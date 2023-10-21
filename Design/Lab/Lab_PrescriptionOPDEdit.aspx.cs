using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
public partial class Design_Lab_Lab_PrescriptionOPDEdit : System.Web.UI.Page
{
    protected void Page_Load()
    {


    }
    [WebMethod(EnableSession = true)]
    public static string UpdatePatientReceipt(PatientData PatientData, List<Patient_Lab_InvestigationOPD> PLO, List<Sample_Barcode> sampledata, List<BookingRequiredField> RequiredField)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (AllLoad_Data.IsInvoiceCreated(con, PatientData.LedgerTransactionID) > 0)
            {
                return JsonConvert.SerializeObject(new { Status = false, response = "Invoice Created, So Edit not Possible" });
            }
            if (PLO.Select(x => x.RequiredAttachment).Count() > 0)
            {
                List<patientDocumentList> reqAttachment = new List<patientDocumentList>();
                foreach (Patient_Lab_InvestigationOPD PLIO in PLO)
                {
                    if (PLIO.RequiredAttachment != string.Empty && PLIO.RequiredAttachment != ",")
                    {
                        if (PLIO.IsPackage == 0)
                        {
                            for (int req = 0; req < PLIO.RequiredAttachment.Split('|').Length; req++)
                            {
                                reqAttachment.Add(new patientDocumentList { DocumentName = PLIO.RequiredAttachment.Split('|')[req] });
                            }
                        }
                        else
                        {
                            if (PLIO.IsPackage == 1)
                            {
                                var requiredAttachment = PLIO.RequiredAttachment.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                                for (int req = 0; req < requiredAttachment.Length; req++)
                                {
                                    if (requiredAttachment[req].Contains("|"))
                                    {
                                        for (int req1 = 0; req1 < requiredAttachment[req].Split('|').Length; req1++)
                                        {
                                            var reqAtt = requiredAttachment[req].Split('|')[req1];
                                            reqAttachment.Add(new patientDocumentList { DocumentName = requiredAttachment[req].Split('|')[req1] });
                                        }
                                    }
                                    else
                                    {
                                        reqAttachment.Add(new patientDocumentList { DocumentName = requiredAttachment[req] });

                                    }
                                }
                            }
                        }
                    }
                }
                reqAttachment = reqAttachment.GroupBy(s => s.DocumentName).Select(g => g.First()).ToList();
                if (reqAttachment.Count > 0)
                {


                    var patientDocumentList = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DocumentName,DocumentID FROM document_detail WHERE PatientID=@PatientID AND IsActive=1",
                          new MySqlParameter("@PatientID", PatientData.Patient_ID)).Tables[0].AsEnumerable().Select(i => new
                          {
                              DocumentID = i.Field<int>("DocumentID"),
                              DocumentName = i.Field<string>("DocumentName")
                          }).ToList();
                    if (reqAttachment.Count(b => b.DocumentName == "Doctor Prescription") > 0 && patientDocumentList.Where(s => s.DocumentName == "Doctor Prescription").Count() == 0)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "Doctor Prescription Required to Attach With Booked Test" });
                    }
                    patientDocumentList = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DocumentName,DocumentID FROM document_detail WHERE PatientID=@PatientID AND IsActive=1 AND DocumentID<>2 UNION ALL SELECT DocumentName,DocumentID FROM document_detail WHERE PatientID=@PatientID AND IsActive=1 ",
                      new MySqlParameter("@PatientID", PatientData.Patient_ID)).Tables[0].AsEnumerable().Select(i => new
                      {
                          DocumentID = i.Field<int>("DocumentID"),
                          DocumentName = i.Field<string>("DocumentName")
                      }).ToList();

                    HashSet<string> reqID = new HashSet<string>(reqAttachment.Select(s => s.DocumentName));
                    if (patientDocumentList.Where(m => reqID.Contains(m.DocumentName) && m.DocumentName != "Doctor Prescription").Count() == 0)
                    {
                      //  tnx.Rollback();
                       // return JsonConvert.SerializeObject(new { status = false, response = string.Concat(string.Join(",", reqAttachment.Select(x => x.DocumentName).Distinct()), " Required to Attach With Booked Test") });
                    }

                    reqAttachment.Clear();
                }
            }

            //if (PatientData.AttachedFileName != string.Empty)
            //{
            //    int filecount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM document_detail WHERE  labNo=@labNo",
            //       new MySqlParameter("@labNo", PatientData.AttachedFileName)));

            //    if (filecount > 0)
            //    {
            //        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE  document_detail SET labNo=@LedgerTransactionNo,PatientID=@PatientID WHERE  labNo=@labNo",
            //             new MySqlParameter("@LedgerTransactionNo", PatientData.LedgerTransactionNo), new MySqlParameter("@labNo", PatientData.AttachedFileName),
            //             new MySqlParameter("@PatientID", PatientData.Patient_ID));
            //    }
            //}


            if (sampledata.Count > 0)
            {
                foreach (Sample_Barcode barcode in sampledata)
                {
                    int a = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM patient_labinvestigation_opd WHERE BarcodeNo=@BarcodeNo AND  LedgerTransactionID<>@LedgerTransactionID AND barcodeNo<>'SNR' AND LedgerTransactionID<>0 ",
                       new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID),
                       new MySqlParameter("@BarcodeNo", barcode.BarcodeNo)));
                    if (a > 0)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Barcode No. Already Exist.Please Change Barcode No. for : ", barcode.InvestigationName) });
                    }
                }
            }

            DataTable dtTemp = new DataTable();
            StringBuilder sb = new StringBuilder();
            DateTime billData = DateTime.Now;
            string Barcode = string.Empty;
            int barcodePreprinted = 0;
            List<string> InvList = new List<string>();
            List<int> PackageItemList = new List<int>();
            List<getItemDetail> ItemIDList = new List<getItemDetail>();
            sb.Append("SELECT ist.SampleTypeID SampleType,plo.SubCategoryID,plo.BarcodeNo");
            sb.Append("  FROM `patient_labinvestigation_opd` plo");
            sb.Append(" Left JOIN  `investigations_sampletype` ist  on");
            sb.Append("  plo.`Investigation_ID`=ist.`Investigation_ID`  AND ist.`IsDefault`=1 where  plo.`LedgerTransactionID`=@LedgerTransactionID and plo.BarcodeNo<>'' AND plo.IsActive=1");
            sb.Append("   GROUP BY ist.SampleTypeID,plo.SubCategoryID,plo.BarcodeNo ");
            using (DataTable dtSample = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID)).Tables[0])
            {
                using (DataTable dtInvList = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT isPackage isPackage,LedgerTransactionID,Test_ID,Investigation_ID,ItemID,DATE_FORMAT(DATE,'%d-%b-%Y %I:%i:%s') PLODate,ItemName,Rate,Amount,DiscountAmt,SubCategoryID,PackageName,PackageCode,ItemCode,IsReporting,BillType FROM patient_labinvestigation_opd WHERE LedgerTransactionID=@LedgerTransactionID AND IsActive=1",
                   new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID)).Tables[0])
                {

                    string BillNo = string.Empty;

                    int DepartmentTokenNo = 0;
                    List<DepartmentTokenNoDetail> DepartmentTokenNoDetail = new List<DepartmentTokenNoDetail>();

                    foreach (Patient_Lab_InvestigationOPD plo in PLO)
                    {
                        string sampleType = string.Empty;
                        if (plo.IsPackage == 0)
                        {



                            if (!InvList.Contains(string.Format("{0}", Util.GetInt(plo.Investigation_ID))))
                            {
                                InvList.Add(Util.GetString(plo.Investigation_ID));
                                ItemIDList.Add(new getItemDetail { ItemID = plo.ItemId, SubcategoryID = plo.SubCategoryID, IsPackage = 0 });
                                dtInvList.AsEnumerable().Where(a => a["Investigation_ID"].ToString().Equals(plo.Investigation_ID)).Count();
                                if (dtInvList.Select(string.Format("Investigation_ID={0}", plo.Investigation_ID)).Length == 0)
                                {
                                    if (plo.DepartmentDisplayName != string.Empty)
                                    {
                                        if (DepartmentTokenNoDetail.Where(s => s.DepartmentDisplayName == plo.DepartmentDisplayName).Count() > 0)
                                        {
                                            DepartmentTokenNo = DepartmentTokenNoDetail.Where(s => s.DepartmentDisplayName == plo.DepartmentDisplayName).Select(s => s.DepartmentTokenNo).First();
                                        }
                                        else
                                        {
                                            DepartmentTokenNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_department_tokenNo(@CentreID,@DepartmentDisplayName,@CreatedDate)",
                                                                                new MySqlParameter("@CentreID", plo.CentreID),
                                                                                new MySqlParameter("@DepartmentDisplayName", plo.DepartmentDisplayName),
                                                                                new MySqlParameter("@CreatedDate", DateTime.Now.ToString("yyyy-MM-dd"))));

                                            DepartmentTokenNoDetail.Add(new DepartmentTokenNoDetail { DepartmentTokenNo = DepartmentTokenNo, DepartmentDisplayName = plo.DepartmentDisplayName });
                                        }
                                    }
                                    else
                                    {
                                        DepartmentTokenNo = 0;
                                    }

                                    sampleType = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT CONCAT(ist.`SampleTypeID`,'#',ist.SampleTypeName) FROM `investigations_sampletype` ist WHERE `Investigation_Id`=@Investigation_ID AND ist.`IsDefault`=1 ",
                                       new MySqlParameter("@Investigation_ID", plo.Investigation_ID)));

                                    if (PatientData.BarCodePrintedType == "System")
                                    {
                                        dtSample.AsEnumerable().Where(a => a["SampleType"].ToString().Equals(sampleType.Split('#')[0]) && a["SubCategoryID"].ToString().Equals(plo.SubCategoryID)).Count();


                                       // if (dtSample.Select(string.Format("BarcodeNo='{0}'", Barcode)).Length == 0)
                                       // {
                                       //     Barcode = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_barcode(@SubCategoryID)",
                                       //        new MySqlParameter("@SubCategoryID", plo.SubCategoryID)).ToString();
                                       //     DataRow dr = dtSample.NewRow();
                                       //     dr["SampleType"] = sampleType.Split('#')[0];
                                       //     dr["SubCategoryID"] = plo.SubCategoryID;
                                       //     dr["BarcodeNo"] = Barcode;
                                        //    dtSample.Rows.Add(dr);
                                        //    dtSample.AcceptChanges();
                                       // }
                                       // else
                                       // {
                                            Barcode = dtSample.Rows[0]["BarcodeNo"].ToString();

                                            sb = new StringBuilder();
                                            sb.Append(" SELECT IsSampleCollected,SampleReceiver,SampleReceivedBy,SampleReceiveDate, ");
                                            sb.Append(" SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,TestCentreID ");
                                            sb.Append("  FROM `patient_labinvestigation_opd` WHERE BarcodeNo=@BarcodeNo LIMIT 1 ");
                                            dtTemp = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                                               new MySqlParameter("@BarcodeNo", Barcode.Trim())).Tables[0];
                                       // }
                                    }
                                    else
                                    {

                                        barcodePreprinted = 1;
                                    }

                                    string PackName = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT IF(im.`SubCategoryID`=15,IF(IFNULL(im.`Inv_ShortName`,'')='',im.`TypeName`,im.`Inv_ShortName`),'')PackName  FROM f_itemmaster im WHERE im.itemid=@ItemID ",
                                       new MySqlParameter("@ItemID", plo.ItemId)));
                                    // float MRP = 0;
                                    //if (Util.GetString(PatientData.PatientType) == "PUP")
                                    //{

                                    //    if (ReferenceCodeOPD == 0)
                                    //        ReferenceCodeOPD = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT PanelID_MRP FROM f_panel_master WHERE Panel_ID=@Panel_ID  AND IsActive=1",
                                    //           new MySqlParameter("@Panel_ID", PatientData.Panel_ID)));

                                    //    string Rate = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT get_item_rate(@ItemId,@ReferenceCodeOPD,@PLODate,@Panel_ID)",
                                    //       new MySqlParameter("@ItemId", plo.ItemId),
                                    //       new MySqlParameter("@ReferenceCodeOPD", ReferenceCodeOPD),
                                    //       new MySqlParameter("@PLODate", Util.GetDateTime(dtInvList.Rows[0]["PLODate"]).ToString("yyyy-MM-dd")),
                                    //       new MySqlParameter("@Panel_ID", PatientData.Panel_ID)));
                                    //    MRP = Util.GetFloat(Rate.Split('#')[0]);
                                    //}


                                    Patient_Lab_InvestigationOPD objPlo = new Patient_Lab_InvestigationOPD(tnx);
                                    objPlo.LedgerTransactionID = PatientData.LedgerTransactionID;
                                    objPlo.LedgerTransactionNo = PatientData.LedgerTransactionNo;
                                    objPlo.Patient_ID = PatientData.Patient_ID;
                                    objPlo.AgeInDays = PatientData.AgeInDays;
                                    objPlo.Gender = PatientData.Gender;

                                    if (barcodePreprinted == 1)
                                    {

                                        try
                                        {
                                            if (sampledata.Count > 0)
                                            {
                                                objPlo.BarcodeNo = sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).BarcodeNo;
                                                if (objPlo.BarcodeNo != string.Empty && sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).IsSNR == 0)
                                                {
                                                    objPlo.IsSampleCollected = "S";

                                                }
                                                else
                                                {
                                                    objPlo.IsSampleCollected = "N";
                                                }
                                            }
                                            else
                                            {
                                                objPlo.BarcodeNo = string.Empty;
                                            }
                                        }
                                        catch
                                        {
                                            objPlo.BarcodeNo = "SNR";
                                        }
                                    }
                                    else
                                    {
                                        objPlo.BarcodeNo = Barcode;

                                    }
                                    objPlo.ItemId = plo.ItemId;
                                    objPlo.ItemCode = plo.ItemCode.ToUpper();
                                    objPlo.ItemName = plo.ItemName.ToUpper();
                                    objPlo.PackageName = PackName.ToUpper();
                                    objPlo.PackageCode = plo.PackageCode;
                                    objPlo.Investigation_ID = plo.Investigation_ID;
                                    objPlo.IsPackage = plo.IsPackage;
                                    objPlo.SubCategoryID = plo.SubCategoryID;
                                    objPlo.Rate = plo.Rate;
                                    objPlo.Amount = plo.Amount;
                                    objPlo.DiscountAmt = plo.DiscountAmt;
                                    objPlo.PayByPanel = plo.PayByPanel;
                                    objPlo.PayByPatient = plo.PayByPatient;
                                    objPlo.PayByPanelPercentage = plo.PayByPanelPercentage;
                                    objPlo.DiscountByLab = plo.DiscountByLab;
                                    objPlo.Quantity = plo.Quantity;
                                    objPlo.IsRefund = plo.IsRefund;
                                    objPlo.IsReporting = plo.IsReporting;
                                    objPlo.ReportType = plo.ReportType;
                                    objPlo.CentreID = plo.CentreID;
                                    objPlo.TestCentreID = plo.TestCentreID;
                                    objPlo.IsSampleCollected = plo.IsSampleCollected;
                                    objPlo.SampleBySelf = plo.SampleBySelf;
                                    objPlo.isUrgent = plo.isUrgent;
                                    objPlo.DeliveryDate = plo.DeliveryDate;
                                    objPlo.SRADate = plo.SRADate;

                                    objPlo.barcodePreprinted = Util.GetByte(barcodePreprinted);

                                    try
                                    {
                                        if (objPlo.barcodePreprinted == 1)
                                        {
                                            objPlo.SampleTypeID = sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).SampleTypeID;
                                            objPlo.SampleTypeName = sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).SampleTypeName;
                                            if (sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).IsSNR == 1 || sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).BarcodeNo == string.Empty)
                                            {
                                                objPlo.IsSampleCollected = "N";
                                            }
                                            else
                                            {
                                                objPlo.IsSampleCollected = "S";
                                            }
                                        }
                                        else
                                        {
                                            objPlo.SampleTypeID = Util.GetInt(sampleType.Split('#')[0]);
                                            objPlo.SampleTypeName = sampleType.Split('#')[1];
                                        }

                                    }
                                    catch
                                    {
                                        objPlo.IsSampleCollected = plo.IsSampleCollected;
                                    }
                                    if (objPlo.IsSampleCollected == "S")
                                    {
                                        objPlo.SampleCollector = UserInfo.LoginName;
                                        objPlo.SampleCollectionBy = UserInfo.ID;
                                        if (PatientData.VisitType == "Home Collection")
                                        {
                                            objPlo.SampleCollectionDate = Util.GetDateTime(plo.SampleCollectionDate);
                                        }
                                        else
                                        {
                                            objPlo.SampleCollectionDate = Util.GetDateTime(DateTime.Now);
                                        }
                                    }
                                    objPlo.SampleBySelf = plo.SampleBySelf;
                                    objPlo.isUrgent = plo.isUrgent;
                                    objPlo.DeliveryDate = plo.DeliveryDate;
                                    objPlo.SRADate = plo.SRADate;

                                    objPlo.IsScheduleRate = plo.IsScheduleRate;
                                    objPlo.MRP = plo.MRP == 0 ? plo.Rate : plo.MRP;
                                    objPlo.Date = billData;
                                    objPlo.PanelItemCode = plo.PanelItemCode;


                                    if (objPlo.ReportType == 5)
                                    {
                                        objPlo.IsSampleCollected = "Y";
                                        objPlo.TestCentreID = objPlo.CentreID;
                                        objPlo.SampleCollectionDate = billData;
                                        objPlo.SampleCollector = UserInfo.LoginName;
                                        objPlo.SampleCollectionBy = UserInfo.ID;

                                    }
                                    if (BillNo == string.Empty)
                                    {
                                        BillNo = AllLoad_Data.getBillNo(PatientData.CentreID, "C", con, tnx); ;
                                    }
                                    if (BillNo == string.Empty)
                                    {
                                        tnx.Rollback();
                                        return JsonConvert.SerializeObject(new { status = false, response = "BillNo Error" });
                                    }
                                    objPlo.BillNo = BillNo;
                                    objPlo.BillType = "Credit-Test Added";
                                    objPlo.IsActive = 1;
                                    objPlo.CreatedBy = UserInfo.LoginName;
                                    objPlo.CreatedByID = UserInfo.ID;
                                    objPlo.BaseCurrencyRound = Util.GetByte(Resources.Resource.BaseCurrencyRound);
                                    objPlo.DepartmentTokenNo = DepartmentTokenNo;
                                    objPlo.SubCategoryName = plo.SubCategoryName;
                                    string ID = objPlo.Insert();

                                    if (ID == string.Empty)
                                    {
                                        tnx.Rollback();
                                        return JsonConvert.SerializeObject(new { status = false, response = "PLO Error" });

                                    }
                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode,@LedgerTransactionID) ",
                                      new MySqlParameter("@LedgertransactionNo", PatientData.LedgerTransactionNo),
                                      new MySqlParameter("@SinNo", Barcode),
                                      new MySqlParameter("@Test_ID", ID),
                                      new MySqlParameter("@Status", string.Format("Added New Item ({0})", plo.ItemName.ToUpper())),
                                      new MySqlParameter("@UserID", UserInfo.ID),
                                      new MySqlParameter("@UserName", UserInfo.LoginName),
                                      new MySqlParameter("@IpAddress", StockReports.getip()),
                                      new MySqlParameter("@CentreID", PatientData.CentreID),
                                      new MySqlParameter("@RoleID", UserInfo.RoleID),
                                      new MySqlParameter("@DispatchCode", string.Empty),
                                      new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID));
                                    if (objPlo.IsSampleCollected == "S")
                                    {
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode,@LedgerTransactionID) ",
                                                      new MySqlParameter("@LedgertransactionNo", PatientData.LedgerTransactionNo),
                                                      new MySqlParameter("@SinNo", Barcode),
                                                      new MySqlParameter("@Test_ID", ID),
                                                      new MySqlParameter("@Status", string.Format("Sample Collected ({0})", plo.ItemName.ToUpper())),
                                                      new MySqlParameter("@UserID", UserInfo.ID),
                                                      new MySqlParameter("@UserName", UserInfo.LoginName),
                                                      new MySqlParameter("@IpAddress", StockReports.getip()),
                                                      new MySqlParameter("@CentreID", PatientData.CentreID),
                                                      new MySqlParameter("@RoleID", UserInfo.RoleID),
                                                      new MySqlParameter("@DispatchCode", string.Empty),
                                                      new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID));


                                        if (Resources.Resource.SRARequired == "0")
                                        {
                                            sb = new StringBuilder();
                                            sb.Append("INSERT INTO sample_logistic(BarcodeNo,Barcode_Group,FromCentreID,ToCentreID,DispatchCode,Qty,EntryBy,`Status`,dtLogisticReceive,LogisticReceiveDate,LogisticReceiveBy,testID) ");
                                            sb.Append(" values(@BarcodeNo,@BarcodeNo,@FromCentreID,@ToCentreID,@DispatchCode,@Qty,@EntryBy,@STATUS,@dtLogisticReceive,@LogisticReceiveDate,@LogisticReceiveBy,@Test_ID);");

                                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                new MySqlParameter("@BarcodeNo", objPlo.BarcodeNo),
                                                new MySqlParameter("@FromCentreID", UserInfo.Centre),
                                                new MySqlParameter("@ToCentreID", UserInfo.Centre),
                                                new MySqlParameter("@DispatchCode", string.Empty),
                                                new MySqlParameter("@Qty", 1),
                                                new MySqlParameter("@EntryBy", UserInfo.ID),
                                                new MySqlParameter("@STATUS", "Received"),
                                                new MySqlParameter("@dtLogisticReceive", DateTime.Now),
                                                new MySqlParameter("@LogisticReceiveDate", DateTime.Now),
                                                new MySqlParameter("@LogisticReceiveBy", UserInfo.ID),
                                                new MySqlParameter("@Test_ID", ID));


                                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode,@LedgerTransactionID) ",
                                                   new MySqlParameter("@LedgertransactionNo", PatientData.LedgerTransactionNo),
                                                   new MySqlParameter("@SinNo", objPlo.BarcodeNo),
                                                   new MySqlParameter("@Test_ID", ID),
                                                   new MySqlParameter("@Status", string.Format("SIN No. {0} {1}", objPlo.BarcodeNo, "Received")),
                                                   new MySqlParameter("@UserID", UserInfo.ID),
                                                   new MySqlParameter("@UserName", UserInfo.LoginName),
                                                   new MySqlParameter("@IpAddress", StockReports.getip()),
                                                   new MySqlParameter("@CentreID", UserInfo.Centre),
                                                   new MySqlParameter("@RoleID", UserInfo.RoleID),
                                                   new MySqlParameter("@DispatchCode", string.Empty),
                                                   new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID),
                                                   new MySqlParameter("@dtEntry", billData));

                                        }
                                    }

                                    if (dtTemp.Rows.Count > 0)
                                    {
                                        sb = new StringBuilder();
                                        sb.Append(" Update patient_labinvestigation_opd ");
                                        sb.Append(" SET IsSampleCollected=@IsSampleCollected,SampleReceiver=@SampleReceiver,SampleReceivedBy=@SampleReceivedBy, ");
                                        sb.Append(" SampleReceiveDate=@SampleReceiveDate,SampleBySelf=@SampleBySelf,SampleCollectionBy=@SampleCollectionBy,  ");
                                        sb.Append(" SampleCollector=@SampleCollector,SampleCollectionDate=@SampleCollectionDate,TestCentreID=@TestCentreID ");
                                        sb.Append(" WHERE BarCodeno=@BarCodeno AND Test_ID=@Test_ID ");
                                   //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                   //        new MySqlParameter("@IsSampleCollected", Util.GetString(dtTemp.Rows[0]["IsSampleCollected"])),
                                   //        new MySqlParameter("@SampleReceiver", Util.GetString(dtTemp.Rows[0]["SampleReceiver"])),
                                   //        new MySqlParameter("@SampleReceivedBy", Util.GetInt(dtTemp.Rows[0]["SampleReceivedBy"])),
                                   //        new MySqlParameter("@SampleReceiveDate", Convert.ToDateTime(Util.GetDateTime(dtTemp.Rows[0]["SampleReceiveDate"])).ToString("yyyy-MM-dd HH:mm:ss")),
                                   //        new MySqlParameter("@SampleBySelf", Util.GetInt(dtTemp.Rows[0]["SampleBySelf"])),
                                   //        new MySqlParameter("@SampleCollectionBy", Util.GetInt(dtTemp.Rows[0]["SampleCollectionBy"])),
                                   //        new MySqlParameter("@SampleCollector", Util.GetString(dtTemp.Rows[0]["SampleCollector"])),
                                   //        new MySqlParameter("@SampleCollectionDate", Convert.ToDateTime(Util.GetDateTime(dtTemp.Rows[0]["SampleCollectionDate"])).ToString("yyyy-MM-dd HH:mm:ss")),
                                   //        new MySqlParameter("@TestCentreID", Util.GetInt(dtTemp.Rows[0]["TestCentreID"])),
                                   //        new MySqlParameter("@BarCodeno", Barcode.Trim()),
                                   //        new MySqlParameter("@Test_ID", ID.Trim()));

                                        dtTemp.Rows.Clear();
                                    }
                                }
                                else
                                {
                                    var testDetailsRow = dtInvList.AsEnumerable().Where(a => a.Field<int>("Investigation_ID").Equals(plo.Investigation_ID) && a.Field<sbyte>("isPackage") == 1);



                                    if (testDetailsRow.Count() > 0)
                                    {
                                        using (DataTable testDetail = testDetailsRow.CopyToDataTable())
                                        {
                                            if (testDetail.Rows.Count > 0)
                                            {
                                                if (BillNo == string.Empty)
                                                {
                                                    BillNo = AllLoad_Data.getBillNo(PatientData.CentreID, "C", con, tnx); ;
                                                }
                                                if (BillNo == string.Empty)
                                                {
                                                    tnx.Rollback();
                                                    return JsonConvert.SerializeObject(new { status = false, response = "BillNo Error" });
                                                }

                                                sb = new StringBuilder();
                                                sb.Append(" UPDATE patient_labinvestigation_opd SET Test_ID=@Test_ID,IsRefund=1,IsReporting=0 WHERE Test_ID=@TestID");
                                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                    new MySqlParameter("@Test_ID", Util.GetInt(testDetail.Rows[0]["Test_ID"].ToString()) * -1),
                                                    new MySqlParameter("@TestID", testDetail.Rows[0]["Test_ID"].ToString()));

                                                sb = new StringBuilder();
                                                sb.Append(" INSERT INTO patient_labinvestigation_opd(Test_ID,LedgerTransactionID,LedgerTransactionNo,BillNo,BarcodeNo,ItemId,ItemName,Investigation_ID,IsPackage,Date,SubCategoryID,SubCategoryName,Rate,");
                                                sb.Append(" Amount,DiscountAmt,PayByPanel,PayByPanelPercentage,PayByPatient,CouponAmt,Quantity,DiscountByLab,IsRefund,IsReporting,IsActive,BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                                                sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                                                sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                                                sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                                                sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                                                sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                                                sb.Append(" SampleTypeID,SampleTypeName,SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                                                sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                                                sb.Append(" CurrentSampleDept,ToSampleDept,UpdateID,UpdateName,UpdateRemarks,ipAddress,");
                                                sb.Append(" Barcode_Group,IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                                                sb.Append(" PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                                                sb.Append(" MachineID_Manual,IsScheduleRate,MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                                                sb.Append(" PackageMRPPercentage,PackageMRPNet,ItemCode,SRADate,CreatedBy,CreatedByID,BaseCurrencyRound,DepartmentTokenNo) ");
                                                sb.Append(" ");
                                                sb.Append(" SELECT @Test_ID,@LedgerTransactionID,LedgerTransactionNo,@BillNo,BarcodeNo,@ItemId,@ItemName,Investigation_ID,0 IsPackage,@BillDate,SubCategoryID,@SubCategoryName,@Rate,");
                                                sb.Append(" @Amount,0 DiscountAmt,@PayByPanel,@PayByPanelPercentage,@PayByPatient,CouponAmt,Quantity,DiscountByLab,0,1,1,@BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                                                sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                                                sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                                                sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                                                sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                                                sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                                                sb.Append(" 0,'',SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                                                sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                                                sb.Append(" CurrentSampleDept,ToSampleDept,0,'','',@ipAddress,");
                                                sb.Append(" '',IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                                                sb.Append(" '' PackageName,'' PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                                                sb.Append(" MachineID_Manual,IsScheduleRate,@MRP,0 PackageRate,HoldType,@PanelItemCode,0 PackageMRP,");
                                                sb.Append(" 0 PackageMRPPercentage,0 PackageMRPNet,@ItemCode,SRADate,@CreatedBy,@CreatedByID,BaseCurrencyRound,DepartmentTokenNo ");
                                                sb.Append(" FROM patient_labinvestigation_opd WHERE Test_ID=@TestID AND IsActive=1");
                                                int count = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                    new MySqlParameter("@Test_ID", testDetail.Rows[0]["Test_ID"].ToString()),
                                                    new MySqlParameter("@TestID", Util.GetInt(testDetail.Rows[0]["Test_ID"].ToString()) * -1),
                                                    new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID),
                                                    new MySqlParameter("@Rate", plo.Rate),
                                                    new MySqlParameter("@Amount", plo.Amount),
                                                    new MySqlParameter("@SubCategoryName", plo.SubCategoryName),
                                                    new MySqlParameter("@ipAddress", StockReports.getip()),
                                                    new MySqlParameter("@PayByPanelPercentage", plo.PayByPanelPercentage),
                                                    new MySqlParameter("@PayByPanel", plo.PayByPanel),
                                                    new MySqlParameter("@PayByPatient", plo.PayByPatient),
                                                    new MySqlParameter("@ItemCode", plo.ItemCode),
                                                    new MySqlParameter("@ItemName", plo.ItemName),
                                                    new MySqlParameter("@ItemId", plo.ItemId),
                                                    new MySqlParameter("@BillNo", BillNo),
                                                    new MySqlParameter("@BillDate", billData),
                                                    new MySqlParameter("@BillType", "Credit-Test Added"),
                                                    new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                                                    new MySqlParameter("@CreatedByID", UserInfo.ID),
                                                    new MySqlParameter("@PanelItemCode", plo.PanelItemCode),
                                                    new MySqlParameter("@MRP", plo.MRP));


                                                sb = new StringBuilder();
                                                sb.Append(" UPDATE patient_labinvestigation_opd SET IsActive=0 WHERE Test_ID=@Test_ID");
                                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                    new MySqlParameter("@Test_ID", Util.GetInt(testDetail.Rows[0]["Test_ID"].ToString()) * -1));
                                            }

                                        }
                                    }

                                }
                            }
                        }
                        // IsPackage Condition Start
                        else
                        {
                            if (dtInvList.Select(string.Format("ItemID={0}", plo.ItemId)).Length == 0)
                            {
                                PackageItemList.Add(plo.ItemId);
                                ItemIDList.Add(new getItemDetail { ItemID = plo.ItemId, SubcategoryID = plo.SubCategoryID, IsPackage = 1 });

                                sampleType = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT CONCAT(ist.`SampleTypeID`,'#',ist.SampleTypeName) FROM `investigations_sampletype` ist where `Investigation_Id`=@Investigation_Id AND ist.`IsDefault`=1 ",
                                   new MySqlParameter("@Investigation_Id", plo.SubCategoryID)));

                                if (PatientData.BarCodePrintedType == "System")
                                {
                                    barcodePreprinted = 0;

                                    if (plo.IsPackage == 0)
                                    {
                                       // if (dtSample.Select(string.Format("BarcodeNo='{0}'", Barcode)).Length == 0)
                                       // {
                                       //     Barcode = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_barcode(@SubCategoryID)",
                                       //        new MySqlParameter("@SubCategoryID", plo.SubCategoryID)).ToString();
                                       //     DataRow dr = dtSample.NewRow();
                                       //     dr["SampleType"] = sampleType.Split('#')[0];
                                       //     dr["SubCategoryID"] = plo.SubCategoryID;
                                       //     dr["BarcodeNo"] = Barcode;
                                       //     dtSample.Rows.Add(dr);
                                       //     dtSample.AcceptChanges();

                                       // }
                                       // else
                                       // {
                                            Barcode = dtSample.Rows[0]["BarcodeNo"].ToString();

                                            sb = new StringBuilder();
                                            sb.Append(" SELECT IsSampleCollected,SampleReceiver,SampleReceivedBy,SampleReceiveDate, ");
                                            sb.Append(" SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,TestCentreID ");
                                            sb.Append("  FROM `patient_labinvestigation_opd` WHERE BarcodeNo=@BarcodeNo LIMIT 1 ");
                                            dtTemp = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                                               new MySqlParameter("@BarcodeNo", Barcode.Trim())).Tables[0];
                                       // }
                                    }
                                }
                                else
                                {

                                    barcodePreprinted = 1;

                                }
                                if (plo.DepartmentDisplayName != string.Empty && plo.IsPackage == 0)
                                {
                                    if (DepartmentTokenNoDetail.Where(s => s.DepartmentDisplayName == plo.DepartmentDisplayName).Count() > 0)
                                    {
                                        DepartmentTokenNo = DepartmentTokenNoDetail.Where(s => s.DepartmentDisplayName == plo.DepartmentDisplayName).Select(s => s.DepartmentTokenNo).First();
                                    }
                                    else
                                    {
                                        DepartmentTokenNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_department_tokenNo(@CentreID,@DepartmentDisplayName,@CreatedDate)",
                                                                            new MySqlParameter("@CentreID", plo.CentreID),
                                                                            new MySqlParameter("@DepartmentDisplayName", plo.DepartmentDisplayName),
                                                                            new MySqlParameter("@CreatedDate", DateTime.Now.ToString("yyyy-MM-dd"))));

                                        DepartmentTokenNoDetail.Add(new DepartmentTokenNoDetail { DepartmentTokenNo = DepartmentTokenNo, DepartmentDisplayName = plo.DepartmentDisplayName });
                                    }
                                }
                                else
                                {
                                    DepartmentTokenNo = 0;
                                }
                                string PackName = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT IF(im.`SubCategoryID`=15,IF(IFNULL(im.`Inv_ShortName`,'')='',im.`TypeName`,im.`Inv_ShortName`),'')PackName  FROM f_itemmaster im WHERE im.itemid=@ItemID ",
                                   new MySqlParameter("@ItemID", plo.ItemId)));

                                Patient_Lab_InvestigationOPD objPlo = new Patient_Lab_InvestigationOPD(tnx);
                                objPlo.LedgerTransactionID = PatientData.LedgerTransactionID;
                                objPlo.LedgerTransactionNo = PatientData.LedgerTransactionNo;
                                objPlo.Patient_ID = PatientData.Patient_ID;
                                objPlo.AgeInDays = Util.GetInt(PatientData.AgeInDays);
                                objPlo.Gender = PatientData.Gender;
                                if (plo.IsPackage == 0)
                                {
                                    if (barcodePreprinted == 1)
                                    {
                                        try
                                        {
                                            if (sampledata.Count > 0)
                                                objPlo.BarcodeNo = sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).BarcodeNo;
                                            else
                                                objPlo.BarcodeNo = string.Empty;
                                        }
                                        catch
                                        {
                                            objPlo.BarcodeNo = "SNR";
                                        }
                                    }
                                    else
                                    {
                                        objPlo.BarcodeNo = Barcode;
                                    }
                                }
                                else
                                {
                                    objPlo.BarcodeNo = string.Empty;
                                }
                                objPlo.ItemId = plo.ItemId;
                                objPlo.ItemCode = plo.ItemCode.ToUpper();
                                objPlo.ItemName = plo.ItemName.ToUpper();
                                objPlo.PackageName = PackName.ToUpper();
                                objPlo.PackageCode = plo.PackageCode;
                                objPlo.Investigation_ID = plo.Investigation_ID;
                                objPlo.IsPackage = plo.IsPackage;
                                objPlo.MRP = plo.MRP == 0 ? plo.Rate : plo.MRP;
                                objPlo.SubCategoryID = plo.SubCategoryID;
                                objPlo.Rate = plo.Rate;
                                objPlo.Amount = plo.Amount;
                                objPlo.DiscountAmt = plo.DiscountAmt;
                                objPlo.DiscountByLab = plo.DiscountByLab;
                                objPlo.PayByPanel = 0;
                                objPlo.PayByPanelPercentage = 0;
                                objPlo.PayByPatient = 0;

                                objPlo.Quantity = plo.Quantity;
                                objPlo.IsRefund = plo.IsRefund;
                                objPlo.IsReporting = plo.IsReporting;
                                objPlo.ReportType = plo.ReportType;
                                objPlo.CentreID = plo.CentreID;
                                objPlo.TestCentreID = plo.TestCentreID;
                                objPlo.IsSampleCollected = plo.IsSampleCollected;
                                objPlo.SampleBySelf = plo.SampleBySelf;
                                objPlo.isUrgent = plo.isUrgent;
                                objPlo.DeliveryDate = plo.DeliveryDate;
                                objPlo.SRADate = plo.SRADate;

                                objPlo.barcodePreprinted = Util.GetByte(barcodePreprinted);

                                try
                                {
                                    if (objPlo.barcodePreprinted == 1 && sampledata.Count > 0)
                                    {
                                        objPlo.SampleTypeID = sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).SampleTypeID;
                                        objPlo.SampleTypeName = sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).SampleTypeName;
                                    }
                                    else
                                    {
                                        objPlo.SampleTypeID = Util.GetInt(sampleType.Split('#')[0]);
                                        objPlo.SampleTypeName = sampleType.Split('#')[1];
                                    }
                                }
                                catch
                                {
                                    objPlo.SampleTypeID = 0;
                                    objPlo.SampleTypeName = string.Empty;
                                }
                                if (objPlo.IsSampleCollected == "S")
                                {
                                    objPlo.SampleCollector = UserInfo.LoginName;
                                    objPlo.SampleCollectionBy = UserInfo.ID;
                                    if (plo.BarcodeNo != string.Empty && plo.BarcodeNo != null)
                                    {
                                        objPlo.SampleCollectionDate = Util.GetDateTime(plo.SampleCollectionDate);
                                    }
                                    else
                                    {
                                        objPlo.SampleCollectionDate = billData;
                                    }
                                }
                                objPlo.Date = billData;
                                objPlo.SampleBySelf = plo.SampleBySelf;
                                objPlo.isUrgent = plo.isUrgent;
                                objPlo.DeliveryDate = plo.DeliveryDate;
                                objPlo.SRADate = plo.SRADate;
								 if (objPlo.ReportType == 5 )
                                {
                                    objPlo.IsSampleCollected = "Y";
                                    objPlo.TestCentreID = objPlo.CentreID;
                                    objPlo.SampleCollectionDate = billData;
                                    objPlo.SampleCollector = UserInfo.LoginName;
                                    objPlo.SampleCollectionBy = UserInfo.ID;

                                }
                                if (BillNo == string.Empty)
                                {
                                    BillNo = AllLoad_Data.getBillNo(PatientData.CentreID, "C", con, tnx); ;
                                }
                                if (BillNo == string.Empty)
                                {
                                    tnx.Rollback();
                                    return JsonConvert.SerializeObject(new { status = false, response = "BillNo Error" });
                                }

                                objPlo.BillNo = BillNo;
                                objPlo.BillType = "Credit-Test Added";
                                objPlo.IsActive = 1;
                                objPlo.CreatedBy = UserInfo.LoginName;
                                objPlo.CreatedByID = UserInfo.ID;
                                objPlo.BaseCurrencyRound = Util.GetByte(Resources.Resource.BaseCurrencyRound);
                                objPlo.DepartmentTokenNo = DepartmentTokenNo;
                                objPlo.SubCategoryName = "PACKAGE";
                                string ID = objPlo.Insert();

                                if (ID == string.Empty)
                                {
                                    tnx.Rollback();
                                    return JsonConvert.SerializeObject(new { status = false, response = "PLO Error" });


                                }
                                barcodePreprinted = 0;
                                sb = new StringBuilder();
                                sb.Append(" SELECT imm.`Name` ,imm.`Investigation_Id`,imm.`Type` sampleData,imm.`Reporting`,imm.`ReportType`,");
                                sb.Append(" Get_DeliveryDate(@Centre,imm.Investigation_ID,now())DeliveryDate, ");
                                sb.Append(" (SELECT IFNULL(DisplayName,'')DisplayName FROM f_itemmaster fim INNER JOIN f_subcategorymaster sb ON sb.subcategoryid=fim.subcategoryid WHERE type_id=imm.`Investigation_Id`  LIMIT 1) DepartmentDisplayName, ");
                                sb.Append(" (SELECT IFNULL(Name,'')SubCategoryName FROM f_itemmaster fim INNER JOIN f_subcategorymaster sb ON sb.subcategoryid=fim.subcategoryid WHERE type_id=imm.`Investigation_Id`  LIMIT 1) SubCategoryName, ");
                                sb.Append(" (SELECT `SubCategoryID` FROM f_itemmaster WHERE type_id=imm.`Investigation_Id`  LIMIT 1)SubCategoryID,imm.TestCode ");
                                sb.Append("     ,UPPER(IF(IFNULL(im.`Inv_ShortName`,'')='',im.`TypeName`,im.`Inv_ShortName`))PackName  ");
                                sb.Append("   FROM f_itemmaster im  ");
                                sb.Append("   INNER JOIN package_labdetail pld  ON pld.PlabID=im.Type_ID   ");
                                sb.Append("   INNER JOIN investigation_master imm  ON imm.Investigation_Id=pld.InvestigationID ");
                                sb.Append("   AND  im.`ItemID`=@ItemId ");

                                using (DataTable dtpackinfo = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                                      new MySqlParameter("@ItemId", plo.ItemId),
                                      new MySqlParameter("@Centre", UserInfo.Centre)).Tables[0])
                                {
                                    decimal totalpackagemrp = 0;
                                    List<string> pacitem = new List<string>();
                                    foreach (DataRow dw in dtpackinfo.Rows)
                                    {
                                        pacitem.Add(dw["Investigation_Id"].ToString());
                                    }
                                    string[] pacitemTags = String.Join(",", pacitem).Split(',');
                                    string[] pacitemParamNames = pacitemTags.Select((s, i) => "@tag" + i).ToArray();
                                    string pacitemClause = string.Join(", ", pacitemParamNames);

                                    pacitem.Clear();
                                    sb = new StringBuilder();
                                    sb.Append("SELECT SUM(rate) FROM f_ratelist WHERE ItemID in({0}) AND panel_id=(SELECT `ReferenceCodeOPD` ");
                                    sb.Append(" FROM f_panel_master WHERE centreID=@CentreID AND panelType='Centre')");

                                    using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), pacitemClause), con))
                                    {
                                        for (int i = 0; i < pacitemParamNames.Length; i++)
                                        {
                                            cmd.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                                        }
                                        cmd.Parameters.AddWithValue("@CentreID", PatientData.CentreID);
                                        totalpackagemrp = Util.GetDecimal(cmd.ExecuteScalar());
                                    }

                                    foreach (DataRow dw in dtpackinfo.Rows)
                                    {

                                        sampleType = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT CONCAT(ist.`SampleTypeID`,'#',ist.SampleTypeName) FROM `investigations_sampletype` ist where `Investigation_Id`=@Investigation_Id AND ist.`IsDefault`=1 ",
                                           new MySqlParameter("@Investigation_Id", dw["Investigation_Id"].ToString())));

                                        if (PatientData.BarCodePrintedType == "System")
                                        {
                                            barcodePreprinted = 0;

                                           // if (dtSample.Select(string.Format("BarcodeNo='{0}'", Barcode)).Length == 0)
                                           // {
                                            //    Barcode = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_barcode(@SubCategoryID)",
                                            //       new MySqlParameter("@SubCategoryID", dw["SubcategoryID"].ToString())).ToString();
                                            //    DataRow dr = dtSample.NewRow();
                                            //    dr["SampleType"] = sampleType.Split('#')[0];
                                            //    dr["SubCategoryID"] = dw["SubCategoryID"].ToString();
                                             //   dr["BarcodeNo"] = Barcode;
                                             //   dtSample.Rows.Add(dr);
                                             //   dtSample.AcceptChanges();

                                           // }
                                           // else
                                           // {
                                                Barcode = dtSample.Rows[0]["BarcodeNo"].ToString();

                                                sb = new StringBuilder();
                                                sb.Append(" Select IsSampleCollected,SampleReceiver,SampleReceivedBy,SampleReceiveDate, ");
                                                sb.Append(" SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,TestCentreID ");
                                                sb.Append("  FROM `patient_labinvestigation_opd` where BarcodeNo=@BarcodeNo limit 1 ");
                                                dtTemp = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                                                   new MySqlParameter("@BarcodeNo", Barcode.Trim())).Tables[0];
                                           // }
                                        }

                                        else
                                        {

                                            barcodePreprinted = 1;
                                        }
                                        if (!InvList.Contains(string.Format("{0}", Util.GetInt(dw["Investigation_id"].ToString()))))
                                        {

                                            InvList.Add(Util.GetString(dw["Investigation_id"]));
                                            if (dtInvList.Select(string.Format("Investigation_ID={0}", Util.GetString(dw["Investigation_id"]))).Length == 0)
                                            {
                                                if (Util.GetString(dw["DepartmentDisplayName"]).ToString() != string.Empty)
                                                {
                                                    if (DepartmentTokenNoDetail.Where(s => s.DepartmentDisplayName == Util.GetString(dw["DepartmentDisplayName"])).Count() > 0)
                                                    {
                                                        DepartmentTokenNo = DepartmentTokenNoDetail.Where(s => s.DepartmentDisplayName == Util.GetString(dw["DepartmentDisplayName"])).Select(s => s.DepartmentTokenNo).First();
                                                    }
                                                    else
                                                    {
                                                        DepartmentTokenNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_department_tokenNo(@CentreID,@DepartmentDisplayName,@CreatedDate)",
                                                                                            new MySqlParameter("@CentreID", plo.CentreID),
                                                                                            new MySqlParameter("@DepartmentDisplayName", dw["DepartmentDisplayName"]),
                                                                                            new MySqlParameter("@CreatedDate", DateTime.Now.ToString("yyyy-MM-dd"))));

                                                        DepartmentTokenNoDetail.Add(new DepartmentTokenNoDetail { DepartmentTokenNo = DepartmentTokenNo, DepartmentDisplayName = Util.GetString(dw["DepartmentDisplayName"]) });
                                                    }
                                                }
                                                else
                                                {
                                                    DepartmentTokenNo = 0;
                                                }

                                                objPlo = new Patient_Lab_InvestigationOPD(tnx);
                                                objPlo.LedgerTransactionID = PatientData.LedgerTransactionID;
                                                objPlo.LedgerTransactionNo = PatientData.LedgerTransactionNo;
                                                objPlo.Patient_ID = PatientData.Patient_ID;
                                                objPlo.AgeInDays = Util.GetInt(PatientData.AgeInDays);
                                                objPlo.Gender = PatientData.Gender;
                                                if (barcodePreprinted == 1)
                                                {
                                                    try
                                                    {
                                                        if (sampledata.Count > 0)
                                                            objPlo.BarcodeNo = sampledata.FirstOrDefault(p => p.InvestigationID == Util.GetInt(dw["Investigation_Id"].ToString())).BarcodeNo;
                                                        else
                                                            objPlo.BarcodeNo = string.Empty;
                                                    }
                                                    catch
                                                    {
                                                        objPlo.BarcodeNo = "SNR";
                                                    }
                                                }
                                                else
                                                {
                                                    objPlo.BarcodeNo = Barcode;
                                                }
                                                objPlo.ItemId = plo.ItemId;
                                                objPlo.ItemCode = dw["TestCode"].ToString().ToUpper();
                                                objPlo.ItemName = dw["name"].ToString().ToUpper();
                                                objPlo.PackageName = dw["PackName"].ToString();
                                                objPlo.PackageCode = plo.PackageCode;
                                                objPlo.Investigation_ID = Util.GetInt(dw["Investigation_Id"].ToString());
                                                objPlo.IsPackage = 1;
                                                objPlo.SubCategoryID = Util.GetInt(dw["SubCategoryID"].ToString());
                                                objPlo.Rate = 0;
                                                objPlo.Amount = 0;
                                                objPlo.DiscountAmt = 0;
                                                objPlo.PayByPanel = 0;
                                                objPlo.PayByPanelPercentage = 0;
                                                objPlo.PayByPatient = 0;

                                                objPlo.Quantity = 1;
                                                objPlo.IsRefund = plo.IsRefund;
                                                objPlo.IsReporting = Util.GetByte(dw["Reporting"].ToString());
                                                objPlo.ReportType = Util.GetByte(dw["ReportType"].ToString());
                                                objPlo.CentreID = plo.CentreID;
                                                objPlo.TestCentreID = plo.TestCentreID;
                                                objPlo.IsSampleCollected = plo.IsSampleCollected;
                                                objPlo.SampleBySelf = plo.SampleBySelf;
                                                objPlo.isUrgent = plo.isUrgent;
                                                objPlo.DeliveryDate = plo.DeliveryDate;
                                                objPlo.SRADate = plo.SRADate;

                                                objPlo.barcodePreprinted = Util.GetByte(barcodePreprinted);

                                                if (barcodePreprinted == 1)
                                                {
                                                    if (objPlo.barcodePreprinted == 1 && sampledata.Count > 0)
                                                    {
                                                        objPlo.SampleTypeID = sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).SampleTypeID;
                                                        objPlo.SampleTypeName = sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).SampleTypeName;
                                                    }
                                                    else
                                                    {
                                                        objPlo.SampleTypeID = Util.GetInt(sampleType.Split('#')[0]);
                                                        objPlo.SampleTypeName = sampleType.Split('#')[1];
                                                    }
                                                }

                                                if (objPlo.IsSampleCollected == "S")
                                                {
                                                    objPlo.SampleCollector = UserInfo.LoginName;
                                                    objPlo.SampleCollectionBy = UserInfo.ID;
                                                    if (plo.BarcodeNo != string.Empty && plo.BarcodeNo != null)
                                                    {
                                                        objPlo.SampleCollectionDate = Util.GetDateTime(plo.SampleCollectionDate);
                                                    }
                                                    else
                                                    {
                                                        objPlo.SampleCollectionDate = billData;
                                                    }
                                                }
                                                objPlo.SampleBySelf = plo.SampleBySelf;
                                                objPlo.isUrgent = plo.isUrgent;
                                                objPlo.DeliveryDate = plo.DeliveryDate;
                                                objPlo.SRADate = plo.SRADate;

                                                objPlo.Date = billData;
                                                decimal PackageMRP = 0;// Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT Rate FROM f_ratelist WHERE ItemID=@ItemID AND panel_id=(SELECT `ReferenceCodeOPD` FROM f_panel_master WHERE centreID=@centreID AND panelType='Centre')",
                                                                       //new MySqlParameter("@ItemID", dw["Investigation_Id"].ToString()),
                                                                       //new MySqlParameter("@centreID", PatientData.CentreID)));
                                                decimal PackageMRPPercentage = 0;// (PackageMRP * 100) / totalpackagemrp;
                                                decimal PackageMRPNet = 0;// (Util.GetDecimal(plo.Amount) * PackageMRPPercentage) / 100;
                                                objPlo.PackageMRP = PackageMRP;
                                                objPlo.PackageMRPPercentage = PackageMRPPercentage;
                                                objPlo.PackageMRPNet = PackageMRPNet;
                                                objPlo.BillNo = BillNo;
                                                objPlo.BillType = "Credit-Test Added";
                                                objPlo.IsActive = 1;
                                                objPlo.CreatedBy = UserInfo.LoginName;
                                                objPlo.CreatedByID = UserInfo.ID;
                                                objPlo.BaseCurrencyRound = Util.GetByte(Resources.Resource.BaseCurrencyRound);
                                                objPlo.DepartmentTokenNo = DepartmentTokenNo;
                                                objPlo.SubCategoryName = dw["SubCategoryName"].ToString();
                                                string ID1 = objPlo.Insert();
                                                if (ID1 == string.Empty)
                                                {
                                                    tnx.Rollback();
                                                    return JsonConvert.SerializeObject(new { status = false, response = "PLO Error" });
                                                }
                                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode,@LedgerTransactionID) ",
                                                             new MySqlParameter("@LedgertransactionNo", PatientData.LedgerTransactionNo),
                                                             new MySqlParameter("@SinNo", Barcode), new MySqlParameter("@Test_ID", ID1),
                                                             new MySqlParameter("@Status", string.Format("Added New Item ({0})", objPlo.ItemName.ToUpper())), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                                                             new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", PatientData.CentreID), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@DispatchCode", string.Empty), new MySqlParameter("@dtEntry", billData), new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID));
                                                if (objPlo.IsSampleCollected == "S")
                                                {
                                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode,@LedgerTransactionID) ",
                                                                  new MySqlParameter("@LedgertransactionNo", PatientData.LedgerTransactionNo),
                                                                  new MySqlParameter("@SinNo", Barcode), new MySqlParameter("@Test_ID", ID1),
                                                                  new MySqlParameter("@Status", string.Format("Sample Collected ({0})", objPlo.ItemName.ToUpper())), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                                                                  new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", PatientData.CentreID), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@DispatchCode", string.Empty), new MySqlParameter("@dtEntry", billData), new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID));

                                                    if (Resources.Resource.SRARequired == "0")
                                                    {
                                                        sb = new StringBuilder();
                                                        sb.Append("INSERT INTO sample_logistic(BarcodeNo,Barcode_Group,FromCentreID,ToCentreID,DispatchCode,Qty,EntryBy,`Status`,dtLogisticReceive,LogisticReceiveDate,LogisticReceiveBy,testID) ");
                                                        sb.Append(" values(@BarcodeNo,@BarcodeNo,@FromCentreID,@ToCentreID,@DispatchCode,@Qty,@EntryBy,@STATUS,@dtLogisticReceive,@LogisticReceiveDate,@LogisticReceiveBy,@Test_ID);");

                                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                            new MySqlParameter("@BarcodeNo", objPlo.BarcodeNo),
                                                            new MySqlParameter("@FromCentreID", UserInfo.Centre), new MySqlParameter("@ToCentreID", UserInfo.Centre),
                                                            new MySqlParameter("@DispatchCode", string.Empty), new MySqlParameter("@Qty", 1),
                                                            new MySqlParameter("@EntryBy", UserInfo.ID),
                                                            new MySqlParameter("@STATUS", "Received"), new MySqlParameter("@dtLogisticReceive", billData),
                                                            new MySqlParameter("@LogisticReceiveDate", DateTime.Now), new MySqlParameter("@LogisticReceiveBy", UserInfo.ID),
                                                            new MySqlParameter("@Test_ID", ID1));



                                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode,@LedgerTransactionID) ",
                                                               new MySqlParameter("@LedgertransactionNo", PatientData.LedgerTransactionNo),
                                                               new MySqlParameter("@SinNo", objPlo.BarcodeNo),
                                                               new MySqlParameter("@Test_ID", ID1),
                                                               new MySqlParameter("@Status", string.Format("SIN No. {0} {1}", objPlo.BarcodeNo, "Received")),
                                                               new MySqlParameter("@UserID", UserInfo.ID),
                                                               new MySqlParameter("@UserName", UserInfo.LoginName),
                                                               new MySqlParameter("@IpAddress", StockReports.getip()),
                                                               new MySqlParameter("@CentreID", UserInfo.Centre),
                                                               new MySqlParameter("@RoleID", UserInfo.RoleID),
                                                               new MySqlParameter("@DispatchCode", string.Empty),
                                                               new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID));

                                                    }


                                                }
                                              // if (dtTemp.Rows.Count > 0)
                                              // {
                                              //     sb = new StringBuilder();
                                              //     sb.Append(" Update patient_labinvestigation_opd ");
                                              //     sb.Append(" SET IsSampleCollected=@IsSampleCollected, ");
                                              //     sb.Append(" SampleReceiver=@SampleReceiver,SampleReceivedBy=@SampleReceivedBy, ");
                                              //     sb.Append(" SampleReceiveDate=@SampleReceiveDate,SampleBySelf=@SampleBySelf,SampleCollectionBy=@SampleCollectionBy, ");
                                              //     sb.Append(" SampleCollector=@SampleCollector,SampleCollectionDate=@SampleCollectionDate,TestCentreID=@TestCentreID ");
                                              //     sb.Append(" WHERE BarcodeNo=@BarcodeNo AND Test_ID=@Test_ID ");
                                              //     MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                              //          new MySqlParameter("@IsSampleCollected", Util.GetString(dtTemp.Rows[0]["IsSampleCollected"])),
                                              //          new MySqlParameter("@SampleReceiver", Util.GetString(dtTemp.Rows[0]["SampleReceiver"])),
                                              //          new MySqlParameter("@SampleReceivedBy", Util.GetInt(dtTemp.Rows[0]["SampleReceivedBy"])),
                                              //          new MySqlParameter("@SampleReceiveDate", Convert.ToDateTime(Util.GetDateTime(dtTemp.Rows[0]["SampleReceiveDate"])).ToString("yyyy-MM-dd HH:mm:ss")),
                                              //          new MySqlParameter("@SampleBySelf", Util.GetInt(dtTemp.Rows[0]["SampleBySelf"])),
                                              //          new MySqlParameter("@SampleCollectionBy", Util.GetInt(dtTemp.Rows[0]["SampleCollectionBy"])),
                                              //          new MySqlParameter("@SampleCollector", Util.GetString(dtTemp.Rows[0]["SampleCollector"])),
                                              //          new MySqlParameter("@SampleCollectionDate", Convert.ToDateTime(Util.GetDateTime(dtTemp.Rows[0]["SampleCollectionDate"])).ToString("yyyy-MM-dd HH:mm:ss")),
                                              //          new MySqlParameter("@TestCentreID", Util.GetInt(dtTemp.Rows[0]["TestCentreID"])),
                                              //          new MySqlParameter("@BarcodeNo", Barcode.Trim()),
                                              //          new MySqlParameter("@Test_ID", ID1.Trim()));
											  //
                                              //     dtTemp.Rows.Clear();
                                              // }
                                            }
                                            else
                                            {


                                                DataTable testDetail = dtInvList.AsEnumerable().Where(a => a.Field<int>("Investigation_ID").Equals(Util.GetInt(dw["Investigation_id"]))).CopyToDataTable();

                                                if (BillNo == string.Empty)
                                                {
                                                    BillNo = AllLoad_Data.getBillNo(PatientData.CentreID, "C", con, tnx); ;
                                                }
                                                if (BillNo == string.Empty)
                                                {
                                                    tnx.Rollback();
                                                    return JsonConvert.SerializeObject(new { status = false, response = "BillNo Error" });
                                                }

                                                sb = new StringBuilder();
                                                sb.Append(" UPDATE patient_labinvestigation_opd SET Test_ID=@Test_ID,IsRefund=1,IsReporting=0 WHERE Test_ID=@TestID");

                                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                    new MySqlParameter("@Test_ID", Util.GetInt(testDetail.Rows[0]["Test_ID"].ToString()) * -1),
                                                    new MySqlParameter("@TestID", testDetail.Rows[0]["Test_ID"].ToString()));

                                                decimal PackageMRP = 0;// Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT Rate FROM f_ratelist WHERE ItemID=@ItemID AND panel_id=(SELECT `ReferenceCodeOPD` FROM f_panel_master WHERE centreID=@centreID AND panelType='Centre')",
                                                                         //                 new MySqlParameter("@ItemID", dw["Investigation_Id"].ToString()),
                                                                           //               new MySqlParameter("@centreID", PatientData.CentreID)));
                                                decimal PackageMRPPercentage = 0;// (PackageMRP * 100) / totalpackagemrp;
                                                decimal PackageMRPNet = 0;// (Util.GetDecimal(plo.Amount) * PackageMRPPercentage) / 100;




                                                sb = new StringBuilder();
                                                sb.Append(" INSERT INTO patient_labinvestigation_opd(Test_ID,LedgerTransactionID,LedgerTransactionNo,BillNo,BarcodeNo,ItemId,ItemName,Investigation_ID,IsPackage,Date,SubCategoryID,SubCategoryName,Rate,");
                                                sb.Append(" Amount,DiscountAmt,CouponAmt,Quantity,DiscountByLab,IsRefund,IsReporting,IsActive,BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                                                sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                                                sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                                                sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                                                sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                                                sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                                                sb.Append(" SampleTypeID,SampleTypeName,SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                                                sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                                                sb.Append(" CurrentSampleDept,ToSampleDept,UpdateID,UpdateName,UpdateRemarks,ipAddress,");
                                                sb.Append(" Barcode_Group,IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                                                sb.Append(" PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                                                sb.Append(" MachineID_Manual,IsScheduleRate,MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                                                sb.Append(" PackageMRPPercentage,PackageMRPNet,ItemCode,SRADate,CreatedBy,CreatedByID,BaseCurrencyRound,DepartmentTokenNo) ");
                                                sb.Append(" ");
                                                sb.Append(" SELECT @Test_ID,LedgerTransactionID,LedgerTransactionNo,@BillNo,BarcodeNo,@ItemId,@ItemName,@Investigation_ID,1 IsPackage,@BillDate,SubCategoryID,SubCategoryName,0 Rate,");
                                                sb.Append(" 0 Amount,0 DiscountAmt,0 CouponAmt,Quantity,DiscountByLab,0,1,1,@BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                                                sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                                                sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                                                sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                                                sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                                                sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                                                sb.Append(" 0,'',SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                                                sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                                                sb.Append(" CurrentSampleDept,ToSampleDept,0,'','',@ipAddress,");
                                                sb.Append(" '',IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                                                sb.Append(" @PackageName PackageName,@PackageCode PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                                                sb.Append(" MachineID_Manual,IsScheduleRate,0 MRP,0 PackageRate,HoldType,@PanelItemCode,@PackageMRP,");
                                                sb.Append(" @PackageMRPPercentage,@PackageMRPNet,@ItemCode,SRADate,@CreatedBy,@CreatedByID,BaseCurrencyRound,DepartmentTokenNo ");
                                                sb.Append(" FROM patient_labinvestigation_opd WHERE Test_ID=@TestID AND IsActive=1");
                                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                   new MySqlParameter("@Test_ID", testDetail.Rows[0]["Test_ID"].ToString()),
                                                   new MySqlParameter("@TestID", Util.GetInt(testDetail.Rows[0]["Test_ID"].ToString()) * -1),

                                                   new MySqlParameter("@ipAddress", StockReports.getip()), new MySqlParameter("@Investigation_ID", dw["Investigation_id"]),
                                                   new MySqlParameter("@PackageName", dw["PackName"].ToString()), new MySqlParameter("@PackageCode", plo.PackageCode),
                                                   new MySqlParameter("@ItemCode", dw["TestCode"].ToString().ToUpper()), new MySqlParameter("@ItemName", dw["name"].ToString().ToUpper()),
                                                   new MySqlParameter("@ItemId", plo.ItemId), new MySqlParameter("@BillNo", BillNo),
                                                   new MySqlParameter("@BillDate", billData), new MySqlParameter("@BillType", "Credit-Test Added"),
                                                   new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID),
                                                   new MySqlParameter("@PanelItemCode", plo.PanelItemCode),
                                                   new MySqlParameter("@PackageMRP", PackageMRP), new MySqlParameter("@PackageMRPPercentage", PackageMRPPercentage),
                                                   new MySqlParameter("@PackageMRPNet", PackageMRPNet));


                                                sb = new StringBuilder();
                                                sb.Append(" UPDATE patient_labinvestigation_opd SET IsActive=0 WHERE Test_ID=@Test_ID");

                                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                    new MySqlParameter("@Test_ID", Util.GetInt(testDetail.Rows[0]["Test_ID"].ToString()) * -1));



                                            }
                                        }
                                    }
                                }
                            }
                            else
                            {
                                PackageItemList.Add(plo.ItemId);
                                ItemIDList.Add(new getItemDetail { ItemID = plo.ItemId, SubcategoryID = plo.SubCategoryID, IsPackage = 1 });


                                //DataTable testDetail = dtInvList.AsEnumerable().Where(a => a.Field<int>("ItemID").Equals(plo.ItemId)).CopyToDataTable();

                                //if (BillNo == string.Empty)
                                //{
                                //    BillNo = AllLoad_Data.getBillNo(PatientData.CentreID, "C", con, tnx); ;
                                //}
                                //if (BillNo == string.Empty)
                                //{
                                //    tnx.Rollback();
                                //    return JsonConvert.SerializeObject(new { status = false, response = "BillNo Error" });
                                //}

                                //sb = new StringBuilder();
                                //sb.Append(" UPDATE patient_labinvestigation_opd SET Test_ID=@Test_ID,IsRefund=1,IsReporting=0,IsActive=0 WHERE Test_ID=@TestID");

                                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                //    new MySqlParameter("@Test_ID", Util.GetInt(testDetail.Rows[0]["Test_ID"].ToString()) * -1),
                                //    new MySqlParameter("@TestID", testDetail.Rows[0]["Test_ID"].ToString()));

                                //sb = new StringBuilder();
                                //sb.Append(" INSERT INTO patient_labinvestigation_opd(Test_ID,LedgerTransactionID,LedgerTransactionNo,BillNo,BarcodeNo,ItemId,ItemName,Investigation_ID,IsPackage,Date,SubCategoryID,Rate,");
                                //sb.Append(" Amount,DiscountAmt,CouponAmt,Quantity,DiscountByLab,IsRefund,IsReporting,IsActive,BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                                //sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                                //sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                                //sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                                //sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                                //sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                                //sb.Append(" SampleTypeID,SampleTypeName,SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                                //sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                                //sb.Append(" CurrentSampleDept,ToSampleDept,UpdateID,UpdateName,UpdateRemarks,ipAddress,");
                                //sb.Append(" Barcode_Group,IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                                //sb.Append(" PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                                //sb.Append(" MachineID_Manual,IsScheduleRate,MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                                //sb.Append(" PackageMRPPercentage,PackageMRPNet,ItemCode,SRADate,CreatedBy,CreatedByID,BaseCurrencyRound) ");
                                //sb.Append(" ");
                                //sb.Append(" SELECT @Test_ID,@LedgerTransactionID,LedgerTransactionNo,@BillNo,BarcodeNo,@ItemId,@ItemName,Investigation_ID,0 IsPackage,@BillDate,SubCategoryID,@Rate,");
                                //sb.Append(" @Amount,0 DiscountAmt,CouponAmt,Quantity,DiscountByLab,0,1,1,@BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                                //sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                                //sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                                //sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                                //sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                                //sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                                //sb.Append(" 0,'',SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                                //sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                                //sb.Append(" CurrentSampleDept,ToSampleDept,0,'','',@ipAddress,");
                                //sb.Append(" '',IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                                //sb.Append(" '' PackageName,'' PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                                //sb.Append(" MachineID_Manual,IsScheduleRate,@MRP,0 PackageRate,HoldType,@PanelItemCode,0 PackageMRP,");
                                //sb.Append(" 0 PackageMRPPercentage,0 PackageMRPNet,@ItemCode,SRADate,@CreatedBy,@CreatedByID,BaseCurrencyRound ");
                                //sb.Append(" FROM patient_labinvestigation_opd WHERE Test_ID=@TestID ");
                                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                //   new MySqlParameter("@Test_ID", testDetail.Rows[0]["Test_ID"].ToString()),
                                //   new MySqlParameter("@TestID", Util.GetInt(testDetail.Rows[0]["Test_ID"].ToString()) * -1),
                                //   new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID),
                                //   new MySqlParameter("@Rate", plo.Rate),
                                //   new MySqlParameter("@Amount", plo.Amount), new MySqlParameter("@ipAddress", StockReports.getip()),
                                //   new MySqlParameter("@ItemCode", plo.ItemCode), new MySqlParameter("@ItemName", plo.ItemName),
                                //   new MySqlParameter("@ItemId", plo.ItemId), new MySqlParameter("@BillNo", BillNo),
                                //   new MySqlParameter("@BillDate", billData), new MySqlParameter("@BillType", "Credit-Test Added"),
                                //   new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID),
                                //   new MySqlParameter("@PanelItemCode", plo.PanelItemCode), new MySqlParameter("@MRP", plo.MRP));







                                //sb = new StringBuilder();
                                //sb.Append(" UPDATE patient_labinvestigation_opd SET itemID=@ItemID, IsPackage=1,Rate=@Rate,PackageName=@PackageName,PackageCode=@PackageCode, ");
                                //sb.Append(" Amount=@Amount,DiscountAmt=@DiscountAmt  ");
                                //sb.Append(" WHERE LedgerTransactionID=@LedgerTransactionID AND ItemID=@ItemID AND SubCategoryID=15 ");
                                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                //   new MySqlParameter("@ItemID", plo.ItemId), new MySqlParameter("@Rate", plo.Rate),
                                //   new MySqlParameter("@PackageName", plo.PackageName),
                                //   new MySqlParameter("@PackageCode", plo.PackageCode), new MySqlParameter("@Amount", plo.Amount),
                                //   new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID),
                                //   new MySqlParameter("@DiscountAmt", plo.DiscountAmt));


                                //sb = new StringBuilder();
                                //sb.Append(" SELECT imm.`Name` ,imm.`Investigation_Id`,imm.`Type` sampleData,imm.`Reporting`,imm.`ReportType`,");
                                //sb.Append(" Get_DeliveryDate_client(@Centre,imm.Investigation_ID,now())DeliveryDate, ");
                                //sb.Append(" (SELECT `SubCategoryID` FROM f_itemmaster WHERE type_id=imm.`Investigation_Id`)SubCategoryID,imm.TestCode ");
                                //sb.Append("   FROM f_itemmaster im  ");
                                //sb.Append("   INNER JOIN package_labdetail pld  ON pld.PlabID=im.Type_ID   ");
                                //sb.Append("   INNER JOIN investigation_master imm  ON imm.Investigation_Id=pld.InvestigationID ");
                                //sb.Append("   AND  im.`ItemID`=@ItemID ");

                                //using (DataTable dtpackinfo = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                //   new MySqlParameter("@ItemID", plo.ItemId), new MySqlParameter("@Centre", UserInfo.Centre)).Tables[0])
                                //{
                                //    if (dtpackinfo.Rows.Count > 0)
                                //    {
                                //        foreach (DataRow dw in dtpackinfo.Rows)
                                //        {
                                //            InvList.Add(Util.GetString(dw["Investigation_id"]));
                                //            sb = new StringBuilder();
                                //            sb.Append(" UPDATE patient_labinvestigation_opd SET itemID=@itemID, IsPackage=1,Rate=0, ");
                                //            sb.Append(" Amount=0,DiscountAmt=0  ");
                                //            sb.Append(" WHERE LedgerTransactionID=@LedgerTransactionID AND Investigation_ID=@Investigation_ID AND IsPackage=1");
                                //            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                //               new MySqlParameter("@itemID", Util.GetString(plo.ItemId)),
                                //               new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID),
                                //               new MySqlParameter("@Investigation_ID", dw["Investigation_Id"].ToString()));
                                //        }
                                //    }
                                //}
                            }
                        }
                    }


                    string Investigation_ID = String.Join(",", InvList);
                    string PackageItemID = String.Join(",", PackageItemList);

                    if (PackageItemID == string.Empty)
                        PackageItemID = "0";


                    string[] Investigation_IDTags = Investigation_ID.Split(',');
                    string[] Investigation_IDParamNames = Investigation_IDTags.Select((s, i) => "@tag" + i).ToArray();
                    string Investigation_IDClause = string.Join(", ", Investigation_IDParamNames);

                    ///Removed Test

                    DataTable dtRemove = new DataTable();
                    using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("Select Distinct ItemName from Patient_labinvestigation_opd where ispackage=0 and LedgertransactionNo='" + PatientData.LedgerTransactionNo + "' and  IsRefund=0 and Investigation_id not in ({0})  ", Investigation_IDClause), con))
                    {
                        for (int i = 0; i < Investigation_IDParamNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(Investigation_IDParamNames[i], Investigation_IDTags[i]);
                        }
                        da.Fill(dtRemove);
                    }
                    for (int rem = 0; rem < dtRemove.Rows.Count; rem++)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode,@LedgerTransactionID) ",
                                                               new MySqlParameter("@LedgertransactionNo", PatientData.LedgerTransactionNo),
                                                               new MySqlParameter("@SinNo", ""), new MySqlParameter("@Test_ID", "0"),
                                                               new MySqlParameter("@Status", string.Format("Removed Item ({0})", dtRemove.Rows[rem]["ItemName"].ToString())), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                                                               new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", PatientData.CentreID), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@DispatchCode", string.Empty), new MySqlParameter("@dtEntry", billData), new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID));
                    }
                    //---------------------


                    sb = new StringBuilder();
                    sb.Append(" UPDATE patient_labinvestigation_opd SET IsRefund=1,IsActive=0,IsReporting=0,");
                    sb.Append(" UpdateID=@UpdateID,UpdateName=@UpdateName,UpdateDate=now(),UpdateRemarks='Investigation Removed' ");
                    sb.Append(" WHERE LedgerTransactionID=@LedgerTransactionID AND Investigation_id NOT IN ({0}) and ispackage=0 AND SubcategoryID<>15 ");


                    using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), Investigation_IDClause), con, tnx))
                    {
                        for (int i = 0; i < Investigation_IDParamNames.Length; i++)
                        {
                            cmd.Parameters.AddWithValue(Investigation_IDParamNames[i], Investigation_IDTags[i]);
                        }
                        cmd.Parameters.AddWithValue("@UpdateID", HttpContext.Current.Session["ID"].ToString());
                        cmd.Parameters.AddWithValue("@UpdateName", HttpContext.Current.Session["LoginName"].ToString());
                        cmd.Parameters.AddWithValue("@LedgerTransactionID", PatientData.LedgerTransactionID);
                        cmd.ExecuteNonQuery();
                    }
                    //---------------------


                    ///Removed Package
                    string[] PackageItemIDTags = PackageItemID.Split(',');
                    string[] PackageItemIDParamNames = PackageItemIDTags.Select((s, i) => "@tag" + i).ToArray();
                    string PackageItemIDClauses = string.Join(", ", PackageItemIDParamNames);
                    DataTable dtRemovePac = new DataTable();
                    using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("Select Distinct ItemName from Patient_labinvestigation_opd where ispackage=1 and LedgertransactionNo='" + PatientData.LedgerTransactionNo + "' and  IsRefund=0 and ItemID not in ({0})  ", PackageItemIDClauses), con))
                    {
                        for (int i = 0; i < PackageItemIDParamNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(PackageItemIDParamNames[i], PackageItemIDTags[i]);
                        }

                        da.Fill(dtRemovePac);
                    }
                    for (int rem = 0; rem < dtRemovePac.Rows.Count; rem++)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode,@LedgerTransactionID) ",
                                                               new MySqlParameter("@LedgertransactionNo", PatientData.LedgerTransactionNo),
                                                               new MySqlParameter("@SinNo", ""), new MySqlParameter("@Test_ID", "0"),
                                                               new MySqlParameter("@Status", string.Format("Removed Item ({0})", dtRemovePac.Rows[rem]["ItemName"].ToString())), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                                                               new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", PatientData.CentreID), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@DispatchCode", string.Empty), new MySqlParameter("@dtEntry", billData), new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID));
                    }
                //---------------------



                    sb = new StringBuilder();
                    sb.Append("UPDATE patient_labinvestigation_opd SET IsRefund=1,IsActive=0,IsReporting=0,");
                    sb.Append(" UpdateID=@UpdateID,UpdateName=@UpdateName,UpdateDate=now(),UpdateRemarks='Investigation Removed' ");
                    sb.Append(" WHERE LedgerTransactionID=@LedgerTransactionID AND ItemID NOT IN ({0}) AND SubcategoryID= 15 ");

                    using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), PackageItemIDClauses), con, tnx))
                    {
                        for (int i = 0; i < PackageItemIDParamNames.Length; i++)
                        {
                            cmd.Parameters.AddWithValue(PackageItemIDParamNames[i], PackageItemIDTags[i]);
                        }

                        cmd.Parameters.AddWithValue("@UpdateID", HttpContext.Current.Session["ID"].ToString());
                        cmd.Parameters.AddWithValue("@UpdateName", HttpContext.Current.Session["LoginName"].ToString());
                        cmd.Parameters.AddWithValue("@LedgerTransactionID", PatientData.LedgerTransactionID);
                        cmd.ExecuteNonQuery();
                    } 

                   
                //---------------------



                   




                    Type fieldType = dtInvList.Columns["IsPackage"].DataType;

                    List<getItemDetail> getOldItemID = dtInvList.AsEnumerable()
                                     .Select(row => new getItemDetail
                                {
                                    ItemID = row.Field<int>("ItemID"),
                                    SubcategoryID = row.Field<int>("SubcategoryID"),
                                    IsPackage = row.Field<sbyte>("isPackage")
                                }).ToList();

                    HashSet<int> diffids = new HashSet<int>(ItemIDList.Select(s => s.ItemID));
                    List<getItemDetail> getUnmatchedItemID = getOldItemID.Where(m => !diffids.Contains(m.ItemID)).ToList();
                    getUnmatchedItemID = getUnmatchedItemID.GroupBy(i => i.ItemID).Select(group => group.First()).ToList();
                    if (getUnmatchedItemID.Count > 0)
                    {
                        string DebitBillNo = AllLoad_Data.getBillNo(PatientData.CentreID, "D", con, tnx);
                        if (DebitBillNo == string.Empty)
                        {
                            tnx.Rollback();
                            return JsonConvert.SerializeObject(new { status = false, response = "BillNo Error" });
                        }

                        List<getItemDetail> getPackageItemID = getUnmatchedItemID.Where(s => s.SubcategoryID == 15).ToList();
                        List<getItemDetail> getOtherItemID = getUnmatchedItemID.Where(s => s.SubcategoryID != 15).ToList();

                        if (getOtherItemID.Count > 0)
                        {

                            int[] ItemIDTags = getOtherItemID.Select(s => s.ItemID).ToArray();
                            string[] ItemIDParamNames = ItemIDTags.Select((s, i) => "@tag" + i).ToArray();
                            string ItemIDClause = string.Join(", ", ItemIDParamNames);

                            sb = new StringBuilder();
                            sb.Append(" INSERT INTO patient_labinvestigation_opd(LedgerTransactionID,LedgerTransactionNo,BillNo,BarcodeNo,ItemId,ItemName,Investigation_ID,IsPackage,Date,SubCategoryID,SubCategoryName,Rate,");
                            sb.Append(" Amount,DiscountAmt,CouponAmt,Quantity,DiscountByLab,IsRefund,IsReporting,IsActive,BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                            sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                            sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                            sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                            sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                            sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                            sb.Append(" SampleTypeID,SampleTypeName,SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                            sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                            sb.Append(" CurrentSampleDept,ToSampleDept,UpdateID,UpdateName,UpdateRemarks,ipAddress,");
                            sb.Append(" Barcode_Group,IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                            sb.Append(" PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                            sb.Append(" MachineID_Manual,IsScheduleRate,MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                            sb.Append(" PackageMRPPercentage,PackageMRPNet,ItemCode,SRADate,CreatedBy,CreatedByID,BaseCurrencyRound,DepartmentTokenNo) ");
                            sb.Append(" ");
                            sb.Append(" SELECT LedgerTransactionID,LedgerTransactionNo,@BillNo,'',ItemId,ItemName,Investigation_ID,IsPackage,@BillDate,SubCategoryID,SubCategoryName,Rate,");
                            sb.Append(" Amount*-1,DiscountAmt*-1,CouponAmt,Quantity*-1,DiscountByLab,2,0,0,@BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                            sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                            sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                            sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                            sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                            sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                            sb.Append(" 0,'',SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                            sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                            sb.Append(" CurrentSampleDept,ToSampleDept,0,'','',@ipAddress,");
                            sb.Append(" '',IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                            sb.Append(" PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                            sb.Append(" MachineID_Manual,IsScheduleRate,MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                            sb.Append(" PackageMRPPercentage,PackageMRPNet,ItemCode,SRADate,@CreatedBy,@CreatedByID,@BaseCurrencyRound,DepartmentTokenNo ");
                            sb.Append(" FROM patient_labinvestigation_opd WHERE LedgerTransactionID=@LedgerTransactionID AND ItemID IN ({0}) AND SubcategoryID<>15 ");


                            using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), ItemIDClause), con, tnx))
                            {
                                for (int i = 0; i < ItemIDParamNames.Length; i++)
                                {
                                    cmd.Parameters.Add(new MySqlParameter(ItemIDParamNames[i], ItemIDTags[i]));
                                }
                                cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID));
                                cmd.Parameters.Add(new MySqlParameter("@BillNo", DebitBillNo));
                                cmd.Parameters.Add(new MySqlParameter("@BillDate", billData));
                                cmd.Parameters.Add(new MySqlParameter("@BillType", "Debit-Test Removed"));
                                cmd.Parameters.Add(new MySqlParameter("@CreatedBy", UserInfo.LoginName));
                                cmd.Parameters.Add(new MySqlParameter("@CreatedByID", UserInfo.ID));
                                cmd.Parameters.Add(new MySqlParameter("@BaseCurrencyRound", Resources.Resource.BaseCurrencyRound));
                                cmd.Parameters.Add(new MySqlParameter("@ipAddress", StockReports.getip()));

                                cmd.ExecuteNonQuery();
                            }
                        }
                        if (getPackageItemID.Count > 0)
                        {

                            int[] PackageItemIDTag = getPackageItemID.Select(s => Util.GetInt(s.ItemID)).ToArray();
                            string[] PackageItemIDParamName = PackageItemIDTag.Select((s, i) => "@tag" + i).ToArray();
                            string PackageItemIDClause = string.Join(", ", PackageItemIDParamName);

                            sb = new StringBuilder();
                            sb.Append(" UPDATE patient_labinvestigation_opd SET IsRefund=1,IsReporting=0,IsActive=0 WHERE LedgerTransactionID=@LedgerTransactionID AND ItemID IN ({0}) AND ispackage=1 and isrefund=0");
                            using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), PackageItemIDClause), con, tnx))
                            {
                                for (int i = 0; i < PackageItemIDParamName.Length; i++)
                                {
                                    cmd.Parameters.Add(new MySqlParameter(PackageItemIDParamName[i], PackageItemIDTag[i]));
                                }
                                cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID));
                               

                                cmd.ExecuteNonQuery();
                            }


                            sb = new StringBuilder();
                            sb.Append("INSERT INTO patient_labinvestigation_opd(LedgerTransactionID,LedgerTransactionNo,BillNo,BarcodeNo,ItemId,ItemName,Investigation_ID,IsPackage,Date,SubCategoryID,SubCategoryName,Rate,");
                            sb.Append(" Amount,DiscountAmt,CouponAmt,Quantity,DiscountByLab,IsRefund,IsReporting,IsActive,BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                            sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                            sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                            sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                            sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                            sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                            sb.Append(" SampleTypeID,SampleTypeName,SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                            sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                            sb.Append(" CurrentSampleDept,ToSampleDept,UpdateID,UpdateName,UpdateRemarks,ipAddress,");
                            sb.Append(" Barcode_Group,IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                            sb.Append(" PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                            sb.Append(" MachineID_Manual,IsScheduleRate,MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                            sb.Append(" PackageMRPPercentage,PackageMRPNet,ItemCode,SRADate,CreatedBy,CreatedByID,BaseCurrencyRound,DepartmentTokenNo) ");
                            sb.Append(" ");
                            sb.Append(" SELECT LedgerTransactionID,LedgerTransactionNo,@BillNo,'',ItemId,ItemName,Investigation_ID,IsPackage,@BillDate,SubCategoryID,SubCategoryName,Rate,");
                            sb.Append(" Amount*-1,DiscountAmt*-1,CouponAmt,Quantity*-1,DiscountByLab,2,0,0,@BillType, Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                            sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                            sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                            sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                            sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                            sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                            sb.Append(" 0,'',SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                            sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                            sb.Append(" CurrentSampleDept,ToSampleDept,0,'','',@ipAddress,");
                            sb.Append(" '',IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                            sb.Append(" PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                            sb.Append(" MachineID_Manual,IsScheduleRate,MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                            sb.Append(" PackageMRPPercentage,PackageMRPNet,ItemCode,SRADate,@CreatedBy,@CreatedByID,@BaseCurrencyRound,DepartmentTokenNo ");
                            sb.Append(" FROM patient_labinvestigation_opd WHERE LedgerTransactionID=@LedgerTransactionID AND ItemID IN ({0}) AND ispackage=1  ");//AND SubcategoryID=15


                            using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), PackageItemIDClause), con, tnx))
                            {
                                for (int i = 0; i < PackageItemIDParamName.Length; i++)
                                {
                                    cmd.Parameters.Add(new MySqlParameter(PackageItemIDParamName[i], PackageItemIDTag[i]));
                                }
                                cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID));
                                cmd.Parameters.Add(new MySqlParameter("@BillNo", DebitBillNo));
                                cmd.Parameters.Add(new MySqlParameter("@BillDate", billData));
                                cmd.Parameters.Add(new MySqlParameter("@BillType", "Debit-Test Removed"));
                                cmd.Parameters.Add(new MySqlParameter("@CreatedBy", UserInfo.LoginName));
                                cmd.Parameters.Add(new MySqlParameter("@CreatedByID", UserInfo.ID));
                                cmd.Parameters.Add(new MySqlParameter("@BaseCurrencyRound", Resources.Resource.BaseCurrencyRound));
                                cmd.Parameters.Add(new MySqlParameter("@ipAddress", StockReports.getip()));

                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
            }


            // update slidenumber start
            sb = new StringBuilder();
            sb.Append(" SELECT slideNumber,HistoCytoSampleDetail FROM patient_labinvestigation_opd WHERE LedgerTransactionNo=@LedgerTransactionNo AND reportType=7 and IFNULL(slideNumber,'')<>'' ");
            DataTable dts = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LedgerTransactionNo", PatientData.LedgerTransactionNo)).Tables[0];
            if (dts.Rows.Count > 0)
            {
                MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET slideNumber=@slideNumber,HistoCytoSampleDetail=@HistoCytoSampleDetail WHERE LedgerTransactionNo=@LedgerTransactionNo AND reportType=7 AND IFNULL(slideNumber,'')='' ",
                   new MySqlParameter("@slideNumber", dts.Rows[0]["slideNumber"].ToString()),
                   new MySqlParameter("@HistoCytoSampleDetail", dts.Rows[0]["HistoCytoSampleDetail"].ToString()),
                   new MySqlParameter("@LedgerTransactionNo", PatientData.LedgerTransactionNo));
            }

            // end


            sb = new StringBuilder();
            sb.Append(" UPDATE f_ledgertransaction SET grossAmount=(SELECT SUM(Rate*Quantity) FROM patient_labinvestigation_opd WHERE LedgerTransactionID = @LedgerTransactionID AND IsActive=1), ");
            sb.Append(" netAmount=(SELECT SUM(amount) FROM patient_labinvestigation_opd WHERE LedgerTransactionID = @LedgerTransactionID AND IsActive=1),");
            sb.Append(" discountonTotal=(SELECT sum(discountAmt) FROM patient_labinvestigation_opd WHERE LedgerTransactionID = @LedgerTransactionID AND IsActive=1)");
            sb.Append(" WHERE LedgerTransactionID=@LedgerTransactionID ");

            int b1 = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID));
            if (b1 == 0)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "LT Error" });
            }
            sb = new StringBuilder();
            sb.Append(" SELECT lm.`LabObservation_ID`,lm.`Name`,plo.`ItemName` FROM `patient_labinvestigation_opd` plo ");
            sb.Append(" INNER JOIN `labobservation_investigation` li ON li.`Investigation_Id`=plo.`Investigation_ID` ");
            sb.Append(" INNER JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=li.`labObservation_ID` ");
            sb.Append(" WHERE AllowDuplicateBooking=0 AND `LedgerTransactionID`>0 AND  plo.`LedgerTransactionID`=@LedgerTransactionID AND plo.IsActive=1");
            sb.Append(" GROUP BY lm.`LabObservation_ID` HAVING COUNT(*) >1  ");

      //     using (DataTable dtDuplicate = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
      //        new MySqlParameter("@LedgerTransactionID", PatientData.LedgerTransactionID)).Tables[0])
      //     {
      //         if (dtDuplicate.Rows.Count > 0)
      //         {
      //             tnx.Rollback();
      //             return JsonConvert.SerializeObject(new { status = false, response = string.Concat(dtDuplicate.Rows[0]["Name"].ToString(), " Found duplicate in ", dtDuplicate.Rows[0]["ItemName"].ToString()) });
      //         }
      //     }

            Panel_Share ps = new Panel_Share();
            JSONResponse IPS = JsonConvert.DeserializeObject<JSONResponse>(ps.InsertPanel_Share(PatientData.LedgerTransactionID, tnx, con));
            if (IPS.status == false)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = IPS.response });
            }

            if (RequiredField.Count > 0)
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM patient_labinvestigation_opd_requiredField WHERE LedgerTransactionID=@LedgerTransactionID",
                   new MySqlParameter("LedgerTransactionID", RequiredField[0].LedgerTransactionID));


                foreach (BookingRequiredField objrequired in RequiredField)
                {
                    BookingRequiredField objrequ = new BookingRequiredField(tnx)
                    {
                        FieldID = objrequired.FieldID,
                        FieldName = objrequired.FieldName,
                        FieldValue = objrequired.FieldValue,
                        Unit = objrequired.Unit,
                        LedgerTransactionID = PatientData.LedgerTransactionID,
                        LedgerTransactionNo = PatientData.LedgerTransactionNo
                    };
                    if (objrequ.Insert() == 0)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "Required Field Error" });

                    }
                }
            }

            tnx.Commit();
            InvList.Clear();
            PackageItemList.Clear();
            return JsonConvert.SerializeObject(new { status = true, response = "Success" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = ex.GetBaseException().ToString() });

        }
        finally
        {
            con.Close();
            con.Dispose();
            tnx.Dispose();
        }
    }

    public class PatientData
    {
        public int LedgerTransactionID { get; set; }
        public string LedgerTransactionNo { get; set; }
        public string Patient_ID { get; set; }
        public string Gender { get; set; }
        public int AgeInDays { get; set; }
        public int CentreID { get; set; }
        public int Panel_ID { get; set; }
        public string PatientType { get; set; }
        public string BarCodePrintedType { get; set; }
        public string VisitType { get; set; }
        public string AttachedFileName { get; set; }
    }
    public class getItemDetail
    {
        public int ItemID { get; set; }
        public int SubcategoryID { get; set; }
        public sbyte IsPackage { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public static string bindAllRequiredField(string requiredFiled, string LabNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] itemTags = requiredFiled.Split(',');
            string[] itemNames = itemTags.Select((s, i) => "@tag" + i).ToArray();
            string itemClause = string.Join(", ", itemNames);

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT IFNULL(pr.FieldValue,'')FieldValue,IFNULL(pr.unit,'') savedUnit, rm.id,rm.FieldName,InputType,IF(rm.IsUnit=1,rm.Unit,'') Unit,IF(InputType='DropDownList',DropDownOption,'')DropDownOption ");
            sb.Append(" FROM `requiredfield_master` rm LEFT JOIN patient_labinvestigation_opd_requiredField pr on rm.id=pr.fieldid ");
            sb.Append(" AND pr.LedgerTransactionNo=@LedgerTransactionNo  WHERE rm.id IN ({0}) AND rm.id not in ('12') ");
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), itemClause), con))
            {
                for (int i = 0; i < itemNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(itemNames[i], itemTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@LedgerTransactionNo", LabNo);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string SaveRequiredField(List<BookingRequiredField> RequiredField)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM patient_labinvestigation_opd_requiredField WHERE LedgerTransactionID=@LedgerTransactionID",
               new MySqlParameter("LedgerTransactionID", RequiredField[0].LedgerTransactionID));

            foreach (BookingRequiredField objrequired in RequiredField)
            {
                BookingRequiredField objrequ = new BookingRequiredField(tnx)
                {
                    FieldID = objrequired.FieldID,
                    FieldName = objrequired.FieldName,
                    FieldValue = objrequired.FieldValue,
                    Unit = objrequired.Unit,
                    LedgerTransactionID = objrequired.LedgerTransactionID,
                    LedgerTransactionNo = objrequired.LedgerTransactionNo
                };
                if (objrequ.Insert() == 0)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Required Field Error" });

                }
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = "true", response = "Required Field Updated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Required Field Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}
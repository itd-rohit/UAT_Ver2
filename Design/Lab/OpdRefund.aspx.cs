using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Linq;
using Newtonsoft.Json;
using System.Web.Script.Serialization;
public partial class Design_Lab_OpdRefund : System.Web.UI.Page
{
    public static string labno = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindEmployee();
            bindpaymentmode();
            AllLoad_Data.bindBank(ddlBank, "Select");
        }
    }

    public void bindEmployee()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT DISTINCT CONCAT(em.`Title`,'',em.`Name`)NAME,em.`Employee_ID` FROM employee_master em  ");
            sb.Append(" INNER JOIN f_login fl ON fl.`EmployeeID`=em.`Employee_ID` ");
            sb.Append(" AND em.`IsActive`=1 AND fl.`CentreID`='" + UserInfo.Centre + "' ORDER BY em.`Name` ");
            ddlRefundBy.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];
            ddlRefundBy.DataTextField = "NAME";
            ddlRefundBy.DataValueField = "Employee_ID";
            ddlRefundBy.DataBind();
            ddlRefundBy.Items.Insert(0, new ListItem("-------Select Refund By-------", ""));



            ddlPaymentMode.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT paymentmodeID,paymentMode FROM `paymentmode_master` WHERE paymentmodeID<>4 AND paymentmodeID<>9 ").Tables[0];
            ddlPaymentMode.DataValueField = "paymentmodeID";
            ddlPaymentMode.DataTextField = "paymentMode";
            ddlPaymentMode.DataBind();

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public static string searchdata(string LabNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        string Roleid = Util.GetString(UserInfo.RoleID); string permissiontype = "LabRefund"; string Labno = LabNo;
        string rresult = Util.RolePermission(Roleid, permissiontype, Labno);

        if (rresult == "true")
        {
            // return JsonConvert.SerializeObject(new { status = false, response = "Your From date ,To date Diffrence is too  Long" });
            return "-1";
        }
        try
        {
            StringBuilder sb = new StringBuilder();

            // PatientMaster
            sb.Append(" SELECT pm.Patient_ID ,pm.Title ,pm.PName , ");
            sb.Append("  (SELECT COUNT(1) FROM `sample_logistic` WHERE barcodeNo=plo.`BarcodeNo` AND TransferredBy>0 LIMIT 1)IsTransferred, ");

            sb.Append(" plo.IsRefund IsARefundEntry,pm.Phone ,pm.Mobile ,pm.Email ,pm.Age ,pm.AgeYear ,pm.AgeMonth ,pm.AgeDays , ");
            sb.Append(" pm.TotalAgeInDays ,DATE_FORMAT(pm.DOB,'%d-%b-%Y')DOB ,pm.Gender ,  ");
            // LT
            sb.Append(" plo.`BillNo` ReceiptNo,lt.`CreatedByID`,lt.LedgerTransactionID,lt.LedgerTransactionNo,lt.NetAmount,lt.GrossAmount,lt.IsCredit,'' DiscountReason,lt.DiscountApprovedByID, ");
            sb.Append(" lt.Adjustment,DATE_FORMAT(plo.date,'%d-%b-%Y')DATE, lt.DoctorName,");

            //PLO
            sb.Append(" plo.BarcodeNo,plo.ItemId,plo.ItemCode,plo.ItemName,plo.Investigation_ID,plo.IsPackage,plo.SubCategoryID,SUM(plo.Rate*Quantity)Rate,SUM(plo.DiscountAmt)DiscountAmt,SUM(plo.Amount)Amount,plo.Quantity,plo.IsRefund,plo.ReportType, ");
            sb.Append(" if(plo.IsReporting=0 AND plo.`IsPackage`=0,'N', IF(plo.`IsPackage`=1 AND ( SELECT COUNT(1) FROM patient_labinvestigation_opd plo2 WHERE plo2.LedgerTransactionID = plo.`LedgerTransactionID` AND plo2.ItemID=plo.itemid AND if(plo2.reporttype=5,if(plo2.result_flag=1,'Y','N'),plo2.IsSampleCollected)='Y') >0 ,'Y',if(plo.reporttype=5,if(plo.result_flag=1,'Y','N'), plo.IsSampleCollected))) IsSampleCollected ,TIMESTAMPDIFF(MINUTE,lt.DATE,NOW()) BillTimeDiff ");

            sb.Append(" FROM patient_master pm  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`Patient_ID`=pm.`Patient_ID` ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
            sb.Append(" AND (plo.`LedgerTransactionNo`=@LedgerTransactionNo or plo.Barcodeno=@LedgerTransactionNo)  AND lt.GrossAmount>0 AND plo.IsActive=1 GROUP BY plo.`ItemId` ");  //AND lt.CentreID=@CentreID 

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LedgerTransactionNo", LabNo.Trim()),
                new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0])
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    void bindpaymentmode()
    {


    }


    [WebMethod(EnableSession = true)]
    public static string SaveOPDRefund(object PLO)
    {
        List<OPDRefund> opdrefund = new JavaScriptSerializer().ConvertToType<List<OPDRefund>>(PLO);
        if (opdrefund.Count == 0)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Please Select Item" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);



        string newReceiptNo = string.Empty;


        try
        {
            if (AllLoad_Data.IsInvoiceCreated(con, opdrefund[0].LabID) > 0)
            {
                return JsonConvert.SerializeObject(new { Status = false, response = "Invoice Created, So Refund not Possible" });
            }

            string Itemid = string.Join(",", opdrefund.AsEnumerable().Select(x => x.ItemID));

            int[] ItemIDTags = opdrefund.AsEnumerable().Select(x => Util.GetInt(x.ItemID)).ToArray();
            string[] ItemIDParamNames = ItemIDTags.Select((s, i) => "@tag" + i).ToArray();
            string ItemIDClause = string.Join(", ", ItemIDParamNames);


            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT  lt.CentreID,lt.Panel_ID,plo.IsPackage,plo.ItemId ,plo.Investigation_ID, plo.IsRefund,plo.IsSampleCollected,SUM(Rate)Rate,SUM(Amount)Amount,SUM(DiscountAmt)DiscountAmt,ItemName,lt.IsCredit,plo.BaseCurrencyRound,lt.Adjustment,plo.S_CountryID,plo.S_Currency,plo.S_Notation,plo.C_Factor FROM ");
            sb.Append(" patient_labinvestigation_opd plo INNER JOIN f_ledgertransaction lt ON plo.LedgerTransactionID=lt.LedgerTransactionID ");
            sb.Append(" WHERE plo.`LedgerTransactionID`=@LedgerTransactionID AND plo.ItemId IN({0}) AND Plo.IsActive=1 GROUP BY plo.`ItemId`");
            DataTable dtdetail = new DataTable();
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), ItemIDClause), con))
            {
                for (int i = 0; i < ItemIDParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(ItemIDParamNames[i], ItemIDTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@LedgerTransactionID", opdrefund[0].LabID);
                da.Fill(dtdetail);
            }

            if (dtdetail.Rows.Count > 0)
            {

                if (dtdetail.AsEnumerable().Where(r => r["IsRefund"].Equals(1)).Count() > 0)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = string.Concat(dtdetail.Rows[0]["ItemName"], " already refunded") }); ;

                }
                //if (dtdetail.AsEnumerable().Where(r => Util.GetString(r["IsSampleCollected"]) == "Y").Count() > 0)
                //{
                //    tnx.Rollback();
                //    return JsonConvert.SerializeObject(new { status = false, response = string.Concat(dtdetail.Rows[0]["ItemName"], " not refunded, Sample receive") });

                //}
                decimal Rate = dtdetail.AsEnumerable().Sum(x => Util.GetDecimal(x["Rate"]));
                decimal Amount = dtdetail.AsEnumerable().Sum(x => Util.GetDecimal(x["Amount"]));
                decimal DiscountAmt = dtdetail.AsEnumerable().Sum(x => Util.GetDecimal(x["DiscountAmt"]));

                List<int> PackageItemList = new List<int>();
                List<int> ItemList = new List<int>();

                for (int i = 0; i < dtdetail.Rows.Count; i++)
                {
                    if (dtdetail.Rows[i]["IsPackage"].ToString() == "1")
                    {
                        PackageItemList.Add(Util.GetInt(dtdetail.Rows[i]["ItemId"].ToString()));
                    }
                    else
                    {
                        ItemList.Add(Util.GetInt(dtdetail.Rows[i]["Investigation_ID"].ToString()));
                    }
                }


                DateTime billDate = DateTime.Now;
                string DebitBillNo = AllLoad_Data.getBillNo(Util.GetInt(dtdetail.Rows[0]["CentreID"]), "D", con, tnx);
                if (DebitBillNo == string.Empty)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "BillNo Error" });
                }

                sb = new StringBuilder();
                sb.Append(" INSERT INTO patient_labinvestigation_opd(LedgerTransactionID,LedgerTransactionNo,BillNo,BarcodeNo,ItemId,ItemName,Investigation_ID,IsPackage,Date,SubCategoryID,SubCategoryName,Rate,");
                sb.Append(" Amount,DiscountAmt,CouponAmt,Quantity,DiscountByLab,IsRefund,IsReporting,IsActive,BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                sb.Append(" SampleTypeID,SampleTypeName,SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,isEmail,");
                sb.Append(" isRerun,ReRunReason,CombinationSample,CurrentSampleDept,ToSampleDept,UpdateID,UpdateName,UpdateRemarks,ipAddress,Barcode_Group,IsLabOutSource,");
                sb.Append(" barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,");
                sb.Append(" HistoCytoStatus,PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                sb.Append(" MachineID_Manual,IsScheduleRate,MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                sb.Append(" PackageMRPPercentage,PackageMRPNet,ItemCode,SRADate,CreatedBy,CreatedByID,BaseCurrencyRound,S_CountryID) ");
                sb.Append(" ");
                sb.Append(" SELECT LedgerTransactionID,LedgerTransactionNo,@BillNo,'',ItemId,ItemName,Investigation_ID,IsPackage,@BillDate,SubCategoryID,SubCategoryName,Rate,");
                sb.Append(" SUM(Amount)*-1 Amount,SUM(DiscountAmt)*-1 DiscountAmt,CouponAmt,Quantity*-1,DiscountByLab,2,0,0,@BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                sb.Append(" 0,'',SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,CurrentSampleDept,ToSampleDept,0,'','',@ipAddress,'',IsLabOutSource,");
                sb.Append(" barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,");
                sb.Append(" HistoCytoStatus,PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                sb.Append(" MachineID_Manual,IsScheduleRate,0 MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                sb.Append(" PackageMRPPercentage,PackageMRPNet,ItemCode,SRADate,@CreatedBy,@CreatedByID,@BaseCurrencyRound,S_CountryID ");
                sb.Append(" FROM patient_labinvestigation_opd WHERE LedgerTransactionID=@LedgerTransactionID AND ItemID IN ({0}) AND IsActive=1 AND IF(isPackage=1,`SubCategoryID`=15,`SubCategoryID`!=15) ");
                sb.Append(" GROUP BY ItemID ");

                using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), ItemIDClause), con, tnx))
                {
                    for (int i = 0; i < ItemIDParamNames.Length; i++)
                    {
                        cmd.Parameters.Add(new MySqlParameter(ItemIDParamNames[i], ItemIDTags[i]));
                    }
                    cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionID", opdrefund[0].LabID));
                    cmd.Parameters.Add(new MySqlParameter("@BillNo", DebitBillNo));
                    cmd.Parameters.Add(new MySqlParameter("@BillDate", billDate));
                    cmd.Parameters.Add(new MySqlParameter("@BillType", "Debit-Test Refund"));
                    cmd.Parameters.Add(new MySqlParameter("@CreatedBy", UserInfo.LoginName));
                    cmd.Parameters.Add(new MySqlParameter("@CreatedByID", UserInfo.ID));
                    cmd.Parameters.Add(new MySqlParameter("@BaseCurrencyRound", Resources.Resource.BaseCurrencyRound));
                    cmd.Parameters.Add(new MySqlParameter("@ipAddress", StockReports.getip()));

                    cmd.ExecuteNonQuery();
                }



                string Investigation_ID = String.Join(",", ItemList);
                //  string PackageItemID = String.Join(",", PackageItemList);

                //  if (PackageItemID == string.Empty)
                //       PackageItemID = "0";


                //string[] Investigation_IDTags = Investigation_ID.Split(',');
                //string[] Investigation_IDParamNames = Investigation_IDTags.Select(
                //  (s, i) => "@tag" + i).ToArray();
                //string Investigation_IDClause = string.Join(", ", Investigation_IDParamNames);

                //sb = new StringBuilder();
                //sb.Append(" UPDATE patient_labinvestigation_opd SET IsRefund=1,IsActive=1,IsReporting=0,");
                //sb.Append(" UpdateID=@UpdateID,UpdateName=@UpdateName,UpdateDate=now(),UpdateRemarks='OPD Refund' ");
                //sb.Append(" WHERE LedgerTransactionID=@LedgerTransactionID AND Investigation_id IN ({0}) AND SubcategoryID<>15 ");


                //using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), Investigation_IDClause), con, tnx))
                //{
                //    for (int i = 0; i < Investigation_IDParamNames.Length; i++)
                //    {
                //        cmd.Parameters.AddWithValue(Investigation_IDParamNames[i], Investigation_IDTags[i]);
                //    }
                //    cmd.Parameters.AddWithValue("@UpdateID", UserInfo.ID);
                //    cmd.Parameters.AddWithValue("@UpdateName", UserInfo.LoginName);
                //    cmd.Parameters.AddWithValue("@LedgerTransactionID", opdrefund[0].LabID);
                //    cmd.ExecuteNonQuery();
                //}

                //string[] PackageItemIDTags = PackageItemID.Split(',');
                //string[] PackageItemIDParamNames = PackageItemIDTags.Select(
                //  (s, i) => "@tag" + i).ToArray();
                //string PackageItemIDClauses = string.Join(", ", PackageItemIDParamNames);

                sb = new StringBuilder();
                sb.Append("UPDATE patient_labinvestigation_opd SET IsRefund=1,IsActive=0,IsReporting=0,");
                sb.Append(" UpdateID=@UpdateID,UpdateName=@UpdateName,UpdateDate=now(),UpdateRemarks='OPD Refund' ");
                sb.Append(" WHERE LedgerTransactionID=@LedgerTransactionID AND ItemID IN ({0}) AND IsActive=1 AND IsRefund=0 ");

                using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), ItemIDClause), con, tnx))
                {
                    for (int i = 0; i < ItemIDParamNames.Length; i++)
                    {
                        cmd.Parameters.Add(new MySqlParameter(ItemIDParamNames[i], ItemIDTags[i]));
                    }

                    cmd.Parameters.AddWithValue("@UpdateID", UserInfo.ID);
                    cmd.Parameters.AddWithValue("@UpdateName", UserInfo.LoginName);
                    cmd.Parameters.AddWithValue("@LedgerTransactionID", opdrefund[0].LabID);
                    cmd.ExecuteNonQuery();
                }

                sb = new StringBuilder();
                sb.Append("SELECT SUM(amount) FROM patient_labinvestigation_opd WHERE LedgerTransactionID = @LedgerTransactionID AND IsActive=1");
                decimal PendingAmt = Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                      new MySqlParameter("@LedgerTransactionID", opdrefund[0].LabID)));

                sb = new StringBuilder();
                sb.Append("SELECT adjustment FROM f_ledgertransaction WHERE LedgerTransactionID = @LedgerTransactionID");
                decimal Paid = Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                      new MySqlParameter("@LedgerTransactionID", opdrefund[0].LabID)));

                decimal RefundAmt = Paid - PendingAmt;

                if (Util.GetInt(dtdetail.Rows[0]["IsCredit"]) == 0 && Util.GetDecimal(RefundAmt) > 0)
                {

                    Receipt objRC = new Receipt(tnx)
                    {
                        LedgerNoCr = "OPD003",
                        LedgerTransactionID = opdrefund[0].LabID,
                        LedgerTransactionNo = opdrefund[0].OldLabNo,
                        CreatedByID = UserInfo.ID,
                        Patient_ID = opdrefund[0].Patient_ID,
                        PayBy = opdrefund[0].PayBy,
                        PaymentMode = opdrefund[0].PaymentMode,
                        PaymentModeID = opdrefund[0].PaymentModeID,
                        Amount = RefundAmt * -1,
                        BankName = opdrefund[0].BankName,
                        CardNo = opdrefund[0].CardNo,
                        CardDate = opdrefund[0].CardDate,
                        IsCancel = 0,
                        Narration = opdrefund[0].Reason,
                        CentreID = Util.GetInt(dtdetail.Rows[0]["CentreID"]),
                        Panel_ID = Util.GetInt(dtdetail.Rows[0]["Panel_ID"]),
                        CreatedDate = billDate,
                        S_Amount = RefundAmt * -1,
                        S_CountryID = Util.GetInt(dtdetail.Rows[0]["S_CountryID"]),
                        S_Currency = Resources.Resource.BaseCurrencyNotation,
                        S_Notation = Resources.Resource.BaseCurrencyNotation,
                        C_Factor = 0,
                        Currency_RoundOff = 0,
                        CurrencyRoundDigit = Util.GetByte(dtdetail.Rows[0]["BaseCurrencyRound"]),
                        CreatedBy = UserInfo.LoginName
                    };
                    string ReceiptNo = objRC.Insert();
                    if (ReceiptNo == string.Empty)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "Receipt Error" });
                    }
                }

                sb = new StringBuilder();
                sb.Append(" UPDATE f_ledgertransaction SET grossAmount=(SELECT  IFNULL(SUM(Rate*Quantity),0)  FROM patient_labinvestigation_opd WHERE LedgerTransactionID = @LedgerTransactionID AND IsActive=1), ");
                sb.Append(" netAmount=(SELECT  IFNULL(SUM(amount),0) FROM patient_labinvestigation_opd WHERE LedgerTransactionID = @LedgerTransactionID AND IsActive=1),");
                sb.Append(" discountonTotal=(SELECT IFNULL(sum(discountAmt),0) FROM patient_labinvestigation_opd WHERE LedgerTransactionID = @LedgerTransactionID AND IsActive=1)");
                sb.Append(" ,Adjustment = (SELECT IFNULL(SUM(amount),0) FROM f_receipt WHERE LedgerTransactionID = @LedgerTransactionID AND IsCancel=0 ) ");
                sb.Append(" WHERE LedgerTransactionID=@LedgerTransactionID ");

                int b1 = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@LedgerTransactionID", opdrefund[0].LabID));
                if (b1 == 0)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "LT Error" });
                }

                Panel_Share ps = new Panel_Share();
                JSONResponse IPS = JsonConvert.DeserializeObject<JSONResponse>(ps.InsertPanel_Share(Util.GetInt(opdrefund[0].LabID), tnx, con));
                if (IPS.status == false)
                {
                    tnx.Rollback();
                    return "0";
                }

            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,Remarks)VALUES(@LedgertransactionNo,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,now(),@DispatchCode,@Remarks) ",
                                                           new MySqlParameter("@LedgertransactionNo", opdrefund[0].OldLabNo),
                                                           new MySqlParameter("@Remarks", opdrefund[0].Reason),
                                                           new MySqlParameter("@Status", " Cancel  Patient"), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                                                           new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@DispatchCode", string.Empty));


            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = "true", response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class OPDRefund
    {
        public int ItemID { get; set; }
        public string OldLabNo { get; set; }
        public string Reason { get; set; }
        public int RefundBy { get; set; }
        public string OldReceiptNO { get; set; }
        public int LabID { get; set; }
        public int Panel_ID { get; set; }
        public int CentreID { get; set; }
        public int PaymentModeID { get; set; }
        public string PaymentMode { get; set; }
        public string BankName { get; set; }
        public string CardNo { get; set; }
        public DateTime CardDate { get; set; }
        public string PayBy { get; set; }
        public string Patient_ID { get; set; }

    }
}
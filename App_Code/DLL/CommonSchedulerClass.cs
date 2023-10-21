using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Net.NetworkInformation;
using System.Text;
using System.Timers;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public class CommonSchedulerClass
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    public MySqlConnection conn;
    public static string EmployeeID = "EMP001";
    public static string EmployeeName = "MobileBooking";
    public static string PackageSubcategoryID = "LSHHI24";
    string _DATE;
    string _CenterId;
    string _PName;
    string _Title;
    string _Panel_Id;
    string _Gender;
    string _Doctor;
    string _CentreCode;
    string _BarcodeNo;
    string _MobileNo;
    string _Address;
    string _Test_ID;
    string _IsCredit;
    string _AGE_in_Days;
    float _TotalAmount;
    string _AppointmentId;
    string _OtherDoctor;
    string _CollectionDate;
    string _PatientID;
    string _labNo;
    string _Dob;
    //string _CollectionTime;
    public string DATE { get { return _DATE; } set { _DATE = value; } }
    public string AppointmentId { get { return _AppointmentId; } set { _AppointmentId = value; } }
    public string Panel_Id { get { return _Panel_Id; } set { _Panel_Id = value; } }
    public string Title { get { return _Title; } set { _Title = value; } }
    public string PName { get { return _PName; } set { _PName = value; } }
    public string MobileNo { get { return _MobileNo; } set { _MobileNo = value; } }
    public string Gender { get { return _Gender; } set { _Gender = value; } }
    public string Doctor { get { return _Doctor; } set { _Doctor = value; } }
    public string OtherDoctor { get { return _OtherDoctor; } set { _OtherDoctor = value; } }
    public string CenterId { get { return _CenterId; } set { _CenterId = value; } }
    public string CentreCode { get { return _CentreCode; } set { _CentreCode = value; } }
    public string Address { get { return _Address; } set { _Address = value; } }
    public string BarcodeNo { get { return _BarcodeNo; } set { _BarcodeNo = value; } }
    public string Test_ID { get { return _Test_ID; } set { _Test_ID = value; } }
    public string IsCredit { get { return _IsCredit; } set { _IsCredit = value; } }
    public string AGE_in_Days { get { return _AGE_in_Days; } set { _AGE_in_Days = value; } }
    public float TotalAmount { get { return _TotalAmount; } set { _TotalAmount = value; } }
    public string CollectionDateTime { get { return _CollectionDate; } set { _CollectionDate = value; } }
    public string PatientIDNew { get { return _PatientID; } set { _PatientID = value; } }
    public string LabNo { get { return _labNo; } set { _labNo = value; } }
    public string dob { get { return _Dob;} set{_Dob=value;} }

    public CommonSchedulerClass()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    //string businessunit, string client, string barcode, string title, string name, string mobileno, string age, string gender, string dob, string address, string testData, string doctorid, string panelId
    public string HisToLisBooking()
    {
//        MySqlConnection con = Util.GetMySqlCon();
//        con.Open();
//        string PatientID = string.Empty;
//        int isError = 0;
//        try
//        {
            

//            StringBuilder sb = new StringBuilder();
//            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
//            //string BarcodeNo = "";
//            //string CreditCardNo = "", ChequeNo = "";
//            //string CreditCardBankName = "", ChequeBankName = "";
//            string TransactionId = string.Empty, BillNO = string.Empty, LedTxnID = string.Empty, IsPackage = string.Empty;
//            string UniqueID = Guid.NewGuid().ToString();
//            string retvalue = string.Empty;
//            int isUrgent = 0;
//            string testexist = "";
//            string age = "";
//            sb = new StringBuilder();
//            if (BarcodeNo.Trim() == "")
//            {
//                BarcodeNo = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_barcodeno()"));

//            }
//            //try
//            //{
//            //     age= Util.GetString(AGE_in_Days.Split(' ')[0])+Util.GetString(AGE_in_Days.Split(' ')[1])+Util.GetString(AGE_in_Days.Split(' ')[2]);
              
//            //}
//            //catch (Exception)
//            //{
//            //    age = "0";
//            //}
          
//            // ------------------------------------- code for Patient Insert--------------------------------------------
          
//            try
//            {
//                Patient_Master objPM = new Patient_Master(tnx);
//                objPM.Title = Util.GetString(Title);
//                objPM.Gender = Util.GetString(Gender); ;
//                objPM.PName = Util.GetString(PName);
//                objPM.House_No = Util.GetString(Address);
//                objPM.City = "";
//                objPM.Phone = "";
//                objPM.Mobile = Util.GetString(MobileNo);
//                objPM.Email = "";
//                objPM.State = "";
//                objPM.City = "";
//                objPM.Locality="";
//                objPM.CountryID=0;
//                objPM.StateID =0;
//                objPM.CityID =0;
//                objPM.LocalityID=0;
//                objPM.Age = "";
//                objPM.AgeYear =0;
//                objPM.AgeMonth = 0;
//                objPM.AgeDays = 0;
//                objPM.TotalAgeInDays = Util.GetInt(AGE_in_Days);               
//                objPM.DOB = Util.GetDateTime(dob);
//                objPM.Pincode = 0;
//                objPM.Relation = "";
//                objPM.IsDOBActual = 1;
//                objPM.UpdateID = EmployeeID;
//                objPM.UpdateName = EmployeeName;
//                objPM.Updatedate = System.DateTime.Now;
//                objPM.UpdateRemarks = "MobileBooking";
//                objPM.CentreID = Util.GetInt(CenterId);
//                PatientID = objPM.Insert();

//            }
//            catch (Exception ex)
//            {
//                ClassLog cl = new ClassLog();
//                cl.errLog(ex.GetBaseException());
//                isError = 1;
//                tnx.Rollback();
//                tnx.Dispose();
//                con.Close();
//                con.Dispose();
//            }

//            //-----------------------------
//            if (isError == 0)
//            {
//                if (retvalue == string.Empty)
//                {
//                    try
//                    {
                       
//                        Ledger_Transaction objLedTran = new Ledger_Transaction(tnx);
//                        objLedTran.LedgerNoCr = "OPD003";
//                        objLedTran.LedgerNoDr = "HOSP0001";
//                        objLedTran.Hospital_ID = "HOS/070920/00001";
//                        if (IsPackage == "1")
//                        {
//                            objLedTran.TypeOfTnx = "OPD-Package";
//                        }
//                        else
//                        {
//                            objLedTran.TypeOfTnx = "OPD-LAB";
//                        }
//                        objLedTran.Date = DateTime.Now;
//                        objLedTran.Time = DateTime.Now;
//                        objLedTran.BillNo = BillNO;
//                        objLedTran.Discount = 0F;
//                        objLedTran.GrossAmount = 0;
//                        objLedTran.NetAmount = 0;
//                        objLedTran.IsCancel = 0;
//                        objLedTran.DiscountReason = "";
//                        objLedTran.AmtCash = 0;
//                        objLedTran.AmtCheque = 0;
//                        objLedTran.AmtCredit = 0;
//                        objLedTran.AmtCreditCard = 0;
//                        objLedTran.Remarks = "";
//                        objLedTran.Panel_ID = Panel_Id;
//                        objLedTran.centreID = CenterId;
//                        objLedTran.Transaction_ID = TransactionId;
//                        objLedTran.Creator_UserID = EmployeeID;
//                        objLedTran.Patient_ID = PatientID;
//                        objLedTran.ApprovedBy = "";
//                        objLedTran.UniqueHash = UniqueID;
//                        objLedTran.PatientType = "Normal";//dt.Rows[a]["PatientType"].ToString()
//                        objLedTran.ReportReceivingType = "MobileBooking";
//                        objLedTran.PRO = "1";
//                        objLedTran.HomeVisitBoyID = "";
//                        objLedTran.UpdateID = EmployeeID;
//                        objLedTran.UpdateName = EmployeeName;
//                        objLedTran.Updatedate = System.DateTime.Now;
//                        objLedTran.UpdateRemarks = "MobileBooking";
//                        retvalue = objLedTran.Insert();
//                        string qry=" UPDATE f_ledgertransaction SET AppointMent_NewId='" + AppointmentId + "' WHERE LedgerTransactionNo ='" + retvalue + "'";
//                        MySqlCommand cmd = new MySqlCommand(qry, con, tnx);
//                        int a= cmd.ExecuteNonQuery();
//                    }
//                    catch (Exception ex)
//                    {
//                        ClassLog objClassLog = new ClassLog();
//                        objClassLog.errLog(ex.GetBaseException());
//                        isError = 1;
//                        tnx.Rollback();
//                        tnx.Dispose();
//                        con.Close();
//                        con.Dispose();
//                    }
//                }
//            }
//            if (isError == 0)
//            {
//                if (Util.GetString(Test_ID) != "")
//                {
//                    foreach (string s in Util.GetString(Test_ID).Split(','))
//                    {
//                        if (s != "")
//                        {
//                            testexist = s;
//                            sb = new StringBuilder();
//                            sb.Append(" SELECT IFNULL(inv.Type,'N') Type,im.`ItemID`,im.`Type_ID`,im.`TypeName`,scm.`SubCategoryID` ,scm.`Name` Department,IFNULL(r.`Rate`,'0.00') Rate,IFNULL(mp.`Rate`,'0.00') MrpRate ");
//                            sb.Append(" FROM  f_itemmaster im   ");
//                            sb.Append(" LEFT JOIN investigation_master inv ON inv.`Investigation_ID`=im.`Type_ID` ");
//                            sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=im.`SubCategoryID` ");
//                            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=78 ");
//                            sb.Append(" LEFT JOIN f_ratelist r ON r.`ItemID`=im.`ItemID` AND r.Panel_ID=fpm.ReferenceCodeOPD ");
//                            sb.Append(" LEFT JOIN f_ratelist mp ON mp.`ItemID`=im.`ItemID` AND mp.Panel_ID=78 ");
//                            sb.Append(" WHERE im.`ItemID`='" + Util.GetString(testexist) + "' LIMIT 1; ");
//                            DataTable dtLIS = StockReports.GetDataTable(sb.ToString());
//                            if (dtLIS.Rows.Count > 0)
//                            {
//                                float Rate = Util.GetFloat(dtLIS.Rows[0]["Rate"]);
//                                float MrpRate = Util.GetFloat(dtLIS.Rows[0]["MrpRate"]);
//                                string ItemID = Util.GetString(dtLIS.Rows[0]["ItemID"]);
//                                string Type_ID = Util.GetString(dtLIS.Rows[0]["Type_ID"]);
//                                string TypeName = Util.GetString(dtLIS.Rows[0]["TypeName"]);
//                                string SubCategoryID = Util.GetString(dtLIS.Rows[0]["SubCategoryID"]);
//                                string Department = Util.GetString(dtLIS.Rows[0]["Department"]);
//                                string _IsSampleCollected = Util.GetString(dtLIS.Rows[0]["Type"]);
//                                IsPackage = "0";
//                                if (Util.GetString(dtLIS.Rows[0]["SubCategoryID"]) == PackageSubcategoryID)
//                                {
//                                    IsPackage = "1";
//                                }
//                                double ageindays = 0;
//                                if (isError == 0)
//                                {
//                                    try
//                                    {
//                                        try
//                                        {
//                                            LedTxnID = retvalue;
//                                            LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tnx);
//                                            objLTDetail.centreID = CenterId;
//                                            objLTDetail.Hospital_ID = "HOS/070920/00001";
//                                            objLTDetail.LedgerTransactionNo = LedTxnID;
//                                            objLTDetail.ItemID = ItemID;
//                                            objLTDetail.SubCategoryID = SubCategoryID;
//                                            objLTDetail.ItemName = TypeName;
//                                            objLTDetail.Rate = Rate;
//                                            objLTDetail.MrpRate = MrpRate;
//                                            objLTDetail.Quantity = Util.GetFloat(1);
//                                            if (IsPackage == "0")
//                                            {
//                                                objLTDetail.IsPackage = 0;
//                                            }
//                                            else
//                                            {
//                                                objLTDetail.IsPackage = 1;
//                                                objLTDetail.PackageID = Type_ID;
//                                            }
//                                            objLTDetail.DiscountPercentage = 0f;
//                                            objLTDetail.Amount = Rate;
//                                            objLTDetail.Transaction_ID = TransactionId;
//                                            objLTDetail.UserID = EmployeeID;
//                                            objLTDetail.EntryDate = DateTime.Now;
//                                            objLTDetail.isUrgent = 0;
//                                            objLTDetail.UpdateID = EmployeeID;
//                                            objLTDetail.UpdateName = "MobileBooking";
//                                            objLTDetail.Updatedate = System.DateTime.Now;
//                                            objLTDetail.UpdateRemarks = "MobileBooking";
//                                            int ID = objLTDetail.Insert();
//                                        }
//                                        catch (Exception ex)
//                                        {
//                                            ClassLog objClassLog = new ClassLog();
//                                            objClassLog.errLog(ex.GetBaseException());
//                                            isError = 1;
//                                            tnx.Rollback();
//                                            tnx.Dispose();
//                                            con.Close();
//                                            con.Dispose();
//                                        }
//                                        int PLOID;
//                                        LedTxnID = retvalue;
//                                        if (IsPackage == "0")
//                                        {
//                                            string _DeliveryDate = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT `Get_DeliveryDate`('" + Util.GetInt(CenterId) + "','" + Util.GetString(Type_ID) + "',now())"));
//                                            _DeliveryDate = Util.GetDateTime(_DeliveryDate).ToString("yyyy-MM-dd HH:MM:ss");
//                                            Patient_Lab_InvestigationOPD objPLI = new Patient_Lab_InvestigationOPD(tnx);
//                                            objPLI.Investigation_ID = Type_ID;
//                                            objPLI.Date = DateTime.Now;
//                                            objPLI.Time = DateTime.Now;
//                                            objPLI.Lab_ID = "LAB1";
//                                            objPLI.Transaction_ID = TransactionId;
//                                            if (Util.GetString(_IsSampleCollected) == "N")
//                                            {
//                                                objPLI.IsSampleCollected = "Y";
//                                            }
//                                            else
//                                            {
//                                                objPLI.IsSampleCollected = "N";
//                                            }
//                                            objPLI.SampleBySelf = 0;
//                                            objPLI.SampleDate = Util.GetDateTime(CollectionDateTime);
//                                            objPLI.Patient_ID = PatientID;
//                                            objPLI.Transaction_ID = TransactionId;
//                                            objPLI.Special_Flag = 0;
//                                            objPLI.LedgerTransactionNo = LedTxnID;
//                                            objPLI.ItemId = ItemID;
//                                            objPLI.CentreID = CenterId;
//                                            objPLI.BarcodeNo = BarcodeNo;
//                                            objPLI.isUrgent = Util.GetInt(isUrgent);
//                                            string b = Util.GetDateTime(_DeliveryDate).ToString("yyyy-MM-dd HH:MM:ss");
//                                            objPLI.DeliveryDate = Util.GetDateTime(_DeliveryDate);
//                                            objPLI.UpdateID = EmployeeID;
//                                            objPLI.UpdateName = EmployeeName;
//                                            objPLI.Updatedate = System.DateTime.Now;
//                                            objPLI.UpdateRemarks = "MobileBooking";
//                                            PLOID = objPLI.Insert();
//                                            PLOID = PLOID - 1;
//                                        }
//                                        else
//                                        {
//                                            LedTxnID = retvalue;
//                                            StringBuilder sbPackage = new StringBuilder();
//                                            sbPackage.Append(" SELECT  im.Investigation_Id,im.Type,im.Name,im.isUrgent,(SELECT `Get_DeliveryDate`(" + CenterId + ",im.Investigation_Id,now())) DeliveryDate ,sc.`Abbreviation`,sc.`SubCategoryID` FROM package_labdetail pld ");
//                                            sbPackage.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=pld.InvestigationID  ");
//                                            sbPackage.Append(" AND pld.PlabID='" + Util.GetString(Type_ID) + "' ");
//                                            sbPackage.Append(" INNER JOIN `f_itemmaster` itm ON itm.`Type_ID`=im.`Investigation_Id` ");
//                                            sbPackage.Append(" INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID`=itm.`SubCategoryID` AND sc.`CategoryID`='LSHHI44' ");
//                                            DataSet dsPackageItem = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sbPackage.ToString());
//                                            if ((dsPackageItem != null) && (dsPackageItem.Tables.Count > 0))
//                                            {
//                                                DataTable dtPackItem = dsPackageItem.Tables[0].Copy();
//                                                if (dtPackItem.Rows.Count > 0)
//                                                {
//                                                    foreach (DataRow dr in dtPackItem.Rows)
//                                                    {
//                                                        Patient_Lab_InvestigationOPD objPLI = new Patient_Lab_InvestigationOPD(tnx);
//                                                        _IsSampleCollected = Util.GetString(dr["Type"]);
//                                                        objPLI.Investigation_ID = Util.GetString(dr["Investigation_id"]);
//                                                        objPLI.Date = DateTime.Now;
//                                                        objPLI.Time = DateTime.Now;
//                                                        objPLI.Lab_ID = "LAB1";
//                                                        objPLI.Transaction_ID = TransactionId;
//                                                        if (Util.GetString(_IsSampleCollected) == "N")
//                                                        {
//                                                            objPLI.IsSampleCollected = "Y";
//                                                        }
//                                                        else
//                                                        {
//                                                            objPLI.IsSampleCollected = "N";
//                                                        }
//                                                        objPLI.SampleBySelf = 0;
//                                                        objPLI.IsPackage = 1;
//                                                        objPLI.ItemId = ItemID;
//                                                        objPLI.BarcodeNo = BarcodeNo;
//                                                        objPLI.SampleDate = DateTime.Now;
//                                                        objPLI.Patient_ID = PatientID;
//                                                        objPLI.Transaction_ID = TransactionId;
//                                                        objPLI.Special_Flag = 0;
//                                                        objPLI.CentreID = CenterId;
//                                                        objPLI.LedgerTransactionNo = LedTxnID;
//                                                        objPLI.isUrgent = Util.GetInt(dr["isUrgent"]);
//                                                        objPLI.DeliveryDate = Util.GetDateTime(dr["DeliveryDate"]);
//                                                        objPLI.UpdateID = EmployeeID;
//                                                        objPLI.UpdateName = EmployeeName;
//                                                        objPLI.Updatedate = System.DateTime.Now;
//                                                        objPLI.UpdateRemarks = "MobileBooking";
//                                                        PLOID = objPLI.Insert();
//                                                        PLOID = PLOID - 1;
//                                                    }
//                                                }
//                                                //else
//                                                //{
//                                                //    isError = 1;
//                                                //    tnx.Rollback();
//                                                //    tnx.Dispose();
//                                                //}
//                                            }
//                                        }
//                                    }
//                                    catch (Exception ex)
//                                    {
//                                        ClassLog objClassLog = new ClassLog();
//                                        objClassLog.errLog(ex.GetBaseException());
//                                        isError = 1;
//                                        tnx.Rollback();
//                                        tnx.Dispose();
//                                        con.Close();
//                                        con.Dispose();
//                                    }

//                                }
//                            }
//                            //else
//                            //{
//                            //    isError = 1;
//                            //    tnx.Rollback();
//                            //    tnx.Dispose();
//                            //}

//                        }
//                    }

//                }
//            }
//            if (isError == 0)
//            {

//                try
//                {
//                    StringBuilder sbLTUpdate = new StringBuilder();
//                    sbLTUpdate = new StringBuilder();
//                    sbLTUpdate.Append(@" UPDATE f_ledgertransaction lt
//                                                         SET lt.NetAmount=(SELECT SUM(Amount) FROM f_ledgertnxdetail ltd  WHERE lt.LedgerTransactionNo=ltd.LedgerTransactionNo
//                                                         GROUP BY ltd.LedgerTransactionNo ),
//                                                         lt.GrossAmount=(SELECT SUM(Amount) FROM f_ledgertnxdetail ltd  WHERE lt.LedgerTransactionNo=ltd.LedgerTransactionNo
//                                                        GROUP BY ltd.LedgerTransactionNo ), ");
//                    if (IsCredit == "1")
//                    {
//                        sbLTUpdate.Append(@"            lt.AmtCredit=(SELECT SUM(Amount) FROM f_ledgertnxdetail ltd  WHERE lt.LedgerTransactionNo=ltd.LedgerTransactionNo
//                                                         GROUP BY ltd.LedgerTransactionNo ), ");
//                    }
//                    sbLTUpdate.Append(@"                   lt.Adjustment=0,
//                                                         lt.AmtCash=0,
//                                                         lt.DiscountonTotal=0
//                                                         WHERE   lt.LedgerTransactionNo='" + LedTxnID + "';");
//                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbLTUpdate.ToString());
//                    tnx.Commit();
//                    con.Close();
//                    con.Dispose();
//                }
//                catch (Exception ex)
//                {
//                    ClassLog objClassLog = new ClassLog();
//                    objClassLog.errLog(ex.GetBaseException());
//                    isError = 1;
//                    tnx.Rollback();
//                    tnx.Dispose();
//                    con.Close();
//                    con.Dispose();
//                }

//            }

//        }
//        catch (Exception ex)
//        {
//            ClassLog objClassLog = new ClassLog();
//            objClassLog.errLog(ex.GetBaseException());
//            con.Close();
//            con.Dispose();
//        }
//        if (isError == 0)
//        {
//            return "1";
//        }
//        else
//        {
//            return "0";
//        }
        return "0";
    }

    public string HisToLisBooking_Edit()
    {
//        MySqlConnection con = Util.GetMySqlCon();
//        con.Open();
//        string PatientID = PatientIDNew;
//        int isError = 0;
//        try
//        {
//            StringBuilder sb = new StringBuilder();
//            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
//            //string BarcodeNo = "";
//            //string CreditCardNo = "", ChequeNo = "";
//            //string CreditCardBankName = "", ChequeBankName = "";
//            string TransactionId = string.Empty, BillNO = string.Empty, LedTxnID = string.Empty, IsPackage = string.Empty;
//            string UniqueID = Guid.NewGuid().ToString();
//            string retvalue = string.Empty;
//            int isUrgent = 0;
//            string testexist = "";
//            string age = "";
//            sb = new StringBuilder();
//            LedTxnID = LabNo;
//            //try
//            //{
//            //     age= Util.GetString(AGE_in_Days.Split(' ')[0])+Util.GetString(AGE_in_Days.Split(' ')[1])+Util.GetString(AGE_in_Days.Split(' ')[2]);

//            //}
//            //catch (Exception)
//            //{
//            //    age = "0";
//            //}

//            // ------------------------------------- code for Patient Insert--------------------------------------------
//            try
//            {
//                Patient_Master objPM = new Patient_Master(tnx);
//                objPM.Patient_ID = PatientID;
//                objPM.HospCode = AllGlobalFunction.HospCode;
//                objPM.Gender = Util.GetString(Gender); ;
//                objPM.PName = Util.GetString(PName);
//                objPM.House_No = Util.GetString(Address);
//                objPM.City = "Kolkata";
//                objPM.Phone = "";
//                objPM.Mobile = Util.GetString(MobileNo);
//                objPM.Email = "";
//                objPM.Age = Util.GetString(AGE_in_Days);
//                objPM.DOB = Util.GetDateTime("0001/01/01");
//                objPM.Title = Util.GetString(Title);
//                objPM.CardPaid = "0";
//                objPM.FeesPaid = 0F;
//                objPM.HospitalOfEnroll_ID = "HOS/070920/00001";
//                objPM.Relation = "";
//                objPM.RelationName = "MobileBooking";
//                objPM.DateEnrolled = DateTime.Now;
//                objPM.isActual = 1;
//                objPM.UpdateID = EmployeeID;
//                objPM.UpdateName = EmployeeName;
//                objPM.Updatedate = System.DateTime.Now;
//                objPM.UpdateRemarks = "MobileBooking";
//                objPM.centreID = CenterId;
//                int result1 = objPM.Update();

//            }
//            catch (Exception ex)
//            {
//                ClassLog cl = new ClassLog();
//                cl.errLog(ex.GetBaseException());
//                isError = 1;
//                tnx.Rollback();
//                tnx.Dispose();
//                con.Close();
//                con.Dispose();
//            }
//            //-------------------LedgerTransactionDetailsUpdate---------------------------

//            //-----------------------------
//            if (isError == 0)
//            {
//                if (retvalue == string.Empty)
//                {
//                    try
//                    {
//                        try
//                        {

//                            string sqlPID = "select Patient_id , Transaction_ID , Date_format(date,'%d-%b-%Y')  date,Time from f_ledgertransaction where LedgerTransactionNO='" + LabNo + "'";
//                            DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sqlPID).Tables[0];
                            
//                            string sqlUpdatePatientMedicalHistory = " update patient_medical_history set ReferedBy = '" + Doctor + "',OtherDr='" + OtherDoctor + "',UpdateID='" + EmployeeID + "',UpdateName='" + EmployeeName + "' where Transaction_ID='" + dt.Rows[0]["Transaction_ID"].ToString() + "'";

//                            MySqlCommand cmd = new MySqlCommand(sqlUpdatePatientMedicalHistory, con, tnx);
//                            int a = cmd.ExecuteNonQuery();
//                        }
//                        catch (Exception ex)
//                        {
//                            ClassLog objClassLog = new ClassLog();
//                            objClassLog.errLog(ex.GetBaseException());
//                            isError = 1;
//                            tnx.Rollback();
//                            tnx.Dispose();
//                            con.Close();
//                            con.Dispose();
//                        }

                        
//                    }
//                    catch (Exception ex)
//                    {
//                        ClassLog objClassLog = new ClassLog();
//                        objClassLog.errLog(ex.GetBaseException());
//                        isError = 1;
//                        tnx.Rollback();
//                        tnx.Dispose();
//                        con.Close();
//                        con.Dispose();
//                    }
//                }
//            }
//            if (isError == 0)
//            {

//                string sqlDeleteLedgerrtnxDetail = " delete from f_ledgertnxdetail where LedgerTransactionNo='" + LabNo + "'";
//                MySqlCommand cmd = new MySqlCommand(sqlDeleteLedgerrtnxDetail, con, tnx);
//                int a = cmd.ExecuteNonQuery();
//                if (Util.GetString(Test_ID) != "")
//                {

//                    foreach (string s in Util.GetString(Test_ID).Split(','))
//                    {
//                        if (s != "")
//                        {
//                            testexist = s;
//                        }
//                    }
//                    foreach (string s in Util.GetString(Test_ID).Split(','))
//                    {
//                        if (s != "")
//                        {
//                            testexist = s;
//                            sb = new StringBuilder();
//                            sb.Append(" SELECT IFNULL(inv.Type,'N') Type,im.`ItemID`,im.`Type_ID`,im.`TypeName`,scm.`SubCategoryID` ,scm.`Name` Department,IFNULL(r.`Rate`,'0.00') Rate,IFNULL(mp.`Rate`,'0.00') MrpRate ");
//                            sb.Append(" FROM  f_itemmaster im   ");
//                            sb.Append(" LEFT JOIN investigation_master inv ON inv.`Investigation_ID`=im.`Type_ID` ");
//                            sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=im.`SubCategoryID` ");
//                            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=78 ");
//                            sb.Append(" LEFT JOIN f_ratelist r ON r.`ItemID`=im.`ItemID` AND r.Panel_ID=fpm.ReferenceCodeOPD ");
//                            sb.Append(" LEFT JOIN f_ratelist mp ON mp.`ItemID`=im.`ItemID` AND mp.Panel_ID=78 ");
//                            sb.Append(" WHERE im.`ItemID`='" + Util.GetString(testexist) + "' LIMIT 1; ");
//                            DataTable dtLIS = StockReports.GetDataTable(sb.ToString());
//                            if (dtLIS.Rows.Count > 0)
//                            {
//                                float Rate = Util.GetFloat(dtLIS.Rows[0]["Rate"]);
//                                float MrpRate = Util.GetFloat(dtLIS.Rows[0]["MrpRate"]);
//                                string ItemID = Util.GetString(dtLIS.Rows[0]["ItemID"]);
//                                string Type_ID = Util.GetString(dtLIS.Rows[0]["Type_ID"]);
//                                string TypeName = Util.GetString(dtLIS.Rows[0]["TypeName"]);
//                                string SubCategoryID = Util.GetString(dtLIS.Rows[0]["SubCategoryID"]);
//                                string Department = Util.GetString(dtLIS.Rows[0]["Department"]);
//                                string _IsSampleCollected = Util.GetString(dtLIS.Rows[0]["Type"]);
//                                IsPackage = "0";
//                                if (Util.GetString(dtLIS.Rows[0]["SubCategoryID"]) == PackageSubcategoryID)
//                                {
//                                    IsPackage = "1";
//                                }
//                                double ageindays = 0;
//                                if (isError == 0)
//                                {
//                                    try
//                                    {
//                                        try
//                                        {
//                                            LedTxnID = retvalue;
//                                            LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tnx);
//                                            objLTDetail.centreID = CenterId;
//                                            objLTDetail.Hospital_ID = "HOS/070920/00001";
//                                            objLTDetail.LedgerTransactionNo = LedTxnID;
//                                            objLTDetail.ItemID = ItemID;
//                                            objLTDetail.SubCategoryID = SubCategoryID;
//                                            objLTDetail.ItemName = TypeName;
//                                            objLTDetail.Rate = Rate;
//                                            objLTDetail.MrpRate = MrpRate;
//                                            objLTDetail.Quantity = Util.GetFloat(1);
//                                            if (IsPackage == "0")
//                                            {
//                                                objLTDetail.IsPackage = 0;
//                                            }
//                                            else
//                                            {
//                                                objLTDetail.IsPackage = 1;
//                                                objLTDetail.PackageID = Type_ID;
//                                            }
//                                            objLTDetail.DiscountPercentage = 0f;
//                                            objLTDetail.Amount = Rate;
//                                            objLTDetail.Transaction_ID = TransactionId;
//                                            objLTDetail.UserID = EmployeeID;
//                                            objLTDetail.EntryDate = DateTime.Now;
//                                            objLTDetail.isUrgent = 0;
//                                            objLTDetail.UpdateID = EmployeeID;
//                                            objLTDetail.UpdateName = "MobileBooking";
//                                            objLTDetail.Updatedate = System.DateTime.Now;
//                                            objLTDetail.UpdateRemarks = "MobileBooking";
//                                            int ID = objLTDetail.Insert();
//                                        }
//                                        catch (Exception ex)
//                                        {
//                                            ClassLog objClassLog = new ClassLog();
//                                            objClassLog.errLog(ex.GetBaseException());
//                                            isError = 1;
//                                            tnx.Rollback();
//                                            tnx.Dispose();
//                                            con.Close();
//                                            con.Dispose();
//                                        }
//                                        int PLOID;
//                                        LedTxnID = retvalue;
//                                        string invList = " SELECT Investigation_ID,ID as PLOID,Test_ID FROM patient_labinvestigation_opd WHERE LedgerTransactionNo='" + LabNo + "' ";
//                                        DataTable dtInvList = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, invList).Tables[0];

//                                        if (dtInvList.Select("Investigation_ID='" + Util.GetString(Type_ID) + "'").Length == 0)
//                                        {
//                                            if (IsPackage == "0")
//                                            {
//                                                string _DeliveryDate = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT `Get_DeliveryDate`('" + Util.GetInt(CenterId) + "','" + Util.GetString(Type_ID) + "')"));
//                                                _DeliveryDate = Util.GetDateTime(_DeliveryDate).ToString("yyyy-MM-dd HH:MM:ss");



//                                                Patient_Lab_InvestigationOPD objPLI = new Patient_Lab_InvestigationOPD(tnx);
//                                                objPLI.Investigation_ID = Type_ID;
//                                                objPLI.Date = DateTime.Now;
//                                                objPLI.Time = DateTime.Now;
//                                                objPLI.Lab_ID = "LAB1";
//                                                objPLI.Transaction_ID = TransactionId;
//                                                if (Util.GetString(_IsSampleCollected) == "N")
//                                                {
//                                                    objPLI.IsSampleCollected = "Y";
//                                                }
//                                                else
//                                                {
//                                                    objPLI.IsSampleCollected = "N";
//                                                }
//                                                objPLI.SampleBySelf = 0;
//                                                objPLI.SampleDate = DateTime.Now;
//                                                objPLI.Patient_ID = PatientID;
//                                                objPLI.Transaction_ID = TransactionId;
//                                                objPLI.Special_Flag = 0;
//                                                objPLI.LedgerTransactionNo = LedTxnID;
//                                                objPLI.ItemId = ItemID;
//                                                objPLI.CentreID = CenterId;
//                                                objPLI.BarcodeNo = BarcodeNo;
//                                                objPLI.isUrgent = Util.GetInt(isUrgent);
//                                                string b = Util.GetDateTime(_DeliveryDate).ToString("yyyy-MM-dd HH:MM:ss");
//                                                objPLI.DeliveryDate = Util.GetDateTime(_DeliveryDate);
//                                                objPLI.UpdateID = EmployeeID;
//                                                objPLI.UpdateName = EmployeeName;
//                                                objPLI.Updatedate = System.DateTime.Now;
//                                                objPLI.UpdateRemarks = "MobileBooking";
//                                                PLOID = objPLI.Insert();
//                                                PLOID = PLOID - 1;
//                                            }
//                                            else
//                                            {
//                                                LedTxnID = retvalue;
//                                                StringBuilder sbPackage = new StringBuilder();
//                                                sbPackage.Append(" SELECT  im.Investigation_Id,im.Type,im.Name,im.isUrgent,(SELECT `Get_DeliveryDate`(" + CenterId + ",im.Investigation_Id)) DeliveryDate ,sc.`Abbreviation`,sc.`SubCategoryID` FROM package_labdetail pld ");
//                                                sbPackage.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=pld.InvestigationID  ");
//                                                sbPackage.Append(" AND pld.PlabID='" + Util.GetString(Type_ID) + "' ");
//                                                sbPackage.Append(" INNER JOIN `f_itemmaster` itm ON itm.`Type_ID`=im.`Investigation_Id` ");
//                                                sbPackage.Append(" INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID`=itm.`SubCategoryID` AND sc.`CategoryID`='LSHHI44' ");
//                                                DataSet dsPackageItem = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sbPackage.ToString());
//                                                if ((dsPackageItem != null) && (dsPackageItem.Tables.Count > 0))
//                                                {
//                                                    DataTable dtPackItem = dsPackageItem.Tables[0].Copy();
//                                                    if (dtPackItem.Rows.Count > 0)
//                                                    {
//                                                        foreach (DataRow dr in dtPackItem.Rows)
//                                                        {
//                                                            Patient_Lab_InvestigationOPD objPLI = new Patient_Lab_InvestigationOPD(tnx);
//                                                            _IsSampleCollected = Util.GetString(dr["Type"]);
//                                                            objPLI.Investigation_ID = Util.GetString(dr["Investigation_id"]);
//                                                            objPLI.Date = DateTime.Now;
//                                                            objPLI.Time = DateTime.Now;
//                                                            objPLI.Lab_ID = "LAB1";
//                                                            objPLI.Transaction_ID = TransactionId;
//                                                            if (Util.GetString(_IsSampleCollected) == "N")
//                                                            {
//                                                                objPLI.IsSampleCollected = "Y";
//                                                            }
//                                                            else
//                                                            {
//                                                                objPLI.IsSampleCollected = "N";
//                                                            }
//                                                            objPLI.SampleBySelf = 0;
//                                                            objPLI.IsPackage = 1;
//                                                            objPLI.ItemId = ItemID;
//                                                            objPLI.BarcodeNo = BarcodeNo;
//                                                            objPLI.SampleDate = DateTime.Now;
//                                                            objPLI.Patient_ID = PatientID;
//                                                            objPLI.Transaction_ID = TransactionId;
//                                                            objPLI.Special_Flag = 0;
//                                                            objPLI.CentreID = CenterId;
//                                                            objPLI.LedgerTransactionNo = LedTxnID;
//                                                            objPLI.isUrgent = Util.GetInt(dr["isUrgent"]);
//                                                            objPLI.DeliveryDate = Util.GetDateTime(dr["DeliveryDate"]);
//                                                            objPLI.UpdateID = EmployeeID;
//                                                            objPLI.UpdateName = EmployeeName;
//                                                            objPLI.Updatedate = System.DateTime.Now;
//                                                            objPLI.UpdateRemarks = "MobileBooking";
//                                                            PLOID = objPLI.Insert();
//                                                            PLOID = PLOID - 1;
//                                                        }
//                                                    }
//                                                    //else
//                                                    //{
//                                                    //    isError = 1;
//                                                    //    tnx.Rollback();
//                                                    //    tnx.Dispose();
//                                                    //}
//                                                }
//                                            }
//                                        }
//                                    }
//                                    catch (Exception ex)
//                                    {
//                                        ClassLog objClassLog = new ClassLog();
//                                        objClassLog.errLog(ex.GetBaseException());
//                                        isError = 1;
//                                        tnx.Rollback();
//                                        tnx.Dispose();
//                                        con.Close();
//                                        con.Dispose();
//                                    }

//                                }
//                            }
//                            //else
//                            //{
//                            //    isError = 1;
//                            //    tnx.Rollback();
//                            //    tnx.Dispose();
//                            //}

//                        }
//                    }

//                }
//            }
//            if (isError == 0)
//            {

//                try
//                {
//                    StringBuilder sbLTUpdate = new StringBuilder();
//                    sbLTUpdate = new StringBuilder();
//                    sbLTUpdate.Append(@" UPDATE f_ledgertransaction lt
//                                                         SET lt.NetAmount=(SELECT SUM(Amount) FROM f_ledgertnxdetail ltd  WHERE lt.LedgerTransactionNo=ltd.LedgerTransactionNo
//                                                         GROUP BY ltd.LedgerTransactionNo ),
//                                                         lt.GrossAmount=(SELECT SUM(Amount) FROM f_ledgertnxdetail ltd  WHERE lt.LedgerTransactionNo=ltd.LedgerTransactionNo
//                                                        GROUP BY ltd.LedgerTransactionNo ), ");
//                    if (IsCredit == "1")
//                    {
//                        sbLTUpdate.Append(@"            lt.AmtCredit=(SELECT SUM(Amount) FROM f_ledgertnxdetail ltd  WHERE lt.LedgerTransactionNo=ltd.LedgerTransactionNo
//                                                         GROUP BY ltd.LedgerTransactionNo ), ");
//                    }
//                    sbLTUpdate.Append(@"                   lt.Adjustment=0,
//                                                         lt.AmtCash=0,
//                                                         lt.DiscountonTotal=0
//                                                         WHERE   lt.LedgerTransactionNo='" + LedTxnID + "';");
//                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbLTUpdate.ToString());
//                    tnx.Commit();
//                    con.Close();
//                    con.Dispose();
//                }
//                catch (Exception ex)
//                {
//                    ClassLog objClassLog = new ClassLog();
//                    objClassLog.errLog(ex.GetBaseException());
//                    isError = 1;
//                    tnx.Rollback();
//                    tnx.Dispose();
//                    con.Close();
//                    con.Dispose();
//                }

//            }

//        }
//        catch (Exception ex)
//        {
//            ClassLog objClassLog = new ClassLog();
//            objClassLog.errLog(ex.GetBaseException());
//            con.Close();
//            con.Dispose();
//        }
//        if (isError == 0)
//        {
//            return "1";
//        }
//        else
//        {
//            return "0";
//        }
        return "0";
    }
    public string sendReportAlert()
    {

        string LastEamildate = Util.GetString(StockReports.ExecuteScalar(" SELECT updatedate FROM global_data WHERE id=0 "));

        string LastUpdate = Util.GetString(StockReports.ExecuteScalar(" SELECT UpdateDate FROM labreportprint_queue WHERE DATE(dtEntry)=CURRENT_DATE() AND isprint=1 ORDER BY id DESC LIMIT 1 "));

        int isPresent = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(pli.Test_ID) FROM patient_labinvestigation_opd pli WHERE pli.ApprovedDate > '" + Util.GetDateTime(LastUpdate).ToString("yyyy-MM-dd HH:MM:ss") + "' AND pli.ApprovedDate <=NOW()"));

        if (isPresent > 0 && Util.GetDateTime(LastUpdate).AddMinutes(15) < DateTime.Now && Util.GetDateTime(LastEamildate).AddMinutes(15) < DateTime.Now)
        {

            string EmailSubject = string.Empty;
            StringBuilder EmailBody = new System.Text.StringBuilder();
            EmailSubject = Util.GetString("Report Sync Error");
            EmailBody.Append("Report Sync Error");
            try
            {
                ReportEmailClass RMail = new ReportEmailClass();
                string IsSend = RMail.sendEmail("paschim.sachdeva@itdoseinfo.com", EmailSubject.Trim(), EmailBody.ToString(), "", "", "", "", "Normal", "1", "Sync", "Sync");
            }
            catch (Exception ex)
            {
                ClassLog dl = new ClassLog();
                dl.errLog(ex);
                dl.GeneralLog("Sync Error");
            }
        }
        return "";
    }
    public string sendReportMail()
    {
        DataTable dtEmailData = StockReports.GetDataTable("CALL get_email_data_patient();");

        if (dtEmailData.Rows.Count > 0)
        {
            foreach (DataRow drTemp in dtEmailData.Rows)
            {

                string EmailSubject = string.Empty;
                StringBuilder EmailBody = new System.Text.StringBuilder();
                EmailSubject = Util.GetString(drTemp["EmailSubject"]).Replace("{PName}", Util.GetString(drTemp["PName"])).Replace("{LabNo}", Util.GetString(dtEmailData.Rows[0]["LedgerTransactionNo"])); ;
                EmailBody.Append(Util.GetString(drTemp["EmailBody"])).Replace("{LabNo}", Util.GetString(dtEmailData.Rows[0]["LedgerTransactionNo"])); ;
                EmailBody.Replace("{PName}", Util.GetString(drTemp["PName"]));
                if (Util.GetString(drTemp["Email"]) != "" && Util.GetFloat(drTemp["DueAmt"]) <= 0)
                {
                    try
                    {
                        ReportEmailClass RMail = new ReportEmailClass();
                        string IsSend = RMail.sendEmail(Util.GetString(drTemp["Email"]), EmailSubject.Trim(), EmailBody.ToString(), "", "", Util.GetString(drTemp["LedgerTransactionNo"]), Util.GetString(drTemp["Test_ID"]), "PDF Report", "1", "PDF Report Email", "Patient");
                    }
                    catch (Exception ex)
                    {
                        ClassLog dl = new ClassLog();
                        dl.errLog(ex);
                        dl.GeneralLog("LabNo:" + drTemp["LedgerTransactionNO"].ToString() + "");
                    }
                }

                if (Util.GetString(drTemp["EmailIdReport"]) != "")
                {
                    try
                    {
                        ReportEmailClass RMail = new ReportEmailClass();
                        string IsSend = RMail.sendEmail(Util.GetString(drTemp["EmailIdReport"]), EmailSubject.Trim(), EmailBody.ToString(), "", "", Util.GetString(drTemp["LedgerTransactionNo"]), Util.GetString(drTemp["Test_ID"]), "PDF Report", "1", "PDF Report Email", "Client");
                    }
                    catch (Exception ex)
                    {
                        ClassLog dl = new ClassLog();
                        dl.errLog(ex);
                        dl.GeneralLog("LabNo:" + drTemp["LedgerTransactionNO"].ToString() + "");
                    }
                }

                // if (Util.GetString(drTemp["AllowToWhom"]).Split('#')[2] == "1" && Util.GetString(drTemp["DoctorEmailId"]) != "")
                // {
                //     try
                //     {
                //         ReportEmailClass RMail = new ReportEmailClass();
                //         string IsSend = RMail.sendEmail(Util.GetString(drTemp["DoctorEmailId"]), EmailSubject.Trim(), EmailBody.ToString(), "", "", Util.GetString(drTemp["LedgerTransactionNo"]), Util.GetString(drTemp["Test_ID"]), "PDF Report", "1", "PDF Report Email", "Doctor");
                //     }
                //     catch (Exception ex)
                //     {
                //         ClassLog dl = new ClassLog();
                //         dl.errLog(ex);
                //         dl.GeneralLog("LabNo:" + drTemp["LedgerTransactionNO"].ToString() + "");
                //     }
                // }


            }
        }
        return "";
    }
	public void sendSMS()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        DataTable dt = new DataTable();
        ClassLog cl = new ClassLog();
        try
        {
            dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select * from SMS where  issend=0 and  EntDate >='" + System.DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00" + "' AND sms_Type<>'Billing' Union All select * from SMS where  issend=0 AND DATE_ADD(EntDate, INTERVAL 30 MINUTE) <= NOW() AND sms_Type='Billing'").Tables[0];
            string Path = Util.getApp("SMSURL").Replace('~', '&');
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                StringBuilder SMSText = new StringBuilder();
				SMSText.Append(Path);//Util.GetString(dt.Rows[i]["MOBILE_NO"])
                 SMSText = SMSText.Replace("MOBILENO", Util.GetString(dt.Rows[i]["MOBILE_NO"])).Replace("SMSTEXT", Util.GetString(dt.Rows[i]["SMS_TEXT"]));
				SMSText=SMSText.Replace("@@", "%0A");
                try
                {
                    WebClient Client = new WebClient();
                    string RequestData = "";
                    byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
                    Client.Headers.Add("User-Agent: Other");
                    Client.Headers.Add("Content-Type", "text/xml");
                    Client.Encoding = Encoding.UTF8;
                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                    byte[] Response = Client.UploadData(SMSText.ToString(), PostData);
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE SMS SET `issend`=1  WHERE  `issend`='0' and sms_ID=@SMSID",
                        new MySqlParameter("@ErrorMsg", "Success"),
						 new MySqlParameter("@SMSID", dt.Rows[i]["SMS_ID"].ToString()));
                }
                catch (Exception ex)
                {
                    cl.errLog(ex);
                    cl.GeneralLog("SMSID:" + dt.Rows[i]["SMS_ID"].ToString() + " LabNo:" + dt.Rows[i]["labno"].ToString() + " MobileNo:" + dt.Rows[i]["Mobile_No"].ToString());
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE SMS SET `issend`=-1  WHERE  `issend`='0' and sms_ID=@SMSID",
                        new MySqlParameter("@ErrorMsg", "Error"),
						 new MySqlParameter("@SMSID", dt.Rows[i]["SMS_ID"].ToString()));
                }

            }
            tnx.Commit();
        }
        catch (Exception ex)
        {

            tnx.Rollback();
            cl.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
public void sendHomeCollectionSMS()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        DataTable dt = new DataTable();
        ClassLog cl = new ClassLog();
        try
        {
            dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select * from " + Util.getApp("HomeCollectionDB") + ".sms where  issend=0 and  EntDate >='" + System.DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00" + "' ").Tables[0];
            string Path = Util.getApp("SMSURL").Replace('~', '&');
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                StringBuilder SMSText = new StringBuilder();
				SMSText.Append(Path);//Util.GetString(dt.Rows[i]["MOBILE_NO"])
                 SMSText = SMSText.Replace("MOBILENO", Util.GetString(dt.Rows[i]["MOBILE_NO"])).Replace("SMSTEXT", Util.GetString(dt.Rows[i]["SMS_TEXT"]));
				SMSText=SMSText.Replace("@@", "%0A");
                try
                {
                    WebClient Client = new WebClient();
                    string RequestData = "";
                    byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
                    Client.Headers.Add("User-Agent: Other");
                    Client.Headers.Add("Content-Type", "text/xml");
                    Client.Encoding = Encoding.UTF8;
                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                    byte[] Response = Client.UploadData(SMSText.ToString(), PostData);
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE " + Util.getApp("HomeCollectionDB") + ".SMS SET `issend`=1  WHERE  `issend`='0' and sms_ID=@SMSID",
                        new MySqlParameter("@ErrorMsg", "Success"),
						 new MySqlParameter("@SMSID", dt.Rows[i]["SMS_ID"].ToString()));
                }
                catch (Exception ex)
                {
                    cl.errLog(ex);
                    cl.GeneralLog("SMSID:" + dt.Rows[i]["SMS_ID"].ToString() + " LabNo:" + dt.Rows[i]["labno"].ToString() + " MobileNo:" + dt.Rows[i]["Mobile_No"].ToString());
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE SMS SET `issend`=-1  WHERE  `issend`='0' and sms_ID=@SMSID",
                        new MySqlParameter("@ErrorMsg", "Error"),
						 new MySqlParameter("@SMSID", dt.Rows[i]["SMS_ID"].ToString()));
                }

            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            cl.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public string LoadTinySMS()
    {
        ClassLog dl = new ClassLog();
        DataTable dt = new DataTable();
        string result;
        try
        {

            dt = StockReports.GetDataTable("call insert_sms_tiny()");
            // dl.GeneralLog("Tiny SMS Count : "+ dt.Rows.Count);
            if (dt.Rows.Count > 0)
            {
               
                string TinyConverterURL = "http://9url.in/?_url=";
                
                StringBuilder sbSQL = new StringBuilder();
                sbSQL.Append("INSERT INTO `sms`(LedgerTransactionID,`MOBILE_NO`,`SMS_TEXT`,`IsSend`,`UserID`,`SMS_Type`) VALUES");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    string ReportURL = "http://itd-saas.cl-srv.ondgni.com/UAT_Ver1";
                    ReportURL += string.Format("/Design/Lab/labreportnew_ShortSMS.aspx?LabNo=" +dt.Rows[i]["LedgerTransactionNo"].ToString() + "");

                    string SMS_TEXT = "Dear PNAME,ITDose Infosystems Pvt Ltd. is pleased to serve you, Now You can view your reports on your smart phone anytime, anywhere, just click on TINY_URL ITDose Infosystems Pvt Ltd.";

                    ReportURL = ReportURL.Replace("LAB_NO", Common.Encrypt(dt.Rows[i]["LedgerTransactionNO"].ToString()));
                    WebClient Client = new WebClient();
                    string RequestData = "";
                    byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
                    byte[] Response = Client.UploadData(TinyConverterURL + ReportURL, PostData);
                    string turl = Encoding.ASCII.GetString(Response);

                    SMS_TEXT = SMS_TEXT.Replace("TINY_URL", turl).Replace("PNAME", dt.Rows[i]["PName"].ToString());

                    if (i == dt.Rows.Count-1)
                    {
                        sbSQL.Append("('" + dt.Rows[i]["LedgerTransactionID"].ToString() + "','" + dt.Rows[i]["PatientMobileno"].ToString() + "','" + SMS_TEXT + "','0','EMP001','ReportSMS'); ");
                    }
                    else
                    {
                        sbSQL.Append("('" + dt.Rows[i]["LedgerTransactionID"].ToString() + "','" + dt.Rows[i]["PatientMobileno"].ToString() + "','" + SMS_TEXT + "','0','EMP001','ReportSMS'), ");
                    }
		
                }

                StockReports.ExecuteDML(sbSQL.ToString());

            }
            else
            {

            }
            result = "1";
        }
        catch (Exception ex)
        {

            dl.errLog(ex);
            if (dt != null && dt.Rows.Count > 0)
            {

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dl.GeneralLog("LabNo:" + dt.Rows[i]["LedgerTransactionNO"].ToString() + " MobileNo:" + dt.Rows[i]["Mobileno"].ToString());
                    StockReports.ExecuteDML("UPDATE `sms_tiny` SET `isActive`=0 , `ErrorMsg`='" + ex.ToString() + "' WHERE  `isActive`='1' AND `LedgertransactionNo`='" + dt.Rows[i]["LedgerTransactionNO"].ToString() + "' ");
                }
            }
            result = null;
        }
        return result;
    }

    public string LoadSampleStatus()
    {
        ClassLog dl = new ClassLog();
        DataTable dt = new DataTable();
        string result = "0";
        try
        {

            dt = StockReports.GetDataTable("Select Int_Test_id Test_id from patient_labinvestigation_opd where IFNULL(Int_Test_id,'')<>'' and  IsApprovedSync=0 And Approved=1 ");
            if (dt.Rows.Count > 0)
            {

                string RequestURL = "http://localhost:56176/ArunImaging/CronJob/SampleStatusUpdate.aspx";
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    try
                    {
                        WebClient Client = new WebClient();
                        string RequestData = "";
                        byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
                        string Response = Client.UploadString(RequestURL, "{\"Test_ID\":\"" + Util.GetString(dt.Rows[i]["Test_id"]) + "\"}");
                        Response res = JsonConvert.DeserializeObject<Response>(Response);
                        if (res.success == "true")
                        {
                            StockReports.ExecuteDML("UPDATE patient_labinvestigation_opd SET `IsApprovedSync`=1  WHERE  `Int_Test_id`='" + Util.GetString(dt.Rows[i]["Test_id"]) + "'");
                        }
                        else
                        {
                            StockReports.ExecuteDML("UPDATE patient_labinvestigation_opd SET `IsApprovedSync`=-1  WHERE  `Int_Test_id`='" + Util.GetString(dt.Rows[i]["Test_id"]) + "'");
                        }
                        result = "1";
                    }
                    catch (Exception ex)
                    {
                        StockReports.ExecuteDML("UPDATE patient_labinvestigation_opd SET `IsApprovedSync`=-1  WHERE  `Int_Test_id`='" + Util.GetString(dt.Rows[i]["Test_id"]) + "'");
                        result = "0";
                    }
                }

            }
        }
        catch (Exception ex)
        {
            dl.errLog(ex);
            result = "0";
        }
        return result;
    }


public string LoadTinyUrgentSMS()
    {
        ClassLog dl = new ClassLog();
        DataTable dt = new DataTable();
        string result;
        try
        {

            dt = StockReports.GetDataTable("call INSERT_SMS_URGENT_tiny()");
            // dl.GeneralLog("Tiny SMS Count : "+ dt.Rows.Count);
            if (dt.Rows.Count > 0)
            {
               
                string TinyConverterURL = "http://9url.in/?_url=";
                
                StringBuilder sbSQL = new StringBuilder();
                StringBuilder sbLOG = new StringBuilder();
                sbSQL.Append("INSERT INTO `sms`(LabNo,`MOBILE_NO`,`SMS_TEXT`,`IsSend`,`UserID`,`SMS_Type`) VALUES");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    string ReportURL = "http://saral-lis.co:4005/Saral";//http://saralpacs.com
                 //   string ReportURL = "http://localhost/Saral";
                    ReportURL += string.Format("/Design/Lab/labreportnew_ShortSMS.aspx?LabNo=" + dt.Rows[i]["LedgerTransactionNO"].ToString() + "");
                  //  string SMS_TEXT = dt.Rows[i]["Template"].ToString();

                    string SMS_TEXT = "Dear PNAME, you can now view your reports directly on your phone by clicking on the following link TINY_URL  Thank You  Saral Diagnostics ";
                    ReportURL = ReportURL.Replace("LAB_NO", Common.Encrypt(dt.Rows[i]["LedgerTransactionNO"].ToString()));
                    WebClient Client = new WebClient();
                    string RequestData = "";
                    byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
                    byte[] Response = Client.UploadData(TinyConverterURL + ReportURL, PostData);
                    string turl = Encoding.ASCII.GetString(Response);
                    SMS_TEXT = SMS_TEXT.Replace("PNAME", dt.Rows[i]["PName"].ToString()).Replace("LAB_NO", dt.Rows[i]["LedgerTransactionNO"].ToString()).Replace("TINY_URL", turl);
                    if (i == dt.Rows.Count-1)
                    {
                        sbSQL.Append("('" + dt.Rows[i]["LedgerTransactionNO"].ToString() + "','" + dt.Rows[i]["Mobileno"].ToString() + "','" + SMS_TEXT + "','0','EMP001','ReportSMS'); ");
                    }
                    else
                    {
                        sbSQL.Append("('" + dt.Rows[i]["LedgerTransactionNO"].ToString() + "','" + dt.Rows[i]["Mobileno"].ToString() + "','" + SMS_TEXT + "','0','EMP001','ReportSMS'), ");
                    }
			//System.IO.File.AppendAllText(@"D:\Production\acc.txt", sbSQL.ToString());
                }

                StockReports.ExecuteDML(sbSQL.ToString());

            }
            else
            {

            }
            result = "1";
        }
        catch (Exception ex)
        {

            dl.errLog(ex);
            if (dt != null && dt.Rows.Count > 0)
            {

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dl.GeneralLog("LabNo:" + dt.Rows[i]["LedgerTransactionNO"].ToString() + " MobileNo:" + dt.Rows[i]["Mobileno"].ToString());
                    StockReports.ExecuteDML("UPDATE `sms_urgent_tiny` SET `isActive`=0 , `ErrorMsg`='" + ex.ToString() + "' WHERE  `isActive`='1' AND `LedgertransactionNo`='" + dt.Rows[i]["LedgerTransactionNO"].ToString() + "' ");
                }
            }
            result = null;
        }
        return result;
    }
 public string LoadTinyRecieptSMS()
 {
     ClassLog dl = new ClassLog();
     DataTable dt = new DataTable();
     string result;
     try
     {

         dt = StockReports.GetDataTable("call INSERT_SMS_RECIEPT_tiny()");
         // dl.GeneralLog("Tiny SMS Count : "+ dt.Rows.Count);
         if (dt.Rows.Count > 0)
         {

             string TinyConverterURL = "http://9url.in/?_url=";

             StringBuilder sbSQL = new StringBuilder();
             StringBuilder sbLOG = new StringBuilder();
             sbSQL.Append("INSERT INTO `sms`(LabNo,`MOBILE_NO`,`SMS_TEXT`,`IsSend`,`UserID`,`SMS_Type`) VALUES");
             for (int i = 0; i < dt.Rows.Count; i++)
             {
                 string ReportURL = "http://saral-lis.co:4005/Saral";
                 //   string ReportURL = "http://localhost/Saral";
                 ReportURL += string.Format("/Design/Lab/PatientReceiptNew1.aspx?LabID=" + Common.Encrypt(dt.Rows[i]["LedgerTransactionID"].ToString()) + "|isSms=1");
                 //  string SMS_TEXT = dt.Rows[i]["Template"].ToString();

                 string SMS_TEXT = "Dear PNAME, you can now view your registration Slip directly on your phone by clicking on the following link TINY_URL  Thank You  Saral Diagnostics ";
               //  ReportURL = ReportURL.Replace("LAB_NO", Common.Encrypt(dt.Rows[i]["LedgerTransactionID"].ToString()));
                 WebClient Client = new WebClient();
                 string RequestData = "";
                 byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
                 byte[] Response = Client.UploadData(TinyConverterURL + ReportURL, PostData);
                 string turl = Encoding.ASCII.GetString(Response);
                 SMS_TEXT = SMS_TEXT.Replace("PNAME", dt.Rows[i]["PName"].ToString()).Replace("TINY_URL", turl);
                 if (i == dt.Rows.Count - 1)
                 {
                     sbSQL.Append("('" + dt.Rows[i]["LedgerTransactionNO"].ToString() + "','" + dt.Rows[i]["Mobileno"].ToString() + "','" + SMS_TEXT + "','0','EMP001','ReceiptSMS'); ");
                 }
                 else
                 {
                     sbSQL.Append("('" + dt.Rows[i]["LedgerTransactionNO"].ToString() + "','" + dt.Rows[i]["Mobileno"].ToString() + "','" + SMS_TEXT + "','0','EMP001','ReceiptSMS'), ");
                 }
                 //System.IO.File.AppendAllText(@"D:\Production\acc.txt", sbSQL.ToString());
             }

             StockReports.ExecuteDML(sbSQL.ToString());

         }
         else
         {

         }
         result = "1";
     }
     catch (Exception ex)
     {

         dl.errLog(ex);
         if (dt != null && dt.Rows.Count > 0)
         {

             for (int i = 0; i < dt.Rows.Count; i++)
             {
                 dl.GeneralLog("LabNo:" + dt.Rows[i]["LedgerTransactionNO"].ToString() + " MobileNo:" + dt.Rows[i]["Mobileno"].ToString());
                 StockReports.ExecuteDML("UPDATE `sms_reciept_tiny` SET `isActive`=0 , `ErrorMsg`='" + ex.ToString() + "' WHERE  `isActive`='1' AND `LedgertransactionNo`='" + dt.Rows[i]["LedgerTransactionNO"].ToString() + "' ");
             }
         }
         result = null;
     }
     return result;
 } 
 public string LoadTinyRecieptCompanySMS()
 {
     ClassLog dl = new ClassLog();
     DataTable dt = new DataTable();
     string result;
     try
     {

         dt = StockReports.GetDataTable("call INSERT_SMS_RECIEPT_COMPANY_tiny()");
         // dl.GeneralLog("Tiny SMS Count : "+ dt.Rows.Count);
         if (dt.Rows.Count > 0)
         {

             string TinyConverterURL = "http://9url.in/?_url=";

             StringBuilder sbSQL = new StringBuilder();
             StringBuilder sbLOG = new StringBuilder();
             sbSQL.Append("INSERT INTO `sms`(LabNo,`MOBILE_NO`,`SMS_TEXT`,`IsSend`,`UserID`,`SMS_Type`) VALUES");
             for (int i = 0; i < dt.Rows.Count; i++)
             {
                 string ReportURL = "http://saral-lis.co:4005/Saral";
                 //   string ReportURL = "http://localhost/Saral";
                 //  ReportURL += string.Format("/Design/Lab/ReceiptNew.aspx?LabID=" + dt.Rows[i]["LedgerTransactionID"].ToString() + "&CompanyID="+ dt.Rows[i]["CompanyID"].ToString() +"");
                 //  string SMS_TEXT = dt.Rows[i]["Template"].ToString();

                 ReportURL += "/Design/Lab/ReceiptNew.aspx?LabID=" + dt.Rows[i]["LedgerTransactionID"].ToString() + "|"+ dt.Rows[i]["CompanyID"].ToString()+"";

                 string SMS_TEXT = "Dear PNAME, you can now view your invoice directly on your phone by clicking on the following link TINY_URL  Thank You  Saral Diagnostics ";
               //  ReportURL = ReportURL.Replace("LAB_NO", Common.Encrypt(dt.Rows[i]["LedgerTransactionID"].ToString()));
                 WebClient Client = new WebClient();
                 string RequestData = "";
                 byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
                 byte[] Response = Client.UploadData(TinyConverterURL + ReportURL, PostData);
                 string turl = Encoding.ASCII.GetString(Response);
                 SMS_TEXT = SMS_TEXT.Replace("PNAME", dt.Rows[i]["PName"].ToString()).Replace("TINY_URL", turl);
                 if (i == dt.Rows.Count - 1)
                 {
                     sbSQL.Append("('" + dt.Rows[i]["LedgerTransactionNO"].ToString() + "','" + dt.Rows[i]["Mobileno"].ToString() + "','" + SMS_TEXT + "','0','EMP001','InvoiceSMS'); ");
                 }
                 else
                 {
                     sbSQL.Append("('" + dt.Rows[i]["LedgerTransactionNO"].ToString() + "','" + dt.Rows[i]["Mobileno"].ToString() + "','" + SMS_TEXT + "','0','EMP001','InvoiceSMS'), ");
                 }
                 //System.IO.File.AppendAllText(@"D:\Production\acc.txt", sbSQL.ToString());
             }

             StockReports.ExecuteDML(sbSQL.ToString());

         }
         else
         {

         }
         result = "1";
     }
     catch (Exception ex)
     {

         dl.errLog(ex);
         if (dt != null && dt.Rows.Count > 0)
         {

             for (int i = 0; i < dt.Rows.Count; i++)
             {
                 dl.GeneralLog("LabNo:" + dt.Rows[i]["LedgerTransactionNO"].ToString() + " MobileNo:" + dt.Rows[i]["Mobileno"].ToString());
                 StockReports.ExecuteDML("UPDATE `sms_reciept_company_tiny` SET `isActive`=0 , `ErrorMsg`='" + ex.ToString() + "' WHERE  `isActive`='1' AND `LedgertransactionNo`='" + dt.Rows[i]["LedgerTransactionNO"].ToString() + "' AND `Companyid`='" + dt.Rows[i]["CompanyID"].ToString() + "' ");
             }
         }
         result = null;
     }
     return result;
 } 

}
public class Response
{
    private string _success;
    private string _msg;
    public string success { get { return _success; } set { _success = value; } }
    public string msg { get { return _msg; } set { _msg = value; } }
}


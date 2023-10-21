using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Lab_RemoveLogisticTransaction : System.Web.UI.Page
{
    public static string labno = "";
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string searchdata(string BarcodeNo)
    {              
        StringBuilder sb = new StringBuilder();
        int isRemoved =Util.GetInt(StockReports.ExecuteScalar("select count(*) from sample_logistic_Remove where BarcodeNo='"+BarcodeNo.Trim()+"' "));
        string RemovalStatus = (isRemoved>0?"Removed":"Not Removed");        
        // PatientMaster
        sb.Append(" select pm.Patient_ID ,pm.Title ,pm.PName ,pm.House_No ,pm.Street_Name ,pm.Locality ,pm.City , pm.PinCode , ");
        sb.Append(" '" + RemovalStatus + "' RemovalStatus, ");
        sb.Append(" (SELECT COUNT(*) FROM `patient_labinvestigation_opd` WHERE BarcodeNo='" + BarcodeNo.Trim() + "' AND IsRefund='1')IsARefundEntry, ");
        sb.Append(" pm.State ,pm.Country ,pm.Phone ,pm.Mobile ,pm.Email ,pm.Age ,pm.AgeYear ,pm.AgeMonth ,pm.AgeDays , ");
        sb.Append(" pm.TotalAgeInDays ,date_format(pm.DOB,'%Y-%m-%d')DOB ,pm.Gender ,pm.StateID ,pm.CityID ,pm.localityid  ");
        sb.Append(" , ");
        // LT
        sb.Append(" lt.LedgerTransactionID,lt.LedgerTransactionNo,lt.TypeOfTnx,lt.NetAmount,lt.GrossAmount,lt.IsCredit,lt.DiscountReason,lt.DiscountApprovedByID, ");
        sb.Append(" lt.DiscountApprovedByName,lt.Remarks,lt.Panel_ID,lt.PanelName,lt.Doctor_ID,lt.DoctorName,lt.OtherDoctorName, ");
        sb.Append(" lt.ReferLab,lt.OtherReferLab,lt.CardNo,lt.VIP,lt.CentreID,lt.Adjustment,lt.PRO,lt.CreditPRO,lt.HomeVisitBoyID, ");
        sb.Append("  lt.PatientIDProof,lt.PatientIDProofNo,lt.PatientSource,lt.PatientType,lt.PUPRefNo,lt.VisitType,lt.PUPContact,lt.PUPMobileNo, ");
        sb.Append("  lt.PUPEmailId,lt.HLMPatientType,lt.HLMOPDIPDNo,lt.DiscountPending,lt.DiscountOnTotal,date_format(lt.date,'%Y-%m-%d')DATE  ");
        sb.Append(" , ");
        //PLO
        sb.Append(" plo.BarcodeNo,plo.ItemId,plo.ItemName,plo.Investigation_ID,plo.IsPackage,plo.SubCategoryID,plo.Rate,plo.DiscountAmt,plo.Amount,plo.Quantity,plo.IsRefund, ");
        sb.Append(" plo.IsReporting,plo.ReportType,plo.CentreID,plo.TestCentreID,");

        sb.Append(" IF(plo.`IsPackage`=1 AND (SELECT COUNT(1) FROM patient_labinvestigation_opd plo2 WHERE plo2.LedgerTransactionID = plo.`LedgerTransactionID` AND plo.ItemID=plo2.itemid AND plo2.IsSampleCollected='Y') >0 ,'Y', plo.IsSampleCollected) IsSampleCollected, ");
        sb.Append(" plo.SampleBySelf,plo.isUrgent,DATE_FORMAT(plo.DeliveryDate,'%Y-%m-%d')DeliveryDate,plo.DispatchModeID, ");
        sb.Append(" plo.DispatchModeName,DATE_FORMAT(plo.Sampledate,'%Y-%m-%d')Sampledate,DATE_FORMAT(plo.SampleCollectionDate,'%Y-%m-%d')SampleCollectionDate  ");
      
        sb.Append(" FROM patient_master pm  ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`Patient_ID`=pm.`Patient_ID` ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
        sb.Append(" AND plo.BarcodeNo='" + BarcodeNo.Trim() + "'    AND lt.`NetAmount`>0  GROUP BY plo.`ItemId` ");
       
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveData(string BarcodeNo, string RemoveReason)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);    
        try
        {
            int IsReceive = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT COUNT(*) FROM `patient_labinvestigation_opd` WHERE BarcodeNo='"+BarcodeNo.Trim()+"' AND  IsSampleCollected='Y' "));
            int IsNot = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT COUNT(*) FROM `patient_labinvestigation_opd` WHERE BarcodeNo='" + BarcodeNo.Trim() + "' AND  IsSampleCollected='N' "));
            int isLogistic = Util.GetInt(StockReports.ExecuteScalar("select count(*) from sample_logistic where BarcodeNo='" + BarcodeNo.Trim() + "' "));           
            if (isLogistic == 0)
            {
                tnx.Rollback();
                con.Close();
                con.Dispose();
                return "#Unable To Remove Because Logistic Not Available.";
            }
            else if (IsReceive > 0)
            {
                tnx.Rollback();
                con.Close();
                con.Dispose();
                return "#Unable To Remove Because Sample Is Received.";
            }
            else if (IsNot > 0)
            {
                tnx.Rollback();
                con.Close();
                con.Dispose();
                return "#Unable To Remove Because Sample Is Not Collected.";
            }
            else
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("  INSERT INTO sample_logistic_remove ");
                sb.Append(" ( ");
                sb.Append(" BarcodeNo,FromCentreID,ToCentreID,DispatchCode,Qty,dtEntry,EntryBy,PickUpFieldBoyID,PickUpFieldBoy, ");
                sb.Append(" CourierDetail,CourierDocketNo,STATUS,IsActive,UpdatedBy,updatedDate,dtSent,dtLogisticReceive, ");
                sb.Append(" RemovedBy,RemoveByID,RemovalReason");
                sb.Append(" ) ");
                sb.Append(" Select ");
                sb.Append(" BarcodeNo,FromCentreID,ToCentreID,DispatchCode,Qty,dtEntry,EntryBy,PickUpFieldBoyID,PickUpFieldBoy, ");
                sb.Append(" CourierDetail,CourierDocketNo,STATUS,IsActive,UpdatedBy,updatedDate,dtSent,dtLogisticReceive, ");
                sb.Append(" '" + UserInfo.LoginName + "' RemovedBy,'" + UserInfo.ID + "' RemoveByID,'" + RemoveReason.Trim() + "'RemovalReason from sample_logistic where BarcodeNo='" + BarcodeNo.Trim() + "' ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " delete from sample_logistic where BarcodeNo='" + BarcodeNo.Trim() + "' ");
            }
            
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());
        }
    }
   
   }
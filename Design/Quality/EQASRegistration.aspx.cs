using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_EQASRegistration : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string dt = StockReports.ExecuteScalar("SELECT count(1) FROM qc_approvalright WHERE apprightfor='EQAS' and typeid=8 AND active=1 AND employeeid='" + UserInfo.ID + "' ");
            if (dt == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';showerrormsg('Dear User You Did not Have Right Register EQAS');", true);
                return;
            }


            ddlprocessinglab.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 ORDER BY centre");
            ddlprocessinglab.DataValueField = "centreid";
            ddlprocessinglab.DataTextField = "centre";
            ddlprocessinglab.DataBind();
           // ddlprocessinglab.Items.Insert(0,new ListItem("Select Processing Lab","0"));

            txtcurrentyear.Text = DateTime.Now.Year.ToString();
            ddlcurrentmonth.Items.Add(new ListItem(DateTime.Now.ToString("MMMM"), DateTime.Now.Month.ToString()));
            txtprogramnumber.Text = DateTime.Now.Year.ToString();
            if (ddlprocessinglab.Items.Count > 0)
            {
                //int AccessDays = Util.GetInt(StockReports.ExecuteScalar("SELECT count(1)  FROM qc_ilcschedule WHERE `ProcessingLabID`=" + ddlprocessinglab.SelectedValue + " AND isactive=1 AND `ScheduleType`=3 AND DAY(NOW()) BETWEEN fromdate AND todate and IsSpecial=0"));

                ////if (AccessDays == 0)
                ////{
                ////    int AccessDaysSpecial = Util.GetInt(StockReports.ExecuteScalar("SELECT count(1)  FROM qc_ilcschedule WHERE `ProcessingLabID`=" + ddlprocessinglab.SelectedValue + " AND isactive=1 AND `ScheduleType`=3  AND DATE(NOW()) BETWEEN `Specialfrom` AND SpecialToDate and IsSpecial=1"));
                ////    if (AccessDaysSpecial == 0)
                ////    {
                ////        string s = StockReports.ExecuteScalar("select concat(fromdate,'-',todate) from qc_ilcschedule WHERE `ProcessingLabID`=" + ddlprocessinglab.SelectedValue + " AND isactive=1 AND `ScheduleType`=3 and IsSpecial=0 ");

                ////        string msg = "This page only accessible between " + s + " (Every Month). Send request for increase time";
                ////        ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "$('#Pbody_box_inventory').hide();$('#disp1').show();$('#disp1').text('" + msg + "');showerrormsg('" + msg + "');", true);
                ////        return;
                ////    }
                ////}

            }
            else
            {
                string msg = "No Processing Lab Found. Please Select Proper Centre.";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "$('#Pbody_box_inventory').hide();$('#disp1').show();$('#disp1').text('" + msg + "');showerrormsg('" + msg + "');", true);
                return;
            }


        }
    }

   

    [WebMethod(EnableSession = true)]
    public static string bindprogram(string labid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT eql.`ProgramID`,eqp.`ProgramName` FROM qc_eqasprogramlabmapping eql
INNER JOIN `qc_eqasprogrammaster` eqp ON eql.`ProgramID`=eqp.`ProgramID` AND eqp.`IsActive`=1
 WHERE eql.`ProcessingLabID`="+labid+" AND eql.isactive=1 GROUP BY eql.`ProgramID` ORDER BY eql.`ProgramID`"));

    }


    [WebMethod(EnableSession = true)]
    public static string bindprogramdata(string programid, string regisyearandmonth, string labid,string type)
    {

        StringBuilder sb = new StringBuilder();
        if (type == "0")
        {
            sb.Append(" SELECT ifnull(qcr.ProgramNo,'') ProgramNo,ifnull(qcr.CycleNo,'') CycleNo, test_id,");
            sb.Append(" ifnull(qcr.LedgerTransactionNo,'')LedgerTransactionNo, ");
            sb.Append(" ifnull(qcr.barcodeno,'')barcodeno, qem.programid,qem.programname,qem.rate,qem.investigationid,investigationname,");
            sb.Append(" concat(ResultWithin,' Days')`ResultWithin`,concat(`Frequency`,' Month') `Frequency`,departmentname, Age,qem.Gender, ");
            sb.Append(" DepartmentID,qem.LabObservationID,im.itemid,im.`TestCode`,im.`TypeName`,imm.`ReportType`,ifnull(qcr.id,0) savedid, ");
            sb.Append(" ifnull(date_format(qcr.EntryDateTime,'%d-%b-%Y'),'')regdate FROM `qc_eqasprogrammaster` qem   ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.`Type_ID`=qem.`InvestigationID` AND im.`IsActive`=1 ");
            sb.Append(" INNER JOIN `investigation_master` imm ON imm.`Investigation_Id`=qem.`InvestigationID` ");
            sb.Append(" left join qc_eqasregistration qcr on qcr.programid=qem.programid and qcr.centreid=" + labid + " and qcr.investigationid=qem.investigationid  ");
            sb.Append(" and qcr.entrymonth=" + regisyearandmonth.Split('#')[0] + " and qcr.entryyear=" + regisyearandmonth.Split('#')[1] + " and qcr.isReject=0 ");
            sb.Append(" WHERE qem.programid =" + programid + " AND qem.isactive=1  ");
            sb.Append(" group by ifnull(qcr.test_id,0) , qem.`InvestigationID`  ");
            sb.Append(" order by qem.programid,test_id ");
        }
        else
        {
            sb.Append(" SELECT * FROM (");
            sb.Append(" SELECT ifnull(qcr.ProgramNo,'') ProgramNo,ifnull(qcr.CycleNo,'') CycleNo,test_id, ");
            sb.Append(" ifnull(qcr.LedgerTransactionNo,'')LedgerTransactionNo, ");
            sb.Append(" ifnull(qcr.barcodeno,'')barcodeno, qem.programid,qem.programname,qem.rate,qem.investigationid,investigationname,");
            sb.Append(" concat(ResultWithin,' Days')`ResultWithin`,concat(`Frequency`,' Month') `Frequency`,departmentname, Age,qem.Gender, ");
            sb.Append(" DepartmentID,qem.LabObservationID,im.itemid,im.`TestCode`,im.`TypeName`,imm.`ReportType`,ifnull(qcr.id,0) savedid, ");
            sb.Append(" ifnull(date_format(qcr.EntryDateTime,'%d-%b-%Y'),'')regdate FROM `qc_eqasprogrammaster` qem   ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.`Type_ID`=qem.`InvestigationID` AND im.`IsActive`=1 ");
            sb.Append(" INNER JOIN `investigation_master` imm ON imm.`Investigation_Id`=qem.`InvestigationID` ");
            sb.Append(" inner join qc_eqasregistration qcr on qcr.programid=qem.programid and qcr.centreid=" + labid + " and qcr.investigationid=qem.investigationid  ");
            sb.Append(" and qcr.entrymonth=" + regisyearandmonth.Split('#')[0] + " and qcr.entryyear=" + regisyearandmonth.Split('#')[1] + " and qcr.isReject=0 ");
            sb.Append(" WHERE qem.programid =" + programid + " AND qem.isactive=1  ");
          

            sb.Append(" union all ");

            sb.Append(" SELECT '' ProgramNo,'' CycleNo,0 test_id, ");
            sb.Append(" '' LedgerTransactionNo, ");
            sb.Append(" '' barcodeno, qem.programid,qem.programname,qem.rate,qem.investigationid,investigationname,");
            sb.Append(" concat(ResultWithin,' Days')`ResultWithin`,concat(`Frequency`,' Month') `Frequency`,departmentname, Age,qem.Gender, ");
            sb.Append(" DepartmentID,qem.LabObservationID,im.itemid,im.`TestCode`,im.`TypeName`,imm.`ReportType`,0 savedid, ");
            sb.Append(" '' regdate FROM `qc_eqasprogrammaster` qem   ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.`Type_ID`=qem.`InvestigationID` AND im.`IsActive`=1 ");
            sb.Append(" INNER JOIN `investigation_master` imm ON imm.`Investigation_Id`=qem.`InvestigationID` ");
         
            sb.Append(" WHERE qem.programid =" + programid + " AND qem.isactive=1  ");

            sb.Append(" ) t");
            sb.Append(" group by test_id , InvestigationID  ");
            sb.Append(" order by programid,test_id ");


        }
    

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }


    [WebMethod(EnableSession = true)]
    public static string saveregister(Ledger_Transaction LTData, List<Patient_Lab_InvestigationOPD> PLO, string regisyearandmonth, string programname, string programno, string cycleno)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string PatientID = string.Empty;
            string LedgerTransactionID = string.Empty;
            string LedgerTransactionNo = string.Empty;


        

            PatientID =Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select patient_id from patient_master where patient_id='EQAS'"));

            if (PatientID == "")
            {
                Exception ex = new Exception("Patient ID Not Found for EQAS.Please Contract To Admin");
                throw (ex);
            }


            Ledger_Transaction objlt = new Ledger_Transaction(tnx);
          
            objlt.DiscountOnTotal = LTData.DiscountOnTotal;
            objlt.NetAmount = LTData.NetAmount;
            objlt.GrossAmount = LTData.GrossAmount;
            objlt.IsCredit = LTData.IsCredit;
            objlt.Patient_ID = PatientID;

            objlt.PName = LTData.PName.ToUpper();

            objlt.Age = LTData.Age;
            objlt.Gender = LTData.Gender;
            objlt.VIP = LTData.VIP;
            objlt.Remarks = LTData.Remarks;
            objlt.Panel_ID = LTData.Panel_ID;
            objlt.PanelName = LTData.PanelName;
            objlt.Doctor_ID = LTData.Doctor_ID;
            objlt.DoctorName = LTData.DoctorName;
          
            objlt.OtherReferLab = LTData.OtherReferLab;
           
            objlt.CentreID = LTData.CentreID;
            objlt.Adjustment = LTData.Adjustment;
            objlt.CreatedByID = UserInfo.ID;
          
            objlt.HomeVisitBoyID = LTData.HomeVisitBoyID;
            objlt.PatientIDProof = LTData.PatientIDProof;
            objlt.PatientIDProofNo = LTData.PatientIDProofNo;
            objlt.PatientSource = LTData.PatientSource;
            objlt.PatientType = LTData.PatientType;
           
            objlt.VisitType = LTData.VisitType;
           
            objlt.HLMPatientType = LTData.HLMPatientType;
            objlt.HLMOPDIPDNo = LTData.HLMOPDIPDNo;
            objlt.DiscountReason = LTData.DiscountReason;
            objlt.DiscountApprovedByID = LTData.DiscountApprovedByID;
            objlt.DiscountApprovedByName = LTData.DiscountApprovedByName;
            objlt.HLMPatientType = LTData.HLMPatientType;
            objlt.HLMOPDIPDNo = LTData.HLMOPDIPDNo;
            objlt.CorporateIDCard = LTData.CorporateIDCard;
            objlt.CorporateIDType = LTData.CorporateIDType;
            objlt.AttachedFileName = LTData.AttachedFileName;
            objlt.ReVisit = 0;
            objlt.CreatedBy = UserInfo.LoginName;
            objlt.DiscountID = LTData.DiscountID;
            objlt.OtherLabRefNo = LTData.OtherLabRefNo;
            objlt.FamilyUHIDNo = LTData.FamilyUHIDNo;
            objlt.WorkOrderID = LTData.WorkOrderID;
           

            objlt.PreBookingID = LTData.PreBookingID;
           

          
            string retvalue = objlt.Insert();
            if (retvalue == string.Empty)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return string.Empty;
            }
            LedgerTransactionID = retvalue.Split('#')[0];
            LedgerTransactionNo = retvalue.Split('#')[1];

            DataTable dtSample = new DataTable();
            dtSample.Columns.Add("SampleType");
            dtSample.Columns.Add("SubCategoryID");
            dtSample.Columns.Add("BarcodeNo");
            string Barcode = "";
            string barcodePreprinted = "0";

            foreach (Patient_Lab_InvestigationOPD plo in PLO)
            {
                string sampleType = "";
                sampleType = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT concat(ist.`SampleTypeID`,'#',ist.SampleTypeName) FROM `investigations_sampletype` ist where `Investigation_Id`='" + plo.Investigation_ID + "' AND ist.`IsDefault`=1 "));

                if (Util.GetString(plo.BarcodeNo) == "" && plo.IsPackage == 0)
                {
                    barcodePreprinted = "0";

                    if (dtSample.Select("SampleType='" + sampleType.Split('#')[0] + "' and SubCategoryID='" + plo.SubCategoryID + "'").Length == 0)
                    {
                        Barcode = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_barcode('" + plo.SubCategoryID + "')").ToString();
                        DataRow dr = dtSample.NewRow();
                        dr["SampleType"] = sampleType.Split('#')[0];
                        dr["SubCategoryID"] = plo.SubCategoryID;
                        dr["BarcodeNo"] = Barcode;
                        dtSample.Rows.Add(dr);
                        dtSample.AcceptChanges();
                    }
                    else
                        Barcode = dtSample.Select("SampleType='" + sampleType.Split('#')[0] + "' and SubCategoryID='" + plo.SubCategoryID + "'")[0]["BarcodeNo"].ToString();
                }
                else
                {
                    Barcode = plo.BarcodeNo;
                    barcodePreprinted = "1";
                }
           
                float MRP = 0;

                Patient_Lab_InvestigationOPD objPlo = new Patient_Lab_InvestigationOPD(tnx);
                objPlo.LedgerTransactionID =Util.GetInt(LedgerTransactionID);
                objPlo.LedgerTransactionNo = LedgerTransactionNo;
                objPlo.Patient_ID = PatientID;
                objPlo.AgeInDays = plo.AgeInDays;
                objPlo.Gender = plo.Gender;
                objPlo.BarcodeNo = Barcode;
                objPlo.ItemId = plo.ItemId;

                objPlo.ItemName = plo.ItemName.ToUpper();
                objPlo.ItemCode = plo.ItemCode;
               // objPlo.InvestigationName = plo.InvestigationName.ToUpper();
                objPlo.PackageName = plo.PackageName;
                objPlo.PackageCode = plo.PackageCode;

                objPlo.Investigation_ID = plo.Investigation_ID;
                objPlo.IsPackage = plo.IsPackage;
                objPlo.SubCategoryID = plo.SubCategoryID;
                objPlo.Rate = plo.Rate;
                objPlo.Amount = plo.Amount;
                objPlo.DiscountAmt = plo.DiscountAmt;
                objPlo.DiscountByLab = plo.DiscountByLab;
                objPlo.CouponAmt = plo.CouponAmt;
                objPlo.IsActive = 1;
                objPlo.Quantity = plo.Quantity;
                objPlo.IsRefund = plo.IsRefund;
                objPlo.IsReporting = plo.IsReporting;
                objPlo.ReportType = plo.ReportType;
                objPlo.CentreID = plo.CentreID;
                objPlo.TestCentreID = plo.TestCentreID;
                objPlo.IsSampleCollected = plo.IsSampleCollected;
                if (objPlo.IsSampleCollected == "S")
                {
                    objPlo.SampleCollector = UserInfo.LoginName;
                    objPlo.SampleCollectionBy = UserInfo.ID;

                  //  objPlo.Sampledate = Util.GetDateTime(DateTime.Now);
                    objPlo.SampleCollectionDate = Util.GetDateTime(DateTime.Now);

                    try
                    {
                        objPlo.SampleTypeID = Util.GetInt(sampleType.Split('#')[0]);
                        objPlo.SampleTypeName = sampleType.Split('#')[1];
                    }
                    catch
                    {
                    }
                }
                objPlo.SampleBySelf = plo.SampleBySelf;
                objPlo.isUrgent = plo.isUrgent;
                objPlo.DeliveryDate = plo.DeliveryDate;
                objPlo.SRADate = plo.SRADate;
               
                objPlo.IsScheduleRate = plo.IsScheduleRate;
               
                objPlo.Date = DateTime.Now;
              
                objPlo.ItemID_Interface = plo.ItemID_Interface;
                
                string ID = objPlo.Insert();

                if (ID == string.Empty)
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return string.Empty;
                }

                DataTable dt_LabObservation = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT lm.`LabObservation_ID`,lm.`Name` AS LabObservationName FROM `labobservation_investigation` li INNER JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=li.`labObservation_ID` WHERE li.`Investigation_Id`='" + objPlo.Investigation_ID + "'").Tables[0];
                if (dt_LabObservation.Rows.Count > 0)
                {
                    for (int i = 0; i < dt_LabObservation.Rows.Count; i++)
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append(" insert into qc_eqasregistration (CentreID,LedgerTransactionID,LedgerTransactionNo,Test_id,InvestigationID,LabObservationID, ");
                        sb.Append(" BarcodeNo,EntryMonth,EntryYear,ProgramID,ProgramName,ProgramNo,CycleNo,EntryDateTime,EntryByUserID,EntryByUserName,LabObservationName) ");
                        sb.Append(" values ");
                        sb.Append("(@CentreID,@LedgerTransactionID,@LedgerTransactionNo,@Test_id,@InvestigationID,@LabObservationID,");
                        sb.Append(" @BarcodeNo,@EntryMonth,@EntryYear,@ProgramID,@ProgramName,@ProgramNo,@CycleNo,@EntryDateTime,@EntryByUserID,@EntryByUserName,@LabObservationName)");

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@CentreID", LTData.CentreID),
                             new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                              new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                               new MySqlParameter("@Test_id", ID),
                                new MySqlParameter("@InvestigationID", objPlo.Investigation_ID),
                                 new MySqlParameter("@LabObservationID", dt_LabObservation.Rows[i]["LabObservation_ID"].ToString()),
                                  new MySqlParameter("@BarcodeNo", Barcode),
                                   new MySqlParameter("@EntryMonth", regisyearandmonth.Split('#')[0]),
                                     new MySqlParameter("@EntryYear", regisyearandmonth.Split('#')[1]),
                                      new MySqlParameter("@ProgramID", objPlo.PackageCode),
                                       new MySqlParameter("@ProgramName", objPlo.PackageName),
                                        new MySqlParameter("@ProgramNo", programno),
                                         new MySqlParameter("@CycleNo", cycleno),
                                          new MySqlParameter("@EntryDateTime", DateTime.Now),
                                            new MySqlParameter("@EntryByUserID", UserInfo.ID),
                                              new MySqlParameter("@EntryByUserName", UserInfo.LoginName),
                                               new MySqlParameter("@LabObservationName", dt_LabObservation.Rows[i]["LabObservationName"].ToString()));
                    }
                }
                else
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" insert into qc_eqasregistration (CentreID,LedgerTransactionID,LedgerTransactionNo,Test_id,InvestigationID,LabObservationID, ");
                    sb.Append(" BarcodeNo,EntryMonth,EntryYear,ProgramID,ProgramName,ProgramNo,CycleNo,EntryDateTime,EntryByUserID,EntryByUserName,LabObservationName) ");
                    sb.Append(" values ");
                    sb.Append("(@CentreID,@LedgerTransactionID,@LedgerTransactionNo,@Test_id,@InvestigationID,@LabObservationID,");
                    sb.Append(" @BarcodeNo,@EntryMonth,@EntryYear,@ProgramID,@ProgramName,@ProgramNo,@CycleNo,@EntryDateTime,@EntryByUserID,@EntryByUserName,@LabObservationName)");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@CentreID", LTData.CentreID),
                         new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                          new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                           new MySqlParameter("@Test_id", ID),
                            new MySqlParameter("@InvestigationID", objPlo.Investigation_ID),
                             new MySqlParameter("@LabObservationID", 0),
                              new MySqlParameter("@BarcodeNo", Barcode),
                               new MySqlParameter("@EntryMonth", regisyearandmonth.Split('#')[0]),
                                 new MySqlParameter("@EntryYear", regisyearandmonth.Split('#')[1]),
                                  new MySqlParameter("@ProgramID", objPlo.PackageCode),
                                   new MySqlParameter("@ProgramName", objPlo.PackageName),
                                    new MySqlParameter("@ProgramNo", programno),
                                     new MySqlParameter("@CycleNo", cycleno),
                                      new MySqlParameter("@EntryDateTime", DateTime.Now),
                                        new MySqlParameter("@EntryByUserID", UserInfo.ID),
                                          new MySqlParameter("@EntryByUserName", UserInfo.LoginName),
                                          new MySqlParameter("@LabObservationName", ""));
                }
            }
            tnx.Commit();
            return "1#" + LedgerTransactionID + "_" + LedgerTransactionNo;


        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.Message);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    
}
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

public partial class Design_Quality_CAPProgramResultEntry : System.Web.UI.Page
{

    public string cansave = "0";
    public string canapprove = "0";
    public string canupload = "0";
    public string canfinaldone = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typeid),0) FROM qc_approvalright WHERE apprightfor='CAP' and typeid!=13 AND employeeid='" + UserInfo.ID + "' ");
            if (dt != "0")
            {
                if (dt.Contains("9"))
                {
                    cansave = "1";
                }
                if (dt.Contains("10"))
                {
                    canapprove = "1";
                }
                if (dt.Contains("11"))
                {
                    canupload = "1";
                }
                if (dt.Contains("12"))
                {
                    canfinaldone = "1";
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';showerrormsg('Dear User You Did not Have Right To View This Page');", true);
                return;
            }



            ddlcentre.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 ORDER BY centre");
            ddlcentre.DataValueField = "centreid";
            ddlcentre.DataTextField = "centre";
            ddlcentre.DataBind();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindshipment(string labid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT shipmentno FROM qc_capshippingdetail WHERE isactive=1 AND centreid=" + labid + " GROUP BY centreid,shipmentno "));
    }

    [WebMethod(EnableSession = true)]
    public static string bindprogram(string labid, string shipmentno)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT qcp.programid,qcm.`ProgramName` FROM qc_capshippingdetail qcp
INNER JOIN `qc_capprogrammaster` qcm ON qcp.`ProgramID`=qcm.`ProgramID` AND qcp.`IsActive`=1 AND qcm.`IsActive`=1
AND qcp.`ShipmentNo`='"+shipmentno+"' and centreid=" + labid + " GROUP BY qcp.programid"));
    }
    

    [WebMethod(EnableSession = true)]
    public static string searchdata(string centreid, string shipmentno, string programid,string type)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT qcpp.LabObservationName,qcpp.labobservationid,qcpp.LedgerTransactionID ,plo.ledgertransactionno as visitno, ifnull((select grade from qc_capprogramperformance where programid=qc.`ProgramID` and InvestigationID=plo.Investigation_ID order by capdonedate desc limit 1),'')lastStatus,");
        sb.Append("  ifnull(qcpp.CAPResultFileName,'')CAPResultFileName,ifnull(qcpp.Grade,'')Grade, ifnull(qcpp.Acceptability,'')Acceptability,  qcp.`ShipmentNo`, qc.ResultWithin, qcpp.test_id, qcp.`CentreId`, qcp.`ShipmentNo`,DATE_FORMAT(qcp.`ShipDate`,'%d-%b-%Y')ShipDate,DATE_FORMAT(qcp.`DueDate`,'%d-%b-%Y') `DueDate`, ");
        sb.Append("qc.`ProgramName`,qc.`ProgramID`,qc.`InvestigationID`,plo.`ReportType`,plo.Investigation_ID, ");
        sb.Append(" sm.`SubCategoryID`,IFNULL(qcpp.`BarcodeNo`,'') sinno,IFNULL(qcpp.`Specimen`,'')Specimen, ");

        sb.Append(" DATE_FORMAT(plo.date,'%d-%b-%Y') regdate,plo.`InvestigationName`,sm.name departmant,plo.`ReportType`, ");
        sb.Append(" IFNULL(ploo.`Value`,ifnull(qcpp.value,'')) ResultValue,IFNULL(ploo.minvalue,'') minvalue,IFNULL(ploo.`MaxValue`,'')`MaxValue`, ");
        sb.Append(" ifnull(ploo.MacReading,'')MacReading ,ifnull(ploo.MachineName,'')MachineName, ");
        sb.Append(" IFNULL(ploo.`DisplayReading`,'')DisplayReading,IFNULL(ploo.`ReadingFormat`,'')ReadingFormat,IFNULL(ploo.flag,'')flag");


        sb.Append(" ,(case when qcpp.CAPDone=1 then 'aqua' when qcpp.ResultUploaded=1 then 'lightsalmon' when qcpp.Approved=1 then 'lightgreen'  when qcpp.result_flag=1 then 'bisque' else 'lightgoldenrodyellow' end)rowcolor, ");
        sb.Append(" (case when qcpp.CAPDone=1 then 'CAPDone' when qcpp.ResultUploaded=1 then 'ResultUploaded' when qcpp.Approved=1 then 'Approved'  when qcpp.result_flag=1 then 'ResultDone' else 'New' end)custatus ");
        sb.Append(" ,if(ResultUploaded=1,date_format(ExpectedResultDate,'%d-%b-%Y'),'')ExpectedResultDate ");
        sb.Append(" FROM qc_capshippingdetail qcp  ");
        sb.Append(" INNER JOIN `qc_capprogrammaster` qc ON qcp.`ProgramID`=qc.`ProgramID` AND qc.`IsActive`=1 AND qcp.`IsActive`=1 and qc.programid=" + programid + " ");
        sb.Append(" inner JOIN qc_capregistration qcpp ON qcpp.`ProgramID`=qc.`ProgramID` AND qcpp.`CentreID`=qcp.`CentreId` AND ");
        sb.Append(" qcpp.`ShipmentNo`=qcp.`ShipmentNo` AND qcpp.`InvestigationID`=qc.`InvestigationID` AND qcpp.`IsActive`=1 ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`Test_ID`=qcpp.`Test_id` ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
        sb.Append(" left join patient_labobservation_opd ploo on ploo.test_id=qcpp.test_id and ploo.labobservation_id=qcpp.labobservationid");

        sb.Append(" WHERE qcp.`ShipmentNo`='" + shipmentno + "' AND qcp.`CentreId`=" + centreid + "  ");
        if (type != "")
        {
            sb.Append(" and " + type + " ");
        }
        sb.Append(" order by qc.`ProgramID`,qcpp.LedgerTransactionID,qc.`InvestigationName`,sinno");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    public static string saveresult(List<CAPResult> CAPResultData, string flag)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string investigationid = "";
            foreach (CAPResult eqas in CAPResultData)
            {
                // Update Status of Result
                StringBuilder sb = new StringBuilder();
                if (flag == "0")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_capregistration set result_flag=@result_flag,ResultEnteredDate=@ResultEnteredDate,ResultEnteredName=@ResultEnteredName,ResultEnteredBy=@ResultEnteredBy,VALUE=@Value,Acceptability=@Acceptability,Grade=@Grade where test_id=@test_id and labobservationid=@labobservationid ",
                       new MySqlParameter("@result_flag", "1"),
                       new MySqlParameter("@ResultEnteredDate", DateTime.Now),
                       new MySqlParameter("@ResultEnteredName", UserInfo.LoginName),
                       new MySqlParameter("@ResultEnteredBy", UserInfo.ID), new MySqlParameter("@test_id", eqas.test_id),
                       new MySqlParameter("@Value", eqas.Value),
                       new MySqlParameter("@Acceptability", eqas.Acceptability),
                       new MySqlParameter("@Grade", eqas.Grade),
                        new MySqlParameter("@labobservationid", eqas.LabObservationID)
                       );
                }
                else if (flag == "1")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_capregistration set result_flag=@result_flag,ResultEnteredDate=if(Result_Flag=0,@ResultEnteredDate,ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,@ResultEnteredName,ResultEnteredName),ResultEnteredBy=if(Result_Flag=0,@ResultEnteredBy,ResultEnteredBy) ,Approved=@Approved,ApprovedDate=@ApprovedDate,ApprovedName=@ApprovedName,ApprovedBy=@ApprovedBy,VALUE=@Value,Acceptability=@Acceptability,Grade=@Grade where test_id=@test_id and labobservationid=@labobservationid ",
                      new MySqlParameter("@result_flag", "1"),
                      new MySqlParameter("@ResultEnteredDate", DateTime.Now),
                      new MySqlParameter("@ResultEnteredName", UserInfo.LoginName),
                      new MySqlParameter("@ResultEnteredBy", UserInfo.ID),
                      new MySqlParameter("@test_id", eqas.test_id),
                      new MySqlParameter("@Approved", "1"),
                      new MySqlParameter("@ApprovedDate", DateTime.Now),
                      new MySqlParameter("@ApprovedName", UserInfo.LoginName),
                      new MySqlParameter("@ApprovedBy", UserInfo.ID),
                      new MySqlParameter("@Value", eqas.Value),
                       new MySqlParameter("@Acceptability", eqas.Acceptability),
                       new MySqlParameter("@Grade", eqas.Grade),
                       new MySqlParameter("@labobservationid", eqas.LabObservationID)
                      );
                }

                else if (flag == "2")
                {
                    int result = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select ResultWithin from qc_capprogrammaster where ProgramID=" + eqas.ProgramID + " limit 1 "));

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_capregistration set ResultUploaded=@ResultUploaded,ResultUploadedBy=@ResultUploadedBy,ResultUploadedDate=@ResultUploadedDate,ResultUploadedName=@ResultUploadedName,ExpectedResultDate=DATE_ADD(NOW(),INTERVAL " + result + " DAY) where test_id=@test_id and labobservationid=@labobservationid ",
                     new MySqlParameter("@ResultUploaded", "1"),
                     new MySqlParameter("@ResultUploadedDate", DateTime.Now),
                     new MySqlParameter("@ResultUploadedName", UserInfo.LoginName),
                     new MySqlParameter("@ResultUploadedBy", UserInfo.ID),
                     new MySqlParameter("@test_id", eqas.test_id),
                      new MySqlParameter("@labobservationid", eqas.LabObservationID)
                     );
                }

                else if (flag == "3")
                {

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_capregistration set CAPDone=@CAPDone,CAPDoneBy=@CAPDoneBy,CAPDoneDate=@CAPDoneDate,CAPDoneName=@CAPDoneName,Acceptability=@Acceptability,Grade=@Grade where test_id=@test_id and labobservationid=@labobservationid  ",
                     new MySqlParameter("@CAPDone", "1"),
                     new MySqlParameter("@CAPDoneDate", DateTime.Now),
                     new MySqlParameter("@CAPDoneName", UserInfo.LoginName),
                     new MySqlParameter("@CAPDoneBy", UserInfo.ID),
                     new MySqlParameter("@test_id", eqas.test_id),
                     new MySqlParameter("@Acceptability", eqas.Acceptability),
                     new MySqlParameter("@Grade", eqas.Grade),
                      new MySqlParameter("@labobservationid", eqas.LabObservationID)
                     );
                    // Save OverAll Performance
                    if (investigationid != eqas.investigationid)
                    {
                        int totalrun = CAPResultData.Where(e => e.investigationid == eqas.investigationid).Count();
                        int totalpass = CAPResultData.Where(e => e.investigationid == eqas.investigationid && e.Grade == "Acceptable").Count();

                        float PassPercentage = (totalpass * 100) / totalrun;
                        string grade = "Pass";
                        if (PassPercentage < 80)
                        {
                            grade = "Fail";
                        }



                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into qc_capprogramperformance (ShipmentNo,ProgramID,investigationID,CAPDoneDate,CAPDoneBy,CAPDoneByID,TotalRun,TotalPass,PassPercentage,Grade) values (@ShipmentNo,@ProgramID,@investigationID,@CAPDoneDate,@CAPDoneBy,@CAPDoneByID,@TotalRun,@TotalPass,@PassPercentage,@Grade)",
                            new MySqlParameter("@ShipmentNo", eqas.shipmentno),
                            new MySqlParameter("@ProgramID", eqas.ProgramID),
                            new MySqlParameter("@investigationID", eqas.investigationid),
                            new MySqlParameter("@CAPDoneDate", DateTime.Now),
                            new MySqlParameter("@CAPDoneBy", UserInfo.LoginName),
                            new MySqlParameter("@CAPDoneByID", UserInfo.ID),
                            new MySqlParameter("@TotalRun", totalrun),
                            new MySqlParameter("@TotalPass", totalpass),
                            new MySqlParameter("@PassPercentage", PassPercentage),
                            new MySqlParameter("@Grade", grade)
                            );
                        
                        investigationid = eqas.investigationid;
                    }
                }
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.Message);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string exporttoexcel(string labid, string shipmentno, string programid)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" select qcr.centreid,(select centre from centre_master where centreid=" + labid + ") Centre,");


        sb.Append(" qcr.shipmentno, qcr.programid,(SELECT programname FROM `qc_capprogrammaster` WHERE programid=qcr.programid limit 1 )programname");
        sb.Append(" ,qcr.test_id,qcr.specimen,plo.ledgertransactionno, plo.barcodeno SinNo, ");
        sb.Append("  sm.name departmant,date_format(qcr.entrydate,'%d-%b-%Y') RegDate,plo.InvestigationName,qcr.LabObservationName, ");
        sb.Append(" IFNULL(ploo.`Value`,ifnull(qcr.value,'')) ResultValue,IFNULL(ploo.minvalue,'') minvalue,IFNULL(ploo.`MaxValue`,'')`MaxValue`, ");
        sb.Append(" ifnull(ploo.MacReading,'')MacReading ,ifnull(ploo.MachineName,'')MachineName, ");
        sb.Append(" IFNULL(ploo.`DisplayReading`,'')DisplayReading,IFNULL(ploo.`ReadingFormat`,'')Unit,IFNULL(ploo.flag,'')flag ");
        sb.Append(" ,ifnull(qcr.Acceptability,'')SDI,ifnull(qcr.Grade,'')Grade");
        sb.Append(" ,(case when qcr.capDone=1 then 'CAPDone' when qcr.ResultUploaded=1 then 'ResultUploaded' when qcr.Approved=1 then 'Approved'  when qcr.result_flag=1 then 'ResultDone' else 'New' end)CurrentStatus, ");

        sb.Append(" if(ResultUploaded=1,date_format(ExpectedResultDate,'%d-%b-%Y'),'')ExpectedResultDate, ");

        sb.Append(" DATE_FORMAT(plo.ApprovedDate,'%d-%b-%Y') ResultApprovedinLabDate,plo.ApprovedName ResultApprovedinLabBy,");


        sb.Append(" DATE_FORMAT(qcr.EntryDate,'%d-%b-%Y') CAPRegistrationDate,qcr.EntryByName CAPRegistrationBy,");
        sb.Append(" DATE_FORMAT(qcr.ResultEnteredDate,'%d-%b-%Y') CAPResultEnteredDate,qcr.ResultEnteredName CAPResultEnteredBy,");
        sb.Append(" DATE_FORMAT(qcr.ApprovedDate,'%d-%b-%Y') CAPResultApprovedDate,qcr.ApprovedName CAPResultApprovedBy,");
        sb.Append(" DATE_FORMAT(qcr.ResultUploadedDate,'%d-%b-%Y') CAPResultUploadedDate,qcr.ResultUploadedName CAPResultUploadedBy,");
        sb.Append(" DATE_FORMAT(qcr.CAPDoneDate,'%d-%b-%Y') CAPFinalDoneDate,qcr.CAPDoneName CAPFinalDoneBy");


        sb.Append(" FROM `qc_capregistration` qcr  ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`Test_ID`=qcr.`Test_id` ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
        sb.Append(" LEFT JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID` and ploo.labobservation_id=qcr.labobservationid");
        sb.Append(" WHERE qcr.programid=" + programid + " and qcr.centreid=" + labid + " AND shipmentno='" + shipmentno + "'  ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());





        DataColumn column = new DataColumn();
        column.ColumnName = "S.No";
        column.DataType = System.Type.GetType("System.Int32");
        column.AutoIncrement = true;
        column.AutoIncrementSeed = 0;
        column.AutoIncrementStep = 1;

        dt.Columns.Add(column);
        int index = 0;
        foreach (DataRow row in dt.Rows)
        {
            row.SetField(column, ++index);
        }
        dt.Columns["S.No"].SetOrdinal(0);
        if (dt.Rows.Count > 0)
        {

            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "CAPResult";
            return "true";
        }
        else
        {
            return "false";
        }


    }
}

public class CAPResult
{
    public string shipmentno { get; set; }
    public string ProgramID { get; set; }
    public string test_id { get; set; }
    public string Value { get; set; }
    public string Acceptability { get; set; }
    public string Grade { get; set; }
    public string UploadFileName { get; set; }
    public string investigationid { get; set; }
    public int LabObservationID { get; set; }

}
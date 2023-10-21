using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_Quality_ILC_EQAS_ConfiguredParametersReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            DataTable dt = StockReports.GetDataTable(" SELECT DISTINCT cm.centreid,centre FROM centre_master cm INNER JOIN f_login fl ON cm.`CentreID`=fl.`CentreID` AND fl.`EmployeeID`='" + UserInfo.ID + "' AND fl.Active=1 AND cm.isActive=1 and  cm.centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY cm.centrecode,cm.Centre  ");
             ddlprocessinglab.DataSource = dt;
             ddlprocessinglab.DataValueField = "CentreID";
             ddlprocessinglab.DataTextField = "Centre";
             ddlprocessinglab.DataBind();
        }
    }


    [WebMethod(EnableSession = true)]
    public static string bindCentre(string TypeId)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT centreid,centre FROM centre_master   WHERE Type1Id =" + TypeId + " and centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY centre"));


    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static Dictionary<string, string> Getsummaryreport(string processingcentre, string ReportType)
    {
        StringBuilder sb = new StringBuilder();
        try
        {
        if (ReportType == "1")
        {
            sb.Append("  SELECT id, ProcessingLabID,ProcessingLabName,ILCLabType,ILCLabID,ILCLabName,TestType, ");
            sb.Append("  TestID,TestName,Rate,StartMonthName StartMonth,Fequency, ");
            sb.Append("  IF(IsActive=1,'Active','Deactive')`Status`,DATE_FORMAT(EntryDate,'%d-%b-%y')EntryDate,EntryByName, ");
            sb.Append("  ifnull(DATE_FORMAT(updatedate,'%d-%b-%y'),'') UpdateDate,ifnull(updatebyname,'')UpdateByName");
            sb.Append("  FROM qc_ilcparametermapping where isactive=1");
            if (processingcentre != "")
            {
                sb.Append(" and ProcessingLabID IN ({0}) ");
            }
            sb.Append(" order by ProcessingLabID");
        }
        else
        {
            sb.Append(" SELECT  qe.ProcessingLabID centreid,cm.centre,qcem.EqasProviderName,qe.programid,eqm.programname,");
            sb.Append(" InvestigationName testname,qe.entrybyname,DATE_FORMAT(entrydatetime,'%d-%b-%Y') entrydatetime ");
            sb.Append(" FROM qc_eqasprogramlabmapping qe ");
            sb.Append(" INNER JOIN centre_master cm ON cm.centreid=qe.ProcessingLabID ");
            sb.Append(" INNER JOIN `qc_eqasprogrammaster` eqm ON eqm.programid=qe.programid and eqm.IsActive=1 ");
            sb.Append(" INNER JOIN `qc_eqasprovidermaster` qcem ON qcem.EqasProviderID=qe.EQASProviderID ");
            if (processingcentre != "")
            {
                sb.Append(" WHERE qe.isactive=1 and qe.ProcessingLabID  IN ({0})  order by qe.ProcessingLabID,qe.programid,InvestigationName");
            }
            else
            {
                sb.Append(" WHERE qe.isactive=1 order by qe.ProcessingLabID,qe.programid,InvestigationName");
            }

        }

        Dictionary<string, string> returnData = new Dictionary<string, string>();
        if (ReportType == "1")       
            returnData.Add("ReportDisplayName", Common.EncryptRijndael("ILC Parameter Mapping Report"));     
        else        
            returnData.Add("ReportDisplayName", Common.EncryptRijndael("EQAS Parameter Mapping Report"));  
        returnData.Add("processingcentre#1", Common.EncryptRijndael(processingcentre));       
        returnData.Add("Query", Common.EncryptRijndael(sb.ToString()));       
        returnData.Add("ReportPath", "../Common/ExportToExcelReport.aspx");      
        returnData.Add("IsAutoIncrement", Common.EncryptRijndael("1"));      
        return returnData;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
}
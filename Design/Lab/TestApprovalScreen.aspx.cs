using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_TestApprovalScreen : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string RoleID = Util.GetString(UserInfo.RoleID);
        string ApprovalId = StockReports.ExecuteScalar("SELECT max(`Approval`)  FROM `f_approval_labemployee` WHERE `RoleID`='" + RoleID + "' AND IF(`TechnicalId`='',`EmployeeID`,`TechnicalId`)='" + UserInfo.ID + "'");

        if (ApprovalId != "4")
        {
            m1.Style.Add("display", "none");
            m2.Style.Add("display", "");
        }
        else
        {
            m1.Style.Add("display", "");
            m2.Style.Add("display", "none");
        }

        if (!IsPostBack)
        {

            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            BindDepartment();
        }
    }

    private void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='LSHHI3'   ");
        if (Util.GetString(HttpContext.Current.Session["AccessDepartment"]) != "")
        {
            sb.Append("  and  SubCategoryID in ('" + Util.GetString(HttpContext.Current.Session["AccessDepartment"]).Replace(",", "','") + "') ");
        }
        sb.Append(" ORDER BY NAME");
        ddlDepartment.DataSource = StockReports.GetDataTable(sb.ToString());
        ddlDepartment.DataTextField = "NAME";
        ddlDepartment.DataValueField = "SubCategoryID";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, new ListItem("All Department", ""));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string binddata(string FromDate, string ToDate, string CentreID, string Department, string TimeFrm, string TimeTo)
    {
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return "-1";
        }

        StringBuilder sb = new StringBuilder();
        sb.Append(" select cm.CentreID,(select state from state_master ss where ss.id=cm.StateID) State  ");
        sb.Append(" ,(select city from city_master ss where ss.id=cm.CityID) City,  cm.centre,count(*) Pending,COUNT(DISTINCT pli.`LedgerTransactionID`) PatientCount from patient_labinvestigation_opd pli");

        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID` AND lt.`IsCancel`=0  and pli.result_flag=1 and pli.approved=0  ");
        sb.Append(" INNER JOIN `investigation_master` im ON im.investigation_ID=pli.investigation_ID and im.isCulture=0 and im.ReportType<>7    ");
        sb.Append(" inner join investigation_observationtype iot on iot.Investigation_ID=pli.Investigation_ID  ");
        if (Department != "")
            sb.Append("  and iot.ObservationType_ID='" + Department + "' ");

        sb.Append(" inner join centre_master cm ON cm.`CentreID`=pli.TestCentreID  ");
        if (CentreID != "ALL")
        {
            sb.Append("  and pli.TestCentreID='" + CentreID + "' ");
        }
        else
        {
            sb.Append(" and ( pli.TestCentreID in ( select ca.CentreAccess from   centre_access ca where  ca.Centreid='" + UserInfo.Centre + "' )   or pli.TestCentreID='" + UserInfo.Centre + "') ");

        }
        sb.Append("  AND pli.sampledate >='" + (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm) + "' ");
        sb.Append(" AND pli.sampledate <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + TimeTo + "' ");

        sb.Append(" group by pli.TestCentreID order by State,City,centre ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Encrypt(string data)
    {
        return Common.Encrypt(data);
    }
    
    
}
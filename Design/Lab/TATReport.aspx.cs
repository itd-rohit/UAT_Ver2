using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using Newtonsoft.Json;

public partial class Design_Lab_TATReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (!IsPostBack)
        {
            dtFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            dtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            bindRefer();
            bindAccessCentre();
            BindPanel();
            BindDepartment();
            bindInvestigation();
            //  BindReportFields();

        }

    }
    private void BindPanel()
    {

        ddlPanel.Items.Insert(0, "");
        ddlPanel.Enabled = false;

    }
    private void bindRefer()
    {

        ddlReferDoctor.Items.Insert(0, "");
        ddlReferDoctor.Enabled = false;
    }
    private void bindAccessCentre()
    {
        ddlCentreAccess.DataSource = AllLoad_Data.getCentreByLogin();
        ddlCentreAccess.DataTextField = "Centre";
        ddlCentreAccess.DataValueField = "CentreID";
        ddlCentreAccess.DataBind();
        ddlCentreAccess.Items.Insert(0, new ListItem("ALL", "ALL"));
    }


    protected void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT om.Name,om.ObservationType_ID FROM f_subcategorymaster sc INNER JOIN observationtype_master om ON om.Description=sc.SubCategoryID ");
        sb.Append(" WHERE sc.Active='1' AND sc.CategoryID='LSHHI3' ORDER BY om.Name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataValueField = "ObservationType_ID";
            ddlDepartment.DataTextField = "Name";

            ddlDepartment.DataBind();
            ListItem list = new ListItem("", "");
            ddlDepartment.Items.Insert(0, list);
        }
    }

    private void bindInvestigation()
    {
        ddlInvestigation.Items.Insert(0, "");
        ddlInvestigation.Enabled = false;
    }

    [WebMethod]
    public static string GetReport(string FromDate, string ToDate, string CentreId, string ReportFromat, string PanelID, string DepartmentID, string Reporttype, string InvestigationID, string DoctorID, string Labno, string PatientID, string barcodeno, string SearchByDate, string Status, string chkTATDelay, string ChkisUrgent, string Pname)
    {
        string frdate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd");
        string tdate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd");
        try
        {
            return JsonConvert.SerializeObject(new { fromDate = frdate, toDate = tdate, CentreId = CentreId, ReportFormat = ReportFromat, PanelID = PanelID, DepartmentID = DepartmentID, Reporttype = Reporttype, InvestigationID = InvestigationID, DoctorID = DoctorID, Labno = Labno, PatientID = PatientID, barcodeno = barcodeno, SearchByDate = SearchByDate, Status = Status, chkTATDelay = chkTATDelay, ChkisUrgent = ChkisUrgent, Pname=Pname });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
   
}



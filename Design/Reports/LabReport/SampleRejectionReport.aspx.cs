using Newtonsoft.Json;
using System;
using System.Collections.Specialized;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;

public partial class Design_OPD_SampleRejectionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindCentreMaster();
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
            reportaccess();
            bindAccessTestCentre();
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(30));
        if (response.status == true)
        {
            if (response.DurationInDay > 0)
            {
                DateTime date = Util.GetDateTime(txtFromDate.Text).AddDays(response.DurationInDay);
                if (date < DateTime.Now.Date)
                {
                    lblMsg.Text = "You are not authorized to view more than " + response.DurationInDay + " days data";
                    return false;
                }
            }
            if (response.ShowPdf == 1 && response.ShowExcel == 0)
            {
                rdoReportFormat.Items[0].Enabled = true;
                rdoReportFormat.Items[1].Enabled = false;
                rdoReportFormat.Items[0].Selected = true;
            }
            else if (response.ShowExcel == 1 && response.ShowPdf == 0)
            {
                rdoReportFormat.Items[1].Enabled = true;
                rdoReportFormat.Items[0].Enabled = false;
                rdoReportFormat.Items[1].Selected = true;
            }
            else if (response.ShowPdf == 0 && response.ShowExcel == 0)
            {
                rdoReportFormat.Visible = false;
                lblMsg.Text = "Report format not allowed contect to admin";
                return false;
            }
            //else
            //{
            //    rdoReportFormat.Items[0].Selected = true;
            //}
        }
        else
        {
            div1.Visible = false;
            div2.Visible = false;
            div3.Visible = false;
            div4.Visible = false;
            div5.Visible = false;
            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }
    private void bindCentreMaster()
    {
        using (DataTable dt = AllLoad_Data.getCentreByLogin())
        {
            if (dt.Rows.Count > 0)
            {
                chlCentres.DataSource = dt;
                chlCentres.DataTextField = "Centre";
                chlCentres.DataValueField = "centreID";
                chlCentres.DataBind();
                BindDepartment();
            }
        }
    }
    private void bindAccessTestCentre()
    {

        using (DataTable dt = AllLoad_Data.loadCentre())
            if (dt != null && dt.Rows.Count > 0)
            {
                chlTestCentres.DataSource = dt;
                chlTestCentres.DataTextField = "Centre";
                chlTestCentres.DataValueField = "CentreID";
                chlTestCentres.DataBind();
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
        chkDept.DataSource = StockReports.GetDataTable(sb.ToString());
        chkDept.DataTextField = "NAME";
        chkDept.DataValueField = "SubCategoryID";
        chkDept.DataBind();
    }

    protected void btnPDFReport_Click(object sender, EventArgs e)
    {
        string Centres = AllLoad_Data.GetSelection(chlCentres);
        string TestCentres = AllLoad_Data.GetSelection(chlTestCentres);
        if (Centres.Trim() == "")
        {
            lblMsg.Text = "Please Select Booking Centre";
            return;
        }
        if (TestCentres.Trim() == "")
        {
            lblMsg.Text = "Please Select Test Centre";
            return;
        }
        string Departments = AllLoad_Data.GetSelection(chkDept);
        if (Departments.Trim() == "")
        {
            lblMsg.Text = "Please Select Department";
            return;
        }
        try
        {
            NameValueCollection collections = new NameValueCollection();
            collections.Add("fromDate",Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd"));
            collections.Add("toDate", Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd"));
            collections.Add("CentreID", Centres);
            collections.Add("TestCentre", TestCentres);
            collections.Add("DepartmentID", Departments);
            collections.Add("reportformat", rdoReportFormat.SelectedValue);
            AllLoad_Data.POSTForm(collections, "Design/Reports/LabReport/SampleRejectionReportPdf.aspx", this.Page);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

    }
}
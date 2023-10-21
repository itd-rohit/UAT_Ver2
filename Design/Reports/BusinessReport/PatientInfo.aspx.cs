using Newtonsoft.Json;
using System;
using System.Collections.Specialized;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;

public partial class Design_OPD_PatientInfo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            bindCentreMaster();
            BindDepartment();
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
            reportaccess();
        }       
    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(9));
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
            divcentre.Visible = false;
            divuser.Visible = false;
            divsave.Visible = false;
            divdept.Visible = false;
            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }
    public void bindCentreMaster()
    {
        using (DataTable dt = AllLoad_Data.getCentreByLogin())
        {
            if (dt.Rows.Count > 0)
            {
                chlCentres.DataSource = dt;
                chlCentres.DataTextField = "Centre";
                chlCentres.DataValueField = "CentreID";
                chlCentres.DataBind();
            }
        }

    }
    private void BindDepartment()
    {
        using (DataTable dt = AllLoad_Data.getDepartment())
        {
            if (dt.Rows.Count > 0)
            {
                chkDept.DataSource = dt;
                chkDept.DataTextField = "NAME";
                chkDept.DataValueField = "SubCategoryID";
                chkDept.DataBind();
            }
        }
    }
    protected void btnPDFReport_Click(object sender, EventArgs e)
    {
        if (!reportaccess())
            return;
        string startDate = string.Empty, toDate = string.Empty, Client = string.Empty;

        string rresult = Util.DateDiffReportSearch(Util.GetDateTime(txtToDate.Text), Util.GetDateTime(txtFromDate.Text));
        if (rresult == "true")
        {
            lblMsg.Text = "Your From date ,To date Diffrence is too  Long";
            return;
            //return JsonConvert.SerializeObject(new { status = false, response = "Your From date ,To date Diffrence is too  Long" });
        }
        if (txtFromDate.Text != string.Empty)
            if (txtFromTime.Text.Trim() != string.Empty)
                startDate = string.Concat(Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd"), " ", txtFromTime.Text.Trim());
            else
                startDate = Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd");

        if (txtToDate.Text != string.Empty)
            if (txtToTime.Text.Trim() != string.Empty)
                toDate = string.Concat(Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd"), " ", txtToTime.Text.Trim());
            else
                toDate = Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd");
        string Centres = AllLoad_Data.GetSelection(chlCentres);
        if (Centres.Trim() == string.Empty)
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        string DeptList = AllLoad_Data.GetSelection(chkDept);
      
        string DuePatient = "0";
        if (chkOnlyDue.Checked == true)
            DuePatient = "1";
        string DiscPatient = "0";
        if (chkOnlyDiscount.Checked == true)
            DiscPatient = "1";

        try
        {
            NameValueCollection collections = new NameValueCollection();
            collections.Add("fromDate", startDate.Trim());
            collections.Add("toDate", toDate.Trim());
            collections.Add("CentreID", Centres.Replace("'",""));
            collections.Add("ReportType", rbtReportType.SelectedValue);
            collections.Add("SubcategoryID", DeptList.Replace("'", ""));
            collections.Add("DuePatient", DuePatient);
            collections.Add("DiscountPatient", DiscPatient);
            collections.Add("ReportFormat", rdoReportFormat.SelectedValue);
            AllLoad_Data.POSTForm(collections, "Design/Reports/BusinessReport/PatientInfoPdf.aspx", this.Page);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}
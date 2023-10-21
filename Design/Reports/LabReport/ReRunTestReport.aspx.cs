using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
public partial class Design_OPD_ReRunTestReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            dtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            reportaccess();
            bindCentreMaster();
            bindAccessTestCentre();
        }
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
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(36));
        if (response.status == true)
        {
            if (response.DurationInDay > 0)
            {
                DateTime date = Util.GetDateTime(dtFrom.Text).AddDays(response.DurationInDay);
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
            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }
    [WebMethod]
    public static string GetReport(string FromDate, string ToDate, string ReportFromat, string Reporttype, string LabNo, string CentreId, string TestCentreId)
    {
        string frdate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd");
        string tdate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd");
        try
        {
            return JsonConvert.SerializeObject(new { fromDate = frdate, toDate = tdate, ReportFormat = ReportFromat, Reporttype = Reporttype, LabNo = LabNo, CentreId = CentreId.TrimEnd(','), TestCentreId = TestCentreId.TrimEnd(',') });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

}
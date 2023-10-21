using Newtonsoft.Json;
using System;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_Reports_BillWiseCollectionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
            reportaccess();
        }
    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(12));
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
        }
        else
        {
            divcentre.Visible = false;
            divuser.Visible = false;
            divsave.Visible = false;
            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }
    [WebMethod]
    public static string getReport(object data)
    {
        return Util.getJson(new { ReportData = JsonConvert.SerializeObject(data).ToString(), ReportName = "BillWise Report", Period = string.Empty, ReportPath = "BusinessReport/BillWiseCollectionReportPdf.aspx" });
    }
}
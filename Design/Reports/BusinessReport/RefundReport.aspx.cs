using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI;

public partial class Design_OPD_RefundReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCenter();
            FillDateTime();
            reportaccess();
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }

    public void BindCenter()
    {

        DataTable dt = AllLoad_Data.getCentreByLogin();
        chklstCenter.DataSource = dt;
        chklstCenter.DataTextField = "Centre";
        chklstCenter.DataValueField = "CentreID";
        chklstCenter.DataBind();
        for (int i = 0; i < chklstCenter.Items.Count; i++)
            chklstCenter.Items[i].Selected = true;
        // chkCentre.Checked = true;
    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(19));
        if (response.status == true)
        {
            if (response.DurationInDay > 0)
            {
                DateTime date = Util.GetDateTime(ucFromDate.Text).AddDays(response.DurationInDay);
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
            divsave.Visible = false;
            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }
    private void FillDateTime()
    {
        ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
    }

    [WebMethod]
    public static string GetReport(string FromDate, string ToDate, string CentreId, string ReportFromat,  string Reporttype)
    {
        string frdate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd");
        string tdate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd");

        string rresult = Util.DateDiffReportSearch(Util.GetDateTime(ToDate), Util.GetDateTime(FromDate));
        if (rresult == "true")
        {
            //lblMsg.Text = "Your From date ,To date Diffrence is too  Long";
            //return JsonConvert.SerializeObject(new { status = false, response = "Your From date ,To date Diffrence is too  Long" });
            return "-1";
        }

        try
        {
            return JsonConvert.SerializeObject(new { fromDate = frdate, toDate = tdate, CentreId = CentreId.TrimEnd(','), ReportFormat = ReportFromat,  Reporttype = Reporttype });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
}
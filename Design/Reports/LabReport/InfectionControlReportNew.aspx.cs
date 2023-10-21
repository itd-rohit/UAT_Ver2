using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Lab_InfectionControlReportNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtfromdate, txttodate);
        }
    }


    [WebMethod(EnableSession = true)]
    public static string bindCentre()
    {
        DataTable dt = StockReports.GetDataTable("SELECT  cm.`CentreID`,cm.`Centre` FROM centre_master cm  WHERE IsActive=1  order by Centre");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string GetReport(string FromDate, string ToDate, string CentreId, string ReportFromat)
    {
        string frdate = string.Concat(Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"), " 00:00:00");
        string tdate = string.Concat(Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"), " 23:59:59");       
        try
        {
            return JsonConvert.SerializeObject(new { CentreID = CentreId, fromDate = frdate, toDate = tdate, ReportFormat = ReportFromat });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        } 
    }
}
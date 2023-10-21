using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_GRNReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(string fromdate, string todate, string locationid, string apptype, string type1, string DateFilter, string Status)
    {
        try
        {
            return JsonConvert.SerializeObject(new
            {
                status = true,
                FromDate = Common.EncryptRijndael(Util.GetString(fromdate)),
                ToDate = Common.EncryptRijndael(Util.GetString(todate)),
                AppType = Common.EncryptRijndael(Util.GetString(apptype)),
                Type1 = Common.EncryptRijndael(Util.GetString(type1)),
                LocationID = Common.EncryptRijndael(locationid),
                DateFilter = Common.EncryptRijndael(DateFilter),
                Status = Common.EncryptRijndael(Status),
                ReportType = Common.EncryptRijndael("GRNReport"),
                ReportDisplayName = Common.EncryptRijndael("GRN Report"),                
                IsAutoIncrement = Common.EncryptRijndael("1"),
                ReportPath = "../Common/ExportToExcelEncrypt.aspx"
            });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new
            {
                status = false

            });
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReportPDF(string fromdate, string todate, string locationid, string apptype, string DateFilter, string Status)
    {

        try
        {
            return JsonConvert.SerializeObject(new
            {
                status = true,
                FromDate = Common.EncryptRijndael(Util.GetString(fromdate)),
                ToDate = Common.EncryptRijndael(Util.GetString(todate)),
                AppType = Common.EncryptRijndael(Util.GetString(apptype)),
                Type1 = Common.EncryptRijndael(Util.GetString(1)),
                LocationID = Common.EncryptRijndael(locationid),
                DateFilter = Common.EncryptRijndael(DateFilter),
                Status = Common.EncryptRijndael(Status),
                ReportPath = "GRNReportPDF.aspx"
            });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new
            {
                status = false

            });
        }
    }

}
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_PurchaseOrderReport : System.Web.UI.Page
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
    public static string GetReport(string fromdate, string todate, string type, string type1)
    {

        try
        {
            return JsonConvert.SerializeObject(new
            {
                status = true,
                FromDate = Common.EncryptRijndael(Util.GetString(fromdate)),
                ToDate = Common.EncryptRijndael(Util.GetString(todate)),
                Type1 = Common.EncryptRijndael(Util.GetString(type1)),
                Type = Common.EncryptRijndael(type),
                ReportType = Common.EncryptRijndael("PurchaseOrderReport"),
                ReportPath = "../Common/ExportToExcelEncrypt.aspx",
                ReportDisplayName = Common.EncryptRijndael("PurchaseOrderReport"),
                IsAutoIncrement = Common.EncryptRijndael("0")
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
    public static string GetReportPDF(string fromdate, string todate, string type, string type1)
    {
        try
        {
            return JsonConvert.SerializeObject(new
            {
                status = true,
                FromDate = Common.EncryptRijndael(Util.GetString(fromdate)),
                ToDate = Common.EncryptRijndael(Util.GetString(todate)),
                Type1 = Common.EncryptRijndael(Util.GetString(1)),
                Type = Common.EncryptRijndael(type),
                ReportPath = "PurchaseOrderReportPDF.aspx"
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
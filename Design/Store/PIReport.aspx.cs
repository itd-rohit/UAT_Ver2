using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_PIReport : System.Web.UI.Page
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
    public static string GetReport(string fromdate, string todate, string type, string ch, string locationid, string indentno, string reportType)
    {
        string ReportPath = string.Empty;
        String ReportDisplayName = "Indent Report";
        if (reportType == "PDF")
        {
            ReportPath = "PIReportPDF.aspx";
        }
        else
        {
            ReportPath = "../Common/ExportToExcelEncrypt.aspx";
        }
        try
        {
            return JsonConvert.SerializeObject(new
            {
                status = true,
                FromDate = Common.EncryptRijndael(fromdate),
                ToDate = Common.EncryptRijndael(todate),
                Type = Common.EncryptRijndael(Util.GetString(type)),
                Ch = Common.EncryptRijndael(Util.GetString(ch)),
                LocationID = Common.EncryptRijndael(Util.GetString(locationid)),
				IndentNo = Common.EncryptRijndael(Util.GetString(indentno)),
                ReportType = Common.EncryptRijndael("IndentReport"),
                ReportDisplayName = Common.EncryptRijndael(ReportDisplayName),
                IsAutoIncrement = Common.EncryptRijndael("1"),
                ReportPath = ReportPath
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
    public static string GetReportPDF(string fromdate, string todate, string type, string ch, string locationid)
    {
        try
        {
            return JsonConvert.SerializeObject(new
            {
                status = true,
                FromDate = Common.EncryptRijndael(fromdate),
                ToDate = Common.EncryptRijndael(todate),
                Type = Common.EncryptRijndael(Util.GetString(type)),
                Ch = Common.EncryptRijndael(Util.GetString(ch)),
                LocationID = Common.EncryptRijndael(Util.GetString(locationid)),
                ReportPath = "PIReportPDF.aspx"
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
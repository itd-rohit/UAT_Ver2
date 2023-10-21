using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_ConsumeReport : System.Web.UI.Page
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
    public static string GetReport(string type, string fromdate, string todate, string categorytypeid, string subcategorytypeid, string subcategoryid, string itemid, string locationid, string machineid, string reportType)
    {
        string ReportPath = string.Empty;
        String ReportDisplayName = string.Empty;
        if (type == "0")
            ReportDisplayName = "UnConsume Report Detail";
        else if (type == "1")
            ReportDisplayName = "UnConsume Report Item Summary";
        else
            ReportDisplayName = "UnConsume Report Amt Summary";
        if (reportType == "PDF")
        {
            ReportPath = "UnConsumeReportPDF.aspx";
        }
        else
        {
            ReportPath="../Common/ExportToExcelEncrypt.aspx";
        }
        try
        {
            return JsonConvert.SerializeObject(new
            {
                status = true,
                ManufactureID=Common.EncryptRijndael(""),
                Type = Common.EncryptRijndael(Util.GetString(type)),
                FromDate = Common.EncryptRijndael(fromdate),
                ToDate = Common.EncryptRijndael(todate),
                CategoryTypeID = Common.EncryptRijndael(categorytypeid),               
                SubCategoryTypeID = Common.EncryptRijndael(subcategorytypeid),
                SubCategoryID = Common.EncryptRijndael(subcategoryid),
                ItemID = Common.EncryptRijndael(itemid),
                LocationID = Common.EncryptRijndael(locationid),
                MachineID = Common.EncryptRijndael(machineid),
                ReportType = Common.EncryptRijndael("StockUnConsume"),
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



   
}
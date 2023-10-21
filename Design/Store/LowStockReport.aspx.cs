using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_LowStockReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(string categorytypeid, string subcategorytypeid, string subcategoryid, string itemid, string locationid, string machineid, string apptype, string reportType)
    {
        string ReportPath = string.Empty;

        if (reportType == "PDF")
        {
            ReportPath = "LowStockReportPDF.aspx";
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
                ItemID = Common.EncryptRijndael(Util.GetString(itemid)),
                CategorytypeId = Common.EncryptRijndael(Util.GetString(categorytypeid)),
                SubCategoryTypeId = Common.EncryptRijndael(Util.GetString(subcategorytypeid)),
                SubCategoryId = Common.EncryptRijndael(Util.GetString(subcategoryid)),
                LocationID = Common.EncryptRijndael(locationid),
                MachineID = Common.EncryptRijndael(machineid),
                Apptype = Common.EncryptRijndael(apptype),
                ReportType = Common.EncryptRijndael("LowStock"),                
                ReportDisplayName = Common.EncryptRijndael("LowStockReport"),
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
    public static string GetReportPDF(string categorytypeid, string subcategorytypeid, string subcategoryid, string itemid, string locationid, string machineid,string apptype)
    {
        try
        {
            return JsonConvert.SerializeObject(new
            {
                status = true,
                ItemID = Common.EncryptRijndael(Util.GetString(itemid)),
                CategorytypeId = Common.EncryptRijndael(Util.GetString(categorytypeid)),
                SubCategoryTypeId = Common.EncryptRijndael(Util.GetString(subcategorytypeid)),
                SubCategoryId = Common.EncryptRijndael(Util.GetString(subcategoryid)),
                LocationID = Common.EncryptRijndael(locationid),
                MachineID = Common.EncryptRijndael(machineid),
                Apptype = Common.EncryptRijndael(apptype),
                ReportPath = "LowStockReportPDF.aspx"
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
﻿using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
public partial class Design_Store_StockExpiryReport : System.Web.UI.Page
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
    public static string GetReportPDF(string fromdate, string todate, string categorytypeid, string subcategorytypeid, string subcategoryid, string itemid, string locationid, string machineid)
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
                FromDate = Common.EncryptRijndael(fromdate),
                ToDate = Common.EncryptRijndael(todate),
                ReportDisplayName = Common.EncryptRijndael("StockExpiryReport"),
                IsAutoIncrement = Common.EncryptRijndael("0"),
                ReportPath = "StockExpiryReportPDF.aspx"
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
    public static string GetReport(string fromdate, string todate, string categorytypeid, string subcategorytypeid, string subcategoryid, string itemid, string locationid, string machineid, string reportType)
    {
        string ReportPath = string.Empty;

        if (reportType == "PDF")
        {
            ReportPath = "StockExpiryReportPDF.aspx";
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
                FromDate = Common.EncryptRijndael(fromdate),
                ToDate = Common.EncryptRijndael(todate),
                ReportPath = ReportPath,
                ReportType = Common.EncryptRijndael("StockExpiry"),
                ReportDisplayName = Common.EncryptRijndael("StockExpiryReport"),
                IsAutoIncrement = Common.EncryptRijndael("1"),
                //ReportPath = "../Common/ExportToExcelEncrypt.aspx"

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
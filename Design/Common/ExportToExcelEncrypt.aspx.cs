using ClosedXML.Excel;
using System;
using System.Data;
using System.IO;
using System.Web.UI;

public partial class Design_Common_ExportToExcelEncrypt : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Request.Form.Count > 0)
        {
            string ReportType = Common.DecryptRijndael(Request.Form["ReportType"]);
            DataTable dt = new DataTable();
            using (dt as IDisposable)
            {
//System.IO.File.WriteAllText(@"D:\Shat\aa.txt",Util.GetString( Request.Form["ReportType"]));

                switch (ReportType)
                {

                    case "StockStatus":
                        dt = Store_ReportQuery.StockStatusReport(Request.Form["ItemID"], Request.Form["ManufactureID"], Request.Form["MacID"], Request.Form["LocationID"]);
                        break;
                    case "StockConsume":
                        dt = Store_ReportQuery.StockConsumeReport(Request.Form["ItemID"], Request.Form["ManufactureID"], Request.Form["MachineID"], Request.Form["LocationID"], Request.Form["Type"], Request.Form["CategoryTypeID"], Request.Form["SubCategoryTypeID"], Request.Form["SubCategoryID"], Request.Form["FromDate"], Request.Form["ToDate"], Request.Form["IsAutoIncrement"]);
                        break;
                    case "IssueReport":
                        dt = Store_ReportQuery.StockIssueReport(Request.Form["Type"], Request.Form["FromDate"], Request.Form["ToDate"], Request.Form["CategoryTypeID"], Request.Form["SubCategoryTypeID"], Request.Form["SubCategoryID"], Request.Form["ItemID"], Request.Form["LocationID"], Request.Form["MachineID"], Request.Form["DateOption"], Request.Form["IssueType"], Request.Form["IndentNo"], Request.Form["IsAutoIncrement"]);
                        break;
                    case "StockExpiry":
                        dt = Store_ReportQuery.StockExpiryReport(Request.Form["FromDate"], Request.Form["ToDate"], Request.Form["CategorytypeId"], Request.Form["SubCategoryTypeId"], Request.Form["SubCategoryId"], Request.Form["ItemID"], Request.Form["LocationID"], Request.Form["MachineID"]);
                        break;
                    case "LowStock":
                        dt = Store_ReportQuery.LowStockReport(Request.Form["CategorytypeId"], Request.Form["SubCategoryTypeId"], Request.Form["SubCategoryId"], Request.Form["ItemID"], Request.Form["LocationID"], Request.Form["MachineID"], Request.Form["Apptype"]);
                        break;
                    case "IndentReport":
                        dt= Store_ReportQuery.IndentReport(Request.Form["FromDate"], Request.Form["ToDate"], Request.Form["Type"], Request.Form["Ch"], Request.Form["LocationID"], Request.Form["IndentNo"]);
                        break;
                    case "GRNReport":
                        dt = Store_ReportQuery.GRNReport(Request.Form["FromDate"], Request.Form["ToDate"], Request.Form["LocationID"], Request.Form["AppType"], Request.Form["Type1"], Request.Form["DateFilter"], Request.Form["Status"]);
                        break;
                    case "PurchaseOrderReport":
                        dt = Store_ReportQuery.PurchaseOrderReport(Request.Form["FromDate"], Request.Form["ToDate"], Request.Form["Type"], Request.Form["Type1"]);
                        break;
                    case "StockUnConsume":
                        dt = Store_ReportQuery.StockUnConsumeReport(Request.Form["ItemID"], Request.Form["MachineID"], Request.Form["LocationID"], Request.Form["Type"], Request.Form["CategoryTypeID"], Request.Form["SubCategoryTypeID"], Request.Form["SubCategoryID"], Request.Form["FromDate"], Request.Form["ToDate"], Request.Form["IsAutoIncrement"]);
                        break;
                    //case "StockLedgerReport":
                    //    dt = Store_ReportQuery.StockLedgerReport(Request.Form["LocationID"], Request.Form["ItemID"], Request.Form["Manu"], Request.Form["MachineID"], Request.Form["FromDate"], Request.Form["ToDate"]);
                  //      break;
                }
//System.IO.File.WriteAllText(@"D:\Shat\aa.txt",Util.GetString( dt.Rows.Count));
                if (dt!=null)
                {
                    string Period = string.Empty;
                    string ReportName = Common.DecryptRijndael(Request.Form["ReportDisplayName"]);
                    if ( Common.DecryptRijndael(Request.Form["IsAutoIncrement"]) == "1")
                    {
                        DataTable dtIncremented = new DataTable(dt.TableName);
                        DataColumn dc = new DataColumn("ID");
                        dc.AutoIncrement = true;
                        dc.AutoIncrementSeed = 1;
                        dc.AutoIncrementStep = 1;
                        dc.DataType = System.Type.GetType("System.Int32");
                        dtIncremented.Columns.Add(dc);
                        dtIncremented.BeginLoadData();
                        DataTableReader dtReader = new DataTableReader(dt);
                        dtIncremented.Load(dtReader);
                        dtIncremented.EndLoadData();
                        dtIncremented.AcceptChanges();
                    }
                    BindData(dt, ReportName);
                    if (Request.Form["Period"] != null)
                        Period = Request.Form["Period"].ToString();
                    else
                        Period = string.Empty;
                    lblHeader.Text = ReportName;
                    lblPeriod.Text = Period;
                }
                else
                {
                    lblmsg.Text = "No Record Found";
                    btnExport.Visible = false;
                }
            }
        }
    }

    public MemoryStream GetStream(XLWorkbook excelWorkbook)
    {
        using (MemoryStream fs = new MemoryStream())
        {
            excelWorkbook.SaveAs(fs);
            fs.Position = 0;
            return fs;
        }
    }

    protected void BindData(DataTable dt, String ReportName)
    {
        lblmsg.Text = string.Empty;
        try
        {
            dt.TableName = "data";
            using (var wb = new XLWorkbook())
            {
                wb.Worksheets.Add(dt);
                byte[] package = ((MemoryStream)GetStream(wb)).ToArray();
                string attachment = "attachment; filename=" + ReportName.ToString() + ".xlsx";
                Response.ClearContent();
                Response.AddHeader("content-disposition", attachment);
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.BinaryWrite(package);
                Response.End();
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
        finally
        {
        }
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        btnExport.Visible = false;
        lblmsg.Visible = false;
        string ReportName = lblHeader.Text;
        Response.Clear();
        Response.AddHeader("content-disposition", "attachment;filename=" + ReportName + ".xls");
        Response.Charset = "";
        Response.ContentType = "application/vnd.xls";

        StringWriter StringWriter = new System.IO.StringWriter();
        HtmlTextWriter HtmlTextWriter = new HtmlTextWriter(StringWriter);
        this.RenderControl(HtmlTextWriter);
        Response.Write(StringWriter.ToString());
        Response.Clear();
        Response.End();
        btnExport.Visible = true;
        lblmsg.Visible = true;
    }

}
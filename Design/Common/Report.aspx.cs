using ClosedXML.Excel;
using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI;

public partial class Design_Common_Report : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form.Count > 0)
        {
            string Query = Request.Form["Query"];

            using (DataTable dt = StockReports.GetDataTable(Query))
            {
                if (dt.Rows.Count > 0)
                {
                    string Period = string.Empty;
                    string ReportName = Request.Form["ReportName"];
                    if (Request.Form["IsAutoIncrement"] == "1")
                    {
                        using (DataTable dtIncremented = new DataTable(dt.TableName))
                        {
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
                    }
                    if (Request.Form["Period"] != null)
                        Period = Request.Form["Period"].ToString();
                    else
                        Period = string.Empty;
                    BindData(dt, ReportName, Period);

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

    protected void BindData(DataTable dt, String ReportName, String Period)
    {
        lblmsg.Text = string.Empty;
        try
        {
            dt.TableName = "data";

            using (var wb = new XLWorkbook())
            {
                // Add a DataTable as a worksheet
                string WorksheetName = ReportName.Length > 30 ? ReportName.Substring(0, 30) : ReportName;
                var ws = wb.Worksheets.Add(WorksheetName);
                ws.Cell(1, 4).Style.Font.Bold = true;
                ws.Cell(2, 4).Style.Font.Bold = true;
                ws.Cell(1, 4).InsertData(new System.Collections.Generic.List<string[]> { new string[] { ReportName.ToString() } });
                ws.Cell(2, 4).InsertData(new System.Collections.Generic.List<string[]> { new string[] { string.Concat(Period.ToString(), "  (Print Date Time : ", DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), ")") } });
                ws.Cell(3, 1).InsertTable(dt);
                // wb.Worksheets.Add(dt);
                // byte[] package = ((MemoryStream)GetStream(wb)).ToArray();
                using (MemoryStream stream = GetStream(wb))
                {
                    string attachment = "attachment; filename=" + ReportName.ToString() + ".xlsx";
                    Response.ClearContent();
                    Response.AddHeader("content-disposition", attachment);
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.BinaryWrite(stream.ToArray());
                    stream.Close();
                    stream.Dispose();
                    // Response.End();
                    Response.Flush();
                    // Response.Clear();
                    HttpContext.Current.Response.SuppressContent = true;
                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                }
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
        finally
        {
            Request.Form.Clear();
        }
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        btnExport.Visible = false;
        lblmsg.Visible = false;

        string ReportName = lblHeader.Text;

        Response.Clear();
        //   application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
        Response.AddHeader("content-disposition", "attachment;filename=" + ReportName + ".xls");
        Response.Charset = "";
        Response.ContentType = "application/vnd.xls";

        StringWriter StringWriter = new System.IO.StringWriter();
        HtmlTextWriter HtmlTextWriter = new HtmlTextWriter(StringWriter);
        this.RenderControl(HtmlTextWriter);

        Response.Write(StringWriter.ToString());
        // Response.Clear();
        // Response.End();

        btnExport.Visible = true;
        lblmsg.Visible = true;
    }
}
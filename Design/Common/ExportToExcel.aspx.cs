using ClosedXML.Excel;
using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI;

public partial class Design_Common_ExportToExcel : System.Web.UI.Page
{
    public override void VerifyRenderingInServerForm(Control control)
    {
        return;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string Period = string.Empty; string ReportName = string.Empty;

            if (Session["ReportName"] != null)
                ReportName = Util.GetString(Session["ReportName"].ToString());
            else
                ReportName = string.Empty;
            if (Session["Period"] != null)
                Period = Session["Period"].ToString();
            else
                Period = string.Empty;

            lblHeader.Text = ReportName;
            lblPeriod.Text = Period;
            BindData();
        }
    }

    public MemoryStream GetStream(XLWorkbook excelWorkbook)
    {
        MemoryStream fs = new MemoryStream();
        excelWorkbook.SaveAs(fs);
        fs.Position = 0;
        return fs;
    }

    protected void BindData()
    {
        lblmsg.Text = string.Empty;
        try
        {
            using (DataTable dt = ((DataTable)Session["dtExport2Excel"]))
            {
                dt.TableName = "data";

                using (var wb = new XLWorkbook())
                {
                    // Add a DataTable as a worksheet
                    //if (Util.GetString(Session["ReportName"].ToString()) == "Bill Charge Report")
                    //{
                    string WorksheetName = Session["ReportName"].ToString().Length > 30 ? Session["ReportName"].ToString().Substring(0, 30) : Session["ReportName"].ToString();
                    var ws = wb.Worksheets.Add(WorksheetName);
                    ws.Cell(1, 4).Style.Font.Bold = true;
                    ws.Cell(1, 4).InsertData(new System.Collections.Generic.List<string[]> { new string[] { Session["ReportName"].ToString() } });
                    if (Session["Period"] != null)
                    {
                        ws.Cell(2, 4).Style.Font.Bold = true;
                        ws.Cell(2, 4).InsertData(new System.Collections.Generic.List<string[]> { new string[] { string.Concat(Session["Period"].ToString(), " (Print Date Time : ", DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), ")") } });
                        ws.Cell(3, 1).InsertTable(dt);
                    }
                    else
                    {
                        ws.Cell(3, 1).InsertTable(dt);
                    }
                    //}
                    //else
                    //{
                    //    wb.Worksheets.Add(dt);
                    //}
                    byte[] package = ((MemoryStream)GetStream(wb)).ToArray();
                    string attachment = "attachment; filename=" + Session["ReportName"].ToString() + ".xlsx";
                    Response.ClearContent();
                    Response.AddHeader("content-disposition", attachment);
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.BinaryWrite(package);
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
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblmsg.Text = ex.Message;
        }
        finally
        {
            Session["dtExport2Excel"] = string.Empty;
            Session.Remove("dtExport2Excel");

            if (Session["ReportName"] != null)
            {
                Session["ReportName"] = string.Empty;
                Session.Remove("ReportName");
            }

            if (Session["Period"] != null)
            {
                Session["Period"] = string.Empty;
                Session.Remove("Period");
            }
        }
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        btnExport.Visible = false;
        lblmsg.Visible = false;

        string ReportName = Util.GetString(Session["ReportName"].ToString());

        Response.Clear();
        //   application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
        Response.AddHeader("content-disposition", "attachment;filename=" + ReportName + ".xls");
        Response.Charset = "";
        Response.ContentType = "application/vnd.xls";

        StringWriter StringWriter = new System.IO.StringWriter();
        HtmlTextWriter HtmlTextWriter = new HtmlTextWriter(StringWriter);
        this.RenderControl(HtmlTextWriter);
        //EmployeeGrid.RenderControl(HtmlTextWriter);
        Response.Write(StringWriter.ToString());
        //Response.End();
        Response.Flush();
        Response.Clear();
        Session["dtExport2Excel"] = "";
        Session.Remove("dtExport2Excel");

        Session["ReportName"] = "";
        Session.Remove("ReportName");

        Session["Period"] = "";
        Session.Remove("Period");

        btnExport.Visible = true;
        lblmsg.Visible = true;
    }
}
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
            BindData();
            string Period = "";
            string ReportName = Session["ReportName"].ToString();

            if (Session["Period"] != null)
                Period = Session["Period"].ToString();
            else
                Period = "";

            lblHeader.Text = ReportName;
            lblPeriod.Text = Period;
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
        lblmsg.Text = "";
        try
        {
            DataTable dt = ((DataTable)Session["dtExport2Excel"]);
            dt.TableName = "data";
            using (var wb = new XLWorkbook())
            {
                var ws = wb.Worksheets.Add(dt);
                string[] ExColArr = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "AA", "AB", "AC", "AD", "AE", "AF", "AG", "AH", "AI", "AJ", "AK", "AL", "AM", "AN", "AO", "AP", "AQ", "AR", "AS", "AT", "AU", "AV", "AW", "AX", "AY", "AZ", "BA", "BB", "BC", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BK", "BL", "BM", "BN", "BO", "BP", "BQ", "BR", "BS", "BT", "BU", "BV", "BW", "BX", "BY", "BZ", "CA", "CB", "CC", "CD", "CE", "CF", "CG", "CH", "CI", "CJ", "CK", "CL", "CM", "CN", "CO", "CP", "CQ", "CR", "CS", "CT", "CU", "CV", "CW", "CX", "CY", "CZ" };

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    for (int j = 6; j < dt.Columns.Count; j++)
                    {
                        string Col = ExColArr[j] + (i + 2);

                        if (Convert.ToString(dt.Rows[i][j]).Contains("High"))
                        {
                            ws.Cell(Col).Style.Fill.SetBackgroundColor(XLColor.Pink);
                            ws.Cell(Col).Style.Font.Bold = true;
                            dt.Rows[i][j] = dt.Rows[i][j].ToString().Replace("High", "");
                            ws.Cell(Col).SetValue(dt.Rows[i][j]);
                        }
                        else if (Convert.ToString(dt.Rows[i][j]).Contains("Low"))
                        {
                            ws.Cell(Col).Style.Fill.SetBackgroundColor(XLColor.Yellow);
                            ws.Cell(Col).Style.Font.Bold = true;
                            dt.Rows[i][j] = dt.Rows[i][j].ToString().Replace("Low", "");
                            ws.Cell(Col).SetValue(dt.Rows[i][j]);
                        }
                    }
                }

                byte[] package = ((MemoryStream)GetStream(wb)).ToArray();
                string attachment = "attachment; filename=" + Session["ReportName"].ToString() + ".xlsx";
                Response.ClearContent();
                Response.AddHeader("content-disposition", attachment);
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.BinaryWrite(package);
                Response.Flush();
                Response.Close();

                HttpContext.Current.Response.SuppressContent = true;
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
        finally
        {
            Session["dtExport2Excel"] = "";
            Session.Remove("dtExport2Excel");
        }
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        btnExport.Visible = false;
        lblmsg.Visible = false;

        string ReportName = Session["ReportName"].ToString();

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
        Response.End();

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
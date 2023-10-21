using ClosedXML.Excel;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_Store_UploadExcel : System.Web.UI.Page
{
    string type = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        btnsave1.Visible = false;
         type = Request.QueryString["type"].ToString();
    }
 

    protected void btnsave_Click(object sender, EventArgs e)
    {
        btnsave1.Visible = false;
        lblMsg.Text = "";
        if (fpData.HasFile)
        {
            string FileExtension = Path.GetExtension(fpData.PostedFile.FileName);

            if (FileExtension.ToLower() != ".xlsx")
            {
                lblMsg.Text = "Only .xlsx File Allowed";
                return;
            }
        }
        else
        {
            lblMsg.Text = "Please Select File";
            return;

        }


        string FileName = "";
        string Mypath = "";

        if (!Directory.Exists(Server.MapPath("~/Design/EDP/TempFiles/")))
            Directory.CreateDirectory(Server.MapPath("~/Design/EDP/TempFiles/"));

        FileName = Path.GetFileName(fpData.FileName);
        Mypath = Server.MapPath("~/Uploads/" + FileName);

        if (File.Exists(Mypath))
            File.Delete(Mypath);

        fpData.SaveAs(Mypath);

        DataTable dt = CreateDataTableHeader(Mypath);
        DataTable  Mydt = Getdata(Mypath, dt);
        grd.DataSource = Mydt;
        grd.DataBind();
        btnsave1.Visible = true;
        if (File.Exists(Mypath))
            File.Delete(Mypath);
    }

    public DataTable Getdata(string pFilePath, DataTable dt)
    {
        try
        {
            var wb = new XLWorkbook(pFilePath);
            IXLWorksheet ws;
            ws = wb.Worksheet("data");
            StringBuilder sb = new StringBuilder();
            foreach (IXLRow r in ws.Rows())
            {
                DataRow tempRow = dt.NewRow();
                for (int i = 1; i <= dt.Columns.Count; i++)
                {
                    tempRow[i - 1] = r.Cell(i).Value.ToString();
                }
                dt.Rows.Add(tempRow);
            }
            dt.Rows.RemoveAt(0);

        }
        catch (Exception ex)
        {

        }

        ViewState["mydata"] = dt;
        return dt;
    }


    public static DataTable CreateDataTableHeader(string fileName)
    {
        DataTable dataTable = new DataTable();
        //using (SpreadsheetDocument spreadSheetDocument = SpreadsheetDocument.Open(fileName, false))
        //{
        //    WorkbookPart workbookPart = spreadSheetDocument.WorkbookPart;
        //    IEnumerable<Sheet> sheets = spreadSheetDocument.WorkbookPart.Workbook.GetFirstChild<Sheets>().Elements<Sheet>();
        //    string relationshipId = sheets.First().Id.Value;
        //    WorksheetPart worksheetPart = (WorksheetPart)spreadSheetDocument.WorkbookPart.GetPartById(relationshipId);
        //    Worksheet workSheet = worksheetPart.Worksheet;
        //    SheetData sheetData = workSheet.GetFirstChild<SheetData>();
        //    IEnumerable<Row> rows = sheetData.Descendants<Row>();
        //    try
        //    {
        //        foreach (Cell cell in rows.ElementAt(0))
        //        {
        //            dataTable.Columns.Add(GetCellValue(spreadSheetDocument, cell));
        //        }
        //    }
        //    catch
        //    {
        //    }



        //}


        return dataTable;
    }

    private static string GetCellValue(SpreadsheetDocument document, Cell cell)
    {
        SharedStringTablePart stringTablePart = document.WorkbookPart.SharedStringTablePart;
        string value = cell.CellValue.InnerXml;

        if (cell.DataType != null && cell.DataType.Value == CellValues.SharedString)
        {
            return stringTablePart.SharedStringTable.ChildElements[Int32.Parse(value)].InnerText;
        }
        else
        {
            return value;
        }
    }

    protected void btnsave1_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (grd.Rows.Count == 0)
        {
            lblMsg.Text = "Please Upload Data To Save";
            return;
        }

        if (type == "MinLevel")
        {

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                foreach (GridViewRow dr in grd.Rows)
                {

                    string str = "Update st_mappingitemmaster SET MinLevel = '" + dr.Cells[5].Text + "',RecorderLevel = '" + dr.Cells[6].Text + "' WHERE id='" + dr.Cells[1].Text + "'";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str.ToString());
                }
                Tranx.Commit();
                con.Close();
                lblMsg.Text = "Data Uploaded Sucessfully";
            }

            catch (Exception ex)
            {
                Tranx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                lblMsg.Text = ex.InnerException.Message;
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }
}
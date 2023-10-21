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
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_ImportStoreItem : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btndownloadexcel_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("   SELECT cat.CategoryTypeName,subcat.SubCategoryTypeName, ");
        sb.Append(" ''ItemGroupName ");
        sb.Append(" FROM st_itemmaster sm  ");
        sb.Append(" inner join st_itemmaster_group sg on sg.ItemIDGroup=sm.itemidgroup");
        sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID ");
        sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID ");
       
        sb.Append(" where sm.itemid<>0 ");
        sb.Append("  order by CategoryTypeName,SubCategoryTypeName limit 5");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        using (XLWorkbook wb = new XLWorkbook())
        {
            wb.Worksheets.Add(dt, "StoreItemSheet");

            Response.Clear();
            Response.Buffer = true;
            Response.Charset = "";
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;filename=StoreItemGroupSheets.xlsx");
            using (MemoryStream MyMemoryStream = new MemoryStream())
            {
                wb.SaveAs(MyMemoryStream);
                MyMemoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }

    protected void btnupload_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (file1.HasFile)
        {
            string FileExtension = Path.GetExtension(file1.PostedFile.FileName);

            if (FileExtension.ToLower() != ".xlsx")
            {
                lblMsg.Text = "Kindly Upload xlsx files...";
                return;
            }
        }
        else
        {
            lblMsg.Text = "Please Select File..!";
            return;

        }


        string FileName = "";
        string Mypath = "";




        if (!Directory.Exists(Server.MapPath("~/Design/Store/TempFiles/")))
            Directory.CreateDirectory(Server.MapPath("~/Design/Store/TempFiles/"));

        FileName = Path.GetFileName(file1.FileName);
        Mypath = Server.MapPath("~/Design/Store/TempFiles/" + FileName);

        if (File.Exists(Mypath))
            File.Delete(Mypath);

        file1.SaveAs(Mypath);



        DataTable dt = CreateDataTableHeader(Mypath);

        grd.DataSource = Getdata(Mypath, dt);
        grd.DataBind();


        if (File.Exists(Mypath))
            File.Delete(Mypath);
    }

    // Create DataTable
    public DataTable Getdata(string pFilePath, DataTable dt)
    {
        try
        {
            var wb = new XLWorkbook(pFilePath);
            IXLWorksheet ws;

            ws = wb.Worksheet(1);


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
            lblMsg.Text = ex.Message.ToString();
        }

        ViewState["mydata"] = dt;
        return dt;
    }

    // Create Header
    public static DataTable CreateDataTableHeader(string fileName)
    {
        DataTable dataTable = new DataTable();
        using (SpreadsheetDocument spreadSheetDocument = SpreadsheetDocument.Open(fileName, false))
        {
            WorkbookPart workbookPart = spreadSheetDocument.WorkbookPart;
            IEnumerable<Sheet> sheets = spreadSheetDocument.WorkbookPart.Workbook.GetFirstChild<Sheets>().Elements<Sheet>();
            string relationshipId = sheets.First().Id.Value;
            WorksheetPart worksheetPart = (WorksheetPart)spreadSheetDocument.WorkbookPart.GetPartById(relationshipId);
            Worksheet workSheet = worksheetPart.Worksheet;
            SheetData sheetData = workSheet.GetFirstChild<SheetData>();
            IEnumerable<Row> rows = sheetData.Descendants<Row>();
            try
            {
                foreach (Cell cell in rows.ElementAt(0))
                {
                    dataTable.Columns.Add(GetCellValue(spreadSheetDocument, cell));
                }
            }
            catch
            {
            }



        }


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
    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (grd.Rows.Count == 0)
        {
            lblMsg.Text = "Please Upload File..!";
            return;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int CategoryTypeID; int SubCategoryTypeID; 
            foreach (GridViewRow dw in grd.Rows)
            {

                if (dw.Cells[2].Text == "" || dw.Cells[2].Text == "&nbsp;")
                {
                    continue;
                }
                               StoreItemMaster objsm = new StoreItemMaster(tnx);
                CategoryTypeID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT categorytypeid FROM st_categorytypemaster where categorytypename='" + dw.Cells[2].Text + "'"));
                if (CategoryTypeID == 0)
                {
                    Exception ex = new Exception("Invalid Category");
                    throw (ex);
                }

                SubCategoryTypeID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT SubCategoryTypeID FROM st_subcategorytypemaster where SubCategoryTypeName='" + dw.Cells[3].Text + "' and CategoryTypeID=" + CategoryTypeID + ""));
                if (SubCategoryTypeID == 0)
                {
                    Exception ex = new Exception("Invalid SubCategory");
                    throw (ex);
                }

               
               StringBuilder sb1 = new StringBuilder();
               sb1.Append(" INSERT INTO st_subcategorymaster (`SubcategoryTypeID`,NAME,Active) ");
                sb1.Append(" VALUES (@SubcategoryTypeID,@NAME,@Active) ");


                using (MySqlCommand cmd = new MySqlCommand(sb1.ToString(), con, tnx))
                {

                    cmd.Parameters.AddWithValue("@SubcategoryTypeID", SubCategoryTypeID);
                    cmd.Parameters.AddWithValue("@NAME", dw.Cells[4].Text);
                    cmd.Parameters.AddWithValue("@Active", 1);
               
                    cmd.ExecuteNonQuery();
                }

               
               


                
               
               


            }

            tnx.Commit();
            lblMsg.Text = "All Item Created Sucessfully";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}
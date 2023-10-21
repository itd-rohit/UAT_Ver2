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

public partial class Design_Store_ImportStoreMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btndownloadexcel_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("   SELECT cat.CategoryTypeName,subcat.SubCategoryTypeName, ");
        sb.Append(" itemcat.Name itemTypeName,sg.ItemNameGroup ItemName, ");
        sb.Append(" sm.hsncode HSNCode,if(sm.IsExpirable='1','Yes','No') Expirable,sm.Expdatecutoff ExpiryDateCutoff,sm.GSTNTax, ");
        sb.Append("  ManufactureName, CatalogNo,MachineName, MajorUnitName PurchasedUnit,Converter, PackSize, MinorUnitName ConsumptionUnit ");
        sb.Append(" FROM st_itemmaster sm  ");
        sb.Append(" inner join st_itemmaster_group sg on sg.ItemIDGroup=sm.itemidgroup");
        sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID ");
        sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID ");
        sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID ");
        sb.Append(" where sm.itemid<>0 ");
        sb.Append("  order by CategoryTypeName,SubCategoryTypeName,itemTypeName,ItemName limit 5");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        using (XLWorkbook wb = new XLWorkbook())
        {
            wb.Worksheets.Add(dt, "StoreItemMaster");

            Response.Clear();
            Response.Buffer = true;
            Response.Charset = "";
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;filename=StoreItemMaster.xlsx");
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
            int CategoryTypeID; int SubCategoryTypeID; int SubCategoryID; int manufactureid; int macid; int minorunitid; int majorunitid;
            string CategoryType = ""; string SubCategoryType = ""; 
            string SubCategory = ""; string manufacture = ""; string machine = ""; 
            string minorunit = ""; string majorunit = "";
            foreach (GridViewRow dw in grd.Rows)
            {

                if (dw.Cells[2].Text == "" || dw.Cells[2].Text == "&nbsp;")
                {
                    continue;
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into st_itemmaster_group (ItemNameGroup) values(@ItemNameGroup)", new MySqlParameter("@ItemNameGroup", dw.Cells[5].Text.ToUpper()));
                int itemgorupid = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select max(ItemIDGroup) from st_itemmaster_group"));

                StoreItemMaster objsm = new StoreItemMaster(tnx);
                CategoryTypeID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT categorytypeid FROM st_categorytypemaster where categorytypename='"+dw.Cells[2].Text+"'"));
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


                SubCategoryID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT SubCategoryID FROM st_subcategorymaster where Name='" + dw.Cells[4].Text + "' and SubCategoryTypeID=" + SubCategoryTypeID + ""));
                if (SubCategoryID == 0)
                {
                    Exception ex = new Exception("Invalid Item Category");
                    throw (ex);
                }

                manufactureid = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT MAnufactureID FROM st_manufacture_master where Name='" + dw.Cells[10].Text + "'"));
                if (manufactureid == 0)
                {
                    Exception ex = new Exception("Invalid Manufacture");
                    throw (ex);
                }

                macid = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT id FROM macmaster where Name='" + dw.Cells[12].Text + "'"));
                if (macid == 0)
                {
                    Exception ex = new Exception("Invalid Machine");
                    throw (ex);
                }

                minorunitid = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT id FROM st_unit_master where unitname='" + dw.Cells[16].Text + "'"));
                if (minorunitid == 0)
                {
                    Exception ex = new Exception("Invalid Minorunit");
                    throw (ex);
                }

                majorunitid = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT id FROM st_unit_master where unitname='" + dw.Cells[13].Text + "'"));
                if (majorunitid == 0)
                {
                    Exception ex = new Exception("Invalid Majorunit");
                    throw (ex);
                }

                objsm.CategoryTypeID = CategoryTypeID;
                objsm.SubCategoryTypeID = SubCategoryTypeID;
                objsm.SubCategoryID = SubCategoryID;
                objsm.TypeName = dw.Cells[5].Text.ToUpper() + " " + dw.Cells[12].Text.ToUpper() + " " + dw.Cells[10].Text.ToUpper() + " " + dw.Cells[15].Text;
                objsm.Description = dw.Cells[5].Text;
                objsm.HsnCode = dw.Cells[6].Text;
              
                objsm.Expdatecutoff = Util.GetInt(dw.Cells[8].Text);
                objsm.GSTNTax = Util.GetInt(dw.Cells[9].Text);
               
                objsm.IsActive = 1;
                objsm.IsExpirable = dw.Cells[7].Text.ToUpper() == "YES" ? 1 : 0;
                objsm.ManufactureID = manufactureid.ToString();
                objsm.ManufactureName = dw.Cells[10].Text;
                objsm.CatalogNo = dw.Cells[11].Text;
                objsm.MachinId = macid.ToString();
                objsm.MachinName = dw.Cells[12].Text;
                objsm.MajorUnitId = majorunitid.ToString();
                objsm.MajorUnitName = dw.Cells[13].Text;
                objsm.PackSize = dw.Cells[15].Text;
                objsm.Converter = Util.GetFloat(dw.Cells[14].Text);
                objsm.MinorUnitId = minorunitid.ToString();
                objsm.MinorUnitName = dw.Cells[16].Text;
                objsm.ItemIDGroup = itemgorupid;
                objsm.IssueMultiplier = 0;
                objsm.BarcodeOption = 1;
                objsm.BarcodeGenrationOption = 2;
                objsm.IssueInFIFO = 1;
                objsm.MajorUnitInDecimal = 0;
                objsm.MinorUnitInDecimal = 0;
                string Itemid = objsm.Insert();
                if (Itemid == string.Empty)
                {
                    Exception ex = new Exception("Error Item Not Saved");
                    throw (ex);
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
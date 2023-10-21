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
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Interface_ImportExportItemInterface : System.Web.UI.Page
{
    private DataTable dtData;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCompany();
        }
    }

    private void BindCompany()
    {
        ddlCompany.DataSource = StockReports.GetDataTable("SELECT CompanyName FROM  f_interface_company_master WHERE IsActive=1 ORDER BY CompanyName");
        ddlCompany.DataTextField = "CompanyName";
        ddlCompany.DataValueField = "CompanyName";
        ddlCompany.DataBind();
        ddlCompany.Items.Insert(0, new ListItem("", "0"));
    }

    protected void btnupload_Click(object sender, EventArgs e)
    {
        string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\InterfaceItemMapping");

        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        RootDir = RootDir + @"\" + DateTime.Now.ToString("yyyyMMdd");
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        string fileExt = System.IO.Path.GetExtension(file1.FileName);
        string FileName = string.Concat(DateTime.Now.ToString("yyyyMMdd"), "##", Guid.NewGuid().ToString(), fileExt);
        file1.SaveAs(string.Concat(RootDir, @"\", FileName));
        string Mypath = string.Concat(RootDir, @"\", FileName);

        using (XLWorkbook workBook = new XLWorkbook(Mypath))
        {
            //Read the first Sheet from Excel file.
            IXLWorksheet workSheet = workBook.Worksheet(1);

            //Create a new DataTable.
            DataTable dt = new DataTable();

            //Loop through the Worksheet rows.
            bool firstRow = true;
            foreach (IXLRow row in workSheet.Rows())
            {
                //Use the first row to add columns to DataTable.
                if (firstRow)
                {
                    foreach (IXLCell cell in row.Cells())
                    {
                        dt.Columns.Add(cell.Value.ToString());
                    }
                    firstRow = false;
                }
                else
                {
                    //Add rows to DataTable.
                    dt.Rows.Add();
                    int i = 0;
                    foreach (IXLCell cell in row.Cells())
                    {
                        dt.Rows[dt.Rows.Count - 1][i] = cell.Value.ToString();
                        i++;
                    }
                }
            }
            if (dt.Rows.Count > 0)
            {
                IsValid = true;
                grd.DataSource = dt;
                grd.DataBind();
                if (IsValid)
                {
                    btnsave.Style["cursor"] = "pointer";
                    btnsave.Style["display"] = "";
                    btnsave.Enabled = true;
                    lblErr.Text = "";
                }
                else
                {
                    btnsave.Style["cursor"] = "not-allowed";
                    btnsave.Style["display"] = "none";
                    btnsave.Enabled = false;
                    lblErr.Text = "Please check imported data !";
                }
            }
            else
            {
                grd.DataSource = "";
                grd.DataBind();
                lblErr.Text = "No Record Found..!";
            }
        }

        //DataTable dt = CreateDataTableHeader(Mypath);
        //dtData = Getdata(Mypath, dt);
        //if (dtData.Rows.Count > 0)
        //{
        //    IsValid = true;
        //    grd.DataSource = dtData;
        //    grd.DataBind();

        //    if (IsValid)
        //    {
        //        btnsave.Style["cursor"] = "pointer";
        //        btnsave.Style["display"] = "";
        //        btnsave.Enabled = true;
        //        lblErr.Text = "";
        //    }
        //    else
        //    {
        //        btnsave.Style["cursor"] = "not-allowed";
        //        btnsave.Style["display"] = "none";
        //        btnsave.Enabled = false;
        //        lblErr.Text = "Please check imported data !";

        //    }

        //}
        //else
        //{
        //    grd.DataSource = "";
        //    grd.DataBind();
        //    lblErr.Text = "No Record Found..!";
        //}

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

            ws = wb.Worksheet("ItemInterfaceMaster");

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
            lblErr.Text = ex.Message.ToString();
        }
        return dt;
    }

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
        string strQuery = "";
        StringBuilder sb = new StringBuilder();

        MySqlConnection con1 = Util.GetMySqlCon();
        con1.Open();
        MySqlTransaction Tnx = con1.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            //Delete OLd Table
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "Drop Table if Exists f_itemmaster_interface_FROMFILE ");

            //Create New Table
            strQuery = "CREATE TABLE f_itemmaster_interface_FROMFILE (`ItemId` VARCHAR(50) DEFAULT NULL,`TestCode` VARCHAR(50) DEFAULT NULL,`ItemId_Interface` VARCHAR(50) DEFAULT NULL,`ItemName_Interface` VARCHAR(50) DEFAULT NULL,`Interface_CompanyName` VARCHAR(50) DEFAULT NULL)";
            StockReports.ExecuteDML(strQuery);
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "ALTER TABLE f_itemmaster_interface_FROMFILE ADD INDEX indx_ItemId_Interface(ItemId_Interface);  ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "ALTER TABLE f_itemmaster_interface_FROMFILE ADD INDEX indx_Interface_CompanyName(Interface_CompanyName);  ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "ALTER TABLE f_itemmaster_interface_FROMFILE CONVERT TO CHARACTER SET utf8; ");

            //-------------------------------------
            string StrGrd = "INSERT INTO f_itemmaster_interface_FROMFILE(ItemId,TestCode,ItemId_Interface,ItemName_Interface,Interface_CompanyName) VALUES ";
            for (int k = 0; k < grd.Rows.Count; k++)
            {
                StrGrd += " ('" + grd.Rows[k].Cells[1].Text + "','" + grd.Rows[k].Cells[2].Text + "','" + grd.Rows[k].Cells[4].Text + "','" + grd.Rows[k].Cells[5].Text + "','" + grd.Rows[k].Cells[6].Text + "'), ";
            }
            StrGrd = StrGrd.Substring(0, StrGrd.Length - 2);
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, StrGrd + ";");

            sb = new StringBuilder();
            sb.Append("DELETE IMI.* FROM f_itemmaster_interface IMI ");
            sb.Append(" INNER JOIN f_itemmaster_interface_FROMFILE FF ON IMI.ItemId_Interface = FF.ItemId_Interface AND IMI.Interface_CompanyName=FF.Interface_CompanyName ");
            // sb.Append(" SET IMI.isActive=0,IMI.UpdateDate=NOW(),IMI.UpdateId='" + UserInfo.ID + "'");

            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.Append(" INSERT INTO f_itemmaster_interface(ItemId,TestCode,ItemId_Interface,ItemName_Interface,Interface_CompanyName,isActive,dtEntry,CreatedBy)");
            sb.Append("  SELECT ItemId,TestCode,ItemId_Interface,ItemName_Interface,Interface_CompanyName,1,NOW(),'" + UserInfo.ID + "' FROM f_itemmaster_interface_FROMFILE ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

            Tnx.Commit();

            lblErr.Text = "Record Saved Successfully";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            Tnx.Rollback();

            throw (ex);
        }
        finally
        {
            Tnx.Dispose();
            con1.Close();
            con1.Dispose();
        }
    }

    public static string CreateTable(string tableName, string Path)
    {
        string CSVFilePathName = Path;
        string[] Lines = File.ReadAllLines(CSVFilePathName);
        string[] Fields;
        Fields = Lines[0].Split(new char[] { ',' });
        int Cols = Fields.GetLength(0);

        string sqlsc = "", strFieldsOnly = "";
        sqlsc = "CREATE TABLE " + tableName + "(\n";
        //sqlsc += "ID int(11) NOT NULL AUTO_INCREMENT, ";

        for (int i = 0; i < Cols; i++)
        {
            if (Fields[i].Trim().ToUpper() != "")
            {
                sqlsc += "\n" + Fields[i].Trim().ToUpper();
                sqlsc += " varchar(500) ";
                sqlsc += ",";
            }

            strFieldsOnly += Fields[i].Trim().ToUpper() + ",";
        }
        sqlsc = sqlsc.Substring(0, sqlsc.Length - 1) + ")";
        //sqlsc += "\nPRIMARY KEY (ID))";
        strFieldsOnly = strFieldsOnly.Substring(0, strFieldsOnly.Length - 1);

        return sqlsc + "#" + strFieldsOnly;
    }

    private bool IsValid = true;

    protected void grd_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string Val = e.Row.Cells[4].Text.Trim() + e.Row.Cells[6].Text.Trim();
                if (dtData.Select("[ItemID_interface]+[Interface_CompanyName] = '" + Val + "'").CopyToDataTable().Rows.Count > 1)
                {
                    e.Row.BackColor = System.Drawing.Color.Red;
                    e.Row.Focus();
                    IsValid = false;
                }
            }
        }
        catch
        {
            lblErr.Text = "Uploaded File contains invalid data, Please Upload a Valid File !";
        }
    }

    //--------------------------------------------------

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string ExportFile(string Company)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT SM.`Name` `Department`,IM.ItemId,IM.`TestCode`, IM.`TypeName` `TestName`,IMI.`ItemID_interface`,IMI.`ItemName_interface`,IMI.`Interface_CompanyName` FROM f_ItemMaster IM ");
        sb.Append(" INNER JOIN f_subcategorymaster SM ON IM.`SubCategoryID`=SM.`SubCategoryID` ");
        sb.Append(" LEFT JOIN f_itemmaster_interface IMI ON IM.`ItemID`=IMI.`ItemID`  AND IMI.IsActive=1  AND  IMI.Interface_CompanyName='" + Company + "'  ");
        sb.Append(" WHERE IM.`IsActive`=1  ORDER BY IM.`TypeName` ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["ReportName"] = "ItemInterfaceMaster";
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                return "1";
            }
            else
            {
                return "0";
            }
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string ImportData()
    {
        return "1";
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        exportExcel(ddlCompany.SelectedItem.Text);
    }

    public void exportExcel(string Company)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT SM.`Name` `Department`,IM.ItemId,IM.`TestCode`, IM.`TypeName` `TestName`,IMI.`ItemID_interface`,IMI.`ItemName_interface`,IMI.`Interface_CompanyName` FROM f_ItemMaster IM ");
        sb.Append(" INNER JOIN f_subcategorymaster SM ON IM.`SubCategoryID`=SM.`SubCategoryID` ");
        sb.Append(" LEFT JOIN f_itemmaster_interface IMI ON IM.`ItemID`=IMI.`ItemID`  AND IMI.IsActive=1  AND  IMI.Interface_CompanyName='" + Company + "'  ");
        sb.Append(" WHERE IM.`IsActive`=1  ORDER BY IM.`TypeName` ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
            {
                string excelName = "ItemInterfaceMaster";
                using (XLWorkbook wb = new XLWorkbook())
                {
                    excelName = excelName.Replace(",", "");
                    var ws = wb.Worksheets.Add(dt, excelName.Trim());
                    ws.Column(1).Style.Protection.SetLocked(true);

                    ws.Protect("shat1234");
                    ws.Column("5").Style.Protection.SetLocked(false);
                    ws.Column("6").Style.Protection.SetLocked(false);
                    ws.Column("7").Style.Protection.SetLocked(false);
                    byte[] package = ((MemoryStream)GetStream(wb)).ToArray();
                    string attachment = "attachment; filename=" + excelName + ".xlsx";
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

        //btnDownloadExcel.Enabled = false;
        //btnDownloadExcel.Text = "Download Excel";
    }

    public MemoryStream GetStream(XLWorkbook excelWorkbook)
    {
        MemoryStream fs = new MemoryStream();
        excelWorkbook.SaveAs(fs);
        fs.Position = 0;
        return fs;
    }
}
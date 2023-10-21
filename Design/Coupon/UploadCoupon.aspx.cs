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

public partial class Design_Coupon_UploadCoupon : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnupload_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (file1.HasFile)
        {
            string[] validFileTypes = { "xlsx", "xls" };
            string ext = Path.GetExtension(file1.PostedFile.FileName);
            bool isValidFile = false;
            for (int i = 0; i < validFileTypes.Length; i++)
            {
                if (ext == "." + validFileTypes[i])
                {
                    isValidFile = true;
                    break;
                }
            }
            if (!isValidFile)
            {
                lblMsg.Text = "Invalid File. Please upload a File with extension " + string.Join(",", validFileTypes);
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
        if (file1.HasFile)
        {

            StringBuilder sb = new StringBuilder();

            FileName = Path.GetFileName(file1.FileName);

            string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\CouponDocument");
            if (!Directory.Exists(RootDir))
                Directory.CreateDirectory(RootDir);
            RootDir = string.Concat(RootDir, @"\", DateTime.Now.ToString("yyyyMMdd"));

            if (!Directory.Exists(RootDir))
                Directory.CreateDirectory(RootDir);
            file1.SaveAs(string.Concat(RootDir, @"\", FileName));
            Mypath = string.Concat(RootDir, @"\", FileName);
            StockReports.ExecuteDML(" truncate table coupan_code_temp;");

            BinaryReader b = new BinaryReader(file1.PostedFile.InputStream);
            byte[] binData = b.ReadBytes(file1.PostedFile.ContentLength);

            using (DataTable dt = getExcelDatatable(binData))
            {
                var dublicateCoupon = dt.AsEnumerable().GroupBy(r => r.Field<string>("coupon_code")).Where(gr => gr.Count() > 1).ToList();

                if (dublicateCoupon.Count > 0)
                {
                    lblMsg.Text = string.Concat("Dublicate Coupons are :", string.Join(", ", dublicateCoupon.Select(dupl => dupl.Key)));
                    return;
                }

                MySqlConnection con1 = Util.GetMySqlCon();
                con1.Open();
                MySqlTransaction Tnx = con1.BeginTransaction(IsolationLevel.Serializable);
                try
                {
                    List<string> Rows = new List<string>();
                    StringBuilder sCommand = new StringBuilder("INSERT INTO tbl_AllCoupon (coupon_code) VALUES ");

                    foreach (DataRow dr in dt.Rows)
                    {
                        Rows.Add(string.Format("('{0}')",
                                           dr["coupon_code"].ToString()
                                           ));


                    }
                    sCommand.Append(string.Join(",", Rows));
                    sCommand.Append(";");
                    using (MySqlCommand myCmd = new MySqlCommand(sCommand.ToString(), con1, Tnx))
                    {
                        myCmd.CommandType = CommandType.Text;
                        myCmd.ExecuteNonQuery();
                    }
                    sb.Clear();

                    if (Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT COUNT(1) FROM coupan_code co INNER JOIN tbl_AllCoupon tbl ON co.CoupanCode=tbl.coupon_code")) > 0)
                    {
                        string CouponCode = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT GROUP_CONCAT(co.CoupanCode)CoupanCode FROM coupan_code co INNER JOIN tbl_AllCoupon tbl ON co.CoupanCode=tbl.coupon_code"));
                        Tnx.Rollback();
                        lblMsg.Text = string.Concat("Coupon Code Already Exits :", CouponCode);
                        return;
                    }
                    DataTable dtClientMaster = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, "Select distinct coupon_code from tbl_AllCoupon ").Tables[0];

                    if (dtClientMaster.Rows.Count > 0)
                    {
                        grd.DataSource = dtClientMaster;
                        grd.DataBind();

                        StockReports.ExecuteDML(" truncate table coupan_code_temp;");
                        sb.Clear();
                        sb.Append(" insert into coupan_code_temp (filename,coupan_code) ");
                        sb.Append(" Select distinct '" + Util.GetString(Request.QueryString["Filename"]) + "',  coupon_code from tbl_AllCoupon  ");
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
                    }
                    Tnx.Commit();
                    StockReports.ExecuteDML(" truncate table tbl_AllCoupon;");

                    lblMsg.Text = "Coupon Code Added";
                }


                catch (Exception ex)
                {
                    Tnx.Rollback();
                    lblMsg.Text = "Record Not Saved";
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }
                finally
                {
                    Tnx.Dispose();
                    con1.Close();
                    con1.Dispose();
                }
            }
        }
        else
            lblMsg.Text = "Kindly Upload File..";
    }

    protected void btnupload_Click1(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (file1.HasFile)
        {
            string FileExtension = Path.GetExtension(file1.PostedFile.FileName);

            if (FileExtension.ToLower() != ".xlsx" && FileExtension.ToLower() != ".xls")
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

        FileName = Path.GetFileName(file1.FileName);
        Mypath = Server.MapPath("~/Upload/" + FileName);

        if (File.Exists(Mypath))
            File.Delete(Mypath);

        file1.SaveAs(Mypath);

        DataTable dt = CreateDataTableHeader(Mypath);
        DataTable dtc = Getdata(Mypath, dt);
        if (dtc.Rows.Count > 0)
        {
            var distinctValues = dtc.AsEnumerable()
                        .Select(row => new
                        {
                            coupon_code = row.Field<string>("coupon_code")
                        })
                        .Distinct();

            grd.DataSource = distinctValues;
            grd.DataBind();

            StockReports.ExecuteDML(" truncate table coupan_code_temp;");

            StringBuilder sb = new StringBuilder();

            sb.Append(" insert into coupan_code_temp (filename,coupan_code) values");

            foreach (GridViewRow dw in grd.Rows)
            {
                if (dw.Cells[0].Text.Trim() != "" && dw.Cells[0].Text.Trim() != "&nbsp;")
                {
                    sb.Append("('" + Util.GetString(Request.QueryString["Filename"]) + "','" + dw.Cells[0].Text.Trim() + "'),");
                }
            }

            StockReports.ExecuteDML(sb.ToString().TrimEnd(','));

            lblMsg.Text = "Coupon Code Added";
        }
        else
        {
            lblMsg.Text = "No record found..!";
        }

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

            ws = wb.Worksheet("Sheet1");

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
    public static DataTable getExcelDatatable(byte[] b)
    {
        //Create a new DataTable.
        DataTable dt = new DataTable();
        dt.TableName = "WorkOrder";
        System.IO.Stream stream = new System.IO.MemoryStream(b);
        using (ClosedXML.Excel.XLWorkbook workBook = new ClosedXML.Excel.XLWorkbook(stream))
        {
            //Read the first Sheet from Excel file.
            ClosedXML.Excel.IXLWorksheet workSheet = workBook.Worksheet(1);



            //Loop through the Worksheet rows.
            bool firstRow = true;
            foreach (ClosedXML.Excel.IXLRow row in workSheet.Rows())
            {
                //Use the first row to add columns to DataTable.
                if (firstRow)
                {
                    foreach (ClosedXML.Excel.IXLCell cell in row.Cells())
                    {
                        dt.Columns.Add(cell.Value.ToString().Trim());
                    }
                    firstRow = false;
                }
                else
                {
                    //Add rows to DataTable.
                    DataRow dr = dt.NewRow();
                    string temp = "";
                    int i = 0;
                    for (int j = 1; j <= dt.Columns.Count; j++)
                    {
                        ClosedXML.Excel.IXLCell cell = row.Cell(j);
                        temp += "" + cell.Value.ToString();
                        temp = temp.Trim();
                        dr[i] = cell.Value.ToString().Trim();
                        i++;
                    }
                    if (temp != "")
                    {
                        dt.Rows.Add(dr);
                    }

                }


            }
        }


        return dt;
    }

}
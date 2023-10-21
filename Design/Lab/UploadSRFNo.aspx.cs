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

public partial class Design_Lab_SampleCollection : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void lnk1_Click(object sender, EventArgs e)
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT '' BarcodeNo,'' SRFNo ");

        using (XLWorkbook wb = new XLWorkbook())
        {
            wb.Worksheets.Add(dt, "SRFNoUpload");

            Response.Clear();
            Response.Buffer = true;
            Response.Charset = "";
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;fileBarcodeNo=SRFNoUpload.xlsx");
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
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            grd.DataSource = null;
            grd.DataBind();
            lblMsg.Text = "";

            if (file1.HasFile)
            {
                string FileExtension = Path.GetExtension(file1.PostedFile.FileName);

                //if (FileExtension.ToLower() != ".xlsx")
                //{
                //    lblMsg.Text = "Kindly Upload xlsx files...";
                //    return;
                //}
            }
            else
            {
                lblMsg.Text = "Please Select File..!";
                return;
            }
            string FileName = "";
            string Mypath = "";
            FileName = Path.GetFileName(file1.FileName);
            Mypath = Server.MapPath("~/UploadSRFNo/" + FileName.Replace(".xlsx", "") + "_" + Guid.NewGuid() + ".xlsx");

            if (File.Exists(Mypath))
                File.Delete(Mypath);
            file1.SaveAs(Mypath);
            DataTable dt = CreateDataTableHeader(Mypath);



            DataTable dtc = Getdata(Mypath, dt);
            if (dtc.Rows.Count > 0)
            {
                var rows = dtc.Select("BarcodeNo='' ");
                foreach (var row in rows)
                    dtc.Rows.Remove(row);


                ViewState["mydatatable"] = dtc;


                //   dtc = dtc.AsEnumerable()
                ////.GroupBy(r => new { Col1 = r["LabNo"] })
                //.Select(g => g.OrderBy(r => r["BarcodeNo"]).First())
                //.CopyToDataTable();
                var VEN = dt.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["SRFNo"].ToString())).AsDataView().Count;
                if (VEN > 0)
                {
                    lblMsg.Text = "Please Enter SRFNo in Excel ";
                    return;
                }
                var VEN1 = dt.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["BarcodeNo"].ToString())).AsDataView().Count;
                if (VEN1 > 0)
                {
                    lblMsg.Text = "Please Enter BarcodeNo in Excel  ";
                    return;
                }
                foreach (DataRow w in dtc.Rows)
                {


                    int SRFNUMberCount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select Count(1) from f_ledgertransaction where SRFNo='" + w["SRFNo"].ToString() + "' and LedgerTransactionNo_Interface<>'" + w["BarcodeNo"].ToString() + "'").ToString());

                    if (SRFNUMberCount > 0)
                    {
                        throw new Exception("SRF ID Already Assigned for Other Patient SRF ID=" + w["SRFNo"].ToString());

                    }

                    if (w["SRFNo"].ToString() != "" && (w["SRFNo"].ToString().Length > 15 || w["SRFNo"].ToString().Length < 13))
                    {
                        throw new Exception(" Invalid SRF ID of BarcodeNo ID- " + w["BarcodeNo"].ToString() + ", must be between 13 to 15 digits!! ");
                        //Exception ex = new Exception(" Invalid SRF ID of Droplet ID- " + w["DropletID"].ToString() + ", must be between 13 to 15 digits!! ");
                        //throw (ex);
                    }

                    string BarcodeNo = w["BarcodeNo"].ToString();
                    string SRFNo = w["SRFNo"].ToString();
                    DataTable dtc1 = (DataTable)ViewState["mydatatable"];

                    DataRow[] dw = dtc1.Select("BarcodeNo='" + BarcodeNo + "'");
                    // foreach (DataRow w1 in dw)
                    // {
                    // SRFNo += w1["SRFNo"] + ","; 
                    // }
                    w["BarcodeNo"] = BarcodeNo.TrimEnd(',');
                    w["SRFNo"] = SRFNo.TrimEnd(',');
                    dtc.AcceptChanges();
                }


                grd.DataSource = dtc;
                grd.DataBind();
            }
            else
            {
                grd.DataSource = "";
                grd.DataBind();
                lblMsg.Text = "No Record Found..!";
            }

        }
        catch (Exception ex)
        {

            lblMsg.Text = ex.Message.ToString();
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }

    // Create DataTable
    public DataTable Getdata(string pFilePath, DataTable dt)
    {
        try
        {
            var wb = new XLWorkbook(pFilePath);
            IXLWorksheet ws;

            ws = wb.Worksheet("SRFNoUpload");
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
    public static DataTable CreateDataTableHeader(string fileBarcodeNo)
    {
        DataTable dataTable = new DataTable();
        using (SpreadsheetDocument spreadSheetDocument = SpreadsheetDocument.Open(fileBarcodeNo, false))
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
        lblMsg.Text = "";
        if (grd.Rows.Count == 0)
        {
            lblMsg.Text = "Please Upload Data To Save..!";
            return;
        }
        StringBuilder sb = new StringBuilder();
        string BarcodeNo = "";
        string SRFNo = "";
        string _GUID = Guid.NewGuid().ToString();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            sb.Append(" insert into booking_data_SRFNo(BarcodeNo,SRFNo,dtEntry,UniqueID,UserID,UserName) Values ");
            foreach (GridViewRow dwr in grd.Rows)
            {
                CheckBox ck = (CheckBox)dwr.FindControl("chk");
                {
                    BarcodeNo = Server.HtmlDecode(Util.GetString(dwr.Cells[1].Text)).Trim();
                    SRFNo = Server.HtmlDecode(Util.GetString(dwr.Cells[2].Text)).Trim();
                    sb.Append("('" + BarcodeNo + "','" + SRFNo + "',NOW(),'" + _GUID + "','" + Session["ID"].ToString() + "','" + Session["LoginName"].ToString() + "'),");
                }
            }
            string sbUpdate = sb.ToString().TrimEnd(',');
            sbUpdate = sbUpdate + ";";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbUpdate);
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " CALL sp_booking_data_SRFNo('" + _GUID + "');");
            tnx.Commit();



            try
            {
                DataTable dt = StockReports.GetDataTable(" SELECT BarcodeNo, SRFNo SRFID, Date_Format(dtEntry,'%d-%b-%Y %r') UploadDate, UserName Uploadby, Remark, UniqueID TransactionID from booking_data_SRFNo where UniqueID='" + _GUID + "'  ");
                if (dt.Rows.Count > 0)
                {
                    string attachment = "attachment; filename=Remarks_" + _GUID + ".xls";
                    Response.ClearContent();
                    Response.AddHeader("content-disposition", attachment);
                    Response.ContentType = "application/vnd.ms-excel";
                    string tab = "";
                    foreach (DataColumn dc in dt.Columns)
                    {
                        Response.Write(tab + dc.ColumnName);
                        tab = "\t";
                    }
                    Response.Write("\n");
                    int i;
                    foreach (DataRow dr in dt.Rows)
                    {
                        tab = "";
                        for (i = 0; i < dt.Columns.Count; i++)
                        {
                            Response.Write(tab + dr[i].ToString());
                            tab = "\t";
                        }
                        Response.Write("\n");
                    }
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
            }

            lblMsg.Text = "Successfully Uploaded. " + _GUID + " Please note the transaction ID for future reference. ";
            grd.DataSource = "";
            grd.DataBind();


        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.GetBaseException().ToString();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            tnx.Rollback();
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void grd_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

        }
    }
    protected void lnk_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("Default.aspx");
    }
}
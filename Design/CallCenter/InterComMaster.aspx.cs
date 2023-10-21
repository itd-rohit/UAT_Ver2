using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Linq;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.UI;
using ClosedXML.Excel;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Collections.Generic;
using System.Web;
using System.Text.RegularExpressions;
using DocumentFormat.OpenXml.Office2010.ExcelAc;
public partial class Design_CallCenter_InterComMaster : System.Web.UI.Page
{
    public static string Columns = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        ActionDiv.Visible = false;
        if (!IsPostBack)
        {
            bindcentre();
        }

    }
    private void bindcentre()
    {
        DataTable dt = StockReports.GetDataTable("SELECT CONCAT(centreId,'@',CentreCode)centreId,centre FROM centre_master WHERE IsActive=1 ");
        if (dt.Rows.Count > 0)
        {
            ddlCenter.DataTextField = "centre";
            ddlCenter.DataValueField = "centreId";
            ddlCenter.DataSource = dt;
            ddlCenter.DataBind();
            ddlCenter.Items.Insert(0, new ListItem("Select Center", "0"));
        }
    }
    [WebMethod]
    public static string Save(object data)
    {
        List<ClsQuery> datatDetail = new System.Web.Script.Serialization.JavaScriptSerializer().ConvertToType<List<ClsQuery>>(data);
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string message = "";
        string code = "0";
        try
        {
            if (datatDetail.Count > 0)
            {
                sb = new StringBuilder();
                sb.Append("INSERT INTO `employeedetails`(`EmployeeName`,EmployeeCode,`MobileNo`,`EmailId`,`CentreCode`,ExtensionNo,Designation,EntryBy,`EntryById`,`EntryDate` )");
                sb.Append("VALUES(@EmployeeName,@EmployeeCode,@MobileNo,@EmailId,@CentreCode,@ExtensionNo,@Designation,@EntryBy,@EntryById,now()) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@EmployeeName", Util.GetString(datatDetail[0].EmployeeName)),
                      new MySqlParameter("@EmployeeCode", Util.GetString(datatDetail[0].EmployeeCode)),
                    new MySqlParameter("@MobileNo", Util.GetString(datatDetail[0].MobileNo)),
                     new MySqlParameter("@EmailId", Util.GetString(datatDetail[0].EmailID)),
                    new MySqlParameter("@CentreCode", Util.GetString(datatDetail[0].CentreCode)),
                    new MySqlParameter("@ExtensionNo", Util.GetString(datatDetail[0].ExtensionCode)),
                     new MySqlParameter("@Designation", Util.GetString(datatDetail[0].Designation)),
                    new MySqlParameter("@EntryBy", Util.GetString(UserInfo.LoginName)),
                    new MySqlParameter("@EntryById", UserInfo.ID)
                    );

                string aa = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select @@identity"));
            }
            tnx.Commit();
            message = "Employee Details Added Successfully";
            code = "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            message = "Please contact Admin Error Code Is:#ER001";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        return Util.getJson(new { Status = code, msg = message });
    }
    public class ClsQuery
    {
        public string EmployeeName { get; set; }
        public string EmployeeCode { get; set; }
        public string CentreCode { get; set; }
        public string MobileNo { get; set; }
        public string EmailID { get; set; }
        public string ExtensionCode { get; set; }
        public string Designation { get; set; }

    }
    protected void btnupload_Click(object sender, EventArgs e)
    {
        StringBuilder sbOldData = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (file1.HasFile)
            {
                string FileExtension = Path.GetExtension(file1.PostedFile.FileName);
                if (FileExtension.ToLower() != ".xlsx" && FileExtension.ToLower() != ".xls")
                {
                    Label1.Text = "Please select excel file only ";
                    return;
                }
                else
                {
                    tblData.InnerHtml = sbOldData.ToString();
                }
            }
            else
            {
                Label1.Text = "Please select excel file";
                tblData.InnerHtml = sbOldData.ToString();
                return;
            }
            string FileName = "";
            string Mypath = "";
            string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\Uploaded Document");
            if (!Directory.Exists(RootDir))
                Directory.CreateDirectory(RootDir);
            RootDir = string.Format(@"{0}\{1:yyyyMMdd}", RootDir, DateTime.Now);
            if (!Directory.Exists(RootDir))
                Directory.CreateDirectory(RootDir);
            string fileExt = System.IO.Path.GetExtension(file1.FileName);
            FileName = string.Format("{0}_{1:yyyyMMddHHmmss}{2}", file1.FileName.Replace(fileExt, "").Trim(), DateTime.Now, fileExt);
            file1.SaveAs(string.Format(@"{0}\{1}", RootDir, FileName));
            DataTable dt = CreateDataTableHeader(string.Format(@"{0}\{1}", RootDir, FileName));
            DataTable dtc = Getdata(string.Format(@"{0}\{1}", RootDir, FileName), dt);
            if (dt.Rows.Count > 0)
            {
                dtc = dtc.Rows.Cast<DataRow>().Where(row => !row.ItemArray.All(field => field is System.DBNull || string.Compare((field as string).Trim(), string.Empty) == 0)).CopyToDataTable();

                using (DataTable dtcentre = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select CentreCode from Centre_Master where CentreCode<>'' ").Tables[0])
                {
                    using (DataTable dtIncremented = new DataTable(dtc.TableName))
                    {
                        DataColumn dc = new DataColumn("ID");
                        dc.AutoIncrement = true;
                        dc.AutoIncrementSeed = 1;
                        dc.AutoIncrementStep = 1;
                        dc.DataType = System.Type.GetType("System.Int32");
                        dtIncremented.Columns.Add(dc);
                        dtIncremented.BeginLoadData();
                        DataTableReader dtReader = new DataTableReader(dtc);
                        dtIncremented.Load(dtReader);
                        dtIncremented.EndLoadData();
                        dtIncremented.AcceptChanges();
                        var VEN = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["EmployeeName"].ToString())).AsDataView().Count;
                        if (VEN > 0)
                        {
                            Label1.Text = "Please Enter EmployeeName in Excel S.No. " + dtIncremented.AsEnumerable().Where(p => p.Field<string>("EmployeeName") == string.Empty).Select(cc => cc.Field<int>("ID") + 1).First();
                            return;
                        }
                        var VEC = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["EmployeeCode"].ToString())).AsDataView().Count;
                        if (VEC > 0)
                        {
                            Label1.Text = "Please Enter EmployeeCode in Excel S.No. " + dtIncremented.AsEnumerable().Where(p => p.Field<string>("EmployeeCode") == string.Empty).Select(cc => cc.Field<int>("ID") + 1).First();
                            return;
                        }
                        var vee = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["EmailId"].ToString())).AsDataView().Count;
                        if (vee > 0)
                        {
                            Label1.Text = "Please Enter EmailId in Excel S.No. " + dtIncremented.AsEnumerable().Where(p => p.Field<string>("EmailId") == string.Empty).Select(cc => cc.Field<int>("ID") + 1).First();
                            return;
                        }
                        long num2;
                        var MobileChkInt = dtIncremented.AsEnumerable().Where(myRow => !long.TryParse(myRow.Field<String>("MobileNo"), out num2)).Count();
                        if (MobileChkInt > 0)
                        {
                            Label1.Text = "Please Enter Valid Mobile in Excel S.No. " + dtIncremented.AsEnumerable().Where(myRow => !long.TryParse(myRow.Field<String>("MobileNo"), out num2)).Select(cc => cc.Field<int>("ID") + 1).First();
                            return;
                        }
                        var veex = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["ExtensionCode"].ToString())).AsDataView().Count;
                        if (veex > 0)
                        {
                            Label1.Text = "Please Enter Extension Code in Excel S.No. " + dtIncremented.AsEnumerable().Where(p => p.Field<string>("ExtensionCode") == string.Empty).Select(cc => cc.Field<int>("ID") + 1).First();
                            return;
                        }
                        var vecc = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["CentreCode"].ToString())).AsDataView().Count;
                        if (vecc > 0)
                        {
                            Label1.Text = "Please Enter Extension CentreCode in Excel S.No. " + dtIncremented.AsEnumerable().Where(p => p.Field<string>("CentreCode") == string.Empty).Select(cc => cc.Field<int>("ID") + 1).First();
                            return;
                        }
                        StringBuilder sb = new StringBuilder();
                        sb.Append(" <table width='99%' id='tblAreaDetails'> ");
                        sb.Append(" <thead><tr> ");
                        sb.Append("<th class='GridViewHeaderStyle' style='width:20px' align='left'>Sr.No</th> ");
                        sb.Append("<th class='GridViewHeaderStyle' style='width:20px' align='left'>Employee Name</th> ");
                        sb.Append("<th class='GridViewHeaderStyle' style='width:20px' align='left'>Employee ID</th> ");
                        sb.Append("<th class='GridViewHeaderStyle' style='width:20px' align='left'>Mobile No</th> ");
                        sb.Append("<th class='GridViewHeaderStyle' style='width:20px' align='left'>Email ID</th> ");
                        sb.Append("<th class='GridViewHeaderStyle' style='width:20px' align='left'> Extension Code</th> ");
                        sb.Append("<th class='GridViewHeaderStyle' style='width:20px' align='left'> Designation</th> ");
                        sb.Append("<th class='GridViewHeaderStyle' style='width:20px' align='left'>Centre Code</th> ");
                        sb.Append("<th class='GridViewHeaderStyle' align='left' style='width:55px'>Remove</th> ");
                        sb.Append("</tr></thead><tbody> ");
                        Columns = Columns.TrimEnd('#');
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            sb.Append("<tr id='tr_dynamic' class='tr_remove'>");
                            sb.AppendFormat("<td style='width:20px!important'>{0} </td> ", (i + 1));
                            sb.AppendFormat("<td><input type='text' value={0} class='ItDoseTextinputText' style='width:99%;'> </td>", dtc.Rows[i]["EmployeeName"].ToString());
                            sb.AppendFormat("<td><input type='text' value={0} class='ItDoseTextinputText' style='width:99%;'> </td>", dtc.Rows[i]["EmployeeCode"].ToString());
                            sb.AppendFormat("<td><input  type='text' class='Mobile ItDoseTextinputText' onkeypress='return isNumberKey(event)' maxlength='10' id='MobileNo' value={0} style='width:99%;'> </td> ", dtc.Rows[i]["MobileNo"].ToString());
                            sb.AppendFormat("<td><input type='text' class='emailid' id='EmailId' value={0} class='ItDoseTextinputText' style='width:99%;'> </td>", dtc.Rows[i]["EmailID"].ToString());
                            sb.AppendFormat("<td><input type='text' value={0} class='ItDoseTextinputText' style='width:99%;'> </td> ", dtc.Rows[i]["ExtensionCode"].ToString());
                            sb.AppendFormat("<td><input type='text' value={0} class='ItDoseTextinputText' style='width:99%;'> </td> ", dtc.Rows[i]["Designation"].ToString());
                            sb.AppendFormat("<td><input type='text' value={0} class='ItDoseTextinputText' style='width:99%;'> </td>", dtc.Rows[i]["CentreCode"].ToString());
                            sb.AppendFormat("<td style='width:50px'><img src='../../App_Images/Delete.gif' alt='' style='cursor:pointer;' onclick='deleterow2(this)'></td> ");
                            sb.AppendFormat("</tr>");
                        }
                        sb.Append("</tbody></table> ");
                        tblData.InnerHtml = sb.ToString();
                        Label1.Text = "";
                    }
                }
                ActionDiv.Visible = true;
            }
            else
            {
                ActionDiv.Visible = false;
            }
            if (File.Exists(Mypath))
                File.Delete(Mypath);
        }
        catch (Exception ex)
        {
            tblData.InnerHtml = sbOldData.ToString();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Label1.Text = ex.Message.Replace("table","Excel sheet");
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
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
    // Create DataTable
    public DataTable Getdata(string pFilePath, DataTable dt)
    {
        try
        {
            var wb = new XLWorkbook(pFilePath);
            IXLWorksheet ws;
            ws = wb.Worksheet("Employeedetails");
            StringBuilder sb = new StringBuilder();
            int j = 0;
            foreach (IXLRow r in ws.Rows())
            {
                DataRow tempRow = dt.NewRow();
                for (int i = 1; i <= dt.Columns.Count; i++)
                {
                    if (j != 0)
                    {

                        tempRow[i - 1] = r.Cell(i).Value.ToString().Trim();
                    }
                }
                dt.Rows.Add(tempRow);
                j++;

            }

            StripEmptyRows(dt);
        }
        catch (Exception ex)
        {

        }
        return dt;
    }
    private DataTable StripEmptyRows(DataTable dt)
    {
        List<int> rowIndexesToBeDeleted = new List<int>();
        int indexCount = 0;
        foreach (var row in dt.Rows)
        {

            var r = (DataRow)row;
            int emptyCount = 0;
            int itemArrayCount = r.ItemArray.Length;
            foreach (var i in r.ItemArray) if (string.IsNullOrWhiteSpace(i.ToString())) emptyCount++;

            if (emptyCount == itemArrayCount) rowIndexesToBeDeleted.Add(indexCount);

            indexCount++;
        }

        int count = 0;
        foreach (var i in rowIndexesToBeDeleted)
        {
            dt.Rows.RemoveAt(i - count);
            count++;
        }
        return dt;
    }
    public class Centre_Code
    {
        public string CentreCode { get; set; }
    }
    [WebMethod(EnableSession = true)]
    public static string SaveTarget(object data)
    {
        List<ClsQuery> datatDetail = new System.Web.Script.Serialization.JavaScriptSerializer().ConvertToType<List<ClsQuery>>(data);
        if (HttpContext.Current.Session["ID"] == "")
        {
            return "2";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            var emp = datatDetail.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r.EmployeeName.ToString())).Count();
            if (emp > 0)
            {
                return "Please Enter EmployeeName";
            }
            var VEC = datatDetail.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r.EmployeeCode.ToString())).Count();
            if (VEC > 0)
            {
                return "Please Enter Employee ID ";//in Excel S.No. " + datatDetail.AsEnumerable().Where(p => p.Field<string>("EmployeeCode") == string.Empty).Select(cc => cc.Field<int>("ID")).First();

            }
            var vee = datatDetail.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r.EmailID.ToString())).Count();
            if (vee > 0)
            {
                return "Please Enter EmailId  " + datatDetail.AsEnumerable().Where(p => p.EmailID == string.Empty).Select(cc => cc.EmailID).First();

            }
            var MobileCount = datatDetail.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r.MobileNo.ToString())).Count();
            if (MobileCount > 0)
            {
                return "Please Enter Mobile No.  " + datatDetail.AsEnumerable().Where(p => p.MobileNo == string.Empty).Select(cc => cc.MobileNo).First();

            }
            var des1 = datatDetail.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r.ExtensionCode.ToString())).Count();
            if (des1 > 0)
            {
                return "Please Enter ExtensionCode " + datatDetail.AsEnumerable().Where(p => p.ExtensionCode == string.Empty).Select(cc => cc.ExtensionCode).First();

            }
            var des = datatDetail.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r.Designation.ToString())).Count();
            if (des > 0)
            {
                return "Please Enter Designation " + datatDetail.AsEnumerable().Where(p => p.Designation == string.Empty).Select(cc => cc.Designation).First();

            }
            var distinctClientCode = datatDetail.AsEnumerable().Select(row => row.CentreCode).Distinct().ToList();
            using (DataTable Center_Code = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select CentreCode from Centre_Master where CentreCode<>'' ").Tables[0])
            {
                List<Centre_Code> PC = new List<Centre_Code>();
                PC = (from DataRow row in Center_Code.Rows
                      select new Centre_Code
                      {
                          CentreCode = row["CentreCode"].ToString()
                      }).ToList();

                var notMachClientCode = distinctClientCode.Except(PC.Select(P => P.CentreCode), StringComparer.OrdinalIgnoreCase).ToList();
                if (notMachClientCode.Count > 0)
                {
                    return "Please Enter Valid Centre Code,Invali CentreCodes are " + string.Join(",", notMachClientCode.ToArray());

                }
                PC.Clear();
            }
            if (datatDetail.Count > 0)
            {
                for (int i = 0; i < datatDetail.Count; i++)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("INSERT INTO `employeedetails`(`EmployeeName`,EmployeeCode,`MobileNo`,`EmailId`,`CentreCode`,ExtensionNo,Designation,`EntryBy`,EntryById,`EntryDate`)");
                    sb.Append("VALUES(@EmployeeName,@EmployeeCode,@MobileNo,@EmailId,@CentreCode,@ExtensionNo,@Designation,@EntryBy,@EntryById,now()) ;");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                      new MySqlParameter("@EmployeeName", Util.GetString(datatDetail[i].EmployeeName)),
                      new MySqlParameter("@EmployeeCode", Util.GetString(datatDetail[i].EmployeeCode)),
                    new MySqlParameter("@MobileNo", Util.GetString(datatDetail[i].MobileNo)),
                     new MySqlParameter("@EmailId", Util.GetString(datatDetail[i].EmailID)),
                    new MySqlParameter("@CentreCode", Util.GetString(datatDetail[i].CentreCode)),
                            new MySqlParameter("@ExtensionNo", Util.GetString(datatDetail[i].ExtensionCode)),
                             new MySqlParameter("@Designation", Util.GetString(datatDetail[i].Designation)),
                            new MySqlParameter("@EntryBy", Util.GetString(UserInfo.LoginName)),
                            new MySqlParameter("@EntryById", UserInfo.ID)
                            );
                }

            }
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
            return "Error Occured";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
      [WebMethod(EnableSession = true)]
    public static string Update(object data, string ID)
    {
        List<ClsQuery> datatDetail = new System.Web.Script.Serialization.JavaScriptSerializer().ConvertToType<List<ClsQuery>>(data);
        if (HttpContext.Current.Session["ID"] == "")
        {
            return "2";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            var emp = datatDetail.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r.EmployeeName.ToString())).Count();
            if (emp > 0)
            {
                return "Please Enter EmployeeName";
            }
            var VEC = datatDetail.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r.EmployeeCode.ToString())).Count();
            if (VEC > 0)
            {
                return "Please Enter Employee ID ";//in Excel S.No. " + datatDetail.AsEnumerable().Where(p => p.Field<string>("EmployeeCode") == string.Empty).Select(cc => cc.Field<int>("ID")).First();

            }
            var vee = datatDetail.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r.EmailID.ToString())).Count();
            if (vee > 0)
            {
                return "Please Enter EmailId  " + datatDetail.AsEnumerable().Where(p => p.EmailID == string.Empty).Select(cc => cc.EmailID).First();

            }
            var MobileCount = datatDetail.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r.MobileNo.ToString())).Count();
            if (MobileCount > 0)
            {
                return "Please Enter Mobile No.  " + datatDetail.AsEnumerable().Where(p => p.MobileNo == string.Empty).Select(cc => cc.MobileNo).First();

            }
            var des1 = datatDetail.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r.ExtensionCode.ToString())).Count();
            if (des1 > 0)
            {
                return "Please Enter ExtensionCode " + datatDetail.AsEnumerable().Where(p => p.ExtensionCode == string.Empty).Select(cc => cc.ExtensionCode).First();

            }
            var des = datatDetail.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r.Designation.ToString())).Count();
            if (des > 0)
            {
                return "Please Enter Designation " + datatDetail.AsEnumerable().Where(p => p.Designation == string.Empty).Select(cc => cc.Designation).First();

            }
            if (datatDetail.Count > 0)
            {
                for (int i = 0; i < datatDetail.Count; i++)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" UPDATE `employeedetails` SET EmployeeName=@EmployeeName,EmployeeCode=@EmployeeCode,`MobileNo`=@MobileNo,`EmailId`=@EmailId,ExtensionNo=@ExtensionNo,Designation=@Designation,`UpdateName`=@UpdateName,UpdateID=@UpdateID,`UpdateDate`=now() Where Id=@Id");
                    
                      MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                      new MySqlParameter("@EmployeeName", Util.GetString(datatDetail[i].EmployeeName)),
                      new MySqlParameter("@EmployeeCode", Util.GetString(datatDetail[i].EmployeeCode)),
                      new MySqlParameter("@MobileNo", Util.GetString(datatDetail[i].MobileNo)),
                      new MySqlParameter("@EmailId", Util.GetString(datatDetail[i].EmailID)),
                      new MySqlParameter("@ExtensionNo", Util.GetString(datatDetail[i].ExtensionCode)),
                      new MySqlParameter("@Designation", Util.GetString(datatDetail[i].Designation)),
                      new MySqlParameter("@UpdateName", Util.GetString(UserInfo.LoginName)),
                      new MySqlParameter("@UpdateID", UserInfo.ID),
                        new MySqlParameter("@Id", ID)
                            );
                }

            }
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
            return "Error Occured";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
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
    protected void lnk1_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ed.id as SNo, ed.`EmployeeName`,ed.EmployeeCode,ed.`MobileNo`,ed.Emailid,ed.`ExtensionNo` as ExtensionCode,IFNULL(ed.Designation,'')Designation,IFNULL(c.`CentreCode`,'')CentreCode FROM EmployeeDetails ed ");
        sb.Append("INNER JOIN Centre_Master c ON C.`CentreCode`=ed.`CentreCode` ");
        sb.Append("INNER JOIN employee_Master e ON e.`Employee_ID`=ed.EntryById ");
        sb.Append("where ed.IsActive=1  ORDER BY ed.employeeName ASC ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        using (XLWorkbook wb = new XLWorkbook())
        {
            wb.Worksheets.Add(dt, "Employeedetails");
            Response.Clear();
            Response.Buffer = true;
            Response.Charset = "";
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;filename=Employeedetails.xlsx");
            using (MemoryStream MyMemoryStream = new MemoryStream())
            {
                wb.SaveAs(MyMemoryStream);
                MyMemoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }
}
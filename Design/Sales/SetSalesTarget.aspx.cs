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
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_Sales_SetSalesTarget : System.Web.UI.Page
{

    public static string Columns = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            //string strInput = "00012034";
            //strInput = strInput.TrimStart('0');
            //Session["ID"] = "EMP001";
            //string sess = Util.GetString(HttpContext.Current.Session["ID"]);
            ActionDiv.Visible = false;
            DataTable dt = StockReports.GetDataTable(Util.GetSalesManagerQuery());
            if (dt.Rows.Count > 0)
            {
                ddlpro.DataSource = dt;
                ddlpro.DataTextField = "ProName";
                ddlpro.DataValueField = "ProID";
                ddlpro.DataBind();
                ddlpro.Items.Insert(0, new ListItem("-SELECT-", "0"));
            }
        }

    }

    protected void lnk1_Click(object sender, EventArgs e)
    {
        string _TeamMember = "";
        string Pro = ddlpro.SelectedValue;
        StringBuilder sb = new StringBuilder();
        if (Pro != "0")
        {
            _TeamMember = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`('" + Pro + "',@ChildNode);");
            _TeamMember = "'" + _TeamMember + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
        }
        else
        {
            lblMsg.Text = "Please Select SalesExecutive";
            lblMsg.ForeColor = System.Drawing.Color.Red;
            return;
        }



        //        DataTable dt = Util.getDT(@"SELECT '' SalesExecutiveID,'' SalesExecutive,'' Apr,'' Age_Months, '' Age_Days,'' sample_collected_date,'' sample_collected_time,
        //        '' test_code,'' `Serum[1]` ,'' `Urine[2]`,'' `Nail[3]`,'' `Plasma[4]`,'' `Sputum[5]`,'' `Whole Blood[6]`,'' `Stone[7]`,'' `Swab[8]`,'' `Tissue or Cells[9]`,'' `stool[10]`,'' `Pus[11]`,'' `WB EDTA[12]`   ");
        string _Year1 = ddlYear.SelectedItem.Value.Split('-')[0];
        string _Year2 = ddlYear.SelectedItem.Value.Split('-')[1];

        sb.AppendLine(" SELECT em.`Employee_ID` SalesExecutiveID,em.`Name` SalesExecutive, ");
        sb.AppendLine(" SUM(IF(pbt.`TargetFromDate`='" + _Year1 + "-04-01',pbt.`TargetAmount`,0)) Apr_" + _Year1 + " , ");
        sb.AppendLine(" SUM(IF(pbt.`TargetFromDate`='" + _Year1 + "-05-01',pbt.`TargetAmount`,0)) May_" + _Year1 + ", ");
        sb.AppendLine(" SUM(IF(pbt.`TargetFromDate`='" + _Year1 + "-06-01',pbt.`TargetAmount`,0)) Jun_" + _Year1 + ", ");
        sb.AppendLine(" SUM(IF(pbt.`TargetFromDate`='" + _Year1 + "-07-01',pbt.`TargetAmount`,0)) Jul_" + _Year1 + ", ");
        sb.AppendLine(" SUM(IF(pbt.`TargetFromDate`='" + _Year1 + "-08-01',pbt.`TargetAmount`,0)) Aug_" + _Year1 + ", ");
        sb.AppendLine(" SUM(IF(pbt.`TargetFromDate`='" + _Year1 + "-09-01',pbt.`TargetAmount`,0)) Sep_" + _Year1 + ", ");
        sb.AppendLine(" SUM(IF(pbt.`TargetFromDate`='" + _Year1 + "-10-01',pbt.`TargetAmount`,0)) Oct_" + _Year1 + ", ");
        sb.AppendLine(" SUM(IF(pbt.`TargetFromDate`='" + _Year1 + "-11-01',pbt.`TargetAmount`,0)) Nov_" + _Year1 + ", ");
        sb.AppendLine(" SUM(IF(pbt.`TargetFromDate`='" + _Year1 + "-12-01',pbt.`TargetAmount`,0)) Dec_" + _Year1 + ", ");
        sb.AppendLine(" SUM(IF(pbt.`TargetFromDate`='" + _Year2 + "-01-01',pbt.`TargetAmount`,0)) Jan_" + _Year2 + ", ");
        sb.AppendLine(" SUM(IF(pbt.`TargetFromDate`='" + _Year2 + "-02-01',pbt.`TargetAmount`,0)) Feb_" + _Year2 + ", ");
        sb.AppendLine(" SUM(IF(pbt.`TargetFromDate`='" + _Year2 + "-03-01',pbt.`TargetAmount`,0)) Mar_" + _Year2 + " ");
        sb.AppendLine(" FROM employee_master em ");
        sb.AppendLine(" LEFT JOIN Pro_Bussiness_Target pbt ON pbt.`PROID`=em.`Employee_ID` where em.IsActive=1 ");
        if (_TeamMember != "")
            sb.AppendLine(" AND em.`Employee_ID` in (" + _TeamMember + ") ");
        sb.AppendLine(" GROUP BY em.`Employee_ID` ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        using (XLWorkbook wb = new XLWorkbook())
        {
            wb.Worksheets.Add(dt, "SalesTarget");

            Response.Clear();
            Response.Buffer = true;
            Response.Charset = "";
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;filename=SalesTarget.xlsx");
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

        StringBuilder sbOldData = new StringBuilder();
        StringBuilder sbPanelData = new StringBuilder();
        string _Year1 = ddlYear.SelectedItem.Value.Split('-')[0];
        string _Year2 = ddlYear.SelectedItem.Value.Split('-')[1];
        try
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
                else
                {
                    tblData.InnerHtml = sbOldData.ToString();
                }
            }
            else
            {
                tblData.InnerHtml = sbOldData.ToString();
                lblMsg.Text = "Please Select File..!";
                return;

            }

            string FileName = "";
            string Mypath = "";

            FileName = Path.GetFileName(file1.FileName);
            Mypath = Server.MapPath("~/Uploads/" + FileName);

            if (File.Exists(Mypath))
                File.Delete(Mypath);

            file1.SaveAs(Mypath);



            DataTable dt = CreateDataTableHeader(Mypath);
            DataTable dtc = Getdata(Mypath, dt);
            if (dtc.Rows.Count > 0)
            {


                StringBuilder str = new StringBuilder();
                str.Append(" <table width='99%' id='tblAreaDetails'> ");

                str.Append(" <tbody><tr> ");
                //str.Append(" <th class='GridViewHeaderStyle' style='width:15px' align='left'>Add</th> ");
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    str.Append(" <th class='GridViewHeaderStyle' style='width:150px' align='left'>" + dt.Columns[i].ToString() + "</th> ");
                    if (i > 1)
                    {
                        if (Columns == "")
                            Columns += dt.Columns[i].ToString();
                        else
                            Columns += "#" + dt.Columns[i].ToString();
                    }
                }
                //str.Append(" <th class='GridViewHeaderStyle' style='width:150px' align='left'>SalesExecutiveID</th> ");
                //str.Append("  <th class='GridViewHeaderStyle' style='width:40px' align='left'>SalesExecutive</th> ");
                //str.Append(" <th class='GridViewHeaderStyle' style='width:50px' align='left'>Apr_" + _Year1 + "</th> ");
                //str.Append("    <th class='GridViewHeaderStyle' style='width:50px' align='left'>May_" + _Year1 + "</th> ");
                //str.Append(" <th class='GridViewHeaderStyle' style='width:55px' align='left'>Jun_" + _Year1 + "</th> ");
                //str.Append(" <th class='GridViewHeaderStyle' style='width:55px;' align='left'>Jul_" + _Year1 + "</th> ");
                //str.Append(" <th class='GridViewHeaderStyle' style='width:55px' align='left'>Aug_" + _Year1 + "</th> ");
                //str.Append(" <th class='GridViewHeaderStyle' align='left' style='width:90px'>Sep_" + _Year1 + "</th> ");
                //str.Append(" <th class='GridViewHeaderStyle' align='left' style='width:55px'>Oct_" + _Year1 + "</th> ");
                //str.Append(" <th class='GridViewHeaderStyle' align='left' style='width:55px'>Nov_" + _Year1 + "</th> ");
                //str.Append(" <th class='GridViewHeaderStyle' align='left' style='width:90px'>Dec_" + _Year1 + "</th> ");
                //str.Append(" <th class='GridViewHeaderStyle' align='left' style='width:55px'>Jan_" + _Year2 + "</th> ");
                //str.Append(" <th class='GridViewHeaderStyle' align='left' style='width:55px'>Feb_" + _Year2 + "</th> ");
                //str.Append(" <th class='GridViewHeaderStyle' align='left' style='width:55px'>Mar_" + _Year2 + "</th> ");
                str.Append(" <th class='GridViewHeaderStyle' align='left' style='width:55px'></th> ");
                str.Append(" </tr> ");
                Columns = Columns.TrimEnd('#');
                for (int i = 0; i < dtc.Rows.Count; i++)
                {
                    str.Append(" <tr id='tr_dynamic' class='tr_remove'> ");
                    //str.Append(" <td id='td1' style='text-align:center'><img src='imnoImage/plus.png' style='width: 15px; cursor: pointer' onclick='addfidetail();'></td> ");
                    str.Append("  <td id='td4'><span id='spnExecutiveID'>" + dt.Rows[i]["SalesExecutiveID"].ToString() + "<span>  </td> ");
                    str.Append(" <td id='td5'><span id='spnExecutive'><span> " + dt.Rows[i]["SalesExecutive"].ToString() + "  </td> ");
                    str.Append("   <td id='td6'><input name='txt_AprSales' type='text' id='txt_AprSales' value=" + dt.Rows[i][Columns.Split('#')[0]].ToString() + " class='ItDoseTextinputText' style='width:99%;'> </td> ");
                    str.Append("   <td id='td6'><input name='txt_MaySales' type='text' id='txt_MaySales' value=" + dt.Rows[i][Columns.Split('#')[1]].ToString() + " class='ItDoseTextinputText' style='width:99%;'> </td> ");
                    str.Append("   <td id='td6'><input name='txt_JunSales' type='text' id='txt_JunSales' value=" + dt.Rows[i][Columns.Split('#')[2]].ToString() + " class='ItDoseTextinputText' style='width:99%;'> </td> ");
                    str.Append("   <td id='td6'><input name='txt_JulSales' type='text' id='txt_JulSales' value=" + dt.Rows[i][Columns.Split('#')[3]].ToString() + " class='ItDoseTextinputText' style='width:99%;'> </td> ");
                    str.Append("   <td id='td6'><input name='txt_AugSales' type='text' id='txt_AugSales' value=" + dt.Rows[i][Columns.Split('#')[4]].ToString() + " class='ItDoseTextinputText' style='width:99%;'> </td> ");
                    str.Append("   <td id='td6'><input name='txt_SepSales' type='text' id='txt_SepSales' value=" + dt.Rows[i][Columns.Split('#')[5]].ToString() + " class='ItDoseTextinputText' style='width:99%;'> </td> ");
                    str.Append("   <td id='td6'><input name='txt_OctSales' type='text' id='txt_OctSales' value=" + dt.Rows[i][Columns.Split('#')[6]].ToString() + " class='ItDoseTextinputText' style='width:99%;'> </td> ");
                    str.Append("   <td id='td6'><input name='txt_NovSales' type='text' id='txt_NovSales' value=" + dt.Rows[i][Columns.Split('#')[7]].ToString() + " class='ItDoseTextinputText' style='width:99%;'> </td> ");
                    str.Append("   <td id='td6'><input name='txt_DecSales' type='text' id='txt_DecSales' value=" + dt.Rows[i][Columns.Split('#')[8]].ToString() + " class='ItDoseTextinputText' style='width:99%;'> </td> ");
                    str.Append("   <td id='td6'><input name='txt_JanSales' type='text' id='txt_JanSales' value=" + dt.Rows[i][Columns.Split('#')[9]].ToString() + " class='ItDoseTextinputText' style='width:99%;'> </td> ");
                    str.Append("   <td id='td6'><input name='txt_FebSales' type='text' id='txt_FebSales' value=" + dt.Rows[i][Columns.Split('#')[10]].ToString() + " class='ItDoseTextinputText' style='width:99%;'> </td> ");
                    str.Append("   <td id='td6'><input name='txt_MarSales' type='text' id='txt_MarSales' value=" + dt.Rows[i][Columns.Split('#')[11]].ToString() + " class='ItDoseTextinputText' style='width:99%;'> </td> ");
                    str.Append(" <td id='td11' style='width:50px'><img src='imnoImage/Delete.gif' alt='' style='cursor:pointer;' onclick='deleterow2(this)'></td> ");
                    str.Append(" </tr> ");
                }

                str.Append(" </tbody></table> ");
                tblData.InnerHtml = str.ToString();
                ActionDiv.Visible = true;
            }
            else
            {

                lblMsg.Text = "No Record Found..!";
                ActionDiv.Visible = false;
            }

            if (File.Exists(Mypath))
                File.Delete(Mypath);
        }
        catch (Exception ex)
        {
            tblData.InnerHtml = sbOldData.ToString();
            lblMsg.Text = "Please Select Valid Excel Sheet..!";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

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

            ws = wb.Worksheet("SalesTarget");


            StringBuilder sb = new StringBuilder();
            int j = 0;

            foreach (IXLRow r in ws.Rows())
            {

                DataRow tempRow = dt.NewRow();
                for (int i = 1; i <= dt.Columns.Count; i++)
                {
                    if (j != 0)
                    {


                        tempRow[i - 1] = r.Cell(i).Value.ToString();


                    }
                }
                dt.Rows.Add(tempRow);
                j++;

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


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveTarget(List<SalesTarget> SalesTarget)
    {
        if (HttpContext.Current.Session["ID"] == "")
        {
            return "2";
        }


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            string _Yr1 = Columns.Split('#')[0].Split('_')[1].ToString();
            string _Yr2 = Columns.Split('#')[10].Split('_')[1].ToString();
            string _UserID = Util.GetString(HttpContext.Current.Session["ID"]);
            for (int i = 0; i < SalesTarget.Count; i++)
            {
                string _SalesExeID = Util.GetString(SalesTarget[i].ExecutiveID.Trim());
                sb.AppendLine(" Delete from pro_bussiness_target WHERE PROID='" + _SalesExeID + "' and TargetFromDate>='" + _Yr1 + "-04-01' and TargetToDate<='" + _Yr2 + "-03-31'; ");
                // System.IO.File.WriteAllText("D:\\Livecode\\ExceUploadApp\\ErrorLog\\SetSalesTarget_11.txt", sb.ToString());
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());

                sb = new StringBuilder();
                sb.AppendLine(" INSERT INTO pro_bussiness_target(PROID,TargetFromDate,TargetToDate,TargetAmount,EntryBy,EntryDatetime) VALUES ");

                if (SalesTarget[i].April.Split('#')[0] == "April")
                {
                    sb.AppendLine(" ('" + _SalesExeID + "','" + _Yr1 + "-04-01" + "','" + _Yr1 + "-04-30" + "','" + Util.GetDouble(SalesTarget[i].April.Split('#')[1]) + "','" + _UserID + "',NOW()),");
                }
                if (SalesTarget[i].May.Split('#')[0] == "May")
                {
                    sb.AppendLine(" ('" + _SalesExeID + "','" + _Yr1 + "-05-01" + "','" + _Yr1 + "-05-31" + "','" + Util.GetDouble(SalesTarget[i].May.Split('#')[1]) + "','" + _UserID + "',NOW()),");
                }
                if (SalesTarget[i].June.Split('#')[0] == "June")
                {
                    sb.AppendLine(" ('" + _SalesExeID + "','" + _Yr1 + "-06-01" + "','" + _Yr1 + "-06-30" + "','" + Util.GetDouble(SalesTarget[i].June.Split('#')[1]) + "','" + _UserID + "',NOW()),");
                }
                if (SalesTarget[i].July.Split('#')[0] == "July")
                {
                    sb.AppendLine(" ('" + _SalesExeID + "','" + _Yr1 + "-07-01" + "','" + _Yr1 + "-07-31" + "','" + Util.GetDouble(SalesTarget[i].July.Split('#')[1]) + "','" + _UserID + "',NOW()),");
                }
                if (SalesTarget[i].August.Split('#')[0] == "August")
                {
                    sb.AppendLine(" ('" + _SalesExeID + "','" + _Yr1 + "-08-01" + "','" + _Yr1 + "-08-31" + "','" + Util.GetDouble(SalesTarget[i].August.Split('#')[1]) + "','" + _UserID + "',NOW()),");
                }
                if (SalesTarget[i].September.Split('#')[0] == "September")
                {
                    sb.AppendLine(" ('" + _SalesExeID + "','" + _Yr1 + "-09-01" + "','" + _Yr1 + "-09-30" + "','" + Util.GetDouble(SalesTarget[i].September.Split('#')[1]) + "','" + _UserID + "',NOW()), ");
                }
                if (SalesTarget[i].October.Split('#')[0] == "October")
                {
                    sb.AppendLine(" ('" + _SalesExeID + "','" + _Yr1 + "-10-01" + "','" + _Yr1 + "-10-31" + "','" + Util.GetDouble(SalesTarget[i].October.Split('#')[1]) + "','" + _UserID + "',NOW()),");
                }
                if (SalesTarget[i].November.Split('#')[0] == "November")
                {
                    sb.AppendLine(" ('" + _SalesExeID + "','" + _Yr1 + "-11-01" + "','" + _Yr1 + "-11-30" + "','" + Util.GetDouble(SalesTarget[i].November.Split('#')[1]) + "','" + _UserID + "',NOW()),");
                }
                if (SalesTarget[i].December.Split('#')[0] == "December")
                {
                    sb.AppendLine(" ('" + _SalesExeID + "','" + _Yr1 + "-12-01" + "','" + _Yr1 + "-12-31" + "','" + Util.GetDouble(SalesTarget[i].December.Split('#')[1]) + "','" + _UserID + "',NOW()),");
                }
                if (SalesTarget[i].January.Split('#')[0] == "January")
                {
                    sb.AppendLine(" ('" + _SalesExeID + "','" + _Yr2 + "-01-01" + "','" + _Yr2 + "-01-31" + "','" + Util.GetDouble(SalesTarget[i].January.Split('#')[1]) + "','" + _UserID + "',NOW()),");
                }
                if (SalesTarget[i].February.Split('#')[0] == "February")
                {
                    sb.AppendLine(" ('" + _SalesExeID + "','" + _Yr2 + "-02-01" + "','" + _Yr2 + "-02-28" + "','" + Util.GetDouble(SalesTarget[i].February.Split('#')[1]) + "','" + _UserID + "',NOW()),");
                }
                if (SalesTarget[i].March.Split('#')[0] == "March")
                {
                    sb.AppendLine(" ('" + _SalesExeID + "','" + _Yr2 + "-03-01" + "','" + _Yr2 + "-03-31" + "','" + Util.GetDouble(SalesTarget[i].March.Split('#')[1]) + "','" + _UserID + "',NOW()); ");
                }


            }
            // System.IO.File.WriteAllText("D:\\Livecode\\ExceUploadApp\\ErrorLog\\SetSalesTarget.txt", sb.ToString());
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();

            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            return "Error Occured";
        }


    }

    public class SalesTarget
    {
        public string ExecutiveID { get; set; }
        public string Executive { get; set; }
        public string January { get; set; }
        public string February { get; set; }
        public string March { get; set; }
        public string April { get; set; }
        public string May { get; set; }
        public string June { get; set; }
        public string July { get; set; }
        public string August { get; set; }
        public string September { get; set; }
        public string October { get; set; }
        public string November { get; set; }
        public string December { get; set; }
    }
}
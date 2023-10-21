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
public partial class Design_Lab_AddPanelAttachment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (!IsPostBack)
                LoadPanel();
        }
       
    }
    private void LoadPanel()
    {
        DataTable dt;
        dt = StockReports.GetDataTable("select Company_Name,Panel_ID from f_panel_master where Panel_ID = ReferenceCodeOPD ORDER BY Company_Name");
        ddlPanel.DataSource = dt;
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "Panel_ID";
        ddlPanel.DataBind();
        ddlPanel.Items.Insert(0, new ListItem("Select", "0"));
    }

    

    // Create DataTable
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
        if (ddlPanel.SelectedValue == "0")
        {
            lblMsg.Text = "Please Select Panel";
            return;
        }

        string strQuery = "";
        StringBuilder sb = new StringBuilder();
        //Converting Excel file to CSV

        //string FileName = "";
        //string Mypath = "";

        string PanelID = ddlPanel.SelectedItem.Value;
        //  string ScheduleChargeID = ddlScheduleCharges.SelectedItem.Value;

        //if (!Directory.Exists(Server.MapPath("~/TempFiles/")))
        //    Directory.CreateDirectory(Server.MapPath("~/TempFiles/"));

        //FileName = Path.GetFileName(file1.FileName);
        //Mypath = Server.MapPath("~/TempFiles/" + FileName);

        //if (File.Exists(Mypath))
        //    File.Delete(Mypath);

        //file1.SaveAs(Mypath);

        MySqlConnection con1 = Util.GetMySqlCon();
        con1.Open();
        MySqlTransaction Tnx = con1.BeginTransaction(IsolationLevel.Serializable);

        //if (rbtnType.SelectedValue == "0") // OPD
        //{
        try
        {
            //Delete OLd Table
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "Drop Table if Exists f_ratefromfile ");

            //Create New Table
            strQuery = "CREATE TABLE `f_ratefromfile` (  `ITEMID` varchar(500) DEFAULT NULL,  `TESTCODE` varchar(500) DEFAULT NULL,  `DEPARTMENT` varchar(500) DEFAULT NULL,  `ITEMNAME` varchar(500) DEFAULT NULL,  `RATE` varchar(500) DEFAULT NULL)";
            StockReports.ExecuteDML(strQuery);
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "ALTER TABLE f_ratefromfile MODIFY COLUMN ItemID VARCHAR(50); ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "ALTER TABLE f_ratefromfile MODIFY COLUMN Rate double; ");

            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "ALTER TABLE f_ratefromfile ADD INDEX indx_ItemID(ItemID);  ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "ALTER TABLE f_ratefromfile ADD INDEX indx_Rate(Rate);  ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "ALTER TABLE f_ratefromfile CONVERT TO CHARACTER SET utf8; ");

            //-------------------------------------
            string StrGrd = "INSERT INTO f_ratefromfile(ItemId,TestCode,Department,ItemName,Rate) VALUES ";
            for (int k = 0; k < grd.Rows.Count; k++)
            {
                StrGrd += " ('" + grd.Rows[k].Cells[1].Text + "','" + grd.Rows[k].Cells[2].Text + "','" + grd.Rows[k].Cells[3].Text + "','" + grd.Rows[k].Cells[4].Text + "','" + grd.Rows[k].Cells[5].Text + "'), ";
            }
            StrGrd = StrGrd.Substring(0, StrGrd.Length - 2);
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, StrGrd + ";");

            //--------------------------------------

            //    Mypath = Mypath.Replace(@"\", @"\\");
            //string ENCLOSEDBY = @"'""'";
            //string ESCAPEDBY = @"'""'";
            string GUID = Guid.NewGuid().ToString();
            //strQuery = " LOAD DATA LOCAL INFILE '" + Mypath + "' INTO TABLE f_ratefromfile FIELDS TERMINATED BY ',' ENCLOSED BY " + ENCLOSEDBY + " ESCAPED BY " + ESCAPEDBY + " LINES TERMINATED BY '\\n'  IGNORE 1 LINES "; //(" + strQuery.Split('#')[1].ToString() + ")";
            //MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strQuery);

            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "Drop Table if Exists f_ratelist_bkp ");

            sb = new StringBuilder("CREATE TABLE f_ratelist_bkp SELECT * FROM f_ratelist");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.Append(" Delete t.* from f_ratefromfile t INNER JOIN f_ratelist r ON t.ItemID = r.ItemID and r.Rate=t.Rate   ");
            sb.Append(" Where r.Panel_ID = @Panel_ID  ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Panel_ID", PanelID));

            sb = new StringBuilder();
            sb.Append(" Update f_ratelist r INNER JOIN  f_ratefromfile t ON t.ItemID = r.ItemID and r.Rate=t.Rate   ");
            sb.Append(" set StockID=@StockID");
            sb.Append(" Where r.Panel_ID = @Panel_ID  ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@StockID", UniqueID),
                new MySqlParameter("@Panel_ID", PanelID));

            sb = new StringBuilder();
            sb.Append("Delete rt.* from f_ratelist rt INNER JOIN f_ratefromfile dt ON dt.ItemID = rt.ItemID  Where  ");
            sb.Append("rt.Panel_ID = @Panel_ID  ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Panel_ID", PanelID));

            sb = new StringBuilder();
            sb.Append("Insert into f_ratelist(Rate,erate, FromDate,ToDate,IsCurrent, ItemID,Panel_ID,UpdateBy,UpdateRemarks,UpdateDate)");
            sb.Append("Select REPLACE(rl.Rate,'\r','0'),0,DATE(NOW()),DATE_ADD(DATE(NOW()), INTERVAL 1 YEAR),'1',rl.ItemID,'" + PanelID + "','','From CSV File',now() from f_ratefromfile rl");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

            //sb = new StringBuilder();
            //sb.Append("update f_ratelist set RatelistID = concat(location,hospcode,id),StockID='" + GUID + "' where RatelistID is null or RatelistID='';");
            //MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

            //------------------panel Share Work--------
            //sb = new StringBuilder();
            //sb.Append(" Delete  from f_panel_share_items WHERE Panel_Id  ='" + PanelID + "'   ");
            //MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

            //sb = new StringBuilder();
            //sb.Append("Insert into f_panel_share_items(Panel_Id,ItemId,SharePer,ShareAmt,IsActive,CreatedByID,CreatedBy,CreatedDate)");
            //sb.Append("Select '" + PanelID + "',ItemId,SharePer,ShareAmt,1,'" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',now() from f_ratefromfile ");
            //MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

            Tnx.Commit();
            Tnx.Dispose();
            con1.Close();
            con1.Dispose();

            lblMsg.Text = "Rate List Uploaded Successfully";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            Tnx.Rollback();
            Tnx.Dispose();
            con1.Close();
            con1.Dispose();
            throw (ex);
        }
        //}
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
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string Val = e.Row.Cells[5].Text;
            int i = 0;
            bool result = int.TryParse(Val, out i);
            if (!result)
            {
                double x = 0.00;
                bool result1 = double.TryParse(Val, out x);
                if (!result1)
                {
                    e.Row.BackColor = System.Drawing.Color.Red;
                    e.Row.Cells[5].BackColor = System.Drawing.Color.Yellow;
                    e.Row.Focus();
                    IsValid = false;
                }
            }

            //string ValSharePer = e.Row.Cells[6].Text;
            //int j = 0;
            //bool resultSharePer = int.TryParse(ValSharePer, out j);
            //if (!resultSharePer)
            //{
            //    double x1 = 0.00;
            //    bool resultSharePer1 = double.TryParse(ValSharePer, out x1);
            //    if (!resultSharePer1)
            //    {
            //        e.Row.BackColor = System.Drawing.Color.Red;
            //        e.Row.Cells[6].BackColor = System.Drawing.Color.Yellow;
            //        e.Row.Focus();
            //        IsValid = false;
            //    }
            //    else
            //    {
            //        if (Convert.ToSingle(ValSharePer) > 100.00)
            //        {
            //            e.Row.BackColor = System.Drawing.Color.Red;
            //            e.Row.Cells[6].BackColor = System.Drawing.Color.Yellow;
            //            e.Row.Focus();
            //            IsValid = false;
            //        }
            //    }
            //}
            //else
            //{
            //    if (Convert.ToInt32(ValSharePer) > 100)
            //    {
            //        e.Row.BackColor = System.Drawing.Color.Red;
            //        e.Row.Cells[6].BackColor = System.Drawing.Color.Yellow;
            //        e.Row.Focus();
            //        IsValid = false;
            //    }
            //}

            //string ValShareAmt = e.Row.Cells[7].Text;
            //int k = 0;
            //bool resultShareAmt = int.TryParse(ValShareAmt, out k);
            //if (!resultShareAmt)
            //{
            //    double x2 = 0.00;
            //    bool resultShareAmt1 = double.TryParse(ValShareAmt, out x2);
            //    if (!resultShareAmt1)
            //    {
            //        e.Row.BackColor = System.Drawing.Color.Red;
            //        e.Row.Cells[7].BackColor = System.Drawing.Color.Yellow;
            //        e.Row.Focus();
            //        IsValid = false;
            //    }

            //}

            for (int y = 0; y < grd.Rows.Count; y++)
            {
                if (grd.Rows[y].Cells[1].Text == e.Row.Cells[1].Text)
                {
                    e.Row.Cells[1].BackColor = System.Drawing.Color.Yellow;
                    grd.Rows[y].Cells[1].BackColor = System.Drawing.Color.Yellow;
                    IsValid = false;
                }
            }
        }
    }

    protected void lnk_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("Default.aspx");
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string DownloadRateList(string PanelId, string PanelName)
    {
        DataTable dt = StockReports.GetDataTable(@"SET @a=0; SELECT @a:=@a+1 AS serial_no,sc.name,im.ItemID,im.type_id,im.testcode,
CASE
  WHEN im.billcategoryid = 1
  THEN 'Routine'
  WHEN im.billcategoryid = 2
  THEN 'Special'
  WHEN im.billcategoryid = 3
  THEN 'OutSource'
  WHEN im.billcategoryid = 4
  THEN 'Package'
  ELSE 'Platinum' END As BillingCategory

,REPLACE(REPLACE(im.typeName,',',''),'´','')  ItemName,IFNULL(plo.Method,'')Method,IFNULL(inv.`SampleRemarks`,'')TestInformation,invs.`SampleTypeName`,inv.`SampleQty`,inv.tatintimation,inv.Sample_Name,inv.logistictemp,IFNULL(r.Rate,0)Rate
        FROM f_itemmaster im
        INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID
        INNER JOIN investigation_master inv ON inv.`TestCode`=im.`TestCode`
INNER JOIN investigations_sampletype invs ON invs.`Investigation_ID`=inv.`Investigation_Id`
INNER JOIN patient_labobservation_opd plo ON plo.Test_ID=inv.`TestCode`
        LEFT OUTER JOIN f_ratelist r ON r.itemid=im.ItemID AND r.panel_id='" + PanelId + "' WHERE im.IsActive=1  ORDER BY serial_no, sc.name,im.TypeName");

        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = PanelName;

            return "1";
        }
        else
            return "0";
    }
}
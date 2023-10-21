using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_OPD_SampleCountReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillDateTime();
            bindCenterDDL();
            bindAllMethod();
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
    }

    private void FillDateTime()
    {
        ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
    }

    private void bindAllMethod()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT SubcategoryID,NAME FROM f_subcategorymaster WHERE Active=1 ORDER BY NAME").Tables[0])
            {
                chklstDept.DataSource = dt;
                chklstDept.DataTextField = "NAME";
                chklstDept.DataValueField = "SubcategoryID";
                chklstDept.DataBind();
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CONCAT(em.`Title`,' ',em.`Name`) Employee,em.`Employee_ID` FROM employee_master em WHERE em.`IsActive`=1 ORDER BY em.`Name`").Tables[0])
            {
                chklstUser.DataSource = dt;
                chklstUser.DataTextField = "Employee";
                chklstUser.DataValueField = "Employee_ID";
                chklstUser.DataBind();
            }
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pm.panel_id,CONCAT(IFNULL(pm.panel_code,''),' ',pm.company_Name)Company_Name  ");
            sb.Append(" FROM f_panel_master pm  ");
            sb.Append(" INNER JOIN centre_Master cm ON cm.CentreId=pm.CentreId ");
            sb.Append(" WHERE pm.isactive=1  ");
            sb.Append(" AND ( pm.`TagBusinessLabID`  IN (" + UserInfo.Centre + ") OR cm.CentreId=" + UserInfo.Centre + ")   ");

            sb.Append(" ORDER BY Company_Name  ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
            {
                chklstPanel.DataSource = dt;
                chklstPanel.DataTextField = "Company_Name";
                chklstPanel.DataValueField = "panel_id";
                chklstPanel.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public void bindCenterDDL()
    {
        DataTable dt = AllLoad_Data.getCentreByTagBusinessLab();
        chklstCenter.DataSource = dt;
        chklstCenter.DataTextField = "Centre";
        chklstCenter.DataValueField = "CentreID";
        chklstCenter.DataBind();
    }

    public string getselectquery(string fromDate, string toDate)
    {
        string PanelID = AllLoad_Data.GetSelection(chklstPanel);
        string CentreID = AllLoad_Data.GetSelection(chklstCenter);
        string Dept = AllLoad_Data.GetSelection(chklstDept);
        string Userid = AllLoad_Data.GetSelection(chklstUser);
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT  scm.`Name`,fpm.`Panel_ID` as Panelid,fpm.`Company_Name`,cm.`Centre`,plo.`SampleTypeID`,'Sample_Count_Report' ReportType, ");
        sb.Append(" plo.`SampleTypeName`, CAST((COUNT(DISTINCT barcodeno)) AS DECIMAL(2)) AS SampleCount ");//COUNT(DISTINCT barcodeno)AS SampleCount
        sb.Append("  FROM `f_ledgertransaction` lt ");
        sb.Append(" INNER JOIN Patient_labinvestigation_opd plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");

        sb.Append("  AND plo.`SampleTypeID`<>0 And");
        sb.Append(" lt.Date >='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND lt.Date <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (Userid != string.Empty)
        {
            sb.Append(" AND lt.`CreatedByID` in(" + Userid + ") ");
        }
        sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=plo.`SubCategoryID` ");
        if (Dept != string.Empty)
        {
            sb.Append(" AND plo.`SubCategoryID` in(" + Dept + ") ");
        }
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID` ");
        if (PanelID != string.Empty)
        {
            sb.Append(" AND lt.`Panel_ID` in(" + PanelID + ") ");
        }
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.`CentreID` ");
        if (CentreID != string.Empty)
        {
            sb.Append(" AND lt.`CentreID` in(" + CentreID + ") ");
        }
        sb.Append(" GROUP BY lt.`Panel_ID`,plo.SampleTypeID order by fpm.`Company_Name` ");

        return sb.ToString();
    }

    protected void btnSaleReport_Click(object sender, EventArgs e)
    {
        string startDate = string.Empty, toDate = string.Empty;
        if (ucFromDate.Text != string.Empty)
            startDate = ucFromDate.Text;
        else
            startDate = DateTime.Now.ToString("yyyy-MM-dd");
        if (ucToDate.Text != string.Empty)
            toDate = ucToDate.Text;
        else
            toDate = DateTime.Now.ToString("yyyy-MM-dd");
        string query = getselectquery(startDate, toDate);

        if (query == "")
            return;

        if (rblReportFormate.SelectedItem.Value == "PDF")
        {
            using (DataTable dt = StockReports.GetDataTable(query))
            {
                if (dt.Rows.Count > 0)
                {
                    lblMsg.Text = "Total " + dt.Rows.Count + "  Record(s) Found";
                    DataColumn dc = new DataColumn("Period", Type.GetType("System.String"));
                    dc.DefaultValue = "Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
                    Session["dtExport2Excel"] = dt;
                    Session["SampleCount"] = dt;
                    dt.Columns.Add(dc);

                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    Session["ds"] = ds;

                    //  ds.WriteXmlSchema("E:/SampleTypeCount.xml");
                    Session["ReportName"] = "SampleTypeCount";

                    //if (dt.Rows.Count > 0)
                    //{
                    //    Session["dtinvCount"] = dt;
                    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('InvCountProcessingPdf.aspx');", true);
                    //}

                    if (rblReportFormate.SelectedItem.Value == "PDF")
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('SampleCountPdf.aspx');", true);
                       // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
                    }
                    //else
                    //{
                    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key2", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
                    //}
                }
                else
                {
                    lblMsg.Text = "No Record Found...";
                }
            }
        }
        else
        {
            string period = string.Concat("From : ", Util.GetDateTime(startDate).ToString("dd-MMM-yyyy"), " To : ", Util.GetDateTime(toDate).ToString("dd-MMM-yyyy"));
            AllLoad_Data.exportToExcel(query, "Sample Type Count", period, "1", this.Page);
        }
    }
}
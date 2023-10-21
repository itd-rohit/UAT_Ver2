using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_OPD_SalesReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillDateTime();
            bindCenterDDL();
            BindPanel();
            BindUser();
            BindDept();
        }
    }

    private void FillDateTime()
    {
        ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
    }

    public void BindDept()
    {
        string str = " SELECT SubcategoryID,NAME FROM f_subcategorymaster WHERE Active=1 ORDER BY NAME";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        chklstDept.DataSource = dt;
        chklstDept.DataTextField = "NAME";
        chklstDept.DataValueField = "SubcategoryID";
        chklstDept.DataBind();
    }

    public void bindCenterDDL()
    {
        string str = "select distinct cm.CentreID,cm.Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.Centre  ";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        chklstCenter.DataSource = dt;
        chklstCenter.DataTextField = "Centre";
        chklstCenter.DataValueField = "CentreID";
        chklstCenter.DataBind();
        //for (int i = 0; i < chklstCenter.Items.Count; i++)
        //{
        //    chklstCenter.Items[i].Selected = true;
        //}
    }

    public void BindPanel()
    {
        string str = " SELECT `Company_Name`,panel_id FROM f_panel_master WHERE IsActive=1 ORDER BY company_name";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        chklstPanel.DataSource = dt;
        chklstPanel.DataTextField = "Company_Name";
        chklstPanel.DataValueField = "panel_id";
        chklstPanel.DataBind();
    }

    public void BindUser()
    {
        string str = "SELECT CONCAT(em.`Title`,' ',em.`Name`) Employee,em.`Employee_ID` FROM employee_master em WHERE em.`IsActive`=1 ORDER BY em.`Name`;  ";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        chklstUser.DataSource = dt;
        chklstUser.DataTextField = "Employee";
        chklstUser.DataValueField = "Employee_ID";
        chklstUser.DataBind();
    }

    public string getselectquery(string fromDate, string toDate)
    {
        string PanelID = AllLoad_Data.GetSelection(chklstPanel);
        string CentreID = AllLoad_Data.GetSelection(chklstCenter);
        string Dept = AllLoad_Data.GetSelection(chklstDept);
        string Userid = AllLoad_Data.GetSelection(chklstUser);
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT DATE_FORMAT(lt.`Date`,'%d-%b-%Y')DATE,lt.`LedgerTransactionNo`,lt.`BillNo`,pm.`PName`, ");
        sb.Append(" scm.`Name`,plo.`ItemName`,fpm.`Company_Name`,cm.Centre,SUM(plo.Rate)Rate,plo.`Amount`, ");
        sb.Append(" plo.`DiscountAmt`,'' ReceivedAmt,'' DueAmt,'' PaymentMode,fpm.Payment_Mode as PaymentType ");
        sb.Append("  FROM `f_ledgertransaction` lt ");
        sb.Append(" INNER JOIN Patient_labinvestigation_opd plo ON plo.`LedgerTransactionNo`=lt.`LedgerTransactionNo` ");

        sb.Append(" And lt.`IsCancel`=0 AND ");
        sb.Append(" lt.Date >='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND lt.Date <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append("  AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");

        if (Userid != "")
        {
            sb.Append(" AND lt.`Creator_userID` in(" + Userid + ") ");
        }
        sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=plo.`SubCategoryID` ");
        if (Dept != "")
        {
            sb.Append(" AND plo.`SubCategoryID` in(" + Dept + ") ");
        }
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID` ");
        if (PanelID != "")
        {
            sb.Append(" AND lt.`Panel_ID` in(" + PanelID + ") ");
        }
        sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID` ");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.`CentreID` ");
        if (CentreID != "")
        {
            sb.Append(" AND lt.`CentreID` in(" + CentreID + ") ");
        }
        sb.Append(" GROUP BY lt.`LedgerTransactionNo`,plo.`ItemName` ORDER BY lt.`Date`,lt.`LedgerTransactionNo` ");
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

        DataTable dt = StockReports.GetDataTable(query);
        if (dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + "  Record(s) Found";
            DataColumn dc = new DataColumn("Period", Type.GetType("System.String"));
            dc.DefaultValue = "Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMm-yyyy") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ds"] = ds;

            //  ds.WriteXmlSchema("E:/SalesReport.xml");
            Session["ReportName"] = "SalesReport";

            if (rblReportFormate.SelectedItem.Value == "PDF")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key2", "window.open('../../Design/Common/CommonCrystalReportViewer.aspx');", true);
            }
        }
        else
        {
            lblMsg.Text = "No Record Found...";
        }
    }
}
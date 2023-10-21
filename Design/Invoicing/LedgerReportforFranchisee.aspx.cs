using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Text;

public partial class Design_Invoice_LedgerReportforFranchisee : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //BindPanel();
            lstbusinessunit.DataSource = StockReports.GetDataTable(Util.GetCentreAccessQuery());
            lstbusinessunit.DataTextField = "Centre";
            lstbusinessunit.DataValueField = "CentreID";
            lstbusinessunit.DataBind();

            BindPanelnew("All");
            BindASM();
            BindZSM();
        }
    }
    private void BindASM()
    {
        string str = "SELECT ID,ManagerName FROM `area_sales_manager_master` WHERE isactive='1' ";
        DataTable dt = StockReports.GetDataTable(str);
        chkASM.DataSource = dt;
        chkASM.DataTextField = "ManagerName";
        chkASM.DataValueField = "ID";
        chkASM.DataBind();
    }

    private void BindZSM()
    {
        string str = "SELECT ID,ZsmName FROM `zsm_master` WHERE isactive='1' ";
        DataTable dt = StockReports.GetDataTable(str);
        chkZSM.DataSource = dt;
        chkZSM.DataTextField = "ZsmName";
        chkZSM.DataValueField = "ID";
        chkZSM.DataBind();
    }


    public void BindPanel()
    {
        chklstCenter.DataSource = StockReports.GetDataTable(Util.GetInvoicePanelQuery_Credit());
        chklstCenter.DataTextField = "Company_Name";
        chklstCenter.DataValueField = "Panel_ID";
        chklstCenter.DataBind();
    }
    public void BindPanelnew(string PaymentMode)
    {
        StringBuilder sb = new StringBuilder();

        if (UserInfo.Centre==10)
        {
            sb.Append("SELECT CONCAT(pm.`Company_Name`,' [',pm.`Panel_ID`,']') Company_Name, pm.`Panel_ID` Panel_ID FROM f_panel_master pm WHERE pm.isActive = 1 ");
        }
        else
        {
            sb.Append("SELECT CONCAT(pm.`Company_Name`,' [',pm.`Panel_ID`,']') Company_Name,pm.`Panel_ID` Panel_ID FROM  f_panel_master pm INNER JOIN `centre_panel` cp ON pm.`Panel_ID` = cp.`PanelId` WHERE pm.isActive = 1 AND  pm.`Panel_ID`=pm.`InvoiceTo`  AND cp.centreid='" + UserInfo.Centre + "'");

        }
        if (Util.GetString(HttpContext.Current.Session["LoginType"]) == "PCC" || Util.GetString(HttpContext.Current.Session["LoginType"]) == "SUBPCC")
        {
            sb.Append("   AND (pm.`Panel_ID` IN (SELECT panel_id FROM f_panel_master WHERE employeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ) OR pm.`Panel_ID` IN (SELECT panel_id FROM f_panel_master WHERE invoiceto IN (SELECT panel_id FROM f_panel_master WHERE employeeID='" + HttpContext.Current.Session["ID"].ToString() + "' )))  ");
        }
        if (ddlPaymentMode.SelectedItem.Value != "All")
        {
            if (ddlPaymentMode.SelectedItem.Value == "RulingAdvance")
            {
                sb.Append("  AND pm.`Payment_Mode`='Credit' AND  pm.`RolingAdvance`=1 ");
            }
            else if (ddlPaymentMode.SelectedItem.Value == "Credit")
            {
                sb.Append(" AND pm.`Payment_Mode`='Credit' AND  pm.`RolingAdvance`=0 ");
            }
            else
            {
                sb.Append("  AND pm.`Payment_Mode`='Cash' ");
            }
        }

        sb.Append("  AND pm.`Panel_ID`=pm.`InvoiceTo` and IsInvoice=1 ORDER BY Company_Name");
        // DataTable dttable = StockReports.GetDataTable(sb.ToString());
        chklstCenter.DataSource = StockReports.GetDataTable(sb.ToString());
        chklstCenter.DataTextField = "Company_Name";
        chklstCenter.DataValueField = "Panel_ID";
        chklstCenter.DataBind();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {

        string chkCenter = StockReports.GetSelection(chklstCenter);
        if (chkCenter == "")
        {
            lblMsg.Text = "Please select the Client";
            return;
        }

        string CentreIDs = StockReports.GetListSelection(lstbusinessunit);
        if (CentreIDs == "")
        {
            lblMsg.Text = "Please select the Centre(s)";
            return;
        }
        string dateonly = "";
        string datewithtime = "";
        if (txtDate.Text == "")
        {
            dateonly = System.DateTime.Now.ToString("yyyy-MM-01");
            datewithtime = System.DateTime.Now.ToString("yyyy-MM-01 00:00:00");
        }
        else
        {
            dateonly = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-01");
            datewithtime = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-01 00:00:00");
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  if(pm.Panel_Code='',pm.InvoiceTo,pm.Panel_Code) `Panel Code`, pm.company_name PanelName, ");
        sb.Append(" round(IFNULL(t2.PreviousReceivedAmount,0)- IFNULL(t1.PreviousBooking,0) - IFNULL(t11.PreviousBookingWithoutInv,0))OpeningAmount, ");
        sb.Append(" round(IFNULL(t3.CurrentBooking,0) + IFNULL(t33.CurrentBookingWithoutInv,0))CurrentBooking, ");
        sb.Append(" round(IFNULL(t4.CurrentReceivedAmount,0))ReceivedAmount, ");
        sb.Append(" round(IFNULL(t2.PreviousReceivedAmount,0) + IFNULL(t4.CurrentReceivedAmount,0) - IFNULL(t1.PreviousBooking,0) - IFNULL(t11.PreviousBookingWithoutInv,0) - IFNULL(t3.CurrentBooking,0) - IFNULL(t33.CurrentBookingWithoutInv,0)) ClosingAmount ");

        sb.Append(" FROM  ");
        sb.Append(" f_panel_master pm  ");
        sb.Append(" LEFT JOIN     ");

        sb.Append("  ( SELECT PanelID, SUM(ShareAmt) PreviousBooking FROM invoicemaster WHERE  iscancel=0  ");
        sb.Append(" AND  `InvoiceDate`<='" + dateonly + "'    ");
        sb.Append(" AND `PanelID` IN (" + chkCenter + ")  ");
        sb.Append(" GROUP BY PanelID )t1   ");
        sb.Append(" ON t1.PanelID=pm.panel_id ");
        sb.Append(" LEFT JOIN     ");
        sb.Append(" ( SELECT pm1.InvoiceTo panel_id, IFNULL(SUM(lt.netamount),0) PreviousBookingWithoutInv    ");
        sb.Append(" FROM f_ledgertransaction lt         ");
        sb.Append(" INNER JOIN f_panel_master  pm1 ON pm1.panel_id=lt.panel_id          ");
        sb.Append(" WHERE  lt.DATE<'" + datewithtime + "'    ");
        sb.Append(" AND pm1.InvoiceTo IN (" + chkCenter + ") and ifnull(lt.InvoiceNo,'')='' ");
        sb.Append(" GROUP BY pm1.InvoiceTo ) t11 ON pm.panel_id= t11.panel_id     ");
        sb.Append(" LEFT JOIN (SELECT panel_id , IFNULL(SUM(receivedamt),0) PreviousReceivedAmount FROM invoicemaster_onaccount   ");
        sb.Append(" WHERE ReceivedDate < '" + dateonly + "'  ");
        sb.Append(" AND iscancel=0  AND TYPE='ON ACCOUNT' GROUP BY Panel_id )t2   ");
        sb.Append(" ON pm.panel_id=t2.panel_id   ");
        sb.Append(" LEFT JOIN     ");
        sb.Append("  ( SELECT PanelID, SUM(ShareAmt) CurrentBooking FROM invoicemaster WHERE  iscancel=0  ");
        sb.Append(" AND  `InvoiceDate`>'" + dateonly + "'    ");
        sb.Append(" AND `PanelID` IN (" + chkCenter + ")  ");
        sb.Append(" GROUP BY PanelID )t3   ");
        sb.Append(" ON t3.PanelID=pm.panel_id ");
        sb.Append(" LEFT JOIN     ");
        sb.Append(" ( SELECT pm1.InvoiceTo panel_id, IFNULL(SUM(lt.netamount),0) CurrentBookingWithoutInv     ");
        sb.Append(" FROM f_ledgertransaction lt         ");
        sb.Append(" INNER JOIN f_panel_master  pm1 ON pm1.panel_id=lt.panel_id          ");
        sb.Append(" WHERE lt.DATE >= '" + datewithtime + "'    ");
        sb.Append(" AND pm1.InvoiceTo IN (" + chkCenter + ") and ifnull(lt.InvoiceNo,'')=''  ");
        sb.Append(" GROUP BY pm1.InvoiceTo ) t33 ON pm.panel_id= t33.panel_id   ");

        sb.Append(" LEFT JOIN (SELECT panel_id , IFNULL(SUM(receivedamt),0) CurrentReceivedAmount FROM invoicemaster_onaccount   ");
        sb.Append(" WHERE ReceivedDate >= '" + dateonly + "'  ");
        sb.Append(" AND iscancel=0  AND TYPE='ON ACCOUNT' GROUP BY Panel_id )t4   ");
        sb.Append(" ON pm.panel_id=t4.panel_id  ");

        sb.Append(" WHERE pm.IsInvoice=1 and pm.payment_mode='Credit'   AND pm.`IsActive`='1' ");

        sb.Append(" and pm.InvoiceTo IN (" + chkCenter + ")  ");
      //  sb.AppendLine(" And pm.BusinessUnitID in (" + CentreIDs + ")  ");
        //  sb.Append(" AND round(IFNULL(t2.PreviousReceivedAmount,0) + IFNULL(t4.CurrentReceivedAmount,0) - IFNULL(t1.PreviousBooking,0)- IFNULL(t3.CurrentBooking,0)) <>0 ");
        sb.Append(" order by pm.company_name; ");
        DataTable dttable = StockReports.GetDataTable(sb.ToString());
        if (dttable != null && dttable.Rows.Count > 0)
        {
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dttable.Copy());
                Session["ReportName"] = "Ledger Statement";
                Session["Period"] = "";
                Session["dtExport2Excel"] = dttable;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
            }
        }
        else
        {
            lblMsg.Text = "No Record Found...!!!";

        }
    }
    protected void rbtReportType_SelectedIndexChanged(object sender, EventArgs e)
    {
    }
    protected void ddlPaymentype_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindPanelnew(ddlPaymentMode.SelectedItem.Value);
    }
}

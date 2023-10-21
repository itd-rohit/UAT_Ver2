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
using System.Text;

public partial class Reports_Forms_InvoiceReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            chkSampleReceive.Checked = true;
            bindPanel();
            DateTime now = DateTime.Now;
            dtFrom.Text = new DateTime(now.Year, now.Month, 1).ToString("dd-MMM-yyyy");
            dtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            if (Request.QueryString.Count > 0)
            {
                dtFrom.Text = DateTime.Now.ToString("01-MMM-yyyy");
                DataTable dtPanel = StockReports.GetDataTable("SELECT Concat(panel_Code,' ',Company_Name) Company_Name,Panel_ID FROM f_panel_master where Panel_Id='" + Util.GetString(Request.QueryString["PanelId"]) + "'");
                ddl_panel.Items.Insert(0, new ListItem(dtPanel.Rows[0][0].ToString(), dtPanel.Rows[0][1].ToString()));
                btn_Search_Click(this, null);
            }

        }

    }
    public void bindPanel()
    {
        DataTable dtPanel =StockReports.GetDataTable(Util.GetInvoicePanelQuery_Credit());
         
          //  System.IO.File.WriteAllText("F:\\ErrorLog\\GetInvoicePanelQuery_Credit.txt", Util.GetInvoicePanelQuery_Credit());
        
        if (dtPanel != null && dtPanel.Rows.Count > 0)
        {
            ddl_panel.DataSource = dtPanel;
            ddl_panel.DataTextField = "Company_Name";
            ddl_panel.DataValueField = "Panel_ID";
            ddl_panel.DataBind();
            btn_Search.Enabled = true;
            Button1.Enabled = true;
            lblMsg.Text = "";
            lblMsg.CssClass = "ItDoseLblError";
        }
        else
        {
            ddl_panel.Items.Clear();
            ddl_panel.Items.Add("-");
            btn_Search.Enabled = false;
            Button1.Enabled = false;
            lblMsg.Text = "Credit Client Not Found!";
            lblMsg.CssClass = "ItDoseLblError1";


        }
    }
    protected void Btn_Ledger_Search(object sender, EventArgs e)
    {
        gdvLedgerReport.DataSource = ReturnMainTable();
        gdvLedgerReport.DataBind();

    }


    private DataTable ReturnDataTableForLedger()
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable("LedgerSummary");

        sb.Append(" SELECT IFNULL(ifnull(t6.PreviousBal,0)-ifnull(t2.paidamt,0),0) OpenningBalance FROM  ");//-ifnull(t3.TDSamt,0)
 

        sb.Append(" (SELECT  IFNULL(SUM(IF(ivca.creditnote=2,ivca.receivedamt*-1,ivca.receivedamt)),0) paidamt FROM  invoicemaster_onaccount ivca    ");
        sb.Append(" WHERE  `ReceivedDate`<'" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + "'    ");
        sb.Append(" AND `Panel_id`='" + ddl_panel.SelectedValue.ToString() + "'  ");
        sb.Append(" AND ivca.iscancel=0 AND `Type`='ON ACCOUNT' ) t2  ,  ");

        sb.Append(" ( SELECT IFNULL(SUM(plos.PCCInvoiceAmt),0) PreviousBal    ");
        sb.Append(" FROM f_ledgertransaction lt        ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd_share plos on plos.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
        sb.Append(" inner join  f_panel_master pnl on lt.Panel_ID=pnl.Panel_ID ");
        sb.Append(" WHERE  lt.DATE<'" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00'    ");
        sb.Append(" and pnl.InvoiceTo = " + ddl_panel.SelectedValue.ToString() + "  "); 
        sb.Append(" ) t6    "); 
        string OpeningAmt = StockReports.ExecuteScalar(sb.ToString());
		//System.IO.File.WriteAllText(@"C:\OpeningAmt.txt", sb.ToString());

                
        sb = new StringBuilder();
        sb.Append(" SELECT ifnull(SUM(plos.`PCCInvoiceAmt`),0) FROM f_ledgertransaction lt   ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd_share plos on plos.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
        sb.Append(" inner join  f_panel_master pnl on lt.Panel_ID=pnl.Panel_ID ");
        sb.Append(" WHERE pnl.InvoiceTo='" + ddl_panel.SelectedValue.ToString() + "' and ifnull(plos.InvoiceNo,'')=''   "); 
        sb.Append(" AND lt.DATE>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
        string Billamount = StockReports.ExecuteScalar(sb.ToString());
		//System.IO.File.WriteAllText(@"C:\Billamount.txt", sb.ToString());

         
        sb = new StringBuilder();    
        string AmountDeposit = "0";  

        sb = new StringBuilder();
        sb.Append(" SELECT IFNULL((IFNULL(t6.PreviousBal, 0)+IFNULL(t7.ShareAmt, 0)) - IFNULL(t2.paidamt, 0),0) OpenningBalance FROM  ");

        sb.Append(" (select SUM(PaidAmt) paidamt from(SELECT  IFNULL(SUM(ivca.receivedamt),0) paidamt   ");
        sb.Append(" FROM   ");
        sb.Append(" invoicemaster_onaccount ivca    ");
        sb.Append(" WHERE  `ReceivedDate`<='" + Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd") + "'  AND creditnote!='2'  ");
        sb.Append(" AND `Panel_id`='" + ddl_panel.SelectedValue.ToString() + "'  ");
        sb.Append(" AND ivca.iscancel=0 ");  
        sb.Append(" UNION ALL SELECT  IFNULL(CONCAT('-',SUM(receivedamt*-1)),'0') paidamt   ");
        sb.Append(" FROM   ");
        sb.Append(" invoicemaster_onaccount ivca    ");
        sb.Append(" WHERE  `ReceivedDate`<='" + Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd") + "' AND creditnote ='2'    ");
        sb.Append(" AND `Panel_id`='" + ddl_panel.SelectedValue.ToString() + "'  ");
        sb.Append(" AND ivca.iscancel=0 )tn");  
        sb.Append(" ) t2  ,  ");
        sb.Append(" ( SELECT ifnull(SUM(plos.`PCCInvoiceAmt`),0) PreviousBal    ");
        sb.Append(" FROM f_ledgertransaction lt        ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd_share plos on plos.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
        sb.Append(" inner join  f_panel_master pnl on lt.Panel_ID=pnl.Panel_ID ");
        sb.Append(" WHERE lt.DATE<'" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00'    ");
        sb.Append("  and pnl.InvoiceTo = " + ddl_panel.SelectedValue.ToString() + " "); 
        sb.Append("  ) t6,   ");
        sb.Append("  (SELECT IFNULL(SUM(ShareAmt), 0) ShareAmt FROM invoicemaster WHERE iscancel = 0    ");
        sb.Append("  AND invoicedate >= '" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + "' AND invoicedate <= '" + Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd") + "'    ");
        sb.Append("  AND panelid = '" + ddl_panel.SelectedValue.ToString() + " ' )t7    ");

         // System.IO.File.WriteAllText(@"C:\ClosingAmount.txt", sb.ToString());
        string ClosingAmount = StockReports.ExecuteScalar(sb.ToString());

        DataColumn dtOpeningAmount = new DataColumn("OpeningAmount");
        dt.Columns.Add(dtOpeningAmount);

        DataColumn dtBillamount = new DataColumn("Billamount");
        dt.Columns.Add(dtBillamount);

        DataColumn dtAmountDeposit = new DataColumn("AmountDeposit");
        dt.Columns.Add(dtAmountDeposit);

        DataColumn dtClosingAmount = new DataColumn("ClosingDeposit");
        dt.Columns.Add(dtClosingAmount);



        DataRow dr = dt.NewRow();
        dr[0] = OpeningAmt;
        dr[1] = Billamount;
        dr[2] = AmountDeposit;
        dr[3] = ClosingAmount;


        dt.Rows.Add(dr);

        dt.AcceptChanges();

        // Main Content

        return dt;
    }
    float credit = 0;
    float debit = 0;
    float Openingamt = 0;
    float CreditAmt = 0;
    float DebitAmt = 0;
    private DataTable ReturnMainTable()
    {
        string PrintHeader = "0";
        if (chkprintheader.Checked)
        {
            PrintHeader = "1";
        }
        StringBuilder sb = new StringBuilder(); 
        sb.Append(" SELECT t.* FROM (  ");
        sb.Append(" SELECT cast(DATE_Format(InvoiceDate,'%d/%b/%y') as char) `BillDate`,'" + PrintHeader + "' PrintHeader,InvoiceDate EntryDate, invoiceno,panelid,(SELECT CONCAT(Panel_Code,'-',Company_Name) FROM f_panel_master WHERE Panel_ID='" + ddl_panel.SelectedValue.ToString() + "')panelname,'Credit Bill' TYPE,0 credit, `ShareAmt` debit , CONCAT(invoiceno,' : Testing Charges of Clinical Samples for the Month for ',fromdate,' to ', todate) period  ");
        sb.Append(" FROM invoicemaster WHERE iscancel=0 AND invoicedate>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + "' AND invoicedate<='" + Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd") + "' AND panelid='" + ddl_panel.SelectedValue.ToString() + "'  "); 
        sb.Append(" UNION ALL  ");
        sb.Append(" SELECT cast(DATE_Format(ivca.`ReceivedDate`,'%d/%b/%y') as char) `BillDate`,'" + PrintHeader + "' PrintHeader,ivca.`ReceivedDate` EntryDate, ivca.`receiptno` invoiceno,Panel_ID panelid,(SELECT CONCAT(Panel_Code,'-',Company_Name) FROM f_panel_master WHERE Panel_ID='" + ddl_panel.SelectedValue.ToString() + "')panelname,'' TYPE,IF(`CreditNote`<>2,ivca.receivedamt,0),  IF(`CreditNote`<>2,0,ivca.receivedamt*-1) debit, ");
        sb.Append(" ivca.Remarks as period "); 
        sb.Append(" FROM invoicemaster_onaccount ivca WHERE ivca.iscancel=0  ");
        sb.Append(" AND Panel_ID='" + ddl_panel.SelectedValue.ToString() + "' ");
        sb.Append(" AND `ReceivedDate`>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + "' AND ReceivedDate<='" + Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd") + "'  "); 
        sb.Append(" )t  order by EntryDate "); 
        DataTable dtMain = StockReports.GetDataTable(sb.ToString());
		//System.IO.File.WriteAllText(@"C:\lblnetPay.txt", sb.ToString());
        lblTotal.Text = "Total Debit = " + dtMain.Compute("sum(debit)", "") + "   Total Credit = " + dtMain.Compute("sum(credit)", "");
        if (dtMain.Rows.Count > 0)
        {
            for (int i = 0; i < dtMain.Rows.Count; i++)
            {
                lblpccName.Text = dtMain.Rows[i]["panelname"].ToString();
            }
        }

        DataSet ds = new DataSet();
        ds.Tables.Add(ReturnDataTableForLedger().Copy());

        float closingDeposit = Util.GetFloat(ds.Tables[0].Rows[0]["ClosingDeposit"]);
        float billamount = Util.GetFloat(ds.Tables[0].Rows[0]["Billamount"]);
        Openingamt = Util.GetFloat(ds.Tables[0].Rows[0]["OpeningAmount"]);
        if (Openingamt < 0)
        {
            CreditAmt = Openingamt * (-1);
            Openingamt = CreditAmt;
        }
        else
        {
            DebitAmt = Openingamt;
            Openingamt = DebitAmt * (-1);
        }
        lblClosing.Text = (closingDeposit * (-1)).ToString();
        lblsecurityAmount.Text = ds.Tables[0].Rows[0]["AmountDeposit"].ToString();
        lblTestingbill.Text = (billamount * (-1)).ToString();
        lblnetPay.Text = ((closingDeposit + billamount) * (-1)).ToString();
        lblClosingamount.Text = lblClosing.Text;
        // lblclosingTotal.Text = closingDeposit.ToString();      
        return dtMain;
    }
    float tss = 0;
    float debitssub = 0;
    float finalAmount = 0;
    float firstAmount = 0;
    protected void btn_Search_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (ddl_panel.SelectedValue != "--Select--" && ddl_panel.SelectedValue != "")
        {


            DataSet ds = new DataSet();
            ds.Tables.Add(ReturnDataTableForLedger().Copy());
            ds.Tables.Add(ReturnMainTable().Copy());

            for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
            {
                if (i == 0)
                    ds.Tables[1].Rows[i]["PanelID"] = Util.GetDouble(ds.Tables[0].Rows[0]["OpeningAmount"]) + (Util.GetDouble(ds.Tables[1].Rows[i]["debit"]) - Util.GetDouble(ds.Tables[1].Rows[i]["credit"]));
                else
                    ds.Tables[1].Rows[i]["PanelID"] = Util.GetDouble(ds.Tables[1].Rows[i]["debit"]) - Util.GetDouble(ds.Tables[1].Rows[i]["credit"]);

            } 
            ds.AcceptChanges();
            Session["LedgerTrans"] = ds;
            Session["ReportName"] = "InvoiceReport";
			ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Invoicing/LedgerInvoicepdf.aspx');", true);
            //Response.Redirect("LedgerInvoicepdf.aspx", false);
            //if (Request.QueryString.Count > 0)
            //{
            //    Response.Redirect("~/Design/Common/Commonreport.aspx");
            //}
            //else
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        
        }
        else
        {
            lblMsg.Text = "Please select Panel";
        }
    }
    protected void gdvLedgerReport_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[2].Text = "Particulars";
            e.Row.Cells[2].Text += "<br /> Opening Balance : ";
            e.Row.Cells[3].Text = "Debit Amount";
            e.Row.Cells[3].Text += "<br />" + DebitAmt.ToString();
            e.Row.Cells[4].Text = "Credit Amount";
            e.Row.Cells[4].Text += "<br />" + CreditAmt.ToString();
        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            credit += Util.GetFloat(e.Row.Cells[3].Text);
            debit += Util.GetFloat(e.Row.Cells[4].Text);
            if (e.Row.RowIndex == 0)
            {
                firstAmount = (Openingamt - Util.GetFloat(e.Row.Cells[3].Text)) + Util.GetFloat(e.Row.Cells[4].Text);
                e.Row.Cells[5].Text = (firstAmount * (-1)).ToString();

            }

            else
            {
                float finalAmt = (firstAmount - Util.GetFloat(e.Row.Cells[3].Text)) + Util.GetFloat(e.Row.Cells[4].Text);

                firstAmount = finalAmt;

                finalAmount = finalAmount * (-1);
                e.Row.Cells[5].Text = (firstAmount * (-1)).ToString();

            }


        }
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.Cells[3].Text = credit.ToString();
            e.Row.Cells[4].Text = debit.ToString();
        }
    }
}

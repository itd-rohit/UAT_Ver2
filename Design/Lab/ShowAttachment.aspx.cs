using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_ShowAttachment : System.Web.UI.Page
{
    public DataTable dt;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Util.GetString(Request.QueryString["Test_ID"]) == "")
        {

            dt = StockReports.GetDataTable(@" SELECT id, CONCAT('/',DATE_FORMAT(createddate,'%Y%m%d'),'/',filename) filename FROM document_detail WHERE labno='" + Util.GetString(Request.QueryString["labno"]) + "' "); //union SELECT id, CONCAT('/',DATE_FORMAT(dtentry,'%Y%m%d'),'/',fileurl)   filename FROM patient_labinvestigation_attachment WHERE test_id IN (SELECT test_id FROM patient_labinvestigation_opd WHERE LedgertransactionNo= '" + Util.GetString(Request.QueryString["labno"]) + "') ");
        }
        else
        {
            dt = StockReports.GetDataTable(@"  SELECT id, CONCAT('/',DATE_FORMAT(dtentry,'%Y%m%d'),'/',fileurl)   filename FROM patient_labinvestigation_attachment WHERE test_id='" + Util.GetString(Request.QueryString["Test_ID"]) + "'  ");
            if (Util.GetString(Session["RoleID"]) != "11")
            {
                if (StockReports.ExecuteScalar("SELECT AllowBalanceReport FROM employee_master  WHERE `Employee_ID` ='" + Util.GetString(Session["ID"]) + "'") != "1")
                {
                    DataTable dtIsBalanceReport = StockReports.GetDataTable("SELECT lt.`LedgerTransactionNo` IsBalanceReport FROM f_ledgertransaction lt INNER JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionNo`=plo.`LedgerTransactionNo` INNER JOIN f_panel_master pnl ON lt.`Panel_ID`=pnl.`Panel_ID` where plo.`Test_ID`='" + Util.GetString(Request.QueryString["Test_ID"]) + "' and lt.NetAmount>lt.Adjustment and lt.AmtCredit=0 and  pnl.`LockTestDueReport`=1  group by lt.LedgerTransactionNo ");
                    if (dtIsBalanceReport.Rows.Count > 0)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('You can not print the balance report');", true);
                        return;
                    }

                    int IsPrintLockReport = Util.GetInt(StockReports.ExecuteScalar("SELECT pnl.IsPrintingLock FROM f_ledgertransaction lt INNER JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionNo`=plo.`LedgerTransactionNo` INNER JOIN f_panel_master pnl ON lt.`Panel_ID`=pnl.`Panel_ID` where plo.`Test_ID` = '" + Util.GetString(Request.QueryString["Test_ID"]) + "' and  pnl.IsPrintingLock=1  LIMIT 1;"));
                    if (IsPrintLockReport == 1)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('Printing Locked. You can not print the report');", true);
                        return;
                    }
                    string IsLock = "0";
                    DataTable dtpanel = StockReports.GetDataTable("SELECT DISTINCT(fpm.`InvoiceTo`) Panel_ID FROM f_ledgertransaction lt INNER JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionNo`=plo.`LedgerTransactionNo` INNER JOIN f_panel_master fpm ON lt.`Panel_ID`=fpm.`Panel_ID`  where plo.`Test_ID`  = '" + Util.GetString(Request.QueryString["Test_ID"]) + "' and fpm.AutoLock='1' and fpm.Payment_Mode!='Cash' and fpm.AllowInvoice='1'  group by fpm.InvoiceTo ");
                    if (dtpanel.Rows.Count > 0)
                    {
                        for (int i = 0; i < dtpanel.Rows.Count; i++)
                        {
                            string _Message = StockReports.ExecuteScalar("SELECT ValidateOutstanding('" + dtpanel.Rows[i]["Panel_ID"].ToString() + "')");
                            if (_Message == "IsLock")
                            {
                                IsLock = "1";
                                break;
                            }
                        }
                        if (IsLock == "1")
                        {
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('Your Account locked, Kindly contact to Account department.');", true);
                            return;
                        }
                    }
                }
            }
        }
       
        foreach (DataRow dw in dt.Rows)
        {
            string s = "key" + dw["id"].ToString();

            ScriptManager.RegisterStartupScript(this, this.GetType(), s, " window.open('../../Design/Lab/ShowAttachedfile.aspx?fileurl=" + dw["filename"].ToString() + "');", true);


        }

        //  ScriptManager.RegisterStartupScript(this, this.GetType(), "close", "this.close();", true);
    }
}
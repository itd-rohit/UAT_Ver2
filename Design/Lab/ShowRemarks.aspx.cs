using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_ShowRemarks : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtremarks.Text = StockReports.ExecuteScalar("SELECT remarks FROM `f_ledgertransaction` WHERE `LedgerTransactionNo`='" + Request.QueryString["labno"].ToString() + "'");
        }
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        StockReports.ExecuteDML("update f_ledgertransaction set remarks='" + txtremarks.Text + "' WHERE `LedgerTransactionNo`='" + Request.QueryString["labno"].ToString() + "' ");
    }
}
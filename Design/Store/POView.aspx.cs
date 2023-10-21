using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_POView : System.Web.UI.Page
{
    public int canapproved = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
         
        string url = "POReport.aspx?Type=0&POID=" + Common.Encrypt(Util.GetString(Request.QueryString["POID"])) + "&ImageToPrint=" + Common.Encrypt("1");
        urIframe.Attributes.Add("src", url);
        int cana=Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(1) FROM `st_approvalright` WHERE employeeid="+UserInfo.ID+" AND typename='Approval' AND active=1 AND apprightfor='PO'"));
        int ischecked = Util.GetInt(StockReports.ExecuteScalar("SELECT count(1) FROM `st_purchaseorder` WHERE `PurchaseOrderid`=" +Util.GetString(Request.QueryString["POID"])+ " AND actiontype='Checker'"));

        if (cana > 0 && ischecked > 0)
        {
            canapproved = 1;
        }
     
    }

  
}
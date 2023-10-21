using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;

public partial class Design_Master_InvoiceReprintNew : System.Web.UI.Page
{
    private string pdffile = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["RoleID"] == null)
            {
                Response.Redirect("~/Design/Default.aspx");
            }
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");

            txtFromInvoiceDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToInvoiceDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            string InvoiceNo1 = Util.GetString(Request.QueryString["InvoiceNoID"]);
        }
        txtFromInvoiceDate.Attributes.Add("readOnly", "true");
        txtToInvoiceDate.Attributes.Add("readOnly", "true");
    }

  



    [WebMethod]
    public static string SearchStatus(string fromInvoiceDate,string toInvoiceDate, string PanelID, string InvoiceNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Panel_Code,pnl.`Company_Name` AS PanelName, ");
        sb.Append(" im.InvoiceNo , DATE_FORMAT(im.InvoiceDate,'%d-%b-%y')DATE,CASE  WHEN im.IsClose=1 THEN '#90EE90' ELSE '#F6A9D1'  END  rowColor  ,  ");
        sb.Append(" (SELECT CONCAT(title,' ',NAME) FROM `employee_master` WHERE Employee_ID=im.EntryByID)InvoiceCreatedBy, ");
        sb.Append(" pnl.Add1 Address,pnl.Mobile,IFNULL(pnl.emailid,'')PanelInvoiceEmailID , ");
        sb.Append("  im.ShareAmt,im.InvoiceType ");
        //sb.Append(" (SELECT IFNULL(SUM(ivca.receivedamt),0) paidAmt FROM `invoicemaster_onaccount` ivca WHERE ivca.`InvoiceNo` = im.InvoiceNo AND ivca.IsCancel=0)ShareAmt  ");
        sb.Append(" FROM invoiceMaster im  INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=im.`PanelID`  ");
        if (PanelID.Trim() != string.Empty)
            sb.Append(" AND pnl.`InvoiceTo` IN (" + PanelID + ")");
        if (InvoiceNo.Trim() == string.Empty)
            sb.Append("  AND im.InvoiceDate>='" + Util.GetDateTime(fromInvoiceDate).ToString("yyyy-MM-dd") + "' AND im.InvoiceDate<='" + Util.GetDateTime(toInvoiceDate).ToString("yyyy-MM-dd") + "'");
        else
            sb.Append(" AND im.InvoiceNo='" + InvoiceNo + "' ");
        sb.Append(" WHERE im.isCancel=0 ");
        sb.Append(" ORDER BY im.InvoiceNo ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }

    
}
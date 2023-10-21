using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_VendorPortal_VendorItemIssueDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            lbpono.Text = Util.GetString(Request.QueryString["PONO"]);

            lblorderqty.Text = Util.GetString(Request.QueryString["OrderQty"]);


            lblitemname.Visible = true;
            lblitemname.Text = StockReports.ExecuteScalar("select typename  from st_itemmaster where itemid=" + Util.GetString(Request.QueryString["ItemID"]) + " ");

            grd.DataSource = StockReports.GetDataTable("SELECT InvoiceNo,Courierdetail,AWBNumber,DATE_FORMAT(invoicedate,'%d-%b-%Y')invoicedate,DATE_FORMAT(Dispatchdate,'%d-%b-%Y')Dispatchdate, DATE_FORMAT(IssueDateTime,'%d-%b-%Y') IssueDate ,trimzero(Issueqty)IssueQty,Filename InvoiceNo FROM st_purchaseorder_details_vendor where Itemid='" + Util.GetString(Request.QueryString["ItemID"]) + "' and PurchaseOrderID='" + Util.GetString(Request.QueryString["POID"]) + "' order by id");
            grd.DataBind();

        }
    }
}
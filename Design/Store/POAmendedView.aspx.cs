using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_POAmendedView : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtponumber.Text = Util.GetString(Request.QueryString["PONumber"]);

            GridView1.DataSource = StockReports.GetDataTable(@"select distinctrow VendorName,StatusName, GrossTotal,DiscountOnTotal,TaxAmount,NetTotal 
from apollo_live_new_log.`st_purchaseorder_before_update` where `purchaseorderno`='" + txtponumber.Text + "'");
            GridView1.DataBind();


            grd.DataSource = StockReports.GetDataTable(@"SELECT * FROM (
SELECT 'Current' STATUS, itemid ItemID,itemname ItemName,orderedqty ReqQty,checkedqty CheckQty,approvedqty ApprovedQty,grnqty GRNQty,rejectqty RejectQty,rate Rate,taxamount TaxAmount,discountamount DiscAmount,unitprice UnitPrice,netamount NetAmount
FROM st_purchaseorder_details WHERE purchaseorderno='" + txtponumber.Text + "' AND isactive=1 UNION ALL SELECT 'OLD' STATUS, itemid ItemID,itemname ItemName,orderedqty ReqQty,checkedqty CheckQty,approvedqty ApprovedQty,grnqty GRNQty,rejectqty RejectQty,rate Rate,taxamount TaxAmount,discountamount DiscAmount,unitprice UnitPrice,netamount NetAmount FROM st_purchaseorder_details_edited WHERE purchaseorderno='" + txtponumber.Text + "' AND isactive=1) t ORDER BY itemid,STATUS");
            grd.DataBind();
        }
    }
}
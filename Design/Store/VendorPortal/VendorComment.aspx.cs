using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_VendorPortal_VendorComment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblpoid.Text = Util.GetString(Request.QueryString["POID"]);
            lbpono.Text = Util.GetString(Request.QueryString["PONO"]);
            lblitemid.Text = Util.GetString(Request.QueryString["ItemID"]);
            lblcotype.Text = Util.GetString(Request.QueryString["CType"]);

            if (lblcotype.Text == "1")
            {
                txtcomment.Text = StockReports.ExecuteScalar("select ifnull(vendorcomment,'') from st_purchaseorder where PurchaseOrderID=" + lblpoid.Text + "");
                lblitemnametitle.Visible = false;
                lblitemname.Visible = false;
            }
            else if (lblcotype.Text == "2")
            {
                txtcomment.Text = StockReports.ExecuteScalar("select ifnull(vendorcommentitem,'')  from st_purchaseorder_details where PurchaseOrderID=" + lblpoid.Text + "  and itemid=" + lblitemid.Text + "");

                lblitemnametitle.Visible = true;
                lblitemname.Visible = true;
                lblitemname.Text = StockReports.ExecuteScalar("select typename  from st_itemmaster where itemid=" + lblitemid.Text + " ");

            }

        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveComment(string POID, string PONO, string ItemID, string Type,string comment)
    {
        if (Type == "1")
        {
            StockReports.ExecuteDML("update st_purchaseorder set vendorcomment='" + comment + "' where PurchaseOrderID=" + POID + "");
        }

        else if (Type == "2")
        {
            StockReports.ExecuteDML("update st_purchaseorder_details set vendorcommentitem='" + comment + "' where PurchaseOrderID=" + POID + " and itemid=" + ItemID + "");
        }
        return "1";
    }
    
}
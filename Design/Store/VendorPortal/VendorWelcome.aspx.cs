using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_VendorPortal_VendorWelcome : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            lblName.Text = Session["SupplierName"].ToString();

            DataTable dt = StockReports.GetDataTable("select state,`PrimaryContactPerson`, date_format(st.LoginTime,'%d-%m-%Y %h:%i %p')LoginTime from st_vendormaster sv inner join st_vendorlogindetail st on sv.SupplierID=st.SupplierID  where sv.SupplierID='" + Session["SupplierID"].ToString() + "' order by st.LoginTime desc limit 2");
            if (dt.Rows.Count >0)
            {
                lblstate.Text = dt.Rows[0]["state"].ToString();
                lblcontact.Text = dt.Rows[0]["PrimaryContactPerson"].ToString();
                lblCLogin.Text = dt.Rows[0]["LoginTime"].ToString();
                if (dt.Rows.Count > 1)
                {
                    lblLastLogin.Text = dt.Rows[1]["LoginTime"].ToString();
                }
            }
        }
    }
}
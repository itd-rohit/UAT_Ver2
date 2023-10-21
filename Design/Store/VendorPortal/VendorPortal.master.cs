using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_VendorPortal_VendorPortal : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["SupplierID"] == null)
            {
                Response.Redirect("~/Design/Default.aspx", true);
                return;
            }
            lblLoginName.Text = Session["SupplierName"].ToString();

            try
            {
                XmlDataSource xsd = new XmlDataSource();
                xsd.DataFile = Server.MapPath("~/Design/MenuData/VendorPortal.xml");
                xsd.XPath = "/MenuItems/MenuItem";
                xsd.TransformFile = Server.MapPath("~/Design/MenuData/menu.xsl");
                xsd.DataBind();
                mnuHIS.DataSource = xsd;
                mnuHIS.DataBind();
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
    }
}

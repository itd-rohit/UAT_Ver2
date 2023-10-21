using System;

public partial class Design_Store_LocationLocationMappingDirectReceive : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ddllocation.DataSource = StockReports.GetDataTable("select location,locationid from st_locationmaster where locationid='" + Request.QueryString["LocID"].ToString() + "'");
        ddllocation.DataValueField = "locationid";
        ddllocation.DataTextField = "location";
        ddllocation.DataBind();
    }
}
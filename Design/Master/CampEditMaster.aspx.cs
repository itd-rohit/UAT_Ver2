using System;
using System.Web.Services;

public partial class Design_Master_CampEditMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    public static string bindCamp(string Company_Name)
    {
        return Util.getJson(StockReports.GetDataTable("SELECT Panel_ID,Company_Name FROM f_panel_master WHERE IsActive=1 AND Company_Name LIKE '" + Company_Name + "%' AND PanelType='Camp' "));
    }
}
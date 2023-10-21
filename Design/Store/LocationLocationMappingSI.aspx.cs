using System;
using System.Text;
using System.Web.Services;

public partial class Design_Store_LocationLocationMappingSI : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ddllocation.DataSource = StockReports.GetDataTable("select location,locationid from st_locationmaster where locationid='" + Request.QueryString["LocID"].ToString() + "'");
        ddllocation.DataValueField = "locationid";
        ddllocation.DataTextField = "location";
        ddllocation.DataBind();
    }

    [WebMethod(EnableSession = true)]
    public static string bindlocation(string centreid, string StateID, string TypeId, string ZoneId, string cityId,string locationid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT LocationID,Location FROM st_locationmaster lm  ");

        sb.Append(" INNER JOIN f_panel_master pm on pm.`panel_id`=lm.`panel_id`  ");
        sb.Append("  INNER JOIN centre_master cm on cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' then pm.`CentreID` else pm.tagprocessinglabid END AND pm.`PanelType` in('Centre','PUP')   and pm.IsActive=1 ");
        if (ZoneId != "")
            sb.Append(" AND cm.BusinessZoneID IN(" + ZoneId + ")");

        if (StateID != "")
            sb.Append("  AND cm.StateID IN(" + StateID + ")");

        if (cityId != "")
            sb.Append(" AND cm.cityid IN(" + cityId + ")");

        if (TypeId != "")
            sb.Append("  AND cm.Type1Id IN(" + TypeId + ")");

        if (centreid != "")
            sb.Append("  AND  pm.`panel_id` IN(" + centreid + ")");

        sb.Append(" WHERE lm.IsActive=1 and   lm.LocationID<>'" + locationid + "' ORDER BY Location");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

}
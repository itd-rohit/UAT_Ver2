using System;
using System.Text;
using System.Web.Services;

public partial class Design_Store_ItemLocationMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ddllocation.DataSource = StockReports.GetDataTable("select location,locationid from st_locationmaster where locationid='" + Request.QueryString["LocID"].ToString() + "'");
        ddllocation.DataValueField = "locationid";
        ddllocation.DataTextField = "location";
        ddllocation.DataBind();
    }


    [WebMethod(EnableSession = true)]
    public static string binditem(string CategoryTypeId, string SubCategoryTypeId, string CategoryId,string machineid)
    {
        StringBuilder sb = new StringBuilder();
        if (CategoryTypeId != "")
            sb.Append(" SELECT ItemId,typename ItemName FROM st_itemmaster WHERE CategoryTypeID IN(" + CategoryTypeId + ") ");
        if (SubCategoryTypeId != "")
            sb.Append(" AND SubCategoryTypeID IN(" + SubCategoryTypeId + ") ");
        if (CategoryId != "")
            sb.Append(" AND SubCategoryID IN(" + CategoryId + ") ");
        if (machineid != "")
            sb.Append(" and MachineID in (" + machineid + ") ");
        sb.Append("  and isactive=1 and approvalstatus=2 order by typename ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }


    [WebMethod(EnableSession = true)]
    public static string SearchData(string Items, string location,string ItemCode)
    {


        Items = Items.Replace("\"", "").Replace("[", "").Replace("]", "");
        location = location.Replace("\"", "").Replace("[", "").Replace("]", "");

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT id mapid,IsPIItem,ifnull(PIItemType,'Both')PIItemType, ");
        sb.Append(" (SELECT centre FROM centre_master WHERE centreid=pm.centreid) Centre,");
        sb.Append(" st.LocationId LocationID,sl.`Location`,");
        sb.Append(" st.itemid,im.typename ItemName,minlevel MinLevel,st.`RecorderLevel` ReorderLevel  FROM st_mappingitemmaster st ");
        sb.Append(" INNER JOIN st_itemmaster im ON im.`ItemID`=st.`ItemId` ");
        if (Items != "")
        {
            sb.Append(" and st.itemid in (" + Items + ")");
        }
        sb.Append(" INNER JOIN st_locationmaster sl ON sl.`LocationID`=st.`LocationId` ");

        if (location != "")
        {
            sb.Append(" and sl.`LocationID` in (" + location + ")");
        }
        sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=sl.`panel_id` ");
        if (ItemCode != "")
        {
            sb.Append(" WHERE ApolloItemCode LIKE '%" + ItemCode + "%' ");
        }
        sb.Append(" ORDER BY location,itemname ");


        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }
}
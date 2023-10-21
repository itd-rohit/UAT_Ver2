using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_StockExpiryChange : System.Web.UI.Page
{


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindalldata();
        }
    }

    void bindalldata()
    {
        if (UserInfo.AccessStoreLocation != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT concat(locationid,'#',Panel_ID) locationid,location FROM st_locationmaster WHERE isactive=1   ");
            sb.Append(" AND locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


            sb.Append(" ORDER BY location ");
            ddllocation.DataSource = StockReports.GetDataTable(sb.ToString());
            ddllocation.DataTextField = "location";
            ddllocation.DataValueField = "locationid";
            ddllocation.DataBind();
            if (ddllocation.Items.Count > 1)
            {
                ddllocation.Items.Insert(0, new ListItem("Select Location", "0"));
            }
        }

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getstockdata(string locationid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  st.barcodeno,st.itemid, st.stockid,DATE_FORMAT(stockdate,'%d-%b-%Y') stockdate,st.batchnumber,IF(expirydate='0001-01-01','', DATE_FORMAT(expirydate,'%d-%b-%Y')) ExpiryDate ,im.HsnCode,im.ManufactureName,im.CatalogNo,im.MachineName,im.packsize,(select itemnamegroup from st_itemmaster_group where ItemIDGroup=im.ItemIDGroup) itemname");
        sb.Append(" ,(`InitialCount` - `ReleasedCount` - `PendingQty` ) InHandQty,minorunit ");
        sb.Append(" FROM st_nmstock  st");
        sb.Append(" inner join st_itemmaster im on im.itemid=st.itemid");

        sb.Append(" WHERE locationid=" + locationid.Split('#')[0] + " AND (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1");
       
        sb.Append(" ORDER BY st.expirydate ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savestock(List<string[]> mydataadj)
    {

      
        try
        {
            foreach (string[] a in mydataadj)
            {
                string exdate = Util.GetDateTime(a[1]).ToString("yyyy-MM-dd");
                StockReports.ExecuteDML("update st_nmstock set expirydate='" + exdate + "', BatchNumber='" + a[2] + "' where StockID='" + a[0] + "'");
            }

            return "1";
        }
        catch (Exception ex)
        {
            return ex.InnerException.ToString();
        }
       
    }



   

}
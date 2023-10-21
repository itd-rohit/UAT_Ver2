using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_Centermasterupdate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindcenter();
           
        }
    }


    public void bindcenter()
    {
        ddlcenter.DataSource = StockReports.GetDataTable("SELECT locationid,location FROM st_locationmaster WHERE isactive=1 ORDER BY location");
        ddlcenter.DataValueField = "locationid";
        ddlcenter.DataTextField = "location";
        ddlcenter.DataBind();
        ddlcenter.Items.Insert(0, new ListItem("Select", "0"));
    }


    [WebMethod(EnableSession = true)]
    public static string getstoreadd(string id)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ifnull(StoreLocationAddress,'')StoreLocationAddress FROM st_locationmaster where IsActive=1 and locationid=" + id + ""));
    }


    [WebMethod(EnableSession = true)]
    public static string saveaddress(string id,string address)
    {
        StockReports.ExecuteDML("UPDATE st_locationmaster SET StoreLocationAddress='" + address + "' WHERE locationid=" + id + " ");
        return "1#";
    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getitemdetailtoadd()
    {
        StringBuilder sb = new StringBuilder();
        // sb.Append(" SET @a:=0");
        sb.Append(" SELECT ifnull(StoreLocationAddress,'')StoreLocationAddress,location FROM st_locationmaster where IsActive=1 ORDER BY location ");
       

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));



    }


}
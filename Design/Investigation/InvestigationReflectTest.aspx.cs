using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;
using Newtonsoft.Json;

public partial class Design_Investigation_InvestigationReflectTest : System.Web.UI.Page
{
    
    public static string InvID = "";
    public static string obsid = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        InvID = Request.QueryString["InvID"].ToString();
        obsid = Request.QueryString["obsid"].ToString();
        if (!IsPostBack)
        {

            lb.Text = StockReports.ExecuteScalar("select name from investigation_master where Investigation_Id='" + InvID + "'");
            lbobs.Text = StockReports.ExecuteScalar("SELECT name FROM labobservation_master WHERE labobservation_id='" + obsid + "'");
            bindinv();
        }
    }

    void bindinv()
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT im.itemid,typename name FROM investigation_master inv
INNER JOIN f_itemmaster im ON im.Type_ID=inv.Investigation_Id  AND im.IsActive=1 and Investigation_Id<>'" + InvID + "' ORDER BY NAME  ");

        ddltest.DataSource = dt;
        ddltest.DataValueField = "itemid";
        ddltest.DataTextField = "NAME";
        ddltest.DataBind();
        ddltest.Items.Insert(0, new ListItem("Select","0"));

      
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savedata(string TestID)
    {
        StockReports.ExecuteDML("delete from investigation_Reflecttest where investigationid='" + InvID + "' and Reflecttestid='" + TestID + "' and labobservation_id='"+obsid+"' ");
        StockReports.ExecuteDML("insert into investigation_Reflecttest (investigationid,Reflecttestid,labobservation_id,createdate,createbyuser) values ('" + InvID + "','" + TestID + "','"+obsid+"',now(),'" + HttpContext.Current.Session["ID"].ToString() + "')");
        return "1";
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getdata()
    {
        DataTable dt = StockReports.GetDataTable("SELECT typename,ir.id FROM investigation_Reflecttest ir INNER JOIN f_itemmaster im ON im.itemid=ir.Reflecttestid AND ir.investigationid='"+InvID+"' ORDER BY typename ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string deleteme(string id)
    {
        StockReports.ExecuteDML("delete from investigation_Reflecttest where id='" + id + "'  ");
        return "1";
    }

   
   
}
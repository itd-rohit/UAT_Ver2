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
using System.Collections.Generic;
using Newtonsoft.Json;

public partial class Design_Master_CentreLocator : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindcentre();          
        }     
        
    }
    void bindcentre()
    {
        listcentre.DataSource = StockReports.GetDataTable("SELECT centreid,centre FROM centre_master  ORDER BY centre");
        listcentre.DataValueField = "centreid";
        listcentre.DataTextField = "centre";
        listcentre.DataBind();
        ListBox2.DataSource = StockReports.GetDataTable("SELECT concat(centreid,'$',CentreCode) centreid,centre FROM centre_master ORDER BY centre");
        ListBox2.DataValueField = "centreid";
        ListBox2.DataTextField = "centre";
        ListBox2.DataBind();

    }
    
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindList( string allowapp)
    {
        string str = null;
        if (allowapp == "1")
        {
            str = " SELECT centreid,centre FROM centre_master  where AllowApp='1' and isActive=1  ORDER BY centre ";
        }
        else
        {
            str = " SELECT centreid,centre FROM centre_master where isActive=1  ORDER BY centre ";
        }
        DataTable dt = StockReports.GetDataTable(str);
        string rtrn = JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateCentre(string CentreId, string MobileNo, string WhatsAppMobileNo, string GeoLocation, string Latitude, string Longitude,string AllowApp)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction();
        try
        {
            string instCentre = "update centre_master set Mobile=@MobileNo,WhatsAppNo=@WhatsAppMobileNo,GeoLocation=@GeoLocation,Latitude=@Latitude,Longitude=@Longitude ,AllowApp=@AllowApp where centreid=@CentreId";
            MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, instCentre, new MySqlParameter("@MobileNo", MobileNo), new MySqlParameter("@WhatsAppMobileNo", WhatsAppMobileNo), new MySqlParameter("@GeoLocation", GeoLocation),
                                      new MySqlParameter("@Latitude", Latitude), new MySqlParameter("@Longitude", Longitude), new MySqlParameter("@AllowApp", AllowApp), new MySqlParameter("@CentreId", CentreId));       
            MySqltrans.Commit();
            MySqltrans.Dispose();           
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            MySqltrans.Rollback();            
            return ex.InnerException.Message;
        }
        finally
        {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getdata(string centreid)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT IFNULL(centre,'')centre,IFNULL(CentreCode,''), Concat(Address,',',City,',',State)Address,  IFNULL(Mobile,'')Mobile,IFNULL(WhatsAppNo,'')WhatsAppNo,IFNULL(AllowApp,'')AllowApp,IFNULL(GeoLocation,'')GeoLocation,IFNULL(Latitude,'')Latitude,IFNULL(Longitude,'')Longitude, CentreID FROM centre_master WHERE isActive=1 And CentreID=@centreid  ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@centreid", centreid)).Tables[0];
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            MySqltrans.Rollback();
            return ex.InnerException.Message;
        }
        finally
        {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    
}
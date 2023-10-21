using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_Locationemployee : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

           bindLocationstate();
           bindcenter();
           bindemployee();
        }
    }


    public void bindLocationstate()
    {
        ddlstate.DataSource = StockReports.GetDataTable("SELECT  ID,State Name FROM state_master where IsActive=1 ORDER BY State");
        ddlstate.DataValueField = "ID";
        ddlstate.DataTextField = "Name";
        ddlstate.DataBind();
        ddlstate.Items.Insert(0, new ListItem("Select", "0"));
    
    }


    public void bindcenter()
    {
        ddlcenter.DataSource = StockReports.GetDataTable("SELECT  centreID,centre FROM centre_master where IsActive=1 ORDER BY State");
        ddlcenter.DataValueField = "centreID";
        ddlcenter.DataTextField = "centre";
        ddlcenter.DataBind();
        ddlcenter.Items.Insert(0, new ListItem("Select", "0"));
    }


    public void bindemployee()
    {
        ddlemployee.DataSource = StockReports.GetDataTable("SELECT  Employee_id,Name FROM employee_master where IsActive=1 ORDER BY Name");
        ddlemployee.DataValueField = "Employee_id";
        ddlemployee.DataTextField = "Name";
        ddlemployee.DataBind();
        ddlemployee.Items.Insert(0, new ListItem("Select", "0"));
    }



    [WebMethod(EnableSession = true)]
    public static string bindcentertype()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("select ID,Type1 from centre_type1master Where IsActive=1 order by Type1 "));
    }


    [WebMethod(EnableSession = true)]
    public static string bindCentre(string TypeId, string ZoneId, string StateID, string cityid)
    {





        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.Panel_ID CentreID,pm.company_name Centre FROM f_panel_master  pm");
        sb.Append("  INNER JOIN centre_master cm on cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' then pm.`CentreID` else pm.tagprocessinglabid END AND pm.`PanelType` in('Centre','PUP')   WHERE pm.IsActive=1 ");
        if (ZoneId != "")
            sb.Append(" AND cm.BusinessZoneID IN(" + ZoneId + ")");

        if (StateID != "")
            sb.Append(" AND cm.StateID IN(" + StateID + ")");

        if (cityid != "")
            sb.Append(" AND cm.cityid IN(" + cityid + ")");

        if (TypeId != "")
            sb.Append(" AND cm.Type1Id IN(" + TypeId + ")");

        sb.Append(" ORDER BY Centre");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));


    }


    [WebMethod(EnableSession = true)]
    public static string bindlocation(string centreid, string StateID, string TypeId, string ZoneId, string cityId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lm.LocationID,Location FROM st_locationmaster lm  ");
        //  sb.Append(" INNER JOIN st_mappingitemmaster stm ON stm.`LocationId`=lm.LocationId AND IsPIItem=1 ");
        sb.Append(" INNER JOIN f_panel_master pm on pm.`panel_id`=lm.`panel_id`  ");
        sb.Append(" INNER join centre_master cm on   cm.`CentreID`=pm.`CentreID` AND pm.`PanelType`in('Centre','PUP')   and cm.IsActive=1");
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

        sb.Append(" WHERE lm.IsActive=1 group by lm.LocationID ORDER BY lm.Location");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Savelocationempdata(List<locationdata> quotationdata)
    {
          string Qutationno = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            for (int i = 0; i < quotationdata.Count;i++ )
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into employeecenterlocation(centerid,locationid,employeeid,created_date,created_by,isactive) values(@centerid,@locationid,@employeeid,now(),@created_by,1)",
                         new MySqlParameter("@centerid", quotationdata[i].center),
                         new MySqlParameter("@locationid", quotationdata[i].location),
                         new MySqlParameter("@employeeid", quotationdata[i].employeeid),
                         new MySqlParameter("@created_by", UserInfo.ID)

                         );
                
            }
            tnx.Commit();
            return "1#";
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.Message);
        }

        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        return Qutationno;
    }



     [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getitemdetailtoadd(string createdby)
    {
        StringBuilder sb = new StringBuilder();
       // sb.Append(" SET @a:=0");
        sb.Append(" SELECT el.id,el.created_by,em.name,el.centerid,cm.centre,el.locationid,lm.location,el.employeeid,emm.name name1,DATE_FORMAT(el.created_date,'%d, %M, %Y ') created_date FROM employeecenterlocation el INNER JOIN employee_master em ON el.created_by=em.employee_id  ");
        sb.Append(" INNER JOIN centre_master cm ON el.centerid=cm.centreid INNER JOIN st_locationmaster lm ON el.locationid=lm.locationid ");
        sb.Append(" INNER JOIN employee_master emm ON el.employeeid=emm.employee_id ");
        sb.Append(" where el.isactive=1 order by el.id desc  ");
      
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

        
         
    }

     [WebMethod]
     [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
     public static string removerow(string id)
     {
         StockReports.ExecuteDML("UPDATE employeecenterlocation SET isactive=0,updated_by='"+UserInfo.ID+"',updated_date=now() WHERE id=" + id + " ");
     return "1#";
     
     }


     [WebMethod(EnableSession = true)]
     public static string SearchRecords(string centreid, string StateID, string TypeId,string locationid)
     {
         StringBuilder sb = new StringBuilder();
         sb.Append(" SELECT el.id,el.created_by,em.name,el.centerid,cm.centre,el.locationid,lm.location,el.employeeid,emm.name name1,DATE_FORMAT(el.created_date,'%d, %M, %Y ') created_date FROM employeecenterlocation el INNER JOIN employee_master em ON el.created_by=em.employee_id  ");
         sb.Append(" INNER JOIN centre_master cm ON el.centerid=cm.centreid INNER JOIN st_locationmaster lm ON el.locationid=lm.locationid ");
         sb.Append(" INNER JOIN employee_master emm ON el.employeeid=emm.employee_id ");
         sb.Append(" where el.isactive=1 ");
         if (locationid != "")
            sb.Append(" AND el.locationid  IN(" + locationid + ")");
         sb.Append("order by el.id desc  ");

         DataTable dt = StockReports.GetDataTable(sb.ToString());

         return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
     }

     [WebMethod]
     [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
     public static string updatemultiRecords(string locationid)
     {
         StockReports.ExecuteDML("UPDATE employeecenterlocation SET isactive=0,updated_by='" + UserInfo.ID + "',updated_date=now() WHERE locationid IN (" + locationid + " )");
         return "1#";
     
     }
   

    public class locationdata
    {
        public string location { get; set; }
        public string center { get; set; }
        public string employeeid { get; set; }
       
    }
}
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_RouteMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
            AllLoad_Data.bindBusinessZone(ddlZone, "Select");
            bindState(ddlSearchState);
        }
    }

    public static void bindState(DropDownList ddlObject)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,State FROM state_master WHERE IsActive=1 ORDER BY state").Tables[0])
            {
                if (dt != null && dt.Rows.Count > 0)
                {
                    ddlObject.DataSource = dt;
                    ddlObject.DataTextField = "State";
                    ddlObject.DataValueField = "ID";
                    ddlObject.DataBind();
                    ddlObject.Items.Insert(0, new ListItem("-Select State-"));
                }
                else
                {
                    ddlObject.DataSource = null;
                    ddlObject.DataBind();
                }

            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }


    [WebMethod]
    public static string bindSearchCity(string StateId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string retr = "";
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT ID,City FROM city_master WHERE stateid=@StateId And IsActive=1 order by City",
                new MySqlParameter("@StateId", StateId.Trim())).Tables[0])
            {
                retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }            
            return retr;
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod(EnableSession = true)]
    public static string bindCity(string StateId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string retr = "";
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT ID,City FROM city_master WHERE stateid=@StateId And IsActive=1 order by City",
                new MySqlParameter("@StateId", StateId.Trim())).Tables[0])
            {
                retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            return retr;
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }


    [WebMethod(EnableSession = true)]
    public static string SaveRecord(string ZoneId, string StateId, string CityId, string Route, string IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        
        try
        {
            int valCentreID = UserInfo.Centre;
        }
        catch(Exception Ex)
        {
            return "-1";
        }
        try
        {
            int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  " + Util.getApp("HomeCollectionDB") + ".hc_routemaster WHERE CityId=@CityId  AND Route=@Route ",
                                                                             new MySqlParameter("@CityId", CityId),
                                                                             new MySqlParameter("@Route", Util.GetString(Route.Trim()))
                                                                             ));
            if (valDuplicate > 0)
            {
                Tnx.Rollback();
                return "2";
            }
            StringBuilder sb = new StringBuilder();
            sb = new StringBuilder();
            sb.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_routemaster(Route,IsActive,dtEntry,CreatedBy,CreatedByID,BusinessZoneID,StateID,CityID)");
            sb.Append("VALUES(@Route,@IsActive,@dtEntry,@CreatedBy,@CreatedByID,@BusinessZoneID,@StateID,@CityID)");
            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
            cmd.Parameters.AddWithValue("@Route", Route);
            cmd.Parameters.AddWithValue("@IsActive", IsActive);
            cmd.Parameters.AddWithValue("@dtEntry", System.DateTime.Now);
            cmd.Parameters.AddWithValue("@CreatedBy", UserInfo.UserName);
            cmd.Parameters.AddWithValue("@CreatedByID", UserInfo.ID);
            cmd.Parameters.AddWithValue("@BusinessZoneID", ZoneId);
            cmd.Parameters.AddWithValue("@StateID", StateId);
            cmd.Parameters.AddWithValue("@CityID", CityId);
            cmd.ExecuteNonQuery();
            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string UpdateRecord(string RouteId, string ZoneId, string StateId, string CityId, string Route, string IsActive)
    {
        try
        {
            int valCentreID = UserInfo.Centre;
        }
        catch
        {
            return "-1";
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  " + Util.getApp("HomeCollectionDB") + ".hc_routemaster WHERE CityId=@CityId  AND Route=@route and Routeid<>@RouteId ",
                new MySqlParameter("@CityId", CityId),
                new MySqlParameter("@route", Util.GetString(Route.Trim())),
                new MySqlParameter("RouteId", RouteId)));
            if (valDuplicate > 0)
            {
                Tnx.Rollback();
                return "2";
            }
            StringBuilder sb = new StringBuilder();
            sb = new StringBuilder();
            sb.Append(" Update  " + Util.getApp("HomeCollectionDB") + ".hc_routemaster set Route=@Route,IsActive=@IsActive,Updatedate=@Updatedate,UpdateBy=@UpdateBy,UpdateByID=@UpdateByID,BusinessZoneID=@BusinessZoneID,StateID=@StateID,CityID=@CityID where Routeid=@RouteId ");
            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
            cmd.Parameters.AddWithValue("@Route", Route);
            cmd.Parameters.AddWithValue("@IsActive", IsActive);
            cmd.Parameters.AddWithValue("@Updatedate", System.DateTime.Now);
            cmd.Parameters.AddWithValue("@UpdateBy", UserInfo.UserName);
            cmd.Parameters.AddWithValue("@UpdateByID", UserInfo.ID);
            cmd.Parameters.AddWithValue("@RouteId", RouteId);
            cmd.Parameters.AddWithValue("@BusinessZoneID", ZoneId);
            cmd.Parameters.AddWithValue("@StateID", StateId);
            cmd.Parameters.AddWithValue("@CityID", CityId);
            cmd.ExecuteNonQuery();
            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string GetData(string searchvalue, string NoofRecord, string SearchState, string SearchCity)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int valCentreID = UserInfo.Centre;
        }
        catch
        {
            return "-1";
        }

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("   SELECT hm.`Routeid`,hm.`Route`,IF(hm.IsActive='1','Active','Deactive') `Status`,hm.IsActive,hm.`BusinessZoneID`,zm.`BusinessZoneName` ,hm.`StateID`,sm.`state`,hm.`CityId`,cm.`City` ");
            sb.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".hc_routemaster hm  ");
            sb.Append(" INNER JOIN BusinessZone_master zm ON zm.`BusinessZoneID`=hm.`BusinessZoneID`  ");
            sb.Append(" INNER JOIN state_master sm ON sm.`id`=hm.`StateID` ");
            sb.Append(" INNER JOIN city_master cm ON cm.`ID`=hm.`CityID`  ");
            if (SearchState != "-Select State-")
            {
                sb.Append(" and  sm.`id`=@SearchState ");
            }
            if (SearchCity != ""&& SearchCity !="0")
            {
                sb.Append(" and  cm.`ID`=@SearchCity ");
            }
            if (searchvalue != "")
            {
                sb.Append(" and  hm.`Route` like @searchvalue ");
            }
            sb.Append("  order by cm.`City` limit @NoofRecord  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@SearchState", SearchState),
                new MySqlParameter("@SearchCity", SearchCity),
                new MySqlParameter("@NoofRecord",Util.GetInt(NoofRecord)),
               new MySqlParameter("@searchvalue", string.Format("%{0}%", searchvalue))).Tables[0])
            {
                return Util.getJson(dt);
            }            
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

}
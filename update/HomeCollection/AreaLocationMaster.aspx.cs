using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;


public partial class Design_HomeCollection_AreaLocationMaster : System.Web.UI.Page
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

    [WebMethod(EnableSession = true)]
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
                retr = JsonConvert.SerializeObject(dt);
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
    public static string bindCity(string HeadquarterID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string retr = "";
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT ID,City FROM city_master WHERE HeadQuarterID=@HeadquarterID And IsActive=1 order by City",
                new MySqlParameter("@HeadquarterID", HeadquarterID.Trim())).Tables[0])
            {
                retr = JsonConvert.SerializeObject(dt);
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
    public static string SaveLocality(string Locality, string BusinessZoneID, string StateID, string HeadquarterID, string CityID, string CityZoneId, string Pincode, string IsActive, string startTime, string endTime, string AvgTime, string isHomeCollection)
    {


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM f_locality WHERE CityId=@CityID  AND NAME=@Locality ",
                new MySqlParameter("@CityID", CityID),
                new MySqlParameter("@Locality", Util.GetString(Locality.Trim()))));
            if (valDuplicate > 0)
            {
                Tnx.Rollback();
                return "2";
            }


            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO f_locality (NAME,StateID,HeadQuarterID,CityID,ZoneID,BusinessZoneID,Pincode,active,CreatedByID,CreatedBy,CreatedOn,StartTime,EndTime,AvgTime,isHomeCollection) ");
            sb.Append("VALUES(@NAME,@StateID,@HeadQuarterID,@CityID,@ZoneID,@BusinessZoneID,@Pincode,@active,@CreatedByID,@CreatedBy,@CreatedOn,@StartTime,@EndTime,@AvgTime,@isHomeCollection)");
            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
            cmd.Parameters.AddWithValue("@NAME", Locality);
            cmd.Parameters.AddWithValue("@StateID", StateID);
            cmd.Parameters.AddWithValue("@HeadQuarterID", HeadquarterID);
            cmd.Parameters.AddWithValue("@CityID", CityID);
            cmd.Parameters.AddWithValue("@ZoneID", CityZoneId);
            cmd.Parameters.AddWithValue("@BusinessZoneID", BusinessZoneID);
            cmd.Parameters.AddWithValue("@Pincode", Pincode);
            cmd.Parameters.AddWithValue("@active", IsActive);
            cmd.Parameters.AddWithValue("@CreatedByID", UserInfo.ID);
            cmd.Parameters.AddWithValue("@CreatedBy", UserInfo.UserName);
            cmd.Parameters.AddWithValue("@CreatedOn", System.DateTime.Now);
            cmd.Parameters.AddWithValue("@StartTime", startTime);
            cmd.Parameters.AddWithValue("@EndTime", endTime);
            cmd.Parameters.AddWithValue("@AvgTime", AvgTime);
            cmd.Parameters.AddWithValue("@isHomeCollection", isHomeCollection);
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
    public static string UpdateRecord(string LocalityId, string Locality, string BusinessZoneID, string StateID, string HeadquarterID, string CityID, string CityZoneId, string Pincode, string IsActive, string startTime, string endTime, string AvgTime, string isHomeCollection)
    {


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM f_locality WHERE CityId=@CityID  AND NAME=@Locality and ID<>@LocalityId ",
                                        new MySqlParameter("@CityID", CityID),
                                        new MySqlParameter("@Locality", Util.GetString(Locality.Trim())),
                                        new MySqlParameter("@LocalityId", LocalityId)));

            if (valDuplicate > 0)
            {
                Tnx.Rollback();
                return "2";
            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" Update f_locality set NAME=@NAME,StateID=@StateID,HeadQuarterID=@HeadQuarterID,CityID=@CityID,ZoneID=@ZoneID,BusinessZoneID=@BusinessZoneID,Pincode=@Pincode,active=@active,UpdatedByID=@UpdatedByID,UpdatedBy=@UpdatedBy,UpdatedOn=@UpdatedOn,StartTime=@StartTime,EndTime=@EndTime,AvgTime=@AvgTime,isHomeCollection=@isHomeCollection where Id=@ID ");

            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
            cmd.Parameters.AddWithValue("@Id", LocalityId);
            cmd.Parameters.AddWithValue("@NAME", Locality);
            cmd.Parameters.AddWithValue("@StateID", StateID);
            cmd.Parameters.AddWithValue("@HeadQuarterID", HeadquarterID);
            cmd.Parameters.AddWithValue("@CityID", CityID);
            cmd.Parameters.AddWithValue("@ZoneID", CityZoneId);
            cmd.Parameters.AddWithValue("@BusinessZoneID", BusinessZoneID);
            cmd.Parameters.AddWithValue("@Pincode", Pincode);
            cmd.Parameters.AddWithValue("@active", IsActive);
            cmd.Parameters.AddWithValue("@StartTime", startTime);
            cmd.Parameters.AddWithValue("@EndTime", endTime);
            cmd.Parameters.AddWithValue("@AvgTime", AvgTime);
            cmd.Parameters.AddWithValue("@isHomeCollection", isHomeCollection);

            cmd.Parameters.AddWithValue("@UpdatedOn", System.DateTime.Now);

            cmd.Parameters.AddWithValue("@UpdatedBy", UserInfo.UserName);
            cmd.Parameters.AddWithValue("@UpdatedByID", UserInfo.ID);
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
            sb.Append("SELECT fl.ID,fl.NAME,IF(fl.active='1','Active','DeActive') `Status`,fl.active,fl.StateID,sm.state,fl.CityID,cm.City,fl.ZoneID,czm.Zone,ifnull(fl.PinCode,'')PinCode,bm.BusinessZoneID,bm.BusinessZoneName,fl.HeadquarterID,hm.headquarter,ifnull(TIME_FORMAT(fl.StartTime,'%H:%i'),'') StartTime,ifnull(TIME_FORMAT(fl.EndTime,'%H:%i'),'')EndTime,ifnull(fl.AvgTime,'')AvgTime,IF(fl.isHomeCollection='1','Yes','No') HomeCollectionStatus,fl.isHomeCollection from f_locality fl ");
            sb.Append(" INNER JOIN state_master sm ON sm.id=fl.StateID ");
            sb.Append(" INNER JOIN headquarter_master hm ON hm.id=fl.HeadQuarterID ");
            sb.Append(" INNER JOIN city_master cm ON cm.ID=fl.CityID ");
            sb.Append(" INNER JOIN centre_zonemaster czm ON czm.ZoneID=fl.ZoneID ");
            sb.Append(" INNER JOIN businesszone_master bm ON bm.BusinessZoneID=sm.BusinessZoneID ");
            sb.Append(" where 1=1 ");
            if (SearchState != "-Select State-")
            {
                sb.Append(" and  fl.StateID=@SearchState ");
            }
            if (SearchCity != string.Empty && SearchCity != "0")
            {
                sb.Append(" and  fl.CityID=@SearchCity ");
            }
            if (searchvalue != string.Empty)
            {
                sb.Append(" and  fl.NAME like @searchvalue ");
            }
            sb.Append("  order by fl.NAME desc  limit @NoofRecord  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@SearchState", SearchState),
                new MySqlParameter("@SearchCity", SearchCity),
                new MySqlParameter("@NoofRecord", Util.GetInt(NoofRecord)),
               new MySqlParameter("@searchvalue", string.Format("%{0}%", searchvalue))).Tables[0])
            {
                return Util.getJson(dt);
            }
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
    public static string SearchDataExcel(string searchvalue, string NoofRecord, string SearchState, string SearchCity)
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
            sb.Append("SELECT  fl.NAME 'Location Name', bm.BusinessZoneName'Business Zone', sm.state as State,cm.City ,ifnull(fl.PinCode,'')PinCode,IF(fl.active='1','Active','DeActive') Status,IF(fl.isHomeCollection='1','Yes','No') IsHocollection,ifnull(TIME_FORMAT(fl.StartTime,'%H:%i'),'') 'Opening Time',ifnull(TIME_FORMAT(fl.EndTime,'%H:%i'),'')EndTime,ifnull(fl.AvgTime,'') 'Closing Time' from f_locality fl ");
            sb.Append(" INNER JOIN state_master sm ON sm.id=fl.StateID ");
            sb.Append(" INNER JOIN city_master cm ON cm.ID=fl.CityID ");
            sb.Append(" INNER JOIN businesszone_master bm ON bm.BusinessZoneID=sm.BusinessZoneID ");
            sb.Append(" where 1=1 ");
            if (SearchState != "-Select State-")
            {
                sb.Append(" and  fl.StateID=@SearchState ");
            }
            if (SearchCity != "")
            {
                sb.Append(" and  fl.CityID=@SearchCity ");
            }
            if (searchvalue != "")
            {
                sb.Append(" and  fl.NAME like @searchvalue ");
            }
            sb.Append("  order by fl.NAME    ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@SearchState", SearchState),
                new MySqlParameter("@SearchCity", SearchCity),
                new MySqlParameter("@searchvalue", string.Format("%{0}%", searchvalue))
                ).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = "Area Master";
                    return "true";
                }
                else
                {
                    HttpContext.Current.Session["dtExport2Excel"] = "";
                    return "false";
                }
            }
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
    public static string bindHeadquarter(string StateID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string retr = "";
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,headquarter FROM headquarter_master WHERE StateID=@StateID And IsActive=1 order by headquarter",
                new MySqlParameter("@StateID", StateID.Trim())).Tables[0])
            {
                retr = JsonConvert.SerializeObject(dt);
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
    public static string bindState(string BusinessZoneID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string retr = "";
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT ID,State FROM state_master WHERE BusinessZoneID=@BusinessZoneID and BusinessZoneID<>0 AND IsActive=1 ORDER BY state ",
                new MySqlParameter("@BusinessZoneID", BusinessZoneID)).Tables[0])
            {
                retr = JsonConvert.SerializeObject(dt);
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
    [WebMethod]
    public static string BindSaveLocation(string Locationid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT fl.ID,fl.NAME,IF(fl.active='1','Yes','No') `Status`,fl.active,fl.StateID,fl.CityID,fl.ZoneID,ifnull(fl.PinCode,'')PinCode,fl.BusinessZoneID,fl.HeadquarterID,ifnull(fl.StartTime,'') StartTime,ifnull(fl.EndTime,'')EndTime,ifnull(fl.AvgTime,'')AvgTime,IF(fl.isHomeCollection='1','Yes','No') HomeCollectionStatus,fl.isHomeCollection from f_locality  ");
            sb.Append(" where fl.ID=@Locationid ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@Locationid", Locationid)).Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindZone(string StateID, string CityID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string retr = "";
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT ZoneID,Zone FROM centre_zonemaster WHERE IsActive=1 And StateID=@StateID AND CityID=@CityID   ORDER BY Zone ",
                new MySqlParameter("@StateID", StateID),
                new MySqlParameter("@CityID", CityID.Trim())).Tables[0])
            {
                retr = JsonConvert.SerializeObject(dt);
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

}
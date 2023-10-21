using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_TemporaryPheleboApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CalendarExtender1.StartDate = DateTime.Now;
            CalendarExtender2.StartDate = DateTime.Now;
            txt_joinFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txt_joinTodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            txtJoinTodate_New.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindStateUpdate(ddlState);
            bindState(ddlSearchState);
        }
    }

    public static void bindStateUpdate(ListBox ddlObject)
    {
        DataTable dtData = StockReports.GetDataTable("SELECT ID,State FROM state_master WHERE IsActive=1 ORDER BY state");
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "State";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }

    public static void bindState(DropDownList ddlObject)
    {
        DataTable dtData = StockReports.GetDataTable("SELECT ID,State FROM state_master WHERE IsActive=1 ORDER BY state");
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
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

    [WebMethod(EnableSession = true)]
    public static string bindSearchCity(string StateId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT ID,City FROM city_master WHERE stateid=@stateid And IsActive=1 order by City",
               new MySqlParameter("@stateid", StateId)).Tables[0])
                return JsonConvert.SerializeObject(dt);
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

    [WebMethod(EnableSession = true)]
    public static string bindCity(string StateId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT ID,City FROM city_master WHERE stateid=@stateid And IsActive=1 order by City",
               new MySqlParameter("@stateid", StateId)).Tables[0])
                return JsonConvert.SerializeObject(dt);
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

    [WebMethod(EnableSession = true)]
    public static string bindCityUpdate(string StateId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] StateIdTags = StateId.Split(',');
            string[] StateIdParamNames = StateIdTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string StateIdClause = string.Join(", ", StateIdParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT CONCAT(ID,'#',stateid) ID ,City FROM city_master WHERE stateid in({0}) And IsActive=1 order by City", StateIdClause), con))
            {
                for (int i = 0; i < StateIdParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(StateIdParamNames[i], StateIdTags[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveRecord(string ZoneId, string StateId, string CityId, string Route, string IsActive)
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
            int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM " + Util.getApp("HomeCollectionDB") + ".hc_routemaster WHERE CityId=@CityId  AND Route=@Route ",
               new MySqlParameter("@CityId", CityId),
               new MySqlParameter("@Route", Util.GetString(Route.Trim()))));
            if (valDuplicate > 0)
            {
                Tnx.Rollback();
                return "2";
            }
            StringBuilder sb = new StringBuilder();
            sb = new StringBuilder();
            sb.Append(" INSERT INTO " + Util.getApp("HomeCollectionDB") + ".hc_routemaster(Route,IsActive,dtEntry,CreatedBy,CreatedByID,BusinessZoneID,StateID,CityID)");
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
            int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM " + Util.getApp("HomeCollectionDB") + ".hc_routemaster WHERE CityId=@CityId  AND Route=@Route and Routeid<>@Routeid ",
                new MySqlParameter("@CityId", CityId),
                new MySqlParameter("@Routeid", RouteId),
                new MySqlParameter("@Route", Util.GetString(Route.Trim()))));
            if (valDuplicate > 0)
            {
                Tnx.Rollback();
                return "2";
            }
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update " + Util.getApp("HomeCollectionDB") + ".hc_routemaster set Route=@Route,IsActive=@IsActive,Updatedate=@Updatedate,UpdateBy=@UpdateBy,UpdateByID=@UpdateByID,BusinessZoneID=@BusinessZoneID,StateID=@StateID,CityID=@CityID where Routeid=@RouteId ");
            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
            cmd.Parameters.AddWithValue("@Route", Route);
            cmd.Parameters.AddWithValue("@IsActive", IsActive);
            cmd.Parameters.AddWithValue("@Updatedate", System.DateTime.Now);
            cmd.Parameters.AddWithValue("@UpdateBy", UserInfo.UserName);
            cmd.Parameters.AddWithValue("@UpdateByID", UserInfo.ID);
            cmd.Parameters.AddWithValue("@BusinessZoneID", ZoneId);
            cmd.Parameters.AddWithValue("@StateID", StateId);
            cmd.Parameters.AddWithValue("@CityID", CityId);
            cmd.Parameters.AddWithValue("@RouteId", RouteId);
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
    public static string GetData(string searchvalue, int NoofRecord, string SearchState, string SearchCity, string Status)
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
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT ht.Temp_PhlebotomistID,NAME,Age,Gender,Mobile,Email,P_Address,P_City,P_Pincode,CONCAT(DucumentType,'-',DucumentNo) DucumentNo ");
            sb.Append(" ,IsVerify, GROUP_CONCAT(' ', sm.`state`,' - ',cm.`City`,' ' ) AS WorkLocation,DATE_FORMAT(ht.dtentry,'%d-%b-%Y %H:%i:%s') as dtentry , ifnull(ht.JoinFromDate,'')JoinFromDate ,ifnull(ht.JoinToDate,'')JoinToDate,ifnull(ht.PhlebotomistID,'')PhlebotomistID FROM  ");
            sb.Append(" " + Util.getApp("HomeCollectionDB") + ".`hc_Tempphlebotomist` ht ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".hc_Tempphlebo_worklocation twl ON twl.Temp_PhlebotomistID=ht.Temp_PhlebotomistID ");
            sb.Append(" INNER JOIN `state_master` sm ON sm.`id`=twl.`StateId` ");
            sb.Append(" INNER JOIN `city_master` cm ON cm.id=twl.`CityId` ");
            sb.Append(" where 1=1 ");
            if (SearchState != "-Select State-")
            {
                sb.Append(" and  sm.`id`=@SearchState ");
            }
            if (Status != string.Empty)
            {
                sb.Append(" and  ht.`IsVerify`=@IsVerify ");
            }
            if (SearchCity != string.Empty)
            {
                sb.Append(" and  cm.`ID`=@SearchCity ");
            }
            if (searchvalue != string.Empty)
            {
                sb.Append(" and  ht.`NAME` like @searchvalue");
            }
            sb.Append(" GROUP BY Temp_PhlebotomistID order by  ht.Temp_PhlebotomistID desc  limit @NoofRecord ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@IsVerify", Status),
               new MySqlParameter("@SearchCity", SearchCity),
               new MySqlParameter("@NoofRecord", NoofRecord),
               new MySqlParameter("@SearchState", SearchState),
               new MySqlParameter("@searchvalue", string.Format("%{0}%", searchvalue))).Tables[0];
            return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string Approval(string tempphelboid, string JoinFromDate, string JoinToDate, string UserName, string Password)
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
            int valDuplicateUser = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster WHERE   UserName=@UserName  ",
               new MySqlParameter("@UserName", UserName)));
            if (valDuplicateUser > 0)
            {
                return "2";
            }
            int check = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM " + Util.getApp("HomeCollectionDB") + ".hc_Tempphlebotomist WHERE Temp_PhlebotomistID=@tempphelboid ",
               new MySqlParameter("@tempphelboid", tempphelboid)));
            if (check > 0)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster(NAME,Age,Gender,Mobile,Email,FatherName,MotherName,P_Address,P_City,P_Pincode,DucumentType,DucumentNo,Vehicle_Num,DrivingLicence,UserName,Password,CreatedByID,CreatedBy,IsTemp,JoinFromDate,JoinToDate) ");
                sb.Append(" SELECT NAME,Age,Gender,Mobile,Email,FatherName,MotherName,P_Address,P_City,P_Pincode,DucumentType,DucumentNo,Vehicle_Num,DrivingLicence,@UserName,@Password,@ID,@UserName,1,@JoinFromDate,@JoinToDate from " + Util.getApp("HomeCollectionDB") + ".hc_Tempphlebotomist ");
                sb.Append(" WHERE Temp_PhlebotomistID=@Temp_PhlebotomistID  ");
                sb.Append(" ");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@Temp_PhlebotomistID", tempphelboid),
                   new MySqlParameter("@UserName", UserName),
                   new MySqlParameter("@Password", Password),
                   new MySqlParameter("@ID", UserInfo.ID),
                   new MySqlParameter("@UserName", UserName),
                   new MySqlParameter("@JoinFromDate", JoinFromDate),
                   new MySqlParameter("@JoinToDate", JoinToDate));

                MySqlCommand cmdID = new MySqlCommand("SELECT LAST_INSERT_ID()", con, Tnx);
                string phleboId = cmdID.ExecuteScalar().ToString();

                //========================================================================Location============================================
                sb = new StringBuilder();
                sb.Append(" INSERT INTO " + Util.getApp("HomeCollectionDB") + ".hc_phleboworklocation(PhlebotomistID,StateId,CityId,EntryBy,EntryByname,EntryDate) ");
                sb.Append(" SELECT @phleboId, StateId,CityId,@EntryBy,@EntryByname,now() FROM " + Util.getApp("HomeCollectionDB") + ".`hc_Tempphlebo_worklocation` ");
                sb.Append(" WHERE Temp_PhlebotomistID=@Temp_PhlebotomistID  ");
                sb.Append(" ");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@Temp_PhlebotomistID", tempphelboid),
                  new MySqlParameter("@phleboId", phleboId),
                  new MySqlParameter("@EntryBy", UserInfo.ID),
                  new MySqlParameter("@EntryByname", UserInfo.UserName));
                sb = new StringBuilder();
                sb.Append(" update " + Util.getApp("HomeCollectionDB") + ".hc_Tempphlebotomist set IsVerify='1',ApproveById=@ApproveById,ApproveBy=@ApproveBy,JoinFromDate=@JoinFromDate,JoinToDate=@JoinToDate,ApproveDate=now(),PhlebotomistID=@phleboId where Temp_PhlebotomistID=@tempphelboid  ");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@ApproveById", UserInfo.ID),
                   new MySqlParameter("@ApproveBy", UserInfo.UserName),
                   new MySqlParameter("@JoinFromDate", JoinFromDate),
                   new MySqlParameter("@JoinToDate", JoinToDate),
                   new MySqlParameter("@phleboId", phleboId),
                   new MySqlParameter("@tempphelboid", tempphelboid));
                Tnx.Commit();
                return "1";
            }
            else
            {
                return "0";
            }
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
    public static string UpdateJoingDate(string tempphelboid, string JoinToDate)
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
            StringBuilder sb = new StringBuilder();
            sb.Append(" update " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster set  JoinToDate=@JoinToDate,  Updatedate=now(),UpdateBy=@UpdateBy, UpdateByID=@UpdateByID where PhlebotomistID=@tempphelboid  ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@JoinToDate", Util.GetDateTime(JoinToDate).ToString("yyyy-MM-dd")),
               new MySqlParameter("@UpdateBy", UserInfo.UserName),
               new MySqlParameter("@UpdateByID", UserInfo.ID),
               new MySqlParameter("@tempphelboid", tempphelboid));

            sb = new StringBuilder();
            sb.Append(" update " + Util.getApp("HomeCollectionDB") + ".hc_Tempphlebotomist set  JoinToDate='" + JoinToDate + "',  Updatedate=now(),UpdateBy=@UpdateBy, UpdateByID=@UpdateByID where PhlebotomistID=@tempphelboid  ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@JoinToDate", Util.GetDateTime(JoinToDate).ToString("yyyy-MM-dd")),
               new MySqlParameter("@UpdateBy", UserInfo.UserName),
               new MySqlParameter("@UpdateByID", UserInfo.ID),
               new MySqlParameter("@tempphelboid", tempphelboid));

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

    [WebMethod]
    public static string BindSavePhelebotomist(string Pheleboid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT pm.Temp_PhlebotomistID,NAME,Age,Gender,Mobile,Email,P_Address,P_City,P_Pincode,DucumentType,DucumentNo,Vehicle_Num,DrivingLicence,GROUP_CONCAT(`StateId`) AS StateId,GROUP_CONCAT(concat(CityId,'#',StateId)) AS CityId from " + Util.getApp("HomeCollectionDB") + ".hc_Tempphlebotomist pm ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".hc_Tempphlebo_worklocation pl ON pl.`Temp_PhlebotomistID`=pm.`Temp_PhlebotomistID`");
            sb.Append(" where pm.Temp_PhlebotomistID=@Pheleboid");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@Pheleboid", Pheleboid)).Tables[0]);
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

    [WebMethod]
    public static string BindJoinDatePhelebotomist(string Pheleboid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT DATE_FORMAT(JoinFromDate,'%d-%b-%Y') as  JoinFromDate,DATE_FORMAT(JoinToDate,'%d-%b-%Y') JoinToDate from " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster  ");
            sb.Append(" where PhlebotomistID=@Pheleboid");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@Pheleboid", Pheleboid)).Tables[0]);
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

    [WebMethod]
    public static string UpdateTempPhelebotomist(PhelebotomistMaster1 obj, string[] CityStateId)
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
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update  " + Util.getApp("HomeCollectionDB") + ".hc_Tempphlebotomist set NAME=@NAME,Age=@Age,Gender=@Gender,Mobile=@Mobile, ");
            sb.Append("  Email=@Email,P_Address=@P_Address, ");
            sb.Append("  P_City=@P_City,P_Pincode=@P_Pincode,Vehicle_Num=@Vehicle_Num, ");
            sb.Append("  DrivingLicence=@DrivingLicence,DucumentType=@DucumentType,DucumentNo=@DucumentNo, ");
            sb.Append("  Updatedate=@Updatedate,UpdateBy=@UpdateBy, ");
            sb.Append("  UpdateByID=@UpdateByID where Temp_PhlebotomistID=@Temp_PhlebotomistID ");

            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
            cmd.Parameters.AddWithValue("@Temp_PhlebotomistID", obj.PhelebotomistId);
            cmd.Parameters.AddWithValue("@NAME", obj.NAME);
            cmd.Parameters.AddWithValue("@Age", obj.Age);
            cmd.Parameters.AddWithValue("@Gender", obj.Gender);
            cmd.Parameters.AddWithValue("@Mobile", obj.Mobile);
            cmd.Parameters.AddWithValue("@Email", obj.Email);
            cmd.Parameters.AddWithValue("@P_Address", obj.P_Address);
            cmd.Parameters.AddWithValue("@P_City", obj.P_City);
            cmd.Parameters.AddWithValue("@P_Pincode", obj.P_Pincode);
            cmd.Parameters.AddWithValue("@Vehicle_Num", obj.Vehicle_Num);
            cmd.Parameters.AddWithValue("@DrivingLicence", obj.DrivingLicence);
            cmd.Parameters.AddWithValue("@DucumentType", obj.DucumentType);
            cmd.Parameters.AddWithValue("@DucumentNo", obj.DucumentNo);
            cmd.Parameters.AddWithValue("@Updatedate", System.DateTime.Now);
            cmd.Parameters.AddWithValue("@UpdateBy", UserInfo.UserName);
            cmd.Parameters.AddWithValue("@UpdateByID", UserInfo.ID);
            cmd.ExecuteNonQuery();

            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "Delete from " + Util.getApp("HomeCollectionDB") + ".hc_Tempphlebo_worklocation where Temp_PhlebotomistID=@PhelebotomistId",
               new MySqlParameter("@PhelebotomistId", obj.PhelebotomistId));

            StringBuilder sbCityState = new StringBuilder();
            string[] CityStateIDBreak = CityStateId;
            for (int i = 0; i < CityStateIDBreak.Length; i++)
            {
                sbCityState = new StringBuilder();
                sbCityState.Append(" insert into " + Util.getApp("HomeCollectionDB") + ".hc_Tempphlebo_worklocation (Temp_PhlebotomistID,StateId,CityId,EntryDate,EntryBy,EntryByname) ");
                sbCityState.Append(" values (@Temp_PhlebotomistID,@StateId,@CityId,@EntryDate,@EntryBy,@EntryByname) ");
                MySqlCommand cmdCityState = new MySqlCommand(sbCityState.ToString(), con, Tnx);
                cmdCityState.Parameters.Clear();
                cmdCityState.Parameters.AddWithValue("@Temp_PhlebotomistID", obj.PhelebotomistId);
                cmdCityState.Parameters.AddWithValue("@StateId", CityStateIDBreak[i].Split('#')[1]);
                cmdCityState.Parameters.AddWithValue("@CityId", CityStateIDBreak[i].Split('#')[0]);
                cmdCityState.Parameters.AddWithValue("@EntryDate", System.DateTime.Now);
                cmdCityState.Parameters.AddWithValue("@EntryByname", UserInfo.UserName);
                cmdCityState.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmdCityState.ExecuteNonQuery();
            }
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
    public static string Reject(string Pheleboid)
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
            StringBuilder sb = new StringBuilder();
            sb.Append(" update " + Util.getApp("HomeCollectionDB") + ".hc_Tempphlebotomist set IsVerify='2',RejectById=@RejectById,RejectBy=@RejectBy,RejectDate=now() where Temp_PhlebotomistID=@Pheleboid  ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@RejectById", UserInfo.ID),
                        new MySqlParameter("@RejectBy", UserInfo.UserName),
                        new MySqlParameter("@Pheleboid", Pheleboid));
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

    public class PhelebotomistMaster1
    {
        public int PhelebotomistId { get; set; }
        public string NAME { get; set; }
        public string IsActive { get; set; }
        public string Age { get; set; }
        public string Gender { get; set; }
        public string Mobile { get; set; }
        public string Other_Contact { get; set; }
        public string Email { get; set; }
        public string FatherName { get; set; }
        public string MotherName { get; set; }
        public string P_Address { get; set; }
        public string P_City { get; set; }
        public string P_Pincode { get; set; }
        public string BloodGroup { get; set; }
        public string Qualification { get; set; }
        public string Vehicle_Num { get; set; }
        public string DrivingLicence { get; set; }
        public string PanNo { get; set; }
        public string DucumentType { get; set; }
        public string DucumentNo { get; set; }
        public string JoiningDate { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
    }
}
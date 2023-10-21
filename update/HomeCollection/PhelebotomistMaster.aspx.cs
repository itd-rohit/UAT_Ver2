using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.UI;
public partial class Design_HomeCollection_PhelebotomistMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
          
            if (!IsPostBack)
            {
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select ID,concat(ChargeName,' @ ', ChargeAmount) Charge from " + Util.getApp("HomeCollectionDB") + ".hc_PhelboChargeMaster order by id")
                    .Tables[0])
                {
                    bindState(ddlState);
                    
                   

                    chchfrom.StartDate = DateTime.Now;
                    chchto.StartDate = DateTime.Now;
                    ddlcharge.DataSource = dt;
                    ddlcharge.DataValueField = "ID";
                    ddlcharge.DataTextField = "Charge";
                    ddlcharge.DataBind();
                    ddlcharge.Items.Insert(0, new ListItem("Select", "0"));
                    bindSearchState(ddlSearchState);
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

    public static void bindState(ListBox ddlObject)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dtData = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,State FROM state_master WHERE IsActive=1 ORDER BY state")
                        .Tables[0])
            {
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

    public static void bindSearchState(DropDownList ddlObject)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dtData = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,State FROM state_master WHERE IsActive=1 ORDER BY state")
                     .Tables[0])
            {
                if (dtData != null && dtData.Rows.Count > 0)
                {
                    ddlObject.DataSource = dtData;
                    ddlObject.DataTextField = "State";
                    ddlObject.DataValueField = "ID";
                    ddlObject.DataBind();
                    ddlObject.Items.Insert(0, new ListItem("-Select State-", "0"));
                  
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
    public static string bindCity(string StateId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            List<string> pacitem = new List<string>();
            string[] pacitemTags = String.Join(",", StateId).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT CONCAT(ID,'#',stateid) ID ,City FROM city_master WHERE stateid in({0}) And IsActive=1 order by City", pacitemClause), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
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
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string SavePhelebotomist(PhelebotomistMaster1 obj, string[] CityStateId, string PhelboSource, List<PhleboCharge> phlebochargedata)
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
            int valDuplicateUser = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster WHERE   UserName=@UserName  ",
                new MySqlParameter("@UserName", obj.UserName)));
            if (valDuplicateUser > 0)
            {
                return "2";
            }
            else
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster(NAME,IsActive,Age,Gender,Mobile,Other_Contact,Email,FatherName,MotherName,P_Address,P_City,P_Pincode,BloodGroup,Qualification,Vehicle_Num,DrivingLicence,PanNo,DucumentType,DucumentNo,JoiningDate,dtEntry,CreatedBy,CreatedByID,UserName,Password,PhelboSource)");
                sb.Append("VALUES(@NAME,@IsActive,@Age,@Gender,@Mobile,@Other_Contact,@Email,@FatherName,@MotherName,@P_Address,@P_City,@P_Pincode,@BloodGroup,@Qualification,@Vehicle_Num,@DrivingLicence,@PanNo,@DucumentType,@DucumentNo,@JoiningDate,@dtEntry,@CreatedBy,@CreatedByID,@UserName,@Password,@PhelboSource)");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
                cmd.Parameters.AddWithValue("@NAME", obj.NAME);
                cmd.Parameters.AddWithValue("@IsActive", obj.IsActive);
                cmd.Parameters.AddWithValue("@Age", obj.Age);
                cmd.Parameters.AddWithValue("@Gender", obj.Gender);
                cmd.Parameters.AddWithValue("@Mobile", obj.Mobile);
                cmd.Parameters.AddWithValue("@Other_Contact", obj.Other_Contact);
                cmd.Parameters.AddWithValue("@Email", obj.Email);
                cmd.Parameters.AddWithValue("@FatherName", obj.FatherName);
                cmd.Parameters.AddWithValue("@MotherName", obj.MotherName);
                cmd.Parameters.AddWithValue("@P_Address", obj.P_Address);
                cmd.Parameters.AddWithValue("@P_City", obj.P_City);
                cmd.Parameters.AddWithValue("@P_Pincode", obj.P_Pincode);
                cmd.Parameters.AddWithValue("@BloodGroup", obj.BloodGroup);
                cmd.Parameters.AddWithValue("@Qualification", obj.Qualification);
                cmd.Parameters.AddWithValue("@Vehicle_Num", obj.Vehicle_Num);
                cmd.Parameters.AddWithValue("@DrivingLicence", obj.DrivingLicence);
                cmd.Parameters.AddWithValue("@PanNo", obj.PanNo);
                cmd.Parameters.AddWithValue("@DucumentType", obj.DucumentType);
                cmd.Parameters.AddWithValue("@DucumentNo", obj.DucumentNo);
                cmd.Parameters.AddWithValue("@JoiningDate", obj.JoiningDate);
                cmd.Parameters.AddWithValue("@dtEntry", System.DateTime.Now);
                cmd.Parameters.AddWithValue("@CreatedBy", UserInfo.UserName);
                cmd.Parameters.AddWithValue("@CreatedByID", UserInfo.ID);
                cmd.Parameters.AddWithValue("@UserName", obj.UserName);
                cmd.Parameters.AddWithValue("@Password", obj.Password);
                cmd.Parameters.AddWithValue("@PhelboSource", PhelboSource);
                cmd.ExecuteNonQuery();
                MySqlCommand cmdID = new MySqlCommand("SELECT LAST_INSERT_ID()", con, Tnx);
                string phleboId = cmdID.ExecuteScalar().ToString();
                StringBuilder sbCityState = new StringBuilder();
                string[] CityStateIDBreak = CityStateId;
                for (int i = 0; i < CityStateIDBreak.Length; i++)
                {
                    int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  " + Util.getApp("HomeCollectionDB") + ".hc_PhleboWorkLocation WHERE CityId=@CityStateIDBreak and  PhlebotomistID=@phleboId ",
                        new MySqlParameter("@CityStateIDBreak", CityStateIDBreak[i].Split('#')[0]),
                        new MySqlParameter("@phleboId", phleboId)));
                    if (valDuplicate == 0)
                    {
                        sbCityState = new StringBuilder();
                        sbCityState.Append(" insert into  " + Util.getApp("HomeCollectionDB") + ".hc_PhleboWorkLocation (PhlebotomistID,StateId,CityId,EntryDate,EntryBy,EntryByname) ");
                        sbCityState.Append(" values (@PhlebotomistID,@StateId,@CityId,@EntryDate,@EntryBy,@EntryByname) ");
                        MySqlCommand cmdCityState = new MySqlCommand(sbCityState.ToString(), con, Tnx);
                        cmdCityState.Parameters.Clear();
                        cmdCityState.Parameters.AddWithValue("@PhlebotomistID", phleboId);
                        cmdCityState.Parameters.AddWithValue("@StateId", CityStateIDBreak[i].Split('#')[1]);
                        cmdCityState.Parameters.AddWithValue("@CityId", CityStateIDBreak[i].Split('#')[0]);
                        cmdCityState.Parameters.AddWithValue("@EntryDate", System.DateTime.Now);
                        cmdCityState.Parameters.AddWithValue("@EntryByname", UserInfo.UserName);
                        cmdCityState.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                        cmdCityState.ExecuteNonQuery();
                    }
                }
                foreach (PhleboCharge pc in phlebochargedata)
                {
                    sb = new StringBuilder();
                    sb.Append(" insert into  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomist_chargemapping (PhlebotomistID,ChargeID,FromDate,ToDate,EntryDate,EntryByID,EntryByName) ");
                    sb.Append(" values (@PhlebotomistID,@ChargeID,@FromDate,@ToDate,@EntryDate,@EntryByID,@EntryByName)");
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@PhlebotomistID", phleboId),
                        new MySqlParameter("@ChargeID", pc.ChargeID),
                        new MySqlParameter("@FromDate", Util.GetDateTime(pc.FromDate)),
                        new MySqlParameter("@ToDate", Util.GetDateTime(pc.ToDate)),
                        new MySqlParameter("@EntryDate", DateTime.Now),
                        new MySqlParameter("@EntryByID", UserInfo.ID),
                        new MySqlParameter("@EntryByName", UserInfo.LoginName));
                }

                Tnx.Commit();
                return "1";
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

    [WebMethod]
    public static string UpdatePhelebotomist(PhelebotomistMaster1 obj, string[] CityStateId, string PhelboSource, List<PhleboCharge> phlebochargedata)
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
            int valDuplicateUser = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster WHERE PhlebotomistID<>@PhelebotomistId  and  UserName=@UserName  ",
                new MySqlParameter("@PhelebotomistId", obj.PhelebotomistId),
                new MySqlParameter("@UserName", obj.UserName)));
            if (valDuplicateUser > 0)
            {
                return "2";
            }
            else
            {
                sb = new StringBuilder();
                sb.Append(" Update   " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster set NAME=@NAME,IsActive=@IsActive,Age=@Age,Gender=@Gender,Mobile=@Mobile, ");
                sb.Append("  Other_Contact=@Other_Contact,Email=@Email,FatherName=@FatherName,MotherName=@MotherName,P_Address=@P_Address, ");
                sb.Append("  P_City=@P_City,P_Pincode=@P_Pincode,BloodGroup=@BloodGroup,Qualification=@Qualification,Vehicle_Num=@Vehicle_Num, ");
                sb.Append("  DrivingLicence=@DrivingLicence,PanNo=@PanNo,DucumentType=@DucumentType,DucumentNo=@DucumentNo,JoiningDate=@JoiningDate, ");
                sb.Append("  Updatedate=@Updatedate,UpdateBy=@UpdateBy,UpdateByID=@UpdateByID,DeviceID=@DeviceID, UserName=@UserName,Password=@Password,PhelboSource=@PhelboSource ");
                sb.Append("  where PhlebotomistID=@PhlebotomistID");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
                cmd.Parameters.AddWithValue("@PhlebotomistID", obj.PhelebotomistId);
                cmd.Parameters.AddWithValue("@NAME", obj.NAME);
                cmd.Parameters.AddWithValue("@IsActive", obj.IsActive);
                cmd.Parameters.AddWithValue("@Age", obj.Age);
                cmd.Parameters.AddWithValue("@Gender", obj.Gender);
                cmd.Parameters.AddWithValue("@Mobile", obj.Mobile);
                cmd.Parameters.AddWithValue("@Other_Contact", obj.Other_Contact);
                cmd.Parameters.AddWithValue("@Email", obj.Email);
                cmd.Parameters.AddWithValue("@FatherName", obj.FatherName);
                cmd.Parameters.AddWithValue("@MotherName", obj.MotherName);
                cmd.Parameters.AddWithValue("@P_Address", obj.P_Address);
                cmd.Parameters.AddWithValue("@P_City", obj.P_City);
                cmd.Parameters.AddWithValue("@P_Pincode", obj.P_Pincode);
                cmd.Parameters.AddWithValue("@BloodGroup", obj.BloodGroup);
                cmd.Parameters.AddWithValue("@Qualification", obj.Qualification);
                cmd.Parameters.AddWithValue("@Vehicle_Num", obj.Vehicle_Num);
                cmd.Parameters.AddWithValue("@DrivingLicence", obj.DrivingLicence);
                cmd.Parameters.AddWithValue("@PanNo", obj.PanNo);
                cmd.Parameters.AddWithValue("@DucumentType", obj.DucumentType);
                cmd.Parameters.AddWithValue("@DucumentNo", obj.DucumentNo);
                cmd.Parameters.AddWithValue("@JoiningDate", obj.JoiningDate);
                cmd.Parameters.AddWithValue("@Updatedate", System.DateTime.Now);
                cmd.Parameters.AddWithValue("@UpdateBy", UserInfo.UserName);
                cmd.Parameters.AddWithValue("@UpdateByID", UserInfo.ID);
                cmd.Parameters.AddWithValue("@DeviceID", obj.DeviceID);
                cmd.Parameters.AddWithValue("@UserName", obj.UserName);
                cmd.Parameters.AddWithValue("@Password", obj.Password);
                cmd.Parameters.AddWithValue("@PhelboSource", PhelboSource);
                cmd.ExecuteNonQuery();

                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "Delete from  " + Util.getApp("HomeCollectionDB") + ".hc_PhleboWorkLocation where PhlebotomistID=@PhlebotomistID",
                   new MySqlParameter("@PhlebotomistID", obj.PhelebotomistId));

              
                StringBuilder sbCityState = new StringBuilder();
                string[] CityStateIDBreak = CityStateId;
                for (int i = 0; i < CityStateIDBreak.Length; i++)
                {
                    sbCityState = new StringBuilder();
                    sbCityState.Append(" insert into  " + Util.getApp("HomeCollectionDB") + ".hc_PhleboWorkLocation (PhlebotomistID,StateId,CityId,EntryDate,EntryBy,EntryByname) ");
                    sbCityState.Append(" values (@PhlebotomistID,@StateId,@CityId,@EntryDate,@EntryBy,@EntryByname) ");
                    MySqlCommand cmdCityState = new MySqlCommand(sbCityState.ToString(), con, Tnx);
                    cmdCityState.Parameters.Clear();
                    cmdCityState.Parameters.AddWithValue("@PhlebotomistID", obj.PhelebotomistId);
                    cmdCityState.Parameters.AddWithValue("@StateId", CityStateIDBreak[i].Split('#')[1]);
                    cmdCityState.Parameters.AddWithValue("@CityId", CityStateIDBreak[i].Split('#')[0]);
                    cmdCityState.Parameters.AddWithValue("@EntryDate", System.DateTime.Now);
                    cmdCityState.Parameters.AddWithValue("@EntryByname", UserInfo.UserName);
                    cmdCityState.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                    cmdCityState.ExecuteNonQuery();
                }

                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "delete from  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomist_chargemapping where PhlebotomistID=@PhlebotomistID",
                    new MySqlParameter("@PhlebotomistID", obj.PhelebotomistId));

                foreach (PhleboCharge pc in phlebochargedata)
                {
                    sb = new StringBuilder();
                    sb.Append(" insert into  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomist_chargemapping (PhlebotomistID,ChargeID,FromDate,ToDate,EntryDate,EntryByID,EntryByName) ");
                    sb.Append(" values (@PhlebotomistID,@ChargeID,@FromDate,@ToDate,@EntryDate,@EntryByID,@EntryByName)");
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@PhlebotomistID", obj.PhelebotomistId),
                        new MySqlParameter("@ChargeID", pc.ChargeID),
                        new MySqlParameter("@FromDate", Util.GetDateTime(pc.FromDate)),
                        new MySqlParameter("@ToDate", Util.GetDateTime(pc.ToDate)),
                        new MySqlParameter("@EntryDate", DateTime.Now),
                        new MySqlParameter("@EntryByID", UserInfo.ID),
                        new MySqlParameter("@EntryByName", UserInfo.LoginName));
                }
                Tnx.Commit();
                return "1";
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

    [WebMethod]
    public static string ResetDeviceId(string PhelebotomistId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update   " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster set DeviceID='' where  PhlebotomistID=@PhlebotomistID ");
            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
            cmd.Parameters.AddWithValue("@PhlebotomistID", PhelebotomistId);
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

    [WebMethod]
    public static string BindChData(string Pheleboid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT hc.`ChargeID`,hm.`ChargeName`,hm.`ChargeAmount`,DATE_FORMAT(hc.`FromDate`,'%d-%b-%Y') fromdate, ");
            sb.Append(" DATE_FORMAT(hc.`todate`,'%d-%b-%Y')todate FROM  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomist_chargemapping hc  ");
            sb.Append(" INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".`hc_PhelboChargeMaster` hm ON hc.`ChargeID`=hm.`ID`  WHERE hc.`PhlebotomistID`=@Pheleboid ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Pheleboid", Pheleboid)
                ).Tables[0])
            {
                return Util.getJson(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.getJson(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindProfilePic(string ProfilePicsID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select ifnull(ProfilePics,'') ProfilePics FROM  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster_profilepic where  ID=@ProfilePicsID ");
            return Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@ProfilePicsID", Util.GetString(ProfilePicsID))));
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
    public static string ApprovalProfile(string Profile_ID)
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
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " update  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster_profilepic set Approved='1',ApprovedByID=@ID,ApprovedDate=now() where ID=@Profile_ID  ",
                new MySqlParameter("@ID", UserInfo.ID),
                new MySqlParameter("@Profile_ID", Profile_ID));

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
        public string DeviceID { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public static string GetDataExcel(string searchtype, string searchvalue, string NoofRecord, string SearchState, string SearchCity, string SearchGender)
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
            sb.Append("SELECT hpm.PhlebotomistID,hpm.NAME,IF(hpm.IsActive='1','Yes','No') `Status`,hpm.IsActive,hpm.Age,hpm.Gender,hpm.Mobile,hpm.Email,ifnull(hpm.Qualification,'')Qualification,ifnull(hpm.UserName,'') UserName,ifnull(hpm.DeviceID,'') DeviceID ");
            sb.Append(" ,IFNULL (hpm.PhelboSource,'') PhelboSource ");
            sb.Append(" from  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster hpm  ");
            sb.Append(" inner join   " + Util.getApp("HomeCollectionDB") + ".hc_PhleboWorkLocation hpmm on hpmm.PhlebotomistID=hpm.PhlebotomistID  ");

            sb.Append(" where 1=1  ");
            if (SearchState != "0")
            {
                sb.Append(" and  hpmm.StateId=@SearchState ");
            }
            if (SearchCity != string.Empty && SearchCity!=null)
            {
                sb.Append(" and  hpmm.CityId=@SearchCity ");
            }

            if (SearchGender != string.Empty)
            {
                sb.Append(" and  hpm.Gender=@SearchGender ");
            }
            if (searchvalue != string.Empty)
            {
                sb.Append(" and   @searchtype like @searchvalue ");
            }

            sb.Append("  group by hpm.PhlebotomistID order by hpm.dtEntry desc limit @NoofRecord  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@SearchState", SearchState),
                new MySqlParameter("@SearchCity", SearchCity),
                new MySqlParameter("@searchtype", searchtype),
                new MySqlParameter("@NoofRecord", Util.GetInt(NoofRecord)),
                new MySqlParameter("@SearchGender", SearchGender),
                new MySqlParameter("@searchvalue", string.Format("%{0}%", searchvalue))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = "Phelebotomist Master";
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
    public static string GetData(string searchtype, string searchvalue, string NoofRecord, string SearchState, string SearchCity, string SearchGender, string IsDeactivatePP)
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
            sb.Append("SELECT hpm.PhlebotomistID,hpm.NAME,IF(hpm.IsActive='1','Yes','No') `Status`,hpm.IsActive,hpm.Age,hpm.Gender,hpm.Mobile,hpm.Email,ifnull(hpm.Qualification,'')Qualification,ifnull(hpm.UserName,'') UserName,ifnull(hpm.DeviceID,'') DeviceID ");
            if (IsDeactivatePP == "0")
            {
                sb.Append("  ,ifnull(hpp.ID,'') ProfilePicID ");
            }
            sb.Append(" ,IFNULL (hpm.PhelboSource,'') PhelboSource ");
            sb.Append(" from  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster hpm  ");
            sb.Append(" inner join   " + Util.getApp("HomeCollectionDB") + ".hc_PhleboWorkLocation hpmm on hpmm.PhlebotomistID=hpm.PhlebotomistID  ");
            if (IsDeactivatePP == "0")
            {
                sb.Append(" inner join  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster_profilepic hpp on hpp.PhlebotomistID=hpm.PhlebotomistID and hpp.Active=1 and hpp.Approved=0 ");
            }

            sb.Append(" WHERE 1=1  ");
            if (SearchState != "0")
            {
                sb.Append(" and  hpmm.StateId=@SearchState ");
            }

            if (SearchCity != string.Empty && SearchCity !=null)
            {
                sb.Append(" and  hpmm.CityId=@SearchCity ");
            }

            if (SearchGender != string.Empty)
            {
                sb.Append(" and  hpm.Gender=@SearchGender ");
            }
            if (searchvalue != string.Empty)
            {
                sb.Append(" and   "+searchtype+" like @searchvalue ");
            }
            sb.Append("  group by hpm.PhlebotomistID order by hpm.dtEntry desc limit @NoofRecord ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@SearchState", SearchState),
                                              new MySqlParameter("@SearchCity", SearchCity),
                                              new MySqlParameter("@SearchGender", SearchGender),
                                              new MySqlParameter("@searchtype", searchtype),
                                              new MySqlParameter("@NoofRecord", Util.GetInt(NoofRecord)),
                                              new MySqlParameter("@searchvalue", string.Format("%{0}%", searchvalue))).Tables[0])
                return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
             return string.Empty;
        }
        finally
        {
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
            sb.Append("SELECT pm.PhlebotomistID,NAME,IsActive,Age,Gender,Mobile,Email,Other_Contact,FatherName,MotherName,P_Address,P_City,P_Pincode,BloodGroup,");
            sb.Append(" DucumentType,DucumentNo,PanNo,Qualification,WA_State,WA_StateId,WA_City,WA_CityId,Vehicle_Num,DrivingLicence,JoiningDate,UserName,Password,");
            sb.Append(" GROUP_CONCAT(`StateId`) AS StateId,GROUP_CONCAT(concat(CityId,'#',StateId)) AS CityId,ifnull(pm.DeviceID,'') DeviceID,IFNULL(PhelboSource,'') PhelboSource, ");
            sb.Append("  ifnull((select ProfilePics from  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster_profilepic pp where pp.`PhlebotomistID`=pm.`PhlebotomistID` and Approved=1 order by id limit 1),'') ProfilePics ");
            sb.Append(" from  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster pm ");
            sb.Append(" INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_PhleboWorkLocation pl ON pl.`PhlebotomistID`=pm.`PhlebotomistID`");
            sb.Append(" where pm.PhlebotomistID=@Pheleboid ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Pheleboid", Pheleboid)).Tables[0])
                return Util.getJson(dt);
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

    public class PhleboCharge
    {
        public string ChargeID { get; set; }
        public string ChargeAmount { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
    }
}
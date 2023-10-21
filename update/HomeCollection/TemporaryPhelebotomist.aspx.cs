using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_TemporaryPhelebotomist : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        bindState(ddlState);
    }

    public static void bindState(ListBox ddlObject)
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

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindCity(string StateId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT CONCAT(ID,'#',stateid) ID ,City FROM city_master WHERE stateid in({0}) And IsActive=1 order by City");

            string[] ItemIDTags = StateId.Split(',');
            string[] ItemIDParamNames = ItemIDTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string ItemIDClause = string.Join(", ", ItemIDParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), ItemIDClause), con))
            {
                for (int i = 0; i < ItemIDParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(ItemIDParamNames[i], ItemIDTags[i]);
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
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string GenerateOTP(string MobileNo)
    {
        try
        {
            string alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            string small_alphabets = "abcdefghijklmnopqrstuvwxyz";
            string numbers = "1234567890";

            string characters = numbers;

            //characters += alphabets + small_alphabets + numbers;

            characters += numbers;

            int length = 4;
            string otp = string.Empty;
            for (int i = 0; i < length; i++)
            {
                string character = string.Empty;
                do
                {
                    int index = new Random().Next(0, characters.Length);
                    character = characters.ToCharArray()[index].ToString();
                } while (otp.IndexOf(character) != -1);
                otp += character;
            }

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
            int valDuplicateUser = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  " + Util.getApp("HomeCollectionDB") + ".hc_Otp_Tempphlebotomist WHERE   Mobile=@MobileNo  ",
                new MySqlParameter("@MobileNo", MobileNo)));
            StringBuilder sb = new StringBuilder();
            if (valDuplicateUser > 0)
            {
                DateTime CurentTime = DateTime.Now;
                sb = new StringBuilder();
                sb.Append("update  " + Util.getApp("HomeCollectionDB") + ".hc_Otp_Tempphlebotomist set Otp=@Otp,EntryDate=@EntryDate,ExpiryDate=@ExpiryDate,IsVerify=@IsVerify where Mobile=@Mobile ");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
                cmd.Parameters.AddWithValue("@Mobile", MobileNo);
                cmd.Parameters.AddWithValue("@Otp", otp);
                cmd.Parameters.AddWithValue("@EntryDate", CurentTime);
                cmd.Parameters.AddWithValue("@ExpiryDate", CurentTime.AddMinutes(Util.GetDouble(5)));
                cmd.Parameters.AddWithValue("@IsVerify", 0);
                cmd.ExecuteNonQuery();
            }
            else
            {
                DateTime CurentTime = DateTime.Now;
                sb = new StringBuilder();
                sb.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_Otp_Tempphlebotomist(Mobile,Otp,EntryDate,ExpiryDate,IsVerify)");
                sb.Append("VALUES(@Mobile,@Otp,@EntryDate,@ExpiryDate,@IsVerify)");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
                cmd.Parameters.AddWithValue("@Mobile", MobileNo);

                cmd.Parameters.AddWithValue("@Otp", otp);
                cmd.Parameters.AddWithValue("@EntryDate", CurentTime);
                cmd.Parameters.AddWithValue("@ExpiryDate", CurentTime.AddMinutes(Util.GetDouble(5)));
                cmd.Parameters.AddWithValue("@IsVerify", 0);
                cmd.ExecuteNonQuery();
            }

            string SmsData = string.Concat("Registration OTP -", otp);
            //Sms_Host sm = new Sms_Host();
            //sm._Msg = SmsData;
            //sm._SmsTo = MobileNo;
            //sm.sendSms();
            StringBuilder sbSMS = new StringBuilder();
            sbSMS.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".SMS(MOBILE_NO,SMS_TEXT,IsSend,SMS_Type) ");
            sbSMS.Append("VALUES(@MOBILE_NO,@SMS_TEXT,@IsSend,@SMS_Type)");
            MySqlCommand cmdSms = new MySqlCommand(sbSMS.ToString(), con, Tnx);
            cmdSms.Parameters.AddWithValue("@MOBILE_NO", MobileNo);
            cmdSms.Parameters.AddWithValue("@SMS_TEXT", SmsData);
            cmdSms.Parameters.AddWithValue("@IsSend", "0");
            cmdSms.Parameters.AddWithValue("@SMS_Type", "TempPhlebotomistOTP");
            cmdSms.ExecuteNonQuery();
            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

    [WebMethod]
    public static string SavePhelebotomist(PhelebotomistMaster1 obj, string[] CityStateId, string Otp)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            StringBuilder sb = new StringBuilder();

            int checkOtp = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text,"SELECT COUNT(1) FROM  " + Util.getApp("HomeCollectionDB") + ".hc_Otp_Tempphlebotomist WHERE   Mobile=@mobile and Otp=@Otp and ExpiryDate>now() ",
                                                   new MySqlParameter("@mobile", obj.Mobile),
                                                   new MySqlParameter("@Otp", Otp)));
            if (checkOtp > 0)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_Tempphlebotomist(NAME,Age,Gender,Mobile,Email,FatherName,P_Address,P_City,P_Pincode,Vehicle_Num,DrivingLicence,DucumentType,DucumentNo,dtEntry,CreatedBy,CreatedByID,IsVerify)");
                sb.Append("VALUES(@NAME,@Age,@Gender,@Mobile,@Email,@FatherName,@P_Address,@P_City,@P_Pincode,@Vehicle_Num,@DrivingLicence,@DucumentType,@DucumentNo,@dtEntry,@CreatedBy,@CreatedByID,@IsVerify)");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
                cmd.Parameters.AddWithValue("@NAME", obj.NAME);

                cmd.Parameters.AddWithValue("@Age", obj.Age);
                cmd.Parameters.AddWithValue("@Gender", obj.Gender);
                cmd.Parameters.AddWithValue("@Mobile", obj.Mobile);

                cmd.Parameters.AddWithValue("@Email", obj.Email);
                cmd.Parameters.AddWithValue("@FatherName", obj.FatherName);

                cmd.Parameters.AddWithValue("@P_Address", obj.P_Address);
                cmd.Parameters.AddWithValue("@P_City", obj.P_City);
                cmd.Parameters.AddWithValue("@P_Pincode", obj.P_Pincode);

                cmd.Parameters.AddWithValue("@Vehicle_Num", obj.Vehicle_Num);
                cmd.Parameters.AddWithValue("@DrivingLicence", obj.DrivingLicence);

                cmd.Parameters.AddWithValue("@DucumentType", obj.DucumentType);
                cmd.Parameters.AddWithValue("@DucumentNo", obj.DucumentNo);

                cmd.Parameters.AddWithValue("@dtEntry", System.DateTime.Now);
                cmd.Parameters.AddWithValue("@CreatedBy", "");
                cmd.Parameters.AddWithValue("@CreatedByID", 0);
                cmd.Parameters.AddWithValue("@IsVerify", 0);

                cmd.ExecuteNonQuery();

                MySqlCommand cmdID = new MySqlCommand("SELECT LAST_INSERT_ID()", con, Tnx);
                string phleboId = cmdID.ExecuteScalar().ToString();

                StringBuilder sbCityState = new StringBuilder();

                string[] CityStateIDBreak = CityStateId;

                for (int i = 0; i < CityStateIDBreak.Length; i++)
                {
                    int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text,
                        "SELECT COUNT(1) FROM  " + Util.getApp("HomeCollectionDB") + ".hc_Tempphlebo_worklocation WHERE CityId=@CityStateIDBreak and  Temp_PhlebotomistID=@phleboId ",
                        new MySqlParameter("@CityStateIDBreak", CityStateIDBreak[i].Split('#')[0]),
                        new MySqlParameter("@phleboId", phleboId)));

                    if (valDuplicate == 0)
                    {
                        sbCityState = new StringBuilder();
                        sbCityState.Append(" insert into  " + Util.getApp("HomeCollectionDB") + ".hc_Tempphlebo_worklocation (Temp_PhlebotomistID,StateId,CityId,EntryDate,EntryBy,EntryByname) ");
                        sbCityState.Append(" values (@Temp_PhlebotomistID,@StateId,@CityId,@EntryDate,@EntryBy,@EntryByname) ");

                        MySqlCommand cmdCityState = new MySqlCommand(sbCityState.ToString(), con, Tnx);

                        cmdCityState.Parameters.Clear();
                        cmdCityState.Parameters.AddWithValue("@Temp_PhlebotomistID", phleboId);
                        cmdCityState.Parameters.AddWithValue("@StateId", CityStateIDBreak[i].Split('#')[1]);
                        cmdCityState.Parameters.AddWithValue("@CityId", CityStateIDBreak[i].Split('#')[0]);
                        cmdCityState.Parameters.AddWithValue("@EntryDate", System.DateTime.Now);
                        cmdCityState.Parameters.AddWithValue("@EntryByname", "");
                        cmdCityState.Parameters.AddWithValue("@EntryBy", 0);
                        cmdCityState.ExecuteNonQuery();
                    }
                }
                Tnx.Commit();
                return "1";
            }
            else
            {
                return "2";
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
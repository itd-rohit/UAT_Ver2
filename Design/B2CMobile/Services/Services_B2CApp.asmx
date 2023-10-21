<%@ WebService Language="C#" Class="Services_B2CApp" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
using System.IO;
using System.Linq;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class Services_B2CApp : System.Web.Services.WebService
{
    string url = "http://182.18.138.149/ItdoseLab/Design/";
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Registration(string name, string dob, string mobileno, string address, string email, string Title, string Gender, string Age, string PinCode, string City, string IsDOB, string UserPin)
    {
        Param param = new Param();
        param.status = false;
        param.error = "";
        param.data = "[]";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " Select count(1) FROM app_register where mobile=@mobile LIMIT 1 ",
                   new MySqlParameter("@mobile", Util.GetString(mobileno))).ToString() == "1")
            {
                param.message = "Sorry!! Already registered mobile no";
            }
            else
            {
                string chars = "0123456789";
                char[] stringChars = new char[6];
                Random random = new Random();
                for (int i = 0; i < stringChars.Length; i++)
                {
                    stringChars[i] = chars[random.Next(chars.Length)];
                }
                string finalString = new String(stringChars);
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO `app_register`(Name,dob,Mobile,Address,email,Title,Gender,Age,PinCode,City,IsDOB,UserPin,IsPinActive)");
                sb.Append("VALUES(@Name,@dob,@Mobile,@Address,@email,@Title,@Gender,@Age,@PinCode,@City,@IsDOB,@UserPin,@IsPinActive) ");
                int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@Name", Util.GetString(name)),
                      new MySqlParameter("@dob", Util.GetDateTime(dob).ToString("yyyy-MM-dd")),
                    new MySqlParameter("@Mobile", Util.GetString(mobileno)),
                     new MySqlParameter("@Address", Util.GetString(address)),
                    new MySqlParameter("@email", Util.GetString(email)),
                    new MySqlParameter("@Title", Util.GetString(Title)),
                       new MySqlParameter("@Age", Util.GetString(Age)),
                     new MySqlParameter("@Gender", Util.GetString(Gender)),
                    new MySqlParameter("@PinCode", Util.GetString(PinCode)),
                    new MySqlParameter("@City", City),
                     new MySqlParameter("@IsDOB", Util.GetInt(IsDOB)),
                      new MySqlParameter("@UserPin", UserPin),
                      new MySqlParameter("@IsPinActive", 1)
                    );
                if (a == 1)
                {
                    sb = new StringBuilder();
                    string SMSText = "Dear Customer, " + finalString + " is your one time password(OTP) . Please enter the OTP to proceed. Thank you.";
                    sb.Append("INSERT INTO `sms`(MOBILE_NO,SMS_TEXT,IsSend,USerID,EntDate)");
                    sb.Append("VALUES(@MOBILE_NO,@SMS_TEXT,@IsSend,@USerID,now()) ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@MOBILE_NO", Util.GetString(mobileno)),
                     new MySqlParameter("@SMS_TEXT", SMSText),
                    new MySqlParameter("@IsSend", Util.GetInt(0)),
                    new MySqlParameter("@USerID", Util.GetInt(0))
                   );
                    sb = new StringBuilder();
                    sb.Append("INSERT INTO `app_otp`(mobile,otp,entrydate)");
                    sb.Append("VALUES(@mobile,@otp,Now()) ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@mobile", Util.GetString(mobileno)),
                      new MySqlParameter("@otp", "123456")
                    );
                    string OTP = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " select otp from app_otp  where mobile=@mobile Order by entrydate desc LIMIT 1 ",
                    new MySqlParameter("@mobile", Util.GetString(mobileno))).ToString();

                    param.status = true;
                    param.message = "Successful";
                    param.data = OTP;


                }
                else
                {
                    param.message = "No Data Found";
                }
                tnx.Commit();
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        return GetResult(param);
    }
	
	[WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetTimeSlot_DateFilter()
    {
        Param param = new Param();
        try
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(@" SELECT  CONCAT(TIME_FORMAT(StartTime, '%h:%i%p'),'-',TIME_FORMAT(EndTime, '%h:%i%p'))TimeSlot,AvgTimeMin FROM app_b2c_slot_master group by StartTime; ");
            dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                return makejsonoftable(dt, makejson.e_with_square_brackets);

            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }


    }
	
	 public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
	
	 public static string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                if (fieldvalue == "True" || fieldvalue == "False")
                {
                    sb2.Append(string.Format("\"{0}\":{1}", fieldname, Convert.ToBoolean(fieldvalue)));
                }
                else if (fieldname == "TestDetails")
                {
                    sb2.Append(string.Format("\"{0}\":{1}", fieldname, fieldvalue));
                }
                else
                {
                    sb2.Append(string.Format("\"{0}\":\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));
                }


            }
            sb.Append(sb2.ToString());
            sb.Append("}");


        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();
    }
	
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateUserInfo(string name, string dob, string mobileno, string address, string email, string Title, string Gender, string Age, string PinCode, string City, string IsDOB, string UserPin)
    {
        Param param = new Param();
        param.status = false;
        param.error = "";
        param.data = "[]";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            if (MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "  Select count(1) FROM app_register where mobile=@mobile and IsActive=1 and IsRegistered=1 Order by EntryDate desc LIMIT 1 ",
                   new MySqlParameter("@mobile", Util.GetString(mobileno))).ToString() == "1")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE app_register SET Name=@Name,dob=@dob,Mobile=@Mobile,Address=@Address,email=@email,Title=@Title,Gender=@Gender,Age=@Age,PinCode=@PinCode,City=@City,IsDOB=@IsDOB,UserPin=@UserPin,IsPinActive=@IsPinActive  Where Mobile=@Mobile  ");

                int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@Name", Util.GetString(name)),
                      new MySqlParameter("@dob", Util.GetDateTime(dob).ToString("yyyy-MM-dd")),
                    new MySqlParameter("@Mobile", Util.GetString(mobileno)),
                     new MySqlParameter("@Address", Util.GetString(address)),
                    new MySqlParameter("@email", Util.GetString(email)),
                    new MySqlParameter("@Title", Util.GetString(Title)),
                     new MySqlParameter("@Gender", Util.GetString(Gender)),
                      new MySqlParameter("@Age", Util.GetString(Age)),
                    new MySqlParameter("@PinCode", Util.GetString(PinCode)),
                    new MySqlParameter("@City", City),
                     new MySqlParameter("@IsDOB", Util.GetInt(IsDOB)),
                      new MySqlParameter("@UserPin", UserPin),
                      new MySqlParameter("@IsPinActive", 1)
                    );
                if (a == 1)
                {
                    param.status = true;
                    param.message = "Details Updated Successful";
                }
                else
                {
                    param.message = "Details Not Updated ";
                }

            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        return GetResult(param);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string ResendOTPRegistation(string mobileno)
    {
        Param param = new Param();
        param.status = false;
        param.error = "";
        param.data = "[]";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (mobileno == "")
            {

                param.message = "Invalid Mobile No.";
                return GetResult(param);
            }
            if (MySqlHelper.ExecuteScalar(con, CommandType.Text, "  Select count(1) FROM app_register where mobile=@mobile and IsActive=1 and IsRegistered=1 Order by EntryDate desc LIMIT 1 ",
                    new MySqlParameter("@mobile", Util.GetString(mobileno))).ToString() == "0")
            {
                string chars = "0123456789";
                char[] stringChars = new char[6];
                Random random = new Random();
                for (int i = 0; i < stringChars.Length; i++)
                {
                    stringChars[i] = chars[random.Next(chars.Length)];
                }
                string finalString = new String(stringChars);
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO `app_otp`(mobile,otp,entrydate)");
                sb.Append("VALUES(@mobile,@otp,Now()) ");
                int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@mobile", Util.GetString(mobileno)),
                new MySqlParameter("@otp", finalString));
                if (a == 1)
                {
                    sb = new StringBuilder();
                    string SMSText = "Dear Customer, " + finalString + " is your one time password(OTP) . Please enter the OTP to proceed. Thank you.";
                    sb.Append("INSERT INTO `sms`(MOBILE_NO,SMS_TEXT,IsSend,USerID,EntDate)");
                    sb.Append("VALUES(@MOBILE_NO,@SMS_TEXT,@IsSend,@USerID,now()) ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@MOBILE_NO", Util.GetString(mobileno)),
                     new MySqlParameter("@SMS_TEXT", SMSText),
                    new MySqlParameter("@IsSend", Util.GetInt(0)),
                    new MySqlParameter("@USerID", Util.GetInt(0))
                   );
                    string OTP = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " select otp from app_otp  where mobile=@mobile Order by entrydate desc LIMIT 1 ",
                    new MySqlParameter("@mobile", Util.GetString(mobileno))).ToString();

                    param.status = true;
                    param.message = "Successful";
                    param.data = OTP;

                }
                else
                {
                    param.message = "No Data Found";
                }
                tnx.Commit();
            }
            else
            {

                param.message = "Sorry!! Please enter registered mobile no";

            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        return GetResult(param);
    }




    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Login(string mobileno, string HasKey)//
    {
        ParamData param = new ParamData();
        param.status = false;
        param.error = "";
        param.data = "[]";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (mobileno == "")
            {

                param.message = "Invalid Mobile No.";
                return GetResult(param);
            }
            if (MySqlHelper.ExecuteScalar(con, CommandType.Text, "  Select count(1) FROM app_register where mobile=@mobile and IsActive=1 and IsRegistered=1 Order by EntryDate desc LIMIT 1 ",
                  new MySqlParameter("@mobile", Util.GetString(mobileno))).ToString() == "1")
            {
                string count = MySqlHelper.ExecuteScalar(con, CommandType.Text, "  select count(*) from app_register where mobile=@mobile  and IsPinActive=1;",
                new MySqlParameter("@mobile", Util.GetString(mobileno))).ToString();

                if (count == "0")
                {
                    string chars = "0123456789";
                    char[] stringChars = new char[6];
                    Random random = new Random();
                    for (int i = 0; i < stringChars.Length; i++)
                    {
                        stringChars[i] = chars[random.Next(chars.Length)];
                    }
                    string finalString = new String(stringChars);

                    StringBuilder sb = new StringBuilder();
                    sb.Append("INSERT INTO `app_otp`(mobile,otp,entrydate)");
                    sb.Append("VALUES(@mobile,@otp,Now()) ");
                    int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@mobile", Util.GetString(mobileno)),
                    new MySqlParameter("@otp", finalString));

                    if (a == 1)
                    {
                        sb = new StringBuilder();
                        string SMSText = "Dear Customer, " + finalString + " is your one time password(OTP) . Please enter the OTP to proceed. Thank you." + HasKey; ;
                        sb.Append("INSERT INTO `sms`(MOBILE_NO,SMS_TEXT,IsSend,USerID,EntDate)");
                        sb.Append("VALUES(@MOBILE_NO,@SMS_TEXT,@IsSend,@USerID,now()) ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@MOBILE_NO", Util.GetString(mobileno)),
                         new MySqlParameter("@SMS_TEXT", SMSText),
                        new MySqlParameter("@IsSend", Util.GetInt(0)),
                        new MySqlParameter("@USerID", Util.GetInt(0))
                       );
                        string OTP = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " select otp from app_otp  where mobile=@mobile Order by entrydate desc LIMIT 1 ",
                        new MySqlParameter("@mobile", Util.GetString(mobileno))).ToString();
                        param.status = true;
                        param.message = "Successful";
                        param.UserPin = "";
                        param.IsPinActive = Util.GetInt(0);
                        param.OTP = OTP;
                    }
                    else
                    {
                        param.message = "No Data Found";

                    }
                }
                else
                {


                    string qry = "select 'True' as status,'' AS error,'Successful' as message, UserPin,IsPinActive,''AS OTP from app_register where mobile=@mobileno";
                    DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, qry.ToString(), new MySqlParameter("@mobileno", mobileno)).Tables[0];
                    param.status = true;
                    param.message = "Successful";
                    param.UserPin = dt.Rows[0]["UserPin"].ToString();
                    param.IsPinActive = Util.GetInt(dt.Rows[0]["IsPinActive"].ToString());
                    param.OTP = "";
                    tnx.Commit();
                }
            }
            else
            {

                param.message = "Sorry!! Please enter registered mobile no";

            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


        return GetResult(param);
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string loginWithUserPin(string mobileno, string UserPin)
    {
        MyArray param = new MyArray();
        param.status = "False";
        param.message = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (mobileno == "" || UserPin == "")
            {

                param.message = "Please enter OTP";
                return GetResult(param);
            }

            string count = MySqlHelper.ExecuteScalar(con, CommandType.Text, "  select count(*) from app_register where mobile=@mobile and UserPin=@UserPin",
                  new MySqlParameter("@mobile", Util.GetString(mobileno)), new MySqlParameter("@UserPin", Util.GetString(UserPin))).ToString();
            if (count == "0")
            {

                param.message = "Invalid UserPin";
                return GetResult(param);
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update app_register set IsRegistered=1 where mobile=@Mobile and IsRegistered=0  ",
               new MySqlParameter("@Mobile", Util.GetString(mobileno))
               );

                string qry = "select  'Successful' as message,'True' as status, ID, IFNULL(NAME,'')NAME,Mobile,IFNULL(Address,'')Address,IFNULL(email,'')email,DATE_FORMAT(dob,'%d-%b-%Y %r')dob,IFNULL(DATE_FORMAT(entrydate,'%d-%b-%Y %r'),'')entrydate,IFNULL(Title,'')Title,IFNULL(Gender,'')Gender,If(IsDOB=0,IFNULL(Age,''),'') Age,IFNULL(City,'')City,IFNULL(PinCode,'')PinCode,IsDOB,IFNULL(UserPin,'')UserPin FROM app_register where mobile=@mobileno  and IsActive=1 and UserPin=@UserPin Order by EntryDate desc LIMIT 1 ";
                DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, qry.ToString(), new MySqlParameter("@mobileno", mobileno), new MySqlParameter("@UserPin", UserPin)).Tables[0];
                param.status = "True";
                param.message = "Successful";
                param.NAME = dt.Rows[0]["NAME"].ToString();
                param.UserPin = dt.Rows[0]["UserPin"].ToString();
                param.Address = dt.Rows[0]["Address"].ToString();
                param.email = dt.Rows[0]["email"].ToString();
                param.Mobile = dt.Rows[0]["Mobile"].ToString();
                param.ID = Util.GetInt(dt.Rows[0]["ID"].ToString());
                param.dob = dt.Rows[0]["dob"].ToString();
                param.Age = dt.Rows[0]["Age"].ToString();
                param.Title = dt.Rows[0]["Title"].ToString();
                param.Gender = dt.Rows[0]["Gender"].ToString();
                param.IsDOB = Util.GetInt(dt.Rows[0]["IsDOB"].ToString());
                param.PinCode = dt.Rows[0]["PinCode"].ToString();
                param.City = dt.Rows[0]["City"].ToString();
                param.entrydate = dt.Rows[0]["entrydate"].ToString();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            param.message = "There are some techinal issue";
            return GetResult(param);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        return GetResult(param);

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string ForgetPin(string mobileno, string HasKey)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        Param param = new Param();
        param.status = false;
        param.message = "";
        param.error = "";
        param.data = "[]";

        try
        {
            if (mobileno == "")
            {

                param.message = "Invalid Mobile No.";
                return GetResult(param);
            }
            if (MySqlHelper.ExecuteScalar(con, CommandType.Text, "  Select count(1) FROM app_register where mobile=@mobile and IsActive=1 and IsRegistered=1 Order by EntryDate desc LIMIT 1 ",
                    new MySqlParameter("@mobile", Util.GetString(mobileno))).ToString() == "1")
            {
                string chars = "0123456789";
                char[] stringChars = new char[6];
                Random random = new Random();

                for (int i = 0; i < stringChars.Length; i++)
                {
                    stringChars[i] = chars[random.Next(chars.Length)];
                }

                string finalString = new String(stringChars);
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO `app_otp`(mobile,otp,entrydate)");
                sb.Append("VALUES(@mobile,@otp,Now()) ");
                int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@mobile", Util.GetString(mobileno)),
                new MySqlParameter("@otp", finalString));

                if (a == 1)
                {
                    sb = new StringBuilder();
                    string SMSText = "Dear Customer, " + finalString + " is your one time password(OTP) . Please enter the OTP to proceed. Thank you.";
                    sb.Append("INSERT INTO `sms`(MOBILE_NO,SMS_TEXT,IsSend,USerID,EntDate)");
                    sb.Append("VALUES(@MOBILE_NO,@SMS_TEXT,@IsSend,@USerID,now()) ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@MOBILE_NO", Util.GetString(mobileno)),
                     new MySqlParameter("@SMS_TEXT", SMSText),
                    new MySqlParameter("@IsSend", Util.GetInt(0)),
                    new MySqlParameter("@USerID", Util.GetInt(0))
                   );
                    string OTP = MySqlHelper.ExecuteScalar(con, CommandType.Text, " select otp from app_otp  where mobile=@mobile Order by entrydate desc LIMIT 1 ",
                    new MySqlParameter("@mobile", Util.GetString(mobileno))).ToString();
                    param.status = true;
                    param.message = "Successful";
                    param.error = "";
                    return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("select 'True' as status,'' AS error,'Successful' as message, '' AS UserPin,0 As IsPinActive,'" + OTP + "' AS OTP"));

                }
                else
                {
                    param.message = "No Data Found";
                }
            }
            else
            {
                param.message = "Sorry!! Please enter registered mobile no";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        return GetResult(param);
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string ValidateOTP(string mobileno, string otp)
    {
        Param param = new Param();
        param.status = false;
        param.message = "";
        param.error = "";
        param.data = "[]";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (mobileno == "" || otp == "")
            {

                param.message = "Please enter OTP";
                return GetResult(param);
            }
            string count = MySqlHelper.ExecuteScalar(con, CommandType.Text, " select count(*) from app_otp  where mobile=@mobile and otp=@otp and isverified=0 ",
                    new MySqlParameter("@mobile", Util.GetString(mobileno)), new MySqlParameter("@otp", Util.GetString(otp))).ToString();
            if (count == "0")
            {
                param.message = "Invalid OTP";
                return GetResult(param);
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update app_otp  SET isverified=1,verifieddate=now()  Where Mobile=@Mobile and otp=@otp and isverified=0 ",
                       new MySqlParameter("@otp", Util.GetString(otp)),
                      new MySqlParameter("@Mobile", Util.GetString(mobileno))
                      );
                param.status = true;
                param.message = "Successful";
                param.data = mobileno;
                tnx.Commit();
                return GetResult(param);

            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            tnx.Rollback();
            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();
            return GetResult(param);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateUserPin(string mobileno, string UserPin)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        Param param = new Param();
        param.status = false;
        param.message = "";
        param.error = "";
        param.data = "[]";

        try
        {
            if (mobileno == "" || UserPin == "")
            {

                param.message = "Please enter OTP";

                return GetResult(param);
            }
            string count = MySqlHelper.ExecuteScalar(con, CommandType.Text, "  Select count(1) FROM app_register where mobile=@mobile and IsActive=1  ",
                    new MySqlParameter("@mobile", Util.GetString(mobileno))).ToString();


            if (count == "0")
            {

                param.message = "Invalid Mobile Number";

                return GetResult(param);
            }
            else
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update app_register set UserPin=@UserPin,IsPinActive=1  where mobile=@Mobile ",
              new MySqlParameter("@Mobile", Util.GetString(mobileno)), new MySqlParameter("@UserPin", Util.GetString(UserPin))
              );

                param.status = true;
                param.message = "User Pin Updated Successfully";

                tnx.Commit();
                return GetResult(param);

            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();
            return GetResult(param);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string verifyotp(string mobileno, string otp)
    {
        Param param = new Param();
        param.status = false;
        param.message = "";
        param.error = "";
        param.data = "[]";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (mobileno == "" || otp == "")
            {

                param.message = "Please enter OTP";
                return GetResult(param);
            }
            string count = MySqlHelper.ExecuteScalar(con, CommandType.Text, " select count(*) from app_otp  where mobile=@mobile and otp=@otp and isverified=0 ",
                    new MySqlParameter("@mobile", Util.GetString(mobileno)), new MySqlParameter("@otp", Util.GetString(otp))).ToString();
            if (count == "0")
            {

                param.message = "Invalid OTP";

                return GetResult(param);
            }
            else
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update app_otp  SET isverified=1,verifieddate=now()  Where Mobile=@Mobile and otp=@otp and isverified=0 ",
                     new MySqlParameter("@otp", Util.GetString(otp)),
                    new MySqlParameter("@Mobile", Util.GetString(mobileno))
                    );
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update app_register set IsRegistered=1 where mobile=@Mobile and IsRegistered=0  ",
               new MySqlParameter("@Mobile", Util.GetString(mobileno))
               );

                string qry = "Select 'Successful' as message,'True' as status, ID, NAME,Mobile,IFNULL(Address,'')Address,IFNULL(email,'')email,DATE_FORMAT(dob,'%d-%b-%Y %r')dob,DATE_FORMAT(entrydate,'%d-%b-%Y %r')entrydate,Title,Gender,If(IsDOB=0,IFNULL(Age,''),'') Age,City,IFNULL(PinCode,'')PinCode,IsDOB FROM app_register where mobile=@mobileno and IsActive=1 and IsRegistered=1 Order by EntryDate desc LIMIT 1";
                DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, qry.ToString(), new MySqlParameter("@mobileno", mobileno)).Tables[0];
                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();
            return GetResult(param);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindpackage(string Test, string PageNo)
    {
        Param param = new Param();
        param.status = false;
        param.message = "";
        param.error = "";
        param.data = "[]";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (PageNo == "")
            {
                return "[]";
            }
            int offSet = 0;
            int _limit = 25;
            int _PageNo = Util.GetInt(PageNo);
            if (_PageNo > 0)
            {
                offSet = (_PageNo - 1) * _limit;
            }
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.ItemID,REPLACE(im.TypeName,',',' ') AS Item, rl.Rate ,sm.`Name` AS SubCategory , Group_Concat(pld.InvestigationID) Investigation_ID, pld.PlabID PackageID  ");
            sb.Append(" FROM f_itemmaster im   ");
            sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.subcategoryid = im.subcategoryid ");
            sb.Append(" INNER JOIN `package_labdetail` pld  ON im.`Type_ID`=pld.PlabID ");
            sb.Append(" INNER JOIN f_ratelist rl ON rl.ItemID=im.ItemID AND rl.Panel_ID=79 ");
            sb.Append(" WHERE sm.CategoryID='LSHHI44' and   im.IsActive=1  ");
            if (Test != "")
            {
                sb.Append(" AND (im.TypeName like @Test or im.Inv_ShortName like @Test) ");
            }
            sb.Append(" GROUP BY im.itemid having ifnull(rl.Rate,0)>0 ORDER BY im.TypeName LIMIT " + offSet + "," + _limit + "; ");//im.IsFavourite DESC,
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@Test", string.Concat("%", Test, "%"))).Tables[0];
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetpackageTestInfo(string pakageID, string PageNo)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (PageNo == "")
            {
                return "[]";
            }
            int offSet = 0;
            int _limit = 50;
            int _PageNo = Util.GetInt(PageNo);
            if (_PageNo > 0)
            {
                offSet = (_PageNo - 1) * _limit;
            }
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(@" SELECT im.`TypeName` TestName,IFNULL(r.`Rate`,0)Rate FROM packagelab_master plm
                         INNER JOIN `package_labdetail` pld ON pld.`PlabID`=plm.`PlabID`
                         INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=pld.`InvestigationID`
                         INNER JOIN f_itemmaster im ON im.`Type_ID`=inv.`Investigation_Id`
                         INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=im.`SubCategoryID` AND scm.`CategoryID`='LSHHI3'
                         LEFT JOIN f_ratelist r ON r.`ItemID`=im.`ItemID` and Panel_ID=79  
                         WHERE  im.isactive=1 and plm.`PlabID`=@pakageID ORDER BY im.`TypeName`LIMIT " + offSet + "," + _limit + "; ");//im.IsFavourite DESC,
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@pakageID", pakageID)).Tables[0];

            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    //Bilal
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindInvestigation(string Test, string PageNo)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (PageNo == "")
            {
                return "[]";
            }
            int offSet = 0;
            int _limit = 25;
            int _PageNo = Util.GetInt(PageNo);
            if (_PageNo > 0)
            {
                offSet = (_PageNo - 1) * _limit;
            }
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.ItemID,im.Type_ID Investigation_ID,REPLACE(im.TypeName,',',' ') AS Item, rl.Rate ,sm.`Name` AS SubCategory,'' PackageID      ");
            sb.Append(" FROM f_itemmaster im ");
            sb.Append(" INNER JOIN `investigation_master`  invm ON im.Type_ID = invm.Investigation_ID AND (invm.`ReportType`=1 OR invm.`ReportType`=3)");
            sb.Append(" INNER JOIN f_subcategorymaster sm  ON sm.subcategoryid = im.subcategoryid ");
            sb.Append(" INNER JOIN f_ratelist rl ON rl.ItemID=im.ItemID AND rl.Panel_ID='79' ");
            sb.Append(" and ifnull(rl.Rate,0)>0 WHERE sm.CategoryID='LSHHI3' and im.TypeName<>''   ");
            if (Test != "")
            {
                sb.Append(" AND (im.TypeName like @Test or im.Inv_ShortName like @Test) ");
            }
            sb.Append(" AND im.IsActive=1 ORDER BY im.TypeName LIMIT " + offSet + "," + _limit + ";");// im.IsFavourite DESC,
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@Test", string.Concat("%", Test, "%"))).Tables[0];
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindRadiologyInvestigation(string Test, string PageNo)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (PageNo == "")
            {
                return "[]";
            }
            int offSet = 0;
            int _limit = 25;
            int _PageNo = Util.GetInt(PageNo);
            if (_PageNo > 0)
            {
                offSet = (_PageNo - 1) * _limit;
            }
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append("   SELECT im.itemid typeid,REPLACE(im.TypeName,',',' ') AS Item, rl.Rate ,sm.`Name` AS SubCategory ,''  Tests,  '' pakageID   ");
            sb.Append("   FROM f_itemmaster im ");
            sb.Append(" INNER JOIN `investigation_master`  invm ON im.Type_ID = invm.Investigation_ID AND invm.`ReportType`=5 ");
            sb.Append(" INNER JOIN f_subcategorymaster sm  ");
            sb.Append("   ON sm.subcategoryid = im.subcategoryid ");
            sb.Append("   INNER JOIN f_ratelist rl ON rl.ItemID=im.ItemID AND rl.Panel_ID=79 ");
            sb.Append("  and ifnull(rl.Rate,0)>0");
            sb.Append("   WHERE sm.CategoryID='LSHHI3'  ");
            if (Test != "")
            {
                sb.Append(" AND (im.TypeName like @Test or im.Inv_ShortName like @Test) ");
            }
            sb.Append("  AND im.IsActive=1 ORDER BY im.TypeName LIMIT " + offSet + "," + _limit + "; ");//im.IsFavourite DESC,
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@Test", string.Concat("%", Test, "%"))).Tables[0];
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindObservation(string Investigation_Id)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.Investigation_ID,LOM.Name  ObName,LOM.LabObservation_ID  FROM investigation_master im  ");
            sb.Append(" INNER JOIN labobservation_investigation loi ON im.Investigation_Id = loi.Investigation_Id ");
            sb.Append(" INNER JOIN labobservation_master lom ON loi.labObservation_ID = lom.LabObservation_ID ");
            sb.Append(" WHERE im.Investigation_Id  =@Investigation_Id order by lom.Name; ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@Investigation_Id", string.Concat("%", Investigation_Id, "%"))).Tables[0];
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SearchHealthPackage(string CentreGroupID)
    {

        DataTable dt = new DataTable();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (CentreGroupID == "")
            {
                return "[]";
            }
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT IFNULL(NAME,'')NAME,IFNULL(ActualPrice,'')ActualPrice,IFNULL(PackagePrice,'')PackagePrice,IFNULL(ParametersCount,'')ParametersCount,IFNULL(Content,'')Content FROM app_mobile_healthpackage WHERE Isactive=1 AND CentreGroupID= @CentreGroupID  ORDER BY PrintOrder", new MySqlParameter("@CentreGroupID", CentreGroupID)).Tables[0];
            if (dt.Rows.Count > 0)
            {

                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }


    public static string GenderValidation(string title, string gender)
    {
        return gender.ToUpper() == "MALE" ? (title.ToUpper() == "MR." || title.ToUpper() == "BABA." || title.ToUpper() == "DR.") && gender.ToUpper() == "MALE" ? "1" : "Please select Gender accoding to title" : (title.ToUpper() == "MRS." || title.ToUpper() == "BABY." || title.ToUpper() == "MISS." || title.ToUpper() == "DR.") && gender.ToUpper() == "FEMALE" ? "1" : "Please select Gender accoding to title";
    }
    private static string FormatAge(DateTime start, DateTime end)
    {

        // Compute the difference between start 
        //year and end year. 
        int years = end.Year - start.Year;
        int months = 0;
        int days = 0;
        // Check if the last year was a full year.

        if (end < start.AddYears(years) && years != 0)
        {
            --years;
        }
        start = start.AddYears(years);
        // Now we know start <= end and the diff between them

        // is < 1 year. 
        if (start.Year == end.Year)
        {
            months = end.Month - start.Month;

        }
        else
        {

            months = (12 - start.Month) + end.Month;

        }

        // Check if the last month was a full month.

        if (end < start.AddMonths(months) && months != 0)
        {

            --months;

        }

        start = start.AddMonths(months);

        // Now we know that start < end and is within 1 month

        // of each other. 

        days = (end - start).Days;

        string Age = "";

        Age = years.ToString() + " Y " + months.ToString() + " M " + days.ToString() + " D";


        return Age;

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BookAppoinment(string title, string Name, string Mobile, string Email, string Date, string Age, string dob, string Gender, string address, string state, string Investigation, string Base64Image, string ConcactPersonMobile, string AppBook_ByName, string Time, string IsDOB)
    {
        Param param = new Param();
        param.status = false;
        param.message = "";
        param.error = "";
        param.data = "[]";

        string IsValid = GenderValidation(title, Gender);
        if (IsValid != "1")
        {
            param.message = IsValid;
            return GetResult(param);
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        DateTime d = DateTime.Parse(Time.Split('-')[0]);
        string StartTime = Util.GetDateTime(Time.Split('-')[0]).ToString("HH:mm:ss");
        string EndTime = Util.GetDateTime(Time.Split('-')[1]).ToString("HH:mm:ss");

        try
        {

            if (dob == "")
            {
                dob = "0001-01-01";
            }
            string UniqueId = Guid.NewGuid().ToString();
            app_appointment obj = new app_appointment();
            obj.Name_varchar = Util.GetString(Name);
            obj.Mobile_varchar = Util.GetString(Mobile);
            obj.Email_varchar = Util.GetString(Email);
            obj.App_Date_datetime = Util.GetString(Date);

            obj.Insert();

            if (IsDOB == "0")
            {

                Age = Age.Replace(" Y", "0 Y");
                Age = Age.Replace(" M", "0 M");
                Age = Age.Replace(" D", "0 D");
                if (Age.Contains(" Years"))
                {
                    Age = Age.Replace("0 Years", "");
                    Age = Age + " Y 0 M 0 D";
                }
                else if (Age.Contains(" Months"))
                {
                    Age = Age.Replace("0 Months", "");
                    Age = "0 Y " + Age + " M 0 D";
                }
                else if (Age.Contains(" Days"))
                {
                    Age = Age.Replace("0 Days", "");
                    Age = "0 Y 0 M " + Age + " D";
                }
                else
                {
                    Age = Age + " Y 0 M 0 D";
                }

            }
            else
            {
                Age = FormatAge(Util.GetDateTime(dob), DateTime.Now);
            }
            int IsPrescription = 0;
            if (Base64Image != "")
            {
                IsPrescription = 1;
            }
            string appid = StockReports.ExecuteScalar("select max(id) from app_appointment");
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("  update app_appointment set IsPrescription=@IsPrescription ,IsPatientApp=1, ConcactPersonMobile=@ConcactPersonMobile, Age=@Age, ");
            sb.AppendLine(" title=@Title,dob=@dob,address=@address, ");
            sb.AppendLine(" Gender=@Gender, State=@state, UniqueId=@UniqueId ,AppBook_ByName=@AppBook_ByName, ");
            sb.AppendLine(" TimeSlot=@Time,Starttime=TIME_FORMAT(@StartTime,'%h:%i:%s'), ");
            sb.AppendLine(" EndTime=TIME_FORMAT(@EndTime ,'%h:%i:%s')   where id=@appid ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@IsPrescription", Util.GetInt(IsPrescription)),
                     new MySqlParameter("@ConcactPersonMobile", Util.GetString(ConcactPersonMobile)),
                      new MySqlParameter("@Age", Util.GetString(Age)),
                     new MySqlParameter("@dob", Util.GetDateTime(dob).ToString("yyyy-MM-dd")),
                   new MySqlParameter("@Mobile", Util.GetString(Mobile)),
                    new MySqlParameter("@address", Util.GetString(address)),
                   new MySqlParameter("@UniqueId", Util.GetString(UniqueId)),
                   new MySqlParameter("@Title", Util.GetString(title)),
                    new MySqlParameter("@Gender", Util.GetString(Gender)),
                   new MySqlParameter("@AppBook_ByName", Util.GetString(AppBook_ByName)),
                   new MySqlParameter("@state", state),
                     new MySqlParameter("@StartTime", StartTime),
                       new MySqlParameter("@EndTime", EndTime),
                    new MySqlParameter("@Time", Time),
                     new MySqlParameter("@appid", appid)
               );

            StockReports.ExecuteDML(sb.ToString());
            if (Investigation != "")
            {
                foreach (string s in Investigation.Split(','))
                {
                    if (s != "")
                    {
                        string str = "insert into app_appointment_inv(appid,investigationid) value(@appid ,@test)";

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str.ToString(),
                        new MySqlParameter("@appid", Util.GetString(appid)),
                         new MySqlParameter("@test", s)

                       );
                    }
                }

            }
            if (Base64Image != "")
            {
                int a = 1;
                foreach (string im in Base64Image.Split(','))
                {
                    if (im != "")
                    {
                        string MobileNo = Util.GetString(UniqueId);
                        string Drive = HttpContext.Current.Server.MapPath("~/Design/B2CMobile/Prescription/");
                        if (!System.IO.Directory.Exists(Drive))
                            System.IO.Directory.CreateDirectory(Drive);

                        string strPath = Drive + MobileNo + "_" + a.ToString() + ".jpg";
                        string ImgPath = MobileNo + "_" + a.ToString() + ".jpg";
                        byte[] photo = Convert.FromBase64String(Util.GetString(im).Replace(" ", "+"));
                        FileStream fs = new FileStream(strPath, FileMode.OpenOrCreate, FileAccess.Write);
                        BinaryWriter br = new BinaryWriter(fs);
                        br.Write(photo);
                        br.Flush();
                        br.Close();
                        fs.Close();
                        a = a + 1;
                        string strAtt = "INSERT INTO app_appointment_attachment(AppointmentID,UniqueID) VALUES(@appid ,@ImgPath );";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strAtt.ToString(),
                        new MySqlParameter("@appid", Util.GetString(appid)),
                         new MySqlParameter("@ImgPath", ImgPath)

                       );


                    }
                }
            }
            param.status = true;
            param.message = "Successful";

            DataTable dtSMSText = StockReports.GetDataTable(" SELECT REPLACE(REPLACE(REPLACE(SMSTemplate,'<PName>','" + Name + "'),'<AppDate>','" + Util.GetDateTime(Date).ToString("dd-MM-yyyy") + "'),'<SlotTime>','" + Time + "')SMSTemplate, Mobile1, Mobile2, Mobile3 FROM `app_B2C_sms_template` WHERE SMS_Type='New Booking' and IsActive=1; ");
            if (dtSMSText.Rows.Count > 0)
            {

                string[] mobileNos = { "" + Mobile + "", "" + dtSMSText.Rows[0]["Mobile1"] + "", "" + dtSMSText.Rows[0]["Mobile2"] + "", "" + dtSMSText.Rows[0]["Mobile3"] + "" };

                for (int i = 0; i < mobileNos.Length; i++)
                {
                    if (!string.IsNullOrEmpty(mobileNos[i]))
                    {
                        string str = "INSERT INTO sms (MOBILE_NO,SMS_TEXT,IsSend,USerID,EntDate) VALUES(@mobileNos,@dtSMSText,'0','',now())";

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str.ToString(),
                        new MySqlParameter("@mobileNos", mobileNos[i]),
                         new MySqlParameter("@dtSMSText", dtSMSText)

                       );
                    }
                }
            }
            tnx.Commit();
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            tnx.Rollback();

            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        return GetResult(param);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetPatientReportName(string mobileno, string PName, string ItemID, string RegDate)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (mobileno == "")
            {
                return "[]";
            }
            DataTable dt = new DataTable();
            string str = "";
            StringBuilder sb = new StringBuilder();
            sb.AppendLine(@" SELECT CONCAT(Title,pm.PName) NAME,pm.Gender,pm.Age,pli.LedgerTransactionNo LabID,DATE_FORMAT(lt.Date,'%d-%b-%Y') AS DATE,DATE_FORMAT(lt.Date,'%d-%b-%Y') ReportDate,
                         DATE_FORMAT(pli.ApprovedDate,'%I:%i %p') ReportTime,
                         im.Name ReportTitle,pli.Approved Report_Ready ,
                         ROUND(lt.NetAmount-lt.Adjustment) DueAmount,'' TestDetails,
                         (SELECT LabReportPath FROM app_B2c_setting LIMIT 1) LabReportPath,
                         GROUP_CONCAT(DISTINCT pli.test_id) TestIDs
                         FROM patient_labinvestigation_opd pli
                         INNER JOIN `f_ledgertransaction` lt ON pli.`LedgerTransactionNo`=lt.`LedgerTransactionNo`
                         INNER JOIN patient_master pm ON pm.Patient_ID=pli.Patient_ID  ");
            if (PName != "")
            {
                sb.AppendLine(" and pm.PName Like @PName ");
            }
            if (ItemID != "")
            {
                sb.AppendLine(" and pli.ItemID=@ItemID  ");
            }
            if (RegDate != "")
            {
                sb.AppendLine(" and pli.Date=@RegDate  ");
            }
            sb.AppendLine(@"      INNER JOIN investigation_master im ON im.Investigation_Id=pli.Investigation_ID ");
            sb.AppendLine(@"  where lt.`IsCancel`=0 AND mobile<>'' and (pm.Mobile=@mobileno  or pm.Mobile IN (SELECT DISTINCT Mobile FROM app_appointment WHERE ConcactPersonMobile=@ mobileno) OR pm.Mobile IN (SELECT DISTINCT Mobile  FROM app_member WHERE ReferMobileNo=@mobileno )) GROUP BY lt.LedgerTransactionNo ORDER BY lt.date DESC; ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@PName", string.Concat(PName, "%")), new MySqlParameter("@ItemID", ItemID),
                new MySqlParameter("@RegDate", Util.GetDateTime(RegDate).ToString("yyyy-MM-dd")),
            new MySqlParameter("@mobileno", mobileno)).Tables[0];
            if (dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    sb = new StringBuilder();
                    sb.Append(" SELECT pli.test_id, im.Name InvestigationName,IF(pli.Approved='1','Available','Pending')Status,Round(lt.NetAmount-lt.Adjustment) DueAmount ");
                    sb.Append(" FROM patient_labinvestigation_opd pli");
                    sb.Append(" INNER JOIN `f_ledgertransaction` lt ON pli.`LedgerTransactionNo`=lt.`LedgerTransactionNo`");
                    sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID=pli.Patient_ID  ");
                    if (PName != "")
                    {
                        sb.AppendLine(" and pm.PName Like @PName ");
                    }
                    if (ItemID != "")
                    {
                        sb.AppendLine(" and pli.ItemID=@ItemID  ");
                    }
                    if (RegDate != "")
                    {
                        sb.AppendLine(" and pli.Date=@RegDate  ");
                    }
                    sb.AppendLine(@"  INNER JOIN investigation_master im ON im.Investigation_Id=pli.Investigation_ID ");
                    sb.Append(" AND pli.LedgerTransactionNo=@LedgerTransactionNo group by pli.test_id; ");
                    DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@PName", string.Concat(PName, "%")), new MySqlParameter("@ItemID", ItemID),
                    new MySqlParameter("@RegDate", Util.GetDateTime(RegDate).ToString("yyyy-MM-dd")),
                    new MySqlParameter("@LedgerTransactionNo", dt.Rows[i]["LabID"].ToString())).Tables[0];
                    if (dt1.Rows.Count > 0)
                    {
                        dt.Rows[i]["LabReportPath"] = dt.Rows[i]["LabReportPath"].ToString() + dt.Rows[i]["TestIDs"].ToString();
                        dt.Rows[i]["TestDetails"] = Newtonsoft.Json.JsonConvert.SerializeObject(dt1);
                        dt.AcceptChanges();
                    }

                }
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


            }

            else
            {
                return "[]";
            }

        }
        catch (Exception ex)
        {
            return "[]";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetPatientReport(string mobileno)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (mobileno == "")
            {
                return "[]";
            }
            DataTable dt = new DataTable();
            string str = "";
            StringBuilder sb = new StringBuilder();
            sb.AppendLine(@" SELECT CONCAT(Title,pm.PName) NAME,pm.Gender,pm.Age,pli.LedgerTransactionNo LabID,DATE_FORMAT(lt.Date,'%d-%b-%Y') AS DATE,DATE_FORMAT(lt.Date,'%d-%b-%Y') ReportDate,
                         DATE_FORMAT(pli.ApprovedDate,'%I:%i %p') ReportTime,
                         im.Name ReportTitle,pli.Approved Report_Ready ,
                         ROUND(lt.NetAmount-lt.Adjustment) DueAmount,'' TestDetails,
                         (SELECT LabReportPath FROM app_B2c_setting LIMIT 1) LabReportPath,
                         GROUP_CONCAT(DISTINCT pli.test_id) TestIDs
                         FROM patient_labinvestigation_opd pli
                         INNER JOIN `f_ledgertransaction` lt ON pli.`LedgerTransactionNo`=lt.`LedgerTransactionNo`
                         INNER JOIN patient_master pm ON pm.Patient_ID=pli.Patient_ID  
                         INNER JOIN investigation_master im ON im.Investigation_Id=pli.Investigation_ID ");
            sb.AppendLine(@"  where lt.`IsCancel`=0 AND mobile<>'' and (pm.Mobile=@mobileno  or pm.Mobile IN (SELECT DISTINCT Mobile FROM app_appointment WHERE ConcactPersonMobile=@ mobileno) OR pm.Mobile IN (SELECT DISTINCT Mobile  FROM app_member WHERE ReferMobileNo=@mobileno )) GROUP BY lt.LedgerTransactionNo ORDER BY lt.date DESC; ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@mobileno", mobileno)).Tables[0];

            if (dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    sb = new StringBuilder();
                    sb.Append(" SELECT pli.test_id, im.Name InvestigationName,IF(pli.Approved='1','Available','Pending')Status,Round(lt.NetAmount-lt.Adjustment) DueAmount ");
                    sb.Append(" FROM patient_labinvestigation_opd pli");
                    sb.Append(" INNER JOIN `f_ledgertransaction` lt ON pli.`LedgerTransactionNo`=lt.`LedgerTransactionNo`");
                    sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID=pli.Patient_ID  ");
                    sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=pli.Investigation_ID ");
                    sb.Append(" AND pli.LedgerTransactionNo=@LedgerTransactionNo group by pli.test_id; ");
                    DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@LedgerTransactionNo", dt.Rows[i]["LabID"].ToString())).Tables[0];

                    if (dt1.Rows.Count > 0)
                    {
                        dt.Rows[i]["LabReportPath"] = dt.Rows[i]["LabReportPath"].ToString() + dt.Rows[i]["TestIDs"].ToString();
                        dt.Rows[i]["TestDetails"] = Newtonsoft.Json.JsonConvert.SerializeObject(dt1);
                        dt.AcceptChanges();
                    }

                }
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }

            else
            {

                return "[]";
            }

        }
        catch (Exception ex)
        {
            return "[]";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string appointmentHistory(string mobileno, string PageNo, string AppDate, string Status)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (PageNo == "")
            {
                return "[]";
            }
            int offSet = 0;
            int _limit = 25;
            int _PageNo = Util.GetInt(PageNo);
            if (_PageNo > 0)
            {
                offSet = (_PageNo - 1) * _limit;
            }
            if (mobileno == "")
            {
                return "[]";
            }
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT aa.id,aa.Name,aa.Mobile, DATE_FORMAT(aa.App_Date,'%d-%b-%Y') App_Date , ifNULL(aa.Address,'')Address ,DATE_FORMAT(aa.dtEntry,'%d-%b-%Y %r') dtEntry,aa.STATUS `Status`,IF(aa.IsCancel=1,aa.cancelbyname,'')cancelbyname,TIME_FORMAT(aa.StartTime, '%h:%i%p')StartTime,TIME_FORMAT(aa.EndTime, '%h:%i%p')EndTime,aa.TimeSlot,CONCAT(IFNULL(pr.Title,''),' ',IFNULL(pr.proname,'')) ProName,");
            sb.Append(" IFNULL(pr.Mobile,'') ProMobile,Concat('" + url + "B2CMobile/Images/','defaultuser.jpg') ProPhoto FROM app_appointment aa ");
            sb.Append(" LEFT JOIN pro_master pr ON aa.assign_Pro=pr.proid WHERE aa.mobile<>'' AND (aa.Mobile=@mobileno  ");
            sb.Append(" OR aa.Mobile IN (SELECT DISTINCT Mobile FROM `app_member` WHERE ReferMobileNo=@mobileno ) OR aa.`ConcactPersonMobile`=@mobileno ) ");
            if (Status != "")
            {
                sb.Append(" and aa.STATUS=@STATUS ");
            }
            if (AppDate != "")
            {
                sb.Append(" and aa.App_Date=@App_Date ");
            }
            sb.Append(" ORDER BY aa.dtEntry DESC; ");

            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@mobileno", mobileno)
                , new MySqlParameter("@STATUS", Status)
                , new MySqlParameter("@App_Date", Util.GetDateTime(AppDate).ToString("yyyy-MM-dd"))).Tables[0];

            if (dt.Rows.Count > 0)
            {

                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }

            else
            {

                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string historyDetails(string appId)
    {

        try
        {
            if (appId == "")
            {
                return "[]";
            }

            DataTable dt = new DataTable();

            string str = "call app_history_detail('" + appId + "')";
            dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }


    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string deleteAppointment(string id, string Cancelreason, string OtherReason)
    {

        Param param = new Param();
        param.status = false;
        param.message = "";
        param.error = "";
        param.data = "[]";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (MySqlHelper.ExecuteScalar(con, CommandType.Text, " select count(1) from app_appointment where id=@Id ",
                     new MySqlParameter("@Id", Util.GetString(id))).ToString() == "0")
            {
                param.message = "Invalid Appoinment ID";
            }
            else
            {
                string str = "Update app_appointment set status='Cancel',iscancel=1,dtcancel=now(),cancelbyname='SELF From Mobile',cancel_reason=@Cancelreason ,Cancel_ReasonOther=@OtherReason where id=@id";
                StringBuilder sb = new StringBuilder();
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str.ToString(),
                        new MySqlParameter("@Cancelreason", Cancelreason),
                         new MySqlParameter("@OtherReason", Util.GetString(OtherReason)),
                         new MySqlParameter("@id", id)
                   );

                SendSMS(id, "Appointment Cancel");
                param.status = true;
                param.message = "Successful";

            }
            if (id == "")
            {

                param.message = "Invalid Appoinment ID";

            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();

            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        return GetResult(param);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Centres(string PageNo)
    {

        try
        {
            if (PageNo == "")
            {
                return "[]";
            }
            int offSet = 0;
            int _limit = 25;
            int _PageNo = Util.GetInt(PageNo);
            if (_PageNo > 0)
            {
                offSet = (_PageNo - 1) * _limit;
            }
            DataTable dt = new DataTable();
            string str = "";
            str = "SELECT CentreID,IFNULL(Centre,'')Centre, IFNULL(Address,'')Address, IFNULL(mobile,'') Contact FROM centre_master WHERE isActive=1 ORDER BY isDefault DESC,Centre LIMIT " + offSet + "," + _limit + "";
            dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string HealthTips1(string PageNo)
    {
        try
        {
            if (PageNo == "")
            {
                return "[]";
            }
            int offSet = 0;
            int _limit = 25;
            int _PageNo = Util.GetInt(PageNo);
            if (_PageNo > 0)
            {
                offSet = (_PageNo - 1) * _limit;
            }
            DataTable dt = new DataTable();
            string str = "";
            str = "SELECT ID,NAME,IFNULL(TipsContent,'')TipsContent,IFNULL(TipsImage,'')TipsImage  FROM app_mobile_healthtips WHERE IsActive=1 ORDER BY PrintOrder LIMIT " + offSet + "," + _limit + "";
            dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {

                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }

            else
            {

                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string HealthOffer(string PageNo)
    {
        try
        {
            if (PageNo == "")
            {
                return "[]";
            }
            int offSet = 0;
            int _limit = 25;
            int _PageNo = Util.GetInt(PageNo);
            if (_PageNo > 0)
            {
                offSet = (_PageNo - 1) * _limit;
            }
            DataTable dt = new DataTable();
            string str = "";
            str = "SELECT ID,Concat('" + url + "B2CMobile/Images/','',Image)Image FROM app_mobile_healthoffer WHERE IsActive=1 ORDER BY id DESC LIMIT " + offSet + "," + _limit + "";
            dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {

                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }

            else
            {

                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string App_member_InsertNew(string ReferID, string ReferMobileNo, string Title, string Name, string Mobile, string dob, string IsRegistered, string Age, string Gender, string Relation, string Address, string Email, string PinCode, string City, string IsDOB)
    {
        Param param = new Param();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (dob == "")
            {
                dob = "0001-01-01";
            }
            Mobile = ReferMobileNo;
            StringBuilder sb = new StringBuilder();
            sb.AppendLine(" Insert Into App_member (IsDOB,ReferID,ReferMobileNo,Name,Mobile,EntryDate,dob,IsRegistered,Age, ");
            sb.AppendLine(" Gender,Relation,Updatedate,Title,EmailId,PinCode,Address,City) values(@IsDOB, ");
            sb.AppendLine(" @ReferID ,@ReferMobileNo,@Name,@Mobile ,NOW(), ");
            sb.AppendLine(" @dob,@IsRegistered, ");
            sb.AppendLine(" @Age,@Gender ,@Relation ,NOW(),@Title ,@Email, ");
            sb.AppendLine(" @PinCode,@Address,@City) ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@ReferID", ReferID),
                         new MySqlParameter("@ReferMobileNo", ReferMobileNo),
                         new MySqlParameter("@Name", Name),
                         new MySqlParameter("@Mobile", Mobile),
                         new MySqlParameter("@dob", Util.GetDateTime(dob).ToString("yyyy-MM-dd")),
                         new MySqlParameter("@IsRegistered", Util.GetInt(IsRegistered)),
                         new MySqlParameter("@Age", Age),
                         new MySqlParameter("@Gender", Gender),
                         new MySqlParameter("@Relation", Relation),
                         new MySqlParameter("@Title", Title),
                         new MySqlParameter("@Email", Email),
                         new MySqlParameter("@PinCode", PinCode),
                           new MySqlParameter("@Address", Address),
                           new MySqlParameter("@City", City),
                          new MySqlParameter("@IsDOB", Util.GetInt(IsDOB))
                    );

            param.status = true;
            param.message = "Successful Insert";

            tnx.Commit();

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            tnx.Rollback();
            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        return GetResult(param);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string App_member_UpdateNew(string ReferID, string ReferMobileNo, string Title, string Name, string Mobile, string dob, string IsRegistered, string Age, string Gender, string Relation, string Address, string Email, string PinCode, string City, string id, string IsDOB)
    {
        Param param = new Param();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (dob == "")
            {
                dob = "0001-01-01";
            }
            string qry = "Update App_member set ReferID=ReferID,ReferMobileNo=ReferMobileNo,IsDOB=@IsDOB,Name=@Name,Mobile=@Mobile,dob=@dob,IsRegistered=@IsRegistered,Age=@Age,Gender=@Gender,Title=@Title,Address=@Address,EmailId=@EmailId,City=@City,PinCode=@PinCode,Relation=@Relation where id=@id ";

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, qry.ToString(),
                         new MySqlParameter("@ReferID", ReferID),
                         new MySqlParameter("@ReferMobileNo", ReferMobileNo),
                         new MySqlParameter("@Name", Name),
                         new MySqlParameter("@Mobile", Mobile),
                         new MySqlParameter("@dob", Util.GetDateTime(dob).ToString("yyyy-MM-dd")),
                         new MySqlParameter("@IsRegistered", Util.GetInt(IsRegistered)),
                         new MySqlParameter("@Age", Age),
                         new MySqlParameter("@Gender", Gender),
                         new MySqlParameter("@Relation", Relation),
                         new MySqlParameter("@Title", Title),
                         new MySqlParameter("@Email", Email),
                         new MySqlParameter("@PinCode", PinCode),
                           new MySqlParameter("@Address", Address),
                           new MySqlParameter("@City", City),
                          new MySqlParameter("@IsDOB", Util.GetInt(IsDOB)),
                               new MySqlParameter("@id", Util.GetInt(id))
                    );


            param.status = true;
            param.message = "Successful Updated";


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            tnx.Rollback();
            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        return GetResult(param);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string App_member_Select(string Mobile)
    {
        Param param = new Param();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dt = new DataTable();
            string str = "";
            str = "SELECT Name,Mobile,DATE_FORMAT(EntryDate,'%d-%b-%Y %r')EntryDate,IFNULL(DATE_FORMAT(dob,'%d-%b-%Y'),'')dob,IsRegistered,IFNULL(Age,'')Age,ifnull(Gender,'')Gender,ifnull(Relation,'')Relation,Id ,ifnull(Title,'')Title,ifnull(EmailId,'')EmailId,ifnull(PinCode,'')PinCode,ifnull(Address,'')Address,ifnull(City,'')City,IsDOB FROM app_member WHERE IsActive=1 AND ReferMobileNo=@Mobile ORDER BY Mobile ";
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str.ToString(), new MySqlParameter("@Mobile", Mobile)).Tables[0];
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else
            {
                return "[]";
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "1";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        //return GetResult(param);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdatePatientInfo(string name, string dob, string mobileno, string address, string state, string email, string Age, string Gender, string IsDOB)
    {
        Param param = new Param();
        param.status = false;
        param.message = "";
        param.error = "";
        param.data = "[]";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (MySqlHelper.ExecuteScalar(con, CommandType.Text, "   Select count(1) FROM app_register where mobile=@mobileno",
                        new MySqlParameter("@mobileno", Util.GetString(mobileno))).ToString() == "0")
            {

                param.message = "Sorry!! Mobile dose not exits";

            }
            else
            {
                if (dob == "")
                {
                    dob = "0001-01-01";
                }

                string qry = "Update app_register SET Name=@Name, dob=@dob, Mobile=@mobileno,Address=@Address,state=@state,email=@email,Age=@Age ,Gender=@Gender,IsDOB=@IsDOB where Mobile=@mobileno ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, qry.ToString(),
                         new MySqlParameter("@Name", name),
                         new MySqlParameter("@mobileno", mobileno),
                         new MySqlParameter("@dob", Util.GetDateTime(dob).ToString("yyyy-MM-dd")),
                         new MySqlParameter("@Age", Age),
                         new MySqlParameter("@Gender", Gender),
                         new MySqlParameter("@email", email),
                           new MySqlParameter("@Address", address),
                           new MySqlParameter("@state", state),
                          new MySqlParameter("@IsDOB", Util.GetInt(IsDOB))

                    );
                param.status = true;
                param.message = "Successful Updated";

            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();

            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        return GetResult(param);
    }





    #region CommanMethods

    public string GetResult(Param Param)
    {
        return JsonConvert.SerializeObject(Param);

        //DataTable dt = new DataTable();
        //dt.Columns.Add("status");
        //dt.Columns.Add("message");
        //dt.Columns.Add("error");
        //dt.Columns.Add("data");
        //DataRow dw = dt.NewRow();
        //dw["status"] = Param.status;
        //dw["message"] = Param.message;
        //dw["error"] = Param.error;
        //dw["data"] = Param.data;
        //dt.Rows.Add(dw);
        //if (Param.IsArray == "1")
        //    return (Newtonsoft.Json.JsonConvert.SerializeObject(dt)).Replace("[", "").Replace("]", ""); //makejsonoftable(dt, makejson.e_with_square_brackets);

        //else
        //    return (Newtonsoft.Json.JsonConvert.SerializeObject(dt)).Replace("[", "").Replace("]", ""); ;//makejsonoftable(dt, makejson.e_without_square_brackets);

    }
    public string GetResult(ParamData Param)
    {
        return JsonConvert.SerializeObject(Param);

    }
    public string GetResult(MyArray Param)
    {
        return JsonConvert.SerializeObject(Param);

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindTabs()
    {
        try
        {
            DataTable dt = new DataTable();
            string str = "";
            str = "select ID,Title,ordering from app_b2c_tab where isactive=1 ORDER BY ordering";
            dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {

                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }

            else
            {

                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
    }
    //----------------------------- for dynamic content by sonu 22-04-2020------------------

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetPageData()
    {
        try
        {

            DataTable dt = new DataTable();
            string str = "";
            str = "SELECT ID,Color,WelcomeContent as WelcomePageContent,IFNULL(WelcomeText,'')WelcomeText,Concat('" + url + "B2CMobile/Images/','',if(Logo='','default.jpg',Logo))Logo,'ITDOSE INFO SYSTEMS PVT LTD' HeaderText,IsShowPoweredBy,IFNULL(HelpLineNo24x7,'')HelpLineNo24x7 from App_B2C_Setting Limit 1 ";
            dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {

                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }

            else
            {

                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetBanner()
    {
        try
        {

            DataTable dt = new DataTable();
            string str = "";
            str = "SELECT ID,CONCAT('" + url + "B2CMobile/Images/','',if(Image='','default.jpg',Image))Images FROM App_B2C_Banner where IsActive=1 order by ShowOrder ";
            dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }

            else
            {

                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetCity()
    {
        try
        {

            DataTable dt = new DataTable();
            string str = "";
            str = "SELECT Id, City,IsDefault FROM App_b2c_City WHERE IsActive=1 ORDER BY IsDefault DESC,City";
            dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }

            else
            {

                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string DOSReport()
    {

        try
        {

            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append("   SELECT ivm.investigation_id,ivm.Name, ist.SampleTypeName,SampleQty,`SampleRemarks` FROM investigation_master ivm INNER JOIN `investigations_sampletype` ist ON ivm.investigation_id=ist.investigation_id AND ist.isdefault=1 GROUP BY ivm.investigation_id  ");

            dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {

                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }

        //  return GetResult(param);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string HealthTips()
    {
        try
        {
            DataTable dt = new DataTable();
            string str = "";
            str = "SELECT `name`,tipsContent ,Concat('" + url + "B2CMobile/Images/','', if(TipsImage='','default.jpg',TipsImage))TipsImage FROM app_mobile_healthtips ";
            dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }

            else
            {

                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetOffers()
    {
        try
        {

            DataTable dt = new DataTable();
            string str = "";
            str = "SELECT * FROM app_offer order by id desc limit 1 ";
            dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }

            else
            {

                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string titleDetail()
    {

        try
        {
            DataTable dt = new DataTable();
            string str = "";
            str = "SELECT ID,Title,Gender FROM title_gender_master where IsActive=1 order by ShowOrder ";
            dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string AboutUsImages()
    {
        try
        {
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT ID,ButtomText,Concat('" + url + "B2CMobile/Images/','',HeaderImage)HeaderImage,IF(IsActive=1,'Yes','No') IsActive,DATE_FORMAT(EntryDateTime,'%d-%b-%y %I:%i %p') Entrydate FROM app_B2c_aboutus_image ORDER BY PrintOrder ");
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string AboutUsContent()
    {
        try
        {
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT ID,IFNULL(HeaderText,'')HeaderText,IFNULL(Content,'')Content,IF(IsActive=1,'Yes','No') IsActive,DATE_FORMAT(EntryDateTime,'%d-%b-%y %I:%i %p') Entrydate,'' AmoutUsImages,'' ButtomText  FROM app_b2c_aboutus_content Where IsActive=1 ORDER BY PrintOrder ");

            if (dt.Rows.Count > 0)
            {

                DataTable dt1 = StockReports.GetDataTable("SELECT ID,ButtomText,Concat('" + url + "B2CMobile/Images/','',if(HeaderImage='','default.jpg',HeaderImage))HeaderImage FROM app_B2c_aboutus_image Where IsActive=1 ORDER BY PrintOrder ");
                if (dt1.Rows.Count > 0)
                {
                    dt.Rows[0]["AmoutUsImages"] = dt1.Rows[0]["HeaderImage"].ToString();
                    dt.Rows[0]["ButtomText"] = dt1.Rows[0]["ButtomText"].ToString();
                    dt.AcceptChanges();
                }
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SearchHelpdata()
    {

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ID,IFNULL(HeaderText,'') as HelpQuery from app_mobile_help Where IsActive=1 ");
            sb.Append("  ORDER BY PrintOrder ASC ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            return "[]";
        }


    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetCentreLocator()
    {

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT  CentreID,Centre,IFNULL(GeoLocation,'')GeoLocation,IFNULL(WhatsAppNo,'')WhatsAppNo,IFNULL(Mobile,'')Mobile,IFNULL(AllowApp,'')AllowApp,IFNULL(Latitude,'')Latitude,IFNULL(Longitude,'')Longitude FROM centre_master Where IsActive=1  and AllowApp=1");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            return "[]";
        }


    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetTimeSlot()
    {
        Param param = new Param();
        try
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(@" SELECT  CONCAT(TIME_FORMAT(StartTime, '%h:%i%p'),'-',TIME_FORMAT(EndTime, '%h:%i%p'))TimeSlot,IFNULL(AvgTimeMin,'')AvgTimeMin FROM app_b2c_slot_master group by StartTime; ");
            dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }


    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetCancelReason()
    {

        try
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(@" SELECT ID,CancelReason FROM App_b2c_CancelReason_master Where IsActive=1; ");
            dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }


    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetPulseRate(string UserId)
    {
        Param param = new Param();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            string str = "SELECT  Id, PulseRate,DATE_FORMAT(MeasureDate,'%W %M %e %Y')MeasureDate FROM app_B2C_HeartRate WHERE UserId=@UserId  order by entryDate desc; ";
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str.ToString(), new MySqlParameter("@UserId", UserId)).Tables[0];
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string AddPulseRate(string PulseRate, string MeasureDate, string MeasureTime, string PatientName, string UserId)
    {
        Param param = new Param();
        param.status = false;
        param.message = "";
        param.error = "";
        param.data = "[]";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Time = Util.GetDateTime(MeasureTime).ToString("HH:mm:ss");
            string str = "INSERT INTO app_B2C_HeartRate (PulseRate,MeasureDate,MeasureTime,PatientName,UserId,EntryDate)Values(@PulseRate,@MeasureDate,TIME_FORMAT(@Time,'%h:%i:%s'),@PatientName,@UserId,now())";
            int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str.ToString(),
                          new MySqlParameter("@PulseRate", PulseRate),
                          new MySqlParameter("@MeasureDate", Util.GetDateTime(MeasureDate).ToString("yyyy-MM-dd HH:mm:ss")),
                          new MySqlParameter("@Time", Time),
                          new MySqlParameter("@PatientName", PatientName),
                          new MySqlParameter("@UserId", UserId)

                     );
            if (a == 1)
            {
                param.status = true;
                param.message = "Successful";

            }
            else
            {

                param.message = "No Data Found";

            }

            tnx.Commit();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();

            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        return GetResult(param);


    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string AddHelpRequest(string HelpId, string Message, string Name, string EmailId, string MobileNo, string UserId)
    {
        Param param = new Param();
        param.status = false;
        param.message = "";
        param.error = "";
        param.data = "[]";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string chars = "0123456789ABCDEFGHIJKLMNOPQRST";
            char[] stringChars = new char[6];
            Random random = new Random();

            for (int i = 0; i < stringChars.Length; i++)
            {
                stringChars[i] = chars[random.Next(chars.Length)];
            }

            string TicketNo = "H-" + new String(stringChars);

            string str = "INSERT INTO App_B2C_HelpDetails (HelpId,Message,Name,EmailId,MobileNo,TicketNo,QueryById,EntryDate)VALUES(@HelpId ,@Message,@Name ,@EmailId,@MobileNo,@TicketNo ,@UserId,now());";

            int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str.ToString(),
                          new MySqlParameter("@HelpId", HelpId),
                          new MySqlParameter("@Message", Message),
                          new MySqlParameter("@Name", Name),
                          new MySqlParameter("@EmailId", EmailId),
                          new MySqlParameter("@MobileNo", TicketNo),
                           new MySqlParameter("@UserId", Util.GetInt(UserId))

                     );
            if (a == 1)
            {
                param.status = true;
                param.message = "Successful";

            }
            else
            {

                param.message = "No Data Found";

            }

            tnx.Commit();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();

            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        return GetResult(param);


    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SubmitAddressDetails(string PinCode, string HouseNo_BulidingName, string AreaColony, string City, string State, string Landmark, string UserID)
    {
        Param param = new Param();
        param.status = false;
        param.message = "";
        param.error = "";
        param.data = "[]";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.AppendLine(" Insert Into App_B2C_AddressDetails (PinCode,HouseNo_BulidingName,AreaColony,City,State,Landmark,UserID,EntryDate )");
            sb.AppendLine("  values(@PinCode,@HouseNo_BulidingName,@AreaColony,@City,@State,@Landmark,@UserID,NOW()); ");
            int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@PinCode", Util.GetString(PinCode)),
                         new MySqlParameter("@HouseNo_BulidingName", Util.GetString(HouseNo_BulidingName)),
                         new MySqlParameter("@AreaColony", AreaColony),
                         new MySqlParameter("@City", City),
                         new MySqlParameter("@State", State),
                          new MySqlParameter("@Landmark", Landmark),
                          new MySqlParameter("@UserID", UserID)

                    );
            StockReports.ExecuteDML(sb.ToString());
            param.status = true;
            param.message = "Successful Insert";

            tnx.Commit();

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        return GetResult(param);
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateAddressDetails(string ID, string PinCode, string HouseNo_BulidingName, string AreaColony, string City, string State, string Landmark, string UserID)
    {
        Param param = new Param();
        param.status = false;
        param.message = "";
        param.error = "";
        param.data = "[]";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update App_B2C_AddressDetails set PinCode=@PinCode ,HouseNo_BulidingName=@HouseNo_BulidingName,AreaColony=@AreaColony,City=@City ,State=@State,Landmark=@Landmark,UpdateDate=NOW(),UpdatedBy=@UserID where id=@ID  ");

            int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@PinCode", Util.GetString(PinCode)),
                       new MySqlParameter("@HouseNo_BulidingName", Util.GetString(HouseNo_BulidingName)),
                       new MySqlParameter("@AreaColony", AreaColony),
                       new MySqlParameter("@City", City),
                       new MySqlParameter("@State", State),
                        new MySqlParameter("@Landmark", Landmark),
                        new MySqlParameter("@UserID", UserID),
                         new MySqlParameter("@ID", ID)

                  );
            param.status = true;
            param.message = "Details Updated Successfully";

            tnx.Commit();
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        return GetResult(param);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetAddressDetails(string UserId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(@" SELECT ID, IFNULL(PinCode,'')PinCode,IFNULL(HouseNo_BulidingName,'')HouseNo_BulidingName,IFNULL(AreaColony,'')AreaColony,IFNULL(City,'')City,IFNULL(State,'')State,IFNULL(Landmark,'')Landmark,DATE_FORMAT(EntryDate,'%a,%d%b %Y %I:%i%p')EntryDate FROM App_B2C_AddressDetails WHERE IsActive=1 AND UserId=@UserId; ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@UserId", UserId)).Tables[0];
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string AddHealthRecord(string UserId, string MemberId, string DocumentType, string Base64Image)
    {
        Param param = new Param();
        param.status = false;
        param.message = "";
        param.error = "";
        param.data = "[]";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (Base64Image != "")
            {
                int a = 1;
                foreach (string im in Base64Image.Split(','))
                {
                    string imagepath = "";

                    string UniqueId = Guid.NewGuid().ToString();
                    if (im != "")
                    {

                        string MobileNo = Util.GetString(UniqueId);
                        string Drive = HttpContext.Current.Server.MapPath("~/Design/B2CMobile/Images/HealthRecord/");
                        if (!System.IO.Directory.Exists(Drive))
                            System.IO.Directory.CreateDirectory(Drive);
                        string strPath = Drive + MobileNo + "_" + a.ToString() + ".jpg";
                        imagepath = MobileNo + "_" + a.ToString() + ".jpg";
                        byte[] photo = Convert.FromBase64String(Util.GetString(im).Replace(" ", "+"));
                        FileStream fs = new FileStream(strPath, FileMode.OpenOrCreate, FileAccess.Write);
                        BinaryWriter br = new BinaryWriter(fs);
                        br.Write(photo);
                        br.Flush();
                        br.Close();
                        fs.Close();
                        a = a + 1;
                        StringBuilder sb = new StringBuilder();
                        sb.AppendLine(" Insert Into App_B2C_HealthRecords (UserId,MemberId,DocumentType,ImagePath,EntryDate )");
                        sb.AppendLine("  values(@UserId,@MemberId,@DocumentType,@imagepath ,NOW()) ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@UserId", Util.GetInt(UserId)),
                    new MySqlParameter("@MemberId", Util.GetInt(MemberId)),
                    new MySqlParameter("@DocumentType", DocumentType),
                    new MySqlParameter("@imagepath", imagepath)

               );
                        StockReports.ExecuteDML(sb.ToString());
                    }
                }
            }

            param.status = true;
            param.message = "Health Record Added Successfully";

            tnx.Commit();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();

            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        return GetResult(param);

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetHealthRecord(string UserId, string DocumentType, string MemberId)
    {
        Param param = new Param();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(@"  SELECT ID, UserId,MemberId,DocumentType,Concat('" + url + "B2CMobile/Images/HealthRecord/','',IF(ImagePath='','default.jpg',ImagePath))ImagePath,DATE_FORMAT(EntryDate,'%a,%d%b %Y %I:%i%p')EntryDate FROM App_B2C_HealthRecords Where UserId=UserId  ");
            if (DocumentType != "all_record")
            {
                sb.Append(" AND DocumentType=@DocumentType  ");
            }
            if (MemberId != "0")
            {
                sb.Append(" and MemberId=@MemberId  ");
            }
            sb.Append(" ORDER BY EntryDate DESC ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@DocumentType", DocumentType), new MySqlParameter("@UserId", UserId), new MySqlParameter("@MemberId", MemberId)).Tables[0];

            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetState()
    {

        try
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(@"  SELECT ID, State FROM State_Master ORDER BY State ");
            dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }


    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string AddSugarLeveDetails(string Event, string BloodSugarLevel, string Date, string MeasureTime, string MemberId, string UserId)
    {
        Param param = new Param();
        param.status = false;
        param.message = "";
        param.error = "";
        param.data = "[]";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Time = Util.GetDateTime(MeasureTime).ToString("HH:mm:ss");
            StringBuilder sb = new StringBuilder();
            string str = "INSERT INTO App_B2C_SugarLevelDetails (Event,BloodSugarLevel,Date,Time,UserId,MemberId,EntryDate)VALUES(@Event,@BloodSugarLevel,@Date,TIME_FORMAT(@Time ,'%h:%i:%s'),@UserId,@MemberId,now());";
            int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str.ToString(),
                        new MySqlParameter("@Event", Event),
                        new MySqlParameter("@BloodSugarLevel", BloodSugarLevel),
                        new MySqlParameter("@Date", Util.GetDateTime(Date).ToString("yyyy-MM-dd HH:mm:ss")),
                        new MySqlParameter("@Time", Time),
                        new MySqlParameter("@UserId", UserId),
                        new MySqlParameter("@MemberId", Util.GetInt(MemberId)));

            if (a == 1)
            {
                param.status = true;
                param.message = "Sugar Details Added Successful";

            }
            else
            {

                param.message = "No Data Found";

            }

            tnx.Commit();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();

            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        return GetResult(param);

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetSugarLevelHistory(string UserId, string MemberId)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(@" SELECT  Id, Event,BloodSugarLevel,DATE_FORMAT(DATE,'%d %M %Y')DATE,TIME_FORMAT(Time, '%h:%i%p')Time FROM App_B2C_SugarLevelDetails WHERE UserId=@UserId AND MemberId =@MemberId order by Event,Date desc,TIME DESC; ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@UserId", UserId), new MySqlParameter("@MemberId", MemberId)).Tables[0];
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetBloodPressureHistory(string UserId, string MemberId)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(@" SELECT  Id, IFNULL(SystolicValue,'')SystolicValue,IFNULL(diastolicValue,'')diastolicValue,ifnull(pulseCount,'')pulseCount,DATE_FORMAT(DATE,'%e %M %Y')DATE,TIME_FORMAT(Time, '%h:%i%p')Time FROM app_b2c_BloodPressure WHERE UserId=@UserId AND MemberId =@MemberId   order by Date desc; ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@UserId", UserId), new MySqlParameter("@MemberId", MemberId)).Tables[0];
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "[]";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string AddBloodPressureDetails(string SystolicValue, string PulseCount, string BloodSugarLevel, string Date, string MeasureTime, string MemberId, string UserId)
    {
        Param param = new Param();
        param.status = false;
        param.message = "";
        param.error = "";
        param.data = "[]";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Time = Util.GetDateTime(MeasureTime).ToString("HH:mm:ss");
            StringBuilder sb = new StringBuilder();
            string str = @"INSERT INTO app_b2c_BloodPressure(SystolicValue,diastolicValue,pulseCount,Date,Time,UserId,MemberId,EntryDate)            
                           VALUES(@SystolicValue ,@PulseCount,@BloodSugarLevel, Date,TIME_FORMAT(@Time ,'%h:%i:%s'),@UserId,@MemberId,now());";

            int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str.ToString(),
                        new MySqlParameter("@SystolicValue", SystolicValue),
                        new MySqlParameter("@PulseCount", PulseCount),
                        new MySqlParameter("@BloodSugarLevel", BloodSugarLevel),
                        new MySqlParameter("@Date", Util.GetDateTime(Date).ToString("yyyy-MM-dd HH:mm:ss")),
                        new MySqlParameter("@Time", Time),
                        new MySqlParameter("@UserId", UserId),
                        new MySqlParameter("@MemberId", Util.GetInt(MemberId)));

            if (a == 1)
            {
                param.status = true;
                param.message = "Blood Pressure Details Added Successfully";
            }
            else
            {
                param.message = "No Data Found";
            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            param.message = "There are some techinal issue";
            param.error = ex.Message.ToString();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        return GetResult(param);


    }
    private bool SendSMS(string Appid, string Type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT Mobile,Name from app_appointment Where id=@Appid;", new MySqlParameter("@Appid", Appid)).Tables[0];
            string SMSText = StockReports.ExecuteScalar(" SELECT REPLACE(REPLACE(SMSTemplate,'<NAME>','" + dt.Rows[0]["Name"].ToString() + "'),'<DATE>','" + Util.GetDateTime(DateTime.Now).ToString("dd-MM-yyyy HH:mm:ss tt") + "')SMSTemplate FROM `sms_template` WHERE SMS_Type='" + Type + "'; ").ToString();
            StockReports.ExecuteDML("INSERT INTO sms (MOBILE_NO,SMS_TEXT,IsSend,USerID,EntDate) VALUES('" + dt.Rows[0]["Mobile"].ToString() + "','" + SMSText + "','0','',now())");
            return true;
        }
        catch (Exception)
        {
            return false;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public class Param
    {
        #region All Memory Variables
        private bool _status;
        private string _message;
        private string _error;
        private string _data;
        #endregion
        #region Set All Property
        public virtual bool status
        {
            get
            {
                return _status;
            }
            set
            {
                _status = value;
            }
        }
        public virtual string message
        {
            get
            {
                return _message;
            }
            set
            {
                _message = value;
            }
        }
        public virtual string error
        {
            get
            {
                return _error;
            }
            set
            {
                _error = value;
            }
        }

        public virtual string data
        {
            get
            {
                return _data;
            }
            set
            {
                _data = value;
            }
        }


        #endregion
    }
    #endregion

    public class ParamData
    {
        #region Set All Property
        public bool status { get; set; }
        public string message { get; set; }
        public string error { get; set; }
        public string data { get; set; }
        public string UserPin { get; set; }
        public int IsPinActive { get; set; }
        public string OTP { get; set; }
        #endregion
    }


    public class MyArray
    {
        public string message { get; set; }
        public string status { get; set; }
        public int ID { get; set; }
        public string NAME { get; set; }
        public string Mobile { get; set; }
        public string Address { get; set; }
        public string email { get; set; }
        public string dob { get; set; }
        public string entrydate { get; set; }
        public string Title { get; set; }
        public string Gender { get; set; }
        public string Age { get; set; }
        public string PinCode { get; set; }
        public int IsDOB { get; set; }
        public string UserPin { get; set; }
        public string City { get; set; }
    }


}
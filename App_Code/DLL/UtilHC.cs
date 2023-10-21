using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Web;
using cfg = System.Configuration.ConfigurationManager;

public sealed class UtilHC
{
    public UtilHC()
    {
    }

    public static string GetConString()
    {
        try
        {
            return "server=localhost;user id=root;  password=123456;database=uat_ver2_homecollection;port=3306; pooling=false;Respect Binary Flags=false;Allow Zero Datetime=true;Allow User Variables=True;";
        }
        catch (Exception ex)
        {
            return "";
            // return "server=ahllinstance.ckvwbt1syjaf.ap-south-1.rds.amazonaws.com;user id=itdose;  password=Login#321;database=itdoselab;port=3306; pooling=false;Respect Binary Flags=false;Allow Zero Datetime=true;".ToString();
        }
       
    }

    public static string SiteId()
    {
        return cfg.AppSettings["SiteId"];
    }

    public static string MailData(string FileName)
    {
        StreamReader stLimit;
        stLimit = File.OpenText(AppDomain.CurrentDomain.BaseDirectory + "/Templates/Email/" + FileName);
        string limitText = stLimit.ReadToEnd();
        stLimit.Close();

        return limitText;
    }

    public static string getApp(string KeyID)
    {
        return cfg.AppSettings[KeyID];
    }

    public static MySqlConnection GetMySqlCon()
    {
        MySqlConnection objCon = new MySqlConnection(GetConString());
        return objCon;
    }

    public static string getHash()
    {
        string hash = Util.GetString(System.Guid.NewGuid()) + "" + DateTime.Now.ToString("MMddyyyyHHmmss");
        return hash;
    }

    public static string GetParamaterString(params string[] strParam)
    {
        #region GetParamaterString

        try
        {
            string strParamValue = "";

            for (int i = strParam.GetLowerBound(0); i <= strParam.GetUpperBound(0); i++)
            {
                if (i % 2 == 0)
                {
                    strParamValue = strParamValue + strParam.GetValue(i).ToString() + "=";
                }
                else
                {
                    strParamValue = strParamValue + strParam.GetValue(i).ToString() + ",";
                }
            }

            if (strParamValue.Length > 0)
            {
                strParamValue = strParamValue.Substring(0, strParamValue.Length - 1);
            }
            return strParamValue;
        }
        catch
        {
            return "";
        }

        #endregion GetParamaterString
    }

    #region Handle Is DbNull

    public static int GetInt(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return 0;
        else
            return int.Parse(obj.ToString());
    }

    public static Int16 GetShortInt(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return 0;
        else
            return Int16.Parse(obj.ToString());
    }

    public static long GetLong(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return 0;
        else
            return long.Parse(obj.ToString());
    }

    public static decimal GetDecimal(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return 0;
        else
            return Decimal.Parse(obj.ToString());
    }

    public static float GetFloat(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return 0F;
        else
            return float.Parse(obj.ToString());
    }

    public static double GetDouble(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return 0;
        else
            return double.Parse(obj.ToString());
    }

    public static DateTime GetDateTime(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return Util.GetMinDateTime();
        else
            return DateTime.Parse(obj.ToString());
    }

    public static string GetString(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return "";
        else
        {
            return obj.ToString().Replace("'", "").Replace('"', ' ').Replace("\n", " ").Replace("\t", " ").Replace("\r", " ").Replace(Environment.NewLine, " ");
        }
    }

    public static string GetStringWithoutReplace(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return "";
        else
        {
            return obj.ToString();
        }
    }

    public static bool GetBoolean(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return false;
        else
            return bool.Parse(obj.ToString());
    }

    #endregion Handle Is DbNull

    public static DateTime GetMinDateTime()
    {
        return DateTime.Parse("01/jan/0001");
    }

    public static int DateDiff(DateTime MaxDate, DateTime MinDate)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string sql = "select datediff('" + MaxDate.ToString("yyyy-MM-dd") + "','" + MinDate.ToString("yyyy-MM-dd") + "') day ";
        string day = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sql));

        con.Close();
        con.Dispose();

        if (day != "")
        {
            return int.Parse(day);
        }
        else
        {
            return 0;
        }
    }

    public static int TimeDiffInMin(DateTime StartTime, DateTime EndTime)
    {
        TimeSpan ts = EndTime.Subtract(StartTime);
        int hours = ts.Hours;
        int TotalMin = (hours * 60) + ts.Minutes;
        return TotalMin;
    }

    public static string Promapping()
    {
        return cfg.AppSettings["PROMapping"];
    }

    public static string Membershipoption()
    {
        return cfg.AppSettings["MemberShipCard"];
    }

    public static string Appointment()
    {
        return cfg.AppSettings["Appointment"];
    }

    public static string getOTP
    {
        get
        {
            return new Random().Next(123456, 1000000).ToString("D6");
        }
    }
    public static string getJson(Object obj)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(obj);
    }
    public static MySqlConnection GetMySqlConRedOnly()
    {
        using (MySqlConnection objCon = new MySqlConnection(GetConStringRedOnly()))
            return objCon;
    }
    public static string GetConStringRedOnly()
    {
        try
        {

            return cfg.AppSettings["ConnectionStringRedOnly"].ToString();
        }
        catch (Exception ex)
        {
            return cfg.AppSettings["ConnectionString"].ToString();
        }
    }
}
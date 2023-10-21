using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Web;
using cfg = System.Configuration.ConfigurationManager;

public sealed class Util
{

    public static string GetConString()
    {
        /*string _Con =
        try
        {
            if (HttpContext.Current.Session["DB"] == null)
            {
                return _Con.Replace("#","itdose_uat_6_e");
            }
            else
            {
                return _Con.Replace("#", HttpContext.Current.Session["DB"].ToString());
				
            }
        }
        catch
        {
            return _Con.Replace("#","itdose_uat_6_e");
        }*/
        return "server=localhost;user id=root;  password=123456;database=uat_ver2;port=3306; pooling=false;Respect Binary Flags=false;Allow Zero Datetime=true;Allow User Variables=True;";

      //  return "server=localhost;user id=root;  password=vaseem123;database=uat_ver2;port=3333; pooling=false;Respect Binary Flags=false;Allow Zero Datetime=true;Allow User Variables=True;";
    }
    public static string CCpanelchanges(string id)
    {
        return "panel_id in (SELECT panelid FROM centre_panel WHERE CentreId IN (SELECT BusinessUnitID FROM f_panel_master WHERE employeeID='" + HttpContext.Current.Session["ID"].ToString() + "' )) ";
    }
     public static string GetInvoicePanelQuery_Credit()
    {
        if (UserInfo.IsSalesTeamMember == 0)
        {
            
            if (Util.GetString(HttpContext.Current.Session["LoginType"]) == "PCC" || Util.GetString(HttpContext.Current.Session["LoginType"]) == "SUBPCC")
            {
                if (UserInfo.Centre == 1)
                {
                    return "SELECT distinct CONCAT(pm.`Company_Name`,' [',pm.`Panel_ID`,']') Company_Name, pm.`Panel_ID` Panel_ID FROM f_panel_master pm WHERE pm.isActive = 1  AND (pm.`Panel_ID` IN (SELECT panel_id FROM f_panel_master WHERE employeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ) OR pm.`Panel_ID` IN (SELECT panel_id FROM f_panel_master WHERE invoiceto IN (SELECT panel_id FROM f_panel_master WHERE employeeID='" + HttpContext.Current.Session["ID"].ToString() + "' )))  AND pm.`Panel_ID`=pm.`InvoiceTo` AND pm.Payment_mode='Credit'   ORDER BY Company_Name";

                }
                else
                {
                    return "SELECT distinct CONCAT(pm.`Company_Name`,' [',pm.`Panel_ID`,']') Company_Name,pm.`Panel_ID` Panel_ID FROM  f_panel_master pm INNER JOIN `centre_panel` cp ON pm.`Panel_ID` = cp.`PanelId` WHERE pm.isActive = 1  AND (pm.`Panel_ID` IN (SELECT panel_id FROM f_panel_master WHERE employeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ) OR pm.`Panel_ID` IN (SELECT panel_id FROM f_panel_master WHERE invoiceto IN (SELECT panel_id FROM f_panel_master WHERE employeeID='" + HttpContext.Current.Session["ID"].ToString() + "' )))  AND pm.`Panel_ID`=pm.`InvoiceTo`  AND cp.centreid='" + UserInfo.Centre + "' AND pm.Payment_mode='Credit'  ORDER BY Company_Name";

                }
            }
            else
            {
                if (UserInfo.Centre==1)
                {
                    return "SELECT distinct CONCAT(pm.`Company_Name`,' [',pm.`Panel_ID`,']') Company_Name, pm.`Panel_ID` Panel_ID FROM f_panel_master pm WHERE pm.isActive = 1 AND pm.`Panel_ID`=pm.`InvoiceTo` AND pm.Payment_mode='Credit' ORDER BY Company_Name";
                }
                else
                {
                    return "SELECT distinct CONCAT(pm.`Company_Name`,' [',pm.`Panel_ID`,']') Company_Name,pm.`Panel_ID` Panel_ID FROM  f_panel_master pm INNER JOIN `centre_panel` cp ON pm.`Panel_ID` = cp.`PanelId` WHERE pm.isActive = 1 AND  pm.`Panel_ID`=pm.`InvoiceTo`   AND cp.centreid='" + UserInfo.Centre + "' AND pm.Payment_mode='Credit' ORDER BY Company_Name";

                }
            }
        }
        else
        {
            string _TeamMember = "'" + UserInfo.AccessPROIDs + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
            return "SELECT CONCAT(pm.`Company_Name`,' [',pm.`Panel_ID`,']') Company_Name,pm.`Panel_ID` Panel_ID FROM  f_panel_master pm WHERE pm.isActive = 1 AND  pm.`Panel_ID`=pm.`InvoiceTo`  AND pm.Payment_mode='Credit'  ORDER BY pm.Company_Name";
        }

    }



    
    public static string GetCentreAccessQuery()
    {
        if (UserInfo.IsSalesTeamMember == 0)
        {
          //  if (HttpContext.Current.Session["IsClient"].ToString() == "Yes" || HttpContext.Current.Session["IsSubClient"].ToString() == "Yes")
          //  {
                // return "SELECT DISTINCT cm.CentreID,CONCAT(cm.Centre,' [',cm.CentreID,'] ') AS Centre FROM centre_master cm WHERE ( cm.CentreID IN (SELECT CentreAccess FROM centre_access WHERE CentreID ='" + UserInfo.Centre + "' AND AccessType=2 ) OR cm.CentreID = '" + UserInfo.Centre + "') AND cm.isActive=1  AND cm.CentreID IN (SELECT BusinessUnitID FROM f_panel_master WHERE employeeID='" + HttpContext.Current.Session["ID"].ToString() + "' )   ORDER BY cm.Centre";
                return "SELECT Distinct  cm.CentreID,Centre FROM centre_master cm  INNER JOIN f_login fl ON cm.`CentreID`=fl.`CentreID` WHERE fl.`EmployeeID`='" + HttpContext.Current.Session["ID"].ToString() + "' AND fl.Active=1 AND cm.isActive=1 and ( cm.CentreID  ='" + UserInfo.Centre + "') and cm.isActive=1 order by cm.CentreCode";
           // }
          //  else
          //  {
          //      return "SELECT DISTINCT cm.CentreID,CONCAT(cm.Centre,' [',cm.CentreID,'] ') AS Centre FROM centre_master cm WHERE ( cm.CentreID IN (SELECT CentreAccess FROM centre_access WHERE CentreID ='" + UserInfo.Centre + "' ) OR cm.CentreID = '" + UserInfo.Centre + "') AND cm.isActive=1  ORDER BY cm.Centre";
          //  }
        }
        else
        {
            string _TeamMember = "'" + UserInfo.AccessPROIDs + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
            return " SELECT DISTINCT cm.CentreID,CONCAT(cm.Centre,' [',cm.CentreID,'] ') AS Centre FROM centre_master cm WHERE ( cm.CentreID IN ( SELECT DISTINCT BusinessUnitID FROM f_panel_master pm WHERE pm.isActive = 1 AND pm.SalesManagerID IN (" + _TeamMember + ") )) AND cm.isActive=1  ORDER BY cm.Centre";
        }
    }
 public static string GetSalesManagerQuery()
    {

        if (UserInfo.AccessPROIDs != "")
        {
            string _TeamMember = "'" + UserInfo.AccessPROIDs + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
            return "SELECT ProId,ProName,Designation as Designation FROM salesteam_master where ProId IN (" + _TeamMember + ");";
        }
        else
        {
            return "SELECT ProId,ProName,Designation as Designation FROM salesteam_master ;";
        }
    }
    public static string SiteId()
    {
        return cfg.AppSettings["SiteId"];
    }

    public static string MailData(string FileName)
    {
        StreamReader stLimit = File.OpenText(string.Format("{0}/Templates/Email/{1}", AppDomain.CurrentDomain.BaseDirectory, FileName));
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
        string hash = string.Format("{0}{1:MMddyyyyHHmmss}", Util.GetString(System.Guid.NewGuid()), DateTime.Now);
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
                    strParamValue = string.Format("{0}{1}=", strParamValue, strParam.GetValue(i));
                }
                else
                {
                    strParamValue = string.Format("{0}{1},", strParamValue, strParam.GetValue(i));
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
            return obj.ToString().Replace("'", "").Replace('"', ' ').Replace("\n", "").Replace("\r", "").Replace(Environment.NewLine, "");
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

        string sql = string.Format("select datediff('{0:yyyy-MM-dd}','{1:yyyy-MM-dd}') day ", MaxDate, MinDate);
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

    public static string DateDiffPatientsearch(DateTime MaxDate, DateTime MinDate)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string sql = string.Format("select datediff('{0:yyyy-MM-dd}','{1:yyyy-MM-dd}') day ", MaxDate, MinDate);
        string day = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sql));

        con.Close();
        con.Dispose();

        if (day != "")
        {
            if (int.Parse(day) > 7)
            {
                return "true";
                //true
            }
            else
            {
                return "false";
            }
        }
        else
        {
            return "false";
        }
    }
    public static string DateDiffReportSearch(DateTime MaxDate, DateTime MinDate)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string sql = string.Format("select datediff('{0:yyyy-MM-dd}','{1:yyyy-MM-dd}') day ", MaxDate, MinDate);
        string day = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sql));

        con.Close();
        con.Dispose();

        if (day != "")
        {
            if (int.Parse(day) > 32)
            {
                return "true";
                //true
            }
            else
            {
                return "false";
            }
        }
        else
        {
            return "false";
        }
    }

    public static string RolePermission(string Roleid, string permissiontype,string Labno)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

         string value = "";
         value = StockReports.ExecuteScalar("SELECT IF ((TIMESTAMPDIFF(MINUTE,DATE,NOW())<(SELECT DISTINCT(" + permissiontype + ") FROM f_rolemaster WHERE id='" + Roleid + "')),0,1)AS permission FROM f_ledgertransaction WHERE LedgerTransactionNo = '" + Labno + "'");       
        con.Close();
        con.Dispose();

        if (value != "")
        {
            if (int.Parse(value) > 0)
            {
                return "true";
                //true
            }
            else
            {
                return "false";
            }
        }
        else
        {
            return "false";
        }
    }
    public static int TimeDiffInMin(DateTime StartTime, DateTime EndTime)
    {
        TimeSpan ts = EndTime.Subtract(StartTime);
        int hours = ts.Hours;
        int TotalMin = (hours * 60) + ts.Minutes;
        return TotalMin;
    }
 public static int getbooleanInt(bool obj)
    {
        if (obj == true)
            return 1;
        else
            return 0;
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
    public static Byte GetByte(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return 0;
        else
            return Byte.Parse(obj.ToString());
    }
    public static SByte GetSByte(Object obj)
    {
        if (obj == null || Convert.IsDBNull(obj) || obj.ToString().Trim() == string.Empty)
            return 0;
        else
            return SByte.Parse(obj.ToString());
    }

    public static void WriteAllText(String qName, Object obj)
    {
        FileStream fs;
        StreamWriter sw;
        string str = AppDomain.CurrentDomain.BaseDirectory + "ErrorLog\\";

        if (System.IO.File.Exists(str + qName + ".txt"))
        {
            File.Delete(str + qName + ".txt");
            fs = File.Create(str + qName + ".txt");
            sw = new StreamWriter(fs);
            sw.WriteLine(obj.ToString());
            sw.Close();
        }
        else
        {
            fs = File.Create(str + qName + ".txt");
            sw = new StreamWriter(fs);
            sw.WriteLine(obj.ToString());
            sw.Close();
            fs.Close();
        }

    }


}
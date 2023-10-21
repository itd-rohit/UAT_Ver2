using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_GraphicalReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ddlzone.DataSource = StockReports.GetDataTable("SELECT businesszoneid,businesszonename FROM `businesszone_master`");
            ddlzone.DataValueField = "businesszoneid";
            ddlzone.DataTextField = "businesszonename";
            ddlzone.DataBind();
            ddlzone.Items.Insert(0, new ListItem("Select Zone", "0"));
        }
    }

    [WebMethod]
    public static string bindstate(int zoneid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT id,state FROM state_master WHERE businesszoneid=@zoneid order by state",
                new MySqlParameter("@zoneid", zoneid))
            .Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string bindcity(int stateid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT id,city FROM city_master WHERE stateid=@stateid order by city",
                new MySqlParameter("@stateid", stateid))
            .Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
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
    public static string bindPhelbo(int cityid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT hp.`PhlebotomistID`,hp.`Name` FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hp INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".`hc_phleboworklocation` hw ON hp.`PhlebotomistID`=hw.`PhlebotomistID` AND hp.`IsActive`=1 AND hw.`CityId`=@cityid ORDER BY NAME ",
                new MySqlParameter("@cityid", cityid))
            .Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
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
    public static string GetReport(string reporttype, string fromdate, string todate, string stateid, string cityid, string phelbotomist)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (reporttype == "1")
            {
                sb.Append(" SELECT DATE_FORMAT(AppDateTime,'%d-%b-%Y')AppDate, ");
                sb.Append(" SUM(IF(hc.`currentstatus`='Pending',1,0)) `Pending`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='DoorLock',1,0)) `DoorLock`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='RescheduleRequest',1,0)) `RescheduleRequest`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='CancelRequest',1,0)) `CancelRequest`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='Rescheduled',1,0)) `Rescheduled`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='Completed',1,0)) `Completed`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='BookingCompleted',1,0)) `BookingCompleted`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='Canceled',1,0)) `Canceled` ");

                sb.Append(" FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc  ");
                sb.Append(" WHERE   ");
                sb.Append(" `AppDateTime`>=@fromdate AND   ");
                sb.Append(" `AppDateTime`<=@todate  ");
                if (stateid != "null" && stateid != "0")
                {
                    sb.Append(" and stateid=@stateid ");
                }
                if (cityid != "null" && cityid != "0")
                {
                    sb.Append(" and cityid=@cityid ");
                }
                if (phelbotomist != "null" && phelbotomist != "0" && phelbotomist != "")
                {
                    sb.Append(" and PhlebotomistID in({0}) ");
                }
                sb.Append("  GROUP BY DATE(AppDateTime)  ORDER BY AppDateTime  ");
            }
            else if (reporttype == "2")
            {
                sb.Append(" SELECT DATE_FORMAT(AppDateTime,'%d-%b-%Y')AppDate, ");
                sb.Append(" SUM(IF(hc.`currentstatus`='Pending',1,0)) `Pending`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='DoorLock',1,0)) `DoorLock`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='RescheduleRequest',1,0)) `RescheduleRequest`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='CancelRequest',1,0)) `CancelRequest`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='Rescheduled',1,0)) `Rescheduled`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='Completed',1,0)) `Completed`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='BookingCompleted',1,0)) `BookingCompleted`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='Canceled',1,0)) `Canceled` ");

                sb.Append(" FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc  ");
                sb.Append(" WHERE   ");
                sb.Append(" `AppDateTime`>=@fromdate  ");
                sb.Append(" AND  `AppDateTime`<=@todate  ");
                if (stateid != "null" && stateid != "0")
                {
                    sb.Append(" and stateid=@stateid ");
                }
                if (cityid != "null" && cityid != "0")
                {
                    sb.Append(" and cityid=@cityid ");
                }
                if (phelbotomist != "null" && phelbotomist != "0" && phelbotomist != "")
                {
                    sb.Append(" and PhlebotomistID in({0}) ");
                }
                sb.Append("  GROUP BY week(AppDateTime)  ORDER BY AppDateTime  ");
            }
            else if (reporttype == "3")
            {
                sb.Append(" SELECT MONTHNAME(AppDateTime)AppDate, ");
                sb.Append(" SUM(IF(hc.`currentstatus`='Pending',1,0)) `Pending`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='DoorLock',1,0)) `DoorLock`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='RescheduleRequest',1,0)) `RescheduleRequest`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='CancelRequest',1,0)) `CancelRequest`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='Rescheduled',1,0)) `Rescheduled`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='Completed',1,0)) `Completed`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='BookingCompleted',1,0)) `BookingCompleted`,  ");
                sb.Append(" SUM(IF(hc.`currentstatus`='Canceled',1,0)) `Canceled` ");

                sb.Append(" FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc  ");
                sb.Append(" WHERE   ");
                sb.Append(" `AppDateTime`>=@fromdate AND   ");
                sb.Append(" `AppDateTime`<=@todate  ");
                if (stateid != "null" && stateid != "0")
                {
                    sb.Append(" and stateid=@stateid ");
                }
                if (cityid != "null" && cityid != "0")
                {
                    sb.Append(" and cityid=@cityid ");
                }
                if (phelbotomist != "null" && phelbotomist != "0" && phelbotomist != "")
                {
                    sb.Append(" and PhlebotomistID in({0}) ");
                }
                sb.Append("  GROUP BY MONTH(AppDateTime)  ORDER BY AppDateTime  ");
            }

            string[] pacitemTags = String.Join(",", phelbotomist).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), pacitemClause), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@stateid", stateid);
                da.SelectCommand.Parameters.AddWithValue("@cityid", cityid);
                da.SelectCommand.Parameters.AddWithValue("@fromdate", Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00");
                da.SelectCommand.Parameters.AddWithValue("@todate", Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59");

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
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
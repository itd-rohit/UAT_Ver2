using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;

public partial class Design_HomeCollection_CustomerRating : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }

    [WebMethod]
    public static string bindzone()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT businesszoneid,businesszonename FROM `businesszone_master`").Tables[0])
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
    public static string bindstate(string zoneid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] pacitemTags = String.Join(",", zoneid).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT id,state FROM state_master WHERE businesszoneid in({0}) order by state", pacitemClause), con))
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
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string bindcity(string stateid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] pacitemTags = String.Join(",", stateid).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT id,city FROM city_master WHERE stateid in({0}) order by city", pacitemClause), con))
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
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string bindroute(string cityid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] pacitemTags = String.Join(",", cityid).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT hr.`Routeid`,hr.`Route` FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_routemaster` hr INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".`hc_area_route_mapping` hrm ON hrm.`Routeid`=hr.`Routeid` AND hr.`IsActive`=1 INNER JOIN `f_locality` fl ON fl.`ID`=hrm.`localityid` AND fl.`CityID` in ({0}) GROUP BY hr.`Routeid` ORDER BY route", pacitemClause), con))
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
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string GetReport(string fromdate, string todate, string stateid, string cityid, string routeid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT hpm.`PhlebotomistID`, hpm.`Name` Phelboname,ifnull(hpm.`Age`,'')Age,GROUP_CONCAT(DISTINCT sm.state) state,GROUP_CONCAT(DISTINCT cm.city)city,  ");
            sb.Append(" round(AVG(hc.`PhelboRating`)) Rating, ifnull(pp.`ProfilePics`,'')ProfilePics ,GROUP_CONCAT(DISTINCT sm.state) state,RouteName,hpm.Mobile, ");
            sb.Append(" sum(if(hc.`PhelboRating`=5,1,0)) `fiveStar`, ");
            sb.Append(" sum(if(hc.`PhelboRating`=4,1,0)) `fourStar`, ");
            sb.Append(" sum(if(hc.`PhelboRating`=3,1,0)) `threeStar`, ");
            sb.Append(" sum(if(hc.`PhelboRating`=2,1,0)) `twoStar`, ");
            sb.Append(" sum(if(hc.`PhelboRating`=1,1,0)) `oneStar`");
            sb.Append(" ");
            sb.Append(" FROM   " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc     ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hpm ON hpm.`PhlebotomistID`=hc.`PhlebotomistID`  ");
            sb.Append(" AND hc.`CurrentStatus` IN ('BookingCompleted','Completed')    ");
            sb.Append(" INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".`hc_phleboworklocation` pw ON pw.`PhlebotomistID`=hpm.`PhlebotomistID` ");
            sb.Append(" INNER JOIN `state_master` sm ON sm.id=pw.stateid ");
            sb.Append(" INNER JOIN `city_master` cm ON cm.id=pw.CityId ");
            sb.Append(" left JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster_profilepic pp ON pp.`PhlebotomistID`=hpm.`PhlebotomistID` AND pp.`Approved`=1 AND pp.`Active`=1 ");
            sb.Append(" where hc.AppDateTime>=@fromdate  ");
            sb.Append(" and hc.AppDateTime<=@todate  ");
            if (stateid != "null" && stateid != "" && stateid != "0")
            {
                sb.Append(" and hc.stateid=@stateid ");
            }
            if (cityid != "null" && cityid != "" && cityid != "0")
            {
                sb.Append(" and hc.cityid=@cityid ");
            }
            if (routeid != "null" && routeid != "" && routeid != "0")
            {
                sb.Append(" and hc.Route_ID=@routeid ");
            }
            sb.Append(" GROUP BY hc.`PhlebotomistID` ORDER BY `Rating` desc ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@stateid", stateid),
                new MySqlParameter("@cityid", cityid),
                new MySqlParameter("@routeid", routeid),
                new MySqlParameter("@todate", Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59"),
                new MySqlParameter("@fromdate", Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00")).Tables[0])
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
            if (con.State == ConnectionState.Open)
            {
                con.Close();
                con.Dispose();
            }
        }
    }

    [WebMethod]
    public static string GetLastThreeData(string phelboid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT patientname,patient_id,DATE_FORMAT(appdatetime,'%d-%b-%Y %h:%i %p')appdate,PhelboRating ");
            sb.Append(" FROM  " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking  ");
            sb.Append(" WHERE `CurrentStatus` IN ('BookingCompleted','Completed') AND PhlebotomistID=@phelboid  ");
            sb.Append("  ORDER BY id DESC LIMIT 3  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@phelboid", phelboid)).Tables[0])
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
}
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;

public partial class Design_HomeCollection_HomeCollectionReport : System.Web.UI.Page
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
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT businesszoneid,businesszonename FROM `businesszone_master`"));
    }

    [WebMethod]
    public static string bindstate(string zoneid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] zoneTags = zoneid.Split(',');
            string[] zoneParamNames = zoneTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string zoneClause = string.Join(", ", zoneParamNames);

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT id,state FROM state_master WHERE businesszoneid in({0}) order by state", zoneClause), con))
            {
                for (int i = 0; i < zoneParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(zoneParamNames[i], zoneTags[i]);
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
            string[] stateTags = stateid.Split(',');
            string[] stateParamNames = stateTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string stateClause = string.Join(", ", stateParamNames);

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT id,city FROM city_master WHERE stateid in({0}) order by city", stateClause), con))
            {
                for (int i = 0; i < stateParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(stateParamNames[i], stateTags[i]);
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
    public static string GetReport(string reporttype, string fromdate, string todate, string stateid, string cityid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] stateTags = stateid.Split(',');
            string[] stateParamNames = stateTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string stateClause = string.Join(", ", stateParamNames);

            string[] cityTags = cityid.Split(',');
            string[] cityParamNames = cityTags.Select(
              (s, i) => "@tag_" + i).ToArray();
            string cityClause = string.Join(", ", cityParamNames);

            string Query = string.Empty;
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            if (reporttype == "1")
            {
                sb.Append(" SELECT hc.`State`,COUNT(DISTINCT hc.prebookingid) PatientCount, SUM(netamt) Revenue ,'' AveragePerPatient,hc.`State` as 'Y' ");
                sb.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc   ");
                sb.Append(" INNER JOIN `patient_labinvestigation_opd_prebooking` plo ON hc.`PreBookingID`=plo.`PreBookingID` AND plo.`IsCancel`=0   ");
                sb.Append(" AND hc.`CurrentStatus` IN ('BookingCompleted','Completed')  ");
                sb.Append(" where hc.AppDateTime>=@fromdate");
                sb.Append(" and hc.AppDateTime<=@todate");
                if (stateid != string.Empty)
                {
                    sb.Append(" and hc.`StateID` in ({0}) ");
                }
                sb.Append(" GROUP BY hc.`StateID` order by hc.`State`  ");
                if (stateid != string.Empty)
                    Query = string.Format(sb.ToString(), stateClause);
                else
                    Query = sb.ToString();
            }
            else if (reporttype == "2")
            {
                sb.Append(" SELECT hc.`State`,hc.`City`,COUNT(DISTINCT hc.prebookingid) PatientCount, SUM(netamt) Revenue,'' AveragePerPatient,hc.`City` as 'Y' ");
                sb.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc   ");
                sb.Append(" INNER JOIN `patient_labinvestigation_opd_prebooking` plo ON hc.`PreBookingID`=plo.`PreBookingID` AND plo.`IsCancel`=0   ");
                sb.Append(" AND hc.`CurrentStatus` IN ('BookingCompleted','Completed')  ");
                sb.Append(" where hc.AppDateTime>=@fromdate");
                sb.Append(" and hc.AppDateTime<=@todate");
                if (stateid != string.Empty)
                {
                    sb.Append(" and hc.`StateID` in ({0}) ");
                }
                if (cityid != string.Empty)
                {
                    if (stateid != string.Empty)
                    {
                        sb.Append(" and hc.`CityID` in ({1}) ");
                    }
                    else
                    {
                        sb.Append(" and hc.`CityID` in ({0}) ");
                    }
                }
                sb.Append(" GROUP BY hc.`CityID` order by hc.`State`,hc.city  ");
                if (stateid != string.Empty && cityid == string.Empty)
                    Query = string.Format(sb.ToString(), stateClause);
                else if (stateid != string.Empty && cityid != string.Empty)
                    Query = string.Format(sb.ToString(), stateClause, cityClause);
                else if (cityid != string.Empty)
                    Query = string.Format(sb.ToString(), cityClause);
                else
                    Query = sb.ToString();
            }
            else if (reporttype == "3")
            {
                sb.Append(" SELECT hc.`State`,hc.`City`,DATE_FORMAT(hc.`AppDateTime`,'%d-%b-%Y') AppDate,COUNT(DISTINCT hc.prebookingid) PatientCount, SUM(netamt) Revenue ,'' AveragePerPatient,DATE_FORMAT(hc.`AppDateTime`,'%d-%b-%Y') 'Y' ");
                sb.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc   ");
                sb.Append(" INNER JOIN `patient_labinvestigation_opd_prebooking` plo ON hc.`PreBookingID`=plo.`PreBookingID` AND plo.`IsCancel`=0   ");
                sb.Append(" AND hc.`CurrentStatus` IN ('BookingCompleted','Completed')  ");
                sb.Append(" where hc.AppDateTime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'");
                sb.Append(" and hc.AppDateTime<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'");
                if (stateid != string.Empty)
                {
                    sb.Append(" and hc.`StateID` in ({0}) ");
                }
                if (cityid != string.Empty)
                {
                    if (stateid != string.Empty)
                    {
                        sb.Append(" and hc.`CityID` in ({1}) ");
                    }
                    else
                    {
                        sb.Append(" and hc.`CityID` in ({0}) ");
                    }
                }
                sb.Append(" GROUP BY hc.`CityID`,DATE(hc.`AppDateTime`)  ORDER BY hc.`State` ,hc.`City`,hc.`AppDateTime`  ");
                if (stateid != string.Empty && cityid == string.Empty)
                    Query = string.Format(sb.ToString(), stateClause);
                else if (stateid != string.Empty && cityid != string.Empty)
                    Query = string.Format(sb.ToString(), stateClause, cityClause);
                else if (cityid != string.Empty)
                    Query = string.Format(sb.ToString(), cityClause);
                else
                    Query = sb.ToString();
            }
            else if (reporttype == "4")
            {
                sb.Append(" SELECT hc.`State`,hc.`City`,DATE_FORMAT(hc.`AppDateTime`,'%b-%Y') AppMonth,COUNT(DISTINCT hc.prebookingid) PatientCount, SUM(netamt) Revenue,'' AveragePerPatient,DATE_FORMAT(hc.`AppDateTime`,'%b-%Y') 'Y' ");
                sb.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc   ");
                sb.Append(" INNER JOIN `patient_labinvestigation_opd_prebooking` plo ON hc.`PreBookingID`=plo.`PreBookingID` AND plo.`IsCancel`=0   ");
                sb.Append(" AND hc.`CurrentStatus` IN ('BookingCompleted','Completed')  ");
                sb.Append(" where hc.AppDateTime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'");
                sb.Append(" and hc.AppDateTime<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'");
                if (stateid != string.Empty)
                {
                    sb.Append(" and hc.`StateID` in ({0}) ");
                }
                if (cityid != string.Empty)
                {
                    if (stateid != string.Empty)
                    {
                        sb.Append(" and hc.`CityID` in ({1}) ");
                    }
                    else
                    {
                        sb.Append(" and hc.`CityID` in ({0}) ");
                    }
                }
                sb.Append(" GROUP BY hc.`CityID`, DATE_FORMAT(hc.`AppDateTime`,'%b-%Y')  ORDER BY hc.`State` ,hc.`City`,hc.`AppDateTime`  ");
                if (stateid != string.Empty && cityid == string.Empty)
                    Query = string.Format(sb.ToString(), stateClause);
                else if (stateid != string.Empty && cityid != string.Empty)
                    Query = string.Format(sb.ToString(), stateClause, cityClause);
                else if (cityid != string.Empty)
                    Query = string.Format(sb.ToString(), cityClause);
                else
                    Query = sb.ToString();
            }
            using (MySqlDataAdapter da = new MySqlDataAdapter(Query, con))
            {
                if (stateid != string.Empty)
                {
                    for (int i = 0; i < stateParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(stateParamNames[i], stateTags[i]);
                    }
                }
                if (cityid != string.Empty)
                {
                    for (int i = 0; i < cityParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(cityParamNames[i], cityTags[i]);
                    }
                }
                da.SelectCommand.Parameters.AddWithValue("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " ", "00:00:00"));
                da.SelectCommand.Parameters.AddWithValue("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59"));

                da.Fill(dt);
            }
            if (dt.Rows.Count > 0)
                return JsonConvert.SerializeObject(dt);
            else
                return "false";
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
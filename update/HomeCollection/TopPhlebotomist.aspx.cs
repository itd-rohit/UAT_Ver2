using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_TopPhlebotomist : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DateTimeFormatInfo info = DateTimeFormatInfo.GetInstance(null);
            for (int a = 1; a < 13; a++)
            {
                ddlmonth.Items.Add(new ListItem(info.GetMonthName(a), a.ToString()));
            }

            ListItem selectedListItem = ddlmonth.Items.FindByValue(DateTime.Now.Month.ToString());

            if (selectedListItem != null)
            {
                selectedListItem.Selected = true;
            }

            for (int a = DateTime.Now.Year - 2; a < DateTime.Now.Year + 10; a++)
            {
                ddlyear.Items.Add(new ListItem(a.ToString(), a.ToString()));
            }

            ListItem selectedListItem1 = ddlyear.Items.FindByValue(DateTime.Now.Year.ToString());

            if (selectedListItem1 != null)
            {
                selectedListItem1.Selected = true;
            }
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
            DataTable dt = new DataTable();
            List<string> pacitem = new List<string>();
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
            return Util.GetString(ex.GetBaseException());
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
            DataTable dt = new DataTable();
            List<string> pacitem = new List<string>();
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

                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());
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
            DataTable dt = new DataTable();
            List<string> pacitem = new List<string>();
            string[] pacitemTags = String.Join(",", cityid).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT hr.`Routeid`,hr.`Route` FROM " + Util.getApp("HomeCollectionDB") + ".`hc_routemaster` hr INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_area_route_mapping` hrm ON hrm.`Routeid`=hr.`Routeid` AND hr.`IsActive`=1 INNER JOIN `f_locality` fl ON fl.`ID`=hrm.`localityid` AND fl.`CityID` in ({0}) GROUP BY hr.`Routeid` ORDER BY route", pacitemClause), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                }

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
            return Util.GetString(ex.GetBaseException());
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string GetReport(string myear, string mmonth, string stateid, string cityid, string routeid, int top)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int days = DateTime.DaysInMonth(Util.GetInt(myear), Util.GetInt(mmonth));
            string fromdate = "01-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(Util.GetInt(mmonth)) + "-" + myear;
            string todate = days + "-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(Util.GetInt(mmonth)) + "-" + myear;

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT hpm.`PhlebotomistID`, hpm.`Name` Phelboname,ifnull(hpm.`Age`,'')Age,GROUP_CONCAT(DISTINCT sm.state) state,GROUP_CONCAT(DISTINCT cm.city)city,COUNT(DISTINCT hc.prebookingid) PatientCount, SUM(netamt) Revenue ,  ");
            sb.Append(" round( AVG(hc.`PhelboRating`),2) Rating, ifnull(pp.`ProfilePics`,'')ProfilePics ,GROUP_CONCAT(DISTINCT sm.state) state,RouteName,hpm.Mobile ");
            sb.Append(" FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc     ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd_prebooking` plo ON hc.`PreBookingID`=plo.`PreBookingID` AND plo.`IsCancel`=0     ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ". `hc_phlebotomistmaster` hpm ON hpm.`PhlebotomistID`=hc.`PhlebotomistID`  ");
            sb.Append(" AND hc.`CurrentStatus` IN ('BookingCompleted','Completed')    ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phleboworklocation` pw ON pw.`PhlebotomistID`=hpm.`PhlebotomistID` ");
            sb.Append(" INNER JOIN `state_master` sm ON sm.id=pw.stateid ");
            sb.Append(" INNER JOIN `city_master` cm ON cm.id=pw.CityId ");
            sb.Append(" left JOIN " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster_profilepic pp ON pp.`PhlebotomistID`=hpm.`PhlebotomistID` AND pp.`Approved`=1 AND pp.`Active`=1 ");
            sb.Append(" where hc.AppDateTime>=@fromDate");
            sb.Append(" and hc.AppDateTime<=@toDate  ");
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
                sb.Append(" and hc.Route_ID=@routeid");
            }
            sb.Append(" GROUP BY hc.`PhlebotomistID` ORDER BY `Revenue` DESC limit @top ");

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@routeid", routeid),
                new MySqlParameter("@top", top),
                new MySqlParameter("@cityid", cityid),
                new MySqlParameter("@stateid", stateid),
                new MySqlParameter("@fromDate", Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00"),
                new MySqlParameter("@toDate", Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59")).Tables[0];
            if (dt.Rows.Count > 0)
            {
                sb = new StringBuilder();

                sb.Append(" SELECT count(DISTINCT hc.prebookingid) PatientCount, sum(netamt) Revenue , count(DISTINCT hc.`PhlebotomistID`) totalphleb, ");
                sb.Append(" sum(hc.`PhelboRating`) Rating");
                sb.Append(" FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc     ");
                sb.Append(" INNER JOIN `patient_labinvestigation_opd_prebooking` plo ON hc.`PreBookingID`=plo.`PreBookingID` AND plo.`IsCancel`=0     ");
                sb.Append(" AND hc.`CurrentStatus` IN ('BookingCompleted','Completed')    ");
                sb.Append(" where hc.AppDateTime>=@fromDate  ");
                sb.Append(" and hc.AppDateTime<=@toDate ");
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

                DataTable dtavg = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@routeid", routeid),
                     new MySqlParameter("@cityid", cityid),
                     new MySqlParameter("@stateid", stateid),
                     new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " 00:00:00")),
                     new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " 23:59:59"))).Tables[0];

                DataColumn dc = new DataColumn("AvgRevenue");
                dc.DataType=typeof(Int32);
                int AvgRev =(int) (Convert.ToInt32(dtavg.Rows[0]["Revenue"]) / Convert.ToInt32(dtavg.Rows[0]["totalphleb"]));
                dc.DefaultValue = Util.GetString(AvgRev);
                dt.Columns.Add(dc);

                dc = new DataColumn("AvgCount");
                dc.DataType = typeof(Int32);
                int AvgCt = (int) (Convert.ToInt32(dtavg.Rows[0]["PatientCount"]) /Convert.ToInt32(dtavg.Rows[0]["totalphleb"]));
                dc.DefaultValue = Util.GetString(AvgCt);
                dt.Columns.Add(dc);

                sb = new StringBuilder();

                sb.Append(" SELECT  ");
                sb.Append(" avg(hc.`PhelboRating`) Rating");
                sb.Append(" FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc     ");
                sb.Append(" where hc.`CurrentStatus` IN ('BookingCompleted','Completed')    ");
                sb.Append(" and hc.AppDateTime>=@fromdate  ");
                sb.Append(" and hc.AppDateTime<=@todate  ");
                if (stateid != "null" && stateid != string.Empty && stateid != "0")
                {
                    sb.Append(" and hc.stateid=@stateid ");
                }
                if (cityid != "null" && cityid != string.Empty && cityid != "0")
                {
                    sb.Append(" and hc.cityid=@cityid ");
                }
                if (routeid != "null" && routeid != string.Empty && routeid != "0")
                {
                    sb.Append(" and hc.Route_ID=@routeid ");
                }

                dc = new DataColumn("AvgRating");
                dc.DefaultValue = Math.Round(Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@routeid", routeid),
                    new MySqlParameter("@stateid", stateid),
                    new MySqlParameter("@fromdate", Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00"),
                    new MySqlParameter("@todate", Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59"),
                    new MySqlParameter("@cityid", cityid))), 2);
                dt.Columns.Add(dc);
            }

            return JsonConvert.SerializeObject(dt);
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
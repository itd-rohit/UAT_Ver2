using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;

public partial class Design_HomeCollection_HomeCollectionRouteReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDateCal.EndDate = DateTime.Now;
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
    public static string bindroute(string cityid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] cityTags = cityid.Split(',');
            string[] cityParamNames = cityTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string cityClause = string.Join(", ", cityParamNames);

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT hr.`Routeid`,hr.`Route` FROM " + Util.getApp("HomeCollectionDB") + ".`hc_routemaster` hr INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_area_route_mapping` hrm ON hrm.`Routeid`=hr.`Routeid` AND hr.`IsActive`=1 INNER JOIN `f_locality` fl ON fl.`ID`=hrm.`localityid` AND fl.`CityID` in ({0}) GROUP BY hr.`Routeid` ORDER BY route", cityClause), con))
            {
                for (int i = 0; i < cityParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(cityParamNames[i], cityTags[i]);
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
    public static string GetReport(string reporttype, string fromdate, string todate, string cityid, string cityname, string routeid, string routename)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        if (reporttype == "1")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT hpm.`PhlebotomistID`,hpm.`Name` FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hpm  ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_area_phlebotomist_mapping` hc ON hpm.`PhlebotomistID`=hc.`PhlebotomistID`  ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_area_route_mapping` hcr ON hcr.`localityid`=hc.`localityid`   ");
            sb.Append(" AND hcr.`Routeid`=@routeid  ");
            sb.Append(" GROUP BY hpm.`PhlebotomistID` ORDER BY hpm.Name  ");

            using (DataTable dtphelbo = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@routeid", routeid)).Tables[0])
            {
                if (dtphelbo.Rows.Count > 0)
                {
                    string phid = string.Join(",", dtphelbo.Rows.OfType<DataRow>().Select(r => r["PhlebotomistID"].ToString()));
                    DataTable dtre = new DataTable();
                    dtre.Columns.Add("Timeslot");
                    foreach (DataRow dw in dtphelbo.Rows)
                    {
                        dtre.Columns.Add(dw["PhlebotomistID"].ToString() + "_" + dw["Name"].ToString(), typeof(System.Int32));
                    }

                    DateTime starttimeday = DateTime.Parse(fromdate + " " + "06:00:00");
                    DateTime endtimeday = DateTime.Parse(fromdate + " " + "20:00:00");
                    int avgtime = 30;
                    TimeSpan span = endtimeday.Subtract(starttimeday);
                    int total_min = Util.GetInt(span.TotalMinutes);

                    int noslots = total_min / avgtime;
                    int add = 0;
                    for (int i = 0; i < noslots; i++)
                    {
                        string madetime = Util.GetDateTime((starttimeday.AddMinutes(add)).ToShortTimeString()).ToString("HH:mm");
                        add += avgtime;
                        DataRow dr = dtre.NewRow();
                        dr["Timeslot"] = madetime.ToString();
                        dtre.Rows.Add(dr);
                    }
                    string[] phidTags = phid.Split(',');
                    string[] phidParamNames = phidTags.Select(
                      (s, i) => "@tag" + i).ToArray();
                    string phidClause = string.Join(", ", phidParamNames);

                    sb = new StringBuilder();
                    sb.Append(" select phlebotomistid,sum(netamt)netamt,DATE_FORMAT(appdatetime,'%H:%i:%s') apptime");
                    sb.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking hc  ");
                    sb.Append(" inner join patient_labinvestigation_opd_prebooking plo on plo.prebookingid=hc.prebookingid and plo.iscancel=0");
                    sb.Append(" WHERE  phlebotomistid in ({0}) and ");
                    sb.Append(" AppDateTime>=@fromdate  and ");
                    sb.Append(" AppDateTime<=@todate and ");
                    sb.Append(" hc.`CurrentStatus` IN ('BookingCompleted','Completed') ");
                    sb.Append(" GROUP BY phlebotomistid,DATE_FORMAT(appdatetime,'%H:%i:%s')");

                    using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), phidClause), con))
                    {
                        for (int i = 0; i < phidParamNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(phidParamNames[i], phidTags[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " ", "00:00:00"));
                        da.SelectCommand.Parameters.AddWithValue("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59"));
                        DataTable dttime = new DataTable();
                        using (dttime as IDisposable)
                        {
                            da.Fill(dttime);
                            sb = new StringBuilder();

                            foreach (DataRow dw in dtre.Rows)
                            {
                                foreach (DataColumn dc in dtre.Columns)
                                {
                                    if (dc.ColumnName != "Timeslot")
                                    {
                                        string ss = "phlebotomistid=" + dc.ColumnName.Split('_')[0] + " AND apptime='" + Util.GetDateTime(dw[0]).ToString("HH:mm:ss") + "'";
                                        DataRow[] drTemp = dttime.Select(ss);
                                        if (drTemp.Length > 0)
                                        {
                                            dw[dc.ColumnName] = Convert.ToInt32(drTemp[0]["netamt"]).ToString();
                                        }
                                        else
                                        {
                                            dw[dc.ColumnName] = "0";
                                        }
                                    }
                                }
                            }
                            DataRow dr1 = dtre.NewRow();
                            dr1["Timeslot"] = routename;
                            foreach (DataColumn dc in dtre.Columns)
                            {
                                if (dc.ColumnName != "Timeslot")
                                {
                                    dr1[dc.ColumnName] = Util.GetString(dtre.Compute("sum([" + dc.ColumnName + "])", ""));
                                }
                            }
                            dtre.Rows.Add(dr1);
                            return JsonConvert.SerializeObject(dtre);
                        }
                    }
                }
                else
                {
                    return "false";
                }
            }
        }
        else
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT hpm.`PhlebotomistID`,hpm.`Name` FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hpm  ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_area_phlebotomist_mapping` hc ON hpm.`PhlebotomistID`=hc.`PhlebotomistID`  ");
            sb.Append(" inner join f_locality fl on fl.id=hc.localityid ");
            sb.Append(" AND fl.`cityid`=@cityid  ");
            sb.Append(" GROUP BY hpm.`PhlebotomistID` ORDER BY hpm.Name  ");

            using (DataTable dtphelbo = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@cityid", cityid)).Tables[0])
            {
                if (dtphelbo.Rows.Count > 0)
                {
                    string phid = string.Join(",", dtphelbo.Rows.OfType<DataRow>().Select(r => r["PhlebotomistID"].ToString()));
                    DataTable dtre = new DataTable();
                    dtre.Columns.Add("Timeslot");
                    foreach (DataRow dw in dtphelbo.Rows)
                    {
                        dtre.Columns.Add(dw["PhlebotomistID"].ToString() + "_" + dw["Name"].ToString(), typeof(System.Int32));
                    }

                    DateTime starttimeday = DateTime.Parse(fromdate + " " + "06:00:00");
                    DateTime endtimeday = DateTime.Parse(fromdate + " " + "20:00:00");
                    int avgtime = 30;
                    TimeSpan span = endtimeday.Subtract(starttimeday);
                    int total_min = Util.GetInt(span.TotalMinutes);

                    int noslots = total_min / avgtime;
                    int add = 0;
                    for (int i = 0; i < noslots; i++)
                    {
                        string madetime = Util.GetDateTime((starttimeday.AddMinutes(add)).ToShortTimeString()).ToString("HH:mm");
                        add += avgtime;
                        DataRow dr = dtre.NewRow();
                        dr["Timeslot"] = madetime.ToString();
                        dtre.Rows.Add(dr);
                    }
                    string[] phidTags = phid.Split(',');
                    string[] phidParamNames = phidTags.Select(
                      (s, i) => "@tag" + i).ToArray();
                    string phidClause = string.Join(", ", phidParamNames);
                    sb = new StringBuilder();
                    sb.Append(" select phlebotomistid,sum(netamt)netamt,DATE_FORMAT(appdatetime,'%H:%i:%s') apptime");
                    sb.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking hc  ");
                    sb.Append(" inner join patient_labinvestigation_opd_prebooking plo on plo.prebookingid=hc.prebookingid and plo.iscancel=0");
                    sb.Append(" WHERE  phlebotomistid in ({0}) and ");
                    sb.Append(" AppDateTime>=@fromdate  and ");
                    sb.Append(" AppDateTime<=@todate and ");
                    sb.Append(" hc.`CurrentStatus` IN ('BookingCompleted','Completed') ");
                    sb.Append(" GROUP BY phlebotomistid,DATE_FORMAT(appdatetime,'%H:%i:%s')");

                    using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), phidClause), con))
                    {
                        for (int i = 0; i < phidParamNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(phidParamNames[i], phidTags[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " ", "00:00:00"));
                        da.SelectCommand.Parameters.AddWithValue("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59"));
                        DataTable dttime = new DataTable();
                        using (dttime as IDisposable)
                        {
                            da.Fill(dttime);
                            sb = new StringBuilder();
                            foreach (DataRow dw in dtre.Rows)
                            {
                                foreach (DataColumn dc in dtre.Columns)
                                {
                                    if (dc.ColumnName != "Timeslot")
                                    {
                                        string ss = "phlebotomistid=" + dc.ColumnName.Split('_')[0] + " AND apptime='" + Util.GetDateTime(dw[0]).ToString("HH:mm:ss") + "'";
                                        DataRow[] drTemp = dttime.Select(ss);
                                        if (drTemp.Length > 0)
                                        {
                                             dw[dc.ColumnName] = Convert.ToInt32(drTemp[0]["netamt"]).ToString();

                                        }
                                        else
                                        {
                                            dw[dc.ColumnName] = "0";
                                        }
                                    }
                                }
                            }
                            DataRow dr1 = dtre.NewRow();
                            dr1["Timeslot"] = cityname;
                            foreach (DataColumn dc in dtre.Columns)
                            {
                                if (dc.ColumnName != "Timeslot")
                                {
                                    dr1[dc.ColumnName] = Util.GetString(dtre.Compute("sum([" + dc.ColumnName + "])", ""));
                                }
                            }
                            dtre.Rows.Add(dr1);
                            return JsonConvert.SerializeObject(dtre);
                        }
                    }
                }
                else
                {
                    return "false";
                }
            }
        }
    }
}
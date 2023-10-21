using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_PhelbomistCallTransfer : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            AllLoad_Data.bindState(ddlstate);

            ToDateCal.StartDate = DateTime.Now;
            ddlstate.Items.Insert(0, new ListItem("Select", "0"));
            AllLoad_Data.bindState(ddlstate_Target);
            ddlstate_Target.Items.Insert(0, new ListItem("Select", "0"));


            //txtfromdate_Serch.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            //txttodate_Serch.Text = DateTime.Now.ToString("dd-MMM-yyyy");


        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindphelbo(string cityid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT hc.PhlebotomistID,`name` FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hc INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_phleboworklocation cm ON cm.PhlebotomistID=hc.PhlebotomistID WHERE cm.cityid=@cityid",
                   new MySqlParameter("@cityid", cityid)).Tables[0])
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

    [WebMethod(EnableSession = true)]
    public static string Transfer(string All_PrebookingId, string phelbotomist_SourceId, string phelbotomist_TargetId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {

            string[] pacitemTags = String.Join(",", All_PrebookingId).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("update  " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking set PhlebotomistID=@phelbotomist_TargetId where PhlebotomistID=@phelbotomist_SourceId and PreBookingID in({0})", pacitemClause), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@phelbotomist_TargetId", phelbotomist_TargetId);
                da.SelectCommand.Parameters.AddWithValue("@phelbotomist_SourceId", phelbotomist_SourceId);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return "1";
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0"; ;
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



    [WebMethod(EnableSession = true)]
    public static string bindslot(string phlebotomistid, string fromdate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {

            DataTable dtre = new DataTable();
            dtre.Columns.Add("Timeslot");
            dt.Columns.Add("route");
            dt.Columns.Add("centreid");
            dt.Columns.Add("PhlebotomistID");
            dt.Columns.Add("PhlebotomistName");
            DateTime starttimeday, endtimeday;
            starttimeday = DateTime.Parse(fromdate + " " + "06:00:0");
            endtimeday = DateTime.Parse(fromdate + " " + "17:00:00");
            int avgtime = Util.GetInt(10);
            TimeSpan span = endtimeday.Subtract(starttimeday);
            int total_min = Util.GetInt(span.TotalMinutes);
            int noslots = total_min / avgtime;
            int add = 0;
            for (int i = 0; i < noslots; i++)
            {
                string madetime = Util.GetDateTime((starttimeday.AddMinutes(add)).ToShortTimeString()).ToString("HH:mm");
                add += avgtime;
                dt.Columns.Add(madetime);
                DataRow dr = dtre.NewRow();
                dr["Timeslot"] = madetime.ToString();
                dtre.Rows.Add(dr);

            }
            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" SELECT hcb.PhlebotomistID,hcb.RouteName,hcb.CentreID,pm.istemp,pm.Name,pm.Mobile, ");
            sb1.Append("  CONCAT(hcb.patient_id,'#',hcb.patientname,'#',hcb.Address,'#',hcb.Mobileno,'#',hcb.Iscancel,'#',hcb.IsBooked,'#',hcb.PreBookingID,'#',if(hcb.vip=1,'Yes','No'),'#',if(hcb.HardCopyRequired=1,'Yes','No'),'#',hcb.locality,'#','1') pname, ");
            sb1.Append(" DATE_FORMAT(hcb.appdatetime,'%H:%i:%s') apptime");
            sb1.Append(" FROM  " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking hcb ");
            sb1.Append(" inner join  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster pm on pm.phlebotomistid=hcb.phlebotomistid ");
            sb1.Append("  WHERE hcb.phlebotomistid=@phlebotomistid  ");
            sb1.Append(" and date(hcb.AppDateTime)=@fromdate and hcb.iscancel=0  AND hcb.isbooked=0  ");
            DataTable dttime = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb1.ToString(),
                new MySqlParameter("@phlebotomistid", phlebotomistid),
                new MySqlParameter("@fromdate", Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"))).Tables[0];
            DataRow dwc = dt.NewRow();
            dwc["route"] = dttime.Rows[0]["RouteName"].ToString().ToUpper();
            dwc["centreid"] = dttime.Rows[0]["RouteName"].ToString();
            dwc["PhlebotomistID"] = dttime.Rows[0]["PhlebotomistID"].ToString() + "#" + 3 + "#" + dttime.Rows[0]["istemp"].ToString();
            dwc["PhlebotomistName"] = dttime.Rows[0]["Name"].ToString() + "(" + dttime.Rows[0]["Mobile"].ToString() + ")";
            foreach (DataColumn dc in dt.Columns)
            {
                if (dc.ColumnName != "PhlebotomistID" && dc.ColumnName != "PhlebotomistName" && dc.ColumnName != "route" && dc.ColumnName != "centreid" && dc.ColumnName != "centre")
                {
                    try
                    {
                        string ss = "phlebotomistid=" + phlebotomistid + " AND apptime='" + Util.GetDateTime(dc.ColumnName).ToString("HH:mm:ss") + "'";
                        DataRow[] drTemp = dttime.Select(ss);
                        if (drTemp.Length > 0)
                            dwc[dc.ColumnName] = drTemp[0]["pname"].ToString();
                    }
                    catch
                    {
                    }
                }
            }
            dt.Rows.Add(dwc);
            return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "1#" + ex.Message;
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
    [WebMethod(EnableSession = true)]
    public static string bindslot_Target(string phlebotomistid, string fromdate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {

            DataTable dtre = new DataTable();
            dtre.Columns.Add("Timeslot");
            dt.Columns.Add("route");
            dt.Columns.Add("centreid");
            dt.Columns.Add("PhlebotomistID");
            dt.Columns.Add("PhlebotomistName");
            DateTime starttimeday, endtimeday;
            starttimeday = DateTime.Parse(fromdate + " " + "06:00:0");
            endtimeday = DateTime.Parse(fromdate + " " + "17:00:00");
            int avgtime = Util.GetInt(10);
            TimeSpan span = endtimeday.Subtract(starttimeday);
            int total_min = Util.GetInt(span.TotalMinutes);
            int noslots = total_min / avgtime;
            int add = 0;
            for (int i = 0; i < noslots; i++)
            {
                string madetime = Util.GetDateTime((starttimeday.AddMinutes(add)).ToShortTimeString()).ToString("HH:mm");
                add += avgtime;
                dt.Columns.Add(madetime);
                DataRow dr = dtre.NewRow();
                dr["Timeslot"] = madetime.ToString();
                dtre.Rows.Add(dr);

            }
            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" SELECT pm.PhlebotomistID,ifnull(hcb.RouteName,'')RouteName,ifnull(hcb.CentreID,'')CentreID,pm.istemp,pm.Name,pm.Mobile, ");
            sb1.Append("  ifnull(CONCAT(hcb.patient_id,'#',hcb.patientname,'#',hcb.Address,'#',hcb.Mobileno,'#',hcb.Iscancel,'#',hcb.IsBooked,'#',hcb.PreBookingID,'#',if(hcb.vip=1,'Yes','No'),'#',if(hcb.HardCopyRequired=1,'Yes','No'),'#',hcb.locality,'#','1'),'') pname, ");
            sb1.Append(" ifnull(DATE_FORMAT(hcb.appdatetime,'%H:%i:%s'),'') apptime");
            sb1.Append(" FROM  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster pm ");
            sb1.Append(" left join  " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking hcb on pm.phlebotomistid=hcb.phlebotomistid and date(hcb.AppDateTime)=@fromDate and hcb.iscancel=0 AND hcb.isbooked=0 ");
            sb1.Append("  WHERE pm.phlebotomistid=@phlebotomistid ");
            using (DataTable dttime = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb1.ToString(),
                  new MySqlParameter("@phlebotomistid", phlebotomistid),
                  new MySqlParameter("@fromDate", Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"))).Tables[0])
            {
                DataRow dwc = dt.NewRow();
                dwc["route"] = dttime.Rows[0]["RouteName"].ToString().ToUpper();
                dwc["centreid"] = dttime.Rows[0]["RouteName"].ToString();
                dwc["PhlebotomistID"] = string.Concat(dttime.Rows[0]["PhlebotomistID"].ToString(), "#", 3 + "#", dttime.Rows[0]["istemp"].ToString());
                dwc["PhlebotomistName"] = string.Concat(dttime.Rows[0]["Name"].ToString(), "(" + dttime.Rows[0]["Mobile"].ToString() + ")");
                foreach (DataColumn dc in dt.Columns)
                {
                    if (dc.ColumnName != "PhlebotomistID" && dc.ColumnName != "PhlebotomistName" && dc.ColumnName != "route" && dc.ColumnName != "centreid" && dc.ColumnName != "centre")
                    {
                        try
                        {
                            string ss = "phlebotomistid=" + phlebotomistid + " AND apptime='" + Util.GetDateTime(dc.ColumnName).ToString("HH:mm:ss") + "'";
                            DataRow[] drTemp = dttime.Select(ss);
                            if (drTemp.Length > 0)
                                dwc[dc.ColumnName] = drTemp[0]["pname"].ToString();
                        }
                        catch
                        {
                        }
                    }
                }
                dt.Rows.Add(dwc);
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Concat("1#", ex.Message);
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
}
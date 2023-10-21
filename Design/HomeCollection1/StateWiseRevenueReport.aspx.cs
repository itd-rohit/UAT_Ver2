using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_StateWiseRevenueReport : System.Web.UI.Page
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
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT businesszoneid,businesszonename FROM `businesszone_master`"));
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
    public static string GetReport(string fromdate, string todate, string stateid)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT hc.`State`,COUNT(DISTINCT hc.prebookingid) PatientCount, SUM(netamt) Revenue ,'' AveragePerPatient,hc.`State` as 'Y',StateLatitude 'SLA',StateLongitude 'SLO' ");
        sb.Append(" FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc   ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd_prebooking` plo ON hc.`PreBookingID`=plo.`PreBookingID` AND plo.`IsCancel`=0   ");
        sb.Append(" inner join state_master st on st.id=hc.StateID");
        sb.Append(" AND hc.`CurrentStatus` IN ('BookingCompleted','Completed')  ");
        sb.Append(" where hc.AppDateTime>=@fromDate ");
        sb.Append(" and hc.AppDateTime<=@todate ");
        if (stateid != string.Empty)
        {
            sb.Append(" and hc.`StateID` in ({0}) ");
        }
        sb.Append(" GROUP BY hc.`StateID` order by hc.`State`  ");

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dt_AllData = new DataTable();
            List<string> pacitem = new List<string>();
            string[] pacitemTags = String.Join(",", stateid).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            string Query = string.Empty;
            if (stateid != string.Empty)
            {
                Query = string.Format(sb.ToString(), pacitemClause);
            }
            else
            {
                Query = sb.ToString();
            }
            using (MySqlDataAdapter da = new MySqlDataAdapter(Query, con))
            {
                da.SelectCommand.Parameters.AddWithValue("@fromDate", Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00");
                da.SelectCommand.Parameters.AddWithValue("@todate", Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59");
                if (stateid != string.Empty)
                {
                    for (int i = 0; i < pacitemParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                    }
                }

                using (dt_AllData as IDisposable)
                {
                    da.Fill(dt_AllData);


                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt_AllData);


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
}
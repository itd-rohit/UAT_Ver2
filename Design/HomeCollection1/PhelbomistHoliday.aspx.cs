using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_PhelbomistHoliday : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            AllLoad_Data.bindState(ddlstate);
            FromdateCal.StartDate = DateTime.Now;
            ToDateCal.StartDate = DateTime.Now;
            ddlstate.Items.Insert(0, new ListItem("Select", "0"));
            txtfromdate_Serch.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate_Serch.Text = DateTime.Now.ToString("dd-MMM-yyyy");
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
    public static string saveholiday(string phlebotomist, string fromdate, string todate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            int a = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` WHERE `PhlebotomistID`=@PhlebotomistID AND iscancel=0 AND isbooked=0 and AppDateTime>=@fromdate and AppDateTime<=@todate",
                new MySqlParameter("@PhlebotomistID", phlebotomist),
                new MySqlParameter("@fromdate", Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00"),
                new MySqlParameter("@todate", Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59")));

            if (a > 0)
            {
                return "0";
            }

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "insert into  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomist_holiday(PhlebotomistID,FromDate,ToDate,EntryDate,EntryByUserID,EntryByUserName) values (@PhlebotomistID,@FromDate,@ToDate,@EntryDate,@EntryByUserID,@EntryByUserName) ",
                  new MySqlParameter("@PhlebotomistID", phlebotomist),
                  new MySqlParameter("@FromDate", Util.GetDateTime(fromdate)),
                  new MySqlParameter("@ToDate", Util.GetDateTime(todate)),
                  new MySqlParameter("@EntryDate", DateTime.Now),
                  new MySqlParameter("@EntryByUserID", UserInfo.ID),
                  new MySqlParameter("@EntryByUserName", UserInfo.LoginName)
                  );
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
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
    public static string GetData(string fromDate, string toDate, string NoofRecord)
    {
        try
        {
            int valCentreID = UserInfo.Centre;
        }
        catch
        {
            return "-1";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("   SELECT  pm.PhlebotomistID,pm.Name,DATE_FORMAT(ph.FromDate,'%d-%b-%Y') as FromDate ,DATE_FORMAT(ph.ToDate,'%d-%b-%Y') as ToDate ,ph.id,IF(ph.IsActive=1,'Active','Cancelled') status,ph.IsActive  ");
            sb.Append(" FROM  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomist_holiday ph  ");
            sb.Append(" INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster pm ON pm.`PhlebotomistID`=ph.`PhlebotomistID` and ph.IsActive=1  ");
            if (fromDate != string.Empty)
            {
                sb.Append(" and  (( ph.FromDate>=@fromDate and ph.FromDate<=@toDate)  ");
            }
            if (toDate != string.Empty)
            {
                sb.Append(" or (  ph.ToDate>=@fromDate and ph.ToDate<=@toDate )) ");
            }
            sb.Append("  order by ph.`ID` desc   limit @NoofRecord  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@NoofRecord", Util.GetInt(NoofRecord)),
                                              new MySqlParameter("@fromDate", Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00"),
                                              new MySqlParameter("@toDate", Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59")
                ).Tables[0])
            {
                return Util.getJson(dt);
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
    public static string CancelPhelboHoliday(string HoliDayid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "Update  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomist_holiday set IsActive=0 where Id=@HoliDayid",
               new MySqlParameter("@HoliDayid", HoliDayid));
            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}
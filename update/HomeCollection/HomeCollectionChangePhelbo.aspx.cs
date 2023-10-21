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

public partial class Design_HomeCollection_HomeCollectionChangePhelbo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.AddDays(1).ToString("dd-MMM-yyyy");
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
                new MySqlParameter("@zoneid", zoneid)).Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
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
                    new MySqlParameter("@stateid", stateid)).Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
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

    [WebMethod]
    public static string GetALlData(string State, string City, string Phelbotomist, string fromdate, string todate, string status, string mobileno, string prebookingid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT hm.`Name` Phleboname,DATE_FORMAT(appdatetime,'%d-%b-%Y %h:%i %p') AppDate,hc.PhlebotomistID, ");
            sb.Append("  `PreBookingID`, Patient_id,PatientName,MobileNo,hc.Address,hc.locality,hc.city,hc.state,hc.pincode,currentstatus,ifnull(hc.RouteName,'')RouteName, ");
            sb.Append("  (SELECT group_concat(distinct concat(routeid,'#',Route)) FROM   " + Util.getApp("HomeCollectionDB") + ".`hc_routemaster` where stateid=hc.stateid and cityid=hc.cityid and isactive=1 )routelist, ");
            sb.Append("  ifnull((SELECT GROUP_CONCAT(distinct CONCAT(cm.PhlebotomistID,'^',cm.`Name`)) ");
            sb.Append("  FROM  " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping ha");
            sb.Append(" INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping hr ON ha.`localityid`=hr.`localityid` ");
            sb.Append(" INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` cm ON cm.PhlebotomistID=ha.`PhlebotomistID`");
            sb.Append("  where hr.routeid=hc.Route_ID ),'')phelbolist,");
            sb.Append("  concat(hc.CentreID,'#',hc.PanelID) cpid,cm.centre");
            sb.Append("  FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc ");
            sb.Append("  INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster`  hm ON hm.`PhlebotomistID`=hc.`PhlebotomistID` ");
            if (State != "0" && State != "null")
            {
                sb.Append(" and hc.StateID=@State ");
            }
            if (City != "0" && City != "null")
            {
                sb.Append(" and hc.CityID=@City ");
            }
            if (Phelbotomist != "0" && Phelbotomist != "null")
            {
                sb.Append(" and hc.PhlebotomistID=@Phelbotomist ");
            }
            if (Phelbotomist != "0" && Phelbotomist != "null")
            {
                sb.Append(" and hc.PhlebotomistID=@Phelbotomist ");
            }
            if (mobileno != "")
            {
                sb.Append(" and hc.MobileNo=@mobileno ");
            }
            if (prebookingid != "")
            {
                sb.Append(" and hc.PreBookingID=@prebookingid ");
            }
            sb.Append(" and hc.currentstatus  in ('Pending','Rescheduled') ");

            sb.Append("  INNER JOIN centre_master cm ON cm.centreid=hc.CentreID ");
            sb.Append(" WHERE ");
            if (mobileno != "" || prebookingid != "")
            {
                sb.Append(" hc.iscancel=0 ");
            }
            else
            {
                sb.Append(" hc.iscancel=0 ");
                sb.Append(" and hc.appdatetime>=@fromDate ");
                sb.Append(" and hc.appdatetime<=@toDate ");
            }

            sb.Append("  ORDER BY cm.centre,appdatetime ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@State", State),
                new MySqlParameter("@City", City),
                new MySqlParameter("@Phelbotomist", Phelbotomist),
                new MySqlParameter("@mobileno", mobileno),
                new MySqlParameter("@prebookingid", prebookingid),
                new MySqlParameter("@fromDate",Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00"),
                new MySqlParameter("@toDate", Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59")).Tables[0])
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
    public static string GetPhelboList(string routeid)
    {
        MySqlConnection con = Util.GetMySqlCon();      
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select ha.PhlebotomistID id,cm.`Name` ");
            sb.Append("  FROM  " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping ha");
            sb.Append(" INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping hr ON ha.`localityid`=hr.`localityid` ");
            sb.Append(" INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` cm ON cm.PhlebotomistID=ha.`PhlebotomistID`");
            sb.Append(" where hr.routeid=@routeid ");
            sb.Append(" group by ha.PhlebotomistID order by Name");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@routeid", routeid)).Tables[0])
            {
                return  JsonConvert.SerializeObject(dt);
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
    public static string SaveData(List<string> dataIm)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (string mmd in dataIm)
            {

                string data = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select concat(PhlebotomistID,'#',DATE_FORMAT(AppDateTime,'%d-%b-%Y %h:%i %p')) from  hc_homecollectionbooking where PreBookingID=@PreBookingID",
                    new MySqlParameter("@PreBookingID", mmd.Split('#')[0])));


                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, @"UPDATE   " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking hc  SET hc.PhlebotomistID=@PhlebotomistID,hc.RouteName=@RouteName,hc.Route_ID=@Route_ID WHERE hc.PreBookingID=@PreBookingID",
                   new MySqlParameter("@PhlebotomistID", mmd.Split('#')[3]),
                   new MySqlParameter("@RouteName", mmd.Split('#')[2]),
                   new MySqlParameter("@Route_ID", mmd.Split('#')[1]),
                   new MySqlParameter("@PreBookingID", mmd.Split('#')[0]));

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into  " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking_status (PreBookingID,CurrentStatus,CurrentStatusDate,EntryByID,EntryByName) values (@PreBookingID,@CurrentStatus,@CurrentStatusDate,@EntryByID,@EntryByName)",
               new MySqlParameter("@PreBookingID", mmd.Split('#')[0]),
               new MySqlParameter("@CurrentStatus", "Phlebotomist Change"),
               new MySqlParameter("@CurrentStatusDate", DateTime.Now),
               new MySqlParameter("@EntryByID", UserInfo.ID),
               new MySqlParameter("@EntryByName", UserInfo.LoginName));

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labinvestigation_opd_prebooking set itemname=@itemname where itemid=@HomeCollectionChargeItemID and  PreBookingID=@PreBookingID",
                    new MySqlParameter("@itemname", mmd.Split('#')[4]),
                    new MySqlParameter("@PreBookingID", mmd.Split('#')[0]),
                    new MySqlParameter("@HomeCollectionChargeItemID",Resources.Resource.HomeCollectionChargeItemID));

                // Send Notification
                StringBuilder sbSMS = new StringBuilder();

                sbSMS.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_fcm_notification (PreBookingID,phelbotomistid,title,body,EntryDate,entrybyid,EntryByName)  ");
                sbSMS.Append(" VALUES ");
                sbSMS.Append(" (@mmd,@data,'Phlebotomist Change','Phlebotomist Change For PrebookingId @mmd',now(),@ID,@LoginName)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                    new MySqlParameter("@mmd", mmd.Split('#')[0]),
                    new MySqlParameter("@data", data.Split('#')[0]),
                    new MySqlParameter("@ID", UserInfo.ID),
                    new MySqlParameter("@LoginName", UserInfo.LoginName)
                    );
                // Send Notification
                sbSMS = new StringBuilder();
                sbSMS.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_fcm_notification (PreBookingID,phelbotomistid,title,body,EntryDate,entrybyid,EntryByName)  ");
                sbSMS.Append(" VALUES ");
                sbSMS.Append(" (@mmd,@mmd3,'New HomeCollection','New HomeCollection Booked For You at @data',now(),@ID,@LoginName)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                    new MySqlParameter("@mmd", mmd.Split('#')[0]),
                    new MySqlParameter("@mmd3", mmd.Split('#')[3]),
                    new MySqlParameter("@data", data.Split('#')[1]),
                    new MySqlParameter("@ID", UserInfo.ID ),
                    new MySqlParameter("@LoginName", UserInfo.LoginName));
            }

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}
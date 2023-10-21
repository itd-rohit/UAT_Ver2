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

public partial class Design_HomeCollection_HomeCollectionChangeDropLocation : System.Web.UI.Page
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
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(ex);
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string bindcity(int stateid)
    {MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT id,city FROM city_master WHERE stateid=@stateid order by city",
                    new MySqlParameter("@stateid", stateid)).Tables[0])
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(ex);
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
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }
        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(ex);
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string GetALlData(string State, string City, string Phelbotomist, string fromdate, string todate, string status,string mobileno,string prebookingid)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append("  SELECT hm.`Name` Phleboname,DATE_FORMAT(appdatetime,'%d-%b-%Y %h:%i %p') AppDate,hc.PhlebotomistID, ");
            sb.Append("  `PreBookingID`, Patient_id,PatientName,MobileNo,hc.Address,hc.locality,hc.city,hc.state,hc.pincode,currentstatus,ifnull(hc.RouteName,'')RouteName, ");
            sb.Append("  (SELECT group_concat(distinct concat(routeid,'#',Route)) FROM   " + Util.getApp("HomeCollectionDB") + ".`hc_routemaster` where stateid=hc.stateid and cityid=hc.cityid and isactive=1 )routelist, ");
            sb.Append("  ifnull((SELECT GROUP_CONCAT( distinct CONCAT(CONCAT(ha.`droplocationID`,'#',ha.panelid),'^',if(cm.type1='PCC',concat(cm.centre,'~',cm.COCO_FOCO),cm.centre))) ");
            sb.Append("  FROM  " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping ha");
            sb.Append("  INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping hr ON ha.`localityid`=hr.`localityid` ");
            sb.Append("  INNER JOIN centre_master cm ON cm.centreid=ha.`droplocationID`");
            sb.Append("  where hr.routeid=hc.Route_ID ),'')centrelist,");
            sb.Append("  concat(hc.CentreID,'#',hc.PanelID) cpid,if(cm1.type1='PCC',concat(cm1.centre,'~',cm1.COCO_FOCO),cm1.centre) as centre ");
            sb.Append("  FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc ");
            sb.Append("  INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster`  hm ON hm.`PhlebotomistID`=hc.`PhlebotomistID` ");
            if (State != "0" && State != "null")
            {
                sb.Append(" and hc.StateID=@State  ");
            }
            if (City != "0" && City != "null")
            {
                sb.Append(" and hc.CityID=@City  ");
            }
            if (Phelbotomist != "0" && Phelbotomist != "null")
            {
                sb.Append(" and hc.PhlebotomistID=@Phelbotomist  ");
            }
            if (Phelbotomist != "0" && Phelbotomist != "null")
            {
                sb.Append(" and hc.PhlebotomistID=@Phelbotomist  ");
            }
            if (mobileno != "")
            {
                sb.Append(" and hc.MobileNo=@mobileno  ");
            }
            if (prebookingid != "")
            {
                sb.Append(" and hc.PreBookingID=@prebookingid  ");
            }
            sb.Append(" and hc.currentstatus not in ('Canceled','BookingCompleted','CheckIn') ");
            sb.Append("  INNER JOIN centre_master cm1 ON cm1.centreid=hc.CentreID ");
            sb.Append(" WHERE ");
            if (mobileno != "" || prebookingid != "")
            {
                sb.Append(" hc.iscancel=0 ");
            }
            else
            {
                sb.Append(" hc.iscancel=0 ");
                sb.Append(" and hc.appdatetime>=@fromdate ");
                sb.Append(" and hc.appdatetime<=@todate  ");
            }
            sb.Append("  ORDER BY Phleboname,appdatetime ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@State", State),
                    new MySqlParameter("@City", City),
                    new MySqlParameter("@Phelbotomist", Phelbotomist),
                    new MySqlParameter("@mobileno", mobileno),
                    new MySqlParameter("@prebookingid", prebookingid),
                    new MySqlParameter("@fromdate", Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00"),
                    new MySqlParameter("@todate", Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59")).Tables[0])
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(ex);
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string GetDropLocationList(string routeid)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append(" select CONCAT(ha.`droplocationID`,'#',ha.panelid) cpid,if(cm.type1='PCC',concat(cm.centre,'~',cm.COCO_FOCO),cm.centre) as Centre ");
            sb.Append("  FROM  " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping ha");
            sb.Append(" INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping hr ON ha.`localityid`=hr.`localityid` ");
            sb.Append(" INNER JOIN centre_master cm ON cm.centreid=ha.`droplocationID` and cm.isactive=1   ");
            sb.Append(" where hr.routeid=@routeid ");
            sb.Append(" group by ha.`droplocationID` order by centre");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@routeid", routeid)).Tables[0])
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(ex);
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
                
               string paneltype = Util.GetString(MySqlHelper.ExecuteScalar(tnx,CommandType.Text,"select paneltype from f_panel_master pm inner join patient_labinvestigation_opd_prebooking plo on plo.panel_id=pm.panel_id and plo.PreBookingID=@PreBookingID",new MySqlParameter("@PreBookingID", mmd.Split('#')[0])));

               int PhlebotomistID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select PhlebotomistID from  " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking where PreBookingID=@PreBookingID", new MySqlParameter("@PreBookingID", mmd.Split('#')[0])));


                if (paneltype == "PUP")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, @"UPDATE   " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking hc INNER JOIN `patient_labinvestigation_opd_prebooking` plo ON plo.PreBookingID=hc.PreBookingID SET hc.CentreID=@CentreID,hc.RouteName=@RouteName,hc.Route_ID=@Route_ID,plo.PreBookingCentreID=@CentreID  WHERE hc.PreBookingID=@PreBookingID",
                       new MySqlParameter("@CentreID", mmd.Split('#')[3]),
                       new MySqlParameter("@PanelID", mmd.Split('#')[4]),
                       new MySqlParameter("@RouteName", mmd.Split('#')[2]),
                       new MySqlParameter("@Route_ID", mmd.Split('#')[1]),
                       new MySqlParameter("@PreBookingID", mmd.Split('#')[0]));
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, @"UPDATE   " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking hc INNER JOIN `patient_labinvestigation_opd_prebooking` plo ON plo.PreBookingID=hc.PreBookingID SET hc.CentreID=@CentreID,hc.PanelID=@PanelID,hc.RouteName=@RouteName,hc.Route_ID=@Route_ID,plo.Panel_ID=@PanelID,plo.PreBookingCentreID=@CentreID  WHERE hc.PreBookingID=@PreBookingID",
                       new MySqlParameter("@CentreID", mmd.Split('#')[3]),
                       new MySqlParameter("@PanelID", mmd.Split('#')[4]),
                       new MySqlParameter("@RouteName", mmd.Split('#')[2]),
                       new MySqlParameter("@Route_ID", mmd.Split('#')[1]),
                       new MySqlParameter("@PreBookingID", mmd.Split('#')[0]));



                    // Update New Rate

                 DataTable dt=   MySqlHelper.ExecuteDataset(tnx, CommandType.Text, @"SELECT plo.itemid, plo.rate,plo.`DiscAmt`,plo.`GrossAmt`,plo.`NetAmt`,round( (plo.`DiscAmt`*100)/plo.`GrossAmt`) discper,pm.Panel_ID,pm.ReferenceCode,
                                                            get_item_rate(plo.itemid,pm.ReferenceCode,plo.createddate,pm.panel_id) newrate
                                                            FROM 
                                                             `patient_labinvestigation_opd_prebooking` plo 
                                                            INNER JOIN f_panel_master pm ON pm.`Panel_ID`=@PanelID
                                                            AND plo.PreBookingID=@PreBookingID and plo.itemid<>@HomeCollectionChargeItemID and plo.iscancel=0",
                                                             new MySqlParameter("@PanelID", mmd.Split('#')[4]),
                                                             new MySqlParameter("@PreBookingID", mmd.Split('#')[0]),
                                                             new MySqlParameter("@HomeCollectionChargeItemID", Resources.Resource.HomeCollectionChargeItemID)).Tables[0];

                 foreach (DataRow dw in dt.Rows)
                 {
                     if (dw["newrate"].ToString().Split('#')[0] == "0")
                     {
                         Exception ex = new Exception("Rate Not Found for New Droplocation Please Contact to Admin");
                         throw (ex);
                     }
                     else
                     {
                         var grossamt=Util.GetInt(dw["newrate"].ToString().Split('#')[0]);
                        // var discamt=Util.GetInt(grossamt) *(Util.GetInt(dw["discper"].ToString())/100);
                           var discamt = (Util.GetInt(grossamt) * Util.GetInt(dw["discper"].ToString())) / 100;
                         var netamt=grossamt-discamt;
                         MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, @"UPDATE `patient_labinvestigation_opd_prebooking` plo set rate=@rate,grossamt=@rate,discamt=@discamt,netamt=@netamt   WHERE plo.PreBookingID=@PreBookingID and itemid=@itemid",
                         new MySqlParameter("@itemid",dw["itemid"].ToString()),
                         new MySqlParameter("@rate",grossamt ),
                         new MySqlParameter("@discamt",discamt ),
                         new MySqlParameter("@netamt", netamt),
                         new MySqlParameter("@PreBookingID", mmd.Split('#')[0]));
                     }
                 }
                }




                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into  " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking_status (PreBookingID,CurrentStatus,CurrentStatusDate,EntryByID,EntryByName) values (@PreBookingID,@CurrentStatus,@CurrentStatusDate,@EntryByID,@EntryByName)",
               new MySqlParameter("@PreBookingID", mmd.Split('#')[0]),
               new MySqlParameter("@CurrentStatus", "DropLocation Change"),
               new MySqlParameter("@CurrentStatusDate", DateTime.Now),
               new MySqlParameter("@EntryByID", UserInfo.ID),
               new MySqlParameter("@EntryByName", UserInfo.LoginName));


                // Send Notification
                StringBuilder sbSMS = new StringBuilder();

                sbSMS.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_fcm_notification (PreBookingID, phelbotomistid,title,body,EntryDate,entrybyid,EntryByName)  ");
                sbSMS.Append(" VALUES ");
                sbSMS.Append(" (@mmd, @PhlebotomistID,'DropLocation Change','DropLocation Change For PrebookingId @mmd',now(),@ID,@UserInfo)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                    new MySqlParameter("@PhlebotomistID", PhlebotomistID),
                    new MySqlParameter("@mmd", mmd.Split('#')[0]),
                    new MySqlParameter("@ID", UserInfo.ID),
                    new MySqlParameter("@UserInfo", UserInfo.LoginName));


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
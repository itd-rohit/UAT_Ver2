﻿using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_HomeCollection : System.Web.UI.Page
{

    public int bookedmultipleslot = 1;
    public int roleid = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            roleid = UserInfo.RoleID;
            string uhid = Util.GetString(Request.QueryString["UHID"]);
            dtFrom.Text = DateTime.Now.AddDays(1).ToString("dd-MMM-yyyy");
            txtappdatere.Text = DateTime.Now.AddDays(1).ToString("dd-MMM-yyyy");
            if (UserInfo.RoleID == 212)
            {
                calAppDate.EndDate = DateTime.Now.AddDays(6);
            }
            else if (UserInfo.RoleID == 253)
            {
                calAppDate.EndDate = DateTime.Now.AddDays(3);
            }
            else
            {
                calAppDate.EndDate = DateTime.Now.AddDays(15);
            }
            calAppDate.StartDate = DateTime.Now;
            CalendarExtender1.StartDate = DateTime.Now;
            if (UserInfo.RoleID == 212)
            {
                CalendarExtender1.EndDate = DateTime.Now.AddDays(6);
            }
            else if (UserInfo.RoleID == 253)
            {
                CalendarExtender1.EndDate = DateTime.Now.AddDays(2);
            }
            else
            {
                CalendarExtender1.EndDate = DateTime.Now.AddDays(15);
            }
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                DataTable dt;
                if (Util.GetString(Request.QueryString["prebookingidnew"]) != string.Empty)
                {
                    dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, @"SELECT plo.`Landmark` Street_Name,pm.title, pm.Mobile, pm.patient_id,pm.pname,pm.age,pm.gender,plo.house_no ,
plo.stateid ,plo.cityid,plo.pincode,plo.localityid,DATE_FORMAT(pm.dob,'%d-%b-%Y')dob,DATE_FORMAT(pm.dob,'%Y-%m-%d') ddob,pm.ageyear,pm.agemonth,pm.agedays,
pm.TotalAgeInDays,pm.email,DATE_FORMAT(plo.samplecollectiondatetime,'%d-%b-%Y %h:%i %p') samplecollection,
IFNULL(Latitude,'0')Latitude,IFNULL(Longitude,0)Longitude 
FROM Patient_master pm
INNER JOIN `patient_labinvestigation_opd_prebooking` plo ON plo.`Patient_ID`=pm.`Patient_ID` AND plo.`PreBookingID`=@prebookingid
WHERE pm.patient_id=@uhid", new MySqlParameter("@uhid", uhid),
                            new MySqlParameter("@prebookingid", Util.GetString(Request.QueryString["prebookingidnew"]))).Tables[0];
                }
                else
                {
                    dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select '' samplecollection, Street_Name,title, Mobile, patient_id,pname,age,gender,house_no ,stateid,cityid,pincode,localityid,date_format(dob,'%d-%b-%Y')dob,dob ddob,ageyear,agemonth,agedays,TotalAgeInDays,email,ifnull(Latitude,'0')Latitude,ifnull(Longitude,0)Longitude from Patient_master where patient_id=@uhid", new MySqlParameter("@uhid", uhid)).Tables[0];

                }
                AllLoad_Data.bindState(ddlstate);
                AllLoad_Data.bindState(ddlstatehc);
                ddlstatehc.Items.Insert(0, new ListItem("Select", "0"));
                if (dt.Rows.Count > 0)
                {

                    if (dt.Rows[0]["samplecollection"].ToString() != string.Empty)
                    {
                        lbhomecollectiondatetime.Text = "Sample Collection DateTime : " + dt.Rows[0]["samplecollection"].ToString();
                    }
                    else
                    {
                        lbhomecollectiondatetime.Text = string.Empty;
                    }


                    txtpatientDOB.Text = dt.Rows[0]["dob"].ToString();
                    txtddob.Text = Util.GetDateTime(dt.Rows[0]["ddob"].ToString()).ToString("yyyy-MM-dd");
                    txtpatientid.Text = dt.Rows[0]["patient_id"].ToString();
                    txtpatienttitle.Text = dt.Rows[0]["title"].ToString();
                    txtpatientname.Text = dt.Rows[0]["pname"].ToString();
                    txtpatientgender.Text = dt.Rows[0]["gender"].ToString();
                    txtpatientaddress.Text = dt.Rows[0]["house_no"].ToString();
                    txtpatientaddresshc.Text = dt.Rows[0]["house_no"].ToString();
                    txtmobileno.Text = dt.Rows[0]["Mobile"].ToString();
                    txtemail.Text = dt.Rows[0]["email"].ToString();
                    txtLatitude.Text = dt.Rows[0]["Latitude"].ToString();
                    txtLongitude.Text = dt.Rows[0]["Longitude"].ToString();
		// ddlarea.SelectedValue = dt.Rows[0]["localityid"].ToString();
                    txtpatientlandmark.Text = dt.Rows[0]["Street_Name"].ToString();
                    txtpatientemailid.Text = dt.Rows[0]["email"].ToString();

                    ListItem selectedListItem = ddlstate.Items.FindByValue(dt.Rows[0]["stateid"].ToString());

                    if (selectedListItem != null)
                    {
                        selectedListItem.Selected = true;
                    }


                    AllLoad_Data.bindCity(ddlcity, Util.GetInt(ddlstate.SelectedValue));
                    ListItem selectedListItem1 = ddlcity.Items.FindByValue(dt.Rows[0]["cityid"].ToString());

                    if (selectedListItem1 != null)
                    {
                        selectedListItem1.Selected = true;
                    }
                    StringBuilder sb1 = new StringBuilder();
                    sb1.Append("  SELECT concat(hr.routeid,'#',hca.localityid,'#',pincode)routeid ,hr.`Route` Route FROM " + Util.getApp("HomeCollectionDB") + ".`hc_routemaster` hr  ");
                    sb1.Append("  INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping hca   ON hca.routeid=  hr.routeid ");
                    sb1.Append("  INNER JOIN f_locality fl on fl.id=hca.localityid ");
                    sb1.Append("  WHERE hr.cityid=@cityid AND isactive=1 group by hr.routeid order by hr.`Route` ");
                    ddlroute.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb1.ToString(),
                       new MySqlParameter("@cityid", dt.Rows[0]["cityid"].ToString())).Tables[0];

                    ddlroute.DataValueField = "routeid";
                    ddlroute.DataTextField = "Route";
                    ddlroute.DataBind();
                    ddlroute.Items.Insert(0, new ListItem("Change Route", "0"));


                    ddlarea.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,NAME FROM f_locality WHERE active=1 AND CityID=@CityID  and Active=1 order by name",
                                                     new MySqlParameter("@CityID", dt.Rows[0]["cityid"].ToString())).Tables[0];
                    ddlarea.DataValueField = "ID";
                    ddlarea.DataTextField = "NAME";
                    ddlarea.DataBind();
                    ListItem selectedListItem11 = ddlarea.Items.FindByValue(dt.Rows[0]["localityid"].ToString());

                    if (selectedListItem11 != null)
                    {
                        selectedListItem11.Selected = true;
                    }
		 //ddlarea.SelectedValue = dt.Rows[0]["localityid"].ToString();
                    txtpincode.Text = dt.Rows[0]["pincode"].ToString();
                    StringBuilder sb = new StringBuilder();
                    sb.Append("   ");
                    sb.Append(" SELECT concat(hr.route,'@',hr.routeid) route, GROUP_CONCAT(DISTINCT CONCAT(cm.centreid,'#',fpm.panel_id,'#',fpm.ReferenceCode,'#',fpm.Panel_Code,'#',ifnull(cm.email,''),'^',if(cm.type1='PCC',concat(cm.centre,'~',cm.COCO_FOCO),cm.centre)) ORDER BY cm.centreid  SEPARATOR '$')centreid, hcp.`phlebotomistId` ID, ");
                    sb.Append(" CONCAT(hcp.`Name`,' (',hcp.mobile,')')NAME ,'' HolidayDate ,hcp.istemp ");
                    sb.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hcp   ");
                    sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_area_phlebotomist_mapping` hcr   ");
                    sb.Append(" ON hcp.`phlebotomistid`=hcr.phlebotomistid AND hcr.`localityid`=@localityid   ");
                    sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_area_droplocation_mapping` hadm ON hadm.`localityid`=@localityid   ");
                    sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_area_route_mapping` harm ON harm.`localityid`=@localityid   ");
                    sb.Append(" INNER JOIN centre_master cm ON cm.centreid=hadm.`droplocationID`  ");
                    if (UserInfo.RoleID != 212)
                    {
                        bookedmultipleslot = 0;
                        sb.Append(" and cm.centreid=" + UserInfo.Centre + "");
                        ddlroute.Enabled = false;
                        ddldroplocation.Enabled = false;
                    }
                    sb.Append(" INNER JOIN f_panel_master fpm on fpm.Panel_ID=hadm.PanelID ");
                    sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".hc_routemaster hr ON hr.routeid=harm.routeid AND hr.isactive=1   ");
                    sb.Append(" GROUP BY hcp.phlebotomistid  ");

                    DataTable ph = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                               new MySqlParameter("@localityid", ddlarea.SelectedValue)).Tables[0];
                    if (ph.Rows.Count > 0)
                    {
                        foreach (string ss in ph.Rows[0]["centreid"].ToString().Split('$'))
                        {
                            ddldroplocation.Items.Add(new ListItem(ss.Split('^')[1], ss.Split('^')[0]));
                        }
                        if (ph.Rows[0]["route"].ToString() != string.Empty)
                        {
                            lbroute.Text = ph.Rows[0]["route"].ToString().Split('@')[0];
                            lbroute1.Text = ph.Rows[0]["route"].ToString().Split('@')[1];
                        }

                    }
                    else
                    {
                        lbmsg.Text = "No Drop Location Found Near Patient's Area";
                    }
                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
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

    [WebMethod(EnableSession = true)]
    public static string bindslot(string areaid, string pincode, string fromdate, string freeslot, string phelboid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            if (freeslot != string.Empty && phelboid != string.Empty)
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "delete from " + Util.getApp("HomeCollectionDB") + ".hc_occupied_slot where PhlebotomistID=@PhlebotomistID and AppDateTime=@AppDateTime ",
                             new MySqlParameter("@PhlebotomistID", phelboid),
                             new MySqlParameter("@AppDateTime", Util.GetDateTime(freeslot).ToString("yyyy-MM-dd HH:mm:ss")));
            }
            DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select StartTime,EndTime,AvgTime,NoofSlotForApp from f_locality where id=@areaid and Pincode=@Pincode and ishomecollection=1",
               new MySqlParameter("@areaid", areaid),
               new MySqlParameter("@Pincode", pincode)).Tables[0];
            if (dt1.Rows.Count == 0)
            {
                return "1#Slot Not Define for Selected Area and Pincode";

            }

            StringBuilder sb = new StringBuilder();
            sb.Append("   ");


            sb.Append(" SELECT concat(hr.route,'@',hr.routeid)route,GROUP_CONCAT(DISTINCT CONCAT(cm.centreid,'#',fpm.panel_id,'#',fpm.ReferenceCode,'#',fpm.Panel_Code,'#',ifnull(cm.email,''),'^',if(cm.type1='PCC',concat(cm.centre,'~',cm.COCO_FOCO),cm.centre)) ORDER BY cm.centreid  SEPARATOR '$')centreid, hcp.`phlebotomistId` ID, ");
            sb.Append(" CONCAT(hcp.`Name`,' (',hcp.mobile,')')NAME,hcp.istemp   ");
            sb.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hcp   ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_area_phlebotomist_mapping` hcr   ");
            sb.Append(" ON hcp.`phlebotomistid`=hcr.phlebotomistid AND hcr.`localityid`=" + areaid + "   ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_area_droplocation_mapping` hadm ON hadm.`localityid`=@localityid   ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_area_route_mapping` harm ON harm.`localityid`=@localityid   ");
            sb.Append(" INNER JOIN centre_master cm ON cm.centreid=hadm.`droplocationID`  ");
            if (UserInfo.RoleID != 212)
            {
                //sb.Append(" and cm.centreid=" + UserInfo.Centre + "");
            }
            sb.Append(" inner join f_panel_master fpm on fpm.Panel_ID=hadm.PanelID ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".hc_routemaster hr ON hr.routeid=harm.routeid AND hr.isactive=1   ");
            sb.Append(" where hcp.isactive=1 and if(hcp.istemp=1,@fromdate>=JoinFromDate and @fromdate<=jointodate,hcp.isactive=1 ) ");
            sb.Append(" GROUP BY hcp.phlebotomistid  ");

            DataTable ph = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@fromdate", Util.GetDateTime(fromdate).ToString("yyyy-MM-dd")),
               new MySqlParameter("@localityid", areaid)).Tables[0];
            if (ph.Rows.Count == 0)
            {
                return "1#Slot Not Define for Selected Area and Pincode";
            }

            DataTable dtre = new DataTable();
            dtre.Columns.Add("Timeslot");

            dt.Columns.Add("route");
            dt.Columns.Add("centreid");

            dt.Columns.Add("PhlebotomistID");
            dt.Columns.Add("PhlebotomistName");


            DateTime starttimeday, endtimeday;

            if (UserInfo.RoleID != 212)
            {

                DataTable dtpccslot = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select HCStartTime,HCEndTime from centre_master_pccslot where CentreID=@CentreID order by id ",
                   new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0];
                if (dtpccslot.Rows.Count > 0)
                {

                    foreach (DataRow dwpcc in dtpccslot.Rows)
                    {

                        starttimeday = DateTime.Parse(fromdate + " " + dwpcc["HCStartTime"].ToString());
                        endtimeday = DateTime.Parse(fromdate + " " + dwpcc["HCEndTime"].ToString());


                        int avgtime = Util.GetInt(dt1.Rows[0]["AvgTime"]);
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
                    }
                }
                else
                {
                    starttimeday = DateTime.Parse(fromdate + " " + dt1.Rows[0]["StartTime"].ToString());
                    endtimeday = DateTime.Parse(fromdate + " " + dt1.Rows[0]["EndTime"].ToString());

                    int avgtime = Util.GetInt(dt1.Rows[0]["AvgTime"]);
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
                }
            }
            else
            {
                starttimeday = DateTime.Parse(fromdate + " " + dt1.Rows[0]["StartTime"].ToString());
                endtimeday = DateTime.Parse(fromdate + " " + dt1.Rows[0]["EndTime"].ToString());
                int avgtime = Util.GetInt(dt1.Rows[0]["AvgTime"]);
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
            }
            string phid = string.Join(",", ph.Rows.OfType<DataRow>().Select(r => r["ID"].ToString()));
            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" SELECT phlebotomistid, ");
            if (UserInfo.RoleID != 212)
            {
                sb1.Append(" if(centreid=" + UserInfo.Centre + ", GROUP_CONCAT(DISTINCT CONCAT(patient_id,'#',patientname,'#',Address,'#',Mobileno,'#',Iscancel,'#',IsBooked,'#',PreBookingID,'#',if(vip=1,'Yes','No'),'#',if(HardCopyRequired=1,'Yes','No'),'#',locality,'#','1','#',(SELECT ROUND(SUM(NetAmt),2)NetAmt FROM `patient_labinvestigation_opd_prebooking` WHERE prebookingid=hc.PreBookingID AND IsCancel=0)) SEPARATOR '~'),");
                sb1.Append(" GROUP_CONCAT(DISTINCT CONCAT(patient_id,'#',patientname,'#',Address,'#',Mobileno,'#',Iscancel,'#',IsBooked,'#',PreBookingID,'#',if(vip=1,'Yes','No'),'#',if(HardCopyRequired=1,'Yes','No'),'#',locality,'#','0','#',(SELECT ROUND(SUM(NetAmt),2)NetAmt FROM `patient_labinvestigation_opd_prebooking` WHERE prebookingid=hc.PreBookingID AND IsCancel=0)) SEPARATOR '~')) ");
                sb1.Append(" pname, ");
            }
            else
            {
                sb1.Append(" GROUP_CONCAT(DISTINCT CONCAT(patient_id,'#',patientname,'#',Address,'#',Mobileno,'#',Iscancel,'#',IsBooked,'#',PreBookingID,'#',if(vip=1,'Yes','No'),'#',if(HardCopyRequired=1,'Yes','No'),'#',locality,'#','1','#',(SELECT ROUND(SUM(NetAmt),2)NetAmt FROM `patient_labinvestigation_opd_prebooking` WHERE prebookingid=hc.PreBookingID AND IsCancel=0)) SEPARATOR '~')pname, ");
            }
            sb1.Append(" DATE_FORMAT(appdatetime,'%H:%i:%s') apptime");
            sb1.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking hc WHERE  phlebotomistid in (" + phid + ") and ");
            sb1.Append(" date(AppDateTime)='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + "' and iscancel=0  ");
            sb1.Append(" GROUP BY phlebotomistid,DATE_FORMAT(appdatetime,'%H:%i:%s')");
            using (DataTable dttime = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb1.ToString()).Tables[0])
            {
                foreach (DataRow dw in ph.Rows)
                {
                    DataRow dwc = dt.NewRow();
                    dwc["route"] = dw["route"].ToString().ToUpper();
                    dwc["centreid"] = dw["centreid"].ToString().ToUpper();

                    dwc["PhlebotomistID"] = string.Concat(dw["ID"].ToString(), "#", dt1.Rows[0]["NoofSlotForApp"].ToString(), "#", dw["istemp"].ToString());
                    dwc["PhlebotomistName"] = dw["Name"].ToString().ToUpper();
                    foreach (DataColumn dc in dt.Columns)
                    {
                        if (dc.ColumnName != "PhlebotomistID" && dc.ColumnName != "PhlebotomistName" && dc.ColumnName != "route" && dc.ColumnName != "centreid" && dc.ColumnName != "centre")
                        {
                            try
                            {
                                string ss = "phlebotomistid=" + dw["ID"].ToString() + " AND apptime='" + Util.GetDateTime(dc.ColumnName).ToString("HH:mm:ss") + "'";
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
                }
                return JsonConvert.SerializeObject(dt);
            }
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
    public static string bindtest(string parametername, string panelid, string PrescribeDate)
    {

        int refpanelid = Util.GetInt(StockReports.ExecuteScalar("select ReferenceCode from f_panel_master where Panel_ID=" + panelid + ""));
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.itemid itemid,typeName itemname,IF(subcategoryid='15','Package','Test') BType,im.testCode, ");
        sb.Append(" IFNULL((SELECT get_item_rate(im.`ItemID`,'" + refpanelid + "',IF('" + PrescribeDate + "' <>'','" + Util.GetDateTime(PrescribeDate).ToString("yyyy-MM-dd") + "',  CURRENT_DATE()),'" + refpanelid + "')),0)Rate,  ");
        sb.Append(" 0 DiscPer FROM f_itemmaster im  ");
        sb.Append(" WHERE isActive=1 HAVING IFNULL(Rate,0)<>0 and typename like '" + parametername + "%'  ORDER BY typename LIMIT 20 ");
        return JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public static string savedata(List<Insert_PreBooking> datatosave, string AppDateTime, int updatepatient, int HardCopyRequired, int PhlebotomistID, string Latitude, string Longitude, string ispermanetaddress, string ReceiptRequired, string Alternatemobileno, string Client, string Paymentmode, string SourceofCollection, string Phelebotomistname, string emailidpcc, string centrename, string RouteName, string RouteID, string deliverych, string endtime, string oldprebookingid, string hcrequestid, string followupcallid, string phelboshare)
    {

        if (Paymentmode == "null" || Paymentmode == string.Empty || Paymentmode == null)
        {
            Paymentmode = "Credit";
        }
        int googleapi = 0;
        if (updatepatient == 1)
        {
            try
            {
                string address = datatosave[0].House_No + " " + datatosave[0].Locality + " " + datatosave[0].City + " " + datatosave[0].State + " " + datatosave[0].Pincode;
                string url = "https://maps.googleapis.com/maps/api/geocode/xml?address=" + address + "&key=AIzaSyBVtUztjJy215wJb3VbmUWHoCfGR7anRgE";
                WebRequest request = WebRequest.Create(url);
                using (WebResponse response = (HttpWebResponse)request.GetResponse())
                {
                    using (StreamReader reader = new StreamReader(response.GetResponseStream(), Encoding.UTF8))
                    {
                        DataSet dsResult = new DataSet();
                        dsResult.ReadXml(reader);
                        if (dsResult.Tables["GeocodeResponse"].Rows[0]["status"].ToString() == "OK")
                        {
                            DataTable dtCoordinates = new DataTable();
                            dtCoordinates.Columns.AddRange(new DataColumn[4] { 
                                new DataColumn("Id", typeof(int)),
                                new DataColumn("Address", typeof(string)),
                                new DataColumn("Latitude",typeof(string)),
                                new DataColumn("Longitude",typeof(string)) });
                            foreach (DataRow row in dsResult.Tables["result"].Rows)
                            {
                                string geometry_id = dsResult.Tables["geometry"].Select("result_id = " + row["result_id"].ToString())[0]["geometry_id"].ToString();
                                DataRow location = dsResult.Tables["location"].Select("geometry_id = " + geometry_id)[0];
                                dtCoordinates.Rows.Add(row["result_id"], row["formatted_address"], location["lat"], location["lng"]);
                            }
                            if (dtCoordinates.Rows.Count > 0)
                            {
                                Latitude = dtCoordinates.Rows[0]["Latitude"].ToString();
                                Longitude = dtCoordinates.Rows[0]["Longitude"].ToString();
                                googleapi = 1;
                            }
                        }
                        else
                        {
                            //return "Address Not Correct. Please Enter Correct Address. gooogle response is Fail";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return ex.Message;
            }
        }

        if (Latitude == "0" || Latitude == string.Empty)
        {
           // return "Address Not Correct. Please Enter Correct Address. latitude is 0";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        MySqlConnection conhc = UtilHC.GetMySqlCon();
        conhc.Open();
        MySqlTransaction tnxhc = conhc.BeginTransaction(IsolationLevel.Serializable);


        try
        {
            string PreBookingID = string.Empty;
            if (oldprebookingid != string.Empty)
            {
                PreBookingID = oldprebookingid;
            }
            else
            {
                PreBookingID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select get_Tran_id('PreBookingID') "));
            }
            string chars = "0123456789";
            char[] stringChars = new char[4];
            Random random = new Random();

            for (int i = 0; i < stringChars.Length; i++)
            {
                stringChars[i] = chars[random.Next(chars.Length)];
            }

            string finalString = new String(stringChars);
            if (oldprebookingid == string.Empty)
            {
                foreach (Insert_PreBooking hcb in datatosave)
                {
                    Insert_PreBooking PreBooking = new Insert_PreBooking(tnx);
                    PreBooking.Title = hcb.Title;
                    PreBooking.Patient_ID = hcb.Patient_ID;
                    PreBooking.PName = hcb.PName.ToUpper();
                    PreBooking.House_No = hcb.House_No;
                    PreBooking.LocalityID = hcb.LocalityID;
                    PreBooking.Locality = hcb.Locality;
                    PreBooking.CityID = hcb.CityID;
                    PreBooking.City = hcb.City;
                    PreBooking.StateID = hcb.StateID;
                    PreBooking.State = hcb.State;
                    PreBooking.Mobile = hcb.Mobile;
                    PreBooking.Pincode = hcb.Pincode;
                    PreBooking.Email = hcb.Email;
                    PreBooking.DOB =  Util.GetDateTime(hcb.DOB);
                    PreBooking.Landmark = hcb.Landmark;
                    PreBooking.Age = hcb.Age;
                    PreBooking.AgeYear = hcb.AgeYear;
                    PreBooking.AgeMonth = hcb.AgeMonth;
                    PreBooking.AgeDays = hcb.AgeDays;
                    PreBooking.TotalAgeInDays = hcb.TotalAgeInDays;
                    PreBooking.Gender = hcb.Gender;
                    PreBooking.VisitType = "Home Collection";
                    PreBooking.VIP = hcb.VIP;
                    PreBooking.PatientSource = "Home Visit";
                    if (HardCopyRequired == 1)
                    {
                        PreBooking.DispatchModeName = "Courier";
                    }
                    else
                    {
                        PreBooking.DispatchModeName = "Email";
                    }

                    PreBooking.Remarks = hcb.Remarks;
                    PreBooking.Panel_ID = hcb.Panel_ID;
                    PreBooking.PreBookingID = PreBookingID;
                    PreBooking.CreatedBy = UserInfo.LoginName;
                    PreBooking.CreatedByID = UserInfo.ID;
                    PreBooking.PaymentMode = Paymentmode;
                    PreBooking.SampleCollectionDateTime = DateTime.Now;
                    PreBooking.LabRefrenceNo = string.Empty;
                    PreBooking.PreBookingCentreID = hcb.PreBookingCentreID;
                    PreBooking.GrossAmt = hcb.GrossAmt;
                    PreBooking.NetAmt = hcb.NetAmt;
                    PreBooking.DiscAmt = hcb.DiscAmt;
                    PreBooking.PaidAmt = 0;
                    PreBooking.PaymentRefNo = string.Empty;
                    PreBooking.VisitTypeID = 1;
                    PreBooking.Sender = "Home Collection";
                    PreBooking.IsConfirm = 0;
                    PreBooking.RefDoctor = hcb.RefDoctor;
                    PreBooking.DoctorID = hcb.DoctorID;
                    PreBooking.OtherDoctor = hcb.OtherDoctor;



                    PreBooking.ItemId = hcb.ItemId;
                    PreBooking.ItemName = hcb.ItemName;
                    PreBooking.Rate = hcb.Rate;
                    PreBooking.TestCode = hcb.TestCode;
                    PreBooking.SubCategoryID = hcb.SubCategoryID; ;
                    PreBooking.IsPackage = (PreBooking.SubCategoryID == 15) ? 1 : 0;
                    PreBooking.DiscountTypeID = hcb.DiscountTypeID;
                    PreBooking.IsHomeCollection = 1;
                    PreBooking.DiscAppBy = hcb.DiscAppBy;
                    PreBooking.DiscAppByID = hcb.DiscAppByID;
                    PreBooking.DiscReason = hcb.DiscReason;
                    PreBooking.MRP = hcb.MRP;
                    PreBooking.Insert();


                }

                if (Util.GetDecimal(deliverych) > 0)
                {
                    Insert_PreBooking PreBooking = new Insert_PreBooking(tnx);
                    PreBooking.Title = datatosave[0].Title;
                    PreBooking.Patient_ID = datatosave[0].Patient_ID;
                    PreBooking.PName = datatosave[0].PName.ToUpper();
                    PreBooking.House_No = datatosave[0].House_No;
                    PreBooking.LocalityID = datatosave[0].LocalityID;
                    PreBooking.Locality = datatosave[0].Locality;
                    PreBooking.CityID = datatosave[0].CityID;
                    PreBooking.City = datatosave[0].City;
                    PreBooking.StateID = datatosave[0].StateID;
                    PreBooking.State = datatosave[0].State;
                    PreBooking.Mobile = datatosave[0].Mobile;
                    PreBooking.Pincode = datatosave[0].Pincode;
                    PreBooking.Email = datatosave[0].Email;
                    PreBooking.DOB = Util.GetDateTime(datatosave[0].DOB);
                    PreBooking.Landmark = datatosave[0].Landmark;
                    PreBooking.Age = datatosave[0].Age;
                    PreBooking.AgeYear = datatosave[0].AgeYear;
                    PreBooking.AgeMonth = datatosave[0].AgeMonth;
                    PreBooking.AgeDays = datatosave[0].AgeDays;
                    PreBooking.TotalAgeInDays = datatosave[0].TotalAgeInDays;
                    PreBooking.Gender = datatosave[0].Gender;
                    PreBooking.VisitType = "Home Collection";
                    PreBooking.VIP = datatosave[0].VIP;
                    PreBooking.PatientSource = "Home Visit";
                    if (HardCopyRequired == 1)
                    {
                        PreBooking.DispatchModeName = "Courier";
                    }
                    else
                    {
                        PreBooking.DispatchModeName = "Email";
                    }

                    PreBooking.Remarks = datatosave[0].Remarks;
                    PreBooking.Panel_ID = datatosave[0].Panel_ID;
                    PreBooking.PreBookingID = PreBookingID;
                    PreBooking.CreatedBy = UserInfo.LoginName;
                    PreBooking.CreatedByID = UserInfo.ID;
                    PreBooking.PaymentMode = Paymentmode;
                    PreBooking.SampleCollectionDateTime = DateTime.Now;
                    PreBooking.LabRefrenceNo = string.Empty;
                    PreBooking.PreBookingCentreID = datatosave[0].PreBookingCentreID;
                    PreBooking.GrossAmt = Util.GetDecimal(deliverych);
                    PreBooking.NetAmt = Util.GetDecimal(deliverych);
                    PreBooking.DiscAmt = 0;
                    PreBooking.PaidAmt = 0;
                    PreBooking.PaymentRefNo = string.Empty;
                    PreBooking.VisitTypeID = 1;
                    PreBooking.Sender = "Home Collection";
                    PreBooking.IsConfirm = 0;
                    PreBooking.RefDoctor = datatosave[0].RefDoctor;
                    PreBooking.DoctorID = datatosave[0].DoctorID;
                    PreBooking.OtherDoctor = datatosave[0].OtherDoctor;



                    PreBooking.ItemId =Util.GetInt( Resources.Resource.HomeCollectionChargeItemID);
                    PreBooking.ItemName = Phelebotomistname.Split('(')[0].Trim();
                    PreBooking.Rate = Util.GetDecimal(deliverych);
                    PreBooking.TestCode = string.Empty;
                    PreBooking.SubCategoryID = 21;
                    PreBooking.IsPackage = (PreBooking.SubCategoryID == 15) ? 1 : 0;
                    PreBooking.DiscountTypeID = 0;
                    PreBooking.IsHomeCollection = 1;
                    PreBooking.DiscAppBy = string.Empty;
                    PreBooking.DiscAppByID = 0;
                    PreBooking.DiscReason = string.Empty;
                    PreBooking.MRP = 0;
                    PreBooking.Insert();
                }
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labinvestigation_opd_prebooking set IsHomeCollection=1,PreBookingCentreID=@PreBookingCentreID where PreBookingID=@PreBookingID ",
                            new MySqlParameter("@PreBookingID", PreBookingID),
                            new MySqlParameter("@PreBookingCentreID", datatosave[0].PreBookingCentreID));
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labinvestigation_opd_prebooking set ItemName=@ItemName  where PreBookingID=@PreBookingID and itemid=@itemid",
                            new MySqlParameter("@PreBookingID", PreBookingID),
                            new MySqlParameter("@ItemName", Phelebotomistname.Split('(')[0].Trim()),
                            new MySqlParameter("@itemid", Resources.Resource.HomeCollectionChargeItemID));
            }

            MySqlHelper.ExecuteNonQuery(tnxhc, CommandType.Text, "insert into " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking (patient_id,PatientName,MobileNo,PreBookingID,Address,localityid,locality,CityID,City,StateID,State,Pincode,CentreID,PanelID,PhlebotomistID,AppDateTime,AppEndDateTime,EntryDateTime,EntryByID,EntryByName,VIP,HardCopyRequired,VerificationCode,Latitude,Longitude,IsPermanentAddress,ReceiptRequired,Alternatemobileno,Client,Paymentmode,SourceofCollection,CurrentStatus,CurrentStatusDate,RouteName,Route_ID,PhleboCharge) values (@patient_id,@PatientName,@MobileNo,@PreBookingID,@Address,@localityid,@locality,@CityID,@City,@StateID,@State,@Pincode,@CentreID,@PanelID,@PhlebotomistID,@AppDateTime,@AppEndDateTime,@EntryDateTime,@EntryByID,@EntryByName,@VIP,@HardCopyRequired,@VerificationCode,@Latitude,@Longitude,@IsPermanentAddress,@ReceiptRequired,@Alternatemobileno,@Client,@Paymentmode,@SourceofCollection,@CurrentStatus,@CurrentStatusDate,@RouteName,@RouteID,@PhleboCharge)",
                        new MySqlParameter("@patient_id", datatosave[0].Patient_ID),
                        new MySqlParameter("@PatientName", datatosave[0].Title + datatosave[0].PName.ToUpper()),
                        new MySqlParameter("@MobileNo", datatosave[0].Mobile),
                        new MySqlParameter("@PreBookingID", PreBookingID),
                        new MySqlParameter("@Address", datatosave[0].House_No),
                        new MySqlParameter("@localityid", datatosave[0].LocalityID),
                        new MySqlParameter("@locality", datatosave[0].Locality),
                        new MySqlParameter("@CityID", datatosave[0].CityID),
                        new MySqlParameter("@City", datatosave[0].City),
                        new MySqlParameter("@StateID", datatosave[0].StateID),
                        new MySqlParameter("@State", datatosave[0].State),
                        new MySqlParameter("@Pincode", datatosave[0].Pincode),
                        new MySqlParameter("@CentreID", datatosave[0].PreBookingCentreID),
                        new MySqlParameter("@PanelID", datatosave[0].Panel_ID),
                        new MySqlParameter("@PhlebotomistID", PhlebotomistID),
                        new MySqlParameter("@AppDateTime", Util.GetDateTime(AppDateTime)),
                        new MySqlParameter("@AppEndDateTime", Util.GetDateTime(AppDateTime).AddMinutes(Util.GetInt(endtime) * 10)),
                        new MySqlParameter("@EntryDateTime", DateTime.Now),
                        new MySqlParameter("@EntryByID", UserInfo.ID),
                        new MySqlParameter("@EntryByName", UserInfo.LoginName),
                        new MySqlParameter("@VIP", datatosave[0].VIP),
                        new MySqlParameter("@HardCopyRequired", HardCopyRequired),
                        new MySqlParameter("@VerificationCode", finalString),
                        new MySqlParameter("@Latitude", Latitude),
                        new MySqlParameter("@Longitude", Longitude),
                        new MySqlParameter("@IsPermanentAddress", ispermanetaddress),
                        new MySqlParameter("@ReceiptRequired", ReceiptRequired),
                        new MySqlParameter("@Alternatemobileno", Alternatemobileno),
                        new MySqlParameter("@Client", Client),
                        new MySqlParameter("@Paymentmode", Paymentmode),
                        new MySqlParameter("@SourceofCollection", SourceofCollection),
                        new MySqlParameter("@CurrentStatus", "Pending"),
                        new MySqlParameter("@CurrentStatusDate", DateTime.Now),
                        new MySqlParameter("@RouteName", RouteName),
                        new MySqlParameter("@RouteID", RouteID),
                        new MySqlParameter("@PhleboCharge", phelboshare));



            MySqlHelper.ExecuteNonQuery(tnxhc, CommandType.Text, "insert into " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking_status (PreBookingID,CurrentStatus,CurrentStatusDate,EntryByID,EntryByName) values (@PreBookingID,@CurrentStatus,@CurrentStatusDate,@EntryByID,@EntryByName)",
                        new MySqlParameter("@PreBookingID", PreBookingID),
                        new MySqlParameter("@CurrentStatus", "Pending"),
                        new MySqlParameter("@CurrentStatusDate", DateTime.Now),
                        new MySqlParameter("@EntryByID", UserInfo.ID),
                        new MySqlParameter("@EntryByName", UserInfo.LoginName));

            string custmercareno = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT customercareno FROM city_master WHERE id=@CityID",
                                                              new MySqlParameter("@CityID", datatosave[0].CityID)));
            if (custmercareno == string.Empty)
            {
                custmercareno = Resources.Resource.HomeCollectionCustomerCare;
            }
            // First SMS

            StringBuilder smsText = new StringBuilder();
            StringBuilder sbSMS = new StringBuilder();

            String[] puplist = Util.getApp("PUPListForNewSMS").Split(',');

            string panel_id = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select panel_id from patient_labinvestigation_opd_prebooking where prebookingid=@prebookingid limit 1", new MySqlParameter("@prebookingid", PreBookingID)));

            string phlebotomis_mobile = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT mobile FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` WHERE phlebotomistid=@phlebotomistid limit 1",
                                                                   new MySqlParameter("@phlebotomistid", PhlebotomistID)));

            if (Array.IndexOf(puplist, panel_id) == -1)
            {
                smsText.Append(Util.getApp("BookSlotSMS"));
            }
            else
            {
                smsText.Append(Util.getApp("BookSlotSMSPUP"));
            }

            smsText.Replace("{Pname}", datatosave[0].Title + datatosave[0].PName.ToUpper());
            smsText.Replace("{BookingTime}", Util.GetDateTime(AppDateTime).ToString("hh:mm tt"));
            smsText.Replace("{BookingDate}", Util.GetDateTime(AppDateTime).ToString("dd-MMM-yyyy"));
            smsText.Replace("{Phelbotomistname}", Util.GetString(Phelebotomistname));
            smsText.Replace("{Totalamt}", Util.GetString(datatosave.Sum(p => p.NetAmt) + Util.GetDecimal(deliverych)));
            smsText.Replace("{OTP}", Util.GetString(finalString));
            smsText.Replace("{Paymentmode}", Util.GetString(Paymentmode));
            smsText.Replace("{custmercareno}", Util.GetString(custmercareno));
            smsText.Replace("{phlebotomis_mobile}", Util.GetString(phlebotomis_mobile));
            try
            {
                sbSMS = new StringBuilder();
                sbSMS.Append(" INSERT INTO " + Util.getApp("HomeCollectionDB") + ".sms(MOBILE_NO,SMS_TEXT,IsSend,UserID,EntDate,SMS_Type,LedgerTransactionID,LabObservation_ID,UpdateDate) ");
                sbSMS.Append(" values(@MobileNo,@smsText,'1','1',now(),'HCBooking','0','0',now()) ");

                Sms_Host sm = new Sms_Host();
                sm._Msg = smsText.ToString();
                sm._SmsTo = Util.GetString(datatosave[0].Mobile);
                sm.sendSmsHomeCollection();
                MySqlHelper.ExecuteNonQuery(tnxhc, CommandType.Text, sbSMS.ToString(),
                            new MySqlParameter("@MobileNo", Util.GetString(datatosave[0].Mobile)),
                            new MySqlParameter("@smsText", smsText));
            }
            catch
            {
                sbSMS = new StringBuilder();
                sbSMS.Append(" INSERT INTO " + Util.getApp("HomeCollectionDB") + ".sms(MOBILE_NO,SMS_TEXT,IsSend,UserID,EntDate,SMS_Type,LedgerTransactionID,LabObservation_ID) ");
                sbSMS.Append(" values(@MobileNo,@smsText,'0','1',NOW(),'HCBooking','0','0') ");
                MySqlHelper.ExecuteNonQuery(tnxhc, CommandType.Text, sbSMS.ToString(),
                            new MySqlParameter("@MobileNo", Util.GetString(datatosave[0].Mobile)),
                            new MySqlParameter("@smsText", smsText));
            }
            // Email To Patient
            if (datatosave[0].Email != string.Empty)
            {
                sbSMS = new StringBuilder();
                sbSMS.Append(" INSERT INTO " + Util.getApp("HomeCollectionDB") + ".hc_email_sender(PreBookingID,EmailID,EmailIDCC,EmailIDBCC,Subject,EmailBody,EmailType,EmailReceiver,EntryDateTime,EntryByID,EntryByName) ");
                sbSMS.Append(" values(@PreBookingID, @EmailID,'','','HomeCollection Confirmation',@EmailBody,'HomeCollectionBooking','Patient',now(),@EntryByID,@EntryByName) ");
                MySqlHelper.ExecuteNonQuery(tnxhc, CommandType.Text, sbSMS.ToString(),
                            new MySqlParameter("@PreBookingID", PreBookingID),
                            new MySqlParameter("@EmailBody", smsText.ToString()),
                            new MySqlParameter("@EntryByID", UserInfo.ID),
                            new MySqlParameter("@EntryByName", UserInfo.LoginName),
                            new MySqlParameter("@EmailID", Util.GetString(datatosave[0].Email)));
            }
            // Email To PCC
            if (emailidpcc != string.Empty)
            {
                smsText = new StringBuilder();
                sbSMS = new StringBuilder();
                smsText.Append("Dear <CentreName>,<br/>");
                smsText.Append("HC booked <Pname> <Totalamt> Customer contact number <Pmobile> with <br/> ");
                smsText.Append("<testlist> <br/>   ");
                smsText.Append("for your PCC/Centre on <BookingDate> <BookingTime> <br/>");
                smsText.Append("Phlebotomist details <Phelbotomistname>");
                smsText.Replace("<CentreName>", centrename);
                smsText.Replace("<Pname>", datatosave[0].Title + datatosave[0].PName.ToUpper());
                smsText.Replace("<Pmobile>", datatosave[0].Mobile);
                smsText.Replace("<BookingTime>", Util.GetDateTime(AppDateTime).ToString("hh:mm tt"));
                smsText.Replace("<BookingDate>", Util.GetDateTime(AppDateTime).ToString("dd-MMM-yyyy"));
                smsText.Replace("<Phelbotomistname>", Util.GetString(Phelebotomistname));
                smsText.Replace("<Totalamt>", Util.GetString(datatosave.Sum(p => p.NetAmt)));
                smsText.Replace("<testlist>", String.Join(",", datatosave.Select(p => p.ItemName).ToList()));

                sbSMS.Append(" INSERT INTO " + Util.getApp("HomeCollectionDB") + ".hc_email_sender(PreBookingID, EmailID,EmailIDCC,EmailIDBCC,Subject,EmailBody,EmailType,EmailReceiver,EntryDateTime,EntryByID,EntryByName) ");
                sbSMS.Append(" values(@PreBookingID,@EmailID,'','','HomeCollection Confirmation',@EmailBody,'HomeCollectionBooking','PCC',now(),@EntryByID,@EntryByName) ");
                MySqlHelper.ExecuteNonQuery(tnxhc, CommandType.Text, sbSMS.ToString(),
                            new MySqlParameter("@PreBookingID", PreBookingID),
                            new MySqlParameter("@EmailID", Util.GetString(emailidpcc)),
                            new MySqlParameter("@EmailBody", smsText.ToString()),
                            new MySqlParameter("@EntryByID", UserInfo.ID),
                            new MySqlParameter("@EntryByName", UserInfo.LoginName));
            }

            // Send Notification
            sbSMS = new StringBuilder();

            sbSMS.Append(" INSERT INTO " + Util.getApp("HomeCollectionDB") + ".hc_fcm_notification (PreBookingID,phelbotomistid,title,body,EntryDate,entrybyid,EntryByName)  ");
            sbSMS.Append(" VALUES ");
            sbSMS.Append(" (@PreBookingID, @PhlebotomistID,'New HomeCollection',@body,now(),@EntryByID,@EntryByName)");
            MySqlHelper.ExecuteNonQuery(tnxhc, CommandType.Text, sbSMS.ToString(),
                           new MySqlParameter("@PreBookingID", PreBookingID),
                           new MySqlParameter("@PhlebotomistID", PhlebotomistID),
                           new MySqlParameter("@body", string.Concat("New HomeCollection Booked For You at ", Util.GetDateTime(AppDateTime).ToString("dd-MMM-yyyy hh:mm tt"))),
                           new MySqlParameter("@EntryByID", UserInfo.ID),
                           new MySqlParameter("@EntryByName", UserInfo.LoginName));



            if (updatepatient == 1)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE patient_master set localityid=@localityid,Locality=@Locality,cityid=@cityid,City=@City,stateid=@stateid,State=@State");
                sb.Append(" ,pincode=@pincode,House_No=@House_No,UpdateName=@UpdateName,Updatedate=@Updatedate,UpdateID=@UpdateID,UpdateRemarks=@UpdateRemarks");
                sb.Append(" ,Street_Name=@Street_Name,Email=@Email where patient_id=@patient_id");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@localityid", datatosave[0].LocalityID),
                            new MySqlParameter("@Locality", datatosave[0].Locality),
                            new MySqlParameter("@City", datatosave[0].City),
                            new MySqlParameter("@cityid", datatosave[0].CityID),
                            new MySqlParameter("@stateid", datatosave[0].StateID),
                            new MySqlParameter("@State", datatosave[0].State),
                            new MySqlParameter("@pincode", datatosave[0].Pincode),
                            new MySqlParameter("@House_No", datatosave[0].House_No),
                            new MySqlParameter("@patient_id", datatosave[0].Patient_ID),
                            new MySqlParameter("@UpdateName", UserInfo.LoginName),
                            new MySqlParameter("@Updatedate", DateTime.Now),
                            new MySqlParameter("@UpdateID", UserInfo.ID),
                            new MySqlParameter("@Street_Name", datatosave[0].Landmark),
                            new MySqlParameter("@Email", datatosave[0].Email),
                            new MySqlParameter("@UpdateRemarks", "Update For Home Collection")
                    );
            }
            if (ispermanetaddress == "1" && googleapi == 1)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_master SET Latitude=@Latitude,Longitude=@Longitude where patient_id=@patient_id",
                            new MySqlParameter("@Latitude", Latitude),
                            new MySqlParameter("@Longitude", Longitude),
                            new MySqlParameter("@patient_id", datatosave[0].Patient_ID));
            }


            Patient_Estimate_Log pel = new Patient_Estimate_Log(tnxhc);
            pel.Mobile = datatosave[0].Mobile;
            pel.Name = datatosave[0].PName;
            pel.Remarks = "HomeCollection Registration";
            pel.RemarksID = 1;
            pel.UserID = UserInfo.ID;
            pel.UserName = UserInfo.LoginName;
            pel.Call_By = "Patient";
            pel.Call_By_ID = datatosave[0].Patient_ID;
            pel.Call_Type = "HomeCollection";
            pel.CentreID = Util.GetString(datatosave[0].PreBookingCentreID);
            pel.Insert();



            if (Util.GetString(hcrequestid) != string.Empty)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" update call_whatsapp_homecollection SET IsCallDone=@IsCallDone,CallDoneDateTime=@CallDoneDateTime,CallDoneByName=@CallDoneByName,");
                sb.Append(" CallDoneByID=@CallDoneByID,CurrentAction=@CurrentAction,NextAction=@NextAction,IsClose=@IsClose,ActionRemark=@ActionRemark,");
                sb.Append(" PrebookingID=@PrebookingID,HomeCollectionBooked=@HomeCollectionBooked,HomeCollectionBookDateTime=@HomeCollectionBookDateTime,");
                sb.Append(" HomeCollectionBookBy=@HomeCollectionBookBy");
                sb.Append("  where id=@id");

                MySqlHelper.ExecuteNonQuery(tnxhc, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@IsCallDone", "1"),
                            new MySqlParameter("@CallDoneDateTime", DateTime.Now),
                            new MySqlParameter("@CallDoneByName", UserInfo.LoginName),
                            new MySqlParameter("@CallDoneByID", UserInfo.ID),
                            new MySqlParameter("@CurrentAction", "Home Collection Booked"),
                            new MySqlParameter("@NextAction", "Close"),
                            new MySqlParameter("@IsClose", "1"),
                            new MySqlParameter("@ActionRemark", "Home Collection Booked"),
                            new MySqlParameter("@PrebookingID", PreBookingID),
                            new MySqlParameter("@HomeCollectionBooked", "1"),
                            new MySqlParameter("@HomeCollectionBookDateTime", DateTime.Now),
                            new MySqlParameter("@HomeCollectionBookBy", UserInfo.LoginName),
                            new MySqlParameter("@id", Util.GetString(hcrequestid)));
            }



            if (Util.GetString(followupcallid) != string.Empty)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" update " + Util.getApp("HomeCollectionDB") + ".call_productmaster_detail set PreBookingID=@PreBookingID ");
                sb.Append("  where id=@id ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PrebookingID", PreBookingID),
                            new MySqlParameter("@id", Util.GetString(followupcallid)));

                sb = new StringBuilder();
                sb.Append(" update patient_labinvestigation_opd_prebooking set CallId=@followupcallid ");
                sb.Append("  where PreBookingID=@PreBookingID ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@followupcallid", Util.GetString(followupcallid)),
                            new MySqlParameter("@PrebookingID", PreBookingID)
                  );
            }


            tnx.Commit();
            tnxhc.Commit();
            return "1";
        }
        catch (Exception ex)
        {

            tnx.Rollback();
            tnxhc.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            if (ex.Message.Contains("Duplicate Entry"))
            {
                return "Home Collection Already Saved";
            }
            else
            {
                return Util.GetString(ex.GetBaseException());
            }

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();

            tnxhc.Dispose();
            conhc.Close();
            conhc.Dispose();

        }
    }


    [WebMethod(EnableSession = true)]
    public static string SearchRecords(string philboid, string appdatettime)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            using (DataTable count = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT id,username,date_format(EntryDateTime,'%d-%b-%Y %h:%i %p') EntryDate from  " + Util.getApp("HomeCollectionDB") + ".hc_occupied_slot where PhlebotomistID=@PhlebotomistID and AppDateTime=@AppDateTime ORDER BY id DESC",
                 new MySqlParameter("@PhlebotomistID", philboid),
                 new MySqlParameter("@AppDateTime", Util.GetDateTime(appdatettime).ToString("yyyy-MM-dd HH:mm:ss"))).Tables[0])
            {
                if (count.Rows.Count > 0)
                {
                    return string.Concat("-1#", count.Rows[0]["username"].ToString(), "^", count.Rows[0]["EntryDate"].ToString());
                }
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "insert into " + Util.getApp("HomeCollectionDB") + ".hc_occupied_slot(PhlebotomistID,AppDateTime,EntryDateTime,UserID,UserName) values (@PhlebotomistID,@AppDateTime,now(),@UserID,@UserName)",
                            new MySqlParameter("@PhlebotomistID", philboid),
                            new MySqlParameter("@AppDateTime", Util.GetDateTime(appdatettime).ToString("yyyy-MM-dd HH:mm:ss")),
                            new MySqlParameter("@UserID", UserInfo.ID),
                            new MySqlParameter("@UserName", UserInfo.LoginName));

                StringBuilder sb = new StringBuilder();

                sb.Append("  SELECT plo.Patient_ID, plo.prebookingid,DATE_FORMAT(hc.appdatetime,'%d-%b-%Y %H:%i:%s')appdatetime, ");
                sb.Append("  CONCAT(title,pname) pname,plo.mobile,concat(age,'/',gender)pinfo,house_no,plo.locality,plo.pincode, ");
                sb.Append("  GROUP_CONCAT(itemname) testname,SUM(grossamt) rate,SUM(discamt) discamt,SUM(netamt) netamt, ");
                sb.Append("  hc.currentstatus `status`, ");
                sb.Append("  (CASE WHEN hc.iscancel=1 THEN 'pink' WHEN hc.isbooked=1 THEN 'lightgreen' ELSE '#5694dc' END) rowcolor   ");
                sb.Append("  FROM `patient_labinvestigation_opd_prebooking` plo ");
                sb.Append("  INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc ON hc.`PreBookingID`=plo.`PreBookingID`  ");
                sb.Append("  where hc.PhlebotomistID=@PhlebotomistID and hc.appdatetime=@appdatetime and plo.iscancel=0");
                sb.Append("  GROUP BY plo.prebookingid ORDER BY plo.id  ");

                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                      new MySqlParameter("@PhlebotomistID", philboid),
                      new MySqlParameter("@appdatetime", Util.GetDateTime(appdatettime).ToString("yyyy-MM-dd HH:mm:ss"))).Tables[0])
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
    public static string CancelAppointment(string appid, string reason)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            StringBuilder smsText = new StringBuilder();
            StringBuilder sbSMS;
            smsText.Append(" SELECT hc.cityid, hp.`PhlebotomistID`, CONCAT(pl.`Title`,pl.`PName`)pname,pl.`Mobile` pmobile, IFNULL(pl.`Email`,'') pemail,ifnull(cm.`Email`,'')emailidpcc,");
            smsText.Append(" cm.`Centre` centrename,DATE_FORMAT(hc.`AppDateTime`,'%d-%b-%Y %h:%i %p')appdate,SUM(netamt)totalamt,");
            smsText.Append(" CONCAT(hp.`Name`,' (',hp.`Mobile`,')')Phelbotomistname ");
            smsText.Append(" FROM `patient_labinvestigation_opd_prebooking`  pl ");
            smsText.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc ON hc.`PreBookingID`=pl.`PreBookingID` AND pl.`IsCancel`=0 ");
            smsText.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=pl.`PreBookingCentreID` ");
            smsText.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hp ON hp.`PhlebotomistID`=hc.`PhlebotomistID` ");
            smsText.Append(" where pl.`PreBookingID`=@PreBookingID ");
            DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, smsText.ToString(),
                                        new MySqlParameter("@PreBookingID", appid)).Tables[0];

            sb.Append(" UPDATE patient_labinvestigation_opd_prebooking plo ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc ON plo.`PreBookingID`=hc.`PreBookingID`  ");
            sb.Append(" SET hc.CancelReason=@CancelReason, plo.`IsCancel`=1,hc.`Iscancel`=1,hc.CancelByid=@CancelByID,hc.CancelByName=@CancelBy,hc.CancelDateTime=now(), ");
            sb.Append(" plo.CancelDate=now(),plo.CancelBy=@CancelBy,plo.CancelByID=@CancelByID,hc.CurrentStatus='Canceled',hc.CurrentStatusDate=now() ");
            sb.Append(" WHERE plo.`PreBookingID`='" + appid + "' ");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@CancelBy", UserInfo.LoginName),
                        new MySqlParameter("@CancelByID", UserInfo.ID),
                        new MySqlParameter("@CancelReason", reason));


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from " + Util.getApp("HomeCollectionDB") + ".hc_occupied_slot where PhlebotomistID=@PhlebotomistID and AppDateTime=@AppDateTime ",
                        new MySqlParameter("@PhlebotomistID", dt.Rows[0]["PhlebotomistID"].ToString()),
                        new MySqlParameter("@AppDateTime", Util.GetDateTime(dt.Rows[0]["appdate"]).ToString("yyyy-MM-dd HH:mm:ss")));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking_status (PreBookingID,CurrentStatus,CurrentStatusDate,EntryByID,EntryByName) values (@PreBookingID,@CurrentStatus,@CurrentStatusDate,@EntryByID,@EntryByName)",
                        new MySqlParameter("@PreBookingID", appid),
                        new MySqlParameter("@CurrentStatus", "Canceled"),
                        new MySqlParameter("@CurrentStatusDate", DateTime.Now),
                        new MySqlParameter("@EntryByID", UserInfo.ID),
                        new MySqlParameter("@EntryByName", UserInfo.LoginName)
                 );


            if (dt.Rows[0]["pmobile"].ToString() != string.Empty)
            {

                string custmercareno = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT customercareno FROM city_master WHERE id=@cityid",
                                                                  new MySqlParameter("@cityid", dt.Rows[0]["cityid"].ToString())));
                if (custmercareno == string.Empty)
                {
                    custmercareno = Resources.Resource.HomeCollectionCustomerCare;
                }


                string _smstext = Util.getApp("CancelAppointmentSMS");
                _smstext = _smstext.Replace("{custmercareno}", custmercareno);
                try
                {

                    sbSMS = new StringBuilder();
                    sbSMS.Append(" insert into " + Util.getApp("HomeCollectionDB") + ".sms(MOBILE_NO,SMS_TEXT,IsSend,UserID,EntDate,SMS_Type,LedgerTransactionID,LabObservation_ID,UpdateDate) ");
                    sbSMS.Append(" values(@MOBILE_NO,@SMS_TEXT,'1','1',now(),'HCCancel','0','0',Now()) ");

                    Sms_Host sm = new Sms_Host();
                    sm._Msg = _smstext.ToString();
                    sm._SmsTo = Util.GetString(Util.GetString(dt.Rows[0]["pmobile"]));
                    sm.sendSmsHomeCollection();

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                                new MySqlParameter("@MOBILE_NO", Util.GetString(dt.Rows[0]["pmobile"])),
                                new MySqlParameter("@SMS_TEXT", _smstext));
                }
                catch
                {
                    sbSMS = new StringBuilder();
                    sbSMS.Append(" insert into " + Util.getApp("HomeCollectionDB") + ".sms(MOBILE_NO,SMS_TEXT,IsSend,UserID,EntDate,SMS_Type,LedgerTransactionID,LabObservation_ID) ");
                    sbSMS.Append(" values(@MOBILE_NO,@SMS_TEXT,'0','1',now(),'HCCancel','0','0') ");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                            new MySqlParameter("@MOBILE_NO", Util.GetString(dt.Rows[0]["pmobile"])),
                            new MySqlParameter("@SMS_TEXT", _smstext));
                }
            }


            // Send Email Patient


            if (dt.Rows[0]["pemail"].ToString() != string.Empty)
            {
                smsText = new StringBuilder();
                sbSMS = new StringBuilder();
                smsText.AppendFormat("{0}<br/><br/> ", Resources.Resource.HomeCollectionSMSTemplate);
                smsText.Append("We have received your request againts your  Home collection is  cancel due to <br/> <cancelreason>  ");
                smsText.Replace("<cancelreason>", reason);
                sbSMS.Append(" insert into " + Util.getApp("HomeCollectionDB") + ".hc_email_sender(PreBookingID,EmailID,EmailIDCC,EmailIDBCC,Subject,EmailBody,EmailType,EmailReceiver,EntryDateTime,EntryByID,EntryByName) ");
                sbSMS.Append(" values(@PreBookingID, @EmailID,'','','HomeCollection Cancel',@EmailBody,'HomeCollectionCancel','Patient',now(),@EntryByID,@EntryByName) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                   new MySqlParameter("@PreBookingID", appid),
                   new MySqlParameter("@EmailID", Util.GetString(dt.Rows[0]["pemail"])),
                   new MySqlParameter("@EmailBody", smsText.ToString()),
                   new MySqlParameter("@EntryByID", UserInfo.ID),
                   new MySqlParameter("@EntryByName", UserInfo.LoginName));
            }

            // Email To PCC

            if (dt.Rows[0]["emailidpcc"].ToString() != string.Empty)
            {
                smsText = new StringBuilder();
                sbSMS = new StringBuilder();
                smsText.Append("Dear <CentreName>,<br/>");
                smsText.Append("<Pname> <Pmobile> <Totalamt> booked for your PCC/Centre on <BookingDate> <br/> ");
                smsText.Append("Phlebotomist details <Phelbotomistname> <br/>");
                smsText.Append("is cancelled due to <cancelreason>");
                smsText.Replace("<cancelreason>", reason);
                smsText.Replace("<CentreName>", dt.Rows[0]["centrename"].ToString());
                smsText.Replace("<Pname>", dt.Rows[0]["pname"].ToString().ToUpper());
                smsText.Replace("<Pmobile>", dt.Rows[0]["pmobile"].ToString());
                smsText.Replace("<BookingDate>", Util.GetString(dt.Rows[0]["appdate"]));
                smsText.Replace("<Phelbotomistname>", Util.GetString(dt.Rows[0]["Phelbotomistname"]));
                smsText.Replace("<Totalamt>", Util.GetString(dt.Rows[0]["totalamt"]));

                sbSMS.Append(" insert into " + Util.getApp("HomeCollectionDB") + ".hc_email_sender(PreBookingID, EmailID,EmailIDCC,EmailIDBCC,Subject,EmailBody,EmailType,EmailReceiver,EntryDateTime,EntryByID,EntryByName) ");
                sbSMS.Append(" values(@PreBookingID,@EmailID,'','','HomeCollection Cancel',@EmailBody,'HomeCollectionCancel','PCC',now(),@EntryByID,@EntryByName) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                   new MySqlParameter("@PreBookingID", appid),
                   new MySqlParameter("@EmailID", Util.GetString(dt.Rows[0]["emailidpcc"])),
                   new MySqlParameter("@EmailBody", smsText.ToString()),
                   new MySqlParameter("@EntryByID", UserInfo.ID),
                   new MySqlParameter("@EntryByName", UserInfo.LoginName));
            }
            sbSMS = new StringBuilder();
            sbSMS.Append(" INSERT INTO " + Util.getApp("HomeCollectionDB") + ".hc_fcm_notification (PreBookingID,phelbotomistid,title,body,EntryDate,entrybyid,EntryByName)  ");
            sbSMS.Append(" VALUES ");
            sbSMS.Append(" (@PreBookingID,@phelbotomistid,'HomeCollection Cancel',@EmailBody,now(),@EntryByID,@EntryByName)");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                   new MySqlParameter("@PreBookingID", appid),
                   new MySqlParameter("@phelbotomistid", Util.GetString(dt.Rows[0]["PhlebotomistID"])),
                   new MySqlParameter("@EmailBody", string.Concat("HomeCollection Canceled For PrebookingId ", appid)),
                   new MySqlParameter("@EntryByID", UserInfo.ID),
                   new MySqlParameter("@EntryByName", UserInfo.LoginName));

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

    [WebMethod(EnableSession = true)]
    public static string GetLastThreeVisit(string uhid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT prebookingid FROM " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` WHERE patient_id=@patient_id AND iscancel=0 order by entrydatetime desc LIMIT 3",
               new MySqlParameter("@patient_id", uhid)).Tables[0];
            if (dt.Rows.Count > 0)
            {
                string labno = string.Join(",", dt.Rows.OfType<DataRow>().Select(r => r[0].ToString()));

                string[] PreBookingTags = labno.Split(',');
                string[] PreBookingParamNames = PreBookingTags.Select(
                  (s, i) => "@tag" + i).ToArray();
                string PreBookingClause = string.Join(", ", PreBookingParamNames);

                StringBuilder sb = new StringBuilder();
                sb.Append("  SELECT plo.patient_id,DATE_FORMAT(plo.CreatedDate,'%d-%b-%Y')regdate, plo.prebookingid ,plo.isconfirm, ");
                sb.Append("  plo.`ItemName`,plo.`Rate`,plo.`DiscAmt`,plo.`NetAmt`,DATE_FORMAT(hc.AppDateTime,'%d-%b-%Y %h:%i %p')appdate, ");
                sb.Append("  ifnull(hc.PatientRating,'')PatientRating ,ifnull(hc.PatientFeedback,'')PatientFeedback ,ifnull(hc.PhelboRating,'')PhelboRating, ifnull(hc.PhelboFeedback,'')PhelboFeedback ");
                sb.Append("  FROM `patient_labinvestigation_opd_prebooking` plo ");
                sb.Append("  inner join " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking hc on hc.prebookingid=plo.prebookingid and hc.IsBooked=1");
                sb.Append("  WHERE plo.`prebookingid` IN ({0}) group by plo.prebookingid,plo.itemid order by hc.AppDateTime desc,plo.itemname asc");
                using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), PreBookingClause), con))
                {
                    for (int i = 0; i < PreBookingParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(PreBookingParamNames[i], PreBookingTags[i]);
                    }
                    DataTable dtP = new DataTable();
                    using (dtP as IDisposable)
                    {
                        da.Fill(dtP);
                        sb = new StringBuilder();
                        return JsonConvert.SerializeObject(dtP);
                    }
                }

            }
            else
            {
                DataTable dtc = new DataTable();
                return JsonConvert.SerializeObject(dtc);
            }
        }
        catch (Exception ex)
        {


            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            DataTable dtc = new DataTable();
            return JsonConvert.SerializeObject(dtc);

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
    public static string getphelbotomistlist(string prebookingid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dtre = new DataTable();
        try
        {
            string data = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(localityid,'#',pincode) da FROM " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` WHERE prebookingid=@prebookingid LIMIT 1",
               new MySqlParameter("@prebookingid", prebookingid)));
            string areaid = data.Split('#')[0];
            string pincode = data.Split('#')[1];

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT hcp.`PhlebotomistID`,hcp.`Name` ");
            sb.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hcp    ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_area_phlebotomist_mapping` hcr   ");
            sb.Append(" ON hcp.`phlebotomistid`=hcr.phlebotomistid AND hcr.`localityid`=@localityid   ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@localityid", areaid)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(dtre);
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
    public static string getslot(string prebookingid, string appdate, string phelbotomist, string oldphelbo)
    {

        if (phelbotomist == "null")
        {
            phelbotomist = oldphelbo;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dtre = new DataTable();
        try
        {



            string data = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(localityid,'#',pincode) da FROM " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` WHERE prebookingid=@prebookingid LIMIT 1",
               new MySqlParameter("@prebookingid", prebookingid)));
            string areaid = data.Split('#')[0];
            string pincode = data.Split('#')[1];
            DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select StartTime,EndTime,AvgTime,NoofSlotForApp from f_locality where id=@areaid and Pincode=@pincode and ishomecollection=1",
               new MySqlParameter("@areaid", areaid),
               new MySqlParameter("@pincode", pincode)).Tables[0];

            if (dt1.Rows.Count == 0)
            {
                return JsonConvert.SerializeObject(dtre);
            }

            dtre.Columns.Add("Timeslot");
            dtre.Columns.Add("isbooked");





            DateTime starttimeday = DateTime.Parse(appdate + " " + dt1.Rows[0]["StartTime"].ToString());
            DateTime endtimeday = DateTime.Parse(appdate + " " + dt1.Rows[0]["EndTime"].ToString());
            int avgtime = Util.GetInt(dt1.Rows[0]["AvgTime"]) * Util.GetInt(dt1.Rows[0]["NoofSlotForApp"].ToString());


            TimeSpan span = endtimeday.Subtract(starttimeday);

            int total_min = Util.GetInt(span.TotalMinutes);

            int noslots = total_min / avgtime;
            int add = 0;

            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" SELECT DATE_FORMAT(appdatetime,'%H:%i:%s') apptime");
            sb1.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking WHERE  phlebotomistid =@phlebotomistid and ");
            sb1.Append(" date(AppDateTime)=@AppDateTime and iscancel=0  ");
            sb1.Append(" GROUP by DATE_FORMAT(appdatetime,'%H:%i:%s')");
            using (DataTable dttime = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb1.ToString(),
                 new MySqlParameter("@phlebotomistid", phelbotomist),
                 new MySqlParameter("@AppDateTime", Util.GetDateTime(appdate).ToString("yyyy-MM-dd"))).Tables[0])
            {



                for (int i = 0; i < noslots; i++)
                {
                    string madetime = Util.GetDateTime((starttimeday.AddMinutes(add)).ToShortTimeString()).ToString("HH:mm");
                    if (Util.GetDateTime(starttimeday.AddMinutes(add)) > DateTime.Now)
                    {

                        DataRow dr = dtre.NewRow();
                        dr["Timeslot"] = madetime.ToString();
                        string ss = "apptime='" + Util.GetDateTime(starttimeday.AddMinutes(add)).ToString("HH:mm:ss") + "'";
                        dr["isbooked"] = Util.GetString(dttime.Select(ss).Length);
                        dtre.Rows.Add(dr);
                    }

                    add += avgtime;
                }
                return JsonConvert.SerializeObject(dtre);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(dtre);
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
    public static string RescheduleNow(string prebookingid, string appdate, string apptime, string phelbotomistid)
    {
        if (phelbotomistid == string.Empty || phelbotomistid == null || phelbotomistid == "0")
        {
            return "Phelbotomist Not Selected Please Try Again";
        }

        if (Util.GetDateTime(appdate + " " + apptime) < DateTime.Now)
        {
            return "Appointment Time Not Less Then Current Time";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (UserInfo.RoleID == 253)
            {
                int cc = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select count(1) from hc_homecollectionbooking_status where PreBookingID=@PreBookingID and CurrentStatus='Rescheduled'",
                   new MySqlParameter("@PreBookingID", prebookingid)));
                if (cc >= 2)
                {
                    Exception ex = new Exception("Yon can only Reschedule a home collection twice.");
                    throw (ex);
                }
            }

            StringBuilder smsText = new StringBuilder();
            StringBuilder sbSMS;
            //Rollback Cancel
            smsText = new StringBuilder();
            smsText.Append(" UPDATE patient_labinvestigation_opd_prebooking plo ");
            smsText.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc ON plo.`PreBookingID`=hc.`PreBookingID` and  hc.currentstatus='Canceled' ");
            smsText.Append(" SET plo.`IsCancel`=0,hc.`Iscancel`=0 ");
            smsText.Append(" WHERE plo.`PreBookingID`=@PreBookingID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, smsText.ToString(),
               new MySqlParameter("@PreBookingID", prebookingid));

            smsText = new StringBuilder();
            smsText.Append(" SELECT hc.cityid, hp.PhlebotomistID, CONCAT(pl.`Title`,pl.`PName`)pname,pl.`Mobile` pmobile, IFNULL(pl.`Email`,'') pemail,ifnull(cm.`Email`,'')emailidpcc,");
            smsText.Append(" cm.`Centre` centrename,DATE_FORMAT(hc.`AppDateTime`,'%d-%b-%Y %h:%i %p')appdate,SUM(netamt)totalamt,");
            smsText.Append(" CONCAT(hp.`Name`,' (',hp.`Mobile`,')')Phelbotomistname ");
            smsText.Append(" FROM `patient_labinvestigation_opd_prebooking`  pl ");
            smsText.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc ON hc.`PreBookingID`=pl.`PreBookingID` AND pl.`IsCancel`=0 ");
            smsText.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=pl.`PreBookingCentreID` ");
            smsText.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hp ON hp.`PhlebotomistID`=hc.`PhlebotomistID` ");
            smsText.Append(" where pl.`PreBookingID`=@PreBookingID ");
            DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, smsText.ToString(),
                new MySqlParameter("@PreBookingID", prebookingid)).Tables[0];

            int endtime = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select NoofSlotForApp from f_locality fl inner join " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking hc on hc.localityid=fl.id and hc.prebookingid=@prebookingid",
                new MySqlParameter("@prebookingid", prebookingid)));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking SET isReschedule=@isReschedule,RescheduleDatetime=@RescheduleDatetime,RescheduleById=@RescheduleById,RescheduleByName=@RescheduleByName,AppDateTime=@AppDateTime,PhlebotomistID=@phelbotomistid,CurrentStatus=@CurrentStatus,CurrentStatusDate=@CurrentStatusDate,AppEndDateTime=@AppEndDateTime WHERE prebookingid=@prebookingid",
                        new MySqlParameter("@isReschedule", "1"),
                        new MySqlParameter("@RescheduleDatetime", DateTime.Now),
                        new MySqlParameter("@RescheduleById", UserInfo.ID),
                        new MySqlParameter("@RescheduleByName", UserInfo.LoginName),
                        new MySqlParameter("@AppDateTime", Util.GetDateTime(appdate + " " + apptime)),
                        new MySqlParameter("@AppEndDateTime", Util.GetDateTime(appdate + " " + apptime).AddMinutes(endtime * 10)),
                        new MySqlParameter("@phelbotomistid", phelbotomistid),
                        new MySqlParameter("@CurrentStatus", "Rescheduled"),
                        new MySqlParameter("@CurrentStatusDate", DateTime.Now),
                        new MySqlParameter("@prebookingid", prebookingid));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking_status (PreBookingID,CurrentStatus,CurrentStatusDate,EntryByID,EntryByName) values (@PreBookingID,@CurrentStatus,@CurrentStatusDate,@EntryByID,@EntryByName)",
                 new MySqlParameter("@PreBookingID", prebookingid),
                 new MySqlParameter("@CurrentStatus", "Rescheduled"),
                 new MySqlParameter("@CurrentStatusDate", DateTime.Now),
                 new MySqlParameter("@EntryByID", UserInfo.ID),
                 new MySqlParameter("@EntryByName", UserInfo.LoginName));
            // Send SMS



            if (dt.Rows[0]["pmobile"].ToString() != string.Empty)
            {

                string custmercareno = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT customercareno FROM city_master WHERE id=@cityid",
                   new MySqlParameter("@cityid", dt.Rows[0]["cityid"].ToString())));
                if (custmercareno == string.Empty)
                {
                    custmercareno = Resources.Resource.HomeCollectionCustomerCare;
                }

                string smstext = Util.getApp("RescheduleNowSMS");
                smstext = smstext.Replace("{BookingDate}", Util.GetDateTime(appdate + " " + apptime).ToString("dd-MM-yyyy"));
                smstext = smstext.Replace("{BookingTime}", Util.GetDateTime(appdate + " " + apptime).ToString("hh:mm tt"));
                smstext = smstext.Replace("{custmercareno}", custmercareno);
                Sms_Host sm = new Sms_Host();

                try
                {


                    sbSMS = new StringBuilder();
                    sbSMS.Append(" insert into " + Util.getApp("HomeCollectionDB") + ".sms(MOBILE_NO,SMS_TEXT,IsSend,UserID,EntDate,SMS_Type,LedgerTransactionID,LabObservation_ID,UpdateDate) ");
                    sbSMS.Append(" values(@MOBILE_NO,@smstext,'1','1',now(),'HCNA','0','0',now()) ");
                    sm._Msg = smstext.ToString();
                    sm._SmsTo = Util.GetString(dt.Rows[0]["pmobile"]);
                    sm.sendSmsHomeCollection();
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sbSMS.ToString(),
                                new MySqlParameter("@MOBILE_NO", Util.GetString(dt.Rows[0]["pmobile"])),
                                new MySqlParameter("@smstext", smstext));
                }
                catch
                {
                    sbSMS = new StringBuilder();
                    sbSMS.Append(" insert into " + Util.getApp("HomeCollectionDB") + ".sms(MOBILE_NO,SMS_TEXT,IsSend,UserID,EntDate,SMS_Type,LedgerTransactionID,LabObservation_ID) ");
                    sbSMS.Append(" values(@MOBILE_NO,@smstext,'0','1',now(),'HCNA','0','0') ");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sbSMS.ToString(),
                                new MySqlParameter("@MOBILE_NO", Util.GetString(dt.Rows[0]["pmobile"])),
                                new MySqlParameter("@smstext", smstext));
                }
            }
            // Send Email Patient
            if (dt.Rows[0]["pemail"].ToString() != string.Empty)
            {
                smsText = new StringBuilder();
                sbSMS = new StringBuilder();

                smsText.AppendFormat("{0}<br/><br/> ", Resources.Resource.HomeCollectionSMSTemplate);
                smsText.Append("We have received your request againts your  Home collection booking  is  postponed  to <reshedule> ");
                smsText.Replace("<reshedule>", Util.GetDateTime(appdate + " " + apptime).ToString("dd-MMM-yyyy hh:mm tt"));



                sbSMS.Append(" insert into " + Util.getApp("HomeCollectionDB") + ".hc_email_sender(PrebookingId,EmailID,EmailIDCC,EmailIDBCC,Subject,EmailBody,EmailType,EmailReceiver,EntryDateTime,EntryByID,EntryByName) ");
                sbSMS.Append(" values(@prebookingid,@pemail,'','','HomeCollection Reschedule',@EmailBody,'HomeCollectionReschedule','Patient',now(),@EntryByID,@EntryByName) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                            new MySqlParameter("@prebookingid", prebookingid),
                            new MySqlParameter("@pemail", Util.GetString(dt.Rows[0]["pemail"])),
                            new MySqlParameter("@EmailBody", smsText.ToString()),
                            new MySqlParameter("@EntryByID", UserInfo.ID),
                            new MySqlParameter("@EntryByName", UserInfo.LoginName));
            }

            // Email To PCC

            if (dt.Rows[0]["emailidpcc"].ToString() != string.Empty)
            {
                smsText = new StringBuilder();
                sbSMS = new StringBuilder();
                smsText.Append("Dear <CentreName>,<br/>");
                smsText.Append("<Pname> <Pmobile> <Totalamt> booked for your PCC/Centre on <BookingDate> <br/> ");
                smsText.Append("Phlebotomist details <Phelbotomistname> <br/>");
                smsText.Append("is Post Ponded  <reshedule> ");
                smsText.Replace("<CentreName>", dt.Rows[0]["centrename"].ToString());
                smsText.Replace("<Pname>", dt.Rows[0]["pname"].ToString().ToUpper());
                smsText.Replace("<Pmobile>", dt.Rows[0]["pmobile"].ToString());
                smsText.Replace("<BookingDate>", Util.GetString(dt.Rows[0]["appdate"]));
                smsText.Replace("<Phelbotomistname>", Util.GetString(dt.Rows[0]["Phelbotomistname"]));
                smsText.Replace("<Totalamt>", Util.GetString(dt.Rows[0]["totalamt"]));
                smsText.Replace("<reshedule>", Util.GetDateTime(appdate + " " + apptime).ToString("dd-MMM-yyyy hh:mm tt"));
                sbSMS.Append(" insert into " + Util.getApp("HomeCollectionDB") + ".hc_email_sender(PrebookingID, EmailID,EmailIDCC,EmailIDBCC,Subject,EmailBody,EmailType,EmailReceiver,EntryDateTime,EntryByID,EntryByName) ");
                sbSMS.Append(" values(@prebookingid, @emailidpcc,'','','HomeCollection Reschedule',@EmailBody,'HomeCollectionReschedule','PCC',now(),@EntryByID,@EntryByName) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                            new MySqlParameter("@prebookingid", prebookingid),
                            new MySqlParameter("@emailidpcc", Util.GetString(dt.Rows[0]["emailidpcc"])),
                            new MySqlParameter("@EmailBody", smsText.ToString()),
                            new MySqlParameter("@EntryByID", UserInfo.ID),
                            new MySqlParameter("@EntryByName", UserInfo.LoginName));
            }

            sbSMS = new StringBuilder();

            sbSMS.Append(" INSERT INTO " + Util.getApp("HomeCollectionDB") + ".hc_fcm_notification (PrebookingID,phelbotomistid,title,body,EntryDate,entrybyid,EntryByName)  ");
            sbSMS.Append(" VALUES ");
            sbSMS.Append(" (@prebookingid,@PhlebotomistID,'HomeCollection Reschedule',@body ,now(),@EntryByID,@EntryByName)");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                        new MySqlParameter("@prebookingid", prebookingid),
                        new MySqlParameter("@PhlebotomistID", Util.GetString(dt.Rows[0]["PhlebotomistID"])),
                        new MySqlParameter("@body", string.Concat("HomeCollection Reschedule For PrebookingId ", prebookingid, ". New Datetime is ", Util.GetDateTime(appdate + " " + apptime).ToString("dd-MMM-yyyy hh:mm tt"))),
                        new MySqlParameter("@EntryByID", UserInfo.ID),
                        new MySqlParameter("@EntryByName", UserInfo.LoginName));

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
    [WebMethod]
    public static string bindroute(string cityid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT concat(hr.routeid,'#',hca.localityid,'#',pincode)routeid ,hr.`Route` Route FROM " + Util.getApp("HomeCollectionDB") + ".`hc_routemaster` hr  ");
            sb.Append("  INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping hca   ON hca.routeid=  hr.routeid ");
            sb.Append("  inner join f_locality fl on fl.id=hca.localityid ");
            sb.Append("  WHERE hr.cityid=@cityid AND isactive=1 group by hr.routeid order by hr.`Route`");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@cityid", cityid)).Tables[0]);
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

    [WebMethod]
    public static string RecommendedPackage(string TestId, string referenceCodeOPD, string TotalAmount)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] itemTags = TestId.Split(',');
            string[] itemNames = itemTags.Select((s, i) => "@tag" + i).ToArray();
            string itemClause = string.Join(", ", itemNames);

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT DISTINCT fm.TypeName as Name,fm.ItemId, fr.Rate, fr.rate-@rate AS Diff, ");
            sb.Append("     IFNULL((SELECT GROUP_CONCAT(imm.name SEPARATOR '##')ItemDetail  ");
            sb.Append("     FROM  f_itemmaster im   ");
            sb.Append("     INNER JOIN package_labdetail pld  ON pld.PlabID=im.Type_ID  ");
            sb.Append("     INNER JOIN investigation_master imm ON imm.Investigation_Id=pld.InvestigationID  ");
            sb.Append("     WHERE  im.`ItemID`=fm.itemID GROUP BY im.ItemID   ),'')ItemDetail ");
            sb.Append("  FROM package_labdetail pd ");
            sb.Append("  INNER JOIN f_itemMaster fm ON pd.plabId=fm.ItemId AND fm.`IsActive`=1");
            sb.Append("  INNER JOIN f_ratelist fr ON fr.itemid=pd.plabid AND fr.Rate<>0");
            sb.Append("  AND pd.investigationid IN ({0}) AND fr.panel_id=@referenceCodeOPD");
            // sb.Append("  AND fr.rate>=@rate-500 AND fr.rate<=@rate+500");

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), itemClause), con))
            {
                for (int i = 0; i < itemNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(itemNames[i], itemTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("referenceCodeOPD", referenceCodeOPD);
                da.SelectCommand.Parameters.AddWithValue("@rate", TotalAmount);
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
    [WebMethod]
    public static string CheckHomeCollectionAllowed(string itemid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM f_itemaster_clientWise WHERE ClientName='HomeCollection' AND isactive=1 AND itemid=@itemid",
               new MySqlParameter("@itemid", itemid)));
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

    [WebMethod]
    public static string LoadEditData(string prebookingid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT hc.prebookingid, hc.Alternatemobileno,hc.SourceofCollection,hc.`Client`,hc.`Paymentmode`,plo.`DoctorID`,plo.`ReferedDoctor`,plo.`OtherDoctor`, ");
            sb.Append(" plo.`VIP`,hc.`HardCopyRequired`,plo.`ItemId`,plo.`DiscAmt`,concat(plo.`Rate`,'#0')Rate,plo.`NetAmt`,hc.`PhlebotomistID`,if(plo.subcategoryid=15,'Package','Test') itemtype, ");
            sb.Append(" CONCAT(pl.`Name`,' (',pl.`Mobile`,')')phelboname, ((plo.`DiscAmt`*100)/plo.rate) discper, ");
            sb.Append(" DATE_FORMAT(hc.`AppDateTime`,'%d-%b-%Y')appdate,DATE_FORMAT(hc.`AppDateTime`,'%h:%i') apptime,plo.`Remarks` ");

            sb.Append("  FROM `patient_labinvestigation_opd_prebooking` plo  ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc ON plo.`PreBookingID`=hc.`PreBookingID` AND plo.`IsCancel`=0 ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` pl ON pl.`PhlebotomistID`=hc.`PhlebotomistID` ");
            sb.Append(" WHERE hc.prebookingid=@prebookingid and plo.itemid<>@HomeCollectionChargeItemID ");

            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@prebookingid", prebookingid),
                new MySqlParameter("@HomeCollectionChargeItemID", Resources.Resource.HomeCollectionChargeItemID)).Tables[0]);
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

    [WebMethod]
    public static string updatedata(List<UpdatePrebooking> datatosave, string VIP, string HardCopyRequired, string Alternatemobileno, string Client, string Paymentmode, string SourceofCollection, string prebookingid, string deliverych, string Phelebotomistname)
    {

        if (Paymentmode == "null" || Paymentmode == string.Empty || Paymentmode == null)
        {
            Paymentmode = "Credit";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update  " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking set  HardCopyRequired=@HardCopyRequired,Alternatemobileno=@Alternatemobileno,Client=@Client,Paymentmode=@Paymentmode,SourceofCollection=@SourceofCollection,VIP=@VIP,UpdateDateTime=@UpdateDateTime,UpdateByID=@UpdateByID,UpdateByname=@UpdateByname where prebookingid=@prebookingid ",
                new MySqlParameter("@UpdateDateTime", DateTime.Now),
                new MySqlParameter("@UpdateByID", UserInfo.ID),
                new MySqlParameter("@UpdateByname", UserInfo.LoginName),
                new MySqlParameter("@prebookingid", prebookingid),
                new MySqlParameter("@VIP", VIP),
                new MySqlParameter("@HardCopyRequired", HardCopyRequired),
                new MySqlParameter("@Alternatemobileno", Alternatemobileno),
                new MySqlParameter("@Client", Client),
                new MySqlParameter("@Paymentmode", Paymentmode),
                new MySqlParameter("@SourceofCollection", SourceofCollection));

            DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, @"SELECT Title,Patient_ID,PName,House_No ,LocalityID, Locality,CityID,City,StateID,State,Mobile,Pincode,Email,DOB,Landmark,
Age,AgeYear,AgeMonth,AgeDays,TotalAgeInDays,Gender,Panel_ID,PreBookingID,PreBookingCentreID,group_concat(itemid) itemid
FROM `patient_labinvestigation_opd_prebooking` WHERE prebookingid=@prebookingid and iscancel=0",
                                        new MySqlParameter("@prebookingid", prebookingid)).Tables[0];

            string olditemid = dt.Rows[0]["itemid"].ToString();
            List<int> olditelist = new List<int>();
            foreach (string s in olditemid.Split(','))
            {
                olditelist.Add(Util.GetInt(s));
            }

            // cancel removed data
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE patient_labinvestigation_opd_prebooking plo ");
            sb.Append(" SET plo.`IsCancel`=1, ");
            sb.Append(" plo.CancelDate=now(),plo.CancelBy=@CancelBy,plo.CancelByID=@CancelByID");
            sb.Append(" WHERE plo.`PreBookingID`=PreBookingID AND itemid=@HomeCollectionItemID ");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@CancelBy", UserInfo.LoginName),
                        new MySqlParameter("@CancelByID", UserInfo.ID),
                        new MySqlParameter("@PreBookingID", prebookingid),
                        new MySqlParameter("@HomeCollectionItemID",Resources.Resource.HomeCollectionChargeItemID));

            string allitemid = string.Join(",", datatosave.Select(i => i.ItemId.ToString()));
            foreach (UpdatePrebooking hcb in datatosave)
            {
                Insert_PreBooking PreBooking = new Insert_PreBooking(tnx);
                PreBooking.Title = Util.GetString(dt.Rows[0]["Title"]);
                PreBooking.Patient_ID = Util.GetString(dt.Rows[0]["Patient_ID"]);
                PreBooking.PName = Util.GetString(dt.Rows[0]["PName"]).ToUpper();
                PreBooking.House_No = Util.GetString(dt.Rows[0]["House_No"]);
                PreBooking.LocalityID = Util.GetString(dt.Rows[0]["LocalityID"]);
                PreBooking.Locality = Util.GetString(dt.Rows[0]["Locality"]);
                PreBooking.CityID = Util.GetString(dt.Rows[0]["CityID"]);
                PreBooking.City = Util.GetString(dt.Rows[0]["City"]);
                PreBooking.StateID = Util.GetString(dt.Rows[0]["StateID"]);
                PreBooking.State = Util.GetString(dt.Rows[0]["State"]);
                PreBooking.Mobile = Util.GetString(dt.Rows[0]["Mobile"]);
                PreBooking.Pincode = Util.GetInt(dt.Rows[0]["Pincode"]);
                PreBooking.Email = Util.GetString(dt.Rows[0]["Email"]);
                PreBooking.DOB = Util.GetDateTime(dt.Rows[0]["DOB"]);
                PreBooking.Landmark = Util.GetString(dt.Rows[0]["Landmark"]);
                PreBooking.Age = Util.GetString(dt.Rows[0]["Age"]);
                PreBooking.AgeYear = Util.GetInt(dt.Rows[0]["AgeYear"]);
                PreBooking.AgeMonth = Util.GetInt(dt.Rows[0]["AgeMonth"]);
                PreBooking.AgeDays = Util.GetInt(dt.Rows[0]["AgeDays"]);
                PreBooking.TotalAgeInDays = Util.GetInt(dt.Rows[0]["TotalAgeInDays"]);
                PreBooking.Gender = Util.GetString(dt.Rows[0]["Gender"]);
                PreBooking.VisitType = "Home Collection";
                PreBooking.VIP = Util.GetInt(VIP);
                PreBooking.PatientSource = "Home Visit";
                if (HardCopyRequired == "1")
                {
                    PreBooking.DispatchModeName = "Courier";
                }
                else
                {
                    PreBooking.DispatchModeName = "Email";
                }
                PreBooking.Remarks = hcb.Remarks;
                PreBooking.Panel_ID = Util.GetInt(dt.Rows[0]["Panel_ID"]);
                PreBooking.PreBookingID = Util.GetString(dt.Rows[0]["PreBookingID"]);
                PreBooking.CreatedBy = UserInfo.LoginName;
                PreBooking.CreatedByID = UserInfo.ID;
                PreBooking.PaymentMode = Paymentmode;
                PreBooking.SampleCollectionDateTime = DateTime.Now;
                PreBooking.LabRefrenceNo = string.Empty;
                PreBooking.PreBookingCentreID = Util.GetInt(dt.Rows[0]["PreBookingCentreID"]);
                PreBooking.GrossAmt = hcb.GrossAmt;
                PreBooking.NetAmt = hcb.NetAmt;
                PreBooking.DiscAmt = hcb.DiscAmt;
                PreBooking.PaidAmt = 0;
                PreBooking.PaymentRefNo = string.Empty;
                PreBooking.VisitTypeID = 1;
                PreBooking.Sender = "Home Collection";
                PreBooking.IsConfirm = 0;
                PreBooking.RefDoctor = hcb.RefDoctor;
                PreBooking.DoctorID = hcb.DoctorID;
                PreBooking.OtherDoctor = hcb.OtherDoctor;
                PreBooking.ItemId = hcb.ItemId;
                PreBooking.ItemName = hcb.ItemName;
                PreBooking.Rate = hcb.Rate;
                PreBooking.TestCode = hcb.TestCode;
                PreBooking.SubCategoryID = hcb.SubCategoryID; ;
                PreBooking.IsPackage = (PreBooking.SubCategoryID == 15) ? 1 : 0;
                PreBooking.MRP = hcb.MRP;
                if (!olditelist.Contains(hcb.ItemId))
                {
                    PreBooking.Insert();
                }
            }
            if (Util.GetDecimal(deliverych) > 0)
            {
                Insert_PreBooking PreBooking = new Insert_PreBooking(tnx);
                PreBooking.Title = Util.GetString(dt.Rows[0]["Title"]);
                PreBooking.Patient_ID = Util.GetString(dt.Rows[0]["Patient_ID"]);
                PreBooking.PName = Util.GetString(dt.Rows[0]["PName"]).ToUpper();
                PreBooking.House_No = Util.GetString(dt.Rows[0]["House_No"]);
                PreBooking.LocalityID = Util.GetString(dt.Rows[0]["LocalityID"]);
                PreBooking.Locality = Util.GetString(dt.Rows[0]["Locality"]);
                PreBooking.CityID = Util.GetString(dt.Rows[0]["CityID"]);
                PreBooking.City = Util.GetString(dt.Rows[0]["City"]);
                PreBooking.StateID = Util.GetString(dt.Rows[0]["StateID"]);
                PreBooking.State = Util.GetString(dt.Rows[0]["State"]);
                PreBooking.Mobile = Util.GetString(dt.Rows[0]["Mobile"]);
                PreBooking.Pincode = Util.GetInt(dt.Rows[0]["Pincode"]);
                PreBooking.Email = Util.GetString(dt.Rows[0]["Email"]);
                PreBooking.DOB = Util.GetDateTime(dt.Rows[0]["DOB"]);
                PreBooking.Landmark = Util.GetString(dt.Rows[0]["Landmark"]);
                PreBooking.Age = Util.GetString(dt.Rows[0]["Age"]);
                PreBooking.AgeYear = Util.GetInt(dt.Rows[0]["AgeYear"]);
                PreBooking.AgeMonth = Util.GetInt(dt.Rows[0]["AgeMonth"]);
                PreBooking.AgeDays = Util.GetInt(dt.Rows[0]["AgeDays"]);
                PreBooking.TotalAgeInDays = Util.GetInt(dt.Rows[0]["TotalAgeInDays"]);
                PreBooking.Gender = Util.GetString(dt.Rows[0]["Landmark"]);
                PreBooking.VisitType = "Home Collection";
                PreBooking.VIP = Util.GetInt(VIP);
                PreBooking.PatientSource = "Home Visit";
                if (HardCopyRequired == "1")
                {
                    PreBooking.DispatchModeName = "Courier";
                }
                else
                {
                    PreBooking.DispatchModeName = "Email";
                }

                PreBooking.Remarks = datatosave[0].Remarks;
                PreBooking.Panel_ID = Util.GetInt(dt.Rows[0]["Panel_ID"]);
                PreBooking.PreBookingID = Util.GetString(dt.Rows[0]["PreBookingID"]);
                PreBooking.CreatedBy = UserInfo.LoginName;
                PreBooking.CreatedByID = UserInfo.ID;
                PreBooking.PaymentMode = Paymentmode;
                PreBooking.SampleCollectionDateTime = DateTime.Now;
                PreBooking.LabRefrenceNo = string.Empty;
                PreBooking.PreBookingCentreID = Util.GetInt(dt.Rows[0]["PreBookingCentreID"]);
                PreBooking.GrossAmt = Util.GetDecimal(deliverych);
                PreBooking.NetAmt = Util.GetDecimal(deliverych);
                PreBooking.DiscAmt = 0;
                PreBooking.PaidAmt = 0;
                PreBooking.PaymentRefNo = string.Empty;
                PreBooking.VisitTypeID = 1;
                PreBooking.Sender = "Home Collection";
                PreBooking.IsConfirm = 0;
                PreBooking.RefDoctor = datatosave[0].RefDoctor;
                PreBooking.DoctorID = datatosave[0].DoctorID;
                PreBooking.OtherDoctor = datatosave[0].OtherDoctor;
                PreBooking.ItemId =Util.GetInt( Resources.Resource.HomeCollectionChargeItemID);
                PreBooking.ItemName = Phelebotomistname.Split('(')[0].Trim();
                PreBooking.Rate = Util.GetDecimal(deliverych);
                PreBooking.TestCode = string.Empty;
                PreBooking.SubCategoryID = 21;
                PreBooking.IsPackage = (PreBooking.SubCategoryID == 15) ? 1 : 0;
                PreBooking.DiscountTypeID = 0;
                PreBooking.IsHomeCollection = 1;
                PreBooking.DiscAppBy = string.Empty;
                PreBooking.DiscAppByID = 0;
                PreBooking.DiscReason = string.Empty;
                PreBooking.MRP = 0;
                PreBooking.Insert();
            }
            // cancel removed data
            sb = new StringBuilder();
            sb.Append(" UPDATE patient_labinvestigation_opd_prebooking plo ");
            sb.Append(" SET plo.`IsCancel`=1, ");
            sb.Append(" plo.CancelDate=now(),plo.CancelBy=@CancelBy,plo.CancelByID=@CancelByID");
            sb.Append(" WHERE plo.`PreBookingID`=@PreBookingID and itemid not in (" + allitemid + ") and itemid != @HomeCollectionChargeItemID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@PreBookingID", prebookingid),
                        new MySqlParameter("@CancelBy", UserInfo.LoginName),
                        new MySqlParameter("@CancelByID", UserInfo.ID),
                        new MySqlParameter("@HomeCollectionChargeItemID", Resources.Resource.HomeCollectionChargeItemID));

            // update remarks
            sb = new StringBuilder();
            sb.Append(" UPDATE patient_labinvestigation_opd_prebooking plo ");
            sb.Append(" SET plo.remarks=@remarks ");
            sb.Append(" WHERE plo.`PreBookingID`=@PreBookingID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@remarks", datatosave[0].Remarks),
                        new MySqlParameter("@PreBookingID", prebookingid));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking_status (PreBookingID,CurrentStatus,CurrentStatusDate,EntryByID,EntryByName) values (@PreBookingID,@CurrentStatus,@CurrentStatusDate,@EntryByID,@EntryByName)",
                        new MySqlParameter("@PreBookingID", prebookingid),
                        new MySqlParameter("@CurrentStatus", "Edit"),
                        new MySqlParameter("@CurrentStatusDate", DateTime.Now),
                        new MySqlParameter("@EntryByID", UserInfo.ID),
                        new MySqlParameter("@EntryByName", UserInfo.LoginName)
                 );

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
    [WebMethod]
    public static string showphelbotprofile(string phelboid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, @"SELECT hp.PhlebotomistID,NAME,age dob,gender,mobile,email,CONCAT(p_address,' ',p_city,' ', p_pincode) address,bloodgroup,DucumentType,DucumentNo,
panno,`Qualification`, Vehicle_num, DrivingLicence, DATE_FORMAT(hp.dtentry, '%d-%b-%Y')joiningdate,
GROUP_CONCAT(cm.city) workingcity,ifnull((select ProfilePics from  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster_profilepic where PhlebotomistID=@phelboid AND active=1 AND approved=1),'')ProfilePics FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hp INNER JOIN " + Util.getApp("HomeCollectionDB") + ".hc_phleboworklocation  hw ON hp.PhlebotomistID = hw.PhlebotomistID INNER JOIN city_master cm ON cm.`ID`= hw.`CityId` where hp.PhlebotomistID=@phelboid GROUP BY hp.PhlebotomistID",
                                                                      new MySqlParameter("@phelboid", phelboid)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }


    [WebMethod]
    public static string GetOldHomeCollectionAddress(string pid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, @"SELECT DISTINCT address,hc.`locality`,hc.`City`,hc.`State`,hc.`LocalityID`,hc.cityid,hc.stateid,hc.pincode,plo.`Landmark`,hc.`Latitude`,hc.`Longitude`
 FROM " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc INNER JOIN `patient_labinvestigation_opd_prebooking` plo ON plo.prebookingid=hc.`PreBookingID`WHERE `IsPermanentAddress`=0 AND hc.patient_id=@pid order by hc.id desc",
         new MySqlParameter("@pid", pid)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string getareafrompincode(string pincode, string CityID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,NAME FROM f_locality WHERE active=1 AND CityID=@CityID and pincode=@pincode AND Active=1 order by name",
               new MySqlParameter("@CityID", CityID),
               new MySqlParameter("@pincode", pincode)));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string savenotbookedreason(string uhid, string mobileno, string address, string areaid, string cityid, string stateid, string pincode, string reason)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" insert into " + Util.getApp("HomeCollectionDB") + ".hc_homecollection_missed(Patient_ID,MobileNo,Address,localityid,Cityid,Stateid,Pincode,Reason,EntryDate,EntryByID,EntryByName)");
            sb.Append(" values ");
            sb.Append(" (@Patient_ID,@MobileNo,@Address,@localityid,@Cityid,@Stateid,@Pincode,@Reason,@EntryDate,@EntryByID,@EntryByName) ");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@Patient_ID", uhid),
                        new MySqlParameter("@MobileNo", mobileno),
                        new MySqlParameter("@Address", address),
                        new MySqlParameter("@localityid", areaid),
                        new MySqlParameter("@Cityid", cityid),
                        new MySqlParameter("@Stateid", stateid),
                        new MySqlParameter("@Pincode", pincode),
                        new MySqlParameter("@Reason", reason),
                        new MySqlParameter("@EntryDate", DateTime.Now),
                        new MySqlParameter("@EntryByID", UserInfo.ID),
                        new MySqlParameter("@EntryByName", UserInfo.LoginName));
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
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string LoadEditDataOnlyTest(string prebookingid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT plo.prebookingid,plo.`DoctorID`,plo.`ReferedDoctor`,plo.`OtherDoctor`, ");
            sb.Append(" plo.`VIP`,plo.`ItemId`,plo.`DiscAmt`,concat(plo.`Rate`,'#0')Rate,plo.`NetAmt`,if(plo.subcategoryid=15,'Package','Test') itemtype, ");
            sb.Append(" ((plo.`DiscAmt`*100)/plo.rate) discper, ");
            sb.Append(" plo.`Remarks`,plo.Paymentmode ,plo.createdby");
            sb.Append("  FROM `patient_labinvestigation_opd_prebooking` plo  ");
            sb.Append(" WHERE plo.prebookingid=@prebookingid and plo.itemid<>@HomeCollectionItemID and iscancel=0 ");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@prebookingid", prebookingid),
               new MySqlParameter("@HomeCollectionItemID", Resources.Resource.HomeCollectionChargeItemID)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string bindCity(int StateID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT City,ID FROM `city_master` WHERE StateID=@StateID and  isactive=1  ORDER BY city",
               new MySqlParameter("@StateID", StateID)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string getphelbotomistcharge(string phid, string appdate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT concat(hm.chargename,' @ ',chargeamount)chargename,chargeamount FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomist_chargemapping` hcm INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phelbochargemaster` hm ON hcm.phlebotomistid=hcm.phlebotomistid AND hcm.phlebotomistid=@phid AND '" + Util.GetDateTime(appdate).ToString("yyyy-MM-dd") + "'>=fromdate AND '" + Util.GetDateTime(appdate).ToString("yyyy-MM-dd") + "'<=todate ",
               new MySqlParameter("@phid", phid)).Tables[0];
            if (dt.Rows.Count > 0)
            {
                return JsonConvert.SerializeObject(dt);
            }
            else
            {
                dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " select 'No Charge @ 0' chargename,'0' chargeamount").Tables[0];
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string showoldtest(string pid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT  DISTINCT pli.itemname TestName,DATE_FORMAT(pli.`Date`,'%d-%b-%Y')DATE,pli.`Test_ID`,  ");
            sb.Append(" plo.`Flag` STATUS  ");
            sb.Append(" FROM `patient_labinvestigation_opd` pli   ");
            sb.Append(" INNER JOIN `patient_labobservation_opd` plo ON pli.`Test_ID`=plo.`Test_ID`  ");
            sb.Append(" WHERE  pli.`Approved`=1  AND pli.`Patient_ID`=@pid  ");
            sb.Append(" AND pli.Date >DATE_ADD(NOW(),INTERVAL -6 MONTH) AND plo.`Flag` IN ('High','Low')  ");
            sb.Append(" GROUP BY pli.`Investigation_ID`  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@pid", pid.Trim())).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
}
public class UpdatePrebooking
{
    public decimal GrossAmt { get; set; }
    public decimal DiscAmt { get; set; }
    public decimal NetAmt { get; set; }
    public int ItemId { get; set; }
    public string ItemName { get; set; }
    public decimal Rate { get; set; }
    public string TestCode { get; set; }
    public int IsPackage { get; set; }
    public int SubCategoryID { get; set; }
    public int? DoctorID { get; set; }
    public string RefDoctor { get; set; }
    public string OtherDoctor { get; set; }
    public string Remarks { get; set; }
    public decimal MRP { get; set; }
}


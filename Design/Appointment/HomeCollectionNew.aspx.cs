using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;
using System.Collections.Generic;


public partial class Design_Appointment_HomeCollectionNew : System.Web.UI.Page
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    public static string starttime = "06:30:00";
    public static string endtime = "19:00:00";
    public static string avg = "30";
    //public string abc = ddlCentreAccess.SelectedValue;
    public DataTable dt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            ce_dtfrom.StartDate = DateTime.Now;
            dtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtredate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            CurrentTime.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindTitle();
            bindAccessCentre();
            //  getdata(dtFrom.Text, ddlCentreAccess.SelectedItem.Value.ToString());
        }
        dtFrom.Attributes.Add("readOnly", "readOnly");
    }

    private void bindAccessCentre()
    {
        // ddlCentreAccess.DataSource = StockReports.GetDataTable("SELECT cm.CentreID,cm.Centre FROM centre_access ca INNER JOIN centre_master cm ON ca.CentreAccess=cm.CentreID and ca.AccessType=1 where ca.CentreID=" + Centre.Id + " Order by cm.Centre");


        //ddlCentreAccess.DataSource = StockReports.GetDataTable("SELECT cm.CentreID,cm.Centre FROM centre_master cm where cm.isactive=1 Order by cm.Centre");
        //ddlCentreAccess.DataTextField = "Centre";
        //ddlCentreAccess.DataValueField = "CentreID";
        //ddlCentreAccess.DataBind();
        //foreach (ListItem li in ddlCentreAccess.Items)
        //{
        //    if (li.Value.ToString() == UserInfo.Centre.ToString())
        //    {
        //        li.Selected = true;
        //        break;
        //    }
        //}
        //ddlCentreAccess.Items.Insert(0, new ListItem("--Select--", ""));
        ddlCentreAccess1.DataSource = StockReports.GetDataTable("SELECT cm.CentreID,cm.Centre FROM centre_master cm where cm.isactive=1 Order by cm.Centre");
        ddlCentreAccess1.DataTextField = "Centre";
        ddlCentreAccess1.DataValueField = "CentreID";
        ddlCentreAccess1.DataBind();
        //ddlCentreAccess1.Items.Insert(0, new ListItem("--Select--", ""));
        //ddlCentreAccess2.DataSource = StockReports.GetDataTable("SELECT cm.CentreID,cm.Centre FROM centre_master cm where cm.isactive=1 Order by cm.Centre");
        //ddlCentreAccess2.DataTextField = "Centre";
        //ddlCentreAccess2.DataValueField = "CentreID";
        //ddlCentreAccess2.DataBind();
        //ddlCentreAccess2.Items.Insert(0, new ListItem("--Select--", ""));


    }
    private void bindTitle()
    {
        cmbTitle.DataSource = AllGlobalFunction.NameTitle;
        cmbTitle.DataBind();

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string PanelBInd(string centreid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pn.company_name Company_Name,pn.Panel_ID PanelID  FROM Centre_Panel cp ");
        sb.Append(" INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id AND cp.CentreId='" + centreid + "'   AND cp.isActive=1 AND pn.isActive=1  ");
        sb.Append(" WHERE pn.panelgroupid ='1'  AND CURRENT_DATE() >= IF(cp.IsCamp=1,cp.`FromCampValidityDate`,CURRENT_DATE())  ");
        sb.Append(" AND CURRENT_DATE() <= IF(cp.IsCamp=1,cp.`ToCampValidityDate`,CURRENT_DATE()) ");
        sb.Append(" ORDER BY pn.company_name  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return retr;
        //StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT pn.Company_Name Company_Name,pn.Panel_ID PanelID  FROM Centre_Panel cp ");
        //sb.Append(" INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id WHERE cp.CentreId='" + UserInfo.Centre + "'  AND cp.isActive=1 AND pn.isActive=1  ");
        //DataTable dtPanel = StockReports.GetDataTable(sb.ToString());
        //string retrn = makejsonoftable(dtPanel, makejson.e_without_square_brackets);
        //return retrn;
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Doctorbind(string centreid)
    {

        StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT Doctor_ID,CONCAT(title,NAME)NAME FROM doctor_referal WHERE IsActive=1 ");
        sb.Append(" SELECT Doctor_ID, NAME FROM doctor_referal WHERE doctor_id <=2 ");
        sb.Append(" UNION ALL   ");
        sb.Append(" SELECT dr.doctor_id VALUE,CONCAT(title,dr.NAME) NAME   ");
        sb.Append(" FROM doctor_referal dr  ");
        sb.Append(" INNER JOIN `doctor_referal_centre` drc ON drc.`Doctor_ID`=dr.`Doctor_ID` AND drc.`CentreID`='" + centreid + "'  ");
        sb.Append(" WHERE dr.isactive=1   ");
        sb.Append(" ORDER BY NAME -- LIMIT 20 ");
        DataTable dtdoctor = StockReports.GetDataTable(sb.ToString());
        string retrn = makejsonoftable(dtdoctor, makejson.e_without_square_brackets);
        return retrn;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getinvlist(string PanelID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT im.itemid,typename,CONCAT(im.itemid,'#',IFNULL(rl.rate,'0')) myid ");
        sb.Append(" FROM f_itemmaster im ");
        sb.Append("LEFT  JOIN f_ratelist rl ON rl.itemid=im.itemid AND rl.panel_id=(SELECT ReferenceCodeOPD FROM f_panel_master WHERE panel_id='" + PanelID + "') ");
        sb.Append(" WHERE isactive=1 AND Booking=1  ORDER BY typename");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string retrn = makejsonoftable(dt, makejson.e_without_square_brackets);
        return retrn;

    }
    protected void btnsearch_Click(object sender, EventArgs e)
    {
        //if (ddlCentreAccess.SelectedItem.Value == "")
        //{
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "alert('Please select centre.....');", true);
        //}
        // getdata(dtFrom.Text, ddlCentreAccess.SelectedValue);
        if (txtCentreAccess.Text != "")
        {
            lblMsg.Text = "";
            getdata(dtFrom.Text, txtCentreAccess.Text);
        }
        else
        {
            lblMsg.Text = "";
            getdata(dtFrom.Text, txtcentrbind.Text);
        }
        if (txtCentreAccess.Text == "" || txtCentreAccess.Text == "0")
        {
            if (txtcentrbind.Text == "" || txtcentrbind.Text == "0")
            {
                lblMsg.Text = "Please select centre";
                return;
            }
        }
    }
    //private void BindPhe(string CentreID) {
    //    DataTable ph = StockReports.GetDataTable(" SELECT fbm.`FeildboyID` ID,fbm.`Name`,DATE_FORMAT(ph.`HolidayDate`,'%d-%b-%Y')HolidayDate FROM feildboy_master fbm  INNER JOIN `fieldboy_zonedetail` fmz ON fmz.`FieldBoyID`=fbm.`FeildboyID` AND fbm.`HomeCollection`=1 AND fmz.`ZoneID` = ( SELECT `BusinessZoneID` FROM  `centre_master` cm WHERE cm.`CentreID`='" + CentreID + "') LEFT JOIN Phlebo_Holiday ph ON fbm.`FeildboyID`=ph.`FieldBoyID` AND ph.`IsActive`=1 WHERE fbm.`IsActive`=1 AND fbm.Name<>'.N/A' ORDER BY fbm.Name ");
    //    ddlphe.DataSource = ph;
    //    ddlphe.DataValueField = "ID";
    //    ddlphe.DataTextField = "Name";
    //    ddlphe.DataBind();
    //}
    public void getdata(string date, string CentreID)
    {
        DataTable dtre = new DataTable();
        dtre.Columns.Add("Timeslot");

        dt.Columns.Add("PhlebotomistID");
        dt.Columns.Add("PhlebotomistName");
        dt.Columns.Add("HolidayDate");


        DateTime starttimeday = DateTime.Parse(date + " " + starttime);
        DateTime endtimeday = DateTime.Parse(date + " " + endtime);
        int avgtime = Convert.ToInt32(avg);
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
        try
        {
            ddlretimeslot.DataSource = dtre;
            ddlretimeslot.DataValueField = "Timeslot";
            ddlretimeslot.DataTextField = "Timeslot";
            ddlretimeslot.DataBind();
        }
        catch
        {
        }
        // DataTable ph = StockReports.GetDataTable("Select Name,ID from feildboy_master where IsActive=1 and Name<>'.N/A' order by Name");
        DataTable ph = StockReports.GetDataTable(" SELECT fbm.`FeildboyID` ID,fbm.`Name`,DATE_FORMAT(ph.`HolidayDate`,'%d-%b-%Y')HolidayDate FROM feildboy_master fbm  INNER JOIN `fieldboy_zonedetail` fmz ON fmz.`FieldBoyID`=fbm.`FeildboyID` AND fbm.`HomeCollection`=1 AND fmz.`ZoneID` = ( SELECT `BusinessZoneID` FROM  `centre_master` cm WHERE cm.`CentreID`='" + CentreID + "') LEFT JOIN Phlebo_Holiday ph ON fbm.`FeildboyID`=ph.`FieldBoyID` AND ph.`IsActive`=1 WHERE fbm.`IsActive`=1 AND fbm.Name<>'.N/A' ORDER BY fbm.Name ");
        //ddlphe.DataSource = ph;
        //ddlphe.DataValueField = "ID";
        //ddlphe.DataTextField = "Name";
        //ddlphe.DataBind();




        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT GROUP_CONCAT(CONCAT(fhm.id,'#',fhm.PatientName,'#',fhm.Mobile,'#', ");
        sb.Append(" CONCAT(fhm.Address,' ',IFNULL(fhm.Address1,''),' ',IFNULL(fhm.Address2,''),' ',IFNULL(fhm.pincode,'')),'#',fhm.Iscancel,'#',fhm.`IsBooked`) ");
        sb.Append(" SEPARATOR '~') `Data`, fhm.PhlebotomistID,cast(fhm.apptime as char)apptime ");
        sb.Append(" FROM f_homecollectiondatanew fhm ");
        sb.Append(" WHERE  fhm.appdate='" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "' AND fhm.CentreID='" + CentreID + "' ");
        sb.Append(" GROUP BY fhm.PhlebotomistID,fhm.apptime ");
        DataTable dttime = StockReports.GetDataTable(sb.ToString());



        foreach (DataRow dw in ph.Rows)
        {
            DataRow dwc = dt.NewRow();
            dwc["PhlebotomistID"] = dw["ID"].ToString();
            dwc["PhlebotomistName"] = dw["Name"].ToString();
            dwc["HolidayDate"] = dw["HolidayDate"].ToString();

            foreach (DataColumn dc in dt.Columns)
            {
                if (dc.ColumnName != "PhlebotomistID" && dc.ColumnName != "PhlebotomistName" && dc.ColumnName != "HolidayDate")
                {
                    try
                    {


                        string ss = "PhlebotomistID=" + dw["ID"].ToString() + " AND apptime='" + Util.GetDateTime(dc.ColumnName).ToString("HH:mm:ss") + "'";
                        DataRow[] drTemp = dttime.Select(ss); // getslotdata(date, dc.ColumnName, dw["ID"].ToString(), CentreID);
                        if (drTemp.Length > 0)
                            dwc[dc.ColumnName] = drTemp[0]["Data"].ToString();
                    }
                    catch (Exception ex)
                    {

                        
                    }
                }
            }
            dt.Rows.Add(dwc);
        }
    }

    public static string getslotdata(string date, string time, string phelbo, string CentreID)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("select group_concat(concat(fhm.id,'#',fhm.PatientName,'#',fhm.Mobile,'#', ");
        sb.Append(" concat(fhm.Address,' ',ifnull(fhm.Address1,''),' ',ifnull(fhm.Address2,''),' ',ifnull(fhm.pincode,'')),'#',fhm.Iscancel,'#',fhm.`IsBooked`) SEPARATOR '~') ");
        sb.Append(" from f_homecollectiondatanew fhm");
        sb.Append(" where  fhm.appdate='" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "' and fhm.CentreID='" + CentreID + "' ");
        sb.Append(" and fhm.PhlebotomistID='" + phelbo + "' and fhm.apptime='" + Util.GetDateTime(time).ToString("HH:mm:ss") + "'");
        string ss = StockReports.ExecuteScalar(sb.ToString());
        return ss;
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindPhle(string CentreID) {
        try {
            DataTable ph = StockReports.GetDataTable(" SELECT fbm.`FeildboyID` ID,fbm.`Name`,DATE_FORMAT(ph.`HolidayDate`,'%d-%b-%Y')HolidayDate FROM feildboy_master fbm  INNER JOIN `fieldboy_zonedetail` fmz ON fmz.`FieldBoyID`=fbm.`FeildboyID` AND fbm.`HomeCollection`=1 AND fmz.`ZoneID` = ( SELECT `BusinessZoneID` FROM  `centre_master` cm WHERE cm.`CentreID`='" + CentreID + "') LEFT JOIN Phlebo_Holiday ph ON fbm.`FeildboyID`=ph.`FieldBoyID` AND ph.`IsActive`=1 WHERE fbm.`IsActive`=1 AND fbm.Name<>'.N/A' ORDER BY fbm.Name ");
            string retr = Newtonsoft.Json.JsonConvert.SerializeObject(ph);
            return retr;
        }
        catch (Exception ex) {
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindTimeSlote(string date) {
        try {
            DataTable dt = new DataTable();
            DataTable dtre = new DataTable();
            dtre.Columns.Add("Timeslot");

            DateTime starttimeday = DateTime.Parse(date + " " + starttime);
            DateTime endtimeday = DateTime.Parse(date + " " + endtime);
            int avgtime = Convert.ToInt32(avg);
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
            string retr = Newtonsoft.Json.JsonConvert.SerializeObject(dtre);
            return retr;
        }
        catch (Exception ex) {
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savealldate(string phelbo, string phelboname, string date, string time, string pname, string mobile, string address, string address1, string address2, string emailid, string pinno, string test, string totalamt, string ageyear, string agemonth, string agedays, string gender, string appid, string PanelID, string DoctorID, string Title, string Centre, string Type, string Booked)
    {
        try
        {
            if (totalamt.ToUpper() == "NAN")
            {
                totalamt = "0";
            }
            if (ageyear == "")
                ageyear = "0";

            if (agemonth == "")
                agemonth = "0";

            if (agedays == "")
                agedays = "0";

            if (appid == "")
            {
                string appdate = Util.GetDateTime(date).ToString("yyyy-MM-dd");
                string appdatetime = Util.GetDateTime(date + " " + time).ToString("yyyy-MM-dd hh:mm:ss");
                string curtime = Util.GetDateTime(date).ToString("yyyy-MM-dd");

                DateTime dt1 = Convert.ToDateTime(appdate).Date;
                DateTime dt2 = DateTime.Now.Date;

                if (dt1 < dt2)
                {
                    return "-1";
                }

                StringBuilder sb = new StringBuilder();
                sb.Append("");
                sb.Append(" INSERT INTO f_homecollectiondatanew  ");
                sb.Append(" (PhlebotomistID,PhlebotomistName,AppDate,AppTime,AppDateTime,PatientName,Mobile,Address,EntryDateTime,EntryById,EntryByName,  ");
                sb.Append(" Address1,Address2,PinCode,EmailID,Investigation,TotalAmt,AgeYear, AgeMonth, AgeDays, Gender,PanelID,Referdoctor,Title,CentreID)");
                sb.Append(" VALUES ('" + phelbo + "', ");
                sb.Append(" '" + phelboname + "','" + appdate + "','" + time + "','" + appdatetime + "','" + pname + "','" + mobile + "','" + address + "',NOW(),  ");
                sb.Append(" '" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "', ");
                sb.Append(" '" + address1 + "','" + address2 + "','" + pinno + "','" + emailid + "','" + test + "','" + totalamt + "','" + ageyear + "','" + agemonth + "'");
                sb.Append(" ,'" + agedays + "','" + gender + "','" + PanelID + "','" + DoctorID + "','" + Title + "','" + Centre.ToString() + "') ");
                StockReports.ExecuteDML(sb.ToString());

                return "saved#" + StockReports.ExecuteScalar("select max(id) from f_homecollectiondatanew");
            }
            else
            {
                if (Booked == "1") { return "2"; }
                StringBuilder sb = new StringBuilder();
                sb.Append("update f_homecollectiondatanew set PatientName='" + pname + "',Mobile='" + mobile + "',Address='" + address + "',Address1='" + address1 + "',");
                sb.Append(" Address2='" + address2 + "',PinCode='" + pinno + "',EmailID='" + emailid + "',Investigation='" + test + "',TotalAmt='" + totalamt + "',");
                sb.Append(" AgeYear='" + ageyear + "', AgeMonth='" + agemonth + "', AgeDays='" + agedays + "', Gender='" + gender + "',UpdateDate=now(),");
                sb.Append(" PanelID='" + PanelID + "',Referdoctor='" + DoctorID + "',Title='" + Title + "',CentreID='" + Centre.ToString() + "', ");
                sb.Append(" UpdateByID='" + Util.GetString(HttpContext.Current.Session["ID"]) + "'");
                sb.Append(" ,UpdateByName='" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "' ,isedited=1 where id='" + appid + "'");
                StockReports.ExecuteDML(sb.ToString());
                //return "updated#" + StockReports.ExecuteScalar("select max(id) from f_homecollectiondatanew");

                if (Type == "1")
                {
                    StringBuilder sb1 = new StringBuilder();
                    sb1.Append(" INSERT INTO `f_homecollectiondatanew_update_status`(AppointmentID,DATETIME,UserID,UserName,STATUS,Remarks) VALUES");
                    sb1.Append("('" + appid + "' ,NOW(), '" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',");
                    sb1.Append(" 'Edit', ' ' )");
                    StockReports.ExecuteDML(sb1.ToString());
                }
                return "updated#" + StockReports.ExecuteScalar("select max(id) from f_homecollectiondatanew");
            }
        }
        catch (Exception ex)
        {
            return ex.InnerException.Message.ToString();
        }


    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getoldpatient(string mobile)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,PhlebotomistID,PhlebotomistName,PatientName,Gender,AgeYear,AgeMonth,DATE_FORMAT(AppDate,'%d-%b-%Y')AppDate,TIME_FORMAT(AppTime,'%h:%i %p')AppTime, ");
        sb.Append(" AgeDays,Mobile,EmailID,Address,Address1,Address2,Pincode FROM f_homecollectiondatanew where Mobile='" + mobile + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string rtrn = makejsonoftable(dt, makejson.e_without_square_brackets);

        return rtrn;
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getoldpatientdetail(string ID, string Mobile)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT PhlebotomistID,PhlebotomistName,PatientName,Gender,AgeYear,AgeMonth,AgeDays,DATE_FORMAT(AppDate,'%d-%b-%Y')AppDate,TIME_FORMAT(AppTime,'%h:%i %p')AppTime, ");
        sb.Append(" Mobile,EmailID,Address,Address1,Address2,Pincode FROM f_homecollectiondatanew where Mobile='" + Mobile + "' and ID='" + ID + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string rtrn = makejsonoftable(dt, makejson.e_without_square_brackets);

        return rtrn;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string changeappdatetime(string appid, string date, string time, string phelbo, string phelboname, string remarks, string Centre, string Booked)
    {

        if (Booked == "1") { return "2"; }
        string appdate = Util.GetDateTime(date).ToString("yyyy-MM-dd");
        string appdatetime = Util.GetDateTime(date + " " + time).ToString("yyyy-MM-dd hh:mm:ss");
        StringBuilder sb = new StringBuilder();
        sb.Append(" update f_homecollectiondatanew set  isReschedule=1,RescheduleDate=now(),RescheduleRemarks='" + remarks + "',");
        sb.Append(" RescheduleByName='" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',");
        sb.Append(" RescheduleByID='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',AppDate='" + appdate + "',AppTime='" + time + "',");
        sb.Append(" AppDateTime='" + appdatetime + "',PhlebotomistID='" + phelbo + "',PhlebotomistName='" + phelboname + "',CentreID='" + Centre.ToString() + "' ");
        sb.Append(" where id='" + appid + "' ");

        StockReports.ExecuteDML(sb.ToString());
        StringBuilder sb1 = new StringBuilder();
        sb1.Append(" INSERT INTO `f_homecollectiondatanew_update_status`(AppointmentID,DATETIME,UserID,UserName,STATUS,Remarks) VALUES");
        sb1.Append("('" + appid + "' ,NOW(), '" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',");
        sb1.Append(" 'Update', ' ' )");
        StockReports.ExecuteDML(sb1.ToString());
        return "1";

        // StringBuilder sb1 = new StringBuilder();
        // sb1.Append(" INSERT INTO `f_homecollectiondatanew_update_status`(AppointmentID,DATETIME,UserID,UserName,STATUS,Remarks) VALUES");
        // sb1.Append("('" + appid + "' ,NOW(), '" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',");
        // sb1.Append(" 'Edit', ' ' )");
        // StockReports.ExecuteDML(sb1.ToString());
        // }


    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getappdata(string phelbo, string date, string time, string Centre)
    {


        StringBuilder sb = new StringBuilder();
        sb.Append(" select isedited,UpdateByName,IsBooked,date_format(UpdateDate,'%d-%m-%Y %h:%I %p') uupdate, (CASE   WHEN Iscancel = '1' THEN 'Pink' WHEN IsBooked = '0' ");
        sb.Append(" THEN 'yellow'  WHEN IsBooked = '1' THEN '#90EE90'  ELSE  '#90EE90'    END)RowColor , cancelreason,Iscancel");
        sb.Append(" , id, PatientName, CONCAT(CONCAT(IF(ageyear<>0,CONCAT(ageyear,' Y'),''),IF(agemonth<>0,CONCAT(' ',agemonth,' M'),''),");
        sb.Append("IF(agedays<>0,CONCAT(' ',agedays,' D'),'')),'/',LEFT(gender,1)) pinfo");
        sb.Append(" ,Mobile,concat(Address,' ',ifnull(Address1,''),' ',ifnull(Address2,''),' ',ifnull(pincode,'')) Address ,EmailID,TotalAmt,");
        sb.Append(" Investigation,DATE_FORMAT(appdate,'%d-%m-%Y') appdate,DATE_FORMAT(apptime,'%h:%i %p')apptime ");
        sb.Append(" FROM f_homecollectiondatanew  ");
        sb.Append(" where  appdate='" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "' ");
        sb.Append(" and CentreID='" + Centre + "'   ");
        sb.Append(" and PhlebotomistID='" + phelbo + "' and apptime='" + Util.GetDateTime(time).ToString("HH:mm:ss") + "'");



        DataTable dt = StockReports.GetDataTable(sb.ToString());

        DataColumn dcm = new DataColumn();
        dcm.ColumnName = "mytest";
        dt.Columns.Add(dcm);
        string ss = "";

        foreach (DataRow dwc in dt.Rows)
        {
            ss = "";
            try
            {
                foreach (string ss1 in dwc["Investigation"].ToString().Split('#'))
                {
                    if (ss1 != "")
                    {
                        ss += ss1.Split('_')[1] + "^";
                    }
                }
                dwc["mytest"] = ss;
            }
            catch
            {
                dwc["mytest"] = ss;
            }
        }

        dt.AcceptChanges();
        string rtrn = makejsonoftable(dt, makejson.e_without_square_brackets);
        return rtrn;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string editappgetdata(string id)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT PatientName,AgeYear,AgeMonth,AgeDays,Gender,Mobile,EmailID,PanelID,Referdoctor,");
        sb.Append("Address,Address1,Address2,PinCode,Investigation,TotalAmt,CentreID,IsBooked ");
        sb.Append("FROM f_homecollectiondatanew WHERE id='" + id + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string rtrn = makejsonoftable(dt, makejson.e_without_square_brackets);
        return rtrn;


    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string cencelapp(string id, string reason)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("");
        sb.Append(" update f_homecollectiondatanew set Iscancel=1,CancelDate=now(),CancelById='" + Util.GetString(HttpContext.Current.Session["ID"]) + "', ");
        sb.Append(" CancelByName='" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',cancelreason='" + reason + "' where id='" + id + "'");

        StockReports.ExecuteDML(sb.ToString());
        return "1";
    }



    void bindgenratecalender()
    {



    }

    public static string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));


            }
            sb.Append(sb2.ToString());
            sb.Append("}");


        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();


    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveNewHomeCollLog(string MobileNo, string CallBy, string CallByID, string CallType, string Remarks,string Name,string centreID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string ID = "";
            Patient_Estimate_Log pelObj = new Patient_Estimate_Log(tnx);
            pelObj.Mobile = MobileNo;
            pelObj.Call_By = CallBy;
            pelObj.Call_By_ID = CallByID;
            pelObj.Call_Type = CallType;
            pelObj.UserName = UserInfo.LoginName;
            pelObj.UserID = UserInfo.ID;
            pelObj.Remarks = Remarks;
            pelObj.Name = Name;
            pelObj.CentreID = centreID;
            ID = pelObj.Insert();

            if (ID == string.Empty)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return string.Empty;
            }
            else
            {
                tnx.Commit();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return "1";
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.GetBaseException());
        }
        finally { }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindCentre(string StateID, string BusinessZoneID)
    {
        StringBuilder sb = new StringBuilder();
        if (StateID != "0")
        {
            sb.Append(" SELECT cm.CentreID,cm.Centre FROM centre_master cm WHERE cm.isactive=1 AND  cm.BusinessZoneID='" + BusinessZoneID + "'  ");
            if (StateID != "-1")
            {
                sb.Append(" AND cm.StateID='" + StateID + "' ");
            }
            sb.Append("   ORDER BY cm.Centre ");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return null;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetRemarks()
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" SELECT RemarksValue,Remarks FROM Call_Centre_Remarks WHERE IsActive='1'");
            string rtrn = makejsonoftable(dt, makejson.e_without_square_brackets);
            return rtrn;
        }
        catch (Exception ex)
        {
            return "";
        }
    }
}
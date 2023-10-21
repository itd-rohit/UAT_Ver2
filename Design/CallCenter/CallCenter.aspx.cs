using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CallCenter_CallCenter : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string cmd = Util.GetString(Request.QueryString["cmd"]);
        string rtrn = "";
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            ddltitle.DataSource = AllGlobalFunction.NameTitle;
            ddltitle.DataBind();
            AllLoad_Data.bindState(ddlstate);
        }
        if (cmd == "GetDoctorList")
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(GetDoctorList());

            Response.Clear();
            Response.ContentType = "application/json; charset=utf-8";
            Response.Write(rtrn);
            Response.End();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveNewPatient(string Mobile, string Title, string Name, string Age, string AgeYear, string AgeMonth, string AgeDays, string TotalAgeInDays, string DOB, string Gender, string State, string City, string Locality, string StateID, string CityID, string localityid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string query = "INSERT INTO patient_master_callcentre(Title,PName,DOB,Age,AgeYear,AgeMonth,AgeDays,TotalAgeInDays,Gender,stateid,State,cityid,City,localityid,Locality,dtEntry,UserName,UserID,Mobile) VALUES('" + Title + "','" + Name + "','" + Util.GetDateTime(DOB).ToString("yyyy-MM-dd") + "','" + Age + "','" + Util.GetInt(AgeYear) + "','" + Util.GetInt(AgeMonth) + "','" + Util.GetInt(AgeDays) + "','" + Util.GetInt(TotalAgeInDays) + "','" + Gender + "','" + StateID + "','" + State + "','" + CityID + "','" + City + "','" + localityid + "','" + Locality + "',NOW(),'" + UserInfo.LoginName + "','" + UserInfo.ID + "','" + Mobile + "')";
            StockReports.ExecuteDML(query);
            return "1";
        }
        catch (Exception ex)
        {
            return "0";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveNewEstimateLog(string MobileNo, string CallBy, string CallByID, string CallType, string Remarks)
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
    public static string bindCentre(string StateID, string BusinessZoneID, string CityID, string CallBy)
    {
        StringBuilder sb = new StringBuilder();
        if (StateID != "0")
        {
            if (CallBy == "1")
            {
                sb.Append(" SELECT cm.CentreID,cm.Centre FROM centre_master cm WHERE cm.isactive=1 AND  cm.BusinessZoneID='" + BusinessZoneID + "'  ");
                if (StateID != "-1")
                {
                    sb.Append(" AND cm.StateID='" + StateID + "' ");
                }
                if (CityID != "-1")
                {
                    sb.Append(" AND cm.CityID IN (" + CityID + ") ");
                }
                sb.Append("   ORDER BY cm.Centre ");
            }
            if (CallBy == "2")
            {

                // for PUP 

                sb.Append(" SELECT distinct cm.CentreID,cm.Centre FROM centre_master cm  ");
                sb.Append(" INNER JOIN f_panel_master pm ON pm.`TagProcessingLabID`=cm.`CentreID` AND pm.`PanelType`='PUP' AND pm.`IsActive`=1 WHERE cm.isactive=1 AND  cm.BusinessZoneID='" + BusinessZoneID + "' ");
                if (StateID != "-1")
                {
                    sb.Append(" AND cm.StateID='" + StateID + "' ");
                }
                if (CityID != "-1")
                {
                    sb.Append(" AND cm.CityID IN (" + CityID + ") ");
                }
                sb.Append("   ORDER BY cm.Centre ");
            }
            // for PCC
            if (CallBy == "3")
            {
                sb.Append(" SELECT distinct cm.CentreID,cm.Centre FROM centre_master cm WHERE cm.isactive=1 AND type1='PCC' and cm.BusinessZoneID='" + BusinessZoneID + "'  ");

                if (StateID != "-1")
                {
                    sb.Append(" AND cm.StateID='" + StateID + "' ");
                }
                if (CityID != "-1")
                {
                    sb.Append(" AND cm.CityID IN (" + CityID + ") ");
                }
                sb.Append("   ORDER BY cm.Centre ");
            }




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
    public static string Doctorbind(string centreid)
    {

        StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT Doctor_ID,CONCAT(title,NAME)NAME FROM doctor_referal WHERE IsActive=1 ");
        sb.Append(" SELECT Doctor_ID, NAME FROM doctor_referal WHERE doctor_id <=2 ");
        sb.Append(" UNION ALL   ");
        sb.Append(" SELECT dr.doctor_id VALUE,CONCAT(title,dr.NAME) NAME   ");
        sb.Append(" FROM doctor_referal dr  ");
        sb.Append(" INNER JOIN `doctor_referal_centre` drc ON drc.`Doctor_ID`=dr.`Doctor_ID` AND drc.`CentreID` IN (" + centreid + ")  ");
        sb.Append(" WHERE dr.isactive=1   ");
        sb.Append("  GROUP BY dr.Doctor_ID  ORDER BY NAME -- LIMIT 20 ");
        DataTable dtdoctor = StockReports.GetDataTable(sb.ToString());
        string retrn = Newtonsoft.Json.JsonConvert.SerializeObject(dtdoctor);
        return retrn;
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string DoctorbindDetail(string DoctorID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(dr.Title,'',dr.Name)NAME,dr.Doctor_ID,dr.DoctorCode,dr.Mobile,dr.Specialization,dr.Degree,dr.Email,");
        sb.Append(" (SELECT DATE_FORMAT(dtEntry,'%d-%b-%Y %h:%I %p')dtEntry FROM `call_centre_log` ccl WHERE ccl.Call_By_ID=dr.Doctor_ID ORDER BY dtentry DESC LIMIT 1) lastcall, ");
        sb.Append("(SELECT Call_Type FROM `call_centre_log` ccl WHERE ccl.Call_By_ID=dr.Doctor_ID ORDER BY dtentry DESC LIMIT 1) calltype ");
        sb.Append("FROM doctor_referal dr ");
        sb.Append(" WHERE dr.Doctor_ID='" + DoctorID + "'");
        DataTable dtdoctor = StockReports.GetDataTable(sb.ToString());
        string retrn = Newtonsoft.Json.JsonConvert.SerializeObject(dtdoctor);
        return retrn;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindPanel(string BusinessZoneID, string StateID, string CityID, string CentreID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT CONCAT(pn.`Panel_ID`,'#',pn.ReferenceCodeOPD,'#',if(pn.paneltype='PUP',pn.TagprocessingLabID,pn.CentreID))Panel_ID,pn.`Company_Name`  ");
        sb.Append("   FROM Centre_Panel cp   ");
        sb.Append("  INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id  ");
        sb.Append("  INNER JOIN `centre_master` cm ON pn.`TagProcessingLabID`= cm.`CentreID`  ");
        sb.Append("  AND cm.`BusinessZoneID` ='" + BusinessZoneID.Trim() + "'  ");
        if (StateID.Trim() != "-1")
            sb.Append("   AND cm.`StateID`='" + StateID.Trim() + "'  ");
        if (CityID.Trim() != "-1")
            //  sb.Append(" AND cm.`CityID` ='" + CityID.Trim() + "' ");
            sb.Append(" AND cm.`CentreID` IN (" + CentreID + ") ");
        sb.Append(" AND cp.isActive=1 AND pn.isActive=1  ");
        sb.Append("  ORDER BY pn.company_name  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string PenelbindDetail(string PanelID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pn.`Company_Name`,pn.`Panel_ID`,pn.Panel_Code,pn.Mobile,pn.EmailID, ");
        sb.Append(" (SELECT DATE_FORMAT(dtEntry,'%d-%b-%Y %h:%I %p')dtEntry FROM `call_centre_log` ccl WHERE ccl.Call_By_ID=pn.`Panel_ID` ORDER BY dtentry DESC LIMIT 1) lastcall, ");
        sb.Append(" (SELECT Call_Type FROM `call_centre_log` ccl WHERE ccl.Call_By_ID=pn.`Panel_ID` ORDER BY dtentry DESC LIMIT 1) calltype  ");
        sb.Append(" FROM f_panel_master pn ");
        sb.Append("  WHERE pn.`Panel_ID`='" + PanelID.Split('#')[0] + "' ");
        DataTable dtdoctor = StockReports.GetDataTable(sb.ToString());
        string retrn = Newtonsoft.Json.JsonConvert.SerializeObject(dtdoctor);
        return retrn;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string PccbindDetail(string CentreID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cn.CentreID,cn.`Centre`,cn.CentreCode,cn.Mobile,cn.Email,  ");
        sb.Append(" (SELECT DATE_FORMAT(dtEntry,'%d-%b-%Y %h:%I %p')dtEntry FROM `call_centre_log` ccl WHERE ccl.Call_By_ID=cn.CentreID ORDER BY dtentry DESC LIMIT 1) lastcall,  ");
        sb.Append(" (SELECT Call_Type FROM `call_centre_log` ccl WHERE ccl.Call_By_ID=cn.CentreID ORDER BY dtentry DESC LIMIT 1) calltype   ");
        sb.Append(" FROM centre_master cn   WHERE cn.CentreID ='" + CentreID + "' ");
        DataTable dtdoctor = StockReports.GetDataTable(sb.ToString());
        string retrn = Newtonsoft.Json.JsonConvert.SerializeObject(dtdoctor);
        return retrn;
    }
    [WebMethod]
    DataTable GetDoctorList()
    {
        string abc = Request.QueryString["TestName"];
        string Category = Request.QueryString["Category"];
        string CallBy = Request.QueryString["CallBy"];
        StringBuilder sb = new StringBuilder();
        if (CallBy == "1")
        {
            sb.Append(" SELECT dr.`State` StateID,dr.`City` CityID,dr.`CentreID` dCenterID,drc.`CentreID`,(SELECT BusinessZoneID FROM state_master WHERE id=dr.`State`) BusinessZoneID,CONCAT(dr.Title,'',dr.Name) value,dr.Doctor_ID,'' Panel_ID,'' pccid,dr.DoctorCode,dr.Mobile,dr.Specialization,dr.Degree,  ");
            sb.Append(" (SELECT DATE_FORMAT(dtEntry,'%d-%b-%Y %h:%I %p')dtEntry FROM `call_centre_log` ccl WHERE ccl.Call_By_ID=dr.Doctor_ID ORDER BY dtentry DESC LIMIT 1)  ");
            sb.Append(" lastcall, (SELECT Call_Type FROM `call_centre_log` ccl WHERE ccl.Call_By_ID=dr.Doctor_ID ORDER BY dtentry DESC LIMIT 1)  ");
            sb.Append(" calltype FROM doctor_referal dr INNER JOIN `doctor_referal_centre` drc ON drc.`Doctor_ID`=dr.`Doctor_ID` WHERE ");
            if (Category == "Name")
            {
                sb.Append(" CONCAT(dr.Title,'',dr.Name) like '%" + abc + "%' ");
            }
            if (Category == "Mobile")
            {
                sb.Append(" dr.Mobile='" + abc + "' "); ;
            }
            sb.Append(" GROUP BY dr.Doctor_ID ");
        }
        if (CallBy == "2")
        {
            sb.Append(" SELECT cm.`CentreID`,cm.`StateID`,cm.`CityID`,cm.`BusinessZoneID`,pn.`Company_Name` value,CONCAT(pn.`Panel_ID`,'#',pn.ReferenceCodeOPD,'#',if(pn.paneltype='PUP',pn.TagprocessingLabID,pn.CentreID)) Panel_ID,pn.Panel_Code,pn.Mobile,'' Doctor_ID,'' pccid,  ");
            sb.Append(" (SELECT DATE_FORMAT(dtEntry,'%d-%b-%Y %h:%I %p')dtEntry FROM `call_centre_log` ccl WHERE ccl.Call_By_ID=pn.`Panel_ID` ORDER BY dtentry DESC LIMIT 1) lastcall,  ");
            sb.Append(" (SELECT Call_Type FROM `call_centre_log` ccl WHERE ccl.Call_By_ID=pn.`Panel_ID` ORDER BY dtentry DESC LIMIT 1) calltype   ");
            sb.Append(" FROM f_panel_master pn  ");
            sb.Append(" INNER JOIN centre_master cm ON pn.`TagProcessingLabID`= cm.`CentreID` WHERE ");
            if (Category == "Name")
            {
                sb.Append(" pn.`Company_Name` like '%" + abc + "%' ");
            }
            if (Category == "Mobile")
            {
                sb.Append(" pn.Mobile='" + abc + "' "); ;
            }
        }
        if (CallBy == "3")
        {
            sb.Append(" SELECT cm.CentreID,cm.CentreID pccid,cm.`StateID`,cm.`CityID`,cm.`BusinessZoneID`,cm.`Centre` value,cm.CentreCode,cm.Mobile, '' Panel_ID,'' Doctor_ID,   ");
            sb.Append(" (SELECT DATE_FORMAT(dtEntry,'%d-%b-%Y %h:%I %p')dtEntry FROM `call_centre_log` ccl  ");
            sb.Append(" WHERE ccl.Call_By_ID=cm.CentreID ORDER BY dtentry DESC LIMIT 1) lastcall,    ");
            sb.Append(" (SELECT Call_Type FROM `call_centre_log` ccl WHERE ccl.Call_By_ID=cm.CentreID ORDER BY dtentry DESC LIMIT 1) calltype  FROM centre_master cm   WHERE type1='PCC' AND ");
            if (Category == "Name")
            {
                sb.Append(" cm.Centre like '%" + abc + "%' ");
            }
            if (Category == "Mobile")
            {
                sb.Append(" cm.Mobile='" + abc + "' "); ;
            }
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
}
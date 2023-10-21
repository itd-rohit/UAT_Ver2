<%@ WebService Language="C#" Class="OldPatientData" %>
using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Newtonsoft;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Web.Script.Services;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]

// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class OldPatientData : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindOldPatient(List<string> searchdata, string Name, string Fromdate, string ToDate)
    {
        string retr = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.patient_id,pm.title,pm.pname,pm.house_no,pm.localityID,pm.cityID,IF(pm.pincode=0,'',pm.pincode)pincode,pm.stateID,pm.country,pm.mobile, pm.email,");
        sb.Append(" pm.ageyear,pm.agemonth,pm.agedays,pm.gender,DATE_FORMAT(pm.dob,'%d-%b-%Y') dob,pm.age,DATE_FORMAT(pm.dob,'%d-%b-%Y') dob,DATE_FORMAT(pm.dtEntry,'%d-%b-%Y %h:%I %p') visitdate,pm.State,pm.City,pm.Locality  ");
        sb.Append(" ,(SELECT DATE_FORMAT(dtEntry,'%d-%b-%Y %h:%I %p')dtEntry FROM `call_centre_log` ccl WHERE ");
        if (searchdata[0] != "")
        {
            sb.Append(" ccl.Mobile='" + searchdata[0] + "' ");
        }
        if (searchdata[0] != "" && Name != "")
        {
            sb.Append(" and ");
        }
        if (Name != "")
        {
            sb.Append(" ccl.Name='" + Name + "' ");
        }
        if (Fromdate != "" && ToDate != "")
        {
            if (searchdata[0] != "" && Name != "")
            {
                sb.Append(" and ");
            }
            sb.Append(" dtEntry >='" + (Util.GetDateTime(Fromdate).ToString("yyyy-MM-dd") + " " + "00:00:00") + "' ");
            sb.Append(" and dtEntry <='" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + "23:59:59") + "' ");
        }
        sb.Append(" ORDER BY dtentry DESC LIMIT 1) lastcall, ");
        sb.Append(" (SELECT Call_Type FROM `call_centre_log` ccl WHERE ");
        if (searchdata[0] != "")
        {
            sb.Append(" ccl.Mobile='" + searchdata[0] + "' ");
        }
        if (searchdata[0] != "" && Name != "") {
            sb.Append(" and ");
        }
        if (Name != "")
        {
            sb.Append(" ccl.Name='" + Name + "' ");
        }
        if (Fromdate != "" && ToDate != "")
        {
            if (searchdata[0] != "" && Name != "")
            {
                sb.Append(" and ");
            }
            sb.Append(" dtEntry >='" + (Util.GetDateTime(Fromdate).ToString("yyyy-MM-dd") + " " + "00:00:00") + "' ");
            sb.Append(" and dtEntry <='" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + "23:59:59") + "' ");
        }
        sb.Append(" ORDER BY dtentry DESC LIMIT 1) calltype ");
        sb.Append(" FROM patient_master pm where  patient_id<>'' ");
        if (Fromdate == "" && ToDate == "")
        {
            if (searchdata[0] != "")
            {
                sb.Append(" and mobile='" + searchdata[0] + "'");
            }
            if (Name != "")
            {
                sb.Append(" and PName = '" + Name + "'");
            }
        }
        if (Fromdate != "" && ToDate != "") {
            sb.Append(" and dtEntry >='" + (Util.GetDateTime(Fromdate).ToString("yyyy-MM-dd") + " " +"00:00:00") + "' ");
            sb.Append(" and dtEntry <='" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + "23:59:59") + "' ");
        }
        sb.Append(" order by dtEntry ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            StringBuilder sb1 = new StringBuilder();
            // sb.Append(" SELECT patient_id,title,pname,house_no,locality,city,IF(pincode=0,'',pincode)pincode,state,country,mobile, email,");
            sb1.Append(" SELECT ID patient_id,title,pname,localityID,cityID,stateID,mobile,'' email, ");
            sb1.Append(" ageyear,agemonth,agedays,gender,DATE_FORMAT(dob,'%d-%b-%Y') dob,age,DATE_FORMAT(dob,'%d-%b-%Y') dob,DATE_FORMAT(dtEntry,'%d-%b-%Y %h:%I %p') visitdate,State,City,Locality ");
            sb1.Append(" ,(SELECT  DATE_FORMAT(dtEntry,'%d-%b-%Y %h:%I %p')dtEntry FROM `call_centre_log` ccl WHERE ");
            if (searchdata[0] != "")
            {
                sb1.Append("ccl.Mobile='" + searchdata[0] + "' ");
            }
            if (searchdata[0] != "" && Name != "")
            {
                sb1.Append(" and ");
            }
            if (Name != "")
            {
                sb1.Append(" ccl.Name='" + Name + "' ");
            }
            if (Fromdate != "" && ToDate != "")
            {
                if (searchdata[0] != "" && Name != "")
                {
                    sb.Append(" and ");
                }
                sb.Append(" dtEntry >='" + (Util.GetDateTime(Fromdate).ToString("yyyy-MM-dd") + " " + "00:00:00") + "' ");
                sb.Append(" and dtEntry <='" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + "23:59:59") + "' ");
            }
            sb1.Append(" ORDER BY dtentry DESC LIMIT 1) lastcall, ");
            sb1.Append(" (SELECT Call_Type FROM `call_centre_log` ccl WHERE ");
            if (searchdata[0] != "")
            {
                sb1.Append("ccl.Mobile='" + searchdata[0] + "' ");
            }
            if (searchdata[0] != "" && Name != "")
            {
                sb1.Append(" and ");
            }
            if (Name != "")
            {
                sb1.Append(" ccl.Name='" + Name + "' ");
            }
            if (Fromdate != "" && ToDate != "")
            {
                if (searchdata[0] != "" && Name != "")
                {
                    sb.Append(" and ");
                }
                sb.Append(" dtEntry >='" + (Util.GetDateTime(Fromdate).ToString("yyyy-MM-dd") + " " + "00:00:00") + "' ");
                sb.Append(" and dtEntry <='" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + "23:59:59") + "' ");
            }
            sb1.Append("ORDER BY dtentry DESC LIMIT 1) calltype ");
            sb1.Append(" FROM patient_master_callcentre ");
            if (Fromdate == "" && ToDate == "")
            {
                if (searchdata[0] != "")
                {
                    sb1.Append(" where mobile='" + searchdata[0] + "'");
                }
                if (searchdata[0] != "" && Name != "")
                {
                    sb1.Append(" and ");
                }
                if (Name != "")
                {
                    sb1.Append(" PName='" + Name + "' ");
                }
            }
            if (Fromdate != "" && ToDate != "")
            {
                sb.Append(" and dtEntry >='" + (Util.GetDateTime(Fromdate).ToString("yyyy-MM-dd") + " " + "00:00:00") + "' ");
                sb.Append(" and dtEntry <='" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + "23:59:59") + "' ");
            }
            sb1.Append(" order by dtEntry ");
            DataTable dt1 = StockReports.GetDataTable(sb1.ToString());
            retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt1);
        }
        return retr;

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string CallDetails(string CallBy,string ID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ccl.ID,ccl.Mobile,ccl.Call_By,ccl.Call_By_ID,ccl.Call_Type,ccl.Remarks,DATE_FORMAT(ccl.dtEntry,'%d-%b-%Y %h:%I %p')dtEntry,ccl.`UserName` FROM `call_centre_log` ccl WHERE Call_By='" + CallBy + "' AND ccl.Call_By_ID='" + ID + "' ORDER BY ccl.dtEntry  DESC ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return retr;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindDropData(string MobileNo)
    {
        string retr = "";
        StringBuilder sb1 = new StringBuilder();
        sb1.Append(" SELECT lt.CentreID,CONCAT(pmm.`Panel_ID`,'#',pmm.ReferenceCodeOPD,'#',if(pmm.paneltype='PUP',pmm.TagprocessingLabID,pmm.CentreID))Panel_ID,'main' masterID,pm.Patient_ID,pm.stateid,pm.cityid,sm.BusinessZoneID,  plo.result_flag,plo.IsRefund,plo.ItemID,plo.Investigation_ID,itm.typename item,itm.testcode testcode,plo.rate,plo.DiscountAmt,plo.amount,DATE_FORMAT(plo.`DeliveryDate`,'%d-%b-%Y %I:%i %p') DeliveryDate FROM patient_master pm ");
        sb1.Append("  INNER JOIN state_master sm ON pm.stateid=sm.id ");
        sb1.Append("  INNER JOIN patient_labinvestigation_opd plo ON pm.Patient_ID=plo.Patient_ID ");
        sb1.Append("  INNER JOIN f_Itemmaster itm  ON itm.ItemID = plo.ItemID  ");
        sb1.Append("  INNER JOIN f_ledgertransaction lt ON  lt.Patient_ID = plo.Patient_ID ");
        sb1.Append("  INNER JOIN f_panel_master pmm  ON pmm.panel_id = lt.panel_id ");
        sb1.Append("  WHERE pm.Mobile='" + MobileNo + "' ");
        sb1.Append("  ORDER BY pm.dtEntry DESC ");
        DataTable dt1 = StockReports.GetDataTable(sb1.ToString());
        if (dt1.Rows.Count > 0)
        {
            retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt1);
        }
        else
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT '' masterID,pmc.stateid,pmc.cityid,sm.BusinessZoneID FROM patient_master_callcentre pmc ");
            sb.Append(" INNER JOIN state_master sm ON pmc.stateid=sm.id ");
            sb.Append(" WHERE Mobile='" + MobileNo + "' ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return retr;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindDropDoctorData(string MID, string Type)
    {
        string retr = "";
        StringBuilder sb1 = new StringBuilder();
        sb1.Append(" SELECT dr.`State` stateid,dr.`City` cityid,sm.BusinessZoneID ");
        sb1.Append(" FROM doctor_referal dr    ");
        sb1.Append(" INNER JOIN state_master sm ON dr.State=sm.id  ");
        sb1.Append(" WHERE dr.`Doctor_ID`='" + MID + "' ");
        DataTable dt1 = StockReports.GetDataTable(sb1.ToString());
        if (dt1.Rows.Count > 0)
        {
            retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt1);
        }
        return retr;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindDropPUPData(string MID, string Type)
    {
        string retr = "";
        StringBuilder sb1 = new StringBuilder();
        sb1.Append(" SELECT cm.`BusinessZoneID`, cm.`StateID`,cm.`CityID`, CONCAT(pn.`Panel_ID`,'#',pn.ReferenceCodeOPD,'#',IF(pn.paneltype='PUP',pn.TagprocessingLabID,pn.CentreID))Panel_ID ");
        sb1.Append(" FROM Centre_Panel cp     INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id ");
        sb1.Append(" INNER JOIN `centre_master` cm ON cm.`CentreID`=cp.`CentreId` ");
        if (Type == "PUP")
        {
            sb1.Append(" WHERE pn.`Panel_ID`='" + MID + "' ");
        }
        else {
            sb1.Append(" WHERE cm.`CentreID`='" + MID + "' ");
        }
        DataTable dt1 = StockReports.GetDataTable(sb1.ToString());
        if (dt1.Rows.Count > 0)
        {
            retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt1);
        }
        return retr;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string sendEmail(string VisitNo, string EmailID, string Cc, string Bcc)
    {
        string IsSend = "-1";
        try
        {
            StringBuilder sbTempEmailData = new StringBuilder();
            sbTempEmailData.Append("  SELECT lt.LedgerTransactionID,lt.`IsCredit`,lt.`NetAmount`,lt.`Adjustment`, ");
            sbTempEmailData.Append("  IF(ROUND(lt.`NetAmount`)>ROUND(lt.`Adjustment`) AND lt.`IsCredit`=0,'1','0')IsDue,  ");
            sbTempEmailData.Append("   GROUP_CONCAT(Test_id)Test_id, lt.`LedgerTransactionNo`,cm.`Centre`,CONCAT(pm.title,'',pm.Pname)NAME,   ");
            sbTempEmailData.Append("   lt.Username_Web UserID, lt.`Password_web` `Password` FROM patient_master pm  ");
            sbTempEmailData.Append(" INNER JOIN f_ledgertransaction lt ON lt.`Patient_ID`=pm.`Patient_ID` AND lt.LedgerTransactionno='" + VisitNo + "'  AND lt.`IsCancel`=0  ");
            sbTempEmailData.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sbTempEmailData.Append(" AND plo.`Approved`=1 AND plo.`IsReporting`=1  ");
            sbTempEmailData.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`  ");
            sbTempEmailData.Append("   GROUP BY plo.LedgerTransactionID; ");

            DataTable dtEmailData = StockReports.GetDataTable(sbTempEmailData.ToString());
            if (dtEmailData.Rows.Count > 0)
            {

                if (Util.GetString(dtEmailData.Rows[0]["IsDue"]) == "0")
                {
                    try
                    {
                        ReportEmailClass RMail = new ReportEmailClass();
                        StringBuilder EmailBody = new StringBuilder();
                        EmailBody.Append(System.IO.File.ReadAllText(HttpContext.Current.Server.MapPath("~/EmailBody/ReportEmailBody.html")));
                        EmailBody.Replace("{CentreName}", Util.GetString(dtEmailData.Rows[0]["Centre"])).Replace("{UserID}", Util.GetString(dtEmailData.Rows[0]["UserID"])).Replace("{Password}", Util.GetString(dtEmailData.Rows[0]["Password"]));
                        IsSend = RMail.sendEmail(EmailID.Trim(),String.Concat(Resources.Resource.ClientNameShowInApplication, " Diagnostics Report"), EmailBody.ToString(), Cc.Trim(), Bcc.Trim(), Util.GetString(dtEmailData.Rows[0]["LedgerTransactionNo"]), Util.GetString(dtEmailData.Rows[0]["Test_id"]), "Normal", "0", "Lab Report");
                    }
                    catch (Exception ex)
                    {
                        IsSend = "-1";
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                    }
                }
            }
            return IsSend;
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return IsSend;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveData(string checkbocselect, string question, string category, string Type, string TypeName)
    {
        try
        {
            //var item = new System.Web.Script.Serialization.JavaScriptSerializer().ConvertToType<List<TypeName>>(data);
            //foreach (var sr in item)
            //{
            //    string query = "INSERT INTO  call_centre_question(CallType,Question,Category,Type,TypeName,CreatedBy,CreatedID,CreatedDate) VALUES('" + radioselect + "','" + question + "','" + category + "','" + sr.Type + "','" + sr.Name + "','" + UserInfo.LoginName + "','" + UserInfo.ID + "',NOW())";
            //    StockReports.ExecuteDML(query);
            //}
            int checkboclength = checkbocselect.Split(',').Length;
            for (int i = 0; i < checkboclength; i++)
            {
                string query = "INSERT INTO  call_centre_question(CallType,Question,Category,Type,TypeName,CreatedBy,CreatedID,CreatedDate) VALUES('" + checkbocselect.Split(',')[i] + "','" + question + "','" + category + "','" + Type + "','" + TypeName + "','" + UserInfo.LoginName + "','" + UserInfo.ID + "',NOW())";
                StockReports.ExecuteDML(query);
            }
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

}
public class TypeName
{
    public string Type { get; set; }
    public string Name { get; set; }
}
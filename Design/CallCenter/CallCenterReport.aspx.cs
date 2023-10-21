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

public partial class Design_CallCenter_CallCenterReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetCallCenterReport(string SelectedType, string SearchValue, string FromDate, string ToDate, string CallBy, string ResonOfCall)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ccl.Name,ccl.`Mobile`,ccl.`Call_By`,ccl.`Call_By_ID`, ccl.`Call_Type` ReasonOfCall,ccl.`UserName`,ccl.`Remarks`,DATE_FORMAT(ccl.dtEntry,'%d-%b-%Y %h:%I %p')'Call Date' FROM `call_centre_log` ccl WHERE  ");
        if (CallBy != "")
        {
            sb.Append("ccl.`Call_By`='" + CallBy.Trim() + "' AND ");
        }
        if (ResonOfCall != "")
        {
            sb.Append("ccl.`Call_Type`='" + ResonOfCall.Trim() + "' AND ");
        }
        if (SearchValue != "")
        {
            sb.Append(" " + SelectedType + "='" + SearchValue + "' AND ");
        }
        sb.Append(" ccl.`dtEntry` >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND ccl.`dtEntry` <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append("  ORDER BY ccl.dtEntry  DESC ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return retr;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetCallCenterDetailReport(string SelectedType, string SearchValue, string FromDate, string ToDate, string CallBy, string ResonOfCall, string CentreID)
    {
        StringBuilder sb = new StringBuilder();
        if (CallBy == "Patient" && ResonOfCall == "HomeCollection")
        {
            sb.Append(" SELECT ccl.Mobile,ccl.Name,hm.PhlebotomistName,cm.Centre,pm.Company_Name Panel,dr.Name DoctorName,");
            sb.Append(" ccl.`Call_By`, ccl.`Call_Type` ReasonOfCall,ccl.`UserName` CallAttend,ccl.`Remarks`,DATE_FORMAT(ccl.dtEntry,'%d-%b-%Y %h:%I %p')'Call Date', ");
            sb.Append(" hm.Gender,hm.EmailID, hm.Investigation,hm.TotalAmt ");
        }
        else if (CallBy == "ALL" && ResonOfCall == "HomeCollection")
        {
            sb.Append(" SELECT ccl.Mobile,ccl.Name,hm.PhlebotomistName,cm.Centre,pm.Company_Name Panel,dr.Name DoctorName,");
            sb.Append(" ccl.`Call_By`, ccl.`Call_Type` ReasonOfCall,ccl.`UserName` CallAttend,ccl.`Remarks`,DATE_FORMAT(ccl.dtEntry,'%d-%b-%Y %h:%I %p')'Call Date', ");
            sb.Append(" hm.Gender,hm.EmailID, hm.Investigation,hm.TotalAmt ");
        }
        else
        {
            sb.Append(" SELECT ccf.`ID`,ccl.Name,ccl.`Mobile`,ccl.`Call_By`, ccl.`Call_Type` ReasonOfCall,ccl.`UserName` CallAttend,ccl.`Remarks`,DATE_FORMAT(ccl.dtEntry,'%d-%b-%Y %h:%I %p')'Call Date', ");
            sb.Append(" ccf.`Question`,ccf.`Answer`,ccf.`Email`,ccf.`DOB`,ccf.`Address` ");
        }
        sb.Append(" FROM `call_centre_log` ccl ");
        if (CallBy == "Patient" && ResonOfCall == "HomeCollection")
        {
            sb.Append(" INNER JOIN f_homecollectiondatanew hm ON hm.CentreID= ccl.CentreID ");
            sb.Append(" LEFT JOIN `centre_master` cm ON ccl.centreID=cm.CentreID ");
            sb.Append(" LEFT JOIN f_panel_master pm ON hm.PanelID=pm.Panel_ID ");
            sb.Append(" LEFT JOIN doctor_referal dr ON hm.Referdoctor=dr.`Doctor_ID` ");
            sb.Append(" WHERE ");
        }
        else if (CallBy == "ALL" && ResonOfCall == "HomeCollection")
        {
            sb.Append(" INNER JOIN f_homecollectiondatanew hm ON hm.CentreID= ccl.CentreID ");
            sb.Append(" LEFT JOIN `centre_master` cm ON ccl.centreID=cm.CentreID ");
            sb.Append(" LEFT JOIN f_panel_master pm ON hm.PanelID=pm.Panel_ID ");
            sb.Append(" LEFT JOIN doctor_referal dr ON hm.Referdoctor=dr.`Doctor_ID` ");
            sb.Append(" WHERE ");
        }
        else
        {
            sb.Append(" INNER JOIN `call_centre_feedbkanswer` ccf ON ccl.`Call_By_ID`=ccf.`FeedBackID` WHERE  ");
        }
        if (CallBy != "")
        {
            if (CallBy != "ALL")
            {
                sb.Append("ccl.`Call_By`='" + CallBy.Trim() + "' AND ");
            }
        }
        if (ResonOfCall != "")
        {
            sb.Append("ccl.`Call_Type`='" + ResonOfCall.Trim() + "' AND ");
        }
        if (SearchValue != "")
        {
            sb.Append(" " + SelectedType + "='" + SearchValue + "' AND ");
        }
        if (CentreID != "")
        {
            sb.Append(" ccl.`CentreID` IN(" + CentreID + ") AND ");
        }
        sb.Append(" ccl.`dtEntry` >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND ccl.`dtEntry` <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (CallBy == "Patient" && ResonOfCall == "HomeCollection")
        {
            sb.Append(" GROUP BY hm.ID ORDER BY ccl.ID DESC ");
        }
        else if (CallBy == "ALL" && ResonOfCall == "HomeCollection")
        {
            sb.Append(" GROUP BY hm.ID ORDER BY ccl.ID DESC ");
        }
        else
        {
            sb.Append("  GROUP BY ccf.`ID`  ORDER BY ccf.ID  DESC  ");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["ReportName"] = "FeedBack and Suggestion";
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            return "Excel";
        }
        else
        {
            return "";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string ExcelToExport(string SelectedType, string SearchValue, string FromDate, string ToDate, string CallBy, string ResonOfCall)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ccl.Name,ccl.`Mobile`,ccl.`Call_By`, ccl.`Call_Type` ReasonOfCall,ccl.`UserName` CallAttend,ccl.`Remarks`,DATE_FORMAT(ccl.dtEntry,'%d-%b-%Y %h:%I %p')'Call Date' FROM `call_centre_log` ccl WHERE  ");
        if (CallBy != "")
        {
            if (CallBy != "ALL")
            {
                sb.Append("ccl.`Call_By`='" + CallBy.Trim() + "' AND ");
            }
        }
        if (ResonOfCall != "")
        {
            sb.Append("ccl.`Call_Type`='" + ResonOfCall.Trim() + "' AND ");
        }
        if (SearchValue != "")
        {
            sb.Append(" " + SelectedType + "='" + SearchValue + "' AND ");
        }
        sb.Append(" ccl.`dtEntry` >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND ccl.`dtEntry` <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append("  ORDER BY ccl.dtEntry  DESC ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["ReportName"] = "FeedBack and Suggestion";
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            return "Excel";
        }
        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindCentre()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT cm.CentreID,cm.Centre FROM centre_master cm WHERE cm.isactive=1 ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else
            {
                return "";
            }
        }
        catch (Exception ex)
        {
            return "";
        }
    }
}
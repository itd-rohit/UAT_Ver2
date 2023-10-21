using MySql.Data.MySqlClient;
using Newtonsoft.Json;
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

public partial class Design_Quality_QCFailRCA_Report : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ddlprocessinglab.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and  cm.CentreID in (SELECT centreid FROM f_login WHERE employeeid=" + UserInfo.ID + " GROUP BY centreid) and cm.isActive=1 ORDER BY centre");
        //ddlprocessinglab.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 ORDER BY centre");
        ddlprocessinglab.DataValueField = "centreid";
        ddlprocessinglab.DataTextField = "centre";
        ddlprocessinglab.DataBind();
        //txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        //txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        //txtdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        //CalendarExtender1.EndDate = DateTime.Now;
        //canverify = StockReports.ExecuteScalar("SELECT COUNT(1) FROM `qc_approvalright` WHERE employeeid=" + UserInfo.ID + " AND active='1' AND apprightfor='QC' AND typeid='16' ");

    }

    [WebMethod(EnableSession = true)]
    public static string bindcontrol(string labid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(controlname,' # ',lotnumber) controlname, controlid FROM qc_control_centre_mapping ");
        sb.Append(" WHERE centreid in(" + labid + ") GROUP BY controlid order by  controlname ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public static string bindMachine(string labid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT machineid MacID,CONCAT(machineid,' # ',mm.name) machinename  FROM " + Util.getApp("MachineDB") + ".`mac_machinemaster` mmc INNER JOIN macmaster mm ON mm.ID=mmc.groupid and mm.isactive=1 WHERE centreid in(" + labid + ")  ORDER BY machineid"));

    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static Dictionary<string, string> showreadingexcel(string labid, string controlid, string MachineId)
    {
        try
        {
            string AllMachine = "";
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT  ");
            sb.Append("  cm.`Centre`,moq.ControlName,moq.Machine_Id,moq.Machine_ParamID,moq.Level,moq.QCStatus,qqf.`Comment` as 'RCA Comment', moq.`RCAType`,DATE_FORMAT(moq.dtEntry,'%d-%b-%Y %h:%i %p') CommentDate, moq.LabObservation_Name 'Parameter Name',moq.LabNo,moq.AssayNo,moq.OldReading,moq.Reading ");
            sb.Append("  ");
            sb.Append(" FROM ");
            sb.Append("  qc_qcfaildata qqf  ");
            sb.Append("  INNER JOIN  ");
            sb.Append("   machost_apollo.mac_observation_qc moq  ON qqf.MacDataId = moq.id AND QCType = 'QC' AND Qcstatus='Fail' AND qqf.isactive = 1  ");
            sb.Append("   INNER JOIN `centre_master` cm ON cm.`CentreID`=moq.CentreID ");
            sb.Append(" WHERE qqf.Type = 'RCA'  ");
            if (controlid != "")
            {
                sb.Append(" and moq.ControlID in({0}) ");
            }
            if (labid != "")
            {
                sb.Append(" and moq.CentreID in ({1}) ");
            }
            if (MachineId != "")
            {
                string[] Machine = MachineId.Split(',');
                
                for (int i = 0; i < Machine.Length; i++)
                {
                    if (i == 0)
                    {
                        AllMachine += "'" + Machine[i] + "'";
                    }
                    else
                    {
                        AllMachine += ",'" + Machine[i] + "'";
                    }
                }
                sb.Append(" and moq.Machine_Id in ({2}) ");
            }

            Dictionary<string, string> returnData = new Dictionary<string, string>();
            returnData.Add("ReportDisplayName", Common.EncryptRijndael("QCFailRCAReport"));
            returnData.Add("labid#1", Common.EncryptRijndael(labid));
            returnData.Add("controlid#1", Common.EncryptRijndael(controlid));
            returnData.Add("AllMachine#1", Common.EncryptRijndael(AllMachine));  
            returnData.Add("Query", Common.EncryptRijndael(sb.ToString()));            
            returnData.Add("ReportPath", "../Common/ExportToExcelReport.aspx");
            returnData.Add("IsAutoIncrement", Common.EncryptRijndael("1")); 
            return returnData;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }



}
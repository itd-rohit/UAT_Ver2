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

public partial class Design_Quality_QCValueEntry : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlprocessinglab.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 ORDER BY centre");
            ddlprocessinglab.DataValueField = "centreid";
            ddlprocessinglab.DataTextField = "centre";
            ddlprocessinglab.DataBind();
            FromdateCal.EndDate = DateTime.Now;
           
            
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindcontrol(string labid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(controlname,' # ',lotnumber) controlname,controlid FROM qc_control_centre_mapping ");
        sb.Append(" WHERE centreid=" + labid + " GROUP BY controlid ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public static string showreading(string labid, string controlid, string fromdate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT LabObservation_ID,`LabObservation_Name`,GROUP_CONCAT(qcd.levelid ORDER BY qcd.levelid) levelid,controlid FROM ");
        sb.Append(" `qc_controlparameter_detail` qcd WHERE controlid='" + controlid + "' ");
        sb.Append(" GROUP BY qcd.`LabObservation_ID` ");
        sb.Append(" ORDER BY LabObservation_Name ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    

    //[WebMethod(EnableSession = true)]
    //public static string bindparameter(string labid, string controlid)
    //{
    //    StringBuilder sb = new StringBuilder();
    //    sb.Append(" SELECT LabObservation_ID,LabObservation_Name FROM qc_control_centre_mapping ");
    //    sb.Append(" WHERE centreid=" + labid + " AND controlid='" + controlid + "' ");
    //    sb.Append(" GROUP BY LabObservation_ID ");
    //    return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    //}


    [WebMethod(EnableSession = true)]
    public static string SaveData(List<qcdataaddreading> controldata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            foreach (qcdataaddreading qc in controldata)
            {
                StringBuilder sb = new StringBuilder();

                sb.Append(" SELECT qcc.machineid,pm.Machine_ParamID,mpm.`AssayNo`,BarcodeNo FROM qc_control_centre_mapping qcc ");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_param_master pm ON pm.LabObservation_id=@LabObservation_ID ");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machineparam mpm ON mpm.Machine_ParamID=pm.Machine_ParamID AND mpm.`MACHINEID`=qcc.machineid ");
                sb.Append(" WHERE qcc.centreid=@centreid AND qcc.controlid=@controlid AND qcc.`LabObservation_ID`=@LabObservation_ID and qcc.LevelID=@LevelID ");

                DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@LabObservation_ID", qc.LabObservation_ID),
                    new MySqlParameter("@centreid", qc.CentreId),
                    new MySqlParameter("@controlid", qc.ControlID),
                    new MySqlParameter("@LevelID", qc.LevelID)).Tables[0];

                if (dt.Rows.Count > 0)
                {

                    sb = new StringBuilder();
                    sb.Append("SELECT BaseMeanvalue,BaseSDvalue,BaseCVPercentage FROM qc_controlparameter_detail WHERE controlid='" + qc.ControlID + "' AND `LabObservation_ID`='" + qc.LabObservation_ID + "' AND levelid='" + qc.LevelID + "'");
                    DataTable dtbase = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


                    sb = new StringBuilder();
                    sb.Append(" SELECT reading FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` ");
                    sb.Append(" WHERE labno=@labno AND machine_id=@machine_id AND controlid=@controlid AND centreid=@centreid AND levelid=@levelid AND `LabObservation_ID`=@LabObservation_ID ");
                    sb.Append(" ORDER BY id DESC LIMIT 10 ");

                    DataTable dtoldvalue = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@labno", dt.Rows[0]["BarcodeNo"].ToString()),
                           new MySqlParameter("@machine_id", dt.Rows[0]["machineid"].ToString()),
                           new MySqlParameter("@controlid", qc.ControlID),
                           new MySqlParameter("@centreid", qc.CentreId),
                           new MySqlParameter("@levelid", qc.LevelID),
                           new MySqlParameter("@LabObservation_ID", qc.LabObservation_ID)
                           ).Tables[0];


                    string qcresult = QualityWestGardRule.ApplyWestGardRule(qc.Reading, Util.GetString(dtbase.Rows[0]["BaseMeanvalue"]), Util.GetString(dtbase.Rows[0]["BaseSDvalue"]), Util.GetString(dtbase.Rows[0]["BaseCVPercentage"]), dtoldvalue, Util.GetString(qc.CentreId), dt.Rows[0]["machineid"].ToString(), Util.GetString(qc.LabObservation_ID),Util.GetString(qc.LevelID), qc.ControlID, con);
                    string qcstatus = qcresult.Split('#')[0];
                    string machinelock = qcresult.Split('#')[2];
                    string rulename = qcresult.Split('#')[1];





                    sb = new StringBuilder();
                    sb.Append(" INSERT  INTO " + Util.getApp("MachineDB") + ".mac_observation_qc(LabNo,Reading,dtEntry,centreid, ");
                    sb.Append(" controlid,ControlName,LotNumber,LabObservation_ID,LabObservation_Name,LevelID,Level,Machine_Id,Machine_ParamID,AssayNo,QCStatus,QCRule,IsMachineLock) values ");
                    sb.Append(" (@LabNo,@Reading,@dtEntry,@centreid,");
                    sb.Append(" @controlid,@ControlName,@LotNumber,@LabObservation_ID,@LabObservation_Name,@LevelID,@Level,@Machine_Id,@Machine_ParamID,@AssayNo,@QCStatus,@QCRule,@IsMachineLock)");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@LabNo", dt.Rows[0]["BarcodeNo"].ToString()),
                         new MySqlParameter("@Reading", qc.Reading),
                         new MySqlParameter("@dtEntry", Util.GetDateTime(qc.EntryDate).ToString("yyyy-MM-dd") + " " + System.DateTime.Now.ToString("HH:mm:ss")),
                         new MySqlParameter("@centreid", qc.CentreId),
                         new MySqlParameter("@controlid", qc.ControlID),
                         new MySqlParameter("@ControlName", qc.ControlName),
                         new MySqlParameter("@LotNumber", qc.LotNumber),
                         new MySqlParameter("@LabObservation_ID", qc.LabObservation_ID),
                         new MySqlParameter("@LabObservation_Name", qc.LabObservation_Name),
                         new MySqlParameter("@LevelID", qc.LevelID),
                         new MySqlParameter("@Level", qc.Level),
                         new MySqlParameter("@Machine_Id", dt.Rows[0]["machineid"].ToString()),
                         new MySqlParameter("@Machine_ParamID", dt.Rows[0]["Machine_ParamID"].ToString()),
                         new MySqlParameter("@AssayNo", dt.Rows[0]["AssayNo"].ToString()),
                         new MySqlParameter("@QCStatus", qcstatus),
                         new MySqlParameter("@QCRule", rulename),
                         new MySqlParameter("@IsMachineLock", machinelock));
                  
                   

                }
              
            }

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.Message);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    
}


public class qcdataaddreading
{
    public int CentreId { get; set; }
    public string ControlID { get; set; }
    public string ControlName { get; set; }
    public string LotNumber { get; set; }
    public int LabObservation_ID { get; set; }
    public string LabObservation_Name { get; set; }
    public int LevelID { get; set; }
    public string Level { get; set; }
    public string Reading { get; set; }
    public string EntryDate { get; set; }

    
    
}
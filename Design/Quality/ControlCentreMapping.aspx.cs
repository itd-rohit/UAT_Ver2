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

public partial class Design_Quality_ControlCentreMapping : System.Web.UI.Page
{
    public string caneditsin = "1";
    public string caneditlabmin = "1";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typeid),0) FROM qc_approvalright WHERE apprightfor='QC' and typeid in(14,15) AND employeeid='" + UserInfo.ID + "' and active=1 ");
            if (dt != "0")
            {
                if (dt.Contains("14"))
                {
                    caneditsin = "1";
                }
                if (dt.Contains("15"))
                {
                    caneditlabmin = "1";
                }

            }


            ddlprocessinglab.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 ORDER BY centre");
            ddlprocessinglab.DataValueField = "centreid";
            ddlprocessinglab.DataTextField = "centre";
            ddlprocessinglab.DataBind();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindmachine(string labid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT CONCAT(machineid,'#',groupid) MacID,CONCAT(machineid,' # ',mm.name) machinename  FROM " + Util.getApp("MachineDB") + ".`mac_machinemaster` mmc INNER JOIN macmaster mm ON mm.ID=mmc.groupid and mm.isactive=1 WHERE centreid=" + labid + " ORDER BY machineid"));

    }

    [WebMethod(EnableSession = true)]
    public static string bindcontrol(string macid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT controlid,CONCAT(controlname,' # ',lotnumber,' # ',(select group_concat(LabObservation_Name)  FROM `qc_controlparameter_detail` qcd WHERE qcd.ControlID=qc.controlid and qcd.IsActive=1)) controlname   FROM `qc_controlmaster`qc  WHERE isactive=1 AND machineid=" + macid + "  and lotexpiry>=current_date "));
    }
    [WebMethod(EnableSession = true)]
    public static string bindparameter(string controlid, string machineid, string centreid)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT IFNULL(ccm.id,'') savedid, DATE_FORMAT(qcm.startdate,'%d-%b-%Y')startdate,DATE_FORMAT(qcm.LotExpiry,'%d-%b-%Y')LotExpiry, ");
        sb.Append("  qcm.controlid,qcm.controlname,qcm.`ControlProvider`,qcm.lotnumber,IFNULL(ccm.assayno,mpm.assayno)assayno, ");
        sb.Append("  qcd.`LabObservation_ID`,qcd.`LabObservation_Name`,qcd.levelid levelid, ");
        sb.Append("  IFNULL(ccm.`Minvalue`,qcd.`Minvalue`)Minvalue,IFNULL(ccm.`Maxvalue`,qcd.`Maxvalue`)`Maxvalue`, ");
        sb.Append("  IFNULL(ccm.`BaseMeanvalue`,qcd.`BaseMeanvalue`)BaseMeanvalue,");
        sb.Append("  IFNULL(ccm.`BaseSDvalue`,qcd.`BaseSDvalue`)BaseSDvalue,IFNULL(ccm.`BaseCVPercentage`,qcd.`BaseCVPercentage`)BaseCVPercentage, ");
        sb.Append("  IFNULL(ccm.barcodeno,'')  barcodeno,  ");
        sb.Append("  IFNULL(ccm.LockMachine,0) LockMachine ");
        sb.Append("  , qcd.minvalue refminvalue,qcd.maxvalue refmaxvalue ");
        sb.Append("  ,(SELECT lockmachine FROM qc_control_centre_mapping WHERE centreid=" + centreid + " AND `LabObservation_ID`=qcd.`LabObservation_ID` ORDER BY id DESC LIMIT 1) oldlock");
        sb.Append("  FROM `qc_controlmaster` qcm  ");
        sb.Append("  INNER JOIN `qc_controlparameter_detail` qcd ON qcm.`ControlID`=qcd.`ControlID` AND qcd.isactive=1  and qcm.lotexpiry>=current_date ");
        sb.Append("  and qcm.LotExpiry>=current_date");
        sb.Append("  INNER JOIN " + Util.getApp("MachineDB") + ".mac_param_master pm ON pm.LabObservation_id=qcd.`LabObservation_ID`   ");
        sb.Append("  INNER JOIN " + Util.getApp("MachineDB") + ".mac_machineparam mpm ON mpm.Machine_ParamID=pm.Machine_ParamID AND  mpm.MACHINEID='" + machineid + "' ");
        sb.Append("  LEFT JOIN qc_control_centre_mapping ccm ON ccm.centreid=" + centreid + " AND qcm.ControlID=ccm.ControlID AND ccm.isactive=1 and   ");
        sb.Append("  qcd.`LabObservation_ID`=ccm.LabObservation_ID AND qcd.LevelID=ccm.LevelID AND ccm.machineid=mpm.MACHINEID and  ccm.assayno=mpm.assayno  ");
        sb.Append("  WHERE qcm.isactive=1 AND qcm.controlid='" + controlid + "' ");
        sb.Append("  ORDER BY LabObservation_Name,levelid ");


        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
       
    [WebMethod(EnableSession = true)]
    public static string checkduplicateassayno(string LabObservation_ID, string assayno)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("select count(1) from qc_control_centre_mapping where AssayNo='" + assayno + "' and LabObservation_ID<>" + LabObservation_ID + ""));

        return count.ToString();
    }
     [WebMethod(EnableSession = true)]
    public static string checkduplicatesinno(string barcodeno, string savedid, string level, string lotnumber)
    {
        if (savedid == "")
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("select count(1) from qc_control_centre_mapping where BarcodeNo='" + barcodeno + "' and controlid!='" + lotnumber + "' and levelid="+level+"  "));

            return count.ToString();
        }
        else
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("select count(1) from qc_control_centre_mapping where BarcodeNo='" + barcodeno + "' and id not in(" + savedid + ")  "));

            return count.ToString();
        }
    }

     [WebMethod(EnableSession = true)]
     public static string SaveData(List<ControlCentreMapping> controldata)
     {
         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         try
         {

             foreach (ControlCentreMapping ccm in controldata)
             {
                 if (Util.GetString(ccm.BarcodeNo) != "" && Util.GetString(ccm.savedid) == "")
                 {
                     MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into qc_control_centre_mapping(CentreId,ControlID,ControlName,LotNumber,MachineID,MachineGroupId,LabObservation_ID,LabObservation_Name,AssayNo,LevelID,Level,BarcodeNo,EntryDate,EntryByID,EntryByName,LockMachine,Minvalue,`Maxvalue`,BaseMeanValue,BaseSDValue,BaseCVPercentage) values (@CentreId,@ControlID,@ControlName,@LotNumber,@MachineID,@MachineGroupId,@LabObservation_ID,@LabObservation_Name,@AssayNo,@LevelID,@Level,@BarcodeNo,@EntryDate,@EntryByID,@EntryByName,@LockMachine,@Minvalue,@Maxvalue,@BaseMeanValue,@BaseSDValue,@BaseCVPercent)",
                        new MySqlParameter("@CentreId", ccm.CentreId),
                        new MySqlParameter("@ControlID", ccm.ControlID),
                        new MySqlParameter("@ControlName", ccm.ControlName.ToUpper()),
                        new MySqlParameter("@LotNumber", ccm.LotNumber.ToUpper()),
                        new MySqlParameter("@MachineID", ccm.MachineID),
                        new MySqlParameter("@MachineGroupId", ccm.MachineGroupId),
                        new MySqlParameter("@LabObservation_ID", ccm.LabObservation_ID),
                        new MySqlParameter("@LabObservation_Name", ccm.LabObservation_Name.ToUpper()),
                        new MySqlParameter("@AssayNo", ccm.AssayNo),
                        new MySqlParameter("@LevelID", ccm.LevelID),
                        new MySqlParameter("@Level", ccm.Level),
                        new MySqlParameter("@BarcodeNo", ccm.BarcodeNo.ToUpper()),
                        new MySqlParameter("@EntryDate", DateTime.Now),
                        new MySqlParameter("@EntryById", UserInfo.ID),
                        new MySqlParameter("@EntryByName", UserInfo.LoginName),
                        new MySqlParameter("@LockMachine", ccm.LockMachine),
                        new MySqlParameter("@MinValue", ccm.MinValue),
                        new MySqlParameter("@MaxValue", ccm.MaxValue),
                        new MySqlParameter("@BaseMeanValue", ccm.BaseMeanValue),
                        new MySqlParameter("@BaseCVPercent", ccm.BaseCVPercent),
                        new MySqlParameter("@BaseSDValue", ccm.BaseSDValue)
                        );
                 }
                 else if (Util.GetString(ccm.savedid) != "")
                 {



                     MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_control_centre_mapping set LockMachine=@LockMachine, BarcodeNo=@BarcodeNo,AssayNo=@AssayNo,updatedate=@updatedate,UpdateByID=@UpdateByID,UpdateByName=@UpdateByName,Minvalue=@Minvalue,`Maxvalue`=@Maxvalue,BaseMeanValue=@BaseMeanValue,BaseSDValue=@BaseSDValue,BaseCVPercentage=@BaseCVPercent where CentreId=@CentreId and ControlID=@ControlID and LabObservation_ID=@LabObservation_ID and MachineID=@MachineID and id=@id",
                        new MySqlParameter("@BarcodeNo", ccm.BarcodeNo.ToUpper()),
                        new MySqlParameter("@CentreId", ccm.CentreId),
                        new MySqlParameter("@ControlID", ccm.ControlID),
                        new MySqlParameter("@MachineID", ccm.MachineID),
                        new MySqlParameter("@LabObservation_ID", ccm.LabObservation_ID),
                        new MySqlParameter("@AssayNo", ccm.AssayNo),
                        new MySqlParameter("@id", ccm.savedid),
                        new MySqlParameter("@updatedate", DateTime.Now),
                        new MySqlParameter("@UpdateByID", UserInfo.ID),
                        new MySqlParameter("@UpdateByName", UserInfo.LoginName),
                        new MySqlParameter("@LockMachine", ccm.LockMachine),
                        new MySqlParameter("@MinValue", ccm.MinValue),
                        new MySqlParameter("@MaxValue", ccm.MaxValue),
                        new MySqlParameter("@BaseMeanValue", ccm.BaseMeanValue),
                        new MySqlParameter("@BaseCVPercent", ccm.BaseCVPercent),
                        new MySqlParameter("@BaseSDValue", ccm.BaseSDValue));
                     
                    
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
     public static string RemoveData(string savedid)
     {
         StockReports.ExecuteDML("update qc_control_centre_mapping set isactive=0,updatedate=now(),UpdateByID=" + UserInfo.ID + ",UpdateByName='" + UserInfo.LoginName + "' where id=" + savedid + "");
         return "1";
     }
    
}

public class ControlCentreMapping
{
    public int CentreId { get; set; }
    public string ControlID { get; set; }
    public string ControlName { get; set; }
    public string LotNumber { get; set; }
    public string MachineID { get; set; }
    public string MachineGroupId { get; set; }
    public string LabObservation_ID { get; set; }
    public string LabObservation_Name { get; set; }
    public string AssayNo { get; set; }
    public int LockMachine { get; set; }
    public string LevelID { get; set; }
    public string Level { get; set; }
    public string BarcodeNo { get; set; }
    public string MinValue { get; set; }
    public string MaxValue { get; set; }
    public string BaseMeanValue { get; set; }
    public string BaseSDValue { get; set; }
    public string BaseCVPercent { get; set; }
    public string savedid { get; set; }
    
    
}
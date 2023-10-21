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

public partial class Design_Quality_QCScheduling : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string bindtypedb()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT DISTINCT type1id ID,type1 TEXT FROM centre_master ORDER BY type1id "));
    }

    [WebMethod]
    public static string bindcentre(string TypeId, string StateID, string ZoneId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ");
        sb.Append(" and cm.isActive=1");
        if (ZoneId != "")
            sb.Append(" AND cm.BusinessZoneID IN(" + ZoneId + ")");

        if (StateID != "")
            sb.Append(" AND cm.StateID IN(" + StateID + ")");

        if (TypeId != "")
            sb.Append(" AND cm.Type1Id IN(" + TypeId + ")");
          

        sb.Append(" ORDER BY centre ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
        
        
    }

    [WebMethod]
    public static string bindmachine(string centreid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT machineid MacID,CONCAT(machineid,' # ',mm.name) machinename  FROM " + Util.getApp("MachineDB") + ".`mac_machinemaster` mmc INNER JOIN macmaster mm ON mm.ID=mmc.groupid and mm.isactive=1 WHERE centreid in(" + centreid + ") ORDER BY machineid"));

    }

    [WebMethod]
    public static string bindparameter(string machineid)
    {
        string machinelist = "";
        foreach (string s in machineid.Split(','))
        {
            machinelist += "'" + s + "',";
        }
        machinelist = machinelist.TrimEnd(',');
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lom.`LabObservation_ID`, TRIM(lom.`Name`) PatameterName  FROM `labobservation_master` lom    ");
        sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_param_master pm ON pm.LabObservation_id=lom.LabObservation_ID  ");
        sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machineparam mpm ON mpm.Machine_ParamID=pm.Machine_ParamID and mpm.MACHINEID in (" + machinelist + ")   ");
        sb.Append("  GROUP BY lom.`LabObservation_ID`  ORDER BY lom.Name ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public static string binddata(string centreid,string machineid,string parameter)
    {
        string machinelist = "";
        foreach (string s in machineid.Split(','))
        {
            machinelist += "'" + s + "',";
        }
        machinelist = machinelist.TrimEnd(',');

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lom.`LabObservation_ID`, TRIM(lom.`Name`) LabObservation_Name    ");
        sb.Append(" ,ifnull(qs1.LockMachine,0) LockMachine,  ifnull(qs1.Time,'') Level1Time,ifnull(qs2.Time,'') Level2Time,ifnull(qs3.Time,'') Level3Time,");

        sb.Append(" ifnull(qs1.Sun,0) Level1Sun,ifnull(qs1.Mon,0) Level1Mon,ifnull(qs1.Tue,0) Level1Tue,ifnull(qs1.Wed,0) Level1Wed, ");
        sb.Append(" ifnull(qs1.Thu,0) Level1Thu,ifnull(qs1.Fri,0) Level1Fri,ifnull(qs1.Sat,0) Level1Sat,");

        sb.Append(" if(ifnull(qs1.Sun,0)=1,'GridViewDragItemStyle','') Level1SunClass,if(ifnull(qs1.Mon,0)=1,'GridViewDragItemStyle','')  Level1MonClass,if(ifnull(qs1.Tue,0)=1,'GridViewDragItemStyle','') Level1TueClass,if(ifnull(qs1.Wed,0)=1,'GridViewDragItemStyle','') Level1WedClass, ");
        sb.Append(" if(ifnull(qs1.Thu,0)=1,'GridViewDragItemStyle','') Level1ThuClass,if(ifnull(qs1.Fri,0)=1,'GridViewDragItemStyle','')  Level1FriClass,if(ifnull(qs1.Sat,0)=1,'GridViewDragItemStyle','') Level1SatClass,");

        sb.Append(" ifnull(qs2.Sun,0) Level2Sun,ifnull(qs2.Mon,0) Level2Mon,ifnull(qs2.Tue,0) Level2Tue,ifnull(qs2.Wed,0) Level2Wed, ");
        sb.Append(" ifnull(qs2.Thu,0) Level2Thu,ifnull(qs2.Fri,0) Level2Fri,ifnull(qs2.Sat,0) Level2Sat,");

        sb.Append(" if(ifnull(qs2.Sun,0)=1,'GridViewDragItemStyle','') Level2SunClass,if(ifnull(qs2.Mon,0)=1,'GridViewDragItemStyle','')  Level2MonClass,if(ifnull(qs2.Tue,0)=1,'GridViewDragItemStyle','') Level2TueClass,if(ifnull(qs2.Wed,0)=1,'GridViewDragItemStyle','') Level2WedClass, ");
        sb.Append(" if(ifnull(qs2.Thu,0)=1,'GridViewDragItemStyle','') Level2ThuClass,if(ifnull(qs2.Fri,0)=1,'GridViewDragItemStyle','')  Level2FriClass,if(ifnull(qs2.Sat,0)=1,'GridViewDragItemStyle','') Level2SatClass,");

        sb.Append(" ifnull(qs3.Sun,0) Level3Sun,ifnull(qs3.Mon,0) Level3Mon,ifnull(qs3.Tue,0) Level3Tue,ifnull(qs3.Wed,0) Level3Wed, ");
        sb.Append(" ifnull(qs3.Thu,0) Level3Thu,ifnull(qs3.Fri,0) Level3Fri,ifnull(qs3.Sat,0) Level3Sat,");

        sb.Append(" if(ifnull(qs3.Sun,0)=1,'GridViewDragItemStyle','') Level3SunClass,if(ifnull(qs3.Mon,0)=1,'GridViewDragItemStyle','')  Level3MonClass,if(ifnull(qs3.Tue,0)=1,'GridViewDragItemStyle','') Level3TueClass,if(ifnull(qs3.Wed,0)=1,'GridViewDragItemStyle','') Level3WedClass, ");
        sb.Append(" if(ifnull(qs3.Thu,0)=1,'GridViewDragItemStyle','') Level3ThuClass,if(ifnull(qs3.Fri,0)=1,'GridViewDragItemStyle','')  Level3FriClass,if(ifnull(qs3.Sat,0)=1,'GridViewDragItemStyle','') Level3Satclass,");

        sb.Append(" ifnull(qs1.id,0) savedid FROM `labobservation_master` lom ");
        sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_param_master pm ON pm.LabObservation_id=lom.LabObservation_ID  and lom.LabObservation_ID in (" + parameter + ")");
        sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machineparam mpm ON mpm.Machine_ParamID=pm.Machine_ParamID and mpm.MACHINEID in (" + machinelist + ")   ");
        sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machinemaster mm ON mm.MACHINEID=mpm.MACHINEID AND mm.CentreID in (" + centreid + ")");
        sb.Append(" left join qc_scheduling qs1 on qs1.LabObservation_id=lom.LabObservation_id and qs1.CentreId=mm.CentreID and qs1.MachineID=mm.MACHINEID and qs1.LevelID=1");
        sb.Append(" left join qc_scheduling qs2 on qs2.LabObservation_id=lom.LabObservation_id and qs2.CentreId=mm.CentreID and qs2.MachineID=mm.MACHINEID and qs2.LevelID=2");
        sb.Append(" left join qc_scheduling qs3 on qs3.LabObservation_id=lom.LabObservation_id and qs3.CentreId=mm.CentreID and qs3.MachineID=mm.MACHINEID and qs3.LevelID=3");
        sb.Append(" GROUP BY lom.`LabObservation_ID`  ORDER BY lom.Name ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public static string SaveData(List<QCSchedule> objsavedata)
    {

        string centreid = string.Join(",", objsavedata[0].centreid);
        string machineid = "'" + string.Join("','", objsavedata[0].machineid) + "'";
    
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {
            foreach (QCSchedule qs in objsavedata)
            {
                sb = new StringBuilder();

                sb.Append(" update qc_scheduling qs  ");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_param_master pm ON pm.LabObservation_ID=qs.LabObservation_ID and qs.LabObservation_ID=" + qs.LabObservation_ID + "");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machineparam mpm ON mpm.Machine_ParamID=pm.Machine_ParamID and mpm.MACHINEID in (" + machineid + ")   ");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machinemaster mm ON mm.MACHINEID=mpm.MACHINEID AND mm.CentreID in (" + centreid + ")");
                sb.Append(" set DeleteDate=now(),DeleteByID=" + UserInfo.ID + ",DeleteByName='"+UserInfo.LoginName+"' ");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());



                sb = new StringBuilder();

                sb.Append(" delete qs.* from qc_scheduling qs  ");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_param_master pm ON  pm.LabObservation_ID=qs.LabObservation_ID and qs.LabObservation_id=" + qs.LabObservation_ID + "");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machineparam mpm ON mpm.Machine_ParamID=pm.Machine_ParamID and mpm.MACHINEID in (" + machineid + ")   ");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machinemaster mm ON mm.MACHINEID=mpm.MACHINEID AND mm.CentreID in (" + centreid + ")");
              
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());


               

                sb = new StringBuilder();
                sb.Append(" insert into qc_scheduling (CentreId,MachineID,MachineGroupId,LabObservation_ID,LevelID,");
                sb.Append(" Time,Sun,Mon,Tue,Wed,Thu,Fri,Sat,");
                sb.Append(" EntryDate,EntryByID,EntryByName,LockMachine)");
                sb.Append(" SELECT mm.CentreID,mpm.MACHINEID,mm.groupid,lom.`LabObservation_ID` ,1,    ");
                sb.Append(" '" + Util.GetDateTime(qs.Level1_Time).ToString("HH:mm:ss") + "'," + qs.Level1_Sun + "," + qs.Level1_Mon + "," + qs.Level1_Tue + "," + qs.Level1_Wed + "," + qs.Level1_Thu + "," + qs.Level1_Fri + "," + qs.Level1_Sat + ",");
                sb.Append(" now()," + UserInfo.ID + ",'" + UserInfo.LoginName + "',"+qs.LockMachine+" ");
                sb.Append("  FROM `labobservation_master` lom");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_param_master pm  ON pm.LabObservation_id=lom.LabObservation_ID and pm.LabObservation_id=" + qs.LabObservation_ID + "");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machineparam mpm ON mpm.Machine_ParamID=pm.Machine_ParamID and mpm.MACHINEID in (" + machineid + ")   ");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machinemaster mm ON mm.MACHINEID=mpm.MACHINEID AND mm.CentreID in (" + centreid + ")");

                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

                sb = new StringBuilder();
                sb.Append(" insert into qc_scheduling (CentreId,MachineID,MachineGroupId,LabObservation_ID,LevelID,");
                sb.Append(" Time,Sun,Mon,Tue,Wed,Thu,Fri,Sat,");
                sb.Append(" EntryDate,EntryByID,EntryByName,LockMachine)");
                sb.Append(" SELECT mm.CentreID,mpm.MACHINEID,mm.groupid,lom.`LabObservation_ID` ,2,    ");
                sb.Append(" '" + Util.GetDateTime(qs.Level2_Time).ToString("HH:mm:ss") + "'," + qs.Level2_Sun + "," + qs.Level2_Mon + "," + qs.Level2_Tue + "," + qs.Level2_Wed + "," + qs.Level2_Thu + "," + qs.Level2_Fri + "," + qs.Level2_Sat + ",");
                sb.Append(" now()," + UserInfo.ID + ",'" + UserInfo.LoginName + "'," + qs.LockMachine + " ");
                sb.Append("  FROM `labobservation_master` lom");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_param_master pm  ON pm.LabObservation_id=lom.LabObservation_ID and pm.LabObservation_id=" + qs.LabObservation_ID + "");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machineparam mpm ON mpm.Machine_ParamID=pm.Machine_ParamID and mpm.MACHINEID in (" + machineid + ")   ");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machinemaster mm ON mm.MACHINEID=mpm.MACHINEID AND mm.CentreID in (" + centreid + ")");

                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
                sb = new StringBuilder();
                sb.Append(" insert into qc_scheduling (CentreId,MachineID,MachineGroupId,LabObservation_ID,LevelID,");
                sb.Append(" Time,Sun,Mon,Tue,Wed,Thu,Fri,Sat,");
                sb.Append(" EntryDate,EntryByID,EntryByName,LockMachine)");
                sb.Append(" SELECT mm.CentreID,mpm.MACHINEID,mm.groupid,lom.`LabObservation_ID` ,3,    ");
                sb.Append(" '" + Util.GetDateTime(qs.Level3_Time).ToString("HH:mm:ss") + "'," + qs.Level3_Sun + "," + qs.Level3_Mon + "," + qs.Level3_Tue + "," + qs.Level3_Wed + "," + qs.Level3_Thu + "," + qs.Level3_Fri + "," + qs.Level3_Sat + ",");
                sb.Append(" now()," + UserInfo.ID + ",'" + UserInfo.LoginName + "'," + qs.LockMachine + " ");
                sb.Append("  FROM `labobservation_master` lom");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_param_master pm  ON pm.LabObservation_id=lom.LabObservation_ID and pm.LabObservation_id=" + qs.LabObservation_ID + "");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machineparam mpm ON mpm.Machine_ParamID=pm.Machine_ParamID and mpm.MACHINEID in (" + machineid + ")   ");
                sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machinemaster mm ON mm.MACHINEID=mpm.MACHINEID AND mm.CentreID in (" + centreid + ")");


               
                



                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
            }
            Tnx.Commit();
            return "1";
        }


        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tnx.Rollback();
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string binddataexcel(string centreid, string machineid, string parameter)
    {
        string machinelist = "";
        foreach (string s in machineid.Split(','))
        {
            machinelist += "'" + s + "',";
        }
        machinelist = machinelist.TrimEnd(',');

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.centreid,cm.centre,mm.MACHINEID, lom.`LabObservation_ID`, TRIM(lom.`Name`) LabObservation_Name ,if(ifnull(qs1.LockMachine,0)=0,'No','Yes') LockMachine,    ");

        sb.Append(" ifnull(qs1.Time,'') Level1Time,");
        sb.Append(" ifnull(qs1.Sun,0) Level1Sun,ifnull(qs1.Mon,0) Level1Mon,ifnull(qs1.Tue,0) Level1Tue,ifnull(qs1.Wed,0) Level1Wed, ");
        sb.Append(" ifnull(qs1.Thu,0) Level1Thu,ifnull(qs1.Fri,0) Level1Fri,ifnull(qs1.Sat,0) Level1Sat,");

        sb.Append(" ifnull(qs2.Time,'') Level2Time, ");
        sb.Append(" ifnull(qs2.Sun,0) Level2Sun,ifnull(qs2.Mon,0) Level2Mon,ifnull(qs2.Tue,0) Level2Tue,ifnull(qs2.Wed,0) Level2Wed, ");
        sb.Append(" ifnull(qs2.Thu,0) Level2Thu,ifnull(qs2.Fri,0) Level2Fri,ifnull(qs2.Sat,0) Level2Sat,");

        sb.Append(" ifnull(qs3.Time,'') Level3Time, ");
        sb.Append(" ifnull(qs3.Sun,0) Level3Sun,ifnull(qs3.Mon,0) Level3Mon,ifnull(qs3.Tue,0) Level3Tue,ifnull(qs3.Wed,0) Level3Wed, ");
        sb.Append(" ifnull(qs3.Thu,0) Level3Thu,ifnull(qs3.Fri,0) Level3Fri,ifnull(qs3.Sat,0) Level3Sat,");

      

        sb.Append(" ifnull(qs1.EntryByName,0) EntryByName,date_format(qs1.EntryDate,'%d-%b-%Y') EntryDate FROM `labobservation_master` lom ");
        sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_param_master pm ON pm.LabObservation_id=lom.LabObservation_ID  and lom.LabObservation_ID in (" + parameter + ")");
        sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machineparam mpm ON mpm.Machine_ParamID=pm.Machine_ParamID and mpm.MACHINEID in (" + machinelist + ")   ");
        sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machinemaster mm ON mm.MACHINEID=mpm.MACHINEID AND mm.CentreID in (" + centreid + ")");
        sb.Append(" inner join centre_master cm on cm.centreid=mm.CentreID");
        sb.Append(" left join qc_scheduling qs1 on qs1.LabObservation_id=lom.LabObservation_id and qs1.CentreId=mm.CentreID and qs1.MachineID=mm.MACHINEID and qs1.levelid=1 ");
        sb.Append(" left join qc_scheduling qs2 on qs2.LabObservation_id=lom.LabObservation_id and qs2.CentreId=mm.CentreID and qs2.MachineID=mm.MACHINEID and qs2.levelid=2 ");
        sb.Append(" left join qc_scheduling qs3 on qs3.LabObservation_id=lom.LabObservation_id and qs3.CentreId=mm.CentreID and qs3.MachineID=mm.MACHINEID and qs3.levelid=3");
        sb.Append(" ORDER BY cm.centre,mm.MACHINEID,lom.`Name`");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {

            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "QCScheduling";
            return "1";
        }
        else
        {
            return "No Record Found";
        }
    }

    
}

public class QCSchedule
{
    public List<string> centreid { get; set; }
    public List<string> machineid { get; set; }
    public string LabObservation_ID { get; set; }
    public string LockMachine { get; set; }
    public string Level1_Time { get; set; }
    public string Level1_Sun { get; set; }
    public string Level1_Mon { get; set; }
    public string Level1_Tue { get; set; }
    public string Level1_Wed { get; set; }
    public string Level1_Thu { get; set; }
    public string Level1_Fri { get; set; }
    public string Level1_Sat { get; set; }

    public string Level2_Time { get; set; }
    public string Level2_Sun { get; set; }
    public string Level2_Mon { get; set; }
    public string Level2_Tue { get; set; }
    public string Level2_Wed { get; set; }
    public string Level2_Thu { get; set; }
    public string Level2_Fri { get; set; }
    public string Level2_Sat { get; set; }

    public string Level3_Time { get; set; }
    public string Level3_Sun { get; set; }
    public string Level3_Mon { get; set; }
    public string Level3_Tue { get; set; }
    public string Level3_Wed { get; set; }
    public string Level3_Thu { get; set; }
    public string Level3_Fri { get; set; }
    public string Level3_Sat { get; set; }

}
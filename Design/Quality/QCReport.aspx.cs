using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_QCReport : System.Web.UI.Page
{
    public string canverify = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlprocessinglab.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and  cm.CentreID in (SELECT centreid FROM f_login WHERE employeeid=" + UserInfo.ID + " GROUP BY centreid) and cm.isActive=1 ORDER BY centre");
            //ddlprocessinglab.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 ORDER BY centre");
            ddlprocessinglab.DataValueField = "centreid";
            ddlprocessinglab.DataTextField = "centre";
            ddlprocessinglab.DataBind();
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            CalendarExtender1.EndDate = DateTime.Now;
            canverify=StockReports.ExecuteScalar("SELECT COUNT(1) FROM `qc_approvalright` WHERE employeeid=" + UserInfo.ID + " AND active='1' AND apprightfor='QC' AND typeid='16' ");
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindcontrol(string labid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(qccd.controlname,' # ',qccd.lotnumber) controlname,qccd.controlid FROM qc_control_centre_mapping qccd inner join qc_controlmaster qcm on qccd.controlid=qcm.controlid ");
        sb.Append(" WHERE qccd.centreid in(" + labid + ") GROUP BY qccd.controlid order by  qccd.controlname ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public static string bindMachine(string labid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT machineid MacID,CONCAT(machineid,' # ',mm.name) machinename  FROM " + Util.getApp("MachineDB") + ".`mac_machinemaster` mmc INNER JOIN macmaster mm ON mm.ID=mmc.groupid and mm.isactive=1 WHERE centreid in(" + labid + ")  ORDER BY machineid"));
       
    }

    [WebMethod(EnableSession = true)]
    public static string bindparameter(string labid,string controlid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT LabObservation_ID,LabObservation_Name FROM qc_control_centre_mapping ");
        sb.Append(" WHERE centreid=" + labid + " AND controlid='" + controlid + "' ");
        sb.Append(" GROUP BY LabObservation_ID  order by  LabObservation_Name ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public static string bindlevel(string labid,string controlid,string LabObservation_ID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT levelid,concat(LEVEL,'#',BarcodeNo)LEVEL FROM qc_control_centre_mapping ");
        sb.Append(" WHERE centreid="+labid+" AND controlid='"+controlid+"' and  LabObservation_ID="+LabObservation_ID+"");
        sb.Append(" GROUP BY LabObservation_ID,levelid ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public static string showreading(string labid, string controlid, string parameterid, string levelid, string fromdate, string todate, string colorcode, string MachineId)
    {
        StringBuilder sb = new StringBuilder(); 
        sb.Append(" SELECT moq.IsVerify,if(moq.IsVerify=1,CONCAT('Verified At :- ',DATE_FORMAT(moq.VerifyDate,'%d-%b-%Y %h:%i %p'),'\n Verified By :-',VerifyByName),'')VerifyDetail, ifnull(moq.RCAType,'')RCAType,ifnull(moq.CAType,'')CAType,ifnull(moq.PAType,'')PAType,   ");
        sb.Append(" moq.labno sinno, moq.Machine_Id, moq.ShowInQC, moq.id,moq.qcstatus,if(qcstatus='Pass','Pass',  ");
        sb.Append(" concat(moq.qcstatus,'(',moq.qcrule,')'))qcstatus1, DATE_FORMAT(moq.dtEntry,'%d-%b-%Y %h:%i %p')EntryDateTime,   ");
        sb.Append(" moq.centreid, cm.Centre,moq.controlid,moq.ControlName, ");
        sb.Append(" moq.LotNumber,moq.LabObservation_ID,");
        sb.Append(" moq.LabObservation_Name,moq.LevelID,moq.Level,moq.Reading,");
        sb.Append(" ifnull(qcc.Minvalue,qcd.Minvalue)Minvalue,ifnull(qcc.Maxvalue,qcd.Maxvalue)`Maxvalue`,ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)BaseMeanvalue,");
        sb.Append(" ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)BaseSDvalue,ifnull(qcc.BaseCVPercentage,qcd.BaseCVPercentage)BaseCVPercentage,");
        sb.Append(" qcd.Unit,qcd.Temperature,qcd.Method, ");
        sb.Append(" ifnull(moq.oldreading,'') oldreading,ifnull(moq.UpdateReason,'')UpdateReason,ifnull(moq.UpdateBy,'')UpdateBy, ");
        sb.Append(" ifnull(DATE_FORMAT(moq.Updatedate,'%d-%b-%Y %h:%i %p'),'')updatedate, ");
        sb.Append(" if(ifnull(moq.RCAType,'') ='','',if(moq.RCAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='RCA' and QCType='QC' and qqf.MacDataId=moq.id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=moq.id  and qqs.Type='RCA' and qqs.QCType='QC')))RCA,  ");
        sb.Append(" if(ifnull(moq.CAType,'') ='','',if(moq.CAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='CorrectiveAction' and QCType='QC' and qqf.MacDataId=moq.id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=moq.id  and qqs.Type='CorrectiveAction' and qqs.QCType='QC')))CorrectiveAction,  ");
        sb.Append(" if(ifnull(moq.PAType,'') ='','',if(moq.PAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='PreventiveAction' and QCType='QC' and qqf.MacDataId=moq.id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=moq.id  and qqs.Type='PreventiveAction' and qqs.QCType='QC')))PreventiveAction,  ");



        sb.Append(" (ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)+(ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)*ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)*0.01)) SDPos, ");
        sb.Append(" (ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)-(ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)*ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)*0.01)) SDNeg ");
       
        sb.Append(" FROM " + Util.getApp("MachineDB") + ".mac_observation_qc moq  ");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=moq.centreid ");
        sb.Append(" and cm.centreid in("+labid+") ");
        if (MachineId != "0")
        {
            sb.Append(" and  moq.Machine_Id ='" + MachineId + "' ");
        }
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");

        sb.Append(" inner join qc_controlmaster qcm on qcm.`ControlID`=qcd.`ControlID`  and qcm.LotExpiry>=current_date");
        //sb.Append(" and qcm.isactive=1  and qcm.LotExpiry>=current_date ");

        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        //sb.Append(" left join qc_qcfaildata qqf on qqf.MacDataId=moq.id and qqf.isactive=1");
        sb.Append( " WHERE moq.isActive=1 and moq.dtEntry>='"+Util.GetDateTime(fromdate).ToString("yyyy-MM-dd")+" 00:00:00' ");
        sb.Append(" and moq.dtEntry<='"+Util.GetDateTime(todate).ToString("yyyy-MM-dd")+" 23:59:59'");
        if (controlid != "")
        {
            sb.Append(" and moq.ControlID='" + controlid + "' ");
        }
        if (parameterid != "")
        {
            sb.Append(" and moq.LabObservation_ID='" + parameterid + "' ");
        }
        if (levelid != "")
        {
            sb.Append(" and moq.LevelID='" + levelid + "' ");
        }

        switch (colorcode)
        {
            case "1": sb.Append(" and moq.qcstatus='Pass' ");
                break;
            case "2": sb.Append(" and moq.qcstatus='Warn' ");
                break;
            case "3": sb.Append(" and moq.qcstatus='Fail' ");
                break;
            case "4": sb.Append(" and moq.ShowInQC='0' ");
                break;
            case "5": sb.Append(" and moq.qcstatus='Not Run' ");
                break;
        }
        sb.Append(" group by moq.controlid,moq.labobservation_id,moq.dtentry,moq.levelid");
        sb.Append(" order by cm.centre,moq.ControlName,moq.LabObservation_Name,moq.dtEntry,moq.levelid ");



        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod(EnableSession = true)]
    public static string showreadingexcel(string labid, string controlid, string parameterid, string levelid, string fromdate, string todate,string type)
    {
        StringBuilder sb = new StringBuilder();


        sb.Append(" SELECT moq.id ID, DATE_FORMAT(moq.dtEntry,'%d-%b-%Y %h:%i %p')EntryDateTime, moq.centreid, cm.Centre, moq.machine_id machineName,moq.ControlName, ");
        sb.Append(" moq.labno SinNo, moq.LotNumber,moq.LabObservation_ID ParameterID,");
        sb.Append(" if(qcstatus='Pass','Pass',  ");
        sb.Append(" concat(moq.qcstatus,'(',moq.qcrule,')'))QCStatus, ");
        sb.Append(" moq.LabObservation_Name Parametername,moq.Level,moq.Reading,");

        sb.Append(" ifnull(qcc.Minvalue,qcd.Minvalue)Minvalue,ifnull(qcc.Maxvalue,qcd.Maxvalue)`Maxvalue`,ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)BaseMeanvalue,");
        sb.Append(" ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)BaseSDvalue,ifnull(qcc.BaseCVPercentage,qcd.BaseCVPercentage)BaseCVPercentage,");

        sb.Append(" qcd.Unit,qcd.Temperature,qcd.Method ,");

        sb.Append(" (ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)+(ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)*3)) SD3_Pos,");
        sb.Append(" (ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)+(ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)*2)) SD2_Pos,");
        sb.Append(" (ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)+(ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)*1)) SD1_Pos,");

        sb.Append(" (ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)-(ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)*3)) SD3_Neg,");
        sb.Append(" (ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)-(ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)*2)) SD2_Neg,");
        sb.Append(" (ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)-(ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)*1)) SD1_Neg,");

       


        sb.Append(" ifnull(moq.oldreading,'') oldreading,ifnull(moq.UpdateReason,'')UpdateReason,ifnull(moq.UpdateBy,'')UpdateBy, ");
        sb.Append(" ifnull(DATE_FORMAT(moq.Updatedate,'%d-%b-%Y %h:%i %p'),'')updatedate, ");
        sb.Append(" if(ShowInQC=1,'Yes','No') ShowInQCReport,");

        sb.Append(" if(moq.RCAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='RCA' and QCType='QC' and qqf.MacDataId=moq.id and qqf.isactive=1),");
        sb.Append(" '')RCA,  ");


        sb.Append(" if(moq.CAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='CorrectiveAction' and QCType='QC' and qqf.MacDataId=moq.id and qqf.isactive=1),");
        sb.Append(" '')CorrectiveAction,  ");


        sb.Append(" if(moq.PAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='PreventiveAction' and QCType='QC' and qqf.MacDataId=moq.id and qqf.isactive=1),");
        sb.Append(" '')PreventiveAction ");


        sb.Append(" ,if(ifnull(moq.AddReadingByName,'')<>'','ManualAddedReading','MachineInterface')ReadingType");
        sb.Append(" ,if(ifnull(moq.AddReadingByName,'')<>'',DATE_FORMAT(moq.AddReadingDate,'%d-%b-%Y %h:%i %p'),'')AddReadingDate");
        sb.Append(" ,ifnull(moq.AddReadingByName,'')AddReadingBy");


      
        sb.Append(" ,if(moq.ShowInQC=0,DATE_FORMAT(moq.RemoveReadingDate,'%d-%b-%Y %h:%i %p'),'')RemoveReadingDate");
        sb.Append(" ,if(moq.ShowInQC=0,moq.RemoveReadingByName,'')RemoveReadingByName");

        sb.Append(" ,if(moq.IsVerify=1,'Verified','')VerifiedStatus");
        sb.Append(" ,if(moq.IsVerify=1,DATE_FORMAT(moq.VerifyDate,'%d-%b-%Y %h:%i %p'),'')VerifyDate");
        sb.Append(" ,if(moq.IsVerify=1,moq.VerifyByName,'')VerifyByName");


        sb.Append(" FROM " + Util.getApp("MachineDB") + ".mac_observation_qc moq  ");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=moq.centreid ");
        sb.Append(" and cm.centreid in(" + labid + ") ");
      
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");

        sb.Append(" inner join qc_controlmaster qcm on qcm.`ControlID`=qcd.`ControlID`  and qcm.LotExpiry>=current_date");
       // sb.Append(" and qcm.isactive=1  and qcm.LotExpiry>=current_date ");

        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");

        sb.Append(" WHERE moq.isActive=1 and moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" and moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'");
        if (controlid != "")
        {
            sb.Append(" and moq.ControlID='" + controlid + "' ");
        }
        if (parameterid != "")
        {
            sb.Append(" and moq.LabObservation_ID='" + parameterid + "' ");
        }
        if (levelid != "")
        {
            sb.Append(" and moq.LevelID='" + levelid + "' ");
        }

        switch (type)
        {
            case "Pass": sb.Append(" and moq.qcstatus='Pass' ");
                break;
            case "Warn": sb.Append(" and moq.qcstatus='Warn' ");
                break;
            case "Fail": sb.Append(" and moq.qcstatus='Fail' ");
                break;
            case "NotShowInQC": sb.Append(" and moq.ShowInQC='0' ");
                break;
            case "NotRun": sb.Append(" and moq.qcstatus='Not Run' ");
                break;
        }

        sb.Append(" group by moq.controlid,moq.labobservation_id,moq.dtentry,moq.levelid");
        sb.Append(" order by cm.centre,moq.ControlName,moq.LabObservation_Name,moq.levelid,moq.dtEntry ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());





        DataColumn column = new DataColumn();
        column.ColumnName = "S.No";
        column.DataType = System.Type.GetType("System.Int32");
        column.AutoIncrement = true;
        column.AutoIncrementSeed = 0;
        column.AutoIncrementStep = 1;

        dt.Columns.Add(column);
        int index = 0;
        foreach (DataRow row in dt.Rows)
        {
            row.SetField(column, ++index);
        }
        dt.Columns["S.No"].SetOrdinal(0);
        if (dt.Rows.Count > 0)
        {

            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "QCReport";
            return "true";
        }
        else
        {
            return "false";
        }
       
    }


    [WebMethod(EnableSession = true)]
    public static string updatereading(List<string> controldata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
         {
            foreach (string cd in controldata)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " update " + Util.getApp("MachineDB") + ".mac_observation_qc set OldReading=reading, reading=@reading,UpdateReason=@UpdateReason,UpdateByID=@UpdateByID,UpdateBy=@UpdateBy,Updatedate=@Updatedate where id=@id ",
                     new MySqlParameter("@reading", cd.Split('#')[1]),
                     new MySqlParameter("@UpdateReason", cd.Split('#')[2]),
                     new MySqlParameter("@Updatedate", DateTime.Now),
                     new MySqlParameter("@UpdateByID", UserInfo.ID),
                     new MySqlParameter("@UpdateBy", UserInfo.LoginName),
                     new MySqlParameter("@id", cd.Split('#')[0]));
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
    public static string removefroqc(string id,string status)
    {
        StockReports.ExecuteDML("update " + Util.getApp("MachineDB") + ".mac_observation_qc set ShowInQC=" + status + ",RemoveReadingDate=now(),RemoveReadingByID=" + UserInfo.ID + ",RemoveReadingByName='"+UserInfo.LoginName+"' where id=" + id + " ");
        return "1";
    }
    
    [WebMethod(EnableSession = true)]
    public static string showqcreport(string labid, string controlid, string parameterid, string levelid, string fromdate, string todate,string type,string macid)
    {

        List<string> addEncrypt = new List<string>();
        addEncrypt.Add(Common.Encrypt(labid));
        addEncrypt.Add(Common.Encrypt(controlid));
        addEncrypt.Add(Common.Encrypt(parameterid));
        addEncrypt.Add(Common.Encrypt(levelid));
        addEncrypt.Add(Common.Encrypt(fromdate));
        addEncrypt.Add(Common.Encrypt(todate));
        addEncrypt.Add(Common.Encrypt(type));
        addEncrypt.Add(Common.Encrypt(macid));
        return JsonConvert.SerializeObject(addEncrypt);



        
      
        

    }

    private static string calculate_Mean(DataTable dt)
    {
        double _sd = 0;
        foreach (DataRow dr in dt.Rows)
        {
            _sd += Util.GetDouble(dr["Reading"]);
        }
        _sd = _sd / Util.GetDouble(dt.Rows.Count);

        return _sd.ToString();
    }

    private static string calculate_CV(DataTable dt)
    {
        double _cv = (Util.GetDouble(dt.Rows[0]["Cal_SD"].ToString()) / Util.GetDouble(dt.Rows[0]["Cal_Mean"].ToString())) * 100;
        return _cv.ToString();
    }

    private static string calculate_SD(DataTable dt)
    {
        double _sd = 0;
        foreach (DataRow dr in dt.Rows)
        {
            _sd += Math.Pow(Util.GetFloat(dr["Reading"]) - Util.GetFloat(dr["Cal_Mean"]), 2);
        }
        _sd = _sd / Util.GetDouble(dt.Rows.Count - 1);
        _sd = Math.Sqrt(_sd);


        return _sd.ToString();
    }

    [WebMethod(EnableSession = true)]
    public static string savereading(string labid, string controlid, string parameterid, string levelid, string entrydate, string reading, string ControlName, string LotNumber, string LabObservation_Name, string Level, string barcodeno)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT qcc.machineid,pm.Machine_ParamID,mpm.`AssayNo` FROM qc_control_centre_mapping qcc ");
            sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_param_master pm ON pm.LabObservation_id=@LabObservation_ID ");
            sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machineparam mpm ON mpm.Machine_ParamID=pm.Machine_ParamID AND mpm.`MACHINEID`=qcc.machineid ");
            sb.Append(" WHERE qcc.centreid=@centreid AND qcc.controlid=@controlid AND qcc.`LabObservation_ID`=@LabObservation_ID and qcc.levelid=@LevelID ");

            DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LabObservation_ID", parameterid),
                new MySqlParameter("@centreid", labid),
                new MySqlParameter("@controlid", controlid),
                new MySqlParameter("@LevelID", levelid)).Tables[0];

            if (dt.Rows.Count > 0)
            {


                sb = new StringBuilder();
                sb.Append("SELECT BaseMeanvalue,BaseSDvalue,BaseCVPercentage FROM qc_controlparameter_detail WHERE controlid='" + controlid + "' AND `LabObservation_ID`='" + parameterid + "' AND levelid='" + levelid + "'");

                DataTable dtbase = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];

                sb = new StringBuilder();
                sb.Append(" SELECT reading FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` ");
                sb.Append(" WHERE labno=@labno AND machine_id=@machine_id AND controlid=@controlid AND centreid=@centreid AND levelid=@levelid AND `LabObservation_ID`=@LabObservation_ID ");
                sb.Append(" ORDER BY id DESC LIMIT 10 ");

                DataTable dtoldvalue = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@labno", barcodeno),
                       new MySqlParameter("@machine_id", dt.Rows[0]["machineid"].ToString()),
                       new MySqlParameter("@controlid", controlid),
                       new MySqlParameter("@centreid", labid),
                       new MySqlParameter("@levelid", levelid),
                       new MySqlParameter("@LabObservation_ID", parameterid)
                       ).Tables[0];


                string qcresult = QualityWestGardRule.ApplyWestGardRule(reading, Util.GetString(dtbase.Rows[0]["BaseMeanvalue"]), Util.GetString(dtbase.Rows[0]["BaseSDvalue"]), Util.GetString(dtbase.Rows[0]["BaseCVPercentage"]), dtoldvalue, labid, dt.Rows[0]["machineid"].ToString(), parameterid,levelid,controlid, con);
                string qcstatus = qcresult.Split('#')[0];
                string machinelock = qcresult.Split('#')[2];
                string rulename = qcresult.Split('#')[1];



                sb = new StringBuilder();
                sb.Append(" INSERT  INTO " + Util.getApp("MachineDB") + ".mac_observation_qc(LabNo,Reading,dtEntry,centreid, ");
                sb.Append(" controlid,ControlName,LotNumber,LabObservation_ID,LabObservation_Name,LevelID,Level,Machine_Id,Machine_ParamID,AssayNo,QCStatus,QCRule,IsMachineLock,AddReadingDate,AddReadingByID,AddReadingByName) values ");
                sb.Append(" (@LabNo,@Reading,@dtEntry,@centreid,");
                sb.Append(" @controlid,@ControlName,@LotNumber,@LabObservation_ID,@LabObservation_Name,@LevelID,@Level,@Machine_Id,@Machine_ParamID,@AssayNo,@QCStatus,@QCRule,@IsMachineLock,@AddReadingDate,@AddReadingByID,@AddReadingByName)");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@LabNo", barcodeno),
                     new MySqlParameter("@Reading", reading),
                     new MySqlParameter("@dtEntry", Util.GetDateTime(entrydate).ToString("yyyy-MM-dd") + " " + System.DateTime.Now.ToString("HH:mm:ss")),
                     new MySqlParameter("@centreid", labid),
                     new MySqlParameter("@controlid", controlid),
                     new MySqlParameter("@ControlName", ControlName),
                     new MySqlParameter("@LotNumber", LotNumber),
                     new MySqlParameter("@LabObservation_ID", parameterid),
                     new MySqlParameter("@LabObservation_Name", LabObservation_Name),
                     new MySqlParameter("@LevelID", levelid),
                     new MySqlParameter("@Level", Level),
                     new MySqlParameter("@Machine_Id", dt.Rows[0]["machineid"].ToString()),
                     new MySqlParameter("@Machine_ParamID", dt.Rows[0]["Machine_ParamID"].ToString()),
                     new MySqlParameter("@AssayNo", dt.Rows[0]["AssayNo"].ToString()),
                     new MySqlParameter("@QCStatus", qcstatus),
                     new MySqlParameter("@QCRule", rulename),
                     new MySqlParameter("@IsMachineLock", machinelock),
                     new MySqlParameter("@AddReadingDate", DateTime.Now),
                     new MySqlParameter("@AddReadingByID", UserInfo.ID),
                     new MySqlParameter("@AddReadingByName", UserInfo.LoginName));
                tnx.Commit();
                return "1";

            }
            else
            {
                tnx.Commit();
                return "Parameter and Control Not Mapped..Please Contact To Admin";

            }

         
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


    [WebMethod]
    public static string bindremarks(string type)
    {
        DataTable dt = StockReports.GetDataTable("select RemarksTitle Remarks,ID from qc_remarkmaster where RemarksType='" + type + "'  and isactive=1 order by id");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string bindremarksdetail(string id)
    {
        return StockReports.ExecuteScalar(" select Remarks from qc_remarkmaster where id='" + id + "'");
    }

    [WebMethod] 
    public static string savercaandcapa(string MacDataId, string Type, string QCType, string Comment)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (Type == "RCA")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update " + Util.getApp("MachineDB") + ".mac_observation_qc set RCAType='Comment' where id=@id",
                    new MySqlParameter("@id", MacDataId));
            }
            else if (Type == "CorrectiveAction")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update " + Util.getApp("MachineDB") + ".mac_observation_qc set CAType='Comment' where id=@id",
                   new MySqlParameter("@id", MacDataId));
            }
            else if (Type == "PreventiveAction")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update " + Util.getApp("MachineDB") + ".mac_observation_qc set PAType='Comment' where id=@id",
                   new MySqlParameter("@id", MacDataId));
            }


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_qcfaildata set IsActive=@IsActive,Updatedate=@Updatedate,UpdatebyId=@UpdatebyId,UpdateByname=@UpdateByname where MacDataId=@MacDataId and  Type=@Type and QCType=@QCType",
           new MySqlParameter("@IsActive", "0"),
           new MySqlParameter("@Updatedate", DateTime.Now),
           new MySqlParameter("@UpdateByID", UserInfo.ID),
           new MySqlParameter("@UpdateByname", UserInfo.LoginName),
           new MySqlParameter("@MacDataId", MacDataId),
           new MySqlParameter("@Type", Type),
           new MySqlParameter("@QCType", QCType)
           );


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " insert into  qc_qcfaildata(MacDataId,Type,QCType,Comment,EntryDate,EntryByID,EntryByName) values (@MacDataId,@Type,@QCType,@Comment,@EntryDate,@EntryByID,@EntryByName)",
                     new MySqlParameter("@MacDataId", MacDataId),
                     new MySqlParameter("@Type", Type),
                     new MySqlParameter("@QCType", QCType),
                     new MySqlParameter("@Comment", Comment),
                     new MySqlParameter("@EntryDate", DateTime.Now),
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
    public static string removercaandcapa(string MacDataId, string Type, string QCType)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {




            if (Type == "RCA")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update " + Util.getApp("MachineDB") + ".mac_observation_qc set RCAType='' where id=@id",
                    new MySqlParameter("@id", MacDataId));
            }
            else if (Type == "CorrectiveAction")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update " + Util.getApp("MachineDB") + ".mac_observation_qc set CAType='' where id=@id",
                   new MySqlParameter("@id", MacDataId));
            }
            else if (Type == "PreventiveAction")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update " + Util.getApp("MachineDB") + ".mac_observation_qc set PAType='' where id=@id",
                   new MySqlParameter("@id", MacDataId));
            }


         
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_qcfaildata set IsActive=@IsActive,Updatedate=@Updatedate,UpdatebyId=@UpdatebyId,UpdateByname=@UpdateByname where MacDataId=@MacDataId and  Type=@Type and QCType=@QCType",
              new MySqlParameter("@IsActive", "0"),
              new MySqlParameter("@Updatedate", DateTime.Now),
              new MySqlParameter("@UpdateByID", UserInfo.ID),
              new MySqlParameter("@UpdateByname", UserInfo.LoginName),
              new MySqlParameter("@MacDataId", MacDataId),
              new MySqlParameter("@Type", Type),
              new MySqlParameter("@QCType", QCType)
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
    public static string verifyqcr(List<string> dataIm)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (string id in dataIm)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " update " + Util.getApp("MachineDB") + ".mac_observation_qc set IsVerify=1,VerifyDate=@VerifyDate,VerifyByID=@VerifyByID,VerifyByName=@VerifyByName where id=@id",
                   new MySqlParameter("@id", id),
                   new MySqlParameter("@VerifyDate", DateTime.Now),
                   new MySqlParameter("@VerifyByID", UserInfo.ID),
                   new MySqlParameter("@VerifyByName", UserInfo.LoginName));
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
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_CheckQCStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {


       
        string labno = Util.GetString(Request.Form["labno"]);
        string machine_id = Util.GetString(Request.Form["machine_id"]);
        string Machine_ParamID = Util.GetString(Request.Form["Machine_ParamID"]);
        string reading = Util.GetString(Request.Form["reading"]);


        if (labno == "" || machine_id == "" || Machine_ParamID == "")
        {
            string response = "{\"ResponseCode\": 0,\"ResponseMessage\": \"Please Enter Valid Data\",\"LockMachine\": 0,\"RuleName\":\"\"}";
            Response.Write(response);
            return;
        }

  
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
       
        try
        {
            // WestGard Rule
            StringBuilder sb = new StringBuilder();
            sb.Append(" select qcc.centreid,qcc.controlid,qcc.ControlName,qcc.LotNumber,AssayNo,qcc.LevelID,qcc.Level,qcc.LabObservation_ID,");
            sb.Append(" ifnull(qcc.Minvalue,qcd.Minvalue)Minvalue, ifnull(qcc.Maxvalue,qcd.Maxvalue)`Maxvalue`, ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)BaseMeanvalue,");
            sb.Append(" ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)BaseSDvalue ,ifnull(qcc.BaseCVPercentage,qcd.BaseCVPercentage)BaseCVPercentage,qcd.Unit,qcd.Temperature,qcd.Method ");
            sb.Append(" from qc_control_centre_mapping qcc");
            sb.Append(" inner join " + Util.getApp("MachineDB") + ".mac_param_master mpm on qcc.LabObservation_ID=mpm.LabObservation_id and mpm.Machine_ParamID=@Machine_ParamID");
            sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=qcc.controlid  ");
            sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcd.LevelID=qcc.LevelID ");
            sb.Append(" where qcc.BarcodeNo=@labno AND qcc.MachineID=@machine_id ");

            DataTable dt =MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), 
                new MySqlParameter("@labno", labno), 
                new MySqlParameter("@machine_id", machine_id),
                new MySqlParameter("@Machine_ParamID", Machine_ParamID)).Tables[0];

            if (dt.Rows.Count > 0)
            {

                sb = new StringBuilder();
                sb.Append(" SELECT reading FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` ");
                sb.Append(" WHERE labno=@labno AND machine_id=@machine_id AND controlid=@controlid AND centreid=@centreid AND levelid=@levelid AND `LabObservation_ID`=@LabObservation_ID ");
                sb.Append(" ORDER BY id DESC LIMIT 10 ");

                DataTable dtoldvalue = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@labno", labno),
                       new MySqlParameter("@machine_id", machine_id),
                       new MySqlParameter("@controlid",  Util.GetString(dt.Rows[0]["controlid"])),
                       new MySqlParameter("@centreid", Util.GetInt(dt.Rows[0]["centreid"])),
                       new MySqlParameter("@levelid",  Util.GetInt(dt.Rows[0]["LevelID"])),
                       new MySqlParameter("@LabObservation_ID", Util.GetInt(dt.Rows[0]["LabObservation_ID"]))
                       ).Tables[0];


                string qcresult = QualityWestGardRule.ApplyWestGardRule(reading, Util.GetString(dt.Rows[0]["BaseMeanvalue"]), Util.GetString(dt.Rows[0]["BaseSDvalue"]), Util.GetString(dt.Rows[0]["BaseCVPercentage"]), dtoldvalue,"","","","","",con);
                string qcstatus=qcresult.Split('#')[0];
                string machinelock = qcresult.Split('#')[2];
                string rulename = qcresult.Split('#')[1];

                sb = new StringBuilder();
                sb.Append(" INSERT INTO " + Util.getApp("MachineDB") + ".mac_observation_qc(LabNo,Machine_Id,Machine_ParamID,Reading,isActive,dtEntry,");
                sb.Append(" centreid,controlid,ControlName,LotNumber,LabObservation_ID,LabObservation_Name,AssayNo,LevelID,`Level`,MappingID,QCStatus,QCRule,IsMachineLock)");
                sb.Append(" select '" + labno + "', '" + machine_id + "' ,'" + Machine_ParamID + "','" + reading + "', 1,now(),");
                sb.Append(" centreid,controlid,ControlName,LotNumber,qcc.LabObservation_ID,LabObservation_Name,AssayNo,LevelID,Level,0,'" + qcstatus + "','" + rulename + "'," + machinelock + " ");
                sb.Append(" from qc_control_centre_mapping qcc ");
                sb.Append(" inner join " + Util.getApp("MachineDB") + ".mac_param_master mpm on qcc.LabObservation_ID=mpm.LabObservation_id and mpm.Machine_ParamID=@Machine_ParamID");
                sb.Append(" where qcc.BarcodeNo=@labno AND qcc.MachineID=@machine_id ");

                int a = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@labno", labno),
                    new MySqlParameter("@machine_id", machine_id),
                    new MySqlParameter("@Machine_ParamID", Machine_ParamID));




                string response = "{\"ResponseCode\": 1,\"ResponseMessage\": \"" + qcstatus + "\",\"LockMachine\": " + machinelock + ",\"RuleName\":\"" + rulename + "\"}";
                Response.Write(response);
            }
            else
            {
                string response = "{\"ResponseCode\": 0,\"ResponseMessage\": \"Please Enter Valid Data\",\"LockMachine\": 0,\"RuleName\":\"\"}";
                Response.Write(response);
            }

        }
        catch(Exception ex)
        {
          
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            string response = "{\"ResponseCode\": 0,\"ResponseMessage\": \"" + ex.Message + "\",\"LockMachine\": 0,\"RuleName\":\"\"}";
            Response.Write(response);
        }
        finally
        {
           
            con.Close();
            con.Dispose();
        }


    }
}
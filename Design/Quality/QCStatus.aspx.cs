using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_QCStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string GetData = (new StreamReader(Request.InputStream)).ReadToEnd();
        DataTable dtresponse = new DataTable();
        dtresponse.Columns.Add("ResponseCode");
        dtresponse.Columns.Add("ResponseMessage");
        dtresponse.Columns.Add("parametername");
        dtresponse.Columns.Add("labno");
        dtresponse.Columns.Add("machine_id");
        dtresponse.Columns.Add("Machine_ParamID");
        dtresponse.Columns.Add("QCStatus");
        dtresponse.Columns.Add("LockMachine");
        dtresponse.Columns.Add("RuleName");

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            if (GetData == "")
            {
                DataRow ddw = dtresponse.NewRow();
                ddw["ResponseCode"] = "0";
                ddw["ResponseMessage"] = "Please Enter Valid Data";
                ddw["parametername"] = "";
                ddw["labno"] = "";
                ddw["machine_id"] = "";
                ddw["Machine_ParamID"] = "";
                ddw["QCStatus"] = "";
                ddw["LockMachine"] = "0";
                ddw["RuleName"] = "";
                dtresponse.Rows.Add(ddw);
                string response = Newtonsoft.Json.JsonConvert.SerializeObject(dtresponse);
                Response.Write(response);
                return;
            }


            List<MyData> MyDataJson = Newtonsoft.Json.JsonConvert.DeserializeObject<List<MyData>>(GetData);





            foreach (MyData md in MyDataJson)
            {

                string labno = md.labno;
                string machine_id = md.machine_id;
                string Machine_ParamID = md.Machine_ParamID;
                string reading = md.reading;

                if (labno == "" || machine_id == "" || Machine_ParamID == "")
                {
                    continue;
                }
               

                // WestGard Rule
                StringBuilder sb = new StringBuilder();
                sb.Append(" select qcd.LabObservation_Name, qcc.centreid,qcc.controlid,qcc.ControlName,qcc.LotNumber,AssayNo,qcc.LevelID,qcc.Level,qcc.LabObservation_ID,");
                sb.Append(" ifnull(qcc.Minvalue,qcd.Minvalue)Minvalue, ifnull(qcc.Maxvalue,qcd.Maxvalue)`Maxvalue`, ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)BaseMeanvalue,");
                sb.Append(" ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)BaseSDvalue ,ifnull(qcc.BaseCVPercentage,qcd.BaseCVPercentage)BaseCVPercentage, ");
                sb.Append(" qcd.Unit,qcd.Temperature,qcd.Method,qcc.LockMachine ,qcc.MachineGroupId ");
                sb.Append(" from qc_control_centre_mapping qcc");
                sb.Append(" inner join " + Util.getApp("MachineDB") + ".mac_param_master mpm on qcc.LabObservation_ID=mpm.LabObservation_id and mpm.Machine_ParamID=@Machine_ParamID and qcc.isactive=1");
                sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=qcc.controlid  ");
                sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcd.LevelID=qcc.LevelID ");
                sb.Append(" where qcc.BarcodeNo=@labno AND qcc.MachineID=@machine_id order by qcc.id desc limit 1 ");

                DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@labno", labno),
                    new MySqlParameter("@machine_id", machine_id),
                    new MySqlParameter("@Machine_ParamID", Machine_ParamID)).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    float r = 0;
                    if (!float.TryParse(reading, out r))
                    {
                        DataRow ddw = dtresponse.NewRow();
                        ddw["ResponseCode"] = "1";
                        ddw["ResponseMessage"] = "Data Found";
                        ddw["parametername"] = Util.GetString(dt.Rows[0]["LabObservation_Name"]);
                        ddw["labno"] = labno;
                        ddw["machine_id"] = machine_id;
                        ddw["Machine_ParamID"] = Machine_ParamID;
                        ddw["QCStatus"] = "Pass";
                        ddw["LockMachine"] = "0";
                        ddw["RuleName"] = "";


                        dtresponse.Rows.Add(ddw);

                        continue;
                    }
                }



                if (dt.Rows.Count > 0)
                {

                    sb = new StringBuilder();
                    sb.Append(" SELECT reading FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` ");
                    sb.Append(" WHERE labno=@labno AND machine_id=@machine_id AND controlid=@controlid AND centreid=@centreid AND levelid=@levelid AND `LabObservation_ID`=@LabObservation_ID ");
                    sb.Append(" ORDER BY id DESC LIMIT 10 ");

                    DataTable dtoldvalue = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@labno", labno),
                           new MySqlParameter("@machine_id", machine_id),
                           new MySqlParameter("@controlid", Util.GetString(dt.Rows[0]["controlid"])),
                           new MySqlParameter("@centreid", Util.GetInt(dt.Rows[0]["centreid"])),
                           new MySqlParameter("@levelid", Util.GetInt(dt.Rows[0]["LevelID"])),
                           new MySqlParameter("@LabObservation_ID", Util.GetInt(dt.Rows[0]["LabObservation_ID"]))
                           ).Tables[0];


                    string qcresult = QualityWestGardRule.ApplyWestGardRule(reading, Util.GetString(dt.Rows[0]["BaseMeanvalue"]), Util.GetString(dt.Rows[0]["BaseSDvalue"]), Util.GetString(dt.Rows[0]["BaseCVPercentage"]), dtoldvalue, Util.GetString(dt.Rows[0]["centreid"]), machine_id, Util.GetString(dt.Rows[0]["LabObservation_ID"]), Util.GetString(dt.Rows[0]["LevelID"]),Util.GetString(dt.Rows[0]["controlid"]), con);
                    string qcstatus = qcresult.Split('#')[0];

                    string machinelock = qcresult.Split('#')[2];
                    string rulename = qcresult.Split('#')[1];

                    if (Util.GetInt(dt.Rows[0]["LockMachine"]) == 0)
                    {
                        machinelock = "0";
                    }

                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO " + Util.getApp("MachineDB") + ".mac_observation_qc(isMachineDateTime,LabNo,Machine_Id,Machine_ParamID,Reading,isActive,dtEntry,");
                    sb.Append(" centreid,controlid,ControlName,LotNumber,LabObservation_ID,LabObservation_Name,AssayNo,LevelID,`Level`,MappingID,QCStatus,QCRule,IsMachineLock)");
                    if (String.IsNullOrEmpty(md.EntryDate))
                    {
                        sb.Append(" select 0,'" + labno + "', '" + machine_id + "' ,'" + Machine_ParamID + "','" + reading + "', 1,now(),");
                    }
                    else
                    {
                        sb.Append(" select 1,'" + labno + "', '" + machine_id + "' ,'" + Machine_ParamID + "','" + reading + "', 1,'" + DateTime.ParseExact(md.EntryDate, "yyyyMMddHHmmss", CultureInfo.InvariantCulture).ToString("yyyy-MM-dd HH:mm:ss") + "',");
                    }
                    sb.Append(" centreid,controlid,ControlName,LotNumber,qcc.LabObservation_ID,LabObservation_Name,AssayNo,LevelID,Level,0,'" + qcstatus + "','" + rulename + "'," + machinelock + " ");
                    sb.Append(" from qc_control_centre_mapping qcc ");
                    sb.Append(" inner join " + Util.getApp("MachineDB") + ".mac_param_master mpm on qcc.LabObservation_ID=mpm.LabObservation_id and mpm.Machine_ParamID=@Machine_ParamID and qcc.isactive=1");
                    sb.Append(" where qcc.BarcodeNo=@labno AND qcc.MachineID=@machine_id order by qcc.id desc limit 1 ");

                    int a = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@labno", labno),
                        new MySqlParameter("@machine_id", machine_id),
                        new MySqlParameter("@Machine_ParamID", Machine_ParamID));



                    // insert into autoconsume table

                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO  mac_data_AutoConsumption ");
                    sb.Append(" (`id`,`centreid`,`LabNo`,Investigation_ID,`LabObservation_ID`,");
                    sb.Append(" isRerun,`Reading`,`machineid`,");
                    sb.Append(" `dtEntry`,`PName`,`Age`,`Gender`,");
                    sb.Append(" `MachineName`,`Test_id`,`BarcodeNo`,`LedgerTransactionNo`,");
                    sb.Append("`InvestigationName`,`LabObservationName`,`Temprature`,");
                    sb.Append("`VialID`,`Updatedate`,`Status`,`MacDate`,EntryStatus,RecordNO)");
                    sb.Append(" values ");
                    sb.Append(" (0,"+Util.GetInt(dt.Rows[0]["centreid"])+",'"+labno+"','0','"+Util.GetInt(dt.Rows[0]["LabObservation_ID"])+"', ");
                    sb.Append(" 2,'" + reading + "','" + Util.GetString(dt.Rows[0]["MachineGroupId"]) + "',");
                    sb.Append(" now(),'QC','','',");
                    sb.Append(" '" + machine_id + "',0,'" + labno + "','',");
                    sb.Append(" '','" + Util.GetString(dt.Rows[0]["LabObservation_Name"]) + "','',");
                    sb.Append(" '',now(),'Receive',now(),'Machine',0)");
                   // MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());







                    DataRow ddw = dtresponse.NewRow();
                    ddw["ResponseCode"] = "1";
                    ddw["ResponseMessage"] = "Data Found";
                    ddw["parametername"] = Util.GetString(dt.Rows[0]["LabObservation_Name"]);
                    ddw["labno"] = labno;
                    ddw["machine_id"] = machine_id;
                    ddw["Machine_ParamID"] = Machine_ParamID;
                    ddw["QCStatus"] = qcstatus;
                    ddw["LockMachine"] = machinelock;
                    ddw["RuleName"] = rulename;


                    dtresponse.Rows.Add(ddw);


                 
                }
                else
                {

                    DataRow ddw = dtresponse.NewRow();
                    ddw["ResponseCode"] = "1";
                    ddw["ResponseMessage"] = "Data Not Found";
                    ddw["parametername"] = "";
                    ddw["labno"] = labno;
                    ddw["machine_id"] = machine_id;
                    ddw["Machine_ParamID"] = Machine_ParamID;
                    ddw["QCStatus"] = "";
                    ddw["LockMachine"] = "0";
                    ddw["RuleName"] = "";


                    dtresponse.Rows.Add(ddw);



                }
            }

            string responsem = Newtonsoft.Json.JsonConvert.SerializeObject(dtresponse);
            Response.Write(responsem);


        }
        catch (Exception ex)
        {

            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            DataRow ddw = dtresponse.NewRow();
            ddw["ResponseCode"] = "0";
            ddw["ResponseMessage"] = ex.Message;
            ddw["LockMachine"] = "0";
            dtresponse.Rows.Add(ddw);
            string response = Newtonsoft.Json.JsonConvert.SerializeObject(dtresponse);
            Response.Write(response);

        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }

    class MyData
    {
        public string labno { get; set; }
        public string machine_id { get; set; }
        public string Machine_ParamID { get; set; }
        public string reading { get; set; }
        public string EntryDate { get; set; }
    }
}
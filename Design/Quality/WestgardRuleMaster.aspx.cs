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

public partial class Design_Quality_WestgardRuleMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlprocessinglab.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master)  and cm.isActive=1 ORDER BY centre");
            ddlprocessinglab.DataValueField = "centreid";
            ddlprocessinglab.DataTextField = "centre";
            ddlprocessinglab.DataBind();
            ddlprocessinglab.Items.Insert(0, new ListItem("Select Centre", "0"));
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindmachine(string labid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT machineid MacID, machineid machinename  FROM " + Util.getApp("MachineDB") + ".`mac_machinemaster` mmc INNER JOIN macmaster mm ON mm.ID=mmc.groupid WHERE centreid=" + labid + " ORDER BY machineid"));

    }
    [WebMethod(EnableSession = true)]
    public static string bindparameter(string macid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lom.`LabObservation_ID`, TRIM(lom.`Name`) PatameterName  FROM `labobservation_master` lom    ");
        sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_param_master pm ON pm.LabObservation_id=lom.LabObservation_ID  ");
        sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machineparam mpm ON mpm.Machine_ParamID=pm.Machine_ParamID and mpm.MACHINEID='" + macid + "'  ");
        sb.Append("  GROUP BY lom.`LabObservation_ID`  ORDER BY lom.Name ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    

    [WebMethod(EnableSession = true)]
    public static string getruledata(string rulename)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ruleinfo,ruleimage,rulename FROM qc_rulemaster WHERE rulename='" + rulename + "'"));
    }
    [WebMethod(EnableSession = true)]
    public static string SaveData(List<QCRule> ruledata)
    {

         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         try
         {
             if (ruledata[0].IsDefault == 1)
             {
                 MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_westgradruleapplicable set isactive=0,UpdateDate=now(),UpdateByName='" + UserInfo.LoginName + "',UpdateByID=" + UserInfo.ID + " where IsDefault=1;");
             }

             else
             {
                 MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_westgradruleapplicable set isactive=0,UpdateDate=now(),UpdateByName='" + UserInfo.LoginName + "',UpdateByID=" + UserInfo.ID + " where IsDefault=0 and centreid=" + ruledata[0].CentreID + " and MachineID='" + ruledata[0].MachineID + "' and LabObservation_ID=" + ruledata[0].LabObservation_ID + ";");
             }
             foreach (QCRule ccm in ruledata)
             {
                 MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into qc_westgradruleapplicable(RuleName,RuleAction,IsDefault,CentreID,MachineID,LabObservation_ID,isactive,EntryDatetime,EntryByName,EntryByID,CheckLevel) values ('" + ccm.RuleName + "','" + ccm.RuleAction + "','" + ccm.IsDefault + "'," + ccm.CentreID + ",'" + ccm.MachineID + "'," + ccm.LabObservation_ID + ",1,now(),'" + UserInfo.LoginName + "'," + UserInfo.ID + "," + ccm.CheckLevel + ")");
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
    public static string getdata(string isdefault, string centreid, string machineid, string parameterid)
    {
        StringBuilder sb=new StringBuilder();
        sb.Append(" SELECT rulename,ruleaction,checklevel FROM qc_westgradruleapplicable WHERE isactive=1");
        sb.Append(" and isdefault=" + isdefault + "");
        if (isdefault == "0")
        {
            sb.Append(" and CentreID="+centreid+"");
            sb.Append(" and machineid='" + machineid + "'");
            sb.Append(" and LabObservation_ID=" + parameterid + "");
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    

    public class QCRule
    {
        public int IsDefault { get; set; }
        public int CentreID { get; set; }
        public string MachineID { get; set; }
        public int LabObservation_ID { get; set; }
        public string RuleName { get; set; }
        public string RuleAction { get; set; }
        public int CheckLevel { get; set; }
    }
}
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

public partial class Design_Lab_NewCopyMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            ddlfromcentre.DataSource = StockReports.GetDataTable("SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and cm.isActive=1 ORDER BY centre");
            ddlfromcentre.DataValueField = "centreid";
            ddlfromcentre.DataTextField = "centre";
            ddlfromcentre.DataBind();
            ddlfromcentre.Items.Insert(0, new ListItem("Select From Centre", "0"));


            ddltocentre.DataSource = ddlfromcentre.DataSource;
            ddltocentre.DataValueField = "centreid";
            ddltocentre.DataTextField = "centre";
            ddltocentre.DataBind();
            ddltocentre.Items.Insert(0, new ListItem("Select To Centre", "0"));

        }
    }
    [WebMethod]
    public static string bindmachine(string centreid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("Select MACHINEID,MACHINENAME from " + Util.getApp("MachineDB") + ".mac_machinemaster where centreid=" + centreid + " and isactive=1 order by MACHINENAME"));
    }
    [WebMethod]
    public static string transfermapping(string frommachine, string tomachine)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" DELETE mp,mpm FROM " + Util.getApp("MachineDB") + ".mac_machineparam mp  ");
            sb.Append(" INNER JOIN  " + Util.getApp("MachineDB") + ".mac_param_master mpm ON mp.`Machine_ParamID`=mpm.`Machine_ParamID` where mp.`MACHINEID`='" + tomachine + "' ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.Append(" INSERT INTO " + Util.getApp("MachineDB") + ".mac_machineparam(Machine_ParamID,MachineID,Machine_Param,AssayNo,IsOrderable,  ");
            sb.Append(" `IsRound`,`RoundUpTo`,`Decimalcalc`) ");
            sb.Append("  SELECT REPLACE(Machine_ParamID,'" + frommachine + "','" + tomachine + "') Machine_ParamID,'" + tomachine + "' MachineID, ");
            sb.Append("  REPLACE(Machine_Param,'" + frommachine + "','" + tomachine + "') Machine_Param,REPLACE(Machine_Paramid,'" + frommachine + "_','') AssayNo, ");
            sb.Append(" `IsOrderable`,`IsRound`,`RoundUpTo`,`Decimalcalc` ");
            sb.Append("  FROM " + Util.getApp("MachineDB") + ".mac_machineparam WHERE machineid='" + frommachine + "' ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.Append(" INSERT INTO " + Util.getApp("MachineDB") + ".mac_param_master(Machine_ParamID,LabObservation_id) ");
            sb.Append(" SELECT REPLACE(Machine_ParamID,'" + frommachine + "','" + tomachine + "') Machine_ParamID,LabObservation_id  ");
            sb.Append(" FROM " + Util.getApp("MachineDB") + ".`mac_param_master` WHERE machine_paramid LIKE '" + frommachine + "%' ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
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


    [WebMethod]
    public static string getdata(string macid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT mp.`MACHINEID`,mp.`Machine_ParamID`,mpm.`LabObservation_id`,lom.`Name` LabObservationname,mp.`AssayNo`,mp.`Machine_Param`, mp.`RoundUpTo`");
        sb.Append(" FROM   " + Util.getApp("MachineDB") + ".mac_machineparam mp ");
        sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_param_master mpm ON mp.`Machine_ParamID`=mpm.`Machine_ParamID` ");
        sb.Append(" INNER JOIN labobservation_master lom ON lom.`LabObservation_ID`=mpm.`LabObservation_id`");
        sb.Append(" AND mp.`MACHINEID`='" + macid + "'");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }
}
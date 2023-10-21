using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Master_Investigation_MachineMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindcentre();
            bindmachine();
        }
    }

    private void bindmachine()
    {
        DataTable dt = StockReports.GetDataTable("SELECT CONCAT(NAME,'|',IFNULL(colour,'')) NAME,CONCAT(ID,'|',IFNULL(colour,''))ID FROM macmaster WHERE Isactive=1");
        ddlMachine.DataSource = dt;
        ddlMachine.DataTextField = "NAME";
        ddlMachine.DataValueField = "ID";
        ddlMachine.DataBind();
        ddlMachine.Items.Insert(0, new ListItem("--select--", "0"));
    }

    private void bindcentre()
    {
        DataTable dt = StockReports.GetDataTable("SELECT CentreID,Centre FROM centre_master WHERE IsActive=1");
        ddlcentre.DataSource = dt;
        ddlcentre.DataTextField = "Centre";
        ddlcentre.DataValueField = "CentreID";
        ddlcentre.DataBind();
        ddlcentre.Items.Insert(0, new ListItem("--select--", "0"));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string binddept()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT SubcategoryID,NAME FROM `f_subcategorymaster` WHERE Active=1 "));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindInvestigation(string Dept)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Investigation_ID,NAME FROM investigation_master im ");
        sb.Append(" INNER JOIN f_itemmaster itm ON itm.type_ID=im.Investigation_ID ");
        if (Dept != "0")
        {
            sb.Append(" WHERE itm.SubcategoryID='" + Dept + "' ");
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveData(string InvestigationID, string CentreID, string MachineID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from investigation_machinemaster where Investigation_ID='" + InvestigationID + "' and CentreID='" + CentreID + "'");

            StringBuilder sb = new StringBuilder();
            sb.Append(" insert into investigation_machinemaster(Investigation_ID,CentreID,MachineID,Colour,CreatedByID,CreateBy)");
            sb.Append(" values('" + Util.GetString(InvestigationID) + "','" + Util.GetInt(CentreID) + "','" + Util.GetInt(MachineID.Split('|')[0]) + "','" + Util.GetString(MachineID.Split('|')[1]).ToString() + "','" + UserInfo.ID + "','" + UserInfo.LoginName + "') ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string Investigationid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.Name,invm.ID,mac.Name MachineName,cm.Centre,invm.colour FROM `investigation_master` im ");
        sb.Append(" INNER JOIN investigation_machinemaster invm ON invm.Investigation_ID=im.Investigation_ID ");
        sb.Append(" INNER JOIN macmaster mac ON mac.ID=invm.MachineID ");
        sb.Append(" INNER JOIN centre_Master cm ON cm.centreID=invm.CentreID ");
        if (Investigationid != "0")
        {
            sb.Append(" where invm.Investigation_ID='" + Investigationid + "' ");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}
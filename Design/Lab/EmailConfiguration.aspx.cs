using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_Lab_EmailConfiguration : System.Web.UI.Page
{
    public string CentreID = string.Empty;
    public string Panel_ID = string.Empty; public string Type = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Type = Request.QueryString["Type"];
            if (Type == "PUP")
                Panel_ID = Common.Decrypt(Request.QueryString["Panel_ID"]);
            else
                CentreID = Common.Decrypt(Request.QueryString["centreID"]);
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindData(string CentreID, string Type, string Panel_ID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT AllowSampleRejection ,SampleRejectionEmailTO ,SampleRejectionEmailCC ,SampleRejectionEmailBCC  ");
        sb.Append(" FROM f_panel_master  WHERE  ");
        if (Type == "PUP")
        {
            sb.Append(" `Panel_ID`=" + Panel_ID.Trim() + " AND `PanelType`='PUP'");
        }
        else
        {
            sb.Append(" `CentreID`=" + CentreID.Trim() + " AND `PanelType`<>'PUP'");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string SaveData(EmailConfiguration EmailConfigurationData)
    {
        string retValue = "0";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update f_panel_master set ");
            sb.Append(" AllowSampleRejection=@AllowSampleRejection, ");
            sb.Append(" SampleRejectionEmailTO=@SampleRejectionEmailTO, ");
            sb.Append(" SampleRejectionEmailCC=@SampleRejectionEmailCC, ");
            sb.Append(" SampleRejectionEmailBCC=@SampleRejectionEmailBCC ");

            if (EmailConfigurationData.Type == "PUP")
            {
                sb.Append(" WHERE Panel_ID=@Panel_ID AND PanelType='PUP' ");
            }
            else
            {
                sb.Append(" WHERE CentreID=@CentreID AND   PanelType<>'PUP' ");
            }

            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);
            cmd.Parameters.AddWithValue("@AllowSampleRejection", EmailConfigurationData.AllowSampleRejection.Trim());
            cmd.Parameters.AddWithValue("@SampleRejectionEmailTO", EmailConfigurationData.SampleRejectionEmailTO.Trim());
            cmd.Parameters.AddWithValue("@SampleRejectionEmailCC", EmailConfigurationData.SampleRejectionEmailCC.Trim());
            cmd.Parameters.AddWithValue("@SampleRejectionEmailBCC", EmailConfigurationData.SampleRejectionEmailBCC.Trim());

            if (EmailConfigurationData.Type == "PUP")
            {
                cmd.Parameters.AddWithValue("@Panel_ID", EmailConfigurationData.Panel_ID.Trim());
            }
            else
            {
                cmd.Parameters.AddWithValue("@CentreID", EmailConfigurationData.CentreID.Trim());
            }
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            tnx.Commit();

            retValue = "1#";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            retValue = "0#" + Util.GetString(ex.GetBaseException());
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        return retValue;
    }

    public class EmailConfiguration
    {
        public string CentreID { get; set; }
        public string AllowSampleRejection { get; set; }
        public string SampleRejectionEmailTO { get; set; }
        public string SampleRejectionEmailCC { get; set; }
        public string SampleRejectionEmailBCC { get; set; }

        public string Panel_ID { get; set; }
        public string Type { get; set; }
    }
}
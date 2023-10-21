using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Master_ReportBackGound : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindPanel();
        }
    }

    private void BindPanel()
    {
        ddlcentre.DataSource = StockReports.GetDataTable("Select Panel_Id,Company_Name From f_Panel_master where Panel_Id=" + Util.GetString(Request["PanelId"]));
        ddlcentre.DataTextField = "Company_Name";
        ddlcentre.DataValueField = "Panel_Id";
        ddlcentre.DataBind();
        hdnPanelId.Value = Util.GetString(Request["PanelId"]);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindData(string PanelId)
    {
        string str = "SELECT SMSFor,Templete,IFNULL(pnl.`Id`,'0') IsSelected,st.Id FROM SMS_Template ST ";
        str += " LEFT JOIN f_Panel_master_SMS pnl ON st.Id=pnl.`SMSId` AND pnl.Panel_Id ='" + PanelId + "' ";
        using (DataTable dt = StockReports.GetDataTable(str))
        {
            string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveSMSConfig(string PanelId, string SMSId)
    {
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    string str = "DELETE FROM f_Panel_master_SMS WHERE Panel_Id = '" + PanelId + "'";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str.ToString());
                    if (SMSId != "")
                    {
                        string[] arr = SMSId.Split(',');
                        StringBuilder sb = new StringBuilder();
                        sb.Append("INSERT INTO f_Panel_master_SMS(Panel_ID,SMSId,IsActive) VALUES ");
                        for (int i = 0; i < arr.Length; i++)
                        {
                            sb.Append(" ('" + PanelId + "','" + arr[i] + "',1),");
                        }
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString().Substring(0, sb.ToString().Length - 1));
                    }
                    Tnx.Commit();
                    con.Close();
                    return "1";
                }
                catch
                {
                    Tnx.Rollback();
                    con.Close();
                    return "0";
                }
                finally
                {
                    Tnx.Dispose();
                    con.Dispose();
                }
            }
        }
    }
}
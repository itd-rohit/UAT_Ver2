using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_Master_LedgerPassword : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblCentreName.Text = UserInfo.CentreName;
        }
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateLedgerPassword(object LedPassword)
    {
        List<LedgerPassword> LedgerData = new JavaScriptSerializer().ConvertToType<List<LedgerPassword>>(LedPassword);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string oldPassword = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT LedgerReportPassword FROM f_panel_master WHERE CentreID=@CentreID",
                 new MySqlParameter("@CentreID", UserInfo.Centre)));
            if (oldPassword != string.Empty)
            {
                if (oldPassword.ToLower() == LedgerData[0].NewPassword.ToLower())
                    return "-1";
            }

            if (LedgerData[0].NewPassword.ToLower() != LedgerData[0].ConfirmPassword.ToLower())
                return "-2";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET LedgerReportPassword=@LedgerReportPassword WHERE CentreID=@CentreID",
              new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@LedgerReportPassword", LedgerData[0].NewPassword));
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public class LedgerPassword
    {
        public string OldPassword { get; set; }
        public string NewPassword { get; set; }
        public string ConfirmPassword { get; set; }
    }
}
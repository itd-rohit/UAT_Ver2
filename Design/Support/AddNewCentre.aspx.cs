using MySql.Data.MySqlClient;
using System;
using System.Text;
using System.Data;
public partial class Design_Support_AddNewCentre : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false)
        {
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        saveCentre();
    }

    private void saveCentre()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("insert into support_site_master(Name,IP,DB,Uid,Pwd) values(");
            sb.Append("@Name,@IP,@DB,@Uid,@Pwd)");


            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Name", txtName.Text.ToUpper()),
                new MySqlParameter("@IP", txtIp.Text),
                new MySqlParameter("@DB", txtDbName.Text),
                new MySqlParameter("@Uid", txtUid.Text),
                new MySqlParameter("@Pwd", Txtpwd.Text));

            Response.Write(Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT max(SiteId) from support_site_master")));
            txtName.Text = string.Empty;
            txtDbName.Text = string.Empty;
            txtIp.Text = string.Empty;
            txtDbName.Text = string.Empty;
            txtUid.Text = string.Empty;
            Txtpwd.Text = string.Empty;
            txtName.Focus();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
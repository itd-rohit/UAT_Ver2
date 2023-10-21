using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_Utility_UtilityLoadData : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblerrmsg.Text = "";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "call Utility_backup_transaction(@fromdate,@todate)",
                new MySqlParameter("@fromdate", Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd")),
                new MySqlParameter("@todate", Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd")));
            tranX.Commit();
            lblerrmsg.Text = "Data Uploaded Successfully...!";
            return;
        }
        catch (Exception ex)
        {
            lblerrmsg.Text = ex.GetBaseException().ToString();
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            tranX.Rollback();
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
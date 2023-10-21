using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_ShowAttachment : System.Web.UI.Page
{
    public DataTable dt;
    protected void Page_Load(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT id, CONCAT('/',filename) filename,'Reg' saveat FROM appointment_radiology_details_attachment WHERE AppID=@AppID ",
                      new MySqlParameter("@AppID", Request.QueryString["AppID"])).Tables[0])
            {
                foreach (DataRow dw in dt.Rows)
                {
                    string s = "key" + dw["id"].ToString();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), s, " window.open('ShowAttachedfile.aspx?fileurl=" + dw["filename"].ToString() + "&saveat=" + dw["saveat"].ToString() + "');", true);
                }
            }
        }
        catch (Exception ex)
        {
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
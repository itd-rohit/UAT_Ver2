using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Investigation_InvestigationRole : System.Web.UI.Page
{
    public string InvID = " ";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (string.IsNullOrEmpty(Request.QueryString["InvID"]))
            {
                InvID = Request.QueryString["InvID"];

                return;
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch1", "document.getElementById('masterheaderid').style.display='none';", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch12", "document.getElementById('mastertopcorner').style.display='none';", true);

//            Menu aa = (Menu)this.Master.FindControl("mnuHIS");
          //  aa.Visible = false;
            LoadRole();
        }
    }

    private void LoadRole()
    {
        MySqlConnection con =Util.GetMySqlCon();
        con.Open();
        try
        {
            lblInvName.Text = MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select name from investigation_master where investigation_ID=@InvID", new MySqlParameter("@InvID",Request.QueryString["InvID"])).ToString();
            lblInvName.Visible = true;

            string str = " SELECT frm.id,frm.rolename,IF((SELECT roleid FROM f_investigation_role WHERE investigation_ID=@InvID AND frm.id=Roleid) IS NULL ,'false','true')Chk " +
            "   FROM f_rolemaster frm  WHERE frm.active=1   ";
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str, new MySqlParameter("@InvID", Request.QueryString["InvID"])).Tables[0];
            chkRole.DataSource = dt;
            chkRole.DataTextField = "RoleName";
            chkRole.DataValueField = "ID";
            chkRole.DataBind();

            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    foreach (ListItem li in chkRole.Items)
                    {
                        if (dr["id"].ToString() == li.Value)
                        {
                            li.Selected = Util.GetBoolean(dr["Chk"]);
                            break;
                        }
                    }
                }
            }
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

    protected void BtnSave_Click(object sender, EventArgs e)
    {
        string InvList = AllLoad_Data.GetSelection(chkRole);

        if (InvList == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Kindly Select a Investigation...');", true);
            return;
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE FROM f_investigation_role WHERE investigation_ID=@ID", new MySqlParameter("@ID", Request.QueryString["InvID"]));
            foreach (ListItem li in chkRole.Items)
            {
                if (li.Selected)
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "call Map_Investigation_Role('" + Request.QueryString["InvID"] + "','" + lblInvName.Text + "','" + li.Value + "','" + li.Text + "')");
                }
            }

            tranX.Commit();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved Successfully');", true);
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}
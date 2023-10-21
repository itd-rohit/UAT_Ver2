using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;
using System.Web.UI;
public partial class Design_EDP_FileManager : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int uid = UserInfo.ID;
            if (uid != 1)
            {
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "displayalertmessage", "alert('This Menu is for Itdose Team Only');", true);
                btnFile.Style["visibility"] = "hidden";
                btnFile.Style["visibility"] = "hidden";
                btnNewFile.Style["visibility"] = "hidden";
                btnNewFile.Style["visibility"] = "hidden";
            }
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                BindMenu(con);
                FileMaster(con);
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

    private void BindMenu(MySqlConnection con)
    {
        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select ID,MenuName from f_menumaster where Active=1 order by MenuName").Tables[0])
        {
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlMenu.DataSource = dt;
                ddlMenu.DataTextField = "MenuName";
                ddlMenu.DataValueField = "ID";
                ddlMenu.DataBind();
                ddlMenu.Items.Insert(0, new ListItem("No Menu", "0"));

                ddlNfile.DataSource = dt;
                ddlNfile.DataTextField = "MenuName";
                ddlNfile.DataValueField = "ID";
                ddlNfile.DataBind();
                ddlNfile.Items.Insert(0, new ListItem("Select", "0"));
            }
        }
    }

    private void FileMaster(MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        if (ddlMenu.SelectedValue == "0")
        {
            sb.Append(" select FM.ID,FM.DispName,FM.Description,MM.MenuName from f_filemaster  FM ");
            sb.Append(" left join f_menumaster MM on FM.MenuID=MM.ID where FM.active=1 and FM.menuid =0 ");
        }
        else
        {
            sb.Append(" select FM.ID,FM.DispName,FM.Description,MM.MenuName from f_filemaster  FM ");
            sb.Append(" left join f_menumaster MM on FM.MenuID=MM.ID where FM.active=1 and FM.menuid =@menuid");
        }
        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@menuid", ddlMenu.SelectedValue)).Tables[0])
        {
            if (dt != null && dt.Rows.Count > 0)
            {
                grdFile.DataSource = dt;
                grdFile.DataBind();
                ViewState.Add("File", dt);
            }
            else
            {
                grdFile.DataSource = null;
                grdFile.DataBind();
            }
            if (dt.Rows.Count > 0)
            {
                btnSaveFileOrder.Visible = true;
            }
            else
            {
                btnSaveFileOrder.Visible = false;
            }
        }
    }
    protected void btnSaveManuPriority_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            foreach (GridViewRow gr in grdFile.Rows)
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE `f_filemaster` SET `Priority`=@Priority where ID=@ID",
                    new MySqlParameter("@Priority", ((TextBox)gr.FindControl("txtOrder")).Text),
                    new MySqlParameter("@ID", ((Label)gr.FindControl("lblID")).Text));


            }

            using (DataTable dtRole = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT id,RoleName FROM `f_rolemaster` WHERE active=1 ").Tables[0])
            {

                foreach (DataRow dr in dtRole.Rows)
                {
                    StockReports.GenerateMenuData(dr["RoleName"].ToString());

                }
            }
            FileMaster(con);

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Success','Record Update Successfully');", true);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Error','Error');", true);

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    protected void grdFile_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AEdit")
        {
            int Index = Util.GetInt(e.CommandArgument);
            int FileId = Util.GetInt((((Label)grdFile.Rows[Index].FindControl("lblID")).Text));
            DataTable dt = new DataTable();
            if (ViewState["File"] != null)
            {
                dt = (DataTable)ViewState["File"];
            }
            DataRow[] dr = dt.Select(string.Format("ID='{0}'", FileId));
            if (dr.Length > 0)
            {
                txtDesc.Text = Util.GetString(dr[0]["Description"]);
                lblFileName.Text = Util.GetString(dr[0]["DispName"]);
                lblFileId.Text = Util.GetString(dr[0]["ID"]);
            }
            BindMenu1();
            mpeCreateGroup.Show();
        }
    }

    private void BindMenu1()
    {
        using (DataTable dt = StockReports.GetDataTable("select ID,MenuName from f_menumaster where Active=1 order by MenuName"))
        {
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlMenu1.DataSource = dt;
                ddlMenu1.DataTextField = "MenuName";
                ddlMenu1.DataValueField = "ID";
                ddlMenu1.DataBind();
            }
        }
    }

    protected void btnFile_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            FileMaster(con);
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

    protected void btnSave_Click(object sender, EventArgs e)
    {
        int Active = 0;
        if (rdbActive.Checked == true)
        {
            Active = 1;
        }
        else
        {
            Active = 0;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {


            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update f_filemaster set Description=@Description,MenuID=@MenuID,Active=@Active where ID=@ID",
                new MySqlParameter("@Description", txtDesc.Text.Trim()),
                new MySqlParameter("@MenuID", ddlMenu1.SelectedValue),
                new MySqlParameter("@Active", Active),
                new MySqlParameter("@ID", lblFileId.Text));


            txtDesc.Text = string.Empty;
            FileMaster(con);

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Success','Record Update Successfully');", true);

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Error','Error');", true);

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSaveMnu_Click(object sender, EventArgs e)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM f_menumaster WHERE MenuName=@MenuName",
               new MySqlParameter("@MenuName", txtNMenu.Text.Trim())));
            if (count > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Error','Menu Name Already Exits');", true);
                return;
            }
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO f_menumaster(MenuName,CreatedByID,CreatedBy) values(@MenuName,@CreatedByID,@CreatedBy)",
                new MySqlParameter("@MenuName", txtNMenu.Text.Trim()),
                new MySqlParameter("@CreatedByID", UserInfo.ID),
                new MySqlParameter("@CreatedBy", UserInfo.LoginName));
            BindMenu(con);
            txtNMenu.Text = string.Empty;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Success','Record Saved Successfully');", true);

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Error','Error');", true);

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void btnFileSave_Click(object sender, EventArgs e)
    {
        if (ddlNfile.SelectedValue == "0")
        {
            lblMsg.Text = "Please Select Menu";
            ddlNfile.Focus();
            return;
        }
        if (txtdispName.Text.Trim() == string.Empty)
        {
            lblMsg.Text = "Please Enter File Name";
            txtdispName.Focus();
            return;
        }
        if (txtNfile.Text.Trim() == string.Empty)
        {
            lblMsg.Text = "Please Enter URL";
            txtNfile.Focus();
            return;
        }
        if (txtFDesc.Text.Trim() == string.Empty)
        {
            lblMsg.Text = "Please Enter Description";
            txtFDesc.Focus();
            return;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

           int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM f_filemaster WHERE URLName=LOWER(@URLName) AND MenuID=@MenuID",
                new MySqlParameter("@URLName", txtNfile.Text.Trim().ToLower()),
                new MySqlParameter("@MenuID", ddlNfile.SelectedValue)));
            if (count > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Error','Page Already Registered');", true);

            }
            else
            {

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO f_filemaster(URLName,DispName,MenuID,Description,CreatedByID,CreatedBy) values(@URLName,@DispName,@MenuID,@Description,@CreatedByID,@CreatedBy)",
                new MySqlParameter("@URLName", txtNfile.Text.Trim()),
                new MySqlParameter("@DispName", txtdispName.Text.Trim()),
                new MySqlParameter("@MenuID", ddlNfile.SelectedValue),
                new MySqlParameter("@Description", txtFDesc.Text.Trim()),
                new MySqlParameter("@CreatedByID", UserInfo.ID),
                new MySqlParameter("@CreatedBy", UserInfo.LoginName));
            	ddlNfile.SelectedIndex = 0;
            	txtDesc.Text = string.Empty;
                txtNfile.Text = string.Empty;
                txtdispName.Text = string.Empty;
                txtFDesc.Text = string.Empty;
               ScriptManager.RegisterStartupScript(this, this.GetType(), "key111", "toast('Success','Record Saved Successfully');", true);
            }                        
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Error','Error');", true);

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_ManageRole : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Util.GetString(HttpContext.Current.Session["RoleID"]) != "6")
            {
                Response.Redirect("~/Design/Welcome.aspx");
            }
            else
            {
                txtRoleName.Focus();
                btnUpdate.Visible = false;
                BindGrid("");
            }
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {

        int active = chkActive.Checked ? 1 : 0;
        string RoleName = txtRoleName.Text.ToUpper();
        string HexaColor = txtcolor.Text;
        string ext = Path.GetExtension(this.FileUpload1.PostedFile.FileName);
        string fileName = RoleName + ext;
        string ImagePath = "/App_Images/RoleDesign/" + fileName;
        string saveDirectory = "~/App_Images/RoleDesign/";
        string fileSavePath = Path.Combine(saveDirectory, fileName);

        if (ext == ".png" || ext == ".PNG")
        {
            FileUpload1.PostedFile.SaveAs(Server.MapPath(fileSavePath));

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO `f_rolemaster` (RoleName,Active,Image,background) VALUES ");
                sb.Append(" ( '" + RoleName + "','" + active + "','" + ImagePath + "','" + HexaColor + "'); ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                tnx.Commit();

                lblMsg.Text = "Record Saved..!";
                BindGrid("");

                txtRoleName.Text = "";
                txtcolor.Text = "";
            }
            catch (Exception ex)
            {
                tnx.Rollback();

                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                lblMsg.Text = ex.InnerException.Message.ToString();
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Only PNG Image is allowed!!!";
        }

    }

    private void BindGrid(string roleName)
    {
        string query = " SELECT ID,RoleName,IF(Active=1,'YES','NO') IsActive,Background,CONCAT('../..',Image)Image FROM `f_rolemaster`   ";
        if (roleName != "")
        {
            query += " WHERE RoleName LIKE '%" + roleName + "%' ";
        }
        query += " order by RoleName";
        DataTable dt = StockReports.GetDataTable(query);
        GridView1.DataSource = dt;
        GridView1.DataBind();
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        string status = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label3")).Text;
        string ID = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label1")).Text;
        if (status == "YES")
        {
            StockReports.ExecuteDML("update  f_rolemaster set Active='0' where ID='" + ID + "' ");
        }
        else
        {
            StockReports.ExecuteDML("update  f_rolemaster set Active='1' where ID='" + ID + "' ");
        }

        lblMsg.Text = "Record Updated..!";
        BindGrid("");
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string Active = ((Label)e.Row.FindControl("Label3")).Text;
            string RoleName = ((Label)e.Row.FindControl("Label1")).Text;
            LinkButton lb = (LinkButton)e.Row.FindControl("LinkButton2");
            if (Active == "YES")
            {
                lb.Text = "Deactive";
            }
            else
            {
                lb.Text = "Active";
            }
        }
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ID = ((Label)GridView1.SelectedRow.FindControl("Label1")).Text;
        string Status = ((Label)GridView1.SelectedRow.FindControl("Label3")).Text;
        txtRoleName.Text = ((Label)GridView1.SelectedRow.FindControl("Label2")).Text;
        txtcolor.Text = ((Label)GridView1.SelectedRow.FindControl("Label4")).Text;
        txtId.Text = ID;
        if (Status == "YES")
        {
            chkActive.Checked = true;
        }
        else
        {
            chkActive.Checked = false;
        }
        btnSave.Visible = false;
        btnUpdate.Visible = true;
    }

    protected void btnsearch_Click(object sender, EventArgs e)
    {
        BindGrid(txtsearch.Text);
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        int ID = Util.GetInt(txtId.Text);
        int active = chkActive.Checked ? 1 : 0;
        string RoleName = txtRoleName.Text.ToUpper();
        string HexaColor = txtcolor.Text;
        string ext = Path.GetExtension(this.FileUpload1.PostedFile.FileName);
        string fileName = RoleName + ext;
        string ImagePath = "/App_Images/RoleDesign/" + fileName;
        string saveDirectory = "~/App_Images/RoleDesign/";
        string fileSavePath = Path.Combine(saveDirectory, fileName);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        if (FileUpload1.HasFile)
        {
            if (ext == ".png" || ext == ".PNG")
            {
                FileUpload1.PostedFile.SaveAs(Server.MapPath(fileSavePath));

                try
                {

                    StringBuilder sb = new StringBuilder();
                    sb.Append(" UPDATE f_rolemaster SET RoleName='" + RoleName + "',Active='" + active + "',Background='" + HexaColor + "',Image='" + ImagePath + "' WHERE ID='" + ID + "'; ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                    tnx.Commit();

                    lblMsg.Text = "Record Saved..!";
                    BindGrid("");

                    txtRoleName.Text = "";
                    txtcolor.Text = "";
                }
                catch (Exception ex)
                {
                    tnx.Rollback();

                    ClassLog objClassLog = new ClassLog();
                    objClassLog.errLog(ex);
                    lblMsg.Text = ex.InnerException.Message.ToString();
                }
                finally
                {
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }


            else
            {
                lblMsg.Visible = true;
                lblMsg.Text = "Only PNG Image is allowed!!!";
            }
        }
        else {
            try
            {

                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE f_rolemaster SET RoleName='" + RoleName + "',Active='" + active + "',Background='" + HexaColor + "' WHERE ID='" + ID + "'; ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                tnx.Commit();

                lblMsg.Text = "Record Saved..!";
                BindGrid("");

                txtRoleName.Text = "";
                txtcolor.Text = "";
            }
            catch (Exception ex)
            {
                tnx.Rollback();

                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                lblMsg.Text = ex.InnerException.Message.ToString();
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }

    }
}
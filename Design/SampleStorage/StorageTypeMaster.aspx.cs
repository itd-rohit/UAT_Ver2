using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_SampleStorage_StorageTypeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtdeptname.Focus();
            BindGrid("");
            btnUpdate.Visible = false;
        }
    }

    private void BindGrid(string testname)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            txtdeptname.Text = "";
            chkActive.Checked = true;
            sb.Append("SELECT id ID,StorageType NAME,IsActive, IF(IsActive=1,'Active','Deactive') STATUS,CreatedBy ,date_format(CreatedOn,'%d-%b-%y %h:%i %p') CreatedOn FROM ss_StorageTypeMaster  ");
            if (testname != "")
            {
                sb.Append(" where StorageType LIKE @testname ");
            }
            sb.Append(" order by StorageType");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@testname", string.Format("%{0}%", testname))).Tables[0])
            {
                GridView1.DataSource = dt;
                GridView1.DataBind();
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

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        string status = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label3")).Text;
        string ID = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label1")).Text;
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try {
            if (status == "1")
            {
                sb.Append("update  ss_StorageTypeMaster set isactive='0' where ID=@id ");
            }
            else
            {
                sb.Append("update  ss_StorageTypeMaster set isactive='1' where ID=@id ");
            }
           MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
           new MySqlParameter("@id", ID));
            lblMsg.Text = "Record Updated..!";
            BindGrid("");
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

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string status = ((Label)e.Row.FindControl("Label3")).Text;
            string Name = ((Label)e.Row.FindControl("Label2")).Text;
            LinkButton lb = (LinkButton)e.Row.FindControl("LinkButton2");
            if (lb != null)
            {
                lb.Attributes.Add("onclick", "return ConfirmOnDelete('" + Name + "','" + status + "');");
            }

            if (status == "1")
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
        string Name = ((Label)GridView1.SelectedRow.FindControl("Label2")).Text;
        string Status = ((Label)GridView1.SelectedRow.FindControl("Label3")).Text;

        txtdeptname.Text = Name;

        txtId.Text = ID;
        if (Status == "1")
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

    protected void btnSave_Click(object sender, EventArgs e)
    {
        int st = chkActive.Checked ? 1 : 0;
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try {
            sb.Append("insert into ss_StorageTypeMaster (StorageType,IsActive, CreatedByID, CreatedBy, CreatedOn)");
            sb.Append(" values (@txtdeptname,@st,@ID,@LoginName,NOW())");
             MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@txtdeptname",  txtdeptname.Text.ToUpper().ToString()),
               new MySqlParameter("@st",st),
               new MySqlParameter("@ID",  UserInfo.ID),
               new MySqlParameter("@LoginName",  UserInfo.LoginName.ToString())
               );
               
            lblMsg.Text = "Record Saved";
            BindGrid("");
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

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        string id = txtId.Text;
        int st = chkActive.Checked ? 1 : 0;
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append("update ss_StorageTypeMaster set StorageType=@StorageType ");
            sb.Append(",IsActive=@st,UpdatedOn=NOW(),UpdatedByID=@UpdatedByID,UpdatedBy=@UpdatedBy ");
            sb.Append(" where id=@id");

            
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
           
           new MySqlParameter("@StorageType", txtdeptname.Text.ToUpper()),
           new MySqlParameter("@st", st),
           new MySqlParameter("@UpdatedByID", UserInfo.ID),
           new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
           new MySqlParameter("@id",id)
           );
            lblMsg.Text = "Record Updated";
            btnUpdate.Visible = false;
            btnSave.Visible = true;

            txtId.Text = "";
            BindGrid("");
            txtdeptname.Focus();
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
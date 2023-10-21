using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_Investigation_DepartmentMaster : System.Web.UI.Page
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
        txtdeptname.Text = "";
        txtdisplayname.Text = "";
        txtline1.Text = "";
        txtline2.Text = "";
        ddldescription.SelectedIndex = 0;
        chkActive.Checked = true;
        string query = "SELECT SubCategoryID ID, deptinterpretaion,NAME,Description,displayname,active, IF(active=1,'Active','Deactive') STATUS,reportline1,reportline2 FROM f_subcategorymaster where CategoryID='LSHHI3' ";
        if (testname != "")
        {
            query += " and name like '%" + testname + "%' ";
        }
        query += " order by name";
        DataTable dt = StockReports.GetDataTable(query);
        GridView1.DataSource = dt;
        GridView1.DataBind();
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        string status = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label3")).Text;
        string ID = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label1")).Text;
        if (status == "1")
        {
            StockReports.ExecuteDML("update  f_subcategorymaster set Active='0' where SubCategoryID='" + ID + "' ");
            StockReports.ExecuteDML("update  observationtype_master set isActive='0' where Description='" + ID + "' ");
        }
        else
        {
            StockReports.ExecuteDML("update  f_subcategorymaster set Active='1' where SubCategoryID='" + ID + "' ");
            StockReports.ExecuteDML("update  observationtype_master set isActive='0' where Description='" + ID + "' ");
        }

        lblMsg.Text = "Record Updated..!";
        BindGrid("");
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string status = ((Label)e.Row.FindControl("Label3")).Text;
            string Name = ((Label)e.Row.FindControl("Label2")).Text;
            string line1 = ((Label)e.Row.FindControl("Label6")).Text;
            string line2 = ((Label)e.Row.FindControl("Label7")).Text;
            LinkButton lb = (LinkButton)e.Row.FindControl("LinkButton2");
            //if (lb != null)
            //{
            //    lb.Attributes.Add("onclick", "return ConfirmOnDelete('" + Name + "','" + status + "');");
            //}

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
        string line1 = ((Label)GridView1.SelectedRow.FindControl("Label6")).Text;
        string line2 = ((Label)GridView1.SelectedRow.FindControl("Label7")).Text;
        txtdeptname.Text = Name;
        txtdisplayname.Text = ((Label)GridView1.SelectedRow.FindControl("Label4")).Text;
        txtbokkingremarks.Text = ((Label)GridView1.SelectedRow.FindControl("Label11")).Text;
        ddldescription.SelectedIndex = ddldescription.Items.IndexOf(ddldescription.Items.FindByText(((Label)GridView1.SelectedRow.FindControl("Label5")).Text));
        txtline1.Text = line1;
        txtline2.Text = line2;
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
        
        string Description = ddldescription.SelectedValue;
        int st = chkActive.Checked ? 1 : 0;
        if (Description == "SELF")
        {
            Description = txtdeptname.Text;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
int id = Util.GetInt(MySqlHelper.ExecuteScalar(tnx,CommandType.Text, "SELECT max(id) from f_subcategorymaster")) + 1;
            StringBuilder sb = new StringBuilder();
            sb.Append("insert into f_subcategorymaster (CategoryID,Location, Hospcode, ID, SubCategoryID, NAME, Description, DisplayName, DisplayPriority, Active,  entryby, entrydate,deptinterpretaion,ReportLine1,ReportLine2)");
            sb.Append(" values ('LSHHI3','L','SHHI','" + id + "','" + id + "','" + txtdeptname.Text.ToUpper() + "','" + Description.ToUpper() + "','" + txtdisplayname.Text.ToUpper() + "','0',");
            sb.Append(" " + st + ",'" + Util.GetString(Session["ID"]) + "',now(),'" + txtbokkingremarks.Text + "','" + txtline1.Text + "','" + txtline2.Text + "')");
            sb.Append("");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.Append("INSERT INTO observationtype_master (Location,Hospcode,ID,ObservationType_ID,NAME,Description,Creator_ID,Flag,isVisible,isActive,Print_Sequence) ");
            sb.Append("VALUES ('L','SHHI','" + id + "','" + id + "','" + txtdeptname.Text + "','" + id + "','" + Util.GetString(Session["ID"]) + "',");
            sb.Append(" '1','1'," + st + ",0)");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            tnx.Commit();

            lblMsg.Text = "Record Saved..!";
            BindGrid("");
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

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        string id = txtId.Text;
        string Description = ddldescription.SelectedValue;
        int st = chkActive.Checked ? 1 : 0;
        if (Description == "SELF")
        {
            Description = txtdeptname.Text;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("update f_subcategorymaster set NAME='" + txtdeptname.Text.ToUpper() + "', Description='" + Description.ToUpper() + "' ");
            sb.Append(" , DisplayName='" + txtdisplayname.Text.ToUpper() + "' ,active='" + st + "',updatedate=now(),updateby='" + Util.GetString(Session["ID"]) + "',deptinterpretaion='"+txtbokkingremarks.Text+"' ");
            sb.Append(" ,ReportLine1='" + txtline1.Text + "',ReportLine2='" + txtline2.Text + "'");
            sb.Append(" where SubCategoryID='" + id + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            sb = new StringBuilder();

            sb.Append("update observationtype_master set NAME='" + txtdeptname.Text.ToUpper() + "', ");
            sb.Append("  isActive='" + st + "',UpdateDate=now() ");

            sb.Append(" where Description='" + id + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            tnx.Commit();

            lblMsg.Text = "Record Updated..!";
            btnUpdate.Visible = false;
            btnSave.Visible = true;

            txtId.Text = "";
            BindGrid("");
            txtdeptname.Focus();
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
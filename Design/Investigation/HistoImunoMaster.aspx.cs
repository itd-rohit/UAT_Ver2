using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class Design_Investigation_HistoImunoMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtAntibiotic.Focus();
            BindGrid("");
            btnUpdate.Visible = false;
        }

    }

    private void BindGrid(string testname)
    {
        txtAntibiotic.Text = "";
        chkActive.Checked = true;
        string query = "SELECT ID `SpecimenID`,Name `SpecimenName`,`IsActive`,if(isactive='1','Active','Deactive') status FROM `histoimmuno_master` ";
        if (testname != "")
        {
            query += " where Name like '%" + testname + "%' ";
        }
        query += " order by Name";
        DataTable dt = StockReports.GetDataTable(query);
        GridView1.DataSource = dt;
        GridView1.DataBind();

    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ID = ((Label)GridView1.SelectedRow.FindControl("Label1")).Text;
        string Name = ((Label)GridView1.SelectedRow.FindControl("Label2")).Text;
        string Status = ((Label)GridView1.SelectedRow.FindControl("Label3")).Text;

        txtAntibiotic.Text = Name;
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

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtAntibiotic.Text == "")
        {
            lblMsg.Text = "Please Enter Antibiotic Name";
            return;
        }
        bool dt;
        string IsActive = "0";
        if (chkActive.Checked == true)
        {
            IsActive = "1";
        }
        StringBuilder sb = new StringBuilder();

        string s = StockReports.ExecuteScalar("select max(ID) from histoimmuno_master");
        int id = Util.GetInt(s) + 1;
        sb.Append("INSERT  INTO histoimmuno_master(ID,Name,IsActive,CreatedByUserID,CreateDateTime) VALUES (" + id + ",'" + txtAntibiotic.Text + "','" + IsActive + "','" + HttpContext.Current.Session["ID"].ToString() + "',now())");
        dt = StockReports.ExecuteDML(sb.ToString());
        if (dt == true)
        {
            lblMsg.Text = "Record Saved..!";
            BindGrid("");
        }
    }
    protected void Unnamed_Click(object sender, EventArgs e)
    {
        if (txtAntibiotic.Text == "")
        {
            lblMsg.Text = "Please Enter Antibiotic Name";
            return;
        }
        bool dt;
        string IsActive = "0";
        if (chkActive.Checked == true)
        {
            IsActive = "1";
        }
        StringBuilder sb = new StringBuilder();


        sb.Append("update histoimmuno_master set Name='" + txtAntibiotic.Text + "',IsActive='" + IsActive + "',UpdateDateTime=now(),UpdateUserID='"+Session["ID"].ToString()+"' where ID='" + txtId.Text + "'");
        dt = StockReports.ExecuteDML(sb.ToString());
        if (dt == true)
        {
            lblMsg.Text = "Record Updated..!";
            BindGrid("");
        }
    }
    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        string status = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label3")).Text;
        string ID = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label1")).Text;
        if (status == "1")
        {
            StockReports.ExecuteDML("update  histoimmuno_master set IsActive='0' where ID='" + ID + "' ");
        }
        else
        {
            StockReports.ExecuteDML("update  histoimmuno_master set IsActive='1' where ID='" + ID + "' ");
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
    protected void txtsearch_TextChanged(object sender, EventArgs e)
    {

    }
    protected void btnsearch_Click(object sender, EventArgs e)
    {
        BindGrid(txtsearch.Text);
    }
}
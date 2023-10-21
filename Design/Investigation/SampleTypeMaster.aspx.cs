using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_Investigation_SampleTypeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtdeptname.Focus();
            BindGrid("");
            btnUpdate.Visible = false;
            bindContainerColor();
        }
    }
    private void bindContainerColor()
    {
        DataTable dt = StockReports.GetDataTable("Select ColorCode,ColorName from colormaster order by ColorName");
        ddlContainerColor.DataSource = dt;
        ddlContainerColor.DataTextField = "ColorName";
        ddlContainerColor.DataValueField = "ColorCode";
        ddlContainerColor.DataBind();
    }
    private void BindGrid(string testname)
    {
        txtdeptname.Text = "";
        chkActive.Checked = true;
        txtContainerName.Text = "";
        ddlContainerColor.SelectedIndex = 0;

        string query = "SELECT id ID,SampleName NAME,IsActive, IF(IsActive=1,'Active','Deactive') STATUS,Container,UPPER(ColorName)ColorName,UPPER(Color)Color FROM sampletype_master  ";
        if (testname != "")
        {
            query += " where SampleName like '%" + testname + "%' ";
        }
        query += " order by SampleName";
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
            StockReports.ExecuteDML("update  sampletype_master set isactive='0' where ID='" + ID + "' ");
        }
        else
        {
            StockReports.ExecuteDML("update  sampletype_master set isactive='1' where ID='" + ID + "' ");
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

        txtdeptname.Text = Name;

        txtId.Text = ID;
        txtContainerName.Text = ((Label)GridView1.SelectedRow.FindControl("lblContainer")).Text;
        try
        {
            ddlContainerColor.SelectedValue = ((Label)GridView1.SelectedRow.FindControl("lblColor")).Text.ToUpper();
        }
        catch
        {
            ddlContainerColor.Items.Insert(0, new ListItem(((Label)GridView1.SelectedRow.FindControl("lblColorName")).Text, ((Label)GridView1.SelectedRow.FindControl("lblColor")).Text.ToUpper()));
            ddlContainerColor.SelectedValue = ((Label)GridView1.SelectedRow.FindControl("lblColor")).Text.ToUpper();
        }
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
        sb.Append("insert into sampletype_master (SampleName,IsActive, CreatedByID, CreatedBy, CreatedOn,Container,ColorName,Color)");
        sb.Append(" values ('" + txtdeptname.Text.ToUpper() + "','" + st + "','" + Util.GetString(Session["ID"]) + "','" + Util.GetString(Session["LoginName"]) + "',now(),'"+txtContainerName.Text+"','"+ddlContainerColor.SelectedItem+"','"+ddlContainerColor.SelectedValue+"')");
        StockReports.ExecuteDML(sb.ToString());

        lblMsg.Text = "Record Saved";
        BindGrid("");
        return;
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        string id = txtId.Text;

        int st = chkActive.Checked ? 1 : 0;

        StringBuilder sb = new StringBuilder();
        sb.Append("update sampletype_master set SampleName='" + txtdeptname.Text.ToUpper() + "' ");
        sb.Append(" ,Container='"+txtContainerName.Text+"',ColorName='"+ddlContainerColor.SelectedItem+"',Color='"+ddlContainerColor.SelectedValue+"'  ");
        sb.Append(",IsActive='" + st + "',UpdatedOn=now(),UpdatedByID='" + Util.GetString(Session["ID"]) + "',UpdatedBy='" + Util.GetString(Session["LoginName"]) + "' ");

        sb.Append(" where id='" + id + "'");

        StockReports.ExecuteDML(sb.ToString());

        lblMsg.Text = "Record Updated";
        btnUpdate.Visible = false;
        btnSave.Visible = true;

        txtId.Text = "";
        BindGrid("");
        txtdeptname.Focus();
    }
}
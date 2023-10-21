using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_Investigation_SampleContainerMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtdeptname.Focus();
            BindGrid("");
            btnUpdate.Visible = false;
            Bindcolors();
        }
    }

    private void Bindcolors()
    {
        DataTable dt = StockReports.GetDataTable("Select ColorName,ColorCode from ColorMaster");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlcolor.DataSource = dt;
            ddlcolor.DataTextField = "ColorName";
            ddlcolor.DataValueField = "ColorName";
            ddlcolor.DataBind();
        }
    }

    private void BindGrid(string testname)
    {
        txtdeptname.Text = "";

        string query = "SELECT id ID,containername NAME,color,qty,concat(qty,' ml.')myqt FROM samplecontainer_master  ";
        if (testname != "")
        {
            query += " where containername like '%" + testname + "%' ";
        }
        query += " order by containername";
        DataTable dt = StockReports.GetDataTable(query);
        GridView1.DataSource = dt;
        GridView1.DataBind();
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ID = ((Label)GridView1.SelectedRow.FindControl("Label1")).Text;
        string Name = ((Label)GridView1.SelectedRow.FindControl("Label2")).Text;
        string color = ((Label)GridView1.SelectedRow.FindControl("Label3")).Text;
        string qty = ((Label)GridView1.SelectedRow.FindControl("label4")).Text;
        ddlcolor.SelectedIndex = ddlcolor.Items.IndexOf(ddlcolor.Items.FindByText(color));
        txtdeptname.Text = Name;
        txtqty.Text = qty;
        txtId.Text = ID;
        btnSave.Visible = false;
        btnUpdate.Visible = true;
    }

    protected void btnsearch_Click(object sender, EventArgs e)
    {
        BindGrid(txtsearch.Text);
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("insert into samplecontainer_master (containername,color,qty, CreatedByID, CreatedBy, CreatedOn)");
        sb.Append(" values ('" + txtdeptname.Text.ToUpper() + "','" + ddlcolor.SelectedValue + "','" + txtqty.Text + "','" + Util.GetString(Session["ID"]) + "','" + Util.GetString(Session["LoginName"]) + "',now())");
        StockReports.ExecuteDML(sb.ToString());
        lblMsg.Text = "Record Saved..!";
        BindGrid("");
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        string id = txtId.Text;

        StringBuilder sb = new StringBuilder();
        sb.Append("update samplecontainer_master set containername='" + txtdeptname.Text.ToUpper() + "' ");
        sb.Append(",color='" + ddlcolor.SelectedValue + "',qty='" + txtqty.Text + "',UpdatedOn=now(),UpdatedByID='" + Util.GetString(Session["ID"]) + "',UpdatedBy='" + Util.GetString(Session["LoginName"]) + "' ");

        sb.Append(" where id='" + id + "'");

        StockReports.ExecuteDML(sb.ToString());

        lblMsg.Text = "Record Updated..!";
        btnUpdate.Visible = false;
        btnSave.Visible = true;

        txtId.Text = "";
        BindGrid("");
        txtdeptname.Focus();
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_Machine_MachineGroup : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindMachine();
        }
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (txtName.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter the Machine Name";
            return;
        }
        if (txtID.Value !="")
        {
            lblMsg.Text = "Record Upated...";
            StockReports.ExecuteDML("update macmaster set Name ='" + txtName.Text.Trim() + "' where ID="+ txtID.Value +"");
        }
        else
        {
            string id = "SELECT MAX(id) FROM macmaster";
            DataTable dt = StockReports.GetDataTable(id);
            string ll = dt.Rows[0][0].ToString();
            string l1 =   (int.Parse(ll)+1).ToString() ;
            StockReports.ExecuteDML("insert into macmaster(Name,ReferRangeMacId) value('" + txtName.Text.Trim() + "'," + l1 + ")");
            lblMsg.Text = "Record Saved...";
            l1 = "";
        }
       
        txtID.Value = "";
        txtName.Text = "";
        
    }
    private void bindMachine()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ID,Name from macmaster");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        GridView1.DataSource = dt;
        GridView1.DataBind();

    }
    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        bindMachine();
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ID = ((Label)GridView1.SelectedRow.FindControl("ID")).Text;
        string str = "SELECT ID,Name FROM MacMaster where ID='" + ID + "'";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            txtName.Text = dt.Rows[0]["Name"].ToString();
            txtID.Value=dt.Rows[0]["ID"].ToString();
            btnsave.Text = "Update";

        }


    }
}
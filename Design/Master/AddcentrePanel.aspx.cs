using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_Master_AddcentrePanel : System.Web.UI.Page
{
    private string centreid = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        centreid = Request.QueryString["centreid"].ToString();
        if (!IsPostBack)
        {
            lb.Text = StockReports.ExecuteScalar("select centre from centre_master where centreid='" + centreid + "'");
            lbheder.Text = "Add Panel In " + lb.Text;
            bindpanel();
        }
    }

    private void bindpanel()
    {
        DataTable dt = StockReports.GetDataTable(@" SELECT panel_id,company_name FROM f_panel_master where IsActive=1  ORDER BY company_name ");

        grd.DataSource = dt;
        grd.DataBind();
        ViewState["mydt"] = dt;
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        foreach (GridViewRow grdrow in grd.Rows)
        {
            CheckBox ck = (CheckBox)grdrow.FindControl("chk");
            string mapid = ((Label)grdrow.FindControl("Label2")).Text;
            if (ck.Checked)
            {
                string del = "DELETE FROM centre_panel WHERE PanelId='" + mapid + "' AND CentreId='" + centreid + "'";
                StockReports.ExecuteDML(del);
                StockReports.ExecuteDML("insert into centre_panel (CentreId,PanelId) values('" + centreid + "','" + mapid + "')");
            }
        }

        lblMsg.Text = "Panel Added Sucessfully..!";
    }

    protected void btnsearch_Click(object sender, EventArgs e)
    {
        TextBox tx = (TextBox)grd.HeaderRow.FindControl("txtearch");
        DataTable dt = (ViewState["mydt"] as DataTable);
        dt.DefaultView.RowFilter = string.Format("[company_name] LIKE '%{0}%'", tx.Text.Trim());
        grd.DataSource = dt;
        grd.DataBind();
    }

    protected void grd_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            CheckBox ck = (CheckBox)e.Row.FindControl("chk");
            string mapid = ((Label)e.Row.FindControl("Label2")).Text;

            string cc = StockReports.ExecuteScalar("select count(*) from centre_panel where centreid='" + centreid + "' and panelid='" + mapid + "'");
            if (cc == "1")
            {
                ck.Checked = true;
            }
            else
            {
                ck.Checked = false;
            }
        }
    }
}
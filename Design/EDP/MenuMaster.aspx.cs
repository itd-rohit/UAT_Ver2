using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_MenuMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {

            bindMenu();
        }
    }

    private void bindMenu()
    {
        DataTable dt = StockReports.GetDataTable("SELECT id,menuname FROM `f_menumaster` WHERE active=1 ORDER BY priority");
        grdItemDetails.DataSource = dt;
        grdItemDetails.DataBind();
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        foreach (GridViewRow gr in grdItemDetails.Rows)
        {
            StockReports.ExecuteDML("update f_menumaster set priority='" + ((TextBox)gr.FindControl("txtOrder")).Text + "' where id=" + ((Label)gr.FindControl("lblID")).Text + "");
        }

        DataTable dtRole = StockReports.GetDataTable("SELECT id,RoleName FROM `f_rolemaster` WHERE active=1 ");

        foreach (DataRow dr in dtRole.Rows)
        {
            StockReports.GenerateMenuData(dr["RoleName"].ToString());
           
        }


        bindMenu();

        lblMsg.Text = "Menu Updated Successfully";
    }
}
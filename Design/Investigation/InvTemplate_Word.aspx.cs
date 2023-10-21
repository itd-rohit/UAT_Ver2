using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Design_PACS_InvTemplate_Word : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (!IsPostBack)
        {
            BindInvestigation();            
        }
    }

    private void BindInvestigation()
    {
        
        string str = "SELECT im.Investigation_Id,im.Name FROM investigation_master im WHERE ReportType=5 ORDER BY im.Name";
        
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlInvestigation.DataSource = dt;
            ddlInvestigation.DataTextField = "Name";
            ddlInvestigation.DataValueField = "Investigation_Id";
            ddlInvestigation.DataBind();
            ddlInvestigation.Items.Insert(0, new ListItem("", ""));
            ddlInvestigation.SelectedIndex = 0;
        }
        else
        {
            ddlInvestigation.Items.Clear();
        }

   

    }

}
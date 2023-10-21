using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Investigation_BreakPoint : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindgroup();
        }
    }

    void bindgroup()
    {
        ddlmastertype.DataSource = StockReports.GetDataTable("SELECT id,NAME FROM micro_master WHERE isactive=1 AND typeid=2 ORDER BY NAME ");
        ddlmastertype.DataTextField = "NAME";
        ddlmastertype.DataValueField = "id";
        ddlmastertype.DataBind();
        ddlmastertype.Items.Insert(0, new ListItem("Select","0"));

    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
public partial class Design_UserControl_PanelGroup : System.Web.UI.UserControl
{
    protected void Page_Init(object sender, EventArgs e)
    {


        using (DataTable dt = StockReports.GetDataTable("SELECT PanelGroupID ID,PanelGroup Type1 FROM f_PanelGroup WHERE Active=1 AND  PanelGroupID IN(2,3,4,6,7,8,9,10,11,2)  "))



        {
            if (dt.Rows.Count > 0)
            {
                rblSearchType.DataSource = dt;
                rblSearchType.DataTextField = "Type1";
                rblSearchType.DataValueField = "ID";
                rblSearchType.DataBind();
                rblSearchType.Items.Insert(0, new ListItem("All", "0"));
              rblSearchType.SelectedIndex = rblSearchType.Items.IndexOf(rblSearchType.Items.FindByValue("0"));
                //rblSearchType.SelectedIndex = rblSearchType.Items.IndexOf(rblSearchType.Items.FindByValue(dt.Rows[0]["ID"].ToString()));

            }
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
        }
    }
}
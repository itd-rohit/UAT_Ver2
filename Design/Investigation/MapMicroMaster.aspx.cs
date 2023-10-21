using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Investigation_MapMicroMaster : System.Web.UI.Page
{
    public string id = "";
    public string typeid = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        id = Util.GetString(Request.QueryString["id"]);
        typeid = Util.GetString(Request.QueryString["typeid"]);

        lbtext.Text = StockReports.ExecuteScalar("SELECT name FROM micro_master WHERE id='" + id + "'");
        lbname.Text = StockReports.ExecuteScalar("SELECT mastername FROM microtype_master WHERE id='" + typeid + "'");
        lblCode.Text = StockReports.ExecuteScalar("SELECT code FROM micro_master WHERE id='" + id + "'");
        bindradio();
       
    }
    void bindradio()
    {
        if (typeid == "2")
        {
            foreach (ListItem li in rdobservation.Items)
            {
                if (li.Value == "4")
                {
                    li.Attributes.Add("style", "display:none");
                }
               
            }
        }

        else if (typeid == "3")
        {
            foreach (ListItem li in rdobservation.Items)
            {
                if (li.Value == "4")
                {
                    li.Selected = true;
                }
                if (li.Value != "4")
                {
                    li.Attributes.Add("style", "display:none");
                }
            }
        }
       
    }
   
}
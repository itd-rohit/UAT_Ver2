using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Mobile_MachineResultEntry : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromTime.Value = "00:00:00";
            txtToTime.Value = "23:59:59";
            ListItem selectedListItem = ddlSampleStatus.Items.FindByText("Tested");

            if (selectedListItem != null)
            {
                selectedListItem.Selected = true;
            }

            if (Util.GetString(Request.QueryString["fromdate"]) != "")
            {
                txtFormDate.Text = Util.GetString(Request.QueryString["fromdate"]);
                txtToDate.Text = Util.GetString(Request.QueryString["todate"]);
                txtFromTime.Value = Util.GetString(Request.QueryString["fromtime"]);
                txtToTime.Value = Util.GetString(Request.QueryString["totime"]);
                CentreAccess.Value = Util.GetString(Request.QueryString["centre"]);
            }
        }

    }
}
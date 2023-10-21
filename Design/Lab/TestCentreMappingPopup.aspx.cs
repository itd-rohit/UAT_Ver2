using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class Design_Investigation_TestCentreMappingPopup : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DataTable dt = StockReports.GetDataTable("SELECT CentreID,Centre FROM `centre_master` WHERE isActive=1 ORDER BY isDefault DESC,Centre ASC");
            ddlCentre.DataSource = dt;
            ddlCentre.DataTextField = "Centre";
            ddlCentre.DataValueField = "CentreID";
            ddlCentre.DataBind();
            ddlCentre.Items.Insert(0, "Booking Centre");
            ddlTestCentre.DataSource = dt;
            ddlTestCentre.DataTextField = "Centre";
            ddlTestCentre.DataValueField = "CentreID";
            ddlTestCentre.DataBind();
            ddlTestCentre.Items.Insert(0,"Test Centre1");

            ddlTestCentre2.DataSource = dt;
            ddlTestCentre2.DataTextField = "Centre";
            ddlTestCentre2.DataValueField = "CentreID";
            ddlTestCentre2.DataBind();
            ddlTestCentre2.Items.Insert(0, "Test Centre2");

            ddlTestCentre3.DataSource = dt;
            ddlTestCentre3.DataTextField = "Centre";
            ddlTestCentre3.DataValueField = "CentreID";
            ddlTestCentre3.DataBind();
            ddlTestCentre3.Items.Insert(0, "Test Centre3");
        }
    }
    protected void txtSave_Click(object sender, EventArgs e)
    {
        if (ddlCentre.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select the Booking Centre";
            return;
        }
        if (ddlTestCentre.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select the Test Centre 1";
            return;
        }
        if (ddlTestCentre2.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select the Test Centre 2";
            return;
        }
        if (ddlTestCentre3.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select the Test Centre 3" ;
            return;
        }
        try
        {
            StockReports.ExecuteDML(" DELETE FROM test_centre_mapping WHERE Booking_Centre='" + ddlCentre.SelectedItem.Value + "';");
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO test_centre_mapping(Booking_Centre,Test_Centre,Test_Centre2,Test_Centre3,Investigation_ID,dtEntry,UserID,Username)");
            sb.Append(" SELECT '" + ddlCentre.SelectedItem.Value + "','" + ddlTestCentre.SelectedItem.Value + "','" + ddlTestCentre2.SelectedItem.Value + "','" + ddlTestCentre3.SelectedItem.Value + "',Investigation_ID,NOW(),'" + Util.GetString(Session["ID"]) + "','" + Util.GetString(Session["LoginName"]) + "' FROM investigation_master; ");
            StockReports.ExecuteDML(sb.ToString());
            lblMsg.Text = "Record Saved Successfully...";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Try Again Later...";
        }
    }
}
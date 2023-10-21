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
using MySql.Data.MySqlClient;
using System.Linq;
using System.Collections.Specialized;
using Newtonsoft.Json;

public partial class Design_OPD_HighVolumeReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {      
        if (!IsPostBack)
        {
            bindCenter();
            BindPanel();
            BindDepartment();
            AllLoad_Data.getCurrentDate(txtfromdate, txttodate);
            reportaccess();
            bindCenterTest();
        }
    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(29));
        if (response.status == true)
        {
            if (response.DurationInDay > 0)
            {
                DateTime date = Util.GetDateTime(txtfromdate.Text).AddDays(response.DurationInDay);
                if (date < DateTime.Now.Date)
                {
                    lblMsg.Text = "You are not authorized to view more than " + response.DurationInDay + " days data";
                    return false;
                }
            }
            if (response.ShowPdf == 1 && response.ShowExcel == 0)
            {
                rblReportformat.Items[0].Enabled = true;
                rblReportformat.Items[1].Enabled = false;
                rblReportformat.Items[0].Selected = true;
            }
            else if (response.ShowExcel == 1 && response.ShowPdf == 0)
            {
                rblReportformat.Items[1].Enabled = true;
                rblReportformat.Items[0].Enabled = false;
                rblReportformat.Items[1].Selected = true;
            }
            else if (response.ShowPdf == 0 && response.ShowExcel == 0)
            {
                rblReportformat.Visible = false;
                lblMsg.Text = "Report format not allowed contect to admin";
                return false;
            }
            //else
            //{
            //    rdoReportFormat.Items[0].Selected = true;
            //}
        }
        else
        {
            div1.Visible = false;
            div2.Visible = false;
            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }
    public void bindCenter()
    {
        using (DataTable dt = AllLoad_Data.loadCentre())
            chkCentre.DataSource = dt;
        chkCentre.DataTextField = "Centre";
        chkCentre.DataValueField = "CentreID";
        chkCentre.DataBind();
      //  chkCentre.Items[0].Selected = true;
    }
    public void bindCenterTest()
    {
        using (DataTable dt = AllLoad_Data.loadCentre())
            chCentresTest.DataSource = dt;
        chCentresTest.DataTextField = "Centre";
        chCentresTest.DataValueField = "CentreID";
        chCentresTest.DataBind();
        //  chkCentre.Items[0].Selected = true;
    }

    private void BindPanel()
    {
        using (DataTable dt = AllLoad_Data.loadPanel())
            ddlPanel.DataSource = dt;
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "Panel_id";
        ddlPanel.DataBind();
        ddlPanel.Items.Insert(0, "");
    }
    protected void BindDepartment()
    {
        using (DataTable dt = AllLoad_Data.getDepartment())        
        if (dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataValueField = "SubcategoryID";
            ddlDepartment.DataTextField = "NAME";

            ddlDepartment.DataBind();
            ListItem list = new ListItem("", "");
            ddlDepartment.Items.Insert(0, list);

        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string Centre = GetSelection(chkCentre);
        if (Centre == string.Empty)
            lblMsg.Text = "please select Booking Centre";
        string TestCentre = GetSelection(chCentresTest);
        if (TestCentre == string.Empty)
            lblMsg.Text = "please select Test Centre";
        try
        {
            NameValueCollection collections = new NameValueCollection();
            collections.Add("fromDate", string.Concat(Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd"), " 00:00:00"));
            collections.Add("toDate", string.Concat(Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd"), " 23:59:59"));
            collections.Add("CentreID", Centre);
            collections.Add("TestCentreID", TestCentre);
            collections.Add("DepartmentID", ddlDepartment.SelectedValue);
            collections.Add("ClientID", ddlPanel.SelectedValue);
            collections.Add("ReportType", rbtReportType.SelectedValue);
            collections.Add("ReportFormat", rblReportformat.SelectedValue);

            AllLoad_Data.POSTForm(collections, "Design/Reports/LabReport/HighVolumeReportPdf.aspx", this.Page);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

    }
    private string GetSelection(CheckBoxList cbl)
    {

        return string.Join(", ", cbl.Items.Cast<ListItem>().Where(s => s.Selected).Select(x => x.Value).ToArray());

    }   
}

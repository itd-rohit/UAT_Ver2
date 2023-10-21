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
using CrystalDecisions.CrystalReports.Engine;
using System.Collections.Specialized;
using System.Linq;
using Newtonsoft.Json;

public partial class Design_OPD_OutSourceLabSampleCollectionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            AllLoad_Data.FillDateTime(txtFromdate, txtTodate, txtFromTime, txtToTime);
            bindAccessCentre();
            bindOutsourceLab();
            reportaccess();
            bindAccessTestCentre();
        }

    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(28));
        if (response.status == true)
        {
            if (response.DurationInDay > 0)
            {
                DateTime date = Util.GetDateTime(txtFromdate.Text).AddDays(response.DurationInDay);
                if (date < DateTime.Now.Date)
                {
                    lblMsg.Text = "You are not authorized to view more than " + response.DurationInDay + " days data";
                    return false;
                }
            }
            if (response.ShowPdf == 1 && response.ShowExcel == 0)
            {
                rblReportFormate.Items[0].Enabled = true;
                rblReportFormate.Items[1].Enabled = false;
                rblReportFormate.Items[0].Selected = true;
            }
            else if (response.ShowExcel == 1 && response.ShowPdf == 0)
            {
                rblReportFormate.Items[1].Enabled = true;
                rblReportFormate.Items[0].Enabled = false;
                rblReportFormate.Items[1].Selected = true;
            }
            else if (response.ShowPdf == 0 && response.ShowExcel == 0)
            {
                rblReportFormate.Visible = false;
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
            div3.Visible = false;
            div4.Visible = false;
            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }
    private void bindAccessCentre()
    {

      using(DataTable dt = AllLoad_Data.loadCentre())
        if (dt != null && dt.Rows.Count > 0)
        {
            chklstOutSrcCentre.DataSource = dt;
            chklstOutSrcCentre.DataTextField = "Centre";
            chklstOutSrcCentre.DataValueField = "CentreID";
            chklstOutSrcCentre.DataBind();
        }
    }
    private void bindAccessTestCentre()
    {

        using (DataTable dt = AllLoad_Data.loadCentre())
            if (dt != null && dt.Rows.Count > 0)
            {
                chklstOutSrcTestCentre.DataSource = dt;
                chklstOutSrcTestCentre.DataTextField = "Centre";
                chklstOutSrcTestCentre.DataValueField = "CentreID";
                chklstOutSrcTestCentre.DataBind();
            }
    }
    private void bindOutsourceLab()
    {
       using(DataTable dt = AllLoad_Data.loadOutSourceLab())
        if (dt != null && dt.Rows.Count > 0)
        {
            chklstOutSrcLab.DataSource = dt;
            chklstOutSrcLab.DataTextField = "Name";
            chklstOutSrcLab.DataValueField = "ID";
            chklstOutSrcLab.DataBind();
        }
    }


    protected void btnReport_Click(object sender, EventArgs e)
    {
        string Centre = GetSelection(chklstOutSrcCentre);
        string TestCentre = GetSelection(chklstOutSrcTestCentre);
        string Outsrclab = GetSelection(chklstOutSrcLab);
        

        try
        {
            NameValueCollection collections = new NameValueCollection();
            collections.Add("fromDate", string.Concat(Util.GetDateTime(txtFromdate.Text).ToString("yyyy-MM-dd")," ",txtFromTime.Text.Trim()));
            collections.Add("toDate", string.Concat(Util.GetDateTime(txtTodate.Text).ToString("yyyy-MM-dd")," ",txtToTime.Text.Trim()));
            collections.Add("CentreID", Centre);
            collections.Add("TestCentre", TestCentre);
            collections.Add("OutSourceCentreID", Outsrclab);
            collections.Add("ReportType", rblReportType.SelectedValue);
            collections.Add("ReportFormat", rblReportFormate.SelectedValue);

            AllLoad_Data.POSTForm(collections, "Design/Reports/LabReport/OutSourceLabReportPdf.aspx", this.Page);
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
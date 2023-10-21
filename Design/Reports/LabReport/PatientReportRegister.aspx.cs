using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Reports_LabReport_PatientReportRegister : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindDepartment();
            bindCenterDDL();
            reportaccess();
        }

    }

    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(22));
        if (response.status == true)
        {
            if (response.DurationInDay > 0)
            {
                DateTime date = Util.GetDateTime(txtFromDate.Text).AddDays(response.DurationInDay);
                if (date < DateTime.Now.Date)
                {
                    lblMsg.Text = "You are not authorized to view more than " + response.DurationInDay + " days data";
                    return false;
                }
            }
            if (response.ShowPdf == 1 && response.ShowExcel == 0)
            {
                rblreportformat.Items[0].Enabled = true;
                rblreportformat.Items[1].Enabled = false;
                rblreportformat.Items[0].Selected = true;
            }
            else if (response.ShowExcel == 1 && response.ShowPdf == 0)
            {
                rblreportformat.Items[1].Enabled = true;
                rblreportformat.Items[0].Enabled = false;
                rblreportformat.Items[1].Selected = true;
            }
            else if (response.ShowPdf == 0 && response.ShowExcel == 0)
            {
                rblreportformat.Visible = false;
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
    protected void BindDepartment()
    {
        ddlDepartment.DataSource = AllLoad_Data.getDepartment();
        ddlDepartment.DataTextField = "Name";
        ddlDepartment.DataValueField = "SubcategoryID";
        ddlDepartment.DataBind();
    }
    public void bindCenterDDL()
    {

        using (DataTable dt = AllLoad_Data.getCentreByLogin())
        {
            if (dt.Rows.Count > 0)
            {
                ddlcenter.DataSource = dt;
                ddlcenter.DataTextField = "Centre";
                ddlcenter.DataValueField = "CentreID";
                ddlcenter.DataBind();
                ddlcenter.SelectedIndex = ddlcenter.Items.IndexOf(ddlcenter.Items.FindByValue(UserInfo.Centre.ToString()));
            }
        }
    }

    [WebMethod]
    public static string BindInvestigations(string DeptId)
    {
        if (DeptId != "")
        {
            string str = "select TypeName,ItemId from f_itemmaster Where SubCategoryId in (" + DeptId + ") order by TypeName";
            using (DataTable dt = StockReports.GetDataTable(str))
            {
                string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                return rtrn;
            }
        }
        else
        {
            return "0";
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (hdnDepartmentValue.Value == string.Empty)
        {
            lblMsg.Text = "Please select Department";
            return;
        }
        if (hdnItemId.Value == string.Empty)
        {
            lblMsg.Text = "Please select Investigation";
            return;
        }

        try
        {
            NameValueCollection collections = new NameValueCollection();
            collections.Add("fromDate", Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd"));
            collections.Add("toDate", Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd"));
            collections.Add("CentreID", ddlcenter.SelectedValue);
            collections.Add("CentreName", ddlcenter.SelectedItem.Text);
            //collections.Add("ReportType", rbtnReportType.SelectedItem.Value);
            collections.Add("SubcategoryID", hdnDepartmentValue.Value);
            collections.Add("ItemID", hdnItemId.Value);
            collections.Add("ReportFormat", rblreportformat.SelectedValue);

            AllLoad_Data.POSTForm(collections, "Design/Reports/LabReport/PatientReportRegisterPdf.aspx", this.Page);
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
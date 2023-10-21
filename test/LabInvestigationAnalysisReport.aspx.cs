using MySql.Data.MySqlClient;
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

public partial class Design_OPD_LabInvestigationAnalysisReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lstpanellist.DataSource = StockReports.GetDataTable("SELECT fpm.Company_Name,fpm.Panel_ID FROM f_panel_master fpm  INNER JOIN  centre_panel cp ON cp.panelid = fpm.panel_id  WHERE (cp.centreid IN ( SELECT DISTINCT `CentreAccess` FROM `centre_access` WHERE `CentreID`='" + UserInfo.Centre + "'  ) OR cp.centreid='" + UserInfo.Centre + "') and fpm.IsActive=1  GROUP BY fpm.panel_id ORDER BY Company_Name;");
            lstpanellist.DataTextField = "Company_Name";
            lstpanellist.DataValueField = "Panel_ID";
            lstpanellist.DataBind();
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindDepartment();          
            bindCenterDDL();         
           
        }
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
            collections.Add("ReportType", rbtnReportType.SelectedItem.Value);
            collections.Add("SubcategoryID", hdnDepartmentValue.Value);
            collections.Add("ItemID", hdnItemId.Value);
            collections.Add("PanelID", hdnPanelID.Value);
            collections.Add("ReportFormat", rblreportformat.SelectedValue);

            AllLoad_Data.POSTForm(collections, "Design/Reports/LabReport/LabInvestigationAnalysisPdf.aspx", this.Page);
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

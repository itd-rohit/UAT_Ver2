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
           // lstpanellist.DataSource = StockReports.GetDataTable("SELECT fpm.Company_Name,fpm.Panel_ID FROM f_panel_master fpm  INNER JOIN  centre_panel cp ON cp.panelid = fpm.panel_id  WHERE (cp.centreid IN ( SELECT DISTINCT `CentreAccess` FROM `centre_access` WHERE `CentreID`='" + UserInfo.Centre + "'  ) OR cp.centreid='" + UserInfo.Centre + "') and fpm.IsActive=1  GROUP BY fpm.panel_id ORDER BY Company_Name;");
            lstpanellist.DataSource = StockReports.GetDataTable("SELECT Company_Name,Panel_ID FROM f_panel_master ");
            lstpanellist.DataTextField = "Company_Name";
            lstpanellist.DataValueField = "Panel_ID";
            lstpanellist.DataBind();
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindDepartment();          
            bindCenterDDL();
            bindCenterTest();
           
        }
    }
    protected void BindDepartment()
    {       
        // ddlDepartment.DataSource = AllLoad_Data.getDepartment();
        // ddlDepartment.DataTextField = "Name";
        // ddlDepartment.DataValueField = "SubcategoryID";
        // ddlDepartment.DataBind();   
 ddlDepartment.DataSource = StockReports.GetDataTable("select SubCategoryID,name from f_subcategorymaster where SubCategoryID<>'LSHHI24'  AND `SubcategoryID`<>15 and active=1 order by name");
        ddlDepartment.DataTextField = "name";
        ddlDepartment.DataValueField = "SubCategoryID";
        ddlDepartment.DataBind();
       // ddlDepartment.Items.Insert(0, new ListItem("Select", "0"));
		
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
               //ddlcenter.SelectedIndex = ddlcenter.Items.IndexOf(ddlcenter.Items.FindByValue(UserInfo.Centre.ToString()));
            }
        }
    }
    public void bindCenterTest()
    {

        using (DataTable dt = AllLoad_Data.getCentreByLogin())
        {
            if (dt.Rows.Count > 0)
            {
                lstCentre.DataSource = dt;
                lstCentre.DataTextField = "Centre";
                lstCentre.DataValueField = "CentreID";
                lstCentre.DataBind();
               // lstCentre.SelectedIndex = ddlcenter.Items.IndexOf(ddlcenter.Items.FindByValue(UserInfo.Centre.ToString()));
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
        if (hdnCentre.Value == string.Empty)
        {
            lblMsg.Text = "Please select Booking Centre";
            return;
        }
        if (hdnCentre1.Value == string.Empty)
        {
            lblMsg.Text = "Please select Test Centre";
            return;
        }
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
            collections.Add("fromDate", Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd")+" 00:00:00");
            collections.Add("toDate", Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd")+" 23:59:59");
            collections.Add("CentreID", hdnCentre.Value);
            collections.Add("TestCentreID", hdnCentre1.Value);
            collections.Add("ReportType", rbtnReportType.SelectedItem.Value);
            collections.Add("SubcategoryID", hdnDepartmentValue.Value);
            collections.Add("ItemID", hdnItemId.Value);
            collections.Add("PanelID", hdnPanelID.Value);
            collections.Add("ReportFormat", rblreportformat.SelectedValue);
            collections.Add("DateType", ddlDateType.SelectedItem.Value);
            if(rbtnReportType.SelectedItem.Value=="Custom")
            {
            AllLoad_Data.POSTForm(collections, "Design/Reports/LabReport/LabInvestigationAnalysisPdfNew.aspx", this.Page);
            }
            else 
            {
            AllLoad_Data.POSTForm(collections, "Design/Reports/LabReport/LabInvestigationAnalysisPdf.aspx", this.Page);
            }
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

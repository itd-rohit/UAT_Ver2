using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Reports_WorkSheet_WorkSheetObservationWise : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromTime.Text = "00:00:00";
            dtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToTime.Text = "23:59:59";
            Bindcenter();
            BindDepartment();
            BindPanel();
           
        }
    }
    private void Bindcenter()
    {
        chlCentre.DataSource = AllLoad_Data.getCentreByLogin();
        chlCentre.DataTextField = "Centre";
        chlCentre.DataValueField = "CentreID";
        chlCentre.DataBind();
       // chlCentre.Items.Add(new ListItem("All", "All"));
    }
    private void BindPanel()
    {
        ddlPanel.DataSource = AllLoad_Data.bindPanel1();
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "PanelID";
        ddlPanel.DataBind();
       ddlPanel.Items.Insert(0, new ListItem("All Panel", "0"));
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
    private void BindDepartment()
    {
        using (DataTable dt = AllLoad_Data.getDepartment())
        {
            if (dt.Rows.Count > 0)
            {
                ddlDepartment.DataSource = dt;
                ddlDepartment.DataTextField = "NAME";
                ddlDepartment.DataValueField = "SubCategoryID";
                ddlDepartment.DataBind();
              //  ddlDepartment.Items.Insert(0, "");
            }
        }
    }

    protected void btnPreview_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (hdnCentre.Value == "")
        {
            lblMsg.Text = "Please select Centre !";
            return;
        }
        if ((dtFrom.Text.Trim() == string.Empty) || (dtTo.Text.Trim() == string.Empty))
        {
            lblMsg.Text = "Please select date !";
            return;
        }
        //if (hdnPanel.Value == "")
        //{
        //    lblMsg.Text = "Please select Centre !";
        //    return;
        //}

        try
        {
            NameValueCollection collections = new NameValueCollection();
            collections.Add("fromDate",string.Concat(Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd")," ",txtFromTime.Text));
            collections.Add("toDate", string.Concat(Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd"), " ", txtToTime.Text));
            collections.Add("CentreID", hdnCentre.Value);
            //collections.Add("PanelID", hdnPanel.Value);
            collections.Add("ReportType", "0");
            collections.Add("SubcategoryID", hdnDepartmentValue.Value);
            collections.Add("InvestigationID", hdnItemId.Value);
            collections.Add("ReportFormat", "0");
            collections.Add("LabNo", txtLabNo.Text.Trim());
            collections.Add("FromLabNo", txtFromLabNo.Text.Trim());
            collections.Add("ToLabNo", txtToLabNo.Text.Trim());
            collections.Add("PatientName", txtPName.Text.Trim());
            collections.Add("SampleStatus", ddlStatus.SelectedValue);
            //
            collections.Add("PanelID",ddlPanel.SelectedValue);
            //
            AllLoad_Data.POSTForm(collections, "Design/Reports/WorkSheet/PatientWiseWorkSheetPdf.aspx", this.Page);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}
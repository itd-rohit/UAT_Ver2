﻿using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Reports_ProBusinessReportNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            bindCentreMaster();
            bindClient("");
            lblMsg.Text = "";
            reportaccess();
            BindPro();
        }
    }
    private void BindPro()
    {

        string proid = Session["PROID"].ToString();
        if (UserInfo.RoleID == 220 && proid != "")
        {

            DataTable dt = StockReports.GetDataTable("SELECT PROID,PRONAME FROM pro_master WHERE isActive=1 and PROID='" + proid + "'  ");
            if (dt.Rows.Count > 0)
            {
                chklPro.DataSource = dt;
                chklPro.DataTextField = "ProName";
                chklPro.DataValueField = "ProID";
                chklPro.DataBind();
                // chklPro.Items.Insert(0, new ListItem("All", "0"));
            }
        }
        else
        {
            DataTable dt = StockReports.GetDataTable("SELECT PROID,PRONAME FROM pro_master WHERE isActive=1 ");
            if (dt.Rows.Count > 0)
            {
                chklPro.DataSource = dt;
                chklPro.DataTextField = "ProName";
                chklPro.DataValueField = "ProID";
                chklPro.DataBind();
                // chklPro.Items.Insert(0, new ListItem("All", "0"));
            }
        }
    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(14));
        if (response.status == true)
        {
            if (response.DurationInDay > 0)
            {
                DateTime date = Util.GetDateTime(ucFromDate.Text).AddDays(response.DurationInDay);
                if (date < DateTime.Now.Date)
                {
                    lblMsg.Text = "You are not authorized to view more than " + response.DurationInDay + " days data";
                    return false;
                }
            }
            if (response.ShowPdf == 1 && response.ShowExcel == 0)
            {
                rdoReportFormat.Items[0].Enabled = true;
                rdoReportFormat.Items[1].Enabled = false;
                rdoReportFormat.Items[0].Selected = true;
            }
            else if (response.ShowExcel == 1 && response.ShowPdf == 0)
            {
                rdoReportFormat.Items[1].Enabled = true;
                rdoReportFormat.Items[0].Enabled = false;
                rdoReportFormat.Items[1].Selected = true;
            }
            else if (response.ShowPdf == 0 && response.ShowExcel == 0)
            {
                rdoReportFormat.Visible = false;
                lblMsg.Text = "Report format not allowed contect to admin";
                return false;
            }
            //else/
            //{
            //    rdoReportFormat.Items[0].Selected = true;
            //}
        }
        else
        {
            divcentre.Visible = false;
            divuser.Visible = false;
            divsave.Visible = false;

            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }
    private void bindClient(string Proid)
    {

         // string proid = Session["PROID"].ToString();  and PROID IN (" + Proid + ")
        if (Proid != "")
        {
            DataTable dt = StockReports.GetDataTable("SELECT Panel_ID,Company_Name FROM f_panel_master WHERE IsActive=1  ORDER BY Company_Name  ");
            if (dt.Rows.Count > 0)
            {
                chklClient.DataSource = dt;
                chklClient.DataTextField = "Company_Name";
                chklClient.DataValueField = "Panel_ID";
                chklClient.DataBind();
                // chklPro.Items.Insert(0, new ListItem("All", "0"));
            }
        }
        else
        {
            //chklClient.Items.Clear();
			DataTable dt = StockReports.GetDataTable("SELECT Panel_ID,Company_Name FROM f_panel_master WHERE IsActive=1 ORDER BY Company_Name  ");
            if (dt.Rows.Count > 0)
            {
                chklClient.DataSource = dt;
                chklClient.DataTextField = "Company_Name";
                chklClient.DataValueField = "Panel_ID";
                chklClient.DataBind();
                // chklPro.Items.Insert(0, new ListItem("All", "0"));
            }
        }
    }
    private void bindCentreMaster()
    {
        using (DataTable dt = AllLoad_Data.getCentreByLogin())
        {
            if (dt.Rows.Count > 0)
            {
                chklCentres.DataSource = dt;
                chklCentres.DataTextField = "Centre";
                chklCentres.DataValueField = "CentreID";
                chklCentres.DataBind();
            }
        }
    }
    protected void btnPreview_Click(object sender, EventArgs e)
    {
        if (!reportaccess())
            return;
        lblMsg.Text = "";
        string startDate = string.Empty, toDate = string.Empty, Client = string.Empty, Pro = string.Empty;

        if (ucFromDate.Text != string.Empty)
            if (txtFromTime.Text.Trim() != string.Empty)
                startDate = string.Concat(Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd"), " ", txtFromTime.Text.Trim());
            else
                startDate = Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd");

        if (ucToDate.Text != string.Empty)
            if (txtToTime.Text.Trim() != string.Empty)
                toDate = string.Concat(Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd"), " ", txtToTime.Text.Trim());
            else
                toDate = Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd");

        Client = GetSelection(chklClient);
        Pro = GetSelection(chklPro);

        GetCollectionData(startDate, toDate, Client, Pro);
    }
    private void GetCollectionData(string fromDate, string toDate, string Client, string Pro)
    {
        string Centres = GetSelection(chklCentres);

        if (Centres.Trim() == string.Empty)
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        if (Client.Trim() == string.Empty)
        {
          //  lblMsg.Text = "Please Select Client";
           // return;
        }
        try
        {
            NameValueCollection collections = new NameValueCollection();
            collections.Add("fromDate", fromDate.Trim());
            collections.Add("toDate", toDate.Trim());
            collections.Add("ClientID", Client);
            collections.Add("CentreID", Centres);
            collections.Add("ReportType", rbtReportType.SelectedValue);
if( rbtReportType.SelectedValue=="2")
{   collections.Add("ReportFormat","2");}
else{
	   collections.Add("ReportFormat", rdoReportFormat.SelectedValue);
	
}
         
            collections.Add("ProID", Pro);
            AllLoad_Data.POSTForm(collections, "Design/Reports/BusinessReport/ProBusinessReportClientPdf.aspx", this.Page);
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
    protected void chklPro_SelectedIndexChanged(object sender, EventArgs e)
    {
        string Pro = GetSelection(chklPro);
        bindClient(Pro);
    }
}
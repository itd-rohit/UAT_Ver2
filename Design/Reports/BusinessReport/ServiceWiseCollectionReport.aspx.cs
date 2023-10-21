using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Specialized;
using System.Data;
using System.Text;

public partial class Design_OPD_ServiceWiseCollectionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindCenter();
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
            reportaccess();
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(11));
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
        }
        else
        {
            divcentre.Visible = false;
            divuser.Visible = false;
            divsave.Visible = false;
            divclient.Visible = false;
            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }
    public void BindCenter()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pm.panel_ID,CONCAT(IFNULL(pm.panel_code,''),' ',pm.company_Name)PanelName  ");
            sb.Append(" FROM f_panel_master pm  ");
            sb.Append(" WHERE  pm.`PanelType` <> 'Centre' ");
            if (UserInfo.Centre != 1)
            {
                sb.Append(" AND ( pm.`TagBusinessLabID` =@CentreID )  ");
            }
            sb.Append(" UNION ALL  ");
            sb.Append(" SELECT pm.panel_ID,CONCAT(IFNULL(cm.`CentreCode`,''),' ',cm.`Centre`)PanelName  ");
            sb.Append(" FROM f_panel_master pm  ");
            sb.Append(" INNER JOIN `centre_master` cm ON cm.CentreID=pm.`CentreID`  ");
            sb.Append(" WHERE pm.`PanelType`='Centre' ");
            if (UserInfo.Centre != 1)
            {
                sb.Append(" AND ( pm.`TagBusinessLabID` =@CentreID OR pm.CentreID =@CentreID)   ");
            }
            sb.Append(" ORDER BY PanelName  ");

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                      new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0];

            if (dt.Rows.Count > 0)
            {
                chlCentres.DataSource = dt;
                chlCentres.DataTextField = "PanelName";
                chlCentres.DataValueField = "panel_ID";
                chlCentres.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (!reportaccess())
            return;
        lblMsg.Text = "";
        string Centres = AllLoad_Data.GetSelection(chlCentres);
        if (Centres.Trim() == string.Empty)
        {
            lblMsg.Text = "Please Select client";
            return;
        }

        string fromDate = string.Concat(Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd"), " 00:00:00");
        string toDate = string.Concat(Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd"), " 23:59:59");

        try
        {
            NameValueCollection collections = new NameValueCollection();
            collections.Add("fromDate", fromDate);
            collections.Add("toDate", toDate);
            collections.Add("CentreID", Centres);
            collections.Add("BillNo", txtBillNo.Text.Trim());
            collections.Add("ReportFormat", rdoReportFormat.SelectedValue);
            AllLoad_Data.POSTForm(collections, "Design/Reports/BusinessReport/ServiceWiseCollectionReportPdf.aspx", this.Page);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}
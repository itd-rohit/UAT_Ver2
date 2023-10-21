using System;
using System.Data;
using System.Text;

public partial class Design_OPD_CustomerRegistrationReport : System.Web.UI.Page
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
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    public void BindCenter()
    {
        // string str = "select distinct cm.CentreID,cm.Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.Centre  ";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.CentreID,cm.Centre ");
        sb.Append(" FROM f_panel_master fpm  ");
        sb.Append(" INNER JOIN `centre_master` cm ON cm.CentreID=fpm.`CentreID`  ");
        sb.Append(" WHERE fpm.`PanelType`='Centre' ");
        if (UserInfo.Centre != 1)
        {
            sb.Append(" AND ( fpm.`TagBusinessLabID` =" + UserInfo.Centre + " OR cm.CentreId =" + UserInfo.Centre + ") ");
        }
        sb.Append(" ORDER BY Centre  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        chlCentres.DataSource = dt;
        chlCentres.DataTextField = "Centre";
        chlCentres.DataValueField = "CentreID";
        chlCentres.DataBind();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string Centres = AllLoad_Data.GetSelection(chlCentres);
        if (Centres.Trim() == string.Empty)
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }

        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT lt.CentreID  LocalityID,pm.Patient_ID UHID,DATE_FORMAT(lt.Date,'%d-%b-%Y %I:%i%p')DATEOFREGISTRATION,lt.PName PATIENTNAME, ");
        sb.Append(" pm.House_No ADDRESS,pm.Mobile MOBILENUMBER,'' EMERGENCYNUMBER,pm.Email MAILID,  DATE_FORMAT(pm.DOB,'%d-%b-%Y')DOB,pm.Gender GENDER,DATE_FORMAT(pm.dtEntry,'%d-%b-%Y %I:%i%p')CreatedDate,");
        sb.Append(" DATE_FORMAT(pm.UpdateDate,'%d-%b-%Y %I:%i%p')updateddate,''Flag,lt.CreatorName OPERATORNAME, ");
        sb.Append(" IF(lt.Revisit=1,'Yes','No')Revisit  FROM patient_master pm   ");

        sb.Append(" INNER JOIN f_ledgertransaction lt ON pm.Patient_ID=lt.Patient_ID ");
        sb.Append("  WHERE  lt.isCancel=0 AND lt.date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'  ");
        sb.Append("  AND lt.date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'  ");
        sb.Append("  AND pm.CentreID IN (" + Centres + " )");
        if (txtUHIDNo.Text.Trim() != "")
            sb.Append(" AND pm.Patient_ID='" + txtUHIDNo.Text.Trim() + "' ");
        sb.Append(" ");
        sb.Append(" ORDER BY lt.Date ");

        string period = string.Concat("From : ", Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy"), " To : ", Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy"));
        AllLoad_Data.exportToExcel(sb.ToString(), "Customer Registration Report", period, "1", this.Page);
        //DataTable dt = StockReports.GetDataTable(sb.ToString());
        //if (dt.Rows.Count > 0)
        //{
        //    Session["dtExport2Excel"] = dt;
        //    Session["ReportName"] = "Customer Registration Report";

        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
        //}
        //else
        //    lblMsg.Text = "No Record Found";
    }
}
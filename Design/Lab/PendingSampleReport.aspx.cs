using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;

public partial class Design_Lab_PendingSampleReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindCentreMaster();
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    private void bindCentreMaster()
    {
        DataTable dt = AllLoad_Data.getCentreByLogin(); 
        if (dt.Rows.Count > 0)
        {
            chlCentres.DataSource = dt;
            chlCentres.DataTextField = "Centre";
            chlCentres.DataValueField = "centreID";
            chlCentres.DataBind();            
        }
    }

    protected void btnExcelReport_Click(object sender, EventArgs e)
    {
        string Centres = AllLoad_Data.GetSelection(chlCentres);
        if (Centres.Trim() == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT lt.`Patient_ID` UHID,lt.`PName` PatientName,lt.`Age`,lt.Gender,plo.barcodeno SinNo,plo.`InvestigationName`, ");
        //sb.Append(" (SELECT `Status` FROM  `patient_labinvestigation_opd_update_status` plos WHERE plos.`BarcodeNo`=plo.`BarcodeNo` ORDER BY `dtEntry` DESC LIMIT 1) LastStatus, ");        
        //sb.Append(" cm.Centre FROM f_ledgertransaction lt ");
        //sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ");
        //sb.Append(" ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
        //sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
        //sb.Append(" AND lt.`IsCancel`=0 ");
        //sb.Append(" AND plo.`Approved`=0 ");
        //sb.Append(" AND lt.`Date` >='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'  AND lt.`Date` <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        //sb.Append(" AND lt.`CentreID` IN (" + Centres + ") ");

        sb.Append(" Select cm.Centre `Registration Centre`,DATE_FORMAT(lt.`Date`,'%d-%b-%y %I:%i%p') `Registration Date`,cm1.`Centre` `Processing Centre`,lt.`LedgerTransactionNo` VisitNo, ");
        sb.Append(" lt.`Patient_ID` UHID,lt.`PName` PatientName,lt.`Age`,lt.Gender,plo.barcodeno SinNo,plo.`ItemCode` TestCode ,sm.`Name` DeptName,plo.`ItemName` InvestigationName,  ");
        sb.Append(" (SELECT `Status` FROM  `patient_labinvestigation_opd_update_status` plos WHERE plos.`BarcodeNo`=plo.`BarcodeNo` ORDER BY `dtEntry` DESC LIMIT 1) LastStatus ");
        sb.Append(" FROM f_ledgertransaction lt  ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo  ");
        sb.Append(" ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID`  ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`  ");
        sb.Append(" INNER JOIN centre_master cm1 ON cm1.`CentreID`=plo.`TestCentreID` INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
        sb.Append(" AND lt.`IsCancel`=0 AND plo.`Approved`=0   AND plo.`Result_Flag`=0   ");
        sb.Append(" AND plo.`SampleCollectionDate` >='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'  AND plo.`SampleCollectionDate` <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" AND plo.`TestCentreID` IN (" + Centres + ") ");
        //DataTable dt = StockReports.GetDataTable(sb.ToString());
      
        //if (dt.Rows.Count > 0)
        //{
        //    Session["dtExport2Excel"] = dt;
        //    Session["ReportName"] = "Pending Sample Report";
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
        //    lblMsg.Text = dt.Rows.Count + " Records Found ";
        //}
        //else
        //{
        //    lblMsg.Text = "Record Not found";
        //}

        string period = string.Concat("From : ", Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy"), " To : ", Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy"));
        AllLoad_Data.exportToExcel(sb.ToString(), "Pending Sample Report", period, "1", this.Page);

    }
    [WebMethod]
    public static string getData(string CentreType)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT GROUP_CONCAT(cm.`CentreID`)CentreID FROM centre_master cm WHERE cm.`type1`='" + CentreType + "' and cm.IsActive=1 ");       
        return Util.getJson(dt);
    }
}
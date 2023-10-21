using System;
using System.Collections.Specialized;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;

public partial class Design_Lab_AutoApprovalReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);          
            bindCentreMaster();
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
       
    }

    private void bindCentreMaster()
    {
        using (DataTable dt = AllLoad_Data.getCentreByLogin())
        {
            if (dt.Rows.Count > 0)
            {
                chlCentres.DataSource = dt;
                chlCentres.DataTextField = "Centre";
                chlCentres.DataValueField = "centreID";
                chlCentres.DataBind();
            }
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
        sb.Append(" SELECT plo.centreid LocationID, ");
        sb.Append(" (SELECT centre FROM centre_master cm1 WHERE cm1.centreid=plo.centreid) BookingCentre, ");
        sb.Append(" (SELECT centre FROM centre_master cm2 WHERE cm2.centreid=plo.`TestCentreID`) ProcessingCentre, ");
        sb.Append(" plo.`LedgerTransactionNo` VisitNo,plo.`BarcodeNo` SinNo, DATE_FORMAT(plo.`Date`,'%d-%b-%Y %I:%i %p') BookingDate,DATE_FORMAT(plo.`SampleCollectionDate`,'%d-%b-%Y %I:%i %p') `SampleCollectionDate`,DATE_FORMAT(plo.`SampleReceiveDate`,'%d-%b-%Y %I:%i %p') DepartmentReceiveDate,DATE_FORMAT(plo.`ResultEnteredDate`,'%d-%b-%Y %I:%i %p') ResultEnteredDate, DATE_FORMAT(plo.ApprovedDate,'%d-%b-%Y %I:%i %p') AutoApprovedDate, ");
        sb.Append("  plo.ResultEnteredName,plo.ApprovedName AutoApprovedByName,plo.`SubCategoryName` AS DepartmentName,plo.`ItemCode`,plo.`ItemName`,");
        sb.Append("  ploo.`LabObservationName`,ploo.`Value`,ploo.`ReadingFormat` Unit ,ploo.`DisplayReading` `Bio. Ref. Range`,ploo.`Method`, ");
        sb.Append("  ploo.`Flag`,ploo.`MinValue`,ploo.`MaxValue`,ploo.`MinCritical`,ploo.`MaxCritical` ");
        sb.Append("  FROM `patient_labinvestigation_opd` plo  ");
        sb.Append("  INNER JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID`  ");

        sb.Append(" WHERE `AutoApproved`=1  AND plo.ApprovedDate >=@FromDate AND plo.ApprovedDate <=@ToDate ");      
        sb.Append(" AND plo.`TestCentreID` IN ({0}) ");
        sb.Append(" ORDER BY plo.LedgerTransactionID, plo.`Test_ID`,ploo.`Priorty` ");


        string Period = string.Concat("From : ", Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy"), " To : ", Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy"));


        NameValueCollection collections = new NameValueCollection();
        collections.Add("ReportDisplayName", Common.EncryptRijndael("Auto Approval Report"));
        collections.Add("TestCentreID#1", Common.EncryptRijndael(Centres));
        collections.Add("FromDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd"), " ", "00:00:00")));
        collections.Add("ToDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd"), " ", "23:59:59")));
        collections.Add("Query", Common.EncryptRijndael(sb.ToString()));
        collections.Add("Period", Common.EncryptRijndael(Period));

        AllLoad_Data.ExpoportToExcelEncrypt(collections, 2, this.Page);
    }
}
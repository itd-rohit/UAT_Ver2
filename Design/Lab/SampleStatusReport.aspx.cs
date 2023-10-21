using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_Lab_SampleStatusReport : System.Web.UI.Page
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
        DataTable dt = StockReports.GetDataTable("SELECT centreID,Centre FROM  centre_master WHERE IsActive=1 AND TagProcessingLabID='" + UserInfo.Centre + "'");
        if (dt.Rows.Count > 0)
        {
            chlCentres.DataSource = dt;
            chlCentres.DataTextField = "Centre";
            chlCentres.DataValueField = "centreID";
            chlCentres.DataBind();
        }
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
        DataTable dt = StockReports.GetDataTable(GetReportQry(Centres,rdoSampleStatusType.SelectedValue));
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            if (rdoSampleStatusType.SelectedValue == "1") // Logistic Receive Pending
            {               
                Session["ReportName"] = "Logistic Receive Pending Report";                
            }
            if (rdoSampleStatusType.SelectedValue == "2") // Pending For Batch
            {
                Session["ReportName"] = "Pending For Batch Report";
            }
            if (rdoSampleStatusType.SelectedValue == "3") // Pending For Transfer ( Batch Created )
            {
                Session["ReportName"] = "Pending For Transfer ( Batch Created ) Report";
            }
            if (rdoSampleStatusType.SelectedValue == "4") // SRA Pending
            {
                Session["ReportName"] = "SRA Pending Report";
            }
            if (rdoSampleStatusType.SelectedValue == "5") // Department Receive Pending ( SRA / SDR Completed ) 
            {
                Session["ReportName"] = "Department Receive Pending ( SRA / SDR Completed ) Report";
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
        }
        else
            lblMsg.Text = "No Record Found";
    }

    public string GetReportQry(string Centres,string SampleStatusType)
    {
        StringBuilder sb = new StringBuilder();
        if (SampleStatusType.Trim() == "1") // Logistic Receive Pending
        {
            sb.Append(" SELECT cm.Centre,lt.PName PatientName,lt.Gender,plo.LedgerTransactionNo VisitNo,plo.BarcodeNo SinNo,plo.`TestCode`,sm.Name Dept,");
            sb.Append(" CAST(GROUP_CONCAT(plo.ItemName )AS CHAR)ItemName,'Pending For Batch Creation' `Status` ");
            sb.Append(" FROM patient_labinvestigation_opd plo  INNER JOIN f_ledgertransaction lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID AND plo.isrefund=0 AND lt.`IsCancel`=0   ");
            sb.Append(" INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
            sb.Append(" AND plo.sampleCollectionDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append(" AND plo.sampleCollectionDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append(" AND plo.IsSampleCollected='S' AND plo.IsReporting=1 ");
            sb.Append(" AND cm.CentreID IN (" + Centres + " )");
            sb.Append(" LEFT JOIN sample_logistic sl ON sl.testid=plo.test_id and sl.FromCentreID = cm.CentreID  ");
            sb.Append("  WHERE sl.BarcodeNo IS NULL  GROUP BY plo.BarcodeNo ");

            sb.Append(" UNION ALL ");
            sb.Append(" SELECT cm.Centre,lt.PName PatientName,lt.Gender,plo.LedgerTransactionNo VisitNo,plo.BarcodeNo SinNo,plo.`TestCode`,sm.Name Dept, ");
            sb.Append(" CAST(GROUP_CONCAT(plo.ItemName )AS CHAR)ItemName, sl.Status `Status` ");
            sb.Append(" FROM patient_labinvestigation_opd plo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` AND lt.`IsCancel`=0 AND plo.isrefund=0 ");            
            sb.Append(" AND plo.sampleCollectionDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append(" AND plo.sampleCollectionDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append(" AND plo.IsSampleCollected='S' AND plo.IsReporting=1 ");
            sb.Append(" INNER JOIN sample_logistic sl ON sl.testid=plo.test_id AND  sl.tocentreid='" + UserInfo.Centre + "' and sl.Status IN ( 'Transferred','Pending for Dispatch') ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=sl.ToCentreID   ");
	    sb.Append(" INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
            sb.Append(" AND cm.CentreID IN (" + Centres + " ) ");
            sb.Append(" AND sl.FromCentreID=cm.CentreID  GROUP BY plo.BarcodeNo");
        }
        if (SampleStatusType.Trim() == "2") // Pending For Batch
        {
           //sb.Append(" SELECT cm.Centre,lt.PName PatientName,lt.Gender,plo.LedgerTransactionNo VisitNo,plo.BarcodeNo SinNo,plo.`TestCode`,sm.Name Dept,");
            //sb.Append(" CAST(GROUP_CONCAT(plo.ItemName )AS CHAR)ItemName,'Pending For Batch Creation' `Status` ");
            //sb.Append(" FROM patient_labinvestigation_opd plo  INNER JOIN f_ledgertransaction lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            //sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID AND plo.isrefund=0 AND lt.`IsCancel`=0   ");
            //sb.Append(" INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
            //sb.Append(" AND plo.sampleCollectionDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            //sb.Append(" AND plo.sampleCollectionDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            //sb.Append(" AND plo.IsSampleCollected='S' AND plo.IsReporting=1 ");
            //sb.Append(" AND cm.CentreID IN (" + Centres + " )");
            //sb.Append(" LEFT JOIN sample_logistic sl ON sl.BarcodeNo=plo.BarcodeNo  ");
            //sb.Append("  WHERE sl.BarcodeNo IS NULL  GROUP BY plo.BarcodeNo ");
            //sb.Append(" UNION ALL ");

            sb.Append(" SELECT cm.Centre,lt.PName PatientName,lt.Gender,plo.LedgerTransactionNo VisitNo,plo.BarcodeNo SinNo,plo.`TestCode`,sm.Name Dept, ");
            sb.Append(" CAST(GROUP_CONCAT(plo.ItemName )AS CHAR)ItemName, 'SRA Completed and Pending For Batch Creation' `Status` ");
            sb.Append(" FROM patient_labinvestigation_opd plo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` AND plo.isrefund=0 AND lt.`IsCancel`=0 ");            
            sb.Append(" AND plo.sampleCollectionDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append(" AND plo.sampleCollectionDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append(" AND plo.IsSampleCollected='S' AND plo.IsReporting=1 ");
            sb.Append(" INNER JOIN sample_logistic sl ON sl.testid=plo.Test_ID AND  sl.Status = 'Transferred' ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=sl.FromCentreID   ");
	    sb.Append(" INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
            sb.Append(" AND cm.CentreID IN (" + Centres + " ) ");
            sb.Append(" LEFT JOIN sample_logistic sl2 ON sl2.testid=plo.`Test_ID` and sl2.FromCentreID = cm.CentreID and sl2.Status != 'SDR Transfered'   ");         
            sb.Append(" GROUP BY plo.BarcodeNo");             


        }
        if (SampleStatusType.Trim() == "3") // Pending For Transfer ( Batch Created )
        {
            sb.Append(" SELECT cm.Centre,lt.PName PatientName,lt.Gender,plo.LedgerTransactionNo VisitNo,plo.BarcodeNo SinNo,plo.`TestCode`,sm.Name Dept, ");
            sb.Append(" CAST(GROUP_CONCAT(plo.ItemName )AS CHAR)ItemName, sl.Status `Status` ");
            sb.Append(" FROM patient_labinvestigation_opd plo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` AND plo.isrefund=0 AND lt.`IsCancel`=0 ");
            
            sb.Append(" AND plo.sampleCollectionDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append(" AND plo.sampleCollectionDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append(" AND plo.IsSampleCollected='S' AND plo.IsReporting=1 ");
            sb.Append(" INNER JOIN sample_logistic sl ON sl.testid=plo.Test_ID AND  sl.Status = 'Pending for Dispatch' ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=sl.ToCentreID   ");
	    sb.Append(" INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
            sb.Append(" AND cm.CentreID IN (" + Centres + " ) ");
            sb.Append(" AND sl.FromCentreID=cm.CentreID  GROUP BY plo.BarcodeNo"); 
        }
        if (SampleStatusType.Trim() == "4") // SRA Pending
        {
            sb.Append(" SELECT cm.Centre,lt.PName PatientName,lt.Gender,plo.LedgerTransactionNo VisitNo,plo.BarcodeNo SinNo,plo.`TestCode`,sm.Name Dept, ");
            sb.Append(" CAST(GROUP_CONCAT(plo.ItemName )AS CHAR)ItemName, sl.Status `Status` ");
            sb.Append(" FROM patient_labinvestigation_opd plo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` AND plo.isrefund=0 AND lt.`IsCancel`=0 ");
         
            sb.Append(" AND plo.sampleCollectionDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append(" AND plo.sampleCollectionDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append(" AND plo.IsSampleCollected='S' AND plo.IsReporting=1 ");
            sb.Append(" INNER JOIN sample_logistic sl ON sl.testid=plo.Test_ID AND  sl.Status in('Transferred','Received at Hub') ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=sl.ToCentreID    ");
	    sb.Append(" INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
            sb.Append(" AND cm.CentreID IN (" + Centres + " ) ");
            sb.Append(" AND sl.FromCentreID=cm.CentreID  GROUP BY plo.BarcodeNo"); 	  
        }
        if (SampleStatusType.Trim() == "5") // Department Receive Pending ( SRA / SDR Completed ) 
        {
            sb.Append(" SELECT cm.Centre,lt.PName PatientName,lt.Gender,plo.LedgerTransactionNo VisitNo,plo.BarcodeNo SinNo,plo.`TestCode`,sm.Name Dept, ");
            sb.Append(" CAST(GROUP_CONCAT(plo.ItemName )AS CHAR)ItemName, sl.Status `Status` ");
            sb.Append(" FROM patient_labinvestigation_opd plo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` AND plo.isrefund=0 AND lt.`IsCancel`=0 ");            
            sb.Append(" AND plo.sampleCollectionDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append(" AND plo.sampleCollectionDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append(" AND plo.IsSampleCollected='S' AND plo.IsReporting=1 ");
            sb.Append(" INNER JOIN sample_logistic sl ON sl.testid=plo.Test_ID AND  sl.Status = 'Received'  ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=sl.ToCentreID    ");
	    sb.Append(" INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
            sb.Append(" AND cm.CentreID IN (" + Centres + " ) ");
            sb.Append(" GROUP BY plo.BarcodeNo"); 
        }
        return sb.ToString();
    }
}
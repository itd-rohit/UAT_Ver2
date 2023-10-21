using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_Lab_LogisticReceivePendingReport : System.Web.UI.Page
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
 	// string str = " SELECT DISTINCT cm.CentreID,cm.Centre FROM centre_master cm INNER JOIN f_login fl ON fl.`CentreID`=cm.`CentreID` AND fl.`EmployeeID`='" + UserInfo.ID+ "' AND cm.`isActive`=1 ";
        DataTable dt = StockReports.GetDataTable("SELECT centreID,Centre FROM  centre_master WHERE IsActive=1 AND TagProcessingLabID='" + UserInfo.Centre + "'");
 	//  DataTable dt = StockReports.GetDataTable(str);
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
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT cm.Centre,lt.PName PatientName,lt.Gender,plo.LedgerTransactionNo VisitNo,plo.BarcodeNo BarcodeNo,");
        sb.Append(" CAST(GROUP_CONCAT(plo.ItemName )AS CHAR)ItemName,'Pending For Batch Creation' `Status` ");
        sb.Append(" FROM patient_labinvestigation_opd plo  INNER JOIN f_ledgertransaction lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID AND plo.isrefund=0 AND lt.`IsCancel`=0   ");
        sb.Append(" ");
        sb.Append(" AND plo.sampleCollectionDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
        sb.Append(" AND plo.sampleCollectionDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" AND plo.IsSampleCollected='S' AND plo.IsReporting=1 ");
        sb.Append(" AND cm.CentreID IN (" + Centres + " )");
        sb.Append(" LEFT JOIN sample_logistic sl ON sl.BarcodeNo=plo.BarcodeNo  ");
        sb.Append("  WHERE sl.BarcodeNo IS NULL  GROUP BY plo.BarcodeNo ");

        sb.Append(" UNION ALL ");
        sb.Append(" SELECT cm.Centre,lt.PName PatientName,lt.Gender,plo.LedgerTransactionNo VisitNo,plo.BarcodeNo BarcodeNo, ");
        sb.Append(" CAST(GROUP_CONCAT(plo.ItemName )AS CHAR)ItemName, sl.Status `Status` ");
        sb.Append(" FROM patient_labinvestigation_opd plo  ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID AND plo.isrefund=0 AND lt.`IsCancel`=0  ");
        sb.Append(" AND plo.sampleCollectionDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
        sb.Append(" AND plo.sampleCollectionDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" AND plo.IsSampleCollected='S' AND plo.IsReporting=1 ");
        sb.Append(" AND cm.CentreID IN (" + Centres + " ) ");
        sb.Append(" INNER JOIN sample_logistic sl ON sl.BarcodeNo=plo.BarcodeNo AND  sl.Status IN ( 'Transferred','Pending for Dispatch') ");
        sb.Append(" AND sl.FromCentreID=cm.CentreID  GROUP BY plo.BarcodeNo");
        //DataTable dt = StockReports.GetDataTable(sb.ToString());
        //if (dt.Rows.Count > 0)
        //{
        //    Session["dtExport2Excel"] = dt;
        //    Session["ReportName"] = "Logistic Receive Pending Report";

        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
        //}
        //else
        //    lblMsg.Text = "No Record Found";

        string period = string.Concat("From : ", Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy"), " To : ", Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy"));
        AllLoad_Data.exportToExcel(sb.ToString(), "LogisticReceivePendingReport", period, "1", this.Page);
    }
}
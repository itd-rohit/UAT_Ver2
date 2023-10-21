using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_HLMRevenueFromOSSampleReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
            bindCentreMaster();
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    private void bindCentreMaster()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT cm.`Centre`,cm.`CentreID` FROM centre_master cm WHERE cm.`isActive`=1 AND cm.`type1`='HLM'  ");
        if (dt.Rows.Count > 0)
        {
            chlCentres.DataSource = dt;
            chlCentres.DataTextField = "Centre";
            chlCentres.DataValueField = "centreID";
            chlCentres.DataBind();            
        }
    }
    [WebMethod]
    public static string getReport(string dtFrom, string dtTo, string Centre)
    {

        string retValue = "0";
        Centre = Centre.TrimEnd(',');

        DateTime dateFrom = Convert.ToDateTime(dtFrom);
        DateTime dateTo = Convert.ToDateTime(dtTo);

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm1.`Centre` ProcessingCentre,  cm.`Centre` BookingCentre,  ");
        sb.Append(" lt.`LedgerTransactionNo` VisitNo,  lt.`Patient_ID` UHID,  lt.`PName`,  lt.`Age`,  lt.`Gender`,  plo.`BarcodeNo` SinNo,plo.`TestCode`, ");
        sb.Append(" plo.`InvestigationName`,  plo.`IsPackage`,plo.`PackageName`,  plo.`Rate`,  plo.`DiscountAmt`,  plo.`Amount` ");     
        sb.Append(" FROM `patient_labinvestigation_opd` plo ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
        sb.Append(" INNER JOIN centre_master cm1 ON cm1.`CentreID`=plo.`TestCentreID` ");
        sb.Append(" AND lt.`IsCancel`=0 AND  plo.`IsSampleCollected`='Y' ");
        sb.Append(" AND plo.`TestCentreID` in("+Centre+") ");
        sb.Append(" AND plo.SampleDate>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00' and plo.SampleDate<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");
       
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "HLM Revenue From O/S Sample Report";
            HttpContext.Current.Session["Period"] = "From : " + dateFrom.ToString("dd-MMM-yyyy") + " To : " + dateTo.ToString("dd-MMM-yyyy");
            retValue = "1";
        }


        return retValue;
    }
}
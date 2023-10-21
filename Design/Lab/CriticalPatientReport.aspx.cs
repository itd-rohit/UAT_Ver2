using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_CriticalPatientReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    [WebMethod]
    public static Dictionary<string, string> getReport(string dtFrom, string dtTo, string CentreID)
    {

        DateTime dateFrom = Convert.ToDateTime(dtFrom);
        DateTime dateTo = Convert.ToDateTime(dtTo);
 	
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT cm.`Centre` BookingCentre,cm1.`Centre` ProcessingCentre, ");
        sb.Append(" DATE_FORMAT(lt.`Date`,'%d-%b-%y %h:%i %p') BookingDateTime,lt.`DoctorName`,s.`MOBILE_NO` ,s.`IsSend`, ");
        sb.Append("  lt.`LedgerTransactionNo` VisitNo, pli.`BarcodeNo` SinNo,lt.`Patient_ID` UHID,lt.`PName`,lt.`Age`,lt.`Gender`,  ");
        sb.Append("   pli.`ItemCode`, pli.`ItemName`,pli.`ApprovedName`,pli.`ApprovedDate`,  ");
        sb.Append("   plo.`LabObservationName`,plo.`Value`,plo.`MinValue`,plo.`MaxValue`,  ");
        sb.Append("  plo.`MinCritical`,plo.`MaxCritical`, plo.`Flag`,plo.`IsCritical`,plo.`ReadingFormat`,plo.`DisplayReading`,plo.`Method`  ");
        sb.Append(" FROM f_ledgertransaction lt ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` pli ON pli.`LedgerTransactionID`=lt.`LedgerTransactionID`  ");
        sb.Append("  AND pli.`Approved`=1 AND pli.IsActive=1 AND  lt.centreid IN({0})");
        sb.Append(" and pli.`ApprovedDate`>=@FromDate and pli.`ApprovedDate`<=@ToDate ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`   ");
        sb.Append("  INNER JOIN centre_master cm1 ON cm1.`CentreID`=pli.`TestCentreID`  ");
        sb.Append("  INNER JOIN `patient_labobservation_opd` plo ON plo.`Test_ID`=pli.`Test_ID`  ");
        sb.Append("  LEFT JOIN sms s ON s.`LedgerTransactionID`=lt.`LedgerTransactionID`    ");
        sb.Append("  AND s.`SMS_Type`='Critical' ");
        sb.Append(" WHERE plo.`IsCritical`=1 AND IFNULL(plo.`Value`,'') <>''   ");
        sb.Append(" ORDER BY lt.`LedgerTransactionID`  ");

        string Period = string.Concat("From : ", Util.GetDateTime(dateFrom).ToString("dd-MMM-yyyy"), " To : ", Util.GetDateTime(dateTo).ToString("dd-MMM-yyyy"));


        Dictionary<string, string> returnData = new Dictionary<string, string>();
        returnData.Add("ReportDisplayName", Common.EncryptRijndael("Critical Patient Report"));
        returnData.Add("CentreID#1", Common.EncryptRijndael(CentreID.TrimEnd(',')));   
        returnData.Add("FromDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(dateTo).ToString("yyyy-MM-dd"), " ", "00:00:00")));
        returnData.Add("ToDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(dateTo).ToString("yyyy-MM-dd"), " ", "23:59:59")));
        returnData.Add("Query", Common.EncryptRijndael(sb.ToString()));
        returnData.Add("Period", Common.EncryptRijndael(Period));
        returnData.Add("ReportPath", AllLoad_Data.ExportToExcelEncryptURL());
        returnData.Add("entrymonth", Common.EncryptRijndael("1"));
        return returnData;           
    }
}
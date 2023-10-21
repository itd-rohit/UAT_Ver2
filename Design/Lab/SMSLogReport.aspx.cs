using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_SMSLogReport : System.Web.UI.Page
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
    public static string getReport(string dtFrom, string dtTo)
    {
        string retValue = "0";

        DateTime dateFrom = Convert.ToDateTime(dtFrom);
        DateTime dateTo = Convert.ToDateTime(dtTo);

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.`Centre` BookingCentre,lt.`LedgerTransactionNo` VisitNo,lt.`Patient_ID` UHID,lt.`PName`,lt.`Age`,lt.`Gender`, ");
	sb.Append(" sm.`MOBILE_NO`,sm.SMS_TEXT,(CASE WHEN sm.`IsSend` =1 THEN 'Success' WHEN sm.`IsSend` =-1 THEN 'Fail' ELSE 'Pending' END )SMSStatus, ");
	sb.Append(" sm.`SMS_Type`, sm.`UserID`, DATE_FORMAT(sm.`EntDate`,'%d-%b-%Y %h:%i%p')EntDate ");
	sb.Append(" FROM sms sm ");
	sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=sm.`LedgerTransactionID` ");
	sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
        sb.Append(" where (sm.EntDate)>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00' and (sm.EntDate)<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");
       
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "SMS Log Report";
            HttpContext.Current.Session["Period"] = "From : " + dateFrom.ToString("dd-MMM-yyyy") + " To : " + dateTo.ToString("dd-MMM-yyyy");
            retValue = "1";
        }


        return retValue;
    }
}
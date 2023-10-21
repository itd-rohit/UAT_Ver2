using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_Lab_EmailReport : System.Web.UI.Page
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
    public static string getReport(string dtFrom, string dtTo, string MailedTo, string MailType, string CentreID)
    {
        string retValue = "0";

        DateTime dateFrom = Convert.ToDateTime(dtFrom);
        DateTime dateTo = Convert.ToDateTime(dtTo);
        double TotDays = (dateTo - dateFrom).TotalDays;
        if (TotDays > 31)
        {
            retValue = "-2";
            return retValue;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT t.* from ( ");
        sb.Append(" SELECT cm.`Centre`,lt.`PName`,lt.`LedgerTransactionNo` VisitNo,lt.LedgerTransactionID,lt.`Patient_ID` UHID, ");
        sb.Append(" em.`Name` EmailSentBy, IF(erp.`IsAutoMail`=1,'Auto','Manual')EMailSendType,if(erp.Test_ID='','Registration Email','PDF Report Email')EmailType,IF(erp.`IsSend`=1,'Succeed','Failed')Delivery, ");
        sb.Append(" erp.`EmailID` `To`,erp.`Cc`,erp.`Bcc`,DATE_FORMAT(erp.`dtEntry`,'%d-%b-%y %h:%i %p')DATE,erp.`MailedTo` ");
        // sb.Append(" ,IF(erp.`Remarks`<>'PDF Report Email' AND erp.`Remarks`<>'Registration Email','',erp.`Remarks`)Remarks ");
        sb.Append(" FROM f_ledgertransaction lt ");
        sb.Append(" INNER JOIN email_record_patient erp ON erp.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
        sb.Append(" and  lt.centreid in(" + CentreID.TrimEnd(',') + ") ");
        if (MailedTo.Trim() != "All")
            sb.Append(" and erp.MailedTo='" + MailedTo.Trim() + "'");
        if (MailType.Trim() != "All")
            sb.Append(" and erp.IsAutoMail='" + MailType.Trim() + "'");
        sb.Append(" and date(erp.dtEntry)>='" + dateFrom.ToString("yyyy-MM-dd") + "' and date(erp.dtEntry)<='" + dateTo.ToString("yyyy-MM-dd") + "' ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
        sb.Append(" Left JOIN employee_master em ON em.`Employee_ID`=erp.`UserID` " );//GROUP BY erp.`LedgerTransactionID`,erp.test_id"
        sb.Append(" Union All ");
        sb.Append(" SELECT cm.`Centre`,lt.`PName`,lt.`LedgerTransactionNo` VisitNo,lt.LedgerTransactionID,lt.`Patient_ID` UHID, ");
        sb.Append(" em.`Name` EmailSentBy, er.`Mailing_Type` EMailSendType,if(er.Test_ID='','Registration Email','PDF Report Email')EmailType,IF(er.`IsSent`=1,'Succeed','Failed')Delivery, ");
        sb.Append(" '' `To`,'' `Cc`,'' `Bcc`,DATE_FORMAT(er.`dtEntry`,'%d-%b-%y %h:%i %p')DATE,er.`EmailAddress` MailedTo ");
        // sb.Append(" ,IF(erp.`Remarks`<>'PDF Report Email' AND erp.`Remarks`<>'Registration Email','',erp.`Remarks`)Remarks ");
        sb.Append(" FROM f_ledgertransaction lt ");
        sb.Append(" INNER JOIN email_record  er    ON er.LedgerTransactionNo = lt.`LedgerTransactionNo`  ");
        sb.Append(" and  lt.centreid in(" + CentreID.TrimEnd(',') + ") ");
     //   if (MailedTo.Trim() != "All")
          //  sb.Append(" and erp.MailedTo='" + MailedTo.Trim() + "'");
        // (MailType.Trim() != "All")
        //    sb.Append(" and erp.IsAutoMail='" + MailType.Trim() + "'");
        sb.Append(" AND DATE(er.dtEntry) >='" + dateFrom.ToString("yyyy-MM-dd") + "' AND DATE(er.dtEntry) <='" + dateTo.ToString("yyyy-MM-dd") + "' ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
        sb.Append(" Left JOIN employee_master em ON em.`Employee_ID`=er.`EmployeeID`  ");//GROUP BY erp.`LedgerTransactionID`,erp.test_id
        sb.Append(" )t GROUP BY LedgerTransactionID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Email Report";
            HttpContext.Current.Session["Period"] = "From : " + dateFrom.ToString("dd-MMM-yyyy") + " To : " + dateTo.ToString("dd-MMM-yyyy");
            retValue = "1";
        }

        return retValue;
    }
}
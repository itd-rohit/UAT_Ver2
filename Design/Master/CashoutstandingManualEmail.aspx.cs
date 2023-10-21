using System;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_Master_CashoutstandingManualEmail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
    }

    [WebMethod]
    public static string BindData(string AllEmployee, DateTime fromdate, DateTime toDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT fl.`LedgerTransactionID`,fl.`LedgerTransactionNo`,fl.`BillNo`,DATE_FORMAT(fl.`Date`,'%d-%b-%Y')BillDATE,fl.`PName`,fl.age,fl.gender,IFNULL(fl.`GrossAmount`,0)GrossAmount,IFNULL(fl.`NetAmount`,0)NetAmount,");
        sb.Append("IFNULL(fl.`DiscountOnTotal`,0)DiscountOnTotal,IFNULL(fl.`CashOutstanding`,0)CashOutstanding,fl.`OutstandingStatus`,fl.`OutstandingEmployeeId`,em.`Name`,em.email,cm.centre,CASE WHEN fl.OutstandingStatus=0 THEN '#FFC0CB' WHEN fl.OutstandingStatus=1 THEN '#90EE90' WHEN fl.OutstandingStatus=-1 THEN '#00FFFF' END rowcolor FROM Email_Cashoutstanding emc ");
        sb.Append("INNER JOIN f_ledgertransaction fl ON fl.`LedgerTransactionID`=emc.`LedgerTransactionID`  INNER JOIN employee_master em ON em.employee_id=fl.`OutstandingEmployeeId`");
        sb.Append("INNER JOIN centre_master cm ON cm.centreid=fl.centreid WHERE fl.CashOutstanding> 0  ");
        if (fromdate.ToString() != "" && toDate.ToString() != "" && AllEmployee == "")
        {
            sb.Append("  and fl.Date >= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' AND fl.Date <= '" + toDate.ToString("yyyy-MM-dd") + " 23:59:59'  ");
        }
        if (AllEmployee != "")
        {
            sb.Append(" and fl.`OutstandingEmployeeId` in (" + AllEmployee + ")");
        }

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
    }

    [WebMethod]
    public static string SendOutstandingVerificationmail(string LedgerTransactionID)
    {
        CashoutstandingEmail sendmail = new CashoutstandingEmail();
        return sendmail.SendOutstandingVerificationmail(LedgerTransactionID, 0);
    }

    [WebMethod(EnableSession = true)]
    public static string bindEmployee()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT DISTINCT em.employee_id,em.NAME FROM employee_master em INNER JOIN Email_Cashoutstanding ec ON em.`Employee_ID`=ec.`Employee_ID` ORDER BY NAME"));
    }
}
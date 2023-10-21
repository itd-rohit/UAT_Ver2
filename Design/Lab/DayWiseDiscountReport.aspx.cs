using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class DayWiseDiscountReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtfromdate, txttodate);
        }
    }


    [WebMethod(EnableSession = true)]
    public static string bindCentre()
    {

        StringBuilder sb = new StringBuilder();
        DataTable dt = AllLoad_Data.getCentreByTagBusinessLab();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(string FromDate, string ToDate, string CentreId)
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT DATE_FORMAT(lt.Date,'%d-%b-%Y %h:%i %p')EntryDate, lt.`CreatorName` UserName, CONCAT(em.`Title`,' ',em.`Name`) ApprovedBy,CONCAT(lt.`PName`,'(',GROUP_CONCAT(plo.`ItemName`),')') PName ");
            sb.Append(" ,lt.`DiscountReason`,lt.LedgertransactionNo VisitNumber, ");
            sb.Append(" (em.`DiscountPerMonth`-(IFNULL((SELECT SUM(DiscountOnTotal)  ");
            sb.Append(" FROM `f_ledgertransaction`  ");
            sb.Append(" WHERE DiscountApprovedByID=lt.`DiscountApprovedByID`  ");
            sb.Append(" AND DATE >= CONCAT(DATE_FORMAT(NOW() ,'%Y-%m-01'),' 00:00:00')),0))) RemainingDiscountAmount ");
            sb.Append(" FROM f_ledgertransaction lt ");
            sb.Append(" INNER JOIN Patient_labInvestigation_OPD plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN employee_Master em ON lt.`DiscountApprovedByID`=em.`Employee_ID` ");
            sb.Append(" WHERE lt.`IsDiscountApproved`=1 ");
            sb.Append(" AND lt.Date>= '"+Util.GetDateTime(FromDate).ToString("yyyy-MM-dd")+" 00:00:00' ");
            sb.Append(" AND lt.Date<= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");

            if (CentreId != "")
            {
                sb.Append(" AND lt.`CentreId` IN (" + CentreId + ") ");
            }

            sb.Append(" GROUP BY plo.LedgertransactionID ORDER BY EntryDate DESC ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "Discount Report";
                return "1";
            }
            else
            {
                return "0";
            }
        }
        catch (Exception ex)
        {
            return "0";
        }
    }



}
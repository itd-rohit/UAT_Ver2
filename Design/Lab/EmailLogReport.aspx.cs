using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Lab_EmailLogReport : System.Web.UI.Page
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
            sb.Append("  SELECT lt.LedgertransactionNo VisitNo, DATE_FORMAT(del.SendOn,'%d-%b-%Y %h:%i %p') MailSentOn,CONCAT(em.Title,' ',em.Name) MailedTo,del.Email,  ");
            sb.Append(" IF(lt.IsDiscountApproved=1,'Approved','Not-Approved') IsApproved,lt.DiscountApprovedByName ApprovedBy,DATE_FORMAT(lt.DiscountApprovedDate,'%d-%b-%Y %h:%i %p') ApprovedOn ");
            sb.Append(" FROM DiscountEmail_log del ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON del.LedgertransactionNo=lt.LedgertransactionId ");
            sb.Append(" INNER JOIN Employee_master em ON em.Employee_Id=del.EmployeeId where ");
            sb.Append("   del.SendOn >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND del.SendOn <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59'");
            if (CentreId != "")
            {
                sb.Append(" AND lt.`CentreID` IN (" + CentreId + ") ");
            }
            sb.Append(" ORDER BY del.SendOn DESC ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "DiscountEmailLogReport";
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
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Lab_AmmendmentReport : System.Web.UI.Page
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
        using (DataTable dt = StockReports.GetDataTable("SELECT CentreID,Centre FROM Centre_Master WHERE  Category='LAB' AND ISActive=1 ORDER BY Centre"))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string bindSubcategory()
    {

        StringBuilder sb = new StringBuilder();
        using (DataTable dt = StockReports.GetDataTable("SELECT SubCategoryID,NAME FROM f_subcategorymaster WHERE Active=1 ORDER BY NAME"))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(string FromDate, string ToDate, string CentreId, string SubcategoryId)
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT DATE_FORMAT(RU.`UnapproveDate`,'%d-%b-%Y %h:%i %p') UnapproveDate,RU.`Unapproveby`, CM.`Centre` ProcessingLab, ");
            sb.Append(" lt.`LedgerTransactionNo` VisitNo,lt.`PName`,lt.`Age`,lt.`Gender`,plo.`InvestigationName`");
            sb.Append(" FROM report_unapprove RU ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd_notapprove PLO ON PLO.`Test_ID`=RU.`Test_ID`");
            sb.Append(" INNER JOIN f_Ledgertransaction lt ON lt.`LedgerTransactionID`=PLO.`LedgerTransactionID`");
            sb.Append(" INNER JOIN Centre_Master CM ON CM.`CentreID`=plo.`TestCentreID`");
            sb.Append(" WHERE RU.UnapproveDate >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND  RU.UnapproveDate <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59'");

            if (CentreId != "")
            {
                sb.Append(" AND plo.`TestCentreID` IN (" + CentreId + ") ");
            }

            if (SubcategoryId != "")
            {
                sb.Append(" AND plo.`SubcategoryID` IN (" + CentreId + ") ");
            }

            sb.Append(" ORDER BY RU.UnapproveDate DESC ");

            using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            {

                if (dt.Rows.Count > 0)
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = "Ammendment_Report";
                    return "1";
                }
                else
                {
                    return "0";
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }



}
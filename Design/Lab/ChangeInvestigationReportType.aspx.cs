using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_ChangeInvestigationReportType : System.Web.UI.Page
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
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetTestMaster()
    {
        using (DataTable dt = StockReports.GetDataTable("select IF(im.TestCode='',typename,CONCAT(im.TestCode,' ~ ',typename)) testname,im.`ItemID` testid from f_itemmaster im where isactive=1 and im.subcategoryid<>'LSHHI44' order by testname"))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string GetData(string fromdate, string todate, string labno, string itemid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT plo.`Test_ID`,plo.LedgerTransactionNO,plo.`ItemName`,plo.`ReportType`,im.`ReportType` masterReportType, ");
        sb.Append(" (CASE WHEN plo.`ReportType`=1 THEN 'Path Numeric' WHEN plo.`ReportType`=3 THEN 'Path RichText' WHEN plo.`ReportType`=5 THEN 'Radiology' WHEN plo.`ReportType`=7 THEN 'Histo Report' END )treport, ");
        sb.Append(" (CASE WHEN im.`ReportType`=1 THEN 'Path Numeric' WHEN im.`ReportType`=3 THEN 'Path RichText' WHEN im.`ReportType`=5 THEN 'Radiology' WHEN im.`ReportType`=7 THEN 'Histo Report' END )mreport ");
        sb.Append(" FROM patient_labinvestigation_opd plo INNER JOIN investigation_master im ON plo.`Investigation_ID`=im.`Investigation_Id` AND plo.`ReportType`!=im.`ReportType`");
        sb.Append("  INNER JOIN `f_ledgertransaction` lt  ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");
        sb.Append(" where plo.approved=0 AND plo.`IsReporting`=1 ");
        if (labno != "")
        {
            sb.Append(" And plo.LedgerTransactionNO='" + labno + "'");

        }
        else
        {
            if (itemid != "" && itemid != "0")
            {
                sb.Append(" And plo.Date >='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' AND plo.Date<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' AND plo.`Investigation_ID`='" + itemid + "'");
            }

        }
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string UpdateData(string testid, string reporttype)
    {

        StockReports.ExecuteDML("Update patient_labinvestigation_opd set ReportType='" + reporttype + "' where Test_ID='" + testid + "'");
        return "1";
    }

}
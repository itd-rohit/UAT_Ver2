using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_SummaryReportOfEQAS : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {




            ddlcentretype.DataSource = StockReports.GetDataTable(@" SELECT DISTINCT TYPE1id,TYPE1  FROM centre_master WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY TYPE1");
            ddlcentretype.DataValueField = "TYPE1id";
            ddlcentretype.DataTextField = "TYPE1";
            ddlcentretype.DataBind();
            ddlcentretype.Items.Insert(0, new ListItem("Type", "0"));


            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");


        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }


    [WebMethod(EnableSession = true)]
    public static string bindCentre(string TypeId)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT centreid,centre FROM centre_master   WHERE Type1Id =" + TypeId + " and centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY centre"));


    }

    [WebMethod]
    public static string Getsummaryreport(string processingcentre, string dtFrom, string dtTo, string status)
    {
        StringBuilder sb = new StringBuilder();
        DateTime dateFrom = Convert.ToDateTime(dtFrom);
        DateTime dateTo = Convert.ToDateTime(dtTo);

        sb.Append(" SELECT cm.`Centre`,qe.`ProgramName`,qe.`ProgramNo`,qe.`CycleNo`, ");
        sb.Append(" DATE_FORMAT(qe.`EntryDateTime`,'%d-%b-%Y')EntryDate, plo.`SampleTypeName`,plo.`BarcodeNo` SinNo,  ");
        sb.Append(" plo.`ItemName` InvestigationName,qe.`LabObservationName`,qe.`Value` LabValue,ifnull(qe.eqasvalue,'')EQASValue,ifnull(qe.EQASStatus,'')  EQASStatus, ");
        sb.Append(" IFNULL(rl.rate,0) MRP_Rate");
        sb.Append(" FROM qc_eqasregistration qe ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=qe.`CentreID` ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`Test_ID`=qe.`Test_id` ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
        sb.Append(" LEFT JOIN f_ratelist rl ON rl.`ItemID`=plo.`ItemId` AND rl.`Panel_ID`=lt.`Panel_ID` ");
        sb.Append(" WHERE qe.CentreID in (" + processingcentre + ")  and qe.isreject=0 ");
        if (status != "")
        {
            sb.Append(" and qe.EQASStatus='" + status + "'");
        }
        sb.Append(" AND qe.EntryDateTime>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00'");
        sb.Append(" AND qe.entrydatetime<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" order by Centre, qe.EntryDateTime");


        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {

            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "EQASSummaryReport";
            return "1";
        }
        else
        {
            return "No Record Found";
        }
    }
}
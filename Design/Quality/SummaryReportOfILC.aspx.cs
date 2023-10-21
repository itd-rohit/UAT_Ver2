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
public partial class Design_Quality_SummaryReportOfILC : System.Web.UI.Page
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

        sb.Append("   SELECT cm.`CentreCode`,cm.`Centre` ,qir.ilclabname, DATE_FORMAT(entrydatetime, '%d-%b-%Y') 'entrydatetime', ");
        sb.Append(" plo.`ItemName` TestName,plo.SampleTypeId ,plo.SampleTypeName ,IFNULL(lom.`Name`, '') ParameterName,qir.oldvalue 'LaboratoryValue', ");
        sb.Append("  qir.newvalue 'Referancelabvalue', qir.Variation 'PercentageDifference',qir.Acceptable 'AccepetanceCirteria',qir.Status  ");
        sb.Append(" FROM `qc_ilcregistration` qil  INNER JOIN centre_master cm ON cm.`CentreID` = qil.`CentreID`  ");
        sb.Append("      INNER JOIN `patient_labinvestigation_opd` plo  ON plo.`Test_ID` = qil.`Test_id`  ");
        sb.Append("  INNER JOIN `f_ledgertransaction` lt  ON lt.`LedgerTransactionID` = plo.`LedgerTransactionID`  ");
        sb.Append(" INNER JOIN `qc_ilcresultentry` qir   ON qil.`Test_id` = qir.`Test_id`  ");
        sb.Append("  LEFT JOIN `labobservation_master` lom  ON lom.`LabObservation_ID` = qil.`LabObservationID`  ");
        sb.Append(" WHERE isreject = 0 ");
        sb.Append(" and qil.centreid in (" + processingcentre + ") ");
        if (status != "")
        {
            sb.Append(" and qir.Status='"+status+"'");
        }
        sb.Append(" AND entrydatetime>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00'");
        sb.Append(" AND entrydatetime<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");

        sb.Append(" order by entrydatetime ");



        DataTable dt = StockReports.GetDataTable(sb.ToString());
        StringBuilder stTable = new StringBuilder();
        if (dt.Rows.Count > 0)
        {
            stTable.Append("   <table border='1'>  ");
            stTable.Append(" <tr> ");
            stTable.Append("   <td colspan='10' style='text-align:center'><b>Summry Report of ILC</b></td> ");

            stTable.Append(" </tr> ");
            stTable.Append("  <tr> ");
            stTable.Append("   <td colspan='3' style='text-align:center'><b>Lab Name:</b></td> ");
            stTable.Append("    <td colspan='2' style='text-align:center'><b>" + dt.Rows[0]["Centre"].ToString() + "</b></td> ");
            stTable.Append("    <td colspan='3' style='text-align:center'><b>Referance lab Name:</b></td> ");
            stTable.Append("   <td colspan='2' style='text-align:center'><b>" + dt.Rows[0]["ilclabname"].ToString() + " </b></td> ");


            stTable.Append("  </tr> ");
            stTable.Append("   <tr> ");
            stTable.Append("  <td  style='text-align:left'><b>S.No</b></td> ");
            stTable.Append("  <td  style='text-align:left'><b>Sample run Date</b></td> ");
            stTable.Append("  <td  style='text-align:left'><b>Sample </b></td> ");
            stTable.Append("  <td  style='text-align:left'><b>Test Name</b></td> ");
            stTable.Append("  <td  style='text-align:left'><b>Parameter</b></td> ");
            stTable.Append("  <td  style='text-align:left'><b>Laboratory Value</b></td> ");
            stTable.Append("  <td  style='text-align:left'><b>Referance lab value</b></td> ");
            stTable.Append("  <td  style='text-align:left'><b>Percentage Difference</b></td> ");
            stTable.Append("  <td  style='text-align:left'><b>Accepetance Cirteria</b></td> ");
            stTable.Append("  <td  style='text-align:left'><b>Accepted  / UnAccepeted</b></td> ");
            stTable.Append("  </tr> ");
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                stTable.Append("   <tr> ");
                stTable.Append("  <td  style='text-align:left'>" + (i + 1) + "</td> ");
                stTable.Append("  <td  style='text-align:left'>" + dt.Rows[i]["entrydatetime"].ToString() + "</td> ");
                stTable.Append("  <td  style='text-align:left'>" + dt.Rows[i]["SampleTypeName"].ToString() + " </td> ");
                stTable.Append("  <td  style='text-align:left'>" + dt.Rows[i]["TestName"].ToString() + "</td> ");
                stTable.Append("  <td  style='text-align:left'>" + dt.Rows[i]["ParameterName"].ToString() + "</td> ");
                stTable.Append("  <td  style='text-align:left'>" + dt.Rows[i]["LaboratoryValue"].ToString() + "</td> ");
                stTable.Append("  <td  style='text-align:left'>" + dt.Rows[i]["Referancelabvalue"].ToString() + "</td> ");
                stTable.Append("  <td  style='text-align:left'>" + dt.Rows[i]["PercentageDifference"].ToString() + "</td> ");
                stTable.Append("  <td  style='text-align:left'>" + dt.Rows[i]["AccepetanceCirteria"].ToString() + "</td> ");
                stTable.Append("  <td  style='text-align:left'>" + dt.Rows[i]["Status"].ToString() + "</td> ");
                stTable.Append("  </tr> ");
            }

            stTable.Append(" </table> ");


            return stTable.ToString();

        }


        else
        {
            return "false";
        }
    }
}
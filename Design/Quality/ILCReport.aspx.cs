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

public partial class Design_Quality_ILCReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           

            dtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            dtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            ddlcentretype.DataSource = StockReports.GetDataTable(@" SELECT DISTINCT TYPE1id,TYPE1  FROM centre_master WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY TYPE1");
            ddlcentretype.DataValueField = "TYPE1id";
            ddlcentretype.DataTextField = "TYPE1";
            ddlcentretype.DataBind();
            ddlcentretype.Items.Insert(0, new ListItem("Type", "0"));


            ddlcurrentmonth.SelectedValue = DateTime.Now.Month.ToString();
            ddlyear.SelectedValue = DateTime.Now.Year.ToString();
           
            
        }
    }


    [WebMethod(EnableSession = true)]
    public static string bindCentre(string TypeId)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT centreid,centre FROM centre_master   WHERE Type1Id =" + TypeId + " and centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY centre"));


    }


    [WebMethod]
    public static string Getsummaryreport(string processingcentre, string cmonth, string cyear,string dtFromDate,string dtToDate)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT ");
        sb.Append(" cm.`CentreCode`,cm.`Centre`,MONTHNAME(STR_TO_DATE(qil.`EntryMonth`, '%m'))EntryMonth,qil.EntryYear, ");
        sb.Append(" qir.ILCLabType ILCLabType,qir.ilclabname ILCLabName,");
        sb.Append(" DATE_FORMAT(entrydatetime,'%d-%b-%Y')EntryDate, ");
        sb.Append(" qil.`LedgerTransactionNo` `Visitno`,qil.`BarcodeNo` SInNo, ");
        sb.Append(" plo.`ItemName` TestName,IFNULL(lom.`Name`,'') ParameterName,qil.`EntryByName`, ");
        sb.Append(" qir.oldvalue  LocalLaboratoryResult,qir.newvalue ReferralLabResult, qir.Variation DifferencePercentage,qir.Acceptable,");
        sb.Append(" qir.Status,qir.Remarks ResultRemark,qir.ApprovedByName SignOffBy,DATE_FORMAT(qir.ApproveDate,'%d-%b-%Y')SignOffDate,");
        sb.Append(" IFNULL(rl.rate,0) MRP_Rate");
       
        sb.Append(" FROM `qc_ilcregistration` qil ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=qil.`CentreID`  ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`Test_ID`=qil.`Test_id` ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
        sb.Append(" LEFT JOIN f_ratelist rl ON rl.`ItemID`=plo.`ItemId` AND rl.`Panel_ID`=lt.`Panel_ID` ");
        sb.Append(" INNER JOIN `qc_ilcresultentry` qir ON qil.`Test_id`=qir.`Test_id`  ");//and qir.approved=1

        sb.Append(" LEFT JOIN `labobservation_master` lom ON lom.`LabObservation_ID`=qil.`LabObservationID` ");
      //  sb.Append(" WHERE isreject=0  AND qil.entrymonth=" + cmonth + " AND qil.entryyear=" + cyear + "  ");
        sb.Append(" WHERE isreject=0  AND  qil.EntryDateTime >= '"+Util.GetDateTime(dtFromDate).ToString("yyyy-MM-dd")+" 00:00:00' ");
        sb.Append(" AND qil.EntryDateTime <= '"+Util.GetDateTime(dtToDate).ToString("yyyy-MM-dd")+" 23:59:59' ");
        if (processingcentre != "")
        {
            sb.Append(" and qil.centreid in (" + processingcentre + ")");
        }

        sb.Append(" order by Centre,qil.EntryYear,qil.`EntryMonth`");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataColumn column = new DataColumn();
        column.ColumnName = "S.No";
        column.DataType = System.Type.GetType("System.Int32");
        column.AutoIncrement = true;
        column.AutoIncrementSeed = 0;
        column.AutoIncrementStep = 1;

        dt.Columns.Add(column);
        int index = 0;
        foreach (DataRow row in dt.Rows)
        {
            row.SetField(column, ++index);
        }
        dt.Columns["S.No"].SetOrdinal(0);
        if (dt.Rows.Count > 0)
        {

            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "ILCSummaryReport";
            return "true";
        }
        else
        {
            return "false";
        }
    }
}
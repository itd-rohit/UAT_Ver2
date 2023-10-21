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


public partial class Design_Quality_EQASReport : System.Web.UI.Page
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
    public static string Getsummaryreport(string processingcentre, string cmonth, string cyear)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" select qcr.centreid, cm.Centre,");

        sb.Append(" (SELECT `EqasProviderName` FROM `qc_eqasprovidermaster` qe  ");
        sb.Append(" INNER JOIN qc_eqasprogrammaster qeq ON qe.EQASProviderID=qeq.EQASProviderID WHERE qeq.programid=qcr.programid LIMIT 1)ProvideName,");
        sb.Append(" qcr.programid,(SELECT programname FROM `qc_eqasprogrammaster` WHERE programid=qcr.programid limit 1 )programname");
        sb.Append(" ,qcr.test_id,plo.barcodeno SinNo, ");
        sb.Append(" DATE_FORMAT(plo.date,'%d-%b-%Y') regdate,sm.name departmant,plo.InvestigationName, ");
        sb.Append(" IFNULL(ploo.`Value`,ifnull(qcr.value,'')) ResultValue,IFNULL(ploo.minvalue,'') minvalue,IFNULL(ploo.`MaxValue`,'')`MaxValue`, ");
        sb.Append(" ifnull(ploo.MacReading,'')MacReading ,ifnull(ploo.MachineName,'')MachineName, ");
        sb.Append(" IFNULL(ploo.`DisplayReading`,'')DisplayReading,IFNULL(ploo.`ReadingFormat`,'')Unit,IFNULL(ploo.flag,'')flag, ");
        sb.Append(" ifnull(qcr.RCA,'')RCA ,ifnull(qcr.CorrectiveAction,'') CorrectiveAction ,ifnull(qcr.PreventiveAction,'') PreventiveAction ,ifnull(qcr.EQASVALUE,'')EQASVALUE");
        sb.Append(" ,(case when qcr.EQASDone=1 then 'EQASDone' when qcr.ResultUploaded=1 then 'ResultUploaded' when qcr.Approved=1 then 'Approved'  when qcr.result_flag=1 then 'ResultDone' else 'New' end)CurrentStatus ");
        sb.Append(" ,if(ResultUploaded=1,date_format(ExpectedResultDate,'%d-%b-%Y'),'')ExpectedResultDate ");

        sb.Append(" FROM `qc_eqasregistration` qcr  ");
        sb.Append(" inner join centre_master cm on cm.centreid=qcr.centreid ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`Test_ID`=qcr.`Test_id` ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
        sb.Append(" LEFT JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID` AND ploo.`LabObservation_ID`=qcr.`LabObservationID` ");

        sb.Append(" WHERE  isreject=0  AND entrymonth=" + cmonth + " AND entryyear=" + cyear + "  ");


        if (processingcentre != "")
        {
            sb.Append(" and qcr.centreid in (" + processingcentre + ")");
        }

        sb.Append(" order by Centre,qcr.EntryYear,qcr.`EntryMonth`,qcr.programid,InvestigationName ");

        // System.IO.File.WriteAllText(@"F:\A_InvReprint.txt", sb.ToString());
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
            HttpContext.Current.Session["ReportName"] = "EQASummaryReport";
            return "true";
        }
        else
        {
            return "false";
        }
    }
}
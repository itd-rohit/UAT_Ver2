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

public partial class Design_Quality_EQAS_Sumarry_Report_ForSingleLabs : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {


        StringBuilder str = new StringBuilder();
        if (!IsPostBack)
        {


           
            ddlmachine.DataSource = StockReports.GetDataTable("SELECT id,name from macmaster where isactive=1  order BY name");
            ddlmachine.DataValueField = "id";
            ddlmachine.DataTextField = "name";
            ddlmachine.DataBind();
            ddlmachine.Items.Insert(0, new ListItem("Select Machine", "0"));


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
    public static string Getsummaryreport(string processingcentre, string dtFrom, string dtTo, string machine)
    {
        StringBuilder sb = new StringBuilder();
        DateTime dateFrom = Convert.ToDateTime(dtFrom);
        DateTime dateTo = Convert.ToDateTime(dtTo);


        if (((dateTo - dateFrom).TotalDays > 30))
        {
            return "-2";
        }


        sb.Append("  SELECT cm.Centre Centre,IFNULL(mc.Name,'')MachineName,  ");
        sb.Append("  qcr.labobservationname  Parameter, ");
        sb.Append("  qcr.value Result, ");

        sb.Append("  (select round(AVG(qcr1.value),2)  from qc_eqasregistration qcr1  ");
        sb.Append(" WHERE  isreject=0  and IsNumeric(qcr1.value)=1");
        sb.Append(" AND qcr1.entrydatetime>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00'");
        sb.Append(" AND qcr1.entrydatetime<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" and qcr1.LabObservationID=qcr.LabObservationID");
        if (machine != "0")
        {
            sb.Append(" and qcr1.machineid='" + machine + "'");
        }
        sb.Append(" )Peer_Group_Mean, ");


        sb.Append("  (select round(STDDEV(qcr1.value),2)  from qc_eqasregistration qcr1  ");
        sb.Append(" WHERE  isreject=0  and IsNumeric(qcr1.value)=1");
        sb.Append(" AND qcr1.entrydatetime>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00'");
        sb.Append(" AND qcr1.entrydatetime<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" and qcr1.LabObservationID=qcr.LabObservationID");
        if (machine != "0")
        {
            sb.Append(" and qcr1.machineid='" + machine + "'");
        }
        sb.Append(" )Peer_Group_SD, ");

        sb.Append("  (select min(qcr1.value)  from qc_eqasregistration qcr1  ");
        sb.Append(" WHERE  isreject=0  and IsNumeric(qcr1.value)=1");
        sb.Append(" AND qcr1.entrydatetime>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00'");
        sb.Append(" AND qcr1.entrydatetime<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" and qcr1.LabObservationID=qcr.LabObservationID");
        if (machine != "0")
        {
            sb.Append(" and qcr1.machineid='" + machine + "'");
        }
        sb.Append(" )Peer_Group_LOW_Range, ");


        sb.Append("  (select max(qcr1.value)  from qc_eqasregistration qcr1  ");
        sb.Append(" WHERE  isreject=0  and IsNumeric(qcr1.value)=1");
        sb.Append(" AND qcr1.entrydatetime>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00'");
        sb.Append(" AND qcr1.entrydatetime<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" and qcr1.LabObservationID=qcr.LabObservationID");
        if (machine != "0")
        {
            sb.Append(" and qcr1.machineid='" + machine + "'");
        }
        sb.Append(" )Peer_Group_High_Range ");



        sb.Append(" FROM `qc_eqasregistration` qcr   ");
        sb.Append(" INNER JOIN centre_master cm ON cm.centreid=qcr.centreid  ");
        if (processingcentre != "" && processingcentre != null && processingcentre != "null")
        {
            sb.Append(" and cm.centreid=" + processingcentre + " ");
        }
        sb.Append(" left join macmaster mc on mc.id=qcr.machineid");
     
        sb.Append(" WHERE  isreject=0  ");
        sb.Append(" AND qcr.entrydatetime>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00'");
        sb.Append(" AND qcr.entrydatetime<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" and IsNumeric(qcr.value)=1 ");
        if (machine != "0")
        {
            sb.Append(" and qcr.machineid='" + machine + "'");
        }


        sb.Append(" ORDER BY labobservationname   ");

        DataTable dt_AllData = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt_AllData);


    }


}
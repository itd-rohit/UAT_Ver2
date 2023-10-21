using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_SigmaAnalysisReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlcurrentmonth.SelectedValue = DateTime.Now.AddMonths(-1).Month.ToString();
            ddlyear.SelectedValue = DateTime.Now.Year.ToString();
            ddlcentretype.DataSource = StockReports.GetDataTable(@" SELECT DISTINCT TYPE1id,TYPE1  FROM centre_master WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY TYPE1");
            ddlcentretype.DataValueField = "TYPE1id";
            ddlcentretype.DataTextField = "TYPE1";
            ddlcentretype.DataBind();
            ddlcentretype.Items.Insert(0, new ListItem("Type", "0"));

            ddlmachine.DataSource = StockReports.GetDataTable("SELECT ID MACHINEID,NAME MACHINENAME FROM MACMASTER where isactive=1 ORDER BY MACHINENAME");
            ddlmachine.DataValueField = "MACHINEID";
            ddlmachine.DataTextField = "MACHINENAME";
            ddlmachine.DataBind();
            ddlmachine.Items.Insert(0, new ListItem("Select Machine", "0"));
         
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindCentre(string TypeId)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT centreid,centre FROM centre_master   WHERE Type1Id =" + TypeId + " and centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY centre"));
    }
    [WebMethod]
    public static string Getsummaryreport(string processingcentre, int month, string year, string machine)
    {

        int days = DateTime.DaysInMonth(Util.GetInt(year), Util.GetInt(month));
        string fromdate = "01-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(month) + "-" + year;
        string todate = days + "-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(month) + "-" + year;



        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT cm.centre,mm.name MachineName, `LabObservation_Name`,IFNULL(qcs.CLIA,'10')`TotalAllowableError`, ");
        sb.Append("  `Level` ,");
        sb.Append("  ROUND((STDDEV(moq.reading )/AVG(moq.reading)*100),3) CurrentLabCVPer,Round(AVG(moq.reading),3) LabMean,");

        sb.Append("  (SELECT ROUND(AVG(reading),3) FROM " + Util.getApp("MachineDB") +".`mac_observation_qc` moq1 ");
        sb.Append("  INNER JOIN " + Util.getApp("MachineDB") + ".`mac_machinemaster` mo1 ON moq1.`Machine_Id`=mo1.`MACHINEID`");
        sb.Append("  INNER JOIN macmaster mm1 ON mm1.id=mo1.groupid");
        if (machine != "0")
        {
            sb.Append(" and mm1.id=" + machine + "");
        }
        sb.Append("  WHERE moq1.levelid=moq.levelid ");
        sb.Append("  AND moq1.LabObservation_ID=moq.`LabObservation_ID`  ");
        sb.Append("  AND moq1.dtentry>='"+Util.GetDateTime(fromdate).ToString("yyyy-MM-dd")+" 00:00:00'");
        sb.Append("  AND moq1.dtentry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append("  AND mm1.id=mm.id)PeerMean");

        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc`  moq");
        sb.Append("  INNER JOIN centre_master cm ON cm.centreid=moq.`centreid` AND cm.centreid=" + processingcentre + "");
        sb.Append("  INNER JOIN " + Util.getApp("MachineDB") + ".`mac_machinemaster` mo ON moq.`Machine_Id`=mo.`MACHINEID`");
        sb.Append("  INNER JOIN macmaster mm ON mm.id=mo.groupid");
        if (machine != "0")
        {
            sb.Append(" and mm.id="+machine+"");
        }
        sb.Append("  LEFT JOIN qc_sigmaanalysisclia qcs ON qcs.`LabObservationID`=moq.`LabObservation_ID`");
        sb.Append("  where moq.dtentry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'");
        sb.Append("  AND moq.dtentry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append("  GROUP BY moq.`centreid`,mm.id,moq.`LabObservation_ID`,moq.`LevelID`");
        sb.Append("  ORDER BY cm.centre,mm.name,LabObservation_Name,moq.`LevelID`");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
}
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_Quality_QCMISReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (UserInfo.Centre != 1)
            {
                ddlprocessinglab.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 ORDER BY centre");
            }
            else
            {
                ddlprocessinglab.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master)  and cm.isActive=1 ORDER BY centre");
            }
            ddlprocessinglab.DataValueField = "centreid";
            ddlprocessinglab.DataTextField = "centre";
            ddlprocessinglab.DataBind();
            ddlprocessinglab.Items.Insert(0, new ListItem("Select Centre ", "0"));



            ddlprocessinglab1.DataSource = ddlprocessinglab.DataSource;
            ddlprocessinglab1.DataValueField = "centreid";
            ddlprocessinglab1.DataTextField = "centre";
            ddlprocessinglab1.DataBind();
            ddlprocessinglab1.Items.Insert(0, new ListItem("Select Centre ", "0"));

            lstcentre.DataSource = ddlprocessinglab.DataSource;
            lstcentre.DataValueField = "centreid";
            lstcentre.DataTextField = "centre";
            lstcentre.DataBind();


            lstcenterday.DataSource = ddlprocessinglab.DataSource;
            lstcenterday.DataValueField = "centreid";
            lstcenterday.DataTextField = "centre";
            lstcenterday.DataBind();

            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            txtdatefromday.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtdatetoday.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            DateTimeFormatInfo info = DateTimeFormatInfo.GetInstance(null);
            for (int a = 1; a < 13; a++)
            {
                ddlfrommonth.Items.Add(new ListItem(info.GetMonthName(a), a.ToString()));
                ddltomonth.Items.Add(new ListItem(info.GetMonthName(a), a.ToString()));
                ddlmonthmonthwise.Items.Add(new ListItem(info.GetMonthName(a), a.ToString()));
                ddlmonthmonthwiseto.Items.Add(new ListItem(info.GetMonthName(a), a.ToString()));
            }

            ListItem selectedListItem = ddlfrommonth.Items.FindByValue(DateTime.Now.Month.ToString());

            if (selectedListItem != null)
            {
                selectedListItem.Selected = true;
            }

            ListItem selectedListItem1 = ddltomonth.Items.FindByValue(DateTime.Now.Month.ToString());

            if (selectedListItem1 != null)
            {
                selectedListItem1.Selected = true;
            }

            ListItem selectedListItem111 = ddlmonthmonthwise.Items.FindByValue(DateTime.Now.Month.ToString());

            if (selectedListItem111 != null)
            {
                selectedListItem111.Selected = true;
            }

            ListItem selectedListItem1111 = ddlmonthmonthwiseto.Items.FindByValue(DateTime.Now.Month.ToString());

            if (selectedListItem1111 != null)
            {
                selectedListItem1111.Selected = true;
            }

            for (int a = DateTime.Now.Year - 2; a < DateTime.Now.Year + 10; a++)
            {
                ddlyear.Items.Add(new ListItem(a.ToString(), a.ToString()));
                ddlyearmonthwise.Items.Add(new ListItem(a.ToString(), a.ToString()));
            }

            ListItem selectedListItem11 = ddlyear.Items.FindByValue(DateTime.Now.Year.ToString());

            if (selectedListItem11 != null)
            {
                selectedListItem11.Selected = true;
            }

            ListItem selectedListItem12 = ddlyearmonthwise.Items.FindByValue(DateTime.Now.Year.ToString());

            if (selectedListItem12 != null)
            {
                selectedListItem12.Selected = true;
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindcontrol(string labid, string MachineId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(controlname,' # ',lotnumber) controlname,controlid FROM qc_control_centre_mapping ");
        sb.Append(" WHERE centreid in(" + labid + ") and MachineID ='" + MachineId + "' GROUP BY controlid order by  controlname ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public static string GetMonthlyReport(string labid, string controlid, string parameterid, string levelid, string year, string frommonth, string tomonth, int frommonthint, int tomonthint,string machineId)
    {
        int days = DateTime.DaysInMonth(Util.GetInt(year), Util.GetInt(tomonthint));
        string fromdate = "01-" + frommonth + "-" + year;
        string todate = days + "-" + tomonth + "-" + year;
        StringBuilder sb = new StringBuilder();
        StringBuilder sb1 = new StringBuilder();

        sb.Append(" SELECT concat(cm.`CentreCode`,' ',cm.`Centre`)Centre,cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + frommonth + "',' ','" + year + "',' - ','" + tomonth + "',' ','" + year + "')daterang,");
        sb.Append(" moq.`LabObservation_Name` ParameterName,moq.`LabNo` SinNo,'1' TypeID,'TotalRun' Type,");
      
        for (int a = frommonthint; a <= tomonthint; a++)
        {
            int daysa = DateTime.DaysInMonth(Util.GetInt(year), Util.GetInt(a));
            string fromdatea = "01-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;
            string todatea = daysa + "-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;

            for (int b = 1; b <= 3; b++)
            {

                sb1.Append(" COUNT(if( moq.LevelID=" + b + " AND moq.dtEntry>='" + Util.GetDateTime(fromdatea).ToString("yyyy-MM-dd") + " 00:00:00' AND moq.dtEntry<='" + Util.GetDateTime(todatea).ToString("yyyy-MM-dd") + " 23:59:59' ,1 ,NULL))  `" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "<br/>Level" + b + "`,");
                
               
            }
        }
        sb.Append(sb1.ToString().TrimEnd(','));
        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=moq.centreid");
        sb.Append(" and cm.centreid=" + labid + " ");
        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (controlid != "")
        {
            sb.Append(" and moq.ControlID='" + controlid + "' ");
        }
        if (parameterid != "")
        {
            sb.Append(" and moq.LabObservation_ID='" + parameterid + "' ");
        }
        if (levelid != "")
        {
            sb.Append(" and moq.LevelID='" + levelid + "' ");
        }
        if (machineId != "")
        {
            sb.Append(" and moq.machine_id='" + machineId + "' ");
        }
        sb.Append("  GROUP BY moq.`controlid`,moq.`LabObservation_ID` ");


        sb.Append(" union all");

        sb1 = new StringBuilder();
        sb.Append(" SELECT concat(cm.`CentreCode`,' ',cm.`Centre`)Centre,cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + frommonth + "',' ','" + year + "',' - ','" + tomonth + "',' ','" + year + "')daterang,");
        sb.Append(" moq.`LabObservation_Name` ParameterName,moq.`LabNo` SinNo,'2' TypeID,'AvgMeanValue' Type,");
    
        for (int a = frommonthint; a <= tomonthint; a++)
        {
            int daysa = DateTime.DaysInMonth(Util.GetInt(year), Util.GetInt(a));
            string fromdatea = "01-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;
            string todatea = daysa + "-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;

            for (int b = 1; b <= 3; b++)
            {


                sb1.Append(" ifnull(round( AVG(if( moq.LevelID=" + b + " AND moq.dtEntry>='" + Util.GetDateTime(fromdatea).ToString("yyyy-MM-dd") + " 00:00:00' AND moq.dtEntry<='" + Util.GetDateTime(todatea).ToString("yyyy-MM-dd") + " 23:59:59' ,moq.reading ,NULL)),3),0)  `" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "<br/>Level" + b + "`,");
 

               
            }
        }
        sb.Append(sb1.ToString().TrimEnd(','));
        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=moq.centreid");
        sb.Append(" and cm.centreid=" + labid + " ");
        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (controlid != "")
        {
            sb.Append(" and moq.ControlID='" + controlid + "' ");
        }
        if (parameterid != "")
        {
            sb.Append(" and moq.LabObservation_ID='" + parameterid + "' ");
        }
        if (levelid != "")
        {
            sb.Append(" and moq.LevelID='" + levelid + "' ");
        }
         if (machineId != "")
        {
            sb.Append(" and moq.machine_id='" + machineId + "' ");
        }
        sb.Append("  GROUP BY moq.`controlid`,moq.`LabObservation_ID` ");

        sb.Append(" union all");

        sb1 = new StringBuilder();
        sb.Append(" SELECT concat(cm.`CentreCode`,' ',cm.`Centre`)Centre,cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + frommonth + "',' ','" + year + "',' - ','" + tomonth + "',' ','" + year + "')daterang,");
        sb.Append(" moq.`LabObservation_Name` ParameterName,moq.`LabNo` SinNo,'3' TypeID,'SDValue' Type,");
      
        for (int a = frommonthint; a <= tomonthint; a++)
        {
            int daysa = DateTime.DaysInMonth(Util.GetInt(year), Util.GetInt(a));
            string fromdatea = "01-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;
            string todatea = daysa + "-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;

            for (int b = 1; b <= 3; b++)
            {


                sb1.Append(" ifnull(round( STDDEV(if( moq.LevelID=" + b + " AND moq.dtEntry>='" + Util.GetDateTime(fromdatea).ToString("yyyy-MM-dd") + " 00:00:00' AND moq.dtEntry<='" + Util.GetDateTime(todatea).ToString("yyyy-MM-dd") + " 23:59:59' ,moq.reading ,NULL)),3),0) `" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "<br/>Level" + b + "`,");


              
            }
        }
        sb.Append(sb1.ToString().TrimEnd(','));
        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=moq.centreid");
        sb.Append(" and cm.centreid=" + labid + " ");
        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");

        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (controlid != "")
        {
            sb.Append(" and moq.ControlID='" + controlid + "' ");
        }
        if (parameterid != "")
        {
            sb.Append(" and moq.LabObservation_ID='" + parameterid + "' ");
        }
        if (levelid != "")
        {
            sb.Append(" and moq.LevelID='" + levelid + "' ");
        }
        if (machineId != "")
        {
            sb.Append(" and moq.machine_id='" + machineId + "' ");
        }
        sb.Append("  GROUP BY moq.`controlid`,moq.`LabObservation_ID` ");

        sb.Append(" union all");

        sb1 = new StringBuilder();
        sb.Append(" SELECT concat(cm.`CentreCode`,' ',cm.`Centre`)Centre,cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + frommonth + "',' ','" + year + "',' - ','" + tomonth + "',' ','" + year + "')daterang,");
        sb.Append(" moq.`LabObservation_Name`ParameterName,moq.`LabNo` SinNo,'4' TypeID,'CVPer' Type,");
       
        for (int a = frommonthint; a <= tomonthint; a++)
        {
            int daysa = DateTime.DaysInMonth(Util.GetInt(year), Util.GetInt(a));
            string fromdatea = "01-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;
            string todatea = daysa + "-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;

            for (int b = 1; b <= 3; b++)
            {

                sb1.Append(" ifnull(ROUND( STDDEV(if( moq.LevelID=" + b + " AND moq.dtEntry>='" + Util.GetDateTime(fromdatea).ToString("yyyy-MM-dd") + " 00:00:00' AND moq.dtEntry<='" + Util.GetDateTime(todatea).ToString("yyyy-MM-dd") + " 23:59:59' ,moq.reading ,NULL)) / ");
                sb1.Append("  AVG(if( moq.LevelID=" + b + " AND moq.dtEntry>='" + Util.GetDateTime(fromdatea).ToString("yyyy-MM-dd") + " 00:00:00' AND moq.dtEntry<='" + Util.GetDateTime(todatea).ToString("yyyy-MM-dd") + " 23:59:59' ,moq.reading ,NULL)) * ");
                sb1.Append("  100 , 3),0) `" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "<br/>Level" + b + "`,");

                
            
            }
        }
        sb.Append(sb1.ToString().TrimEnd(','));
        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=moq.centreid");
        sb.Append(" and cm.centreid=" + labid + " ");
        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (controlid != "")
        {
            sb.Append(" and moq.ControlID='" + controlid + "' ");
        }
        if (parameterid != "")
        {
            sb.Append(" and moq.LabObservation_ID='" + parameterid + "' ");
        }
        if (levelid != "")
        {
            sb.Append(" and moq.LevelID='" + levelid + "' ");
        }
         if (machineId != "")
        {
            sb.Append(" and moq.machine_id='" + machineId + "' ");
        }
        sb.Append("  GROUP BY moq.`controlid`,moq.`LabObservation_ID` ");

        sb.Append(" order by ControlProvider,Controlname,ParameterName,typeid");

  

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        dt.Columns.Remove("typeid");
        dt.Columns.Remove("sinno");

    

         return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod(EnableSession = true)]
    public static string GetMonthlyReportMontWise(List<string> labid, string year, string frommonth, int frommonthint, string tomonth, int tomonthint)
    {
        int days = DateTime.DaysInMonth(Util.GetInt(year), Util.GetInt(tomonthint));
        string fromdate = "01-" + frommonth + "-" + year;
        string todate = days + "-" + tomonth + "-" + year;
        StringBuilder sb = new StringBuilder();
        StringBuilder sb1 = new StringBuilder();

        sb.Append(" SELECT cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + frommonth + "',' ','" + year + "',' - ','" + tomonth + "',' ','" + year + "')daterang,");
        sb.Append(" moq.`LabObservation_Name`ParameterName,moq.`LabNo` SinNo,'1' TypeID,'TotalRun' Type,");

        for (int a = frommonthint; a <= tomonthint; a++)
        {
            foreach (string centreid in labid)
            {
                int daysa = DateTime.DaysInMonth(Util.GetInt(year), Util.GetInt(a));
                string fromdatea = "01-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;
                string todatea = daysa + "-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;
                for (int b = 1; b <= 3; b++)
                {
                    sb1.Append(" COUNT(if(moq.centreid=" + centreid.Split('#')[0] + " and  moq.LevelID=" + b + " AND moq.dtEntry>='" + Util.GetDateTime(fromdatea).ToString("yyyy-MM-dd") + " 00:00:00' AND moq.dtEntry<='" + Util.GetDateTime(todatea).ToString("yyyy-MM-dd") + " 23:59:59' ,1 ,NULL))  `" + centreid.Split('#')[1] + "<br/>" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "<br/>Level" + b + "`,");
                }
            }
        }

        sb.Append(sb1.ToString().TrimEnd(','));

        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");

        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" GROUP BY moq.`LabObservation_ID` ");


        sb.Append(" union all");

        sb1 = new StringBuilder();
        sb.Append(" SELECT cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + frommonth + "',' ','" + year + "')daterang,");
        sb.Append(" moq.`LabObservation_Name`ParameterName,moq.`LabNo` SinNo,'2' TypeID,'AvgMeanValue' Type,");
        for (int a = frommonthint; a <= tomonthint; a++)
        {
            foreach (string centreid in labid)
            {
                int daysa = DateTime.DaysInMonth(Util.GetInt(year), Util.GetInt(a));
                string fromdatea = "01-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;
                string todatea = daysa + "-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;
                for (int b = 1; b <= 3; b++)
                {
                    sb1.Append(" ifnull(round( AVG(if( moq.centreid=" + centreid.Split('#')[0] + " and moq.LevelID=" + b + " AND moq.dtEntry>='" + Util.GetDateTime(fromdatea).ToString("yyyy-MM-dd") + " 00:00:00' AND moq.dtEntry<='" + Util.GetDateTime(todatea).ToString("yyyy-MM-dd") + " 23:59:59' ,moq.reading ,NULL)),3),0)  `" + centreid.Split('#')[1] + "<br/>" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "<br/>Level" + b + "`,");
                  
                }
            }
        }

        sb.Append(sb1.ToString().TrimEnd(','));

        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");

        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append("  GROUP BY moq.`controlid`,moq.`LabObservation_ID` ");

        sb.Append(" union all");

        sb1 = new StringBuilder();
        sb.Append(" SELECT cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + frommonth + "',' ','" + year + "')daterang,");
        sb.Append(" moq.`LabObservation_Name`ParameterName,moq.`LabNo` SinNo,'3' TypeID,'SDValue' Type,");
        for (int a = frommonthint; a <= tomonthint; a++)
        {
            foreach (string centreid in labid)
            {
                int daysa = DateTime.DaysInMonth(Util.GetInt(year), Util.GetInt(a));
                string fromdatea = "01-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;
                string todatea = daysa + "-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;
                for (int b = 1; b <= 3; b++)
                {
                    sb1.Append(" ifnull(round( STDDEV(if( moq.centreid=" + centreid.Split('#')[0] + " and moq.LevelID=" + b + " AND moq.dtEntry>='" + Util.GetDateTime(fromdatea).ToString("yyyy-MM-dd") + " 00:00:00' AND moq.dtEntry<='" + Util.GetDateTime(todatea).ToString("yyyy-MM-dd") + " 23:59:59' ,moq.reading ,NULL)),3),0)  `" + centreid.Split('#')[1] + "<br/>" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "<br/>Level" + b + "`,");
                }
            }
        }

        sb.Append(sb1.ToString().TrimEnd(','));

        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");

        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append("  GROUP BY moq.`controlid`,moq.`LabObservation_ID` ");

        sb.Append(" union all");



        sb1 = new StringBuilder();
        sb.Append(" SELECT cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + frommonth + "',' ','" + year + "')daterang,");
        sb.Append(" moq.`LabObservation_Name`ParameterName,moq.`LabNo` SinNo,'4' TypeID,'CVPer' Type,");
        for (int a = frommonthint; a <= tomonthint; a++)
        {
            foreach (string centreid in labid)
            {
                int daysa = DateTime.DaysInMonth(Util.GetInt(year), Util.GetInt(a));
                string fromdatea = "01-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;
                string todatea = daysa + "-" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "-" + year;
                for (int b = 1; b <= 3; b++)
                {

                    sb1.Append(" ifnull(ROUND( STDDEV(if(moq.centreid=" + centreid.Split('#')[0] + " and moq.LevelID=" + b + " AND moq.dtEntry>='" + Util.GetDateTime(fromdatea).ToString("yyyy-MM-dd") + " 00:00:00' AND moq.dtEntry<='" + Util.GetDateTime(todatea).ToString("yyyy-MM-dd") + " 23:59:59' ,moq.reading ,NULL)) / ");
                    sb1.Append("  AVG(if(moq.centreid=" + centreid.Split('#')[0] + " and moq.LevelID=" + b + " AND moq.dtEntry>='" + Util.GetDateTime(fromdatea).ToString("yyyy-MM-dd") + " 00:00:00' AND moq.dtEntry<='" + Util.GetDateTime(todatea).ToString("yyyy-MM-dd") + " 23:59:59' ,moq.reading ,NULL)) * ");
                    sb1.Append("  100 , 3),0) `" + centreid.Split('#')[1] + "<br/>" + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(a) + "<br/>Level" + b + "`,");


                }
            }
        }

        sb.Append(sb1.ToString().TrimEnd(','));

        sb.Append(" FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");
        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append("  GROUP BY moq.`controlid`,moq.`LabObservation_ID` ");

        sb.Append(" order by ControlProvider,Controlname,ParameterName,typeid");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        dt.Columns.Remove("typeid");
        dt.Columns.Remove("sinno");

       return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod(EnableSession = true)]
    public static string GetMonthlyReportDayWise(string labid, string controlid, string parameterid, string levelid, string fromdate, string todate)
    {
        DateTime start = Util.GetDateTime(fromdate);
        DateTime end = Util.GetDateTime(todate);

        StringBuilder sb = new StringBuilder();
        StringBuilder sb1 = new StringBuilder();

        sb.Append(" SELECT concat(cm.`CentreCode`,' ',cm.`Centre`)Centre,cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + fromdate + "',' - ','" + todate + "')daterang,");
        sb.Append(" moq.`LabObservation_Name`ParameterName,moq.`LabNo` SinNo,'1' TypeID,'ControlResult' Type,");

        for (DateTime date = start; date.Date <= end.Date; date = date.AddDays(1))
        {
            for (int b = 1; b <= 3; b++)
            {

                sb1.Append(" ifnull((select reading FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq1 where moq.centreid=" + labid + " and  moq1.`controlid`=moq.controlid");
                sb1.Append(" and moq1.LabObservation_ID=moq.LabObservation_ID AND moq1.LevelID=" + b + " and moq1.`isActive`=1 AND moq1.`ShowInQC`=1 ");
                sb1.Append(" AND moq1.dtEntry>='" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb1.Append(" AND moq1.dtEntry<='" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + " 23:59:59' order by dtEntry limit 1),'')");
                sb1.Append(" `" + date.ToString("dd-MMM") + "<br/>Level" + b + "`,");
            }
        }
        sb.Append(sb1.ToString().TrimEnd(','));
        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=moq.centreid");
        sb.Append(" and cm.centreid=" + labid + " ");
        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (controlid != "")
        {
            sb.Append(" and moq.ControlID='" + controlid + "' ");
        }
        if (parameterid != "")
        {
            sb.Append(" and moq.LabObservation_ID='" + parameterid + "' ");
        }
        if (levelid != "")
        {
            sb.Append(" and moq.LevelID='" + levelid + "' ");
        }

        sb.Append("  GROUP BY moq.`controlid`,moq.`LabObservation_ID` ");
        sb1 = new StringBuilder();
        sb.Append(" union all ");


        sb.Append(" SELECT concat(cm.`CentreCode`,' ',cm.`Centre`)Centre,cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + fromdate + "',' - ','" + todate + "')daterang,");
        sb.Append(" moq.`LabObservation_Name`ParameterName,moq.`LabNo` SinNo,'2' TypeID,'Min' Type,");

        for (DateTime date = start; date.Date <= end.Date; date = date.AddDays(1))
        {
            for (int b = 1; b <= 3; b++)
            {

                sb1.Append(" ifnull((select minvalue from qc_controlparameter_detail qcd1 where qcd1.ControlID=moq.controlid  AND qcd1.LabObservation_ID=moq.LabObservation_ID AND qcd1.LevelID=" + b + "),'') ");
                sb1.Append(" `" + date.ToString("dd-MMM") + "<br/>Level" + b + "`,");
            }
        }
        sb.Append(sb1.ToString().TrimEnd(','));
        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=moq.centreid");
        sb.Append(" and cm.centreid=" + labid + " ");
        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (controlid != "")
        {
            sb.Append(" and moq.ControlID='" + controlid + "' ");
        }
        if (parameterid != "")
        {
            sb.Append(" and moq.LabObservation_ID='" + parameterid + "' ");
        }
        if (levelid != "")
        {
            sb.Append(" and moq.LevelID='" + levelid + "' ");
        }

        sb.Append("  GROUP BY moq.`controlid`,moq.`LabObservation_ID` ");

        sb1 = new StringBuilder();
        sb.Append(" union all ");


        sb.Append(" SELECT concat(cm.`CentreCode`,' ',cm.`Centre`)Centre,cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + fromdate + "',' - ','" + todate + "')daterang,");
        sb.Append(" moq.`LabObservation_Name`ParameterName,moq.`LabNo` SinNo,'3' TypeID,'Max' Type,");

        for (DateTime date = start; date.Date <= end.Date; date = date.AddDays(1))
        {
            for (int b = 1; b <= 3; b++)
            {

                sb1.Append(" ifnull((select `Maxvalue` from qc_controlparameter_detail qcd1 where qcd1.ControlID=moq.controlid  AND qcd1.LabObservation_ID=moq.LabObservation_ID AND qcd1.LevelID=" + b + "),'') ");
                sb1.Append(" `" + date.ToString("dd-MMM") + "<br/>Level" + b + "`,");
            }
        }
        sb.Append(sb1.ToString().TrimEnd(','));
        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=moq.centreid");
        sb.Append(" and cm.centreid=" + labid + " ");
        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (controlid != "")
        {
            sb.Append(" and moq.ControlID='" + controlid + "' ");
        }
        if (parameterid != "")
        {
            sb.Append(" and moq.LabObservation_ID='" + parameterid + "' ");
        }
        if (levelid != "")
        {
            sb.Append(" and moq.LevelID='" + levelid + "' ");
        }

        sb.Append("  GROUP BY moq.`controlid`,moq.`LabObservation_ID` ");


        sb1 = new StringBuilder();
        sb.Append(" union all ");


        sb.Append(" SELECT concat(cm.`CentreCode`,' ',cm.`Centre`)Centre,cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + fromdate + "',' - ','" + todate + "')daterang,");
        sb.Append(" moq.`LabObservation_Name`ParameterName,moq.`LabNo` SinNo,'4' TypeID,'Status' Type,");

        for (DateTime date = start; date.Date <= end.Date; date = date.AddDays(1))
        {
            for (int b = 1; b <= 3; b++)
            {

                sb1.Append(" ifnull((select if(QCStatus='Pass','Pass',concat(QCStatus,'(',QCRule,')'))  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq1 where moq.centreid=" + labid + " and  moq1.`controlid`=moq.controlid");
                sb1.Append(" and moq1.LabObservation_ID=moq.LabObservation_ID AND moq1.LevelID=" + b + " and moq1.`isActive`=1 AND moq1.`ShowInQC`=1 ");
                sb1.Append(" AND moq1.dtEntry>='" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb1.Append(" AND moq1.dtEntry<='" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + " 23:59:59' order by dtEntry limit 1),'')");
                sb1.Append(" `" + date.ToString("dd-MMM") + "<br/>Level" + b + "`,");
            }
        }
        sb.Append(sb1.ToString().TrimEnd(','));
        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=moq.centreid");
        sb.Append(" and cm.centreid=" + labid + " ");
        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (controlid != "")
        {
            sb.Append(" and moq.ControlID='" + controlid + "' ");
        }
        if (parameterid != "")
        {
            sb.Append(" and moq.LabObservation_ID='" + parameterid + "' ");
        }
        if (levelid != "")
        {
            sb.Append(" and moq.LevelID='" + levelid + "' ");
        }

        sb.Append("  GROUP BY moq.`controlid`,moq.`LabObservation_ID` ");

        sb.Append(" order by ControlProvider,Controlname,ParameterName,typeid");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        dt.Columns.Remove("typeid");
        dt.Columns.Remove("sinno");


        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public static string GetMonthlyReportDayWiseAll(List<string> labid, string fromdate, string todate)
    {
        DateTime start = Util.GetDateTime(fromdate);
        DateTime end = Util.GetDateTime(todate);

        StringBuilder sb = new StringBuilder();
        StringBuilder sb1 = new StringBuilder();

        sb.Append(" SELECT cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + fromdate + "',' - ','" + todate + "')daterang,");
        sb.Append(" moq.`LabObservation_Name`ParameterName,moq.`LabNo` SinNo,'1' TypeID,'ControlResult' Type,");
        foreach (string centreid in labid)
        {
            for (DateTime date = start; date.Date <= end.Date; date = date.AddDays(1))
            {
                for (int b = 1; b <= 3; b++)
                {

                    sb1.Append(" ifnull((select reading FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq1 where moq1.centreid=" + centreid.Split('#')[0] + " and  moq1.`controlid`=moq.controlid");
                    sb1.Append(" and moq1.LabObservation_ID=moq.LabObservation_ID AND moq1.LevelID=" + b + " and moq1.`isActive`=1 AND moq1.`ShowInQC`=1 ");
                    sb1.Append(" AND moq1.dtEntry>='" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb1.Append(" AND moq1.dtEntry<='" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + " 23:59:59' order by dtEntry limit 1),'')");
                    sb1.Append(" `" + centreid.Split('#')[1] + "<br/>" + date.ToString("dd-MMM") + "<br/>Level" + b + "`,");
                }
            }
        }
        sb.Append(sb1.ToString().TrimEnd(','));
        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");
       
        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
       

        sb.Append("  GROUP BY moq.`controlid`,moq.`LabObservation_ID` ");
        sb1 = new StringBuilder();
        sb.Append(" union all ");


        sb.Append(" SELECT cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + fromdate + "',' - ','" + todate + "')daterang,");
        sb.Append(" moq.`LabObservation_Name`ParameterName,moq.`LabNo` SinNo,'2' TypeID,'Min' Type,");
        foreach (string centreid in labid)
        {

            for (DateTime date = start; date.Date <= end.Date; date = date.AddDays(1))
            {
                for (int b = 1; b <= 3; b++)
                {

                    sb1.Append(" ifnull((select minvalue from qc_controlparameter_detail qcd1 where qcd1.ControlID=moq.controlid  AND qcd1.LabObservation_ID=moq.LabObservation_ID AND qcd1.LevelID=" + b + "),'') ");
                    sb1.Append(" `" + centreid.Split('#')[1] + "<br/>" + date.ToString("dd-MMM") + "<br/>Level" + b + "`,");
                }
            }
        }
        sb.Append(sb1.ToString().TrimEnd(','));
        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");
      
        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
       

        sb.Append("  GROUP BY moq.`controlid`,moq.`LabObservation_ID` ");

        sb1 = new StringBuilder();
        sb.Append(" union all ");


        sb.Append(" SELECT cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + fromdate + "',' - ','" + todate + "')daterang,");
        sb.Append(" moq.`LabObservation_Name`ParameterName,moq.`LabNo` SinNo,'3' TypeID,'Max' Type,");
        foreach (string centreid in labid)
        {
            for (DateTime date = start; date.Date <= end.Date; date = date.AddDays(1))
            {
                for (int b = 1; b <= 3; b++)
                {

                    sb1.Append(" ifnull((select `Maxvalue` from qc_controlparameter_detail qcd1 where qcd1.ControlID=moq.controlid  AND qcd1.LabObservation_ID=moq.LabObservation_ID AND qcd1.LevelID=" + b + "),'') ");
                    sb1.Append(" `" + centreid.Split('#')[1] + "<br/>" + date.ToString("dd-MMM") + "<br/>Level" + b + "`,");
                }
            }
        }
        sb.Append(sb1.ToString().TrimEnd(','));
        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");
      
        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
       

        sb.Append("  GROUP BY moq.`controlid`,moq.`LabObservation_ID` ");


        sb1 = new StringBuilder();
        sb.Append(" union all ");


        sb.Append(" SELECT cmq.Subcategoryname Department,cmq.ControlProvider,cmq.MachineName,cmq.ControlName,cmq.`LotNumber`, ");
        sb.Append(" DATE_FORMAT(cmq.`LotExpiry`,'%d-%b-%Y')LotExpiry,");
        sb.Append(" concat('" + fromdate + "',' - ','" + todate + "')daterang,");
        sb.Append(" moq.`LabObservation_Name`ParameterName,moq.`LabNo` SinNo,'4' TypeID,'Status' Type,");
        foreach (string centreid in labid)
        {
            for (DateTime date = start; date.Date <= end.Date; date = date.AddDays(1))
            {
                for (int b = 1; b <= 3; b++)
                {

                    sb1.Append(" ifnull((select if(QCStatus='Pass','Pass',concat(QCStatus,'(',QCRule,')'))  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq1 where moq1.centreid=" + centreid.Split('#')[0] + " and  moq1.`controlid`=moq.controlid");
                    sb1.Append(" and moq1.LabObservation_ID=moq.LabObservation_ID AND moq1.LevelID=" + b + " and moq1.`isActive`=1 AND moq1.`ShowInQC`=1 ");
                    sb1.Append(" AND moq1.dtEntry>='" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb1.Append(" AND moq1.dtEntry<='" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + " 23:59:59' order by dtEntry limit 1),'')");
                    sb1.Append(" `" + centreid.Split('#')[1] + "<br/>" + date.ToString("dd-MMM") + "<br/>Level" + b + "`,");
                }
            }
        }
        sb.Append(sb1.ToString().TrimEnd(','));
        sb.Append("  FROM " + Util.getApp("MachineDB") + ".`mac_observation_qc` moq");
     
        sb.Append(" INNER JOIN `qc_controlmaster` cmq ON cmq.`ControlID`=moq.`controlid`");
        sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");
        sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
        sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcc.LevelID=moq.LevelID and qcc.centreid=cm.centreid and qcc.isactive=1 ");
        sb.Append(" and qcc.machineid=moq.Machine_Id");
        sb.Append(" WHERE moq.`isActive`=1 AND moq.`ShowInQC`=1");
        sb.Append(" AND moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
       

        sb.Append("  GROUP BY moq.`controlid`,moq.`LabObservation_ID` ");

        sb.Append(" order by ControlProvider,Controlname,ParameterName,typeid");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        dt.Columns.Remove("typeid");
        dt.Columns.Remove("sinno");


        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    
}
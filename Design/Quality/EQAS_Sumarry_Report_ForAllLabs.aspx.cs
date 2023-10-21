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

public partial class Design_Quality_EQAS_Sumarry_Report_ForAllLabs : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
      
        StringBuilder str = new StringBuilder();
        if (!IsPostBack)
        {


            ddleqasprogram.DataSource = StockReports.GetDataTable("SELECT programid,programname FROM `qc_eqasprogrammaster`  GROUP BY programid");
            ddleqasprogram.DataValueField = "programid";
            ddleqasprogram.DataTextField = "programname";
            ddleqasprogram.DataBind();
            ddleqasprogram.Items.Insert(0, new ListItem("Select Program", "0"));

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
    public static string Getsummaryreport(string processingcentre, string dtFrom, string dtTo, string progrm, string machine)
    {
        StringBuilder sb = new StringBuilder();
        DateTime dateFrom = Convert.ToDateTime(dtFrom);
        DateTime dateTo = Convert.ToDateTime(dtTo);

        sb.Append("  SELECT qcr.programid programid,cm.centreid centreid,ifnull(qcr.MachineID,'')MachineID,qcr.`LabObservationID` LabObservation_ID,qcr.programname,  ");
        sb.Append(" cm.Centre,IFNULL(mc.Name,'')MachineName,qcr.LabObservationName Parameter,qcr.test_id,    ");
        sb.Append("  qcr.value myvalue ");


        sb.Append(" FROM `qc_eqasregistration` qcr   ");
        sb.Append(" INNER JOIN centre_master cm ON cm.centreid=qcr.centreid  ");
        if (processingcentre != "" && processingcentre != null && processingcentre != "null")
        {
            sb.Append(" and cm.centreid="+processingcentre+" ");
        }

        sb.Append(" left join macmaster mc on mc.id=qcr.machineid");
        sb.Append(" WHERE  isreject=0  ");
        sb.Append(" AND qcr.entrydatetime>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00'");
        sb.Append(" AND qcr.entrydatetime<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" and qcr.programid=" + progrm + "");
        sb.Append(" and IsNumeric(qcr.value)=1 ");
        if (machine != "0")
        {
            sb.Append(" and qcr.machineid='" + machine + "'");
        }

        
      


        DataTable dt_AllData = StockReports.GetDataTable(sb.ToString());
        if (dt_AllData.Rows.Count > 0)
        {
            DataTable dtc = ChangeDatatable(dt_AllData);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtc);
        }
        else
        {
            return "false";
        }
      
 
            
    }


    static DataTable ChangeDatatable(DataTable dt)
    {
        DataTable dtme = new DataTable();
        dtme.Columns.Add("Program^Name");
        dtme.Columns.Add("Centre");
        dtme.Columns.Add("Instrument^Name");
        dtme.Columns.Add("Total");
        DataView dv = dt.DefaultView.ToTable(true, "Centre", "MachineName").DefaultView;
        dv.Sort = "Centre asc";
        DataTable dtCentre = dv.ToTable();



        DataView dvobs = dt.DefaultView.ToTable(true, "LabObservation_ID","Parameter").DefaultView;
        dvobs.Sort = "Parameter asc";
        DataTable dvobsp = dvobs.ToTable();
        DataColumn dc;
        foreach (DataRow dw in dvobsp.Rows)
        {
            dc = new DataColumn(dw["Parameter"].ToString().Replace(" ", "^"), System.Type.GetType("System.Double"));
            dtme.Columns.Add(dc);
           
        }
        foreach (DataRow dwrr in dtCentre.Rows)
        {
            DataRow dwr = dtme.NewRow();
            dwr["Program^Name"] = dt.Rows[0]["programname"].ToString();
            dwr["Centre"] = dwrr["Centre"].ToString();
            dwr["Instrument^Name"] = dwrr["MachineName"].ToString();
            DataRow[] dwme = dt.Select("Centre='" + dwrr["Centre"].ToString() + "'");

            foreach (DataRow dwm in dwme)
            {
                dwr[dwm["Parameter"].ToString().Replace(" ", "^")] = dwm["myvalue"].ToString();
            }
            dtme.Rows.Add(dwr);

        }

        DataRow dwr1 = dtme.NewRow();
        dwr1["Total"] = "Peer Group Mean";
        foreach (DataRow dw in dvobsp.Rows)
        {
            dwr1[dw["Parameter"].ToString().Replace(" ", "^")] = Math.Round((double)dtme.Compute("AVG([" + dw["Parameter"].ToString().Replace(" ", "^") + "])", ""),2);
        }

        DataRow dwr2 = dtme.NewRow();
        dwr2["Total"] = "Peer Group SD";
        foreach (DataRow dw in dvobsp.Rows)
        {
            dwr2[dw["Parameter"].ToString().Replace(" ", "^")] = dtme.Compute("StDev([" + dw["Parameter"].ToString().Replace(" ", "^") + "])", "");
        }

        //DataRow dwr2 = dtme.NewRow();
        //dwr2["Total"] = "Peer Group SD";
        //foreach (DataRow dw in dvobsp.Rows)
        //{
        //   dwr2[dw["Parameter"].ToString().Replace(" ", "^")] = Math.Round((double)dtme.Compute("StDev([" + dw["Parameter"].ToString().Replace(" ", "^") + "])", ""),2);
        //}


        DataRow dwr3 = dtme.NewRow();
        dwr3["Total"] = "Peer  Group Low Range";
        foreach (DataRow dw in dvobsp.Rows)
        {
            dwr3[dw["Parameter"].ToString().Replace(" ", "^")] = (double)dtme.Compute("Min([" + dw["Parameter"].ToString().Replace(" ", "^") + "])", "");
        }
       

        DataRow dwr4 = dtme.NewRow();
        dwr4["Total"] = "Peer Group  High Range";
       
        foreach (DataRow dw in dvobsp.Rows)
        {
            dwr4[dw["Parameter"].ToString().Replace(" ", "^")] = (double)dtme.Compute("Max([" + dw["Parameter"].ToString().Replace(" ", "^") + "])", "");
        }
      


       

        dtme.Rows.Add(dwr1);
        dtme.Rows.Add(dwr2);
        dtme.Rows.Add(dwr3);
        dtme.Rows.Add(dwr4);

       

        return dtme;
     
    }

  
}
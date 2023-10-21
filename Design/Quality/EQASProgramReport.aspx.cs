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

public partial class Design_Quality_EQASProgramReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            ddleqasprovider.DataSource = StockReports.GetDataTable(@"SELECT `EQASProviderID`,`EqasProviderName` FROM `qc_eqasprovidermaster` WHERE isactive=1 ORDER BY EqasProviderName");
            ddleqasprovider.DataValueField = "EQASProviderID";
            ddleqasprovider.DataTextField = "EqasProviderName";
            ddleqasprovider.DataBind();
            ddleqasprovider.Items.Insert(0, new ListItem("Select EQAS Provider", "0"));

            ddlcurrentmonth.SelectedValue = DateTime.Now.Month.ToString();
            ddlyear.SelectedValue = DateTime.Now.Year.ToString();
        }
    }


    [WebMethod(EnableSession = true)]
    public static string bindprogram(string eqasproid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT programid,programname FROM `qc_eqasprogrammaster` WHERE `EQASProviderID`=" + eqasproid + " AND isactive=1 GROUP BY programid ORDER BY programname"));

    }


    [WebMethod(EnableSession = true)]
    public static string getdata(string programid, string EntryMonth, string EntryYear)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("   ");
        sb.Append(" SELECT programname, cm.`Centre`,pli.`InvestigationName`,plo.`Value` ");
        sb.Append(" FROM qc_eqasregistration  qcr ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=qcr.`CentreID` ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Test_ID`=qcr.`Test_id` AND pli.`IsReporting`=1 ");
        sb.Append(" LEFT JOIN `patient_labobservation_opd` plo ON plo.`LabObservation_ID`=qcr.`LabObservationID` AND pli.`Test_ID`=plo.`Test_ID` ");
        sb.Append(" WHERE isreject=0 AND EntryMonth=" + EntryMonth + " AND EntryYear=" + EntryYear + " and qcr.programid=" + programid + " ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            dt = convertdatatable(dt);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    static DataTable convertdatatable(DataTable dt)
    {


        try
        {
            DataTable dtc = new DataTable();


            DataView dv = dt.DefaultView.ToTable(true, "Centre").DefaultView;
            dv.Sort = "Centre asc";
            DataTable dept = dv.ToTable();

            dtc.Columns.Add("ProgramName");
            dtc.Columns.Add("Centre");

            DataView dvmonth = dt.DefaultView.ToTable(true, "InvestigationName").DefaultView;
            dvmonth.Sort = "InvestigationName asc";
            DataTable pro = dvmonth.ToTable();


          
            foreach (DataRow dw in pro.Rows)
            {
                dtc.Columns.Add(dw["InvestigationName"].ToString());
            }


            foreach (DataRow dwrr in dept.Rows)
            {
                DataRow dwr = dtc.NewRow();
                dwr["ProgramName"] = dt.Rows[0]["programname"].ToString();
                dwr["Centre"] = dwrr["Centre"].ToString();
                DataRow[] dwme = dt.Select("Centre='" + dwrr["Centre"].ToString() + "'");
              
                foreach (DataRow dwm in dwme)
                {
                    dwr[dwm["InvestigationName"].ToString()] = dwm["value"].ToString();
                }
                dtc.Rows.Add(dwr);

            }






            return dtc;

        }
        catch (Exception ex)
        {
            return dt;
        }
    }



    [WebMethod(EnableSession = true)]
    public static string getdataexcel(string programid, string EntryMonth, string EntryYear)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("   ");
        sb.Append(" SELECT programname, cm.`Centre`,pli.`InvestigationName`,plo.`Value` ");
        sb.Append(" FROM qc_eqasregistration  qcr ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=qcr.`CentreID` ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Test_ID`=qcr.`Test_id` AND pli.`IsReporting`=1 ");
        sb.Append(" LEFT JOIN `patient_labobservation_opd` plo ON plo.`LabObservation_ID`=qcr.`LabObservationID` AND pli.`Test_ID`=plo.`Test_ID` ");
        sb.Append(" WHERE isreject=0 AND EntryMonth=" + EntryMonth + " AND EntryYear=" + EntryYear + " and qcr.programid=" + programid + " ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            dt = convertdatatable(dt);
        }

    
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
            HttpContext.Current.Session["ReportName"] = "EQASComparisonReport";
            return "true";
        }
        else
        {
            return "false";
        }

    }

}
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Sales_BusinessReportCumulative : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtfromdate, txttodate);
        }
    }


    [WebMethod(EnableSession = true)]
    public static string bindbusinessUnit()
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT cm.Centreid,cm.centre FROM centre_master cm  ");
        sb.Append(" INNER JOIN f_panel_master pm ON pm.`TagBusinessLabID` = cm.centreID ");
        sb.Append("  ORDER by cm.centre ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public static string bindclient(string Businessunit, string type)
    {

        if (type != "")
            type = "'" + type.Replace(",", "','") + "'";

        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT pm.panel_ID,CONCAT(IFNULL(pm.panel_code,''),' ',pm.company_Name)PanelName  ");
        sb.Append(" FROM f_panel_master pm  ");
        sb.Append(" WHERE pm.isactive=1 AND pm.`PanelType` <> 'Centre' ");
        if (type != "")
            sb.Append(" AND pm.panelType IN (" + type + ") ");
        if (Businessunit != "")
            sb.Append(" AND pm.`TagBusinessLabID`  IN (" + Businessunit + ")   ");
        sb.Append(" UNION ALL  ");

        sb.Append(" SELECT pm.panel_ID,CONCAT(IFNULL(cm.`CentreCode`,''),' ',cm.`Centre`)PanelName  ");
        sb.Append(" FROM f_panel_master pm  ");
        sb.Append(" INNER JOIN `centre_master` cm ON cm.CentreID=pm.`CentreID` AND pm.`PanelType`='Centre' ");
        sb.Append(" WHERE pm.isactive=1 ");
        if (type != "")
            sb.Append(" AND cm.`type1` IN (" + type + ") ");
        if (Businessunit != "")
            sb.Append(" AND pm.`TagBusinessLabID`  IN (" + Businessunit + ")   ");

        sb.Append(" ORDER BY PanelName  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public static string bindcentertype()
    {
        //  return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("select type1 ID,Type1 from centre_type1master Where IsActive=1 order by Type1 "));


        DataTable dt = StockReports.GetDataTable("select type1 ID,Type1 from centre_type1master Where IsActive=1 order by Type1 ");
        DataRow dr = dt.NewRow();
        // dr["ID"] = "GOVT PANEL";
        //  dr["Type1"] = "GOVT PANEL";
        //  dt.Rows.Add(dr);

        //  dr = dt.NewRow();
        //  dr["ID"] = "CORPORATE";
        //  dr["Type1"] = "CORPORATE";
        //  dt.Rows.Add(dr);

        //  dr = dt.NewRow();
        //  dr["ID"] = "TPA";
        //  dr["Type1"] = "TPA";
        //  dt.Rows.Add(dr);

        dr = dt.NewRow();
        dr["ID"] = "Camp";
        dr["Type1"] = "Camp";
        dt.Rows.Add(dr);

        dr = dt.NewRow();
        dr["ID"] = "RateType";
        dr["Type1"] = "RateType";
        dt.Rows.Add(dr);

        dt.AcceptChanges();

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Search(string PanelId, string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT plo.LedgertransactionID, lt.`LedgerTransactionNo`,lt.`PName` ,lt.`Age`,GROUP_CONCAT(plo.`ItemName`) Tests FROM f_ledgertransaction lt ");
        sb.Append("INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
        sb.Append("WHERE plo.`Approved`=1 AND IsCancel=0 and plo.`ReportType`=1 AND lt.Panel_id =" + PanelId + " AND plo.`ApprovedDate` >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND plo.`ApprovedDate` <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" GROUP BY plo.LedgertransactionID ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(string LedgerTransactionID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lt.`LedgerTransactionNo`,pli.BarcodeNo,lt.`Patient_ID`,lt.`PName`,lt.`Age`,lt.`Gender`,pli.`ItemName`,plo.`LabObservationName`, CONCAT(plo.`Value`,' ',IF(plo.Flag='Normal','',plo.Flag)) `Value`  FROM f_ledgertransaction lt ");
        sb.Append(" INNER JOIN Patient_labInvestigation_OPD pli ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID` ");
        sb.Append(" INNER JOIN Patient_labObservation_OPD plo ON pli.`Test_ID`=plo.`Test_ID` ");
        sb.Append(" WHERE pli.`Approved`=1 and pli.`ReportType`=1 AND lt.`IsCancel`=0 AND pli.`LedgerTransactionID` IN (" + LedgerTransactionID + ") ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataTable dtMerge = new DataTable();
        dtMerge.Columns.Add("LedgerTransactionNo");
        dtMerge.Columns.Add("BarcodeNo");
        dtMerge.Columns.Add("Patient_ID");
        dtMerge.Columns.Add("PName");
        dtMerge.Columns.Add("Age");
        dtMerge.Columns.Add("Gender");

        foreach (DataRow drMain in dt.Rows)
        {
            if (!dtMerge.Columns.Contains(drMain["LabObservationName"].ToString()))
            {
                dtMerge.Columns.Add(drMain["LabObservationName"].ToString());
            }
            DataRow[] DRtemp = dtMerge.Select("BarcodeNo='" + drMain["BarcodeNo"].ToString() + "'");
            if (DRtemp.Length == 0)
            {
                DataRow NewMerge = dtMerge.NewRow();
                NewMerge["LedgerTransactionNo"] = drMain["LedgerTransactionNo"].ToString();
                NewMerge["BarcodeNo"] = drMain["BarcodeNo"].ToString();
                NewMerge["Patient_ID"] = drMain["Patient_ID"].ToString();
                NewMerge["PName"] = drMain["PName"].ToString();
                NewMerge["Age"] = drMain["Age"].ToString();
                NewMerge["Gender"] = drMain["Gender"].ToString();
                NewMerge[drMain["LabObservationName"].ToString()] = drMain["Value"].ToString();
                dtMerge.Rows.Add(NewMerge);
            }
            else {
                DRtemp[0][drMain["LabObservationName"].ToString()] = drMain["Value"].ToString();
            }

        }

        HttpContext.Current.Session["dtExport2Excel"] = dtMerge;
        HttpContext.Current.Session["ReportName"] = "LabReportCumulative_"+DateTime.Now;
        
        return "1";

    }



}
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Lab_MachineDataReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtfromdate, txttodate);
        }
    }


    [WebMethod(EnableSession = true)]
    public static string bindCentre()
    {

        StringBuilder sb = new StringBuilder();
        DataTable dt = AllLoad_Data.getCentreByTagBusinessLab();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(string FromDate, string ToDate, string CentreId, string ReportType)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            if (ReportType == "1")
            {
                sb.Append("  SELECT CM.Centre,MD.LedgertransactionNo VisitNo,LabNo Barcode,MD.`PName`,MD.`Gender`, ");
                sb.Append("  MD.InvestigationName,MD.LabObservationName,MD.`Reading` ");
                sb.Append("  FROM mac_data MD ");
                sb.Append("  INNER JOIN Centre_Master CM ON CM.`CentreID`=MD.`centreid` ");
                sb.Append("  WHERE MD.`Status`='Receive' AND MD.Reading <> ''  ");
                sb.Append("  AND MD.MacDate !='0000-00-00 00:00:00'  ");
                sb.Append("  AND MD.`MacDate` >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00'  ");
                sb.Append("  AND MD.`MacDate`  <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
                if (CentreId != "")
                {
                    sb.Append(" AND MD.`centreid` IN (" + CentreId + ") ");
                }

                sb.Append("  UNION ALL  ");
                sb.Append("  SELECT CM.Centre,MD.LedgertransactionNo VisitNo,LabNo Barcode,MD.`PName`,MD.`Gender`,  ");
                sb.Append("  MD.InvestigationName,MD.LabObservationName,MD.`Reading` ");
                sb.Append("  FROM mac_data MD ");
                sb.Append("  INNER JOIN Centre_Master CM ON CM.`CentreID`=MD.`centreid` ");
                sb.Append("  WHERE MD.`Status`='Receive' AND MD.Reading <> ''  ");
                sb.Append("  AND MD.MacDate ='0000-00-00 00:00:00'  ");
                sb.Append("  AND MD.`dtEntry` >= '" + Util.GetDateTime(FromDate).ToString("yyyyMMdd") + "000000'  ");
                sb.Append("  AND MD.`dtEntry`  <= '" + Util.GetDateTime(ToDate).ToString("yyyyMMdd") + "235959' ");
                if (CentreId != "")
                {
                    sb.Append(" AND MD.`centreid` IN (" + CentreId + ") ");
                }

                sb.Append("  UNION ALL ");
                sb.Append("  SELECT CM.Centre,MD.LedgertransactionNo VisitNo,LabNo Barcode,MD.`PName`,MD.`Gender`,  ");
                sb.Append("  MD.InvestigationName,MD.LabObservationName,MD.`Reading` ");
                sb.Append("  FROM atulya_live_log.mac_data_before_delete MD ");
                sb.Append("  INNER JOIN atulya_live.Centre_Master CM ON CM.`CentreID`=MD.`centreid` ");
                sb.Append("  WHERE MD.`Status`='Receive' AND MD.Reading <> ''  ");
                sb.Append("  AND MD.MacDate !='0000-00-00 00:00:00'  ");
                sb.Append("  AND MD.`MacDate` >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00'  ");
                sb.Append("  AND MD.`MacDate`  <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
                if (CentreId != "")
                {
                    sb.Append(" AND MD.`centreid` IN (" + CentreId + ") ");
                }

                sb.Append("  UNION ALL  ");
                sb.Append("  SELECT CM.Centre,MD.LedgertransactionNo VisitNo,LabNo Barcode,MD.`PName`,MD.`Gender`,  ");
                sb.Append("  MD.InvestigationName,MD.LabObservationName,MD.`Reading` ");
                sb.Append("  FROM atulya_live_log.mac_data_before_delete MD ");
                sb.Append("  INNER JOIN atulya_live.Centre_Master CM ON CM.`CentreID`=MD.`centreid` ");
                sb.Append("  WHERE MD.`Status`='Receive' AND MD.Reading <> ''  ");
                sb.Append("  AND MD.MacDate ='0000-00-00 00:00:00'  ");
                sb.Append("  AND MD.`dtEntry` >= '" + Util.GetDateTime(FromDate).ToString("yyyyMMdd") + "000000'  ");
                sb.Append("  AND MD.`dtEntry`  <= '" + Util.GetDateTime(ToDate).ToString("yyyyMMdd") + "235959' ");
                if (CentreId != "")
                {
                    sb.Append(" AND MD.`centreid` IN (" + CentreId + ") ");
                }
            }
            else
            {

                sb.Append("   SELECT CM.`Centre`, lt.PName,lt.Age,lt.Gender, lt.`LedgerTransactionNo` VisitNo,pli.BarcodeNo Barcode, ");
                sb.Append(" pli.`InvestigationName`,plo.LabObservationName,plo.`Value`, plo.MacReading AS MachineReading  ");
                sb.Append(" FROM `patient_labinvestigation_opd` pli ");
                sb.Append(" INNER JOIN f_ledgertransaction lt ON pli.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
                sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
                sb.Append(" INNER JOIN  `patient_labobservation_opd` plo ON pli.`Test_ID`=plo.`Test_ID` ");
               
                sb.Append(" WHERE pli.Date >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00'");
                sb.Append(" AND pli.Date <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
                sb.Append(" AND pli.`IsSampleCollected`='Y'  ");
                sb.Append(" AND plo.`Value` <> '' ");
                if (CentreId != "")
                {
                    sb.Append(" AND lt.`CentreID` IN (" + CentreId + ") ");
                }
            }



            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "Machine_Reading_Data";
                return "1";
            }
            else
            {
                return "0";
            }
        }
        catch (Exception ex)
        {
            return "0";
        }
    }



}
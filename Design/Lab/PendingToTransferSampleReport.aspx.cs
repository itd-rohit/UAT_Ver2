using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Lab_DoctorApprovalReport : System.Web.UI.Page
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
    public static string GetReport(string FromDate, string ToDate, string CentreId)
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT cm.Centre,plo.InvestigationName,plo.BarcodeNo AS Barcode,sl.`DispatchCode` AS BatchNo,DATE_FORMAT(plo.SampleDate,'%d-%b-%y %h:%i %p') AS SampleDate,lt.PName AS PatientName,lt.`Age`   ");
            sb.Append(" FROM sample_logistic sl  ");
            sb.Append(" INNER JOIN patient_labInvestigation_OPD plo ON sl.testId=plo.Test_Id ");
            sb.Append(" INNER JOIN Centre_Master cm ON cm.`CentreID`=sl.`FromCentreID` ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
            sb.Append(" WHERE sl.Status ='Pending for Dispatch'  ");
            sb.Append("  AND plo.SampleDate >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND plo.SampleDate <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59'");
            if (CentreId != "")
            {
                sb.Append(" AND sl.`FromCentreID` IN (" + CentreId + ") ");
            }
          
            sb.Append(" ORDER BY plo.SampleDate DESC ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "PendingToTransferSample";
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
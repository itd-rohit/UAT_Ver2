using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Lab_NorthernRailwayReport : System.Web.UI.Page
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
    public static string GetReport(string FromDate, string ToDate, string ReportType, string LtId)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            
            sb.Append("   SELECT CONCAT(pm.Title,' ',pm.PName) PName,pm.Patient_Id,IFNULL(ltCD.`ReferralSNo`,'') RefNo,DATE_FORMAT(lt.Date,'%d-%b-%Y') DATE,lt.CorporateIDCard MedicalIdCard, ");
            sb.Append(" lt.BillNo,plo.InvestigationName,plo.PanelItemCode CGHSCode,plo.Amount,'' CentreName,'Mukul Sales Private Limited' BankAccountName,'Citi Bank' BankName,'0001552187' BankAccountNumber, ");
            sb.Append(" 'CITI0000013' BankIFSC,DATE_FORMAT(lt.Date,'%M`%y') MonthYear,'' col1,'' col2,'' col3 ");
            sb.Append(" FROM patient_labInvestigation_OPD plo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON plo.LedgertransactionId=lt.LedgertransactionId AND lt.Panel_Id=199 ");
            sb.Append(" INNER JOIN patient_master pm ON pm.Patient_Id=lt.Patient_Id ");
            sb.Append(" LEFT JOIN f_ledgertransaction_corporatedetail  ltCD ON lt.`LedgerTransactionID`=ltCD.`LedgerTransactionID` ");
            sb.Append(" WHERE lt.Date >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND lt.Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append(" AND lt.LedgertransactionId IN (" + LtId + ") ");
            sb.Append(" ORDER BY lt.Date ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                if (ReportType == "1")
                {
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                   // ds.WriteXml(@"f:/apurva/NorthernRailway.xml");
                    HttpContext.Current.Session["ds"] = ds;
                    HttpContext.Current.Session["ReportName"] = "NorthernRailway_PatientSummary";
                }
                else if (ReportType == "2")
                {
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    ds.WriteXml(@"f:/apurva/NorthernRailwayPD.xml");
                    HttpContext.Current.Session["ds"] = ds;
                    HttpContext.Current.Session["ReportName"] = "NorthernRailway_PatientDetail";
                }
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


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Search(string FromDate, string ToDate, string ReportType)
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("   SELECT lt.LedgertransactionNo,lt.LedgertransactionId, CONCAT(pm.Title,' ',pm.PName) PName,pm.Patient_Id,IFNULL(ltCD.`ReferralSNo`,'') RefNo,DATE_FORMAT(lt.Date,'%d-%b-%Y') DATE,lt.CorporateIDCard MedicalIdCard, ");
            sb.Append(" lt.BillNo,plo.InvestigationName,plo.PanelItemCode CGHSCode,plo.Amount,'' CentreName,'Mukul Sales Private Limited' BankAccountName,'Citi Bank' BankName,'0001552187' BankAccountNumber, ");
            sb.Append(" 'CITI0000013' BankIFSC,DATE_FORMAT(lt.Date,'%M`%y') MonthYear,CONCAT(lt.Age,'/',lt.Gender) col1,'' col2,'' col3 ");
            sb.Append(" FROM patient_labInvestigation_OPD plo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON plo.LedgertransactionId=lt.LedgertransactionId AND lt.Panel_Id=199 ");
            sb.Append(" INNER JOIN patient_master pm ON pm.Patient_Id=lt.Patient_Id ");
            sb.Append(" LEFT JOIN f_ledgertransaction_corporatedetail  ltCD ON lt.`LedgerTransactionID`=ltCD.`LedgerTransactionID` ");
            sb.Append(" WHERE lt.Date >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND lt.Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append(" Group BY lt.Patient_Id ");
            sb.Append(" ORDER BY lt.Date ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
           
        }
        catch (Exception ex)
        {
            return "0";
        }
    }



}
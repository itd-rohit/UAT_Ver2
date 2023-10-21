using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_FrontOffice_DispatchReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtfromdate, txttodate);
        }
    }


    [WebMethod(EnableSession = true)]
    public static string bindEmployee()
    {

        StringBuilder sb = new StringBuilder();
        DataTable dt = StockReports.GetDataTable("SELECT CONCAT(Title,' ',NAME) EmployeeName,Employee_Id FROM employee_master WHERE IsActive=1 ORDER BY NAME");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

   

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(string FromDate, string ToDate, string EmployeeId)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT plo.`LedgerTransactionNo` VisitNo,lt.PName,lt.Age,lt.Gender,lt.DoctorName,lt.PanelName  ");
         sb.Append(" ,IFNULL(CONCAT(em.Title,' ',em.Name),'') DispatchBy,IFNULL(DATE_FORMAT(rd.dtEntry,'%d-%b-%Y %h:%i %p'),'')DispatchedOn,   ");
         sb.Append(" IFNULL(rd.DispatchTo,'') DispatchTo,IFNULL(rd.OtherName,'') OtherName,IFNULL(rd.OtherMobile,'') OtherMobile, ");
         sb.Append(" plo.InvestigationName,sm.Name Department   ");
         sb.Append(" FROM f_ledgertransaction lt   ");
         sb.Append(" INNER JOIN patient_labInvestigation_OPD plo ON lt.LedgertransactionId=plo.ledgertransactionId   ");
         sb.Append(" INNER JOIN f_SubcategoryMaster sm ON plo.subcategoryId=sm.subcategoryId  ");
         sb.Append(" INNER JOIN ReportDispatch_log rd ON plo.Test_Id=rd.Test_Id   ");
         sb.Append(" INNER JOIN Employee_Master em ON em.Employee_Id=rd.Employee_Id   ");
         sb.Append(" WHERE rd.`dtEntry` >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND rd.`dtEntry` <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59'   ");
         if (EmployeeId != "")
         {
             sb.Append(" AND rd.`Employee_Id` IN (" + EmployeeId + ") ");
         }
         sb.Append(" order by  rd.`dtEntry` DESC ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "Dispatch_Report";
                return "1";
            }
            else
            {
                return "0";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }



}
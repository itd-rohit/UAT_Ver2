using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_DuplicatePatientEntryReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    [WebMethod]
    public static string getReport(string dtFrom, string dtTo, string CentreID)
    {
        string retValue = "0";

        DateTime dateFrom = Convert.ToDateTime(dtFrom);
        DateTime dateTo = Convert.ToDateTime(dtTo); 	
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.`Centre`, pm.`Patient_ID` UHID,CONCAT(pm.`Title`,' ',pm.`PName`)NAME,pm.`Gender`,pm.`Age`, ");
        sb.Append(" pm.`Mobile`,pm.`Email`,DATE_FORMAT(lt.Date,'%d-%b-%y %h:%i %p')Date,lt.`Creator_UserID` RegisteredByID,em.`Name` RegisteredByName  ");
        sb.Append(" FROM patient_master pm ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`Patient_ID`=pm.`Patient_ID` ");
        sb.Append(" AND lt.`IsCancel`=0 AND pm.`IsDuplicate`=1 ");
        sb.Append(" AND DATE(lt.`Date`)>='" + dateFrom.ToString("yyyy-MM-dd") + "' AND DATE(lt.`Date`)<='" + dateTo.ToString("yyyy-MM-dd") + "' ");
        sb.Append(" AND lt.CentreID in("+CentreID.TrimEnd(',')+") ");
        sb.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=lt.`Creator_UserID` ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` GROUP BY pm.`Patient_ID`");
             

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Duplicate Patient Entry Report";
            HttpContext.Current.Session["Period"] = "From : " + dateFrom.ToString("dd-MMM-yyyy") + " To : " + dateTo.ToString("dd-MMM-yyyy");
            retValue = "1";
        }
        return retValue;
    }
}
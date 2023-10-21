using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_DateWiseItemRateReport : System.Web.UI.Page
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
    public static string getReport(string dtFrom, string dtTo)
    {
        string retValue = "0";

        DateTime dateFrom = Convert.ToDateTime(dtFrom);
        DateTime dateTo = Convert.ToDateTime(dtTo);
 	
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.`BusinessZoneName`,cm.`State`,cm.`Centre`,fpm.`Company_Name`,itm.`TestCode`,itm.`TypeName` TestName,frc.`Rate`, ");
        sb.Append(" DATE_FORMAT(frc.`FromDate`,'%d-%b-%y')FromDate,DATE_FORMAT(frc.`ToDate`,'%d-%b-%y')ToDate ");
        sb.Append(" FROM f_panel_master fpm ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=fpm.`CentreID` ");
        sb.Append(" INNER JOIN f_ratelist_schedule frc ON frc.`Panel_ID`=fpm.`Panel_ID`  ");
        sb.Append(" INNER JOIN f_itemmaster itm ON itm.`ItemID`=frc.`ItemID`  ");
        sb.Append(" WHERE frc.`IsActive`=1 AND fpm.`IsActive`=1 ");
        sb.Append(" Union ");
        sb.Append(" SELECT 'EAST'`BusinessZoneName`,'ASSAM'`State`,'SL GUWAHATI'`Centre`,'SL GUWAHATI'`Company_Name`, ");
        sb.Append(" itm.`TestCode`,itm.`TypeName` TestName,frc.`Rate`, ");
        sb.Append(" DATE_FORMAT(frc.`FromDate`,'%d-%b-%y')FromDate,DATE_FORMAT(frc.`ToDate`,'%d-%b-%y')ToDate FROM  ");
        sb.Append(" f_ratelist_schedule frc  ");
        sb.Append(" INNER JOIN f_itemmaster itm ON itm.`ItemID`=frc.`ItemID`  ");
        sb.Append(" WHERE frc.`IsActive`=1 AND frc.`Panel_ID`=78  ");
        
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Date Wise Item Rate Report";
            HttpContext.Current.Session["Period"] = "";
            retValue = "1";
        }


        return retValue;
    }
}
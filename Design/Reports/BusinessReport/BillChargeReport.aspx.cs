using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_BillChargeReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);          
        }
    }   
    [WebMethod(EnableSession = true)]
    public static string bindPanel()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT fpm.Panel_ID Panel_Id,CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name  ");
        sb.Append(" FROM f_panel_master fpm  ");
        sb.Append(" WHERE  fpm.`PanelType` <> 'Centre' ");
        
            sb.Append(" AND ( fpm.`TagBusinessLabID` =" + UserInfo.Centre + " ) ");
            
        sb.Append(" UNION ALL  ");
        sb.Append(" SELECT fpm.Panel_ID Panel_Id,CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name  ");
        sb.Append(" FROM f_panel_master fpm  ");
        sb.Append(" INNER JOIN `centre_master` cm ON cm.CentreID=fpm.`CentreID`  ");
        sb.Append(" WHERE fpm.`PanelType`='Centre' ");
        
            sb.Append(" AND ( fpm.`TagBusinessLabID` =" + UserInfo.Centre + " OR cm.CentreId =" + UserInfo.Centre + ") ");
        
        sb.Append(" ORDER BY Company_Name  ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
            {
                return Util.getJson(dt);
            }
            else
            {
                return null;
            }
        }
    }
    [WebMethod(EnableSession = true)]
    public static string exportReport(DateTime FromDate, DateTime ToDate, string PanelID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  Select Date_Format(plo.Date,'%d-%b-%Y') OpenDate, plo.`BillNo` as BillNo,lt.`PName` PatientName, ");
        sb.Append(" lt.DoctorName Referer, ");
        sb.Append(" sm.Name as ServiceSubGroup,IF(plo.ispackage=1,plo.PackageName,plo.InvestigationName) ItemDescription,lt.`PanelName` as RatePlan,plo.`Rate` Amount ,plo.Amount NetAmount,plo.`DiscountAmt` as Discount  ");
        sb.Append(" ,IF(lt.NetAmount <> lt.Adjustment,'Unpaid','Paid') PaymentStatus ");
        sb.Append(" ,if(cm.`type1` = 'CC', ROUND(ifnull(plos.PCCInvoiceAmt,0),2),plo.Amount) ClientShare,lt.LedgerTransactionNo VisitNo ");
        sb.Append(" FROM f_Ledgertransaction lt INNER JOIN Patient_Labinvestigation_OPD plo on lt.`LedgerTransactionID`=plo.ledgertransactionId ");
        sb.Append(" INNER join doctor_referal dr on lt.`Doctor_ID`=dr.`Doctor_ID` ");
        sb.Append(" INNER join f_subcategorymaster sm ON plo.`SubCategoryID`=sm.`SubCategoryID` ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
        sb.Append("  LEFT JOIN patient_labinvestigation_opd_share plos on plos.LedgerTransactionID = plo.LedgerTransactionID and plos.ItemID=plo.ItemID ");
        sb.Append(" WHERE   IF(plo.isPackage=1,plo.SubCategoryID=15,plo.SubCategoryID!=15) ");
        if (PanelID != "0")
            sb.Append(" AND lt.`Panel_id` IN (" + PanelID + ") ");

        sb.Append(" AND plo.DATE >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00" + "' AND  plo.DATE <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59" + "' ");
        sb.Append(" ORDER BY lt.PanelName,lt.Date ");

       return Util.getJson(new { Query = sb.ToString(), ReportName = "BillCharge Report", Period = string.Concat("From : ", FromDate.ToString("dd-MMM-yyyy"), " To : ", ToDate.ToString("dd-MMM-yyyy")), ReportPath = AllLoad_Data.getHostDetail("Report")  });
    }
}
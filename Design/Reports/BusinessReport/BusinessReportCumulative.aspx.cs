using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.IO;
using Newtonsoft.Json;
using MySql.Data.MySqlClient;

public partial class Design_Reports_BusinessReport_BusinessReportCumulative : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txttodate);
            reportaccess();
        }
    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(13));
        if (response.status == true)
        {
            if (response.DurationInDay > 0)
            {
                DateTime date = Util.GetDateTime(txtFromDate.Text).AddDays(response.DurationInDay);
                if (date < DateTime.Now.Date)
                {
                    lblMsg.Text = "You are not authorized to view more than " + response.DurationInDay + " days data";
                    return false;
                }
            }
            if (response.ShowPdf == 1 && response.ShowExcel == 0)
            {
                rdoReportFormat.Items[0].Enabled = true;
                rdoReportFormat.Items[1].Enabled = false;
                rdoReportFormat.Items[0].Selected = true;
            }
            else if (response.ShowExcel == 1 && response.ShowPdf == 0)
            {
                rdoReportFormat.Items[1].Enabled = true;
                rdoReportFormat.Items[0].Enabled = false;
                rdoReportFormat.Items[1].Selected = true;
            }
            else if (response.ShowPdf == 0 && response.ShowExcel == 0)
            {
                rdoReportFormat.Visible = false;
                lblMsg.Text = "Report format not allowed contect to admin";
                return false;
            }
        }
        else
        {
            divcentre.Visible = false;
            divuser.Visible = false;
            divsave.Visible = false;
            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }

    [WebMethod]
    public static string bindbusinessUnit()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT cm.Centreid,cm.centre FROM centre_master cm  ");
        sb.Append(" INNER JOIN f_panel_master pm ON pm.`TagBusinessLabID` = cm.centreID ");
        sb.Append("  ORDER by cm.centre ");
        return JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public static string bindclient(string Businessunit, string type)
    {

        if (type != "")
            type = "'" + type.Replace(",", "','") + "'";

        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT pm.panel_ID,CONCAT(IFNULL(pm.panel_code,''),' ',pm.company_Name)PanelName  ");
        sb.Append(" FROM f_panel_master pm  ");
        sb.Append(" WHERE  pm.`PanelType` <> 'Centre' ");
        if (type != "")
              sb.Append(" AND pm.PanelGroupID IN (" + type + ") ");
        if (Businessunit != "")
            sb.Append(" AND pm.`TagBusinessLabID`  IN (" + Businessunit + ")   ");
        sb.Append(" UNION ALL  ");

        sb.Append(" SELECT pm.panel_ID,CONCAT(IFNULL(cm.`CentreCode`,''),' ',cm.`Centre`)PanelName  ");
        sb.Append(" FROM f_panel_master pm  ");
        sb.Append(" INNER JOIN `centre_master` cm ON cm.CentreID=pm.`CentreID`  ");
        sb.Append(" WHERE pm.`PanelType`='Centre' ");
        if (type != "")
            sb.Append(" AND pm.PanelGroupID  IN (" + type + ") ");
        if (Businessunit != "")
            sb.Append(" AND pm.`TagBusinessLabID`  IN (" + Businessunit + ")   ");

        sb.Append(" ORDER BY PanelName  ");
        return JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }



    [WebMethod(EnableSession = true)]
    public static string bindcentertype()
    {
     
        DataTable dt = StockReports.GetDataTable("SELECT PanelGroupID ID,PanelGroup Type1 FROM f_PanelGroup WHERE Active=1 AND  PanelGroupID IN(3,4,8,9,11,2) ");
   
        return JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string binddepartment()
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT DISTINCT `DisplayName` FROM `f_subcategorymaster`  ORDER BY `DisplayName` "));
    }

    [WebMethod]
    public static string bindtest(string deptid)
    {
        if (deptid == "")
        {
            return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ItemID,concat(testcode,'~',TypeName) TypeName FROM `f_itemmaster`  ORDER BY TypeName"));
        }
        else
        {
            return JsonConvert.SerializeObject(StockReports.GetDataTable(" SELECT ItemID,CONCAT(im.testcode,'~',im.TypeName) TypeName FROM `f_itemmaster` im INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID`=im.`SubCategoryID` WHERE  sc.`DisplayName` IN('" + deptid.Replace(",", "','") + "') ORDER BY im.TypeName "));
        }
    }

    [WebMethod]
    public static string GetReport(string reportype, int isdate, DateTime fromdate, DateTime todate, int iscurrentmonth, int istoday, string businessunit,
        string centretype, string client, string reportoption, string department, string test, int isclientwisegrouping, string VisitType, string PdfOrexcel)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        string rresult = Util.DateDiffReportSearch(todate, fromdate);

        if (rresult == "true")
        {
            //return JsonConvert.SerializeObject(new { status = false, response = "Your Fromdate,Todate Diffrence is too  Long" });
            return "-1";
        }

        try
        {
            StringBuilder sb = new StringBuilder();
            if (reportype == "Cumulative")
            {
                if (reportoption == "ClientWise")
                {
                    sb = new StringBuilder();

                    sb.Append("    SELECT  ");
                    sb.Append(" Panel_Code ClientCode, Company_Name ClientName, ClientType, BusinessUnit, SUM(GrossSales)GrossSales, ");
                    sb.Append(" SUM(Disc)Disc, SUM(NetSales)NetSales, ");
                    sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `LedgerTransactionID` , NULL )) - COUNT(DISTINCT IF(`Quantity` < 0 , `LedgerTransactionID` , NULL )) Pt_Count, ");
                    sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `SampleTypeID` , NULL ),IF(`Quantity` > 0 , `LedgerTransactionID` , NULL ))-COUNT(DISTINCT IF(`Quantity` < 0 , `SampleTypeID` , NULL ),IF(`Quantity` < 0 , `LedgerTransactionID` , NULL ))  SampleCount, ");
                    sb.Append(" SUM(CashSameDate)CashSameDate, ");
                    sb.Append(" SUM(BankSameDate)BankSameDate, ");
                    sb.Append(" SUM(CollectionSameDay)CollectionSameDay, ");
                    sb.Append(" SUM(NetSales) - (SUM(CashSameDate) + SUM(BankSameDate) ) - SUM(Cr_SalesSameDay) Cash_OS_Same_Day, ");
                    sb.Append(" SUM(Cr_SalesSameDay)Cr_SalesSameDay, ");
                    sb.Append(" SUM(CashPrev_Day)CashPrev_Day, ");
                    sb.Append(" SUM(BankPrev_Day)BankPrev_Day, ");
                    sb.Append(" SUM(TotalReceivedAmount)TotalReceivedAmount, ");
                    sb.Append(" SUM(TotalCashAmount)TotalCashAmount, ");
                    sb.Append(" SUM(TotalBankAmount)TotalBankAmount ");

                    sb.Append(" FROM ( ");

                    //-- Business non CC

                    sb.Append(" SELECT pnl.Panel_ID, pnl.`Panel_Code`,pnl.`Company_Name`, pnl.PanelGroup ClientType,cm.`Centre` BusinessUnit,(plo.rate * plo.`Quantity`) GrossSales, ");
                    sb.Append(" plo.`DiscountAmt` Disc,plo.`Amount` NetSales, lt.`LedgerTransactionID`, IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`, ");
                    sb.Append(" 0 CashSameDate,	 ");
                    sb.Append(" 0 BankSameDate,	 ");
                    sb.Append(" 0 CollectionSameDay, ");
                    sb.Append(" IF(lt.`IsCredit`=1,plo.Amount,0) Cr_SalesSameDay, ");
                    sb.Append(" 0 CashPrev_Day, ");
                    sb.Append(" 0 BankPrev_Day, ");
                    sb.Append(" 0 TotalReceivedAmount , ");
                    sb.Append(" 0 TotalCashAmount, ");
                    sb.Append(" 0 TotalBankAmount, ");
                    sb.Append(" plo.`Quantity` ");
                    sb.Append(" FROM f_ledgertransaction lt  ");
                    sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
                    sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
                    sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                    sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pnl.`TagBusinessLabID` ");
                    sb.Append(" WHERE     IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)  ");
                    if (client.Trim() != string.Empty)
                        sb.Append("  AND lt.InvoiceToPanelID IN (" + client + ") ");
                    sb.Append(" AND plo.`Date`>=  @fromdate ");
                    sb.Append(" AND plo.`Date`<= @todate ");
                    if (VisitType != "0")
                        sb.Append(" AND lt.VisitType=@VisitType");

                    sb.Append(" UNION ALL  ");
                    //-- Business of CC
                    sb.Append(" SELECT pnl.Panel_ID, pnl.`Panel_Code`,pnl.`Company_Name`, pnl.PanelGroup ClientType,cm.`Centre` BusinessUnit,IFNULL(plos.PCCInvoiceAmt,0) GrossSales, ");
                    sb.Append(" 0 Disc,IFNULL(plos.PCCInvoiceAmt,0) NetSales, lt.`LedgerTransactionID`, IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`, ");
                    sb.Append(" 0 CashSameDate,	 ");
                    sb.Append(" 0 BankSameDate,	 ");
                    sb.Append(" 0 CollectionSameDay, ");
                    sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Cr_SalesSameDay, ");
                    sb.Append(" 0 CashPrev_Day, ");
                    sb.Append(" 0 BankPrev_Day, ");
                    sb.Append(" 0 TotalReceivedAmount , ");
                    sb.Append(" 0 TotalCashAmount, ");
                    sb.Append(" 0 TotalBankAmount, ");
                    sb.Append(" plo.`Quantity` ");
                    sb.Append(" FROM f_ledgertransaction lt  ");
                    sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
                    sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
                    sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` = 'CC'  ");
                    sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pnl.`TagBusinessLabID` ");
                    sb.Append(" LEFT JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = plo.LedgerTransactionID AND plos.ItemID=plo.ItemID  ");
                    sb.Append(" WHERE  IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)  ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                    sb.Append(" AND plo.`Date`>=  @fromdate");
                    sb.Append(" AND plo.`Date`<= @todate ");
                    if (VisitType != "0")
                        sb.Append(" AND lt.VisitType=@VisitType");

                    sb.Append(" UNION ALL  ");

                    //-- Collection from f_receipt 

                    sb.Append(" SELECT pnl.Panel_ID, pnl.`Panel_Code`,pnl.`Company_Name`, pnl.PanelGroup ClientType,cm.`Centre` BusinessUnit,0 GrossSales, ");
                    sb.Append(" 0 Disc,0 NetSales, NULL `LedgerTransactionID`, NULL `SampleTypeID`, ");
                    sb.Append(" IF(r.`PaymentModeID`=1 AND lt.`Date` >= @fromdate AND lt.`Date` <= @todate ,r.`Amount`,0) CashSameDate,	 ");
                    sb.Append(" IF(r.`PaymentModeID`!=1 AND lt.`Date` >= @fromdate AND lt.`Date` <= @todate ,r.`Amount`,0) BankSameDate,	 ");
                    sb.Append(" IF( lt.`Date` >= @fromdate AND lt.`Date` <= @todate ,r.`Amount`,0) CollectionSameDay, ");
                    sb.Append(" 0 Cr_SalesSameDay, ");
                    sb.Append(" IF(r.`PaymentModeID`=1 AND lt.`Date` < @fromdate ,r.`Amount`,0) CashPrev_Day, "); //Both dates are same
                    sb.Append(" IF(r.`PaymentModeID`!=1 AND lt.`Date` < @fromdate ,r.`Amount`,0) BankPrev_Day, "); // Both Dates same : 2018-09-01 00:00:00
                    sb.Append(" r.`Amount` TotalReceivedAmount ,	 ");
                    sb.Append(" IF(r.`PaymentModeID`=1 ,r.`Amount`,0) TotalCashAmount, ");
                    sb.Append(" IF(r.`PaymentModeID`!=1 ,r.`Amount`,0) TotalBankAmount, ");
                    sb.Append(" null `Quantity` ");
                    sb.Append(" FROM f_ledgertransaction lt  ");
                    sb.Append(" INNER JOIN `f_receipt` r ON r.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
                    sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
                    sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                    sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pnl.`TagBusinessLabID` ");
                    sb.Append(" WHERE r.`IsCancel`=0  ");
                    if (client.Trim() != string.Empty)
                        sb.Append("   AND lt.InvoiceToPanelID IN (" + client + ") ");
                    sb.Append(" AND r.`createddate`>=  @fromdate ");
                    sb.Append(" AND r.`createddate`<=  @todate ");
                    if (VisitType != "0")
                        sb.Append(" AND lt.VisitType=@VisitType");

                    sb.Append(" UNION ALL  ");

                    //-- Collection from `invoicemaster_onaccount` 

                    sb.Append(" SELECT pnl.Panel_ID, pnl.`Panel_Code`,pnl.`Company_Name`, pnl.PanelGroup ClientType,cm.`Centre` BusinessUnit,0 GrossSales, ");
                    sb.Append(" 0 Disc,0 NetSales, NULL `LedgerTransactionID`, NULL `SampleTypeID`, ");
                    sb.Append(" 0 CashSameDate,	 ");
                    sb.Append(" 0 BankSameDate,	 ");
                    sb.Append(" 0 CollectionSameDay, ");
                    sb.Append(" 0 Cr_SalesSameDay, ");
                    sb.Append(" IF(io.`PaymentMode`='CASH' ,io.`ReceivedAmt`,0) CashPrev_Day, ");
                    sb.Append(" IF(io.`PaymentMode`!='CASH' ,io.`ReceivedAmt`,0) BankPrev_Day, ");
                    sb.Append(" io.`ReceivedAmt` TotalReceivedAmount ,	 ");
                    sb.Append(" IF(io.`PaymentMode`='CASH' ,io.`ReceivedAmt`,0) TotalCashAmount, ");
                    sb.Append(" IF(io.`PaymentMode`!='CASH' ,io.`ReceivedAmt`,0) TotalBankAmount, ");
                    sb.Append(" null `Quantity` ");
                    sb.Append(" FROM `invoicemaster_onaccount` io  ");
                    sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=io.`Panel_ID` ");
                    sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pnl.`TagBusinessLabID` ");
                    sb.Append(" WHERE io.`IsCancel`=0  ");
                    sb.Append(" AND io.`CreditNote`=0 ");
                    if (client.Trim() != string.Empty)
                        sb.Append("   AND pnl.`Panel_ID` IN (" + client + ") ");

                    sb.Append(" AND io.`ReceivedDate` >=  @fromdate  ");
                    sb.Append(" AND io.`ReceivedDate` <=   @todate ");

                    sb.Append(" ) aa ");
                    sb.Append(" GROUP BY Panel_ID ");
                    sb.Append(" order by BusinessUnit,ClientName ");

                }
                else if (reportoption == "DepartmentWise")
                {
                    sb = new StringBuilder();

                    sb.Append(" SELECT ");
                    if (isclientwisegrouping == 1)
                        sb.Append("   ClientCode, ClientName, ClientType, TabBusinessCode, TagBusinessUnit, ");
                    sb.Append(" Department, ");

                    sb.Append(" SUM(Rate) Rate,SUM(Disc)Disc,SUM(Net) Net, ");
                    sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `LedgerTransactionID` , NULL )) - COUNT(DISTINCT IF(`Quantity` < 0 , `LedgerTransactionID` , NULL )) PatientCount, ");
                    sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `SampleTypeID` , NULL ),IF(`Quantity` > 0 , `LedgerTransactionID` , NULL ))-COUNT(DISTINCT IF(`Quantity` < 0 , `SampleTypeID` , NULL ),IF(`Quantity` < 0 , `LedgerTransactionID` , NULL ))  SampleCount, ");
                    sb.Append(" Panel_ID,ItemID from ( ");

                    sb.Append(" SELECT ");
                    if (isclientwisegrouping == 1)
                        sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" sc.`DisplayName` Department, ");
                    sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net,lt.`LedgerTransactionID`, ");
                    sb.Append("  IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`, lt.`InvoiceToPanelID` Panel_ID, plo.ItemID, sc.DisplayName, ");
                    sb.Append(" plo.`Quantity` ");
                    sb.Append(" FROM `f_ledgertransaction` lt ");
                    sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");

                    sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                    sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");

                    if (isclientwisegrouping == 1)
                    {
                        sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                        sb.Append("  LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`  ");
                    }
                    sb.Append(" WHERE  IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");

                    sb.Append(" AND plo.`Date`>=  @fromdate  ");
                    sb.Append(" AND plo.`Date`<=  @todate ");
                    if (department != "")
                        sb.Append(" and sc.DisplayName in ('" + department.Replace(",", "','") + "')");
                    if (VisitType != "0")
                        sb.Append(" AND lt.VisitType=@VisitType");

                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT ");
                    if (isclientwisegrouping == 1)
                        sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" sc.`DisplayName` Department, ");
                    sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net,lt.`LedgerTransactionID`, ");
                    sb.Append("  IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`, lt.`InvoiceToPanelID` Panel_ID, plo.ItemID, sc.DisplayName, ");
                    sb.Append(" plo.`Quantity` ");
                    sb.Append(" FROM `f_ledgertransaction` lt ");
                    sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                    sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                    sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` = 'CC'  ");

                    if (isclientwisegrouping == 1)
                    {
                        sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                        sb.Append("  LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`  ");
                    }
                    sb.Append(" LEFT JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = plo.LedgerTransactionID AND plos.ItemID=plo.ItemID    ");
                    sb.Append(" WHERE  IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");

                    sb.Append(" AND plo.`Date`>=  @fromdate ");
                    sb.Append(" AND plo.`Date`<=  @todate ");
                    if (department != "")
                        sb.Append(" and sc.DisplayName in ('" + department.Replace(",", "','") + "')");
                    if (VisitType != "0")
                        sb.Append(" AND lt.VisitType=@VisitType");
                    sb.Append(" ) aa  ");
                    sb.Append(" GROUP BY  ");
                    sb.Append(" `DisplayName` ");
                    if (isclientwisegrouping == 1)
                        sb.Append(" , `Panel_ID`  ");
                }
                else if (reportoption == "TestWise")
                {
                    sb = new StringBuilder();

                    sb.Append(" SELECT ");
                    if (isclientwisegrouping == 1)
                        sb.Append("  ClientCode,ClientName,ClientType,TabBusinessCode,TagBusinessUnit, ");
                    sb.Append(" Department,`ItemName`, ");
                    sb.Append(" Round(SUM(Rate)) Rate,Round(SUM(Disc))Disc,Round(SUM(Net)) Net, ");
                    sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `LedgerTransactionID` , NULL )) - COUNT(DISTINCT IF(`Quantity` < 0 , `LedgerTransactionID` , NULL )) PatientCount, ");
                    sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `SampleTypeID` , NULL ),IF(`Quantity` > 0 , `LedgerTransactionID` , NULL ))-COUNT(DISTINCT IF(`Quantity` < 0 , `SampleTypeID` , NULL ),IF(`Quantity` < 0 , `LedgerTransactionID` , NULL ))  SampleCount, ");

                    sb.Append(" Panel_ID,ItemID,BillingCategory from ( ");
                    sb.Append(" SELECT ");
                    if (isclientwisegrouping == 1)
                        sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                    sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net,lt.`LedgerTransactionID`, ");
                    sb.Append(" IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`,lt.`InvoiceToPanelID` Panel_ID,plo.ItemID, ");
                    sb.Append(" plo.`Quantity` ");
                    //--------------------------------------------------
                    sb.Append(" ,bcm.Name As BillingCategory ");

                    sb.Append(" FROM `f_ledgertransaction` lt ");
                    sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                    sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                    sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                    if (isclientwisegrouping == 1)
                    {
                        sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                        sb.Append("  LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`  ");
                    }
                    //---------Added By Apurva for Billing category---------------
                    sb.Append(" INNER JOIN f_ItemMaster im ON plo.ItemId=im.ItemId ");
                    sb.Append(" INNER JOIN `billingcategory_master` bcm ON im.Bill_Category=bcm.ID");
                    //--------------------------------------------------------------

                    sb.Append(" WHERE IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");

                    sb.Append(" AND plo.`Date`>=  @fromdate  ");
                    sb.Append(" AND plo.`Date`<=  @todate ");
                    if (department != "")
                        sb.Append(" and plo.`ItemId` in ('" + test.Replace(",", "','") + "')");
                    if (VisitType != "0")
                        sb.Append(" AND lt.VisitType=@VisitType");


                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT ");
                    if (isclientwisegrouping == 1)
                        sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                    sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net,lt.`LedgerTransactionID`, ");
                    sb.Append(" IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`) `SampleTypeID`,lt.`InvoiceToPanelID` Panel_ID,plo.ItemID, ");
                    sb.Append(" plo.`Quantity` ");
                    //--------------------------------------------------
                    sb.Append(" ,bcm.Name As BillingCategory ");

                    sb.Append(" FROM `f_ledgertransaction` lt ");
                    sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                    sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` = 'CC'  ");
                    sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                    if (isclientwisegrouping == 1)
                    {
                        sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                        sb.Append("  LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`  ");
                    }
                    sb.Append(" LEFT JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = plo.LedgerTransactionID AND plos.ItemID=plo.ItemID    ");
                    //---------Added By Apurva for Billing category---------------
                    sb.Append(" INNER JOIN f_ItemMaster im ON plo.ItemId=im.ItemId ");
                    sb.Append(" INNER JOIN `billingcategory_master` bcm ON im.Bill_Category=bcm.ID");
                    //--------------------------------------------------------------

                    sb.Append(" WHERE IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");

                    sb.Append(" AND plo.`Date`>=  @fromdate  ");
                    sb.Append(" AND plo.`Date`<=  @todate ");
                    if (department != "")
                        sb.Append(" and plo.`ItemId` in ('" + test.Replace(",", "','") + "')");
                    if (VisitType != "0")
                        sb.Append(" AND lt.VisitType=@VisitType");

                    sb.Append(" )  aa  ");
                    sb.Append(" GROUP BY  ");
                    sb.Append(" `ItemName` ");
                    if (isclientwisegrouping == 1)
                        sb.Append(" , `Panel_ID`  ");
                }

            }
            else if (reportype == "MonthWiseTrend")
            {
                DateTime dateFrom = Convert.ToDateTime(fromdate);
                DateTime dateTo = Convert.ToDateTime(todate);
                double TotDays = (dateTo - dateFrom).TotalDays;
                if (TotDays > 365)
                {

                    return "2";
                }
                else
                {
                    sb = new StringBuilder();
                    if (reportoption == "ClientWise")
                    {

                        sb.Append("  SELECT MONTHNAME(`Date`)`MonthName`, ClientCode,ClientName,ClientType,TabBusinessCode, TagBusinessUnit, ");
                        sb.Append(" SUM(Rate) Rate,SUM(Disc)Disc,SUM(Net) Net, ");
                        sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `LedgerTransactionID` , NULL )) - COUNT(DISTINCT IF(`Quantity` < 0 , `LedgerTransactionID` , NULL )) PatientCount, ");
                        sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `SampleTypeID` , NULL ),IF(`Quantity` > 0 , `LedgerTransactionID` , NULL ))-COUNT(DISTINCT IF(`Quantity` < 0 , `SampleTypeID` , NULL ),IF(`Quantity` < 0 , `LedgerTransactionID` , NULL ))  SampleCount, ");

                        sb.Append(" Panel_ID, ItemID  from ( ");

                        sb.Append("  SELECT lt.`Date`, pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                        sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net, lt.`LedgerTransactionID`,  ");
                        sb.Append("  IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`) `SampleTypeID` ,lt.Panel_ID,plo.ItemID,  ");
                        sb.Append(" plo.`Quantity` ");
                        sb.Append("  FROM `f_ledgertransaction` lt   ");
                        sb.Append("  INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                        sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                        sb.Append("  INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                        sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                        sb.Append(" WHERE IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)   ");
                        if (client.Trim() != string.Empty)
                            sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");

                        sb.Append(" AND plo.`Date`>=  @fromdate ");
                        sb.Append(" AND plo.`Date`<=  @todate ");
                        if (VisitType != "0")
                            sb.Append(" AND lt.VisitType=@VisitType");
                        sb.Append("  UNION ALL  ");

                        sb.Append("  SELECT lt.`Date`, pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                        sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net, lt.`LedgerTransactionID`,  ");
                        sb.Append("  IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`) `SampleTypeID` ,lt.Panel_ID,plo.ItemID,  ");
                        sb.Append(" plo.`Quantity` ");
                        sb.Append("  FROM `f_ledgertransaction` lt   ");
                        sb.Append("  INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                        sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                        sb.Append("  INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` = 'CC'  ");
                        sb.Append(" LEFT JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = plo.LedgerTransactionID AND plos.ItemID=plo.ItemID    ");
                        sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                        sb.Append(" WHERE IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)   ");
                        if (client.Trim() != string.Empty)
                            sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");

                        sb.Append(" AND plo.`Date`>=  @fromdate ");
                        sb.Append(" AND plo.`Date`<=  @todate ");
                        if (VisitType != "0")
                            sb.Append(" AND lt.VisitType=@VisitType");

                        sb.Append("  ) aa  ");
                        sb.Append("  GROUP BY `ClientCode`,MONTH(`Date`)  ");
                        sb.Append("  ORDER BY   YEAR(`Date`), MONTH(`Date`),`ClientName` ");
                    }
                    else if (reportoption == "DepartmentWise")
                    {
                        sb = new StringBuilder();

                        sb.Append("  SELECT MONTHNAME(`Date`)`MonthName`, ");
                        if (isclientwisegrouping == 1)
                            sb.Append(" ClientCode,ClientName,ClientType,TabBusinessCode,TagBusinessUnit, ");
                        sb.Append(" Department, ");
                        sb.Append(" SUM(Rate) Rate,SUM(Disc)Disc,SUM(Net) Net, ");
                        sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `LedgerTransactionID` , NULL )) - COUNT(DISTINCT IF(`Quantity` < 0 , `LedgerTransactionID` , NULL )) PatientCount, ");
                        sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `SampleTypeID` , NULL ),IF(`Quantity` > 0 , `LedgerTransactionID` , NULL ))-COUNT(DISTINCT IF(`Quantity` < 0 , `SampleTypeID` , NULL ),IF(`Quantity` < 0 , `LedgerTransactionID` , NULL ))  SampleCount, ");

                        sb.Append(" Panel_ID,ItemID  from (  ");
                        sb.Append("  SELECT lt.`Date`, ");
                        if (isclientwisegrouping == 1)
                            sb.Append(" pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                        sb.Append(" sc.`DisplayName` Department, ");
                        sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net,lt.`LedgerTransactionID`,  ");
                        sb.Append("  IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`) `SampleTypeID`,lt.Panel_ID,plo.ItemID ,  ");
                        sb.Append(" plo.`Quantity` ");
                        sb.Append("  FROM `f_ledgertransaction` lt   ");
                        sb.Append("  INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                        sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                        sb.Append("  INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                        if (isclientwisegrouping == 1)
                        {
                            sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                            sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                        }
                        sb.Append(" WHERE IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)   ");
                        if (client.Trim() != string.Empty)
                            sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                        sb.Append(" AND plo.`Date`>=  @fromdate");
                        sb.Append(" AND plo.`Date`<=  @todate ");
                        if (department != "")
                            sb.Append(" and sc.DisplayName in ('" + department.Replace(",", "','") + "')");
                        if (VisitType != "0")
                            sb.Append(" AND lt.VisitType=@VisitType");

                        sb.Append("  UNION ALL ");
                        sb.Append("  SELECT lt.`Date`, ");
                        if (isclientwisegrouping == 1)
                            sb.Append(" pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                        sb.Append(" sc.`DisplayName` Department, ");
                        sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net,lt.`LedgerTransactionID`,  ");
                        sb.Append("  IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`) `SampleTypeID`,lt.Panel_ID,plo.ItemID ,  ");
                        sb.Append(" plo.`Quantity` ");
                        sb.Append("  FROM `f_ledgertransaction` lt   ");
                        sb.Append("  INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                        sb.Append("  INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                        sb.Append("  INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` = 'CC'  ");
                        if (isclientwisegrouping == 1)
                        {
                            sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                            sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                        }
                        sb.Append(" LEFT JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = plo.LedgerTransactionID AND plos.ItemID=plo.ItemID    ");
                        sb.Append(" WHERE IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)   ");
                        if (client.Trim() != string.Empty)
                            sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");

                        sb.Append(" AND plo.`Date`>=  @fromdate ");
                        sb.Append(" AND plo.`Date`<=  @todate ");
                        if (department != "")
                            sb.Append(" and sc.DisplayName in ('" + department.Replace(",", "','") + "')");
                        if (VisitType != "0")
                            sb.Append(" AND lt.VisitType=@VisitType");
                        sb.Append("  ) aa ");

                        sb.Append("  GROUP BY `Department`,MONTH(`Date`)  ");

                        if (isclientwisegrouping == 1)
                            sb.Append(" , `ClientCode`  ");
                        sb.Append("  ORDER BY ");
                        sb.Append("  MONTH(`Date`) ");
                        if (isclientwisegrouping == 1)
                            sb.Append(" ,`ClientName` ");

                    }
                    else if (reportoption == "TestWise")
                    {
                        sb = new StringBuilder();

                        sb.Append("  SELECT MONTHNAME(`Date`)`MonthName`, ");
                        if (isclientwisegrouping == 1)
                            sb.Append("  ClientCode,ClientName,ClientType,TabBusinessCode,TagBusinessUnit, ");
                        sb.Append(" Department,`ItemName`, ");
                        sb.Append(" Round(SUM(Rate)) Rate,Round(SUM(Disc))Disc,Round(SUM(Net)) Net, ");

                        sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `LedgerTransactionID` , NULL )) - COUNT(DISTINCT IF(`Quantity` < 0 , `LedgerTransactionID` , NULL )) PatientCount, ");
                        sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `SampleTypeID` , NULL ),IF(`Quantity` > 0 , `LedgerTransactionID` , NULL ))-COUNT(DISTINCT IF(`Quantity` < 0 , `SampleTypeID` , NULL ),IF(`Quantity` < 0 , `LedgerTransactionID` , NULL ))  SampleCount, ");

                        sb.Append(" Panel_ID , ItemID,BillingCategory from (");
                        sb.Append("  SELECT lt.`Date`, ");
                        if (isclientwisegrouping == 1)
                            sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                        sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                        sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net,lt.`LedgerTransactionID`,  ");
                        sb.Append(" IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID` ,lt.Panel_ID ,plo.ItemID, ");
                        sb.Append(" plo.`Quantity` ");
                        //--------------------------------------------------
                        sb.Append(" ,bcm.Name As BillingCategory ");

                        sb.Append("  FROM `f_ledgertransaction` lt   ");
                        sb.Append("  INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                        sb.Append("  INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                        sb.Append("  INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                        if (isclientwisegrouping == 1)
                        {
                            sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                            sb.Append("  LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                        }
                        sb.Append(" INNER JOIN f_ItemMaster im ON plo.ItemId=im.ItemId ");
                        sb.Append(" INNER JOIN `billingcategory_master` bcm ON im.Bill_Category=bcm.ID");
                        //--------------------------------------------------------------

                        sb.Append(" WHERE IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)   ");
                        if (client.Trim() != string.Empty)
                            sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");

                        sb.Append(" AND plo.`Date`>=  @fromdate ");
                        sb.Append(" AND plo.`Date`<=  @todate ");

                        if (department != "")
                            sb.Append(" and plo.`ItemId` in ('" + test.Replace(",", "','") + "')");
                        if (VisitType != "0")
                            sb.Append(" AND lt.VisitType=@VisitType");

                        sb.Append("  UNION ALL ");

                        sb.Append("  SELECT lt.`Date`, ");
                        if (isclientwisegrouping == 1)
                            sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                        sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                        sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net,lt.`LedgerTransactionID`,  ");
                        sb.Append(" IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID` ,lt.Panel_ID ,plo.ItemID, ");
                        sb.Append(" plo.`Quantity` ");
                        //--------------------------------------------------
                        sb.Append(" ,bcm.Name As BillingCategory ");

                        sb.Append("  FROM `f_ledgertransaction` lt   ");
                        sb.Append("  INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                        sb.Append("  INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                        sb.Append("  INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` = 'CC'  ");
                        if (isclientwisegrouping == 1)
                        {
                            sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                            sb.Append("  LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                        }
                        sb.Append(" LEFT JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = plo.LedgerTransactionID AND plos.ItemID=plo.ItemID    ");
                        //---------Added By Apurva for Billing category---------------
                        sb.Append(" INNER JOIN f_ItemMaster im ON plo.ItemId=im.ItemId ");
                        sb.Append(" INNER JOIN `billingcategory_master` bcm ON im.Bill_Category=bcm.ID");
                        //--------------------------------------------------------------

                        sb.Append(" WHERE  IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)   ");
                        if (client.Trim() != string.Empty)
                            sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");


                        sb.Append(" AND plo.`Date`>=  @fromdate ");
                        sb.Append(" AND plo.`Date`<=  @todate ");

                        if (department != "")
                            sb.Append(" and plo.`ItemId` in ('" + test.Replace(",", "','") + "')");
                        if (VisitType != "0")
                            sb.Append(" AND lt.VisitType=@VisitType");

                        sb.Append(" ) aa ");

                        sb.Append(" GROUP BY  ");
                        sb.Append(" `ItemName`,MONTH(`Date`) ");
                        if (isclientwisegrouping == 1)
                            sb.Append(" , ClientCode ");
                        sb.Append("  ORDER BY ");
                        sb.Append("  MONTH(`Date`) ");
                        if (isclientwisegrouping == 1)
                            sb.Append(" ,ClientName ");

                    }
                }
            }
            else if (reportype == "DateWiseTrend")
            {
                DateTime dateFrom = Convert.ToDateTime(fromdate);
                DateTime dateTo = Convert.ToDateTime(todate);
                double TotDays = (dateTo - dateFrom).TotalDays;
                if (TotDays > 31)
                {
                    return "3";
                }
                else
                {
                    sb = new StringBuilder();
                    if (reportoption == "ClientWise")
                    {

                        sb.Append(" SELECT DAY(`Date`)`Date`, ClientCode,ClientName,ClientType, TabBusinessCode, TagBusinessUnit, ");
                        sb.Append("  Department,`ItemName`, ");
                        sb.Append(" SUM(Rate) Rate,SUM(Disc)Disc,SUM(Net) Net, ");
                    
                        sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `LedgerTransactionID` , NULL )) - COUNT(DISTINCT IF(`Quantity` < 0 , `LedgerTransactionID` , NULL )) PatientCount, ");
                        sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `SampleTypeID` , NULL ),IF(`Quantity` > 0 , `LedgerTransactionID` , NULL ))-COUNT(DISTINCT IF(`Quantity` < 0 , `SampleTypeID` , NULL ),IF(`Quantity` < 0 , `LedgerTransactionID` , NULL ))  SampleCount, ");


                        sb.Append(" Panel_ID,ItemID from ( ");


                        sb.Append(" SELECT lt.`Date`, pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                        sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                        sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net, lt.`LedgerTransactionID`, ");
                        sb.Append(" IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`,lt.Panel_ID,plo.ItemID, ");
                        sb.Append(" plo.`Quantity` ");
                        sb.Append("  FROM `f_ledgertransaction` lt ");
                        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                        sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                        sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                        sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                        sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");

                        sb.Append(" WHERE IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                        if (client.Trim() != string.Empty)
                            sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");

                        sb.Append(" AND plo.`Date`>=  @fromdate  ");
                        sb.Append(" AND plo.`Date`<=  @todate ");
                        if (VisitType != "0")
                            sb.Append(" AND lt.VisitType=@VisitType");
                        sb.Append(" UNION ALL  ");

                        sb.Append(" SELECT lt.`Date`, pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                        sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                        sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net, lt.`LedgerTransactionID`, ");
                        sb.Append(" IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`,lt.Panel_ID,plo.ItemID, ");
                        sb.Append(" plo.`Quantity` ");
                        sb.Append("  FROM `f_ledgertransaction` lt ");
                        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                        sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                        sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                        sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` = 'CC'  ");
                        sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                        sb.Append(" LEFT JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = plo.LedgerTransactionID AND plos.ItemID=plo.ItemID    ");
                        sb.Append(" WHERE IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                        if (client.Trim() != string.Empty)
                            sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");

                        sb.Append(" AND plo.`Date`>=  @fromdate ");
                        sb.Append(" AND plo.`Date`<=  @todate ");
                        if (VisitType != "0")
                            sb.Append(" AND lt.VisitType=@VisitType");

                        sb.Append(" ) aa  ");

                        sb.Append(" GROUP BY  ");
                        sb.Append("  DAY(`Date`), ClientCode ");
                    }

                    else if (reportoption == "DepartmentWise")
                    {
                        sb = new StringBuilder();


                        sb.Append(" SELECT DAY(`Date`)`Date`, ");
                        if (isclientwisegrouping == 1)
                            sb.Append(" ClientCode,ClientName,ClientType,TabBusinessCode,TagBusinessUnit, ");
                        sb.Append(" Department, ");
                        sb.Append(" SUM(Rate) Rate,SUM(Disc)Disc,SUM(Net) Net, ");
                      
                        sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `LedgerTransactionID` , NULL )) - COUNT(DISTINCT IF(`Quantity` < 0 , `LedgerTransactionID` , NULL )) PatientCount, ");
                        sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `SampleTypeID` , NULL ),IF(`Quantity` > 0 , `LedgerTransactionID` , NULL ))-COUNT(DISTINCT IF(`Quantity` < 0 , `SampleTypeID` , NULL ),IF(`Quantity` < 0 , `LedgerTransactionID` , NULL ))  SampleCount, ");


                        sb.Append(" Panel_ID , ItemID from ( ");
                        sb.Append(" SELECT lt.`Date`, ");
                        if (isclientwisegrouping == 1)
                            sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                        sb.Append(" sc.`DisplayName` Department, ");
                        sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net,lt.`LedgerTransactionID`, ");
                        sb.Append(" IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`,lt.Panel_ID ,plo.ItemID, ");
                        sb.Append(" plo.`Quantity` ");
                        sb.Append("  FROM `f_ledgertransaction` lt ");
                        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                        sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                        sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                        if (isclientwisegrouping == 1)
                        {
                            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                            sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                        }
                        sb.Append(" WHERE IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                        if (client.Trim() != string.Empty)
                            sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");


                        sb.Append(" AND plo.`Date`>=  @fromdate ");
                        sb.Append(" AND plo.`Date`<=  @todate ");
                        if (department != "")
                            sb.Append(" and sc.DisplayName in ('" + department.Replace(",", "','") + "')");
                        if (VisitType != "0")
                            sb.Append(" AND lt.VisitType=@VisitType");
                        sb.Append(" UNION ALL ");

                        sb.Append(" SELECT lt.`Date`, ");
                        if (isclientwisegrouping == 1)
                            sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                        sb.Append(" sc.`DisplayName` Department, ");
                        sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net,lt.`LedgerTransactionID`, ");
                        sb.Append(" IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`,lt.Panel_ID ,plo.ItemID, ");
                        sb.Append(" plo.`Quantity` ");
                        sb.Append("  FROM `f_ledgertransaction` lt ");
                        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                        sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                        sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` = 'CC'  ");
                        if (isclientwisegrouping == 1)
                        {
                            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                            sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");

                        }
                        sb.Append(" LEFT JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = plo.LedgerTransactionID AND plos.ItemID=plo.ItemID    ");
                        sb.Append(" WHERE IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                        if (client.Trim() != string.Empty)
                            sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");


                        sb.Append(" AND plo.`Date`>=  @fromdate ");
                        sb.Append(" AND plo.`Date`<=  @todate  ");
                        if (department != "")
                            sb.Append(" and sc.DisplayName in ('" + department.Replace(",", "','") + "')");
                        if (VisitType != "0")
                            sb.Append(" AND lt.VisitType=@VisitType");

                        sb.Append(" ) aa ");
                        sb.Append(" GROUP BY  ");
                        sb.Append(" DAY(`Date`), `Department` ");
                        if (isclientwisegrouping == 1)
                            sb.Append(" , `ClientCode`  ");

                    }
                    else if (reportoption == "TestWise")
                    {
                        sb = new StringBuilder();
                        sb.Append(" SELECT DAY(`Date`)`Date`, ");
                        if (isclientwisegrouping == 1)
                            sb.Append("  ClientCode,ClientName,ClientType,TabBusinessCode,TagBusinessUnit, ");
                        sb.Append(" Department,`ItemName`, ");
                        sb.Append(" Round(SUM(Rate)) Rate,Round(SUM(Disc))Disc,Round(SUM(Net)) Net, ");
                        sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `LedgerTransactionID` , NULL )) - COUNT(DISTINCT IF(`Quantity` < 0 , `LedgerTransactionID` , NULL )) PatientCount, ");
                        sb.Append(" COUNT(DISTINCT IF(`Quantity` > 0 , `SampleTypeID` , NULL ),IF(`Quantity` > 0 , `LedgerTransactionID` , NULL ))-COUNT(DISTINCT IF(`Quantity` < 0 , `SampleTypeID` , NULL ),IF(`Quantity` < 0 , `LedgerTransactionID` , NULL ))  SampleCount, ");
                        sb.Append(" Panel_ID,ItemID,BillingCategory from ( ");
                        sb.Append(" SELECT lt.`Date`, ");
                        if (isclientwisegrouping == 1)
                            sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                        sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                        sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net,lt.`LedgerTransactionID`, ");
                        sb.Append(" IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`, lt.Panel_ID , plo.ItemID, ");
                        sb.Append(" plo.`Quantity` ");
                        //---------------------------
                        sb.Append(" ,bcm.Name As BillingCategory ");

                        sb.Append("  FROM `f_ledgertransaction` lt ");
                        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                        sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                        sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                        if (isclientwisegrouping == 1)
                        {
                            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                            sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                        }
                        //---------Added By Apurva for Billing category---------------
                        sb.Append(" INNER JOIN f_ItemMaster im ON plo.ItemId=im.ItemId ");
                        sb.Append(" INNER JOIN `billingcategory_master` bcm ON im.Bill_Category=bcm.ID");
                        //--------------------------------------------------------------
                        sb.Append(" WHERE IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                        if (client.Trim() != string.Empty)
                            sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");


                        sb.Append(" AND plo.`Date`>= @fromdate ");
                        sb.Append(" AND plo.`Date`<= @todate ");

                        if (department != "")
                            sb.Append(" and plo.`ItemId` in ('" + test.Replace(",", "','") + "')");
                        if (VisitType != "0")
                            sb.Append(" AND lt.VisitType=@VisitType");

                        sb.Append(" UNION ALL ");

                        sb.Append(" SELECT lt.`Date`, ");
                        if (isclientwisegrouping == 1)
                            sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                        sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                        sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net,lt.`LedgerTransactionID`, ");
                        sb.Append(" IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`, lt.Panel_ID , plo.ItemID, ");
                        sb.Append(" plo.`Quantity` ");
                        //---------------------------
                        sb.Append(" ,bcm.Name As BillingCategory ");

                        sb.Append("  FROM `f_ledgertransaction` lt ");
                        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                        sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                        sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` = 'CC'  ");
                        if (isclientwisegrouping == 1)
                        {
                            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                            sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                        }
                        sb.Append(" LEFT JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = plo.LedgerTransactionID AND plos.ItemID=plo.ItemID    ");
                        //---------Added By Apurva for Billing category---------------
                        sb.Append(" INNER JOIN f_ItemMaster im ON plo.ItemId=im.ItemId ");
                        sb.Append(" INNER JOIN `billingcategory_master` bcm ON im.Bill_Category=bcm.ID");
                        //--------------------------------------------------------------
                        sb.Append(" WHERE  IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                        if (client.Trim() != string.Empty)
                            sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");


                        sb.Append(" AND plo.`Date`>= @fromdate ");
                        sb.Append(" AND plo.`Date`<= @todate ");

                        if (department != "")
                            sb.Append(" and plo.`ItemId` in ('" + test.Replace(",", "','") + "')");
                        if (VisitType != "0")
                            sb.Append(" AND lt.VisitType=@VisitType");

                        sb.Append(" ) aa ");

                        sb.Append(" GROUP BY  ");
                        sb.Append(" DAY(`Date`), Department, `ItemId` ");
                        if (isclientwisegrouping == 1)
                            sb.Append(" , ClientCode  ");

                    }
                }
            }
            DataTable dtMerge = new DataTable();
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@fromdate",string.Concat(fromdate.ToString("yyyy-MM-dd"), " 00:00:00")),
                new MySqlParameter("@todate",string.Concat(todate.ToString("yyyy-MM-dd"), " 23:59:59")),
                new MySqlParameter("@VisitType", VisitType)).Tables[0];

            int AmountStartIndex = 0;
            if (dt.Rows.Count > 0)
            {
                if (reportype == "MonthWiseTrend" || reportype == "DateWiseTrend")
                {

                    if (reportoption == "ClientWise" || isclientwisegrouping == 1)
                    {
                        dtMerge.Columns.Add("ClientCode");
                        dtMerge.Columns.Add("ClientName");
                        dtMerge.Columns.Add("ClientType");
                        dtMerge.Columns.Add("TabBusinessCode");
                        dtMerge.Columns.Add("TagBusinessUnit");
                    }
                    if (reportoption == "DepartmentWise")
                    {
                        dtMerge.Columns.Add("Department");

                    }
                    else if (reportoption == "TestWise")
                    {
                        dtMerge.Columns.Add("Department");
                        dtMerge.Columns.Add("ItemName");
                        dtMerge.Columns.Add("BillingCategory");


                    }
                    dtMerge.Columns.Add("Type");
                    dtMerge.Columns.Add("Priority", typeof(int));
                    // dtMerge.Columns.Add("Panel_ID");

                    foreach (DataRow drMain in dt.Rows)
                    {


                        if (reportype == "MonthWiseTrend" && reportoption == "ClientWise")
                        {
                            AmountStartIndex = 5;
                            if (!dtMerge.Columns.Contains(drMain["MonthName"].ToString()))
                            {
                                dtMerge.Columns.Add(drMain["MonthName"].ToString(), typeof(double));
                                dtMerge.Columns[drMain["MonthName"].ToString()].DefaultValue = Util.GetDouble(0);
                            }
                            DataRow[] DRtemp = dtMerge.Select("ClientCode='" + drMain["ClientCode"].ToString() + "'", "Priority");
                            if (DRtemp.Length == 0)
                            {
                                DataRow NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Type"] = "NetAmount";
                                NewMerge[drMain["MonthName"].ToString()] = drMain["Net"].ToString();
                                NewMerge["Priority"] = "0";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Type"] = "PatientCount";
                                NewMerge[drMain["MonthName"].ToString()] = drMain["PatientCount"].ToString();
                                NewMerge["Priority"] = "1";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Type"] = "SampleCount";
                                NewMerge[drMain["MonthName"].ToString()] = drMain["SampleCount"].ToString();
                                NewMerge["Priority"] = "2";
                                dtMerge.Rows.Add(NewMerge);


                            }
                            else
                            {

                                DRtemp[0][drMain["MonthName"].ToString()] = drMain["Net"].ToString();
                                DRtemp[1][drMain["MonthName"].ToString()] = drMain["PatientCount"].ToString();
                                DRtemp[2][drMain["MonthName"].ToString()] = drMain["SampleCount"].ToString();
                            }

                        }
                        else if (reportype == "DateWiseTrend" && reportoption == "ClientWise")
                        {

                            if (!dtMerge.Columns.Contains(drMain["Date"].ToString()))
                            {


                                dtMerge.Columns.Add(drMain["Date"].ToString(), typeof(double));
                                dtMerge.Columns[drMain["Date"].ToString()].DefaultValue = Util.GetDouble(0);

                            }
                            DataRow[] DRtemp = dtMerge.Select("ClientCode='" + drMain["ClientCode"].ToString() + "'", "Priority");
                            if (DRtemp.Length == 0)
                            {
                                DataRow NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Type"] = "NetAmount";
                                NewMerge[drMain["Date"].ToString()] = drMain["Net"].ToString();
                                NewMerge["Priority"] = "0";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Type"] = "PatientCount";
                                NewMerge[drMain["Date"].ToString()] = drMain["PatientCount"].ToString();
                                NewMerge["Priority"] = "1";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Type"] = "SampleCount";
                                NewMerge[drMain["Date"].ToString()] = drMain["SampleCount"].ToString();
                                NewMerge["Priority"] = "2";
                                dtMerge.Rows.Add(NewMerge);


                            }
                            else
                            {

                                DRtemp[0][drMain["Date"].ToString()] = drMain["Net"].ToString();
                                DRtemp[1][drMain["Date"].ToString()] = drMain["PatientCount"].ToString();
                                DRtemp[2][drMain["Date"].ToString()] = drMain["SampleCount"].ToString();
                            }

                        }

                        if (reportype == "MonthWiseTrend" && reportoption == "DepartmentWise" && isclientwisegrouping == 0)
                        {

                            if (!dtMerge.Columns.Contains(drMain["MonthName"].ToString()))
                            {

                                dtMerge.Columns.Add(drMain["MonthName"].ToString(), typeof(double));
                                dtMerge.Columns[drMain["MonthName"].ToString()].DefaultValue = Util.GetDouble(0);


                            }
                            DataRow[] DRtemp = dtMerge.Select("Department='" + drMain["Department"].ToString() + "'", "Priority");
                            if (DRtemp.Length == 0)
                            {
                                DataRow NewMerge = dtMerge.NewRow();
                                // NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                // NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                // NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                // NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["Type"] = "NetAmount";
                                NewMerge[drMain["MonthName"].ToString()] = drMain["Net"].ToString();
                                NewMerge["Priority"] = "0";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                //NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                //NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                //NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                //NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["Type"] = "PatientCount";
                                NewMerge[drMain["MonthName"].ToString()] = drMain["PatientCount"].ToString();
                                NewMerge["Priority"] = "1";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                //NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                //NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                //NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                //NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["Type"] = "SampleCount";
                                NewMerge[drMain["MonthName"].ToString()] = drMain["SampleCount"].ToString();
                                NewMerge["Priority"] = "2";
                                dtMerge.Rows.Add(NewMerge);


                            }
                            else
                            {

                                DRtemp[0][drMain["MonthName"].ToString()] = drMain["Net"].ToString();
                                DRtemp[1][drMain["MonthName"].ToString()] = drMain["PatientCount"].ToString();
                                DRtemp[2][drMain["MonthName"].ToString()] = drMain["SampleCount"].ToString();
                            }

                        }
                        if (reportype == "MonthWiseTrend" && reportoption == "DepartmentWise" && isclientwisegrouping == 1)
                        {

                            if (!dtMerge.Columns.Contains(drMain["MonthName"].ToString()))
                            {

                                dtMerge.Columns.Add(drMain["MonthName"].ToString(), typeof(double));
                                dtMerge.Columns[drMain["MonthName"].ToString()].DefaultValue = Util.GetDouble(0);

                            }
                            DataRow[] DRtemp = dtMerge.Select("ClientCode='" + drMain["ClientCode"].ToString() + "' and  Department='" + drMain["Department"].ToString() + "'", "Priority");
                            if (DRtemp.Length == 0)
                            {
                                DataRow NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["Type"] = "NetAmount";
                                NewMerge[drMain["MonthName"].ToString()] = drMain["Net"].ToString();
                                NewMerge["Priority"] = "0";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["Type"] = "PatientCount";
                                NewMerge[drMain["MonthName"].ToString()] = drMain["PatientCount"].ToString();
                                NewMerge["Priority"] = "1";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["Type"] = "SampleCount";
                                NewMerge[drMain["MonthName"].ToString()] = drMain["SampleCount"].ToString();
                                NewMerge["Priority"] = "2";
                                dtMerge.Rows.Add(NewMerge);


                            }
                            else
                            {

                                DRtemp[0][drMain["MonthName"].ToString()] = drMain["Net"].ToString();
                                DRtemp[1][drMain["MonthName"].ToString()] = drMain["PatientCount"].ToString();
                                DRtemp[2][drMain["MonthName"].ToString()] = drMain["SampleCount"].ToString();
                            }

                        }
                        if (reportype == "MonthWiseTrend" && reportoption == "TestWise" && isclientwisegrouping == 0)
                        {

                            if (!dtMerge.Columns.Contains(drMain["MonthName"].ToString()))
                            {


                                dtMerge.Columns.Add(drMain["MonthName"].ToString(), typeof(double));
                                dtMerge.Columns[drMain["MonthName"].ToString()].DefaultValue = Util.GetDouble(0);
                            }
                            DataRow[] DRtemp = dtMerge.Select("ItemName='" + drMain["ItemName"].ToString() + "'", "Priority");
                            if (DRtemp.Length == 0)
                            {
                                DataRow NewMerge = dtMerge.NewRow();
                                // NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                // NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                // NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                // NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["ItemName"] = drMain["ItemName"].ToString();
                                NewMerge["BillingCategory"] = drMain["BillingCategory"].ToString();

                                NewMerge["Type"] = "NetAmount";
                                NewMerge[drMain["MonthName"].ToString()] = drMain["Net"].ToString();
                                NewMerge["Priority"] = "0";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                //NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                //NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                //NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                //NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["ItemName"] = drMain["ItemName"].ToString();
                                NewMerge["BillingCategory"] = drMain["BillingCategory"].ToString();

                                NewMerge["Type"] = "PatientCount";
                                NewMerge[drMain["MonthName"].ToString()] = drMain["PatientCount"].ToString();
                                NewMerge["Priority"] = "1";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                //NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                //NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                //NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                //NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["ItemName"] = drMain["ItemName"].ToString();
                                NewMerge["BillingCategory"] = drMain["BillingCategory"].ToString();

                                NewMerge["Type"] = "SampleCount";
                                NewMerge[drMain["MonthName"].ToString()] = drMain["SampleCount"].ToString();
                                NewMerge["Priority"] = "2";
                                dtMerge.Rows.Add(NewMerge);


                            }
                            else
                            {

                                DRtemp[0][drMain["MonthName"].ToString()] = drMain["Net"].ToString();
                                DRtemp[1][drMain["MonthName"].ToString()] = drMain["PatientCount"].ToString();
                                DRtemp[2][drMain["MonthName"].ToString()] = drMain["SampleCount"].ToString();
                            }

                        }
                        if (reportype == "MonthWiseTrend" && reportoption == "TestWise" && isclientwisegrouping == 1)
                        {

                            if (!dtMerge.Columns.Contains(drMain["MonthName"].ToString()))
                            {

                                dtMerge.Columns.Add(drMain["MonthName"].ToString(), typeof(double));
                                dtMerge.Columns[drMain["MonthName"].ToString()].DefaultValue = Util.GetDouble(0);
                            }
                            DataRow[] DRtemp = dtMerge.Select("ClientCode='" + drMain["ClientCode"].ToString() + "' and ItemName='" + drMain["ItemName"].ToString() + "'", "Priority");
                            if (DRtemp.Length == 0)
                            {
                                DataRow NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["ItemName"] = drMain["ItemName"].ToString();
                                NewMerge["BillingCategory"] = drMain["BillingCategory"].ToString();

                                NewMerge["Type"] = "NetAmount";
                                NewMerge[drMain["MonthName"].ToString()] = drMain["Net"].ToString();
                                NewMerge["Priority"] = "0";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["ItemName"] = drMain["ItemName"].ToString();
                                NewMerge["BillingCategory"] = drMain["BillingCategory"].ToString();

                                NewMerge["Type"] = "PatientCount";
                                NewMerge[drMain["MonthName"].ToString()] = drMain["PatientCount"].ToString();
                                NewMerge["Priority"] = "1";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["ItemName"] = drMain["ItemName"].ToString();
                                NewMerge["BillingCategory"] = drMain["BillingCategory"].ToString();

                                NewMerge["Type"] = "SampleCount";
                                NewMerge[drMain["MonthName"].ToString()] = drMain["SampleCount"].ToString();
                                NewMerge["Priority"] = "2";
                                dtMerge.Rows.Add(NewMerge);


                            }
                            else
                            {

                                DRtemp[0][drMain["MonthName"].ToString()] = drMain["Net"].ToString();
                                DRtemp[1][drMain["MonthName"].ToString()] = drMain["PatientCount"].ToString();
                                DRtemp[2][drMain["MonthName"].ToString()] = drMain["SampleCount"].ToString();
                            }

                        }

                        else if (reportype == "DateWiseTrend" && reportoption == "DepartmentWise" && isclientwisegrouping == 0)
                        {

                            if (!dtMerge.Columns.Contains(drMain["Date"].ToString()))
                            {

                                dtMerge.Columns.Add(drMain["Date"].ToString(), typeof(double));
                                dtMerge.Columns[drMain["Date"].ToString()].DefaultValue = Util.GetDouble(0);
                            }
                            DataRow[] DRtemp = dtMerge.Select("Department='" + drMain["Department"].ToString() + "'", "Priority");
                            if (DRtemp.Length == 0)
                            {
                                DataRow NewMerge = dtMerge.NewRow();
                                //NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                //NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                //NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                //NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["Type"] = "NetAmount";
                                NewMerge[drMain["Date"].ToString()] = drMain["Net"].ToString();
                                NewMerge["Priority"] = "0";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                //NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                //NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                //NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                //NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["Type"] = "PatientCount";
                                NewMerge[drMain["Date"].ToString()] = drMain["PatientCount"].ToString();
                                NewMerge["Priority"] = "1";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                //NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                //NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                //NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                //NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["Type"] = "SampleCount";
                                NewMerge[drMain["Date"].ToString()] = drMain["SampleCount"].ToString();
                                NewMerge["Priority"] = "2";
                                dtMerge.Rows.Add(NewMerge);


                            }
                            else
                            {

                                DRtemp[0][drMain["Date"].ToString()] = drMain["Net"].ToString();
                                DRtemp[1][drMain["Date"].ToString()] = drMain["PatientCount"].ToString();
                                DRtemp[2][drMain["Date"].ToString()] = drMain["SampleCount"].ToString();
                            }

                        }

                        else if (reportype == "DateWiseTrend" && reportoption == "DepartmentWise" && isclientwisegrouping == 1)
                        {

                            if (!dtMerge.Columns.Contains(drMain["Date"].ToString()))
                            {

                                dtMerge.Columns.Add(drMain["Date"].ToString(), typeof(double));
                                dtMerge.Columns[drMain["Date"].ToString()].DefaultValue = Util.GetDouble(0);
                            }
                            DataRow[] DRtemp = dtMerge.Select("ClientCode='" + drMain["ClientCode"].ToString() + "' and Department='" + drMain["Department"].ToString() + "'", "Priority");
                            if (DRtemp.Length == 0)
                            {
                                DataRow NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["Type"] = "NetAmount";
                                NewMerge[drMain["Date"].ToString()] = drMain["Net"].ToString();
                                NewMerge["Priority"] = "0";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["Type"] = "PatientCount";
                                NewMerge[drMain["Date"].ToString()] = drMain["PatientCount"].ToString();
                                NewMerge["Priority"] = "1";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["Type"] = "SampleCount";
                                NewMerge[drMain["Date"].ToString()] = drMain["SampleCount"].ToString();
                                NewMerge["Priority"] = "2";
                                dtMerge.Rows.Add(NewMerge);


                            }
                            else
                            {

                                DRtemp[0][drMain["Date"].ToString()] = drMain["Net"].ToString();
                                DRtemp[1][drMain["Date"].ToString()] = drMain["PatientCount"].ToString();
                                DRtemp[2][drMain["Date"].ToString()] = drMain["SampleCount"].ToString();
                            }

                        }
                        else if (reportype == "DateWiseTrend" && reportoption == "TestWise" && isclientwisegrouping == 0)
                        {

                            if (!dtMerge.Columns.Contains(drMain["Date"].ToString()))
                            {


                                dtMerge.Columns.Add(drMain["Date"].ToString(), typeof(double));
                                dtMerge.Columns[drMain["Date"].ToString()].DefaultValue = Util.GetDouble(0);

                            }
                            DataRow[] DRtemp = dtMerge.Select(" ItemName='" + drMain["ItemName"].ToString() + "'", "Priority");
                            if (DRtemp.Length == 0)
                            {
                                DataRow NewMerge = dtMerge.NewRow();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["ItemName"] = drMain["ItemName"].ToString();
                                NewMerge["BillingCategory"] = drMain["BillingCategory"].ToString();

                                NewMerge["Type"] = "NetAmount";
                                NewMerge[drMain["Date"].ToString()] = drMain["Net"].ToString();
                                NewMerge["Priority"] = "0";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["ItemName"] = drMain["ItemName"].ToString();
                                NewMerge["BillingCategory"] = drMain["BillingCategory"].ToString();
                                NewMerge["Type"] = "PatientCount";
                                NewMerge[drMain["Date"].ToString()] = drMain["PatientCount"].ToString();
                                NewMerge["Priority"] = "1";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["ItemName"] = drMain["ItemName"].ToString();
                                NewMerge["BillingCategory"] = drMain["BillingCategory"].ToString();
                                NewMerge["Type"] = "SampleCount";
                                NewMerge[drMain["Date"].ToString()] = drMain["SampleCount"].ToString();
                                NewMerge["Priority"] = "2";
                                dtMerge.Rows.Add(NewMerge);


                            }
                            else
                            {

                                DRtemp[0][drMain["Date"].ToString()] = drMain["Net"].ToString();
                                DRtemp[1][drMain["Date"].ToString()] = drMain["PatientCount"].ToString();
                                DRtemp[2][drMain["Date"].ToString()] = drMain["SampleCount"].ToString();
                            }

                        }
                        else if (reportype == "DateWiseTrend" && reportoption == "TestWise" && isclientwisegrouping == 1)
                        {

                            if (!dtMerge.Columns.Contains(drMain["Date"].ToString()))
                            {


                                dtMerge.Columns.Add(drMain["Date"].ToString(), typeof(double));
                                dtMerge.Columns[drMain["Date"].ToString()].DefaultValue = Util.GetDouble(0);
                            }
                            DataRow[] DRtemp = dtMerge.Select("ClientCode='" + drMain["ClientCode"].ToString() + "' and ItemName='" + drMain["ItemName"].ToString() + "'", "Priority");
                            if (DRtemp.Length == 0)
                            {
                                DataRow NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["ItemName"] = drMain["ItemName"].ToString();
                                NewMerge["BillingCategory"] = drMain["BillingCategory"].ToString();
                                NewMerge["Type"] = "NetAmount";
                                NewMerge[drMain["Date"].ToString()] = drMain["Net"].ToString();
                                NewMerge["Priority"] = "0";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["ItemName"] = drMain["ItemName"].ToString();
                                NewMerge["BillingCategory"] = drMain["BillingCategory"].ToString();
                                NewMerge["Type"] = "PatientCount";
                                NewMerge[drMain["Date"].ToString()] = drMain["PatientCount"].ToString();
                                NewMerge["Priority"] = "1";
                                dtMerge.Rows.Add(NewMerge);

                                NewMerge = dtMerge.NewRow();
                                NewMerge["ClientCode"] = drMain["ClientCode"].ToString();
                                NewMerge["ClientName"] = drMain["ClientName"].ToString();
                                NewMerge["ClientType"] = drMain["ClientType"].ToString();
                                NewMerge["TabBusinessCode"] = drMain["TabBusinessCode"].ToString();
                                NewMerge["TagBusinessUnit"] = drMain["TagBusinessUnit"].ToString();
                                NewMerge["Department"] = drMain["Department"].ToString();
                                NewMerge["ItemName"] = drMain["ItemName"].ToString();
                                NewMerge["BillingCategory"] = drMain["BillingCategory"].ToString();
                                NewMerge["Type"] = "SampleCount";
                                NewMerge[drMain["Date"].ToString()] = drMain["SampleCount"].ToString();
                                NewMerge["Priority"] = "2";
                                dtMerge.Rows.Add(NewMerge);

                            }
                            else
                            {

                                DRtemp[0][drMain["Date"].ToString()] = drMain["Net"].ToString();
                                DRtemp[1][drMain["Date"].ToString()] = drMain["PatientCount"].ToString();
                                DRtemp[2][drMain["Date"].ToString()] = drMain["SampleCount"].ToString();
                            }

                        }
                    }
                    DataRow newrow = dtMerge.NewRow();
                }
                else
                    dtMerge = dt;


                if (dtMerge.Columns.Contains("Priority"))
                {
                    dtMerge.Columns.Remove("Priority");

                }

                if (dtMerge.Columns.Contains("Panel_ID"))
                {
                    dtMerge.Columns.Remove("Panel_ID");

                }
                if (dtMerge.Columns.Contains("ItemID"))
                {
                    dtMerge.Columns.Remove("ItemID");

                }
                if (PdfOrexcel == "1")
                {
                    HttpContext.Current.Session["BusinessCumulativeReport"] = dtMerge;
                    HttpContext.Current.Session["ReportName"] = reportype + "&" + reportoption;
                    HttpContext.Current.Session["Period"] = "From : " + fromdate.ToString("dd-MMM-yyyy") + " To : " + todate.ToString("dd-MMM-yyyy");
                }
                else
                {
                    decimal amount1 = 0;
                    decimal amount2 = 0;
                    decimal amount3 = 0;
                    decimal amount4 = 0;
                    decimal amount5 = 0;
                    decimal amount6 = 0;
                    decimal amount7 = 0;
                    decimal amount8 = 0;
                    decimal amount9 = 0;
                    decimal amount10 = 0;
                    decimal amount11 = 0;
                    decimal amount12 = 0;
                    decimal amount13 = 0;
                    decimal amount14 = 0;
                    decimal amount15 = 0;

                    if (dt.Rows.Count != 0)
                    {



                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            amount1 += Convert.ToDecimal(dt.Rows[i]["GrossSales"].ToString());
                            amount2 += Convert.ToDecimal(dt.Rows[i]["Disc"].ToString());
                            amount3 += Convert.ToDecimal(dt.Rows[i]["NetSales"].ToString());
                            amount4 += Convert.ToDecimal(dt.Rows[i]["Pt_Count"].ToString());
                            amount5 += Convert.ToDecimal(dt.Rows[i]["SampleCount"].ToString());
                            amount6 += Convert.ToDecimal(dt.Rows[i]["CashSameDate"].ToString());
                            amount7 += Convert.ToDecimal(dt.Rows[i]["BankSameDate"].ToString());
                            amount8 += Convert.ToDecimal(dt.Rows[i]["CollectionSameDay"].ToString());
                            amount9 += Convert.ToDecimal(dt.Rows[i]["Cash_OS_Same_Day"].ToString());
                            amount10 += Convert.ToDecimal(dt.Rows[i]["Cr_SalesSameDay"].ToString());
                            amount11 += Convert.ToDecimal(dt.Rows[i]["CashPrev_Day"].ToString());
                            amount12 += Convert.ToDecimal(dt.Rows[i]["BankPrev_Day"].ToString());
                            amount13 += Convert.ToDecimal(dt.Rows[i]["TotalReceivedAmount"].ToString());
                            amount14 += Convert.ToDecimal(dt.Rows[i]["TotalCashAmount"].ToString());
                            amount15 += Convert.ToDecimal(dt.Rows[i]["TotalBankAmount"].ToString());
                        }

                        DataRow dtr = dt.NewRow();
                        dtr[0] = "Total";
                        dtr[4] = amount1.ToString();
                        dtr[5] = amount2.ToString();
                        dtr[6] = amount3.ToString();
                        dtr[7] = amount4.ToString();
                        dtr[8] = amount5.ToString();
                        dtr[9] = amount6.ToString();
                        dtr[10] = amount7.ToString();
                        dtr[11] = amount8.ToString();
                        dtr[12] = amount9.ToString();
                        dtr[13] = amount10.ToString();
                        dtr[14] = amount11.ToString();
                        dtr[15] = amount12.ToString();
                        dt.Rows.Add(dtr);



                        HttpContext.Current.Session["dtExport2Excel"] = dtMerge;
                        HttpContext.Current.Session["ReportName"] = reportype + " & " + reportoption + " Report ";
                        HttpContext.Current.Session["Period"] = "From : " + fromdate.ToString("dd-MMM-yyyy") + " To : " + todate.ToString("dd-MMM-yyyy");

                        return "1";

                    }
                    else
                    {
                        return "0";
                    }




                  //  HttpContext.Current.Session["dtExport2Excel"] = dtMerge;
                   // HttpContext.Current.Session["ReportName"] = reportype + " & " + reportoption + " Report ";
                   // HttpContext.Current.Session["Period"] = "From : " + fromdate.ToString("dd-MMM-yyyy") + " To : " + todate.ToString("dd-MMM-yyyy");
                }
                return "1";
            }
            else
                return "0";
        }
        catch (Exception ex)
        {
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


}
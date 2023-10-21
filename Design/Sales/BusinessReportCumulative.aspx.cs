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
        sb.Append(" WHERE cm.centreid<>1 ORDER by cm.centre ");
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
        // sb.Append(" WHERE pm.isactive=1 AND pm.`PanelType` <> 'Centre' ");
        sb.Append(" WHERE  pm.`PanelType` <> 'Centre' ");
        if (type != "")
            sb.Append(" AND pm.panelType IN (" + type + ") ");
        if (Businessunit != "")
            sb.Append(" AND pm.`TagBusinessLabID`  IN (" + Businessunit + ")   ");
        sb.Append(" UNION ALL  ");

        sb.Append(" SELECT pm.panel_ID,CONCAT(IFNULL(cm.`CentreCode`,''),' ',cm.`Centre`)PanelName  ");
        sb.Append(" FROM f_panel_master pm  ");
        sb.Append(" INNER JOIN `centre_master` cm ON cm.CentreID=pm.`CentreID`  ");
        sb.Append(" WHERE pm.`PanelType`='Centre' ");
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
        dr["ID"] = "GOVT PANEL";
        dr["Type1"] = "GOVT PANEL";
        dt.Rows.Add(dr);

        dr = dt.NewRow();
        dr["ID"] = "CORPORATE";
        dr["Type1"] = "CORPORATE";
        dt.Rows.Add(dr);

        dr = dt.NewRow();
        dr["ID"] = "TPA";
        dr["Type1"] = "TPA";
        dt.Rows.Add(dr);

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
    public static string binddepartment()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT DISTINCT `DisplayName` FROM `f_subcategorymaster`  ORDER BY `DisplayName` "));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindtest(string deptid)
    {
        if (deptid == "")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ItemID,concat(testcode,'~',TypeName) TypeName FROM `f_itemmaster`  ORDER BY TypeName"));
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" SELECT ItemID,CONCAT(im.testcode,'~',im.TypeName) TypeName FROM `f_itemmaster` im INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID`=im.`SubCategoryID` WHERE  sc.`DisplayName` IN('" + deptid.Replace(",", "','") + "') ORDER BY im.TypeName "));
        }
    }

    [WebMethod]
    public static string GetReport(string reportype, int isdate, DateTime fromdate, DateTime todate, int iscurrentmonth, int istoday, string businessunit,
        string centretype, string client, string reportoption, string department, string test, int isclientwisegrouping)
    {
        StringBuilder sb = new StringBuilder();

        

        if (reportype == "Cumulative")
        {
            if (reportoption == "ClientWise")
            {
               sb = new StringBuilder();

                //sb.Append(" select aa.ClientCode,aa.ClientName,aa.TabBusinessCode,aa.TagBusinessUnit, ");
                //sb.Append("  aa.Rate, aa.Disc, aa.Net, aa.PatientCount, ");
                //sb.Append("  aa.SampleCount,  ");
                //sb.Append(" bb.TotalReceiveAmount,   ");
                //sb.Append(" bb.CashAmount,  ");
                //sb.Append(" bb.DebitCardAmount,  ");
                //sb.Append(" bb.CreditCardAmount,  ");
                //sb.Append(" bb.ChequeAmount,  ");
                //sb.Append(" bb.OnlineAmount,  ");
                //sb.Append(" (aa.Net-bb.TotalReceiveAmount-aa.CreditAmount)  CashOutStanding, ");
                //sb.Append(" aa.CreditAmount ");


                //sb.Append(" from ( ");
                //sb.Append("   SELECT  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                //sb.Append(" SUM(plo.`Rate`*plo.`Quantity`) Rate,SUM(plo.`DiscountAmt`)Disc,SUM(plo.`Amount`) Net,COUNT(DISTINCT lt.`LedgerTransactionID`) PatientCount, ");
                //sb.Append(" COUNT(DISTINCT plo.`SampleTypeID`,lt.`LedgerTransactionID`) SampleCount,lt.Panel_ID,plo.ItemID , sum(if(lt.IsCredit=1,plo.Amount,0))CreditAmount  ");
                //sb.Append(" FROM `f_ledgertransaction` lt  ");
                //sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");
                //sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`  ");
                //sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                //sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`  ");
                //sb.Append(" WHERE lt.`IsCancel`=0  ");
                //sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)  ");
                //if (client.Trim() != string.Empty)
                //    sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                //if (isdate == 1)
                //{
                //    sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                //    sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");
                //}
                //else if (iscurrentmonth == 1)
                //{
                //    var startOfMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                //    //  var endOfMonth = startOfMonth.AddMonths(1).AddDays(-1);

                //    sb.Append(" AND lt.`Date`>= '" + startOfMonth.ToString("yyyy-MM-dd") + " 00:00:00' ");
                //    // sb.Append(" AND lt.`Date`<= '" + Util.GetDateTime(endOfMonth).ToString("yyyy-MM-dd") + " 23:59:59'    ");
                //}
                //else
                //{

                //    sb.Append(" AND lt.`Date`>= '" + DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00' ");
                //    sb.Append(" AND lt.`Date`<= '" + DateTime.Now.ToString("yyyy-MM-dd") + " 23:59:59'    ");
                //}
                //sb.Append(" GROUP BY pm.`Panel_ID`  ");
                //sb.Append(" ) aa ");
                //sb.Append(" LEFT JOIN  ( ");

                //sb.Append(" SELECT lt.InvoiceToPanelID `Panel_ID`  ,SUM(Amount)TotalReceiveAmount,   ");
                //sb.Append(" SUM(IF(r.PaymentMode='Cash',Amount,0))CashAmount,  ");
                //sb.Append(" SUM(IF(r.PaymentMode='Debit Card',Amount,0))DebitCardAmount,  ");
                //sb.Append(" SUM(IF(r.PaymentMode='Credit Card',Amount,0))CreditCardAmount,  ");
                //sb.Append(" SUM(IF(r.PaymentMode='Cheque',Amount,0))ChequeAmount,  ");

                //sb.Append(" SUM(IF(r.PaymentMode!='Cash' AND r.PaymentMode !='Debit Card' AND r.PaymentMode!='Credit Card' AND r.PaymentMode!='Cheque',Amount,0))OnlineAmount  ");

                //sb.Append(" FROM `f_reciept` r  ");
                //sb.Append(" INNER JOIN `f_ledgertransaction` lt ON r.`LedgerTransactionID`=lt.`LedgerTransactionID`  ");
                //sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                //sb.Append(" WHERE lt.`IsCancel`=0 AND r.`IsCancel`=0  ");


                //if (client.Trim() != string.Empty)
                //    sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                //if (isdate == 1)
                //{
                //    sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                //    sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");
                //}
                //else if (iscurrentmonth == 1)
                //{
                //    var startOfMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                //    //  var endOfMonth = startOfMonth.AddMonths(1).AddDays(-1);

                //    sb.Append(" AND lt.`Date`>= '" + startOfMonth.ToString("yyyy-MM-dd") + " 00:00:00' ");
                //    // sb.Append(" AND lt.`Date`<= '" + Util.GetDateTime(endOfMonth).ToString("yyyy-MM-dd") + " 23:59:59'    ");
                //}
                //else
                //{

                //    sb.Append(" AND lt.`Date`>= '" + DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00' ");
                //    sb.Append(" AND lt.`Date`<= '" + DateTime.Now.ToString("yyyy-MM-dd") + " 23:59:59'    ");
                //}

                //sb.Append(" GROUP BY lt.`InvoiceToPanelID`  ");
                //sb.Append(" ) bb on aa.Panel_ID=bb.Panel_ID ");


                //sb.Append(" UNION ALL ");



                //sb.Append("   SELECT  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                //sb.Append(" SUM(IFNULL(plos.PCCInvoiceAmt,0)) Rate,0 Disc,SUM(IFNULL(plos.PCCInvoiceAmt,0)) Net,COUNT(DISTINCT lt.`LedgerTransactionID`) PatientCount, ");
                //sb.Append(" COUNT(DISTINCT plo.`SampleTypeID`,lt.`LedgerTransactionID`) SampleCount,");

                //                sb.Append(" 0 TotalReceiveAmount,   ");
                // sb.Append(" 0 CashAmount,   ");
                // sb.Append(" 0 DebitCardAmount,   ");
                // sb.Append(" 0 CreditCardAmount,   ");
                // sb.Append(" 0 ChequeAmount,   ");
                // sb.Append(" 0 OnlineAmount,   ");
                // sb.Append(" 0 CashOutStanding,  ");


                //sb.Append(" sum(IFNULL(plos.PCCInvoiceAmt,0))CreditAmount  ");
                //sb.Append(" FROM `f_ledgertransaction` lt  ");
                //sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");
                //sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`  ");
                //sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` = 'CC'  ");
                //sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`  ");
                //sb.Append(" LEFT JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = plo.LedgerTransactionID AND plos.ItemID=plo.ItemID    "); 
                //sb.Append(" WHERE lt.`IsCancel`=0  ");
                //sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)  ");
                //if (client.Trim() != string.Empty)
                //    sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                //if (isdate == 1)
                //{
                //    sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                //    sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");
                //}
                //else if (iscurrentmonth == 1)
                //{
                //    var startOfMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                //    //  var endOfMonth = startOfMonth.AddMonths(1).AddDays(-1);

                //    sb.Append(" AND lt.`Date`>= '" + startOfMonth.ToString("yyyy-MM-dd") + " 00:00:00' ");
                //    // sb.Append(" AND lt.`Date`<= '" + Util.GetDateTime(endOfMonth).ToString("yyyy-MM-dd") + " 23:59:59'    ");
                //}
                //else
                //{

                //    sb.Append(" AND lt.`Date`>= '" + DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00' ");
                //    sb.Append(" AND lt.`Date`<= '" + DateTime.Now.ToString("yyyy-MM-dd") + " 23:59:59'    ");
                //}
                //sb.Append(" GROUP BY pm.`Panel_ID`  ");

                //------Salek sir query Changes by Apurva : 22-09-2018
                sb.Append("    SELECT  ");
                sb.Append(" Panel_Code ClientCode, Company_Name ClientName, ClientType, BusinessUnit, SUM(GrossSales)GrossSales, ");
                sb.Append(" SUM(Disc)Disc, SUM(NetSales)NetSales, COUNT(DISTINCT `LedgerTransactionID`) Pt_Count, ");
                sb.Append(" COUNT(DISTINCT `SampleTypeID`,`LedgerTransactionID`) SampleCount, ");
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

                sb.Append(" SELECT pnl.Panel_ID, pnl.`Panel_Code`,pnl.`Company_Name`, pnl.CentreType1 ClientType,cm.`Centre` BusinessUnit,(plo.rate * plo.`Quantity`) GrossSales, ");
                sb.Append(" plo.`DiscountAmt` Disc,plo.`Amount` NetSales, lt.`LedgerTransactionID`, plo.`SampleTypeID`, ");
                sb.Append(" 0 CashSameDate,	 ");
                sb.Append(" 0 BankSameDate,	 ");
                sb.Append(" 0 CollectionSameDay, ");
                sb.Append(" IF(lt.`IsCredit`=1,plo.Amount,0) Cr_SalesSameDay, ");
                sb.Append(" 0 CashPrev_Day, ");
                sb.Append(" 0 BankPrev_Day, ");
                sb.Append(" 0 TotalReceivedAmount , ");
                sb.Append(" 0 TotalCashAmount, ");
                sb.Append(" 0 TotalBankAmount ");

                sb.Append(" FROM f_ledgertransaction lt  ");
                sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
                sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
                sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pnl.`TagBusinessLabID` ");
                sb.Append(" WHERE lt.`IsCancel`=0  ");
                sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)  ");
                if (client.Trim() != string.Empty)
                    sb.Append("  AND lt.InvoiceToPanelID IN (" + client + ") ");
                sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59' ");

                sb.Append(" UNION ALL  ");
                //-- Business of CC
                sb.Append(" SELECT pnl.Panel_ID, pnl.`Panel_Code`,pnl.`Company_Name`, pnl.CentreType1 ClientType,cm.`Centre` BusinessUnit,IFNULL(plos.PCCInvoiceAmt,0) GrossSales, ");
                sb.Append(" 0 Disc,IFNULL(plos.PCCInvoiceAmt,0) NetSales, lt.`LedgerTransactionID`, plo.`SampleTypeID`, ");
                sb.Append(" 0 CashSameDate,	 ");
                sb.Append(" 0 BankSameDate,	 ");
                sb.Append(" 0 CollectionSameDay, ");
                sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Cr_SalesSameDay, ");
                sb.Append(" 0 CashPrev_Day, ");
                sb.Append(" 0 BankPrev_Day, ");
                sb.Append(" 0 TotalReceivedAmount , ");
                sb.Append(" 0 TotalCashAmount, ");
                sb.Append(" 0 TotalBankAmount ");

                sb.Append(" FROM f_ledgertransaction lt  ");
                sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
                sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
                sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` = 'CC'  ");
                sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pnl.`TagBusinessLabID` ");
                sb.Append(" LEFT JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = plo.LedgerTransactionID AND plos.ItemID=plo.ItemID  ");
                sb.Append(" WHERE lt.`IsCancel`=0  ");
                sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)  ");
                if (client.Trim() != string.Empty)
                    sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59' ");


                sb.Append(" UNION ALL  ");

                //-- Collection from f_receipt 

                sb.Append(" SELECT pnl.Panel_ID, pnl.`Panel_Code`,pnl.`Company_Name`, pnl.CentreType1 ClientType,cm.`Centre` BusinessUnit,0 GrossSales, ");
                sb.Append(" 0 Disc,0 NetSales, NULL `LedgerTransactionID`, NULL `SampleTypeID`, ");
                sb.Append(" IF(r.`PaymentModeID`=1 AND lt.`Date` >= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' AND lt.`Date` <= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59' ,r.`Amount`,0) CashSameDate,	 ");
                sb.Append(" IF(r.`PaymentModeID`!=1 AND lt.`Date` >= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' AND lt.`Date` <= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59' ,r.`Amount`,0) BankSameDate,	 ");
                sb.Append(" IF( lt.`Date` >= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' AND lt.`Date` <= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59' ,r.`Amount`,0) CollectionSameDay, ");
                sb.Append(" 0 Cr_SalesSameDay, ");
                sb.Append(" IF(r.`PaymentModeID`=1 AND lt.`Date` < '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ,r.`Amount`,0) CashPrev_Day, "); //Both dates are same
                sb.Append(" IF(r.`PaymentModeID`!=1 AND lt.`Date` < '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ,r.`Amount`,0) BankPrev_Day, "); // Both Dates same : 2018-09-01 00:00:00
                sb.Append(" r.`Amount` TotalReceivedAmount ,	 ");
                sb.Append(" IF(r.`PaymentModeID`=1 ,r.`Amount`,0) TotalCashAmount, ");
                sb.Append(" IF(r.`PaymentModeID`!=1 ,r.`Amount`,0) TotalBankAmount ");

                sb.Append(" FROM f_ledgertransaction lt  ");
                sb.Append(" INNER JOIN `f_reciept` r ON r.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
                sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
                sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pnl.`TagBusinessLabID` ");
                sb.Append(" WHERE r.`IsCancel`=0  ");
                if (client.Trim() != string.Empty)
                    sb.Append("   AND lt.InvoiceToPanelID IN (" + client + ") ");
                sb.Append(" AND r.`EntryDateTime`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb.Append(" AND r.`EntryDateTime`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59' ");



                sb.Append(" UNION ALL  ");

                //-- Collection from `invoicemaster_onaccount` 

                sb.Append(" SELECT pnl.Panel_ID, pnl.`Panel_Code`,pnl.`Company_Name`, pnl.CentreType1 ClientType,cm.`Centre` BusinessUnit,0 GrossSales, ");
                sb.Append(" 0 Disc,0 NetSales, NULL `LedgerTransactionID`, NULL `SampleTypeID`, ");
                sb.Append(" 0 CashSameDate,	 ");
                sb.Append(" 0 BankSameDate,	 ");
                sb.Append(" 0 CollectionSameDay, ");
                sb.Append(" 0 Cr_SalesSameDay, ");
                sb.Append(" IF(io.`PaymentMode`='CASH' ,io.`ReceivedAmt`,0) CashPrev_Day, ");
                sb.Append(" IF(io.`PaymentMode`!='CASH' ,io.`ReceivedAmt`,0) BankPrev_Day, ");
                sb.Append(" io.`ReceivedAmt` TotalReceivedAmount ,	 ");
                sb.Append(" IF(io.`PaymentMode`='CASH' ,io.`ReceivedAmt`,0) TotalCashAmount, ");
                sb.Append(" IF(io.`PaymentMode`!='CASH' ,io.`ReceivedAmt`,0) TotalBankAmount ");

                sb.Append(" FROM `invoicemaster_onaccount` io  ");
                sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=io.`Panel_ID` ");
                sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pnl.`TagBusinessLabID` ");
                sb.Append(" WHERE io.`IsCancel`=0  ");
                sb.Append(" AND io.`CreditNote`=0 ");
                if (client.Trim() != string.Empty)
                    sb.Append("   AND pnl.`Panel_ID` IN (" + client + ") ");
               
                sb.Append(" AND io.`ReceivedDate` >= '" + fromdate.ToString("yyyy-MM-dd") + "' ");
                sb.Append(" AND io.`ReceivedDate` <= '" + todate.ToString("yyyy-MM-dd") + "' ");

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
                sb.Append(" SUM(Rate) Rate,SUM(Disc)Disc,SUM(Net) Net,COUNT(DISTINCT `LedgerTransactionID`) PatientCount, ");
                sb.Append(" COUNT(DISTINCT `SampleTypeID`,`LedgerTransactionID`) SampleCount,Panel_ID,ItemID from ( ");



                sb.Append(" SELECT ");
                if (isclientwisegrouping == 1)
                    sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                sb.Append(" sc.`DisplayName` Department, ");
                sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net,lt.`LedgerTransactionID`, ");
                sb.Append("  plo.`SampleTypeID`, lt.Panel_ID, plo.ItemID, sc.DisplayName ");
                sb.Append(" FROM `f_ledgertransaction` lt ");
                sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
 
                sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");               
                sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                
                if (isclientwisegrouping == 1)
                {
                    sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                    sb.Append("  LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`  ");
                }
                sb.Append(" WHERE lt.`IsCancel`=0 ");
                if (client.Trim() != string.Empty)
                    sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");
                if (department != "")
                    sb.Append(" and sc.DisplayName in ('" + department.Replace(",", "','") + "')");

                sb.Append(" UNION ALL ");


                sb.Append(" SELECT ");
                if (isclientwisegrouping == 1)
                    sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                sb.Append(" sc.`DisplayName` Department, ");
                sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net,lt.`LedgerTransactionID`, ");
                sb.Append("  plo.`SampleTypeID`, lt.Panel_ID, plo.ItemID, sc.DisplayName ");
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
                sb.Append(" WHERE lt.`IsCancel`=0 ");
                if (client.Trim() != string.Empty)
                    sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");
                if (department != "")
                    sb.Append(" and sc.DisplayName in ('" + department.Replace(",", "','") + "')");
                


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
                sb.Append(" SUM(Rate) Rate,SUM(Disc)Disc,SUM(Net) Net,COUNT(DISTINCT `LedgerTransactionID`) PatientCount, ");
                sb.Append(" COUNT(DISTINCT `SampleTypeID`,`LedgerTransactionID`) SampleCount,Panel_ID,ItemID from ( ");


                sb.Append(" SELECT ");
                if (isclientwisegrouping == 1)
                    sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net,lt.`LedgerTransactionID`, ");
                sb.Append(" plo.`SampleTypeID`,lt.Panel_ID,plo.ItemID ");
                sb.Append(" FROM `f_ledgertransaction` lt ");
                sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                if (isclientwisegrouping == 1)
                {
                    sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                    sb.Append("  LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`  ");
                }
                sb.Append(" WHERE lt.`IsCancel`=0 ");
                if (client.Trim() != string.Empty)
                    sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");
                if (department != "")
                    sb.Append(" and plo.`ItemId` in ('" + test.Replace(",", "','") + "')");


                sb.Append(" UNION ALL ");
                sb.Append(" SELECT ");
                if (isclientwisegrouping == 1)
                    sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net,lt.`LedgerTransactionID`, ");
                sb.Append(" plo.`SampleTypeID`,lt.Panel_ID,plo.ItemID ");
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
                sb.Append(" WHERE lt.`IsCancel`=0 ");
                if (client.Trim() != string.Empty)
                    sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");
                if (department != "")
                    sb.Append(" and plo.`ItemId` in ('" + test.Replace(",", "','") + "')");




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
                    sb.Append(" SUM(Rate) Rate,SUM(Disc)Disc,SUM(Net) Net,COUNT(DISTINCT `LedgerTransactionID`) PatientCount,  ");
                    sb.Append("  COUNT(DISTINCT `SampleTypeID`, `LedgerTransactionID`) SampleCount , Panel_ID, ItemID  from ( ");


                    sb.Append("  SELECT lt.`Date`, pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net, lt.`LedgerTransactionID`,  ");
                    sb.Append("  plo.`SampleTypeID` ,lt.Panel_ID,plo.ItemID  ");
                    sb.Append("  FROM `f_ledgertransaction` lt   ");
                    sb.Append("  INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                    sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                    sb.Append("  INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                    sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                    sb.Append(" WHERE lt.`IsCancel`=0   ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)   ");
                    sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");




                    sb.Append("  UNION ALL  ");

                    sb.Append("  SELECT lt.`Date`, pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net, lt.`LedgerTransactionID`,  ");
                    sb.Append("  plo.`SampleTypeID` ,lt.Panel_ID,plo.ItemID  ");
                    sb.Append("  FROM `f_ledgertransaction` lt   ");
                    sb.Append("  INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                    sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                    sb.Append("  INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` = 'CC'  ");
                    sb.Append(" LEFT JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = plo.LedgerTransactionID AND plos.ItemID=plo.ItemID    "); 
                    sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                    sb.Append(" WHERE lt.`IsCancel`=0   ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)   ");
                    sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");




                    sb.Append("  ) aa  ");
                    sb.Append("  GROUP BY `ClientCode`,MONTH(`Date`)  ");
                    sb.Append("  ORDER BY   MONTH(`Date`),`ClientName` ");
                }
                else if (reportoption == "DepartmentWise")
                {
                    sb = new StringBuilder();

                    sb.Append("  SELECT MONTHNAME(`Date`)`MonthName`, ");
                    if (isclientwisegrouping == 1)
                        sb.Append(" ClientCode,ClientName,ClientType,TabBusinessCode,TagBusinessUnit, ");
                    sb.Append(" Department, ");
                    sb.Append(" SUM(Rate) Rate,SUM(Disc)Disc,SUM(Net) Net,COUNT(DISTINCT `LedgerTransactionID`) PatientCount,  ");
                    sb.Append("  COUNT(DISTINCT `SampleTypeID`,`LedgerTransactionID`) SampleCount,Panel_ID,ItemID  from (  ");



                    sb.Append("  SELECT lt.`Date`, ");
                    if (isclientwisegrouping == 1)
                        sb.Append(" pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" sc.`DisplayName` Department, ");
                    sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net,lt.`LedgerTransactionID`,  ");
                    sb.Append("  plo.`SampleTypeID`,lt.Panel_ID,plo.ItemID   ");
                    sb.Append("  FROM `f_ledgertransaction` lt   ");
                    sb.Append("  INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                    sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                    sb.Append("  INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                    if (isclientwisegrouping == 1)
                    {
                        sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                        sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                    }
                    sb.Append(" WHERE lt.`IsCancel`=0   ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)   ");

                    sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");
                    if (department != "")
                        sb.Append(" and sc.DisplayName in ('" + department.Replace(",", "','") + "')");



                    sb.Append("  UNION ALL ");


                    sb.Append("  SELECT lt.`Date`, ");
                    if (isclientwisegrouping == 1)
                        sb.Append(" pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" sc.`DisplayName` Department, ");
                    sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net,lt.`LedgerTransactionID`,  ");
                    sb.Append("  plo.`SampleTypeID`,lt.Panel_ID,plo.ItemID   ");
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
                    sb.Append(" WHERE lt.`IsCancel`=0   ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)   ");

                    sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");
                    if (department != "")
                        sb.Append(" and sc.DisplayName in ('" + department.Replace(",", "','") + "')");




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
                    sb.Append(" SUM(Rate) Rate,SUM(Disc)Disc,SUM(Net) Net,COUNT(DISTINCT `LedgerTransactionID`) PatientCount,  ");
                    sb.Append("  COUNT(DISTINCT`SampleTypeID`,`LedgerTransactionID`) SampleCount ,Panel_ID , ItemID from (");


                    sb.Append("  SELECT lt.`Date`, ");
                    if (isclientwisegrouping == 1)
                        sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                    sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net,lt.`LedgerTransactionID`,  ");
                    sb.Append(" plo.`SampleTypeID` ,lt.Panel_ID ,plo.ItemID ");
                    sb.Append("  FROM `f_ledgertransaction` lt   ");
                    sb.Append("  INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                    sb.Append("  INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                    sb.Append("  INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                    if (isclientwisegrouping == 1)
                    {
                        sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                        sb.Append("  LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                    }
                    sb.Append(" WHERE lt.`IsCancel`=0   ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)   ");

                    sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");

                    if (department != "")
                        sb.Append(" and plo.`ItemId` in ('" + test.Replace(",", "','") + "')");


                    sb.Append("  UNION ALL ");

                    sb.Append("  SELECT lt.`Date`, ");
                    if (isclientwisegrouping == 1)
                        sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                    sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net,lt.`LedgerTransactionID`,  ");
                    sb.Append(" plo.`SampleTypeID` ,lt.Panel_ID ,plo.ItemID ");
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
                    sb.Append(" WHERE lt.`IsCancel`=0   ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)   ");

                    sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");

                    if (department != "")
                        sb.Append(" and plo.`ItemId` in ('" + test.Replace(",", "','") + "')");





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
                    sb.Append(" SUM(Rate) Rate,SUM(Disc)Disc,SUM(Net) Net,COUNT(DISTINCT `LedgerTransactionID`) PatientCount, ");
                    sb.Append(" COUNT(DISTINCT `SampleTypeID`,`LedgerTransactionID`) SampleCount,Panel_ID,ItemID from ( ");


                    sb.Append(" SELECT lt.`Date`, pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                    sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net, lt.`LedgerTransactionID`, ");
                    sb.Append(" plo.`SampleTypeID`,lt.Panel_ID,plo.ItemID ");
                    sb.Append("  FROM `f_ledgertransaction` lt ");
                    sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                    sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                    sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                    sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                    sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");

                    sb.Append(" WHERE lt.`IsCancel`=0 ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");

                    sb.Append(" UNION ALL  ");

                    sb.Append(" SELECT lt.`Date`, pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                    sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net, lt.`LedgerTransactionID`, ");
                    sb.Append(" plo.`SampleTypeID`,lt.Panel_ID,plo.ItemID ");
                    sb.Append("  FROM `f_ledgertransaction` lt ");
                    sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                    sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                    sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                    sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` = 'CC'  ");
                    sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                    sb.Append(" LEFT JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = plo.LedgerTransactionID AND plos.ItemID=plo.ItemID    ");
                    sb.Append(" WHERE lt.`IsCancel`=0 ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");





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
                    sb.Append(" SUM(Rate) Rate,SUM(Disc)Disc,SUM(Net) Net,COUNT(DISTINCT `LedgerTransactionID`) PatientCount, ");
                    sb.Append(" COUNT(DISTINCT `SampleTypeID`,`LedgerTransactionID`) SampleCount, Panel_ID , ItemID from ( ");



                    sb.Append(" SELECT lt.`Date`, ");
                    if (isclientwisegrouping == 1)
                        sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" sc.`DisplayName` Department, ");
                    sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net,lt.`LedgerTransactionID`, ");
                    sb.Append(" plo.`SampleTypeID`,lt.Panel_ID ,plo.ItemID ");
                    sb.Append("  FROM `f_ledgertransaction` lt ");
                    sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                    sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                    sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                    if (isclientwisegrouping == 1)
                    {
                        sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                        sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                    }
                    sb.Append(" WHERE lt.`IsCancel`=0 ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");

                    sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");
                    if (department != "")
                        sb.Append(" and sc.DisplayName in ('" + department.Replace(",", "','") + "')");

                    sb.Append(" UNION ALL ");

                    sb.Append(" SELECT lt.`Date`, ");
                    if (isclientwisegrouping == 1)
                        sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" sc.`DisplayName` Department, ");
                    sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net,lt.`LedgerTransactionID`, ");
                    sb.Append(" plo.`SampleTypeID`,lt.Panel_ID ,plo.ItemID ");
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
                    sb.Append(" WHERE lt.`IsCancel`=0 ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");

                    sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");
                    if (department != "")
                        sb.Append(" and sc.DisplayName in ('" + department.Replace(",", "','") + "')");






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
                    sb.Append(" SUM(Rate) Rate,SUM(Disc)Disc,SUM(Net) Net,COUNT(DISTINCT `LedgerTransactionID`) PatientCount, ");
                    sb.Append(" COUNT(DISTINCT `SampleTypeID`,`LedgerTransactionID`) SampleCount,Panel_ID,ItemID from ( ");
             


                    sb.Append(" SELECT lt.`Date`, ");
                    if (isclientwisegrouping == 1)
                        sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                    sb.Append(" (plo.`Rate`*plo.`Quantity`) Rate,(plo.`DiscountAmt`)Disc,(plo.`Amount`) Net,lt.`LedgerTransactionID`, ");
                    sb.Append(" plo.`SampleTypeID`, lt.Panel_ID , plo.ItemID ");
                    sb.Append("  FROM `f_ledgertransaction` lt ");
                    sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                    sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
                    sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
                    if (isclientwisegrouping == 1)
                    {
                        sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`InvoiceToPanelID`   ");
                        sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=pm.`TagBusinessLabID`   ");
                    }
                    sb.Append(" WHERE lt.`IsCancel`=0 ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");

                    sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");
                    
                    if (department != "")
                        sb.Append(" and plo.`ItemId` in ('" + test.Replace(",", "','") + "')");

                    sb.Append(" UNION ALL ");

                    sb.Append(" SELECT lt.`Date`, ");
                    if (isclientwisegrouping == 1)
                        sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName, pm.CentreType1 ClientType,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit, ");
                    sb.Append(" sc.`DisplayName` Department,plo.`ItemName`, ");
                    sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) Rate,0 Disc,IFNULL(plos.PCCInvoiceAmt,0) Net,lt.`LedgerTransactionID`, ");
                    sb.Append(" plo.`SampleTypeID`, lt.Panel_ID , plo.ItemID ");
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
                    sb.Append(" WHERE lt.`IsCancel`=0 ");
                    if (client.Trim() != string.Empty)
                        sb.Append(" AND lt.InvoiceToPanelID IN (" + client + ") ");
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");

                    sb.Append(" AND lt.`Date`>= '" + fromdate.ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append(" AND lt.`Date`<= '" + todate.ToString("yyyy-MM-dd") + " 23:59:59'    ");

                    if (department != "")
                        sb.Append(" and plo.`ItemId` in ('" + test.Replace(",", "','") + "')");




                    sb.Append(" ) aa ");

                    sb.Append(" GROUP BY  ");
                    sb.Append(" DAY(`Date`), Department, `ItemId` ");
                    if (isclientwisegrouping == 1)
                        sb.Append(" , ClientCode  ");

                }
            }
        }
        DataTable dtMerge = new DataTable();
        DataTable dt = StockReports.GetDataTable(sb.ToString());
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
                            dtMerge.Columns.Add(drMain["MonthName"].ToString(),typeof(double));
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
                            NewMerge["Type"] = "NetAmount";
                            NewMerge[drMain["Date"].ToString()] = drMain["Net"].ToString();
                            NewMerge["Priority"] = "0";
                            dtMerge.Rows.Add(NewMerge);

                            NewMerge = dtMerge.NewRow();
                            NewMerge["Department"] = drMain["Department"].ToString();
                            NewMerge["ItemName"] = drMain["ItemName"].ToString();
                            NewMerge["Type"] = "PatientCount";
                            NewMerge[drMain["Date"].ToString()] = drMain["PatientCount"].ToString();
                            NewMerge["Priority"] = "1";
                            dtMerge.Rows.Add(NewMerge);

                            NewMerge = dtMerge.NewRow();
                            NewMerge["Department"] = drMain["Department"].ToString();
                            NewMerge["ItemName"] = drMain["ItemName"].ToString();
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

          

            HttpContext.Current.Session["dtExport2Excel"] = dtMerge;
            HttpContext.Current.Session["ReportName"] = reportype+ " & " + reportoption + " Report ";
            HttpContext.Current.Session["Period"] = "From : " + fromdate.ToString("dd-MMM-yyyy") + " To : " + todate.ToString("dd-MMM-yyyy");
            return "1";
        }
        else
            return "0";
    }


}
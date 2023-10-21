using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_OPD_CollectionReportClientWise : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs;



    int MarginLeft = 20;
    int MarginRight = 20;
    int PageWidth = 550;
    int BrowserWidth = 800;


    float HeaderHeight = 80;//207
    int XHeader = 20;//20
    int YHeader = 60;//80
    int HeaderBrowserWidth = 800;


    //Footer Property 80
    float FooterHeight = 50;
    int XFooter = 20;
    string Period = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            document = new PdfDocument();
            tempDocument = new PdfDocument();
            document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
            try
            {
                DataTable dt = new DataTable();

                string fromDate = Request.Form["fromDate"].ToString();
                StringBuilder sb = new StringBuilder();

                if (Request.Form["ReportType"].ToString() == "0")
                {
                    sb.Append("  SELECT PanelName,Panel_ID,SUM(GrossAmount)GrossAmount,SUM(NetAmount)NetAmount,SUM(DiscountAmt)DiscountAmt,SUM(CashAmt)CashAmt,");
                    sb.Append(" sum(NetAmount-Amount-CreditSale+CreditSaleReceiveSameDay)Oustanding, ");
                    sb.Append(" SUM(CardAmt)CardAmt,SUM(ChequeAmt)ChequeAmt,SUM(Amount)ReceivedAmount,SUM(OnlineAmt)OnlineAmt,sum(DebitCardAmt) DebitCardAmt,sum(OPDAdvance)OPDAdvance, ");
                    sb.Append(" SUM(CreditSale)CreditSale,SUM(SameDaySettlement)SameDaySettlement,SUM(BackDaySettlement)BackDaySettlement,SUM(CreditSaleReceiveSameDay)CreditSaleReceiveSameDay, ");
                    sb.Append("  SUM(NetAmount-SameDaySettlement-CreditSale+CreditSaleReceiveSameDay) SamedayOutstanding,sum(AppAmt)AppAmt,sum(ClientAdvanceAmt)ClientAdvanceAmt ");
                    sb.Append(" FROM ( ");
                    sb.Append(" SELECT SUM(Rate*Quantity)GrossAmount,SUM(Amount)NetAmount,SUM(DiscountAmt)DiscountAmt,0 Amount,  ");
                    sb.Append("  '' PaymentMode,0 PaymentModeID,lt.`PanelName`,lt.`Panel_ID` ,  ");
                    sb.Append(" 0 CashAmt,0 CardAmt,0 ChequeAmt,0 OnlineAmt,0 DebitCardAmt,0 OnlinePayment,0 OPDAdvance,  ");
                    sb.Append(" SUM(IF(lt.`IsCredit`=1,(Rate*Quantity),0)) CreditSale ,0 SameDaySettlement,0 BackDaySettlement,0 CreditSaleReceiveSameDay,0 AppAmt,0 ClientAdvanceAmt ");
                    sb.Append(" FROM `patient_labinvestigation_opd` plo ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");

                    if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND lt.`Panel_ID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                    sb.Append(" AND plo.`CentreID` IN ({1}) ");

                    sb.Append(" AND plo.date >=@fromDate AND plo.date <= @toDate  AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append("  GROUP BY lt.`Panel_ID` ");
                    //cash collection
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT 0 GrossAmount,0 NetAmount,0 DiscountAmt,SUM(Amount)Amount, ");
                    sb.Append(" PaymentMode,PaymentModeID,lt.`PanelName`,lt.`Panel_ID` ,  ");
                    sb.Append(" SUM(IF(`PaymentModeID`=1,Amount,0))CashAmt,SUM(IF(`PaymentModeID`=3,Amount,0))CardAmt, ");
                    sb.Append("  SUM(IF(`PaymentModeID`=2,Amount,0))ChequeAmt,SUM(IF(`PaymentModeID`=10,Amount,0))OnlineAmt,SUM(IF(`PaymentModeID`=5,Amount,0))DebitCardAmt, ");
                    sb.Append(" SUM(IF(`PaymentModeID`=6,Amount,0))OnlinePayment,SUM(IF(`PaymentModeID`=9,Amount,0))OPDAdvance,0 CreditSale, ");
                    sb.Append(" SUM(IFNULL((IF( lt.Date >= @fromDate   AND lt.Date <=  @toDate  ,rc.Amount,0)),0)) SameDaySettlement, ");
                    sb.Append(" SUM(IFNULL((IF( lt.Date < @fromDate   ,rc.Amount,0)),0)) BackDaySettlement,  ");
                    sb.Append(" SUM(IFNULL((IF( lt.Date >= @fromDate   AND lt.Date <=  @toDate  AND lt.`IsCredit`=1,rc.Amount,0)),0)) CreditSaleReceiveSameDay,0 AppAmt,0 ClientAdvanceAmt ");
                    sb.Append(" FROM f_receipt rc ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=rc.`LedgerTransactionID` ");

                    sb.Append(" AND rc.Iscancel=0 and ifnull(rc.AppointmentID,'')=''  AND rc.`PayBy`<>'C' ");
                    if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND lt.`Panel_ID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                    sb.Append(" AND rc.`CentreID` IN ({1}) ");

                    sb.Append(" AND rc.`CreatedDate` >=@fromDate AND rc.`CreatedDate` <= @toDate ");
                    sb.Append("  GROUP BY lt.`Panel_ID` ");
                    //Appointment collection
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT 0 GrossAmount,0 NetAmount,0 DiscountAmt,0 Amount, ");
                    sb.Append(" PaymentMode,PaymentModeID,pnl.company_name `PanelName`,rc.`Panel_ID` ,  ");
                    sb.Append(" 0 CashAmt,0 CardAmt, ");
                    sb.Append(" 0 ChequeAmt,0 OnlineAmt,0 DebitCardAmt, ");
                    sb.Append(" 0 OnlinePayment,0 OPDAdvance,0 CreditSale, ");
                    sb.Append(" 0 SameDaySettlement, ");
                    sb.Append(" 0  BackDaySettlement,  ");
                    sb.Append(" 0 CreditSaleReceiveSameDay,SUM(Amount) AppAmt,0 ClientAdvanceAmt ");
                    sb.Append(" FROM f_receipt rc ");
                    sb.Append(" INNER JOIN f_panel_master pnl ON pnl.Panel_ID = rc.Panel_ID ");
                    sb.Append(" where rc.Iscancel=0 and ifnull(rc.AppointmentID,'')<>''  AND rc.`PayBy`<>'C' ");
                    if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND rc.`Panel_ID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND rc.`CentreID` IN ({1}) ");

                    sb.Append(" AND rc.`CreatedDate` >=@fromDate AND rc.`CreatedDate` <= @toDate ");
                    sb.Append("  GROUP BY rc.`Panel_ID` ");
                    //Client Advance Amt
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT 0 GrossAmount,0 NetAmount,0 DiscountAmt,0 Amount, ");
                    sb.Append(" PaymentMode,PaymentModeID,pnl.company_name  `PanelName`,rc.`Panel_ID` ,  ");
                    sb.Append(" 0 CashAmt,0 CardAmt, ");
                    sb.Append(" 0 ChequeAmt,0 OnlineAmt,0 DebitCardAmt, ");
                    sb.Append(" 0 OnlinePayment,0 OPDAdvance,0 CreditSale, ");
                    sb.Append(" 0 SameDaySettlement, ");
                    sb.Append(" 0  BackDaySettlement,  ");
                    sb.Append(" 0 CreditSaleReceiveSameDay,0 AppAmt, SUM(Amount) ClientAdvanceAmt ");
                    sb.Append(" FROM f_receipt rc ");
                    sb.Append(" INNER JOIN f_panel_master pnl ON pnl.Panel_ID = rc.Panel_ID ");
                    sb.Append(" where rc.Iscancel=0 and ifnull(rc.AppointmentID,'')=''  AND rc.`PayBy`='C' ");
                    if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND rc.`Panel_ID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND rc.`CentreID` IN ({1}) ");

                    sb.Append(" AND rc.`CreatedDate` >=@fromDate AND rc.`CreatedDate` <= @toDate ");
                    sb.Append("  GROUP BY rc.`Panel_ID` ");
                    sb.Append(" )a GROUP BY Panel_ID ");
                }
                else
                {
                    sb = new StringBuilder();
                    sb.Append("  SELECT PanelName,Panel_ID,SUM(GrossAmount)GrossAmount,SUM(NetAmount)NetAmount,SUM(DiscountAmt)DiscountAmt,SUM(CashAmt)CashAmt,");
                    sb.Append(" sum(NetAmount-Amount-CreditSale+CreditSaleReceiveSameDay)Oustanding,LedgerTransactionNo,PName,GROUP_CONCAT(PaymentMode)PaymentMode,IF(SUM(DiscountAmt)>0,IFNULL(DiscountReason,''),'')DiscountReason,If(SUM(DiscountAmt)>0,IFNULL(DiscountApprovedByName,''),'')DiscountApprovedByName, ");
                    sb.Append(" SUM(CardAmt)CardAmt,SUM(ChequeAmt)ChequeAmt,SUM(Amount)ReceivedAmount,SUM(OnlineAmt)OnlineAmt,sum(DebitCardAmt) DebitCardAmt,sum(OPDAdvance)OPDAdvance, ");
                    sb.Append(" SUM(CreditSale)CreditSale,SUM(SameDaySettlement)SameDaySettlement,SUM(BackDaySettlement)BackDaySettlement,SUM(CreditSaleReceiveSameDay)CreditSaleReceiveSameDay, ");
                    sb.Append("  SUM(NetAmount-SameDaySettlement-CreditSale+CreditSaleReceiveSameDay) SamedayOutstanding,sum(AppAmt)AppAmt,sum(ClientAdvanceAmt)ClientAdvanceAmt ");
                    sb.Append(" FROM ( ");
                    sb.Append(" SELECT SUM(Rate*Quantity)GrossAmount,SUM(Amount)NetAmount,SUM(DiscountAmt)DiscountAmt,0 Amount,  ");
                    sb.Append("  0 PaymentModeID,lt.`PanelName`,lt.`Panel_ID` ,lt.`LedgerTransactionID`,lt.`LedgerTransactionNo`,lt.`PName`,'' PaymentMode,   ");
                    sb.Append(" (SELECT DiscountReason FROM f_ledgertransaction_DiscountReason WHERE `LedgertransactionID`=lt.`LedgerTransactionID` And IsActive=1 LIMIT 1)DiscountReason,lt.`DiscountApprovedByName`,  ");
                    sb.Append(" 0 CashAmt,0 CardAmt,0 ChequeAmt,0 OnlineAmt,0 DebitCardAmt,0 OnlinePayment,0 OPDAdvance,  ");
                    sb.Append(" SUM(IF(lt.`IsCredit`=1,(Rate*Quantity),0)) CreditSale ,0 SameDaySettlement,0 BackDaySettlement,0 CreditSaleReceiveSameDay,0 AppAmt,0 ClientAdvanceAmt ");
                    sb.Append(" FROM `patient_labinvestigation_opd` plo ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");                 

                    if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND lt.`Panel_ID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND plo.`CentreID` IN ({1}) ");

                    sb.Append(" AND plo.date >=@fromDate AND plo.date <= @toDate  AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append("  GROUP BY lt.`LedgerTransactionID`,lt.`Panel_ID` ");
                    //cash collection
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT 0 GrossAmount,0 NetAmount,0 DiscountAmt,SUM(Amount)Amount, ");
                    sb.Append(" PaymentModeID,lt.`PanelName`,lt.`Panel_ID` ,lt.`LedgerTransactionID`,lt.`LedgerTransactionNo`,lt.`PName`,GROUP_CONCAT(PaymentMode)PaymentMode,   ");
                    sb.Append(" (SELECT DiscountReason FROM f_ledgertransaction_DiscountReason WHERE `LedgertransactionID`=lt.`LedgerTransactionID` And IsActive=1 LIMIT 1)DiscountReason,lt.`DiscountApprovedByName`,  ");
                    sb.Append(" SUM(IF(`PaymentModeID`=1,Amount,0))CashAmt,SUM(IF(`PaymentModeID`=3,Amount,0))CardAmt, ");
                    sb.Append("  SUM(IF(`PaymentModeID`=2,Amount,0))ChequeAmt,SUM(IF(`PaymentModeID`=10,Amount,0))OnlineAmt,SUM(IF(`PaymentModeID`=5,Amount,0))DebitCardAmt, ");
                    sb.Append(" SUM(IF(`PaymentModeID`=6,Amount,0))OnlinePayment,SUM(IF(`PaymentModeID`=9,Amount,0)) OPDAdvance,0 CreditSale, ");
                    sb.Append(" SUM(IFNULL((IF( lt.Date >= @fromDate   AND lt.Date <=  @toDate  ,rc.Amount,0)),0)) SameDaySettlement, ");
                    sb.Append(" SUM(IFNULL((IF( lt.Date < @fromDate    ,rc.Amount,0)),0)) BackDaySettlement,  ");
                    sb.Append(" SUM(IFNULL((IF( lt.Date >= @fromDate   AND lt.Date <=  @toDate  AND lt.`IsCredit`=1,rc.Amount,0)),0)) CreditSaleReceiveSameDay,0 AppAmt,0 ClientAdvanceAmt ");
                    sb.Append(" FROM f_receipt rc ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=rc.`LedgerTransactionID`  AND rc.Iscancel=0 and ifnull(rc.AppointmentID,'')='' AND rc.`PayBy`<>'C' ");
                  
                    if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND lt.`Panel_ID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND rc.`CentreID` IN ({1}) ");

                    sb.Append(" AND rc.`CreatedDate` >=@fromDate AND rc.`CreatedDate` <= @toDate ");
                    sb.Append("  GROUP BY lt.`LedgerTransactionID`,lt.`Panel_ID`  ");
                    //Amt collection
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT 0 GrossAmount,0 NetAmount,0 DiscountAmt,0 Amount, ");
                    sb.Append(" PaymentModeID,fpm.company_name `PanelName`,rc.`Panel_ID`,rc.AppointmentID LedgerTransactionID,rc.`LedgerTransactionNo`,(select CONCAT(pm.`Title`,' ',pm.`PatientName`) from appointment_radiology_details pm where pm.`AppointmentID`=rc.`AppointmentID` limit 1) `PName`,GROUP_CONCAT(PaymentMode)PaymentMode,  ");
                    sb.Append(" '' DiscountReason,'' DiscountApprovedByName,  ");
                    sb.Append(" 0 CashAmt,0 CardAmt, ");
                    sb.Append("  0 ChequeAmt,0 OnlineAmt,0 DebitCardAmt, ");
                    sb.Append(" 0 OnlinePayment,0 OPDAdvance,0 CreditSale, ");
                    sb.Append(" 0 SameDaySettlement, ");
                    sb.Append(" 0 BackDaySettlement,  ");
                    sb.Append(" 0 CreditSaleReceiveSameDay,SUM(Amount)AppAmt,0 ClientAdvanceAmt ");
                    sb.Append(" FROM f_receipt rc  ");
                    sb.Append(" INNER JOIN f_panel_master fpm on fpm.Panel_ID= rc.`Panel_ID` AND rc.Iscancel=0 and ifnull(rc.AppointmentID,'')<>'' AND rc.`PayBy`<>'C' ");

                    if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND rc.`Panel_ID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND rc.`CentreID` IN ({1}) ");

                    sb.Append(" AND rc.`CreatedDate` >=@fromDate AND rc.`CreatedDate` <= @toDate ");
                    sb.Append("  GROUP BY rc.`AppointmentID`,rc.`Panel_ID`  ");
                    //Client advance collection
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT 0 GrossAmount,0 NetAmount,0 DiscountAmt,0 Amount, ");
                    sb.Append(" PaymentModeID,fpm.company_name `PanelName`,rc.`Panel_ID`,rc.AppointmentID LedgerTransactionID,rc.`LedgerTransactionNo`,(select CONCAT(pm.`Title`,' ',pm.`PatientName`) from appointment_radiology_details pm where pm.`AppointmentID`=rc.`AppointmentID` limit 1) `PName`,GROUP_CONCAT(PaymentMode)PaymentMode,  ");
                    sb.Append(" '' DiscountReason,'' DiscountApprovedByName,  ");
                    sb.Append(" 0 CashAmt,0 CardAmt, ");
                    sb.Append("  0 ChequeAmt,0 OnlineAmt,0 OPDAdvance,0 DebitCardAmt, ");
                    sb.Append(" 0 OnlinePayment,0 CreditSale, ");
                    sb.Append(" 0 SameDaySettlement, ");
                    sb.Append(" 0 BackDaySettlement,  ");
                    sb.Append(" 0 CreditSaleReceiveSameDay,0 AppAmt,SUM(Amount) ClientAdvanceAmt ");
                    sb.Append(" FROM f_receipt rc  ");
                    sb.Append(" INNER JOIN f_panel_master fpm on fpm.Panel_ID= rc.`Panel_ID` AND rc.Iscancel=0 and ifnull(rc.AppointmentID,'')='' AND rc.`PayBy`='C' ");

                    if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND rc.`Panel_ID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND rc.`CentreID` IN ({1}) ");

                    sb.Append(" AND rc.`CreatedDate` >=@fromDate AND rc.`CreatedDate` <= @toDate ");
                    sb.Append("  GROUP BY rc.`AppointmentID`,rc.`Panel_ID`  ");
                    sb.Append(" )a GROUP BY Panel_ID,LedgerTransactionID ");

                }

                List<string> UserDataList = new List<string>();
                UserDataList = Request.Form["ClientID"].ToString().Split(',').ToList<string>();

                List<string> CentreIDDataList = new List<string>();
                CentreIDDataList = Request.Form["CentreID"].Split(',').ToList<string>();
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", UserDataList), string.Join(",", CentreIDDataList)), con))
                    {
                        for (int i = 0; i < UserDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), UserDataList[i]);
                        }
                        for (int i = 0; i < CentreIDDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), CentreIDDataList[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@fromDate", Request.Form["fromDate"].ToString());
                        da.SelectCommand.Parameters.AddWithValue("@toDate", Request.Form["toDate"].ToString());
                        da.Fill(dt);

                        UserDataList.Clear();
                        CentreIDDataList.Clear();


                        if (dt != null && dt.Rows.Count > 0)
                        {
                             Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            if (Request.Form["ReportFormat"].ToString() == "1")
                            {                               
                                    sb = new StringBuilder();
                                    sb.Append(" <div style='width:1200px;'> ");
                                    sb.Append("<table style='width: 1200px;font-family:Arial;border-top:1px solid'>");
                                    if (Request.Form["ReportType"].ToString() == "0")
                                    {
                                        for (int i = 0; i < dt.Rows.Count; i++)
                                        {

                                            sb.Append("<tr> ");
                                            sb.AppendFormat(" <td style='width:12%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["PanelName"]));
                                            sb.AppendFormat(" <td style='width:7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["GrossAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["DiscountAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["NetAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["CashAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["CardAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["ChequeAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["DebitCardAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["OnlineAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["OPDAdvance"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["CreditSale"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["ReceivedAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["AppAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["ClientAdvanceAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["NetAmount"]) - Util.GetDecimal(dt.Rows[i]["ReceivedAmount"]) - Util.GetDecimal(dt.Rows[i]["CreditSale"]) + Util.GetDecimal(dt.Rows[i]["CreditSaleReceiveSameDay"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                            sb.Append(" </tr> ");
                                        }
                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td style='width: 12%;font-size: 14px;font-weight: bold '>Total:</td>");
                                        sb.AppendFormat(" <td style='width: 7%;font-size: 14px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:6%;font-size: 14px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:6%;font-size: 14px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:6%;font-size: 14px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("CashAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:6%;font-size: 14px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("CardAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:7%;font-size: 14px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("ChequeAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:7%;font-size: 14px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("DebitCardAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:7%;font-size: 14px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("OnlineAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:6%;font-size: 14px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("OPDAdvance"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:6%;font-size: 14px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("CreditSale"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:6%;font-size: 14px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("ReceivedAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:6%;font-size: 14px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("AppAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:6%;font-size: 14px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("ClientAdvanceAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:6%;font-size: 14px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("Oustanding"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                        sb.Append(" </tr> ");
                                    }
                                    else
                                    {
                                        List<getDetail> Panel_ID = new List<getDetail>();
                                        var distinctdoctor = (from DataRow drw in dt.Rows
                                                              select new { Panel_ID = drw["Panel_ID"] }).Distinct().ToList();
                                        for (int j = 0; j < distinctdoctor.Count; j++)
                                        {
                                            DataTable dtdoc = dt.AsEnumerable().Where(x => x.Field<int>("Panel_ID") == Util.GetInt(distinctdoctor[j].Panel_ID)).CopyToDataTable();
                                            sb.Append(" <tr> ");
                                            sb.Append(" <td colspan='2' style='font-size: 16px;padding-top: 10px;padding-bottom: 10px;'>Client : </td> ");
                                            sb.Append(" <td colspan='13' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;'>" + Util.GetString(dtdoc.Rows[0]["PanelName"].ToString()) + "</td> ");
                                            sb.Append(" </tr> ");

                                            for (int i = 0; i < dtdoc.Rows.Count; i++)
                                            {
                                                if (Util.GetDecimal(dtdoc.Rows[i]["Oustanding"]) < 0)
                                                    sb.Append("<tr style='background-color:#ffe6e6;'> ");
                                                else
                                                    sb.Append("<tr> ");
                                                sb.AppendFormat(" <td style='width:12%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["PName"]));
                                                sb.AppendFormat(" <td style='width:7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["GrossAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["DiscountAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["NetAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["CashAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["CardAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;width:50px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["ChequeAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;text-align:right;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["DebitCardAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;text-align:right;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["OnlineAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;text-align:right;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["OPDAdvance"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;text-align:right;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["CreditSale"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;text-align:right;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["ReceivedAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;text-align:right;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["AppAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;text-align:right;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["ClientAdvanceAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;text-align:right;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["Oustanding"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                                sb.Append(" </tr> ");
                                            }
                                            sb.Append("<tr> ");
                                            sb.AppendFormat(" <td style='width:12%;font-size: 14px;padding-top: 10px;font-weight: bold '>SubTotal:</td>");
                                            sb.AppendFormat(" <td style='width:7%;font-size: 14px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;font-size: 14px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;font-size: 14px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;font-size: 14px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("CashAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;font-size: 14px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("CardAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:7%;font-size: 14px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold;width:50px; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("ChequeAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:7%;font-size: 14px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold;text-align:right; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("DebitCardAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:7%;font-size: 14px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold;text-align:right; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("OnlineAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;font-size: 14px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold;text-align:right; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("OPDAdvance"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;font-size: 14px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold;text-align:right; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("CreditSale"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;font-size: 14px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold;text-align:right; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("ReceivedAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;font-size: 14px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold;text-align:right; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("AppAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;font-size: 14px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold;text-align:right; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("ClientAdvanceAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:6%;font-size: 14px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold ;text-align:right;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("Oustanding"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                            sb.Append(" </tr> ");
                                        }
                                    }
                                
                                sb.Append("</table>");
                                sb.Append("</div>");

                                AddContent(sb.ToString());
                                SetFooter(tempDocument.Pages[tempDocument.Pages.Count - 1]);
                                mergeDocument();
                                byte[] pdfBuffer = document.WriteToMemory();
                                HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
                                HttpContext.Current.Response.BinaryWrite(pdfBuffer);
                                HttpContext.Current.Response.End();
                            }
                            else
                            {
                                Session["dtExport2Excel"] = dt;
                                Session["ReportName"] = "Client Wise Collection Report";
                                Response.Redirect("../../common/ExportToExcel.aspx");
                            }
                        }
                        else
                        {
                            Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> No Record Found<span><br/></center>");
                            return;
                        }
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }
                finally
                {
                    con.Close();
                    con.Dispose();
                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
            finally
            {
                if (document != null)
                {
                    document.Close();
                }
                if (tempDocument != null)
                {
                    tempDocument.Close();
                }
            }
        }
    }
    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        PdfPage page1 = eventParams.PdfPage;

        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);
        SetFooter(page1);
    }


    private void SetHeader(PdfPage page)
    {
        page.CreateHeaderCanvas(HeaderHeight);
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader - 40, PageWidth, MakeHeader(), null);
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(headerHtml);

    }
    private string MakeHeader()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" <div style='width:1200px;'> ");
        sb.Append("<table style='width: 1200px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;'>");
        if (Request.Form["ReportType"].ToString() == "0")
        {
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Client Wise Collection Report(Summary)</span><br />");
        }
        else
        {
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Client Wise Collection Report(Detail)</span><br />");
        }
        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        sb.AppendFormat(" <span style='font-size: 14px;'>{0}</span>", Period);
        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("</table>");
        sb.Append(" </div> ");
        sb.Append(" <div style='width:1200px;'>");
        sb.Append("<table style='width:1200px;border-top:2px solid;border-bottom:2px solid ; font-family:Times New Roman;font-size:16px; bottom-margin:30px'>");
        if (Request.Form["ReportType"].ToString() == "0")
        {
            sb.Append(" <tr> ");
            sb.Append(" <td style='width:12%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Client Name</td> ");
            sb.Append(" <td style='width:7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Gross Amt</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Disc Amt</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetAmt</td> ");

            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>CashAmt</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>CardAmt</td> ");
            sb.Append(" <td style='width:7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>ChequeAmt</td> ");
            sb.Append(" <td style='width:7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>D.CardAmt</td> ");
            sb.Append(" <td style='width:7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Online Pay</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>OPD Advance</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>CreditSale</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Rec. Amt</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>App Amt</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Client Ad Amt</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Cash Outs.</td> ");
            sb.Append(" </tr> ");          
        }
        else
        {
            sb.Append(" <tr> ");
            sb.Append(" <td style='width:12%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Patient Name</td> ");
            sb.Append(" <td style='width:7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Gross Amt</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>DiscAmt</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetAmt</td> ");

            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>CashAmt</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>CardAmt</td> ");
            sb.Append(" <td style='width:7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>ChequeAmt</td> ");
            sb.Append(" <td style='width:7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;text-align:right;'>D.CardAmt</td> ");
            sb.Append(" <td style='width:7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;text-align:right;'>Online Pay</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;text-align:right;'>OPD Advance</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;text-align:right;'>Credit Sale</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;text-align:right;'>Rec. Amt</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;text-align:right;'>AppAmt</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;text-align:right;'>Client Ad Amt</td> ");
            sb.Append(" <td style='width:6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;text-align:right;'>Cash Outs.</td> ");
            sb.Append(" </tr> ");
        }
        sb.Append("</table>");
        sb.Append(" </div> ");
        return sb.ToString();
    }
    private void SetFooter(PdfPage page)
    {
        if (page.Footer != null)
        {
        }
    }
    private void AddContent(string Content)
    {
        PdfPage page1 = tempDocument.AddPage(PdfPageSize.A4, PdfDocumentMargins.Empty);
        PdfHtml html1 = new PdfHtml();
        html1 = new PdfHtml(MarginLeft, ((html1LayoutInfo == null) ? 0 : html1LayoutInfo.LastPageRectangle.Height), PageWidth, Content, null);
        html1.PageCreatingEvent += new PdfPageCreatingDelegate(htmlToPdfConverter_PageCreatingEvent);
        html1.FontEmbedding = false;
        html1.BrowserWidth = BrowserWidth;
        html1.ImagesCutAllowed = false;
        html1LayoutInfo = page1.Layout(html1);
    }
    private void mergeDocument()
    {
        int pageno = 1;
        foreach (PdfPage p in tempDocument.Pages)
        {
            PdfHtml linehtml = new PdfHtml(XFooter, -4, "<div style='width:1140px;border-top:3px solid black;'></div>", null);
            System.Drawing.Font pageNumberingFont =
            new System.Drawing.Font(new System.Drawing.FontFamily("Arial"), 8, System.Drawing.GraphicsUnit.Point);
            PdfText pageNumberingText = new PdfText(PageWidth - 20, FooterHeight - 40, String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;
            PdfText printdatetime = new PdfText(PageWidth - 520, FooterHeight - 40, DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont);
            printdatetime.ForeColor = System.Drawing.Color.Black;

            if (p.Footer == null)
            {
                p.CreateFooterCanvas(FooterHeight);

            }
            p.Footer.Layout(linehtml);
            p.Footer.Layout(pageNumberingText);
            p.Footer.Layout(printdatetime);
            document.Pages.AddPage(p);
            pageno++;
        }
        tempDocument = new PdfDocument();
    }
    public class getDetail
    {
        public int Panel_ID { get; set; }
    }   
}
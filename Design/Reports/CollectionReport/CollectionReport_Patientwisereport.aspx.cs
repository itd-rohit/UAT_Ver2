using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;

public partial class Design_OPD_CollectionReport_Patientwisereport : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs;



    int MarginLeft = 20;
    int MarginRight = 20;
    int PageWidth = 550;
    int BrowserWidth = 1050;


    float HeaderHeight = 40;//207
    int XHeader = 20;//20
    int YHeader = 60;//80
    int HeaderBrowserWidth = 1050;  


    //Footer Property 80
    float FooterHeight = 50;
    int XFooter = 20;


    string HeadersubTitle = "";

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
                DataTable dtClient = new DataTable();
                DataTable dtDetail = new DataTable();
                DataTable dtUserSummery = new DataTable();
                DataTable dtInvoiceamt = new DataTable();
                DataTable dtrefund = new DataTable();
                StringBuilder sb = new StringBuilder();
                // User Collection Summary
                sb.Append(" SELECT rec.CreatedByID,rec.CreatedBy EmployeeName, rec.PaymentModeID,S_Notation, ");
                if (Request.Form["BaseCurrency"].ToString() == "1")
                    sb.Append(" SUM(`Amount`)`Amount`,Rec.`PaymentMode` PaymentMode ");
                else
                    sb.Append(" SUM(S_Amount)Amount,concat(Rec.`PaymentMode`,'(',S_Notation,')') PaymentMode ");
                sb.Append("  FROM f_receipt rec  ");
                sb.Append(" WHERE ifnull(rec.AppointmentID,'')='' and rec.`IsCancel`=0 AND rec.`PayBy`<>'C'");
                if (Request.Form["UserID"].ToString() != string.Empty)
                    sb.Append(" AND rec.`CreatedByID` IN ({0}) ");

                sb.Append(" AND rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate ");
                sb.Append(" AND rec.`CentreID` IN ({1}) ");
                sb.Append(" GROUP BY rec.CreatedByID, rec.`PaymentModeID` ");
                if (Request.Form["BaseCurrency"].ToString() == "0")
                    sb.Append(" , S_Notation ");
              //  appointment amt
                sb.Append(" UNION ALL ");
                sb.Append(" SELECT rec.CreatedByID,rec.CreatedBy EmployeeName, rec.PaymentModeID,S_Notation, ");
                if (Request.Form["BaseCurrency"].ToString() == "1")
                    sb.Append(" SUM(`Amount`)`Amount`,concat('App_',Rec.`PaymentMode`) PaymentMode ");
                else
                    sb.Append(" SUM(S_Amount)Amount,concat('App_',Rec.`PaymentMode`,'(',S_Notation,')') PaymentMode ");
                sb.Append("  FROM f_receipt rec  ");
                sb.Append(" WHERE ifnull(rec.AppointmentID,'')<>'' and rec.`IsCancel`=0 AND rec.`PayBy`<>'C'");
                if (Request.Form["UserID"].ToString() != string.Empty)
                    sb.Append(" AND rec.`CreatedByID` IN ({0}) ");

                sb.Append(" AND rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate ");
                sb.Append(" AND rec.`CentreID` IN ({1}) ");
                sb.Append(" GROUP BY rec.CreatedByID, rec.`PaymentModeID` ");
                if (Request.Form["BaseCurrency"].ToString() == "0")
                    sb.Append(" , S_Notation ");
                //  Client Advance amt
                sb.Append(" UNION ALL ");
                sb.Append(" SELECT rec.CreatedByID,rec.CreatedBy EmployeeName, rec.PaymentModeID,S_Notation, ");
                if (Request.Form["BaseCurrency"].ToString() == "1")
                    sb.Append(" SUM(`Amount`)`Amount`,concat('ClientAdvance_',Rec.`PaymentMode`) PaymentMode ");
                else
                    sb.Append(" SUM(S_Amount)Amount,concat('ClientAdvance_',Rec.`PaymentMode`,'(',S_Notation,')') PaymentMode ");
                sb.Append("  FROM f_receipt rec  ");
                sb.Append(" WHERE ifnull(rec.AppointmentID,'')='' and rec.`IsCancel`=0 AND rec.`PayBy`='C'");
                if (Request.Form["UserID"].ToString() != string.Empty)
                    sb.Append(" AND rec.`CreatedByID` IN ({0}) ");

                sb.Append(" AND rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate ");
                sb.Append(" AND rec.`CentreID` IN ({1}) ");
                sb.Append(" GROUP BY rec.CreatedByID, rec.`PaymentModeID` ");
                if (Request.Form["BaseCurrency"].ToString() == "0")
                    sb.Append(" , S_Notation "); 

                List<string> UserDataList = new List<string>();
                UserDataList = Request.Form["UserID"].ToString().Split(',').ToList<string>();

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


                    }
                    //Client Collection Summary
                    sb = new StringBuilder();
                    sb.Append(" SELECT pnl.Company_Name ,rec.PaymentModeID,pnl.Panel_ID,S_Notation,");
                    if (Request.Form["BaseCurrency"].ToString() == "1")
                        sb.Append(" SUM(`Amount`)`Amount`,Rec.`PaymentMode` PaymentMode ");
                    else
                        sb.Append(" SUM(S_Amount)Amount,concat(Rec.`PaymentMode`,'(',S_Notation,')') PaymentMode ");
                    sb.Append(" FROM f_receipt rec ");
                    sb.Append(" INNER JOIN f_panel_master pnl ON pnl.Panel_ID = rec.Panel_ID ");
                    sb.Append(" WHERE ifnull(rec.AppointmentID,'')=''and rec.`IsCancel`=0 AND rec.`PayBy`<>'C' ");

                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND rec.`CreatedByID` IN ({0}) ");

                    sb.Append(" AND rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate ");
                    sb.Append(" AND rec.`CentreID` IN ({1}) ");
                    sb.Append(" GROUP BY IF(pnl.InvoiceTo=0,pnl.Panel_ID,pnl.InvoiceTo), Rec.`PaymentModeID`");
                    if (Request.Form["BaseCurrency"].ToString() == "0")
                        sb.Append(" , S_Notation ");
                    //appointment Amount
                    sb.Append(" UNION All ");
                    sb.Append(" SELECT pnl.Company_Name ,rec.PaymentModeID,pnl.Panel_ID,S_Notation,");
                    if (Request.Form["BaseCurrency"].ToString() == "1")
                        sb.Append(" SUM(`Amount`)`Amount`,concat('App_',Rec.`PaymentMode`) PaymentMode ");
                    else
                        sb.Append(" SUM(S_Amount)Amount,concat('App_',Rec.`PaymentMode`,'(',S_Notation,')') PaymentMode ");
                    sb.Append(" FROM f_receipt rec ");
                    sb.Append(" INNER JOIN f_panel_master pnl ON pnl.Panel_ID = rec.Panel_ID ");
                    sb.Append(" WHERE ifnull(rec.AppointmentID,'')<>'' and rec.`IsCancel`=0 AND rec.`PayBy`<>'C' ");

                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND rec.`CreatedByID` IN ({0}) ");

                    sb.Append(" AND rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate ");
                    sb.Append(" AND rec.`CentreID` IN ({1}) ");
                    sb.Append(" GROUP BY IF(pnl.InvoiceTo=0,pnl.Panel_ID,pnl.InvoiceTo), Rec.`PaymentModeID`");
                    if (Request.Form["BaseCurrency"].ToString() == "0")
                        sb.Append(" , S_Notation ");
                    //Client Advance Amount
                    sb.Append(" UNION All ");
                    sb.Append(" SELECT pnl.Company_Name ,rec.PaymentModeID,pnl.Panel_ID,S_Notation,");
                    if (Request.Form["BaseCurrency"].ToString() == "1")
                        sb.Append(" SUM(`Amount`)`Amount`,concat('ClientAdvance_',Rec.`PaymentMode`) PaymentMode ");
                    else
                        sb.Append(" SUM(S_Amount)Amount,concat('ClientAdvance_',Rec.`PaymentMode`,'(',S_Notation,')') PaymentMode ");
                    sb.Append(" FROM f_receipt rec ");
                    sb.Append(" INNER JOIN f_panel_master pnl ON pnl.Panel_ID = rec.Panel_ID ");
                    sb.Append(" WHERE ifnull(rec.AppointmentID,'')='' and rec.`IsCancel`=0 AND rec.`PayBy`='C' ");

                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND rec.`CreatedByID` IN ({0}) ");

                    sb.Append(" AND rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate ");
                    sb.Append(" AND rec.`CentreID` IN ({1}) ");
                    sb.Append(" GROUP BY IF(pnl.InvoiceTo=0,pnl.Panel_ID,pnl.InvoiceTo), Rec.`PaymentModeID`");
                    if (Request.Form["BaseCurrency"].ToString() == "0")
                        sb.Append(" , S_Notation ");  


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
                        da.Fill(dtClient);

                    }

                    sb = new StringBuilder();
                    sb.Append(" SELECT DATE_FORMAT(rec.`CreatedDate`,'%d-%m-%Y %H:%i')DATE,rec.CreatedByID Employee_ID,rec.CreatedBy EmployeeName,  ");
                    sb.Append("  rec.`ReceiptNo`,rec.TransactionID, rec.`LedgerTransactionNo` ");
                    sb.Append(" ,CONCAT(Rec.`PaymentMode`,' ',Rec.`Amount`) Payment, ");
                    sb.Append(" CONCAT(pm.`Title`,' ',pm.`PName`)PatientName, CONCAT(IF(ageyear<>0,CONCAT(ageyear,' Y'),''),IF(agemonth<>0,CONCAT(' ',agemonth,' M'),''),IF(agedays<>0,CONCAT(' ',agedays,' D'),'')) Age,pm.`Gender`, ");
                    if (Request.Form["BaseCurrency"].ToString() == "1")
                        sb.Append(" Rec.`Amount`,rec.PaymentMode S_Notation, ");
                    else
                        sb.Append(" rec.S_Amount Amount,rec.S_Notation, ");
                    sb.Append(" rec.Patient_ID,rec.`PaymentMode`,rec.`PaymentModeID` FROM f_receipt rec  ");

                    sb.Append(" INNER JOIN `patient_master` pm ON pm.`Patient_ID`=rec.`Patient_ID` ");
                    sb.Append(" WHERE rec.`IsCancel`=0 and  ifnull(rec.AppointmentID,'')='' AND rec.`PayBy`<>'C' ");
                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND rec.`CreatedByID` IN ({0}) ");

                    sb.Append(" AND rec.`CentreID` IN ({1}) ");
                    sb.Append(" AND rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate ");
                    //Appointment Amount
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT DATE_FORMAT(rec.`CreatedDate`,'%d-%m-%Y %H:%i')DATE,rec.CreatedByID Employee_ID,rec.CreatedBy EmployeeName,  ");
                    sb.Append("  rec.`ReceiptNo`,rec.TransactionID,rec.LedgerTransactionNo ");
                    sb.Append(" ,CONCAT(Rec.`PaymentMode`,' ',Rec.`Amount`) Payment, ");
                    sb.Append(" (select CONCAT(pm.`Title`,' ',pm.`PatientName`) from appointment_radiology_details pm where pm.`AppointmentID`=rec.`AppointmentID` limit 1)PatientName, 0 Age,'' Gender, ");
                    if (Request.Form["BaseCurrency"].ToString() == "1")
                        sb.Append(" Rec.`Amount`,rec.PaymentMode S_Notation, ");
                    else
                        sb.Append(" rec.S_Amount Amount,rec.S_Notation, ");
                    sb.Append(" 'Appointment' Patient_ID,rec.`PaymentMode`,rec.`PaymentModeID` FROM f_receipt rec  ");
                    sb.Append(" WHERE rec.`IsCancel`=0 and  ifnull(rec.AppointmentID,'')<>'' AND rec.`PayBy`<>'C' ");
                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND rec.`CreatedByID` IN ({0}) ");

                    sb.Append(" AND rec.`CentreID` IN ({1}) ");
                    sb.Append(" AND rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate ");
                    //client Advance Amount
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT DATE_FORMAT(rec.`CreatedDate`,'%d-%m-%Y %H:%i')DATE,rec.CreatedByID Employee_ID,rec.CreatedBy EmployeeName,  ");
                    sb.Append("  rec.`ReceiptNo`,rec.TransactionID, pnl.Panel_ID LedgerTransactionNo ");
                    sb.Append(" ,CONCAT(Rec.`PaymentMode`,' ',Rec.`Amount`) Payment, ");
                    sb.Append("pnl.Company_Name PatientName, '' Age,'' Gender, ");
                    if (Request.Form["BaseCurrency"].ToString() == "1")
                        sb.Append(" Rec.`Amount`,rec.PaymentMode S_Notation, ");
                    else
                        sb.Append(" rec.S_Amount Amount,rec.S_Notation, ");
                    sb.Append(" 'Client' Patient_ID,rec.`PaymentMode`,rec.`PaymentModeID` FROM f_receipt rec  ");

                    sb.Append(" INNER JOIN f_panel_master pnl ON pnl.Panel_ID = rec.Panel_ID ");
                    sb.Append(" WHERE rec.`IsCancel`=0 and  ifnull(rec.AppointmentID,'')='' AND rec.`PayBy`='C' ");
                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND rec.`CreatedByID` IN ({0}) ");

                    sb.Append(" AND rec.`CentreID` IN ({1}) ");
                    sb.Append(" AND rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate ");
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
                        da.Fill(dtDetail);

                       
                    }
                    //User wise detail Refund
                    sb = new StringBuilder();
                    sb.Append(" SELECT DATE_FORMAT(rec.`CreatedDate`,'%d-%m-%Y %H:%i')DATE,rec.CreatedByID Employee_ID,rec.CreatedBy EmployeeName,  ");
                    sb.Append("  rec.`ReceiptNo`, rec.`LedgerTransactionNo` ");
                    sb.Append(" ,CONCAT(Rec.`PaymentMode`,' ',Rec.`Amount`) Payment, ");
                    sb.Append(" CONCAT(pm.`Title`,' ',pm.`PName`)PatientName, CONCAT(IF(ageyear<>0,CONCAT(ageyear,' Y'),''),IF(agemonth<>0,CONCAT(' ',agemonth,' M'),''),IF(agedays<>0,CONCAT(' ',agedays,' D'),'')) Age,pm.`Gender`, ");                 
                        sb.Append(" rec.`Amount`,rec.PaymentMode S_Notation, ");                                    
                    sb.Append(" rec.Patient_ID,rec.`PaymentMode`,rec.`PaymentModeID` FROM f_receipt rec  ");

                    sb.Append(" INNER JOIN `patient_master` pm ON pm.`Patient_ID`=rec.`Patient_ID` ");                   
                    sb.Append(" WHERE rec.`IsCancel`=0 and rec.Amount < 0 ");
                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND rec.`CreatedByID` IN ({0}) ");

                    sb.Append(" AND rec.`CentreID` IN ({1}) ");
                    sb.Append(" AND rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate ");
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
                        da.Fill(dtrefund);
                    }

                    // Single Line User Summary
                    sb = new StringBuilder();
                    sb.Append("  SELECT EmployeeName,SUM(GrossAmount)GrossAmount,SUM(NetAmount)NetAmount,SUM(DiscountAmt)DiscountAmt,SUM(CashAmt)CashAmt,");
                    sb.Append(" SUM(CardAmt)CardAmt,SUM(ChequeAmt)ChequeAmt,SUM(Amount)Amount,SUM(S_Amount)S_Amount,SUM(OnlineAmt)OnlineAmt,sum(DebitCardAmt) DebitCardAmt, ");
                    sb.Append(" SUM(CreditSale)CreditSale,SUM(AmtSubmission)AmtSubmission,SUM(SameDaySettlement)SameDaySettlement,SUM(BackDaySettlement)BackDaySettlement,SUM(CreditSaleReceiveSameDay)CreditSaleReceiveSameDay,sum(AppAmt) AppAmt,sum(ClientAdvanceAmt)ClientAdvanceAmt, ");
                    sb.Append("  SUM(NetAmount-SameDaySettlement-CreditSale+CreditSaleReceiveSameDay) SamedayOutstanding ");
                    sb.Append(" FROM ( ");
                    sb.Append(" SELECT SUM(Rate*Quantity)GrossAmount,SUM(Amount)NetAmount,SUM(DiscountAmt)DiscountAmt,0 Amount,0 S_Amount,  ");
                    sb.Append("  '' PaymentMode,0 PaymentModeID,plo.CreatedByID,plo.createdBy EmployeeName, ");
                    sb.Append(" 0 CashAmt,0 CardAmt,0 ChequeAmt,0 OnlineAmt,0 DebitCardAmt,  ");
                    sb.Append(" SUM(IF(lt.`IsCredit`=1,(Rate*Quantity),0)) CreditSale ,0 AmtSubmission,0 SameDaySettlement,0 BackDaySettlement,0 CreditSaleReceiveSameDay,0 AppAmt,0 ClientAdvanceAmt ");
                    sb.Append(" FROM `patient_labinvestigation_opd` plo ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");                   
                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND plo.`CreatedByID` IN ({0}) ");
                    sb.Append("   AND plo.`CentreID` IN ({1}) ");
                    sb.Append(" AND plo.date >=@fromDate AND plo.date <= @toDate  AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append("  GROUP BY plo.CreatedById ");
                     //cash collection
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT 0 GrossAmount,0 NetAmount,0 DiscountAmt,SUM(Amount)Amount,SUM(S_Amount)S_Amount, ");
                    sb.Append(" PaymentMode,PaymentModeID,rc.CreatedByID,rc.CreatedBy EmployeeName, ");
                    sb.Append(" SUM(IF(`PaymentModeID`=1,Amount,0))CashAmt,SUM(IF(`PaymentModeID`=3,Amount,0))CardAmt, ");
                    sb.Append("  SUM(IF(`PaymentModeID`=2,Amount,0))ChequeAmt,SUM(IF(`PaymentModeID`=10,Amount,0))OnlineAmt,SUM(IF(`PaymentModeID`=5,Amount,0))DebitCardAmt, ");
                    sb.Append(" 0 CreditSale,0 AmtSubmission, ");
                    sb.Append(" SUM(IFNULL((IF( lt.Date >= @fromDate   AND lt.Date <=  @toDate ,rc.Amount,0)),0)) SameDaySettlement, ");
                    sb.Append(" SUM(IFNULL((IF( lt.Date < @fromDate   ,rc.Amount,0)),0)) BackDaySettlement,  ");
                    sb.Append(" SUM(IFNULL((IF( lt.Date >= @fromDate   AND lt.Date <=  @toDate  AND lt.`IsCredit`=1,rc.Amount,0)),0)) CreditSaleReceiveSameDay,0 AppAmt,0 ClientAdvanceAmt ");
                    sb.Append(" FROM f_receipt rc ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=rc.`LedgerTransactionID` ");
                    sb.Append(" AND rc.Iscancel=0 and  ifnull(rc.AppointmentID,'')='' AND rc.`PayBy`<>'C' ");
                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND rc.`CreatedByID` IN ({0}) ");

                    sb.Append(" AND rc.`CentreID` IN ({1}) ");
                    sb.Append(" AND rc.`CreatedDate` >=@fromDate AND rc.`CreatedDate` <= @toDate ");                    
                    sb.Append("   GROUP BY rc.CreatedById ");
                    //Appointment collection
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT 0 GrossAmount,0 NetAmount,0 DiscountAmt,0 Amount,0 S_Amount, ");
                    sb.Append(" PaymentMode,PaymentModeID,rc.CreatedByID,rc.CreatedBy EmployeeName, ");
                    sb.Append(" 0 CashAmt,0 CardAmt, ");
                    sb.Append(" 0 ChequeAmt,0 OnlineAmt,0 DebitCardAmt, ");
                    sb.Append(" 0 CreditSale,0 AmtSubmission, ");
                    sb.Append(" 0 SameDaySettlement, ");
                    sb.Append(" 0 BackDaySettlement,  ");
                    sb.Append(" 0 CreditSaleReceiveSameDay,SUM(Amount) AppAmt,0 ClientAdvanceAmt ");
                    sb.Append(" FROM f_receipt rc ");
                    sb.Append(" where rc.Iscancel=0 and  ifnull(rc.AppointmentID,'')<>'' AND rc.`PayBy`<>'C' ");
                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND rc.`CreatedByID` IN ({0}) ");

                    sb.Append(" AND rc.`CentreID` IN ({1}) ");
                    sb.Append(" AND rc.`CreatedDate` >=@fromDate AND rc.`CreatedDate` <= @toDate ");
                    sb.Append("   GROUP BY rc.CreatedById ");
                    //client advance collection
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT 0 GrossAmount,0 NetAmount,0 DiscountAmt,0 Amount,0 S_Amount, ");
                    sb.Append(" PaymentMode,PaymentModeID,rc.CreatedByID,rc.CreatedBy EmployeeName, ");
                    sb.Append(" 0 CashAmt,0 CardAmt, ");
                    sb.Append(" 0 ChequeAmt,0 OnlineAmt,0 DebitCardAmt, ");
                    sb.Append(" 0 CreditSale,0 AmtSubmission, ");
                    sb.Append(" 0 SameDaySettlement, ");
                    sb.Append(" 0 BackDaySettlement,  ");
                    sb.Append(" 0 CreditSaleReceiveSameDay,0  AppAmt,SUM(Amount) ClientAdvanceAmt ");
                    sb.Append(" FROM f_receipt rc ");
                    sb.Append(" where rc.Iscancel=0 and  ifnull(rc.AppointmentID,'')='' AND rc.`PayBy`='C' ");
                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND rc.`CreatedByID` IN ({0}) ");

                    sb.Append(" AND rc.`CentreID` IN ({1}) ");
                    sb.Append(" AND rc.`CreatedDate` >=@fromDate AND rc.`CreatedDate` <= @toDate ");
                    sb.Append("   GROUP BY rc.CreatedById ");
                    //Invoice Amt submission
                     sb.Append(" UNION ALL ");
                     sb.Append(" SELECT 0 GrossAmount,0 NetAmount,0 DiscountAmt,0 Amount,0 S_Amount,  ");
                     sb.Append("  PaymentMode, PaymentModeID,EntryBy CreatedByID,EntryByName EmployeeName, ");
                     sb.Append(" 0 CashAmt,0 CardAmt,  0 ChequeAmt,0 OnlineAmt,0 DebitCardAmt , ");
                     sb.Append(" 0 CreditSale,SUM(ReceivedAmt) AmtSubmission,0 SameDaySettlement,0 BackDaySettlement,0 CreditSaleReceiveSameDay,0 AppAmt,0 ClientAdvanceAmt ");
                    sb.Append(" FROM invoicemaster_onaccount im ");
                    sb.Append("   WHERE IsCancel=0   AND CreditNote = 0 AND ReceivedAmt > 0   ");
                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND im.`EntryBy` IN ({0}) ");

                    sb.Append(" AND im.EntryDate >=@fromDate AND im.EntryDate <= @toDate ");
                    sb.Append("   GROUP BY EntryBy ");
                    sb.Append(" )a GROUP BY CreatedById ");
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
                        da.Fill(dtUserSummery);
                       
                        CentreIDDataList.Clear();
                    }
                   //Invoice Amt Submission
                    sb = new StringBuilder();
                    sb.Append(" SELECT DATE_FORMAT(EntryDate,'%d-%m-%Y %H:%i')DATE,EntryBy Employee_ID,EntryByName EmployeeName,     ");
                    sb.Append(" im.ReceiptNo,CONCAT(PaymentMode,' ',ReceivedAmt) Payment,pm.Company_Name, ");
                    if (Request.Form["BaseCurrency"].ToString() == "1")
                        sb.Append(" im.ReceivedAmt,  im.PaymentMode ");
                    else
                        sb.Append(" im.S_Amount ReceivedAmt,concat(im.PaymentMode,'(',im.S_Notation,')') PaymentMode ");
                    sb.Append("  FROM invoicemaster_onaccount im  INNER JOIN f_Panel_Master pm ON pm.`Panel_ID`=im.`Panel_ID`  ");
                    sb.Append("  WHERE `IsCancel`=0  AND `ReceivedAmt`>0 AND `CreditNote`=0  ");
                    sb.Append(" AND EntryDate >=@fromDate AND EntryDate <= @toDate  ");
                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND EntryBy IN ({0}) ");
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", UserDataList)), con))
                    {
                        for (int i = 0; i < UserDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), UserDataList[i]);
                        }                       
                        da.SelectCommand.Parameters.AddWithValue("@fromDate", Request.Form["fromDate"].ToString());
                        da.SelectCommand.Parameters.AddWithValue("@toDate", Request.Form["toDate"].ToString());
                        da.Fill(dtInvoiceamt);
                        UserDataList.Clear();                        
                    }

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        string Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss "), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));


                        sb = new StringBuilder();
                        sb.Append(" <div style='width:1050px;'> ");
                        sb.Append(" <table style='width: 100%; border-collapse: collapse;'> ");
                        sb.Append(" <tr> ");
                        sb.Append(" <td style='text-align: center;'> ");
                        if (Request.Form["BaseCurrency"].ToString() == "1")
                        {
                            sb.Append(" <span style='display: inline-block; font-size: 20px; font-weight: bold; margin-top: 10px;'>Collection Report(In Base Currency)</span><br /> ");
                        }
                        else
                        {
                            sb.Append(" <span style='display: inline-block; font-size: 20px; font-weight: bold; margin-top: 10px;'>Collection Report(In Actual Currency)</span><br /> ");
                        }
                        sb.AppendFormat(" <span style='display: inline-block; margin-top: 5px;'>{0}</span> ", Period);
                        sb.Append(" </td> ");
                        sb.Append(" </tr> ");
                        sb.Append(" </table> ");
                        sb.Append(" </div> ");
                        //user wise collection
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            sb.Append(" <div style='width:1050px;'> ");
                            sb.Append(" <table style='width: 100%; border-collapse: collapse;'> ");
                            sb.Append(" <tr> ");
                            sb.Append(" <td style='font-size: 16px !important !important !important;padding-top: 20px;padding-bottom: 8px;'><u>User Collection Summary</u></td> ");
                            sb.Append(" </tr> ");
                            sb.Append(" </table> ");
                            sb.Append(" </div> ");

                            sb.Append(" <div style='width:1050px;'> ");
                            sb.Append(" <table style='width: 100%; border-collapse: collapse;'> ");
                            sb.Append(" <tr> ");
                            sb.Append(" <td style='width: 28%'></td> ");
                            var PaymentModeDetail = (from DataRow dRow in dt.Rows
                                                     select new { PaymentModeID = dRow["PaymentModeID"], PaymentMode = dRow["PaymentMode"], CurrencyMode = dRow["S_Notation"] }).Distinct().ToList();

                            for (int j = 0; j < PaymentModeDetail.Count; j++)
                            {
                                sb.AppendFormat("<td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;'>{0}</td>", PaymentModeDetail[j].PaymentMode.ToString());
                            }


                            sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;'>Total</td>");
                            sb.Append(" </tr>");

                            var distinctReceiver = (from DataRow dRow in dt.Rows
                                                    select new { CreatedByID = dRow["CreatedByID"], EmployeeName = dRow["EmployeeName"] }).Distinct().ToList();
                            for (int i = 0; i < distinctReceiver.Count; i++)
                            {
                                sb.Append(" <tr>");
                                sb.AppendFormat(" <td style='width: 28%;border:1px solid;padding: 0.3em;'>{0}</td>", distinctReceiver[i].EmployeeName.ToString());
                                for (int j = 0; j < PaymentModeDetail.Count; j++)
                                {
                                    sb.AppendFormat(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(x => x.Field<sbyte>("PaymentModeID") == Util.GetByte(PaymentModeDetail[j].PaymentModeID) && x.Field<int>("CreatedByID") == Util.GetInt(distinctReceiver[i].CreatedByID.ToString()) && x.Field<string>("S_Notation") == Util.GetString(PaymentModeDetail[j].CurrencyMode) && x.Field<string>("PaymentMode") == Util.GetString(PaymentModeDetail[j].PaymentMode)).Sum(x => x.Field<Decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero));
                                }
                                sb.AppendFormat(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(x => x.Field<int>("CreatedByID") == Util.GetInt(distinctReceiver[i].CreatedByID.ToString())).Sum(x => x.Field<Decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.Append(" </tr>");
                            }


                            sb.Append(" <tr>");
                            sb.Append(" <td style='width: 28%;border:1px solid;padding: 0.3em;'>Total :</td>");

                            for (int j = 0; j < PaymentModeDetail.Count; j++)
                            {
                                sb.AppendFormat(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(x => x.Field<sbyte>("PaymentModeID") == Util.GetByte(PaymentModeDetail[j].PaymentModeID) && x.Field<string>("S_Notation") == Util.GetString(PaymentModeDetail[j].CurrencyMode) && x.Field<string>("PaymentMode") == Util.GetString(PaymentModeDetail[j].PaymentMode)).Sum(x => x.Field<Decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero));
                            }
                            sb.AppendFormat(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            sb.Append(" </tr>");
                            sb.Append(" </table>");
                            sb.Append("</div>");
                        }
                    }

                    // panel wise collection
                    if (dtClient != null && dtClient.Rows.Count > 0)
                    {
                        sb.Append(" <div style='width:1050px;'> ");
                        sb.Append(" <table style='width: 100%; border-collapse: collapse;'> ");
                        sb.Append(" <tr> ");
                        sb.Append(" <td style='font-size: 16px;padding-top: 20px;padding-bottom: 8px;'><u>Client Collection Summary</u></td> ");
                        sb.Append(" </tr> ");
                        sb.Append(" </table> ");
                        sb.Append(" </div> ");
                        sb.Append(" <div style='width:1050px;'> ");
                        sb.Append(" <table style='width: 100%; border-collapse: collapse;'> ");
                        sb.Append(" <tr> ");
                        sb.Append(" <td style='width: 28%'></td> ");

                        var PaymentModeDetail = (from DataRow dRow in dtClient.Rows
                                                 select new { PaymentModeID = dRow["PaymentModeID"], PaymentMode = dRow["PaymentMode"], CurrencyMode = dRow["S_Notation"] }).Distinct().ToList();

                        for (int j = 0; j < PaymentModeDetail.Count; j++)
                        {
                            sb.AppendFormat("<td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;'>{0}</td>", PaymentModeDetail[j].PaymentMode.ToString());
                        }
                        sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;'>Total</td>");
                        sb.Append(" </tr>");

                        var distinctClient = (from DataRow dRow in dtClient.Rows
                                              select new { Panel_ID = dRow["Panel_ID"], Company_Name = dRow["Company_Name"] }).Distinct().ToList();

                        for (int i = 0; i < distinctClient.Count; i++)
                        {
                            sb.Append(" <tr>");
                            sb.AppendFormat(" <td style='width: 28%;border:1px solid;padding: 0.3em;'>{0}</td>", distinctClient[i].Company_Name.ToString());
                            for (int j = 0; j < PaymentModeDetail.Count; j++)
                            {
                                sb.AppendFormat(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dtClient.AsEnumerable().Where(x => x.Field<sbyte>("PaymentModeID") == Util.GetByte(PaymentModeDetail[j].PaymentModeID) && x.Field<int>("Panel_ID") == Util.GetInt(distinctClient[i].Panel_ID.ToString()) && x.Field<string>("S_Notation") == Util.GetString(PaymentModeDetail[j].CurrencyMode) && x.Field<string>("PaymentMode") == Util.GetString(PaymentModeDetail[j].PaymentMode)).Sum(x => x.Field<Decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero));
                            }
                            sb.AppendFormat(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dtClient.AsEnumerable().Where(x => x.Field<int>("Panel_ID") == Util.GetInt(distinctClient[i].Panel_ID.ToString())).Sum(x => x.Field<Decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            sb.Append(" </tr>");
                        }
                        sb.Append(" <tr>");
                        sb.Append(" <td style='width: 28%;border:1px solid;padding: 0.3em;'>Total :</td>");
                        for (int j = 0; j < PaymentModeDetail.Count; j++)
                        {
                            sb.AppendFormat(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dtClient.AsEnumerable().Where(x => x.Field<sbyte>("PaymentModeID") == Util.GetByte(PaymentModeDetail[j].PaymentModeID) && x.Field<string>("S_Notation") == Util.GetString(PaymentModeDetail[j].CurrencyMode) && x.Field<string>("PaymentMode") == Util.GetString(PaymentModeDetail[j].PaymentMode)).Sum(x => x.Field<Decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero));
                        }

                        sb.AppendFormat(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dtClient.AsEnumerable().Sum(x => x.Field<Decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                        sb.Append(" </tr>");
                        sb.Append(" </table>");
                        sb.Append("</div>");
                    }
                    //Invoice Amount Submission
                    if (dtInvoiceamt != null && dtInvoiceamt.Rows.Count > 0)
                    {
                        sb.Append(" <div style='width:1050px;'> ");
                        sb.Append(" <table style='width: 100%; border-collapse: collapse;padding-top:6px;'> ");
                        sb.Append(" <tr> ");
                        sb.Append("   <td style='font-size: 16px;padding-top: 20px;padding-bottom: 8px;'><u>User Wise Invoice Amount Submission</u></td> ");
                        sb.Append("  </tr> ");
                        sb.Append(" </table> ");
                        sb.Append(" </div> ");
                        sb.Append(" <div style='width:1050px;'>");
                        sb.Append(" <table style='width: 100%; border-collapse: collapse;padding-top:6px;'> ");
                        sb.Append(" <tr> ");
                        sb.Append(" <td style='width: 20%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Payment Date/Time</td> ");
                        sb.Append(" <td style='width: 20%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Receipt No.</td> ");                        
                        sb.Append(" <td style='width: 30%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Client Name</td> ");                        
                        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Payment Detail</td> ");
                        sb.Append(" <td style='width: 20%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;text-align:right;'>Amount</td> ");
                        sb.Append(" </tr> ");
                        sb.Append(" </table> ");
                        sb.Append("</div>");                        
                        var distinctempid = (from DataRow drow in dtInvoiceamt.Rows
                                             select new { Employee_ID = drow["Employee_ID"] }).Distinct().ToList();
                        sb.Append("<div style='width:1000px;'>");
                        for (int i = 0; i < distinctempid.Count; i++)
                        {
                            DataTable dtinv = dtInvoiceamt.AsEnumerable().Where(s3 => s3.Field<int>("Employee_ID") == Util.GetInt(distinctempid[i].Employee_ID)).CopyToDataTable();
                            sb.Append("<table style='width: 100%'>");
                            sb.Append(" <tr> ");
                            sb.Append(" <td colspan='1' style='font-size: 16px;padding-top: 10px;padding-bottom: 10px;'>Receiver : </td> ");
                            sb.Append(" <td colspan='4' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtinv.Rows[0]["EmployeeName"].ToString()) + "</td> ");
                            sb.Append(" </tr> ");
                            for (int j = 0; j < dtinv.Rows.Count; j++)
                            {
                                sb.Append(" <tr> ");
                                sb.AppendFormat(" <td style='width: 20%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtinv.Rows[j]["DATE"]));
                                sb.AppendFormat(" <td style='width: 20%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtinv.Rows[j]["ReceiptNo"]));
                                sb.AppendFormat(" <td style='width: 30%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtinv.Rows[j]["Company_Name"]));

                                sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(string.Concat(Util.GetString(dtinv.Rows[j]["PaymentMode"]), " ", Math.Round(Util.GetDecimal(dtinv.Rows[j]["ReceivedAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero))));
                                sb.AppendFormat(" <td style='width: 20%;text-align:right;font-weight: bold;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetDouble(dtinv.Rows[j]["ReceivedAmt"]));
                                sb.Append(" </tr> ");
                            }
                            sb.Append(" <tr> ");
                            sb.Append(" <td colspan='2' ></td> ");
                   //         sb.Append(" <td colspan='3' style='border-bottom: 2px solid;padding-top: 3px;font-size: 16px;'>Sub-total :( " + Util.GetString(dtinv.Rows[0]["EmployeeName"].ToString()) + ") <span style='font-weight: bold;float: right;'>" + Math.Round(Util.GetDecimal(dtinv.AsEnumerable().Sum(x => x.Field<double>("ReceivedAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)) + "</span> </td> ");
                            sb.Append(" </tr> ");
                            sb.Append("</table>");
                            sb.Append("</div>");
                        }
                    }

                    if (dtDetail != null && dtDetail.Rows.Count > 0)
                    {
                        sb.Append(" <div style='width:1050px;'> ");
                        sb.Append(" <table style='width: 1050px; border-collapse: collapse;padding-top:6px;'> ");
                        sb.Append(" <tr> ");
                        sb.Append("   <td style='font-size: 16px;padding-top: 20px;padding-bottom: 8px;'><u>User Collection Detail</u></td> ");
                        sb.Append("  </tr> ");
                        sb.Append(" </table> ");
                        sb.Append(" </div> ");
                        sb.Append(" <div style='width:1050px;'>");
                        sb.Append(" <table style='width: 1050px; border-collapse: collapse;padding-top:6px;'> ");
                        sb.Append(" <tr> ");
                        sb.Append(" <td style='width: 15%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Payment Date/Time</td> ");
                        sb.Append(" <td style='width: 15%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Receipt No.</td> ");
                        sb.Append(" <td style='width: 15%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>MR No.</td> ");
                        sb.Append(" <td style='width: 15%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Patient Name</td> ");
                        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Visit No.</td> ");
                        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>TnxID</td> ");
                        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Payment Detail</td> ");
                        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;text-align:right'>Amount</td> ");
                        sb.Append(" </tr> ");
                        sb.Append(" </table> ");
                        sb.Append("</div>");                                            

                            var distinctEmpID = (from DataRow dRow in dtDetail.Rows
                                                 select new { Employee_ID = dRow["Employee_ID"] }).Distinct().ToList();

                            sb.Append("<div style='width:1050px;'>");
                            for (int i = 0; i < distinctEmpID.Count; i++)
                            {
                                DataTable dt3 = dtDetail.AsEnumerable().Where(s1 => s1.Field<int>("Employee_ID") == Util.GetInt(distinctEmpID[i].Employee_ID)).CopyToDataTable();

                                sb.Append("<table style='width: 1050px;'>");
                                sb.Append(" <tr> ");
                                sb.Append(" <td colspan='2' style='font-size: 16px;padding-top: 10px;'>Receiver : </td> ");
                                sb.Append(" <td colspan='6' style='font-size: 16px;font-weight: bold;padding-top: 10px;'>" + Util.GetString(dt3.Rows[0]["EmployeeName"].ToString()) + "</td> ");
                                sb.Append(" </tr> ");
                               
                                var distincePaymentModeID = (from DataRow dRow in dt3.Rows
                                                             select new { PaymentModeID = dRow["PaymentModeID"] }).Distinct().ToList();

                                for (int b = 0; b < distincePaymentModeID.Count; b++)
                                {

                                    DataTable dt2 = dt3.AsEnumerable().Where(s1 => s1.Field<sbyte>("PaymentModeID") == Util.GetByte(distincePaymentModeID[b].PaymentModeID)).CopyToDataTable();
                                    for (int s = 0; s < dt2.Rows.Count; s++)
                                    {

                                        if (s == 0)
                                        {
                                            sb.Append(" <tr> ");
                                            sb.Append(" <td colspan='2' style='font-size: 16px;padding-top: 10px;'>Payment Mode : </td> ");
                                            sb.Append(" <td colspan='6' style='font-size: 16px;font-weight: bold;padding-top: 10px;'>" + Util.GetString(dt2.Rows[s]["PaymentMode"].ToString()) + "</td> ");
                                            sb.Append("  </tr> ");
                                            sb.Append(" <tr> ");
                                            sb.Append(" <td style='border-bottom: 1px solid;' colspan='8'>Bill Receipts</td> ");
                                            sb.Append(" </tr> ");
                                        }
                                        if (Util.GetDecimal(dt2.Rows[s]["Amount"]) < 0)                                        
                                            sb.Append("<tr style='background-color:#ffe6e6;'> ");                                        
                                        else
                                            sb.Append("<tr> ");
                                            sb.AppendFormat(" <td style='width: 15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt2.Rows[s]["DATE"]));
                                            sb.AppendFormat(" <td style='width: 15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt2.Rows[s]["ReceiptNo"]));
                                            sb.AppendFormat(" <td style='width: 15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt2.Rows[s]["Patient_ID"]));
                                            sb.AppendFormat(" <td style='width: 15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt2.Rows[s]["PatientName"]));
                                            sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt2.Rows[s]["LedgerTransactionNo"]));
                                            sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt2.Rows[s]["TransactionID"]));
                                            sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(string.Concat(Util.GetString(dt2.Rows[s]["S_Notation"]), " ", Math.Round(Util.GetDecimal(dt2.Rows[s]["Amount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero))));
                                            sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;text-align:right'>{0}</td> ", Util.GetDouble(dt2.Rows[s]["Amount"]));
                                            sb.Append(" </tr> ");
                                        
                                    }
                                    sb.Append(" <tr> ");
                                    sb.Append(" <td colspan='3' ></td> ");
                                    sb.Append(" <td colspan='5' style='border-bottom: 2px solid;padding-top: 3px;font-size: 16px;'>Sub-total :( " + Util.GetString(dt3.Rows[0]["EmployeeName"].ToString()) + "," + Util.GetString(dt2.Rows[0]["PaymentMode"].ToString()) + ",Bill Receipts ) <span style='font-weight: bold;float: right;'>" + Math.Round(Util.GetDecimal(dt2.AsEnumerable().Sum(x => x.Field<Decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                    sb.Append(" </tr> ");

                                }


                                //sb.Append(" <tr> ");
                                //sb.Append(" <td colspan='3' ></td> ");
                                //sb.AppendFormat(" <td colspan='4' style='border-bottom: 2px solid;padding-top: 3px;font-size: 16px;'>Grand Total Collection for User :({0}) <span style='font-weight: bold;float: right;'>{1}</span> </td> ", Util.GetString(dt3.Rows[i]["EmployeeName"].ToString()), Math.Round(Util.GetDecimal(dt3.AsEnumerable().Sum(x => x.Field<Decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                //sb.Append(" </tr> ");
                            }
                            sb.Append("</table>");
                            sb.Append("</div>");
                        
                    }
                    //single line user summary
                    if (dtUserSummery != null && dtUserSummery.Rows.Count > 0)
                    {
                        sb.Append(" <div style='width:1050px;'> ");
                        sb.Append(" <table style='width: 100%; border-collapse: collapse;'> ");
                        sb.Append(" <tr> ");
                        sb.Append(" <td style='font-size: 16px;font-weight: bold;padding-top: 20px;padding-bottom: 8px;'><u>Single Line User Summary(only in Base Currency)</u></td> ");
                        sb.Append(" </tr> ");
                        sb.Append(" </table> ");
                        sb.Append(" </div> ");
                        sb.Append(" <div style='width:1050px;'> ");
                        sb.Append(" <table style='width: 100%; border-collapse: collapse;'> ");
                        sb.Append(" <tr> ");
                        sb.Append(" <td style='width: 10%;font-weight: bold;'>EmployeeName</td> ");
                        sb.Append(" <td style='width: 9%;border:1px solid;font-weight: bold;padding: 0.3em;text-align: right;'>GrossAmt</td>");
                        sb.Append(" <td style='width: 9%;border:1px solid;font-weight: bold;padding: 0.3em;text-align: right;'>DiscAmt</td>");
                        sb.Append(" <td style='width: 9%;border:1px solid;font-weight: bold;padding: 0.3em;text-align: right;'>NetAmt</td>");
                   
                        sb.Append(" <td style='width: 9%;border:1px solid;font-weight: bold;padding: 0.3em;text-align: right;'>Total Received</td>");
                        sb.Append(" <td style='width: 9%;border:1px solid;font-weight: bold;padding: 0.3em;text-align: right;'>S.Day Settlement</td>");
                        sb.Append(" <td style='width: 9%;border:1px solid;font-weight: bold;padding: 0.3em;text-align: right;'>B.Day Settlement</td>");
                        sb.Append(" <td style='width: 9%;border:1px solid;font-weight: bold;padding: 0.3em;text-align: right;'>Credit Sale</td>");
                        sb.Append(" <td style='width: 9%;border:1px solid;font-weight: bold;padding: 0.3em;text-align: right;'>S.Day Credit Received</td>");
                        sb.Append(" <td style='width: 9%;border:1px solid;font-weight: bold;padding: 0.3em;text-align: right;'>S.Day Cash Outstanding</td>");
                        sb.Append(" <td style='width: 9%;border:1px solid;font-weight: bold;padding: 0.3em;text-align: right;'>Client Amt Submission</td>");
                        sb.Append(" <td style='width: 9%;border:1px solid;font-weight: bold;padding: 0.3em;text-align: right;'>App Amt</td>");
                        sb.Append(" <td style='width: 9%;border:1px solid;font-weight: bold;padding: 0.3em;text-align: right;'>Client Advance Amt</td>");
                                           
                        for (int i = 0; i < dtUserSummery.Rows.Count; i++)
                        {
                            sb.Append(" <tr>");
                            sb.AppendFormat(" <td style='width: 10%;border:1px solid;padding: 0.3em;'>{0}</td>", dtUserSummery.Rows[i]["EmployeeName"].ToString());
                            sb.AppendFormat(" <td style='width: 9%;border:1px solid;padding: 0.3em;text-align: right;'>{0}</td>", Math.Round(Util.GetDecimal(dtUserSummery.Rows[i]["GrossAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            sb.AppendFormat(" <td style='width: 9%;border:1px solid;padding: 0.3em;text-align: right;'>{0}</td>", Math.Round(Util.GetDecimal(dtUserSummery.Rows[i]["DiscountAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            sb.AppendFormat(" <td style='width: 9%;border:1px solid;padding: 0.3em;text-align: right;'>{0}</td>", Math.Round(Util.GetDecimal(dtUserSummery.Rows[i]["NetAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            
                            sb.AppendFormat(" <td style='width: 9%;border:1px solid;padding: 0.3em;text-align: right;'>{0}</td>", Math.Round(Util.GetDecimal(dtUserSummery.Rows[i]["Amount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            sb.AppendFormat(" <td style='width: 9%;border:1px solid;padding: 0.3em;text-align: right;'>{0}</td>", Math.Round(Util.GetDecimal(dtUserSummery.Rows[i]["SameDaySettlement"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            sb.AppendFormat(" <td style='width: 9%;border:1px solid;padding: 0.3em;text-align: right;'>{0}</td>", Math.Round(Util.GetDecimal(dtUserSummery.Rows[i]["BackDaySettlement"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            sb.AppendFormat(" <td style='width: 9%;border:1px solid;padding: 0.3em;text-align: right;'>{0}</td>", Math.Round(Util.GetDecimal(dtUserSummery.Rows[i]["CreditSale"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            sb.AppendFormat(" <td style='width: 9%;border:1px solid;padding: 0.3em;text-align: right;'>{0}</td>", Math.Round(Util.GetDecimal(dtUserSummery.Rows[i]["CreditSaleReceiveSameDay"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            sb.AppendFormat(" <td style='width: 9%;border:1px solid;padding: 0.3em;text-align: right;'>{0}</td>", Math.Round(Util.GetDecimal(dtUserSummery.Rows[i]["SamedayOutstanding"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            sb.AppendFormat(" <td style='width: 9%;border:1px solid;padding: 0.3em;text-align: right;'>{0}</td>", Math.Round(Util.GetDecimal(dtUserSummery.Rows[i]["AmtSubmission"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            sb.AppendFormat(" <td style='width: 9%;border:1px solid;padding: 0.3em;text-align: right;'>{0}</td>", Math.Round(Util.GetDecimal(dtUserSummery.Rows[i]["AppAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            sb.AppendFormat(" <td style='width: 9%;border:1px solid;padding: 0.3em;text-align: right;'>{0}</td>", Math.Round(Util.GetDecimal(dtUserSummery.Rows[i]["ClientAdvanceAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);                         
                            sb.Append(" </tr>");
                        }
                        sb.Append("</table>");
                        sb.Append("</div>");
                        
                    }

                    //User wise Refund
                    if (dtrefund != null && dtrefund.Rows.Count > 0)
                    {
                        sb.Append(" <div style='width:1050px;'> ");
                        sb.Append(" <table style='width: 100%; border-collapse: collapse;padding-top:6px;'> ");
                        sb.Append(" <tr> ");
                        sb.Append(" <td style='font-size: 16px;font-weight: bold;padding-top: 20px;padding-bottom: 8px;'><u>User Wise Refund(Only In Base Currency)</u></td> ");
                        sb.Append("  </tr> ");
                        sb.Append(" </table> ");
                        sb.Append(" </div> ");
                        sb.Append(" <div style='width:1050px;'>");
                        sb.Append(" <table style='width: 100%; border-collapse: collapse;padding-top:6px;'> ");
                        sb.Append(" <tr> ");
                        sb.Append(" <td style='width: 14%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Payment Date/Time</td> ");
                        sb.Append(" <td style='width: 17%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Receipt No.</td> ");
                        sb.Append(" <td style='width: 14%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>MR No.</td> ");
                        sb.Append(" <td style='width: 14%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Patient Name</td> ");
                        sb.Append(" <td style='width: 17%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Visit No.</td> ");
                        sb.Append(" <td style='width: 17%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Payment Detail</td> ");
                        sb.Append(" <td style='width: 14%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Amount</td> ");
                        sb.Append(" </tr> ");
                        sb.Append(" </table> ");
                        sb.Append("</div>");                        

                        var distinctEmpID = (from DataRow dRow in dtrefund.Rows
                                             select new { Employee_ID = dRow["Employee_ID"] }).Distinct().ToList();

                        sb.Append("<div style='width:1000px;'>");
                        for (int i = 0; i < distinctEmpID.Count; i++)
                        {
                            DataTable dt2 = dtrefund.AsEnumerable().Where(s1 => s1.Field<int>("Employee_ID") == Util.GetInt(distinctEmpID[i].Employee_ID)).CopyToDataTable();

                            sb.Append("<table style='width: 100%;'>");
                            sb.Append(" <tr> ");
                            sb.Append(" <td colspan='2' style='font-size: 16px;padding-top: 10px;'>Receiver : </td> ");
                            sb.Append(" <td colspan='4' style='font-size: 16px;font-weight: bold;padding-top: 10px;'>" + Util.GetString(dt2.Rows[0]["EmployeeName"].ToString()) + "</td> ");
                            sb.Append(" </tr> ");
                            for (int s = 0; s < dt2.Rows.Count; s++)
                            {
                                sb.Append("<tr style='background-color:#ffe6e6;'> ");
                                sb.AppendFormat(" <td style='width: 14%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt2.Rows[s]["DATE"]));
                                sb.AppendFormat(" <td style='width: 17%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt2.Rows[s]["ReceiptNo"]));
                                sb.AppendFormat(" <td style='width: 14%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt2.Rows[s]["Patient_ID"]));
                                sb.AppendFormat(" <td style='width: 14%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt2.Rows[s]["PatientName"]));
                                sb.AppendFormat(" <td style='width: 17%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt2.Rows[s]["LedgerTransactionNo"]));
                                sb.AppendFormat(" <td style='width: 17%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(string.Concat(Util.GetString(dt2.Rows[s]["S_Notation"]), " ", Math.Round(Util.GetDecimal(dt2.Rows[s]["Amount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero))));
                                sb.AppendFormat(" <td style='width: 10%;text-align:right;font-weight: bold;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetDouble(dt2.Rows[s]["Amount"]));
                                sb.Append(" </tr> ");

                            }
                            sb.Append(" <tr> ");
                            sb.Append(" <td colspan='3' ></td> ");
                            sb.Append(" <td colspan='4' style='border-bottom: 2px solid;padding-top: 3px;font-size: 16px;'>Sub-total :( " + Util.GetString(dt2.Rows[0]["EmployeeName"].ToString()) + "," + Util.GetString(dt2.Rows[0]["PaymentMode"].ToString()) + ",Bill Receipts ) <span style='font-weight: bold;float: right;'>" + Math.Round(Util.GetDecimal(dt2.AsEnumerable().Sum(x => x.Field<Decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                            sb.Append(" </tr> ");
                        }
                        sb.Append("</table>");
                        sb.Append("</div>");
                    }
                    if (dt.Rows.Count > 0)
                    {
                        if (Request.Form["ReportFormat"].ToString() == "1")
                        {
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
                            Session["dtExport2Excel"] = dtDetail;
                            if (Request.Form["BaseCurrency"].ToString() == "1")
                            {
                                Session["ReportName"] = "User Wise Collection Detail(In Actual Currency)";
                            }
                            else
                            {
                                Session["ReportName"] = "User Wise Collection Detail(In Base Currency)";
                            }

                            Response.Redirect("../../common/ExportToExcel.aspx");
                        }
                    }
                    else
                    {
                        Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'>No Record Found <span><br/></center>");
                        return;
                    }
                }
                  catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
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
        StringBuilder Header = new StringBuilder();
        Header.Append(" <div style='width: 1000px;'>");
        Header.Append("<table style='width: 100%;border-collapse: collapse;font-family:Arial;margin-top: 14px;'>");
        Header.Append("<tr>");
        Header.Append("<td></td>");
        Header.Append("</tr>");
        Header.Append("</table>");
        Header.Append("</div>");

        return Header.ToString();
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
}
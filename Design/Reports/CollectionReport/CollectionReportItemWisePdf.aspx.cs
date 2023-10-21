using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_OPD_CollectionReportItemWisePdf : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs;



    int MarginLeft = 20;
    int MarginRight = 20;
    int PageWidth = 550;
    int BrowserWidth = 800;


    float HeaderHeight = 40;//207
    int XHeader = 20;//20
    int YHeader = 60;//80
    int HeaderBrowserWidth = 800;


    //Footer Property 80
    float FooterHeight = 50;
    int XFooter = 20;
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
                DataTable dtbackdatesettlement = new DataTable();
                string fromDate = Request.Form["fromDate"].ToString();
                StringBuilder sb = new StringBuilder();

                if (Request.Form["ReportType"].ToString() == "0")
                {
                    sb.Append(" Select SubcategoryName DeptName,SubCategoryID,sum(GrossAmount)GrossAmount,sum(DiscountAmt)DiscountAmt,sum(NetAmount)NetAmount,COUNT(quantity)TotalQunatity,");
                    sb.Append(" ItemName,ItemId,sum(ItemReceiveAmt)ItemReceiveAmt,sum(ClientAdvance)ClientAdvance,sum(AppAmt)AppAmt, ");
                    sb.Append(" sum(CashAmtItem)CashAmt,sum(ChequeAmtItem)ChequeAmt,sum(CardAmtItem)CardAmt,sum(DebitCardAmt)DebitCardAmt, ");
                    sb.Append(" sum(MobileWallet)MobileWallet,sum(OnlinePayment)OnlinePayment,sum(OPDAdvance)OPDAdvance,sum(ReceivedAmt)ReceivedAmt,sum(CreditSale)CreditSale ");
                    sb.Append(" from ( ");
                    sb.Append(" SELECT plo.SubcategoryName,plo.`SubCategoryID`,plo.`Amount` NetAmount,(plo.`Rate`*plo.quantity)GrossAmount,plo.`DiscountAmt`,plo.quantity,rc.ReceivedAmt, ");
                    sb.Append("  plo.`ItemId`,plo.`ItemName`, ");
                    sb.Append(" (IF(lt.`NetAmount`<>0,(plo.`Amount`*100)/lt.`NetAmount`,0)*IFNULL(rc.ReceivedAmt,0)*0.01)ItemReceiveAmt, ");
                    sb.Append(" (IF(lt.`NetAmount`<>0,(plo.`Amount`*100)/lt.`NetAmount`,0)*IFNULL(rc.CashAmt,0)*0.01)CashAmtItem, ");
                    sb.Append(" (IF(lt.`NetAmount`<>0,(plo.`Amount`*100)/lt.`NetAmount`,0)*IFNULL(rc.ChequeAmt,0)*0.01)ChequeAmtItem, ");
                    sb.Append(" (IF(lt.`NetAmount`<>0,(plo.`Amount`*100)/lt.`NetAmount`,0)*IFNULL(rc.CardAmt,0)*0.01)CardAmtItem, ");
                    sb.Append(" (IF(lt.`NetAmount`<>0,(plo.`Amount`*100)/lt.`NetAmount`,0)*IFNULL(rc.DebitCardAmt,0)*0.01)DebitCardAmt, ");
                    sb.Append(" (IF(lt.`NetAmount`<>0,(plo.`Amount`*100)/lt.`NetAmount`,0)*IFNULL(rc.MobileWallet,0)*0.01)MobileWallet, ");
                    sb.Append(" (IF(lt.`NetAmount`<>0,(plo.`Amount`*100)/lt.`NetAmount`,0)*IFNULL(rc.OnlinePayment,0)*0.01)OnlinePayment, ");
                    sb.Append(" (IF(lt.`NetAmount`<>0,(plo.`Amount`*100)/lt.`NetAmount`,0)*IFNULL(rc.OPDAdvance,0)*0.01)OPDAdvance,0 ClientAdvance,0 AppAmt, ");
                    sb.Append(" (IF(lt.`NetAmount`<>0 AND lt.IsCredit=1,(plo.`Amount`*100)/lt.`NetAmount`,0)*IFNULL(rc.ReceivedAmt,0)*0.01)CreditSale ");
                    sb.Append(" FROM f_ledgertransaction lt ");
                    sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                    sb.Append("  LEFT JOIN ");
                    sb.Append(" (SELECT r.LedgerTransactionID, ");
                    sb.Append(" SUM(r.Amount)ReceivedAmt,SUM(IF(r.`PaymentModeID`=1,r.Amount,0))CashAmt,SUM(IF(r.`PaymentModeID`=2,r.Amount,0))ChequeAmt, ");
                    sb.Append(" SUM(IF(r.`PaymentModeID`=3,r.Amount,0))CardAmt, SUM(IF(r.`PaymentModeID`=5,r.Amount,0))DebitCardAmt,  ");
                    sb.Append("  SUM(IF(r.`PaymentModeID`=10,r.Amount,0))MobileWallet,SUM(IF(r.`PaymentModeID`=6,r.Amount,0))OnlinePayment,SUM(IF(r.`PaymentModeID`=9,r.Amount,0))OPDAdvance  ");
                    sb.Append(" FROM f_receipt r ");
                    sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=r.LedgerTransactionID ");
                    sb.Append(" WHERE r.`CreatedDate`>=@fromDate AND r.CreatedDate<=@toDate AND r.IsCancel=0 AND r.`PayBy`<>'C' and ifnull(r.AppointmentID,'')='' ");
                    sb.Append(" AND lt.`Date`>=@fromDate ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND r.`CentreID` IN ({1}) ");

                    sb.Append(" GROUP BY r.LedgerTransactionID) rc ON rc.LedgerTransactionID=lt.`LedgerTransactionID` ");
                    sb.Append("  WHERE plo.date >=@fromDate AND plo.date <= @toDate  ");

                    if (Request.Form["DeptID"].ToString() != string.Empty)
                        sb.Append(" AND plo.`SubCategoryID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND plo.`CentreID` IN ({1}) ");
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    //Appointment Amount
                    sb.Append(" UNION ALL");
                    sb.Append(" SELECT rad.DeptName SubcategoryName,rad.DeptID SubCategoryID,0 NetAmount,0 GrossAmount,0 DiscountAmt,1 quantity,0 ReceivedAmt, ");
                    sb.Append("  rad.`ItemId`,rad.Investigation `ItemName`, ");
                    sb.Append(" (IF(lt.`NetAmount`<>0,(plo.`Amount`*100)/lt.`NetAmount`,IF(rad.`NetAmount`<>0,(rad.`rate`*100)/rad.`NetAmount`,0))*IFNULL(r.Amount,0)*0.01) ItemReceiveAmt, ");
                    sb.Append(" 0 CashAmtItem, ");
                    sb.Append(" 0 ChequeAmtItem, ");
                    sb.Append(" 0 CardAmtItem, ");
                    sb.Append(" 0 DebitCardAmt, ");
                    sb.Append(" 0 MobileWallet, ");
                    sb.Append(" 0 OnlinePayment, ");
                    sb.Append(" 0 OPDAdvance,0 ClientAdvance,(IF(lt.`NetAmount`<>0,(plo.`Amount`*100)/lt.`NetAmount`,IF(rad.`NetAmount`<>0,(rad.`rate`*100)/rad.`NetAmount`,0))*IFNULL(r.Amount,0)*0.01) AppAmt, ");
                    sb.Append(" 0 CreditSale ");
                    sb.Append(" FROM f_receipt r ");
                    sb.Append(" INNER JOIN  appointment_radiology_details rad on rad.AppointmentID=r.AppointmentID  and ifnull(r.AppointmentID,'')<>''  AND r.`PayBy`<>'C' ");
                    sb.Append(" Left JOIN `f_ledgertransaction` lt ON lt.`AppointmentID`=r.AppointmentID ");
                    sb.Append(" Left JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                    sb.Append(" WHERE r.`CreatedDate`>=@fromDate AND r.CreatedDate<=@toDate AND r.IsCancel=0 ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND r.`CentreID` IN ({1}) ");

                    if (Request.Form["DeptID"].ToString() != string.Empty)
                        sb.Append(" AND rad.`DeptID` IN ({0}) ");
                  
                    //Client Advance Amount
                    sb.Append(" UNION ALL");
                    sb.Append(" SELECT 'ClientAdvance' SubcategoryName,0 SubCategoryID,0 NetAmount,0 GrossAmount,0 DiscountAmt,1 quantity,0 ReceivedAmt, ");
                    sb.Append("  fpm.Panel_ID `ItemId`,fpm.company_Name `ItemName`, ");
                    sb.Append(" r.Amount ItemReceiveAmt, ");
                    sb.Append(" 0 CashAmtItem, ");
                    sb.Append(" 0 ChequeAmtItem, ");
                    sb.Append(" 0 CardAmtItem, ");
                    sb.Append(" 0 DebitCardAmt, ");
                    sb.Append(" 0 MobileWallet, ");
                    sb.Append(" 0 OnlinePayment, ");
                    sb.Append(" 0 OPDAdvance,r.Amount ClientAdvance,0 AppAmt, ");
                    sb.Append(" 0 CreditSale ");                   
                    sb.Append(" FROM f_receipt r ");
                    sb.Append(" INNER JOIN f_panel_master fpm on fpm.Panel_ID= r.`Panel_ID` and r.`CreatedDate`>=@fromDate AND r.CreatedDate<=@toDate AND r.IsCancel=0 AND r.`PayBy`='C' and ifnull(r.AppointmentID,'')='' ");                   

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND r.`CentreID` IN ({1}) ");              
                   
                    sb.Append(" )t GROUP BY ItemName ");
                    sb.Append(" ORDER BY  SubCategoryID");
                }
                else
                {
                    sb = new StringBuilder();

                }

                List<string> UserDataList = new List<string>();
                UserDataList = Request.Form["DeptID"].ToString().Split(',').ToList<string>();

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

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            //backdate settlement
                            sb = new StringBuilder();
                            sb.Append("select SUM(r.Amount)ReceivedAmt,SUM(IF(r.`PaymentModeID`=1,r.Amount,0))CashAmt,SUM(IF(r.`PaymentModeID`=2,r.Amount,0))ChequeAmt, ");
                            sb.Append(" SUM(IF(r.`PaymentModeID`=3,r.Amount,0))CardAmt, SUM(IF(r.`PaymentModeID`=5,r.Amount,0))DebitCardAmt,  ");
                            sb.Append("  SUM(IF(r.`PaymentModeID`=10,r.Amount,0))MobileWallet,SUM(IF(r.`PaymentModeID`=6,r.Amount,0))OnlinePayment,SUM(IF(r.`PaymentModeID`=9,r.Amount,0))OPDAdvance  ");
                            sb.Append(" FROM f_receipt r ");
                            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=r.LedgerTransactionID ");
                            sb.Append(" WHERE r.`CreatedDate`>=@fromDate AND r.CreatedDate<=@toDate AND r.IsCancel=0 ");
                            sb.Append(" AND lt.`Date`<@fromDate ");

                            if (Request.Form["CentreID"].ToString() != string.Empty)
                                sb.Append(" AND r.`CentreID` IN ({1}) ");
                            using (MySqlDataAdapter da1 = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", UserDataList), string.Join(",", CentreIDDataList)), con))
                            {
                                for (int i = 0; i < UserDataList.Count; i++)
                                {
                                    da1.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), UserDataList[i]);
                                }
                                for (int i = 0; i < CentreIDDataList.Count; i++)
                                {
                                    da1.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), CentreIDDataList[i]);
                                }
                                da1.SelectCommand.Parameters.AddWithValue("@fromDate", Request.Form["fromDate"].ToString());
                                da1.SelectCommand.Parameters.AddWithValue("@toDate", Request.Form["toDate"].ToString());
                                da1.Fill(dtbackdatesettlement);
                                UserDataList.Clear();
                                CentreIDDataList.Clear();
                            }
                            string Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            if (Request.Form["ReportFormat"].ToString() == "1")
                            {
                                sb = new StringBuilder();
                                sb.Append(" <div style='width:1200px;'> ");
                                sb.Append("<table style='width: 1200px;border-collapse: collapse;font-family:Arial;border: 1px solid;margin-bottom: 10px;margin-top:15px;'>");
                                sb.Append("<tr>");
                                sb.Append("<td style='width:100%; text-align: center;'>");

                                sb.Append("<span style='font-weight: bold;font-size:20px;'>Item Wise Collection Report</span><br />");

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
                                sb.Append(" <table style='width: 100%; border-collapse: collapse;padding-top:6px;'> ");
                                sb.Append(" <tr> ");
                                sb.Append(" <td style='width: 13%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>ItemName</td> ");
                                sb.Append(" <td style='width: 3%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Qty</td> ");
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Gross Amt</td> ");
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Disc Amt</td> ");
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Net Amt</td> ");

                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Cash Amt</td> ");
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Card Amt</td> ");
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Cheque Amt</td> ");
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Mobile Wallet</td> ");
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Online Payment</td> ");
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>OPD Advance</td> ");
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Client Advance</td> ");                                
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>App Amt</td> ");
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>TRec. Amt</td> ");
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>CreditSale</td> ");                                
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Cash Outs.</td> ");
                                sb.Append(" </tr> ");
                                List<getDetail> DepartmentID = new List<getDetail>();
                                var distinctDept = (from DataRow drw in dt.Rows
                                                    select new { DeptName = drw["DeptName"] }).Distinct().ToList();                            
                                for (int j = 0; j < distinctDept.Count; j++)
                                {
                                    DataTable dtitem = dt.AsEnumerable().Where(s3 => s3.Field<string>("DeptName") == Util.GetString(distinctDept[j].DeptName)).CopyToDataTable();                                  
                                    sb.Append(" <tr> ");                                  
                                    sb.Append(" <td colspan='16' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtitem.Rows[0]["DeptName"].ToString()) + "</td> ");
                                    sb.Append(" </tr> ");
                                    for (int i = 0; i < dtitem.Rows.Count; i++)
                                    {

                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td style='width: 13%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtitem.Rows[i]["ItemName"]));
                                        sb.AppendFormat(" <td style='width: 3%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtitem.Rows[i]["TotalQunatity"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtitem.Rows[i]["GrossAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtitem.Rows[i]["DiscountAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtitem.Rows[i]["NetAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtitem.Rows[i]["CashAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtitem.Rows[i]["CardAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtitem.Rows[i]["ChequeAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtitem.Rows[i]["MobileWallet"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtitem.Rows[i]["OnlinePayment"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtitem.Rows[i]["OPDAdvance"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtitem.Rows[i]["ClientAdvance"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtitem.Rows[i]["AppAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtitem.Rows[i]["ItemReceiveAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtitem.Rows[i]["CreditSale"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtitem.Rows[i]["NetAmount"]) - Util.GetDecimal(dt.Rows[i]["ItemReceiveAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                        sb.Append(" </tr> ");
                                    }                                                                       
                                }
                                var S = dt.Columns["ItemReceiveAmt"].DataType.Name.ToString();
                                sb.Append("<tr> ");
                                sb.AppendFormat(" <td style='width: 13%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", "Total:");
                                sb.AppendFormat(" <td style='width: 3%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetInt(dt.AsEnumerable().Sum(x => x.Field<Int64>("TotalQunatity"))));
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("CashAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("CardAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("ChequeAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("MobileWallet"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("OnlinePayment"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("OPDAdvance"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("ClientAdvance"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);                                
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<double>("AppAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDouble(dt.AsEnumerable().Sum(x => x.Field<double>("ItemReceiveAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("CreditSale"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))) - Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<double>("ItemReceiveAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                sb.Append(" </tr> ");


                                sb.Append("<tr> ");
                                sb.AppendFormat(" <td colspan=5  style='width: 34%;padding-top :40px;font-weight: bold;text-align: right;font-size: 14px !important;word-wrap: break-word;'>Same Date Settlementt  :</td> ");

                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;padding-top :40px;font-weight: bold;text-align: left;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("CashAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;padding-top :40px;font-weight: bold;text-align: left;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("CardAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;padding-top :40px;font-weight: bold;text-align: left;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("ChequeAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;padding-top :40px;font-weight: bold;text-align: left;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("MobileWallet"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;padding-top :40px;font-weight: bold;text-align: left;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("OnlinePayment"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;padding-top :40px;font-weight: bold;text-align: left;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("OPDAdvance"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.Append(" <td colspan=5 style='width: 30%;text-align: left;font-size: 14px !important;padding-top :40px;word-wrap: break-word;'></td>");




                                sb.Append(" </tr> ");
                                sb.Append("<tr> ");
                                sb.AppendFormat(" <td colspan=5 style='width: 34%;font-weight: bold;text-align: right;font-size: 14px !important;word-wrap: break-word;'>Back Date Settlement  :</td> ");
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-weight: bold;text-align: left;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtbackdatesettlement.Rows[0]["CashAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-weight: bold;text-align: left;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtbackdatesettlement.Rows[0]["CardAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-weight: bold;text-align: left;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtbackdatesettlement.Rows[0]["ChequeAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-weight: bold;text-align: left;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtbackdatesettlement.Rows[0]["MobileWallet"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-weight: bold;text-align: left;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtbackdatesettlement.Rows[0]["OnlinePayment"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-weight: bold;text-align: left;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtbackdatesettlement.Rows[0]["OPDAdvance"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.Append(" <td colspan=5 style='width: 30%;text-align: left;font-size: 14px !important;word-wrap: break-word;'></td>");


                                sb.Append(" </tr> ");
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
                                Session["ReportName"] = "Item Wise Collection Summary";
                                Response.Redirect("../../common/ExportToExcel.aspx");
                            }
                        }
                        else
                        {
                            Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> No Record Found<span><br/><input type='button' value='Refresh' style='cursor:pointer;font-weight:bold;' onclick='window.location.reload();'/></center>");
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
        StringBuilder Header = new StringBuilder();
        Header.Append(" <div style='width: 1000px;'>");
        Header.Append("<table style='width: 1000px;border-collapse: collapse;font-family:Arial;margin-top: 14px;'>");
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
    public class getDetail
    {
        public int DepartmentID { get; set; }
    }
}
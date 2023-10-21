using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_BusinessReport_PatientInfoPdf : System.Web.UI.Page
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
    int YHeader = 20;//80
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
                    sb = new StringBuilder();
                    sb.Append("  SELECT DATE_FORMAT(lt.date,'%d-%m-%Y')DATE,plo.LedgerTransactionNo,lt.`PName`,lt.`Age`,lt.`Gender`,lt.`Panel_ID`,lt.`PanelName`, cm.`Centre`, ");
                    sb.Append("  plo.SubcategoryName DeptName,plo.`SubCategoryID`,GROUP_CONCAT(plo.`ItemName`)ItemName,lt.DoctorName,  ");
                    sb.Append("  ROUND(SUM(plo.Rate*plo.Quantity),2) GrossAmount,ROUND(SUM(plo.DiscountAmt),2)DiscountAmt, ROUND(SUM(plo.Amount),2)NetAmount,");
                    //sb.Append("  ROUND((SUM(plo.Amount)- ifnull(rc.Amount,0)),2)NetBalance, ROUND((SUM(plo.Amount) - IFNULL(lt.Adjustment, 0)),2) DueAmt, ");
                   sb.Append("  0 CashAmt, 0 CardAmt,0 ChequeAmt, ");//ROUND(ifnull(rc.Amount,0),2) ReceivedAmt,
                    sb.Append("  0 MobileWallet,0 DebitCardAmt,0 OnlinePayment  ");

                    sb.Append("   FROM `patient_labinvestigation_opd` plo  ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`INNER JOIN centre_master cm ON cm.`CentreID` = lt.CentreID    ");
                    sb.Append(" WHERE plo.Date >=@fromDate AND plo.Date<= @toDate  ");
                    if (Request.Form["SubcategoryID"].ToString() != string.Empty)
                        sb.Append(" AND plo.`SubCategoryID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND plo.`CentreID` IN ({1}) ");

                    if (Request.Form["DuePatient"].ToString() == "1")
                    {
                        sb.Append("  AND Round(lt.NetAmount) > Round(lt.Adjustment) AND lt.IsCredit=0  ");
                    }
                    if (Request.Form["DiscountPatient"].ToString() == "1")
                    {
                        sb.Append("   AND lt.DiscountOnTotal>0   ");
                    }
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append(" GROUP BY plo.LedgerTransactionNo   order by plo.LedgerTransactionNo");


                }
                else
                {
                    sb = new StringBuilder();
                    sb.Append("  SELECT DATE_FORMAT(lt.date,'%d-%m-%Y')DATE,plo.LedgerTransactionNo,lt.`PName`,lt.`Age`,lt.`Gender`,lt.`Panel_ID`,lt.`PanelName`, cm.`Centre`, ");
                    sb.Append("  plo.SubcategoryName DeptName,plo.`SubCategoryID`,GROUP_CONCAT(plo.`ItemName`)ItemName,lt.DoctorName,  ");
                    sb.Append("  ROUND(SUM(plo.Rate*plo.Quantity),2) GrossAmount,ROUND(SUM(plo.DiscountAmt),2)DiscountAmt, ROUND(SUM(plo.Amount),2)NetAmount,");
                    //sb.Append("  ROUND((SUM(plo.Amount)- ifnull(rc.Amount,0)),2)NetBalance, ROUND((SUM(plo.Amount) - IFNULL(lt.Adjustment, 0)),2) DueAmt, ");
                    sb.Append("  0 CashAmt, 0 CardAmt,0 ChequeAmt, ");//ROUND(ifnull(rc.Amount,0),2) ReceivedAmt,
                    sb.Append("  0 MobileWallet,0 DebitCardAmt,0 OnlinePayment  ");

                    sb.Append("   FROM `patient_labinvestigation_opd` plo  ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`INNER JOIN centre_master cm ON cm.`CentreID` = lt.CentreID    ");
                    sb.Append(" WHERE plo.Date >=@fromDate AND plo.Date<= @toDate  ");
                    if (Request.Form["SubcategoryID"].ToString() != string.Empty)
                        sb.Append(" AND plo.`SubCategoryID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND plo.`CentreID` IN ({1}) ");

                    if (Request.Form["DuePatient"].ToString() == "1")
                    {
                        sb.Append("  AND Round(lt.NetAmount) > Round(lt.Adjustment) AND lt.IsCredit=0  ");
                    }
                    if (Request.Form["DiscountPatient"].ToString() == "1")
                    {
                        sb.Append("   AND lt.DiscountOnTotal>0   ");
                    }
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append("  GROUP BY plo.LedgerTransactionNo,plo.itemid  order by plo.LedgerTransactionNo");
                }
             //     System.IO.File.WriteAllText(@"D:\ITDose\Jitm\ErrorLog\PAtientInfo.txt", sb.ToString());
                List<string> UserDataList = new List<string>();
                UserDataList = Request.Form["SubcategoryID"].ToString().Trim().Split(',').ToList<string>();

                List<string> CentreIDDataList = new List<string>();
                CentreIDDataList = Request.Form["CentreID"].Trim().Split(',').ToList<string>();
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
                        da.SelectCommand.Parameters.AddWithValue("@fromDate", Request.Form["fromDate"].ToString() +" 00:00:00");
                        da.SelectCommand.Parameters.AddWithValue("@toDate", Request.Form["toDate"].ToString()  +" 23:59:59");
                        da.Fill(dt);

                        UserDataList.Clear();
                        CentreIDDataList.Clear();


                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            if (Request.Form["ReportFormat"].ToString() == "1")
                            {
                                sb = new StringBuilder();
                                sb.Append(" <div style='width:1300px;'> ");
                                sb.Append("<table style='width: 1300px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
                                if (Request.Form["ReportType"].ToString() == "0")
                                {
                                    List<getDetail> Panel_ID = new List<getDetail>();
                                    var distinctdoctor = (from DataRow drw in dt.Rows
                                                          select new { Panel_ID = drw["Panel_ID"] }).Distinct().ToList();
                                    for (int j = 0; j < distinctdoctor.Count; j++)
                                    {
                                        DataTable dtdoc = dt.AsEnumerable().Where(x => x.Field<int>("Panel_ID") == Util.GetInt(distinctdoctor[j].Panel_ID)).CopyToDataTable();
                                        sb.Append(" <tr> ");
                                        sb.Append(" <td colspan='2' style='font-size: 16px;padding-top: 10px;padding-bottom: 10px;'>PanelName : </td> ");
                                        sb.Append(" <td colspan='10' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtdoc.Rows[0]["PanelName"].ToString()) + "</td> ");
                                        sb.Append(" </tr> ");

                                        for (int i = 0; i < dtdoc.Rows.Count; i++)
                                        {
                                            sb.Append("<tr> ");
                                            sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["DATE"]));
                                            sb.AppendFormat(" <td style='width: 9%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["LedgerTransactionNo"]));
                                            sb.AppendFormat(" <td style='width: 12%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["PName"]));
                                            sb.AppendFormat(" <td style='width: 9%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Age"]));
                                            sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Gender"]));
                                            sb.AppendFormat(" <td style='width: 9%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["DoctorName"]));
                                            sb.AppendFormat(" <td style='width: 12%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Centre"]));
                                            sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["GrossAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["DiscountAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["NetAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                            sb.AppendFormat(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                          //  sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["ReceivedAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                           // sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["NetBalance"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                            sb.Append(" </tr> ");
                                        }
                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td colspan='7' style='width: 40%;border-bottom: 1px solid;font-weight: bold;padding-top: 3px;text-align:right'>Sub-total ( " + Util.GetString(dtdoc.Rows[0]["PanelName"].ToString()) + "):</td>");
                                        sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                        sb.AppendFormat(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                        //sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("ReceivedAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                       // sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("NetBalance"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                        sb.Append(" </tr> ");                                       
                                    }
                                }
                                else
                                {
                                    List<getDetail> Panel_ID = new List<getDetail>();
                                    List<getLabno> LedgerTransactionNo = new List<getLabno>();
                                    var distinctdoctor = (from DataRow drw in dt.Rows
                                                          select new { Panel_ID = drw["Panel_ID"] }).Distinct().ToList();
                                    for (int j = 0; j < distinctdoctor.Count; j++)
                                    {
                                        DataTable dtdoc = dt.AsEnumerable().Where(x => x.Field<int>("Panel_ID") == Util.GetInt(distinctdoctor[j].Panel_ID)).CopyToDataTable();
                                        sb.Append(" <tr> ");
                                        sb.Append(" <td colspan='2' style='font-size: 16px;padding-top: 10px;padding-bottom: 10px;'>PanelName : </td> ");
                                        sb.Append(" <td colspan='10' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtdoc.Rows[0]["PanelName"].ToString()) + "</td> ");
                                        sb.Append(" </tr> ");

                                        var distinctLabno = (from DataRow drlab in dtdoc.Rows
                                                             select new { LedgerTransactionNo = drlab["LedgerTransactionNo"] }).Distinct().ToList();
                                        for (int k = 0; k < distinctLabno.Count; k++)
                                        {
                                            DataTable dtlabno = dtdoc.AsEnumerable().Where(x => x.Field<string>("LedgerTransactionNo") == Util.GetString(distinctLabno[k].LedgerTransactionNo)).CopyToDataTable();
                                            var labno = "";
                                            for (int i = 0; i < dtlabno.Rows.Count; i++)
                                            {
                                                if (labno != Util.GetString(dtlabno.Rows[i]["LedgerTransactionNo"]))
                                                {
                                                    sb.Append("<tr> ");
                                                    sb.AppendFormat(" <td style='width: 8%;border-top: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtlabno.Rows[i]["DATE"]));
                                                    sb.AppendFormat(" <td style='width: 8%;border-top: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtlabno.Rows[i]["LedgerTransactionNo"]));
                                                    sb.AppendFormat(" <td style='width: 8%;border-top: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtlabno.Rows[i]["PName"]));
                                                    sb.AppendFormat(" <td style='width: 8%;border-top: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtlabno.Rows[i]["Age"]));
                                                    sb.AppendFormat(" <td style='width: 8%;border-top: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtlabno.Rows[i]["Gender"]));
                                                    sb.AppendFormat(" <td style='width: 12%;border-top: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtlabno.Rows[i]["Centre"]));
                                                    sb.AppendFormat(" <td style='width: 8%;border-top: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtlabno.Rows[i]["DoctorName"]));
                                                   
                                                    sb.AppendFormat(" <td style='width: 12%;border-top: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtlabno.Rows[i]["ItemName"]));
                                                    sb.AppendFormat(" <td style='width: 8%;border-top: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtlabno.Rows[i]["GrossAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                    sb.AppendFormat(" <td style='width: 8%;border-top: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtlabno.Rows[i]["DiscountAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                    sb.AppendFormat(" <td style='width: 8%;border-top: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtlabno.Rows[i]["NetAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                    sb.AppendFormat(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                                    sb.AppendFormat(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                                    sb.AppendFormat(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                                   
                                                   // sb.AppendFormat(" <td style='width: 8%;border-top: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtlabno.Rows[i]["ReceivedAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                    //sb.AppendFormat(" <td style='width: 8%;border-top: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtlabno.Rows[i]["NetBalance"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                    //sb.AppendFormat(" <td style='width: 8%;border-top: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtlabno.Rows[i]["DueAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                    sb.Append(" </tr> ");
                                                }
                                                else
                                                {
                                                    sb.Append("<tr> ");
                                                    sb.AppendFormat(" <td style='width: 8%;'></td>");
                                                    sb.AppendFormat(" <td style='width: 8%;'></td> ");
                                                    sb.AppendFormat(" <td style='width: 8%;'></td> ");
                                                    sb.AppendFormat(" <td style='width: 8%;'></td> ");
                                                    sb.AppendFormat(" <td style='width: 8%;'></td> ");
                                                    sb.AppendFormat(" <td style='width: 8%;'></td> ");
                                                    sb.AppendFormat(" <td style='width: 8%;'></td> ");
                                                    sb.AppendFormat(" <td style='width: 12%;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtlabno.Rows[i]["ItemName"]));
                                                    sb.AppendFormat(" <td style='width: 8%;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtlabno.Rows[i]["GrossAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                    sb.AppendFormat(" <td style='width: 8%;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtlabno.Rows[i]["DiscountAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                    sb.AppendFormat(" <td style='width: 8%;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtlabno.Rows[i]["NetAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                    sb.AppendFormat(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                                  
                                                   // sb.AppendFormat(" <td style='width: 8%;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtlabno.Rows[i]["DueAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                    sb.AppendFormat(" <td style='width: 8%;'></td> ");
                                                    sb.AppendFormat(" <td style='width: 8%;'></td> ");
                                                    sb.Append(" </tr> ");
                                                }

                                                labno = Util.GetString(dtlabno.Rows[i]["LedgerTransactionNo"]);
                                            }
                                            sb.Append("<tr> ");
                                            sb.Append(" <td colspan='8'style='width: 60%;border-bottom: 1px solid;border-top: 1px solid;font-weight: bold;padding-top: 3px;text-align:right'>Sub-total:</td>");
                                            sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;border-top: 1px solid;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtlabno.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;border-top: 1px solid;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtlabno.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;border-top: 1px solid;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtlabno.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'></td> ");
                                            sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'></td> ");
                                            sb.Append(" </tr> ");          
                                        }
                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td colspan='8' style='width: 60%;border-bottom: 1px solid;border-top: 1px solid;padding-top: 10px;font-weight: bold;padding-top: 3px;text-align:right'>Client Sub-total ( " + Util.GetString(dtdoc.Rows[0]["PanelName"].ToString()) + "):</td>");
                                        sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;padding-top: 10px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;padding-top: 10px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;padding-top: 10px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);

                                        sb.AppendFormat(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                        sb.AppendFormat(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                        sb.AppendFormat(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                       
                                        //sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;padding-top: 10px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("ReceivedAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        //sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;padding-top: 10px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("NetBalance"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                       // sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;padding-top: 10px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("DueAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);

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
                                Session["Period"] = Period;
                                Session["ReportName"] = "Patient Info Report";
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
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader, PageWidth, MakeHeader(), null);
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(headerHtml);

    }
    private string MakeHeader()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" <div style='width:1300px;'> ");
        sb.Append("<table style='width: 1300px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;'>");
        if (Request.Form["ReportType"].ToString() == "0")
        {
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Patient Info  Report(Summary)</span><br />");
        }
        else
        {
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Patient Info Report(Detail)</span><br />");
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
        sb.Append(" <div style='width:1300px;'>");
        sb.Append("<table style='width:1300px;border-top:2px solid #000;border-bottom:2px solid #000; font-family:Times New Roman;font-size:16px;'>");
        if (Request.Form["ReportType"].ToString() == "0")
        {
            sb.Append(" <tr> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Date</td> ");
            sb.Append(" <td style='width: 9%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>LabNo</td> ");
            sb.Append(" <td style='width: 12%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>PatientName</td> ");
            sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Age</td> ");
            sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Gender</td> ");

            sb.Append(" <td style='width: 9%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Doctor</td> ");
            sb.Append(" <td style='width: 11%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Centre</td> ");
            sb.Append(" <td style='width: 9%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>GrossAmt</td> ");
            sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>DiscAmt</td> ");
            sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetAmt</td> ");
            sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'></td> ");
            sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'></td> ");
            sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'></td> ");
           // sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>ReceivedAmt</td> ");
           // sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetBalance</td> ");
           // sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>DueAmt</td> ");
            sb.Append(" </tr> ");
        }
        else
        {
            sb.Append(" <tr> ");
            sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Date</td> ");
            sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>LabNo</td> ");
            sb.Append(" <td style='width: 9%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>PatientName</td> ");
            sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Age</td> ");
            sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Gender</td> ");
            sb.Append(" <td style='width: 12%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Centre</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Doctor</td> ");
           
            sb.Append(" <td style='width: 14%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>ItemName</td> ");
            sb.Append(" <td style='width: 11%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>GrossAmt</td> ");
            sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>DiscAmt</td> ");
            sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetAmt</td> ");
            sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'></td> ");
            sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'></td> ");
            sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'></td> ");
           // sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>ReceivedAmt</td> ");
            //sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetBalance</td> ");
               // sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>DueAmt</td> ");
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
    public class getLabno
    {
        public string LedgerTransactionNo { get;set; }
    }
}
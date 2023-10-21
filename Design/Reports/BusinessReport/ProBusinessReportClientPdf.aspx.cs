using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_OPD_BusinessReportClientPdf : System.Web.UI.Page
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
                    sb.Append(" SELECT '' ProID,'' ProName,lt.`PanelName`,lt.`Panel_ID` , ");
                   //  sb.Append("  SUM(plo.Rate*plo.Quantity)GrossAmount,SUM(plo.DiscountAmt)DiscountAmt,SUM(plo.Amount)NetAmount,ifnull(rc.Amount,0)Adjustment,(sum(plo.Amount)-ifnull(rc.Amount,0))DueAmt ");
                     sb.Append("  SUM(plo.Rate*plo.Quantity)GrossAmount,SUM(plo.DiscountAmt)DiscountAmt,SUM(plo.Amount)NetAmount,SUM(ifnull(lt.Adjustment,0))Adjustment,0 DueAmt ");// lt.Adjustment ,(SUM(plo.Amount)-lt.Adjustment)DueAmt//,(sum(plo.Amount)-ifnull(rc.Amount,0))DueAmt 
                  
                     sb.Append(" FROM `patient_labinvestigation_opd` plo ");
                     sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                     sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
                     sb.Append(" INNER JOIN pro_master pr ON pr.PROID=lt.PROID   ");

                     sb.Append(" Left JOIN (SELECT SUM(r.Amount)Amount, r.Panel_ID ");

                     sb.Append("  FROM f_receipt r ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=r.`LedgerTransactionID`  ");
                   

                    sb.Append(" WHERE r.Createddate >=@fromDate AND r.Createddate <= @toDate and r.Iscancel=0 ");
                     if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND r.`Panel_ID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND lt.`CentreID` IN ({1}) ");

                   


                    sb.Append(" GROUP BY r.Panel_ID  ) rc ON rc.Panel_ID=lt.Panel_ID  ");
                     sb.Append(" where plo.date >=@fromDate AND plo.date <= @toDate ");

                     if (Request.Form["ClientID"].ToString() != string.Empty)
                         sb.Append(" AND lt.`Panel_ID` IN ({0}) ");

                     if (Request.Form["CentreID"].ToString() != string.Empty)
                     sb.Append(" AND lt.`CentreID` IN ({1}) ");

                     if (Request.Form["ProID"].ToString() != string.Empty)
                        sb.AppendLine(" and lt.PROID IN ({2}) ");

                    sb.Append("    AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                     sb.Append("  GROUP BY lt.`Panel_ID` ORDER BY pr.ProName,lt.PanelName; "); 
					

    
                    // System.IO.File.WriteAllText(@"C:\ITDose\Code\Yoda_live\ErrorLog\ProReport12.txt", sb.ToString());					
                }
				else if(Request.Form["ReportType"].ToString() == "2")
				{
					
					sb = new StringBuilder();
                     sb.Append(" SELECT pr.ProName,lt.`PanelName` ,plo.`SubCategoryName`,plo.`ItemName`,COUNT(1) TestCount,SUM(plo.Amount)NetAmount  ");
                    // sb.Append("  SUM(plo.Rate*plo.Quantity)GrossAmount,SUM(plo.DiscountAmt)DiscountAmt,SUM(plo.Amount)NetAmount,ifnull(rc.Amount,0)Adjustment,(sum(plo.Amount)-ifnull(rc.Amount,0))DueAmt ");
                  
                     sb.Append(" FROM `patient_labinvestigation_opd` plo ");
                     sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                     sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
                     sb.Append(" Left JOIN pro_master pr ON pr.PROID=lt.PROID   ");

                     sb.Append(" Left JOIN (SELECT SUM(r.Amount)Amount, r.Panel_ID ");

                     sb.Append("  FROM f_receipt r ");
                     sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=r.`LedgerTransactionID`  ");
                   

                    sb.Append(" WHERE r.Createddate >=@fromDate AND r.Createddate <= @toDate and r.Iscancel=0 ");
                     if (Request.Form["ClientID"].ToString() != string.Empty)
                         sb.Append(" AND r.`Panel_ID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                         sb.Append(" AND lt.`CentreID` IN ({1}) ");

                   


                     sb.Append(" GROUP BY r.Panel_ID  ) rc ON rc.Panel_ID=lt.Panel_ID  ");
                     sb.Append(" where plo.date >=@fromDate AND plo.date <= @toDate ");

                     if (Request.Form["ClientID"].ToString() != string.Empty)
                         sb.Append(" AND lt.`Panel_ID` IN ({0}) ");

                     if (Request.Form["CentreID"].ToString() != string.Empty)
                     sb.Append(" AND lt.`CentreID` IN ({1}) ");

                     if (Request.Form["ProID"].ToString() != string.Empty)
                        sb.AppendLine(" and lt.PROID IN ({2}) ");

                    sb.Append("    AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                     sb.Append("  GROUP BY lt.`Panel_ID`,plo.`SubCategoryID`,plo.`ItemId`  ORDER BY pr.ProName,lt.PanelName; "); 
					//  System.IO.File.WriteAllText(@"C:\ITDose\Code\Yoda_live\ErrorLog\ProReport14.txt", sb.ToString());	
				}
                else
                {
                    sb = new StringBuilder();
                    sb.Append(" SELECT pr.ProID,pr.ProName,lt.`PanelName`,lt.`Panel_ID` ,lt.`LedgerTransactionID`,lt.`LedgerTransactionNo`,lt.`PName`,   ");
                    sb.Append(" lt.Age,lt.Gender,if(lt.Doctor_ID=2,'Other',lt.`DoctorName`)DocName,Date_Format(lt.Date,'%d-%m-%Y')Date, (Select Rate from f_ratelist where ItemID=itm.`ItemID` And Panel_id=78 limit 1)MrpRate, ");
                    sb.Append(" SUM(plo.Rate*plo.Quantity)GrossAmount,SUM(plo.DiscountAmt)DiscountAmt,SUM(plo.Amount)NetAmount,lt.Adjustment ,0 DueAmt ");
                    sb.Append(" FROM `patient_labinvestigation_opd` plo ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                    sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
                    sb.Append(" INNER JOIN pro_master pr ON pr.PROID=lt.PROID   ");
                    sb.Append(" INNER JOIN f_itemmaster itm ON plo.`ItemId`=itm.`ItemID`   "); 
                    if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND lt.`Panel_ID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND lt.`CentreID` IN ({1}) ");

                    if (Request.Form["ProID"].ToString() != string.Empty)
                         sb.AppendLine(" and lt.PROID IN ({2}) ");

                    sb.Append(" AND plo.date >=@fromDate AND plo.date <= @toDate   AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append("  GROUP BY lt.`LedgerTransactionID`,lt.`Panel_ID` ORDER BY pr.PROName,lt.PanelName,lt.Date; ");
              
                 ///  System.IO.File.WriteAllText(@"C:\ITDose\Code\Yoda_live\ErrorLog\ProReport13.txt", sb.ToString());
                }
               // System.IO.File.AppendAllText(@"C:\\ITDose\\ggggggg.txt", sb.ToString()); 

                List<string> UserDataList = new List<string>();
                UserDataList = Request.Form["ClientID"].ToString().Split(',').ToList<string>();

                List<string> CentreIDDataList = new List<string>();
                CentreIDDataList = Request.Form["CentreID"].Split(',').ToList<string>();

                List<string> ProIDDataList = new List<string>();
                ProIDDataList = Request.Form["ProID"].Split(',').ToList<string>();

                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", UserDataList), string.Join(",", CentreIDDataList), string.Join(",", ProIDDataList)), con))
                    {
                        for (int i = 0; i < UserDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), UserDataList[i]);
                        }
                        for (int i = 0; i < CentreIDDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), CentreIDDataList[i]);
                        }
                        for (int i = 0; i < ProIDDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@k", i), ProIDDataList[i]);
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
                                        sb.AppendFormat(" <td style='width:5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetInt(i + 1));
                                        sb.AppendFormat(" <td style='width:20%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                       // sb.AppendFormat(" <td style='width:20%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["ProName"]));
                                        sb.AppendFormat(" <td style='width:20%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["PanelName"]));
                                        sb.AppendFormat(" <td style='width:15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["GrossAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["DiscountAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["NetAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["Adjustment"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                       // sb.AppendFormat(" <td style='width:10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["DueAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                        sb.Append(" </tr> ");
                                    }
                                    sb.Append("<tr> ");
                                    sb.AppendFormat(" <td colspan='3' style='width: 25%;font-size: 18px;font-weight: bold;text-align:right '>Total:</td>");
                                    sb.AppendFormat(" <td style='border-bottom: 1px solid;width: 15%;font-size: 18px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='border-bottom: 1px solid;width:10%;font-size: 18px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='border-bottom: 1px solid;width:10%;font-size: 18px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='border-bottom: 1px solid;width:10%;font-size: 18px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("Adjustment"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width:10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                    //sb.AppendFormat(" <td style='border-bottom: 1px solid;width:10%;font-size: 18px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("DueAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);

                                    sb.Append(" </tr> ");
                                }
                                else
                                {





                                    var distinctPro = (from DataRow drw in dt.Rows
                                                       select new { PROID = drw["PROID"], PanelID = drw["Panel_ID"], ProName = drw["ProName"] }).Distinct().ToList();
                                    for (int k = 0; k < distinctPro.Count; k++)
                                    {

                                        sb.Append(" <tr> ");

                                        sb.Append(" <td colspan='10' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;'>Pro Name : " + Util.GetString(distinctPro[k].ProName) + "</td> ");
                                        sb.Append(" </tr> ");

                                        var ProData = dt.AsEnumerable().Where(s => s.Field<int>("ProID") == Util.GetInt(distinctPro[k].PROID)).ToList();

                                        var distinctPanelName = (from DataRow dRow in ProData
                                                                 where Util.GetInt(dRow["ProID"]) == Util.GetInt(distinctPro[k].PROID)
                                                                 select new { PanelID = dRow["Panel_ID"], PanelName = dRow["PanelName"] }).Distinct().ToList();

                                        for (int l = 0; l < distinctPanelName.Count; l++)
                                        {
                                            sb.Append(" <tr> ");

                                            sb.Append(" <td colspan='10' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;'>Client Name : " + Util.GetString(distinctPanelName[l].PanelName) + "</td> ");
                                            sb.Append(" </tr> ");
                                           

                                            DataTable dtdoc = dt.AsEnumerable().Where(x => x.Field<int>("ProID") == Util.GetInt(distinctPro[k].PROID) && x.Field<int>("Panel_ID") == Util.GetInt(distinctPanelName[l].PanelID)).CopyToDataTable();

                                            

                                            for (int i = 0; i < dtdoc.Rows.Count; i++)
                                            {
                                                //if (Util.GetDecimal(dtdoc.Rows[i]["DueAmt"]) < 0)
                                                //    sb.Append("<tr style='background-color:#ffe6e6;'> ");
                                                //else
                                                    sb.Append("<tr> ");
                                                sb.AppendFormat(" <td style='width:5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetInt(i + 1));
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Date"]));
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["PName"]));
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["LedgerTransactionNo"]));
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Age"]));
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Gender"]));
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["DocName"]));
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["GrossAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["MrpRate"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["DiscountAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["NetAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["Adjustment"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td>");
                                               // sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["DueAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);

                                                sb.Append(" </tr> ");
                                            }
                                            sb.Append("<tr> ");
                                            sb.AppendFormat(" <td colspan='7' style='width:60%;font-size: 18px;padding-top: 10px;font-weight: bold;text-align:right; '>Client Total:</td>");
                                            sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Where(x => x.Field<int>("ProID") == Util.GetInt(distinctPro[k].PROID) && x.Field<int>("Panel_ID") == Util.GetInt(distinctPro[k].PanelID)).Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Where(x => x.Field<int>("ProID") == Util.GetInt(distinctPro[k].PROID) && x.Field<int>("Panel_ID") == Util.GetInt(distinctPro[k].PanelID)).Sum(x => x.Field<decimal>("MrpRate"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Where(x => x.Field<int>("ProID") == Util.GetInt(distinctPro[k].PROID) && x.Field<int>("Panel_ID") == Util.GetInt(distinctPro[k].PanelID)).Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Where(x => x.Field<int>("ProID") == Util.GetInt(distinctPro[k].PROID) && x.Field<int>("Panel_ID") == Util.GetInt(distinctPro[k].PanelID)).Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Where(x => x.Field<int>("ProID") == Util.GetInt(distinctPro[k].PROID) && x.Field<int>("Panel_ID") == Util.GetInt(distinctPro[k].PanelID)).Sum(x => x.Field<decimal>("Adjustment"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                           // sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Where(x => x.Field<int>("ProID") == Util.GetInt(distinctPro[k].PROID) && x.Field<int>("Panel_ID") == Util.GetInt(distinctPro[k].PanelID)).Sum(x => x.Field<decimal>("DueAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                            sb.Append(" </tr> ");
                                        }
                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td colspan='7' style='width:60%;font-size: 18px;padding-top: 10px;font-weight: bold;text-align:right; '>Pro Total:</td>");
                                        sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(x => x.Field<int>("ProID") == Util.GetInt(distinctPro[k].PROID)).Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(x => x.Field<int>("ProID") == Util.GetInt(distinctPro[k].PROID)).Sum(x => x.Field<decimal>("MrpRate"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(x => x.Field<int>("ProID") == Util.GetInt(distinctPro[k].PROID)).Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(x => x.Field<int>("ProID") == Util.GetInt(distinctPro[k].PROID)).Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(x => x.Field<int>("ProID") == Util.GetInt(distinctPro[k].PROID)).Sum(x => x.Field<decimal>("Adjustment"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td>");
                                        //sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(x => x.Field<int>("ProID") == Util.GetInt(distinctPro[k].PROID)).Sum(x => x.Field<decimal>("DueAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    }
                                    sb.Append("<tr> ");
                                    sb.AppendFormat(" <td colspan='7' style='width:60%;font-size: 18px;padding-top: 10px;font-weight: bold;text-align:right; '>Grand Total:</td>");
                                    sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("MrpRate"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("Adjustment"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td>");
                                  //  sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("DueAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                    sb.Append(" </tr> ");
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

                                if (dt.Rows.Count > 0)
                                {
                                    if (Request.Form["ReportType"].ToString() == "0")
                                    {
                                        double sumGrossAmount = Convert.ToDouble(dt.Compute("SUM(GrossAmount)", string.Empty));
                                       
                                        double sumDiscountOnTotal = Convert.ToDouble(dt.Compute("SUM(DiscountAmt)", string.Empty));
                                        double sumNetAmount = Convert.ToDouble(dt.Compute("SUM(NetAmount)", string.Empty));
                                        double sumAdjustment = Convert.ToDouble(dt.Compute("SUM(Adjustment)", string.Empty));
                                        double sumDueAmt = Convert.ToDouble(dt.Compute("SUM(DueAmt)", string.Empty));
                                        dt.Rows.Add(0, "", "Total : ", 0, Util.GetString(sumGrossAmount), Util.GetString(sumDiscountOnTotal), Util.GetString(sumNetAmount), Util.GetString(sumAdjustment), Util.GetString(sumDueAmt));
                                    }
									else if (Request.Form["ReportType"].ToString() == "2")
                                    {
                                        double sumGrossAmount = Convert.ToDouble(dt.Compute("SUM(NetAmount)", string.Empty));
                                       
                                       
                                        dt.Rows.Add(0, "", "Total : ", 0,0, Util.GetString(sumGrossAmount));
                                    }
                                    else {

                                        double sumGrossAmount = Convert.ToDouble(dt.Compute("SUM(GrossAmount)", string.Empty));
                                     double sumMrpRate = Convert.ToDouble(dt.Compute("SUM(MrpRate)", string.Empty));
                                        double sumDiscountOnTotal = Convert.ToDouble(dt.Compute("SUM(DiscountAmt)", string.Empty));
                                        double sumNetAmount = Convert.ToDouble(dt.Compute("SUM(NetAmount)", string.Empty));
                                        double sumAdjustment = Convert.ToDouble(dt.Compute("SUM(Adjustment)", string.Empty));
                                        double sumDueAmt = Convert.ToDouble(dt.Compute("SUM(DueAmt)", string.Empty));
                                        dt.Rows.Add(0, "", "", 0, 0, "", "", "", "","", "Total ", Util.GetString(sumGrossAmount),Util.GetString(sumMrpRate), Util.GetString(sumDiscountOnTotal), Util.GetString(sumNetAmount), Util.GetString(sumAdjustment), Util.GetString(sumDueAmt));
                                    
                                    }
                                }


                                Session["dtExport2Excel"] = dt;
                                Session["ReportName"] = "Pro Wise Business Report";
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
        sb.Append(" <div style='width:1200px;'> ");
        sb.Append("<table style='width: 1200px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;'>");
        if (Request.Form["ReportType"].ToString() == "0")
        {
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Pro Wise Business Report(Summary)</span><br />");
        }
        else
        {
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Pro Wise Business Report(Detail)</span><br />");
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
            sb.Append(" <td style='width:5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Sr.No</td> ");
            sb.Append(" <td style='width:20%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'></td> ");
           // sb.Append(" <td style='width:20%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Pro Name</td> ");
            sb.Append(" <td style='width:20%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Client Name</td> ");
            sb.Append(" <td style='width:15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Gross Amt</td> ");
            sb.Append(" <td style='width:10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Disc Amt</td> ");
            sb.Append(" <td style='width:10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetAmt</td> ");

            sb.Append(" <td style='width:10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Paid Amt</td> ");
            sb.Append(" <td style='width:10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'></td> ");
           // sb.Append(" <td style='width:10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Due Amt</td> ");
         
            sb.Append(" </tr> ");          
        }
        else
        {
            sb.Append(" <tr> ");
            sb.Append(" <td style='width:5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Sr.No</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Date</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Patient Name</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>LabNo</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Age</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Gender</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Doctor Name</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Gross Amt</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Mrp Amt</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>DiscAmt</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetAmt</td> ");

            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Paid Amt</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'></td> ");
            //sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Due Amt</td> ");
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
        html1 = new PdfHtml(MarginLeft, 0, PageWidth, Content, null);
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
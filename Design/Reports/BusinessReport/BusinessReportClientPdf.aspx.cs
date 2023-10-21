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
                    sb.Append(" SELECT lt.`PanelName`,lt.`Panel_ID` ,DATE_FORMAT(plo.date,'%d/%b/%Y %I:%i%p')RegDate, ");
                    sb.Append("  SUM(plo.Rate*plo.Quantity)GrossAmount,SUM(plo.Amount)NetAmount,SUM(plo.DiscountAmt)DiscountAmt  ");//,sum(lt.Adjustment)Adjustment,sum((lt.NetAmount-lt.Adjustment))DueAmt
                  
                    sb.Append(" FROM `patient_labinvestigation_opd` plo ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");

                    if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND lt.`Panel_ID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                    sb.Append(" AND plo.`CentreID` IN ({1}) ");

                    sb.Append(" AND plo.date >=@fromDate AND plo.date <= @toDate  AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append("  GROUP BY lt.`Panel_ID` ORDER  BY  lt.`PanelName` ASC ");
              
                }
                else if (Request.Form["ReportType"].ToString() == "1")
                {
                    sb = new StringBuilder();
                    sb.Append(" SELECT DATE_FORMAT(plo.date, '%d-%b-%Y') DATE,  lt.`PanelName`,lt.`Panel_ID` ,lt.`LedgerTransactionID`,lt.`LedgerTransactionNo`, plo.`ItemName`,lt.`PName`,DATE_FORMAT(plo.date,'%d-%b-%Y %I:%i%p')RegDate,   ");
                    sb.Append(" lt.Age,lt.Gender,if(lt.Doctor_ID=2,'Other',lt.`DoctorName`)DocName,  ROUND((plo.mrp),2)mrp,");
                    sb.Append("ROUND((Rate * Quantity), 2) GrossAmount, ROUND((plo.Amount), 2) NetAmount,ROUND((plo.DiscountAmt), 2) DiscountAmt, IFNULL(ROUND(plo.mrp - plo.Amount-plo.DiscountAmt),0) TotalDiscount, IFNULL((SELECT GROUP_CONCAT(Remarks)  FROM patient_labinvestigation_opd_remarks WHERE test_id=plo.`test_id` ),'' )Remarks ");//ROUND((lt.Adjustment), 2) Adjustment,IFNULL(ROUND(lt.NetAmount - lt.Adjustment),0) DueAmt,
           
                    sb.Append(" FROM `patient_labinvestigation_opd` plo ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
  
                    if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND lt.`Panel_ID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND plo.`CentreID` IN ({1}) ");

                    sb.Append(" AND plo.date >=@fromDate AND plo.date <= @toDate  AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append(" ORDER BY  DATE,lt.LedgerTransactionNo ");
              

                }
                else
                {
                    sb = new StringBuilder();
                    sb.Append(" SELECT lt.`PanelName`,lt.`Panel_ID` ,lt.`LedgerTransactionID`,lt.`LedgerTransactionNo`,lt.`PName`,DATE_FORMAT(plo.date,'%d-%b-%Y %I:%i%p')RegDate,   ");
                    sb.Append(" lt.Age,lt.Gender,if(lt.Doctor_ID=2,'Other',lt.`DoctorName`)DocName, ");
                    sb.Append("  SUM(plo.Rate*plo.Quantity)GrossAmount,SUM(plo.Amount)NetAmount,SUM(plo.DiscountAmt)DiscountAmt, IFNULL((SELECT GROUP_CONCAT(Remarks)  FROM patient_labinvestigation_opd_remarks WHERE test_id=plo.`test_id` ),'' )Remarks ");//sum(lt.Adjustment)Adjustment, IFNULL(SUM(lt.NetAmount - lt.Adjustment), 0)DueAmt,
           
                    sb.Append(" FROM `patient_labinvestigation_opd` plo ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
  
                    if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND lt.`Panel_ID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND plo.`CentreID` IN ({1}) ");

                    sb.Append(" AND plo.date >=@fromDate AND plo.date <= @toDate  AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append("  GROUP BY lt.`LedgerTransactionID`,lt.`Panel_ID`  ORDER  BY  lt.`PanelName` ASC  ");
              

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
                                            sb.AppendFormat(" <td style='width:5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetInt(i + 1));
                                            sb.AppendFormat(" <td style='width:20%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["PanelName"]));
                                            //sb.AppendFormat(" <td style='width:20%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["RegDate"]));
                                            sb.AppendFormat(" <td style='width:15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["GrossAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["DiscountAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["NetAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td>");
                                            sb.AppendFormat(" <td style='width:15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td>");
                                            //sb.AppendFormat(" <td style='width:15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["Adjustment"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            //sb.AppendFormat(" <td style='width:15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["DueAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                            sb.Append(" </tr> ");
                                        }
                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td colspan='2' style='width: 25%;font-size: 18px;font-weight: bold;text-align:right '>Total:</td>");
                                        sb.AppendFormat(" <td style='border-bottom: 1px solid;width: 15%;font-size: 18px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='border-bottom: 1px solid;width:15%;font-size: 18px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='border-bottom: 1px solid;width:15%;font-size: 18px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td>");
                                        sb.AppendFormat(" <td style='width:15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td>");
                                      //  sb.AppendFormat(" <td style='border-bottom: 1px solid;width:15%;font-size: 18px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("Adjustment"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                       // sb.AppendFormat(" <td style='border-bottom: 1px solid;width:15%;font-size: 18px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("DueAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        
                                        sb.Append(" </tr> ");
                                    }
                                    else if (Request.Form["ReportType"].ToString() == "1")
                                    {


                                        List<getDetails> DATE = new List<getDetails>();
                                        var distin = (from DataRow drw in dt.Rows
                                                      select new { DATE = drw["DATE"] }).Distinct().ToList();
                                        for (int j = 0; j < distin.Count; j++)
                                        {
                                            DataTable dtdoc = dt.AsEnumerable().Where(x => x.Field<string>("DATE") == Util.GetString(distin[j].DATE)).CopyToDataTable();
                                            sb.Append(" <tr> ");
                                            sb.Append(" <td colspan=3 style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtdoc.Rows[0]["DATE"].ToString()) + "</td> ");
                                            sb.Append(" </tr> ");

                                            for (int i = 0; i < dtdoc.Rows.Count; i++)
                                            {
                                                //if (Util.GetDecimal(dtdoc.Rows[i]["DueAmt"]) < 0)
                                                //    sb.Append("<tr style='background-color:#ffe6e6;'> ");
                                                //else
                                                    sb.Append("<tr> ");
                                                sb.AppendFormat(" <td style='width:4%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetInt(i + 1));
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["DATE"]));
                                                sb.AppendFormat(" <td style='width:10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["PName"]));
                                                sb.AppendFormat(" <td style='width:7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["LedgerTransactionNo"]));
                                                sb.AppendFormat(" <td style='width:10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Age"]));
                                                sb.AppendFormat(" <td style='width:5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Gender"]));
                                                sb.AppendFormat(" <td style='width:12%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["ItemName"]));
                                                sb.AppendFormat(" <td style='width:10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["DocName"]));
                                                //sb.AppendFormat(" <td style='width:10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["RegDate"]));
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["mrp"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["GrossAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["DiscountAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["NetAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td>");
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td>");
                                               // sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["Adjustment"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                               // sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["DueAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);

                                                sb.Append(" </tr> ");
                                            }
                                            sb.Append("<tr> ");
                                            sb.AppendFormat(" <td colspan='8' style='width:60%;font-size: 18px;padding-top: 10px;font-weight: bold;text-align:right; '>SubTotal:</td>");
                                            sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("mrp"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td>");
                                            sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td>");
                                            //sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("Adjustment"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                           // sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("DueAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                            sb.Append(" </tr> ");
                                        }
                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td colspan='8' style='width:60%;font-size: 18px;padding-top: 10px;font-weight: bold;text-align:right; '>Grand Total:</td>");
                                        sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("mrp"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td>");
                                        sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td>");
                                        //sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("Adjustment"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                       // sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("DueAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                        sb.Append(" </tr> ");
                                    }
                                    else
                                    {
 
                                        var distinctdoctor = (from DataRow drw in dt.Rows
                                                              select new { Panel_ID = drw["Panel_ID"] }).Distinct().ToList();
                                        for (int j = 0; j < distinctdoctor.Count; j++)
                                        {
                                            DataTable dtdoc = dt.AsEnumerable().Where(x => x.Field<int>("Panel_ID") == Util.GetInt(distinctdoctor[j].Panel_ID)).CopyToDataTable();
                                            sb.Append(" <tr> ");
               
                                            sb.Append(" <td colspan='10' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;'>Client Name : " + Util.GetString(dtdoc.Rows[0]["PanelName"].ToString()) + "</td> ");
                                            sb.Append(" </tr> ");

                                            for (int i = 0; i < dtdoc.Rows.Count; i++)
                                            {
                                               // if (Util.GetDecimal(dtdoc.Rows[i]["DueAmt"]) < 0)
                                                 //   sb.Append("<tr style='background-color:#ffe6e6;'> ");
                                               // else
                                                    sb.Append("<tr> ");
                                                sb.AppendFormat(" <td style='width:5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetInt(i + 1));
                                                sb.AppendFormat(" <td style='width:15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["PName"]));
                                                sb.AppendFormat(" <td style='width:10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["LedgerTransactionNo"]));
                                                sb.AppendFormat(" <td style='width:10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Age"]));
                                                sb.AppendFormat(" <td style='width:10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Gender"]));
                                                sb.AppendFormat(" <td style='width:10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["DocName"]));
                                                //sb.AppendFormat(" <td style='width:10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["RegDate"]));
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["GrossAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["DiscountAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["NetAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                                sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                                //  sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["Adjustment"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                              //  sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["DueAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);

                                                sb.Append(" </tr> ");
                                            }
                                            sb.Append("<tr> ");
                                            sb.AppendFormat(" <td colspan='6' style='width:60%;font-size: 18px;padding-top: 10px;font-weight: bold;text-align:right; '>SubTotal:</td>");
                                            sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                            sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                            //sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("Adjustment"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            //sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("DueAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                            sb.Append(" </tr> ");
                                        }
                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td colspan='6' style='width:60%;font-size: 18px;padding-top: 10px;font-weight: bold;text-align:right; '>Grand Total:</td>");
                                        sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                        sb.AppendFormat(" <td style='width:8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                       // sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("Adjustment"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        //sb.AppendFormat(" <td style='width:8%;font-size: 18px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold; '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("DueAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


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
                                Session["dtExport2Excel"] = dt;
                                Session["ReportName"] = "Client Wise Business Report";
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
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Client Wise Business Report(Summary)</span><br />");
        }
        else if (Request.Form["ReportType"].ToString() == "1")
        {
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Client Wise Business Report(Patient Details Item Name With Date)</span><br />");
        }
        else
        {
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Client Wise Business Report(Detail)</span><br />");
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
            sb.Append(" <td style='width:20%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Client Name</td> ");
            sb.Append(" <td style='width:15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Gross Amt</td> ");
            sb.Append(" <td style='width:15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Disc Amt</td> ");
            sb.Append(" <td style='width:15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetAmt</td> ");

            sb.Append(" <td style='width:15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'></td> ");
            sb.Append(" <td style='width:15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'></td> ");
           // sb.Append(" <td style='width:15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Paid Amt</td> ");
           // sb.Append(" <td style='width:15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Due Amt</td> ");
          
         
            sb.Append(" </tr> ");          
        }
        else if(Request.Form["ReportType"].ToString() == "1")
        {
            sb.Append(" <tr> ");
            sb.Append(" <td style='width:5%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'>Sr.No</td> ");
            sb.Append(" <td style='width:7%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'>DATE</td> ");
            sb.Append(" <td style='width:10%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'>Patient Name</td> ");
            sb.Append(" <td style='width:7%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'>LabNo</td> ");
            sb.Append(" <td style='width:7%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'>Age</td> ");
            sb.Append(" <td style='width:5%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'>Gender</td> ");
            sb.Append(" <td style='width:10%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'>Item Name</td> ");
            sb.Append(" <td style='width:9%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'>Doctor Name</td> ");
            //sb.Append(" <td style='width:10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Regdate</td> ");
            sb.Append(" <td style='width:7%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'>Mrp Amt</td> ");
            sb.Append(" <td style='width:7%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'>Gross Amt</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'>DiscAmt</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'>NetAmt</td> ");

            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'></td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'></td> ");
           // sb.Append(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'>Paid Amt</td> ");
           // sb.Append(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'>Due Amt</td> ");
            sb.Append(" </tr> ");
        }
        else
        {
            sb.Append(" <tr> ");
            sb.Append(" <td style='width:5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Sr.No</td> ");
            sb.Append(" <td style='width:15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Patient Name</td> ");
            sb.Append(" <td style='width:10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>LabNo</td> ");
            sb.Append(" <td style='width:10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Age</td> ");
            sb.Append(" <td style='width:10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Gender</td> ");
            sb.Append(" <td style='width:10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Doctor Name</td> ");
            //sb.Append(" <td style='width:10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Regdate</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Gross Amt</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>DiscAmt</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetAmt</td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'></td> ");
            sb.Append(" <td style='width:8%;font-weight: bold;font-size: 14px !important;word-wrap: break-word;'></td> ");
           // sb.Append(" <td style='width:8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Paid Amt</td> ");
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
    public class getDetails
    {
        public string DATE { get; set; }
    }
    
}
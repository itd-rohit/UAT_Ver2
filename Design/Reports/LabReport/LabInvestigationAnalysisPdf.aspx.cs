using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_LabReport_LabInvestigationAnalysisPdf : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;

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
    string CentreName = "";
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
                StringBuilder sb = new StringBuilder();

                if (Request.Form["ReportType"].ToString() == "Summary")
                {

                    sb.Append(" select plo.ItemID,UPPER(plo.ItemName)ItemName, ");
                    sb.Append(" plo.SubcategoryName ,plo.SubCategoryID,COUNT(1)LabCount,  ");
                    sb.Append(" Round(sum(plo.Rate*plo.`Quantity`),2) GrossAmount,Round(sum(plo.DiscountAmt),2) DiscountAmount,Round(sum(plo.Amount),2) NetAmount,ROUND(SUM(plo.`MRP`* plo.`Quantity`),2 )MRP ");//avinash 16-12-2022
                    sb.Append(" from patient_labinvestigation_opd  plo ");
                    sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                    sb.Append(" where plo.`IsActive`=1 AND plo.IsReporting = '1'  AND plo.isRefund=0 ");
                    
                    if (Request.Form["DateType"].ToString() == "plo.ApprovedDate")
                    {
                       sb.Append(" and plo.ApprovedDate>='"+Request.Form["fromDate"].ToString()+"' and plo.ApprovedDate<='"+Request.Form["todate"].ToString()+"' ");
                    }
                    else if (Request.Form["DateType"].ToString() == "plo.ResultEnteredDate")
                    {
                       sb.Append(" and plo.ResultEnteredDate>='"+Request.Form["fromDate"].ToString()+"' and plo.ResultEnteredDate<='"+Request.Form["todate"].ToString()+"' ");
                    }
                    else if (Request.Form["DateType"].ToString() == "lt.Date")
                    {
                       sb.Append(" and lt.Date>='"+Request.Form["fromDate"].ToString()+"' and lt.Date<='"+Request.Form["todate"].ToString()+"' ");
                    }
                    else
                    {
                       sb.Append(" and plo.Date>='"+Request.Form["fromDate"].ToString()+"' and plo.Date<='"+Request.Form["todate"].ToString()+"' "); 
                    }

                  
                    if (Request.Form["CentreID"].ToString() != string.Empty)
                    {
                       sb.Append(" and plo.CentreID in ("+Request.Form["CentreID"].ToString()+")  ");
                    }
                    if (Request.Form["TestCentreID"].ToString() != string.Empty)
                    {
                        sb.Append(" and plo.TestCentreID in (" + Request.Form["TestCentreID"].ToString() + ")  ");
                    }
                    if (Request.Form["PanelID"].ToString() != string.Empty)
                    {
                        sb.Append(" and lt.Panel_ID in ("+Request.Form["PanelID"].ToString()+")  ");
                    }
                    if (Request.Form["SubcategoryID"].ToString() != string.Empty)
                    {
                        sb.Append(" and plo.SubCategoryID in ("+Request.Form["SubCategoryID"].ToString()+")  ");
                    }
                    if (Request.Form["DateType"].ToString() == "plo.ResultEnteredDate")
                    {
                       sb.Append(" and plo.Result_flag=1  ");
                    }
                    else if (Request.Form["DateType"].ToString() == "plo.ApprovedDate")
                    {
                       sb.Append(" and plo.Approved=1  ");
                    }
                    sb.Append(" and plo.Investigation_ID in (" + Request.Form["ItemID"].ToString() + ") ");
                    //sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append(" group by plo.Investigation_ID ");
                    sb.Append(" order by plo.SubcategoryName,UPPER(plo.ItemName) ");
					
                }
                else
                {
                    sb.Append("  SELECT DATE_FORMAT(plo.date ,'%d-%b-%Y')DATE,lt.`LedgerTransactionNo`,lt.`PName`,concat(lt.`Age`,'/',lt.`Gender`)Age,Round((plo.`Rate`*plo.`Quantity`),2)GrossAmount,Round(plo.`Amount`,2) NetAmount,Round(plo.`DiscountAmt`,2)DiscountAmt , ");
                    sb.Append(" Round((lt.`NetAmount`-lt.`Adjustment`),2) DueAmt,lt.`DoctorName`,lt.`PanelName`,plo.`SubCategoryID`,plo.`SubcategoryName`,plo.`ItemCode`,UPPER(plo.ItemName)ItemName,  ");
                    sb.Append(" sum(IF(plo.`IsPackage`=0,plo.Amount,0))GrossAmount,IF(plo.Result_Flag=1,'Done','Not Done') Result_Flag,plo.`Investigation_ID`,    ");
                    sb.Append(" sum(IF(plo.`IsPackage`=1,1,0))PackageCount ,  ");
                    sb.Append(" sum(IF(plo.`IsPackage`=0,1,0))LabCount  ");
                    sb.Append(" FROM `patient_labinvestigation_opd` plo "); 
                    sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
					 sb.Append(" where plo.`IsActive`=1 AND plo.IsReporting = '1' AND plo.isRefund=0   ");
                   // sb.Append(" and "+Request.Form["DateType"].ToString()+">='"+Request.Form["fromDate"].ToString()+"'  and "+Request.Form["DateType"].ToString()+"<='"+Request.Form["todate"].ToString()+"'  ");
                    if (Request.Form["DateType"].ToString() == "plo.ApprovedDate")
                    {
                       sb.Append(" and plo.ApprovedDate>='"+Request.Form["fromDate"].ToString()+"' and plo.ApprovedDate<='"+Request.Form["todate"].ToString()+"' ");
                    }
                    else if (Request.Form["DateType"].ToString() == "plo.ResultEnteredDate")
                    {
                       sb.Append(" and plo.ResultEnteredDate>='"+Request.Form["fromDate"].ToString()+"' and plo.ResultEnteredDate<='"+Request.Form["todate"].ToString()+"' ");
                    }
                    else if (Request.Form["DateType"].ToString() == "lt.Date")
                    {
                       sb.Append(" and lt.Date>='"+Request.Form["fromDate"].ToString()+"' and lt.Date<='"+Request.Form["todate"].ToString()+"' ");
                    }
                    else
                    {
                       sb.Append(" and plo.Date>='"+Request.Form["fromDate"].ToString()+"' and plo.Date<='"+Request.Form["todate"].ToString()+"' "); 
                    }
                    if (Request.Form["CentreID"].ToString() != string.Empty)
                    {
                        sb.Append(" and plo.CentreID in ("+Request.Form["CentreID"].ToString()+")  ");
                    }
                    if (Request.Form["TestCentreID"].ToString() != string.Empty)
                    {
                        sb.Append(" and plo.TestCentreID in (" + Request.Form["TestCentreID"].ToString() + ")  ");
                    }
                    if (Request.Form["PanelID"].ToString() != string.Empty)
                    {
                       sb.Append(" and lt.Panel_ID in ("+Request.Form["PanelID"].ToString()+")  ");
                    }
                    if (Request.Form["SubcategoryID"].ToString() != string.Empty)
                    {
                       sb.Append(" and plo.SubCategoryID in ("+Request.Form["SubCategoryID"].ToString()+")  ");
                    }
                    if (Request.Form["DateType"].ToString() == "plo.ResultEnteredDate")
                    {
                     sb.Append(" and plo.Result_flag=1  ");
                    }
                    else if (Request.Form["DateType"].ToString() == "plo.ApprovedDate")
                    {
                    sb.Append(" and plo.Approved=1  ");
                    }
                   sb.Append(" and plo.Investigation_ID in ("+Request.Form["ItemID"].ToString()+") ");
                  //  sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append(" GROUP BY plo.`LedgerTransactionID`,plo.`SubCategoryID`,plo.`Investigation_ID` ");
                    sb.Append("  order by SubcategoryName,ItemName ,LedgerTransactionNo ");
					//System.IO.File.WriteAllText (@"C:\ITDOSE\LiveCode\Oncquest\ErrorLog\avinash250323.txt", sb.ToString());
                }


                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                   
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString()), con))
                    {

                        da.SelectCommand.Parameters.AddWithValue("@fromDate", Request.Form["fromDate"].ToString() + "00:00:00");
                       da.SelectCommand.Parameters.AddWithValue("@toDate", Request.Form["toDate"].ToString() + "23:59:59");
                        da.SelectCommand.Parameters.AddWithValue("@DateType", Request.Form["DateType"].ToString());
                       da.SelectCommand.Parameters.AddWithValue("@CentreID", Request.Form["CentreID"].ToString());
                       da.SelectCommand.Parameters.AddWithValue("@TestCentreID", Request.Form["TestCentreID"].ToString());
                       da.SelectCommand.Parameters.AddWithValue("@PanelID", Request.Form["PanelID"].ToString());
                       da.SelectCommand.Parameters.AddWithValue("@SubCategoryID", Request.Form["SubCategoryID"].ToString());
                       da.SelectCommand.Parameters.AddWithValue("@ItemID", Request.Form["ItemID"].ToString());
                        da.Fill(dt);



                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            if (Request.Form["ReportFormat"].ToString() == "1")
                            {
                                //CentreName = string.Concat(" Centre : ", Util.GetString(Request.Form["CentreName"].ToString()));
                                sb = new StringBuilder();
                                if (Request.Form["ReportType"].ToString() == "Summary")
                                {
                                    sb.Append(" <div style='width:1000px;'>");
                                    sb.Append(" <table style='width: 100%; border-collapse: collapse;padding-top:6px;'> ");
                                    sb.Append(" <tr> ");
                                    sb.Append(" <td style='width: 30%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>ItemName</td> ");
                                    sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Lab Count</td> ");
									                                    sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>MRP</td> ");//avinash 16-12-2022
                                    sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>GrossAmount</td> ");
             sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>DiscountAmount</td> ");
             sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>NetAmount</td> ");


                                    sb.Append(" </tr> ");
                                    List<getDetail> SubCategoryID = new List<getDetail>();
                                    var distinctdoctor = (from DataRow drw in dt.Rows
                                                          select new { SubCategoryID = drw["SubCategoryID"] }).Distinct().ToList();
                                    for (int j = 0; j < distinctdoctor.Count; j++)
                                    {
                                        DataTable dtdept = dt.AsEnumerable().Where(x => x.Field<int>("SubCategoryID") == Util.GetInt(distinctdoctor[j].SubCategoryID)).CopyToDataTable();
                                        sb.Append(" <tr> ");
                                        sb.Append(" <td colspan=3 style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtdept.Rows[0]["SubcategoryName"].ToString()) + "</td> ");
                                        sb.Append(" </tr> ");
                                        for (int i = 0; i < dtdept.Rows.Count; i++)
                                        {

                                            sb.Append("<tr> ");
                                            sb.Append(" <td style='width: 40%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtdept.Rows[i]["ItemName"]) + "</td> ");
                                            sb.Append(" <td style='width: 15%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtdept.Rows[i]["LabCount"]) + "</td> ");
											                                            sb.Append(" <td style='width: 15%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtdept.Rows[i]["MRP"]) + "</td> ");//avinash 16-12-2022
                                            sb.Append(" <td style='width: 15%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtdept.Rows[i]["GrossAmount"]) + "</td> ");
sb.Append(" <td style='width: 15%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtdept.Rows[i]["DiscountAmount"]) + "</td> ");
sb.Append(" <td style='width: 15%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtdept.Rows[i]["NetAmount"]) + "</td> ");
                                            sb.Append(" </tr> ");
                                        }
                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td style='width: 40%;font-size: 16px;padding-top: 10px;font-weight: bold;text-align: right; '>{0}</td>", string.Concat("SubTotal of " + Util.GetString(dtdept.Rows[0]["SubcategoryName"]), ":"));
                                        sb.AppendFormat(" <td style='width: 15%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold '>{0}</td> ", Util.GetInt(dt.AsEnumerable().Sum(x => x.Field<Int64>("LabCount"))));
										                                        sb.AppendFormat(" <td style='width: 15%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dtdept.AsEnumerable().Sum(x => x.Field<decimal>("MRP"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);//avinash 16-12-2022
                                        sb.AppendFormat(" <td style='width: 15%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dtdept.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
 sb.AppendFormat(" <td style='width: 15%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dtdept.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
 sb.AppendFormat(" <td style='width: 15%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;padding-top: 10px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dtdept.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.Append(" </tr> ");
                                    }
                                    sb.Append("<tr> ");
                                    sb.AppendFormat(" <td style='width: 40%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;border-top: 1px solid;padding-top: 10px;font-weight: bold;text-align: right; '>Total:</td>");
                                    sb.AppendFormat(" <td style='width: 15%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;border-top: 1px solid;padding-top: 10px;font-weight: bold '>{0}</td> ", Util.GetInt(dt.AsEnumerable().Sum(x => x.Field<Int64>("LabCount"))));
									                                    sb.AppendFormat(" <td style='width: 15%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;border-top: 1px solid;padding-top: 10px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("MRP"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);//avinash 16-12-2022
                                    sb.AppendFormat(" <td style='width: 15%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;border-top: 1px solid;padding-top: 10px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
  sb.AppendFormat(" <td style='width: 15%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;border-top: 1px solid;padding-top: 10px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
  sb.AppendFormat(" <td style='width: 15%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;border-top: 1px solid;padding-top: 10px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.Append(" </tr> ");
                                    sb.Append("</table>");
                                    sb.Append("</div>");
                                }
                                else
                                {
                                    sb.Append(" <div style='width:1000px;'>");
                                    sb.Append(" <table style='width: 100%; border-collapse: collapse;padding-top:6px;'> ");
                                    sb.Append(" <tr> ");
                                    sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>DATE</td> ");
                                    sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Lab No</td> ");
                                    sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>PatientName</td> ");
                                    sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Age/Gender</td> ");
                                    sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Result</td> ");

                                    sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>GrossAmt</td> ");
                                    sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Disc</td> ");
                                    sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>NetAmt</td> ");
                                    sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Due</td> ");
                                    sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Reffered By</td> ");
                                    sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>ClientName</td> ");

                                    sb.Append(" </tr> ");
                                    List<getDetail> SubCategoryID = new List<getDetail>();
                                    List<getInvestigationID> InvestigationID = new List<getInvestigationID>();

                                    var distinctdoctor = (from DataRow drw in dt.Rows
                                                          select new { SubCategoryID = drw["SubCategoryID"] }).Distinct().ToList();
                                    for (int j = 0; j < distinctdoctor.Count; j++)
                                    {
                                        DataTable dtdept = dt.AsEnumerable().Where(x => x.Field<int>("SubCategoryID") == Util.GetInt(distinctdoctor[j].SubCategoryID)).CopyToDataTable();
                                        sb.Append(" <tr> ");
                                        sb.Append(" <td colspan=11 style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtdept.Rows[0]["SubcategoryName"].ToString()) + "</td> ");
                                        sb.Append(" </tr> ");
                                        var distinctinv = (from DataRow drw in dtdept.Rows
                                                           select new { InvestigationID = drw["Investigation_ID"] }).Distinct().ToList();
                                        for (int k = 0; k < distinctinv.Count; k++)
                                        {
                                            DataTable dtinv = dtdept.AsEnumerable().Where(x => x.Field<int>("Investigation_ID") == Util.GetInt(distinctinv[k].InvestigationID)).CopyToDataTable();
                                            sb.Append(" <tr> ");
                                            sb.Append(" <td colspan=11 style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtinv.Rows[0]["ItemName"].ToString()) + "</td> ");
                                            sb.Append(" </tr> ");

                                            for (int i = 0; i < dtinv.Rows.Count; i++)
                                            {
                                                sb.Append("<tr> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["DATE"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["LedgerTransactionNo"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["PName"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["Age"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["Result_Flag"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["GrossAmount"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["DiscountAmt"]) + "</td> ");

                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["NetAmount"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["DueAmt"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["DoctorName"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["PanelName"]) + "</td> ");
                                                sb.Append(" </tr> ");
                                            }
                                            sb.Append("<tr> ");
                                            sb.AppendFormat(" <td colspan=5 style='width: 10%;font-size: 16px;padding-top: 10px;font-weight: bold;text-align: right; '>Total :</td>");
                                            sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dtinv.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dtinv.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dtinv.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '></td> ");
                                            sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '></td> ");
                                            sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '></td> ");
                                            sb.Append(" </tr> ");
                                            sb.Append("<tr> ");
                                            sb.AppendFormat(" <td colspan=5 style='width: 10%;font-size: 16px;padding-top: 10px;font-weight: bold;text-align: right; '>{0}</td>", string.Concat("Total :"));
                                            sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '>Lab Count</td> ");
                                            sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dtinv.AsEnumerable().Sum(x => x.Field<decimal>("LabCount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '>Lab Amount</td> ");
                                            sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dtinv.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '>Package Count</td> ");
                                            sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dtinv.AsEnumerable().Sum(x => x.Field<decimal>("PackageCount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            sb.Append(" </tr> ");
                                        }
                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td colspan=5 style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 2px solid;border-top: 2px solid;font-weight: bold;text-align: right; '>{0}</td>", string.Concat("SubTotal of " + Util.GetString(dtdept.Rows[0]["SubcategoryName"]), ":"));
                                        sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 2px solid;border-top: 2px solid;font-weight: bold '>Lab Count</td> ");
                                        sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 2px solid;border-top: 2px solid;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dtdept.AsEnumerable().Sum(x => x.Field<decimal>("LabCount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 2px solid;border-top: 2px solid;font-weight: bold '>Lab Amount</td> ");
                                        sb.AppendFormat(" <td  style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 2px solid;border-top: 2px solid;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dtdept.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td  style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 2px solid;border-top: 2px solid;font-weight: bold '>Package Count</td> ");
                                        sb.AppendFormat(" <td  style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 2px solid;border-top: 2px solid;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dtdept.AsEnumerable().Sum(x => x.Field<decimal>("PackageCount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.Append(" </tr> ");
                                    }
                                    sb.Append("<tr> ");
                                    sb.AppendFormat(" <td colspan=5 style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;border-top: 1px solid;font-weight: bold;text-align: right; '>Total:</td>");
                                    sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '>Lab Count</td> ");
                                    sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;border-top: 1px solid;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("LabCount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '>Lab Amount</td> ");
                                    sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;border-top: 1px solid;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '>Package Count</td> ");
                                    sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;border-top: 1px solid;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.Append(" </tr> ");
                                    sb.Append("</table>");
                                    sb.Append("</div>");
                                }

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
                                Session["ReportName"] = "Lab Investigation Analysis Report";//Client Wise Collection Report
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

                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                Response.Write(ex.GetBaseException().ToString());
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
        sb.Append(" <div style='width:1000px;'> ");
        sb.Append("<table style='width: 1000px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;'>");
        if (Request.Form["ReportType"].ToString() == "Summary")
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Investigation Analysis Report(Summary) </span><br />");
        else
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Investigation Analysis Report(Detail) </span><br />");

        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        sb.AppendFormat(" <span style='font-size: 14px;'>{0}</span>", Period);
        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        sb.AppendFormat(" <span style='font-size: 14px;'>{0}</span>", CentreName);
        sb.Append("</td>");
        sb.Append("</tr>");
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
        public int SubCategoryID { get; set; }
    }
    public class getInvestigationID
    {
        public int InvestigationID { get; set; }
    }
}
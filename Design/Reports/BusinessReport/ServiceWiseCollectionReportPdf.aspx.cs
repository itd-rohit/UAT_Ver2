using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_BusinessReport_ServiceWiseCollectionReportPdf : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;

    int MarginLeft = 20;
    int MarginRight = 20;
    int PageWidth = 550;
    int BrowserWidth = 800;

    float HeaderHeight = 80;
    int XHeader = 20;
    int YHeader = 20;
    int HeaderBrowserWidth = 800;

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
                StringBuilder sb = new StringBuilder();
                sb = new StringBuilder();
                sb.Append("  SELECT fpm.`Panel_ID`,fpm.`Panel_Code` ClientCode,fpm.`Company_Name` ClientName,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit,lt.LedgerTransactionNo VisitNo, plo.BillNo BillNo,plo.Patient_ID UHID,lt.PName PatientName,lt.Age,");
                sb.Append(" DATE_FORMAT(plo.Date,'%d-%b-%Y %I:%i %p') BillDate,");
                sb.Append(" lt.`DoctorName` DoctorName,  ");

                sb.Append(" IF(lt.IsCredit=1,'Credit','Cash')BillingType,im.TestCode,sc.Name DepartmentName ,im.TypeName ItemName,");

                sb.Append(" lt.`PanelName`, ");

                sb.Append("  (plo.Rate*plo.Quantity) GrossAmount,plo.DiscountAmt DiscountAmt,plo.Amount NetAmt,lt.CreatedBy UserName, ");
                sb.Append(" lt.HLMOPDIPDNo ReferenceNumber,IF(lt.HLMPatientType='IPD','IP','OP') OPIPFlag,");
                sb.Append(" pm.Email MailId,pm.Mobile MobileNumber,");
                sb.Append(" IF(lt.VisitType='Home Collection','Yes','No') HomeCollection, ");
                sb.Append(" lt.`PatientIDProof`,lt.`PatientIDProofNo` ");
                sb.Append(", ( SELECT CONCAT('Refund Against VisitNo:',lt2.LedgerTransactionNo,' Date:',DATE_FORMAT(lt2.`Date`,'%d-%b-%Y %I:%i %p')) FROM opd_refund rf INNER JOIN  f_ledgertransaction lt2 ON lt2.LedgerTransactionNo = rf.old_LedgerTransactionNo WHERE rf.`new_LedgerTransactionNo`=lt.LedgerTransactionNo LIMIT 1 ) Comments ");

                sb.Append(" , IF(lt.OutstandingStatus=1 OR lt.OutstandingStatus=-1,CONCAT(OSE.Title,' ',OSE.Name,''),'') OutStandingEmployee,IF(lt.NetAmount > lt.Adjustment,'Unpaid','Paid') PaymentStatus  ");

                sb.Append("  FROM f_ledgertransaction lt ");
                sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionID=lt.LedgerTransactionID  ");
                sb.Append(" AND plo.Date>=@fromDate");
                sb.Append(" AND plo.Date<=@toDate ");
                if (Request.Form["CentreID"] != string.Empty)
                    sb.Append(" AND lt.InvoiceToPanelID IN ({0}) ");
                if (Request.Form["BillNo"] != string.Empty)
                    sb.Append("     AND plo.BillNo=@BillNo");
                sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");

                sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=plo.ItemId ");
                sb.Append(" INNER JOIN patient_master pm ON pm.patient_id=lt.patient_id  ");
                sb.Append(" INNER join `f_subcategorymaster` sc on sc.SubCategoryID=im.SubCategoryID ");
                sb.Append(" INNER JOIN centre_master cm2 ON cm2.CentreID=lt.CentreID AND cm2.`type1` != 'CC' ");
                sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`InvoiceToPanelID` ");

                sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=fpm.`TagBusinessLabID`  ");
                sb.Append(" LEFT JOIN Employee_Master OSE ON OSE.Employee_ID=lt.OutStandingEmployeeId ");

                sb.Append(" UNION ALL ");

                sb.Append("  SELECT fpm.`Panel_ID`,fpm.`Panel_Code` ClientCode,fpm.`Company_Name` ClientName,cm.CentreCode TabBusinessCode,cm.`Centre` TagBusinessUnit,lt.LedgerTransactionNo VisitNo, plo.BillNo BillNo,plo.Patient_ID UHID,lt.PName PatientName,lt.Age,");
                sb.Append(" DATE_FORMAT(plo.Date,'%d-%b-%Y %I:%i %p') BillDate ,");
                sb.Append(" lt.`DoctorName` DoctorName,  ");

                sb.Append(" IF(lt.IsCredit=1,'Credit','Cash')BillingType,im.TestCode,sc.Name DepartmentName ,im.TypeName ItemName,");

                sb.Append(" lt.`PanelName`, ");

                sb.Append(" IFNULL(plos.PCCInvoiceAmt,0) GrossAmount,0 DiscountAmt,IFNULL(plos.PCCInvoiceAmt,0) NetAmt,lt.CreatedBy UserName, ");
                sb.Append(" lt.HLMOPDIPDNo ReferenceNumber,IF(lt.HLMPatientType='IPD','IP','OP') OPIPFlag,");
                sb.Append(" pm.Email MailId,pm.Mobile MobileNumber, ");
                sb.Append(" IF(lt.VisitType='Home Collection','Yes','No') HomeCollection, ");
                sb.Append(" lt.`PatientIDProof`,lt.`PatientIDProofNo` ");
                sb.Append(", ( SELECT CONCAT('Refund Against VisitNo:',lt2.LedgerTransactionNo,' Date:',DATE_FORMAT(lt2.`Date`,'%d-%b-%Y %I:%i %p')) FROM opd_refund rf INNER JOIN  f_ledgertransaction lt2 ON lt2.LedgerTransactionNo = rf.old_LedgerTransactionNo WHERE rf.`new_LedgerTransactionNo`=lt.LedgerTransactionNo LIMIT 1 ) Comments ");

                sb.Append(" , IF(lt.OutstandingStatus=1 OR lt.OutstandingStatus=-1,CONCAT(OSE.Title,' ',OSE.Name,''),'') OutStandingEmployee,IF(lt.NetAmount > lt.Adjustment,'Unpaid','Paid') PaymentStatus  ");

                sb.Append("  FROM f_ledgertransaction lt ");
                sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionId=lt.LedgerTransactionID  ");
                sb.Append(" AND plo.Date>=@fromDate");
                sb.Append(" AND plo.Date<=@toDate ");
                if (Request.Form["CentreID"] != string.Empty)
                sb.Append(" AND lt.InvoiceToPanelID IN ({0}) ");
                if (Request.Form["BillNo"] != string.Empty)
                    sb.Append("     AND plo.BillNo=@BillNo");
                sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");

                sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=plo.ItemId ");
                sb.Append(" INNER JOIN patient_master pm ON pm.patient_id=lt.patient_id  ");
                sb.Append(" inner join `f_subcategorymaster` sc on sc.SubCategoryID=im.SubCategoryID ");
                sb.Append(" INNER JOIN centre_master cm2 ON cm2.CentreID=lt.CentreID AND cm2.`type1` = 'CC' ");
                sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`InvoiceToPanelID` ");

                sb.Append("  LEFT JOIN centre_master cm ON cm.`CentreID`=fpm.`TagBusinessLabID`  ");
                sb.Append(" LEFT JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = plo.LedgerTransactionID AND plos.ItemID=plo.ItemID    ");
                sb.Append(" LEFT JOIN Employee_Master OSE ON OSE.Employee_ID=lt.OutStandingEmployeeId ");

                sb.Append(" ORDER BY billdate ");


                List<string> UserDataList = new List<string>();
                UserDataList = Request.Form["CentreID"].ToString().Split(',').ToList<string>();
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", UserDataList)), con))
                    {
                        for (int i = 0; i < UserDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), UserDataList[i]);
                        }

                        da.SelectCommand.Parameters.AddWithValue("@fromDate", Request.Form["fromDate"].ToString());
                        da.SelectCommand.Parameters.AddWithValue("@toDate", Request.Form["toDate"].ToString());
                        if (Request.Form["BillNo"] != string.Empty)
                            da.SelectCommand.Parameters.AddWithValue("@BillNo", Request.Form["BillNo"].ToString());
                        da.Fill(dt);

                        UserDataList.Clear();

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            if (Request.Form["ReportFormat"].ToString() == "1")
                            {
                                sb = new StringBuilder();
                                sb.Append(" <div style='width:1300px;'> ");
                                sb.Append("<table style='width: 1300px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");

                                var distinctdoctor = (from DataRow drw in dt.Rows
                                                      select new { Employee_ID = drw["Panel_ID"] }).Distinct().ToList();
                                for (int j = 0; j < distinctdoctor.Count; j++)
                                {
                                    DataTable dtdoc = dt.AsEnumerable().Where(x => x.Field<int>("Panel_ID") == Util.GetInt(distinctdoctor[j].Employee_ID)).CopyToDataTable();
                                    sb.Append(" <tr> ");

                                    sb.Append(" <td colspan='15' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>Client :" + Util.GetString(dtdoc.Rows[0]["ClientName"].ToString()) + "</td> ");
                                    sb.Append(" </tr> ");

                                    for (int i = 0; i < dtdoc.Rows.Count; i++)
                                    {

                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["TagBusinessUnit"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["PatientName"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["BillDate"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["VisitNo"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["BillNo"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["UHID"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["MobileNumber"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["DoctorName"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["DepartmentName"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["ItemName"]));
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["GrossAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["DiscountAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["NetAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["PaymentStatus"]));
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["UserName"]));


                                        sb.Append(" </tr> ");
                                    }
                                    sb.Append("<tr> ");
                                    sb.Append(" <td colspan='10' style='text-align:right;font-weight: bold;' >Sub-total of " + Util.GetString(dtdoc.Rows[0]["ClientName"].ToString()) + ": </td> ");
                                    sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                    sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                    sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("NetAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                    sb.Append(" <td colspan='2' style='text-align:right' ></td> ");
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
                                Session["Period"] = Period;
                                Session["ReportName"] = "Service Wise Collection Report";
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

        sb.Append("<span style='font-weight: bold;font-size:20px;'>Service Wise Collection Report</span><br />");

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

        sb.Append(" <tr> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>TagBussiness Unit</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Patient Name</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>BillDate</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>LabNo</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>BillNo</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>UHID</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Mobile</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Doctor Name</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Dept Name</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Item Name</td> ");
        sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>GrossAmt</td> ");
        sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Disc</td> ");
        sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetAmt</td> ");
        sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Payment Status</td> ");
        sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>UserName</td> ");
        sb.Append(" </tr> ");
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
}
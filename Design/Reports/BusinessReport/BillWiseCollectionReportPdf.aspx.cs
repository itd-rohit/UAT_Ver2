using HiQPdf;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_BusinessReport_BillWiseCollectionReportPdf : System.Web.UI.Page
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
                List<ReportData> reportData = JsonConvert.DeserializeObject<List<ReportData>>(Request.Form["ReportData"]);
                DataTable dt = new DataTable();
                StringBuilder sb = new StringBuilder();
                sb = new StringBuilder();
                sb.Append("  SELECT  if(fpm.paneltype<>'Centre',fpm.paneltype,if(cm.type1='PCC',CONCAT(cm.type1,'-',cm.coco_foco),cm.type1)) BusinessType,plo.BillNo,lt.Patient_ID UHIDNo,lt.PName PatientName, ");
                sb.Append("  plo.LedgerTransactionNo VisitNo,DATE_FORMAT(plo.Date,'%d-%b-%Y') billDate,lt.DoctorName,");
                sb.Append("  cm.CentreID,cm.CentreCode TaggedLabCode,cm.Centre TaggedLabName, ");
                sb.Append("  SUM(plo.Rate*plo.Quantity) TotalAmt,SUM(plo.DiscountAmt) DiscountAmt,SUM(plo.Amount) NetAmt, ");
                sb.Append("  plo.CreatedBy UserName,IF(lt.HLMPatientType='IPD','IP','OP') OPIPFlag,pm.Email MailId,pm.Mobile MobileNumber, ");
                sb.Append("  IF(lt.IsCredit=1,SUM(plo.Amount),0) CustomerCreditAmount,IF(lt.IsCredit=0,SUM(plo.Amount),0)CustomerCashAmount, ");
                sb.Append("  lt.HLMOPDIPDNo ReferenceNumber,lt.PanelName `ClientName`,fpm.Panel_Code `ClientCode`, ");
                sb.Append("  DATE_FORMAT(plo.Date,'%d-%b-%Y %I:%i%p') CreatedDate, ");
                sb.Append("  IF(lt.VisitType='Home Collection','Yes','No') HomeCollection, ");
                sb.Append("  IF(lt.VisitType!='Home Collection','',(SELECT NAME FROM feildboy_master  WHERE `FeildboyID`=lt.`HomeVisitBoyID` LIMIT 1  )) FieldBoyName,  ");
                sb.Append("  IF(lt.Revisit=1,'Yes','No')Revisit,  ");
                sb.Append("  lt.username_web web_login_id,lt.Password_web web_login_pswd,lt.PatientSource, lt.OtherLabRefNo,lt.PreBookingID ");
                sb.Append("  FROM f_ledgertransaction lt ");
                sb.Append("   INNER JOIN `patient_labinvestigation_opd` plo ON plo.LedgerTransactionid=lt.LedgerTransactionid  ");
                sb.Append("   INNER JOIN patient_master pm ON pm.patient_id=lt.patient_id  ");
                sb.Append("   INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.panel_id  ");
                sb.Append("  INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID INNER JOIN doctor_referal dr ON dr.Doctor_ID=lt.Doctor_ID  ");
                sb.Append("  WHERE lt.Date>=@fromDate AND lt.Date<=@toDate  ");
                sb.Append("  AND lt.CentreID IN ({0}) ");
                if (reportData[0].billNo != string.Empty)
                    sb.Append("     AND lt.BillNo=@BillNo");
                sb.Append(" GROUP BY plo.BillNo ");

                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    string[] centreTags = String.Join(",", reportData[0].centreID).Split(',');
                    string[] centreParamNames = centreTags.Select(
                      (s, i) => "@tag" + i).ToArray();
                    string centreClause = string.Join(", ", centreParamNames);
                    using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), centreClause), con))
                    {
                        for (int i = 0; i < centreParamNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(centreParamNames[i], centreTags[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@BillNo", reportData[0].billNo);
                        da.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Util.GetDateTime(reportData[0].fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00"));
                        da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Util.GetDateTime(reportData[0].toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"));
                        da.Fill(dt);

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Util.GetDateTime(reportData[0].fromDate.ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(reportData[0].toDate.ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            if (reportData[0].reportformat.ToString() == "1")
                            {
                                sb = new StringBuilder();
                                sb.Append(" <div style='width:1300px;'> ");
                                sb.Append("<table style='width: 1300px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");

                                var distinctdoctor = (from DataRow drw in dt.Rows
                                                      select new { Employee_ID = drw["CentreID"] }).Distinct().ToList();
                                for (int j = 0; j < distinctdoctor.Count; j++)
                                {
                                    DataTable dtdoc = dt.AsEnumerable().Where(x => x.Field<int>("CentreID") == Util.GetInt(distinctdoctor[j].Employee_ID)).CopyToDataTable();
                                    sb.Append(" <tr> ");

                                    sb.Append(" <td colspan='15' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>TaggedLabName :" + Util.GetString(dtdoc.Rows[0]["TaggedLabName"].ToString()) + "</td> ");
                                    sb.Append(" </tr> ");

                                    for (int i = 0; i < dtdoc.Rows.Count; i++)
                                    {

                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["BusinessType"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["PatientName"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["BillDate"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["VisitNo"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["BillNo"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["UHIDNo"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["MobileNumber"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["DoctorName"]));

                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["TotalAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["DiscountAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["NetAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["CustomerCreditAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["CustomerCashAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["ClientName"]));
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Revisit"]));


                                        sb.Append(" </tr> ");
                                    }
                                    sb.Append("<tr> ");
                                    sb.Append(" <td colspan='8' style='text-align:right;font-weight: bold;' >Sub-total of " + Util.GetString(dtdoc.Rows[0]["TaggedLabName"].ToString()) + ": </td> ");
                                    sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("TotalAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                    sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                    sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("NetAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                    sb.Append(" <td colspan='4' style='text-align:right' ></td> ");
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
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>BusinessType</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Patient Name</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>BillDate</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>LabNo</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>BillNo</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>UHID</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Mobile</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Doctor Name</td> ");

        sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>TotalAmt</td> ");
        sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Disc</td> ");
        sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetAmt</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Customer CreditAmt</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Customer CashAmt</td> ");
        sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>ClientName</td> ");
        sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Revisit</td> ");
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
    public class ReportData
    {
        public string fromDate { get; set; }
        public string toDate { get; set; }
        public string billNo { get; set; }
        public string centreID { get; set; }
        public string reportName { get; set; }
        public string reportformat { get; set; }
    }
}
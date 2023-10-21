using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;


public partial class Design_Reports_BusinessReport_RefundReportPdf : System.Web.UI.Page
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
    int YHeader = 10;
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
                if (Request.Form["Reporttype"].ToString() == "0")
                {
                    sb.Append("SELECT DATE_FORMAT(lt.Date,'%d-%b-%Y %H:%s') AS RegDate,DATE_FORMAT(r.CreatedDate,'%d-%b-%Y %H:%s') AS RefundDate,lt.`LedgerTransactionNo`, ");
                    sb.Append(" r.`ReceiptNo`,lt.`PName`,lt.Age, ");
                    sb.Append(" lt.PanelName, ");
                    sb.Append(" lt.DoctorName, ");
                    sb.Append(" Round(r.`Amount`,2) AmountPaid,IF(r.PaymentModeID=1,r.`Amount`,0)AmtCash,IF(r.PaymentModeID=2,r.`Amount`,0)AmtCheque, ");
                    sb.Append(" IF(r.PaymentModeID=3,r.`Amount`,0)AmtCreditCard,r.CreatedBy AS RefundBy ");
                    sb.Append(" FROM `f_receipt` r  ");
                    sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=r.`LedgerTransactionID` ");

                    sb.Append(" WHERE  r.`IsCancel`=0  AND r.`Amount`<0 ");
                    sb.Append(" AND r.CreatedDate >= @fromDate ");
                    sb.Append(" AND r.CreatedDate <= @toDate");
                }
                else
                {
                    sb.Append("SELECT DATE_FORMAT(lt.Date,'%d-%b-%Y %H:%s') AS RegDate,DATE_FORMAT(plo.Date,'%d-%b-%Y %H:%s') AS RefundDate,lt.`LedgerTransactionNo`, ");
                    sb.Append(" plo.BillNo,lt.`PName`, lt.Age,plo.SubcategoryName,plo.ItemName,Round(plo.Amount,2)Amount, ");
                    sb.Append(" lt.PanelName, ");
                    sb.Append(" lt.DoctorName,plo.createdBy RefundBy");
                    sb.Append("  FROM `patient_labinvestigation_opd` plo  ");
                    sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");

                    sb.Append(" WHERE  plo.Amount<0 AND plo.`IsRefund`<>0 ");
                    sb.Append(" AND plo.Date >= @fromDate ");
                    sb.Append(" AND plo.Date <= @toDate");
                }

                List<string> CentreID = new List<string>();
                CentreID = Request.Form["CentreId"].ToString().Split(',').ToList<string>();

               
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", CentreID)), con))
                    {
                        for (int i = 0; i < CentreID.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), CentreID[i]);
                        }

                        da.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Request.Form["fromDate"].ToString(), " 00:00:00"));
                        da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Request.Form["toDate"].ToString(), " 23:59:59"));

                        if (Request.Form["CentreId"].ToString() != string.Empty && Request.Form["CentreId"].ToString() != "ALL")
                            da.SelectCommand.Parameters.AddWithValue("@CentreId", Request.Form["CentreId"].ToString());

                        da.Fill(dt);


                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            if (Request.Form["ReportFormat"].ToString() == "1")
                            {
                                sb = new StringBuilder();
                                sb.Append(" <div style='width:1300px;'> ");
                                sb.Append("<table style='width: 1300px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
                                if (Request.Form["Reporttype"].ToString() == "0")
                                {

                                    for (int i = 0; i < dt.Rows.Count; i++)
                                    {
                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td style='width: 3%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetInt(i + 1));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["LedgerTransactionNo"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["PName"]));
                                        sb.AppendFormat(" <td style='width: 9%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["ReceiptNo"]));
                                        sb.AppendFormat(" <td style='width: 9%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["RegDate"]));
                                        sb.AppendFormat(" <td style='width: 13%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["RefundDate"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["AmountPaid"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["AmtCash"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["AmtCheque"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["AmtCreditCard"]));
                                        sb.AppendFormat(" <td style='width: 12%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["RefundBy"]));
                                        sb.Append(" </tr> ");
                                    }
                                }
                                else
                                {
                                    for (int i = 0; i < dt.Rows.Count; i++)
                                    {
                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td style='width: 3%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetInt(i + 1));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["LedgerTransactionNo"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["PName"]));
                                        sb.AppendFormat(" <td style='width: 9%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["BillNo"]));
                                        sb.AppendFormat(" <td style='width: 9%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["SubcategoryName"]));
                                        sb.AppendFormat(" <td style='width: 13%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["ItemName"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["PanelName"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["RegDate"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["RefundDate"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["Amount"]));
                                        sb.AppendFormat(" <td style='width: 12%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["RefundBy"]));
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
                                if (Request.Form["Reporttype"].ToString() == "0")
                                {
                                    Session["ReportName"] = "Refund Report(Amount Refund)";
                                }
                                else
                                {
                                    Session["ReportName"] = "Refund Report(Test Refund)";
                                }
                               
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
        sb.Append("<table style='width: 1300px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;'>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;'>");
        if (Request.Form["Reporttype"].ToString() == "0")
        {
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Refund Report(Amount Refund)</span><br />");
        }
        else
        {
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Refund Report(Test Refund)</span><br />");
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
        if (Request.Form["Reporttype"].ToString() == "0")
        {
            sb.Append(" <tr> ");
            sb.Append(" <td style='width: 3%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>SrNo.</td> ");
            sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>LabNo</td> ");
            sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Patient Name</td> ");
            sb.Append(" <td style='width: 9%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Bill No</td> ");
            sb.Append(" <td style='width: 9%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Reg Date</td> ");
            sb.Append(" <td style='width: 13%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Refund Date</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Refund Amt</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Cash</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Cheque Amt</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Credit Card Amt</td> ");
            sb.Append(" <td style='width: 12%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Refund By</td> ");
            sb.Append(" </tr> ");
        }
        else
        {
            sb.Append(" <tr> ");
            sb.Append(" <td style='width: 3%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>SrNo.</td> ");
            sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>LabNo</td> ");
            sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Patient Name</td> ");
            sb.Append(" <td style='width: 9%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Bill No</td> ");
            sb.Append(" <td style='width: 9%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Dept Name</td> ");
            sb.Append(" <td style='width: 13%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>ItemName</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>PanelName</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Reg Date</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Refund Date</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Refund Amt</td> ");
            sb.Append(" <td style='width: 12%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Refund By</td> ");
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
}
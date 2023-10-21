using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Invoicing_CoPaymentBillPdf : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;

    int MarginLeft = 20;
    int MarginRight = 20;
    int PageWidth = 550;
    int BrowserWidth = 800;

    float HeaderHeight = 25;
    string HeaderImg = "";
    int XHeader = 20;
    int YHeader = 20;
    int HeaderBrowserWidth = 800;

    float FooterHeight = 50;
    int XFooter = 20;
    string Period = "";
    string InvoiceNo = "";
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
				
				
                sb.Append("           SELECT io.ReceiptNo InvoiceNo,pm.Panel_id, pm.`Panel_Code`,pm.`Company_Name` PanelName,CONCAT(pm.add1,'Mobile:',pm.Mobile,',Email:',pm.EmailID) Address,io.`ReceivedAmt` BalAmt,CASE WHEN io.CreditNote=0 THEN 'Receipt' WHEN io.CreditNote=1 THEN 'Credit Note' ELSE 'Debit Note' END `Header`,   ");
                sb.Append("    (SELECT CONCAT(title,NAME) FROM `employee_master` WHERE Employee_ID=io.`EntryBy`)DepositBy , DATE_FORMAT(io.EntryDate,'%d-%b-%y')DepositDate , DATE_FORMAT(io.ReceivedDate,'%d-%b-%y')InvoiceDate , io.Remarks  Period,");
                if (Util.GetString(Request.QueryString["Type"]).ToUpper() == "CREDIT NOTE" || Util.GetString(Request.QueryString["Type"]).ToUpper() == "DEBIT NOTE")
                {
                    sb.Append(" io.Remarks PaymentMode  ");
                }
                else
                {
                    sb.Append(" IF(PaymentMode='Mobile Wallet','Mobile Wallet',IF(PaymentMode='CASH','CASH',IF(PaymentMode='CHEQUE',CONCAT('CHEQUE ',IF((Bank='' OR Bank='.'),'',CONCAT(',Bank : ',bank)),', ChequeNo : ',io.ChequeNo),IF(PaymentMode='NEFT','NEFT','')))) PaymentMode  ");
                }
                sb.Append("    FROM `invoicemaster_onaccount`  io INNER JOIN f_panel_master pm ON pm.`Panel_ID`=io.`Panel_id` and io.id='" + Util.GetString(Request.QueryString["id"]) + "' AND pm.`Panel_ID`=pm.`InvoiceTo`  ");
               
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
                    {
                        da.Fill(dt);
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = "";
                            //if (Request.Form["ReportFormat"].ToString() == "1")
                            //{
                                sb = new StringBuilder();
                                string number = StockReports.ConvertAmountinword(Util.GetDouble(dt.Rows[0]["BalAmt"]));

                                if (Util.GetString(Request.QueryString["Type"]).ToUpper() == "DEBIT NOTE" || Util.GetString(Request.QueryString["Type"]).ToUpper() == "CREDIT NOTE")
                                {
                                    sb.Append(" <center> <u><span style='text-align:centre;font-weight:bold;font-size:24px;'>" + Util.GetString(Session["InvoiceType"]).ToUpper() + "<span></u><br/></center> ");
                                }
                                else
                                {

                                    // Local path //"D:\GITNew1\Uat_ver1\App_Images\itdose.png"
                                    // Live Uat Server path    //C:/ITDOSE/UAT_Ver1/App_Images/itdose.png
                                 
                                    sb.Append(" <center> ");
                                    //Local Path
                                   // sb.Append("<img  src='D:/GIT1Jun23/Uat_ver1/App_Images/itdose.png' style='text-align:Top;width: 900px; height: 150px' />");
                                   
                                    //Live Path
                                    sb.Append("<img  src='C:/ITDOSE/UAT_Ver1/App_Images/itdose.png' style='text-align:Top;width: 900px; height: 150px' />");
                                    sb.Append("  </center> ");
                                    
                                    sb.Append(" <center> <u><span style='text-align:centre;font-weight:bold;font-size:24px;'>Receipt <span></u><br/></center> ");
                                }
								
                                sb.Append(" <div style='width:1000px;border:1px solid black; ' >");
								                               
                                sb.Append("<table style='width:800px; font-family:Times New Roman;font-size:17px;'>");
                                if (Util.GetString(Request.QueryString["Type"]) == "DEBIT NOTE" || Util.GetString(Request.QueryString["Type"]).ToUpper() == "CREDIT NOTE")
                                {
									
                                    sb.Append(" <tr> ");
                                    sb.Append(" <td style='width: 50%;font-weight: bold;font-size: 17px !important;word-wrap: break-word;'>Voucher No: " + Util.GetString(dt.Rows[0]["InvoiceNo"]) + "</td> ");
                                    sb.Append(" <td style='width: 50%;font-weight: bold;font-size: 17px '>Date: " + Util.GetString(dt.Rows[0]["InvoiceDate"]) + "</td> ");

                                    sb.Append(" </tr> ");

                                    sb.Append(" <tr> ");
                                    sb.Append(" <td colspan='2' style='width: 100%;font-weight: bold;font-size: 17px !important;word-wrap: break-word;'>Client: " + Util.GetString(dt.Rows[0]["Panel_Code"]) + " : " + Util.GetString(dt.Rows[0]["PanelName"]) + "</td> ");
                                    sb.Append(" </tr> ");

                                    sb.Append(" <tr> ");
                                    sb.Append(" <td style='width: 50%;font-weight: bold;font-size: 17px !important;word-wrap: break-word;'></td> ");
                                    sb.Append(" <td style='width: 50%;font-weight: bold;font-size: 17px '>" + Util.GetString(dt.Rows[0]["Address"]) + "</td> ");

                                    sb.Append(" </tr> ");

                                    sb.Append(" <tr> ");
                                    sb.Append(" <td   colspan='2' style='width: 100%;font-weight: bold;font-size: 17px !important;word-wrap: break-word;'>a sum of Rupees: " + number + "</td> ");
                                    sb.Append(" </tr> ");
                                    sb.Append(" <tr> ");
                                    sb.Append(" <td   colspan='2' style='width: 100%;font-weight: bold;font-size: 17px !important;word-wrap: break-word;'>Received Amount: " + Util.GetString(dt.Rows[0]["BalAmt"]) + "</td> ");
                                    sb.Append(" </tr> ");
                                    sb.Append(" <tr> ");
                                    sb.Append(" <td colspan='2' style='width: 100%;font-weight: bold;font-size: 17px !important;word-wrap: break-word;'>Narration: " + Util.GetString(dt.Rows[0]["PaymentMode"]) + "</td> ");
                                    sb.Append(" </tr> ");
                                }
                                else
                                {
                                    sb.Append(" <tr> ");
                                    sb.Append(" <td style='width: 50%;font-weight: bold;font-size: 17px !important;word-wrap: break-word;'>Receipt No::&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + Util.GetString(dt.Rows[0]["InvoiceNo"]) + "</td> ");
                                    sb.Append(" <td style='width: 50%;font-weight: bold;font-size: 17px '> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date:  &nbsp;&nbsp;&nbsp;&nbsp;" + Util.GetString(dt.Rows[0]["InvoiceDate"]) + "</td> ");

                                   
                                    sb.Append(" </tr> ");
                                     
                                    sb.Append(" <tr> ");
                                    sb.Append(" <td colspan='2' style='width: 100%;font-weight: bold;font-size: 17px !important;word-wrap: break-word;'>Received from:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + Util.GetString(dt.Rows[0]["Panel_Code"]) + " : " + Util.GetString(dt.Rows[0]["PanelName"]) + "</td> ");
                                   
                                    
                                    sb.Append(" </tr> ");
                                    sb.Append(" <td style='width: 50%;font-weight: bold;font-size: 17px '>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;" + Util.GetString(dt.Rows[0]["Address"]) + "</td> ");
                                   
                                    sb.Append(" </tr> ");

                                    //sb.Append(" <tr> ");
                                    //sb.Append(" <td style='width: 30%;font-weight: bold;font-size: 17px !important;word-wrap: break-word;'></td> ");
                                    //sb.Append(" <td style='width: 50%;font-weight: bold;font-size: 17px '>" + Util.GetString(dt.Rows[0]["Address"]) + "</td> ");

                                    //sb.Append(" </tr> ");

                                    sb.Append(" <tr> ");
                                    sb.Append(" <td   colspan='2' style='width: 100%;font-weight: bold;font-size: 17px !important;word-wrap: break-word;'>a sum of Rupees: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; " + number + "</td> ");
                                    sb.Append(" </tr> ");
                                    sb.Append(" <tr> ");
                                    sb.Append(" <td   colspan='2' style='width: 100%;font-weight: bold;font-size: 17px !important;word-wrap: break-word;'>Received Amount: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;" + Util.GetString(dt.Rows[0]["BalAmt"]) + "</td> ");
                                    sb.Append(" </tr> ");
                                    sb.Append(" <tr> ");
                                    sb.Append(" <td colspan='2' style='width: 100%;font-weight: bold;font-size: 17px !important;word-wrap: break-word;'>Payment mode: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;" + Util.GetString(dt.Rows[0]["PaymentMode"]) + "</td> ");
                                    sb.Append(" </tr> ");
                                }

                                sb.Append("</table>");
                                sb.Append(" <center><span style='margin-left:500px;font-weight:bold;font-size:17px;'>--------------------------------------<span></center> ");
                                sb.Append(" <center><span style='margin-left:500px;font-weight:bold;font-size:17px;'> Signature<span><br/></center> ");
                                sb.Append(" </div> ");
                                sb.Append("<br/> <span style='margin-left:0px;color:green;font-weight:bold;font-size:17px;'> *Disclaimer: This is an electronically generated Receipt.No Signature is Required<span> ");
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
        //sb.Append(" <div style='width:1000px;'> ");
        //sb.Append("<table style='width: 1000px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
        //sb.Append("<tr>");
        //sb.Append("<td style='width:100%; text-align: center;'>");

        //sb.Append("<span style='font-weight: bold;font-size:20px;'>Bill</span><br />");

        //sb.Append("</td>");
        //sb.Append("</tr>");
        //sb.Append("<tr>");
        //sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        //sb.AppendFormat(" <span style='font-size: 14px;'>{0}</span>", Period);
        //sb.Append("</td>");
        //sb.Append("</tr>");
        //sb.Append("</table>");
        //sb.Append(" </div> ");
       
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
           // p.Footer.Layout(printdatetime);
            document.Pages.AddPage(p);
            pageno++;
        }
        tempDocument = new PdfDocument();
    }
}
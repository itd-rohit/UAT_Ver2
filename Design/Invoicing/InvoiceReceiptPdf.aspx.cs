using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HiQPdf;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Net;
using System.Drawing.Drawing2D;
using System.Diagnostics;
using System.Drawing.Printing;
using MySql.Data.MySqlClient;
using CrystalDecisions.CrystalReports.Engine;
using System.Web.Security;

public partial class Design_OPD_InvoiceReceiptPdf : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs;

    DataTable dt;

    int MarginLeft = 20;
    int MarginRight = 30;
    int PageWidth = 790;
    int BrowserWidth = 800;

    //Header Property
    float HeaderHeight = 155;
    int XHeader = 10;
    int YHeader = 33;
    int HeaderBrowserWidth = 800;
    int chkpage = 1;
    // BackGround Property
    bool HeaderImage = true;
    bool FooterImage = true;
    bool BackGroundImage = true;
    string HeaderImg = "";
    bool skip = false;
    string Period = "";
    //Footer Property 80
    float FooterHeight = 50;
    int XFooter = 20;


    int isrefundprint = 0;

    string HeadersubTitle = "";
    string IID = "";
    string PanelID = "";
    string dept = "";
    string BookingCentre = "";
    string InvoiceNo = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        InvoiceNo = Util.GetString(Request.QueryString["InvoiceNo"]);
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
        try
        {
            StringBuilder sb = new StringBuilder();
            StringBuilder sbInvoice = new StringBuilder();
            if (InvoiceNo != "" && InvoiceNo != null)
            {
                DataTable dtInvoice = InvoiceDetailReportQuery(InvoiceNo);

                decimal TotalNetAmount = Util.GetDecimal(dtInvoice.Compute("SUM(NetAmount)", ""));
                decimal TotalClientDiscount = Util.GetDecimal(dtInvoice.Compute("SUM(ClientDiscount)", ""));
                decimal TotalInvoiceAmt = Util.GetDecimal(dtInvoice.Compute("SUM(InvoiceAmt)", ""));
				decimal TotalMRP = Util.GetDecimal(dtInvoice.Compute("SUM(MRP)", ""));

                if (dtInvoice.Rows.Count > 0)
                {
                    sb.Append("<table style='font-size:10px;background-color: white;border: solid 2px black; width:750px;' border='1' rules='all' cellspacing='0'> ");
                    sb.Append("<tbody> "); 
                    for (int i = 0; i < dtInvoice.Rows.Count; i++)
                    {
                        sb.Append("<tr> ");
                        sb.Append("<td style='width:5px;'>" + Util.GetInt(i + 1) + "</td> ");
                        sb.Append("<td style='width:80px;'>" + dtInvoice.Rows[i]["Client"].ToString() + "</td> ");
                        sb.Append("<td style='width:30px;'>" + dtInvoice.Rows[i]["LabNo"].ToString() + "</td> ");
                        sb.Append("<td style='width:30px;display:none;'>" + dtInvoice.Rows[i]["SRFID"].ToString() + "</td> ");
                        sb.Append("<td style='width:50px;'>" + dtInvoice.Rows[i]["Date of Billing"].ToString() + "</td> ");
                        sb.Append("<td style='width:50px;'>" + dtInvoice.Rows[i]["PName"].ToString() + "</td> ");
                        sb.Append("<td style='width:50px;'>" + dtInvoice.Rows[i]["Age"].ToString() + "</td> ");
                        sb.Append("<td style='width:50px;'>" + dtInvoice.Rows[i]["ItemName"].ToString() + "</td> ");
						sb.Append("<td style='width:40px;'>" + dtInvoice.Rows[i]["MRP"].ToString() + "</td> ");
						sb.Append("<td style='width:50px;'>" + dtInvoice.Rows[i]["InvoiceAmt"].ToString() + "</td> ");
                        sb.Append("<td style='width:50px;'>" + dtInvoice.Rows[i]["ClientDiscount"].ToString() + "</td> ");
						sb.Append("<td style='width:50px;'>" + dtInvoice.Rows[i]["NetAmount"].ToString() + "</td> ");
                        sb.Append("</tr> ");
                    }
                    sb.Append("<tr> ");
                    sb.Append("<td colspan='7' align='right'><b style='margin-right:5px;'> Total : </b></td> ");
					sb.Append("<td style='width:50px;'><b> " + TotalMRP + "</b> </td> ");
					sb.Append("<td style='width:50px;'><b> " + TotalInvoiceAmt + "</b> </td> ");
                    sb.Append("<td style='width:50px;'><b>" + TotalClientDiscount + " </b></td> ");
					sb.Append("<td style='width:50px;'> <b>" + TotalNetAmount + " </b></td> ");
                    sb.Append("</tr> ");

                    sb.Append("</tbody></table>");
                }

            }

            AddContent(sb.ToString());
            mergeDocument();
            byte[] pdfBuffer = document.WriteToMemory();
            HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
            HttpContext.Current.Response.BinaryWrite(pdfBuffer);
            HttpContext.Current.Response.End();

        }
        catch (Exception EX)
        {
            string ac = EX.ToString();
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
    private DataTable InvoiceDetailReportQuery(string InvoiceNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.AppendLine(" SELECT (select round(rate,0) from f_ratelist where itemid=im.itemid and panel_id=78) MRP,fpm.company_name as Client, concat('*',lt.LedgerTransactionNo) LabNo,lt.SRFNo SRFID, Date_Format(lt.Date,'%d-%b-%Y') `Date of Billing` , CONCAT(pm.Title,' ',pm.PName)PName,CONCAT(pm.Age,'/',LEFT(pm.Gender,1))Age,  ");
        sb.AppendLine(" im.TypeName ItemName  ,Sum(plos.Rate * plos.Quantity) GrossAmount,(Sum(plos.Amount)-Sum(plos.Rate * plos.Quantity)) PatientDiscount,Round(Sum(plos.Amount)) NetAmount,Round(Sum(plos.PCCInvoiceAmt)-Sum(plos.Amount)) ClientDiscount,ROUND(Sum(plos.PCCInvoiceAmt))InvoiceAmt ");
        sb.AppendLine(" FROM f_ledgertransaction lt    "); 
        sb.AppendLine(" INNER JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionNo=lt.LedgerTransactionNo  ");
		sb.AppendLine(" INNER JOIN `f_itemmaster` im ON im.`ItemID`=plos.ItemID  ");
        sb.AppendLine(" INNER JOIN f_Panel_Master fpm ON fpm.panel_ID=lt.panel_ID ");
        sb.AppendLine(" INNER JOIN patient_master pm ON pm.Patient_ID = lt.Patient_ID   ");
        sb.AppendLine(" where  plos.InvoiceNo = '" + InvoiceNo + "' Group by plos.ItemID ");
        sb.AppendLine(" ORDER BY lt.LedgerTransactionNo,im.TypeName ");
        //System.IO.File.WriteAllText("F:\\ErrorLog\\InvoiceDetailReportQuery.txt", sb.ToString());
         
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        PdfPage page1 = eventParams.PdfPage;
        string Imgpath = "Design/Centre/Image/1_Header.jpg";
        page1.Layout(getPDFImage(30, 10, Imgpath));
        chkpage = eventParams.PdfPageNumber;
        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);
    }
    private PdfImage getPDFImage(float X, float Y, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Server.MapPath("~/" + SignImg));
        transparentResizedPdfImage.PreserveAspectRatio = true;
        return transparentResizedPdfImage;
    }
    private void SetHeader(PdfPage page)
    {

        int breakp = tempDocument.Pages.Count;
        page.CreateHeaderCanvas(HeaderHeight);
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader, PageWidth, MakeHeader(), null);
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(headerHtml);

        // page.Header.Layout(getPDFImageforbarcode(50, 150, drcurrent["LedgerTransactionNo"].ToString()));
    }
    private string MakeHeader()
    {
        StringBuilder headerset = new StringBuilder();
        headerset.Append("  <div></div>");
        headerset.Append(" <style type='text/css'>.auto-style1 {text-align: center;}    </style>   ");
        headerset.Append(" <table style='width: 800px; margin-top:70px;' > ");
        headerset.Append(" <tr align='centre'> ");
        headerset.Append(" <td class='auto-style1' ><strong style='text-align: center'>Invoive Detail ItemWise</strong></td> ");
        headerset.Append(" </tr> ");

        headerset.Append(" <td class='auto-style1'><strong>Invoice No : " + InvoiceNo + "</strong></td> ");
        headerset.Append(" </tr> ");
        headerset.Append(" </table> ");

        headerset.Append("<table style='font-size:10px;background-color: white;border: solid 2px black; width:752px; margin-left:12px;margin-top:16px;' border='1' rules='all' cellspacing='0' > ");
        headerset.Append("<tr style='font-family: Verdana;background-color: CaptionText;color: white;' valign='top'> ");
        headerset.Append("<th style='width:1px;' scope='col'>Sr. No.</th>  ");
        headerset.Append("<th style='width:72px;' scope='col'>Client</th>  ");
        headerset.Append("<th style='width:63px;' scope='col'>LabNo</th>  ");
        headerset.Append("<th style='width:63px;display:none;' scope='col'>SRFID</th>  ");
        headerset.Append("<th style='width:50px;' scope='col' >Date of Billing</th> ");
        headerset.Append("<th style='width:60px;' scope='col'>PName</th> ");
        headerset.Append("<th style='width:50px;' scope='col' >Age</th> ");
        headerset.Append("<th style='width:60px;' scope='col' >ItemName</th> ");
		 headerset.Append("<th style='width:80px;' scope='col' >MRP</th> ");
        headerset.Append("<th style='width:50px;' scope='col'>Invoice Amount</th> ");        
        headerset.Append("<th style='width:50px;' scope='col'>Client Discount</th> ");
		headerset.Append("<th style='width:50px;' scope='col'>Net Amount</th> ");
        headerset.Append("</tr> ");
        headerset.Append("</table> ");


        return headerset.ToString();
    }

    private void AddContent(string Content)
    {
        PdfPage page1 = tempDocument.AddPage(PdfPageSize.A4, PdfDocumentMargins.Empty, PdfPageOrientation.Portrait);
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
            System.Drawing.Font pageNumberingFont = new System.Drawing.Font(new System.Drawing.FontFamily("Arial"), 8, System.Drawing.GraphicsUnit.Point);
            PdfText pageNumberingText = new PdfText(500, FooterHeight, String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;
            PdfText printdatetime = new PdfText(350, FooterHeight, DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont);
            printdatetime.ForeColor = System.Drawing.Color.Black;
            if (p.Footer == null)
            {
                p.CreateFooterCanvas(FooterHeight);

            }
            document.Pages.AddPage(p);
            pageno++;

        }

        tempDocument = new PdfDocument();
    }
}
using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Linq;
public partial class Design_Store_StockStatusReportPDF : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs=new DataTable();
    //Page Property

    int MarginLeft = 20;
    int MarginRight = 30;
    int PageWidth = 550;
    int BrowserWidth = 800;



    //Header Property
    float HeaderHeight = 113;//207
    int XHeader = 20;//20
    int YHeader = 20;//80
    int HeaderBrowserWidth = 800;




    // BackGround Property
    bool HeaderImage = true;
    bool FooterImage = false;
    bool BackGroundImage = false;
    string HeaderImg = "";

    //Footer Property 80
    float FooterHeight = 30;
    int XFooter = 20;

    DataRow drcurrent;
    string urlpath = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        urlpath = Request.Url.Scheme + "://" + Request.Url.Host + ":" + Request.Url.Port + "/" + Request.Url.AbsolutePath.Split('/')[1] + "/";
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
        try
        {
            BindData();
            if (dtObs.Rows.Count == 0)
            {
                Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong . Please Refresh Page Or Contact To Admin..!<span><br/><input type='button' value='Refresh' style='cursor:pointer;font-weight:bold;' onclick='window.location.reload();'/></center>");
                return;
            }

            StringBuilder sb = new StringBuilder();
            sb.Append("<div style='width:800px;'>");
            sb.Append("<table style='width:800px;border-collapse:collapse;font-family:Arial;font-size:12px;' frame='box' rules='all' border='1'");
            foreach (DataRow dw in dtObs.Rows)
            {
              
                sb.Append("<tr>");
                sb.Append("<td style='width:100px; word-wrap:break-word;'>" + Util.GetString(dw["GRNType"]) + "</td>");
                sb.Append("<td style='width:80px;'>" + Util.GetString(dw["GRNNo"]) + "</td>");
                sb.Append("<td style='width:120px; '>" + Util.GetString(dw["SupplierName"]) + "</td>");
                sb.Append("<td style='width:100px;'>" + Util.GetString(dw["SupplierState"]) + "</td>");
                sb.Append("<td style='width:70px;'>" + Util.GetString(dw["Location"]) + "</td>");
                //sb.Append("<td style='width:70px;'>" + Util.GetString(dw["LocationState"]) + "</td>");
                sb.Append("<td style='width:70px;'>" + Util.GetString(dw["GrossAmount"]) + "</td>");
                sb.Append("<td style='width:70px;'>" + Util.GetString(dw["DiscountOnTotal"]) + "</td>");
                sb.Append("<td style='width:70px;'>" + Util.GetString(dw["TaxAmount"]) + "</td>");
                sb.Append("<td style='width:70px;'>" + Util.GetString(dw["NetAmount"]) + "</td>");
                sb.Append("<td style='width:70px;'>" + Util.GetString(dw["InvoiceNo"]) + "</td>");
                sb.Append("<td style='width:70px;'>" + Util.GetString(dw["PurchaseOrderNo"]) + "</td>");
                sb.Append("<td style='width:70px;'>" + Util.GetString(dw["TaxAmtIGST"]) + "</td>");
                sb.Append("<td style='width:70px;'>" + Util.GetString(dw["TaxAmtCGST"]) + "</td>");
                sb.Append("<td style='width:70px;'>" + Util.GetString(dw["TaxAmtSGST"]) + "</td>");
                sb.Append("<td style='width:70px;'>" + Util.GetString(dw["GRNDate"]) + "</td>");
                sb.Append("<td style='width:70px;'>" + Util.GetString(dw["GRNBYUser"]) + "</td>");
                //sb.Append("<td style='width:70px;'>" + Util.GetString(dw["PODnumber"]) + "</td>");

                sb.Append("</tr>");
                drcurrent = dtObs.Rows[dtObs.Rows.IndexOf(dw)];
            }
            sb.Append("</table>");
            sb.Append("</div>");
            AddContent(sb.ToString());
            mergeDocument();
            byte[] pdfBuffer = document.WriteToMemory();
            HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
            HttpContext.Current.Response.BinaryWrite(pdfBuffer);
            HttpContext.Current.Response.End();

        }
        catch (Exception ex)
        {
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong . Please Refresh Page Or Contact To Admin..!<span><br/><input type='button' value='Refresh' style='cursor:pointer;font-weight:bold;' onclick='window.location.reload();'/></center>");
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
    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        PdfPage page1 = eventParams.PdfPage;
        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);
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
    private void mergeDocument()
    {
        int pageno = 1;
        foreach (PdfPage p in tempDocument.Pages)
        {
            System.Drawing.Font pageNumberingFont = new System.Drawing.Font(new System.Drawing.FontFamily("Times New Roman"), 8, System.Drawing.GraphicsUnit.Point);
            PdfText pageNumberingText = new PdfText(PageWidth - 50, FooterHeight, String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;
            PdfText printdatetime = new PdfText(20, FooterHeight, "Print Date Time : " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont);
            printdatetime.ForeColor = System.Drawing.Color.Black;
            if (p.Footer == null)
            {
                p.CreateFooterCanvas(FooterHeight);
            }
            p.Footer.Layout(pageNumberingText);
            p.Footer.Layout(printdatetime);
            document.Pages.AddPage(p);
            pageno++;
        }
        tempDocument = new PdfDocument();
    }
    private string MakeHeader()
    {

        StringBuilder Header = new StringBuilder();
        Header.Append("<div style='width:800px;'>");
        Header.Append("<table style='width:800px;border-collapse:collapse;font-family:Arial;font-size:14px;'");
        Header.Append("<tr style='border-bottom:1px solid black;'><td colspan='4' align='center' style='border:1px solid black;font-size:17px;font-weight:bold;padding:5px;'>GRN Report</td></tr>");
        Header.Append("<tr style='border-bottom:1px solid black;'><td colspan='4' align='center' style='border:1px solid black;font-size:17px;font-weight:bold;padding:5px;'>As On :" + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + "</td></tr>");

        Header.Append("</table></div>");
        Header.Append("<br/>");
        Header.Append("<div style='width:800px;'>");
        Header.Append("<table style='width:800px;border-collapse:collapse;font-family:Arial;font-size:11px;' frame='box' rules='all' border='1'");
        Header.Append("<tr>");
        Header.Append("<td valign='top' style='font-weight:bold;width:50px;'>GRN Type</td>");
        Header.Append("<td valign='top' style='width:130px;font-weight:bold;'>GRNNo</td>");
        Header.Append("<td valign='top' style='width:120px;font-weight:bold;'>SupplierName</td>");
        Header.Append("<td valign='top' style='width:70px;font-weight:bold;'>Supplier State</td>");
        Header.Append("<td valign='top' style='width:170px;font-weight:bold;'>Location</td>");
        Header.Append("<td valign='top' style='width:50px;font-weight:bold;'>Gross Amount</td>");
        Header.Append("<td valign='top' style='width:50px;font-weight:bold;'>Discount On Total</td>");
        Header.Append("<td valign='top' style='width:40px;font-weight:bold;'>Tax Amount</td>");
        Header.Append("<td valign='top' style='width:50px;font-weight:bold;'>Net Amount</td>");
        Header.Append("<td valign='top' style='width:80px;font-weight:bold;'>Invoice No</td>");
        Header.Append("<td valign='top' style='width:120px;font-weight:bold;'>Purchase Order No</td>");
        Header.Append("<td valign='top' style='width:60px;font-weight:bold;'>Tax Amt IGST</td>");
        Header.Append("<td valign='top' style='width:55px;font-weight:bold;'>Tax Amt CGST</td>");
        Header.Append("<td valign='top' style='width:55px;font-weight:bold;'>Tax Amt SGST</td>");
        Header.Append("<td valign='top' style='width:40px;font-weight:bold;'>GRN Date</td>");
        Header.Append("<td valign='top' style='width:60px;font-weight:bold;'>GRN BY User</td>");
        //Header.Append("<td valign='top' style='width:60px;font-weight:bold;'>POD Number</td>");
        Header.Append("</tr>");
        Header.Append("</table></div>");
        return Header.ToString();
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
    private void BindData()
    {

        try
        {
            dtObs = Store_ReportQuery.GRNReport(Request.Form["FromDate"], Request.Form["ToDate"], Request.Form["LocationID"], Request.Form["AppType"], Request.Form["Type1"], Request.Form["DateFilter"], Request.Form["Status"]);
        }
        catch (Exception ex)
        {
ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}
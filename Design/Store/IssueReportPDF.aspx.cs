using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Linq;

public partial class Design_Store_IssueReportPDF : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs = new DataTable();
    //Page Property

    int MarginLeft = 20;
    int MarginRight = 30;
    int PageWidth = 550;
    int BrowserWidth = 800;



    //Header Property
    float HeaderHeight = 160;//207
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
    protected void Page_Load(object sender, EventArgs e)
    {

        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
        try
        {
            BindData();
            if (dtObs.Rows.Count == 0)
            {
                Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'>No Record Found</center>");
                return;
            }
            StringBuilder sb = new StringBuilder();
            sb.Append("<div style='width:800px;'>");
            sb.Append("<table style='width:800px;border-collapse:collapse;font-family:Arial;font-size:12px;' frame='box' rules='all' border='1'");
            foreach (DataRow dw in dtObs.Rows)
            {
                sb.Append("<td >" + Util.GetString(dw["S.No"]) + "</td>");
                sb.Append("<td tyle='word-wrap:break-word;'>" + Util.GetString(dw["IndentNo"]) + "</td>");
                sb.Append("<td tyle='word-wrap:break-word;'>" + Util.GetString(dw["FromLocation"]) + "</td>");
                sb.Append("<td tyle='word-wrap:break-word;'>" + Util.GetString(dw["FromLocationState"]) + "</td>");
                sb.Append("<td style='word-wrap:break-word;'>" + Util.GetString(dw["ToLocation"]) + "</td>");
                sb.Append("<td style='word-wrap:break-word;'>" + Util.GetString(dw["ToLocationState"]) + "</td>");
                sb.Append("<td style='word-wrap:break-word;'>" + Util.GetString(dw["itemname"]) + "</td>");
                sb.Append("<td >" + Util.GetString(dw["barcodeno"]) + "</td>");
                sb.Append("<td >" + Math.Round(Util.GetDecimal(dw["ReceiveQuantity"]), 2) + "</td>");
                sb.Append("<td >" + Math.Round(Util.GetDecimal(dw["Rate"]), 2) + "</td>");
                sb.Append("<td >" + dw["DiscountAmt"] + "</td>");
                sb.Append("<td s>" + dw["taxper"] + "</td>");
                sb.Append("<td >" + Math.Round(Util.GetDecimal(dw["ReceiveAmt"]), 2) + "</td>");
               
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

    private string MakeHeader()
    {
        string Period = string.Concat(" Period From :", Util.GetDateTime(Common.DecryptRijndael(Request.Form["fromDate"].ToString())).ToString("dd-MMM-yyyy"), " Period To :", Util.GetDateTime(Common.DecryptRijndael(Request.Form["toDate"].ToString())).ToString("dd-MMM-yyyy"));

        StringBuilder Header = new StringBuilder();
        Header.Append("<div style='width:800px;'>");
        Header.Append("<table style='width:800px;border-collapse:collapse;font-family:Arial;font-size:14px;'");
        Header.AppendFormat("<tr style='border-bottom:1px solid black;'><td colspan='4' align='center' style='border:1px solid black;font-size:17px;font-weight:bold;padding:5px;'>{0}</td></tr>", Common.DecryptRijndael(Request.Form["ReportDisplayName"].ToString()));
        Header.AppendFormat("<tr style='border-bottom:1px solid black;'><td colspan='4' align='center' style='border:1px solid black;font-size:17px;font-weight:bold;padding:5px;'>{0}</td></tr>", Period);

        Header.Append("</table></div>");
        Header.Append("<br/>");
        Header.Append("<div style='width:800px;'>");

        Header.Append("<table style='width:800px;border-collapse:collapse;font-family:Arial;font-size:12px;' frame='box' rules='all' border='1'");
        Header.Append("<tr>");
        Header.Append("<td valign='top' style='font-weight:bold;width:30px;'>S.No.</td>");
        Header.Append("<td valign='top' style='font-weight:bold;width:80px;'>IndentNo</td>");
        Header.Append("<td valign='top' style='font-weight:bold;width:80px;'>FromLocation</td>");
        Header.Append("<td valign='top' style='font-weight:bold;width:80px;'>FromLocationState</td>");
        Header.Append("<td valign='top' style='font-weight:bold;width:80px;'>ToLocation</td>");
        Header.Append("<td valign='top' style='font-weight:bold;width:80px;'>ToLocationState</td>");
        Header.Append("<td valign='top' style='font-weight:bold;width:100px;'>ItemName</td>");
        Header.Append("<td valign='top' style='font-weight:bold;width:80px;'>BarCodeNo</td>");
        Header.Append("<td valign='top' style='font-weight:bold;width:80px; text-align:right;' >ReceiveQuantity</td>");
        Header.Append("<td valign='top' style='font-weight:bold;width:80px; text-align:right;' >Rate</td>");
        Header.Append("<td valign='top' style='font-weight:bold;width:80px; text-align:right;' >DiscountAmt</td>");
        Header.Append("<td valign='top' style='font-weight:bold;width:80px; text-align:left;' >taxper</td>");
        Header.Append("<td valign='top' style='font-weight:bold;width:80px; text-align:left;' >ReceiveAmt</td>");
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
    private void BindData()
    {
        try
        {
            dtObs = Store_ReportQuery.StockIssueReport(Request.Form["Type"], Request.Form["FromDate"], Request.Form["ToDate"], Request.Form["CategoryTypeID"], Request.Form["SubCategoryTypeID"], Request.Form["SubCategoryID"], Request.Form["ItemID"], Request.Form["LocationID"], Request.Form["MachineID"], Request.Form["DateOption"], Request.Form["IssueType"], Request.Form["IndentNo"], Request.Form["IsAutoIncrement"]);
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
}
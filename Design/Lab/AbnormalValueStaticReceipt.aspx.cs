using HiQPdf;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_AbnormalValueStaticReceipt : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs;

    DataTable dt;
    int MarginLeft = 20;
    int MarginRight = 30;
    int PageWidth = 850;
    int BrowserWidth = 1050;

    //Header Property
    float HeaderHeight = 50;
    int XHeader = 20;
    int YHeader = 30;
    int HeaderBrowserWidth = 1050;
    // BackGround Property
    bool HeaderImage = true;
    bool FooterImage = true;
    bool BackGroundImage = true;
    string HeaderImg = "";

    //Footer Property 80
    float FooterHeight = 50;
    int XFooter = 20;

    string HeadersubTitle = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
        try
        {
            if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
            {
                Response.Redirect(Request.RawUrl + "?access=" + Util.getHash());
            }
            else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
            {
                Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
            }
            string cmd = Util.GetString(Request.QueryString["cmd"]);
            DataTable dtInvest = new DataTable();
            dtInvest = (DataTable)Session["ds" + cmd];
           
            if (dtInvest != null && dtInvest.Rows.Count > 0)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("<div style='width: 1050px'>");
                sb.Append("<table style='width: 1050px;border-collapse: collapse;font-family:Arial;border-bottom: 2px solid;margin-bottom: 10px;margin-top:15px;'>");
                sb.Append("<tr>");
                sb.Append("<td style='width:100%; text-align: center;'>");
                sb.Append("<span style='font-weight: bold;font-size:20px;'>Abnormal Values Statistical Report</span><br />");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("</table>");
                sb.Append("<table style='width: 1050px;border-collapse: collapse;font-family:Arial;margin-top: 20px;'>");
                sb.Append("<tr style= 'color: blue;text-align:center;'>");
                sb.Append("<td style='width: 12%;border:1px solid;padding: 0.3em;'>Sr.No</td>");
                sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;'>Reg Date</td>");
                sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;'>Lab No</td>");
                sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;'>Sample Date</td>");
                sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;'>Patient Name</td>");
                sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;'>Investigation</td>");
                sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;'>Parameter Name</td>");
                sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;'>Result</td>");
                sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;'>Min</td>");
                sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;'>Max</td>");
                sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;'>Client</td>");
                sb.Append(" </tr>");
                for (int i = 0; i < dtInvest.Rows.Count; i++)
                {
                    sb.Append(" <tr style='font-size: 10px;'>");
                    sb.Append(" <td style='width: 2%;border:1px solid;padding: 0.3em; text-align: center;'>" + (i + 1) + "</td>");
                    sb.Append(" <td style='width: 15%;border:1px solid;padding: 0.3em;text-align: right; text-align: center;'>" + dtInvest.Rows[i]["VstDate"].ToString() + "</td>");
                    sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: center;'>" + dtInvest.Rows[i]["VstDestination"].ToString() + "</td>");
                    sb.Append(" <td style='width: 20%;border:1px solid;padding: 0.3em;text-align: center;'>" + dtInvest.Rows[i]["sampledate"].ToString() + "</td>");
                    sb.Append(" <td style='width: 14%;border:1px solid;padding: 0.3em;text-align: right;'>" + dtInvest.Rows[i]["Pat_Name"].ToString() + "</td>");
                    sb.Append("<td style='width: 16%;border:1px solid;padding: 0.3em;text-align: right;'>" + dtInvest.Rows[i]["inv"].ToString() + "</td>");
                    sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: center;'>" + dtInvest.Rows[i]["ParamName"].ToString() + "</td>");
                    sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;'>" + dtInvest.Rows[i]["TrResult"].ToString() + "</td>");
                    sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;'>" + dtInvest.Rows[i]["ParamCriLow"].ToString() + "</td>");
                    sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;'>" + dtInvest.Rows[i]["ParamCriHigh"].ToString() + "</td>");
                    sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;'>" + dtInvest.Rows[i]["DocName"].ToString() + "</td>");
                    sb.Append(" </tr>");               
                }
                sb.Append(" </table>");
                sb.Append("</div>");
                //=================================================================================================================
                AddContent(sb.ToString());
                SetFooter(tempDocument.Pages[tempDocument.Pages.Count - 1]);
                mergeDocument();    
                byte[] pdfBuffer = document.WriteToMemory();
                HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
                HttpContext.Current.Response.BinaryWrite(pdfBuffer);
                HttpContext.Current.Response.End();
            } 
        }
        catch (Exception ex)
        {
          
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
        // page.Header.Layout(getPDFImageforbarcode(50, 150, drcurrent["LedgerTransactionNo"].ToString()));
    }
    private string MakeHeader()
    {
        //string headertext = "";
        //headertext = "Patient History & Investigation at-a-Glance (Delta-Check)"; 
        StringBuilder Header = new StringBuilder();
        Header.Append(" <div style='width: 1050px'>");
        Header.Append("<table style='width: 1050px;border-collapse: collapse;font-family:Arial;margin-top: 10px;'>");
        Header.Append("<tr>");
        Header.Append("<td></td>");
        Header.Append("</tr>");
        Header.Append("</table>");
        Header.Append("</div>");
        return Header.ToString();
    }
    private void SetFooter(PdfPage page)
    {
        if (page.Footer != null)
        {
        }
    }
    private void AddContent(string Content)
    {
        PdfPage page1 = tempDocument.AddPage(PdfPageSize.A3, PdfDocumentMargins.Empty);
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
            System.Drawing.Font pageNumberingFont =
            new System.Drawing.Font(new System.Drawing.FontFamily("Arial"), 8, System.Drawing.GraphicsUnit.Point);
            PdfText pageNumberingText = new PdfText(PageWidth, FooterHeight, String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;
            PdfText printdatetime = new PdfText(20, FooterHeight, DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont);
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
}
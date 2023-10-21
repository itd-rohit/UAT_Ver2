using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

using HiQPdf;
using MySql.Data.MySqlClient;

using System.Collections.Generic;

using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;

public partial class Design_Lab_DownloadRateList1 : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs;
    DataTable dtSettlement;
    DataTable dtRefund;

    //Page Property

    int MarginLeft = 20;
    int MarginRight = 30;
    int PageWidth = 550;
    int BrowserWidth = 800;

    //Header Property
    float HeaderHeight = 120;//207
    int XHeader = 100;//20
    int YHeader = 80;//80
    int HeaderBrowserWidth = 800;

    // BackGround Property
    bool HeaderImage = true;
    bool FooterImage = false;
    bool BackGroundImage = false;
    string HeaderImg = "";

    //Footer Property 80
    float FooterHeight = 50;
    int XFooter = 20;

    DataRow drcurrent;

    string id = "";
    string name = "";


    protected void Page_Load(object sender, EventArgs e)
    {
        string LedgerPwd = Util.GetString(HttpContext.Current.Request.QueryString["LedgerPwd"]);
        id = UserInfo.ID.ToString();
        name = UserInfo.LoginName.ToString();
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
        if (!IsPostBack)
        {
            BindData(LedgerPwd);
        }
    }
    public void BindData(string LedgerPwd)
    {
        lblmsg.Text = "";
        try
        {
            StringBuilder sb = new StringBuilder();
            using (DataTable dt = ((DataTable)Session["dtratelist"]))
            {
                if (dt != null && dt.Rows.Count > 0)
                {
                    sb = new StringBuilder();
                
                    sb.Append("<div style='width:1000px;'>");
                    sb.Append("<table style='width:100%;border-collapse:collapse;font-family:Times New Roman;font-size:16px;'>");
                
                    #region "3 row"
                    string LabNo = "";
                    string BookingCentre = "";
                    int i = 0;
                    foreach (DataRow dw in dt.Rows)
                    {
                        sb.Append("<tr>");
                        sb.Append("<td style='width:5%;text-align:center;'>" + Util.GetInt(i + 1) + "</td>");
                        sb.Append("<td style='width:10%;text-align:center;'>" + Util.GetString(dw["ItemID"]) + "</td>");
                        sb.Append("<td style='width:10%;text-align:center;'>" + Util.GetString(dw["testcode"]) + "</td>");
                        sb.Append("<td style='width:40% !important;font-weight:bold;word-break: break-word;' >" + Util.GetString(dw["ItemName"]) + "</td>");
                        sb.Append("<td  style='width:10%;text-align: right;'>" + Util.GetDouble(dw["MRP"]) + "</td>");
                        sb.Append("<td style='width:10%;text-align: right;'>" + Util.GetDouble(dw["PatientRate"]) + "</td>");
                        if (Session["CentreType"].ToString().ToUpper() == "CC")
                        {
                            sb.Append("<td style='width:10%;text-align: right;'>" + Util.GetDouble(dw["ClientRate"]) + "</td>");
                        }
                        sb.Append("</tr>");
                        i = i + 1;
                    }
                  //  sb.Append("</table>");
                    //sb.Append("</div>");
                    #endregion

                    AddContent(sb.ToString());
                    SetFooter(tempDocument.Pages[tempDocument.Pages.Count - 1]);
                    mergeDocument();
                    byte[] pdfBuffer = document.WriteToMemory();
                    HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
                    HttpContext.Current.Response.BinaryWrite(pdfBuffer);
                   // HttpContext.Current.Response.End();
                    HttpContext.Current.Response.Flush();
                    // Response.Clear();
                    HttpContext.Current.Response.SuppressContent = true;
                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                }
            }


            //}
        }
        catch(Exception ex) 
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblmsg.Text = ex.Message;
        }
        finally
        {
            Session["dtratelist"] = string.Empty;
            Session.Remove("dtratelist");
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
    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        PdfPage page1 = eventParams.PdfPage;
        //set background iamge in pdf report.
        if (BackGroundImage == true)
        {
            HeaderImg = "";// "App_Images/WatermarkReceipt.png";
            page1.Layout(getPDFBackGround(HeaderImg));
        }
        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);
        SetFooter(page1);
    }
    private void SetHeader(PdfPage page)
    {
        page.CreateHeaderCanvas(HeaderHeight);
        PdfHtml headerHtml = new PdfHtml(XHeader - 80, YHeader - 40, PageWidth, MakeHeader(), null);
        //   page.Header.Layout(getPDFImageforbarcode(15, 140, drcurrent["LedgerTransactionNo"].ToString()));
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(headerHtml);
        //string path = "../../App_Images/brcodelogo/vaccutainer-logo-red.jpg";
        //if (HeaderImage)
        //{
        //    page.Header.Layout(getPDFImageHeader(path));
        //}
        //-----------------
       
    }
    private PdfImage getPDFImageHeader(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(10, 3, 150, Server.MapPath(SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }
    private void SetFooter(PdfPage page)
    {
        if (page.Footer != null)
        {
            if (FooterImage)
            {
                page.Footer.Layout(getPDFImageFooter(drcurrent["FooterImage"].ToString()));
            }

        }
    }
    private PdfImage getPDFImageforbarcode(float X, float Y, string labno)
    {
        string image = "";

        //  image = new Barcode_alok().Save(labno).Trim();



        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Base64StringToImage(image));

        transparentResizedPdfImage.PreserveAspectRatio = true;



        return transparentResizedPdfImage;

    }
    public System.Drawing.Image Base64StringToImage(string base64String)
    {
        byte[] imageBytes = Convert.FromBase64String(base64String.Replace("data:image/png;base64,", ""));
        MemoryStream memStream = new MemoryStream(imageBytes, 0, imageBytes.Length);

        memStream.Write(imageBytes, 0, imageBytes.Length);
        System.Drawing.Image image = System.Drawing.Image.FromStream(memStream);
        Bitmap newImage = new Bitmap(240, 30);
        using (Graphics graphics = Graphics.FromImage(newImage))
            graphics.DrawImage(image, 0, 0, 240, 30);
        return newImage;
    }

    private PdfImage getPDFBackGround(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(225, 110, 200, Server.MapPath("~/" + SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }

    private PdfImage getPDFImageFooter(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(20, 0, Server.MapPath(SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }
    private string MakeHeader()
    {
        string headertext = "";

        StringBuilder Header = new StringBuilder();
        Header.Append("<div style='width:1000px;'>");

        Header.Append("<table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:15px;'");
        Header.Append("<tr>");
        Header.Append("<td><span style='font-size:16px !important;'></span>");
        Header.Append("</td>");
        Header.Append("</tr>");
        Header.Append("</table>");

        Header.Append("<table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:15px;'>");
        Header.Append("<tr>");
        Header.Append("<td style='text-align:center;padding:15px 5px;'><span style='font-size:26px !important;font-weight:bold; text-align:center;'>Rate List Report</span><br />");
        Header.Append("<span style='font-size:20px !important;font-weight:bold; text-align:center;'>Client : " + UserInfo.LoginName + "</span><br />");
        Header.Append("<span style='font-size:15px !important; text-align:center;'>Print Date : " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + "</span><br />");
        Header.Append("</td>");
        Header.Append("</tr>");
        Header.Append("</table>");

        
        Header.Append("<div style='width:1000px;'>");
        Header.Append("<table style='width:100%;border-collapse:collapse;font-family:Times New Roman;font-size:16px;margin-left:20px;'>");
        #region "1 row"

        Header.Append("<tr style='border-top:2px solid black;border-bottom:2px solid black;'>");
        Header.Append("<td style='width:5%;font-weight:bold;' >SNo.</td>");
        Header.Append("<td style='width:10%;font-weight:bold;' >Item ID</td>");
        Header.Append("<td style='font-weight:bold;width:10%;'>Test Code</td>");
        Header.Append("<td style='font-weight:bold;width:45%;' >Item Name</td>");
        Header.Append("<td  style='font-weight:bold;width:10%;text-align:center;'>MRP</td>");
        string RateType="Patient Rate";
        if (Session["CentreType"].ToString() != "CC")
        {
            RateType = "Client Rate";
        }

        Header.Append("<td style='font-weight:bold;width:10%;text-align:right;'>" + RateType + "</td>");
        if (Session["CentreType"].ToString().ToUpper() == "CC")
        {
            Header.Append("<td style='font-weight:bold;width:10%;text-align:right;'>Client Rate</td>");
        }
        
        Header.Append("</tr>");
       Header.Append("</table>");
       
        #endregion
        return Header.ToString();
    }
   
    private void mergeDocument()
    {
        int pageno = 1;
        foreach (PdfPage p in tempDocument.Pages)
        {
            

            PdfHtml linehtml = new PdfHtml(XFooter, -4, "<div style='width:1140px;border-top:3px solid black;'></div>", null);

            System.Drawing.Font pageNumberingFont =
          new System.Drawing.Font(new System.Drawing.FontFamily("Times New Roman"), 8, System.Drawing.GraphicsUnit.Point);
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
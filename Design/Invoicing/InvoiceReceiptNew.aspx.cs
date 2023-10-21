using HiQPdf;
using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Web;

public partial class Design_Invoicing_InvoiceReceiptNew : System.Web.UI.Page
{
    private PdfDocument document;
    private PdfDocument tempDocument;
    private PdfLayoutInfo html1LayoutInfo;
    private DataTable dtObs;
    private DataTable dtSettlement;
    private DataTable dtRefund;

    //Page Property

    private int MarginLeft = 20;
    private int MarginRight = 30;
    private int PageWidth = 550;
    private int BrowserWidth = 800;

    //Header Property
    //bool HeaderImage = false;
    //string HeaderImg = "";
    //string nabllogo = "../App_Images/mynabl.jpg";
    private float HeaderHeight = 80;//207

    private int XHeader = 20;//20
    private int YHeader = 60;//80
    private int HeaderBrowserWidth = 800;

    // BackGround Property
    private bool HeaderImage = true;

    private bool FooterImage = false;
    private bool BackGroundImage = false;
    private string HeaderImg = "";

    //Footer Property 80
    private float FooterHeight = 60;

    private int XFooter = 20;

    private DataRow drcurrent;

    private string id = "";
    private string name = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            id = Util.GetString(UserInfo.ID);
            name = Util.GetString(UserInfo.LoginName);
        }
        catch { }
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
        if (!IsPostBack)
        {
            BindData();
        }
    }

    protected void BindData()
    {
        try
        {
            DataSet DsInvoice = ((DataSet)Session["DsInvoice"]);
            DataTable dtInvoice = DsInvoice.Tables[0];
            DataTable dtCm = DsInvoice.Tables[1];
            DataTable dtAccountSumm = DsInvoice.Tables[2];
            if (dtInvoice != null && dtInvoice.Rows.Count > 0)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("    <div style='width:1000px;font-family:Times New Roman;font-size:18px !important; '>");

                sb.Append(" <table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:18px; border: 2px solid'>");
                sb.Append(" <tr>");
                sb.Append("     <td style='width: 50%; text-align: left; border: 2px solid;'>");
                sb.Append("         <table style='width: 100%;font-family:Times New Roman;font-size:18px;'>");
                sb.Append("             <tr>");
                sb.Append("                 <td style='border-bottom: 2px solid;'>");
                sb.Append("                     <span style='font-weight: bold;'>ITDOSE INFOSYSTEMS PVT. LTD</span><br />");
                sb.Append("                     <span>G-19, G-Block, Sector 6,</span><br />");
                sb.Append("                     <span>Noida, Uttar Pradesh 201301</span><br />");
                sb.Append("                     <span><a href='www.abc.in'>www.itdoseinfo.com</a></span><br />");
                sb.Append("                     <span>GSTIN : N/A</span><br />");
                sb.Append("                     <span>Email : <a href='mailto:accounts@itdoseinfo.com'>accounts@itdoseinfo.com</a></span><br />");
                sb.Append("                     <span>Phone : +91 120 4100290 </span>");
                sb.Append("                 </td>");
                sb.Append("             </tr>");
                sb.Append("             <tr>");
                sb.Append("                 <td>");
                sb.Append("                     <span style='font-weight: bold;'>Client Info :</span><br />");
                sb.Append("                     <table style='width: 100%'>");
                sb.Append("                         <tr>");
                sb.Append("                             <td style='width: 20%; text-align: left;'><span>" + Util.GetString(dtInvoice.Rows[0]["Panel_Code"]) + "</span></td>");
                sb.Append("                             <td style='width: 50%; text-align: left;'><span>" + Util.GetString(dtInvoice.Rows[0]["InvoiceDisplayName"]) + "</span></td>");
                sb.Append("                         </tr>");
                sb.Append("                     </table>");
                sb.Append("                     <span>Plot No. : " + Util.GetString(dtInvoice.Rows[0]["Address"]) + "</span><br />");
                sb.Append("                     <span>Email : <a href='mailto:" + Util.GetString(dtInvoice.Rows[0]["EmailID"]) + "'>" + Util.GetString(dtInvoice.Rows[0]["EmailID"]) + "</a></span><br />");
                sb.Append("                     <table style='width: 100%'>");
                sb.Append("                         <tr>");
                sb.Append("                             <td style='width: 50%; text-align: left;'><span>Phone : " + Util.GetString(dtInvoice.Rows[0]["Mobile"]) + "</span></td>");
                sb.Append("                             <td style='width: 50%; text-align: left;'><span>GSTIN : " + Util.GetString(dtInvoice.Rows[0]["PanelGSTNo"]) + "</span></td>");
                sb.Append("                         </tr>");
                sb.Append("                     </table>");
                sb.Append("                 </td>");
                sb.Append("             </tr>");
                sb.Append("         </table>");
                sb.Append("     </td>");
                sb.Append("     <td style='width: 50%; text-align: left; vertical-align: top;'>");
                sb.Append("         <table style='width: 100%; font-family:Times New Roman;font-size:18px;'>");
                sb.Append("             <tr>");
                sb.Append("                 <td style=' width: 50%; border-right: 2px solid; '>");
                sb.Append("                     <span>Invoice No</span><br />");
                sb.Append("                     <span>" + Util.GetString(dtInvoice.Rows[0]["InvoiceNo"]) + "</span>");
                sb.Append("                 </td>");
                sb.Append("                 <td >");
                sb.Append("                     <span>Date of Invoice</span><br />");
                sb.Append("                     <span>" + Util.GetString(dtInvoice.Rows[0]["InvoiceDate"]) + "</span>");
                sb.Append("                 </td>");
                sb.Append("             </tr>");
                sb.Append("             <tr style='height: 200px; vertical-align: top;'>");
                sb.Append("                 <td colspan='2' style='border-top: 2px solid;'>");
                //sb.Append("                     <span>Place of Supply : </span> ");
                //sb.Append("                     <span>" + Util.GetString(dtInvoice.Rows[0]["PanelID"]) + "</span>");
                sb.Append("                 </td>");
                sb.Append("             </tr>");
                sb.Append("             <tr >");
                sb.Append("                 <td colspan='2' style='border-top: 2px solid;' >");
                sb.Append("                     <span>State Code : " + Util.GetString(dtInvoice.Rows[0]["StateCode"]) + "</span>");
                sb.Append("                 </td>");
                sb.Append("             </tr>");
                sb.Append("         </table>");
                sb.Append("     </td>");
                sb.Append(" </tr>");
                sb.Append("  </table>");
                sb.Append("  <table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:18px; border-bottom: 2px solid; border-left: 2px solid; border-right: 2px solid;'>");
                sb.Append(" <tr style='height: 40px; border-bottom: 2px solid;'>");
                sb.Append("     <td style='width: 4%;  border-right: 2px solid;'>Sn</td>");
                sb.Append("     <td style='width: 43%;  border-right: 2px solid; padding-left: 20px;'>Particulars</td>");
                sb.Append("     <td style='width: 10%;  border-right: 2px solid; padding-left: 8px;'>SAC</td>");
                sb.Append("     <td style='width: 43%; text-align: right; padding-right: 10px;'><span>Amount</span></td>");
                sb.Append(" </tr>");
                sb.Append(" <tr style='height: 60px;border-bottom: 2px solid;'>");
                sb.Append("     <td style='width: 4%;  border-right: 2px solid; vertical-align: top;' rowspan='2'>1</td>");
                sb.Append("     <td style='width: 43%;  border-right: 2px solid; padding-left: 20px; vertical-align: top;'>");
                sb.Append("         <span>" + Util.GetString(dtInvoice.Rows[0]["TestingCharges"]) + " : " + Util.GetString(dtInvoice.Rows[0]["Period"]) + "</span>");
                sb.Append("     </td>");
                sb.Append("     <td style='width: 10%;  border-right: 2px solid; padding-left: 8px; vertical-align: top;'><span>999316</span></td>");
                sb.Append("     <td style='width: 43%; text-align: right; padding-right: 10px; vertical-align: top;'><span>" + String.Format("{0:0.00}", Util.GetDecimal(dtInvoice.Rows[0]["ShareAmt"])) + "</span></td>");
                sb.Append(" </tr>"); sb.Append(" <tr>");
                //sb.Append("     <!--<td style='width: 4%;  border-right: 2px solid;'></td>-->");
                sb.Append("     <td style='text-align: right; font-weight: bold; width: 43%; border-bottom: 2px solid;'><span>Total</span></td>");
                sb.Append("     <td style='width: 10%; border-bottom: 2px solid;'><span></span></td>");
                sb.Append("     <td style='width: 43%; text-align: right; padding-right: 10px; font-weight: bold; border-bottom: 2px solid;'><span>" + String.Format("{0:0.00}", Util.GetDecimal(dtInvoice.Rows[0]["ShareAmt"])) + "</span></td>");
                sb.Append(" </tr>");
                sb.Append(" <tr >");
                sb.Append("     <td colspan='4' style='font-size: 17px;'>");
                sb.Append("         <span>Amount chargable in words</span>");
                sb.Append("     </td>");
                sb.Append(" </tr>");
                sb.Append(" <tr>");
                sb.Append("     <td colspan='4' style='font-weight: bold; font-size: 17px;'>");
                sb.Append("         <span>Indian Rupees " + changeNumericToWords(Util.GetString(dtInvoice.Rows[0]["ShareAmt"])) + " Only.</span>");
                sb.Append("     </td>");
                sb.Append(" </tr> ");
                sb.Append(" </table> ");
                sb.Append(" <table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:18px; border-bottom: 2px solid; border-left: 2px solid; border-right: 2px solid;'>");
                sb.Append(" <tr style='height: 30px; border-bottom: 2px solid;'>");
                sb.Append("     <td style='width: 70%; text-align: left; border-right: 2px solid; padding-left: 10px;'>");
                sb.Append("         <span>SAC</span>");
                sb.Append("     </td>");
                sb.Append("     <td  style='width: 30%; text-align: right;padding-right: 10px;'>");
                sb.Append("         <span>Amount</span>");
                sb.Append("     </td>");
                sb.Append(" </tr>");
                sb.Append(" <tr style=' border-bottom: 2px solid;'>");
                sb.Append("     <td  style='width: 70%; text-align: left; border-right: 2px solid;  padding-left: 10px;'>");
                sb.Append("         <span>999316</span>");
                sb.Append("     </td>");
                sb.Append("     <td style='width: 30%; text-align: right;padding-right: 10px;'>");
                sb.Append("         <span>" + String.Format("{0:0.00}", Util.GetDecimal(dtInvoice.Rows[0]["ShareAmt"])) + "</span>");
                sb.Append("     </td>");
                sb.Append(" </tr>");
                sb.Append(" <tr>");
                sb.Append("     <td style='width: 70%; text-align: right; border-right: 2px solid; font-weight: bold;  padding-right: 10px;'>");
                sb.Append("         <span>Total</span>");
                sb.Append("     </td>");
                sb.Append("     <td style='width: 30%; text-align: right; font-weight: bold;padding-right: 10px;'>");
                sb.Append("         <span>" + String.Format("{0:0.00}", Util.GetDecimal(dtInvoice.Rows[0]["ShareAmt"])) + "</span>");
                sb.Append("     </td>");
                sb.Append(" </tr> ");
                sb.Append(" </table> ");
              // sb.Append(" <table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:18px; border-bottom: 2px solid; border-left: 2px solid; border-right: 2px solid;'>");
              // sb.Append(" <tr style='height: 40px; '>");
              // sb.Append("     <td style='font-weight: bold; padding-left: 10px;'>");
              // sb.Append("         <span>Account Summary</span>");
              // sb.Append("     </td>");
              // sb.Append(" </tr>");
              // sb.Append(" <tr style='height: 200px; vertical-align: top;'>");
              // sb.Append("     <td style='padding-left: 10px;'>");
              // sb.Append("         <table style='width:76%; border-collapse:collapse;font-family:Times New Roman;font-size:18px; border: 2px solid; '>");
              // sb.Append("             <tr style='width: 100%; border-bottom: 2px solid;'>");
              //  sb.Append("                 <th style='width: 25%; border-right: 2px solid;'>");
              //  //sb.Append("                     <span>Opening Balance</span>");
              //  //sb.Append("                 </th>");
              //  //sb.Append("                 <th style='width: 25%; border-right: 2px solid;'>");
              //  //sb.Append("                     <span>Invoice Amount</span>");
              //  //sb.Append("                 </th>");
              //  //sb.Append("                 <th style='width: 25%; border-right: 2px solid;'>");
              //  //sb.Append("                     <span>Collection Amount</span>");
              //  //sb.Append("                 </th>");
              //  //sb.Append("                 <th style='width: 25%'>");
              //  //sb.Append("                     <span>Balance</span>");
              //  sb.Append("                 </th>");
              //  sb.Append("             </tr>");
              //  sb.Append("             <tr style='width: 100%'>");
              //  sb.Append("                 <td style='width: 25%; border-right: 2px solid;'>");
              //  sb.Append("                     <span style='float: right; padding-right: 10px;'>" + String.Format("{0:0.00}", Util.GetDecimal(dtAccountSumm.Rows[0]["Amount"])) + "</span>");
              //  sb.Append("                 </td>");
              //  sb.Append("                 <td style='width: 25%; border-right: 2px solid;'>");
              //  sb.Append("                     <span style='float: right; padding-right: 10px;'>" + String.Format("{0:0.00}", Util.GetDecimal(dtInvoice.Rows[0]["ShareAmt"])) + "</span>");
              //  sb.Append("                 </td>");
              //  sb.Append("                 <td style='width: 25%; border-right: 2px solid;'>");
              //  sb.Append("                     <span  style='float: right; padding-right: 10px;'>" + String.Format("{0:0.00}", Util.GetDecimal(dtAccountSumm.Rows[0]["CollectionAmount"])) + "</span>");
              //  sb.Append("                 </td>");
              //  sb.Append("                 <td style='width: 25%;'>");
              //  sb.Append("                     <span style='float: right; padding-right: 10px;'>" + String.Format("{0:0.00}", Util.GetDecimal(Util.GetDecimal(dtAccountSumm.Rows[0]["Amount"]) + Util.GetDecimal(dtInvoice.Rows[0]["ShareAmt"]) - Util.GetDecimal(dtAccountSumm.Rows[0]["CollectionAmount"]))) + "</span>");
              //  sb.Append("                 </td>");
              //  sb.Append("             </tr>");
              //  sb.Append("         </table>");
                sb.Append("     </td>");
                sb.Append(" </tr>");
                sb.Append(" <tr>");
                sb.Append("     <td style='padding-bottom: 10px;'>");
                sb.Append("         <table style='width:100%; border-collapse:collapse;font-family:Times New Roman;font-size:18px; '>");
                sb.Append("             <tr>");
                sb.Append("                 <td style='width: 40%'></td>");
                sb.Append("             <td style='float: right;border-top: 2px solid;border-bottom: 2px solid;border-left: 2px solid; width: 60%'>");
                // sb.Append("                     <span>This is a computer generated Invoice and doesn’t require a signature/stamp.</span>");
                sb.Append("             </td>");
                sb.Append("             </tr>");
                sb.Append("             ");
                sb.Append("         </table>");
                sb.Append("     </td>");
                sb.Append(" </tr> ");
                sb.Append(" </table> ");
                sb.Append("</div>");
                sb.Append("<div style='width: 1000px; margin-top: 10px;'>");
                sb.Append("<table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:18px; border: none;'>");
                sb.Append("<tr>");
                sb.Append("<th style='text-align: left;' colspan='3'>");
                sb.Append("Payment Information");
                sb.Append("</th>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td colspan='3'><span>Demand Draft/Cheque to be drawn in favour of ' ITDOSE INFOSYSTEMS PVT. LTD.'</span></td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td colspan='3'><span>RTGS/NEFT Bank details:</span></td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td colspan='3'><span>Beneficiary Name - ITDOSE INFOSYSTEMS PVT. LTD.</span></td>");
                sb.Append("</tr>");
				 sb.Append("<tr>");
                sb.Append("<td colspan='3';'><span>Bank Name : " + Util.GetString(dtInvoice.Rows[0]["BankName"]) + "</span></td>");
                                      
                sb.Append("   </tr>");
                sb.Append("<tr>");
                sb.Append(" <td colspan='3''><span>Bank ID : " + Util.GetString(dtInvoice.Rows[0]["BankID"]) + "</span></td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append(" <td colspan='3''><span>Bank Account Number : " + Util.GetString(dtInvoice.Rows[0]["AccountNo"]) + "</span></td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append(" <td colspan='3''><span>IFCI CODE : " + Util.GetString(dtInvoice.Rows[0]["IFSCCode"]) + "</span></td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append(" <td colspan='3''><span> PAN CardNo : " + Util.GetString(dtInvoice.Rows[0]["PANNo"]) + "</span></td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td style='width: 20%; padding-top: 10px;'></td>");
                sb.Append("<td style='width: 60%; padding-top: 10px; text-align: center;'>");
                sb.Append("<span style='text-align:center;'>");
                sb.Append("This is a computer generated invoice,requires no signature This Invoice will be considered correct if no errors are reported within 15 days of receipt of invoice To assure proper credit to your account,please mention Client code and invoice no. on your reminttance For clarification regarding the Bill details, please contact bill accounts@itdoseinfo.com,");
                sb.Append("</span>");
                sb.Append("</td>");
                sb.Append("<td style='width: 20%; padding-top: 10px;'></td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td style='width: 20%; padding-top: 10px;'></td>");
                sb.Append("<td style='width: 60%; padding-top: 10px; font-weight: bold; text-align: center;'>");
                sb.Append("<span>");
                sb.Append("Registered office:  G-19, G-Block, Sector 6, Noida, Uttar Pradesh 201301");
                sb.Append("</span>");
                sb.Append("</td>");
                sb.Append("<td style='width: 20%; padding-top: 40px;'></td>");
                sb.Append("</tr>");
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
        }
        catch (Exception Ex)
        {
            //lblmsg.Text = Ex.Message;
        }
        finally
        {
            Session["DsInvoice"] = "";
            Session.Remove("DsInvoice");
        }
    }

    protected void btnPreview_Click(object sender, EventArgs e)
    {
    }

    private void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        PdfPage page1 = eventParams.PdfPage;
        if (BackGroundImage == true)
        {
            HeaderImg = "";
            page1.Layout(getPDFBackGround(HeaderImg));
        }
       
        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);
        SetFooter(page1);
    }

    private PdfImage getPDFImage(float X, float Y, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Server.MapPath("~/" + SignImg));
        transparentResizedPdfImage.PreserveAspectRatio = true;
        return transparentResizedPdfImage;
    }
    private void SetHeader(PdfPage page)
    {
        page.CreateHeaderCanvas(HeaderHeight);
        PdfHtml headerHtml = new PdfHtml(XHeader - 80, YHeader - 40, PageWidth, MakeHeader(), null);
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(headerHtml);
        string path = "../../App_Images/SHLlogo.png";
        if (HeaderImage)
        {
            page.Header.Layout(getPDFImageHeader(path));
        }
    }

    private PdfImage getPDFImageHeader(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(10, 3, 150, Server.MapPath(SignImg));
        transparentResizedPdfImage.PreserveAspectRatio = true;
        return transparentResizedPdfImage;
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
        return transparentResizedPdfImage;
    }

    private PdfImage getPDFImageFooter(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(20, 0, Server.MapPath(SignImg));
        transparentResizedPdfImage.PreserveAspectRatio = true;
        return transparentResizedPdfImage;
    }

    private string MakeHeader()
    {
        string headertext = "";
        StringBuilder Header = new StringBuilder();
        Header.Append("<div style='width:1000px;'>");
        Header.Append("<table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:15px;'");
        Header.Append("<tr>");
        Header.Append("    <td class='auto-style1'><img style='width:200px;height:80px;' src='../../App_Images/MaxEmailLogo.jpg' /></td>");
        Header.Append("     <td style='text-align:left;'>");
        Header.Append("         <h2>Bill of Supply</h2>");
        Header.Append("     </td>");
        Header.Append("</tr>");
        Header.Append("</table>");
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

    public void test()
    {
    }

    public String changeNumericToWords(string numb)
    {
        String num = numb.ToString();
        return changeToWords(num, false);
    }

    private String changeToWords(String numb, bool isCurrency)
    {
        String val = "", wholeNo = numb, points = "", andStr = "", pointStr = "";
        String endStr = (isCurrency) ? ("Only") : ("");
        try
        {
            int decimalPlace = numb.IndexOf(".");
            if (decimalPlace > 0)
            {
                wholeNo = numb.Substring(0, decimalPlace);
                points = numb.Substring(decimalPlace + 1);
                if (Convert.ToInt32(points) > 0)
                {
                    andStr = (isCurrency) ? ("and") : ("point");// just to separate whole numbers from points/cents
                    endStr = (isCurrency) ? ("Cents " + endStr) : ("");
                    pointStr = translateCents(points);
                }
            }
            val = String.Format("{0} {1}{2} {3}", translateWholeNumber(wholeNo).Trim(), andStr, pointStr, endStr);
        }
        catch { ;}
        return val;
    }

    private String translateWholeNumber(String number)
    {
        string word = "";
        try
        {
            bool beginsZero = false;//tests for 0XX
            bool isDone = false;//test if already translated
            double dblAmt = (Convert.ToDouble(number));
            //if ((dblAmt > 0) && number.StartsWith("0"))
            if (dblAmt > 0)
            {//test for zero or digit zero in a nuemric
                beginsZero = number.StartsWith("0");

                int numDigits = number.Length;
                int pos = 0;//store digit grouping
                String place = "";//digit grouping name:hundres,thousand,etc...
                switch (numDigits)
                {
                    case 1://ones' range
                        word = ones(number);
                        isDone = true;
                        break;

                    case 2://tens' range
                        word = tens(number);
                        isDone = true;
                        break;

                    case 3://hundreds' range
                        pos = (numDigits % 3) + 1;
                        place = " Hundred ";
                        break;

                    case 4://thousands' range
                    case 5:
                    case 6:
                        pos = (numDigits % 4) + 1;
                        place = " Thousand ";
                        break;

                    case 7://millions' range
                    case 8:
                    case 9:
                        pos = (numDigits % 7) + 1;
                        place = " Million ";
                        break;

                    case 10://Billions's range
                        pos = (numDigits % 10) + 1;
                        place = " Billion ";
                        break;
                    //add extra case options for anything above Billion...
                    default:
                        isDone = true;
                        break;
                }
                if (!isDone)
                {//if transalation is not done, continue...(Recursion comes in now!!)
                    word = translateWholeNumber(number.Substring(0, pos)) + place + translateWholeNumber(number.Substring(pos));
                    //check for trailing zeros
                    if (beginsZero) word = " and " + word.Trim();
                }
                //ignore digit grouping names
                if (word.Trim().Equals(place.Trim())) word = "";
            }
        }
        catch { ;}
        return word.Trim();
    }

    private String tens(String digit)
    {
        int digt = Convert.ToInt32(digit);
        String name = null;
        switch (digt)
        {
            case 10:
                name = "Ten";
                break;

            case 11:
                name = "Eleven";
                break;

            case 12:
                name = "Twelve";
                break;

            case 13:
                name = "Thirteen";
                break;

            case 14:
                name = "Fourteen";
                break;

            case 15:
                name = "Fifteen";
                break;

            case 16:
                name = "Sixteen";
                break;

            case 17:
                name = "Seventeen";
                break;

            case 18:
                name = "Eighteen";
                break;

            case 19:
                name = "Nineteen";
                break;

            case 20:
                name = "Twenty";
                break;

            case 30:
                name = "Thirty";
                break;

            case 40:
                name = "Fourty";
                break;

            case 50:
                name = "Fifty";
                break;

            case 60:
                name = "Sixty";
                break;

            case 70:
                name = "Seventy";
                break;

            case 80:
                name = "Eighty";
                break;

            case 90:
                name = "Ninety";
                break;

            default:
                if (digt > 0)
                {
                    name = tens(digit.Substring(0, 1) + "0") + " " + ones(digit.Substring(1));
                }
                break;
        }
        return name;
    }

    private String ones(String digit)
    {
        int digt = Convert.ToInt32(digit);
        String name = "";
        switch (digt)
        {
            case 1:
                name = "One";
                break;

            case 2:
                name = "Two";
                break;

            case 3:
                name = "Three";
                break;

            case 4:
                name = "Four";
                break;

            case 5:
                name = "Five";
                break;

            case 6:
                name = "Six";
                break;

            case 7:
                name = "Seven";
                break;

            case 8:
                name = "Eight";
                break;

            case 9:
                name = "Nine";
                break;
        }
        return name;
    }

    private String translateCents(String cents)
    {
        String cts = "", digit = "", engOne = "";
        for (int i = 0; i < cents.Length; i++)
        {
            digit = cents[i].ToString();
            if (digit.Equals("0"))
            {
                engOne = "Zero";
            }
            else
            {
                engOne = ones(digit);
            }
            cts += " " + engOne;
        }
        return cts;
    }
}
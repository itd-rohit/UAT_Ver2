using HiQPdf;
using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Web;

public partial class Design_Store_IndentReceiptTax_Pdf : System.Web.UI.Page
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
    private string path = "../../App_Images/ITdoseLogo.jpg";
    //Header Property
    //bool HeaderImage = false;
    //string HeaderImg = "";
    //string nabllogo = "../App_Images/mynabl.jpg";
    private float HeaderHeight = 30;//207

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
            DataSet DsBatchNumber = ((DataSet)Session["BatchNumber"]);
            DataTable dtBatchNumber = DsBatchNumber.Tables[0];
            //DataTable dtCm = DsInvoice.Tables[1];
            // DataTable dtAccountSumm = DsInvoice.Tables[2];
            if (dtBatchNumber != null && dtBatchNumber.Rows.Count > 0)
            {
                StringBuilder sb = new StringBuilder();

                sb.Append("<div>");
                sb.Append("<table style='border: 2px solid;border-collapse:collapse'>");
                sb.Append("<tr>");

                sb.Append("<div>");
                sb.Append("<table style='border: 2px solid;border-collapse:collapse'>");
                sb.Append("<tr>");
                sb.Append("<td style='border-style: solid; border-width: 1pt; width:1022pt;height:74pt;'>");
                sb.Append("<img  src='D:/GITNEW/Uat_ver1/App_Images/ITdoseLogo.png' />");
                sb.Append("<b>&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp; </b></td>");
              
                sb.Append("</tr>");

                sb.Append("<tr style='height:20pt'>");
                sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");

                sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
                sb.Append("<tr>");

                sb.Append("<td style=' width: 50%; border-right: 1px solid; '>");
                sb.Append("<span> <b>Issue Invoice Number  :&nbsp&nbsp " + dtBatchNumber.Rows[0]["IssueInvoiceNo"] + " </b>  ");
                sb.Append("</span>");

                sb.Append("</td>");

                sb.Append("<td>");

                sb.Append("<span><b> Batch Number : &nbsp&nbsp " + dtBatchNumber.Rows[0]["batchnumber"] + " </b> ");
                sb.Append("</span>");

                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("</table>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr style='height:20pt'>");
                sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
                sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
                sb.Append("<tr>");
                sb.Append("<td style=' width:20%; border-right: 1px solid; '>");
                sb.Append("<span> <b>Invoice Date: </b>");

                sb.Append("</span>");

                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append("<span><b> " + dtBatchNumber.Rows[0]["dtEntry"] + " </b>");
                sb.Append("<span> ");
                sb.Append("</span>");

                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("</table>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr style='height:20pt'>");
                sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
                sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
                sb.Append("<tr>");
                sb.Append("<td style=' width: 30%; border-right: 1px solid; '>");
                sb.Append("<span><b> Indent Number :</b>");
                
                sb.Append("</span>");

           //     sb.Append("<span><b> " + dtBatchNumber.Rows[0]["IndentNo"] + " </b>");

                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append("<span><b> " + dtBatchNumber.Rows[0]["IndentNo"] + " </b>");
                sb.Append("<span> ");
                sb.Append("</span>");

                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("</table>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr style='height:20pt'>");
                sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
                sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
                sb.Append("<tr>");
                sb.Append("<td style=' width: 32%; border-right: 1px solid; '>");
                sb.Append("<span><b>Name & Address of Sender :</b> " + dtBatchNumber.Rows[0]["FromLocation"] + " ");
                sb.Append("<span> ");
                sb.Append("</span>");


                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("</table>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr style='height:20pt'>");
                sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
                sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
                sb.Append("<tr>");
                sb.Append("<td style=' width:20%; border-right: 1px solid; '>");
                sb.Append("<span> <b>Receiver GSTN :  </b>");

                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("</table>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr style='height:20pt'>");
                sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
                sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
                sb.Append("<tr>");
                sb.Append("<td style=' width:20%; border-right: 1px solid; '>");
                sb.Append("<span> <b>Name & Address of Recipient : </b>");





                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append("<span>  ");
                sb.Append("</span>");

                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("</table>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr style='height:20pt'>");
                sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
                sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
                sb.Append("<tr>");
                sb.Append("<td style=' width:20%; border-right: 1px solid; '>");
                sb.Append("<span> <b>Sender GSTN : </b>");
           

                sb.Append("</span>");

                sb.Append("</td>");
                sb.Append("<td>");
                sb.Append("<span> ");
                sb.Append("</span>");

                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("</table>");
                sb.Append("</td>");
                sb.Append("</tr>");




                sb.Append("<table style='border: 1px solid;:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:15px; border-bottom: 1px solid; border-left: 1px solid; border-right: 1px solid;'>");
                sb.Append("<tr style='height: 40px; border-bottom: 1px solid;'>");
                sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>S.No </b> ");
                sb.Append("</td>");
                sb.Append("<td style='width: 40%;  border-right: 1px solid;'><b>Item Name</b>");
                sb.Append("</td>");
                sb.Append("<td style='width: 40%;  border-right: 1px solid;'><b>Machine Name</b>");
                sb.Append("</td>");
                sb.Append("<td style='width: 8%;  border-right: 1px solid;'><b>HSN Code </b> ");
                sb.Append("</td>");
                sb.Append("<td style='width: 10%;  border-right: 1px solid;'><b>Catalog No</b> ");
                sb.Append("</td>");
                sb.Append("<td style='width: 8%;  border-right: 1px solid;'><b>Order Qty </b>");
                sb.Append("</td>");
                sb.Append("<td style='width: 6%;  border-right: 1px solid;'><b>Price</b>");
                sb.Append("</td>");
                sb.Append("<td style='width: 6%;  border-right: 1px solid;'><b>Amount</b>");
                sb.Append("</td>");

                sb.Append("<td style='width: 6%;  border-right: 1px solid;'><b>Batch No</b>");
                sb.Append("</td>");
                sb.Append("<td style='width: 6%;  border-right: 1px solid;'><b>BarcodeNo</b>");
                sb.Append("</td>");
                sb.Append("<td style='width: 6%;  border-right: 1px solid;'><b>CUnit</b>");
                sb.Append("</td>");

                sb.Append("<td style='width: 6%;  border-right: 1px solid;'><b>Total Amt. </b>");
                sb.Append("</td>");
                    
                //sb.Append("</td>");
                sb.Append("</tr>");
                int i = 0;
                foreach (DataRow dr in dtBatchNumber.Rows)
                {
                    i += 1;
                    sb.Append("<tr style='height: 40px; border-bottom: 1px solid;'>");
                    sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + i + "</td> ");
                    sb.Append("<td style='width: 40%;  border-right: 1px solid;'>" + dr["ItemName"] + " </td>");
                    sb.Append("<td style='width: 40%;  border-right: 1px solid;'><b>Machine Name</b>");
                    sb.Append("</td>");
                    sb.Append("<td style='width: 8%;  border-right: 1px solid;'>" + dr["HsnCode"] + " </td>");
                    sb.Append("<td style='width: 10%;  border-right: 1px solid;'><b>Catalog No</b> ");
                    sb.Append("</td>");
                    sb.Append("<td style='width: 8%;  border-right: 1px solid;'>" + dr["issueQty"] + " </td>");

                    sb.Append("<td style='width: 6%;  border-right: 1px solid;'>" + dr["HsnCode"] + " </td>");

                    sb.Append("<td style='width: 6%;  border-right: 1px solid;'>" + dr["HsnCode"] + " </td>");

                    sb.Append("<td style='width: 6%;  border-right: 1px solid;'>" + dr["batchnumber"] + " </td>");

                    sb.Append("<td style='width: 6%;  border-right: 1px solid;'>" + dr["barcodeno"] + " </td>");

                    sb.Append("<td style='width: 6%;  border-right: 1px solid;'>" + dr["unitType"] + " </td>");

                    sb.Append("<td style='width: 6%;  border-right: 1px solid;'>" + dr["FinalAmount"] + " </td>");
               
                    sb.Append("</tr>");
                }
            
                float totalAmount = 0;
             
                
                sb.Append("</table>");

                sb.Append("<table style='border: 1px solid;border-collapse:collapse'>");
                sb.Append("<tr>");

                sb.Append("<td style='width: 10%; text-align: left; border-right: 1px solid; font-weight: bold;  padding-right: 10px;'>");
                sb.Append("<span>Total :     " + dtBatchNumber.Rows[0]["AmountInWord"] + "   ");
                sb.Append("</span>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("</table>");

                  sb.Append("<table style='border: 1px solid;border-collapse:collapse'>");
                sb.Append("<tr>");

                sb.Append("<td style='width: 10%; text-align: left; border-right: 1px solid; font-weight: bold;  padding-right: 10px;'>");
                sb.Append("<span>Total :  ");
                sb.Append("</span>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("</table>");

                sb.Append("<table style='border-collapse:collapse'>");
                sb.Append("<tr style='height:20pt'>");
                sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
                sb.Append("<table style='width: 100%; font-family:Times New Roman;font-size:15px;'>");
                sb.Append("<tr>");
                sb.Append("<td style='width: 100%; border-right: 0px solid;'>");
                sb.Append("<span>Signature</br>");
                sb.Append("</span>");
                sb.Append("<span>INTERNAL TRANSFER NOT FOR SALE</br>");
                sb.Append("</span>");
                sb.Append("<span>Designation / Status</br>");
                sb.Append("</span>");
               // sb.Append("<span><b>Date:   ,DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"));
                sb.AppendFormat("<span> <b> Date:{0}", Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy hh:mm tt"));
                sb.Append("</span>");
                //sb.Append("<span>This is a compuer generated document, hence signature is not required.");
                sb.Append("</span>");
                sb.Append("</td>");
               // sb.Append("<span><b>Name & Address of Sender :</b> " + dtBatchNumber.Rows[0]["FromLocation"] + " ");
             //   Header.AppendFormat("<td style='width:230px;'>{0}</td>", DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"));
                sb.Append("</tr>");
                sb.Append("</table>");
                sb.Append("</td>");
                sb.Append("</tr>");
              

                sb.Append("</table>");
                sb.Append("</td>");
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
            Session["dtBatchNumber"] = "";
            Session.Remove("dtBatchNumber");
        }

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
        string path = "../../App_Images/yoda_logo1.jpg";

        if (HeaderImage)
        {
            //page.Header.Layout(getPDFImageHeader(path));
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
        // Header.Append("<div style='width:1000px;'>");
        // Header.Append("<table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:15px;'");
        // Header.Append("<tr>");
        // Header.Append("    <td class='auto-style1'><img style='width:200px;height:80px;' src='../../App_Images/yoda_logo1.png' /></td>");
        // Header.Append("     <td style='text-align:left;'>");
        //// Header.Append("         <h2>Bill of Supply</h2>");
        // Header.Append("     </td>");
        // Header.Append("</tr>");
        // Header.Append("</table>");
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
        DataSet DsBatchNumber = ((DataSet)Session["BatchNumber"]);
        DataTable dtBatchNumber = DsBatchNumber.Tables[0];
        int pageno = 1;
        foreach (PdfPage p in tempDocument.Pages)
        {
            PdfHtml linehtml = new PdfHtml(XFooter, -4, "<div style='width:1140px;border-top:3px solid black;'></div>", null);
            PdfHtml satushtml = new PdfHtml(XFooter, -2, "<table style='border: 1px solid;width: 1150px; font-family:Times New Roman;font-size:20px;'><tr><td style='border-right: 1px solid;'><span><b>Created By :</b></span></td><td style=' border-right: 1px solid; '><span><b>Checked By :</b></span></td></tr></table>", null);
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
            //p.Footer.Layout(linehtml);
            p.Footer.Layout(satushtml);
            p.Footer.Layout(pageNumberingText);
            p.Footer.Layout(printdatetime);
            document.Pages.AddPage(p);
            pageno++;
        }

        tempDocument = new PdfDocument();
    }



}
﻿using HiQPdf;
using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Web;

public partial class Design_Store_GRNReceiptpdf : System.Web.UI.Page
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
    private string path = "../../App_Images/ITdoseLogo.png";
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
            DataSet DsIndentDetail = ((DataSet)Session["Grndetail"]);
            DataTable dtGrndetail = DsIndentDetail.Tables[0];
            //DataTable dtCm = DsInvoice.Tables[1];
           // DataTable dtAccountSumm = DsInvoice.Tables[2];
            if (dtGrndetail != null && dtGrndetail.Rows.Count > 0)
            {
                StringBuilder sb = new StringBuilder();

             sb.Append("<div>"); 
            sb.Append("<table style='border: 2px solid;border-collapse:collapse'>");
            sb.Append("<tr>");
            sb.Append("<td style='border-style: solid; border-width: 1pt; width:1022pt;height:74pt;'>");
            sb.Append("<img  src='D:/GITNEW/Uat_ver1/App_Images/ITdoseLogo.png' />");
            sb.Append("<b>&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;  Goods Received Note </b></td>");
        
	        sb.Append("</tr>");
        
            sb.Append("<tr>");
            sb.Append("<td style='width: 100%; text-align: left;'>");		   
            sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:13px;'>");
            sb.Append("<tr>");
            sb.Append("<td style=' width: 50%; border-right: 1px solid;margin-top:-20px; '>");
            sb.Append("<span> <b>Location :</b> " + Util.GetString(dtGrndetail.Rows[0]["Location"]) + " </br>");  
	        sb.Append("</span>");
            sb.Append("<span> <b>Supplier :</b> " + Util.GetString(dtGrndetail.Rows[0]["Vendorname"]) + " </br>");
            sb.Append("</span>");
            sb.Append("<span> <b>Address :</b> " + Util.GetString(dtGrndetail.Rows[0]["VendorAddress"]) + " </br>");
            sb.Append("</span>");
           
                    
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append("<span><b> GRN No : </b>" + Util.GetString(dtGrndetail.Rows[0]["LedgerTransactionNo"]) + " </br> "); 
			sb.Append("</span>");
            sb.Append("<span> <b>PO No :</b> " + Util.GetString(dtGrndetail.Rows[0]["PurchaseOrderNo"]) + " </br> ");
            sb.Append("</span>");
            sb.Append("<span> <b>Date :</b> " + Util.GetString(dtGrndetail.Rows[0]["grndate"]) + " </br> ");
            sb.Append("</span>");
            sb.Append("<span> <b>Receive By :</b> " + Util.GetString(dtGrndetail.Rows[0]["UserName"]) + " </br> ");
            sb.Append("</span>");
            sb.Append("<span> <b>Invoice No :</b> " + Util.GetString(dtGrndetail.Rows[0]["InvoiceNo"]) + " </br> ");
            sb.Append("</span>");
            sb.Append("<span> <b>Chalan No :</b> " + Util.GetString(dtGrndetail.Rows[0]["ChalanNo"]) + " </br> ");
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
                       sb.Append("<td style='width: 40%;  border-right: 1px solid;'><b>Description of Services</b>");  
                       sb.Append("</td>");
                       sb.Append("<td style='width: 8%;  border-right: 1px solid;'><b>Free </b> "); 
				       sb.Append("</td>");
                       sb.Append("<td style='width: 8%;  border-right: 1px solid;'><b>Batch Number </b> ");
                       sb.Append("</td>");
                       sb.Append("<td style='width: 10%;  border-right: 1px solid;'><b>Catalog No</b> "); 
				       sb.Append("</td>");
                       sb.Append("<td style='width: 8%;  border-right: 1px solid;'><b>Qty </b>"); 
				       sb.Append("</td>");
                       sb.Append("<td style='width: 6%;  border-right: 1px solid;'><b>Unit</b>");  
				       sb.Append("</td>");
                       sb.Append("<td style='width: 6%;  border-right: 1px solid;'><b></b>");  
				       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b></b>");   
                       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>IGST%</b> ");
                       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>CGST% </b>");
                       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>SGST %</b>");
                       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>Total</b>");
                       sb.Append("</td>");
                       //sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>Amnt.(Rs)</b> ");    
                       //sb.Append("</td>");
                       sb.Append("</tr>");
                          // For Add  Dynamic Data
                       //float totalCGST = 0;
                       //float totalQty = 0;
                       //float totalUnitPrice = 0;
                       //float totalDisc = 0;
                       //float totalTax = 0;
                       //float totalIGST = 0;
                       float totalAmount = 0;
                     //  float alltotal = 0;
                       for (int k = 0; k < dtGrndetail.Rows.Count; k++)
                       {
                           int J = k + 1;
                           sb.Append("<tr style='height: 40px; border-bottom: 1px solid;'>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'> "+J+"  ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 10%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[k]["ItemName"]) + "");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 5%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[k]["IsFree"]) + " ");//BatchNumber
                           sb.Append("</td>");
                           sb.Append("<td style='width: 10%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[k]["BatchNumber"]) + " ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 10%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[k]["CatalogNo"]) + " ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 6%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[k]["Quantity"]) + " ");
                           sb.Append("<td style='width: 5%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[k]["unittype"]) + "");
                           sb.Append("</td>");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 5%;  border-right: 1px solid;'>");//
                           sb.Append("</td>");
                           sb.Append("<td style='width: 5%;  border-right: 1px solid;'>");//
                           sb.Append("</td>");
                           sb.Append("<td style='width: 5%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[k]["IGSTPer"]) + "");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 5%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[k]["CGSTPer"]) + "");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 5%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[k]["SGSTPer"]) + "");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[k]["unitprice"]) + "");//pack size
                           sb.Append("</td>");
                           //sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[0]["Qty"]) + "");
                           //sb.Append("</td>");
                           //sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[0]["UnitPrice"]) + " ");
                           //sb.Append("</td>");
                           //sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[0]["Disc"]) + " ");
                           //sb.Append("</td>");
                           //sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[0]["Tax"]) + "");
                           //sb.Append("</td>");
                           //sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[0]["IGST"]) + "");
                           //sb.Append("</td>");
                           //sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtGrndetail.Rows[0]["Amount"]) + " ");
                           //sb.Append("</td>");
                           sb.Append("</tr>");
                           //totalCGST = Util.GetFloat(dtGrndetail.Rows[0]["CGST"]);
                           //totalQty = Util.GetFloat(dtGrndetail.Rows[0]["Qty"]);
                           //totalUnitPrice = Util.GetFloat(dtGrndetail.Rows[0]["UnitPrice"]);
                           //totalDisc = Util.GetFloat(dtGrndetail.Rows[0]["Disc"]);
                           //totalTax = Util.GetFloat(dtGrndetail.Rows[0]["Tax"]);
                           //totalIGST = Util.GetFloat(dtGrndetail.Rows[0]["IGST"]);
                           totalAmount = totalAmount + Util.GetFloat(dtGrndetail.Rows[k]["unitprice"]);

                           //alltotal=totalCGST*totalQty*totalUnitPrice+
                       }
                    sb.Append("</table>"); 

               sb.Append("<table style='border: 1px solid;border-collapse:collapse'>"); 
                sb.Append("<tr>");
             
                sb.Append("<td style='width: 10%; text-align: right; border-right: 1px solid; font-weight: bold;  padding-right: 10px;'>");
               sb.Append("<span>Total : " + totalAmount + " ");  
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
                sb.Append("<span><b>Date:</b> " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + "</br>");
                sb.Append("</span>");
                sb.Append("<span>This is a compuer generated document, hence signature is not required.");
                sb.Append("</span>");
                sb.Append("</td>");
                  
               sb.Append("</tr>");
               sb.Append("</table>");    
               sb.Append("</td>");
               sb.Append("</tr>");
               //sb.Append("<tr style='height:20pt'>"); 
			  // sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
             //  sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:16px;'>");
               //sb.Append("<tr>");
               //sb.Append("<td style=' width: 100%; border-right: 1px solid; '> &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; ");
               //sb.Append("<span><b>Terms and Conditions<b>");
               //sb.Append("</span>");                   
               //sb.Append("</td>");                 
               //sb.Append("</tr>");
               
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
            Session["dtGrndetail"] = "";
            Session.Remove("dtGrndetail");
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
using HiQPdf;
using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Web;

public partial class Design_Store_VendorQutReportpdf : System.Web.UI.Page
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
    private string path = "../../App_Images/yoda_logo1.jpg";
    //Header Property
    //bool HeaderImage = false;
    //string HeaderImg = "";
    //string nabllogo = "../App_Images/mynabl.jpg";
    private float HeaderHeight = 22;//207//80

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
            DataSet DsInvoice = ((DataSet)Session["QutationDetail"]);
            DataTable dtQutation = DsInvoice.Tables[0];
           

            if (dtQutation != null && dtQutation.Rows.Count > 0)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("<table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;border: 1px solid;background-color:#d2d5d9'>");
                sb.Append("<tr>");
                sb.Append("     <td style='text-align:center;'>");
                sb.Append("         <h2>Supplier Quotation</h2>");
                sb.Append("     </td>");
                sb.Append("</tr>");
                sb.Append("</table>");
           
             sb.Append("<div>");
             sb.Append("<table style=' width:1000px;border: 2px solid;border-collapse:collapse;border: 1px solid;font-size:14px'>");
            sb.Append("<tr>");
            sb.Append("<td style='border-style: solid; border-width: 1pt; width:1022pt;height:24pt;background-color:#d2d5d9'>");
               sb.Append("<span> <b>Quotation No:</b> " + Util.GetString(dtQutation.Rows[0]["Qutationno"]) + " ");  
           sb.Append("</tr>");
        
            sb.Append("<tr>"); 
			sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");

            sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:14px;border-bottom: 1pt solid black'>");
       
            sb.Append("<tr>");
            sb.Append("<td style=' width: 50%; border-right: 1px solid;background-color:#d2d5d9'>");
            sb.Append("<span> <b>Supplier Name:</b> " + Util.GetString(dtQutation.Rows[0]["vendor"]) + " ");
            sb.Append("</span>");

            sb.Append("</td>");
            sb.Append("<td style='background-color:#d2d5d9'>");
            sb.Append("<span><b> GSTN NO: </b>" + Util.GetString(dtQutation.Rows[0]["GSTno"]) + " ");
            sb.Append("</span>");

            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("</table>");    
             sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");   
			sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
            sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:14px;'>");
            sb.Append("<tr>");
            sb.Append("<td style=' width: 50%; border-right: 1px solid; '>");
            sb.Append("<span style='color:red;'> <b>Center:  </b>" + Util.GetString(dtQutation.Rows[0]["Center"]) + "");

		    sb.Append("</span>");
                    
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append("<span style='color:red;'><b> Location: </b>" + Util.GetString(dtQutation.Rows[0]["Location"]) + " ");  
		    sb.Append("</span>");
     
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("</table>");    
            sb.Append("</td>");
            sb.Append("</tr>");
             
           
					   
                       sb.Append("</table>");   
                       sb.Append("<table style='border: 1px solid;:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:14px; border-bottom: 1px solid; border-left: 1px solid; border-right: 1px solid;'>");
                       sb.Append("<tr style='height: 40px; border-bottom: 1px solid;background-color:#f5f6f7;'>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>S.No </b> ");
					   sb.Append("</td>");
                       sb.Append("<td style='width: 14%;  border-right: 1px solid;'><b>Item</b>");  
                       sb.Append("</td>");
                       sb.Append("<td style='width: 5%;  border-right: 1px solid;'><b>HSN Code </b> "); 
				       sb.Append("</td>");
                       sb.Append("<td style='width: 8%;  border-right: 1px solid;'><b>Catalog No</b> "); 
				       sb.Append("</td>");
                       sb.Append("<td style='width: 6%;  border-right: 1px solid;'><b>Manufacture </b>"); 
				       sb.Append("</td>");
                       sb.Append("<td style='width: 5%;  border-right: 1px solid;'><b>Rate</b>");  
				       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>Qty</b>");  
				       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>Disc %</b>");   
				       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>IGST %</b> ");
                       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>SGST % </b>");
                       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>CGST %</b>");  
				       sb.Append("</td>");
                     
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>Amount</b> ");    
				       sb.Append("</td>");
                       sb.Append("</tr>");
                
                       float totalAmount = 0;
                     
                       for (int k = 0; k < dtQutation.Rows.Count; k++)
                       {
                           int J = k + 1;
                           sb.Append("<tr style='height: 20px; border-bottom: 1px solid;'>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'> " + J + "  ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 10%;  border-right: 1px solid;'>" + Util.GetString(dtQutation.Rows[k]["Item"]) + "");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 5%;  border-right: 1px solid;'>" + Util.GetString(dtQutation.Rows[k]["HsnCode"]) + " ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 10%;  border-right: 1px solid;'>" + Util.GetString(dtQutation.Rows[k]["Catalogno"]) + " ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 6%;  border-right: 1px solid;'>" + Util.GetString(dtQutation.Rows[k]["Menufacture"]) + " ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 5%;  border-right: 1px solid;'>" + Util.GetString(dtQutation.Rows[k]["Rate"]) + "");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 5%;  border-right: 1px solid;'>" + Util.GetString(dtQutation.Rows[k]["Qty"]) + "");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtQutation.Rows[k]["DiscountPer"]) + "");//pack size
                           sb.Append("</td>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtQutation.Rows[k]["IGSTPer"]) + "");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtQutation.Rows[k]["SGSTPer"]) + " ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtQutation.Rows[k]["CGSTPer"]) + " ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtQutation.Rows[k]["FinalPrice"]) + "");
                           sb.Append("</td>");
                          
                           sb.Append("</tr>");

                              totalAmount =totalAmount+Util.GetFloat(dtQutation.Rows[k]["FinalPrice"]);

                       }
                    sb.Append("</table>");

                    sb.Append("<table style='border: 1px solid;border-collapse:collapse;font-size:14px;'>"); 
                   sb.Append("<tr>");
             
                sb.Append("<td style='width: 10%; text-align: right; border-right: 1px solid; font-weight: bold;  padding-right: 10px;'>");
                sb.Append("<span> Total Amount in INR : " + totalAmount + " ");  
                sb.Append("</span>"); 
				sb.Append("</td>");
                sb.Append("</tr>");          
                sb.Append("</table>");
                sb.Append("<table style='border: 1px solid;border-collapse:collapse;font-size:14px;'>");

                sb.Append("<td style='width:1000px;border: 1px solid;  '>");
                sb.Append("<span><b>Total Amt In Word:&nbsp;&nbsp&nbsp;&nbsp;</b>" + Util.GetString(dtQutation.Rows[0]["AmountInWord"]) + " </br>");
                sb.Append("</span>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td style=' width: 100%; border: 1px solid; '>");
                sb.Append("<span><b>Total QTY In Word:&nbsp;&nbsp;&nbsp;&nbsp;</b>" + Util.GetString(dtQutation.Rows[0]["QtyInWord"]) + " </br>");          
                sb.Append("</span>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td style=' width: 100%;'>");
                sb.Append("<span style='text-decoration: underline;color:red;'><b>Terms&Conditions</b>");
                sb.Append("</span>");
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
            Session["dtQutation"] = "";
            Session.Remove("dtQutation");
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
       // Header.Append("<table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:14px;'");
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
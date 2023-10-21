
using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;

public partial class Design_Lab_HistoTRF : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs;

    //Page Property

    int MarginLeft = 20;
    int MarginRight = 30;
    int PageWidth = 550;
    int BrowserWidth = 800;



    //Header Property
    float HeaderHeight = 138;//207
    int XHeader = 20;//20
    int YHeader = 30;//80
    int HeaderBrowserWidth = 800;




    // BackGround Property
    bool HeaderImage = true;
    bool FooterImage = true;
    bool BackGroundImage = true;
    string HeaderImg = "";

    //Footer Property 80
    float FooterHeight = 50;
    int XFooter = 20;

    DataRow drcurrent;


    protected void Page_Load(object sender, EventArgs e)
    {
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = "RAwtFRQg-IggtJjYl-Nj11dGp0-ZHVkcGR9-cXNkd3Vq-dXZqfX19-fQ==";


        try
        {
            StringBuilder sb = new StringBuilder();

            BindData();

            if (dtObs.Rows.Count == 0)
            {
                Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong . Please Refresh Page Or Contact To Admin..!<span><br/><input type='button' value='Refresh' style='cursor:pointer;font-weight:bold;' onclick='window.location.reload();'/></center>");
                return;
            }

            drcurrent = dtObs.Rows[0];


            sb.Append("<table style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:14px;'> ");

            sb.Append("<tr><td style='height:220px;border:1px solid black;padding:5px;' valign='top'><span style='font-weight:bold;font-size:16px;'> GROSS:</span><br/>Received</td></tr>");

            sb.Append("<tr><td style='height:10px;'><br/></td></tr>");

            sb.Append("<tr><td style='height:220px;border:1px solid black;padding:5px;' valign='top'> Section: (All Embedded/ Part Embedded)<br/>A-<br/>B-<br/>C-<br/>D-<br/>E-<br/><br/>Grosses on/by:</td></tr>");
            sb.Append("<tr><td style='height:10px;'><br/></td></tr>");
            sb.Append("<tr><td style='height:220px;border:1px solid black;padding:5px;' valign='top'><span style='font-weight:bold;font-size:18px;'> MICROSCOPIC FINDINGS:</span></td></tr>");
            sb.Append("<tr><td style='height:10px;'><br/></td></tr>");
            sb.Append("<tr><td style='height:220px;border:1px solid black;padding:5px;' valign='top'><span style='font-weight:bold;font-size:18px;'> IMPRESSION:</span></td></tr>");
            sb.Append("</table>");

            AddContent(sb.ToString());
            SetFooter(tempDocument.Pages[tempDocument.Pages.Count - 1]);
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

    private void SetFooter(PdfPage page)
    {
        if (page.Footer != null)
        {
           

        }
    }



    private PdfImage getPDFImageforbarcode(float X, float Y, string labno)
    {
        string image = "";

        image = new Barcode_alok().Save(labno).Trim();



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

    private PdfImage getPDFImageHeader(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(20, 10, Server.MapPath(SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }

    private string MakeHeader()
    {
        string headertext = "";
        
        headertext = "Histo Work Sheet";
     

        


        StringBuilder Header = new StringBuilder();
        Header.Append("<div style='width:800px;border:1px solid black;'>");
        Header.Append("<table style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:14px;'>");
        Header.Append("<tr style='border-bottom:1px solid black;'>");
        Header.Append("<td colspan='4' style='text-align:center;width:800px;font-weight:bold;'>" + headertext + "</td>");

        Header.Append("</tr>");

        Header.Append("<tr>");
        Header.Append("<td style='width:100px;font-weight:bold;'>Patient Name</td>");
        Header.Append("<td style='width:380px'>" + Util.GetString(drcurrent["pname"]) + "</td>");
        Header.Append("<td style='width:90px;font-weight:bold;'>Age/Gender</td>");
        Header.Append("<td>" + Util.GetString(drcurrent["age"]) + "/" + Util.GetString(drcurrent["gender"]) + "</td>");
        Header.Append("</tr>");


        Header.Append("<tr >");
        Header.Append("<td style='font-weight:bold;'>Visit ID</td>");
        Header.Append("<td >" + Util.GetString(drcurrent["LedgerTransactionNo"]) + "");

        Header.Append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
        Header.Append("<span style='font-weight:bold;'>SIN No</span>&nbsp;&nbsp;&nbsp;" + Util.GetString(drcurrent["barcodeno"]) + "</td>");


        Header.Append("<td style='font-weight:bold;'>UHID</td>");
        Header.Append("<td>" + Util.GetString(drcurrent["patient_id"]) + "</td>");


     

        Header.Append("</tr>");


     

        Header.Append("<tr>");
        Header.Append("<td style='font-weight:bold;'>Word Order Date</td>");
        Header.Append("<td >" + Util.GetString(drcurrent["regdate"]) + "");
        Header.Append("&nbsp;&nbsp;&nbsp;<span style='font-weight:bold;'>Collection Date</span>&nbsp;&nbsp;" + Util.GetString(drcurrent["SampleCollectionDate"]) + "&nbsp;");
       
        Header.Append("<td style='font-weight:bold;'>Received Date</td>");
        Header.Append("<td>" + Util.GetString(drcurrent["SampleReceiveDate"]) + "</td>");

        Header.Append("</tr>");

        Header.Append("<tr>");
        Header.Append("<td style='font-weight:bold;'>Doctor Name</td>");
        Header.Append("<td>" + Util.GetString(drcurrent["doctorname"]) + "</td>");
        Header.Append("<td style='font-weight:bold;'>Doctor Contact No</td>");
        Header.Append("<td>" + Util.GetString(drcurrent["Mobile"]) + "</td>");
       
        Header.Append("</tr>");

        Header.Append("<tr>");
        Header.Append("<td style='font-weight:bold;'>Biopsy No</td>");
        Header.Append("<td>" + Util.GetString(drcurrent["slidenumber"]) + "</td>");
        Header.Append("<td style='font-weight:bold;'>Test Center</td>");
        Header.Append("<td>" + Util.GetString(drcurrent["TestCentre"]) + "</td>");
        Header.Append("</tr>");

       

      


        Header.Append("<tr >");
        Header.Append("<td style='font-weight:bold;'>Test Name</td>");
        Header.Append("<td colspan='3'>" + Util.GetString(drcurrent["TestCode"]) + "~" + Util.GetString(drcurrent["InvestigationName"]) + "</td>");
      
        Header.Append("</tr>");
        

        Header.Append("</div>");
        Header.Append("</table>");
        return Header.ToString();
    }

    private void AddContent(string Content)
    {

        //File.AppendAllText("D:\\apollo.txt", Content);
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



            System.Drawing.Font pageNumberingFont =
          new System.Drawing.Font(new System.Drawing.FontFamily("Times New Roman"), 8, System.Drawing.GraphicsUnit.Point);


            PdfText pageNumberingText = new PdfText(PageWidth, FooterHeight, String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;


            PdfText printdatetime = new PdfText(PageWidth - 100, FooterHeight, DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont);
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

    void BindData()
    {

         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
        StringBuilder sb = new StringBuilder();
        sb.Append(" ");

        sb.Append("  SELECT lt.pname,lt.`Age`,lt.`Gender`,lt.`LedgerTransactionNo`,plo.`BarcodeNo`,plo.`SlideNumber`,IF(lt.`Doctor_ID`='2','Other',Concat('Dr.',lt.`DoctorName`)) doctorname, ");
        sb.Append(" dr.`Mobile`,plo.ItemName InvestigationName,plo.ItemCode TestCode,cm.`Centre` BookingCentre,left(cm1.`Centre`,17) TestCentre, ");
        sb.Append("DATE_FORMAT(plo.`SampleReceiveDate`,'%d-%b-%Y %h:%i%p')SampleReceiveDate,DATE_FORMAT(plo.SampleCollectionDate,'%d-%b-%Y %h:%i%p') SampleCollectionDate, ");
        sb.Append("  DATE_FORMAT(lt.`Date`,'%d-%b-%Y %h:%i%p') RegDate ,lt.patient_id FROM `f_ledgertransaction`  lt  ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
        sb.Append(" AND plo.`Test_ID`=@Test_ID ");
        sb.Append(" INNER JOIN `doctor_referal` dr ON dr.`Doctor_ID`=lt.`Doctor_ID` ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
        sb.Append("  INNER JOIN centre_master cm1 ON cm1.`CentreID`=plo.`TestCentreID` ");
        dtObs = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@Test_ID", Util.GetString(Request.QueryString["test_id"]))).Tables[0];
        
        }
        catch (Exception ex)
        {
           
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
}
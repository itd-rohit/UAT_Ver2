using HiQPdf;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_ILCSummaryReport : System.Web.UI.Page
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
    float HeaderHeight = 130;//207
    int XHeader = 20;//20
    int YHeader =90;//80
    int HeaderBrowserWidth = 800;




    // BackGround Property
    bool HeaderImage = false;
    bool FooterImage = true;
    bool BackGroundImage = true;
    string HeaderImg = "";

    //Footer Property 80
    float FooterHeight = 140;
    int XFooter = 20;

    DataRow drcurrent;
    string ApolloImagesPath = "https://lims.lupindiagnostics.com/LupinImages/";
    protected void Page_Load(object sender, EventArgs e)
    {
        document = new PdfDocument();
        tempDocument = new PdfDocument();
       document.SerialNumber = "RAwtFRQg-IggtJjYl-Nj11dGp0-ZHVkcGR9-cXNkd3Vq-dXZqfX19-fQ==";


        string testid = Common.Decrypt(Request.QueryString["testid"].ToString());
        if (Request.QueryString["phead"].ToString() == "1")
        {
            HeaderImage = true;
        }
         try
        {
            StringBuilder sb = new StringBuilder();

            BindData(testid);

            if (dtObs.Rows.Count == 0)
            {
                Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong . Please Refresh Page Or Contact To Admin..!<span><br/><input type='button' value='Refresh' style='cursor:pointer;font-weight:bold;' onclick='window.location.reload();'/></center>");
                return;
            }
            drcurrent = dtObs.Rows[0];


            sb.Append("<table box='frame' rules='all' border='1' style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:14px;'> ");
            sb.Append("<tr>");
            sb.Append("<td  width='50px' valign='top' style='font-weight:bold;'>Sl.No</td>");
            sb.Append("<td  width='150px'  valign='top' style='font-weight:bold;'>Parameter</td>");
            sb.Append("<td  width='100px'  valign='top' style='font-weight:bold;'>Laboratory Value</td>");
            sb.Append("<td  width='100px'  valign='top' style='font-weight:bold;'>Referance lab value</td>");
            sb.Append("<td  width='100px'  valign='top' style='font-weight:bold;'>Percentage Difference</td>");
            sb.Append("<td  width='100px'  valign='top' style='font-weight:bold;'>Accepetance Criteria</td>");
            sb.Append("<td  width='100px'  valign='top' style='font-weight:bold;'>Accepted/ UnAccepeted</td>");
            sb.Append("<td  width='100px'  valign='top' style='font-weight:bold;'>Remarks</td>");
            sb.Append("</tr>");
            int a = 1;
            foreach (DataRow dw in dtObs.Rows)
            {
                sb.Append("<tr>");
                sb.Append("<td  width='50px'  valign='top'>" + a.ToString() + "</td>");
                sb.Append("<td  width='150px'  valign='top'>" + dw["Parameter"].ToString() + "</td>");
                sb.Append("<td  width='100px'  valign='top'>" + dw["LaboratoryValue"].ToString() + "</td>");
                sb.Append("<td  width='100px'  valign='top'>" + dw["ReferanceLabValue"].ToString() + "</td>");
                sb.Append("<td  width='100px'  valign='top'>" + dw["PercentageDifference"].ToString() + "</td>");
                sb.Append("<td  width='100px'  valign='top'>" + dw["AccepetanceCriteria"].ToString() + "</td>");
                sb.Append("<td  width='100px'  valign='top'>" + dw["Accepted_UnAccepeted"].ToString() + "</td>");
                sb.Append("<td  width='100px'  valign='top'>" + dw["Remarks"].ToString() + "</td>");
                sb.Append("</tr>");
                a++;
            }


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


        if (HeaderImage == true && Util.GetString(drcurrent["ILCReportBackGroundImage"].ToString())!="")
        {
            HeaderImg = "App_Images/ILCReportBackGround/" + Util.GetString(drcurrent["ILCReportBackGroundImage"].ToString());
            page1.Layout(getPDFImage(0, 0, HeaderImg));
        }



        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);
        SetFooter(page1);




    }


    private PdfImage getPDFImage(float X, float Y, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Server.MapPath("~/" + SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
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
            StringBuilder sbimg = new StringBuilder();
            string imgname = ApolloImagesPath + "/signature/" + Util.GetString(drcurrent["ApproveByID"]) + ".jpg";

            sbimg.Append("<div style='width:750px;border-top:1px solid black;'>");
            sbimg.Append("<table style='width:750px;border-collapse:collapse;font-family:Times New Roman;font-size:14px;'>");
            sbimg.Append("<tr><td>");
            sbimg.Append("<img  src='" + imgname + "' />");
            sbimg.Append("</tr></td>");
            sbimg.Append("</table>");
            sbimg.Append("</div>");
            PdfHtml footerhtml = new PdfHtml(XFooter,0,sbimg.ToString(), null);
          
            footerhtml.BrowserWidth = HeaderBrowserWidth;
            page.Footer.Layout(footerhtml);

        }
    }



  

    private string MakeHeader()
    {
      





        StringBuilder Header = new StringBuilder();
        Header.Append("<div style='width:800px;border:1px solid black;'>");
        Header.Append("<table style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:14px;'>");

        Header.Append("<tr style='border-bottom:1px solid black;'>");
        Header.Append("<td colspan='4' style='text-align:center;width:800px;font-weight:bold;'>" + Util.GetString(drcurrent["ProcessingLabName"]) + "</td>");

        Header.Append("</tr>");


        Header.Append("<tr style='border-bottom:1px solid black;'>");
        Header.Append("<td colspan='4' style='text-align:center;width:800px;font-weight:bold;'>ILC Summary of " + Util.GetString(drcurrent["Entrymonth"]) +" " +Util.GetString(drcurrent["Entryyear"])+ "</td>");

        Header.Append("</tr>");



        Header.Append("</table>");
        Header.Append("</div>");
        
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


            PdfText pageNumberingText = new PdfText(PageWidth-50, 70, String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;


            PdfText printdatetime = new PdfText(PageWidth - 150, 70, DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont);
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

    void BindData(string id)
    {


        StringBuilder sb = new StringBuilder();


        sb.Append(" SELECT MONTHNAME(STR_TO_DATE(Entrymonth, '%m'))Entrymonth,EntryYear,ProcessingLabID, ProcessingLabName,ilclabname ILCLabName,LabItemName Parameter,oldvalue LaboratoryValue,oldmethod LaboratoryMethod,olddisplayreading LaboratoryDisplayReading,newvalue ReferanceLabValue,newvalue1 ReferanceLabValue1,newmethod ReferanceLabMethod,newdisplayreading ReferanceLabDisplayreading, ");
        sb.Append(" Variation PercentageDifference,Acceptable AccepetanceCriteria,STATUS Accepted_UnAccepeted ,Remarks,ApproveByID ");
        sb.Append(" ,ifnull(cm.ILCReportBackGroundImage,'') ILCReportBackGroundImage");
      
        sb.Append(" FROM qc_ilcresultentry qil  ");
        sb.Append(" inner join  centre_master cm on cm.centreid=qil.ProcessingLabID ");
        sb.Append(" WHERE id IN (" + id + ")");


        dtObs = StockReports.GetDataTable(sb.ToString());


    }
}
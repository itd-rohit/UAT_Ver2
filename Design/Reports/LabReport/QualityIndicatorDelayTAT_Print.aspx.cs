using System;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Text;
using HiQPdf;
using System.Web;
using System.Drawing.Drawing2D;
using MySql.Data.MySqlClient;


public partial class Design_Lab_QualityIndicatorDelayTAT_Print : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;


    //Page Property

    int MarginLeft = 20;
    int MarginRight = 30;
    int PageWidth = 800;
    int BrowserWidth = 800;

    float FooterHeight = 40;
    protected void Page_Load(object sender, EventArgs e)
    {       
        try
        {
            HtmlToPdf htmlToPdfConverter = new HtmlToPdf();

            htmlToPdfConverter.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
            // //http://itd-saas.cl-srv.ondgni.com
            byte[] pdfBuffer = htmlToPdfConverter.ConvertUrlToMemory("http://itd-saas.cl-srv.ondgni.com" + Resources.Resource.ApplicationName + "/Design/Reports/LabReport/QualityIndicatorDelayTAT_Draw.aspx?Val=" + Util.GetString(Request["Val"]));
           // byte[] pdfBuffer = htmlToPdfConverter.ConvertUrlToMemory("http://localhost:25961" + Resources.Resource.ApplicationName + "/Design/Reports/LabReport/QualityIndicatorDelayTAT_Draw.aspx?Val=" + Util.GetString(Request["Val"]));
           
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
    private void mergeDocument()
    {
        int pageno = 1;
        foreach (PdfPage p in tempDocument.Pages)
        {


            if (p.Footer == null)
            {
                p.CreateFooterCanvas(FooterHeight);

            }

            document.Pages.AddPage(p);
            pageno++;
        }

        tempDocument = new PdfDocument();
    }
}
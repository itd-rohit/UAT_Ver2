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

public partial class Design_Lab_WorksheetNew : System.Web.UI.Page
{

    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;

    //Page Property

    int MarginLeft = 20;
    int MarginRight = 30;
    int PageWidth = 550;
    int BrowserWidth = 800;



    //Header Property
    float HeaderHeight = 40;//207
    int XHeader = 20;//20
    int YHeader = 60;//80
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
        id = UserInfo.ID.ToString();
        name = UserInfo.LoginName.ToString();
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
        lblmsg.Text = "";
        try
        {
            DataTable dtInvest = ((DataTable)Session["dtWorklistMax"]);

            if (dtInvest != null && dtInvest.Rows.Count > 0)
            {
                StringBuilder sbWorklist = new StringBuilder();
                sbWorklist.Append("<div style='width:1000px;'>");
                sbWorklist.Append("<table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:15px;'");
                sbWorklist.Append("<tr>");
                sbWorklist.Append("<td style='text-align:center;padding:15px 5px;'><span style='font-size:20px !important;font-weight:bold; text-align:center;'>Pathology Check List " + dtInvest.Rows[0]["Period"] + " (" + dtInvest.Rows[0]["ReportOf"] + ") </span>");
                sbWorklist.Append("</td>");
                sbWorklist.Append("</tr>");
                sbWorklist.Append("</table>");


                sbWorklist.Append("<div style='width:1000px;'>");
                sbWorklist.Append("<table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:16px;'>");
                #region "1 row"

                sbWorklist.Append("<tr style='border-top:2px solid black;'>");
                sbWorklist.Append("<td style='width:120px;font-weight:bold;' >PatientID</td>");
                sbWorklist.Append("<td style='font-weight:bold;width:120px;'>Patient Name</td>");
                sbWorklist.Append("<td style='font-weight:bold;width:100px' >Age / Sex</td>");

                sbWorklist.Append("<td style='font-weight:bold;width:100px'></td>");
                sbWorklist.Append("<td  style='font-weight:bold;width:100px'></td>");
                sbWorklist.Append("<td  style='font-weight:bold;width:50px'>Ref. Doctor</td>");
                sbWorklist.Append("</tr>");

                sbWorklist.Append("<tr style='border-bottom:2px solid black;'>");
                sbWorklist.Append("<td style='width:100px;font-weight:bold;' ></td>");
                if (dtInvest.Columns.Contains("SampleCollectionDateTime"))
                {
                    sbWorklist.Append("<td style='font-weight:bold;width:100px;'>Registration Date / Department Receive Date</td>");
                }
                else
                {
                    sbWorklist.Append("<td style='font-weight:bold;width:100px;'>Registration Date</td>");
                }
                sbWorklist.Append("<td style='font-weight:bold;width:100px' >Requisition No.</td>");

                sbWorklist.Append("<td style='font-weight:bold;width:100px'>Test Name</td>");
                sbWorklist.Append("<td  style='font-weight:bold;width:50px'>Outsource</td>");
                sbWorklist.Append("<td  style='font-weight:bold;width:50px'>Sample No.</td>");
                sbWorklist.Append("</tr>");
                #endregion
                #region "2 row"


                #endregion

                #region "3 row"

                string LabNo = "";
                string BookingCentre = "";
                foreach (DataRow dw in dtInvest.Rows)
                {
                    if (BookingCentre != Util.GetString(dw["BookingCentre"]))
                    {
                        sbWorklist.Append("<tr style='border-top:2px solid black;'>");
                        sbWorklist.AppendFormat("<td colspan='3' style='width:20px;font-weight:bold;' >Centre : " + Util.GetString(dw["BookingCentre"]) + "</td>");

                        sbWorklist.Append("<td colspan='3' style='width:20px;font-weight:bold;text-align:right;padding-right:10px;' >Department : " + Util.GetString(dw["DepartmentName"]) + "</td>");
                        sbWorklist.Append("</tr>");
                        BookingCentre = Util.GetString(dw["BookingCentre"]);
                    }

                    if (LabNo != Util.GetString(dw["VisitID"]))
                    {
                        sbWorklist.Append("<tr style='border-top:2px solid black;'>");
                        sbWorklist.Append("<td style='width:120px;font-weight:bold;padding:5px 5px;' >" + Util.GetString(dw["PatientID"]) + "</td>");
                        sbWorklist.Append("<td style='font-weight:bold;width:120px;padding:5px 5px;'>" + Util.GetString(dw["PName"]) + "</td>");
                        sbWorklist.Append("<td style='font-weight:bold;width:100px;padding:5px 5px;' >" + Util.GetString(dw["Age"]) + " " + Util.GetString(dw["Sex"]) + " </td>");

                        sbWorklist.Append("<td style='font-weight:bold;width:100px;padding:5px 5px;'></td>");
                        sbWorklist.Append("<td  style='font-weight:bold;width:100px;padding:5px 5px;'></td>");
                        sbWorklist.Append("<td  style='font-weight:bold;width:50px;padding:5px 5px;'>" + Util.GetString(dw["DoctorName"]) + "</td>");
                        sbWorklist.Append("</tr>");
                        LabNo = Util.GetString(dw["VisitID"]);
                    }
                    if (LabNo != Util.GetString(dw["VisitID"]))
                    {
                        sbWorklist.Append("<tr style='border-bottom:2px solid black;'>");
                    }
                    else
                    {
                        sbWorklist.Append("<tr >");
                    }

                    sbWorklist.Append("<td style='width:100px;font-weight:bold;padding:5px 5px;' ></td>");
                    if (dw.Table.Columns.Contains("SampleCollectionDateTime"))
                    {
                        sbWorklist.Append("<td style='width:100px;padding:5px 5px;'>" + Util.GetString(dw["RegDateTime"]) + " / " + Util.GetString(dw["SampleCollectionDateTime"]) + "</td>");
                    }
                    else
                    {
                        sbWorklist.Append("<td style='width:100px;padding:5px 5px;'>" + Util.GetString(dw["RegDateTime"]) + "</td>");
                    }
                    sbWorklist.Append("<td style='width:100px;padding:5px 5px;' >" + Util.GetString(dw["VisitID"]) + "</td>");

                    sbWorklist.Append("<td style='width:100px;padding:5px 5px;'>" + Util.GetString(dw["TestName"]) + "</td>");
                    sbWorklist.Append("<td  style='width:50px;padding:5px 5px;'>" + Util.GetString(dw["outsrc"]) + "</td>");
                    sbWorklist.Append("<td  style='width:50px;padding:5px 5px;'>" + Util.GetString(dw["SINNo"]) + "</td>");
                    sbWorklist.Append("</tr>");
                }
                #endregion


                AddContent(sbWorklist.ToString());
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
            lblmsg.Text = Ex.Message;
        }

        finally
        {
            Session["dtWorklistMax"] = "";
            Session.Remove("dtWorklistMax");
        }

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
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader - 40, PageWidth, MakeHeader(), null);
        //   page.Header.Layout(getPDFImageforbarcode(15, 140, drcurrent["LedgerTransactionNo"].ToString()));
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(headerHtml);
        string path = "";// "../../App_Images/Max Lab_Logo.jpg";
        if (HeaderImage)
        {
            // page.Header.Layout(getPDFImageHeader(path));
        }
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
        Header.Append("<td><span style='font-size:18px !important;'></span>");
        Header.Append("</td>");
        Header.Append("</tr>");
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
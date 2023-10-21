using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Lab_DoctorApprovalReportSummary : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs;



    int MarginLeft = 20;
    int MarginRight = 20;
    int PageWidth = 550;
    int BrowserWidth = 800;


    float HeaderHeight = 80;//207
    int XHeader = 20;//20
    int YHeader = 60;//80
    int HeaderBrowserWidth = 800;


    //Footer Property 80
    float FooterHeight = 50;
    int XFooter = 20;
    string Period = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            document = new PdfDocument();
            tempDocument = new PdfDocument();
            document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
            try
            {
                DataSet ds = new DataSet();
                ds = (DataSet)Session["ds"];
                StringBuilder sb = new StringBuilder();

                DataTable dt = ds.Tables[0];

                Period = Session["Period"].ToString();


                List<getDetail> Doctor_ID = new List<getDetail>();
                var distinctdoctor = (from DataRow drw in dt.Rows
                                      select new { Doctor_ID = drw["Doctor_ID"] }).Distinct().ToList();
                sb = new StringBuilder();
                sb.Append(" <div style='width:1200px;'> ");
                sb.Append("<table style='width: 1200px;border-collapse: collapse;font-family:Arial;'>");
                for (int j = 0; j < distinctdoctor.Count; j++)
                {
                    using (DataTable dtdoc = dt.AsEnumerable().Where(x => x.Field<int>("Doctor_ID") == Util.GetInt(distinctdoctor[j].Doctor_ID)).CopyToDataTable())
                    {
                        sb.Append("<tr>");
                        sb.AppendFormat("<td  colspan='3' style='width: 100%;font-size: 20px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>{0}</td> ", Util.GetString(dtdoc.Rows[0]["DoctorName"].ToString()));
                        sb.Append("</tr>");
                        for (int i = 0; i < dtdoc.Rows.Count; i++)
                        {
                            sb.Append("<tr>");
                            sb.Append("<td style='width: 45%;font-size: 20px !important;word-wrap: break-word;'>&nbsp;</td> ");
                            sb.AppendFormat("<td style='width: 45%;font-size: 20px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Department"]));
                            sb.AppendFormat("<td style='width: 10%;font-size: 20px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Cnt"]));
                            sb.Append("</tr>");
                        }
                        sb.Append("<tr>");
                        sb.Append("<td style='width: 45%;font-size: 20px !important;word-wrap: break-word;'>&nbsp;</td> ");
                        sb.AppendFormat("<td style='width: 45%;border-bottom: 1px solid;border-top: 1px solid;font-size: 20px !important;word-wrap: break-word;'>Total of <b>{0} :</b></td> ", Util.GetString(dtdoc.Rows[0]["DoctorName"].ToString()));
                        sb.AppendFormat("<td style='width: 10%;border-bottom: 1px solid;border-top: 1px solid;font-size: 20px !important;word-wrap: break-word;'>{0}</td> ", dtdoc.AsEnumerable().Sum(x => x.Field<Int64>("Cnt")));
                        sb.Append("</tr>");
                    }
                }
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
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
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
                if (Session["ds"] != null)
                {
                    Session["ds"] = string.Empty;
                    Session.Remove("ds");
                }

                if (Session["Period"] != null)
                {
                    Session["Period"] = string.Empty;
                    Session.Remove("Period");
                }
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
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader - 40, PageWidth, MakeHeader(), null);
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(headerHtml);

    }
    private string MakeHeader()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" <div style='width:1200px;'> ");
        sb.Append("<table style='width: 1200px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;'>");
        sb.Append("<span style='font-weight: bold;font-size:26px;'>Approval Report(Summary)</span><br />");
        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        sb.AppendFormat(" <span style='font-size: 20px;'>{0}</span>", Period);
        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("</table>");

        sb.Append("<table style='width:1200px;border-top:2px solid #000;border-bottom:2px solid #000; font-family:Times New Roman;font-size:18px;'>");

        sb.Append(" <tr> ");
        sb.Append(" <td style='width: 45%;font-weight: bold;font-size: 20px !important;word-wrap: break-word;'></td> ");
        sb.Append(" <td style='width: 45%;font-weight: bold;font-size: 20px !important;word-wrap: break-word;'>Department</td> ");
        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 20px !important;word-wrap: break-word;'>Count</td> ");

        sb.Append(" </tr> ");

        sb.Append("</table>");
        sb.Append(" </div> ");
        return sb.ToString();
    }
    private void SetFooter(PdfPage page)
    {
        if (page.Footer != null)
        {
        }
    }
    private void AddContent(string Content)
    {
        PdfPage page1 = tempDocument.AddPage(PdfPageSize.A4, PdfDocumentMargins.Empty);
        PdfHtml html1 = new PdfHtml();
        //  html1 = new PdfHtml(MarginLeft, ((html1LayoutInfo == null) ? 0 : html1LayoutInfo.LastPageRectangle.Height), PageWidth, Content, null);
        html1 = new PdfHtml(MarginLeft, 0, PageWidth, Content, null);
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
            new System.Drawing.Font(new System.Drawing.FontFamily("Arial"), 8, System.Drawing.GraphicsUnit.Point);
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
    public class getDetail
    {
        public int Doctor_ID { get; set; }
    }
}
using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_OPD_SampleCountPdf : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;

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
    string reportheader = "";
    string CentreName = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            document = new PdfDocument();
            tempDocument = new PdfDocument();
            document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
           
                //DataTable dt = new DataTable();    
                StringBuilder sb = new StringBuilder();
                DataTable dt = (DataTable)Session["SampleCount"];
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = Util.GetString(dt.Rows[0]["Period"]);
                            reportheader = Util.GetString(dt.Rows[0]["ReportType"]);
                           
                                sb = new StringBuilder();
                               
                                    sb.Append(" <div style='width:1000px;'>");
                                    sb.Append(" <table style='width: 100%; border-collapse: collapse;padding-top:6px;'> ");
                                    sb.Append(" <tr> ");
                                    sb.Append(" <td style='width: 50%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>SampleName</td> ");
                                    sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>Sample Count</td> ");
                               

                                    sb.Append(" </tr> ");
                                    List<getDetail> Panelid = new List<getDetail>();
                                    var distinctdoctor = (from DataRow drw in dt.Rows
                                                          select new { Panelid = drw["Panelid"] }).Distinct().ToList();
                                    for (int j = 0; j < distinctdoctor.Count; j++)
                                    {
                                        DataTable dtdept = dt.AsEnumerable().Where(x => x.Field<int>("Panelid") == Util.GetInt(distinctdoctor[j].Panelid)).CopyToDataTable();
                                        sb.Append(" <tr> ");
                                        sb.Append(" <td colspan=3 style='font-size: 18px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtdept.Rows[0]["Company_Name"].ToString()) + "</td> ");
                                        sb.Append(" </tr> ");
                                        for (int i = 0; i < dtdept.Rows.Count; i++)
                                        {

                                            sb.Append("<tr> ");
                                            sb.Append(" <td style='width: 60%;font-size: 16px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtdept.Rows[i]["SampleTypeName"]) + "</td> ");
                                            sb.Append(" <td style='width: 20%;font-size: 16px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtdept.Rows[i]["SampleCount"]) + "</td> ");

                                        
                                            sb.Append(" </tr> ");
                                        }
                                     
                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td style='width: 60%;font-size: 18px;padding-top: 10px;font-weight: bold;text-align: right; '>{0}</td>", string.Concat("SubTotal of " + Util.GetString(dtdept.Rows[0]["Company_Name"]), ":"));
                                        sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dtdept.AsEnumerable().Sum(x => x.Field<decimal>("SampleCount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                       
                                   
                                        sb.Append(" </tr> ");
                                    }
                                    sb.Append("<tr> ");
                                    sb.AppendFormat(" <td style='width: 60%;font-size: 18px;padding-top: 10px;border-bottom: 1px solid;border-top: 1px solid;padding-top: 10px;font-weight: bold;text-align: right; '>Total:</td>");
                                    sb.AppendFormat(" <td style='width: 10%;font-size: 16px;padding-top: 10px;border-bottom: 1px solid;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("SampleCount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                  
                                   
                                    sb.Append(" </tr> ");
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
                        else
                        {
                            Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> No Record Found<span><br/></center>");
                            return;
                        }
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
        sb.Append(" <div style='width:1000px;'> ");
        sb.Append("<table style='width: 1000px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;'>");
       // if (Request.Form["ReportType"].ToString() == "Summary")
        sb.Append("<span style='font-weight: bold;font-size:20px;'>Sample Count  Report</span><br />");
        //else
        //    sb.Append("<span style='font-weight: bold;font-size:20px;'>Investigation Analysis Report(Detail) </span><br />");

        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        sb.AppendFormat(" <span style='font-size: 16px;'>{0}</span>", Period);
        sb.Append("</td>");
        sb.Append("</tr>");
        //sb.Append("<tr>");
        //sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        //sb.AppendFormat(" <span style='font-size: 16px;'>{0}</span>", CentreName);
        //sb.Append("</td>");
        //sb.Append("</tr>");
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
        public int Panelid { get; set; }
    }
    public class getInvestigationID
    {
        public int InvestigationID { get; set; }
    }
}
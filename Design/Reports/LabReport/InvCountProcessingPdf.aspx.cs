using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_LabReport_InvCountProcessingPdf : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;

    int MarginLeft = 20;
    int MarginRight = 20;
    int PageWidth = 550;
    int BrowserWidth = 800;


    float HeaderHeight = 70;//207
    int XHeader = 20;//20
    int YHeader = 50;//80
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
                StringBuilder sb = new StringBuilder();
                try
                {
                    using (DataTable dt = ((DataTable)Session["dtinvCount"]))
                    {

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = "";// Util.GetString(dt.Rows[0]["Period"]);                           
                            sb = new StringBuilder();
                            sb.Append(" <div style='width:1000px;'>");
                            sb.Append(" <table style='width: 100%; border-collapse: collapse;'> ");
                            sb.Append(" <tr> ");
                            sb.Append(" <td style='font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Department</td> ");
                            sb.Append(" <td style='font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Test Name</td> ");
                         
                            var distinctday = (from DataRow dr in dt.Rows
                                               select new { Day = dr["Day"] }).Distinct().ToList();
                            for (int j = 0; j < distinctday.Count; j++)
                            {
                                sb.Append(" <td style='font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>" + Util.GetInt(distinctday[j].Day) + "</td> ");
                            }
                            sb.Append(" <td style='font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Total</td> ");
                            sb.Append(" </tr> ");                                                        
                                var distinctinv = (from DataRow drw in dt.Rows
                                                   select new { InvestigationID = drw["investigation_id"]}).Distinct().ToList();

                                for (int l = 0; l < distinctinv.Count; l++)
                                {
                                     DataTable dtinv = dt.AsEnumerable().Where(x => x.Field<int>("investigation_id") == Util.GetInt(distinctinv[l].InvestigationID)).CopyToDataTable();
                                      sb.Append("<tr> ");
                                      sb.Append(" <td style='font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[0]["Department"]) + "</td> ");
                                      sb.Append(" <td style='font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[0]["TestName"]) + "</td> ");

                                      for (int k = 0; k < distinctday.Count; k++)
                                      {
                                          int a = 0;
                                          for (int i = 0; i < dtinv.Rows.Count; i++)
                                          {
                                              if (Util.GetInt(dtinv.Rows[i]["DAY"]) == Util.GetInt(distinctday[k].Day))
                                              a= Util.GetInt(dtinv.Rows[i]["CountMe"]);
                                          }
                                          sb.Append("<td style='font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetInt(a) + "</td>");
                                      }
                                    //  string aa = dtinv.Columns["CountMe"].DataType.ToString();                                     

                                      sb.AppendFormat(" <td style='font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;font-weight : bold;'>{0}</td>", dtinv.AsEnumerable().Where(x => x.Field<Int32>("investigation_id") == Util.GetInt(distinctinv[l].InvestigationID)).Sum(x => x.Field<Int64>("CountMe")));
                                    sb.Append(" </tr> ");
                                }
                                sb.Append("<tr> ");
                                sb.Append(" <td style='font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'></td>");
                                sb.Append(" <td style='font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;font-weight : bold;text-align :right'>Total:</td>");
                                for (int k = 0; k < distinctday.Count; k++)
                                {
                                    sb.AppendFormat(" <td style='font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;font-weight : bold;'>{0}</td>", dt.AsEnumerable().Where(x => x.Field<Int32>("DAY") == Util.GetInt(distinctday[k].Day)).Sum(x => x.Field<Int64>("CountMe")));
                                }
                                sb.Append(" <td style='font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;font-weight : bold;'>" + dt.AsEnumerable().Sum(x => x.Field<Int64>("CountMe")) + "</td>");
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
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }
                finally
                {

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
                Session["dtinvCount"] = "";
                Session.Remove("dtinvCount");
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

    }
    private string MakeHeader()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" <div style='width:1000px;'> ");
        sb.Append("<table style='width: 1000px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;'>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;'>");

        sb.Append("<span style='font-weight: bold;font-size:20px;'>Investigation Count Day Wise Report</span><br />");

        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        sb.AppendFormat(" <span style='font-size: 14px;'>{0}</span>", Period);
        sb.Append("</td>");
        sb.Append("</tr>");
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
        html1 = new PdfHtml(MarginLeft, 0, PageWidth, Content, null);//((html1LayoutInfo == null) ? 0 : html1LayoutInfo.LastPageRectangle.Height)
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
        public int Day { get; set; }
    }
    public class getinvestigation
    {
        public int Investigation { get; set; }       
    }
}
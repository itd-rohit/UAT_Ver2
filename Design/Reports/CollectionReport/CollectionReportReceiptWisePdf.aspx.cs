using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_OPD_CollectionReportReceiptWisePdf : System.Web.UI.Page
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
                DataTable dt = new DataTable();

                string fromDate = Request.Form["fromDate"].ToString();
                StringBuilder sb = new StringBuilder();

                if (Request.Form["ReportType"].ToString() == "0")
                {
                    sb = new StringBuilder();
                    sb.Append(" SELECT DATE_FORMAT(rec.`CreatedDate`,'%d-%m-%Y %H:%i')DATE,em.`Employee_ID`,CONCAT(em.`Title`,' ',em.`Name`)EmployeeName,  ");
                    sb.Append("  rec.`ReceiptNo`, rec.`LedgerTransactionNo` ");
                    sb.Append(" ,CONCAT(Rec.`PaymentMode`,' ',ROUND(Rec.`Amount`,2)) Payment,CONCAT(rec.`S_Notation`,' ',ROUND(rec.`S_Amount`,2))ActualCurrency, ");
                    sb.Append(" if(rec.PayBy='C','Client Advance',if(lt.`PName`<>'',lt.`PName`,'Appointment Advance'))PName,pnl.company_Name PanelName, ");
                    sb.Append(" Rec.`Amount`,rec.PaymentMode , ");                   
                    sb.Append(" rec.Patient_ID,rec.`PaymentMode`,rec.`PaymentModeID` FROM f_receipt rec  ");

                    sb.Append("  INNER JOIN employee_master em ON rec.CreatedByID=em.Employee_ID  ");
                    sb.Append("  left JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=rec.`LedgerTransactionID` ");
                    sb.Append(" INNER JOIN f_panel_master pnl ON pnl.Panel_ID = rec.Panel_ID ");
                    sb.Append(" WHERE rec.`IsCancel`=0 ");
                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND rec.`CreatedByID` IN ({0}) ");

                    sb.Append(" AND rec.`CentreID` IN ({1}) ");
                    sb.Append(" AND rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate  order by rec.`CreatedDate` ");
                }

                List<string> UserDataList = new List<string>();
                UserDataList = Request.Form["UserID"].ToString().Split(',').ToList<string>();

                List<string> CentreIDDataList = new List<string>();
                CentreIDDataList = Request.Form["CentreID"].Split(',').ToList<string>();
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", UserDataList), string.Join(",", CentreIDDataList)), con))
                    {
                        for (int i = 0; i < UserDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), UserDataList[i]);
                        }
                        for (int i = 0; i < CentreIDDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), CentreIDDataList[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@fromDate", Request.Form["fromDate"].ToString());
                        da.SelectCommand.Parameters.AddWithValue("@toDate", Request.Form["toDate"].ToString());
                        da.Fill(dt);

                        UserDataList.Clear();
                        CentreIDDataList.Clear();


                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            if (Request.Form["ReportFormat"].ToString() == "1")
                            {
                                sb = new StringBuilder();
                                sb.Append(" <div style='width:1100px;'> ");
                                sb.Append("<table style='width: 1100px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
                                if (Request.Form["ReportType"].ToString() == "0")
                                {                                  
                                    List<getDetail> Employee_ID = new List<getDetail>();
                                    var distinctdoctor = (from DataRow drw in dt.Rows
                                                          select new { Employee_ID = drw["Employee_ID"] }).Distinct().ToList();
                                    for (int j = 0; j < distinctdoctor.Count; j++)
                                    {
                                        DataTable dtdoc = dt.AsEnumerable().Where(x => x.Field<int>("Employee_ID") == Util.GetInt(distinctdoctor[j].Employee_ID)).CopyToDataTable();
                                        sb.Append(" <tr> ");
                                        sb.Append(" <td colspan='2' style='font-size: 16px;padding-top: 10px;padding-bottom: 10px;'>User : </td> ");
                                        sb.Append(" <td colspan='8' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtdoc.Rows[0]["EmployeeName"].ToString()) + "</td> ");
                                        sb.Append(" </tr> ");

                                        for (int i = 0; i < dtdoc.Rows.Count; i++)
                                        {
                                            if (Util.GetDecimal(dtdoc.Rows[i]["Amount"]) < 0)
                                                sb.Append("<tr style='background-color:#ffe6e6;'> ");
                                            else
                                                sb.Append("<tr> ");
                                            sb.AppendFormat(" <td style='width: 14%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["DATE"]));
                                            sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["LedgerTransactionNo"]));
                                            sb.AppendFormat(" <td style='width: 16%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["ReceiptNo"]));
                                            sb.AppendFormat(" <td style='width: 14%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["PName"]));
                                            sb.AppendFormat(" <td style='width: 15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["PanelName"]));
                                            sb.AppendFormat(" <td style='width: 13%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Payment"]));                                                                                        
                                            sb.AppendFormat(" <td style='width: 11%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["ActualCurrency"]));
                                            sb.AppendFormat(" <td style='width: 9%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["Amount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                            sb.Append(" </tr> ");
                                        }
                                        sb.Append("<tr> ");
                                        sb.Append(" <td colspan='7' style='text-align:right' >Sub-total of " + Util.GetString(dtdoc.Rows[0]["EmployeeName"].ToString()) + ":</td> ");
                                        sb.Append(" <td  style='border-bottom: 2px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");                                      

                                        sb.Append(" </tr> ");
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
                            else
                            {
                                Session["dtExport2Excel"] = dt;
                                Session["ReportName"] = "Client Wise Collection Report";
                                Response.Redirect("../../common/ExportToExcel.aspx");
                            }
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
                    con.Close();
                    con.Dispose();
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
        sb.Append(" <div style='width:1100px;'> ");
        sb.Append("<table style='width: 1100px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;'>");
        if (Request.Form["ReportType"].ToString() == "0")
        {
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Receipt Wise Collection Report(Summary)</span><br />");
        }
        else
        {
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Receipt Wise Collection Report(Detail)</span><br />");
        }
        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        sb.AppendFormat(" <span style='font-size: 14px;'>{0}</span>", Period);
        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("</table>");
        sb.Append(" </div> ");
        sb.Append(" <div style='width:1100px;'>");
        sb.Append("<table style='width:1100px;border-top:2px solid #000;border-bottom:2px solid #000; font-family:Times New Roman;font-size:16px;'>");
       
            sb.Append(" <tr> ");
            sb.Append(" <td style='width: 14%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Date</td> ");
            sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>LabNo</td> ");
            sb.Append(" <td style='width: 16%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>ReceiptNo</td> ");
            sb.Append(" <td style='width: 14%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Patient Name</td> ");

            sb.Append(" <td style='width: 15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Panel Name</td> ");
            sb.Append(" <td style='width: 13%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Payment Mode</td> ");            
            sb.Append(" <td style='width: 11%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>In Currency</td> ");            
            sb.Append(" <td style='width: 9%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Received Amt</td> ");                       
            sb.Append(" </tr> ");
            sb.Append("</table>");
            sb.Append(" </div> ");       
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
        public int Employee_ID { get; set; }
    }   
}
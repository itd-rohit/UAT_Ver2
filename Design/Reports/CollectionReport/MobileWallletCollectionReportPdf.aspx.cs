using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_OPD_MobileWallletCollectionReportPdf : System.Web.UI.Page
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
                    sb.Append(" SELECT   ");
                    sb.Append(" sum(Rec.`Amount`)Amount,rec.PaymentMode , rec.`PaymentModeID`,rec.CentreID,cm.Centre FROM f_receipt rec  ");
                    sb.Append(" INNER JOIN Centre_Master cm on cm.CentreID=rec.CentreID ");
                    sb.Append(" WHERE rec.`IsCancel`=0 ");
                  //  if (Request.Form["UserID"].ToString() != string.Empty)
                    //    sb.Append(" AND rec.`CreatedByID` IN ({0}) ");

                    sb.Append(" AND rec.`CentreID` IN ({0}) ");
                    if (Request.Form["wallet"].ToString() != string.Empty)
                        sb.Append(" AND rec.`PaymentModeID` IN ({1}) ");

                    sb.Append(" AND rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate   GROUP BY rec.`PaymentModeID` ");


                }
                else
                {
                    sb = new StringBuilder();
                    sb.Append(" SELECT   ");
                    sb.Append(" sum(Rec.`Amount`)Amount,rec.PaymentMode , rec.`PaymentModeID`,rec.CentreID,cm.Centre,rec.BankName FROM f_receipt rec  ");
                    sb.Append(" INNER JOIN Centre_Master cm on cm.CentreID=rec.CentreID ");
                    sb.Append(" WHERE rec.`IsCancel`=0 ");
                 //   if (Request.Form["UserID"].ToString() != string.Empty)
                   //     sb.Append(" AND rec.`CreatedByID` IN ({0}) ");

                    sb.Append(" AND rec.`CentreID` IN ({0}) ");
                    if (Request.Form["wallet"].ToString() != string.Empty)
                        sb.Append(" AND rec.`PaymentModeID` IN ({1}) ");

                    sb.Append(" AND rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate  GROUP BY rec.`PaymentModeID`,rec.BankName ");
                }
             
                //List<string> UserDataList = new List<string>();
                //UserDataList = Request.Form["UserID"].ToString().Split(',').ToList<string>();

                List<string> CentreIDDataList = new List<string>();
                CentreIDDataList = Request.Form["CentreID"].Split(',').ToList<string>();

                List<string> walletDataList = new List<string>();
                walletDataList = Request.Form["wallet"].Split(',').ToList<string>();

                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                   // using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", UserDataList), string.Join(",", CentreIDDataList), string.Join(",", walletDataList)), con))
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(),  string.Join(",", CentreIDDataList), string.Join(",", walletDataList)), con))
                    {
                        //for (int i = 0; i < UserDataList.Count; i++)
                        //{
                        //    da.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), UserDataList[i]);
                        //}
                        for (int i = 0; i < CentreIDDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), CentreIDDataList[i]);
                        }
                        for (int i = 0; i < walletDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@b", i), walletDataList[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@fromDate", Request.Form["fromDate"].ToString());
                        da.SelectCommand.Parameters.AddWithValue("@toDate", Request.Form["toDate"].ToString());
                        da.Fill(dt);

                     //   UserDataList.Clear();
                        CentreIDDataList.Clear();
                        walletDataList.Clear();

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
                                    
                                        for (int i = 0; i < dt.Rows.Count; i++)
                                        {
                                            if (Util.GetDecimal(dt.Rows[i]["Amount"]) < 0)
                                                sb.Append("<tr style='background-color:#ffe6e6;'> ");
                                            else
                                                sb.Append("<tr> ");
                                            sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetInt(i) + 1);
                                            sb.AppendFormat(" <td style='width: 60%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["PaymentMode"]));


                                            sb.AppendFormat(" <td style='width: 30%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["Amount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                            sb.Append(" </tr> ");
                                        }
                                        sb.Append("<tr> ");
                                        sb.Append(" <td colspan='2' style='text-align:right;width: 70%;' >Grand-total :</td> ");
                                        sb.Append(" <td  style='border-bottom: 2px solid;padding-top: 3px;font-size: 16px;width: 30%;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");

                                        sb.Append(" </tr> ");
                                    
                                }
                                else
                                {
                                    var distinctdoctor = (from DataRow drw in dt.Rows
                                                          select new { Employee_ID = drw["CentreID"] }).Distinct().ToList();
                                    for (int j = 0; j < distinctdoctor.Count; j++)
                                    {
                                        DataTable dtdoc = dt.AsEnumerable().Where(x => x.Field<int>("CentreID") == Util.GetInt(distinctdoctor[j].Employee_ID)).CopyToDataTable();
                                        sb.Append(" <tr> ");
                                        sb.Append(" <td  style='font-size: 16px;padding-top: 10px;padding-bottom: 10px;'>Centre : </td> ");
                                        sb.Append(" <td colspan='3' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtdoc.Rows[0]["Centre"].ToString()) + "</td> ");
                                        sb.Append(" </tr> ");

                                        for (int i = 0; i < dtdoc.Rows.Count; i++)
                                        {
                                            if (Util.GetDecimal(dtdoc.Rows[i]["Amount"]) < 0)
                                                sb.Append("<tr style='background-color:#ffe6e6;'> ");
                                            else
                                                sb.Append("<tr> ");
                                            sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetInt(i) + 1);
                                            sb.AppendFormat(" <td style='width: 30%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["PaymentMode"]));
                                            sb.AppendFormat(" <td style='width: 30%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["BankName"]));

                                            sb.AppendFormat(" <td style='width: 30%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["Amount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                            sb.Append(" </tr> ");
                                        }
                                        sb.Append("<tr> ");
                                        sb.Append(" <td colspan='3' style='text-align:right;width: 70%;' >Sub-total of " + Util.GetString(dtdoc.Rows[0]["Centre"].ToString()) + ":</td> ");
                                        sb.Append(" <td  style='border-bottom: 2px solid;padding-top: 3px;font-size: 16px;width: 30%;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");

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
                                Session["ReportName"] = "Mobile Wallet Collection Report";
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
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Mobile Wallet Collection Report(Summary)</span><br />");
        }
        else
        {
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Mobile Wallet Collection Report(Detail)</span><br />");
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
            if (Request.Form["ReportType"].ToString() == "0")
            {
                sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>SrNo</td> ");
                sb.Append(" <td style='width: 60%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>PayMentMode</td> ");

                sb.Append(" <td style='width: 30%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Received Amt</td> ");
            }
            else
            {
                sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>SrNo</td> ");
                sb.Append(" <td style='width: 30%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>PayMentMode</td> ");
                sb.Append(" <td style='width: 30%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>BankName</td> ");
                sb.Append(" <td style='width: 30%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Received Amt</td> ");
            }
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
}
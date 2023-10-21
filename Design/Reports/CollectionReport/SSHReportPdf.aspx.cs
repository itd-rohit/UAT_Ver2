using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_CollectionReport_SSHReportPdf : System.Web.UI.Page
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
					sb.Append(" SELECT t.date,t.LedgerTransactionNo,t.HospitalId,t.`PName`,t.Age,t.PaymentMode,t.DoctorName,t.ItemName,t.GrossAmount,t.DiscountAmt,t.NetAmount,t.NetBalance, ");
                    sb.Append(" SUM(IFNULL(r.Amount, 0)) ReceivedAmt,SUM(IF(IFNULL(r.`PaymentModeID`, 0) = 1,IFNULL(r.Amount, 0),0)) CashAmt,SUM(IF(IFNULL(r.`PaymentModeID`, 0) <> 1,IFNULL(r.Amount, 0),0)) OnlinePayment");
					sb.Append(" FROM( SELECT DATE_FORMAT(lt.date,'%d-%m-%Y')DATE,lt.LedgerTransactionNo,lt.PanelName HospitalId,lt.`PName`,CONCAT(lt.`Age`,'/',left( lt.`Gender`,1)) Age,'' PaymentMode,lt.`DoctorName`,plo.ItemName,");// lt.`Panel_ID`
                    sb.Append("  ROUND(lt.GrossAmount,2) GrossAmount,ROUND(lt.DiscountOnTotal,2)DiscountAmt, ROUND(lt.NetAmount,2)NetAmount,");
                    sb.Append("  ROUND(lt.NetAmount- IFNULL(lt.Adjustment,0),2)NetBalance,ROUND(SUM(lt.NetAmount - lt.Adjustment),2) PendingAmt,0 ReceivedAmt, ");

                    sb.Append("  0 CashAmt, ");
					sb.Append("  0 OnlinePayment,lt.LedgerTransactionID  ");
                    sb.Append("  FROM f_ledgertransaction lt ");
                    sb.Append("  INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`= plo.LedgerTransactionID  ");
                    sb.Append(" WHERE lt.date >=@fromDate AND lt.date <= @toDate ");
                    if (Request.Form["Panel_ID"].ToString() != string.Empty)
                      sb.Append(" AND lt.`Panel_ID` IN ({0}) ");
                        //sb.Append(" AND lt.`Panel_ID` IN ('"++"') ");
					if (Request.Form["CentreID"].ToString() != string.Empty)
                    sb.Append(" AND lt.`CentreID` IN ({1}) ");
                        // sb.Append(" AND lt.`CentreID` IN ('"++"') ");
                   // sb.Append("  AND ROUND(lt.Adjustment)<ROUND(lt.netAmount)  ");
                    sb.Append(" GROUP BY lt.LedgerTransactionID) t ");
					sb.Append(" LEFT JOIN f_receipt r   ON t.`LedgerTransactionID` = r.`LedgerTransactionID` AND r.Iscancel = 0 GROUP BY t.LedgerTransactionID  ");
					
                }
                else
                {
                    sb = new StringBuilder();
                    sb.Append(" SELECT DATE,lt.LedgerTransactionNo,lt.PName,lt.Panel_ID,lt.PanelName,  ");
                    sb.Append("  ROUND((NetAmount- rc.Amount),2)NetBalance,GrossAmount,DiscountAmt,NetAmount, ");
                    sb.Append("  ROUND( rc.Amount,2) ReceivedAmt,ROUND(rc.CashAmt,2)CashAmt, ROUND(rc.CardAmt,2)CardAmt,ROUND(rc.ChequeAmt,2)ChequeAmt, ");
                    sb.Append("  ROUND(rc.MobileWallet,2)MobileWallet,ROUND(rc.DebitCardAmt,2)DebitCardAmt,ROUND(rc.OnlinePayment,2)OnlinePayment ");
                    sb.Append(" FROM ( ");
                    sb.Append("  SELECT DATE_FORMAT(plo.date,'%d-%m-%Y')DATE,plo.LedgerTransactionNo,plo.LedgerTransactionID,lt.`PName`,lt.`Age`,lt.`Gender`,lt.`Panel_ID`,lt.`PanelName`, ");

                    sb.Append("  ROUND(SUM(Rate*Quantity),2) GrossAmount,ROUND(SUM(DiscountAmt),2)DiscountAmt, ROUND(SUM(plo.Amount),2)NetAmount");
                    sb.Append(" FROM `patient_labinvestigation_opd` plo ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");
                    sb.Append(" WHERE plo.date >=@fromDate AND plo.date <= @toDate AND lt.iscredit=0 ");
                    if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND lt.`Panel_ID` IN ({0}) ");

                    sb.Append(" AND plo.`CentreID` IN ({1}) ");
                    sb.Append(" GROUP BY plo.LedgerTransactionID  ) lt");
                    sb.Append(" LEFT JOIN ");
                    sb.Append("  (SELECT SUM(Amount)Amount, r.LedgerTransactionID, ");
                    sb.Append(" SUM(IF(`PaymentModeID`=1,Amount,0))CashAmt,SUM(IF(`PaymentModeID`=2,Amount,0))ChequeAmt,SUM(IF(`PaymentModeID`=3,Amount,0))CardAmt, ");
                    sb.Append(" SUM(IF(`PaymentModeID`=10,Amount,0))MobileWallet,SUM(IF(`PaymentModeID`=5,Amount,0))DebitCardAmt, ");
                    sb.Append(" SUM(IF(`PaymentModeID`=6,Amount,0))OnlinePayment FROM f_receipt r  ");
                    sb.Append(" WHERE  r.CreatedDate >=@fromDate AND r.CreatedDate <= @toDate AND r.Iscancel=0 ");

                    sb.Append("  GROUP BY r.LedgerTransactionID ) rc ON rc.LedgerTransactionID=lt.LedgerTransactionID ");
                    sb.Append(" WHERE ROUND(lt.NetAmount) < ROUND(IFNULL(rc.Amount,0)) ");
                }

                List<string> UserDataList = new List<string>();
                UserDataList = Request.Form["Panel_ID"].ToString().Split(',').ToList<string>();//CentreID
System.IO.File.WriteAllText(@"C:\Dummy.txt", Request.Form["Panel_ID"].ToString());
                List<string> PanelDataList = new List<string>();
                PanelDataList = Request.Form["CentreID"].Split(',').ToList<string>();//Panel_ID
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", UserDataList), string.Join(",", PanelDataList)), con))
                    {
						System.IO.File.WriteAllText(@"C:\Dummy.txt", sb.ToString());
                        for (int i = 0; i < UserDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), UserDataList[i]);
                        }
                        for (int i = 0; i < PanelDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), PanelDataList[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@fromDate", Request.Form["fromDate"].ToString());
                        da.SelectCommand.Parameters.AddWithValue("@toDate", Request.Form["toDate"].ToString());
                        da.Fill(dt);

                        UserDataList.Clear();
                        PanelDataList.Clear();


                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            if (Request.Form["ReportFormat"].ToString() == "1")
                            {
                                sb = new StringBuilder();
                                sb.Append(" <div style='width:1100px;'> ");
                                sb.Append("<table style='width: 1100px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");

                                List<getDetail> Panel_ID = new List<getDetail>();
                                var distinctdoctor = (from DataRow drw in dt.Rows
                                                      select new { Panel_ID = drw["Panel_ID"] }).Distinct().ToList();
                                for (int j = 0; j < distinctdoctor.Count; j++)
                                {
                                    DataTable dtdoc = dt.AsEnumerable().Where(x => x.Field<int>("Panel_ID") == Util.GetInt(distinctdoctor[j].Panel_ID)).CopyToDataTable();
                                    sb.Append(" <tr> ");
                                   // sb.Append(" <td colspan='2' style='font-size: 16px;padding-top: 10px;padding-bottom: 10px;'>PanelName : </td> ");
                                   // sb.Append(" <td colspan='10' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtdoc.Rows[0]["PanelName"].ToString()) + "</td> ");
                                    sb.Append(" </tr> ");

                                    for (int i = 0; i < dtdoc.Rows.Count; i++)
                                    {
                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["DATE"]));
                                        sb.AppendFormat(" <td style='width: 9%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["LedgerTransactionNo"]));
                                       // sb.AppendFormat(" <td style='width: 9%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["PName"]));
                                        sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["GrossAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["DiscountAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["NetAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["CashAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                       // sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["CardAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                       // sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["ChequeAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                       // sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["MobileWallet"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["ReceivedAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.Rows[i]["NetBalance"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                        sb.Append(" </tr> ");
                                    }
                                    sb.Append("<tr> ");
                                   // sb.AppendFormat(" <td colspan=3 style='width: 10%;border-bottom: 1px solid;font-weight: bold;padding-top: 3px;'>Sub-total :( " + Util.GetString(dtdoc.Rows[0]["PanelName"].ToString()) + ")</td>");
                                    sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("GrossAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("CashAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    //sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("CardAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                   // sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("ChequeAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                   // sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("MobileWallet"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("ReceivedAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 8%;border-bottom: 2px solid;font-weight: bold;padding-top: 3px;'>{0}</td> ", Math.Round(Util.GetDecimal(dtdoc.AsEnumerable().Sum(x => x.Field<decimal>("NetBalance"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                    sb.Append(" </tr> ");
                                    sb.Append(" </tr> ");
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
                                Session["ReportName"] = "OutStanding Report";
                               // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
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
            sb.Append("<span style='font-weight: bold;font-size:20px;'>OutStanding  Report(AS ON NOW Outstanding)</span><br />");
        }
        else
        {
            sb.Append("<span style='font-weight: bold;font-size:20px;'>OutStanding Report(DATE wise Outstanding)</span><br />");
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
        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Date</td> ");
        sb.Append(" <td style='width: 9%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>LabNo</td> ");
        sb.Append(" <td style='width: 9%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Patient Name</td> ");
        sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>GrossAmt</td> ");
        sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>DiscAmt</td> ");
        sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetAmt</td> ");
      //  sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>CashAmt</td> ");
      //  sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>CardAmt</td> ");
      //  sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>ChequeAmt</td> ");
      //  sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>MobileWallet</td> ");
        sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>ReceivedAmt</td> ");
        sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetBalance</td> ");
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
        public int Panel_ID { get; set; }
    }   
}
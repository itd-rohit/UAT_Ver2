using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_OPD_CollectionReportSummary : System.Web.UI.Page
{
    private PdfDocument document;
    private PdfDocument tempDocument;
    private PdfLayoutInfo html1LayoutInfo;
    private DataTable dtObs;

    private int MarginLeft = 20;
    private int MarginRight = 30;
    private int PageWidth = 850;
    private int BrowserWidth = 1050;

    //Header Property
    private float HeaderHeight = 50;

    private int XHeader = 20;
    private int YHeader = 30;
    private int HeaderBrowserWidth = 1050;

    // BackGround Property
    private bool HeaderImage = true;

    private bool FooterImage = true;
    private bool BackGroundImage = true;
    private string HeaderImg = "";

    //Footer Property 80
    private float FooterHeight = 50;

    private int XFooter = 20;

    private string HeadersubTitle = "";

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
                    sb.Append(" SELECT rec.CreatedByID,rec.CreatedBy as EmployeeName,PaymentModeID,S_Notation, ");
                    if (Request.Form["BaseCurrency"].ToString() == "1")
                        sb.Append(" SUM(`Amount`)`Amount`,Rec.`PaymentMode` PaymentMode ");
                    else
                        sb.Append(" SUM(S_Amount)Amount,concat(Rec.`PaymentMode`,'(',S_Notation,')') PaymentMode ");
                    sb.Append(" FROM f_receipt Rec  ");
                    sb.Append(" WHERE ifnull(rec.AppointmentID,'')='' and rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate AND rec.`IsCancel`=0  AND rec.`PayBy`<>'C' ");
                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND rec.`CreatedByID` IN ({0}) ");
                    sb.Append(" AND rec.`CentreID` IN ({1}) ");
                    sb.Append(" GROUP BY rec.CreatedByID, rec.`PaymentModeID` ");

                    if (Request.Form["BaseCurrency"].ToString() == "0")
                        sb.Append(" , S_Notation ");                  
                    // Appointment Amount
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT rec.CreatedByID,rec.CreatedBy as EmployeeName,PaymentModeID,S_Notation, ");
                    if (Request.Form["BaseCurrency"].ToString() == "1")
                        sb.Append(" SUM(`Amount`)`Amount`,concat('App_',Rec.`PaymentMode`) PaymentMode ");
                    else
                        sb.Append(" SUM(S_Amount)Amount,concat('App_',Rec.`PaymentMode`,'(',S_Notation,')') PaymentMode ");
                    sb.Append(" FROM f_receipt Rec  ");
                    sb.Append(" WHERE ifnull(rec.AppointmentID,'')<>'' and rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate AND rec.`IsCancel`=0 AND rec.`PayBy`<>'C'");
                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND rec.`CreatedByID` IN ({0}) ");
                    sb.Append(" AND rec.`CentreID` IN ({1}) ");
                    sb.Append(" GROUP BY rec.CreatedByID, rec.`PaymentModeID` ");

                    if (Request.Form["BaseCurrency"].ToString() == "0")
                        sb.Append(" , S_Notation ");
                    // Appointment Amount
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT rec.CreatedByID,rec.CreatedBy as EmployeeName,PaymentModeID,S_Notation, ");
                    if (Request.Form["BaseCurrency"].ToString() == "1")
                        sb.Append(" SUM(`Amount`)`Amount`,concat('ClientAdvance_',Rec.`PaymentMode`) PaymentMode ");
                    else
                        sb.Append(" SUM(S_Amount)Amount,concat('ClientAdvance_',Rec.`PaymentMode`,'(',S_Notation,')') PaymentMode ");
                    sb.Append(" FROM f_receipt Rec  ");
                    sb.Append(" WHERE ifnull(rec.AppointmentID,'')='' and rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate AND rec.`IsCancel`=0 AND rec.`PayBy`='C' ");
                    if (Request.Form["UserID"].ToString() != string.Empty)
                        sb.Append(" AND rec.`CreatedByID` IN ({0}) ");
                    sb.Append(" AND rec.`CentreID` IN ({1}) ");
                    sb.Append(" GROUP BY rec.CreatedByID, rec.`PaymentModeID` ");
                    if (Request.Form["BaseCurrency"].ToString() == "0")
                        sb.Append(" , S_Notation "); 
                    sb.Append(" ORDER BY `PaymentModeID`  ");
                }
                else
                {
                    sb = new StringBuilder();
                   
                }

                List<string> UserDataList = new List<string>();
                UserDataList = Request.Form["UserID"].ToString().Split(',').ToList<string>();

                List<string> CentreIDDataList = new List<string>();
                CentreIDDataList = Request.Form["CentreID"].Split(',').ToList<string>();
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
					//System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\collection.txt", sb.ToString());
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
                            string Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            if (Request.Form["ReportFormat"].ToString() == "1")
                            {
                                sb = new StringBuilder();
                                sb.Append(" <div style='width:1000px;'> ");
                                sb.Append("<table style='width: 1050px;border-collapse: collapse;font-family:Arial;border-bottom: 2px solid;margin-bottom: 10px;margin-top:15px;'>");
                                sb.Append("<tr>");
                                sb.Append("<td style='width:100%; text-align: center;'>");
                                if (Request.Form["ReportType"].ToString() == "0")
                                {
                                    if (Request.Form["BaseCurrency"].ToString() == "1")
                                        sb.Append("<span style='font-weight: bold;font-size:20px;'>User Wise Collection Summary(In Base Currency)</span><br />");
                                    else
                                        sb.Append("<span style='font-weight: bold;font-size:20px;'>User Wise Collection Summary(In Actual Currency)</span><br />");
                                }
                                else
                                {

                                }
                                sb.Append("</td>");
                                sb.Append("</tr>");
                                sb.Append("<tr>");
                                sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
                                sb.AppendFormat(" <span style='font-size: 14px;'>{0}</span>", Period);
                                sb.Append("</td>");
                                sb.Append("</tr>");
                                sb.Append("</table>");
                                sb.Append("<table style='width: 1050px;border-collapse: collapse;font-family:Arial;margin-top: 20px;'>");
                                sb.Append("<tr>");
                                sb.Append("<td style='width: 28%'></td>");


                                var PaymentModeDetail = (from DataRow dRow in dt.Rows
                                                         select new { PaymentModeID = dRow["PaymentModeID"], PaymentMode = dRow["PaymentMode"], CurrencyMode = dRow["S_Notation"] }).Distinct().ToList();

                                for (int j = 0; j < PaymentModeDetail.Count; j++)
                                {
                                    sb.AppendFormat("<td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;'>{0}</td>", PaymentModeDetail[j].PaymentMode.ToString());
                                }
                                sb.Append(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;'>Total</td>");
                                sb.Append(" </tr>");
                                if (Request.Form["ReportType"].ToString() == "0")
                                {
                                    var distinctReceiver = (from DataRow dRow in dt.Rows
                                                            select new { CreatedByID = dRow["CreatedByID"], EmployeeName = dRow["EmployeeName"] }).Distinct().ToList();
                                    for (int i = 0; i < distinctReceiver.Count; i++)
                                    {
                                        sb.Append(" <tr>");
                                        sb.AppendFormat(" <td style='width: 28%;border:1px solid;padding: 0.3em;'>{0}</td>", distinctReceiver[i].EmployeeName.ToString());
                                        for (int j = 0; j < PaymentModeDetail.Count; j++)
                                        {
                                            sb.AppendFormat(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(x => x.Field<sbyte>("PaymentModeID") == Util.GetByte(PaymentModeDetail[j].PaymentModeID) && x.Field<int>("CreatedByID") == Util.GetInt(distinctReceiver[i].CreatedByID.ToString()) && x.Field<string>("S_Notation") == Util.GetString(PaymentModeDetail[j].CurrencyMode) && x.Field<string>("PaymentMode") == Util.GetString(PaymentModeDetail[j].PaymentMode)).Sum(x => x.Field<Decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero));
                                        }
                                        sb.AppendFormat(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(x => x.Field<int>("CreatedByID") == Util.GetInt(distinctReceiver[i].CreatedByID.ToString())).Sum(x => x.Field<Decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        sb.Append(" </tr>");
                                    }
                                }
                                else
                                {

                                }
                                sb.Append(" <tr>");
                                sb.Append(" <td style='width: 28%;border:1px solid;padding: 0.3em;'>Total :</td>");

                                for (int j = 0; j < PaymentModeDetail.Count; j++)
                                {
                                    sb.AppendFormat(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(x => x.Field<sbyte>("PaymentModeID") == Util.GetByte(PaymentModeDetail[j].PaymentModeID) && x.Field<string>("S_Notation") == Util.GetString(PaymentModeDetail[j].CurrencyMode) && x.Field<string>("PaymentMode") == Util.GetString(PaymentModeDetail[j].PaymentMode)).Sum(x => x.Field<Decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero));
                                }
                                sb.AppendFormat(" <td style='width: 12%;border:1px solid;padding: 0.3em;text-align: right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                sb.Append(" </tr>");
                                sb.Append(" </table>");
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
                                if (Request.Form["BaseCurrency"].ToString() == "1")
                                {
                                    Session["ReportName"] = "User Wise Collection Summary(In Actual Currency)";
                                }
                                else
                                {
                                    Session["ReportName"] = "User Wise Collection Summary(In Base Currency)";
                                }

                                Response.Redirect("../../common/ExportToExcel.aspx");                               
                            }
                        }
                        else
                        {
                            Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> No Record Found..!<span><br/><input type='button' value='Refresh' style='cursor:pointer;font-weight:bold;' /></center>");                            
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
    private void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
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
        StringBuilder Header = new StringBuilder();
        Header.Append(" <div style='width: 1050px'>");
        Header.Append("<table style='width: 1050px;border-collapse: collapse;font-family:Arial;margin-top: 10px;'>");
        Header.Append("<tr>");
        Header.Append("<td></td>");
        Header.Append("</tr>");
        Header.Append("</table>");
        Header.Append("</div>");
        return Header.ToString();
    }

    private void SetFooter(PdfPage page)
    {
        if (page.Footer != null)
        {
        }
    }

    private void AddContent(string Content)
    {
        PdfPage page1 = tempDocument.AddPage(PdfPageSize.A3, PdfDocumentMargins.Empty);
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
            System.Drawing.Font pageNumberingFont = new System.Drawing.Font(new System.Drawing.FontFamily("Arial"), 8, System.Drawing.GraphicsUnit.Point);
            PdfText pageNumberingText = new PdfText(PageWidth, FooterHeight, String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;
            PdfText printdatetime = new PdfText(20, FooterHeight, DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont);
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
}
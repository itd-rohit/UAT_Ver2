using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_LabReport_LabObservationAnalysisReportPdf : System.Web.UI.Page
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
    int YHeader = 20;//80
    int HeaderBrowserWidth = 800;


    //Footer Property 80
    float FooterHeight = 50;
    int XFooter = 20;
    string Period = "";
    DataTable dt = new DataTable();
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
                //if (Request.Form["reporttype"] == "0")
                //{
                //    sb = new StringBuilder();
                //    sb.Append(" SELECT sb.`subcategoryid` ObservationType_ID,sb.Name ObservationTypeName,");
                //    sb.Append(" IFNULL(lob.`ObsTestCode`,' ') LabObservation_id,bt.`LabObservationName`,COUNT(1) Total ");
                //    sb.Append(" FROM patient_labobservation_opd bt ");
                //    sb.Append(" INNER JOIN labobservation_master lob ON lob.`LabObservation_ID`=bt.`LabObservation_id` ");
                //    sb.Append(" INNER JOIN patient_labinvestigation_opd plo   ON plo.`Test_id` = bt.`Test_id` ");
                //    sb.Append(" INNER JOIN f_subcategorymaster sb   ON plo.subcategoryid =sb.`subcategoryid` ");
                //    sb.Append(" WHERE bt.`ResultDateTime`>=@fromDate ");
                //    sb.Append(" AND bt.`ResultDateTime`<=@toDate ");
                //    if (Request.Form["CentreID"] != string.Empty)
                //    {
                //        sb.Append(" and plo.`CentreID` in ({0}) ");
                //    }
                   
                //    if (Request.Form["MachineID"] != string.Empty)
                //    {
                //        sb.Append(" and bt.`MachineName` in ({1}) ");
                //    }
                //    if (Request.Form["ParameterID"] != string.Empty)
                //    {
                //        sb.Append(" and bt.`LabObservation_id` in ({2}) ");
                //    }
                //    if (Request.Form["TestCentreID"] != string.Empty)
                //    {
                //        sb.Append(" and plo.`TestCentreID` in ({3}) ");
                //    }
                //    sb.Append(" GROUP BY bt.`LabObservation_id` ORDER BY sb.Name,bt.`LabObservationName`;  ");

                //}
                //else 
                
                if (Request.Form["reporttype"] == "1")
                {
                  //  sb = new StringBuilder();
                   // sb.Append(" SELECT bt.`Department`,bt.`LabObservation_id`,bt.`LabObservationName`,COUNT(1) Total ");
                  //  sb.Append(" FROM booking_transaction_rpt_labobservation bt ");
                   // sb.Append(" WHERE bt.`ResultDate`>=@fromDate ");
                   // sb.Append(" AND bt.`ResultDate`<=@toDate ");
                   // if (Request.Form["CentreID"] != string.Empty)
                   // {
                   //     sb.Append(" and bt.`BookingCentreID` in ({0}) ");
                   // }
                   // if (Request.Form["MachineID"] != string.Empty)
                   // {
                  //      sb.Append(" and bt.`MachineName` in ({1}) ");
                  //  }
                   // if (Request.Form["ParameterID"] != string.Empty)
                 //   {
                 //       sb.Append(" and bt.`LabObservation_id` in ({2}) ");
                 //   }
                  //  if (Request.Form["TestCentreID"] != string.Empty)
                   // {
                   //     sb.Append(" and bt.`TestCentreID` in ({3}) ");
                   // }
                   // sb.Append(" GROUP BY bt.`LabObservation_id` ORDER BY  bt.`Department`,bt.`LabObservationName`;  ");
                     sb = new StringBuilder();
                     sb.Append(" SELECT sb.`subcategoryid` ObservationType_ID,sb.Name ObservationTypeName,");
                   sb.Append(" bt.LabObservation_id LabObservation_id,bt.`LabObservationName`,COUNT(1) Total ");
                   sb.Append(" FROM patient_labobservation_opd bt ");
                  sb.Append(" INNER JOIN labobservation_master lob ON lob.`LabObservation_ID`=bt.`LabObservation_id` ");
                    sb.Append(" INNER JOIN patient_labinvestigation_opd plo   ON plo.`Test_id` = bt.`Test_id` ");
                    sb.Append(" INNER JOIN f_subcategorymaster sb   ON plo.subcategoryid =sb.`subcategoryid` ");
                   sb.Append(" where plo.`IsActive`=1 AND plo.IsReporting = '1' AND plo.isRefund=0 and plo.`ResultEnteredDate`>=@fromDate ");
                   sb.Append(" AND plo.`ResultEnteredDate`<=@toDate ");
                    if (Request.Form["CentreID"] != string.Empty)
                   {
                       sb.Append(" and plo.`CentreID` in ({0}) ");
                   }
                   
                 if (Request.Form["MachineID"] != string.Empty)
                    {
                        sb.Append(" and bt.`MachineName` in ({1}) ");
                   }
                   if (Request.Form["ParameterID"] != string.Empty)
                  {
                      sb.Append(" and bt.`LabObservation_id` in ({2}) ");
                 }
                 if (Request.Form["TestCentreID"] != string.Empty)
                   {
                       sb.Append(" and plo.`TestCentreID` in ({3}) ");
                  }
                   sb.Append(" GROUP BY bt.`LabObservation_id` ORDER BY sb.Name,bt.`LabObservationName`;  ");
                }
               // else
                //{
                //    sb = new StringBuilder();
                //    sb.Append(" SELECT bt.`MachineName`,bt.`LabObservation_id`,bt.`LabObservationName`,COUNT(1) Total ");
                //    sb.Append(" FROM booking_transaction_rpt_labobservation bt ");
                //    sb.Append(" WHERE bt.`ResultDate`>=@fromDate ");
                //    sb.Append(" AND bt.`ResultDate`<=@toDate ");
                //    if (Request.Form["CentreID"] != string.Empty)
                //    {
                //        sb.Append(" and bt.`BookingCentreID` in ({0}) ");
                //    }
                //    if (Request.Form["MachineID"] != string.Empty)
                //    {
                //        sb.Append(" and bt.`MachineName` in ({1}) ");
                //    }
                //    if (Request.Form["ParameterID"] != string.Empty)
                //    {
                //        sb.Append(" and bt.`LabObservation_id` in ({2}) ");
                //    }
                //    if (Request.Form["TestCentreID"] != string.Empty)
                //    {
                //        sb.Append(" and bt.`TestCentreID` in ({3}) ");
                //    }
                //    sb.Append(" GROUP BY bt.`MachineName`,bt.`LabObservation_id` ORDER BY  bt.`MachineName`,bt.`LabObservationName`;  ");
                //}
				// System.IO.File.WriteAllText(@"C:\observe.txt",sb.ToString());				
				// System.IO.File.WriteAllText(@"C:\centre.txt",Request.Form["CentreID"].ToString());
				// System.IO.File.WriteAllText(@"C:\mac.txt",Request.Form["MachineID"].ToString());
				// System.IO.File.WriteAllText(@"C:\params.txt",Request.Form["ParameterID"].ToString());
				// System.IO.File.WriteAllText(@"C:\from.txt",Request.Form["fromDate"].ToString());
				// System.IO.File.WriteAllText(@"C:\to.txt",sb.ToString());
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {

                    List<string> CentreID = new List<string>();
                    CentreID = Request.Form["CentreID"].ToString().Split(',').ToList<string>();

                    List<string> TestCentreID = new List<string>();
                    TestCentreID = Request.Form["TestCentreID"].ToString().Split(',').ToList<string>();

                    List<string> MachineID = new List<string>();
                    MachineID = Request.Form["MachineID"].ToString().Split(',').ToList<string>();

                    List<string> ParameterID = new List<string>();
                    ParameterID = Request.Form["ParameterID"].Split(',').ToList<string>();					
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", CentreID), string.Concat( "'",string.Join("','", MachineID),"'"), string.Join(",", ParameterID), string.Join(",", TestCentreID)), con))
                    {
                        for (int i = 0; i < CentreID.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), CentreID[i]);
                        }
                        for (int i = 0; i < MachineID.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@d", i), MachineID[i]);
                        }
                        for (int i = 0; i < ParameterID.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), ParameterID[i]);
                        }
                        for (int i = 0; i < TestCentreID.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@t", i), TestCentreID[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Util.GetDateTime(Request.Form["fromDate"]).ToString("yyyy-MM-dd"), " ", "00:00:00"));
                        da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Util.GetDateTime(Request.Form["toDate"]).ToString("yyyy-MM-dd"), " ", "23:59:59"));
                        da.Fill(dt);

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            if (Request.Form["ReportFormat"].ToString() == "1")
                            {
                                sb = new StringBuilder();
                                sb.Append(" <div style='width:1000px;'> ");
                                sb.Append("<table style='width: 1000px;border-collapse: collapse;font-family:Arial;'>");
                                //Adding DataRow.

                                sb.Append(" <tr> ");
                                foreach (DataColumn column in dt.Columns)//set table header dynamic
                                {
                                    sb.Append(" <td style='width: 10%;font-weight: bold;border-bottom: 2px solid;border-top: 2px solid;font-size: 16px !important;word-wrap: break-word;padding-bottom:30px;'>" + column.ColumnName.ToString() + "</td> ");
                                }
                                sb.Append(" </tr> ");

                                foreach (DataRow row in dt.Rows)//set table row dynamic
                                {
                                    sb.Append("<tr>");
                                    foreach (DataColumn column in dt.Columns)
                                    {
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", row[column.ColumnName].ToString());
                                    }
                                    sb.Append("</tr>");
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
                                Session["ReportName"] = "LabObservation Analysis Report";
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
        sb.Append("<table style='width: 1000px;border-collapse: collapse;font-family:Arial;'>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;'>");

        sb.AppendFormat("<span style='font-weight: bold;font-size:20px;'>{0}</span><br />", "LabObservation Analysis Report");

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
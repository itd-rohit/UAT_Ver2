using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_LabReport_InfectionControlReportPdf : System.Web.UI.Page
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
                StringBuilder sb = new StringBuilder();

                sb.Append(" SELECT (select centre from centre_master where centreid=lt.centreid)BookingCentre, ");
                sb.Append(" (select centre from centre_master where centreid=pli.testcentreid)TestCentre, ");
                sb.Append(" date_format(lt.Date,'%d-%b-%Y %h:%i %p') BookingDate ,lt.LedgerTransactionNo,lt.Patient_ID UHID,lt.PName PatientName,concat(lt.Age,'/', lt.Gender)Age, lt.`PanelName` PanelName,");
                sb.Append(" pli.Investigation_ID,pli.ItemName InvestigationName,date_format(pli.ResultEnteredDate,'%d-%b-%Y %h:%i %p') ResultEnteredDate, ");
                sb.Append("  date_format(pli.ApprovedDate,'%d-%b-%Y %h:%i %p')ApprovedDate,Plo.LabObservationName,plo.Value  ");
                sb.Append(" FROM patient_labinvestigation_opd pli ");
                sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionID=pli.LedgerTransactionID ");
                sb.Append(" INNER JOIN patient_labobservation_opd plo ON plo.Test_ID=pli.Test_ID  ");
                sb.Append(" INNER JOIN investigation_master_infectioncontrol ICM on ICM.LabObservation_ID = plo.LabObservation_ID  and  ICM.IsActive=1 ");
                sb.Append("    WHERE   ");
                sb.Append("   ( plo.Flag ='High' OR plo.Flag='Low' ) ");
                sb.Append("  AND pli.ApprovedDate >=@fromDate AND pli.ApprovedDate <= @toDate ");
                if (Request.Form["CentreID"].ToString() != string.Empty)
                {
                    sb.Append(" AND pli.`TestCentreID` IN ({0}) ");
                }
                sb.Append(" order by pli.date,lt.LedgerTransactionNo,pli.ItemName");

                List<string> CentreDataList = new List<string>();
                CentreDataList = Request.Form["CentreID"].ToString().Split(',').ToList<string>();

                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", CentreDataList)), con))
                    {
                        for (int i = 0; i < CentreDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), CentreDataList[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@fromDate", Request.Form["fromDate"].ToString());
                        da.SelectCommand.Parameters.AddWithValue("@toDate", Request.Form["toDate"].ToString());
                        da.SelectCommand.Parameters.AddWithValue("@CentreID", Request.Form["CentreID"].ToString());
                        da.Fill(dt);

                        CentreDataList.Clear();

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            if (Request.Form["ReportFormat"].ToString() == "1")
                            {                              
                                sb = new StringBuilder();

                                sb.Append(" <div style='width:1000px;'>");
                                sb.Append(" <table style='width: 100%; border-collapse: collapse;padding-top:6px;'> ");
                                sb.Append(" <tr> ");
                                sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Test Centre</td> ");
                                sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Booking Centre</td> ");
                                sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>LabNo</td> ");
                                sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>PatientName</td> ");
                                sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Age/Gender</td> ");

                                sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Client Name</td> ");
                                sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Investigation Name</td> ");
                                sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Observation Name</td> ");
                                sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>ResultDate</td> ");
                                sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>ApprovedDate</td> ");
                                sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 14px;border-top: 2px solid; border-bottom: 2px solid;'>Value</td> ");

                                sb.Append(" </tr> ");
                                for (int i = 0; i < dt.Rows.Count; i++)
                                {
                                    sb.Append("<tr> ");
                                    sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dt.Rows[i]["BookingCentre"]) + "</td> ");
                                    sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dt.Rows[i]["TestCentre"]) + "</td> ");
                                    sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dt.Rows[i]["LedgerTransactionNo"]) + "</td> ");
                                    sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dt.Rows[i]["PatientName"]) + "</td> ");
                                    sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dt.Rows[i]["Age"]) + "</td> ");
                                    sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dt.Rows[i]["PanelName"]) + "</td> ");
                                    sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dt.Rows[i]["InvestigationName"]) + "</td> ");

                                    sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dt.Rows[i]["LabObservationName"]) + "</td> ");
                                    sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dt.Rows[i]["ResultEnteredDate"]) + "</td> ");
                                    sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dt.Rows[i]["ApprovedDate"]) + "</td> ");
                                    sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dt.Rows[i]["Value"]) + "</td> ");
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
                                Session["ReportName"] = "Infection Control Report";
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
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Infection Control Report </span><br />");

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
}
using HiQPdf;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_LabReport_SampleRejectionReportPdf : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;

    int MarginLeft = 20;
    int MarginRight = 20;
    int PageWidth = 550;
    int BrowserWidth = 800;

    float HeaderHeight = 80;
    int XHeader = 20;
    int YHeader = 20;
    int HeaderBrowserWidth = 800;

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
                DataTable dtSummary = new DataTable();
                StringBuilder sb = new StringBuilder();
                sb = new StringBuilder();
                sb.Append("  SELECT '' TypeOfTnx,psr.Patient_ID MRNO,psr.LedgerTransactionNo AS LedgerTransactionNo,  ");
                sb.Append(" CONCAT(pm.Title,pm.PName)PNAME,CONCAT(pm.Age,'/',pm.Gender) AS Age,pm.Gender, ");
                sb.Append(" TRIM(CONCAT(CONCAT(IFNULL(pm.Phone,''),'',IFNULL(pm.Mobile,'')))) Phone,pm.locality Address,  ");
                if (Request.Form["reportformat"].ToString() == "2")
                {
                    sb.Append("plo.ItemCode InvCode,");
                }
                sb.Append("plo.ItemName InvName,");
                if (Request.Form["reportformat"].ToString() == "2")
                {
                    sb.Append("SUM((plo.`Rate`*plo.quantity))MRP,SUM(plo.`DiscountAmt`)DiscountAmt,SUM(plo.`Amount`) NetAmount,");
                }
                sb.Append("   psr.RejectionReason,DATE_FORMAT(psr.EntDate,'%d-%b-%Y %I:%i%p') RejectionDate,em.Name RejectedBy, ");
                sb.Append(" plo.`SampleCollectionBy` samplereceivedby,plo.`SampleCollector` samplereceiver,DATE_FORMAT(plo.`SampleCollectionDate`,'%d-%b-%Y %I:%i%p') ReceiveDate   ");
                sb.Append(" FROM patient_sample_Rejection  psr  ");
                sb.Append("  INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID=psr.test_ID   ");
                sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID=plo.Patient_ID  ");
                sb.Append("  AND psr.EntDate>=@fromDate ");
                sb.Append(" AND psr.EntDate<=@toDate ");
                if (Request.Form["CentreID"].ToString() != string.Empty)
                {
                    sb.Append("   AND plo.CentreID IN  ({0}) ");
                }
                if (Request.Form["TestCentre"].ToString() != string.Empty)
                {
                    sb.Append("   AND plo.`TestCentreID` IN ({1}) ");
                }
                sb.Append(" INNER JOIN employee_master em ON em.Employee_ID=psr.UserID  ");
                if (Request.Form["DepartmentID"].ToString() != string.Empty)
                {
                    sb.Append(" INNER JOIN `investigation_observationtype` iot ON iot.Investigation_Id=plo.Investigation_Id  ");
                    sb.Append("  AND iot.ObservationType_ID IN ({2}) ");
                }
                sb.Append("  ORDER BY psr.LedgerTransactionNo  ");

                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    List<string> CentreID = new List<string>();
                    CentreID = Request.Form["CentreID"].ToString().Split(',').ToList<string>();

                    List<string> TestCentreID = new List<string>();
                    TestCentreID = Request.Form["TestCentre"].ToString().Split(',').ToList<string>();

                    List<string> DepartmentID = new List<string>();
                    DepartmentID = Request.Form["DepartmentID"].Split(',').ToList<string>();

                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", CentreID), string.Join(",", TestCentreID), string.Join(",", DepartmentID)), con))
                    {
                        for (int i = 0; i < CentreID.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), CentreID[i]);
                        }
                        for (int i = 0; i < TestCentreID.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@b", i), TestCentreID[i]);
                        }
                        for (int i = 0; i < DepartmentID.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), DepartmentID[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Util.GetDateTime(Request.Form["fromDate"]).ToString("yyyy-MM-dd"), " ", "00:00:00"));
                        da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Util.GetDateTime(Request.Form["toDate"]).ToString("yyyy-MM-dd"), " ", "23:59:59"));
                        da.Fill(dt);
                       
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            if (Request.Form["reportformat"].ToString() == "1")
                            {
                               
                                sb = new StringBuilder();
                                sb.Append("      SELECT plo.`Investigation_Id`,otm.`Name` Department, plo.`ItemName` ServiceName,COUNT(*) SampleCount,  ");
                                sb.Append("   0 ActivityCount   ");
                                sb.Append("   FROM patient_sample_Rejection psr           ");
                                sb.Append("   INNER JOIN patient_labinvestigation_opd  plo ON psr.`Test_ID`=plo.`Test_ID`  ");
                                if (Request.Form["CentreID"].ToString() != string.Empty)
                                {
                                    sb.Append("     AND plo.CentreID IN  ({0}) ");
                                }
                                if (Request.Form["TestCentre"].ToString() != string.Empty)
                                {
                                    sb.Append("   AND plo.`TestCentreID` IN ({1}) ");
                                }
                                sb.Append("   AND psr.EntDate>= @fromDate ");
                                sb.Append("   AND  psr.EntDate<=@toDate  ");
                                sb.Append("  INNER JOIN `investigation_observationtype` iot  ON plo.`Investigation_ID`=  iot.`Investigation_ID`   ");
                                sb.Append(" INNER JOIN `observationtype_master` otm ON otm.`ObservationType_ID`=iot.`ObservationType_Id`      ");
                                if (Request.Form["DepartmentID"].ToString() != string.Empty)
                                {
                                    sb.Append("    AND otm.ObservationType_ID IN ({2}) ");
                                }
                                sb.Append("   GROUP BY plo.`Investigation_ID`  ");
                                sb.Append("   ORDER BY Department,ServiceName ");

                                using (MySqlDataAdapter da1 = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", CentreID), string.Join(",", TestCentreID), string.Join(",", DepartmentID)), con))
                                {
                                    for (int i = 0; i < CentreID.Count; i++)
                                    {
                                        da1.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), CentreID[i]);
                                    }
                                    for (int i = 0; i < TestCentreID.Count; i++)
                                    {
                                        da.SelectCommand.Parameters.AddWithValue(string.Concat("@c", i), TestCentreID[i]);
                                    }
                                    for (int i = 0; i < DepartmentID.Count; i++)
                                    {
                                        da1.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), DepartmentID[i]);
                                    }
                                    da1.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Util.GetDateTime(Request.Form["fromDate"]).ToString("yyyy-MM-dd"), " ", "00:00:00"));
                                    da1.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Util.GetDateTime(Request.Form["toDate"]).ToString("yyyy-MM-dd"), " ", "23:59:59"));
                                    da1.Fill(dtSummary);


                                    CentreID.Clear();
                                    DepartmentID.Clear();
                                    sb = new StringBuilder();
                                    sb.Append(" <div style='width:1300px;'> ");
                                    sb.Append("<table style='width: 1300px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");


                                    for (int i = 0; i < dt.Rows.Count; i++)
                                    {

                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td style='width: 3%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetInt(i + 1));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["LedgerTransactionNo"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["PNAME"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["Age"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["Phone"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["Address"]));
                                        sb.AppendFormat(" <td style='width: 15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["InvName"]));
                                        sb.AppendFormat(" <td style='width: 12%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["RejectionReason"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["RejectionDate"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["RejectedBy"]));

                                        sb.Append(" </tr> ");
                                    }

                                    sb.Append("</table>");
                                    sb.Append("</div>");
                                    if (dtSummary.Rows.Count > 0)
                                    {
                                    
                                        sb.Append(" <div style='width:1300px;'> ");
                                        sb.Append("<table style='width: 1300px;border-collapse: collapse;font-family:Arial;border:1px solid;padding-top:70px'>");

                                        sb.Append(" <tr > ");
                                        sb.Append(" <td style='width: 20%;border-bottom: 1px solid;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'></td> ");
                                        sb.Append(" <td style='width: 20%;border-bottom: 1px solid;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Department</td> ");
                                        sb.Append(" <td style='width: 20%;border-bottom: 1px solid;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Service Name</td> ");
                                        sb.Append(" <td style='width: 20%;border-bottom: 1px solid;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Sample Rejected Count</td> ");
                                        sb.Append(" <td style='width: 20%;border-bottom: 1px solid;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'></td> ");

                                        sb.Append("</tr>");
                                        for (int i = 0; i < dtSummary.Rows.Count; i++)
                                        {
                                            sb.Append("<tr> ");
                                            sb.Append(" <td style='width: 20%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                            sb.AppendFormat(" <td style='width: 20%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtSummary.Rows[i]["Department"]));
                                            sb.AppendFormat(" <td style='width: 20%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtSummary.Rows[i]["ServiceName"]));
                                            sb.AppendFormat(" <td style='width: 20%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtSummary.Rows[i]["SampleCount"]));
                                            sb.Append(" <td style='width: 20%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'></td> ");
                                            sb.Append(" </tr> ");
                                        }
                                        sb.Append("</table>");
                                        sb.Append("</div>");
                                    }
                                  
                                    AddContent(sb.ToString());
                                    SetFooter(tempDocument.Pages[tempDocument.Pages.Count - 1]);
                                    mergeDocument();
                                    byte[] pdfBuffer = document.WriteToMemory();
                                    HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
                                    HttpContext.Current.Response.BinaryWrite(pdfBuffer);
                                    HttpContext.Current.Response.End();
                                }
                            }
                            else
                            {
                                Session["dtExport2Excel"] = dt;
                                Session["Period"] = Period;
                                Session["ReportName"] = "Sample Rejection Report";//Sample Rejection Report//Service Wise Collection Report
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
        sb.Append(" <div style='width:1300px;'> ");
        sb.Append("<table style='width: 1300px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;'>");

        sb.Append("<span style='font-weight: bold;font-size:20px;'>Sample Rejection Report</span><br />");

        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        sb.AppendFormat(" <span style='font-size: 14px;'>{0}</span>", Period);
        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("</table>");
        sb.Append(" </div> ");
        sb.Append(" <div style='width:1300px;'>");
        sb.Append("<table style='width:1300px;border-top:2px solid #000;border-bottom:2px solid #000; font-family:Times New Roman;font-size:16px;'>");

        sb.Append(" <tr> ");
        sb.Append(" <td style='width: 3%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>SrNo.</td> ");
        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Lab No</td> ");
        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Patient Name</td> ");
        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Age</td> ");
        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>MobileNo</td> ");
        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Address</td> ");
        sb.Append(" <td style='width: 15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Investigation</td> ");
        sb.Append(" <td style='width: 12%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Rejection Reason</td> ");

        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Rejection Date</td> ");
        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Rejected By</td> ");
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
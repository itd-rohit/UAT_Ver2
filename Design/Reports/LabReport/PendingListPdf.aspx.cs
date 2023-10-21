﻿using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_LabReport_PendingListPdf : System.Web.UI.Page
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
    int YHeader = 10;
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
                //string TestCentreId = Request.Form["TestCentreId"].ToString();
                DataTable dt = new DataTable();
                StringBuilder sb = new StringBuilder();
                sb = new StringBuilder();
                sb.Append(" SELECT  plo.LedgerTransactionNo LabNo,plo.BarcodeNo,lt.PName,lt.Panel_ID,lt.PanelName,");
                sb.Append(" DATE_FORMAT(lt.Date,'%d/%m/%Y %H:%s %p') RegDateTime,plo.ItemName,DATE_FORMAT(plo.SampleCollectionDate,'%d/%m/%Y %H:%s %p')SampleCollDateTime,DATE_FORMAT(plo.DeliveryDate,'%d/%m/%Y %H:%s %p') DeliveryDate,");
                sb.Append(" (CASE WHEN approved='1' THEN 'Result Approved' WHEN result_flag='1' THEN 'Result Done' ");
                sb.Append(" WHEN plo.IsSampleCollected='Y' THEN 'Sample Receive' ELSE 'Sample Not Collected' END ) CurrentStatus,plo.SubCategoryID,plo.SubcategoryName FROM patient_labinvestigation_opd plo  ");
                sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=plo.LedgerTransactionNo  ");
                if (Request.Form["CentreId"].ToString() != string.Empty && Request.Form["CentreId"].ToString() != "ALL")
                {
                    sb.Append(" and lt.CentreID in ({0}) ");
                }
                sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.SubCategoryID=plo.SubCategoryID  ");
                sb.Append(" WHERE ( plo.approved=0 OR plo.isHold=1 ) AND scm.CategoryID='LSHHI3'   ");
                if (Request.Form["DepartmentID"].ToString() != string.Empty)
                    sb.Append(" and scm.SubCategoryID in ({2})  ");

                if (Request.Form["TestCentreId"].ToString() != string.Empty)
                {
                    sb.Append(" AND plo.`TestCentreID` IN ({1})  ");
                }
                sb.Append(" AND " + Request.Form["DateType"] + " >=@fromDate  ");
                sb.Append(" AND " + Request.Form["DateType"] + " <=@toDate ");

                List<string> CentreID = new List<string>();
                CentreID = Request.Form["CentreId"].ToString().Split(',').ToList<string>();

                List<string> TestCentreID = new List<string>();
                TestCentreID = Request.Form["TestCentreId"].ToString().Split(',').ToList<string>();

                List<string> DepartmentID = new List<string>();
                DepartmentID = Request.Form["DepartmentID"].ToString().Split(',').ToList<string>();

                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", CentreID),string.Join(",", TestCentreID), string.Join(",", DepartmentID)), con))
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

                        da.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Request.Form["fromDate"].ToString(), " 00:00:00"));
                        da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Request.Form["toDate"].ToString(), " 23:59:59"));
                      
                        if (Request.Form["CentreId"].ToString() != string.Empty && Request.Form["CentreId"].ToString() != "ALL")
                            da.SelectCommand.Parameters.AddWithValue("@CentreId", Request.Form["CentreId"].ToString());

                        if (Request.Form["TestCentreId"].ToString() != string.Empty)
                            da.SelectCommand.Parameters.AddWithValue("@TestCentreId", Request.Form["TestCentreId"].ToString());
                       
                        if (Request.Form["DepartmentID"].ToString() != string.Empty)
                            da.SelectCommand.Parameters.AddWithValue("@DepartmentID", Request.Form["DepartmentID"].ToString());
                       
                        da.Fill(dt);


                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            if (Request.Form["ReportFormat"].ToString() == "1")
                            {
                                sb = new StringBuilder();
                                sb.Append(" <div style='width:1300px;'> ");
                                sb.Append("<table style='width: 1300px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");

                              
                                    for (int i = 0; i < dt.Rows.Count; i++)
                                    {
                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td style='width: 3%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetInt(i + 1));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["LabNo"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["BarcodeNo"]));
                                        sb.AppendFormat(" <td style='width: 9%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["PName"]));
                                        sb.AppendFormat(" <td style='width: 9%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["SubcategoryName"]));
                                        sb.AppendFormat(" <td style='width: 13%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["ItemName"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["PanelName"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["RegDateTime"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["SampleCollDateTime"]));
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["DeliveryDate"]));
                                        sb.AppendFormat(" <td style='width: 12%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["CurrentStatus"]));


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
                                Session["Period"] = Period;
                                Session["ReportName"] = "TAT Report";
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
        sb.Append("<table style='width: 1300px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;'>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;'>");

        sb.Append("<span style='font-weight: bold;font-size:20px;'>Pending Test Report</span><br />");

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
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>LabNo</td> ");
        sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>BarcodeNo</td> ");
        sb.Append(" <td style='width: 9%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Patient Name</td> ");
        sb.Append(" <td style='width: 9%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Department</td> ");
        sb.Append(" <td style='width: 13%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Item Name</td> ");
        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Client Name</td> ");
        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Reg. Date</td> ");
        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Sample Collection Date</td> ");
        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Delivery date</td> ");
        sb.Append(" <td style='width: 12%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Status</td> ");
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
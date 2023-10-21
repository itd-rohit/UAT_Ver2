using CrystalDecisions.CrystalReports.Engine;
using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;

public partial class Design_Lab_DeltacheckNewPdf : System.Web.UI.Page
{
    private DataTable dtDepartment = new DataTable();

    private DataTable dt;

    public string PID = "";

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
    string Patinfo = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            document = new PdfDocument();
            tempDocument = new PdfDocument();
            document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
            // PID = StockReports.ExecuteScalar("select patient_id from f_ledgertransaction where LedgerTransactionNo='" + Util.GetString(Request.QueryString["LedgerTransactionNo"]) + "'  ");

            loadotherata();
        }
    }

    private DataTable GetDistinctRecords(DataTable dt, string[] Columns)
    {
        DataTable dtUniqRecords = new DataTable();
        dtUniqRecords = dt.DefaultView.ToTable(true, Columns);
        return dtUniqRecords;
    }

    public void bind_Dep()
    {
        string[] TobeDistinct = { "DEPARTMENT", "PARAM_NAME" };
        DataTable dtSet = GetDistinctRecords(dt, TobeDistinct);
        //DataTable dttem = dt;

        int aa = 0;

       
    }

    public void loadotherata()
    {
       
       
        try
        {
            PID = StockReports.ExecuteScalar("select patient_id from f_ledgertransaction where LedgerTransactionNo='" + Util.GetString(Request.QueryString["LedgerTransactionNo"]) + "'  ");

            StringBuilder sb = new StringBuilder();
          

            sb = new StringBuilder();
            sb.Append("   SELECT    DATE_FORMAT(pli.ResultEnteredDate,'%d-%b-%y %h:%i:%s') as TST_DATE, DATE_FORMAT(plo.ResultDateTime,'%h:%i:%s')  AS TST_TIME,   ");//pli.LedgerTransactionNo AS LAB_NO,
         //   sb.Append("   PATTITLE,   ");// pli.SlideNumber LIS_NO, '' IPD_NO,REPLACE(pli.Patient_ID,'LSHHI','') OPD_NO,
            sb.Append(" CONCAT(pm.Title, ' ', pm.Pname) PATIENT_NAME, pm.Age AS AGE, replace(otm.Name,' ','') DEPARTMENT,  otm.ID AS Dept_id,  ");
            sb.Append("   REPLACE(plo.LabObservationName,' ','') PARAM_NAME,   ");
            sb.Append("  plo.Value     ");//'' DOCTOR
            sb.Append("   FROM patient_labobservation_opd plo INNER JOIN patient_labinvestigation_opd pli ON plo.test_ID=pli.Test_ID  ");
            //AND pli.Patient_ID='" + PID + "'// AND pli.Approved=1
            sb.Append("   inner JOIN investigation_master im ON im.investigation_ID=pli.investigation_id   ");
            sb.Append("  INNER JOIN investigation_observationtype iot ON iot.investigation_ID=im.investigation_ID ");
            sb.Append("  INNER JOIN observationtype_master otm ON otm.ObservationType_ID=iot.ObservationType_ID ");
            sb.Append("  INNER JOIN patient_master pm ON pm.Patient_ID=pli.Patient_ID  INNER  JOIN  `f_ledgertransaction` lt  ON lt.`LedgerTransactionNo` = pli.`LedgerTransactionNo` ");
            sb.Append(" and plo.Value<>'HEAD'  AND pli.Patient_ID='" + PID + "'  order by plo.ResultDateTime  "); 
            dt = new DataTable();
           // System.IO.File.WriteAllText(@"D:\itdoes\pksaha\ErrorLog\11NOVMDeltacheck1.txt",sb.ToString());
            dt = StockReports.GetDataTable(sb.ToString());

         
            dtDepartment = dt.Clone();

            bind_Dep();

            //dtDepartment

           
        

            if (dt != null && dt.Rows.Count > 0)
            {
                Patinfo = string.Concat(" Patient Name :", dt.Rows[0]["PATIENT_NAME"].ToString(), " Of :", dt.Rows[0]["Age"].ToString());
              
                    sb = new StringBuilder();
                    sb.Append(" <div style='width:1000px;'> ");
                    sb.Append("<table style='width: 1000px;border-collapse: collapse;font-family:Arial;'>");
                    //Adding DataRow.

                    sb.Append(" <tr> ");

                    var distinctcolumn = (from DataRow drw in dt.Rows
                                          select new { TST_DATE = drw["TST_DATE"] }).Distinct().ToList();

                    sb.Append(" <td style='text-align:center;width: 10%;font-weight: bold;border: 2px solid;font-size: 14px !important;word-wrap: break-word;padding-bottom:30px;'>Parameter Name</td> ");
                    for (int j = 0; j < distinctcolumn.Count; j++)
                    {
                        sb.Append(" <td style='text-align:center;width: 10%;font-weight: bold;border: 2px solid;font-size: 14px !important;word-wrap: break-word;padding-bottom:30px;'>" + distinctcolumn[j].TST_DATE + "</td> ");
                    }
                    sb.Append(" </tr> ");

                    var distinctDept = (from DataRow drw in dt.Rows
                                        select new { DEPARTMENT = drw["DEPARTMENT"], Deptid = drw["Dept_id"]  }).Distinct().ToList();

                    for (int j = 0; j < distinctDept.Count; j++)
                    {
                        sb.Append(" <tr> ");
                        sb.Append(" <td style='text-align:left;width: 10%;font-weight: bold;border: 2px solid;font-size: 18px !important;word-wrap: break-word;padding-bottom:30px;' Colspan=" + distinctcolumn.Count + 1 + ">" + distinctDept[j].DEPARTMENT + "</td> ");
                        sb.Append(" </tr> ");


                        DataTable dtItem = dt.AsEnumerable().Where(x => x.Field<int>("Dept_id") == Util.GetInt(distinctDept[j].Deptid)).CopyToDataTable();
                        List<string> li = new List<string>();
                        for (int i = 0; i < dtItem.Rows.Count; i++)
                        {
                           
                            if (!li.Contains(Util.GetString(dtItem.Rows[i]["PARAM_NAME"])))
                            {
                                sb.Append(" <tr> ");
                                sb.Append(" <td style='text-align:left;width: 10%;font-weight: bold;border: 2px solid;font-size: 14px !important;word-wrap: break-word;'>" + dtItem.Rows[i]["PARAM_NAME"] + "</td> ");
                                for (int k = 0; k < distinctcolumn.Count; k++)
                                {
                                    var distinctvalue = (from DataRow drw in dt.Rows
                                                         where drw.Field<string>("PARAM_NAME") == Util.GetString(dtItem.Rows[i]["PARAM_NAME"])
                                                        && drw.Field<string>("TST_DATE") == Util.GetString(distinctcolumn[k].TST_DATE)
                                                         select new { Value = drw["Value"] }).Distinct().ToList();
                                    if (distinctvalue.Count > 0)
                                    {
                                        sb.Append(" <td style='text-align:center;width: 10%;font-weight: bold;border: 2px solid;font-size: 14px !important;word-wrap: break-word;padding-bottom:30px;'>" + distinctvalue[0].Value + "</td> ");
                                    }
                                    else
                                    {
                                        sb.Append(" <td style='text-align:center;width: 10%;font-weight: bold;border: 2px solid;font-size: 14px !important;word-wrap: break-word;padding-bottom:30px;'></td> ");
                                    }
                                }
                                sb.Append(" </tr> ");
                            }
                            li.Add(Util.GetString(dtItem.Rows[i]["PARAM_NAME"]));
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
                Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> No Record Found<span><br/></center>");
                return;
            }
          
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
       
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

        sb.AppendFormat("<span style='font-weight: bold;font-size:20px;'>{0}</span><br />", "Patient History & Investigation at-a-Glance (Delta-Check)");

        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: left;padding-top: 1em;'>");
        sb.AppendFormat(" <span style='font-size: 14px; font-weight: bold;'>{0}</span>", Patinfo);
        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("</table>");
        sb.Append(" </div> ");

        return sb.ToString();
    }
    public class getDetail
    {
        public int Dept_id { get; set; }
    }
}
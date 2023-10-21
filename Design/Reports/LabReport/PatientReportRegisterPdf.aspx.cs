using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_LabReport_PatientReportRegisterPdf : System.Web.UI.Page
{

    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;

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
    string CentreName = "";
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

                sb.Append(" select DATE_FORMAT(plo.Date, '%d-%b-%Y')Date ,CONCAT(plo.`LedgerTransactionNo`,' ',pm.`Title`,' ',pm.`PName`,' ',pm.`Age`,'',plo.`Gender`)PatientDetails,plo.ItemName TestName, ");
                sb.Append(" plo.SubcategoryName,plo.ApprovedName ReportingDr,GROUP_CONCAT(IFNULL(plob.`Value`,CONCAT('Gross Examination:',ploh.`Gross`,'Microscopy:',ploh.`Microscopic`,'Final Impression:',ploh.`Impression`))) Result   ");
                    sb.Append(" from patient_labinvestigation_opd  plo ");
                    sb.Append(" INNER JOIN  `patient_master` pm ON plo.`Patient_ID`=pm.`Patient_ID` ");
					sb.Append(" LEFT JOIN  `patient_labobservation_opd` plob ON plob.`Test_ID`=plo.`Test_ID` ");
					sb.Append(" LEFT JOIN  `patient_labobservation_histo` ploh ON ploh.`Test_ID`=plo.`Test_ID`  ");
                    sb.Append(" where plo.`IsActive`=1 AND plo.`Approved`='1' ");
                    sb.Append(" and plo.Date>=@fromDate and plo.Date<=@toDate ");
                    if (Request.Form["CentreID"].ToString() != string.Empty)
                    {
                        sb.Append(" and plo.CentreID=@CentreID ");
                    }
                    sb.Append(" and plo.ItemID in ({0}) ");
                    //sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append(" group by plo.BarcodeNo ");
                    sb.Append(" order by plo.SubcategoryName,plo.ItemName ");
              
                List<string> ItemDataList = new List<string>();
                ItemDataList = Request.Form["ItemID"].ToString().Split(',').ToList<string>();

                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", ItemDataList)), con))
                    {
                        for (int i = 0; i < ItemDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), ItemDataList[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@fromDate", Request.Form["fromDate"].ToString());
                        da.SelectCommand.Parameters.AddWithValue("@toDate", Request.Form["toDate"].ToString());
                        da.SelectCommand.Parameters.AddWithValue("@CentreID", Request.Form["CentreID"].ToString());
                        da.Fill(dt);

                        ItemDataList.Clear();

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            
                            
                                Session["dtExport2Excel"] = dt;
                                Session["ReportName"] = "Patient Report Register";
                                Response.Redirect("../../common/ExportToExcel.aspx");
                           
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
        //sb.Append(" <div style='width:1000px;'> ");
        //sb.Append("<table style='width: 1000px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
        //sb.Append("<tr>");
        //sb.Append("<td style='width:100%; text-align: center;'>");
        //if (Request.Form["ReportType"].ToString() == "Summary")
        //    sb.Append("<span style='font-weight: bold;font-size:20px;'>Investigation Analysis Report(Summary) </span><br />");
        //else
        //    sb.Append("<span style='font-weight: bold;font-size:20px;'>Investigation Analysis Report(Detail) </span><br />");

        //sb.Append("</td>");
        //sb.Append("</tr>");
        //sb.Append("<tr>");
        //sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        //sb.AppendFormat(" <span style='font-size: 14px;'>{0}</span>", Period);
        //sb.Append("</td>");
        //sb.Append("</tr>");
        //sb.Append("<tr>");
        //sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        //sb.AppendFormat(" <span style='font-size: 14px;'>{0}</span>", CentreName);
        //sb.Append("</td>");
        //sb.Append("</tr>");
        //sb.Append("</table>");
        //sb.Append(" </div> ");

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
        public int SubCategoryID { get; set; }
    }
    public class getInvestigationID
    {
        public int InvestigationID { get; set; }
    }
}
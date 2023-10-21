using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_LabReport_OutSourceLabReportPdf : System.Web.UI.Page
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

                sb.Append("  SELECT DATE_FORMAT(plo.SampleReceiveDate,'%d-%b-%y %H:%i:%s')SampleReceiveDate,plo.`LedgerTransactionNo` Labno,");
                sb.Append(" DATE_FORMAT(plo.`LabOutSrcDate`,'%d-%b-%y')LabOutSrcDate,plo.SubCategoryName Department,plo.`SubCategoryID`,plo.ItemName TestName,");
                sb.Append(" lt.PanelName, ");
                sb.Append(" lt.DoctorName,SUBSTRING_INDEX(plo.LabOutsrcName,'~',1) LabOutsrcName,plo.`LabOutsrcID`,");
                sb.Append(" lt.PName PatientName,CONCAT(lt.Age,'/',lt.Gender)Age,plo.LabOutSrcRate, ");
                sb.Append(" Round(IF(plo.`IsPackage`=1,'0',plo.rate),2) Rate FROM patient_labinvestigation_opd plo  ");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` and plo.IsLabOutSource=1 and plo.`IsActive`=1");
                if (Request.Form["CentreID"].ToString() != string.Empty)
                {
                    sb.Append(" AND lt.`CentreID` IN ({0}) ");
                }
                if (Request.Form["TestCentre"].ToString() != string.Empty)
                {
                    sb.Append(" AND plo.`TestCentreID` IN ({1}) ");
                }
                if (Request.Form["OutSourceCentreID"].ToString() != "")
                {
                    sb.Append(" AND plo.`LabOutsrcID` IN ({2}) ");
                }
                sb.Append(" and plo.SampleReceiveDate>=@fromDate ");
                sb.Append(" and plo.SampleReceiveDate<=@toDate ");
                sb.Append(" AND plo.`SubCategoryID`<>15 ");             

                List<string> ItemDataList = new List<string>();
                ItemDataList = Request.Form["CentreID"].ToString().Split(',').ToList<string>();

                List<string> ItemDataListTest = new List<string>();
                ItemDataListTest = Request.Form["TestCentre"].ToString().Split(',').ToList<string>();

                List<string> outCentreDataList = new List<string>();
                outCentreDataList = Request.Form["OutSourceCentreID"].ToString().Split(',').ToList<string>();

                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", ItemDataList), string.Join(",", ItemDataListTest), string.Join(",", outCentreDataList)), con))
                    {
                        for (int i = 0; i < ItemDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), ItemDataList[i]);
                        }
                        for (int i = 0; i < ItemDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@j", i), ItemDataListTest[i]);
                        }
                        for (int i = 0; i < outCentreDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), outCentreDataList[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@fromDate", Request.Form["fromDate"].ToString());
                        da.SelectCommand.Parameters.AddWithValue("@toDate", Request.Form["toDate"].ToString());
                     
                        da.Fill(dt);

                        ItemDataList.Clear();
                        outCentreDataList.Clear();
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Request.Form["fromDate"].ToString(), " Period To :", Request.Form["toDate"].ToString());
                            if (Request.Form["ReportFormat"].ToString() == "1")
                            {                              
                                sb = new StringBuilder();
                                sb.Append(" <div style='width:1000px;'>");
                                sb.Append(" <table style='width: 100%; border-collapse: collapse;padding-top:6px;'> ");
                                var distinctLabOutsrcID = (from DataRow drw in dt.Rows
                                                   select new { LabOutsrcID = drw["LabOutsrcID"] }).Distinct().ToList();
                                for (int j = 0; j < distinctLabOutsrcID.Count; j++)
                                    {
                                        DataTable dtdept = dt.AsEnumerable().Where(x => x.Field<int>("LabOutsrcID") == Util.GetInt(distinctLabOutsrcID[j].LabOutsrcID)).CopyToDataTable();
                                        sb.Append(" <tr> ");
                                        sb.Append(" <td colspan='2' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>OutSourced Lab Name :</td> ");
                                        sb.Append(" <td colspan='7' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtdept.Rows[0]["LabOutsrcName"].ToString()) + "</td> ");
                                        sb.Append(" </tr> ");
                                        var distinctSubCategoryID = (from DataRow drw in dtdept.Rows
                                                           select new { SubCategoryID = drw["SubCategoryID"] }).Distinct().ToList();
                                        for (int k = 0; k < distinctSubCategoryID.Count; k++)
                                        {
                                            DataTable dtinv = dtdept.AsEnumerable().Where(x => x.Field<int>("SubCategoryID") == Util.GetInt(distinctSubCategoryID[k].SubCategoryID)).CopyToDataTable();
                                            sb.Append(" <tr> ");
                                            sb.Append(" <td colspan='9' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtinv.Rows[0]["Department"].ToString()) + "</td> ");
                                            sb.Append(" </tr> ");

                                            for (int i = 0; i < dtinv.Rows.Count; i++)
                                            {
                                                sb.Append("<tr> ");
                                                sb.Append(" <td style='width: 12%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["SampleReceiveDate"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["LabOutSrcDate"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["PatientName"]) + "</td> ");
                                                sb.Append(" <td style='width: 12%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["Age"]) + "</td> ");
                                                sb.Append(" <td style='width: 8%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["Labno"]) + "</td> ");
                                                sb.Append(" <td style='width: 20%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["TestName"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["DoctorName"]) + "</td> ");
                                                if (Request.Form["ReportType"].ToString() == "0")
                                                {
                                                    sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["LabOutSrcRate"]) + "</td> ");
                                                    sb.Append(" <td style='width: 8%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;text-align:right'>" + Util.GetString(dtinv.Rows[i]["Rate"]) + "</td> ");
                                                }
                                                sb.Append(" </tr> ");
                                            }                                          
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
                                Session["ReportName"] = "OutSource Sample Report";
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
      
            sb.Append("<span style='font-weight: bold;font-size:20px;'>OutSource Sample Detail </span><br />");

        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        sb.AppendFormat(" <span style='font-size: 14px;'>{0}</span>", Period);
        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("</table>");
        sb.Append(" </div> ");
        sb.Append(" <div style='width:1000px;'>");
        sb.Append(" <table style='width: 100%; border-collapse: collapse;padding-top:6px;'> ");
        sb.Append(" <tr> ");
        sb.Append(" <td style='width: 12%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>Date Collected</td> ");
        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>Date Sent</td> ");
        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>Patient Name</td> ");
        sb.Append(" <td style='width: 12%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>Age/Gender</td> ");
        sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>Lab No</td> ");

        sb.Append(" <td style='width: 20%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>Test Detail</td> ");
        sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>Refferd By</td> ");
        if (Request.Form["ReportType"].ToString() == "0")
        {
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>OutSrc Rate</td> ");
            sb.Append(" <td style='width: 8%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;text-align:right'>Rate</td> ");
        }
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
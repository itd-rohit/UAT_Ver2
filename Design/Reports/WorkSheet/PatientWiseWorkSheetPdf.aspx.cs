using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_WorkSheet_PatientWiseWorkSheetPdf : System.Web.UI.Page
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

                    sb = new StringBuilder();
                    sb.Append("  SELECT plo.`LedgerTransactionNo`,plo.`LedgerTransactionID`,plo.`BarcodeNo`,lt.`PName`,lt.`Age`,lt.`Gender`,lt.`DoctorName`,plo.`SubcategoryName`,plo.`ItemName`,  ");
                    sb.Append("  inv.`Name` invName,plo.`Investigation_ID`,lom.`LabObservation_ID`,lom.Name LabObservationName,plo.`SubCategoryID`,IFNULL(lr.`ReadingFormat`,'')ReadingFormat  ");
                    sb.Append(" FROM `patient_labinvestigation_opd` plo");
                    sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");

                    sb.Append(" INNER JOIN `f_panel_master` pn ON lt.`Panel_ID`=pn.`Panel_ID` ");
                    sb.Append("  INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=plo.`Investigation_ID` AND inv.ReportType<>'5' ");
                    sb.Append("   INNER JOIN labobservation_investigation loi ON inv.Investigation_Id=loi.Investigation_Id   ");
                    sb.Append("   INNER JOIN  labobservation_master lom  ON loi.labObservation_ID=lom.LabObservation_ID  ");
                    sb.Append("   LEFT OUTER JOIN labobservation_range lr ON lr.LabObservation_ID=lom.LabObservation_ID and lr.rangetype='Normal' ");
                    sb.Append("   AND lr.Investigation_ID=inv.Investigation_ID  ");
                
                    sb.Append(" WHERE plo.date >=@fromDate AND plo.date <= @toDate ");
                    if (Request.Form["SubcategoryID"].ToString() != string.Empty)
                        sb.Append(" AND plo.`SubCategoryID` IN ({0}) ");

                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND plo.`CentreID` IN ({1}) ");
                    if (Request.Form["PatientName"].ToString() != string.Empty)
                    {
                        sb.Append(" AND lt.`PName` like @PName ");
                    }
                    if (Request.Form["LabNo"].ToString() != string.Empty)
                    {
                        sb.Append(" AND plo.`LedgerTransactionNo` = @LedgerTransactionNo ");
                    }
                    if ((Request.Form["FromLabNo"].ToString() != string.Empty) && (Request.Form["ToLabNo"].ToString() != string.Empty))
                    {
                        sb.Append(" AND lt.LedgerTransactionNo >=@FromLabNo AND lt.LedgerTransactionNo<=@ToLabNo");
                    }
                    if (Request.Form["SampleStatus"].ToString() == "Approved")
                    {
                        sb.Append(" AND plo.`Approved` = 1 ");
                    }
                    if (Request.Form["SampleStatus"].ToString() == "ResultDone")
                    {
                        sb.Append(" AND plo.`Approved` = 0 and plo.Result_Flag=1 ");
                    }
                    if (Request.Form["SampleStatus"].ToString() == "ResultNotDone")
                    {
                        sb.Append("  AND plo.Result_Flag=0 ");
                    }
                    if (Request.Form["SampleStatus"].ToString() == "Hold")
                    {
                        sb.Append("  AND plo.Hold=1 AND plo.`Approved` = 0 ");
                    }
                    if (Request.Form["PanelID"].ToString() != "" && Request.Form["PanelID"].ToString()!="0")
                    {
                        sb.Append("  AND pn.Panel_ID= " + Request.Form["PanelID"].ToString() + "  ");
                    }
                   
                    sb.Append(" GROUP BY plo.`LedgerTransactionID`,plo.`Investigation_ID`,lom.LabObservation_ID  ");
                    sb.Append("  order by plo.LedgerTransactionNo");
                

                List<string> UserDataList = new List<string>();
                UserDataList = Request.Form["SubcategoryID"].ToString().Split(',').ToList<string>();

                List<string> CentreIDDataList = new List<string>();
                CentreIDDataList = Request.Form["CentreID"].Split(',').ToList<string>();
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
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
                        if (Request.Form["PatientName"].ToString()!=string.Empty)
                        da.SelectCommand.Parameters.AddWithValue("@PName", string.Concat("%" , Request.Form["PatientName"].ToString() , "%"));
                        da.SelectCommand.Parameters.AddWithValue("@LedgerTransactionNo", Request.Form["LabNo"].ToString());
                        da.SelectCommand.Parameters.AddWithValue("@FromLabNo", Request.Form["FromLabNo"].ToString());
                        da.SelectCommand.Parameters.AddWithValue("@ToLabNo", Request.Form["ToLabNo"].ToString());
                        da.Fill(dt);

                        UserDataList.Clear();
                        CentreIDDataList.Clear();


                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));

                            sb = new StringBuilder();

                        
                            var distinctlabno = (from DataRow dr in dt.Rows
                                                 select new { LedgerTransactionID = dr["LedgerTransactionID"] }).Distinct().ToList();
                            for (int k = 0; k < distinctlabno.Count; k++)
                            {
                                DataTable dtlabno = dt.AsEnumerable().Where(k2 => k2.Field<int>("LedgerTransactionID") == Util.GetInt(distinctlabno[k].LedgerTransactionID)).CopyToDataTable();
                                sb.Append(" <div style='width:1000px;'> ");
                                sb.Append("<table style='width: 1000px;border-collapse: collapse;border: 1px solid;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
                                sb.Append(" <tr> ");
                                sb.Append(" <td  style='font-size: 16px;padding-top: 10px;padding-bottom: 10px;'>LabNo : </td> ");
                                sb.Append(" <td  style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtlabno.Rows[0]["LedgerTransactionNo"].ToString()) + "</td> ");
                                sb.Append(" <td  style='font-size: 16px;padding-top: 10px;padding-bottom: 10px;'>BarcodeNo : </td> ");
                                sb.Append(" <td  style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtlabno.Rows[0]["BarcodeNo"].ToString()) + "</td> ");
                                sb.Append(" <td  style='font-size: 16px;padding-top: 10px;padding-bottom: 10px;'>PatientName : </td> ");
                                sb.Append(" <td  style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtlabno.Rows[0]["PName"].ToString()) + "</td> ");
                                sb.Append(" <td  style='font-size: 16px;padding-top: 10px;padding-bottom: 10px;'>Age/Gender : </td> ");
                                sb.Append(" <td  style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtlabno.Rows[0]["Age"].ToString()) + '/' + Util.GetString(dtlabno.Rows[0]["Gender"].ToString()) + "</td> ");                               
                                sb.Append(" </tr> ");
                                sb.Append(" <tr> ");                               
                                sb.Append(" <td  style='font-size: 16px;padding-top: 10px;padding-bottom: 10px;'>Refer By : </td> ");
                                sb.Append(" <td colspan=7 style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtlabno.Rows[0]["DoctorName"].ToString()) + "</td> ");
                                sb.Append(" </tr> ");
                                sb.Append("</table>");
                                sb.Append("</div>");

                                sb.Append(" <div style='width:1000px;'> ");
                                sb.Append("<table style='width: 1000px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");

                             
                                var distinctSubcategory = (from DataRow drw in dtlabno.Rows
                                                      select new { SubCategoryID = drw["SubCategoryID"] }).Distinct().ToList();
                                for (int j = 0; j < distinctSubcategory.Count; j++)
                                {
                                    DataTable dtDept = dtlabno.AsEnumerable().Where(x => x.Field<int>("SubCategoryID") == Util.GetInt(distinctSubcategory[j].SubCategoryID)).CopyToDataTable();
                                    sb.Append(" <tr> ");

                                    sb.Append(" <td colspan= 10; style='font-size: 16px;font-weight: bold;text-align:left;'>Department : " + Util.GetString(dtDept.Rows[0]["SubcategoryName"].ToString()) + "</td> ");
                                    sb.Append(" </tr> ");

                                    var distinctinvid = (from DataRow drinv in dtDept.Rows
                                                         select new { InvestigationID = drinv["Investigation_ID"] }).Distinct().ToList();

                                    for (int s = 0; s < distinctinvid.Count; s++)
                                    {
                                        DataTable dtinv = dtDept.AsEnumerable().Where(s2 => s2.Field<int>("Investigation_ID") == Util.GetInt(distinctinvid[s].InvestigationID)).CopyToDataTable();
                                        sb.Append(" <tr> ");                                      
                                        sb.Append(" <td colspan=10; style='font-size: 18px;font-weight: bold;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtinv.Rows[0]["invName"].ToString()) + "</td> ");
                                        sb.Append(" </tr> ");
                                        int count = 0;
                                        for (int i = 0; i < dtinv.Rows.Count; i++)
                                        {
                                            if (count == 0)
                                            {
                                                sb.Append("<tr> ");
                                            }
                                            sb.AppendFormat(" <td style='width: 20%;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtinv.Rows[i]["LabObservationName"]));
                                            sb.AppendFormat(" <td  style='width: 15%;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", "................." + Util.GetString(dtinv.Rows[i]["ReadingFormat"]));                                          
                                            count++;
                                            if (count == 3)
                                                count = 0;
                                        }
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
        sb.Append(" <div style='width:1000px;'> ");
        sb.Append("<table style='width: 1000px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;'>");
      
            sb.Append("<span style='font-weight: bold;font-size:20px;'>Work Sheet </span><br />");
      
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
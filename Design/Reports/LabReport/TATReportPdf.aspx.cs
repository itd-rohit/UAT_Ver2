using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_LabReport_TATReportPdf : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;

    int MarginLeft = 20;
    int MarginRight = 20;
    int PageWidth = 550;
    int BrowserWidth = 800;

    float HeaderHeight = 40;
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
                DataTable dt = new DataTable();
                StringBuilder sb = new StringBuilder();
                sb = new StringBuilder();
                //ForwardDate ,ForwardByName,
                sb.Append(" SELECT LabNo,BarcodeNo,PName,Age,PanelName,DATE_FORMAT(RegDateTime,'%d-%m-%Y %T')RegDateTime,DATE_FORMAT(SampleCollDateTime,'%d-%m-%Y %T')SampleCollDateTime,DATE_FORMAT(SampleReceiveDate,'%d-%m-%Y %T')DeptReceiveDate,DATE_FORMAT(ResultEnteredDate,'%d-%m-%Y %T')ResultEnteredDate ,ResultEnteredName, DATE_FORMAT(ApproveDateTime,'%d-%m-%Y %T')ApproveDateTime  ,ApprovedName , ");
                sb.Append(" TIMEDIFF(ApproveDateTime,RegDateTime) ActualTAT ,  ");
                sb.Append(" DeliveryDate SelectedDeliveryDate, ");
                sb.Append(" Deviaion,");
                sb.Append(" InvestigationName , DepartmentName ");
                sb.Append(" FROM  ");
                sb.Append("(SELECT plo.BarcodeNo,plo.ResultEnteredDate,plo.ResultEnteredName,lt.LedgerTransactionNo LabNo, lt.PName, CONCAT(lt.Age,LEFT(lt.Gender,1))Age, ");
                sb.Append(" (select company_name from f_panel_master where Panel_ID=lt.Panel_ID) PanelName,");
                sb.Append(" DATE_FORMAT(lt.Date,'%d-%b-%Y')RegDate,TIME_FORMAT(lt.`Date`,'%h:%i %p') RegTime ,");
                sb.Append(" lt.date RegDateTime , ");
                sb.Append(" plo.ApprovedDate ApproveDateTime , plo.ApprovedName ,plo.`SampleReceiveDate` ,");
                sb.Append(" DATE_FORMAT(plo.ApprovedDate,'%d-%b-%Y')ApprovedDate , plo.ForwardDate , plo.ForwardByName ,  ");
                sb.Append(" plo.SampleCollectionDate SampleCollDateTime,  ");
                sb.Append(" DATE_FORMAT(plo.ApprovedDate,'%h:%i %p')ApprovedTime , ");
                sb.Append(" plo.approved, ");
                sb.Append(" im.Name   InvestigationName,otm.Name DepartmentName , ");
                sb.Append(" if(plo.DeliveryDate <> '0001-01-01 00:00:00',DeliveryDate,'')DeliveryDate, ");
                sb.Append(" if(plo.DeliveryDate <> '0001-01-01 00:00:00' , (IF(IF(Approved=0,NOW(),plo.ApprovedDate) > plo.DeliveryDate , TIMEDIFF(IF(Approved='1',ApprovedDate,NOW()),plo.DeliveryDate), '')), '') Deviaion ");
                sb.Append(" FROM  ");
                sb.Append(" f_ledgertransaction lt  ");
                sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON lt.LedgerTransactionNo=plo.LedgerTransactionNo");



                if (Request.Form["Labno"].ToString() != string.Empty)
                    sb.Append(" and lt.LedgerTransactionNo=@Labno");

                if (Request.Form["PatientID"].ToString() != string.Empty)
                    sb.Append(" and lt.Patient_ID=@PatientID");

                if (Request.Form["CentreId"].ToString() != string.Empty && Request.Form["CentreId"].ToString() != "ALL")
                {
                    sb.Append(" and lt.CentreID=@CentreId ");
                }

                if (Request.Form["InvestigationID"].ToString() != string.Empty)
                {
                    sb.Append(" AND plo.Investigation_ID=@InvestigationID ");
                }
                if (Request.Form["barcodeno"].ToString() != string.Empty)
                    sb.Append(" AND plo.BarcodeNo = @barcodeno ");

                if (Request.Form["ChkisUrgent"].ToString() == "1")
                    sb.Append(" AND plo.isUrgent = '1' ");

                if (Request.Form["chkTATDelay"].ToString() == "1")
                    sb.Append(" AND IF(plo.Approved=0,NOW(),plo.ApprovedDate) > plo.DeliveryDate ");

                if (Request.Form["Status"].ToString() == "Approved")
                {
                    sb.Append(" and plo.Approved=1");
                }
                else if (Request.Form["Status"].ToString() == "Not Approved")
                {
                    sb.Append(" and plo.Approved=0");
                }
                else if (Request.Form["Status"].ToString() == "Result Done")
                {
                    sb.Append(" and plo.Result_Flag=1  and (plo.Approved is null or plo.Approved=0) and plo.isForward=0 and plo.isHold=0  AND plo.isPartial_Result=0  ");
                }
                else if (Request.Form["Status"].ToString() == "Result Not Done")
                {
                    sb.Append(" and plo.Result_Flag=0 ");
                }
                else if (Request.Form["Status"].ToString() == "Pending")
                {
                    sb.Append(" and plo.Result_Flag='1' AND plo.isPartial_Result='1' and plo.Approved=0 and plo.isForward=0 and plo.isHold=0 ");
                }
                else if (Request.Form["Status"].ToString() == "Forward")
                {
                    sb.Append(" and plo.isForward=1 and (plo.Approved is null or plo.Approved=0) and plo.isHold=0 ");
                }
                else if (Request.Form["Status"].ToString() == "Hold")
                {
                    sb.Append(" and plo.isHold=1 ");
                }


                if (Request.Form["SearchByDate"].ToString() == "RegisterationDate")
                    sb.Append(" AND lt.Date >= @fromDate AND lt.Date <= @toDate");
                else if (Request.Form["SearchByDate"].ToString() == "SampleCollectionDate")
                    sb.Append(" AND plo.SampleCollectionDate >= @fromDate AND plo.SampleCollectionDate <=@toDate ");
                else if (Request.Form["SearchByDate"].ToString() == "SampleReceivingDate")
                    sb.Append(" AND plo.SampleReceiveDate >= @fromDate AND plo.SampleReceiveDate <= @toDate ");

                else if (Request.Form["SearchByDate"].ToString() == "ApprovedDate")
                    sb.Append(" AND plo.ApprovedDate >=@fromDate AND plo.ApprovedDate <= @toDate");
                else if (Request.Form["SearchByDate"].ToString() == "SampleRejectionDate")
                    sb.Append(" inner join patient_sample_rejection psr on psr.Test_ID=plo.test_ID AND psr.entdate >= @fromDate AND psr.entdate <=@toDate ");
                else
                    sb.Append(" AND lt.Date >= @fromDate AND lt.Date <= @toDate ");


                sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID ");
                sb.Append(" INNER JOIN investigation_observationtype io ON io.Investigation_ID=plo.Investigation_ID ");
                sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_ID=io.ObservationType_Id  ");
                if (Request.Form["DepartmentID"].ToString() != string.Empty)
                    sb.Append(" and otm.ObservationType_ID = @DepartmentID ");

                sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID = lt.Panel_ID ");
                if (Request.Form["DoctorID"].ToString() != string.Empty)
                    sb.Append(" and lt.Doctor_ID  = @DoctorID ");

                if (Request.Form["PanelID"].ToString() != string.Empty)
                    sb.Append(" and lt.Panel_ID  = @PanelID ");

                if (Request.Form["Pname"].ToString() != string.Empty)
                    sb.Append(" and lt.PName =@Pname ");


                sb.Append(" order by plo.SampleCollectionDate,lt.LedgerTransactionNo ) TAT Order by RegDateTime ,LabNo,DepartmentName, InvestigationName ");
             
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString()), con))
                    {
                   

                        da.SelectCommand.Parameters.AddWithValue("@fromDate",string.Concat(Request.Form["fromDate"].ToString()," 00:00:00"));
                        da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Request.Form["toDate"].ToString()," 23:59:59"));
                        if (Request.Form["Labno"].ToString() != string.Empty)
                            da.SelectCommand.Parameters.AddWithValue("@Labno", Request.Form["Labno"].ToString());
                        if (Request.Form["PatientID"].ToString() != string.Empty)
                            da.SelectCommand.Parameters.AddWithValue("@PatientID", Request.Form["PatientID"].ToString());
                        if (Request.Form["CentreId"].ToString() != string.Empty && Request.Form["CentreId"].ToString() != "ALL")
                            da.SelectCommand.Parameters.AddWithValue("@CentreId", Request.Form["CentreId"].ToString());
                        if (Request.Form["InvestigationID"].ToString() != string.Empty)
                            da.SelectCommand.Parameters.AddWithValue("@InvestigationID", Request.Form["InvestigationID"].ToString());
                        if (Request.Form["barcodeno"].ToString() != string.Empty)
                            da.SelectCommand.Parameters.AddWithValue("@barcodeno", Request.Form["barcodeno"].ToString());
                        if (Request.Form["DepartmentID"].ToString() != string.Empty)
                            da.SelectCommand.Parameters.AddWithValue("@DepartmentID", Request.Form["DepartmentID"].ToString());
                        if (Request.Form["DoctorID"].ToString() != string.Empty)
                            da.SelectCommand.Parameters.AddWithValue("@DoctorID", Request.Form["DoctorID"].ToString());
                        if (Request.Form["PanelID"].ToString() != string.Empty)
                            da.SelectCommand.Parameters.AddWithValue("@PanelID", Request.Form["PanelID"].ToString());
                        if (Request.Form["Pname"].ToString() != string.Empty)
                            da.SelectCommand.Parameters.AddWithValue("@Pname", Request.Form["Pname"].ToString());
                        da.Fill(dt);

                     
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Util.GetDateTime(Request.Form["fromDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"), " Period To :", Util.GetDateTime(Request.Form["toDate"].ToString()).ToString("dd-MMM-yyyy HH:mm:ss"));
                            if (Request.Form["ReportFormat"].ToString() == "1")
                            {
                                sb = new StringBuilder();
                                sb.Append(" <div style='width:1300px;'> ");
                                sb.Append("<table style='width: 1300px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
                                sb.Append(" <tr> ");
                                sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;border-top:2px solid #000;border-bottom:2px solid #000;'>LabNo</td> ");
                                sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;border-top:2px solid #000;border-bottom:2px solid #000;'>BarcodeNo</td> ");
                                sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;border-top:2px solid #000;border-bottom:2px solid #000;'>PName</td> ");
                                sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;border-top:2px solid #000;border-bottom:2px solid #000;'>Age</td> ");
                                sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;border-top:2px solid #000;border-bottom:2px solid #000;'>Panel Name</td> ");
                                sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;border-top:2px solid #000;border-bottom:2px solid #000;'>Reg DateTime</td> ");
                                sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;border-top:2px solid #000;border-bottom:2px solid #000;'>SampleColl DateTime</td> ");
                                sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;border-top:2px solid #000;border-bottom:2px solid #000;'>DeptReceive DateTime</td> ");
                                sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;border-top:2px solid #000;border-bottom:2px solid #000;'>Result Entered Date</td> ");
                                sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;border-top:2px solid #000;border-bottom:2px solid #000;'>Result Entered Name</td> ");
                                
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;border-top:2px solid #000;border-bottom:2px solid #000;'>Investigation Name</td> ");
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;border-top:2px solid #000;border-bottom:2px solid #000;'>Approve DateTime</td> ");
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;border-top:2px solid #000;border-bottom:2px solid #000;'>Selected DeliveryDate</td> ");
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;border-top:2px solid #000;border-bottom:2px solid #000;'>Actual TAT</td> ");
                                sb.Append(" <td style='width: 6%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;border-top:2px solid #000;border-bottom:2px solid #000;'>Deviaion</td> ");
                                sb.Append(" </tr> ");
                                var distinctdoctor = (from DataRow drw in dt.Rows
                                                      select new { Employee_ID = drw["DepartmentName"] }).Distinct().ToList();
                                for (int j = 0; j < distinctdoctor.Count; j++)
                                {
                                    DataTable dtdoc = dt.AsEnumerable().Where(x => x.Field<string>("DepartmentName") == Util.GetString(distinctdoctor[j].Employee_ID)).CopyToDataTable();
                                    sb.Append(" <tr> ");

                                    sb.Append(" <td colspan='15' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>DepartmentName :" + Util.GetString(dtdoc.Rows[0]["DepartmentName"].ToString()) + "</td> ");
                                    sb.Append(" </tr> ");

                                    for (int i = 0; i < dtdoc.Rows.Count; i++)
                                    {

                                        sb.Append("<tr> ");
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["LabNo"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["BarcodeNo"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["PName"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Age"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["PanelName"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["RegDateTime"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["SampleCollDateTime"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["DeptReceiveDate"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["ResultEnteredDate"]));
                                        sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["ResultEnteredName"]));
                                        //v1
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["InvestigationName"]));
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["ApproveDateTime"]));
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["SelectedDeliveryDate"]));
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["ActualTAT"]));
                                        sb.AppendFormat(" <td style='width: 6%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dtdoc.Rows[i]["Deviaion"]));


                                        sb.Append(" </tr> ");
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

        sb.Append("<span style='font-weight: bold;font-size:20px;'>TAT Report</span><br />");

        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        sb.AppendFormat(" <span style='font-size: 14px;'>{0}</span>", Period);
        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("</table>");
        sb.Append(" </div> ");
        //sb.Append(" <div style='width:1300px;'>");
        //sb.Append("<table style='width:1300px;border-top:2px solid #000;border-bottom:2px solid #000; font-family:Times New Roman;font-size:16px;'>");

      
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
}
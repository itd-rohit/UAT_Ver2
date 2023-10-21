using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_LabReport_HighVolumeReportPdf : System.Web.UI.Page
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
                if (Request.Form["ReportType"].ToString() == "1")
                {
                    sb = new StringBuilder();
                    sb.Append("SELECT cm.CentreID,cm.Centre,plo.Investigation_ID,plo.ItemCode,plo.ItemName TestName,");
                    sb.Append(" SUM(IF(plo.IsPackage=0,plo.Quantity,0))LabCount,");
                    sb.Append(" Round(SUM(IF(plo.IsPackage=0,(plo.Mrp*Quantity),0)),2)MRP,");
                    sb.Append(" Round(SUM(IF(plo.IsPackage=0,(plo.Rate*plo.Quantity),0)),2) GrossAmt,");
                    sb.Append(" Round(SUM(IF(plo.IsPackage=0,((plo.Rate*plo.Quantity-plo.Amount)),0)),0) DiscAmt,");
                    sb.Append(" Round(SUM(IF(plo.IsPackage=0,(plo.Amount),0)),2) NetAmt,");
                    sb.Append(" SUM(IF(plo.IsPackage=1,plo.Quantity,0))PackageCount,");
                    sb.Append(" SUM(plo.Quantity)TotalQuantity,");
                    sb.Append(" plo.SubCategoryID,plo.SubcategoryName Department ");
                    sb.Append(" FROM patient_labinvestigation_opd plo");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionID=plo.LedgerTransactionID ");
                    sb.Append(" AND plo.`IsActive`=1 ");
                    sb.Append(" AND plo.Date >=@fromDate AND plo.Date<=@toDate ");
                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND plo.CentreID IN ({0}) ");
                    if (Request.Form["TestCentreID"].ToString() != string.Empty)
                        sb.Append(" AND plo.TestCentreID IN ({1}) ");

                    if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND lt.Panel_ID=@Panel_ID ");

                    if (Request.Form["DepartmentID"].ToString() != string.Empty)
                        sb.Append(" AND plo.SubCategoryID= @SubCategoryID");
                    sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID  ");
                    sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append(" GROUP BY plo.Investigation_ID ORDER BY SUM(plo.Quantity) DESC ,plo.Rate desc ");
                }
                else
                {
                    sb = new StringBuilder();
                    sb.Append("SELECT   lt.PName PatientName,plo.LedgerTransactionNo,cm.CentreID,cm.Centre,plo.Investigation_ID,plo.ItemCode,plo.ItemName TestName,");
                    sb.Append(" IF(plo.IsPackage=0,plo.Quantity,0)LabCount,");
                    sb.Append(" Round(IF(plo.IsPackage=0,(plo.Mrp*Quantity),0),2)MRP,");
                    sb.Append(" Round(IF(plo.IsPackage=0,(plo.Rate*plo.Quantity),0),2) GrossAmt,");
                    sb.Append(" Round(IF(plo.IsPackage=0,((plo.Rate*plo.Quantity-plo.Amount)),0),0) DiscAmt,");
                    sb.Append(" Round(IF(plo.IsPackage=0,(plo.Amount),0),0) NetAmt,");
                    sb.Append(" IF(plo.IsPackage=1,plo.Quantity,0)PackageCount,");
                    sb.Append(" (plo.Quantity)TotalQuantity,");
                    sb.Append(" plo.SubCategoryID,plo.SubcategoryName Department ");
                    sb.Append(" FROM patient_labinvestigation_opd plo");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionID=plo.LedgerTransactionID ");
                    sb.Append(" AND plo.`IsActive`=1 ");
                    sb.Append(" AND plo.Date >=@fromDate AND plo.Date<=@toDate ");
                    if (Request.Form["CentreID"].ToString() != string.Empty)
                        sb.Append(" AND plo.CentreID IN ({0}) ");

                    if (Request.Form["TestCentreID"].ToString() != string.Empty)
                        sb.Append(" AND plo.TestCentreID IN ({1}) ");

                    if (Request.Form["ClientID"].ToString() != string.Empty)
                        sb.Append(" AND lt.Panel_ID=@Panel_ID ");

                    if (Request.Form["DepartmentID"].ToString() != string.Empty)
                        sb.Append(" AND plo.SubCategoryID= @SubCategoryID");
                    sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID  ");
                  //  sb.Append(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append("  ORDER BY plo.LedgerTransactionNo");
                }

                List<string> ItemDataList = new List<string>();
                ItemDataList = Request.Form["CentreID"].ToString().Split(',').ToList<string>();

        

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
                        da.SelectCommand.Parameters.AddWithValue("@TestCentreID", Request.Form["TestCentreID"].ToString());
                        da.SelectCommand.Parameters.AddWithValue("@Panel_ID", Request.Form["ClientID"].ToString());
                        da.SelectCommand.Parameters.AddWithValue("@SubCategoryID", Request.Form["DepartmentID"].ToString());
                        da.Fill(dt);

                        ItemDataList.Clear();                       
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period From :", Request.Form["fromDate"].ToString(), " Period To :", Request.Form["toDate"].ToString());
                            if (Request.Form["ReportFormat"].ToString() == "1")
                            {
                                sb = new StringBuilder();
                                if (Request.Form["ReportType"].ToString() == "1")
                                {
                                    sb.Append(" <div style='width:1000px;'>");
                                    sb.Append(" <table style='width: 100%; border-collapse: collapse;padding-top:6px;'> ");
                                    var distinctCentreID = (from DataRow drw in dt.Rows
                                                            select new { CentreID = drw["CentreID"] }).Distinct().ToList();
                                    for (int j = 0; j < distinctCentreID.Count; j++)
                                    {
                                        DataTable dtdept = dt.AsEnumerable().Where(x => x.Field<int>("CentreID") == Util.GetInt(distinctCentreID[j].CentreID)).CopyToDataTable();
                                        sb.Append(" <tr> ");
                                        sb.Append(" <td colspan='2' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>Centre Name :</td> ");
                                        sb.Append(" <td colspan='7' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtdept.Rows[0]["Centre"].ToString()) + "</td> ");
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
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["ItemCode"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["TestName"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["LabCount"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["MRP"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["GrossAmt"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["DiscAmt"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["NetAmt"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["PackageCount"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["TotalQuantity"]) + "</td> ");

                                                sb.Append(" </tr> ");
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    sb.Append(" <div style='width:1000px;'>");
                                    sb.Append(" <table style='width: 100%; border-collapse: collapse;padding-top:6px;'> ");
                                    var distinctCentreID = (from DataRow drw in dt.Rows
                                                            select new { CentreID = drw["CentreID"] }).Distinct().ToList();
                                    for (int j = 0; j < distinctCentreID.Count; j++)
                                    {
                                        DataTable dtdept = dt.AsEnumerable().Where(x => x.Field<int>("CentreID") == Util.GetInt(distinctCentreID[j].CentreID)).CopyToDataTable();
                                        sb.Append(" <tr> ");
                                        sb.Append(" <td colspan='2' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>Centre Name :</td> ");
                                        sb.Append(" <td colspan='8' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtdept.Rows[0]["Centre"].ToString()) + "</td> ");
                                        sb.Append(" </tr> ");
                                        var distinctSubCategoryID = (from DataRow drw in dtdept.Rows
                                                                     select new { SubCategoryID = drw["SubCategoryID"] }).Distinct().ToList();
                                        for (int k = 0; k < distinctSubCategoryID.Count; k++)
                                        {
                                            DataTable dtinv = dtdept.AsEnumerable().Where(x => x.Field<int>("SubCategoryID") == Util.GetInt(distinctSubCategoryID[k].SubCategoryID)).CopyToDataTable();
                                            sb.Append(" <tr> ");
                                            sb.Append(" <td colspan='10' style='font-size: 16px;font-weight: bold;padding-top: 10px;padding-bottom: 10px;text-align:left;'>" + Util.GetString(dtinv.Rows[0]["Department"].ToString()) + "</td> ");
                                            sb.Append(" </tr> ");

                                            for (int i = 0; i < dtinv.Rows.Count; i++)
                                            {
                                                sb.Append("<tr> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["LedgerTransactionNo"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["PatientName"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["TestName"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["LabCount"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["MRP"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["GrossAmt"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["DiscAmt"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["NetAmt"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["PackageCount"]) + "</td> ");
                                                sb.Append(" <td style='width: 10%;font-size: 14px;border-top: 1px solid; border-bottom: 1px solid;'>" + Util.GetString(dtinv.Rows[i]["TotalQuantity"]) + "</td> ");

                                                sb.Append(" </tr> ");
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
                                Session["dtExport2Excel"] = dt;
                                Session["ReportName"] = "High Volume Report";
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
        if (Request.Form["ReportType"].ToString() == "1")
        {
            sb.Append("<span style='font-weight: bold;font-size:20px;'>High Volume Summary Report</span><br />");
        }
        else
            sb.Append("<span style='font-weight: bold;font-size:20px;'>High Volume Detail Report</span><br />");

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
        if (Request.Form["ReportType"].ToString() == "1")
        {
           
            sb.Append(" <table style='width: 100%; border-collapse: collapse;padding-top:6px;'> ");
            sb.Append(" <tr> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>ItemCode</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>TestName</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>LabCount</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>MRP</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>GrossAmt</td> ");

            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>DiscAmt</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>NetAmt</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>PackageCount</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>TotalQuantity</td> ");
            sb.Append(" </tr> ");
            sb.Append("</table>");
           
        }
        else
        {           
            sb.Append(" <table style='width: 100%; border-collapse: collapse;padding-top:6px;'> ");
            sb.Append(" <tr> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>LabNo</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>Patient Name</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>TestName</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>LabCount</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>MRP</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>GrossAmt</td> ");

            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>DiscAmt</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>NetAmt</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>PackageCount</td> ");
            sb.Append(" <td style='width: 10%;font-weight: bold;font-size: 16px;border-top: 2px solid; border-bottom: 2px solid;'>TotalQuantity</td> ");
            sb.Append(" </tr> ");
            sb.Append("</table>");
            
        }
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
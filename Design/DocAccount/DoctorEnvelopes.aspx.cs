using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_DocAccount_DoctorEnvelopes : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    //Page Property

    int MarginLeft = 20;
    int MarginRight = 30;
    int PageWidth = 550;
    int BrowserWidth = 800;


    //Header Property
    float HeaderHeight = 80;//207
    int XHeader = 20;//20
    int YHeader = 60;//80
    int HeaderBrowserWidth = 800;
    // BackGround Property 
    bool BackGroundImage = false;
    string HeaderImg = "";

    //Footer Property 80
    float FooterHeight = 50;
    int XFooter = 20;
    DataTable dt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber; 

        if (Request.Form["ReportType"].ToString() != string.Empty && Request.Form["toDate"].ToString() != string.Empty && Request.Form["fromDate"].ToString() != string.Empty)
            BindData(Request.Form["fromDate"].ToString(), Request.Form["toDate"].ToString(), Request.Form["ReportType"].ToString());
    }
    protected void BindData(string fromDate, string toDate, string ReportType)
    {       
        string CentreID = Request.Form["CentreID"].ToString();
        string DoctorID = Request.Form["DoctorID"].ToString();
        string DepartmentID = Request.Form["DepartmentID"].ToString();
        string PanelID = Util.GetString(Request.Form["PanelID"]);
        string CategoryID = Util.GetString(Request.Form["CategoryID"]);

        string ddlPatientCount = Request.Form["PatientCount"].ToString();
        string txtPatientCount = Request.Form["PatientValue"].ToString();
        string ddlRefAmount = Request.Form["ShareAmtType"].ToString();
        string txtRefAmount = Request.Form["ShareAmtvalue"].ToString();       


        try
        {
            MySqlConnection con = Util.GetMySqlCon();
          string  Period = string.Concat(" Period From :", Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy"), " Period To :", Util.GetDateTime(toDate).ToString("dd-MMM-yyyy"));


            StringBuilder sb = new StringBuilder();           
            //Doctor Envelop
            if (ReportType == "4")
            {

                sb.Append("   SELECT DoctorName,sum(DoctorShare) DoctorShareAmount, Doctor_ID  ");
                sb.Append("  FROM (  ");

                sb.Append(" SELECT ua.LedgerTransactionNo ,DATE_FORMAT(ua.Date,'%d/%m/%Y') AS dtEntry,UPPER(ua.PName) Patient, ua.GrossAmount,ua.DiscountOnTotal,");
                sb.Append(" ua.NetAmount, (ua.NetAmount- ua.FinalAdjustment) AS Balance,    ua.ItemName,ua.Rate,ua.Quantity,ua.`DiscountAmt`,ua.Amount,ua.itemid,ua.RemoveDocShareItemWise, ");
                sb.Append("  IF(ua.DoctorMasterShareAllow ='1','Y','N') Referal ,ua.DoctorGroup Doctor_ID,ua.`DoctorName`,ua.`DoctorMobile`,ua.`Specialization`,ua.`Phone1`,ua.`Phone2`,ua.Doctor_ID Doctor_ID1,");
                sb.Append(" IF(ua.ReferMasterShare='1','Y','N') MasterShare,ua.DeptName Name, ");

                sb.Append("IFNULL(ROUND(CASE WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocShareAmt,0)!=0  ");
                sb.Append(" THEN ROUND(((ds.DocShareAmt*ua.Quantity)-ua.`DiscountAmt`),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)!=0  ");
                sb.Append(" THEN ROUND(((ua.Rate*ua.Quantity*ds.DocSharePer*0.01)-ua.`DiscountAmt`) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND(((ua.Rate*ua.Quantity*ds1.DocSharePer*0.01)-ua.`DiscountAmt`) ,2)  ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ds2.DocShareAmt*ua.Quantity)-ua.`DiscountAmt`),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ua.Rate*ua.Quantity*ds2.DocSharePer*0.01)-ua.`DiscountAmt`) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0  ");
                sb.Append(" THEN ROUND(((ua.Rate*ua.Quantity*ds3.DocSharePer*0.01)-ua.`DiscountAmt`) ,2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocShareAmt,0)!=0 ");
                sb.Append(" THEN ROUND((ds.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)!=0 ");
                sb.Append(" THEN ROUND((ua.Rate*ua.Quantity*ds.DocSharePer*0.01),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND((ua.Rate*ua.Quantity*ds1.DocSharePer*0.01) ,2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ds2.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ua.Rate*ua.Quantity*ds2.DocSharePer*0.01),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0  ");
                sb.Append(" THEN ROUND((ua.Rate*ua.Quantity*ds3.DocSharePer*0.01) ,2) ");
                sb.Append(" END,2),0) AS DoctorShare  ");

                sb.Append(" FROM utility_accountdata ua ");
                sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=ua.`ItemID` AND ua.RemoveDocShareItemWise=0 and ua.PanelDoctorShareAllow=1 and ua.DoctorMasterShareAllow=1");
               
                sb.Append(" LEFT JOIN doctor_referral_share_items ds ON  ds.itemID=ua.`ItemId`  AND ds.Panel_ID=ua.Panel_ID  AND ds.Doctor_ID =0 ");
                sb.Append("  LEFT JOIN doctor_referral_share_items ds1 ON  ds1.SubcategoryID=ua.`SubCategoryID` AND ds1.Panel_ID=ua.Panel_ID AND ds1.Doctor_ID=0 ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds2 ON  ds2.itemID=ua.`ItemId`  AND ds2.Panel_ID='78'  AND ds2.Doctor_ID =0 ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds3 ON  ds3.SubcategoryID=ua.`SubCategoryID` AND ds3.Panel_ID='78' AND ds3.Doctor_ID=0 ");
                sb.Append(" WHERE ua.date>=@fromdate AND ua.date<=@todate AND ua.ReferMasterShare=1  ");
                if (CategoryID != string.Empty)
                {
                    sb.Append(" and im.Category in (" + CategoryID + ") ");
                }
                if (PanelID != string.Empty)
                {
                    sb.Append(" and ua.Panel_ID IN (" + PanelID + ") ");
                }
                if (CentreID != string.Empty)
                {
                    sb.Append(" and ua.CentreID in (" + CentreID + ") ");
                }
                if (DepartmentID != string.Empty)
                {
                    sb.Append("	and ua.SubCategoryID  in (" + DepartmentID + ")  ");
                }
                if (DoctorID != string.Empty)
                {
                    sb.Append("	and ua.Doctor_ID  in (" + DoctorID + ")  ");
                }              
                sb.Append("		)t  ");
                sb.Append(" group by Doctor_ID ");

                sb.Append(" UNION ALL   ");
               // salek

                sb.Append("   SELECT DoctorName,sum(DoctorShare) DoctorShareAmount, Doctor_ID  ");
                sb.Append("  FROM (  ");

               
                sb.Append(" SELECT ua.LedgerTransactionNo ,DATE_FORMAT(ua.Date,'%d/%m/%Y') AS dtEntry,UPPER(ua.PName) Patient, ua.GrossAmount,ua.DiscountOnTotal,");
                sb.Append(" ua.NetAmount, (ua.NetAmount- ua.FinalAdjustment) AS Balance,    ua.ItemName ,ua.Rate,ua.Quantity,ua.`DiscountAmt`,ua.Amount,ua.itemid,ua.RemoveDocShareItemWise, ");
                sb.Append("  IF(ua.DoctorMasterShareAllow='1','Y','N') Referal ,ua.DoctorGroup Doctor_ID,ua.`DoctorName`,ua.`DoctorMobile`,ua.`Specialization`,ua.`Phone1`,ua.`Phone2`,ua.Doctor_ID Doctor_ID1,");
                sb.Append(" IF(ua.ReferMasterShare ='1','Y','N') MasterShare,ua.DeptName Name, ");

                sb.Append(" IFNULL(ROUND(CASE WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocShareAmt,0)!=0 ");
                sb.Append(" THEN ROUND(((ds.DocShareAmt*ua.Quantity)-ua.`DiscountAmt`),2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)!=0 ");
                sb.Append(" THEN ROUND(((ua.Rate*ua.Quantity*ds.DocSharePer*0.01)-ua.`DiscountAmt`) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0  AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND(((ua.Rate*ua.Quantity*ds.DocSharePer*0.01)-ua.`DiscountAmt`) ,2) ");

                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ds2.DocShareAmt*ua.Quantity)-ua.`DiscountAmt`),2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ua.Rate*ua.Quantity*ds2.DocSharePer*0.01)-ua.`DiscountAmt`) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND(((ua.Rate*ua.Quantity*ds3.DocSharePer*0.01)-ua.`DiscountAmt`) ,2) ");

                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocShareAmt,0)!=0 ");
                sb.Append(" THEN ROUND((ds.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)!=0 ");
                sb.Append(" THEN ROUND((ua.Rate*ua.Quantity*ds.DocSharePer*0.01),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND((ua.Rate*ua.Quantity*ds1.DocSharePer*0.01) ,2) ");

                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ds2.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ua.Rate*ua.Quantity*ds2.DocSharePer*0.01),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)=0 AND ds2.DocShareAmt=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0   AND IFNULL(ds3.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND((ua.Rate*ua.Quantity*ds3.DocSharePer*0.01) ,2)  END,2),0) AS DoctorShare   ");

                sb.Append(" FROM utility_accountdata ua  ");
                sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=ua.`ItemID` AND ua.RemoveDocShareItemWise=0 and ua.PanelDoctorShareAllow=1 and ua.DoctorMasterShareAllow=1 ");

                sb.Append(" LEFT JOIN doctor_referral_share_items ds ON ds.Doctor_ID=ua.Doctor_ID AND ds.itemID=ua.`ItemId` AND ds.Panel_ID=ua.Panel_ID ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds1 ON ds1.Doctor_ID=ua.Doctor_ID AND ds1.SubcategoryID=ua.`SubCategoryID` AND ds1.Panel_ID=ua.Panel_ID ");
                sb.Append("  LEFT JOIN doctor_referral_share_items ds2 ON  ds2.itemID=ua.`ItemId`  AND ds2.Panel_ID='78'  AND ds2.Doctor_ID =0 ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds3 ON  ds3.SubcategoryID=ua.`SubCategoryID` AND ds3.Panel_ID='78' AND ds3.Doctor_ID=0 ");
                sb.Append(" WHERE ua.date>=@fromdate AND ua.date<=@todate  AND ua.ReferMasterShare=0  ");
                if (CategoryID != string.Empty)
                {
                    sb.Append(" and im.Category in (" + CategoryID + ") ");
                }
                if (PanelID != string.Empty)
                {
                    sb.Append(" and ua.Panel_ID IN (" + PanelID + ") ");
                }
                if (CentreID != string.Empty)
                {
                    sb.Append(" and ua.CentreID in (" + CentreID + ") ");
                }
                if (DepartmentID != string.Empty)
                {
                    sb.Append("	and ua.SubCategoryID  in (" + DepartmentID + ")  ");
                }
                if (DoctorID != string.Empty)
                {
                    sb.Append("	and ua.Doctor_ID  in (" + DoctorID + ")  ");
                }
                sb.Append("		)t  ");
                sb.Append(" group by Doctor_ID ");

                sb.Append(" order by Doctor_ID ");
                con.Open();
                using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
                {
                    da.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " 00:00:00'"));
                    da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " 23:59:59'"));
                    da.Fill(dt);
                    con.Close();

                    if (dt.Rows.Count > 0)
                    {                       
                        StringBuilder Header = new StringBuilder();
                        Header.Append("<div style='width:1000px;'>");
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            Header = new StringBuilder();
                                using (DataTable dt1 = dt.AsEnumerable().Where(s => s.Field<string>("Doctor_ID") == Util.GetString(dt.Rows[i]["Doctor_ID"].ToString())).CopyToDataTable())
                                {
                                    for (int j = 0; j < dt1.Rows.Count; j++)
                                    {
                                        if (j == 0)
                                        {                                           
                                            Header.Append("<div style='width:1000px;'>");
                                            Header.Append("<table style='width:1000px; font-family:Times New Roman;font-size:16px;'>");
                                            Header.Append("<tr>");
                                            Header.Append("<td style='text-align:center;padding:15px 5px;'>");

                                            Header.AppendFormat("<span style='font-size:25px !important;font-weight:bold; text-align:center;'>{0}</span>", dt1.Rows[j]["DoctorName"].ToString());
                                            Header.AppendFormat("</td>");
                                            Header.Append("</tr>");
                                        }
                                        Header.Append("<tr>");
                                        Header.Append("<td style='text-align:center;padding:15px 5px;'>");

                                        Header.AppendFormat("<span style='font-size:26px !important;font-weight:bold; text-align:center;'>{0}</span>", Math.Round(Util.GetDecimal(dt1.Rows[j]["DoctorShareAmount"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        Header.AppendFormat("</td>");
                                        Header.Append("</tr>");
                                    }
                                    Header.Append("</table></div>");
                                                         
                                }
                                AddContent(Header.ToString());
                                      
                        }                                    
                    }
                }
            }
            if (dt.Rows.Count > 0)
            {
                mergeDocument(); 
                byte[] pdfBuffer = document.WriteToMemory();
                HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
                HttpContext.Current.Response.BinaryWrite(pdfBuffer);
                HttpContext.Current.Response.End();
                dt.Dispose();
            }
            else
            {
                Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'>No Record Found <span><br/></center>");
                return;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    private void mergeDocument()
    {
        int pageno = 1;
        foreach (PdfPage p in tempDocument.Pages)
        {

            PdfHtml linehtml = new PdfHtml(XFooter, -4, "<div style='width:1140px;border-top:3px solid black;'></div>", null);

            System.Drawing.Font pageNumberingFont =
          new System.Drawing.Font(new System.Drawing.FontFamily("Times New Roman"), 8, System.Drawing.GraphicsUnit.Point);
            PdfText pageNumberingText = new PdfText(PageWidth - 20, FooterHeight - 40, String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;

            PdfText printdatetime = new PdfText(PageWidth - 520, FooterHeight - 40, DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont);
            printdatetime.ForeColor = System.Drawing.Color.Black;

            if (p.Footer == null)
            {
                p.CreateFooterCanvas(FooterHeight);

            }
         //   p.Footer.Layout(linehtml);
         //   p.Footer.Layout(pageNumberingText);
         //   p.Footer.Layout(printdatetime);
            document.Pages.AddPage(p);
            pageno++;
        }

        tempDocument = new PdfDocument();
    }
    private void AddContent(string Content)
    {

        PdfPage page1 = tempDocument.AddPage(PdfPageSize.A4, PdfDocumentMargins.Empty);
        PdfHtml html1 = new PdfHtml();
        html1 = new PdfHtml(MarginLeft, 0, PageWidth, Content, null);//((html1LayoutInfo == null) ? 0 : html1LayoutInfo.LastPageRectangle.Height)
        html1.PageCreatingEvent += new PdfPageCreatingDelegate(htmlToPdfConverter_PageCreatingEvent);
        html1.FontEmbedding = false;
        html1.BrowserWidth = BrowserWidth;
        html1.ImagesCutAllowed = false;
        html1LayoutInfo = page1.Layout(html1);
    }
    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        PdfPage page1 = eventParams.PdfPage;
        if (BackGroundImage == true)
        {
            HeaderImg = "";
           // page1.Layout(getPDFBackGround(HeaderImg));
        }
        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);
      
    }
    private string MakeHeader()
    {
        StringBuilder Header = new StringBuilder();
      
        return Header.ToString();
    }
    private void SetHeader(PdfPage page)
    {
        page.CreateHeaderCanvas(HeaderHeight);
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader - 40, PageWidth, MakeHeader(), null);
        //   page.Header.Layout(getPDFImageforbarcode(15, 140, drcurrent["LedgerTransactionNo"].ToString()));
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(headerHtml);

    }
   

   
   
}
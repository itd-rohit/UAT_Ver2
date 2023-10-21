using HiQPdf;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_EQASSummaryReport : System.Web.UI.Page
{

    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs;

    //Page Property

    int MarginLeft = 20;
    int MarginRight = 30;
    int PageWidth = 550;
    int BrowserWidth = 800;



    //Header Property
    float HeaderHeight = 160;//207
    int XHeader = 20;//20
    int YHeader = 90;//80
    int HeaderBrowserWidth = 800;




    // BackGround Property
    bool HeaderImage = false;
    bool FooterImage = true;
    bool BackGroundImage = true;
    string HeaderImg = "";

    //Footer Property 80
    float FooterHeight = 140;
    int XFooter = 20;

    DataRow drcurrent;
    string ApolloImagesPath ="https://lims.lupindiagnostics.com/LupinImages/";


    protected void Page_Load(object sender, EventArgs e)
    {
        document = new PdfDocument();
        tempDocument = new PdfDocument();
       document.SerialNumber = "RAwtFRQg-IggtJjYl-Nj11dGp0-ZHVkcGR9-cXNkd3Vq-dXZqfX19-fQ==";


       string labid = Util.GetString(Request.QueryString["labid"].ToString());
       string regisyear = Util.GetString(Request.QueryString["regisyear"].ToString());
       string regismonth = Util.GetString(Request.QueryString["regismonth"].ToString());
       string programid = Util.GetString(Request.QueryString["programid"].ToString());
        if (Request.QueryString["phead"].ToString() == "1")
        {
            HeaderImage = true;
        }
        try
        {
            StringBuilder sb = new StringBuilder();

            BindData(programid, labid, regisyear, regismonth);

            if (dtObs.Rows.Count == 0)
            {
                Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong . Please Refresh Page Or Contact To Admin..!<span><br/><input type='button' value='Refresh' style='cursor:pointer;font-weight:bold;' onclick='window.location.reload();'/></center>");
                return;
            }
            drcurrent = dtObs.Rows[0];

            sb.Append("<table box='frame' rules='all' border='1' style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:14px;'> ");
            sb.Append("<tr>");
            sb.Append("<td>EQAS Registration Date</td><td>" + drcurrent["EQASRegistrationDate"].ToString() + "</td>");
            sb.Append("<td>EQAS Registration By</td><td>" + drcurrent["EQASRegistrationBy"].ToString() + "</td>");
            sb.Append("</tr>");

            sb.Append("<tr>");
            sb.Append("<td>Lab Result Approved Date</td><td>" + drcurrent["ResultApprovedinLabDate"].ToString() + "</td>");
            sb.Append("<td>Lab Result Approved By</td><td>" + drcurrent["ResultApprovedinLabBy"].ToString() + "</td>");
            sb.Append("</tr>");

         


            sb.Append("<tr>");
            sb.Append("<td>EQAS Result Entered Date</td><td>" + drcurrent["EQASResultEnteredDate"].ToString() + "</td>");
            sb.Append("<td>EQAS Result Entered By</td><td>" + drcurrent["EQASResultEnteredBy"].ToString() + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td>EQAS Result Approved Date</td><td>" + drcurrent["EQASResultApprovedDate"].ToString() + "</td>");
            sb.Append("<td>EQAS Result Approved By</td><td>" + drcurrent["EQASResultApprovedBy"].ToString() + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td>EQAS Result Upload Date</td><td>" + drcurrent["EQASResultUploadedDate"].ToString() + "</td>");
            sb.Append("<td>EQAS Result Upload By</td><td>" + drcurrent["EQASResultUploadedBy"].ToString() + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td>EQAS Final Done Date</td><td>" + drcurrent["EQASFinalDoneDate"].ToString() + "</td>");
            sb.Append("<td>EQAS Final Done By</td><td>" + drcurrent["EQASFinalDoneBy"].ToString() + "</td>");
            sb.Append("</tr>");
            sb.Append("</table><br/><br/>");


            sb.Append("<table box='frame' rules='all' border='1' style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:14px;'> ");
            sb.Append("<tr>");
            sb.Append("<td  width='50px' valign='top' style='font-weight:bold;'>Sr.No</td>");
            sb.Append("<td    valign='top' style='font-weight:bold;'>VisitID</td>");
            sb.Append("<td    valign='top' style='font-weight:bold;'>SinNo</td>");
            sb.Append("<td    valign='top' style='font-weight:bold;'>Departemnt</td>");
            sb.Append("<td    valign='top' style='font-weight:bold;'>TestName</td>");
            sb.Append("<td   valign='top' style='font-weight:bold;'>Parameter</td>");
            sb.Append("<td    valign='top' style='font-weight:bold;'>Value</td>");
            sb.Append("<td    valign='top' style='font-weight:bold;'>MinValue</td>");
            sb.Append("<td   valign='top' style='font-weight:bold;'>MaxValue</td>");
            sb.Append("<td   valign='top' style='font-weight:bold;'>Status</td>");
            sb.Append("<td   valign='top' style='font-weight:bold;'>EQAS<br/>Status</td>");
            sb.Append("</tr>");
            int a = 1;


            foreach (DataRow dw in dtObs.Rows)
            {
                sb.Append("<tr>");
                sb.Append("<td  width='50px'  valign='top'>" + a.ToString() + "</td>");
                sb.Append("<td  valign='top'>" + dw["visitno"].ToString() + "</td>");
                sb.Append("<td  valign='top'>" + dw["SinNo"].ToString() + "</td>");
                sb.Append("<td  valign='top'>" + dw["departmant"].ToString() + "</td>");
                sb.Append("<td  valign='top'>" + dw["InvestigationName"].ToString() + "</td>");
                sb.Append("<td  valign='top'>" + dw["LabObservationName"].ToString() + "</td>");
                sb.Append("<td  valign='top'>" + dw["ResultValue"].ToString() + "</td>");
                sb.Append("<td  valign='top'>" + dw["minvalue"].ToString() + "</td>");
                sb.Append("<td  valign='top'>" + dw["MaxValue"].ToString() + "</td>");
                sb.Append("<td  valign='top'>" + dw["flag"].ToString() + "</td>");
                sb.Append("<td  valign='top'>" + dw["eqasstatus"].ToString() + "</td>");
                sb.Append("</tr>");
                a++;
            }

            //if (drcurrent["rca"] != "")
            //{
            //    sb.Append("<tr style='border:0px'><td colspan='8'><br/></td></tr>");
            //    sb.Append("<tr>");
            //    sb.Append("<td colspan='2'>RCA</td>");
            //    sb.Append("<td colspan='6'>" + drcurrent["rca"].ToString()+ "</td>");
            //    sb.Append("</tr>");
            //}
            //if (drcurrent["CorrectiveAction"] != "")
            //{

            //    sb.Append("<tr style='border:0px'><td colspan='8'><br/></td></tr>");
            //    sb.Append("<tr>");
            //    sb.Append("<td colspan='2'>CorrectiveAction</td>");
            //    sb.Append("<td colspan='6'>" + drcurrent["CorrectiveAction"].ToString() + "</td>");
            //    sb.Append("</tr>");
            //}
            //if (drcurrent["PreventiveAction"] != "")
            //{

            //    sb.Append("<tr>");
            //    sb.Append("<td colspan='2'>PreventiveAction</td>");
            //    sb.Append("<td colspan='6'>" + drcurrent["PreventiveAction"].ToString() + "</td>");
            //    sb.Append("</tr>");
            //}
            sb.Append("</table>");
            AddContent(sb.ToString());
            SetFooter(tempDocument.Pages[tempDocument.Pages.Count - 1]);
            mergeDocument();
            byte[] pdfBuffer = document.WriteToMemory();
            HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
            HttpContext.Current.Response.BinaryWrite(pdfBuffer);
            HttpContext.Current.Response.End();

        }
        catch (Exception ex)
        {
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong . Please Refresh Page Or Contact To Admin..!<span><br/><input type='button' value='Refresh' style='cursor:pointer;font-weight:bold;' onclick='window.location.reload();'/></center>");
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



    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {

        PdfPage page1 = eventParams.PdfPage;


        if (HeaderImage == true && Util.GetString(drcurrent["ILCReportBackGroundImage"].ToString()) != "")
        {
            HeaderImg = "App_Images/ILCReportBackGround/" + Util.GetString(drcurrent["ILCReportBackGroundImage"].ToString());
            page1.Layout(getPDFImage(0, 0, HeaderImg));
        }



        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);
        SetFooter(page1);




    }


    private PdfImage getPDFImage(float X, float Y, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Server.MapPath("~/" + SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }


    private void SetHeader(PdfPage page)
    {


        page.CreateHeaderCanvas(HeaderHeight);

        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader, PageWidth, MakeHeader(), null);
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(headerHtml);

        // page.Header.Layout(getPDFImageforbarcode(50, 150, drcurrent["LedgerTransactionNo"].ToString()));


    }

    private void SetFooter(PdfPage page)
    {
        if (page.Footer != null)
        {
            StringBuilder sbimg = new StringBuilder();
            string imgname = ApolloImagesPath + "/signature/" + Util.GetString(drcurrent["ApprovedBy"]) + ".jpg";

            sbimg.Append("<div style='width:750px;border-top:1px solid black;'>");
            sbimg.Append("<table style='width:750px;border-collapse:collapse;font-family:Times New Roman;font-size:14px;'>");
            sbimg.Append("<tr><td>");
            sbimg.Append("<img  src='" + imgname + "' />");
            sbimg.Append("</tr></td>");
            sbimg.Append("</table>");
            sbimg.Append("</div>");
            PdfHtml footerhtml = new PdfHtml(XFooter, 0, sbimg.ToString(), null);

            footerhtml.BrowserWidth = HeaderBrowserWidth;
            page.Footer.Layout(footerhtml);

        }
    }





    private string MakeHeader()
    {






        StringBuilder Header = new StringBuilder();
        Header.Append("<div style='width:800px;border:1px solid black;'>");
        Header.Append("<table style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:14px;'>");

        Header.Append("<tr style='border-bottom:1px solid black;'>");
        Header.Append("<td colspan='4' style='text-align:center;width:800px;font-weight:bold;'>" + Util.GetString(drcurrent["Centre"]) + "</td>");

        Header.Append("</tr>");


        Header.Append("<tr style='border-bottom:1px solid black;'>");
        Header.Append("<td colspan='4' style='text-align:center;width:800px;font-weight:bold;'>EQAS Report of " + Util.GetString(drcurrent["Entrymonth"]) + " " + Util.GetString(drcurrent["Entryyear"]) + "</td>");

        Header.Append("</tr>");

        Header.Append("<tr style='border-bottom:1px solid black;'>");
        Header.Append("<td colspan='4' style='text-align:center;width:800px;font-weight:bold;'>EQAS Provider : " + Util.GetString(drcurrent["ProvideName"]) + "&nbsp;&nbsp;&nbsp;&nbsp;EQAS Program : " + Util.GetString(drcurrent["programname"]) + "</td>");

        Header.Append("</tr>");

        Header.Append("<tr style='border-bottom:1px solid black;'>");
        Header.Append("<td colspan='4' style='text-align:center;width:800px;font-weight:bold;'>EQAS Status : " + Util.GetString(drcurrent["CurrentStatus"]) + "&nbsp;&nbsp;&nbsp;&nbsp;Expected Result Date From EQAS Provider : " + Util.GetString(drcurrent["ExpectedResultDate"]) + "</td>");

        Header.Append("</tr>");

        Header.Append("</table>");
        Header.Append("</div>");

        return Header.ToString();
    }

    private void AddContent(string Content)
    {

        //File.AppendAllText("D:\\apollo.txt", Content);
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



            System.Drawing.Font pageNumberingFont =
          new System.Drawing.Font(new System.Drawing.FontFamily("Times New Roman"), 8, System.Drawing.GraphicsUnit.Point);


            PdfText pageNumberingText = new PdfText(PageWidth - 50, 70, String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;


            PdfText printdatetime = new PdfText(PageWidth - 150, 70, DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont);
            printdatetime.ForeColor = System.Drawing.Color.Black;

            if (p.Footer == null)
            {
                p.CreateFooterCanvas(FooterHeight);

            }
            p.Footer.Layout(pageNumberingText);
            p.Footer.Layout(printdatetime);
            document.Pages.AddPage(p);
            pageno++;
        }

        tempDocument = new PdfDocument();
    }

    void BindData(string programid, string labid, string regisyear,string regismonth)
    {


        StringBuilder sb = new StringBuilder();
        sb.Append(" select plo.ApprovedBy, qcr.centreid,cm.centre Centre,ifnull(cm.ILCReportBackGroundImage,'') ILCReportBackGroundImage,MONTHNAME(STR_TO_DATE(Entrymonth, '%m'))Entrymonth,EntryYear,");

        sb.Append(" (SELECT `EqasProviderName` FROM `qc_eqasprovidermaster` qe  ");
        sb.Append(" INNER JOIN qc_eqasprogrammaster qeq ON qe.EQASProviderID=qeq.EQASProviderID WHERE qeq.programid=qcr.programid LIMIT 1)ProvideName,");
        sb.Append(" qcr.programid,qcr.programname");
        sb.Append(" ,qcr.test_id,qcr.LedgerTransactionNo visitno,qcr.LabObservationName,plo.barcodeno SinNo, ");
        sb.Append("  sm.name departmant,plo.InvestigationName, ");
        sb.Append(" IFNULL(ploo.`Value`,ifnull(qcr.value,'')) ResultValue,IFNULL(ploo.minvalue,'') minvalue,IFNULL(ploo.`MaxValue`,'')`MaxValue`, ");
        sb.Append(" ifnull(ploo.MacReading,'')MacReading ,ifnull(ploo.MachineName,'')MachineName, ");
        sb.Append(" IFNULL(ploo.`DisplayReading`,'')DisplayReading,IFNULL(ploo.`ReadingFormat`,'')Unit,IFNULL(ploo.flag,'')flag, ");
        sb.Append(" ifnull(qcr.RCA,'')RCA ,ifnull(qcr.CorrectiveAction,'') CorrectiveAction ,ifnull(qcr.PreventiveAction,'') PreventiveAction ,ifnull(qcr.EQASVALUE,'')EQASVALUE,EQASStatus");
        sb.Append(" ,(case when qcr.EQASDone=1 then 'EQASDone' when qcr.ResultUploaded=1 then 'ResultUploaded' when qcr.Approved=1 then 'Approved'  when qcr.result_flag=1 then 'ResultDone' else 'New' end)CurrentStatus, ");

        sb.Append(" if(ResultUploaded=1,date_format(ExpectedResultDate,'%d-%b-%Y'),'')ExpectedResultDate, ");

        sb.Append(" ifnull(DATE_FORMAT(plo.ApprovedDate,'%d-%b-%Y'),DATE_FORMAT(plo.ResultEnteredDate,'%d-%b-%Y')) ResultApprovedinLabDate,ifnull(plo.ApprovedName,plo.ResultEnteredName) ResultApprovedinLabBy,");


        sb.Append(" DATE_FORMAT(qcr.EntryDateTime,'%d-%b-%Y') EQASRegistrationDate,qcr.EntryByUserName EQASRegistrationBy,");
        sb.Append(" DATE_FORMAT(qcr.ResultEnteredDate,'%d-%b-%Y') EQASResultEnteredDate,qcr.ResultEnteredName EQASResultEnteredBy,");
        sb.Append(" DATE_FORMAT(qcr.ApprovedDate,'%d-%b-%Y') EQASResultApprovedDate,qcr.ApprovedName EQASResultApprovedBy,");
        sb.Append(" DATE_FORMAT(qcr.ResultUploadedDate,'%d-%b-%Y') EQASResultUploadedDate,qcr.ResultUploadedName EQASResultUploadedBy,");
        sb.Append(" DATE_FORMAT(qcr.EQASDoneDate,'%d-%b-%Y') EQASFinalDoneDate,qcr.EQASDoneName EQASFinalDoneBy");


        sb.Append(" FROM `qc_eqasregistration` qcr  ");
        sb.Append(" inner join centre_master cm on cm.centreid=qcr.centreid ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`Test_ID`=qcr.`Test_id` ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
        sb.Append(" LEFT JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID` AND ploo.`LabObservation_ID`=qcr.`LabObservationID` ");
        sb.Append(" WHERE qcr.programid=" + programid + " and qcr.centreid=" + labid + " AND entrymonth=" + regismonth + " AND entryyear=" + regisyear + " AND isreject=0 ");



        dtObs = StockReports.GetDataTable(sb.ToString());


    }
}
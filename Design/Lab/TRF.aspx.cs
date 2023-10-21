using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Web;

public partial class Design_Lab_TRF : System.Web.UI.Page
{
    private PdfDocument document;
    private PdfDocument tempDocument;
    private PdfLayoutInfo html1LayoutInfo;

    //Page Property

    private int MarginLeft = 20;
    private int MarginRight = 30;
    private int PageWidth = 550;
    private int BrowserWidth = 800;

    //Header Property
    private float HeaderHeight = 40;//207

    private int XHeader = 20;//20
    private int YHeader = 60;//80
    private int HeaderBrowserWidth = 800;

    // BackGround Property
    private bool HeaderImage = true;

    private bool FooterImage = false;
    private bool BackGroundImage = false;
    private string HeaderImg = "";

    //Footer Property 80
    private float FooterHeight = 400;

    private int XFooter = 20;

    private DataRow drcurrent;

    private string id = "";
    private string name = "";

    //Bilal - 2020-04-07

    protected void Page_Load(object sender, EventArgs e)
    {
        id = UserInfo.ID.ToString();
        name = UserInfo.LoginName.ToString();
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;

        if (!IsPostBack)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["ID"]))
            {
                string LedgertransactionId = Common.Decrypt(Request["ID"]);
                BindData(Util.GetInt(LedgertransactionId));
            }
        }
    }

    protected void BindData(int LedgertransactionId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        lblmsg.Text = "";
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT stm.SampleTypeName Department, CONCAT(pm.Title,' ',pm.PName) PName,pm.Age,pm.Gender,pm.Mobile,lt.LedgertransactionNo,plo.BarcodeNo,");
            sb.Append(" plo.`ItemName`  Tests,'Sample Type' TYPE, DATE_FORMAT(lt.Date,'%d-%b-%Y %h:%i %p') DATE,cm.Centre,cm.HeaderImage ,lt.Patient_Id,IF(plo.DepartmentTokenNo=0,'',DepartmentTokenNo)DepartmentTokenNo ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN patient_labInvestigation_opd plo ON lt.LedgertransactionId=plo.LedgertransactionId   ");
            sb.Append(" AND  plo.IsReporting=1  AND lt.LedgertransactionID=@LedgertransactionID  ");
            sb.Append(" INNER JOIN f_subcategoryMaster scm ON plo.SubcategoryId=scm.SubcategoryId  ");
            sb.Append(" INNER JOIN patient_master pm ON lt.Patient_Id=pm.Patient_Id  ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreId=lt.CentreId  ");
            sb.Append(" INNER JOIN `investigations_sampletype` stm ON stm.Investigation_Id=plo.Investigation_Id  AND stm.IsDefault=1  ");

          // System.IO.File.WriteAllText (@"C:\\q1.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
             new MySqlParameter("@LedgertransactionID", LedgertransactionId)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    StringBuilder sbWorklist = new StringBuilder();
                    sbWorklist.Append("<div style='width:800px;'>");
                    sbWorklist.Append("<table style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:15px;'");
                    sbWorklist.Append("<tr>");
                    sbWorklist.Append("<td style='text-align:center;padding:15px 5px;'><span style='font-size:20px !important;font-weight:bold; text-align:center;'>TRF</span>");
                    sbWorklist.Append("</td>");
                    sbWorklist.Append("</tr>");
                    sbWorklist.Append("</table>");
                    sbWorklist.Append("<div style='width:800px;'>");
                    sbWorklist.Append("<table style='width:800px;border:1px solid #000; font-family:Times New Roman;font-size:12px;'>");

                    #region "1 row"

                    sbWorklist.Append("<tr>");
                    sbWorklist.Append("<td style='width:120px;font-weight:bold;' >Patient Name : </td>");
                    sbWorklist.AppendFormat("<td style='font-weight:bold;width:100px;'>{0}</td>", Util.GetString(dt.Rows[0]["PName"]));
                    sbWorklist.Append("<td  style='font-weight:bold;width:100px'></td>");
                    sbWorklist.Append("<td style='font-weight:bold;width:100px' >Visit No : </td>");
                    sbWorklist.AppendFormat("<td style='font-weight:bold;width:120px'>{0}</td>", Util.GetString(dt.Rows[0]["LedgertransactionNo"]));
                    sbWorklist.Append("</tr>");

                    sbWorklist.Append("<tr>");
                    sbWorklist.Append("<td style='width:100px;font-weight:bold;' >Age/Gender : </td>");
                    sbWorklist.AppendFormat("<td style='font-weight:bold;width:130px;'>{0}/{1}</td>", Util.GetString(dt.Rows[0]["Age"]), Util.GetString(dt.Rows[0]["Gender"]));
                    sbWorklist.Append("<td  style='font-weight:bold;width:100px'></td>");
                    sbWorklist.Append("<td style='font-weight:bold;width:100px' >Reg. Date : </td>");
                    sbWorklist.AppendFormat("<td style='font-weight:100;width:120px;font-size:11px;'>{0}</td>", Util.GetString(dt.Rows[0]["Date"]));
                    sbWorklist.Append("</tr>");

                    sbWorklist.Append("<tr>");
                    sbWorklist.Append("<td style='width:100px;font-weight:bold;' >Centre : </td>");
                    sbWorklist.AppendFormat("<td style='font-weight:100;width:130px;'>{0}</td>", Util.GetString(dt.Rows[0]["Centre"]));
                    sbWorklist.Append("<td  style='font-weight:bold;width:100px'></td>");
                    sbWorklist.Append("<td style='font-weight:bold;width:100px' >Mobile : </td>");
                    sbWorklist.AppendFormat("<td style='font-weight:100;width:120px'>{0}</td>", Util.GetString(dt.Rows[0]["Mobile"]));
                    sbWorklist.Append("</tr>");

                    sbWorklist.Append("<tr>");
                    sbWorklist.Append("<td style='width:100px;font-weight:bold;' >UHID : </td>");
                    sbWorklist.AppendFormat("<td style='font-weight:100;width:130px;'>{0}</td>", Util.GetString(dt.Rows[0]["Patient_Id"]));
                    sbWorklist.Append("<td  style='font-weight:bold;width:100px'></td>");
                    sbWorklist.Append("<td style='font-weight:bold;width:100px' >Visit No : </td>");
                    sbWorklist.AppendFormat("<td style='font-weight:100;width:120px'>{0}</td>", Util.GetString(dt.Rows[0]["LedgertransactionNo"]));
                    sbWorklist.Append("</tr>");

                    sbWorklist.Append("<tr>");
              //    sbWorklist.Append("<td style='width:100px;font-weight:bold;' >Centre : </td>");
              //    sbWorklist.AppendFormat("<td colspan='2' style='font-weight:100;width:130px;'>{0}</td>", Util.GetString(dt.Rows[0]["Centre"]));
              //    sbWorklist.Append("<td  style='font-weight:bold;width:100px'></td>");
              //    sbWorklist.Append("<td style='font-weight:bold;width:100px' > </td>");
              //    // sbWorklist.Append("<td style='font-weight:bold;width:120px'></td>");
              //    sbWorklist.Append("</tr>");
                    sbWorklist.Append("</table>");
                    sbWorklist.Append("</div>");

                    //----------------------------------------------------
                    sbWorklist.Append("<div style='width:800px;margin-top:10px;height:30px;'>");
                    sbWorklist.Append("<table style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:12px;' >");
                    sbWorklist.Append("<tr>");
                    sbWorklist.AppendFormat("<td style='text-align:right;'><img style='width:200px;margin-right:-10px' src='{0}'/></td>", new Barcode_alok().Save(dt.Rows[0]["LedgerTransactionNo"].ToString()).Trim());

                    sbWorklist.Append("</tr></table></div>");

                    sbWorklist.Append("<div style='width:800px;margin-top:10px;'>");
                    sbWorklist.Append("<table style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:12px;' >");
                    sbWorklist.Append("<tr>");
                    sbWorklist.Append("<th style='width:50px;font-weight:bold;border:1px solid #ccc;' >S.No. </th>");
                    sbWorklist.Append("<th style='width:500px;font-weight:bold;border:1px solid #ccc;' >Investigation </th>");
                    sbWorklist.Append("<th style='width:80px;font-weight:bold;border:1px solid #ccc;' >Token No. </th>");
                    sbWorklist.Append("</tr>");
                    //<img src='" + new Barcode_alok().Save(drcurrent["LedgerTransactionNo"].ToString()).Trim() + "'/>
                    int i = 0;
                    foreach (DataRow dr in dt.Rows)
                    {
                        i++;
                        drcurrent = dr;
                        sbWorklist.Append("<tr>");
                        sbWorklist.AppendFormat("<td style='font-weight:100;width:50px;border:1px solid #ccc;text-align:center'>{0}</td>", i);
                        sbWorklist.AppendFormat("<td  style='font-weight:100;width:500px;border:1px solid #ccc;'>{0}</td>", Util.GetString(dr["Tests"]));
                        sbWorklist.AppendFormat("<td  style='font-weight:100;width:80px;border:1px solid #ccc;text-align:center'>{0}</td>", Util.GetString(dr["DepartmentTokenNo"]));
                        sbWorklist.Append("</tr>");
                    }
                    sbWorklist.Append("</table>");
                    sbWorklist.Append("</div>");

                    #endregion "1 row"

                    AddContent(sbWorklist.ToString());
                    SetFooter(tempDocument.Pages[tempDocument.Pages.Count - 1]);
                    mergeDocument();
                    byte[] pdfBuffer = document.WriteToMemory();
                    HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
                    HttpContext.Current.Response.BinaryWrite(pdfBuffer);
                    HttpContext.Current.Response.End();
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblmsg.Text = ex.ToString();
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    private void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        PdfPage page1 = eventParams.PdfPage;
        //set background iamge in pdf report.
        if (BackGroundImage == true)
        {
            HeaderImg = "";// "App_Images/WatermarkReceipt.png";
            page1.Layout(getPDFBackGround(HeaderImg));
        }
        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);
        SetFooter(page1);
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
        string path = "";
        if (HeaderImage)
        {
            // page.Header.Layout(getPDFImageHeader(path));
        }
    }

    private void SetFooter(PdfPage page)
    {
        if (page.Footer != null)
        {
            if (FooterImage)
            {
                page.Footer.Layout(getPDFImageFooter(drcurrent["FooterImage"].ToString()));
            }
        }
    }

    private void SetHeaderImage(PdfPage page)
    {
        if (drcurrent["HeaderImage"].ToString() != "")
        {
            if (FooterImage)
            {
                page.Header.Layout(getPDFImageFooter(drcurrent["FooterImage"].ToString()));
            }
        }
    }

    private PdfImage getPDFImageforbarcode(float X, float Y, string labno)
    {
        string image = "";
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Base64StringToImage(image));
        transparentResizedPdfImage.PreserveAspectRatio = true;
        return transparentResizedPdfImage;
    }

    public System.Drawing.Image Base64StringToImage(string base64String)
    {
        byte[] imageBytes = Convert.FromBase64String(base64String.Replace("data:image/png;base64,", ""));
        MemoryStream memStream = new MemoryStream(imageBytes, 0, imageBytes.Length);

        memStream.Write(imageBytes, 0, imageBytes.Length);
        System.Drawing.Image image = System.Drawing.Image.FromStream(memStream);
        Bitmap newImage = new Bitmap(240, 30);
        using (Graphics graphics = Graphics.FromImage(newImage))
            graphics.DrawImage(image, 0, 0, 240, 30);
        return newImage;
    }

    private PdfImage getPDFBackGround(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(225, 110, 200, Server.MapPath("~/" + SignImg));
        transparentResizedPdfImage.PreserveAspectRatio = true;
        return transparentResizedPdfImage;
    }

    private PdfImage getPDFImageFooter(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(20, 0, Server.MapPath(SignImg));
        transparentResizedPdfImage.PreserveAspectRatio = true;
        return transparentResizedPdfImage;
    }

    private string MakeHeader()
    {
        StringBuilder Header = new StringBuilder();
        Header.Append("<div style='width:550px;'>");
        Header.Append("<table style='width:550px;border-collapse:collapse;font-family:Times New Roman;font-size:15px;'");
        Header.Append("<tr>");
        Header.Append("<td><span style='font-size:18px !important;'></span>");
        Header.Append("</td>");
        Header.Append("</tr>");
        Header.Append("</table>");
        return Header.ToString();
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
            PdfHtml linehtml = new PdfHtml(XFooter, FooterHeight+10, "<div style='width:1200px;border-top:3px solid black;font-weight:bold;'></div>", null);
            System.Drawing.Font pageNumberingFont =
          new System.Drawing.Font(new System.Drawing.FontFamily("Times New Roman"), 8, System.Drawing.GraphicsUnit.Point);
            PdfText pageNumberingText = new PdfText(PageWidth - 50, FooterHeight , String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;
            PdfText printdatetime = new PdfText(PageWidth - 520, FooterHeight , DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont);
            printdatetime.ForeColor = System.Drawing.Color.Black;
            if (p.Footer == null)
            {
                p.CreateFooterCanvas(FooterHeight);
            }
          //  p.Footer.Layout(linehtml);
            p.Footer.Layout(pageNumberingText);
            p.Footer.Layout(printdatetime);
            document.Pages.AddPage(p);
            pageno++;
        }
        tempDocument = new PdfDocument();
    }
}
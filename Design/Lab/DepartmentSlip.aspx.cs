using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Web;

public partial class Design_Lab_DepartmentSlip : System.Web.UI.Page
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
    float HeaderHeight = 30;//207
    int XHeader = 20;//20
    int YHeader = 60;//80
    int HeaderBrowserWidth = 800;

    // BackGround Property
    bool HeaderImage = true;
    bool FooterImage = false;
    bool BackGroundImage = false;
    string HeaderImg = "";

    //Footer Property 80
    float FooterHeight = 400;
    int XFooter = 20;

    DataRow drcurrent;

    string id = "";
    string name = "";

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
                string LedgertransactionId = Common.Decrypt(HttpUtility.UrlDecode(Request["ID"]));
                BindData(Util.GetInt(LedgertransactionId));
            }
        }
    }

    protected void BindData(int LedgertransactionId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        lblmsg.Text = string.Empty;
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT plo.ReportType,scm.Name Department, CONCAT(pm.Title,' ',pm.PName) PName,pm.Age,pm.Gender,pm.Mobile,lt.LedgertransactionNo,plo.BarcodeNo,GROUP_CONCAT(plo.ItemName separator ' , ') Tests,'Department' Type, DATE_FORMAT(lt.Date,'%d-%b-%Y %h:%i %p') Date ,cm.Centre,cm.HeaderImage");
            sb.Append(" ,lt.Patient_Id ,RTRIM(LTRIM(CONCAT(pm.`House_No`,' ',pm.`Street_Name`,' ',pm.Locality,' ',pm.city))) PAddress,IF(lt.DoctorName = 'SELF', lt.DoctorName,CONCAT('Dr.', lt.`DoctorName`) )ReferDoctor ");
            sb.Append(",IFNULL((SELECT FieldValue FROM `patient_labinvestigation_opd_requiredfield` WHERE FieldName='LMP' AND LedgertransactionId=lt.LedgertransactionId),'N/A') LMP,IF(plo.DepartmentTokenNo=0,'',DepartmentTokenNo)DepartmentTokenNo ");
            sb.Append(" FROM f_ledgertransaction lt ");
            sb.Append(" INNER JOIN patient_labInvestigation_opd plo ON lt.LedgertransactionId=plo.LedgertransactionId  ");
            sb.Append(" AND plo.ReportType=5 AND plo.IsReporting=1  AND lt.LedgertransactionId=@LedgertransactionId ");
            sb.Append(" INNER JOIN f_subcategoryMaster scm ON plo.SubcategoryId=scm.SubcategoryId ");
            sb.Append(" INNER JOIN patient_master pm ON lt.Patient_Id=pm.Patient_Id ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreId=lt.CentreId ");
            sb.Append(" GROUP BY plo.ITEMID ");
            sb.Append(" UNION ALL ");
            sb.Append(" SELECT plo.ReportType,stm.SampleTypeName Department, CONCAT(pm.Title,' ',pm.PName) PName,pm.Age,pm.Gender,pm.Mobile,lt.LedgertransactionNo,plo.BarcodeNo,GROUP_CONCAT(plo.ItemName SEPARATOR ' , ') Tests,'Sample Type' TYPE, DATE_FORMAT(lt.Date,'%d-%b-%Y %h:%i %p') DATE,cm.Centre,cm.HeaderImage ,lt.Patient_Id ");
            sb.Append(",RTRIM(LTRIM(CONCAT(pm.`House_No`,' ',pm.`Street_Name`,' ',pm.Locality,' ',pm.city))) PAddress, IF(lt.DoctorName = 'SELF', lt.DoctorName,CONCAT('Dr.', lt.`DoctorName`)) ReferDoctor ");
            sb.Append(",IFNULL((SELECT FieldValue FROM `patient_labinvestigation_opd_requiredfield` WHERE FieldName='LMP' AND LedgertransactionId=lt.LedgertransactionId),'N/A') LMP,IF(plo.DepartmentTokenNo=0,'',DepartmentTokenNo)DepartmentTokenNo  ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN patient_labInvestigation_opd plo ON lt.LedgertransactionId=plo.LedgertransactionId   ");
            sb.Append(" AND plo.ReportType <> 5 AND plo.IsReporting=1  AND lt.LedgertransactionID=@LedgertransactionId  ");
            sb.Append(" INNER JOIN f_subcategoryMaster scm ON plo.SubcategoryId=scm.SubcategoryId  ");
            sb.Append(" INNER JOIN patient_master pm ON lt.Patient_Id=pm.Patient_Id  ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreId=lt.CentreId  ");
            sb.Append(" INNER JOIN `investigations_sampletype` stm ON stm.Investigation_Id=plo.Investigation_Id  AND stm.IsDefault=1  ");
            sb.Append(" GROUP BY stm.SampleTypeId  ");

          

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                                             new MySqlParameter("@LedgertransactionId", LedgertransactionId)).Tables[0])
            {

                if (dt.Rows.Count > 0)
                {
                    StringBuilder sbWorklist = new StringBuilder();
                    sbWorklist.Append("<div style='width:800px;'>");
                    sbWorklist.Append("<table style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:15px;'");
                    sbWorklist.Append("<tr>");
                    sbWorklist.Append("<td style='padding:15px 5px;'><span style='font-size:20px !important;font-weight:bold; text-align:center;'>Department Slip </span>");
                    sbWorklist.Append("</td>");
                    sbWorklist.Append("<td style='text-align:right;'>");
                    sbWorklist.AppendFormat("<img style='width:200px;margin-right:-10px' src='{0}'/>", new Barcode_alok().Save(dt.Rows[0]["LedgerTransactionNo"].ToString()).Trim());
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
                    sbWorklist.AppendFormat("<td style='font-weight:bold;;width:120px'>{0}</td>", Util.GetString(dt.Rows[0]["LedgertransactionNo"]));
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
                    sbWorklist.Append("<td style='font-weight:bold;width:100px' >Barcodeno : </td>");
                    sbWorklist.AppendFormat("<td style='font-weight:bold;width:120px'>{0}</td>", Util.GetString(dt.Rows[0]["Barcodeno"]));
                    sbWorklist.Append("</tr>");

                  // sbWorklist.Append("<tr>");
                  // sbWorklist.Append("<td style='width:100px;font-weight:bold;' >Centre : </td>");
                  // sbWorklist.AppendFormat("<td colspan='2' style='font-weight:100;width:130px;'>{0}</td>", Util.GetString(dt.Rows[0]["Centre"]));
                  // sbWorklist.Append("<td  style='font-weight:bold;width:100px'></td>");
                  // sbWorklist.Append("<td style='font-weight:bold;width:100px' > </td>");
                  // // sbWorklist.Append("<td style='font-weight:bold;width:120px'></td>");
                  // sbWorklist.Append("</tr>");
                    sbWorklist.Append("</table>");
                    sbWorklist.Append("</div>");

                    //-----------------------Added By Apurva : 04-03-2020------------------------------

                    sbWorklist.Append("<div style='width:800px;margin-top:5px;'>");
                    sbWorklist.Append("<table style='width:800px;border:1px solid #000; font-family:Times New Roman;font-size:12px;'>");

                    sbWorklist.Append("<tr>");
                    sbWorklist.Append("<td style='width:120px;font-weight:bold;' >Patient Address : </td>");
                    sbWorklist.AppendFormat("<td colspan='2' style='font-weight:100;width:130px;'>{0}</td>", Util.GetString(dt.Rows[0]["PAddress"]));
                    //sbWorklist.Append("<td  style='font-weight:bold;width:100px'></td>");
                    sbWorklist.Append("<td style='font-weight:bold;width:100px' >Referral Doctor : </td>");
                    sbWorklist.AppendFormat("<td style='font-weight:100;width:120px'>{0}</td>", Util.GetString(dt.Rows[0]["ReferDoctor"]));
                    sbWorklist.Append("</tr>");

              //     sbWorklist.Append("<tr>");
              //     sbWorklist.Append("<td style='width:100px;font-weight:bold;' >Patient Sign. :  </td>");
              //     sbWorklist.AppendFormat("<td colspan='2' style='font-weight:100;width:130px; '></td>");
              //     //sbWorklist.Append("<td  style='font-weight:bold;width:100px'></td>");
              //     sbWorklist.Append("<td style='font-weight:bold;width:100px' >LMP : </td>");
              //     sbWorklist.AppendFormat("<td style='font-weight:100;width:120px;font-size:11px;'>{0}</td>", Util.GetString(dt.Rows[0]["LMP"]));
              //     sbWorklist.Append("</tr>");

                 //  sbWorklist.Append("<tr>");
                 //  sbWorklist.Append("<td style='width:100px;font-weight:bold;' >Patient Sign. : </td>");
                 //  sbWorklist.Append("<td style='font-weight:100;width:130px; '></td>");
                 //  sbWorklist.Append("<td  style='font-weight:bold;width:100px'></td>");
                 //  sbWorklist.Append("<td style='font-weight:bold;width:100px' > </td>");
                 //  sbWorklist.Append("<td style='font-weight:100;width:120px'></td>");
                 //  sbWorklist.Append("</tr>");

                    sbWorklist.Append("</table>");
                    sbWorklist.Append("</div>");

                    //----------------------------------------------------
                 //   sbWorklist.Append("<div style='width:550px;margin-top:10px;height:30px;'>");
                  //  sbWorklist.Append("<table style='width:550px;border-collapse:collapse;font-family:Times New Roman;font-size:12px;' >");
                   // sbWorklist.Append("<tr>");
                    //sbWorklist.AppendFormat("<td style='text-align:right;'><img style='width:200px;margin-right:-10px' src='{0}'/></td>", new Barcode_alok().Save(dt.Rows[0]["LedgerTransactionNo"].ToString()).Trim());

                  //  sbWorklist.Append("</table></div>");

                    //<img src='" + new Barcode_alok().Save(drcurrent["LedgerTransactionNo"].ToString()).Trim() + "'/>
                    sbWorklist.Append("<div style='width:800px;margin-top:5px;'>");
                    sbWorklist.Append("<table style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:12px;' >");
                    foreach (DataRow dr in dt.Rows)
                    {
                        drcurrent = dr;
                        if (dt.Rows.IndexOf(dr)==0)
                        {
                            
                            sbWorklist.Append("<tr>");
                            sbWorklist.AppendFormat("<th style='width:120px;font-weight:bold;border:1px solid #000;' >{0}</th>", Util.GetString(dr["Type"]));
                            sbWorklist.Append("<th style='width:370px;font-weight:bold;border:1px solid #000;' >Investigation </th>");
                            sbWorklist.Append("<th style='width:20px;font-weight:bold;border:1px solid #000;' >TNo. </th>");
                            // sbWorklist.Append("<th style='width:80px;font-weight:bold;border:1px solid #000;' >Status </th>");
                            sbWorklist.Append("<th style='width:60px;font-weight:bold;border:1px solid #000;' >Sign </th>");
                            sbWorklist.Append("<th style='width:60px;font-weight:bold;border:1px solid #000;' >Name </th>");

                            sbWorklist.Append("</tr>");
                        }
                        else if (Util.GetString(dr["Type"]) != dt.Rows[dt.Rows.IndexOf(dr) - 1]["Type"].ToString() && dt.Rows[dt.Rows.IndexOf(dr) - 1]["ReportType"].ToString()=="5")
                        {
                            sbWorklist.Append("</table>");
                            sbWorklist.Append("</div>");
                            sbWorklist.Append("<div style='width:800px;margin-top:5px;'>");
                            sbWorklist.Append("<table style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:12px;' >");
                            sbWorklist.Append("<tr>");
                            sbWorklist.AppendFormat("<th style='width:120px;font-weight:bold;border:1px solid #000;' >{0}</th>", Util.GetString(dr["Type"]));
                            sbWorklist.Append("<th style='width:370px;font-weight:bold;border:1px solid #000;' >Investigation </th>");
                            sbWorklist.Append("<th style='width:20px;font-weight:bold;border:1px solid #000;' >TNo. </th>");
                            // sbWorklist.Append("<th style='width:80px;font-weight:bold;border:1px solid #000;' >Status </th>");
                            sbWorklist.Append("<th style='width:60px;font-weight:bold;border:1px solid #000;' >Sign </th>");
                            sbWorklist.Append("<th style='width:60px;font-weight:bold;border:1px solid #000;' >Name </th>");

                            sbWorklist.Append("</tr>");
                        }
                        sbWorklist.Append("<tr>");

                        sbWorklist.AppendFormat("<td style='text-align:centre;font-weight:100;width:120px;border:1px solid #000;'>{0}</td>", Util.GetString(dr["Department"]));
                        sbWorklist.AppendFormat("<td  style='font-weight:100;width:370px;border:1px solid #000;'>{0}</td>", Util.GetString(dr["Tests"]));
                        sbWorklist.AppendFormat("<td style='font-weight:100;width:20px;border:1px solid #000;text-align:center' >{0}</td>", Util.GetString(dr["DepartmentTokenNo"]));
                        //sbWorklist.Append("<td style='font-weight:100;width:100px;border:1px solid #000;' ></td>");
                        sbWorklist.Append("<td style='font-weight:100;width:60px;border:1px solid #000;'></td>");
                        sbWorklist.Append("<td style='font-weight:100;width:60px;border:1px solid #000;'></td>");

                        sbWorklist.Append("</tr>");
                       
                    }
                    sbWorklist.Append("</table>");
                    sbWorklist.Append("</div>");
                    #endregion "1 row"

                    //  SetHeader(tempDocument.Pages[tempDocument.Pages.Count - 1]);
                    // SetHeaderImage(tempDocument.Pages[tempDocument.Pages.Count - 1]);
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
            lblmsg.Text = ex.Message;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
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
        string path = "";// "../../App_Images/Max Lab_Logo.jpg";
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
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }

    private PdfImage getPDFImageFooter(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(20, 0, Server.MapPath(SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }

    private string MakeHeader()
    {
        string headertext = "";
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
            PdfHtml linehtml = new PdfHtml(XFooter, -4, "<div style='width:640px;border-top:3px solid black;font-weight:bold;'></div>", null);

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
           // p.Footer.Layout(linehtml);
            p.Footer.Layout(pageNumberingText);
            p.Footer.Layout(printdatetime);
            document.Pages.AddPage(p);
            pageno++;
        }

        tempDocument = new PdfDocument();
    }
}

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

public partial class Design_Lab_PatientReceiptNew : System.Web.UI.Page
{

    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs;
    DataTable dtSettlement;
    DataTable dtRefund;

    //Page Property

    const int MarginLeft = 20;
    const int PageWidth = 550;
    const int BrowserWidth = 800;



    //Header Property
    const float HeaderHeight = 178;//207
    const int XHeader = 20;//20
    const int YHeader = 60;//80
    const int HeaderBrowserWidth = 800;


    // BackGround Property
    bool HeaderImage = false;
    bool FooterImage = false;
    bool BackGroundImage = true;
    string HeaderImg = "";

    //Footer Property 80
    const float FooterHeight = 450;

    DataRow drcurrent;

    string id = string.Empty;
    string name = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        id = Util.GetString(UserInfo.ID);
        name = UserInfo.LoginName;
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
        try
        {
            StringBuilder sb = new StringBuilder();
            BindData();
            if (dtObs.Rows.Count == 0)
            {
                Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong . Please Refresh Page Or Contact To Admin..!<span><br/><input type='button' value='Refresh' style='cursor:pointer;font-weight:bold;' onclick='window.location.reload();'/></center>");
                return;
            }

            if (dtObs.Rows[0]["AAALogo"].ToString() == "0")
            {
                BackGroundImage = false;
            }
            sb.Append("<div style='width:800px;'>");
            sb.Append("<table style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:11px;'>");
            sb.Append("<tr style='border-bottom:1px solid black;'>");
            sb.Append("<td style='width:50px;font-weight:bold;' >#</td>");
            sb.Append("<td style='font-weight:bold;width:100px;'>Service Code</td>");
            sb.Append("<td style='font-weight:bold;width:350px' >Service Name</td>");
            sb.Append("<td style='font-weight:bold;width:70px'>Barcode No.</td>");
            if (Util.GetInt(dtObs.Rows[0]["HideReceiptRate"]) == 1 || Util.GetInt(dtObs.Rows[0]["IsMRPBIll"]) == 1)
            {
                sb.Append("<td style='font-weight:bold;width:80px;text-align:right;'></td>");
            }
            else
            {
                sb.Append("<td style='font-weight:bold;width:80px;text-align:right;'>Rate</td>");
            }
            if (Util.GetFloat(dtObs.Rows[0]["DiscountOnTotal"]) == 0 || Util.GetInt(dtObs.Rows[0]["HideReceiptRate"]) == 1 || Util.GetInt(dtObs.Rows[0]["IsMRPBIll"]) == 1)
            {
                sb.Append("<td style='font-weight:bold;width:80px;text-align:right;'></td>");
            }
            else
            {
                sb.Append("<td style='font-weight:bold;width:80px;text-align:right;'>Discount</td>");
            }
            if (Util.GetInt(dtObs.Rows[0]["HideReceiptRate"]) == 1)
            {
                sb.Append("<td style='font-weight:bold;width:80px;text-align:right;'></td>");
            }
            else
            {
                sb.Append("<td style='font-weight:bold;width:80px;text-align:right;'>Total</td>");
            }
            sb.Append("</tr>");
            int serialno = 1;
            foreach (DataRow dw in dtObs.Rows)
            {
                sb.Append("<tr>");
                sb.AppendFormat("<td>{0}</td>", serialno);
                sb.AppendFormat("<td>{0}</td>", Util.GetString(dw["testcode"]));
                sb.AppendFormat("<td>{0}</td>", Util.GetString(dw["itemname"]));

                sb.AppendFormat("<td>{0}</td>", Util.GetString(dw["barcodeno"]));

                if (Util.GetInt(dtObs.Rows[0]["HideReceiptRate"]) == 1 || Util.GetInt(dtObs.Rows[0]["IsMRPBIll"]) == 1)
                {
                    sb.Append("<td style='text-align:right;'></td>");
                }
                else
                {
                    sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Util.GetString(dw["rate"]));
                }
                if (Util.GetFloat(dtObs.Rows[0]["DiscountOnTotal"]) == 0 || Util.GetInt(dtObs.Rows[0]["HideReceiptRate"]) == 1 || Util.GetInt(dtObs.Rows[0]["IsMRPBIll"]) == 1)
                {
                    sb.Append("<td style='text-align:right;'></td>");
                }
                else
                {
                    sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Util.GetString(dw["discountamt"]));
                }
                if (Util.GetInt(dtObs.Rows[0]["HideReceiptRate"]) == 1)
                {
                    sb.Append("<td style='text-align:right;'></td>");
                }
                else
                {
                    sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Util.GetString(dw["Amount"]));
                }
                sb.Append("</tr>");
                serialno++;
                drcurrent = dtObs.Rows[dtObs.Rows.IndexOf(dw)];
            }
            sb.Append("<tr>");
            sb.Append("  <td colspan='4' rowspan='5'>");
            // Settlement Data
            if (Util.GetInt(drcurrent["IsMRPBIll"]) == 0)
            {
                if (dtSettlement.Rows.Count > 0)
                {
                    sb.Append("<table style='width:600px;border-collapse:collapse;font-family:Times New Roman;font-size:11px;'>");
                    sb.Append("<tr style='border:1px solid black;'>");
                    sb.Append("<td style='font-weight:bold;width:100px'>Settlement</td>");
                    sb.Append("<td style='font-weight:bold;width:100px'>Payment</td>");
                    sb.Append("<td style='font-weight:bold;width:170px'>Receipt No.</td>");
                    sb.Append("<td style='font-weight:bold;width:80px'>Mode</td>");
                    sb.Append("<td style='font-weight:bold;width:50px'>Currency</td>");
                    sb.Append("<td style='font-weight:bold;width:50px;text-align:right;'>Amount</td>");
                    sb.Append("<td style='font-weight:bold;width:140px'>&nbsp;&nbsp;Received By</td>");
                    sb.Append("</tr>");
                    foreach (DataRow dwc in dtSettlement.Rows)
                    {
                        string msg = "Settlement";

                        if (Util.GetFloat(dwc["Amount"]) < 0)
                        {
                            msg = "Refund";
                        }
                        sb.Append("<tr>");
                        sb.AppendFormat("<td>{0}</td>", Util.GetString(msg));
                        sb.AppendFormat("<td>{0}</td>", Util.GetString(dwc["EntryDateTime"]));
                        sb.AppendFormat("<td>{0}</td>", Util.GetString(dwc["ReceiptNo"]));
                        sb.AppendFormat("<td>{0}</td>", Util.GetString(dwc["PaymentMode"]));
                        sb.AppendFormat("<td>{0}</td>", Util.GetString(dwc["S_Notation"]));
                        sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Util.GetString(dwc["Amount"]));
                        sb.AppendFormat("<td>{0}</td>", Util.GetString(string.Concat("&nbsp;&nbsp;",dwc["UserName"])));
                        sb.Append("</tr>");
                    }

                    sb.Append("</table>");
                }
            }
            sb.Append("</td>");
            if (Util.GetInt(drcurrent["HideReceiptRate"]) == 1)
            {
                sb.Append("<td colspan='2' style='text-align:right;'><b></b></td>");
                sb.Append("<td style='text-align:right;'></td>");
            }
            else
            {
                sb.Append("<td colspan='2' style='text-align:right;'><b>Bill Amount :</b></td>");
                sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Util.GetString(drcurrent["grossamount"]));
            }
            sb.Append("</tr>");
            sb.Append("<tr>");
            if (Util.GetFloat(drcurrent["DiscountOnTotal"]) == 0 || Util.GetInt(drcurrent["HideReceiptRate"]) == 1 || Util.GetInt(drcurrent["IsMRPBIll"]) == 1)
            {
                sb.Append("<td colspan='2' style='text-align:right;'></td>");
                sb.Append("<td style='text-align:right;'></td>");
            }
            else
            {
                sb.Append("<td colspan='2' style='text-align:right;'><b>Total Discount :</b></td>");
                sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Util.GetString(drcurrent["discountontotal"]));
            }
            sb.Append("</tr>");
            sb.Append("<tr>");
            if (Util.GetInt(drcurrent["HideReceiptRate"]) == 1 || Util.GetInt(drcurrent["IsMRPBIll"]) == 1)
            {
                sb.Append("<td colspan='2' style='text-align:right;'></td>");
                sb.Append("<td style='text-align:right;'></td>");
            }
            else
            {
                sb.Append("<td colspan='2' style='text-align:right;'><b>Net Bill Amount :</b></td>");
                sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Util.GetString(drcurrent["netamount"]));
            }
            sb.Append("</tr>");
            sb.Append("<tr>");
            if (Util.GetInt(drcurrent["HideReceiptRate"]) == 1 || Util.GetInt(drcurrent["IsMRPBIll"]) == 1)
            {
                sb.Append("<td colspan='2' style='text-align:right;'></td>");
                sb.Append("<td style='text-align:right;'></td>");
            }
            else
            {
                sb.Append("<td colspan='2' style='text-align:right;'><b>Total Paid Amount :</b></td>");
                sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Util.GetString(drcurrent["adjustment"]));
            }
            sb.Append("</tr>");
            float dueamount = Util.GetFloat(drcurrent["netamount"]) - Util.GetFloat(drcurrent["adjustment"]);
            sb.Append("<tr>");
            if (dueamount == 0 || Util.GetInt(drcurrent["HideReceiptRate"]) == 1 || Util.GetInt(drcurrent["IsMRPBIll"]) == 1)
            {
                sb.Append("<td colspan='2' style='text-align:right;'></td>");
                sb.Append("<td style='text-align:right;'></td>");
            }
            else
            {
                sb.Append("<td colspan='2' style='text-align:right;'><b>Due Amount :</b></td>");
                sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Util.GetString(dueamount));
            }
            sb.Append("</tr>");
            sb.Append("<tr style='border-top:1px solid black;'>");
            if (Util.GetInt(drcurrent["HideReceiptRate"]) == 1 || Util.GetInt(drcurrent["IsMRPBIll"]) == 1)
            {
                sb.Append("<td colspan='5'>");
                sb.Append("</td>");
            }
            else
            {
                sb.Append("<td colspan='5'><b>Received with thanks :</b> " + Util.GetString(drcurrent["AmountInWord"]));
                sb.Append("</td>");
            }
            sb.Append("<td colspan='2'><b>Authorized Signature :</b></td>");

            sb.Append("</tr>");

            if (drcurrent["GSTIN"].ToString() == "" || drcurrent["ShowGST"].ToString() == "")
            {
                sb.Append("<tr><td colspan='7' style='font-weight:bold;'></td></tr>");
                sb.Append("<tr><td colspan='7' style='font-weight:bold;'></td></tr>");
            }
            else
            {
                sb.AppendFormat("<tr><td colspan='7' style='font-weight:bold;'>GSTIN :{0}</td></tr>", Util.GetString(drcurrent["GSTIN"]));
                sb.AppendFormat("<tr><td colspan='7' style='font-weight:bold;'>Address :{0}</td></tr>", Util.GetString(drcurrent["GSTINAddress"]));
            }

            if (drcurrent["AAALogo"].ToString() == "0")
            {

                sb.Append("<tr><td colspan='7' style='font-size:18px !important;font-weight:bold;'></td></tr>");
            }
            else
            {
                sb.AppendFormat("<tr><td colspan='7' style='font-size:18px !important;font-weight:bold;'>{0}</td></tr>", Util.GetString(drcurrent["AAALogoContent"]));
            }

            // Refund Data

            if (Util.GetInt(drcurrent["IsMRPBIll"]) == 0)
            {
                if (dtRefund.Rows.Count > 0)
                {
                    sb.Append("<tr><td colspan='7'>");
                    sb.Append("<div style='page-break-inside:avoid;width:760px;'>");
                    sb.Append("<table style='width:750px;border-collapse:collapse;font-family:Times New Roman;font-size:11px;'>");
                    sb.AppendFormat("<tr><td colspan='4' style='text-align:center;font-weight:bold;'>Refund Details Of Visit No. {0}</td></tr>", drcurrent["LedgerTransactionNo"]);
                    sb.Append("<tr style='border-top:1px solid black;border-bottom:1px solid black;'>");
                    sb.Append("<td style='width:50px' style='font-weight:bold;'>#</td>");
                    sb.Append("<td style='font-weight:bold;width:100px;'>Service Code</td>");
                    sb.Append("<td style='font-weight:bold;width:350px'>Service Name</td>");
                    sb.Append("<td style='font-weight:bold;width:250px;text-align:right;'>Rate</td>");
                    sb.Append("</tr>");
                    int sn = 1;
                    foreach (DataRow dwr in dtRefund.Rows)
                    {
                        sb.Append("<tr>");
                        sb.AppendFormat("<td>{0}</td>", sn);
                        sb.AppendFormat("<td>{0}</td>", Util.GetString(dwr["testcode"]));
                        sb.AppendFormat("<td>{0}</td>", Util.GetString(dwr["itemname"]));
                        sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Util.GetString(dwr["rate"]));
                        sb.Append("</tr>");
                        sn++;
                    }
                    sb.Append("<tr><td colspan='4'><br/></td></tr>");
                    sb.Append("<tr><td colspan='4'>");
                    sb.Append("<table style='width:600px;border-collapse:collapse;font-family:Times New Roman;font-size:11px;'>");
                    sb.Append("<tr style='border:1px solid black;'>");
                    sb.Append("<td style='font-weight:bold;width:100px'>Settlement</td>");
                    sb.Append("<td style='font-weight:bold;width:100px'>Payment</td>");
                    sb.Append("<td style='font-weight:bold;width:170px'>Receipt No.</td>");
                    sb.Append("<td style='font-weight:bold;width:80px'>Mode</td>");
                    sb.Append("<td style='font-weight:bold;width:50px'>Currency</td>");
                    sb.Append("<td style='font-weight:bold;width:50px;text-align:right;'>Amount</td>");
                    sb.Append("<td style='font-weight:bold;width:140px'>&nbsp;&nbsp;Received By</td>");
                    sb.Append("</tr>");

                    sb.Append("<tr>");
                    string msg1 = "Settlement";

                    if (Util.GetFloat(dtRefund.Rows[0]["Amount"]) < 0)
                    {
                        msg1 = "Refund";
                    }

                    sb.AppendFormat("<td >{0}</td>", msg1);
                    sb.AppendFormat("<td >{0}</td>", Util.GetString(dtRefund.Rows[0]["entrydatetime"]));
                    sb.AppendFormat("<td >{0}</td>", Util.GetString(dtRefund.Rows[0]["receiptno"]));
                    sb.AppendFormat("<td >{0}</td>", Util.GetString(dtRefund.Rows[0]["PaymentMode"]));
                    sb.AppendFormat("<td >{0}</td>", Util.GetString(dtRefund.Rows[0]["S_Notation"]));
                    sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Util.GetString(dtRefund.Rows[0]["grossAmount"]));
                    sb.AppendFormat("<td >{0}</td>", Util.GetString(string.Concat("&nbsp;&nbsp;", dtRefund.Rows[0]["UserName"])));
                    sb.Append("</tr>");

                    sb.AppendFormat("<tr><td colspan='5' style='text-align:right;font-weight:bold;'>Total Refund Amount : {0}</td></tr>", Util.GetString(dtRefund.Rows[0]["grossamount"]));
                    sb.Append("</table></td></tr>");
                    sb.Append("</table></div></td></tr>");
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
            HttpContext.Current.Response.Flush();
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
        //set background iamge in pdf report.
        if (BackGroundImage == true)
        {
            HeaderImg = "App_Images/WatermarkReceipt.png";
            page1.Layout(getPDFBackGround(HeaderImg));
        }
        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);
        SetFooter(page1);
    }
    private void SetHeader(PdfPage page)
    {
        page.CreateHeaderCanvas(HeaderHeight);
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader, PageWidth, MakeHeader(), null) { FitDestWidth = true, FontEmbedding = false, BrowserWidth = HeaderBrowserWidth };
        page.Header.Layout(headerHtml);
        page.Header.Layout(getPDFImageforbarcode(50, 150, drcurrent["LedgerTransactionNo"].ToString()));
        if (drcurrent["HeaderImage"].ToString().Length > 0)
            HeaderImage = true;
        if (HeaderImage)
        {
            page.Header.Layout(getPDFImageHeader(drcurrent["HeaderImage"].ToString()));
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
    private PdfImage getPDFImageforbarcode(float X, float Y, string labno)
    {
        string image = "";
        image = new Barcode_alok().Save(labno).Trim();
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Base64StringToImage(image)) { PreserveAspectRatio = true };
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
        PdfImage transparentResizedPdfImage = new PdfImage(225, 110, 200, Server.MapPath("~/" + SignImg)) { PreserveAspectRatio = true };
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }

    private PdfImage getPDFImageFooter(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(20, 0, Server.MapPath(SignImg)) { PreserveAspectRatio = true };
        //transparentResizedPdfImage.AlphaBlending = true;
        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }

    private PdfImage getPDFImageHeader(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(20, 10, Server.MapPath(SignImg)) { PreserveAspectRatio = true };
        //transparentResizedPdfImage.AlphaBlending = true;
        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }

    private string MakeHeader()
    {
        string headertext = "";
        if (Util.GetInt(drcurrent["IsRefund"]) == 1)
        {
            headertext = "Refund";
        }
        else
        {
            headertext = "BILL OF SUPPLY";
        }

        string isduplicate = "";

        if (Util.GetInt(drcurrent["Bill_Count"]) > 0)
        {
            if (Util.GetInt(drcurrent["IsRefund"]) == 1)
            {
                isduplicate = "Refund";
            }
            else
            {
                isduplicate = "Duplicate";
            }
        }
        else
        {
            if (Util.GetInt(drcurrent["IsRefund"]) == 1)
            {
                isduplicate = "Refund";
            }
            else
            {
                isduplicate = "Original";
            }
        }
        StringBuilder Header = new StringBuilder();
        Header.Append("<div style='width:800px;'>");
        Header.Append("<table style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:11px;'>");
        Header.Append("<tr style='border-top:1px solid black;'>");
        Header.AppendFormat("<td colspan='4' style='text-align:center;width:800px;font-weight:bold;'>{0} <span style='float:right'>{1}</span></td>", headertext, isduplicate);
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td style='width:100px;font-weight:bold;'>Name</td>");
        Header.AppendFormat("<td style='width:380px'>{0}</td>", Util.GetString(drcurrent["pname"]));
        Header.Append("<td style='width:90px;font-weight:bold;'>Bill</td>");
        Header.AppendFormat("<td style='width:230px;'>{0}</td>", Util.GetString(drcurrent["billno"]));
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td style='font-weight:bold;'>Age/Gender</td>");
        Header.AppendFormat("<td>{0}/{1}</td>", Util.GetString(drcurrent["age"]), Util.GetString(drcurrent["gender"]));
        Header.Append("<td style='font-weight:bold;'>Visit/Reg. Date</td>");
        Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["regdate"]));
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td style='font-weight:bold;'>Contact No.</td>");
        Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["mobile"]));
        Header.Append("<td style='font-weight:bold;'>Refered By</td>");
        Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["doctorname"]));
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td style='font-weight:bold;'>Address</td>");
        Header.AppendFormat("<td style='white-space: nowrap; overflow: hidden;width:380px;'>{0}</td>", Util.GetString(drcurrent["address"]));
        Header.Append("<td style='font-weight:bold;'>Visit No.</td>");
        Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["LedgerTransactionNo"]));
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td style='font-weight:bold;'>UHID</td>");
        Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["patient_id"]));
        Header.Append("<td style='font-weight:bold;'>Center</td>");
        Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["centre"]));
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td style='font-weight:bold;'>Home Collection</td>");
        Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["visittype"]));
        Header.Append("<td style='font-weight:bold;'>Center Ph. No.</td>");
        Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["CenterContact"]));
        Header.Append("</tr>");
        Header.Append("<tr style='border-bottom:1px solid black;'>");
        Header.Append("<td></td>");
        Header.Append("<td></td>");
        Header.Append("<td style='font-weight:bold;' valign='top'>Center Address</td>");
        Header.AppendFormat("<td><div style='height:50px;overflow:hidden;'>{0}</div></td>", Util.GetString(drcurrent["CenterAddress1"]));
        Header.Append("</tr>");
        Header.Append("</div>");
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
            Font pageNumberingFont =
          new Font(new FontFamily("Times New Roman"), 8, GraphicsUnit.Point);
            PdfText pageNumberingText = new PdfText(PageWidth, FooterHeight, String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont) { ForeColor = Color.Black };
            PdfText printdatetime = new PdfText(PageWidth - 100, FooterHeight, DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont) { ForeColor = Color.Black };

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
    private void BindData()
    {

        int MRPBill = 0;
        if (Request.QueryString["MRPBill"] != null)
            MRPBill = Util.GetInt(Request.QueryString["MRPBill"]);

        string PostValue = Request.Form["LabID"];
        string MRPBill1 = Request.Form["MRPBill"];
        string labid = Util.GetString(Common.Decrypt(Request.Form["LabID"]));
      //  string labid = Util.GetString(Common.Decrypt(Request.QueryString["LabID"]));
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            int isRefund = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT count(1) FROM opd_refund WHERE old_LedgerTransactionNo=(select LedgerTransactionNo from patient_labinvestigation_opd where LedgerTransactionID=@LedgerTransactionID LIMIT 1) ",
               new MySqlParameter("@LedgerTransactionID", labid)));

            // For Settlement

            dtSettlement = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ReceiptNo,PaymentMode,S_Notation,S_Currency,Amount,DATE_FORMAT(EntryDateTime,'%d-%m-%Y') EntryDateTime,UserId,UserName FROM f_reciept WHERE `LedgerTransactionID`=@LedgerTransactionID ",
               new MySqlParameter("@LedgerTransactionID", labid)).Tables[0];

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT sm.State,sm.GSTIN,IFNULL(sm.GSTINAddress,'')GSTINAddress,IF(lt.DATE>'2017-07-01',1,0)ShowGST,fpm.HideReceiptRate,LT.Password_web,lt.Username_web,lt.Bill_Count,cm.Mobile CenterContact,left(replace(cm.`Address`,',',', '),150) CenterAddress1,cm.Locality CenterAddress2,CONCAT(pm.title,pm.pname) pname,pm.`Patient_ID`,lt.`LedgerTransactionNo`,plo.`BillNo`,cm.`Centre`,lt.`IsCancel`, plo.`Barcode_Group`,DATE_FORMAT(plo.`DeliveryDate`,'%d-%b-%Y %h:%i%p') DeliveryDate,cm.HeaderImage,cm.FooterImage, ");//cm.HeaderImage,cm.FooterImage,  ");
            if (isRefund > 0)
                sb.Append(" '1' IsRefund,");
            else
                sb.Append(" '0' IsRefund,");
            if (dtSettlement.Rows.Count > 0)
                sb.Append(" '1' IsSettlementEntry,");
            else
                sb.Append(" '0' IsSettlementEntry,");
            sb.Append(" pm.`Age`,pm.`Gender`,pm.`Mobile`, lt.`PanelName`,IF(lt.`Doctor_ID`='2', ");
            sb.Append(" lt.`OtherDoctorName`,Concat('Dr.',lt.`DoctorName`)) Doctorname, DATE_FORMAT(lt.`Date`,'%d-%b-%Y %h:%i%p') RegDate, ");
            sb.Append(" left(TRIM(BOTH ',' FROM CONCAT(IFNULL(pm.House_No,''),',',IFNULL(pm.`Locality`,''),',',IFNULL(pm.`City`,''))),60) Address,plo.IsPackage, ");
            sb.Append(" itm.TypeName ItemName, ");
            sb.AppendFormat(" itm.TestCode ,plo.rate, plo.`DiscountAmt`,IF('{0}'=0,plo.`Amount`,plo.MRP)Amount, DATE_FORMAT(plo.deliverydate,'%d-%b-%Y %h:%i%p')deliverydate,  lt.`GrossAmount`, ", MRPBill);
            sb.Append(" lt.`DiscountOnTotal`,lt.`NetAmount`,lt.`Adjustment`, ");
            sb.Append(" (SELECT em.name FROM employee_master em WHERE em.employee_id=lt.`Creator_UserID`)UserName , ");
            sb.AppendFormat(" sc.`Name`DepartmentName ,'{0}' IsMRPBIll,IF(lt.`VisitType`='Home Collection','Yes','No')VisitType ", MRPBill);
            sb.Append(" ,'0' `AAALogo`,'' AAALogoContent,plo.barcodeno  ");
            sb.Append(" FROM patient_labinvestigation_opd plo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` AND IF(isPackage=1,`SubCategoryID`=15,`SubCategoryID`!=15) ");
            sb.Append(" AND lt.`LedgerTransactionID`=@LedgerTransactionID ");
            sb.Append("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.`Panel_ID` ");
            sb.Append(" INNER JOIN f_itemmaster itm on itm.ItemID=plo.ItemID ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
            sb.Append(" INNER JOIN state_master sm ON sm.ID=cm.StateID ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`  GROUP BY plo.`ItemId` ");
            sb.Append(" ORDER BY sc.`Name`,plo.ispackage,plo.itemname ");
            dtObs = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@LedgerTransactionID", labid)).Tables[0];

            dtObs.Columns.Add("AmountInWord", typeof(string));
            NumberToWordsConvertor nw = new NumberToWordsConvertor();
            string amtWord = nw.NumberToText(Util.GetInt(dtObs.Rows[0]["Adjustment"]));

            if (amtWord.Trim() != "")
            {
                dtObs.Rows[dtObs.Rows.Count - 1]["AmountInWord"] = amtWord.Trim();
            }
            else
            {
                dtObs.Rows[dtObs.Rows.Count - 1]["AmountInWord"] = "";
            }

            dtObs.AcceptChanges();


            string refundLedgerTransactionID = string.Empty;
            if (Util.GetInt(isRefund) > 0)
            {
                string oldLabNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " select LedgerTransactionNo from f_ledgertransaction where LedgerTransactionID=@LedgerTransactionID ",
                    new MySqlParameter("@LedgerTransactionID", labid)));
                string newLabNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " select new_LedgerTransactionNo from opd_refund where old_LedgerTransactionNo=@old_LedgerTransactionNo ",
                    new MySqlParameter("@old_LedgerTransactionNo", oldLabNo)));
                refundLedgerTransactionID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT LedgerTransactionID from f_ledgertransaction where LedgerTransactionNo=@newLabNo ",
                    new MySqlParameter("@newLabNo", newLabNo)));
            }
            sb = new StringBuilder();
            sb.Append(" SELECT lt.`IsCredit`,LT.Password_web,lt.Bill_Count,cm.Mobile CenterContact,left(replace(cm.`Address`,',',', '),150) CenterAddress1,cm.Locality CenterAddress2,CONCAT(pm.title,pm.pname) pname,pm.`Patient_ID`,lt.`LedgerTransactionNo`,plo.`BillNo`,cm.`Centre`,lt.`IsCancel`, plo.`Barcode_Group`,DATE_FORMAT(plo.`DeliveryDate`,'%d-%b-%Y %h:%i%p') DeliveryDate,cm.HeaderImage,cm.FooterImage, ");//cm.HeaderImage,cm.FooterImage,  ");
            sb.Append("  r.ReceiptNo,r.PaymentMode,r.S_Notation,r.S_Currency,r.Amount,DATE_FORMAT(r.EntryDateTime,'%d-%m-%Y') EntryDateTime,r.UserId, ");
            sb.Append(" pm.`Age`,pm.`Gender`,pm.`Mobile`, lt.`PanelName`,IF(lt.`Doctor_ID`='2', ");
            sb.Append(" lt.`OtherDoctorName`,Concat('Dr.',lt.`DoctorName`)) Doctorname, DATE_FORMAT(lt.`Date`,'%d-%b-%Y %h:%i%p') RegDate, ");
            sb.Append(" TRIM(BOTH ',' FROM CONCAT(IFNULL(pm.House_No,''),',',IFNULL(pm.`Locality`,''),',',IFNULL(pm.`City`,''))) Address, ");
            sb.Append(" plo.IsPackage, itm.TypeName ItemName ,itm.TestCode ,plo.rate, plo.`DiscountAmt`,plo.`Amount`, ");
            sb.Append(" DATE_FORMAT(plo.deliverydate,'%d-%b-%Y %h:%i%p')deliverydate,  lt.`GrossAmount`, ");
            sb.Append(" lt.`DiscountOnTotal`,lt.`NetAmount`,lt.`Adjustment`, ");
            sb.Append(" (SELECT em.name FROM employee_master em WHERE em.employee_id=lt.`Creator_UserID`)UserName , ");
            sb.Append(" sc.`Name`DepartmentName     FROM patient_labinvestigation_opd plo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`");
            sb.Append(" AND lt.`LedgerTransactionID`=@LedgerTransactionID ");
            sb.Append(" INNER JOIN f_itemmaster itm on itm.ItemID=plo.ItemID ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID` ");
            sb.Append(" LEFT JOIN f_reciept r ON r.LedgerTransactionID=lt.LedgerTransactionID and r.iscancel=0 ");
            sb.Append("  GROUP BY plo.`ItemId`  ORDER BY sc.`Name`,plo.ispackage,plo.itemname ");
            dtRefund = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@LedgerTransactionID", refundLedgerTransactionID.Trim())).Tables[0];
            if (dtRefund.Rows.Count > 0 && dtObs.Rows.Count > 0)
            {
                dtRefund.Columns.Add("HideReceiptRate");
                dtRefund.Columns.Add("IsMRPBIll");
                dtRefund.Columns["HideReceiptRate"].DefaultValue = Util.GetString(dtObs.Rows[0]["HideReceiptRate"]);
                dtRefund.Columns["IsMRPBIll"].DefaultValue = Util.GetString(dtObs.Rows[0]["IsMRPBIll"]);
                dtRefund.AcceptChanges();
            }


            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, " UPDATE f_ledgertransaction SET Bill_Count=Bill_Count+1 WHERE LedgerTransactionID=@LedgerTransactionID ",
               new MySqlParameter("@LedgerTransactionID", labid.Trim()));
            sb = new StringBuilder();
            sb.Append(" INSERT INTO Receipt_Print_Log(LedgerTransactionID,PrintedByID,PrinttedByName,IPAddress) ");
            sb.Append(" values(@LedgerTransactionID,@PrintedByID,Left(@PrinttedByName,30),@IPAddress);");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@LedgerTransactionID", labid.Trim()),
               new MySqlParameter("@PrintedByID", id), new MySqlParameter("@PrinttedByName", name),
               new MySqlParameter("@IPAddress", Util.GetString(StockReports.getip())));

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
}
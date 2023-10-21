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

public partial class Design_Lab_EstimateReceipt : System.Web.UI.Page
{

    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs;


    //Page Property

    const int MarginLeft = 20;
    const int PageWidth = 550;
    const int BrowserWidth = 800;



    //Header Property
    const float HeaderHeight = 185;//207
    const int XHeader = 20;//20
    const int YHeader = 95;//80
    const int HeaderBrowserWidth = 800;


    // BackGround Property
    bool HeaderImage = false;
    bool FooterImage = false;
    bool BackGroundImage = true;
    string HeaderImg = "";

    //Footer Property 80
    const float FooterHeight = 500;

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
            
            if (Util.GetInt(dtObs.Rows[0]["HideReceiptRate"]) == 1 || Util.GetInt(dtObs.Rows[0]["IsMRPBIll"]) == 1)
            {
                sb.Append("<td style='font-weight:bold;width:80px;text-align:right;'></td>");
            }
            else
            {
                sb.Append("<td style='font-weight:bold;width:80px;text-align:right;'>MRP</td>");
            }
            if (Util.GetInt(dtObs.Rows[0]["HideReceiptRate"]) == 1 || Util.GetInt(dtObs.Rows[0]["IsMRPBIll"]) == 1)
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
                if (Util.GetInt(dtObs.Rows[0]["HideReceiptRate"]) == 1 || Util.GetInt(dtObs.Rows[0]["IsMRPBIll"]) == 1)
                {
                    sb.Append("<td style='text-align:right;'></td>");
                }
                else
                {
                    sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dw["rate"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                }
                if (Util.GetInt(dtObs.Rows[0]["HideReceiptRate"]) == 1 || Util.GetInt(dtObs.Rows[0]["IsMRPBIll"]) == 1)
                {
                    sb.Append("<td style='text-align:right;'></td>");
                }
                else
                {
                    sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dw["DiscAmt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                }
                if (Util.GetInt(dtObs.Rows[0]["HideReceiptRate"]) == 1)
                {
                    sb.Append("<td style='text-align:right;'></td>");
                }
                else
                {
                    sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dw["Amount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                }
                sb.Append("</tr>");
                serialno++;
                drcurrent = dtObs.Rows[dtObs.Rows.IndexOf(dw)];
            }
            sb.Append("<tr><td>&nbsp;</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("  <td colspan='3' rowspan='5'>");

            
            sb.Append("</td>");
            if (Util.GetInt(drcurrent["HideReceiptRate"]) == 1)
            {
                sb.Append("<td colspan='2' style='text-align:right;'><b></b></td>");
                sb.Append("<td style='text-align:right;'></td>");
            }
            else
            {
                sb.Append("<td colspan='2' style='text-align:right;'><b>Bill Amount :</b></td>");
                sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dtObs.AsEnumerable().Sum(x => x.Field<decimal>("rate"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
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
                sb.Append("<td colspan='2' style='text-align:right;'><b>Total Discount :</b></td>");
                sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dtObs.AsEnumerable().Sum(x => x.Field<decimal>("DiscAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
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
                sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dtObs.AsEnumerable().Sum(x => x.Field<decimal>("Amount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
            }
            sb.Append("</tr>");
            
            
            sb.Append("<tr style='border-top:1px solid black;'>");
            
              
            
            sb.Append("<td colspan='6'><b>Authorized Signature :</b></td>");

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
        PdfImage transparentResizedPdfImage = new PdfImage(20, 5, Server.MapPath(SignImg)) { PreserveAspectRatio = true };
        //transparentResizedPdfImage.AlphaBlending = true;
        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }

    private string MakeHeader()
    {
        string headertext = "Estimate BILL ";
        
        

        string isduplicate = "";

        
        StringBuilder Header = new StringBuilder();
        Header.Append("<div style='width:800px;'>");
        Header.Append("<table style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:11px;'>");
        Header.Append("<tr style='border-top:1px solid black;'>");
        Header.AppendFormat("<td colspan='4' style='text-align:center;width:800px;font-weight:bold;'>{0} <span style='float:right'>{1}</span></td>", headertext, isduplicate);
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td style='width:100px;font-weight:bold;'>Name</td>");
        Header.AppendFormat("<td style='width:380px'>{0}</td>", Util.GetString(drcurrent["pname"]));
        Header.Append("<td style='width:90px;font-weight:bold;'>Estimate No.</td>");
        Header.AppendFormat("<td style='width:230px;'>{0}</td>", Util.GetString(drcurrent["EstimateID"]));
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
        Header.Append("<td style='font-weight:bold;'>Center</td>");
        Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["centre"]));
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td style='font-weight:bold;'>Address</td>");
        Header.AppendFormat("<td style='white-space: nowrap; overflow: hidden;width:380px;'>{0}</td>", Util.GetString(drcurrent["address"]));
        Header.Append("<td style='font-weight:bold;'>Center Ph. No.</td>");
        Header.AppendFormat("<td>{0}</td>",Util.GetString(drcurrent["CenterContact"]));
        Header.Append("</tr>");
       
        
        Header.Append("<tr style='border-bottom:1px solid black;'>");
        Header.Append("<td></td>");
        Header.Append("<td></td>");
        Header.Append("<td style='font-weight:bold;' valign='top'>Center Address</td>");
        Header.AppendFormat("<td><div style='height:22px;overflow:hidden;'>{0}</div></td>", Util.GetString(drcurrent["CenterAddress1"]));
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

       int ID=0;
        try
        {
            ID = Util.GetInt(Request.QueryString["ID"]);
        }
        catch (Exception ex)
        {
            ID = Util.GetInt(Request.QueryString["IDNew"]);
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT es.EstimateID,sm.State,sm.GSTIN,IFNULL(sm.GSTINAddress,'')GSTINAddress,1 ShowGST,fpm.HideReceiptRate,");
            sb.Append(" cm.Mobile CenterContact,LEFT(REPLACE(cm.`Address`,',',', '),150) CenterAddress1,cm.Locality CenterAddress2,CONCAT(es.title,es.pname) pname, ");
            sb.Append(" cm.`Centre`,cm.HeaderImage,cm.FooterImage, ");
            sb.Append("  es.`Age`,es.`Gender`,es.`Mobile`, fpm.Company_Name `PanelName`, DATE_FORMAT(es.`CreatedDate`,'%d-%b-%Y %h:%i%p') RegDate, ");
            sb.Append("  IFNULL(es.Address,'') Address, itm.TypeName ItemName,itm.TestCode ,es.Rate AS Rate,es.Amount, ");
            sb.Append(" es.`DiscAmt`, es.CreatedBy UserName , sc.`Name`DepartmentName ,0 IsMRPBIll ,'0' `AAALogo`,'' AAALogoContent ");
            sb.Append(" FROM estimate_billDetail es  ");
            sb.Append("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=es.`Panel_ID`  ");
            sb.Append(" INNER JOIN f_itemmaster itm ON itm.ItemID=es.ItemID  ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=fpm.`CentreID`  ");
            sb.Append(" INNER JOIN state_master sm ON sm.ID=cm.StateID  ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=es.`SubCategoryID`");
            sb.Append(" WHERE es.EstimateID=@EstimateID ");
            sb.Append(" ORDER BY sc.`Name`,es.ispackage,es.itemname  ");
            dtObs = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@EstimateID", ID)).Tables[0];


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
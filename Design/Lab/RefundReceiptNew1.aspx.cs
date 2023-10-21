﻿
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

public partial class Design_Lab_RefundReceiptNew1 : System.Web.UI.Page
{

    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs;
    DataTable dtSettlement;
    DataTable dtRefund;
    DataTable dtDetail;
    //Page Property

    const int MarginLeft = 20;
    const int PageWidth = 550;
    const int BrowserWidth = 800;



    //Header Property
    const float HeaderHeight = 200;//207//178
    const int XHeader = 20;//20
    const int YHeader = 95;//80
    const int HeaderBrowserWidth = 800;


    // BackGround Property
    bool HeaderImage = false;
    bool FooterImage = false;
    bool BackGroundImage = true;
    string HeaderImg = "";

    //Footer Property 80
    float FooterHeight =200;// 50;

    DataRow drcurrent;

    string id = "1";
    string name = "Auto";

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {

            name = UserInfo.LoginName;

            id = Util.GetString(UserInfo.ID);
        }
        catch
        {

        }
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
        try
        {
            StringBuilder sb = new StringBuilder();
            BindData();
           if (dtObs.Rows.Count > 7)
           {
               FooterHeight = 50;
           }
            if (dtObs.Rows.Count == 0)
            {
                Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong . Please Refresh Page Or Contact To Admin..!<span><br/><input type='button' value='Refresh' style='cursor:pointer;font-weight:bold;' onclick='window.location.reload();'/></center>");
                return;
            }

            if (dtObs.Rows[0]["AAALogo"].ToString() == "0")
            {
                BackGroundImage = false;
            }
           
            foreach (DataRow dw in dtObs.Rows)
            {
               
               drcurrent = dtObs.Rows[dtObs.Rows.IndexOf(dw)];
            }
           
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
        PdfHtml headerHtml = new PdfHtml(XHeader +10, YHeader -130, PageWidth, MakeHeader(), null) { FitDestWidth = true, FontEmbedding = false, BrowserWidth = HeaderBrowserWidth };
        page.Header.Layout(headerHtml);
      //  page.Header.Layout(getPDFImageforbarcode(340, 75, drcurrent["LedgerTransactionNo"].ToString()));
        if (drcurrent["HeaderImage"].ToString().Length > 0)
            HeaderImage = true;
        //if (HeaderImage)
        //{
        //    page.Header.Layout(getPDFImageHeader(drcurrent["HeaderImage"].ToString()));
        //}
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
        PdfImage transparentResizedPdfImage = new PdfImage(0, 0, Server.MapPath(SignImg)) { PreserveAspectRatio = true };
        //transparentResizedPdfImage.AlphaBlending = true;
        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }

    private string MakeHeader()
    {
        string headertext = "";
        string headertext1 = "";
        string headertext2 = "";
        if (Util.GetInt(drcurrent["IsRefund"]) == 1)
        {
            headertext = "Refund";
        }
        else 
        {
            
            headertext = "ITDOSE INFOSYSTEM PVT. LTD.";
            headertext1 = " G-19, G Block, Sector 6, Noida, Uttar Pradesh 201301 Ph.No: 099999 16974";
            headertext2 = "Refund Receipt";
        }

        string isduplicate = "";

        if (Util.GetInt(drcurrent["BillPrintCount"]) > 0)
        {
            if (Util.GetInt(drcurrent["IsRefund"]) == 1)
            {
                isduplicate = "Refund";
            }
            else
            {
                isduplicate = "";//"Duplicate"
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
        Header.Append("<div style='width:800px; '>");
        Header.Append("<table style='width:800px;  border-collapse:collapse;font-family:Times New Roman;font-size:16px;background-color: #C8C8C8;'><br><br><br>");
        Header.Append("<tr>");
        Header.AppendFormat("<td colspan='4' style='text-align:center;width:800px;font-weight:bold;'>{0} <span style='float:right' >{1}</span></td>", headertext, isduplicate);
        Header.Append("</tr> </table></div>");
        Header.Append("<div style='width:800px;'>");
        Header.Append("<table style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:15px;'>");
        Header.Append("<tr>");
        Header.AppendFormat("<td colspan='4' style='text-align:center;width:800px;'>{0} <span style='float:right'>{1}</span></td>", headertext1, isduplicate);
        Header.Append("</tr> </table></div>");
        Header.Append("<div style='width:600px; margin:auto; text-align:center;'>");
        Header.Append("<table style='width:200px; margin:auto; text-align:center; border-collapse:collapse;font-family:Times New Roman;font-size:15px;'>");
        Header.Append("<tr style=' text-align:center; border-bottom:1px solid black;'>");
       
        Header.AppendFormat("<td  style='width:800px; text-align:center;font-weight:bold;background-color: #C8C8C8;'>{0} <span style='float:right'>{1}</span></td>", headertext2, isduplicate);
    
        Header.Append("</tr> </table></div>");



        Header.Append("<div >");
        Header.Append("<table>");
        Header.Append("<tr style='border-top:1px solid black;'>");
        Header.Append("<td style='width:100px;'><i>Refund Mode: </i> " + Util.GetString(drcurrent["paymentmode"]) + "   " + "<b>  " + Util.GetFloat(drcurrent["amount"]));
        //Header.Append("<td>" + Util.GetFloat(drcurrent["Adjustment"]));
        //Header.Append("</td>");
        Header.Append("</td>");
        Header.Append("<td><i>Refund-NO:</i> " + Util.GetString(drcurrent["billno"]));
        Header.Append("</td>");
        Header.Append("</tr>");
        Header.Append("<tr><td><i>Received with thanks from</i> : <b>" + Util.GetString(drcurrent["UserName"]));
        Header.Append("</td>");
       // Header.Append("<td><i>against ID</i>: " + Util.GetString(drcurrent["patient_id"]));
        Header.Append("</td>");
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td><i>the sum of Rupees </i>: <b>" + Util.GetString(drcurrent["AmountInWord"]));
        Header.Append("</td>");
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td><i>on account of full & final payment towards Investigation charges.<i></td>");
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td style='font-weight:bold;'><i>Rs.</i> " + (Util.GetFloat(drcurrent["netamount"]) - Util.GetFloat(drcurrent["amount"])));
        Header.Append("</td>");
        Header.Append("<td><i>UHID </i>" + Util.GetString(drcurrent["patient_id"]));
        //Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["patient_id"]));
        Header.Append("</td>");
        Header.Append("</tr>");
        Header.Append("<tr>");
       // Header.Append("<td><br><br>SOURAV SAHA</td>");
        Header.Append("<td> <br><br>  <b>" + Util.GetString(drcurrent["UserName"]));
        Header.Append("</td>");
        Header.Append("<td><br>Authorised Signatory</td>");
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
           // PdfText pageNumberingText = new PdfText(PageWidth-30, FooterHeight, String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont) { ForeColor = Color.Black };
            PdfText printdatetime = new PdfText(PageWidth - 180, FooterHeight, "Print Date Time :  " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont) { ForeColor = Color.Black };
           // PdfText printcreatedby = new PdfText(27, FooterHeight, "Created By :  " + drcurrent["UserName"], pageNumberingFont) { ForeColor = Color.Black };
           
            if (p.Footer == null)
            {
                p.CreateFooterCanvas(FooterHeight);

           }
            document.Pages.AddPage(p);
            pageno++;
        }
        tempDocument = new PdfDocument();
    }
    private void BindData()
    {

        int MRPBill = 0;
        if (Request.QueryString["MRPBill"] != null)
            MRPBill = Util.GetInt(Common.Decrypt(Request.QueryString["MRPBill"]));

        string PostValue = Request.Form["LabID"];
        string MRPBill1 = Request.Form["MRPBill"];
        string labid = "";
        if (Request.Form["LabID"] == null)
        {
			 if (Request.QueryString["IsAPI"] != "1")
        {
            labid = Util.GetString(Common.Decrypt(Util.GetString(Request.QueryString["LabID"]).Replace("%27", "")));
		}
        }
        else
        {
			 if (Request.QueryString["IsAPI"] != "1")
        {
            labid = Util.GetString(Common.Decrypt(Util.GetString(Request.Form["LabID"]).Replace("%27", "")));
		}
        }
        if (Util.GetString(Session["CentreType"]) == "B2B")
            MRPBill = 1;
        //  string labid = Util.GetString(Common.Decrypt(Request.QueryString["LabID"]));
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int isRefund = 0;
           // int isRefund = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT COUNT(1) FROM patient_labinvestigation_opd WHERE LedgerTransactionID=@LedgerTransactionID AND IsRefund=2 LIMIT 1 ",
           //    new MySqlParameter("@LedgerTransactionID", labid)));

            // For Settlement

            dtSettlement = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT TransactionID,ReceiptNo,PaymentMode,S_Notation,S_Currency,Amount,DATE_FORMAT(CreatedDate,'%d-%m-%Y') CreatedDate,CreatedBy UserName,CurrencyRoundDigit,S_Amount FROM f_receipt WHERE `LedgerTransactionID`=@LedgerTransactionID and iscancel=0",
               new MySqlParameter("@LedgerTransactionID", labid)).Tables[0];

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT sm.State,sm.GSTIN,IFNULL(sm.GSTINAddress,'')GSTINAddress,1 ShowGST,fpm.HideReceiptRate,LT.Password_web,lt.Username_web,lt.BillPrintCount,lt.`OtherLabRefNo`,cm.Mobile CenterContact,left(replace(cm.`Address`,',',', '),150) CenterAddress1,cm.Locality CenterAddress2,CONCAT(pm.title,UCASE(pm.PName)) pname,pm.`Patient_ID`,lt.`LedgerTransactionNo`,plo.`BillNo`,cm.`Centre`, plo.`Barcode_Group`,DATE_FORMAT(plo.`DeliveryDate`,'%d-%b-%Y %h:%i%p') DeliveryDate,cm.HeaderImage,cm.FooterImage, ");//cm.HeaderImage,cm.FooterImage,  ");
            if (isRefund > 0)
                sb.Append(" '1' IsRefund,");
            else
                sb.Append(" '0' IsRefund,");
            if (dtSettlement.Rows.Count > 0)
                sb.Append(" '1' IsSettlementEntry,");
            else
                sb.Append(" '0' IsSettlementEntry,");
            sb.Append(" pm.`Age`,pm.`Gender`,pm.`Mobile`, lt.`PanelName`,rc.ReceiptNo,IF(lt.`DoctorName`='SELF',lt.`DoctorName`,CONCAT('Dr.', lt.`DoctorName`))Doctorname, ");
            sb.Append("  DATE_FORMAT(lt.`Date`,'%d-%b-%Y %h:%i%p') RegDate, ");
            sb.Append(" left(TRIM(BOTH ',' FROM CONCAT(IFNULL(pm.House_No,''),',',IFNULL(pm.`Locality`,''),',',IFNULL(pm.`City`,''))),60) Address,plo.IsPackage, ");
            sb.Append(" itm.TypeName ItemName, ");
            sb.AppendFormat(" itm.TestCode ,SUM(plo.Rate*plo.Quantity) as rate,(plo.rate*plo.Quantity -SUM(plo.`Amount`)) as `DiscountAmt`,IF('{0}'=0,SUM(plo.`Amount`),SUM(plo.MRP))Amount, DATE_FORMAT(plo.deliverydate,'%d-%b-%Y %h:%i%p')deliveryDate,  lt.`GrossAmount`, ", MRPBill);
            sb.Append(" lt.`DiscountOnTotal`,lt.`NetAmount`,lt.`Adjustment`,");
            sb.Append(" lt.CreatedBy UserName , ");
            sb.AppendFormat(" plo.`SubCategoryName` DepartmentName ,'{0}' IsMRPBIll,IF(lt.`VisitType`='Home Collection','Yes','No')VisitType ", MRPBill);
            sb.Append(" ,'0' `AAALogo`,'' AAALogoContent,plo.barcodeno,IF(plo.DepartmentTokenNo=0,'',DepartmentTokenNo)DepartmentTokenNo,plo.IsActive  ");
            sb.Append(" ,ifnull(prm.PROName,'') PROName,ifnull(frt1.ItemCode,'')ItemCode,rc.paymentmode");
            sb.Append(" FROM patient_labinvestigation_opd plo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` AND IF(isPackage=1,`SubCategoryID`=15,`SubCategoryID`!=15) ");
            sb.Append(" AND lt.`LedgerTransactionID`=@LedgerTransactionID ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.`Panel_ID` ");
            sb.Append(" INNER JOIN f_itemmaster itm on itm.ItemID=plo.ItemID ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
            sb.Append(" INNER JOIN state_master sm ON sm.ID=cm.StateID ");
            sb.Append(" Left JOIN pro_master prm ON prm.PROID=lt.PROID ");
            sb.Append(" Left JOIN f_receipt rc ON lt.LedgerTransactionID=rc.LedgerTransactionID ");
            sb.Append(" Left JOIN f_ratelist frt ON frt.ItemID=itm.ItemID and frt.Panel_ID=lt.`Panel_ID`   ");
            sb.Append(" Left JOIN f_ratelist frt1 ON frt1.ItemID=itm.ItemID  AND frt1.Panel_ID = fpm.ReferenceCodeOPD  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`  ");
         //   sb.Append(" WHERE plo.IsActive=1   ");
            sb.Append("  GROUP BY plo.`ItemId` ORDER BY plo.`SubCategoryName`,plo.ispackage,plo.itemname ");
          //  System.IO.File.WriteAllText(@"D:\itdoes\pksaha\ErrorLog\03jun23referr.txt", sb.ToString());
            dtObs = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@LedgerTransactionID", labid)).Tables[0];

             //string aa = dtDetail.Columns["IsActive"].DataType.ToString();

           // dtObs = dtDetail.AsEnumerable().Where(s => s.Field<SByte>("IsActive") == 1).CopyToDataTable();

            dtObs.Columns.Add("AmountInWord", typeof(string));


            string amtWord = ConvertCurrencyInWord.AmountInWord(Util.GetDecimal(dtObs.Rows[0]["Adjustment"]), "Rupee");

            if (amtWord.Trim() != string.Empty)
            {
                dtObs.Rows[dtObs.Rows.Count - 1]["AmountInWord"] = amtWord.Trim();
            }
            else
            {
                dtObs.Rows[dtObs.Rows.Count - 1]["AmountInWord"] = "";
            }

            dtObs.AcceptChanges();


            string refundLedgerTransactionID = string.Empty;
           
                sb = new StringBuilder();
                sb.Append(" SELECT ");
                sb.Append(" plo.IsPackage, itm.TypeName ItemName ,itm.TestCode ,plo.rate, plo.`DiscountAmt`,plo.`Amount`, ");
                sb.Append(" DATE_FORMAT(plo.Date,'%d-%b-%Y %h:%i%p')Date,IF(SUBSTRING_INDEX(plo.BillType,'-',1)='Credit','CR','DR')BillType,plo.IsActive,plo.BillNo ");
                sb.Append("    FROM patient_labinvestigation_opd plo  ");
                sb.Append(" INNER JOIN f_itemmaster itm on itm.ItemID=plo.ItemID ");
                sb.Append(" AND plo.`LedgerTransactionID`=@LedgerTransactionID AND IF(plo.isPackage=1,plo.SubCategoryID=15,plo.SubCategoryID!=15) ");
                sb.Append("  ORDER BY plo.Date,plo.`SubCategoryName`,plo.ispackage,plo.itemname ");
				//System.IO.File.WriteAllText(@"C:\rcpt1.txt", sb.ToString());
                dtRefund = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@LedgerTransactionID", labid)).Tables[0];
               
                if (dtRefund.Rows.Count > 0 && dtObs.Rows.Count > 0)
                {
                    dtRefund.Columns.Add("HideReceiptRate");
                    dtRefund.Columns.Add("IsMRPBIll");
                    dtRefund.Columns["HideReceiptRate"].DefaultValue = Util.GetString(dtObs.Rows[0]["HideReceiptRate"]);
                    dtRefund.Columns["IsMRPBIll"].DefaultValue = Util.GetString(dtObs.Rows[0]["IsMRPBIll"]);
                    dtRefund.AcceptChanges();
                }

           // }

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, " UPDATE f_ledgertransaction SET BillPrintCount=BillPrintCount+1 WHERE LedgerTransactionID=@LedgerTransactionID ",
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
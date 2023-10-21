
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

public partial class Design_Lab_PatientReceiptNewFull : System.Web.UI.Page
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
    const float HeaderHeight = 178;//207
    const int XHeader = 20;//20
    const int YHeader = 95;//80
    const int HeaderBrowserWidth = 800;


    // BackGround Property
    bool HeaderImage = false;
    bool FooterImage = false;
    bool BackGroundImage = true;
    string HeaderImg = "";

    //Footer Property 80
    float FooterHeight =400;// 50;

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
            sb.Append("<div style='width:800px;'>");
            sb.Append("<table style='width:800px;border-collapse:collapse;font-family:Times New Roman;font-size:11px;'>");
            sb.Append("<tr style='border-bottom:1px solid black;'>");
            sb.Append("<td style='width:50px;font-weight:bold;' >#</td>");
            sb.Append("<td style='font-weight:bold;width:100px;'>Test Code</td>");
            sb.Append("<td style='font-weight:bold;width:300px' >Test Name</td>");
            sb.Append("<td style='font-weight:bold;width:70px'>Barcode No.</td>");
            sb.Append("<td style='font-weight:bold;width:50px'>Token&nbsp;No.</td>");
            if (Util.GetInt(dtObs.Rows[0]["HideReceiptRate"]) == 1)
            {
                if (Util.GetInt(dtObs.Rows[0]["IsMRPBIll"]) == 1)
                    sb.Append("<td style='font-weight:bold;width:80px;text-align:right;'>Rate</td>");
                else
                    sb.Append("<td style='font-weight:bold;width:80px;text-align:right;'></td>");
            }
            else
            {
                sb.Append("<td style='font-weight:bold;width:80px;text-align:right;'>Rate</td>");
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
			decimal sum =0;
			decimal discountsum =0;
            foreach (DataRow dw in dtObs.Rows)
            {
				sum = sum + Math.Round(Util.GetDecimal(dw["rate"]), Util.GetInt(Resources.Resource.BaseCurrencyRound));
				discountsum = discountsum + Math.Round(Util.GetDecimal(dw["discountamt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound));
                sb.Append("<tr>");
                sb.AppendFormat("<td>{0}</td>", serialno);
                sb.AppendFormat("<td>{0}</td>", Util.GetString(dw["testcode"]));
                string itmcod="";
                if (Util.GetString(dw["itemcode"]) !="")
                    itmcod="(" + Util.GetString(dw["itemcode"]) + ")";
                else 
                    itmcod="";
                sb.AppendFormat("<td>{0}</td>", Util.GetString(dw["itemname"]) + itmcod);

                sb.AppendFormat("<td>{0}</td>", Util.GetString(dw["barcodeno"]));
                sb.AppendFormat("<td style='text-align:center;'>{0}</td>", Util.GetString(dw["DepartmentTokenNo"]));
                if (Util.GetInt(dtObs.Rows[0]["HideReceiptRate"]) == 1)
                {
                    if (Util.GetInt(dtObs.Rows[0]["IsMRPBIll"]) == 1)
                        sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dw["rate"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                    else
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
                    sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dw["discountamt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                }
                if (Util.GetInt(dtObs.Rows[0]["HideReceiptRate"]) == 1)
                {
                    sb.Append("<td style='text-align:right;'></td>");
                }
                else
                {
                    sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dw["rate"]), Util.GetInt(Resources.Resource.BaseCurrencyRound))-Math.Round(Util.GetDecimal(dw["discountamt"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                }
                sb.Append("</tr>");
                serialno++;
                drcurrent = dtObs.Rows[dtObs.Rows.IndexOf(dw)];
            }
            sb.Append("<tr><td>&nbsp;</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("  <td colspan='5' rowspan='5'>");
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
                    sb.Append("<td style='font-weight:bold;width:70px;text-align:right;'>Amount</td>");
                    sb.Append("<td style='font-weight:bold;width:70px;text-align:right;'>TransactionID</td>");
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
                        sb.AppendFormat("<td>{0}</td>", Util.GetString(dwc["CreatedDate"]));
                        sb.AppendFormat("<td>{0}</td>", Util.GetString(dwc["ReceiptNo"]));
                        sb.AppendFormat("<td>{0}</td>", Util.GetString(dwc["PaymentMode"]));
                        sb.AppendFormat("<td>{0}</td>", Util.GetString(dwc["S_Notation"]));
                        sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dwc["S_Amount"]), Util.GetInt(dwc["CurrencyRoundDigit"])), MidpointRounding.AwayFromZero);
                        sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Util.GetString(dwc["TransactionID"]));
                        sb.AppendFormat("<td >{0}</td>", Util.GetString(string.Concat("&nbsp;&nbsp;", dwc["UserName"])));
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
                // sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(drcurrent["grossamount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
				 sb.AppendFormat("<td style='text-align:right;'>{0}</td>",sum, MidpointRounding.AwayFromZero);
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
                 // sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(drcurrent["discountontotal"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
				 sb.AppendFormat("<td style='text-align:right;'>{0}</td>", discountsum, MidpointRounding.AwayFromZero);
            }
            sb.Append("</tr>");
            sb.Append("<tr>");
			float NetBillAmt =Util.GetFloat(sum) - Util.GetFloat(discountsum);
            if (Util.GetInt(drcurrent["HideReceiptRate"]) == 1 || Util.GetInt(drcurrent["IsMRPBIll"]) == 1)
            {
                sb.Append("<td colspan='2' style='text-align:right;'></td>");
                sb.Append("<td style='text-align:right;'></td>");
            }
            else
            {
                 sb.Append("<td colspan='2' style='text-align:right;'><b>Net Bill Amount :</b></td>");
                 // sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(drcurrent["netamount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
				                  sb.AppendFormat("<td style='text-align:right;'>{0}</td>", NetBillAmt, MidpointRounding.AwayFromZero);

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
                // sb.Append("<td colspan='2' style='text-align:right;'><b>Total Paid Amount :</b></td>");
                // sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(drcurrent["adjustment"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
            }
            sb.Append("</tr>");
            // float dueamount = Util.GetFloat(drcurrent["rate"]) - Util.GetFloat(drcurrent["adjustment"]);
			float dueamount = Util.GetFloat(NetBillAmt) - Util.GetFloat(drcurrent["adjustment"]);
            sb.Append("<tr>");
            if (dueamount == 0 || Util.GetInt(drcurrent["HideReceiptRate"]) == 1 || Util.GetInt(drcurrent["IsMRPBIll"]) == 1)
            {
                sb.Append("<td colspan='2' style='text-align:right;'></td>");
                sb.Append("<td style='text-align:right;'></td>");
            }
            else
            {
                 sb.Append("<td colspan='2' style='text-align:right;'><b>Due Amount :</b></td>");
                 sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dueamount), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
            }
            sb.Append("</tr>");
            sb.Append("<tr style='border-top:1px solid black;'>");
            if (Util.GetInt(drcurrent["HideReceiptRate"]) == 1 || Util.GetInt(drcurrent["IsMRPBIll"]) == 1)
            {
                sb.Append("<td colspan='9'>");
                sb.Append("</td>");
            }
            else
            {
                sb.Append("<td colspan='9'><b>Received with thanks :</b> " + Util.GetString(drcurrent["AmountInWord"]));
                sb.Append("</td>");
            }
            

            sb.Append("</tr>");
            sb.Append("<tr><td colspan='9'>&nbsp;</td></tr>");
            sb.Append("<tr><td colspan='9'>&nbsp;</td></tr>");
            sb.Append("<tr><td colspan='7'>");
            sb.AppendFormat("For Online Report:  ID:     {0} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Password:  {1}</td>", Util.GetString(drcurrent["Username_web"].ToString()), Util.GetString(drcurrent["Password_web"].ToString()));
            sb.Append("<td colspan='2'><b> Signature</b></td></tr>");
            sb.Append("<tr><td colspan='9'  style='font-weight:bold;'>");
            sb.AppendFormat("Online Patient reports available for 7 days.");
            sb.Append("</tr>");
            sb.Append("<tr><td colspan='9' style='font-weight:bold;'>");
            sb.AppendFormat("Timings : Apr-Oct 8am - 8pm, Nov-March 8.30am - 7.30pm | Sunday 8am-1pm");
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

            ////if (Util.GetInt(drcurrent["IsMRPBIll"]) == 0)
            ////{
            ////    if (dtRefund.Rows.Count > 0)
            ////    {

            ////        var billType = dtRefund.AsEnumerable().Select(s => s.Field<string>("BillType")).Distinct().ToList();

            ////        for (int s = 0; s < billType.Count; s++)
            ////        {
            ////            DataTable billDetail = dtRefund.AsEnumerable().Where(a => a.Field<string>("BillType")==billType[s].ToString()).CopyToDataTable();
            ////            sb.Append("<tr><td colspan='7'>");
            ////            sb.Append("<div style='page-break-inside:avoid;width:760px;'>");
            ////            sb.Append("<table style='width:600px;border-collapse:collapse;font-family:Times New Roman;font-size:11px;'>");
            ////            sb.AppendFormat("<tr><td colspan='4' style='text-align:left;font-weight:bold;'>{0}</td></tr>", billType[s].ToString());
            ////            sb.Append("<tr style='border-top:2px solid black;border-bottom:1px solid black;'>");
            ////            sb.Append("<td style='width:50px' style='font-weight:bold;'>#</td>");
            ////            sb.Append("<td style='font-weight:bold;width:100px;'>Service Code</td>");
            ////            sb.Append("<td style='font-weight:bold;width:350px'>Service Name</td>");
            ////            sb.AppendFormat("<td style='font-weight:bold;width:200px'>{0} Date</td>", billType[s].ToString());
            ////            sb.AppendFormat("<td style='font-weight:bold;width:200px'>{0} No.</td>", billType[s].ToString());
            ////           // sb.Append("<td style='font-weight:bold;width:250px;text-align:right;'>Rate</td>");
            ////            sb.Append("</tr>");
            ////            int sn = 1;
            ////            foreach (DataRow dwr in billDetail.Rows)
            ////            {
            ////                sb.Append("<tr>");
            ////                sb.AppendFormat("<td>{0}</td>", sn);
            ////                sb.AppendFormat("<td>{0}</td>", Util.GetString(dwr["testcode"]));
            ////                sb.AppendFormat("<td>{0}</td>", Util.GetString(dwr["ItemName"]));
            ////                sb.AppendFormat("<td>{0}</td>", Util.GetString(dwr["Date"]));
            ////                sb.AppendFormat("<td>{0}</td>", Util.GetString(dwr["BillNo"]));
            ////              //  sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dwr["rate"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
            ////                sb.Append("</tr>");
            ////                sn++;
            ////            }
            ////            sb.Append("</table></div></td></tr>");
            ////        }

                    //sb.Append("<tr><td colspan='7'>");
                    //sb.Append("<div style='page-break-inside:avoid;width:760px;'>");
                    //sb.Append("<table style='width:600px;border-collapse:collapse;font-family:Times New Roman;font-size:11px;'>");
                    //// sb.AppendFormat("<tr><td colspan='4' style='text-align:center;font-weight:bold;'>Refund Details Of Visit No. {0}</td></tr>", drcurrent["LedgerTransactionNo"]);
                    //sb.Append("<tr style='border-top:2px solid black;border-bottom:1px solid black;'>");
                    //sb.Append("<td style='width:50px' style='font-weight:bold;'>#</td>");
                    //sb.Append("<td style='font-weight:bold;width:100px;'>Service Code</td>");
                    //sb.Append("<td style='font-weight:bold;width:350px'>Service Name</td>");
                    //sb.Append("<td style='font-weight:bold;width:250px;text-align:right;'>Rate</td>");
                    //sb.Append("</tr>");
                    //int sn = 1;
                    //foreach (DataRow dwr in dtRefund.Rows)
                    //{
                    //    sb.Append("<tr>");
                    //    sb.AppendFormat("<td>{0}</td>", sn);
                    //    sb.AppendFormat("<td>{0}</td>", Util.GetString(dwr["testcode"]));
                    //    sb.AppendFormat("<td>{0}</td>", Util.GetString(dwr["ItemName"]));
                    //    sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dwr["rate"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                    //    sb.Append("</tr>");
                    //    sn++;
                    //}
                    //sb.Append("<tr><td colspan='4'><br/></td></tr>");
                    //sb.Append("<tr><td colspan='4'>");
                    //sb.Append("<table style='width:600px;border-collapse:collapse;font-family:Times New Roman;font-size:11px;'>");
                    //sb.Append("<tr style='border:1px solid black;'>");
                    //sb.Append("<td style='font-weight:bold;width:100px'>Settlement</td>");
                    //sb.Append("<td style='font-weight:bold;width:100px'>Payment</td>");
                    //sb.Append("<td style='font-weight:bold;width:170px'>Receipt No.</td>");
                    //sb.Append("<td style='font-weight:bold;width:80px'>Mode</td>");
                    //sb.Append("<td style='font-weight:bold;width:50px'>Currency</td>");
                    //sb.Append("<td style='font-weight:bold;width:50px;text-align:right;'>Amount</td>");
                    //sb.Append("<td style='font-weight:bold;width:140px'>&nbsp;&nbsp;Received By</td>");
                    //sb.Append("</tr>");

                    //sb.Append("<tr>");
                    //string msg1 = "Settlement";

                    //if (Util.GetFloat(dtRefund.Rows[0]["Amount"]) < 0)
                    //{
                    //    msg1 = "Refund";
                    //}

                    //sb.AppendFormat("<td >{0}</td>", msg1);
                    //sb.AppendFormat("<td >{0}</td>", Util.GetString(dtRefund.Rows[0]["CreatedDate"]));
                    //sb.AppendFormat("<td >{0}</td>", Util.GetString(dtRefund.Rows[0]["receiptno"]));
                    //sb.AppendFormat("<td >{0}</td>", Util.GetString(dtRefund.Rows[0]["PaymentMode"]));
                    //sb.AppendFormat("<td >{0}</td>", Util.GetString(dtRefund.Rows[0]["S_Notation"]));
                    //sb.AppendFormat("<td style='text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dtRefund.Rows[0]["grossAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                    //sb.AppendFormat("<td >{0}</td>", Util.GetString(string.Concat("&nbsp;&nbsp;", dtRefund.Rows[0]["UserName"])));
                    //sb.Append("</tr>");

            ////        //sb.AppendFormat("<tr><td colspan='5' style='text-align:right;font-weight:bold;'>Total Refund Amount : {0}</td></tr>", Math.Round(Util.GetDecimal(dtRefund.Rows[0]["grossamount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                    
            ////        sb.Append("</table></div></td></tr>");
            ////    }
            ////}
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
      //  if (dtObs.Rows.Count <= 2)
      //  {
      //      PdfText printtextline = new PdfText(27, FooterHeight - 176, "Online Patient reports available for 7 days.", new Font(new FontFamily("Times New Roman"), 8, FontStyle.Bold, GraphicsUnit.Point)) { ForeColor = Color.Black };
      //      PdfText printtiming = new PdfText(27, FooterHeight - 168, "Timings : Apr-Oct 8am - 8pm, Nov-March 8.30am - 7.30pm | Sunday 8am-1pm", new Font(new FontFamily("Times New Roman"), 8, FontStyle.Bold, GraphicsUnit.Point)) { ForeColor = Color.Black };
      //      page1.Layout(printtextline);
      //      page1.Layout(printtiming);
      //  }
        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);
        SetFooter(page1);
    }
    private void SetHeader(PdfPage page)
    {
        page.CreateHeaderCanvas(HeaderHeight);
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader, PageWidth, MakeHeader(), null) { FitDestWidth = true, FontEmbedding = false, BrowserWidth = HeaderBrowserWidth };
        page.Header.Layout(headerHtml);
        page.Header.Layout(getPDFImageforbarcode(340, 75, drcurrent["LedgerTransactionNo"].ToString()));
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
            //headertext = "BILL OF SUPPLY";
            headertext = "BILL/RECEIPT";
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
        Header.AppendFormat("<td style='width:380px;font-weight:bold;'>{0}</td>", Util.GetString(drcurrent["pname"]));
        Header.Append("<td style='width:90px;font-weight:bold;'>Bill</td>");
        Header.AppendFormat("<td style='width:230px;'>{0}</td>", Util.GetString(drcurrent["billno"]));
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td style='font-weight:bold;'>Age/Gender</td>");
        Header.AppendFormat("<td style='font-weight:bold;'>{0}/{1}</td>", Util.GetString(drcurrent["age"]), Util.GetString(drcurrent["gender"]));
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
        Header.AppendFormat("<td style='font-weight:bold;'>{0}</td>", Util.GetString(drcurrent["LedgerTransactionNo"]));
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td style='font-weight:bold;'>UHID</td>");
        Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["patient_id"]));
        //Header.Append("<td style='font-weight:bold;'>Center</td>");
        //Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["centre"]));
		Header.Append("<td style='font-weight:bold;'>Home Collection</td>");
        Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["visittype"]));
        Header.Append("</tr>");
        Header.Append("<tr>");
        Header.Append("<td style='font-weight:bold;'>PanelName</td>");
        Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["PanelName"]));
        Header.Append("<td style='font-weight:bold;'>PRO</td>");
        Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["PROName"]));
        Header.Append("</tr>");
  //      Header.Append("<tr>");
        //Header.Append("<td style='font-weight:bold;'>Home Collection</td>");
//        Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["visittype"]));
        //Header.Append("<td style='font-weight:bold;'>Center Ph. No.</td>");
        //Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["CenterContact"]));
      //  Header.Append("</tr>");
        //Header.Append("<tr>");
        //Header.Append("<td style='font-weight:bold;'>Client Name</td>");
        //Header.AppendFormat("<td>{0}</td>", Util.GetString(drcurrent["PanelName"]));
        //Header.Append("<td style='font-weight:bold;'>&nbsp;</td>");
        //Header.AppendFormat("<td>&nbsp;</td>");
        //Header.Append("</tr>");
        //Header.Append("<tr style='border-bottom:1px solid black;'>");
        //Header.Append("<td></td>");
        //Header.Append("<td></td>");
        //Header.Append("<td style='font-weight:bold;' valign='top'>Center Address</td>");
        //Header.AppendFormat("<td><div style='height:50px;overflow:hidden;'>{0}</div></td>", Util.GetString(drcurrent["CenterAddress1"]));
        //Header.Append("</tr>");
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
            PdfText pageNumberingText = new PdfText(PageWidth-30, FooterHeight, String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont) { ForeColor = Color.Black };
            PdfText printdatetime = new PdfText(PageWidth - 180, FooterHeight, "Print Date Time :  " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont) { ForeColor = Color.Black };
            PdfText printcreatedby = new PdfText(27, FooterHeight, "Created By :  " + drcurrent["UserName"], pageNumberingFont) { ForeColor = Color.Black };
           
            if (p.Footer == null)
            {
                p.CreateFooterCanvas(FooterHeight);

            }
            p.Footer.Layout(pageNumberingText);
            p.Footer.Layout(printdatetime);
            p.Footer.Layout(printcreatedby);
           // if (dtObs.Rows.Count > 2)
           // {
                PdfText printtextline = new PdfText(27, FooterHeight-10, "Online Patient reports available for 7 days.", new Font(new FontFamily("Times New Roman"), 8, FontStyle.Bold, GraphicsUnit.Point)) { ForeColor = Color.Black };
                PdfText printtiming = new PdfText(27, FooterHeight +30, "Timings : Apr-Oct 8am - 8pm, Nov-March 8.30am - 7.30pm | Sunday 8am-1pm", new Font(new FontFamily("Times New Roman"), 8, FontStyle.Bold, GraphicsUnit.Point)) { ForeColor = Color.Black };
             //   p.Footer.Layout(printtextline);
                //p.Footer.Layout(printtiming);
           // }
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
            labid = Util.GetString(Common.Decrypt(Request.QueryString["LabID"]));
        }
        else
        {
            labid = Util.GetString(Common.Decrypt(Request.Form["LabID"]));
        }
        if (Session["CentreType"].ToString() == "B2B")
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
            sb.Append(" SELECT sm.State,sm.GSTIN,IFNULL(sm.GSTINAddress,'')GSTINAddress,1 ShowGST,fpm.HideReceiptRate,LT.Password_web,lt.Username_web,lt.BillPrintCount,cm.Mobile CenterContact,left(replace(cm.`Address`,',',', '),150) CenterAddress1,cm.Locality CenterAddress2,CONCAT(pm.title,UCASE(pm.PName)) pname,pm.`Patient_ID`,lt.`LedgerTransactionNo`,plo.`BillNo`,cm.`Centre`, plo.`Barcode_Group`,DATE_FORMAT(plo.`DeliveryDate`,'%d-%b-%Y %h:%i%p') DeliveryDate,cm.HeaderImage,cm.FooterImage, ");//cm.HeaderImage,cm.FooterImage,  ");
            if (isRefund > 0)
                sb.Append(" '1' IsRefund,");
            else
                sb.Append(" '0' IsRefund,");
            if (dtSettlement.Rows.Count > 0)
                sb.Append(" '1' IsSettlementEntry,");
            else
                sb.Append(" '0' IsSettlementEntry,");
            sb.Append(" pm.`Age`,pm.`Gender`,pm.`Mobile`, lt.`PanelName`,Concat('Dr.',UPPER(lt.`DoctorName`)) Doctorname, ");
            sb.Append("  DATE_FORMAT(lt.`Date`,'%d-%b-%Y %h:%i%p') RegDate, ");
            sb.Append(" left(TRIM(BOTH ',' FROM CONCAT(IFNULL(pm.House_No,''),',',IFNULL(pm.`Locality`,''),',',IFNULL(pm.`City`,''))),60) Address,plo.IsPackage, ");
            sb.Append(" itm.TypeName ItemName, ");
            //sb.AppendFormat(" itm.TestCode ,SUM(plo.Rate*plo.Quantity) as rate,(plo.rate*plo.Quantity -SUM(plo.`Amount`)) as `DiscountAmt`,IF('{0}'=0,SUM(plo.`Amount`),SUM(plo.MRP))Amount, DATE_FORMAT(plo.deliverydate,'%d-%b-%Y %h:%i%p')deliveryDate,  lt.`GrossAmount`, ", MRPBill);
            sb.AppendFormat(" itm.TestCode ,(select Rate from f_ratelist where panel_ID=78 and itemid=plo.ItemID Limit 1) as rate,(plo.rate*plo.Quantity -SUM(plo.`Amount`)) as `DiscountAmt`,IF('{0}'=0,SUM(plo.`Amount`),SUM(plo.MRP))Amount, DATE_FORMAT(plo.deliverydate,'%d-%b-%Y %h:%i%p')deliveryDate,  lt.`GrossAmount`, ", MRPBill);
            sb.Append(" lt.`DiscountOnTotal`,lt.`NetAmount`,lt.`Adjustment`, ");
            sb.Append(" lt.CreatedBy UserName , ");
            sb.AppendFormat(" plo.`SubCategoryName` DepartmentName ,'{0}' IsMRPBIll,IF(lt.`VisitType`='Home Collection','Yes','No')VisitType ", MRPBill);
            sb.Append(" ,'0' `AAALogo`,'' AAALogoContent,plo.barcodeno,IF(plo.DepartmentTokenNo=0,'',DepartmentTokenNo)DepartmentTokenNo,plo.IsActive  ");
            sb.Append(" ,ifnull(prm.PROName,'') PROName,ifnull(frt1.ItemCode,'')ItemCode");
            sb.Append(" FROM patient_labinvestigation_opd plo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` AND IF(isPackage=1,`SubCategoryID`=15,`SubCategoryID`!=15) ");
            sb.Append(" AND lt.`LedgerTransactionID`=@LedgerTransactionID ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.`Panel_ID` ");
            sb.Append(" INNER JOIN f_itemmaster itm on itm.ItemID=plo.ItemID ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
            sb.Append(" INNER JOIN state_master sm ON sm.ID=cm.StateID ");
            sb.Append(" Left JOIN pro_master prm ON prm.PROID=lt.PROID ");
            sb.Append(" Left JOIN f_ratelist frt ON frt.ItemID=itm.ItemID and frt.Panel_ID=lt.`Panel_ID`   ");
            sb.Append(" Left JOIN f_ratelist frt1 ON frt1.ItemID=itm.ItemID  AND frt1.Panel_ID = fpm.ReferenceCodeOPD  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`  ");
            sb.Append(" WHERE plo.IsActive=1   ");
            sb.Append("  GROUP BY plo.`ItemId` ORDER BY plo.`SubCategoryName`,plo.ispackage,plo.itemname ");
            //System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\rcpt.txt", sb.ToString());
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
            //if (Util.GetInt(isRefund) > 0)
            //{
            //    string oldLabNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT LedgerTransactionNo FROM f_ledgertransaction WHERE LedgerTransactionID=@LedgerTransactionID ",
            //                                                               new MySqlParameter("@LedgerTransactionID", labid)));
            //    string newLabNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT new_LedgerTransactionNo FROM opd_refund WHERE old_LedgerTransactionNo=@old_LedgerTransactionNo ",
            //                                                                new MySqlParameter("@old_LedgerTransactionNo", oldLabNo)));
            //    refundLedgerTransactionID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT LedgerTransactionID FROM f_ledgertransaction WHERE LedgerTransactionNo=@newLabNo ",
            //                                                                new MySqlParameter("@newLabNo", newLabNo)));
            //}
            //if (Util.GetInt(isRefund) > 0)
            //{
                sb = new StringBuilder();
                sb.Append(" SELECT ");
                sb.Append(" plo.IsPackage, itm.TypeName ItemName ,itm.TestCode ,plo.rate, plo.`DiscountAmt`,plo.`Amount`, ");
                sb.Append(" DATE_FORMAT(plo.Date,'%d-%b-%Y %h:%i%p')Date,IF(SUBSTRING_INDEX(plo.BillType,'-',1)='Credit','CR','DR')BillType,plo.IsActive,plo.BillNo ");
                sb.Append("    FROM patient_labinvestigation_opd plo  ");
                sb.Append(" INNER JOIN f_itemmaster itm on itm.ItemID=plo.ItemID ");
                sb.Append(" AND plo.`LedgerTransactionID`=@LedgerTransactionID AND IF(plo.isPackage=1,plo.SubCategoryID=15,plo.SubCategoryID!=15) ");
                sb.Append("  ORDER BY plo.Date,plo.`SubCategoryName`,plo.ispackage,plo.itemname ");
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
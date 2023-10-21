using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Store_VendorQuotation : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;

    int MarginLeft = 20;
    int MarginRight = 20;
    int PageWidth = 550;
    int BrowserWidth = 800;

    float HeaderHeight = 80;
    int XHeader = 20;
    int YHeader = 20;
    int HeaderBrowserWidth = 800;

    float FooterHeight = 50;
    int XFooter = 20;
    string Period = "";
    string InvoiceNo = "";
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
                sb.Append(" SELECT Qutationno,(SELECT REPLACE(GROUP_CONCAT('# ',TermsCondition,''), ',', '')  FROM st_Qutationtermsconditions WHERE Qutationno=stv.Qutationno) ");
                sb.Append(" TermsCondition,VendorId Vendor_Id,VendorName vendor,DeliveryCentreName Center,DeliveryLocationName Location,ManufactureName Menufacture,");
                sb.Append("ItemId,ItemName Item,'' MakeModel,HsnCode,VednorStateGstnno GSTno,TrimZero(Rate) Rate,Qty,TrimZero(DiscountPer)DiscountPer,TrimZero(IGSTPer)IGSTPer,TrimZero(SGSTPer)SGSTPer,TrimZero(CGSTPer)CGSTPer,ConversionFactor,PurchasedUnit, ");
                sb.Append("  ConsumptionUnit,TrimZero(Finalprice)Finalprice,Finalprice Finalprice1, ApprovalStatus,Qty,(SELECT CatalogNo FROM st_itemmaster WHERE itemid=stv.`ItemID` LIMIT 1)  CatalogNo  FROM st_vendorqutation stv  where Qutationno='" + Util.GetString(Request.QueryString["QutationNo"]) + "'  ");

                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
                    {
                        da.Fill(dt);
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = "";
                            sb = new StringBuilder();
                          


                            sb.Append(" <center> <u><span style='text-align:centre;font-weight:bold;font-size:24px;'> <span>Supplier Quotation</u><br/></center> ");

                            sb.Append(" <div style='width:1000px;border:1px solid black; ' >");

                            sb.Append("<table style='width:1000px; font-family:Times New Roman;font-size:17px;border-collapse: collapse;'>");
                            sb.Append(" <tr> ");
                            sb.Append(" <td  colspan='2' style='width: 100%;border-bottom:1px solid black;font-weight: bold;font-size: 17px !important;word-wrap: break-word;'>Quotation No: " + Util.GetString(dt.Rows[0]["Qutationno"]) + "</td> ");
                            sb.Append(" </tr> ");
                            sb.Append(" <tr> ");
                            sb.Append(" <td  style='width:50%;border-bottom:1px solid black;font-weight: bold;font-size: 17px !important;word-wrap: break-word;'>Supplier Name: " + Util.GetString(dt.Rows[0]["vendor"]) + "</td> ");
                            sb.Append(" <td  style='width:50%;font-weight: bold;border-bottom:1px solid black;font-size: 17px !important;word-wrap: break-word;'>GSTN NO: " + Util.GetString(dt.Rows[0]["GSTno"]) + "</td> ");
                            sb.Append(" </tr> ");
                            sb.Append("</table><br/>");

                            sb.Append("<table style='width:1000px; font-family:Times New Roman;font-size:17px;border-collapse: collapse;'>");

                            sb.Append(" <tr> ");
                            sb.Append(" <td style='width: 8%;font-weight: bold;border-bottom: 1px solid;border-Top: 1px solid;font-size: 17px !important;word-wrap: break-word;'>S.No</td> ");
                            sb.Append(" <td style='width: 8%;font-weight: bold;border-bottom: 1px solid;border-Top: 1px solid;font-size: 17px !important;word-wrap: break-word;'>Item</td> ");
                            sb.Append(" <td style='width: 8%;font-weight: bold;border-bottom: 1px solid;border-Top: 1px solid;font-size: 17px !important;word-wrap: break-word;'>HsnCode</td> ");
                            sb.Append(" <td style='width: 8%;font-weight: bold;border-bottom: 1px solid;border-Top: 1px solid;font-size: 17px !important;word-wrap: break-word;'>Catalog No</td> ");
                            sb.Append(" <td style='width: 8%;font-weight: bold;border-bottom: 1px solid;border-Top: 1px solid;font-size: 17px !important;word-wrap: break-word;'>Manufacture</td> ");
                            sb.Append(" <td style='width: 8%;font-weight: bold;border-bottom: 1px solid;border-Top: 1px solid;font-size: 17px !important;word-wrap: break-word;'>Rate</td> ");
                            sb.Append(" <td style='width: 8%;font-weight: bold;border-bottom: 1px solid;border-Top: 1px solid;font-size: 17px !important;word-wrap: break-word;'>Qty</td> ");
                            sb.Append(" <td style='width: 8%;font-weight: bold;border-bottom: 1px solid;border-Top: 1px solid;font-size: 17px !important;word-wrap: break-word;'>Disc%</td> ");
                            sb.Append(" <td style='width: 8%;font-weight: bold;border-bottom: 1px solid;border-Top: 1px solid;font-size: 17px !important;word-wrap: break-word;'>IGST%</td> ");
                            sb.Append(" <td style='width: 8%;font-weight: bold;border-bottom: 1px solid;border-Top: 1px solid;font-size: 17px !important;word-wrap: break-word;'>SGST%</td> ");
                            sb.Append(" <td style='width: 8%;font-weight: bold;border-bottom: 1px solid;border-Top: 1px solid;font-size: 17px !important;word-wrap: break-word;'>CGST%</td> ");
                            sb.Append(" <td style='width: 8%;font-weight: bold;border-bottom: 1px solid;border-Top: 1px solid;font-size: 17px !important;word-wrap: break-word;'>Amount</td> ");
                            
                            sb.Append(" </tr> ");

                            var distinctCentre = (from DataRow drw in dt.Rows
                                                  select new { CentreName = drw["Center"] }).Distinct().ToList();
                            for (int i = 0; i < distinctCentre.Count; i++)
                            {
                                sb.Append(" <tr>");
                                sb.AppendFormat(" <td Colspan='12'  style='font-size: 18px;font-weight: bold '>Center: {0} </td>", distinctCentre[i].CentreName.ToString());
                                sb.Append(" </tr>");

                                var distinctItem = dt.AsEnumerable().Where(s => s.Field<string>("Center") == Util.GetString(distinctCentre[i].CentreName)).ToList();
                                for (int k = 0; k < distinctItem.Count; k++)
                                {
                                    int sno = k + 1;
                                    sb.Append(" <tr> ");
                                    sb.Append(" <td style='width: 8%;border-bottom: 1px solid;font-size: 17px !important;word-wrap: break-word;'>" + sno + "</td> ");
                                    sb.Append(" <td style='width: 8%;border-bottom: 1px solid;font-size: 17px !important;word-wrap: break-word;'>" + Util.GetString(distinctItem[k]["Item"]) + "</td> ");
                                    sb.Append(" <td style='width: 8%;border-bottom: 1px solid;font-size: 17px !important;word-wrap: break-word;'>" + Util.GetString(distinctItem[k]["HsnCode"]) + "</td> ");
                                    sb.Append(" <td style='width: 8%;border-bottom: 1px solid;font-size: 17px !important;word-wrap: break-word;'>" + Util.GetString(distinctItem[k]["CatalogNo"]) + "</td> ");
                                    sb.Append(" <td style='width: 8%;border-bottom: 1px solid;font-size: 17px !important;word-wrap: break-word;'>" + Util.GetString(distinctItem[k]["Menufacture"]) + "</td> ");
                                    sb.Append(" <td style='width: 8%;border-bottom: 1px solid;font-size: 17px !important;word-wrap: break-word;'>" + Util.GetDecimal(distinctItem[k]["Rate"]) + "</td> ");
                                    sb.Append(" <td style='width: 8%;border-bottom: 1px solid;font-size: 17px !important;word-wrap: break-word;'>" + Util.GetDecimal(distinctItem[k]["Qty"]) + "</td> ");
                                    sb.Append(" <td style='width: 8%;border-bottom: 1px solid;font-size: 17px !important;word-wrap: break-word;'>" + Util.GetDecimal(distinctItem[k]["DiscountPer"]) + "</td> ");
                                    sb.Append(" <td style='width: 8%;border-bottom: 1px solid;font-size: 17px !important;word-wrap: break-word;'>" + Util.GetDecimal(distinctItem[k]["IGSTPer"]) + "</td> ");
                                    sb.Append(" <td style='width: 8%;border-bottom: 1px solid;font-size: 17px !important;word-wrap: break-word;'>" + Util.GetDecimal(distinctItem[k]["SGSTPer"]) + "</td> ");
                                    sb.Append(" <td style='width: 8%;border-bottom: 1px solid;font-size: 17px !important;word-wrap: break-word;'>" + Util.GetDecimal(distinctItem[k]["CGSTPer"]) + "</td> ");
                                    sb.Append(" <td style='width: 8%;border-bottom: 1px solid;font-size: 17px !important;word-wrap: break-word;'>" + Math.Round(Util.GetDecimal(distinctItem[k]["Finalprice1"])) + "</td> ");
                                    sb.Append(" </tr> ");
                                }

                            }
                            string FinalpriceinWord = StockReports.ConvertAmountinword(Util.GetDouble(dt.AsEnumerable().Sum(x => x.Field<decimal>("Finalprice1"))));
                            string TotalQtyinWord = StockReports.ConvertAmountinword(Util.GetDouble(dt.AsEnumerable().Sum(x => x.Field<decimal>("Qty"))));

                            sb.Append(" <tr> ");
                            sb.Append(" <td Colspan='9' style='width: 92%;font-size: 17px !important;word-wrap: break-word;'>Total Amt In Word: " + FinalpriceinWord + "</td> ");
                            sb.Append(" <td Colspan='2' style='width: 8%;text-align:right;font-size: 17px !important;word-wrap: break-word;'>Total Amt</td> ");
                            sb.AppendFormat(" <td style='width: 8%;font-size: 17px;font-weight: bold '>{0}</td> ", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("Finalprice1"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            sb.Append(" </tr> ");

                            sb.Append(" <tr> ");
                            sb.Append(" <td Colspan='12' style='width: 100%;font-size: 17px !important;word-wrap: break-word;'>Total QTY In Word: " + TotalQtyinWord + "</td> ");
                            sb.Append(" </tr> ");

                            sb.Append(" <tr> ");
                            sb.Append(" <td Colspan='12' style='width: 100%;font-size: 17px !important;word-wrap: break-word;'>Terms & Conditions</td> ");
                            sb.Append(" </tr> ");

                            sb.Append("</table>");
                            sb.Append(" </div> ");
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
        //sb.Append(" <div style='width:1000px;'> ");
        //sb.Append("<table style='width: 1000px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
        //sb.Append("<tr>");
        //sb.Append("<td style='width:100%; text-align: center;'>");

        //sb.Append("<span style='font-weight: bold;font-size:20px;'>Bill</span><br />");

        //sb.Append("</td>");
        //sb.Append("</tr>");
        //sb.Append("<tr>");
        //sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        //sb.AppendFormat(" <span style='font-size: 14px;'>{0}</span>", Period);
        //sb.Append("</td>");
        //sb.Append("</tr>");
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
            // p.Footer.Layout(printdatetime);
            document.Pages.AddPage(p);
            pageno++;
        }
        tempDocument = new PdfDocument();
    }


}

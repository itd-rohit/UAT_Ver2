using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HiQPdf;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Net;
using System.Drawing.Drawing2D;
using System.Diagnostics;
using System.Drawing.Printing;
using MySql.Data.MySqlClient;


public partial class Design_ConcentForm_PrintConcentFrom : System.Web.UI.Page
{

    PdfLayoutInfo html1LayoutInfo;
    PdfDocument document = new PdfDocument();
    PdfDocument tempDocument = new PdfDocument();
    public string TestID = "";
    public string LeftMargin = "";
    public string PrintSNR = "";
    public string isOnlinePrint = "";
    public string isEmail = "";
    int MarginLeft = 20;
    int PageWidth = 550;
    int BrowserWidth = 800;
    public string IsPrev = "0";
    public DataTable _Attachments;
    int HeaderHeight = 214;
    protected void Page_Load(object sender, EventArgs e)
    {
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
        if (!IsPostBack)
        {
            AddContent("");
            mergeDocument();
        }
    }
    private void mergeDocument()
    {
        int pageno = 1;
        foreach (PdfPage p in tempDocument.Pages)
        {
            document.Pages.AddPage(p);
            pageno++;
        }
        tempDocument = new PdfDocument();
    }
    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        PdfPage page1 = eventParams.PdfPage;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ic.filename,icd.`fieldsid`,icd.`FieldsName`,icd.`Left`,icd.`Top`,icd.`fontname`,icd.`isbold`,icd.`fontsize` FROM investigation_concentform ic LEFT JOIN `investigation_concentform_detail` icd ON ic.id=icd.`formid` where concentformname=@concentformname ",
               new MySqlParameter("@concentformname", Request.QueryString["Name"].ToString())).Tables[0];
            if (dt.Rows.Count > 0)
            {


                string _pdf = "";
                if (dt.Rows[0]["filename"].ToString().EndsWith(".pdf"))
                {
                    //"D:/GITNEW/uat_ver1/Design/ConcentForm/PNDT.pdf" local  Path
                    //"C:/ITDOSE/UAT_Ver1/Design/ConcentForm/PNDT.pdf"  Live  Path
                    _pdf = string.Concat("C:/ITDOSE/UAT_Ver1/Design/ConcentForm") + "/" + dt.Rows[0]["filename"].ToString();
                    if (Util.GetString(Request.QueryString["name"]) == "PNDT")
                    {
                        try
                        {
                            PdfDocument document1 = PdfDocument.FromFile(_pdf);

                             PdfText PatientName = new PdfText(130, 140, Request.QueryString["PatientName"].Split('/')[0], new Font("times new roman", 9));
                             PdfText Age = new PdfText(470, 140, Request.QueryString["Age"].Split('/')[0], new Font("times new roman", 9));
                             PdfText Children = new PdfText(190, 160, Request.QueryString["Children"].Split('/')[0], new Font("times new roman", 9));
                             PdfText Son = new PdfText(110, 193, Request.QueryString["Son"].Split('/')[0], new Font("times new roman", 9));
                             PdfText AgeSon = new PdfText(250, 193, Request.QueryString["AgeSon"].Split('/')[0], new Font("times new roman", 9));
                             PdfText Daughter = new PdfText(110, 227, Request.QueryString["Daughter"].Split('/')[0], new Font("times new roman", 9));
                             PdfText AgeDaughter = new PdfText(250, 227, Request.QueryString["AgeDaughter"].Split('/')[0], new Font("times new roman", 9));
                             PdfText House_No = new PdfText(310, 258, Request.QueryString["House_No"].Split('/')[0], new Font("times new roman", 9));
                             PdfText Pregnancydate = new PdfText(260, 423, Request.QueryString["Pregnancydate"].Split('/')[0], new Font("times new roman", 9));


                            document1.Pages[0].Layout(PatientName);
                            document1.Pages[0].Layout(Age);
                            document1.Pages[0].Layout(Children);
                            document1.Pages[0].Layout(Son);
                            document1.Pages[0].Layout(AgeSon);
                            document1.Pages[0].Layout(Daughter);
                            document1.Pages[0].Layout(AgeDaughter);
                            document1.Pages[0].Layout(Pregnancydate);
                            document1.Pages[0].Layout(House_No);
                            
                            document1.AddDocument(document1);
                          
                            
                            byte[] pdfBuffer = document1.WriteToMemory();
                            HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
                            HttpContext.Current.Response.BinaryWrite(pdfBuffer);
                            // call End() method of HTTP response to stop ASP.NET page processing
                            //   HttpContext.Current.Response.End();
                            HttpContext.Current.Response.Flush();
                            HttpContext.Current.Response.SuppressContent = true;
                            HttpContext.Current.ApplicationInstance.CompleteRequest();

                        }
                        catch (Exception ex)
                        {
                            ClassLog cl = new ClassLog();
                            cl.errLog(ex);
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", string.Format("window.open('{0}');", _pdf), true);
                        }
                    }
                     else
                    {
                       try
                        {
							// System.IO.File.WriteAllText (@"E:\Uat\Vardaan_uat\ErrorLog\_pdf.txt", _pdf.ToString());
                            PdfDocument document1 = PdfDocument.FromFile(_pdf);
                            document.AddDocument(document1);
                            byte[] pdfBuffer = document1.WriteToMemory();
                            HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
                            HttpContext.Current.Response.BinaryWrite(pdfBuffer);
                            // call End() method of HTTP response to stop ASP.NET page processing
                         //   HttpContext.Current.Response.End();
                            HttpContext.Current.Response.Flush();
                            HttpContext.Current.Response.SuppressContent = true;
                            HttpContext.Current.ApplicationInstance.CompleteRequest();

                        }
                        catch (Exception ex)
                        {
                            ClassLog cl = new ClassLog();
                            cl.errLog(ex);
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", string.Format("window.open('{0}');", _pdf), true);
                        }
                    }
                }
                else
                {
                    page1.Layout(getPDFImage(0, 0, string.Concat("Design/ConcentForm/", dt.Rows[0]["filename"].ToString())));
                    StringBuilder sb = new StringBuilder();
                    foreach (DataRow dw in dt.Rows)
                    {
                        if (dw["FieldsName"].ToString() != "")
                        {
                            if (dw["isbold"].ToString() == "1")
                            {
                                page1.Layout(new PdfText(Util.GetFloat(dw["left"].ToString()), Util.GetFloat(dw["Top"].ToString()), Request.QueryString[dw["FieldsName"].ToString()].ToString(), new Font(Util.GetString(dw["fontname"].ToString()), Util.GetInt(dw["fontsize"].ToString()), FontStyle.Bold)));
                            }
                            else
                            {
                                page1.Layout(new PdfText(Util.GetFloat(dw["left"].ToString()), Util.GetFloat(dw["Top"].ToString()), Request.QueryString[dw["FieldsName"].ToString()].ToString(), new Font(Util.GetString(dw["fontname"].ToString()), Util.GetInt(dw["fontsize"].ToString()))));
                            }
                        }
                    }
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

    private PdfImage getPDFImage(float X, float Y, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y,600, Server.MapPath("~/" + SignImg));
        transparentResizedPdfImage.PreserveAspectRatio = true;
        return transparentResizedPdfImage;

    }

    private void AddContent(string Content)
    {
        PdfPage page1 = tempDocument.AddPage(PdfPageSize.A4, PdfDocumentMargins.Empty);
        PdfHtml html1 = new PdfHtml();
        if (html1LayoutInfo == null)
        {
            html1LayoutInfo = page1.Layout(html1);
        }
        html1 = new PdfHtml(MarginLeft, html1LayoutInfo.LastPageRectangle.Height, PageWidth, Content, null);
        html1.PageCreatingEvent += new PdfPageCreatingDelegate(htmlToPdfConverter_PageCreatingEvent);
        html1.FontEmbedding = false;
        html1.BrowserWidth = BrowserWidth;
        html1LayoutInfo = page1.Layout(html1);
    }
    private void SetHeader(PdfPage page)
    {
        page.CreateHeaderCanvas(HeaderHeight);

    }



    private void SetFooter(PdfPage page)
    {


    }
}

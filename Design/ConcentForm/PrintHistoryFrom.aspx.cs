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
    StringBuilder Header = new StringBuilder();
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
    int XHeader =20;//20
    int YHeader = 20;//80
    int HeaderBrowserWidth = 800;
    int HeaderHeight = 110;
    protected void Page_Load(object sender, EventArgs e)
    {
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
        StringBuilder data = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ic.FormText FROM investigation_concentform ic LEFT JOIN `investigation_concentform_detail` icd ON ic.id=icd.`formid` where ic.id=@concentformname and IsEditor=1 LIMIT 1",
                  new MySqlParameter("@concentformname", Request.QueryString["Name"].ToString())).Tables[0];
            if (dt.Rows.Count > 0)
            {
                data.Append(dt.Rows[0]["FormText"].ToString());
                //int a=data.IndexOf("{PatientName}");
                //data.
                data.Replace("{PatientName}", Request.QueryString["PatientName"].ToString());
                data.Replace("{ReferDoctor}", Request.QueryString["ReferDoctor"].ToString());
                data.Replace("{TestName}", Request.QueryString["TestName"].ToString());
                data.Replace("{Panel}", Request.QueryString["Panel"].ToString());
                data.Replace("{Gender}", Request.QueryString["Gender"].ToString());
                data.Replace("{Age}", Request.QueryString["Age"].ToString());
                data.Replace("{RegDate}", Request.QueryString["RegDate"].ToString());
                data.Replace("{Name}", Request.QueryString["Name"].ToString());
                Header.Append(Util.GetString(StockReports.ExecuteScalar("SELECT HeaderText FROM investigation_concentform WHERE IsEditor=1 AND FileName='FormHeader'")));

                Header = Header.Replace("{RegDate}", Request.QueryString["RegDate"].ToString());
                Header = Header.Replace("{PName}", Request.QueryString["PatientName"].ToString());
                Header = Header.Replace("{Mobile}", Request.QueryString["Mobile"].ToString());
                Header = Header.Replace("{ReferDoctor}", Request.QueryString["ReferDoctor"].ToString());
                Header = Header.Replace("{Age}", Request.QueryString["Age"].ToString() + "/" + Request.QueryString["Gender"].ToString());
                Header = Header.Replace("{TestName}", Request.QueryString["TestName"].ToString());
                Header = Header.Replace("{DocMobile}", Request.QueryString["DocMobile"].ToString());
                Header = Header.Replace("{Patient_ID}", Request.QueryString["Patient_ID"].ToString());
                Header = Header.Replace("{LabNo}", Request.QueryString["LabNo"].ToString());
                Header = Header.Replace("{DeptName}", Request.QueryString["DeptName"].ToString());
            }
        }
        catch
        {

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
        AddContent(data.ToString());
        mergeDocument();
        try
        {
            byte[] pdfBuffer = document.WriteToMemory();
            HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
            HttpContext.Current.Response.BinaryWrite(pdfBuffer);
            HttpContext.Current.Response.End();
        }
        finally
        {
            document.Close();
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
        string BackGroundImage = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT ReportBackGroundImage FROM f_panel_master WHERE Company_Name=@Company_Name ",
               new MySqlParameter("@Company_Name", Request.QueryString["Panel"].ToString())));
        if(BackGroundImage!="")
        {
      //  string HeaderImg = "App_Images/ReportBackGround/" + BackGroundImage;
      //  page1.Layout(getPDFImage(0, 0, HeaderImg));
        }  
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ic.filename,icd.`fieldsid`,icd.`FieldsName`,icd.`Left`,icd.`Top`,icd.`fontname`,icd.`isbold`,icd.`fontsize`,ic.IsEditor,ic.FormText FROM investigation_concentform ic LEFT JOIN `investigation_concentform_detail` icd ON ic.id=icd.`formid` where concentformname=@concentformname and IsEditor=0",
               new MySqlParameter("@concentformname", Request.QueryString["Name"].ToString())).Tables[0];
            if (dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["IsEditor"].ToString() == "0")
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
            SetHeader(page1);
            SetFooter(page1);
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
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Server.MapPath("~/" + SignImg));
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
        // layout HTML in header
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader, PageWidth, Header.ToString(), null) { FitDestWidth = true, FontEmbedding = false, BrowserWidth = HeaderBrowserWidth };
        
        page.Header.Layout(headerHtml);
    }



    private void SetFooter(PdfPage page)
    {


        int FooterHeight = 40;
        page.CreateFooterCanvas(FooterHeight);

    }
}
using HiQPdf;
using HTMLReportEngine;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using ClosedXML.Excel;


public partial class Design_Dashboard_output : System.Web.UI.Page
{
    StringBuilder sb = new StringBuilder();
    string ReportId = "";
    string ReportName = "";
    string ReportFile = "";
    DataTable dtReport = new DataTable();
    DataTable dtColumns = new DataTable();
    DataSet ds = new DataSet();
    MySqlConnection con = new MySqlConnection();
    MySqlCommand cmd = new MySqlCommand();
    MySqlDataAdapter da = new MySqlDataAdapter();
    protected void Page_Load(object sender, EventArgs e)
    {

        
        


        try
        {
            ReportId = getValue("ctl00$ContentPlaceHolder1$ddlReport");

            if (ReportId == "")
                throw (new Exception("Invalid Report Id."));


            con = Util.GetMySqlCon();
            con.Open();
            cmd.Connection = con;
            cmd.CommandType = CommandType.Text;
            cmd.CommandTimeout = 600;
            //Getting Report Query
            cmd.CommandText = "SELECT id,ReportSql,ReportName,Rpt_File FROM dashboard_report_master where id=@id";
           
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@id", ReportId);
            da = new MySqlDataAdapter();
            da.SelectCommand = cmd;
            da.Fill(dtReport);

            ReportName = dtReport.Rows[0]["ReportName"].ToString();
            ReportFile = dtReport.Rows[0]["Rpt_File"].ToString();

            sb.Append(dtReport.Rows[0]["ReportSql"].ToString());


            cmd.Parameters.Clear();
            //Getting Report Data
            getParamter(ref sb, ref cmd, getValue("ctl00$ContentPlaceHolder1$lblPanel"), "Panel");
            getParamter(ref sb, ref cmd, getValue("ctl00$ContentPlaceHolder1$lblCentre"), "Centre");
            getParamter(ref sb, ref cmd, getValue("ctl00$ContentPlaceHolder1$lblItem"), "Item");
            getParamter(ref sb, ref cmd, getValue("ctl00$ContentPlaceHolder1$lblDept"), "Department");
            getParamter(ref sb, ref cmd, getValue("ctl00$ContentPlaceHolder1$lblUser"), "User");

           // cmd.Parameters.AddWithValue("@dtFrom", getValue("ctl00$ContentPlaceHolder1$dtFrom"));
           // cmd.Parameters.AddWithValue("@dtTo", getValue("ctl00$ContentPlaceHolder1$dtTo"));

            cmd.Parameters.AddWithValue("@dtFrom", getValue("ctl00$ContentPlaceHolder1$dtFrom") + " 00:00:00");
            cmd.Parameters.AddWithValue("@dtTo", getValue("ctl00$ContentPlaceHolder1$dtTo") + " 23:59:59");

            cmd.CommandText = sb.ToString();
            da.SelectCommand = cmd;
            da.Fill(ds);

            if (ds.Tables[0].Rows.Count == 0)
                  throw (new Exception("No record found."));
        



            //Getting fields information
            cmd.CommandText = "SELECT * FROM `dashboard_report_master_columns` WHERE ReportID=@ReportID  ORDER BY GroupBy desc, isVisible desc, PrintOrder ASC";
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@ReportID", dtReport.Rows[0]["id"]);
            da = new MySqlDataAdapter();
            da.SelectCommand = cmd;
            da.Fill(dtColumns);

            da.Dispose();
            cmd.Dispose();
        }
        catch (Exception ex) {
            lblMsg.Text = ex.Message.ToString();
            return;
        }
        finally { 
            con.Close();
            con.Dispose();


        }


        if (getValue("ctl00$ContentPlaceHolder1$ddlOutput") == "Excel")
            getExcel(ds.Tables[0]);
        else if ((getValue("ctl00$ContentPlaceHolder1$ddlOutput") == "Crystal Report") || (ReportFile!=""))
            bindCrystalReport();
        else if (getValue("ctl00$ContentPlaceHolder1$ddlOutput") == "PDF")
            getPDF();
       

    }

    private void getExcel(DataTable dt)
    {
        var wb = new XLWorkbook();
       // Add a DataTable as a worksheet
        wb.Worksheets.Add(dt);
        
        MemoryStream ms = new MemoryStream();
        wb.SaveAs(ms);

        string attachment = "attachment; filename=" + ReportName + ".xlsx";
        Response.ClearContent();
        Response.AddHeader("content-disposition", attachment);
        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        Response.BinaryWrite(ms.ToArray());
        Response.End();
    }


    void bindCrystalReport()
    {

        //ds.WriteXmlSchema("d:\\"+ReportName+".xml");
        //return;
        //CrystalDecisions.Web.CrystalReportViewer cv=null;
        if (getValue("ctl00$ContentPlaceHolder1$ddlOutput") == "Crystal Report")
        {
           // cv = new CrystalDecisions.Web.CrystalReportViewer();
            cv.AutoDataBind = true;
            cv.EnableDatabaseLogonPrompt = false;
            cv.EnableParameterPrompt = false;

            //if (!Page.Form.Controls.Contains(cv))
            //    Page.Form.Controls.Add(cv);
        }
        
        //cv.DocumentView = CrystalDecisions.Shared.DocumentViewType.PrintLayout;
        CrystalDecisions.CrystalReports.Engine.ReportDocument obj1 = new CrystalDecisions.CrystalReports.Engine.ReportDocument();
        try
        {

            obj1.Load(Server.MapPath("~/Design/Dashboard/Reports/") + ReportFile);
            obj1.SetDataSource(ds);
            if (getValue("ctl00$ContentPlaceHolder1$ddlOutput") == "Crystal Report")
            {
                cv.ReportSource = obj1;
                cv.DataBind();
            }
            else
            {

                System.IO.Stream oStream = null;
                byte[] byteArray = null;
                oStream = obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                obj1.Close();
                obj1.Dispose();
                byteArray = new byte[oStream.Length];
                oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
                Response.ClearContent();
                Response.ClearHeaders();
                Response.ContentType = "application/pdf";
                Response.BinaryWrite(byteArray);
                Response.Flush();
                Response.Close();
                oStream.Flush();
                oStream.Close();
                oStream.Dispose();
                GC.Collect();
            }

        }
        catch (Exception ex) { lblMsg.Text = ex.ToString(); }
        finally {

            
        }

        
    }


    void getPDF()
    {

        Report report = new Report();
        //report.ReportTitle = ReportName;
        report.ReportFont = "Arial";

        report.ReportSource = ds;
        report.IncludeTotal = true;


        

        foreach (DataRow dr in dtColumns.Rows)
        {
            if (!ds.Tables[0].Columns.Contains(dr["FieldName"].ToString()))
                continue;

            if (dr["isVisible"].ToString() == "1")
            {
                Field field = new Field();
                field.HeaderName = (dr["HeaderName"].ToString() == "" ? dr["FieldName"].ToString() : dr["HeaderName"].ToString());
                field.FieldName = dr["FieldName"].ToString();
                field.BackColor = Color.FromName(dr["BackColor"].ToString());
                field.HeaderBackColor = Color.FromName(dr["HeaderBackColor"].ToString());
                field.isTotalField = (dr["isTotalField"].ToString() == "1" ? true : false);
                field.Alignment = (dr["Alignment"].ToString().ToLower() == "Right".ToLower() ? ALIGN.RIGHT : ALIGN.LEFT);

                if (field.Alignment.ToString().ToLower() != dr["Alignment"].ToString().ToLower())
                    field.Alignment = (dr["Alignment"].ToString().ToLower() == "Centre".ToLower() ? ALIGN.CENTER : ALIGN.LEFT);


                field.Width = Util.GetInt(dr["Width"]);
                report.ReportFields.Add(field);

                //if (field.isTotalField)
                //    report.TotalFields.Add(field);


            }
        }

        foreach (DataRow dr in dtColumns.Rows)
        {
            if (dr["GroupBy"].ToString() == "1")
            {
                if (!ds.Tables[0].Columns.Contains(dr["FieldName"].ToString()))
                    continue;


                Section grp = new Section();
                grp.GroupBy = dr["FieldName"].ToString();
                grp.TitlePrefix = dr["HeaderName"].ToString();
                grp.IncludeTotal = true;



                if (grp.TitlePrefix != "")
                    grp.TitlePrefix = grp.TitlePrefix + " : ";


                

                report.Sections.Add(grp);
                

            }
        }






        PdfDocument document = new PdfDocument();
        document.SerialNumber = "g8vq0tPn-5c/q4fHi-8fq7rbOj-sqO3o7uy-t6Owsq2y-sa26urq6";
        PdfPage page1 = document.AddPage(PdfPageSize.A4, PdfDocumentMargins.Empty, PdfPageOrientation.Portrait);
        page1.Margins.Bottom = 5;
        page1.Margins.Left = 5;
        page1.Margins.Right = 5;
        page1.Margins.Top = 5;

        PdfHtml html1 = new PdfHtml();
        html1 = new PdfHtml(report.GenerateReport(), null);
        html1.PageCreatingEvent += new PdfPageCreatingDelegate(htmlToPdfConverter_PageCreatingEvent);
        html1.FontEmbedding = false;
        //html1.BrowserWidth = 850;
        page1.Layout(html1);


        foreach (PdfPage p in document.Pages)
        {

           // Header Content

            System.Drawing.Font txtHeaderFont =
            new System.Drawing.Font(new System.Drawing.FontFamily("Arial"), 15, System.Drawing.GraphicsUnit.Point);

            PdfText txtHeader = new PdfText(5, 3, ReportName, txtHeaderFont);
            txtHeader.ForeColor = System.Drawing.Color.Black;
            p.Header.Layout(txtHeader);


            // Footer content
            System.Drawing.Font pageNumberingFont =
             new System.Drawing.Font(new System.Drawing.FontFamily("Arial"), 6, System.Drawing.GraphicsUnit.Point);
            
            PdfText pageNumberingText = new PdfText(page1.Size.Width-100, 3, String.Format("Page {0} of {1}", p.Index+1,document.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;
            p.Footer.Layout(pageNumberingText);

            pageNumberingText = new PdfText(5, 3, String.Format("Print Date : {0}", DateTime.Now.ToString("dd/MMM/yyyy hh:mm tt")), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;
            p.Footer.Layout(pageNumberingText);

            PdfLine pdfLine = new PdfLine(new PointF(0, 0), new PointF(page1.Size.Width,0));
            p.Footer.Layout(pdfLine);

        }


        try
        {
            // write the PDF document to a memory buffer
            byte[] pdfBuffer = document.WriteToMemory();



            // inform the browser about the binary data format
            HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");

            //// let the browser know how to open the PDF document and the file name
            //HttpContext.Current.Response.AddHeader("Content-Disposition", String.Format("attachment; filename=PdfText.pdf; size={0}",
            //            pdfBuffer.Length.ToString()));

            HttpContext.Current.Response.AddHeader("Content-Disposition", String.Format("inline; filename=" + ReportName + ".pdf; size={0}",
                                    pdfBuffer.Length.ToString()));

            // write the PDF buffer to HTTP response
            HttpContext.Current.Response.BinaryWrite(pdfBuffer);

            // call End() method of HTTP response to stop ASP.NET page processing
            HttpContext.Current.Response.End();

        }

        finally
        {

            document.Close();


        }

    }

    private void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        PdfPage p = eventParams.PdfPage;
        p.CreateHeaderCanvas(20);

        p.CreateFooterCanvas(10);
    }

   



    void getParamter(ref StringBuilder sb, ref MySqlCommand cmd, string t, string Key)
    {
        //string t = getValue("ctl00$ContentPlaceHolder1$lblPanel");
        if (t != "")
        {
            string[] tags = t.Split(',');
            t = "";
            for (int i = 0; i < tags.Length; i++)
            {
                t = t + "@"+Key + i + ",";
                cmd.Parameters.AddWithValue("@" + Key + i, tags[i]);
            }
        }

        sb = new StringBuilder(sb.ToString().Replace("@"+ Key,t.TrimEnd(',')));
    }

    string getValue(string ForKey)
    {
        foreach (string key in Request.Form)
        {
            //File.AppendAllText("d:\\form.txt", key + "=" + Request.Form[key] + "\r\n");
            if (key.ToLower() == ForKey.ToLower())
                return Request.Form[key];

        }
        return "";
    }
}
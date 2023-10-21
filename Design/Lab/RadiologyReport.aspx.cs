using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_RadiologyReport : System.Web.UI.Page
{
    string TestID = "";
    string filepath = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TestID = Request.QueryString["TestID"].ToString();
            filepath = Request.QueryString["filepath"].ToString();
            if (TestID != "" && filepath!="")
            {
                downloadreport();
            }                           
        }
    }
    public void downloadreport()
    {        
        try
        {
            string Path = Util.getApp("WordReportPath") + @"Reports\";           
            string filePath = Path + filepath +  "/" + TestID + ".doc";
            if (filePath != string.Empty)
            {
                WebClient req = new WebClient();
                Response.ContentType = "doc/docx";
                Response.AddHeader("Content-Disposition", "attachment;filename=\"" + TestID + ".doc" + "\"");
                byte[] data = req.DownloadData(filePath);
                Response.BinaryWrite(data);
               
            }
        }
        catch (Exception ex)
        {
        }
        finally
        {
            Response.End();
            Response.Clear();
        }
    }
}
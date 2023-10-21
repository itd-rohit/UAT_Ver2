using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_ShowAttachedfile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {



        string FilePath = Request.QueryString["fileurl"].ToString();
        string RootDir = Server.MapPath("~/Design/UploadedDocument");
        string filename = RootDir + FilePath;
        filename = filename.Replace("/", "\\");

        WebClient client = new WebClient();
        byte[] buffer = client.DownloadData(filename);

        //       [Byte]() buffer=client.DownloadData(path);


        //If buffer IsNot Nothing Then

        string ext = Path.GetExtension(filename);
        if (ext.ToLower() == ".pdf")
        {
            Response.ContentType = "application/pdf";
        }
        else if (ext.ToLower() == ".jpeg" || ext.ToLower() == ".jpg")
        {
            Response.ContentType = "image/jpg";
        }
        else if (ext.ToLower() == ".png")
        {
            Response.ContentType = "image/png";
        }
        else if (ext.ToLower() == ".docx" || ext.ToLower() == ".doc")
        {
            Response.ContentType = "Application/msword";
        }
        else if (ext.ToLower() == ".xlsx" || ext.ToLower() == ".xls")
        {
            Response.ContentType = "Application/x-msexcel";
        }

        Response.AddHeader("content-length", buffer.Length.ToString());
        Response.BinaryWrite(buffer);
        Response.End();       

    }
}
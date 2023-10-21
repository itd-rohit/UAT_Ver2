using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HiQPdf;
using System.Drawing;

public partial class Design_OPD_MemberShipCard_HtmlToImage : System.Web.UI.Page
{
    string CardNumber = "";
    string Type = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        CardNumber = Request.QueryString["CardNumber"].ToString();
        Type = Request.QueryString["Type"].ToString();
        Getimage(Type);
    }
    public static byte[] GetImageBuffer(System.Drawing.Image x)
    {
        ImageConverter _imageConverter = new ImageConverter();
        byte[] xByte = (byte[])_imageConverter.ConvertTo(x, typeof(byte[]));
        return xByte;
    }
    public void Getimage(string Type)
    {
        // create the HTML to Image converter
        HtmlToImage htmlToImageConverter = new HtmlToImage();
        htmlToImageConverter.SerialNumber = "g8vq0tPn‐5c/q4fHi‐8fq7rbOj‐sqO3o7uy‐t6Owsq2y‐sa26urq6";
        // set browser width
        htmlToImageConverter.BrowserWidth = 210;
        htmlToImageConverter.HtmlLoadedTimeout = 120;
        htmlToImageConverter.TriggerMode = ConversionTriggerMode.WaitTime;
        htmlToImageConverter.WaitBeforeConvert = 2;

        // convert to image
        System.Drawing.Image imageObject = null;
        string imageFormatName = "jpg";
        string imageFileName ="";
        if (Type == "front")
        {
            imageFileName = String.Format("Front_{0}.{1}", CardNumber, imageFormatName);
        }
        else
        {
            imageFileName = String.Format("Back_{0}.{1}", CardNumber, imageFormatName);
        }
        string Host = HttpContext.Current.Request.Url.Host;
        int Port = HttpContext.Current.Request.Url.Port;
        string url ="";
         if (Type == "front")
        {
            url = "http://" + Host + ":" + Port + "/Design/MemberShipCard/Membership_Card_Design1Front.aspx?CardNumber=" + CardNumber + "";
        }
        else
        {
            url = "http://" + Host + ":" + Port + "/Design/MemberShipCard/Membership_Card_Design1Back.aspx?CardNumber=" + CardNumber + "";
        }
        imageObject = htmlToImageConverter.ConvertUrlToImage(url)[0];

        // get the image buffer in the selected image format
        byte[] imageBuffer = GetImageBuffer(imageObject);

        // the image object rturned by converter can be disposed
        imageObject.Dispose();

        // inform the browser about the binary data format
        string mimeType = imageFormatName == "jpg" ? "jpeg" : imageFormatName;
        HttpContext.Current.Response.AddHeader("Content-Type", "image/" + mimeType);

        // let the browser know how to open the image and the image name
        HttpContext.Current.Response.AddHeader("Content-Disposition",
                    String.Format("attachment; filename={0}; size={1}", imageFileName, imageBuffer.Length.ToString()));

        // write the image buffer to HTTP response
        HttpContext.Current.Response.BinaryWrite(imageBuffer);

        // call End() method of HTTP response to stop ASP.NET page processing
        HttpContext.Current.Response.End();
    }
}
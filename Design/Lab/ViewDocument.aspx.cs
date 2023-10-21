using System;
using System.Net;
using System.Web;

public partial class Design_Lab_ViewDocument : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {


            string fileName = Common.Decrypt(Request.Form["fileName"]);
            string filePath = Common.Decrypt(Request.Form["filePath"]);
            string type = Common.Decrypt(Request.Form["type"]);
            string path = string.Empty;
            if (type == "1")
                path = string.Concat(Resources.Resource.DocumentPath, "/UploadedDocument/", filePath);
            using (var client = new WebClient())
            {
                Byte[] buffer = client.DownloadData(path);

                if (buffer != null)
                {
                    var FileExt = System.IO.Path.GetExtension(fileName);
                    if (FileExt == ".pdf")
                    {
                        Response.ClearContent();
                        Response.ClearHeaders();
                        Response.Cache.SetCacheability(HttpCacheability.NoCache);
                        Response.ContentType = "application/pdf";
                        Response.AddHeader("content-length", buffer.Length.ToString());
                        Response.BinaryWrite(buffer);
                        Response.Flush();
                        Response.Close();

                    }
                    else
                    {
                        string base64String = Convert.ToBase64String(buffer, 0, buffer.Length, Base64FormattingOptions.None);
                        Image1.ImageUrl = "data:image/png;base64," + base64String;
                        Image1.Visible = true;
                    }
                }
            }
        }


        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblError.Text = "Error....";
        }



    }
}
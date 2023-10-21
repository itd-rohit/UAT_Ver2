using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CallCenter_image : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        

        if (Request.QueryString["FilePath"] != null)
        {

            string strRequest = Request.QueryString["FilePath"];  
            if (strRequest != "")
            {
                string path = Server.MapPath("~/CallCenterDocument") + strRequest;  
                var extention = path.Substring(path.LastIndexOf(".") + 1);
                System.IO.FileInfo file = new System.IO.FileInfo(path);   
              

                if (file.Exists) //set appropriate headers  
                {
                    if (extention == "jpg" || extention == "png" || extention == "gif" || extention=="jpeg")
                    {
                        Response.ContentType = "image/png";
                        byte[] data = System.IO.File.ReadAllBytes(path);
                        Response.OutputStream.Write(data, 0, data.Length);
                        Response.OutputStream.Flush();
                        Response.End();
                    }
                    else if (extention == "pdf")
                    {
                        Response.Clear();
                        Response.ContentType = "application/pdf";
                        Response.WriteFile(file.FullName);
                        Response.Flush();
                        Response.End();
                    }
                    else
                    {
                        Response.Write("This file does not open.");
                    }
                    //else if (extention == "docx")
                    //{
                    //    Response.Clear();
                    //    Response.ContentType = "Application/msword";
                    //    Response.WriteFile(file.FullName);
                    //    Response.Flush();
                    //    Response.End();
                    //}
                }
                else
                {
                    // if file does not exist
                    Response.Write("This file does not exist.");
                }
            }
            else
            {
                //nothing in the URL as HTTP GET
                Response.Write("Please provide a file to download.");
            }
        }
    }
}

 
<%@ WebHandler Language="C#" Class="imageuploader" %>

using System;
using System.Web;
using System.Web.Hosting;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;

public class imageuploader : IHttpHandler
{    
    public void ProcessRequest (HttpContext context) {
        if (context.Request.Files.Count > 0)
        {
            string path = context.Server.MapPath("~/Design/OPD/MemberShipCard/Photo/");
            if (!Directory.Exists(path))
                Directory.CreateDirectory(path);

            System.Web.HttpPostedFile file = context.Request.Files[0];

            string fileName;

            if (HttpContext.Current.Request.Browser.Browser.ToUpper() == "IE")
            {
                string[] files = file.FileName.Split(new char[] { '\\' });
                fileName = Guid.NewGuid().ToString() + "" + files[files.Length - 1];
            }
            else
            {
                fileName = Guid.NewGuid().ToString() + "" + file.FileName;
            }
            string strFileName = fileName;
            fileName = Path.Combine(path, fileName);
            file.SaveAs(fileName);


            string msg = "{";
            msg += string.Format("error:'{0}',\n", string.Empty);
            msg += string.Format("msg:'{0}'\n", strFileName);
            msg += "}";
            context.Response.Write(msg);
        }      
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}
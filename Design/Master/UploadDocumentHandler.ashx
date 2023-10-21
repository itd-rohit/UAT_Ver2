<%@ WebHandler Language="C#" Class="UploadDocumentHandler" %>

using System;
using System.Web;
using System.IO;
using MySql.Data.MySqlClient;
using System.Text;
using System.Data;
using System.Web.SessionState;

public class UploadDocumentHandler : IHttpHandler, IReadOnlySessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int ID = Util.GetInt(context.Request.QueryString["id"]);
            string type = Util.GetString(context.Request.QueryString["type"]);
            // var dirFullPath = new DirectoryInfo(string.Concat(Resources.Resource.DocumentPath, "\\" + type + "\\"));
              string dirFullPath = Resources.Resource.DocumentPath + "\\" + type + "\\";
           // string dirFullPath = context.Server.MapPath("~/App_Images/" + type);

            if (!Directory.Exists(dirFullPath))
            {
                Directory.CreateDirectory(dirFullPath);
            }
            string str_image = "";
            foreach (string s in context.Request.Files)
            {
                HttpPostedFile file = context.Request.Files[s];
                string fileName = file.FileName;
                string fileExtension = file.ContentType;

                if (!string.IsNullOrEmpty(fileName))
                {
                    fileExtension = Path.GetExtension(fileName);
                    str_image = type + "_" + ID + "_" + DateTime.Now.ToString("yyyyMMddhhmmss") + fileExtension;
                    // string pathToSave = context.Server.MapPath("~/App_Images/" + type + "/" + str_image);
                      string pathToSave = Resources.Resource.DocumentPath + "\\" + type + "\\" + str_image;
                    file.SaveAs(pathToSave);
                }
            }

           
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update document_master_setup set ");

            if (type.ToUpper() == "DynamicHeader".ToUpper())
            {
                sb.Append("  dynamicImageHeaderPath=@dynamicImageHeaderPath ,dynmicImageUploadDate=NOW(),dynamicImageUploadName=@dynamicImageUploadName,dynamicImageUploadby=@dynamicImageUploadby");

            }
            else
            {
                sb.Append("  documentPath=@dynamicImageHeaderPath ,documentUploadDate=NOW(),documentUploadByName=@dynamicImageUploadName,documentUploadBy=@dynamicImageUploadby");
            }

            sb.Append(" where documentID=@ID ");
            int a = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@dynamicImageHeaderPath", str_image),
                new MySqlParameter("@ID", ID),
                new MySqlParameter("@dynamicImageUploadby", UserInfo.ID),
                new MySqlParameter("@dynamicImageUploadName", UserInfo.LoginName));
            if (a > 0)
            {
                context.Response.Write("1");
            }
            else
            {
                context.Response.Write("0");
            }
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            context.Response.Write("0");
        }
        finally
        {
            con.Close();       
            con.Dispose();
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}
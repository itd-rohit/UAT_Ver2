<%@ WebHandler Language="C#" Class="PanelFileUploadHandler" %>

using System;
using System.Web;
using System.IO;
using MySql.Data.MySqlClient;
using System.Text;
using System.Data;

public class PanelFileUploadHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{


    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\UploadedDocument");
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        RootDir = string.Concat(RootDir, @"\", DateTime.Now.ToString("yyyyMMdd"));
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        try
        {
            string[] files;
            files = System.IO.Directory.GetFiles(RootDir);

           

            string PostedFileName = Util.GetString(context.Request.Form["Filename"]);
            
            if (Util.GetInt(context.Request.Form["alreadyInserted"]) > 0)
            {
                PostedFileName = string.Concat(PostedFileName, context.Request.Form["alreadyInserted"].ToString());
            }
            string FName = string.Empty;
            string FileName = string.Empty;
            string FileExtension = string.Empty;
            HttpPostedFile file = context.Request.Files[0];
            FileExtension = string.Concat(PostedFileName, System.IO.Path.GetExtension(file.FileName));
            FName = Guid.NewGuid().ToString();
            FileName = FName + FileExtension;
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                int lastInsertedID = 0;
                StringBuilder sb = new StringBuilder();


                string LabNo = string.Empty;
                if (Util.GetString(context.Request.Form["LabNo"]) == string.Empty)
                    LabNo = context.Request.Form["Filename"];
                else
                    LabNo = context.Request.Form["LabNo"];

                sb.Append(" INSERT INTO document_detail (DocumentID,DocumentName,PatientID,LabNo,PanelID,CreatedByID,CreatedDate,filename,isActive,isDefault,FromPUPPortal,CreatedBy) ");
                sb.Append(" VALUES (@DocumentID,@DocumentName,'',@LabNo,@PatientID,@CreatedByID,NOW(),@FileName,1,1,0,@CreatedBy) ");

                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@DocumentID", context.Request.Form["documentID"]),
                   new MySqlParameter("@DocumentName", context.Request.Form["documentName"]),
                   new MySqlParameter("@LabNo", LabNo),
                   new MySqlParameter("@PatientID", context.Request.Form["Patient_ID"]),
                   new MySqlParameter("@CreatedByID", context.Session["ID"].ToString()),
                   new MySqlParameter("@FileName", FileName),
                   new MySqlParameter("@CreatedBy", context.Session["LoginName"].ToString()));

                lastInsertedID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT LAST_INSERT_ID() as AutoKey"));


                if (!string.IsNullOrEmpty(file.FileName))
                {
                    file.SaveAs(string.Concat(RootDir, @"\", FileName));
                    context.Response.Write(lastInsertedID);
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
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}
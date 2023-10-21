using System;
using System.Collections.Generic;
using System.Web;
using System.IO;
using System.Threading;
using System.Web.UI;
using System.Net;

public partial class Design_Lab_DownloadAttachment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string filename = Request.QueryString["FileName"].ToString();
        string FilePath = Request.QueryString["FilePath"].ToString();
        if (Util.GetString(Request.QueryString["Type"]) == "1")
        {
            fileDownload(filename, string.Concat(Resources.Resource.DocumentPath, "/Uploaded Report/", FilePath));
        }
        else if (Util.GetString(Request.QueryString["Type"]) == "2")
        {
            fileDownload(filename, string.Concat(Resources.Resource.DocumentPath, "/SalesDocument/", FilePath));
        }
        else if (Util.GetString(Request.QueryString["Type"]) == "3")
        {
            fileDownload(filename, string.Concat(Resources.Resource.DocumentPath, "/CallCenterDocument/", FilePath));
        }
        else if (Util.GetString(Request.QueryString["Type"]) == "4")
        {
            fileDownload(filename, string.Concat(Resources.Resource.DocumentPath, "/Panel_Document/", FilePath));
        }
        else if (Util.GetString(Request.QueryString["Type"]) == "5")
        {
            fileDownload(filename, string.Concat(Resources.Resource.DocumentPath, "/Uploaded Document/", FilePath));
        }
        else
        {
            fileDownload(filename, string.Concat(Resources.Resource.DocumentPath, "/UploadedDocument/", FilePath));
        }
        //(error throwing here and file is not downloading)
    }

    private void fileDownload(string fileName, string fileUrl)
    {
		if (Util.GetString(Request.QueryString["Type"])=="1" || Util.GetString(Request.QueryString["Type"]) =="2" || Util.GetString(Request.QueryString["Type"])=="3"){
        Page.Response.Clear();
        bool success = ResponseFile(Page.Request, Page.Response, fileName, fileUrl, 1024000);
        if (!success)
            Response.Write("Downloading Error!");
        Page.Response.End();
		}
		else 
		{
			 string ext = System.IO.Path.GetExtension(fileUrl);
            if (ext.Replace(".", "").ToUpper() == "PDF")
            {
			WebClient User = new WebClient();
			Byte[] FileBuffer = User.DownloadData(fileUrl);
			//System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\dlw.txt",fileUrl);
			if (FileBuffer != null)
			{
				Response.ContentType = "application/pdf";
				Response.AddHeader("content-length", FileBuffer.Length.ToString());
				Response.BinaryWrite(FileBuffer);
			}  
			}
			else 
			{
				string mmc = Convert.ToBase64String(File.ReadAllBytes(fileUrl));
				//string ext = System.IO.Path.GetExtension(fileUrl);
           
                mm.Attributes["src"] = @"data:image/" + ext.Replace(".", "") + ";base64," + mmc;
			}
		}
    }
    public static bool ResponseFile(HttpRequest _Request, HttpResponse _Response, string _fileName, string _fullPath, long _speed)
    {
        try
        {
            FileStream myFile = new FileStream(_fullPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
            BinaryReader br = new BinaryReader(myFile);
            try
            {
                _Response.AddHeader("Accept-Ranges", "bytes");
                _Response.Buffer = false;
                long fileLength = myFile.Length;
                long startBytes = 0;

                int pack = 10240; //10K bytes
                int sleep = (int)Math.Floor((double)(1000 * pack / _speed)) + 1;
                if (_Request.Headers["Range"] != null)
                {
                    _Response.StatusCode = 206;
                    string[] range = _Request.Headers["Range"].Split(new char[] { '=', '-' });
                    startBytes = Convert.ToInt64(range[1]);
                }
                _Response.AddHeader("Content-Length", (fileLength - startBytes).ToString());
                if (startBytes != 0)
                {
                    _Response.AddHeader("Content-Range", string.Format(" bytes {0}-{1}/{2}", startBytes, fileLength - 1, fileLength));
                }
                _Response.AddHeader("Connection", "Keep-Alive");
                _Response.ContentType = "application/octet-stream";
                _Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(_fileName, System.Text.Encoding.UTF8));

                br.BaseStream.Seek(startBytes, SeekOrigin.Begin);
                int maxCount = (int)Math.Floor((double)((fileLength - startBytes) / pack)) + 1;

                for (int i = 0; i < maxCount; i++)
                {
                    if (_Response.IsClientConnected)
                    {
                        _Response.BinaryWrite(br.ReadBytes(pack));
                        Thread.Sleep(sleep);
                    }
                    else
                    {
                        i = maxCount;
                    }
                }
            }
            catch
            {
                return false;
            }
            finally
            {
                br.Close();
                myFile.Close();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;
        }
        return true;
    }
}
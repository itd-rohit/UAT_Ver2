using ICSharpCode.SharpZipLib.Zip;
using System;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Threading;
using System.Web;
using System.Web.UI;

public partial class Design_Master_CreateZIP : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    private void fileDownload(string fileName, string fileUrl)
    {
        Page.Response.Clear();
        bool success = ResponseFile(Page.Request, Page.Response, fileName, fileUrl, 1024000);
        if (!success)
            Response.Write("Downloading Error!");
        HttpContext.Current.ApplicationInstance.CompleteRequest();
        //  Page.Response.End();
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

    protected void btnZip_Click(object sender, EventArgs e)
    {
        lblError.Text = "";
        try
        {
            string MySqlPath = @"C:\Program Files\MySQL\MySQL Server 5.6\bin\";
            string txtSourceUsername = "root";
            string txtSourcePwd = "123456";
            string txtSourceDB = "apollo";

            string tbName = "";
            DataTable dt = StockReports.GetDataTable("SELECT TABLE_NAME FROM table_master_apollo WHERE TABLE_TYPE='master' ");
            if (dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (tbName != string.Empty)
                    {
                        tbName += " " + dt.Rows[i]["TABLE_NAME"].ToString() + "";
                    }
                    else
                    {
                        tbName = "" + dt.Rows[i]["TABLE_NAME"].ToString() + "";
                    }
                }
            }
            //string tbName = StockReports.ExecuteScalar("SELECT GROUP_CONCAT(TABLE_NAME SEPARATOR ' ') FROM table_master_apollo WHERE TABLE_TYPE='master'");
            string txtTempPath = @"e:\db\";
            string fileName = "Apollo";

            if (tbName == "")
                return;

            //creating backup file
            Process p = new Process();
            //string ConStr = "server=" + txtSourceIP.Text + ";user id=" + txtSourceUsername.Text + "; password=" + txtSourcePwd.Text + ";database=" + txtSourceDB.Text + "; pooling=false;Respect Binary Flags=false;";
            p.StartInfo.FileName = MySqlPath + "mysqldump.exe";
            p.StartInfo.Arguments = String.Format("-P 3306 -u {0} -p{1} {2} --tables {3} --result-file {4}",
                txtSourceUsername,
                txtSourcePwd,
                txtSourceDB,
                tbName,
                txtTempPath + "" + fileName + ".sql"
                );
            p.StartInfo.UseShellExecute = false;
            p.StartInfo.CreateNoWindow = false;
            p.Start();
            p.WaitForExit();
            p.Dispose();

            //create zip
            FastZip obj = new FastZip();
            obj.CreateZip(txtTempPath + "" + fileName + ".zip", txtTempPath, false, fileName + ".sql");

            // delete .sql file
            if (File.Exists(txtTempPath + "" + fileName + ".sql"))
                File.Delete(txtTempPath + "" + fileName + ".sql");

            fileDownload(fileName + ".zip", txtTempPath + "" + fileName + ".zip");

            //// delete .zip file
            //if (File.Exists(txtTempPath + "" + tbName + ".zip"))
            //    File.Delete(txtTempPath + "" + tbName + ".zip");
            lblError.Text = "Created Successfully";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblError.Text = "Error";
            btnZip.Enabled = true;
            btnZip.Text = "Create BackUp";
        }
    }
}
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_PettyCash_UploadExpncesDoc : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Util.GetString(Request.QueryString["FileName"]) != string.Empty)
            {
                lblupl.Text = Request.QueryString["FileName"];
                if (Util.GetString(Request.QueryString["IsView"]) != string.Empty)
                {
                    lblIsView.Text = "1";
                    btnSave.Visible = false;
                    pnlView.Visible = false;
                }
                else
                    lblIsView.Text = "0";

                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    bindAttachment(con);
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }
                finally
                {
                    con.Close();
                    con.Dispose();
                }
            }
        }
        this.ClientScript.GetPostBackEventReference(this, string.Empty);
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (fu_Upload.HasFile)
        {
            int fileSize = fu_Upload.PostedFile.ContentLength;
            if (fileSize > 10485760)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindMessage('You can Only Upload 10 MB File','Error');", true);
                fu_Upload.Focus();
                return;
            }
            string[] validFileTypes = { "doc", "docx", "pdf", "jpg", "png", "gif", "jpeg", "xlsx", "JPG" };
            string ext =Path.GetExtension(fu_Upload.FileName);
            bool isValidFile = false;
            for (int i = 0; i < validFileTypes.Length; i++)
            {
                if (ext == "." + validFileTypes[i])
                {
                    isValidFile = true;
                    break;
                }
            }
            if (!isValidFile)
            {
                string msg = "Invalid File. Please upload a File with extension " +
                               string.Join(",", validFileTypes);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", string.Format("bindMessage({0},'Error');", msg), true);
                return;
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindMessage('Please Select File to Upload','Error');", true);
            fu_Upload.Focus();
            return;
        }
        string Filename = string.Empty;
      
        Filename = Util.GetString(Request.QueryString["Filename"]);
        if (Filename == string.Empty)
            return;
        Filename = Guid.NewGuid().ToString();
        string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\PettyCash");

        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        RootDir = string.Format(@"{0}\{1:yyyyMMdd}", RootDir, DateTime.Now);
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        string fileExt = Path.GetExtension(fu_Upload.FileName);
        string ComFileName = Filename + fileExt;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO  PettyCash_document (TempID,FileName,FileUrl,CreatedByID,CreatedBy) VALUES ( ");
            sb.Append(" @TempID,@Filename,@ComFileName,@CreatedByID,@CreatedBy) ");

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@TempID", lblupl.Text),
                new MySqlParameter("@Filename", Filename),
                new MySqlParameter("@ComFileName", ComFileName),
                new MySqlParameter("@CreatedByID", UserInfo.ID),
                new MySqlParameter("@CreatedBy", UserInfo.LoginName));
            fu_Upload.SaveAs(string.Format(@"{0}\{1}", RootDir, ComFileName));
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindMessage('File Saved','Success');", true);
            bindAttachment(con);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void grvAttachment_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Remove")
        {
            GridViewRow gvr = ((Control)e.CommandSource).Parent.Parent as GridViewRow;
            Label lblPath = (Label)gvr.FindControl("lblPath");

            string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\PettyCash");
            if (File.Exists(RootDir + lblPath.Text))
            {
                File.Delete(RootDir + lblPath.Text);
            }
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                MySqlHelper.ExecuteScalar(con, CommandType.Text, "DELETE FROM PettyCash_document where ID=@ID",
                  new MySqlParameter("@ID", e.CommandArgument.ToString()));
                bindAttachment(con);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindMessage('File Deleted Successfully','Success');", true);
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }
    }

    private void bindAttachment(MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,FileName,TempID,CONCAT('/',DATE_FORMAT(CreatedDate,'%Y%m%d'),'/',FileUrl) FilePath,FileUrl,CreatedBy UploadedBy,DATE_FORMAT(CreatedDate,'%d-%b-%y')  dtEntry ");
        sb.Append(" FROM PettyCash_document  ");
        sb.Append(" WHERE TempID=@TempID ");

        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
             new MySqlParameter("@TempID", lblupl.Text)).Tables[0])
        {
            grvAttachment.DataSource = dt;
            grvAttachment.DataBind();
        }
    }

    [WebMethod]
    public static string EncryptDocument(int ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ID,FileName,TempID,CONCAT('/',DATE_FORMAT(CreatedDate,'%Y%m%d'),'/',FileUrl) FilePath,FileUrl ");
            sb.Append(" FROM PettyCash_document  ");
            sb.Append(" WHERE ID=@ID ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@ID", ID)).Tables[0])
            {
                return JsonConvert.SerializeObject(new { status = "true", fileName = Common.Encrypt(dt.Rows[0]["FileUrl"].ToString()), filePath = Common.Encrypt(dt.Rows[0]["FilePath"].ToString()), type = Common.Encrypt("5") });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void grvAttachment_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (lblIsView.Text == "1")
            {
                ((ImageButton)e.Row.FindControl("imgRemove")).Visible = false;
            }
        }
    }
}
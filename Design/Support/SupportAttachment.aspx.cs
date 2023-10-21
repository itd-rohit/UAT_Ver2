using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Support_SupportAttachment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
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
        this.ClientScript.GetPostBackEventReference(this, string.Empty);
    }
    private void bindAttachment(MySqlConnection con)
    {

        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text,
                                      "SELECT FileId ID,CONCAT('/',DATE_FORMAT(dtEntry,'%Y%m%d'),'/',FilePath)  FileUrl,FilePath AttachedFile,Date_Format(dtEntry,'%d-%b-%Y')dtEntry  FROM support_uploadedfile WHERE DynamicNo=@DynamicNo",
                                      new MySqlParameter("@DynamicNo", Util.GetString(Request.QueryString["Filename"]))).Tables[0])
            {
               
                    grvAttachment.DataSource = dt;
                    grvAttachment.DataBind();
                
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!fu_Upload.HasFile)
        {
            lblMsg.Text = "Please Select file to upload";
            return;
        }
        string DynamicNo = Util.GetString(Request.QueryString["Filename"]);

        if (DynamicNo == string.Empty)
            return;
        string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\SupportFiles");
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);
        RootDir = string.Format(@"{0}\{1:yyyyMMdd}", RootDir, DateTime.Now);
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

       


        string fileName = Path.GetFileNameWithoutExtension(fu_Upload.PostedFile.FileName);
        string ext = Path.GetExtension(Path.GetFileName(fu_Upload.PostedFile.FileName));

        
        string ComFileName = DynamicNo + ext;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con,
                CommandType.Text,
                "INSERT INTO `support_uploadedfile`(`FileName`,`FilePath`,`TicketId`,`ReplyId`,`dtEntry`,FileExt,DynamicNo) VALUES (@FileName,@FilePath,0,0,NOW(),@fileExt,@DynamicNo)",
                new MySqlParameter("@FileName", DynamicNo),
                new MySqlParameter("@FilePath", ComFileName),
                new MySqlParameter("@fileExt", ext),
                new MySqlParameter("@DynamicNo", DynamicNo));
            fu_Upload.SaveAs(string.Format(@"{0}\{1}", RootDir, ComFileName));

            lblMsg.Text = "File Uploaded Successfully";
            bindAttachment(con);
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;

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

            string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\SupportFiles");
            if (File.Exists(RootDir + lblPath.Text))
            {
                File.Delete(RootDir + lblPath.Text);
            }
            
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "DELETE FROM support_uploadedfile WHERE FileId=@FileId",
                   new MySqlParameter("@FileId", e.CommandArgument.ToString()));

                bindAttachment(con);
            }
            catch (Exception ex)
            {
                lblMsg.Text = ex.Message;

            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }

    }

}
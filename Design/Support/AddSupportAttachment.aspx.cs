using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using cfg = System.Configuration.ConfigurationManager;

public partial class Design_Support_AddSupportAttachment : System.Web.UI.Page
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
            lblMsg.Text = "";
        }
    }

    private void bindAttachment(MySqlConnection con)
    {
        
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con,
                                      CommandType.Text,
                                      "SELECT FileId ID,REPLACE(FilePath,'\\\\','//')  FileUrl,FileName AttachedFile,Date_Format(dtEntry,'%d-%b-%y %h:%i %p')dtEntry  FROM support_uploadedfile WHERE DynamicNo=@DynamicNo",
                                      new MySqlParameter("@DynamicNo", Util.GetString(Request.QueryString["Filename"]))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    grvAttachment.DataSource = dt;
                    grvAttachment.DataBind();
                }
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
        string RootDir = Path.GetFullPath(cfg.AppSettings["SupportFilePath"]);
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        string fileExt = Path.GetExtension(fu_Upload.FileName);
        string FileName = fu_Upload.FileName;
        RootDir = RootDir.Replace("\\", "\\\\");

        RootDir = RootDir + FileName;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con,
                CommandType.Text,
                "INSERT INTO `support_uploadedfile`(`FileName`,`FilePath`,`TicketId`,`ReplyId`,`dtEntry`,FileExt,DynamicNo) VALUES (@FileName,@RootDir,0,0,NOW(),@fileExt,@DynamicNo)",
                new MySqlParameter("@FileName", FileName),
                new MySqlParameter("@RootDir", RootDir),
                new MySqlParameter("@fileExt", fileExt),
                new MySqlParameter("@DynamicNo", DynamicNo));
            fu_Upload.SaveAs(RootDir);

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
            if (File.Exists(lblPath.Text))
            {
                File.Delete(lblPath.Text);
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
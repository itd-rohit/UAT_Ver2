using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CallCenter_UploadDocument : System.Web.UI.Page
{
    private string TicketID = string.Empty;
    private string pagename = string.Empty;
    private string ReplyID = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch1", "document.getElementById('masterheaderid').style.display='none';", true);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch12", "document.getElementById('mastertopcorner').style.display='none';", true);
        if (Util.GetString(Request.QueryString["TicketId"]) != string.Empty)
            TicketID = Common.Decrypt(Util.GetString(Request.QueryString["TicketId"]));
        if (Util.GetString(Request.QueryString["ReplyID"]) != string.Empty)
            ReplyID = Util.GetString(Request.QueryString["ReplyID"]);
        if (!IsPostBack)
        {
            bindAttachment();
        }
        lblMsg.Text = string.Empty;
    }

    private void bindAttachment()
    {
        StringBuilder sb = new StringBuilder();

        //sb.Append(" SELECT FileID ID,FileName AttachedFile,CONCAT('/',DATE_FORMAT(dtEntry,'%Y%m%d'),'/',filename) fileUrl,CreatedBy UploadedBy,DATE_FORMAT(dtEntry,'%d-%b-%y')  dtEntry ");
        sb.Append(" SELECT FileID ID,CONCAT(FileName,'',FileExt) AS  AttachedFile,CONCAT(CONCAT('/',DATE_FORMAT(dtEntry,'%Y%m%d'),'/',filename,'',FileExt)) fileUrl,CreatedBy UploadedBy,DATE_FORMAT(dtEntry,'%d-%b-%y')  dtEntry ");

        sb.Append(" FROM support_uploadedfile WHERE ");
         if (TicketID != string.Empty)
        {
            sb.Append("  TicketID='" + TicketID + "'  ");
        }
         else if (ReplyID != string.Empty)
        {
            sb.Append("  TempID='" + Util.GetString(Request.QueryString["ReplyID"]) + "'  ");
        }
       
        else
        {
            sb.Append("  TempID='" + Util.GetString(ReplyID) + "'  ");
        }

         sb.Append("  and IsPrtSrc='0'  ");
        
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        grvAttachment.DataSource = dt;
        grvAttachment.DataBind();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (fu_Upload.HasFile)
        {

            int fileSize = fu_Upload.PostedFile.ContentLength;

            // Allow only files less than 2097152 bytes (approximately 2 MB) to be uploaded.
            if (fileSize > 2097152)
            {
                lblMsg.Text = "You can Only Upload 2 MB File";
                fu_Upload.Focus();
                return;
            }
            string[] validFileTypes = { "doc", "docx", "pdf", "jpg", "png", "gif", "jpeg" };
            string ext = System.IO.Path.GetExtension(fu_Upload.FileName);
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

                lblMsg.Text = "Invalid File. Please upload a File with extension " +
                               string.Join(",", validFileTypes);
                return;
            }

        }
        else
        {
            lblMsg.Text = "Please Select File to Upload";
            fu_Upload.Focus();
            return;
        }

        string Filename = string.Empty;
       
        if (ReplyID != string.Empty)
        {
            Filename = Util.GetString(Request.QueryString["ReplyID"]);

        }
        else
        {
            Filename = Guid.NewGuid().ToString();
          
        }

        if (grvAttachment.Rows.Count > 0)
        {
            Filename = Filename + grvAttachment.Rows.Count.ToString();
        }

        if (Filename == string.Empty)
            return;

        string RootDir = Server.MapPath("~/CallCenterDocument");

        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        RootDir = RootDir + @"\" + DateTime.Now.ToString("yyyyMMdd");
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        string fileExt = System.IO.Path.GetExtension(fu_Upload.FileName);
        string FilePath = Filename + fileExt;

        string FileName = Filename;// Path.GetFileNameWithoutExtension(fu_Upload.PostedFile.FileName);
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" INSERT INTO  support_uploadedfile (TicketId,ReplyID,TempID,CreatedByID,CreatedBy,filename,FileExt,FilePath,IsPrtSrc) VALUES ( ");
            if (TicketID == string.Empty)
            {
                sb.Append(" '0' ,");
            }
            else
            {
                sb.Append(" '" + TicketID + "' ,");
            }

            sb.Append("  '0' ,'" + Util.GetString(Request.QueryString["ReplyID"]) + "','" + UserInfo.ID + "','" + UserInfo.LoginName + " ','" + FileName + "','" + fileExt + "','" + FilePath + "','0') ");

            StockReports.ExecuteDML(sb.ToString());

            fu_Upload.SaveAs(RootDir + @"\" + FilePath);
            lblMsg.Text = "File Uploaded Successfully";
            bindAttachment();
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.ToString();
        }
    }

    protected void grvAttachment_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Remove")
        {
            GridViewRow gvr = ((Control)e.CommandSource).Parent.Parent as GridViewRow;
            Label lblPath = (Label)gvr.FindControl("lblPath");

            string RootDir = Server.MapPath("~/CallCenterDocument");
            if (File.Exists(RootDir + lblPath.Text))
            {
                File.Delete(RootDir + lblPath.Text);
            }

            StockReports.ExecuteDML("delete from support_uploadedfile where FileID='" + e.CommandArgument.ToString() + "'");
        }
        bindAttachment();
    }
}
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

         sb.Append("  and IsPrtSrc='1'  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        grvAttachment.DataSource = dt;
        grvAttachment.DataBind();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string Image = imageurl.Value;
        Image = Image.Replace("data:image/png;base64,", "");
        var bytess = Convert.FromBase64String(Image);

        string Filename = "prtscr";

        if (ReplyID != string.Empty)
        {
            Filename =Filename+ Util.GetString(Request.QueryString["ReplyID"]);

        }
        else
        {
            Filename = Filename+Guid.NewGuid().ToString();

        }
        if (grvAttachment.Rows.Count > 0)
        {
            Filename = Filename + grvAttachment.Rows.Count.ToString();
        }
       
        if (Filename =="prtscr")
            return;

        string RootDir = Server.MapPath("~/CallCenterDocument");

        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        RootDir = RootDir + @"\" + DateTime.Now.ToString("yyyyMMdd");
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        string fileExt = ".png";
        string FilePath = Filename + fileExt;

        string FileName = Filename;
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

            sb.Append("  '0' ,'" + Util.GetString(Request.QueryString["ReplyID"]) + "','" + UserInfo.ID + "','" + UserInfo.LoginName + " ','" + FileName + "','" + fileExt + "','" + FilePath + "','1') ");

            StockReports.ExecuteDML(sb.ToString());

            using (var imageFile = new FileStream(RootDir + @"\" + FilePath, FileMode.Create))
            {
                imageFile.Write(bytess, 0, bytess.Length);
                imageFile.Flush();
            }
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
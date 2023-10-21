using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Sales_UploadDocument : System.Web.UI.Page
{
    private string EnrollID = string.Empty;
    private string pagename = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch1", "document.getElementById('masterheaderid').style.display='none';", true);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch12", "document.getElementById('mastertopcorner').style.display='none';", true);
        if (Util.GetString(Request.QueryString["EnrolID"]) != string.Empty)
            EnrollID = Common.Decrypt(Util.GetString(Request.QueryString["EnrolID"]));
        if (Util.GetString(Request.QueryString["IsView"]) != string.Empty)
        {
            btnSave.Visible = false;
        }
        if (!IsPostBack)
        {
            ddldoctype.DataSource = StockReports.GetDataTable("SELECT ID,Name FROM `document_master` WHERE isActive=1 AND isCentreDocument=1 ORDER BY Priority+0 ");
            ddldoctype.DataTextField = "Name";
            ddldoctype.DataValueField = "ID";
            ddldoctype.DataBind();
            ddldoctype.Items.Insert(0, new ListItem("Select", "0"));
            bindAttachment();
        }
        lblMsg.Text = string.Empty;
    }

    private void bindAttachment()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT ID,DocumentName DocType,filename AttachedFile,IF(EnrollID='','0','1') Approved,CONCAT('/',DATE_FORMAT(CreatedDate,'%Y%m%d'),'/',filename) fileUrl,CreatedBy UploadedBy,DATE_FORMAT(CreatedDate,'%d-%b-%y')  dtEntry ");

        sb.Append(" FROM Sales_document WHERE ");
        if (EnrollID == string.Empty)
        {
            sb.Append("  TempID='" + Util.GetString(Request.QueryString["Filename"]) + "'  ");
        }
        else
        {
            sb.Append("  EnrollID='" + Util.GetString(EnrollID) + "'  ");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        grvAttachment.DataSource = dt;
        grvAttachment.DataBind();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ddldoctype.SelectedValue == "0")
        {
            lblMsg.Text = "Please Select Doc Type";
            ddldoctype.Focus();
            return;
        }
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
            string[] validFileTypes = { "doc", "docx", "pdf", "jpg", "png", "gif", "jpeg" ,"xlsx"};
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
        string ss = string.Empty;
        if (EnrollID == string.Empty)
        {
            Filename = Util.GetString(Request.QueryString["Filename"]);
        }
        else
        {
            Filename = Guid.NewGuid().ToString();
            ss = Filename;
        }
        if (grvAttachment.Rows.Count > 0)
        {
            Filename = Filename + grvAttachment.Rows.Count.ToString();
        }

        if (Filename == string.Empty)
            return;

        string RootDir = Server.MapPath("~/SalesDocument");

        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        RootDir = RootDir + @"\" + DateTime.Now.ToString("yyyyMMdd");
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        string fileExt = System.IO.Path.GetExtension(fu_Upload.FileName);
        string FileName = Filename + fileExt;

        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" INSERT INTO  Sales_document (EnrollID,DocumentID,DocumentName,TempID,CreatedByID,CreatedBy,filename) VALUES ( ");
            if (EnrollID == string.Empty)
            {
                sb.Append(" '0' ");
            }
            else
            {
                sb.Append(" '" + EnrollID + "' ");
            }
            sb.Append(" ,'" + ddldoctype.SelectedItem.Value + "','" + ddldoctype.SelectedItem.Text + "','" + Util.GetString(Request.QueryString["Filename"]) + "','" + UserInfo.ID + "','" + UserInfo.LoginName + " ','" + FileName + "') ");

            StockReports.ExecuteDML(sb.ToString());

            fu_Upload.SaveAs(RootDir + @"\" + FileName);
            lblMsg.Text = "File Saved..!";
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

            string RootDir = Server.MapPath("~/SalesDocument");
            if (File.Exists(RootDir + lblPath.Text))
            {
                File.Delete(RootDir + lblPath.Text);
            }

            StockReports.ExecuteDML("delete from Sales_document where id='" + e.CommandArgument.ToString() + "'");
        }
        bindAttachment();
    }
}
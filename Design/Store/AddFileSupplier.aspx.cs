using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_AddFileSupplier : System.Web.UI.Page
{

   
    string VendorId = "";
    string filename1 = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        
        VendorId = Util.GetString(Request.QueryString["vendorid"]);
        if (VendorId == "")
        {
            VendorId = "0";
        }
        filename1 = Util.GetString(Request.QueryString["filename"]);
        if (!IsPostBack)
        {

            ddldoctype.DataSource = StockReports.GetDataTable("SELECT Name FROM `st_document_master` WHERE isactive=1 ORDER BY NAME ");
            ddldoctype.DataTextField = "Name";
            ddldoctype.DataValueField = "Name";
            ddldoctype.DataBind();

            bindAttachment();
        }
        lblMsg.Text = "";
    }



    private void bindAttachment()
    {
        
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  ID,FileName,file AttachedFile,OriginalFileName FROM st_vendor_document WHERE VendorID='" + VendorId + "' ");



        DataTable dt = StockReports.GetDataTable(sb.ToString());
        grvAttachment.DataSource = dt;
        grvAttachment.DataBind();




    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        
        if (ddldoctype.SelectedValue == "0")
        {
            lblMsg.Text = "Please Select Doc Type";
            return;
        }
        string RootDir = "";
        string filename = "";
        Random r = new Random();

        filename = VendorId + r.Next()+ddldoctype.Text;
       
        RootDir = Server.MapPath("~/Design/Store/UploadedDocument");

        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir); 
        string fileExt = System.IO.Path.GetExtension(fu_Upload.FileName);
        string FileName = filename + fileExt;

        FileName = FileName.Replace(" ", "_");
        try
        {
            var url = "~/Design/Store/UploadedDocument/" + FileName;
            StringBuilder sb = new StringBuilder();
            sb.Append(" insert into st_Vendor_Document (OriginalFileName,VendorID,File,FileName,Path,CreatedBy,CreatedDate,newfilename) values('" + fu_Upload.FileName + "','" + VendorId + "','" + FileName + "','" + ddldoctype.SelectedItem + "','" + url + "','" + UserInfo.ID + "',now(),'"+filename1+"')");
            StockReports.ExecuteDML(sb.ToString());
            fu_Upload.SaveAs(RootDir + @"\" + FileName);

            lblMsg.Text = "File Saved..!";
            bindAttachment();
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.InnerException.ToString();

        }




    }
    protected void grvAttachment_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Remove")
        {
            GridViewRow gvr = ((Control)e.CommandSource).Parent.Parent as GridViewRow;
            Label lblPath = (Label)gvr.FindControl("lblPath");
            string RootDir = "";



            RootDir = Server.MapPath("~/Design/Store/UploadedDocument/");
            string aa = RootDir + lblPath.Text;
            if (File.Exists(RootDir + lblPath.Text))
            {
                File.Delete(RootDir + lblPath.Text);
            }
            string bb = "delete from st_Vendor_Document where ID='" + e.CommandArgument.ToString() + "'";
            StockReports.ExecuteDML(bb.ToString());

        }
        bindAttachment();
    }
}
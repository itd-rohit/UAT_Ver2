using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_ILCUpload : System.Web.UI.Page
{
 
    string filename = "";
    public string Approved = "";
    public string PageName = "";
    protected void Page_Load(object sender, EventArgs e)
    {


        filename = Util.GetString(Request.QueryString["filename"]);
        Approved = Util.GetString(Request.QueryString["Approved"]);
        PageName = Util.GetString(Request.QueryString["PageName"]);
        if (PageName != "ResultEntry")
        {
            mmd.Visible = false;
        }
        if (!IsPostBack)
        {

         

            bindAttachment();
        }
        lblMsg.Text = "";
    }



    private void bindAttachment()
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  ID,FileName,file AttachedFile,file OriginalFileName FROM qc_ilcdocument WHERE filename='" + filename + "' ");



        DataTable dt = StockReports.GetDataTable(sb.ToString());
        grvAttachment.DataSource = dt;
        grvAttachment.DataBind();




    }

    protected void btnSave_Click(object sender, EventArgs e)
    {

      
        string RootDir = "";
     
        Random r = new Random();


        RootDir = Util.getApp("ApolloImagePath") + "\\ILCUpload";
        //RootDir = Server.MapPath("~/Design/Store/UploadedDocument");

        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);
        string fileExt = System.IO.Path.GetExtension(fu_Upload.FileName);
        string FileName = filename+"_"+r.Next() + fileExt;

      
        try
        {
            var url = "ILCUpload/" + FileName;
            StringBuilder sb = new StringBuilder();
            sb.Append(" insert into qc_ilcdocument (Filename,File,Path,EntryDate,EntryByID,EntryByName) values('" + filename + "','" + FileName + "','" + url + "',now(),'" + UserInfo.ID + "','" + UserInfo.LoginName + "')");
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
        if (e.CommandName == "View")
        {
            string file = e.CommandArgument.ToString();
            if (file.ToLower().Contains(".jpg") && file.ToLower().Contains(".png") && file.ToLower().Contains(".jpeg") && file.ToLower().Contains(".gif"))
            {
              
            }
            else if (file.Contains(".pdf"))
            {

            }
            else
            {
                System.Diagnostics.Process.Start(Util.getApp("ApolloImagePath") + "\\ILCUpload\\" + file);
            }
        }
        if (e.CommandName == "Remove")
        {
            if (PageName != "ResultEntry")
            {
                lblMsg.Text = "You Can't Delete File";
                return;
            }
            if (Approved != "0")
            {
                lblMsg.Text = "You Can't Delete File";
                return;
            }
           int app=Util.GetInt(StockReports.ExecuteScalar("select sum(approved) from qc_ilcresultentry where UploadFileName='"+filename+"'"));
           if (app > 0)
           {
               lblMsg.Text = "Result Approved Can't Delete File.!";
               return;
           }
            GridViewRow gvr = ((Control)e.CommandSource).Parent.Parent as GridViewRow;
            Label lblPath = (Label)gvr.FindControl("lblPath");
            string RootDir = "";


            RootDir = Util.getApp("ApolloImagePath") + "\\ILCUpload";
           
            string aa = RootDir + lblPath.Text;
            if (File.Exists(RootDir + lblPath.Text))
            {
                File.Delete(RootDir + lblPath.Text);
            }
            string bb = "delete from qc_ilcdocument where ID='" + e.CommandArgument.ToString() + "'";
            StockReports.ExecuteDML(bb.ToString());

        }
        bindAttachment();
    }
}
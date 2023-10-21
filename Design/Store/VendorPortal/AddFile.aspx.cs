using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_Store_VendorPortal_AddFile : System.Web.UI.Page
{
   
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            
            bindAttachment();

            if (Util.GetString(Request.QueryString["Type"]) == "2")
            {
                lb.Visible = false;
                Button1.Visible = false;
                fu_Upload.Visible = false;
            }
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        
        string RootDir = "";
       




        RootDir = Server.MapPath("~/Design/Store/VendorPortal/UploadedInvoice");

        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);
        string fileExt = System.IO.Path.GetExtension(fu_Upload.FileName);

        Random r = new Random();
        string FileName = Util.GetString(Request.QueryString["Filename"]) + "_" + r.Next() + fileExt;

        try
        {



            StringBuilder sb = new StringBuilder();

            sb.Append(" INSERT INTO  st_purchaseorder_details_vendor_invoice (File,FileName,EntryDate) VALUES ");
            sb.Append(" ('" + Util.GetString(Request.QueryString["Filename"]) + "','" + FileName + "',now()) ");


            StockReports.ExecuteDML(sb.ToString());
            
           
            fu_Upload.SaveAs(RootDir + @"\" + FileName);
            lblMsg.Text = "File Saved..!";
            bindAttachment();
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message.ToString();

        }




    }


    private void bindAttachment()
    {
        string filename = Util.GetString(Request.QueryString["Filename"]);
        filename = "'" + filename + "'";
        filename = filename.Replace(",", "','");
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,File,FileName,DATE_FORMAT(EntryDate,'%d-%b-%Y')  EntryDate FROM st_purchaseorder_details_vendor_invoice WHERE File in(" + filename +") ");



        DataTable dt = StockReports.GetDataTable(sb.ToString());
        grvAttachment.DataSource = dt;
        grvAttachment.DataBind();




    }

    protected void grvAttachment_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Remove")
        {
            GridViewRow gvr = ((Control)e.CommandSource).Parent.Parent as GridViewRow;
            Label lblPath = (Label)gvr.FindControl("lblPath");
            string RootDir = "";



            RootDir = Server.MapPath("~/Design/Store/VendorPortal/UploadedInvoice");
            string aa = RootDir + lblPath.Text;
            if (File.Exists(RootDir + lblPath.Text))
            {
                File.Delete(RootDir + lblPath.Text);
            }
            string bb = "delete from st_purchaseorder_details_vendor_invoice where ID='" + e.CommandArgument.ToString() + "'";
            StockReports.ExecuteDML(bb.ToString());

        }
        bindAttachment();
    }
   
}
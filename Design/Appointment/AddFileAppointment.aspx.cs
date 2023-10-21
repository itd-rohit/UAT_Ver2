using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

public partial class Design_OPD_AddFileAppointment : System.Web.UI.Page
{
    string labno = "";
   protected void Page_Load(object sender, EventArgs e)
    {
        labno = Util.GetString(Request.QueryString["AppID"]);
        if (!IsPostBack)
        {
            binddoctype();
            bindAttachment();
        }
        lblMsg.Text = "";
    }

    public void binddoctype()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT NAME,id FROM document_master"))
        {
            ddldoctype.DataSource = dt;
            ddldoctype.DataTextField = "NAME";
            ddldoctype.DataValueField = "id";
            ddldoctype.DataBind();
            ddldoctype.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    private void bindAttachment()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT id,documentname doctype,filename AttachedFile,CONCAT('/',filename) fileurl,userid UploadedBy,DATE_FORMAT(DATE,'%d-%b-%y')  dtEntry ");
            sb.Append(" FROM appointment_radiology_details_attachment WHERE AppID=@AppID ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@AppID", labno)).Tables[0])
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
        finally
        {
            con.Close();
            con.Dispose();
        }                
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ddldoctype.SelectedValue == "0")
        {
            lblMsg.Text = "Please Select Doc Type";
            return;
        }

        string Filename = "";
        Filename = Guid.NewGuid().ToString();

        if (grvAttachment.Rows.Count > 0)
        {


            Filename = Filename + grvAttachment.Rows.Count.ToString();
        }


        if (Filename == "")
            return;
        string RootDir = "";
        RootDir = Server.MapPath("~/Design/UploadedDocument");
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        string fileExt = System.IO.Path.GetExtension(fu_Upload.FileName);
        string FileName = Filename + fileExt;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO  appointment_radiology_details_attachment (documentid,documentname,AppID,userid,DATE,filename,isactive,isdefault) VALUES ");
            sb.Append(" (@documentid,@documentname,@AppID,@userid,now(),@filename ,'1','1') ");

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@documentid", ddldoctype.SelectedValue),
                new MySqlParameter("@documentname", ddldoctype.SelectedItem.Text),
                new MySqlParameter("@AppID", labno),
                new MySqlParameter("@userid", Util.GetString(UserInfo.LoginName)),
                new MySqlParameter("@filename", FileName));

            fu_Upload.SaveAs(RootDir + @"\" + FileName);
            lblMsg.Text = "File Saved..!";
            bindAttachment();            
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
            string RootDir = Server.MapPath("~/Design/UploadedDocument");
            if (File.Exists(RootDir + lblPath.Text))
            {
                File.Delete(RootDir + lblPath.Text);
            }
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "delete from appointment_radiology_details_attachment where id=@id",
                    new MySqlParameter("@id", e.CommandArgument.ToString()));              
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
        bindAttachment();
    }
}
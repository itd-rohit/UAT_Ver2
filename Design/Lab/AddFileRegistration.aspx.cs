using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
using System.Web.Configuration;
using System.Configuration;
public partial class Design_Lab_AddFileRegistration : System.Web.UI.Page
{

    string labno = "";
    string pagename = "";
    string centerid = "";
    public string FromPUPPortal = "0";
	
    protected void Page_Load(object sender, EventArgs e)
    {   try
        {
            if (Util.GetString(Request.QueryString["HideHelpDesk"]).Trim() == "1")
            {
                ((System.Web.UI.HtmlControls.HtmlControl)Master.FindControl("FeedBack")).Visible = false;
                FromPUPPortal = "1";
            }
            else
            {
                FromPUPPortal = "0";
            }
        }
        catch
        {
            FromPUPPortal = "0";
        }

         labno = Util.GetString(Request.QueryString["labno"]);
         pagename = Util.GetString(Request.QueryString["PageName"]);
        centerid = Util.GetString(Request.QueryString["Filename"]);
        if (!IsPostBack)
        {

            ddldoctype.DataSource = StockReports.GetDataTable("SELECT Name FROM `document_master` WHERE isactive=1 ORDER BY NAME ");
            ddldoctype.DataTextField = "Name";
            ddldoctype.DataValueField = "Name";
            ddldoctype.DataBind();

            bindAttachment();
        }
        lblMsg.Text = "";
    }



    private void bindAttachment()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
			string DocPath=string.Concat(Resources.Resource.DocumentPath, "/Uploaded Report/");
            StringBuilder sb = new StringBuilder();
            if (pagename == "Centermaster")
            {
                sb.Append("SELECT DocumentID id, DocumentName doctype, CenterID,'Centermaster' Type, Path AttachedFile, CONCAT('/',CenterID,'/',Path) fileurl,Concat('"+ DocPath +"','/',CenterID,'/',Path)DocPath, CreatedBy UploadedBy,DATE_FORMAT(CreatedDate, '%d-%b-%y') dtEntry FROM Center_document where CenterID='" + centerid + "'");

            }
            else
            {
                sb.Append(" SELECT '' CenterID, id,documentname doctype,filename AttachedFile,IF(LabNo='','0','1') Approved,CONCAT('/',DATE_FORMAT(CreatedDate,'%Y%m%d'),'/',filename) fileurl,Concat('"+ DocPath +"','/',DATE_FORMAT(CreatedDate,'%Y%m%d'),'/',filename)DocPath,CreatedByID UploadedBy,DATE_FORMAT(CreatedDate,'%d-%b-%y')  dtEntry ");
                if (labno == "")
                {
                    sb.Append(" FROM document_detail WHERE labno=@labno ");
                }
                else
                {
                    sb.Append(" FROM document_detail WHERE labno=@labno1 ");
                }

            }
			//System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\att.txt",sb.ToString());
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@centerid", centerid),
                new MySqlParameter("@labno", Util.GetString(Request.QueryString["Filename"])),
                 new MySqlParameter("@labno1", labno)).Tables[0];
            grvAttachment.DataSource = dt;
            grvAttachment.DataBind();
        }
        catch (Exception ex)
        {
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        HttpRuntimeSection section = new HttpRuntimeSection();
        section.MaxRequestLength = 40960;
        decimal size = Math.Round(((decimal)fu_Upload.PostedFile.ContentLength / (decimal)1024), 2);
        if (size > 10240)
        {
            lblMsg.Text = "File size must not exceed 10 MB.";
            return;
        }
        if (pagename == "Centermaster")
        {
            if (ddlCenterMasterdoctype.SelectedValue == "0")
            {
                lblMsg.Text = "Please Select Doc Type";
                return;
            }
            string Filename = "";
            Filename = centerid;

            if (Filename == "")
                return;

            string RootDir = "";
            RootDir = Server.MapPath("~/Design/Master/DocumentImage");

            if (!Directory.Exists(RootDir))
                Directory.CreateDirectory(RootDir);



            RootDir = RootDir + @"\" + centerid;
            if (!Directory.Exists(RootDir))
                Directory.CreateDirectory(RootDir);
            string fileExt = System.IO.Path.GetExtension(fu_Upload.FileName);
            string path = ddlCenterMasterdoctype.SelectedValue + Filename + fileExt;

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();

            try
            {

                StringBuilder sb = new StringBuilder();

                int Count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM Center_document WHERE CenterID=@CenterID AND Path=@Path",
                    new MySqlParameter("@CenterID", centerid),
                    new MySqlParameter("@Path", path)));
                if (Count > 0)
                {
                    sb.Append(" UPDATE Center_document SET Path=@Path WHERE CenterID=@CenterID AND Path=@Path");
                }
                else
                {
                    sb.Append(" INSERT INTO Center_document (DocumentName,CenterID,Path,CreatedID,CreatedBy,CreatedDate,IsActive) VALUES ");
                    sb.Append(" (@DocumentName,@CenterID,@Path,@CreatedBy,@CreatedBy,now(),'1') ");
                }
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Path", path),
                    new MySqlParameter("@CenterID", centerid),
                    new MySqlParameter("@DocumentName", ddlCenterMasterdoctype.SelectedItem.Text),
                    new MySqlParameter("@CreatedID", UserInfo.ID),
                    new MySqlParameter("@CreatedBy", UserInfo.LoginName));
               
                //if (System.IO.File.Exists(RootDir + @"\" + filename))
                //{
                //    System.IO.File.Delete(RootDir + @"\" + filename);
                //}
                fu_Upload.SaveAs(RootDir + @"\" + path);
                lblMsg.Text = "File Saved..!";
                bindAttachment();
            }
            catch (Exception ex)
            {
                lblMsg.Text = ex.InnerException.ToString();

            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            if (ddldoctype.SelectedValue == "0")
            {
                lblMsg.Text = "Please Select Doc Type";
                return;
            }

            string Filename = "";
            string ss = "";
            if (labno == "")
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


            if (Filename == "")
                return;

            string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\UploadedDocument");

            if (!Directory.Exists(RootDir))
                Directory.CreateDirectory(RootDir);

            RootDir = RootDir + @"\" + DateTime.Now.ToString("yyyyMMdd");
            if (!Directory.Exists(RootDir))
                Directory.CreateDirectory(RootDir);

            string fileExt = System.IO.Path.GetExtension(fu_Upload.FileName);
            string FileName = Filename + fileExt;
            string PatientID = "";
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                StringBuilder sb = new StringBuilder();
                if (labno == "")
                {
                    sb.Append(" INSERT INTO  document_detail (documentid,documentname,labno,patientid,CreatedByID,CreatedDate,filename,isactive,isdefault,FromPUPPortal) VALUES ");
                    sb.Append(" ('0',@DocumentName,@labno,'',@CreatedID,now(),@FileName ,'1','1',@FromPUPPortal) ");
                }
                else
                {
                    PatientID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select Patient_Id from f_ledgertransaction where LedgerTransactionNo=@Labno",
                         new MySqlParameter("@Labno", labno)));
                    sb.Append(" INSERT INTO  document_detail (documentid,documentname,labno,patientid,CreatedByID,CreatedDate,filename,isactive,isdefault,FromPUPPortal) VALUES ");
                    sb.Append(" ('0',@DocumentName,@labno1,@PatientID,@CreatedID,now(),@FileName ,'1','1',@FromPUPPortal) ");


                }
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@labno", Util.GetString(Request.QueryString["Filename"])),
                     new MySqlParameter("@labno1", labno),
                      new MySqlParameter("@PatientID", PatientID),
                    new MySqlParameter("@FileName", FileName),
                    new MySqlParameter("@DocumentName", ddldoctype.SelectedItem.Text),
                     new MySqlParameter("@FromPUPPortal", FromPUPPortal),
                    new MySqlParameter("@CreatedID", UserInfo.ID));
                if (labno != "")
                {
                    //MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update f_ledgertransaction set AttachedFileName=@AttachedFileName where LedgerTransactionNo=@LedgerTransactionNo ",
                    //    new MySqlParameter("@AttachedFileName", ss),
                    //    new MySqlParameter("@LedgerTransactionNo", labno));

                }
                fu_Upload.SaveAs(RootDir + @"\" + FileName);
                lblMsg.Text = "File Saved..!";
                bindAttachment();
            }
            catch (Exception ex)
            {
                lblMsg.Text = ex.Message.ToString();

            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }



    }
    protected void grvAttachment_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Remove")
        {
            GridViewRow gvr = ((Control)e.CommandSource).Parent.Parent as GridViewRow;
            Label lblPath = (Label)gvr.FindControl("lblPath");
            string RootDir = "";
            if (pagename == "Centermaster")
            {
                Label CenterID = (Label)gvr.FindControl("CenterID");
                RootDir = Server.MapPath("~/Design/Master/DocumentImage/" + CenterID.Text + "/");
            }
          else
                RootDir = Server.MapPath("~/Uploaded Document");
            if (File.Exists(RootDir + lblPath.Text))
            {
                File.Delete(RootDir + lblPath.Text);
            }
             if (pagename == "Centermaster")
                StockReports.ExecuteDML("delete from Center_document where DocumentID='" + e.CommandArgument.ToString() + "'");
            else
            StockReports.ExecuteDML("delete from document_detail where id='" + e.CommandArgument.ToString() + "'");
        }
        bindAttachment();
    }
}
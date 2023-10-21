using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_Support_AnswerTicket : System.Web.UI.Page
{
    public DataTable dt;
    public DataTable Reply;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int IsNotClosed = 0;
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
               
                getQuestion(con);
                getReply(con);
                BindQueries(con);
                BindRoles(con);
                BindSelectedRoles(con);


                ChangeReadStatus(con);


                IsNotClosed = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM support_error_record WHERE Id=@Id AND Employee_Id=@Employee_Id AND STATUS<>'Closed'",
                   new MySqlParameter("@Id", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+"))),
                   new MySqlParameter("@Employee_Id", UserInfo.ID)));
                if ((Util.GetString(Session["IsPanel"]) == "Yes") || (IsNotClosed == 1))
                {
                    btnClose.Visible = true;
                    if (Util.GetString(dt.Rows[0]["Status"]) == "Closed")
                    {
                        NotForPcc.Visible = false;
                    }
                }
            }
            catch (Exception Ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(Ex);
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
            if (Util.GetString(dt.Rows[0]["Status"]) == "Closed")
            {
                NotForPcc.Visible = false;
            }

            if (Util.GetString(Session["RoleId"]) == "198" || Util.GetString(Session["RoleId"]) == "202" || Util.GetString(Session["RoleId"]) == "211" || Util.GetString(Session["RoleId"]) == "212")
            {
                //btnForward.Visible = true;
            }
            btnResolved.Visible = true;
            if ((Util.GetString(dt.Rows[0]["Status"]) == "Resolved") || (Util.GetString(dt.Rows[0]["Status"]) == "Closed"))
            {
                btnResolved.Visible = false;
            }
        }
    }

    private void ChangeReadStatus(MySqlConnection con)
    {
        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, " Update support_error_reply SET IsOpen=1 WHERE TicketId=@TicketId",
           new MySqlParameter("@TicketId", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+"))));
    }

    private void BindSelectedRoles(MySqlConnection con)
    {
        using (DataTable roles = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT `TicketId`,`RoleId` FROM `support_roleticket` WHERE `TicketId`=@TicketId",
              new MySqlParameter("@TicketId", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+")))).Tables[0])
        {
            string str = string.Empty;
            foreach (DataRow dr in roles.Rows)
            {
                if (str == "")
                {
                    str += Util.GetString(dr["RoleId"]);
                }
                else
                {
                    str += "," + Util.GetString(dr["RoleId"]);
                }
            }

            string[] SelecetedRoles = str.Split(',');
            for (int i = 0; i < SelecetedRoles.Length; i++)
            {
                foreach (ListItem li in ddlRoles.Items)
                {
                    if (li.Value == SelecetedRoles[i])
                    {
                        li.Selected = true;
                    }
                }
            }
        }
    }

    private void BindRoles(MySqlConnection con)
    {
        using (DataTable dtRoles = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,RoleName FROM f_rolemaster WHERE active=1 ORDER BY RoleName").Tables[0])
        {
            ddlRoles.DataSource = dtRoles;
            ddlRoles.DataTextField = "RoleName";
            ddlRoles.DataValueField = "ID";
            ddlRoles.DataBind();
        }
    }

    private void BindQueries(MySqlConnection con)
    {
        using (DataTable Queries = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT `Id`,`Type`,`Subject`,LEFT(`Detail` , 100)Detail FROM `support_queryresponse` WHERE `Type`='Response'").Tables[0])
        {
            ddlQueries.DataSource = Queries;
            ddlQueries.DataTextField = "Detail";
            ddlQueries.DataValueField = "Id";
            ddlQueries.DataBind();
            ddlQueries.Items.Insert(0, new ListItem("Select Response", ""));
        }
    }

    private void getReply(MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ");
        sb.Append(" IFNULL(fpm.`Panel_ID`,'')Panel_ID,");
        sb.Append(" IF(IFNULL(su.`FileId`,'')<>'',GROUP_CONCAT(IFNULL(su.`FileId`,'')),'')  FileId,");
        sb.Append(" IF(IFNULL(su.`FileName`,'')<>'',GROUP_CONCAT(IFNULL(su.`FileName`,'')),'') FileName,");
        sb.Append(" IF(IFNULL(su.`FilePath`,'')<>'',GROUP_CONCAT(IFNULL(su.`FilePath`,'')),'') FilePath, ");
        sb.Append(" ser.`Answer`,");
        sb.Append(" ser.`Employee_ID`,");
        sb.Append(" ser.`EmpName`,");
        sb.Append(" DATE_FORMAT(ser.`dtEntry`, '%d %b %Y %h:%i %p') dtEntry ,IFNULL(fpm.`Panel_ID`,'')Panel_ID");
        sb.Append(" FROM");
        sb.Append("`support_error_reply` ser");
        sb.Append(" LEFT JOIN f_panel_master fpm ON ser.`Employee_ID`=fpm.`Employee_ID`");
        sb.Append(" LEFT JOIN `support_uploadedfile` su ON ser.`id`=su.`ReplyId`");
        sb.Append(" WHERE ser.`TicketId` = @TicketId GROUP BY ser.`id`");
        sb.Append(" ORDER BY ser.`dtEntry` ");
        Reply = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
       new MySqlParameter("@TicketId", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+")))).Tables[0];
    }

    private void getQuestion(MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT('PIM',s.`ID`)IssueCode,s.`ID`,s.Status,s.Employee_ID `EmpId`,s.`EmpName`,s.`SiteId`,s.`Subject`,IFNULL(td.Message,'')Message,s.`VialId`,s.`RegNo`,DATE_FORMAT(s.`dtAdd`,'%d %b %Y %h:%i %p')dtAdd,IFNULL(fp.`Panel_Code`,'')Panel_Code");
        sb.Append(" FROM `support_error_record` s INNER JOIN support_error_textDetails td ON s.ID=td.TicketID");
        sb.Append(" LEFT JOIN `f_panel_master` fp ON s.`PanelId`=fp.`Panel_ID` WHERE s.`ID`=@TicketId");

        dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@TicketId", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+")))).Tables[0];
        if (Util.GetString(dt.Rows[0]["Status"]) == "Resolved")
        {
            btnResolved.Visible = false;
        }
    }

    protected void btnForward_Click(object sender, EventArgs e)
    {
        ForForward.Visible = true;
        NotForForward.Visible = false;
        btnForward.Visible = false;
    }

    protected void btnCancelForward_Click(object sender, EventArgs e)
    {
        ForForward.Visible = false;
        NotForForward.Visible = true;
        btnForward.Visible = true;
    }

    protected void btnSaveForward_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        if (hdnRoles.Value == "")
        {
            lblError.Text = "Select Atleast one role";
            return;
        }
        string[] SelectedRoles = (hdnRoles.Value).Split(',');
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM support_roleticket WHERE TicketId=@TicketId",
                       new MySqlParameter("@TicketId", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+"))));
            for (int i = 0; i < SelectedRoles.Length; i++)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO `support_roleticket`(`TicketId`,`RoleId`) VALUES(@TicketId,@RoleId)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@RoleId", SelectedRoles[i]),
                    new MySqlParameter("@TicketId", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+"))));
            }
            tnx.Commit();
            BindSelectedRoles(con);
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        lblError.Text = "";
    }
    protected void btnResolved_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO `support_error_reply`(`Answer`,`Employee_Id`,`EmpName`,`dtEntry`,`TicketId`)");
            sb.Append(" VALUES(@Answer,@EmpId,@EmpName,@dtEntry,@TicketId)");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text,
                sb.ToString(),
                new MySqlParameter("@Answer", ((txtRply.Text == "") ? "Issue has been resolved" : txtRply.Text)),
                new MySqlParameter("@EmpId", Util.GetString(Session["ID"])),
                new MySqlParameter("@EmpName", Util.GetString(Session["LoginName"])),
                new MySqlParameter("@dtEntry", DateTime.Now),
                new MySqlParameter("@TicketId", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+"))));
            string ReplyId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT @@identity"));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text,
                "UPDATE `support_error_record` SET `Status`='Resolved',`StatusId`=6,Updatedate=NOW(),UpdateID=@UpdateID,UpdateName=@UpdateName WHERE `ID`=@Id",
                new MySqlParameter("@Id", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+"))),
                new MySqlParameter("@UpdateID", UserInfo.ID),
                new MySqlParameter("@UpdateName", UserInfo.LoginName));
            if (fu_file.HasFile)
                UploadFile(tnx, ReplyId);
            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        Response.Redirect("AnswerTicket.aspx?TicketId=" + Request.QueryString["TicketId"]);
    }

    protected void btnClose_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("INSERT INTO `support_error_reply`(`Answer`,`Employee_Id`,`EmpName`,`dtEntry`,`TicketId`)");
            sb.Append(" VALUES(@Answer,@EmpId,@EmpName,@dtEntry,@TicketId)");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
            new MySqlParameter("@Answer", ((txtRply.Text == "") ? "Issue has been closed" : txtRply.Text)),
            new MySqlParameter("@EmpId", Util.GetString(Session["ID"])),
            new MySqlParameter("@EmpName", Util.GetString(Session["LoginName"])),
            new MySqlParameter("@dtEntry", DateTime.Now),

            new MySqlParameter("@TicketId", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+"))));
            string ReplyId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT @@identity"));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text,
               "UPDATE `support_error_record` SET `Status`='Closed',`StatusId`=6,Updatedate=NOW(),UpdateID=@UpdateID,UpdateName=@UpdateName WHERE `ID`=@Id",
               new MySqlParameter("@Id", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+"))),
               new MySqlParameter("@UpdateID", UserInfo.ID),
               new MySqlParameter("@UpdateName", UserInfo.LoginName));
            if (fu_file.HasFile)
                UploadFile(tnx, ReplyId);
            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        Response.Redirect("AnswerTicket.aspx?TicketId=" + Request.QueryString["TicketId"]);
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string AppendQuery = string.Empty;
        if (txtRply.Text == string.Empty)
        {
            lblError.Text = "Please Enter Reply";
            txtRply.Focus();
            return;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO `support_error_reply`(`Answer`,`Employee_Id`,`EmpName`,`dtEntry`,`TicketId`)");
            sb.Append(" VALUES(@Answer,@EmpId,@EmpName,@dtEntry,@TicketId)");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Answer", txtRply.Text),
                new MySqlParameter("@EmpId", Util.GetString(Session["ID"])),
                new MySqlParameter("@EmpName", Util.GetString(Session["LoginName"])),
                new MySqlParameter("@dtEntry", DateTime.Now),
                new MySqlParameter("@TicketId", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+"))));
            string ReplyId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT @@identity"));
            string UserId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT `Employee_Id` FROM `support_error_record` WHERE `ID`=@ID",
                new MySqlParameter("@ID", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+")))));


            string CurrentStatus = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Status FROM support_error_record WHERE ID=@ID",
                new MySqlParameter("@Id", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+")))));

            sb = new StringBuilder();
            sb.Append("UPDATE `support_error_record` SET `Status`=@Status,`StatusId`=@StatusId,UpdateDate=NOW(),UpdateID=@UpdateID,UpdateName=@UpdateName");
            if (Util.GetString(CurrentStatus) == "Closed")
                sb.Append(" , ReopenDate=NOW()");
            sb.Append(" WHERE `ID`=@Id ");

            string Status = string.Empty;
            int statusID = 0;

            if (Util.GetString(Session["IsPanel"]) == "Yes")
            {
                Status = "PCC Reply";
                statusID = 3;
            }
            else if (Util.GetString(Session["RoleID"]) == "198" || Util.GetString(Session["RoleID"]) == "202")
            {
                Status = "Support Reply";
                statusID = 2;
            }
            else
            {
                Status = "Department Reply";
                statusID = 4;
            }

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Id", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+"))),
                    new MySqlParameter("@Status", Status),
                    new MySqlParameter("@StatusId", statusID),
                    new MySqlParameter("@UpdateID", UserInfo.ID),
                    new MySqlParameter("@UpdateName", UserInfo.LoginName));
            if (fu_file.HasFile)
                UploadFile(tnx, ReplyId);

            tnx.Commit();
            lblError.Text = string.Empty;
            getQuestion(con);
            getReply(con);
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void UploadFile(MySqlTransaction tnx, string ReplyId)
    {
        

        
        if (fu_file.HasFile)
        {
            string path = string.Concat(Resources.Resource.DocumentPath, "\\SupportFiles");
            if (!Directory.Exists(path))
                Directory.CreateDirectory(path);

            path = string.Format(@"{0}\{1:yyyyMMdd}", path, DateTime.Now);
            if (!Directory.Exists(path))
                Directory.CreateDirectory(path);

            string fileName = Path.GetFileNameWithoutExtension(fu_file.PostedFile.FileName);
            string ext = Path.GetExtension(Path.GetFileName(fu_file.PostedFile.FileName));
            
            string Filename = string.Concat(fileName, ReplyId, "_", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+")));
            string ComFileName = Filename + ext;

           

            fu_file.SaveAs(string.Format(@"{0}\{1}", path, ComFileName));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO `support_uploadedfile`(`FileName`,`FilePath`,`TicketId`,`ReplyId`,`dtEntry`,FileExt) VALUES(@FileName,@FilePath,@TicketId,@ReplyId,NOW(),@FileExt)",
                new MySqlParameter("@FileName", fileName),
                new MySqlParameter("@FilePath", ComFileName),
                new MySqlParameter("@TicketId", Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+"))),
                new MySqlParameter("@ReplyId", ReplyId),
                new MySqlParameter("@FileExt", ext));
        }
    }
}
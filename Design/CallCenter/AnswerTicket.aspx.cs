using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_CallCenter_AnswerTicket : System.Web.UI.Page
{



    protected void Page_Load(object sender, EventArgs e)
    {
        string cmd = Util.GetString(Request.QueryString["cmd"]);
        string rtrn = string.Empty;

        if (cmd == "GetEmpList")
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(GetEmpList());
            Response.Clear();
            Response.ContentType = "application/json; charset=utf-8";
            Response.Write(rtrn);
            Response.End();

            return;
        }
        lblTicketID.Text = Request.QueryString["TicketId"].ToString();
        lblEncryptTicketID.Text = Common.Encrypt(Request.QueryString["TicketId"].ToString());
        lblDisplayTicketID.Text = string.Concat("Ticket No. : ", " ", lblTicketID.Text);
        calResolveDate.StartDate = DateTime.Now;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            UpdateIsRead(Request.QueryString["TicketId"].ToString(), "1", tnx);

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
    }
    [WebMethod]
    public static string GetReply(int TicketId)
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append("SELECT ");
        //sb.Append(" (SELECT IFNULL(su.`FileId`,'') FROM support_uploadedfile su WHERE su.replyid=ser.`id` ORDER BY replyid ASC LIMIT 1)FileId, ");        
        //sb.Append(" (SELECT IFNULL(su.`FileName`,'') FROM support_uploadedfile su WHERE su.replyid=ser.`id`)FileName, ");
        //        sb.Append(" (SELECT IFNULL(CONCAT('/',DATE_FORMAT(dtEntry,'%Y%m%d'),'/',filename),'') FROM support_uploadedfile su WHERE su.replyid=ser.`id`)FilePath, ");
        //      sb.Append(" (SELECT IFNULL(CONCAT(CONCAT('/',DATE_FORMAT(dtEntry,'%Y%m%d'),'/',filename),'',FileExt),'') FROM support_uploadedfile su WHERE su.replyid=ser.`id`)FileUrl, ");

        //sb.Append(" (SELECT IFNULL(CONCAT(su.`FileName`,'',FileExt),'') FROM support_uploadedfile su WHERE su.replyid=ser.`id`  order by replyid asc limit 1)FileName, ");
        //sb.Append(" (SELECT IFNULL(CONCAT(CONCAT('/',DATE_FORMAT(dtEntry,'%Y%m%d'),'/',filename),'',FileExt),'') FROM support_uploadedfile su WHERE su.replyid=ser.`id` order by replyid asc limit 1)FilePath, ");
        //sb.Append(" (SELECT IFNULL(CONCAT(CONCAT('/',DATE_FORMAT(dtEntry,'%Y%m%d'),'/',filename),'',FileExt),'') FROM support_uploadedfile su WHERE su.replyid=ser.`id` order by replyid asc limit 1)FileUrl, ");

        //sb.Append(" ser.`Answer`,ser.`EmpId`,ser.`EmpName`,");       
        //sb.Append(" DATE_FORMAT(ser.`dtEntry`, '%d %b %Y %h:%i %p') dtEntry, ");
        //sb.Append(" DATE_FORMAT(ser.`dtEntry`, '%d %b %Y') ReplyDate, ");
        //sb.Append(" DATE_FORMAT(ser.`dtEntry`, '%h:%i %p') ReplyTime ");
        //sb.Append(" FROM");
        //sb.Append(" `support_error_reply` ser");

        //sb.Append(" WHERE ser.`TicketId` = @TicketId");
        //sb.Append(" ORDER BY ser.`dtEntry` ");        
        sb.Append(" SELECT   ");
        sb.Append(" ser.`Answer`,ser.`EmpId`,ser.`EmpName`, DATE_FORMAT(ser.`dtEntry`, '%d %b %Y %h:%i %p') dtEntry,' 'TATTime, ");
        sb.Append(" DATE_FORMAT(ser.`dtEntry`, '%d %b %Y') ReplyDate,  DATE_FORMAT(ser.`dtEntry`, '%h:%i %p') ReplyTime ,");
        sb.Append(" IFNULL((SELECT GROUP_CONCAT(CONCAT (IFNULL(CONCAT(su.`FileName`,'',FileExt),''),'#',IFNULL(CONCAT(CONCAT('/',DATE_FORMAT(dtEntry,'%Y%m%d'),'/',filename),'',FileExt),''))) FROM support_uploadedfile su WHERE su.ReplyID=ser.`Id`  ORDER BY replyid ASC ),'') Files ");
        sb.Append(" FROM `support_error_reply` ser WHERE ser.`TicketId` = '" + TicketId + "' ORDER BY ser.`dtEntry`");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (i > 0)
                {
                    DateTime dtFromDate = Convert.ToDateTime(dt.Rows[i - 1]["dtEntry"].ToString());
                    DateTime dtToDate = Convert.ToDateTime(dt.Rows[i]["dtEntry"].ToString());
                    TimeSpan diff = (dtToDate - dtFromDate);
                    dt.Rows[i]["TATTime"] = String.Format("{0} days {1} hr {2} min", diff.Days, diff.Hours, diff.Minutes); 
                }
            }
           
        }
        return Util.getJson(dt);
    }


    [WebMethod]
    public static string GetQueryDescription(string QueryId)
    {
        return Util.getJson(StockReports.GetDataTable("SELECT `Detail` FROM `inquiry_master` WHERE `Id`='" + QueryId + "'"));

    }

    [WebMethod]
    public static string GetIssueList(string TicketId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT cic.`Lavel`,cic.`EmployeeID`,DATE_FORMAT(s.`dtAdd`,'%d %b %Y %h:%i %p')dtAdd,DATE_FORMAT(s.`dtAdd`,'%H:%i')dtAddTime, ");
        sb.Append(" DATE_FORMAT(s.`dtAdd`,'%d %m %Y %h:%i %p')dtAdd1,CONCAT('PIM',s.`ID`)IssueCode,s.`ID`,s.Status,s.`EmpId`,s.`EmpName`,s.`Subject`,s.Message, ");
        sb.Append(" s.`VialId`,s.`RegNo`,DATE_FORMAT(s.`dtAdd`,'%d %b %Y %h:%i %p')dtAdd,IFNULL(cm.`CentreCode`,'')Panel_Code ");
        sb.Append(" FROM `support_error_record` s");
        sb.Append(" INNER JOIN `customercare_inquery_categoryEmployee` cic ON s.`CentreID`=cic.`CentreID` AND cic.`EmployeeID`='" + UserInfo.ID + "' AND  s.`CentreId`='" + UserInfo.Centre + "'  ");
        sb.Append(" INNER JOIN `centre_master` cm ON cm.`centreID`=s.`centreID` WHERE s.`ID`='" + TicketId + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataTable tbl = new DataTable();

        dt.Columns.Add(new DataColumn("Name", typeof(string)));
        dt.Columns.Add(new DataColumn("Lavel1Time", typeof(Int32)));
        dt.Columns.Add(new DataColumn("Lavel2Time", typeof(Int32)));
        dt.Columns.Add(new DataColumn("Lavel3Time", typeof(Int32)));

        StringBuilder sb1 = new StringBuilder();
        sb1.Append(" SELECT cit.Name,cit.Lavel1Time,cit.Lavel2Time,cit.Lavel3Time FROM `customercare_inquery_categoryemployee` cic ");
        sb1.Append(" INNER JOIN `customercare_inquery_categorytat` cit ON cic.Inq_SubCategoryID=cit.SubCategoryID ");
        sb1.Append(" WHERE cic.CentreID='" + UserInfo.Centre + "' AND cit.Name='Response TAT' ");
        sb1.Append(" GROUP BY cit.ID ");
        DataTable dt1 = StockReports.GetDataTable(sb1.ToString());
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            dt.Rows[i]["Name"] = dt1.Rows[0]["Name"];
            dt.Rows[i]["Lavel1Time"] = dt1.Rows[0]["Lavel1Time"];
            dt.Rows[i]["Lavel2Time"] = dt1.Rows[0]["Lavel2Time"];
            dt.Rows[i]["Lavel3Time"] = dt1.Rows[0]["Lavel3Time"];
        }
        return Util.getJson(dt);
    }
    [WebMethod]
    private DataTable GetEmpList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Employee_ID as value,CONCAT(House_No,'~', CONCAT(Title,' ', NAME)) AS label,Email FROM `employee_master` em ");
        sb.Append("  LEFT JOIN support_error_access ea ON em.Employee_ID=ea.EmployeeID AND ea.TicketID='" + Request.QueryString["TicketID"].ToString() + "' ");
        sb.Append(" WHERE IsActive=1 AND Employee_ID !='" + UserInfo.ID + "' AND NAME LIKE '" + Request.QueryString["EmpName"].ToString() + "%' AND ea.ID IS NULL ");
        return StockReports.GetDataTable(sb.ToString());
    }

    [WebMethod]
    public static string saveAnswerTicket(object Ticket)
    {
        List<AnswerTicket> answerTicket = new JavaScriptSerializer().ConvertToType<List<AnswerTicket>>(Ticket);
        if (answerTicket[0].resolveDateTime != "")
        {
            DateTime resolvedt = DateTime.Parse(answerTicket[0].resolveDateTime);
            DateTime currentdt = DateTime.Now;

            TimeSpan resolveTime = resolvedt.TimeOfDay;
            TimeSpan currentTime = currentdt.TimeOfDay;
            if (resolvedt.Date == currentdt.Date)
            {
                if (resolveTime < currentTime)
                {
                    return "2";
                }
            }

            if (resolvedt.Date < currentdt.Date)
            {
                return "3";
            }
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {


            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO `support_error_reply`(`Answer`,`EmpId`,`EmpName`,`dtEntry`,`TicketId`,TicketStatus,TicketStatusID,AssignID,ReopenReason,RootcauseID,ExpectedResolveDateTime)");
            sb.Append(" VALUES(@Answer,@EmpId,@EmpName,@dtEntry,@TicketId,@TicketStatus,@TicketStatusID,@AssignID,@ReopenReason,@RootCause,@ExpectedResolveDateTime)");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),

                new MySqlParameter("@Answer", answerTicket[0].Reply), new MySqlParameter("@EmpId", Util.GetString(UserInfo.ID)),
                new MySqlParameter("@EmpName", Util.GetString(UserInfo.LoginName)),
                new MySqlParameter("@dtEntry", DateTime.Now), new MySqlParameter("@TicketStatus", answerTicket[0].Status), new MySqlParameter("@TicketStatusID", answerTicket[0].StatusID),
                new MySqlParameter("@AssignID", answerTicket[0].EmpID),
                new MySqlParameter("@TicketId", Util.GetString(answerTicket[0].TicketID)), new MySqlParameter("@RootCause", Util.GetString(answerTicket[0].Rootcause)),
                new MySqlParameter("@ReopenReason", Util.GetString(answerTicket[0].ReopenReason)), new MySqlParameter("@ExpectedResolveDateTime", Util.GetDateTime(answerTicket[0].resolveDateTime).ToString("yyyy-MM-dd HH:mm:ss"))
                 );

            int ReplyID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT max(ID) FROM support_error_reply"));
            string Rootcause = string.Empty;
            string resolveDateTime = null;
            string ResolvedBy = "0";
            if (answerTicket[0].StatusID == 4)
            {
                Rootcause = answerTicket[0].Rootcause;
                resolveDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                ResolvedBy = Util.GetString(UserInfo.ID);
            }
            else
            {
                resolveDateTime = "0001-01-01 00:00:00";
                ResolvedBy = "0";
            }

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text,
                               "UPDATE `support_error_record` SET ResolvedBy=@ResolvedBy, `Status`=@Status,`StatusId`=@StatusId,UpdateDate=NOW(),UpdateID=@UpdateID,UpdateName=@UpdateName,AssignID=@AssignID,RootCauseID=@RootCause,resolveDateTime=@resolveDateTime WHERE `ID`=@Id",
                               new MySqlParameter("@ResolvedBy", ResolvedBy), new MySqlParameter("@Status", answerTicket[0].Status), new MySqlParameter("@StatusId", answerTicket[0].StatusID),
                               new MySqlParameter("@UpdateID", Util.GetString(UserInfo.ID)), new MySqlParameter("@UpdateName", Util.GetString(UserInfo.LoginName)),
                               new MySqlParameter("@AssignID", answerTicket[0].EmpID), new MySqlParameter("@RootCause", answerTicket[0].Rootcause),
                                new MySqlParameter("@resolveDateTime", resolveDateTime),
                               new MySqlParameter("@Id", Util.GetString(answerTicket[0].TicketID)));



            if (answerTicket[0].AttachedFileName != string.Empty)
            {
                int filecount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM support_uploadedfile WHERE  TempID=@TempID ",
                    new MySqlParameter("@TempID", answerTicket[0].AttachedFileName)));

                if (filecount > 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE support_uploadedfile SET ReplyID=@ReplyID WHERE TempID=@TempID",
                        new MySqlParameter("@ReplyID", ReplyID),
                        new MySqlParameter("@TempID", answerTicket[0].AttachedFileName));
                }
            }
            if (answerTicket[0].EmpID != 0)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO support_error_Access(TicketID,AccessDateTime,EmployeeID)VALUES(@TicketID,@AccessDateTime,@EmployeeID)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@TicketID", answerTicket[0].TicketID), new MySqlParameter("@AccessDateTime", DateTime.Now),
                   new MySqlParameter("@EmployeeID", answerTicket[0].EmpID));

 Notification.notificationInsert(2, Util.GetString(answerTicket[0].TicketID), tnx, 0, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), answerTicket[0].EmpID, "Ticket Reply");
                //mail code start
                if (answerTicket[0].IsEmail == "0")
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE employee_master SET email=@Email where Employee_ID=@EmployeeID");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@Email", answerTicket[0].EmailID),
                       new MySqlParameter("@EmployeeID", answerTicket[0].EmpID));
                }
                var toAddress = new string[] { answerTicket[0].EmailID };
                var ccAddress = string.IsNullOrEmpty(answerTicket[0].OtherEmailID) ? new string[] { } : answerTicket[0].OtherEmailID.Split(',');// new string[] { answerTicket[0].OtherEmailID };
                var bccAddress = new string[] { };
                string Subject = answerTicket[0].Subject;
                string Message = Design_CallCenter_AnswerTicket.GetMailBody(answerTicket);
                string TicketID = Util.GetString(answerTicket[0].TicketID);

                SendNewTicketMail(toAddress, Subject, Message, ccAddress, bccAddress, TicketID);
                //mail code End
            }


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE support_error_Access SET IsRead=0 WHERE TicketID=@TicketID AND EmployeeID !=@EmployeeID",
                  new MySqlParameter("@TicketID", answerTicket[0].TicketID),
                  new MySqlParameter("@EmployeeID", UserInfo.ID));
            int CreatedTicketID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT EmpID FROM support_error_record WHERE ID=" + answerTicket[0].TicketID + ""));
            Notification.notificationInsert(2, Util.GetString(answerTicket[0].TicketID), tnx, 0, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), CreatedTicketID, "Ticket Reply");

            UpdateIsRead(Util.GetString(answerTicket[0].TicketID), "1", tnx);
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public static void SendNewTicketMail(string[] toAddress, string Subject, string Message, string[] ccAddress, string[] bccAddress, string TiketId)
    {
        int columnIndex = 0; //single-column DataTable

        ReportEmailClass mail = new ReportEmailClass();
        DataTable dt = StockReports.GetDataTable("SELECT CONCAT(CONCAT('/',DATE_FORMAT(dtEntry,'%Y%m%d'),'/',filename,'',FileExt)) fileUrl FROM support_uploadedfile WHERE TicketId='" + TiketId + "'");
        string[] Attachment = new string[dt.Rows.Count];
        string RootDir = System.Web.HttpContext.Current.Server.MapPath("~/CallCenterDocument");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            Attachment[i] = RootDir + @"\" + dt.Rows[i][columnIndex].ToString();
        }
        mail.sendCustomerCareEmail(toAddress, Subject, Message, ccAddress, bccAddress, Attachment, TiketId);


    }

    public class AnswerTicket
    {
        public string Reply { get; set; }
        public string Status { get; set; }
        public int StatusID { get; set; }
        public int TicketID { get; set; }
        public string AttachedFileName { get; set; }
        public int EmpID { get; set; }
        public string Rootcause { get; set; }
        public string ReopenReason { get; set; }
        public string resolveDateTime { get; set; }

        //email start prop
        public string EmailID { get; set; }
        public string IsEmail { get; set; }
        public string OtherEmailID { get; set; }
        public string Subject { get; set; }
        public string empCode { get; set; }
        public string empName { get; set; }
        public string empEmail { get; set; }
        public string empMobile { get; set; }
        public string empGroup { get; set; }
        public string empClientCode { get; set; }
        public string empSubject { get; set; }
        public string CreatedDate { get; set; }
        public string Message { get; set; }
        //email end prop
    }
    [WebMethod]
    public static string ResponseDetail(int ResponseID)
    {
        return MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text, "SELECT Detail FROM inquiry_master WHERE IsActive=1 AND Type='Response' AND Id=@ID",
            new MySqlParameter("@ID", Util.GetString(ResponseID))).ToString();
    }
    [WebMethod]
    public static string getHeader(int TicketId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CONCAT('PIM',s.`ID`)IssueCode,s.`ID`,s.Status,emp.House_No,s.`EmpId`,s.`EmpName`,s.`Subject`,dtl.Message,s.`VialId`,s.`RegNo`, ");
        sb.Append(" DATE_FORMAT(s.`dtAdd`,'%d %b %Y %h:%i %p')dtAdd,IFNULL(cm.`CentreCode`,'')Panel_Code,s.DepartmentID,s.GroupID,s.CategoryID,s.SubcategoryID,emp.ReopenTicket");
        sb.Append("  , cdm.DepartmentName,cgm.GroupName,emp.Email,emp.Mobile FROM `support_error_record` s");
        sb.Append(" INNER JOIN `support_error_textdetails` dtl on dtl.TicketID=s.ID ");
        sb.Append(" INNER JOIN `employee_master` emp on emp.Employee_ID=s.EmpId ");
        sb.Append(" INNER JOIN `CutomerCare_Group_Master` cgm on cgm.GroupID=s.GroupID ");
        sb.Append(" INNER JOIN `centre_master` cm ON cm.`centreID`=s.`centreID`  ");
        sb.Append(" LEFT JOIN `cutomercare_department_master` cdm on cdm.DepartmentID=s.DepartmentID WHERE s.`ID`='" + TicketId + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Util.getJson(dt);
    }
    [WebMethod]
    public static string bindStatus()
    {
        DataTable supportstatus = StockReports.GetDataTable("SELECT ID,Status FROM support_status_master WHERE isActive=1 ORDER By Priority+0 ");
        return Util.getJson(supportstatus);
    }
    [WebMethod]
    public static string BindQueries(int CategoryID, int SubCategoryID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT `Id`,`Type`,`Subject`,LEFT(`Detail` , 100)Detail FROM `inquiry_master` WHERE `Type`='Response' ");
        sb.Append(" AND IsActive=1 AND CategoryID='" + CategoryID + "' AND SubCategoryID='" + SubCategoryID + "' ");
        DataTable Queries = StockReports.GetDataTable(sb.ToString());
        return Util.getJson(Queries);
    }

    [WebMethod]
    public static string bindRootCause()
    {
        DataTable RootCause = StockReports.GetDataTable("SELECT ID,RootCause FROM customercare_rootcause WHERE isActive=1 ORDER By ID ");
        return Util.getJson(RootCause);
    }
    [WebMethod]
    public static string SaveRootCause(string DesignationName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int DesignationID;
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, string.Format("select count(*) from customercare_rootcause where RootCause='{0}'", DesignationName)));
            if (count > 0)
            {
                return "2";
            }
            else
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO customercare_rootcause(RootCause,CreatedBy,CreatedID,CreateDate)");
                sb.Append(" VALUES(@RootCause,@CreatedByID,@CreatedBy,now()) ");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);
                cmd.Parameters.AddWithValue("@RootCause", DesignationName);
                cmd.Parameters.AddWithValue("@CreatedByID", UserInfo.ID);
                cmd.Parameters.AddWithValue("@CreatedBy", UserInfo.UserName);
                cmd.ExecuteNonQuery();
                DesignationID = Convert.ToInt32(cmd.LastInsertedId);
            }
            tnx.Commit();
            return Util.getJson(new { DesignationID = DesignationID, DesignationName = DesignationName });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    public static void UpdateIsRead(string TicketID, string Status, MySqlTransaction tnx)
    {


        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update support_error_access set IsRead=@IsRead where EmployeeID=@EmpID and TicketId=@TicketId",
                new MySqlParameter("@IsRead", Status),
                new MySqlParameter("@TicketId", Util.GetString(TicketID)),
                new MySqlParameter("@EmpID", UserInfo.ID));
 if (Status == "1")
            Notification.updateNotification(Util.GetString(TicketID), Util.GetString(UserInfo.ID), "", 1, tnx, "Ticketing", "");

    }

    public static string GetMailBody(List<AnswerTicket> answerTicket)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT");
        sb.Append(" ser.`Answer`,ser.`EmpId`,ser.`EmpName`, DATE_FORMAT(ser.`dtEntry`, '%d %b %Y %h:%i %p') dtEntry, ");
        sb.Append(" DATE_FORMAT(ser.`dtEntry`, '%d %b %Y') ReplyDate,  DATE_FORMAT(ser.`dtEntry`, '%h:%i %p') ReplyTime ");
        sb.Append(" FROM `support_error_reply` ser WHERE ser.`TicketId` = '" + answerTicket[0].TicketID + "' ORDER BY ser.`dtEntry`");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        int index = 0;
        StringBuilder table = new StringBuilder();
        table.Append("<table border='0' width='1024px'>");
        table.Append("<tr>");
        table.Append(" <td width='124px' style='font-weight: 700'>Ticket No.:</td>");
        table.Append("<td width='233px' colspan='5'>" + answerTicket[0].TicketID + "</td>");
        table.Append("</tr>");
        table.Append("<tr>");
        table.Append("<td width='124px' style='font-weight: 700'>Raised by code:</td>");
        table.Append("<td width='233px'>" + answerTicket[0].empCode + "</td>");
        table.Append("<td width='100px' style='font-weight: 700'>Raised By:</td>");
        table.Append("<td width='233px'>" + answerTicket[0].empName + "</td>");
        table.Append("<td width='100px' style='font-weight: 700'>Email ID:</td>");
        table.Append("<td width='233px'>" + answerTicket[0].empEmail + "</td>");
        table.Append("</tr>");
        table.Append("<tr>");
        table.Append("<td width='124px' style='font-weight: 700'>Mobile No.:</td>");
        table.Append("<td width='233px'>" + answerTicket[0].empMobile + "</td>");
        table.Append("<td width='100px' style='font-weight: 700'>Group:</td>");
        table.Append("<td width='233px'>" + answerTicket[0].empGroup + "</td>");
        table.Append(" <td width='100px' style='font-weight: 700'>Client Code:</td>");
        table.Append("<td width='233px'>" + answerTicket[0].empClientCode + "</td>");
        table.Append("  </tr>");
        table.Append("<tr>");
        table.Append("<td width='124px' style='font-weight: 700'>Subject:</td>");
        table.Append("<td width='233px'>" + answerTicket[0].Subject + "</td>");
        table.Append(" <td width='100px' style='font-weight: 700'>Raised Date: </td>");
        table.Append("<td width='233px'>" + answerTicket[0].CreatedDate + "</td>");
        table.Append(" <td width='100px' style='font-weight: 700'>  Question: </td>");
        table.Append(" <td width='233px'>" + answerTicket[0].Message + "</td>");
        table.Append("</tr>");
        table.Append(" </table>");
        table.Append("<br/>");

        table.Append("<table border='1' width='1024px'>");
        table.Append("<thead><tr><th width='24px'>S.No.</th><th width='250px'>Replyed By</th><th width='150px'>Reply DateTime</th><th width='700px'>Description</th></tr></thead> ");
        table.Append(" <tbody>");
        foreach (DataRow row in dt.Rows)
        {
            table.Append("<tr><td>" + (index + 1) + "</td><td>" + row["EmpName"].ToString() + "</td><td>" + row["ReplyDate"].ToString() + "</td><td>" + row["Answer"].ToString() + "</td></tr>");
            index++;
        }

        table.Append("</tbody> ");
        table.Append("</table>");
        return table.ToString();

    }
}
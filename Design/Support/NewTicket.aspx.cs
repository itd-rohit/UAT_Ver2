using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Support_NewTicket : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
    }

    [WebMethod]
    public static string bindStatus()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            using (DataTable dtCategory = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT CONCAT(ID,'#',ShowClient,'#',ShowRole,'#',ShowCentre,'#',ShowBarcodeNo,'#',ShowLabNo,'#',ShowTestCode,'@',MandatoryClient,'#',MandatoryRole,'#',MandatoryCentre,'#',MandatoryBarcodeNo,'#',MandatoryLabNo,'#',MandatoryTestCode) ID, CategoryName FROM ticketing_category_master where isActive=1 AND roles NOT IN(" + UserInfo.RoleID + ") ORDER BY CategoryName").Tables[0])
            {
                using (DataTable dtStatus = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,STATUS  FROM  support_status_master where isActive=1 ORDER BY Priority+0").Tables[0])
                {
                    sb.Append(" SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,fpm.Panel_ID Panel_ID,cm.Type1ID FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID  ");
                    sb.Append(" WHERE cm.IsActive=1 ");
                    sb.Append("   AND ( cm.CentreID IN (SELECT CentreAccess FROM centre_access WHERE CentreID =@CentreID ) OR cm.CentreID =@CentreID )  ");
                    using (DataTable dtClient = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0])
                    {
                        using (DataTable dtInv = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT concat(TestCode,' - ',Typename) ID,concat(TestCode,' - ',Typename) Typename FROM f_itemmaster   WHERE subcategoryid<>'LSHHI24' and isactive=1   ORDER BY Typename").Tables[0])
                        {
                            return Util.getJson(new { StatusData = dtStatus, ClientData = dtClient, InvData = dtInv, CategoryData = dtCategory });
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string GetUsers(int RoleId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (RoleId > 0)
            {
                sb.Append(" SELECT DISTINCT CONCAT(em.Title,' ',NAME)AS NAME,em.Employee_ID FROM f_login flg INNER JOIN employee_master em ON flg.EmployeeID=em.Employee_ID ");
                sb.Append("  INNER JOIN f_rolemaster fr ON fr.ID=flg.RoleID");
                sb.Append("   WHERE em.IsActive=1 AND flg.Active=1 AND fr.ID=@RoleId ORDER by NAME");
            }
            else
            {
                sb.Append(" SELECT DISTINCT CONCAT(em.Title,' ',NAME)AS NAME,em.Employee_ID FROM f_login flg INNER JOIN employee_master em ON flg.EmployeeID=em.Employee_ID");
                sb.Append(" INNER JOIN f_rolemaster fr ON fr.ID=flg.RoleID");
                sb.Append(" WHERE em.IsActive=1 AND flg.Active=1 ORDER by NAME");
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@RoleId", RoleId)).Tables[0])
                return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    private void Bind_Users(int RoleId, MySqlConnection con)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            if (RoleId > 0)
            {
                sb.Append(" SELECT DISTINCT CONCAT(em.Title,' ',NAME)AS NAME,em.Employee_ID FROM f_login flg INNER JOIN employee_master em ON flg.EmployeeID=em.Employee_ID");
                sb.Append("  INNER JOIN f_rolemaster fr ON fr.ID=flg.RoleID");
                sb.Append("  WHERE em.IsActive=1 AND flg.Active=1 AND fr.ID=@RoleId ORDER by NAME");
            }
            else
            {
                sb.Append(" SELECT DISTINCT CONCAT(em.Title,' ',NAME)AS NAME,em.Employee_ID FROM f_login flg INNER JOIN employee_master em ON flg.EmployeeID=em.Employee_ID");
                sb.Append("  INNER JOIN f_rolemaster fr ON fr.ID=flg.RoleID");
                sb.Append("  WHERE em.IsActive=1 AND flg.Active=1 ORDER by NAME");
            }

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@RoleId", RoleId)).Tables[0])
            {
                ddluser.DataSource = dt;
                ddluser.DataTextField = "Name";
                ddluser.DataValueField = "Employee_ID";
                ddluser.DataBind();
                ddluser.Items.Insert(0, new ListItem("--Select User--", ""));
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private void Bind_Role(MySqlConnection con)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT UPPER(rm.RoleName) RoleName,rm.ID FROM f_login fl INNER JOIN f_rolemaster rm");
            sb.Append(" ON fl.RoleID=rm.ID AND fl.EmployeeID=@EmployeeID AND fl.Active=1 AND fl.RoleID<>@RoleID ");
            sb.Append(" AND rm.Active=1 and fl.CentreID=@CentreID ORDER BY rm.RoleName");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@EmployeeID", UserInfo.ID),
                   new MySqlParameter("@CentreID", UserInfo.Centre),
                   new MySqlParameter("@RoleID", UserInfo.RoleID)).Tables[0])
            {
                ddlrole.DataSource = dt;
                ddlrole.DataTextField = "RoleName";
                ddlrole.DataValueField = "ID";
                ddlrole.DataBind();

                ddlrole.Items.Insert(0, new ListItem("--Select Role--", ""));
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    [WebMethod]
    public static string BindQueries(int CategoryID)
    {
        string str = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            if (CategoryID > 0)
            {
                str = " SELECT Id,Type,Subject,REPLACE(Detail,'\n','') Detail FROM Support_queryresponse WHERE CategoryID=@CategoryID AND  isactive=1 AND Type='Query' Order by Subject asc";
            }
            else
            {
                str = " SELECT Id,Type,Subject,REPLACE(Detail,'\n','') Detail FROM Support_queryresponse WHERE CategoryID=-1 AND isactive=1 AND Type='Query' Order by Subject asc";
            }

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str,
                 new MySqlParameter("@CategoryID", CategoryID)).Tables[0])
                return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string GetImageName()
    {
        string labno = Guid.NewGuid().ToString();
        return labno;
    }

    [WebMethod(EnableSession = true)]
    public static string Save(string CategoryID, string Query, string Subject, string MainHead, string Details, string Client, string Centre, string Barcode, string LabNo, string LabCode, string hfRoleID, string hfCenter, string hfPccId, string hfUserID, string hfinvid, string hdFileID, sbyte IsShowVisitNo, sbyte IsShowBarcodeNumber, string Email)
    {
        bool IsLevel2 = false;
        bool IsLevel3 = false;
        bool IsModify = false;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (IsShowBarcodeNumber == 1 && Barcode != string.Empty)
            {
                int chkBarCode = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM patient_labinvestigation_opd WHERE `BarcodeNo`=@BarcodeNo",
                   new MySqlParameter("@BarcodeN", Barcode)));
                if (chkBarCode > 0)
                    return JsonConvert.SerializeObject(new { status = false, response = "Please Enter Valid Barcode No." });
            }

            if (IsShowVisitNo == 1 && LabNo != string.Empty)
            {
                int chkVisitNo = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM patient_labinvestigation_opd WHERE `LedgerTransactionNo`=@LedgerTransactionNo",
                   new MySqlParameter("@LedgerTransactionNo", LabNo)));
                if (chkVisitNo > 0)
                    return JsonConvert.SerializeObject(new { status = false, response = "Please Enter Valid Visit No." });
            }
            ClsQuery obj = new ClsQuery();
            obj.CategoryID = CategoryID;
            obj.QueryID = Query;
            obj.Subject = Subject;
            obj.MainHead = MainHead;
            obj.Details = Details;
            obj.Client = Util.GetInt(hfPccId);
            obj.BarcodeNumber = Barcode;
            obj.LabNo = LabNo;
            obj.InvestigationID = hfinvid;
            obj.isTATDefine = 1;
            obj.isTagEmployeeDefine = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IF(COUNT(*)>0,1,0) FROM ticketing_categoryemployee WHERE isActive=1 and CategoryID=@CategoryID AND centreID=@centreID",
               new MySqlParameter("@CategoryID", obj.CategoryID),
               new MySqlParameter("@centreID", UserInfo.Centre)));
            obj.OldTicketID = 0;
            obj.isDefaultTagEmployeeDefine = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, " Select count(1) from ticketing_categoryemployee WHERE centreID=0 AND CategoryID=@CategoryID AND isActive=1",
                new MySqlParameter("@CategoryID", obj.CategoryID)));

            StringBuilder sb = new StringBuilder();

            int Level1Time = 0; int Level2Time = 0; int Level3Time = 0;
            string TicketID = string.Empty;
            if (obj.OldTicketID == 0)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO support_error_record(Employee_ID,EmpName,Subject,CentreID,VialId,RegNo,dtAdd,UpdateDate,UpdateID,UpdateName,");
                sb.Append("   ItemID,CategoryId,QueryID,StatusId,SessionRoleID , SessionRoleName , SessionCentreID , SessionCentreName,PanelId,EmailID )");
                sb.Append("    VALUES(@Employee_ID,@EmpName,@Subject,@CentreID,@VialId,@RegNo,@dtAdd,@UpdateDate,@UpdateID,@UpdateName ,");
                sb.Append("    @ItemID,@CategoryId,@QueryID,@StatusId, @SessionRoleID,  @SessionRoleName,  @SessionCentreID,  @SessionCentreName,@PanelID,@EmailID )");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Employee_ID", UserInfo.ID),
                    new MySqlParameter("@EmpName", UserInfo.LoginName),
                    new MySqlParameter("@Subject", Util.GetString(obj.Subject)),
                    new MySqlParameter("@CentreID", UserInfo.Centre),
                    new MySqlParameter("@RegNo", Util.GetString(obj.LabNo)),
                    new MySqlParameter("@VialId", Util.GetString(obj.BarcodeNumber)),
                    new MySqlParameter("@dtAdd", DateTime.Now),
                    new MySqlParameter("@StatusId", "1"),
                    new MySqlParameter("@ItemID", Util.GetString(obj.InvestigationID)),
                    new MySqlParameter("@CategoryId", Util.GetInt(obj.CategoryID)),
                    new MySqlParameter("@QueryID", Util.GetInt(obj.QueryID)),

                    new MySqlParameter("@SessionRoleID", UserInfo.RoleID),
                    new MySqlParameter("@SessionRoleName", UserInfo.LoginType),
                    new MySqlParameter("@SessionCentreID", UserInfo.Centre),
                    new MySqlParameter("@SessionCentreName", UserInfo.CentreName),
                    new MySqlParameter("@PanelID", Util.GetInt(obj.Client)),
                    new MySqlParameter("@EmailID", Email));

                TicketID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select @@identity"));

                sb = new StringBuilder();
                sb.Append("INSERT INTO support_error_textDetails(TicketID,Message) ");
                sb.Append(" VALUES(@TicketID,@Message) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@TicketID", TicketID),
                    new MySqlParameter("@Message", Util.GetString(obj.Details))
                );

                if (obj.isTATDefine != 0)
                {
                    DataTable TATResolveTime = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Level1Resolve Lavel1Time,  Level2Resolve Lavel2Time,  Level3Resolve Lavel3Time FROM ticketing_category_master WHERE IsActive=1 AND ID=@ID",
                       new MySqlParameter("@ID", obj.CategoryID)).Tables[0];
                    if (TATResolveTime.Rows.Count > 0)
                    {
                        Level1Time = Util.GetInt(TATResolveTime.Rows[0]["Lavel1Time"].ToString());
                        Level2Time = Util.GetInt(TATResolveTime.Rows[0]["Lavel2Time"].ToString());
                        Level3Time = Util.GetInt(TATResolveTime.Rows[0]["Lavel3Time"].ToString());
                    }
                }
                DateTime LevelTime = DateTime.Now;
                DataTable _dtNew = new DataTable();
                if (obj.isTagEmployeeDefine != 0 || obj.isDefaultTagEmployeeDefine != 0)
                {
                    DataTable tagEmp = null;

                    if (obj.isTagEmployeeDefine != 0)
                    {
                        tagEmp = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT EmployeeID,Lavel Level,EmailCCLevel2,EmailCCLevel3 FROM ticketing_categoryemployee WHERE centreID=@centreID AND CategoryID=@CategoryID AND IsActive=1 ORDER BY lavel  ASC ",
                           new MySqlParameter("@centreID", UserInfo.Centre),
                           new MySqlParameter("@CategoryID", obj.CategoryID)).Tables[0];
                        _dtNew = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT GROUP_CONCAT(EmployeeID) EmployeeID FROM ticketing_categoryemployee WHERE centreID=@centreID AND CategoryID=@CategoryID AND IsActive=1 GROUP BY CategoryID ORDER BY lavel  ASC ",
                            new MySqlParameter("@centreID", UserInfo.Centre),
                            new MySqlParameter("@CategoryID", obj.CategoryID)).Tables[0];
                    }
                    else
                    {
                        tagEmp = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT EmployeeID,Lavel Level,EmailCCLevel2,EmailCCLevel3 FROM ticketing_categoryemployee WHERE centreID=0 AND CategoryID=@CategoryID AND IsActive=1 ORDER BY lavel  ASC ",
                             new MySqlParameter("@CategoryID", obj.CategoryID)).Tables[0];
                        _dtNew = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT GROUP_CONCAT(EmployeeID) EmployeeID FROM ticketing_categoryemployee WHERE centreID=0 AND CategoryID=@CategoryID AND IsActive=1 GROUP BY CategoryID  ORDER BY lavel  ASC ",
                            new MySqlParameter("@CategoryID", obj.CategoryID)).Tables[0];
                    }

                    if (tagEmp.Rows.Count > 0)
                    {
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO support_error_Access(TicketID,AccessDateTime,Employee_ID)VALUES(@TicketID,@AccessDateTime,@Employee_ID)");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@TicketID", TicketID),
                           new MySqlParameter("@AccessDateTime", DateTime.Now),
                           new MySqlParameter("@Employee_ID", UserInfo.ID));
                        DateTime CurentTime = DateTime.Now;
                        for (int i = 0; i < tagEmp.Rows.Count; i++)
                        {
                            sb = new StringBuilder();
                            int TagEmployeeID = 0;
                            if (tagEmp.Rows[i]["Level"].ToString() == "Level1")
                            {
                                TagEmployeeID = Util.GetInt(tagEmp.Rows[i]["EmployeeID"]);
                                LevelTime = CurentTime;

                                if (tagEmp.Rows[i]["EmailCCLevel2"].ToString() == "1")
                                    IsLevel2 = true;
                                if (tagEmp.Rows[i]["EmailCCLevel3"].ToString() == "1")
                                    IsLevel3 = true;
                            }
                            else if (tagEmp.Rows[i]["Level"].ToString() == "Level2")
                            {
                                TagEmployeeID = Util.GetInt(tagEmp.Rows[i]["EmployeeID"].ToString());
                                LevelTime = CurentTime.AddMinutes(Util.GetDouble(Level2Time));
                            }
                            else if (tagEmp.Rows[i]["Level"].ToString() == "Level3")
                            {
                                TagEmployeeID = Util.GetInt(tagEmp.Rows[i]["EmployeeID"].ToString());
                                LevelTime = CurentTime.AddMinutes(Util.GetDouble(Level3Time));
                            }
                            if (TagEmployeeID != 0 && TagEmployeeID != UserInfo.ID)
                            {
                                sb = new StringBuilder();
                                sb.Append(" INSERT INTO support_error_Access(TicketID,AccessDateTime,Employee_ID)VALUES(@TicketID,@AccessDateTime,@Employee_ID)");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                   new MySqlParameter("@TicketID", TicketID),
                                   new MySqlParameter("@AccessDateTime", Util.GetDateTime(LevelTime).ToString("yyyy-MM-dd HH:mm:ss")),
                                   new MySqlParameter("@Employee_ID", TagEmployeeID));
                            }
                        }
                    }
                    else
                    {
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO support_error_Access(TicketID,AccessDateTime,Employee_ID)VALUES(@TicketID,@AccessDateTime,@Employee_ID)");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@TicketID", TicketID),
                        new MySqlParameter("@AccessDateTime", DateTime.Now),
                        new MySqlParameter("@Employee_ID", UserInfo.ID));
                    }
                }
                else
                {
                    int Employee_ID = 0;
                    for (int i = 0; i <= 1; i++)
                    {
                        if (i == 0)
                            Employee_ID = obj.AssignID;
                        else if (i == 1)
                            Employee_ID = UserInfo.ID;
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO support_error_Access(TicketID,AccessDateTime,Employee_ID)VALUES(@TicketID,@AccessDateTime,@Employee_ID)");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@TicketID", TicketID),
                           new MySqlParameter("@AccessDateTime", DateTime.Now),
                           new MySqlParameter("@Employee_ID", Employee_ID));
                    }
                }

                StringBuilder sbBilalNew = new StringBuilder();
                sbBilalNew.Append(" SELECT em.Employee_ID EmpID FROM Employee_Master em INNER JOIN");
                sbBilalNew.Append(" f_login fl ON fl.EmployeeID=em.Employee_ID WHERE fl.RoleID='" + UserInfo.RoleID + "' AND CentreID='" + UserInfo.Centre + "'");
                sbBilalNew.Append(" AND em.IsActive=1 AND fl.Active=1 AND em.Employee_ID<>'" + UserInfo.ID + "'");
                if (_dtNew.Rows.Count > 0)
                {
                    string str = "'" + _dtNew.Rows[0]["EmployeeID"].ToString().Replace(",", "','") + "'";
                    sbBilalNew.Append(" AND em.Employee_ID NOT IN(" + str + ")");
                }
                DataTable _dtEmpIds = StockReports.GetDataTable(sbBilalNew.ToString());
                if (_dtEmpIds.Rows.Count > 0)
                {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO support_error_Access(TicketID,AccessDateTime,Employee_ID) VALUES");
                    for (int m = 0; m < _dtEmpIds.Rows.Count; m++)
                    {
                        sb.Append(" (" + TicketID + ",'" + Util.GetDateTime(LevelTime).ToString("yyyy-MM-dd HH:mm:ss") + "','" + _dtEmpIds.Rows[m]["EmpID"].ToString() + "'),");
                    }
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString().TrimEnd(','));
                }

                // End

                sb = new StringBuilder();
                sb.Append("INSERT INTO support_error_reply(Answer,Employee_Id,EmpName,dtEntry,TicketId,TicketStatus,TicketStatusID,expectedResolveDateTime)");
                sb.Append(" VALUES(@Answer,@Employee_Id,@EmpName,@dtEntry,@TicketId,@TicketStatus,@TicketStatusID,@expectedResolveDateTime)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Answer", Util.GetString(obj.Details)),
                    new MySqlParameter("@Employee_Id", UserInfo.ID),
                    new MySqlParameter("@EmpName", UserInfo.LoginName),
                    new MySqlParameter("@dtEntry", DateTime.Now),
                    new MySqlParameter("@TicketId", TicketID),
                    new MySqlParameter("@TicketStatus", "New"),
                    new MySqlParameter("@TicketStatusID", "1"),
                    new MySqlParameter("@expectedResolveDateTime", Util.GetDateTime(obj.resolveDateTime).ToString("yyyy-MM-dd HH:mm:ss")));

                string ReplyId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT @@identity"));
                string UserId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT Employee_ID FROM support_error_record WHERE ID=@ID",
                new MySqlParameter("@ID", TicketID)));

                if (obj.FileName != null && obj.FileName != string.Empty)
                {
                    sb = new StringBuilder();
                    sb.Append("update support_uploadedfile set TicketId=@TicketId,ReplyId=@ReplyId where TempID=@TempID");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@TicketId", Util.GetString(TicketID)),
                        new MySqlParameter("@ReplyId", Util.GetString(ReplyId)),
                        new MySqlParameter("@TempID", obj.FileName));
                }
            }
            else
            {
                // int replyCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM support_error_reply WHERE TicketID=@TicketID",
                //          new MySqlParameter("@TicketID", obj.OldTicketID)));
            }
            tnx.Commit();
            //string subject = "";
            //if (IsModify)
            //{
            //    subject = "MODIFY " + obj.Subject;
            //}
            //else
            //    subject = obj.Subject;

            //SendNewTicketMail(subject, obj.Details, TicketID, obj.SubCatrgoryID, IsLevel2, IsLevel3, obj.isTagEmployeeDefine, obj.isDefaultTagEmployeeDefine);
            //  string js = new JavaScriptSerializer();
            //DataTable dt = new DataTable();
            //dt.Columns.Add(new DataColumn("Status", typeof(string)));
            //dt.Columns.Add(new DataColumn("msg", typeof(string)));
            //DataRow dr = dt.NewRow();
            //dr["Status"] = "1";
            //dr["msg"] = TicketID;
            //dt.Rows.Add(dr);

            //DataTable dtt = new DataTable();
            //dtt.Columns.Add(new DataColumn("Status", typeof(string)));
            //dtt.Columns.Add(new DataColumn("msg", typeof(string)));
            //DataRow drr = dtt.NewRow();
            //drr["Status"] = "7";
            //drr["msg"] = string.Concat(obj.OldTicketID, "Updated");
            //dtt.Rows.Add(drr);

            return JsonConvert.SerializeObject(new { status = true, response = string.Concat("Ticket Generated Successfully <br/><b>Issue No. :", TicketID, "</b>"), responseDetail = Util.getJson(bindTicketDetail(DateTime.Now.ToString("yyyy-MM-dd"), DateTime.Now.ToString("yyyy-MM-dd"), 1, con)) });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class ClsQuery
    {
        public string CategoryID { get; set; }
        public string QueryID { get; set; }
        public string Subject { get; set; }
        public string Details { get; set; }
        public string BarcodeNumber { get; set; }
        public string VisitNo { get; set; }
        public string InvestigationID { get; set; }
        public string PatientID { get; set; }
        public string FileName { get; set; }
        public int isTATDefine { get; set; }
        public int isTagEmployeeDefine { get; set; }
        public int isDefaultTagEmployeeDefine { get; set; }
        public int RoleID { get; set; }
        public string resolveDateTime { get; set; }
        public int AssignID { get; set; }
        public int OldTicketID { get; set; }
        public string MainHead { get; set; }
        public int Client { get; set; }
        public string LabNo { get; set; }
        public sbyte IsShowBarcodeNumber { get; set; }
        public sbyte IsShowSnvestigationID { get; set; }
        public sbyte IsShowVisitNo { get; set; }
    }

    public static DataTable bindTicketDetail(string fromDate, string toDate, int statusID, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT s.EmailID,s.ID TicketID,s.StatusID,s.Status,IF(s.IsRead=1,'Yes','No')IsRead,cm.CategoryName, s.Subject,s.RegNo,DATE_FORMAT(s.dtAdd,'%d-%b-%Y')dtAdd,");
        sb.Append(" s.ItemID,s.CategoryId,s.QueryID,s.EmpName,");
        sb.Append(" (SELECT COUNT(*) FROM support_uploadedfile WHERE ticketID=s.id) AS Attachment ");
        sb.Append(" FROM support_error_record s ");
        sb.Append(" INNER JOIN ticketing_category_master cm ON cm.ID=s.CategoryID ");

        sb.Append(" WHERE s.Employee_ID=@Employee_ID");
        sb.Append(" AND s.dtAdd>=@fromDate");
        sb.Append(" AND s.dtAdd<=@toDate AND s.Active=1 ");
        if (statusID != 0)
            sb.Append(" AND s.statusID=@statusID");
        sb.Append(" ORDER BY s.StatusID+0");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
             new MySqlParameter("@Employee_ID", UserInfo.ID),
             new MySqlParameter("@statusID", statusID),
             new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " 00:00:00")),
             new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " 23:59:59"))).Tables[0];
    }

    [WebMethod]
    public static string searchOldTicket(string fromDate, string toDate, int statusID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = bindTicketDetail(fromDate, toDate, statusID, con))
            {
                if (dt.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(new { status = true, responseDetail = Util.getJson(dt) });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = true, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
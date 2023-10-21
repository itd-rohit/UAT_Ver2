using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.UI;
public partial class Design_CallCenter_NewTicket : System.Web.UI.Page
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
        if (!IsPostBack)
        {
            bindGroup();
            // bindinv();
            txtResolveDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtResolveDate.Attributes.Add("readOnly", "readOnly");
            txtResolveTime.Text = DateTime.Now.ToString("HH:mm:ss");
            txtFromDate.Text = DateTime.Now.AddDays(-15).ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindStatus();
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
        if (Util.GetString(Request.QueryString["FileName"]) != string.Empty)
            lblFileName.Text = Util.GetString(Request.QueryString["FileName"]);
        calResolveDate.StartDate = DateTime.Now;
    }

    private void bindStatus()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,STATUS  FROM  support_status_master where isActive=1 ");
        if (dt.Rows.Count > 0)
        {
            ddlStatus.DataTextField = "STATUS";
            ddlStatus.DataValueField = "ID";
            ddlStatus.DataSource = dt;
            ddlStatus.DataBind();
            ddlStatus.Items.Insert(0, new ListItem("All", "0"));
            ddlStatus.SelectedIndex = ddlStatus.Items.IndexOf(ddlStatus.Items.FindByValue("1"));
        }
    }
    [WebMethod]
    private DataTable GetEmpList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Employee_ID as value,CONCAT(House_No,'~', CONCAT(Title,' ', NAME)) AS label FROM `employee_master` WHERE IsActive=1 AND Employee_ID !='" + UserInfo.ID + "' AND NAME LIKE '" + Request.QueryString["EmpName"].ToString() + "%' ");
        return StockReports.GetDataTable(sb.ToString());
    }
    [WebMethod]
    public static string bindCategory(int GroupID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT ID,CategoryName FROM CutomerCare_Category_Master WHERE IsActive=1 AND GroupID='" + GroupID + "' ORDER BY CategoryName asc ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string bindSubCategory(string CategoryID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(ID,'#',ShowBarcodeNumber,'#',ShowInvestigationID,'#',ShowPatientID,'#', ");
        sb.Append(" (SELECT IF(COUNT(*)>0,1,0) FROM customercare_inquery_categoryTAT WHERE IsActive=1 AND SubcategoryID=sm.ID AND CC_InqType=2),'#', ");
        sb.Append(" (SELECT IF(COUNT(*)>0,1,0) FROM customercare_inquery_categoryEmployee WHERE isActive=1 and Inq_SubCategoryID=sm.ID AND centreID='" + UserInfo.Centre + "') ");
        sb.Append(" ,'#',ShowVisitNo,'#',ShowDepartment,'#',MandatoryBarcodeNumber,'#',MandatoryVisitNo,'#', MandatoryPatientID,'#',MandatoryDepartment,'#',MandatoryInvestigationID,'#', (SELECT IF(COUNT(*)>0,1,0) FROM customercare_inquery_categoryEmployee WHERE IsActive=1 and Inq_SubCategoryID=sm.ID AND centreID='0'))ID,SubCategoryName ");
        sb.Append(" FROM CutomerCare_SubCategory_Master sm WHERE sm.IsActive=1 AND sm.CategoryID='" + CategoryID + "' ORDER BY sm.SubCategoryName asc ");
        sb.Append("");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string ShowHideDetails(string SubCategoryID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT ID,SubCategoryName,ShowBarcodeNumber,ShowInvestigationID,ShowPatientID FROM CutomerCare_SubCategory_Master WHERE ID='" + SubCategoryID + "' ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string bindinv(string Department)
    {
        // DataTable dt = StockReports.GetDataTable("SELECT ItemID AS id,CONCAT(TestCode,' - ',TypeName) value FROM f_itemmaster   WHERE subCategoryid<>'15' AND isActive=1   ORDER BY value");
        //ddlInvestigation.DataSource = dt;
        //ddlInvestigation.DataTextField = "value";
        //ddlInvestigation.DataValueField = "id";
        //ddlInvestigation.DataBind();
        //ddlInvestigation.Items.Insert(0, new ListItem("---Select Test---", "0"));
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ItemID AS id,CONCAT(TestCode,' - ',TypeName) VALUE FROM `f_itemmaster` item INNER JOIN f_subcategorymaster sub ON (sub.SubcategoryID=item.SubCategoryID and item.subCategoryid<>'15')   ");
        sb.Append(" INNER JOIN cutomercare_department_master dep ON(sub.name='" + Department + "' AND dep.IsLabDepartment='1')   ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Util.getJson(dt);
    }

    [WebMethod]
    public static string Save(string query)
    {
        bool IsLevel2 = false;
        bool IsLevel3 = false;
        bool IsModify = false;
        ClsQuery obj = new ClsQuery();
        obj = JsonConvert.DeserializeObject<ClsQuery>(query);
        StringBuilder sb = new StringBuilder();
        if (obj.isTATDefine == 0)
        {
            double NrOfDays = (Util.GetDateTime(obj.resolveDateTime) - DateTime.Now).TotalSeconds;
            if (NrOfDays < 0)
                return "2";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        if (obj.IsShowBarcodeNumber == "1" && obj.BarcodeNumber != string.Empty)
        {
            int chkBarCode = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM patient_labinvestigation_opd WHERE `BarcodeNo`='" + Util.GetString(obj.BarcodeNumber) + "'"));
            if (chkBarCode == 0)
                return "3";
        }
        if (obj.IsShowPatientID == "1" && obj.PatientID != string.Empty)
        {
            int chkPatientID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM patient_master WHERE `Patient_ID`='" + Util.GetString(obj.PatientID) + "'"));
            if (chkPatientID == 0)
                return "4";
        }

        if (obj.IsShowVisitNo == "1" && obj.VisitNo != string.Empty)
        {
            int chkVisitNo = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM patient_labinvestigation_opd WHERE `LedgerTransactionNo`='" + Util.GetString(obj.VisitNo) + "'"));
            if (chkVisitNo == 0)
                return "5";
        }

        try
        {

            int Level1Time = 0; int Level2Time = 0; int Level3Time = 0;
            string TicketID = string.Empty;
            if (obj.OldTicketID == 0)
            {

                sb = new StringBuilder();
                sb.Append("INSERT INTO `support_error_record`(`EmpId`,`EmpName`,`Subject`,`CentreID`,VialId,VisitNo,`RegNo`,`dtAdd`,UpdateDate,UpdateID,UpdateName,");
                sb.Append(" StatusId,ItemID,CategoryId,SubCategoryID,QueryID,isTATDefine,isTagEmployeeDefine,AssignID,GroupID,DepartmentID,isDefaultTagEmployeeDefine ");
                sb.Append(" )");
                sb.Append(" VALUES(@EmpId,@EmpName,@Subject,@CentreID,@VialId,@VisitNo,@RegNo,@dtAdd,@UpdateDate,@UpdateID,@UpdateName, ");
                sb.Append(" @StatusId,@ItemID,@CategoryId,@SubCategoryID,@QueryID,@isTATDefine,@isTagEmployeeDefine,@AssignID,@GroupID,@DepartmentID,@isDefaultTagEmployeeDefine ");
                sb.Append(" )");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@EmpId", Util.GetString(UserInfo.ID)), new MySqlParameter("@EmpName", Util.GetString(UserInfo.LoginName)),
                    new MySqlParameter("@Subject", Util.GetString(obj.Subject)),
                     new MySqlParameter("@CentreID", Util.GetString(UserInfo.Centre)),
                    new MySqlParameter("@RegNo", Util.GetString(obj.PatientID)), new MySqlParameter("@VialId", Util.GetString(obj.BarcodeNumber)),
                    new MySqlParameter("@VisitNo", Util.GetString(obj.VisitNo)),
                    new MySqlParameter("@dtAdd", DateTime.Now), new MySqlParameter("@UpdateDate", DateTime.Now), new MySqlParameter("@UpdateID", Util.GetString(UserInfo.ID)),
                    new MySqlParameter("@UpdateName", Util.GetString(UserInfo.LoginName)), new MySqlParameter("@StatusId", '1'),
                    new MySqlParameter("@ItemID", Util.GetString(obj.InvestigationID)), new MySqlParameter("@CategoryId", Util.GetString(obj.CatrgoryID)),
                    new MySqlParameter("@SubCategoryID", Util.GetString(obj.SubCatrgoryID)), new MySqlParameter("@QueryID", Util.GetString(obj.QueryID)),
                    new MySqlParameter("@isTATDefine", obj.isTATDefine), new MySqlParameter("@isTagEmployeeDefine", obj.isTagEmployeeDefine),
                     new MySqlParameter("@isDefaultTagEmployeeDefine", obj.isDefaultTagEmployeeDefine),
                    //new MySqlParameter("@resolveDateTime", Util.GetDateTime(obj.resolveDateTime).ToString("yyyy-MM-dd HH:mm:ss")), new MySqlParameter("@AssignID", obj.AssignID),
                     new MySqlParameter("@AssignID", obj.AssignID),
                    new MySqlParameter("@GroupID", obj.GroupID), new MySqlParameter("@DepartmentID", obj.DepartmentID)
                    //new MySqlParameter("@Level1TagEmployee", Level1TagEmployee), new MySqlParameter("@Level2TagEmployee", Level2TagEmployee),
                    //new MySqlParameter("@Level3TagEmployee", Level3TagEmployee),
                    //new MySqlParameter("@Lavel1Time", Lavel1Time), new MySqlParameter("@Lavel2Time", Lavel2Time),
                    //new MySqlParameter("@Lavel3Time", Lavel3Time)
                    );

                TicketID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select @@identity"));

                sb = new StringBuilder();
                sb.Append("INSERT INTO `support_error_textDetails`(`TicketID`,`Message`) ");
                sb.Append(" VALUES(@TicketID,@Message) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@TicketID", TicketID),
                    new MySqlParameter("@Message", Util.GetString(obj.Details))
                );



                if (obj.isTATDefine != 0)
                {
                    DataTable TATResolveTime = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Lavel1Time,Lavel2Time,Lavel3Time FROM customercare_inquery_categoryTAT WHERE IsActive=1 AND SubcategoryID='" + obj.SubCatrgoryID + "' AND CC_InqType=2").Tables[0];
                    if (TATResolveTime.Rows.Count > 0)
                    {
                        Level1Time = Util.GetInt(TATResolveTime.Rows[0]["Lavel1Time"].ToString());
                        Level2Time = Util.GetInt(TATResolveTime.Rows[0]["Lavel2Time"].ToString());
                        Level3Time = Util.GetInt(TATResolveTime.Rows[0]["Lavel3Time"].ToString());
                    }
                }
                DateTime LevelTime = DateTime.Now;
                if (obj.isTagEmployeeDefine != 0 || obj.isDefaultTagEmployeeDefine != 0)
                {
                    DataTable tagEmp = null;
                    if (obj.isTagEmployeeDefine != 0)
                        tagEmp = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT EmployeeID,Lavel Level,EmailCCLevel2,EmailCCLevel3 FROM customercare_inquery_categoryEmployee WHERE centreID='" + UserInfo.Centre + "' AND Inq_SubCategoryID='" + obj.SubCatrgoryID + "' AND IsActive=1 ORDER BY lavel  ASC ").Tables[0];
                    else
                        tagEmp = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT EmployeeID,Lavel Level,EmailCCLevel2,EmailCCLevel3 FROM customercare_inquery_categoryEmployee WHERE centreID='0' AND Inq_SubCategoryID='" + obj.SubCatrgoryID + "' AND IsActive=1 ORDER BY lavel  ASC ").Tables[0];

                    if (tagEmp.Rows.Count > 0)
                    {
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO support_error_Access(TicketID,AccessDateTime,EmployeeID)VALUES(@TicketID,@AccessDateTime,@EmployeeID)");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@TicketID", TicketID),new MySqlParameter("@AccessDateTime", DateTime.Now), new MySqlParameter("@EmployeeID", UserInfo.ID));
                        DateTime CurentTime = DateTime.Now;
                        for (int i = 0; i < tagEmp.Rows.Count; i++)
                        {
                            sb = new StringBuilder();
                            int TagEmployeeID = 0;
                            if (tagEmp.Rows[i]["Level"].ToString() == "Level1")
                            {
                                TagEmployeeID = Util.GetInt(tagEmp.Rows[i]["EmployeeID"].ToString());
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
                                sb.Append(" INSERT INTO support_error_Access(TicketID,AccessDateTime,EmployeeID)VALUES(@TicketID,@AccessDateTime,@EmployeeID)");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                   new MySqlParameter("@TicketID", TicketID), new MySqlParameter("@AccessDateTime", Util.GetDateTime(LevelTime).ToString("yyyy-MM-dd HH:mm:ss")),
                                   new MySqlParameter("@EmployeeID", TagEmployeeID));

                                Notification.notificationInsert(1, Util.GetString(TicketID), tnx, 0, Util.GetDateTime(LevelTime).ToString("yyyy-MM-dd HH:mm:ss"), TagEmployeeID, "New Ticket");

                            }
                        }
                    }
                    else
                    {
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO support_error_Access(TicketID,AccessDateTime,EmployeeID)VALUES(@TicketID,@AccessDateTime,@EmployeeID)");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@TicketID", TicketID), new MySqlParameter("@AccessDateTime",DateTime.Now), new MySqlParameter("@EmployeeID", UserInfo.ID));
                    }
                }
                else
                {
                    int EmpID = 0;
                    for (int i = 0; i <= 1; i++)
                    {
                        if (i == 0)
                            EmpID = obj.AssignID;
                        else if (i == 1)
                            EmpID = UserInfo.ID;
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO support_error_Access(TicketID,AccessDateTime,EmployeeID)VALUES(@TicketID,@AccessDateTime,@EmployeeID)");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@TicketID", TicketID), new MySqlParameter("@AccessDateTime", DateTime.Now), new MySqlParameter("@EmployeeID", EmpID));
                    }
                }
                sb = new StringBuilder();
                sb.Append("INSERT INTO `support_error_reply`(`Answer`,`EmpId`,`EmpName`,`dtEntry`,`TicketId`,TicketStatus,TicketStatusID,expectedResolveDateTime)");
                sb.Append(" VALUES(@Answer,@EmpId,@EmpName,@dtEntry,@TicketId,@TicketStatus,@TicketStatusID,@expectedResolveDateTime)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Answer", Util.GetString(obj.Details)), new MySqlParameter("@EmpId", Util.GetString(UserInfo.ID)),
                    new MySqlParameter("@EmpName", Util.GetString(UserInfo.LoginName)), new MySqlParameter("@dtEntry", DateTime.Now),
                    new MySqlParameter("@TicketId", TicketID), new MySqlParameter("@TicketStatus", "New"), new MySqlParameter("@TicketStatusID", "1"),
                   new MySqlParameter("@expectedResolveDateTime", Util.GetDateTime(obj.resolveDateTime).ToString("yyyy-MM-dd HH:mm:ss")));

                string ReplyId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT @@identity"));
                string UserId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT `EmpId` FROM `support_error_record` WHERE `ID`=@ID",
                    new MySqlParameter("@ID", TicketID)));

                if (obj.FileName != null && obj.FileName != string.Empty)
                {
                    sb = new StringBuilder();
                    sb.Append("update support_uploadedfile set TicketId=@TicketId,ReplyId=@ReplyId where TempID=@TempID");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@TicketId", Util.GetString(TicketID)), new MySqlParameter("@ReplyId", Util.GetString(ReplyId)),
                        new MySqlParameter("@TempID", obj.FileName));
                }
            }
            else
            {

                int replyCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM support_error_reply WHERE TicketID=@TicketID",
                         new MySqlParameter("@TicketID", obj.OldTicketID)));
                if (replyCount == 1)
                {
                    sb = new StringBuilder();
                    sb.Append("UPDATE support_error_record SET GroupID=@GroupID,CategoryId=@CategoryId,SubCategoryID=@SubCategoryID,QueryID=@QueryID,Subject=@Subject,");
                    sb.Append(" VialId=@VialId,VisitNo=@VisitNo,RegNo=@RegNo,ItemID=@ItemID,DepartmentID=@DepartmentID, ");
                    sb.Append(" UpdateDate=@UpdateDate,UpdateID=@UpdateID,UpdateName=@UpdateName,AssignID=@AssignID");
                    sb.Append(" ");
                    sb.Append(" ");
                    sb.Append(" WHERE ID=@TicketID");



                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@TicketID", obj.OldTicketID), new MySqlParameter("@GroupID", obj.GroupID), new MySqlParameter("@CategoryId", obj.CatrgoryID),
                        new MySqlParameter("@SubCategoryID", obj.SubCatrgoryID), new MySqlParameter("@QueryID", obj.QueryID), new MySqlParameter("@Subject", obj.Subject),
                        new MySqlParameter("@VialId", obj.BarcodeNumber), new MySqlParameter("@VisitNo", obj.VisitNo), new MySqlParameter("@RegNo", obj.PatientID),
                        new MySqlParameter("@ItemID", obj.InvestigationID), new MySqlParameter("@DepartmentID", obj.DepartmentID), new MySqlParameter("@UpdateDate", DateTime.Now),
                        new MySqlParameter("@UpdateID", UserInfo.ID), new MySqlParameter("@UpdateName", UserInfo.LoginName), new MySqlParameter("@AssignID", obj.AssignID)
                        );

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE support_error_textDetails SET Message=@Message WHERE TicketID=@TicketID ",
                        new MySqlParameter("@TicketID", obj.OldTicketID),
                        new MySqlParameter("@Message", Util.GetString(obj.Details))
                    );


                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE support_error_reply SET Answer=@Answer,expectedResolveDateTime=@expectedResolveDateTime WHERE TicketId=@TicketId ",
                    new MySqlParameter("@Answer", Util.GetString(obj.Details)), new MySqlParameter("@TicketId", obj.OldTicketID),
                    new MySqlParameter("@expectedResolveDateTime", Util.GetDateTime(obj.resolveDateTime).ToString("yyyy-MM-dd HH:mm:ss")));


                    string ReplyId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT ID FROM support_error_reply WHERE TicketID=@TicketID",
                         new MySqlParameter("@TicketId", obj.OldTicketID)));


                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update support_uploadedfile set ReplyId=@ReplyId where TicketId=@TicketId",
                        new MySqlParameter("@TicketId", obj.OldTicketID), new MySqlParameter("@ReplyId", Util.GetString(ReplyId)));

                    IsModify = true;

                }
                else
                {
                    return "6";
                }

            }
            tnx.Commit();
            string subject = "";
            if (IsModify)
            {
                subject = "MODIFY " + obj.Subject;
            }
            else
                subject = obj.Subject;

            SendNewTicketMail(subject, obj.Details, TicketID, obj.SubCatrgoryID, IsLevel2, IsLevel3, obj.isTagEmployeeDefine, obj.isDefaultTagEmployeeDefine);
            if (obj.OldTicketID == 0)
                return Util.getJson(new { Status = "1", msg = TicketID });
            else
                return Util.getJson(new { Status = "7", msg = string.Concat(obj.OldTicketID, " Updated ") });
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
    [WebMethod]
    public static string GetInquiryDescription(string QueryId)
    {
        DataTable Reply = StockReports.GetDataTable("SELECT `categoryId`,`Detail` FROM `inquiry_master` WHERE `Id`='" + QueryId + "'");

        return Util.getJson(Reply);
    }
    [WebMethod(EnableSession = true)]
    public static string GetCategoryName()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("  SELECT ID,CategoryName FROM `cutomercare_category_master` WHERE IsActive='1' ORDER BY CategoryName "));
    }
    public class ClsQuery
    {
        public string CatrgoryID { get; set; }
        public string SubCatrgoryID { get; set; }
        public string QueryID { get; set; }
        public string Subject { get; set; }
        public string Details { get; set; }
        public string BarcodeNumber { get; set; }
        public string VisitNo { get; set; }
        public string InvestigationID { get; set; }
        public string PatientID { get; set; }
        public string FileName { get; set; }
        public string IsShowBarcodeNumber { get; set; }
        public string IsShowSnvestigationID { get; set; }
        public string IsShowPatientID { get; set; }
        public string IsShowVisitNo { get; set; }

        public int isTATDefine { get; set; }
        public int isTagEmployeeDefine { get; set; }
        public int isDefaultTagEmployeeDefine { get; set; }
        public string resolveDateTime { get; set; }
        public int AssignID { get; set; }
        public int DepartmentID { get; set; }
        public int GroupID { get; set; }
        public int OldTicketID { get; set; }
    }


    public static void SendNewTicketMail(string Subject, string Message, string TiketId, string SubCatrgoryID = "0", bool IsLevel2 = false, bool IsLevel3 = false, int isTagEmployeeDefine = 0, int isDefaultTagEmployeeDefine = 0)
    {

        //EmailCCLevel2,EmailCCLevel3 
        int columnIndex = 0; //single-column DataTable
        // Level 2 Mail Start
        DataTable Level1CCdt = new DataTable();
        if (isTagEmployeeDefine != 0)
            Level1CCdt = StockReports.GetDataTable("SELECT Email FROM employee_master WHERE Employee_ID in(SELECT EmployeeID FROM customercare_inquery_categoryEmployee WHERE centreID='" + UserInfo.Centre + "' AND Inq_SubCategoryID='" + SubCatrgoryID + "' AND IsActive=1 and lavel='Level1' )");
        else
            Level1CCdt = StockReports.GetDataTable("SELECT Email FROM employee_master WHERE Employee_ID in(SELECT EmployeeID FROM customercare_inquery_categoryEmployee WHERE centreID='0' AND Inq_SubCategoryID='" + SubCatrgoryID + "' AND IsActive=1 and lavel='Level1' )");

        string[] CcLevel1 = new string[Level1CCdt.Rows.Count];
        columnIndex = 0;
        for (int i = 0; i < Level1CCdt.Rows.Count; i++)
        {
            CcLevel1[i] = Level1CCdt.Rows[i][columnIndex].ToString();

        }
        // Level 2 Mail End

        ReportEmailClass mail = new ReportEmailClass();
        DataTable dt = StockReports.GetDataTable("SELECT CONCAT(CONCAT('/',DATE_FORMAT(dtEntry,'%Y%m%d'),'/',filename,'',FileExt)) fileUrl FROM support_uploadedfile WHERE TicketId='" + TiketId + "'");
        string[] Attachment = new string[dt.Rows.Count];
        string RootDir = System.Web.HttpContext.Current.Server.MapPath("~/CallCenterDocument");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            Attachment[i] = RootDir + @"\" + dt.Rows[i][columnIndex].ToString();
        }

        // Level 2 Mail Start
        DataTable Level2CCdt = new DataTable();
        if (IsLevel2 == true)
        {
            if (isTagEmployeeDefine != 0)
                Level2CCdt = StockReports.GetDataTable("SELECT Email FROM employee_master WHERE Employee_ID in(SELECT EmployeeID FROM customercare_inquery_categoryEmployee WHERE centreID='" + UserInfo.Centre + "' AND Inq_SubCategoryID='" + SubCatrgoryID + "' AND IsActive=1 and lavel='Level2')");
            else
                Level2CCdt = StockReports.GetDataTable("SELECT Email FROM employee_master WHERE Employee_ID in(SELECT EmployeeID FROM customercare_inquery_categoryEmployee WHERE centreID='0' AND Inq_SubCategoryID='" + SubCatrgoryID + "' AND IsActive=1 and lavel='Level2')");
        }
        string[] CcLevel2 = new string[Level2CCdt.Rows.Count];

        columnIndex = 0;
        for (int i = 0; i < Level2CCdt.Rows.Count; i++)
        {
            CcLevel2[i] = Level2CCdt.Rows[i][columnIndex].ToString();
        }
        // Level 2 Mail End

        // Level 3 Mail Start
        DataTable Level3CCdt = new DataTable();
        if (IsLevel3 == true)
        {
            if (isTagEmployeeDefine != 0)
                Level3CCdt = StockReports.GetDataTable("SELECT Email FROM employee_master WHERE Employee_ID in(SELECT EmployeeID FROM customercare_inquery_categoryEmployee WHERE centreID='" + UserInfo.Centre + "' AND Inq_SubCategoryID='" + SubCatrgoryID + "' AND IsActive=1 and lavel='Level3')");
            else
                Level3CCdt = StockReports.GetDataTable("SELECT Email FROM employee_master WHERE Employee_ID in(SELECT EmployeeID FROM customercare_inquery_categoryEmployee WHERE centreID='0' AND Inq_SubCategoryID='" + SubCatrgoryID + "' AND IsActive=1 and lavel='Level3')");
        }
        string[] CcLevel3 = new string[Level3CCdt.Rows.Count];

        columnIndex = 0;
        for (int i = 0; i < Level3CCdt.Rows.Count; i++)
        {
            CcLevel3[i] = Level3CCdt.Rows[i][columnIndex].ToString();
        }
        // Level 2 Mail End
        mail.sendCustomerCareEmail(CcLevel1, Subject, Message, CcLevel2, CcLevel3, Attachment, TiketId);


    }
    public void bindGroup()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT GroupID,GroupName FROM cutomercare_group_master where IsActive=1 ORDER BY GroupName asc ");
        ddlGroup.DataSource = dt;
        ddlGroup.DataTextField = "GroupName";
        ddlGroup.DataValueField = "GroupID";
        ddlGroup.DataBind();
        ddlGroup.Items.Insert(0, new ListItem { Text = "---Select---", Value = "0" });
        if (Request.QueryString["FileName"] != null)
        {
            ddlGroup.SelectedIndex = ddlGroup.Items.IndexOf(ddlGroup.Items.FindByValue("1"));
        }
    }
    [WebMethod]
    public static string searchOldTicket(string fromDate, string toDate, int statusID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT s.ID TicketID,s.StatusID,s.Status,s.IsRead, cgm.GroupName,csm.SubCategoryName,ccm.CategoryName, s.Subject,s.VialId,s.VisitNo,s.RegNo,DATE_FORMAT(s.dtAdd,'%d-%b-%Y')dtAdd, ");
        sb.Append(" s.ItemID,s.CategoryId,s.QueryID,s.AssignID,s.GroupID,s.DepartmentID,DATE_FORMAT(s.resolveDateTime,'%d-%b-%Y')resolveDate,DATE_FORMAT(s.resolveDateTime,'%H-%i-%s')resolveTime ,");
        sb.Append("  CONCAT(csm.ID,'#',ShowBarcodeNumber,'#',ShowInvestigationID,'#',ShowPatientID,'#', ");
        sb.Append(" (SELECT IF(COUNT(*)>0,1,0) FROM customercare_inquery_categoryTAT WHERE IsActive=1 AND SubcategoryID=csm.ID AND CC_InqType=2),'#', ");
        sb.Append(" (SELECT IF(COUNT(*)>0,1,0) FROM customercare_inquery_categoryEmployee WHERE isActive=1 and Inq_SubCategoryID=csm.ID AND centreID='" + UserInfo.Centre + "') ");
        sb.Append(" ,'#',ShowVisitNo,'#',ShowDepartment,'#',MandatoryBarcodeNumber,'#',MandatoryVisitNo,'#', MandatoryPatientID,'#',MandatoryDepartment,'#',MandatoryInvestigationID,'#', ");
        sb.Append(" (SELECT IF(COUNT(*)>0,1,0) FROM customercare_inquery_categoryEmployee WHERE IsActive=1 and Inq_SubCategoryID=csm.ID AND centreID='0'))SubCategoryID, ");
        sb.Append(" (SELECT COUNT(*) FROM support_uploadedfile WHERE ticketID=s.id) AS Attachment ");
        sb.Append(" FROM support_error_record s ");
        sb.Append(" INNER JOIN cutomercare_group_master cgm ON cgm.GroupID=s.GroupID ");
        sb.Append(" INNER JOIN cutomercare_category_master ccm ON ccm.ID=s.CategoryId ");
        sb.Append(" INNER JOIN cutomercare_subcategory_master csm ON csm.ID=s.SubCategoryID ");
        sb.Append(" WHERE s.EmpId='" + UserInfo.ID + "' AND s.CentreID='" + UserInfo.Centre + "'");
        sb.Append(" AND s.dtAdd>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND s.dtAdd<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' AND s.Active=1 ");
        if (statusID != 0)
            sb.Append(" AND s.statusID='" + statusID + "'");
        sb.Append(" ORDER BY s.StatusID+0");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Util.getJson(dt);
    }
    [WebMethod]
    public static string searchOldTicketDetail(string TicketID)
    {
        return StockReports.ExecuteScalar("SELECT Message FROM support_error_textDetails WHERE TicketID='" + TicketID + "'");
    }
    [WebMethod]
    public static string searchOldTicketAttachment(string TicketID)
    {
        return StockReports.ExecuteScalar("SELECT fileName,filePath FROM support_uploadedfile WHERE TicketID='" + TicketID + "'");
    }
    [WebMethod]
    public static string encryptTicketID(string TicketID)
    {
        return Common.Encrypt(TicketID);
    }
    
}
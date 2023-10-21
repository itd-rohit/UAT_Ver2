<%@ WebService Language="C#" Class="Support" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MySql.Data.MySqlClient;
using System.Data;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Support : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    public string GetIssueList(string FromDate, string ToDate, string IssueCode, string VialId, string FromBarcode, string ToBarcode, string RegNo, string PccCode, string Status, string TimeFrm, string TimeTo, string Dept, string Role_ID)
    {
        //string Role = HttpContext.Current.Session["RoleID"].ToString().Trim();
        //int Role_ID = Int32.Parse(Role.Trim());
        List<SupportProp> mylist = new List<SupportProp>();
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append(" SELECT tce.`CentreID`, tcm.`ID` CategoryID,sea.Employee_ID EmployeeID, IF(s.`PanelId`='','',IFNULL(fpm.`Company_Name`,'')) Company_Name, DATE_FORMAT(AccessDateTime,'%d-%b-%Y %h:%i %p')AccessDateTime, s.`ID` IssueCode, s.Status STATUS,");
            sb.Append(" s.`ID`,s.Employee_ID `EmpId`,s.`EmpName`,IFNULL(s.`SiteId`,'')SiteId,s.`Subject`,'' Message,s.`VialId`,IFNULL(s.`RegNo`,'')RegNo, ");
            sb.Append("  DATE_FORMAT(s.`dtAdd`,'%d %b %Y %h:%i %p')dtAdd,s.itemid FROM `support_error_record` s ");
            sb.Append("  INNER JOIN support_error_Access sea  ");
            sb.Append("  ON s.ID= sea.TicketID ");
            sb.Append(" INNER JOIN `ticketing_category_master` tcm ON tcm.`ID`=s.`CategoryID`");
            sb.Append(" INNER JOIN ticketing_categoryemployee tce ON tce.`CategoryID`=tcm.ID");
            sb.Append(" LEFT JOIN f_panel_master fpm ON fpm.`Panel_ID`=s.`PanelId` ");

            sb.Append("WHERE (s.`dtAdd` >=@FromDate AND s.`dtAdd` <=@ToDate) ");
            sb.Append("  AND AccessDateTime<=@ToDate and sea.Employee_ID=@EmployeeID AND IF(tce.`CentreID`=0,1=1,tce.`CentreID`=@CentreID)   "); //AND s.SessionRoleID =@RoleID

            if (IssueCode != string.Empty)
            {
                IssueCode = IssueCode.ToUpper().Replace("PIM", "");
                sb.Append(" AND s.`ID`=@IssueCode ");
            }
            if (VialId != string.Empty)
            {
                sb.Append(" AND s.`VialId` LIKE @VialId");
            }
            if (RegNo != string.Empty)
            {
                sb.Append(" AND s.`RegNo`=@RegNo");
            }
            if (PccCode != string.Empty)
            {
                sb.Append(" AND fpm.`Company_name` like @PccCode");
            }
            if (Status != "0")
            {
                sb.Append(" AND s.`Status`=@Status");
            }
            //added by chandan for department wise segregation of ticketing
           // sb.Append(" AND s.`SessionRoleID` = "+Role_ID+" ");
            //sb.Append(" AND s.`SessionRoleID` = @Role_ID ");
            sb.Append(" AND s.Active=1 GROUP BY sea.Employee_ID, s.ID ORDER BY IF(s.STATUS='Resolved' OR s.STATUS='Closed',1,2) DESC,s.dtAdd DESC");
//System.IO.File.WriteAllText (@"C:\\suportviewtict.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@Status", Status),
                 new MySqlParameter("@RegNo", RegNo),
                 new MySqlParameter("@EmployeeID", UserInfo.ID),
                 new MySqlParameter("@CentreID", UserInfo.Centre),
                 new MySqlParameter("@IssueCode", IssueCode),
                 new MySqlParameter("@PccCode", string.Format("%{0}%", PccCode)),
                 new MySqlParameter("@VialId", string.Format("%{0}%", VialId)),
                 new MySqlParameter("@FromDate", (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm)),
                 new MySqlParameter("@ToDate", (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + TimeTo))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = true, response = string.Empty, responseDetail = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = true, response = "No Record Found", responseDetail = string.Empty });
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error", responseDetail = string.Empty });

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string GetStatus()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT STATUS FROM  support_status_master where isActive=1"))
        {
            return Util.getJson(dt);
        }
    }
    [WebMethod(EnableSession = true)]
    public void CheckReadStatus(string ItemId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string IsRead = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT `IsRead` FROM `support_error_record` WHERE `ID`=@ID",
                new MySqlParameter("@ID", ItemId)));
            if (IsRead == "0")
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE `support_error_record` SET `IsRead`=1,`ReadTime`=NOW(),ReadBy=@ReadBy,ReadByID=@ReadByID WHERE `ID`=@ID",
                    new MySqlParameter("@ID", ItemId),
                    new MySqlParameter("@ReadBy", UserInfo.LoginName),
                    new MySqlParameter("@ReadByID", UserInfo.ID));
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


    [WebMethod(EnableSession = true)]
    public string GetReplyList(string TicketId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT ");
            sb.Append(" IFNULL(fpm.`Panel_ID`,'')Panel_ID,");
            sb.Append(" IFNULL(su.`FileId`,'')FileId,");
            sb.Append(" IFNULL(su.`FileName`,'')FileName,");
            sb.Append(" IFNULL(su.`FilePath`,'')FilePath, ");
            sb.Append(" ser.`Answer`,");
            sb.Append(" ser.`EmpId`,");
            sb.Append(" ser.`EmpName`,");
            sb.Append(" DATE_FORMAT(ser.`dtEntry`, '%d %b %Y %h:%i %p') dtEntry ,IFNULL(fpm.`Panel_ID`,'')Panel_ID");
            sb.Append(" FROM");
            sb.Append("`support_error_reply` ser");
            sb.Append(" LEFT JOIN f_panel_master fpm ON ser.`EmpId`=fpm.`EmployeeID`");
            sb.Append(" LEFT JOIN `support_uploadedfile` su ON ser.`id`=su.`ReplyId`");
            sb.Append(" WHERE ser.`TicketId` = @TicketId");
            sb.Append(" ORDER BY ser.`dtEntry` DESC ");
            DataTable Reply = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@TicketId", TicketId)).Tables[0];
            return Util.getJson(Reply);

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string GetQueryDescription(string QueryId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT `Detail`,`MainHead` FROM `Support_queryresponse` WHERE `Id`=@QueryId");
            using (DataTable Reply = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
              new MySqlParameter("@QueryId", QueryId)).Tables[0])
                return Util.getJson(Reply); ;

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }



    [WebMethod(EnableSession = true)]
    public string SaveReply(string Answer, string IssueId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string status = "";
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO `support_error_reply`(`Answer`,`EmpId`,`EmpName`,`dtEntry`,`SiteId`,`TicketId`)");
            sb.Append(" VALUES(@Answer,@EmpId,@EmpName,@dtEntry,@SiteId,@TicketId)");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text,
                sb.ToString(),
                new MySqlParameter("@Answer", Answer),
                new MySqlParameter("@EmpId", Util.GetString(Session["ID"])),
                new MySqlParameter("@EmpName", Util.GetString(Session["LoginName"])),
                new MySqlParameter("@dtEntry", DateTime.Now),
                new MySqlParameter("@SiteId", Util.SiteId()),
                new MySqlParameter("@TicketId", IssueId));
            string UserId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT `EmpId` FROM `support_error_record` WHERE `ID`=@ID",
                new MySqlParameter("@ID", IssueId)));
            //if (UserId == Util.GetString(Session["ID"]))
            // {
            if (Util.GetString(Session["IsPanel"]) == "Yes")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text,
                   "UPDATE `support_error_record` SET `Status`='PCC Reply' WHERE `ID`=@Id",
                   new MySqlParameter("@Id", IssueId));
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text,
                   "UPDATE `support_error_record` SET `Status`='Staff Reply' WHERE `ID`=@Id",
                   new MySqlParameter("@Id", IssueId));
            }

            tnx.Commit();

            status = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT `Status` FROM `support_error_record` WHERE `ID`=@ID",
                new MySqlParameter("@ID", IssueId)));
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            status = "";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        return status;
    }

    [WebMethod(EnableSession = true)]
    public string ViewOnlineTransaction(string PccCode, string FromDate, string ToDate, string TransactionNo, string Status)
    {
        StringBuilder sb = new StringBuilder();
        DateTime StartDate = DateTime.Parse(FromDate);
        DateTime EndDate = DateTime.Parse(ToDate);
        DataTable dt = new DataTable();
        sb.Append("SELECT `paymentId`,`merchantTransactionId`,`Amount`,`Status`,`paymentMode`,`PaymentNote`,");
        sb.Append(" `Panel_Code`,`Panel_Id`,DATE_FORMAT(`dtEntry`,'%d-%b-%Y %h:%i %p')dtEntry");
        sb.Append(" FROM `payumoney_integration` WHERE 1=1");
        if (TransactionNo != "")
            sb.Append(" AND `merchantTransactionId`=@merchantTransactionId");
        if (FromDate != "")
            sb.Append("  AND `dtEntry` >=@FromDate");
        if (ToDate != "")
            sb.Append("  AND `dtEntry`<=@ToDate");
        if (Status != "")
            sb.Append("  AND `Status`=@Status");
        if (PccCode != "")
            sb.Append("  AND `Panel_Id`=@PanelID");
        dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, sb.ToString(),
            new MySqlParameter("@merchantTransactionId", TransactionNo.Trim()),
            new MySqlParameter("@FromDate", StartDate.ToString("yyyy-MM-dd") + " 00:00:00 "),
            new MySqlParameter("@ToDate", EndDate.ToString("yyyy-MM-dd") + " 23:59:59 "),
            new MySqlParameter("@Status", Status),
            new MySqlParameter("@PanelID", PccCode)).Tables[0];
        string rtrn = Util.getJson(dt);
        return rtrn;


    }

    [WebMethod(EnableSession = true)]
    public string GetQueryList(string type)
    {
        StringBuilder sb = new StringBuilder();

        if (type == "1")
        {

            sb.Append("SELECT Id,TYPE,SUBJECT,Detail,DATE_FORMAT(dtEntry,'%d-%b-%Y')dtEntry,isActive,MainHead");
            sb.Append(" FROM  Support_queryresponse where Type='Query' AND isActive=1");
        }
        else
        {

            sb.Append("SELECT Id,TYPE,SUBJECT,Detail,DATE_FORMAT(dtEntry,'%d-%b-%Y')dtEntry,isActive,MainHead");
            sb.Append(" FROM  Support_queryresponse where Type='Response' AND isActive=1");
        }


        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
                return JsonConvert.SerializeObject(new { status = true, response = string.Empty, responseDetail = Util.getJson(dt) });
            else
                return JsonConvert.SerializeObject(new { status = true, response = "No Record Found", responseDetail = string.Empty });
        }
    }

    [WebMethod(EnableSession = true)]
    public string GetQueryListByCategory(int CategoryId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT Id,TYPE,SUBJECT,Detail FROM  Support_queryresponse where Type='Query' AND isActive=1");
            if (CategoryId > 0)
            {
                sb.Append(" AND CategoryId=@CategoryId");
            }
            sb.Append(" ORDER BY SUBJECT");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@CategoryId", CategoryId)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = true, response = string.Empty, responseDetail = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = true, response = "No Record Found", responseDetail = string.Empty });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string DeleteQuery(string Id)
    {


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string Des = Util.GetString(MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE Support_queryresponse SET isActive=0,UpdatedByName=@UpdatedByName,UpdatedByID=@UpdatedByID,UpdatedAt=NOW() WHERE `Id`=@Id",
                new MySqlParameter("@Id", Id),
                new MySqlParameter("@UpdatedByID", UserInfo.ID),
                new MySqlParameter("@UpdatedByName", UserInfo.LoginName)));
            if (Des == "1")
            {
                return JsonConvert.SerializeObject(new { status = true, response = "Data Removed Successfully" });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = true, response = "Some error please try again" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    public string EditeQuery(string Id)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CategoryID,Id,TYPE,SUBJECT,Detail,DATE_FORMAT(dtEntry,'%d-%b-%Y')dtEntry,isActive,MainHead FROM  Support_queryresponse where Id=@ID",
                new MySqlParameter("@ID", Id)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = true, response = string.Empty, responseDetail = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = true, response = "No Record Found", responseDetail = string.Empty });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string UpdateQueryString(string Id, string type, string subject, string detail, string MainHead, string CategoryID)
    {


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            string Des = Util.GetString(MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE Support_queryresponse SET TYPE=@type, Subject=@subject, Detail=@detail,MainHead=@MainHead, CategoryID=@CategoryID WHERE `Id`=@Id",
                new MySqlParameter("@TYPE", type),
                new MySqlParameter("@Detail", detail),
                new MySqlParameter("@Subject", subject),
                new MySqlParameter("@Updatedate", DateTime.Now),
                new MySqlParameter("MainHead", MainHead),
                new MySqlParameter("@CategoryID", CategoryID),
                new MySqlParameter("@Id", Id)));
            if (Des == "1")
            {
                return JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully" });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Error" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string UpdateQuery2(string Id, string CategoryID, string subject, string detail)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string Des = Util.GetString(MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE Support_queryresponse SET  Subject=@subject, Detail=@detail, CategoryID=@CategoryID WHERE `Id`=@Id",
                new MySqlParameter("@Detail", detail),
                new MySqlParameter("@Subject", subject),
                new MySqlParameter("@Updatedate", DateTime.Now),
                new MySqlParameter("@CategoryID", CategoryID),
                new MySqlParameter("@Id", Id)));
            if (Des == "1")
            {
                return JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully" });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Error" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public class SupportProp
    {
        public string IssueCode { get; set; }
        public string EmpId { get; set; }
        public string EmpName { get; set; }
        public string SiteId { get; set; }
        public string Subject { get; set; }
        public string Msg { get; set; }
        public string AddDate { get; set; }

        public string PanelCode { get; set; }
        public string PanelId { get; set; }
        public string RegNo { get; set; }
        public string VialId { get; set; }
    }


}
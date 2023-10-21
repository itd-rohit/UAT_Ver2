using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;

public partial class Design_CallCenter_ViewTicket : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
        if (!IsPostBack)
        {
            txtFromTime.Text = "06:00:00";
            txtToTime.Text = "23:59:59";
            txtFormDate.Text = DateTime.Now.AddDays(-15).ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFormDate.Attributes.Add("readonly", "readonly");
            txtToDate.Attributes.Add("readonly", "readonly");
            if (Util.GetString(Session["IsPanel"]) == "Yes")
            {
                string PanelCode = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), System.Data.CommandType.Text, "SELECT `panel_code` FROM f_panel_master WHERE `EmployeeID`=@EmployeeID", new MySql.Data.MySqlClient.MySqlParameter("@EmployeeID", Util.GetString(Session["ID"]))));
                txtPcc.Text = PanelCode;
                txtPcc.Attributes.Add("readonly", "readonly");
            }
        }
    }

    [WebMethod]
    public static string GetUserList(string q)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Email as value,CONCAT(House_No,'~', CONCAT(Title,' ', NAME)) AS label FROM `employee_master` WHERE Email<>'' and IsActive=1 AND Employee_ID !='" + UserInfo.ID + "' AND NAME LIKE '" + q + "%' ");
        var data = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(data);
    }
    
    protected void btn_clickExportToExcel(object sender, EventArgs e)
    {
        Session["ReportName"] = "Customer care Report (Detail)";
        Session["Period"] = txtFormDate.Text + " " + txtFromTime.Text + "-" + txtToDate.Text + " " + txtToTime.Text;
        StringBuilder sb = new StringBuilder();

        sb.Append("    SELECT cm.Centre,DATE_FORMAT(s.`dtAdd`,'%d %b %Y %h:%i %p')`RaisedDateTime`, CONCAT('PIM',s.`ID`)`TicketNo`, ");
        sb.Append("  IFNULL(cm.`CentreCode`,'')`ClientCode`,s.`Subject` `Subject`,s.Message `Message`, ");
        sb.Append("  IF(IFNULL(s.`VialId`,'')<>'','Yes','No') AS 'Department',s.`VialId` `SINNo`,s.RegNo `UHIDNo`,s.Status, ");
        sb.Append("  (SELECT IF(`status`='Resolved' OR 'Closed',TIMEDIFF(dtEntry,dtAdd), TIMEDIFF(NOW(),dtEntry)) FROM support_error_reply WHERE TicketId=s.id   ORDER BY id DESC LIMIT 1) AS 'TAT Time'   ");


        sb.Append("  FROM `support_error_record` s   ");
        sb.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=s.`CentreID`  ");
        sb.Append(" WHERE s.`dtAdd` >='" + (Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + " " + txtFromTime.Text) + "' AND s.`dtAdd` <='" + (Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " " + txtToTime.Text) + "'");

        if (txtIssueNo.Text != string.Empty)
        {
            sb.Append(" AND s.`ID`='" + txtIssueNo.Text.ToUpper().Replace("PIM", "") + "' ");
        }
        if (txtVialId.Text != string.Empty)
        {
            sb.Append(" AND s.`VialId`='" + txtVialId.Text + "'");
        }
        if (txtRegNo.Text != string.Empty)
        {
            sb.Append(" AND s.`RegNo`='" + txtRegNo.Text + "'");
        }
        if (txtPcc.Text != string.Empty)
        {
            sb.Append(" AND cm.`CentreCode`='" + txtPcc.Text + "'");
        }

        sb.Append("  ORDER BY s.`ID`+0 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count < 1)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "key", "alert('No Record Found');", true);
        }
        else
        {
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "key1", "window.open('../Common/ExportToExcel.aspx');", true);
        }
    }

    private DataTable createtable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("SrNo");
        dt.Columns.Add("Description");
        dt.Columns.Add("No");
        return dt;
    }



    [WebMethod(EnableSession = true)]
    public static string GetStatus()
    {
        DataTable dt = StockReports.GetDataTable("SELECT STATUS  FROM  support_status_master where isActive=1 ");
        return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string GetIssueList(string FromDate, string ToDate, string IssueCode, string VialId, string FromBarcode, string ToBarcode, string RegNo, string PccCode, string Status, string TimeFrm, string TimeTo, string GroupID)
    {
        List<SupportProp> mylist = new List<SupportProp>();
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IFNULL(tag.`Lavel`,'0') Lavel, s.SubCategoryID,s.`centreID`,cgm.GroupName,emp.Email,sea.IsRead,sea.`EmployeeID`,CONCAT('PIM',s.`ID`)IssueCode,s.Status,s.`ID`,s.`EmpId`,s.`EmpName`,s.`Subject`,dtl.Message,s.`VialId`,s.`RegNo`, ");
        sb.Append(" DATE_FORMAT(s.`dtAdd`,'%d %b %Y %h:%i %p')dtAdd, ");
        sb.Append(" IFNULL(cm.`CentreCode`,'')CentreCode,IF(s.itemid=0,'',s.itemid)itemid, cat.CategoryName,scat.SubCategoryName,cm.Centre, ");
        sb.Append(" CONCAT(emp.Title,'',emp.NAME) AS EmpName,item.typeName, ");
        sb.Append(" CONCAT(emp1.Title,'',emp1.NAME) AS ResolvedBy, ");
        sb.Append(" (SELECT COUNT(*) FROM support_uploadedfile WHERE ticketID=s.id) AS Attachment, ");


        sb.Append(" IF(s.StatusId<>4, CONCAT(FLOOR(HOUR(TIMEDIFF(NOW(),dtAdd)) / 24), ' days ',MOD(HOUR(TIMEDIFF(NOW(),dtAdd)), 24), ' hr ',MINUTE(TIMEDIFF(NOW(),dtAdd)), ' min'),'')ElapsedTime, ");
        sb.Append(" IF(s.StatusId=4, CONCAT(FLOOR(HOUR(TIMEDIFF(resolveDateTime,dtAdd)) / 24), ' days ',MOD(HOUR(TIMEDIFF(resolveDateTime,dtAdd)), 24), ' hr ',MINUTE(TIMEDIFF(resolveDateTime,dtAdd)), ' min'),'')ResolvedDate ");
        sb.Append(" ,IF(s.StatusId=4,TIMESTAMPDIFF(SECOND, dtAdd, resolveDateTime),0)TATTimeDiffInSec, ");
        sb.Append(" IF(s.StatusId<>4,TIMESTAMPDIFF(SECOND, dtAdd, NOW()),0)ElapsedTimeDiffInSec ");

        sb.Append(" FROM `support_error_record` s ");
        sb.Append(" INNER JOIN `support_error_textdetails` dtl on dtl.TicketID=s.ID ");
        sb.Append(" INNER JOIN `cutomercare_category_master` cat on cat.ID=s.categoryID ");
        sb.Append(" INNER JOIN `cutomercare_subcategory_master` scat on scat.ID=s.SubCategoryID ");
        sb.Append(" INNER JOIN `cutomercare_Group_master` cgm on cgm.GroupID=s.GroupID ");
        sb.Append(" INNER JOIN `employee_master` emp on emp.Employee_ID=s.EmpId ");
        sb.Append(" LEFT JOIN `f_itemmaster` item on item.ItemID=s.itemid ");
        sb.Append(" INNER JOIN support_error_access sea ON sea.TicketID=s.ID AND sea.EmployeeID='" + UserInfo.ID + "' AND AccessDateTime<NOW()");
        sb.Append("  INNER JOIN `centre_master` cm ON cm.`centreID`=s.`centreID` ");
        sb.Append("  INNER JOIN `support_status_master` ser ON s.`StatusId`=ser.`ID`  ");
        sb.Append(" LEFT JOIN `employee_master` emp1 on emp1.Employee_ID=s.ResolvedBy ");
        sb.Append(" LEFT JOIN customercare_inquery_categoryEmployee tag ON  (tag.CentreID=s.`CentreID` OR tag.CentreID='0') AND (tag.`Inq_SubCategoryID`=s.`SubCategoryID`) AND tag.`EmployeeID`=sea.`EmployeeID` ");
        sb.Append("  WHERE s.`dtAdd` >='" + (Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm) + "' AND s.`dtAdd` <='" + (Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + TimeTo) + "'");

        if (IssueCode != string.Empty)
        {
            IssueCode = IssueCode.ToUpper().Replace("PIM", "");
            sb.Append(" AND s.`ID`='" + IssueCode + "' ");
        }
        if (VialId != string.Empty)
        {
            sb.Append(" AND s.`VialId`='" + VialId + "'");
        }
        if (FromBarcode != string.Empty && ToBarcode != string.Empty)
        {
            sb.Append(" AND s.VialId >= '" + FromBarcode.Trim() + "'");
            sb.Append(" AND s.VialId <= '" + ToBarcode.Trim() + "'");
        }
        if (RegNo != string.Empty)
        {
            sb.Append(" AND s.`RegNo`='" + RegNo + "'");
        }
        if (PccCode != string.Empty)
        {
            sb.Append(" AND fp.`Panel_Code`='" + PccCode + "'");
        }
        if (Status != string.Empty)
        {
            sb.Append(" AND s.`Status`='" + Status + "'");
        }
        if (GroupID != string.Empty)
        {
            sb.Append(" AND s.GroupID='" + GroupID + "'");
        }

        sb.Append(" GROUP BY ID   ORDER BY s.`ID` ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());



        return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string GetNotifyEmployee(string CenterID, string SubcategoryID, string Lavel, string Type)
    {
        string level = Lavel == "" ? "'none'" : Lavel.TrimEnd(',');
        DataTable dt = new DataTable(); 
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT '" + Type + "' Type, CONCAT(emp.`Title`,' ', emp.`Name`) EmpName, Email,EmployeeID,mobile,Lavel FROM customercare_inquery_categoryEmployee tag ");
        sb.Append(" INNER JOIN employee_master emp ON tag.`EmployeeID`=emp.`Employee_ID` ");
        sb.Append(" WHERE CentreID='" + CenterID + "' AND Inq_SubCategoryID='" + SubcategoryID + "'  AND Lavel IN(" + level + ")  ORDER BY Lavel ASC ");
        dt=StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count == 0)
        {
            sb = new StringBuilder();
            sb.Append(" SELECT '" + Type + "' Type, CONCAT(emp.`Title`,' ', emp.`Name`) EmpName, Email,EmployeeID,mobile, Lavel FROM customercare_inquery_categoryEmployee tag ");
            sb.Append(" INNER JOIN employee_master emp ON tag.`EmployeeID`=emp.`Employee_ID` ");
            sb.Append(" WHERE CentreID='0' AND Inq_SubCategoryID='" + SubcategoryID + "'  AND Lavel IN(" + level + ") ORDER BY Lavel ASC");
            dt = new DataTable(); 
            dt = StockReports.GetDataTable(sb.ToString());
        }
        return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string SendNotification(string Data)
    {
        try
        {
            JavaScriptSerializer Serializer = new JavaScriptSerializer();
            Emaildata email = Serializer.Deserialize<Emaildata>(Data);
            
            email.Email = email.Email.TrimEnd(',');
            if (email.Type == "SMS")
            {
                MySqlConnection con = new MySqlConnection();
                con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
                StringBuilder sb = new StringBuilder();
                ///
                try
                {     

                    StringBuilder Command = new StringBuilder();
                    Command.Append("INSERT INTO SMS (MOBILE_NO,SMS_TEXT,IsSend,UserID,SMS_Type,LedgerTransactionID) VALUES ");

                    var Mobiles = string.IsNullOrEmpty(email.Email) ? new string[] { } : email.Email.Split(',');
                    foreach (string mobile in Mobiles)
                    {
                        Command.Append(" (");
                        Command.Append("'" + mobile + "',");
                        Command.Append("'" + email.Message + "',");
                        Command.Append("'0',");
                        Command.Append("'-1',");
                        Command.Append("'Ticket',");
                        Command.Append("'" + email.TicketID + "'");
                        Command.Append(" ),");
                    }

                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Command.ToString().Trim().TrimEnd(','));
                    Tranx.Commit();
                    return "2";  ///
                }
                catch (Exception ex)
                {
                    Tranx.Rollback();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return "0";
                }
                finally
                {
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }
            else
            {
                var toAddress = string.IsNullOrEmpty(email.Email) ? new string[] { } : email.Email.Split(',');
                var ccAddress = new string[] { };
                var bccAddress = new string[] { };
                string Subject = email.Subject;
                string Message = GetdNotificationMailBody(email);
                string TicketID = Util.GetString(email.TicketID);

                SendNotificationMail(toAddress, Subject, Message, ccAddress, bccAddress, TicketID);
                return "1";
            }
           
        }
        catch (Exception ex)
        {            
            ClassLog cl = new ClassLog();
              cl.errLog(ex);
            return "0";
        }
    }

    public static string GetdNotificationMailBody(Emaildata email)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT");
        sb.Append(" ser.`Answer`,ser.`EmpId`,ser.`EmpName`, DATE_FORMAT(ser.`dtEntry`, '%d %b %Y %h:%i %p') dtEntry, ");
        sb.Append(" DATE_FORMAT(ser.`dtEntry`, '%d %b %Y %h:%i %p') ReplyDate,  DATE_FORMAT(ser.`dtEntry`, '%h:%i %p') ReplyTime, ");
        sb.Append("IFNULL((SELECT GROUP_CONCAT(filename,'',FileExt) FROM support_uploadedfile su WHERE su.ReplyID=ser.`Id` ORDER BY replyid ASC ),'') FileName");
        sb.Append("  FROM `support_error_reply` ser ");
        sb.Append("  WHERE ser.`TicketId` = '" + email.TicketID + "' ORDER BY ser.`dtEntry`");
       
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        int index = 0;
        StringBuilder table = new StringBuilder();
        table.Append("<div> Hi," + email.EmpName + " </div>");
        table.Append("<br/>");
        table.Append("<table border='0' width='1024px'>");
        table.Append("<tr>");
        table.Append(" <td width='124px' style='font-weight: 700'>Ticket No.:</td>");
        table.Append("<td width='233px' colspan='5'>" + email.TicketID + "</td>");
        table.Append("</tr>");
        table.Append("<tr>");
        table.Append("<td width='124px' style='font-weight: 700'>Group:</td>");
        table.Append("<td width='233px'>" + email.Group + "</td>");
        table.Append("<td width='100px' style='font-weight: 700'>Category:</td>");
        table.Append("<td width='233px'>" + email.Category + "</td>");
        table.Append("<td width='100px' style='font-weight: 700'>SubCategory:</td>");
        table.Append("<td width='233px'>" + email.SubCategory + "</td>");
        table.Append("</tr>");
        if (email.SinNo != null && email.UHIDNo != null && email.TestName != null)
        {
            table.Append("<tr>");
            if (email.SinNo != "" && email.SinNo != null)
            {
                table.Append("<td width='124px' style='font-weight: 700'>SIN No.:</td>");
                table.Append("<td width='233px'>" + email.SinNo + "</td>");
            }
            if (email.UHIDNo != "" && email.UHIDNo != null)
            {
                table.Append("<td width='100px' style='font-weight: 700'>UHID NO.:</td>");
                table.Append("<td width='233px'>" + email.UHIDNo + "</td>");
            }
            if (email.TestName != "" && email.TestName != null)
            {
                table.Append(" <td width='100px' style='font-weight: 700'>Test Name:</td>");
                table.Append("<td width='233px'>" + email.TestName + "</td>");
            }
            table.Append("  </tr>");
        }
        table.Append("<tr>");
        table.Append(" <td width='100px' style='font-weight: 700'>  Message: </td>");
        table.Append(" <td width='233px'colspan='3'>" + email.Message + "</td>");
        table.Append("</tr>");
        table.Append(" </table>");
        table.Append("<br/>");

        table.Append("<table border='1' width='1024px'>");
        table.Append("<thead><tr><th width='24px'>S.No.</th><th width='250px'>Replyed By</th><th width='180px'>Reply DateTime</th><th width='700px'>Description</th><th width='150px'>Attachment</th></tr></thead> ");
        table.Append(" <tbody>");
        foreach (DataRow row in dt.Rows)
        {

            table.Append("<tr><td>" + (index + 1) + "</td><td>" + row["EmpName"].ToString() + "</td><td>" + row["ReplyDate"].ToString() + "</td><td>" + row["Answer"].ToString() + "</td><td>" + row["FileName"].ToString() + "</td></tr>");//FileName
            index++;
        }

        table.Append("</tbody> ");
        table.Append("</table>");
        table.Append("<br/><br/><br/><br/><br/>");
        table.Append("<div> This is an automatically generated email. please do not reply to it .</div>");

        return table.ToString();

    }
    public static void SendNotificationMail(string[] toAddress, string Subject, string Message, string[] ccAddress, string[] bccAddress, string TiketId)
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

    [WebMethod(EnableSession = true)]
    public static string SendMail(string Data)
    {
        try
        {
            JavaScriptSerializer Serializer = new JavaScriptSerializer();
            Emaildata email = Serializer.Deserialize<Emaildata>(Data);

            email.Email = email.Email.TrimEnd(',');
            email.CcEmail = email.CcEmail.TrimEnd(',');
            var toAddress = string.IsNullOrEmpty(email.Email) ? new string[] { } : email.Email.Split(',');
            var ccAddress = string.IsNullOrEmpty(email.CcEmail) ? new string[] { } : email.CcEmail.Split(',');
            var bccAddress = new string[] { };
            string Subject = email.Subject;
            string Message = GetdNotificationMailBody(email);
            string TicketID = Util.GetString(email.TicketID);

            SendNotificationMail(toAddress, Subject, Message, ccAddress, bccAddress, TicketID);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

}

public class Emaildata
{
    public int TicketID { get; set; }
    public string Group { get; set; }
    public string Category { get; set; }
    public string SubCategory { get; set; }
    public string SinNo { get; set; }
    public string UHIDNo { get; set; }
    public string TestName { get; set; }
    public string Subject { get; set; }
    public string Message { get; set; }
    public string Email { get; set; }
    public string CcEmail { get; set; }
    
    public string EmpName { get; set; }
    public string Type { get; set; }
}

public class SupportProp
{


    private string _IssueCode;
    private string _EmpId;
    private string _EmpName;
    private string _Subject;
    private string _Msg;
    private string _AddDate;
    private string _PanelCode;
    private string _PanelId;
    private string _RegNo;
    private string _VialId;
    public string IssueCode { get { return _IssueCode; } set { _IssueCode = value; } }
    public string EmpId { get { return _EmpId; } set { _EmpId = value; } }
    public string EmpName { get { return _EmpName; } set { _EmpName = value; } }
    public string Subject { get { return _Subject; } set { _Subject = value; } }
    public string Msg { get { return _Msg; } set { _Msg = value; } }
    public string AddDate { get { return _AddDate; } set { _AddDate = value; } }
    public string PanelCode { get { return _PanelCode; } set { _PanelCode = value; } }
    public string PanelId { get { return _PanelId; } set { _PanelId = value; } }
    public string RegNo { get { return _RegNo; } set { _RegNo = value; } }
    public string VialId { get { return _VialId; } set { _VialId = value; } }
}
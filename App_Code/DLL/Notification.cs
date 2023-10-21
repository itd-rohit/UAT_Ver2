using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for Notification_Insert
/// </summary>
public class Notification
{
    public Notification()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static string notificationInsert(int notificationID, string UpdatedID, MySqlTransaction tnx, int roleID = 0, string notificationDate = "", int employee_ID = 0, string Message = "")
    {
        try
        {

            int notification = 1;
            if (notificationID == 1) //New Ticket
            {
                notification = notificationInsert(employee_ID, 0, 1, "/Design/CallCenter/ViewTicket.aspx", Message, "support_error_record", "ID", "Ticketing", UpdatedID, notificationDate, tnx);

            }
            if (notificationID == 2) //Answer Ticket
            {
                notification = notificationInsert(employee_ID, 0, 2, "/Design/CallCenter/ViewTicket.aspx", Message, "support_error_record", "ID", "Ticketing", UpdatedID, notificationDate, tnx);

            }



            return "1";
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
            return "0";
        }
    }

    public static int notificationInsert(int employee_ID, int RoleID, int notificationID, string URL, string Message, string tableName, string ColumnName, string inputType, string UpdatedID, string notificationDate = "", MySqlTransaction tnx = null)
    {
        try
        {
            if (notificationDate == "")
                notificationDate = "0001-01-01";
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO notification_detail(Employee_ID,RoleID,PagePath,NotificationID,Message,tableName,ColumnName,");
            sb.Append(" inputType,UpdatedID,notificationDate) VALUES(@Employee_ID,@RoleID,@PagePath,@NotificationID,@Message,@tableName,@ColumnName,");
            sb.Append(" @inputType,@UpdatedID,@notificationDate)");
            sb.Append("");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
             new MySqlParameter("@Employee_ID", employee_ID), new MySqlParameter("@RoleID", RoleID),
            new MySqlParameter("@PagePath", URL), new MySqlParameter("@NotificationID", notificationID), new MySqlParameter("@Message", Message),
            new MySqlParameter("@tableName", tableName), new MySqlParameter("@ColumnName", ColumnName), new MySqlParameter("@inputType", inputType),
            new MySqlParameter("@UpdatedID", UpdatedID), new MySqlParameter("@notificationDate", Util.GetDateTime(notificationDate).ToString("yyyy-MM-dd HH:mm:ss")));





            return 1;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
    }

    public static int updateNotification(string UpdatedID, string EmployeeID = "", string RoleID = "", int notificationID = 0, MySqlTransaction tnx = null, string InputType = "", string NotifyID = "")
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE notification_detail SET IsView=1 WHERE UpdatedID='" + UpdatedID + "' ");
            // if (notificationID != 0)
            //     sb.Append(" AND notificationID='" + notificationID + "'");
            if (InputType != string.Empty)
                sb.Append(" AND InputType='" + InputType + "'");
            if (EmployeeID != string.Empty)
                sb.Append(" AND Employee_ID='" + EmployeeID + "'");
            if (RoleID != string.Empty)
                sb.Append(" AND RoleID='" + RoleID + "'");
            if (NotifyID != string.Empty)
                sb.Append(" AND ID='" + NotifyID + "'");
            if (tnx != null)
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            else
                StockReports.ExecuteDML(sb.ToString());
            return 1;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
    }


}
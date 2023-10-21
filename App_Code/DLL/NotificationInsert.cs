using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Net.NetworkInformation;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using System.Linq;
using System.Reflection;
using AjaxControlToolkit;
/// <summary>
/// Summary description for BindDate
/// </summary>
public class NotificationInsert
{
    public NotificationInsert()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static int notificationInsert(int notificationID, int employee_ID, int RoleID, string URL, string Message, string tableName, string ColumnName, string inputType, string notificationDate = "", MySqlTransaction tnx = null, string RoleIDConcat = "", string doctor_ID = "")
    {
        try
        {
            if (notificationDate == "")
                notificationDate = "0001-01-01";


            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO notification_detail(Employee_ID,RoleID,Message,PagePath,NotificationID,InputType,CreatedByID,CreatedBy,tableName,ColumnName)");
            sb.Append(" VALUES(@Employee_ID,@RoleID,@Message,@PagePath,@NotificationID,@InputType,@CreatedByID,@CreatedBy,@tableName,@ColumnName) ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@Employee_ID", employee_ID),
               new MySqlParameter("@RoleID", RoleID),
               new MySqlParameter("@Message", Message),
               new MySqlParameter("@PagePath", URL),
               new MySqlParameter("@NotificationID", notificationID),
               new MySqlParameter("@InputType", inputType),
               new MySqlParameter("@CreatedByID", UserInfo.ID),
               new MySqlParameter("@CreatedBy", UserInfo.LoginName),
               new MySqlParameter("@tableName", tableName),
               new MySqlParameter("@ColumnName", ColumnName)
               );
            return 1;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
    }

    public static int updateNotification(string UpdatedID, string EmployeeID = "", string RoleID = "", int notificationID = 0, MySqlTransaction tnx = null, string InputType = "")
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE notification_detail SET IsView=1 WHERE UpdatedID='" + UpdatedID + "' ");
            if (notificationID != 0)
                sb.Append(" AND notificationID='" + notificationID + "'");
            if (InputType != "")
                sb.Append(" AND InputType='" + InputType + "'");
            if (EmployeeID != "")
                sb.Append(" AND Employee_ID='" + EmployeeID + "'");
            if (RoleID != "")
                sb.Append(" AND RoleID='" + RoleID + "'");
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

    public static void getCurrentDate(TextBox toDate, TextBox fromDate)
    {
        toDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        fromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        toDate.Attributes.Add("readOnly", "true");
        fromDate.Attributes.Add("readOnly", "true");
    }

}
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
public class Notification_Insert
{
    public Notification_Insert()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static string notificationInsert(int notificationID, string UpdatedID, MySqlTransaction tnx, int LedgerTransactionID, string LedgertransactionNo, int roleID = 0, int employee_ID = 0, string Message = "", string notificationDate = "", string Tablename = "", string ColumnName = "", string InputType = "")
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            DataTable dtdetail = new DataTable();
            if (notificationID == 1)
            {
                sb = new StringBuilder();
                sb.Append(" SELECT RoleID,EmployeeID FROM f_login  ");
                sb.Append(" WHERE Centreid=(SELECT CentreID FROM patient_labinvestigation_opd WHERE LedgerTransactionID=@LedgerTransactionID  ");
                sb.Append(" AND  isSampleCollected='R'  ");
                sb.Append(" LIMIT 1) AND RoleID=9  ");
                using (dtdetail = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)).Tables[0])
                {
                    if (dtdetail.Rows.Count > 0)
                    {
                        for (int i = 0; i < dtdetail.Rows.Count; i++)
                        {
                           int returnStatus= NotificationInsert.notificationInsert(notificationID, Util.GetInt(dtdetail.Rows[i]["EmployeeID"]), Util.GetInt(dtdetail.Rows[i]["RoleID"]),"",                                 Message,Tablename, ColumnName, InputType, "", tnx, "");
                           if (returnStatus == 0)
                           {
                               return "0";
                           }
                        }

                    }
                }

            }
            else if (notificationID == 2) 
            {
                sb = new StringBuilder();
                sb.Append(" SELECT RoleID,EmployeeID FROM f_login  ");
                sb.Append(" WHERE Centreid=(SELECT CentreID FROM f_ledgertransaction WHERE LedgerTransactionNo=@LedgerTransactionNo  ");
                sb.Append(" LIMIT 1) AND RoleID=9  ");
  
                using (dtdetail = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                               new MySqlParameter("@LedgerTransactionNo", LedgertransactionNo)).Tables[0])
                {
                    if (dtdetail.Rows.Count > 0)
                    {
                        for (int i = 0; i < dtdetail.Rows.Count; i++)
                        {
                            NotificationInsert.notificationInsert(notificationID, Util.GetInt(dtdetail.Rows[i]["EmployeeID"]), Util.GetInt(dtdetail.Rows[i]["RoleID"]), "",                                 Message,Tablename, ColumnName, InputType, "", tnx, "");
                        }

                    }
                }
            }
            else if (notificationID == 3)
            {
                sb = new StringBuilder();
                sb.Append(" SELECT RoleID,EmployeeID FROM f_login  ");
                sb.Append(" WHERE Centreid=(SELECT CentreID FROM f_ledgertransaction WHERE LedgerTransactionNo=@LedgerTransactionNo  ");
                sb.Append(" LIMIT 1) AND RoleID=211  ");

                using (dtdetail = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                               new MySqlParameter("@LedgerTransactionNo", LedgertransactionNo)).Tables[0])
                {
                    if (dtdetail.Rows.Count > 0)
                    {
                        for (int i = 0; i < dtdetail.Rows.Count; i++)
                        {
                            NotificationInsert.notificationInsert(notificationID, Util.GetInt(dtdetail.Rows[i]["EmployeeID"]), Util.GetInt(dtdetail.Rows[i]["RoleID"]), "", Message, Tablename, ColumnName, InputType, "", tnx, "");
                        }

                    }
                }
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
    public static string notificationDelete(int notificationID, string UpdatedID, MySqlTransaction tnx, int LedgerTransactionID, string LedgertransactionNo, int roleID = 0, int employee_ID = 0, string Message = "", string notificationDate = "", string Tablename = "", string ColumnName = "", string InputType = "")
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            DataTable dtdetail = new DataTable();
           

            return "1";
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
            return "";
        }
    }
    public static int activeNotification()
    {


        return 1;
    }

}
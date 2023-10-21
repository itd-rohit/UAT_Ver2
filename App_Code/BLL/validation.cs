using System;
using System.Data;
using System.Web;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

/// <summary>
/// Summary description for validation
/// </summary>
public class validation
{

    public bool datevalidation(DateTime fromdate)
    {
        if (HttpContext.Current.Session["RoleID"].ToString() == "9")
        {
            DateTime currentdatetime = new DateTime();
            currentdatetime = DateTime.Now;
            if (fromdate > currentdatetime)
            {
                return false;
            }
            if (currentdatetime.Day > 7)
            {
                if (fromdate.Date < Util.GetDateTime("01-" + DateTime.Now.ToString("MMM-yyyy")).Date)
                {
                    return false;
                }
                else
                    return true;
            }
            else
            {
                if (fromdate.Date < Util.GetDateTime("01-" + DateTime.Now.AddMonths(-1).ToString("MMM-yyyy")).Date)
                {
                    return false;
                }
                else
                    return true;
            }
        }
        else
            return true;
    }
    public string lock_PrintReport_ByPanelMaster_TestID(string Test_ID)
    {
        Test_ID = Test_ID.TrimEnd(',');
        int len = Util.GetInt(Test_ID.Split(',').Length);
        string[] TestIDList = new string[len];
        TestIDList = Test_ID.Split(',');

        string newTest_ID = "";

        for (int i = 0; i < len; i++)
        {
            StringBuilder sbPanleLock = new StringBuilder();
            sbPanleLock.Append(" SELECT COUNT(*) FROM  ");
            sbPanleLock.AppendFormat(" (SELECT LedgerTransactionID FROM `patient_labinvestigation_opd` plo WHERE plo.test_ID={0}) plo ", TestIDList[i]);
            sbPanleLock.Append(" INNER JOIN `f_ledgertransaction` lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` where IF(lt.IsCredit='0' AND lt.OutstandingStatus=0,IF(Adjustment  = NetAmount ,'1','0'),'1' )=0 ");
            int PanelLock = Util.GetInt(StockReports.ExecuteScalar(sbPanleLock.ToString()));
            if (PanelLock == 0)
            {
                newTest_ID += TestIDList[i] + ",";
            }
        }
        newTest_ID = newTest_ID.TrimEnd(',');
        return newTest_ID;
    }
    public string checkdiscountapproved(string Test_ID)
    {

        Test_ID = Test_ID.TrimEnd(',');
        int len = Util.GetInt(Test_ID.Split(',').Length);
        string[] TestIDList = new string[len];
        TestIDList = Test_ID.Split(',');
        string newTest_ID = "";
        for (int i = 0; i < len; i++)
        {
            int discountnotapp = Util.GetInt(StockReports.ExecuteScalar(string.Format("SELECT COUNT(*) FROM `f_ledgertransaction` WHERE discountid<>0 AND DiscountApprovedByID<>0 AND `IsDiscountApproved`=0 AND `DiscountOnTotal`>0 AND `LedgerTransactionNo`=(SELECT LedgerTransactionNo FROM `patient_labinvestigation_opd` plo WHERE plo.test_ID={0}) ", TestIDList[i])));
            if (discountnotapp == 0)
            {
                newTest_ID += TestIDList[i] + ",";
            }
        }
        newTest_ID = newTest_ID.TrimEnd(',');
        return newTest_ID;
    }
    public string checkCancelByInterface(string Test_ID)
    {

        Test_ID = Test_ID.TrimEnd(',');
        int len = Util.GetInt(Test_ID.Split(',').Length);
        string[] TestIDList = new string[len];
        TestIDList = Test_ID.Split(',');
        string newTest_ID = "";
        for (int i = 0; i < len; i++)
        {
            int discountnotapp = Util.GetInt(StockReports.ExecuteScalar(string.Format("SELECT COUNT(*)  FROM `patient_labinvestigation_opd` plo WHERE plo.test_ID={0} and CancelByInterface=1 and `Interface_companyName`<>'' ", TestIDList[i])));
            if (discountnotapp == 0)
            {
                newTest_ID += TestIDList[i] + ",";
            }
        }
        newTest_ID = newTest_ID.TrimEnd(',');
        return newTest_ID;
    }
    public static int chkRefund(string LabNo)
    {
        return Util.GetInt(StockReports.ExecuteScalar(string.Format("SELECT COUNT(1) FROM opd_refund WHERE new_ledgertransactionno='{0}' OR old_ledgertransactionno='{0}' ", LabNo)));
    }

    public string isPanelLocked(List<string> Test_ID)
    {
        String retValue = "0";
        int isPanelLocked = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string dtPanelLockData = string.Empty;
            StringBuilder sbLocked = new StringBuilder();
            sbLocked.Append(" SELECT fpm.`Panel_ID` FROM f_panel_master fpm ");
            sbLocked.Append(" INNER JOIN f_ledgertransaction lt ON lt.`Panel_ID`=fpm.`Panel_ID` ");
            sbLocked.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sbLocked.Append(" WHERE plo.test_id in({0}) ");
            using (MySqlCommand cmd = new MySqlCommand(string.Format(sbLocked.ToString(), string.Join(",", Test_ID)), con))
            {
                for (int i = 0; i < Test_ID.Count; i++)
                {
                    cmd.Parameters.AddWithValue(string.Concat("@Test_IDParam", i), Test_ID[i]);
                }
                dtPanelLockData = Util.GetString(cmd.ExecuteScalar());
            }
            if (dtPanelLockData != string.Empty)
            {
                isPanelLocked = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT isPanelLock(@dtPanelLockData,'Printing',0) ",
                   new MySqlParameter("@dtPanelLockData", Util.GetString(dtPanelLockData))));
            }
            if (isPanelLocked > 0)
            {
                retValue = "-3";
            }
            else
            {
                retValue = String.Join(",", Test_ID);
            }
            return retValue;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "-3";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public string getCentreType(string TID)
    {
        return StockReports.ExecuteScalar(string.Format("SELECT cm.Type1 Type FROM Centre_master cm INNER JOIN `patient_labinvestigation_opd` plo ON plo.`CentreID`=cm.`CentreID` WHERE plo.test_id in({0}) ", TID.TrimEnd(',')));
    }
}

using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_DashBoard_TATPendingDashBoard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

        }
    }

    
        [WebMethod]
    public static string GetPopdata1(string date, string Centreid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        string CentreID = "";
        try
        {
            if (Centreid == "")
            {
                CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
            }
            else
            {
                CentreID = Centreid;
            }

            StringBuilder sb = new StringBuilder();





            sb.Append(" SELECT plo.LedgerTransactionNo,plo.BarcodeNo,lt.Pname,plo.`ItemName` TestName FROM  `patient_labinvestigation_opd` plo   INNER JOIN patient_master pm     ON pm.patient_id = plo.patient_id   INNER JOIN f_ledgertransaction lt ");
            sb.Append(" ON plo.`LedgerTransactionID` = lt.`LedgerTransactionID`  ");
            sb.Append(" AND lt.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND lt.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");

            sb.Append(" AND (lt.CentreID IN (SELECT ca.CentreAccess FROM  centre_access ca       WHERE ca.Centreid  IN(" + CentreID + ")) OR lt.CentreID IN(" + CentreID + ")) INNER JOIN f_panel_master fpm ");
            sb.Append(" ON lt.`Panel_ID` = fpm.`Panel_ID`   INNER JOIN f_subcategorymaster obm ON obm.subcategoryid = plo.subcategoryid   INNER JOIN f_itemmaster it ON it.Type_ID = plo.Investigation_ID     AND plo.IsReporting = 1 ");
            sb.Append(" GROUP BY plo.`ItemName`,  plo.LedgerTransactionNo ORDER BY plo.LedgerTransactionNo,  plo.barcodeno,  plo.`ItemName`  ");
            DataTable dtPendingDataSra = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


            return JsonConvert.SerializeObject(new { status = true,  dtPendingDataSra });

        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false });
        }
        finally
        {
            if (con.State == ConnectionState.Open)
            {
                con.Close();
                con.Dispose();
            }

        }
    }


        [WebMethod]
        public static string GetPopdata2(string date, string Centreid)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            string CentreID = "";
            try
            {
                if (Centreid == "")
                {
                    CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
                }
                else
                {
                    CentreID = Centreid;
                }

                StringBuilder sb = new StringBuilder();




                sb.Append(" SELECT plo.LedgerTransactionNo,plo.BarcodeNo,lt.Pname,plo.`ItemName` TestName ");
                sb.Append(" FROM `patient_labinvestigation_opd` plo   ");
                sb.Append(" INNER JOIN Report_Unapprove ru ON ru.`Test_ID`=plo.`Test_ID` INNER JOIN `f_ledgertransaction` lt ON  lt.LedgerTransactionID=plo.LedgerTransactionID   ");
                sb.Append(" AND ru.`UnapproveDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND ru.`UnapproveDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'    ");
                sb.Append(" WHERE plo.isreporting=1 AND plo.`Approved`=1 AND plo.`TestCentreID`  IN(" + CentreID + ") ");
                
                DataTable dtPendingDataSra = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


                return JsonConvert.SerializeObject(new { status = true, dtPendingDataSra });

            }

            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return JsonConvert.SerializeObject(new { status = false });
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                    con.Dispose();
                }

            }
        }


        [WebMethod]
        public static string GetPopdata3(string date, string Centreid)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            string CentreID = "";
            try
            {
                if (Centreid == "")
                {
                    CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
                }
                else
                {
                    CentreID = Centreid;
                }

                StringBuilder sb = new StringBuilder();



                sb.Append(" SELECT   plo.LedgerTransactionNo,plo.BarcodeNo,lt.Pname,plo.`ItemName` TestName  ");
                sb.Append(" FROM `patient_labinvestigation_opd` plo      ");
                sb.Append("  INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                sb.Append(" WHERE  plo.`isrerun`=1 AND plo.`TestCentreID`IN(" + CentreID + ")     ");//lt.`IsCancel`=0
                sb.Append(" AND lt.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND lt.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");

                DataTable dtPendingDataSra = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


                return JsonConvert.SerializeObject(new { status = true, dtPendingDataSra });

            }

            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return JsonConvert.SerializeObject(new { status = false });
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                    con.Dispose();
                }

            }
        }

        [WebMethod]
        public static string GetPopdata4(string date, string Centreid)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            string CentreID = "";
            try
            {
                if (Centreid == "")
                {
                    CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
                }
                else
                {
                    CentreID = Centreid;
                }

                StringBuilder sb = new StringBuilder();


                sb.Append(" SELECT   plo.LedgerTransactionNo,plo.BarcodeNo,lt.Pname,plo.`ItemName` TestName  ");
                sb.Append(" FROM patient_sample_Rejection  psr    ");
                sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID=psr.test_ID  INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                sb.Append(" AND psr.EntDate>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' ");
                sb.Append(" AND psr.EntDate<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  AND plo.CentreID IN(" + CentreID + ") ");

                DataTable dtPendingDataSra = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


                return JsonConvert.SerializeObject(new { status = true, dtPendingDataSra });

            }

            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return JsonConvert.SerializeObject(new { status = false });
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                    con.Dispose();
                }

            }
        }


        [WebMethod]
        public static string GetPopdata5(string date, string Centreid)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            string CentreID = "";
            try
            {
                if (Centreid == "")
                {
                    CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
                }
                else
                {
                    CentreID = Centreid;
                }

                StringBuilder sb = new StringBuilder();

                sb.Append("  SELECT  ");
                sb.Append("    pli.LedgerTransactionNo,pli.BarcodeNo,lt.Pname,pli.`ItemName` TestName   ");
                //sb.Append(" FROM `patient_labobservation_opd` plo    ");
                sb.Append(" From `patient_labinvestigation_opd` pli ");
                sb.Append("  INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID`    ");
                sb.Append(" WHERE  pli.Result_Flag=1   ");
                sb.Append(" AND pli.IsNormalResult=2  ");
                sb.Append(" AND pli.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
                sb.Append(" AND pli.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  AND pli.`TestCentreID`IN(" + CentreID + ")   ");

                DataTable dtPendingDataSra = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


                return JsonConvert.SerializeObject(new { status = true, dtPendingDataSra });

            }

            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return JsonConvert.SerializeObject(new { status = false });
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                    con.Dispose();
                }

            }
        }

        [WebMethod]
        public static string GetPopdata6(string date, string Centreid)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            string CentreID = "";
            try
            {
                if (Centreid == "")
                {
                    CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
                }
                else
                {
                    CentreID = Centreid;
                }

                StringBuilder sb = new StringBuilder();

                sb.Append(" SELECT  pli.LedgerTransactionNo,pli.BarcodeNo,lt.Pname,pli.`ItemName` TestName    ");
                sb.Append(" FROM `patient_labinvestigation_opd` pli   ");
                sb.Append(" INNER JOIN `patient_labobservation_opd` plo ON plo.`Test_ID`=pli.`Test_ID`  INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID`   ");
                sb.Append(" INNER JOIN Email_Critical ec    ON ec.`LedgerTransactionNo`=pli.`LedgerTransactionNo` AND plo.`LabObservation_ID`=ec.`LabObservation_ID`   ");
                sb.Append(" LEFT JOIN sms s ON s.`LedgerTransactionID`=pli.`LedgerTransactionID`      ");
                sb.Append(" AND s.`SMS_Type`='Critical'   ");
                sb.Append(" WHERE   ");
                sb.Append(" pli.`Approved`=1 AND pli.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND pli.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'            ");
                sb.Append(" AND pli.isreporting=1  AND plo.`IsCritical`=1 AND IFNULL(plo.`Value`,'') <>''   AND pli.centreid IN(" + CentreID + ")   ");
          
                DataTable dtPendingDataSra = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


                return JsonConvert.SerializeObject(new { status = true, dtPendingDataSra });

            }

            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return JsonConvert.SerializeObject(new { status = false });
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                    con.Dispose();
                }

            }
        }

        [WebMethod]
        public static string GetPopdata7(string date, string Centreid)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            string CentreID = "";
            try
            {
                if (Centreid == "")
                {
                    CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
                }
                else
                {
                    CentreID = Centreid;
                }

                StringBuilder sb = new StringBuilder();

                sb.Append("  SELECT plo.LedgerTransactionNo,plo.BarcodeNo,lt.Pname,plo.`ItemName` TestName  FROM patient_labinvestigation_opd plo  INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  WHERE   plo.LabOutsrcID<>0 AND plo.`TestCentreID` IN(" + CentreID + ") ");
                sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");

                DataTable dtPendingDataSra = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


                return JsonConvert.SerializeObject(new { status = true, dtPendingDataSra });

            }

            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return JsonConvert.SerializeObject(new { status = false });
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                    con.Dispose();
                }

            }
        }


        [WebMethod]
        public static string GetPopdata8(string date, string Centreid)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            string CentreID = "";
            try
            {
                if (Centreid == "")
                {
                    CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
                }
                else
                {
                    CentreID = Centreid;
                }

                StringBuilder sb = new StringBuilder();

                sb.Append(" SELECT plo.LedgerTransactionNo,plo.BarcodeNo,lt.Pname,plo.`ItemName` TestName   FROM patient_labinvestigation_opd plo INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");
                sb.Append("  WHERE plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' ");
                sb.Append("  AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
                // sb.Append("  AND  plo.CentreID=plo.testcentreid");
                sb.Append("  AND plo.`testcentreid`IN(" + CentreID + ") AND plo.LabOutsrcID=0   ");

                DataTable dtPendingDataSra = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


                return JsonConvert.SerializeObject(new { status = true, dtPendingDataSra });

            }

            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return JsonConvert.SerializeObject(new { status = false });
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                    con.Dispose();
                }

            }
        }

        [WebMethod]
        public static string GetPopdata9(string date, string Centreid)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            string CentreID = "";
            try
            {
                if (Centreid == "")
                {
                    CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
                }
                else
                {
                    CentreID = Centreid;
                }

                StringBuilder sb = new StringBuilder();

                sb.Append(" SELECT plo.LedgerTransactionNo,plo.BarcodeNo,lt.Pname,plo.`ItemName` TestName  ");
                sb.Append(" FROM `patient_labinvestigation_opd` plo   INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`    ");
                sb.Append(" WHERE   plo.ishold=1 AND plo.`TestCentreID`IN(" + CentreID + ")     ");
                sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'   ");

                DataTable dtPendingDataSra = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


                return JsonConvert.SerializeObject(new { status = true, dtPendingDataSra });

            }

            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return JsonConvert.SerializeObject(new { status = false });
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                    con.Dispose();
                }

            }
        }


        [WebMethod]
        public static string GetPopdata10(string date, string Centreid)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            string CentreID = "";
            try
            {
                if (Centreid == "")
                {
                    CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
                }
                else
                {
                    CentreID = Centreid;
                }

                StringBuilder sb = new StringBuilder();

                sb.Append(" SELECT  plo.LedgerTransactionNo,plo.BarcodeNo,lt.Pname,plo.`ItemName` TestName FROM  f_ledgertransaction lt       INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                sb.Append(" where lt.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
                sb.Append(" AND lt.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
                sb.Append(" AND lt.`centreid`IN(" + CentreID + ") GROUP BY plo.LedgerTransactionNo ");

                DataTable dtPendingDataSra = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


                return JsonConvert.SerializeObject(new { status = true, dtPendingDataSra });

            }

            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return JsonConvert.SerializeObject(new { status = false });
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                    con.Dispose();
                }

            }
        }

        [WebMethod]
        public static string GetPopdata11(string date, string Centreid)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            string CentreID = "";
            try
            {
                if (Centreid == "")
                {
                    CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
                }
                else
                {
                    CentreID = Centreid;
                }

                StringBuilder sb = new StringBuilder();

                sb.Append(" SELECT  plo.LedgerTransactionNo,plo.BarcodeNo,lt.Pname,plo.`ItemName` TestName FROM f_ledgertransaction lt INNER JOIN `patient_labinvestigation_opd` plo ON plo.LedgerTransactionID=lt.LedgerTransactionID   ");
                sb.Append(" where lt.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
                sb.Append(" AND lt.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
                sb.Append(" AND lt.`centreid`IN(" + CentreID + ") ");

                DataTable dtPendingDataSra = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


                return JsonConvert.SerializeObject(new { status = true, dtPendingDataSra });

            }

            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return JsonConvert.SerializeObject(new { status = false });
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                    con.Dispose();
                }

            }
        }

        [WebMethod]
        public static string GetPopdata12(string date, string Centreid)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            string CentreID = "";
            try
            {
                if (Centreid == "")
                {
                    CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
                }
                else
                {
                    CentreID = Centreid;
                }

                StringBuilder sb = new StringBuilder();

                sb.Append(" SELECT  plo.LedgerTransactionNo,plo.BarcodeNo,lt.Pname,plo.`ItemName` TestName  FROM `f_ledgertransaction` lt INNER JOIN `patient_labinvestigation_opd` plo ON plo.LedgerTransactionID=lt.LedgerTransactionID  ");
                sb.Append(" where lt.DiscountOnTotal<>0  and lt.`CentreID`  IN(" + CentreID + ") AND lt.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND lt.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  GROUP BY plo.LedgerTransactionNo ");

                DataTable dtPendingDataSra = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


                return JsonConvert.SerializeObject(new { status = true, dtPendingDataSra });

            }

            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return JsonConvert.SerializeObject(new { status = false });
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                    con.Dispose();
                }

            }
        }



    [WebMethod]
    public static string bindTotalCount(string date, string Centreid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        string CentreID = "";
        try
        {
            if (Centreid == "")
            {
                CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
            }
            else
            {
                CentreID = Centreid;
            }

            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT TotalSample, ");
            sb.Append(" (SELECT COUNT(1) ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo   ");

            sb.Append(" INNER JOIN Report_Unapprove ru ON ru.`Test_ID`=plo.`Test_ID`  ");
            sb.Append(" AND ru.`UnapproveDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND ru.`UnapproveDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'    ");
            sb.Append(" WHERE plo.isreporting=1 AND plo.`Approved`=1 AND plo.`TestCentreID`  IN(" + CentreID + ")) AS AmendmentSample, ");

            sb.Append(" (SELECT COUNT(*) FROM (SELECT plo.`LedgerTransactionID` FROM  `patient_labinvestigation_opd` plo   INNER JOIN patient_master pm     ON pm.patient_id = plo.patient_id   INNER JOIN f_ledgertransaction lt ");
    sb.Append(" ON plo.`LedgerTransactionID` = lt.`LedgerTransactionID`  "); 
	sb.Append(" AND lt.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND lt.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
	
	sb.Append(" AND (lt.CentreID IN (SELECT ca.CentreAccess FROM  centre_access ca       WHERE ca.Centreid  IN(" + CentreID + ")) OR lt.CentreID IN(" + CentreID + ")) INNER JOIN f_panel_master fpm ");
     sb.Append(" ON lt.`Panel_ID` = fpm.`Panel_ID`   INNER JOIN f_subcategorymaster obm ON obm.subcategoryid = plo.subcategoryid   INNER JOIN f_itemmaster it ON it.Type_ID = plo.Investigation_ID     AND plo.IsReporting = 1 ");
 sb.Append(" GROUP BY plo.`ItemName`,  plo.LedgerTransactionNo ORDER BY plo.LedgerTransactionNo,  plo.barcodeno,  plo.`ItemName` ) t) AS  `TotalpatientCount`, ");


            sb.Append(" (SELECT COUNT(1) FROM `f_ledgertransaction` lt ");
            sb.Append(" where lt.DiscountOnTotal<>0  and lt.`CentreID`  IN(" + CentreID + ") AND lt.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND lt.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "') AS  `TotalDiscountpatient`, ");

            sb.Append("  (SELECT COUNT(LabOutsrcID) FROM patient_labinvestigation_opd plo WHERE   plo.LabOutsrcID<>0 AND plo.`TestCentreID` IN(" + CentreID + ") ");
            sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "') AS  `OutsourceCount`, ");


  //sb.Append(" (SELECT COUNT(*) FROM support_error_record s ");
            //sb.Append(" INNER JOIN support_error_access sea ON sea.TicketID=s.ID AND sea.Employee_ID='" + UserInfo.ID + "' AND AccessDateTime<NOW()");
            //sb.Append(" WHERE s.`active` = 1  AND s.dtAdd>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND s.dtAdd<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "') AS TicketRaised, ");


           // sb.Append(" ( SELECT  ");
           // sb.Append("   COUNT(1) ");
           // sb.Append("  FROM patient_labinvestigation_opd plo   ");
           // sb.Append("  inner join sample_logistic sl on sl.barcodeno=plo.barcodeno and sl.testid=plo.test_id AND sl.IsActive=1 ");
           // sb.Append("  AND sl.`ToCentreID`=plo.`TestCentreID` ");
           // sb.Append(" WHERE  plo.Result_Flag=1   ");
           // sb.Append(" AND plo.Date >='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
           // sb.Append(" AND plo.Date <='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
           // sb.Append(" AND plo.SubcategoryID in (1,2,6,9,12) ");

           // sb.Append(" AND sl.`Status`='Received' and TIMEDIFF(plo.ApprovedDate,sl.ReceivedDate)< '03:00:00' AND sl.ToCentreID IN(" + CentreID + ")  ) AS TAT3Hrs , ");
            
			sb.Append(" ( SELECT  ");
            sb.Append("   COUNT(1) ");
            sb.Append("  FROM patient_labinvestigation_opd plo   ");
            sb.Append("  inner join sample_logistic sl on sl.barcodeno=plo.barcodeno and sl.testid=plo.test_id AND sl.IsActive=1 ");
            sb.Append("  AND sl.`ToCentreID`=plo.`TestCentreID` ");
            sb.Append(" WHERE  plo.Result_Flag=1   ");

            sb.Append(" AND plo.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND plo.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            sb.Append(" AND sl.`Status`='Received' and TIMEDIFF(plo.ApprovedDate,sl.ReceivedDate)< '06:00:00' AND plo.`centreid`IN(" + CentreID + ")  ) AS TAT6Hrs , ");

            // sb.Append(" ( SELECT  ");
            // sb.Append("   COUNT(1) ");
            // sb.Append("  FROM patient_labinvestigation_opd plo   ");
            // sb.Append("  inner join sample_logistic sl on sl.barcodeno=plo.barcodeno and sl.testid=plo.test_id AND sl.IsActive=1 ");
            // sb.Append("  AND sl.`ToCentreID`=plo.`TestCentreID` ");
            // sb.Append(" WHERE  plo.Result_Flag=1   ");
            // sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            // sb.Append(" AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            // sb.Append(" and TIMEDIFF(sl.ReceivedDate,plo.ApprovedDate)< '06:00:00' AND plo.`centreid`IN(" + CentreID + ")  ) AS regToSra6Hrs , ");

            sb.Append(" (SELECT COUNT(plo.SubCategoryID) OuthouseInhouse FROM patient_labinvestigation_opd plo ");
            sb.Append("  WHERE plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' ");
            sb.Append("  AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
           // sb.Append("  AND  plo.CentreID=plo.testcentreid");
            sb.Append("  AND plo.`testcentreid`IN(" + CentreID + ") AND plo.LabOutsrcID=0 ) AS InhouseTest, ");

            sb.Append(" (SELECT  COUNT(1)  ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo      ");
            sb.Append(" WHERE   plo.ishold=1 AND plo.`TestCentreID`IN(" + CentreID + ")     ");
            sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "') AS OnholdCount, ");


            sb.Append(" (SELECT  COUNT(1)  ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo      ");
            sb.Append("  INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
            sb.Append(" WHERE  plo.`isrerun`=1 AND plo.`TestCentreID`IN(" + CentreID + ")     ");//lt.`IsCancel`=0
            sb.Append(" AND lt.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND lt.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "') AS RepeatedSample, ");

            sb.Append(" (SELECT COUNT(1) RejectedSample ");
            sb.Append(" FROM patient_sample_Rejection  psr    ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID=psr.test_ID   ");

            sb.Append(" AND psr.EntDate>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' ");
            sb.Append(" AND psr.EntDate<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  AND plo.CentreID IN(" + CentreID + ") ) AS RejectedSample, ");


            sb.Append(" ( SELECT  ");
            sb.Append("   COUNT(1) ");
            //sb.Append(" FROM `patient_labobservation_opd` plo    ");
            sb.Append(" From `patient_labinvestigation_opd` pli ");
            //sb.Append(" ON plo.test_ID=pli.test_ID    ");
            sb.Append(" WHERE  pli.Result_Flag=1   ");
            sb.Append(" AND pli.IsNormalResult=2  ");
            sb.Append(" AND pli.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND pli.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  AND pli.`TestCentreID`IN(" + CentreID + ")  ) AS AbnormalSample,  ");

            sb.Append(" (SELECT COUNT(1)  ");
            sb.Append(" FROM `patient_labinvestigation_opd` pli   ");
            sb.Append(" INNER JOIN `patient_labobservation_opd` plo ON plo.`Test_ID`=pli.`Test_ID`    ");
            sb.Append(" INNER JOIN Email_Critical ec    ON ec.`LedgerTransactionNo`=pli.`LedgerTransactionNo` AND plo.`LabObservation_ID`=ec.`LabObservation_ID`   ");
            sb.Append(" LEFT JOIN sms s ON s.`LedgerTransactionID`=pli.`LedgerTransactionID`      ");
            sb.Append(" AND s.`SMS_Type`='Critical'   ");
            sb.Append(" WHERE   ");
            sb.Append(" pli.`Approved`=1 AND pli.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND pli.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'            ");
            sb.Append(" AND pli.isreporting=1  AND plo.`IsCritical`=1 AND IFNULL(plo.`Value`,'') <>''   AND pli.centreid IN(" + CentreID + ") ) AS CriticalSample, ");
          
            sb.Append(" (SELECT COUNT(1) AutoApprovedSample  ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo    ");
            sb.Append(" INNER JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID`    ");

            sb.Append(" WHERE plo.isreporting=1 AND `AutoApproved`=1  AND  plo.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'          ");
            sb.Append(" AND plo.`TestCentreID`IN(" + CentreID + ") ) AS AutoApprovedSample,    ");



            //sb.Append(" ( SELECT  ");
            //sb.Append("   COUNT(1) ");
            //sb.Append("  FROM patient_labinvestigation_opd plo   ");
            //sb.Append("  inner join sample_logistic sl on sl.barcodeno=plo.barcodeno and sl.testid=plo.test_id AND sl.IsActive=1 ");
            //sb.Append("  AND sl.`ToCentreID`=plo.`TestCentreID` ");


            //sb.Append(" WHERE  plo.Result_Flag=1   ");

            //sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            //sb.Append(" AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            //sb.Append(" and TIMEDIFF(plo.ApprovedDate,sl.ReceivedDate)<='06:00:00' AND plo.`centreid`IN(" + CentreID + ")  ) AS TAT,  ");

            sb.Append(" (SELECT COUNT(1) FROM  f_ledgertransaction lt   ");
	    sb.Append(" where lt.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND lt.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
	    sb.Append(" AND lt.`centreid`IN(" + CentreID + ")) AS TotalReg, ");

            sb.Append(" (SELECT Sum(plo.Amount) FROM f_ledgertransaction lt INNER JOIN `patient_labinvestigation_opd` plo ON plo.LedgerTransactionID=lt.LedgerTransactionID   ");
	    sb.Append(" where lt.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND lt.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
	    sb.Append(" AND lt.`centreid`IN(" + CentreID + ")) AS NetSale ");

            sb.Append(" FROM  ");
            sb.Append(" (         ");

            sb.Append(" SELECT COUNT(1)TotalSample  ");
            sb.Append("     FROM patient_labinvestigation_opd  ");
            sb.Append(" WHERE  Date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'     ");
            sb.Append(" AND Date<'" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            sb.Append(" AND TestCentreID IN(" + CentreID + ") ) a ");


//System.IO.File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "ErrorLog\\mmm.txt", sb.ToString());
                                // System.IO.File.WriteAllText (@"C:\ITDOSE\code\yoda_uat\ErrorLog\first.txt", sb.ToString());



            DataTable displayCount = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


            sb = new StringBuilder();

            sb.Append("  SELECT ");
            sb.Append(" (SELECT centre FROM centre_master WHERE centreid=a.CentreID)  Centre, ");
            sb.Append(" a.TotalSample,SUM(IFNULL(AmendmentSample,0)) AS AmendmentSample, ");
            sb.Append(" SUM(IFNULL(RepeatedSample,0)) AS RepeatedSample, ");
            sb.Append(" SUM(IFNULL(RejectedSample,0)) AS RejectedSample, ");
            sb.Append(" SUM(IFNULL(AbnormalSample,0)) AS AbnormalSample, ");
            sb.Append(" SUM(IFNULL(CriticalSample,0)) AS CriticalSample, ");
            sb.Append(" SUM(IFNULL(AutoApprovedSample,0)) AS AutoApprovedSample, ");
            sb.Append(" SUM(IFNULL(TAT3hrIn,0)) AS TAT3hrIn, ");
            sb.Append(" SUM(IFNULL(TAT3hrOut,0)) AS TAT3hrOut ");
            sb.Append(" FROM  ");
            sb.Append(" (  ");
            sb.Append(" SELECT ");
            sb.Append(" TestCentreID CentreID,COUNT(1) TotalSample,0 AmendmentSample,0 RepeatedSample,0 RejectedSample,0 AbnormalSample,0 CriticalSample,0 AutoApprovedSample ,0 TAT3hrIn,0 TAT3hrOut");
            sb.Append("  FROM patient_labinvestigation_opd plo ");
            sb.Append("  WHERE   Date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' ");
            sb.Append(" AND Date<'" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            sb.Append(" AND TestCentreID IN(" + CentreID + ")  ");
            sb.Append(" GROUP BY TestCentreID ");

            sb.Append(" UNION ALL");
            sb.Append(" SELECT plo.TestCentreID CentreID, 0 TotalSample,COUNT(1) AmendmentSample,0 RepeatedSample,0 RejectedSample,0 AbnormalSample,0 CriticalSample, 0 AutoApprovedSample ,0 TAT3hrIn,0 TAT3hrOut ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo   ");
            sb.Append(" INNER JOIN Report_Unapprove ru ON ru.`Test_ID`=plo.`Test_ID`  ");
            sb.Append(" AND ru.`UnapproveDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND ru.`UnapproveDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'    ");
            sb.Append(" WHERE plo.isreporting=1 AND  plo.`Approved`=1 AND plo.`TestCentreID`  IN(" + CentreID + ") GROUP BY plo.TestCentreID ");
           


            sb.Append(" UNION ALL  ");
            sb.Append(" SELECT plo.TestCentreID CentreID, 0 TotalSample,0 AmendmentSample,COUNT(1) RepeatedSample,0 RejectedSample,0 AbnormalSample,0 CriticalSample,0 AutoApprovedSample ,0 TAT3hrIn,0 TAT3hrOut ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo     ");
            sb.Append(" WHERE   plo.isreporting=1 AND plo.`isrerun`=1 AND plo.`TestCentreID`IN(" + CentreID + ")    ");
            sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'    ");
            sb.Append(" GROUP BY plo.TestCentreID");


            sb.Append(" UNION ALL ");
            sb.Append(" SELECT  plo.CentreID, 0 TotalSample,0 AmendmentSample,0 RepeatedSample,COUNT(1) RejectedSample,0 AbnormalSample,0 CriticalSample, 0 AutoApprovedSample ,0 TAT3hrIn,0 TAT3hrOut");
            sb.Append(" FROM patient_sample_Rejection  psr   ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID=psr.test_ID  ");
            sb.Append(" AND psr.EntDate>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND psr.EntDate<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  AND plo.CentreID IN(" + CentreID + ")  ");
            sb.Append(" GROUP BY plo.CentreID");


            sb.Append(" UNION ALL ");
            sb.Append(" SELECT  ");
            sb.Append(" pli.TestCentreID CentreID, 0 TotalSample,0 AmendmentSample,0 RepeatedSample,0 RejectedSample,COUNT(1) AbnormalSample,0 CriticalSample,0 AutoApprovedSample ,0 TAT3hrIn,0 TAT3hrOut");
            sb.Append(" FROM `patient_labinvestigation_opd` pli ");
            sb.Append(" WHERE  pli.Result_Flag=1   ");
            sb.Append(" AND pli.IsNormalResult=2  ");
            sb.Append(" AND pli.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND pli.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  AND pli.`TestCentreID`IN(" + CentreID + ")  ");
            sb.Append(" GROUP BY pli.TestCentreID");

            sb.Append(" UNION ALL ");
            sb.Append(" SELECT  pli.centreid, 0 TotalSample,0 AmendmentSample,0 RepeatedSample,0 RejectedSample,0 AbnormalSample,COUNT(1) CriticalSample,0 AutoApprovedSample ,0 TAT3hrIn,0 TAT3hrOut ");
            sb.Append(" FROM `patient_labinvestigation_opd` pli  ");
            sb.Append(" WHERE  ");
            sb.Append(" pli.`Approved`=1 AND pli.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND pli.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'           ");
            sb.Append(" AND pli.isreporting=1  AND pli.`IsCriticalResult`=1  AND pli.TestCentreID IN(" + CentreID + ")  ");
            sb.Append(" GROUP BY pli.TestCentreID ");

            sb.Append(" UNION ALL");
            sb.Append(" SELECT plo.TestCentreID CentreID, 0 TotalSample,0 AmendmentSample,0 RepeatedSample,0 RejectedSample,0 AbnormalSample,0 CriticalSample,COUNT(1) AutoApprovedSample,0 TAT3hrIn,0 TAT3hrOut");
            sb.Append(" FROM `patient_labinvestigation_opd` plo   ");
            sb.Append(" WHERE plo.isreporting=1 AND `AutoApproved`=1  AND  plo.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'         ");
            sb.Append(" AND plo.`TestCentreID`IN(" + CentreID + ")  ");
            sb.Append(" GROUP BY plo.TestCentreID");


            sb.Append(" UNION ALL ");
            sb.Append(" SELECT  ");
            sb.Append("  plo.centreid, 0 TotalSample,0 AmendmentSample,0 RepeatedSample,0 RejectedSample,0 AbnormalSample,0 CriticalSample,0 AutoApprovedSample,  COUNT(1) TAT3hrIn,0 TAT3hrOut ");
            sb.Append("  FROM patient_labinvestigation_opd plo   ");
            sb.Append("  inner join sample_logistic sl on sl.barcodeno=plo.barcodeno and sl.testid=plo.test_id AND sl.IsActive=1 ");
            sb.Append("  AND sl.`ToCentreID`=plo.`TestCentreID` ");
            sb.Append(" WHERE  plo.Result_Flag=1   ");
            sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            sb.Append(" and TIMEDIFF(plo.ApprovedDate,sl.ReceivedDate)<='03:00:00' AND plo.`centreid`IN(" + CentreID + ")  ");
            sb.Append(" GROUP BY plo.centreid");

            sb.Append(" UNION ALL");
            sb.Append(" SELECT  ");
            sb.Append("  plo.centreid,0 TotalSample,0 AmendmentSample,0 RepeatedSample,0 RejectedSample,0 AbnormalSample,0 CriticalSample, ");
            sb.Append("  0 AutoApprovedSample,0 TAT3hrIn, COUNT(1) TAT3hrOut ");
            sb.Append("  FROM patient_labinvestigation_opd plo   ");
            sb.Append("  inner join sample_logistic sl on sl.barcodeno=plo.barcodeno and sl.testid=plo.test_id AND sl.IsActive=1 ");
            sb.Append("  AND sl.`ToCentreID`=plo.`TestCentreID` ");
            sb.Append(" WHERE  plo.Result_Flag=1   ");
            sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            sb.Append(" and TIMEDIFF(plo.ApprovedDate,sl.ReceivedDate)>'03:00:00' AND plo.`centreid`IN(" + CentreID + ")  ");
            sb.Append(" GROUP BY plo.centreid )a GROUP BY centreid ORDER BY centre");
           // System.IO.File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "ErrorLog\\sb1.txt", sb.ToString());
//System.IO.File.WriteAllText (@"C:\ITDOSE\code\yoda_uat\ErrorLog\Second.txt", sb.ToString());

            DataTable dtcentrewise = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];

            sb = new StringBuilder();
            sb.Append(" SELECT MACHINEID FROM eq_machinebreakdown WHERE BreakDownDatetime>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND BreakDownDatetime<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'");
         // System.IO.File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "ErrorLog\\sb2.txt", sb.ToString());
		   DataTable dtMachinebreakdown = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];



            sb = new StringBuilder();
            sb.Append(" SELECT COUNT(plo.SubCategoryID) DepartmentCount,  ");
            sb.Append(" plo.SubCategoryName Department ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo   ");
            //sb.Append("  WHERE plo.`Approved`=0 AND plo.`Result_Flag`=0 ");
           // sb.Append("  AND  plo.CentreID=plo.testcentreid");
            sb.Append(" WHERE  plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' ");
            sb.Append("  AND  plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'   ");
            sb.Append(" AND plo.`Testcentreid` IN(" + CentreID + ") AND plo.`Approved`=0 ");
            sb.Append(" GROUP BY plo.`SubCategoryID` ");
			         // System.IO.File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "ErrorLog\\sb3.txt", sb.ToString());

			//System.IO.File.WriteAllText (@"C:\ITDOSE\code\yoda_uat\ErrorLog\Third.txt", sb.ToString());
			
            DataTable dtPendingData = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


            sb = new StringBuilder();
            sb.Append(" SELECT COUNT(plo.SubCategoryID) DepartmentCount,  ");
            sb.Append(" plo.SubCategoryName Department ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo   ");
            //sb.Append("  WHERE plo.`Approved`=0 AND plo.`Result_Flag`=0 ");
            // sb.Append("  AND  plo.CentreID=plo.testcentreid");
            sb.Append(" WHERE  plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' ");
            sb.Append("  AND  plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'   ");
            sb.Append(" AND plo.`Testcentreid` IN(" + CentreID + ") AND plo.`Approved`=1 and plo.IsSampleCollected = 'Y' ");
            sb.Append(" GROUP BY plo.`SubCategoryID` ");

            	//System.IO.File.WriteAllText (@"C:\ITDOSE\code\yoda_uat\ErrorLog\Fourth.txt", sb.ToString());
			          //System.IO.File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "ErrorLog\\sb4.txt", sb.ToString());

            DataTable dtPendingDataDept = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];

            sb = new StringBuilder();
            sb.Append(" SELECT COUNT(plo.SubCategoryID) DepartmentCount,  ");
            sb.Append(" plo.SubCategoryName Department ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo   ");
            //sb.Append("  WHERE plo.`Approved`=0 AND plo.`Result_Flag`=0 ");
            // sb.Append("  AND  plo.CentreID=plo.testcentreid");
            sb.Append(" WHERE  plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' ");
            sb.Append("  AND  plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'   ");
            sb.Append(" AND plo.`Testcentreid` IN(" + CentreID + ") AND plo.`Approved`=1 AND plo.`IsSRA`='1' ");
            sb.Append(" GROUP BY plo.`SubCategoryID` ");
			         // System.IO.File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "ErrorLog\\sb5.txt", sb.ToString());

            	//System.IO.File.WriteAllText (@"C:\ITDOSE\code\yoda_uat\ErrorLog\Fifth.txt", sb.ToString());

            DataTable dtPendingDataSra = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


            return JsonConvert.SerializeObject(new { status = true, displayCount = displayCount, displaycentrewise = dtcentrewise, dtMachinebreakdown = dtMachinebreakdown, dtPendingData = dtPendingData, dtPendingDataDept = dtPendingDataDept, dtPendingDataSra = dtPendingDataSra });

        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false });
        }
        finally
        {
            if (con.State == ConnectionState.Open)
            {
                con.Close();
                con.Dispose();
            }

        }
    }

    [WebMethod]
    public static string bindTotalCountwkly(string date, string radioValue, string Centreid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DateTime addmonth;
        string CentreID = "";
        try
        {

            if (radioValue == "monthlyData")
            {
                addmonth = Convert.ToDateTime(date).AddMonths(-1);
            }
            else if (radioValue == "weeklyData")
            {
                addmonth = Convert.ToDateTime(date).AddDays(-7);
            }
            else
            {
                addmonth = Convert.ToDateTime(date);
            }
            if (Centreid == "")
            {
                CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
            }
            else { CentreID = Centreid; }

            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT t.TotalSample,t.AmendmentSample, ");
            sb.Append(" t.OutsourceCount,  ");
            sb.Append(" t.RepeatedSample, ");
            sb.Append(" t.RejectedSample,  ");
            sb.Append(" t.AbnormalSample,  ");
            sb.Append(" t.CriticalSample, ");
            sb.Append(" t.AutoApprovedSample, ");
            sb.Append(" t.TAT FROM ( ");
            sb.Append("  SELECT TotalSample, ");
            sb.Append(" (SELECT COUNT(1) ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo   ");

            sb.Append(" INNER JOIN Report_Unapprove ru ON ru.`Test_ID`=plo.`Test_ID`  ");
            sb.Append(" AND ru.`UnapproveDate`>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND ru.`UnapproveDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'    ");
            sb.Append(" WHERE plo.isreporting=1 AND plo.`Approved`=1 AND plo.`TestCentreID`  IN(" + CentreID + ")) AS AmendmentSample, ");

            sb.Append("  (SELECT COUNT(LabOutsrcID) FROM patient_labinvestigation_opd plo WHERE   plo.LabOutsrcID<>0 AND plo.`TestCentreID`IN(" + CentreID + ") ");
            sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "') AS  `OutsourceCount`, ");



            sb.Append(" (SELECT  COUNT(1)  ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo      ");
            //sb.Append("  INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
            sb.Append(" WHERE   plo.`isreporting`=1  AND plo.`isrerun`=1 AND plo.`TestCentreID`IN(" + CentreID + ")     ");
            sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "') AS RepeatedSample, ");

            sb.Append(" (SELECT COUNT(1) RejectedSample ");
            sb.Append(" FROM patient_sample_Rejection  psr    ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID=psr.test_ID   ");
            // sb.Append(" AND plo.isreporting=1   ");
            sb.Append(" AND psr.EntDate>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "' ");
            sb.Append(" AND psr.EntDate<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  AND plo.CentreID IN(" + CentreID + ") ) AS RejectedSample, ");


            sb.Append(" ( SELECT  ");
            sb.Append("   COUNT(1) ");
            //sb.Append(" FROM `patient_labobservation_opd` plo    ");
            sb.Append(" From `patient_labinvestigation_opd` pli ");
            // sb.Append(" ON plo.test_ID=pli.test_ID    ");


            sb.Append(" WHERE  pli.Result_Flag=1   ");
            sb.Append(" AND pli.IsNormalResult=2  ");
            sb.Append(" AND pli.date>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND pli.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  AND pli.`TestCentreID`IN(" + CentreID + ")  ) AS AbnormalSample,  ");

            sb.Append(" (SELECT COUNT(1)  ");
            sb.Append(" FROM `patient_labinvestigation_opd` pli   ");
            sb.Append(" WHERE   ");
            sb.Append(" pli.`Approved`=1 AND pli.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND pli.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'            ");
            sb.Append(" AND pli.isreporting=1  AND pli.`IsCriticalResult`=1  AND pli.centreid IN(" + CentreID + ") ) AS CriticalSample, ");
            sb.Append(" (SELECT COUNT(1) AutoApprovedSample  ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo    ");
            //sb.Append(" INNER JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID`    ");

            sb.Append(" WHERE plo.isreporting=1 AND `AutoApproved`=1  AND  plo.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'          ");
            sb.Append(" AND plo.`TestCentreID`IN(" + CentreID + ") ) AS AutoApprovedSample,    ");



            sb.Append(" ( SELECT  ");
            sb.Append("   COUNT(1) ");
            sb.Append("  FROM patient_labinvestigation_opd plo   ");
            sb.Append("  inner join sample_logistic sl on sl.barcodeno=plo.barcodeno and sl.testid=plo.test_id AND sl.IsActive=1 ");
            sb.Append("  AND sl.`ToCentreID`=plo.`TestCentreID` ");


            sb.Append(" WHERE  plo.Result_Flag=1   ");

            sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            sb.Append(" and TIMEDIFF(plo.ApprovedDate,sl.ReceivedDate)<='06:00:00' AND plo.`centreid`IN(" + CentreID + ")  ) AS TAT  ");


            sb.Append(" FROM  ");
            sb.Append(" (         ");

            sb.Append(" SELECT COUNT(1)TotalSample  ");
            sb.Append("     FROM patient_labinvestigation_opd  ");
            sb.Append(" WHERE  date>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "'     ");
            sb.Append(" AND date<'" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            sb.Append(" AND TestCentreID IN(" + CentreID + ") ) a)t ");
			       //   System.IO.File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "ErrorLog\\sb6.txt", sb.ToString());

            DataTable displayCountdata = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];
            return JsonConvert.SerializeObject(new { status = true, displayCount = displayCountdata });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false });
        }
        finally
        {
            if (con.State == ConnectionState.Open)
            {
                con.Close();
                con.Dispose();
            }

        }
    }
    [WebMethod]
    public static string excelreportsummary(string date)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {

            string CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC','PCL') WHERE employeeid=" + UserInfo.ID + ""));

            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT TotalSample, ");
            sb.Append(" (SELECT COUNT(1) ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo   ");

            sb.Append(" INNER JOIN Report_Unapprove ru ON ru.`Test_ID`=plo.`Test_ID`  ");
            sb.Append(" AND ru.`UnapproveDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND ru.`UnapproveDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'    ");
            sb.Append(" WHERE plo.isreporting=1 AND plo.`Approved`=1 AND plo.`TestCentreID`  IN(" + CentreID + ")) AS AmendmentTest, ");
            sb.Append(" (SELECT  COUNT(1)  ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo      ");
            sb.Append(" WHERE   plo.isreporting=1 AND plo.`isrerun`=1 AND plo.`TestCentreID`IN(" + CentreID + ")     ");
            sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "') AS RepeatedSample, ");
            sb.Append(" (SELECT COUNT(1) RejectedSample ");
            sb.Append(" FROM patient_sample_Rejection  psr    ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID=psr.test_ID   ");
            //  sb.Append(" AND plo.isreporting=1   ");
            sb.Append(" AND psr.EntDate>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' ");
            sb.Append(" AND psr.EntDate<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  AND plo.CentreID IN(" + CentreID + ") ) AS RejectedSample, ");

            sb.Append(" ( SELECT  ");
            sb.Append("   COUNT(1) ");
            sb.Append(" FROM `patient_labobservation_opd` plo    ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` pli ");
            sb.Append(" ON plo.test_ID=pli.test_ID    ");


            sb.Append(" WHERE  pli.Result_Flag=1   ");
            sb.Append(" AND pli.IsNormalResult=2  ");
            sb.Append(" AND pli.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND pli.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  AND pli.`TestCentreID`IN(" + CentreID + ")  ) AS AbnormalTest,  ");


            sb.Append(" (SELECT COUNT(1)  ");
            sb.Append(" FROM `patient_labinvestigation_opd` pli   ");
            sb.Append(" INNER JOIN `patient_labobservation_opd` plo ON plo.`Test_ID`=pli.`Test_ID`    ");
            sb.Append(" INNER JOIN Email_Critical ec    ON ec.`LedgerTransactionNo`=pli.`LedgerTransactionNo` AND plo.`LabObservation_ID`=ec.`LabObservation_ID`   ");
            sb.Append(" LEFT JOIN sms s ON s.`LedgerTransactionID`=pli.`LedgerTransactionID`      ");
            sb.Append(" AND s.`SMS_Type`='Critical'   ");
            sb.Append(" WHERE   ");
            sb.Append(" pli.`Approved`=1 AND pli.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND pli.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'            ");
            sb.Append(" AND pli.isreporting=1  AND plo.`IsCritical`=1 AND IFNULL(plo.`Value`,'') <>''   AND pli.centreid IN(" + CentreID + ") ) AS CriticalSample, ");
            sb.Append(" (SELECT COUNT(1) AutoApprovedSample  ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo    ");
            sb.Append(" INNER JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID`    ");

            sb.Append(" WHERE plo.isreporting=1 AND `AutoApproved`=1  AND  plo.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'          ");
            sb.Append(" AND plo.`TestCentreID`IN(" + CentreID + ") ) AS AutoApprovedSample    ");


            sb.Append(" ( SELECT  ");
            sb.Append("   COUNT(1) ");
            sb.Append("  FROM patient_labinvestigation_opd plo   ");
            sb.Append("  inner join sample_logistic sl on sl.barcodeno=plo.barcodeno and sl.testid=plo.test_id AND sl.IsActive=1 ");

            sb.Append("  AND sl.`ToCentreID`=plo.`TestCentreID` ");

            sb.Append(" WHERE  plo.Result_Flag=1   ");

            sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            sb.Append(" and TIMEDIFF(plo.ApprovedDate,sl.ReceivedDate)<='06:00:00' AND plo.`centreid`IN(" + CentreID + ")  ) AS 'SRA TO APPROVE(WITHIN 6HR)'  ");



            sb.Append(" FROM  ");
            sb.Append(" (         ");

            sb.Append(" SELECT COUNT(1)TotalSample,  ");
            sb.Append("     FROM patient_labinvestigation_opd  ");
            sb.Append(" WHERE  sampledate>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'     ");
            sb.Append(" AND sampledate<'" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            sb.Append(" AND TestCentreID IN(" + CentreID + ") ) a ");


            //sb.Append(" SELECT COUNT(1)TotalSample, ");
            //sb.Append(" sum(if(ifnull(notapprovalId,0)>0,1,0)) AmendmentSample, ");
            //sb.Append(" SUM(IF(isrerun=1,1,0))RepeatedSample,SUM(IF(IsSampleCollected='R',1,0)) RejectedSample, ");
            //sb.Append(" SUM(IF(IsNormalResult=2,1,0))AbnormalSample,SUM(IF(IsCriticalResult=1,1,0))CriticalSample, ");
            //sb.Append(" SUM(IF(AutoApproved=1,1,0))AutoApprovedSample,'0' TAT FROM patient_labinvestigation_opd ");
            //sb.Append(" WHERE  sampledate>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'    ");
            //sb.Append(" AND sampledate<'" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'");
            //sb.Append(" AND TestCentreID IN(" + CentreID + ") ");
			          //System.IO.File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "ErrorLog\\sb7.txt", sb.ToString());

            DataTable displayCount = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


            HttpContext.Current.Session["dtExport2Excel"] = displayCount;
            HttpContext.Current.Session["ReportName"] = "Dashboard";
            return "true";




        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "false";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string excelreport(string date, string Centreid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        string CentreID = "";
        try
        {
            if (Centreid == "")
            {
                CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
            }
            else { CentreID = Centreid; }

            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT ");
            sb.Append(" (SELECT centre FROM centre_master WHERE centreid=a.TestCentreID)  Centre, ");
            sb.Append(" a.TotalSample,IFNULL(AmendmentSample,0) AS AmendmentSample, ");
            sb.Append(" IFNULL(RepeatedSample,0) AS RepeatedSample, ");
            sb.Append(" IFNULL(RejectedSample,0) AS RejectedSample, ");
            sb.Append(" IFNULL(AbnormalSample,0) AS AbnormalSample, ");
            sb.Append(" IFNULL(CriticalSample,0) AS CriticalSample, ");
            sb.Append(" IFNULL(AutoApprovedSample,0) AS AutoApprovedSample ");
            sb.Append("  ,IFNULL(TAT3hrIn,0) AS 'SRA TO APPROVE(Within 3Hr)' ");
            sb.Append("  ,IFNULL(TAT3hrOut,0) AS 'SRA TO APPROVE(Morethan 3Hr)' ");

            sb.Append(" FROM  ");
            sb.Append(" (  ");
            sb.Append(" SELECT TestCentreID,  ");
            sb.Append(" COUNT(1)TotalSample ");



            sb.Append("  FROM patient_labinvestigation_opd plo ");

            sb.Append("  WHERE   sampledate>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' ");
            sb.Append(" AND sampledate<'" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            sb.Append(" AND TestCentreID IN(" + CentreID + ")  ");
            sb.Append(" GROUP BY TestCentreID ) a ");
            sb.Append(" LEFT JOIN  ");
            sb.Append(" (       SELECT COUNT(1) AmendmentSample,plo.TestCentreID ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo   ");

            sb.Append(" INNER JOIN Report_Unapprove ru ON ru.`Test_ID`=plo.`Test_ID`  ");
            sb.Append(" AND ru.`UnapproveDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND ru.`UnapproveDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'    ");
            sb.Append(" WHERE plo.isreporting=1 AND  plo.`Approved`=1 AND plo.`TestCentreID`  IN(" + CentreID + ") GROUP BY plo.TestCentreID) b ");
            sb.Append(" ON b.TestCentreID=a.TestCentreID ");


            sb.Append(" LEFT JOIN  ");
            sb.Append(" (       SELECT  COUNT(1) RepeatedSample,plo.TestCentreID ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo     ");
            sb.Append(" WHERE   plo.isreporting=1 AND plo.`isrerun`=1 AND plo.`TestCentreID`IN(" + CentreID + ")    ");
            sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'    ");
            sb.Append(" GROUP BY plo.TestCentreID) c ");
            sb.Append(" ON c.TestCentreID=a.TestCentreID ");

            sb.Append(" LEFT JOIN  ");
            sb.Append(" (        SELECT COUNT(1) RejectedSample,plo.CentreID ");
            sb.Append(" FROM patient_sample_Rejection  psr   ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID=psr.test_ID  ");
            // sb.Append(" AND plo.isreporting=1  ");
            sb.Append(" AND psr.EntDate>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND psr.EntDate<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  AND plo.CentreID IN(" + CentreID + ")  ");
            sb.Append(" GROUP BY plo.CentreID) d ");
            sb.Append(" ON d.CentreID=a.TestCentreID ");

            sb.Append(" LEFT JOIN  ");
            sb.Append(" ( SELECT  ");
            sb.Append("   COUNT(1) AbnormalSample,pli.TestCentreID ");
            sb.Append(" FROM `patient_labobservation_opd` plo    ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` pli ");
            sb.Append(" ON plo.test_ID=pli.test_ID    ");


            sb.Append(" WHERE  pli.Result_Flag=1   ");
            sb.Append(" AND pli.IsNormalResult=2  ");
            sb.Append(" AND pli.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND pli.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  AND pli.`TestCentreID`IN(" + CentreID + ")  ");
            sb.Append(" GROUP BY pli.TestCentreID) e ");
            sb.Append(" ON e.TestCentreID=a.TestCentreID ");

            sb.Append(" LEFT JOIN  ");
            sb.Append(" (             SELECT COUNT(1) CriticalSample,pli.centreid ");
            sb.Append(" FROM `patient_labinvestigation_opd` pli  ");


            sb.Append(" INNER JOIN `patient_labobservation_opd` plo ON plo.`Test_ID`=pli.`Test_ID`   ");
            sb.Append(" INNER JOIN Email_Critical ec    ON ec.`LedgerTransactionNo`=pli.`LedgerTransactionNo` AND plo.`LabObservation_ID`=ec.`LabObservation_ID`  ");
            sb.Append(" LEFT JOIN sms s ON s.`LedgerTransactionID`=pli.`LedgerTransactionID`     ");
            sb.Append(" AND s.`SMS_Type`='Critical'  ");
            sb.Append(" WHERE  ");
            sb.Append(" pli.`Approved`=1 AND pli.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND pli.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'           ");
            sb.Append(" AND pli.isreporting=1  AND plo.`IsCritical`=1 AND IFNULL(plo.`Value`,'') <>''   AND pli.centreid IN(" + CentreID + ")  ");
            sb.Append(" GROUP BY pli.centreid) f ");
            sb.Append(" ON f.centreid=a.TestCentreID ");

            sb.Append(" LEFT JOIN  ");
            sb.Append(" (SELECT COUNT(1) AutoApprovedSample,plo.TestCentreID ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo   ");
            sb.Append(" INNER JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID`   ");

            sb.Append(" WHERE plo.isreporting=1 AND `AutoApproved`=1  AND  plo.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'         ");
            sb.Append(" AND plo.`TestCentreID`IN(" + CentreID + ")  ");
            sb.Append(" GROUP BY plo.TestCentreID) g ");
            sb.Append(" ON g.TestCentreID=a.TestCentreID ");

            sb.Append(" LEFT JOIN  ");
            sb.Append(" ( SELECT  ");
            sb.Append("   COUNT(1) TAT3hrIn,plo.centreid ");
            sb.Append("  FROM patient_labinvestigation_opd plo   ");
            sb.Append("  inner join sample_logistic sl on sl.barcodeno=plo.barcodeno and sl.testid=plo.test_id AND sl.IsActive=1 ");
            sb.Append("  AND sl.`ToCentreID`=plo.`TestCentreID` ");


            sb.Append(" WHERE  plo.Result_Flag=1   ");

            sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            sb.Append(" and TIMEDIFF(plo.ApprovedDate,sl.ReceivedDate)<='03:00:00' AND plo.`centreid`IN(" + CentreID + ")  ");
            sb.Append(" GROUP BY plo.centreid) h ");
            sb.Append(" ON h.centreid=a.TestCentreID ");



            sb.Append(" LEFT JOIN  ");
            sb.Append(" ( SELECT  ");
            sb.Append("   COUNT(1) TAT3hrOut,plo.centreid ");
            sb.Append("  FROM patient_labinvestigation_opd plo   ");
            sb.Append("  inner join sample_logistic sl on sl.barcodeno=plo.barcodeno and sl.testid=plo.test_id AND sl.IsActive=1 ");
            sb.Append("  AND sl.`ToCentreID`=plo.`TestCentreID` ");


            sb.Append(" WHERE  plo.Result_Flag=1   ");

            sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            sb.Append(" and TIMEDIFF(plo.ApprovedDate,sl.ReceivedDate)>'03:00:00' AND plo.`centreid`IN(" + CentreID + ")  ");
            sb.Append(" GROUP BY plo.centreid) i ");
            sb.Append(" ON i.centreid=a.TestCentreID ");


            //sb.Append(" SELECT (SELECT centre FROM centre_master WHERE centreid=TestCentreID)  Centre,");
            //sb.Append(" COUNT(1)TotalSample,");
            //sb.Append(" sum(if(ifnull(notapprovalId,0)>0,1,0)) AmendmentSample,");
            //sb.Append(" SUM(IF(isrerun=1,1,0))RepeatedSample,SUM(IF(IsSampleCollected='R',1,0)) RejectedSample,");
            //sb.Append(" SUM(IF(IsNormalResult=2,1,0))AbnormalSample,SUM(IF(IsCriticalResult=1,1,0))CriticalSample,");
            //sb.Append(" SUM(IF(AutoApproved=1,1,0))AutoApprovedSample,'0' TAT FROM patient_labinvestigation_opd plo");

            //sb.Append(" WHERE  sampledate>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'    ");
            //sb.Append(" AND sampledate<'" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'");
            //sb.Append(" AND TestCentreID  IN(" + CentreID + ") ");
            //sb.Append(" GROUP BY TestCentreID");
			         // System.IO.File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "ErrorLog\\sb8.txt", sb.ToString());

            DataTable dtcentrewise = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


            HttpContext.Current.Session["dtExport2Excel"] = dtcentrewise;
            HttpContext.Current.Session["ReportName"] = "Dashboard";
            return "true";




        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "false";
        }
        finally
        {
            if (con.State == ConnectionState.Open)
            {
                con.Close();
                con.Dispose();
            }
        }
    }

    [WebMethod]
    public static string ExcelreportMonthwise(string date, string Centreid, string value)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        string CentreID = "";
        try
        {
            if (Centreid == "")
            {
                CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
            }
            else { CentreID = Centreid; }

            StringBuilder sb = new StringBuilder();
            if (value == "1")
            {
                sb.Append("  SELECT ");
                sb.Append("   plo.SubCategorymasterName Department,plo.SubCategoryID,SUM(IF(plo.`IsPackage`=0,1,0))LabCount,  ");
                sb.Append("   ROUND(SUM(IF(plo.`IsPackage`=0,plo.`Rate`,0)))LabItemAmt, ");
                sb.Append("   SUM(IF(plo.`IsPackage`=1,1,0))PackageCount ,sum(plo.Result_Flag)Result_Flag  ");
                sb.Append("  FROM f_ledgertransaction lt  ");
                sb.Append("   INNER JOIN patient_labinvestigation_opd  plo ON lt.`LedgerTransactionID`=plo.LedgerTransactionID ");
                sb.Append("   WHERE lt.IsCancel=0  ");
                sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "' AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
                sb.Append(" AND YEAR(plo.date) =YEAR('" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "') AND plo.TestCentreID IN (" + CentreID + ") ");
                sb.Append(" GROUP BY plo.SubCategorymasterName ");
                sb.Append(" ORDER BY plo.SubCategorymasterName,plo.ItemName   ");



                //sb.Append(" SELECT COUNT(test_id) AS 'WORKLOAD (Total Test Count)',DATE_FORMAT(DATE,'%d-%b-%Y')CreatedDateTime,(SELECT centre FROM centre_master WHERE CentreID =plo.`CentreID`)'LAB NAME(processing Lab)' ");
                //sb.Append(" FROM patient_labinvestigation_opd plo ");
                //sb.Append(" WHERE YEAR(date) =YEAR('" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "') ");
                //sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "' AND date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
                //sb.Append(" GROUP BY DATE(DATE) ");

            }
            else if (value == "2")
            {
                sb.Append("  SELECT ");
                sb.Append("   plo.SubCategorymasterName Department,plo.SubCategoryID,SUM(IF(plo.`IsPackage`=0,1,0))LabCount,  ");
                sb.Append("   ROUND(SUM(IF(plo.`IsPackage`=0,plo.`Rate`,0)))LabItemAmt, ");
                sb.Append("   SUM(IF(plo.`IsPackage`=1,1,0))PackageCount ,sum(plo.Result_Flag)Result_Flag  ");
                sb.Append("  FROM f_ledgertransaction lt  ");
                sb.Append("   INNER JOIN patient_labinvestigation_opd  plo ON lt.`LedgerTransactionID`=plo.LedgerTransactionID ");
                sb.Append("   WHERE lt.IsCancel=0  ");
                sb.Append(" AND plo.date >= '" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "'-INTERVAL 1 MONTH ");
                sb.Append(" AND plo.date <= '" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "' ");
                sb.Append(" AND YEAR(plo.date) =YEAR('" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "') AND plo.TestCentreID IN (" + CentreID + ") ");
                sb.Append(" GROUP BY plo.SubCategorymasterName ");
                sb.Append(" ORDER BY plo.SubCategorymasterName,plo.ItemName   ");


                //sb.Append(" SELECT COUNT(test_id) AS 'WORKLOAD (Total Test Count)',DATE_FORMAT(DATE,'%d-%b-%Y')CreatedDateTime,(SELECT centre FROM centre_master WHERE CentreID =plo.`CentreID`)'LAB NAME(processing Lab)' ");
                //sb.Append(" FROM patient_labinvestigation_opd plo ");
                //sb.Append(" WHERE YEAR(date) =YEAR('" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "') ");
                //sb.Append(" AND plo.date >= '" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "'-INTERVAL 1 MONTH ");
                //sb.Append(" AND plo.date <= '" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "' ");
                //sb.Append(" GROUP BY DATE(DATE) ");
            }

            else if (value == "3")
            {
                sb.Append("  SELECT ");
                sb.Append("   plo.SubCategorymasterName Department,plo.SubCategoryID,SUM(IF(plo.`IsPackage`=0,1,0))LabCount,  ");
                sb.Append("   ROUND(SUM(IF(plo.`IsPackage`=0,plo.`Rate`,0)))LabItemAmt, ");
                sb.Append("   SUM(IF(plo.`IsPackage`=1,1,0))PackageCount ,sum(plo.Result_Flag)Result_Flag  ");
                sb.Append("  FROM f_ledgertransaction lt  ");
                sb.Append("   INNER JOIN patient_labinvestigation_opd  plo ON lt.`LedgerTransactionID`=plo.LedgerTransactionID ");
                sb.Append("   WHERE lt.IsCancel=0  ");
                sb.Append(" AND plo.date >= '" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "'-INTERVAL 2 MONTH ");
                sb.Append(" AND plo.date <= '" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "'-INTERVAL 1 MONTH ");
                sb.Append(" AND YEAR(plo.date) =YEAR('" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "') AND plo.TestCentreID IN (" + CentreID + ") ");
                sb.Append(" GROUP BY plo.SubCategorymasterName ");
                sb.Append(" ORDER BY plo.SubCategorymasterName,plo.ItemName   ");

                //    sb.Append(" SELECT COUNT(test_id) AS 'WORKLOAD (Total Test Count)',DATE_FORMAT(DATE,'%d-%b-%Y')CreatedDateTime,(SELECT centre FROM centre_master WHERE CentreID =plo.`CentreID`)'LAB NAME(processing Lab)' ");
                //    sb.Append(" FROM patient_labinvestigation_opd plo ");
                //    sb.Append(" WHERE YEAR(date) =YEAR('" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "') ");
                //    sb.Append(" AND plo.date >= '" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "'-INTERVAL 2 MONTH ");
                //    sb.Append(" AND plo.date <= '" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "'-INTERVAL 1 MONTH ");
                //    sb.Append(" GROUP BY DATE(DATE) ");
            }
						         // System.IO.File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "ErrorLog\\sb9.txt", sb.ToString());

            DataTable dtprevTwoMonth = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


            HttpContext.Current.Session["dtExport2Excel"] = dtprevTwoMonth;
            HttpContext.Current.Session["ReportName"] = "SampleLoadDataMonthWise";
            return "true";

        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "false";
        }
        finally
        {
            if (con.State == ConnectionState.Open)
            {
                con.Close();
                con.Dispose();
            }
        }
    }
    [WebMethod]
    public static string ExcelreportDownloadWeekly(string date, string Centreid, string radioParameters)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        string CentreID = "";
        try
        {
            if (Centreid == "")
            {
                CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
            }
            else { CentreID = Centreid; }

            StringBuilder sb = new StringBuilder();
            if (radioParameters == "AmendmentReport")
            {

                sb.Append("  SELECT cm.`Centre` BookingCentre,cma.Centre ProccessingCentre, ");
                sb.Append("  DATE_FORMAT(lt.`Date`,'%d-%b-%y %h:%i %p')BookingDate, ");
                sb.Append("  lt.`LedgerTransactionNo` VisitNo,lt.`Patient_ID`,lt.`PName`,lt.`Age`,lt.`Gender`,plo.`BarcodeNo`, ");
                sb.Append("  plo.`TestCode`,plo.`InvestigationName`, ");
                sb.Append("  ru.`Unapproveby`,DATE_FORMAT(ru.`UnapproveDate`,'%d-%b-%y %h:%i %p')`UnapproveDate`,ru.`Comments` UnApproveReason,ru.`ipaddress`, ");
                sb.Append("  plo.`ApprovedBy`,DATE_FORMAT(plo.`ApprovedDate`,'%d-%b-%y %h:%i %p')`ApprovedDate` ");
                sb.Append("  FROM `patient_labinvestigation_opd` plo  ");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                sb.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
                sb.Append("  INNER JOIN centre_master cma ON cma.`CentreID`=plo.`TestCentreID` ");
                sb.Append("  INNER JOIN Report_Unapprove ru ON ru.`Test_ID`=plo.`Test_ID` ");
                sb.Append("  AND ru.`UnapproveDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "' AND ru.`UnapproveDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'   ");
                sb.Append("  WHERE plo.`Approved`=1 AND plo.`TestCentreID`  in(" + CentreID.TrimEnd(',') + ")");// lt.`IsCancel`=0 AND
                sb.Append("  ORDER BY lt.`Date` DESC ");

            }
            if (radioParameters == "RepeatedTests")
            {

                sb.Append("    SELECT cm.`Centre` BookingCentre,cma.Centre ProccessingCentre,   ");
                sb.Append("   DATE_FORMAT(lt.`Date`,'%d-%b-%y %h:%i %p') BookingDate,   ");
                sb.Append("  lt.`LedgerTransactionNo` VisitNo,lt.`Patient_ID`,lt.`PName`,lt.`Age`,lt.`Gender`,plo.`BarcodeNo`,plo.`Test_ID`,   ");
                sb.Append("  plo.`TestCode`,plo.`InvestigationName` TestName,  ");
                sb.Append("  plo.`Rerunreason` RerunReason,DATE_FORMAT(plo.RerunDate,'%d-%b-%y %h:%i %p') RerunDate,em.`Name` RerunBy   ");
                sb.Append(" ,IF(lt.VisitType='Home Collection','Yes','No') HomeCollection");
                sb.Append("  FROM `patient_labinvestigation_opd` plo    ");
                sb.Append("  INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                sb.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`   ");
                sb.Append("  INNER JOIN centre_master cma ON cma.`CentreID`=plo.`TestCentreID`    ");
                sb.Append("   INNER JOIN employee_master em ON em.`Employee_ID`=plo.Rerunbyid  ");
                sb.Append("   WHERE  plo.`isrerun`=1 AND plo.`TestCentreID`  IN(" + CentreID.TrimEnd(',') + ")   ");//lt.`IsCancel`=0 AND
                sb.Append("   AND lt.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "' AND lt.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'   ");
                sb.Append("   ORDER BY plo.`Test_ID` ;  ");


            }
            if (radioParameters == "RejectedTests")
            {
                sb.Append("  SELECT '' TypeOfTnx,psr.Patient_ID MRNO,psr.LedgerTransactionNo AS LedgerTransactionNo,  ");
                sb.Append(" CONCAT(pm.Title,pm.PName)PNAME,CONCAT(pm.Age,'/',pm.Gender) AS Age,pm.Gender, ");
                sb.Append(" TRIM(CONCAT(CONCAT(IFNULL(pm.Phone,''),'',IFNULL(pm.Mobile,'')))) Phone,pm.locality Address,  ");
                sb.Append("  plo.ItemName InvName, psr.RejectionReason,DATE_FORMAT(psr.EntDate,'%d-%b-%Y %I:%i%p') RejectionDate,em.Name RejectedBy, ");
                sb.Append(" plo.`SampleCollectionBy` samplereceivedby,plo.`SampleCollector` samplereceiver,DATE_FORMAT(plo.`SampleCollectionDate`,'%d-%b-%Y %I:%i%p') ReceiveDate   ");
                sb.Append(" FROM patient_sample_Rejection  psr  ");
                sb.Append("  INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID=psr.test_ID   ");
                sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID=plo.Patient_ID  ");
                sb.Append("  AND psr.EntDate>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "'  ");
                sb.Append(" AND psr.EntDate<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  ");
                sb.Append("   AND plo.CentreID IN  (" + CentreID + ") ");
                sb.Append(" INNER JOIN employee_master em ON em.Employee_ID=psr.UserID  ");
                sb.Append("  ORDER BY psr.LedgerTransactionNo  ");
            }
            if (radioParameters == "AbnormalTest")
            {


                sb.Append("  SELECT ");
                sb.Append("  cm.centre BookingCenter,(select centre from centre_master cmm where cmm.centreid=pli.testcentreid) ProcessingCentre, pli.Investigation_ID ParamID,pli.InvestigationName AS ParamName, count(*) TotalCount  ");
                //sb.Append("   FROM `patient_labobservation_opd` plo   ");
                sb.Append("  From `patient_labinvestigation_opd` pli   ");
                // sb.Append("   ON plo.test_ID=pli.test_ID   ");
                sb.Append("  INNER JOIN `f_ledgertransaction` lt  ");
                sb.Append("  ON lt.ledgertransactionID=pli.ledgertransactionID   ");
                sb.Append("  INNER JOIN centre_master cm  ");
                sb.Append("  ON cm.centreid=lt.centreid  ");
                sb.Append("  WHERE  pli.Result_Flag=1  ");
                sb.Append(" and pli.IsNormalResult=2 ");
                sb.Append("   AND pli.date >= '" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "' ");
                sb.Append("    AND pli.date <= '" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
                sb.Append("  AND pli.Testcentreid IN(" + CentreID + ") group by pli.Testcentreid,pli.Investigation_ID ");
                sb.Append(" ORDER BY  pli.TestCentreID  ");

            }
            if (radioParameters == "CriticalReport")
            {
                sb.Append("  SELECT cm.`Centre` BookingCentre,cm1.`Centre` ProcessingCentre, ");
                sb.Append(" DATE_FORMAT(lt.`Date`,'%d-%b-%y %h:%i %p') BookingDateTime,lt.`DoctorName`,s.`MOBILE_NO` ,s.`IsSend`, ");
                sb.Append("  lt.`LedgerTransactionNo` VisitNo, pli.`BarcodeNo` SinNo,lt.`Patient_ID` UHID,lt.`PName`,lt.`Age`,lt.`Gender`,  ");
                sb.Append("   pli.`TestCode`, pli.`InvestigationName`,pli.`ApprovedName`,pli.`ApprovedDate`,  ");
                sb.Append("   plo.`LabObservationName`,plo.`Value`,plo.`MinValue`,plo.`MaxValue`,  ");
                sb.Append("  plo.`MinCritical`,plo.`MaxCritical`, plo.`Flag`,plo.`IsCritical`,plo.`ReadingFormat`,plo.`DisplayReading`,plo.`Method`  ");
                sb.Append(" FROM f_ledgertransaction lt ");
                sb.Append(" INNER JOIN `patient_labinvestigation_opd` pli ON pli.`LedgerTransactionID`=lt.`LedgerTransactionID`  ");
                sb.Append(" AND  pli.`Approved`=1 and  lt.centreid in(" + CentreID.TrimEnd(',') + ")");//lt.`IsCancel`=0 AND
                sb.Append(" and pli.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "' and pli.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
                sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`   ");
                sb.Append("  INNER JOIN centre_master cm1 ON cm1.`CentreID`=pli.`TestCentreID`  ");
                sb.Append("  INNER JOIN `patient_labobservation_opd` plo ON plo.`Test_ID`=pli.`Test_ID`  ");
                sb.Append("  INNER JOIN Email_Critical ec    ON ec.`LedgerTransactionNo`=lt.`LedgerTransactionNo` AND plo.`LabObservation_ID`=ec.`LabObservation_ID` ");
                sb.Append("  LEFT JOIN sms s ON s.`LedgerTransactionID`=lt.`LedgerTransactionID`    ");
                sb.Append("  AND s.`SMS_Type`='Critical' ");
                sb.Append(" WHERE plo.`IsCritical`=1 AND IFNULL(plo.`Value`,'') <>''   ");
                sb.Append(" ORDER BY lt.`LedgerTransactionID`  ");
            }
            if (radioParameters == "AutoValidateReport")
            {
                sb.Append(" SELECT plo.centreid LocationID, ");
                sb.Append(" (SELECT centre FROM centre_master cm1 WHERE cm1.centreid=plo.centreid) BookingCentre, ");
                sb.Append(" (SELECT centre FROM centre_master cm2 WHERE cm2.centreid=plo.`TestCentreID`) ProcessingCentre, ");
                sb.Append(" plo.`LedgerTransactionNo` VisitNo,plo.`BarcodeNo` SinNo, DATE_FORMAT(plo.`Date`,'%d-%b-%Y %I:%i %p') BookingDate,DATE_FORMAT(plo.`SampleCollectionDate`,'%d-%b-%Y %I:%i %p') `SampleCollectionDate`,DATE_FORMAT(plo.`SampleReceiveDate`,'%d-%b-%Y %I:%i %p') DepartmentReceiveDate,DATE_FORMAT(plo.`ResultEnteredDate`,'%d-%b-%Y %I:%i %p') ResultEnteredDate, DATE_FORMAT(plo.ApprovedDate,'%d-%b-%Y %I:%i %p') AutoApprovedDate, ");
                sb.Append("  plo.ResultEnteredName,plo.ApprovedName AutoApprovedByName,sm.`Name` AS DepartmentName,plo.`InvestigationName`,plo.`TestCode`, ");
                sb.Append("  ploo.`LabObservationName`,ploo.`Value`,ploo.`ReadingFormat` Unit ,ploo.`DisplayReading` `Bio. Ref. Range`,ploo.`Method` ");
                sb.Append(" ,ploo.`Flag`,ploo.`MinValue`,ploo.`MaxValue`,ploo.`MinCritical`,ploo.`MaxCritical` ");
                sb.Append("  FROM `patient_labinvestigation_opd` plo  ");
                sb.Append("  INNER JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID`  ");
                sb.Append(" INNER JOIN  f_subcategorymaster sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
                sb.Append(" WHERE `AutoApproved`=1  AND plo.ApprovedDate >='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "'  AND plo.ApprovedDate <='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  ");
                sb.Append(" AND plo.`TestCentreID` IN (" + CentreID + ") ");
                sb.Append(" ORDER BY plo.LedgerTransactionID, plo.`Test_ID`,ploo.`Priorty` ");

            }
            if (radioParameters == "SraToApprove(<3HR)")
            {
                sb.Append("  SELECT cm.centre BookingCentre,(select centre from centre_master where centreid=sl.ToCentreID) TestCentre, ");
                sb.Append("  IFNULL((SELECT centre FROM centre_master WHERE centreid=plo.`TestCentreID`),'')ProcessingCentre , ");
                //  sb.Append("  IFNULL((SELECT DATE_FORMAT(dtPrint,'%d-%b-%Y %h:%i %p') FROM patient_labinvestigation_opd_print_log WHERE Test_ID=plo.`Test_ID` ORDER BY id DESC LIMIT 1  ),'') ReportPrintingDateAndTime, ");
                sb.Append("  IF(plo.`Result_Flag`=1,IF((SELECT COUNT(1) FROM `test_centre_mapping` WHERE `Booking_Centre`=plo.`TestCentreID` AND `Investigation_Id`=plo.`Investigation_ID` AND `Booking_Centre`<>`Test_Centre`)>0,'OutHouse','InHouse'),'')`InHouse/OutHouse`, ");
                sb.Append("  lt.PanelName,lt.Patient_ID UHID,lt.PName,lt.Age,lt.Gender Sex,  ");
                sb.Append("  plo.ledgertransactionNo VisitNo,plo.BarcodeNo SINNo,  ");
                sb.Append("  OM.Name DepartmentName,plo.InvestigationName TestName,  ");
                sb.Append("  DATE_FORMAT(plo.Date,'%d-%b-%Y %I:%i%p') RegDateTime,  ");
                sb.Append("  DATE_FORMAT(plo.SampleCollectionDate,'%d-%b-%Y %h:%i %p')SampleCollectionDateTime,  ");
                sb.Append("  DATE_FORMAT(sl.TransferredDate,'%d-%b-%Y %h:%i %p')LastTransferDateTime,  ");
                sb.Append("  DATE_FORMAT(sl.LogisticReceiveDate,'%d-%b-%Y %h:%i %p')LogisticReceiveDateTime,  ");
                sb.Append("  DATE_FORMAT(sl.ReceivedDate,'%d-%b-%Y %h:%i %p')SRAReceiveDateTime,  ");
                sb.Append("  IF(plo.IsSampleCollected='Y', DATE_FORMAT(plo.SampleReceiveDate,'%d-%b-%Y %h:%i %p'),'')DepartmentReceiveDateTime,  ");
                sb.Append("  IF(plo.Result_Flag=1, DATE_FORMAT(plo.ResultEnteredDate,'%d-%b-%Y %I:%i%p'),'')ResultEnteredDateTime,  ");
                sb.Append("  IF(plo.Approved=1,DATE_FORMAT(plo.ApprovedDate,'%d-%b-%Y %I:%i%p'),'')ApprovedDateTime,   ");
                sb.Append("  IF(plo.Approved=1,'Y','N')ApprovalStatus,   ");
                sb.Append(" IFNULL((SELECT DATE_FORMAT(dtPrint,'%d-%b-%Y %h:%i %p') FROM patient_labinvestigation_opd_print_log WHERE Test_ID=plo.`Test_ID` ORDER BY id DESC LIMIT 1  ),'') ReportPrintingDateAndTime,      ");
                sb.Append(" IF(plo.Approved=1,TIMEDIFF(IFNULL((SELECT dtPrint FROM patient_labinvestigation_opd_print_log WHERE Test_ID=plo.`Test_ID` ORDER BY id DESC LIMIT 1  ),''),plo.ApprovedDate),'')`Report Approval-Report Printing`, ");

                sb.Append("  TIMEDIFF(sl.ReceivedDate,ifnull(TransferredDate,plo.SampleCollectionDate)) `Collection-SRA(hrs)`,");
                sb.Append("  TIMEDIFF(plo.SampleReceiveDate,sl.ReceivedDate) `SRA-DepartmentReceive(hrs)`,");
                sb.Append("  TIMEDIFF(plo.ResultEnteredDate,plo.SampleReceiveDate) `DepartmentReceive-ResultEntry(hrs)`,");
                sb.Append("  TIMEDIFF(plo.ApprovedDate,plo.ResultEnteredDate) `ResultEntry-Approval(hrs)`,");
                sb.Append("  TIMEDIFF(plo.ApprovedDate,sl.ReceivedDate) `SRA-Approval(hrs)`,");
                sb.Append("  TIMEDIFF(plo.ApprovedDate,plo.Date) `Booking-Approval(hrs)`, ");
                sb.Append("  IF(sl.ReceivedBy>0 AND sl.TransferredBy>0 ,  IFNULL(TIMEDIFF(sl.ReceivedDate,sl.TransferredDate),''),'')LogisticsTAT ");

                sb.Append("  FROM patient_labinvestigation_opd plo   ");
                sb.Append("  inner join sample_logistic sl on sl.barcodeno=plo.barcodeno and sl.testid=plo.test_id ");
                sb.Append("  AND sl.`ToCentreID`=plo.`TestCentreID` ");
                //sb.Append("   AND sl.ToCentreID IN(" + CentreID + ")   ");
                sb.Append("  INNER JOIN f_ledgertransaction LT ON LT.LedgerTransactionID = PLO.LedgerTransactionID   ");
                sb.Append("  AND lt.isCancel=0   ");
                sb.Append("  INNER JOIN centre_master cm ON cm.centreid=lt.centreid   ");
                sb.Append("  INNER JOIN investigation_observationtype io ON plo.Investigation_Id = IO.Investigation_ID     ");
                sb.Append("  INNER JOIN observationtype_master OM ON OM.ObservationType_ID = IO.ObservationType_Id  ");

                sb.Append("  AND plo.Date >='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "' ");
                sb.Append("  AND plo.Date <='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  ");

                sb.Append(" AND plo.SubcategoryID in (1,2,6,9,12) and TIMEDIFF(plo.ApprovedDate,sl.ReceivedDate)< '03:00:00' AND sl.`Status`='Received' AND plo.Result_Flag=1 AND sl.ToCentreID IN(" + CentreID + ") GROUP BY plo.`Test_ID`  ");
                sb.Append("  ORDER BY plo.Date  ");
            }
            if (radioParameters == "OutsourceTest")
            {

                sb.Append(" SELECT (SELECT centre FROM centre_master WHERE centreid=sl.`ToCentreID`) centre,lt.LedgerTransactionNo AS 'Visit No' ");
                sb.Append(" ,sl.`BarcodeNo`AS  'Sin No',lt.`PName` AS 'Patient Name',plo.SubCategorymasterName department,plo.`itemname` AS 'Test Name', ");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0',ifnull(io.`OutSrcLabID`,'-1'),plo.LabOutsrcID) LabOutsrcID, ");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0',io.`OutSrcLabname`,plo.LabOutsrcName) LabOutsrcName, ");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0',io.`OutsourceRate`,plo.LabOutSrcRate) LabOutSrcRate, ifnull(concat(io.`TAT`,' ',TATType),'') TAT,");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0','Pending','OutSourced') `Status`,plo.LabOutSrcBy, ");
                sb.Append(" DATE_FORMAT(plo.LabOutSrcDate,'%d-%b-%y %h:%i%p') LabOutSrcDate ");
                sb.Append(" FROM `patient_labinvestigation_opd` plo  ");
                sb.Append(" inner join investigation_master im on im.investigation_ID=plo.investigation_ID");
                sb.Append(" INNER JOIN `sample_logistic` sl ON plo.`BarcodeNo`=sl.`BarcodeNo` and plo.test_id=sl.testid AND sl.`Status`='SDR OUTSOURCE' ");
                sb.Append("  and sl.ToCentreID='" + CentreID + "' ");
                sb.Append(" LEFT JOIN `investigations_outsrclab` io ON io.`CentreID`=sl.`ToCentreID` AND io.`Investigation_ID`=plo.`Investigation_ID` ");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");//AND lt.`IsCancel`=0
                sb.Append("  where plo.date >='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "' ");
                sb.Append("  AND plo.date <='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");

                sb.Append(" UNION All ");
                sb.Append(" SELECT (SELECT centre FROM centre_master WHERE centreid=sl.`ToCentreID`) centre,lt.LedgerTransactionNo AS 'Visit No' ");
                sb.Append(" ,sl.`BarcodeNo`AS  'Sin No',lt.`PName` AS 'Patient Name',plo.SubCategorymasterName department,plo.`itemname` AS 'Test Name', ");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0','',plo.LabOutsrcID) LabOutsrcID, ");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0','',plo.LabOutsrcName) LabOutsrcName, ");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0','0',plo.LabOutSrcRate) LabOutSrcRate, ''TAT,");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0','Pending','OutSourced') `Status`,plo.LabOutSrcBy, ");
                sb.Append(" DATE_FORMAT(plo.LabOutSrcDate,'%d-%b-%y %h:%i%p') LabOutSrcDate ");
                sb.Append(" FROM `patient_labinvestigation_opd` plo  ");
                sb.Append(" inner join investigation_master im on im.investigation_ID=plo.investigation_ID");
                sb.Append(" INNER JOIN `sample_logistic` sl ON plo.`BarcodeNo`=sl.`BarcodeNo` AND  sl.`Status` = 'Received' AND plo.`LabOutsrcID`!='0' ");
                sb.Append("  and sl.ToCentreID='" + CentreID + "' ");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");//AND lt.`IsCancel`=0
                sb.Append("  where plo.date >='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "' ");
                sb.Append("  AND plo.date <='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");

            }
            if (radioParameters == "InhouseTest")
            {
                sb.Append("   SELECT cm1.`CentreID` FromCentreID, cm1.`CentreCode` FromCentreCode,cm1.`Centre` FromCentre, ");
                sb.Append("  plo.`TestCode`,plo.`Investigation_Id`, plo.InvestigationName InvestigationName,plo.SubCategorymasterName department ");
                sb.Append(" from patient_labinvestigation_opd plo  ");
                sb.Append(" inner JOIN centre_master cm1 ON cm1.`CentreID`=plo.`testcentreid` ");
                sb.Append(" where plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "'  ");
                sb.Append(" AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
                sb.Append("    AND plo.testcentreid IN(" + CentreID + ") ");
               

            }
            if (radioParameters == "SampleLoad")
            {
                sb.Append("  SELECT plo.ItemID,plo.`ItemName` Investigation, ");
                sb.Append("   sc.Name Department,sc.SubCategoryID,IF(plo.`IsPackage`=0,1,0)LabCount,    ");
                sb.Append("  IF(plo.`IsPackage`=0,plo.Amount,0)LabItemAmt,   ");
                sb.Append("  IF(plo.`IsPackage`=1,1,0)PackageCount ,  ");
                sb.Append("   lt.LedgerTransactionNo,DATE_FORMAT(lt.date ,'%d-%b-%Y')DATE, lt.`PName` PName,lt.`Age` Age,lt.Gender, ");
                sb.Append("   IF(plo.Result_Flag=1,'Done','Not Done') Result_Flag,    ");
                sb.Append("  (IFNULL(plo.Rate,0)*IFNULL(plo.`Quantity`,0)) GrossAmt, ");
                sb.Append("  IFNULL(plo.`DiscountAmt`,0) DiscAmt, ");
                sb.Append("  IFNULL(plo.`Amount`,0) NetAmt,  ");
                sb.Append("  IF(lt.`Doctor_ID`=2,lt.`OtherDoctorName`,lt.`DoctorName`) Doctor, ");
                sb.Append("   lt.`PanelName` PanelName ,plo.`TestCode` TestCode     ");
                sb.Append("   FROM  ");
                sb.Append("     f_ledgertransaction  lt ");
                sb.Append("    INNER JOIN patient_labinvestigation_opd  plo ON lt.`LedgerTransactionID`=plo.LedgerTransactionID    ");
                sb.Append("    AND lt.IsCancel=0   ");
                sb.Append("   AND lt.date >='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-01"), " 00:00:00") + "'   ");
                sb.Append("   AND lt.date <='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'    ");
                sb.Append("   AND plo.TestCentreID IN (" + CentreID + ") ");
                sb.Append("  INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=plo.SubCategoryID    ");
                sb.Append("  ORDER BY Department,Investigation ,LedgerTransactionNo   ");

            }
						       //   System.IO.File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "ErrorLog\\sb10.txt", sb.ToString());

            DataTable dtprevTwoMonth = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


            HttpContext.Current.Session["dtExport2Excel"] = dtprevTwoMonth;
            HttpContext.Current.Session["ReportName"] = radioParameters + "Report";
            return "true";

        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "false";
        }
        finally
        {
            if (con.State == ConnectionState.Open)
            {
                con.Close();
                con.Dispose();
            }
        }
    }

    [WebMethod]
    public static string ExcelreportDownloadMonthly(string date, string Centreid, string radioParameters, string firstDate, string lastDate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        string CentreID = "";
        try
        {
            if (Centreid == "")
            {
                CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
            }
            else { CentreID = Centreid; }

            StringBuilder sb = new StringBuilder();
            if (radioParameters == "AmendmentReport")
            {

                sb.Append("  SELECT cm.`Centre` BookingCentre,cma.Centre ProccessingCentre, ");
                sb.Append("  DATE_FORMAT(lt.`Date`,'%d-%b-%y %h:%i %p')BookingDate, ");
                sb.Append("  lt.`LedgerTransactionNo` VisitNo,lt.`Patient_ID`,lt.`PName`,lt.`Age`,lt.`Gender`,plo.`BarcodeNo`, ");
                sb.Append("  plo.`TestCode`,plo.`InvestigationName`, ");
                sb.Append("  ru.`Unapproveby`,DATE_FORMAT(ru.`UnapproveDate`,'%d-%b-%y %h:%i %p')`UnapproveDate`,ru.`Comments` UnApproveReason,ru.`ipaddress`, ");
                sb.Append("  plo.`ApprovedBy`,DATE_FORMAT(plo.`ApprovedDate`,'%d-%b-%y %h:%i %p')`ApprovedDate` ");
                sb.Append("  FROM `patient_labinvestigation_opd` plo  ");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                sb.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
                sb.Append("  INNER JOIN centre_master cma ON cma.`CentreID`=plo.`TestCentreID` ");
                sb.Append("  INNER JOIN Report_Unapprove ru ON ru.`Test_ID`=plo.`Test_ID` ");
                sb.Append("  AND ru.`UnapproveDate`>='" + string.Concat(Util.GetDateTime(firstDate).ToString("yyyy-MM-01"), " 00:00:00") + "' AND ru.`UnapproveDate`<='" + string.Concat(Util.GetDateTime(lastDate).ToString("yyyy-MM-dd"), " 00:00:00") + "'   ");
                sb.Append("  WHERE  plo.`Approved`=1 AND plo.`TestCentreID`  in(" + CentreID.TrimEnd(',') + ")");//lt.`IsCancel`=0 AND
                sb.Append("  ORDER BY lt.`Date` DESC ");

            }
            if (radioParameters == "RepeatedTests")
            {

                sb.Append("    SELECT cm.`Centre` BookingCentre,cma.Centre ProccessingCentre,   ");
                sb.Append("   DATE_FORMAT(lt.`Date`,'%d-%b-%y %h:%i %p') BookingDate,   ");
                sb.Append("  lt.`LedgerTransactionNo` VisitNo,lt.`Patient_ID`,lt.`PName`,lt.`Age`,lt.`Gender`,plo.`BarcodeNo`,plo.`Test_ID`,   ");
                sb.Append("  plo.`TestCode`,plo.`InvestigationName` TestName,  ");
                sb.Append("  plo.`Rerunreason` RerunReason,DATE_FORMAT(plo.RerunDate,'%d-%b-%y %h:%i %p') RerunDate,em.`Name` RerunBy   ");
                sb.Append(" ,IF(lt.VisitType='Home Collection','Yes','No') HomeCollection");
                sb.Append("  FROM `patient_labinvestigation_opd` plo    ");
                sb.Append("  INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                sb.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`   ");
                sb.Append("  INNER JOIN centre_master cma ON cma.`CentreID`=plo.`TestCentreID`    ");
                sb.Append("   INNER JOIN employee_master em ON em.`Employee_ID`=plo.Rerunbyid  ");
                sb.Append("   WHERE  plo.`isrerun`=1 AND plo.`TestCentreID`  IN(" + CentreID.TrimEnd(',') + ")   ");//lt.`IsCancel`=0 AND
                sb.Append("   AND lt.date>='" + string.Concat(Util.GetDateTime(firstDate).ToString("yyyy-MM-01"), " 00:00:00") + "' AND lt.date<='" + string.Concat(Util.GetDateTime(lastDate).ToString("yyyy-MM-dd"), " 23:59:59") + "'   ");
                sb.Append("   ORDER BY plo.`Test_ID` ;  ");

            }
            if (radioParameters == "RejectedTests")
            {
                sb.Append("  SELECT '' TypeOfTnx,psr.Patient_ID MRNO,psr.LedgerTransactionNo AS LedgerTransactionNo,  ");
                sb.Append(" CONCAT(pm.Title,pm.PName)PNAME,CONCAT(pm.Age,'/',pm.Gender) AS Age,pm.Gender, ");
                sb.Append(" TRIM(CONCAT(CONCAT(IFNULL(pm.Phone,''),'',IFNULL(pm.Mobile,'')))) Phone,pm.locality Address,  ");
                sb.Append("  plo.ItemName InvName, psr.RejectionReason,DATE_FORMAT(psr.EntDate,'%d-%b-%Y %I:%i%p') RejectionDate,em.Name RejectedBy, ");
                sb.Append(" plo.`SampleCollectionBy` samplereceivedby,plo.`SampleCollector` samplereceiver,DATE_FORMAT(plo.`SampleCollectionDate`,'%d-%b-%Y %I:%i%p') ReceiveDate   ");
                sb.Append(" FROM patient_sample_Rejection  psr  ");
                sb.Append("  INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID=psr.test_ID   ");
                sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID=plo.Patient_ID  ");
                sb.Append("  AND psr.EntDate>='" + string.Concat(Util.GetDateTime(firstDate).ToString("yyyy-MM-01"), " 00:00:00") + "'  ");
                sb.Append(" AND psr.EntDate<='" + string.Concat(Util.GetDateTime(lastDate).ToString("yyyy-MM-dd"), " 23:59:59") + "'  ");
                sb.Append("   AND plo.CentreID IN  (" + CentreID + ") ");
                sb.Append(" INNER JOIN employee_master em ON em.Employee_ID=psr.UserID  ");
                sb.Append("  ORDER BY psr.LedgerTransactionNo  ");
            }
            if (radioParameters == "AbnormalTest")
            {


                sb.Append("  SELECT ");
                sb.Append("  cm.centre BookingCenter,(select centre from centre_master cmm where cmm.centreid=pli.testcentreid) ProcessingCentre, pli.Investigation_ID ParamID,pli.InvestigationName AS ParamName, count(*) TotalCount  ");
                //sb.Append("   FROM `patient_labobservation_opd` plo   ");
                sb.Append("  From `patient_labinvestigation_opd` pli   ");
                // sb.Append("   ON plo.test_ID=pli.test_ID   ");
                sb.Append("  INNER JOIN `f_ledgertransaction` lt  ");
                sb.Append("  ON lt.ledgertransactionID=pli.ledgertransactionID   ");
                sb.Append("  INNER JOIN centre_master cm  ");
                sb.Append("  ON cm.centreid=lt.centreid  ");
                sb.Append("  WHERE  pli.Result_Flag=1  ");
                sb.Append(" and pli.IsNormalResult=2 ");
                sb.Append("   AND pli.date >= '" + string.Concat(Util.GetDateTime(firstDate).ToString("yyyy-MM-dd"), " 00:00:00") + "' ");
                sb.Append("    AND pli.date <= '" + string.Concat(Util.GetDateTime(lastDate).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
                sb.Append("  AND pli.Testcentreid IN(" + CentreID + ") group by pli.Testcentreid,pli.Investigation_ID ");
                sb.Append(" ORDER BY  pli.TestCentreID  ");

            }
            if (radioParameters == "CriticalReport")
            {
                sb.Append("  SELECT cm.`Centre` BookingCentre,cm1.`Centre` ProcessingCentre, ");
                sb.Append(" DATE_FORMAT(lt.`Date`,'%d-%b-%y %h:%i %p') BookingDateTime,lt.`DoctorName`,s.`MOBILE_NO` ,s.`IsSend`, ");
                sb.Append("  lt.`LedgerTransactionNo` VisitNo, pli.`BarcodeNo` SinNo,lt.`Patient_ID` UHID,lt.`PName`,lt.`Age`,lt.`Gender`,  ");
                sb.Append("   pli.`TestCode`, pli.`InvestigationName`,pli.`ApprovedName`,pli.`ApprovedDate`,  ");
                sb.Append("   plo.`LabObservationName`,plo.`Value`,plo.`MinValue`,plo.`MaxValue`,  ");
                sb.Append("  plo.`MinCritical`,plo.`MaxCritical`, plo.`Flag`,plo.`IsCritical`,plo.`ReadingFormat`,plo.`DisplayReading`,plo.`Method`  ");
                sb.Append(" FROM f_ledgertransaction lt ");
                sb.Append(" INNER JOIN `patient_labinvestigation_opd` pli ON pli.`LedgerTransactionID`=lt.`LedgerTransactionID`  ");
                sb.Append(" AND  pli.`Approved`=1 and  lt.centreid in(" + CentreID.TrimEnd(',') + ")");//lt.`IsCancel`=0 AND
                sb.Append(" and pli.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(firstDate).ToString("yyyy-MM-01"), " 00:00:00") + "' and pli.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(lastDate).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
                sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`   ");
                sb.Append("  INNER JOIN centre_master cm1 ON cm1.`CentreID`=pli.`TestCentreID`  ");
                sb.Append("  INNER JOIN `patient_labobservation_opd` plo ON plo.`Test_ID`=pli.`Test_ID`  ");
                sb.Append("  INNER JOIN Email_Critical ec    ON ec.`LedgerTransactionNo`=lt.`LedgerTransactionNo` AND plo.`LabObservation_ID`=ec.`LabObservation_ID` ");
                sb.Append("  LEFT JOIN sms s ON s.`LedgerTransactionID`=lt.`LedgerTransactionID`    ");
                sb.Append("  AND s.`SMS_Type`='Critical' ");
                sb.Append(" WHERE plo.`IsCritical`=1 AND IFNULL(plo.`Value`,'') <>''   ");
                sb.Append(" ORDER BY lt.`LedgerTransactionID`  ");
            }
            if (radioParameters == "AutoValidateReport")
            {
                sb.Append(" SELECT plo.centreid LocationID, ");
                sb.Append(" (SELECT centre FROM centre_master cm1 WHERE cm1.centreid=plo.centreid) BookingCentre, ");
                sb.Append(" (SELECT centre FROM centre_master cm2 WHERE cm2.centreid=plo.`TestCentreID`) ProcessingCentre, ");
                sb.Append(" plo.`LedgerTransactionNo` VisitNo,plo.`BarcodeNo` SinNo, DATE_FORMAT(plo.`Date`,'%d-%b-%Y %I:%i %p') BookingDate,DATE_FORMAT(plo.`SampleCollectionDate`,'%d-%b-%Y %I:%i %p') `SampleCollectionDate`,DATE_FORMAT(plo.`SampleReceiveDate`,'%d-%b-%Y %I:%i %p') DepartmentReceiveDate,DATE_FORMAT(plo.`ResultEnteredDate`,'%d-%b-%Y %I:%i %p') ResultEnteredDate, DATE_FORMAT(plo.ApprovedDate,'%d-%b-%Y %I:%i %p') AutoApprovedDate, ");
                sb.Append("  plo.ResultEnteredName,plo.ApprovedName AutoApprovedByName,sm.`Name` AS DepartmentName,plo.`InvestigationName`,plo.`TestCode`, ");
                sb.Append("  ploo.`LabObservationName`,ploo.`Value`,ploo.`ReadingFormat` Unit ,ploo.`DisplayReading` `Bio. Ref. Range`,ploo.`Method` ");
                sb.Append(" ,ploo.`Flag`,ploo.`MinValue`,ploo.`MaxValue`,ploo.`MinCritical`,ploo.`MaxCritical` ");
                sb.Append("  FROM `patient_labinvestigation_opd` plo  ");
                sb.Append("  INNER JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID`  ");
                sb.Append(" INNER JOIN  f_subcategorymaster sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
                sb.Append(" WHERE `AutoApproved`=1  AND plo.ApprovedDate >='" + string.Concat(Util.GetDateTime(firstDate).ToString("yyyy-MM-01"), " 00:00:00") + "'  AND plo.ApprovedDate <='" + string.Concat(Util.GetDateTime(lastDate).ToString("yyyy-MM-dd"), " 23:59:59") + "'  ");
                sb.Append(" AND plo.`TestCentreID` IN (" + CentreID + ") ");
                sb.Append(" ORDER BY plo.LedgerTransactionID, plo.`Test_ID`,ploo.`Priorty` ");


            }
            if (radioParameters == "SraToApprove(<3HR)")
            {
                sb.Append("  SELECT cm.centre BookingCentre,(select centre from centre_master where centreid=sl.ToCentreID) TestCentre, ");
                sb.Append("  IFNULL((SELECT centre FROM centre_master WHERE centreid=plo.`TestCentreID`),'')ProcessingCentre , ");
                //  sb.Append("  IFNULL((SELECT DATE_FORMAT(dtPrint,'%d-%b-%Y %h:%i %p') FROM patient_labinvestigation_opd_print_log WHERE Test_ID=plo.`Test_ID` ORDER BY id DESC LIMIT 1  ),'') ReportPrintingDateAndTime, ");
                sb.Append("  IF(plo.`Result_Flag`=1,IF((SELECT COUNT(1) FROM `test_centre_mapping` WHERE `Booking_Centre`=plo.`TestCentreID` AND `Investigation_Id`=plo.`Investigation_ID` AND `Booking_Centre`<>`Test_Centre`)>0,'OutHouse','InHouse'),'')`InHouse/OutHouse`, ");
                sb.Append("  lt.PanelName,lt.Patient_ID UHID,lt.PName,lt.Age,lt.Gender Sex,  ");
                sb.Append("  plo.ledgertransactionNo VisitNo,plo.BarcodeNo SINNo,  ");
                sb.Append("  OM.Name DepartmentName,plo.InvestigationName TestName,  ");
                sb.Append("  DATE_FORMAT(plo.Date,'%d-%b-%Y %I:%i%p') RegDateTime,  ");
                sb.Append("  DATE_FORMAT(plo.SampleCollectionDate,'%d-%b-%Y %h:%i %p')SampleCollectionDateTime,  ");
                sb.Append("  DATE_FORMAT(sl.TransferredDate,'%d-%b-%Y %h:%i %p')LastTransferDateTime,  ");
                sb.Append("  DATE_FORMAT(sl.LogisticReceiveDate,'%d-%b-%Y %h:%i %p')LogisticReceiveDateTime,  ");
                sb.Append("  DATE_FORMAT(sl.ReceivedDate,'%d-%b-%Y %h:%i %p')SRAReceiveDateTime,  ");
                sb.Append("  IF(plo.IsSampleCollected='Y', DATE_FORMAT(plo.SampleReceiveDate,'%d-%b-%Y %h:%i %p'),'')DepartmentReceiveDateTime,  ");
                sb.Append("  IF(plo.Result_Flag=1, DATE_FORMAT(plo.ResultEnteredDate,'%d-%b-%Y %I:%i%p'),'')ResultEnteredDateTime,  ");
                sb.Append("  IF(plo.Approved=1,DATE_FORMAT(plo.ApprovedDate,'%d-%b-%Y %I:%i%p'),'')ApprovedDateTime,   ");
                sb.Append("  IF(plo.Approved=1,'Y','N')ApprovalStatus,   ");
                sb.Append(" IFNULL((SELECT DATE_FORMAT(dtPrint,'%d-%b-%Y %h:%i %p') FROM patient_labinvestigation_opd_print_log WHERE Test_ID=plo.`Test_ID` ORDER BY id DESC LIMIT 1  ),'') ReportPrintingDateAndTime,      ");
                sb.Append(" IF(plo.Approved=1,TIMEDIFF(IFNULL((SELECT dtPrint FROM patient_labinvestigation_opd_print_log WHERE Test_ID=plo.`Test_ID` ORDER BY id DESC LIMIT 1  ),''),plo.ApprovedDate),'')`Report Approval-Report Printing`, ");

                sb.Append("  TIMEDIFF(sl.ReceivedDate,ifnull(TransferredDate,plo.SampleCollectionDate)) `Collection-SRA(hrs)`,");
                sb.Append("  TIMEDIFF(plo.SampleReceiveDate,sl.ReceivedDate) `SRA-DepartmentReceive(hrs)`,");
                sb.Append("  TIMEDIFF(plo.ResultEnteredDate,plo.SampleReceiveDate) `DepartmentReceive-ResultEntry(hrs)`,");
                sb.Append("  TIMEDIFF(plo.ApprovedDate,plo.ResultEnteredDate) `ResultEntry-Approval(hrs)`,");
                sb.Append("  TIMEDIFF(plo.ApprovedDate,sl.ReceivedDate) `SRA-Approval(hrs)`,");
                sb.Append("  TIMEDIFF(plo.ApprovedDate,plo.Date) `Booking-Approval(hrs)`, ");
                sb.Append("  IF(sl.ReceivedBy>0 AND sl.TransferredBy>0 ,  IFNULL(TIMEDIFF(sl.ReceivedDate,sl.TransferredDate),''),'')LogisticsTAT ");

                sb.Append("  FROM patient_labinvestigation_opd plo   ");
                sb.Append("  inner join sample_logistic sl on sl.barcodeno=plo.barcodeno and sl.testid=plo.test_id ");
                sb.Append("  AND sl.`ToCentreID`=plo.`TestCentreID` ");
                //sb.Append("   AND sl.ToCentreID IN(" + CentreID + ")   ");
                sb.Append("  INNER JOIN f_ledgertransaction LT ON LT.LedgerTransactionID = PLO.LedgerTransactionID   ");
                sb.Append("  AND lt.isCancel=0   ");
                sb.Append("  INNER JOIN centre_master cm ON cm.centreid=lt.centreid   ");
                sb.Append("  INNER JOIN investigation_observationtype io ON plo.Investigation_Id = IO.Investigation_ID     ");
                sb.Append("  INNER JOIN observationtype_master OM ON OM.ObservationType_ID = IO.ObservationType_Id  ");

                sb.Append("  AND plo.Date >='" + string.Concat(Util.GetDateTime(firstDate).ToString("yyyy-MM-01"), " 00:00:00") + "' ");
                sb.Append("  AND plo.Date <='" + string.Concat(Util.GetDateTime(lastDate).ToString("yyyy-MM-dd"), " 23:59:59") + "'  ");

                sb.Append(" AND plo.SubcategoryID in (1,2,6,9,12) and TIMEDIFF(plo.ApprovedDate,sl.ReceivedDate)< '03:00:00' AND sl.`Status`='Received' AND plo.Result_Flag=1 AND sl.ToCentreID IN(" + CentreID + ") GROUP BY plo.`Test_ID`  ");
                sb.Append("  ORDER BY plo.Date  ");
            }
            if (radioParameters == "OutsourceTest")
            {

                sb.Append(" SELECT (SELECT centre FROM centre_master WHERE centreid=sl.`ToCentreID`) centre,lt.LedgerTransactionNo AS 'Visit No' ");
                sb.Append(" ,sl.`BarcodeNo`AS  'Sin No',lt.`PName` AS 'Patient Name',plo.SubCategorymasterName department,plo.`itemname` AS 'Test Name', ");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0',ifnull(io.`OutSrcLabID`,'-1'),plo.LabOutsrcID) LabOutsrcID, ");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0',io.`OutSrcLabname`,plo.LabOutsrcName) LabOutsrcName, ");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0',io.`OutsourceRate`,plo.LabOutSrcRate) LabOutSrcRate, ifnull(concat(io.`TAT`,' ',TATType),'') TAT,");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0','Pending','OutSourced') `Status`,plo.LabOutSrcBy, ");
                sb.Append(" DATE_FORMAT(plo.LabOutSrcDate,'%d-%b-%y %h:%i%p') LabOutSrcDate ");
                sb.Append(" FROM `patient_labinvestigation_opd` plo  ");
                sb.Append(" inner join investigation_master im on im.investigation_ID=plo.investigation_ID");
                sb.Append(" INNER JOIN `sample_logistic` sl ON plo.`BarcodeNo`=sl.`BarcodeNo` and plo.test_id=sl.testid AND sl.`Status`='SDR OUTSOURCE' ");
                sb.Append("  and sl.ToCentreID='" + CentreID + "' ");
                sb.Append(" LEFT JOIN `investigations_outsrclab` io ON io.`CentreID`=sl.`ToCentreID` AND io.`Investigation_ID`=plo.`Investigation_ID` ");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");//AND lt.`IsCancel`=0
                sb.Append("  where plo.date >='" + string.Concat(Util.GetDateTime(firstDate).ToString("yyyy-MM-01"), " 00:00:00") + "' ");
                sb.Append("  AND plo.date <='" + string.Concat(Util.GetDateTime(lastDate).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");

                sb.Append(" UNION All ");
                sb.Append(" SELECT (SELECT centre FROM centre_master WHERE centreid=sl.`ToCentreID`) centre,lt.LedgerTransactionNo AS 'Visit No' ");
                sb.Append(" ,sl.`BarcodeNo`AS  'Sin No',lt.`PName` AS 'Patient Name',plo.SubCategorymasterName department,plo.`itemname` AS 'Test Name', ");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0','',plo.LabOutsrcID) LabOutsrcID, ");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0','',plo.LabOutsrcName) LabOutsrcName, ");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0','0',plo.LabOutSrcRate) LabOutSrcRate, ''TAT,");
                sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0','Pending','OutSourced') `Status`,plo.LabOutSrcBy, ");
                sb.Append(" DATE_FORMAT(plo.LabOutSrcDate,'%d-%b-%y %h:%i%p') LabOutSrcDate ");
                sb.Append(" FROM `patient_labinvestigation_opd` plo  ");
                sb.Append(" inner join investigation_master im on im.investigation_ID=plo.investigation_ID");
                sb.Append(" INNER JOIN `sample_logistic` sl ON plo.`BarcodeNo`=sl.`BarcodeNo` AND  sl.`Status` = 'Received' AND plo.`LabOutsrcID`!='0' ");
                sb.Append("  and sl.ToCentreID='" + CentreID + "' ");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");//AND lt.`IsCancel`=0
                sb.Append("  where plo.date >='" + string.Concat(Util.GetDateTime(firstDate).ToString("yyyy-MM-01"), " 00:00:00") + "' ");
                sb.Append("  AND plo.date <='" + string.Concat(Util.GetDateTime(lastDate).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            }
            if (radioParameters == "InhouseTest")
            {
                sb.Append("   SELECT cm1.`CentreID` FromCentreID, cm1.`CentreCode` FromCentreCode,cm1.`Centre` FromCentre, ");
                sb.Append("  plo.`TestCode`,plo.`Investigation_Id`, plo.InvestigationName InvestigationName,plo.SubCategorymasterName department ");
                sb.Append(" from patient_labinvestigation_opd plo  ");
                sb.Append(" inner JOIN centre_master cm1 ON cm1.`CentreID`=plo.`testcentreid` ");
                sb.Append(" where plo.date>='" + string.Concat(Util.GetDateTime(firstDate).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
                sb.Append(" AND plo.date<='" + string.Concat(Util.GetDateTime(lastDate).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
                sb.Append("    AND plo.testcentreid IN(" + CentreID + ") ");


            }
            if (radioParameters == "SampleLoad")
            {
                sb.Append("  SELECT plo.ItemID,plo.`ItemName` Investigation, ");
                sb.Append("   sc.Name Department,sc.SubCategoryID,IF(plo.`IsPackage`=0,1,0)LabCount,    ");
                sb.Append("  IF(plo.`IsPackage`=0,plo.Amount,0)LabItemAmt,   ");
                sb.Append("  IF(plo.`IsPackage`=1,1,0)PackageCount ,  ");
                sb.Append("   lt.LedgerTransactionNo,DATE_FORMAT(lt.date ,'%d-%b-%Y')DATE, lt.`PName` PName,lt.`Age` Age,lt.Gender, ");
                sb.Append("   IF(plo.Result_Flag=1,'Done','Not Done') Result_Flag,    ");
                sb.Append("  (IFNULL(plo.Rate,0)*IFNULL(plo.`Quantity`,0)) GrossAmt, ");
                sb.Append("  IFNULL(plo.`DiscountAmt`,0) DiscAmt, ");
                sb.Append("  IFNULL(plo.`Amount`,0) NetAmt,  ");
                sb.Append("  IF(lt.`Doctor_ID`=2,lt.`OtherDoctorName`,lt.`DoctorName`) Doctor, ");
                sb.Append("   lt.`PanelName` PanelName ,plo.`TestCode` TestCode     ");
                sb.Append("   FROM  ");
                sb.Append("     f_ledgertransaction  lt ");
                sb.Append("    INNER JOIN patient_labinvestigation_opd  plo ON lt.`LedgerTransactionID`=plo.LedgerTransactionID    ");
                sb.Append("    AND lt.IsCancel=0   ");
                sb.Append("   AND lt.date >='" + string.Concat(Util.GetDateTime(firstDate).ToString("yyyy-MM-dd"), " 00:00:00") + "'   ");
                sb.Append("   AND lt.date <='" + string.Concat(Util.GetDateTime(lastDate).ToString("yyyy-MM-dd"), " 23:59:59") + "'    ");
                sb.Append("   AND plo.TestCentreID IN (" + CentreID + ") ");
                sb.Append("  INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=plo.SubCategoryID    ");
                sb.Append("  ORDER BY Department,Investigation ,LedgerTransactionNo   ");


            }
						        //  System.IO.File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "ErrorLog\\sb11.txt", sb.ToString());

            DataTable dtprevTwoMonth = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


            HttpContext.Current.Session["dtExport2Excel"] = dtprevTwoMonth;
            HttpContext.Current.Session["ReportName"] = radioParameters + "Report";
            return "true";

        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "false";
        }
        finally
        {
            if (con.State == ConnectionState.Open)
            {
                con.Close();
                con.Dispose();
            }
        }
    }

    [WebMethod]
    public static string bindCentre()
    {
        try
        {

            var centreData = StockReports.GetDataTable("SELECT DISTINCT cm.centreid,centre FROM centre_master cm INNER JOIN f_login fl ON cm.`CentreID`=fl.`CentreID` AND fl.`EmployeeID`='" + UserInfo.ID + "' AND fl.Active=1 AND cm.isActive=1 ORDER BY centre ");
            return Util.getJson(centreData);

        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "false";
        }

    }

    [WebMethod]
    public static string bindDataParamsWise(string date, string radioValue, string Centreid, string radioParameters)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DateTime addmonth;
        string CentreID = "";
        try
        {

            if (radioValue == "MonthlyData")
            {
                //addmonth = Convert.ToDateTime(date).AddMonths(-2);
				addmonth = Convert.ToDateTime(date).AddYears(-1);
            }
            else if (radioValue == "WeeklyData")
            {
                //addmonth = Convert.ToDateTime(date);
				addmonth = Convert.ToDateTime(date).AddDays(-28);
            }
            else
            {
                //addmonth = Convert.ToDateTime(date);
				addmonth = Convert.ToDateTime(date).AddDays(-7);
            }
            if (Centreid == "")
            {
                CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
            }
            else { CentreID = Centreid; }

            StringBuilder sb = new StringBuilder();

            if (radioParameters == "AmendmentReport")
            {
                sb.Append(" SELECT COUNT(1) as countdata,DATE_FORMAT(plo.date,'%d-%b-%Y')CreatedDateTime ");
                sb.Append(" FROM `patient_labinvestigation_opd` plo   ");
                sb.Append(" INNER JOIN Report_Unapprove ru ON ru.`Test_ID`=plo.`Test_ID`  ");
                sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'    ");
                sb.Append(" WHERE plo.isreporting=1 AND plo.`Approved`=1 AND plo.`TestCentreID`  IN(" + CentreID + ") ");
                if (radioValue == "DailyData")
                {
                    sb.Append("  GROUP BY DATE(plo.date) ORDER BY DATE(DATE) ");
                }
                if (radioValue == "MonthlyData")
                {
                    sb.Append("  GROUP BY MONTH(plo.date) ORDER BY DATE(DATE) ");
                }
                if (radioValue == "WeeklyData")
                {
                    sb.Append("  GROUP BY WEEK(FROM_DAYS(TO_DAYS(plo.date) -MOD(TO_DAYS(plo.date) -2, 7))) ORDER BY DATE(DATE)");
                }
				//System.IO.File.WriteAllText (@"C:\ITDOSE\LiveCode\Oncquest\ErrorLog\AmendmentReport.txt", sb.ToString());
            }
            if (radioParameters == "RepeatedTests")
            {

                sb.Append(" SELECT  COUNT(1) as countdata,DATE_FORMAT(plo.date,'%d-%b-%Y')CreatedDateTime  ");
                sb.Append(" FROM `patient_labinvestigation_opd` plo      ");
                sb.Append("  INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   ");
                //sb.Append("  INNER JOIN  patient_labobservation_opd_rerun plr ON plr.`Test_ID`=plo.`Test_ID` ");
                sb.Append(" WHERE   plo.`isrerun`=1 AND plo.`TestCentreID`IN(" + CentreID + ")     ");//lt.`IsCancel`=0  and
                sb.Append(" AND lt.date>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "' ");
                sb.Append(" AND lt.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
                if (radioValue == "DailyData")
                {
                    sb.Append("  GROUP BY DATE(lt.date)");
                }
                if (radioValue == "MonthlyData")
                {
                    sb.Append("  GROUP BY MONTH(lt.date) ");
                }
                if (radioValue == "WeeklyData")
                {
                    sb.Append("  GROUP BY WEEK(FROM_DAYS(TO_DAYS(lt.date) -MOD(TO_DAYS(lt.date) -2, 7))) ");
                }

				//System.IO.File.WriteAllText (@"C:\ITDOSE\LiveCode\Oncquest\ErrorLog\RepeatedTests.txt", sb.ToString());
            }
            if (radioParameters == "RejectedTests")
            {
                sb.Append(" SELECT COUNT(1) as countdata,DATE_FORMAT(plo.date,'%d-%b-%Y')CreatedDateTime ");
                sb.Append(" FROM patient_sample_Rejection  psr    ");
                sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID=psr.test_ID   ");
                sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "' ");
                sb.Append(" AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'  ");
                sb.Append(" AND plo.CentreID IN(" + CentreID + ") ");

                if (radioValue == "DailyData")
                {
                    sb.Append("  GROUP BY DATE(plo.date) ");
                }
                if (radioValue == "MonthlyData")
                {
                    sb.Append("  GROUP BY MONTH(plo.date) ");
                }
                if (radioValue == "WeeklyData")
                {
                    sb.Append("  GROUP BY WEEK(FROM_DAYS(TO_DAYS(plo.date) -MOD(TO_DAYS(plo.date) -2, 7))) ");
                }
				//System.IO.File.WriteAllText (@"C:\ITDOSE\LiveCode\Oncquest\ErrorLog\RejectedTests.txt", sb.ToString());

            }
            if (radioParameters == "AbnormalTest")
            {
                sb.Append(" SELECT COUNT(1) as countdata,DATE_FORMAT(pli.date,'%d-%b-%Y')CreatedDateTime ");
                //sb.Append(" FROM `patient_labobservation_opd` plo    ");
                sb.Append(" from `patient_labinvestigation_opd` pli ");
                //sb.Append(" ON plo.test_ID=pli.test_ID    ");
                sb.Append(" WHERE  pli.Result_Flag=1   ");
                sb.Append(" AND pli.IsNormalResult=2  ");
                sb.Append(" AND pli.date>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
                sb.Append(" AND pli.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
                sb.Append(" AND pli.`TestCentreID`IN(" + CentreID + ") ");


                if (radioValue == "DailyData")
                {
                    sb.Append("  GROUP BY DATE(pli.date) ");
                }
                if (radioValue == "MonthlyData")
                {
                    sb.Append("  GROUP BY MONTH(pli.date) ");
                }
                if (radioValue == "WeeklyData")
                {
                    sb.Append("  GROUP BY WEEK(FROM_DAYS(TO_DAYS(pli.date) -MOD(TO_DAYS(pli.date) -2, 7))) ");
                }

            }
            if (radioParameters == "CriticalReport")
            {
                sb.Append(" SELECT COUNT(1) as countdata,DATE_FORMAT(pli.date,'%d-%b-%Y')CreatedDateTime ");
                sb.Append(" FROM `patient_labinvestigation_opd` pli   ");
                sb.Append(" WHERE   ");
                sb.Append(" pli.IsCriticalResult=1 and  pli.`Approved`=1 AND pli.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "' ");
                sb.Append(" AND pli.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'");
                sb.Append(" AND pli.centreid IN(" + CentreID + ") ");

                if (radioValue == "DailyData")
                {
                    sb.Append("  GROUP BY DATE(pli.date) ");
                }
                if (radioValue == "MonthlyData")
                {
                    sb.Append("  GROUP BY MONTH(pli.date) ");
                }
                if (radioValue == "WeeklyData")
                {
                    sb.Append("  GROUP BY WEEK(FROM_DAYS(TO_DAYS(pli.date) -MOD(TO_DAYS(pli.date) -2, 7))) ");
                }

            }
			//System.IO.File.WriteAllText (@"C:\ITDOSE\LiveCode\Oncquest\ErrorLog\CriticalReport.txt", sb.ToString());
            // if (radioParameters == "AutoValidateReport")
            // {
                // sb.Append(" SELECT COUNT(1) as countdata,DATE_FORMAT(plo.date,'%d-%b-%Y')CreatedDateTime  ");
                // sb.Append(" FROM `patient_labinvestigation_opd` plo    ");
                // sb.Append(" WHERE plo.isreporting=1 AND `AutoApproved`=1  AND  plo.`ApprovedDate`>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-01"), " 00:00:00") + "' AND plo.`ApprovedDate`<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'          ");
                // sb.Append(" AND plo.`TestCentreID`IN(" + CentreID + ") ");

                // if (radioValue == "DailyData")
                // {
                    // sb.Append("  GROUP BY DATE(plo.date) ");
                // }
                // if (radioValue == "MonthlyData")
                // {
                    // sb.Append("  GROUP BY MONTH(plo.date) ");
                // }
                // if (radioValue == "WeeklyData")
                // {
                    // sb.Append("  GROUP BY WEEK(FROM_DAYS(TO_DAYS(plo.date) -MOD(TO_DAYS(plo.date) -2, 7)))  ");
                // }

            // }
            // if (radioParameters == "SraToApprove(<3HR)")
            // {
                // sb.Append(" SELECT  ");
                // sb.Append("   COUNT(1) as countdata,DATE_FORMAT(plo.date,'%d-%b-%Y')CreatedDateTime  ");
                // sb.Append("  FROM patient_labinvestigation_opd plo   ");
                // sb.Append("  inner join sample_logistic sl on sl.barcodeno=plo.barcodeno and sl.testid=plo.test_id AND sl.IsActive=1 ");
                // //sb.Append("  AND sl.`ToCentreID`=plo.`TestCentreID` ");
                // sb.Append(" WHERE  plo.Result_Flag=1   ");
                // sb.Append(" AND plo.Date >='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-01"), " 00:00:00") + "'  ");
                // sb.Append(" AND plo.Date <='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
                // sb.Append(" AND plo.SubcategoryID in (1,2,6,9,12) ");
                // //sb.Append(" AND sl.`ToCentreID`=plo.`TestCentreID` ");
                // sb.Append(" and TIMEDIFF(plo.ApprovedDate,sl.ReceivedDate)< '03:00:00' AND sl.`Status`='Received' AND sl.ToCentreID IN(" + CentreID + ") ");

                // if (radioValue == "DailyData")
                // {
                    // sb.Append("  GROUP BY DATE(plo.date) ");
                // }
                // if (radioValue == "MonthlyData")
                // {
                    // sb.Append("  GROUP BY MONTH(plo.date) ");
                // }
                // if (radioValue == "WeeklyData")
                // {
                    // sb.Append(" GROUP BY WEEK(FROM_DAYS(TO_DAYS(plo.date) -MOD(TO_DAYS(plo.date) -2, 7)))  ");
                // }

            // }
            if (radioParameters == "OutsourceTest")
            {
                sb.Append(" SELECT COUNT(LabOutsrcID) as countdata,DATE_FORMAT(plo.date,'%d-%b-%Y')CreatedDateTime FROM patient_labinvestigation_opd plo WHERE   plo.LabOutsrcID<>0 AND plo.`TestCentreID` IN(" + CentreID + ") ");
                sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "' AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'");

                if (radioValue == "DailyData")
                {
                    sb.Append("  GROUP BY DATE(plo.date) ");
                }
                if (radioValue == "MonthlyData")
                {
                    sb.Append("  GROUP BY MONTH(plo.date) ");
                }
                if (radioValue == "WeeklyData")
                {
                    sb.Append(" GROUP BY WEEK(FROM_DAYS(TO_DAYS(plo.date) -MOD(TO_DAYS(plo.date) -2, 7)))  ");
                }

            }
            if (radioParameters == "InhouseTest")
            {
                
                sb.Append(" SELECT COUNT(plo.SubCategoryID) as countdata,DATE_FORMAT(plo.date,'%d-%b-%Y')CreatedDateTime ");
                sb.Append(" from patient_labinvestigation_opd plo  ");
                sb.Append(" where plo.date>='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
                sb.Append(" AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
                sb.Append(" AND plo.CentreID = plo.testcentreid ");
                sb.Append("  AND plo.CentreID IN(" + CentreID + ") ");



                if (radioValue == "DailyData")
                {
                    sb.Append("  GROUP BY DATE(plo.date) ");
                }
                if (radioValue == "MonthlyData")
                {
                    sb.Append("  GROUP BY MONTH(plo.date) ");
                }
                if (radioValue == "WeeklyData")
                {
                    sb.Append("  GROUP BY WEEK(FROM_DAYS(TO_DAYS(plo.date) -MOD(TO_DAYS(plo.date) -2, 7))) ");
                }
				//System.IO.File.WriteAllText (@"C:\ITDOSE\LiveCode\Oncquest\ErrorLog\InhouseTest.txt", sb.ToString());

            }

            if (radioParameters == "SampleLoad")
            {
                sb.Append("  SELECT  COUNT(1) as countdata,DATE_FORMAT(plo.date,'%d-%b-%Y')CreatedDateTime  ");
                sb.Append("   FROM  ");
                sb.Append("     f_ledgertransaction  lt ");
                sb.Append("    INNER JOIN patient_labinvestigation_opd  plo ON lt.`LedgerTransactionID`=plo.LedgerTransactionID    ");
               // sb.Append("    AND lt.IsCancel=0   ");
                sb.Append("   AND lt.date >='" + string.Concat(Util.GetDateTime(addmonth).ToString("yyyy-MM-dd"), " 00:00:00") + "'   ");
                sb.Append("   AND lt.date <='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "'    ");
                sb.Append("   AND plo.TestCentreID IN (" + CentreID + ") ");
               
                if (radioValue == "DailyData")
                {
                    sb.Append("  GROUP BY DATE(lt.date) ");
                }
                if (radioValue == "MonthlyData")
                {
                    sb.Append("  GROUP BY MONTH(lt.date) ");
                }
                if (radioValue == "WeeklyData")
                {
                    sb.Append("  GROUP BY WEEK(FROM_DAYS(TO_DAYS(lt.date) -MOD(TO_DAYS(lt.date) -2, 7))) ");
                }


            }
//System.IO.File.WriteAllText (@"C:\ITDose\LiveCode\Oncquest\ErrorLog\Dashboard.txt", sb.ToString());
			       //   System.IO.File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "ErrorLog\\sb12.txt", sb.ToString());

            DataTable dtCurrentdaydata = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];
            //var datemonth = Convert.ToDateTime(date);
            //StringBuilder sb1 = new StringBuilder();

            //sb1.Append(" SELECT COUNT(plo.SubCategoryID) OuthouseInhouse FROM patient_labinvestigation_opd plo ");
            //sb1.Append("  INNER JOIN test_centre_mapping tcm  ON plo.`Investigation_ID` =tcm.`Investigation_ID` ");
            //sb1.Append("  WHERE plo.date>='" + string.Concat(Util.GetDateTime(datemonth).ToString("yyyy-MM-01"), " 00:00:00") + "'");
            //sb1.Append("  AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' AND tcm.`Test_Centre`=tcm.`Booking_Centre` ");
            //sb1.Append("  AND plo.`TestCentreID`IN(" + CentreID + ") ");
            //if (radioValue == "DailyData")
            //{
            //    sb1.Append("  GROUP BY DATE(plo.date) ");
            //}
            //if (radioValue == "MonthlyData")
            //{
            //    sb1.Append("  ");
            //}
            //if (radioValue == "WeeklyData")
            //{
            //    sb1.Append("  ");
            //}



            //DataTable dtInhouseTestcount = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb1.ToString()).Tables[0];
            return JsonConvert.SerializeObject(new { status = true, dtCurrentdaydata = dtCurrentdaydata });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false });
        }
        finally
        {
            if (con.State == ConnectionState.Open)
            {
                con.Close();
                con.Dispose();
            }

        }
    }
}
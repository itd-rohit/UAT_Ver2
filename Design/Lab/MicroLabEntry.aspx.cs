﻿using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_MicroLabEntry : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            dtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(List<string> searchdata)
    {
        try
        {
            string checkSession = UserInfo.LoginName;
        }
        catch
        {
            return "-1";
        }
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append("");

        sbQuery.Append(" SELECT plo.Cultureno,plo.AgeInDays, plo.`Investigation_ID`, plo.`Test_ID`,plo.`LedgerTransactionNo`,plo.`BarcodeNo`,lt.`PName`, ");
        sbQuery.Append(" case when CultureStatus='Microscopic' then 'pink' when  CultureStatus='Plating' then 'lightgreen' when  CultureStatus='Incubation' then '#ff00ff' else 'lightyellow' end rowcolor,");//#00FFFF
        sbQuery.Append("inv.`Name`,plo.`SampleTypeName`,lt.`Age`,plo.`Gender`,lt.PanelName,plo.SlideNumber,  ");
        sbQuery.Append(" DATE_FORMAT(`SampleCollectionDate`,'%d-%b-%y %h:%i %p') SampleCollectionDate, ");
        sbQuery.Append("DATE_FORMAT(`SampleReceiveDate`,'%d-%b-%y %h:%i %p') SampleReceiveDate, ");
        sbQuery.Append(" ifnull(DATE_FORMAT(`CultureStatusDate`,'%d-%b-%y %h:%i %p'),'') CultureStatusDate, ");
        sbQuery.Append(" ifnull(CultureStatus,'') CultureStatus,if(plo.result_flag='1','saved','notdone') reportstatus");
        sbQuery.Append(" FROM `patient_labinvestigation_opd` plo  ");
        sbQuery.Append("INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
        sbQuery.Append("INNER JOIN investigation_master inv ON inv.`Investigation_Id`=plo.`Investigation_ID` AND inv.`isCulture`=1 ");
        sbQuery.Append(" AND plo.`IsSampleCollected`='Y' ");
        sbQuery.Append(" where plo.TestCentreID='"+UserInfo.Centre+"' ");
        sbQuery.Append(" and  plo.SampleReceiveDate>='"+Util.GetDateTime(searchdata[1]).ToString("yyyy-MM-dd")+" 00:00:00'");
        sbQuery.Append(" and plo.SampleReceiveDate<='" + Util.GetDateTime(searchdata[2]).ToString("yyyy-MM-dd") + " 23:59:59'");

        if (searchdata[3] != "")
        {
            sbQuery.Append(" and plo.LedgerTransactionNo='" + searchdata[3] + "'");
        }

        if (searchdata[4] != "")
        {
            sbQuery.Append(" and plo.barcodeno='" + searchdata[4] + "'");
        }
        sbQuery.Append(" and `Result_Flag`=0 ");
        if (searchdata[5] != "")
        {
            if (searchdata[5] == "Pending")
            {
                sbQuery.Append(" and ifnull(CultureStatus,'') ='' ");
            }
            else
            {
                sbQuery.Append(" and CultureStatus='" + searchdata[5] + "' ");
            }
        }
        else
        {
            if (searchdata[0] == "Microscopic")
            {
                sbQuery.Append(" and ifnull(CultureStatus,'') ='' ");
            }
            else if (searchdata[0] == "Plating")
            {
                sbQuery.Append(" and CultureStatus='Microscopic' ");
            }
            else if (searchdata[0] == "Incubation")
            {
                sbQuery.Append(" and CultureStatus='Plating' ");
            }
        }
        sbQuery.Append("order by plo.SampleReceiveDate");
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveMicroScopicdata(List<ResultEntryProperty> datatosave)
    {
        try
        {
            string checkSession = UserInfo.LoginName;
        }
        catch
        {
            return "-1";
        }

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {

            foreach (ResultEntryProperty pdeatil in datatosave)
            {
                Patient_lab_ObservationOPD_MIC plo = new Patient_lab_ObservationOPD_MIC(tnx);
                plo.testid = Util.GetString(pdeatil.Test_ID);
                plo.labobservation_id = Util.GetString(pdeatil.LabObservation_ID);
                plo.labobservation_name = Util.GetString(pdeatil.LabObservationName);
                plo.value = Util.GetString(pdeatil.Value);
                plo.unit = Util.GetString(pdeatil.ReadingFormat);
                plo.ResultEntrydateTime = Util.GetDateTime(System.DateTime.Now);
                plo.Result_flag = 1;

                plo.Reporttype = Util.GetString(pdeatil.ReportType);

                plo.IPAddress = StockReports.getip();
                plo.Insert();
            }
            StringBuilder sb = new StringBuilder();

            sb.Append("update patient_labinvestigation_opd set CultureStatus='Microscopic',CultureStatusDate=now() where Test_ID=@Test_ID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Test_ID", datatosave[0].Test_ID)
                );

            sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status ");
            sb.Append(" (LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Microscopic (',ItemName,')'),'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
            sb.Append(" '" + UserInfo.RoleID + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + datatosave[0].Test_ID + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_micro_status ");
            sb.Append(" (Test_id,LedgerTransactionNo,BarcodeNo,MicroScopic,MicroScopicComment,MicroScopicDoneBy,MicroScopicDate,CurrentStatus) ");
            sb.Append(" values ");
            sb.Append(" ('" + datatosave[0].Test_ID + "','" + datatosave[1].LedgerTransactionNo + "','" + datatosave[2].BarcodeNo + "','','', ");
            sb.Append(" '" + UserInfo.LoginName + "',now(),'Microscopic')");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());


            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();


        }


    }



     [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SavePlatingdata(List<string> datatosave)
    {
        try
        {
            string checkSession = UserInfo.LoginName;
        }
        catch
        {
            return "-1";
        }

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("update patient_labinvestigation_opd set CultureStatus='Plating',CultureStatusDate=now() where Test_ID=@Test_ID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Test_ID", datatosave[0])
                );

            sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status ");
            sb.Append(" (LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Plating (',ItemName,')'),'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
            sb.Append(" '" + UserInfo.RoleID + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + datatosave[0] + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.Append(" update   patient_labinvestigation_opd_micro_status set NoofPlate=@NoofPlate,PlateNumber=@PlateNumber,PlatingComment=@PlatingComment,");
            sb.Append(" PlatingDoneBy=@PlatingDoneBy,PlatingDate=now(),CurrentStatus='Plating' where Test_ID=@Test_ID ");


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(), new MySqlParameter("@NoofPlate", datatosave[3]), new MySqlParameter("@PlateNumber", datatosave[5].TrimEnd('#')), new MySqlParameter("@PlatingComment", datatosave[4]), new MySqlParameter("@PlatingDoneBy", UserInfo.LoginName), new MySqlParameter("@Test_ID", datatosave[0]));


            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();


        }


    }
     [WebMethod]
     public static string savefinaldata(List<getculturedata> data)
     {
         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         try
         {
             for (int i = 0; i < data.Count; i++)
             {
                 StringBuilder sb = new StringBuilder();

                 string slidenumber = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT get_Tran_id_MonthWise('Culture')"));
                 string UpdateSN = string.Concat("MDRC", slidenumber);

                 sb.Append("update patient_labinvestigation_opd set SlideNumber=@SlideNumber,CultureStatus='Incubation',CultureStatusDate=now(),incubationdatetime=NOW() where Test_ID=@Test_ID ");
                 MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@SlideNumber", UpdateSN),
                     new MySqlParameter("@Test_ID", data[i].Test_ID)
                     );

                 sb = new StringBuilder();
                 sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status ");
                 sb.Append(" (LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                 sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Incubation (',ItemName,')'),'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
                 sb.Append(" '" + UserInfo.RoleID + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + data[i].Test_ID + "'");

                 MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
             }
             return JsonConvert.SerializeObject(new { status = true, response = "culture start" });
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

      [WebMethod]
      [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
     public static string SaveIncubationdata(List<string> datatosave)
    {
        try
        {
            string checkSession = UserInfo.LoginName;
        }
        catch
        {
            return "-1";
        }

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("update patient_labinvestigation_opd set CultureStatus='Incubation',CultureStatusDate=now(),incubationdatetime=DATE_ADD(NOW(), INTERVAL " + datatosave[3] + " HOUR) where Test_ID=@Test_ID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Test_ID", datatosave[0])
                );

           


            sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status ");
            sb.Append(" (LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Incubation (',ItemName,')'),'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
            sb.Append(" '" + UserInfo.RoleID + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + datatosave[0] + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.Append(" update   patient_labinvestigation_opd_micro_status set IncubationPeriod=@IncubationPeriod, IncubationBatch=@IncubationBatch,IncubationComment=@IncubationComment,");
            sb.Append(" IncubationDoneBy=@IncubationDoneBy,IncubationDate=now(),CurrentStatus='Incubation' where Test_ID=@Test_ID ");


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(), new MySqlParameter("@IncubationPeriod", datatosave[3]), new MySqlParameter("@IncubationBatch", datatosave[4]), new MySqlParameter("@IncubationComment", datatosave[5]), new MySqlParameter("@IncubationDoneBy", UserInfo.LoginName), new MySqlParameter("@Test_ID", datatosave[0]));


            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();


        }


    }


    



     [WebMethod]
     [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
     public static string GetSavedData(string testid)
     {
         StringBuilder sbQuery = new StringBuilder();
         sbQuery.Append("");
         sbQuery.Append(" SELECT MicroScopic,MicroScopicComment,MicroScopicDoneBy,  DATE_FORMAT(`MicroScopicDate`,'%d-%b-%y %h:%i %p') MicroScopicDate, ");
         sbQuery.Append(" NoofPlate,PlateNumber,PlatingComment,PlatingDoneBy,DATE_FORMAT(`PlatingDate`,'%d-%b-%y %h:%i %p') PlatingDate, ");
         sbQuery.Append(" IncubationPeriod,IncubationBatch,IncubationComment,IncubationDoneBy,DATE_FORMAT(`IncubationDate`,'%d-%b-%y %h:%i %p') IncubationDate");
         sbQuery.Append(" FROM patient_labinvestigation_opd_micro_status WHERE test_id='" + testid + "' ");
         DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
         return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
     }

     [WebMethod]
     [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
     public static string UpdateAllData(List<string> datatoupdate, List<ResultEntryProperty> datatosave)
     {
         try
         {
             string checkSession = UserInfo.LoginName;
         }
         catch
         {
             return "-1";
         }


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "DELETE FROM patient_labobservation_opd_mic WHERE `TestID`=@Test_ID and Reporttype=@reportnumber",
                            new MySqlParameter("@Test_ID", datatosave[0].Test_ID), new MySqlParameter("@reportnumber", "Preliminary 1"));

            foreach (ResultEntryProperty pdeatil in datatosave)
            {
                Patient_lab_ObservationOPD_MIC plo = new Patient_lab_ObservationOPD_MIC(tnx);
                plo.testid = Util.GetString(pdeatil.Test_ID);
                plo.labobservation_id = Util.GetString(pdeatil.LabObservation_ID);
                plo.labobservation_name = Util.GetString(pdeatil.LabObservationName);
                plo.value = Util.GetString(pdeatil.Value);
                plo.unit = Util.GetString(pdeatil.ReadingFormat);
                plo.ResultEntrydateTime = Util.GetDateTime(System.DateTime.Now);
                plo.Result_flag = 1;

                plo.Reporttype = Util.GetString(pdeatil.ReportType);

                plo.IPAddress = StockReports.getip();
                plo.Insert();
            }


            StringBuilder sb = new StringBuilder();
            sb.Append("update patient_labinvestigation_opd_micro_status set MicroScopic=@MicroScopic,MicroScopicComment=@MicroScopicComment,MicroScopicDate=now(), ");
            sb.Append(" MicroScopicDoneBy=@MicroScopicDoneBy,");
            sb.Append(" NoofPlate=@NoofPlate,PlateNumber=@PlateNumber,PlatingComment=@PlatingComment,");
            sb.Append(" PlatingDoneBy=@PlatingDoneBy,PlatingDate=now(), ");
            sb.Append(" IncubationPeriod=@IncubationPeriod, IncubationBatch=@IncubationBatch,IncubationComment=@IncubationComment,");
            sb.Append(" IncubationDoneBy=@IncubationDoneBy,IncubationDate=now() ");
            sb.Append("  where Test_ID=@Test_ID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(), new MySqlParameter("@MicroScopic", datatoupdate[1]), new MySqlParameter("@MicroScopicComment", datatoupdate[2]), new MySqlParameter("@MicroScopicDoneBy", UserInfo.LoginName), new MySqlParameter("@NoofPlate", datatoupdate[3]), new MySqlParameter("@PlateNumber", datatoupdate[5].TrimEnd('#')), new MySqlParameter("@PlatingComment", datatoupdate[4]), new MySqlParameter("@PlatingDoneBy", UserInfo.LoginName), new MySqlParameter("@IncubationPeriod", datatoupdate[6]), new MySqlParameter("@IncubationBatch", datatoupdate[7]), new MySqlParameter("@IncubationComment", datatoupdate[8]), new MySqlParameter("@IncubationDoneBy", UserInfo.LoginName), new MySqlParameter("@Test_ID", datatoupdate[0])
                );
            sb = new StringBuilder();
            sb.Append("update patient_labinvestigation_opd set CultureStatus='Incubation',CultureStatusDate=now(),incubationdatetime=DATE_ADD(NOW(), INTERVAL " + datatoupdate[6] + " HOUR) where Test_ID=@Test_ID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Test_ID", datatoupdate[0])
                );

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();


        }
     }


     [WebMethod]
     [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
     public static string getMicroScopyData(string invid, string LabNo, string barcodeno, string Gender,string AgeInDays,string Test_id)
     {
         StringBuilder sbQuery = new StringBuilder();
         sbQuery.Append("");


         sbQuery.Append(" SELECT  MICROSCOPY, loi.labObservation_ID,lm.Name labObservationName,IF(loi.Child_Flag=1,'HEAD','') `value`,ifnull(IFNULL(lr.Readingformat,lr2.Readingformat),'') Unit,ifnull(h.help,'') help FROM `labobservation_investigation` loi  ");
         sbQuery.Append(" INNER JOIN `labobservation_master` lm ON loi.labObservation_ID=lm.labObservation_ID ");
         sbQuery.Append(" AND loi.Investigation_Id='"+invid+"'  ");

         sbQuery.Append(" LEFT OUTER JOIN  ");
         sbQuery.Append(" ( SELECT LabNo,LabObservation_ID,Reading MacReading,Reading1,Reading2,Reading3,'' MachineID,machinename,MachineID1,MachineID2,MachineID3,dtEntry,Test_ID "); 
         sbQuery.Append(" FROM  mac_data WHERE LedgerTransactionNo='" + LabNo + "' AND Reading<>''   ");
         sbQuery.Append("  GROUP BY Test_ID,LabObservation_ID ) mac ON mac.Test_ID='"+Test_id+"'  AND mac.LabObservation_ID= lm.LabObservation_ID   AND mac.LabNo = '" + barcodeno + "'  ");

         sbQuery.Append("LEFT OUTER JOIN labobservation_range lr ON lr.Gender=LEFT('" + Gender + "',1)  ");
         sbQuery.Append("AND lr.FromAge<=IF(" + AgeInDays + "=0,4381," + AgeInDays + ") AND lr.ToAge>=IF(" + AgeInDays + "=0,4381," + AgeInDays + ")    ");
         sbQuery.Append("AND lr.LabObservation_ID=lm.LabObservation_ID AND lr.macID = mac.MachineID AND lr.CentreID=" + UserInfo.Centre + "  AND lr.rangetype='Normal'  ");

         sbQuery.Append(" LEFT OUTER JOIN labobservation_range lr2 ON lr2.Gender=LEFT('" + Gender + "',1)  ");
         sbQuery.Append("AND lr2.FromAge<=IF(" + AgeInDays + "=0,4381," + AgeInDays + ") AND lr2.ToAge>=IF(" + AgeInDays + "=0,4381," + AgeInDays + ")   ");
         sbQuery.Append(" AND lr2.LabObservation_ID=lm.LabObservation_ID AND   IFNULL(lr2.macID,'1') = '1' AND lr2.CentreID=1  AND lr2.rangetype='Normal'  ");


         sbQuery.Append(" LEFT OUTER JOIN ");
         sbQuery.Append(" (SELECT GROUP_CONCAT(lhm.Help SEPARATOR '|' )Help,loh.labObservation_ID  ");
         sbQuery.Append(" FROM LabObservation_Help loh  ");
         sbQuery.Append(" INNER JOIN LabObservation_Help_Master lhm ON lhm.id=loh.HelpId  ");
         sbQuery.Append(" GROUP BY loh.LabObservation_ID ) h ON h.LabObservation_ID = lm.LabObservation_ID ");



         sbQuery.Append("ORDER BY printOrder ");


         DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
         return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
     }


     [WebMethod]
     [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
     public static string getMicroScopyDataaftersave(string invid, string LabNo, string barcodeno, string Gender, string AgeInDays, string Test_id)
     {
         StringBuilder sbQuery = new StringBuilder();
         sbQuery.Append("");

         
         sbQuery.Append(" SELECT  MICROSCOPY, loi.labObservation_ID,lm.Name labObservationName,IF(loi.Child_Flag=1,'HEAD',ifnull(plo.value,'')) `value`,ifnull(plo.Unit, ifnull(IFNULL(lr.Readingformat,lr2.Readingformat),'')) Unit,ifnull(h.help,'') help FROM `labobservation_investigation` loi  ");
         sbQuery.Append(" INNER JOIN `labobservation_master` lm ON loi.labObservation_ID=lm.labObservation_ID ");
         sbQuery.Append(" AND loi.Investigation_Id='"+invid+"'  ");

         sbQuery.Append(" LEFT OUTER JOIN  ");
         sbQuery.Append(" ( SELECT LabNo,LabObservation_ID,Reading MacReading,Reading1,Reading2,Reading3,'' MachineID,machinename,MachineID1,MachineID2,MachineID3,dtEntry,Test_ID "); 
         sbQuery.Append(" FROM  mac_data WHERE LedgerTransactionNo='" + LabNo + "' AND Reading<>''   ");
         sbQuery.Append("  GROUP BY Test_ID,LabObservation_ID ) mac ON mac.Test_ID='"+Test_id+"'  AND mac.LabObservation_ID= lm.LabObservation_ID   AND mac.LabNo = '" + barcodeno + "'  ");

         sbQuery.Append("LEFT OUTER JOIN labobservation_range lr ON lr.Gender=LEFT('" + Gender + "',1)  ");
         sbQuery.Append("AND lr.FromAge<=IF(" + AgeInDays + "=0,4381," + AgeInDays + ") AND lr.ToAge>=IF(" + AgeInDays + "=0,4381," + AgeInDays + ")    ");
         sbQuery.Append("AND lr.LabObservation_ID=lm.LabObservation_ID AND lr.macID = mac.MachineID AND lr.CentreID=" + UserInfo.Centre + "  AND lr.rangetype='Normal'  ");

         sbQuery.Append(" LEFT OUTER JOIN labobservation_range lr2 ON lr2.Gender=LEFT('" + Gender + "',1)  ");
         sbQuery.Append("AND lr2.FromAge<=IF(" + AgeInDays + "=0,4381," + AgeInDays + ") AND lr2.ToAge>=IF(" + AgeInDays + "=0,4381," + AgeInDays + ")   ");
         sbQuery.Append(" AND lr2.LabObservation_ID=lm.LabObservation_ID AND   IFNULL(lr2.macID,'1') = '1' AND lr2.CentreID=1  AND lr2.rangetype='Normal'  ");


         sbQuery.Append(" LEFT OUTER JOIN ");
         sbQuery.Append(" (SELECT GROUP_CONCAT(lhm.Help SEPARATOR '|' )Help,loh.labObservation_ID  ");
         sbQuery.Append(" FROM LabObservation_Help loh  ");
         sbQuery.Append(" INNER JOIN LabObservation_Help_Master lhm ON lhm.id=loh.HelpId  ");
         sbQuery.Append(" GROUP BY loh.LabObservation_ID ) h ON h.LabObservation_ID = lm.LabObservation_ID ");


         sbQuery.Append(" LEFT JOIN patient_labobservation_opd_mic plo ON plo.TestID='" + Test_id + "' AND plo.LabObservation_ID=lm.LabObservation_ID and plo.reporttype='Preliminary 1' ");


         sbQuery.Append("ORDER BY printOrder ");


         DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
         return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
     }

     public class getculturedata
     {
         public int Test_ID { get; set; }
         public string LedgerTransactionNo { get; set; }
         public string BacrodeNo { get; set; }
     }
    
}
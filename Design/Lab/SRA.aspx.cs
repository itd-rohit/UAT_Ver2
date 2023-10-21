using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;

public partial class Design_Lab_SRA : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            txtBarcode.Focus();
    }

    [WebMethod]
    public static string SampleSearch(List<SampleSearch> data)
    {
       
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            DataTable dt = new DataTable();
            using (dt as IDisposable)
            {
                if (data[0].Inhouse == "True")
                {

                    sb = new StringBuilder();
                    sb.Append("SELECT LedgertransactionNo,group_concat(CAST(test_id AS CHAR))  testid FROM `patient_labinvestigation_opd` pli WHERE pli.`Barcode_Group`=@Barcode_Group and pli.isSampleCollected='S' AND pli.`CentreIDSession`=@CentreIDSession and pli.IsReporting=1 and isSRA=0 and pli.Isactive=1 and pli.LedgerTransactionNo <>'' AND pli.Test_Id IN (" + data[0].Test_ID + ") group by Barcode_Group  ;");  //--- Appended By Apurva 11-09-2018 

                    using (DataTable dtSelect = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@Barcode_Group", data[0].BarcodeNo.Trim()),
                         new MySqlParameter("@CentreIDSession", UserInfo.Centre)).Tables[0])
                    {

                        if (dtSelect.Rows.Count > 0)
                        {
                            sb = new StringBuilder();
                            sb.Append("SELECT COUNT(*) from sample_logistic where testid in(" + data[0].Test_ID + ") and  status<>'Rejected' and isActive=1 ;"); //---Appended by Apurva 11-09-2018
                            if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@barcodeNo", data[0].BarcodeNo.Trim()))) == 0)
                            {
                                string aa = dtSelect.Rows[0]["testid"].ToString();
                                string[] testid = aa.Split(',');
                                for (int i = 0; i < testid.Length; i++)
                                {
                                    sb = new StringBuilder();
                                    sb.Append("INSERT INTO sample_logistic(BarcodeNo,Barcode_Group,FromCentreID,ToCentreID,DispatchCode,Qty,EntryBy,`Status`,dtLogisticReceive,LogisticReceiveDate,LogisticReceiveBy,testid) ");
                                    sb.Append(" values(@BarcodeNo,@BarcodeNo,@FromCentreID,@ToCentreID,@DispatchCode,@Qty,@EntryBy,@STATUS,@dtLogisticReceive,@LogisticReceiveDate,@LogisticReceiveBy,@testid);");

                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                        new MySqlParameter("@BarcodeNo", data[0].BarcodeNo.Trim()),
                                        new MySqlParameter("@FromCentreID", UserInfo.Centre),
                                        new MySqlParameter("@ToCentreID", UserInfo.Centre),
                                        new MySqlParameter("@DispatchCode", ""),
                                        new MySqlParameter("@Qty", 1),
                                        new MySqlParameter("@EntryBy", UserInfo.ID),
                                        new MySqlParameter("@STATUS", "Received at Hub"), new MySqlParameter("@dtLogisticReceive", DateTime.Now),
                                        new MySqlParameter("@LogisticReceiveDate", DateTime.Now),
                                        new MySqlParameter("@LogisticReceiveBy", UserInfo.ID),
                                        new MySqlParameter("@testid", testid[i])
                                        );
                                }

                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode) ",
                            new MySqlParameter("@LedgertransactionNo", dtSelect.Rows[0]["LedgertransactionNo"].ToString()),
                            new MySqlParameter("@SinNo", data[0].BarcodeNo.Trim()), new MySqlParameter("@Test_ID", "0"),
                            new MySqlParameter("@Status", string.Format("SIN No. {0} Received at In-house Hub ", data[0].BarcodeNo)), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                            new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID),
                            new MySqlParameter("@DispatchCode", ""));
                            }
                        }
                    }
                }
                sb = new StringBuilder();
                sb.Append("  SELECT pli.sampleqty,GROUP_CONCAT(CAST(pli.`Test_ID` AS CHAR))Test_ID, pli.IsUrgent,pli.`BarcodeNo`,pm.`PName`,sl.DispatchCode,pm.`Age`,pm.`Gender`,pli.`SampleTypeID`,pli.`SampleTypeName`,GROUP_CONCAT(CONCAT(IFNULL(imm.`Colour`,'White'),'|',IFNULL((SELECT NAME FROM macmaster WHERE ID=imm.MachineID),'Add Machine Name')))MachineColour,  ");
                sb.Append(" IFNULL((SELECT  OutSrcLabName FROM `investigations_outsrclab`WHERE CentreID = @CentreID AND `Investigation_ID` = pli.Investigation_ID),'')OutsourceCentre, ");
                sb.Append(" IFNULL((SELECT cm.centre FROM `test_centre_mapping` tcm INNER JOIN centre_master cm ON cm.`CentreID`=tcm.`Test_Centre` ");
                sb.Append(" WHERE `Booking_Centre` = 2 AND Test_Centre <> Booking_Centre AND `Investigation_ID` = pli.Investigation_ID),'')TestCentre, ");
                sb.Append("  IF(HistoCytoSampleDetail<>'', ");
                sb.Append(" CONCAT(");
                sb.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 1), '^', -1)<>'0',CONCAT('Container:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 1), "); sb.Append("'^', -1)),''),");
                sb.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 2), '^', -1)<>'0',CONCAT(' , Slides:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 2),"); sb.Append("'^', -1)),''),");
                sb.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 3), '^', -1)<>'0',CONCAT(', Blocks:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 3),"); sb.Append(" '^', -1)),''))");
                sb.Append(" ,'') SampleInfo ");
                sb.Append("  ,DATE_FORMAT(dtSent,'%d-%b-%y %h:%i %p') dtSent,DATE_FORMAT(dtLogisticReceive,'%d-%b-%y %h:%i %p') dtLogisticReceive ");
                sb.Append("  ,GROUP_CONCAT(CAST(im.`Investigation_Id` AS CHAR))Investigation_Id,GROUP_CONCAT(CAST(im.`Name` AS CHAR)) AS Test,GROUP_CONCAT(DISTINCT CAST(scm.`Abbreviation` AS CHAR))Department  ");
                sb.Append(" ,(CASE WHEN (SELECT COUNT(*) FROM `test_centre_mapping`  ");
                sb.Append("  WHERE `Booking_Centre`=@CentreID AND Test_Centre<>Booking_Centre AND `Investigation_ID`=pli.Investigation_ID) >0 THEN '1'  ");
                sb.Append("  WHEN (SELECT COUNT(*) FROM `investigations_outsrclab`  ");
                sb.Append("  WHERE CentreID=@CentreID AND `Investigation_ID`=pli.Investigation_ID) >0 THEN '2'  ");
                sb.Append("  ELSE '0' END )Segregation,pli.LedgertransactionNo         ");
                sb.Append("  FROM `patient_labinvestigation_opd` pli   ");
                sb.Append("  INNER JOIN `investigation_master` im ON im.`Investigation_Id`=pli.`Investigation_ID`  and pli.IsSampleCollected<>'R' AND pli.isactive=1  AND pli.`IsReporting`=1   ");
                sb.Append("  INNER JOIN `f_subcategorymaster` scm ON scm.`SubCategoryID`=pli.`SubCategoryID`    ");
                sb.Append("  INNER JOIN `investigations_sampletype` ist ON ist.`Investigation_ID`=pli.`Investigation_ID` AND ist.`IsDefault`=1   ");
                sb.Append("  INNER JOIN patient_master pm ON pm.`Patient_ID`=pli.`Patient_ID` ");
                sb.Append("  INNER JOIN sample_logistic sl ON sl.BarcodeNo=pli.`BarcodeNo` AND sl.`testid`=pli.`Test_ID` ");
                sb.Append(" LEFT JOIN investigation_machinemaster imm ON imm.`CentreID`=@CentreID AND imm.`Investigation_ID`=pli.`Investigation_ID` ");
                sb.Append("  WHERE pli.`BarcodeNo`=@BarcodeNo ");
                sb.Append("  AND sl.ToCentreID=@CentreID AND sl.Status ='Received at Hub' AND sl.IsActive=1 ");
			

              
                sb.Append(" AND pli.Test_Id  IN (" + data[0].Test_ID + ") ");

                sb.Append(" AND pli.IsReporting=1  GROUP BY SampletypeID,Segregation  ");

                dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@CentreID", UserInfo.Centre),
                    new MySqlParameter("@BarcodeNo", data[0].BarcodeNo.Trim())).Tables[0];

                dt.Columns.Add("Total");
                dt.Columns.Add("Received");
                dt.Columns.Add("Rejected");
                dt.Columns.Add("Pending");
                if (dt.Rows.Count > 0)
                {
                    string Status = string.Empty;
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        sb = new StringBuilder();
                        string finalstatus = string.Empty;

                        if (dt.Rows[i]["Segregation"].ToString() == "1")
                        {
                            finalstatus = "Transferred";
                        }
                        else if (dt.Rows[i]["Segregation"].ToString() == "2")
                        {
                            finalstatus = "OutSource";
                        }
                        else
                        {
                            finalstatus = "Received";
                        }
                        string aa = dt.Rows[i]["Test_ID"].ToString();
                        string[] arrtestid = aa.Split(',');
                        for (int a = 0; a < arrtestid.Length; a++)
                        {
                            sb.Append("update sample_logistic set `Status`=@Status,SDRDate=now(),SDRBy=@ReceivedBy,ReceivedDate=now(),ReceivedBy=@ReceivedBy where BarcodeNo=@BarcodeNo and `Status`='Received at Hub' and ToCentreID=@CentreID and testid=@testid; ");
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                             new MySqlParameter("@BarcodeNo", data[0].BarcodeNo.Trim()),
                            new MySqlParameter("@CentreID", UserInfo.Centre),
                            new MySqlParameter("@ReceivedBy", UserInfo.ID), new MySqlParameter("@Status", finalstatus),
                            new MySqlParameter("@testid", arrtestid[a]));

                            if (finalstatus == "Received" || finalstatus == "SDR OUTSOURCE")
                            {

                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "CALL insert_Mac_Detail_testID('" + UserInfo.Centre + "'," +
                                    arrtestid[a] + ",'Receive','" + data[0].BarcodeNo.Trim() + "');");
                            

                                
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET IsSRA=1 ,SRADate=NOW() WHERE test_id=@testid",
                                         new MySqlParameter("@testid", arrtestid[a]));

                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd_share SET IsSRA=1 ,SRADate=NOW() WHERE test_id=@testid",
                                         new MySqlParameter("@testid", arrtestid[a]));
                            }
                        }
                    }
                    if (dt.Select("Segregation>0").Length == 0)
                    {
                      //  MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "CALL insert_Mac_Detail(@CentreID,@BarcodeNo,'Receive');",
                      //      new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@BarcodeNo", data[0].BarcodeNo.Trim()));
                        sb.Append("update sample_logistic set `Status`='Received',ReceivedDate=now(),ReceivedBy=@ReceivedBy where BarcodeNo=@BarcodeNo and `Status`='Received at Hub' and ToCentreID=@CentreID; ");
                        Status = "SRA Received, Send to Department";
                    }
                    else
                    {
                     //   MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "CALL insert_Mac_Detail(@CentreID,@BarcodeNo,'Receive')",
                     //       new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@BarcodeNo", data[0].BarcodeNo.Trim()));
                        sb.Append("update sample_logistic set `Status`='SDR',SDRDate=now(),SDRBy=@ReceivedBy where BarcodeNo=@BarcodeNo and `Status`='Received at Hub' and ToCentreID=@CentreID; ");
                        Status = "SRA Received, Send to Outsource Department";
                    }
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode) ",
                       new MySqlParameter("@LedgertransactionNo", dt.Rows[0]["LedgertransactionNo"].ToString()),
                       new MySqlParameter("@SinNo", data[0].BarcodeNo.Trim()), new MySqlParameter("@Test_ID", "0"),
                       new MySqlParameter("@Status", string.Format("SIN No. {0} {1}", data[0].BarcodeNo.Trim(), Status)), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                       new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID),
                       new MySqlParameter("@DispatchCode", dt.Rows[0]["DispatchCode"])
                       );

                    // Getting Batch Detail
                    sb = new StringBuilder();
                    sb.Append("SELECT COUNT(1)Total,SUM(IF(STATUS IN('Received','OutSource'),1,0))Received,SUM(IF(STATUS='Rejected',1,0))Rejected FROM `sample_logistic` WHERE dispatchcode=@dispatchCode ; ");
                    DataTable dtBatch = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@dispatchCode", dt.Rows[0]["DispatchCode"].ToString())).Tables[0];

                    if (dtBatch.Rows.Count == 1)
                    {
                        dt.Rows[0]["Total"] = dtBatch.Rows[0]["Total"].ToString();
                        dt.Rows[0]["Received"] = dtBatch.Rows[0]["Received"].ToString();
                        dt.Rows[0]["Rejected"] = dtBatch.Rows[0]["Rejected"].ToString();
                        dt.Rows[0]["Pending"] = Util.GetInt(dtBatch.Rows[0]["Total"]) - Util.GetInt(dtBatch.Rows[0]["Received"]) - Util.GetInt(dtBatch.Rows[0]["Rejected"]);
                    }
                }
                tnx.Commit();
                data.Clear();
                 return JsonConvert.SerializeObject(new { status = true, response = dt });
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }      
    }
    [WebMethod]
    public static string getSampleList(List<SampleSearch> data)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT pli.sampleqty, sl.ID sampleLogisticID,sl.`dispatchCode`,pli.`BarcodeNo`,pm.`PName`,pm.`Age`,pm.`Gender`,ist.`SampleTypeID`,ist.`SampleTypeName` , ");
            sb.Append("  IF(HistoCytoSampleDetail<>'', ");
            sb.Append(" CONCAT(");
            sb.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 1), '^', -1)<>'0',CONCAT('Container:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 1), "); sb.Append("'^', -1)),''),");
            sb.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 2), '^', -1)<>'0',CONCAT(' , Slides:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 2),"); sb.Append("'^', -1)),''),");
            sb.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 3), '^', -1)<>'0',CONCAT(', Blocks:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 3),"); sb.Append(" '^', -1)),''))");
            sb.Append(" ,'') SampleInfo ");
            sb.Append("  ,CAST(GROUP_CONCAT(im.`Name`)as CHAR)Test,sl.Status   ");
            sb.Append("  FROM `patient_labinvestigation_opd` pli   ");
            sb.Append("  INNER JOIN `investigation_master` im ON im.`Investigation_Id`=pli.`Investigation_ID`  and pli.IsSampleCollected<>'R'   ");
            sb.Append("  INNER JOIN `investigations_sampletype` ist ON ist.`Investigation_ID`=pli.`Investigation_ID` AND ist.`IsDefault`=1  ");
            sb.Append("  INNER JOIN sample_logistic sl ON sl.BarCodeNo=pli.BarCodeNo ");
            sb.Append("   ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`Patient_ID`=pli.`Patient_ID` WHERE sl.`dispatchCode`=@dispatchCode and sl.Status=@Status and pli.IsReporting=1 GROUP BY pli.`BarcodeNo`  ");

            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@dispatchCode", data[0].BatchNo.Trim()),
                new MySqlParameter("@Status", data[0].Status)).Tables[0]);
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
    public static string getSampleListpending()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT pli.sampleqty, sl.ID sampleLogisticID,sl.`dispatchCode`,pli.`BarcodeNo`,pm.`PName`,pm.`Age`,pm.`Gender`,ist.`SampleTypeID`,ist.`SampleTypeName` , ");
            sb.Append("  IF(HistoCytoSampleDetail<>'', ");
            sb.Append(" CONCAT(");
            sb.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 1), '^', -1)<>'0',CONCAT('Container:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 1), "); sb.Append("'^', -1)),''),");
            sb.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 2), '^', -1)<>'0',CONCAT(' , Slides:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 2),"); sb.Append("'^', -1)),''),");
            sb.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 3), '^', -1)<>'0',CONCAT(', Blocks:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 3),"); sb.Append(" '^', -1)),''))");
            sb.Append(" ,'') SampleInfo ");
            sb.Append("  ,CAST(GROUP_CONCAT(im.`Name`)as CHAR)Test,sl.Status   ");
            sb.Append("  FROM `patient_labinvestigation_opd` pli   ");
            sb.Append("  INNER JOIN `investigation_master` im ON im.`Investigation_Id`=pli.`Investigation_ID`  and pli.IsSampleCollected<>'R'   ");
            sb.Append("  INNER JOIN `investigations_sampletype` ist ON ist.`Investigation_ID`=pli.`Investigation_ID` AND ist.`IsDefault`=1  ");
            sb.Append("  INNER JOIN sample_logistic sl ON sl.BarCodeNo=pli.BarCodeNo ");
            sb.Append("   ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`Patient_ID`=pli.`Patient_ID` WHERE sl.ToCentreID=@ToCentreID and sl.Status='Received at Hub' and pli.IsReporting='1' GROUP BY pli.`BarcodeNo`  ");

            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@ToCentreID", UserInfo.Centre)).Tables[0]);
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
    [WebMethod(EnableSession = true)]
    public static string updateLogistic(string sampleLogisticID, string dispatchCode, string removeCondition, string SinNo)
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(8);
        int ReqCount = MT.GetIPCount(8);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return "Too Many Request,Try Again after some";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sample_logistic SET IsActive=@IsActive,UpdatedBy=@UpdatedBy,updatedDate=NOW(),Status='Rejected' WHERE ID=@ID ",
                 new MySqlParameter("@IsActive", "0"), new MySqlParameter("@UpdatedBy", UserInfo.ID),
                 new MySqlParameter("@ID", sampleLogisticID));

            string LedgertransactionNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT LedgertransactionNo FROM patient_labinvestigation_opd WHERE BarcodeNo=@BarcodeNo",
               new MySqlParameter("@BarcodeNo", SinNo.Trim())));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode) ",
                new MySqlParameter("@LedgertransactionNo", LedgertransactionNo),
                new MySqlParameter("@SinNo", SinNo), new MySqlParameter("@Test_ID", "0"),
                new MySqlParameter("@Status", string.Format("SIN No. {0} Rejected from Batch No. {1}", SinNo.Trim(), dispatchCode)),
                new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                new MySqlParameter("@IpAddress", StockReports.getip()),
                new MySqlParameter("@CentreID", UserInfo.Centre),
                new MySqlParameter("@RoleID", UserInfo.RoleID),
                new MySqlParameter("@DispatchCode", dispatchCode));
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Removed Removed Successfully" });
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
    [WebMethod(EnableSession = true)]
    public static string getLogisticData(string dispatchCode)
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT COUNT(*)Total,SUM(IF(STATUS='Received',1,0))Received,SUM(IF(STATUS='Rejected',1,0))Rejected,0 Pending FROM `sample_logistic` WHERE dispatChcode=@dispatchCode ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@dispatChcode", dispatchCode)).Tables[0])
            {

                if (dt.Rows.Count == 1)
                {
                    dt.Rows[0]["Pending"] = Util.GetInt(dt.Rows[0]["Total"]) - Util.GetInt(dt.Rows[0]["Received"]) - Util.GetInt(dt.Rows[0]["Rejected"]);
                }
                return JsonConvert.SerializeObject(new { status = true, response = dt });
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
    public static string GetSampleTypeWiseData(string BarcodeNo, string Inhouse)
    {
        StringBuilder sb = new StringBuilder();

        //if (Inhouse == "1")
        //{
        //    sb.Append(" SELECT GROUP_CONCAT(pli.ItemName) TestName,GROUP_CONCAT(pli.Test_Id)Test_Id, pli.SampleTypeName,GROUP_CONCAT(sm.Name) Department,lt.PName,lt.Age,CONCAT(cm.`CentreCode`,'~',cm.`Centre`)BookingCentre ,pli.`PackageName`,IF(UPPER(lt.DoctorName)='OTHER','',lt.`DoctorName`) ReferDoctor  ");
        //    sb.Append(" FROM `patient_labinvestigation_opd`pli  ");
        //    sb.Append(" INNER JOIN f_SubCategorymaster sm ON sm.SubCategoryId=pli.SubCategoryId ");
        //    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.ledgertransactionId=pli.ledgertransactionId ");
        //    sb.Append("  INNER JOIN centre_master cm    ON lt.`CentreID`=cm.`CentreID`");
        //    sb.Append("  left join sample_logistic sl on sl.testid=pli.test_id and sl.barcodeno=pli.BarcodeNo and sl.ToCentreID=" + UserInfo.Centre + "  ");
        //    sb.Append(" WHERE pli.`BarcodeNo`='" + BarcodeNo + "' AND pli.isSampleCollected='S' AND pli.`CentreIDSession`=" + UserInfo.Centre + " AND pli.IsReporting='1'   ");
        //    sb.Append(" AND pli.IsSRA=0 AND sl.ID IS NULL  GROUP BY SampleTypeId  ");  //AND sl.ID IS NULL

        //}
        //else
        //{
            sb.Append(" SELECT GROUP_CONCAT(pli.ItemName) TestName,GROUP_CONCAT(pli.Test_Id)Test_Id, pli.SampleTypeName,GROUP_CONCAT(Distinct sm.Name) Department,lt.PName,lt.Age,CONCAT(cm.`CentreCode`,'~',cm.`Centre`)BookingCentre ,pli.`PackageName`,IF(UPPER(lt.DoctorName)='OTHER','',lt.`DoctorName`) ReferDoctor  ");
            sb.Append(" FROM `patient_labinvestigation_opd` pli    ");
            sb.Append(" INNER JOIN f_SubCategorymaster sm ON sm.SubCategoryId=pli.SubCategoryId ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.ledgertransactionId=pli.ledgertransactionId ");
            sb.Append(" INNER JOIN sample_logistic sl ON sl.BarcodeNo=pli.`BarcodeNo`  AND sl.`testid`=pli.`Test_ID` ");
            sb.Append("  INNER JOIN centre_master cm    ON lt.`CentreID`=cm.`CentreID`");
            sb.Append(" WHERE pli.`BarcodeNo`='" + BarcodeNo + "'  ");
            sb.Append(" AND sl.ToCentreID=" + UserInfo.Centre + " AND sl.Status ='Received at Hub' AND sl.IsActive=1  ");
            sb.Append(" AND pli.IsReporting='1' AND pli.IsSRA=0 GROUP BY  SampleTypeId   ");

        //}


        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
    }

    //-------------------------------------------------------------------------
}
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_Lab_EditBatch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Util.GetString(Request.QueryString["batchNo"]) != string.Empty)
                txtBatchNo.Text = Util.GetString(Common.Decrypt(Request.QueryString["batchNo"]));
            else
                txtBatchNo.Text = string.Empty;
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                string qry = string.Format("Select ToCentreId FROM Sample_Logistic WHERE DispatchCode=@DispatchCode");
                ddlCentre.Value = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, qry,
                   new MySqlParameter("@DispatchCode", txtBatchNo.Text)));
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
        txtBatchNo.Focus();
    }

    [WebMethod]
    public static string BatchSearch(string BatchNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (BatchNo.Trim() == string.Empty)
            {
                return "-1";
            }
            if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM sample_logistic sm WHERE sm.`DispatchCode`=@DispatchCode AND sm.`Status`='Transferred' AND sm.`IsActive`=1",
               new MySqlParameter("@DispatchCode", BatchNo.Trim()))) > 0)
            {
                return "-1";
            }
            int TotalItems = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM `sample_logistic` sm WHERE sm.`DispatchCode`=@DispatchCode AND isActive=1",
                new MySqlParameter("@DispatchCode", BatchNo.Trim())));
            int TotalItemsReceived = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM `sample_logistic` sm WHERE sm.`DispatchCode`=@DispatchCode AND isActive=1 AND STATUS='Received'",
                new MySqlParameter("@DispatchCode", BatchNo.Trim())));
            if (TotalItems == TotalItemsReceived)
            {
                return "-1";
            }

            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT pli.`BarcodeNo`,pm.`PName`,pm.`Age`,pm.`Gender`,ist.`SampleTypeName`  ");
            sb.Append("  ,GROUP_CONCAT(im.`Investigation_Id`)Investigation_Id,GROUP_CONCAT(im.`Name`) AS Test ,sl.Status,sl.`DispatchCode`,SUM(distinct Qty)Quantity,sl.ToCentreID,sl.PickUpFieldBoyID,sl.PickUpFieldBoy,sl.CourierDetail,sl.CourierDocketNo,group_concat(sl.ID) sampleLogisticID ,group_concat(pli.test_id ) test_id   ");
            sb.Append("  FROM `patient_labinvestigation_opd` pli   ");
            sb.Append("  INNER JOIN `investigation_master` im ON im.`Investigation_Id`=pli.`Investigation_ID`  AND pli.IsActive=1 ");
            sb.Append("  INNER JOIN `investigations_sampletype` ist ON ist.`Investigation_ID`=pli.`Investigation_ID` AND ist.`IsDefault`=1   ");
            sb.Append("  INNER JOIN sample_logistic sl ON sl.BarcodeNo=pli.BarcodeNo AND sl.IsActive=1 ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`Patient_ID`=pli.`Patient_ID` WHERE sl.`DispatchCode`=@BatchNo AND pli.CentreIdSession=@CentreID GROUP BY pli.`BarcodeNo`  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@BatchNo", BatchNo),
                    new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0])
                return Util.getJson(dt);
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
    public static string addBatch(string SinNo, List<SampleSearch> data)
    {
        string BatchNo = data[0].BatchNo;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM sample_logistic sm WHERE sm.`DispatchCode`=@DispatchCode AND sm.`Status`='Transferred' AND sm.`IsActive`=1",
                new MySqlParameter("@DispatchCode", data[0].BatchNo))) > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Unable To Add Any Sample In This Batch Because Its Already Transferredd" });

            }
            DataTable dtCheck = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT IFNULL(DispatchCode,'')DispatchCode,COUNT(*) CNT FROM sample_logistic WHERE  `status`!='SDR Transfered' AND BarcodeNo=@BarcodeNo AND `IsActive`=1",
               new MySqlParameter("@BarcodeNo", SinNo)).Tables[0];

            if (Util.GetInt(dtCheck.Rows[0]["CNT"]) > 0)
            {
                con.Close();
                con.Dispose();
                if (Util.GetString(dtCheck.Rows[0]["DispatchCode"]) == string.Empty)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });

                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Batch No. ", Util.GetString(dtCheck.Rows[0]["DispatchCode"]), " already created") });

                }
            }

            int logesticCentreID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT  ToCentreID FROM sample_logistic WHERE barcodeno = @barcodeno  AND `status`='SDR Transfered'  ORDER BY `dtEntry` DESC LIMIT 1",
                new MySqlParameter("@barcodeno", SinNo)));

            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT 'Pending for Dispatch' Status,@BatchNo `DispatchCode`,0 sampleLogisticID,pli.SampleQty Quantity,pli.SampleQty sampleqty, pli.`BarcodeNo`,pm.`PName`,pm.`Age`,pm.`Gender`,pli.`SampleTypeID`,pli.`SampleTypeName` ");
            sb.Append(" ,GROUP_CONCAT(DISTINCT pli.`SampleTypeID`)ColorValue, GROUP_CONCAT(pli.test_id) testid");
            sb.Append("  ,GROUP_CONCAT(im.`Investigation_Id`)Investigation_Id,GROUP_CONCAT(im.`Name`) AS Test,pli.LedgertransactionNo,pli.LedgertransactionID   ");
            sb.Append("  FROM `patient_labinvestigation_opd` pli   ");
            sb.Append("  INNER JOIN `investigation_master` im ON im.`Investigation_Id`=pli.`Investigation_ID` AND pli.IsSampleCollected='S'   ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`Patient_ID`=pli.`Patient_ID` WHERE pli.`BarcodeNo`=@BarcodeNo ");
            if (logesticCentreID > 0)
            {
                sb.Append(" AND " + UserInfo.Centre + "=@logesticCentreID ");
            }
            else
            {
                  sb.Append("  AND ( pli.CentreIdSession=@TestCentreID OR pli.`TestCentreID` = @TestCentreID ) ");
            }
            sb.Append("  AND pli.IsReporting=1 GROUP BY pli.`BarcodeNo`  ");

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@BatchNo", BatchNo),
                new MySqlParameter("@BarcodeNo", SinNo), new MySqlParameter("@TestCentreID", UserInfo.Centre),
                new MySqlParameter("@logesticCentreID", logesticCentreID)).Tables[0];




            if (dt.Rows.Count == 1)
            {
                MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                try
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " update sample_logistic sl set sl.Status ='BatchCreated' where sl.BarcodeNo=@BarcodeNo  AND sl.Status ='SDR Transfered' AND sl.ToCentreID = @ToCentreID ",
                       new MySqlParameter("@BarcodeNo", SinNo),
                       new MySqlParameter("@ToCentreID", UserInfo.Centre));


                    string aa = dt.Rows[0]["testid"].ToString();
                    string[] testid = aa.Split(',');
                    for (int a = 0; a < testid.Length; a++)
                    {
                        sb = new StringBuilder();
                        sb.Append("insert into sample_logistic(BarcodeNo,Barcode_Group,FromCentreID,ToCentreID,DispatchCode,Qty,EntryBy,`Status`,BatchCreatedDate,BatchCreatedBy,testid) ");
                        sb.Append(" values(@BarcodeNo,@BarcodeNo,@FromCentreID,@ToCentreID,@DispatchCode,@Qty,@EntryBy,@STATUS,now(),@BatchCreatedBy,@testid);");

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@BarcodeNo", SinNo),
                            new MySqlParameter("@FromCentreID", UserInfo.Centre),
                            new MySqlParameter("@ToCentreID", data[0].ToCentreID),
                            new MySqlParameter("@DispatchCode", BatchNo),
                            new MySqlParameter("@Qty", dt.Rows[0]["sampleqty"]),
                            new MySqlParameter("@EntryBy", UserInfo.ID),
                            new MySqlParameter("@STATUS", "Pending for Dispatch"),
                            new MySqlParameter("@BatchCreatedBy", UserInfo.ID),
                            new MySqlParameter("@testid", testid[a])
                            );
                        dt.Rows[0]["sampleLogisticID"] = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT @@Identity"));

                    }

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgertransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode,@LedgertransactionID) ",
                       new MySqlParameter("@LedgertransactionNo", dt.Rows[0]["LedgertransactionNo"].ToString()),
                       new MySqlParameter("@LedgertransactionID", dt.Rows[0]["LedgertransactionID"].ToString()),
                       new MySqlParameter("@SinNo", SinNo), new MySqlParameter("@Test_ID", "0"),
                       new MySqlParameter("@Status", string.Format("SIN No. {0} Added to Batch No. {1}", data[0].BarcodeNo, data[0].BatchNo)),
                       new MySqlParameter("@UserID", UserInfo.ID),
                       new MySqlParameter("@UserName", UserInfo.LoginName),
                       new MySqlParameter("@IpAddress", StockReports.getip()),
                       new MySqlParameter("@CentreID", UserInfo.Centre),
                       new MySqlParameter("@RoleID", UserInfo.RoleID),
                       new MySqlParameter("@DispatchCode", BatchNo));
                    tnx.Commit();
                    return JsonConvert.SerializeObject(new { status = true, response = Util.getJson(dt) });

                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Error" });
                }
                finally
                {
                    tnx.Dispose();

                }
            }
            else
                return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
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
    public static string updateLogistic(string sampleLogisticID, string BatchNo, string SinNo, string testid)
    {
        if (BatchNo.Trim() == string.Empty)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "BatchNo Cannot Blank" });
        }
        if (SinNo.Trim() == string.Empty)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Sin No. Cannot Blank" });
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sample_logistic SET Status='SDR Transfered' WHERE testid IN (" + testid + ") AND tocentreid=@tocentreid and Status='BatchCreated'",
                new MySqlParameter("@tocentreid", UserInfo.Centre));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sample_logistic SET IsActive=@IsActive,UpdatedBy=@UpdatedBy,updatedDate=NOW() WHERE ID IN (" + sampleLogisticID + ") ",
                 new MySqlParameter("@IsActive", "0"),
                 new MySqlParameter("@UpdatedBy", UserInfo.ID));


            string LedgertransactionNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT LedgertransactionNo FROM patient_labinvestigation_opd WHERE BarcodeNo=@BarcodeNo LIMIT 1",
                           new MySqlParameter("@BarcodeNo", SinNo)));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode) ",
                new MySqlParameter("@LedgertransactionNo", LedgertransactionNo),
                new MySqlParameter("@SinNo", SinNo),
                new MySqlParameter("@Test_ID", "0"),
                new MySqlParameter("@Status", string.Format("SIN No. {0} Remove from Batch No. {1}", SinNo, BatchNo)),
                new MySqlParameter("@UserID", UserInfo.ID),
                new MySqlParameter("@UserName", UserInfo.LoginName),
                new MySqlParameter("@IpAddress", StockReports.getip()),
                new MySqlParameter("@CentreID", UserInfo.Centre),
                new MySqlParameter("@RoleID", UserInfo.RoleID),
                new MySqlParameter("@DispatchCode", BatchNo)
                 );

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Record Removed Successfully" });
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
}
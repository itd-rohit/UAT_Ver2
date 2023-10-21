using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Linq;

public partial class Design_Lab_SendSample : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
             
            if (Resources.Resource.SRARequired == "0")
            {
                lblMsg.Text = "You Do not have right to access this Page";
                txtBarcode.Enabled = true;
            }

            string Ctype = UserInfo.CentreType;

            if (Ctype == "PCC" || Ctype == "B2B" && Ctype == "FC" && Ctype == "CC")
            {
                chkAllCentre.Enabled = false;

            }


                   
            
            getcolor();


            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);

            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;

            AllLoad_Data.getCurrentDate(txtFromDateBarcode, txtToDateBarcode);

            calFromDateBarcode.EndDate = DateTime.Now;
            calToDateBarcode.EndDate = DateTime.Now;
           
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");

    }

    void getcolor()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT color,GROUP_CONCAT(CAST(ID AS CHAR) SEPARATOR ' ') id FROM sampletype_master WHERE isActive=1 GROUP BY color ORDER BY color"))
        {
            List<string> finalstring = new List<string>();
            foreach (DataRow dw in dt.Rows)
            {
                finalstring.Add(string.Format("<span style='background-color:{0};padding:10px;float:left;font-weight:bold;margin-left:5px;' class='{1}'>0</span>", dw["color"], dw["id"]));
            }

            colordiv.InnerHtml = string.Join("", finalstring);
        }
    }

    [WebMethod]
    public static string SampleSearch(List<SampleSearch> data)
    {
        string BatchNo = string.Empty;
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            using (dt as IDisposable)
            {
                using (DataTable dtCheck = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT IFNULL(DispatchCode,'')DispatchCode,COUNT(*) CNT FROM sample_logistic WHERE  `status`='Pending for Dispatch' AND BarcodeNo=@BarcodeNo AND `IsActive`=1",
                     new MySqlParameter("@BarcodeNo", data[0].BarcodeNo)).Tables[0])
                {

                    if (Util.GetInt(dtCheck.Rows[0]["CNT"]) > 0)
                    {
                        tnx.Rollback();
                        if (Util.GetString(dtCheck.Rows[0]["DispatchCode"]) == string.Empty)
                        {
                            return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
                        }
                        else
                        {
                            return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Batch No ", Util.GetString(dtCheck.Rows[0]["DispatchCode"]), " already created") });
                        }
                    }
                }
                string duplicateFlag = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT DispatchCode FROM sample_logistic WHERE  DisPatchCode=@DisPatchCode AND `IsActive`=1 and DispatchCode!='' AND STATUS <> 'Pending FOR Dispatch' ",
                    new MySqlParameter("@DisPatchCode", data[0].BatchNo)));
                if (duplicateFlag != string.Empty)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Batch No ", Util.GetString(duplicateFlag), " already created ") });
                }

                string LabCategory = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Category FROM centre_master WHERE centreID= @CentreID",
                    new MySqlParameter("@CentreID", UserInfo.Centre)));
                string LabTestID = string.Empty;

                if (LabCategory.ToUpper() == "LAB")
                {
                    sb = new StringBuilder();
                    sb.Append(" SELECT IFNULL(GROUP_CONCAT(CAST( a.Testid AS CHAR)),'')testid FROM  ");
                    sb.Append(" ( SELECT sl.Testid FROM sample_logistic sl ");
                    sb.Append(" WHERE sl.BarcodeNo=@BarcodeNo AND sl.Status ='Transferred' AND sl.ToCentreID = @CentreID AND sl.IsActive=1 ) a ");
                    sb.Append(" LEFT JOIN  ");
                    sb.Append(" (SELECT sl.testid FROM  sample_logistic sl ");
                    sb.Append(" WHERE sl.BarcodeNo=@BarcodeNo AND  sl.FromCentreID = @CentreID AND sl.ToCentreID != sl.FromCentreID  ");
                    sb.Append(" AND sl.IsActive=1 ) b ON a.testid=b.testid ");
                    sb.Append(" WHERE b.testid IS NULL  ");
                    LabTestID = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@BarcodeNo", data[0].BarcodeNo), new MySqlParameter("@CentreID", UserInfo.Centre)).ToString();

                    if (LabTestID == string.Empty)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
                    }
                }

             //   List<string> LabTestIDList = LabTestID.Select(c => c.ToString()).ToList();
			 List<string> LabTestIDList = LabTestID.TrimEnd(',').Split(',').ToList<string>(); //LabTestID.Select(c => c.ToString()).ToList();

                sb = new StringBuilder();
                sb.Append("  SELECT pli.SampleQty sampleQty, pli.`BarcodeNo`,pli.Barcode_Group,pm.`PName`,pm.`Age`,pm.`Gender`,pli.`SampleTypeID`,pli.`SampleTypeName` ");
                sb.Append(" ,GROUP_CONCAT(DISTINCT CAST( pli.`SampleTypeID` AS CHAR))ColorValue, GROUP_CONCAT(CAST(pli.test_id AS CHAR)) testid");
                sb.Append("  ,GROUP_CONCAT(CAST( im.`Investigation_Id` AS CHAR))Investigation_Id,GROUP_CONCAT(CAST(im.`Name` AS CHAR)) AS Test,pli.LedgertransactionNo   ");
                sb.Append("  FROM `patient_labinvestigation_opd` pli   ");
                sb.Append("  INNER JOIN `investigation_master` im ON im.`Investigation_Id`=pli.`Investigation_ID` AND pli.IsSampleCollected='S'   ");
                if (LabCategory.ToUpper() == "LAB")
                    sb.Append("  INNER JOIN sample_logistic sl ON sl.BarcodeNo=pli.`BarcodeNo` AND sl.`testid`=pli.`Test_ID` and sl.testid in ({0}) AND sl.Status ='Transferred' AND sl.ToCentreID = @CentreID AND sl.IsActive=1  ");
                else
                    sb.Append("  AND ( pli.CentreIdSession=@CentreID OR pli.`TestCentreID` = @CentreID  OR pli.`CentreID` = @CentreID) ");
                sb.Append("  INNER JOIN patient_master pm ON pm.`Patient_ID`=pli.`Patient_ID` WHERE pli.`BarcodeNo`=@BarcodeNo ");
                sb.Append("  AND pli.IsReporting=1 GROUP BY pli.`BarcodeNo`  ");

               // System.IO.File.WriteAllText (@"D:\Shat\aa.txt", string.Join(",", LabTestIDList));
                using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", LabTestIDList)), con))
                {
                    da.SelectCommand.Parameters.AddWithValue("@CentreID", UserInfo.Centre);
                    da.SelectCommand.Parameters.AddWithValue("@BarcodeNo", data[0].BarcodeNo);
                    for (int i = 0; i < LabTestIDList.Count; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(string.Concat("@LabTestParam", i), LabTestIDList[i]);
                    }
                    da.Fill(dt);
                    LabTestIDList.Clear();
                }
            }
            if (dt.Rows.Count > 0)
            {


                if (data[0].BatchNo == string.Empty)
                {
                    // BatchNo = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT  `get_batchno_centre`('" + UserInfo.Centre + "')  AS BatchNo "));
                }
                else
                {
                    BatchNo = data[0].BatchNo;
                }


                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE sample_logistic sl SET sl.Status ='BatchCreated' WHERE sl.BarcodeNo=@BarcodeNo  AND sl.Status ='Transferred' AND sl.ToCentreID = @ToCentreID",
                   new MySqlParameter("@BarcodeNo", data[0].BarcodeNo),
                   new MySqlParameter("@ToCentreID", UserInfo.Centre));

                string aa = dt.Rows[0]["testid"].ToString();
                string[] testid = aa.Split(',');
                for (int a = 0; a < testid.Length; a++)
                {
                    sb = new StringBuilder();
                    sb.Append("INSERT INTO sample_logistic(BarcodeNo,Barcode_Group,FromCentreID,ToCentreID,DispatchCode,Qty,EntryBy,`Status`,BatchCreatedDate,BatchCreatedBy,testID) ");
                    sb.Append(" values(@BarcodeNo,@BarcodeNo,@FromCentreID,@ToCentreID,@DispatchCode,@Qty,@EntryBy,@STATUS,now(),@BatchCreatedBy,@testID);");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@BarcodeNo", data[0].BarcodeNo),
                        new MySqlParameter("@FromCentreID", UserInfo.Centre),
                        new MySqlParameter("@ToCentreID", data[0].ToCentreID),
                        new MySqlParameter("@DispatchCode", BatchNo),
                        new MySqlParameter("@Qty", dt.Rows[0]["sampleQty"]),
                        new MySqlParameter("@EntryBy", UserInfo.ID),
                        new MySqlParameter("@STATUS", "Pending for Dispatch"), new MySqlParameter("@BatchCreatedBy", UserInfo.ID),
                        new MySqlParameter("@testID", testid[a])
                        );
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode) ",
                    new MySqlParameter("@LedgertransactionNo", dt.Rows[0]["LedgertransactionNo"].ToString()),
                    new MySqlParameter("@SinNo", data[0].BarcodeNo), new MySqlParameter("@Test_ID", "0"),
                    new MySqlParameter("@Status", string.Format("SIN No. {0} Added to Batch No. {1}", data[0].BarcodeNo, BatchNo)), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                    new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID),
                    new MySqlParameter("@DispatchCode", BatchNo));
            }
            else
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "No Record Found created" });
            }
            DataColumn dc = new DataColumn() { ColumnName = "BatchNo", DefaultValue = BatchNo };
            dt.Columns.Add(dc);
            tnx.Commit();
            return Util.getJson(dt);

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

    [WebMethod]
    public static string BatchSearch(List<SampleSearch> data)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT dispatchCode,COUNT(DISTINCT BarcodeNo) Quantity,`PickUpFieldBoyID`,`PickUpFieldBoy`,CourierDetail,CourierDocketNo,`Status` FROM sample_logistic ");
            sb.Append("  WHERE FromCentreID=@FromCentreID AND IsActive=1 ");
            if (data[0].FromDate != "0" && data[0].ToDate != "0")
                sb.Append(" AND DATE(dtEntry)>=@FromDate AND DATE(dtEntry)<=@toDate ");
            sb.Append("  GROUP BY dispatchCode ");
            sb.Append("  order by  ");
            sb.Append("  (CASE WHEN `STATUS` = 'Pending for Dispatch' THEN 1 ");
            sb.Append("  WHEN `STATUS` = 'Transferred' THEN 2 ");
            sb.Append("  WHEN `STATUS` = 'Received at Hub' THEN 3 ");
            sb.Append("  WHEN `STATUS` = 'Received' THEN 4 ");
            sb.Append("  WHEN `STATUS` = 'SDR' THEN 5 ");
            sb.Append("  WHEN `STATUS` = 'Rejected' THEN 6 ");
            sb.Append("  ELSE `STATUS` END ),  dtEntry DESC  ");


            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@FromCentreID", UserInfo.Centre),
                new MySqlParameter("@FromDate", Util.GetDateTime(data[0].FromDate).ToString("yyyy-MM-dd")),
                new MySqlParameter("@toDate", Util.GetDateTime(data[0].ToDate).ToString("yyyy-MM-dd"))).Tables[0]);

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
    public static string GenerateBatch()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT  `get_batchno_centre`(@CentreID)  AS BatchNo ",
               new MySqlParameter("@CentreID", UserInfo.Centre)));

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod]
    public static string UpdateBatchStatus(List<SampleSearch> data)
    {
        if (data[0].Status == "Transferred")
        {
            StringBuilder sb = new StringBuilder();
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                sb.Append("update sample_logistic set dtSent=now(),PickUpFieldBoyID=@PickUpFieldBoyID,PickUpFieldBoy=@PickUpFieldBoy,CourierDetail=@CourierDetail,CourierDocketNo=@CourierDocketNo,Status=@Status,TransferredDate=now(),TransferredBy=@TransferredBy WHERE dispatchCode=@dispatchCode ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@PickUpFieldBoyID", data[0].FieldBoyID),
                    new MySqlParameter("@PickUpFieldBoy", data[0].FieldBoy),
                    new MySqlParameter("@CourierDetail", data[0].CourierDetail),
                    new MySqlParameter("@CourierDocketNo", data[0].CourierDocketNo),
                    new MySqlParameter("@Status", data[0].Status),
                    new MySqlParameter("@dispatchCode", data[0].BatchNo),
                    new MySqlParameter("@TransferredBy", UserInfo.ID));

                StringBuilder sb1 = new StringBuilder();
                sb1.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode) ");
                sb1.Append(" SELECT ");
              //  sb1.Append("      (SELECT LedgertransactionNo FROM patient_labinvestigation_opd plo WHERE plo.BarcodeNo=sl.BarcodeNo  LIMIT 1)LedgertransactionNo, ");
			    sb1.Append("     '' LedgertransactionNo, ");
                sb1.Append("      sl.BarCodeNo,0,CONCAT('SIN No. ',sl.BarcodeNo ,' Transferred with Batch No. ',sl.DispatchCode),@UserID,@UserName,@IpAddress, ");
                sb1.Append("      @CentreID,@RoleID,NOW(),DispatchCode  FROM sample_logistic sl  WHERE sl.dispatchCode=@dispatchCode");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString(),
                   new MySqlParameter("@UserID", UserInfo.ID),
                   new MySqlParameter("@UserName", UserInfo.LoginName),
                   new MySqlParameter("@IpAddress", StockReports.getip()),
                   new MySqlParameter("@CentreID", UserInfo.Centre),
                   new MySqlParameter("@RoleID", UserInfo.RoleID),
                   new MySqlParameter("@dispatchCode", data[0].BatchNo));

                tnx.Commit();

            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objerror = new ClassLog();
                objerror.errLog(ex);
                throw (ex);
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        return "";
    }
    [WebMethod]
    public static string viewSampleData(string dispatchCode)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT sl.ID sampleLogisticID,sl.`dispatchCode`,pli.`BarcodeNo`,pm.`PName`, `Age`,pm.`Gender`,pli.`SampleTypeID`,pli.`SampleTypeName`,group_concat(CAST(pli.test_id AS CHAR)) test_id  ");
            sb.Append("  ,GROUP_CONCAT(CAST(im.`Name` as CHAR))Test,sl.Status   ");
            sb.Append("  FROM `patient_labinvestigation_opd` pli   ");
            sb.Append("  INNER JOIN `investigation_master` im ON im.`Investigation_Id`=pli.`Investigation_ID` AND pli.IsSampleCollected<>'R'   ");
            sb.Append("  INNER JOIN sample_logistic sl ON sl.testid=pli.test_id ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`Patient_ID`=pli.`Patient_ID` WHERE sl.`dispatchCode`=@dispatchCode AND pli.IsReporting=1  GROUP BY pli.`BarcodeNo`  ");

            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@dispatchCode", dispatchCode)).Tables[0]);
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
    public static string updateLogistic(string sampleLogisticID, string dispatchCode, string removeCondition, string SinNo, string testid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            if (removeCondition == "IN")
            {
                List<string> TestIDList = testid.Select(c => c.ToString()).ToList();
                using (MySqlCommand cmd = new MySqlCommand() { Connection = con, CommandType = CommandType.Text })
                {
                    sb = new StringBuilder();
                    sb.Append("update sample_logistic set Status='Transferred' where testid in ({0}) AND tocentreID=@tocentreID AND Status='BatchCreated'");
                    cmd.CommandText = String.Format(sb.ToString(), string.Join(",", TestIDList));
                    cmd.Parameters.Add(new MySqlParameter("@tocentreID", UserInfo.Centre));
                    for (int i = 0; i < TestIDList.Count; i++)
                    {
                        cmd.Parameters.Add(new MySqlParameter(string.Concat("@SuggestedParam", i), TestIDList[i]));
                    }

                    cmd.ExecuteNonQuery();
                    TestIDList.Clear();
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sample_logistic SET IsActive=@IsActive,UpdatedBy=@UpdatedBy,updatedDate=NOW() WHERE ID=@ID ",
                               new MySqlParameter("@IsActive", "0"),
                               new MySqlParameter("@UpdatedBy", UserInfo.ID),
                               new MySqlParameter("@ID", sampleLogisticID)
                    );
                string LedgertransactionNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT LedgertransactionNo FROM patient_labinvestigation_opd WHERE BarcodeNo=@BarcodeNo LIMIT 1",
                    new MySqlParameter("@BarcodeNo", SinNo)));

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode) ",
                    new MySqlParameter("@LedgertransactionNo", LedgertransactionNo),
                    new MySqlParameter("@SinNo", SinNo), new MySqlParameter("@Test_ID", "0"),
                    new MySqlParameter("@Status", string.Concat("SIN No. ", SinNo, " Remove from Batch No. ", dispatchCode)), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                    new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID),
                    new MySqlParameter("@DispatchCode", dispatchCode), new MySqlParameter("@SinNo", SinNo));
            }
            else
            {
                string test_id = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT IFNULL(GROUP_CONCAT(CAST(testid AS CHAR)),'')testid FROM sample_logistic WHERE  IsActive=1 AND  dispatchCode=@dispatchCode",
                   new MySqlParameter("@dispatchCode", dispatchCode)));
                if (test_id == string.Empty)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Error" });
                }
                List<string> TestIDList = test_id.Select(c => c.ToString()).ToList();
                using (MySqlCommand cmd = new MySqlCommand() { Connection = con, CommandType = CommandType.Text })
                {
                    sb = new StringBuilder();
                    sb.Append("UPDATE sample_logistic set Status='Transferred' where testid in ({0}) and tocentreid=@tocentreID and Status='BatchCreated'");
                    cmd.CommandText = String.Format(sb.ToString(), string.Join(",", TestIDList));
                    cmd.Parameters.Add(new MySqlParameter("@tocentreID", UserInfo.Centre));
                    for (int i = 0; i < TestIDList.Count; i++)
                    {
                        cmd.Parameters.Add(new MySqlParameter(string.Concat("@SuggestedParam", i), TestIDList[i]));
                    }
                    cmd.ExecuteNonQuery();
                    TestIDList.Clear();
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sample_logistic SET IsActive=@IsActive,UpdatedBy=@UpdatedBy,updatedDate=NOW() WHERE dispatchCode=@dispatchCode ",
                                     new MySqlParameter("@IsActive", 0),
                                     new MySqlParameter("@UpdatedBy", UserInfo.ID),
                                     new MySqlParameter("@dispatchCode", dispatchCode));
                sb = new StringBuilder();
                sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode) ");
                sb.Append("    SELECT ");
              //  sb.Append("          (SELECT LedgertransactionNo FROM patient_labinvestigation_opd plo WHERE plo.BarcodeNo=sl.BarcodeNo  LIMIT 1)LedgertransactionNo,");
			    sb.Append("         '' LedgertransactionNo,");
                sb.Append("           sl.BarCodeNo,0,CONCAT('SIN No. ',sl.BarcodeNo ,' Remove from Batch No. ',sl.DispatchCode),@UserID,@UserName,@IpAddress, ");
                sb.Append("           @CentreID,@RoleID,NOW(),DispatchCode  FROM sample_logistic sl WHERE sl.dispatchCode=@dispatchCode");


                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre),
                new MySqlParameter("@RoleID", UserInfo.RoleID),
                new MySqlParameter("@dispatchCode", dispatchCode));
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Removed Successfully" });
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
    [WebMethod]
    public static string rejectedSampleData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT pli.`BarCodeNo`,pm.`PName`,pm.`Age`,pm.`Gender`,pli.`SampleTypeID`,pli.`SampleTypeName` ");
            sb.Append("  ,GROUP_CONCAT(CAST(im.`Investigation_Id` AS CHAR))Investigation_Id,GROUP_CONCAT(CAST(im.`Name` AS CHAR)) AS Test ,sl.DispatchCode  ");
            sb.Append("  FROM `patient_labinvestigation_opd` pli   ");
            sb.Append("  INNER JOIN `investigation_master` im ON im.`Investigation_Id`=pli.`Investigation_ID`   ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`Patient_ID`=pli.`Patient_ID`    ");
            sb.Append("  INNER JOIN sample_logistic sl ON sl.BarCodeNo=pli.BarCodeNo WHERE sl.Status='Rejected' AND sl.IsActive=0  AND pli.CentreIdSession=@CentreID AND pli.IsReporting='1'  GROUP BY pli.`BarcodeNo` ");
            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }

    [WebMethod]
    public static int getRejectedSampleData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM sample_logistic WHERE Status='Rejected' AND IsActive=0 AND FromCentreID=@FromCentreID ",
               new MySqlParameter("FromCentreID", UserInfo.Centre)));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }
    [WebMethod]
    public static string bindSampleTransferCentre(string AllCentre)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (AllCentre.Trim() == "0")
            {
                string Ctype = UserInfo.CentreType;
                if (UserInfo.Centre != 1)
                {
                    if (Ctype != "PCC" && Ctype != "B2B" && Ctype != "FC" && Ctype != "CC")
                    {
                        sb.Append(" SELECT DISTINCT a.CentreID,cm.`Centre` FROM centre_master cm  ");
                        sb.Append(" INNER JOIN ( ");
                        sb.Append(" SELECT tcm.test_centre CentreID FROM test_centre_mapping tcm WHERE tcm.booking_centre=@CentreID AND tcm.test_centre<>@CentreID  ");
                        sb.Append(" UNION");
                        sb.Append(" SELECT tcm.test_centre2 CentreID FROM test_centre_mapping tcm WHERE tcm.booking_centre=@CentreID AND tcm.test_centre2<>@CentreID ");
                        sb.Append(" UNION ");
                        sb.Append(" SELECT  tcm.test_centre3 CentreID FROM test_centre_mapping tcm WHERE tcm.booking_centre=@CentreID AND tcm.test_centre3<>@CentreID ");
                        sb.Append(" )a ON a.CentreID=cm.`CentreID`");
                    }
                    else
                    {
                        sb.Append(" SELECT CentreID,Centre FROM centre_master WHERE CentreID=(Select TagProcessingLabID from centre_master where CentreID=@CentreID) AND IsActive=1 ORDER By Centre");
                    }
                }
                else
                {
                    sb.Append(" SELECT  cm.`CentreID`,cm.`Centre` FROM centre_master cm  WHERE cm.IsActive=1 ORDER BY centre");
                }
            }
            else
            {
                if (UserInfo.Centre != 1)
                {
                    sb.Append(" SELECT CentreID,Centre,type1,COCO_FOCO FROM centre_master WHERE Category='LAB' AND CentreID != @CentreID AND CentreID != 1 AND IsActive=1 ORDER BY Centre");
                }
                else
                {
                    sb.Append(" SELECT  cm.`CentreID`,cm.`Centre` FROM centre_master cm  WHERE cm.IsActive=1 ORDER BY Centre");
                }
            }


            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0]);

        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }

    [WebMethod]
    public static string UpdateBarcodeNo(string OldBarcode, string newBarcode)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            if (UserInfo.RoleID != 183)
            {
                string testid = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT IFNULL(GROUP_CONCAT(CAST(testID AS CHAR)),'')testID FROM sample_logistic WHERE barcodeno=@OldBarcode AND STATUS='Pending for Dispatch' GROUP BY barcodeno",
                    new MySqlParameter("@OldBarcode", OldBarcode)));
                string[] aa = testid.Split(',');
                for (int i = 0; i < aa.Length; i++)
                {
                    sb = new StringBuilder();
                    sb.Append("update sample_logistic set BarcodeNo=@BarcodeNo where  BarcodeNo=@OldBarcodeNo and testID=@testID ");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@BarcodeNo", newBarcode),
                        new MySqlParameter("@OldBarcodeNo", OldBarcode),
                        new MySqlParameter("@testID", aa[i]));

                    sb = new StringBuilder();

                    sb.Append("update patient_labinvestigation_opd set BarcodeNo=@BarcodeNo where  BarcodeNo=@OldBarcodeNo and test_id=@testID ");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@BarcodeNo", newBarcode),
                       new MySqlParameter("@OldBarcodeNo", OldBarcode),
                       new MySqlParameter("@testID", aa[i]));
                }
            }
            sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode) ");
            sb.Append(" SELECT ");
    // sb.Append("      (SELECT LedgertransactionNo FROM patient_labinvestigation_opd plo WHERE plo.BarcodeNo=sl.BarcodeNo  LIMIT 1)LedgertransactionNo, ");           
		   sb.Append("     '' LedgertransactionNo, ");
            sb.Append("      @newBarcode,0,CONCAT('SIN No. ',sl.BarcodeNo ,'Barcode change',sl.DispatchCode),@UserID,@UserName,@IpAddress, ");
            sb.Append("      @CentreID,@RoleID,NOW(),DispatchCode  FROM sample_logistic sl  WHERE STATUS='Pending for Dispatch' ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                  new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre),
                  new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@newBarcode", newBarcode));

            tnx.Commit();
            sb = new StringBuilder();
            return JsonConvert.SerializeObject(new { status = true, response = "BarCode Updated" });

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
    public static string BatchPending()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT dispatchCode,COUNT(DISTINCT BarcodeNo) Quantity,`PickUpFieldBoyID`,`PickUpFieldBoy`,CourierDetail,CourierDocketNo,`Status` FROM sample_logistic ");
            sb.Append("  WHERE FromCentreID=@FromCentreID AND IsActive=1 AND STATUS='Pending for Dispatch' ");
            sb.Append("  GROUP BY dispatchCode ");
            sb.Append("  order by dtEntry DESC ");
            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@FromCentreID", UserInfo.Centre)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string AddBatchToBatch(string BatchToAdd, string BatchNo, string TransferredTo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        //---Check whether Batch numbers are existing or not--------
        try
        {
            string sql = "SELECT COUNT(1) FROM sample_logistic WHERE `DispatchCode`=@DispatchCode AND `Status`= 'Received at Hub' AND ToCentreID=@ToCentreID";
            int cnt = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sql,
                new MySqlParameter("@DispatchCode", BatchToAdd), new MySqlParameter("@ToCentreID", UserInfo.Centre)));

            if (cnt == 0)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Batch Not belongs to Centre" });
            }
            else
            {
                sql = "SELECT COUNT(1) FROM sample_logistic WHERE `DispatchCode`=@DispatchCode AND `Status`!= 'Received at Hub' AND ToCentreID=@ToCentreID";
                cnt = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sql,
                    new MySqlParameter("@DispatchCode", BatchToAdd), new MySqlParameter("@ToCentreID", UserInfo.Centre)));
                if (cnt > 0)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Barcode has been processed. You can't add this batch" });
                }
            }
            //------------Update Existing Batch codes to Old BatchCode and insert new Batch Code
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE Sample_logistic SET OldDispatchCode=DispatchCode,DispatchCode=@BatchNo,Status='Pending for Dispatch', ");
            sb.Append(" FromCentreId=@FromCentreId,ToCentreId=@ToCentreId WHERE DispatchCode=@DispatchCode ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@FromCentreId", UserInfo.Centre), new MySqlParameter("@ToCentreId", TransferredTo),
                new MySqlParameter("@DispatchCode", BatchToAdd), new MySqlParameter("@BatchNo", BatchNo));

            sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode) ");
            sb.Append(" SELECT ");
           // sb.Append(" (SELECT LedgertransactionNo FROM patient_labinvestigation_opd plo WHERE plo.BarcodeNo=sl.BarcodeNo  LIMIT 1)LedgertransactionNo, ");
     sb.Append("     '' LedgertransactionNo, ");          
		  sb.Append(" BarcodeNo,0,CONCAT('Batch no. ',OldDispatchCode,' merged to Batch no. ',DispatchCode),@UserID,@UserName,@IpAddress, ");
            sb.Append(" @CentreID,@RoleID,NOW(),DispatchCode  FROM sample_logistic sl  WHERE OldDispatchCode=@OldDispatchCode ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                  new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre),
                  new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@OldDispatchCode", BatchToAdd));
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Success" });
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
    public static string GetRecord(string BatchNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT @BatchNo BatchNo,pli.SampleQty sampleqty, pli.`BarcodeNo`,pli.Barcode_Group,pm.`PName`,pm.`Age`,pm.`Gender`,pli.`SampleTypeID`,pli.`SampleTypeName` ");
            sb.Append(" ,GROUP_CONCAT(DISTINCT CAST( pli.`SampleTypeID` AS CHAR))ColorValue, GROUP_CONCAT(CAST(pli.test_id AS CHAR)) testid");
            sb.Append("  ,GROUP_CONCAT(CAST(im.`Investigation_Id` AS CHAR))Investigation_Id,GROUP_CONCAT(CAST(im.`Name` AS CHAR)) AS Test,pli.LedgertransactionNo   ");
            sb.Append("  FROM `patient_labinvestigation_opd` pli   ");
            sb.Append("  INNER JOIN `investigation_master` im ON im.`Investigation_Id`=pli.`Investigation_ID` and pli.IsSampleCollected='S'   ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`Patient_ID`=pli.`Patient_ID` WHERE pli.`BarcodeNo` IN (SELECT barcodeNo FROM  sample_logistic  WHERE DispatchCode=@DispatchCode) ");
            sb.Append("  AND pli.IsReporting='1' GROUP BY pli.`BarcodeNo`  ");
            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@BatchNo", BatchNo), new MySqlParameter("@DispatchCode", BatchNo)).Tables[0]);

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }


    [WebMethod(EnableSession = true)]
    public static string OpenPopup(string BatchToAdd, string BatchNo, string TransferredTo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        //---Check whether Batch numbers are existing or not--------
        try
        {
            string sql = "SELECT COUNT(1) FROM sample_logistic WHERE `DispatchCode`=@DispatchCode AND `Status`= 'Received at Hub' AND ToCentreID=@ToCentreID;";
            int cnt = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sql,
               new MySqlParameter("@DispatchCode", BatchToAdd), new MySqlParameter("@ToCentreID", UserInfo.Centre)));

            if (cnt == 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Batch Not belongs to Centre" });
            }
            else
            {
                sql = "SELECT COUNT(1) FROM sample_logistic WHERE `DispatchCode`=@DispatchCode AND `Status`!= 'Received at Hub' AND ToCentreID=@ToCentreID;";
                cnt = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sql,
                   new MySqlParameter("@DispatchCode", BatchToAdd), new MySqlParameter("@ToCentreID", UserInfo.Centre)));
                if (cnt > 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Barcode has been processed. You can't add this batch" });
                }
            }
            string GetNewBatchNo = string.Empty;
            GetNewBatchNo = BatchNo;
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT @BatchNo BatchNo, plo.BarcodeNo,plo.`InvestigationName`,cm1.`Centre` FromCentre,cm2.`Centre` ToCentre FROM Sample_Logistic sl ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`BarcodeNo`=sl.`BarcodeNo` ");
            sb.Append(" INNER JOIN centre_master cm1 ON cm1.`CentreID`=sl.`FromCentreID` ");
            sb.Append(" INNER JOIN Centre_Master cm2 ON cm2.`CentreID`=sl.`ToCentreID` ");
            sb.Append(" WHERE sl.`DispatchCode`=@DispatchCode  ");
            return JsonConvert.SerializeObject(new
            {
                status = true,
                response = Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@DispatchCode", BatchToAdd), new MySqlParameter("@BatchNo", GetNewBatchNo)).Tables[0])
            });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }
    [WebMethod]
    public static string bindpendinglist(string FromDate, string TODate)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            FromDate = FromDate == "" ? DateTime.Now.ToString() : FromDate;
            TODate = TODate == "" ? DateTime.Now.ToString() : TODate;

            string LabCategory = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Category FROM centre_master WHERE centreID= @ToCentreID",
                new MySqlParameter("@ToCentreID", UserInfo.Centre)));
            if (LabCategory.ToUpper() == "LAB")
            {
                sb.Append(" SELECT lt.CentreID,barcodeno,GROUP_CONCAT(CAST(ItemName AS CHAR)) TestName,pname ,DATE_FORMAT(plo.`Date`,'%d-%b-%Y %h:%i %p')RegDate FROM patient_labinvestigation_opd plo");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` and  plo.`IsSampleCollected`='S' and plo.IsActive=1 ");
                sb.Append(" INNER JOIN ( SELECT sl.Testid FROM ");
                sb.Append(" sample_logistic sl  ");
                sb.Append(" WHERE  sl.Status ='Transferred' AND sl.ToCentreID = @ToCentreID AND sl.IsActive=1 ) a ON a.TestID=plo.Test_ID ");
                sb.Append(" AND plo.`SampleCollectionDate`>=@FromDate  AND plo.`SampleCollectionDate`<= @ToDate ");
                sb.Append(" GROUP BY plo.`BarcodeNo`");
//System.IO.File.WriteAllText (@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\cap.txt", sb.ToString());
                return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@ToCentreID", UserInfo.Centre),
                     new MySqlParameter("@FromDate", Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00"),
                new MySqlParameter("@ToDate", Util.GetDateTime(TODate).ToString("yyyy-MM-dd") + " 23:59:59")).Tables[0]);
            }
            else
            {
                sb.Append(" SELECT lt.CentreID,plo.barcodeno,GROUP_CONCAT(CAST(ItemName AS CHAR)) TestName,pname ,DATE_FORMAT(plo.`Date`,'%d-%b-%Y %h:%i %p')RegDate FROM patient_labinvestigation_opd plo");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` and  plo.`IsSampleCollected`='S' AND plo.IsActive=1 ");
                sb.Append(" LEFT JOIN  ");
                sb.Append(" sample_logistic sl on sl.Testid=plo.test_id and sl.IsActive=1 ");
                sb.Append(" WHERE sl.Status ='Transferred' and plo.CentreID = @CentreIDSession and sl.Testid is not null   ");
                sb.Append(" AND plo.`SampleCollectionDate`>=@FromDate  AND plo.`SampleCollectionDate`<=@ToDate ");
                sb.Append(" GROUP BY plo.`BarcodeNo`");
				//System.IO.File.WriteAllText (@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\cap.txt", sb.ToString());
                return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@CentreIDSession", UserInfo.Centre),
                   new MySqlParameter("@FromDate", Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00"),
                new MySqlParameter("@ToDate", Util.GetDateTime(TODate).ToString("yyyy-MM-dd") + " 23:59:59")).Tables[0]);
            }
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
}
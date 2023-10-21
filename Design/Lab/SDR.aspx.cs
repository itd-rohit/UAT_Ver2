using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;

public partial class Design_Lab_SDR : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string SampleSearch(List<SampleSearch> data)
    {


        StringBuilder sb = new StringBuilder();

        DataTable dt = new DataTable();
        DataTable dtOutsource = new DataTable();

        DataSet ds = new DataSet();


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            List<string> Test_ID = new List<string>();
            foreach (DataRow dr in dtOutsource.Rows)
                Test_ID.Add(dr["Test_ID"].ToString());

            

            sb.Append("   SELECT  pli.`IsUrgent`,sl.id,IF(sl.Barcode_Group=pli.`BarcodeNo`,'',pli.`BarcodeNo`) BarcodeNo,sl.Barcode_Group,pm.`PName`,sl.DispatchCode, ");
            sb.Append("   pm.`Age`,pm.`Gender`,pli.`SampleTypeID`,pli.`SampleTypeName`    ");
            sb.Append("   ,DATE_FORMAT(dtSent,'%d-%b-%y %h:%i %p') dtSent,DATE_FORMAT(dtLogisticReceive,'%d-%b-%y %h:%i %p') dtLogisticReceive,GROUP_CONCAT(DISTINCT CAST(pli.Test_ID AS CHAR))Test_ID   ");
            sb.Append("   ,GROUP_CONCAT(CAST(pli.`Investigation_Id` AS CHAR))Investigation_Id,GROUP_CONCAT(CAST(pli.`ItemName` AS CHAR)) AS Test,GROUP_CONCAT(DISTINCT CAST(scm.`Abbreviation` AS CHAR))Department  ");
            sb.Append("   ,tcm.`Test_Centre`,cm.`Centre` ,'Other Centre'  `Type`,pli.LedgerTransactionNo,pli.`SubCategoryID`   ");
            sb.Append("   FROM `patient_labinvestigation_opd` pli     ");
            sb.Append("   INNER JOIN sample_logistic sl ON sl.BarcodeNo=pli.`BarcodeNo` AND sl.`Barcode_Group`=@BarcodeNo AND pli.IsReporting='1' and pli.IsSampleCollected<>'R' AND pli.`LedgerTransactionNo`<>'' ");
            sb.Append("   AND sl.ToCentreID=@CentreID AND sl.Status ='SDR' AND sl.IsActive=1   ");
            sb.Append("   INNER JOIN `test_centre_mapping` tcm ON tcm.`Booking_Centre`=@CentreID  ");
            sb.Append("   AND tcm.`Investigation_ID`=pli.`Investigation_ID` AND  tcm.`Booking_Centre`<>tcm.`Test_Centre`   ");
            sb.Append("   INNER JOIN centre_master cm ON cm.`CentreID`=tcm.`Test_Centre`   ");
            sb.Append("   INNER JOIN `f_subcategorymaster` scm ON scm.`SubCategoryID`=pli.`SubCategoryID`      ");
            sb.Append("   INNER JOIN patient_master pm ON pm.`Patient_ID`=pli.`Patient_ID`  ");
            sb.Append("   GROUP BY tcm.`Test_Centre`  ");

            sb.Append("   UNION ALL  ");


            sb.Append("   SELECT  pli.`IsUrgent`,sl.id,IF(sl.Barcode_Group=pli.`BarcodeNo`,'',pli.`BarcodeNo`) BarcodeNo,sl.Barcode_Group,pm.`PName`,sl.DispatchCode,    ");
            sb.Append("   pm.`Age`,pm.`Gender`,pli.`SampleTypeID`,pli.`SampleTypeName`");
            sb.Append("  ,DATE_FORMAT(dtSent,'%d-%b-%y %h:%i %p') dtSent,DATE_FORMAT(dtLogisticReceive,'%d-%b-%y %h:%i %p') dtLogisticReceive,GROUP_CONCAT(DISTINCT CAST(pli.Test_ID AS CHAR))Test_ID   ");
            sb.Append("   ,GROUP_CONCAT(CAST(pli.`Investigation_Id` AS CHAR))Investigation_Id,GROUP_CONCAT(CAST(pli.`ItemName` AS CHAR)) AS Test,GROUP_CONCAT(DISTINCT CAST(scm.`Abbreviation` AS CHAR))Department  ");
            sb.Append("   ,iol.OutSrcLabID `Test_Centre`,cm.name ,'Outsource'  `Type`,pli.LedgerTransactionNo,pli.`SubCategoryID`   ");
            sb.Append("   FROM `patient_labinvestigation_opd` pli    ");
            sb.Append("   INNER JOIN sample_logistic sl ON sl.BarcodeNo=pli.`BarcodeNo`  ");
            sb.Append("   AND sl.`Barcode_Group`=@BarcodeNo AND pli.IsReporting='1'  ");
            sb.Append("   AND sl.ToCentreID=@CentreID AND sl.Status ='SDR' AND sl.IsActive=1  and pli.IsSampleCollected<>'R'  AND pli.`LedgerTransactionNo`<>'' ");
            sb.Append("   INNER JOIN `investigations_outsrclab` iol ON iol.`Investigation_ID`=pli.`Investigation_ID` AND   ");
            sb.Append("   iol.CentreID=@CentreID   ");
            sb.Append("   INNER JOIN `outsourcelabmaster` cm ON cm.id=iol.OutSrcLabID    ");
            sb.Append("   INNER JOIN `f_subcategorymaster` scm ON scm.`SubCategoryID`=pli.`SubCategoryID`      ");
            sb.Append("   INNER JOIN patient_master pm ON pm.`Patient_ID`=pli.`Patient_ID`   ");
            sb.Append("   GROUP BY iol.OutSrcLabID; ");

            dtOutsource = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@BarcodeNo", data[0].BarcodeNo)).Tables[0];


            sb = new StringBuilder();
            sb.Append("  SELECT  pli.`IsUrgent`,sl.id,if(sl.Barcode_Group=pli.`BarcodeNo`,'',pli.`BarcodeNo`) BarcodeNo,sl.Barcode_Group,pm.`PName`,sl.DispatchCode,pm.`Age`,pm.`Gender`,pli.`SampleTypeID`,pli.`SampleTypeName`    ");
            sb.Append("  ,DATE_FORMAT(dtSent,'%d-%b-%y %h:%i %p') dtSent,DATE_FORMAT(dtLogisticReceive,'%d-%b-%y %h:%i %p') dtLogisticReceive,group_concat(distinct CAST(pli.Test_ID AS CHAR))Test_ID   ");
            sb.Append("  ,GROUP_CONCAT(CAST(pli.`Investigation_Id` AS CHAR))Investigation_Id,GROUP_CONCAT(CAST(pli.ItemName AS CHAR)) AS Test,GROUP_CONCAT(DISTINCT CAST(scm.`Abbreviation` AS CHAR))Department  ");
            sb.Append("  ,@CentreID `Test_Centre`,'Inhouse' Centre ,'Inhouse'  `Type`,pli.LedgerTransactionNo ,pli.`SubCategoryID`  ");
            sb.Append("  FROM `patient_labinvestigation_opd` pli     ");
            sb.Append("  INNER JOIN sample_logistic sl ON sl.BarcodeNo=pli.`BarcodeNo`  ");
            sb.Append("  and sl.`Barcode_Group`=@BarcodeNo AND pli.IsReporting='1' and pli.IsSampleCollected<>'R'   ");


            foreach (DataRow dr in dtOutsource.Rows)
                sb.Append(" AND pli.`Test_ID` not in ({0}) ");



            sb.Append("  AND sl.ToCentreID=@CentreID AND sl.Status ='SDR' AND sl.IsActive=1   ");
            sb.Append("  INNER JOIN `f_subcategorymaster` scm ON scm.`SubCategoryID`=pli.`SubCategoryID`      ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`Patient_ID`=pli.`Patient_ID`   ");
            sb.Append("  GROUP BY pli.`BarcodeNo`,pli.`SubCategoryID`  ");
            using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", Test_ID)), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@CentreID", UserInfo.Centre);
                da.SelectCommand.Parameters.AddWithValue("@BarcodeNo", data[0].BarcodeNo);
                for (int i = 0; i < Test_ID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@Test_IDParam", i), Test_ID[i]);
                }
                da.Fill(dt);
                sb = new StringBuilder();
                
            }
            
            if (dt.Rows.Count > 0)
            {
                dt.Merge(dtOutsource);
                foreach (DataRow dr in dt.Rows)
                {
                    if (dt.Select(string.Format("BarcodeNo='{0}' and Barcode_Group='{1}'", dr["BarcodeNo"], dr["Barcode_Group"])).Length > 1)
                    {
                        dr["Centre"] = string.Format("{0}-{1}", dr["Centre"], dr["Department"]);
                    }
                    else if (dr["BarcodeNo"].ToString() != dr["Barcode_Group"].ToString())
                    {
                        dr["Centre"] = string.Format("{0}-{1}", dr["Centre"], dr["Department"]);
                    }
                }
            }
            DataColumn newColumn = new DataColumn("Segregation", typeof(String)) { DefaultValue = dt.Select("BarcodeNo=''").Length };
            dt.Columns.Add(newColumn);
            tnx.Commit();
            Test_ID.Clear();
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
        return Util.getJson(dt);
    }
    [WebMethod]
    public static string generateBarcode(List<SampleSearch> data)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        DataSet ds = new DataSet();
        List<string> Test_ID = data[0].Test_ID.Split(',').ToList();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            sb.Append("select get_Barcode(@SubCategoryID);");

            string NewBarcode = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@SubCategoryID", data[0].SubCategoryID)).ToString();
            sb = new StringBuilder();
            sb.Append("update patient_labinvestigation_opd set BarcodeNo=@NewBarcode where Test_ID IN ({0}) and IsSampleCollected<>'R' ;");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@NewBarcode", NewBarcode));
            using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), string.Join(",", Test_ID)), con))
            {
                for (int i = 0; i < Test_ID.Count; i++)
                {
                    cmd.Parameters.AddWithValue(string.Concat("@Test_IDParam", i), Test_ID[i]);
                }
                cmd.ExecuteNonQuery();
            }
            sb = new StringBuilder();
            sb.Append("update mac_data set labNo=@NewBarcode where Test_ID IN ({0})");           
            using (MySqlCommand cmd1 = new MySqlCommand(string.Format(sb.ToString(), string.Join(",", Test_ID)), con))
            {
                cmd1.Parameters.AddWithValue("@NewBarcode", NewBarcode);
                for (int i = 0; i < Test_ID.Count; i++)
                {
                    cmd1.Parameters.AddWithValue(string.Concat("@Test_IDParam", i), Test_ID[i]);
                }
                cmd1.ExecuteNonQuery();
            }
            sb = new StringBuilder();
            sb.Append(" INSERT INTO sample_logistic(BarcodeNo,Barcode_Group,FromCentreID,ToCentreID,DispatchCode,Qty,dtEntry,EntryBy,PickUpFieldBoyID,PickUpFieldBoy,CourierDetail,CourierDocketNo,STATUS,IsActive,UpdatedBy,updatedDate,dtSent,dtLogisticReceive,testid) ");
            sb.Append(" SELECT @NewBarcode BarcodeNo,BarcodeNo, FromCentreID,ToCentreID,'' DispatchCode,Qty,NOW() dtEntry,@UserID EntryBy,'0'PickUpFieldBoyID,''PickUpFieldBoy,''CourierDetail,''CourierDocketNo,STATUS,IsActive,@UserID UpdatedBy,NOW()updatedDate,'0001-01-01 00:00:00'dtSent,'0001-01-01 00:00:00'dtLogisticReceive,@Test_ID testid ");
            sb.Append(" FROM sample_logistic WHERE barcodeNo=@BarcodeNo AND `Status`='SDR' AND IsActive=1 LIMIT 1 ");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@NewBarcode", NewBarcode), new MySqlParameter("@BarcodeNo", data[0].BarcodeNo),
                new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@Test_ID", data[0].Test_ID));
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
        return "";
    }
    [WebMethod]
    public static string markComplete(List<SampleSearch> data)
    {
        StringBuilder sb = new StringBuilder();
        string _SampleStatus = string.Empty;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (SampleSearch ss in data)
            {
                string _BarcodeNo = ss.BarcodeNo;
                if (_BarcodeNo == string.Empty)
                    _BarcodeNo = ss.Barcode_Group;
                int udatedrecord = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE mac_data  SET centreid=@centreID,STATUS='Receive' where labno=@BarcodeNo; ",
                new MySqlParameter("@centreID", UserInfo.Centre), new MySqlParameter("@BarcodeNo", _BarcodeNo));
                sb = new StringBuilder();
                if (ss.Type == "Other Centre")
                {
                    sb.Append("update sample_logistic set Status='SDR Transfered',ReceivedDate=now(),ReceivedBy=@ReceivedBy  where BarcodeNo =@Barcode and Status!='SDR Transfered' and ToCentreID=@CentreID;");
                    sb.Append("update patient_labinvestigation_opd set TestCentreID=@CentreID where BarcodeNo =@Barcode;");
                    _SampleStatus = "SDR Received, Ready for Transfer (Batch)";
                }
                else if (ss.Type == "Outsource")
                {
                    sb.Append("update sample_logistic set Status='SDR OUTSOURCE',ReceivedDate=now(),ReceivedBy=@ReceivedBy  where BarcodeNo =@Barcode and Status!='SDR OUTSOURCE' and ToCentreID=@CentreID;");
                    sb.Append("update patient_labinvestigation_opd set TestCentreID=@CentreID where BarcodeNo =@Barcode;");
                    _SampleStatus = "SDR Received, Ready for Outsource";
                }
                else
                {
                    sb.Append("update sample_logistic set Status='Received',ReceivedDate=now(),ReceivedBy=@ReceivedBy where BarcodeNo =@Barcode and Status!='Received' and ToCentreID=@CentreID;");
                    _SampleStatus = "SDR Received, Send to Department";
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@Barcode", _BarcodeNo), new MySqlParameter("@CentreID", UserInfo.Centre),
                            new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@ReceivedBy", UserInfo.ID));
                StringBuilder sb1 = new StringBuilder();
                sb1.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode) ");
                sb1.Append(" values(@LedgerTransactionNo,@BarcodeNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),'') ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString(),
                   new MySqlParameter("@LedgerTransactionNo", data[0].LedgerTransactionNo), new MySqlParameter("@BarcodeNo", _BarcodeNo),
                   new MySqlParameter("@Test_ID", ss.Test_ID), new MySqlParameter("@Status", _SampleStatus), new MySqlParameter("@UserID", UserInfo.ID),
                   new MySqlParameter("@UserName", UserInfo.LoginName), new MySqlParameter("@IpAddress", StockReports.getip()),
                   new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID));

            }
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
        return "";
    }
}
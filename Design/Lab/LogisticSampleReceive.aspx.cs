using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Lab_LogisticSampleReceive : System.Web.UI.Page
{
    public string IsSampleLogisticReject = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindAllCentre(ddlCentre);
            ddlCentre.Items.Insert(0, new ListItem("-- Select Centre --", ""));

            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);

            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                IsSampleLogisticReject = MySqlHelper.ExecuteScalar(con, CommandType.Text,
                                         " SELECT IsSampleLogisticReject from employee_master where Employee_ID=@Employee_ID ",
                                         new MySqlParameter("@Employee_ID", UserInfo.ID)).ToString();
                StringBuilder sb = new StringBuilder();
                sb.Append("  SELECT fm.Name ,fm.FeildboyID id FROM feildboy_master fm ");
                sb.Append("  INNER JOIN `fieldboy_zonedetail` fmz ON fmz.`FieldBoyID`=fm.`FeildboyID` ");
                sb.Append("  AND fmz.`ZoneID` = ( SELECT `BusinessZoneID` FROM  `centre_master` cm WHERE cm.`CentreID`=@CentreID) ");
                sb.Append("  WHERE fm.isactive=1 ORDER BY NAME ");
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0])
                {
                    ddlFieldBoy.DataSource = dt;


                    ddlFieldBoy.DataTextField = "Name";
                    ddlFieldBoy.DataValueField = "id";
                    ddlFieldBoy.DataBind();
                    ddlFieldBoy.Items.Insert(0, new ListItem("-- Select Field Boy --", ""));
                }
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
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateBatchStatus(List<SampleSearch> data)
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(7);
        int ReqCount = MT.GetIPCount(7);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return "Too Many Request,Try Again after some";
        }

        if (data[0].Status == "Received at Hub" || data[0].Status == "Reject at Hub")
        {

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("update sample_logistic set Status=@Status, ");

                if (data[0].Status == "Received at Hub")
                {
                    sb.Append(" dtLogisticReceive=now(),LogisticReceiveDate=now(),LogisticReceiveBy=@LogisticReceiveBy ");
                }
                if (data[0].Status == "Reject at Hub")
                {
                    sb.Append(" LogisticRejectDate=now(),LogisticRejectByID=@LogisticReceiveBy ");
                }

                sb.Append("where dispatchCode=@dispatchCode ");
            //    System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\02-Jun-2021\log.txt", sb.ToString());
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@Status", data[0].Status),
                 new MySqlParameter("@dispatchCode", data[0].BatchNo), new MySqlParameter("@LogisticReceiveBy", UserInfo.ID));

                sb = new StringBuilder();
                sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode) ");
                sb.Append(" SELECT ");
              //  sb.Append("      (SELECT LedgertransactionNo FROM patient_labinvestigation_opd plo WHERE plo.BarcodeNo=sl.BarcodeNo  LIMIT 1)LedgertransactionNo, ");
			    sb.Append("    '' LedgertransactionNo, ");
                sb.Append("      sl.BarCodeNo,0,CONCAT('SIN No. ',sl.BarcodeNo ,' " + data[0].Status + " Batch No. ',sl.DispatchCode),@UserID,@UserName,@IpAddress, ");
                sb.Append("      @CentreID,@RoleID,NOW(),DispatchCode  FROM sample_logistic sl  WHERE sl.dispatchCode=@dispatchCode");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName), new MySqlParameter("@IpAddress", StockReports.getip()),
                   new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@dispatchCode", data[0].BatchNo));

           //     MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET IsSRA=0 WHERE Test_ID IN (select TestID  FROM sample_logistic sl  WHERE sl.dispatchCode=@dispatchCode)",
             //              new MySqlParameter("@dispatchCode", data[0].BatchNo));
                tnx.Commit();
                return JsonConvert.SerializeObject(new { status = true, response = "Success" });

            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objerror = new ClassLog();
                objerror.errLog(ex);
                return JsonConvert.SerializeObject(new { status = false, response = ex.Message });
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = true, response = "Success" });
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
            sb.Append("  SELECT cm.Centre TransferFromCentre, sl.dispatchcode,COUNT(DISTINCT sl.BarcodeNo) Quantity,`PickUpFieldBoyID`,`PickUpFieldBoy`,sl.CourierDetail,sl.CourierDocketNo,`Status`,date_format(sl.dtSent,'%d-%M-%y %h:%i %p') SendDate,sl.BarCodeNo ");
            sb.Append(" ,CASE WHEN sl.STATUS='Reject at Hub' THEN 'bisqueRow' WHEN sl.STATUS='Received' THEN 'NoColor' ELSE CASE WHEN DATE(sl.TransferredDate)< DATE(NOW()) THEN 'OrangeRow' WHEN DATE(sl.dtEntry)<>DATE(sl.TransferredDate) THEN 'PinkRow'   ELSE '' END END AS RowColor ");
            sb.Append(" FROM sample_logistic sl");
            sb.Append(" INNER JOIN Centre_Master cm ON cm.CentreId=sl.FromCentreId ");
            sb.Append(" WHERE sl.ToCentreID=@ToCentreID ");
            if (Util.GetString(data[0].FromCentreID) != "0")
                sb.Append(" AND sl.FromCentreID=@FromCentreID ");

            if (Util.GetString(data[0].BatchNo) != string.Empty)
                sb.Append(" AND sl.dispatchCode=@BatchNo ");
            if (data[0].FromDate != string.Empty && data[0].ToDate != string.Empty)
                sb.Append(" AND DATE(sl.dtSent)>=@FromDate AND DATE(sl.dtSent)<=@ToDate ");

            sb.Append("  AND sl.IsActive=1 GROUP BY sl.dispatchCode ORDER BY sl.STATUS='Transfer' ");
            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@ToCentreID", UserInfo.Centre), new MySqlParameter("@FromCentreID", Util.GetString(data[0].FromCentreID)),
               new MySqlParameter("@BatchNo", Util.GetString(data[0].BatchNo)),
               new MySqlParameter("@FromDate", Util.GetDateTime(data[0].FromDate).ToString("yyyy-MM-dd")),
               new MySqlParameter("@ToDate", Util.GetDateTime(data[0].ToDate).ToString("yyyy-MM-dd"))).Tables[0]);

        }
        catch (Exception ex)
        {
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string viewSampleData(string dispatchCode)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT sl.ID sampleLogisticID,sl.`dispatchCode`,pli.`BarcodeNo`,pm.`PName`,pm.`Age`,pm.`Gender`,pli.`SampleTypeID`,pli.`SampleTypeName`  ");
            sb.Append("  ,CAST(GROUP_CONCAT(Distinct im.`Name`)as CHAR)Test,sl.Status   ");
            sb.Append("  FROM `patient_labinvestigation_opd` pli   ");
            sb.Append("  INNER JOIN `investigation_master` im ON im.`Investigation_Id`=pli.`Investigation_ID` and pli.IsSampleCollected<>'R'   ");
            sb.Append("  INNER JOIN `investigations_sampletype` ist ON ist.`Investigation_ID`=pli.`Investigation_ID` AND ist.`IsDefault`=1  ");
            sb.Append("  INNER JOIN sample_logistic sl ON sl.BarCodeNo=pli.BarCodeNo ");
            sb.Append("   ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`Patient_ID`=pli.`Patient_ID` WHERE sl.`dispatchCode`=@dispatchCode AND sl.IsActive=1 AND pli.IsReporting='1' GROUP BY pli.`BarcodeNo`  ");

            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@dispatchCode", dispatchCode)).Tables[0]);

        }
        catch (Exception ex)
        {
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
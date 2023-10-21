using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;


public partial class Design_Lab_OutSourceTestToOtherLab : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            BindDepartment();

            BindOutsourceLab();
            ce_dtfrom.EndDate = DateTime.Now;
            ce_dtTo.EndDate = DateTime.Now;
        }
    }

    private void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='LSHHI3'   ");
        if (Util.GetString(HttpContext.Current.Session["AccessDepartment"]) != "")
        {
            sb.AppendFormat("  and  SubCategoryID in ('{0}') ", Util.GetString(HttpContext.Current.Session["AccessDepartment"]).Replace(",", "','"));
        }
        sb.Append(" ORDER BY NAME");
        ddlDepartment.DataSource = StockReports.GetDataTable(sb.ToString());
        ddlDepartment.DataTextField = "NAME";
        ddlDepartment.DataValueField = "SubCategoryID";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, new ListItem("All Department", ""));
    }
    private void BindOutsourceLab()
    {

        ddloutsourcelab.DataSource = StockReports.GetDataTable("SELECT id,NAME FROM `outsourcelabmaster` WHERE Active=1 ORDER BY NAME");
        ddloutsourcelab.DataTextField = "NAME";
        ddloutsourcelab.DataValueField = "ID";
        ddloutsourcelab.DataBind();
        ddloutsourcelab.Items.Insert(0, new ListItem("All OutSourceLab", "All"));
    }

    [WebMethod(EnableSession = true)]
    public static string binddata(string FromDate, string ToDate, string CentreID, string Department, string TimeFrm, string TimeTo, string OutsourceLabid, string BarcodeNo)
    {

        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return "-1";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT (SELECT centre FROM centre_master WHERE centreid=sl.`ToCentreID`) centre,lt.LedgerTransactionNo, ");
            sb.Append(" plo.`Test_ID`,plo.SubCategoryName dept,plo.`itemname`,plo.`Investigation_ID`,sl.`BarcodeNo`,CONCAT(lt.`PName`,'/', lt.`Age`,'/',lt.`Gender`) PName,CONCAT( lt.`Age`,'/',lt.`Gender`)Age, ");
            sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0',io.`OutSrcLabID`,plo.LabOutsrcID) LabOutsrcID, ");
            sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0',io.`OutSrcLabname`,plo.LabOutsrcName) LabOutsrcName, ");
            sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0',io.`OutsourceRate`,plo.LabOutSrcRate) LabOutSrcRate, ifnull(concat(io.`TAT`,' ',TATType),'') TAT,if(IsFileRequired=0,'No','Yes') IsFileRequired,");
            sb.Append(" IF(IFNULL(plo.LabOutsrcID,'0')='0','Pending','OutSourced') `Status`,plo.LabOutSrcBy, ");
            sb.Append(" DATE_FORMAT(plo.LabOutSrcDate,'%d-%b-%y %h:%i%p') LabOutSrcDate,DATE_FORMAT(plo.Date,'%d-%b-%y %h:%i%p') RegDate ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo  ");
           
           
            sb.Append(" INNER JOIN `sample_logistic` sl ON plo.`BarcodeNo`=sl.`BarcodeNo` AND sl.`testid` = plo.`Test_ID` AND sl.`Status`='OutSource' ");

            if (Department != string.Empty)
            {
                sb.Append("  AND plo.SubCategoryID=@Department ");
            }
            if (CentreID != "0")
            {
                sb.Append("  and sl.ToCentreID=@CentreID ");
            }
            else
            {
                sb.Append(" and ( sl.ToCentreID in ( select ca.CentreAccess from   centre_access ca where  ca.Centreid=@ToCentreID )   or sl.ToCentreID =@ToCentreID) ");
            }
            sb.Append(" INNER JOIN `investigations_outsrclab` io ON io.`CentreID`=sl.`ToCentreID` AND io.`Investigation_ID`=plo.`Investigation_ID` ");
            if (OutsourceLabid != "All")
            {
                sb.Append(" and io.outsrclabid=@outsrclabid");
            }
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` AND plo.IsActive=1 ");
            sb.Append("  where sl.ReceivedDate >= @fromDate AND sl.ReceivedDate <= @todate ");
            if (BarcodeNo != string.Empty)
            {
                sb.Append(" AND plo.BarcodeNo=@BarcodeNo ");
            }
            sb.Append(" order by sl.ReceivedDate");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Department", Department),
                new MySqlParameter("@CentreID", CentreID),
                new MySqlParameter("@ToCentreID", UserInfo.Centre),
                new MySqlParameter("@outsrclabid", OutsourceLabid),
                new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"), " ", TimeFrm)),
                new MySqlParameter("@todate", string.Concat(Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"), " ", TimeTo)),
                new MySqlParameter("@BarcodeNo", BarcodeNo)).Tables[0])
                return JsonConvert.SerializeObject(dt);
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
    public static string bindoutsrclab()
    {
        return JsonConvert.SerializeObject(AllLoad_Data.loadOutSourceLab());
    }


    [WebMethod(EnableSession = true)]
    public static string savedata(List<string> data)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            StringBuilder sb = new StringBuilder();
            foreach (string s in data)
            {
                var barcode = s.Split('#')[4];
                string oldbarcode = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT barcodeno FROM patient_labinvestigation_opd WHERE Test_ID=@Test_ID",
                    new MySqlParameter("@Test_ID", s.Split('#')[0])));
                if (oldbarcode != barcode)
                {
                    int newbarcode = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT count(*) FROM patient_labinvestigation_opd WHERE barcodeno=@barcodeno",
                        new MySqlParameter("@barcodeno", barcode)));
                    if (newbarcode > 0)
                    {
                        tnx.Rollback();
                        return string.Concat("Barcode already exist for this Barcode :", oldbarcode);
                    }
                }

                sb = new StringBuilder();
                sb.Append("update patient_labinvestigation_opd set BarcodeNo=@BarcodeNo,LabOutsrcID=@LabOutsrcID,LabOutsrcName=@LabOutsrcName,LabOutSrcUserID=@LabOutSrcUserID,LabOutSrcBy=@LabOutSrcBy,LabOutSrcRate=@LabOutSrcRate,LabOutSrcDate=NOW(),TestCentreID=@TestCentreID,IsSampleCollected='Y',SampleReceiver=@SampleReceiver,SampleReceivedBy=@SampleReceivedBy,sampleCollectionDate=NOW(),SampleReceiveDate=NOW() where Test_ID=@Test_ID ;");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@BarcodeNo", s.Split('#')[4]),
                    new MySqlParameter("@LabOutsrcID", s.Split('#')[1]),
                    new MySqlParameter("@LabOutsrcName", s.Split('#')[2]),
                    new MySqlParameter("@LabOutSrcUserID", UserInfo.ID),
                    new MySqlParameter("@LabOutSrcBy", UserInfo.LoginName),
                    new MySqlParameter("@LabOutSrcRate", s.Split('#')[3]),
                    new MySqlParameter("@TestCentreID", UserInfo.Centre),
                    new MySqlParameter("@SampleReceiver", UserInfo.LoginName),
                    new MySqlParameter("@SampleReceivedBy", UserInfo.ID),
                    new MySqlParameter("@Test_ID", s.Split('#')[0]));

                sb = new StringBuilder();
                sb.Append("UPDATE sample_logistic SET BarcodeNo=@BarcodeNo WHERE testid=@testid ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),                                      
                    new MySqlParameter("@BarcodeNo", s.Split('#')[4]),
                    new MySqlParameter("@Test_ID", s.Split('#')[0]));

                sb = new StringBuilder();
                sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,LedgerTransactionID,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                sb.Append(" SELECT LedgerTransactionNo,LedgerTransactionID,@BarcodeNo,Test_ID,CONCAT('Test OutSource (',ItemName,')'),@UserID,@UserName,@IpAddress,@CentreID, ");
                sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID =@Test_ID");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@BarcodeNo", s.Split('#')[4]),
                    new MySqlParameter("@UserID", UserInfo.ID),
                    new MySqlParameter("@UserName", UserInfo.LoginName),
                    new MySqlParameter("@IpAddress", StockReports.getip()),
                    new MySqlParameter("@CentreID", UserInfo.Centre),
                    new MySqlParameter("@RoleID", UserInfo.RoleID),
                    new MySqlParameter("@Test_ID", s.Split('#')[0]));
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            tnx.Rollback();
            return ex.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    public static string encryptData(string LedgerTransactionNo, string Test_ID)
    {
        return JsonConvert.SerializeObject(new { status = true, LedgerTransactionNo = Common.EncryptRijndael(LedgerTransactionNo), Test_ID = Common.EncryptRijndael(Test_ID), OutSrc = Common.EncryptRijndael("1") });
    }
}
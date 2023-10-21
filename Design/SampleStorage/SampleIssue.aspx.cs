using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_SampleStorage_SampleIssue : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtdatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtdateo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string searchIssue(string fromdate, string todate, string pname, string sinno, string visitno, string uhid)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append(" SELECT ss.slotnumber,ss.IssueTo,ss.IssueByUserName, date_format(ss.IssueDate,'%d-%b-%y')  IssueDate,ss.status, (case when ss.`Status`=1 then 'white' when ss.Status=2 then 'pink' when ss.Status=3 then 'lightgreen' end) RowColor, ss.id uniid, lt.`LedgerTransactionNo`,plo.`BarcodeNo` Sinno,  lt.`PName`,CONCAT(lt.`Age`,'/',LEFT(lt.`Gender`,1)) Pinfo, plo.`Patient_ID`, ");
            sb.Append(" (SELECT centre FROM centre_master WHERE centreid=lt.centreid) BookingCentre, ");
            sb.Append(" (SELECT centre FROM centre_master WHERE centreid=ss.centreid) StorageCentre,plo.`SampleTypeName`,  ");
            sb.Append(" sdm.`DeviceName`,ss.`RackID` RackNumber,ss.`TrayCode`  ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo   ");
            sb.Append(" INNER JOIN `ss_samplestorage` ss ON plo.`BarcodeNo`=ss.`BarcodeNo`  ");
            if (sinno != "")
                sb.Append(" and plo.barcodeno=@sinno ");

            if (visitno != "")
                sb.Append(" and plo.LedgerTransactionNo=@visitno ");

            if (uhid != "")
                sb.Append(" and plo.Patient_ID=@uhid ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");
            sb.Append(" INNER JOIN `ss_storagedevicemaster` sdm ON sdm.`ID`=ss.`DeviceID`  ");
            if (sinno == "" && visitno == "" && uhid == "")
                sb.Append(" and date(lt.date)>=@fromdate and date(lt.date)<=@todate ");
            if (pname != "")
                sb.Append("  and lt.pname like @pname ");
            sb.Append(" group by  ss.barcodeno ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@sinno", sinno),
               new MySqlParameter("@visitno", visitno),
               new MySqlParameter("@uhid", uhid),
               new MySqlParameter("@fromdate", Util.GetDateTime(fromdate).ToString("yyyy-MM-dd")),
               new MySqlParameter("@todate", Util.GetDateTime(todate).ToString("yyyy-MM-dd")),
               new MySqlParameter("@pname", string.Format("%{0}%", pname))
               ).Tables[0])
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);    
            }            
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveissue(string unid, string barcodeno, string issueto, string issuepurpose, string invoiceno)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("update ss_samplestorage set status=3,IssueTo=@issueto,IssuePurpose=@issuepurpose,IssueInvoiceNo=@invoiceno,IssueByUserName=@LoginName,IssueDate=now() where barcodeno=@barcodeno and id=@unid ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@issueto", issueto),
                new MySqlParameter("@issuepurpose", issuepurpose),
                new MySqlParameter("@invoiceno", invoiceno),
                new MySqlParameter("@LoginName", UserInfo.LoginName),
                new MySqlParameter("@barcodeno", barcodeno),
                new MySqlParameter("@unid", unid));
            sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Sample Issued (',ItemName,')'),@ID,@LoginName,@getip,@Centre, ");
            sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE  BarCodeNo =@barcodeno ");


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@ID", UserInfo.ID),
                new MySqlParameter("@LoginName", UserInfo.LoginName),
                new MySqlParameter("@getip", StockReports.getip()),
                new MySqlParameter("@Centre", UserInfo.Centre),
                new MySqlParameter("@RoleID", UserInfo.RoleID),
                new MySqlParameter("@barcodeno", barcodeno)
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
    
}
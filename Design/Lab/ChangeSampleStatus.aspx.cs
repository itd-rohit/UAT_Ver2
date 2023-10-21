using MySql.Data.MySqlClient;
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

public partial class Design_Lab_ChangeSampleStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Util.GetString(Request.QueryString["LabNo"]) != "")
        {
            txtLabNo.Text = Util.GetString(Request.QueryString["LabNo"]);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "GetData();", true);
        }
        else
        {
            txtLabNo.Focus();
        }

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetData(string LabNo)
    {
        try
        {
            int valCentreID = UserInfo.Centre;
        }
        catch
        {
            return "-1";
        }

        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT  lt.`PName`,CONCAT(lt.`Age`,'/ ',LEFT(lt.`Gender`,1)) AgeGender,lt.`LedgerTransactionNo`,plo.Test_ID, ");
            sb.Append(" lt.`LedgerTransactionNo`,inv.`Name` Investigation,plo.`BarcodeNo`,plo.`Result_Flag`,plo.`Approved`,plo.`IsSampleCollected`, ");
            sb.Append(" CASE WHEN plo.isPrint=1 THEN '#00FFFF' WHEN plo.Approved=1 THEN '#90EE90' WHEN plo.Result_Flag=1  THEN 'Pink' ");
            sb.Append(" WHEN plo.isSampleCollected='N' THEN  '#CC99FF'  WHEN plo.isSampleCollected='Y' THEN 'white'  ELSE 'white'  END rowcolor");
            sb.Append(" FROM `patient_labinvestigation_opd` plo ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN investigation_master inv ON inv.`Investigation_Id`=plo.`Investigation_ID` ");
            sb.Append(" WHERE lt.`LedgerTransactionNo`='" + Util.GetString(LabNo) + "' ORDER BY inv.`Name`; ");

            using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateRecord(string LabNo, string TestData)
    {
        try
        {
            int valCentreID = UserInfo.Centre;
        }
        catch
        {
            return "-1";
        }

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {
            TestData = TestData.TrimEnd('#');
            int len = Util.GetInt(TestData.Split('#').Length);
            string[] Item = new string[len];
            Item = TestData.Split('#');

            for (int i = 0; i < len; i++)
            {


                if (Util.GetString(Item[i].Split('|')[0]) == "0")
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE patient_labinvestigation_opd SET Result_Flag=0,ResultEnteredBy=0,ResultEnteredName='', ");
                    sb.Append(" UpdateID='" + UserInfo.ID + "',UpdateName='" + UserInfo.LoginName + "',UpdateRemarks='Result Remove', ");
                    sb.Append(" UpdateDate=NOW() WHERE Test_ID='" + Util.GetString(Item[i].Split('|')[1]) + "';");
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO  patient_labinvestigation_opd_update_status(LedgerTransactionNo,Test_ID,STATUS,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID,OLDID,NEWID)  ");
                    sb.Append(" values ('" + LabNo + "','" + Util.GetString(Item[i].Split('|')[1]) + "','Result Remove','" + UserInfo.ID + "','" + UserInfo.LoginName + "',NOW(),");
                    sb.Append(" '" + StockReports.getip() + "','" + UserInfo.Centre + "','" + UserInfo.RoleID + "','','');");
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
                }
                if (Util.GetString(Item[i].Split('|')[0]) == "1")
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE patient_labinvestigation_opd SET IsSampleCollected='N', ");
                    sb.Append(" UpdateID='" + UserInfo.ID + "',UpdateName='" + UserInfo.LoginName + "',UpdateRemarks='Sample Remove', ");
                    sb.Append(" UpdateDate=NOW() WHERE Test_ID='" + Util.GetString(Item[i].Split('|')[1]) + "';");
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO  patient_labinvestigation_opd_update_status(LedgerTransactionNo,Test_ID,STATUS,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID,OLDID,NEWID)  ");
                    sb.Append(" values ('" + LabNo + "','" + Util.GetString(Item[i].Split('|')[1]) + "','Sample Remove','" + UserInfo.ID + "','" + UserInfo.LoginName + "',NOW(),");
                    sb.Append(" '" + StockReports.getip() + "','" + UserInfo.Centre + "','" + UserInfo.RoleID + "','','');");
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
                }
                    sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                    sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Department Receive (',ItemName,')'),@UserID,@UserName,@IpAddress,@CentreID, ");
                    sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID =@Test_ID");
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@UserID", UserInfo.ID),
                        new MySqlParameter("@UserName", UserInfo.LoginName),
                        new MySqlParameter("@IpAddress", StockReports.getip()),
                        new MySqlParameter("@CentreID", UserInfo.Centre),
                        new MySqlParameter("@RoleID", UserInfo.RoleID),
                        new MySqlParameter("@Test_ID", Util.GetString(Item[i].Split('|')[1])));

            }

            Tnx.Commit();
            
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
}
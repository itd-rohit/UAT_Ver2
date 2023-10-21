using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;
using System.Data;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System.Web.Script.Serialization;


public partial class Design_Lab_MergeBarcode : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        txtLabNo.Focus();
    }
    [WebMethod(EnableSession = true)]    
    public static string GetData(string LabNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT  lt.`PName`,CONCAT(lt.`Age`,'/ ',LEFT(lt.`Gender`,1)) AgeGender,lt.`LedgerTransactionNo`,plo.Test_ID, ");
            sb.Append(" lt.`LedgerTransactionNo`,inv.`Name` Investigation,plo.`BarcodeNo`,plo.`Result_Flag`,plo.`Approved`,plo.`IsSampleCollected`, ");
            sb.Append(" CASE WHEN plo.isPrint=1 THEN '#00FFFF' WHEN plo.Approved=1 THEN '#90EE90' WHEN plo.Result_Flag=1  THEN 'Pink' ");
            sb.Append(" WHEN plo.isSampleCollected='N' THEN  '#CC99FF'  WHEN plo.isSampleCollected='Y' THEN 'white'  ELSE 'white'  END rowcolor");
            sb.Append(" FROM `patient_labinvestigation_opd` plo ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` AND lt.`IsCancel`=0 ");
            sb.Append(" INNER JOIN investigation_master inv ON inv.`Investigation_Id`=plo.`Investigation_ID` ");
            sb.Append(" WHERE lt.`LedgerTransactionNo`=@LabNo ORDER BY inv.`Name`; ");

          using(DataTable dt = MySqlHelper.ExecuteDataset(con,CommandType.Text,sb.ToString(),
              new MySqlParameter("@LabNo",Util.GetString(LabNo))).Tables[0])
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);           
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string UpdateRecord(object savedata)
    {
        List<Mergebarcode> mergebarcode = new JavaScriptSerializer().ConvertToType<List<Mergebarcode>>(savedata);
        MySqlConnection con = Util.GetMySqlCon();        
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {
            for (int i = 0; i < mergebarcode.Count; i++)
            {
                if (mergebarcode[i].BarcodeNo == "")
                {
                    Tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Barcode cannot be  null..!" });
                }
                int valBarcode = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM `patient_labinvestigation_opd` plo WHERE BarcodeNo=@BarcodeNo AND `LedgertransactionNo`<>@LabNo ",
                    new MySqlParameter("@BarcodeNo", mergebarcode[i].BarcodeNo),
                    new MySqlParameter("@LabNo", mergebarcode[i].LabNo)));
                if (valBarcode > 0)
                {
                    Tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Barcode already exist..!" });
                }

                sb = new StringBuilder();
                sb.Append(" UPDATE patient_labinvestigation_opd SET BarcodeNo=@BarcodeNo, UpdateID=@UpdateID,UpdateName=@UpdateName,UpdateRemarks='Merge Barcode', ");
                sb.Append(" Updatedate=NOW() WHERE Test_ID=@Test_ID;");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@BarcodeNo", mergebarcode[i].BarcodeNo),
                    new MySqlParameter("@UpdateID", UserInfo.ID),
                    new MySqlParameter("@UpdateName", UserInfo.LoginName),
                    new MySqlParameter("@Test_ID", mergebarcode[i].TestID));

                sb = new StringBuilder();
                sb.Append(" INSERT INTO  patient_labinvestigation_opd_update_status(LedgerTransactionNo,Test_ID,STATUS,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID,OLDID,NEWID)  ");
                sb.Append(" values (@LabNo,@Test_ID,'Merge Barcode',@UserID,@UserName,NOW(), @getip,@Centre,@RoleID,@OLDID,@NEWID);");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@LabNo", mergebarcode[i].LabNo),
                    new MySqlParameter("@Test_ID", mergebarcode[i].TestID),
                    new MySqlParameter("@UserID", UserInfo.RoleID),
                    new MySqlParameter("@UserName", UserInfo.LoginName),
                    new MySqlParameter("@getip", StockReports.getip()),
                    new MySqlParameter("@Centre", UserInfo.Centre),
                    new MySqlParameter("@RoleID", UserInfo.RoleID),
                    new MySqlParameter("@OLDID", mergebarcode[i].OldBarcodeNo),
                    new MySqlParameter("@NEWID", mergebarcode[i].BarcodeNo));
            }
            Tnx.Commit();
            mergebarcode.Clear();
            return JsonConvert.SerializeObject(new { status = true });
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public class Mergebarcode
    {
        public string LabNo { get; set; }
        public string TestID { get; set; }
        public string BarcodeNo { get; set; }
        public string OldBarcodeNo { get; set; }
    }
}
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_ChangeBarcode : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Util.GetString(Request.QueryString["labno"]) != "")
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
    public static string GetData(string LabNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT plo.ReportType, lt.`PName`,CONCAT(lt.`Age`,'/ ',LEFT(lt.`Gender`,1)) AgeGender,lt.`LedgerTransactionNo`,plo.Test_ID, ");
            sb.Append(" lt.`LedgerTransactionNo`,inv.`Name` Investigation,plo.`BarcodeNo`,plo.`Result_Flag`,plo.`Approved`,plo.`IsSampleCollected`, ");
            sb.Append(" CASE WHEN plo.isPrint=1 THEN '#00FFFF' WHEN plo.Approved=1 THEN '#90EE90' WHEN plo.Result_Flag=1  THEN 'Pink' ");
            sb.Append(" WHEN plo.isSampleCollected='N' THEN  '#CC99FF'  WHEN plo.isSampleCollected='Y' THEN 'white'  ELSE 'white'  END rowcolor");
            sb.Append(" FROM `patient_labinvestigation_opd` plo ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN investigation_master inv ON inv.`Investigation_Id`=plo.`Investigation_ID` ");
            sb.Append(" WHERE lt.`LedgerTransactionNo`=@LabNo ORDER BY inv.`Name`; ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LabNo", Util.GetString(LabNo))).Tables[0])
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false });
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
        List<changebarcode> changebarcode = new JavaScriptSerializer().ConvertToType<List<changebarcode>>(savedata);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {
            for (int i = 0; i < changebarcode.Count; i++)
            {
                if (changebarcode[i].BarcodeNo == "")
                {
                    Tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Barcode cannot be  blank..!" });
                }
                int valBarcode = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM `patient_labinvestigation_opd` plo WHERE BarcodeNo=@BarcodeNo AND `LedgertransactionNo`<>@LabNo ",
                    new MySqlParameter("@BarcodeNo", changebarcode[i].BarcodeNo),
                    new MySqlParameter("@LabNo", changebarcode[i].LabNo)));
                if (valBarcode > 0)
                {
                    Tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Barcode already exist..!" });
                }
                sb = new StringBuilder();
                sb.Append(" UPDATE patient_labinvestigation_opd SET BarcodeNo=@BarcodeNo, UpdateID=@UpdateID,UpdateName=@UpdateName,UpdateRemarks='Change Barcode', ");
                sb.Append(" Updatedate=NOW() WHERE Test_ID=@Test_ID");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@BarcodeNo", changebarcode[i].BarcodeNo),
                    new MySqlParameter("@UpdateID", UserInfo.ID),
                    new MySqlParameter("@UpdateName", UserInfo.LoginName),
                    new MySqlParameter("@Test_ID", changebarcode[i].TestID));

                sb = new StringBuilder();
                sb.Append(" UPDATE sample_logistic SET BarcodeNo=@BarcodeNo,Barcode_Group=@BarcodeNo,UpdatedBy=@UpdateID,UpdatedDate=Now() ");
                sb.Append("  WHERE TestID=@Test_ID");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@BarcodeNo", changebarcode[i].BarcodeNo),
                    new MySqlParameter("@UpdateID", UserInfo.ID),
                    new MySqlParameter("@Test_ID", changebarcode[i].TestID));

                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,Remarks,OLDNAME,NEWNAME)VALUES(@LedgertransactionNo,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,now(),@DispatchCode,@Remarks,@OLDNAME,@NEWNAME) ",
                                                           new MySqlParameter("@LedgertransactionNo", changebarcode[i].LabNo),
                                                           new MySqlParameter("@Remarks", "Change  Barcode Old " + changebarcode[i].OldBarcodeNo + "  To " + changebarcode[i].BarcodeNo + " "),
                                                           new MySqlParameter("@OLDNAME", changebarcode[i].OldBarcodeNo),
                                                           new MySqlParameter("@NEWNAME", changebarcode[i].BarcodeNo),
                                                           new MySqlParameter("@Status", "Change  Barcode"), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                                                           new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@DispatchCode", string.Empty));

              
          }
            
            Tnx.Commit();
            changebarcode.Clear();
            return JsonConvert.SerializeObject(new { status = true });
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error Occurred" });
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    public class changebarcode
    {
        public string LabNo { get; set; }
        public string TestID { get; set; }
        public string BarcodeNo { get; set; }
        public string OldBarcodeNo { get; set; }
    }
}
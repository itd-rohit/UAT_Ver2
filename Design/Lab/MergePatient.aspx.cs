using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Data;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System.Web.Script.Serialization;

public partial class Design_Lab_MergePatient : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession = true)]    
    public static string GetData(string MobileNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT  lt.`PName`,CONCAT(lt.`Age`,'/ ',LEFT(lt.`Gender`,1)) AgeGender,lt.`LedgerTransactionNo`,DATE_FORMAT(lt.`Date`,'%d-%b-%Y')RegDate, ");
            sb.Append(" lt.`LedgerTransactionNo`,lt.Patient_ID,pm.Mobile,pm.Locality,pm.City,lt.PanelName,lt.DoctorName ");
            sb.Append(" FROM  `f_ledgertransaction` lt   ");
            sb.Append(" INNER JOIN patient_master pm on pm.Patient_ID=lt.Patient_ID AND lt.`IsCancel`=0 ");
            sb.Append(" WHERE pm.Mobile=@Mobile ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
              new MySqlParameter("@Mobile", Util.GetString(MobileNo))).Tables[0])
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
    public static string UpdatePatient(object savedata)
    {
        List<MergePatient> mergepatient = new JavaScriptSerializer().ConvertToType<List<MergePatient>>(savedata);
        MySqlConnection con = Util.GetMySqlCon();        
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {
            for (int i = 0; i < mergepatient.Count; i++)
            {
                sb = new StringBuilder();
                sb.Append(" UPDATE patient_labinvestigation_opd plo INNER JOIN `f_ledgertransaction` lt ON lt.LedgerTransactionID=plo.LedgerTransactionID ");
                sb.Append(" SET plo.Patient_ID=@Patient_ID,lt.Patient_ID=@Patient_ID, ");
                sb.Append(" plo.UpdateID=@UpdateID,plo.UpdateName=@UpdateName,plo.UpdateRemarks='Merge Patient', ");
                sb.Append(" plo.Updatedate=NOW() WHERE lt.Patient_ID=@OldPatientID;");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Patient_ID", mergepatient[i].PatientID),
                    new MySqlParameter("@UpdateID", UserInfo.ID),
                    new MySqlParameter("@UpdateName", UserInfo.LoginName),
                    new MySqlParameter("@OldPatientID", mergepatient[i].OldPatientID));
                if(mergepatient[i].OldPatientID!=mergepatient[i].PatientID)
                {
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE patient_master set IsActive=0,PatientGroup=@PatientGroup where Patient_ID=@Patient_ID",
                        new MySqlParameter("@Patient_ID", mergepatient[i].OldPatientID),
                        new MySqlParameter("@PatientGroup", mergepatient[i].PatientID));
                }

                sb = new StringBuilder();
                sb.Append(" INSERT INTO  patient_labinvestigation_opd_update_status(LedgerTransactionNo,Test_ID,STATUS,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID,OLDID,NEWID)  ");
                sb.Append(" values (@LabNo,@Test_ID,'Merge Patient',@UserID,@UserName,NOW(), @getip,@Centre,@RoleID,@OLDID,@NEWID);");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@LabNo", mergepatient[i].LabNo),
                    new MySqlParameter("@Test_ID", ""),
                    new MySqlParameter("@UserID", UserInfo.RoleID),
                    new MySqlParameter("@UserName", UserInfo.LoginName),
                    new MySqlParameter("@getip", StockReports.getip()),
                    new MySqlParameter("@Centre", UserInfo.Centre),
                    new MySqlParameter("@RoleID", UserInfo.RoleID),
                    new MySqlParameter("@OLDID", mergepatient[i].OldPatientID),
                    new MySqlParameter("@NEWID", mergepatient[i].PatientID));

            }
            Tnx.Commit();
            mergepatient.Clear();
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
    public class MergePatient
    {
        public string PatientID { get; set; }
        public string OldPatientID { get; set; }
        public string LabNo { get; set; }
    }
}
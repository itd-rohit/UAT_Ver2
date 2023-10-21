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

public partial class Design_SampleStorage_SampleSearchinStore : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        txtsinno.Focus();
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string searchIssue(string sinno)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append(" SELECT date_format(ss.dtentry,'%d-%b-%y') StoredDate,(select name from employee_master where employee_id=ss.userid) StoredBy, ss.SlotNumber, ifnull(ss.IssueTo,'')IssueTo,ifnull(ss.IssueByUserName,'')IssueByUserName,date_format(ss.ProcessedDate,'%d-%b-%y') ProcessedDate ,date_format(ss.ExpiryDate,'%d-%b-%y') ExpiryDate, ifnull(date_format(ss.DiscardDate,'%d-%b-%y'),'') DiscardDate,ifnull((select name from employee_master where employee_id=ss.DiscardBy),'') DiscardBy,ifnull(IssuePurpose,'')IssuePurpose,ifnull(IssueInvoiceNo,'')IssueInvoiceNo,  ifnull(date_format(ss.IssueDate,'%d-%b-%y'),'')  IssueDate,ss.status, (case when ss.`Status`=1 then 'white' when ss.Status=2 then 'pink' when ss.Status=3 then 'lightgreen' end) RowColor,(case when ss.`Status`=1 then 'Stored' when ss.Status=2 then 'Discarded' when ss.Status=3 then 'Issued' end) mystatus, ss.id uniid, lt.`LedgerTransactionNo`,plo.`BarcodeNo` Sinno,  lt.`PName`,CONCAT(lt.`Age`,'/',LEFT(lt.`Gender`,1)) Pinfo, plo.`Patient_ID`, ");
            sb.Append(" (SELECT centre FROM centre_master WHERE centreid=lt.centreid) BookingCentre, ");
            sb.Append(" (SELECT centre FROM centre_master WHERE centreid=ss.centreid) StorageCentre,plo.`SampleTypeName`,  ");
            sb.Append(" sdm.`DeviceName`,ss.`RackID` RackNumber,ss.`TrayCode`  ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo   ");
            sb.Append(" INNER JOIN `ss_samplestorage` ss ON plo.`BarcodeNo`=ss.`BarcodeNo`  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");
            sb.Append(" INNER JOIN `ss_storagedevicemaster` sdm ON sdm.`ID`=ss.`DeviceID`  ");
            sb.Append(" where plo.barcodeno=@sinno or plo.LedgerTransactionNo=@sinno ");
            sb.Append(" group by plo.barcodeno ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@sinno", sinno)
                ).Tables[0])
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

}
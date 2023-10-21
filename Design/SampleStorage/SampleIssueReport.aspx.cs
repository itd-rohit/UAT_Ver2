using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_SampleStorage_SampleIssueReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtdatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtdateo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }
    protected void btn_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            lblMsg.Text = "";

            sb.Append(" SELECT ss.barcodeno SINNo,");
            sb.Append(" (SELECT centre FROM centre_master WHERE centreid=ss.centreid) StorageCentre,plo.`SampleTypeName`,( case when type='P' then 'Processed Sample' else 'Scheduled Sample' end) Type , ");
            sb.Append(" sdm.`DeviceName`,ss.`RackID` RackNumber,ss.`TrayCode`,ss.SlotNumber,date_format(ss.ProcessedDate,'%d-%b-%y')  ProcessedDate,date_format(ss.ExpiryDate,'%d-%b-%y')  ExpiryDate,  ");
            sb.Append(" ss.IssueTo,ss.IssueByUserName, date_format(ss.IssueDate,'%d-%b-%y')  IssueDate,IssuePurpose,IssueInvoiceNo ");
            sb.Append("  ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo   ");
            sb.Append(" INNER JOIN `ss_samplestorage` ss ON plo.`BarcodeNo`=ss.`BarcodeNo`  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");
            sb.Append(" INNER JOIN `ss_storagedevicemaster` sdm ON sdm.`ID`=ss.`DeviceID`  ");
            sb.Append(" WHERE ss.status=3 ");
            sb.Append(" AND ss.IssueDate>=@FromDate AND ss.IssueDate<=@ToDate order by IssueDate");
            string Period = string.Format("{0} {1}-{2} {3}", txtdatefrom.Text, "00:00:00", txtdateo.Text, "23:59:59");

            NameValueCollection collections = new NameValueCollection();
            collections.Add("ReportDisplayName", Common.EncryptRijndael("Sample Issue Report Detail"));
            collections.Add("FromDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(txtdatefrom.Text).ToString("yyyy-MM-dd"), " ", "00:00:00")));
            collections.Add("ToDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(txtdateo.Text).ToString("yyyy-MM-dd"), " ", "23:59:59")));            
            collections.Add("Period", Common.EncryptRijndael(Period));
            collections.Add("Query", Common.EncryptRijndael(sb.ToString()));
            AllLoad_Data.ExpoportToExcelEncrypt(collections, 2, this.Page);
           
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
}
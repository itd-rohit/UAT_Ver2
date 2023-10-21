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


public partial class Design_SampleStorage_SampleStorageReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtdatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtdateo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            binddevice();
            bindsampletype();

        }
    }


    void binddevice()
    {
        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT id,devicename FROM `ss_storagedevicemaster` WHERE centreid=@Centre",
                new MySqlParameter("@Centre", UserInfo.Centre)
                ).Tables[0])
            {
                ddldevice.DataSource = dt;
                ddldevice.DataValueField = "id";
                ddldevice.DataTextField = "devicename";
                ddldevice.DataBind();
            }

            ddldevice.Items.Insert(0, new ListItem("All", "0"));
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

    void bindsampletype()
    {
        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
           
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT id,samplename FROM sampletype_master WHERE isactive=1 ORDER BY samplename").Tables[0])
            {
                ddlsampletype.DataValueField = "id";
                ddlsampletype.DataTextField = "samplename";
                ddlsampletype.DataSource = dt;
                ddlsampletype.DataBind();
            }
            ddlsampletype.Items.Insert(0, new ListItem("All", "0"));

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

    protected void btn_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            lblMsg.Text = "";
            sb.Append(" SELECT ss.BarcodeNo SinNo,");
            sb.Append(" (SELECT centre FROM centre_master WHERE centreid=ss.centreid) StorageCentre,plo.`SampleTypeName`,( case when type='P' then 'Processed Sample' else 'Scheduled Sample' end) Type , ");
            sb.Append(" sdm.`DeviceName`,ss.`RackID` RackNumber,ss.`TrayCode`,ss.SlotNumber,date_format(ss.ProcessedDate,'%d-%b-%y')  ProcessedDate,date_format(ss.ExpiryDate,'%d-%b-%y')  ExpiryDate,  ");
            sb.Append(" ( case when status='1' then 'Stored' when status='2' then 'Discarded' else 'Issued' end) Type  ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo   ");
            sb.Append(" INNER JOIN `ss_samplestorage` ss ON plo.`BarcodeNo`=ss.`BarcodeNo`  ");
            if (txtsinno.Text != "")
                sb.Append(" and ss.`BarcodeNo`=@txtsinno ");
            if (ddlsampletype.SelectedValue != "0")
                sb.Append(" and plo.`SampleTypeID`=@ddlsampletype ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");
            sb.Append(" INNER JOIN `ss_storagedevicemaster` sdm ON sdm.`ID`=ss.`DeviceID`  ");
            if (ddldevice.SelectedValue != "0")
                sb.Append(" and sdm.`ID`=@ddlsampletype ");
            sb.Append(" WHERE  ");
            sb.Append("  ss.dtEntry>=@txtdatefrom AND ss.dtEntry<=@txtdateo order by dtEntry");

            string Period = string.Format("{0} {1}-{2} {3}", txtdatefrom.Text, "00:00:00", txtdateo.Text, "23:59:59");

            NameValueCollection collections = new NameValueCollection();
            collections.Add("ReportDisplayName", Common.EncryptRijndael("Sample Storage Report Detail"));
            collections.Add("FromDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(txtdatefrom.Text).ToString("yyyy-MM-dd"), " ", "00:00:00")));
            collections.Add("ToDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(txtdateo.Text).ToString("yyyy-MM-dd"), " ", "23:59:59")));
            collections.Add("txtsinno#0", Common.EncryptRijndael(txtsinno.Text));
            collections.Add("ddlsampletype#0", Common.EncryptRijndael(ddlsampletype.SelectedValue));
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
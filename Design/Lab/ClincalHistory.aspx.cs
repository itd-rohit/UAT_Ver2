using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

public partial class Design_Lab_SampleTracking : System.Web.UI.Page
{
    string labid = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        lblerrmsg.Text = "";
        if (Request.QueryString["IsEncript"] == null)
        {
            labid = Util.GetString(Common.Decrypt(Util.GetString(Request.QueryString["LabNo"])));
        }
        else
        {
            labid = Util.GetString(Request.QueryString["LabNo"]);
        }
        if (Request.QueryString["LabNo"] != null && IsPostBack == false)
        {
            txtClinicalHistory.Text = GetClincalHistory();
            ChangeStatusLog();
        }
    }

    protected void btnClincalUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string _HistoryOLD = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Clinicalhistory FROM f_ledgertransaction WHERE ledgertransactionno=@Labno", new MySqlParameter("@Labno", labid)));
            if (_HistoryOLD != txtClinicalHistory.Text.Trim())
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, " Update f_ledgertransaction set Clinicalhistory=@ClinicalHistory WHERE ledgertransactionno=@Labno ",
                   new MySqlParameter("@ClinicalHistory", txtClinicalHistory.Text.Trim()),new MySqlParameter("@Labno",labid));
                StringBuilder sb_1 = new StringBuilder();
                sb_1.Append("  INSERT INTO `patient_labinvestigation_opd_update_status`(`LedgertransactionNo`,`Status`,OLDNAME,`NEWNAME`,UserID,UserName,dtEntry,RoleID,CentreID,IPAddress) ");
                sb_1.Append("  values('" + labid + "','Change History','" + _HistoryOLD + "','" + txtClinicalHistory.Text.Trim() + "','" + Util.GetString(UserInfo.ID) + "','" + Util.GetString(UserInfo.LoginName) + "',NOW(),'" + Util.GetString(UserInfo.RoleID) + "','" + Util.GetString(UserInfo.Centre) + "','" + StockReports.getip() + "');  ");
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb_1.ToString(),
                   new MySqlParameter("@ClinicalHistory", txtClinicalHistory.Text.Trim()),new MySqlParameter("@Labno",labid));
                lblerrmsg.Text = "History Updated..!!!";
            }
            ChangeStatusLog();
            lblerrmsg.Text = "Update Successfull";
        }
        catch (Exception ex)
        {
            lblerrmsg.Text = "Somthing Went Wrong";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    private void ChangeStatusLog()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT UserName,IpAddress,Date_format(dtEntry,'%d-%b-%Y %I:%i %p') dtEntry,OLDNAME,NEWNAME  FROM patient_labinvestigation_opd_update_status ");
        sb.Append(" WHERE   LedgerTransactionNo='" + labid + "' and Status='Change History' ");
        sb.Append(" Order by dtEntry DESC");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdLog.DataSource = dt;
            grdLog.DataBind();
        }
    }
    private string GetClincalHistory()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            return Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT lt.ClinicalHistory FROM `f_ledgertransaction` lt  WHERE lt.`LedgerTransactionNo`=@LabNo",
                       new MySqlParameter("@LabNo", labid)));
           
        }
        catch (Exception ex)
        {
            lblerrmsg.Text = "Somthing Went Wrong";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            
            return "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
       
    }
}
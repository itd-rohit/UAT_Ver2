using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_Lab_AddRemarks_PatientTestPopup : System.Web.UI.Page
{
    public string UserID;
    public string UserName;
    public string CurrentDataTimeDisp;
    public string TestID;
    public string VisitNo;
    public string Offline;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            lblTestName.Text = Common.DecryptRijndael(Request.QueryString["TestName"].ToString().Replace("'", "").Replace(" ", "+"));
            UserID = Util.GetString(UserInfo.ID);
            UserName = UserInfo.LoginName;
            CurrentDataTimeDisp = DateTime.Now.ToString("dd-MM-yyyy hh:mm:ss tt");
            VisitNo = Common.DecryptRijndael(Request.QueryString["VisitNo"].ToString().Replace(" ", "+"));
            TestID = Common.DecryptRijndael(Request.QueryString["TestID"].ToString().Replace(" ", "+"));
            
            try
            {
                Offline = Util.GetString(Common.DecryptRijndael(Request.QueryString["Offline"].ToString().Replace(" ", "+")));
            }
            catch
            {
                Offline = "0";
            }
        }
    }
    protected void ddlRemarks_SelectedIndexChanged(object sender, EventArgs e)
    {
        Response.Write("<script>OnRemarksChange();</script>");
    }
    [WebMethod(EnableSession = true)]
    public static string SavePatientRemarks(string TestID, string Remarks, string VisitNo, string ShowOnline, string Offline)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (Offline.Trim() == string.Empty)
            {
                Offline = "0";
            }
            int LedgerTransactionID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT LedgerTransactionID FROM f_ledgertransaction WHERE LedgerTransactionNo=@LedgerTransactionNo",
                                                                            new MySqlParameter("@LedgerTransactionNo", VisitNo)));
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_remarks  ");
            sb.Append("  (`UserID`,`UserName`,`Test_ID`,`Remarks`,`LedgerTransactionNo`,`ShowOnline`,DATE,LedgerTransactionID) ");
            sb.Append("  values (");
            sb.Append(" @UserID,@UserName,@Test_ID,@Remarks,@LedgerTransactionNo,@ShowOnline,NOW(),@LedgerTransactionID ");
            sb.Append(" ) ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName), new MySqlParameter("@Test_ID", TestID.Trim()),
               new MySqlParameter("@Remarks", Remarks.Trim()), new MySqlParameter("@LedgerTransactionNo", VisitNo.Trim()),
               new MySqlParameter("@ShowOnline", ShowOnline.Trim()),
               new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
            Tnx.Commit();

            return JsonConvert.SerializeObject(new { status = true, response = "Remarks Saved" });

        }

        catch
        {
            Tnx.Rollback();

            return JsonConvert.SerializeObject(new { status = true, response = "Error" });
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string DeleteRemarks(string ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE patient_labinvestigation_opd_remarks SET ");
            sb.Append(" IsActive=0,UpdatedByID=@UserID,UpdatedBy=@UserName,UpdatedOn=now() where ID=@ID");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                new MySqlParameter("@ID", ID.Trim()));
            Tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Remarks Removed" });
        }

        catch
        {
            Tnx.Rollback();
            return JsonConvert.SerializeObject(new { status = true, response = "Remarks Not Removed" });
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string GetRemarks(string TestID, string Offline)
    {
        if (Offline.Trim() == string.Empty)
        {
            Offline = "0";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string mstr = "select ID,Date_format(DATE,'%Y-%m-%d %h:%i %p')DATE,UserID,UserName,EndDate,Remarks,Test_ID,LedgerTransactionNo,IF(ShowOnline=1,'Yes','No')ShowOnline from patient_labinvestigation_opd_remarks where Test_ID = @Test_ID and IsActive=1  order by ID  ";
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, mstr,
            new MySqlParameter("@Test_ID", TestID.Trim())).Tables[0])
            {
                return Util.getJson(dt);
            }

        }
        catch
        {
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}

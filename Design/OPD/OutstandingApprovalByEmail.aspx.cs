using MySql.Data.MySqlClient;
using System;
using System.Data;

public partial class Design_OPD_OutstandingApprovalByEmail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string labno = Common.Decrypt(Util.GetString(Request.QueryString["VisitNo"]));
        string type = Common.Decrypt(Util.GetString(Request.QueryString["type"]));
        string AppByID = Common.Decrypt(Util.GetString(Request.QueryString["AppBy"]));
        string outstandingamt = Common.Decrypt(Util.GetString(Request.QueryString["outamt"]));

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(1) FROM f_ledgertransaction where LedgerTransactionID=@LedgerTransactionID AND CashOutstanding=@CashOutstanding AND OutstandingEmployeeId=@OutstandingEmployeeId ",
               new MySqlParameter("@LedgerTransactionID", labno), new MySqlParameter("@CashOutstanding", outstandingamt), new MySqlParameter("@OutstandingEmployeeId", AppByID)));
            if (count > 0)
            {
                int chkApp = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT OutstandingStatus FROM f_ledgertransaction where LedgerTransactionID=@LedgerTransactionID ",
               new MySqlParameter("@LedgerTransactionID", labno)));
                if (chkApp == 0)
                {
                    if (type == "1")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertransaction set OutstandingStatus=1,OutstandingVerifiedDate=NOW() WHERE LedgerTransactionID=@LedgerTransactionID",
                           new MySqlParameter("@LedgerTransactionID", labno));

                        lblerrmsg.BackColor = System.Drawing.Color.Green;
                        lblerrmsg.Text = "Outstanding Approved";
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertransaction set OutstandingStatus=-1,OutstandingVerifiedDate=NOW() WHERE LedgerTransactionID=@LedgerTransactionID",
                          new MySqlParameter("@LedgerTransactionID", labno));

                        lblerrmsg.BackColor = System.Drawing.Color.Red;
                        lblerrmsg.Text = "Outstanding Rejected";
                    }
                }
                else if (chkApp == 1)
                {
                    lblerrmsg.BackColor = System.Drawing.Color.Red;
                    lblerrmsg.Text = "Outstanding Already Approved";
                }
                else if (chkApp == -1)
                {
                    lblerrmsg.BackColor = System.Drawing.Color.Red;
                    lblerrmsg.Text = "Outstanding Already Rejected";
                }
            }
            else
            {

                lblerrmsg.BackColor = System.Drawing.Color.Red;
                lblerrmsg.Text = "Record Not Found";
            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
        }
        finally
        {
            con.Close();
            con.Dispose();
            tnx.Dispose();
        }
    }
}
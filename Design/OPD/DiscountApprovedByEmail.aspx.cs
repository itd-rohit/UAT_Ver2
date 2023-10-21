using MySql.Data.MySqlClient;
using System;
using System.Data;

public partial class Design_OPD_DiscountApprovedByEmail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string labno = Common.Decrypt(Util.GetString(Request.QueryString["VisitNo"]));
        string type = Common.Decrypt(Util.GetString(Request.QueryString["type"]));
        string AppByID = Common.Decrypt(Util.GetString(Request.QueryString["AppBy"]));
        string discamt = Common.Decrypt(Util.GetString(Request.QueryString["discamt"]));

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(*) FROM f_ledgertransaction where LedgerTransactionID=@LedgerTransactionID AND DiscountOnTotal=@DiscountOnTotal AND DiscountApprovedByID=@DiscountApprovedByID ",
               new MySqlParameter("@LedgerTransactionID", labno), new MySqlParameter("@DiscountOnTotal", discamt), new MySqlParameter("@DiscountApprovedByID", AppByID)));
            if (count > 0)
            {
                int chkApp = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IsDiscountApproved FROM f_ledgertransaction where LedgerTransactionID=@LedgerTransactionID ",
               new MySqlParameter("@LedgerTransactionID", labno)));
                if (chkApp == 0)
                {
                    if (type == "1")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertransaction set IsDiscountApproved=1,DiscountApprovedDate=NOW() WHERE LedgerTransactionID=@LedgerTransactionID",
                           new MySqlParameter("@LedgerTransactionID", labno));

                        lblerrmsg.BackColor = System.Drawing.Color.Green;
                        lblerrmsg.Text = "Discount Approved";
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE f_ledgertransaction lt INNER JOIN patient_labinvestigation_opd plo ON lt.LedgerTransactionID=plo.LedgerTransactionID set plo.DiscountAmt=0,plo.Amount=plo.Rate,lt.IsDiscountApproved=-1,lt.DiscountApprovedDate=now(),lt.DiscountID=0,lt.DiscountOnTotal=0.00,lt.NetAmount=lt.GrossAmount,lt.DiscountReason='Discount Rejected',lt.DiscountApprovedByID=0,lt.DiscountApprovedByName='' WHERE lt.LedgerTransactionID=@LedgerTransactionID",
                           new MySqlParameter("@LedgerTransactionID", labno));

                        lblerrmsg.BackColor = System.Drawing.Color.Red;
                        lblerrmsg.Text = "Discount Rejected";
                    }
                }
                else if (chkApp == 1)
                {
                    lblerrmsg.BackColor = System.Drawing.Color.Red;
                    lblerrmsg.Text = "Discount Already Approved";
                }
                else if (chkApp == -1)
                {
                    lblerrmsg.BackColor = System.Drawing.Color.Red;
                    lblerrmsg.Text = "Discount Already Rejected";
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
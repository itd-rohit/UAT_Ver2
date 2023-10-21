using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for CashoutstandingEmail
/// </summary>
public class CashoutstandingEmail
{
    //
    // TODO: Add constructor logic here



    public string SendOutstandingVerificationmail(string LedgerTransactionID, int MailCon)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT emc.ID,fl.`LedgerTransactionNo`,fl.LedgerTransactionID,fl.`BillNo`,DATE_FORMAT(fl.`Date`,'%d-%b-%Y')BillDATE,fl.`PName`,fl.age,fl.gender,IFNULL(fl.`GrossAmount`,0)GrossAmount,IFNULL(fl.`NetAmount`,0)NetAmount,IFNULL(fl.`Adjustment`,0)PaidAmt,");
        sb.Append(" IFNULL(fl.`DiscountOnTotal`,0)DiscountOnTotal,IFNULL(fl.`CashOutstanding`,0)CashOutstanding,fl.`OutstandingStatus`,fl.`OutstandingEmployeeId`,em.`Name`,emc.email,cm.centre,CASE WHEN fl.OutstandingStatus=0 THEN '#FFC0CB' WHEN fl.OutstandingStatus=1 THEN '#90EE90' WHEN fl.OutstandingStatus=-1 THEN '#00FFFF' END rowcolor FROM Email_Cashoutstanding emc ");
        sb.Append(" INNER JOIN f_ledgertransaction fl ON fl.`LedgerTransactionID`=emc.`LedgerTransactionID`  INNER JOIN employee_master em ON em.employee_id=fl.`OutstandingEmployeeId`");
        sb.Append(" INNER JOIN centre_master cm ON cm.centreid=fl.centreid  AND emc.IsSend=0 ");
        if (LedgerTransactionID != "0")
            sb.Append(" WHERE emc.LedgerTransactionID=" + LedgerTransactionID.Trim() + " ");
        else
            sb.Append(" WHERE OutstandingStatus=0 ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
            {
                return sendmail(dt);
            }
            else
            {
                return "0";
            }
        }
    }



    public string sendmail(DataTable dt)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            string body = string.Empty; string mainBody = string.Empty;
            using (StreamReader reader = new StreamReader(HttpContext.Current.Server.MapPath("~/EmailBody/OutstandingEmailTemplate.txt")))
            {
                body = reader.ReadToEnd();
            }

            mainBody = body;

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                body = body.Replace("{PName}", Util.GetString(dt.Rows[i]["PName"].ToString().ToUpper()));
                body = body.Replace("{Age}", Util.GetString(dt.Rows[i]["age"].ToString()));
                body = body.Replace("{Gender}", Util.GetString(dt.Rows[i]["gender"].ToString()));
                body = body.Replace("{Centre}", Util.GetString(dt.Rows[i]["centre"].ToString()));
                body = body.Replace("{GrossAmt}", Util.GetString(dt.Rows[i]["GrossAmount"].ToString()));
                body = body.Replace("{DiscAmt}", Util.GetString(dt.Rows[i]["DiscountOnTotal"].ToString()));
                body = body.Replace("{NetAmt}", Util.GetString(dt.Rows[i]["NetAmount"].ToString()));
                body = body.Replace("{PaidAmt}", Util.GetString(dt.Rows[i]["PaidAmt"].ToString()));
                body = body.Replace("{OutstandingAmt}", Util.GetString(dt.Rows[i]["CashOutstanding"].ToString()));
                if (Resources.Resource.RemoteLinkApplicable == "1")
                {
                    body = body.Replace("{ApprovedLink}", string.Format("<a href=\'{0}/Design/OPD/OutstandingApprovalByEmail.aspx?VisitNo={1}&type={2}&outamt={3}&AppBy={4}\'>Click here to Approve Cash Outstanding Amount</a>", Resources.Resource.RemoteLink, Common.Encrypt(Util.GetString(dt.Rows[i]["LedgerTransactionID"].ToString())), Common.Encrypt("1"), Common.Encrypt(Util.GetString(dt.Rows[i]["CashOutstanding"].ToString())), Common.Encrypt(Util.GetString(dt.Rows[i]["OutstandingEmployeeId"].ToString()))));
                    body = body.Replace("{RejectLink}",   string.Format("<a href=\'{0}/Design/OPD/OutstandingApprovalByEmail.aspx?VisitNo={1}&type={2}&outamt={3}&AppBy={4}\'>Click here to Reject Cash Outstanding Amount</a>", Resources.Resource.RemoteLink, Common.Encrypt(Util.GetString(dt.Rows[i]["LedgerTransactionID"].ToString())), Common.Encrypt("-1"), Common.Encrypt(Util.GetString(dt.Rows[i]["CashOutstanding"].ToString())), Common.Encrypt(Util.GetString(dt.Rows[i]["OutstandingEmployeeId"].ToString()))));
                }
                if (Resources.Resource.LocalLinkApplicable == "1")
                {
                    body = body.Replace("{LocalApprovedLink}", string.Format("<a href=\'{0}/Design/OPD/OutstandingApprovalByEmail.aspx?VisitNo={1}&type={2}&outamt={3}&AppBy={4}\'>Click here to Approve Cash Outstanding Amount</a>", Resources.Resource.LocalLink, Common.Encrypt(Util.GetString(dt.Rows[i]["LedgerTransactionID"].ToString())), Common.Encrypt("1"), Common.Encrypt(Util.GetString(dt.Rows[i]["CashOutstanding"].ToString())), Common.Encrypt(Util.GetString(dt.Rows[i]["OutstandingEmployeeId"].ToString()))));
                    body = body.Replace("{LocalRejectLink}",   string.Format("<a href=\'{0}/Design/OPD/OutstandingApprovalByEmail.aspx?VisitNo={1}&type={2}&outamt={3}&AppBy={4}\'>Click here to Reject Cash Outstanding Amount</a>", Resources.Resource.LocalLink, Common.Encrypt(Util.GetString(dt.Rows[i]["LedgerTransactionID"].ToString())), Common.Encrypt("-1"), Common.Encrypt(Util.GetString(dt.Rows[i]["CashOutstanding"].ToString())), Common.Encrypt(Util.GetString(dt.Rows[i]["OutstandingEmployeeId"].ToString()))));
                }
                if ((Util.GetString(dt.Rows[i]["email"].ToString())) == string.Empty)
                {
                    return "2";
                }
                else
                {
                    ReportEmailClass res = new ReportEmailClass();
                    try
                    {
                        string EmailStatus = res.sendDiscountApproval(Util.GetString(dt.Rows[i]["email"].ToString()), "Outstanding Approval/Rejection", body, "");
                        try
                        {
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, " UPDATE Email_Cashoutstanding SET IsSend=@IsSend,SendDate=NOW() WHERE ID=@ID",
                                     new MySqlParameter("@ID", dt.Rows[i]["ID"]), new MySqlParameter("@IsSend", EmailStatus));
                        }
                        catch (Exception ex)
                        {
                            ClassLog cl = new ClassLog();
                            cl.errLog(ex);
                        }
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);

                    }
                    body = mainBody;
                }
            }
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

    }

}

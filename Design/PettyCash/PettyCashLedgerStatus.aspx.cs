using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_PettyCash_PettyCashLedgerStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calFromDate.EndDate = DateTime.Now;
        }
    }

    [WebMethod]
    public static string bindtable(string todate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pcl.centreid,pcl.centreCode,pcl.Centre,SUM(pcl.amount) Total,(SELECT ABS(IFNULL(SUM(amount),0)) FROM ");
            sb.Append(" `petty_cash_ledger` WHERE centreid=pcl.centreid  AND IsActive=1 AND IsApproved=0) as pending, ");
            sb.Append(" (SELECT ABS(IFNULL(SUM(amount),0)) FROM `petty_cash_ledger` WHERE centreid=pcl.centreid AND IsActive=1  ");
            sb.Append(" AND TYPE='Expense' AND IsApproved=1) AS TotalExp, (SELECT ABS(IFNULL(SUM(amount),0)) FROM `petty_cash_ledger` ");
            sb.Append("  WHERE centreid=pcl.centreid AND isApproved=1 AND IsActive=1  AND TYPE='Issue'  ) AS TotalIssue ");
            sb.Append(" FROM petty_cash_ledger pcl WHERE isApproved=1 AND  DATE<=@todate ");
            sb.Append(" GROUP BY centreid order by Centre,centreCode ");
            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
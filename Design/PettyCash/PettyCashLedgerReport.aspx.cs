using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_PettyCash_PettyCashLedgerReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            Bindexpense();
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
    }

    public void Bindexpense()
    {
        ddlExpense.DataSource = StockReports.GetDataTable("SELECT ID,Typename FROM petty_expansetype where IsActive=1  ORDER BY Typename");
        ddlExpense.DataValueField = "ID";
        ddlExpense.DataTextField = "Typename";
        ddlExpense.DataBind();
        ddlExpense.Items.Insert(0, new ListItem("ALL", "0"));
    }

    [WebMethod]
    public static string bindtable(string Centreid, string fromdate, string todate, string viewtype, string ExpType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (viewtype == "1")
            {
                sb.Append(" SELECT ifnull(pcl.Remarks,'')Remarks,centreid,centreCode,Centre,TYPE,SUM(amount) Total,MONTHNAME(DATE) as month,");
                sb.Append("  (SELECT IFNULL(SUM(Amount),0) FROM petty_cash_ledger WHERE centreid= pcl.centreid and isApproved=1 AND ApprovedDate<@fromdate  )AS opening ");
                sb.Append(" FROM petty_cash_ledger pcl ");

                sb.Append(" LEFT join petty_expansetype pet on pet.ID=pcl.ExpensesID WHERE isApproved=1  ");
                if (Centreid.Split('#')[0] != "ALL")
                {
                    sb.Append(" AND centreid=@centreid ");
                }

                if (ExpType != "0")
                    sb.Append("and pet.ID =@ID ");
                sb.Append(" and ApprovedDate>=@fromdate ");
                sb.Append(" and ApprovedDate<=@todate ");
                sb.Append("   GROUP BY CentreId, MONTH(DATE),TYPE    ORDER BY Centre,  MONTH(DATE)    ");
            }
            else if (viewtype == "2")
            {
                sb.Append(" SELECT ifnull(pcl.Remarks,'')Remarks,centreid,centreCode,Centre,TYPE,SUM(amount) Total,DATE_FORMAT(ApprovedDate,'%d-%M-%Y ') as month,");
                sb.Append(" (SELECT IFNULL(SUM(Amount),0) FROM petty_cash_ledger WHERE centreid=pcl.centreid And isApproved=1 AND ApprovedDate<@fromdate  ) AS opening FROM ");
                sb.Append(" petty_cash_ledger pcl ");
                sb.Append(" LEFT join petty_expansetype pet on pet.ID=pcl.ExpensesID WHERE isApproved=1  ");
                if (Centreid.Split('#')[0] != "ALL")
                {
                    sb.Append(" AND centreid=@centreid ");
                }
                if (ExpType != "0")
                    sb.Append("and pet.ID =@ID ");
                sb.Append(" and ApprovedDate>=@fromdate ");
                sb.Append(" and ApprovedDate<=@todate ");
                sb.Append(" GROUP BY CentreId,TYPE ,DATE_FORMAT(DATE,'%d-%M-%Y ') ORDER BY Centre,DATE(DATE)  ");
            }
            else
            {
                sb.Append(" SELECT ifnull(pcl.Remarks,'')Remarks,centreid,centreCode,Centre,TYPE,(amount) Total,Filename,DATE_FORMAT(ApprovedDate,'%d-%M-%Y ') as month,");
                sb.Append(" (SELECT IFNULL(SUM(Amount),0) FROM petty_cash_ledger WHERE centreid=pcl.centreid And isApproved=1 AND ApprovedDate<@fromdate  )AS opening,ExpansesType,Narration FROM ");
                sb.Append(" petty_cash_ledger pcl  ");
                sb.Append(" LEFT join petty_expansetype pet on pet.ID=pcl.ExpensesID WHERE isApproved=1  ");
                if (Centreid.Split('#')[0] != "ALL")
                {
                    sb.Append(" AND centreid=@centreid");
                }
                if (ExpType != "0")
                    sb.Append("and pet.ID =@ID");
                sb.Append(" and ApprovedDate>=@fromdate");
                sb.Append(" and ApprovedDate<=@todate ");
                sb.Append(" ORDER BY Centre, DATE(DATE)  ");
            }

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@ID", ExpType),
                 new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                 new MySqlParameter("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59")),
                 new MySqlParameter("@centreid", Centreid.Split('#')[0])).Tables[0])
            {
                float TotalExpense = 0.0f;
                float TotalIssue = 0.0f;

                DataColumn dcTotalExpense = new DataColumn("TotalExpense");
                dt.Columns.Add(dcTotalExpense);

                DataColumn dcTotalIssue = new DataColumn("TotalIssue");
                dt.Columns.Add(dcTotalIssue);

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (dt.Rows[i]["centreid"].ToString() == dt.Rows[i]["centreid"].ToString())
                    {
                        TotalExpense = Util.GetFloat(dt.Compute("Sum(total)", string.Format("Type = 'Expense' AND centreid={0}", dt.Rows[i]["centreid"])));
                        TotalIssue = Util.GetFloat(dt.Compute("Sum(total)", string.Format("Type = 'Issue' AND centreid={0}", dt.Rows[i]["centreid"])));
                        dt.Rows[i]["TotalExpense"] = TotalExpense;
                        dt.Rows[i]["TotalIssue"] = TotalIssue;
                        TotalExpense = 0;
                        TotalIssue = 0;
                    }
                }
                return JsonConvert.SerializeObject(dt);
            }
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
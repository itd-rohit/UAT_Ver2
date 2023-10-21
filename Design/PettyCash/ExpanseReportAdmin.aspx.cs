using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;

public partial class Design_PettyCash_ExpanseReportAdmin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SearchRecords(string Centreid, string fromdate, string todate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] CentreTags = Centreid.Split(',');
            string[] CentreParamNames = CentreTags.Select((s, i) => "@tag" + i).ToArray();
            string CentreClause = string.Join(", ", CentreParamNames);

            string bindData = string.Empty;

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT Case when ifnull(IsApproved,0)=2 then 'aqua' when ifnull(IsApproved,0)=1 then '#90EE90' else 'pink' end as rowColor,id,centre,centrecode,");
            sb.Append(" amount,DATE_FORMAT(DATE,'%d-%M-%Y ') DATE,createby,TYPE,paymentmode,InvoiceNo,IsApproved,Bank,CardNo,ApprovedBy,DATE_FORMAT(ApprovedDate,'%d-%M-%Y ')ApprovedDate,");
            sb.Append(" Filename FROM petty_cash_ledger ");
            sb.Append(" WHERE IsActive=1 AND TYPE='Expense' AND DATE>=@fromdate AND DATE<=@todate ");

            if (Centreid != string.Empty)
            {
                sb.Append(" AND CentreID IN({0})");
                bindData = string.Format(sb.ToString(), CentreClause);
            }
            else
                bindData = sb.ToString();

            using (MySqlDataAdapter da = new MySqlDataAdapter(bindData, con))
            {
                if (Centreid != string.Empty)
                {
                    for (int i = 0; i < CentreParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(CentreParamNames[i], CentreTags[i]);
                    }
                }
                da.SelectCommand.Parameters.AddWithValue("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " ", "00:00:00"));
                da.SelectCommand.Parameters.AddWithValue("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59"));
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    sb = new StringBuilder();
                    return JsonConvert.SerializeObject(dt);
                }
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

    [WebMethod(EnableSession = true)]
    public static string bindtablewithstatus(string status)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT Case when ifnull(IsApproved,0)=2 then 'aqua' when ifnull(IsApproved,0)=1 then '#90EE90' else 'pink' end as rowColor,id,centre,centrecode, ");
            sb.Append(" amount,DATE_FORMAT(DATE,'%d-%M-%Y ') DATE,createby,TYPE,paymentmode,InvoiceNo,IsApproved,CardNo,Bank,ApprovedBy,DATE_FORMAT(ApprovedDate,'%d-%M-%Y ')ApprovedDate,");
            sb.Append(" Filename  FROM petty_cash_ledger WHERE TYPE='Expense'  AND IsActive=1  AND IsApproved=@IsApproved ");
            sb.Append("  order BY CreatedDate desc");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@IsApproved", status)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = true, response = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
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
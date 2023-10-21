using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Linq;
public partial class Design_PettyCash_PettyCashRejectApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
    }



    [WebMethod(EnableSession = true)]
    public static string SearchRecords(string Centreid, string fromdate, string todate, string type)
    {
        string typeid = type == "1" ? "Expense" : "Issue";

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
            sb.Append(" amount,DATE_FORMAT(DATE,'%d-%M-%Y ') DATE,createby,TYPE,paymentmode,InvoiceNo,IsApproved,Bank,CardNo,ApprovedBy,DATE_FORMAT(ApprovedDate,'%d-%M-%Y ') ApprovedDate ");
            sb.Append(" FROM petty_cash_ledger ");
            sb.Append(" WHERE IsActive=1 and IsApproved=1 AND TYPE=@typeid AND DATE>=@fromdate AND DATE<=@todate ");

            if (Centreid != string.Empty)
                sb.Append(" AND CentreID IN({0})");
            sb.Append("  ORDER BY  centre,DATE desc");

            if (Centreid != string.Empty)
                bindData = string.Format(sb.ToString(), CentreClause);
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
                da.SelectCommand.Parameters.AddWithValue("@typeid", typeid);
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
            sb.Append("SELECT Case when ifnull(IsApproved,0)=2 then 'aqua' when ifnull(IsApproved,0)=1 then '#90EE90' else 'pink' end as rowColor,id,centre,");
            sb.Append(" centrecode,amount,DATE_FORMAT(DATE,'%d-%M-%Y ') DATE,createby,TYPE,paymentmode,InvoiceNo,IsApproved,CardNo,Bank,ApprovedBy,");
            sb.Append(" DATE_FORMAT(ApprovedDate,'%d-%M-%Y ')ApprovedDate  FROM petty_cash_ledger WHERE TYPE='Expense'  and IsActive=1  ");
            sb.Append(" AND IsApproved=@status");
            sb.Append("  order BY CreatedDate desc");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@status", status)).Tables[0];

            return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string acceptexpense(int ID, string Remark)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            InsertPettyCash objpetty = new InsertPettyCash(Tranx)
            {
                IsApproved = Util.GetInt(1),
                Id = Util.GetInt(ID),
                Remarks = Remark,
                ApprovedBy = UserInfo.LoginName,
                ApprovedById = UserInfo.ID
            };
            objpetty.Update();
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string rejectexpense(int ID, string Cancelremark)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            InsertPettyCash objpetty = new InsertPettyCash(Tranx)
            {
                Id = Util.GetInt(ID),
                IsApproved = Util.GetInt(2),
                CancelByName = UserInfo.LoginName,
                CancelBy = UserInfo.ID,
                CancelRemark = Cancelremark
            };
            objpetty.Update();
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}
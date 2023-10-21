using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_PettyCash_pettyissueslist : System.Web.UI.Page
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
    public static string bindtable(string centerid, string fromdate, string todate, string type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] CentreTags = centerid.Split(',');
            string[] CentreParamNames = CentreTags.Select((s, i) => "@tag" + i).ToArray();
            string CentreClause = string.Join(", ", CentreParamNames);
            string bindData = string.Empty;
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT ");
            if (type != "Excel")
            {
                sb.Append(" Case when ifnull(IsApproved,0)=2 then 'aqua' when ifnull(IsApproved,0)=1 then '#90EE90' else 'pink' end as rowColor ,id,");
            }
            sb.Append(" centre,centrecode,amount,DATE_FORMAT(DATE,'%d-%M-%Y ') DATE,createby,TYPE,paymentmode,IsApproved,CardNo,Bank,ApprovedBy,DATE_FORMAT(ApprovedDate,'%d-%M-%Y ')ApprovedDate,IFNULL(CancelRemarks,'')CancelRemarks,IFNULL(Remarks, '') Remarks  FROM petty_cash_ledger WHERE TYPE='Issue'  and IsActive=1  ");
            if (centerid != "" && centerid != "0" && centerid != "null")
                sb.Append(" AND CentreID IN({0})");
            sb.Append(" AND DATE>=@fromdate ");
            sb.Append(" AND DATE<=@todate ");
            sb.Append("  order BY centre,DATE desc");
            if (centerid != "" && centerid != "0" && centerid != "null")
            {
                bindData = string.Format(sb.ToString(), CentreClause);
            }
            else
            {
                bindData = sb.ToString();
            }
            using (MySqlDataAdapter da = new MySqlDataAdapter(bindData, con))
            {
                if (centerid != "" && centerid != "0" && centerid != "null")
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
                    if (type == "Excel")
                    {
                        HttpContext.Current.Session["dtExport2Excel"] = dt;
                        HttpContext.Current.Session["ReportName"] = "Petty Cash Issue Accept Reject";
                    }
                    return JsonConvert.SerializeObject(dt);
                }
            }
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
    public static string bindtablewithstatus(string status, string Centre, string fromdate, string todate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] CentreTags = Centre.Split(',');
            string[] CentreParamNames = CentreTags.Select((s, i) => "@tag" + i).ToArray();
            string CentreClause = string.Join(", ", CentreParamNames);
            string bindData = string.Empty;

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT Case when ifnull(IsApproved,0)=2 then 'aqua' when ifnull(IsApproved,0)=1 then '#90EE90' else 'pink' end as rowColor,id,centre,centrecode,amount,DATE_FORMAT(DATE,'%d-%M-%Y ') DATE,createby,TYPE,paymentmode,IsApproved,CardNo,Bank,ApprovedBy,DATE_FORMAT(ApprovedDate,'%d-%M-%Y ')ApprovedDate,IFNULL(CancelRemarks,'')CancelRemarks ,IFNULL(Remarks, '') Remarks  FROM petty_cash_ledger WHERE TYPE='Issue' and IsActive=1  ");
            sb.Append(" and IsApproved=@IsApproved");
            if (Centre != "" && Centre != "0" && Centre != "null")
            {
                sb.Append(" AND CentreID IN({0})");
            }
            sb.Append(" AND DATE>=@fromdate ");
            sb.Append(" AND DATE<=@todate ");
            sb.Append("  order BY centre,DATE desc");
            if (Centre != "" && Centre != "0" && Centre != "null")
            {
                bindData = string.Format(sb.ToString(), CentreClause);
            }
            else
            {
                bindData = sb.ToString();
            }
            using (MySqlDataAdapter da = new MySqlDataAdapter(bindData, con))
            {
                if (Centre != "" && Centre != "0" && Centre != "null")
                {
                    for (int i = 0; i < CentreParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(CentreParamNames[i], CentreTags[i]);
                    }
                }
                da.SelectCommand.Parameters.AddWithValue("@IsApproved", status);
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
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string removerow(string id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE petty_cash_ledger set IsActive=0 WHERE id=@id ",
               new MySqlParameter("@id", id));
            return JsonConvert.SerializeObject(new { status = true, response = "Record Removed Successfully" });
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
}
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_PettyCash_CenterPettyAcceptance : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindcenter();
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
    }

    public void bindcenter()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            ddlcenter.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT  CONCAT(centreid,'#',centrecode) centreID,centre FROM centre_master WHERE IsActive=1 AND centreID=@centreID ORDER BY centre",
               new MySqlParameter("@centreID", UserInfo.Centre));
            ddlcenter.DataValueField = "centreID";
            ddlcenter.DataTextField = "centre";
            ddlcenter.DataBind();
            ddlcenter.Items.Insert(0, new ListItem("Select", "0"));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public static DataTable bindData(MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Case when ifnull(IsApproved,0)=2 then 'aqua' when ifnull(IsApproved,0)=1 then '#90EE90' else 'pink' end as rowColor,id,IsApproved,centre,centrecode,amount,DATE_FORMAT(DATE,'%d-%b-%y') DATE,createby,TYPE,paymentmode,Filename,  ");
        sb.Append(" Bank,CardNo,CASE WHEN IsApproved=2 THEN 'Rejected' WHEN isApproved=1 THEN 'Accept' ELSE 'Pending' END STATUS,ApprovedBy,Date_Format(ApprovedDate,'%d-%b-%y') ApprovedDate,InvoiceNo,IFNULL(Remarks,'') Remarks ");
        sb.Append(" FROM petty_cash_ledger WHERE TYPE='issue' AND CentreID=@CentreID and IsActive=1 order BY CreatedDate desc ");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0];
    }

    [WebMethod(EnableSession = true)]
    public static string bindtable(string centerid, string fromdate, string todate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = bindData(con))
            {
                if (dt.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(new { status = true, response = string.Empty, responseDetail = Util.getJson(dt) });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found", responseDetail = string.Empty });
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
    public static string UpdatePettyledger(string id, string val, string region)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            InsertPettyCash objpetty = new InsertPettyCash(Tranx)
            {
                Id = Util.GetInt(id),
                IsApproved = Util.GetInt(val),
                CancelByName = UserInfo.LoginName,
                CancelBy = UserInfo.ID,
                CancelRemark = region
            };
            objpetty.Update();
            Tranx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully", responseDetail = Util.getJson(bindData(con)) });
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            Tranx.Dispose();
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
            sb.Append("SELECT Case when ifnull(IsApproved,0)=2 then 'aqua' when ifnull(IsApproved,0)=1 then '#90EE90' else 'pink' end as rowColor,id,IsApproved,centre,");
            sb.Append(" centrecode,amount,DATE_FORMAT(DATE,'%d, %M, %Y ') DATE,createby,TYPE,paymentmode,Filename , ");
            sb.Append(" Bank,CardNo,CASE WHEN IsApproved=2 THEN 'Rejected' WHEN isApproved=1 THEN 'Accept' ELSE 'Pending' END STATUS,ApprovedBy,");
            sb.Append(" Date_Format(ApprovedDate,'%d-%b-%y') ApprovedDate,InvoiceNo,IFNULL(Remarks,'') Remarks ");
            sb.Append(" FROM petty_cash_ledger WHERE TYPE='issue' and CentreID=@CentreID and IsActive=1  ");
            sb.Append(" AND IsApproved=@status");
            sb.Append("  order BY CreatedDate desc");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@CentreID", UserInfo.Centre),
                  new MySqlParameter("@status", status)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = true, response = string.Empty, responseDetail = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
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
}
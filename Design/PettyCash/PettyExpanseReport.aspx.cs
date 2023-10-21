using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_PettyCash_PettyExpanseReport : System.Web.UI.Page
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
        ddlcenter.DataSource = StockReports.GetDataTable("SELECT  CONCAT(centreid) centreID,centre FROM centre_master where IsActive=1 and centreID=" + UserInfo.Centre + " ORDER BY centre");
        ddlcenter.DataValueField = "centreID";
        ddlcenter.DataTextField = "centre";
        ddlcenter.DataBind();
        ddlcenter.Items.Insert(0, new ListItem("Select", "0"));
        ddlcenter.SelectedIndex = ddlcenter.Items.IndexOf(ddlcenter.Items.FindByValue(UserInfo.Centre.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public static string bindtable(string status, string centerid, string fromdate, string todate)
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
            sb.Append("SELECT Case when ifnull(IsApproved,0)=2 then 'aqua' when ifnull(IsApproved,0)=1 then '#90EE90' else 'pink' end as rowColor,id,centre,IsApproved,centrecode,amount,DATE_FORMAT(DATE,'%d-%b-%y') DATE,createby,TYPE,paymentmode,Filename,IFNULL(CancelRemarks,'')CancelRemarks, ");
            sb.Append("Bank,CardNo,CASE WHEN IsApproved=2 THEN 'Rejected' WHEN isApproved=1 THEN 'Accept' ELSE 'Pending' END STATUS,ApprovedBy,Date_Format(ApprovedDate,'%d-%b-%y') ApprovedDate,InvoiceNo,ExpansesType,Narration,Ifnull(Remarks,'') Remarks   ");
            sb.Append(" FROM petty_cash_ledger WHERE TYPE='Expense'  AND IsActive=1  ");
            if (status != string.Empty)
                sb.Append(" AND IsApproved=@IsApproved ");
            if (centerid != "" && centerid != "0" && centerid != "null")
                sb.Append(" AND CentreID IN({0})");
            sb.Append(" AND DATE>=@fromdate AND DATE<=@todate ");
          
            sb.Append("  order BY CreatedDate desc");
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
                if (status != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@IsApproved", status);

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
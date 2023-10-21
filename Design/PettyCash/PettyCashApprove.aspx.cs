using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;
using System.Web;
public partial class Design_PettyCash_Pettycashapprove : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtentrydatefrom, txtentrydateto);
            Bindexpense();
            calToDate.EndDate = DateTime.Now;
            calFromDate.EndDate = DateTime.Now;
        }
    }

    [WebMethod(EnableSession = true)]
    public static string Bindexpense()
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ID,Typename FROM petty_expansetype where IsActive=1  ORDER BY Typename"));
    }

    [WebMethod(EnableSession = true)]
    public static string SearchRecords(string status, string Centreid, string fromdate, string todate, string ExpType, int IsReport)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {


            string[] ExpTypeTags = ExpType.Split(',');
            string[] ExpTypeParamNames = ExpTypeTags.Select((s, i) => "@tag" + i).ToArray();
            string ExpTypeClause = string.Join(", ", ExpTypeParamNames);

            string bindData = string.Empty;

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT Case when ifnull(pcl.IsApproved,0)=2 then 'aqua' when ifnull(pcl.IsApproved,0)=1 then '#90EE90' else 'pink' end as rowColor,pcl.id,pcl.CentreCode,pcl.Centre,pcl.Amount,");
            sb.Append(" DATE_FORMAT(pcl.DATE,'%d-%b-%Y ') DATE,pcl.createby CreatedBy,pcl.TYPE,pcl.PaymentMode,Replace(pcl.InvoiceNo,',',' ,')InvoiceNo,");
            sb.Append(" DATE_FORMAT(pcl.InviceDate,'%d-%b-%Y ') InvoiceDate,pcl.IsApproved,CASE WHEN pcl.IsApproved=0 THEN 'Pending' WHEN pcl.IsApproved=1 THEN 'Approved' ELSE 'Reject' END `Status` ,");
            sb.Append(" IF(IsApproved=2,'',ifnull(ApprovedBy,''))ApprovedBy,IF(IsApproved=2,'',DATE_FORMAT(ifnull(pcl.ApprovedDate,''),'%d-%b-%Y')) ApprovedDate,");
            sb.Append(" pcl.Bank,IFNULL(CardNo,'')CardNo,pcl.Filename,pcl.ExpansesType,Replace(pcl.Narration,',',' ,')Narration,");
            sb.Append(" IFNULL(pcl.CancelByName,'')RejectedBy,DATE_FORMAT(ifnull(pcl.CancelDateTime,''),'%d-%b-%Y')RejectedDate,IFNULL(pcl.cancelRemarks,'')RejectedReason FROM petty_cash_ledger pcl");
            sb.Append(" LEFT join petty_expansetype pet on pet.ID=pcl.ExpensesID WHERE pcl.IsActive=1 AND pcl.TYPE='Expense'");
            if (status != string.Empty)
                sb.Append(" AND IsApproved=@IsApproved ");

            sb.Append(" AND pcl.DATE>=@fromdate ");
            sb.Append(" AND pcl.DATE<=@todate ");

            if (Centreid != string.Empty)
                sb.Append(" AND CentreID=@CentreID");

            if (ExpType != "0")
                sb.Append(" AND pet.ID IN({0}) ");

            sb.Append("  order BY pcl.centre,pcl.DATE desc");

            if (ExpType != "0")
            {
                bindData = string.Format(sb.ToString(), ExpTypeClause);
            }
            else
            {
                bindData = sb.ToString();
            }
            using (MySqlDataAdapter da = new MySqlDataAdapter(bindData, con))
            {

                if (ExpType != "0")
                {
                    for (int i = 0; i < ExpTypeParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(ExpTypeParamNames[i], ExpTypeTags[i]);
                    }
                }

                da.SelectCommand.Parameters.AddWithValue("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " ", "00:00:00"));
                da.SelectCommand.Parameters.AddWithValue("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59"));
                if (status != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@IsApproved", status);
                if (Centreid != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@CentreID", Centreid);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (IsReport == 0)
                        return JsonConvert.SerializeObject(dt);
                    else
                    {
                        if (dt.Rows.Count > 0)
                        {
                            dt.Columns.Remove("rowColor");
                            dt.Columns.Remove("id");
                            dt.Columns.Remove("FileName");
                            dt.Columns.Remove("IsApproved");
                            HttpContext.Current.Session["dtExport2Excel"] = dt;
                            HttpContext.Current.Session["ReportName"] = "Petty Cash Approve Report";
                            HttpContext.Current.Session["Period"] = string.Concat("From : ", Util.GetDateTime(fromdate).ToString("dd-MMM-yyyy"), " To :", Util.GetDateTime(todate).ToString("dd-MMM-yyyy"));

                            return "1";
                        }
                        else
                        {
                            return "0";
                        }
                    }
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
        MySqlConnection con = Util.GetMySqlCon();
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
    [WebMethod]
    public static string EncryptDocument(string fileName, string filePath)
    {
        return JsonConvert.SerializeObject(new { status = "true", fileName = Common.Encrypt(fileName), filePath = Common.Encrypt(filePath), type = Common.Encrypt("5") });
    }
}
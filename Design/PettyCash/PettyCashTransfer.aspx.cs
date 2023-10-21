using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;

public partial class Design_PettyCash_PettyCashTransfer : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
      if (!Page.IsPostBack)
        {
            lstCentre.Focus();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindCentre(string State)
    {
        if (State == "0")
        {
            return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT CONCAT(cm.Centreid,'#',cm.CentreCode,'#',IFNULL(CONCAT(em.House_No,'-',em.name),'' )) AS Centreid,cm.centre,cm.stateid FROM centre_master cm  LEFT JOIN employee_master em ON em.House_No=cm.Manager_EmpCode and em.Isactive=1 where cm.COCO_FOCO!='FOCO' group by cm.Centreid order by cm.centre"));
        }
        else
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                string[] StateTags = State.Split(',');
                string[] StateParamNames = StateTags.Select((s, i) => "@tag" + i).ToArray();
                string StateClause = string.Join(", ", StateParamNames);

                StringBuilder sb = new StringBuilder();
                sb.Append(" SELECT CONCAT(cm.Centreid,'#',cm.CentreCode,'#',IFNULL(CONCAT(em.House_No,'-',em.name),'' ) ) AS Centreid,cm.centre,cm.stateid ");
                sb.Append("  FROM centre_master cm  LEFT JOIN employee_master em ON em.House_No=cm.Manager_EmpCode ");
                sb.Append(" and em.Isactive=1 WHERE cm.stateid IN({0}) and cm.COCO_FOCO!='FOCO' group by cm.Centreid order by cm.centre");

                using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), StateClause), con))
                {
                    for (int i = 0; i < StateParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(StateParamNames[i], StateTags[i]);
                    }
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
    }

    [WebMethod(EnableSession = true)]
    public static string bindbank()
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT bank_id,bankname FROM f_bank_master"));
    }

    [WebMethod(EnableSession = true)]
    public static string Savepettycash(List<Pettycashtransfer> Allitem)
    {
        MySqlConnection con = con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        InsertPettyCash objpetty = new InsertPettyCash(Tranx);
        string Amount = Util.GetString(Allitem[0].Amount);
        if (Util.GetInt(Allitem[0].Adjustment) == 1)
        {
            Amount = "-" + Amount;
        }
        objpetty.CenterId = Util.GetInt(Allitem[0].Center);
        objpetty.CenterCode = Util.GetString(Allitem[0].CenterCode);
        objpetty.CenterName = Util.GetString(Allitem[0].CenterName);
        objpetty.Amount = Util.GetDecimal(Amount);
        objpetty.ChequeDate = Util.GetString(Allitem[0].ChequeDate);
        objpetty.PaymentDate = Util.GetString(Allitem[0].Date);
        objpetty.Type = Util.GetString("Issue");
        objpetty.PaymentMode = Util.GetString(Allitem[0].PaymentMode);
        objpetty.BankName = Util.GetString(Allitem[0].BankName);
        objpetty.CardNo = Util.GetString(Allitem[0].CardNo);
        objpetty.Remarks = Util.GetString(Allitem[0].Remarks);
        objpetty.Adjustment = Util.GetInt(Allitem[0].Adjustment);
        objpetty.Reciept = Util.GetString(Allitem[0].Reciept);
        try
        {
            int id = objpetty.Insert();
            if (Util.GetString(Allitem[0].Reciept) != string.Empty)
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE pettycash_document SET PettyCashID=@PettyCashID WHERE TempID=@TempID",
                   new MySqlParameter("@PettyCashID", id),
                   new MySqlParameter("@TempID", Util.GetString(Allitem[0].Reciept)));
            }
            Tranx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
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
    public static string bindtable()
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT id,centre,centrecode,amount,DATE_FORMAT(DATE,'%d-%M-%Y ') DATE,createby,TYPE,paymentmode  FROM petty_cash_ledger WHERE IsActive=1 and TYPE='Issue' order BY CreatedDate desc"));
    }

    [WebMethod(EnableSession = true)]
    public static string SearchRecords(string Centreid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string bindData = string.Empty;
            string[] CentreTags = Centreid.Split(',');
            string[] CentreParamNames = CentreTags.Select((s, i) => "@tag" + i).ToArray();
            string CentreClause = string.Join(", ", CentreParamNames);
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT Case when ifnull(IsApproved,0)=2 then 'aqua' when ifnull(IsApproved,0)=1 then '#90EE90' else 'pink' end as rowColor,id,centre,centrecode,");
            sb.Append(" amount,DATE_FORMAT(DATE,'%d-%M-%Y ') DATE,createby,TYPE,paymentmode,InvoiceNo,DATE_FORMAT(InviceDate,'%d-%M-%Y ') InvoiceDate,IsApproved,Bank,CardNo,ApprovedBy,");
            sb.Append(" DATE_FORMAT(ApprovedDate,'%d-%M-%Y ') ApprovedDate,Filename,ExpansesType,Narration FROM petty_cash_ledger ");
            sb.Append(" WHERE IsActive=1 and TYPE='Expense' and IsApproved='0'");
            if (Centreid != string.Empty)
                sb.Append(" AND CentreID IN({0})");
            if (Centreid != string.Empty)
            {
                bindData = string.Format(sb.ToString(), CentreClause);
            }
            else
            {
                bindData = sb.ToString();
            }
            using (MySqlDataAdapter da = new MySqlDataAdapter(bindData, con))
            {
                if (Centreid != string.Empty)
                {
                    for (int i = 0; i < CentreParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(CentreParamNames[i], CentreTags[i]);
                    }
                }
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

    [WebMethod(EnableSession = true)]
    public static string acceptexpense(int ID)
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
                Remarks = string.Empty,
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
    public static string BindBalance(string centerid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ifnull(SUM(amount),0) total,(SELECT ABS(IFNULL(SUM(amount),0)) FROM `petty_cash_ledger` ");
            sb.Append(" WHERE centreid=@centreid AND IsActive=1 AND IsApproved=0 ) pending FROM `petty_cash_ledger`  WHERE centreid=@centreid and IsActive=1 and IsApproved=1 ");
            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@centreid", centerid)).Tables[0]);
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

    public class Pettycashtransfer
    {
        public string Center { get; set; }
        public string Amount { get; set; }
        public string CenterName { get; set; }
        public string Date { get; set; }
        public string CenterCode { get; set; }
        public string PaymentMode { get; set; }
        public string BankName { get; set; }
        public string ChequeDate { get; set; }
        public string CardNo { get; set; }
        public string Remarks { get; set; }
        public int Adjustment { get; set; }
        public string Reciept { get; set; }
    }
}
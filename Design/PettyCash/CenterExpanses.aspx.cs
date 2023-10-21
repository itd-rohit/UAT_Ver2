using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_PettyCash_CenterExpanses : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            calFromDate.StartDate = DateTime.Now;
            calFromDate.EndDate = DateTime.Now;
            calinvoicedate.EndDate = DateTime.Now;
            txtpaymentdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtinvoicedate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                bindcenter(con);
                BankMaster(con);
                bindexpansetype(con);
                spnremarks.InnerText = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT  IFNULL(CONCAT(em.House_No,'-',em.name),'' )AS Centreid  FROM centre_master cm  LEFT JOIN employee_master em ON em.House_No=cm.Manager_EmpCode where cm.IsActive=1 and cm.centreID=@centreID ORDER BY cm.centre",
                   new MySqlParameter("@centreID", UserInfo.Centre)));
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
        txtpaymentdate.Attributes.Add("readOnly", "true");
        txtinvoicedate.Attributes.Add("readOnly", "true");
    }

    public void bindexpansetype(MySqlConnection con)
    {
        ddlexptype.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT id,TypeName FROM petty_expansetype WHERE IsActive=1 order by TypeName").Tables[0];
        ddlexptype.DataValueField = "id";
        ddlexptype.DataTextField = "TypeName";
        ddlexptype.DataBind();
        ddlexptype.Items.Insert(0, new ListItem("Select", "0"));
    }

    public void bindcenter(MySqlConnection con)
    {
        ddlcenter.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT  CONCAT(centreid,'#',centrecode) centreID,centre FROM centre_master where IsActive=1 and centreID=@centreID ORDER BY centre",
            new MySqlParameter("@centreID", UserInfo.Centre));
        ddlcenter.DataValueField = "centreID";
        ddlcenter.DataTextField = "centre";
        ddlcenter.DataBind();
        ddlcenter.Items.Insert(0, new ListItem("Select", "0"));
    }

    public void BankMaster(MySqlConnection con)
    {
        ddlbank.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "  SELECT Bank_id,BankName FROM f_bank_master order by BankName").Tables[0];
        ddlbank.DataValueField = "Bank_id";
        ddlbank.DataTextField = "BankName";
        ddlbank.DataBind();
        ddlbank.Items.Insert(0, new ListItem("", "0"));
    }

    [WebMethod(EnableSession = true)]
    public static string Saveexpanses(List<Paymentdetails> Paymentlist)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, "SELECT IFNULL(SUM(amount),0) total FROM petty_cash_ledger  where IsActive=1 and centreID=@centreID AND (isapproved=1 OR isapproved=0)  ",
                new MySqlParameter("@centreID", UserInfo.Centre)).Tables[0])
            {
                if (Util.GetDecimal(dt.Rows[0]["total"].ToString()) <= 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "you have insufficient funds in your account" });
                }
                if (Util.GetDecimal(dt.Rows[0]["total"].ToString()) < Util.GetDecimal(Paymentlist[0].amount))
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "you have insufficient funds in your account" });
                }

                if (Paymentlist[0].checkdate == string.Empty)
                {
                    Paymentlist[0].checkdate = null;
                }
                string[] centercod = Paymentlist[0].centerid.Split('#');


                string Amount = Util.GetString(Paymentlist[0].amount);

                if (Util.GetInt(Paymentlist[0].Adjustment) == 1)
                {
                    Amount = "+" + Amount;
                }
                else
                {
                    Amount = "-" + Amount;
                }

                InsertPettyCash objpetty = new InsertPettyCash(Tranx)
                {
                    CenterId = Util.GetInt(centercod[0]),
                    CenterCode = Util.GetString(centercod[1]),
                    CenterName = Util.GetString(Paymentlist[0].center),
                    Amount = Util.GetDecimal(Amount),
                    PaymentDate = Util.GetString(Paymentlist[0].paydate),
                    Type = "Expense",
                    PaymentMode = Util.GetString(Paymentlist[0].mode),
                    BankName = Util.GetString(Paymentlist[0].bankname),
                    CardNo = Util.GetString(Paymentlist[0].refnumber),
                    InvoiceNo = Util.GetString(Paymentlist[0].invoiceno),
                    invicedate = Util.GetString(Paymentlist[0].invicedate),
                    exptype = Util.GetString(Paymentlist[0].exptype),
                    exptypeID = Util.GetInt(Paymentlist[0].exptypeID),
                    narration = Util.GetString(Paymentlist[0].narration),
                    Remarks = Util.GetString(Paymentlist[0].remarks),
                    Adjustment = Util.GetInt(Paymentlist[0].Adjustment),
                    Reciept = Util.GetString(Paymentlist[0].Reciept)
                };
                int id = objpetty.Insert();

                if (Util.GetString(Paymentlist[0].Reciept) != string.Empty)
                {
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE pettycash_document SET PettyCashID=@PettyCashID WHERE TempID=@TempID",
                       new MySqlParameter("@PettyCashID", id),
                       new MySqlParameter("@TempID", Util.GetString(Paymentlist[0].Reciept)));
                }
                Tranx.Commit();
                return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
            }
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = true, response = "Error" });
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public static DataTable bindData(MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT id,centre,centrecode,amount,DATE_FORMAT(DATE,'%d, %M, %Y ') DATE,createby,TYPE,paymentmode,Filename ");
        sb.Append(" FROM petty_cash_ledger WHERE TYPE='Expense' and CreatedById=@CreatedById and IsActive=1 order BY CreatedDate desc ");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@CreatedById", UserInfo.ID)).Tables[0];
    }

    [WebMethod(EnableSession = true)]
    public static string bindtable()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = bindData(con))
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

    [WebMethod]
    public static string BindBalance()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT IFNULL(SUM(amount),0) total,(SELECT ABS(IFNULL(SUM(amount),0)) FROM `petty_cash_ledger` ");
            sb.Append("  WHERE centreid=@centreid AND IsActive=1 AND IsApproved=0 ) pending FROM `petty_cash_ledger` ");
            sb.Append(" WHERE centreid=@centreid and IsActive=1 and IsApproved=1 ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@centreid", UserInfo.Centre)).Tables[0])
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
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public class Paymentdetails
    {
        public string centerid { get; set; }
        public string center { get; set; }
        public string amount { get; set; }
        public string paydate { get; set; }
        public string mode { get; set; }
        public string bankname { get; set; }
        public string refnumber { get; set; }
        public string checkdate { get; set; }
        public string invoiceno { get; set; }
        public string invicedate { get; set; }
        public string exptype { get; set; }
        public int exptypeID { get; set; }
        public string narration { get; set; }
        public string remarks { get; set; }
        public int Adjustment { get; set; }
        public string Reciept { get; set; }
    }
}
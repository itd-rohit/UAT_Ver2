using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Lab_UpdatePanelShare : System.Web.UI.Page
{
    public static string labno = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtCardDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindBank();
            bindpaymentmode();
        }
    }

    private void bindBank()
    {
        ddlBank.DataSource = StockReports.GetDataTable(" SELECT BankName,Bank_ID FROM `f_bank_master` ");
        ddlBank.DataTextField = "BankName";
        ddlBank.DataValueField = "BankName";
        ddlBank.DataBind();
        ddlBank.Items.Insert(0, new ListItem("Select Bank", ""));
    }

    private void bindpaymentmode()
    {
        ddlPaymentMode.DataSource = StockReports.GetDataTable("SELECT paymentmodeid,paymentmode FROM `paymentmode_master` where Active='1' AND  paymentmodeid<>4 ");
        ddlPaymentMode.DataValueField = "paymentmodeid";
        ddlPaymentMode.DataTextField = "paymentmode";
        ddlPaymentMode.DataBind();
        ddlPaymentMode.Items.Insert(0, new ListItem("Select Payment Mode", ""));
    }

    [WebMethod(EnableSession = true)]
    public static string searchdata(string LabNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            Panel_Share ps = new Panel_Share();
            JSONResponse IPS = JsonConvert.DeserializeObject<JSONResponse>(ps.InsertPanel_Share(LabNo, tnx, con));
            if (IPS.status == false)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = IPS.response });
            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "No Record Found..!" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveData(GetData LTData)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (Util.GetString(LTData.VisitNo).Trim() == "")
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Visit No should not be null...!" });
            }
            // if (Util.GetString(LTData.TypeToPerform).Trim() == "2")
            if (Util.GetString(LTData.PaymentModeID).Trim() != "1")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" update f_receipt set ");
                sb.Append(" PaymentMode=@PaymentMode, PaymentModeID=@PaymentModeID , BankName=@BankName , ");
                sb.Append(" CardNo=@CardNo , CardDate=@CardDate , Narration=@Naration , UpdateID=@UpdateID , ");
                sb.Append(" UpdateName=@UpdateName , Updatedate=now() , ipaddress=@ipaddress  ");
                sb.Append(" where LedgerTransactionNo=@LedgerTransactionNo and ID=@ReceiptID ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@PaymentMode", Util.GetString(LTData.PaymentMode).Trim()),
                    new MySqlParameter("@PaymentModeID", Util.GetInt(LTData.PaymentModeID)),
                    new MySqlParameter("@BankName", Util.GetString(LTData.Bank).Trim()),
                    new MySqlParameter("@CardNo", Util.GetString(LTData.CardNo).Trim()),
                    new MySqlParameter("@CardDate", Convert.ToDateTime(Util.GetDateTime(LTData.CardDate)).ToString("yyyy-MM-dd HH:mm:ss")),
                    new MySqlParameter("@Naration", Util.GetString(LTData.Naration).Trim()),
                    new MySqlParameter("@UpdateID", Util.GetInt(UserInfo.ID)),
                    new MySqlParameter("@UpdateName", Util.GetString(UserInfo.LoginName)),
                    new MySqlParameter("@ipaddress", StockReports.getip()),
                    new MySqlParameter("@LedgerTransactionNo", Util.GetString(LTData.VisitNo).Trim()),
                    new MySqlParameter("@ReceiptID", Util.GetString(LTData.ReceiptID).Trim()));
            }
            else
            {
                if (Util.GetString(LTData.PaymentModeID).Trim() == "1")// For Cash To Credit
                {
                    StringBuilder sbLT = new StringBuilder();
                    sbLT.Append(" Update f_ledgertransaction set IsCredit='1',");
                    sbLT.Append(" UpdateID=@UpdateID , UpdateName=@UpdateName , Updatedate=now() ,ipaddress=@ipaddress ");
                    sbLT.Append(" where LedgerTransactionNo=@LedgerTransactionNo");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbLT.ToString(),
                        new MySqlParameter("@UpdateID", Util.GetInt(UserInfo.ID)),
                        new MySqlParameter("@UpdateName", Util.GetString(UserInfo.LoginName)),
                        new MySqlParameter("@ipaddress", StockReports.getip()),
                        new MySqlParameter("@LedgerTransactionNo", Util.GetString(LTData.VisitNo).Trim()));

                    StringBuilder sbRc = new StringBuilder();
                    sbRc.Append(" Update f_receipt set LedgerNoCr='HOSP0005',  ");
                    sbRc.Append(" Narration=@Naration , UpdateID=@UpdateID , UpdateName=@UpdateName , Updatedate=now() , ");
                    sbRc.Append(" ipaddress=@ipaddress  ");
                    sbRc.Append(" where LedgerTransactionNo=@LedgerTransactionNo and LedgerNoCr='OPD003' and IsCancel=0 ");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbRc.ToString(),
                        new MySqlParameter("@Naration", "Cash To Credit" + Util.GetString(LTData.Naration).Trim()),
                        new MySqlParameter("@UpdateID", Util.GetInt(UserInfo.ID)),
                        new MySqlParameter("@UpdateName", Util.GetString(UserInfo.LoginName)),
                        new MySqlParameter("@ipaddress", StockReports.getip()),
                        new MySqlParameter("@LedgerTransactionNo", Util.GetString(LTData.VisitNo).Trim()));
                }
                else if (Util.GetString(LTData.PaymentModeID).Trim() == "4")// For Credit To Cash
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " Update f_ledgertransaction SET IsCredit=0 where LedgerTransactionNo=@LedgerTransactionNo ",
                        new MySqlParameter("@LedgerTransactionNo", Util.GetString(LTData.VisitNo).Trim()));
                }
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, ID = Common.Encrypt(Util.GetString(LTData.VisitNo)) });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error Occured...!" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string getReceiptData(string VisitNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT ID,ReceiptNo,Amount,PaymentMode,PaymentModeID  FROM `f_receipt` WHERE `LedgerTransactionNo`=@LedgerTransactionNo AND IsCancel=0 ",
                new MySqlParameter("@LedgerTransactionNo", VisitNo.Trim())).Tables[0])
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "No Record" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public class GetData
    {
        public string PatientID { get; set; }
        public string CentreID { get; set; }
        public string LedgerTransactionID { get; set; }
        public string VisitNo { get; set; }
        public string PaymentMode { get; set; }
        public string PaymentModeID { get; set; }
        public string Bank { get; set; }
        public string CardNo { get; set; }
        public DateTime CardDate { get; set; }
        public string Naration { get; set; }
        public string ReceiptID { get; set; }
        public string TypeToPerform { get; set; }
    }
}
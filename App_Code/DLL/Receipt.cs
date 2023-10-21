using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.ComponentModel;
/// <summary>
/// Summary description for Receipt
/// </summary>
public class Receipt
{
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;
	public Receipt()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
	}
    public Receipt(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    public string LedgerNoCr { get; set; }//OPD003
    public int LedgerTransactionID { get; set; }
    public string LedgerTransactionNo { get; set; }
    public string PayBy { get; set; }
    public string PaymentMode { get; set; }
    public int PaymentModeID { get; set; }
    public decimal Amount { get; set; }
    public string BankName { get; set; }
    public string CardNo { get; set; }
    public DateTime CardDate { get; set; }
    public int CreatedByID { get; set; }
    public string CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; }
    public string Patient_ID { get; set; }
    public int IsCancel { get; set; }
    public string Narration { get; set; }
    public int CentreID { get; set; }
    public string ipaddress { get; set; }
    public string PayTmOtp { get; set; }
    public string PayTmMobile { get; set; }
    public string TIDNumber { get; set; }
    public int Panel_ID { get; set; }
    public string ReceiptNo_Adv { get; set; }
    public int IsPUPAdvance { get; set; }    
    public int bulkSettleID { get; set; }
    public decimal S_Amount { get; set; }
    public int S_CountryID { get; set; }
    public string S_Currency { get; set; }
    public string S_Notation { get; set; }
    public decimal C_Factor { get; set; }
    [DefaultValue(0.00)]
    public decimal Currency_RoundOff { get; set; }
    public byte CurrencyRoundDigit { get; set; }
    [DefaultValue(0)]
    public sbyte Refund { get; set; }
    public int Converson_ID { get; set; }
    public string refundAgainstReceiptNo { get; set; }
    public int IsAdvance { get; set; }
    public int BulkSettlementID { get; set; }
    [DefaultValue(0.00)]
    public decimal TDSAmount { get; set; }
    [DefaultValue(0.00)]
    public decimal WriteOffAmount { get; set; }
    public string SettleAgainstReceiptNo { get; set; }
    public string transactionid { get; set; }
    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Receipt");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter() { ParameterName = "@Receipt_No", MySqlDbType = MySqlDbType.VarChar, Size = 50, Direction = ParameterDirection.Output };
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans) { CommandType = CommandType.StoredProcedure };
            cmd.Parameters.Add(new MySqlParameter("@LedgerNoCr", Util.GetString(LedgerNoCr)));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionID", Util.GetInt(LedgerTransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionNo", Util.GetString(LedgerTransactionNo).ToUpper()));
            cmd.Parameters.Add(new MySqlParameter("@PayBy", Util.GetString(PayBy)));
            cmd.Parameters.Add(new MySqlParameter("@PaymentMode", Util.GetString(PaymentMode)));
            cmd.Parameters.Add(new MySqlParameter("@PaymentModeID", Util.GetInt(PaymentModeID)));
            cmd.Parameters.Add(new MySqlParameter("@Amount", Util.GetDecimal(Amount)));
            cmd.Parameters.Add(new MySqlParameter("@BankName", Util.GetString(BankName)));
            cmd.Parameters.Add(new MySqlParameter("@CardNo", Util.GetString(CardNo)));
            cmd.Parameters.Add(new MySqlParameter("@CardDate", Util.GetDateTime(CardDate)));
            cmd.Parameters.Add(new MySqlParameter("@CreatedByID", Util.GetInt(CreatedByID)));
            cmd.Parameters.Add(new MySqlParameter("@CreatedBy", Util.GetString(CreatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@CreatedDate", Util.GetDateTime(CreatedDate)));
            cmd.Parameters.Add(new MySqlParameter("@Patient_ID", Util.GetString(Patient_ID)));
            cmd.Parameters.Add(new MySqlParameter("@Narration", Util.GetString(Narration)));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", Util.GetInt(CentreID)));            
            cmd.Parameters.Add(new MySqlParameter("@ipaddress", Util.GetString(StockReports.getip())));
            cmd.Parameters.Add(new MySqlParameter("@TIDNumber", TIDNumber));
            cmd.Parameters.Add(new MySqlParameter("@Panel_ID", Panel_ID));
            cmd.Parameters.Add(new MySqlParameter("@ReceiptNo_Adv", ReceiptNo_Adv));
            cmd.Parameters.Add(new MySqlParameter("@IsPUPAdvance", IsPUPAdvance));           
            cmd.Parameters.Add(new MySqlParameter("@bulkSettleID", Util.GetInt(bulkSettleID)));
            cmd.Parameters.Add(new MySqlParameter("@S_Amount", Util.GetDecimal(S_Amount)));
            cmd.Parameters.Add(new MySqlParameter("@S_CountryID", Util.GetInt(S_CountryID)));
            cmd.Parameters.Add(new MySqlParameter("@S_Currency", Util.GetString(S_Currency)));
            cmd.Parameters.Add(new MySqlParameter("@S_Notation", Util.GetString(S_Notation)));
            cmd.Parameters.Add(new MySqlParameter("@C_Factor", Util.GetDecimal(C_Factor)));
            cmd.Parameters.Add(new MySqlParameter("@Currency_RoundOff", Util.GetDecimal(Currency_RoundOff)));
            cmd.Parameters.Add(new MySqlParameter("@CurrencyRoundDigit", Util.GetByte(CurrencyRoundDigit)));
            cmd.Parameters.Add(new MySqlParameter("@Converson_ID", Util.GetInt(Converson_ID)));
            cmd.Parameters.Add(new MySqlParameter("@refundAgainstReceiptNo", Util.GetString(refundAgainstReceiptNo)));  
            cmd.Parameters.Add(new MySqlParameter("@IsAdvance", IsAdvance));
            cmd.Parameters.Add(new MySqlParameter("@BulkSettlementID", Util.GetInt(BulkSettlementID)));
            cmd.Parameters.Add(new MySqlParameter("@SettleAgainstReceiptNo", Util.GetString(SettleAgainstReceiptNo)));
            cmd.Parameters.Add(new MySqlParameter("@transactionid", Util.GetString(transactionid)));
            cmd.Parameters.Add(paramTnxID);
            string rcno = cmd.ExecuteScalar().ToString();
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return rcno;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            throw (ex);
        }
    }
   
}
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for CCAvPaymentResponse
/// </summary>
public class CCAvPaymentResponse
{
    public string SavePaymentResponse(string PanelID, string dtEntry, string AdvAmt, string PaymentMode, string typeOfPayment, string UserName, string UserId, string Remark, string BankName, string CentreId)
    {

        if (AdvAmt.Trim() == "")
        {
            return "";
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string PaymentType = Util.GetString(PaymentMode);
            string Remarks = Util.GetString(Remark);
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO invoicemaster_onaccount(ReceivedAmt,EntryDate,EntryBy,Panel_id,PaymentMode ,`Type`,`Bank` ");
            sb.Append(" ,ReceiptNo,Remarks , EntryByName, receiveddate, CreditNote) ");
            sb.Append(" VALUES (" + Util.GetDouble(AdvAmt) + ",now() ,'" + UserId + "','" + PanelID + "', '" + PaymentType.Trim() + "' ");
            sb.Append(" , 'ON ACCOUNT','" + BankName + "' ");
            sb.Append(",get_receiptno_invoice(0,0,now()), '" + Remarks + "', '" + UserName + "',now() ," + Util.GetInt(typeOfPayment) + ") ");
            if (Util.GetString(UserId) == "EMP001")
            {
                // System.IO.File.WriteAllText("C:\\opd22.txt", sb.ToString());
            }
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());

            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();

            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            return "Error Occured";
        }


    }
}
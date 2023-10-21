using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for OPD_Advance
/// </summary>
public class OPD_Advance
{
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public OPD_Advance()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public OPD_Advance(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    public int ID { get; set; }
    public string Patient_ID { get; set; }
    public int LedgerTransactionID { get; set; }
    public string LedgerTransactionNo { get; set; }
    public decimal AdvanceAmount { get; set; }
    public string CreatedBy { get; set; }
    public int CreatedByID { get; set; }
    public int CentreID { get; set; }
    public int Panel_ID { get; set; }
    public string ReceiptNo { get; set; }
    public int PaymentModeID { get; set; }
    public string PaymentMode { get; set; }
    public DateTime CreatedDate { get; set; }
    public string AdvanceType { get; set; }
    public int Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_OPD_Advance");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter() { ParameterName = "@ReturnLedgerTransactionNo", MySqlDbType = MySqlDbType.VarChar, Size = 30, Direction = ParameterDirection.Output };
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans) { CommandType = CommandType.StoredProcedure };

            cmd.Parameters.Add(new MySqlParameter("@vPatient_ID", Patient_ID));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionID", LedgerTransactionID));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionNo", LedgerTransactionNo));
            cmd.Parameters.Add(new MySqlParameter("@vReceiptNo", ReceiptNo));
            cmd.Parameters.Add(new MySqlParameter("@vAdvanceAmount", AdvanceAmount));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedByID", CreatedByID));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vPanel_ID", Panel_ID));
            cmd.Parameters.Add(new MySqlParameter("@vPaymentModeID", PaymentModeID));
            cmd.Parameters.Add(new MySqlParameter("@vPaymentMode", PaymentMode));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedDate", CreatedDate));
            cmd.Parameters.Add(new MySqlParameter("@vAdvanceType", AdvanceType));
            cmd.Parameters.Add(paramTnxID);
            ID = Util.GetInt(cmd.ExecuteScalar().ToString());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return ID;
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
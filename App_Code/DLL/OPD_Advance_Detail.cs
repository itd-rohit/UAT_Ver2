using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for OPD_Advance_Detail
/// </summary>
public class OPD_Advance_Detail
{
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public OPD_Advance_Detail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public OPD_Advance_Detail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    public int ID { get; set; }
    public string Patient_ID { get; set; }
    public int LedgerTransactionID { get; set; }
    public string LedgerTransactionNo { get; set; }
    public decimal PaidAmount { get; set; }
    public string CreatedBy { get; set; }
    public int CreatedByID { get; set; }
    public int CentreID { get; set; }
    public int Panel_ID { get; set; }
    public string ReceiptNo { get; set; }
    public int AdvanceID { get; set; }
    public string ReceiptNoAgainst { get; set; }
    private DateTime CreatedDate { get; set; }
    public string AdvanceType { get; set; }
    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_OPD_Advance_Detail");
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
            cmd.Parameters.Add(new MySqlParameter("@vPaidAmount", PaidAmount));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedByID", CreatedByID));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vPanel_ID", Panel_ID));
            cmd.Parameters.Add(new MySqlParameter("@vReceiptNo", ReceiptNo));
            cmd.Parameters.Add(new MySqlParameter("@vAdvanceID", AdvanceID));
            cmd.Parameters.Add(new MySqlParameter("@vReceiptNoAgainst", ReceiptNoAgainst));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedDate", CreatedDate));
            cmd.Parameters.Add(new MySqlParameter("@vAdvanceType", AdvanceType));
            cmd.Parameters.Add(paramTnxID);
            LedgerTransactionNo = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return LedgerTransactionNo.ToString();
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
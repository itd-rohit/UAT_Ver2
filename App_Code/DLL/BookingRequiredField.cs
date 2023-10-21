using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for BookingRequiredField
/// </summary>
public class BookingRequiredField
{

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public BookingRequiredField()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public BookingRequiredField(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    public string FieldID { get; set; }
    public string FieldName { get; set; }
    public string FieldValue { get; set; }
    public string Unit { get; set; }
    public int LedgerTransactionID { get; set; }
    public string LedgerTransactionNo { get; set; }


    public int Insert()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append(" insert into patient_labinvestigation_opd_requiredField  (FieldID,FieldName,FieldValue,Unit,LedgerTransactionID,LedgerTransactionNo)");
            objSQL.Append("VALUES(@FieldID,@FieldName,@FieldValue,@Unit,@LedgerTransactionID,@LedgerTransactionNo)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
               new MySqlParameter("@FieldID", Util.GetInt(FieldID)), new MySqlParameter("@FieldName", Util.GetString(FieldName)),
               new MySqlParameter("@FieldValue", Util.GetString(FieldValue)), new MySqlParameter("@Unit", Util.GetString(Unit)),
               new MySqlParameter("@LedgerTransactionID", LedgerTransactionID), new MySqlParameter("@LedgerTransactionNo", Util.GetString(LedgerTransactionNo)));
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return RowAffected;
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
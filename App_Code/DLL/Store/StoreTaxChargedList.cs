using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for StoreTaxChargedList
/// </summary>
public class StoreTaxChargedList
{
	 MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public StoreTaxChargedList()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
       
    }
    public StoreTaxChargedList(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }


    public int LedgerTransactionID { get; set; }
    public string LedgerTransactionNo { get; set; }
    public int StockID { get; set; }
    public int ItemID { get; set; }
    public string TaxName { get; set; }
    public float Percentage { get; set; }
    public float TaxAmt { get; set; }
    public string BatchNumber { get; set; }

    public string Insert()
    {
        try
        {
            string saveditemid = "";
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("store_taxchargedlist");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@ID";

            paramTnxID.MySqlDbType = MySqlDbType.Int32;
            paramTnxID.Size = 15;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionID", Util.GetInt(LedgerTransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionNo", Util.GetString(LedgerTransactionNo)));
            cmd.Parameters.Add(new MySqlParameter("@StockID", Util.GetInt(StockID)));
            cmd.Parameters.Add(new MySqlParameter("@ItemID", Util.GetInt(ItemID)));
            cmd.Parameters.Add(new MySqlParameter("@TaxName", Util.GetString(TaxName).ToUpper()));
            cmd.Parameters.Add(new MySqlParameter("@Percentage", Util.GetFloat(Percentage)));
            cmd.Parameters.Add(new MySqlParameter("@TaxAmt", Util.GetFloat(TaxAmt)));
            cmd.Parameters.Add(new MySqlParameter("@EntryBy", Util.GetInt(UserInfo.ID)));
           




            cmd.Parameters.Add(paramTnxID);
            saveditemid = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return saveditemid.ToString();


        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            // Util.WriteLog(ex);
            throw (ex);
        }
    }

    
}
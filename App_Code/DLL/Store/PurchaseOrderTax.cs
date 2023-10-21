using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for PurchaseOrderTax
/// </summary>
public class PurchaseOrderTax
{
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

	#region Overloaded Constructor
    public PurchaseOrderTax()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;        
	}
    public PurchaseOrderTax(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property

    public int PurchaseOrderID { get; set; }
    public string PurchaseOrderNo { get; set; }
    public int ItemID { get; set; }
    public string TaxName { get; set; }
    public decimal Percentage { get; set; }
    public decimal TaxAmt { get; set; }
    public string CreatedBy { get; set; }
    public int CreatedByID { get; set; }
    public int PurchaseOrderTaxID { get; set; }
    #endregion


    public int Insert()
    {
        try
        {

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("store_Insert_PurchaseOrder_Tax");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@PurchaseOrderTaxID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;
            paramTnxID.Direction = ParameterDirection.InputOutput;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@PurchaseOrderID", Util.GetInt(PurchaseOrderID)));
            cmd.Parameters.Add(new MySqlParameter("@PurchaseOrderNo", Util.GetString(PurchaseOrderNo)));
            cmd.Parameters.Add(new MySqlParameter("@ItemID", Util.GetInt(ItemID)));
            cmd.Parameters.Add(new MySqlParameter("@TaxName", Util.GetString(TaxName)));
            cmd.Parameters.Add(new MySqlParameter("@Percentage", Util.GetDecimal(Percentage)));
            cmd.Parameters.Add(new MySqlParameter("@TaxAmt", Util.GetDecimal(TaxAmt)));
            cmd.Parameters.Add(new MySqlParameter("@CreatedBy", Util.GetString(CreatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@CreatedByID", Util.GetInt(CreatedByID)));
            PurchaseOrderTaxID = Util.GetInt(cmd.ExecuteScalar().ToString());


            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return PurchaseOrderTaxID;
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
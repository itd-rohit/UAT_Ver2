using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary Purpose for PurchaseOrderDetail
/// </summary>
public class PurchaseOrderDetail
{
   
    
    
   
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

     #endregion
    #region Overloaded Constructor
    public PurchaseOrderDetail()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;        
	}
    public PurchaseOrderDetail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property

    public int PurchaseOrderID { get; set; }
    public string PurchaseOrderNo { get; set; }
    public int ItemID { get; set; }
    public string ItemName { get; set; }
    public int ManufactureID { get; set; }
    public string ManufactureName { get; set; }
    public string CatalogNo { get; set; }
    public int MachineID { get; set; }
    public string MachineName { get; set; }
    public int MajorUnitId { get; set; }
    public string MajorUnitName { get; set; }
    public string PackSize { get; set; }
    public decimal OrderedQty { get; set; }
    public decimal CheckedQty { get; set; }
    public decimal ApprovedQty { get; set; }
    public decimal GRNQty { get; set; }
    public decimal Rate { get; set; }

    public decimal TaxAmount { get; set; }
    public decimal DiscountAmount { get; set; }
    public decimal DiscountPercentage { get; set; }
    public decimal NetAmount { get; set; }
    public decimal UnitPrice { get; set; }
    public int IsFree { get; set; }
    public int PurchaseOrderDetailID { get; set; }
    #endregion

    public int Insert()
    
    {
        try
        {
           
             StringBuilder objSQL = new StringBuilder();
            objSQL.Append("store_Insert_PurchaseOrder_Detail");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@PurchaseOrderDetailID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;
            paramTnxID.Direction = ParameterDirection.InputOutput;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@PurchaseOrderID", Util.GetInt(PurchaseOrderID)));
            cmd.Parameters.Add(new MySqlParameter("@PurchaseOrderNo", Util.GetString(PurchaseOrderNo)));
            cmd.Parameters.Add(new MySqlParameter("@ItemID", Util.GetInt(ItemID)));
            cmd.Parameters.Add(new MySqlParameter("@ItemName", Util.GetString(ItemName)));
            cmd.Parameters.Add(new MySqlParameter("@ManufactureID", Util.GetInt(ManufactureID)));
            cmd.Parameters.Add(new MySqlParameter("@ManufactureName", Util.GetString(ManufactureName)));

            cmd.Parameters.Add(new MySqlParameter("@CatalogNo", Util.GetString(CatalogNo)));
            cmd.Parameters.Add(new MySqlParameter("@MachineID", Util.GetInt(MachineID)));
            cmd.Parameters.Add(new MySqlParameter("@MachineName", Util.GetString(MachineName)));
            cmd.Parameters.Add(new MySqlParameter("@MajorUnitId", Util.GetInt(MajorUnitId)));
            cmd.Parameters.Add(new MySqlParameter("@MajorUnitName", Util.GetString(MajorUnitName)));

            cmd.Parameters.Add(new MySqlParameter("@PackSize", Util.GetString(PackSize)));
            cmd.Parameters.Add(new MySqlParameter("@OrderedQty", Util.GetDecimal(OrderedQty)));
            cmd.Parameters.Add(new MySqlParameter("@CheckedQty", Util.GetDecimal(CheckedQty)));

            cmd.Parameters.Add(new MySqlParameter("@ApprovedQty", Util.GetDecimal(ApprovedQty)));
            cmd.Parameters.Add(new MySqlParameter("@GRNQty", Util.GetDecimal(GRNQty)));
            cmd.Parameters.Add(new MySqlParameter("@Rate", Util.GetDecimal(Rate)));
            cmd.Parameters.Add(new MySqlParameter("@TaxAmount", Util.GetDecimal(TaxAmount)));
            cmd.Parameters.Add(new MySqlParameter("@DiscountAmount", Util.GetDecimal(DiscountAmount)));
            cmd.Parameters.Add(new MySqlParameter("@DiscountPercentage", Util.GetDecimal(DiscountPercentage)));

            cmd.Parameters.Add(new MySqlParameter("@NetAmount", Util.GetDecimal(NetAmount)));
            cmd.Parameters.Add(new MySqlParameter("@UnitPrice", Util.GetDecimal(UnitPrice)));

            cmd.Parameters.Add(new MySqlParameter("@IsFree", Util.GetInt(IsFree)));
            PurchaseOrderDetailID = Util.GetInt( cmd.ExecuteScalar().ToString());


            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return PurchaseOrderDetailID;
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

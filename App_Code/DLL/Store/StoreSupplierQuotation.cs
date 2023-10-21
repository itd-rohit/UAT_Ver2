using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
/// <summary>
/// Summary description for StoreSupplierQuotation
/// </summary>
public class StoreSupplierQuotation
{
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public StoreSupplierQuotation()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
       
    }
    public StoreSupplierQuotation(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }




    public string Qutationno { get; set; }
    public string Quotationrefno { get; set; }
    public string VendorId { get; set; }
    public string VendorName { get; set; }
    public string VendorAddress { get; set; }
    public string VendorStateId { get; set; }
    public string VednorStateName { get; set; }
    public string VednorStateGstnno { get; set; }
    public string EntryDateFrom { get; set; }
    public string EntryDateTo { get; set; }
    public string DeliveryStateID { get; set; }
    public string DeliveryStateName { get; set; }
    public string DeliveryCentreID { get; set; }
    public string DeliveryCentreName { get; set; }
    public string DeliveryLocationID { get; set; }
    public string DeliveryLocationName { get; set; }
    public string ItemCategoryID { get; set; }

    public string ItemCategoryName { get; set; }
    public string ItemID { get; set; }
    public string ItemName { get; set; }
    public string HSNCode { get; set; }
    public string ManufactureID { get; set; }
    public string ManufactureName { get; set; }
    public string MachineID { get; set; }
    public string MachineName { get; set; }



    public float Rate { get; set; }
    public float Qty { get; set; }
    public float DiscountPer { get; set; }
    public float IGSTPer { get; set; }
    public float SGSTPer { get; set; }
    public float CGSTPer { get; set; }
    public float ConversionFactor { get; set; }
    public string PurchasedUnit { get; set; }
    public string ConsumptionUnit { get; set; }
    public float BuyPrice { get; set; }
    public float FreeQty { get; set; }
    public float DiscountAmt { get; set; }
    public float GSTAmount { get; set; }
    public float FinalPrice { get; set; }
   
    public string IsActive { get; set; }

    public string Insert()
    {
        try
        {
            string saveditemid = "";
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("store_vendorqutation");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@LastID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 15;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@Qutationno", Util.GetString(Qutationno)));
            cmd.Parameters.Add(new MySqlParameter("@Quotationrefno", Util.GetString(Quotationrefno)));
            cmd.Parameters.Add(new MySqlParameter("@VendorId", Util.GetString(VendorId)));
            cmd.Parameters.Add(new MySqlParameter("@VendorName", Util.GetString(VendorName)));
            cmd.Parameters.Add(new MySqlParameter("@VendorAddress", Util.GetString(VendorAddress)));
            cmd.Parameters.Add(new MySqlParameter("@VendorStateId", Util.GetString(VendorStateId)));
            cmd.Parameters.Add(new MySqlParameter("@VednorStateName", Util.GetString(VednorStateName)));
            cmd.Parameters.Add(new MySqlParameter("@VednorStateGstnno", Util.GetString(VednorStateGstnno)));
            cmd.Parameters.Add(new MySqlParameter("@EntryDateFrom", Util.GetDateTime(EntryDateFrom)));
            cmd.Parameters.Add(new MySqlParameter("@EntryDateTo", Util.GetDateTime(EntryDateTo)));
            cmd.Parameters.Add(new MySqlParameter("@DeliveryStateID", Util.GetString(DeliveryStateID)));
            cmd.Parameters.Add(new MySqlParameter("@DeliveryStateName", Util.GetString(DeliveryStateName)));
            cmd.Parameters.Add(new MySqlParameter("@DeliveryCentreID", Util.GetString(DeliveryCentreID)));
            cmd.Parameters.Add(new MySqlParameter("@DeliveryCentreName", Util.GetString(DeliveryCentreName)));

            cmd.Parameters.Add(new MySqlParameter("@DeliveryLocationID", Util.GetString(DeliveryLocationID)));
            cmd.Parameters.Add(new MySqlParameter("@DeliveryLocationName", Util.GetString(DeliveryLocationName)));

            cmd.Parameters.Add(new MySqlParameter("@ItemCategoryID", Util.GetString(ItemCategoryID)));
            cmd.Parameters.Add(new MySqlParameter("@ItemCategoryName", Util.GetString(ItemCategoryName)));
            cmd.Parameters.Add(new MySqlParameter("@ItemID", Util.GetString(ItemID)));
            cmd.Parameters.Add(new MySqlParameter("@ItemName", Util.GetString(ItemName)));
            cmd.Parameters.Add(new MySqlParameter("@HSNCode", Util.GetString(HSNCode)));
            cmd.Parameters.Add(new MySqlParameter("@ManufactureID", Util.GetString(ManufactureID)));
            cmd.Parameters.Add(new MySqlParameter("@ManufactureName", Util.GetString(ManufactureName)));
            cmd.Parameters.Add(new MySqlParameter("@MachineID", Util.GetString(MachineID)));
            cmd.Parameters.Add(new MySqlParameter("@MachineName", Util.GetString(MachineName)));
            cmd.Parameters.Add(new MySqlParameter("@Rate", Util.GetFloat(Rate)));
            cmd.Parameters.Add(new MySqlParameter("@Qty", Util.GetFloat(Qty)));
            cmd.Parameters.Add(new MySqlParameter("@DiscountPer", Util.GetFloat(DiscountPer)));
            cmd.Parameters.Add(new MySqlParameter("@IGSTPer", Util.GetFloat(IGSTPer)));
            cmd.Parameters.Add(new MySqlParameter("@SGSTPer", Util.GetFloat(SGSTPer)));
            cmd.Parameters.Add(new MySqlParameter("@CGSTPer", Util.GetFloat(CGSTPer)));
            cmd.Parameters.Add(new MySqlParameter("@ConversionFactor", Util.GetFloat(ConversionFactor)));
            cmd.Parameters.Add(new MySqlParameter("@PurchasedUnit", Util.GetString(PurchasedUnit)));
            cmd.Parameters.Add(new MySqlParameter("@ConsumptionUnit", Util.GetString(ConsumptionUnit)));
            cmd.Parameters.Add(new MySqlParameter("@BuyPrice", Util.GetFloat(BuyPrice)));
            cmd.Parameters.Add(new MySqlParameter("@FreeQty", Util.GetFloat(FreeQty)));
            cmd.Parameters.Add(new MySqlParameter("@DiscountAmt", Util.GetFloat(DiscountAmt)));
            cmd.Parameters.Add(new MySqlParameter("@GSTAmount", Util.GetFloat(GSTAmount)));
            cmd.Parameters.Add(new MySqlParameter("@FinalPrice", Util.GetFloat(FinalPrice)));
            cmd.Parameters.Add(new MySqlParameter("@CreaterID", UserInfo.ID));
            cmd.Parameters.Add(new MySqlParameter("@IsActive", Util.GetInt(IsActive)));



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
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for StoreSalesIndent
/// </summary>
public class StoreSalesIndent
{
	

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public StoreSalesIndent()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
       
    }
    public StoreSalesIndent(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }


    public string IndentNo { get; set; }
    public int ItemId { get; set; }
    public string ItemName { get; set; }
    public int FromPanelId { get; set; }
    public int FromLocationID { get; set; }
    public int ToPanelID { get; set; }
    public int ToLocationID { get; set; }
    public float ReqQty { get; set; }
    public int MinorUnitID { get; set; }
    public string MinorUnitName { get; set; }
    public string Narration { get; set; }
    public DateTime ExpectedDate { get; set; }
    public string IndentType { get; set; }
    public int IsBackupEntry { get; set; }
    public string FromRights { get; set; }
    public float Rate { get; set; }
    public float DiscountPer { get; set; }
    public float TaxPerIGST { get; set; }
    public float TaxPerCGST { get; set; }
    public float TaxPerSGST { get; set; }
    public float NetAmount { get; set; }
    public float ApprovedQty { get; set; }
    public float CheckedQty { get; set; }
    public float MaxQty { get; set; }
    public int Vendorid { get; set; }
    public int VendorStateId { get; set; }
    public string VednorStateGstnno { get; set; }
    public float UnitPrice { get; set; }
 public string mapid { get; set; }
    public string Insert()
    {
        try
        {
            string issaved = "";
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("store_SaveIndentdetail");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

           
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            cmd.Parameters.Add(new MySqlParameter("@IndentNo", Util.GetString(IndentNo)));
            cmd.Parameters.Add(new MySqlParameter("@ItemId", Util.GetInt(ItemId)));
            cmd.Parameters.Add(new MySqlParameter("@ItemName", Util.GetString(ItemName).ToUpper()));
            cmd.Parameters.Add(new MySqlParameter("@FromPanelId", Util.GetInt(FromPanelId)));
            cmd.Parameters.Add(new MySqlParameter("@FromLocationID", Util.GetInt(FromLocationID)));
            cmd.Parameters.Add(new MySqlParameter("@ToPanelID", Util.GetInt(ToPanelID)));
            cmd.Parameters.Add(new MySqlParameter("@ToLocationID", Util.GetInt(ToLocationID)));
            cmd.Parameters.Add(new MySqlParameter("@ReqQty", Util.GetFloat(ReqQty)));
            cmd.Parameters.Add(new MySqlParameter("@MinorUnitID", Util.GetInt(MinorUnitID)));
            cmd.Parameters.Add(new MySqlParameter("@MinorUnitName", Util.GetString(MinorUnitName)));
          

            cmd.Parameters.Add(new MySqlParameter("@UserId", Util.GetInt(UserInfo.ID)));
            cmd.Parameters.Add(new MySqlParameter("@UserName", Util.GetString(UserInfo.LoginName)));

            cmd.Parameters.Add(new MySqlParameter("@Narration", Util.GetString(Narration)));
            cmd.Parameters.Add(new MySqlParameter("@ExpectedDate", Util.GetDateTime(ExpectedDate)));
            cmd.Parameters.Add(new MySqlParameter("@IndentType", Util.GetString(IndentType)));
            cmd.Parameters.Add(new MySqlParameter("@IsBackupEntry", Util.GetInt(IsBackupEntry)));
            cmd.Parameters.Add(new MySqlParameter("@FromRights", Util.GetString(FromRights)));
            cmd.Parameters.Add(new MySqlParameter("@Rate", Util.GetFloat(Rate)));
            cmd.Parameters.Add(new MySqlParameter("@DiscountPer", Util.GetFloat(DiscountPer)));
            cmd.Parameters.Add(new MySqlParameter("@TaxPerIGST", Util.GetFloat(TaxPerIGST)));
            cmd.Parameters.Add(new MySqlParameter("@TaxPerCGST", Util.GetFloat(TaxPerCGST)));
            cmd.Parameters.Add(new MySqlParameter("@TaxPerSGST", Util.GetFloat(TaxPerSGST)));
            cmd.Parameters.Add(new MySqlParameter("@NetAmount", Util.GetFloat(NetAmount)));

            cmd.Parameters.Add(new MySqlParameter("@Vendorid", Util.GetInt(Vendorid)));
            cmd.Parameters.Add(new MySqlParameter("@VendorStateId", Util.GetInt(VendorStateId)));
            cmd.Parameters.Add(new MySqlParameter("@VednorStateGstnno", Util.GetString(VednorStateGstnno)));
            cmd.Parameters.Add(new MySqlParameter("@UnitPrice", Util.GetFloat(UnitPrice)));
            cmd.Parameters.Add(new MySqlParameter("@MaxQty", Util.GetFloat(MaxQty)));

            issaved = cmd.ExecuteNonQuery().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return issaved.ToString();
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
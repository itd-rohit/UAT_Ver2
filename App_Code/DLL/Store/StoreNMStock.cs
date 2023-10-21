using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for StoreNMStock
/// </summary>
public class StoreNMStock
{


    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public StoreNMStock()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;

    }
    public StoreNMStock(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    public int StockID { get; set; }
    public int ItemID { get; set; }
    public string ItemName { get; set; }
    public int LedgerTransactionID { get; set; }
    public string LedgerTransactionNo { get; set; }
    public string BatchNumber { get; set; }

    public float Rate { get; set; }
    public float DiscountPer { get; set; }
    public float DiscountAmount { get; set; }
    public float TaxPer { get; set; }
    public float TaxAmount { get; set; }
    public float UnitPrice { get; set; }
    public float MRP { get; set; }
    public float InitialCount { get; set; }
    public float ReleasedCount { get; set; }
    public float PendingQty { get; set; }
    public float RejectQty { get; set; }


    public DateTime ExpiryDate { get; set; }


    public string Naration { get; set; }
    public int IsFree { get; set; }

    public int LocationID { get; set; }
    public int Panel_Id { get; set; }

    public string IndentNo { get; set; }
    public int FromLocationID { get; set; }
    public int FromStockID { get; set; }
    public int Reusable { get; set; }
    public int ManufactureID { get; set; }
    public int MacID { get; set; }
    public int MajorUnitID { get; set; }
    public string MajorUnit { get; set; }
    public int MinorUnitID { get; set; }
    public string MinorUnit { get; set; }
    public float Converter { get; set; }
    public string Remarks { get; set; }
    public string BarcodeNo { get; set; }

    public int IsExpirable{ get; set; }
    public int IssueMultiplier { get; set; }
    public string PackSize{ get; set; }

    public int BarcodeOption { get; set; }
    public int BarcodeGenrationOption { get; set; }
    public int IssueInFIFO { get; set; }
    public int MajorUnitInDecimal { get; set; }
    public int MinorUnitInDecimal { get; set; }
    public int IsPost { get; set; }
    public DateTime PostDate { get; set; }
    public string PostUserID { get; set; }
    public string UpdateRemarks { get; set; }
    public string StockPhysicalVerificationID { get; set; }
    public string InitialCount_old { get; set; }
    public string InitialCount_New { get; set; }
    public string StockPhysicalVerificationRemarks { get; set; }
    public string qutationid { get; set; }
    public string Insert()
    {
        try
        {
            string saveditemid = "";
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("store_nmstock");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@StockID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 30;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            cmd.Parameters.Add(new MySqlParameter("@ItemID", Util.GetInt(ItemID)));
            cmd.Parameters.Add(new MySqlParameter("@ItemName", Util.GetString(ItemName)));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionID", Util.GetInt(LedgerTransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionNo", Util.GetString(LedgerTransactionNo)));
            cmd.Parameters.Add(new MySqlParameter("@BatchNumber", Util.GetString(BatchNumber)));
            cmd.Parameters.Add(new MySqlParameter("@Rate", Util.GetFloat(Rate)));
            cmd.Parameters.Add(new MySqlParameter("@DiscountPer", Util.GetFloat(DiscountPer)));

            cmd.Parameters.Add(new MySqlParameter("@DiscountAmount", Util.GetFloat(DiscountAmount)));
            cmd.Parameters.Add(new MySqlParameter("@TaxPer", Util.GetFloat(TaxPer)));
            cmd.Parameters.Add(new MySqlParameter("@TaxAmount", Util.GetFloat(TaxAmount)));
            cmd.Parameters.Add(new MySqlParameter("@UnitPrice", Util.GetFloat(UnitPrice)));
            cmd.Parameters.Add(new MySqlParameter("@MRP", Util.GetFloat(MRP)));
            cmd.Parameters.Add(new MySqlParameter("@InitialCount", Util.GetFloat(InitialCount)));

            cmd.Parameters.Add(new MySqlParameter("@ReleasedCount", Util.GetFloat(ReleasedCount)));

            cmd.Parameters.Add(new MySqlParameter("@PendingQty", Util.GetFloat(PendingQty)));
            cmd.Parameters.Add(new MySqlParameter("@RejectQty", Util.GetFloat(RejectQty)));



            cmd.Parameters.Add(new MySqlParameter("@ExpiryDate", Util.GetDateTime(ExpiryDate)));

            cmd.Parameters.Add(new MySqlParameter("@Naration", Util.GetString(Naration)));
            cmd.Parameters.Add(new MySqlParameter("@IsFree", Util.GetString(IsFree)));
            cmd.Parameters.Add(new MySqlParameter("@LocationID", Util.GetInt(LocationID)));

            cmd.Parameters.Add(new MySqlParameter("@Panel_Id", Util.GetInt(Panel_Id)));
            cmd.Parameters.Add(new MySqlParameter("@IndentNo", Util.GetString(IndentNo)));
            cmd.Parameters.Add(new MySqlParameter("@FromLocationID", Util.GetInt(FromLocationID)));
            cmd.Parameters.Add(new MySqlParameter("@FromStockID", Util.GetInt(FromStockID)));
            cmd.Parameters.Add(new MySqlParameter("@UserID", Util.GetString(UserInfo.ID)));
            cmd.Parameters.Add(new MySqlParameter("@Reusable", Util.GetInt(Reusable)));
            cmd.Parameters.Add(new MySqlParameter("@ManufactureID", Util.GetInt(ManufactureID)));
            cmd.Parameters.Add(new MySqlParameter("@MacID", Util.GetInt(MacID)));

            cmd.Parameters.Add(new MySqlParameter("@MajorUnitID", Util.GetInt(MajorUnitID)));
            cmd.Parameters.Add(new MySqlParameter("@MajorUnit", Util.GetString(MajorUnit)));

            cmd.Parameters.Add(new MySqlParameter("@MinorUnitID", Util.GetInt(MinorUnitID)));
            cmd.Parameters.Add(new MySqlParameter("@MinorUnit", Util.GetString(MinorUnit)));

            cmd.Parameters.Add(new MySqlParameter("@Converter", Util.GetFloat(Converter)));
            cmd.Parameters.Add(new MySqlParameter("@Remarks", Util.GetString(Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@BarcodeNo", Util.GetString(BarcodeNo)));
            cmd.Parameters.Add(new MySqlParameter("@IsPost", Util.GetInt(IsPost)));
            cmd.Parameters.Add(new MySqlParameter("@PostDate", Util.GetDateTime(PostDate)));

            cmd.Parameters.Add(new MySqlParameter("@PostUserID", Util.GetString(PostUserID)));

            cmd.Parameters.Add(new MySqlParameter("@IsExpirable", Util.GetInt(IsExpirable)));
            cmd.Parameters.Add(new MySqlParameter("@IssueMultiplier", Util.GetInt(IssueMultiplier)));
            cmd.Parameters.Add(new MySqlParameter("@PackSize", Util.GetString(PackSize)));

            cmd.Parameters.Add(new MySqlParameter("@BarcodeOption", Util.GetInt(BarcodeOption)));
            cmd.Parameters.Add(new MySqlParameter("@BarcodeGenrationOption", Util.GetInt(BarcodeGenrationOption)));
            cmd.Parameters.Add(new MySqlParameter("@IssueInFIFO", Util.GetInt(IssueInFIFO)));

            cmd.Parameters.Add(new MySqlParameter("@MajorUnitInDecimal", Util.GetInt(MajorUnitInDecimal)));
            cmd.Parameters.Add(new MySqlParameter("@MinorUnitInDecimal", Util.GetInt(MinorUnitInDecimal)));

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

    public int Update()
    {

        try
        {
            int saveditemid = 0;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append(" update st_nmstock set ItemID='" + Util.GetInt(ItemID) + "',ItemName='" + Util.GetString(ItemName) + "' ,");
            objSQL.Append(" BatchNumber='" + Util.GetString(BatchNumber) + "',ExpiryDate='" + Util.GetDateTime(ExpiryDate).ToString("yyyy-MM-dd") + "',Rate='" + Util.GetFloat(Rate) + "', ");
            objSQL.Append(" DiscountPer='" + Util.GetFloat(DiscountPer) + "' ,DiscountAmount='" + Util.GetFloat(DiscountAmount) + "',TaxPer='" + Util.GetFloat(TaxPer) + "',");
            objSQL.Append(" TaxAmount='" + Util.GetFloat(TaxAmount) + "',UnitPrice='" + Util.GetFloat(UnitPrice) + "',MRP='" + Util.GetFloat(MRP) + "',");

            objSQL.Append(" InitialCount='" + Util.GetFloat(InitialCount) + "',UpdateBy='" + UserInfo.ID + "',");
            objSQL.Append(" UpdateRemarks='" + Util.GetString(UpdateRemarks) + "',UpdateDate=now(),");
            objSQL.Append(" IsExpirable='" + Util.GetInt(IsExpirable) + "',IssueMultiplier='" + Util.GetInt(IssueMultiplier) + "',PackSize='" + Util.GetString(PackSize) + "',BarcodeOption='" + Util.GetInt(BarcodeOption) + "',BarcodeGenrationOption='" + Util.GetInt(BarcodeGenrationOption) + "',IssueInFIFO='" + Util.GetInt(IssueInFIFO) + "'");
           

            objSQL.Append(" where LedgerTransactionID='" + Util.GetInt(LedgerTransactionID) + "' and stockid='" + Util.GetInt(StockID) + "'");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.Text;



            saveditemid = cmd.ExecuteNonQuery();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return saveditemid;


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
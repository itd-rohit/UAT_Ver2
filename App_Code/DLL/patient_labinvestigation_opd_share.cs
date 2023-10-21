using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for ItemMaster
/// </summary>
public class patient_labinvestigation_opd_share
{
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public patient_labinvestigation_opd_share()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public patient_labinvestigation_opd_share(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #region All Memory Variables
    public string BarcodeNo { get; set; }
    public int Centre_PanelID { get; set; }
    public int Panel_ID { get; set; }
    public int LedgerTransactionID { get; set; }
    public string LedgerTransactionNo { get; set; }
    public int ItemId { get; set; }
    public decimal Rate { get; set; }
    public decimal MRP { get; set; }
    public decimal Amount { get; set; }
    public decimal DiscountAmt { get; set; }
    public decimal Quantity { get; set; }
    public int DiscountByLab { get; set; }
    public decimal PCCGrossAmt { get; set; }
    public decimal PCCDiscAmt { get; set; }
    public decimal PCCNetAmt { get; set; }
    public int PCCSpecialFlag { get; set; }
    public decimal PCCInvoiceAmt { get; set; }
    public decimal PCCPercentage { get; set; }
    public DateTime Date { get; set; }
    public int Test_ID { get; set; }
    public Byte? IsSRA { get; set; }
    public DateTime? SRADate { get; set; }
    public string BillNo { get; set; }
    public decimal CouponAmt { get; set; }
     public string IsSampleCollected { get; set; }
    #endregion All Memory Variables




    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_patient_labinvestigation_opd_share");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("@BarcodeNo", BarcodeNo));
            cmd.Parameters.Add(new MySqlParameter("@Centre_PanelID", Centre_PanelID));
            cmd.Parameters.Add(new MySqlParameter("@Panel_ID", Panel_ID));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo));
            cmd.Parameters.Add(new MySqlParameter("@ItemId", ItemId));
            cmd.Parameters.Add(new MySqlParameter("@Rate", Rate));
            cmd.Parameters.Add(new MySqlParameter("@Amount", Amount));
            cmd.Parameters.Add(new MySqlParameter("@DiscountAmt", DiscountAmt));
            cmd.Parameters.Add(new MySqlParameter("@Quantity", Quantity));
            cmd.Parameters.Add(new MySqlParameter("@DiscountByLab", DiscountByLab));
            cmd.Parameters.Add(new MySqlParameter("@PCCGrossAmt", PCCGrossAmt));
            cmd.Parameters.Add(new MySqlParameter("@PCCDiscAmt", PCCDiscAmt));
            cmd.Parameters.Add(new MySqlParameter("@PCCNetAmt", PCCNetAmt));
            cmd.Parameters.Add(new MySqlParameter("@PCCSpecialFlag", PCCSpecialFlag));
            cmd.Parameters.Add(new MySqlParameter("@PCCInvoiceAmt", PCCInvoiceAmt));
            cmd.Parameters.Add(new MySqlParameter("@PCCPercentage", PCCPercentage));
            cmd.Parameters.Add(new MySqlParameter("@Date", Util.GetDateTime(Date)));
            cmd.Parameters.Add(new MySqlParameter("@MRP", Util.GetDecimal(MRP)));
            cmd.Parameters.Add(new MySqlParameter("@Test_ID", Test_ID));
            cmd.Parameters.Add(new MySqlParameter("@BillNo", BillNo));
            cmd.Parameters.Add(new MySqlParameter("@IsSRA", IsSRA));
            cmd.Parameters.Add(new MySqlParameter("@SRADate", SRADate));
            cmd.Parameters.Add(new MySqlParameter("@CouponAmt", Util.GetDecimal(CouponAmt)));
             cmd.Parameters.Add(new MySqlParameter("@IsSampleCollected", IsSampleCollected));

            string id = cmd.ExecuteNonQuery().ToString();
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return id;
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
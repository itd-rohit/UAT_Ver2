using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for StoreLedgerTransaction
/// </summary>
public class StoreLedgerTransaction
{



    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public StoreLedgerTransaction()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;

    }
    public StoreLedgerTransaction(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }


    public int LedgerTransactionID { get; set; }
    public string LedgerTransactionNo { get; set; }
    public int VendorID { get; set; }
    public string TypeOfTnx { get; set; }
    public string PurchaseOrderNo { get; set; }
    public float GrossAmount { get; set; }
    public float DiscountOnTotal { get; set; }
    public float TaxAmount { get; set; }
    
    public float NetAmount { get; set; }
    public float InvoiceAmount { get; set; }
    public string InvoiceNo { get; set; }
    public DateTime InvoiceDate { get; set; }
    public int InvoiceAttachment { get; set; }
    public string ChalanNo { get; set; }
    public DateTime ChalanDate { get; set; }
   
    public string DiscountReason { get; set; }
    public string Remarks { get; set; }

    public string IndentNo { get; set; }
    public float Freight { get; set; }
    public float Octori { get; set; }
    public string GatePassInWard { get; set; }
    public string GatePassOutWard { get; set; }
    public int IsReturnable { get; set; }
    public float RoundOff { get; set; }
    public int LocationID { get; set; }
    public int IsDirectGRN { get; set; }
    public string UpdateRemarks { get; set; }


    public string Insert()
    {
        try
        {
            string saveditemid = "";
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("store_ledgertransaction");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@ReturnLedgerTransactionNo";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 30;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            cmd.Parameters.Add(new MySqlParameter("@VendorID", Util.GetInt(VendorID)));
            cmd.Parameters.Add(new MySqlParameter("@TypeOfTnx", Util.GetString(TypeOfTnx)));
            cmd.Parameters.Add(new MySqlParameter("@PurchaseOrderNo", Util.GetString(PurchaseOrderNo)));
            cmd.Parameters.Add(new MySqlParameter("@GrossAmount", Util.GetFloat(GrossAmount)));
            cmd.Parameters.Add(new MySqlParameter("@DiscountOnTotal", Util.GetFloat(DiscountOnTotal)));
            cmd.Parameters.Add(new MySqlParameter("@TaxAmount", Util.GetFloat(TaxAmount)));
            
            cmd.Parameters.Add(new MySqlParameter("@NetAmount", Util.GetFloat(NetAmount)));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceAmount", Util.GetFloat(InvoiceAmount)));

            cmd.Parameters.Add(new MySqlParameter("@InvoiceNo", Util.GetString(InvoiceNo)));


            cmd.Parameters.Add(new MySqlParameter("@InvoiceDate", Util.GetDateTime(InvoiceDate)));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceAttachment", Util.GetInt(InvoiceAttachment)));
            cmd.Parameters.Add(new MySqlParameter("@ChalanNo", Util.GetString(ChalanNo)));
            cmd.Parameters.Add(new MySqlParameter("@ChalanDate", Util.GetDateTime(ChalanDate)));
            cmd.Parameters.Add(new MySqlParameter("@DiscountReason", Util.GetString(DiscountReason)));
            cmd.Parameters.Add(new MySqlParameter("@Remarks", Util.GetString(Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@Creator_UserID", Util.GetInt(UserInfo.ID)));

            cmd.Parameters.Add(new MySqlParameter("@IndentNo", Util.GetString(IndentNo)));
            cmd.Parameters.Add(new MySqlParameter("@Freight", Util.GetFloat(Freight)));
            cmd.Parameters.Add(new MySqlParameter("@Octori", Util.GetFloat(Octori)));
            cmd.Parameters.Add(new MySqlParameter("@GatePassInWard", Util.GetString(GatePassInWard)));
            cmd.Parameters.Add(new MySqlParameter("@GatePassOutWard", Util.GetString(GatePassOutWard)));
            cmd.Parameters.Add(new MySqlParameter("@IsReturnable", Util.GetInt(IsReturnable)));
            cmd.Parameters.Add(new MySqlParameter("@RoundOff", Util.GetFloat(RoundOff)));
            cmd.Parameters.Add(new MySqlParameter("@LocationID", Util.GetInt(LocationID)));
            cmd.Parameters.Add(new MySqlParameter("@IsDirectGRN", Util.GetInt(IsDirectGRN)));
            
        




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
            objSQL.Append(" update st_ledgertransaction set VendorID='" + Util.GetInt(VendorID) + "',TypeOfTnx='" + Util.GetString(TypeOfTnx) + "' ,");
            objSQL.Append(" PurchaseOrderNo='" + Util.GetString(PurchaseOrderNo) + "',GrossAmount='" + Util.GetFloat(GrossAmount) + "',DiscountOnTotal='" + Util.GetFloat(DiscountOnTotal) + "', ");
            objSQL.Append(" TaxAmount='" + Util.GetFloat(TaxAmount) + "' ,NetAmount='" + Util.GetFloat(NetAmount) + "',InvoiceAmount='" + Util.GetFloat(InvoiceAmount) + "',");
            objSQL.Append(" InvoiceNo='" + Util.GetString(InvoiceNo) + "',InvoiceDate='" + Util.GetDateTime(InvoiceDate).ToString("yyyy-MM-dd hh:mms:ss") + "',ChalanNo='" + Util.GetString(ChalanNo) + "',");

            objSQL.Append(" ChalanDate='" + Util.GetDateTime(ChalanDate).ToString("yyyy-MM-dd hh:mms:ss") + "',Remarks='" + Util.GetString(Remarks) + "',IndentNo='" + Util.GetString(IndentNo) + "',");
            objSQL.Append(" Freight='" + Util.GetFloat(Freight) + "',Octori='" + Util.GetFloat(Octori) + "',GatePassInWard='" + Util.GetString(GatePassInWard) + "',");
            objSQL.Append(" GatePassOutWard='" + Util.GetString(GatePassOutWard) + "',RoundOff='" + Util.GetFloat(RoundOff) + "',UpdateBy='" + UserInfo.ID + "',");
            objSQL.Append(" UpdateRemarks='" + Util.GetString(UpdateRemarks) + "',UpdateDate=now()");
            objSQL.Append(" where LedgerTransactionID='" + Util.GetInt(LedgerTransactionID) + "'");
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
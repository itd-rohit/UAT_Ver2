using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for InsertPettyCash
/// </summary>
public class InsertPettyCash
{


    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion


    #region Overloaded Constructor
    public InsertPettyCash()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;  
    }

    public InsertPettyCash(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;

    }
    #endregion

    #region Set All Property
    public int Id { get; set; }
    public int CenterId { get; set; }
    public string CenterName { get; set; }
    public string CenterCode { get; set; }
    public decimal Amount { get; set; }
    public string  Reciept { get; set; }
    public string PaymentDate { get; set; }
    public string  Type { get; set; }
    public string PaymentMode { get; set; }
    public string BankName { get; set; }
    public string ChequeDate { get; set; }
    public string  CardNo { get; set; }
    public string InvoiceNo { get; set; }
    public string invicedate { get; set; }
    public string exptype { get; set; }
    public int exptypeID { get; set; }
    public string narration { get; set; }
    public int Adjustment { get; set; }


    public int PettyCashId { get; set; }

    public int CancelBy { get; set; }
    public string  CancelByName { get; set; }
    public string CancelDatetime { get; set; }
    public string CancelRemark { get; set; }

    public int IsApproved { get; set; }
    public int ApprovedById { get; set; }
    public string ApprovedBy { get; set; }
    public string ApprovedDate { get; set; }
    public string Remarks { get; set; }
    public int IsActive { get; set; }

    #endregion

    public int Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("PettyCash_Insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@Id";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;
            paramTnxID.Direction = ParameterDirection.InputOutput;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("@CentreID", Util.GetInt(CenterId)));
            cmd.Parameters.Add(new MySqlParameter("@CentreCode", Util.GetString(CenterCode)));
            cmd.Parameters.Add(new MySqlParameter("@Centre", Util.GetString(CenterName)));
            cmd.Parameters.Add(new MySqlParameter("@Amount", Util.GetDecimal(Amount)));
            cmd.Parameters.Add(new MySqlParameter("@Filename", Util.GetString(Reciept)));
            cmd.Parameters.Add(new MySqlParameter("@PaymentDate", Util.GetDateTime(PaymentDate)));
            cmd.Parameters.Add(new MySqlParameter("@PaymentType", Util.GetString(Type)));
            cmd.Parameters.Add(new MySqlParameter("@IsActive", "1"));
            cmd.Parameters.Add(new MySqlParameter("@CreateBy", UserInfo.LoginName));
            cmd.Parameters.Add(new MySqlParameter("@CreatedById", UserInfo.ID));
            cmd.Parameters.Add(new MySqlParameter("@PaymentMode", Util.GetString(PaymentMode)));
            cmd.Parameters.Add(new MySqlParameter("@Bank", Util.GetString(BankName)));
            cmd.Parameters.Add(new MySqlParameter("@CardNo", Util.GetString(CardNo)));
            cmd.Parameters.Add(new MySqlParameter("@ChequeDate", Util.GetDateTime(ChequeDate)));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceNo", Util.GetString(InvoiceNo)));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceDate", Util.GetDateTime(invicedate)));
            cmd.Parameters.Add(new MySqlParameter("@ExpancType", Util.GetString(exptype)));
            cmd.Parameters.Add(new MySqlParameter("@ExpensesID", Util.GetInt(exptypeID)));
            
            cmd.Parameters.Add(new MySqlParameter("@Narration", Util.GetString(narration)));
            cmd.Parameters.Add(new MySqlParameter("@Remarks", Util.GetString(Remarks)));
            //Adjustment
            cmd.Parameters.Add(new MySqlParameter("@Adjustment", Util.GetInt(Adjustment)));

            PettyCashId = Util.GetInt(cmd.ExecuteScalar().ToString());
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
          
            return PettyCashId;

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

    public void Update() {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("PettyCash_Update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("@UpdatePettyId", Util.GetInt(Id)));
            cmd.Parameters.Add(new MySqlParameter("@UpdateIsApproved", Util.GetInt(IsApproved)));
            cmd.Parameters.Add(new MySqlParameter("@UpdateCancelBy", Util.GetInt(CancelBy)));
            cmd.Parameters.Add(new MySqlParameter("@UpdateCancelByName", Util.GetString(CancelByName)));
            cmd.Parameters.Add(new MySqlParameter("@UpdateCancelRemarks", Util.GetString(CancelRemark)));
            cmd.Parameters.Add(new MySqlParameter("@UpdateApprovedBy", Util.GetString(ApprovedBy)));
            cmd.Parameters.Add(new MySqlParameter("@UpdateApprovedByID", Util.GetInt(ApprovedById)));
            cmd.Parameters.Add(new MySqlParameter("@UpdateRemarks", Util.GetString(Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@UpdateIsActive", IsActive));
            cmd.ExecuteNonQuery();
           
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) 
                    objCon.Close();
            }
            throw (ex);
        }
    
    
    
    
    }

}
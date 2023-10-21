using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for PurchaseOrderTermsAndConditions
/// </summary>
public class PurchaseOrderTermsAndConditions
{
      #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

     #endregion
    #region Overloaded Constructor
    public PurchaseOrderTermsAndConditions()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;        
	}
    public PurchaseOrderTermsAndConditions(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property

    public int PurchaseOrderID { get; set; }
    public string PurchaseOrderNo { get; set; }
    public string POTermsCondition { get; set; }
    public int CreatedByID { get; set; }
    public string CreatedByName { get; set; }
    public int PurchaseOrderTermID { get; set; }
    public int POTermConditionID { get; set; }
    public string DeliveryTerm { get; set; }

    public int TermConditionID { get; set; }
    public int DeliveryTermID { get; set; }
    #endregion

    public int Insert()
    {
        try
        {

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("store_Insert_PurchaseOrder_TermsAndCondition");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@PurchaseOrderTermID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;
            paramTnxID.Direction = ParameterDirection.InputOutput;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@PurchaseOrderID", Util.GetInt(PurchaseOrderID)));
            cmd.Parameters.Add(new MySqlParameter("@PurchaseOrderNo", Util.GetString(PurchaseOrderNo)));
            cmd.Parameters.Add(new MySqlParameter("@POTermsCondition", Util.GetString(POTermsCondition)));
            cmd.Parameters.Add(new MySqlParameter("@CreatedByID", Util.GetInt(CreatedByID)));
            cmd.Parameters.Add(new MySqlParameter("@CreatedByName", Util.GetString(CreatedByName)));
            cmd.Parameters.Add(new MySqlParameter("@DeliveryTerm", Util.GetString(DeliveryTerm)));

            cmd.Parameters.Add(new MySqlParameter("@TermConditionID", Util.GetInt(TermConditionID)));
            cmd.Parameters.Add(new MySqlParameter("@DeliveryTermID", Util.GetInt(DeliveryTermID)));
            PurchaseOrderTermID = Util.GetInt(cmd.ExecuteScalar().ToString());


            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return PurchaseOrderTermID;
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
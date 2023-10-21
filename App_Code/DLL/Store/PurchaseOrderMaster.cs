#region All Namespaces
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
#endregion All Namespaces


public class PurchaseOrderMaster
{


    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Overloaded Constructor
    public PurchaseOrderMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public PurchaseOrderMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion


    #region Set All Property

    public string PurchaseOrderNo { get; set; }
    public int PurchaseOrderID { get; set; }
    public string Subject { get; set; }
    public int VendorID { get; set; }
    public string VendorName { get; set; }
    public int CreatedByID { get; set; }
    public string CreatedByName { get; set; }

    public DateTime CheckedDate { get; set; }
    public int CheckedByID { get; set; }
    public string CheckedByName { get; set; }
    public DateTime ApprovedDate { get; set; }
    public int ApprovedByID { get; set; }
    public string AppprovedByName { get; set; }

    public int Status { get; set; }
    public string StatusName { get; set; }
    public int LocationID { get; set; }
    public string IndentNo { get; set; }
    public int VendorStateId { get; set; }
    public string VendorGSTIN { get; set; }
    public string VendorAddress { get; set; }
    public int VendorLogin { get; set; }
    public string POType { get; set; }

    public int IsDirectPO { get; set; }
    public string ActionType { get; set; }
    public string Warranty { get; set; }
    public string NFANo { get; set; }
    public string Termandcondition { get; set; }
    #endregion
    public int Insert()
    {
        try
        {

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("store_Insert_PurchaseOrder");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@PoNumber";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;


            paramTnxID.Direction = ParameterDirection.InputOutput;
            paramTnxID.Value = PurchaseOrderID;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@PurchaseOrderNo", Util.GetString(PurchaseOrderNo)));
            cmd.Parameters.Add(new MySqlParameter("@Subject", Util.GetString(Subject)));
            cmd.Parameters.Add(new MySqlParameter("@VendorID", Util.GetInt(VendorID)));
            cmd.Parameters.Add(new MySqlParameter("@VendorName", Util.GetString(VendorName)));
            cmd.Parameters.Add(new MySqlParameter("@CreatedByID", Util.GetInt(CreatedByID)));
            cmd.Parameters.Add(new MySqlParameter("@CreatedByName", Util.GetString(CreatedByName)));
            cmd.Parameters.Add(new MySqlParameter("@CheckedDate", Util.GetDateTime(CheckedDate)));
            cmd.Parameters.Add(new MySqlParameter("@CheckedByID", Util.GetInt(CheckedByID)));
            cmd.Parameters.Add(new MySqlParameter("@CheckedByName", Util.GetString(CheckedByName)));
            cmd.Parameters.Add(new MySqlParameter("@ApprovedDate", Util.GetDateTime(ApprovedDate)));
            cmd.Parameters.Add(new MySqlParameter("@ApprovedByID", Util.GetInt(ApprovedByID)));
            cmd.Parameters.Add(new MySqlParameter("@AppprovedByName", Util.GetString(AppprovedByName)));
            cmd.Parameters.Add(new MySqlParameter("@Status", Util.GetInt(Status)));
            cmd.Parameters.Add(new MySqlParameter("@StatusName", Util.GetString(StatusName)));
            cmd.Parameters.Add(new MySqlParameter("@LocationID", Util.GetInt(LocationID)));
            cmd.Parameters.Add(new MySqlParameter("@IndentNo", Util.GetString(IndentNo)));
            cmd.Parameters.Add(new MySqlParameter("@VendorStateId", Util.GetInt(VendorStateId)));
            cmd.Parameters.Add(new MySqlParameter("@VendorGSTIN", Util.GetString(VendorGSTIN)));
            cmd.Parameters.Add(new MySqlParameter("@VendorAddress", Util.GetString(VendorAddress)));
            cmd.Parameters.Add(new MySqlParameter("@VendorLogin", Util.GetInt(VendorLogin)));
            cmd.Parameters.Add(new MySqlParameter("@POType", Util.GetString(POType)));
            cmd.Parameters.Add(new MySqlParameter("@IsDirectPO", Util.GetInt(IsDirectPO)));
            cmd.Parameters.Add(new MySqlParameter("@ActionType", Util.GetString(ActionType)));
            cmd.Parameters.Add(new MySqlParameter("@Warranty", Util.GetString(Warranty)));

            cmd.Parameters.Add(new MySqlParameter("@NFANo", Util.GetString(NFANo)));
            cmd.Parameters.Add(new MySqlParameter("@Termandcondition", Util.GetString(Termandcondition)));

            PurchaseOrderID = Util.GetInt(cmd.ExecuteScalar().ToString());


            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return PurchaseOrderID;
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

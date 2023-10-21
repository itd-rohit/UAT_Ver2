using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for StoreSalesDetail
/// </summary>
public class StoreSalesDetail
{


    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public StoreSalesDetail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;

    }
    public StoreSalesDetail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

   
    public int FromLocationID { get; set; }
    public int ToLocationID { get; set; }
    public int StockID { get; set; }
    public float Quantity { get; set; }
    public int TrasactionTypeID { get; set; }
    public string TrasactionType { get; set; }
    public int ItemID { get; set; }
    public string IndentNo { get; set; }
    public string Naration { get; set; }
    public int SalesNo { get; set; }
    public string IssueType { get; set; }
    public string Insert()
    {
        try
        {
            string saveditemid = "";
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("store_nmsalesdetail");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@SalesID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 30;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            cmd.Parameters.Add(new MySqlParameter("@FromLocationID", Util.GetInt(FromLocationID)));
            cmd.Parameters.Add(new MySqlParameter("@ToLocationID", Util.GetInt(ToLocationID)));
            cmd.Parameters.Add(new MySqlParameter("@StockID", Util.GetInt(StockID)));
            cmd.Parameters.Add(new MySqlParameter("@Quantity", Util.GetFloat(Quantity)));
            cmd.Parameters.Add(new MySqlParameter("@TrasactionTypeID", Util.GetInt(TrasactionTypeID)));
            cmd.Parameters.Add(new MySqlParameter("@TrasactionType", Util.GetString(TrasactionType)));
            cmd.Parameters.Add(new MySqlParameter("@ItemID", Util.GetInt(ItemID)));
            cmd.Parameters.Add(new MySqlParameter("@IndentNo", Util.GetString(IndentNo)));

            cmd.Parameters.Add(new MySqlParameter("@Naration", Util.GetString(Naration)));
            cmd.Parameters.Add(new MySqlParameter("@UserID", Util.GetInt(UserInfo.ID)));

            cmd.Parameters.Add(new MySqlParameter("@salesno", Util.GetInt(SalesNo)));
            cmd.Parameters.Add(new MySqlParameter("@IssueType", Util.GetString(IssueType)));

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
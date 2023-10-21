using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for Patient_Estimate_Log
/// </summary>
public class Patient_Estimate_Log
{
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;
	public Patient_Estimate_Log()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;	
    }
    public Patient_Estimate_Log(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    public string Mobile { get; set; }
    public string Call_By { get; set; }
    public string Call_By_ID { get; set; }
    public string Call_Type { get; set; }
    public string UserName { get; set; }
    public int UserID { get; set; }
    public string Remarks { get; set; }
    public string Name { get; set; }
    public string CentreID { get; set; }
    public int RemarksID { get; set; }
    public string Insert() {
        try {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Call_Centre_Log");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@testid";

            paramTnxID.MySqlDbType = MySqlDbType.Int32;
            paramTnxID.Size = 20;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("@Mobile", Util.GetString(Mobile)));
            cmd.Parameters.Add(new MySqlParameter("@Call_By", Util.GetString(Call_By)));
            cmd.Parameters.Add(new MySqlParameter("@Call_By_ID", Util.GetString(Call_By_ID)));
            cmd.Parameters.Add(new MySqlParameter("@Call_Type", Util.GetString(Call_Type)));
            cmd.Parameters.Add(new MySqlParameter("@UserName", Util.GetString(UserName)));
            cmd.Parameters.Add(new MySqlParameter("@UserID", Util.GetInt(UserID)));
            cmd.Parameters.Add(new MySqlParameter("@Remarks", Util.GetString(Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@Name", Util.GetString(Name)));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", Util.GetString(CentreID)));
            cmd.Parameters.Add(new MySqlParameter("@RemarksID", Util.GetInt(RemarksID)));
            cmd.Parameters.Add(paramTnxID);
            string id = cmd.ExecuteScalar().ToString();

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
            // Util.WriteLog(ex);
            throw (ex);
        }
        finally { }
    }
}
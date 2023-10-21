using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>  
/// Summary description for app_appointment  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:               
/// Create date:	1/17/2015 3:53:08 PM 
/// Description:	This class is intended for inserting, updating, deleting values for app_appointment table 
/// ========================================================================================== 
/// </summary>  

public class app_appointment
{
    public app_appointment()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public app_appointment(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private string _id;
    private string _Name;
    private string _Mobile;
    private string _App_Date;
    private string _dtEntry;
    private string _Assign_PRO;
    private string _dtAssign;
    private string _Assign_By;
    private string _Assign_Date;
    private string _isCancel;
    private string _Cancel_Reason;
    private string _Email;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual string id_int { get { return _id; } set { _id = value; } }
    public virtual string Name_varchar { get { return _Name; } set { _Name = value; } }
    public virtual string Mobile_varchar { get { return _Mobile; } set { _Mobile = value; } }
    public virtual string App_Date_datetime { get { return _App_Date; } set { _App_Date = value; } }
    public virtual string dtEntry_timestamp { get { return _dtEntry; } set { _dtEntry = value; } }
    public virtual string Assign_PRO_int { get { return _Assign_PRO; } set { _Assign_PRO = value; } }
    public virtual string dtAssign_datetime { get { return _dtAssign; } set { _dtAssign = value; } }
    public virtual string Assign_By_varchar { get { return _Assign_By; } set { _Assign_By = value; } }
    public virtual string Assign_Date_datetime { get { return _Assign_Date; } set { _Assign_Date = value; } }
    public virtual string isCancel_tinyint { get { return _isCancel; } set { _isCancel = value; } }
    public virtual string Cancel_Reason_varchar { get { return _Cancel_Reason; } set { _Cancel_Reason = value; } }
    public virtual string Email_varchar { get { return _Email; } set { _Email = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("app_appointment_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@_Name", _Name));
            cmd.Parameters.Add(new MySqlParameter("@_Mobile", _Mobile));
            cmd.Parameters.Add(new MySqlParameter("@_App_Date", Util.GetDateTime(_App_Date).ToString("yyyy-MM-dd HH:mm:ss")));
            //cmd.Parameters.Add(new MySqlParameter("@_dtEntry", _dtEntry));
            cmd.Parameters.Add(new MySqlParameter("@_Assign_PRO", _Assign_PRO));
            cmd.Parameters.Add(new MySqlParameter("@_dtAssign", _dtAssign));
            cmd.Parameters.Add(new MySqlParameter("@_Assign_By", _Assign_By));
            cmd.Parameters.Add(new MySqlParameter("@_Assign_Date", _Assign_Date));
            cmd.Parameters.Add(new MySqlParameter("@_isCancel", _isCancel));
            cmd.Parameters.Add(new MySqlParameter("@_Cancel_Reason", _Cancel_Reason));
            cmd.Parameters.Add(new MySqlParameter("@_Email", _Email));

            Output = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Output.ToString();
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





    #endregion

}

using System;
using System.Collections.Generic;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>  
/// Summary description for patient_labinvestigation_attachment  
/// Generated using MySqlManager  
/// ========================================================================================== 
/// Author:              DEEPAK SINGH 
/// Create date:	9/4/2013 10:25:36 PM 
/// Description:	This class is intended for inserting, updating, deleting values for patient_labinvestigation_attachment table 
/// ========================================================================================== 
/// </summary>  

public class patient_labinvestigation_attachment
{
    public patient_labinvestigation_attachment()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public patient_labinvestigation_attachment(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private string _id;
    private string _Test_ID;
    private string _AttachedFile;
    private string _FileUrl;
    private string _UploadedBy;
    private string _dtEntry;
    private string _IsOutSrc;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual string id_int { get { return _id; } set { _id = value; } }
    public virtual string Test_ID_varchar { get { return _Test_ID; } set { _Test_ID = value; } }
    public virtual string AttachedFile_varchar { get { return _AttachedFile; } set { _AttachedFile = value; } }
    public virtual string FileUrl_varchar { get { return _FileUrl; } set { _FileUrl = value; } }
    public virtual string UploadedBy_varchar { get { return _UploadedBy; } set { _UploadedBy = value; } }
    public virtual string dtEntry_timestamp { get { return _dtEntry; } set { _dtEntry = value; } }
    public virtual string V_IsOutSrc { get { return _IsOutSrc; } set { _IsOutSrc = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("insert_patient_labinvestigation_attachment");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@_Test_ID", _Test_ID));
            cmd.Parameters.Add(new MySqlParameter("@_AttachedFile", _AttachedFile));
            cmd.Parameters.Add(new MySqlParameter("@_FileUrl", _FileUrl));
            cmd.Parameters.Add(new MySqlParameter("@_UploadedBy", _UploadedBy));
            cmd.Parameters.Add(new MySqlParameter("@_dtEntry", _dtEntry));

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



    public string InsertReport()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("insert_patient_labinvestigation_attachment_report");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@_Test_ID", _Test_ID));
            cmd.Parameters.Add(new MySqlParameter("@_AttachedFile", _AttachedFile));
            cmd.Parameters.Add(new MySqlParameter("@_FileUrl", _FileUrl));
            cmd.Parameters.Add(new MySqlParameter("@_UploadedBy", _UploadedBy));
            cmd.Parameters.Add(new MySqlParameter("@_dtEntry", _dtEntry));
            cmd.Parameters.Add(new MySqlParameter("@IsOutSrc", _IsOutSrc));

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

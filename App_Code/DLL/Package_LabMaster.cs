using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class PackageLab_Master
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _PLabID;
    private string _Name;
    private string _Description;
    private string _CreaterID;
    private DateTime _Creator_Date;
    private int _IsActive;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public PackageLab_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public PackageLab_Master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    

    public virtual int ID
    {
        get
        {
            return _ID;
        }
        set
        {
            _ID = value;
        }
    }

    public virtual string PLabID
    {
        get
        {
            return _PLabID;
        }
        set
        {
            _PLabID = value;
        }
    }

    public virtual string Name
    {
        get
        {
            return _Name;
        }
        set
        {
            _Name = value;
        }
    }

    public virtual string Description
    {
        get
        {
            return _Description;
        }
        set
        {
            _Description = value;
        }
    }

    public virtual string CreaterID
    {
        get
        {
            return _CreaterID;
        }
        set
        {
            _CreaterID = value;
        }
    }

    public virtual DateTime Creator_Date
    {
        get
        {
            return _Creator_Date;
        }
        set
        {
            _Creator_Date = value;
        }
    }

    public virtual int IsActive
    {
        get
        {
            return _IsActive;
        }
        set
        {
            _IsActive = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            string iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_PackageLabMaster");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.CreaterID = Util.GetString(CreaterID);
            this.Creator_Date = Util.GetDateTime(Creator_Date);
            this.IsActive = Util.GetInt(IsActive);

            MySqlParameter paramPakageID = new MySqlParameter();
            paramPakageID.ParameterName = "@PlabID";

            paramPakageID.MySqlDbType = MySqlDbType.VarChar;
            paramPakageID.Size = 50;

            paramPakageID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
            cmd.Parameters.Add(new MySqlParameter("@Description", Description));
            cmd.Parameters.Add(new MySqlParameter("@Creator_ID", CreaterID));
            cmd.Parameters.Add(new MySqlParameter("@Creater_date", Creator_Date));
            cmd.Parameters.Add(new MySqlParameter("@IsActive", IsActive));
            cmd.Parameters.Add(paramPakageID);
            iPkValue = Util.GetString(cmd.ExecuteScalar().ToString());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue;
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
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE PackageLab_Master SET Name = ?, Description = ?,CreaterID=?,IsActive=? WHERE PLabID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.CreaterID = Util.GetString(CreaterID);
            this.IsActive = Util.GetInt(IsActive);
            this.PLabID = Util.GetString(PLabID);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Name", Name),
                new MySqlParameter("@Description", Description),
                new MySqlParameter("@CreaterID", CreaterID),
                new MySqlParameter("@IsActive", IsActive),
                new MySqlParameter("@PLabID", PLabID));

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return RowAffected;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            //Util.WriteLog(ex);
            throw (ex);
        }
    }

    public int Delete(string iPkValue)
    {
        this.CreaterID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM PackageLab_Master WHERE PLabID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("PLabID", PLabID));
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return iRetValue;
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

    #endregion All Public Member Function
}
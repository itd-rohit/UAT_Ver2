#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

public class Investigation_ObservationType
{
    #region All Memory Variables

    private int _Investigation_ObservationType_ID;
    private int _Investigation_ID;
    private int _ObservationType_ID;
    private string _Ownership;
    private int _Creator_ID;
    private string _GroupID;
    private string _SampleType;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Investigation_ObservationType()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Investigation_ObservationType(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual int Investigation_ObservationType_ID
    {
        get
        {
            return _Investigation_ObservationType_ID;
        }
        set
        {
            _Investigation_ObservationType_ID = value;
        }
    }

    public virtual int Investigation_ID
    {
        get
        {
            return _Investigation_ID;
        }
        set
        {
            _Investigation_ID = value;
        }
    }

    public virtual int ObservationType_ID
    {
        get
        {
            return _ObservationType_ID;
        }
        set
        {
            _ObservationType_ID = value;
        }
    }

    public virtual string Ownership
    {
        get
        {
            return _Ownership;
        }
        set
        {
            _Ownership = value;
        }
    }

    public virtual int Creator_ID
    {
        get
        {
            return _Creator_ID;
        }
        set
        {
            _Creator_ID = value;
        }
    }

    public virtual string GroupID
    {
        get
        {
            return _GroupID;
        }
        set
        {
            _GroupID = value;
        }
    }

    //public virtual string SampleType
    //{
    //    get
    //    {
    //        return _SampleType;
    //    }
    //    set
    //    {
    //        _SampleType = value;
    //    }
    //}

    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO Investigation_ObservationType (Investigation_ObservationType_ID,  Investigation_ID, ObservationType_ID, ");
            objSQL.Append("Ownership, GroupID, Creator_ID)");
            objSQL.Append("VALUES (@Investigation_ObservationType_ID,@Investigation_ID,@ObservationType_ID,@Ownership,@GroupID,@Creator_ID)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.Investigation_ObservationType_ID = Util.GetInt(Investigation_ObservationType_ID);
            this.Investigation_ID = Investigation_ID;
            this.ObservationType_ID = Util.GetInt(ObservationType_ID);
            this.Ownership = Util.GetString(Ownership);
            this.GroupID = Util.GetString(GroupID);
            this.Creator_ID = Util.GetInt(Creator_ID);

            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                new MySqlParameter("@Investigation_ObservationType_ID", Investigation_ObservationType_ID),
                new MySqlParameter("@Investigation_ID", Investigation_ID),
                new MySqlParameter("@ObservationType_ID", ObservationType_ID),
                new MySqlParameter("@Ownership", Ownership),
                new MySqlParameter("@GroupID", GroupID),
                new MySqlParameter("@Creator_ID", Creator_ID));

            iPkValue = Util.GetInt(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, "select @@identity as AutoKey"));

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
            throw (ex);
        }
    }

    #endregion All Public Member Function
}
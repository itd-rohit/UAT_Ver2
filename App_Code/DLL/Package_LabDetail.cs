using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class PackageLab_Detail
{
    #region All Memory Variables

    private int _Plab_DetailID;
    private string _PLabID;
    private string _InvestigationID;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public PackageLab_Detail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public PackageLab_Detail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual int Plab_DetailID
    {
        get
        {
            return _Plab_DetailID;
        }
        set
        {
            _Plab_DetailID = value;
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

    public virtual string InvestigationID
    {
        get
        {
            return _InvestigationID;
        }
        set
        {
            _InvestigationID = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO package_labdetail(PLabID,InvestigationID) Values (@PLabID, @InvestigationID)");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.PLabID = Util.GetString(PLabID);
            this.InvestigationID = Util.GetString(InvestigationID);
            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
            new MySqlParameter("@PLabID", PLabID),
            new MySqlParameter("@InvestigationID", InvestigationID));

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
            objSQL.Append("UPDATE package_labdetail SET InvestigationID=?,PLabID = ? WHERE Plab_DetailID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            //this.Fluid_ID = Util.GetString(Fluid_ID);
            this.PLabID = Util.GetString(PLabID);
            this.Plab_DetailID = Util.GetInt(Plab_DetailID);
            this.InvestigationID = Util.GetString(InvestigationID);
            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

            new MySqlParameter("@Plab_DetailID", Plab_DetailID),
            new MySqlParameter("@InvestigationID", InvestigationID),
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

    //////public int Delete(int iPkValue)
    //////{
    //////    this.Plab_DetailID = iPkValue;
    //////    return this.Delete();
    //////}

    //////public int Delete()
    //////{
    //////    try
    //////    {
    //////        int iRetValue;
    //////        StringBuilder objSQL = new StringBuilder();
    //////        objSQL.Append("DELETE FROM package_labdetail WHERE Plab_DetailID = ?");

    //////        if (IsLocalConn)
    //////        {
    //////            this.objCon.Open();
    //////            this.objTrans = this.objCon.BeginTransaction();
    //////        }

    //////        iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

    //////            new MySqlParameter("Plab_DetailID", Plab_DetailID));
    //////        if (IsLocalConn)
    //////        {
    //////            this.objTrans.Commit();
    //////            this.objCon.Close();
    //////        }
    //////        return iRetValue;
    //////    }
    //////    catch (Exception ex)
    //////    {
    //////        if (IsLocalConn)
    //////        {
    //////            if (objTrans != null) this.objTrans.Rollback();
    //////            if (objCon.State == ConnectionState.Open) objCon.Close();
    //////        }
    //////       // Util.WriteLog(ex);
    //////        throw (ex);
    //////    }
    //////}

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM package_labdetail WHERE PlabID = '" + PLabID + "'");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString());

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
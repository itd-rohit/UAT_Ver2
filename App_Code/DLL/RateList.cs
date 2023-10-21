using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class RateList
{
    #region All Memory Variables

    private int _ID;
    private string _RateListID;
    private string _StockID;
    private decimal _Rate;
    private decimal _mrprate;
    private decimal _ERate;
    private int _IsTaxable;
    private DateTime _FromDate;
    private DateTime _ToDate;
    private int _IsCurrent;
    private int _ItemID;
    private string _IsService;
    private decimal _Commission;
    private int _Panel_ID;
    private string _ItemDisplayName;
    private string _ItemCode;
    private string _UpdateBy;
    private DateTime _UpdateDate;
    private string _UpdateRemarks;
    private string _RateType;
    private int _SpecialFlag;
    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public RateList()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public RateList(MySqlTransaction objTrans)
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

    public virtual string RateListID
    {
        get
        {
            return _RateListID;
        }
        set
        {
            _RateListID = value;
        }
    }

   

    public virtual string StockID
    {
        get
        {
            return _StockID;
        }
        set
        {
            _StockID = value;
        }
    }

    public virtual decimal Rate
    {
        get
        {
            return _Rate;
        }
        set
        {
            _Rate = value;
        }
    }

    public virtual decimal MrpRate
    {
        get
        {
            return _mrprate;
        }
        set
        {
            _mrprate = value;
        }
    }

    public virtual decimal ERate
    {
        get
        {
            return _ERate;
        }
        set
        {
            _ERate = value;
        }
    }

    public virtual int IsTaxable
    {
        get
        {
            return _IsTaxable;
        }
        set
        {
            _IsTaxable = value;
        }
    }

    public virtual DateTime FromDate
    {
        get
        {
            return _FromDate;
        }
        set
        {
            _FromDate = value;
        }
    }

    public virtual DateTime ToDate
    {
        get
        {
            return _ToDate;
        }
        set
        {
            _ToDate = value;
        }
    }

    public virtual int IsCurrent
    {
        get
        {
            return _IsCurrent;
        }
        set
        {
            _IsCurrent = value;
        }
    }

    public virtual int ItemID
    {
        get
        {
            return _ItemID;
        }
        set
        {
            _ItemID = value;
        }
    }

    public virtual string IsService
    {
        get
        {
            return _IsService;
        }
        set
        {
            _IsService = value;
        }
    }

    public virtual decimal Commission
    {
        get
        {
            return _Commission;
        }
        set
        {
            _Commission = value;
        }
    }

    public virtual int Panel_ID
    {
        get
        {
            return _Panel_ID;
        }
        set
        {
            _Panel_ID = value;
        }
    }

    public virtual string ItemDisplayName
    {
        get
        {
            return _ItemDisplayName;
        }
        set
        {
            _ItemDisplayName = value;
        }
    }

    public virtual string ItemCode
    {
        get
        {
            return _ItemCode;
        }
        set
        {
            _ItemCode = value;
        }
    }

    public virtual string UpdateBy
    {
        get
        {
            return _UpdateBy;
        }
        set
        {
            _UpdateBy = value;
        }
    }

    public virtual string UpdateRemarks
    {
        get
        {
            return _UpdateRemarks;
        }
        set
        {
            _UpdateRemarks = value;
        }
    }

    public virtual string RateType
    {
        get
        {
            return _RateType;
        }
        set
        {
            _RateType = value;
        }
    }

    public virtual System.DateTime UpdateDate
    {
        get
        {
            return _UpdateDate;
        }
        set
        {
            _UpdateDate = value;
        }
    }
    public virtual int SpecialFlag
    {
        get
        {
            return _SpecialFlag;
        }
        set
        {
            _SpecialFlag = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_RateList");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@RateListID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;
            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            this.StockID = Util.GetString(StockID);
            this.Rate = Rate;
            this.ERate = ERate;
            this.IsTaxable = IsTaxable;
            this.FromDate = Util.GetDateTime(FromDate);
            this.ToDate = Util.GetDateTime(ToDate);
            this.IsCurrent = Util.GetInt(IsCurrent);
            this.ItemID =ItemID;
            this.IsService = Util.GetString(IsService);
            this.Commission = Commission;
            this.Panel_ID = Panel_ID;
            this.ItemDisplayName = Util.GetString(ItemDisplayName);
            this.ItemCode = Util.GetString(ItemCode);
            this.UpdateBy = Util.GetString(UpdateBy);
            this.UpdateRemarks = Util.GetString(UpdateRemarks);
            this.RateType = Util.GetString(RateType);
            this.UpdateDate = Util.GetDateTime(UpdateDate);
            this.MrpRate =MrpRate;
            this.SpecialFlag = Util.GetInt(SpecialFlag);
            cmd.Parameters.Add(new MySqlParameter("@StockID", StockID));
            cmd.Parameters.Add(new MySqlParameter("@Rate", Rate));
            cmd.Parameters.Add(new MySqlParameter("@vErate", ERate));
            cmd.Parameters.Add(new MySqlParameter("@IsTaxable", IsTaxable));
            cmd.Parameters.Add(new MySqlParameter("@FromDate", FromDate));
            cmd.Parameters.Add(new MySqlParameter("@ToDate", ToDate));
            cmd.Parameters.Add(new MySqlParameter("@IsCurrent", IsCurrent));
            cmd.Parameters.Add(new MySqlParameter("@ItemID", ItemID));
            cmd.Parameters.Add(new MySqlParameter("@IsService", IsService));
            cmd.Parameters.Add(new MySqlParameter("@Commission", Commission));
            cmd.Parameters.Add(new MySqlParameter("@Panel_ID", Panel_ID));
            cmd.Parameters.Add(new MySqlParameter("@ItemDisplayName", ItemDisplayName));
            cmd.Parameters.Add(new MySqlParameter("@ItemCode", ItemCode));
            cmd.Parameters.Add(new MySqlParameter("@UpdateBy", UpdateBy));
            cmd.Parameters.Add(new MySqlParameter("@UpdateRemarks", UpdateRemarks));
            cmd.Parameters.Add(new MySqlParameter("@RateType", RateType));
            cmd.Parameters.Add(new MySqlParameter("@UpdateDate", UpdateDate));
            cmd.Parameters.Add(new MySqlParameter("@mrp_rate", MrpRate));
            cmd.Parameters.Add(new MySqlParameter("@SpecialFlag", SpecialFlag));
            cmd.Parameters.Add(paramTnxID);
            RateListID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return RateListID;
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

    public int UpdateRate()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE f_ratelist SET ToDate=? WHERE StockID = ? and ToDate='' ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.ToDate = Util.GetDateTime(ToDate);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@ToDate", ToDate));
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

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE f_ratelist SET StockID=?,Rate=?,IsTaxable=?,FromDate=?,ToDate=?,IsCurrent=?,ItemID=?,IsService=?,Commission=?,Panel_ID=? WHERE RateListID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.StockID = Util.GetString(StockID);
            this.Rate = Rate;
            this.IsTaxable = Util.GetInt(IsTaxable);
            this.FromDate = Util.GetDateTime(FromDate);
            this.ToDate = Util.GetDateTime(ToDate);
            this.IsCurrent = Util.GetInt(IsCurrent);
            this.RateListID = Util.GetString(RateListID);
            this.ItemID =ItemID;
            this.IsService = Util.GetString(IsService);
            this.Commission = Commission;
            this.Panel_ID = Panel_ID;

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                new MySqlParameter("@StockID", StockID),
                new MySqlParameter("@Rate", Rate),
                new MySqlParameter("@IsTaxable", IsTaxable),
                new MySqlParameter("@FromDate", FromDate),
                new MySqlParameter("@ToDate", ToDate),
                new MySqlParameter("@RateListID", RateListID),
                new MySqlParameter("@ItemID", ItemID),
                new MySqlParameter("@IsService", IsService),
                new MySqlParameter("@Commission", Commission),
                new MySqlParameter("@Panel_ID", Panel_ID));

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

    public int Delete(int iPkValue)
    {
        this.RateListID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM f_ratelist WHERE RateListID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("RateListID", RateListID));
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
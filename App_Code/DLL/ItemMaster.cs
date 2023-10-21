using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for ItemMaster
/// </summary>
public class ItemMaster
{
    #region All Memory Variables

    private int _ID;
    private int _ItemID;
    private int _SubCategoryID;
    private int _Type_ID;
    private string _TypeName;
    private int _IsActive;
    private string _IsTrigger;
    private string _Inv_ShortName;
    private int _CreaterID;
    private string _TestCode;
    private string _UpdatedBy;
    private DateTime _UpdateDate;
    private int _MaxDiscount;
    private int _Booking;
    public int _BillCategoryID;
    private int _ToBeBilled;
    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public ItemMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public ItemMaster(MySqlTransaction objTrans)
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



    public virtual int SubCategoryID
    {
        get
        {
            return _SubCategoryID;
        }
        set
        {
            _SubCategoryID = value;
        }
    }

    public virtual int Type_ID
    {
        get
        {
            return _Type_ID;
        }
        set
        {
            _Type_ID = value;
        }
    }

    public virtual string TypeName
    {
        get
        {
            return _TypeName;
        }
        set
        {
            _TypeName = value;
        }
    }

    public virtual string IsTrigger
    {
        get
        {
            return _IsTrigger;
        }
        set
        {
            _IsTrigger = value;
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

    public virtual int ToBeBilled
    {
        get
        {
            return _ToBeBilled;
        }
        set
        {
            _ToBeBilled = value;
        }
    }

    private string _Unit;

    public virtual string Unit
    {
        get { return _Unit; }
        set { _Unit = value; }
    }

   

    public virtual string Inv_ShortName
    {
        get
        {
            return _Inv_ShortName;
        }
        set
        {
            _Inv_ShortName = value;
        }
    }
    public virtual int CreaterID
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

    public virtual string TestCode
    {
        get
        {
            return _TestCode;
        }
        set
        {
            _TestCode = value;
        }
    }

    public virtual DateTime UpdateDate
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

    public virtual string UpdatedBy
    {
        get
        {
            return _UpdatedBy;
        }
        set
        {
            _UpdatedBy = value;
        }
    }

    public virtual int MaxDiscount
    {
        get
        {
            return _MaxDiscount;
        }
        set
        {
            _MaxDiscount = value;
        }
    }

    public virtual int Booking
    {
        get
        {
            return _Booking;
        }
        set
        {
            _Booking = value;
        }
    }

    public virtual int BillCategoryID
    {
        get
        {
            return _BillCategoryID;
        }
        set
        {
            _BillCategoryID = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_ItemMaster");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@Item_ID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            this.SubCategoryID = Util.GetInt(SubCategoryID);
            this.Type_ID = Util.GetInt(Type_ID);
            this.TypeName = Util.GetString(TypeName);
            this.IsActive = Util.GetInt(IsActive);
            this.Unit = Util.GetString(Unit);
            this._Inv_ShortName = Util.GetString(Inv_ShortName);
            this.IsTrigger = Util.GetString(IsTrigger);
            this.CreaterID = Util.GetInt(CreaterID);
            this.TestCode = Util.GetString(TestCode);
            this.UpdatedBy = Util.GetString(UpdatedBy);
            this.MaxDiscount = Util.GetInt(MaxDiscount);
            this.Booking = Util.GetInt(Booking);
            this._BillCategoryID = Util.GetInt(BillCategoryID);
            this.ToBeBilled = Util.GetInt(ToBeBilled);
            cmd.Parameters.Add(new MySqlParameter("@SubCategoryID", SubCategoryID));
            cmd.Parameters.Add(new MySqlParameter("@Type_ID", Type_ID));
            cmd.Parameters.Add(new MySqlParameter("@TypeName", TypeName));
            cmd.Parameters.Add(new MySqlParameter("@IsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@vUnit", Unit));
            cmd.Parameters.Add(new MySqlParameter("@IsTrigger", IsTrigger));
            cmd.Parameters.Add(new MySqlParameter("@Inv_ShortName", Inv_ShortName));
            cmd.Parameters.Add(new MySqlParameter("@CreaterID", CreaterID));
            cmd.Parameters.Add(new MySqlParameter("@TestCode", TestCode));
            cmd.Parameters.Add(new MySqlParameter("@UpdatedBy", UpdatedBy));
            cmd.Parameters.Add(new MySqlParameter("@UpdateDate", UpdateDate));
            cmd.Parameters.Add(new MySqlParameter("@MaxDiscount", MaxDiscount));
            cmd.Parameters.Add(new MySqlParameter("@Booking", Booking));
            cmd.Parameters.Add(new MySqlParameter("@BillCategoryID", BillCategoryID));
            cmd.Parameters.Add(new MySqlParameter("@ToBeBilled", ToBeBilled));
            cmd.Parameters.Add(paramTnxID);
            ItemID =Util.GetInt( cmd.ExecuteScalar().ToString());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return ItemID.ToString();
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

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE f_itemmaster SET SubCategoryID=?,Type_ID=?,TypeName=?,IsActive=?,TestCode=? WHERE ItemID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.ItemID = Util.GetInt(ItemID);
            this.SubCategoryID = Util.GetInt(SubCategoryID);
            this.Type_ID = Util.GetInt(Type_ID);
            this.TypeName = Util.GetString(TypeName);
            this.IsActive = Util.GetInt(IsActive);
            this.TestCode = Util.GetString(TestCode);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                new MySqlParameter("@SubCategoryID", SubCategoryID),
                new MySqlParameter("@Type_ID", Type_ID),
                new MySqlParameter("@TypeName", TypeName),
                new MySqlParameter("@IsActive", IsActive),
                 new MySqlParameter("@TestCode", TestCode),
                new MySqlParameter("@ItemID", ItemID));

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
            throw (ex);
        }
    }

   

    #endregion All Public Member Function
}
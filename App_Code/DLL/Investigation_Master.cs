#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

public class Investigation_Master
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _Investigation_ID;
    private string _Name;
    private string _Description;
    private string _Type;
    private string _Ownership;
    private string _Creator_ID;
    private string _Group_ID;
    private string _FileLimitationName;
    private int _ReportType;
    private int _Print_Sequence;
    private string _TimeLimit;
    private string _SampleQty;
    private string _SampleRemarks;
    private int _printHeader;
    private int _ShowFlag;
    private int _ShowOnline;
    private string _GenderInvestigate;
    private string _ColorCode;
    private int _isAutoStore;
    private string _TestCode;
    private string _Sample_Name;
    private string _Method;
    private int _isUrgent;
    private int _reporting;
    private int _IsOrganism;
    private int _ShowinTAT;
    private int _IsCulture;
    private int _IsMic;
    private int _PrintSeparate;
    private int _PrintSampleName;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Investigation_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Investigation_Master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual int Print_Sequence
    {
        get
        {
            return _Print_Sequence;
        }
        set
        {
            _Print_Sequence = value;
        }
    }

    
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

    public virtual string Investigation_ID
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

    public virtual string Type
    {
        get
        {
            return _Type;
        }
        set
        {
            _Type = value;
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

    public virtual string Creator_ID
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

    public virtual string Group_ID
    {
        get
        {
            return _Group_ID;
        }
        set
        {
            _Group_ID = value;
        }
    }

    public virtual string FileLimitationName
    {
        get
        {
            return _FileLimitationName;
        }
        set
        {
            _FileLimitationName = value;
        }
    }

    public virtual int ReportType
    {
        get
        {
            return _ReportType;
        }
        set
        {
            _ReportType = value;
        }
    }

    public virtual string TimeLimit
    {
        get { return _TimeLimit; }
        set { _TimeLimit = value; }
    }

    public virtual string SampleQty
    {
        get
        {
            return _SampleQty;
        }
        set
        {
            _SampleQty = value;
        }
    }

    public virtual string SampleRemarks
    {
        get
        {
            return _SampleRemarks;
        }
        set
        {
            _SampleRemarks = value;
        }
    }

    public virtual int printHeader
    {
        get
        {
            return _printHeader;
        }
        set
        {
            _printHeader = value;
        }
    }

    public virtual int ShowFlag
    {
        get
        {
            return _ShowFlag;
        }
        set
        {
            _ShowFlag = value;
        }
    }

    public virtual int ShowOnline
    {
        get
        {
            return _ShowOnline;
        }
        set
        {
            _ShowOnline = value;
        }
    }

    public virtual int ShowinTAT
    {
        get
        {
            return _ShowinTAT;
        }
        set
        {
            _ShowinTAT = value;
        }
    }

    public virtual string GenderInvestigate
    {
        get
        {
            return _GenderInvestigate;
        }
        set
        {
            _GenderInvestigate = value;
        }
    }

    public virtual string ColorCode
    {
        get
        {
            return _ColorCode;
        }
        set
        {
            _ColorCode = value;
        }
    }

    public virtual int isAutoStore
    {
        get
        {
            return _isAutoStore;
        }
        set
        {
            _isAutoStore = value;
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

    public virtual string Sample_Name
    {
        get
        {
            return _Sample_Name;
        }
        set
        {
            _Sample_Name = value;
        }
    }

    public virtual string Method
    {
        get
        {
            return _Method;
        }
        set
        {
            _Method = value;
        }
    }

    public virtual int isUrgent
    {
        get
        {
            return _isUrgent;
        }
        set
        {
            _isUrgent = value;
        }
    }

    public virtual int Reporting
    {
        get
        {
            return _reporting;
        }
        set
        {
            _reporting = value;
        }
    }

    public virtual int IsOrganism
    {
        get
        {
            return _IsOrganism;
        }
        set
        {
            _IsOrganism = value;
        }
    }

    public virtual int IsCulture
    {
        get
        {
            return _IsCulture;
        }
        set
        {
            _IsCulture = value;
        }
    }

    public virtual int IsMic
    {
        get
        {
            return _IsMic;
        }
        set
        {
            _IsMic = value;
        }
    }

    public virtual int PrintSeparate
    {
        get
        {
            return _PrintSeparate;
        }
        set
        {
            _PrintSeparate = value;
        }
    }

    public virtual int PrintSampleName
    {
        get
        {
            return _PrintSampleName;
        }
        set
        {
            _PrintSampleName = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Investigation");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@InvestID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Investigation_ID = Util.GetString(Investigation_ID);
            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.Type = Util.GetString(Type);
            this.Ownership = Util.GetString(Ownership);
            this.Creator_ID = Util.GetString(Creator_ID);
            this.Group_ID = Util.GetString(Group_ID);
            this.FileLimitationName = Util.GetString(FileLimitationName);
            this.ReportType = Util.GetInt(ReportType);
            this.Print_Sequence = Util.GetInt(Print_Sequence);
            this.SampleQty = Util.GetString(SampleQty);
            this.SampleRemarks = Util.GetString(SampleRemarks);
            this.printHeader = Util.GetInt(printHeader);
            this.ShowFlag = Util.GetInt(ShowFlag);
            this.ShowOnline = Util.GetInt(ShowOnline);
            this.GenderInvestigate = Util.GetString(GenderInvestigate);
            this.ColorCode = Util.GetString(ColorCode);
            this.isAutoStore = Util.GetInt(isAutoStore);
            this.TestCode = Util.GetString(TestCode);
            this.Sample_Name = Util.GetString(Sample_Name);
            this.Method = Util.GetString(Method);
            this.isUrgent = Util.GetInt(isUrgent);
            this.ShowinTAT = Util.GetInt(ShowinTAT);
            this.Reporting = Util.GetInt(Reporting);
            this.IsOrganism = Util.GetInt(IsOrganism);
            this.IsCulture = Util.GetInt(IsCulture);
            this.IsMic = Util.GetInt(IsMic);
            this.PrintSeparate = Util.GetInt(PrintSeparate);
            this._PrintSampleName = Util.GetInt(PrintSampleName);

            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
            cmd.Parameters.Add(new MySqlParameter("@Description", Description));
            cmd.Parameters.Add(new MySqlParameter("@TYPE", Type));
            cmd.Parameters.Add(new MySqlParameter("@Ownership", Ownership));
            cmd.Parameters.Add(new MySqlParameter("@Group_ID", Group_ID));
            cmd.Parameters.Add(new MySqlParameter("@Creator_ID", Creator_ID));
            cmd.Parameters.Add(new MySqlParameter("@FileName", FileLimitationName));
            cmd.Parameters.Add(new MySqlParameter("@ReportType", ReportType));
            cmd.Parameters.Add(new MySqlParameter("@Print_Sequence", Print_Sequence));
            cmd.Parameters.Add(new MySqlParameter("@TimeLimit", TimeLimit));
            cmd.Parameters.Add(new MySqlParameter("@SampleQty", SampleQty));
            cmd.Parameters.Add(new MySqlParameter("@SampleRemarks", SampleRemarks));
            cmd.Parameters.Add(new MySqlParameter("@printHeader", printHeader));
            cmd.Parameters.Add(new MySqlParameter("@ShowFlag", ShowFlag));
            cmd.Parameters.Add(new MySqlParameter("@ShowOnline", ShowOnline));
            cmd.Parameters.Add(new MySqlParameter("@GenderInvestigate", GenderInvestigate));
            cmd.Parameters.Add(new MySqlParameter("@ColorCode", ColorCode));
            cmd.Parameters.Add(new MySqlParameter("@isAutoStore", isAutoStore));
            cmd.Parameters.Add(new MySqlParameter("@TestCode", TestCode));
            cmd.Parameters.Add(new MySqlParameter("@Sample_Name", Sample_Name));
            cmd.Parameters.Add(new MySqlParameter("@Method", Method));
            cmd.Parameters.Add(new MySqlParameter("@isUrgent", isUrgent));
            cmd.Parameters.Add(new MySqlParameter("@ShowinTat", ShowinTAT));
            cmd.Parameters.Add(new MySqlParameter("@Reporting", Reporting));
            cmd.Parameters.Add(new MySqlParameter("@IsOrganism", IsOrganism));
            cmd.Parameters.Add(new MySqlParameter("@IsCulture", IsCulture));
            cmd.Parameters.Add(new MySqlParameter("@isMic", IsMic));
            cmd.Parameters.Add(new MySqlParameter("@PrintSeparate", PrintSeparate));
            cmd.Parameters.Add(new MySqlParameter("@PrintSampleName", PrintSampleName));

            cmd.Parameters.Add(paramTnxID);
            Investigation_ID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Investigation_ID;
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
            objSQL.Append("UPDATE Investigation_Master SET Name = ?, Description = ?,Type =?,");
            objSQL.Append("Ownership= ?, Creator_ID=?, Group_ID = ?, FileLimitationName = ?, ReportType = ?,Print_Sequence=? WHERE Investigation_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Name", Name),
                new MySqlParameter("@Description", Description),
                new MySqlParameter("@Type", Type),
                new MySqlParameter("@Ownership", Ownership),
                new MySqlParameter("@Creator_ID", Creator_ID),
                new MySqlParameter("@Group_ID", Group_ID),
                new MySqlParameter("@FileLimitationName", FileLimitationName),
                new MySqlParameter("@ReportType", ReportType),
                new MySqlParameter("@Investigation_ID", Investigation_ID));
            new MySqlParameter("@Print_Sequence", Print_Sequence);
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

    public int Delete(int iPkValue)
    {
        this.Investigation_ID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM Investigation_Master WHERE Investigation_ID = ?");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("Investigation_ID", Investigation_ID));
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
            throw (ex);
        }
    }

    #endregion All Public Member Function
}
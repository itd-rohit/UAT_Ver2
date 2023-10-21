#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

public class Labobservation_master
{
    #region All Memory Variables

   
    private int _ID;
    private string _LabObservation_ID;
    private string _Name;
    private string _Description;
    private string _DefaultDescription;
    private string _Minimum;
    private string _Maximum;
    private string _DefaultValue;
    private string _ReadingFormat;
    private string _Ownership;
    private string _Creator_ID;
    private string _GroupID;
    private int _Child_Flag;
    private string _ParentID;
    private int _Culture_Flag;
    private string _MinFemale;
    private string _MaxFemale;
    private string _MinChild;
    private string _MaxChild;
    private string _Suffix;
    private string _Shortname;
    private int _ShowFlag;
    private int _RoundUpto;
    private string _Gender;
    private int _PrintSeparate;
    private int _PrintInLabReport;
    private int _AllowDuplicateBooking;
    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Labobservation_master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Labobservation_master(MySqlTransaction objTrans)
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

    public virtual string LabObservation_ID
    {
        get
        {
            return _LabObservation_ID;
        }
        set
        {
            _LabObservation_ID = value;
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

    public virtual string DefaultDescription
    {
        get
        {
            return _DefaultDescription;
        }
        set
        {
            _DefaultDescription = value;
        }
    }

    public virtual string Minimum
    {
        get
        {
            return _Minimum;
        }
        set
        {
            _Minimum = value;
        }
    }

    public virtual string Maximum
    {
        get
        {
            return _Maximum;
        }
        set
        {
            _Maximum = value;
        }
    }

    public virtual string DefaultValue
    {
        get
        {
            return _DefaultValue;
        }
        set
        {
            _DefaultValue = value;
        }
    }

    public virtual string ReadingFormat
    {
        get
        {
            return _ReadingFormat;
        }
        set
        {
            _ReadingFormat = value;
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

    public virtual int Child_Flag
    {
        get
        {
            return _Child_Flag;
        }
        set
        {
            _Child_Flag = value;
        }
    }

    public virtual string ParentID
    {
        get
        {
            return _ParentID;
        }
        set
        {
            _ParentID = value;
        }
    }

    public virtual int Culture_Flag
    {
        get
        {
            return _Culture_Flag;
        }
        set
        {
            _Culture_Flag = value;
        }
    }

    public virtual string MaxFemale
    {
        get
        {
            return _MaxFemale;
        }
        set
        {
            _MaxFemale = value;
        }
    }

    public virtual string MinFemale
    {
        get
        {
            return _MinFemale;
        }
        set
        {
            _MinFemale = value;
        }
    }

    public virtual string MaxChild
    {
        get
        {
            return _MaxChild;
        }
        set
        {
            _MaxChild = value;
        }
    }

    public virtual string MinChild
    {
        get
        {
            return _MinChild;
        }
        set
        {
            _MinChild = value;
        }
    }

    public virtual string Suffix
    {
        get
        {
            return _Suffix;
        }
        set
        {
            _Suffix = value;
        }
    }

    public virtual string Shortname
    {
        get
        {
            return _Shortname;
        }
        set
        {
            _Shortname = value;
        }
    }

    public virtual string Gender
    {
        get
        {
            return _Gender;
        }
        set
        {
            _Gender = value;
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

    public virtual int RoundUpto
    {
        get
        {
            return _RoundUpto;
        }
        set
        {
            _RoundUpto = value;
        }
    }
    public virtual int PrintInLabReport
    {
        get
        {
            return _PrintInLabReport;
        }
        set
        {
            _PrintInLabReport = value;
        }
    }
    public virtual int AllowDuplicateBooking
    {
        get
        {
            return _AllowDuplicateBooking;
        }
        set
        {
            _AllowDuplicateBooking = value;
        }
    }
    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_LabObesarvation");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@LabObservationTypeID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            this.Name = Util.GetString(Name);
            this.Description = Util.GetString(Description);
            this.DefaultDescription = Util.GetString(DefaultDescription);
            this.Minimum = Util.GetString(Minimum);
            this.Maximum = Util.GetString(Maximum);
            this.DefaultValue = Util.GetString(DefaultValue);
            this.ReadingFormat = Util.GetString(ReadingFormat);
            this.Ownership = Util.GetString(Ownership);
            this.Creator_ID = Util.GetString(Creator_ID);
            this.GroupID = Util.GetString(GroupID);
            this.Child_Flag = Util.GetInt(Child_Flag);
            this.ParentID = Util.GetString(ParentID);
            this.Culture_Flag = Util.GetInt(Culture_Flag);
            this.MaxFemale = Util.GetString(MaxFemale);
            this.MinFemale = Util.GetString(MinFemale);
            this.MaxChild = Util.GetString(MaxChild);
            this.MinChild = Util.GetString(MinChild);
            this.Suffix = Util.GetString(Suffix);
            this.Shortname = Util.GetString(Shortname);
            this.Gender = Util.GetString(Gender);
            this.PrintSeparate = Util.GetInt(PrintSeparate);
            this.ShowFlag = Util.GetInt(ShowFlag);
            this.RoundUpto = Util.GetInt(RoundUpto);
            this.PrintSeparate = Util.GetInt(PrintInLabReport);
            this.PrintSeparate = Util.GetInt(AllowDuplicateBooking);

            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
            cmd.Parameters.Add(new MySqlParameter("@Description", Description));
            cmd.Parameters.Add(new MySqlParameter("@DefaultDescription", DefaultDescription));
            cmd.Parameters.Add(new MySqlParameter("@Minimum", Minimum));
            cmd.Parameters.Add(new MySqlParameter("@Maximum", Maximum));
            cmd.Parameters.Add(new MySqlParameter("@DefaultValue", DefaultValue));
            cmd.Parameters.Add(new MySqlParameter("@ReadingFormat", ReadingFormat));
            cmd.Parameters.Add(new MySqlParameter("@Ownership", Ownership));
            cmd.Parameters.Add(new MySqlParameter("@Creator_ID", Creator_ID));
            cmd.Parameters.Add(new MySqlParameter("@GroupID", GroupID));
            cmd.Parameters.Add(new MySqlParameter("@Child_Flag", Child_Flag));
            cmd.Parameters.Add(new MySqlParameter("@ParentID", ParentID));
            cmd.Parameters.Add(new MySqlParameter("@Culture_Flag", Culture_Flag));
            cmd.Parameters.Add(new MySqlParameter("@MaxFemale", MaxFemale));
            cmd.Parameters.Add(new MySqlParameter("@MinFemale", MinFemale));
            cmd.Parameters.Add(new MySqlParameter("@MaxChild", MaxChild));
            cmd.Parameters.Add(new MySqlParameter("@MinChild", MinChild));
            cmd.Parameters.Add(new MySqlParameter("@Suffix", Suffix));
            cmd.Parameters.Add(new MySqlParameter("@Shortname", Shortname));
            cmd.Parameters.Add(new MySqlParameter("@Gender", Gender));
            cmd.Parameters.Add(new MySqlParameter("@PrintSeparate", PrintSeparate));
            cmd.Parameters.Add(new MySqlParameter("@ShowFlag", ShowFlag));
            cmd.Parameters.Add(new MySqlParameter("@RoundUpto", RoundUpto));
            cmd.Parameters.Add(new MySqlParameter("@PrintInLabReport", PrintInLabReport));
            cmd.Parameters.Add(new MySqlParameter("@AllowDuplicateBooking", AllowDuplicateBooking));
            cmd.Parameters.Add(paramTnxID);
            string LabObservation_ID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return LabObservation_ID;
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
            objSQL.Append("UPDATE Labobservation_master SET Name = ?, Description = ?, DefaultDescription = ?, Minimum = ?, Maximum = ?,DefaultValue = ? ,");
            objSQL.Append("ReadingFormat = ?, Ownership= ?, Creator_ID=?, GroupID = ?, Child_Flag = ?, ParentID = ?,Culture_Flag = ? ,MaxFemale = ?, MinFemale = ? ,MaxChild = ?, MinChild = ? WHERE LabObservation_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Name", Name),
                new MySqlParameter("@Description", Description),
                new MySqlParameter("@DefaultDescription", DefaultDescription),
                new MySqlParameter("@Minimum", Minimum),
                new MySqlParameter("@Maximum", Maximum),
                new MySqlParameter("@DefaultValue", DefaultValue),
                new MySqlParameter("@ReadingFormat", ReadingFormat),
                new MySqlParameter("@Ownership", Ownership),
                new MySqlParameter("@Creator_ID", Creator_ID),
                new MySqlParameter("@GroupID", GroupID),
                new MySqlParameter("@Child_Flag", Child_Flag),
                new MySqlParameter("@ParentID", ParentID),
                new MySqlParameter("@Culture_Flag", Culture_Flag),
                new MySqlParameter("@LabObservation_ID", LabObservation_ID),
                new MySqlParameter("@MaxFemale", MaxFemale),
                new MySqlParameter("@MinFemale", MinFemale),
                new MySqlParameter("@MaxChild", MaxChild),
                new MySqlParameter("@MinChild", MinChild),
                new MySqlParameter("@Suffix", Suffix),
                new MySqlParameter("@Shortname", Shortname),
                new MySqlParameter("@ShowFlag", ShowFlag));

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
        this.LabObservation_ID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM Labobservation_master WHERE LabObservation_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("LabObservation_ID", LabObservation_ID));
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
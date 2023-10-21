#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

public class DoctorMasterReferal
{
    #region All Memory Variables

    private int _ID;
    private string _Doctor_ID;
    private string _Title;
    private string _Name;
    private string _IMARegistartionNo;
    private string _RegistrationOf;
    private string _RegistrationYear;
    private string _ProfesionalSummary;
    private string _Designation;
    private string _Phone1;
    private string _Phone2;
    private string _Phone3;
    private string _Mobile;
    private string _House_No;
    private string _Street_Name;
    private string _Locality;
    private string _State;
    private string _StateRegion;
    private string _CountryRegion;
    private string _Pincode;
    private string _Email;
    private string _PorfilePageID;
    private string _UserName;
    private string _Password;
    private string _City;
    private string _Gender;
    private string _Degree;
    private string _Specialization;
    public string _DoctorTime;
    private DateTime _DateOfBirth;
    private DateTime _Anniversary;
    private string _AreaName;
    private int _ReferMasterShare;
    private int _allowsharing;
    private int _discountapproved;
    private string _PROID;
    private string _ClinicalAddress;
    private string _AddedBy;
    private string _ClinicName;
    private string _ClinicAddress;
    private string _HospitalName;
    private string _HospitalAddress;
    private string _IsVisible;
    private string _IsLock;

    private string _category;
    private string _doctortype;
    private string _visitday;
    private int _GroupID;
    private int _CentreID;
    private int _ZoneID;
    private string _DoctorCode;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public DoctorMasterReferal()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public DoctorMasterReferal(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property
    public virtual string category { get { return _category; } set { _category = value; } }
    public virtual string doctortype { get { return _doctortype; } set { _doctortype = value; } }
    public virtual string visitday { get { return _visitday; } set { _visitday = value; } }
    public virtual int GroupID { get { return _GroupID; } set { _GroupID = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public virtual int ZoneID { get { return _ZoneID; } set { _ZoneID = value; } }
    public virtual string DoctorCode { get { return _DoctorCode; } set { _DoctorCode = value; } }
    
    public virtual string ClinicalAddress
    {
        get
        {
            return _ClinicalAddress;
        }
        set
        {
            _ClinicalAddress = value;
        }
    }

    public virtual int ReferMasterShare
    {
        get
        {
            return _ReferMasterShare;
        }
        set
        {
            _ReferMasterShare = value;
        }
    }

    public virtual int allowsharing
    {
        get
        {
            return _allowsharing;
        }
        set
        {
            _allowsharing = value;
        }
    }

    public virtual int discountapproved
    {
        get
        {
            return _discountapproved;
        }
        set
        {
            _discountapproved = value;
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

    public virtual string Doctor_ID
    {
        get
        {
            return _Doctor_ID;
        }
        set
        {
            _Doctor_ID = value;
        }
    }

    public virtual string Title
    {
        get
        {
            return _Title;
        }
        set
        {
            _Title = value;
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

    public virtual string IMARegistartionNo
    {
        get
        {
            return _IMARegistartionNo;
        }
        set
        {
            _IMARegistartionNo = value;
        }
    }

    public virtual string RegistrationOf
    {
        get
        {
            return _RegistrationOf;
        }
        set
        {
            _RegistrationOf = value;
        }
    }

    public virtual string RegistrationYear
    {
        get
        {
            return _RegistrationYear;
        }
        set
        {
            _RegistrationYear = value;
        }
    }

    public virtual string ProfesionalSummary
    {
        get
        {
            return _ProfesionalSummary;
        }
        set
        {
            _ProfesionalSummary = value;
        }
    }

    public virtual string Designation
    {
        get
        {
            return _Designation;
        }
        set
        {
            _Designation = value;
        }
    }

    public virtual string Phone1
    {
        get
        {
            return _Phone1;
        }
        set
        {
            _Phone1 = value;
        }
    }

    public virtual string Phone2
    {
        get
        {
            return _Phone2;
        }
        set
        {
            _Phone2 = value;
        }
    }

    public virtual string Phone3
    {
        get
        {
            return _Phone3;
        }
        set
        {
            _Phone3 = value;
        }
    }

    public virtual string Mobile
    {
        get
        {
            return _Mobile;
        }
        set
        {
            _Mobile = value;
        }
    }

    public virtual string House_No
    {
        get
        {
            return _House_No;
        }
        set
        {
            _House_No = value;
        }
    }

    public virtual string Street_Name
    {
        get
        {
            return _Street_Name;
        }
        set
        {
            _Street_Name = value;
        }
    }

    //
    public virtual string Locality
    {
        get
        {
            return _Locality;
        }
        set
        {
            _Locality = value;
        }
    }

    public virtual string State
    {
        get
        {
            return _State;
        }
        set
        {
            _State = value;
        }
    }

    public virtual string StateRegion
    {
        get
        {
            return _StateRegion;
        }
        set
        {
            _StateRegion = value;
        }
    }

    public virtual string CountryRegion
    {
        get
        {
            return _CountryRegion;
        }
        set
        {
            _CountryRegion = value;
        }
    }

    public virtual string Pincode
    {
        get
        {
            return _Pincode;
        }
        set
        {
            _Pincode = value;
        }
    }

    public virtual string Email
    {
        get
        {
            return _Email;
        }
        set
        {
            _Email = value;
        }
    }

    public virtual string PorfilePageID
    {
        get
        {
            return _PorfilePageID;
        }
        set
        {
            _PorfilePageID = value;
        }
    }

    public virtual string UserName
    {
        get
        {
            return _UserName;
        }
        set
        {
            _UserName = value;
        }
    }

    public virtual string Password
    {
        get
        {
            return _Password;
        }
        set
        {
            _Password = value;
        }
    }

    public virtual string City
    {
        get
        {
            return _City;
        }
        set
        {
            _City = value;
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

    public virtual string Degree
    {
        get
        {
            return _Degree;
        }
        set
        {
            _Degree = value;
        }
    }

    public virtual string Specialization
    {
        get
        {
            return _Specialization;
        }
        set
        {
            _Specialization = value;
        }
    }

    public virtual string DoctorTime
    {
        get
        {
            return _DoctorTime;
        }
        set
        {
            _DoctorTime = value;
        }
    }

    public virtual DateTime DateOfBirth
    {
        get
        {
            return _DateOfBirth;
        }
        set
        {
            _DateOfBirth = value;
        }
    }

    public virtual DateTime Anniversary
    {
        get
        {
            return _Anniversary;
        }
        set
        {
            _Anniversary = value;
        }
    }

    public virtual string AreaName
    {
        get
        {
            return _AreaName;
        }
        set
        {
            _AreaName = value;
        }
    }

    public virtual string PROID
    {
        get
        {
            return _PROID;
        }
        set
        {
            _PROID = value;
        }
    }

    public virtual string AddedBy
    {
        get
        {
            return _AddedBy;
        }
        set
        {
            _AddedBy = value;
        }
    }

    public virtual string ClinicName
    {
        get
        {
            return _ClinicName;
        }
        set
        {
            _ClinicName = value;
        }
    }

    public virtual string ClinicAddress
    {
        get
        {
            return _ClinicAddress;
        }
        set
        {
            _ClinicAddress = value;
        }
    }

    public virtual string HospitalName
    {
        get
        {
            return _HospitalName;
        }
        set
        {
            _HospitalName = value;
        }
    }

    public virtual string HospitalAddress
    {
        get
        {
            return _HospitalAddress;
        }
        set
        {
            _HospitalAddress = value;
        }
    }

    public virtual string IsVisible
    {
        get
        {
            return _IsVisible;
        }
        set
        {
            _IsVisible = value;
        }
    }

    public virtual string IsLock
    {
        get
        {
            return _IsLock;
        }
        set
        {
            _IsLock = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            int iPkValue = 0;

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("Insert_DoctorReferal");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@DoctorID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;



            this.Title = Util.GetString(Title);
            this.Name = Util.GetString(Name);
            this.IMARegistartionNo = Util.GetString(IMARegistartionNo);
            this.RegistrationOf = Util.GetString(RegistrationOf);
            this.RegistrationYear = Util.GetString(RegistrationYear);
            this.ProfesionalSummary = Util.GetString(ProfesionalSummary);
            this.Designation = Util.GetString(Designation);
            this.Phone1 = Util.GetString(Phone1);
            this.Phone2 = Util.GetString(Phone2);
            this.Phone3 = Util.GetString(Phone3);
            this.Mobile = Util.GetString(Mobile);
            this.House_No = Util.GetString(House_No);
            this.Street_Name = Util.GetString(Street_Name);
            this.Locality = Util.GetString(Locality);
            this.State = Util.GetString(State);
            this.City = Util.GetString(City);
            this.StateRegion = Util.GetString(StateRegion);
            this.CountryRegion = Util.GetString(CountryRegion);
            this.Pincode = Util.GetString(Pincode);
            this.Gender = Util.GetString(Gender);
            this.Email = Util.GetString(Email);
            this.PorfilePageID = Util.GetString(PorfilePageID);

            this.Specialization = Util.GetString(Specialization);
            this.UserName = Util.GetString(UserName);
            this.Password = Util.GetString(Password);
            this.DoctorTime = Util.GetString(DoctorTime);
            this._DateOfBirth = Util.GetDateTime(DateOfBirth);
            this._Anniversary = Util.GetDateTime(Anniversary);
            this._AreaName = Util.GetString(AreaName);
            this.ReferMasterShare = Util.GetInt(ReferMasterShare);
            this._PROID = Util.GetString(PROID);
            this._ClinicalAddress = Util.GetString(ClinicalAddress);
            this._AddedBy = Util.GetString(AddedBy);
            this._ClinicName = Util.GetString(ClinicName);
            this._ClinicAddress = Util.GetString(ClinicAddress);
            this._HospitalName = Util.GetString(HospitalName);
            this._HospitalAddress = Util.GetString(HospitalAddress);
            this.IsVisible = Util.GetString(IsVisible);
            this.IsLock = Util.GetString(IsLock);
            this.Degree = Util.GetString(Degree);
            this.allowsharing = Util.GetInt(allowsharing);
            this.discountapproved = Util.GetInt(discountapproved);
            this.category = Util.GetString(category);
            this.doctortype = Util.GetString(doctortype);
            this.visitday = Util.GetString(visitday);
            this.GroupID = Util.GetInt(GroupID);
            this.ZoneID = Util.GetInt(ZoneID);
            this.DoctorCode = Util.GetString(DoctorCode);
            
            cmd.Parameters.Add(new MySqlParameter("@Title", Title));
            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
            cmd.Parameters.Add(new MySqlParameter("@IMARegistartionNo", IMARegistartionNo));
            cmd.Parameters.Add(new MySqlParameter("@RegistrationOf", RegistrationOf));
            cmd.Parameters.Add(new MySqlParameter("@RegistrationYear", RegistrationYear));
            cmd.Parameters.Add(new MySqlParameter("@ProfesionalSummary", ProfesionalSummary));
            cmd.Parameters.Add(new MySqlParameter("@Designation", Designation));
            cmd.Parameters.Add(new MySqlParameter("@Phone1", Phone1));
            cmd.Parameters.Add(new MySqlParameter("@Phone2", Phone2));
            cmd.Parameters.Add(new MySqlParameter("@Phone3", Phone3));
            cmd.Parameters.Add(new MySqlParameter("@Mobile", Mobile));
            cmd.Parameters.Add(new MySqlParameter("@House_No", House_No));
            cmd.Parameters.Add(new MySqlParameter("@Street_Name", Street_Name));
            cmd.Parameters.Add(new MySqlParameter("@Locality", Locality));
            cmd.Parameters.Add(new MySqlParameter("@State", State));
            cmd.Parameters.Add(new MySqlParameter("@City", City));
            cmd.Parameters.Add(new MySqlParameter("@StateRegion", StateRegion));
            cmd.Parameters.Add(new MySqlParameter("@CountryRegion", CountryRegion));
            cmd.Parameters.Add(new MySqlParameter("@Pincode", Pincode));
            cmd.Parameters.Add(new MySqlParameter("@Gender", Gender));
            cmd.Parameters.Add(new MySqlParameter("@Email", Email));
            cmd.Parameters.Add(new MySqlParameter("@PorfilePageID", PorfilePageID));
            cmd.Parameters.Add(new MySqlParameter("@Specialization", Specialization));
            cmd.Parameters.Add(new MySqlParameter("@UserName", UserName));
            cmd.Parameters.Add(new MySqlParameter("@PASSWORD", Password));
            cmd.Parameters.Add(new MySqlParameter("@DoctorTime", DoctorTime));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", UserInfo.Centre));
            cmd.Parameters.Add(new MySqlParameter("@DateOfBirth", DateOfBirth));
            cmd.Parameters.Add(new MySqlParameter("@Anniversary", Anniversary));
            cmd.Parameters.Add(new MySqlParameter("@AreaName", AreaName));
            cmd.Parameters.Add(new MySqlParameter("@ReferMasterShare", ReferMasterShare));
            cmd.Parameters.Add(new MySqlParameter("@PROID", PROID));
            cmd.Parameters.Add(new MySqlParameter("@ClinicalAddress", ClinicalAddress));
            cmd.Parameters.Add(new MySqlParameter("@AddedBy", AddedBy));
            cmd.Parameters.Add(new MySqlParameter("@ClinicName", ClinicName));
            cmd.Parameters.Add(new MySqlParameter("@ClinicAddress", ClinicAddress));
            cmd.Parameters.Add(new MySqlParameter("@HospitalName", HospitalName));
            cmd.Parameters.Add(new MySqlParameter("@HospitalAddress", HospitalAddress));
            cmd.Parameters.Add(new MySqlParameter("@IsVisible", IsVisible));
            cmd.Parameters.Add(new MySqlParameter("@IsLock", IsLock));
            cmd.Parameters.Add(new MySqlParameter("@Degree", Degree));
            cmd.Parameters.Add(new MySqlParameter("@allowsharing", allowsharing));
            cmd.Parameters.Add(new MySqlParameter("@discountapproved", discountapproved));

            cmd.Parameters.Add(new MySqlParameter("@category", category));
            cmd.Parameters.Add(new MySqlParameter("@doctortype", doctortype));
            cmd.Parameters.Add(new MySqlParameter("@visitday", visitday));
            cmd.Parameters.Add(new MySqlParameter("@GroupID", GroupID));
            cmd.Parameters.Add(new MySqlParameter("@ZoneID", ZoneID));
            cmd.Parameters.Add(new MySqlParameter("@DoctorCode", DoctorCode));
            
            cmd.Parameters.Add(paramTnxID);

            //cmd.ExecuteNonQuery();

            Doctor_ID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Doctor_ID.ToString();
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
            this.ID = Util.GetInt(ID);
            this.Title = Util.GetString(Title);
            this.Name = Util.GetString(Name);
            this.IMARegistartionNo = Util.GetString(IMARegistartionNo);
            this.RegistrationOf = Util.GetString(RegistrationOf);
            this.RegistrationYear = Util.GetString(RegistrationYear);
            this.ProfesionalSummary = Util.GetString(ProfesionalSummary);
            this.Designation = Util.GetString(Designation);
            this.Phone1 = Util.GetString(Phone1);
            this.Phone2 = Util.GetString(Phone2);
            this.Phone3 = Util.GetString(Phone3);
            this.Mobile = Util.GetString(Mobile);
            this.House_No = Util.GetString(House_No);
            this.Street_Name = Util.GetString(Street_Name);
            this.Locality = Util.GetString(Locality);
            this.State = Util.GetString(State);
            this.StateRegion = Util.GetString(StateRegion);
            this.CountryRegion = Util.GetString(CountryRegion);
            this.Pincode = Util.GetString(Pincode);
            this.Email = Util.GetString(Email);
            this.PorfilePageID = Util.GetString(PorfilePageID);
            this.UserName = Util.GetString(UserName);
            this.Password = Util.GetString(Password);
            this.City = Util.GetString(City);
            this.Gender = Util.GetString(Gender);
            this.DoctorTime = Util.GetString(DoctorTime);

            //this.Specialization = Util.GetString(Specialization);

            int RowAffected;
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("UPDATE doctor_master SET   Title=?, Name=?, IMARegistartionNo=?, RegistrationOf=?, RegistrationYear = ?,ProfesionalSummary=?,Designation=?, Phone1=?,Phone2=?,Phone3=?,Mobile=?,");
            objSQL.Append("House_No = ?, Street_Name = ?, Locality = ?, State = ?, StateRegion = ?, CountryRegion = ?, Pincode = ?,");
            objSQL.Append("Email = ?, PorfilePageID = ?, City = ?,");
            objSQL.Append("Gender = ?, DocDateTime=? WHERE Doctor_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

            new MySqlParameter("@Title", Title),
            new MySqlParameter("@Name", Name),
            new MySqlParameter("@IMARegistartionNo", IMARegistartionNo),
            new MySqlParameter("@RegistrationOf", RegistrationOf),
            new MySqlParameter("@RegistrationYear", RegistrationYear),
            new MySqlParameter("@ProfesionalSummary", ProfesionalSummary),
            new MySqlParameter("@Designation", Designation),
            new MySqlParameter("@Phone1", Phone1),
            new MySqlParameter("@Phone2", Phone2),
            new MySqlParameter("@Phone3", Phone3),
            new MySqlParameter("@Mobile", Mobile),
            new MySqlParameter("@House_No", House_No),
            new MySqlParameter("@Street_Name", Street_Name),
            new MySqlParameter("@Locality", Locality),
            new MySqlParameter("@State", State),
            new MySqlParameter("@StateRegion", StateRegion),
            new MySqlParameter("@CountryRegion", CountryRegion),
            new MySqlParameter("@Pincode", Pincode),
            new MySqlParameter("@Email", Email),
            new MySqlParameter("@PorfilePageID", PorfilePageID),
            new MySqlParameter("@City", City),
            new MySqlParameter("@Gender", Gender),
             new MySqlParameter("@DoctorTime", DoctorTime),
                // new MySqlParameter("@Specialization", Specialization),
            new MySqlParameter("@Doctor_ID", Doctor_ID));
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

    public int Update(string DoctorID)
    {
        this.Doctor_ID = Util.GetString(DoctorID);
        return this.Update();
    }

    public int Delete(string DoctorID)
    {
        this.Doctor_ID = Util.GetString(DoctorID);
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM doctor_master WHERE Doctor_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("Doctor_ID", Doctor_ID));
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
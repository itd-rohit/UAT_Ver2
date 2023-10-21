#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

public class MSTEmployee
{
    #region All Memory Variables

    
    private int _ID;
    private string _Employee_ID;
    private string _Title;
    private string _Name;
    private string _Designation;
    private string _House_No;
    private string _Street_Name;
    private string _Locality;
    private string _City;
    private int _PinCode;
    private string _PHouse_No;
    private string _PStreet_Name;
    private string _PLocality;
    private string _PCity;
    private int _PPinCode;
    private DateTime _DOB;
    private string _Qualification;
    private string _Blood_Group;
    private string _FatherName;
    private string _MotherName;
    private string _ESI_No;
    private string _EPF_No;
    private string _PAN_No;
    private string _Passport_No;

    private string _Email;
    private string _Phone;
    private string _Mobile;
    private DateTime _StartDate;
    private string _AllowSharing;
    private string _AccessDepartment;
    private int _CreatedByID;
    private int _ApproveSpecialRate;
    private int _AmrValueAccess;
	  private int _DesignationID;
    private int _ValidateLogin;
    private int _IsMobileAccess;
    private int _IsHideRate;
    private int _IsEditMacReading;
    private string _CreatedBy;
    private int _IsSampleLogisticReject;
    private int _GlobalReportAccess;
    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public MSTEmployee()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
       
    }

    public MSTEmployee(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

   

    public virtual string AccessDepartment
    {
        get
        {
            return _AccessDepartment;
        }
        set
        {
            _AccessDepartment = value;
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

    public virtual string Employee_ID
    {
        get
        {
            return _Employee_ID;
        }
        set
        {
            _Employee_ID = value;
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

    public virtual string AllowSharing
    {
        get
        {
            return _AllowSharing;
        }
        set
        {
            _AllowSharing = value;
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

    public virtual int PinCode
    {
        get
        {
            return _PinCode;
        }
        set
        {
            _PinCode = value;
        }
    }

    public virtual string PHouse_No
    {
        get
        {
            return _PHouse_No;
        }
        set
        {
            _PHouse_No = value;
        }
    }

    public virtual string PStreet_Name
    {
        get
        {
            return _PStreet_Name;
        }
        set
        {
            _PStreet_Name = value;
        }
    }

    public virtual string PLocality
    {
        get
        {
            return _PLocality;
        }
        set
        {
            _PLocality = value;
        }
    }

    public virtual string PCity
    {
        get
        {
            return _PCity;
        }
        set
        {
            _PCity = value;
        }
    }

    public virtual int PPinCode
    {
        get
        {
            return _PPinCode;
        }
        set
        {
            _PPinCode = value;
        }
    }

    public virtual DateTime DOB
    {
        get
        {
            return _DOB;
        }
        set
        {
            _DOB = value;
        }
    }

    public virtual string Qualification
    {
        get
        {
            return _Qualification;
        }
        set
        {
            _Qualification = value;
        }
    }

    public virtual string Blood_Group
    {
        get
        {
            return _Blood_Group;
        }
        set
        {
            _Blood_Group = value;
        }
    }

    public virtual string FatherName
    {
        get
        {
            return _FatherName;
        }
        set
        {
            _FatherName = value;
        }
    }

    public virtual string MotherName
    {
        get
        {
            return _MotherName;
        }
        set
        {
            _MotherName = value;
        }
    }

    public virtual string ESI_No
    {
        get
        {
            return _ESI_No;
        }
        set
        {
            _ESI_No = value;
        }
    }

    public virtual string EPF_No
    {
        get
        {
            return _EPF_No;
        }
        set
        {
            _EPF_No = value;
        }
    }

    public virtual string PAN_No
    {
        get
        {
            return _PAN_No;
        }
        set
        {
            _PAN_No = value;
        }
    }

    public virtual string Passport_No
    {
        get
        {
            return _Passport_No;
        }
        set
        {
            _Passport_No = value;
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

    public virtual string Phone
    {
        get
        {
            return _Phone;
        }
        set
        {
            _Phone = value;
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

    public virtual DateTime StartDate
    {
        get
        {
            return _StartDate;
        }
        set
        {
            _StartDate = value;
        }
    }
    public virtual int CreatedByID
    {
        get
        {
            return _CreatedByID;
        }
        set
        {
            _CreatedByID = value;
        }
    }
    public virtual int ApproveSpecialRate
    {
        get
        {
            return _ApproveSpecialRate;
        }
        set
        {
            _ApproveSpecialRate = value;
        }
    }
    public virtual int AmrValueAccess
    {
        get
        {
            return _AmrValueAccess;
        }
        set
        {
            _AmrValueAccess = value;
        }
    }
public virtual int DesignationID
    {
        get
        {
            return _DesignationID;
        }
        set
        {
            _DesignationID = value;
        }
    }
public virtual int ValidateLogin
{
    get
    {
        return _ValidateLogin;
    }
    set
    {
        _ValidateLogin = value;
    }
}
public virtual int IsMobileAccess
{
    get
    {
        return _IsMobileAccess;
    }
    set
    {
        _IsMobileAccess = value;
    }
}

public virtual int IsHideRate
{
    get
    {
        return _IsHideRate;
    }
    set
    {
        _IsHideRate = value;
    }
}
    public virtual int PROID
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

    public virtual int IsEditMacReading
    {
        get {
            return _IsEditMacReading;
        }
        set {
            _IsEditMacReading = value;
        }
    }
    public virtual string CreatedBy
    {
        get
        {
            return _CreatedBy;
        }
        set
        {
            _CreatedBy = value;
        }
    }
    public virtual int IsSampleLogisticReject
    {
        get
        {
            return _IsSampleLogisticReject;
        }
        set
        {
            _IsSampleLogisticReject = value;
        }
    }
    public virtual int GlobalReportAccess
    {
        get
        {
            return _GlobalReportAccess;
        }
        set
        {
            _GlobalReportAccess = value;
        }
    }
    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("insert_employee");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter() { ParameterName = "@Employee_ID", MySqlDbType = MySqlDbType.VarChar, Size = 50, Direction = ParameterDirection.Output };
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans) { CommandType = CommandType.StoredProcedure };

           

            this.Employee_ID = Util.GetString(Employee_ID);
            this.Title = Util.GetString(Title);
            this.Name = Util.GetString(Name);
            this.House_No = Util.GetString(House_No);
            this.Street_Name = Util.GetString(Street_Name);
            this.Locality = Util.GetString(Locality);
            this.City = Util.GetString(City);
            this.PinCode = Util.GetInt(PinCode);
            this.PHouse_No = Util.GetString(PHouse_No);
            this.PStreet_Name = Util.GetString(PStreet_Name);
            this.PLocality = Util.GetString(PLocality);
            this.PCity = Util.GetString(PCity);
            this.PPinCode = Util.GetInt(PPinCode);
            this.DOB = Util.GetDateTime(DOB);
            this.Qualification = Util.GetString(Qualification);
            this.Blood_Group = Util.GetString(Blood_Group);
            this.FatherName = Util.GetString(FatherName);
            this.MotherName = Util.GetString(MotherName);
            this.ESI_No = Util.GetString(ESI_No);
            this.EPF_No = Util.GetString(EPF_No);
            this.PAN_No = Util.GetString(PAN_No);
            this.Passport_No = Util.GetString(Passport_No);
            this.Email = Util.GetString(Email);
            this.Phone = Util.GetString(Phone);
            this.Mobile = Util.GetString(Mobile);
            this.StartDate = Util.GetDateTime(StartDate);
            this.AllowSharing = Util.GetString(AllowSharing);
            this.Designation = Util.GetString(Designation);
            this.AccessDepartment = Util.GetString(AccessDepartment);
            this.CreatedByID = Util.GetInt(CreatedByID);
            this.ApproveSpecialRate = Util.GetInt(ApproveSpecialRate);
            this.AmrValueAccess = Util.GetInt(AmrValueAccess);
			this.DesignationID = Util.GetInt(DesignationID);
            this.ValidateLogin = Util.GetInt(ValidateLogin);
            this.IsMobileAccess = Util.GetInt(IsMobileAccess);
            this.PROID = Util.GetInt(PROID);
            this.IsHideRate = Util.GetInt(IsHideRate);
            this.IsEditMacReading = Util.GetInt(IsEditMacReading);
            this.CreatedBy = Util.GetString(CreatedBy);

            this.IsSampleLogisticReject =IsSampleLogisticReject;
            this.GlobalReportAccess = GlobalReportAccess;
            
            cmd.Parameters.Add(new MySqlParameter("@Title", Title));
            cmd.Parameters.Add(new MySqlParameter("@Ename", Name));
            cmd.Parameters.Add(new MySqlParameter("@Designation", Designation));
            cmd.Parameters.Add(new MySqlParameter("@House_No", House_No));
            cmd.Parameters.Add(new MySqlParameter("@Street_Name", Street_Name));
            cmd.Parameters.Add(new MySqlParameter("@Locality", Locality));
            cmd.Parameters.Add(new MySqlParameter("@City", City));
            cmd.Parameters.Add(new MySqlParameter("@Pincode", PinCode));
            cmd.Parameters.Add(new MySqlParameter("@PHouse_No", PHouse_No));
            cmd.Parameters.Add(new MySqlParameter("@PStreet_Name", PStreet_Name));
            cmd.Parameters.Add(new MySqlParameter("@PLocality", PLocality));
            cmd.Parameters.Add(new MySqlParameter("@PCity", PCity));
            cmd.Parameters.Add(new MySqlParameter("PPincode", PPinCode));
            cmd.Parameters.Add(new MySqlParameter("@DOB", DOB));
            cmd.Parameters.Add(new MySqlParameter("@Qualification", Qualification));
            cmd.Parameters.Add(new MySqlParameter("@BloodGroup", Blood_Group));
            cmd.Parameters.Add(new MySqlParameter("@FatherName", FatherName));
            cmd.Parameters.Add(new MySqlParameter("@MotherName", MotherName));
            cmd.Parameters.Add(new MySqlParameter("@ESI_No", ESI_No));
            cmd.Parameters.Add(new MySqlParameter("@EPF_No", EPF_No));
            cmd.Parameters.Add(new MySqlParameter("@PAN_No", PAN_No));
            cmd.Parameters.Add(new MySqlParameter("@PassportNo", Passport_No));
            cmd.Parameters.Add(new MySqlParameter("@Email", Email));
            cmd.Parameters.Add(new MySqlParameter("@Phone", Phone));
            cmd.Parameters.Add(new MySqlParameter("@Mobile", Mobile));
            cmd.Parameters.Add(new MySqlParameter("@StartDate", StartDate));
            cmd.Parameters.Add(new MySqlParameter("@AllowSharing", AllowSharing));
            cmd.Parameters.Add(new MySqlParameter("@AccessDepartment", AccessDepartment));
            cmd.Parameters.Add(new MySqlParameter("@CreatedByID", CreatedByID));
            cmd.Parameters.Add(new MySqlParameter("@ApproveSpecialRate", ApproveSpecialRate));
            cmd.Parameters.Add(new MySqlParameter("@AmrValueAccess", AmrValueAccess));
			      cmd.Parameters.Add(new MySqlParameter("@DesignationID", DesignationID));
            cmd.Parameters.Add(new MySqlParameter("@ValidateLogin", ValidateLogin));
            cmd.Parameters.Add(new MySqlParameter("@IsMobileAccess", IsMobileAccess));
            cmd.Parameters.Add(new MySqlParameter("@PROID", PROID));
            cmd.Parameters.Add(new MySqlParameter("@IsHideRate", IsHideRate));
            cmd.Parameters.Add(new MySqlParameter("@IsEditMacReading", IsEditMacReading));
            cmd.Parameters.Add(new MySqlParameter("@CreatedBy", CreatedBy));
             cmd.Parameters.Add(new MySqlParameter("@IsSampleLogisticReject", IsSampleLogisticReject));
             cmd.Parameters.Add(new MySqlParameter("@GlobalReportAccess", GlobalReportAccess));

            cmd.Parameters.Add(paramTnxID);


            Employee_ID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Employee_ID;
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

    public int Update(int iPkValue)
    {
        this.Employee_ID = iPkValue.ToString();
        return this.Update();
    }

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE employee_master SET Title=@Title, Name =@Name, House_No=@House_No, Street_Name=@Street_Name, Locality=@Locality, City=@City, PinCode=@PinCode, PHouse_No=@PHouse_No, PStreet_Name=@PStreet_Name, PLocality=@PLocality, PCity=@PCity, PPinCode=@PPinCode, DOB=@DOB, Qualification=@Qualification, BloodGroup=@Blood_Group, FatherName=@FatherName, MotherName=@MotherName, ESI_No=@ESI_No, EPF_No=@EPF_No, PAN_No=@PAN_No, PassportNo=@Passport_No, Email = @Email,");
            objSQL.Append("Phone = @Phone, Mobile = @Mobile, StartDate= @StartDate,AllowSharing=@allowsharing,Designation=@Designation,AccessDepartment=@AccessDepartment,ApproveSpecialRate=@ApproveSpecialRate,AmrValueAccess=@AmrValueAccess,DesignationID=@DesignationID,ValidateLogin=@ValidateLogin,IsMobileAccess=@IsMobileAccess,PROID=@PROID,IsHideRate=@IsHideRate,IsEditMacReading=@IsEditMacReading, IsSampleLogisticReject=@IsSampleLogisticReject,GlobalReportAccess=@GlobalReportAccess WHERE Employee_ID = @Employee_ID");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

           

            this.Employee_ID = Util.GetString(Employee_ID);
            this.Title = Util.GetString(Title);
            this.Name = Util.GetString(Name);
            this.House_No = Util.GetString(House_No);
            this.Street_Name = Util.GetString(Street_Name);
            this.Locality = Util.GetString(Locality);
            this.City = Util.GetString(City);
            this.PinCode = Util.GetInt(PinCode);
            this.PHouse_No = Util.GetString(PHouse_No);
            this.PStreet_Name = Util.GetString(PStreet_Name);
            this.PLocality = Util.GetString(PLocality);
            this.PCity = Util.GetString(PCity);
            this.PPinCode = Util.GetInt(PPinCode);
            this.DOB = Util.GetDateTime(DOB);
            this.Qualification = Util.GetString(Qualification);
            this.Blood_Group = Util.GetString(Blood_Group);
            this.FatherName = Util.GetString(FatherName);
            this.MotherName = Util.GetString(MotherName);
            this.ESI_No = Util.GetString(ESI_No);
            this.EPF_No = Util.GetString(EPF_No);
            this.PAN_No = Util.GetString(PAN_No);
            this.Passport_No = Util.GetString(Passport_No);
            this.Email = Util.GetString(Email);
            this.Phone = Util.GetString(Phone);
            this.Mobile = Util.GetString(Mobile);
            this.StartDate = Util.GetDateTime(StartDate);
            this.Designation = Util.GetString(Designation);
            this.AllowSharing = Util.GetString(AllowSharing);
            this.AccessDepartment = Util.GetString(AccessDepartment);
            this.ApproveSpecialRate = Util.GetInt(ApproveSpecialRate);
            this.AmrValueAccess = Util.GetInt(AmrValueAccess);
			this.DesignationID = Util.GetInt(DesignationID);
            this.ValidateLogin = Util.GetInt(ValidateLogin);
            this.IsMobileAccess = Util.GetInt(IsMobileAccess);
            this.PROID = Util.GetInt(PROID);
            this.IsHideRate = Util.GetInt(IsHideRate);
            this.IsEditMacReading = Util.GetInt(IsEditMacReading);
            this.IsSampleLogisticReject =IsSampleLogisticReject;
            this.GlobalReportAccess = GlobalReportAccess;

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                 new MySqlParameter("@Title", Title),
                new MySqlParameter("@Name", Name),
                new MySqlParameter("@House_No", House_No),
                new MySqlParameter("@Street_Name", Street_Name),
                new MySqlParameter("@Locality", Locality),
                new MySqlParameter("@City", City),
                new MySqlParameter("@PinCode", PinCode),
                new MySqlParameter("@PHouse_No", PHouse_No),
                new MySqlParameter("@PStreet_Name", PStreet_Name),
                new MySqlParameter("@PLocality", PLocality),
                new MySqlParameter("@PCity", PCity),
                new MySqlParameter("@PPinCode", PPinCode),
                new MySqlParameter("@DOB", DOB),
                new MySqlParameter("@Qualification", Qualification),
                new MySqlParameter("@Blood_Group", Blood_Group),
                new MySqlParameter("@FatherName", FatherName),
                new MySqlParameter("@MotherName", MotherName),
                new MySqlParameter("@ESI_No", ESI_No),
                new MySqlParameter("@EPF_No", EPF_No),
                new MySqlParameter("@PAN_No", PAN_No),
                new MySqlParameter("@Passport_No", Passport_No),
                new MySqlParameter("@Email", Email),
                new MySqlParameter("@Phone", Phone),
                new MySqlParameter("@Mobile", Mobile),
                new MySqlParameter("@StartDate", StartDate),
                new MySqlParameter("@allowsharing", AllowSharing),
                new MySqlParameter("@Designation", Designation),
                new MySqlParameter("@AccessDepartment", AccessDepartment),
                new MySqlParameter("@Employee_ID", Employee_ID),
                new MySqlParameter("@ApproveSpecialRate", ApproveSpecialRate),
                new MySqlParameter("@AmrValueAccess", AmrValueAccess),
				        new MySqlParameter("@DesignationID", DesignationID),
                new MySqlParameter("@ValidateLogin", ValidateLogin),
                new MySqlParameter("@IsMobileAccess", IsMobileAccess),
                new MySqlParameter("@PROID",PROID),
                new MySqlParameter("@IsHideRate", IsHideRate),
                new MySqlParameter("@IsEditMacReading",IsEditMacReading),
                new MySqlParameter("@IsSampleLogisticReject",IsSampleLogisticReject),
                new MySqlParameter("@GlobalReportAccess",GlobalReportAccess)
                );
                
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
        this.Employee_ID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM employee_master WHERE Employee_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("Employee_ID", Employee_ID));
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

    public int _PROID { get; set; }
    
}
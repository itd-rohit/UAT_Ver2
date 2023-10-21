#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces


public class DoctorMaster
{
    #region All Memory Variables
    private string _Location;
    private string _HospCode;
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
    private string _ConsultantFee;
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
    private string _DocDateTime;
    public string _DocGroupId;
    public string _DocDepartmentID;
    public int _CentreID;
    public string _CreatedByID;
    public string _CreatedBy;
   #endregion

    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

     #endregion

    #region Overloaded Constructor
		public DoctorMaster()
		{
			objCon = Util.GetMySqlCon();
			this.IsLocalConn = true;
        }
    public DoctorMaster(MySqlTransaction objTrans)
		{
			this.objTrans = objTrans;
			this.IsLocalConn = false;
		}
	#endregion
    #region Set All Property

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

    public virtual string CreatedByID
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

    public virtual int CentreID
    {

        get
        {
            return _CentreID;
        }
        set
        {
            _CentreID = value;
        }
    }

    
    public virtual string Location
    {

        get
        {
            return _Location;
        }
        set
        {
            _Location = value;
        }
    }
    public virtual string HospCode
    {

        get
        {
            return _HospCode;
        }
        set
        {
            _HospCode = value;
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
    public virtual string ConsultantFee
    {
        get
        {
            return _ConsultantFee;
        }
        set
        {
            _ConsultantFee = value;
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
    public virtual string DocDateTime
    {
        get
        {
            return _DocDateTime;
        }
        set
        {
            _DocDateTime = value;
        }
    }
    public virtual string DocGroupId
    {
        get
        {
            return _DocGroupId;
        }
        set
        {
            _DocGroupId = value;
        }
    }
    public virtual string DocDepartmentID
    {
        get
        {
            return _DocDepartmentID;
        }
        set
        {
            _DocDepartmentID = value;
        }
    }
    

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        try
        {
            
           
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("Insert_Doctor");
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

            this.Location = "";
            this.HospCode = "";

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
           
            this.Title = Util.GetString(Title);
            this.Name = Util.GetString(Name);
            this.IMARegistartionNo = Util.GetString(IMARegistartionNo);
            this.RegistrationOf = Util.GetString(RegistrationOf);
            this.RegistrationYear = Util.GetString(RegistrationYear);
            this.ProfesionalSummary = Util.GetString(ProfesionalSummary);
            this.Designation = Util.GetString(Designation);
            this.Phone1 = Util.GetString(Phone1);
            this.Phone2 = Util.GetString(Phone2);
            this.ConsultantFee = Util.GetString(ConsultantFee);
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
            this.Degree = Util.GetString(Degree);
            this.Specialization = Util.GetString(Specialization);
            this.UserName = Util.GetString(UserName);
            this.Password = Util.GetString(Password);
            this.DoctorTime = Util.GetString (DoctorTime);
            this.DocDateTime = Util.GetString(DocDateTime);
            this.DocGroupId = Util.GetString(DocGroupId);
            this.DocDepartmentID = Util.GetString(DocDepartmentID);
            this.CentreID =UserInfo.Centre;
            this.CreatedByID = Util.GetString(CreatedByID);
            this.CreatedBy = Util.GetString(CreatedBy);

            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@Title", Title));
            cmd.Parameters.Add(new MySqlParameter("@NAME", Name));
            cmd.Parameters.Add(new MySqlParameter("@IMARegistartionNo", IMARegistartionNo));
            cmd.Parameters.Add(new MySqlParameter("@RegistrationOf", RegistrationOf));
            cmd.Parameters.Add(new MySqlParameter("@RegistrationYear", RegistrationYear));
            cmd.Parameters.Add(new MySqlParameter("@ProfesionalSummary", ProfesionalSummary));
            cmd.Parameters.Add(new MySqlParameter("@Designation", Designation));
            cmd.Parameters.Add(new MySqlParameter("@Phone1", Phone1));
            cmd.Parameters.Add(new MySqlParameter("@Phone2", Phone2));
            cmd.Parameters.Add(new MySqlParameter("@ConsultantFee", ConsultantFee));
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
            cmd.Parameters.Add(new MySqlParameter("@Degree", Degree));
            cmd.Parameters.Add(new MySqlParameter("@Specialization", Specialization));
            cmd.Parameters.Add(new MySqlParameter("@UserName", UserName));
            cmd.Parameters.Add(new MySqlParameter("@PASSWORD", Password));  
            cmd.Parameters.Add(new MySqlParameter("@DoctorTime", DoctorTime));
            cmd.Parameters.Add(new MySqlParameter("@DocDateTime", DocDateTime));
            cmd.Parameters.Add(new MySqlParameter("@DocGroupId", DocGroupId));
            cmd.Parameters.Add(new MySqlParameter("@DocDepartmentID", DocDepartmentID));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@CreatedByID", CreatedByID));
            cmd.Parameters.Add(new MySqlParameter("@CreatedBy", CreatedBy));
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

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
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
            this.ConsultantFee = Util.GetString(ConsultantFee);
            this.Mobile = Util.GetString(Mobile);
            this.House_No = Util.GetString(House_No);
            this.Street_Name = Util.GetString(Street_Name);
            this.Locality = Util.GetString(Locality);
            this.State = Util.GetString(State);
            this.StateRegion = Util.GetString(StateRegion);
            this.CountryRegion = Util.GetString(CountryRegion);
            this.Pincode= Util.GetString(Pincode);
            this.Email = Util.GetString(Email);
            this.PorfilePageID = Util.GetString(PorfilePageID);
            this.UserName = Util.GetString(UserName);
            this.Password = Util.GetString(Password);
            this.City = Util.GetString(City);
            this.Gender = Util.GetString(Gender);
            this.DoctorTime = Util.GetString(DoctorTime);
            this.DoctorTime = Util.GetString(DocDateTime);
            this.DocDepartmentID = Util.GetString(DocDepartmentID);
            
            //this.Specialization = Util.GetString(Specialization);

            int RowAffected;
            StringBuilder objSQL = new StringBuilder();


            objSQL.Append("UPDATE doctor_master SET   Title=?, Name=?, IMARegistartionNo=?, RegistrationOf=?, RegistrationYear = ?,ProfesionalSummary=?,Designation=?, Phone1=?,Phone2=?,ConsultantFee=?,Mobile=?,");
            objSQL.Append("House_No = ?, Street_Name = ?, Locality = ?, State = ?, StateRegion = ?, CountryRegion = ?, Pincode = ?,");
            objSQL.Append("Email = ?, PorfilePageID = ?, City = ?,");
            objSQL.Append("Gender = ?, DocDateTime=? DocDateTime=?,DocGroupId=?,DocDepartmentID=? WHERE Doctor_ID = ?");

         if (IsLocalConn)
            {
                this.objCon.Open();
               this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

            new MySqlParameter("@Title", Title),
            new MySqlParameter("@Name", Name),
            new MySqlParameter("@IMARegistartionNo", IMARegistartionNo),
            new MySqlParameter("@RegistrationOf",RegistrationOf),
            new MySqlParameter("@RegistrationYear",RegistrationYear),
            new MySqlParameter("@ProfesionalSummary", ProfesionalSummary),
            new MySqlParameter("@Designation", Designation),
            new MySqlParameter("@Phone1",Phone1),
            new MySqlParameter("@Phone2",Phone2),
            new MySqlParameter("@ConsultantFee",ConsultantFee),
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
             new MySqlParameter("@DocDateTime", DocDateTime),
             new MySqlParameter("@DocGroupId", DocGroupId),
           // new MySqlParameter("@Specialization", Specialization),
            new MySqlParameter("@Doctor_ID", Doctor_ID),
            new MySqlParameter("@DocDepartmentID", DocDepartmentID));
            

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
    

    /// <summary>
    /// Loads the specified i pk value.
    /// </summary>
    /// <param name="iPkValue">The i pk value.</param>
    /// <returns></returns>
   
 #endregion All Public Member Function



   

}

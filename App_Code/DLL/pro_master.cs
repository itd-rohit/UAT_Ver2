#region All Namespaces
using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MySql.Data.MySqlClient;
#endregion All Namespace
/// <summary>
/// Summary description for pro_master
/// </summary>
public class pro_master
{
    #region All Memory Variables
    private int _PROID;
    private string _Title;
    private string _PROName;
    private string _Designation;
    private string _Phone1;
    private string _Phone2;
    private string _Phone3;
    private string _Mobile;
    private int _IsCreditLimit;
    private float _CreditLimit;
    private string _Address;
    private string _AreaName;
    private string _State;
    private string _Gender;
    private string _Email;
    private string _UserName;
    private string _Password;
    private int _IsActive;
    private DateTime _DateOfBirth;
    private string _UserID;
    private DateTime _EntDateTime;
    private string _UpdateBy;
    private DateTime _UpdateDate;
    private string _UpdateRemarks;
    #endregion


    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor

    public pro_master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;


        //
        // TODO: Add constructor logic here
        //
    }
    public pro_master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion
    #region Set All Property
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
    public virtual string PROName
    {
        get
        {
            return _PROName;
        }
        set
        {
            _PROName = value;
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
    public virtual int IsCreditLimit
    {
        get
        {
            return _IsCreditLimit;
        }
        set
        {
            _IsCreditLimit = value;
        }
    }
    public virtual float CreditLimit
    {
        get
        {
            return _CreditLimit;
        }
        set
        {

            _CreditLimit = value;
        }
    }
    public virtual string Address
    {
        get
        {
            return _Address;
        }
        set
        {
            _Address = value;
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
    public virtual string UserID
    {
        get
        {
            return _UserID;
        }
        set
        {
            _UserID = value;
        }
    }
    public virtual DateTime EntDateTime
    {
        get
        {
            return _EntDateTime;
        }
        set
        {
            _EntDateTime = value;
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
    #endregion
    #region All Public Member Function
    public string Insert()
    {
        try
        {

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("pro_master");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@PROID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            this.Title = Util.GetString(Title);
            this.PROName = Util.GetString(PROName);
            this.Designation = Util.GetString(Designation);
            this.Phone1 = Util.GetString(Phone1);
            this.Phone2 = Util.GetString(Phone2);
            this.Phone3 = Util.GetString(Phone3);
            this.Mobile = Util.GetString(Mobile);
            this.IsCreditLimit = Util.GetInt(IsCreditLimit);
            this.CreditLimit = Util.GetFloat(CreditLimit);
            this.Address = Util.GetString(Address);
            this.AreaName = Util.GetString(AreaName);
            this.State = Util.GetString(State);
            this.Gender = Util.GetString(Gender);
            this.Email = Util.GetString(Email);
            this.UserName = Util.GetString(UserName);
            this.Password = Util.GetString(Password);
            this.IsActive = Util.GetInt(IsActive);
            this.DateOfBirth = Util.GetDateTime(DateOfBirth);
            this.UserID = Util.GetString(UserID);
            this.EntDateTime = Util.GetDateTime(EntDateTime);
            this.UpdateBy = Util.GetString(UpdateBy);
            this.UpdateDate = Util.GetDateTime(UpdateDate);
            this.UpdateRemarks = Util.GetString(UpdateRemarks);



            cmd.Parameters.Add(new MySqlParameter("@Title", Title));
            cmd.Parameters.Add(new MySqlParameter("@PROName", PROName));

            cmd.Parameters.Add(new MySqlParameter("@Designation", Designation));
            cmd.Parameters.Add(new MySqlParameter("@Phone1", Phone1));
            cmd.Parameters.Add(new MySqlParameter("@Phone2", Phone2));
            cmd.Parameters.Add(new MySqlParameter("@Phone3", Phone3));
            cmd.Parameters.Add(new MySqlParameter("@Mobile", Mobile));
            cmd.Parameters.Add(new MySqlParameter("@IsCreditLimit", IsCreditLimit));
            cmd.Parameters.Add(new MySqlParameter("@CreditLimit", CreditLimit));
            cmd.Parameters.Add(new MySqlParameter("@Address", Address));
            cmd.Parameters.Add(new MySqlParameter("@AreaName", AreaName));
            cmd.Parameters.Add(new MySqlParameter("@State", State));
            cmd.Parameters.Add(new MySqlParameter("@Gender", Gender));
            cmd.Parameters.Add(new MySqlParameter("@Email", Email));
            cmd.Parameters.Add(new MySqlParameter("@UserName", UserName));
            cmd.Parameters.Add(new MySqlParameter("@Password", Password));
            cmd.Parameters.Add(new MySqlParameter("@IsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@DateOfBirth", DateOfBirth));
            cmd.Parameters.Add(new MySqlParameter("@UserID", UserID));
            cmd.Parameters.Add(new MySqlParameter("@UpdateBy", UpdateBy));
            cmd.Parameters.Add(new MySqlParameter("@UpdateDate", UpdateDate));
            cmd.Parameters.Add(new MySqlParameter("@UpdateRemarks", UpdateRemarks));

            cmd.Parameters.Add(paramTnxID);
            string PROID = cmd.ExecuteScalar().ToString();
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return PROID;
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



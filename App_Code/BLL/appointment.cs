
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
using MySql.Data.MySqlClient;
using System.Text;
#endregion All Namespaces

/// <summary>
/// Summary description for appointment
/// </summary>


//************Divya Kalra**********08/10/07*********************

public class appointment
{
    #region All Memory Variables

    private string _App_ID;
    private string _Hospital_ID;
    private string _Doctor_ID;
    private string _Patient_ID;
    private string _Title;
    private string _Pname;
    private DateTime _DOB;
    private string _Age;
    private int _Temp_Patient_Flag;
    private int  _Shift;
    private int _AppNo;
    private DateTime _Time;
    private DateTime _Date;
    private int _SlotNo;
    private string _AppType_ID;
    private string _AppTurnOut;
    private int _flag;
    private int _OPD_ID;
    private string _Transaction_ID;
    private string _LedgerTransactionNo;
    private DateTime _AptTime;
     
    #endregion
    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Overloaded Constructor
		public appointment()
		{
			objCon = Util.GetMySqlCon();
			this.IsLocalConn = true;
            //this.Location=AllGlobalFunction.Location;
            //this.HospCode = AllGlobalFunction.HospCode;
        }
    public appointment(MySqlTransaction objTrans)
		{
			this.objTrans = objTrans;
			this.IsLocalConn = false;
		}
	#endregion
    #region Set All Property
    public virtual string App_ID
    {

        get
        {
            return _App_ID;
        }
        set
        {
            _App_ID = value;
        }
    }

    public virtual string Hospital_ID
    {
        get
        {
            return _Hospital_ID;
        }
        set
        {
            _Hospital_ID = value;
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

    public virtual string Patient_ID
    {
        get
        {
            return _Patient_ID;
        }
        set
        {
            _Patient_ID = value;
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
    public virtual string Pname
    {
        get
        {
            return _Pname;
        }
        set
        {
            _Pname = value;
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
    public virtual string Age
    {
        get
        {
            return _Age;
        }
        set
        {
            _Age = value;
        }
    }
    public virtual int Temp_Patient_Flag
    {
        get
        {
            return _Temp_Patient_Flag;
        }
        set
        {
            _Temp_Patient_Flag = value;
        }
    }
    public virtual int Shift
    {
        get
        {
            return _Shift;
        }
        set
        {
            _Shift = value;
        }
    }
    public virtual int AppNo
    {
        get
        {
            return _AppNo;
        }
        set
        {
            _AppNo = value;
        }
    }
   
   
    public virtual DateTime Time
    {
        get
        {
            return _Time;
        }
        set
        {
            _Time = value;
        }
    }
    public virtual DateTime Date
    {
        get
        {
            return _Date;
        }
        set
        {
            _Date = value;
        }
    }
    public virtual int SlotNo
    {
        get
        {
            return _SlotNo;
        }
        set
        {
            _SlotNo = value;
        }
    }


    public virtual string AppType_ID
    {
        get
        {
            return _AppType_ID;
        }
        set
        {
            _AppType_ID = value;
        }
    }
    public virtual string AppTurnOut
    {
        get
        {
            return _AppTurnOut;
        }
        set
        {
            _AppTurnOut = value;
        }
    }

    public virtual int flag
    {
        get
        {
            return _flag;
        }
        set
        {
            _flag = value;
        }
    }
    public virtual int OPD_ID
    {
        get
        {
            return _OPD_ID;
        }
        set
        {
            _OPD_ID = value;
        }
    }

    public virtual string Transaction_ID
    {
        get
        {
            return _Transaction_ID;
        }
        set
        {
            _Transaction_ID = value;
        }
    }


    public virtual string LedgerTransactionNo
    {
        get
        {
            return _LedgerTransactionNo;
        }
        set
        {
            _LedgerTransactionNo = value;
        }
    }

    public virtual DateTime AptTime
    {
        get
        {
            return _AptTime;
        }
        set
        {
            _AptTime = value;
        }
    }
    
    #endregion
    #region All Public Member Function
    public string Insert()
    {
        try
        {
            int iPkValue = 0;

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("insert_appointment");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@AppID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.Doctor_ID = Util.GetString(Doctor_ID);
            this.Patient_ID = Util.GetString(Patient_ID);
            this.Title = Util.GetString(Title);
            this.Pname = Util.GetString(Pname);
            this.DOB = Util.GetDateTime(DOB);
            this.Age = Util.GetString(Age);
            this.Temp_Patient_Flag = Util.GetInt(Temp_Patient_Flag);
            this.Shift = Util.GetInt(Shift);
            this.AppNo = Util.GetInt(AppNo);
            this.Time = Util.GetDateTime(Time);
            this.Date = Util.GetDateTime(Date);
            this.SlotNo = Util.GetInt(SlotNo);
            this.AppType_ID = Util.GetString(AppType_ID);
            this.AppTurnOut = Util.GetString(AppTurnOut);
            this.flag = Util.GetInt(flag);
            this.OPD_ID = Util.GetInt(OPD_ID);
            this.AptTime = AptTime;
            this.Transaction_ID = Util.GetString(Transaction_ID);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);
           
           
            cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@Doctor_ID", Doctor_ID));
            cmd.Parameters.Add(new MySqlParameter("@Patient_ID", Patient_ID));
            cmd.Parameters.Add(new MySqlParameter("@Title", Title));
            cmd.Parameters.Add(new MySqlParameter("@Pname", Pname));
            cmd.Parameters.Add(new MySqlParameter("@DOB", DOB));
            cmd.Parameters.Add(new MySqlParameter("@Age", Age));
            cmd.Parameters.Add(new MySqlParameter("@Temp_Patient_Flag", Temp_Patient_Flag));
            cmd.Parameters.Add(new MySqlParameter("@Shift", Shift));
            cmd.Parameters.Add(new MySqlParameter("@AppNo", AppNo));
            cmd.Parameters.Add(new MySqlParameter("@TIME", Time));
            cmd.Parameters.Add(new MySqlParameter("@DATE", Date));
            cmd.Parameters.Add(new MySqlParameter("@SlotNo", SlotNo));
            cmd.Parameters.Add(new MySqlParameter("@AppType_ID", AppType_ID));
            cmd.Parameters.Add(new MySqlParameter("@AppTurnOut", AppTurnOut));
            cmd.Parameters.Add(new MySqlParameter("@flag", flag));
            cmd.Parameters.Add(new MySqlParameter("@OPD_ID", OPD_ID));
            cmd.Parameters.Add(new MySqlParameter("@Appointment_Time", AptTime));
            cmd.Parameters.Add(new MySqlParameter("@TransactionID", Transaction_ID));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo));

           
            cmd.Parameters.Add(paramTnxID);

            //cmd.ExecuteNonQuery();

            App_ID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return App_ID.ToString();
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

    //created update /delete /load function by Sonika dt 5 Oct 2007
    //***************************************************************************************
   public int Update()
    {
        try
        {
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.Doctor_ID = Util.GetString(Doctor_ID);
            this.Patient_ID = Util.GetString(Patient_ID);
            this.Title = Util.GetString(Title);
            this.Pname = Util.GetString(Pname);
            this.DOB = Util.GetDateTime(DOB);
            this.Age = Util.GetString(Age);
            this.Temp_Patient_Flag = Util.GetInt(Temp_Patient_Flag);
            this.Shift = Util.GetInt(Shift);
            this.AppNo = Util.GetInt(AppNo);
            this.Time = Util.GetDateTime(Time);
            this.Date = Util.GetDateTime(Date);
            this.SlotNo = Util.GetInt(SlotNo);
            this.AppType_ID = Util.GetString(AppType_ID);
            this.AppTurnOut = Util.GetString(AppTurnOut);
            this.flag = Util.GetInt(flag);
            this.OPD_ID = Util.GetInt(OPD_ID);
            this.Transaction_ID = Util.GetString(Transaction_ID);

            int RowAffected;
            StringBuilder objSQL = new StringBuilder();



            objSQL.Append("UPDATE appointment SET Hospital_ID = ?,Doctor_ID =?,Patient_ID=?,Title=?,Pname=?,DOB=?,Age=?,Temp_Patient_Flag=?, ");
            objSQL.Append("Shift = ?,AppNo=?,Time=?,Date=?,SlotNo=?,AppType_ID=?,AppTurnOut=?,flag=?,OPD_ID=?,Transaction_ID=? WHERE App_ID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),


               new MySqlParameter("@Hospital_ID",Hospital_ID),
               new MySqlParameter("@Doctor_ID",Doctor_ID),
               new MySqlParameter("@Patient_ID",Patient_ID),
               new MySqlParameter("@Title", Title),
               new MySqlParameter("@Pname", Pname),
               new MySqlParameter("@DOB", DOB),
               new MySqlParameter("@Age", Age),
               new MySqlParameter("@Temp_Patient_Flag",Temp_Patient_Flag),
               new MySqlParameter("@Shift",Shift),
               new MySqlParameter("@AppNo",AppNo),
               new MySqlParameter("@Time",Time),
               new MySqlParameter("@Date",Date),
               new MySqlParameter("@SlotNo",SlotNo),
               new MySqlParameter("@AppType_ID",AppType_ID),
               new MySqlParameter("@AppTurnOut",AppTurnOut),
               new MySqlParameter("@flag",flag),
               new MySqlParameter("@OPD_ID",OPD_ID),
               new MySqlParameter("@Transaction_ID", Transaction_ID));
                

               

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
    public int Update(string AppID)
    {
        this.App_ID = Util.GetString(AppID);
        return this.Update();
    }




    public int Delete(string AppID)
    {
        this.App_ID = Util.GetString(AppID);
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM appointment WHERE App_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("App_ID", App_ID));
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

    public bool Load()
    {
        DataTable dtTemp;

        try
        {

            string sSQL = "SELECT * FROM appointment WHERE App_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@App_ID", App_ID)).Tables[0];

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            if (dtTemp.Rows.Count > 0)
            {
               // this.SetProperties(dtTemp);
                return true;
            }
            else
                return false;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            // Util.WriteLog(ex);
            string sParams = "App_ID=" + this.App_ID.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }

    }

    /// <summary>
    /// Loads the specified i pk value.
    /// </summary>
    /// <param name="iPkValue">The i pk value.</param>
    /// <returns></returns>
    public bool Load(string AppID)
    {
        this.App_ID = Util.GetString(AppID);
        return this.Load();
    }

    #endregion All Public Member Function
    
    
}

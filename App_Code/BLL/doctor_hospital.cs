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

/// <summary>
/// Summary description for doctor_hospital** sonika**
/// </summary>
public class doctor_hospital
{


    #region All Memory Variables

    private int  _OPD_ID;
    private string _Doctor_ID;
    private string _Hospital_ID;
    private string _Day;
    private int _Shift;
    private DateTime _StartTime;
    private DateTime _EndTime;
    private int _StartBufferTime;
    private int _EndBufferTime;
    private int _NoOfSlot;
    private int _TotalPatient;
    private int _AvgTime;
    private int _StopTimeForOnlineApp;
    private int _ClosingDayForOnlineApp;
    private string _App_Type;
    private string _Department;
    private float _Latitude;
    private float _Longitude;
    private string _RoomNo;
    private int _DurationforNewPatient;
    private int _DurationforOldPatient;
    private string _DocFloor;
    #endregion

    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public doctor_hospital()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public doctor_hospital(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
	#endregion
    #region Set All Property

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

    public virtual string Day
    {
        get
        {
            return _Day;
        }
        set
        {
            _Day = value;
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
    public virtual DateTime StartTime
    {
        get
        {
            return _StartTime;
        }
        set
        {
            _StartTime = value;
        }
    }
    public virtual DateTime EndTime
    {
        get
        {
            return _EndTime;
        }
        set
        {
            _EndTime = value;
        }
    }
    public virtual int NoOfSlot
    {
        get
        {
            return _NoOfSlot;
        }
        set
        {
            _NoOfSlot = value;
        }
    }
    public virtual int TotalPatient
    {
        get
        {
            return _TotalPatient;
        }
        set
        {
            _TotalPatient = value;
        }
    }
    public virtual int AvgTime
    {
        get
        {
            return _AvgTime;
        }
        set
        {
            _AvgTime = value;
        }
    }
    public virtual string App_Type
    {
        get
        {
            return _App_Type;
        }
        set
        {
            _App_Type = value;
        }
    }
    public virtual int StopTimeForOnlineApp
    {
        get
        {
            return _StopTimeForOnlineApp;
        }
        set
        {
            _StopTimeForOnlineApp = value;
        }
    }
    public virtual int ClosingDayForOnlineApp
    {
        get
        {
            return _ClosingDayForOnlineApp;
        }
        set
        {
            _ClosingDayForOnlineApp = value;
        }
    }
    public virtual string Department
    {
        get
        {
            return _Department;
        }
        set
        {
            _Department = value;
        }
    }
    public virtual float Latitude
    {
        get
        {
            return _Latitude;
        }
        set
        {
            _Latitude = value;
        }
    }
    public virtual float Longitude
    {
        get
        {
            return _Longitude;
        }
        set
        {
            _Longitude = value;
        }
    }
    public virtual string RoomNo
    {
        get
        {
            return _RoomNo;
        }
        set
        {
            _RoomNo = value;
        }
    }
    public virtual int StartBufferTime
    {
        get
        {
            return _StartBufferTime;
        }
        set
        {
            _StartBufferTime = value;
        }
    }
    public virtual int EndBufferTime
    {
        get
        {
            return _EndBufferTime;
        }
        set
        {
            _EndBufferTime = value;
        }
    }
    public virtual int DurationforNewPatient
    {
        get
        {
            return _DurationforNewPatient;
        }
        set
        {
            _DurationforNewPatient = value;
        }
    }
    public virtual int DurationforOldPatient
    {
        get
        {
            return _DurationforOldPatient;
        }
        set
        {
            _DurationforOldPatient = value;
        }
    }
    public virtual string DocFloor
    {
        get
        {
            return _DocFloor;
        }
        set
        {
            _DocFloor = value;
        }
    }


    #endregion
    #region All Public Member Function
    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();


            objSQL.Append("INSERT INTO doctor_hospital(OPD_ID,Doctor_ID,Hospital_ID,Day,Shift,StartTime,EndTime,NoOfSlot,TotalPatient,AvgTime,StopTimeForOnlineApp,ClosingDayForOnlineApp,App_Type,Department,Latitude,Longitude,Room_No,StartBufferTime,EndBufferTime,DurationforNewPatient,DurationforOldPatient)");
            objSQL.Append("VALUES (@OPD_ID,@Doctor_ID, @Hospital_ID,@Day, @Shift, @StartTime,@EndTime,@NoOfSlot,@TotalPatient,@AvgTime,@StopTimeForOnlineApp,@ClosingDayForOnlineApp,@App_Type,@Department,@Latitude,@Longitude,@RoomNo,@StartBufferTime,@EndBufferTime,@DurationforNewPatient,@DurationforOldPatient)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.OPD_ID = Util.GetInt(OPD_ID);
            this.Doctor_ID = Util.GetString(Doctor_ID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.Day = Util.GetString(Day);
            this.Shift = Util.GetInt(Shift);
            this.StartTime = Util.GetDateTime(StartTime);
            this.EndTime = Util.GetDateTime(EndTime);
            this.NoOfSlot = Util.GetInt(NoOfSlot);
            this.TotalPatient = Util.GetInt(TotalPatient);
            this.AvgTime = Util.GetInt(AvgTime);
            this.StopTimeForOnlineApp = Util.GetInt(StopTimeForOnlineApp);
            this.ClosingDayForOnlineApp = Util.GetInt(ClosingDayForOnlineApp);
            this.App_Type = Util.GetString(App_Type);
            this.Department = Util.GetString(Department);
            this.Latitude = Util.GetFloat(Latitude);
            this.Longitude = Util.GetFloat(Longitude);
            this.RoomNo = Util.GetString(RoomNo);
            this.StartBufferTime = Util.GetInt(StartBufferTime);
            this.EndBufferTime = Util.GetInt(EndBufferTime);
            this.DurationforNewPatient = Util.GetInt(DurationforNewPatient);
            this.DurationforOldPatient = Util.GetInt(DurationforOldPatient);
           // this.DocFloor = Util.GetString(DocFloor);
            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

               new MySqlParameter("@OPD_ID", OPD_ID),
               new MySqlParameter("@Doctor_ID", Doctor_ID),
               new MySqlParameter("@Hospital_ID", Hospital_ID),
               new MySqlParameter("@Day", Day),
               new MySqlParameter("@Shift", Shift),
               new MySqlParameter("@StartTime", StartTime),
               new MySqlParameter("@EndTime", EndTime),
               new MySqlParameter("@NoOfSlot", NoOfSlot),
               new MySqlParameter("@TotalPatient", TotalPatient),
               new MySqlParameter("@AvgTime", AvgTime),
               new MySqlParameter("@StopTimeForOnlineApp", StopTimeForOnlineApp),
               new MySqlParameter("@ClosingDayForOnlineApp", ClosingDayForOnlineApp),
               new MySqlParameter("@App_Type", App_Type),
               new MySqlParameter("@Department", Department),
               new MySqlParameter("@Latitude", Latitude),
               new MySqlParameter("@Longitude", Longitude),
               new MySqlParameter("@RoomNo", RoomNo),
               new MySqlParameter("@StartBufferTime", StartBufferTime),
               new MySqlParameter("@EndBufferTime", EndBufferTime),
            new MySqlParameter("@DurationforNewPatient", DurationforNewPatient),
            new MySqlParameter("@DurationforOldPatient", DurationforOldPatient) );
             //  new MySqlParameter("@DocFloor", DocFloor)
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
    /// <summary>
    /// update by sonika dt 3 oct 2007
    /// </summary>
    /// <returns></returns>
       public int Update()
         {
           try
          {
            this.OPD_ID = Util.GetInt(OPD_ID);
            this.Doctor_ID = Util.GetString(Doctor_ID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.Day = Util.GetString(Day);
            this.Shift = Util.GetInt(Shift);
            this.StartTime = Util.GetDateTime(StartTime);
            this.EndTime = Util.GetDateTime(EndTime);
            this.NoOfSlot = Util.GetInt(NoOfSlot);
            this.TotalPatient = Util.GetInt(TotalPatient);
            this.AvgTime = Util.GetInt(AvgTime);
            this.StopTimeForOnlineApp = Util.GetInt(StopTimeForOnlineApp);
            this.ClosingDayForOnlineApp = Util.GetInt(ClosingDayForOnlineApp);
            this.App_Type = Util.GetString(App_Type);
            this.Department = Util.GetString(Department);
            this.Latitude = Util.GetFloat(Latitude);
            this.Longitude = Util.GetFloat(Longitude);
            this.RoomNo = Util.GetString(RoomNo);
            this.StartBufferTime = Util.GetInt(StartBufferTime);
            this.EndBufferTime = Util.GetInt(EndBufferTime);
            this.DurationforNewPatient = Util.GetInt(DurationforNewPatient);
            this.DurationforOldPatient = Util.GetInt(DurationforOldPatient);
            this.DocFloor = Util.GetString(DocFloor);
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("UPDATE doctor_hospital SET Hospital_ID=?,Day = ?,Shift=?, StartTime=?, EndTime=?,NoOfSlot=?,TotalPatient=?,AvgTime=?,StopTimeForOnlineApp=?,ClosingDayForOnlineApp=?");
            objSQL.Append("App_Type = ?,Department=? ,Latitude = ? ,Longitude = ?,Room_No=?,StartBufferTime=?,EndBufferTime=?,DurationforNewPatient=?,DurationforOldPatient=?,DocFloor=? WHERE Doctor_ID = ? ");

             if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
             RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@OPD_ID", OPD_ID),
                new MySqlParameter("@Doctor_ID", Doctor_ID),
                new MySqlParameter("@Hospital_ID", Hospital_ID),
                new MySqlParameter("@Day", Day),
                new MySqlParameter("@Shift", Shift),
                new MySqlParameter("@StartTime", StartTime),
                new MySqlParameter("@EndTime", EndTime),
                new MySqlParameter("@NoOfSlot", NoOfSlot),
                new MySqlParameter("@TotalPatient", TotalPatient),
                new MySqlParameter("@AvgTime", AvgTime),
                new MySqlParameter("@StopTimeForOnlineApp", StopTimeForOnlineApp),
                new MySqlParameter("@ClosingDayForOnlineApp", ClosingDayForOnlineApp),
                new MySqlParameter("@App_Type", App_Type),
                new MySqlParameter("@Department", Department),
                new MySqlParameter("@Latitude", Latitude),
                new MySqlParameter("@Longitude", Longitude),
                 new MySqlParameter("@RoomNo", RoomNo),
                new MySqlParameter("@StartBufferTime", StartBufferTime),
                 new MySqlParameter("@EndBufferTime", EndBufferTime),
             new MySqlParameter("@DurationforNewPatient", DurationforNewPatient),
            new MySqlParameter("@DurationforOldPatient", DurationforOldPatient),
            new MySqlParameter("@DocFloor", DocFloor));


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
            objSQL.Append("DELETE FROM doctor_hospital WHERE Doctor_ID = @Doctor_ID");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Doctor_ID", Doctor_ID));
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
            string sSQL = "SELECT * FROM doctor_hospital WHERE Doctor_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@Doctor_ID", Doctor_ID)).Tables[0];

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            if (dtTemp.Rows.Count > 0)
            {
                this.SetProperties(dtTemp);
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
            string sParams = "Doctor_ID=" + this.Doctor_ID.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }

    }

    /// <summary>
    /// Loads the specified i pk value.
    /// </summary>
    /// <param name="iPkValue">The i pk value.</param>
    /// <returns></returns>
    public bool Load(string DoctorID)
    {
        this.Doctor_ID = Util.GetString(DoctorID);
        return this.Load();
    }

    #endregion All Public Member Function
    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        //OPD_ID,Doctor_ID,Hospital_ID,Day,Shift,StartTime,EndTime,NoOfSlot,TotalPatient,AvgTime,StopTimeForOnlineApp,ClosingDayForOnlineApp
        //this.OPD_ID = Util.GetInt(dtTemp.Rows[0][AllTables.Doctor_hospital.OPD_ID]);
        //this.Doctor_ID = Util.GetString(dtTemp.Rows[0][AllTables.Doctor_hospital.Doctor_ID]);
        //this.Hospital_ID = Util.GetString(dtTemp.Rows[0][AllTables.Doctor_hospital.Hospital_ID]);
        //this.Day = Util.GetString(dtTemp.Rows[0][AllTables.Doctor_hospital.Day]);
        //this.Shift = Util.GetInt(dtTemp.Rows[0][AllTables.Doctor_hospital.Shift]);
        //this.StartTime = Util.GetDateTime(dtTemp.Rows[0][AllTables.Doctor_hospital.StartTime]);
        //this.EndTime = Util.GetDateTime(dtTemp.Rows[0][AllTables.Doctor_hospital.EndTime]);
        //this.NoOfSlot = Util.GetInt(dtTemp.Rows[0][AllTables.Doctor_hospital.NoOfSlot]);
        //this.TotalPatient = Util.GetInt(dtTemp.Rows[0][AllTables.Doctor_hospital.TotalPatient]);
        //this.AvgTime = Util.GetInt(dtTemp.Rows[0][AllTables.Doctor_hospital.AvgTime]);
        //this.StopTimeForOnlineApp = Util.GetInt(dtTemp.Rows[0][AllTables.Doctor_hospital.StopTimeForOnlineApp]);
        //this.ClosingDayForOnlineApp = Util.GetInt(dtTemp.Rows[0][AllTables.Doctor_hospital.ClosingDayForOnlineApp]);
        //this.App_Type = Util.GetString(dtTemp.Rows[0][AllTables.Doctor_hospital.App_Type]);
        //this.Department = Util.GetString(dtTemp.Rows[0][AllTables.Doctor_hospital.Department]);
        //this.Latitude = Util.GetFloat(dtTemp.Rows[0][AllTables.Doctor_hospital.Latitude]);
        //this.Longitude = Util.GetFloat(dtTemp.Rows[0][AllTables.Doctor_hospital.Longitude]);
        //this.RoomNo = Util.GetString(dtTemp.Rows[0][AllTables.Doctor_hospital.RoomNo]);
        //this.StartBufferTime = Util.GetInt(dtTemp.Rows[0][AllTables.Doctor_hospital.StartBufferTime]);
        //this.EndBufferTime = Util.GetInt(dtTemp.Rows[0][AllTables.Doctor_hospital.EndBufferTime]);
        //this.DurationforNewPatient = Util.GetInt(dtTemp.Rows[0][AllTables.Doctor_hospital.DurationforNewPatient]);
        //this.DurationforOldPatient = Util.GetInt(dtTemp.Rows[0][AllTables.Doctor_hospital.DurationforOldPatient]);
        //this.DocFloor = Util.GetString(dtTemp.Rows[0][AllTables.Doctor_hospital.DocFloor]);
    }
    #endregion

	
}

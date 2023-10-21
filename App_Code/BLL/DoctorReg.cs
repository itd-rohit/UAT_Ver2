using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for DoctorReg
/// </summary>
public class DoctorReg
{
    public DoctorReg()
    {
        //
        // TODO: Add constructor logic here
        //


    }
    public DataTable getMembershipList()
    {
        DataTable dt = GetTypeList(2);
        return dt;
    }
    public static DataTable GetTypeList(int i)
    {
        return StockReports.GetDataTable("select TRIM(BOTH FROM NAME) Name from type_master where TypeID =" + i + " order by Name");
    }
    public DataTable getDegreeList()
    {
        DataTable dt = GetTypeList(1);
        return dt;
    }
    public DataTable getSpecializationList()
    {
        DataTable dt = GetTypeList(3);
        return dt;
    }
    public static DataTable LoadPanelCompanyConsultation()
    {
        DataTable Items = StockReports.GetDataTable("Select rtrim(ltrim(Company_Name)) as Company_Name,Panel_ID,ReferenceCode,ReferenceCodeOPD from f_panel_master where panel_id=78 order by Company_Name");
        return Items;
    }
    public DataTable getDepartmentList()
    {
        DataTable dt = GetTypeList(5);
        return dt;
    }
    public static DataTable GetDoctorDetail(string DName, string Specialization, string Deptartment, string DID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
        sb.Append("SELECT  DM.Name, DM.Doctor_ID AS DID , DM.Specialization, Department ,  DM.Degree FROM (SELECT  Doctor_ID,   NAME ,   Specialization, Designation AS Department ,  Degree  FROM   doctor_master  WHERE IsActive = 1  ");
        if (DName != "")
        {
            sb.Append(" and Name like @DName");
        }
        if (DID != "")
        {
            sb.Append(" and Doctor_ID like @DID");
        }
        if (Specialization != "")
        {
            sb.Append("  and Specialization = @Specialization");
        }
        if (Deptartment != "")
        {
            sb.Append(" and Designation=@Designation ");
        }
        sb.Append(" )DM order by DM.Name");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@DName", "%" + DName + "%"),
                 new MySqlParameter("@Doctor_ID", DID),
                new MySqlParameter("@Specialization", Specialization),
                new MySqlParameter("@Designation", Deptartment)).Tables[0])
            {
                return dt;
            }
        }
        catch (Exception ex)
        {
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public DataTable getDoctorOPDSlot(string Doctor_ID)
    {
        DataTable dt = StockReports.GetDataTable("select * from doctor_master where doctor_id='" + Doctor_ID + "'");
        return dt;
    }
    public static int GetDoctorShift(string DocID, string HospID, string Day)
    {
        string sql = "select max(Shift) from doctor_hospital where Doctor_ID='" + DocID + "' and Hospital_ID='" + HospID + "' and Day='" + Day + "'";
        return Util.GetInt(StockReports.ExecuteScalar(sql));
    }
    public string SaveDocOPD(string DocID, string HospID, string Day, DateTime StartTime, DateTime EndTime, string RoomNo, string Dept, int avgtime, MySqlTransaction Trans)
    {
        try
        {
            doctor_hospital objDocHosp = new doctor_hospital(Trans);
            int Shift = GetDoctorShift(DocID, HospID, Day);

            Shift = Shift + 1;


            objDocHosp.Doctor_ID = DocID;
            objDocHosp.Hospital_ID = HospID;
            objDocHosp.Day = Day;
            objDocHosp.StartTime = StartTime;
            objDocHosp.EndTime = EndTime;
            objDocHosp.Department = Dept;
            objDocHosp.RoomNo = RoomNo;
            objDocHosp.AvgTime = avgtime;
            //objDocHosp.StartBufferTime = StartBufferTime;
            //objDocHosp.EndBufferTime = EndBufferTime;
            // objDocHosp.DurationforOldPatient = DurationforOldPatient;
            //objDocHosp.DurationforNewPatient = DurationforNewPatient;
            // objDocHosp.DocFloor = DocFloor;
            objDocHosp.Insert();

            return "1";
        }
        catch (Exception ex)
        {
            Trans.Rollback();
            return "0";
            //return ex.Message;
        }
    }
    public static DataTable LoadCategoryByConfigRelationID(string ConfigRelationID)
    {
        return StockReports.GetDataTable("Select CategoryID  from f_ConfigRelation where ConfigRelationID in (" + ConfigRelationID + ")");

    }
    public static DataTable LoadSubCategoryByCategory(DataTable Category)
    {
        string CatID = "";
        if (Category != null && Category.Rows.Count > 0)
        {
            for (int i = 0; i < Category.Rows.Count; i++)
            {
                if (Category.Rows.Count == 1)
                {
                    CatID = CatID + Category.Rows[i][0].ToString();
                }
                else if (i == Category.Rows.Count - 1)
                {
                    CatID = CatID + Category.Rows[i][0].ToString();
                }
                else
                {
                    CatID = CatID + Category.Rows[i][0].ToString() + "','";
                }
            }
        }
        DataTable Items = GetSubCategoryByCategory(CatID);
        return Items;
    }
    public static DataTable GetSubCategoryByCategory(string Category)
    {
        return StockReports.GetDataTable("SELECT Name,SubCategoryID from f_Subcategorymaster where CategoryID in ('" + Category + "') order by Name");

    }
    public static DataTable LoadDoctorByDoctorID(string Doctor_ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select Name from doctor_master where Doctor_ID=@Doctor_ID",
                new MySqlParameter("@Doctor_ID", Doctor_ID)).Tables[0])
            {
                return dt;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}

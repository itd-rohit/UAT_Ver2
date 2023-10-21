using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI;

public partial class Design_Sales_DesignationEmployeeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
        }
    }

    [WebMethod]
    public static string GetDesignation()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ID,Name,SequenceNo,IsActive,If(IsActive=1,'Active','Deactive')CurrentStatus, ");
        sb.Append(" IFNULL((SELECT COUNT(1) FROM employee_master em WHERE `DesignationID`= dm.id AND em.`IsSalesTeamMember`=1 AND em.isactive=1) ,0) EmpCount ");
        sb.Append(" FROM f_designation_msater dm WHERE IsSales=1 ORDER BY SequenceNo");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string GetEmployee(string DesignationID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Employee_ID, Title, NAME, Mobile, Email,House_No as EmpCode FROM `employee_master` WHERE IsSalesTeamMember=1 and IsActive=1 and DesignationID='" + DesignationID + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string SearchEmployee(string query)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Employee_ID as value,CONCAT(House_No,'~', CONCAT(Title,' ', NAME)) AS label FROM `employee_master` WHERE IsActive=1 and IsSalesTeamMember=0 AND CONCAT(House_No,'~', CONCAT(Title,' ', NAME)) LIKE '%" + query + "%'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string bindDesignation(string Sequence)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,Name FROM f_designation_msater where IsActive=1 and IsSales=1 and SequenceNo <'" + Sequence + "' order by SequenceNo desc");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string bindReporter(string DesignationID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CONCAT(em.Employee_ID,'#',st.TagLocationID,'#',st.tagLocationName)Employee_ID,CONCAT(em.House_No,'~', CONCAT(em.Title,' ', em.NAME)) AS EmpName ");
        sb.Append(" FROM `employee_master` em INNER JOIN f_designation_msater dm ON em.DesignationID=dm.ID INNER JOIN sales_taglocation st ON st.employee_id=em.Employee_ID AND st.IsActive=1 ");

        sb.Append(" WHERE em.IsSalesTeamMember=1 AND em.IsActive=1 AND em.DesignationID='" + DesignationID + "' GROUP BY st.employee_id");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string Save(string EmpID, string DesignationID, int DesignationSequence, int tagLocationID, string tagLocationName, string TypeID, string ReporterID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Reporting_Employee_ID = string.Empty;
            if (DesignationSequence == 1)
                Reporting_Employee_ID = EmpID;
            else
                Reporting_Employee_ID = ReporterID;

            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE employee_master SET IsSalesTeamMember=1,DesignationID=@DesignationID, Reporting_Employee_ID=@Reporting_Employee_ID,UpdatedByID=@UpdatedByID,UpdatedBy=@UpdatedBy,UpdateDate=@UpdateDate where Employee_ID=@ID ");
            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);
            cmd.Parameters.AddWithValue("@DesignationID", DesignationID);
            cmd.Parameters.AddWithValue("@Reporting_Employee_ID", Reporting_Employee_ID);
            cmd.Parameters.AddWithValue("@UpdatedByID", UserInfo.ID);
            cmd.Parameters.AddWithValue("@UpdatedBy", UserInfo.LoginName);
            cmd.Parameters.AddWithValue("@UpdateDate", DateTime.Now);
            cmd.Parameters.AddWithValue("@ID", EmpID);
            cmd.ExecuteNonQuery();
            if (DesignationSequence == 1 || tagLocationID==1)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sales_taglocation SET IsActive=0 WHERE Employee_ID='" + EmpID + "' ");
                sb = new StringBuilder();
                sb.Append(" INSERT INTO sales_taglocation(TagLocationID,TagLocationName,TypeID,TypeName,CreatedByID,CreatedBy,Reporting_Employee_ID,DesignationID,Employee_ID) ");
                sb.Append(" VALUES(@TagLocationID,@TagLocationName,@TypeID,@TypeName,@CreatedByID,@CreatedBy,@Reporting_Employee_ID,@DesignationID,@Employee_ID)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@TagLocationID", "1"),
                    new MySqlParameter("@TagLocationName", "ALL"), new MySqlParameter("@TypeID", "0"),
                    new MySqlParameter("@TypeName", string.Empty),
                    new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                    new MySqlParameter("@Reporting_Employee_ID", Reporting_Employee_ID), new MySqlParameter("@DesignationID", DesignationID), new MySqlParameter("@Employee_ID", EmpID));
            }
            else if (TypeID != string.Empty)
            {
                int len = Util.GetInt(TypeID.Split(',').Length);
                string[] Data = new string[len];
                Data = TypeID.Split(',');

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sales_taglocation SET IsActive=0 WHERE Employee_ID='" + EmpID + "' ");
                for (int i = 0; i < len; i++)
                {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO sales_taglocation(TagLocationID,TagLocationName,TypeID,TypeName,CreatedByID,CreatedBy,Reporting_Employee_ID,DesignationID,Employee_ID) ");
                    sb.Append(" VALUES(@TagLocationID,@TagLocationName,@TypeID,@TypeName,@CreatedByID,@CreatedBy,@Reporting_Employee_ID,@DesignationID,@Employee_ID)");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@TagLocationID", tagLocationID),
                        new MySqlParameter("@TagLocationName", tagLocationName), new MySqlParameter("@TypeID", Data[i].ToString()),
                        new MySqlParameter("@TypeName", string.Empty),
                        new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                        new MySqlParameter("@Reporting_Employee_ID", Reporting_Employee_ID), new MySqlParameter("@DesignationID", DesignationID), new MySqlParameter("@Employee_ID", EmpID)

                        );
                }
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnexport_Click(object sender, EventArgs e)
    {
        lblerrmsg.Text = "";
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("SELECT emp.Employee_ID,emp.House_No AS EmployeeCode, CONCAT(emp.Title,' ', emp.NAME) AS EmployeeName,sh.Name AS  Designation, emp.Mobile, emp.Email, ");
            sb.Append(" CONCAT(em2.Title,' ', em2.NAME) AS ReportingEmployeeName,dm2.Name AS  ReportingDesignation  FROM ");
            sb.Append(" `f_designation_msater` AS sh ");

            sb.Append(" INNER JOIN employee_master emp ON emp.DesignationID=sh.`ID` AND emp.IsSalesTeamMember=1 AND sh.IsSales=1 ");
            sb.Append(" INNER JOIN employee_master em2 ON emp.Reporting_Employee_ID=em2.Employee_ID ");
            sb.Append(" inner join f_designation_msater dm2 on dm2.ID=em2.DesignationID ORDER BY sh.SequenceNo ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "SalesEmployee";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
            }
            else
                lblerrmsg.Text = "No Record Found";
        }
        catch (Exception ex)
        {
            lblerrmsg.Text = ex.Message;
        }
    }

    [WebMethod]
    public static string bindTagLocation(int repTagLocationID, string repEmployeeID, int LocationHierarchy)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        DataTable TypeID = StockReports.GetDataTable("SELECT CAST(GROUP_CONCAT(TypeID) AS CHAR)TypeID,TagLocationID,TagLocationName FROM sales_taglocation WHERE TagLocationID='" + repTagLocationID + "' AND Employee_ID='" + repEmployeeID + "' AND IsActive=1 GROUP BY TagLocationID");

        if (LocationHierarchy == 2)
        {
            sb = new StringBuilder();
            sb.Append("SELECT bm.BusinessZoneID ID,bm.BusinessZoneName Name FROM businesszone_master bm  WHERE  bm.isActive=1 ");
            if (TypeID.Rows.Count > 0)
            {
                if (repTagLocationID == 2)
                {
                    sb.Append(" AND bm.BusinessZoneID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                else if (repTagLocationID == 3 || repTagLocationID == 4 || repTagLocationID == 5)
                {
                }
            }
            sb.Append(" ORDER BY bm.BusinessZoneName ");
        }
        else if (LocationHierarchy == 3)
        {
            sb = new StringBuilder();
            sb.Append("SELECT ID,state Name FROM state_master bm  WHERE  IsActive=1 ");
            if (TypeID.Rows.Count > 0)
            {
                if (repTagLocationID == 2)
                {
                    sb.Append(" AND bm.BusinessZoneID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                else if (repTagLocationID == 3)
                {
                    sb.Append(" AND ID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                else if (repTagLocationID == 4)
                {
                    sb.Append(" AND ID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
            }
            sb.Append(" ORDER BY bm.state ");
        }
        else if (LocationHierarchy == 4)
        {
            sb = new StringBuilder();
            sb.Append("SELECT ID,headquarter Name FROM headquarter_master bm  WHERE  IsActive=1 ");
            if (TypeID.Rows.Count > 0)
            {
                if (repTagLocationID == 2)
                {
                    sb.Append(" AND BusinessZoneID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                else if (repTagLocationID == 3)
                {
                    sb.Append(" AND StateID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                else if (repTagLocationID == 4)
                {
                    sb.Append(" AND ID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
            }
            sb.Append(" ORDER BY headquarter ");
        }
        else if (LocationHierarchy == 5)
        {
            sb = new StringBuilder();
            sb.Append(" SELECT ID,City Name FROM city_master WHERE IsActive=1 ");
            if (TypeID.Rows.Count > 0)
            {
                if (repTagLocationID == 2)
                {
                    sb.Append(" AND StateID IN(SELECT StateID FROM state_master WHERE BusinessZoneID IN(" + TypeID.Rows[0]["TypeID"].ToString() + ")) ");
                }
                else if (repTagLocationID == 3)
                {
                    sb.Append(" AND StateID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                else if (repTagLocationID == 4)
                {
                    sb.Append(" AND HeadQuarterID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                else if (repTagLocationID == 5)
                {
                    sb.Append(" AND ID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                sb.Append(" ORDER BY City ");
            }
        }
        else if (LocationHierarchy == 6)
        {
            sb = new StringBuilder();
            sb.Append(" SELECT ZoneID ID,Zone Name FROM centre_zonemaster WHERE IsActive=1 ");
            if (TypeID.Rows.Count > 0)
            {
                if (repTagLocationID == 2)
                {
                    sb.Append(" AND StateID IN(SELECT StateID FROM state_master WHERE BusinessZoneID IN(" + TypeID.Rows[0]["TypeID"].ToString() + ")) ");
                }
                else if (repTagLocationID == 3)
                {
                    sb.Append(" AND StateID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                else if (repTagLocationID == 4)
                {
                    sb.Append(" AND HeadQuarterID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                else if (repTagLocationID == 5)
                {
                    sb.Append(" AND CityID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                else if (repTagLocationID == 6)
                {
                    sb.Append(" AND ID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                sb.Append(" ORDER BY Name ");
            }
        }
        else if (LocationHierarchy == 7)
        {
            sb = new StringBuilder();
            sb.Append(" SELECT ID,Name Name FROM f_locality WHERE Active=1 ");
            if (TypeID.Rows.Count > 0)
            {
                if (repTagLocationID == 2)
                {
                    sb.Append(" AND StateID IN(SELECT StateID FROM state_master WHERE BusinessZoneID IN(" + TypeID.Rows[0]["TypeID"].ToString() + ")) ");
                }
                else if (repTagLocationID == 3)
                {
                    sb.Append(" AND StateID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                else if (repTagLocationID == 4)
                {
                    sb.Append(" AND HeadQuarterID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                else if (repTagLocationID == 5)
                {
                    sb.Append(" AND CityID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                else if (repTagLocationID == 6)
                {
                    sb.Append(" AND ZoneID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                else if (repTagLocationID == 7)
                {
                    sb.Append(" AND ID IN (" + TypeID.Rows[0]["TypeID"].ToString() + ") ");
                }
                sb.Append(" ORDER BY Name ");
            }
        }
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }
[WebMethod]
    public static string DeleteEmployee(string DesignationID, string EmployeeId)
    {
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                if (EmployeeId != "")
                {

                    string query = "Update employee_master set Reporting_Employee_ID='0',IsSalesTeamMember='0' WHERE IsSalesTeamMember=1 and IsActive=1 and DesignationID='" + DesignationID + "' and Employee_Id='" + EmployeeId + "' ";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, query.ToString());
                    Tnx.Commit();
                    con.Close();
                    return "1";
                }
                else
                {
                    return "0";
                }
            }
        }
       
    }
    [WebMethod]
    public static string bindLocationHierarchy(int TagLocationID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,tagLocationName FROM sales_taglocation_master WHERE IsActive=1 AND Priority>= (SELECT Priority FROM sales_taglocation_master WHERE ID='" + TagLocationID + "') ");
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }
}
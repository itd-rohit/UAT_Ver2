using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Quality_QCApprovalRight : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlType.DataSource = StockReports.GetDataTable("SELECT DISTINCT AppRightFor AS ID,AppRightFor AS NAME  FROM qc_approvaltype order by apprightfor");
            ddlType.DataValueField = "ID";
            ddlType.DataTextField = "NAME";
            ddlType.DataBind();
            ddlType.Items.Insert(0, new ListItem("Select", "0"));
        }
    }


    [WebMethod]
    public static string bindaction(string typeToBind)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("    SELECT typename,TypeIDApprove FROM qc_approvaltype WHERE apprightfor='" + typeToBind + "'  ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
    }


    [WebMethod]
    public static string bindManageApproval(string appRightFor, int Con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT  st.ApprightID,st.CreatedBy,st.TypeName,em.name EmployeeName,st.AppRightFor,DATE_FORMAT(st.CreatedDate,'%d-%b-%Y')CreatedDate  ");
        sb.Append(" FROM qc_approvalright st INNER JOIN employee_master em ON em.employee_id=st.employeeid WHERE st.Active=1 ");
        if (appRightFor != "0" && Con == 0)
            sb.Append(" AND st.appRightFor='" + appRightFor + "' ");
        sb.Append("ORDER BY em.name,st.AppRightFor,st.TypeName ");
        sb.Append("");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
    }
    [WebMethod]
    public static string SearchEmployee(string query)
    {

        using (DataTable dt = StockReports.GetDataTable("SELECT Employee_ID as value,CONCAT(Title,' ', NAME) AS label FROM `employee_master` WHERE IsActive=1 AND NAME LIKE '" + query + "%'"))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
    }
    [WebMethod]
    public static string SaveApprovalRight(string EmployeeID, string typeData, string appRightFor)
    {
        string retValue = "";
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    string[] TotaltypeName = typeData.TrimEnd(',').Split(',');
                    for (int i = 0; i < TotaltypeName.Length; i++)
                    {
                        string TypeID = TotaltypeName[i].Split('#')[0];
                        string TypeName = TotaltypeName[i].Split('#')[1];
                        StringBuilder sb = new StringBuilder();
                        sb.Append(" SELECT COUNT(*) FROM qc_approvalright WHERE EmployeeID=@EmployeeID AND TypeID=@TypeID AND appRightFor=@appRightFor AND Active=@Active  ");
                        int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                                                new MySqlParameter("@EmployeeID", EmployeeID),
                                                new MySqlParameter("@TypeID", TypeID),
                                                new MySqlParameter("@appRightFor", appRightFor),
                                                new MySqlParameter("@Active", "1")));
                        if (count > 0)
                        {
                            Exception ex = new Exception(TypeName + " Role Already Assigned");
                            throw (ex);
                        }
                       
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO qc_approvalright (EmployeeID,typeName,appRightFor,CreatedBy,CreatedByID,TypeID) values ");
                        sb.Append(" (@EmployeeID,@typeName,@appRightFor,@CreatedBy,@CreatedByID,@TypeID) ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@EmployeeID", EmployeeID),
                         new MySqlParameter("@typeName", TypeName),
                         new MySqlParameter("@TypeID", TypeID),
                         new MySqlParameter("@appRightFor", appRightFor),
                         new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                         new MySqlParameter("@CreatedByID", UserInfo.ID)
                         );
                    }
                    tnx.Commit();
                    retValue = "success";
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    tnx.Rollback();
                    retValue = ex.Message;
                }
                finally
                {
                    con.Close();
                }
                return retValue;
            }

        }
    }
    [WebMethod]
    public static string removeManageApproval(string AppRightID)
    {

        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE qc_approvalright SET Active=0,UpdatedByID=@UpdatedByID,UpdatedBy=@UpdatedBy,UpdatedDate=NOW() WHERE AppRightID=@AppRightID",
                     new MySqlParameter("@UpdatedBy", UserInfo.LoginName), new MySqlParameter("@UpdatedByID", UserInfo.ID), new MySqlParameter("@AppRightID", AppRightID)
                        );
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
                    con.Close();
                }
            }


        }
    }

    [WebMethod]
    public static string exportToExcel()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT em.name `EmployeeName`,st.TypeName `AuthorityType`,st.AppRightFor AccessLabel,st.CreatedBy,DATE_FORMAT(st.CreatedDate,'%d-%b-%Y')CreatedDate  ");
        // sb.Append(" st.UpdatedBy,DATE_FORMAT(st.UpdatedDate,'%d-%b-%Y')UpdatedDate ");
        sb.Append(" FROM qc_approvalright st INNER JOIN employee_master em ON em.employee_id=st.employeeid WHERE st.Active=1 ");
        sb.Append("ORDER BY st.CreatedBy,st.AppRightFor,st.TypeName ");
        sb.Append("");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt != null && dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = " ManageApprovalQuality";
                return "1";
            }
            else
                return "0";
        }
    }
}
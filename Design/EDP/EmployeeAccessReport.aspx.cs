using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_EDP_EmployeeAccessReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //bindEmployee();
            BindRole();
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchEmployee(string Employee)
    {
        DataTable dt = StockReports.GetDataTable("SELECT Employee_ID as value,CONCAT(em.Title,' ',em.Name) as label FROM employee_master em WHERE IsActive=1 AND Name like '" + Employee + "%'");
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchCentre(string Centre)
    {
        string str = "select CentreId as value,Centre as label from centre_master where IsActive=1 AND Centre like '" + Centre + "%'";
        using (DataTable dt = StockReports.GetDataTable(str))
        {
            string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
    }

    private void BindRole()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,RoleName FROM f_rolemaster WHERE Active=1 ORDER BY RoleName");
        if (dt.Rows.Count > 0)
        {
            ddlRole.DataTextField = "RoleName";
            ddlRole.DataValueField = "ID";
            ddlRole.DataSource = dt;
            ddlRole.DataBind();
            ddlRole.Items.Insert(0, new ListItem("--Select--", "0"));
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Search(string EmployeeId, string CentreId, string RoleId)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT employee_ID,NAME EmployeeName,GROUP_CONCAT(DISTINCT Centre  separator  '\n')Centre,GROUP_CONCAT(DISTINCT RoleName  separator  '\n')RoleName,RoleID FROM ( ");
            sb.Append("    SELECT   em.employee_ID, CONCAT(em.Title,' ',em.Name)NAME,rm.RoleName RoleName,cm.Centre,rm.ID,cm.centreid,lo.RoleID ");
            sb.Append("    FROM f_login lo INNER JOIN  employee_master em  ON lo.employeeid=em.Employee_ID ");
            sb.Append("    INNER JOIN centre_master cm ON cm.centreid=lo.centreid INNER JOIN f_rolemaster rm ON rm.ID=lo.RoleID WHERE ''='' ");
            if (EmployeeId != "0")
                sb.Append(" AND  em.employee_ID='" + EmployeeId + "' ");
            if (CentreId != "0")
                sb.Append(" AND  cm.CentreId='" + CentreId + "' ");
            if (RoleId != "0")
                sb.Append(" AND  lo.RoleId='" + RoleId + "' ");
            sb.Append("  )t GROUP BY t.employee_ID ");

            DataSet ds = new DataSet();
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            ds.Tables.Add(dt.Copy());
            HttpContext.Current.Session["ReportName"] = "EmployeeAccessReport";
            HttpContext.Current.Session["ds"] = ds;
            return "1";
        }
        catch
        {
            return "0";
        }
    }
}
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Mobile_dashboard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
            if (Session["UserName"] == null && Session["UserName"] == null)
            {
                if (Request.QueryString["UserID"] != null && Request.QueryString["Password"] != null)
                {
                    
                  Login(Request.QueryString["UserID"], Request.QueryString["Password"]);

                   
                }
                else
                {
                    Response.Redirect("SignIn.aspx", false);
                }
            }
        }
    }

    private void Login(string UserID,string Password)
    {
        try
        {
            int InvalidPassword = 0;

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();

            InvalidPassword = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select InvalidPassword from f_login where UserName=@UserName and InvalidPassword>=3",
                new MySqlParameter("@UserName",UserID.Trim())));

            con.Close();
            con.Dispose();

            if (InvalidPassword >= 3)
            {
                Response.Redirect("SignIn.aspx", false);
            }

            StringBuilder sb = new StringBuilder();
            sb.Append("select (select datediff(now(), ifnull(max(f2.CurLoginTime),now())) LastLogin from f_login f2 where f2.EmployeeID = em.Employee_ID)LastLogin  ,(SELECT DATEDIFF(NOW(), IFNULL(MAX(f2.lastpass_dt),NOW())) Lastpassin FROM f_login f2 WHERE f2.EmployeeID = em.Employee_ID)Lastpassin  ,cm.Centre,cm.Type1,fl.EmployeeID,fl.UserName,em.name EmpName,fl.RoleID,rm.RoleName,fl.CentreID ");
            sb.Append(" from f_login fl inner join employee_master em on fl.EmployeeID = em.Employee_ID ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=fl.CentreID INNER JOIN f_rolemaster rm ON rm.ID=fl.RoleID  where fl.Active = 1 and em.IsActive=1 ");
            sb.Append(" and PASSWORD(LOWER(fl.UserName)) = PASSWORD(LOWER(@Username)) and PASSWORD(LOWER(fl.Password)) = PASSWORD(LOWER(@Password))  ORDER BY fl.isDefault desc");

            DataTable dt = new DataTable();

            dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, sb.ToString(),
           new MySql.Data.MySqlClient.MySqlParameter("@Username",UserID.Trim()),
           new MySql.Data.MySqlClient.MySqlParameter("@Password", Password.Trim())).Tables[0];

            // int days = 0;

            if (dt.Rows.Count > 0)
            {


                con.Open();
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, " insert into f_login_detail(RoleID,EmployeeID,EmployeeName,UserName,CentreID,Browser,ipAddress,HostName)values(" + Util.GetString(dt.Rows[0]["RoleID"]) + ",'" + Util.GetString(dt.Rows[0]["EmployeeID"]) + "','" + Util.GetString(dt.Rows[0]["EmpName"]) + "','" +UserID + "','" + Util.GetString(dt.Rows[0]["CentreID"]) + "','" + Request.UserAgent + "','" + Request.UserHostAddress + "','" + Request.UserHostName + "') ");

                con.Close();
                con.Dispose();

                Session["Centre"] = Util.GetString(dt.Rows[0]["CentreID"]);
                Session["LoginType"] = Util.GetString(dt.Rows[0]["RoleName"]);
                Session["UserName"] =UserID.Trim();
                Session["ID"] = Util.GetString(dt.Rows[0]["EmployeeID"]);
                Session["LoginName"] = Util.GetString(dt.Rows[0]["EmpName"]);
                Session["RoleID"] = Util.GetString(dt.Rows[0]["RoleID"]);
                Session["CentreName"] = Util.GetString(dt.Rows[0]["Centre"]);
                Session["CentreType"] = Util.GetString(dt.Rows[0]["Type1"]);

                

                UpdateLoginDetails(dt.Rows[0]["RoleID"].ToString(), Util.GetString(dt.Rows[0]["EmployeeID"]));
                
            }
            else
            {
                Response.Redirect("SignIn.aspx", false);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }



    private void UpdateLoginDetails(string RoleID, string EmployeeID)
    {
        try
        {
            string str = "Update f_login Set LastLoginTime=CurLoginTime,CurLoginTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',NoOfLogins=NoOfLogins+1 where EmployeeID='" + EmployeeID + "'";
            StockReports.ExecuteDML(str);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}
<%@ WebService Language="C#" Class="Login" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.IO;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.Script.Services;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Login : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod(EnableSession=true)]
    [ScriptMethod(UseHttpGet = true)]
  //  [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]  
    public string UserLogin(string UserID, string Password)
    {
        MySqlConnection con = Util.GetMySqlCon();
        try
        {
            int InvalidPassword = 0;
          
            con.Open();
            InvalidPassword = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select InvalidPassword from f_login where UserName=@UserName and InvalidPassword>=3",
                new MySqlParameter("@UserName", UserID.Trim())));
            con.Close();
            con.Dispose();
            if (InvalidPassword >= 3)
            {
               //return "You have exceeded the number of allowed login attempts";
                return Util.getJson(new { success = "You have exceeded the number of allowed login attempts" });
            }
            StringBuilder sb = new StringBuilder();
            sb.Append("select cm.Centre,cm.Type1,fl.EmployeeID,fl.UserName,em.name EmpName,fl.RoleID,rm.RoleName,fl.CentreID ");
            sb.Append(" from f_login fl inner join employee_master em on fl.EmployeeID = em.Employee_ID and em.IsMobileAccess=1 ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=fl.CentreID INNER JOIN f_rolemaster rm ON rm.ID=fl.RoleID  where fl.Active = 1 and em.IsActive=1 ");
            sb.Append(" and PASSWORD(LOWER(fl.UserName)) = PASSWORD(LOWER(@Username)) and PASSWORD(LOWER(fl.Password)) = PASSWORD(LOWER(@Password))  ORDER BY fl.isDefault desc");
            DataTable dt = new DataTable();
            dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, sb.ToString(),
           new MySql.Data.MySqlClient.MySqlParameter("@Username", UserID.Trim()),
           new MySql.Data.MySqlClient.MySqlParameter("@Password", Password.Trim())).Tables[0];

            //StringBuilder sb = new StringBuilder();
            //sb.Append("select count(*) ");
            //sb.Append(" from f_login fl inner join employee_master em on fl.EmployeeID = em.Employee_ID and em.IsMobileAccess=1 where em.IsActive=1 and fl.Active=1 ");
            //sb.Append(" and PASSWORD(LOWER(fl.UserName)) = PASSWORD(LOWER(@Username)) and PASSWORD(LOWER(fl.Password)) = PASSWORD(LOWER(@Password))  ORDER BY fl.isDefault desc");

            //int IsUser = Util.GetInt(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text, sb.ToString(),
            //new MySql.Data.MySqlClient.MySqlParameter("@Username", UserID.Trim()),
            //new MySql.Data.MySqlClient.MySqlParameter("@Password", Password.Trim())));
            
            con.Close();
            con.Dispose();
            if (dt.Rows.Count > 0)
            {
                Session["Centre"] = Util.GetString(dt.Rows[0]["CentreID"]);
                Session["LoginType"] = Util.GetString(dt.Rows[0]["RoleName"]);
                Session["UserName"] = UserID.Trim();
                Session["ID"] = Util.GetString(dt.Rows[0]["EmployeeID"]);
                Session["LoginName"] = Util.GetString(dt.Rows[0]["EmpName"]);
                Session["RoleID"] = Util.GetString(dt.Rows[0]["RoleID"]);
                Session["CentreName"] = Util.GetString(dt.Rows[0]["Centre"]);
                Session["CentreType"] = Util.GetString(dt.Rows[0]["Type1"]);
                return Util.getJson(new { success = "successful" });

            }
            else
            {
                return Util.getJson(new { success = "failed" });
               // return "failed";

            }
        }
        catch (Exception ex)
        {
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.getJson(new { success = "failed" });
         //   return "failed";
        }
    }


}
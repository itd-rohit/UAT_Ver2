using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;

public partial class Design_UserControl_LoginPage : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        txtUserName.Text = string.Empty;
        txtPassword.Text = string.Empty;
    }
    private void Login()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (ddlUserType.SelectedValue == "PRO")
            {
                StringBuilder sb = new StringBuilder();
                int InvalidPassword = 0;
                InvalidPassword = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select InvalidPassword from f_login where UserName=@UserName and InvalidPassword>=3",
                    new MySqlParameter("@UserName", txtUserName.Text.Trim())));
                if (InvalidPassword >= 3)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('You have exceeded the number of allowed login attempts.\\nYou will be redirect to verify your login.');window.location='ForgotPassword.aspx';", true);
                    return;
                }
                sb.Append("SELECT cm.Centre,cm.Type1,fl.EmployeeID,fl.UserName,em.name EmpName,fl.RoleID,rm.RoleName,fl.CentreID,pm.IsInvoice,em.PROID,em.IsSalesTeamMember ");
                sb.Append(" FROM f_login fl inner join employee_master em on fl.EmployeeID = em.Employee_ID and em.proid <> 0 ");
                sb.Append(" INNER Join pro_master pro  on pro.proid=em.proid AND  pro.isactive=1 ");
                sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=fl.CentreID ");
                sb.Append(" INNER JOIN f_rolemaster rm ON rm.ID=fl.RoleID ");
                sb.Append(" INNER JOIN f_panel_Master pm ON pm.CentreID=cm.CentreID AND pm.PanelType='Centre' WHERE fl.Active = 1 AND em.IsActive=1 ");
                sb.Append(" AND PASSWORD(LOWER(fl.UserName)) = PASSWORD(LOWER(@Username)) AND PASSWORD(LOWER(fl.Password)) = PASSWORD(LOWER(@Password))  ORDER BY fl.isDefault desc");

                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySql.Data.MySqlClient.MySqlParameter("@Username", txtUserName.Text.Trim()),
                new MySql.Data.MySqlClient.MySqlParameter("@Password", txtPassword.Text.Trim())).Tables[0])
                {
                    if (dt.Rows.Count > 0)
                    {
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO f_login_detail(RoleID,EmployeeID,EmployeeName,UserName,CentreID,Browser,ipAddress,HostName) ");
                        sb.Append(" values(@RoleID,@EmployeeID,@EmployeeName,@UserName,@CentreID,@Browser,@ipAddress,@HostName) ");

                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@RoleID", Util.GetString(dt.Rows[0]["RoleID"])), new MySqlParameter("@EmployeeID", Util.GetString(dt.Rows[0]["EmployeeID"])),
                            new MySqlParameter("@EmployeeName", Util.GetString(dt.Rows[0]["EmpName"])), new MySqlParameter("@UserName", txtUserName.Text),
                            new MySqlParameter("@CentreID", Util.GetString(dt.Rows[0]["CentreID"])), new MySqlParameter("@Browser", Request.UserAgent),
                            new MySqlParameter("@ipAddress", Request.UserHostAddress), new MySqlParameter("@HostName", Request.UserHostName));

                        Session["Centre"] = Util.GetString(dt.Rows[0]["CentreID"]);
                        Session["LoginType"] = Util.GetString(dt.Rows[0]["RoleName"]);
                        Session["UserName"] = txtUserName.Text.Trim();
                        Session["ID"] = Util.GetString(dt.Rows[0]["EmployeeID"]);
                        Session["LoginName"] = Util.GetString(dt.Rows[0]["EmpName"]);
                        Session["RoleID"] = Util.GetString(dt.Rows[0]["RoleID"]);
                        Session["CentreName"] = Util.GetString(dt.Rows[0]["Centre"]);
                        Session["CentreType"] = Util.GetString(dt.Rows[0]["Type1"]);
                        Session["IsInvoice"] = Util.GetString(dt.Rows[0]["IsInvoice"]);
                        Session["PROID"] = Util.GetString(dt.Rows[0]["PROID"]);
                        Session["IsSalesTeamMember"] = Util.GetString(dt.Rows[0]["IsSalesTeamMember"]);
                        UpdateLoginDetails(dt.Rows[0]["RoleID"].ToString(), Util.GetString(dt.Rows[0]["EmployeeID"]), con);
                        Response.Redirect("~/Design/Welcome.aspx", false);
                    }
                    else
                    {
                        lblError.Visible = true;
                        lblError.Text = "[ INCORRECT USERNAME/PASSWORD ]<br/>USE EMPLOYEE ID AS YOUR USERNAME";
                        txtUserName.Focus();
                    }
                }
            }
            else
            {
                int InvalidPassword = 0;
                InvalidPassword = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select InvalidPassword from f_login where UserName=@UserName AND InvalidPassword>=3",
                    new MySqlParameter("@UserName", txtUserName.Text.Trim())));
                if (InvalidPassword >= 3)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('You have exceeded the number of allowed login attempts.\\nYou will be redirect to verify your login.');window.location='ForgotPassword.aspx';", true);
                    return;
                }
                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT cm.Centre,cm.Type1,fl.EmployeeID,fl.UserName,em.name EmpName,fl.RoleID,rm.RoleName,fl.CentreID,pm.IsInvoice,em.IsSalesTeamMember ");
                sb.Append(" FROM f_login fl inner join employee_master em on fl.EmployeeID = em.Employee_ID ");
                sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=fl.CentreID ");
                sb.Append(" INNER JOIN f_rolemaster rm ON rm.ID=fl.RoleID ");
                sb.Append(" INNER JOIN f_panel_Master pm ON pm.CentreID=cm.CentreID AND pm.PanelType='Centre' WHERE fl.Active = 1 AND em.IsActive=1 ");
                sb.Append(" and PASSWORD(LOWER(fl.UserName)) = PASSWORD(LOWER(@Username)) and PASSWORD(LOWER(fl.Password)) = PASSWORD(LOWER(@Password))  ORDER BY fl.isDefault desc");
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySql.Data.MySqlClient.MySqlParameter("@Username", txtUserName.Text.Trim()),
                 new MySql.Data.MySqlClient.MySqlParameter("@Password", txtPassword.Text.Trim())).Tables[0])
                {
                    if (dt.Rows.Count > 0)
                    {
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO f_login_detail(RoleID,EmployeeID,EmployeeName,UserName,CentreID,Browser,ipAddress,HostName) ");
                        sb.Append(" VALUES(@RoleID,@EmployeeID,@EmployeeName,@UserName,@CentreID,@Browser,@ipAddress,@HostName) ");
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@RoleID", Util.GetString(dt.Rows[0]["RoleID"])), new MySqlParameter("@EmployeeID", Util.GetString(dt.Rows[0]["EmployeeID"])),
                            new MySqlParameter("@EmployeeName", Util.GetString(dt.Rows[0]["EmpName"])), new MySqlParameter("@UserName", txtUserName.Text),
                            new MySqlParameter("@CentreID", Util.GetString(dt.Rows[0]["CentreID"])), new MySqlParameter("@Browser", Request.UserAgent),
                            new MySqlParameter("@ipAddress", Request.UserHostAddress), new MySqlParameter("@HostName", Request.UserHostName));

                        Session["Centre"] = Util.GetString(dt.Rows[0]["CentreID"]);
                        Session["LoginType"] = Util.GetString(dt.Rows[0]["RoleName"]);
                        Session["UserName"] = txtUserName.Text.Trim();
                        Session["ID"] = Util.GetString(dt.Rows[0]["EmployeeID"]);
                        Session["LoginName"] = Util.GetString(dt.Rows[0]["EmpName"]);
                        Session["RoleID"] = Util.GetString(dt.Rows[0]["RoleID"]);
                        Session["CentreName"] = Util.GetString(dt.Rows[0]["Centre"]);
                        Session["CentreType"] = Util.GetString(dt.Rows[0]["Type1"]);
                        Session["IsInvoice"] = Util.GetString(dt.Rows[0]["IsInvoice"]);
                        Session["PROID"] = "0";
                        Session["IsSalesTeamMember"] = Util.GetString(dt.Rows[0]["IsSalesTeamMember"]);
                        UpdateLoginDetails(dt.Rows[0]["RoleID"].ToString(), Util.GetString(dt.Rows[0]["EmployeeID"]), con);
                        Response.Redirect("~/Design/Welcome.aspx", false);
                    }
                    else
                    {
                        lblError.Visible = true;
                        lblError.Text = "[ INCORRECT USERNAME/PASSWORD ]<br/>USE EMPLOYEE ID AS YOUR USERNAME";
                        txtUserName.Focus();
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    private void UpdateLoginDetails(string RoleID, string EmployeeID, MySqlConnection con)
    {
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Update f_login Set LastLoginTime=CurLoginTime,CurLoginTime=@CurLoginTime,NoOfLogins=NoOfLogins+1 WHERE EmployeeID=@EmployeeID",
             new MySqlParameter("@CurLoginTime", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")), new MySqlParameter("@EmployeeID", EmployeeID));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        Login();
    }
}
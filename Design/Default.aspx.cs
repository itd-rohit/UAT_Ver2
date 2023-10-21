using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Security.Cryptography;
using System.Text;
using System.Runtime.InteropServices;
using System.Web;
public partial class Default : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
			 if (Util.GetString(Request.QueryString["dbname"]).Trim() != "")
                Session["DB"] = Util.GetString(Request.QueryString["dbname"]);
            else
                Session["DB"] = System.Configuration.ConfigurationManager.AppSettings["LiveDB"];
            lblClientFullName.Text = GetGlobalResourceObject("Resource", "ClientFullName").ToString().ToUpper();
            imgClientLogo.ImageUrl = GetGlobalResourceObject("Resource", "ClientLogo").ToString();
            if (Session["ID"] != null)
            {
                Response.Redirect("~/Design/Welcome.aspx");
            }
            if (Request.QueryString["sessionTimeOut"] != null)
            {
                if (Request.QueryString["sessionTimeOut"] == "true")
                {
                    Session.RemoveAll();
                    Session.Abandon();
                    HttpCookie myCookie = new HttpCookie("ASP.NET_SessionId");
                    myCookie.Expires = DateTime.Now.AddDays(-1);
                    Response.Cookies.Add(myCookie);
                    HttpCookie Login = new HttpCookie("Login");
                    Login.Expires = DateTime.Now.AddDays(-1);
                    Response.Cookies.Add(Login);
                    Response.Redirect("~/Design/Default.aspx");
                }
            }
            txtUserName.Focus();
            form1.Visible = true;
        }
        else
        {
            form1.Visible = true;
            lblError.Visible = false;
            if (!Page.IsPostBack)
            {
                lblClientFullName.Text = GetGlobalResourceObject("Resource", "ClientFullName").ToString().ToUpper();
                imgClientLogo.ImageUrl = GetGlobalResourceObject("Resource", "ClientLogo").ToString();
                if (Session["ID"] != null)
                {
                    Response.Redirect("~/Design/Welcome.aspx");
                }
            //    YYY.bindCenterDropDownList(ddlCenterMaster, Resources.Resource.DefaultCentreID, "");
                txtUserName.Focus();
            }
            //WelcomeMessage();
        }
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
           
                int InvalidPassword = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select InvalidPassword from f_login where UserName=@UserName and InvalidPassword>=3",
                    new MySqlParameter("@UserName", txtUserName.Text.Trim())));
                if (InvalidPassword >= 3)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('You have exceeded the number of allowed login attempts.\\nYou will be redirect to verify your login.');window.location='ForgotPassword.aspx';", true);
                    return;
                }
                sb.Append("SELECT cm.Centre,cm.Type1,fl.EmployeeID,fl.UserName,em.name EmpName,fl.RoleID,rm.RoleName,fl.CentreID,pm.IsInvoice,em.PROID,em.IsSalesTeamMember,em.IsHideRate ");
                sb.Append(" FROM f_login fl inner join employee_master em on fl.EmployeeID = em.Employee_ID and em.proid <> 0 ");
                sb.Append(" INNER Join pro_master pro  on pro.proid=em.proid AND  pro.isactive=1 ");
                sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=fl.CentreID ");
                sb.Append(" INNER JOIN f_rolemaster rm ON rm.ID=fl.RoleID ");
                sb.Append(" INNER JOIN f_panel_Master pm ON pm.CentreID=cm.CentreID AND pm.PanelType='Centre' WHERE fl.Active = 1 AND em.IsActive=1 ");
                sb.Append(" AND BINARY PASSWORD(fl.UserName) = PASSWORD(@Username) AND BINARY PASSWORD(fl.Password) = PASSWORD(@Password)  ORDER BY fl.isDefault desc");

                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Username", txtUserName.Text.Trim()),
                new MySqlParameter("@Password", txtPassword.Text.Trim())).Tables[0])
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
                            new MySqlParameter("@ipAddress",Request.UserHostAddress), new MySqlParameter("@HostName", Request.UserHostName));//

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
						if (dt.Rows[0]["IsSalesTeamMember"].ToString() == "1")
                {
                    string _TeamMember = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`('" + dt.Rows[0]["EmployeeID"].ToString() + "',@ChildNode);");
                    _TeamMember = "'" + _TeamMember + "'";
                    _TeamMember = _TeamMember.Replace(",", "','");
                    Session["AccessPROIDs"] = _TeamMember;
                }
                else
                {
                    Session["AccessPROIDs"] = "";
                }
                        Session["IsHideRate"] = Util.GetString(dt.Rows[0]["IsHideRate"]);
                        UpdateLoginDetails(Util.GetString(dt.Rows[0]["EmployeeID"]), con);
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
            else if (ddlUserType.SelectedValue == "PUP")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" SELECT cm.PaytmMid,cm.PaytmGuid,cm.PaytmKey,fpm.PanelUserID, fpm.PanelPassword,fpm.IsActive,cm.`Centre`,cm.`CentreID`,cm.`type1`,fpm.Panel_ID,fpm.Company_Name,fpm.IsInvoice  ");
                sb.Append(" FROM f_panel_master  fpm  ");
                sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=fpm.`TagProcessingLabID` ");
                sb.Append(" where  fpm.PanelUserID=@Username and fpm.PanelPassword=@Password  AND fpm.IsActive=1 AND fpm.PanelType='PUP' ");
                DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                        new MySql.Data.MySqlClient.MySqlParameter("@Username", txtUserName.Text.Trim()),
                        new MySql.Data.MySqlClient.MySqlParameter("@Password", txtPassword.Text.Trim())).Tables[0];
                if (dt.Rows.Count == 0)
                {
                    lblError.Visible = true;
                    lblError.Text = "[ INCORRECT USERNAME/PASSWORD ]";
                    txtUserName.Focus();
                    return;
                }
                else
                {
                    string isActive = dt.Rows[0]["IsActive"].ToString();
                    if (isActive == "0")
                    {
                        lblError.Visible = true;
                        lblError.Text = "Your Account has been deactivated ,kindly contact account department !!";
                        txtUserName.Focus();
                        return;
                    }


                    string OnlinePanelID = Util.GetString(dt.Rows[0]["Panel_ID"]);
                    string usertype = "Panel";
                    Session["isLogin"] = "true";
                    Session["Centre"] = Util.GetString(dt.Rows[0]["CentreID"]);
                    Session["LoginType"] = "PCC";// Util.GetString(dt.Rows[0]["RoleName"]);
                    Session["UserName"] = Util.GetString(dt.Rows[0]["PanelUserID"]);
                    Session["ID"] = Util.GetString(dt.Rows[0]["Panel_ID"]);
                    Session["LoginName"] = Util.GetString(dt.Rows[0]["Company_Name"]);
                    Session["RoleID"] = "211";
                    Session["CentreName"] = Util.GetString(dt.Rows[0]["Centre"]);
                    Session["CentreType"] = "PUP";
                    Session["IsInvoice"] = Util.GetString(dt.Rows[0]["IsInvoice"]);
                    Session["OnlinePanelID"] = Util.GetString(dt.Rows[0]["Panel_ID"]);
                    Session["AccessStoreLocation"] = "";
                    Session["PROID"] = ""; // Util.GetString(dt.Rows[0]["PROID"]);
                    Session["IsSalesTeamMember"] = "0"; // Util.GetString(dt.Rows[0]["IsSalesTeamMember"]);
                    Session["IsHideRate"] = "0";// Util.GetString(dt.Rows[0]["IsHideRate"]);
					Session["AccessPROIDs"] = "";
                    Response.Redirect(string.Format("OnlineLab/ViewlabReportPanelOfline.aspx?UserType={0}&OnlinePanelID={1}", HttpUtility.UrlEncode(Common.Encrypt(usertype.Trim())), HttpUtility.UrlEncode(Common.Encrypt(OnlinePanelID.Trim()))), false);
                }
            }
            else
            {
               
                int InvalidPassword = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select InvalidPassword from f_login where UserName=@UserName AND InvalidPassword>=3",
                    new MySqlParameter("@UserName", txtUserName.Text.Trim())));
                if (InvalidPassword >= 3)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('You have exceeded the number of allowed login attempts.\\nYou will be redirect to verify your login.');window.location='ForgotPassword.aspx';", true);
                    return;
                }
                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT cm.Centre,cm.Type1,fl.EmployeeID,fl.UserName,em.name EmpName,fl.RoleID,rm.RoleName,fl.CentreID,pm.IsInvoice,em.IsSalesTeamMember,em.`AccessDepartment`,em.IsHideRate,IFNULL(em.AccessStoreLocation,'')AccessStoreLocation,  ");
                sb.Append(" IFNULL((SELECT IF(Panel_ID=InvoiceTo,'PCC','SUBPCC') FROM f_Panel_master WHERE Employee_ID=fl.EmployeeID),'') PanelType ");
                sb.Append(" FROM f_login fl INNER JOIN employee_master em on fl.EmployeeID = em.Employee_ID ");
                sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=fl.CentreID ");
                sb.Append(" INNER JOIN f_rolemaster rm ON rm.ID=fl.RoleID ");
                sb.Append(" INNER JOIN f_panel_Master pm ON pm.CentreID=cm.CentreID  WHERE fl.Active = 1 AND em.IsActive=1 ");
                sb.Append(" AND BINARY PASSWORD(fl.UserName) = PASSWORD(@Username) AND BINARY PASSWORD(fl.Password) = PASSWORD(@Password)  ORDER BY fl.isDefault desc");
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@Username", txtUserName.Text.Trim()),
                 new MySqlParameter("@Password", txtPassword.Text.Trim())).Tables[0])
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
                            new MySqlParameter("@ipAddress", StockReports.GetIPAddress()), new MySqlParameter("@HostName", Request.UserHostName));

                        Session["Centre"] = Util.GetString(dt.Rows[0]["CentreID"]);
                        Session["LoginType"] = Util.GetString(dt.Rows[0]["RoleName"]);
                        Session["UserName"] = txtUserName.Text.Trim();
                        Session["ID"] = Util.GetString(dt.Rows[0]["EmployeeID"]);
                        Session["LoginName"] = Util.GetString(dt.Rows[0]["EmpName"]);
                        Session["RoleID"] = Util.GetString(dt.Rows[0]["RoleID"]);
                        Session["CentreName"] = Util.GetString(dt.Rows[0]["Centre"]);
                        Session["CentreType"] = Util.GetString(dt.Rows[0]["Type1"]);
                        Session["IsInvoice"] = Util.GetString(dt.Rows[0]["IsInvoice"]);
                        Session["PanelType"] = Util.GetString(dt.Rows[0]["PanelType"]);
                        Session["PROID"] = "0";
                        Session["IsSalesTeamMember"] = Util.GetString(dt.Rows[0]["IsSalesTeamMember"]);
						if (dt.Rows[0]["IsSalesTeamMember"].ToString() == "1")
                {
                    string _TeamMember = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`('" + dt.Rows[0]["EmployeeID"].ToString() + "',@ChildNode);");
                    _TeamMember = "'" + _TeamMember + "'";
                    _TeamMember = _TeamMember.Replace(",", "','");
                    Session["AccessPROIDs"] = _TeamMember;
                }
                else
                {
                    Session["AccessPROIDs"] = "";
                }
                        Session["AccessDepartment"] = Util.GetString(dt.Rows[0]["AccessDepartment"]);
                        Session["IsHideRate"] = Util.GetString(dt.Rows[0]["IsHideRate"]);
                        Session["AccessStoreLocation"] = Util.GetString(dt.Rows[0]["AccessStoreLocation"]);
                        UpdateLoginDetails(Util.GetString(dt.Rows[0]["EmployeeID"]), con);
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
    private void UpdateLoginDetails(string EmployeeID, MySqlConnection con)
    {
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Update f_login Set LastLoginTime=CurLoginTime,CurLoginTime=@CurLoginTime,NoOfLogins=NoOfLogins+1,Last_IPAddress=@Last_IPAddress WHERE EmployeeID=@EmployeeID",
             new MySqlParameter("@CurLoginTime", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")), new MySqlParameter("@EmployeeID", EmployeeID),
             new MySqlParameter("@Last_IPAddress", AllLoad_Data.IpAddress()));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        HttpCookie cookie = Request.Cookies["Login"];
        if (cookie == null)
        {
            cookie = new HttpCookie("Login");
            cookie.Value = Guid.NewGuid().ToString();
        }
        else
        {
            cookie.Value = Guid.NewGuid().ToString();
        }
        cookie.Expires = DateTime.UtcNow.AddMinutes(30);
        Response.Cookies.Add(cookie);
        Session["CookiesLogin"] = cookie.Value;
        Session["CookiesLoginDateTime"] = DateTime.UtcNow.AddMinutes(30);

        Login();
    }
}
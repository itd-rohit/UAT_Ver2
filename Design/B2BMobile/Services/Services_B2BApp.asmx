<%@ WebService Language="C#" Class="Services_B2BApp" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.UI;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class Services_B2BApp : System.Web.Services.WebService
{
    string url = "http://182.18.138.149/ItdoseLab/Design/";
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetPageData()
    {
        ParamLPageData param = new ParamLPageData();
        param.status = "failure";        
        param.message = "";
        try
        {
            string str = "";
            str = "SELECT ID,Color,WelcomeContent as WelcomePageContent,IFNULL(WelcomeText,'')WelcomeText,Concat('" + url + "B2CMobile/Images/','',if(Logo='','default.jpg',Logo))Logo,'ITDOSE INFO SYSTEMS PVT LTD' HeaderText,IsShowPoweredBy,IFNULL(HelpLineNo24x7,'')HelpLineNo24x7 from App_B2B_Setting Limit 1 ";
            param.status = "success";
            DataTable dt = StockReports.GetDataTable(str);
            PageData lo = new PageData();
            lo.ID = Util.GetInt(dt.Rows[0]["ID"]);
            lo.Color = Util.GetString(dt.Rows[0]["Color"]);
            lo.WelcomePageContent = Util.GetString(dt.Rows[0]["WelcomePageContent"]);
            lo.WelcomeText = Util.GetString(dt.Rows[0]["WelcomeText"]);
            lo.Logo = Util.GetString(dt.Rows[0]["Logo"]);
            lo.HeaderText = Util.GetString(dt.Rows[0]["HeaderText"]);
            lo.IsShowPoweredBy = Util.GetInt(dt.Rows[0]["IsShowPoweredBy"]);
            lo.HelpLineNo24x7 = Util.GetString(dt.Rows[0]["HelpLineNo24x7"]);
            System.Collections.Generic.List<PageData> products = new System.Collections.Generic.List<PageData>();
            products.Add(lo);
            param.data = products;           
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            param.message = "There are some techinal issue";
        }

        return JsonConvert.SerializeObject(param);
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Login(string username, string password)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        ParamList param = new ParamList();
        param.status = "failure";
        param.message = "";
        try
        {
            if (username != "" && password != "")
            {

                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT cm.Centre,cm.Type1,fl.EmployeeID,fl.EmployeeID as Employee_Id,pm.company_name as Panel_Name, pm.panel_id ,fl.UserName,Concat(em.Title,'',em.Name) AS NAME,em.Mobile,fl.RoleID,rm.RoleName,fl.CentreID,pm.IsInvoice,em.IsSalesTeamMember,em.`AccessDepartment`,em.IsHideRate,IFNULL(em.AccessStoreLocation,'')AccessStoreLocation  ");
                sb.Append(" FROM f_login fl INNER JOIN employee_master em on fl.EmployeeID = em.Employee_ID ");
                sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=fl.CentreID ");
                sb.Append(" INNER JOIN f_rolemaster rm ON rm.ID=fl.RoleID ");
                sb.Append(" INNER JOIN f_panel_Master pm ON pm.CentreID=cm.CentreID AND pm.PanelType='Centre' WHERE fl.Active = 1 AND em.IsActive=1 ");
                sb.Append(" AND BINARY PASSWORD(fl.UserName) = PASSWORD(@Username) AND BINARY PASSWORD(fl.Password) = PASSWORD(@Password)  ORDER BY fl.isDefault desc LIMIT 1");
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@Username", username.Trim()),
                 new MySqlParameter("@Password", password.Trim())).Tables[0])
                {
                    if (dt.Rows.Count > 0)
                    {
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO f_login_detail(RoleID,EmployeeID,EmployeeName,UserName,CentreID,Browser,ipAddress,HostName) ");
                        sb.Append(" VALUES(@RoleID,@EmployeeID,@EmployeeName,@UserName,@CentreID,@Browser,@ipAddress,@HostName) ");
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@RoleID", Util.GetString(dt.Rows[0]["RoleID"])), new MySqlParameter("@EmployeeID", Util.GetString(dt.Rows[0]["EmployeeID"])),
                            new MySqlParameter("@EmployeeName", Util.GetString(dt.Rows[0]["NAME"])), new MySqlParameter("@UserName", username),
                            new MySqlParameter("@CentreID", Util.GetString(dt.Rows[0]["CentreID"])), new MySqlParameter("@HostName", "Mobile"));

                        LoginData lo = new LoginData();
                        lo.CentreID = Util.GetInt(dt.Rows[0]["CentreID"]);
                        lo.RoleName = Util.GetString(dt.Rows[0]["RoleName"]);
                        lo.UserName = Util.GetString(username);
                        lo.Employee_Id = Util.GetInt(dt.Rows[0]["EmployeeID"]);
                        lo.NAME = Util.GetString(dt.Rows[0]["NAME"]);
                        lo.RoleName = Util.GetString(dt.Rows[0]["RoleID"]);
                        lo.Centre = Util.GetString(dt.Rows[0]["Centre"]);
                        lo.Type1 = Util.GetString(dt.Rows[0]["Type1"]);
                        lo.IsInvoice = Util.GetInt(dt.Rows[0]["IsInvoice"]);
                        lo.IsSalesTeamMember = Util.GetInt(dt.Rows[0]["IsSalesTeamMember"]);
                        lo.IsHideRate = Util.GetInt(dt.Rows[0]["IsHideRate"]);
                        lo.Mobile = Util.GetString(dt.Rows[0]["Mobile"]);
                        lo.panel_id = Util.GetInt(dt.Rows[0]["panel_id"]);
                        lo.AccessStoreLocation = Util.GetString(dt.Rows[0]["AccessStoreLocation"]);
                        lo.AccessDepartment = Util.GetString(dt.Rows[0]["AccessDepartment"]);
                        lo.Panel_Name = Util.GetString(dt.Rows[0]["Panel_Name"]);
                        System.Collections.Generic.List<LoginData> products = new System.Collections.Generic.List<LoginData>();
                        products.Add(lo);
                        param.data = products;
                        param.status = "success";
                    }
                    else
                    {
                        param.message = "INCORRECT USERNAME/PASSWORD";
                    }
                }
            }
            else
            {
                param.message = "PLEASE ENTER USERNAME/PASSWORD";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            param.message = "There are some techinal issue";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
        return JsonConvert.SerializeObject(param);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string ForgotPassword(string UserName, string Mobile, string Email)
    {
        DataTable dt = new DataTable();
        ParamData param = new ParamData();
        param.status = "failure";
        param.data = "[]";
        param.message = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string EmpId = "";
        if (UserName.Trim() == "")
        {
            param.message = "Please Input User Name";

            return GetResult(param);
        }
        if ((Mobile.Trim() == "" && Email.Trim() == "") || UserName.Trim() == "")
        {
            param.message = "Please Input User Name Or Mobile Or Email";
            return GetResult(param);
        }

        try
        {

            EmpId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text,
                    "SELECT f.`EmployeeID` FROM `f_login` f JOIN `employee_master` e ON f.`EmployeeID`=e.`Employee_ID` WHERE  f.`UserName`=@UserName  AND e.`IsActive`=@IsActive AND ( mobile=@Mobile OR e.Email=@Email)LIMIT 1;",
                     new MySqlParameter("@IsActive", "1"),
                new MySqlParameter("@Mobile", Mobile),
                new MySqlParameter("@UserName", UserName),
                new MySqlParameter("@Email", Email)

                ));

            //else if (UserType.Trim() == "PUP")
            //{
            //    EmpId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text,
            //        " SELECT Panel_ID FROM f_panel_master WHERE  PanelType=@PanelType AND IsActive=@IsActive AND PanelUserID=@PanelUserID AND (mobile=@mobile OR EmailID=@EmailID)",
            //        new MySqlParameter("@PanelType", "PUP"),
            //        new MySqlParameter("@IsActive", "1"),
            //        new MySqlParameter("@PanelUserID", UserName.Trim()),
            //        new MySqlParameter("@mobile", Mobile.Trim()),
            //        new MySqlParameter("@EmailID", Email.Trim())));
            //}
            if (EmpId == "")
            {
                param.message = " Invalid Username/Mobile ";

            }
            else
            {
                int limit = 0;
                if (limit == 3)
                {
                    param.message = " Get Otp request exceeded.You can request only 3 times a day ";

                }
                else
                {
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM forget_password WHERE dtEntry>=CURRENT_DATE() AND employee_ID=@Employee_Id and UserType=@UserType", new MySqlParameter("@Employee_Id", EmpId), new MySqlParameter("@UserType", "Employee"))) < 3)
                    {
                        string mobileOtp = Util.getOTP;
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text,
                            "INSERT INTO `forget_password`(`code`,`Employee_Id`,`dtEntry`,UserType) VALUES(@code,@Employee_Id,@dtEntry,@UserType)",
                            new MySqlParameter("@code", mobileOtp),
                            new MySqlParameter("@Employee_Id", EmpId),
                            new MySqlParameter("@dtEntry", DateTime.Now),
                            new MySqlParameter("@UserType", "Employee"));

                        string OTPText = "Your OTP is: " + mobileOtp;
                        if (Mobile.Trim() != "")
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text,
                            "INSERT INTO `sms`(`MOBILE_NO`,`SMS_TEXT`,`IsSend`,UserID,SMS_Type) VALUES(@MOBILE,@OTPText,@IsSend,@Employee_Id,@SMSType)",
                            new MySqlParameter("@MOBILE", Mobile.Trim()),
                            new MySqlParameter("@OTPText", OTPText),
                            new MySqlParameter("@IsSend", 0),
                            new MySqlParameter("@Employee_Id", EmpId),
                            new MySqlParameter("@SMSType", "OTP"));
                            param.status = "success";
                            param.message = "OTP sent";
                            param.data = mobileOtp;

                        }
                        else if (Email.Trim() != "")
                        {
                            ReportEmailClass objEmail = new ReportEmailClass();
                            objEmail.sendEmailOTP(Email, "Your OTP", "Your OTP is: " + mobileOtp, "", "", EmpId, "Employee");
                            param.message = "OTP sent";
                            param.status = "success";
                            param.data = mobileOtp;

                        }
                    }
                    else
                    {
                        param.message = "OTP can be sent for maximum 2 times in a day. Please contact Administrator.";
                    }
                }
            }

            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        catch (Exception ex)
        {
            param.message = "Error Occured. Please contact Administrator.";
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        return GetResult(param);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string validateOTP(string UserName, string Mobile, string Email, string otp)
    {
        ParamData param = new ParamData();
        param.status = "failure";
        param.data = "[]";
        param.message = "";
        string UserType = "Employee";
        string EmployeeId = "";
        try
        {
            if (UserType.Trim() == "Employee")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT f.`code` FROM `forget_password` f");
                sb.Append(" JOIN (SELECT f.`EmployeeID` FROM `f_login` f JOIN `employee_master` e ON f.`EmployeeID`=e.`Employee_ID` WHERE  f.`UserName`=@UserName And (e.`Mobile`=@Mobile or e.Email=@Email) LIMIT 1)t");
                sb.Append(" ON t.EmployeeID=f.`Employee_Id`");
                sb.Append(" WHERE `code`=@code And UserType=@UserType AND `Employee_Id`=t.EmployeeID AND f.`isUsed`='0' AND date(`dtEntry`)=current_Date()");
                string otpupdate = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text,
                    sb.ToString(),
                    new MySqlParameter("@Mobile", Mobile.Trim()),
                     new MySqlParameter("@Email", Email.Trim()),
                    new MySqlParameter("@UserName", UserName),
                    new MySqlParameter("@code", otp),
                    new MySqlParameter("@UserType", UserType.Trim())));
                if (otpupdate == "")
                {
                    param.message = " Incorrect Informations ";

                }
                else
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE forget_password f ");
                    sb.Append(" INNER JOIN f_login fl ON f.`Employee_Id`=fl.`EmployeeID`");
                    sb.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=fl.`EmployeeID` ");
                    sb.Append(" AND f.`code`=@code AND fl.`UserName`=@UserName AND (em.`Mobile`=@Mobile or em.Email=@Email) AND f.`isUsed`=0 And UserType=@UserType ");
                    sb.Append(" SET f.`isUsed`=@isUsed,`dtUsed`=@dtUsed ");
                    MySqlHelper.ExecuteNonQuery(Util.GetMySqlCon(), CommandType.Text,
                    sb.ToString(),
                    new MySqlParameter("@Mobile", Mobile.Trim()),
                     new MySqlParameter("@Email", Email.Trim()),
                    new MySqlParameter("@UserType", UserType.Trim()),
                    new MySqlParameter("@UserName", UserName),
                    new MySqlParameter("@code", otp),
                    new MySqlParameter("@isUsed", "1"),
                    new MySqlParameter("@dtUsed", DateTime.Now));
                    EmployeeId = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text,
                        "SELECT f.`EmployeeID` FROM `f_login` f JOIN `employee_master` e ON f.`EmployeeID`=e.`Employee_ID` WHERE (e.`Mobile`=@Mobile or e.`Email`=@EmailID)  AND f.`UserName`=@UserName LIMIT 1",
                        new MySqlParameter("@Mobile", Mobile),
                        new MySqlParameter("@EmailID", Email.Trim()),
                        new MySqlParameter("@UserName", UserName)));
                    param.status = "success";
                    param.message = EmployeeId;
                }
            }
            else if (UserType.Trim() == "PUP")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT f.`code` FROM `forget_password` f");
                sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=f.`Employee_Id` And PanelUserID=@PanelUserID AND (fpm.`Mobile`=@Mobile OR fpm.`EmailID`=@EmailID) ");
                sb.Append(" WHERE `code`=@code AND UserType=@UserType AND f.`isUsed`='0' AND DATE(`dtEntry`)=CURRENT_DATE() ");

                string otpupdate1 = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text,
                    sb.ToString(),
                    new MySqlParameter("@PanelUserID", UserName.Trim()),
                    new MySqlParameter("@Mobile", Mobile.Trim()),
                    new MySqlParameter("@EmailID", Email.Trim()),
                    new MySqlParameter("@code", otp.Trim()),
                    new MySqlParameter("@UserType", UserType.Trim())));
                if (otpupdate1 == "")
                {
                    param.message = " Incorrect Informations ";

                }
                else
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE forget_password f ");
                    sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=f.`Employee_Id` And PanelUserID=@PanelUserID AND (fpm.`Mobile`=@Mobile OR fpm.`EmailID`=@EmailID) ");
                    sb.Append(" AND f.`code`=@code AND f.`isUsed`=0 And UserType=@UserType ");
                    sb.Append(" SET f.`isUsed`=@isUsed,`dtUsed`=@dtUsed ");
                    MySqlHelper.ExecuteNonQuery(Util.GetMySqlCon(), CommandType.Text,
                    sb.ToString(),
                    new MySqlParameter("@PanelUserID", UserName.Trim()),
                    new MySqlParameter("@Mobile", Mobile.Trim()),
                    new MySqlParameter("@EmailID", Email.Trim()),
                    new MySqlParameter("@UserType", UserType.Trim()),
                    new MySqlParameter("@code", otp),
                    new MySqlParameter("@isUsed", "1"),
                    new MySqlParameter("@dtUsed", DateTime.Now));
                    EmployeeId = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text,
                        "SELECT Panel_ID FROM f_panel_master WHERE  PanelType=@PanelType AND IsActive=@IsActive AND PanelUserID=@PanelUserID AND (mobile=@mobile OR EmailID=@EmailID)",
                        new MySqlParameter("@PanelType", "PUP"),
                        new MySqlParameter("@IsActive", "1"),
                        new MySqlParameter("@PanelUserID", UserName.Trim()),
                        new MySqlParameter("@mobile", Mobile.Trim()),
                        new MySqlParameter("@EmailID", Email.Trim())));
                    param.status = "success";
                    param.message = EmployeeId;
                }
            }
        }
        catch (Exception ex)
        {
            param.message = "Error Occured. Please contact Administrator.";
        }
        return GetResult(param);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string ResetPassword(string Password, string Employeeid)
    {
        ParamData param = new ParamData();
        param.status = "failure";
        param.data = "[]";
        param.message = "";
        try
        {
            string UserType = "Employee";
            if (UserType.Trim() == "Employee")
            {
                MySqlHelper.ExecuteNonQuery(Util.GetMySqlCon(), CommandType.Text,
                    "UPDATE `f_login` SET PASSWORD=@password,InvalidPassword=0 WHERE `EmployeeID`=@Employee_Id",
                    new MySqlParameter("@password", Password),
                    new MySqlParameter("@Employee_Id", Employeeid));
                param.message = "Password successfully updated";
            }
            else if (UserType.Trim() == "PUP")
            {
                MySqlHelper.ExecuteNonQuery(Util.GetMySqlCon(), CommandType.Text,
                    " Update f_panel_master set PanelPassword=@PanelPassword where Panel_ID=@Panel_ID and IsActive=@IsActive And PanelType=@PanelType ",
                    new MySqlParameter("@PanelPassword", Password.Trim()),
                    new MySqlParameter("@Panel_ID", Employeeid),
                    new MySqlParameter("@IsActive", "1"),
                    new MySqlParameter("@PanelType", "PUP"));
                param.status = "success";
                param.message = "Password successfully updated";
            }
        }
        catch (Exception ex)
        {
            param.message = "Error Occured. Please contact Administrator.";
        }
        return GetResult(param);
    }

    public string GetResult(ParamData Param)
    {
        return JsonConvert.SerializeObject(Param);
    }

    public class ParamData
    {
        public string status { get; set; }
        public string message { get; set; }
        public string data { get; set; }

    }
    public class ParamList
    {
        public string status { get; set; }
        public string message { get; set; }
        public System.Collections.Generic.List<LoginData> data { get; set; }

    }
    public class ParamLPageData
    {
        public string status { get; set; }
        public string message { get; set; }
        public System.Collections.Generic.List<PageData> data { get; set; }

    }
    public class LoginData
    {
        public string Centre { get; set; }
        public string Type1 { get; set; }
        public int EmployeeID { get; set; }
        public int Employee_Id { get; set; }
        public string Panel_Name { get; set; }
        public int panel_id { get; set; }
        public string UserName { get; set; }
        public string NAME { get; set; }
        public string Mobile { get; set; }
        public int RoleID { get; set; }
        public string RoleName { get; set; }
        public int CentreID { get; set; }
        public int IsInvoice { get; set; }
        public int IsSalesTeamMember { get; set; }
        public string AccessDepartment { get; set; }
        public int IsHideRate { get; set; }
        public string AccessStoreLocation { get; set; }
    }
    public class PageData
    {
        public int ID { get; set; }
        public string Color { get; set; }
        public string WelcomePageContent { get; set; }
        public string WelcomeText { get; set; }
        public string Logo { get; set; }
        public string HeaderText { get; set; }
        public int IsShowPoweredBy { get; set; }
        public string HelpLineNo24x7 { get; set; }
    }

}
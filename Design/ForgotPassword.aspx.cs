using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_ForgotPassword : System.Web.UI.Page
{
    public string PUPPortalLogin = "0";
    public DataTable Layouts;
    public string EmployeeId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        AllDesign();
        if (!IsPostBack)
        {
            imgClientLogo.ImageUrl = GetGlobalResourceObject("Resource", "ClientLogo").ToString();
            Image1.ImageUrl = imgClientLogo.ImageUrl;
            
            resetPassDiv.Visible = false;
            lblError.Visible = false;
            btnResetShow.Visible = true;
        }
    }

    private void AllDesign()
    {
        Layouts = StockReports.GetDataTable("SELECT `Type`,`Content` FROM `cms_content`");
    }

    protected void btnOTp_Click(object sender, EventArgs e)
    {
        bool Verified = false;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string EmpId = "";
        string UserType = ddlUserType.SelectedValue;
        if (txtUserName.Text.Trim() == "")
        {
            lblError.Text = "Please Input User Name";
            lblError.Visible = true;
            return;
        }
        if ((txtMobile.Text.Trim() == "" && txtEmail.Text.Trim() == "") || txtUserName.Text.Trim() == "")
        {
            lblError.Text = "Please Input User Name Or Mobile Or Email";
            lblError.Visible = true;
            return;
        }

        try
        {
            if (UserType.Trim() == "Employee")
            {
                EmpId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text,
                        "SELECT f.`EmployeeID` FROM `f_login` f JOIN `employee_master` e ON f.`EmployeeID`=e.`Employee_ID` WHERE  f.`UserName`=@UserName  AND e.`IsActive`=@IsActive AND ( mobile=@Mobile OR e.Email=@Email)LIMIT 1;",
                         new MySqlParameter("@IsActive", "1"),
                    new MySqlParameter("@Mobile", txtMobile.Text),
                    new MySqlParameter("@UserName", txtUserName.Text),
                    new MySqlParameter("@Email", txtEmail.Text)

                    ));
            }
            else if (UserType.Trim() == "PUP")
            {
                EmpId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text,
                    " SELECT Panel_ID FROM f_panel_master WHERE  PanelType=@PanelType AND IsActive=@IsActive AND PanelUserID=@PanelUserID AND (mobile=@mobile OR EmailID=@EmailID)",
                    new MySqlParameter("@PanelType", "PUP"),
                    new MySqlParameter("@IsActive", "1"),
                    new MySqlParameter("@PanelUserID", txtUserName.Text.Trim()),
                    new MySqlParameter("@mobile", txtMobile.Text.Trim()),
                    new MySqlParameter("@EmailID", txtEmail.Text.Trim())));
            }
            if (EmpId == "")
            {
                lblError.Text = "[ Invalid Username/Mobile ]";
                lblError.Visible = true;
            }
            else
            {
                int limit = 0;
                if (limit == 3)
                {
                    lblError.Text = "[ Get Otp request exceeded.You can request only 3 times a day ]";
                    lblError.Visible = true;
                }
                else
                {
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM forget_password WHERE dtEntry>=CURRENT_DATE() AND employee_ID=@Employee_Id and UserType=@UserType", new MySqlParameter("@Employee_Id", EmpId), new MySqlParameter("@UserType", UserType.Trim()))) < 3)
                    {
                        string mobileOtp = Util.getOTP;
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text,
                            "INSERT INTO `forget_password`(`code`,`Employee_Id`,`dtEntry`,UserType) VALUES(@code,@Employee_Id,@dtEntry,@UserType)",
                            new MySqlParameter("@code", mobileOtp),
                            new MySqlParameter("@Employee_Id", EmpId),
                            new MySqlParameter("@dtEntry", DateTime.Now),
                            new MySqlParameter("@UserType", UserType));

                        string OTPText = "Your OTP is: " + mobileOtp;
                        if (txtMobile.Text.Trim() != "")
                        {
                            // Sms_Host objSms = new Sms_Host();
                            // objSms._SmsTo = txtMobile.Text.Trim();
                            //// objSms._Msg = StockReports.ExecuteScalar("select key_value from global_data where key_data='sms_otp'");
                            //// objSms._Msg = objSms._Msg.Replace("{otp}", mobileOtp);
                            // objSms._Msg = "Your OTP is: " + mobileOtp;
                            // objSms.sendSms();
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text,
                            "INSERT INTO `sms`(`MOBILE_NO`,`SMS_TEXT`,`IsSend`,UserID,SMS_Type) VALUES(@MOBILE,@OTPText,@IsSend,@Employee_Id,@SMSType)",
                            new MySqlParameter("@MOBILE", txtMobile.Text.Trim()),
                            new MySqlParameter("@OTPText", OTPText),
                            new MySqlParameter("@IsSend", 0),
                            new MySqlParameter("@Employee_Id", EmpId),
                            new MySqlParameter("@SMSType", "OTP"));
                            lblError.Text = "OTP sent";
                            lblError.Visible = true;
                            btnResetShow.Visible = true;
                        }
                        else if (txtEmail.Text.Trim() != "")
                        {
                            ReportEmailClass objEmail = new ReportEmailClass();
                            objEmail.sendEmailOTP(txtEmail.Text.Trim(), "Your OTP", "Your OTP is: " + mobileOtp, "", "", EmpId, UserType);
                            lblError.Text = "OTP sent";
                            lblError.Visible = true;
                            btnResetShow.Visible = true;
                        }
                    }
                    else
                    {
                        lblError.Text = "OTP can be sent for maximum 2 times in a day. Please contact Administrator.";
                        lblError.Visible = true;
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
            lblError.Text = "Error Occured. Please contact Administrator.";
            //lblError.Text = ex.ToString();
            lblError.Visible = true;
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnResetShow_Click(object sender, EventArgs e)
    {
        string UserType = ddlUserType.SelectedValue;
        if (UserType.Trim() == "Employee")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT f.`code` FROM `forget_password` f");
            sb.Append(" JOIN (SELECT f.`EmployeeID` FROM `f_login` f JOIN `employee_master` e ON f.`EmployeeID`=e.`Employee_ID` WHERE  f.`UserName`=@UserName And (e.`Mobile`=@Mobile or e.Email=@Email) LIMIT 1)t");
            sb.Append(" ON t.EmployeeID=f.`Employee_Id`");
            sb.Append(" WHERE `code`=@code And UserType=@UserType AND `Employee_Id`=t.EmployeeID AND f.`isUsed`='0' AND date(`dtEntry`)=current_Date()");
            string otp = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text,
                sb.ToString(),
                new MySqlParameter("@Mobile", txtMobile.Text.Trim()),
                 new MySqlParameter("@Email", txtEmail.Text.Trim()),
                new MySqlParameter("@UserName", txtUserName.Text),
                new MySqlParameter("@code", txtOtp.Text),
                new MySqlParameter("@UserType", UserType.Trim())));
            if (otp == "")
            {
                lblError.Text = "[ Incorrect Informations ]";
                lblError.Visible = true;
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
                new MySqlParameter("@Mobile", txtMobile.Text.Trim()),
                 new MySqlParameter("@Email", txtEmail.Text.Trim()),
                new MySqlParameter("@UserType", UserType.Trim()),
                new MySqlParameter("@UserName", txtUserName.Text),
                new MySqlParameter("@code", txtOtp.Text),
                new MySqlParameter("@isUsed", "1"),
                new MySqlParameter("@dtUsed", DateTime.Now));
                btnOtp.Visible = false;
                resetPassDiv.Visible = true;
                GetOtpDiv.Visible = false;
                lblError.Text = "";
                lblError.Visible = false;
                EmployeeId = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text,
                    "SELECT f.`EmployeeID` FROM `f_login` f JOIN `employee_master` e ON f.`EmployeeID`=e.`Employee_ID` WHERE (e.`Mobile`=@Mobile or e.`Email`=@EmailID)  AND f.`UserName`=@UserName LIMIT 1",
                    new MySqlParameter("@Mobile", txtMobile.Text),
                    new MySqlParameter("@EmailID", txtEmail.Text.Trim()),
                    new MySqlParameter("@UserName", txtUserName.Text)));
                hdfEmpCOde.Value = EmployeeId;
            }
        }
        else if (UserType.Trim() == "PUP")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT f.`code` FROM `forget_password` f");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=f.`Employee_Id` And PanelUserID=@PanelUserID AND (fpm.`Mobile`=@Mobile OR fpm.`EmailID`=@EmailID) ");
            sb.Append(" WHERE `code`=@code AND UserType=@UserType AND f.`isUsed`='0' AND DATE(`dtEntry`)=CURRENT_DATE() ");

            string otp = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text,
                sb.ToString(),
                new MySqlParameter("@PanelUserID", txtUserName.Text.Trim()),
                new MySqlParameter("@Mobile", txtMobile.Text.Trim()),
                new MySqlParameter("@EmailID", txtEmail.Text.Trim()),
                new MySqlParameter("@code", txtOtp.Text.Trim()),
                new MySqlParameter("@UserType", UserType.Trim())));
            if (otp == "")
            {
                lblError.Text = "[ Incorrect Informations ]";
                lblError.Visible = true;
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
                new MySqlParameter("@PanelUserID", txtUserName.Text.Trim()),
                new MySqlParameter("@Mobile", txtMobile.Text.Trim()),
                new MySqlParameter("@EmailID", txtEmail.Text.Trim()),
                new MySqlParameter("@UserType", UserType.Trim()),
                new MySqlParameter("@code", txtOtp.Text),
                new MySqlParameter("@isUsed", "1"),
                new MySqlParameter("@dtUsed", DateTime.Now));
                btnOtp.Visible = false;
                resetPassDiv.Visible = true;
                GetOtpDiv.Visible = false;
                lblError.Text = "";
                lblError.Visible = false;
                EmployeeId = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text,
                    "SELECT Panel_ID FROM f_panel_master WHERE  PanelType=@PanelType AND IsActive=@IsActive AND PanelUserID=@PanelUserID AND (mobile=@mobile OR EmailID=@EmailID)",
                    new MySqlParameter("@PanelType", "PUP"),
                    new MySqlParameter("@IsActive", "1"),
                    new MySqlParameter("@PanelUserID", txtUserName.Text.Trim()),
                    new MySqlParameter("@mobile", txtMobile.Text.Trim()),
                    new MySqlParameter("@EmailID", txtEmail.Text.Trim())));
                hdfEmpCOde.Value = EmployeeId;
            }
        }
    }

    protected void btnREset(object sender, EventArgs e)
    {
        try
        {
            string UserType = ddlUserType.SelectedValue;
            if (UserType.Trim() == "Employee")
            {
                MySqlHelper.ExecuteNonQuery(Util.GetMySqlCon(), CommandType.Text,
                    "UPDATE `f_login` SET PASSWORD=@password,InvalidPassword=0 WHERE `EmployeeID`=@Employee_Id",
                    new MySqlParameter("@password", txtPassword.Text),
                    new MySqlParameter("@Employee_Id", hdfEmpCOde.Value));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('Password successfully updated');window.location='default.aspx';", true);
            }
            else if (UserType.Trim() == "PUP")
            {
                MySqlHelper.ExecuteNonQuery(Util.GetMySqlCon(), CommandType.Text,
                    " Update f_panel_master set PanelPassword=@PanelPassword where Panel_ID=@Panel_ID and IsActive=@IsActive And PanelType=@PanelType ",
                    new MySqlParameter("@PanelPassword", txtPassword.Text.Trim()),
                    new MySqlParameter("@Panel_ID", hdfEmpCOde.Value),
                    new MySqlParameter("@IsActive", "1"),
                    new MySqlParameter("@PanelType", "PUP"));

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('Password successfully updated');window.location='default.aspx';", true);
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('" + ex.Message + "');window.location='default.aspx';", true);
        }
    }
}
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Employee_EmployeeRegistration : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ddlPRO.Visible = true;
        try
        {
            if (IsPostBack == false)
            {
                bindAllData();
                BindPRO();
                AllLoad_Data.bindDesignation(ddlDesignation, "Select");
                calStartDate.EndDate = DateTime.Now;
                calDOB.EndDate = DateTime.Now;
                if (System.Convert.ToString(Request.QueryString["Employee_ID"]) != null)
                {
                    lblEmployee_ID.Text = Common.Decrypt(Request.QueryString["Employee_ID"].ToString());
                    BindEmployeeDetail();
                }
                else
                {
                    lblEmployee_ID.Text = string.Empty;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog CL = new ClassLog();
            CL.errLog(ex);
        }
        txtStartTime.Attributes.Add("readOnly", "readOnly");
        txtDOB.Attributes.Add("readOnly", "readOnly");
    }

    private void bindAllData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            cmgBloodGroup.DataSource = AllGlobalFunction.BloobGroup;
            cmgBloodGroup.DataBind();
            cmdTitle.DataSource = AllGlobalFunction.NameTitle;
            cmdTitle.DataBind();
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ObservationType_ID,NAME FROM `observationtype_master` WHERE IsActive=1").Tables[0])
            {
                chlDepartments.DataSource = dt;
                chlDepartments.DataTextField = "Name";
                chlDepartments.DataValueField = "ObservationType_ID";
                chlDepartments.DataBind();
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,RoleName FROM f_rolemaster WHERE active=1").Tables[0])
            {
                ChlRoles.DataSource = dt;
                ChlRoles.DataTextField = "RoleName";
                ChlRoles.DataValueField = "ID";
                ChlRoles.DataBind();
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Name,User_Type_ID FROM user_type_master order by id desc").Tables[0])
            {
                cmbUserType.DataSource = dt;
                cmbUserType.DataTextField = "Name";
                cmbUserType.DataValueField = "User_Type_ID";
                cmbUserType.DataBind();
                cmbUserType.Items.Insert(0, new ListItem("Select", "0"));
            }
            ProMaster(con);
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

    private void ProMaster(MySqlConnection con)
    {
        bool IsLocalConn = false;
        if (con != null)
        {
            IsLocalConn = true;
            con = Util.GetMySqlCon();
            con.Open();
        }
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT proid,CONCAT(Title,ProName) proname FROM pro_master WHERE isActive=1").Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    ddlPRO.DataSource = dt;
                    ddlPRO.DataTextField = "proname";
                    ddlPRO.DataValueField = "proid";
                    ddlPRO.DataBind();
                    ddlPRO.Items.Insert(0, new ListItem("NA", "0"));
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
            if (IsLocalConn)
            {
                con.Close();
                con.Dispose();
            }
        }
    }

    private void BindPRO()
    {
        DataTable dt = StockReports.GetDataTable("SELECT Employee_Id,Name FROM Employee_master WHERE IsActive=1 and Designation ='Head PRO' order by Name");
        ddlPROHead.DataSource = dt;
        ddlPROHead.DataTextField = "Name";
        ddlPROHead.DataValueField = "Employee_Id";
        ddlPROHead.DataBind();
        ddlPROHead.Items.Insert(0, new ListItem("Select", "0"));
    }
    protected void chkCentres_DataBound(object sender, EventArgs e)
    {
        CheckBoxList chkList = (CheckBoxList)(sender);
        foreach (ListItem item in chkList.Items)
        {
            item.Attributes.Add("id", item.Value);
            item.Attributes.Add("chk_text", item.Text);
        }
    }

    protected void chkDeptmnts_DataBound(object sender, EventArgs e)
    {
        CheckBoxList chkLsdept = (CheckBoxList)(sender);
        foreach (ListItem item in chkLsdept.Items)
        {
            item.Attributes.Add("id", item.Value);
            item.Attributes.Add("chk_text", item.Text);
        }
    }

    protected void chkRoles_DataBound(object sender, EventArgs e)
    {
        CheckBoxList chkList = (CheckBoxList)(sender);
        foreach (ListItem item in chkList.Items)
        {
            item.Attributes.Add("id", item.Value);
            item.Attributes.Add("chk_text", item.Text);
        }
    }

    protected void BindEmployeeDetail()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select *,IF(DOB='0001-01-01','', DATE_FORMAT(DOB,'%d-%b-%Y'))DateOfBirth from employee_master where Employee_ID=@empid", new MySqlParameter("@empid", lblEmployee_ID.Text.Trim())).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    cmdTitle.SelectedIndex = cmdTitle.Items.IndexOf(cmdTitle.Items.FindByText(dt.Rows[0]["Title"].ToString()));
                    if (cmdTitle.SelectedValue == "Dr.")
                    {
                        chkAllowSharing.Visible = true;
                    }
                    else
                    {
                        chkAllowSharing.Visible = false;
                    }

                    if (dt.Rows[0]["AllowSharing"].ToString() == "1")
                    {
                        chkAllowSharing.Checked = true;
                    }
                    //BindPRO();
                    ddlPROHead.SelectedValue = dt.Rows[0]["PROHeadID"].ToString();
                    txName.Text = dt.Rows[0]["Name"].ToString();
                    txtHouseNo.Text = dt.Rows[0]["House_No"].ToString();
                    txtStreet.Text = dt.Rows[0]["Street_Name"].ToString();
                    txtCity.Text = dt.Rows[0]["City"].ToString();
                    txtLocality.Text = dt.Rows[0]["Locality"].ToString();
                    txtPinCode.Text = dt.Rows[0]["PinCode"].ToString();

                    txtEmail.Text = dt.Rows[0]["Email"].ToString();
                    txtSTD.Text = dt.Rows[0]["Phone"].ToString().Split('-')[0];
                    if (dt.Rows[0]["Phone"].ToString().Split('-').Length > 1)
                        txtPhone.Text = dt.Rows[0]["Phone"].ToString().Split('-')[1];

                    txtMobile.Text = dt.Rows[0]["Mobile"].ToString();

                    txtOhouseNo.Text = dt.Rows[0]["PHouse_No"].ToString();
                    txtOStreet.Text = dt.Rows[0]["PStreet_Name"].ToString();
                    txtOCity.Text = dt.Rows[0]["PCity"].ToString();
                    txtOlocality.Text = dt.Rows[0]["PLocality"].ToString();
                    txtOPinCode.Text = dt.Rows[0]["PPinCode"].ToString();

                    txtFather.Text = dt.Rows[0]["FatherName"].ToString();
                    txtMother.Text = dt.Rows[0]["MotherName"].ToString();
                    txtqualification.Text = dt.Rows[0]["qualification"].ToString();
                    txtDOB.Text = dt.Rows[0]["DateOfBirth"].ToString();
                    txtESI.Text = dt.Rows[0]["ESI_No"].ToString();
                    txtEPF.Text = dt.Rows[0]["EPF_No"].ToString();
                    txtPAN.Text = dt.Rows[0]["PAN_No"].ToString();
                    txtPassport.Text = dt.Rows[0]["PassportNO"].ToString();
                    ddlDesignation.SelectedValue = dt.Rows[0]["DesignationID"].ToString();
                    // ddlValidateLogin.SelectedValue = dt.Rows[0]["ValidateLogin"].ToString();
                    txtuid.Enabled = (dt.Rows[0]["ValidateLogin"].ToString() == "1") ? false : true;
                    txtHouseNo.Enabled = (dt.Rows[0]["ValidateLogin"].ToString() == "1") ? false : true;
                    ddlPRO.SelectedValue = dt.Rows[0]["PROID"].ToString();
                    //  txtStartTime.Text=dt.Rows[0]["StartDate"].ToString();
                    if (dt.Rows[0]["ApproveSpecialRate"].ToString() == "1")
                        chkApproveSpecialRate.Checked = true;
                    else
                        chkApproveSpecialRate.Checked = false;
                    if (dt.Rows[0]["AmrValueAccess"].ToString() == "1")
                        chkAmrValueAccess.Checked = true;
                    else
                        chkAmrValueAccess.Checked = false;
                    if (dt.Rows[0]["IsMobileAccess"].ToString() == "1")
                        IsMobile.Checked = true;
                    else
                        IsMobile.Checked = false;

                    if (dt.Rows[0]["IsHideRate"].ToString() == "1")
                        chkHideRate.Checked = true;
                    else
                        chkHideRate.Checked = false;

                    if (dt.Rows[0]["IsEditMacReading"].ToString() == "1")
                        chkIsEditMacReading.Checked = true;
                    else
                        chkIsEditMacReading.Checked = false;
                    chkSampleReject.Checked = Util.GetString(dt.Rows[0]["IsSampleLogisticReject"]) == "1" ? true : false;
                    chkGlobalReportAccess.Checked = Util.GetString(dt.Rows[0]["GlobalReportAccess"]) == "1" ? true : false;
                    cmbHospital.Visible = false;
                    cmgBloodGroup.SelectedIndex = cmgBloodGroup.Items.IndexOf(cmgBloodGroup.Items.FindByText(dt.Rows[0]["BloodGroup"].ToString()));

                    txtuid.Text = MySqlHelper.ExecuteScalar(con, CommandType.Text, "select Username from f_login where EmployeeID=@empid",
                        new MySqlParameter("@empid", lblEmployee_ID.Text.Trim())).ToString();

                    if (dt.Rows[0]["AccessDepartment"].ToString() != string.Empty)
                    {
                        int len = Util.GetInt(dt.Rows[0]["AccessDepartment"].ToString().Split(',').Length);
                        string[] Item = new string[len];
                        Item = dt.Rows[0]["AccessDepartment"].ToString().Split(',');

                        for (int i = 0; i < len; i++)
                        {
                            for (int k = 0; k <= chlDepartments.Items.Count - 1; k++)
                            {
                                if (Item[i] == chlDepartments.Items[k].Value)
                                {
                                    chlDepartments.Items[k].Selected = true;
                                }
                            }
                        }
                    }

                    //using (DataTable dtcntr = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select DISTINCT CentreID from f_login where EmployeeID=@empid",
                    //      new MySqlParameter("@empid", lblEmployee_ID.Text.Trim())).Tables[0])
                    using (DataTable dtrol = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select DISTINCT RoleID from f_login where EmployeeID=@empid",
                        new MySqlParameter("@empid", lblEmployee_ID.Text.Trim())).Tables[0])
                    {
                        chkLogin.Checked = false;
                        ddlCentre.Items.Clear();
                        ddlRoles.Items.Clear();

                        for (int i = 0; i < dtrol.Rows.Count; i++)
                        {
                            for (int k = 0; k <= ChlRoles.Items.Count - 1; k++)
                            {
                                if (dtrol.Rows[i]["RoleID"].ToString() == ChlRoles.Items[k].Value)
                                {
                                    ChlRoles.Items[k].Selected = true;
                                    ddlRoles.Items.Insert(i, new ListItem(ChlRoles.Items[k].Text, dtrol.Rows[i]["RoleID"].ToString()));
                                }
                            }
                        }
                    }
                    string defaultRole = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(RoleID,'#',CentreID)DefaultLogin FROM f_login WHERE EmployeeID=@empid AND isDefault=1", new MySqlParameter("@empid", lblEmployee_ID.Text.Trim())).ToString();
                    if (defaultRole != string.Empty)
                    {
                        ddlRoles.SelectedIndex = ddlRoles.Items.IndexOf(ddlRoles.Items.FindByValue(defaultRole.Split('#')[0]));
                        // ddlCentre.SelectedIndex = ddlCentre.Items.IndexOf(ddlCentre.Items.FindByValue(defaultRole.Split('#')[1]));
                    }
                    chkLogin.Enabled = true;
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

    [WebMethod(EnableSession = true)]
    public static string SaveData(string Title, string Name, string HouseNo, string Street, string Locality, string City, string Pincode, string OHouse, string OStreet, string OLocality, string OCity, string OPincode, string Father, string Mother, string ESI, string EPF, string PAN, string Passport, string DOB, string Qualification, string Email, string AllowSharing, string STD, string Phone, string Mobile, string BloodGroup, string StartDate, string Username, string Pwd, string ConfirmPwd, string Dept, string Centre, string Role, string Login, int defaultCentreID, string Designation, int defaultRoleID, int ApproveSpecialRate, int AmrValueAccess, int DesignationID, int ValidateLogin, int IsMobileAccess, int PROID, string IsHideRate, string IsEditMacReading, int IsSampleLogisticReject, int GlobalReportAccess,string PROHeadID)
    {
        string rsltt = string.Empty;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction MySqltrans = con.BeginTransaction();
        string Employee_id = string.Empty;
        try
        {
            int EmpCodeQty = Util.GetInt(MySqlHelper.ExecuteScalar(MySqltrans, CommandType.Text, " SELECT COUNT(*) FROM employee_master WHERE house_no=@Houseno AND isactive=1 AND house_no<>'' ", new MySqlParameter("@Houseno", HouseNo.Trim())));
            if (EmpCodeQty > 0)
            {
                MySqltrans.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Employee Code Already Exist...! Please Use Another Employee Code." });
            }
            MSTEmployee objMSTEmployee = new MSTEmployee(MySqltrans);
            objMSTEmployee.Title = Title.Trim();
            objMSTEmployee.Name = Name.Trim();
            objMSTEmployee.House_No = HouseNo.Trim();
            objMSTEmployee.Street_Name = Street.Trim();
            objMSTEmployee.Locality = Locality.Trim();
            objMSTEmployee.City = City.Trim();
            objMSTEmployee.PinCode = Util.GetInt(Pincode.Trim());
            objMSTEmployee.PHouse_No = OHouse.Trim();
            objMSTEmployee.PStreet_Name = OStreet.Trim();
            objMSTEmployee.PLocality = OLocality.Trim();
            objMSTEmployee.PCity = OCity.Trim();
            objMSTEmployee.PPinCode = Util.GetInt(OPincode.Trim());
            objMSTEmployee.FatherName = Father.Trim();
            objMSTEmployee.MotherName = Mother.Trim();
            objMSTEmployee.ESI_No = ESI.Trim();
            objMSTEmployee.EPF_No = EPF.Trim();
            objMSTEmployee.PAN_No = PAN.Trim();
            objMSTEmployee.Passport_No = Passport.Trim();
            if (DOB != string.Empty)
                objMSTEmployee.DOB = Util.GetDateTime(DOB.Trim());
            objMSTEmployee.Qualification = Qualification.Trim();
            objMSTEmployee.Email = Email.Trim();
            objMSTEmployee.AllowSharing = AllowSharing.ToString();

            if (STD != string.Empty || Phone != string.Empty)
            {
                objMSTEmployee.Phone = STD.Trim() + "-" + Phone.Trim();
            }

            objMSTEmployee.Mobile = Mobile.Trim();
            objMSTEmployee.Blood_Group = BloodGroup.Trim();

            if (StartDate != string.Empty)
                objMSTEmployee.StartDate = Util.GetDateTime(StartDate.Trim());

            Dept = Dept.Trim(',');
            objMSTEmployee.AccessDepartment = Dept.ToString();
            objMSTEmployee.Designation = Designation.ToString();
            objMSTEmployee.DesignationID = DesignationID;
            objMSTEmployee.CreatedByID = Util.GetInt(UserInfo.ID);
            objMSTEmployee.ApproveSpecialRate = ApproveSpecialRate;
            objMSTEmployee.AmrValueAccess = AmrValueAccess;
            objMSTEmployee.ValidateLogin = ValidateLogin;
            objMSTEmployee.IsMobileAccess = IsMobileAccess;
            objMSTEmployee.PROID = PROID;
            objMSTEmployee.IsHideRate = Util.GetInt(IsHideRate);
            objMSTEmployee.IsEditMacReading = Util.GetInt(IsEditMacReading);
            objMSTEmployee.IsSampleLogisticReject = IsSampleLogisticReject;
            objMSTEmployee.CreatedBy = UserInfo.LoginName;
            objMSTEmployee.GlobalReportAccess = GlobalReportAccess;
            Employee_id = objMSTEmployee.Insert();

            MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, "Update Employee_Master set PROHeadID='" + PROHeadID  + "' where Employee_Id='"+ Employee_id +"'");
            string rsltdata = SaveLogin(MySqltrans, Employee_id, Username, Pwd, ConfirmPwd, Centre, Role, Login, defaultCentreID, defaultRoleID);
            if (rsltdata == "Invalid Username or Password")
            {
                MySqltrans.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Invalid Username or Password.Username And Password Must Contain Atleast 2 Characters" });
            }
            else if (rsltdata == "Username already in use")
            {
                MySqltrans.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = rsltdata });
            }
            else if (rsltdata == "Username and Password both must be entered")
            {
                MySqltrans.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = rsltdata });
            }
            else if (rsltdata == "Not Saved")
            {
                MySqltrans.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = rsltdata });
            }
            else
            {
                MySqltrans.Commit();
                return JsonConvert.SerializeObject(new { status = true, response = rsltdata });
            }
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Not Saved" });
        }
        finally
        {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string UpdateData(string Title, string Name, string HouseNo, string Street, string Locality, string City, string Pincode, string OHouse, string OStreet, string OLocality, string OCity, string OPincode, string Father, string Mother, string ESI, string EPF, string PAN, string Passport, string DOB, string Qualification, string Email, string AllowSharing, string STD, string Phone, string Mobile, string BloodGroup, string StartDate, string Username, string Pwd, string ConfirmPwd, string Dept, string Centre, string Role, string Login, int defaultCentreID, string Designation, int defaultRoleID, int ApproveSpecialRate, int AmrValueAccess, int DesignationID, string Employee_ID, int ValidateLogin, int IsMobileAccess, int PROID, int IsHideRate, int IsEditMacReading, int IsSampleLogisticReject, int GlobalReportAccess,string PROHeadID)
    {
        string rsltdata;
        string rsltt = string.Empty;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction();
        try
        {
            int EmpCodeQty = Util.GetInt(MySqlHelper.ExecuteScalar(MySqltrans, CommandType.Text, " SELECT COUNT(*) FROM employee_master WHERE house_no=@HouseNo AND isActive=1  AND employee_id<>@empid AND house_no<>'' ", new MySqlParameter("@HouseNo", HouseNo), new MySqlParameter("@empid", Employee_ID.Trim())));
            if (EmpCodeQty > 0)
            {
                MySqltrans.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Employee Code Already Exist...! Please Use Another Employee Code." });
            }
            MSTEmployee objMSTEmployee = new MSTEmployee(MySqltrans);
            objMSTEmployee.Title = Title.Trim();
            objMSTEmployee.Name = Name.Trim();
            objMSTEmployee.House_No = HouseNo.Trim();
            objMSTEmployee.Street_Name = Street.Trim();
            objMSTEmployee.Locality = Locality.Trim();
            objMSTEmployee.City = City.Trim();
            objMSTEmployee.PinCode = Util.GetInt(Pincode.Trim());
            objMSTEmployee.PHouse_No = OHouse.Trim();
            objMSTEmployee.PStreet_Name = OStreet.Trim();
            objMSTEmployee.PLocality = OLocality.Trim();
            objMSTEmployee.PCity = OCity.Trim();
            objMSTEmployee.PPinCode = Util.GetInt(OPincode.Trim());
            objMSTEmployee.FatherName = Father.Trim();
            objMSTEmployee.MotherName = Mother.Trim();
            objMSTEmployee.ESI_No = ESI.Trim();
            objMSTEmployee.EPF_No = EPF.Trim();
            objMSTEmployee.PAN_No = PAN.Trim();
            objMSTEmployee.Passport_No = Passport.Trim();
            objMSTEmployee.DOB = Util.GetDateTime(DOB.Trim());
            objMSTEmployee.Qualification = Qualification.Trim();
            objMSTEmployee.Email = Email.Trim();
            objMSTEmployee.AllowSharing = AllowSharing.ToString();

            if (STD != string.Empty || Phone != string.Empty)
            {
                objMSTEmployee.Phone = STD.Trim() + "-" + Phone.Trim();
            }

            objMSTEmployee.Mobile = Mobile.Trim();
            objMSTEmployee.Blood_Group = BloodGroup.Trim();

            if (StartDate != string.Empty)
                objMSTEmployee.StartDate = Util.GetDateTime(StartDate.Trim());
            else
                objMSTEmployee.StartDate = Util.GetDateTime(StartDate.Trim());
            Dept = Dept.Trim(',');
            objMSTEmployee.AccessDepartment = Dept.ToString();
            objMSTEmployee.Designation = Designation.ToString();
            objMSTEmployee.DesignationID = DesignationID;
            objMSTEmployee.Employee_ID = Employee_ID;
            objMSTEmployee.ApproveSpecialRate = ApproveSpecialRate;
            objMSTEmployee.AmrValueAccess = AmrValueAccess;
            objMSTEmployee.ValidateLogin = ValidateLogin;
            objMSTEmployee.IsMobileAccess = IsMobileAccess;
            objMSTEmployee.PROID = PROID;
            objMSTEmployee.IsHideRate = IsHideRate;
            objMSTEmployee.IsEditMacReading = IsEditMacReading;
            objMSTEmployee.IsSampleLogisticReject = IsSampleLogisticReject;
            objMSTEmployee.GlobalReportAccess = GlobalReportAccess;
            objMSTEmployee.Update();
            MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, "Update Employee_Master set PROHeadID='" + PROHeadID + "' where Employee_Id='" + Employee_ID + "'");
            rsltdata = SaveLogin(MySqltrans, Employee_ID, Username, Pwd, ConfirmPwd, Centre, Role, Login, defaultCentreID, defaultRoleID);
            if (rsltdata == "Invalid Username or Password")
            {
                MySqltrans.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Invalid Username or Password.Username And Password Must Contain Atleast 2 Characters" });
            }
            else if (rsltdata == "Username already in use")
            {
                MySqltrans.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = rsltdata });
            }
            else if (rsltdata == "Username and Password both must be entered")
            {
                MySqltrans.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = rsltdata });
            }
            else if (rsltdata == "Not Saved")
            {
                MySqltrans.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = rsltdata });
            }
            else
            {
                MySqltrans.Commit();
                return JsonConvert.SerializeObject(new { status = true, response = rsltdata });
            }
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Not Saved" });
        }
        finally
        {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string SaveLogin(MySqlTransaction MySqltrans, string EmployeeID, string Username, string Pwd, string ConfirmPwd, string Centre, string Role, string Login, int defaultCentreID, int defaultRoleID)
    {
        int sts = 0;
        int rslt = 0;

        int centreID;
        int roleID;

        int isTPwd = 0;
        string TranPwd = string.Empty;
        if (EmployeeID == string.Empty)
        {
            if (Login == "1")
            {
                Username = Username.Trim();
                Pwd = Pwd.Trim();
                if ((Username.Length < 2) || (Pwd.Length < 2))
                {
                    rslt = -1;
                    return JsonConvert.SerializeObject("Invalid Username or Password");
                }
                else if (Util.GetInt(MySqlHelper.ExecuteScalar(MySqltrans, CommandType.Text, "select count(*) from f_login where lower(username)=lower(@Username)", new MySqlParameter("@Username", Username))) > 0)
                {
                    rslt = -2;
                    return JsonConvert.SerializeObject("Username already in use");
                }
            }
        }
        else
        {
            if (Login == "1")
            {
                Username = Username.Trim();
                Pwd = Pwd.Trim();
                if (Util.GetInt(MySqlHelper.ExecuteScalar(MySqltrans, CommandType.Text, "select count(*) from f_login where lower(username)=lower(@Username) and EmployeeID<>@EmployeeID", new MySqlParameter("@Username", Username), new MySqlParameter("@EmployeeID", EmployeeID))) > 0)
                {
                    rslt = -2;
                    return JsonConvert.SerializeObject("Username already in use");
                }
            }
            else
            {
                DataTable dt = MySqlHelper.ExecuteDataset(MySqltrans, CommandType.Text, "Select username,password,IsTPassword,TPassword from f_login where EmployeeId=@EmployeeID", new MySqlParameter("@EmployeeID", EmployeeID)).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    Username = dt.Rows[0]["Username"].ToString();
                    Pwd = dt.Rows[0]["password"].ToString();
                }
            }
        }

        if ((Username == string.Empty) || (Pwd == string.Empty))
        {
            rslt = -3;
            return JsonConvert.SerializeObject("Username and Password both must be entered");
        }

        MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, "DELETE FROM f_login WHERE EmployeeID=@EmployeeID", new MySqlParameter("@EmployeeID", EmployeeID));

        int isDefault = 0;

        string[] cid = Centre.Split(',');
        string[] rid = Role.Split(',');
        int lenCentreID = Util.GetInt(cid.Length);
        int lenRoleID = Util.GetInt(rid.Length);

        for (int i = 0; i < lenCentreID - 1; i++)
        {
            centreID = Convert.ToInt32(cid[i]);
            for (int j = 0; j < lenRoleID - 1; j++)
            {
                roleID = Convert.ToInt32(rid[j]);
                if (centreID == defaultCentreID && roleID == defaultRoleID)
                    isDefault = 1;
                else
                    isDefault = 0;
                string str1 = "insert into f_login(RoleID,EmployeeID,Username,Password,CentreId,IsTPassword,TPassword,lastpass_dt,isDefault,CreatedByID,CreatedBy,Createdon)" +
                            "values(@roleID,@EmployeeID,@Username,@Pwd,@centreID,@isTPwd,@TranPwd,now(),@isDefault,@CreatedByID,@CreatedBy,NOW())";
                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, str1, new MySqlParameter("@roleID", roleID),
                    new MySqlParameter("@EmployeeID", EmployeeID), new MySqlParameter("@Username", Username),
                    new MySqlParameter("@Pwd", Pwd), new MySqlParameter("@centreID", centreID),
                    new MySqlParameter("@isTPwd", isTPwd), new MySqlParameter("@TranPwd", TranPwd),
                    new MySqlParameter("@isDefault", isDefault),
                    new MySqlParameter("@CreatedByID", UserInfo.ID),
                    new MySqlParameter("@CreatedBy", UserInfo.LoginName));
            }
            sts = 1;
        }
        if (sts == 1)
        {
            rslt = 1;
            return JsonConvert.SerializeObject("Record Saved");
        }
        return JsonConvert.SerializeObject("Not Saved");
    }

    [WebMethod(EnableSession = true)]
    public static string bindBusinessZoneWiseState(string BusinessZoneID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,State FROM state_master WHERE BusinessZoneID IN("+BusinessZoneID+") AND IsActive=1 ORDER BY State").Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject("");
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindStateWiseCentre(string StateID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CentreID,Centre FROM centre_master cm  WHERE cm.IsActive=1 AND cm.StateID IN(" + StateID + ") ORDER BY cm.Centre", new MySqlParameter("@StateID", StateID)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject("");
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindLoginCentre(string EmployeeID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DISTINCT lo.CentreID,cm.Centre,cm.BusinessZoneID,cm.StateID from f_login lo INNER JOIN centre_master cm ON lo.CentreID=cm.CentreID WHERE lo.EmployeeID=@EmployeeID AND cm.IsActive=1", new MySqlParameter("@EmployeeID", EmployeeID)).Tables[0]);
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

    [WebMethod]
    public static string selectDefaultCentre(string Employee_ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CentreID DefaultLogin FROM f_login WHERE EmployeeID=@EmpID AND isDefault=1", new MySqlParameter("@EmpID", Employee_ID)).ToString());
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

    [WebMethod]
    public static string bindZoneWithCentre(string Employee_ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DISTINCT lo.CentreID,cm.Centre from f_login lo INNER JOIN centre_master cm ON lo.CentreID=cm.CentreID WHERE lo.EmployeeID='" + Employee_ID + "' AND cm.IsActive=1").Tables[0]);
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

    [WebMethod]
    public static string SaveDesignation(string DesignationName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int DesignationID;
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, string.Format("select count(*) from f_designation_msater where Name='{0}'", DesignationName)));
            if (count > 0)
            {
                return JsonConvert.SerializeObject("Designation Name Already Exist");
            }
            else
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO f_designation_msater(Name,CreatedByID,CreatedBy,CreatedOn)");
                sb.Append(" VALUES(@Name,@CreatedByID,@CreatedBy,now()) ");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);
                cmd.Parameters.AddWithValue("@Name", DesignationName);
                cmd.Parameters.AddWithValue("@CreatedByID", UserInfo.ID);
                cmd.Parameters.AddWithValue("@CreatedBy", UserInfo.UserName);
                cmd.ExecuteNonQuery();
                DesignationID = Convert.ToInt32(cmd.LastInsertedId);
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { DesignationID = DesignationID, DesignationName = DesignationName });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return JsonConvert.SerializeObject("Error");
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    /* [WebMethod]
     public static string bindAdrenalinData(string EmployeeCode)
     {
         SqlConnection con = new SqlConnection(Util.getApp("AdrenalinConString"));
         SqlDataAdapter da = new SqlDataAdapter("Select * from ADRENALIN_MASTER_FOR_ITAS where EMPLOYEE_EMPLOYEE_ID='"+EmployeeCode+"'", con);
         DataSet ds = new DataSet();
         da.Fill(ds);
         return Util.getJson(ds.Tables[0]);
     }*/

    protected void ckIsPRO_CheckedChanged(object sender, EventArgs e)
    {
        if (ckIsPRO.Checked == true)
        {
            ddlPRO.Visible = true;
            ProMaster(null);
        }
        else
        {
            ddlPRO.Visible = false;
        }
    }
}
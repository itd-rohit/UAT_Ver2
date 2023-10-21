using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public partial class Design_Employee_ChangePassword : System.Web.UI.Page
{
    private string pwd = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtOldPassword.Focus();
            Login();
        }
        lblMsg.Text = string.Empty;
    }

   
    private void ChangePassword()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            int A = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update f_login set lastpass_dt=now(), password=@Password,UserName=@UserName where  EmployeeID=@EmployeeID",
               new MySqlParameter("@Password", txtNewPassword.Text), new MySqlParameter("@UserName", txtUserName.Text.Trim()), new MySqlParameter("@EmployeeID", Session["ID"].ToString()));

            if (A > 0)
            {
                lblMsg.Visible = true;
                lblMsg.Text = "Password Changed Successfully";
            }
            else
            {
                lblMsg.Visible = true;
                lblMsg.Text = "Password Not Changed..";
            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    private void Validation()
    {
        btnSave.Attributes.Add("OnClick", string.Format("ChangePassword('{0}','{1}','{2}','{3}','Old Password',' New Password','Confirm Password');return false;", txtOldPassword.ClientID, txtNewPassword.ClientID, txtConfirmPassword.ClientID, btnSave.ClientID));
    }

    private void Login()
    {
         
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("Select rl.RoleName,rl.ID RoleID,fl.EmployeeID,fl.UserName,fl.Password ");
            sb.Append("from f_login fl inner join f_rolemaster rl on fl.RoleID = rl.ID ");
            sb.Append("Where rl.Active=1 and fl.EmployeeID = @EmployeeID and fl.RoleID = @RoleID and fl.UserName =@UserName");


            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@EmployeeID", Session["ID"].ToString()),
                 new MySqlParameter("@RoleID", Session["RoleID"].ToString()),
                 new MySqlParameter("@UserName", Session["UserName"].ToString())).Tables[0])
            {

                if (dt.Rows.Count > 0)
                {
                    if (Util.GetString(dt.Rows[0]["UserName"]) == "ITDOSE")
                        Session["Ownership"] = "Public";
                    else
                        Session["Ownership"] = "Private";

                    lblUserType.Text = Util.GetString(dt.Rows[0]["RoleName"]);
                    txtUserName.Text = Util.GetString(dt.Rows[0]["UserName"]);
                    ViewState.Add("UserName", dt.Rows[0]["UserName"]);
                    ViewState.Add("pwd", dt.Rows[0]["Password"]);
                    txtOldPassCheck.Text = dt.Rows[0]["Password"].ToString();
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

    protected void btnSave_Click(object sender, EventArgs e)
    {
        //return;

        if (ViewState["pwd"] != null)
        {
            pwd = ViewState["pwd"].ToString();
        }

        if (txtOldPassword.Text == string.Empty)
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Enter Old Password";
            txtOldPassword.Focus();
        }
        else if (txtNewPassword.Text == string.Empty)
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Enter  New Password";
            txtNewPassword.Focus();
        }
        else if (txtConfirmPassword.Text == string.Empty)
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Enter Confirm Password";
            txtConfirmPassword.Focus();
        }
        else if (txtOldPassword.Text.Trim() != pwd)
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Your Old Password Does Not Match. Please Specify Correct Old Password.";
            txtOldPassword.Focus();
            return;
        }
        //else if (txtNewPassword.Text.Length < 6)
        //{
        //    lblMsg.Visible = true;
        //    lblMsg.Text = "Password can't be less than 6 characters";
        //    txtNewPassword.Focus();
        //}
        //else if (txtConfirmPassword.Text.Length < 6)
        //{
        //    lblMsg.Visible = true;
        //    lblMsg.Text = "Password can't be less than 6 characters";
        //    txtConfirmPassword.Focus();
        //}
        else if (txtNewPassword.Text.Trim() != txtConfirmPassword.Text.Trim())
        {
            lblMsg.Visible = true;
            lblMsg.Text = "New Password does not match with the confirmed Password.";
            txtNewPassword.Focus();
            return;
        }
        else
        {
            Validation();
            ChangePassword();
            if (Session["LoginType"].ToString() != "EDP")
            {
                txtUserName.Enabled = false;
                txtConfirmPassword.Enabled = false;
                txtNewPassword.Enabled = false;
                txtOldPassword.Enabled = false;
                btnSave.Enabled = false;
            }
            else
            {
                txtUserName.Text = string.Empty;
                txtConfirmPassword.Text = string.Empty;
                txtNewPassword.Text = string.Empty;
                txtOldPassword.Text = string.Empty;
            }
        }
    }
}
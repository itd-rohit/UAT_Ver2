using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_EDP_UserManager : System.Web.UI.Page
{
    #region Data Binding

    private void BindRole()
    {
        DataTable dt = StockReports.GetDataTable("select ID,RoleName from f_rolemaster order by RoleName");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlRole.DataSource = dt;
            ddlRole.DataTextField = "RoleName";
            ddlRole.DataValueField = "ID";
            ddlRole.DataBind();
            ddlRole.Items.Insert(0, new ListItem("NoRole", "0"));

            ddlRoleRight.DataSource = dt;
            ddlRoleRight.DataTextField = "RoleName";
            ddlRoleRight.DataValueField = "ID";
            ddlRoleRight.DataBind();
        }
    }

    private void BindEmployee()
    {
        StringBuilder sb = new StringBuilder();

        if (ddlRole.SelectedValue == "0")
        {
            sb.Append(" select EM.Employee_ID,em.Name,l.UserName,'false' ltype,'true' ptype from employee_master em left join f_login l on");
            sb.Append(" em.Employee_ID=l.EmployeeID where l.EmployeeID is null order by em.Name");
        }
        else
        {
            sb.Append(" select EM.Employee_ID,em.Name,l.UserName,if(l.username is null,'true','false')ltype,if(l.username is null,'true','false')ptype from employee_master em inner join f_login l on");
            sb.Append(" em.Employee_ID=l.EmployeeID where l.RoleID=" + ddlRole.SelectedValue + " order by em.Name");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdRole.DataSource = dt;
            grdRole.DataBind();
            ViewState.Add("Role", dt);
        }
        else
        {
            lblMsg.Text = "No Record Found";
            grdRole.DataSource = null;
            grdRole.DataBind();
        }
    }

    #endregion Data Binding

    #region Events Handling

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            int uid = UserInfo.ID;
            if (uid != 1)
            {
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "displayalertmessage", "alert('This Menu is for Itdose Team Only');", true);
             
                btnUser.Style["visibility"] = "hidden";
                btnUser.Style["visibility"] = "hidden";
             
            }
            BindRole();

            string str = "select ID,RoleName,isstorepaid from f_rolemaster where active=1 order by RoleName";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt != null && dt.Rows.Count > 0)
            {
                rg.DataSource = dt;
                rg.DataBind();
            }
        }
    }

    protected void btnUser_Click(object sender, EventArgs e)
    {
        BindEmployee();
    }

    protected void grdRole_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AEdit")
        {
            if (ViewState["Role"] != null)
            {
                DataTable dt = new DataTable();
                dt = (DataTable)ViewState["Role"];

                string EmpID = Util.GetString(e.CommandArgument);
                ViewState.Add("EmpId", EmpID);

                DataRow[] dr = dt.Select("Employee_ID='" + EmpID + "'");
                if (dr.Length > 0)
                    lblEmpName.Text = Util.GetString(dr[0]["Name"]);

                mpeCreateGroup.Show();
            }
            else
                lblMsg.Text = "Error...";
        }
        if (e.CommandName == "login")
        {
            if (ViewState["Role"] != null)
            {
                DataTable dt = new DataTable();
                dt = (DataTable)ViewState["Role"];

                string EmpID = Util.GetString(e.CommandArgument);
                ViewState.Add("EmpId", EmpID);

                DataRow[] dr = dt.Select("Employee_ID='" + EmpID + "'");
                if (dr.Length > 0)
                {
                    lblEmp.Text = Util.GetString(dr[0]["Name"]);
                    txtUser.Text = Util.GetString(dr[0]["UserName"]);
                }
                ModalPopupExtender1.Show();
            }
            else
                lblMsg.Text = "Error...";
        }
        if (e.CommandName == "Password")
        {
            if (ViewState["Role"] != null)
            {
                DataTable dt = new DataTable();
                dt = (DataTable)ViewState["Role"];

                string EmpID = Util.GetString(e.CommandArgument);
                ViewState.Add("EmpId", EmpID);

                DataRow[] dr = dt.Select("Employee_ID='" + EmpID + "'");
                if (dr.Length > 0)
                    lblemp1.Text = Util.GetString(dr[0]["Name"]);

                ModalPopupExtender2.Show();
            }
            else
                lblMsg.Text = "Error...";
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ViewState["EmpId"] != null)
        {
            string EmpId = Convert.ToString(ViewState["EmpId"]);

            if (StockReports.ExecuteDML("call InsertRole('" + EmpId + "'," + ddlRoleRight.SelectedValue + ")"))
            {
                lblMsg.Text = "Record Saved Successfully";
                ViewState.Remove("EmpId");
                BindEmployee();
            }
            else
                lblMsg.Text = "Error...";
        }
        else
            lblMsg.Text = "Error...";
    }

    protected void btnSavePassword_Click(object sender, EventArgs e)
    {
        string str = "select * from f_login where username='" + txtUser.Text.Trim() + "'";
        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
            lblMsg.Text = "Sorry!!! User Name Already Exist";
        else
        {
            if (ViewState["EmpId"] != null)
            {
                string EmpId = Convert.ToString(ViewState["EmpId"]);
                string Insert = "update f_login set username='" + txtUser.Text.Trim() + "',Password='" + txtPassword.Text.Trim() + "' where EmployeeID='" + EmpId + "'";

                if (StockReports.ExecuteDML(Insert))
                {
                    lblMsg.Text = "Record Saved Successfully";
                    ViewState.Remove("EmpId");
                    ViewState.Remove("Role");
                    BindEmployee();
                }
                else
                    lblMsg.Text = "Error...";
            }
            else
                lblMsg.Text = "Error...";
        }
    }

    protected void btnSavePwd_Click(object sender, EventArgs e)
    {
        if (ViewState["EmpId"] != null)
        {
            string str = "update f_login set password='" + txtpwd.Text.Trim() + "' where EmployeeID='" + Convert.ToString(ViewState["EmpId"]) + "'";
            if (StockReports.ExecuteDML(str))
                lblMsg.Text = "Password Changed successfully";
            else
                lblMsg.Text = "Error...";
        }
    }

    #endregion Events Handling

    protected void btnSaveRole_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select count(*) from f_rolemaster where upper(RoleName)='" + txtRole.Text.Trim().ToUpper() + "' and Active=1")) == 0)
            {
                

                if (rbtrolldeptlsit.SelectedIndex == 1)
                {
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "insert into f_rolemaster(RoleName,Active) values('" + txtRole.Text.Trim() + "',1)");
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "insert into f_rolemaster(RoleName,Active,isstorepaid) values('" + txtRole.Text.Trim() + "',1,1)");
                }
            }
            else
            {
                lblMsg.Text = "Role is already registered.";
            }
            Tranx.Commit();
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error";
            Tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
        BindRole();
    }

    protected void btnupdate_Click(object sender, EventArgs e)
    {
        foreach (GridViewRow dwr in rg.Rows)
        {
            string roleid = ((Label)dwr.FindControl("lbroleid")).Text;
            string check = Convert.ToInt32(((CheckBox)dwr.FindControl("chkenbl")).Checked).ToString();
            StockReports.ExecuteDML("update f_rolemaster set isstorepaid=" + check + " where id='" + roleid + "' ");
        }

        lblMsg.Text = "Role Updated..!";
        ModalPopupExtender3.Hide();
    }
}
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Employee_EditEmployee : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindRole();
            txtName.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
        }
    }

    protected void BindRole()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT CentreID,IF(IFNULL(CentreCode,'')<>'',CONCAT(CentreCode,' - ',Centre),Centre) Centre FROM centre_master WHERE isActive=1 ORDER BY CentreCode,Centre ");
        ddlCentre.DataSource = dt;
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataTextField = "Centre";
        ddlCentre.DataBind();
        ddlCentre.Items.Insert(0, "");
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindEmployee();
    }

    protected void BindEmployee()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT DISTINCT Employee_ID,NAME,House_No,Mobile,Phone,IF(IsActive=1,'Yes','No')Active,IF(IsActive=1,'True','False') IsActive,fl.UserName, ");
            sb.Append(" DATE_FORMAT(emp.`CreatedDate`,'%d-%b-%Y %h:%i %p')CreatedDate,emp.CreatedBy,DATE_FORMAT(emp.`DeactivatedDateTime`,'%d-%b-%Y %h:%i %p')DeactivatedDateTime,emp.DeactivatedBy ");
            sb.Append(" ,DATE_FORMAT(emp.`LastPasswordChangeDateTime`,'%d-%b-%Y %h:%i %p') LastPasswordChangeDateTime ");
            sb.Append(" FROM employee_master emp LEFT JOIN f_login fl ON emp.Employee_ID=fl.EmployeeID AND fl.active=1 where emp.name<>'' AND  emp.name<>'ITDOSE' ");

            if (rd.SelectedValue == "1")
            {
                sb.Append(" and emp.isactive=1 ");
            }
            if (rd.SelectedValue == "0")
            {
                sb.Append(" and emp.isactive=0 ");
            }
            if (ddlCentre.SelectedIndex > 0)
            {
                sb.Append(" and fl.centreID=@centreID ");
            }

            if (ddlSearchType.SelectedItem.Text != "All")
            {
                if (txtName.Text.Trim() != "")
                {
                    sb.Append(" and " + ddlSearchType.SelectedValue + " like '" + txtName.Text + "%' ");
                }

                if (ddlSearchType.SelectedItem.Text == "PCC")
                {
                    sb.Append(" and fl.roleid='195' ");
                }
                else if (ddlSearchType.SelectedItem.Text == "Sub PCC")
                {
                    sb.Append(" and fl.roleid='214' ");
                }
            }
            if (ddlSearchType.SelectedItem.Text == "PCC" || ddlSearchType.SelectedItem.Text == "Sub PCC")
            {
                sb.Append(" order by fl.UserName  ");
            }
            else
            {
                sb.Append(" order by Name  ");
            }

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@centreID", ddlCentre.SelectedItem.Value)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    GridView1.DataSource = dt;
                    GridView1.DataBind();
                }
                else
                {
                    GridView1.DataSource = null;
                    GridView1.DataBind();
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

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        BindEmployee();
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (e.CommandName == "Active")
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE employee_master SET isActive=1,ActivatedBy=@ActivatedBy,ActivatedByID=@ActivatedByID,ActivatedDate=NOW() where employee_id=@employee_id",
                 new MySqlParameter("@employee_id", e.CommandArgument),
                 new MySqlParameter("@ActivatedBy", UserInfo.LoginName),
                 new MySqlParameter("@ActivatedByID", UserInfo.ID));
            }
            else if (e.CommandName == "Edited")
            {
                string EID = Common.Encrypt(Util.GetString(e.CommandArgument));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Employee/EmployeeRegistration.aspx?Employee_ID=" + EID + "');", true);
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update employee_master SET isActive=0,DeactivatedDateTime=NOW(),DeactivatedBy=@DeactivatedBy,DeactivatedByID=@DeactivatedByID where employee_id=@employee_id",
                    new MySqlParameter("@employee_id", e.CommandArgument),
                    new MySqlParameter("@DeactivatedBy", UserInfo.LoginName),
                    new MySqlParameter("@DeactivatedByID", UserInfo.ID));
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
        BindEmployee();
    }

    [WebMethod(EnableSession = true)]
    public static string GetData(string EmployeeID, string SearchType, string EmployeeName)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            if (SearchType.Trim() == "Role")
            {
                sb.Append(" SELECT   DISTINCT cm1.`RoleName`,'" + EmployeeName + "' EmployeeName  FROM  f_login fl1 INNER JOIN f_rolemaster cm1  ON cm1.id = fl1.roleid   WHERE fl1.`EmployeeID` =" + EmployeeID + "");
            }
            else
            {
                sb.Append("SELECT DISTINCT cm1.`Centre`,'" + EmployeeName + "' EmployeeName FROM f_login fl1 INNER JOIN centre_master cm1 ON cm1.`CentreID` = fl1.`CentreID`  WHERE fl1.`EmployeeID` =" + EmployeeID + "");
            }

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return Util.getJson(dt);
        }
        catch
        {
            return "0";
        }
    }
}
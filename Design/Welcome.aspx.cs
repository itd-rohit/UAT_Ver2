using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Net;
using System.Net.NetworkInformation;
public partial class Design_Welcome : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
            LoadData();
            BindNews();
            bindRole(null, 0);
            WelcomeMessage();

          
            if (Util.GetString(Request.QueryString["days"]) != "" && Util.GetInt(Request.QueryString["days"]) > 35)
            {
                Response.Write(string.Format("<script language='javascript'>alert('Your password will expire after {0} day(s)')</script>", 45 - Util.GetInt(Request.QueryString["days"])));
            }
        }
    }

    private void BindNews()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT content FROM cms_content WHERE TYPE='news' AND content<>''"))
        {
            if (dt.Rows.Count > 0)
            {
                GridNews.DataSource = dt;
                GridNews.DataBind();
                news.Visible = true;
            }
            else
            {
                news.Visible = false;
            }
        }
    }
 

    
    private void LoadData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "Select '' Designation, rl.RoleName,concat(DATE_FORMAT(l.CurLoginTime,'%d-%b-%y'),' ',TIME_FORMAT(l.CurLoginTime,'%h:%i %p'))CurLoginTime,concat(DATE_FORMAT(l.LastLogintime,'%d-%b-%y'),' ',TIME_FORMAT(l.LastLogintime,'%h:%i %p'))LastLogintime,l.NoOfLogins, concat(em.Title,' ',em.Name)EmpName,DATE_FORMAT(l.lastpass_dt,'%d-%b-%Y  %l:%i %p')lastpass_dt  from f_login l inner join f_rolemaster rl on l.RoleID = rl.ID inner join employee_master em on em.Employee_ID = l.EmployeeID  where l.EmployeeID=@EmployeeID and l.RoleID=@RoleID",
             new MySqlParameter("@EmployeeID", Session["ID"]), new MySqlParameter("@RoleID", Session["RoleID"])).Tables[0])
            {
                if (dt != null && dt.Rows.Count > 0)
                {
                    divLastLoginTime.InnerText = Util.GetString(dt.Rows[0]["LastLoginTime"]);
                    divTotalLogin.InnerText = Util.GetString(dt.Rows[0]["NoOfLogins"]);
                    divLastPasswordChange.InnerText = Util.GetString(dt.Rows[0]["lastpass_dt"]);
 
                    divIPAddress.InnerText =   AllLoad_Data.IpAddress();
                }

                string RegPatient = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM f_ledgertransaction WHERE CentreID=@CentreID AND DATE>=CONCAT(current_date(),' 00:00:00') ",
                      new MySqlParameter("@CentreID", UserInfo.Centre)));
                divNoofPatient.InnerText = RegPatient;

                string totalsystemlogin = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(DISTINCT ipaddress) FROM f_login_detail WHERE employeeid=@EmployeeID AND DATE_FORMAT(Logintime,'%Y-%m-%d')=CURRENT_DATE() AND IFNULL(Logouttime,'')=''",
                    new MySqlParameter("@EmployeeID", Session["ID"])));
                divTotalsystemlogin.InnerText = totalsystemlogin;
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
    private void WelcomeMessage()
    {
        DataTable dtMessage = StockReports.GetDataTable("Select Message from welcome_message where Active = '1'");
        if (dtMessage.Rows.Count > 0)
            divWelcomeMessage.InnerHtml = dtMessage.Rows[0]["Message"].ToString();
        else
            divWelcomeMessage.InnerHtml = "";
    }
    private void bindRole(MySqlConnection con, int isConnection)
    {
        DataTable dtData = new DataTable();
        try
        {
            int uid = UserInfo.ID; string role;
            if (uid != 1)
            {
                role = "SELECT DISTINCT RoleID ,ro.`RoleName` FROM f_login lo INNER JOIN `f_rolemaster` ro ON lo.`RoleID`=ro.`ID`  AND lo.roleid<>6 WHERE EmployeeID=@EmployeeID order by RoleName";
            }
            else
            {
                role = "SELECT DISTINCT RoleID ,ro.`RoleName` FROM f_login lo INNER JOIN `f_rolemaster` ro ON lo.`RoleID`=ro.`ID` WHERE EmployeeID=@EmployeeID order by RoleName";
            }
            if (isConnection == 0)
            {

                con = Util.GetMySqlCon();
                con.Open();

                dtData = MySqlHelper.ExecuteDataset(con, CommandType.Text, role,
                    new MySqlParameter("@EmployeeID", UserInfo.ID)).Tables[0];
            }

            using (dtData as IDisposable)
            {
                if (dtData != null && dtData.Rows.Count > 0)
                {
                    ddlRole.DataSource = dtData;
                    ddlRole.DataTextField = "RoleName";
                    ddlRole.DataValueField = "RoleID";
                    ddlRole.DataBind();
                    ddlRole.Items.Insert(0, new ListItem("---Default Role---", "0"));
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
            if (isConnection == 0)
            {
                con.Close();
                con.Dispose();
            }
        }
    }

    protected void ddlRole_SelectedIndexChanged(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction();
        try
        {
               bindRole(con, 1);
          
               MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, "UPDATE f_login SET isDefault=0 where EmployeeId=@EmployeeId and CentreID=@CentreID",
               new MySqlParameter("@EmployeeId", UserInfo.ID), new MySqlParameter("@CentreID", UserInfo.Centre));
               MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, "UPDATE f_login SET isDefault=1 where EmployeeId=@EmployeeId and RoleID=@RoleID and CentreID=@CentreID",
                    new MySqlParameter("@EmployeeId", UserInfo.ID), new MySqlParameter("@RoleID", ddlRole.SelectedValue), new MySqlParameter("@CentreID", UserInfo.Centre));
               MySqltrans.Commit();             
          
            
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string ClientIntimation()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "PUP" || HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "CC" || HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "FC" || HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "B2B")
            {
                if (HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "CC" || HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "FC" || HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "B2B")
                {
                    int IsShowIntimation = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IsShowIntimation FROM f_panel_master WHERE CentreID=@CentreID AND PanelType='Centre' AND Panel_ID=InvoiceTo",
                       new MySqlParameter("@CentreID", HttpContext.Current.Session["Centre"])));
                    if (IsShowIntimation == 1)
                    {
                        return Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT get_client_intimation(@CentreType,@Centre) ",
                            new MySqlParameter("@CentreType", HttpContext.Current.Session["CentreType"]), new MySqlParameter("@Centre", HttpContext.Current.Session["Centre"])));
                    }
                    else
                    {
                        return "-2";
                    }
                }
                else
                {
                    int IsShowIntimation = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IsShowIntimation FROM f_panel_master WHERE Panel_ID=@Panel_ID AND Panel_ID=InvoiceTo",
                        new MySqlParameter("@Panel_ID", HttpContext.Current.Session["OnlinePanelID"])));
                    if (IsShowIntimation == 1)
                    {
                        return Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT get_client_intimation(@CentreType,@OnlinePanelID) ",
                            new MySqlParameter("@CentreType", HttpContext.Current.Session["CentreType"]), new MySqlParameter("@OnlinePanelID", HttpContext.Current.Session["OnlinePanelID"])));
                    }
                    else
                    {
                        return "-2";
                    }
                }
            }
            else
                return "-2";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
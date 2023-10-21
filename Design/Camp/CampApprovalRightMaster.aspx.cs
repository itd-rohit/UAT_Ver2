using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Camp_CampApprovalRightMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindDetail();
        }
    }
    private void bindDetail()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            ddlVerificationType.Items.Insert(0, new ListItem("Select", "0"));
            ddlVerificationType.Items.Insert(1, new ListItem("CampConfiguration", "CampConfiguration"));
            ddlVerificationType.Items.Insert(2, new ListItem("CampRequest", "CampRequest"));
            ddlVerificationType.Items.Insert(3, new ListItem("CampCreation", "CampCreation"));
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT Employee_id,CONCAT(NAME,'~',house_no) AS Employee_name FROM employee_master WHERE isactive=1 AND Employee_id<>'-1' ORDER BY NAME ").Tables[0])
            {
                ddlEmployee.DataSource = dt;
                ddlEmployee.DataTextField = "Employee_name";
                ddlEmployee.DataValueField = "Employee_id";
                ddlEmployee.DataBind();
                ddlEmployee.Items.Insert(0, new ListItem("Select", "0"));
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
    public static string Save(string VerificationType, string EmployeeId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM camp_approvalright_master WHERE ApprovalID=@ApprovalID AND VerificationType=@VerificationType",
                                        new MySqlParameter("@ApprovalID", EmployeeId),
                                        new MySqlParameter("@VerificationType", VerificationType))) > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Approval already exists for this employee" });
            }
            else
            {
                StringBuilder sb_Add = new StringBuilder();
                sb_Add.Append(" INSERT INTO camp_approvalright_master(ApprovalID,VerificationType,IsActive,CreatedDate,CreatedByID,CreatedBy) ");
                sb_Add.Append(" VALUES(@ApprovalID,@VerificationType,1,now(),@CreatedByID,@CreatedBy)  ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb_Add.ToString(),
                            new MySqlParameter("@ApprovalID", EmployeeId),
                            new MySqlParameter("@VerificationType", VerificationType),
                            new MySqlParameter("@CreatedByID", UserInfo.ID),
                            new MySqlParameter("@CreatedBy", UserInfo.LoginName));
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Camp Approval Right Successfully Added", approvalRight = BindApprovalRight(con) });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {

            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string RightsUpdate(string VerificationType, string EmployeeId, int Isactive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM employee_master WHERE Employee_ID=@EmployeeId AND IsActive=0 ",
                                        new MySqlParameter("@EmployeeId", EmployeeId))) > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Employee Is Not Active" });
            }
            else
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE camp_approvalright_master SET IsActive=@IsActive,UpdatedDate=now(),UpdatedBy=@UpdatedBy,UpdatedByID=@UpdatedByID WHERE VerificationType=@VerificationType AND ApprovalID=@ApprovalID ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@ApprovalID", EmployeeId),
                            new MySqlParameter("@VerificationType", VerificationType),
                            new MySqlParameter("@IsActive", Isactive == 1 ? 0 : 1),
                            new MySqlParameter("@UpdatedByID", UserInfo.ID),
                            new MySqlParameter("@UpdatedBy", UserInfo.LoginName));
            }
            tnx.Commit();
            if (Isactive == 1)
                return JsonConvert.SerializeObject(new { status = true, response = "Camp Approval Right Successfully Deactivated", approvalRight = BindApprovalRight(con) });
            else
                return JsonConvert.SerializeObject(new { status = true, response = "Camp Approval Right Successfully Activated", approvalRight = BindApprovalRight(con) });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string BindApprovalData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(new { status = true, response = "", approvalRight = BindApprovalRight(con) });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public static string BindApprovalRight(MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT em.`Name`,SAM.`VerificationType`,em.`Employee_ID`,sam.`IsActive`,IF(sam.`IsActive`=1,'Active','Deactive') STATUS,sam.CreatedBy,DATE_FORMAT(sam.`CreatedDate`,'%d-%b-%Y %I:%i%p') CreateDate FROM `camp_approvalright_master` sam ");
        sb.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=sam.`ApprovalID` ORDER BY SAM.`VerificationType`  ");
        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
                                          return JsonConvert.SerializeObject(dt);
    }
}
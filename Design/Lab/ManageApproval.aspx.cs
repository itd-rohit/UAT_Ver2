using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Investigation_ManageApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            AllLoad_Data.bindRole(DDroleid);
            AllLoad_Data.bindEmployee(ddlEmployee);
            ddlEmployee.Items.Insert(0, "");
            AllLoad_Data.bindEmployee(ddlTecnicianID);
            ddlTecnicianID.Items.Insert(0, "");
            //bindgrid();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindgrid()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT if(ap.DefaultSignature=0,'No','Yes') DefaultSignature, Ap.Id AS id,Ap.Roleid,Ap.EmployeeID,Rm.RoleName as Rolename,em.NAME as empName,ifnull((SELECT NAME FROM employee_master WHERE employee_id=ap.TechnicalId),'')TechName,case when ap.Approval=1 then 'Approve' when ap.Approval=2 then 'Forward' when ap.Approval=3 then 'Aprrove & NotApprove' when Approval=5 then 'Result Entry' else 'Aprrove & NotApprove & Unhold' end AS Authority,IFNULL((SELECT SigantureID FROM f_approval_signature WHERE EmployeeID=em.Employee_id AND isActive=1 LIMIT 1),0)SigantureID FROM f_approval_labemployee Ap INNER JOIN f_rolemaster rm ON ap.roleId=rm.id INNER JOIN employee_master em ON em.Employee_id=Ap.EmployeeId  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string DefaultSignature = "0";
        if (chisdefault.Checked)
        {
            DefaultSignature = "1";
        }
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(tnx,CommandType.Text, "SELECT Roleid FROM f_approval_labemployee WHERE employeeID=@employeeID and TechnicalId=@TechnicalId", new MySqlParameter("@employeeID", ddlEmployee.SelectedValue),
                                                               new MySqlParameter("@TechnicalId", ddlTecnicianID.SelectedValue)).Tables[0];
            if (dt != null && dt.Rows.Count > 0)
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO f_approval_labemployee(RoleID,EmployeeID,Approval,TechnicalId,CreatedBy,CreatedByID,DefaultSignature) values (@RoleID,@EmployeeID,@Approval,@TechnicalId,@CreatedBy,@CreatedByID,@DefaultSignature)",
                                                                   new MySqlParameter("@RoleID", DDroleid.SelectedValue),
                                                                   new MySqlParameter("@EmployeeID", ddlEmployee.SelectedValue),
                                                                   new MySqlParameter("@Approval", rblApproval.SelectedItem.Value.ToString()),
                                                                   new MySqlParameter("@TechnicalId", ddlTecnicianID.SelectedValue),
                                                                   new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                                                                   new MySqlParameter("@CreatedByID", UserInfo.ID),
                                                                   new MySqlParameter("@DefaultSignature", DefaultSignature));

                
                if (dt.Rows[0]["Roleid"].ToString() == DDroleid.SelectedValue.ToString())
                {
                    lblMsg.Text = "This Role ID and Technician is Already Engaged to this Employee";
                    return;
                }
                bindgrid();
            }
            else
            {
                SaveSign(tnx);
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO f_approval_labemployee(RoleID,EmployeeID,Approval,TechnicalId,CreatedBy,CreatedByID,DefaultSignature) values (@RoleID,@EmployeeID,@Approval,@TechnicalId,@CreatedBy,@CreatedByID,@DefaultSignature)",
                                                                  new MySqlParameter("@RoleID", DDroleid.SelectedValue),
                                                                  new MySqlParameter("@EmployeeID", ddlEmployee.SelectedValue),
                                                                  new MySqlParameter("@Approval", rblApproval.SelectedItem.Value.ToString()),
                                                                  new MySqlParameter("@TechnicalId", ddlTecnicianID.SelectedValue),
                                                                  new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                                                                  new MySqlParameter("@CreatedByID", UserInfo.ID),
                                                                  new MySqlParameter("@DefaultSignature", DefaultSignature));
                bindgrid();
                lblMsg.Text = "Record Saved Successfully";
                chisdefault.Checked = false;
            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
        }
        finally {
            tnx.Dispose();
            con.Dispose();
        }
    }

    private void SaveSign(MySqlTransaction tnx)
    {
        
        if (fuSign.PostedFile.ContentLength > 0)
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update f_approval_signature set IsActive=0,UpdatedByID=@UpdatedByID,UpdatedDate=now() where EmployeeID=@EmployeeID",
                                                                 new MySqlParameter("@UpdatedByID", UserInfo.ID),
                                                                 new MySqlParameter("@EmployeeID", ddlEmployee.SelectedValue));



            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO f_approval_signature(EmployeeID,IsActive,CreatedByID,CreatedDate) values (@EmployeeID,@IsActive,@CreatedByID,now())",
                                                                       new MySqlParameter("@EmployeeID", ddlEmployee.SelectedValue),
                                                                       new MySqlParameter("@IsActive", "1"),
                                                                       new MySqlParameter("@CreatedByID", UserInfo.ID));

            string SignatureID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT MAX(SigantureID) AS last_id FROM f_approval_signature"));

            fuSign.SaveAs(Server.MapPath("~/Design/OPD/Signature/" + SignatureID + ".jpg"));
        }
    }

    [WebMethod(EnableSession = true)]
    public static string removeSign(string ID)
    {
        try
        {
            string str = "DELETE  FROM f_approval_labemployee WHERE ID=" + ID.Trim() + "";
            StockReports.ExecuteDML(str);
            return "1";
        }
        catch
        {
            ClassLog cl = new ClassLog();
            return "0";
        }
    }

    
}
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_ManageApprovalStore : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlType.DataSource = StockReports.GetDataTable("SELECT DISTINCT AppRightFor AS ID,AppRightFor AS NAME  FROM st_approvaltype order by apprightfor");
            ddlType.DataValueField = "ID";
            ddlType.DataTextField = "NAME";
            ddlType.DataBind();
            ddlType.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    [WebMethod]
    public static string bindaction(string typeToBind)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("    SELECT typename,TypeIDApprove FROM st_approvaltype WHERE apprightfor='" + typeToBind + "'  ");
    
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
    }


    [WebMethod]
    public static string bindManageApproval(string appRightFor, int Con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT concat('POSign/',st.employeeid,'.jpg') posign, st.ApprightID,st.CreatedBy,st.TypeName,em.name EmployeeName,em.House_no EmployeeCode,st.AppRightFor,st.ShowRate,DATE_FORMAT(st.CreatedDate,'%d-%b-%Y')CreatedDate  ");
        sb.Append(",if(apprightfor='PO' and TypeName='Approval',ifnull(trimzero(POAppLimitPerPO),''),'')POAppLimitPerPO,if(apprightfor='PO' and TypeName='Approval',ifnull(trimzero(POAppLimitPerMonth),''),'')POAppLimitPerMonth,IF(apprightfor='PI' || apprightfor='SI',IF(showrate='0','No','Yes'),'')rateshow ");
        sb.Append(" FROM st_approvalright st INNER JOIN employee_master em ON em.employee_id=st.employeeid WHERE st.Active=1 ");
        if (appRightFor != "0" && Con == 0)
            sb.Append(" AND st.appRightFor='" + appRightFor + "' ");
        sb.Append("ORDER BY em.name,st.AppRightFor,st.TypeName ");
        sb.Append("");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
    }
    [WebMethod]
    public static string SearchEmployee(string query)
    {

        using (DataTable dt = StockReports.GetDataTable("SELECT Employee_ID as value,CONCAT(Title,' ', NAME) AS label FROM `employee_master` WHERE IsActive=1 AND NAME LIKE '" + query + "%'"))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
    }
    [WebMethod]
    public static string SaveApprovalRight(string EmployeeID, string typeData, string appRightFor, string ShowRate, string POAppLimitPerPO, string POAppLimitPerMonth)
    {
        string retValue = "";
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {                    
                    string[] TotaltypeName = typeData.TrimEnd(',').Split(',');
                    for (int i = 0; i < TotaltypeName.Length; i++)
                    {
                        string TypeID = TotaltypeName[i].Split('#')[0];
                        string TypeName = TotaltypeName[i].Split('#')[1];
                        StringBuilder sb = new StringBuilder();
                        sb.Append(" SELECT COUNT(*) FROM st_approvalright WHERE EmployeeID=@EmployeeID AND TypeID=@TypeID AND appRightFor=@appRightFor AND Active=@Active  ");
                        int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                                                new MySqlParameter("@EmployeeID", EmployeeID),
                                                new MySqlParameter("@TypeID", TypeID),
                                                new MySqlParameter("@appRightFor", appRightFor),
                                                new MySqlParameter("@Active", "1")));
                        if (count > 0)
                        {
                            Exception ex = new Exception(TypeName+" Role Already Assigned");                            
                            throw (ex);
                        }
                        string POAppLimitPerPO1 = ""; string POAppLimitPerMonth1 = "";
                        if (appRightFor == "PO" && TypeID == "3")
                        {

                            

                            POAppLimitPerPO1 = POAppLimitPerPO == "" ? "0" : POAppLimitPerPO;
                            POAppLimitPerMonth1 = POAppLimitPerMonth == "" ? "0" : POAppLimitPerMonth;

                            if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " select count(1) from st_posign where EmpID='" + EmployeeID + "' ")) == 0)
                            {
                                Exception ex = new Exception("Please Upload Sign for PO Approval");
                                throw (ex);
                            }
                        }
                        else
                        {
                            POAppLimitPerPO1 = "0";
                            POAppLimitPerMonth1 = "0";
                        }
                       
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO st_approvalright (EmployeeID,typeName,appRightFor,CreatedBy,CreatedByID,ShowRate,TypeID,POAppLimitPerPO,POAppLimitPerMonth) values ");
                        sb.Append(" (@EmployeeID,@typeName,@appRightFor,@CreatedBy,@CreatedByID,@ShowRate,@TypeID,@POAppLimitPerPO,@POAppLimitPerMonth) ");                       
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@EmployeeID", EmployeeID),
                         new MySqlParameter("@typeName", TypeName),
                         new MySqlParameter("@TypeID", TypeID), 
                         new MySqlParameter("@appRightFor", appRightFor),
                         new MySqlParameter("@CreatedBy", UserInfo.LoginName), 
                         new MySqlParameter("@CreatedByID", UserInfo.ID),
                         new MySqlParameter("@ShowRate", ShowRate),
                         new MySqlParameter("@POAppLimitPerPO", POAppLimitPerPO1),
                         new MySqlParameter("@POAppLimitPerMonth", POAppLimitPerMonth1)
                         );
                    }
                    tnx.Commit();
                    retValue="success";
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    tnx.Rollback();
                    retValue = ex.Message;
                }
                finally
                {
                    con.Close();
                }
                return retValue;
            }

        }
    }
    [WebMethod]
    public static string removeManageApproval(string AppRightID)
    {
        
            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                {
                    try
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE st_approvalright SET Active=0,UpdatedByID=@UpdatedByID,UpdatedBy=@UpdatedBy,UpdatedDate=NOW() WHERE AppRightID=@AppRightID",
                         new MySqlParameter("@UpdatedBy", UserInfo.LoginName), new MySqlParameter("@UpdatedByID", UserInfo.ID), new MySqlParameter("@AppRightID", AppRightID)
                            );
                        tnx.Commit();
                        return "1";
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        tnx.Rollback();
                        return "0";
                    }
                    finally
                    {
                        con.Close();
                    }
                }

            
        }
    }

    [WebMethod]
    public static string exportToExcel()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT em.name `EmployeeName`,em.House_no EmployeeCode,st.TypeName `AuthorityType`,st.AppRightFor AccessLabel,IF(apprightfor='PI' || apprightfor='SI',IF(showrate='0','No','Yes'),'') ShowRate,if(apprightfor='PO' and TypeName='Approval',ifnull(trimzero(POAppLimitPerPO),''),'')POAppLimitPerPO,if(apprightfor='PO' and TypeName='Approval',ifnull(trimzero(POAppLimitPerMonth),''),'')POAppLimitPerMonth,st.CreatedBy,DATE_FORMAT(st.CreatedDate,'%d-%b-%Y')CreatedDate  ");
       // sb.Append(" st.UpdatedBy,DATE_FORMAT(st.UpdatedDate,'%d-%b-%Y')UpdatedDate ");
        sb.Append(" FROM st_approvalright st INNER JOIN employee_master em ON em.employee_id=st.employeeid WHERE st.Active=1 ");
        sb.Append("ORDER BY st.CreatedBy,st.AppRightFor,st.TypeName ");
        sb.Append("");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt != null && dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] =  " ManageApproval ";              
                return "1";
            }
            else
                return "0";
        }
    }
}

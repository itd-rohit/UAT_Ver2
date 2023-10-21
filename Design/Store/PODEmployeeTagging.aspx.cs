
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_PODEmployeeTagging : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            
        
        }
    }



    [WebMethod]
    public static string bindemployeedata()
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT DISTINCT Employee_ID,CONCAT(NAME,'(',House_no,')')NAME1 FROM employee_master WHERE isactive=1 AND NAME IS NOT NULL ORDER BY NAME");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
 
    [WebMethod(EnableSession = true)]
    public static string Savedata(string[] FromEmployee, string ToEmployee, string LastId, string CurrierRequired)
    {
        if (Array.Exists(FromEmployee, x => x == ToEmployee))
        {
            return "2# Same employee you haven't tag";
        }
    
         string allemployee = string.Join(",", FromEmployee);
         DataTable dtexist = StockReports.GetDataTable("select id from st_pod_employeetagging where EmployeeIdFrom in(" + allemployee + ") and IsActive=1");
         if (dtexist.Rows.Count > 0) {
             return "3#These Employee Already Exists.";
         }

         DataTable dtopositetag = StockReports.GetDataTable(" SELECT id FROM st_pod_employeetagging WHERE employeeidfrom=" + ToEmployee + " AND employeeidto  in(" + allemployee + ") and IsActive=1");
         if (dtopositetag.Rows.Count > 0)
         {
             return "3#Bidirectional Employee Tagging Not allow.";
         }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {
            bool lastidexist=true;
                for (int i = 0; i < FromEmployee.Length; i++)
                {

                    int j = 0;
                    string islastid = ToEmployee;
                    while (j < 10)
                    {
                        DataTable dtcheckislast = StockReports.GetDataTable(" SELECT id,employeeidfrom,employeeidto,IsLast FROM st_pod_employeetagging WHERE employeeidfrom=" + islastid + " and IsActive=1");
                        if (dtcheckislast.Rows.Count > 0)
                        {
                            if (dtcheckislast.Rows[0]["IsLast"].ToString() == "1")
                            {
                                break;
                            }
                            else
                            {
                                islastid = dtcheckislast.Rows[0]["employeeidto"].ToString();
                            }
                 
                        }
                        else
                        {
                            if (LastId == "1")
                            {
                                lastidexist = true;
                            }
                            else
                            {
                                lastidexist = false;
                            }
                            break;
                            //return "3#Last ID Not Exists For These Employee";
                         
                        }

                        j++;
                    }
                    if (lastidexist)
                    {
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Insert into st_pod_employeetagging(EmployeeIdFrom,EmployeeIdTo,IsLast,IsCurierRequired,IsActive,CreateBy,CreateById,CreateDate) values (@EmployeeIdFrom,@EmployeeIdTo,@IsLast,@IsCurierRequired,1,@CreateBy,@CreateById,now())",
                        new MySqlParameter("@EmployeeIdFrom", FromEmployee[i]),
                         new MySqlParameter("@EmployeeIdTo", ToEmployee),
                          new MySqlParameter("@IsLast", LastId),
                           new MySqlParameter("@IsCurierRequired", CurrierRequired),
                            new MySqlParameter("@CreateBy", UserInfo.LoginName),
                             new MySqlParameter("@CreateById", UserInfo.ID));
                    }
                    else
                    {
                        return "3#Last ID Not Exists For These Employee";
                    }
                }
        Tranx.Commit();
        return "1#";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SearchEmployee(string[] fromid)
    {
        string allemployee = string.Join(",", fromid);
        DataTable dt = StockReports.GetDataTable(@"SELECT id,EmployeeIdFrom,(SELECT NAME FROM employee_master WHERE employee_id=EmployeeIdFrom) fromname,EmployeeIdTo,(SELECT NAME FROM employee_master WHERE employee_id=EmployeeIdTo) toname,IsLast,IsCurierRequired,CreateBy,DATE_FORMAT(CreateDate,'%d-%b-%y')CreateDate FROM `st_pod_employeetagging` where EmployeeIdFrom in (" + allemployee + ") and IsActive=1 ORDER BY id ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string removerow(string id)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try{
        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update st_pod_employeetagging set IsActive=0,UpdateBy=@UpdateBy,UpdateById=@UpdateById,UpdateDate=now() where id=@id ",
                new MySqlParameter("@UpdateBy", UserInfo.LoginName),
                 new MySqlParameter("@UpdateById", UserInfo.ID),
                   new MySqlParameter("@id", id));
        Tranx.Commit();
        return "1#";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }



    [WebMethod(EnableSession = true)]
    public static string ExportToExcel(string[] fromid)
    {

        string allemployee = string.Join(",", fromid);
        DataTable dt = StockReports.GetDataTable(@"SELECT id,EmployeeIdFrom,(SELECT NAME FROM employee_master WHERE employee_id=EmployeeIdFrom) fromname,EmployeeIdTo,(SELECT NAME FROM employee_master WHERE employee_id=EmployeeIdTo) toname,IsLast,IsCurierRequired,CreateBy,DATE_FORMAT(CreateDate,'%d-%b-%y')CreateDate FROM `st_pod_employeetagging` where EmployeeIdFrom in (" + allemployee + ") and IsActive=1 ORDER BY id ");

        DataColumn column = new DataColumn();
        column.ColumnName = "S.No";
        column.DataType = System.Type.GetType("System.Int32");
        column.AutoIncrement = true;
        column.AutoIncrementSeed = 0;
        column.AutoIncrementStep = 1;

        dt.Columns.Add(column);
        int index = 0;
        foreach (DataRow row in dt.Rows)
        {
            row.SetField(column, ++index);
        }
        dt.Columns["S.No"].SetOrdinal(0);
        if (dt.Rows.Count > 0)
        {

            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "PODEmployeeTagMaster";
            return "1";
        }
        return "0";
    }
}
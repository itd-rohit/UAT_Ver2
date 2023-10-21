using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.Services;

public partial class Design_Master_CashOutstandingMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod(EnableSession = true)]
    public static string bindCentre()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT Centreid,centre FROM centre_master WHERE isActive=1  AND Category='Lab' order by centre"));
    }

    [WebMethod(EnableSession = true)]
    public static string bindEmployee()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT employee_id,NAME FROM employee_master ORDER BY NAME"));
    }

    [WebMethod]
    public static string SaveData(string Center, string Emoployee, string MaxOutstandingAmt, string MaxBill)
    {
        string[] AllCenter = Center.Split(',');
        string[] AllEmployee = Emoployee.Split(',');
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            for (int i = 0; i < AllCenter.Length; i++)
            {
                for (int j = 0; j < AllEmployee.Length; j++)
                {
                    string isexist = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Count(EmployeeId) from CashOutStandingMaster where EmployeeId=@EmployeeId and CenterId=@CenterId and IsActive=@IsActive",
                        new MySqlParameter("@EmployeeId", AllEmployee[j]),
                        new MySqlParameter("CenterId", AllCenter[i]),
                        new MySqlParameter("@IsActive", "1")));
                    if (isexist == "0")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO CashOutStandingMaster(CenterId,EmployeeId,MaxOutstandingAmt,MaxBill,IsActive,CreatedById,CreatedBy,CreatedDate)VALUES(@CenterId,@EmployeeId,@MaxOutstandingAmt,@MaxBill,@IsActive,@CreatedById,@CreatedBy,NOW()) ",
                                                     new MySqlParameter("@CenterId", Util.GetInt(AllCenter[i])),
                                                     new MySqlParameter("@EmployeeId", Util.GetInt(AllEmployee[j])),
                                                     new MySqlParameter("@MaxOutstandingAmt", Util.GetDecimal(MaxOutstandingAmt)),
                                                     new MySqlParameter("@MaxBill", Util.GetDecimal(MaxBill)),
                                                      new MySqlParameter("@IsActive", "1"),
                                                     new MySqlParameter("@CreatedById", UserInfo.ID),
                                                     new MySqlParameter("@CreatedBy", UserInfo.LoginName));
                    }
                    else
                    {
                        tnx.Rollback();
                        return "2";
                    }
                }
            }

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
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindData()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT co.id,cm.centre,em.name,co.MaxOutstandingAmt,co.MaxBill,co.CreatedBy,DATE_FORMAT(co.CreatedDate,'%d-%b-%Y') CreatedDate FROM CashOutStandingMaster co INNER JOIN employee_master em ON em.employee_id=co.employeeid INNER JOIN centre_master cm ON cm.centreid=co.centerid where co.IsActive=1 order by co.id desc "));
    }

    [WebMethod]
    public static string UpdateData(string id, string maxamount, string maxbill)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update CashOutStandingMaster set MaxBill=@MaxBill,MaxOutstandingAmt=@MaxOutstandingAmt where id=@id",
                                                      new MySqlParameter("@MaxOutstandingAmt", Util.GetFloat(maxamount)),
                                                      new MySqlParameter("@MaxBill", Util.GetFloat(maxbill)),
                                                      new MySqlParameter("@id", Util.GetInt(id)));

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
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string RemoveData(string id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update CashOutStandingMaster set IsActive=@IsActive,UpdateById=@UpdateById,UpdateBy=@UpdateBy,UpdateDate=now() where id=@id",
                                                   new MySqlParameter("@IsActive", Util.GetString(0)),
                                                   new MySqlParameter("@UpdateById", Util.GetString(UserInfo.ID)),
                                                      new MySqlParameter("@UpdateBy", Util.GetString(UserInfo.LoginName)),
                                                   new MySqlParameter("@id", Util.GetInt(id)));
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
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}
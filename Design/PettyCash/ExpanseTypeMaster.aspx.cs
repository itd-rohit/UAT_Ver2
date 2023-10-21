using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_PettyCash_ExpanseTypeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    public static DataTable bindData(MySqlConnection con)
    {
        return MySqlHelper.ExecuteDataset(con,CommandType.Text,"SELECT Id,TypeName,acc_code,CreateBy,DATE_FORMAT(createDate,'%d-%b-%Y') as date,if(IsActive=1,'Yes','No')Active FROM petty_expansetype").Tables[0];

    }
    [WebMethod]
    public static string bindtabledata()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(bindData(con));
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

    [WebMethod]
    public static string removerow(string id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE petty_expansetype SET IsActive=0,UpdateBy=@UpdateBy,UpdateByID=@UpdateByID,UpdateDate=NOW() WHERE id=@id ",
               new MySqlParameter("@UpdateBy", UserInfo.LoginName),
               new MySqlParameter("@UpdateByID", UserInfo.ID),
               new MySqlParameter("@id", id));

            return JsonConvert.SerializeObject(new { status = true, response = "Record Removed Successfully", responseDetail = Util.getJson(bindData(con)) });

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

    [WebMethod]
    public static string Saveldiagnosisdata(string expansename, string LedgerNo, string id, string Active)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            if (id != string.Empty)
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update petty_expansetype set IsActive=@IsActive ,TypeName=@TypeName,acc_code=@acc_code WHERE id=@id",
                   new MySqlParameter("@IsActive", Active),
                   new MySqlParameter("@TypeName", expansename.Trim()),
                   new MySqlParameter("@acc_code", LedgerNo.Trim()),
                   new MySqlParameter("@id", id));
                tnx.Commit();
                return JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully", responseDetail = Util.getJson(bindData(con)) });
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into petty_expansetype(IsActive,TypeName,acc_code,CreateBy,CreateById,CreateDate) values(@IsActive,@TypeName,@acccode,@CreateBy,@CreatedById,now())",
                           new MySqlParameter("@IsActive", Active),
                           new MySqlParameter("@TypeName", expansename),
                           new MySqlParameter("@acccode", LedgerNo),
                           new MySqlParameter("@CreateBy", UserInfo.LoginName),
                           new MySqlParameter("@CreatedById", UserInfo.ID)
                         );
                tnx.Commit();
                return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully", responseDetail = Util.getJson(bindData(con)) });
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
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
}
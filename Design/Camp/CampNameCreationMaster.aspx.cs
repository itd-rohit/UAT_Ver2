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

public partial class Design_Camp_CampNameCreationMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string CampMaster()
    {
        using (DataTable dt = StockReports.GetDataTable(" SELECT ID,CampName,IF(IsActive=1,'Active','De-Active')IsActive,IsActive IsActiveStatus,CreatedBy,DATE_FORMAT(CreatedDate,'%d-%b-%Y %h:%i %p')CreatedDate FROM camp_request_master"))
        {
            return Util.getJson(dt);
        }
    }
    [WebMethod]
    public static string SaveCamp(string CampName)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM camp_request_master WHERE CampName=@CampName",
                                                new MySqlParameter("@CampName", CampName.Trim())));
            if (count > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Camp Name Already Exits" });
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO camp_request_master(CampName,CreatedByID,CreatedBy)VALUES(@CampName,@CreatedByID,@CreatedBy)",
                        new MySqlParameter("@CampName", CampName.Trim()),
                        new MySqlParameter("@CreatedByID", UserInfo.ID),
                        new MySqlParameter("@CreatedBy", UserInfo.LoginName));

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
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
    [WebMethod]
    public static string UpdateCamp(string CampName,int CampID,int Status)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM camp_request_master WHERE CampName=@CampName AND ID!=@ID",
                                                new MySqlParameter("@CampName", CampName.Trim()),
                                                new MySqlParameter("@ID", CampID)));
            if (count > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Camp Name Already Exits" });
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE camp_request_master SET IsActive=@IsActive,CampName=@CampName,UpdatedByID=@UpdatedByID,UpdatedBy=@UpdatedBy,UpdatedDate=NOW() WHERE ID=@ID",
                        new MySqlParameter("@CampName", CampName.Trim()),
                        new MySqlParameter("@UpdatedByID", UserInfo.ID),
                        new MySqlParameter("@ID", CampID),
                        new MySqlParameter("@IsActive", Status),
                        new MySqlParameter("@UpdatedBy", UserInfo.LoginName));

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully" });
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
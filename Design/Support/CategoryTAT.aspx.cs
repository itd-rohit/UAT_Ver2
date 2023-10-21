using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_Support_CategoryTAT : System.Web.UI.Page
{
    public string CatID = "0";
    public string CategoryName = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString.Count > 0)
        {
            CatID = Common.DecryptRijndael(Request.QueryString[0].Replace(" ","+").ToString());
            CategoryName = Common.DecryptRijndael(Request.QueryString[1].Replace(" ","+").ToString());
        }
        else
        {
            Response.Redirect("CategoryMaster.aspx");
        }
    }

    public static DataTable getDetail(int Id, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select ID,Level1Resolve,Level2Resolve,Level3Resolve,Level1Resp,Level2Resp,Level3Resp,IsActive from ticketing_category_master where ID=@ID");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@ID", Id)).Tables[0];
    }

    [WebMethod]
    public static string GetCategoryTAT(int Id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = getDetail(Id, con))
                return JsonConvert.SerializeObject(new { status = true, response = string.Empty, responseDetail = Util.getJson(dt) });
        }
        catch (Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string UpdateCategoryTAT(int Id, string Level1, string Level2, string Level3, string Level1rp, string Level2rp, string Level3rp)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE  ticketing_category_master SET Level1Resolve=@Level1Resolve,Level2Resolve=@Level2Resolve,Level3Resolve=@Level3Resolve, ");
            sb.Append(" Level1Resp=@Level1Resp,Level2Resp=@Level2Resp,Level3Resp=@Level3Resp,UpdatedBy=@UpdatedBy,UpdatedID=@UpdatedID,UpdatedDate=NOW() WHERE ID=@ID");

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Level1Resolve", Level1),
                new MySqlParameter("@Level2Resolve", Level2),
                new MySqlParameter("@Level3Resolve", Level3),
                new MySqlParameter("@Level1Resp", Level1rp),
                new MySqlParameter("@Level2Resp", Level2rp),
                new MySqlParameter("@Level3Resp", Level3rp),
                new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                new MySqlParameter("@UpdatedID", UserInfo.ID),
                new MySqlParameter("@ID", Id));
            return JsonConvert.SerializeObject(new
            {
                status = true,
                response = "TAT Values Sucessfully Updated",
                responseDetail = Util.getJson(getDetail(Id, con))
            });
        }
        catch (Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Support_CreateResponse : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            GetCategoryList();
        }
    }
    [WebMethod]
    public static string updateResponse(string ID, string Detail, string MainHead, string CategoryID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM support_queryresponse WHERE Detail=@Detail AND ID!=@ID AND IsActive=1 AND Type='Response'",
               new MySqlParameter("@Detail", Detail),
               new MySqlParameter("@ID", ID)));
            if (count == 0)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE support_queryresponse SET MainHead=@MainHead,Detail=@Detail,UpdatedById=@UpdatedById,");
                sb.Append(" UpdatedByName=@UpdatedByName,UpdatedAt=NOW() WHERE ID=@ID");

                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@ID", ID),
                    new MySqlParameter("@UpdatedById", ID),
                    new MySqlParameter("@UpdatedByName", ID),
                    new MySqlParameter("@MainHead", MainHead),
                    new MySqlParameter("@Detail", Detail));
                return JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully", responseDetail = Util.getJson(getResponseList(con)) });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Response Already Exits", responseDetail = string.Empty });

            }
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
    public static string SaveResponse(string Type, string Detail, string MainHead, string CategoryID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM support_queryresponse WHERE Detail=@Detail AND IsActive=1 AND Type='Response'",
                new MySqlParameter("@Detail", Detail)));
            if (count == 0)
            {
                StringBuilder sb = new StringBuilder();

                sb.Append("INSERT INTO `support_queryresponse`(`Type`,`Subject`,`Detail`,`dtEntry`,`EnteredById`,`EnteredByName`,`MainHead`,CategoryID)");
                sb.Append("VALUES(@Type,@Subject,@Detail,NOW(),@EnteredById,@EnteredByName,@MainHead,@CategoryID)");

                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Type", Type),
                    new MySqlParameter("@Subject", string.Empty),
                    new MySqlParameter("@Detail", Detail),
                    new MySqlParameter("@EnteredById", UserInfo.ID),
                    new MySqlParameter("@EnteredByName", UserInfo.LoginName),
                    new MySqlParameter("@MainHead", MainHead),
                    new MySqlParameter("@CategoryID", CategoryID));

                return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully", responseDetail = Util.getJson(getResponseList(con)) });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Response Already Exits", responseDetail = string.Empty });

            }
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
    public static DataTable getResponseList(MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Id,TYPE,SUBJECT,Detail,DATE_FORMAT(dtEntry,'%d-%b-%Y')dtEntry,isActive,MainHead");
        sb.Append(" FROM  Support_queryresponse where Type='Response' AND isActive=1");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];
    }

    [WebMethod(EnableSession = true)]
    public static string GetQueryList()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = getResponseList(con))
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = true, response = "", responseDetail = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = true, response = "No Record Found", responseDetail = string.Empty });
            }
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

    private void GetCategoryList()
    {
        using (DataTable dt = StockReports.GetDataTable(" SELECT ID, CategoryName FROM ticketing_category_master where isActive=1"))
        {
            if (dt.Rows.Count > 0)
            {
                ddlCategory.DataSource = dt;
                ddlCategory.DataTextField = "CategoryName";
                ddlCategory.DataValueField = "ID";
                ddlCategory.DataBind();
            }
            ddlCategory.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    [WebMethod]
    public static string removeResponse(string ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE Support_queryresponse SET isActive=0,UpdatedByName=@UpdatedByName,UpdatedByID=@UpdatedByID,UpdatedAt=NOW() WHERE `Id`=@Id",
                 new MySqlParameter("@Id", ID),
                 new MySqlParameter("@UpdatedByID", UserInfo.ID),
                 new MySqlParameter("@UpdatedByName", UserInfo.LoginName));

            return JsonConvert.SerializeObject(new { status = true, response = "Response Removed Successfully", responseDetail = Util.getJson(getResponseList(con)) });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error", responseDetail = string.Empty });

        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
}
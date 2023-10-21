using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Support_CreateQueryResponse : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            GetCategoryList();
        }
    }
    [WebMethod]
    public static string SaveResponse(string Type, string Subject, string Detail, string MainHead, string CategoryID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO `support_queryresponse`(`Type`,`Subject`,`Detail`,`dtEntry`,`EnteredById`,`EnteredByName`,`MainHead`,CategoryID)");
                sb.Append("VALUES(@Type,@Subject,@Detail,NOW(),@EnteredById,@EnteredByName,@MainHead,@CategoryID)");
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Type", Type),
                    new MySqlParameter("@Subject", Subject),
                    new MySqlParameter("@Detail", Detail),
                    new MySqlParameter("@EnteredById", UserInfo.ID),
                    new MySqlParameter("@EnteredByName", UserInfo.LoginName),
                    new MySqlParameter("@MainHead", MainHead),
                    new MySqlParameter("@CategoryID", CategoryID));

                return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully", responseDetail = Util.getJson(getQueryList(con, CategoryID)) });

            
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
    public static string getDetail(string CategoryID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = getQueryList(con, CategoryID))
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = true, response = "", responseDetail = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found", responseDetail = string.Empty });
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
    public static DataTable getQueryList(MySqlConnection con, string CategoryId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sq.Id,sq.TYPE,sq.SUBJECT,sq.Detail,tcm.CategoryName,sq.CategoryID FROM  Support_queryresponse sq ");
        sb.Append(" INNER JOIN ticketing_category_master tcm ON sq.CategoryID=tcm.ID where sq.Type='Query' AND sq.isActive=1");
        if (CategoryId != "0")
        {
            sb.Append(" AND sq.CategoryId=@CategoryId");
        }
        sb.Append(" ORDER BY sq.SUBJECT");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@CategoryId", CategoryId)).Tables[0];

    }


    private void GetCategoryList()
    {
        using (DataTable dt = StockReports.GetDataTable(" SELECT ID, CategoryName FROM ticketing_category_master where isActive=1 order by  CategoryName"))
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

}
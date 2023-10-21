using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_CallCenter_Inquiry_Master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindGroup();
        }
    }
    public void bindGroup()
    {
        DataTable dt = StockReports.GetDataTable("SELECT GroupID,GroupName FROM CutomerCare_Group_Master where IsActive=1 ORDER BY GroupName asc ");
        ddlgroup.DataSource = dt;
        ddlgroup.DataTextField = "GroupName";
        ddlgroup.DataValueField = "GroupID";
        ddlgroup.DataBind();
        ddlgroup.Items.Insert(0, new ListItem { Text = "-----Select-----", Value = "0" });

    }

    [WebMethod]
    public static string SaveInquiry(string IsActive, string Type, string CategoryID, string CategoryName, string SubCategoryID, string Subject, string Detail, string EditId,string GroupID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();

            if (EditId == string.Empty)
            {
                if (Type == "Query")
                {
                    sb = new StringBuilder();
                    sb.Append("INSERT INTO `Inquiry_Master`(isActive,`Type`,`Category_master`,`categoryId`,`Subject`,`Detail`,`dtEntry`,`EnteredById`,`EnteredByName`,SubCategoryID,GroupID)");
                    sb.Append("VALUES(@isActive,@Type,@Category_master,@categoryId,@Subject,@Detail,@dtEntry,@EnteredById,@EnteredByName,@SubCategoryID,@GroupID)");

              MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
              new MySqlParameter("@isActive", IsActive),
              new MySqlParameter("@Type", Type),
              new MySqlParameter("@Category_master", CategoryName), new MySqlParameter("@categoryId", CategoryID),
              new MySqlParameter("@Subject", Subject), new MySqlParameter("@Detail", Detail),
              new MySqlParameter("@dtEntry", DateTime.Now), new MySqlParameter("@EnteredById", UserInfo.ID), new MySqlParameter("@EnteredByName", UserInfo.LoginName),
              new MySqlParameter("@SubCategoryID", SubCategoryID), new MySqlParameter("@GroupID", GroupID));
                }
                else if (Type == "Response")
                {
                    sb = new StringBuilder();
                    sb.Append("INSERT INTO `Inquiry_Master`(isActive,`Type`,`Category_master`,`categoryId`,Subject,`Detail`,`dtEntry`,`EnteredById`,`EnteredByName`,SubCategoryID,GroupID)");
                    sb.Append("VALUES(@isActive,@Type,@Category_master,@categoryId,@Subject,@Detail,@dtEntry,@EnteredById,@EnteredByName,@SubCategoryID,@GroupID)");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
              new MySqlParameter("@isActive", IsActive),
              new MySqlParameter("@Type", Type),
              new MySqlParameter("@Category_master", CategoryName), new MySqlParameter("@categoryId", CategoryID),
               new MySqlParameter("@Subject", Subject), new MySqlParameter("@Detail", Detail),
              new MySqlParameter("@dtEntry", DateTime.Now), new MySqlParameter("@EnteredById", UserInfo.ID), new MySqlParameter("@EnteredByName", UserInfo.LoginName),
              new MySqlParameter("@SubCategoryID", SubCategoryID), new MySqlParameter("@GroupID", GroupID));            
                }
                tnx.Commit();
                return "1";
            }
            else
            {
                string str = string.Empty;
                if (Type == "Query")
                {
                    str = "update Inquiry_Master set isActive='" + IsActive + "',`Type`='" + Type + "',`Category_master`='" + CategoryName + "',`categoryId`='" + CategoryID + "',`Subject`='" + Subject + "',`Detail`='" + Detail + "',UpdatedByName='" + UserInfo.LoginName + "',UpdatedById='" + UserInfo.ID + "',UpdatedDate=Now(),SubCategoryID='" + SubCategoryID + "',GroupID='" + GroupID + "'";
                }
                if (Type == "Response")
                {
                    str = "update Inquiry_Master set isActive='" + IsActive + "', `Type`='" + Type + "',`Category_master`='" + CategoryName + "',`categoryId`='" + CategoryID + "',`Detail`='" + Detail + "',UpdatedByName='" + UserInfo.LoginName + "',UpdatedById='" + UserInfo.ID + "',UpdatedDate=Now(),SubCategoryID='" + SubCategoryID + "',GroupID='" + GroupID + "'";
                }
                sb.Append(str);
                sb.Append(" where Id='" + EditId + "'");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                tnx.Commit();
                return "2";
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
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
    public static string GetQueryList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.ID,im.TYPE,im.SUBJECT,im.Detail,DATE_FORMAT(im.dtEntry,'%d-%b-%Y')dtEntry,im.isActive, ");
        sb.Append(" cat.CategoryName,scat.SubCategoryName,im.categoryId,im.SubCategoryID,im.GroupID,cgm.GroupName FROM Inquiry_Master as im ");
        sb.Append(" inner join CutomerCare_Group_Master cgm on im.GroupID=cgm.GroupID ");
        sb.Append(" inner join cutomercare_category_master cat on cat.ID=im.categoryId ");
        sb.Append(" inner join cutomercare_subcategory_master scat on scat.ID=im.SubCategoryID ");        
        sb.Append(" ORDER BY im.ID DESC ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Util.getJson(dt);
    }

    [WebMethod]
    public static string EditeQuery(string Id)
    {
        DataTable dt = StockReports.GetDataTable("SELECT Id,TYPE,categoryId,SUBJECT,Detail,DATE_FORMAT(dtEntry,'%d-%b-%Y')dtEntry,isActive,SubCategoryId,GroupID FROM  Inquiry_Master where Id='" + Id + "'");
        return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string DeleteQuery(string Id)
    {
        string Des = string.Empty;
        try
        {
            Des = Util.GetString(MySqlHelper.ExecuteNonQuery(Util.GetMySqlCon(), CommandType.Text, "UPDATE Inquiry_Master SET isActive='0' WHERE `Id`=@Id",
                new MySqlParameter("@Id", Id)));
            if (Des == "1")
            {
                return "Data Successful deleted";
            }
            else
            {
                return "Some error please try again";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    
}
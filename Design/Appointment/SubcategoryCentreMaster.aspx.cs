using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;
using Newtonsoft.Json;


public partial class Design_Master_SubcategoryCentreMaster : System.Web.UI.Page
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets

    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindCenterDDL();
            BindDepartment();           
        }         
    }

    public void bindCenterDDL()
    {
       
        string str = "select distinct cm.CentreID,cm.Centre from centre_master cm where cm.isActive=1 order by cm.Centre  ";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        ddlcenter.DataSource = dt;
        ddlcenter.DataTextField = "Centre";
        ddlcenter.DataValueField = "centreID";
        ddlcenter.DataBind();
    }

    private void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DISTINCT NAME,SubCategoryID FROM f_subcategorymaster WHERE Active=1 ORDER BY NAME; "); 
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            ddlSubGroups.DataSource = dt;
            ddlSubGroups.DataTextField = "Name";
            ddlSubGroups.DataValueField = "SubCategoryID";
            ddlSubGroups.DataBind();
            ddlSubGroups.Items.Insert(0, new ListItem("", ""));
            lblMsg.Text = "";
        }
        else
        {
            ddlSubGroups.Items.Clear();
            lblMsg.Text = "No Sub-Groups Found";
        }

    } 

    [WebMethod]    
    public static string AddDepartment(string CentreID, string SubCategoryID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string checkSession = Util.GetString(UserInfo.Centre);
        }
        catch
        {
            return "-1";
        }
        string str = "";
        try
        {
            if (SubCategoryID != "")
            {
                
              int MaxOrder=Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT MAX(Priority) FROM f_subcategorymaster_centre WHERE CentreID=@CentreID ",
                    new MySqlParameter("@CentreID", CentreID)));
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "delete from f_subcategorymaster_centre where CentreID=@CentreID AND SubcategoryID=@SubcategoryID",
                  new MySqlParameter("@CentreID", CentreID),
                  new MySqlParameter("@SubcategoryID", SubCategoryID));

                str = "INSERT INTO f_subcategorymaster_centre(CentreID,SubcategoryID,UserID,UserName,dtEntry,IpAddress,Priority) VALUES(@CentreID,@SubcategoryID,@UserID,@UserName,NOW(),@IpAddress,@Priority);";
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str,
                new MySqlParameter("@CentreID", CentreID),
                new MySqlParameter("@SubcategoryID", SubCategoryID),
                 new MySqlParameter("@UserID", Util.GetString(HttpContext.Current.Session["ID"])),
                  new MySqlParameter("@UserName", Util.GetString(HttpContext.Current.Session["LoginName"])),                
                 new MySqlParameter("@IpAddress",  StockReports.getip()),
                 new MySqlParameter("@Priority", (MaxOrder + 1)));              
                              
                return "1";
            }
            else
            {
                return "2";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
       

    }


    [WebMethod] 
    public static string SearchDepartment(string CentreID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@" SELECT scm.Name SubCategoryName,scm.SubcategoryID,scmc.Priority FROM  f_subcategorymaster scm   
                      Inner JOIN f_subcategorymaster_centre scmc  ON scmc.SubcategoryID = scm.SubcategoryID  AND scmc.CentreID=@CentreID
                      WHERE scm.`Active`=1   ORDER BY scmc.Priority  ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@CentreID", CentreID)).Tables[0])
            {
                return makejsonoftable(dt, makejson.e_without_square_brackets);    
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }       
    }


    [WebMethod]    
    public static string SaveOrdering(string CentreID, string DeptOrder)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string checkSession = Util.GetString(UserInfo.Centre);
        }
        catch
        {
            return "-1";
        }
        try
        {
           string SubCategoryID = DeptOrder.TrimEnd('#');
            string str = "";
            int len = Util.GetInt(DeptOrder.Split('#').Length);
            string[] Data = new string[len];
            Data = DeptOrder.Split('#');
            for (int i = 0; i < len; i++)
            {
                string abc = Data[i].Split('|')[0].ToString();
                str = "Update f_subcategorymaster_centre Set UpdatedByID=@UpdatedByID,UpdatedBy=@UpdatedBy,Updatedate=NOW(),Priority=@Priority  where CentreID=@CentreID and SubCategoryID=@SubCategoryID ";

                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str,
                    new MySqlParameter("@UpdatedByID", UserInfo.ID),
                    new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                    new MySqlParameter("@Priority", (Util.GetInt(i) + 1)),
                    new MySqlParameter("@CentreID", CentreID),
                    new MySqlParameter("@SubCategoryID", Data[i].ToString()));              
            }
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }  
       

    }


    [WebMethod]    
    public static string RemoveDepartment(string CentreID, string SubCategoryIdID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string checkSession = Util.GetString(UserInfo.Centre);
        }
        catch
        {
            return "-1";
        }       
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "delete from f_subcategorymaster_centre where CentreID=@CentreID AND SubcategoryID=@SubcategoryID",
               new MySqlParameter("@CentreID", CentreID),
               new MySqlParameter("@SubcategoryID", SubCategoryIdID));            
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }  
        

    }

    public static string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));


            }
            sb.Append(sb2.ToString());
            sb.Append("}");


        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();


    }
}



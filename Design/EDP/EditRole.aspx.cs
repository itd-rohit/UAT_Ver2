using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_EDP_EditRole : System.Web.UI.Page
{
    private string ID;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindGrid()
    {
        try
        {

            using (DataTable dt = StockReports.GetDataTable("select ID,RoleName,Image,Background from f_rolemaster where active=1 order by RoleName"))
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetById(string id)
    {
        try
        {

            using (DataTable dt = StockReports.GetDataTable("select ID,RoleName,Image,Background from f_rolemaster where Id=" + id + " order by RoleName"))
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Save(string id, string role, string backcolor, string imagepath, string FBytes, string ContentType, string active, string remove)
    {
        string imgpath = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (ContentType != "")
            {
                byte[] bytes = Convert.FromBase64String(FBytes);
                imgpath = "/App_Images/RoleDesign/" + imagepath;
                string filePath = AppDomain.CurrentDomain.BaseDirectory + "App_Images\\RoleDesign\\" + imagepath;
                File.WriteAllBytes(filePath, bytes);
            }
            if (imgpath == "") imgpath = "/App_Images/RoleDesign/" + "icon1.png";
            if (id != "")
            {
                if (ContentType == "" && remove == "0")
                    StockReports.ExecuteDML("update f_rolemaster set RoleName='" + role + "',background='" + backcolor + "',Active=" + active + " where id='" + id + "' ");
                else if (ContentType == "" && remove == "1")
                    StockReports.ExecuteDML("update f_rolemaster set RoleName='" + role + "',background='" + backcolor + "',image='" + imgpath + "',Active=" + active + " where id='" + id + "' ");
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "insert into f_rolemaster(RoleName,Active,image,background) values('" + role + "',1,'" + imgpath + "','" + backcolor + "')");
            }
            return "Success";
        }
        catch (Exception e)
        {
            return e.ToString();
        }
        finally
        {
            if (con.State == ConnectionState.Open) { con.Close(); con.Dispose(); }
        }
    }
}
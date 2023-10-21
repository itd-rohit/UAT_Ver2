using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Web.Services;

public partial class Design_EDP_MakeMenu : System.Web.UI.Page
{
    private string ID;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string sr = StockReports.ExecuteScalar("select Max(Priority)+1 from f_menumaster");
            lblPrOrder.Text = "Max Priority : " + sr;
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindGrid()
    {
        try
        {
            string str = "select ID,MenuName,Image,Priority from f_menumaster where active=1 order by MenuName";
            DataTable dt = StockReports.GetDataTable(str.ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch(Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
            return null ;
        }
    }

    [WebMethod(EnableSession = true)]
    public static string GetById(string id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select ID,MenuName,Image,Priority from f_menumaster where Id=@ID order by MenuName", new MySqlParameter("@ID", id)).Tables[0];
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception e)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(e);
            return null;
        }
        finally
        {
             con.Close(); con.Dispose(); 
        }
    }

    [WebMethod(EnableSession = true)]
    public static string Save(string id, string role, string backcolor, string imagepath, string FBytes, string ContentType, string active, string RImage)
    {
        string imgpath = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (backcolor == "") backcolor = "0";
            if (FBytes !="" && FBytes !=null)
            FBytes =FBytes.Contains("data:image/jpg;base64,") ? FBytes: "data:image/jpg;base64," + FBytes;
            if (id != "")
            {
                if (ContentType == "" && RImage == "1")
                    MySqlHelper.ExecuteScalar(con,CommandType.Text,"update f_menumaster set MenuName=@role,Priority=@backcolor,image='',Active=@active where id=@id "
                        , new MySqlParameter("@role", role), new MySqlParameter("@backcolor", backcolor)
                        ,new MySqlParameter("@active",active) ,new MySqlParameter("@id",id));
                else
                    MySqlHelper.ExecuteScalar(con, CommandType.Text, "update f_menumaster set MenuName=@role,Priority=@backcolor,image=@Image,Active=@active where id=@id"
                        , new MySqlParameter("@role", role), new MySqlParameter("@backcolor", backcolor)
                       ,new MySqlParameter("@Image",FBytes) ,new MySqlParameter("@active",active) ,new MySqlParameter("@id",id));
            }
            else
            {
                MySqlHelper.ExecuteScalar(con, CommandType.Text, "insert into f_menumaster(MenuName,Active,image,Priority) values(@role,1,@Image,@backcolor)"
                      , new MySqlParameter("@role", role)
                       , new MySqlParameter("@backcolor", backcolor), new MySqlParameter("@Image", FBytes));
            }
            DataTable dtRole = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DISTINCT RM.id,RM.RoleName FROM f_filemaster fm INNER JOIN f_file_role fr ON fm.ID = fr.UrlID INNER JOIN f_rolemaster rm ON fr.RoleID = rm.ID AND rm.Active=1 INNER JOIN f_menumaster fmm ON fmm.id=fm.MenuID WHERE fm.Active = 1 AND fr.Active = 1 AND MenuName=@role ORDER BY fm.Priority "
                , new MySqlParameter("@role", role)).Tables[0];

            foreach (DataRow dr in dtRole.Rows)
            {
                StockReports.GenerateMenuData(dr["RoleName"].ToString());
            }
            return JsonConvert.SerializeObject(new { status = true, response = "Success" });
        }
        catch (Exception e)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(e);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close(); con.Dispose(); 
        }
    }
}
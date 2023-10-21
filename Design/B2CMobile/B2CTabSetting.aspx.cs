using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_B2CTabSetting : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,Name,Title,Ordering,if (IsActive='1','Yes','No') Active FROM app_b2c_tab order by ordering");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveData(string TabList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string[] list1 = TabList.Split(',');
            int ordering = list1.Length + 1;
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update app_b2c_tab set IsActive=0 , Ordering=@Ordering", new MySqlParameter("@Ordering", Util.GetInt(ordering)));
            for (int i = 0; i < list1.Length; i++)
            {
                int j = i + 1;
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update app_b2c_tab set Title=@Title ,IsActive=1 ,Ordering=@Ordering where ID=@ID", new MySqlParameter("@Title", list1[i].Split('_')[1]), new MySqlParameter("@Ordering", Util.GetInt(j)),
                                      new MySqlParameter("@ID", list1[i].Split('_')[0]));
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
            con.Close();
            con.Dispose();
        }
    }
}
    
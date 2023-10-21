using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using MySql.Data.MySqlClient;


public partial class Design_PROApp_Help : System.Web.UI.Page
{
  
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateHelpContent(string HeaderText, string ContentText, string IsActive, string ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string sb = "UPDATE app_mobile_help SET HeaderText=@HeaderText,Content=@ContentText ,IsActive=@IsActive, UpdateID=@UpdateID, UpdateName=@UpdateName, UpdateDate=NOW() WHERE ID=@ID";
            int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@HeaderText", HeaderText),
                                 new MySqlParameter("@ContentText", ContentText),
                                  new MySqlParameter("@IsActive", IsActive),
                                     new MySqlParameter("@UpdateID", UserInfo.ID),
                               new MySqlParameter("@UpdateName", UserInfo.LoginName),
                                new MySqlParameter("@ID", ID)
                               );
            tnx.Commit();
            return a.ToString();
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

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchHelpdata()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ID,HeaderText,Content,IF(Isactive=1,'Yes','No')IsActive,DATE_FORMAT(EntryDateTime,'%d-%b-%y %I:%i %p') Entrydate from app_mobile_help ");
            sb.Append("  ORDER BY PrintOrder ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
          
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        
    }

    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveHelpContent(string HeaderText, string ContentText, string IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

           string sb="Insert into app_mobile_help(HeaderText,Content,IsActive,UserID)" + " values (@HeaderText,@Content,@IsActive,@UserID)";
           int a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                                 new MySqlParameter("@HeaderText", HeaderText),
                                  new MySqlParameter("@ContentText", ContentText),
                                   new MySqlParameter("@IsActive", IsActive),
                                      new MySqlParameter("@UpdateID", UserInfo.ID)                              
                                );
            Tranx.Commit();
            return a.ToString();
        }        
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "Error";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveHelpOrdering(string InvOrder)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            // ObsData= Order|ObservationId|Header|IsCritical#
            InvOrder = InvOrder.TrimEnd('|');

            string str = "";
            int len = Util.GetInt(InvOrder.Split('|').Length);
            string[] Data = new string[len];
            Data = InvOrder.Split('|');
            for (int i = 0; i < len; i++)
            {
                str = " UPDATE app_mobile_help " +
                      " SET  PrintOrder=@PrintOrder WHERE ID=@ID ";
                int a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str.ToString(),
                                new MySqlParameter("@PrintOrder", (Util.GetInt(i) + 1)),                                
                                new MySqlParameter("@ID", Data[i].ToString())
                               );
            }


            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            con.Close();
            con.Dispose();
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
   


}
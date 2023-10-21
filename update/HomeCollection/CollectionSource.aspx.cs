using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_CollectionSource : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
          
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveRecord(string Source, string IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        
      
        try
        {
            int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  " + Util.getApp("HomeCollectionDB") + ".hc_CollectionSourceMaster WHERE  source=@Source",
                 new MySqlParameter("@Source", Util.GetString(Source.Trim()))));
            if (valDuplicate > 0)
            {
                Tnx.Rollback();
                return "2";
            }
            StringBuilder sb = new StringBuilder();
            sb = new StringBuilder();
            sb.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_CollectionSourceMaster(Source,IsActive,CreatedDate,CreatedBy,CreatedByID)");
            sb.Append("VALUES(@Source,@IsActive,@dtEntry,@CreatedBy,@CreatedByID)");
            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
            cmd.Parameters.AddWithValue("@Source", Source);
            cmd.Parameters.AddWithValue("@IsActive", IsActive);
            cmd.Parameters.AddWithValue("@dtEntry", System.DateTime.Now);
            cmd.Parameters.AddWithValue("@CreatedBy", UserInfo.UserName);
            cmd.Parameters.AddWithValue("@CreatedByID", UserInfo.ID);
            cmd.ExecuteNonQuery();
            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string UpdateRecord(string SourceId, string Source, string IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  " + Util.getApp("HomeCollectionDB") + ".hc_CollectionSourceMaster WHERE ID=@ID  AND source=@Source and ID<>@ID ",
                new MySqlParameter("@Source", Util.GetString(Source.Trim())),
                new MySqlParameter("ID", SourceId)));
            if (valDuplicate > 0)
            {
                Tnx.Rollback();
                return "2";
            }
            StringBuilder sb = new StringBuilder();
            sb = new StringBuilder();
            sb.Append(" Update  " + Util.getApp("HomeCollectionDB") + ".hc_CollectionSourceMaster set source=@source,IsActive=@IsActive,Updatedate=@Updatedate,UpdateBy=@UpdateBy,UpdateByID=@UpdateByID where ID=@ID ");
            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
            cmd.Parameters.AddWithValue("@Source", Source);
            cmd.Parameters.AddWithValue("@IsActive", IsActive);
            cmd.Parameters.AddWithValue("@Updatedate", System.DateTime.Now);
            cmd.Parameters.AddWithValue("@UpdateBy", UserInfo.UserName);
            cmd.Parameters.AddWithValue("@UpdateByID", UserInfo.ID);
            cmd.Parameters.AddWithValue("@ID", SourceId);
            cmd.ExecuteNonQuery();
            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string GetData(string searchvalue, string NoofRecord)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
       
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("   SELECT ID,Source,IsActive ");
            sb.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".hc_CollectionSourceMaster hm  ");
          
            
            if (searchvalue != "")
            {
                sb.Append(" where  hm.`Source` like @searchvalue ");
            }
          //  sb.Append("  order by hm.`source` limit @NoofRecord  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@searchvalue", string.Format("%{0}%", searchvalue)),
               new MySqlParameter("@NoofRecord", NoofRecord)).Tables[0])
            {
                return Util.getJson(dt);
            }            
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

}
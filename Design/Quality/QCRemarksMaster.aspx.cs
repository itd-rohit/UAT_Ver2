using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_QCRemarksMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }



    [WebMethod(EnableSession = true)]
    public static string binddata()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT  id,RemarksTitle,Remarks,RemarksType,");
        sb.Append(" IF(IsActive=1,'Active','Deactive')IsActive,DATE_FORMAT(EntryDateTime,'%d-%b-%y')EntryDateTime,EntryByName,");
        sb.Append(" ifnull(DATE_FORMAT(UpdateDateTime,'%d-%b-%y'),'') UpdateDateTime,ifnull(UpdateByName,'')UpdateByName FROM qc_remarkmaster order by ID");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public static string saveremark(string remarktype, string remark, string IsActive, string remarktext)
    {
       

        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        try
        {



            MySqlHelper.ExecuteNonQuery(conn, CommandType.Text, "insert into qc_remarkmaster(RemarksTitle,RemarksType,IsActive,EntryDateTime,EntryByID,EntryByName,Remarks) values (@Remarks,@RemarksType,@IsActive,@EntryDateTime,@EntryByID,@EntryByName,@RemarksText)",
                new MySqlParameter("@Remarks", remark),
                 new MySqlParameter("@RemarksText", remarktext),
                new MySqlParameter("@RemarksType", remarktype),
                new MySqlParameter("@IsActive", IsActive),
                new MySqlParameter("@EntryDateTime", Util.GetDateTime(DateTime.Now)),
                new MySqlParameter("@EntryByID", UserInfo.ID),
                new MySqlParameter("@EntryByName", UserInfo.LoginName));

           

            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;

        }
        finally
        {

            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
                conn.Dispose();
            }
        }
    }
    
    [WebMethod(EnableSession = true)]
    public static string updateremark(string remarktype, string remark, string IsActive, string id, string remarktext)
    {
       

        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        try
        {



            MySqlHelper.ExecuteNonQuery(conn, CommandType.Text, "update  qc_remarkmaster set RemarksTitle=@RemarksTitle,Remarks=@Remarks,RemarksType=@RemarksType,IsActive=@IsActive,UpdateDateTime=@UpdateDateTime,UpdateByID=@UpdateByID,UpdateByName=@UpdateByName where id=@id",
                new MySqlParameter("@RemarksTitle", remark),
                 new MySqlParameter("@Remarks", remarktext),
                new MySqlParameter("@RemarksType", remarktype),
                new MySqlParameter("@IsActive", IsActive),
                new MySqlParameter("@UpdateDateTime", Util.GetDateTime(DateTime.Now)),
                new MySqlParameter("@UpdateByID", UserInfo.ID),
                new MySqlParameter("@UpdateByName", UserInfo.LoginName),
                new MySqlParameter("@id", id));

           

            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;

        }
        finally
        {

            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
                conn.Dispose();
            }
        }
    }
    
}
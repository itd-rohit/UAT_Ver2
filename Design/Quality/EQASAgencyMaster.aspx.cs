using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_Quality_EQASAgencyMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FromdateCal.StartDate = DateTime.Now;
        }
    }

    public void file1_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
    {
        string fileext = System.IO.Path.GetExtension(file1.FileName);
        string filename = Guid.NewGuid().ToString() + fileext;
        file1.SaveAs(Server.MapPath("~/Design/Quality/EQASDocument/") + filename);
        Session["filename"] = filename;
    }

    [WebMethod(EnableSession = true)]
    public static string savedata(string labname, string labaddress, string contactno, string contactpername, string renewdate, string IsActive, string emailaddress)
    {
        string filename = Util.GetString(HttpContext.Current.Session["filename"]);
        if (filename == "")
        {
            //return "Please Upload File";
        }

        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        try
        {

            if (Util.GetInt(MySqlHelper.ExecuteScalar(conn, CommandType.Text, "select count(1) from qc_eqasprovidermaster where EqasProviderName='" + labname + "' ")) > 0)
            {
                return "ILC Lab Name Already Exist";
            }

            MySqlHelper.ExecuteNonQuery(conn, CommandType.Text, "insert into qc_eqasprovidermaster(EqasProviderName,EqasProviderAddress,ContactNo,ContactPersonname,EmailAddress,RenewDate,Document,EntryDate,EntryByID,EntryByName,IsActive) values (@EqasProviderName,@EqasProviderAddress,@ContactNo,@ContactPersonname,@EmailAddress,@RenewDate,@Document,@EntryDate,@EntryByID,@EntryByName,@IsActive)",
                new MySqlParameter("@EqasProviderName", labname),
                new MySqlParameter("@EqasProviderAddress", labaddress),
                new MySqlParameter("@ContactNo", contactno),
                new MySqlParameter("@ContactPersonname", contactpername), new MySqlParameter("@EmailAddress", emailaddress),
                new MySqlParameter("@RenewDate", Util.GetDateTime(renewdate).ToString("yyyy-MM-dd")),
                new MySqlParameter("@Document", filename),
                new MySqlParameter("@EntryDate", Util.GetDateTime(DateTime.Now)),
                new MySqlParameter("@EntryByID", UserInfo.ID),
                new MySqlParameter("@EntryByName", UserInfo.LoginName),
                new MySqlParameter("@IsActive", IsActive));

            HttpContext.Current.Session["filename"] = "";

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
    public static string updatedata(string labid, string labname, string labaddress, string contactno, string contactpername, string renewdate, string IsActive, string emailaddress)
    {
        string filename = Util.GetString(HttpContext.Current.Session["filename"]);
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        try
        {
            if (Util.GetInt(MySqlHelper.ExecuteScalar(conn, CommandType.Text, "select count(1) from qc_eqasprovidermaster where EqasProviderName='" + labname + "' and EqasProviderID<>'" + labid + "' ")) > 0)
            {
                return "ILC Lab Name Already Exist";
            }

            MySqlHelper.ExecuteNonQuery(conn, CommandType.Text, "update qc_eqasprovidermaster set EqasProviderName=@EqasProviderName,EqasProviderAddress=@EqasProviderAddress,ContactNo=@ContactNo,ContactPersonname=@ContactPersonname,RenewDate=@RenewDate,IsActive=@IsActive,UpdateDate=@UpdateDate,UpdateByID=@UpdateByID,UpdateByName=@UpdateByName,EmailAddress=@EmailAddress where EqasProviderID=@EqasProviderID",
                new MySqlParameter("@EqasProviderName", labname),
                new MySqlParameter("@EqasProviderAddress", labaddress),
                new MySqlParameter("@ContactNo", contactno),
                new MySqlParameter("@ContactPersonname", contactpername), new MySqlParameter("@EmailAddress", emailaddress),
                new MySqlParameter("@RenewDate", Util.GetDateTime(renewdate).ToString("yyyy-MM-dd")),
                new MySqlParameter("@UpdateDate", Util.GetDateTime(DateTime.Now)),
                new MySqlParameter("@UpdateByID", UserInfo.ID),
                new MySqlParameter("@UpdateByName", UserInfo.LoginName),
                new MySqlParameter("@IsActive", IsActive),
                new MySqlParameter("@EqasProviderID", labid));

            if (filename != "")
            {
                MySqlHelper.ExecuteNonQuery(conn, CommandType.Text, "update qc_eqasprovidermaster set Document=@Document where EqasProviderID=@EqasProviderID",
                   new MySqlParameter("@Document", filename),
                   new MySqlParameter("@EqasProviderID", labid));
            }
            HttpContext.Current.Session["filename"] = "";

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
    public static string binddata()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  EqasProviderID,EqasProviderName,EqasProviderAddress,ContactNo,ContactPersonname,if(RenewDate='0001-01-01','',DATE_FORMAT(RenewDate, '%d-%b-%y'))RenewDate,Document,EmailAddress,");
        sb.Append(" IF(IsActive=1,'Active','Deactive')IsActive,DATE_FORMAT(EntryDate,'%d-%b-%y')EntryDate,EntryByName,");
        sb.Append(" ifnull(DATE_FORMAT(UpdateDate,'%d-%b-%y'),'') UpdateDate,ifnull(UpdateByName,'')UpdateByName FROM qc_eqasprovidermaster order by EqasProviderID");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
}
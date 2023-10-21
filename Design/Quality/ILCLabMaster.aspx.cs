using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_Quality_ILCLabMaster : System.Web.UI.Page
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
        file1.SaveAs(Server.MapPath("~/Design/Quality/MOUDocument/") + filename);
        Session["filename"] = filename;
    }

    [WebMethod(EnableSession = true)]
    public static string savedata(string labname, string labaddress, string contactno, string contactpername, string renewdate, string IsActive)
    {
        string filename = Util.GetString(HttpContext.Current.Session["filename"]);
        if (filename == "")
        {
            return "Please Upload File";
        }

        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        try
        {

            if (Util.GetInt(MySqlHelper.ExecuteScalar(conn, CommandType.Text, "select count(1) from qc_ilclabmaster where ILCLabName='" + labname + "' ")) > 0)
           {
               return "ILC Lab Name Already Exist";
           }

            MySqlHelper.ExecuteNonQuery(conn, CommandType.Text, "insert into qc_ilclabmaster(ILCLabName,ILCLabAddress,ContactNo,ContactPersonname,MOURenewDate,MOUDocument,EntryDate,EntryByID,EntryByName,IsActive) values (@ILCLabName,@ILCLabAddress,@ContactNo,@ContactPersonname,@MOURenewDate,@MOUDocument,@EntryDate,@EntryByID,@EntryByName,@IsActive)",
                new MySqlParameter("@ILCLabName", labname),
                new MySqlParameter("@ILCLabAddress", labaddress),
                new MySqlParameter("@ContactNo", contactno),
                new MySqlParameter("@ContactPersonname", contactpername),
                new MySqlParameter("@MOURenewDate", Util.GetDateTime(renewdate).ToString("yyyy-MM-dd")),
                new MySqlParameter("@MOUDocument", filename),
                new MySqlParameter("@EntryDate", Util.GetDateTime(DateTime.Now)),
                new MySqlParameter("@EntryByID", UserInfo.ID),
                new MySqlParameter("@EntryByName",UserInfo.LoginName),
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
    public static string updatedata(string labid,string labname, string labaddress, string contactno, string contactpername, string renewdate, string IsActive)
    {
        string filename = Util.GetString(HttpContext.Current.Session["filename"]);
        

        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        try
        {

            if (Util.GetInt(MySqlHelper.ExecuteScalar(conn, CommandType.Text, "select count(1) from qc_ilclabmaster where ILCLabName='" + labname + "' and LabID<>'" + labid + "' ")) > 0)
            {
                return "ILC Lab Name Already Exist";
            }

            MySqlHelper.ExecuteNonQuery(conn, CommandType.Text, "update qc_ilclabmaster set ILCLabName=@ILCLabName,ILCLabAddress=@ILCLabAddress,ContactNo=@ContactNo,ContactPersonname=@ContactPersonname,MOURenewDate=@MOURenewDate,IsActive=@IsActive,UpdateDate=@UpdateDate,UpdateByID=@UpdateByID,UpdateByName=@UpdateByName where labid=@labid",
                new MySqlParameter("@ILCLabName", labname),
                new MySqlParameter("@ILCLabAddress", labaddress),
                new MySqlParameter("@ContactNo", contactno),
                new MySqlParameter("@ContactPersonname", contactpername),
                new MySqlParameter("@MOURenewDate", Util.GetDateTime(renewdate).ToString("yyyy-MM-dd")),
                new MySqlParameter("@UpdateDate", Util.GetDateTime(DateTime.Now)),
                new MySqlParameter("@UpdateByID", UserInfo.ID),
                new MySqlParameter("@UpdateByName", UserInfo.LoginName),
                new MySqlParameter("@IsActive", IsActive),
                new MySqlParameter("@labid", labid));

            if (filename != "")
            {
                MySqlHelper.ExecuteNonQuery(conn, CommandType.Text, "update qc_ilclabmaster set MOUDocument=@MOUDocument where labid=@labid",
                   new MySqlParameter("@MOUDocument", filename),
                   new MySqlParameter("@labid", labid));
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

        sb.Append(" SELECT  LabID,ILCLabName,ILCLabAddress,ContactNo,ContactPersonname,DATE_FORMAT(MOURenewDate, '%d-%b-%y')MOURenewDate,MOUDocument,");
        sb.Append(" IF(IsActive=1,'Active','Deactive')IsActive,DATE_FORMAT(EntryDate,'%d-%b-%y')EntryDate,EntryByName,");
        sb.Append(" ifnull(DATE_FORMAT(UpdateDate,'%d-%b-%y'),'') UpdateDate,ifnull(UpdateByName,'')UpdateByName FROM qc_ilclabmaster order by LabID");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    
}
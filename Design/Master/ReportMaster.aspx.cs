using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

public partial class Design_Master_ReportMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession = true)]
    public static string SaveReportDetails(ReportDetail DocDetails)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (DocDetails.ReportID == "")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" Insert into report_master (ReportType, ReportName,EntryById,EntryByName) ");
                sb.Append(" VALUES (@ReportType, @ReportName, @EntryById, @EntryByName) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@ReportType", DocDetails.ReportType),
                   new MySqlParameter("@ReportName", DocDetails.ReportName),
                   new MySqlParameter("@EntryById", UserInfo.ID),
                   new MySqlParameter("@EntryByName", UserInfo.LoginName));


            }
            else
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" Update report_master set  ReportType=@ReportType, ReportName=@ReportName,UpdateById= @UpdateById,  UpdateByName=@UpdateByName,  UpdateDate=NOW() ");
                sb.Append(" where ReportID=@ReportID ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@ReportType", DocDetails.ReportType),
                   new MySqlParameter("@ReportName", DocDetails.ReportName),                 
                   new MySqlParameter("@UpdateById", UserInfo.ID),
                   new MySqlParameter("@UpdateByName", UserInfo.LoginName),
                   new MySqlParameter("@ReportID", DocDetails.ReportID));
            }
          //  int MaxID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT LAST_INSERT_ID() as AutoKey"));
            tnx.Commit();


            return JsonConvert.SerializeObject(new { status = true, response = "Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string GetReportDetails()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@" SELECT ReportID,ReportType, ReportName, Date_Format(EntryDate,'%d-%M-%y') EntryDate,EntryById,EntryByName 
                         FROM report_master where IsActive=1   order by ReportID");

            DataTable dtSearch = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()
               ).Tables[0];

            if (dtSearch.Rows.Count > 0)
            {
                return JsonConvert.SerializeObject(new { status = true, data = dtSearch });

            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, data = "No Record Found" });
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });
        }

        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public class ReportDetail
    {
        public string ReportID { get; set; }
        public string ReportType { get; set; }
        public string ReportName { get; set; }
    }
}
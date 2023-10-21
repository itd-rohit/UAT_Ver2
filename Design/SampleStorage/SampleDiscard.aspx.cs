using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_SampleStorage_SampleDiscard : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtspshedule.Text = DateTime.Now.ToString("dd-MMM-yyyy");
           //calFromDate.EndDate = System.DateTime.Now;
        }
    }
  

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string binddevice(string centreid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT  CONCAT(id,'#',numberofrack) id,devicename FROM `ss_storagedevicemaster` WHERE centreid=@centreid ",
               new MySqlParameter("@centreid", centreid)
                ).Tables[0])
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getdevicedata(string deviceid, string rackid, string expirydate)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append("SELECT (case when sss.type='P' then 'Processed' else 'Scheduled' end) as type, COUNT(DISTINCT barcodeno) totalcount,traycode,(sst.`Capacity1`*sst.`Capacity2`) totalcapacity,rackid,sst.`Capacity1`,sst.`Capacity2`,date_format(sss.expirydate,'%d-%b-%Y') expirydate");
            sb.Append(" FROM ss_samplestorage sss");
            sb.Append(" INNER JOIN `ss_storagetraymaster` sst ON sst.id=sss.`TrayID` ");
            sb.Append(" WHERE deviceid=@deviceid AND STATUS=1  and rackid=@rackid and sss.expirydate<=@expirydate group by traycode");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@deviceid", deviceid),
               new MySqlParameter("@rackid", rackid),
               new MySqlParameter("@expirydate", Util.GetDateTime(expirydate).ToString("yyyy-MM-dd"))
                ).Tables[0])
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveData(List<string> datatosave)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (string ss in datatosave)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " update  ss_samplestorage set status=2,DiscardDate=now(),DiscardBy=@ID where traycode=@ss ",
                     new MySqlParameter("@ID", UserInfo.ID),
                     new MySqlParameter("@ss", ss)
                    );
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}
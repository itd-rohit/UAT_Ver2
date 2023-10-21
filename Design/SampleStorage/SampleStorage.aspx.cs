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

public partial class Design_SampleStorage_SampleStorage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (!IsPostBack)
            {
                txtspshedule.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                sb.Append("SELECT CONCAT(id,'#',numberofrack) id,devicename FROM `ss_storagedevicemaster` WHERE centreid=@centreid ");
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@centreid", UserInfo.Centre)).Tables[0])
                {
                    ddldevice.DataValueField = "id";
                    ddldevice.DataTextField = "devicename";
                    ddldevice.DataSource = dt;
                    ddldevice.DataBind();
                }
                ddldevice.Items.Insert(0, new ListItem("Select Device", "0"));

            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindsampletype()
    {
        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dt = new DataTable();
           
            using (dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT id,samplename FROM sampletype_master WHERE isactive=1 ORDER BY samplename ").Tables[0])
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
    public static string bindtray(string sampletype)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append("SELECT id,concat(trayname,'^',concat(capacity1,'X',capacity2),'^',concat(expiryunit,' ',expirytype)  ) trayname,sampletypeid FROM `ss_storagetraymaster` WHERE isactive=1 and sampletypeid like @sampletype ORDER BY trayname");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@sampletype", string.Format("%{0}%", sampletype))).Tables[0])
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
    public static string bindsampledata(string barcodeno, string sampletype)
    {
         StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append("SELECT ifnull(barcodeno,'')barcodeno, GROUP_CONCAT( itemname SEPARATOR '^'  ) Itemname,plo.`LedgerTransactionNo`,lt.pname,lt.`Age`,lt.`Gender`");
            sb.Append(" FROM `patient_labinvestigation_opd`  plo");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" WHERE barcodeno=@barcodeno AND sampletypeid=@sampletype and (select count(*) from ss_samplestorage  where BarcodeNo=@barcodeno and Status=1)=0 ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@barcodeno", barcodeno),
               new MySqlParameter("@sampletype", sampletype)
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
    public static string bindoldtray(string type, string date)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append("SELECT id,TrayCode FROM ( ");
            sb.Append(" SELECT sst.id, COUNT(DISTINCT barcodeno) saved, (sst.capacity1*sst.capacity2) capacity,  ");
            sb.Append(" CONCAT(traycode,'^',CONCAT(capacity1,'X',capacity2),'^',CONCAT(expiryunit,' ',expirytype)  ) TrayCode FROM ss_samplestorage ssm ");
            sb.Append(" INNER JOIN ss_storagetraymaster sst ON ssm.trayid=sst.id ");
            sb.Append(" WHERE TYPE=LEFT(@type,1)  ");

            if (type == "Processed Samples")
            {
                sb.Append(" and  ProcessedDate=@date ");
            }
            else
            {
                sb.Append(" and  ScheduledDate=@date ");
            }
            sb.Append(" GROUP BY traycode)t WHERE saved<capacity");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@type", type),
               new MySqlParameter("@date", Util.GetDateTime(date).ToString("yyyy-MM-dd"))
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
    public static string SaveData(List<string[]> datatosave)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string traycode = "";
            DateTime expirydate;
            DateTime processdate;
            string pp="";
            if (datatosave[0][2] == "")
            {
                Random rnd = new Random();
                int value = rnd.Next(100000, 999999);

                traycode = value.ToString();
            }
            else
            {
                traycode = datatosave[0][2];
                pp = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " select date_format(ExpiryDate,'%d-%b-%Y') from ss_samplestorage where traycode=@traycode " ,
                    new MySqlParameter("@traycode", traycode)
                    ));
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " delete from ss_samplestorage where traycode=@traycode ",
                    new MySqlParameter("@traycode", traycode)
                    );
            }

            if (datatosave[0][2] == "")
            {
                if (datatosave[0][1] == "P")
                {
                    processdate = Util.GetDateTime(datatosave[0][9]);
                    if (datatosave[0][5].Split(' ')[1] == "Days")
                    {
                        expirydate = processdate.AddDays(Util.GetInt(datatosave[0][5].Split(' ')[0]));
                    }
                    else if (datatosave[0][5].Split(' ')[1] == "Months")
                    {
                        expirydate = processdate.AddMonths(Util.GetInt(datatosave[0][5].Split(' ')[0]));
                    }
                    else
                    {
                        expirydate = processdate.AddYears(Util.GetInt(datatosave[0][5].Split(' ')[0]));
                    }
                }
                else
                {
                    processdate = Util.GetDateTime(datatosave[0][9]);
                    expirydate = Util.GetDateTime(datatosave[0][9]);
                }
            }
            else
            {
                processdate = Util.GetDateTime(datatosave[0][9]);
                expirydate = Util.GetDateTime(pp);
            }

            foreach (string[] ss in datatosave)
            {

                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO ss_samplestorage");
                sb.Append(" (DeviceID,RackID,TrayID,TrayCode,SlotNumber,TYPE,BarcodeNo,STATUS,SampleTypeID,CentreID,ProcessedDate,ExpiryDate,UserID,ScheduledDate)");
                sb.Append(" values(@ss0,@ss6,@ss8,@traycode,@ss10,@ss1,@ss7,@ss4,@ss3,@Centre");
                sb.Append(" ,@processdate,@expirydate,@ID,@expirydate)");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@ss0", ss[0]),
                    new MySqlParameter("@ss6", ss[6]),
                    new MySqlParameter("@ss8", ss[8]),
                    new MySqlParameter("@traycode", traycode),
                    new MySqlParameter("@ss10", ss[10]),
                    new MySqlParameter("@ss7", ss[1]),
                    new MySqlParameter("@ss4", ss[4]),
                    new MySqlParameter("@ss3", ss[3]),
                    new MySqlParameter("@Centre", UserInfo.Centre),
                    new MySqlParameter("@processdate", processdate.ToString("yyyy-MM-dd")),
                    new MySqlParameter("@expirydate", expirydate.ToString("yyyy-MM-dd")),
                    new MySqlParameter("@ID", UserInfo.ID)
                    );


                sb = new StringBuilder();
                sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Sample Stored (',ItemName,')'),@ID,@LoginName,@getip,@Centre, ");
                sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE  BarCodeNo =@ss7 ");


                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@ID", UserInfo.ID),
                    new MySqlParameter("@LoginName", UserInfo.LoginName),
                    new MySqlParameter("@getip", StockReports.getip()),
                    new MySqlParameter("@Centre", UserInfo.Centre),
                    new MySqlParameter("@RoleID", UserInfo.RoleID),
                    new MySqlParameter("@ss7", ss[7])
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


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetoldTrayData(string trayid)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append("SELECT DISTINCT ss.barcodeno,GROUP_CONCAT( itemname SEPARATOR '^'  ) Itemname,plo.`LedgerTransactionNo`,lt.pname,lt.`Age`,lt.`Gender`,concat(sdm.id,'#',sdm.numberofrack)deviceid");
            sb.Append(" FROM `ss_samplestorage` ss inner join ss_storagedevicemaster sdm on sdm.id=ss.deviceid");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON ss.`BarcodeNo`=plo.`BarcodeNo` AND ss.`Status`=1");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" WHERE traycode=@trayid GROUP BY plo.`BarcodeNo`");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@trayid", trayid)).Tables[0])
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }    
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

     [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getdevicedata(string deviceid, string rackid)
    {
         StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append("SELECT (case when sss.type='P' then 'Processed' else 'Scheduled' end) as type, COUNT(DISTINCT barcodeno) totalcount,traycode,(sst.`Capacity1`*sst.`Capacity2`) totalcapacity,rackid");
            sb.Append(" FROM ss_samplestorage sss");
            sb.Append(" INNER JOIN `ss_storagetraymaster` sst ON sst.id=sss.`TrayID`");
            sb.Append(" WHERE deviceid=@deviceid AND STATUS=1  and rackid=@rackid  group by traycode");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@deviceid", deviceid),
               new MySqlParameter("@rackid", rackid)
               ).Tables[0])
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            //DataTable dt = StockReports.GetDataTable(@"");
            
        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(ex);

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
     }

}
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
using System.IO;
using System.Data.SqlClient;
using System.Drawing;
public partial class Design_PROApp_B2CAppSmsConfigure : System.Web.UI.Page
{
    
   
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
          

        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetSMSData(string Id, string Type)
    {
        DataTable dt = new DataTable();
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string query = "";
            if (Id != "0")
            {
                query = "Select  ID, SMSTemplate,SMS_Type,If(IsActive=1,'Yes','No')IsActive,UserID,DATE_FORMAT(Updatedate, '%d-%m-%Y')Updatedate, Mobile1,Mobile2,Mobile3 from app_b2c_sms_template Where Id=@Id;";
                dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, query.ToString(), new MySqlParameter("@Id", Id)).Tables[0];
            }
            else
            {
                if (Type == "")
                {
                    dt = StockReports.GetDataTable(" Select ID,Replace(Replace(SMSTemplate,'<',''),'>','') SMSTemplate,SMS_Type,If(IsActive=1,'Yes','No')IsActive,UserID,DATE_FORMAT(Updatedate, '%d-%m-%Y')Updatedate,  Mobile1,  Mobile2,  Mobile3   from app_b2c_sms_template; ");
                }
                else
                {
                    query = "Select ID,Replace(Replace(SMSTemplate,'<',''),'>','') SMSTemplate,SMS_Type,If(IsActive=1,'Yes','No')IsActive,UserID ,DATE_FORMAT(Updatedate, '%d-%m-%Y')Updatedate,  Mobile1,Mobile2,Mobile3 from app_b2c_sms_template Where SMS_Type=@Type; ";
                    dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, query.ToString(), new MySqlParameter("@Type", Type)).Tables[0];
                }
            }

            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);            
            return ex.Message;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string SaveData(List<Datalist> data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string msg = "";
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (data.Count > 0)
            {
                if (data[0].Id != "0")
                {
                    string str = "update app_b2c_sms_template set Mobile1=@Mobile1,Mobile2=@Mobile2 ,Mobile3=@Mobile3, SMSTemplate=@SMSText ,SMS_Type=@SmsType  , isActive=@IsActive  ,UserID=@EntryById,Updatedate=NOW()  where ID=@Id";
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str.ToString(),
                             new MySqlParameter("@Mobile1", Util.GetString(data[0].Mobile1)),
                              new MySqlParameter("@Mobile2", Util.GetString(data[0].Mobile1)),
                            new MySqlParameter("@Mobile3", Util.GetString(data[0].Mobile1)),
                            new MySqlParameter("@SMSText", Util.GetString(data[0].SMSText)),
                            new MySqlParameter("@SmsType", Util.GetString(data[0].SmsType)),
                              new MySqlParameter("@IsActive", Util.GetString(data[0].IsActive)),
                            new MySqlParameter("@Id", data[0].Id),
                            new MySqlParameter("@EntryById", UserInfo.ID)
                            );
                    
                    msg = "Record Update Successfully!";
                }
                else
                {
                    if (StockReports.ExecuteScalar(" SELECT Count(*) FROM `app_b2c_sms_template` WHERE SMS_Type='" + data[0].SmsType + "'; ").ToString() == "0")
                    {
                        string str = "insert INTO app_b2c_sms_template(SMSTemplate,SMS_Type,IsActive,UserID,Updatedate,Mobile1,Mobile2,Mobile3) values(@SMSTemplate,@SMS_Type,@IsActive,@UserID,Now(),@Mobile1,@Mobile2,@Mobile3);";
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str.ToString(),
                            new MySqlParameter("@Mobile1", Util.GetString(data[0].Mobile1)),
                             new MySqlParameter("@Mobile2", Util.GetString(data[0].Mobile1)),
                           new MySqlParameter("@Mobile3", Util.GetString(data[0].Mobile1)),
                           new MySqlParameter("@SMSText", Util.GetString(data[0].SMSText)),
                           new MySqlParameter("@SmsType", Util.GetString(data[0].SmsType)),
                             new MySqlParameter("@IsActive", Util.GetString(data[0].IsActive)),
                           new MySqlParameter("@UserID", UserInfo.ID)
                           );                    
                        msg = "Record saved Successfully!";
                    }
                    else {
                        msg = "SMS Type!";
                    }
                }

            }
            tranX.Commit();
            return msg;
        }
        catch (Exception ex)
        {
            tranX.Rollback();
			ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
        finally
        {
			tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public class Datalist
    {
        private string _Id;
        private string _SMSText;
        private string _SmsType;
        private string _IsActive;
		
		private string _Mobile1;
		private string _Mobile2;
		private string _Mobile3;
		
        public string Id
        {
            get { return _Id; }
            set { _Id = value; }
        }
        public string SMSText
        {
            get { return _SMSText; }
            set { _SMSText = value; }
        }
        public string SmsType
        {
            get { return _SmsType; }
            set { _SmsType = value; }
        }
        public string IsActive
        {
            get { return _IsActive; }
            set { _IsActive = value; }
        }
		
		public string Mobile1
        {
            get { return _Mobile1; }
            set { _Mobile1 = value; }
        }
		public string Mobile2
        {
            get { return _Mobile2; }
            set { _Mobile2 = value; }
        }
		public string Mobile3
        {
            get { return _Mobile3; }
            set { _Mobile3 = value; }
        }
    }
    
}
using System;
using System.Collections.Generic;
using System.Data;
//using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Reflection;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using Newtonsoft.Json;
using System.IO;
using System.Drawing;
public partial class Design_B2BMobile_MobileAppB2BSetting : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {


        }
    }

    [WebMethod]
    public static string BindData()
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT ID,Color,ifnull(WelcomeContent,'')WelcomeContent ,ifnull(WelcomeText,'')WelcomeText,Concat('../B2CMobile/Images/','',IF(Logo='','default.jpg',Logo))Logo,IF(IsShowPoweredBy=0,'No','Yes')IsShowPoweredBy,HeaderTest,IFNULL(LabReportPath,'')LabReportPath,HelpLineNo24x7 from App_B2B_Setting  Limit 1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }
    [WebMethod]
    public static string SaveData(List<Datalist> data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (data.Count > 0)
            {

                if (data[0].LoginLogo != "")
                {
                    string directoryPath = HttpContext.Current.Server.MapPath("~/Design/B2BMobile/Images/");
                    if (!Directory.Exists(directoryPath))
                    {
                        Directory.CreateDirectory(directoryPath);
                    }
                    byte[] byteBuffer = Convert.FromBase64String(data[0].LoginLogo.Split(',')[1].ToString());
                    using (MemoryStream ms = new MemoryStream(byteBuffer))
                    {
                        using (Bitmap bm2 = new Bitmap(ms))
                        {
                            bm2.Save(HttpContext.Current.Server.MapPath("~/Design/B2BMobile/Images/" + data[0].FileName));
                        }
                    }
                }

                StringBuilder sb = new StringBuilder();
                string ab = (StockReports.ExecuteScalar("SELECT count(1) FROM App_B2B_Setting  Limit 1;"));
                if (ab != "0")
                {
                    sb.Append(" Update App_B2B_Setting  SET HeaderTest=@HeaderTest,WelcomeContent=@WelcomeContent,Color=@Color,WelcomeText=@WelcomeText,UpdateById=@EntryById,UpdateBy=@EntryBy,IsShowPoweredBy=@IsShowPoweredBy,LabReportPath=@LabReportPath,HelpLineNo24x7=@HelpLineNo24x7");
                    if (data[0].LoginLogo != "")
                        sb.Append(" ,Logo=@Logo ");
                    sb.Append("  WHERE ID=@ID ;");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@HeaderTest", Util.GetString(data[0].LoginContent2)),
                             new MySqlParameter("@Color", Util.GetString(data[0].ThemeColor)),
                           new MySqlParameter("@WelcomeText", Util.GetString(data[0].LoginContent1)),
                           new MySqlParameter("@IsShowPoweredBy", Util.GetString(data[0].PoweredBy)),
                           new MySqlParameter("@LabReportPath", Util.GetString(data[0].LabReportPath)),
                             new MySqlParameter("@Logo", Util.GetString(data[0].FileName)),
                            new MySqlParameter("@WelcomeContent", Util.GetString(data[0].WelcomeContent)),
                             new MySqlParameter("@HelpLineNo24x7", Util.GetString(data[0].Helpline24x7)),
                           new MySqlParameter("@EntryBy", Util.GetString(UserInfo.LoginName)),
                           new MySqlParameter("@EntryById", UserInfo.ID),
                           new MySqlParameter("@ID", data[0].Appid)
                           );

                }
                else
                {

                    sb.Append("INSERT INTO `App_B2B_Setting`(HeaderTest,Color,Logo,WelcomeText,EntryById,EntryBy,EntryDate,IsShowPoweredBy,LabReportPath,WelcomeContent,HelpLineNo24x7)");
                    sb.Append("VALUES(@HeaderTest,@Color,@Logo,@WelcomeText,@EntryById,@EntryBy,NOW(),@IsShowPoweredBy,@LabReportPath,@WelcomeContent,@HelpLineNo24x7) ");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@HeaderTest", Util.GetString(data[0].LoginContent2)),
                          new MySqlParameter("@Color", Util.GetString(data[0].ThemeColor)),
                        new MySqlParameter("@WelcomeText", Util.GetString(data[0].LoginContent1)),
                        new MySqlParameter("@IsShowPoweredBy", Util.GetString(data[0].PoweredBy)),
                        new MySqlParameter("@LabReportPath", Util.GetString(data[0].LabReportPath)),
                          new MySqlParameter("@Logo", Util.GetString(data[0].FileName)),
                         new MySqlParameter("@WelcomeContent", Util.GetString(data[0].WelcomeContent)),
                          new MySqlParameter("@HelpLineNo24x7", Util.GetString(data[0].Helpline24x7)),
                        new MySqlParameter("@EntryBy", Util.GetString(UserInfo.LoginName)),
                        new MySqlParameter("@EntryById", UserInfo.ID)
                        );
                }

            }
            tranX.Commit();
            return "Record Saved";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tranX.Rollback();
            return ex.Message;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public class Datalist
    {

        public string WelcomeContent
        {
            get;
            set;
        }
        public string CentreID
        {
            get;
            set;
        }
        public string Appid
        {
            get;
            set;
        }
        public string LoginContent2
        {
            get;
            set;
        }
        public string ThemeColor
        {
            get;
            set;
        }
        public string LoginLogo
        {
            get;
            set;
        }
        public string LoginContent1
        {
            get;
            set;
        }

        public string PoweredBy
        {
            get;
            set;
        }
        public string FileName
        {
            get;
            set;
        }
        public string LabReportPath
        {
            get;
            set;
        }
        public string Helpline24x7
        {
            get;
            set;
        }

    }
}
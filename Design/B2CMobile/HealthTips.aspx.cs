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



public partial class Design_PROApp_HealthTips : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string ImageData(string Id)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        try
        {

            DataTable dt = new DataTable();
            if (Id != "0")
            {
                dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,Name,TipsContent,Concat('../B2CMobile/Images/','',if(TipsImage='','default.jpg',TipsImage))TipsImage,IF(IsActive=1,'Yes','No') IsActive,DATE_FORMAT(EntryDateTime,'%d-%b-%y %I:%i %p'),TipsImage as Img FROM app_mobile_healthtips  Where Id=@Id", new MySqlParameter("@Id", Id)).Tables[0];

            }
            else
                dt = StockReports.GetDataTable("SELECT ID,Name,TipsContent,Concat('../B2CMobile/Images/','',if(TipsImage='','default.jpg',TipsImage))TipsImage,IF(IsActive=1,'Yes','No') IsActive,DATE_FORMAT(EntryDateTime,'%d-%b-%y %I:%i %p') Entrydate FROM app_mobile_healthtips ORDER BY PrintOrder ");
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "Error";
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
                if (data[0].Image != "")
                {
                    string directoryPath = HttpContext.Current.Server.MapPath("~/Design/B2CMobile/Images/");
                    if (!Directory.Exists(directoryPath))
                    {
                        Directory.CreateDirectory(directoryPath);
                    }
                    //  Bitmap varBmp = Base64StringToBitmap(ClintLogo);
                    byte[] byteBuffer = Convert.FromBase64String(data[0].Image.Split(',')[1].ToString());
                    using (MemoryStream ms = new MemoryStream(byteBuffer))
                    {
                        using (Bitmap bm2 = new Bitmap(ms))
                        {
                            bm2.Save(HttpContext.Current.Server.MapPath("~/Design/B2CMobile/Images/" + data[0].FileName));
                        }
                    }
                }
                if (data[0].Id != "0")
                {
                    if (data[0].Image != "")
                    {
                        string str = "update app_mobile_healthtips set Name=@Name ,TipsContent=@TipsContent ,TipsImage=@TipsImage,isActive=@IsActive ,UserID=@UpdateID   where ID=ID";
                        int a = MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str.ToString(),
                                  new MySqlParameter("@Name", data[0].HeaderText),
                                  new MySqlParameter("@TipsContent", data[0].Content),
                                   new MySqlParameter("@TipsImage", data[0].FileName),
                                    new MySqlParameter("@IsActive", data[0].IsActive),
                                       new MySqlParameter("@UpdateID", UserInfo.ID), new MySqlParameter("@ID", data[0].Id));
                    }
                    else
                    {
                        string str = "update app_mobile_healthtips set Name=@Name,TipsContent=@TipsContent,isActive=@IsActive ,UserID=@UpdateID  where ID=ID";

                        int a = MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str.ToString(),
                         new MySqlParameter("@Name", data[0].HeaderText),
                                 new MySqlParameter("@TipsContent", data[0].Content),
                                   new MySqlParameter("@IsActive", data[0].IsActive),
                                      new MySqlParameter("@UpdateID", UserInfo.ID),
                                       new MySqlParameter("@ID", data[0].Id));
                    }
                    msg = "Record Update Successfully!";
                }
                else
                {
                    string str = "insert INTO app_mobile_healthtips(Name,TipsContent,TipsImage,IsActive,UserID) values(@Name,@TipsContent,@TipsImage,@IsActive,@UpdateID)";
                    int a = MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str.ToString(),
                         new MySqlParameter("@Name", data[0].HeaderText),
                                 new MySqlParameter("@TipsContent", data[0].Content),
                                  new MySqlParameter("@TipsImage", data[0].FileName),
                                   new MySqlParameter("@IsActive", data[0].IsActive),
                                      new MySqlParameter("@UpdateID", UserInfo.ID));
                    msg = "Record saved Successfully!";
                }

            }
            tranX.Commit();
            return msg;
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            return ex.Message;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveHealthOrdering(string HTOrder)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            // ObsData= Order|ObservationId|Header|IsCritical#
            HTOrder = HTOrder.TrimEnd('|');

            string str = "";
            int len = Util.GetInt(HTOrder.Split('|').Length);
            string[] Data = new string[len];
            Data = HTOrder.Split('|');
            for (int i = 0; i < len; i++)
            {
                str = " UPDATE app_mobile_healthtips SET  PrintOrder=@PrintOrder WHERE ID=@ID";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str, new MySqlParameter("@PrintOrder", (Util.GetInt(i) + 1)),
                                      new MySqlParameter("@ID", Data[i].ToString()));
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
    }
    public class Datalist
    {
        private string _Id;
        private string _Image;
        private string _HeaderText;
        private string _FileName;
        private string _Content;
        private string _IsActive;
        public string Id
        {
            get { return _Id; }
            set { _Id = value; }
        }
        public string HeaderText
        {
            get { return _HeaderText; }
            set { _HeaderText = value; }
        }
        public string Content
        {
            get { return _Content; }
            set { _Content = value; }
        }
        public string Image
        {
            get { return _Image; }
            set { _Image = value; }
        }
        public string FileName
        {
            get { return _FileName; }
            set { _FileName = value; }
        }
        public string IsActive
        {
            get { return _IsActive; }
            set { _IsActive = value; }
        }
    }
}
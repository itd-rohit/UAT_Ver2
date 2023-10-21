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
public partial class Design_Master_UploadBannar : System.Web.UI.Page
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
        sb.Append(" SELECT ID,Concat('../B2CMobile/Images/','',if(Image='','default.jpg',Image))Image,ShowOrder,IsActive from app_b2c_banner  order by ShowOrder ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }
    [WebMethod]
    public static string DeleteImage(string ID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            string str = " delete from app_b2c_banner where id='" + ID + "' ";
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str.ToString());
            tranX.Commit();
            return "Banner Delete Successfully!";
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            return "";
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
                if (data[0].Bannerimg != "")
                {
                    string directoryPath = HttpContext.Current.Server.MapPath("~/Design/B2CMobile/Images/");
                    if (!Directory.Exists(directoryPath))
                    {
                        Directory.CreateDirectory(directoryPath);
                    }
                    byte[] byteBuffer = Convert.FromBase64String(data[0].Bannerimg.Split(',')[1].ToString());
                    using (MemoryStream ms = new MemoryStream(byteBuffer))
                    {
                        using (Bitmap bm2 = new Bitmap(ms))
                        {
                            bm2.Save(HttpContext.Current.Server.MapPath("~/Design/B2CMobile/Images/" + data[0].FileName));
                        }
                    }
                }

                string MaxOrder = StockReports.ExecuteScalar("SELECT IFNULL(ROUND(MAX(ShowOrder)+1),1) ShowOrder FROM app_b2c_banner ");
                string str = "Insert into app_b2c_banner (ShowOrder,Image,CreatedBy,CreatedById,createdDate)values(@ShowOrder,@Image,@CreatedBy,@CreatedById,now())";

                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str.ToString(),
                                new MySqlParameter("@ShowOrder", Util.GetInt(MaxOrder)),
                                 new MySqlParameter("@Image", Util.GetString(data[0].FileName)),
                               new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                               new MySqlParameter("@CreatedById", UserInfo.ID)

                               );              
                msg = "Banner Uploaded Successfully!";

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
    public static string SaveBannerOrdering(string InvOrder)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            // ObsData= Order|ObservationId|Header|IsCritical#
            InvOrder = InvOrder.TrimEnd('|');
            string str = "";
            int len = Util.GetInt(InvOrder.Split('|').Length);
            string[] Data = new string[len];
            Data = InvOrder.Split('|');
            for (int i = 0; i < len; i++)
            {
                str = " UPDATE app_b2c_banner " +
                      " SET  ShowOrder=@ShowOrder, isActive=@IsActive WHERE ID=@ID ";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str.ToString(),
                                 new MySqlParameter("@ShowOrder", (Util.GetInt(i) + 1)),
                                  new MySqlParameter("@IsActive", (Data[i].ToString()).Split('#')[1]),
                                new MySqlParameter("@ID", (Data[i].ToString()).Split('#')[0])

                                );
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
        private string _Bannerimg;
        private string _FileName;
        public string Id
        {
            get { return _Id; }
            set { _Id = value; }
        }
        public string Bannerimg
        {
            get { return _Bannerimg; }
            set { _Bannerimg = value; }
        }
        public string FileName
        {
            get { return _FileName; }
            set { _FileName = value; }
        }
    }
}
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
public partial class Design_PROApp_HealthOffer : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string ImageDataList()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT ID,Concat('../B2CMobile/Images/','',if(Image='','default.jpg',Image))Image,IF(IsActive=1,'Yes','No') IsActive,DATE_FORMAT(EntryDateTime,'%d-%b-%y %I:%i %p') Entrydate FROM app_mobile_healthoffer ORDER BY printOrder");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveHealthOfferOrdering(string HTOrder)
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

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                str = " UPDATE app_mobile_healthoffer SET  PrintOrder=@PrintOrder WHERE ID=@ID";
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
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            con.Close();
            con.Dispose();
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {


            if (HiddenField1.Value == "")
            {
                int IsActive;
                if (chkActive.Checked)
                {
                    IsActive = 1;
                }
                else
                {
                    IsActive = 0;
                }

                if (FileUpload1.HasFile)
                {

                    string filename = Path.GetFileName(FileUpload1.PostedFile.FileName);
                    string directoryPath = HttpContext.Current.Server.MapPath("~/Design/B2CMobile/Images/");
                    if (!Directory.Exists(directoryPath))
                    {
                        Directory.CreateDirectory(directoryPath);
                    }
                    FileUpload1.SaveAs(Server.MapPath("~/Design/B2CMobile/Images/") + filename);
                    string str = "insert INTO app_mobile_healthoffer(Image,IsActive,UserID) values(@filename ,@IsActive,@UpdateID)";
                    int a = MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str.ToString(),
                                     new MySqlParameter("@filename", filename), new MySqlParameter("@IsActive", IsActive), new MySqlParameter("@UpdateID", UserInfo.ID));
                    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Success', 'Record Saved', '');", true);
                    chkActive.Checked = false;

                }
                else
                {
                    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Error', 'Please select File..', '');", true);

                }
            }
            else
            {
                int IsActive;
                if (chkActive.Checked)
                {
                    IsActive = 1;
                }
                else
                {
                    IsActive = 0;
                }
                if (FileUpload1.HasFile)
                {
                    string filename = Path.GetFileName(FileUpload1.PostedFile.FileName);
                    string directoryPath = HttpContext.Current.Server.MapPath("~/Design/B2CMobile/Images/");
                    if (!Directory.Exists(directoryPath))
                    {
                        Directory.CreateDirectory(directoryPath);
                    }
                    FileUpload1.SaveAs(Server.MapPath("~/Design/B2CMobile/Images/") + filename);
                    string str = "update app_mobile_healthoffer set Image=@filename,isActive=@IsActive ,UpdateID=@UpdateID ,UpdateName=@UpdateName ,UpdateDate=NOW() where ID=@ID";
                    int a = MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str.ToString(),
                                      new MySqlParameter("@filename", filename), new MySqlParameter("@IsActive", IsActive), new MySqlParameter("@UpdateID", UserInfo.ID), new MySqlParameter("@UpdateName", UserInfo.LoginName), new MySqlParameter("@ID", HiddenField1.Value));
                    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Success', 'Record Updated', '');", true);
                    chkActive.Checked = false;
                    btnsave.Text = "Save";
                    imgHeader.Visible = false;

                }
                else
                {
                    string str = "update app_mobile_healthoffer set isActive=@IsActive ,UpdateID=@UpdateID ,UpdateName=@UpdateName ,UpdateDate=NOW() where ID=@ID";
                    int a = MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str.ToString(),
                                      new MySqlParameter("@IsActive", IsActive), new MySqlParameter("@UpdateID", UserInfo.ID), new MySqlParameter("@UpdateName", UserInfo.LoginName), new MySqlParameter("@ID", HiddenField1.Value));
                    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Success', 'Record Updated', '');", true);
                    chkActive.Checked = false;

                    btnsave.Text = "Save";
                    imgHeader.Visible = false;

                }
            }
            tranX.Commit();
        }

        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
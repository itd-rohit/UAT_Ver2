using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Services;
 
using System.Configuration;
using System.Collections; 
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls; 
using System.Collections.Generic;
using System.Text;


public partial class Design_Master_TitleMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
                
        }
    }
    public static DataTable getTitleDetail()
    {
        return StockReports.GetDataTable("SELECT ID,Title FROM Title_Master WHERE IsActive=1");
    }    
    [WebMethod(EnableSession = true)]
    public static string titleMasterDetail()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(getTitleDetail());
    }
    [WebMethod(EnableSession = true)]
    public static string saveTitle(string titleName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM title_master WHERE Title=@Title",
                new MySqlParameter("@Title", titleName)));
            if (count > 0)
            {
                return "Title already exits" ;
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO title_master(Title,CreatedBy)VALUES(@Title,@CreatedBy)",
                   new MySqlParameter("@Title", titleName),
                   new MySqlParameter("@CreatedByID", HttpContext.Current.Session["ID"]), new MySqlParameter("@CreatedBy", HttpContext.Current.Session["LoginName"]));
                int ID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT LAST_INSERT_ID() as AutoKey"));
                tnx.Commit();
                return "Record Saved Successfully|"+ID+"|"+titleName;
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "Error";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string titleDetail()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT ID,Title,Gender,if(IsActive=1,'Active','DeActive')Status FROM title_gender_master order by ShowOrder"))
        {
            return Util.getJson(dt);
        }
    }
    [WebMethod(EnableSession = true)]
    public static string saveData(string title, string gender, string typeData, string ID,string IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (typeData.ToUpper() == "SAVE")
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM title_gender_master WHERE Title=@Title",
                    new MySqlParameter("@Title", title)));
                if (count > 0)
                {
                    return "Title already exits" ;
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO title_gender_master(Title,Gender,CreatedByID,CreatedBy,IsActive)VALUES(@Title,@Gender,@CreatedByID,@CreatedBy,@IsActive)",
                       new MySqlParameter("@Title", title), new MySqlParameter("@Gender", gender),
                       new MySqlParameter("@CreatedByID", HttpContext.Current.Session["ID"]), new MySqlParameter("@CreatedBy", HttpContext.Current.Session["LoginName"]), new MySqlParameter("@IsActive", IsActive));

                    using (DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT Title,Gender,if(IsActive=1,'Yes','No')IsActive FROM title_gender_master WHERE IsActive=1").Tables[0])
                    {
                        File.WriteAllText(HttpContext.Current.Server.MapPath("~/Scripts/titleWithGender.js"), string.Concat("titleWithGenderData = function (callback) { callback(", Util.getJson(dt).Replace("\r\n", ""), ")}"));
                        tnx.Commit();
                        return "Record Saved Successfully";
                    }
                }
            }
            else
            {
                //int patientCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM patient_master WHERE Title=@Title",
                  // new MySqlParameter("@Title", title)));
                //if (patientCount > 0)
                //{
                  //  return "Patient already registered with this Title";
                //}
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM title_gender_master WHERE Title=@Title AND ID!=@ID",
                   new MySqlParameter("@Title", title), new MySqlParameter("@ID", ID)));
                if (count > 0)
                {
                    return  "Title already exits";
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE title_gender_master SET Title=@Title,Gender=@Gender,IsActive=@IsActive WHERE ID=@ID ",
                       new MySqlParameter("@Title", title), new MySqlParameter("@Gender", gender),new MySqlParameter("@IsActive", IsActive),
                       new MySqlParameter("@ID", ID));

                    using (DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT Title,Gender,if(IsActive=1,'Yes','No')IsActive FROM title_gender_master WHERE IsActive=1").Tables[0])
                    {
                        File.WriteAllText(HttpContext.Current.Server.MapPath("~/Scripts/titleWithGender.js"), string.Concat("titleWithGenderData = function (callback) { callback(", Util.getJson(dt).Replace("\r\n", ""), ")}"));
                        tnx.Commit();
                        return "Record Updated Successfully";
                    }
                }
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return  "Error" ;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]   
    public static string SaveOrdering(string InvOrder)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
           
            InvOrder = InvOrder.TrimEnd('|');
            string str = "";
            int len = Util.GetInt(InvOrder.Split('|').Length);
            string[] Data = new string[len];
            Data = InvOrder.Split('|');
            for (int i = 0; i < len; i++)
            {

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE title_gender_master SET ShowOrder=@ShowOrder WHERE ID=@ID ",
                       new MySqlParameter("@ShowOrder", (Util.GetInt(i) + 1)),
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
}
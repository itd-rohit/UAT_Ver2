using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_OPD_MapOutSourceLabWithOther : System.Web.UI.Page
{
    public static string InvID = "";
    public static string Outsrclabid = "";
    public static string BookingCentreID = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        InvID = Request.QueryString["Investigation_Id"].ToString();
        Outsrclabid = Request.QueryString["LabID"].ToString();
        BookingCentreID = Request.QueryString["BookingCentreID"].ToString();
        if (!IsPostBack)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {

                lb2.Text = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select name from investigation_master where Investigation_Id=@Investigation_Id",
                    new MySqlParameter("@Investigation_Id", InvID)));
                lb1.Text = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT name FROM outsourcelabMaster WHERE id=@id",
                    new MySqlParameter("@id", Outsrclabid)));
                lb.Text = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT centre FROM centre_master WHERE centreid=@centreid",
                    new MySqlParameter("@centreid", BookingCentreID)));               
                bindinv();
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
    }

    private void bindinv()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT im.itemid,typename name FROM investigation_master inv INNER JOIN f_itemmaster im ON im.Type_ID=inv.Investigation_Id  AND im.IsActive=1 and Investigation_Id<> @Investigation_Id ORDER BY NAME  ",
               new MySqlParameter("@Investigation_Id", InvID)).Tables[0])

            ddltest.DataSource = dt;
            ddltest.DataValueField = "itemid";
            ddltest.DataTextField = "NAME";
            ddltest.DataBind();
            ddltest.Items.Insert(0, new ListItem("Select", "0"));
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

    [WebMethod]    
    public static string savedata(string TestID)
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con,CommandType.Text,"delete from investigations_outsrclab_othertest where InvID=@InvID and Outsrclabid=@Outsrclabid and BookingCentreID=@BookingCentreID and otherinvid=@otherinvid",
                new MySqlParameter("@InvID", InvID),
                new MySqlParameter("@Outsrclabid",Outsrclabid),
                new MySqlParameter("@BookingCentreID",BookingCentreID),
                new MySqlParameter("@otherinvid",TestID));


            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "insert into investigations_outsrclab_othertest (InvID,Outsrclabid,BookingCentreID,otherinvid,createdate,createbyuser) values (@InvID,@Outsrclabid,@BookingCentreID,@otherinvid,now(),@createbyuser)",
               new MySqlParameter("@InvID", InvID),
               new MySqlParameter("@Outsrclabid", Outsrclabid),
               new MySqlParameter("@BookingCentreID", BookingCentreID),
               new MySqlParameter("@otherinvid", TestID),
               new MySqlParameter("@createbyuser", HttpContext.Current.Session["ID"].ToString()));
               
        return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getdata()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT typename,ir.id FROM investigations_outsrclab_othertest ir INNER JOIN f_itemmaster im ON im.itemid=ir.otherinvid AND ir.InvID=@InvID and BookingCentreID=@BookingCentreID and Outsrclabid=@Outsrclabid ORDER BY typename ",
                new MySqlParameter("@InvID", InvID),
                new MySqlParameter("@BookingCentreID", BookingCentreID),
                new MySqlParameter("@Outsrclabid", Outsrclabid)).Tables[0])
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string deleteme(string id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "delete from investigations_outsrclab_othertest where id=@id ",
                new MySqlParameter("@id", id));
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl=new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Master_Fieldboy_Master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //AllLoad_Data.bindBusinessZone(ddlZone,"Select");
            //string BusinessZoneID = StockReports.ExecuteScalar("SELECT BusinessZoneID FROM centre_master cm where CentreID ='" + UserInfo.Centre + "' ");
            //ddlState.SelectedIndex = ddlState.Items.IndexOf(ddlState.Items.FindByValue(StateID));
            //lblStateID.Text = StateID;
            //  AllLoad_Data.bindCity(ddlCity, StateID);
            //  bindZone(ddlCity.SelectedValue);
        }
    }

    //private void bindZone(string CityID)
    //{
    //    DataTable dt = StockReports.GetDataTable("SELECT ZoneID,Zone FROM `centre_zonemaster`   Where IsActive=1 AND CityID=" + CityID + " ORDER By Zone");
    //    lstZone.DataSource = dt;
    //    lstZone.DataTextField = "Zone";
    //    lstZone.DataValueField = "ZoneID";
    //    lstZone.DataBind();
    //}

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string ShowDetail(string _ID)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(string.Format(" SELECT FeildBoyID,NAME,Age,Mobile,IsActive,Address,StateID,CityID,HomeCollection FROM `feildboy_master` WHERE FeildBoyID='{0}'; ", _ID));
            string retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return retr;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveRecord(string ID, string Name, string Age, string Mobile, string Address, string StateID, string CityID, string IsActive, string ItemData, int HomeCollection)
    {
        try
        {
            int valCentreID = UserInfo.Centre;
        }
        catch
        {
            return "-1";
        }

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {
            int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM `feildboy_master`   WHERE NAME='" + Util.GetString(Name.Trim()) + "' AND `FeildboyID`<>'" + ID + "' "));
            if (valDuplicate > 0)
            {
                Tnx.Rollback();
                return "2";
            }
            ItemData = ItemData.TrimEnd('#');
            string str = "";
            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');
            string FieldBoyID = "";
            if (ID == "")
            {
                sb.Append(" INSERT INTO feildboy_master(NAME,Age,Mobile,IsActive,UserID,UserName,dtEntry,IpAddress,Address,StateID,CityID,HomeCollection) ");
                sb.Append(" values('" + Util.GetString(Name.Trim()) + "','" + Util.GetString(Age.Trim()) + "','" + Util.GetString(Mobile.Trim()) + "',1,'" + UserInfo.ID + "','" + UserInfo.LoginName + "',NOW(),'" + StockReports.getip() + "','" + Util.GetString(Address.Trim()) + "','" + StateID + "','" + CityID + "','" + HomeCollection + "'); ");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

                FieldBoyID = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT MAX(FeildboyID) FROM feildboy_master"));
            }
            else
            {
                sb.Append(" UPDATE feildboy_master SET Name = '" + Util.GetString(Name.Trim()) + "',Age = '" + Util.GetString(Age.Trim()) + "', ");
                sb.Append(" Mobile = '" + Mobile.Trim() + "',IsActive = '" + IsActive + "',UpdateDate=NOW(),UpdatedBy='" + UserInfo.LoginName + "',UpdatedByID='" + UserInfo.ID + "',");
                sb.Append(" IpAddress = '" + StockReports.getip() + "',Address = '" + Util.GetString(Address.Trim()) + "',StateID = '" + StateID + "',CityID = '" + CityID + "',HomeCollection='" + HomeCollection + "' ");
                sb.Append(" WHERE FeildboyID = '" + ID.Trim() + "';");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
                FieldBoyID = ID;
            }
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "DELETE FROM fieldBoy_ZoneDetail WHERE FieldBoyID='" + FieldBoyID + "'");
            for (int i = 0; i < len; i++)
            {
                str = "insert into fieldBoy_ZoneDetail(FieldBoyID,StateID,CityID,ZoneID,CreatedBy)values('" + FieldBoyID + "','" + StateID + "','" + CityID + "','" + Item[i].ToString() + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "') ";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
            }

            Tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string GetData()
    {
        try
        {
            int valCentreID = UserInfo.Centre;
        }
        catch
        {
            return "-1";
        }

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT FeildBoyID,NAME,Age,Mobile,fm.IsActive,IF(fm.IsActive='1','Yes','No') `Status`,Address, ");
            sb.Append(" IFNULL(fm.StateID,0) StateID,sm.`state`, IFNULL(fm.CityID,0)CityID,cm.`City` ,if(fm.HomeCollection=1,'Yes','No')HomeCollection  ");
            sb.Append(" FROM feildboy_master fm  ");
            sb.Append(" INNER JOIN state_master sm ON sm.`id`=fm.`StateID`  ");
            sb.Append(" INNER JOIN city_master cm ON cm.`ID`=fm.`CityID` ORDER BY fm.`Name`;");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindSelectedBusinessZone(string FieldBoyID)
    {
        DataTable dt = StockReports.GetDataTable(string.Format("SELECT ZoneID FROM fieldBoy_ZoneDetail WHERE FieldBoyID='{0}'", FieldBoyID));
        return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string bindBusinessZoneWiseState(string BusinessZoneID)
    {
        return Util.getJson(StockReports.GetDataTable(string.Format("SELECT ID,State FROM state_master WHERE BusinessZoneID IN({0}) AND IsActive=1", BusinessZoneID)));
    }
}
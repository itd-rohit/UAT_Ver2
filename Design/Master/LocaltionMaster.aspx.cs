using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Master_LocaltionMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            AllLoad_Data.bindBusinessZone(ddlSBussinessZone, "Select");
            AllLoad_Data.bindBusinessZone(ddlStBussinessZone, "Select");
            AllLoad_Data.bindBusinessZone(ddlMBusinessZone, "Select");
            AllLoad_Data.bindBusinessZone(ddlMCBusinessZone, "Select");
            AllLoad_Data.bindBusinessZone(ddlMZBusinessZone, "Select");
            AllLoad_Data.bindBusinessZone(ddlCityBusinessZone, "Select");
            AllLoad_Data.bindBusinessZone(ddlZoneBusinessZone, "Select");
            AllLoad_Data.bindBusinessZone(ddlModifyBusinessZone, "Select");
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindState()
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" SELECT ID,State FROM state_master WHERE IsActive=1 order by State");
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
    public static string bindAllState(string BusinessZoneID)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" SELECT Concat(ID,'#',IsActive)ID,State FROM state_master WHERE BusinessZoneID='" + BusinessZoneID + "' order by State");
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
    public static string bindCity(string StateID)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" SELECT ID,City FROM city_master WHERE StateID='" + StateID.Trim() + "' And IsActive=1 order by City");
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
    public static string bindAllCity(string StateID)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" SELECT Concat(ID,'#',IsActive)ID,City FROM city_master WHERE StateID='" + StateID.Trim() + "'  order by City");
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
    public static string bindZone(string StateID, string CityID)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" SELECT ZoneID,Zone FROM centre_zonemaster WHERE IsActive=1 And StateID='" + StateID.Trim() + "'AND CityID='" + CityID.Trim() + "'   ORDER BY Zone ");
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
    public static string bindAllZone(string StateID, string CityID)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" SELECT concat(ZoneID,'#',IsActive)ZoneID,Zone FROM centre_zonemaster WHERE  StateID='" + StateID.Trim() + "'AND CityID='" + CityID.Trim() + "'   ORDER BY Zone ");
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
    public static string SaveState(string State, string IsActive, string BusinessZoneID)
    {
        try
        {
            if (State.Trim() != "" && IsActive.Trim() != "" && BusinessZoneID != "0" && BusinessZoneID != "")
            {
                string isDupl = StockReports.ExecuteScalar(" SELECT COUNT(*) FROM state_master WHERE state='" + State.Trim() + "' ");
                if (isDupl.Trim() == "0")
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO state_master (state,IsActive,CreatedBy,CreatedByID,BusinessZoneID)values ");
                    sb.Append(" ( '" + State.Trim() + "','" + IsActive + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + BusinessZoneID.Trim() + "'  ) ");
                    StockReports.ExecuteDML(sb.ToString());
                    return "1";
                }
                else
                {
                    return "2";
                }
            }
            else
            {
                return "0";
            }
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
    public static string UpdateState(string State, string IsActive, string StateID, string BusinessZone)
    {
        try
        {
            if (State.Trim() != "" && IsActive.Trim() != "" && StateID.Trim() != "")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" Update  state_master SET BusinessZoneID='" + BusinessZone.Trim() + "',state = '" + State.Trim() + "',  IsActive = '" + IsActive.Trim() + "',   UpdateBy = '" + UserInfo.UserName + "',  UpdateByID = '" + UserInfo.ID + "',  Updatedate = now() WHERE id = '" + StateID.Trim() + "'; ");
                StockReports.ExecuteDML(sb.ToString());
                return "1";
            }
            else
            {
                return "0";
            }
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
    public static string UpdateCity(string City, string IsActive, string CityID)
    {
        try
        {
            if (City.Trim() != "" && IsActive.Trim() != "" && CityID.Trim() != "")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" Update  city_master SET City = '" + City.Trim() + "',  IsActive = '" + IsActive.Trim() + "',   UpdateBy = '" + UserInfo.UserName + "',  UpdateByID = '" + UserInfo.ID + "'  WHERE id = '" + CityID.Trim() + "'; ");
                StockReports.ExecuteDML(sb.ToString());
                return "1";
            }
            else
            {
                return "0";
            }
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
    public static string UpdateZone(string Zone, string IsActive, string ZoneID)
    {
        try
        {
            if (Zone.Trim() != "" && IsActive.Trim() != "" && ZoneID.Trim() != "")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" Update  centre_zonemaster SET Zone = '" + Zone.Trim() + "',  IsActive = '" + IsActive.Trim() + "',   UpdateBy = '" + UserInfo.UserName + "',  UpdateByID = '" + UserInfo.ID + "',UpdateDate=now() WHERE ZoneID = '" + ZoneID.Trim() + "'; ");
                StockReports.ExecuteDML(sb.ToString());
                return "1";
            }
            else
            {
                return "0";
            }
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
    public static string SaveCity(string City, string StateID, string IsActive)
    {
        try
        {
            if (City.Trim() != "" && StateID.Trim() != "" && IsActive.Trim() != "")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO city_master (City, stateID, IsActive,CreatedBy, CreatedByID) values ");
                sb.Append("('" + City.Trim() + "','" + StateID.Trim() + "','" + IsActive.Trim() + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "'   ) ");
                StockReports.ExecuteDML(sb.ToString());
                return "1";
            }
            else
            {
                return "0";
            }
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
    public static string SaveZone(string Zone, string StateID, string CityID, string IsActive)
    {
        try
        {
            if (Zone.Trim() != "" && StateID.Trim() != "" && CityID.Trim() != "" && IsActive.Trim() != "")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO centre_zonemaster (Zone,CityID,StateID,IsActive,CreatedBy,CreatedByID) values ");
                sb.Append(" ('" + Zone.Trim() + "','" + CityID.Trim() + "','" + StateID.Trim() + "' ,'" + IsActive.Trim() + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "' ) ");
                StockReports.ExecuteDML(sb.ToString());
                return "1";
            }
            else
            {
                return "0";
            }
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
    public static string SaveLocality(string Locality, string ZoneID, string StateID, string CityID, string IsActive)
    {
        try
        {
            if (Locality.Trim() != "" && ZoneID.Trim() != "" && StateID.Trim() != "")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO f_locality (NAME,StateID,CityID,ZoneID,active,CreatedByID,CreatedBy,CreatedOn) values ");
                sb.Append(" ( '" + Locality.Trim() + "','" + StateID.Trim() + "','" + CityID.Trim() + "','" + ZoneID.Trim() + "','" + IsActive.Trim() + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',now() ) ");
                StockReports.ExecuteDML(sb.ToString());
                return "1";
            }
            else
            {
                return "0";
            }
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
    public static string UpdateLocality(string LocalityID, string Locality, string ZoneID, string StateID, string CityID, string IsActive, string BusinessZoneID)
    {
        try
        {
            if (Locality.Trim() != "" && ZoneID.Trim() != "" && StateID.Trim() != "" && BusinessZoneID != "0")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" update f_locality set BusinessZoneID='" + BusinessZoneID.Trim() + "',NAME='" + Locality.Trim() + "',StateID='" + StateID.Trim() + "',CityID='" + CityID.Trim() + "',ZoneID='" + ZoneID.Trim() + "' ");
                sb.Append(" ,active='" + IsActive.Trim() + "', UpdatedBy='" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',UpdatedByID='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',UpdatedOn=now() where ID='" + LocalityID.Trim() + "'  ");
                // System.IO.File.WriteAllText (@"C:\Nirmal\qry.txt", sb.ToString());
                StockReports.ExecuteDML(sb.ToString());
                //StockReports.ExecuteDML(" update state_master set BusinessZoneID='" + BusinessZoneID.Trim() + "' where ID='" + StateID + "' ");
                return "1";
            }
            else
            {
                return "0";
            }
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
    public static string GetLocality(string StateID, string BusinessZoneID, string CityID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT fl.ID,fl.Name,sm.state,cm.City,czm.Zone,fl.CreatedBy,IFNULL(fl.UpdatedBy,'')UpdatedBy,fl.CreatedOn,if(fl.Active='1','Yes','No')Active,fl.StateID,fl.CityID,fl.ZoneID,bm.BusinessZoneID FROM f_locality fl ");
        sb.Append(" INNER JOIN state_master sm ON sm.id=fl.StateID ");
        sb.Append(" INNER JOIN city_master cm ON cm.ID=fl.CityID ");
        sb.Append(" INNER JOIN centre_zonemaster czm ON czm.ZoneID=fl.ZoneID ");
        sb.Append(" INNER JOIN businesszone_master bm ON bm.BusinessZoneID=sm.BusinessZoneID ");
        sb.Append(" AND bm.BusinessZoneID='" + BusinessZoneID.Trim() + "' AND sm.id='" + StateID.Trim() + "' and cm.ID='" + CityID.Trim() + "' ");
        sb.Append(" ORDER BY fl.Name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return retr;
    }
}
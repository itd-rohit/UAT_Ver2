using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Linq;
using System.Web.UI.WebControls;
public partial class Design_HomeCollection_PhelebotomistMapping : System.Web.UI.Page
{
    public string locationId = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlZone, "Select");
            //  bindState(ddlState);


        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindState(string BusinessZoneID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string retr = "";
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT ID,State FROM state_master WHERE BusinessZoneID=@BusinessZoneID and BusinessZoneID<>0 AND IsActive=1 ORDER BY state ",
                new MySqlParameter("@BusinessZoneID", BusinessZoneID)).Tables[0])
            {
                retr = JsonConvert.SerializeObject(dt);
            }
            return retr;
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }
        finally
        {

            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public static string bindCity(string StateID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            List<string> pacitem = new List<string>();
            string[] pacitemTags = String.Join(",", StateID).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT ID,City FROM `city_master`  WHERE `IsActive`=1 and stateID IN({0})", pacitemClause), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
                }
            }


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(ex);
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindRoute_Multiple(string CityId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            List<string> pacitem = new List<string>();
            string[] pacitemTags = String.Join(",", CityId).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT distinct  `Routeid`,`Route` FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_routemaster` WHERE `IsActive`=1 and  `CityID` in ({0})", pacitemClause), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(ex);

        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindArea_Multiple(string Pincode, string CityId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] PincodeTags = Pincode.Split(',');
            string[] PincodeParamNames = PincodeTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string PincodeClause = string.Join(", ", PincodeParamNames);


            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT DISTINCT fl.Id,fl.NAME,fl.Pincode,IFNULL(arm.`Routeid`,'na') Routeid FROM `f_locality` fl LEFT JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping  arm ON arm.`localityid`=fl.`ID` WHERE active=1 AND `isHomeCollection`=1 AND fl.`CityId`=@CityId and  `Pincode` in ({0})  order by fl.Pincode,fl.`NAME` ", PincodeClause), con))
            {
                for (int i = 0; i < PincodeParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(PincodeParamNames[i], PincodeTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@CityId", CityId);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(ex);
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindArea_Multiple_Phelbo(string Pincode, string CityId, string PhelboId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] PincodeTags = Pincode.Split(',');
            string[] PincodeParamNames = PincodeTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string PincodeClause = string.Join(", ", PincodeParamNames);

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT DISTINCT fl.Id,fl.NAME,fl.Pincode,IFNULL(arm.`PhlebotomistID`,'na') Pheleboid FROM `f_locality` fl LEFT JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping  arm ON arm.`localityid`=fl.`ID` and arm.`PhlebotomistID`=@PhelboId WHERE active=1 AND `isHomeCollection`=1 AND fl.`CityId`=@CityId and  `Pincode` in ({0})  order by fl.Pincode,fl.`NAME` "
                , PincodeClause), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@PhelboId", PhelboId);
                da.SelectCommand.Parameters.AddWithValue("@CityId", CityId);
                for (int i = 0; i < PincodeParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(PincodeParamNames[i], PincodeTags[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {

                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        return JsonConvert.SerializeObject(dt);
                    }
                    else
                    {
                        return null;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public static string bindArea_Multiple_DropLocation(string Pincode, string CityId, string DropLocationId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] CityIdTags = CityId.Split(',');
            string[] CityIdParamNames = CityIdTags.Select(
              (s, i) => "@tag_" + i).ToArray();
            string CityIdClause = string.Join(", ", CityIdParamNames);

            string[] PincodeTags = Pincode.Split(',');
            string[] PincodeParamNames = PincodeTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string PincodeClause = string.Join(", ", PincodeParamNames);





            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT DISTINCT fl.Id,fl.NAME,fl.Pincode,IFNULL(arm.droplocationID,'na') droplocationID FROM `f_locality` fl LEFT JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping  arm ON arm.`localityid`=fl.`ID` and arm.`droplocationID`=@DropLocationId WHERE active=1 AND `isHomeCollection`=1 AND fl.`CityId` in ({0}) and  `Pincode` in ({1})  order by fl.Pincode,fl.`NAME` ",
                 CityIdClause, PincodeClause), con))
            {
                for (int i = 0; i < CityIdParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(CityIdParamNames[i], CityIdTags[i]);
                }

                for (int i = 0; i < PincodeParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(PincodeParamNames[i], PincodeTags[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
                }
            }


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(ex);
        }
        finally
        {

            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public static string bindRoute(string CityId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT `Routeid`,`Route` FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_routemaster` WHERE `IsActive`=1 and  `CityID`=@CityId ",
                new MySqlParameter("@CityId", CityId)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(dt);
                else
                    return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(ex);
        }
        finally
        {

            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public static string bindPhelbo(string CityId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT pm.`PhlebotomistID`,pm.NAME  FROM  " + Util.getApp("HomeCollectionDB") + ".hc_phleboworklocation pw INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster pm ON pm.`PhlebotomistID`=pw.`PhlebotomistID` WHERE pm.`Isactive`=1 and  pw.`CityId`=@CityId ",
                new MySqlParameter("@CityId", CityId)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(dt);
                else
                    return null;
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(ex);

        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindDropLocation(string StateId, string checkType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        StringBuilder sb = new StringBuilder();

        con.Open();
        try
        {
            sb.Append(" SELECT CONCAT(cm.centreid,'#',fpm.panel_id) centreid,CONCAT(centrecode,'-',centre,'(',cm.COCO_FOCO,')') centre FROM centre_master cm INNER JOIN `f_panel_master` fpm ON fpm.`CentreID`=cm.`CentreID` AND fpm.`PanelType`='Centre' WHERE cm.`isactive`=1 ");

            if (checkType == "1")
            {
                sb.Append("  and   cm.type1 in('PCC','PCL') ");
            }
            else if (checkType == "2")
            {
                sb.Append("  and   cm.type1 in('SL','NRL') ");
            }
            else if (checkType == "3")
            {
                sb.Append("  and   cm.type1 in('HLM','RLM') ");
            }
            else if (checkType == "4")
            {
                sb.Append("  and   cm.type1 in('RRL') ");
            }
            else if (checkType == "5")
            {
                sb.Append("  and   cm.type1 in('DDC') ");
            }
            else if (checkType == "6")
            {
                sb.Append("  and   cm.type1 in('STAT') ");
            }
            else
            {
                sb.Append("  and   cm.type1 in('PCC','PCL') ");

            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(dt);
                else
                    return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(ex);
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string GetData(string CityId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
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
            sb.Append("SELECT fl.ID, fl.`NAME` AS location,cym.City,ifnull(fl.Pincode,'') as Pincode ,IFNULL(GROUP_CONCAT( DISTINCT rm.Routeid SEPARATOR '^'), '0') Routeid,IFNULL( GROUP_CONCAT( DISTINCT rm.Route SEPARATOR '^'),'') Route, ");
            sb.Append(" IFNULL( GROUP_CONCAT(DISTINCT pm.Name SEPARATOR '^'),'')Phelbo,IFNULL(GROUP_CONCAT( DISTINCT pm.PhlebotomistID SEPARATOR '^'),'0')Phelboid,IFNULL(GROUP_CONCAT( DISTINCT concat(adm.`droplocationID`,'#',adm.PanelId) SEPARATOR '^'),'0')DropLocationid,IFNULL(GROUP_CONCAT( DISTINCT cm.Centre SEPARATOR '^'),'0') DropLocation, ");
            sb.Append("  fl.`StateID`,fl.`CityID` FROM  `f_locality` fl  ");
            sb.Append("  INNER JOIN city_master cym ON cym.id=fl.CityId ");
            sb.Append(" LEFT JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping arm ON fl.id=arm.localityid  ");
            sb.Append(" LEFT JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_routemaster rm ON rm.Routeid=arm.Routeid ");
            sb.Append(" LEFT JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping rpm ON  rpm.`localityid`=fl.id ");
            sb.Append(" LEFT JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster pm ON pm.`PhlebotomistID`=rpm.`PhlebotomistID` ");
            sb.Append(" LEFT JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping adm ON adm.`localityid`=fl.id  ");
            sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=adm.`droplocationID` ");
            sb.Append(" where  fl.isHomeCollection=1 and  fl.`cityid` IN ({0}) GROUP BY fl.id order by fl.Pincode,fl.`NAME` ");


            //using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
            //{
            //    return Util.getJson(dt);
            //}
            List<string> pacitem = new List<string>();
            string[] pacitemTags = String.Join(",", CityId).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), pacitemClause), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string GetDataExcel(string CityId)
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
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            sb.Append("SELECT cym.City, fl.`NAME` AS  Area ,ifnull(fl.Pincode,'') as Pincode ,IFNULL( GROUP_CONCAT( DISTINCT rm.Route),'') Route, ");
            sb.Append(" IFNULL( GROUP_CONCAT(DISTINCT pm.Name),'')Phelbo,IFNULL(GROUP_CONCAT( DISTINCT cm.Centre),'') 'Drop Location' ");
            sb.Append("   FROM  `f_locality` fl  ");
            sb.Append("  INNER JOIN city_master cym ON cym.id=fl.CityId ");
            sb.Append(" LEFT JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping arm ON fl.id=arm.localityid  ");
            sb.Append(" LEFT JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_routemaster rm ON rm.Routeid=arm.Routeid ");
            sb.Append(" LEFT JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping rpm ON  rpm.`localityid`=fl.id ");
            sb.Append("  LEFT JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster pm ON pm.`PhlebotomistID`=rpm.`PhlebotomistID` ");
            sb.Append("  LEFT JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping adm ON adm.`localityid`=fl.id  ");
            sb.Append("   LEFT JOIN centre_master cm ON cm.`CentreID`=adm.`droplocationID` ");
            sb.Append(" where  fl.isHomeCollection=1 and  fl.`cityid` IN ({0}) GROUP BY fl.id order by fl.Pincode,fl.`NAME` ");


            List<string> pacitem = new List<string>();
            string[] pacitemTags = String.Join(",", CityId).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), pacitemClause), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    if (dt.Rows.Count > 0)
                    {
                        da.Fill(dt);
                        HttpContext.Current.Session["dtExport2Excel"] = dt;
                        HttpContext.Current.Session["ReportName"] = "Phelebotomist Mapping";
                        return "true";
                    }
                    else
                    {
                        HttpContext.Current.Session["dtExport2Excel"] = "";
                        return "false";
                    }

                }
            }


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }
    }
    protected void chkRoles_DataBound(object sender, EventArgs e)
    {
        CheckBoxList chkList = (CheckBoxList)(sender);
        foreach (ListItem item in chkList.Items)
        {
            item.Attributes.Add("id", item.Value);
            item.Attributes.Add("chk_text", item.Text);
        }
    }
    [WebMethod(EnableSession = true)]
    public static string SaveRoute_Multiple(string LocalityId, string RouteID)
    {


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            StringBuilder sbLog = new StringBuilder();
            sbLog.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping_DeleteLog(localityid,Routeid,EntryDate,EntryBy,EntryByname,DeleteDate,DeleteBy,DeleteByname) ");
            sbLog.Append(" SELECT localityid,Routeid,EntryDate,EntryBy,EntryByname,Now(),@DeletedByID,@DeletedBy from  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping WHERE  localityid =@LocalityId  ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sbLog.ToString(),
             new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName),
             new MySqlParameter("@LocalityId", LocalityId));


            //MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "");
            List<string> pacitem = new List<string>();
            string[] pacitemTags = String.Join(",", LocalityId).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("delete from   " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping where  localityid in({0})", pacitemClause), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                }
            }


            StringBuilder sb = new StringBuilder();


            string[] DropLocationIDBreak = LocalityId.Split(',');

            for (int i = 0; i < DropLocationIDBreak.Length; i++)
            {




                sb = new StringBuilder();
                sb.Append(" insert into  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping (localityid,Routeid,EntryDate,EntryBy,EntryByname) ");
                sb.Append(" values (@localityid,@Routeid,@EntryDate,@EntryBy,@EntryByname) ");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
                cmd.Parameters.AddWithValue("@localityid", DropLocationIDBreak[i]);
                cmd.Parameters.AddWithValue("@Routeid", RouteID);
                cmd.Parameters.AddWithValue("@EntryDate", System.DateTime.Now);
                cmd.Parameters.AddWithValue("@EntryByname", UserInfo.LoginName);
                cmd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmd.ExecuteNonQuery();
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
    public static string SaveRoute(string LocalityId, string RouteID, string isChecked)
    {


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            if (isChecked == "false")
            {
                StringBuilder sbLog = new StringBuilder();
                sbLog.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping_DeleteLog(localityid,Routeid,EntryDate,EntryBy,EntryByname,DeleteDate,DeleteBy,DeleteByname) ");
                sbLog.Append(" SELECT localityid,Routeid,EntryDate,EntryBy,EntryByname,Now(),@DeletedByID,@DeletedBy from  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping WHERE  localityid =@LocalityId  ");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sbLog.ToString(),
                 new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName),
                 new MySqlParameter("@LocalityId", LocalityId));
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "delete from   " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping where  localityid =@LocalityId ",
                    new MySqlParameter("@LocalityId", Util.GetInt(LocalityId)));
                Tnx.Commit();
                return "3";
            }
            StringBuilder sbLog2 = new StringBuilder();
            sbLog2.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping_DeleteLog(localityid,Routeid,EntryDate,EntryBy,EntryByname,DeleteDate,DeleteBy,DeleteByname) ");
            sbLog2.Append(" SELECT localityid,Routeid,EntryDate,EntryBy,EntryByname,Now(),@DeletedByID,@DeletedBy from  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping WHERE  localityid =@LocalityId  ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sbLog2.ToString(),
             new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName),
             new MySqlParameter("@LocalityId", Util.GetInt(LocalityId)));

            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "delete from   " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping where  localityid =@LocalityId ",
                new MySqlParameter("@LocalityId", LocalityId));



            StringBuilder sb = new StringBuilder();




            int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping WHERE   localityid=@LocalityId  ",
                new MySqlParameter("@LocalityId", LocalityId)));

            if (valDuplicate > 0)
            {
                return "2";
            }
            else
            {

                sb = new StringBuilder();
                sb.Append(" insert into  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping (localityid,Routeid,EntryDate,EntryBy,EntryByname) ");
                sb.Append(" values (@localityid,@Routeid,@EntryDate,@EntryBy,@EntryByname) ");

                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
                cmd.Parameters.AddWithValue("@localityid", LocalityId);
                cmd.Parameters.AddWithValue("@Routeid", RouteID);
                cmd.Parameters.AddWithValue("@EntryDate", System.DateTime.Now);
                cmd.Parameters.AddWithValue("@EntryByname", UserInfo.UserName);
                cmd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmd.ExecuteNonQuery();
                Tnx.Commit();
                return "1";
            }
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
    public static string SavePhelbo(string LocalityId, string PhelboID, string isChecked)
    {


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            if (isChecked.ToLower() == "false")
            {
                StringBuilder sbLog = new StringBuilder();
                sbLog.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping_DeleteLog(localityid,PhlebotomistID,EntryDate,EntryBy,EntryByname,DeleteDate,DeleteBy,DeleteByname) ");
                sbLog.Append(" SELECT localityid,PhlebotomistID,EntryDate,EntryBy,EntryByname,Now(),@DeletedByID,@DeletedBy from  " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping WHERE  phlebotomistid =@phlebotomistid and localityid=@localityid   ");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sbLog.ToString(),
                   new MySqlParameter("@phlebotomistid", PhelboID), new MySqlParameter("@localityid", Util.GetInt(LocalityId)),
                   new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName));

                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "delete from   " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping where  phlebotomistid=@phlebotomistid and localityid=@localityid",
                    new MySqlParameter("@phlebotomistid", PhelboID), new MySqlParameter("@localityid", Util.GetInt(LocalityId)));
                Tnx.Commit();
                return "3";
            }
            StringBuilder sb = new StringBuilder();
            int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping WHERE   localityid=@LocalityId  and PhlebotomistID=@PhelboID ",
                new MySqlParameter("@LocalityId", LocalityId),
                new MySqlParameter("@PhelboID", PhelboID)
                ));
            if (valDuplicate > 0)
            {
                return "2";
            }
            else
            {
                sb = new StringBuilder();
                sb.Append(" insert into  " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping (localityid,PhlebotomistID,EntryDate,EntryBy,EntryByname) ");
                sb.Append(" values (@localityid,@PhlebotomistID,@EntryDate,@EntryBy,@EntryByname) ");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
                cmd.Parameters.Clear();
                cmd.Parameters.AddWithValue("@localityid", Util.GetInt(LocalityId));
                cmd.Parameters.AddWithValue("@PhlebotomistID", PhelboID);
                cmd.Parameters.AddWithValue("@EntryDate", System.DateTime.Now);

                cmd.Parameters.AddWithValue("@EntryByname", UserInfo.LoginName);
                cmd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmd.ExecuteNonQuery();
                Tnx.Commit();
                return "1";
            }
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
    public static string SaveDropLocation(string LocalityId, string DropLocationID, string isChecked)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (isChecked == "false")
            {
                StringBuilder sbLog = new StringBuilder();
                sbLog.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping_DeleteLog(localityid,droplocationID,PanelId,EntryDate,EntryBy,EntryByname,DeleteDate,DeleteBy,DeleteByname) ");
                sbLog.Append(" SELECT localityid,droplocationID,PanelId,EntryDate,EntryBy,EntryByname,Now(),@DeletedByID,@DeletedBy from  " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping WHERE  droplocationID =@droplocationID and localityid=@localityid   ");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sbLog.ToString(),
                   new MySqlParameter("@droplocationID", DropLocationID.Split('#')[0]), new MySqlParameter("@localityid", LocalityId),
                   new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName));

                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "delete from   " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping where  droplocationID=@droplocationID and localityid=@localityid",
                    new MySqlParameter("@droplocationID", DropLocationID), new MySqlParameter("@localityid", LocalityId));
                Tnx.Commit();

                return "3";
            }
            StringBuilder sb = new StringBuilder();
            int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping WHERE   localityid=@LocalityId  and droplocationID=@DropLocationID ",
                new MySqlParameter("@LocalityId", LocalityId),
                new MySqlParameter("@DropLocationID", DropLocationID.Split('#')[0])));
            if (valDuplicate > 0)
            {
                return "2";
            }
            else
            {
                sb = new StringBuilder();
                sb.Append(" insert into  " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping (localityid,droplocationID,PanelId,EntryDate,EntryBy,EntryByname) ");
                sb.Append(" values (@localityid,@droplocationID,@PanelId,@EntryDate,@EntryBy,@EntryByname) ");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
                cmd.Parameters.Clear();
                cmd.Parameters.AddWithValue("@localityid", LocalityId);
                cmd.Parameters.AddWithValue("@droplocationID", DropLocationID.Split('#')[0]);
                cmd.Parameters.AddWithValue("@PanelId", DropLocationID.Split('#')[1]);
                cmd.Parameters.AddWithValue("@EntryDate", System.DateTime.Now);
                cmd.Parameters.AddWithValue("@EntryByname", UserInfo.LoginName);
                cmd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmd.ExecuteNonQuery();
                Tnx.Commit();
                return "1";
            }
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
    public static string SaveDropLocation1(string LocalityId, string DropLocationID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            string[] DropLocationIDBreak = DropLocationID.Split(',');
            for (int i = 0; i < DropLocationIDBreak.Length; i++)
            {
                int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping WHERE droplocationID=@DropLocationIDBreak and  localityid=@LocalityId ",
                    new MySqlParameter("@LocalityId", LocalityId),
                    new MySqlParameter("@DropLocationIDBreak", DropLocationIDBreak[i].Split('#')[0])));

                if (valDuplicate == 0)
                {
                    sb = new StringBuilder();
                    sb.Append(" insert into  " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping (localityid,droplocationID,PanelId,EntryDate,EntryBy,EntryByname) ");
                    sb.Append(" values (@localityid,@droplocationID,@PanelId,@EntryDate,@EntryBy,@EntryByname) ");
                    MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
                    cmd.Parameters.Clear();
                    cmd.Parameters.AddWithValue("@localityid", LocalityId);
                    cmd.Parameters.AddWithValue("@droplocationID", DropLocationIDBreak[i].Split('#')[0]);
                    cmd.Parameters.AddWithValue("@PanelId", DropLocationIDBreak[i].Split('#')[1]);
                    cmd.Parameters.AddWithValue("@EntryDate", System.DateTime.Now);
                    cmd.Parameters.AddWithValue("@EntryByname", UserInfo.LoginName);
                    cmd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                    cmd.ExecuteNonQuery();
                }
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
    [WebMethod]
    public static string BindRouteTable_Multiple(string CityId, string Routeid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT arm.localityid,arm.Routeid,hc.route,fl.Name,fl.cityid FROM  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping arm  ");
            sb.Append("  INNER JOIN f_locality fl ON fl.ID=arm.localityid and fl.isHomeCollection=1 ");
            sb.Append("  INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_routemaster hc ON hc.Routeid=arm.Routeid  where fl.cityid in({0}) and hc.Routeid=@Routeid  ");
            List<string> pacitem = new List<string>();
            string[] pacitemTags = String.Join(",", CityId).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), pacitemClause,
                new MySqlParameter("Routeid", Routeid)), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(ex);
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string BindRouteTable(string Pincode, string Routeid, string CityId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT arm.localityid,arm.Routeid,hc.route,fl.Name,fl.Pincode FROM  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping arm  ");
            sb.Append("  INNER JOIN f_locality fl ON fl.ID=arm.localityid ");
            sb.Append("  INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_routemaster hc ON hc.Routeid=arm.Routeid  where  fl.cityid in({0})  and fl.Pincode=@Pincode and hc.Routeid=@Routeid order by fl.Pincode,fl.`NAME` ");
            //using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
            //{
            //    return JsonConvert.SerializeObject(dt);
            //}
            List<string> pacitem = new List<string>();
            string[] pacitemTags = String.Join(",", CityId).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), pacitemClause,
                new MySqlParameter("@Pincode", Pincode),
                new MySqlParameter("@Routeid", Routeid)), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
                }
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string RouteRemove_Multiple(string locationid, string routeid)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sbLog = new StringBuilder();
            sbLog.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping_DeleteLog(localityid,Routeid,EntryDate,EntryBy,EntryByname,DeleteDate,DeleteBy,DeleteByname) ");
            sbLog.Append(" SELECT localityid,Routeid,EntryDate,EntryBy,EntryByname,Now(),@DeletedByID,@DeletedBy from  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping WHERE  Routeid =@Routeid and localityid=@localityid   ");


            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sbLog.ToString(),
                 new MySqlParameter("@Routeid", routeid), new MySqlParameter("@localityid", locationid),
                 new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName));


            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "delete from   " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping where  Routeid =@Routeid and localityid=@localityid",
                 new MySqlParameter("@Routeid", routeid), new MySqlParameter("@localityid", locationid));

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
    [WebMethod]
    public static string routeRemove(string locationid, string routeid)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            StringBuilder sbLog = new StringBuilder();
            sbLog.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping_DeleteLog(localityid,Routeid,EntryDate,EntryBy,EntryByname,DeleteDate,DeleteBy,DeleteByname) ");
            sbLog.Append(" SELECT localityid,Routeid,EntryDate,EntryBy,EntryByname,Now(),@DeletedByID,@DeletedBy from  " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping WHERE  Routeid =@Routeid and localityid=@localityid   ");


            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sbLog.ToString(),
                 new MySqlParameter("@Routeid", routeid), new MySqlParameter("@localityid", locationid),
                 new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName));



            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "delete from   " + Util.getApp("HomeCollectionDB") + ".hc_area_route_mapping where  Routeid =@Routeid and localityid=@localityid",
                new MySqlParameter("@Routeid", routeid), new MySqlParameter("@localityid", locationid));
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
    [WebMethod]
    public static string BindPheleboTable(string Pincode, string Pheleboid, string CityId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT rpm.localityid,pm.phlebotomistid,pm.Name AS phlebotomist,fl.Name ,fl.Pincode FROM  " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping rpm  ");
            sb.Append("  INNER JOIN f_locality fl ON fl.ID=rpm.localityid ");
            sb.Append("  INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster pm ON pm.PhlebotomistID=rpm.PhlebotomistID  where  fl.cityid in({0})  and fl.Pincode=@Pincode and pm.PhlebotomistID=@Pheleboid order by fl.Pincode,fl.`NAME` ");

            List<string> pacitem = new List<string>();
            string[] pacitemTags = String.Join(",", CityId).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), pacitemClause,
                new MySqlParameter("@Pincode", Pincode),
                new MySqlParameter("@Pheleboid", Pheleboid)), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
                }
            }


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(ex);
        }
        finally
        {

            con.Close();
            con.Dispose();
        }

    }
    [WebMethod]
    public static string BindDropLocationTable(string Pincode, string Droplocationid, string CityId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT adm.localityid,adm.droplocationID,cm.Centre,cm.`CentreCode`,fl.Name ,fl.Pincode FROM  " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping adm  ");
            sb.Append("  INNER JOIN f_locality fl ON fl.ID=adm.localityid ");
            sb.Append("  INNER JOIN centre_master cm ON cm.centreid=adm.droplocationID  where  fl.cityid in({0})  and fl.Pincode=@Pincode and cm.centreid=@Droplocationid order by fl.Pincode,fl.`NAME` ");

            List<string> pacitem = new List<string>();
            string[] pacitemTags = String.Join(",", CityId).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), pacitemClause,
                new MySqlParameter("@Pincode", Pincode),
                new MySqlParameter("@Droplocationid", Droplocationid)), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
                }
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(ex);
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string pheleboRemove(string locationid, string pheleboid)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sbLog = new StringBuilder();
            sbLog.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping_DeleteLog(localityid,PhlebotomistID,EntryDate,EntryBy,EntryByname,DeleteDate,DeleteBy,DeleteByname) ");
            sbLog.Append(" SELECT localityid,PhlebotomistID,EntryDate,EntryBy,EntryByname,Now(),@DeletedByID,@DeletedBy from  " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping WHERE  phlebotomistid =@phlebotomistid and localityid=@localityid   ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sbLog.ToString(),
               new MySqlParameter("@phlebotomistid", pheleboid), new MySqlParameter("@localityid", locationid),
               new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName));

            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "delete from   " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping where  phlebotomistid=@phlebotomistid and localityid=@localityid",
               new MySqlParameter("@phlebotomistid", pheleboid), new MySqlParameter("@localityid", locationid));
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
    [WebMethod]
    public static string DropLocationRemove(string locationid, string DropLocationid)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sbLog = new StringBuilder();
            sbLog.Append(" INSERT INTO  " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping_DeleteLog(localityid,droplocationID,PanelId,EntryDate,EntryBy,EntryByname,DeleteDate,DeleteBy,DeleteByname) ");
            sbLog.Append(" SELECT localityid,droplocationID,PanelId,EntryDate,EntryBy,EntryByname,Now(),@DeletedByID,@DeletedBy from  " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping WHERE  droplocationID =@droplocationID and localityid=@localityid   ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sbLog.ToString(),
               new MySqlParameter("@droplocationID", DropLocationid), new MySqlParameter("@localityid", Util.GetInt(locationid)),
               new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName));

            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "delete from   " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping where  droplocationID=@droplocationID and localityid=@localityid",
                new MySqlParameter("@droplocationID", DropLocationid), new MySqlParameter("@localityid", Util.GetInt(locationid)));
            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Dispose();
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

}
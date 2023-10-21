using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Linq;

public partial class Design_HomeCollection_HomeCollectionDelayTatMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {



    }

    [WebMethod(EnableSession = true)]
    public static string bindCenterType()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT ID,Type1 from centre_type1master Where IsActive=1 order by Type1 "))
            return JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string bindState(string BusinessZoneID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] pacitemTags = String.Join(",", BusinessZoneID).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT ID,State FROM state_master WHERE BusinessZoneID IN({0}) AND IsActive=1 ORDER BY State", pacitemClause), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return Util.getJson(dt);
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.getJson(ex);
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
            string[] pacitemTags = String.Join(",", StateID).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT ID,City FROM `city_master` WHERE stateID IN({0})", pacitemClause), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                        return JsonConvert.SerializeObject(dt);
                    else
                        return null;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.getJson(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod(EnableSession = true)]
    public static string BindData(string CentrTypeId, string StateId, string TagprocessingLabID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        StringBuilder sb = new StringBuilder();
        con.Open();
        try
        {
            DataTable dt = new DataTable();
            string Query = string.Empty;
            if (CentrTypeId != string.Empty || StateId != string.Empty)
            {
                sb.Append("SELECT CentreID,Centre FROM centre_master WHERE isActive='1'");
                if (StateId != string.Empty && CentrTypeId == string.Empty)
                    sb.Append(" AND StateID IN({0}) ");
                else if (StateId != string.Empty && CentrTypeId != string.Empty)
                    sb.Append(" AND StateID IN({0}) AND Type1Id IN({1}) ");
                else if (StateId == string.Empty && CentrTypeId != string.Empty)
                    sb.Append(" AND Type1Id IN({0}) ");

                if (TagprocessingLabID != "0" && TagprocessingLabID != "-1" && TagprocessingLabID != "null")
                    sb.Append(" and TagProcessingLabID=@TagprocessingLabID ");
            }
            else
                sb.Append("SELECT CentreID,Centre FROM centre_master WHERE isActive=1");



            if (CentrTypeId != string.Empty || StateId != string.Empty)
            {
                string[] CentrTypeTags = CentrTypeId.Split(',');
                string[] CentrTypeParamNames = CentrTypeTags.Select((s, i) => "@tag" + i).ToArray();
                string CentrTypeClause = string.Join(", ", CentrTypeParamNames);

                string[] StateIdTags = StateId.Split(',');
                string[] StateIdParamNames = StateIdTags.Select((s, i) => "@tags" + i).ToArray();
                string StateIdClause = string.Join(", ", StateIdParamNames);

                if (StateId != string.Empty && CentrTypeId == string.Empty)
                    Query = string.Format(sb.ToString(), StateIdClause);
                else if (StateId != string.Empty && CentrTypeId != string.Empty)
                    Query = string.Format(sb.ToString(), StateIdClause, CentrTypeClause);
                else if (StateId == string.Empty && CentrTypeId != string.Empty)
                    Query = string.Format(sb.ToString(), CentrTypeClause);
                using (MySqlDataAdapter da = new MySqlDataAdapter(Query, con))
                {
                    for (int i = 0; i < StateIdParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(StateIdParamNames[i], StateIdTags[i]);
                    }
                    for (int i = 0; i < CentrTypeParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(CentrTypeParamNames[i], CentrTypeTags[i]);
                    }
                    da.SelectCommand.Parameters.AddWithValue("@TagprocessingLabID", TagprocessingLabID);
                    da.Fill(dt);
                }
            }
            else
            {
                Query = sb.ToString();
                using (MySqlDataAdapter da = new MySqlDataAdapter(Query, con))
                {
                    da.Fill(dt);
                }
            }
            using (dt as IDisposable)
            {

                dt.Columns.Add("Level1ID");
                dt.Columns.Add("Level1");
                dt.Columns.Add("Level2ID");
                dt.Columns.Add("Level2");
                dt.Columns.Add("Level3ID");
                dt.Columns.Add("Level3");
                StringBuilder sb1 = new StringBuilder();
                sb1.Append(" SELECT cm.CentreID,cm.Centre ,IFNULL(CAST(GROUP_CONCAT(em.Employee_ID) AS CHAR),'') LevelID,CAST(GROUP_CONCAT(CONCAT(em.Title,' ', em.NAME)) AS CHAR) LevelName,LevelName as Level FROM centre_master cm ");
                sb1.Append(" LEFT JOIN  hc_delaycheckin_centre_mapping cc ON cm.CentreID=cc.CentreID  AND cc.IsActive=1 ");
                sb1.Append(" LEFT JOIN employee_master em  ON cc.`EmployeeID` = em.Employee_ID   GROUP BY cm.CentreID,LevelName ");

                using (DataTable dt2 = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb1.ToString()).Tables[0])
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        var level1 = "Level1";
                        var level2 = "Level2";
                        var level3 = "Level3";
                        DataRow[] erow1 = dt2.Select("CentreID = '" + row["CentreID"] + "' AND Level='" + level1 + "'");
                        DataRow[] erow2 = dt2.Select("CentreID = '" + row["CentreID"] + "' AND Level='" + level2 + "'");
                        DataRow[] erow3 = dt2.Select("CentreID = '" + row["CentreID"] + "' AND Level='" + level3 + "'");
                        if (erow1.Length > 0)
                        {
                            row["Level1"] = erow1[0]["LevelName"];
                            row["Level1ID"] = erow1[0]["LevelID"];
                        }
                        if (erow2.Length > 0)
                        {
                            row["Level2"] = erow2[0]["LevelName"];
                            row["Level2ID"] = erow2[0]["LevelID"];
                        }
                        if (erow3.Length > 0)
                        {
                            row["Level3"] = erow3[0]["LevelName"];
                            row["Level3ID"] = erow3[0]["LevelID"];
                        }
                    }
                    return Util.getJson(dt);
                }
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.getJson(ex);
        }
        finally
        {
            if (con.State == ConnectionState.Open)
            {
                con.Close();
                con.Dispose();
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindCentre(string CityID, string BusinessZoneID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            string Query = string.Empty;
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT cm.CentreID,cm.Centre FROM centre_master cm WHERE cm.isactive=1 AND  cm.BusinessZoneID IN ({0})  ");
            if (CityID != string.Empty)
                sb.Append(" AND cm.CityID IN({1}) ");
            sb.Append("   ORDER BY cm.Centre ");

            string[] BusinessZoneIDTags = BusinessZoneID.Split(',');
            string[] BusinessZoneIDParamNames = BusinessZoneIDTags.Select((s, i) => "@tag" + i).ToArray();
            string BusinessZoneIDClause = string.Join(", ", BusinessZoneIDParamNames);

            string[] CityIDTags = CityID.Split(',');
            string[] CityIDParamNames = CityIDTags.Select((s, i) => "@tags" + i).ToArray();
            string CityIDClause = string.Join(", ", CityIDParamNames);

            if (CityID != string.Empty)
                Query = string.Format(sb.ToString(), BusinessZoneIDClause, CityIDClause);
            else
                Query = string.Format(sb.ToString(), BusinessZoneIDClause);

            using (MySqlDataAdapter da = new MySqlDataAdapter(Query, con))
            {
                if (CityID != string.Empty)
                {
                    for (int i = 0; i < CityIDParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(CityIDParamNames[i], CityIDTags[i]);
                    }
                }
                for (int i = 0; i < BusinessZoneIDParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(BusinessZoneIDParamNames[i], BusinessZoneIDTags[i]);
                }
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                        return JsonConvert.SerializeObject(dt);
                    else
                        return null;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "1#" + ex.Message;
        }
        finally
        {            
                con.Close();
                con.Dispose();
        }
    }
    [WebMethod]
    public static string SearchEmployee(string query, string EmpList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (EmpList == string.Empty)
                EmpList = "''";
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT HospCode,Employee_ID as value,CONCAT(House_No,'~', CONCAT(Title,' ', NAME)) AS label,Email,Mobile FROM employee_master WHERE IsActive='1' AND Employee_ID NOT IN({0}) AND name like '%"+query+"%' "); ;

            List<string> pacitem = new List<string>();
            string[] pacitemTags = String.Join(",", EmpList).Split(',');
            string[] pacitemParamNames = pacitemTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string pacitemClause = string.Join(", ", pacitemParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), pacitemClause), con))
            {
                for (int i = 0; i < pacitemParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                }
                //da.SelectCommand.Parameters.AddWithValue("@query", query);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                        return JsonConvert.SerializeObject(dt);
                    else
                        return null;
                }
            }
        }
        catch (Exception Ex)
        {
            return JsonConvert.SerializeObject(Ex);

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string Save(string Data, string CenterID)
    {
        EmpData obj = new EmpData();
        obj = JsonConvert.DeserializeObject<EmpData>(Data);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            var Center = CenterID.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            for (int i = 0; i < Center.Length; i++)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO   hc_delaycheckin_centre_mapping(`CentreID`,`EmployeeID`,`EntryByName`,`EntryByID`,`LevelName`,LevelID) ");
                sb.Append(" VALUES (@CentreID,@EmployeeID,@EntryByName,@EntryByID,@LevelName,@LevelID) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@CentreID", Center[i]),
                            new MySqlParameter("@EmployeeID", obj.EmpID),
                            new MySqlParameter("@EntryByName", UserInfo.LoginName),
                            new MySqlParameter("@EntryByID", UserInfo.ID),
                            new MySqlParameter("@LevelName", obj.Lavel),
                            new MySqlParameter("@LevelID", obj.Lavel.Remove(0, 5)));
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string GetEmpID(string ID, string Level, string CenterID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT cc.ID,cm.`CentreID`,cm.`StateID`,cm.`CityID`,cm.`BusinessZoneID`, HospCode,em.Employee_ID ,CONCAT(House_No,'~', CONCAT(Title,' ', NAME)) EmpName,em.Email,em.Mobile ");
            sb.Append(" FROM   hc_delaycheckin_centre_mapping cc ");
            sb.Append(" INNER JOIN employee_master em  ON cc.`EmployeeID` = em.Employee_ID ");
            sb.Append(" INNER JOIN `centre_master` cm ON cc.`CentreID`=cm.`CentreID` ");
            sb.Append(" WHERE cc.CentreID=@CenterID AND em.Employee_ID=@Employee_ID AND cc.`Lavel`=@Lavel AND cc.IsActive=1 AND em.IsActive=1");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@CenterID", CenterID),
                                              new MySqlParameter("@Employee_ID", ID),
                                              new MySqlParameter("@Lavel", Level)).Tables[0])
                return JsonConvert.SerializeObject(dt);
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

    [WebMethod]
    public static string GetCenter(string CenterID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT cm.`CentreID`,cm.`StateID`,cm.`CityID`,cm.`BusinessZoneID` from `centre_master` cm WHERE cm.CentreID=@CentreID",
                                              new MySqlParameter("@CentreID", CenterID)).Tables[0])
                return JsonConvert.SerializeObject(dt);
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
    public static string bindDelaycheckin_Master()
    {
        using (DataTable dttime = StockReports.GetDataTable(" SELECT ID,Level1Time,Level2Time,Level3Time FROM  hc_delaycheckin_Master WHERE  IsActive=1 "))
                                               return JsonConvert.SerializeObject(dttime);
    }
    public class EmpData
    {
        public string EmpID { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Mobile { get; set; }
        public string Lavel { get; set; }
        public string SubCategoryID { get; set; }
        public string IsEditMobile { get; set; }
        public string IsEditEmail { get; set; }
        public string EnquiryID { get; set; }
        public int ReopenTicket { get; set; }
        public int EmailCCLevel2 { get; set; }
        public int EmailCCLevel3 { get; set; }
    }
    [WebMethod]
    public static string BindTagEmployeeDetail(string CenterID, string Level)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT cc.ID,em.Employee_ID ,CONCAT(Title,' ', NAME)EmpName,em.Email,em.Mobile,cm.`CentreID`,cm.`StateID`,cm.`CityID`,cm.`BusinessZoneID` ");
            sb.Append(" FROM  hc_delaycheckin_centre_mapping cc ");
            sb.Append(" INNER JOIN employee_master em  ON cc.`EmployeeID` = em.Employee_ID ");
            sb.Append(" INNER JOIN `centre_master` cm ON cc.`CentreID`=cm.`CentreID` ");
            sb.Append(" WHERE cc.CentreID=@CenterID  AND cc.`LevelName`=@Lavel and em.IsActive=1 AND cc.IsActive=1");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@CenterID", CenterID),
                                              new MySqlParameter("@Lavel", Level)).Tables[0])
                return JsonConvert.SerializeObject(dt);
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
    [WebMethod]
    public static string removeTagEmployeeDetail(string ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE  hc_delaycheckin_centre_mapping SET IsActive =0 WHERE ID=@ID",
                        new MySqlParameter("@ID", ID));

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
    public static string UpdateTime(string ID, string Level1Time, string Level2Time, string Level3Time)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE  hc_delaycheckin_Master SET IsActive =0,UpdatedBy =@UpdatedBy,UpdatedID =@UpdatedID,UpdatedDate =now() WHERE ID=@ID",               
                        new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                        new MySqlParameter("@UpdatedID", UserInfo.ID),
                        new MySqlParameter("@ID", ID));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into  hc_delaycheckin_Master(Level1Time,Level2Time,Level3Time,CreatedBy,CreatedID,CreatedDate)  VALUES (@Level1Time,@Level2Time,@Level3Time,@CreatedBy,@CreatedID,now())",
                        new MySqlParameter("@Level1Time", Level1Time),
                        new MySqlParameter("@Level2Time", Level2Time),
                        new MySqlParameter("@Level3Time", Level3Time),
                        new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                        new MySqlParameter("@CreatedID", UserInfo.ID));
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string DefaultSave(string Data)
    {
        EmpData obj = new EmpData();
        obj = JsonConvert.DeserializeObject<EmpData>(Data);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO   hc_delaycheckin_centre_mapping(`CentreID`,`EmployeeID`,`EntryByName`,`EntryByID`,`LevelName`,LevelID) ");
            sb.Append(" VALUES (@CentreID,@EmployeeID,@EntryByName,@EntryByID,@LevelName,@LevelID) ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@CentreID", "0"),
                        new MySqlParameter("@EmployeeID", obj.EmpID),
                        new MySqlParameter("@EntryByName", UserInfo.LoginName),
                        new MySqlParameter("@EntryByID", UserInfo.ID),
                        new MySqlParameter("@LevelName", obj.Lavel),
                        new MySqlParameter("@LevelID", obj.Lavel.Remove(0, 5)));
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string defaultBindTagEmployeeDetail(string CenterID, string Level)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cc.ID,em.Employee_ID ,CONCAT(Title,' ', NAME)EmpName,em.Email,em.Mobile ");
        sb.Append(" FROM   hc_delaycheckin_centre_mapping cc ");
        sb.Append(" INNER JOIN employee_master em  ON cc.`EmployeeID` = em.Employee_ID ");
        sb.Append(" WHERE cc.CentreID=@CenterID  AND cc.`LevelName`=@Lavel AND em.IsActive=1 AND cc.IsActive=1");
        using (DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, sb.ToString(),
                                          new MySqlParameter("@CenterID", CenterID),
                                          new MySqlParameter("@Lavel", Level)).Tables[0])
            return JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public static string defaultBindData()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            DataTable dt = new DataTable();
            dt.Columns.Add("Level1ID");
            dt.Columns.Add("Level1");
            dt.Columns.Add("Level2ID");
            dt.Columns.Add("Level2");
            dt.Columns.Add("Level3ID");
            dt.Columns.Add("Level3");

            StringBuilder sb1 = new StringBuilder();
            sb1.Append("SELECT IFNULL(CAST(GROUP_CONCAT(em.Employee_ID) AS CHAR),'') LevelID, ");
            sb1.Append("CAST(GROUP_CONCAT(CONCAT(em.Title,' ', em.NAME)) AS CHAR) LevelName,LevelName Lavel FROM  hc_delaycheckin_centre_mapping cc ");
            sb1.Append("LEFT JOIN employee_master em  ON cc.`EmployeeID` = em.Employee_ID WHERE cc.IsActive=1 and CentreID=0  GROUP BY LevelName ");
            DataTable dt1 = StockReports.GetDataTable(sb1.ToString());

            DataRow row = dt.NewRow();
            var level1 = "Level1";
            var level2 = "Level2";
            var level3 = "Level3";
            DataRow[] erow1 = dt1.Select("Lavel='" + level1 + "'");
            DataRow[] erow2 = dt1.Select("Lavel='" + level2 + "'");
            DataRow[] erow3 = dt1.Select("Lavel='" + level3 + "'");
            if (erow1.Length > 0)
            {
                row["Level1"] = erow1[0]["LevelName"];
                row["Level1ID"] = erow1[0]["LevelID"];
            }
            if (erow2.Length > 0)
            {
                row["Level2"] = erow2[0]["LevelName"];
                row["Level2ID"] = erow2[0]["LevelID"];
            }
            if (erow3.Length > 0)
            {
                row["Level3"] = erow3[0]["LevelName"];
                row["Level3ID"] = erow3[0]["LevelID"];
            }
            dt.Rows.Add(row);
            return Util.getJson(dt);
        }
        catch (Exception Ex)
        {
            return Util.getJson(Ex);
        }
    }

    [WebMethod]
    public static string defaultremoveTagEmployeeDetail(string ID)
    {
        try
        {
            MySqlHelper.ExecuteNonQuery(Util.GetMySqlCon(), CommandType.Text, "UPDATE  hc_delaycheckin_centre_mapping SET IsActive =0 WHERE ID=@ID",
                        new MySqlParameter("@ID", ID));

            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

    }
  
    [WebMethod]
    public static string bindtagprocessinglabLoad(string Type1, string btype, string StateID, string ZoneId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string Query = string.Empty;
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT CentreID,CONCAt(CentreCode,'~',Centre)Centre,type1 ");
            sb.Append(" FROM centre_master cm where isActive=1 ");
            if (ZoneId != string.Empty && StateID == string.Empty)
                sb.Append(" AND BusinessZoneID IN({0})");
            else if (ZoneId != string.Empty && StateID != string.Empty)
            {
                sb.Append(" AND BusinessZoneID IN({0}) AND cm.StateID IN({1}) ");
            }
            else if (ZoneId == string.Empty && StateID != string.Empty)
            {
                sb.Append("  AND cm.StateID IN({0})");
            }
            if (btype != "0")
                sb.Append(" and coco_foco=@btype ");
            sb.Append(" AND cm.CentreID=cm.TagProcessingLabID order by Centre ");


            string[] ZoneIdTags = ZoneId.Split(',');
            string[] ZoneIdParamNames = ZoneIdTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string ZoneIdClause = string.Join(", ", ZoneIdParamNames);

            string[] StateIDTags = StateID.Split(',');
            string[] StateIDParamNames = StateIDTags.Select(
              (s, i) => "@tags" + i).ToArray();
            string StateIDClause = string.Join(", ", StateIDParamNames);




            if (ZoneId != string.Empty && StateID == string.Empty)
            {
                Query = string.Format(sb.ToString(), ZoneIdClause);
            }
            else if (ZoneId != string.Empty && StateID != string.Empty)
            {
                Query = string.Format(sb.ToString(), ZoneIdClause, StateIDClause);
            }
            else if (ZoneId == string.Empty && StateID != string.Empty)
            {
                Query = string.Format(sb.ToString(), StateIDClause);
            }
            using (MySqlDataAdapter da = new MySqlDataAdapter(Query, con))
            {
                if (StateID != string.Empty)
                {
                    for (int i = 0; i < StateIDParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(StateIDParamNames[i], StateIDTags[i]);
                    }
                }
                if (ZoneId != string.Empty)
                {
                    for (int i = 0; i < ZoneIdParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(ZoneIdParamNames[i], ZoneIdTags[i]);
                    }
                }
                da.SelectCommand.Parameters.AddWithValue("@btype", btype);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                        return JsonConvert.SerializeObject(dt);
                    else
                        return null;
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
    public static string bindtypedb()
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT DISTINCT type1id ID,type1 TEXT FROM centre_master ORDER BY type1id "));
    }
}
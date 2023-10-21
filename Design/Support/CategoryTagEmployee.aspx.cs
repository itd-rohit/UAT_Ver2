using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;

public partial class Design_Support_CategoryTagEmployee : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        hdncategoryID.Value = Request.QueryString[0].ToString();//Common.DecryptRijndael(Request.QueryString["ID"].ToString());
        lblSubCategoryID.Text = Request.QueryString[0].ToString();//Common.DecryptRijndael(Request.QueryString["ID"].ToString());
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string InqSubCategory = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT CategoryName FROM ticketing_category_master WHERE ID=@ID AND IsActive=1 ",
               new MySqlParameter("@ID", lblSubCategoryID.Text.Trim())));
            if (InqSubCategory != string.Empty)
            {
                lblCategory.Text = InqSubCategory.ToString();
            }
        }
        catch (Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindBusinessZone()
    {
        using (DataTable dt = StockReports.GetDataTable(" SELECT BusinessZoneID,BusinessZoneName FROM BusinessZone_master WHERE IsActive=1 ORDER BY BusinessZoneName "))
        return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string bindCenterType()
    {
        using (DataTable dt = StockReports.GetDataTable(" SELECT ID,Type1 from centre_type1master Where IsActive=1 order by Type1 "))
        return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string bindState(string BusinessZoneID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] BusinessZoneTags = BusinessZoneID.Split(',');
            string[] BusinessZoneNames = BusinessZoneTags.Select((s, i) => "@tag" + i).ToArray();
            string BusinessZoneClause = string.Join(", ", BusinessZoneNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT ID,State FROM state_master WHERE BusinessZoneID IN({0}) AND IsActive=1 ORDER BY State", BusinessZoneClause), con))
            {
                for (int i = 0; i < BusinessZoneNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(BusinessZoneNames[i], BusinessZoneTags[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                        return Util.getJson(dt);
                    else
                        return null;
                }
            }
        }
        catch (Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
            return null;
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
            string[] StateTags = StateID.Split(',');
            string[] StateNames = StateTags.Select((s, i) => "@tag" + i).ToArray();
            string StateClause = string.Join(", ", StateNames);

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT ID,City FROM city_master WHERE stateID IN({0})", StateClause), con))
            {
                for (int i = 0; i < StateNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(StateNames[i], StateTags[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                        return Util.getJson(dt);
                    else
                        return null;
                }
            }
        }
        catch (Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindData(string CentrTypeId, string StateId, string SubCategoryID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (CentrTypeId != "null" || CentrTypeId != string.Empty || StateId != string.Empty || StateId != "Null")
                sb.Append(" SELECT CentreID,Centre FROM centre_master WHERE isActive=1 ORDER BY Centre");
            else
                sb.Append("SELECT CentreID,Centre FROM centre_master WHERE isActive=1 ORDER BY Centre");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
            {
                dt.Columns.Add("Level1ID");
                dt.Columns.Add("Level1");
                dt.Columns.Add("Level2ID");
                dt.Columns.Add("Level2");
                dt.Columns.Add("Level3ID");
                dt.Columns.Add("Level3");

                sb = new StringBuilder();
                sb.Append(" SELECT cm.CentreID,cm.Centre ,IFNULL(CAST(GROUP_CONCAT(em.Employee_ID) AS CHAR),'') LevelID,CAST(GROUP_CONCAT(CONCAT(em.Title,' ', em.NAME)) AS CHAR) LevelName,Lavel FROM centre_master cm ");
                sb.Append(" LEFT JOIN ticketing_categoryemployee cc ON cm.CentreID=cc.CentreID  AND cc.IsActive=1 ");
                sb.Append(" LEFT JOIN employee_master em  ON cc.EmployeeID = em.Employee_ID where cc.CategoryID=@CategoryID GROUP BY cm.CentreID,Lavel ");
                using (DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@CategoryID", SubCategoryID)).Tables[0])
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        string level1 = "Level1";
                        string level2 = "Level2";
                        string level3 = "Level3";
                        DataRow[] erow1 = dt1.Select(string.Format("CentreID = '{0}' AND Lavel='{1}'", row["CentreID"], level1));
                        DataRow[] erow2 = dt1.Select(string.Format("CentreID = '{0}' AND Lavel='{1}'", row["CentreID"], level2));
                        DataRow[] erow3 = dt1.Select(string.Format("CentreID = '{0}' AND Lavel='{1}'", row["CentreID"], level3));
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
        catch (Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindCentre(string CityID, string BusinessZoneID)
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT cm.CentreID,cm.Centre FROM centre_master cm WHERE cm.isactive=1 ORDER BY cm.Centre "))
        {
            if (dt.Rows.Count > 0)
                return Util.getJson(dt);
            else
                return null;
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

            string[] EmpTags = EmpList.Split(',');
            string[] EmpNames = EmpTags.Select((s, i) => "@tag" + i).ToArray();
            string EmpClause = string.Join(", ", EmpNames);

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT HospCode,Employee_ID as value,CONCAT(CONCAT(Title,' ', NAME),' / ',Employee_ID,' & ',IFNULL(House_No,'')) AS label,Email,Mobile");
            sb.Append(" FROM employee_master WHERE IsActive='1' AND Employee_ID NOT IN({0}) AND Name LIKE @query ");

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), EmpClause), con))
            {
                for (int i = 0; i < EmpNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(EmpNames[i], EmpTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@query", string.Format("%{0}%", query));

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
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string Save(EmpData obj, string CenterID)
    {
        //EmpData obj = new EmpData();
        //obj = JsonConvert.DeserializeObject<EmpData>(Data);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            if (obj.EnquiryID != string.Empty)
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM ticketing_categoryemployee WHERE ID=@EnquiryID ",
                    new MySqlParameter("@EnquiryID", obj.EnquiryID)));
                if (count > 0)
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE ticketing_categoryemployee SET IsActive=@IsActive,UpdatedBy=@UpdatedBy,UpdatedID=@UpdatedID,UpdatedDate=@UpdatedDate");
                    sb.Append(" WHERE ID=@EnquiryID ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@IsActive", "0"),
                        new MySqlParameter("@EnquiryID", obj.EnquiryID),
                        new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                        new MySqlParameter("@UpdatedID", UserInfo.ID),
                        new MySqlParameter("@UpdatedDate", DateTime.Now)
                        );
                }
            }
            string[] Center = CenterID.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            for (int i = 0; i < Center.Length; i++)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO  ticketing_categoryemployee(CentreID,EmployeeID,CategoryID,CreatedBy,CreatedID,Lavel,LevelID,EmailCCLevel2,EmailCCLevel3) ");
                sb.Append(" VALUES (@CentreID,@EmployeeID,@CategoryID,@CreatedBy,@CreatedID,@Level,@LevelID,@EmailCCLevel2,@EmailCCLevel3) ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@CentreID", Center[i]),
                    new MySqlParameter("@EmployeeID", obj.EmpID),
                    new MySqlParameter("@CategoryID", obj.SubCategoryID),
                    new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                    new MySqlParameter("@CreatedID", UserInfo.ID),
                    new MySqlParameter("@Level", obj.Lavel),
                    new MySqlParameter("@LevelID", obj.Lavel.Remove(0, 5)),
                    new MySqlParameter("@EmailCCLevel2", obj.EmailCCLevel2),
                    new MySqlParameter("@EmailCCLevel3", obj.EmailCCLevel3));
            }
            sb = new StringBuilder();
            sb.Append("UPDATE employee_master SET Mobile=@Mobile, Email=@Email,ReopenTicket=@ReopenTicket WHERE Employee_ID=@Employee_ID");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@Mobile", obj.Mobile),
                 new MySqlParameter("@Email", obj.Email),
                 new MySqlParameter("@ReopenTicket", obj.ReopenTicket),
                 new MySqlParameter("@Employee_ID", obj.EmpID));
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
            sb.Append(" SELECT cc.ID,cm.CentreID,cm.StateID,cm.CityID,cm.BusinessZoneID, HospCode,em.Employee_ID ,CONCAT(House_No,'~', CONCAT(Title,' ', NAME)) EmpName,em.Email,em.Mobile ");
            sb.Append(" FROM  ticketing_categoryemployee cc ");
            sb.Append(" INNER JOIN employee_master em  ON cc.EmployeeID = em.Employee_ID ");
            sb.Append(" INNER JOIN centre_master cm ON cc.CentreID=cm.CentreID ");
            sb.Append(" WHERE cc.CentreID=@CenterID AND em.Employee_ID=@Employee_ID AND cc.Lavel=@Lavel AND cc.IsActive=@InqueryActive AND em.IsActive=@EmpActive");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@CenterID", CenterID),
                           new MySqlParameter("@Employee_ID", ID),
                           new MySqlParameter("@Lavel", Level),
                           new MySqlParameter("@InqueryActive", "1"),
                           new MySqlParameter("@EmpActive", "1")
                           ).Tables[0])
                return Util.getJson(dt);
        }
        catch (Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
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
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT cm.CentreID,cm.StateID,cm.CityID,cm.BusinessZoneID");
            sb.Append(" from centre_master cm WHERE cm.CentreID=@CentreID");
           using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@CentreID", CenterID)).Tables[0])
            return Util.getJson(dt);
        }
        catch (Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
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
    public static string BindTagEmployeeDetail(string CenterID, string Level, int SubCategoryID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT cc.ID,em.Employee_ID ,CONCAT(Title,' ', NAME)EmpName,em.Email,em.Mobile,cm.CentreID,cm.BusinessZoneID,em.ReopenTicket,cc.EmailCCLevel2,cc.EmailCCLevel3 ");
            sb.Append(" FROM  ticketing_categoryemployee cc ");
            sb.Append(" INNER JOIN employee_master em  ON cc.EmployeeID = em.Employee_ID ");
            sb.Append(" INNER JOIN centre_master cm ON cc.CentreID=cm.CentreID ");
            sb.Append(" WHERE cc.CentreID=@CenterID  AND cc.Lavel=@Lavel AND cc.CategoryID=@CategoryID AND em.IsActive=@emActive AND cc.IsActive=@categoryActive");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@CenterID", CenterID),
                           new MySqlParameter("@Lavel", Level),
                           new MySqlParameter("@CategoryID", SubCategoryID),
                           new MySqlParameter("@emActive", "1"),
                           new MySqlParameter("@categoryActive", "1")
                           ).Tables[0])
            return Util.getJson(dt);
        }
        catch (Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
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
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE ticketing_categoryemployee SET IsActive =0 WHERE ID=@ID",
                new MySqlParameter("@ID", ID));
            return "1";
        }
        catch (Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string DefaultSave(EmpData Data)
    {
       

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            if (Data.EnquiryID != string.Empty)
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM ticketing_categoryemployee WHERE ID=@EnquiryID ",
                    new MySqlParameter("@EnquiryID", Data.EnquiryID)));
                if (count > 0)
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE ticketing_categoryemployee SET employeeID=@employeeID,EmailCCLevel2=@EmailCCLevel2,EmailCCLevel3=@EmailCCLevel3,IsActive=@IsActive,UpdatedBy=@UpdatedBy,UpdatedID=@UpdatedID,UpdatedDate=@UpdatedDate");
                    sb.Append(" WHERE ID=@EnquiryID ");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@employeeID", Data.EmpID),
                       new MySqlParameter("@EmailCCLevel2", Data.EmailCCLevel2),
                       new MySqlParameter("@EmailCCLevel3", Data.EmailCCLevel3),
                       new MySqlParameter("@IsActive", "1"),
                       new MySqlParameter("@EnquiryID", Data.EnquiryID),
                       new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                       new MySqlParameter("@UpdatedID", UserInfo.ID),
                       new MySqlParameter("@UpdatedDate", DateTime.Now)
                        );
                }
            }
            else
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO  ticketing_categoryemployee (CentreID,EmployeeID,CategoryID,CreatedBy,CreatedID,Lavel,LevelID,EmailCCLevel2,EmailCCLevel3) ");
                sb.Append("  VALUES (@CentreID,@EmployeeID,@CategoryID,@CreatedBy,@CreatedID,@Level,@LevelID,@EmailCCLevel2,@EmailCCLevel3) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@CentreID", "0"),
                    new MySqlParameter("@EmployeeID", Data.EmpID),
                    new MySqlParameter("@CategoryID", Util.GetInt(Data.SubCategoryID)),
                    new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                    new MySqlParameter("@CreatedID", UserInfo.ID),
                    new MySqlParameter("@Level", Data.Lavel),
                    new MySqlParameter("@LevelID", Util.GetInt(Data.Lavel.Remove(0, 5))),
                    new MySqlParameter("@EmailCCLevel2", Data.EmailCCLevel2),
                    new MySqlParameter("@EmailCCLevel3", Data.EmailCCLevel3));
            }

            sb = new StringBuilder();
            sb.Append("UPDATE employee_master SET Mobile=@Mobile, Email=@Email,ReopenTicket=@ReopenTicket WHERE Employee_ID=@Employee_ID");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@Mobile", Data.Mobile),
                 new MySqlParameter("@Email", Data.Email),
                 new MySqlParameter("@ReopenTicket", Data.ReopenTicket),
                 new MySqlParameter("@Employee_ID", Data.EmpID));

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
    public static string defaultBindTagEmployeeDetail(string CenterID, string Level, int SubCategoryID)
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT cc.ID,em.Employee_ID ,CONCAT(Title,' ', NAME)EmpName,em.Email,em.Mobile,em.ReopenTicket,cc.EmailCCLevel2,cc.EmailCCLevel3 ");
            sb.Append(" FROM  ticketing_categoryemployee cc ");
            sb.Append(" INNER JOIN employee_master em  ON cc.EmployeeID = em.Employee_ID ");
            sb.Append(" WHERE cc.CentreID=@CenterID  AND cc.Lavel=@Lavel AND cc.CategoryID=@CategoryID AND em.IsActive=@emActive AND cc.IsActive=@categoryActive");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                          new MySqlParameter("@CenterID", CenterID),
                          new MySqlParameter("@Lavel", Level),
                          new MySqlParameter("@CategoryID", SubCategoryID),
                          new MySqlParameter("@emActive", "1"),
                          new MySqlParameter("@categoryActive", "1")
                          ).Tables[0])
                return Util.getJson(dt);
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

    [WebMethod(EnableSession = true)]
    public static string defaultBindData(string SubCategoryID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
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
            sb1.Append("CAST(GROUP_CONCAT(CONCAT(em.Title,' ', em.NAME)) AS CHAR) LevelName,Lavel FROM ticketing_categoryemployee cc ");
            sb1.Append("LEFT JOIN employee_master em  ON cc.EmployeeID = em.Employee_ID WHERE cc.IsActive=1 and CentreID=0 ");
            sb1.Append(" and cc.CategoryID=@CategoryID GROUP BY Lavel ");
            using (DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb1.ToString(),
                   new MySqlParameter("@CategoryID", SubCategoryID)).Tables[0])
            {
                DataRow row = dt.NewRow();
                string level1 = "Level1";
                string level2 = "Level2";
                string level3 = "Level3";
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
        }
        catch (Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string defaultremoveTagEmployeeDetail(string ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE ticketing_categoryemployee SET IsActive =0 WHERE ID=@ID",
                new MySqlParameter("@ID", ID));

            return "1";
        }
        catch (Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
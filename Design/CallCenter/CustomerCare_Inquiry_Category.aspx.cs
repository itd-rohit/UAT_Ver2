using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_CallCenter_CustomerCare_Inquiry_Category : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        hdncategoryID.Value = Util.GetString(Request.QueryString["Id"]);
        lblSubCategoryID.Text = Util.GetString(Request.QueryString["Id"]);

        string InqSubCategory = StockReports.ExecuteScalar("SELECT SubCategoryName FROM `cutomercare_subcategory_master` WHERE ID='" + lblSubCategoryID.Text.Trim() + "' AND IsActive=1");
        if (InqSubCategory != string.Empty)
        {
            lblCategory.Text = InqSubCategory.ToString();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindCenterType()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,Type1 from centre_type1master Where IsActive=1 order by Type1 ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string bindState(string BusinessZoneID)
    {
        return Util.getJson(StockReports.GetDataTable("SELECT ID,State FROM state_master WHERE BusinessZoneID IN(" + BusinessZoneID + ") AND IsActive=1 ORDER BY State"));
    }

    [WebMethod(EnableSession = true)]
    public static string bindCity(string StateID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,City FROM `city_master` WHERE stateID IN(" + StateID + ")");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return null;
    }

    [WebMethod(EnableSession = true)]
    public static string BindData(string CentrTypeId, string StateId, string SubCategoryID)
    {
        StringBuilder sb = new StringBuilder();
        if (CentrTypeId != string.Empty || StateId != string.Empty)
        {
            sb.Append("SELECT CentreID,Centre FROM centre_master WHERE isActive='1'");
            if (StateId != string.Empty)
                sb.Append(" AND StateID IN(" + StateId + ") ");
            if (CentrTypeId != string.Empty)
                sb.Append(" AND Type1Id IN(" + CentrTypeId + ") ");
        }
        else
            sb.Append("SELECT CentreID,Centre FROM centre_master WHERE isActive='1'");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        dt.Columns.Add("Level1ID");
        dt.Columns.Add("Level1");
        dt.Columns.Add("Level2ID");
        dt.Columns.Add("Level2");
        dt.Columns.Add("Level3ID");
        dt.Columns.Add("Level3");

        StringBuilder sb1 = new StringBuilder();
        sb1.Append(" SELECT cm.CentreID,cm.Centre ,IFNULL(CAST(GROUP_CONCAT(em.Employee_ID) AS CHAR),'') LevelID,CAST(GROUP_CONCAT(CONCAT(em.Title,' ', em.NAME)) AS CHAR) LevelName,Lavel FROM centre_master cm ");
        sb1.Append(" LEFT JOIN customercare_inquery_categoryEmployee cc ON cm.CentreID=cc.CentreID  AND cc.IsActive=1 ");
        sb1.Append(" LEFT JOIN employee_master em  ON cc.`EmployeeID` = em.Employee_ID where cc.Inq_SubCategoryID='" + SubCategoryID + "' GROUP BY cm.CentreID,Lavel ");
        DataTable dt1 = StockReports.GetDataTable(sb1.ToString());

        foreach (DataRow row in dt.Rows)
        {
            var level1 = "Level1";
            var level2 = "Level2";
            var level3 = "Level3";
            DataRow[] erow1 = dt1.Select("CentreID = '" + row["CentreID"] + "' AND Lavel='" + level1 + "'");
            DataRow[] erow2 = dt1.Select("CentreID = '" + row["CentreID"] + "' AND Lavel='" + level2 + "'");
            DataRow[] erow3 = dt1.Select("CentreID = '" + row["CentreID"] + "' AND Lavel='" + level3 + "'");
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

    [WebMethod(EnableSession = true)]
    public static string bindCentre(string CityID, string BusinessZoneID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT cm.CentreID,cm.Centre FROM centre_master cm WHERE cm.isactive=1 AND  cm.BusinessZoneID IN (" + BusinessZoneID + ")  ");
        if (CityID != string.Empty)
            sb.Append(" AND cm.CityID IN(" + CityID + ") ");
        sb.Append("   ORDER BY cm.Centre ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return null;
    }
    [WebMethod]
    public static string SearchEmployee(string query, string EmpList)
    {
        if(EmpList==string.Empty)
            EmpList="''";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT HospCode,Employee_ID as value,CONCAT(House_No,'~', CONCAT(Title,' ', NAME)) AS label,Email,Mobile FROM employee_master WHERE IsActive='1' AND Employee_ID NOT IN(" + EmpList + ") AND name like '%" + query + "%' "); ;
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
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
            if (obj.EnquiryID != string.Empty)
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM customercare_inquery_categoryEmployee WHERE ID=@EnquiryID ",
                    new MySqlParameter("@EnquiryID", obj.EnquiryID)));
                if (count > 0)
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE customercare_inquery_categoryEmployee SET IsActive=@IsActive,UpdatedBy=@UpdatedBy,UpdatedID=@UpdatedID,UpdatedDate=@UpdatedDate");
                    sb.Append(" WHERE ID=@EnquiryID ");


                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@IsActive", "0"), new MySqlParameter("@EnquiryID", obj.EnquiryID),
                        new MySqlParameter("@UpdatedBy", UserInfo.LoginName), new MySqlParameter("@UpdatedID", UserInfo.ID), new MySqlParameter("@UpdatedDate", DateTime.Now)
                        
                        );
                }
            }
               


            
            var Center = CenterID.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            for (int i = 0; i < Center.Length; i++)
            {
               
              //  int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM customercare_inquery_categoryEmployee WHERE CentreID=@CentreID AND Inq_SubCategoryID=@Inq_SubCategoryID AND Lavel=@Level ",
              //      new MySqlParameter("@CentreID", Center[i]), new MySqlParameter("@Inq_SubCategoryID", obj.SubCategoryID), new MySqlParameter("@Level", obj.Lavel)));
                            
                //if (count > 0)
                //{
                //    sb = new StringBuilder();
                //    sb.Append(" UPDATE customercare_inquery_categoryEmployee SET IsActive=@IsActive,UpdatedBy=@UpdatedBy,UpdatedID=@UpdatedID,UpdatedDate=@UpdatedDate");
                //    sb.Append(" WHERE CentreID=@CentreID AND Inq_SubCategoryID=@Inq_SubCategoryID AND Lavel=@Level");
                    

                //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                //        new MySqlParameter("@IsActive", '0'), new MySqlParameter("@Inq_SubCategoryID", obj.SubCategoryID), new MySqlParameter("@CentreID", Center[i]),
                //        new MySqlParameter("@UpdatedBy", UserInfo.LoginName), new MySqlParameter("@UpdatedID", UserInfo.ID), new MySqlParameter("@UpdatedDate", DateTime.Now),
                //        new MySqlParameter("@Level", obj.Lavel)
                //        );
                //}
                
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO  customercare_inquery_categoryEmployee(`CentreID`,`EmployeeID`,`Inq_SubCategoryID`,`CreatedBy`,`CreatedID`,`Lavel`,LevelID,EmailCCLevel2,EmailCCLevel3) ");
                    sb.Append(" VALUES (@CentreID,@EmployeeID,@Inq_SubCategoryID,@CreatedBy,@CreatedID,@Level,@LevelID,@EmailCCLevel2,@EmailCCLevel3) ");
                 

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@CentreID", Center[i]), new MySqlParameter("@EmployeeID", obj.EmpID), new MySqlParameter("@Inq_SubCategoryID", obj.SubCategoryID),
                        new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedID", UserInfo.ID), new MySqlParameter("@Level", obj.Lavel),
                        new MySqlParameter("@LevelID", obj.Lavel.Remove(0, 5)), new MySqlParameter("@EmailCCLevel2", obj.EmailCCLevel2), new MySqlParameter("@EmailCCLevel3", obj.EmailCCLevel3));

                   
                
            }

           

                sb = new StringBuilder();
                sb.Append("UPDATE employee_master SET Mobile=@Mobile, Email=@Email,ReopenTicket=@ReopenTicket WHERE Employee_ID=@Employee_ID");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@Mobile", obj.Mobile), new MySqlParameter("@Email", obj.Email), new MySqlParameter("@ReopenTicket", obj.ReopenTicket),
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
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cc.ID,cm.`CentreID`,cm.`StateID`,cm.`CityID`,cm.`BusinessZoneID`, HospCode,em.Employee_ID ,CONCAT(House_No,'~', CONCAT(Title,' ', NAME)) EmpName,em.Email,em.Mobile ");
        sb.Append(" FROM  customercare_inquery_categoryEmployee cc ");
        sb.Append(" INNER JOIN employee_master em  ON cc.`EmployeeID` = em.Employee_ID ");
        sb.Append(" INNER JOIN `centre_master` cm ON cc.`CentreID`=cm.`CentreID` ");
        sb.Append(" WHERE cc.CentreID=@CenterID AND em.Employee_ID=@Employee_ID AND cc.`Lavel`=@Lavel AND cc.IsActive=@InqueryActive AND em.IsActive=@EmpActive");

        DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, sb.ToString(),
                     new MySqlParameter("@CenterID", CenterID), new MySqlParameter("@Employee_ID", ID), new MySqlParameter("@Lavel", Level),
                     new MySqlParameter("@InqueryActive", "1"), new MySqlParameter("@EmpActive", "1")
                     ).Tables[0];
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string GetCenter(string CenterID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.`CentreID`,cm.`StateID`,cm.`CityID`,cm.`BusinessZoneID`");
        sb.Append(" from `centre_master` cm WHERE cm.CentreID=@CentreID");

        DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, sb.ToString(), new MySqlParameter("@CentreID", CenterID)).Tables[0];
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
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
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cc.ID,em.Employee_ID ,CONCAT(Title,' ', NAME)EmpName,em.Email,em.Mobile,cm.`CentreID`,cm.`StateID`,cm.`CityID`,cm.`BusinessZoneID`,em.ReopenTicket,cc.EmailCCLevel2,cc.EmailCCLevel3 ");
        sb.Append(" FROM  customercare_inquery_categoryEmployee cc ");
        sb.Append(" INNER JOIN employee_master em  ON cc.`EmployeeID` = em.Employee_ID ");
        sb.Append(" INNER JOIN `centre_master` cm ON cc.`CentreID`=cm.`CentreID` ");
        sb.Append(" WHERE cc.CentreID=@CenterID  AND cc.`Lavel`=@Lavel AND cc.Inq_SubCategoryID=@Inq_SubCategoryID AND em.IsActive=@emActive AND cc.IsActive=@categoryActive");

        DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, sb.ToString(),
                     new MySqlParameter("@CenterID", CenterID), new MySqlParameter("@Lavel", Level), new MySqlParameter("@Inq_SubCategoryID", SubCategoryID),
                     new MySqlParameter("@emActive", "1"), new MySqlParameter("@categoryActive", "1")
                     ).Tables[0];
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod]
    public static string removeTagEmployeeDetail(string ID)
    {
        try
        {
            MySqlHelper.ExecuteNonQuery(Util.GetMySqlCon(), CommandType.Text, "UPDATE customercare_inquery_categoryEmployee SET IsActive =@IsActive WHERE ID=@ID",
                new MySqlParameter("@ID", ID), new MySqlParameter("@IsActive", "0"));
            
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
            if (obj.EnquiryID != string.Empty)
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM customercare_inquery_categoryEmployee WHERE ID=@EnquiryID ",
                    new MySqlParameter("@EnquiryID", obj.EnquiryID)));
                if (count > 0)
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE customercare_inquery_categoryEmployee SET employeeID=@employeeID,EmailCCLevel2=@EmailCCLevel2,EmailCCLevel3=@EmailCCLevel3,IsActive=@IsActive,UpdatedBy=@UpdatedBy,UpdatedID=@UpdatedID,UpdatedDate=@UpdatedDate");
                    sb.Append(" WHERE ID=@EnquiryID ");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@employeeID", obj.EmpID),
                       new MySqlParameter("@EmailCCLevel2", obj.EmailCCLevel2), new MySqlParameter("@EmailCCLevel3", obj.EmailCCLevel3), new MySqlParameter("@IsActive", "1"), new MySqlParameter("@EnquiryID", obj.EnquiryID),
                        new MySqlParameter("@UpdatedBy", UserInfo.LoginName), new MySqlParameter("@UpdatedID", UserInfo.ID), new MySqlParameter("@UpdatedDate", DateTime.Now)

                        );
                }
            }
            else
            { 

                sb = new StringBuilder();
                sb.Append(" INSERT INTO  customercare_inquery_categoryEmployee(`CentreID`,`EmployeeID`,`Inq_SubCategoryID`,`CreatedBy`,`CreatedID`,`Lavel`,LevelID,EmailCCLevel2,EmailCCLevel3) ");
                sb.Append(" VALUES (@CentreID,@EmployeeID,@Inq_SubCategoryID,@CreatedBy,@CreatedID,@Level,@LevelID,@EmailCCLevel2,@EmailCCLevel3) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@CentreID", "0"), new MySqlParameter("@EmployeeID", obj.EmpID), new MySqlParameter("@Inq_SubCategoryID", obj.SubCategoryID),
                    new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedID", UserInfo.ID), new MySqlParameter("@Level", obj.Lavel),
                    new MySqlParameter("@LevelID", obj.Lavel.Remove(0, 5)), new MySqlParameter("@EmailCCLevel2", obj.EmailCCLevel2), new MySqlParameter("@EmailCCLevel3", obj.EmailCCLevel3));




            }

            sb = new StringBuilder();
            sb.Append("UPDATE employee_master SET Mobile=@Mobile, Email=@Email,ReopenTicket=@ReopenTicket WHERE Employee_ID=@Employee_ID");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@Mobile", obj.Mobile), new MySqlParameter("@Email", obj.Email), new MySqlParameter("@ReopenTicket", obj.ReopenTicket),
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
    public static string defaultBindTagEmployeeDetail(string CenterID, string Level, int SubCategoryID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cc.ID,em.Employee_ID ,CONCAT(Title,' ', NAME)EmpName,em.Email,em.Mobile,em.ReopenTicket,cc.EmailCCLevel2,cc.EmailCCLevel3 ");
        sb.Append(" FROM  customercare_inquery_categoryEmployee cc ");
        sb.Append(" INNER JOIN employee_master em  ON cc.`EmployeeID` = em.Employee_ID ");       
        sb.Append(" WHERE cc.CentreID=@CenterID  AND cc.`Lavel`=@Lavel AND cc.Inq_SubCategoryID=@Inq_SubCategoryID AND em.IsActive=@emActive AND cc.IsActive=@categoryActive");

        DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, sb.ToString(),
                     new MySqlParameter("@CenterID", CenterID), new MySqlParameter("@Lavel", Level), new MySqlParameter("@Inq_SubCategoryID", SubCategoryID),
                     new MySqlParameter("@emActive", "1"), new MySqlParameter("@categoryActive", "1")
                     ).Tables[0];
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod(EnableSession = true)]
    public static string defaultBindData(string SubCategoryID)
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
        sb1.Append("CAST(GROUP_CONCAT(CONCAT(em.Title,' ', em.NAME)) AS CHAR) LevelName,Lavel FROM customercare_inquery_categoryEmployee cc ");
        sb1.Append("LEFT JOIN employee_master em  ON cc.`EmployeeID` = em.Employee_ID WHERE cc.IsActive=1 and CentreID=0 and cc.Inq_SubCategoryID='" + SubCategoryID + "' GROUP BY Lavel ");
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

    [WebMethod]
    public static string defaultremoveTagEmployeeDetail(string ID)
    {
        try
        {
            MySqlHelper.ExecuteNonQuery(Util.GetMySqlCon(), CommandType.Text, "UPDATE customercare_inquery_categoryEmployee SET IsActive =@IsActive WHERE ID=@ID",
                new MySqlParameter("@ID", ID), new MySqlParameter("@IsActive", "0"));

            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

    }

}
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Lab_SuggestedItemMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindtest();
        }
    }

    [WebMethod]
    public static string bindCentreLoad(List<string> Type1, string btype, List<string> StateID, List<string> ZoneId, string tagprocessinglab)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT CentreID,CONCAT(CentreID,'#',zone,'#',state,'#',city,'#')CentreID1,Concat(centrecode,'~',Centre)Centre,type1 FROM centre_master cm where isActive=1");
            if (ZoneId.Count > 0)
                sb.Append(" AND BusinessZoneID IN({0})");
            if (StateID.Count > 0)
                sb.Append("  AND cm.StateID IN({1})");
            if (Type1.Count > 0)
                sb.Append("  AND cm.Type1Id IN({2})");
            if (btype != "0")
                sb.Append(" and coco_foco=@btype");
            if (tagprocessinglab != "0" && tagprocessinglab != "-1" && tagprocessinglab != "null")
                sb.Append(" and TagProcessingLabID=@TagProcessingLabID");


            using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", ZoneId), string.Join(",", StateID), string.Join(",", Type1)), con))
            {

                da.SelectCommand.Parameters.AddWithValue("@btype", btype);
                da.SelectCommand.Parameters.AddWithValue("@TagProcessingLabID", tagprocessinglab);
                for (int i = 0; i < ZoneId.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@ZoneParam", i), ZoneId[i]);
                }
                for (int i = 0; i < StateID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@StateParam", i), StateID[i]);
                }
                for (int i = 0; i < Type1.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@TypeParam", i), Type1[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    sb = new StringBuilder();
                    ZoneId.Clear();
                    StateID.Clear(); Type1.Clear();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
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

    [WebMethod]
    public static string bindtagprocessinglabLoad(string btype, List<string> StateID, List<string> ZoneId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT CentreID,CONCAT(CentreID,'#',zone,'#',state,'#',city,'#')CentreID1,CONCAT(centreCode,'~',Centre)Centre,type1 FROM centre_master cm where isActive=1");
            if (ZoneId.Count > 0)
                sb.Append(" AND BusinessZoneID IN({0})");
            if (StateID.Count > 0)
                sb.Append("  AND cm.StateID IN({1})");
            if (btype != "0")
                sb.Append(" and coco_foco=@btype");
            sb.Append(" AND cm.CentreID=cm.TagProcessingLabID order by Centre ");
            using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", ZoneId), string.Join(",", StateID)), con))
            {

                da.SelectCommand.Parameters.AddWithValue("@btype", btype);
                for (int i = 0; i < ZoneId.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@ZoneParam", i), ZoneId[i]);
                }
                for (int i = 0; i < StateID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@StateParam", i), StateID[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    sb = new StringBuilder();
                    ZoneId.Clear();
                    StateID.Clear();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
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
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT DISTINCT type1id ID,type1 TEXT FROM centre_master ORDER BY type1id "));
    }
    public void bindtest()
    {
        ddlTest.DataSource = StockReports.GetDataTable(" SELECT CONCAT(testCode,' ~ ', TypeName)TypeName,ItemId FROM f_itemmaster where isActive=1 order by TypeName ");
        ddlTest.DataTextField = "TypeName";
        ddlTest.DataValueField = "ItemId";
        ddlTest.DataBind();
        ddlTest.Items.Insert(0, new ListItem("Select Test", "0"));
        lstSuggestTest.DataSource = ddlTest.DataSource;
        lstSuggestTest.DataTextField = "TypeName";
        lstSuggestTest.DataValueField = "ItemId";
        lstSuggestTest.DataBind();
    }

    public void bindcentre()
    {

        ddlCentreSuggested.DataSource = StockReports.GetDataTable(" SELECT CONCAT(centreCode,' ~ ',Centre) centre,centreid FROM centre_master WHERE isActive=1 ORDER BY centre ");
        ddlCentreSuggested.DataTextField = "centre";
        ddlCentreSuggested.DataValueField = "centreid";
        ddlCentreSuggested.DataBind();
    }
    [WebMethod]
    public static string suggestedtest()
    {
        return Util.getJson(StockReports.GetDataTable("SELECT CONCAT(testCode,' ~ ', TypeName) TypeName,ItemId FROM f_itemmaster "));
    }
    [WebMethod]
    public static string Savesuggesttest(string[] centreid, string TestId, string[] SuggestedId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {
            for (int j = 0; j < centreid.Length; j++)
            {

                for (int i = 0; i < SuggestedId.Length; i++)
                {
                    if (SuggestedId[i] != TestId)
                    {

                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "insert into f_itemmaster_suggestion(centreID,ItemID,ItemID_suggestion,IsActive,CreateBy,CreatedById,CreatedDate) values(@centreID,@ItemID,@ItemID_suggestion,1,@CreateBy,@CreatedById,now())",
                                       new MySqlParameter("@centreID", centreid[j]), new MySqlParameter("@ItemID", TestId),
                                         new MySqlParameter("@ItemID_suggestion", SuggestedId[i]),
                                          new MySqlParameter("@CreateBy", UserInfo.LoginName),
                                           new MySqlParameter("@CreatedById", UserInfo.ID)
                                       );
                    }
                }
            }
            Tranx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Data Save successfully" });
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error Occurred" });
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string bindtableData(List<string> centreid, string testid)
    {
        List<string> CentreIDList = centreid;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT (SELECT CONCAT(centreCode,' ~ ',Centre) centre FROM centre_master where Centreid=fis.centreid) centre,");
            sb.Append(" (SELECT CONCAT(testcode,' ~ ', TypeName) FROM f_itemmaster WHERE ItemID=fis.ItemID) TestName,(SELECT concat(testcode,' ~ ', TypeName) ");
            sb.Append(" FROM f_itemmaster WHERE ItemID=fis.ItemID_suggestion) SuggestTestName,fis.CreateBy,DATE_FORMAT(fis.CreatedDate,'%d-%b-%y %r') CreatedDate,");
            sb.Append(" fis.ID FROM `f_itemmaster_suggestion` fis");
            sb.Append(" where IsActive=1 ");
            if (centreid.Count > 0)
                sb.Append(" and fis.centreid in({0}) ");
            if (testid != string.Empty)
                sb.Append(" and fis.itemid=@itemid");
            sb.Append(" order by Centre,TestName,SuggestTestName");
            using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", CentreIDList)), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@itemid", testid);
                for (int i = 0; i < CentreIDList.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@CentreParam", i), CentreIDList[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    sb = new StringBuilder();
                    CentreIDList.Clear();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
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
    [WebMethod]
    public static string removerow(string id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE f_itemmaster_suggestion SET IsActive=0,UpdateBy=@UpdateBy,UpdatedByID=@UpdatedByID,UpdatedDate=now() WHERE id=@id ",
               new MySqlParameter("@UpdateBy", UserInfo.LoginName), new MySqlParameter("@UpdatedByID", UserInfo.ID), new MySqlParameter("@id", id));
            return JsonConvert.SerializeObject(new { status = true, response = "Test Remove successfully" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error Occurred" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string SearchRecords(List<string> centreid, string TestId, List<string> SuggestedId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ItemID FROM `f_itemmaster_suggestion` WHERE isActive=1   ");
            if (TestId != "0")
                sb.Append(" AND itemid=@itemid ");
            if (SuggestedId.Count > 0)
                sb.Append(" AND ItemID_suggestion  IN({0})");
            if (centreid.Count > 0)
                sb.Append(" AND centreID  in({1})");
            sb.Append(" order by id DESC  ");

            using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", SuggestedId), string.Join(",", centreid)), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@itemid", TestId);
                for (int i = 0; i < SuggestedId.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@SuggestedParam", i), SuggestedId[i]);
                }
                for (int i = 0; i < centreid.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@CentreParam", i), centreid[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    sb = new StringBuilder();
                    SuggestedId.Clear();
                    centreid.Clear();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
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
    public static string updatemultiRecords(string TestId, List<string> SuggestedId, List<string> centreid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlCommand cmd = new MySqlCommand() { Connection = con, CommandType = CommandType.Text };
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE f_itemmaster_suggestion SET IsActive=0,UpdateBy=@UpdateBy,UpdatedByID=@UpdatedByID");
            sb.Append(" UpdatedDate=now() WHERE itemid=@itemid");
            sb.Append(" and ItemID_suggestion  IN({0}) and centreid in ({1})");

            cmd.CommandText = String.Format(sb.ToString(), string.Join(",", SuggestedId), string.Join(",", centreid));
            cmd.Parameters.Add(new MySqlParameter("@itemid", TestId));
            cmd.Parameters.Add(new MySqlParameter("@UpdateBy", UserInfo.LoginName));
            cmd.Parameters.Add(new MySqlParameter("@UpdatedByID", UserInfo.ID));
            for (int i = 0; i < SuggestedId.Count; i++)
            {
                cmd.Parameters.Add(new MySqlParameter(string.Concat("@SuggestedParam", i), SuggestedId[i]));
            }
            for (int i = 0; i < centreid.Count; i++)
            {
                cmd.Parameters.Add(new MySqlParameter(string.Concat("@CentreParam", i), centreid[i]));
            }

            cmd.ExecuteNonQuery();
            sb = new StringBuilder();
            SuggestedId.Clear();
            centreid.Clear();
            cmd.Dispose();
            return JsonConvert.SerializeObject(new { status = true, response = "Test Remove successfully" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error Occurred" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string exportdatatoexcel(List<string> centreid, string testid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT (SELECT CONCAT(centrecode,' ~ ',centre) centre FROM centre_master where centreid=fis.centreid) centre,(SELECT concat(testcode,' ~ ', TypeName) FROM f_itemmaster WHERE ItemID=fis.ItemID) TestName,(SELECT concat(testcode,' ~ ', TypeName) FROM f_itemmaster WHERE ItemID=fis.ItemID_suggestion) SuggestTestName,fis.CreateBy,DATE_FORMAT(fis.CreatedDate,'%d-%b-%y %r') CreatedDate FROM `f_itemmaster_suggestion` fis");
            sb.Append(" where IsActive=1 ");
            if (centreid.Count > 0)
                sb.Append(" and fis.centreid in({0}) ");
            if (testid != "0")
                sb.Append(" and fis.itemid=@itemid");
            sb.Append(" order by Centre,TestName,SuggestTestName");
            List<string> CentreList = centreid.ToList<string>();
            using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", CentreList)), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@itemid", testid);
                for (int i = 0; i < CentreList.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@CentreParam", i), CentreList[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    sb = new StringBuilder();
                    CentreList.Clear();
                    DataColumn column = new DataColumn() { ColumnName = "S.No", DataType = Type.GetType("System.Int32"), AutoIncrement = true, AutoIncrementSeed = 0, AutoIncrementStep = 1 };

                    dt.Columns.Add(column);
                    int index = 0;
                    foreach (DataRow row in dt.Rows)
                    {
                        row.SetField(column, ++index);
                    }
                    dt.Columns["S.No"].SetOrdinal(0);
                    if (dt.Rows.Count > 0)
                    {

                        HttpContext.Current.Session["dtExport2Excel"] = dt;
                        HttpContext.Current.Session["ReportName"] = "PromotionalTest";
                        return "true";
                    }
                    else
                    {
                        return "false";
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "false";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
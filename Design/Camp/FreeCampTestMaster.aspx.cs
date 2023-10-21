using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

public partial class Design_Camp_FreeCampTestMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblCreatedBy.Text = UserInfo.LoginName;
            lblAddedData.Text = DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt");
        }
    }
    [WebMethod]
    public static string GetTestList(int SearchType, string TestName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.itemid value,typeName label,if(subcategoryID='15','Package','Test') type,0 Rate from f_itemmaster im ");
            sb.Append(" WHERE isActive=1 ");
            if (SearchType == 1)
                sb.Append(" AND typeName LIKE @TestName ");
            else if (SearchType == 0)
                sb.Append(" AND im.testcode LIKE @TestCode ");
            else
                sb.Append(" AND typeName like LIKE @typeName  ");

            sb.Append("  order by typeName limit 20 ");
            return Util.getJson(MySqlHelper.ExecuteDataset(con,CommandType.Text,sb.ToString(),
                                            new MySqlParameter("@TestName", string.Format("{0}%", TestName)),
                                            new MySqlParameter("@TestCode", string.Format("{0}%", TestName)),
                                            new MySqlParameter("@typeName", string.Format("%{0}%", TestName))).Tables[0]);
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
    public static string getTestDetail()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT st.ID,im.TypeName ItemName,im.TestCode,st.ItemID,DATE_FORMAT(st.CreatedDate,'%d-%b-%Y %h:%i %p')AddedDate, ");
        sb.Append(" st.CreatedBy AddedBy,IFNULL(st.UpdatedBy,'')LastUpdatedBy,");
        sb.Append(" IF(IFNULL(st.UpdatedBy,'')<>'',DATE_FORMAT(st.UpdatedDate,'%d-%b-%Y %h:%i %p'),'')LastUpdatedDate ");
        sb.Append(" FROM  camp_freetest_master st INNER JOIN f_ItemMaster im on im.ItemID=st.ItemID   ");
        sb.Append(" WHERE st.IsActive=1  ORDER BY st.ID+0");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
                return Util.getJson(dt);
            else
                return null;
        }
    }
    [WebMethod(EnableSession = true)]
    public static string saveTest(object ItemDetail)
    {
        List<ItemData> ItemDetails = new JavaScriptSerializer().ConvertToType<List<ItemData>>(ItemDetail);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ItemID FROM  camp_freetest_master "
                                              ).Tables[0])
            {
                List<ItemData> specialItem = new List<ItemData>();
                specialItem = (from DataRow dr in dt.Rows
                               select new ItemData()
                               {
                                   ItemID = Util.GetInt(dr["ItemID"]),
                               }).ToList();
                HashSet<int> sentIDs = new HashSet<int>(ItemDetails.Select(s => s.ItemID));

                specialItem = specialItem.Where(m => !sentIDs.Contains(m.ItemID)).ToList();

                string Item_ID = String.Join(",", specialItem.Select(a => String.Join(", ", a.ItemID)));
                if (Item_ID != string.Empty)
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE camp_freetest_master SET IsActive=0,UpdatedByID=@UpdatedByID,UpdatedDate=NOW(),UpdatedBy=@UpdatedBy WHERE ItemID IN(" + Item_ID + ")",
                                new MySqlParameter("@UpdatedByID", UserInfo.ID),
                                new MySqlParameter("@UpdatedBy", UserInfo.LoginName));
                for (int k = 0; k < ItemDetails.Count; k++)
                {
                    if (dt.AsEnumerable().Where(s => s.Field<int>("ItemID") == ItemDetails[k].ItemID).Count() > 0)
                    {

                        if (dt.AsEnumerable().Where(s => s.Field<int>("ItemID") == ItemDetails[k].ItemID).Count() > 0)
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE camp_freetest_master SET UpdatedByID=@UpdatedByID,UpdatedDate=NOW(),UpdatedBy=@UpdatedBy WHERE ItemID=@ItemID ",
                                        new MySqlParameter("@UpdatedByID", UserInfo.ID),
                                        new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                                        new MySqlParameter("@ItemID", ItemDetails[k].ItemID));
                        }                       
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO camp_freetest_master(ItemID,CreatedByID,CreatedBy)VALUES(@ItemID,@CreatedByID,@CreatedBy) ",
                                    new MySqlParameter("@ItemID", ItemDetails[k].ItemID),
                                    new MySqlParameter("@CreatedByID", UserInfo.ID),
                                    new MySqlParameter("@CreatedBy", UserInfo.LoginName));
                    }
                }
                tnx.Commit();
                ItemDetails.Clear();
                specialItem.Clear();
                sentIDs.Clear();
                return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class ItemData
    {
        public int ItemID { get; set; }
        public int IsNew { get; set; }
        public int IsOld { get; set; }
    }
    [WebMethod(EnableSession = true)]
    public static string removeCampTest(int CampTestID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE camp_freetest_master SET IsActive=0,UpdatedByID=@UpdatedByID,UpdatedDate=NOW(),UpdatedBy=@UpdatedBy WHERE ID=@ID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@UpdatedByID", UserInfo.ID),
                        new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                        new MySqlParameter("@ID", CampTestID));
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
    [WebMethod(EnableSession = true)]
    public static Dictionary<string, string> gerReport()
    {
        Dictionary<string, string> returnData = new Dictionary<string, string>();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.TestCode, im.TypeName TestName,fis.CreatedBy,DATE_FORMAT(fis.CreatedDate,'%d-%b-%Y')CreatedDate,");
        sb.Append(" IFNULL(fis.UpdatedBy,'')UpdatedBy, IF(IFNULL(UpDatedByID,0)=0,'',DATE_FORMAT(fis.UpdatedDate,'%d-%b-%Y'))UpdatedDate ");
        sb.Append(" FROM camp_freetest_master fis INNER JOIN f_itemmaster im ON fis.ItemID=im.ItemID ");
        sb.Append(" WHERE fis.IsActive=1 ORDER BY fis.ID+0 ");

        returnData.Add("ReportDisplayName", Common.EncryptRijndael("Free Camp test Report"));
        returnData.Add("Query", Common.EncryptRijndael(sb.ToString()));
        returnData.Add("ReportPath", string.Concat(AllLoad_Data.getHostDetail(), "/Design/Common/ExportToExcelReport.aspx"));
        return returnData;
    }
}
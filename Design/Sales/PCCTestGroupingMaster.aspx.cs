using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_Sales_PCCTestGroupingMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string cmd = Util.GetString(Request.QueryString["cmd"]);
        string rtrn = "";

        if (cmd == "GetTestList")
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(GetTestList());
            Response.Clear();
            Response.ContentType = "application/json; charset=utf-8";
            Response.Write(rtrn);
            Response.End();

            return;
        }
    }

    [WebMethod]
    private DataTable GetTestList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.itemid value,typeName label,if(subcategoryID='15','Package','Test') type,0 Rate from f_itemmaster im ");
        sb.Append(" WHERE isActive=1 ");
        if (Request.QueryString["SearchType"] == "1")
            sb.Append(" AND typeName like '" + Request.QueryString["TestName"].ToString() + "%' ");
        else if (Request.QueryString["SearchType"] == "0")
            sb.Append(" AND im.testcode LIKE '" + Request.QueryString["TestName"].ToString() + "%' ");
        else
            sb.Append(" AND typeName like '%" + Request.QueryString["TestName"].ToString() + "%' ");

        sb.Append("  order by typeName limit 20 ");

        return StockReports.GetDataTable(sb.ToString());
    }

    [WebMethod]
    public static string bindGroup()
    {
        DataTable dt = StockReports.GetDataTable("Select GroupName,CONCAT(GroupID,'#',IsActive)GroupID FROM sales_pccGrouping_Master   ");
        return Util.getJson(dt);
    }

    [WebMethod]
    public static string bindPCCTestGroup(string GroupID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select gp.GroupID,gp.ItemID,im.TypeName ItemName,IFNULL( im.testcode,'')TestCode FROM  sales_pccGrouping gp   ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=gp.ItemID ");
        sb.Append(" WHERE  gp.IsActive=1 AND gp.groupID=@GroupID");

        DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, sb.ToString(),
            new MySqlParameter("@GroupID", GroupID)).Tables[0];

        return Util.getJson(dt);
    }

    public class ItemData
    {
        public int ItemID { get; set; }
    }

    [WebMethod]
    public static string savePCCTestGroup(string GroupName, object ItemDetail)
    {
        List<ItemData> ItemDetails = new JavaScriptSerializer().ConvertToType<List<ItemData>>(ItemDetail);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string ItemID = String.Join(",", ItemDetails.Select(a => String.Join(", ", a.ItemID)));

            DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT sg.ItemID,gm.GroupName FROM  sales_pccGrouping sg INNER JOIN sales_pccGrouping_Master gm ON sg.groupID=gm.groupID WHERE ItemID IN(" + ItemID + ")  AND gm.IsActive=1 AND sg.IsActive=1 ").Tables[0];
            if (dt1.Rows.Count > 0)
            {
                return Util.getJson(dt1);
            }

            int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM sales_pccGrouping_Master WHERE GroupName=@GroupName",
                 new MySqlParameter("@GroupName", GroupName)
                ));
            if (count > 0)
            {
                return "2";
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO sales_pccGrouping_Master(GroupName,CreatedByID,CreatedBy)VALUES(@GroupName,@CreatedByID,@CreatedBy) ",
                       new MySqlParameter("@GroupName", GroupName),
                       new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName));

            int GroupID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT LAST_INSERT_ID()"));

            for (int k = 0; k < ItemDetails.Count; k++)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO sales_pccGrouping(ItemID,GroupID,CreatedByID,CreatedBy)VALUES(@ItemID,@GroupID,@CreatedByID,@CreatedBy) ",
                    new MySqlParameter("@ItemID", ItemDetails[k].ItemID), new MySqlParameter("@GroupID", GroupID),
                    new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName));
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
    public static string GetItemMaster(string ItemID, string Type)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL( im.testcode,'')testCode,typeName,im.`ItemID`,IFNULL(gm.GroupName,'')GroupName FROM f_itemmaster im ");
        sb.Append(" LEFT JOIN  sales_pccGrouping sg ON im.ItemID=sg.ItemID LEFT JOIN sales_pccGrouping_Master gm ON gm.GroupID=sg.GroupID AND sg.IsActive=1 AND gm.isActive=1 ");
        sb.Append(" WHERE im.`ItemID`='" + ItemID + "' ");
        sb.Append(" ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string updatePCCTestGroup(int GroupID, int isEdit, int Active, string GroupName, object ItemDetail)
    {
        List<ItemData> ItemDetails = new JavaScriptSerializer().ConvertToType<List<ItemData>>(ItemDetail);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string ItemID = String.Join(",", ItemDetails.Select(a => String.Join(", ", a.ItemID)));

            DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT sg.ItemID,gm.GroupName FROM  sales_pccGrouping sg INNER JOIN sales_pccGrouping_Master gm ON sg.groupID=gm.groupID WHERE ItemID IN(" + ItemID + ") AND gm.groupID !='" + GroupID + "' AND gm.IsActive=1 AND sg.IsActive=1").Tables[0];
            if (dt1.Rows.Count > 0)
            {
                return Util.getJson(dt1);
            }

            int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM sales_pccGrouping_Master WHERE GroupName=@GroupName AND GroupID<>@GroupID",
                 new MySqlParameter("@GroupName", GroupName), new MySqlParameter("@GroupID", GroupID)
                ));
            if (count > 0)
            {
                return "2";
            }
            if (isEdit == 1)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sales_pccGrouping_Master SET isActive=@isActive,GroupName=@GroupName,UpdatedByID=@UpdatedByID,UpdatedDate=NOW(),UpdatedBy=@UpdatedBy WHERE GroupID=@GroupID ",
                    new MySqlParameter("@GroupName", GroupName), new MySqlParameter("@UpdatedByID", UserInfo.ID), new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                    new MySqlParameter("@GroupID", GroupID), new MySqlParameter("@isActive", Active));
            }

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ItemID FROM  sales_pccGrouping WHERE GroupID=@GroupID ",
                new MySqlParameter("@GroupID", GroupID)).Tables[0];

            List<ItemData> groupingItem = new List<ItemData>();
            groupingItem = (from DataRow dr in dt.Rows
                            select new ItemData()
                            {
                                ItemID = Util.GetInt(dr["ItemID"]),
                            }).ToList();

            HashSet<int> sentIDs = new HashSet<int>(ItemDetails.Select(s => s.ItemID));

            groupingItem = groupingItem.Where(m => !sentIDs.Contains(m.ItemID)).ToList();

            string Item_ID = String.Join(",", groupingItem.Select(a => String.Join(", ", a.ItemID)));
            StringBuilder sb = new StringBuilder();
            if (Item_ID != string.Empty)
            {
                sb = new StringBuilder();
                sb.Append("INSERT INTO sales_pccgrouping_bkp(Bkp_ID,Bkp_GroupID,Bkp_ItemID,Bkp_CreatedBy,Bkp_CreatedByID,Bkp_CreatedDate,Bkp_IsActive,CreatedBy,CreatedByID)");
                sb.Append(" SELECT ID,GroupID,ItemID,CreatedBy,CreatedByID,CreatedDate,IsActive,'" + UserInfo.LoginName + "','" + UserInfo.ID + "' FROM sales_pccGrouping WHERE ItemID IN(" + Item_ID + ") AND GroupID='" + GroupID + "'  ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sales_pccGrouping SET IsActive=0,UpdatedByID='" + UserInfo.ID + "',UpdatedDate=NOW(),UpdatedBy='" + UserInfo.LoginName + "' WHERE ItemID IN(" + Item_ID + ") AND GroupID='" + GroupID + "' ");
            }
            for (int k = 0; k < ItemDetails.Count; k++)
            {
                DataRow[] fountRow = dt.Select("ItemID = '" + ItemDetails[k].ItemID + "'");
                if (fountRow.Length == 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO sales_pccGrouping(ItemID,GroupID,CreatedByID,CreatedBy)VALUES(@ItemID,@GroupID,@CreatedByID,@CreatedBy) ",
                      new MySqlParameter("@ItemID", ItemDetails[k].ItemID), new MySqlParameter("@GroupID", GroupID),
                      new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName));
                }
                else
                {
                    sb = new StringBuilder();
                    sb.Append("INSERT INTO sales_pccgrouping_bkp(Bkp_ID,Bkp_GroupID,Bkp_ItemID,Bkp_CreatedBy,Bkp_CreatedByID,Bkp_CreatedDate,Bkp_IsActive,CreatedBy,CreatedByID)");
                    sb.Append(" SELECT ID,GroupID,ItemID,CreatedBy,CreatedByID,CreatedDate,IsActive,@CreatedBy,@CreatedByID FROM sales_pccGrouping WHERE ItemID=@ItemID AND GroupID=@GroupID  ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@ItemID", ItemDetails[k].ItemID), new MySqlParameter("@GroupID", GroupID), new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID)
                        );

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sales_pccGrouping SET IsActive=1, UpdatedByID=@UpdatedByID,UpdatedDate=NOW(),UpdatedBy=@UpdatedBy WHERE ItemID=@ItemID AND GroupID=@GroupID",
                             new MySqlParameter("@UpdatedByID", UserInfo.ID),
                             new MySqlParameter("@UpdatedBy", UserInfo.LoginName), new MySqlParameter("@ItemID", ItemDetails[k].ItemID), new MySqlParameter("@GroupID", GroupID));
                }
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
}
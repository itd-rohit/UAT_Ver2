using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_Master_MapSpecialTestMaster : System.Web.UI.Page
{
    public DataTable dtMerge = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
        }
    }

    [WebMethod]
    public static string bindPanel(int BusinessZoneID, int StateID, int CityID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Company_Name,Panel_ID FROM f_panel_master ");
        sb.Append(" WHERE TagProcessingLabID IN (SELECT CentreID FROM centre_master WHERE  BusinessZoneID='" + BusinessZoneID + "'");
        sb.Append(" AND StateID='" + StateID + "' AND CityID='" + CityID + "' AND IsActive=1  AND COCO_FOCO='COCO')");
        sb.Append(" AND PanelType='PUP'  AND IsActive=1 ");
        sb.Append("  ");

        sb.Append(" UNION ALL ");

        sb.Append("SELECT fpm.Company_Name,fpm.Panel_ID FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID ");
        sb.Append(" WHERE  cm.BusinessZoneID='" + BusinessZoneID + "' AND cm.StateID='" + StateID + "' AND cm.CityID='" + CityID + "'  ");
        sb.Append(" AND cm.IsActive=1 AND cm.COCO_FOCO='FOCO' ");
        sb.Append(" ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return "";
    }

    [WebMethod]
    public static string getSpecialTest(string PanelID, int isVerifiedChk)
    {
        DataTable dtMerge = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.TypeName ItemName, fis.ItemID,fis.Rate,IFNULL(fms.Rate,'')SRate,IFNULL(pnl.panel_id,'')PanelID,pnl.Company_Name PanelName FROM f_itemmaster_special fis INNER JOIN f_itemmaster im ON fis.ItemID=im.ItemID ");
        if (isVerifiedChk == 0)
        {
            sb.Append(" INNER JOIN f_panel_master_specialtest fms ON fms.ItemID=fis.ItemID AND fms.IsActive=1 AND fms.IsVerified=0");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.Panel_ID =fms.Panel_ID  ");
            if (PanelID != "")
                sb.Append(" AND pnl.Panel_ID IN (" + PanelID + ")   ");
        }
        else
        {
            sb.Append(" CROSS JOIN f_panel_master pnl ON pnl.Panel_ID IN (" + PanelID + ")");
            sb.Append("  LEFT JOIN f_panel_master_specialtest fms ON fms.ItemID=fis.ItemID AND  fms.panel_id =pnl.Panel_ID  AND fms.IsActive=1 ");
        }

        sb.Append(" WHERE fis.IsActive=1 AND im.IsActive=1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            dtMerge.Columns.Add("ItemName");
            dtMerge.Columns.Add("ItemID");
            dtMerge.Columns.Add("Rate");

            DataRow newrow = dtMerge.NewRow();

            foreach (DataRow dr in dt.Rows)
            {
                DataRow[] RowCreated = dtMerge.Select("ItemID='" + dr["ItemID"].ToString() + "'");
                if (RowCreated.Length == 0)
                {
                    DataRow[] RowExist = dt.Select("ItemID='" + dr["ItemID"].ToString() + "'");
                    if (RowExist.Length > 0)
                    {
                        DataRow row = dtMerge.NewRow();
                        row["ItemID"] = RowExist[0]["ItemID"].ToString();
                        row["ItemName"] = RowExist[0]["ItemName"].ToString();
                        row["Rate"] = RowExist[0]["Rate"].ToString();

                        for (int i = 0; i < RowExist.Length; i++)
                        {
                            if (!dtMerge.Columns.Contains(RowExist[i]["PanelName"].ToString() + "#" + RowExist[i]["PanelID"].ToString()))
                            {
                                dtMerge.Columns.Add(RowExist[i]["PanelName"].ToString() + "#" + RowExist[i]["PanelID"].ToString());
                            }
                            row[RowExist[i]["PanelName"].ToString() + "#" + RowExist[i]["PanelID"].ToString()] = RowExist[i]["SRate"];
                        }
                        dtMerge.Rows.Add(row);
                    }
                }
            }
            return Util.getJson(dtMerge);
        }
        else
            return "";
    }

    [WebMethod]
    public static string saveSpecialTest(object ItemDetail)
    {
        List<ItemData> ItemDetails = new JavaScriptSerializer().ConvertToType<List<ItemData>>(ItemDetail);

        ItemDetails = ItemDetails.GroupBy(x => new { x.ItemID, x.Panel_ID }).Select(g => g.OrderByDescending(o => o.Panel_ID).Last()).ToList();

        ItemDetails = ItemDetails.Where(s => !string.IsNullOrWhiteSpace(Util.GetString(s.Rate))).ToList();

        //List<ItemData> specialItem = new List<ItemData>();
        //specialItem = (from DataRow dr in dt.Rows
        //               select new ItemData()
        //               {
        //                   ItemID = Util.GetInt(dr["ItemID"]),
        //                   Panel_ID = Util.GetInt(dr["Panel_ID"]),
        //                   Rate = Util.GetDouble(dr["Rate"]),
        //                   RateBasic = Util.GetDouble(dr["RateBasic"]),
        //               }).ToList();

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ItemID,Panel_ID,Rate,RateBasic FROM f_panel_master_specialtest ").Tables[0];

        DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ItemID,Rate FROM f_itemmaster_special WHERE IsActive=1 ").Tables[0];

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            for (int k = 0; k < ItemDetails.Count; k++)
            {
                //   bool contains = dt.AsEnumerable().Any(row => ItemDetails[k].ItemID == row.Field<int>("ItemID") &&  ItemDetails[k].Panel_ID == row.Field<int>("Panel_ID"));

                int isVerified = 1;
                DataRow[] foundRate = dt1.Select("ItemID = '" + ItemDetails[k].ItemID + "' AND Rate >'" + ItemDetails[k].Rate + "'");

                if (foundRate.Length != 0)
                {
                    isVerified = 0;
                }
                StringBuilder sb = new StringBuilder();
                DataRow[] foundRow = dt.Select("ItemID = '" + ItemDetails[k].ItemID + "' AND Panel_ID='" + ItemDetails[k].Panel_ID + "'");
                if (foundRow.Length != 0)
                {
                    foundRow = dt.Select("ItemID = '" + ItemDetails[k].ItemID + "' AND Panel_ID='" + ItemDetails[k].Panel_ID + "' AND Rate<>'" + ItemDetails[k].Rate + "'");
                    if (foundRow.Length != 0)
                    {
                        sb.Append(" UPDATE f_panel_master_specialtest SET Rate='" + ItemDetails[k].Rate + "',UpdatedByID='" + UserInfo.ID + "',UpdatedDate=NOW(),UpdatedBy='" + UserInfo.LoginName + "'  ");
                        sb.Append(" ,isVerified='" + isVerified + "' ");
                        sb.Append(" WHERE ItemID='" + ItemDetails[k].ItemID + "' AND Panel_ID='" + ItemDetails[k].Panel_ID + "' ");

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                    }
                    else
                    {
                    }
                }
                else
                {
                    sb.Append(" INSERT INTO f_panel_master_specialtest(ItemID,Panel_ID,Rate,RateBasic,CreatedByID,CreatedBy,isVerified) ");
                    sb.Append("");
                    sb.Append(" VALUES('" + ItemDetails[k].ItemID + "','" + ItemDetails[k].Panel_ID + "','" + ItemDetails[k].Rate + "','" + ItemDetails[k].RateBasic + "','" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + isVerified + "')");

                    sb.Append("");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                }

                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM f_ratelist WHERE Panel_ID='" + ItemDetails[k].Panel_ID + "' AND ItemID='" + ItemDetails[k].ItemID + "'");

                //RateList rl = new RateList(tnx);
                //rl.ItemID = Util.GetString(ItemDetails[k].ItemID);
                //rl.Panel_ID = Util.GetString(ItemDetails[k].Panel_ID);
                //rl.Rate = Util.GetDouble( ItemDetails[k].Rate);
                //rl.ERate = Util.GetDouble(ItemDetails[k].Rate);
                //rl.IsCurrent = 1;
                //rl.FromDate = Util.GetDateTime(DateTime.Now);
                //rl.IsService = "YES";
                //rl.UpdateBy = Util.GetString(UserInfo.ID);
                //rl.UpdateRemarks = "Special Test Rate";
                //rl.ItemDisplayName = "";
                //rl.UpdateDate = DateTime.Now;
                //string RateListID = rl.Insert();
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

    public class ItemData
    {
        public int ItemID { get; set; }
        public int Panel_ID { get; set; }
        public double? Rate { get; set; }
        public double? RateBasic { get; set; }
    }

    [WebMethod]
    public static int approvalRight()
    {
        return Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM employee_master WHERE ApproveSpecialRate=1 AND Employee_ID='" + UserInfo.ID + "'"));
    }

    [WebMethod]
    public static string getNotVerifiedTest(string PanelID)
    {
        DataTable dtMerge = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.TypeName ItemName, fis.ItemID,fis.Rate,IFNULL(fms.Rate,'')SRate,IFNULL(pnl.panel_id,'')PanelID,pnl.Company_Name PanelName FROM f_itemmaster_special fis ");
        sb.Append(" INNER JOIN f_itemmaster im ON fis.ItemID=im.ItemID  INNER JOIN f_panel_master pnl ON pnl.Panel_ID ");
        if (PanelID != "")
            sb.Append(" IN (" + PanelID + ") ");
        sb.Append(" INNER JOIN f_panel_master_specialtest fms ON fms.ItemID=fis.ItemID AND  fms.panel_id =pnl.Panel_ID  AND fms.IsActive=1 ");

        sb.Append(" WHERE fis.IsActive=1 AND im.IsActive=1 AND fms.IsVerified=0 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            dtMerge.Columns.Add("ItemName");
            dtMerge.Columns.Add("ItemID");
            dtMerge.Columns.Add("Rate");

            DataRow newrow = dtMerge.NewRow();

            foreach (DataRow dr in dt.Rows)
            {
                DataRow[] RowCreated = dtMerge.Select("ItemID='" + dr["ItemID"].ToString() + "'");
                if (RowCreated.Length == 0)
                {
                    DataRow[] RowExist = dt.Select("ItemID='" + dr["ItemID"].ToString() + "'");
                    if (RowExist.Length > 0)
                    {
                        DataRow row = dtMerge.NewRow();
                        row["ItemID"] = RowExist[0]["ItemID"].ToString();
                        row["ItemName"] = RowExist[0]["ItemName"].ToString();
                        row["Rate"] = RowExist[0]["Rate"].ToString();

                        for (int i = 0; i < RowExist.Length; i++)
                        {
                            if (!dtMerge.Columns.Contains(RowExist[i]["PanelName"].ToString() + "#" + RowExist[i]["PanelID"].ToString()))
                            {
                                dtMerge.Columns.Add(RowExist[i]["PanelName"].ToString() + "#" + RowExist[i]["PanelID"].ToString());
                            }
                            row[RowExist[i]["PanelName"].ToString() + "#" + RowExist[i]["PanelID"].ToString()] = RowExist[i]["SRate"];
                        }
                        dtMerge.Rows.Add(row);
                    }
                }
            }
            return Util.getJson(dtMerge);
        }
        else
            return "";
    }

    [WebMethod]
    public static string approveSpecialTest(object ItemDetail)
    {
        List<ItemData> ItemDetails = new JavaScriptSerializer().ConvertToType<List<ItemData>>(ItemDetail);

        ItemDetails = ItemDetails.GroupBy(x => new { x.ItemID, x.Panel_ID }).Select(g => g.OrderByDescending(o => o.Panel_ID).Last()).ToList();

        ItemDetails = ItemDetails.Where(s => !string.IsNullOrWhiteSpace(Util.GetString(s.Rate))).ToList();

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            for (int k = 0; k < ItemDetails.Count; k++)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE f_panel_master_specialtest SET Rate='" + ItemDetails[k].Rate + "',VerifiedByID='" + UserInfo.ID + "',VerifiedDateTime=NOW(),VerifiedBy='" + UserInfo.LoginName + "'  ");
                sb.Append(" ,isVerified='1' ");
                sb.Append(" WHERE ItemID='" + ItemDetails[k].ItemID + "' AND Panel_ID='" + ItemDetails[k].Panel_ID + "' ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
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
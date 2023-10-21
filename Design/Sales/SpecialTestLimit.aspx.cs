using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_Sales_SpecialTestLimit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod(EnableSession = true)]
    public static string bindSalesHierarchy(string EntryType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT im.TypeName ItemName, fis.ItemID,fis.Rate BaseRate ,IFNULL(fms.TestRate, '')TestRate,sh.Name SalesName,sh.ID SalesID ");
        sb.Append(" FROM f_itemmaster im INNER JOIN f_itemmaster_special fis ON fis.ItemID=im.ItemID  AND fis.EntryType='" + EntryType.ToUpper() + "' ");
        sb.Append(" CROSS JOIN f_designation_msater sh LEFT JOIN sales_special_testlimit_amount fms ON fms.SpecialTestID=fis.ItemID AND fms.SalesID=sh.ID AND fms.IsActive=1 AND fms.EntryType='" + EntryType.ToUpper() + "' ");

        sb.Append(" WHERE fis.IsActive =1 AND sh.IsActive=1 AND sh.IsSales=1 ORDER BY sh.SequenceNo+0 DESC ,fms.id+0 ASC ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataTable dtMerge = new DataTable();
        if (dt.Rows.Count > 0)
        {
            dtMerge.Columns.Add("ItemID");
            dtMerge.Columns.Add("ItemName");
            dtMerge.Columns.Add("BaseRate");

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
                        row["BaseRate"] = RowExist[0]["BaseRate"].ToString();

                        for (int i = 0; i < RowExist.Length; i++)
                        {
                            if (!dtMerge.Columns.Contains(RowExist[i]["SalesName"].ToString() + "#" + RowExist[i]["SalesID"].ToString()))
                            {
                                dtMerge.Columns.Add(RowExist[i]["SalesName"].ToString() + "#" + RowExist[i]["SalesID"].ToString());
                            }
                            row[RowExist[i]["SalesName"].ToString() + "#" + RowExist[i]["SalesID"].ToString()] = RowExist[i]["TestRate"].ToString();
                        }

                        dtMerge.Rows.Add(row);
                    }
                }
            }
        }

        return Util.getJson(dtMerge);
    }

    public class ItemData
    {
        public int specialTestID { get; set; }
        public int SalesID { get; set; }
        public decimal basicRate { get; set; }
        public decimal testRate { get; set; }
        public string salesName { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public static string saveTestLimit(string ItemDetail, string EntryType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            JavaScriptSerializer Serializer = new JavaScriptSerializer();
            List<ItemData> ItemDetails = Serializer.Deserialize<List<ItemData>>(ItemDetail);

            ItemDetails = ItemDetails.Where(s => !string.IsNullOrWhiteSpace(Util.GetString(s.testRate))).ToList();

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sales_special_testlimit_amount SET IsActive=@IsActive WHERE EntryType=@EntryType",
                new MySqlParameter("@IsActive", "0"), new MySqlParameter("@EntryType", EntryType)
                );

            for (int k = 0; k < ItemDetails.Count; k++)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO sales_special_testlimit_amount(SalesID,SpecialTestID,BaseRate,TestRate,CreatedByID,CreatedBy,EntryType)");
                sb.Append(" VALUES(@SalesID,@SpecialTestID,@BaseRate,@TestRate,@CreatedByID,@CreatedBy,@EntryType)");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@SalesID", ItemDetails[k].SalesID),
                     new MySqlParameter("@SpecialTestID", ItemDetails[k].specialTestID), new MySqlParameter("@BaseRate", ItemDetails[k].basicRate),
                     new MySqlParameter("@TestRate", ItemDetails[k].testRate),
                     new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                     new MySqlParameter("@EntryType", EntryType)
                     );
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
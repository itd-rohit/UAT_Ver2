using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_Sales_DiscountOnMRPMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod(EnableSession = true)]
    public static string bindSalesHierarchy(string EntryType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT sh.ID SalesID,sh.Name SalesName,IFNULL(DiscountOnMRP,'')DiscountOnMRP,IFNULL(BusinessCommitment,'0')BusinessCommitment,IFNULL(sl.ID,1)ID,'' `Add`,'' `Remove` FROM f_designation_msater  sh ");
        sb.Append(" LEFT JOIN sales_DiscountOnMRP sl ON sh.ID=sl.SalesID AND sl.IsActive=1 AND sl.EntryType='" + EntryType.ToUpper() + "'");
        sb.Append(" ");

        sb.Append(" WHERE sh.IsActive =1 AND sh.IsSales=1 ORDER BY sh.SequenceNo+0 DESC ,sl.id+0 ASC");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataTable dtMerge = new DataTable();
        if (dt.Rows.Count > 0)
        {
            dtMerge.Columns.Add("BusinessCommitment");
            dtMerge.Columns.Add("ID");
            DataRow newrow = dtMerge.NewRow();
            foreach (DataRow dr in dt.Rows)
            {
                DataRow[] RowCreated = dtMerge.Select("BusinessCommitment='" + dr["BusinessCommitment"].ToString() + "'");
                if (RowCreated.Length == 0)
                {
                    DataRow[] RowExist = dt.Select("BusinessCommitment='" + dr["BusinessCommitment"].ToString() + "'");
                    if (RowExist.Length > 0)
                    {
                        DataRow row = dtMerge.NewRow();
                        for (int i = 0; i < RowExist.Length; i++)
                        {
                            if (!dtMerge.Columns.Contains(RowExist[i]["SalesName"].ToString() + "#" + RowExist[i]["SalesID"].ToString()))
                            {
                                dtMerge.Columns.Add(RowExist[i]["SalesName"].ToString() + "#" + RowExist[i]["SalesID"].ToString());
                            }
                            row[RowExist[i]["SalesName"].ToString() + "#" + RowExist[i]["SalesID"].ToString()] = RowExist[i]["DiscountOnMRP"].ToString();

                            row["BusinessCommitment"] = RowExist[i]["BusinessCommitment"].ToString();
                            row["ID"] = RowExist[i]["ID"].ToString();
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
        public decimal businessCommitment { get; set; }
        public int salesID { get; set; }
        public int DiscountOnMRP { get; set; }
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

            ItemDetails = ItemDetails.Where(s => !string.IsNullOrWhiteSpace(Util.GetString(s.DiscountOnMRP))).ToList();

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sales_DiscountOnMRP SET IsActive=@IsActive WHERE EntryType=@EntryType",
                new MySqlParameter("@IsActive", "0"), new MySqlParameter("@EntryType", EntryType.ToUpper())
                );

            for (int k = 0; k < ItemDetails.Count; k++)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO sales_DiscountOnMRP(BusinessCommitment,SalesID,DiscountOnMRP,CreatedByID,CreatedBy,EntryType)");
                sb.Append(" VALUES(@BusinessCommitment,@SalesID,@DiscountOnMRP,@CreatedByID,@CreatedBy,@EntryType)");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@BusinessCommitment", ItemDetails[k].businessCommitment),
                     new MySqlParameter("@SalesID", ItemDetails[k].salesID), new MySqlParameter("@DiscountOnMRP", ItemDetails[k].DiscountOnMRP),
                     new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                     new MySqlParameter("@EntryType", EntryType.ToUpper())
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
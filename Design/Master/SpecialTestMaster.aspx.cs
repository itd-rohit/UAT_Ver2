using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_Master_SpecialTestMaster : System.Web.UI.Page
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
    public static string getSpecialTest()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.TypeName ItemName,im.TestCode,st.ItemID,st.Rate,DATE_FORMAT(st.CreatedDate,'%d-%b-%Y %h:%i %p')AddedDate, ");
        sb.Append(" st.CreatedBy AddedBy,IFNULL(st.UpdatedBy,'')LastUpdatedBy,");
        sb.Append(" IF(IFNULL(st.UpdatedBy,'')<>'',DATE_FORMAT(st.UpdatedDate,'%d-%b-%Y %h:%i %p'),'')LastUpdatedDate ");
        sb.Append(" FROM  f_ItemMaster_Special st INNER JOIN f_ItemMaster im on im.ItemID=st.ItemID   ");
        sb.Append(" WHERE st.IsActive=1 ORDER BY st.ID+0");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return "";
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
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ItemID,Rate FROM  f_ItemMaster_Special").Tables[0];

            List<ItemData> specialItem = new List<ItemData>();
            specialItem = (from DataRow dr in dt.Rows
                           select new ItemData()
                           {
                               ItemID = Util.GetInt(dr["ItemID"]),
                           }).ToList();

            HashSet<int> sentIDs = new HashSet<int>(ItemDetails.Select(s => s.ItemID));

            specialItem = specialItem.Where(m => !sentIDs.Contains(m.ItemID)).ToList();

            string Item_ID = String.Join(",", specialItem.Select(a => String.Join(", ", a.ItemID)));
            if (Item_ID != "")
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ItemMaster_Special SET IsActive=0,UpdatedByID='" + UserInfo.ID + "',UpdatedDate=NOW(),UpdatedBy='" + UserInfo.LoginName + "' WHERE ItemID IN(" + Item_ID + ") ");

            for (int k = 0; k < ItemDetails.Count; k++)
            {
                DataRow[] fountRow = dt.Select("ItemID = '" + ItemDetails[k].ItemID + "'");
                if (fountRow.Length != 0)
                {
                    fountRow = dt.Select("ItemID = '" + ItemDetails[k].ItemID + "' AND Rate <> '" + ItemDetails[k].Rate + "'");
                    if (fountRow.Length != 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ItemMaster_Special SET Rate='" + ItemDetails[k].Rate + "',UpdatedByID='" + UserInfo.ID + "',UpdatedDate=NOW(),UpdatedBy='" + UserInfo.LoginName + "' WHERE ItemID='" + ItemDetails[k].ItemID + "'");
                    }
                    else
                    {
                    }
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO f_ItemMaster_Special(ItemID,Rate,CreatedByID,CreatedBy)VALUES('" + ItemDetails[k].ItemID + "','" + ItemDetails[k].Rate + "','" + UserInfo.ID + "','" + UserInfo.LoginName + "')");
                }
                //if (ItemDetails[k].IsOld == 1 && ItemDetails[k].IsRateChange == 1)
                //{
                //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ItemMaster_Special SET Rate='" + ItemDetails[k].Rate + "',UpdatedByID='" + UserInfo.ID + "',UpdatedDate=NOW(),UpdatedBy='" + UserInfo.LoginName + "' WHERE ItemID='" + ItemDetails[k].ItemID + "'");

                //}
                //else if(ItemDetails[k].IsNew == 1 && ItemDetails[k].IsRateChange == 0)
                //{
                //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO f_ItemMaster_Special(ItemID,Rate,CreatedByID,CreatedBy)VALUES('" + ItemDetails[k].ItemID + "','" + ItemDetails[k].Rate + "','" + UserInfo.ID + "','" + UserInfo.LoginName + "')");

                //}
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
        public double Rate { get; set; }
        public int IsNew { get; set; }
        public int IsOld { get; set; }
        public int IsRateChange { get; set; }
    }
}
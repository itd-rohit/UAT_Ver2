using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_Master_PanelShareMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindState(ddlState, "Select");
        }
    }

    [WebMethod]
    public static string bindDepartment()
    {
        return Util.getJson(StockReports.GetDataTable("SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='LSHHI3' ORDER BY NAME"));
    }

    [WebMethod]
    public static string bindPanel()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CONCAT(Company_Name,' = ',Panel_ID) Company_Name,Panel_ID FROM f_panel_master fpm where fpm.IsActive=1 and fpm.Payment_Mode='Credit' and AllowSharing=1 Order by fpm.Company_Name; "); 
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return "";
    }

    [WebMethod]
    public static string bindPanelShare(int PanelID, string Department)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.ItemID,im.TypeName ItemName,im.SubCategoryID, IFNULL(psi.SharePer,'')SharePer,IFNULL(psi.ShareAmt,'')ShareAmt,'" + PanelID + "' PanelID,'" + Department + "' DepartmentID  FROM f_itemmaster im ");
        sb.Append(" LEFT JOIN f_panel_share_items psi  ON im.ItemID=psi.ItemID AND psi.panel_ID='" + PanelID + "' AND psi.IsActive=1 ");
        sb.Append(" LEFT JOIN `f_panel_master_specialtest` ps ON ps.`ItemID`=im.`ItemID` AND ps.`IsVerified`= 1 AND ps.`Panel_ID`='" + PanelID + "' ");
        sb.Append(" WHERE im.isActive=1 ");
        if (Department != "0")
            sb.Append(" AND im.SubcategoryID='" + Department + "' ");
        sb.Append(" AND ps.ID IS NULL ");
        sb.Append(" ");
		System.IO.File.WriteAllText (@"C:\ankur_credit.txt",sb.ToString());
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return "";
    }

    [WebMethod]
    public static string savePanelShare(object ItemData)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            List<ShareItemData> ItemDetails = new JavaScriptSerializer().ConvertToType<List<ShareItemData>>(ItemData);

            ItemDetails = ItemDetails.Where(a => a.ShareAmt != null || a.SharePer != null).ToList();
 

            var shareDetails = ItemDetails.Select(d => new
            {
                ItemID = d.ItemID,
                PanelID = d.PanelID,
                Rate = d.Rate,
                DepartmentID = d.DepartmentID,
                SubCategoryID = d.SubCategoryID,
                ShareAmt = d.ShareAmt ?? 0,
                SharePer = d.SharePer ?? 0
            }).ToList();
            if (shareDetails.Count > 0)
            {
                if (shareDetails[0].DepartmentID == "0")
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM f_panel_share_items WHERE Panel_ID='" + shareDetails[0].PanelID + "'");
                else
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE psi.* FROM f_panel_share_items psi INNER JOIN f_itemmaster im ON psi.ItemID=im.ItemID WHERE psi.Panel_ID='" + shareDetails[0].PanelID + "' AND im.SubCategoryID='" + shareDetails[0].DepartmentID + "'");
                for (int k = 0; k < shareDetails.Count; k++)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO f_panel_share_items(Panel_ID,ItemID,SharePer,ShareAmt,CreatedBy,CreatedByID)");
                    sb.Append(" VALUES('" + shareDetails[k].PanelID + "','" + shareDetails[k].ItemID + "','" + Util.GetDouble(shareDetails[k].SharePer) + "','" + Util.GetDouble(shareDetails[k].ShareAmt) + "','" + UserInfo.LoginName + "','" + UserInfo.ID + "')");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
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

    public class ShareItemData
    {
        public int ItemID { get; set; }
        public double? Rate { get; set; }
        public int PanelID { get; set; }
        public double? SharePer { get; set; }
        public double? ShareAmt { get; set; }
        public string SubCategoryID { get; set; }
        public string DepartmentID { get; set; }
    }
}
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;

public partial class Design_Store_BudgetMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtBudgetMonth.Text = DateTime.Now.ToString("MMM-yy");
            calBudgetMonth.StartDate = DateTime.Now;
            txtBudgetMonth.Attributes.Add("readOnly", "readOnly");
        }
    }
    [WebMethod]
    public static string bindLocation(string CentreTypeID, string ZoneID, string StateID, string CityID)
    {
         StringBuilder sb = new StringBuilder();

         sb.Append(" SELECT loc.LocationID,loc.Location FROM centre_master cm ");
         sb.Append("  INNER JOIN  f_panel_master fpm  ON cm.centreid=fpm.CentreID AND fpm.PanelType='Centre' ");
         sb.Append("  INNER JOIN   st_locationmaster loc ON fpm.Panel_ID=loc.Panel_ID ");
        
         if (CentreTypeID != string.Empty)
            sb.Append(" AND cm.Type1ID IN (" + CentreTypeID + ")");
         if (ZoneID != string.Empty)
             sb.Append(" AND cm.BusinessZoneID IN (" + ZoneID + ")");
         if (StateID != string.Empty)
             sb.Append(" AND cm.StateID IN (" + StateID + ")");

         if (CityID != string.Empty)
             sb.Append(" AND cm.CityID IN (" + CityID + ")");
         using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
         {
             return Util.getJson(dt);
         }
    }

    [WebMethod]
    public static string bindBudgetMaster(string CentreTypeID, string ZoneID, string StateID, string LocationID, string BudgetDate)
    {
        BudgetDate ="01-"+ BudgetDate;
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT loc.LocationID,loc.Location,IFNULL(TrimZero(bm.BudgetAmount),'')BudgetAmount,IFNULL(DATE_FORMAT(bm.BudgetDate,'%b-%y'),'')BudgetDate, ");
        sb.Append("  IFNULL(bm.ID,0)BudgetID,IFNULL(DATE_FORMAT(bm1.BudgetDate,'%b-%y'),'')PreMonthBudget,IFNULL(TrimZero(bm1.BudgetAmount),'') PreMonthBudgetAmt ");
        sb.Append("  FROM centre_master cm  INNER JOIN  f_panel_master fpm  ON cm.centreid=fpm.CentreID AND fpm.PanelType='Centre' ");
        sb.Append("  INNER JOIN  st_locationmaster loc ON fpm.Panel_ID=loc.Panel_ID ");
        sb.Append("  LEFT JOIN   st_Budget_Master bm ON bm.LocationID=loc.LocationID  AND bm.BudgetDate='"+Util.GetDateTime(BudgetDate).ToString("yyyy-MM-dd")+"' ");
        sb.Append("  LEFT JOIN   st_Budget_Master bm1 ON bm1.LocationID=loc.LocationID  AND bm1.BudgetDate='" + Util.GetDateTime(BudgetDate).AddMonths(-1).ToString("yyyy-MM-dd") + "' ");
        if (CentreTypeID != string.Empty)
            sb.Append(" AND cm.Type1ID IN (" + CentreTypeID + ")");

        if (ZoneID != string.Empty)
            sb.Append(" AND cm.BusinessZoneID IN (" + ZoneID + ")");
        if (StateID != string.Empty)
            sb.Append(" AND cm.StateID IN (" + StateID + ")");
        if (LocationID != string.Empty)
            sb.Append(" AND loc.LocationID IN (" + LocationID + ")");

       
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            return Util.getJson(dt);
        }
    }
    [WebMethod(EnableSession = true)]
    public static string saveBudget(List<Budget> BudgetMaster)
    {
        var BudgetData = BudgetMaster.Where(s => string.IsNullOrWhiteSpace(Util.GetString(s.BudgetAmount)) || Util.GetDecimal(s.BudgetAmount) == 0).ToList();
        if (BudgetData.Count > 0)
        {

            var oSerializer = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(new { BudgetAmountValidation = BudgetData.Select(s => s.tableSNo) }); 
            return oSerializer;
        }

        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    if (BudgetMaster.Count > 0)
                    {
                        for (int i = 0; i < BudgetMaster.Count; i++)
                        {
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "INSERT INTO st_Budget_Master(LocationID,BudgetAmount,BudgetDate,CreatedByID,CreatedBy)VALUES(@LocationID,@BudgetAmount,@BudgetDate,@CreatedByID,@CreatedBy)",
                                new MySqlParameter("@LocationID", BudgetMaster[i].LocationID), new MySqlParameter("@BudgetAmount", BudgetMaster[i].BudgetAmount),
                                new MySqlParameter("@BudgetDate",Util.GetDateTime( BudgetMaster[i].BudgetDate).ToString("yyyy-MM-dd")), new MySqlParameter("@CreatedByID", UserInfo.ID),
                                new MySqlParameter("@CreatedBy", UserInfo.LoginName)
                                );
                        }
                    }
                    Tnx.Commit();
                    return "1";
                }
                catch (Exception ex)
                {
                    Tnx.Rollback();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return "0";
                }
                finally
                {
                    con.Close();
                }
            }

        }
    }
    public class Budget
    {

        public decimal BudgetAmount { get; set; }
        public int LocationID { get; set; }
        public string BudgetDate { get; set; }
        public int tableSNo { get; set; }
    }
}
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Investigation_PackageRateMaster : System.Web.UI.Page
{


    protected void Page_Load(object sender, EventArgs e)
    {
        string ItemID = Request.QueryString["itemid"].ToString();
        if (!IsPostBack)
        {

            lblpackage.Text = StockReports.ExecuteScalar("SELECT CONCAT(im.`TestCode`,'~',plb.`Name`) NAME FROM packagelab_master plb  INNER JOIN f_itemmaster im  ON im.`Type_ID`=plb.`PlabID` WHERE plb.`PlabID`='" + ItemID + "'");
            lblItemID.Text = ItemID;
        }
    }
    [WebMethod]
    public static string bindPanel()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT CONCAT(fpm.panel_code,' ~ ',fpm.Company_Name) NAME,CONCAT(fpm.Panel_ID,'#',fpm.ReferenceCode)Panel_ID FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID AND cm.IsActive=1 AND fpm.`Panel_ID`=fpm.`ReferenceCode` AND fpm.PanelType='Centre' "));
    }



    [WebMethod(EnableSession = true)]
    public static string SaveItemWisePanelRate(string ItemID, string PackageRate, string PRate, string PanelId, List<Allitem> Allitem)
    {

        if (Util.GetDecimal(PackageRate) != Util.GetDecimal(PackageRate))
        {
            return "Package Rate and Total Rate is Different";
        }

        decimal totalRate = Allitem.Sum(item => Util.GetDecimal(item.Rate));

        if (Util.GetDecimal(Allitem.Sum(item => Util.GetDecimal(item.Rate))) != Util.GetDecimal(PackageRate))
        {
            return "Package Rate and Total Rate is Different";
        }

        if (Allitem.Any(item => item.Rate == null) || Allitem.Any(item => item.Rate == string.Empty) || Allitem.Any(item => item.Rate == "0"))
        {
            return "Please Enter Package Item Rate";
        }
        if (Allitem.Any(item => item.Per == null) || Allitem.Any(item => item.Per == string.Empty) || Allitem.Any(item => item.Per == "0"))
        {
            return "Please Enter Package Item Percentage";
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            // string PackageItem_ID = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT ItemID  FROM f_itemmaster WHERE Type_ID='" + Util.GetString(PackageItemId) + "'"));
            string str = string.Empty;

            int rateUpdate = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT COUNT(1) FROM f_ratelist WHERE ItemID=@ItemID AND Panel_ID=@Panel_ID AND Rate=@Rate",
               new MySqlParameter("@ItemID", ItemID), new MySqlParameter("@Panel_ID", PanelId.Split('#')[1]),
               new MySqlParameter("@Rate", PRate)));

            if (rateUpdate == 0)
            {

                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "DELETE FROM f_ratelist WHERE ItemID =@ItemID AND  Panel_ID=@Panel_ID",
                    new MySqlParameter("@ItemID", ItemID), new MySqlParameter("@Panel_ID", PanelId.Split('#')[1]));

                RateList objRateList = new RateList(Tnx);
                objRateList.Panel_ID = Util.GetInt(PanelId.Split('#')[1]);
                objRateList.ItemID = Util.GetInt(ItemID);
                objRateList.Rate = Util.GetDecimal(PRate);
                objRateList.ERate = 0;
                objRateList.IsTaxable = Util.GetInt("0");
                objRateList.FromDate = DateTime.Now;
                objRateList.ToDate = DateTime.Now;
                objRateList.IsCurrent = 1;
                objRateList.IsService = "YES";
                objRateList.ItemDisplayName = string.Empty;
                objRateList.ItemCode = string.Empty;
                objRateList.MrpRate = Util.GetDecimal(0);
                objRateList.UpdateBy = HttpContext.Current.Session["LoginName"].ToString();
                objRateList.UpdateRemarks = "PackageRateMaster";
                objRateList.UpdateDate = System.DateTime.Now;
                objRateList.Insert();
            }



            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "DELETE FROM f_ratelist_PackageDetails WHERE PackageItemID =@PackageItem_ID AND  PanelID=@PanelID",
                new MySqlParameter("@PackageItem_ID", ItemID), new MySqlParameter("@PanelID", PanelId));

            for (int i = 0; i < Allitem.Count; i++)
            {
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "INSERT INTO f_ratelist_PackageDetails(PackageItemID,PackageRate,TestItemId,PanelId,TestRate,TestPer,CreatedByID,IsBaseRate)VALUES(@PackageItemID,@PackageRate,@TestItemId,@PanelId,@TestRate,@TestPer,@CreatedByID,1) ",
                                         new MySqlParameter("@PackageItemID", ItemID),
                                         new MySqlParameter("@PackageRate", Util.GetDouble(PackageRate)),
                                         new MySqlParameter("@TestItemId", Allitem[i].TestItemId),
                                         new MySqlParameter("@PanelId", Util.GetString(PanelId.Split('#')[0])),
                                         new MySqlParameter("@TestRate", Allitem[i].Rate), new MySqlParameter("@CreatedByID", UserInfo.ID),
                                         new MySqlParameter("@TestPer", Allitem[i].Per));
            }

          //  MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "DELETE FROM f_ratelist_PackageDetails WHERE PackageItemID=@PackageItemID AND IsBaseRate=0 ",
          //     new MySqlParameter("@PackageItemID", ItemID));

            StringBuilder sb = new StringBuilder();

            sb.Append(" INSERT INTO f_ratelist_PackageDetails(PackageItemID,PackageRate,PanelId,TestItemId,TestRate,TestPer,CreatedByID,IsBaseRate) ");
            sb.Append(" SELECT @PackageItemID,pm.Rate,pm.Panel_ID,im.ItemID TestItemId,ROUND(pm.Rate * frp.TestPer * 0.01,2),frp.TestPer,@CreatedByID,0 IsBaseRate ");
            sb.Append(" FROM `package_labdetail` pld  ");
            sb.Append(" INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=pld.`InvestigationID` ");
            sb.Append(" INNER JOIN f_itemmaster im  ON im.`Type_ID`=inv.`Investigation_Id` ");
            sb.Append(" INNER JOIN f_ratelist_PackageDetails frp  ON frp.PackageItemID=pld.PlabID AND frp.TestItemID=im.ItemID AND IsBaseRate=1 ");
            sb.Append(" AND pld.`PlabID`=@PackageItemID    ");
            sb.Append("    CROSS JOIN  ");
            sb.Append(" (SELECT Panel_ID,Rate FROM f_ratelist WHERE ItemID=@PackageItemID AND Rate>0 AND Panel_ID<>@Panel_ID)  pm   ");
            sb.Append(" ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@PackageItemID", ItemID), new MySqlParameter("@Panel_ID", PanelId.Split('#')[0]), new MySqlParameter("@CreatedByID", UserInfo.ID));


            Tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "Error Occurred";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindRate(string ItemID, string PanelID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            string rate = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT rate FROM f_ratelist WHERE Panel_ID=@Panel_ID AND ItemID=@ItemID",
                new MySqlParameter("@ItemID", ItemID), new MySqlParameter("@Panel_ID", PanelID.Split('#')[1])).ToString();

            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT '" + rate + "' prate,  ");
            sb.Append(" im.testcode, im.`ItemID`, PlabId,PrintSeprate,im.`TypeName` Investigation,pld.SampleDefinedPackage,IFNULL(rpd.`TestRate`,0)TestRate, ");
            sb.Append(" IFNULL(rpd.`TestPer`,0)TestPer,IFNULL(rpd.`PackageRate`, 0) PackageRate,IFNULL(rat.Rate,0)MRP,0 MRPPer   FROM `package_labdetail` pld ");
            sb.Append(" INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=pld.`InvestigationID` ");
            sb.Append(" INNER JOIN f_itemmaster im  ON im.`Type_ID`=inv.`Investigation_Id` ");
            sb.Append(" LEFT JOIN f_ratelist rat  ON rat.`ItemID`=im.`ItemID` AND rat.Panel_ID='79' ");
            sb.Append(" LEFT JOIN f_ratelist_PackageDetails rpd    ON rpd.`TestItemId`=inv.`Investigation_Id` AND rpd.`PackageItemID`=pld.`PlabID` AND rpd.`PanelId`=@PanelID AND rpd.IsBaseRate=1");
            sb.Append(" WHERE pld.`PlabID`=@PlabID  ORDER BY Priority+1;  ");

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
              new MySqlParameter("@PlabID", ItemID), new MySqlParameter("@PanelID", PanelID.Split('#')[1])).Tables[0];
            Double totalMRP = 0;
            if (dt.Rows.Count > 0)
            {

                totalMRP = dt.AsEnumerable().Sum(x => x.Field<Double>("MRP"));
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                 dt.Rows[i]["MRPPer"] = Util.GetString(Math.Round(Util.GetDouble(Util.GetDouble(dt.Rows[i]["MRP"].ToString()) * 100) / totalMRP,3,MidpointRounding.AwayFromZero));

                }
                dt.AcceptChanges();
            }
            return Util.getJson(new { dt = dt, totalMRP = totalMRP });

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

    public class Allitem
    {
        public string TestItemId { get; set; }
        public string TestCode { get; set; }
        public string Rate { get; set; }
        public string Per { get; set; }


    }

}
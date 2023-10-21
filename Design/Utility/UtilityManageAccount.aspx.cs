using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Utility_UtilityManageAccount : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            dtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindcentrepanel();           
        }        
    }
    private void bindcentrepanel()
    {
        lstCentreAccess.DataSource = StockReports.GetDataTable("SELECT centreid,centre FROM utility_centremaster WHERE isActive=1 ORDER BY centre ");
        lstCentreAccess.DataTextField = "centre";
        lstCentreAccess.DataValueField = "centreid";
        lstCentreAccess.DataBind();

        ddlPanel.DataSource = StockReports.GetDataTable("SELECT Panel_ID,Company_Name AS Panel  FROM utility_panelmaster  WHERE isActive=1 order by Company_Name");
        ddlPanel.DataTextField = "Panel";
        ddlPanel.DataValueField = "Panel_ID";
        ddlPanel.DataBind();
    }
    [WebMethod]
    public static string Search(string FromDate, string ToDate, string DiscType, string CentreID, string PanelID)
    {       
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT Description,SubCategoryID,ROUND(SUM(Rate*Quantity)) GrossAmt,ROUND(SUM(DiscountAmt)) Discount,ROUND(SUM(amount)) NetAmount  ");
            sb.Append(" FROM UtilityTransaction_AccountData WHERE DATE >=@FromDate AND DATE<=@ToDate ");

            if (DiscType != "0")
            {
            if (DiscType == "1")
                sb.Append(" and DiscountAmt>0 ");

             if (DiscType == "2")
                sb.Append(" and DiscountAmt=0 ");
            }

            if (CentreID != string.Empty)
                sb.Append(" AND CentreID IN (" + CentreID + ") ");

            if (PanelID != string.Empty)
                sb.Append(" AND Panel_ID IN (" + PanelID + ") ");

            sb.Append("  GROUP BY SubCategoryID ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@FromDate", string.Concat(Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"), " 00:00:00")),
                new MySqlParameter("@ToDate", string.Concat(Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"), " 23:59:59"))).Tables[0])
            {
                return JsonConvert.SerializeObject(new { status = true, response = dt });
            }           
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string SaveAdjustAmt(List<savedata> data, string CentreID, string PanelID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            if (Util.GetDateTime(data[0].ToDate) > DateTime.Now.AddDays(-5))
            {
              //  return JsonConvert.SerializeObject(new { status = false, response = "You can process data only 5 Days older." });
            }
            float ReduceBy = 0;
            for (int i = 0; i < data.Count; i++)
            {
                if (data[i].SubcategoryID == string.Empty)
                {
                    ReduceBy = Util.GetFloat(data[i].AdjustedAmt);
                    ReduceBy = Util.GetFloat(data[i].NetAmount) * ReduceBy / 100;
                }
                else
                {
                    ReduceBy = Util.GetFloat(data[i].AdjustedAmt);
                }
                StringBuilder sb = new StringBuilder();
                //sb.Append(" DROP TABLE IF EXISTS upd_account;  ");

                //sb.Append("  SET @runtot:=0;  ");
                //sb.Append(" CREATE TABLE upd_account  ");
                //sb.Append("  SELECT tt.*,im.Rate newRate,im.TypeName newItem,im.SubCategoryID newSubcategoryID,im.Description newDescription,IF((@runtot := @runtot + (tt.netAmount- im.`Rate`))<=" + ReduceBy + ",0,1) AS upisSync FROM   ");
                //sb.Append("  (SELECT ua.*,(SELECT itm.itemid FROM `utility_itemmaster` itm WHERE itm.`Panel_ID`=ua.`Panel_ID`   ");
                //sb.Append("  AND itm.`isReplacewith`=1 ORDER BY RAND() LIMIT 1) newItemID  ");
                //sb.Append("  FROM utility_accountdata ua                      ");
                //sb.Append("  INNER JOIN utility_itemmaster im ON im.ItemID=ua.ItemID     WHERE ua.CentreID IN (" + CentreID + ") ");
                //sb.Append("  AND ua.Panel_ID IN (" +PanelID + ")  AND ua.DATE>=@FromDate AND ua.DATE<=@ToDate   ");
                //sb.Append("  AND ua.NetAmount=ua.Adjustment AND ua.AmtCredit=0  AND im.Panel_ID=ua.Panel_ID      ");
                //sb.Append("  AND ua.AmtCheque=0 AND ua.AmtCreditCard=0  AND ua.amtcash>0   AND ua.isCancel=0  AND ua.NetAmount>0          ");


                //if (data[i].DiscType != "0")
                //{
                //    if (data[i].DiscType == "1")
                //        sb.Append(" and ua.DiscountAmt>0 ");

                //    if (data[i].DiscType == "2")
                //        sb.Append(" and ua.DiscountAmt=0 ");
                //}
                //if (data[i].SubcategoryID != string.Empty)
                //{
                //    sb.Append(" and ua.SubCategoryID='" + data[i].SubcategoryID + "' ");
                //}

                //sb.Append("    GROUP BY ua.`LedgerTransactionNo`   ");


                //sb.Append("  HAVING (COUNT(*)=SUM(im.isReplaceable))       ");
                //sb.Append("  ORDER BY ROUND(ua.`NetAmount`) DESC)tt   ");
                //sb.Append("  INNER JOIN `utility_itemmaster` im ON im.`Panel_ID`=tt.panel_id AND im.`ItemID`=tt.newItemID   ");
                //sb.Append("  AND tt.netAmount-im.`Rate`>0;  ");


                //sb.Append(" DELETE ua.* FROM  utility_accountdata ua   ");
                //sb.Append(" INNER JOIN upd_account upd ON ua.LedgerTransactionNo=upd.LedgerTransactionNo where upd.upisSync=0;   ");

                //sb.Append(" INSERT INTO utility_accountdata  ");
                //sb.Append(" (ID,LedgerTransactionNo,PName,Panel_ID,CentreID,Quantity,NetAmount,DiscountOnTotal,GrossAmount,Adjustment,AmtCash,AmtCheque,AmtCredit,AmtCreditCard,TypeOfTnx,DATE,Description,SubCategoryID,ItemID,ItemName,Rate,DiscountPercentage,Amount,isCancel,isSync,TestDone)  ");
                //sb.Append(" SELECT ID,LedgerTransactionNo,PName,Panel_ID,CentreID,Quantity,newRate NetAmount,'0' DiscountOnTotal,newRate GrossAmount,newRate Adjustment,  ");
                //sb.Append(" newRate AmtCash,AmtCheque,AmtCredit,AmtCreditCard,TypeOfTnx,DATE,newDescription Description,newSubcategoryID SubCategoryID,newItemID ItemID,newItem ItemName,newRate Rate,'0' DiscountPercentage,newRate Amount,isCancel,upisSync,'1' TestDone FROM upd_account  where upisSync=0;  ");

                sb.Append(" DROP TABLE IF EXISTS upd_account;  ");

                sb.Append("  SET @runtot:=0;  ");
                sb.Append(" CREATE TABLE upd_account  ");
                sb.Append("  SELECT tt.*,im.Rate newRate,im.TypeName newItem,im.SubCategoryID newSubcategoryID,im.Description newDescription,IF((@runtot := @runtot + (tt.netAmount- im.`Rate`))<=" + ReduceBy + ",0,1) AS upisSync FROM   ");
                sb.Append("  (SELECT ua.*,(SELECT itm.itemid FROM `utility_itemmaster` itm WHERE itm.`Panel_ID`=ua.`Panel_ID`   ");
                sb.Append("  AND itm.`isReplacewith`=1 ORDER BY RAND() LIMIT 1) newItemID  ");
                sb.Append("  FROM UtilityTransaction_AccountData ua                      ");
                sb.Append("  INNER JOIN utility_itemmaster im ON im.ItemID=ua.ItemID     WHERE ua.CentreID IN (" + CentreID + ") ");
                sb.Append("  AND ua.Panel_ID IN (" + PanelID + ")  AND ua.DATE>=@FromDate AND ua.DATE<=@ToDate   ");
                sb.Append("  AND ua.NetAmount=ua.Adjustment AND ua.IsCredit=0  AND im.Panel_ID=ua.Panel_ID      ");
                sb.Append("  AND ua.AmtCheque=0 AND ua.AmtCreditCard=0  AND ua.AmtCash>0   AND ua.NetAmount>0          ");


                if (data[i].DiscType != "0")
                {
                    if (data[i].DiscType == "1")
                        sb.Append(" and ua.DiscountAmt>0 ");

                    if (data[i].DiscType == "2")
                        sb.Append(" and ua.DiscountAmt=0 ");
                }
                if (data[i].SubcategoryID != string.Empty)
                {
                    sb.Append(" and ua.SubCategoryID='" + data[i].SubcategoryID + "' ");
                }

                sb.Append("    GROUP BY ua.`LedgerTransactionNo`   ");


                sb.Append("  HAVING (COUNT(*)=SUM(im.isReplaceable))       ");
                sb.Append("  ORDER BY ROUND(ua.`NetAmount`) DESC)tt   ");
                sb.Append("  INNER JOIN `utility_itemmaster` im ON im.`Panel_ID`=tt.panel_id AND im.`ItemID`=tt.newItemID   ");
                sb.Append("  AND tt.netAmount-im.`Rate`>0;  ");


                sb.Append(" DELETE ua.* FROM  UtilityTransaction_AccountData ua   ");
                sb.Append(" INNER JOIN upd_account upd ON ua.LedgerTransactionNo=upd.LedgerTransactionNo where upd.upisSync=0;   ");

                sb.Append(" INSERT INTO UtilityTransaction_AccountData  ");
                sb.Append(" (Test_ID,LedgerTransactionNo,PName,Panel_ID,CentreID,Quantity,NetAmount,DiscountOnTotal,GrossAmount,Adjustment,AmtCash,AmtCheque,AmtCredit,AmtCreditCard,DATE,Description,SubCategoryID,ItemID,ItemName,Rate,DiscountAmt,Amount,isSync,TestDone)  ");
                sb.Append(" SELECT Test_ID,LedgerTransactionNo,PName,Panel_ID,CentreID,Quantity,newRate NetAmount,'0' DiscountOnTotal,newRate GrossAmount,newRate Adjustment,  ");
                sb.Append(" newRate AmtCash,AmtCheque,AmtCredit,AmtCreditCard,DATE,newDescription Description,newSubcategoryID SubCategoryID,newItemID ItemID,newItem ItemName,newRate Rate,'0' DiscountAmt,newRate Amount,upisSync,'1' TestDone FROM upd_account  where upisSync=0;  ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@FromDate", string.Concat(Util.GetDateTime(data[i].FromDate).ToString("yyyy-MM-dd"), " 00:00:00")),
                    new MySqlParameter("@ToDate", string.Concat(Util.GetDateTime(data[i].ToDate).ToString("yyyy-MM-dd"), " 23:59:59")));
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
       
    }
    [WebMethod]
    public static string untouchabletestlist(string TestType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string strquery = "SELECT it.ItemID,it.TypeName,it.SubCategoryID,'' Rate,it.Description FROM utility_itemmaster it where it.isReplaceable=@isReplaceable and it.Panel_id='78'  order by TypeName";
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, strquery,
                new MySqlParameter("@isReplaceable", Util.GetInt(TestType))).Tables[0])
            {
                return JsonConvert.SerializeObject(new { status = true, response = dt });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string UpdateisReplaceable(string ItemID, string Type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string changeval = "";
            if (Type == "0")
                changeval = "1";
            if (Type == "1")
                changeval = "0";

            string strquery = "update utility_itemmaster set isReplaceable=@isReplaceable where itemID=@itemID";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, strquery,
                new MySqlParameter("@isReplaceable",Util.GetInt(changeval)),
                new MySqlParameter("@itemID", ItemID));
            return JsonConvert.SerializeObject(new { status = true, response = "Added into Touchable Test List" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string AddtoUntouchableList(string ItemID, string Type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {           
            string strquery = "update utility_itemmaster set isReplaceable=@isReplaceable where itemID in(" + ItemID + ")";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, strquery,
                new MySqlParameter("@isReplaceable", Util.GetInt(Type)));
            return JsonConvert.SerializeObject(new { status = true, response = "Added into UnTouchable Test List" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string bindtouchabletestlist(string Type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string changeval = "";
            if (Type == "0")
                changeval = "1";
            if (Type == "1")
                changeval = "0";
            string strquery = "SELECT ItemID,TypeName FROM utility_itemmaster where isReplaceable=@isReplaceable and Panel_id='78'   order by TypeName";
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, strquery,
                new MySqlParameter("@isReplaceable", Util.GetInt(changeval))).Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(null);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string uploadfinaldata(string UserName, string Password)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            if (UserName != "ItDose")
                return JsonConvert.SerializeObject(new { status = false, response = "Username is not correct" });
            if (Password != "p@ssw0rd")
                return JsonConvert.SerializeObject(new { status = false, response = "Password is not correct" });

            StringBuilder sb = new StringBuilder();
            sb.Append(" DROP TABLE IF EXISTS upd_final;  " + "\r\n");
            sb.Append(" CREATE TABLE upd_final   " + "\r\n");
            sb.Append(" SELECT * FROM UtilityTransaction_AccountData WHERE isSync=0;  " + "\r\n");
            sb.Append(" ALTER TABLE upd_final ADD INDEX LedgerTransactionNo (LedgerTransactionNo);  " + "\r\n");
            sb.Append(" ALTER TABLE upd_final ADD INDEX ItemID (ItemID);  " + "\r\n");
            sb.Append(" CALL Utility_validate_Db(); ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Uploaded Data Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = ex.GetBaseException().ToString() });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public class savedata
    {
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string DiscType { get; set; }      
        public string AdjustedAmt { get; set; }
        public string NetAmount { get; set; }
        public string SubcategoryID { get; set; }
    }
}
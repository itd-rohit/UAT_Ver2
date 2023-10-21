using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Linq;
public partial class LedgerReportCashPUP : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtfromdate, txttodate);
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            if (UserInfo.RoleID == 1)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script1", "showAccountSearch();", true);


            }
        }
    }


    [WebMethod]
    public static string searchLedger(string PanelID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] PanelIDTags = PanelID.Split(',');
            string[] PanelIDNames = PanelIDTags.Select((s, i) => "@tag" + i).ToArray();
            string PanelIDClause = string.Join(", ", PanelIDNames);
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("SELECT pm.Panel_Code PanelCode,pm.Panel_ID, pm.company_name PanelName,pm.`State`,pm.`City`,pm.Zone,DATE_FORMAT(pm.Creatordate,'%d-%b-%Y')CreatorDate,");
            sb.AppendLine(" TRIM( LEADING ',' FROM CONCAT(IFNULL(pm.Phone,''),', ',IFNULL(pm.Mobile,'')))Mobile, pm.CreditLimit , ");
            sb.AppendLine(" IF(IFNULL(pm.MaxExpiry,'')='','',DATE_FORMAT(pm.MaxExpiry,'%d-%b-%Y %H:%i'))MaxExpiry,   ");
            sb.AppendLine(" pm.`IsBookingLock` IsBlockPanelBooking,pm.`IsPrintingLock` IsBlockPanelReporting,pm.Payment_Mode,IF( pm.TaxPercentage=0,10,pm.TaxPercentage)TaxPercentage ,  "); 
            sb.AppendLine(" (CASE  ");
            sb.AppendLine(" WHEN pm.`showBalanceAmt` ='0' THEN 'Open (Master not set)'     ");
            sb.AppendLine(" WHEN pm.`IsBookingLock`='1' AND pm.`showBalanceAmt` ='1'  AND pm.MaxExpiry < NOW() THEN 'Lock (Manual Lock)'    ");
            sb.AppendLine(" WHEN pm.MaxExpiry >= NOW() AND pm.`showBalanceAmt` ='1'  THEN CONCAT('Open (Manual open till ',MaxExpiry,')')   ");
            sb.AppendLine(" WHEN  pm.MaxExpiry < NOW() AND (-1)*pm.creditlimit >  ROUND(IFNULL(BalanceAmt,0)) THEN 'Lock (Auto Lock)'     ");
            sb.AppendLine(" ELSE 'Open' END )isLock "); 
            sb.AppendLine(" ,aa.BalanceAmt     ");
            sb.AppendLine(" FROM   f_panel_master pm  INNER JOIN employee_master em ON em.Employee_ID=pm.SalesManagerID ");
            sb.AppendLine(" AND pm.Payment_Mode='Cash'  "); 
            if (PanelID != string.Empty)
                sb.Append(" AND pm.`Panel_ID` IN ({0}) ");
            sb.AppendLine("  INNER JOIN  ( SELECT SUM(`Adjustment` - `NetAmount`)BalanceAmt,Panel_ID FROM `f_ledgertransaction` WHERE ");
            if (PanelID != string.Empty)
                sb.AppendLine(" `Panel_ID` IN ({0}) AND "); 
            sb.AppendLine("    `IsCredit`=0  GROUP BY Panel_ID ");
            sb.AppendLine("   ) aa  ON pm.panel_ID=aa.Panel_ID ORDER BY pm.company_name; ");

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), PanelIDClause), con))
            {
                for (int i = 0; i < PanelIDNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(PanelIDNames[i], PanelIDTags[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                        return Util.getJson(dt);
                    else
                        return null;
                }
            }
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
    public static string bindPanel(int BusinessZoneID, int StateID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (BusinessZoneID == 0)
                BusinessZoneID = Util.GetInt(StockReports.ExecuteScalar(string.Format("SELECT BusinessZoneID FROM state_master WHERE ID='{0}' AND IsActive=1 ORDER BY state", StateID)));
            sb.Append(" SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,fpm.Panel_ID FROM f_panel_master fpm ");
            sb.Append(" WHERE fpm.Payment_Mode='Cash'  ");
            if (BusinessZoneID!=0)
            sb.Append(" and fpm.TagProcessingLabID IN (SELECT CentreID FROM centre_master WHERE  BusinessZoneID=@BusinessZoneID");
            if (StateID != -1)
                sb.Append("  AND StateID=@StateID ");  
            sb.Append(" ORDER BY fpm.Company_Name");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@StateID", StateID),
                  new MySqlParameter("@BusinessZoneID", BusinessZoneID)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return Util.getJson(dt);
                else
                    return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod]
    public static string ExcelExport(string PanelID, string datewithtime, string Todatewithtime)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] PanelIDTags = PanelID.Split(',');
            string[] PanelIDNames = PanelIDTags.Select((s, i) => "@tag" + i).ToArray();
            string PanelIDClause = string.Join(", ", PanelIDNames);
            StringBuilder sb = new StringBuilder();
            datewithtime = Util.GetDateTime(datewithtime).ToString("yyyy-MM-dd") + " 00:00:00";
            Todatewithtime = Util.GetDateTime(Todatewithtime).ToString("yyyy-MM-dd") + " 23:59:59";


            sb.Append("  SELECT pm.Panel_Code PanelCode,pm.Panel_ID, pm.company_name PanelName,cm.`State`,cm.`City`,cm.Zone,    ");
            sb.Append(" 'PUP' SearchType, ");
            sb.Append(" ROUND((IFNULL(ReceivedAmtOpening,0) - IFNULL(BookingOpening,0)),0)`ClosingBalance`,DATE_FORMAT(pm.Creatordate,'%d-%b-%Y')CreatorDate,    ");
            sb.Append(" TRIM( LEADING ',' FROM CONCAT(IFNULL(pm.Phone,''),', ',IFNULL(pm.Mobile,'')))Mobile,  ");
            sb.Append(" pm.Payment_Mode,  ");
            sb.Append(" ROUND(IFNULL(BookingCurrent,0))`CurrentBusiness`,ROUND(IFNULL(ReceivedAmtCurrent,0))`ReceivedAmount`,  ");
            sb.Append(" ROUND((IFNULL(t.ReceivedAmtOpening,0)+IFNULL(t.ReceivedAmtCurrent,0)-IFNULL(t.BookingOpening,0)-IFNULL(t.BookingCurrent,0)))`TotalOutstanding`  "); 
            sb.Append(" FROM   ");
            sb.Append(" f_panel_master pm    ");

            //--  for PUP Search

            sb.Append(" INNER JOIN centre_master cm ON cm.centreid=pm.TagProcessingLabID  AND pm.PanelType='PUP'  ");
            if (PanelID != string.Empty)
                sb.Append("  AND pm.Panel_ID IN ({0})  ");
            sb.Append(" LEFT JOIN   ");
            sb.Append(" ( ");
            sb.Append(" SELECT PanelID,SUM(BookingOpening)BookingOpening,SUM(BookingCurrent)BookingCurrent, SUM(ReceivedAmtOpening)ReceivedAmtOpening,SUM(ReceivedAmtCurrent)ReceivedAmtCurrent,SUM(Ageing)Ageing  ");
            sb.Append(" FROM (  ");
            sb.Append(" SELECT pnl.`Panel_ID` PanelID,SUM(lt.`NetAmount`)BookingOpening,0 BookingCurrent, 0 ReceivedAmtOpening,0 ReceivedAmtCurrent, 0 Ageing  ");
            sb.Append(" FROM  `f_ledgertransaction` lt  ");
            sb.Append(" INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=lt.`Panel_ID` AND pnl.`PanelType`='PUP' AND lt.`IsCredit`=0  ");
            sb.Append("   ");
            sb.Append("  AND lt.Date < @datewithtime  ");
            if (PanelID != string.Empty)
                sb.Append("     AND pnl.`Panel_ID` IN ({0})  ");
            sb.Append(" GROUP BY pnl.`Panel_ID`  ");

            sb.Append("  UNION ALL   ");

            sb.Append(" SELECT pnl.`InvoiceTo` PanelID,0 BookingOpening, SUM(lt.`NetAmount`)BookingCurrent, 0 ReceivedAmtOpening,0 ReceivedAmtCurrent, 0 Ageing  ");
            sb.Append(" FROM  `f_ledgertransaction` lt  ");
            sb.Append(" INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=lt.`Panel_ID` AND pnl.`PanelType`='PUP' AND lt.`IsCredit`=0  ");
            sb.Append("   ");
            sb.Append("  AND lt.Date >= @datewithtime  ");
            sb.Append("  AND lt.Date <= @Todatewithtime  ");
            if (PanelID != string.Empty)
                sb.Append("  AND pnl.`Panel_ID` IN ({0})  ");
            sb.Append(" GROUP BY pnl.`Panel_ID`  ");

            sb.Append(" UNION ALL  ");

            sb.Append(" SELECT pnl.`Panel_ID` PanelID,0 BookingOpening,0 BookingCurrent, IFNULL(SUM(r.`Amount`),0) ReceivedAmtOpening,0 ReceivedAmtCurrent, 0 Ageing  ");
            sb.Append(" FROM  `f_ledgertransaction` lt  ");
            sb.Append(" INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=lt.`Panel_ID` AND pnl.`PanelType`='PUP' AND lt.`IsCredit`=0  ");
            sb.Append(" INNER JOIN `f_reciept` r ON r.`LedgerTransactionID`=lt.`LedgerTransactionID` AND r.`IsCancel`=0   ");
            sb.Append("  AND r.EntryDateTime < @datewithtime  ");
            if (PanelID != string.Empty)
                sb.Append("       AND pnl.Panel_ID IN ({0})  ");
            sb.Append(" GROUP BY pnl.`Panel_ID` ");

            sb.Append(" UNION ALL  ");

            sb.Append(" SELECT pnl.`Panel_ID` PanelID,0 BookingOpening,0 BookingCurrent, 0 ReceivedAmtOpening, IFNULL(SUM(r.`Amount`),0) ReceivedAmtCurrent, 0 Ageing  ");
            sb.Append(" FROM  `f_ledgertransaction` lt  ");
            sb.Append(" INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=lt.`Panel_ID` AND pnl.`PanelType`='PUP' AND lt.`IsCredit`=0  ");
            sb.Append(" INNER JOIN `f_reciept` r ON r.`LedgerTransactionID`=lt.`LedgerTransactionID` AND r.`IsCancel`=0   ");
            sb.Append("  AND r.EntryDateTime >= @datewithtime  ");
            sb.Append("  AND r.EntryDateTime <= @Todatewithtime  ");
            if (PanelID != string.Empty)
                sb.Append("       AND pnl.Panel_ID IN ({0})  ");
            sb.Append(" GROUP BY pnl.`Panel_ID` ");
            sb.Append(" ) aa GROUP BY PanelID   ");
            sb.Append(" ) t ON t.PanelId=pm.`Panel_ID`  ");
            sb.Append(" ORDER BY cm.`BusinessZoneID`,cm.`State`,cm.`City`, pm.`Company_Name` ");
            System.IO.File.WriteAllText(@"F:\Errorlog\LedgerReport_Cash.txt", sb.ToString());

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), PanelIDClause), con))
            {
                for (int i = 0; i < PanelIDNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(PanelIDNames[i], PanelIDTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@datewithtime", datewithtime);
                da.SelectCommand.Parameters.AddWithValue("@Todatewithtime", Todatewithtime);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        HttpContext.Current.Session["dtExport2Excel"] = dt;
                        HttpContext.Current.Session["ReportName"] = "Ledger Status For Cash PUP";
                        HttpContext.Current.Session["Period"] = "";
                        return "1";
                    }
                    else
                    {

                        return "0";
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
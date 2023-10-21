using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Linq;
public partial class Design_Invoicing_LedgerStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            if (UserInfo.RoleID == 1)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script1", "showAccountSearch();", true);


            }
        }
    }

    [WebMethod]
    public static string SaveUpdation(string PanelID, string setLock, string txtTimeLimit, string ddlTime, string LockUnLockReason)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {


            DateTime dt = DateTime.Now.AddHours(Util.GetInt(txtTimeLimit) * Util.GetInt(ddlTime));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_Panel_master SET MaxExpiry=@MaxExpiry,IsBookingLock=@IsBookingLock,IsPrintingLock=@IsPrintingLock,UpdateID=@UpdateID,UpdateName=@UpdateName,UpdateDate=NOW(),LockUnLockReason=@LockUnLockReason WHERE Panel_ID=@Panel_ID",
               new MySqlParameter("@MaxExpiry", dt.ToString("yyyy-MM-dd HH:mm:ss")),
               new MySqlParameter("@IsBookingLock", setLock),
               new MySqlParameter("@UpdateID", UserInfo.ID),
               new MySqlParameter("@UpdateName", UserInfo.LoginName),
               new MySqlParameter("@IsPrintingLock", setLock),
               new MySqlParameter("@Panel_ID", PanelID),
               new MySqlParameter("@LockUnLockReason", LockUnLockReason));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO f_panel_LockUnLockReason(Panel_ID,LockUnLockReason,setLock,MaxExpiry,CreatedBy,CreatedByID)VALUES(@Panel_ID,@LockUnLockReason,@SetLock,@MaxExpiry,@CreatedBy,@CreatedByID) ",
                    new MySqlParameter("@Panel_ID", PanelID),
                    new MySqlParameter("@LockUnLockReason", LockUnLockReason),
                    new MySqlParameter("@SetLock", setLock),
                    new MySqlParameter("@MaxExpiry", dt.ToString("yyyy-MM-dd HH:mm:ss")),
                    new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                    new MySqlParameter("@CreatedByID", UserInfo.ID));
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Record Updated" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
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
            sb.Append("SELECT pm.Panel_Code PanelCode,pm.Panel_ID, pm.company_name PanelName,cm.`State`,cm.`City`,cm.Zone,DATE_FORMAT(pm.Creatordate,'%d-%b-%Y')CreatorDate,");
            sb.Append(" TRIM( LEADING ',' FROM CONCAT(IFNULL(pm.Phone,''),', ',IFNULL(pm.Mobile,'')))Mobile, pm.CreditLimit , ");
            sb.Append(" IF(IFNULL(pm.MaxExpiry,'')='','',DATE_FORMAT(pm.MaxExpiry,'%d-%b-%Y %H:%i'))MaxExpiry,   ");
            sb.Append(" pm.`IsBookingLock` IsBlockPanelBooking,pm.`IsPrintingLock` IsBlockPanelReporting,pm.Payment_Mode,IF( pm.TaxPercentage=0,10,pm.TaxPercentage)TaxPercentage ,  ");

            sb.Append(" (CASE  ");
            sb.Append(" WHEN pm.`showBalanceAmt` ='0' THEN 'Open (Master not set)'     ");
            sb.Append(" WHEN pm.`IsBookingLock`='1' AND pm.`showBalanceAmt` =1  AND pm.MaxExpiry < NOW() THEN 'Lock (Manual Lock)'    ");
            sb.Append(" WHEN pm.MaxExpiry >= NOW() AND pm.`showBalanceAmt` =1  THEN CONCAT('Open (Manual open till ',MaxExpiry,')')   ");
            sb.Append(" WHEN  pm.MaxExpiry < NOW() AND (-1)*pm.creditlimit >  ROUND(IFNULL(BalanceAmt,0)) THEN 'Lock (Auto Lock)'     ");
            sb.Append(" ELSE 'Open' END )isLock ");

            sb.Append(" ,aa.BalanceAmt     ");
            sb.Append(" FROM  ");
            sb.Append(" f_panel_master pm   ");
            sb.Append("  INNER JOIN `centre_master` cm ON cm.`CentreID`=pm.`TagProcessingLabID` AND pm.Payment_Mode='Cash' AND pm.IsInvoice=0 AND pm.PanelType='PUP' ");
            sb.Append(" ");

            if (PanelID != string.Empty)
                sb.Append(" AND pm.`Panel_ID` IN ({0}) ");

            sb.Append("  INNER JOIN   ");
            sb.Append("  ( SELECT SUM(`Adjustment` - `NetAmount`)BalanceAmt,Panel_ID FROM `f_ledgertransaction`   ");
            sb.Append("  WHERE ");
            if (PanelID != string.Empty)
                sb.Append(" `Panel_ID` IN ({0}) AND ");

            sb.Append("    `IsCredit`=0   GROUP BY Panel_ID ");
            sb.Append("   ) aa  ON pm.panel_ID=aa.Panel_ID ");

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

            sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,fpm.Panel_ID FROM f_panel_master fpm ");
            sb.Append(" WHERE fpm.TagProcessingLabID IN (SELECT CentreID FROM centre_master WHERE  BusinessZoneID=@BusinessZoneID");
            if (StateID != -1)
                sb.Append("  AND StateID=@StateID");


            sb.Append("   )");
            sb.Append("    AND fpm.IsInvoice=0 AND fpm.Payment_Mode='Cash' AND fpm.PanelType='PUP' ");
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
    public static string ExcelExport(string PanelID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] PanelIDTags = PanelID.Split(',');
            string[] PanelIDNames = PanelIDTags.Select((s, i) => "@tag" + i).ToArray();
            string PanelIDClause = string.Join(", ", PanelIDNames);

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT pm.Panel_Code PanelCode,pm.Panel_ID, pm.company_name PanelName,cm.`State`,cm.`City`,cm.Zone,DATE_FORMAT(pm.Creatordate,'%d-%b-%Y')CreatorDate,");
            sb.Append(" TRIM( LEADING ',' FROM CONCAT(IFNULL(pm.Phone,''),', ',IFNULL(pm.Mobile,'')))Mobile, pm.CreditLimit , ");
            sb.Append(" IF(IFNULL(pm.MaxExpiry,'')='','',DATE_FORMAT(pm.MaxExpiry,'%d-%b-%Y %H:%i'))MaxExpiry,   ");
            sb.Append(" pm.`IsBookingLock` IsBlockPanelBooking,pm.`IsPrintingLock` IsBlockPanelReporting,pm.Payment_Mode,IF( pm.TaxPercentage=0,10,pm.TaxPercentage)TaxPercentage  ");
            sb.Append(" ,aa.BalanceAmt     ");
            sb.Append(" FROM  ");
            sb.Append(" f_panel_master pm   ");
            sb.Append("  INNER JOIN `centre_master` cm ON cm.`CentreID`=pm.`TagProcessingLabID` AND pm.Payment_Mode='Cash' AND pm.IsInvoice=0 AND pm.PanelType='PUP' ");
            sb.Append(" ");

            if (PanelID != string.Empty)
                sb.Append(" AND pm.`Panel_ID` IN ({0}) ");

            sb.Append("  INNER JOIN   ");
            sb.Append("  ( SELECT SUM(`Adjustment` - `NetAmount`)BalanceAmt,Panel_ID FROM `f_ledgertransaction`   ");
            sb.Append("  WHERE ");
            if (PanelID != string.Empty)
                sb.Append(" `Panel_ID` IN ({0}) AND ");

            sb.Append("    `IsCredit`=0   GROUP BY Panel_ID ");
            sb.Append("   ) aa  ON pm.panel_ID=aa.Panel_ID ");

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
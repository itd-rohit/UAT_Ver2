using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Linq;
using System.Web;
public partial class Design_Invoicing_AccountWelcomePage : System.Web.UI.Page
{
    public string IsHavingRights = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindPanelGroup();
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT DISTINCT cm.CentreID,CONCAT(cm.Centre,' [',cm.CentreID,'] ') AS Centre FROM centre_master cm WHERE (cm.centreID =" + UserInfo.Centre + "  or cm.CentreID IN (SELECT CentreAccess FROM centre_access WHERE CentreID ='" + UserInfo.Centre + "'  ) ) AND cm.isActive=1  ");
            if (Util.GetString(HttpContext.Current.Session["LoginType"]) == "PCC" || Util.GetString(HttpContext.Current.Session["LoginType"]) == "SUBPCC")
                sb.Append(" AND cm.CentreID IN (SELECT BusinessUnitID FROM f_panel_master WHERE employeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ) ");
            sb.Append(" ORDER BY cm.Centre"); 
            lstcentre.DataSource = StockReports.GetDataTable(sb.ToString());
            lstcentre.DataTextField = "Centre";
            lstcentre.DataValueField = "CentreID";
            lstcentre.DataBind();
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            if (UserInfo.RoleID == 1 || UserInfo.RoleID == 177 || UserInfo.RoleID == 6)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script1", "showAccountSearch();", true);
                lblSearchType.Text = "1";
            }
            else
            {
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    int isSalesTeamMember = Util.GetInt(Session["IsSalesTeamMember "].ToString());
                    lblIsSalesTeamMember.Text = isSalesTeamMember.ToString();
                    if (isSalesTeamMember == 1)
                    {
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script1", "bindSalesPanel();", true);
                        lblSearchType.Text = "2";
                    }

                    else
                    {
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script2", "hideSearchCriteria();", true);
                        lblSearchType.Text = "3";

                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);

                }
                finally
                {
                    con.Close();
                    con.Dispose();

                }
            }
            if (Session["RoleId"].ToString() == "1" || Session["RoleId"].ToString() == "177" || Session["RoleId"].ToString() == "6" || Session["RoleId"].ToString() == "221") // Access to Administrator,Accounts,SalesAdmin & EDP 
            {
                IsHavingRights = "style='pointer-events: all;'";
            }
            else
            {
                IsHavingRights = "style='pointer-events: none;'";
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindPanel(int BusinessZoneID, int StateID, int SearchType, string PaymentMode, string TagBusinessLab, string PanelGroup, int? IsInvoicePanel, string BillingCycle, string CentreID = "")
    {
        StringBuilder sb = new StringBuilder();
        HttpContext ctx = HttpContext.Current;
        string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");

        sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#',fpm.PanelGroup,'#',fpm.PanelGroupID)Panel_ID,fpm.PanelGroup Type1 FROM f_panel_master fpm   ");
        sb.Append(" WHERE   fpm.IsInvoice=1 AND fpm.`Payment_Mode`='Credit' ");

        sb.Append(" and Panel_ID in(select distinct PanelId from centre_panel where centreID in(" + CentreID + "))");

        if (BusinessZoneID != 0)
            sb.Append("  AND fpm.BusinessZoneID='" + BusinessZoneID + "' ");


        sb.Append("   AND fpm.Panel_ID=fpm.InvoiceTo   ");

        if (SearchType != 0)
        {
            sb.Append(" AND fpm.PanelGroupID='" + SearchType + "'  ");
        }

        if (Util.GetString(ctx.Session["LoginType"]) == "PCC")
        {
            sb.Append(" and fpm.InvoiceTo =" + InvoicePanelID + "");
        }
        else if (Util.GetString(ctx.Session["LoginType"]).ToUpper() == "SUBPCC")
        {
            sb.Append(" and fpm.employee_ID=" + Util.GetString(ctx.Session["ID"]) + "");
        }
        sb.Append("   AND fpm.IsPermanentClose=0 ");

        if (PaymentMode != string.Empty)
            sb.Append(" AND fpm.Payment_Mode='" + PaymentMode + "' ");

        sb.Append(" ORDER BY fpm.Company_Name");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
		//System.IO.File.WriteAllText(@"D:\Dummy.txt", sb.ToString());
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }
    [WebMethod(EnableSession = true)]
    public static string SaveUpdation(string PanelID, string setLock, string txtTimeLimit, string ddlTime, string LockUnLockReason)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DateTime dt = DateTime.Now.AddHours(Util.GetInt(txtTimeLimit) * Util.GetInt(ddlTime));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_Panel_master SET MaxExpiry=@MaxExpiry,IsManualLock=@IsManualLock,UpdateID=@UpdateID,UpdateName=@UpdateName,UpdateDate=NOW(),LockUnLockReason=@LockUnLockReason WHERE Panel_ID=@Panel_ID",
               new MySqlParameter("@MaxExpiry", dt.ToString("yyyy-MM-dd HH:mm:ss")),
               new MySqlParameter("@IsManualLock", setLock),
               new MySqlParameter("@UpdateID", UserInfo.ID),
               new MySqlParameter("@UpdateName", UserInfo.LoginName),
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
    public static string searchLedger(int SearchType, string PanelID, string SalesManager, string center)
    {
        PanelID = String.Join(",", PanelID.Split(new char[] { ' ', ',' }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Split('#')[0]).ToList());


        string[] PanelIDTags = PanelID.Split(',');
        string[] PanelIDNames = PanelIDTags.Select((s, i) => "@tag" + i).ToArray();
        string PanelIDClause = string.Join(", ", PanelIDNames);


        StringBuilder sb = new StringBuilder();

        string dateonly = System.DateTime.Now.ToString("yyyy-MM-01");
        string datewithtime = System.DateTime.Now.ToString("yyyy-MM-01 00:00:00");

        string LastMonthFirstDate = System.DateTime.Now.AddMonths(-1).ToString("yyyy-MM-01 00:00:00");
        string LastMonthLastDate = System.DateTime.Now.Date.AddDays(-System.DateTime.Now.Day).ToString("yyyy-MM-dd 23:59:59");

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            sb.AppendLine(" SELECT pm.LockUnlockReason,pm.SecurityAmt,cm.Centre,pm.SalesManager,pm.Panel_Code PanelCode,pm.Panel_ID, if(RollingAdvance=0,pm.company_name,Concat(pm.company_name,'(R)')) PanelName,cm.`State`,cm.`City`,cm.Zone,   ");
            sb.AppendLine(" cm.Type1 SearchType,");
            sb.AppendLine(" ROUND((IFNULL(ReceivedAmtOpening,0) - IFNULL(BookingOpening,0)),0)`ClosingBalance`,DATE_FORMAT(pm.Creatordate,'%d-%b-%Y')CreatorDate,   ");
            sb.AppendLine(" TRIM( LEADING ',' FROM CONCAT(IFNULL(pm.Phone,''),', ',IFNULL(pm.Mobile,'')))Mobile, pm.CreditLimit*-1 CreditLimit,t.Ageing,  ");
            sb.AppendLine(" IF(IFNULL(pm.MaxExpiry,'')='','',DATE_FORMAT(pm.MaxExpiry,'%d-%b-%Y %H:%i'))MaxExpiry,  ");
            sb.AppendLine(" IF(pm.`IsBookingLock`=1,'Yes','No') IsBlockPanelBooking,IF(pm.`IsPrintingLock`=1,'Yes','No') IsBlockPanelReporting,pm.Payment_Mode,IF(pm.IsShowIntimation=1,'Yes','No')IsShowIntimation,(IFNULL(pm.IntimationLimit,0)*-1)IntimationLimit, ");
            sb.AppendLine(" pm.LabReportLimit*-1 LabReportLimit,IF( pm.TaxPercentage=0,10,pm.TaxPercentage)TaxPercentage ,round(IFNULL(BookingCurrent,0))`CurrentBusiness`,round(IFNULL(ReceivedAmtCurrent,0))`ReceivedAmount`, ");
            sb.AppendLine(" ROUND((IFNULL(t.ReceivedAmtOpening,0)+IFNULL(t.ReceivedAmtCurrent,0)-IFNULL(t.BookingOpening,0)-IFNULL(t.BookingCurrent,0)))`TotalOutstanding`, "); 
            sb.AppendLine(" (CASE  ");
            sb.AppendLine(" WHEN pm.`showBalanceAmt` =0 THEN 'Open (Master not set)'  "); 
            sb.AppendLine(" WHEN pm.`IsManualLock`=1 AND pm.`showBalanceAmt` =1  AND pm.`IsPrintingLock`=1 AND pm.IsBookingLock=1  AND pm.MaxExpiry < NOW() THEN 'Lock (Manual)'   ");
            sb.AppendLine(" WHEN pm.`IsManualLock`=1 AND pm.`showBalanceAmt` =1  AND pm.`IsPrintingLock`=0 AND pm.IsBookingLock=1  AND pm.MaxExpiry < NOW() THEN 'Booking Lock (Manual)'   ");
            sb.AppendLine(" WHEN pm.`IsManualLock`=1 AND pm.`showBalanceAmt` =1  AND pm.`IsPrintingLock`=1 AND pm.IsBookingLock=0  AND pm.MaxExpiry < NOW() THEN 'Printing Lock (Manual)'   "); 
            sb.AppendLine(" WHEN pm.MaxExpiry >= NOW() AND pm.`showBalanceAmt` =1  THEN CONCAT('Open (Manual open till ',DATE_FORMAT(pm.MaxExpiry,'%d-%b-%Y %H:%i'),')')    ");
            sb.AppendLine(" WHEN pm.`showBalanceAmt` =1  AND pm.`IsPrintingLock`=1 and pm.IsBookingLock=1  AND pm.MaxExpiry < NOW() AND pm.creditlimit <= ROUND((IFNULL(BookingOpening,0)+IFNULL(BookingCurrent,0)-IFNULL(ReceivedAmtOpening,0)-IFNULL(ReceivedAmtCurrent,0))) THEN 'Lock (Auto)'    ");
            sb.AppendLine(" WHEN pm.`showBalanceAmt` =1  AND pm.`IsPrintingLock`=0 and pm.IsBookingLock=1  AND pm.MaxExpiry < NOW() AND pm.creditlimit <= ROUND((IFNULL(BookingOpening,0)+IFNULL(BookingCurrent,0)-IFNULL(ReceivedAmtOpening,0)-IFNULL(ReceivedAmtCurrent,0))) THEN 'Booking Lock (Auto)'    ");
            sb.AppendLine(" WHEN pm.`showBalanceAmt` =1  AND pm.`IsPrintingLock`=1 and pm.IsBookingLock=0  AND pm.MaxExpiry < NOW() AND pm.LabReportLimit <= ROUND((IFNULL(BookingOpening,0)+IFNULL(BookingCurrent,0)-IFNULL(ReceivedAmtOpening,0)-IFNULL(ReceivedAmtCurrent,0))) THEN 'Printing Lock (Auto)'    ");
            sb.AppendLine(" WHEN pm.`showBalanceAmt` ='1'  AND pm.MaxExpiry < NOW() AND pm.chkExpectedPayment=1 AND pm.ExpectedPaymentDate<=DAY(NOW()) AND  (IFNULL(pm.LastMonthBusinessAmount,0) - (IFNULL(ReceivedAmtOpening,0)+IFNULL(ReceivedAmtCurrent,0))) >0 THEN 'Lock By Exp Pay Date' ");
            sb.AppendLine(" ELSE 'Open' END )isLock,pm.InvoiceTo,  IFNULL(CONCAT(em.Title,' ',em.Name),'')SalesManager ,pm.LockUnLockReason,LastPaidAmt,DATE_FORMAT(LastPaidDate,'%d-%b-%Y')LastPaidDate  ");
            sb.AppendLine(" FROM  ");
            sb.AppendLine(" f_panel_master pm LEFT JOIN employee_master em ON em.Employee_ID=pm.SalesManagerid  ");
            if (center != "")
            {
                sb.AppendLine(" And (pm.TagBusinessLabID in (" + center + ")  or pm.TagProcessingLabID in (" + center + "))");
            } 
            if (SearchType != 7)
            {
                sb.AppendLine(" INNER JOIN centre_master cm ON cm.centreid=pm.TagBusinessLabID  AND pm.InvoiceTo = pm.panel_id   AND pm.IsInvoice=1 AND pm.InvoiceCreatedOn=2 "); 
                if (PanelID != string.Empty)
                    sb.AppendLine(" AND pm.Panel_ID IN ({0}) ");
                if (SalesManager != string.Empty)
                    sb.AppendLine(" AND pm.SalesManagerid IN (" + SalesManager + ") "); 
            } 
            else if (SearchType == 7)
            {
                sb.AppendLine(" INNER JOIN centre_master cm ON cm.centreid=pm.TagProcessingLabID  AND pm.PanelType='PUP' AND pm.IsInvoice=1 AND pm.Payment_Mode='Credit' AND pm.InvoiceCreatedOn=2");
                if (PanelID != string.Empty)
                    sb.AppendLine(" AND pm.Panel_ID IN ({0}) ");
                if (SalesManager != string.Empty)
                    sb.AppendLine(" AND pm.SalesManagerid IN (" + SalesManager + ") ");

            } 
            sb.AppendLine(" LEFT JOIN  "); 
            sb.AppendLine(" (SELECT PanelID,SUM(BookingOpening)BookingOpening,SUM(BookingCurrent)BookingCurrent, SUM(ReceivedAmtOpening)ReceivedAmtOpening,SUM(ReceivedAmtCurrent)ReceivedAmtCurrent,SUM(Ageing)Ageing,SUM(LastPaidAmt)LastPaidAmt,LastPaidDate ");
            sb.AppendLine(" FROM ( "); 
            sb.AppendLine("  SELECT * FROM (          ");
            sb.AppendLine(" SELECT Panel_id PanelID,0 BookingOpening,0 BookingCurrent,0 ReceivedAmtOpening,0 ReceivedAmtCurrent,0 Ageing,IFNULL(receivedAmt,0)LastPaidAmt,EntryDate LastPaidDate ");
            sb.AppendLine(" FROM invoicemaster_onaccount   ");
            sb.AppendLine(" WHERE  isCancel=0 AND receivedAmt >0 AND CreditNote=0   ");
            if (PanelID != string.Empty)
                sb.AppendLine(" AND Panel_id IN ({0}) ");
            sb.AppendLine(" ORDER BY EntryDate  DESC ");
            sb.AppendLine(" )t             ");
            sb.AppendLine("  GROUP BY t.PanelID        "); 
            sb.AppendLine(" UNION ALL   "); 
            sb.AppendLine(" SELECT pnl.`InvoiceTo` PanelID,SUM(plos.PCCInvoiceAmt)BookingOpening,0 BookingCurrent, 0 ReceivedAmtOpening,0 ReceivedAmtCurrent, 0 Ageing,0 LastPaidAmt,'' LastPaidDate ");
            sb.AppendLine(" from f_ledgertransaction lt ");
            sb.AppendLine(" INNER JOIN patient_labinvestigation_opd_share plos on plos.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.AppendLine(" INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=lt.`Panel_ID` AND pnl.`IsInvoice`=1 AND pnl.InvoiceCreatedOn=2  and plos.issamplecollected<>'R' ");
            sb.AppendFormat(" AND lt.{0} < @datewithtime ", Resources.Resource.LedgerReportDate); 
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.AppendLine(" AND plos.IsSRA=1 ");
            if (center != "")
            {
                sb.AppendLine(" And (pnl.TagBusinessLabID in (" + center + ")  )");
            }
            if (PanelID != string.Empty)
                sb.AppendLine(" AND pnl.InvoiceTo IN ({0}) ");
            if (SalesManager != string.Empty)
                sb.AppendLine(" AND pnl.SalesManagerid IN (" + SalesManager + ") ");
            sb.AppendLine(" GROUP BY pnl.`InvoiceTo`  ");

            sb.AppendLine(" UNION ALL  ");
            sb.AppendLine(" SELECT pnl.`InvoiceTo` PanelID,0 BookingOpening, SUM(plos.PCCInvoiceAmt)BookingCurrent, 0 ReceivedAmtOpening,0 ReceivedAmtCurrent, 0 Ageing,0 LastPaidAmt,''LastPaidDate ");
            sb.AppendLine(" FROM f_ledgertransaction lt ");
            sb.AppendLine(" INNER JOIN patient_labinvestigation_opd_share plos on plos.`LedgerTransactionID`=lt.`LedgerTransactionID` "); 
            sb.AppendLine(" INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=lt.`Panel_ID` AND pnl.`IsInvoice`=1 AND pnl.InvoiceCreatedOn=2  and plos.issamplecollected<>'R' "); 
            sb.AppendFormat("  AND plos.{0} >= @datewithtime ", Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.AppendLine(" AND plos.IsSRA=1 ");
            if (center != "")
            {
                sb.AppendLine(" And (pnl.TagBusinessLabID in (" + center + ")  )");
            }
            if (PanelID != string.Empty)
                sb.AppendLine(" AND pnl.InvoiceTo IN ({0}) ");
            if (SalesManager != string.Empty)
                sb.AppendLine(" AND pnl.SalesManagerid IN (" + SalesManager + ") ");
            sb.AppendLine(" GROUP BY pnl.`InvoiceTo` ");

            sb.AppendLine(" UNION ALL ");

            sb.AppendLine(" SELECT Panel_id PanelID,0 BookingOpening,0 BookingCurrent, IFNULL(SUM(receivedAmt),0) ReceivedAmtOpening,0 ReceivedAmtCurrent, 0 Ageing,0 LastPaidAmt,''LastPaidDate ");
            sb.AppendLine(" FROM invoicemaster_onaccount WHERE `ReceivedDate`<  @dateonly  and creditnote!=2");
            sb.AppendLine(" AND isCancel=0  ");
            if (PanelID != string.Empty)
                sb.AppendLine(" AND Panel_ID IN ({0}) ");
            sb.AppendLine(" GROUP BY Panel_id ");

            sb.AppendLine(" UNION ALL ");

            sb.AppendLine(" SELECT Panel_id PanelID,0 BookingOpening,0 BookingCurrent, Concat('-',IFNULL(SUM(receivedAmt),0)) ReceivedAmtOpening,0 ReceivedAmtCurrent, 0 Ageing,0 LastPaidAmt,''LastPaidDate ");
            sb.AppendLine(" FROM invoicemaster_onaccount WHERE `ReceivedDate`<  @dateonly  ");
            sb.AppendLine(" AND isCancel=0 and creditnote=2 ");
            if (PanelID != string.Empty)
                sb.AppendLine(" AND Panel_ID IN ({0}) ");
            sb.AppendLine(" GROUP BY Panel_id ");

            sb.AppendLine(" UNION ALL ");

            sb.AppendLine(" SELECT Panel_id PanelID,0 BookingOpening,0 BookingCurrent, 0 ReceivedAmtOpening, IFNULL(SUM(receivedAmt),0) ReceivedAmtCurrent, 0 Ageing,0 LastPaidAmt,''LastPaidDate ");
            sb.AppendLine(" FROM invoicemaster_onaccount WHERE `ReceivedDate`>=  @dateonly and creditnote!=2 ");
            sb.AppendLine(" AND isCancel=0  ");
            if (PanelID != string.Empty)
                sb.AppendLine(" AND Panel_ID IN ({0}) ");
            sb.AppendLine(" GROUP BY Panel_id ");

            sb.AppendLine(" UNION ALL ");

            sb.AppendLine(" SELECT Panel_id PanelID,0 BookingOpening,0 BookingCurrent, 0 ReceivedAmtOpening, Concat('-',IFNULL(SUM(receivedAmt),0)) ReceivedAmtCurrent, 0 Ageing,0 LastPaidAmt,''LastPaidDate ");
            sb.AppendLine(" FROM invoicemaster_onaccount WHERE `ReceivedDate`>=  @dateonly and creditnote=2 ");
            sb.AppendLine(" AND isCancel=0  ");
            if (PanelID != string.Empty)
                sb.AppendLine(" AND Panel_ID IN ({0}) ");
            sb.AppendLine(" GROUP BY Panel_id ");

            sb.AppendLine(" UNION ALL   ");

            sb.AppendLine(" SELECT Panel_id PanelID,0 BookingOpening,0 BookingCurrent, 0 ReceivedAmtOpening, 0 ReceivedAmtCurrent ");
            sb.AppendLine(" , IFNULL(DATEDIFF(CURRENT_DATE,MAX(ReceivedDate)),0) Ageing,0 LastPaidAmt,''LastPaidDate  ");
            sb.AppendLine(" FROM invoicemaster_onaccount  WHERE  isCancel=0 AND receivedAmt >0 ");
            if (PanelID != string.Empty)
                sb.AppendLine("  AND Panel_ID IN ({0}) ");
            sb.AppendLine(" GROUP BY Panel_ID  "); 
            sb.AppendLine(" ) aa GROUP BY PanelID  ");
            sb.AppendLine(" ) t ON t.PanelId=pm.`Panel_ID` ");
            sb.AppendLine(" WHERE  pm.`PanelType`!='RateType' ");
            sb.AppendLine(" ORDER BY cm.`BusinessZoneID`,cm.`State`,cm.`City`, pm.`Company_Name` ");
          //  System.IO.File.WriteAllText(@"C:\ITDOSE\UAT_Ver1\ErrorLog\\AccountWelcomePage.txt", sb.ToString());
            string data = string.Empty;
            if (PanelID != string.Empty)
                data = string.Format(sb.ToString(), PanelIDClause);
            else
                data = sb.ToString();
            using (MySqlDataAdapter da = new MySqlDataAdapter(data, con))
            {
                if (PanelID != string.Empty)
                {
                    for (int i = 0; i < PanelIDNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(PanelIDNames[i], PanelIDTags[i]);
                    }
                } 
                da.SelectCommand.Parameters.AddWithValue("@datewithtime", datewithtime);
                da.SelectCommand.Parameters.AddWithValue("@dateonly", dateonly);
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
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string ExcelLedgerStament(int SearchType, string PanelID, string SalesManager, string center)
    {
        PanelID = String.Join(",", PanelID.Split(new char[] { ' ', ',' }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Split('#')[0]).ToList());


        //string[] PanelIDTags = PanelID.Split(',');
        //string[] PanelIDNames = PanelIDTags.Select((s, i) => "@tag" + i).ToArray();
        //string PanelIDClause = string.Join(", ", PanelIDNames);


        StringBuilder sb = new StringBuilder();

        string dateonly = System.DateTime.Now.ToString("yyyy-MM-01");
        string datewithtime = System.DateTime.Now.ToString("yyyy-MM-01 00:00:00");

        string LastMonthFirstDate = System.DateTime.Now.AddMonths(-1).ToString("yyyy-MM-01 00:00:00");
        string LastMonthLastDate = System.DateTime.Now.Date.AddDays(-System.DateTime.Now.Day).ToString("yyyy-MM-dd 23:59:59");

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        //return "";
        
        sb.Append(" SELECT  if(pm.Panel_Code='',pm.InvoiceTo,pm.Panel_Code) `Panel Code`, pm.company_name PanelName, ");
        sb.Append(" round(IFNULL(t2.PreviousReceivedAmount,0)- IFNULL(t1.PreviousBooking,0) - IFNULL(t11.PreviousBookingWithoutInv,0))OpeningAmount, ");
        sb.Append(" round(IFNULL(t3.CurrentBooking,0) + IFNULL(t33.CurrentBookingWithoutInv,0))CurrentBooking, ");
        sb.Append(" round(IFNULL(t4.CurrentReceivedAmount,0))ReceivedAmount, ");
        sb.Append(" round(IFNULL(t2.PreviousReceivedAmount,0) + IFNULL(t4.CurrentReceivedAmount,0) - IFNULL(t1.PreviousBooking,0) - IFNULL(t11.PreviousBookingWithoutInv,0) - IFNULL(t3.CurrentBooking,0) - IFNULL(t33.CurrentBookingWithoutInv,0)) ClosingAmount ");

        sb.Append(" FROM  ");
        sb.Append(" f_panel_master pm  ");
        sb.Append(" LEFT JOIN     ");

        sb.Append("  ( SELECT PanelID, SUM(ShareAmt) PreviousBooking FROM invoicemaster WHERE  iscancel=0  ");
        sb.Append(" AND  `InvoiceDate`<='" + dateonly + "'    ");
        sb.Append(" AND `PanelID` IN (" + PanelID + ")  ");
        sb.Append(" GROUP BY PanelID )t1   ");
        sb.Append(" ON t1.PanelID=pm.panel_id ");
        sb.Append(" LEFT JOIN     ");
        sb.Append(" ( SELECT pm1.InvoiceTo panel_id, IFNULL(SUM(lt.netamount),0) PreviousBookingWithoutInv    ");
        sb.Append(" FROM f_ledgertransaction lt         ");
        sb.Append(" INNER JOIN f_panel_master  pm1 ON pm1.panel_id=lt.panel_id          ");
        sb.Append(" WHERE  lt.DATE<'" + datewithtime + "'    ");
        sb.Append(" AND pm1.InvoiceTo IN (" + PanelID + ") and ifnull(lt.InvoiceNo,'')='' ");
        sb.Append(" GROUP BY pm1.InvoiceTo ) t11 ON pm.panel_id= t11.panel_id     ");
        sb.Append(" LEFT JOIN (SELECT panel_id , IFNULL(SUM(receivedamt),0) PreviousReceivedAmount FROM invoicemaster_onaccount   ");
        sb.Append(" WHERE ReceivedDate < '" + dateonly + "'  ");
        sb.Append(" AND iscancel=0  AND TYPE='ON ACCOUNT' GROUP BY Panel_id )t2   ");
        sb.Append(" ON pm.panel_id=t2.panel_id   ");
        sb.Append(" LEFT JOIN     ");
        sb.Append("  ( SELECT PanelID, SUM(ShareAmt) CurrentBooking FROM invoicemaster WHERE  iscancel=0  ");
        sb.Append(" AND  `InvoiceDate`>'" + dateonly + "'    ");
        sb.Append(" AND `PanelID` IN (" + PanelID + ")  ");
        sb.Append(" GROUP BY PanelID )t3   ");
        sb.Append(" ON t3.PanelID=pm.panel_id ");
        sb.Append(" LEFT JOIN     ");
        sb.Append(" ( SELECT pm1.InvoiceTo panel_id, IFNULL(SUM(lt.netamount),0) CurrentBookingWithoutInv     ");
        sb.Append(" FROM f_ledgertransaction lt         ");
        sb.Append(" INNER JOIN f_panel_master  pm1 ON pm1.panel_id=lt.panel_id          ");
        sb.Append(" WHERE lt.DATE >= '" + datewithtime + "'    ");
        sb.Append(" AND pm1.InvoiceTo IN (" + PanelID + ") and ifnull(lt.InvoiceNo,'')=''  ");
        sb.Append(" GROUP BY pm1.InvoiceTo ) t33 ON pm.panel_id= t33.panel_id   ");

        sb.Append(" LEFT JOIN (SELECT panel_id , IFNULL(SUM(receivedamt),0) CurrentReceivedAmount FROM invoicemaster_onaccount   ");
        sb.Append(" WHERE ReceivedDate >= '" + dateonly + "'  ");
        sb.Append(" AND iscancel=0  AND TYPE='ON ACCOUNT' GROUP BY Panel_id )t4   ");
        sb.Append(" ON pm.panel_id=t4.panel_id  ");

        sb.Append(" WHERE pm.IsInvoice=1 and pm.payment_mode='Credit'   AND pm.`IsActive`='1' ");

        sb.Append(" and pm.InvoiceTo IN (" + PanelID + ")  ");
        //  sb.AppendLine(" And pm.BusinessUnitID in (" + CentreIDs + ")  ");
        //  sb.Append(" AND round(IFNULL(t2.PreviousReceivedAmount,0) + IFNULL(t4.CurrentReceivedAmount,0) - IFNULL(t1.PreviousBooking,0)- IFNULL(t3.CurrentBooking,0)) <>0 ");
        sb.Append(" order by pm.company_name; ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataColumn column = new DataColumn();
        column.ColumnName = "S.No";
        column.DataType = System.Type.GetType("System.Int32");
        column.AutoIncrement = true;
        column.AutoIncrementSeed = 0;
        column.AutoIncrementStep = 1;

        dt.Columns.Add(column);
        int index = 0;
        foreach (DataRow row in dt.Rows)
        {
            row.SetField(column, ++index);
        }
        dt.Columns["S.No"].SetOrdinal(0);
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = " Ledger Statement";
            return "true";
        }
        else
        {
            return "false";
        }      
  }
    [WebMethod]
    public static string encryptData(string PanelID, string Type)
    {
        List<string> addEncrypt = new List<string>();
        addEncrypt.Add(Common.Encrypt(PanelID));
        addEncrypt.Add(Common.Encrypt(Type));
        return JsonConvert.SerializeObject(addEncrypt);
    }
    private void BindPanelGroup()
    {
        lstPanelGroup.DataSource = StockReports.GetDataTable("SELECT DISTINCT PanelGroupId,PanelGroup FROM f_panel_master WHERE isActive=1 AND PanelType='PUP'  ORDER BY PanelGroup");
        lstPanelGroup.DataTextField = "PanelGroup";
        lstPanelGroup.DataValueField = "PanelGroupId";
        lstPanelGroup.DataBind();

    }

    [WebMethod]
    public static string salesManager()
    {
        return Util.getJson(StockReports.GetDataTable(" SELECT PRONAME,PROID FROM salesteam_master "));

    }

}
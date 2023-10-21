using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Linq;
public partial class Design_Invoicing_LedgerStatusAsOnDate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calDate.EndDate = DateTime.Now;
            txtDate.Attributes.Add("readOnly", "true");
            txtToTime.Text = "23:59:59";
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            CalendarExtender1.EndDate = DateTime.Now;
            CalendarExtender2.EndDate = DateTime.Now;
        }
    }
    [WebMethod]
    public static string searchLedger(int SearchType, string PanelID, string AsOnDate, string type, string fromDate, string toDate)
    {
        PanelID = String.Join(",", PanelID.Split(new char[] { ' ', ',' }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Split('#')[0]).ToList());

        string[] PanelIDTags = PanelID.Split(',');
        string[] PanelIDNames = PanelIDTags.Select((s, i) => "@tag" + i).ToArray();
        string PanelIDClause = string.Join(", ", PanelIDNames);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (type == "1")
            {
                //  As on Date 
                StringBuilder sb = new StringBuilder();
                string dateonly = Util.GetDateTime(AsOnDate).ToString("yyyy-MM-dd");
                string datewithtime = Util.GetDateTime(AsOnDate).ToString("yyyy-MM-dd HH:mm:ss");

                sb.Append(" SELECT pm.Panel_Code PanelCode,pm.Panel_ID, pm.company_name PanelName,if(pm.`State`='select','',pm.state)State,if(pm.`City`='select','',pm.City)`City`,if(pm.`zone`='select','',pm.zone)Zone,   ");
                sb.AppendFormat(" ROUND((IFNULL(ReceivedAmtOpening,0) - IFNULL(BookingOpening,0)),0)`OpeningBalance`,'{0}' AsOnDate, ", AsOnDate);
                sb.Append(" TRIM( LEADING ',' FROM CONCAT(IFNULL(pm.Phone,''),', ',IFNULL(pm.Mobile,'')))Mobile ");
                sb.Append(" FROM  ");
                sb.Append(" f_panel_master pm   ");
               
                sb.Append(" LEFT JOIN  ");
                sb.Append(" (SELECT PanelID,SUM(BookingOpening)BookingOpening, SUM(ReceivedAmtOpening)ReceivedAmtOpening ");
                sb.Append(" FROM ( ");
                sb.Append(" SELECT pnl.`InvoiceTo` PanelID,SUM(plos.PCCInvoiceAmt)BookingOpening, 0 ReceivedAmtOpening ");
                sb.Append(" FROM  ");
                sb.Append(" patient_labinvestigation_opd_share plos  ");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID` "); 
                if (Resources.Resource.LedgerReportDate == "SRADate")
                {
                     sb.Append(" AND plo.IsSRA=1 ");
                }
                sb.Append(" INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=lt.`Panel_ID` AND pnl.`IsInvoice`=1 AND pnl.InvoiceCreatedOn=2");
                if (PanelID != string.Empty)
                    sb.Append(" AND pnl.InvoiceTo IN ({0}) ");
                sb.AppendFormat("  AND plos.{0} <= @datewithtime ", Resources.Resource.LedgerReportDate);
                sb.Append(" GROUP BY pnl.`InvoiceTo`  ");

                sb.Append(" UNION ALL ");
                sb.Append(" SELECT Panel_id PanelID,0 BookingOpening, IFNULL(SUM(receivedAmt),0) ReceivedAmtOpening ");
                sb.Append(" FROM invoicemaster_onaccount WHERE `ReceivedDate`<= @dateonly and creditnote!=2  ");
                sb.Append(" AND isCancel=0  ");
                if (PanelID != string.Empty)
                    sb.Append(" AND Panel_ID IN ({0}) ");
                sb.Append(" GROUP BY Panel_id ");

                sb.Append(" UNION ALL ");
                sb.Append(" SELECT Panel_id PanelID,0 BookingOpening, Concat('-',IFNULL(SUM(receivedAmt),0)) ReceivedAmtOpening ");
                sb.Append(" FROM invoicemaster_onaccount WHERE `ReceivedDate`<= @dateonly and creditnote=2 ");
                sb.Append(" AND isCancel=0  ");
                if (PanelID != string.Empty)
                    sb.Append(" AND Panel_ID IN ({0}) ");
                sb.Append(" GROUP BY Panel_id ");

                sb.Append(" ) aa GROUP BY PanelID  ");
                sb.Append(" ) t");
                sb.Append(" ON t.PanelId=pm.`Panel_ID` "); 
                if (SearchType != 7)
                { 
                    sb.Append(" where pm.InvoiceTo = pm.panel_id   AND pm.IsInvoice=1 AND pm.InvoiceCreatedOn=2");
                    if (PanelID != string.Empty)
                        sb.Append(" AND pm.Panel_ID IN ({0}) "); 
                } 
                else if (SearchType == 7)
                { 
                    sb.Append(" where pm.PanelType='PUP' AND pm.IsInvoice=1 AND pm.Payment_Mode='Credit' AND pm.InvoiceCreatedOn=2");

                    if (PanelID != string.Empty)
                        sb.Append(" AND pm.Panel_ID IN ({0}) ");
                }
                sb.Append(" ORDER BY  pm.`Company_Name` ");
                using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), PanelIDClause), con))
                {
                    for (int i = 0; i < PanelIDNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(PanelIDNames[i], PanelIDTags[i]);
                    }
                    da.SelectCommand.Parameters.AddWithValue("@dateonly", dateonly);
                    da.SelectCommand.Parameters.AddWithValue("@datewithtime", datewithtime);
                    da.SelectCommand.Parameters.AddWithValue("@type1ID", SearchType);
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
            else if (type == "2")
            {
                if (Util.GetDateTime(fromDate) > Util.GetDateTime(toDate))
                {
                    return "-1";
                }
                DataTable dt = new DataTable();

                StringBuilder sb = new StringBuilder();

                string dateonly = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd");
                string datewithtime = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd 00:00:00");

                string ToDateWithTime = Util.GetDateTime(toDate).ToString("yyyy-MM-dd 23:59:59");
                string ToDateOnly = Util.GetDateTime(toDate).ToString("yyyy-MM-dd");


                sb.Append(" SELECT pm.Panel_Code PanelCode,pm.Panel_ID, pm.company_name PanelName,if(pm.`State`='select','',pm.state)State,if(pm.`City`='select','',pm.City)`City`,if(pm.`zone`='select','',pm.zone)Zone,   ");
                if (SearchType == 7)
                    sb.Append(" 'PUP' SearchType,");
                else
                    sb.Append(" '' SearchType,");
                sb.Append(" ROUND((IFNULL(ReceivedAmtOpening,0) - IFNULL(BookingOpening,0)),0)`ClosingBalance`,DATE_FORMAT(pm.Creatordate,'%d-%b-%Y')CreatorDate,   ");
                sb.Append(" TRIM( LEADING ',' FROM CONCAT(IFNULL(pm.Phone,''),', ',IFNULL(pm.Mobile,'')))Mobile, pm.CreditLimit,t.Ageing,  ");
                sb.Append(" IF(IFNULL(pm.MaxExpiry,'')='','',DATE_FORMAT(pm.MaxExpiry,'%d-%b-%Y %H:%i'))MaxExpiry,  ");
                sb.Append(" pm.`IsBookingLock` IsBlockPanelBooking,pm.`IsPrintingLock` IsBlockPanelReporting,pm.Payment_Mode, ");
                sb.Append(" IF( pm.TaxPercentage=0,10,pm.TaxPercentage)TaxPercentage ,round(IFNULL(BookingCurrent,0))`CurrentBusiness`,round(IFNULL(ReceivedAmtCurrent,0))`ReceivedAmount`, ");

                sb.Append(" ROUND((IFNULL(t.ReceivedAmtOpening,0)+IFNULL(t.ReceivedAmtCurrent,0)-IFNULL(t.BookingOpening,0)-IFNULL(t.BookingCurrent,0)))`TotalOutstanding`, ");
                sb.Append(" pm.InvoiceTo   ");
                sb.Append(" FROM  ");
                sb.Append(" f_panel_master pm   ");
               
                sb.Append(" LEFT JOIN  ");
                sb.Append(" (SELECT PanelID,SUM(BookingOpening)BookingOpening,SUM(BookingCurrent)BookingCurrent, SUM(ReceivedAmtOpening)ReceivedAmtOpening,SUM(ReceivedAmtCurrent)ReceivedAmtCurrent,SUM(Ageing)Ageing ");
                sb.Append(" FROM ( ");
                sb.Append(" SELECT pnl.`InvoiceTo` PanelID,SUM(plos.PCCInvoiceAmt)BookingOpening,0 BookingCurrent, 0 ReceivedAmtOpening,0 ReceivedAmtCurrent, 0 Ageing ");
                sb.Append(" FROM  patient_labinvestigation_opd_share plos ");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID` "); 
                sb.Append(" INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=lt.`Panel_ID` AND pnl.`IsInvoice`=1 ");
                sb.AppendFormat("  AND plos.{0} < @datewithtime ", Resources.Resource.LedgerReportDate);
                if (Resources.Resource.LedgerReportDate == "SRADate")
                { sb.Append(" AND lt.IsSRA=1 "); }
                if (PanelID != string.Empty)
                    sb.Append(" AND pnl.InvoiceTo IN ({0}) ");
                sb.Append(" GROUP BY pnl.`InvoiceTo`  ");

                sb.Append(" UNION ALL  ");

                sb.Append(" SELECT pnl.`InvoiceTo` PanelID,0 BookingOpening, SUM(plos.PCCInvoiceAmt)BookingCurrent, 0 ReceivedAmtOpening,0 ReceivedAmtCurrent, 0 Ageing ");
                sb.Append(" FROM  patient_labinvestigation_opd_share plos "); 
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID` "); 
                sb.Append(" INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=plos.`Panel_ID` AND pnl.`IsInvoice`=1 ");
                sb.AppendFormat(" AND plos.{0} >= @datewithtime AND plos.{1} <= @ToDateWithTime ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);
                if (Resources.Resource.LedgerReportDate == "SRADate")
                {
                    sb.Append(" AND plo.IsSRA=1 ");
                }
                if (PanelID != string.Empty)
                    sb.Append(" AND pnl.InvoiceTo IN ({0}) ");
                sb.Append(" GROUP BY pnl.`InvoiceTo` ");
                sb.Append(" UNION ALL ");
                sb.Append(" SELECT Panel_id PanelID,0 BookingOpening,0 BookingCurrent, IFNULL(SUM(receivedAmt),0) ReceivedAmtOpening,0 ReceivedAmtCurrent, 0 Ageing ");
                sb.Append(" FROM invoicemaster_onaccount WHERE `ReceivedDate`<  @dateonly  ");
                sb.Append(" AND isCancel=0  ");
                if (PanelID != string.Empty)
                    sb.Append(" AND Panel_ID IN ({0}) ");
                sb.Append(" GROUP BY Panel_id ");
                sb.Append(" UNION ALL ");
                sb.Append(" SELECT Panel_id PanelID,0 BookingOpening,0 BookingCurrent, 0 ReceivedAmtOpening, IFNULL(SUM(receivedAmt),0) ReceivedAmtCurrent, 0 Ageing ");
                sb.Append(" FROM invoicemaster_onaccount WHERE `ReceivedDate`>=  @dateonly and `ReceivedDate`<=  @ToDateOnly and creditnote!=2 ");
                sb.Append(" AND isCancel=0  ");
                if (PanelID != string.Empty)
                    sb.Append(" AND Panel_ID IN ({0}) ");
                sb.Append(" GROUP BY Panel_id ");

                sb.Append(" UNION ALL ");
                sb.Append(" SELECT Panel_id PanelID,0 BookingOpening,0 BookingCurrent, 0 ReceivedAmtOpening, Concat('-',IFNULL(SUM(receivedAmt),0)) ReceivedAmtCurrent, 0 Ageing ");
                sb.Append(" FROM invoicemaster_onaccount WHERE `ReceivedDate`>=  @dateonly and `ReceivedDate`<=  @ToDateOnly and creditnote=2 ");
                sb.Append(" AND isCancel=0  ");
                if (PanelID != string.Empty)
                    sb.Append(" AND Panel_ID IN ({0}) ");
                sb.Append(" GROUP BY Panel_id ");

                sb.Append(" ) aa GROUP BY PanelID  ");
                sb.Append(" ) t ON t.PanelId=pm.`Panel_ID` ");
                if (SearchType != 7)
                {
                     sb.Append(" where pm.InvoiceTo = pm.panel_id   AND pm.IsInvoice=1 ");
                    if (PanelID != string.Empty)
                        sb.Append(" AND pm.Panel_ID IN ({0}) "); 
                } 
                else if (SearchType == 7)
                {
                    sb.Append(" where pm.PanelType='PUP' AND pm.IsInvoice=1 AND pm.Payment_Mode='Credit' ");
                    if (PanelID != string.Empty)
                        sb.Append(" AND pm.Panel_ID IN ({0}) ");
                }
                sb.Append(" and  pm.`PanelType`!='RateType' ");
                sb.Append(" ORDER BY  pm.`Company_Name` ");//cm.`BusinessZoneID`,cm.`State`,cm.`City`,
                using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), PanelIDClause), con))
                {
                    for (int i = 0; i < PanelIDNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(PanelIDNames[i], PanelIDTags[i]);
                    }
                    da.SelectCommand.Parameters.AddWithValue("@ToDateOnly", ToDateOnly);
                    da.SelectCommand.Parameters.AddWithValue("@dateonly", dateonly);
                    da.SelectCommand.Parameters.AddWithValue("@datewithtime", datewithtime);
                    da.SelectCommand.Parameters.AddWithValue("@ToDateWithTime", ToDateWithTime);
                    da.SelectCommand.Parameters.AddWithValue("@SearchType", SearchType);
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
            else
            {
                if (Util.GetDateTime(fromDate) > Util.GetDateTime(toDate))
                {
                    return "-1";
                }
                DataTable dt = new DataTable();


                foreach (DateTime day in EachDay(Util.GetDateTime(fromDate), Util.GetDateTime(toDate)))
                {
                    StringBuilder sb = new StringBuilder();

                    string dateonly = Util.GetDateTime(day).ToString("yyyy-MM-dd");
                    string datewithtime = Util.GetDateTime(day).ToString("yyyy-MM-dd 00:00:00");

                    string dataas = Util.GetDateTime(day).ToString("dd-MMM-yyyy");

                    sb.Append(" SELECT pm.Panel_Code PanelCode,pm.Panel_ID, pm.company_name PanelName,pm.`BusinessZoneID`,if(pm.`State`='select','',pm.state)State,if(pm.`City`='select','',pm.City)`City`,if(pm.`zone`='select','',pm.zone)Zone,    ");
                    sb.AppendFormat(" ROUND((IFNULL(ReceivedAmtOpening,0) - IFNULL(BookingOpening,0)),0)`OpeningBalance`, '{0}' AsOnDate,", dataas);
                    sb.Append(" TRIM( LEADING ',' FROM CONCAT(IFNULL(pm.Phone,''),', ',IFNULL(pm.Mobile,'')))Mobile "); 
                    sb.Append(" FROM  ");
                    sb.Append(" f_panel_master pm   "); 
                    sb.Append(" LEFT JOIN  ");
                    sb.Append(" (SELECT PanelID,SUM(BookingOpening)BookingOpening, SUM(ReceivedAmtOpening)ReceivedAmtOpening ");
                    sb.Append(" FROM ( ");
                    sb.Append(" SELECT pnl.`InvoiceTo` PanelID,SUM(plos.PCCInvoiceAmt)BookingOpening, 0 ReceivedAmtOpening ");
                    sb.Append(" FROM patient_labinvestigation_opd_share plos ");
                    sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID` "); 
                    sb.Append(" INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=lt.`Panel_ID` AND pnl.`IsInvoice`=1 ");
                    sb.Append("  AND plo.date < @datewithtime ");
                    if (PanelID != string.Empty)
                        sb.Append(" AND pnl.InvoiceTo IN ({0}) ");
                    sb.Append(" GROUP BY pnl.`InvoiceTo`  ");
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT Panel_id PanelID,0 BookingOpening, IFNULL(SUM(receivedAmt),0) ReceivedAmtOpening ");
                    sb.Append(" FROM invoicemaster_onaccount WHERE `ReceivedDate`<=  @dateonly  and creditnote!=2 ");
                    sb.Append(" AND isCancel=0  ");
                    if (PanelID != string.Empty)
                        sb.Append(" AND Panel_ID IN ({0}) ");
                    sb.Append(" GROUP BY Panel_id ");

                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT Panel_id PanelID,0 BookingOpening, Concat('-',IFNULL(SUM(receivedAmt),0)) ReceivedAmtOpening ");
                    sb.Append(" FROM invoicemaster_onaccount WHERE `ReceivedDate`<=  @dateonly  and creditnote!=2 ");
                    sb.Append(" AND isCancel=0  ");
                    if (PanelID != string.Empty)
                        sb.Append(" AND Panel_ID IN ({0}) ");
                    sb.Append(" GROUP BY Panel_id ");

                    sb.Append(" ) aa GROUP BY PanelID  ");
                    sb.Append(" ) t ON t.PanelId=pm.`Panel_ID` ");
                    if (SearchType != 7)
                    {
                        sb.Append(" where pm.InvoiceTo = pm.panel_id   AND pm.IsInvoice=1 "); 
                        if (PanelID != string.Empty)
                        { 
                            sb.Append(" AND pm.Panel_ID IN ({0}) "); 
                        }
                    } 
                    else if (SearchType == 7)
                    {
                        sb.Append(" where pm.PanelType='PUP' AND pm.IsInvoice=1 AND pm.Payment_Mode='Credit' ");

                        if (PanelID != string.Empty)
                            sb.Append(" AND pm.Panel_ID IN ({0}) ");
                    } 
                    sb.Append(" ORDER BY  pm.`Company_Name` "); 

                    DataTable dtc = new DataTable();
                    dt.Merge(dtc);
                    using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), PanelIDClause), con))
                    {
                        for (int i = 0; i < PanelIDNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(PanelIDNames[i], PanelIDTags[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@dateonly", dateonly);
                        da.SelectCommand.Parameters.AddWithValue("@datewithtime", datewithtime);
                        da.SelectCommand.Parameters.AddWithValue("@type1ID", SearchType);
                        da.Fill(dtc);
                        dt.Merge(dtc);
                    }
                }
                DataView dv = dt.DefaultView;
                dv.Sort = " BusinessZoneID, State,City,PanelName asc";
                DataTable sortedDT = dv.ToTable();
                return Util.getJson(sortedDT);
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
    public static IEnumerable<DateTime> EachDay(DateTime from, DateTime thru)
    {
        for (var day = from.Date; day.Date <= thru.Date; day = day.AddDays(1))
            yield return day;
    }
}
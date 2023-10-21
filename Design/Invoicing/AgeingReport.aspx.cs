using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq;
public partial class Design_Invoicing_AgeingReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            if (UserInfo.RoleID == 1 || UserInfo.RoleID == 177 || UserInfo.RoleID == 6 || UserInfo.RoleID == 221 || UserInfo.RoleID == 244)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script1", "showAccountSearch();", true);
                lblSearchType.Text = "1";
            }
            else
            {
                if (UserInfo.IsSalesTeamMember == 1)
                {
                    lblSearchType.Text = "2";

                }
                else
                {
                    lblSearchType.Text = "3";

                }
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script11", "hideAccountSearch();", true);
            }


            if (UserInfo.RoleID == 220) //Sales
            {
                lblSearchType.Text = "2";
            }
            if (UserInfo.RoleID == 182) //Regional Accounts
            {
                lblSearchType.Text = "4";
            }
        }
    }



    [WebMethod]
    public static string searchLedger(int SearchType, string PanelID, string SalesManager, int IncludeCurrentMonthBusiness, string Type, int ReportFormat)
    {
        StringBuilder sb = new StringBuilder();

        if (PanelID == string.Empty)
            PanelID = GetPanels(SearchType);


        string ToDate = System.DateTime.Now.ToString("yyyy-MM-dd");
        string ToDateTime = System.DateTime.Now.ToString("yyyy-MM-dd 23:59:59");


        string FromDateTime = System.DateTime.Now.AddMonths(-5).ToString("yyyy-MM-01 00:00:00");

        DateTime ToDateTime_Date = System.DateTime.Now;

        if (IncludeCurrentMonthBusiness == 0)
        {
            ToDateTime = System.DateTime.Now.Date.AddDays(-System.DateTime.Now.Day).ToString("yyyy-MM-dd 23:59:59");
            FromDateTime = System.DateTime.Now.AddMonths(-6).ToString("yyyy-MM-01 00:00:00");
            ToDateTime_Date = System.DateTime.Now.Date.AddDays(-System.DateTime.Now.Day);

        }
        string[] PanelIDTags = PanelID.Split(',');
        string[] PanelIDNames = PanelIDTags.Select((s, i) => "@tag" + i).ToArray();
        string PanelIDClause = string.Join(", ", PanelIDNames);

        string[] SalesManagerTags = SalesManager.Split(',');
        string[] SalesManagerNames = SalesManagerTags.Select((s, i) => "@tags" + i).ToArray();
        string SalesManagerClause = string.Join(", ", SalesManagerNames);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (ReportFormat == 1)
            {
                #region MonthWiseAging

                if (IncludeCurrentMonthBusiness == 0)
                {
                    ToDateTime = System.DateTime.Now.Date.AddDays(-System.DateTime.Now.Day).ToString("yyyy-MM-dd 23:59:59");
                    FromDateTime = System.DateTime.Now.AddMonths(-6).ToString("yyyy-MM-01 00:00:00");
                }
                sb.AppendLine(" SELECT pm.Panel_Code PanelCode, pm.company_name PanelName,pm.`State`,pm.`City`,pm.Zone,   ");
                sb.AppendLine(" ROUND((IFNULL(ReceivedAmtOpening,0) - IFNULL(BookingOpening,0)),0)`OutstandingBalance`,  ");
                sb.AppendLine("  IFNULL(CONCAT(em.Title,' ',em.Name),'')SalesManager,  ");


                if (IncludeCurrentMonthBusiness == 1)
                {
                    sb.AppendLine(" `" + System.DateTime.Now.ToString("yyyy-MMM") + "` as `" + System.DateTime.Now.ToString("yyyy-MMM") + "_Business`, ");
                    sb.AppendLine(" `" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MMM") + "` as `" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MMM") + "_Business`, ");
                    sb.AppendLine(" `" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MMM") + "` as `" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MMM") + "_Business`, ");
                    sb.AppendLine(" `" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MMM") + "` as `" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MMM") + "_Business`, ");
                    sb.AppendLine(" `" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MMM") + "` as `" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MMM") + "_Business`, ");
                    sb.AppendLine(" `" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MMM") + "` as `" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MMM") + "_Business` ");

                }
                else
                {
                    sb.AppendLine(" `" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MMM") + "` as `" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MMM") + "_Business`, ");
                    sb.AppendLine(" `" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MMM") + "` as `" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MMM") + "_Business`, ");
                    sb.AppendLine(" `" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MMM") + "` as `" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MMM") + "_Business`, ");
                    sb.AppendLine(" `" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MMM") + "` as `" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MMM") + "_Business`, ");
                    sb.AppendLine(" `" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MMM") + "` as `" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MMM") + "_Business`, ");
                    sb.AppendLine(" `" + System.DateTime.Now.AddMonths(-6).ToString("yyyy-MMM") + "` as `" + System.DateTime.Now.AddMonths(-6).ToString("yyyy-MMM") + "_Business` ");
                }




                sb.AppendLine(" FROM   f_panel_master pm  INNER JOIN employee_master em ON em.Employee_ID=pm.SalesManagerID ");

                if (SearchType != 7)
                {
                    sb.AppendLine(" AND pm.InvoiceTo = pm.panel_id   AND pm.IsInvoice=1 ");

                    if (PanelID != string.Empty)
                        sb.AppendLine(" AND pm.Panel_ID IN ({0}) ");

                } 
                else if (SearchType == 7)
                {
                    sb.AppendLine(" AND pm.PanelType='PUP' AND pm.IsInvoice=1 AND pm.Payment_Mode='Credit' ");

                    if (PanelID != string.Empty)
                        sb.AppendLine(" AND pm.Panel_ID IN ({0}) ");


                }
                sb.AppendLine(" LEFT JOIN  ");
                sb.AppendLine(" (SELECT PanelID,SUM(BookingOpening)BookingOpening, SUM(ReceivedAmtOpening)ReceivedAmtOpening, SUM(BookingCurrent)BookingCurrent, ");

                if (IncludeCurrentMonthBusiness == 1)
                {
                    sb.AppendLine(" SUM(`" + System.DateTime.Now.ToString("yyyy-MMM") + "`) as '" + System.DateTime.Now.ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(`" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MMM") + "`)  as '" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(`" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MMM") + "`)  as '" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(`" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MMM") + "`)  as '" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(`" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MMM") + "`)  as '" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(`" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MMM") + "`)  as '" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MMM") + "' ");

                }
                else
                {
                    sb.AppendLine(" SUM(`" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MMM") + "`)  as '" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(`" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MMM") + "`)  as '" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(`" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MMM") + "`)  as '" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(`" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MMM") + "`)  as '" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(`" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MMM") + "`)  as '" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(`" + System.DateTime.Now.AddMonths(-6).ToString("yyyy-MMM") + "`)  as '" + System.DateTime.Now.AddMonths(-6).ToString("yyyy-MMM") + "' ");
                }

                sb.AppendLine(" FROM ( ");

                sb.AppendLine(" SELECT pnl.`InvoiceTo` PanelID,SUM(plos.PCCInvoiceAmt)BookingOpening,0 ReceivedAmtOpening,0 BookingCurrent, ");
                if (IncludeCurrentMonthBusiness == 1)
                {
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MMM") + "' ");

                }
                else
                {
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-6).ToString("yyyy-MMM") + "' ");
                }

                sb.AppendLine(" FROM patient_labinvestigation_opd_share plos ");
                sb.AppendLine(" INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=plos.`Panel_ID` AND pnl.`IsInvoice`=1 ");
                sb.AppendLine(" Where plos." + Resources.Resource.LedgerReportDate + " <= '" + ToDateTime + "' ");
                if (Resources.Resource.LedgerReportDate == "SRADate")
                    sb.AppendLine(" AND plos.IsSRA=1 ");
                
                if (PanelID != string.Empty)
                    sb.AppendLine(" AND pnl.InvoiceTo IN ({0}) ");
                if (SalesManager != string.Empty)
                    sb.AppendLine(" AND pnl.SalesManager IN ({1}) ");
                sb.AppendLine(" GROUP BY pnl.`InvoiceTo`  ");


                sb.AppendLine(" UNION ALL ");

                sb.AppendLine(" SELECT Panel_id PanelID,0 BookingOpening, IFNULL(SUM(receivedAmt),0) ReceivedAmtOpening,0 BookingCurrent, ");
                if (IncludeCurrentMonthBusiness == 1)
                {
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MMM") + "' ");

                }
                else
                {


                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" 0 as '" + System.DateTime.Now.AddMonths(-6).ToString("yyyy-MMM") + "' ");

                }
                sb.AppendLine(" FROM invoicemaster_onaccount WHERE  isCancel=0  ");
                if (PanelID != string.Empty)
                    sb.AppendLine(" AND Panel_ID IN ({0}) ");
                sb.AppendLine(" GROUP BY Panel_id ");

                sb.AppendLine(" UNION ALL  ");

                sb.AppendLine(" SELECT pnl.`InvoiceTo` PanelID,0 BookingOpening,  0 ReceivedAmtOpening, SUM(plos.PCCInvoiceAmt)BookingCurrent,");


                if (IncludeCurrentMonthBusiness == 1)
                {
                    sb.AppendLine(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " >= '" + System.DateTime.Now.ToString("yyyy-MM-01 00:00:00") + "' AND  plos." + Resources.Resource.LedgerReportDate + " <= '" + System.DateTime.Now.ToString("yyyy-MMM-dd 23:59:59") + "',plos.PCCInvoiceAmt,0 )) as '" + System.DateTime.Now.ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " >= '" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MM-01 00:00:00") + "' AND  plos." + Resources.Resource.LedgerReportDate + " <= '" + System.DateTime.Now.Date.AddDays(-System.DateTime.Now.Day).ToString("yyyy-MM-dd 23:59:59") + "',plos.PCCInvoiceAmt,0 )) as '" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " >= '" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MM-01 00:00:00") + "' AND  plos." + Resources.Resource.LedgerReportDate + " <= '" + System.DateTime.Now.Date.AddMonths(-1).AddDays(-System.DateTime.Now.Day).ToString("yyyy-MM-dd 23:59:59") + "',plos.PCCInvoiceAmt,0 )) as '" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " >= '" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MM-01 00:00:00") + "' AND  plos." + Resources.Resource.LedgerReportDate + " <= '" + System.DateTime.Now.Date.AddMonths(-2).AddDays(-System.DateTime.Now.Day).ToString("yyyy-MM-dd 23:59:59") + "',plos.PCCInvoiceAmt,0 )) as '" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " >= '" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MM-01 00:00:00") + "' AND  plos." + Resources.Resource.LedgerReportDate + " <= '" + System.DateTime.Now.Date.AddMonths(-3).AddDays(-System.DateTime.Now.Day).ToString("yyyy-MM-dd 23:59:59") + "',plos.PCCInvoiceAmt,0 )) as '" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " >= '" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MM-01 00:00:00") + "' AND  plos." + Resources.Resource.LedgerReportDate + " <= '" + System.DateTime.Now.Date.AddMonths(-4).AddDays(-System.DateTime.Now.Day).ToString("yyyy-MM-dd 23:59:59") + "',plos.PCCInvoiceAmt,0 )) as '" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MMM") + "' ");

                }
                else
                {


                    sb.AppendLine(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " >= '" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MM-01 00:00:00") + "' AND  plos." + Resources.Resource.LedgerReportDate + " <= '" + System.DateTime.Now.Date.AddDays(-System.DateTime.Now.Day).ToString("yyyy-MM-dd 23:59:59") + "',plos.PCCInvoiceAmt,0 )) as '" + System.DateTime.Now.AddMonths(-1).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " >= '" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MM-01 00:00:00") + "' AND  plos." + Resources.Resource.LedgerReportDate + " <= '" + System.DateTime.Now.Date.AddMonths(-1).AddDays(-System.DateTime.Now.Day).ToString("yyyy-MM-dd 23:59:59") + "',plos.PCCInvoiceAmt,0 )) as '" + System.DateTime.Now.AddMonths(-2).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " >= '" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MM-01 00:00:00") + "' AND  plos." + Resources.Resource.LedgerReportDate + " <= '" + System.DateTime.Now.Date.AddMonths(-2).AddDays(-System.DateTime.Now.Day).ToString("yyyy-MM-dd 23:59:59") + "',plos.PCCInvoiceAmt,0 )) as '" + System.DateTime.Now.AddMonths(-3).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " >= '" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MM-01 00:00:00") + "' AND  plos." + Resources.Resource.LedgerReportDate + " <= '" + System.DateTime.Now.Date.AddMonths(-3).AddDays(-System.DateTime.Now.Day).ToString("yyyy-MM-dd 23:59:59") + "',plos.PCCInvoiceAmt,0 )) as '" + System.DateTime.Now.AddMonths(-4).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " >= '" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MM-01 00:00:00") + "' AND  plos." + Resources.Resource.LedgerReportDate + " <= '" + System.DateTime.Now.Date.AddMonths(-4).AddDays(-System.DateTime.Now.Day).ToString("yyyy-MM-dd 23:59:59") + "',plos.PCCInvoiceAmt,0 )) as '" + System.DateTime.Now.AddMonths(-5).ToString("yyyy-MMM") + "', ");
                    sb.AppendLine(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " >= '" + System.DateTime.Now.AddMonths(-6).ToString("yyyy-MM-01 00:00:00") + "' AND  plos." + Resources.Resource.LedgerReportDate + " <= '" + System.DateTime.Now.Date.AddMonths(-5).AddDays(-System.DateTime.Now.Day).ToString("yyyy-MM-dd 23:59:59") + "',plos.PCCInvoiceAmt,0 )) as '" + System.DateTime.Now.AddMonths(-6).ToString("yyyy-MMM") + "' ");

                }


                sb.AppendLine(" FROM `patient_labinvestigation_opd_share` plos ");
                sb.AppendLine(" INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=plos.`Panel_ID` AND pnl.`IsInvoice`=1 ");
                sb.AppendLine("  Where plos." + Resources.Resource.LedgerReportDate + " >= '" + FromDateTime + "' ");
                sb.AppendLine("  AND plos." + Resources.Resource.LedgerReportDate + " <= '" + ToDateTime + "' ");



                if (Resources.Resource.LedgerReportDate == "SRADate")
                    sb.AppendLine(" AND plos.IsSRA=1 ");
               
                if (PanelID != string.Empty)
                    sb.AppendLine(" AND pnl.InvoiceTo IN ({0}) ");
                if (SalesManager != string.Empty)
                    sb.AppendLine(" AND pnl.SalesManager IN ({1}) ");
                sb.AppendLine(" GROUP BY pnl.`InvoiceTo` ");

                sb.AppendLine(" ) aa GROUP BY PanelID  ");
                sb.AppendLine(" ) t ON t.PanelId=pm.`Panel_ID` WHERE pm.IsPermanentClose=0 ");

                sb.AppendLine(" ORDER BY pm.Panel_Code ");
                System.IO.File.WriteAllText(@"F:\Errorlog\AgeingReport.txt", sb.ToString());

                string data = string.Empty;
                if (SalesManager == string.Empty)
                    data = string.Format(sb.ToString(), PanelIDClause);
                else
                    string.Format(sb.ToString(), PanelIDClause, SalesManagerClause);

                using (MySqlDataAdapter da = new MySqlDataAdapter(data, con))
                {
                    for (int i = 0; i < PanelIDNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(PanelIDNames[i], PanelIDTags[i]);
                    }
                    if (SalesManager != string.Empty)
                    {
                        for (int i = 0; i < SalesManagerNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(SalesManagerNames[i], SalesManagerTags[i]);
                        }
                    }
                    da.SelectCommand.Parameters.AddWithValue("@SearchType", SearchType);
                    DataTable dt = new DataTable();
                    using (dt as IDisposable)
                    {
                        da.Fill(dt);
                        if (dt.Rows.Count > 0)
                        {
                            using (DataTable dtNew = new DataTable())
                            {
                                foreach (DataColumn dc in dt.Columns)
                                {
                                    dtNew.Columns.Add(dc.ColumnName);
                                    if (dc.ColumnName.Contains("_Business"))
                                    {
                                        dtNew.Columns.Add(dc.ColumnName.Replace("Business", "OutStanding"));
                                    }
                                }
                                dtNew.Columns.Add("Outstanding Older Than Six Months");

                                for (int i = 0; i < dt.Rows.Count; i++)
                                {
                                    DataRow dr = dtNew.NewRow();
                                    dr[0] = Util.GetString(dt.Rows[i][0]);//PanelCode
                                    dr[1] = Util.GetString(dt.Rows[i][1]);//PanelName
                                    dr[2] = Util.GetString(dt.Rows[i][2]);//State
                                    dr[3] = Util.GetString(dt.Rows[i][3]);//City
                                    dr[4] = Util.GetString(dt.Rows[i][4]);//Zone
                                    dr[5] = Util.GetInt(dt.Rows[i][5]); //Outstanding Amount
                                    dr[6] = Util.GetString(dt.Rows[i][6]);//SalesManager


                                    int TotalOutstanding = Util.GetInt(dt.Rows[i][5]);

                                    //-----------------------------------
                                    dr[7] = Util.GetDecimal(dt.Rows[i][7]);//First Month Business
                                    dr[9] = Util.GetDecimal(dt.Rows[i][8]);//Second Month Business
                                    dr[11] = Util.GetDecimal(dt.Rows[i][9]);//Third Month Business
                                    dr[13] = Util.GetDecimal(dt.Rows[i][10]);//Fourth Month Business
                                    dr[15] = Util.GetDecimal(dt.Rows[i][11]);//Fifth Month Business
                                    dr[17] = Util.GetDecimal(dt.Rows[i][12]);//Sixth Month Business

                                    if (Util.GetInt(dt.Rows[i][5]) < 0)
                                    {
                                        TotalOutstanding = TotalOutstanding * (-1);

                                        decimal FirstMonthBusiness = Util.GetDecimal(dt.Rows[i][7]);
                                        decimal SecondMonthBusiness = Util.GetDecimal(dt.Rows[i][8]);
                                        decimal ThirdMonthBusiness = Util.GetDecimal(dt.Rows[i][9]);
                                        decimal FourthMonthBusiness = Util.GetDecimal(dt.Rows[i][10]);
                                        decimal FifthMonthBusiness = Util.GetDecimal(dt.Rows[i][11]);
                                        decimal SixthMonthBusiness = Util.GetDecimal(dt.Rows[i][12]);

                                        //------First Month outstanding--------------------------
                                        if (TotalOutstanding > FirstMonthBusiness)
                                        {
                                            dr[8] = FirstMonthBusiness * (-1);
                                        }
                                        else if (TotalOutstanding < 0)
                                        {
                                            dr[8] = "0";
                                        }
                                        else
                                        {
                                            dr[8] = TotalOutstanding * (-1);
                                        }
                                        //------Second Month outstanding--------------------------
                                        if ((TotalOutstanding - FirstMonthBusiness) > SecondMonthBusiness)
                                        {
                                            dr[10] = SecondMonthBusiness * (-1);
                                        }
                                        else if ((TotalOutstanding - FirstMonthBusiness) < 0)
                                        {
                                            dr[10] = "0";
                                        }
                                        else
                                        {
                                            dr[10] = (TotalOutstanding - FirstMonthBusiness) * (-1);
                                        }

                                        //------Third Month outstanding--------------------------
                                        if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness) > ThirdMonthBusiness)
                                        {
                                            dr[12] = ThirdMonthBusiness * (-1);
                                        }
                                        else if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness) < 0)
                                        {
                                            dr[12] = "0";
                                        }
                                        else
                                        {
                                            dr[12] = (TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness) * (-1);
                                        }

                                        //------Fourth Month outstanding--------------------------
                                        if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness) > FourthMonthBusiness)
                                        {
                                            dr[14] = FourthMonthBusiness * (-1);
                                        }
                                        else if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness) < 0)
                                        {
                                            dr[14] = "0";
                                        }
                                        else
                                        {
                                            dr[14] = (TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness) * (-1);
                                        }


                                        //------Fifth Month outstanding--------------------------
                                        if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness) > FifthMonthBusiness)
                                        {
                                            dr[16] = FifthMonthBusiness * (-1);
                                        }
                                        else if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness) < 0)
                                        {
                                            dr[16] = "0";
                                        }
                                        else
                                        {
                                            dr[16] = (TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness) * (-1);
                                        }

                                        //------Sixth Month outstanding--------------------------
                                        if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness - FifthMonthBusiness) > SixthMonthBusiness)
                                        {
                                            dr[19] = SixthMonthBusiness * (-1);
                                        }
                                        else if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness - FifthMonthBusiness) < 0)
                                        {
                                            dr[19] = "0";
                                        }
                                        else
                                        {
                                            dr[19] = (TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness - FifthMonthBusiness) * (-1);
                                        }


                                        //----Outstanding More than Six Months

                                        if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness - FifthMonthBusiness) > SixthMonthBusiness)
                                        {
                                            dr[18] = SixthMonthBusiness * (-1);
                                        }
                                        else if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness - FifthMonthBusiness) < 0)
                                        {
                                            dr[18] = "0";
                                        }
                                        else
                                        {
                                            dr[18] = (TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness - FifthMonthBusiness) * (-1);
                                        }


                                        //----Outstanding More than Six Months

                                        if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness - FifthMonthBusiness - SixthMonthBusiness) < 0)
                                        {
                                            dr[19] = "0";
                                        }
                                        else
                                        {
                                            dr[19] = (TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness - FifthMonthBusiness - SixthMonthBusiness) * (-1);
                                        }

                                        dtNew.Rows.Add(dr);

                                    }
                                    else
                                    {
                                        dr[8] = "0";//First Month outstanding
                                        dr[10] = "0";//Second Month outstanding
                                        dr[12] = "0";//Third Month outstanding
                                        dr[14] = "0";//Fourth Month outstanding
                                        dr[16] = "0";//Fifth Month outstanding
                                        dr[18] = "0";//Sixth Month outstanding
                                        dr[19] = "0";//outstanding More than Six Months
                                        dtNew.Rows.Add(dr);
                                    }
                                }
                                if (Type == "View")
                                    return Util.getJson(dtNew);
                                else
                                {
                                    HttpContext.Current.Session["dtExport2Excel"] = dtNew;
                                    HttpContext.Current.Session["ReportName"] = "AgeingReport";
                                    return "1";
                                }
                            }
                        }
                        else
                            return null;
                    }
                }
                #endregion
            }
            else
            {
                #region DateWiseAging


                sb.Append(" SELECT pm.Panel_Code PanelCode, pm.company_name PanelName,pm.`State`,pm.`City`,pm.Zone,   ");
                sb.Append(" ROUND((IFNULL(ReceivedAmtOpening,0) - IFNULL(BookingOpening,0)),0)`OutstandingBalance` ");
                if (SearchType == 7)
                    sb.Append(" ,'PUP' SearchType,");
                else
                    sb.Append(" ,cm.Type1 SearchType,");


                sb.Append(" `0-15` as `0-15_Business`, ");
                sb.Append(" `16-30` as `16-30_Business`, ");
                sb.Append(" `31-60` as `31-60_Business`, ");
                sb.Append(" `61-90` as `61-90_Business`, ");
                sb.Append(" `91-120` as `91-120_Business` ");
                sb.Append(" FROM  f_panel_master pm  INNER JOIN employee_master em ON em.Employee_ID=pm.SalesManagerID ");
                if (SearchType != 7)
                {
                    sb.Append(" AND pm.InvoiceTo = pm.panel_id   AND pm.IsInvoice=1 ");
                    if (PanelID != string.Empty)
                        sb.Append(" AND pm.Panel_ID IN ({0}) ");

                }
                // for PUP Search
                else if (SearchType == 7)
                {
                    sb.Append(" AND pm.IsInvoice=1 AND pm.Payment_Mode='Credit' ");
                    if (PanelID != string.Empty)
                        sb.Append(" AND pm.Panel_ID IN ({0}) ");
                }

                sb.Append(" LEFT JOIN  ");
                sb.Append(" (SELECT PanelID,SUM(BookingOpening)BookingOpening, SUM(ReceivedAmtOpening)ReceivedAmtOpening, SUM(BookingCurrent)BookingCurrent, ");
                sb.Append(" sum(`0-15`)  as '0-15', ");
                sb.Append(" sum(`16-30`)  as '16-30', ");
                sb.Append(" sum(`31-60`)  as '31-60', ");
                sb.Append(" sum(`61-90`)  as '61-90', ");
                sb.Append(" sum(`91-120`)  as '91-120' ");
                sb.Append(" FROM ( ");
                sb.Append(" SELECT pnl.`InvoiceTo` PanelID,SUM(plos.PCCInvoiceAmt)BookingOpening,0 ReceivedAmtOpening,0 BookingCurrent, ");
                sb.Append(" 0 as '0-15', ");
                sb.Append(" 0 as '16-30', ");
                sb.Append(" 0 as '31-60', ");
                sb.Append(" 0 as '61-90', ");
                sb.Append(" 0 as '91-120' ");

                sb.Append(" FROM patient_labinvestigation_opd_share plos ");
                sb.Append(" INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=plos.`Panel_ID` AND pnl.`IsInvoice`=1 ");
                sb.Append("  Where plos." + Resources.Resource.LedgerReportDate + " <= '" + ToDateTime + "' ");
                if (Resources.Resource.LedgerReportDate == "SRADate")
                    sb.Append(" AND plos.IsSRA=1 ");
              
                if (PanelID != string.Empty)
                    sb.Append(" AND pnl.InvoiceTo IN ({0}) ");
                if (SalesManager != string.Empty)
                    sb.Append(" AND pnl.SalesManager IN ({1}) ");
                sb.Append(" GROUP BY pnl.`InvoiceTo`  ");


                sb.Append(" UNION ALL ");

                sb.Append(" SELECT Panel_id PanelID,0 BookingOpening, IFNULL(SUM(receivedAmt),0) ReceivedAmtOpening,0 BookingCurrent, ");
                sb.Append(" 0 as '0-15', ");
                sb.Append(" 0 as '16-30', ");
                sb.Append(" 0 as '31-60', ");
                sb.Append(" 0 as '61-90', ");
                sb.Append(" 0 as '91-120' ");
                sb.Append(" FROM invoicemaster_onaccount WHERE  isCancel=0  ");
                if (PanelID != string.Empty)
                    sb.Append(" AND Panel_ID IN ({0}) ");
                sb.Append(" GROUP BY Panel_id ");

                sb.Append(" UNION ALL  ");

                sb.Append(" SELECT pnl.`InvoiceTo` PanelID,0 BookingOpening,  0 ReceivedAmtOpening, SUM(plos.PCCInvoiceAmt)BookingCurrent, ");
                sb.Append(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " > '" + ToDateTime_Date.AddDays(-14).ToString("yyyy-MM-dd 00:00:00") + "' and  plos." + Resources.Resource.LedgerReportDate + " <= '" + ToDateTime_Date.ToString("yyyy-MM-dd 23:59:59") + "',plos.PCCInvoiceAmt,0 )) as '0-15', ");
                sb.Append(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " > '" + ToDateTime_Date.AddDays(-29).ToString("yyyy-MM-dd 00:00:00") + "' and  plos." + Resources.Resource.LedgerReportDate + " <= '" + ToDateTime_Date.AddDays(-14).ToString("yyyy-MM-dd 00:00:00") + "',plos.PCCInvoiceAmt,0 )) as '16-30', ");
                sb.Append(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " > '" + ToDateTime_Date.AddDays(-59).ToString("yyyy-MM-dd 00:00:00") + "' and  plos." + Resources.Resource.LedgerReportDate + " <= '" + ToDateTime_Date.AddDays(-29).ToString("yyyy-MM-dd 00:00:00") + "',plos.PCCInvoiceAmt,0 )) as '31-60', ");
                sb.Append(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " > '" + ToDateTime_Date.AddDays(-89).ToString("yyyy-MM-dd 00:00:00") + "' and  plos." + Resources.Resource.LedgerReportDate + " <= '" + ToDateTime_Date.AddDays(-59).ToString("yyyy-MM-dd 00:00:00") + "',plos.PCCInvoiceAmt,0 )) as '61-90', ");
                sb.Append(" SUM(if( plos." + Resources.Resource.LedgerReportDate + " > '" + ToDateTime_Date.AddDays(-119).ToString("yyyy-MM-dd 00:00:00") + "' and  plos." + Resources.Resource.LedgerReportDate + " <= '" + ToDateTime_Date.AddDays(-89).ToString("yyyy-MM-dd 00:00:00") + "',plos.PCCInvoiceAmt,0 )) as '91-120' ");

                sb.Append(" FROM `patient_labinvestigation_opd_share` plos ");
                sb.Append(" INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=plos.`Panel_ID` AND pnl.`IsInvoice`=1 ");
                sb.Append("  Where plos." + Resources.Resource.LedgerReportDate + " >= '" + ToDateTime_Date.AddDays(-120).ToString("yyyy-MM-dd 00:00:00") + "' ");
                sb.Append("  AND plos." + Resources.Resource.LedgerReportDate + " <= '" + ToDateTime_Date.ToString("yyyy-MM-dd 23:59:59") + "' ");

                if (Resources.Resource.LedgerReportDate == "SRADate")
                    sb.Append(" AND plos.IsSRA=1 ");
              
                if (PanelID != string.Empty)
                    sb.Append(" AND pnl.InvoiceTo IN ({0}) ");
                if (SalesManager != string.Empty)
                    sb.Append(" AND pnl.SalesManager IN ({1}) ");
                sb.Append(" GROUP BY pnl.`InvoiceTo` ");
                sb.Append(" ) aa GROUP BY PanelID  ");
                sb.Append(" ) t ON t.PanelId=pm.`Panel_ID` WHERE pm.IsPermanentClose=0 ");


                sb.Append(" ORDER BY cm.`BusinessZoneID`,cm.`State`,cm.`City`, pm.`Company_Name` ");

                string data = string.Empty;
                if (SalesManager == string.Empty)
                    data = string.Format(sb.ToString(), PanelIDClause);
                else
                    data = string.Format(sb.ToString(), PanelIDClause, SalesManagerClause);
                using (MySqlDataAdapter da = new MySqlDataAdapter(data, con))
                {
                    for (int i = 0; i < PanelIDNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(PanelIDNames[i], PanelIDTags[i]);
                    }
                    if (SalesManager != string.Empty)
                    {
                        for (int i = 0; i < SalesManagerNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(SalesManagerNames[i], SalesManagerTags[i]);
                        }

                    }

                    da.SelectCommand.Parameters.AddWithValue("@SearchType", SearchType);

                    DataTable dt = new DataTable();
                    using (dt as IDisposable)
                    {
                        da.Fill(dt);
                        if (dt.Rows.Count > 0)
                        {
                            using (DataTable dtNew = new DataTable())
                            {
                                foreach (DataColumn dc in dt.Columns)
                                {
                                    dtNew.Columns.Add(dc.ColumnName);
                                    if (dc.ColumnName.Contains("_Business"))
                                    {
                                        dtNew.Columns.Add(dc.ColumnName.Replace("Business", "OutStanding"));
                                    }
                                }
                                dtNew.Columns.Add("Outstanding Older Than 120 Days");

                                for (int i = 0; i < dt.Rows.Count; i++)
                                {
                                    DataRow dr = dtNew.NewRow();
                                    dr[0] = Util.GetString(dt.Rows[i][0]);//PanelCode
                                    dr[1] = Util.GetString(dt.Rows[i][1]);//PanelName
                                    dr[2] = Util.GetString(dt.Rows[i][2]);//State
                                    dr[3] = Util.GetString(dt.Rows[i][3]);//City
                                    dr[4] = Util.GetString(dt.Rows[i][4]);//Zone
                                    dr[5] = Util.GetInt(dt.Rows[i][5]); //Outstanding Amount
                                    dr[6] = Util.GetString(dt.Rows[i][6]);//SearchType

                                    int TotalOutstanding = Util.GetInt(dt.Rows[i][5]);

                                    //-----------------------------------
                                    dr[7] = Util.GetDecimal(dt.Rows[i][7]);//First Month Business
                                    dr[9] = Util.GetDecimal(dt.Rows[i][8]);//Second Month Business
                                    dr[11] = Util.GetDecimal(dt.Rows[i][9]);//Third Month Business
                                    dr[13] = Util.GetDecimal(dt.Rows[i][10]);//Fourth Month Business
                                    dr[15] = Util.GetDecimal(dt.Rows[i][11]);//Fifth Month Business


                                    if (Util.GetInt(dt.Rows[i][5]) < 0)
                                    {
                                        TotalOutstanding = TotalOutstanding * (-1);

                                        decimal FirstMonthBusiness = Util.GetDecimal(dt.Rows[i][7]);
                                        decimal SecondMonthBusiness = Util.GetDecimal(dt.Rows[i][8]);
                                        decimal ThirdMonthBusiness = Util.GetDecimal(dt.Rows[i][9]);
                                        decimal FourthMonthBusiness = Util.GetDecimal(dt.Rows[i][10]);
                                        decimal FifthMonthBusiness = Util.GetDecimal(dt.Rows[i][11]);


                                        //------0-15 outstanding--------------------------
                                        if (TotalOutstanding > FirstMonthBusiness)
                                        {
                                            dr[8] = FirstMonthBusiness * (-1);
                                        }
                                        else if (TotalOutstanding < 0)
                                        {
                                            dr[8] = "0";
                                        }
                                        else
                                        {
                                            dr[8] = TotalOutstanding * (-1);
                                        }


                                        //------16-30 outstanding--------------------------
                                        if ((TotalOutstanding - FirstMonthBusiness) > SecondMonthBusiness)
                                        {
                                            dr[10] = SecondMonthBusiness * (-1);
                                        }
                                        else if ((TotalOutstanding - FirstMonthBusiness) < 0)
                                        {
                                            dr[10] = "0";
                                        }
                                        else
                                        {
                                            dr[10] = (TotalOutstanding - FirstMonthBusiness) * (-1);
                                        }

                                        //------31-60 outstanding--------------------------
                                        if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness) > ThirdMonthBusiness)
                                        {
                                            dr[12] = ThirdMonthBusiness * (-1);
                                        }
                                        else if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness) < 0)
                                        {
                                            dr[12] = "0";
                                        }
                                        else
                                        {
                                            dr[12] = (TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness) * (-1);
                                        }

                                        //------61-90 outstanding--------------------------
                                        if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness) > FourthMonthBusiness)
                                        {
                                            dr[14] = FourthMonthBusiness * (-1);
                                        }
                                        else if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness) < 0)
                                        {
                                            dr[14] = "0";
                                        }
                                        else
                                        {
                                            dr[14] = (TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness) * (-1);
                                        }


                                        //------91-120 outstanding--------------------------
                                        if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness) > FifthMonthBusiness)
                                        {
                                            dr[16] = FifthMonthBusiness * (-1);
                                        }
                                        else if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness) < 0)
                                        {
                                            dr[16] = "0";
                                        }
                                        else
                                        {
                                            dr[16] = (TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness) * (-1);
                                        }



                                        //----Outstanding More than 120

                                        if ((TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness - FifthMonthBusiness) < 0)
                                        {
                                            dr[17] = "0";
                                        }
                                        else
                                        {
                                            dr[17] = (TotalOutstanding - FirstMonthBusiness - SecondMonthBusiness - ThirdMonthBusiness - FourthMonthBusiness - FifthMonthBusiness) * (-1);
                                        }

                                        dtNew.Rows.Add(dr);

                                    }
                                    else
                                    {
                                        dr[8] = "0";//0-15 outstanding
                                        dr[10] = "0";//16-30 outstanding
                                        dr[12] = "0";//31-60 outstanding
                                        dr[14] = "0";//61-90 outstanding
                                        dr[16] = "0";//91-120 outstanding
                                        dr[17] = "0";//outstanding More than 120
                                        dtNew.Rows.Add(dr);

                                    }
                                }
                                if (Type == "View")
                                    return Util.getJson(dtNew);
                                else
                                {
                                    HttpContext.Current.Session["dtExport2Excel"] = dtNew;
                                    HttpContext.Current.Session["ReportName"] = "AgeingReport";
                                    return "1";
                                }

                            }

                        }
                        else
                            return null;
                    }
                }
                #endregion
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

    private static string GetPanels(int SearchType)
    {
        string PanelId = string.Empty;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            if (UserInfo.RoleID == 220)//Sales
            {

                string SalesTeamMembers = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "CALL get_ChildNode_proc(@UserID,@Sales)",
                    new MySqlParameter("@UserID", UserInfo.ID)));


                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT GROUP_CONCAT(fpm.Panel_ID) Panel_ID  ");
                sb.Append(" FROM f_panel_master fpm INNER JOIN Centre_master cm ON fpm.CentreID=cm.CentreID AND fpm.SalesManager IN (" + SalesTeamMembers + ") ");
                sb.Append("  WHERE fpm.PanelType ='Centre' AND fpm.Panel_ID=fpm.InvoiceTo  AND fpm.IsPermanentClose=0 ");


                PanelId = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@type1ID", SearchType)));
            }
            else if (UserInfo.RoleID == 182)//Regional Accounts
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" SELECT GROUP_CONCAT(fpm.Panel_ID) Panel_Id FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID  ");
                sb.Append(" WHERE  ");
                sb.Append(" cm.IsActive=1  AND fpm.IsInvoice=1  AND fpm.Panel_ID=fpm.InvoiceTo AND fpm.IsPermanentClose=0  AND ( cm.CentreID IN (SELECT CentreAccess FROM centre_access WHERE CentreID =@CentreID ) OR cm.CentreID =@CentreID )  ");

                PanelId = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@CentreID", UserInfo.Centre)));
            }
            else
            {
                PanelId = "";
            }
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            PanelId = "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
        return PanelId;
    }

    [WebMethod]
    public static string salesManager()
    {
        if (UserInfo.RoleID == 1 || UserInfo.RoleID == 177 || UserInfo.RoleID == 6 || UserInfo.RoleID == 221 || UserInfo.RoleID == 244 || UserInfo.RoleID == 182)// 
        {
            return Util.getJson(StockReports.GetDataTable(" SELECT Name PRONAME,Employee_Id PROID FROM Employee_Master where isSalesteammember=1 AND IsActive=1 order by DesignationID+0"));
        }
        else
        {
            string EmpIds = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`(" + UserInfo.ID + ",@Sales)");
            return Util.getJson(StockReports.GetDataTable(" SELECT Name PRONAME,Employee_Id PROID FROM Employee_Master where Employee_Id IN (" + EmpIds + ") "));
        }
    }




    [WebMethod(EnableSession = true)]
    public static string BindPanel(string BusinessZoneID, string StateID, string SearchType, string SalesManager, string PanelGroup)
    {
        if (SalesManager != string.Empty)
        {
            string[] SMgr = SalesManager.Trim().Split(',');
            SalesManager = string.Empty;
            if (SMgr.Length > 0)
            {
                for (int i = 0; i < SMgr.Length; i++)
                {
                    string EmpIds = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`(" + SMgr[i] + ",@Sales)");
                    if (EmpIds.Length > 0)
                    {
                        SalesManager += EmpIds + ",";
                    }
                }
            }

            SalesManager = SalesManager.TrimEnd(',');
        }
        string[] SalesTeamTags = SalesManager.Split(',');
        string[] SalesTeamNames = SalesTeamTags.Select((s, i) => "@tag" + i).ToArray();
        string SalesTeamClause = string.Join(", ", SalesTeamNames);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (SearchType != "7")
            {
                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,fpm.Panel_ID,11 Type1 FROM f_panel_master fpm  # INNER JOIN centre_master cm #  cm.CentreID=fpm.CentreID ");
                sb.Append(" WHERE   fpm.IsInvoice=1  ");
                if (BusinessZoneID != "0")
                    sb.Append("  AND fpm.BusinessZoneID=@BusinessZoneID ");
                if (StateID != "-1" && StateID != "" && StateID != null)
                    sb.Append("  AND fpm.StateID=@StateID ");
                sb.Append("   AND fpm.Panel_ID=fpm.InvoiceTo   ");
                sb.Append("   AND fpm.PanelGroup='" + PanelGroup + "'  ");
            }
            else
            {
                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,fpm.Panel_ID,'PUP' Type1 FROM f_panel_master fpm ");
                sb.Append(" WHERE fpm.TagProcessingLabID IN (SELECT CentreID FROM centre_master WHERE  BusinessZoneID=@BusinessZoneID");
                if (StateID != "-1")
                    sb.Append("  AND StateID=@StateID ");
                sb.Append(" )AND fpm.PanelType='PUP' AND fpm.IsInvoice=1 ");
            }
            sb.Append("   AND fpm.IsPermanentClose=0 ");
            if (SalesManager != string.Empty)
            {
                sb.Append(" AND fpm.SalesManager IN ({0}) ");
            }
            sb.Append(" ORDER BY fpm.Company_Name");

            string data = string.Empty;
            if (SalesManager != string.Empty)
                data = string.Format(sb.ToString(), SalesTeamClause);
            else
                data = sb.ToString();

            //System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\ioj.txt",sb.ToString());
            using (MySqlDataAdapter da = new MySqlDataAdapter(data, con))
            {
                for (int i = 0; i < SalesTeamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(SalesTeamNames[i], SalesTeamTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@BusinessZoneID", BusinessZoneID);
                da.SelectCommand.Parameters.AddWithValue("@StateID", StateID);
                da.SelectCommand.Parameters.AddWithValue("@SearchType", SearchType);

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
    [WebMethod(EnableSession = true)]
    public static string SalesChildNode(string SearchType, string SalesManager)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string SalesTeamMembers = AllLoad_Data.getSalesChildNode(con, Util.GetInt(HttpContext.Current.Session["ID"].ToString()));

            string[] SalesTeamTags = SalesTeamMembers.Split(',');
            string[] SalesTeamNames = SalesTeamTags.Select((s, i) => "@tag" + i).ToArray();
            string SalesTeamClause = string.Join(", ", SalesTeamNames);


            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,fpm.Panel_ID Panel_ID,cm.Type1ID,fpm.ShowBalanceAmt  ");
            sb.Append(" FROM f_panel_master fpm INNER JOIN Centre_master cm ON fpm.CentreID=cm.CentreID  ");
            if (UserInfo.RoleID == 1 || UserInfo.RoleID == 177 || UserInfo.RoleID == 6 || UserInfo.RoleID == 221 || UserInfo.RoleID == 244 || UserInfo.RoleID == 182)
            {

            }
            else
            {
                sb.Append(" AND fpm.SalesManager IN ({0}) ");
            }
            sb.Append("  WHERE fpm.PanelType ='Centre' AND fpm.Panel_ID=fpm.InvoiceTo  AND fpm.IsPermanentClose=0 ");
            sb.Append(" AND cm.type1ID=@SearchType ");
            if (SalesManager != string.Empty)
                sb.Append(" AND fpm.SalesManager IN ({0}) ");

            string data = string.Empty;
            if (SalesManager != string.Empty)
                data = string.Format(sb.ToString(), SalesTeamClause);
            else
                data = sb.ToString();

            using (MySqlDataAdapter da = new MySqlDataAdapter(data, con))
            {
                for (int i = 0; i < SalesTeamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(SalesTeamNames[i], SalesTeamTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@SearchType", SearchType);

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
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string SalesCentreAccess(string SalesManager)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] SalesTeamTags = SalesManager.Split(',');
            string[] SalesTeamNames = SalesTeamTags.Select((s, i) => "@tag" + i).ToArray();
            string SalesTeamClause = string.Join(", ", SalesTeamNames);

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,fpm.Panel_ID Panel_ID,cm.Type1ID,fpm.ShowBalanceAmt FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID  ");
            sb.Append(" WHERE  ");
            sb.Append(" cm.IsActive=1  AND fpm.IsInvoice=1  AND fpm.Panel_ID=fpm.InvoiceTo AND fpm.IsPermanentClose=0  AND ( cm.CentreID IN (SELECT CentreAccess FROM centre_access WHERE CentreID =@CentreID ) OR cm.CentreID =@CentreID )  ");
            sb.Append(" AND fpm.SalesManager IN ({0}) ");
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), SalesTeamClause), con))
            {
                for (int i = 0; i < SalesTeamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(SalesTeamNames[i], SalesTeamTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@CentreID", UserInfo.ID);

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
    [WebMethod(EnableSession = true)]
    public static string bindRegionalClient(string BusinessZoneID, string StateID, string SearchType, string SalesManager)
    {
        if (SalesManager != string.Empty)
        {
            string[] SMgr = SalesManager.Split(',');
            SalesManager = "";

            if (SMgr.Length > 0)
            {
                for (int i = 0; i < SMgr.Length; i++)
                {
                    string EmpIds = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`(" + SMgr[i] + ",@Sales)");
                    if (EmpIds.Length > 0)
                    {
                        SalesManager += EmpIds + ",";
                    }
                }
            }
            SalesManager = SalesManager.TrimEnd(',');
        }
        string[] SalesManagerTags = SalesManager.Split(',');
        string[] SalesManagerNames = SalesManagerTags.Select((s, i) => "@tag" + i).ToArray();
        string SalesManagerClause = string.Join(", ", SalesManagerNames);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (SearchType != "7")
            {
                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,fpm.Panel_ID,cm.Type1 FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID ");
                sb.Append(" WHERE   fpm.IsInvoice=1  AND fpm.TagBusinessLabID=@TagBusinessLabID ");
                if (BusinessZoneID != "0")
                    sb.Append("  AND cm.BusinessZoneID=@BusinessZoneID ");
                if (StateID != "-1" && StateID != string.Empty && StateID != null)
                    sb.Append("  AND cm.StateID=@StateID ");
                sb.Append(" AND fpm.Panel_ID=fpm.InvoiceTo   ");
                sb.Append(" AND cm.type1ID=@SearchType ");
            }
            else
            {
                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,fpm.Panel_ID,'PUP' Type1 FROM f_panel_master fpm ");
                sb.Append(" WHERE fpm.TagProcessingLabID IN (SELECT CentreID FROM centre_master WHERE  BusinessZoneID=@BusinessZoneID");
                if (StateID != "-1")
                    sb.Append("  AND StateID=@StateID ");
                sb.Append(" )AND fpm.PanelType='PUP' AND fpm.IsInvoice=1 ");
            }
            sb.Append("   AND fpm.IsPermanentClose=0 ");
            if (SalesManager != string.Empty)
            {
                sb.Append(" AND fpm.SalesManager IN ({0}) ");
            }
            sb.Append(" ORDER BY fpm.Company_Name");
            string data = string.Empty;
            if (SalesManager != string.Empty)
                data = string.Format(sb.ToString(), SalesManagerClause);
            else
                data = sb.ToString();


            using (MySqlDataAdapter da = new MySqlDataAdapter(data, con))
            {
                for (int i = 0; i < SalesManagerNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(SalesManagerNames[i], SalesManagerTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@SearchType", SearchType);
                da.SelectCommand.Parameters.AddWithValue("@BusinessZoneID", BusinessZoneID);
                da.SelectCommand.Parameters.AddWithValue("@StateID", StateID);
                da.SelectCommand.Parameters.AddWithValue("@TagBusinessLabID", UserInfo.Centre);
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

}
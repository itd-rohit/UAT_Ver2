using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Invoicing_LedgerReport : System.Web.UI.Page
{
    public static string retValue = "1";

    protected void Page_Load(object sender, EventArgs e)
    {


        if (!IsPostBack)
        {
            BindPanelGroup();
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "All");
            //ddlState.Items.Insert(0, new ListItem("All", "-1"));
            txtFromDate.Text = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            chkCondition();

        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");



    }

    private void chkCondition()
    {


        if (UserInfo.RoleID == 1 || UserInfo.RoleID == 177 || UserInfo.RoleID == 6)
        {
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script1", "showAccountSearch();", true);
            lblSearchType.Text = "1";
        }
        else
        {
            if (Session["IsSalesTeamMember"].ToString() == "1")
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "hideSearchCriteria1();", true);
                lblSearchType.Text = "2";
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "hideSearchCriteria();", true);
                lblSearchType.Text = "3";
            }
        }
    }



    public static void PUPLedgerReport(string PanelName, int? PanelID, DateTime FromDate, DateTime ToDate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT '0001-01-01' DateOrder, 'OPENING' `Month`,'' MRP,'' Net,'' DepositAmount,  ");
            sb.Append(" round((ifnull(ReceivedAmt,0)-ifnull(NetAmount,0)),2) Closing FROM  ");
            sb.Append(" ( SELECT SUM(`ReceivedAmt`)ReceivedAmt FROM `invoicemaster_onaccount` WHERE `IsCancel`=0 AND `Panel_ID`=@PanelID AND  ");
            sb.Append(" `ReceivedDate` < @FromReceiveDate ) a ");
            sb.Append(" ,( SELECT SUM(plos.`PCCInvoiceAmt`)NetAmount  ");
            sb.Append(" FROM `patient_labinvestigation_opd_share` plos  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID`  ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID`   ");
            sb.AppendFormat(" AND plos.{0} < @FromDate ", Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");
            sb.Append(" AND plos.Isssamplecollected<>'R' AND pm.`InvoiceTo`=@PanelID) b ");

            sb.Append(" UNION ALL  ");


            sb.Append(" SELECT DateOrder,`Month`,round(SUM(MRP),2) MRP,round(SUM(Net),2) Net, round(SUM(DepositAmount),2) DepositAmount,0 Closing ");
            sb.Append(" FROM ( ");
            sb.Append(" SELECT ReceivedDate DateOrder, CONCAT(MONTHNAME(ReceivedDate),'-',YEAR(ReceivedDate)) `Month`,'0' MRP, ");
            sb.Append(" '0' Net, IFNULL(SUM(`ReceivedAmt`),0) DepositAmount,0 Closing ");
            sb.Append(" FROM `invoicemaster_onaccount` WHERE `IsCancel`=0 AND `Panel_ID`=@PanelID AND  ");
            sb.Append(" `ReceivedDate` >= @FromReceiveDate AND `ReceivedDate` <= @ToReceiveDate GROUP BY YEAR(ReceivedDate),MONTH(ReceivedDate) ");

            sb.Append(" UNION ALL   ");

            sb.AppendFormat(" SELECT plos.date DateOrder, CONCAT(MONTHNAME(plos.{0}),'-',YEAR(plos.{1})) `Month`,  ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);
            sb.Append(" SUM(IFNULL(r.rate,0)*plos.`Quantity`) MRP, ");
            sb.Append(" SUM(plos.`Amount`) Net, ");
            sb.Append(" 0 DepositAmount,0 Closing   ");
            sb.Append(" FROM  `patient_labinvestigation_opd_share` plos  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID`  ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` AND pm.`InvoiceTo`=@PanelID ");
            sb.AppendFormat(" AND plos.{0} >= @FromDate AND plos.{1} <= @ToDate ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");

            sb.Append(" INNER JOIN f_panel_master pm2 ON pm2.centreID=pm.TagProcessingLabID AND pm2.paneltype='Centre' ");
            sb.Append(" LEFT JOIN f_ratelist r ON r.ItemID=plos.ItemID AND r.panel_ID= pm2.`ReferenceCodeOPD`  ");
            sb.AppendFormat(" GROUP BY YEAR(plos.{0}),MONTH(plos.{1}) ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);

            sb.Append(" ) aa GROUP BY `Month` ");
            sb.Append(" ORDER BY DateOrder ");
            //System.IO.File.WriteAllText (@"D:\Shat\aa.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@PanelID", PanelID),
                   new MySqlParameter("@FromDate", string.Concat(FromDate.ToString("yyyy-MM-dd"), " ", "00:00:00")),
                   new MySqlParameter("@ToDate", string.Concat(ToDate.ToString("yyyy-MM-dd"), " ", "23:59:59")),
                   new MySqlParameter("@FromReceiveDate", FromDate.ToString("yyyy-MM-dd")),
                   new MySqlParameter("@ToReceiveDate", FromDate.ToString("yyyy-MM-dd"))).Tables[0])
            {


                if (dt != null && dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (i > 0)
                        {
                            dt.Rows[i]["Closing"] = Util.GetDouble(dt.Rows[i - 1]["Closing"]) - Util.GetDouble(dt.Rows[i]["Net"]) + Util.GetDouble(dt.Rows[i]["DepositAmount"]);
                        }

                    }

                    dt.Columns.Remove("DateOrder");
                    dt.AcceptChanges();

                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = PanelName.Replace(",", "") + " Ledger Report Summary ";
                    HttpContext.Current.Session["Period"] = string.Format("From : {0:dd-MMM-yyyy} To : {1:dd-MMM-yyyy}", FromDate, ToDate);
                    retValue = "1";
                }
                else
                {
                    retValue = "0";
                }

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


    public static void PUPLedgerReportDetail(string PanelName, int? PanelID, DateTime FromDate, DateTime ToDate, string ClientTypeID, string ClientType, int AllLedger = 0)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ");
            if (AllLedger == 1)
                sb.Append(" pm1.`Panel_Code` ClientCode,pm1.`Company_Name` ClientName, ");
            sb.Append("   DATE_FORMAT(plos.`Date`,'%d-%b-%Y %I:%i %p') BillDate,plos.BillNo,plos.`LedgerTransactionNo` VisitNo, ");
            if (AllLedger == 0)
                sb.Append("  pm.`Panel_Code` PUPCode,pm1.PName PatientName,(select BarcodeNo from  patient_labinvestigation_opd where Test_id=plos.Test_id Limit 1 ) BarcodeNo, pm.`Company_Name` PUPName,  ");
            sb.Append("  pm2.`Company_Name` TagProcessingLab,pm2.`Panel_Code` TagProcessingLabCode, ");
            sb.Append(" im.TestCode `TestCode`,im.TypeName TestName,(plos.`Amount`) Net,IFNULL(plos.`InvoiceNo`,'')InvoiceNo ");
            sb.Append(" FROM  `patient_labinvestigation_opd_share` plos  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID`  ");
            sb.Append("  INNER JOIN f_itemmaster im ON im.ItemID=plos.ItemID ");
            sb.AppendFormat(" AND plos.{0} >= @FromDate AND plos.{1} <= @ToDate ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");
            sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` ");
            sb.Append("  INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=plos.`LedgerTransactionNo` ");
            sb.Append("  INNER JOIN patient_master pm1  ON pm1.Patient_ID = lt.Patient_ID  ");
            if (AllLedger == 0)
            {
                sb.Append("   AND pm.`InvoiceTo`=@PanelID  ");
            }
            else
            {
                sb.Append(" INNER JOIN f_panel_master pm1 ON pm1.`Panel_ID`= pm.`InvoiceTo` AND pm1.`IsInvoice`=1   ");
            }
            sb.Append("  INNER JOIN f_panel_master pm2 ON pm2.centreID=pm.TagProcessingLabID AND pm2.paneltype='Centre'  ");
            sb.Append("  LEFT JOIN f_ratelist r ON r.ItemID=plos.ItemID AND r.panel_ID= pm2.`ReferenceCodeOPD`   ");
            sb.AppendFormat("  ORDER BY pm.`Company_Name`,plos.{0} ", Resources.Resource.LedgerReportDate);
          //  System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\pup.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
              new MySqlParameter("@Type1ID", ClientTypeID),
              new MySqlParameter("@PanelID", PanelID),
              new MySqlParameter("@FromDate", string.Concat(FromDate.ToString("yyyy-MM-dd"), " ", "00:00:00")),
              new MySqlParameter("@ToDate", string.Concat(ToDate.ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                string ReportName = string.Empty;
                if (AllLedger == 1)
                    ReportName = string.Format("All {0} Client Ledger Report Detail", ClientType);
                else
                    ReportName = PanelName + " Ledger Report Detail ";

                if (dt != null && dt.Rows.Count > 0)
                {



                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = ReportName.Replace(",", "") + " Ledger Report Detail ";
                    HttpContext.Current.Session["Period"] = string.Format("From : {0:dd-MMM-yyyy} To : {1:dd-MMM-yyyy}", FromDate, ToDate);
                    retValue = "1";
                }
                else
                {
                    retValue = "0";
                }

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


    public static void HLMLedgerReport(string PanelName, int? PanelID, DateTime FromDate, DateTime ToDate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT '0001-01-01' DateOrder, 'OPENING' `Month`,'' Net,'' DepositAmount,  ");
            sb.Append(" round((ifnull(ReceivedAmt,0)-ifnull(PCCInvoiceAmt,0)),2) Closing FROM  ");
            sb.Append(" ( SELECT SUM(`ReceivedAmt`)ReceivedAmt FROM `invoicemaster_onaccount` WHERE `IsCancel`=0 AND `Panel_ID`=@PanelID AND  ");
            sb.Append(" `ReceivedDate` < @FromReceiveDate ) a, ");
            sb.Append(" ( SELECT SUM(plos.`PCCInvoiceAmt`)PCCInvoiceAmt  ");
            sb.Append("  FROM `patient_labinvestigation_opd_share` plos ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID`  ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` AND pm.`InvoiceTo`=@PanelID AND pm.InvoiceCreatedOn=2 ");

            sb.AppendFormat("  AND plos.{0} < @FromDate ", Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");
            sb.Append(" ) b ");

            sb.Append(" UNION ALL  ");


            sb.Append(" SELECT DateOrder,`Month`,round(SUM(Net),2) Net, round(SUM(DepositAmount),2) DepositAmount,0 Closing ");
            sb.Append(" FROM ( ");
            sb.Append(" SELECT ReceivedDate DateOrder, CONCAT(MONTHNAME(ReceivedDate),'-',YEAR(ReceivedDate)) `Month`,'0' Net, ");
            sb.Append("  IFNULL(SUM(`ReceivedAmt`),0) DepositAmount,0 Closing ");
            sb.Append(" FROM `invoicemaster_onaccount` WHERE `IsCancel`=0 AND `Panel_ID`=@PanelID AND  ");
            sb.Append(" `ReceivedDate` >= @FromReceiveDate AND `ReceivedDate` <= @ToReceiveDate GROUP BY YEAR(ReceivedDate),MONTH(ReceivedDate) ");

            sb.Append(" UNION ALL   ");

            sb.AppendFormat(" SELECT plos.date DateOrder, CONCAT(MONTHNAME(plos.{0}),'-',YEAR(plos.{1})) `Month`,  ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);
            sb.Append(" SUM(plos.`PCCInvoiceAmt`) Net,  ");
            sb.Append(" 0 DepositAmount,0 Closing   ");
            sb.Append(" FROM `patient_labinvestigation_opd_share` plos  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID`  ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` AND pm.`InvoiceTo`=@PanelID AND pm.InvoiceCreatedOn=2 ");
            sb.AppendFormat(" AND plos.{0} >= @FromDate AND plos.{1} <= @ToDate ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");
            sb.AppendFormat("  GROUP BY YEAR(plos.{0}),MONTH(plos.{1}) ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);
            sb.Append(" ) aa group by `Month` ");
            sb.Append(" ORDER BY DateOrder ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@PanelID", PanelID),
                   new MySqlParameter("@FromDate", string.Concat(FromDate.ToString("yyyy-MM-dd"), " ", "00:00:00")),
                   new MySqlParameter("@ToDate", string.Concat(ToDate.ToString("yyyy-MM-dd"), " ", "23:59:59")),
                   new MySqlParameter("@FromReceiveDate", FromDate.ToString("yyyy-MM-dd")),
                   new MySqlParameter("@ToReceiveDate", FromDate.ToString("yyyy-MM-dd"))).Tables[0])
            {


                if (dt != null && dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (i > 0)
                        {
                            dt.Rows[i]["Closing"] = Util.GetDouble(dt.Rows[i - 1]["Closing"]) - Util.GetDouble(dt.Rows[i]["Net"]) + Util.GetDouble(dt.Rows[i]["DepositAmount"]);
                        }

                    }

                    dt.Columns.Remove("DateOrder");
                    dt.AcceptChanges();

                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = PanelName + " Ledger Report Summary ";
                    HttpContext.Current.Session["Period"] = string.Format("From : {0:dd-MMM-yyyy} To : {1:dd-MMM-yyyy}", FromDate, ToDate);
                    retValue = "1";
                }
                else
                {
                    retValue = "0";
                }
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


    public static void HLMLedgerReportDetail(string PanelName, int? PanelID, DateTime FromDate, DateTime ToDate, int AllLedger = 0)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ");
            if (AllLedger == 1)
                sb.Append(" pm1.`Panel_Code` ClientCode,pm1.`Company_Name` ClientName, ");
            sb.Append("  DATE_FORMAT(plos.`Date`,'%d-%b-%Y %I:%i %p') BillDate,plos.`BillNo`,plos.`LedgerTransactionNo` VisitNo, ");
            if (AllLedger == 0)
                sb.Append(" pm.`Panel_Code` HLMCode,pm.`Company_Name` HLMName, ");
            sb.Append(" `HLMPatientType`,HLMOPDIPDNo ,im.TestCode `TestCode`,im.`TypeName` TestName,(plos.`PCCInvoiceAmt`) Net ");
            sb.Append(" FROM `f_ledgertransaction` lt ");
            sb.Append(" INNER JOIN  `patient_labinvestigation_opd_share` plos ON lt.LedgertransactionID=plos.LedgertransactionID   ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=plos.ItemID ");
            sb.AppendFormat(" AND plos.{0} >= @FromDate AND plos.{1} <= @ToDate  ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` AND pm.InvoiceCreatedOn=2 ");
            if (AllLedger == 0)
            {
                sb.Append(" AND pm.`InvoiceTo`=@PanelID  ");
            }
            else
            {
                sb.Append(" INNER JOIN f_panel_master pm1 ON pm1.`Panel_ID`= pm.`InvoiceTo` AND pm1.`IsInvoice`=1 ");
                sb.Append(" INNER JOIN `centre_master` cm ON cm.`CentreID`=pm1.`CentreID`  AND cm.`type1`='HLM' ");
            }
            sb.AppendFormat(" ORDER BY pm.`Company_Name`,plos.{0} ", Resources.Resource.LedgerReportDate);

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
              new MySqlParameter("@PanelID", PanelID),
              new MySqlParameter("@FromDate", string.Concat(FromDate.ToString("yyyy-MM-dd"), " ", "00:00:00")),
              new MySqlParameter("@ToDate", string.Concat(ToDate.ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (dt != null && dt.Rows.Count > 0)
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = PanelName + " Ledger Report Summary ";
                    HttpContext.Current.Session["Period"] = string.Format("From : {0:dd-MMM-yyyy} To : {1:dd-MMM-yyyy}", FromDate, ToDate);
                    retValue = "1";
                }
                else
                {
                    retValue = "0";
                }
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


    [WebMethod(EnableSession = true)]
    public static string getReportData(string PanelName, int? PanelID, string dtFrom, string dtTo, string ClientType, string ClientTypeID, string ReportType, string password, int AllLedger, int IsPassword)
    {
        if (UserInfo.RoleID != 1 && UserInfo.RoleID != 177 && UserInfo.RoleID != 6 && HttpContext.Current.Session["IsSalesTeamMember"].ToString() == "0" && IsPassword == 0)
        {
            if (AllLoad_Data.getLedgerReportPassword(PanelID) != string.Empty)
                return "8";
        }
        if (IsPassword == 1 && AllLoad_Data.getLedgerPasswordMatches(password, AllLoad_Data.getLedgerReportPassword(PanelID)) == 0)
        {
            return "5";
        }

        DateTime dateFrom = Convert.ToDateTime(dtFrom);
        DateTime dateTo = Convert.ToDateTime(dtTo);
        double TotDays = (dateTo - dateFrom).TotalDays;
        if (ReportType == "Summary")
        {
            if (TotDays > 180)
            {
                retValue = "2";
                return retValue;
            }
            B2BLedgerReport(PanelName, PanelID, dateFrom, dateTo);
        }
        else if (ReportType == "Detail")
        {
            if (TotDays > 31)
            {
                retValue = "3";
                return retValue;
            }
            B2BLedgerReportDetail(PanelName, PanelID, dateFrom, dateTo, ClientTypeID, ClientType, AllLedger);

        }
        return retValue;
    }

    [WebMethod]
    public static string encryptData(string PanelID, string Type)
    {
        List<string> addEncrypt = new List<string>();
        addEncrypt.Add(Common.Encrypt(PanelID));
        addEncrypt.Add(Common.Encrypt(Type));
        return JsonConvert.SerializeObject(addEncrypt);
    }
    public static void CCLedgerReport(string PanelName, int? PanelID, DateTime FromDate, DateTime ToDate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT '0001-01-01' DateOrder, 'OPENING' `Month`,''PatientRate,''PatientDisc,''PatientNetRate,'' ShareAmt,'' DepositAmount,  ");
            sb.Append(" round((ifnull(ReceivedAmt,0)-ifnull(NetAmount,0)),2) Closing FROM  ");
            sb.Append(" ( SELECT SUM(`ReceivedAmt`)ReceivedAmt FROM `invoicemaster_onaccount` WHERE `IsCancel`=0 AND `Panel_ID`=@PanelID AND  ");
            sb.Append(" `ReceivedDate` < @FromReceiveDate ) a ");
            sb.Append(" ,( SELECT SUM(plos.`PCCInvoiceAmt`)NetAmount  ");
            sb.Append(" FROM `patient_labinvestigation_opd_share` plos   ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID`   AND pm.InvoiceCreatedOn=2 ");
            sb.AppendFormat(" AND plos.{0} < @FromDate ", Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");
            sb.Append(" AND pm.`InvoiceTo`=@PanelID) b ");

            sb.Append(" UNION ALL  ");


            sb.Append(" SELECT DateOrder,`Month`,ROUND(SUM(PatientRate),2)PatientRate,ROUND(SUM(PatientDisc),2)PatientDisc,ROUND(SUM(PatientNetRate),2)PatientNetRate,round(SUM(Net),2) ShareAmt, round(SUM(DepositAmount),2) DepositAmount,0 Closing ");
            sb.Append(" FROM ( ");
            sb.Append(" SELECT ReceivedDate DateOrder, CONCAT(MONTHNAME(ReceivedDate),'-',YEAR(ReceivedDate)) `Month`, ");
            sb.Append(" '0' PatientRate,'0' PatientDisc,'0' PatientNetRate,'0' Net, IFNULL(SUM(`ReceivedAmt`),0) DepositAmount,0 Closing ");
            sb.Append(" FROM `invoicemaster_onaccount` WHERE `IsCancel`=0 AND `Panel_ID`=@PanelID AND  ");
            sb.Append(" `ReceivedDate` >= @FromReceiveDate AND `ReceivedDate` <= @ToReceiveDate GROUP BY YEAR(ReceivedDate),MONTH(ReceivedDate) ");

            sb.Append(" UNION ALL   ");

            sb.AppendFormat(" SELECT plos.date DateOrder, CONCAT(MONTHNAME(plos.{0}),'-',YEAR(plos.{1})) `Month`,  ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);

            sb.Append(" SUM(plos.Rate)PatientRate,SUM(plos.DiscountAmt) PatientDisc,SUM(plos.Amount)PatientNetRate,SUM(plos.`PCCInvoiceAmt`) Net, ");
            sb.Append(" 0 DepositAmount,0 Closing   ");
            sb.Append(" FROM `patient_labinvestigation_opd_share` plos  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` AND pm.`InvoiceTo`=@PanelID AND pm.InvoiceCreatedOn=2");
            sb.AppendFormat(" AND plos.{0} >= @FromDate AND plos.{1} <= @ToDate ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");


            sb.AppendFormat(" GROUP BY YEAR(plos.{0}),MONTH(plos.{1}) ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);

            sb.Append(" ) aa GROUP BY `Month` ");
            sb.Append(" ORDER BY DateOrder ");
           // System.IO.File.WriteAllText(@"F:\ErrorLog\LedgerReport.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@PanelID", PanelID),
                   new MySqlParameter("@FromDate", string.Concat(FromDate.ToString("yyyy-MM-dd"), " ", "00:00:00")),
                   new MySqlParameter("@ToDate", string.Concat(ToDate.ToString("yyyy-MM-dd"), " ", "23:59:59")),
                   new MySqlParameter("@FromReceiveDate", FromDate.ToString("yyyy-MM-dd")),
                   new MySqlParameter("@ToReceiveDate", ToDate.ToString("yyyy-MM-dd"))).Tables[0])
            {


                if (dt != null && dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (i > 0)
                        {
                            dt.Rows[i]["Closing"] = Util.GetDouble(dt.Rows[i - 1]["Closing"]) - Util.GetDouble(dt.Rows[i]["ShareAmt"]) + Util.GetDouble(dt.Rows[i]["DepositAmount"]);
                        }

                    }

                    dt.Columns.Remove("DateOrder");
                    dt.AcceptChanges();

                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = PanelName.Replace(",", "") + " Ledger Report Summary ";
                    HttpContext.Current.Session["Period"] = string.Format("From : {0:dd-MMM-yyyy} To : {1:dd-MMM-yyyy}", FromDate, ToDate);
                    retValue = "1";
                }
                else
                {
                    retValue = "0";
                }

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


    public static void CCLedgerReportDetail(string PanelName, int? PanelID, DateTime FromDate, DateTime ToDate, string ClientTypeID, string ClientType, int AllLedger = 0)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();


            sb.Append(" SELECT ");
            if (AllLedger == 1)
                sb.Append(" pm1.`Panel_Code` ClientCode,pm1.`Company_Name` ClientName, ");
            sb.Append("   lt.PName PatientName,DATE_FORMAT(plos.`Date`,'%d-%b-%Y %I:%i %p') BillDate,plos.BillNo,plos.`LedgerTransactionNo` VisitNo, ");
            if (AllLedger == 0)
                sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName,  ");
            sb.Append(" im.TestCode `TestCode`,im.`TypeName` TestName, (plos.`Amount`) Net,(plos.`PCCInvoiceAmt`) ShareAmt,IFNULL(plos.`InvoiceNo`,'')InvoiceNo ");
            sb.Append("  FROM `f_ledgertransaction` lt  ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd_share` plos ON plos.`LedgerTransactionID`=lt.`LedgerTransactionID`   ");
            sb.Append(" INNER JOIN  f_itemmaster im ON im.ItemID=plos.ItemID  ");
            sb.AppendFormat(" AND plos.{0} >= @FromDate AND plos.{1} <= @ToDate  ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");
            sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` AND pm.InvoiceCreatedOn=2 ");
            if (AllLedger == 0)
            {
                sb.Append("   AND pm.`InvoiceTo`=@PanelID  ");
            }
            else
            {
                sb.Append(" INNER JOIN f_panel_master pm1 ON pm1.`Panel_ID`= pm.`InvoiceTo` AND pm1.`IsInvoice`=1   ");
                sb.Append(" INNER JOIN Centre_master cm ON pm1.CentreID=cm.CentreID ");
                sb.Append(" AND cm.Type1ID=@Type1ID ");
            }
            sb.AppendFormat("  ORDER BY pm.`Company_Name`,plos.{0} ", Resources.Resource.LedgerReportDate);
            // System.IO.File.WriteAllText(@"F:\Shat\aa.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
              new MySqlParameter("@Type1ID", ClientTypeID),
              new MySqlParameter("@PanelID", PanelID),
              new MySqlParameter("@FromDate", string.Concat(FromDate.ToString("yyyy-MM-dd"), " ", "00:00:00")),
              new MySqlParameter("@ToDate", string.Concat(ToDate.ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                string ReportName = string.Empty;

                if (AllLedger == 1)
                    ReportName = string.Format("All {0} Client Ledger Report Detail", ClientType);
                else
                    ReportName = PanelName + " Ledger Report Detail ";

                if (dt != null && dt.Rows.Count > 0)
                {



                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = ReportName.Replace(",", "");
                    HttpContext.Current.Session["Period"] = string.Format("From : {0:dd-MMM-yyyy} To : {1:dd-MMM-yyyy}", FromDate, ToDate);
                    retValue = "1";
                }
                else
                {
                    retValue = "0";
                }

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


    public static void FCLedgerReport(string PanelName, int? PanelID, DateTime FromDate, DateTime ToDate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT '0001-01-01' DateOrder, 'OPENING' `Month`,'' Net,'' DepositAmount,  ");
            sb.Append(" round((ifnull(ReceivedAmt,0)-ifnull(NetAmount,0)),2) Closing FROM  ");
            sb.Append(" ( SELECT SUM(`ReceivedAmt`)ReceivedAmt FROM `invoicemaster_onaccount` WHERE `IsCancel`=0 AND `Panel_ID`=@PanelID AND  ");
            sb.Append(" `ReceivedDate` < @FromReceiveDate ) a ");
            sb.Append(" ,( SELECT SUM(plos.`PCCInvoiceAmt`)NetAmount FROM `patient_labinvestigation_opd_share` plos  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID`   AND pm.InvoiceCreatedOn=2 ");
            sb.AppendFormat(" AND plos.{0} < @FromDate ", Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");
            sb.Append(" AND pm.`InvoiceTo`=@PanelID) b ");

            sb.Append(" UNION ALL  ");


            sb.Append(" SELECT DateOrder,`Month`,round(SUM(Net),2) Net, round(SUM(DepositAmount),2) DepositAmount,0 Closing ");
            sb.Append(" FROM ( ");
            sb.Append(" SELECT ReceivedDate DateOrder, CONCAT(MONTHNAME(ReceivedDate),'-',YEAR(ReceivedDate)) `Month`, ");
            sb.Append(" '0' Net, IFNULL(SUM(`ReceivedAmt`),0) DepositAmount,0 Closing ");
            sb.Append(" FROM `invoicemaster_onaccount` WHERE `IsCancel`=0 AND `Panel_ID`=@PanelID AND  ");
            sb.Append(" `ReceivedDate` >= @FromReceiveDate AND `ReceivedDate` <= @ToReceiveDate GROUP BY YEAR(ReceivedDate),MONTH(ReceivedDate) ");

            sb.Append(" UNION ALL   ");

            sb.AppendFormat(" SELECT plos.date DateOrder, CONCAT(MONTHNAME(plos.{0}),'-',YEAR(plos.{1})) `Month`,  ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);

            sb.Append(" SUM(plos.`Amount`) Net, ");
            sb.Append(" 0 DepositAmount,0 Closing   ");
            sb.Append(" FROM  ");
            sb.Append("  `patient_labinvestigation_opd_share` plos   ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` AND pm.`InvoiceTo`=@PanelID AND pm.InvoiceCreatedOn=2 ");
            sb.AppendFormat(" AND plos.{0} >= @FromDate AND plos.{1} <= @ToDate ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");
            sb.AppendFormat(" GROUP BY YEAR(plos.{0}),MONTH(plos.{1}) ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);

            sb.Append(" ) aa GROUP BY `Month` ");
            sb.Append(" ORDER BY DateOrder ");
            //System.IO.File.WriteAllText (@"F:\Shat\aa.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@PanelID", PanelID),
                   new MySqlParameter("@FromDate", string.Concat(FromDate.ToString("yyyy-MM-dd"), " ", "00:00:00")),
                   new MySqlParameter("@ToDate", string.Concat(ToDate.ToString("yyyy-MM-dd"), " ", "23:59:59")),
                   new MySqlParameter("@FromReceiveDate", FromDate.ToString("yyyy-MM-dd")),
                   new MySqlParameter("@ToReceiveDate", ToDate.ToString("yyyy-MM-dd"))).Tables[0])
            {


                if (dt != null && dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (i > 0)
                        {
                            dt.Rows[i]["Closing"] = Util.GetDouble(dt.Rows[i - 1]["Closing"]) - Util.GetDouble(dt.Rows[i]["Net"]) + Util.GetDouble(dt.Rows[i]["DepositAmount"]);
                        }

                    }

                    dt.Columns.Remove("DateOrder");
                    dt.AcceptChanges();

                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = Util.GetString(PanelName.Replace(",", "")) + " Ledger Report Summary ";
                    HttpContext.Current.Session["Period"] = string.Format("From : {0:dd-MMM-yyyy} To : {1:dd-MMM-yyyy}", FromDate, ToDate);
                    retValue = "1";
                }
                else
                {
                    retValue = "0";
                }

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


    public static void FCLedgerReportDetail(string PanelName, int? PanelID, DateTime FromDate, DateTime ToDate, string ClientTypeID, string ClientType, int AllLedger = 0)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();


            sb.Append(" SELECT ");
            if (AllLedger == 1)
                sb.Append(" pm1.`Panel_Code` ClientCode,pm1.`Company_Name` ClientName, ");
            sb.Append("   lt.PName PatientName,DATE_FORMAT(plos.`Date`,'%d-%b-%Y %I:%i %p') BillDate,plos.BillNo,plos.`LedgerTransactionNo` VisitNo, ");
            if (AllLedger == 0)
                sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName,  ");
            sb.Append(" im.TestCode `TestCode`,im.`TypeName` TestName,(plos.`Amount`) Net,IFNULL(plos.`InvoiceNo`,'')InvoiceNo  ");
            sb.Append("  FROM `f_ledgertransaction` lt  ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd_share` plos ON plos.`LedgerTransactionID`=lt.`LedgerTransactionID`  ");
            sb.Append(" INNER JOIN  f_itemmaster im ON im.ItemID=plos.ItemID  ");
            sb.AppendFormat(" AND plos.{0} >= @FromDate AND plos.{1} <= @ToDate  ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");
            sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` AND pm.InvoiceCreatedOn=2 ");
            if (AllLedger == 0)
            {
                sb.Append("   AND pm.`InvoiceTo`=@PanelID  ");
            }
            else
            {
                sb.Append(" INNER JOIN f_panel_master pm1 ON pm1.`Panel_ID`= pm.`InvoiceTo` AND pm1.`IsInvoice`=1   ");
                sb.Append(" INNER JOIN Centre_master cm ON pm1.CentreID=cm.CentreID ");
                sb.Append(" AND cm.Type1ID=@Type1ID ");
            }
            sb.AppendFormat("  ORDER BY pm.`Company_Name`,plos.{0} ", Resources.Resource.LedgerReportDate);
            // System.IO.File.WriteAllText(@"D:\Shat\aa.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@Type1ID", ClientTypeID),
               new MySqlParameter("@PanelID", PanelID),

               new MySqlParameter("@FromDate", string.Concat(FromDate.ToString("yyyy-MM-dd"), " ", "00:00:00")),
               new MySqlParameter("@ToDate", string.Concat(ToDate.ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                string ReportName = string.Empty;

                if (AllLedger == 1)
                    ReportName = string.Format("All {0} Client Ledger Report Detail", ClientType);
                else
                    ReportName = PanelName + " Ledger Report Detail ";

                if (dt != null && dt.Rows.Count > 0)
                {



                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = ReportName.Replace(",", "");
                    HttpContext.Current.Session["Period"] = string.Format("From : {0:dd-MMM-yyyy} To : {1:dd-MMM-yyyy}", FromDate, ToDate);
                    retValue = "1";
                }
                else
                {
                    retValue = "0";
                }

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


    public static void B2BLedgerReport(string PanelName, int? PanelID, DateTime FromDate, DateTime ToDate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT '0001-01-01' DateOrder, 'OPENING' `Month`,'' Net,'' DepositAmount,  ");
            sb.Append(" round((ifnull(ReceivedAmt,0)-ifnull(NetAmount,0)),2) Closing FROM  ");
            sb.Append(" ( SELECT SUM(`ReceivedAmt`)ReceivedAmt FROM `invoicemaster_onaccount` WHERE `IsCancel`=0 AND `Panel_ID`=@PanelID AND  ");
            sb.Append(" `ReceivedDate` < @FromReceiveDate ) a ");
            sb.Append(" ,( SELECT SUM(plos.`PCCInvoiceAmt`)NetAmount FROM  `patient_labinvestigation_opd_share` plos   ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID`  AND pm.InvoiceCreatedOn=2 ");
            sb.AppendFormat(" AND plos.{0} < @FromDate ", Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");
            sb.Append(" AND pm.`InvoiceTo`=@PanelID) b ");

            sb.Append(" UNION ALL  ");


            sb.Append(" SELECT DateOrder,`Month`,round(SUM(Net),2) Net, round(SUM(DepositAmount),2) DepositAmount,0 Closing ");
            sb.Append(" FROM ( ");
            sb.Append(" SELECT ReceivedDate DateOrder, CONCAT(MONTHNAME(ReceivedDate),'-',YEAR(ReceivedDate)) `Month`, ");
            sb.Append(" '0' Net, IFNULL(SUM(`ReceivedAmt`),0) DepositAmount,0 Closing ");
            sb.Append(" FROM `invoicemaster_onaccount` WHERE `IsCancel`=0 AND `Panel_ID`=@PanelID AND  ");
            sb.Append(" `ReceivedDate` >= @FromReceiveDate AND `ReceivedDate` <= @ToReceiveDate GROUP BY YEAR(ReceivedDate),MONTH(ReceivedDate) ");

            sb.Append(" UNION ALL   ");

            sb.AppendFormat(" SELECT plos.date DateOrder, CONCAT(MONTHNAME(plos.{0}),'-',YEAR(plos.{1})) `Month`,  ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);
            sb.Append(" SUM(plos.`PCCInvoiceAmt`) Net, ");
            sb.Append(" 0 DepositAmount,0 Closing   ");
            sb.Append(" FROM  `patient_labinvestigation_opd_share` plos  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID`  ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` AND pm.`InvoiceTo`=@PanelID AND pm.InvoiceCreatedOn=2 ");
            sb.AppendFormat(" AND plos.{0} >= @FromDate AND plos.{1} <=@ToDate ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");

            sb.AppendFormat(" GROUP BY YEAR(plos.{0}),MONTH(plos.{1}) ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);

            sb.Append(" ) aa GROUP BY `Month` ");
            sb.Append(" ORDER BY DateOrder ");
          //  System.IO.File.WriteAllText(@"F:\ErrorLog\B2BLedgerReport.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@PanelID", PanelID),
               new MySqlParameter("@FromDate", string.Concat(FromDate.ToString("yyyy-MM-dd"), " ", "00:00:00")),
               new MySqlParameter("@ToDate", string.Concat(ToDate.ToString("yyyy-MM-dd"), " ", "23:59:59")),
               new MySqlParameter("@FromReceiveDate", FromDate.ToString("yyyy-MM-dd")),
               new MySqlParameter("@ToReceiveDate", ToDate.ToString("yyyy-MM-dd"))).Tables[0])
            {
                if (dt != null && dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (i > 0)
                        {
                            dt.Rows[i]["Closing"] = Util.GetDouble(dt.Rows[i - 1]["Closing"]) - Util.GetDouble(dt.Rows[i]["Net"]) + Util.GetDouble(dt.Rows[i]["DepositAmount"]);
                        }

                    }

                    dt.Columns.Remove("DateOrder");
                    dt.AcceptChanges();

                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = Util.GetString(PanelName.Replace(",", "")) + " Ledger Report Summary ";
                    HttpContext.Current.Session["Period"] = string.Format("From : {0:dd-MMM-yyyy} To : {1:dd-MMM-yyyy}", FromDate, ToDate);
                    retValue = "1";
                }
                else
                {
                    retValue = "0";
                }

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


    public static void B2BLedgerReportDetail(string PanelName, int? PanelID, DateTime FromDate, DateTime ToDate, string ClientTypeID, string ClientType, int AllLedger = 0)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();


            sb.Append(" SELECT ");
            if (AllLedger == 1)
                sb.Append(" pm1.`Panel_Code` ClientCode,pm1.`Company_Name` ClientName, ");
            sb.Append("   lt.PName PatientName,DATE_FORMAT(plos.`Date`,'%d-%b-%Y %I:%i %p') BillDate,plos.BarcodeNo,plos.BillNo,plos.`LedgerTransactionNo` VisitNo, ");
            if (AllLedger == 0)
                sb.Append("  pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName,  ");
            sb.Append(" im.TestCode `TestCode`,im.`TypeName` TestName,plos.Amount Net,plos.PCCInvoiceAmt InvoiceAmount,IFNULL(plos.`InvoiceNo`,'')InvoiceNo ");
            sb.Append("  FROM `f_ledgertransaction` lt  ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd_share` plos ON plos.`LedgerTransactionID`=lt.`LedgerTransactionID`  ");
            sb.Append(" INNER JOIN  f_itemmaster im ON im.ItemID=plos.ItemID  ");
            sb.AppendFormat(" AND plos.{0} >= @FromDate AND plos.{1} <= @ToDate  ", Resources.Resource.LedgerReportDate, Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");
            sb.Append("  INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` AND pm.InvoiceCreatedOn=2 ");
            if (AllLedger == 0)
            {
                sb.Append("   AND pm.`InvoiceTo`=@PanelID  ");
            }
            else
            {
                sb.Append(" INNER JOIN f_panel_master pm1 ON pm1.`Panel_ID`= pm.`InvoiceTo` AND pm1.`IsInvoice`=1   ");
                sb.Append(" INNER JOIN Centre_master cm ON pm1.CentreID=cm.CentreID ");
                sb.Append(" AND cm.Type1ID=@Type1ID ");
            }
            sb.AppendFormat("  ORDER BY pm.`Company_Name`,plos.{0} ", Resources.Resource.LedgerReportDate);
            // System.IO.File.WriteAllText(@"F:\Shat\aa.txt", "1");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@Type1ID", ClientTypeID),
               new MySqlParameter("@PanelID", PanelID),
               new MySqlParameter("@FromDate", string.Concat(FromDate.ToString("yyyy-MM-dd"), " ", "00:00:00")),
               new MySqlParameter("@ToDate", string.Concat(ToDate.ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                string ReportName = string.Empty;

                if (AllLedger == 1)
                    ReportName = string.Format("All {0} Client Ledger Report Detail", ClientType);
                else
                    ReportName = PanelName + " Ledger Report Detail ";

                if (dt != null && dt.Rows.Count > 0)
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = ReportName.Replace(",", "");
                    HttpContext.Current.Session["Period"] = string.Format("From : {0:dd-MMM-yyyy} To : {1:dd-MMM-yyyy}", FromDate, ToDate);
                    retValue = "1";
                }
                else
                {
                    retValue = "0";
                }

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

    [WebMethod]
    public static string BindPanelByGroup(string PanelGroupId)
    {
        HttpContext ctx = HttpContext.Current;
        string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#','PUP','#','7')Panel_ID,'PUP' Type1 FROM f_panel_master fpm ");
        sb.Append(" WHERE  fpm.IsInvoice=1  ");//and fpm.Panel_ID=fpm.InvoiceTo
        if (Util.GetString(ctx.Session["PanelType"]) == "PCC")
        {
            sb.Append(" and InvoiceTo =" + InvoicePanelID + " ");
        }
        else if (Util.GetString(ctx.Session["PanelType"]).ToUpper() == "SUBPCC")
        {
            sb.Append(" and employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
        }
        else if (UserInfo.Centre != 1)
        {
            sb.Append(" and Panel_ID in(select PanelID from centre_panel where centreID= " + UserInfo.Centre + ") ");
        }
        sb.Append(" ORDER BY fpm.Company_Name");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

        }
    }

    private void BindPanelGroup()
    {
        lstPanelGroup.DataSource = StockReports.GetDataTable("SELECT DISTINCT PanelGroupId,PanelGroup FROM f_panel_master WHERE isActive=1 AND PanelType='PUP'  ORDER BY PanelGroup");
        lstPanelGroup.DataTextField = "PanelGroup";
        lstPanelGroup.DataValueField = "PanelGroupId";
        lstPanelGroup.DataBind();

    }

}
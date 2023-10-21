using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Invoicing_ClientDepositReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            chkCondition();
            BindCentreType();
        }
    }
    private void BindCentreType()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT ID,Type1 FROM centre_type1master WHERE IsActive=1 AND Category='CC' "))
        {
            if (dt.Rows.Count > 0)
            {
                rblSearchType.DataSource = dt;
                rblSearchType.DataTextField = "Type1";
                rblSearchType.DataValueField = "ID";
                rblSearchType.DataBind();
                rblSearchType.Items.Insert(0, new ListItem("ALL", "0"));

            }
        }
    }
    private void chkCondition()
    {
        lblMsg.Text = string.Empty;
        if (UserInfo.RoleID == 1 || UserInfo.RoleID == 177 || UserInfo.RoleID == 6)
        {
            lblSearchType.Text = "1";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script1", "showAccountSearch();", true);
        }
        else
        {
            if (HttpContext.Current.Session["IsSalesTeamMember"].ToString() == "1")
            {
                lblSearchType.Text = "2";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "hideSearchCriteria1();", true);
            }
            else if (HttpContext.Current.Session["PROID"].ToString() != "0")
            {
                lblSearchType.Text = "4";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "hideSearchCriteria();", true);
            }
            else
            {
                lblSearchType.Text = "3";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "hideSearchCriteria();", true);
            }
        }

    }
    [WebMethod]
    public static string bindPanel(int BusinessZoneID, int StateID, int SearchType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            HttpContext ctx = HttpContext.Current;
            string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#','','#','') Panel_ID,");
            sb.Append(" '' Type1ID FROM  f_panel_master fpm ");
            sb.Append(" WHERE   fpm.isInvoice=1 ");
            if (Util.GetString(ctx.Session["LoginType"]) == "PCC")
            {
                sb.Append(" and InvoiceTo =" + InvoicePanelID + " ORDER BY fpm.Employee_ID desc");
            }
            else if (Util.GetString(ctx.Session["LoginType"]).ToUpper() == "SUBPCC")
            {
                sb.Append(" and employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ORDER BY fpm.Employee_ID desc");
            }
            else if (UserInfo.RoleID == 220)
            {
                sb.Append(" and Panel_ID in(select PanelID from centre_panel where centreID= " + UserInfo.Centre + ") ORDER BY fpm.Company_Name desc");
            }
            else
                sb.Append(" AND fpm.`TagProcessingLabID`=" + UserInfo.Centre + " ORDER BY fpm.Company_Name");
				//sb.Append(" ORDER BY fpm.Company_Name");

            using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

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
    public static string bindPanelold(int BusinessZoneID, int StateID, int SearchType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int condition = 0;
            StringBuilder sb = new StringBuilder();
            if (UserInfo.RoleID == 1 || UserInfo.RoleID == 177 || UserInfo.RoleID == 6)
            {
                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#',cm.Type1,'#',cm.Type1ID) Panel_ID,");
                sb.Append(" cm.Type1ID FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID");
                sb.Append(" WHERE   fpm.isInvoice=1 ");
            }
            else
            {
                if (HttpContext.Current.Session["IsSalesTeamMember"].ToString() == "1")
                {
                    string SalesTeamMembers = AllLoad_Data.getSalesChildNode(con, UserInfo.ID);
                    sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#',cm.Type1,'#',cm.Type1ID) Panel_ID,cm.Type1ID  ");
                    sb.Append(" FROM centre_master cm INNER JOIN f_panel_master fpm ON fpm.CentreID=cm.CentreID   ");
                    sb.Append(" AND fpm.SalesManager IN (" + SalesTeamMembers + ")  ");
                    sb.Append(" WHERE   fpm.isInvoice=1   ");
                }
                else if (HttpContext.Current.Session["PROID"].ToString() != "0")
                {
                    condition = 1;
                    sb.Append("SELECT DISTINCT cm.`CentreID`, CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#',cm.Type1,'#',cm.Type1ID) Panel_ID,cm.Type1ID FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID");
                    sb.Append(" INNER JOIN f_login l ON l.`CentreID`=cm.`CentreID` WHERE  fpm.isInvoice=1  AND fpm.isActive=1 AND l.EmployeeID ='" + UserInfo.ID + "' AND l.Active=1 ");
                    sb.Append("  ");
                }
                else
                {
                    condition = 1;
                    sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#',cm.Type1,'#',cm.Type1ID) Panel_ID,cm.Type1ID FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID");
                    sb.Append(" WHERE   fpm.isInvoice=1   ");
                    sb.Append("  AND ( cm.CentreID IN (SELECT CentreAccess FROM centre_access WHERE CentreID ='" + UserInfo.Centre + "' ) OR cm.CentreID ='" + UserInfo.Centre + "' ) ");
                }
            }
            if (condition == 0)
            {
                if (BusinessZoneID != 0)
                {
                    sb.Append(" AND cm.BusinessZoneID='" + BusinessZoneID + "'");
                }
                if (StateID != -1)
                {
                    sb.Append("  AND cm.StateID='" + StateID + "' ");
                }              
                if (SearchType != 0)
                    sb.Append(" AND cm.type1ID=" + SearchType + "  ");
            }
            sb.Append("    AND fpm.Panel_ID=fpm.InvoiceTo AND fpm.InvoiceCreatedOn=2 ");


            using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
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
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static Dictionary<string, string> getReportData(string PanelID, DateTime FromDate, DateTime ToDate, int Type, int AllClient, string DateType)
    {
        PanelID = String.Join(",", PanelID.Split(new char[] { ' ', ',' }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Split('#')[0]).ToList());

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM ( ");
        sb.Append(" SELECT fpm.Panel_Code ClientCode, fpm.`Company_Name` ClientName,CONCAT(ivac.S_Amount,'(',ivac.S_Notation,')')BaseAmount, ivac.PaymentMode,");
		sb.Append(" (case when ivac.CreditNote='0' then 'Deposit' when ivac.CreditNote='1' then 'Credit Note' when ivac.CreditNote='2' then 'Debit Note' when ivac.CreditNote='3' then 'Cheque Bounce' else '' end )PaymentType,");
		sb.Append(" ivac.cardNo,DATE_FORMAT(ivac.`CardDate`, '%d-%b-%Y')CardDate,ivac.S_Currency PayCurrency,  ivac.`ReceivedAmt` PaidAmount,ivac.C_factor Conversion,ivac.Bank BankName,ivac.EntryByName EntryBy,");
        sb.Append(" DATE_FORMAT(ivac.`receiveddate`,'%d-%b-%Y') DepositDate ,DATE_FORMAT(ivac.EntryDate,'%d-%b-%Y %I:%i %p') `EntryDate/ValidateDate`,");
        sb.Append(" CASE WHEN IsCancel=1 THEN 'Reject' WHEN ValidateStatus=0 THEN 'Pending' WHEN ValidateStatus=1 THEN 'Approve' END `Status`,ivac.ApprovedBy,");
        sb.Append(" DATE_FORMAT(ivac.`receivedDate`,'%d-%b-%Y')ReceivedDate,Remarks,IF(IsCancel=1,CancelReason,'')RejectReason,IsCancel,IFNULL(CreditDebitNoteType,'')CreditDebitNoteType  FROM `invoicemaster_onaccount` ivac ");
        sb.Append(" INNER JOIN `f_panel_master` fpm ON ivac.`Panel_id` = fpm.`Panel_ID` WHERE  fpm.`Panel_ID`<>'' ");
        sb.Append(" ");
        sb.Append(" ");
        if (AllClient == 0)
            sb.Append(" AND ivac.panel_id IN({0}) ");
        if (Type == 1)
            sb.Append(" AND  ivac.ValidateStatus=0  AND IsCancel=0 ");
        else if (Type == 2)
            sb.Append("  AND ivac.ValidateStatus=1  AND IsCancel=0 ");
        else if (Type == 3)
            sb.Append("  AND ivac.IsCancel=1  ");
        if (DateType == "Deposit")
            sb.Append(" AND ivac.`receivedDate`>=@FromDate AND  ivac.`receivedDate`<=@ToDate ");
        else if (DateType == "Entry")
            sb.Append(" AND ivac.`EntryDate`>=@FromDate AND  ivac.`EntryDate`<=@ToDate ");
        else
            sb.Append(" AND ivac.`EntryDate`>=@FromDate AND  ivac.`EntryDate`<=@ToDate ");

        sb.Append(" UNION ALL ");

        sb.Append("    SELECT fpm.Panel_Code ClientCode, fpm.`Company_Name` ClientName,CONCAT(ivac.S_Amount,'(',ivac.S_Notation,')')BaseAmount,");
		sb.Append(" ivac.PaymentMode, (case when ivac.CreditNote='0' then 'Deposit' when ivac.CreditNote='1' then 'Credit Note' when ivac.CreditNote='2' then 'Debit Note' when ivac.CreditNote='3' then 'Cheque Bounce' else '' end )PaymentType,");
		sb.Append(" ivac.cardNo,DATE_FORMAT(ivac.`CardDate`, '%d-%b-%Y')CardDate,ivac.S_Currency PayCurrency,  ivac.`ReceivedAmt` PaidAmount,ivac.C_factor Conversion,ivac.Bank BankName,ivac.EntryByName EntryBy, ");
        sb.Append("  DATE_FORMAT(ivac.`receiveddate`,'%d-%b-%Y') DepositDate ,DATE_FORMAT(ivac.EntryDate,'%d-%b-%Y %I:%i %p') `EntryDate/ValidateDate`,CASE WHEN IsCancel=1 THEN 'Reject' WHEN ValidateStatus=0 THEN 'Pending' WHEN ValidateStatus=1 THEN 'Approve' END `Status`,'' ApprovedBy, ");
        sb.Append("  DATE_FORMAT(ivac.`receivedDate`,'%d-%b-%Y')ReceivedDate,Remarks,if(IsCancel=1,CancelReason,'')RejectReason,IsCancel,'' CreditDebitNoteType  FROM `Invoicemaster_Payment` ivac  ");
        sb.Append("  INNER JOIN `f_panel_master` fpm ON ivac.`Panel_id` = fpm.`Panel_ID` WHERE  fpm.`Panel_ID`<>''  AND ValidateStatus=0 ");
        if (AllClient == 0)
            sb.Append(" AND ivac.panel_id IN({0}) ");
       
        else if (Type == 3)
            sb.Append("  AND ivac.IsCancel=1  ");
        sb.Append(" AND ivac.`receivedDate`>= @FromDate AND  ivac.`receivedDate`<= @ToDate ");
        sb.Append("         ");

        sb.Append(" )t ORDER BY STR_TO_DATE(t.`EntryDate/ValidateDate`, '%l:%i %p'); ");
        //System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\cdr.txt", sb.ToString());
        string Period = string.Concat("From : ", FromDate.ToString("dd-MMM-yyyy"), " To : ", ToDate.ToString("dd-MMM-yyyy"));
        Dictionary<string, string> returnData = new Dictionary<string, string>();
        returnData.Add("ReportDisplayName", Common.EncryptRijndael("ClientDeposit Report"));
        returnData.Add("PanelID#1", Common.EncryptRijndael(PanelID));
        
        returnData.Add("FromDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")));
        returnData.Add("ToDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"), " ", "23:59:59")));

        returnData.Add("Query", Common.EncryptRijndael(sb.ToString()));
        returnData.Add("Period", Common.EncryptRijndael(Period));
        returnData.Add("ReportPath", "../Common/ExportToExcelReport.aspx");
        returnData.Add("entrymonth", Common.EncryptRijndael("1"));
        return returnData;
             
    }
}
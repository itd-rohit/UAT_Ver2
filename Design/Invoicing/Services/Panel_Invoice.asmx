<%@ WebService Language="C#" Class="Panel_Invoice" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class Panel_Invoice : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    public Panel_Invoice()
    { }

    [WebMethod(EnableSession = true)]
    public string bindPanel(int BusinessZoneID, int StateID, int SearchType, string PaymentMode, string TagBusinessLab, string PanelGroup,int? IsInvoicePanel, string BillingCycle)
    {
        StringBuilder sb = new StringBuilder();
        HttpContext ctx = HttpContext.Current;
        string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
        // if (SearchType != 7)
        // {
        sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#',fpm.PanelGroup,'#',fpm.PanelGroupID)Panel_ID,fpm.PanelGroup Type1 FROM f_panel_master fpm   ");
        sb.Append(" WHERE   fpm.IsInvoice=1 AND fpm.`Payment_Mode`='Credit' ");
        //if (CentreID != "")
        //{
		if (UserInfo.Centre != 1){
            sb.Append(" and FPM.Panel_ID in(select distinct PanelId from centre_panel where CENTREID ="+ UserInfo.Centre +" OR centreID in(SELECT DISTINCT CentreId FROM centre_access WHERE centreId IN("+ UserInfo.Centre +")))");
		}
        //}/
        if (BusinessZoneID != 0)
            sb.Append("  AND fpm.BusinessZoneID='" + BusinessZoneID + "' ");

        //if (StateID != -1)
        //    sb.Append("  AND fpm.StateID='" + StateID + "' ");

        sb.Append("   AND fpm.Panel_ID=fpm.InvoiceTo   ");
        if (SearchType != 0)
        {
            sb.Append(" AND fpm.PanelGroupID='" + SearchType + "'  ");
        }
        //if (TagBusinessLab != string.Empty)
        //    sb.Append(" AND fpm.TagBusinessLabID IN (" + TagBusinessLab + ")");
		if (UserInfo.Centre != 1){
			if (Util.GetString(ctx.Session["LoginType"]) == "PCC")
			{
				sb.Append(" and fpm.InvoiceTo =" + InvoicePanelID + "");
			}
			else if (Util.GetString(ctx.Session["LoginType"]).ToUpper() == "SUBPCC")
			{
				sb.Append(" and fpm.employee_ID=" + Util.GetString(ctx.Session["ID"]) + "");
			}
		}
        sb.Append("   AND fpm.IsPermanentClose=0 ");

        if (PaymentMode != string.Empty)
            sb.Append(" AND fpm.Payment_Mode='" + PaymentMode + "' ");
        //if (IsInvoicePanel == 2)
        //    sb.Append(" AND fpm.InvoiceCreatedOn=2 ");
        //else if(IsInvoicePanel == 1)
        //    sb.Append("  AND fpm.InvoiceCreatedOn=2 AND MonthlyInvoiceType=1");
        //else if(IsInvoicePanel == 3)
        //    sb.Append("  AND fpm.InvoiceCreatedOn=2 AND MonthlyInvoiceType=2");
        //else
        //    sb.Append(" AND fpm.InvoiceCreatedOn=1 ");

       // if (HttpContext.Current.Session["CentreType"] == "B2B")
         //   sb.Append(" AND fpm.CentreID =" + HttpContext.Current.Session["Centre"] + " ");
        sb.Append(" ORDER BY fpm.Company_Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
		
	//	if (UserInfo.ID ==5856)
		//System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\pi.txt",sb.ToString());
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }
    [WebMethod(EnableSession = true)]
    public string SalesChildNode(int SearchType,int? IsInvoicePanel)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            HttpContext ctx = HttpContext.Current;
            string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
            string SalesTeamMembers = AllLoad_Data.getSalesChildNode(con, Util.GetInt(HttpContext.Current.Session["ID"].ToString()));
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#',cm.Type1,'#',cm.Type1ID) Panel_ID,cm.Type1ID,fpm.ShowBalanceAmt  ");
            sb.Append(" FROM f_panel_master fpm INNER JOIN Centre_master cm ON fpm.CentreID=cm.CentreID AND fpm.SalesManager IN (" + SalesTeamMembers + ") ");
            sb.Append("  WHERE fpm.PanelType ='Centre' AND fpm.Panel_ID=fpm.InvoiceTo  ");
            sb.Append(" AND cm.type1ID='" + SearchType + "'  ");
            if (IsInvoicePanel == 2)
                sb.Append(" AND fpm.InvoiceCreatedOn=2 ");
            else if (IsInvoicePanel == 1)
                sb.Append("  AND fpm.InvoiceCreatedOn=2 AND MonthlyInvoiceType=1");
            else if (IsInvoicePanel == 3)
                sb.Append("  AND fpm.InvoiceCreatedOn=2 AND MonthlyInvoiceType=2");
            else
                sb.Append(" AND fpm.InvoiceCreatedOn=1 ");
            if (Util.GetString(ctx.Session["LoginType"]) == "PCC")
            {
                sb.Append(" and InvoiceTo =" + InvoicePanelID + "");
            }
            else if (Util.GetString(ctx.Session["LoginType"]).ToUpper() == "SUBPCC")
            {
                sb.Append(" and employee_ID=" + Util.GetString(ctx.Session["ID"]) + "");
            }
            using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            {
                if (dt.Rows.Count > 0)
                {
                    return Util.getJson(dt);
                }
                else
                {
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

    [WebMethod]
    public string bindLedgerPanel(int BusinessZoneID, int StateID, int SearchType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            return Util.getJson(AllLoad_Data.getLedgerClient(BusinessZoneID, StateID, SearchType, con));

        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";

        }
        finally
        {
            con.Close();
            con.Dispose();

        }
    }
    [WebMethod]
    public string bindTagBusinessLab()
    {
        return Util.getJson(AllLoad_Data.getTagBusinessLab());
    }
    [WebMethod(EnableSession = true)]
    public string SalesCentreAccess(int? IsInvoicePanel)
    {
        HttpContext ctx = HttpContext.Current;
        string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#',cm.Type1,'#',cm.Type1ID) Panel_ID,cm.Type1ID,fpm.ShowBalanceAmt FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID  ");
        sb.Append(" WHERE  ");
        sb.Append(" cm.IsActive=1  AND fpm.IsInvoice=1  AND fpm.Panel_ID=fpm.InvoiceTo   AND ( cm.CentreID IN (SELECT CentreAccess FROM centre_access WHERE CentreID ='" + UserInfo.Centre + "' ) OR cm.CentreID ='" + UserInfo.Centre + "' )  ");
        if (IsInvoicePanel == 2)
            sb.Append(" AND fpm.InvoiceCreatedOn=2 ");
        else if (IsInvoicePanel == 1)
            sb.Append("  AND fpm.InvoiceCreatedOn=2 AND MonthlyInvoiceType=1");
        else if (IsInvoicePanel == 3)
            sb.Append("  AND fpm.InvoiceCreatedOn=2 AND MonthlyInvoiceType=2");
        else
            sb.Append(" AND fpm.InvoiceCreatedOn=1 ");

        if (Util.GetString(ctx.Session["LoginType"]) == "PCC")
        {
            sb.Append(" and fpm.InvoiceTo =" + InvoicePanelID + "");
        }
        else if (Util.GetString(ctx.Session["LoginType"]).ToUpper() == "SUBPCC")
        {
            sb.Append(" and fpm.employee_ID=" + Util.GetString(ctx.Session["ID"]) + "");
        }
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
            {
                return Util.getJson(dt);
            }
            else
            {
                return null;
            }
        }
    }
}






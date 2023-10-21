using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;

public partial class Design_SalesDiagnostic_ReferringLess1000 : System.Web.UI.Page
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets

    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            DataTable dt =StockReports.GetDataTable(AllLoad_Data.GetSalesManagerQuery());
            if (dt.Rows.Count > 0)
            {
                ddlpro.DataSource = dt;
                ddlpro.DataTextField = "ProName";
                ddlpro.DataValueField = "ProID";
                ddlpro.DataBind();
                ddlpro.Items.Insert(0, new ListItem("All", "0"));
            }
        }
    } 
	
	[WebMethod]
    public static string ReferringLessExcel(string FromDate, string ToDate, string pro)
    {
        string _TeamMember = "";
        if (pro != "0")
        {
            _TeamMember = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`('" + pro + "',@ChildNode);");
            _TeamMember = "'" + _TeamMember + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
        }
        StringBuilder sb = new StringBuilder();
        sb.AppendLine(" SELECT fpm.SalesManager, IFNULL((Select Centre from centre_master where CentreID=fpm.BusinessUnit),'') BusinessUnit,fpm.PanelGroup,fpm.Panel_ID ,fpm.Company_Name Client,fpm.`Mobile`,fpm.`EmailID`,fpm.`Contact_Person`,fpm.ReferenceCode `RateType`,IFNULL(MAX(DATE_FORMAT(lt.Date,'%Y-%m-%d')),'')LwD,IFNULL(ROUND(SUM(lt.netamount),2),'') Amount,IFNULL(ROUND(AVG(lt.`NetAmount`),2),'')AverageAmt FROM employee_master em ");
        sb.AppendLine(" INNER JOIN f_panel_master fpm ON fpm.SalesManagerID=em.Employee_ID  ");
		
        sb.AppendLine(" LEFT JOIN (select lt.Panel_ID,MAX(pli.Date) Date,SUM(pli.Amount) NetAmount from `f_ledgertransaction` lt inner join Patient_LabInvestigation_OPD pli on pli.LedgertransactionID=lt.LedgertransactionID AND IF(pli.isPackage=1,pli.`SubCategoryID`=15,pli.`SubCategoryID`!=15) where  ");
        sb.AppendLine("  pli.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.AppendLine(" AND pli.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' GROUP BY lt.Panel_ID HAVING SUM(pli.`Amount`)<=1000 ) lt  ");
        sb.AppendLine(" ON lt.`Panel_ID`=fpm.`Panel_ID` ");
        sb.AppendLine(" Where fpm.IsActive=1 ");
        if (pro != "0")
        {
            sb.AppendLine(" and em.Employee_ID IN (" + _TeamMember + ") ");
        }
        else
        {
            if (UserInfo.AccessPROIDs != "")
            {
                _TeamMember = "'" + UserInfo.AccessPROIDs + "'";
                _TeamMember = _TeamMember.Replace(",", "','");
                sb.AppendLine(" and em.Employee_ID IN (" + _TeamMember + ")");
            }
        }
        sb.AppendLine(" GROUP BY fpm.`Panel_ID`  ORDER BY fpm.SalesManager,fpm.Company_Name; ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
		if	(dt.Rows.Count>0)
		{
			    HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "Business Less than 1000";
                return "1";
		}
		else
		{
			return "-1";
			
		}
       // return Util.getJson(dt);
    }
	
	
	
	
    [WebMethod]
    public static string ReferringLess(string FromDate, string ToDate, string pro)
    {
        string _TeamMember = "";
        if (pro != "0")
        {
            _TeamMember = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`('" + pro + "',@ChildNode);");
            _TeamMember = "'" + _TeamMember + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
        }
        StringBuilder sb = new StringBuilder();
        sb.AppendLine(" SELECT fpm.SalesManager, IFNULL((Select Centre from centre_master where CentreID=fpm.BusinessUnit),'') BusinessUnit,fpm.PanelGroup,fpm.Panel_ID ,fpm.Company_Name Client,fpm.`Mobile`,fpm.`EmailID`,fpm.`Contact_Person`,fpm.ReferenceCode `RateType`,IFNULL(MAX(DATE_FORMAT(lt.Date,'%Y-%m-%d')),'')LwD,IFNULL(ROUND(SUM(lt.netamount),2),'') Amount,IFNULL(ROUND(AVG(lt.`NetAmount`),2),'')AverageAmt FROM employee_master em ");
        sb.AppendLine(" INNER JOIN f_panel_master fpm ON fpm.SalesManagerID=em.Employee_ID  ");
		
       sb.AppendLine(" LEFT JOIN (select lt.Panel_ID,MAX(pli.Date) Date,SUM(pli.Amount) NetAmount from `f_ledgertransaction` lt inner join Patient_LabInvestigation_OPD pli on pli.LedgertransactionID=lt.LedgertransactionID AND IF(pli.isPackage=1,pli.`SubCategoryID`=15,pli.`SubCategoryID`!=15) where  ");
        sb.AppendLine("  pli.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.AppendLine(" AND pli.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' GROUP BY lt.Panel_ID HAVING SUM(pli.`Amount`)<=1000 ) lt  ");
        sb.AppendLine(" ON lt.`Panel_ID`=fpm.`Panel_ID` ");
        sb.AppendLine(" Where fpm.IsActive=1 ");
        if (pro != "0")
        {
            sb.AppendLine(" and em.Employee_ID IN (" + _TeamMember + ") ");
        }
        else
        {
            if (UserInfo.AccessPROIDs != "")
            {
                _TeamMember = "'" + UserInfo.AccessPROIDs + "'";
                _TeamMember = _TeamMember.Replace(",", "','");
                sb.AppendLine(" and em.Employee_ID IN (" + _TeamMember + ")");
            }
        }
        sb.AppendLine(" GROUP BY fpm.`Panel_ID`  ORDER BY fpm.SalesManager,fpm.Company_Name; ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Util.getJson(dt);
    }
    public static string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue));
            }
            sb.Append(sb2.ToString());
            sb.Append("}");
        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();
    }
}
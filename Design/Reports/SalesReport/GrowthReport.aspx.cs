using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web; 
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
public partial class Design_SalesDiagnostic_GrowthReport : System.Web.UI.Page
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
            PtxtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            PtxtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            DataTable dt = StockReports.GetDataTable(AllLoad_Data.GetSalesManagerQuery());
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
    public static string GrowthReport(string FromDate, string ToDate, string pro, string PFromDate,string PToDate, string type)
    {
        string _TeamMember = "";
        if (pro != "0")
        {
            _TeamMember = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`('" + pro + "',@ChildNode);");
            _TeamMember = "'" + _TeamMember + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
        }
        StringBuilder sb = new StringBuilder();

        sb.AppendLine(" SELECT PROName,PROID,CurrentYear,LastYear,Curr_Sale,Last_Sale,TotalSale,diff,ROUND(SalePer1,2)SalePer1,round(ifnull(((Curr_Sale-Last_Sale) / Last_Sale *100),''),2)SalePer FROM (  ");
        sb.AppendLine(" SELECT PROName,PROID,CurrentYear,LastYear,SUM(ROUND(Curr_Sale,2)) AS Curr_Sale,SUM(ROUND(Last_Sale,2)) AS Last_Sale,SUM(ROUND(Curr_Sale,2))+SUM(ROUND(Last_Sale,2)) TotalSale, ");
        sb.AppendLine(" SUM(ROUND(Curr_Sale,2))-SUM(ROUND(Last_Sale,2)) diff,IFNULL((100 * SUM(Curr_Sale)) / SUM(Last_Sale) ,'0') SalePer1  FROM (  ");
        sb.AppendLine(" SELECT em.Name `PROName`,em.Employee_ID PROID,DATE_FORMAT(lt.DATE,'%y')'CurrentYear', ");
        sb.AppendLine(" ''LastYear, SUM(pli.Amount)Curr_Sale,'0'Last_Sale FROM f_ledgertransaction  lt  ");
		
		sb.AppendLine(" inner join Patient_LabInvestigation_OPD pli on pli.LedgertransactionID=lt.LedgertransactionID AND IF(pli.isPackage=1,pli.`SubCategoryID`=15,pli.`SubCategoryID`!=15) ");
		
        sb.AppendLine(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID   ");
        sb.AppendLine(" INNER JOIN employee_master em ON em.Employee_ID = fpm.SalesManagerID   ");
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
        sb.AppendLine(" WHERE  pli.DATE>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND pli.DATE<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' GROUP BY em.Employee_ID  ");

        sb.AppendLine(" UNION ALL ");
        sb.AppendLine(" SELECT em.Name `PROName`,em.Employee_ID PROID,''CurrentYear, ");
        sb.AppendLine(" DATE_FORMAT(lt.DATE,'%y') LastYear,'0'Curr_Sale,SUM(pli.Amount)Last_Sale FROM `f_ledgertransaction` lt  ");
sb.AppendLine(" inner join Patient_LabInvestigation_OPD pli on pli.LedgertransactionID=lt.LedgertransactionID AND IF(pli.isPackage=1,pli.`SubCategoryID`=15,pli.`SubCategoryID`!=15) ");      
	  sb.AppendLine(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID   ");
        sb.AppendLine(" INNER JOIN employee_master em ON em.Employee_ID = fpm.SalesManagerID   ");
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
        //sb.AppendLine(" WHERE lt.IsCancel=0 and lt.DATE>=Concat(ADDDATE('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "',INTERVAL " + compare + " MONTH),' 00:00:00') AND lt.DATE<=Concat(ADDDATE('" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "',INTERVAL " + compare + " MONTH),' 23:59:59')    GROUP BY YEAR(DATE),em.Employee_ID  ");
        sb.AppendLine(" WHERE  pli.DATE>='" + Util.GetDateTime(PFromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND pli.DATE<='" + Util.GetDateTime(PToDate).ToString("yyyy-MM-dd") + " 23:59:59' GROUP BY em.Employee_ID  ");
        sb.AppendLine(" )t GROUP BY t.PROID  )tt GROUP BY tt.PROID order by PROName");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr["TotalSale"] = dt.Compute("SUM(Curr_Sale)+SUM(Last_Sale)", string.Empty);
            dr["Curr_Sale"] = dt.Compute("SUM(Curr_Sale)", string.Empty);
            dr["Last_Sale"] = dt.Compute("SUM(Last_Sale)", string.Empty);
            dr["diff"] = dt.Compute("SUM(Curr_Sale)-SUM(Last_Sale)", string.Empty);
            dr["SalePer"] = dt.Compute(" ((SUM(Curr_Sale)-SUM(Last_Sale)) / SUM(Last_Sale) *100)  ", string.Empty); // round(ifnull(((Curr_Sale-Last_Sale) / Last_Sale *100),''),2)
            dr["PROName"] = "Total ::";
            dt.Rows.Add(dr);
        }
        return Util.getJson(dt);
    }
	
	
	[WebMethod]
    public static string GrowthReportExcel(string FromDate, string ToDate, string pro, string PFromDate,string PToDate, string type)
    {
        string _TeamMember = "";
        if (pro != "0")
        {
            _TeamMember = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`('" + pro + "',@ChildNode);");
            _TeamMember = "'" + _TeamMember + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
        }
        StringBuilder sb = new StringBuilder();

        sb.AppendLine(" SELECT PROName,PROID,CurrentYear,LastYear,Curr_Sale,Last_Sale,TotalSale,diff,ROUND(SalePer1,2)SalePer1,round(ifnull(((Curr_Sale-Last_Sale) / Last_Sale *100),''),2)SalePer FROM (  ");
        sb.AppendLine(" SELECT PROName,PROID,CurrentYear,LastYear,SUM(ROUND(Curr_Sale,2)) AS Curr_Sale,SUM(ROUND(Last_Sale,2)) AS Last_Sale,SUM(ROUND(Curr_Sale,2))+SUM(ROUND(Last_Sale,2)) TotalSale, ");
        sb.AppendLine(" SUM(ROUND(Curr_Sale,2))-SUM(ROUND(Last_Sale,2)) diff,IFNULL((100 * SUM(Curr_Sale)) / SUM(Last_Sale) ,'0') SalePer1  FROM (  ");
        sb.AppendLine(" SELECT em.Name `PROName`,em.Employee_ID PROID,DATE_FORMAT(lt.DATE,'%y')'CurrentYear', ");
        sb.AppendLine(" ''LastYear, SUM(pli.Amount)Curr_Sale,'0'Last_Sale FROM f_ledgertransaction  lt  ");
		
		sb.AppendLine(" inner join Patient_LabInvestigation_OPD pli on pli.LedgertransactionID=lt.LedgertransactionID AND IF(pli.isPackage=1,pli.`SubCategoryID`=15,pli.`SubCategoryID`!=15) ");
		
        sb.AppendLine(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID   ");
        sb.AppendLine(" INNER JOIN employee_master em ON em.Employee_ID = fpm.SalesManagerID   ");
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
        sb.AppendLine(" WHERE  pli.DATE>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND pli.DATE<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' GROUP BY em.Employee_ID  ");

        sb.AppendLine(" UNION ALL ");
        sb.AppendLine(" SELECT em.Name `PROName`,em.Employee_ID PROID,''CurrentYear, ");
        sb.AppendLine(" DATE_FORMAT(lt.DATE,'%y') LastYear,'0'Curr_Sale,SUM(pli.Amount)Last_Sale FROM `f_ledgertransaction` lt  ");
        sb.AppendLine(" inner join Patient_LabInvestigation_OPD pli on pli.LedgertransactionID=lt.LedgertransactionID AND IF(pli.isPackage=1,pli.`SubCategoryID`=15,pli.`SubCategoryID`!=15) ");      
	    sb.AppendLine(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID   ");
        sb.AppendLine(" INNER JOIN employee_master em ON em.Employee_ID = fpm.SalesManagerID   ");
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
        //sb.AppendLine(" WHERE lt.IsCancel=0 and lt.DATE>=Concat(ADDDATE('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "',INTERVAL " + compare + " MONTH),' 00:00:00') AND lt.DATE<=Concat(ADDDATE('" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "',INTERVAL " + compare + " MONTH),' 23:59:59')    GROUP BY YEAR(DATE),em.Employee_ID  ");
        sb.AppendLine(" WHERE  pli.DATE>='" + Util.GetDateTime(PFromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND pli.DATE<='" + Util.GetDateTime(PToDate).ToString("yyyy-MM-dd") + " 23:59:59' GROUP BY em.Employee_ID  ");
        sb.AppendLine(" )t GROUP BY t.PROID  )tt GROUP BY tt.PROID order by PROName");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr["TotalSale"] = dt.Compute("SUM(Curr_Sale)+SUM(Last_Sale)", string.Empty);
            dr["Curr_Sale"] = dt.Compute("SUM(Curr_Sale)", string.Empty);
            dr["Last_Sale"] = dt.Compute("SUM(Last_Sale)", string.Empty);
            dr["diff"] = dt.Compute("SUM(Curr_Sale)-SUM(Last_Sale)", string.Empty);
            dr["SalePer"] = dt.Compute(" ((SUM(Curr_Sale)-SUM(Last_Sale)) / SUM(Last_Sale) *100)  ", string.Empty); // round(ifnull(((Curr_Sale-Last_Sale) / Last_Sale *100),''),2)
            dr["PROName"] = "Total ::";
            dt.Rows.Add(dr); 
			HttpContext.Current.Session["dtExport2Excel"] = dt;
             HttpContext.Current.Session["ReportName"] = "GrowthReport";
             return "1";
			
        }
		else
		{
			
			return "-1";
		}
    }
	

}
using System;
using System.Collections.Generic;
using System.Data;
//using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Sales_SalesDepartmentWise : System.Web.UI.Page
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
            DataTable dt = StockReports.GetDataTable(AllLoad_Data.GetSalesManagerQuery());
            if (dt.Rows.Count > 0)
            {
                ddlpro.DataSource = dt;
                ddlpro.DataTextField = "ProName";
                ddlpro.DataValueField = "ProID";
                ddlpro.DataBind();
                ddlpro.Items.Insert(0, new ListItem("All", "0"));
            }
            DataTable dtDept = AllLoad_Data.getDepartment();
            if (dtDept.Rows.Count > 0)
            {

                ddlDept.DataSource = dtDept;
                ddlDept.DataTextField = "NAME";
                ddlDept.DataValueField = "SubCategoryID";
                ddlDept.DataBind();
                ddlDept.Items.Insert(0, new ListItem("All", "0"));
            }
        }
    } 
	
	[WebMethod]
    public static string DepartmentWiseSalesExcel(string FromDate, string ToDate, string pro,string Department)
    {
        string _TeamMember = "";
        if (pro != "0")
        {
            _TeamMember = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`('" + pro + "',@ChildNode);");
            _TeamMember = "'" + _TeamMember + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
        }
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        sb.AppendLine("  SELECT concat(DATE_FORMAT(pli.DATE,'%b%y'),'_Sale')DATE,concat(DATE_FORMAT(pli.DATE,'%b%y'),'_TC')DATE1,DATE_FORMAT(pli.DATE, '%m') MONTH,date_format(pli.Date,'%y-%m') MySQLDate, ");
        sb.AppendLine(" em.Name `SalesManager`,sgm.`Name` Department, COUNT(1) PatientCount, ");
        sb.AppendLine(" ROUND(SUM(pli.Amount),2)NetAmount ");
        sb.AppendLine(" FROM f_ledgertransaction lt ");
         sb.AppendLine(" inner join Patient_LabInvestigation_OPD pli on pli.LedgertransactionID=lt.LedgertransactionID AND IF(pli.isPackage=1,pli.`SubCategoryID`=15,pli.`SubCategoryID`!=15) ");      
        sb.AppendLine("  AND  pli.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.AppendLine(" AND  pli.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.AppendLine("  INNER JOIN f_panel_master pnl ON pnl.Panel_ID=lt.Panel_ID ");
        sb.AppendLine(" INNER JOIN f_subcategorymaster sgm ON sgm.`SubCategoryID`=pli.`SubCategoryID` ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=pnl.`SalesManagerID`");
        if (Department != "0")
        {
            sb.AppendLine(" and sgm.`SubCategoryID`='" + Department + "' ");
        }
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

        sb.AppendLine("  GROUP BY em.Employee_ID, DATE_FORMAT(pli.DATE,'%M-%Y'),sgm.`SubCategoryID` ");
        sb.AppendLine(" ORDER BY em.`Name`,DATE_FORMAT(pli.DATE, '%m%y'),sgm.`Name` ");
      

        DataTable dtBussiness = StockReports.GetDataTable(sb.ToString());
        if (dtBussiness.Rows.Count > 0)
        {
            dt = changedatatableManagerWise(dtBussiness);
        }
        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            for (int i = 2; i < dt.Columns.Count; i++)
            {
                dr[dt.Columns[i].ColumnName] = dt.Compute("sum([" + dt.Columns[i].ColumnName + "])", "");
            }
            dr["Department"] = "Grand Total ::";
            dt.Rows.Add(dr);
                HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Sales Executive vs Dept";
            return "1";
        
		}
		else
		{
			
			return "-1";
		}
    }
	
	
	
	
	

    [WebMethod]
    public static string DepartmentWiseSales(string FromDate, string ToDate, string pro,string Department)
    {
        string _TeamMember = "";
        if (pro != "0")
        {
            _TeamMember = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`('" + pro + "',@ChildNode);");
            _TeamMember = "'" + _TeamMember + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
        }
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        sb.AppendLine("  SELECT concat(DATE_FORMAT(pli.DATE,'%b%y'),'_Sale')DATE,concat(DATE_FORMAT(pli.DATE,'%b%y'),'_TC')DATE1,DATE_FORMAT(pli.DATE, '%m') MONTH,date_format(pli.Date,'%y-%m') MySQLDate, ");
        sb.AppendLine(" em.Name `SalesManager`,sgm.`Name` Department, COUNT(1) PatientCount, ");
        sb.AppendLine(" ROUND(SUM(pli.Amount),2)NetAmount ");
        sb.AppendLine(" FROM f_ledgertransaction lt ");
         sb.AppendLine(" inner join Patient_LabInvestigation_OPD pli on pli.LedgertransactionID=lt.LedgertransactionID AND IF(pli.isPackage=1,pli.`SubCategoryID`=15,pli.`SubCategoryID`!=15) ");      
        sb.AppendLine("  AND  pli.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.AppendLine(" AND  pli.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.AppendLine("  INNER JOIN f_panel_master pnl ON pnl.Panel_ID=lt.Panel_ID ");
        sb.AppendLine(" INNER JOIN f_subcategorymaster sgm ON sgm.`SubCategoryID`=pli.`SubCategoryID` ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=pnl.`SalesManagerID`");
        if (Department != "0")
        {
            sb.AppendLine(" and sgm.`SubCategoryID`='" + Department + "' ");
        }
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

        sb.AppendLine("  GROUP BY em.Employee_ID, DATE_FORMAT(pli.DATE,'%M-%Y'),sgm.`SubCategoryID` ");
        sb.AppendLine(" ORDER BY em.`Name`,DATE_FORMAT(pli.DATE, '%m%y'),sgm.`Name` ");
      

        DataTable dtBussiness = StockReports.GetDataTable(sb.ToString());
        if (dtBussiness.Rows.Count > 0)
        {
            dt = changedatatableManagerWise(dtBussiness);
        }
        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            for (int i = 2; i < dt.Columns.Count; i++)
            {
                dr[dt.Columns[i].ColumnName] = dt.Compute("sum([" + dt.Columns[i].ColumnName + "])", "");
            }
            dr["Department"] = "Grand Total ::";
            dt.Rows.Add(dr);
        }
        //return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        string rtrn = Util.getJson(dt);
            return rtrn;
    }

    public static DataTable changedatatableManagerWise(DataTable dt)
    {
        try
        {
            DataTable dtc = new DataTable();


            DataView dv = dt.DefaultView.ToTable(true, "SalesManager", "Department").DefaultView;
            dv.Sort = "SalesManager,Department asc";
            DataTable dept = dv.ToTable();



            DataView dvmonth = dt.DefaultView.ToTable(true, "DATE", "DATE1", "MySQLDate").DefaultView;
            dvmonth.Sort = "MySQLDate asc";
            DataTable pro = dvmonth.ToTable();



            dtc.Columns.Add("SalesManager");
            dtc.Columns.Add("Department");
            //dtc.Columns.Add("PatientCount");
            
            foreach (DataRow dw in pro.Rows)
            {
                dtc.Columns.Add(dw["DATE"].ToString());
                dtc.Columns[dw["DATE"].ToString()].DataType = typeof(float);
                dtc.Columns.Add(dw["DATE1"].ToString());
                dtc.Columns[dw["DATE1"].ToString()].DataType = typeof(float);
            }

            string SM = "";
            foreach (DataRow dwrr in dept.Rows)
            {
                DataRow dwr = dtc.NewRow();

                dwr["SalesManager"] = dwrr["SalesManager"].ToString();

                dwr["Department"] = dwrr["Department"].ToString();
                SM = dwrr["SalesManager"].ToString();

                DataRow[] dwme = dt.Select("SalesManager='" + dwrr["SalesManager"].ToString() + "' and Department='" + dwrr["Department"].ToString() + "'");

                foreach (DataRow dwm in dwme)
                {
                    dwr[dwm["DATE"].ToString()] = dwm["NetAmount"].ToString();
                    dwr[dwm["DATE1"].ToString()] = dwm["PatientCount"].ToString();
                }
                dtc.Rows.Add(dwr);

            }

            return dtc;

        }
        catch (Exception ex)
        {
            return dt;
        }

    }
}
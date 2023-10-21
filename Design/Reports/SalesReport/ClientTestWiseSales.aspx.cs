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

public partial class Design_Sales_ClientTestWiseSales : System.Web.UI.Page
{
    public string _SessionID = "";
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            _SessionID = Util.GetString(UserInfo.ID);
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
            DataTable dtDept = StockReports.GetDataTable("select ItemID,Typename from f_itemmaster where IsActive=1 order by Typename ");
            if (dtDept.Rows.Count > 0)
            {
                ddlInv.DataSource = dtDept;
                ddlInv.DataTextField = "Typename";
                ddlInv.DataValueField = "ItemID";
                ddlInv.DataBind();
                ddlInv.Items.Insert(0, new ListItem("All", "0"));
            }
        }
    } 
	
	
	
	
	[WebMethod]
    public static string ClientTestWiseSalesExcel(string FromDate, string ToDate, string pro, string ItemID,string reporttype)
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
        sb.AppendLine(" em.Name `SalesManager`,pnl.Company_Name PanelName,pli.ItemName TestName,COUNT(1) TestCount, ");
        sb.AppendLine(" ROUND(SUM(pli.Amount),2)NetAmount ");
        sb.AppendLine(" FROM f_ledgertransaction lt ");
        sb.AppendLine(" inner join Patient_LabInvestigation_OPD pli on pli.LedgertransactionID=lt.LedgertransactionID AND IF(pli.isPackage=1,pli.`SubCategoryID`=15,pli.`SubCategoryID`!=15) ");      
        sb.AppendLine("  AND  pli.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.AppendLine(" AND  pli.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.AppendLine("  INNER JOIN f_panel_master pnl ON pnl.Panel_ID=lt.Panel_ID ");
        sb.AppendLine(" INNER JOIN `f_itemmaster` im ON pli.`ItemID`=im.`ItemID`  ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=pnl.`SalesManagerID`");
        if (ItemID != "0")
        {
            sb.AppendLine(" and im.ItemID='" + ItemID + "' ");
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

        sb.AppendLine(" group by  em.Employee_ID,pnl.Panel_ID,pli.`ItemID`,DATE_FORMAT(pli.DATE, '%m%y') ");
        sb.AppendLine(" ORDER BY em.`Name`,DATE_FORMAT(pli.DATE, '%m%y'),pnl.Company_Name ");
       

        DataTable dtBussiness = StockReports.GetDataTable(sb.ToString());
        if (dtBussiness.Rows.Count > 0)
        {
            dt = changedatatableManagerWise(dtBussiness);
        }
        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            for (int i = 3; i < dt.Columns.Count; i++)
            {
                dr[dt.Columns[i].ColumnName] = dt.Compute("sum([" + dt.Columns[i].ColumnName + "])", "");
            }
            dr["PanelName"] = "Grand Total ::";
            dt.Rows.Add(dr);
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Sales Executive vs Client";
            return "1";
        
		}
		else
		{
			
			return "-1";
		}
       
        //return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
	   
    }

    [WebMethod]
    public static string ClientTestWiseSales(string FromDate, string ToDate, string pro, string ItemID,string reporttype)
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
        sb.AppendLine(" em.Name `SalesManager`,pnl.Company_Name PanelName,pli.ItemName TestName,COUNT(1) TestCount, ");
        sb.AppendLine(" ROUND(SUM(pli.Amount),2)NetAmount ");
        sb.AppendLine(" FROM f_ledgertransaction lt ");
        sb.AppendLine(" inner join Patient_LabInvestigation_OPD pli on pli.LedgertransactionID=lt.LedgertransactionID AND IF(pli.isPackage=1,pli.`SubCategoryID`=15,pli.`SubCategoryID`!=15) ");      
        sb.AppendLine("  AND  pli.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.AppendLine(" AND  pli.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.AppendLine("  INNER JOIN f_panel_master pnl ON pnl.Panel_ID=lt.Panel_ID ");
        sb.AppendLine(" INNER JOIN `f_itemmaster` im ON pli.`ItemID`=im.`ItemID`  ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=pnl.`SalesManagerID`");
        if (ItemID != "0")
        {
            sb.AppendLine(" and im.ItemID='" + ItemID + "' ");
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

        sb.AppendLine(" group by  em.Employee_ID,pnl.Panel_ID,pli.`ItemID`,DATE_FORMAT(pli.DATE, '%m%y') ");
        sb.AppendLine(" ORDER BY em.`Name`,DATE_FORMAT(pli.DATE, '%m%y'),pnl.Company_Name ");
       

        DataTable dtBussiness = StockReports.GetDataTable(sb.ToString());
        if (dtBussiness.Rows.Count > 0)
        {
            dt = changedatatableManagerWise(dtBussiness);
        }
        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            for (int i = 3; i < dt.Columns.Count; i++)
            {
                dr[dt.Columns[i].ColumnName] = dt.Compute("sum([" + dt.Columns[i].ColumnName + "])", "");
            }
            dr["PanelName"] = "Grand Total ::";
            dt.Rows.Add(dr);
        }
        if (reporttype != "Excel")
        {
            if (dt.Rows.Count > 0)
            {
                string rtrn = Util.getJson(dt);
                return rtrn;
            }
            else
            {
                return "";
            }
        }
        else
        {
            if (dt.Rows.Count > 0)
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                HttpContext.Current.Session["ReportName"] = "Test Wise Sales Excutive Report";
                HttpContext.Current.Session["Period"] = "Period From : " + Util.GetDateTime(FromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ToDate).ToString("dd-MMM-yyyy");
                HttpContext.Current.Session["ds"] = ds;
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                return "Excel";
            }
            else
            {
                return "";
            }
        }
        //return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
	   
    }

    public static DataTable changedatatableManagerWise(DataTable dt)
    {
        try
        {
            DataTable dtc = new DataTable();


            DataView dv = dt.DefaultView.ToTable(true, "SalesManager", "PanelName", "TestName").DefaultView;
            dv.Sort = "SalesManager,PanelName,TestName asc";
            DataTable dept = dv.ToTable();



            DataView dvmonth = dt.DefaultView.ToTable(true, "DATE", "DATE1", "MySQLDate").DefaultView;
            dvmonth.Sort = "MySQLDate asc";
            DataTable pro = dvmonth.ToTable();



            dtc.Columns.Add("SalesManager");
            dtc.Columns.Add("PanelName");
            dtc.Columns.Add("TestName");
            
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

                dwr["PanelName"] = dwrr["PanelName"].ToString();
                dwr["TestName"] = dwrr["TestName"].ToString();
                SM = dwrr["SalesManager"].ToString();

                DataRow[] dwme = dt.Select("SalesManager='" + dwrr["SalesManager"].ToString() + "' and PanelName='" + dwrr["PanelName"].ToString() + "' and TestName='" + dwrr["TestName"].ToString() + "'");

                foreach (DataRow dwm in dwme)
                {
                    dwr[dwm["DATE"].ToString()] = dwm["NetAmount"].ToString();
                    dwr[dwm["DATE1"].ToString()] = dwm["TestCount"].ToString();
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
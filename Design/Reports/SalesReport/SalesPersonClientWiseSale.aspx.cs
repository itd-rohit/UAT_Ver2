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

public partial class Design_OPD_SalesPersonClientWiseSale : System.Web.UI.Page
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
        }
    } 
	
	
	[WebMethod]
    public static string SalesPersonClientWiseSaleExcel(string FromDate, string ToDate, string pro)
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
        sb.AppendLine("  SELECT concat(DATE_FORMAT(pli.DATE,'%b%y'),'_Sale')DATE,concat(DATE_FORMAT(pli.DATE,'%b%y'),'_PC')DATE1,DATE_FORMAT(pli.DATE, '%m') MONTH,date_format(pli.Date,'%y-%m') MySQLDate, ");
        sb.AppendLine(" em.Name `SalesManager`,pnl.Company_Name PanelName, COUNT(DISTINCT pli.LedgerTransactionNo) PatientCount, ");
        sb.AppendLine(" ROUND(SUM(pli.Amount),2)NetAmount ");
        sb.AppendLine(" FROM f_ledgertransaction lt ");
		
			sb.AppendLine(" inner join Patient_LabInvestigation_OPD pli on pli.LedgertransactionID=lt.LedgertransactionID AND IF(pli.isPackage=1,pli.`SubCategoryID`=15,pli.`SubCategoryID`!=15) ");      
		
        sb.AppendLine("  INNER JOIN f_panel_master pnl ON pnl.Panel_ID=lt.Panel_ID ");
        sb.AppendLine("  AND  pli.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.AppendLine(" AND  pli.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");

        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=pnl.`SalesManagerID`");
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

        sb.AppendLine("  GROUP BY  DATE_FORMAT(pli.DATE,'%M-%Y'),pnl.Panel_ID ");
        sb.AppendLine(" ORDER BY em.`Name`,DATE_FORMAT(pli.DATE, '%m%y'),pnl.`Company_Name` ");
       

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

       // return Util.getJson(dt);
    }
	
	
	
    [WebMethod]
    public static string SalesPersonClientWiseSale(string FromDate, string ToDate, string pro)
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
        sb.AppendLine("  SELECT concat(DATE_FORMAT(pli.DATE,'%b%y'),'_Sale')DATE,concat(DATE_FORMAT(pli.DATE,'%b%y'),'_PC')DATE1,DATE_FORMAT(pli.DATE, '%m') MONTH,date_format(pli.Date,'%y-%m') MySQLDate, ");
        sb.AppendLine(" em.Name `SalesManager`,pnl.Company_Name PanelName, COUNT(DISTINCT pli.LedgerTransactionNo) PatientCount, ");
        sb.AppendLine(" ROUND(SUM(pli.Amount),2)NetAmount ");
        sb.AppendLine(" FROM f_ledgertransaction lt ");
		
			sb.AppendLine(" inner join Patient_LabInvestigation_OPD pli on pli.LedgertransactionID=lt.LedgertransactionID AND IF(pli.isPackage=1,pli.`SubCategoryID`=15,pli.`SubCategoryID`!=15) ");      
		
        sb.AppendLine("  INNER JOIN f_panel_master pnl ON pnl.Panel_ID=lt.Panel_ID ");
        sb.AppendLine("  AND  pli.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.AppendLine(" AND  pli.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");

        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=pnl.`SalesManagerID`");
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

        sb.AppendLine("  GROUP BY  DATE_FORMAT(pli.DATE,'%M-%Y'),pnl.Panel_ID ");
        sb.AppendLine(" ORDER BY em.`Name`,DATE_FORMAT(pli.DATE, '%m%y'),pnl.`Company_Name` ");
       

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
            dr["PanelName"] = "Grand Total ::";
            dt.Rows.Add(dr);
        }
        //return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

        return Util.getJson(dt);
    }

    public static DataTable changedatatableManagerWise(DataTable dt)
    {
        try
        {
            DataTable dtc = new DataTable();


            DataView dv = dt.DefaultView.ToTable(true, "SalesManager", "PanelName").DefaultView;
            dv.Sort = "SalesManager,PanelName asc";
            DataTable dept = dv.ToTable();



            DataView dvmonth = dt.DefaultView.ToTable(true, "DATE", "DATE1", "MySQLDate").DefaultView;
            dvmonth.Sort = "MySQLDate asc";
            DataTable pro = dvmonth.ToTable();



            dtc.Columns.Add("SalesManager");
            dtc.Columns.Add("PanelName");
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

                dwr["PanelName"] = dwrr["PanelName"].ToString();
                SM = dwrr["SalesManager"].ToString();

                DataRow[] dwme = dt.Select("SalesManager='" + dwrr["SalesManager"].ToString() + "' and PanelName='" + dwrr["PanelName"].ToString() + "'");

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
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));


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
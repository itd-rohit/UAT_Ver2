using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;

public partial class Design_Sales_AgeingReport_Cash : System.Web.UI.Page
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
    public static string Search(string pro)
    {
        StringBuilder sb = new StringBuilder();
        string _TeamMember = "";
        if (pro != "0")
        {
            _TeamMember = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`('" + pro + "',@ChildNode);");
            _TeamMember = "'" + _TeamMember + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
        }
        sb.AppendLine("  SELECT em.Employee_ID PROID,em.Name ProName,SUM(lt.NetAmount-lt.Adjustment)TotalOutStanding,SUM(lt.Adjustment) TotalReceived,   ");
        sb.AppendLine("  SUM(IF(lt.Date>ADDDATE(NOW(),-30),(lt.NetAmount-lt.Adjustment),0)) AS 'Days30', 	 ");
        sb.AppendLine("  SUM(IF(lt.Date<ADDDATE(NOW(),-30) AND lt.Date>=ADDDATE(NOW(),-180),(lt.NetAmount-lt.Adjustment),0)) AS 'Less180',   ");
        sb.AppendLine("  SUM(IF(lt.Date<ADDDATE(NOW(),-180),(lt.NetAmount-lt.Adjustment),0)) AS 'More180'     ");
        sb.AppendLine("  FROM f_ledgertransaction lt 	 ");
        sb.AppendLine("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID  ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=fpm.SalesManagerID    ");
        if (pro != "0")
        {
            sb.AppendLine(" and em.Employee_ID IN (" + _TeamMember + ") ");
        }
        else
        {
            if (UserInfo.AccessPROIDs != "")
            {
                sb.AppendLine(" and em.Employee_ID IN (" + UserInfo.AccessPROIDs + ")");
            }
        }
     //   sb.AppendLine("  WHERE lt.IsCancel=0   ");
        sb.AppendLine("  GROUP BY em.Employee_ID ORDER BY ProName;   ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr["TotalOutStanding"] = dt.Compute("SUM(TotalOutStanding)", string.Empty);
            dr["TotalReceived"] = dt.Compute("SUM(TotalReceived)", string.Empty);
            dr["Days30"] = dt.Compute("SUM(Days30)", string.Empty);
            dr["Less180"] = dt.Compute("SUM(Less180)", string.Empty);
            dr["More180"] = dt.Compute("SUM(More180)", string.Empty);
            //dr["Total"] = dt.Compute("SUM(Total)", string.Empty);
            dr["ProName"] = "Total ::";
            dt.Rows.Add(dr);
        }
        return Util.getJson(dt);
    }
	
	[WebMethod]
    public static string SearchExcel(string pro)
    {
        StringBuilder sb = new StringBuilder();
        string _TeamMember = "";
        if (pro != "0")
        {
            _TeamMember = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`('" + pro + "',@ChildNode);");
            _TeamMember = "'" + _TeamMember + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
        }
        sb.AppendLine("  SELECT em.Employee_ID PROID,em.Name ProName,SUM(lt.NetAmount-lt.Adjustment)TotalOutStanding,SUM(lt.Adjustment) TotalReceived,   ");
        sb.AppendLine("  SUM(IF(lt.Date>ADDDATE(NOW(),-30),(lt.NetAmount-lt.Adjustment),0)) AS 'Days30', 	 ");
        sb.AppendLine("  SUM(IF(lt.Date<ADDDATE(NOW(),-30) AND lt.Date>=ADDDATE(NOW(),-180),(lt.NetAmount-lt.Adjustment),0)) AS 'Less180',   ");
        sb.AppendLine("  SUM(IF(lt.Date<ADDDATE(NOW(),-180),(lt.NetAmount-lt.Adjustment),0)) AS 'More180'     ");
        sb.AppendLine("  FROM f_ledgertransaction lt 	 ");
        sb.AppendLine("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID  ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=fpm.SalesManagerID    ");
        if (pro != "0")
        {
            sb.AppendLine(" and em.Employee_ID IN (" + _TeamMember + ") ");
        }
        else
        {
            if (UserInfo.AccessPROIDs != "")
            {
                sb.AppendLine(" and em.Employee_ID IN (" + UserInfo.AccessPROIDs + ")");
            }
        }
     //   sb.AppendLine("  WHERE lt.IsCancel=0   ");
        sb.AppendLine("  GROUP BY em.Employee_ID ORDER BY ProName;   ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr["TotalOutStanding"] = dt.Compute("SUM(TotalOutStanding)", string.Empty);
            dr["TotalReceived"] = dt.Compute("SUM(TotalReceived)", string.Empty);
            dr["Days30"] = dt.Compute("SUM(Days30)", string.Empty);
            dr["Less180"] = dt.Compute("SUM(Less180)", string.Empty);
            dr["More180"] = dt.Compute("SUM(More180)", string.Empty);
            //dr["Total"] = dt.Compute("SUM(Total)", string.Empty);
            dr["ProName"] = "Total ::";
            dt.Rows.Add(dr);
			HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Sales Executive vs Ageing";
            return "1";
        
		}
		else
		{
			
			return "-1";
		}
		
      //  return Util.getJson(dt);
    }
}
using ClosedXML.Excel;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Lab_CurrentSalesStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(string SearchType)
    {
        StringBuilder sb = new StringBuilder();

        string RoleId = HttpContext.Current.Session["RoleId"].ToString();
        string Qry = "";
        if (RoleId == "1" || RoleId == "2")
        {
            DataTable dtEmployee = StockReports.GetDataTable("Select Employee_ID From Employee_Master WHERE `IsActive`=1");
            if (dtEmployee.Rows.Count > 0)
            {
                for (int i = 0; i < dtEmployee.Rows.Count; i++)
                {
                    Qry += dtEmployee.Rows[i]["Employee_Id"].ToString() + ",";
                }
                Qry = Qry.Trim().TrimEnd(',');
            }
        }
        else
        {
            Qry = Util.GetString(StockReports.ExecuteScalar(" CALL get_ChildNode_proc(" + HttpContext.Current.Session["ID"].ToString() + ",@Sales)"));
        }

        sb.Append(" SELECT em.Employee_ID,em.Name ,ROUND(IFNULL(TargetMoney,0)) TargetMoney, ");
        sb.Append(" ROUND((IFNULL(TargetMoney,0)/DAY(LAST_DAY(NOW()))))TargetPerDay, ");
        sb.Append(" ROUND(((IFNULL(TargetMoney,0)/DAY(LAST_DAY(NOW())))*DAYOFMONTH(NOW())))TillDayTarget, ");
        sb.Append(" ROUND(SUM(IFNULL(sales.amount,0))) TillDateSale, ");
        sb.Append(" ROUND(SUM(IFNULL(sales.amount,0))-((IFNULL(TargetMoney,0)/DAY(LAST_DAY(NOW())))*DAYOFMONTH(NOW())))Difference, ");
        sb.Append(" ROUND((SUM(IFNULL(sales.amount,0))/DAYOFMONTH(NOW()))* DAY(LAST_DAY(NOW()))) MonthEndLanding, ");
        sb.Append(" ROUND((SUM(IFNULL(sales.amount,0))/DAYOFMONTH(NOW()))) AvgSalePerDay, ");
        sb.Append(" if(DAYOFMONTH(NOW()) != DAY(LAST_DAY(NOW())), ((ROUND(IFNULL(TargetMoney,0)) - ROUND(SUM(IFNULL(sales.amount,0))) ) / (DAY(LAST_DAY(NOW()))-DAYOFMONTH(NOW()))) ,0) AvgSalePerDayRequired ");
        sb.Append(" FROM employee_master em  ");
        sb.Append(" LEFT JOIN ( ");
        sb.Append(" SELECT `DependentEmployeeID`,`TargetAmount` TargetMoney");
        sb.Append(" FROM `f_targetmonthwisedetail` ");
        sb.Append(" WHERE iscancel=0  AND YEAR=YEAR(CURDATE()) AND MONTH=MONTH(CURDATE()) AND IsGroup =0 ");
        sb.Append(" ) tg ON em.Employee_id= tg.DependentEmployeeID");
        sb.Append(" LEFT JOIN ");
        sb.Append(" (SELECT lt.SalesTagEmployee,SUM(lt.netamount)Amount FROM f_ledgertransaction lt ");
        sb.Append(" WHERE iscancel=0 ");
        sb.Append(" AND lt.`Date` >= DATE_FORMAT(NOW(),'%Y-%m-01 00:00:00')");
        sb.Append(" GROUP BY lt.`SalesTagEmployee`)sales");
        sb.Append(" ON em.employee_ID=sales.SalesTagEmployee ");
        sb.Append(" WHERE em.`IsSalesTeamMember`=1");
        sb.Append("  AND em.employee_ID IN (" + Qry + ")");
        sb.Append(" GROUP BY em.employee_ID;");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            if (SearchType == "0")
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "CurrentSalesReport";

                return "1";
            }
            else
            {
                return Util.getJson(dt);
            }
        }
        else
            return "0";
    }

    public static MemoryStream GetStream(XLWorkbook excelWorkbook)
    {
        MemoryStream fs = new MemoryStream();
        excelWorkbook.SaveAs(fs);
        fs.Position = 0;
        return fs;
    }
}
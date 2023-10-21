using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
public partial class Design_SalesDiagnostic_DailyStatus : System.Web.UI.Page
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
            BindPro();
        }
    }
    private void BindPro()
    {
        DataTable dt = StockReports.GetDataTable(AllLoad_Data.GetSalesManagerQuery());
        if (dt.Rows.Count > 0)
        {
            ddlpro.DataSource = dt;
            ddlpro.DataTextField = "ProName";
            ddlpro.DataValueField = "ProID";
            ddlpro.DataBind();
            ddlpro.Items.Insert(0, new ListItem("0", "0"));
        }
    }

    [WebMethod]
    public static string BindDailyStatus(string Pro, string Date)
    {
        string _TeamMember = "";
        if (Pro != "0")
        {
            _TeamMember = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`('" + Pro + "',@ChildNode);");
            _TeamMember = "'" + _TeamMember + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
        }
        StringBuilder sb = new StringBuilder();
        string datetyu = Convert.ToDateTime(Date).ToString("yyyy-MM-dd");
        int year = Convert.ToInt32(datetyu.Split('-')[0]);
        int month = Convert.ToInt32(datetyu.Split('-')[1]);
        int days = DateTime.DaysInMonth(year, month);
        sb.AppendLine("   SELECT PROID,TargetFromDate,DATE MonthYear,Target,ProCode,ProName,Achieved,AchievedPer,  ");
        sb.AppendLine("  Round(Short,2) Short,ROUND((AchievedPer-100),2) ShortPer,'0' Total FROM ( ");
        sb.AppendLine("  SELECT tt.*,ROUND((100 * Achieved) / Target, 2)AchievedPer,Achieved-Target Short FROM (  ");
        sb.AppendLine("   SELECT tg.PROID,DATE_FORMAT(tg.TargetFromDate,'%d-%m-%Y')TargetFromDate,DATE_FORMAT(DATE,'%d-%m-%Y')DATE,tg.TargetToDate,ROUND((tg.TargetAmount / " + days + "),2) Target,tg.ProCode,ProName,SUM(Achieved)Achieved   FROM Pro_Bussiness_Target tg  ");
        sb.AppendLine("  INNER JOIN     (    ");
        sb.AppendLine(" SELECT lt.Date,em.Employee_ID PROID,em.Employee_ID ProCode,em.Name ProName,  ");
        sb.AppendLine(" lt.NetAmount Achieved   FROM f_ledgertransaction lt    ");
        sb.AppendLine("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=fpm.SalesManagerID   ");
        sb.AppendLine("  WHERE lt.Date>=concat('" + year + "-" + month + "-01 00:00:00') and lt.Date<=concat('" + year + "-" + month + "-31 23:59:59')  "); 
        if (Pro != "0")
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
        sb.AppendLine("  )t ON t.ProID=tg.ProID WHERE DATE(t.Date)>= tg.TargetFromDate AND DATE(t.Date)<= tg.TargetToDate and month(tg.TargetToDate)=month('" + datetyu + "') ");
        sb.AppendLine("   GROUP BY t.PROID,DATE(t.date) ");
        sb.AppendLine(" )tt ");
        sb.AppendLine(" )ttt  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString()); 
        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr["Target"] = dt.Compute("SUM(Target)", string.Empty);
            dr["Achieved"] = dt.Compute("SUM(Achieved)", string.Empty);
            dr["AchievedPer"] = dt.Compute("(100 * SUM(Achieved)) / SUM(Target)", string.Empty);
            dr["Short"] = dt.Compute("SUM(Short)", string.Empty);
            dr["ShortPer"] = dt.Compute("(((100 * SUM(Achieved)) / SUM(Target))-100)", string.Empty); 
            dr["Total"] = "Total ::";
            dt.Rows.Add(dr);
        }
        return Util.getJson(dt);
    }
}
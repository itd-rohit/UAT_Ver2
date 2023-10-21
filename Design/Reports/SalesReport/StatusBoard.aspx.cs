using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
public partial class Design_SalesDiagnostic_StatusBoard : System.Web.UI.Page
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets

    }
    public string PROId;
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
    public static string BindSummary(string Pro)
    {
        string _TeamMember = "";
        if (Pro != "0")
        {
            _TeamMember = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`('" + Pro + "',@ChildNode);");
            _TeamMember = "'" + _TeamMember + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
        }
        StringBuilder sb = new StringBuilder();
        sb.AppendLine("    SELECT Round(SUM(Target),2) Target,DATE_FORMAT(TargetFromDate,'%b-%Y')TargetDate,Round(SUM(Achieved),2) Achieved , SUM(AltRef) AltRef,SUM(RefNo) RefNo, ");
        sb.AppendLine("  ROUND((100 * SUM(Achieved)) / SUM(Target), 2)AchievedPer,ROUND((100 * SUM(RefNo)) / SUM(AltRef), 2)RefPer,SUM(NewRefNo)NewRefNo,SUM(sales)sales,0 Amount,'0' Total ");
        sb.AppendLine("  FROM( ");
        sb.AppendLine("  SELECT tl.*,IFNULL(SUM(Sales),0)Sales FROM (SELECT ttttt.*,IFNULL(SUM(NewRefNo),0)NewRefNo FROM (SELECT tt.*,IFNULL(ttt.AltRef,0)AltRef ,IFNULL(SUM(tttt.RefNo),0)RefNo FROM (SELECT tg.PROID,tg.TargetFromDate,tg.TargetToDate,tg.TargetAmount Target,tg.ProCode,ProName,SUM(Achieved) Achieved ");
        sb.AppendLine("  FROM Pro_Bussiness_Target tg  INNER JOIN   ");
        sb.AppendLine("  ( ");
        sb.AppendLine("  SELECT pli.Date,em.Employee_ID PROID,em.Employee_ID ProCode,em.Name ProName,   ");
        sb.AppendLine("  SUM(pli.Amount) Achieved,'0'RefNo,'0'NewRefNo,'0' sales   FROM f_ledgertransaction lt  ");
		
		
		sb.AppendLine(" inner join Patient_LabInvestigation_OPD pli on pli.LedgertransactionID=lt.LedgertransactionID AND IF(pli.isPackage=1,pli.`SubCategoryID`=15,pli.`SubCategoryID`!=15) ");      
		
		
        sb.AppendLine("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=fpm.SalesManagerID   ");
       // sb.AppendLine("  WHERE lt.IsCancel=0  ");
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
        sb.AppendLine(" GROUP BY lt.LedgertransactionID )t ON t.ProID=tg.ProID WHERE DATE(t.Date)>= tg.TargetFromDate AND DATE(t.Date)<= tg.TargetToDate ");
        sb.AppendLine("  GROUP BY t.PROID,MONTH(tg.TargetFromDate))tt ");

        sb.AppendLine("  LEFT JOIN ( ");
        sb.AppendLine("  SELECT em.Employee_ID ProID,COUNT(1)AltRef FROM employee_master em INNER JOIN f_panel_master fpm ON em.Employee_ID=fpm.SalesManagerID ");
        sb.AppendLine("  WHERE fpm.IsActive=1 ");
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
        sb.AppendLine("  GROUP BY em.Employee_ID ");
        sb.AppendLine("  )ttt ON tt.ProID=ttt.PROID ");

        sb.AppendLine("  LEFT JOIN ( ");
        sb.AppendLine("  SELECT IFNULL(COUNT(DISTINCT lt.Panel_ID),0)RefNo ,lt.Date,em.Employee_ID PROID ");
        sb.AppendLine("  FROM f_ledgertransaction lt ");
        sb.AppendLine("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=fpm.SalesManagerID   ");
      //  sb.AppendLine("  WHERE lt.IsCancel=0  ");
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
        sb.AppendLine("  GROUP BY em.Employee_ID,MONTH(lt.Date) ");
        sb.AppendLine("  ) tttt ON tttt.ProID=tt.ProID AND DATE(tttt.Date)>= tt.TargetFromDate AND DATE(tttt.Date)<= tt.TargetToDate GROUP BY tt.PROID,MONTH(tt.TargetFromDate) ");
        sb.AppendLine("  )ttttt ");

        sb.AppendLine("  LEFT JOIN ( ");
        sb.AppendLine("  SELECT em.Employee_ID PROID,COUNT(1)NewRefNo,DATE(fpm.CreatorDate)AddedDate FROM employee_master em INNER JOIN f_panel_master fpm ON em.Employee_ID=fpm.SalesManagerID ");
        sb.AppendLine("  WHERE fpm.IsActive=1 ");
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
        sb.AppendLine("  GROUP BY em.Employee_ID,DATE(fpm.CreatorDate) ");
        sb.AppendLine("  )tttttt ON tttttt.ProID=ttttt.PROID AND tttttt.AddedDate>= ttttt.TargetFromDate AND tttttt.AddedDate<= ttttt.TargetToDate GROUP BY ttttt.PROID,MONTH(ttttt.TargetFromDate) ");
        sb.AppendLine("  )tl  ");
        sb.AppendLine("  LEFT JOIN  ");
        sb.AppendLine("  ( ");
        sb.AppendLine("  SELECT em.Employee_ID PROID,DATE(fpm.CreatorDate)AddedDate ,SUM(lt.NetAmount)Sales FROM f_ledgertransaction lt ");
        sb.AppendLine("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=fpm.SalesManagerID   ");
        sb.AppendLine("  WHERE fpm.IsActive=1  ");
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
        sb.AppendLine("   GROUP BY em.Employee_ID,DATE(fpm.CreatorDate) ");
        sb.AppendLine("  )tlb ON tl.ProID=tlb.PROID AND tlb.AddedDate>= tl.TargetFromDate AND tlb.AddedDate<= tl.TargetToDate GROUP BY tl.PROID,MONTH(tl.TargetFromDate)  ");
        sb.AppendLine("  )ft GROUP BY MONTH(TargetFromDate) ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow(); 
            dr["Target"] = dt.Compute("SUM(Target)", string.Empty);
            dr["Achieved"] = dt.Compute("SUM(Achieved)", string.Empty);
            dr["AltRef"] = dt.Compute("SUM(AltRef)", string.Empty);
            dr["RefNo"] = dt.Compute("SUM(RefNo)", string.Empty);
            dr["NewRefNo"] = dt.Compute("SUM(NewRefNo)", string.Empty);
            dr["AchievedPer"] = dt.Compute("(100 * SUM(Achieved)) / SUM(Target)", string.Empty);
            dr["RefPer"] = dt.Compute("(100 * SUM(RefNo)) / SUM(AltRef)", string.Empty);
            dr["sales"] = dt.Compute("SUM(sales)", string.Empty);
            dr["Amount"] = dt.Compute("SUM(Amount)", string.Empty);
            dr["Total"] = "Total ::";
            dt.Rows.Add(dr);
        }
        return Util.getJson(dt);
    }

    [WebMethod]
    public static string ReferalInfo(string Pro)
    {
        string _TeamMember = "";
        if (Pro != "0")
        {
            _TeamMember = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`('" + Pro + "',@ChildNode);");
            _TeamMember = "'" + _TeamMember + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
        }
        StringBuilder sb = new StringBuilder();
        sb.AppendLine("  SELECT PROID,Round(Target,2) Target,ProName,DATE_FORMAT(TargetFromDate,'%d-%m-%Y')TargetDate,ProCode,Round(Achieved,2) Achieved,AltRef,RefNo, ");
        sb.AppendLine("  ROUND((100 * Achieved) / Target, 2)AchievedPer,ROUND((100 * RefNo) / AltRef, 2)RefPer,NewRefNo,sales,0 Amount ");
        sb.AppendLine("  FROM( ");
        sb.AppendLine("  SELECT tl.*,IFNULL(SUM(Sales),0)Sales FROM (SELECT ttttt.*,IFNULL(SUM(NewRefNo),0)NewRefNo FROM (SELECT tt.*,IFNULL(ttt.AltRef,0)AltRef ,IFNULL(SUM(tttt.RefNo),0)RefNo FROM (SELECT tg.PROID,tg.TargetFromDate,tg.TargetToDate,tg.TargetAmount Target,tg.ProCode,ProName,SUM(Achieved)Achieved ");
        sb.AppendLine("  FROM Pro_Bussiness_Target tg  INNER JOIN   ");
        sb.AppendLine("  ( ");
        sb.AppendLine("  SELECT lt.Date,em.Employee_ID PROID,em.Employee_ID ProCode,em.Name ProName,   ");
        sb.AppendLine("  lt.NetAmount Achieved,'0'RefNo,'0'NewRefNo,'0' sales   FROM f_ledgertransaction lt  ");
        sb.AppendLine("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=fpm.SalesManagerID   ");
       // sb.AppendLine("  WHERE lt.IsCancel=0  ");
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
        sb.AppendLine("  )t ON t.ProID=tg.ProID WHERE DATE(t.Date)>= tg.TargetFromDate AND DATE(t.Date)<= tg.TargetToDate ");
        sb.AppendLine("  GROUP BY t.PROID,MONTH(tg.TargetFromDate))tt ");

        sb.AppendLine("  LEFT JOIN ( ");
        sb.AppendLine("  SELECT em.Employee_ID ProID,COUNT(1)AltRef FROM employee_master em INNER JOIN f_panel_master fpm ON em.Employee_ID=fpm.SalesManagerID ");
        sb.AppendLine("  WHERE fpm.IsActive=1  ");
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
        sb.AppendLine("  GROUP BY em.Employee_ID  )ttt ON tt.ProID=ttt.PROID ");

        sb.AppendLine("  LEFT JOIN ( ");
        sb.AppendLine("  SELECT IFNULL(COUNT(DISTINCT lt.Panel_ID),0)RefNo ,lt.Date,em.Employee_ID PROID ");
        sb.AppendLine("  FROM f_ledgertransaction lt ");
        sb.AppendLine("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=fpm.SalesManagerID   ");
      //  sb.AppendLine("  WHERE lt.IsCancel=0  ");
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
        sb.AppendLine("  GROUP BY em.Employee_ID,MONTH(lt.Date) ");
        sb.AppendLine("  ) tttt ON tttt.ProID=tt.ProID AND DATE(tttt.Date)>= tt.TargetFromDate AND DATE(tttt.Date)<= tt.TargetToDate GROUP BY tt.PROID,MONTH(tt.TargetFromDate) ");
        sb.AppendLine("  )ttttt "); 

        sb.AppendLine("  LEFT JOIN ( ");
        sb.AppendLine("  SELECT em.Employee_ID PROID,COUNT(1)NewRefNo,DATE(fpm.CreatorDate)AddedDate FROM employee_master em INNER JOIN f_panel_master fpm ON em.Employee_ID=fpm.SalesManagerID ");
        sb.AppendLine("  WHERE fpm.IsActive=1");
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
        sb.AppendLine("  GROUP BY em.Employee_ID,DATE(fpm.CreatorDate) ");
        sb.AppendLine("  )tttttt ON tttttt.ProID=ttttt.PROID AND tttttt.AddedDate>= ttttt.TargetFromDate AND tttttt.AddedDate<= ttttt.TargetToDate GROUP BY ttttt.PROID,MONTH(ttttt.TargetFromDate) ");
        sb.AppendLine("  )tl  ");

        sb.AppendLine("  LEFT JOIN  ");
        sb.AppendLine("  ( ");
        sb.AppendLine("  SELECT em.Employee_ID PROID,DATE(fpm.CreatorDate)AddedDate ,SUM(lt.NetAmount)Sales FROM f_ledgertransaction lt ");
        sb.AppendLine("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=fpm.SalesManagerID   ");
        sb.AppendLine("  WHERE fpm.IsActive=1  ");
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
        sb.AppendLine("   GROUP BY em.Employee_ID,DATE(fpm.CreatorDate) ");
        sb.AppendLine("  )tlb ON tl.ProID=tlb.PROID AND tlb.AddedDate>= tl.TargetFromDate AND tlb.AddedDate<= tl.TargetToDate GROUP BY tl.PROID,MONTH(tl.TargetFromDate)  ");
        sb.AppendLine("  )ft order by ProName,TargetDate ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr["Target"] = dt.Compute("SUM(Target)", string.Empty);
            dr["Achieved"] = dt.Compute("SUM(Achieved)", string.Empty);
            dr["AltRef"] = dt.Compute("SUM(AltRef)", string.Empty);
            dr["RefNo"] = dt.Compute("SUM(RefNo)", string.Empty);
            dr["NewRefNo"] = dt.Compute("SUM(NewRefNo)", string.Empty);
            dr["AchievedPer"] = dt.Compute("(100 * SUM(Achieved)) / SUM(Target)", string.Empty);
            dr["RefPer"] = dt.Compute("(100 * SUM(RefNo)) / SUM(AltRef)", string.Empty);
            dr["sales"] = dt.Compute("SUM(sales)", string.Empty);
            dr["Amount"] = dt.Compute("SUM(Amount)", string.Empty);
            dr["ProName"] = "Total ::";
            dt.Rows.Add(dr);
        }
        return Util.getJson(dt);
    }
	


    [WebMethod]
    public static string BindSummaryExcel(string Pro)
    {
        string _TeamMember = "";
        if (Pro != "0")
        {
            _TeamMember = StockReports.ExecuteScalar("CALL `get_ChildNode_proc`('" + Pro + "',@ChildNode);");
            _TeamMember = "'" + _TeamMember + "'";
            _TeamMember = _TeamMember.Replace(",", "','");
        }
        StringBuilder sb = new StringBuilder();
        sb.AppendLine("    SELECT Round(SUM(Target),2) Target,DATE_FORMAT(TargetFromDate,'%b-%Y')TargetDate,Round(SUM(Achieved),2) Achieved , SUM(AltRef) AltRef,SUM(RefNo) RefNo, ");
        sb.AppendLine("  ROUND((100 * SUM(Achieved)) / SUM(Target), 2)AchievedPer,ROUND((100 * SUM(RefNo)) / SUM(AltRef), 2)RefPer,SUM(NewRefNo)NewRefNo,SUM(sales)sales,0 Amount,'0' Total ");
        sb.AppendLine("  FROM( ");
        sb.AppendLine("  SELECT tl.*,IFNULL(SUM(Sales),0)Sales FROM (SELECT ttttt.*,IFNULL(SUM(NewRefNo),0)NewRefNo FROM (SELECT tt.*,IFNULL(ttt.AltRef,0)AltRef ,IFNULL(SUM(tttt.RefNo),0)RefNo FROM (SELECT tg.PROID,tg.TargetFromDate,tg.TargetToDate,tg.TargetAmount Target,tg.ProCode,ProName,SUM(Achieved) Achieved ");
        sb.AppendLine("  FROM Pro_Bussiness_Target tg  INNER JOIN   ");
        sb.AppendLine("  ( ");
        sb.AppendLine("  SELECT pli.Date,em.Employee_ID PROID,em.Employee_ID ProCode,em.Name ProName,   ");
        sb.AppendLine("  SUM(pli.Amount) Achieved,'0'RefNo,'0'NewRefNo,'0' sales   FROM f_ledgertransaction lt  ");
		
		
		sb.AppendLine(" inner join Patient_LabInvestigation_OPD pli on pli.LedgertransactionID=lt.LedgertransactionID AND IF(pli.isPackage=1,pli.`SubCategoryID`=15,pli.`SubCategoryID`!=15) ");      
		
		
        sb.AppendLine("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=fpm.SalesManagerID   ");
       // sb.AppendLine("  WHERE lt.IsCancel=0  ");
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
        sb.AppendLine(" GROUP BY lt.LedgertransactionID )t ON t.ProID=tg.ProID WHERE DATE(t.Date)>= tg.TargetFromDate AND DATE(t.Date)<= tg.TargetToDate ");
        sb.AppendLine("  GROUP BY t.PROID,MONTH(tg.TargetFromDate))tt ");

        sb.AppendLine("  LEFT JOIN ( ");
        sb.AppendLine("  SELECT em.Employee_ID ProID,COUNT(1)AltRef FROM employee_master em INNER JOIN f_panel_master fpm ON em.Employee_ID=fpm.SalesManagerID ");
        sb.AppendLine("  WHERE fpm.IsActive=1 ");
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
        sb.AppendLine("  GROUP BY em.Employee_ID ");
        sb.AppendLine("  )ttt ON tt.ProID=ttt.PROID ");

        sb.AppendLine("  LEFT JOIN ( ");
        sb.AppendLine("  SELECT IFNULL(COUNT(DISTINCT lt.Panel_ID),0)RefNo ,lt.Date,em.Employee_ID PROID ");
        sb.AppendLine("  FROM f_ledgertransaction lt ");
        sb.AppendLine("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=fpm.SalesManagerID   ");
      //  sb.AppendLine("  WHERE lt.IsCancel=0  ");
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
        sb.AppendLine("  GROUP BY em.Employee_ID,MONTH(lt.Date) ");
        sb.AppendLine("  ) tttt ON tttt.ProID=tt.ProID AND DATE(tttt.Date)>= tt.TargetFromDate AND DATE(tttt.Date)<= tt.TargetToDate GROUP BY tt.PROID,MONTH(tt.TargetFromDate) ");
        sb.AppendLine("  )ttttt ");

        sb.AppendLine("  LEFT JOIN ( ");
        sb.AppendLine("  SELECT em.Employee_ID PROID,COUNT(1)NewRefNo,DATE(fpm.CreatorDate)AddedDate FROM employee_master em INNER JOIN f_panel_master fpm ON em.Employee_ID=fpm.SalesManagerID ");
        sb.AppendLine("  WHERE fpm.IsActive=1 ");
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
        sb.AppendLine("  GROUP BY em.Employee_ID,DATE(fpm.CreatorDate) ");
        sb.AppendLine("  )tttttt ON tttttt.ProID=ttttt.PROID AND tttttt.AddedDate>= ttttt.TargetFromDate AND tttttt.AddedDate<= ttttt.TargetToDate GROUP BY ttttt.PROID,MONTH(ttttt.TargetFromDate) ");
        sb.AppendLine("  )tl  ");
        sb.AppendLine("  LEFT JOIN  ");
        sb.AppendLine("  ( ");
        sb.AppendLine("  SELECT em.Employee_ID PROID,DATE(fpm.CreatorDate)AddedDate ,SUM(lt.NetAmount)Sales FROM f_ledgertransaction lt ");
        sb.AppendLine("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
        sb.AppendLine("  INNER JOIN employee_master em ON em.Employee_ID=fpm.SalesManagerID   ");
        sb.AppendLine("  WHERE fpm.IsActive=1  ");
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
        sb.AppendLine("   GROUP BY em.Employee_ID,DATE(fpm.CreatorDate) ");
        sb.AppendLine("  )tlb ON tl.ProID=tlb.PROID AND tlb.AddedDate>= tl.TargetFromDate AND tlb.AddedDate<= tl.TargetToDate GROUP BY tl.PROID,MONTH(tl.TargetFromDate)  ");
        sb.AppendLine("  )ft GROUP BY MONTH(TargetFromDate) ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow(); 
            dr["Target"] = dt.Compute("SUM(Target)", string.Empty);
            dr["Achieved"] = dt.Compute("SUM(Achieved)", string.Empty);
            dr["AltRef"] = dt.Compute("SUM(AltRef)", string.Empty);
            dr["RefNo"] = dt.Compute("SUM(RefNo)", string.Empty);
            dr["NewRefNo"] = dt.Compute("SUM(NewRefNo)", string.Empty);
            dr["AchievedPer"] = dt.Compute("(100 * SUM(Achieved)) / SUM(Target)", string.Empty);
            dr["RefPer"] = dt.Compute("(100 * SUM(RefNo)) / SUM(AltRef)", string.Empty);
            dr["sales"] = dt.Compute("SUM(sales)", string.Empty);
            dr["Amount"] = dt.Compute("SUM(Amount)", string.Empty);
            dr["Total"] = "Total ::";
            dt.Rows.Add(dr);
			HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Monthly Status";
            return "1";
			
        }
		else
		{
			
			return "-1";
		}
       // return Util.getJson(dt);
    }
}
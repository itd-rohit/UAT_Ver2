using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;
using System.Collections.Generic;
using System.Globalization;

public partial class Design_PRO_SetPROTarget : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //ddlyearfrom.SelectedIndex = ddlyearfrom.Items.IndexOf(ddlyearfrom.Items.FindByValue(DateTime.Now.Year.ToString()));
            //ddlyearto.SelectedIndex = ddlyearto.Items.IndexOf(ddlyearto.Items.FindByValue(DateTime.Now.Year.ToString()));
            //ddlmonthfrom.SelectedIndex = ddlmonthfrom.Items.IndexOf(ddlmonthfrom.Items.FindByValue(DateTime.Now.Month.ToString()));
            //ddlmonthto.SelectedIndex = ddlmonthto.Items.IndexOf(ddlmonthto.Items.FindByValue(DateTime.Now.Month.ToString()));
            BindPanel();


        }
    }

    private void BindPanel()
    {
        DataTable dt = StockReports.GetDataTable("SELECT * FROM salesteam_master ");
        if (dt.Rows.Count > 0)
        {
            ddlPanel.DataSource = dt;
            ddlPanel.DataTextField = "PRONAME";
            ddlPanel.DataValueField = "PROID";
            ddlPanel.DataBind();
        }
        ddlPanel.Items.Insert(0, new ListItem("", "0"));


    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindSubCategory()
    {

        DataTable dt = StockReports.GetDataTable(" SELECT ProId as Employee_Id,ProName as Name,Designation as Designation FROM salesteam_master ");
        {
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else
            {
                return "";
            }
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindtargetdata(string year, string frommonthid, string frommonthname, string proid, string proname)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT Panel_Id,Company_Name,TargetMoney,Tid  FROM (");
        sb.Append(" SELECT FPM.Panel_Id,FPM.Company_Name,PTM.TargetMoney,ID AS Tid  FROM f_panel_master FPM");
        sb.Append(" LEFT JOIN pro_targetmaster PTM ON FPM.SalesManager=PTM.PROID AND FPM.`Panel_ID`=PTM.`Panel_Id`");
        sb.Append(" WHERE FPM.SalesManager=@SalesManager");
        sb.Append(" AND PTM.TargetMonth=@TargetMonth");
        sb.Append(" AND PTM.TargetYear=@TargetYear UNION");
        sb.Append(" SELECT FPM.Panel_Id,FPM.Company_Name,'' AS TargetMoney,'0' AS Tid FROM f_panel_master FPM");
        sb.Append(" LEFT JOIN pro_targetmaster PTM ON FPM.SalesManager=PTM.PROID");
        sb.Append(" WHERE FPM.SalesManager=@SalesManager");
        sb.Append(" ) TEM GROUP BY Panel_Id ORDER BY Company_Name");

        DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
             new MySqlParameter("@SalesManager", proid),
             new MySqlParameter("@TargetMonth", frommonthid),
             new MySqlParameter("@TargetYear", year)
             ).Tables[0];
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }




    static string monthname(string id)
    {
        string monthname = "";
        switch (id)
        {
            case "1":
                {
                    monthname = "January";
                    break;
                }
            case "2":
                {
                    monthname = "February";
                    break;
                }
            case "3":
                {
                    monthname = "March";
                    break;
                }
            case "4":
                {
                    monthname = "April";
                    break;
                }
            case "5":
                {
                    monthname = "May";
                    break;
                }
            case "6":
                {
                    monthname = "June";
                    break;
                }
            case "7":
                {
                    monthname = "July";
                    break;
                }
            case "8":
                {
                    monthname = "August";
                    break;
                }
            case "9":
                {
                    monthname = "September";
                    break;
                }
            case "10":
                {
                    monthname = "October";
                    break;
                }
            case "11":
                {
                    monthname = "November";
                    break;
                }
            case "12":
                {
                    monthname = "December";
                    break;
                }

        }
        return monthname;
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savetargetdata(List<SaveData> SaveData, List<DeleteList> DeleteList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (DeleteList.Count > 0)
            {
                for (int i = 0; i < DeleteList.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM pro_targetmaster WHERE ID=" + DeleteList[i].ProId);
                }
            }

            if (SaveData.Count > 0)
            {
                for (int i = 0; i < SaveData.Count; i++)
                {
                    string Mon = string.Empty;
                    if (Convert.ToInt32(SaveData[i].MonthId) < 10)
                    {
                        Mon = "0" + SaveData[i].MonthId;
                    }
                    else
                    {
                        Mon = SaveData[i].MonthId;
                    }

                    string StartDate = SaveData[i].Year + "-" + Mon + "-01 00:00:00";

                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO pro_targetmaster(PROID,ProName,targetYear,TargetMonth,TargetMonthName,TargetMoney,Panel_Id,EntryDate,EntryById,EntryByName,StartDate) ");
                    sb.Append(" VALUES('" + SaveData[i].ProId + "','" + SaveData[i].ProName + "','" + SaveData[i].Year + "','" + SaveData[i].MonthId + "','" + SaveData[i].MonthName + "','" + SaveData[i].TargetMoney + "','" + SaveData[i].panelId + "',now(),'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + StartDate + "') ");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@Year", SaveData[i].Year),
                     new MySqlParameter("@MonthId", SaveData[i].MonthId),
                     new MySqlParameter("@MonthName", SaveData[i].MonthName),
                     new MySqlParameter("@ProId", SaveData[i].ProId),
                     new MySqlParameter("@ProName", SaveData[i].ProName),
                     new MySqlParameter("@TargetMoney", SaveData[i].TargetMoney),
                     new MySqlParameter("@PanelId", SaveData[i].panelId),
                     new MySqlParameter("@EntryById", UserInfo.ID),
                     new MySqlParameter("@EntryByName", UserInfo.LoginName),
                     new MySqlParameter("@StartDate", StartDate)
                     );
                }
            }

            tnx.Commit();
            con.Close();
            return "1";
        }
        catch
        {
            tnx.Rollback();
            con.Close();
            return "0";
        }
        finally
        {
            con.Dispose();
        }

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Search(string Year, string PanelId, string PanelName, string Type)
    {
        StringBuilder sb = new StringBuilder();

        DateTime dtNow = DateTime.ParseExact("01/03/" + Year.Split('-')[0].ToString(), "dd/MM/yyyy", CultureInfo.InvariantCulture);

        string Ids = StockReports.ExecuteScalar("CALL get_ChildNode_proc(" + PanelId.ToString() + ",@str)");
        sb.Append(" SELECT '" + Year + "' AS FinancialYear, pnl.Company_Name as PanelName,pnl.PanelSalesManager,pnl.Type1,pnl.SalesRegion,pnl.PartnerCategory,pnl.Affiliation, ROUND(SUM(IFNULL(ptm.target,0)),0)TotalTarget,ROUND(SUM(IFNULL(sales.Achieved,0)),0) TotalAchieved,ROUND(SUM(IFNULL(sales.Achieved,0))-SUM(IFNULL(ptm.target,0)),0) TotalDelta ,");



        for (int i = 1; i <= 12; i++)
        {
            DateTime dt1 = dtNow.AddMonths(i);
            sb.Append("IF(ptm.Date='" + dt1.ToString("yyyy-MM-dd") + " 00:00:00',IFNULL(Target,0),0) `" + dt1.ToString("MMM") + "_Target` ,");
            sb.Append("IF(sales.Date='" + dt1.ToString("yyyy-MM-dd") + " 00:00:00',ROUND(IFNULL(Achieved,0),0),0) `" + dt1.ToString("MMM") + "_Achieved` ,");
            sb.Append(" IF(sales.Date='" + dt1.ToString("yyyy-MM-dd") + " 00:00:00',ROUND(IFNULL(Achieved,0),0),0)-IF(ptm.Date='" + dt1.ToString("yyyy-MM-dd") + " 00:00:00',ROUND(IFNULL(Target,0),0),0)   `" + dt1.ToString("MMM") + "_Delta` , ");
           // sb.Append("IF(ptm.Date='" + dt1.ToString("yyyy-MM-dd") + " 00:00:00',(IFNULL(Achieved,0)-IFNULL(Target,0)),0) `" + dt1.ToString("MMM") + "_Delta` ,");

        }



        sb.Append(" (SELECT NAME FROM Employee_Master WHERE Employee_id=@SalesManager) AS SalesManager ");

        sb.Append(" FROM (SELECT fpm.Panel_Id,fpm.Company_Name,CM.Type1,'' SalesRegion,'' PartnerCategory,'' Affiliation, (SELECT IFNULL(Concat('(',NAME,')'),'') as Name FROM Employee_Master WHere Employee_ID = fpm.SalesManager) as PanelSalesManager  FROM `f_panel_master` fpm ");
        sb.Append(" INNER JOIN Centre_Master CM ON CM.CentreId=fpm.CentreId ");
        sb.Append(" WHERE FIND_IN_SET(fpm.`SalesManager`,'" + Ids + "') ");
        sb.Append(" UNION ALL Select '0', 'UnAllocated','','','','','' ");
        sb.Append(" )pnl ");
        sb.Append(" LEFT JOIN ");
        sb.Append("(SELECT ptm.`Panel_Id`,SUM(ptm.`TargetMoney`) Target,DATE_FORMAT(ptm.`StartDate`,'%Y-%m-01 00:00:00')DATE FROM pro_targetmaster PTM  ");
        sb.Append("WHERE   FIND_IN_SET(PTM.PROID,'" + Ids + "')  AND  ");
        sb.Append("PTM.StartDate >=CONCAT(@YearFrom,'-04-01 00:00:00')   ");
        sb.Append("AND PTM.StartDate <=CONCAT(@YearTo,'-03-31 23:59:59')  GROUP BY ptm.`Panel_Id`,DATE_FORMAT(ptm.`StartDate`,'%Y-%m-01 00:00:00')");
           // sb.Append(" UNION ALL ");
// sb.Append("SELECT 0,0,'2018-04-01 00:00:00'");
           sb.Append(" ) ptm  ON ptm.Panel_id=pnl.Panel_id ");
        sb.Append("LEFT JOIN ");

        sb.Append("(SELECT fpm.`Panel_ID`,fpm.`Company_Name`,fpm.`CentreID`, IFNULL(SUM(pls.`PCCInvoiceAmt`),0) Achieved,DATE_FORMAT(lt.`Date`,'%Y-%m-01 00:00:00') DATE,lt.Sales  FROM f_ledgerTransaction lt   ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd_share` pls ON pls.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
        sb.Append("INNER JOIN `f_panel_master` fpm ON fpm.`Panel_ID`=lt.`Panel_ID` ");
        sb.Append("AND  lt.`Date` >=CONCAT(@YearFrom,'-04-01 00:00:00')   ");
        sb.Append("AND lt.`Date` <=CONCAT(@YearTo,'-03-31 23:59:59')");
        sb.Append(" WHERE lt.IsCancel=0 AND FIND_IN_SET(" + PanelId + ",lt.`Sales`)  ");
        sb.Append(" GROUP BY fpm.`InvoiceTo`,DATE_FORMAT(lt.`Date`,'%Y-%M') ");
        sb.Append("  UNION ALL   ");
        sb.Append("  SELECT 0,'Unallocated',fpm.`CentreID`, IFNULL(SUM(pls.`PCCInvoiceAmt`),0)Achieved,  ");
        sb.Append("  DATE_FORMAT(lt.`Date`,'%Y-%m-01 00:00:00') DATE,lt.Sales  FROM f_ledgerTransaction lt     ");
        sb.Append("  INNER JOIN `patient_labinvestigation_opd_share` pls ON pls.`LedgerTransactionID`=lt.`LedgerTransactionID`   ");
        sb.Append("  INNER JOIN `f_panel_master` fpm ON fpm.`Panel_ID`=lt.`Panel_ID` AND  lt.`Date` >=CONCAT(@YearFrom,'-04-01 00:00:00')     ");
        sb.Append("  AND lt.`Date` <=CONCAT(@YearTo,'-03-31 23:59:59') WHERE lt.IsCancel=0  AND IF(lt.`Sales`='',0,lt.`Sales`)=0   ");
        sb.Append("  GROUP BY DATE_FORMAT(lt.`Date`,'%Y-%M')  ");

        sb.Append("  )Sales ON Sales.Panel_ID=pnl.Panel_ID ");
        sb.Append("GROUP BY ");
        sb.Append("pnl.Panel_id,Sales.Date order by pnl.Company_name ");


        //sb.Append(" SELECT * FROM(");
        //sb.Append(" SELECT (SELECT NAME FROM Employee_Master WHERE Employee_id=ProId) AS SalesManager, CONCAT(TargetMonthName,' ',TargetYear) TargetOf,Target,Achieved,(Target-Achieved) Delta FROM (");
        //sb.Append(" SELECT Panel_ID,TargetMonthName,TargetYear,PTM.TargetMonth, ");
        //sb.Append(" (SELECT IFNULL(SUM(NetAmount),0) ");
        //sb.Append(" FROM f_ledgerTransaction lt ");
        //sb.Append(" WHERE lt.Date >=CONCAT(PTM.TargetYear,'-',PTM.TargetMonth,'-01 00:00:00') ");
        //sb.Append(" AND lt.Date <=CONCAT(LAST_DAY(CONCAT(PTM.TargetYear,'-',PTM.TargetMonth,'-01')),' 23:59:59')");
        //sb.Append(" AND  lt.Panel_Id=PTM.Panel_ID) Achieved,");
        //sb.Append(" (SELECT IFNULL(SUM(TargetMoney),0) Target FROM Pro_targetMaster");
        //sb.Append(" WHERE StartDate=CONCAT(PTM.TargetYear,'-',PTM.TargetMonth,'-01 00:00:00') ");
        //sb.Append(" AND Panel_Id=PTM.Panel_ID ");
        //sb.Append(" AND PROID = (SELECT SalesManager FROM f_panel_master WHERE Panel_Id=PTM.Panel_ID)) Target,PROID ");
        //sb.Append(" FROM pro_targetmaster PTM");
        //sb.Append(" WHERE PTM.`Panel_Id`=@Panelid ");
        //sb.Append(" AND PTM.StartDate >=CONCAT(@YearFrom,'-04-01 00:00:00') ");
        //sb.Append(" AND PTM.StartDate <=CONCAT(@YearTo,'-03-31 00:00:00')");
        //sb.Append(" ) Tem ORDER BY TargetYear,TargetMonth ) Tab ");
        using (DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, sb.ToString(),
                          new MySqlParameter("@SalesManager", PanelId),
                          new MySqlParameter("@YearFrom", Year.Split('-')[0]),
                          new MySqlParameter("@YearTo", Year.Split('-')[1])
                         ).Tables[0])
        {
            if (dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["ReportName"] = "SalesReport";
                if (Type == "1")
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                }
                else if (Type == "2")
                {
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    //  ds.WriteXmlSchema(@"H:\SalesReport2.xml");
                    HttpContext.Current.Session["ds"] = ds;
                }
                return "1";
            }
            else
            {

                return "0";
            }
        }
    }




}

public class SaveData
{
    public string Year { get; set; }
    public string MonthId { get; set; }
    public string MonthName { get; set; }
    public string ProId { get; set; }
    public string ProName { get; set; }
    public string TargetMoney { get; set; }
    public string panelId { get; set; }

}

public class DeleteList
{
    public string ProId { get; set; }

}
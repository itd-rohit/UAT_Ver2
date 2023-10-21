using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_QualityIndicatorDelayTATDRL_Draw : System.Web.UI.Page
{
    public string jsonstring="";
    public string headding1 = "";
    public string headding2 = "";
    public string headding3 = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        string Val = Util.GetString(Request["Val"]);
        string[] splitVal = Val.Split('_');

        BindData(splitVal[0], splitVal[1], splitVal[2], splitVal[3],splitVal[4]);
    }
    public void BindData(string ReportType, string Deparment, string Year, string FromMonth, string ToMonth)
    {
        string ReportName = "";
        StringBuilder sb = new StringBuilder();
         StringBuilder sbdata = new StringBuilder();
         DataTable dt = new DataTable();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (ReportType == "1")
            {
                sb.Append("   SELECT t.Name AS Department, t.Month,t.DelayedSample AS 'Val',t.TotalSample,((t.DelayedSample/t.TotalSample)* 100) AS 'Val_Per','<5%' as limitVal  FROM ");
                sb.Append("  (SELECT sm.Name, MONTHNAME(pli.date) AS 'Month', SUM(IF(IF(pli.`Approved` =0, NOW(),pli.`ApprovedDate`) > pli.`DeliveryDate`&& pli.`DeliveryDate` != '0001-01-01 00:00:00' && pli.`DeliveryDate` IS NOT NULL , 1,0)) AS 'DelayedSample' , SUM(1) AS 'TotalSample' ");
                sb.Append(" FROM `patient_labinvestigation_opd` pli ");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID` ");
                sb.Append("  INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`= pli.SubcategoryID AND pli.SubcategoryID=@SubcategoryID  and  pli.`Date`>=@fromdate AND pli.`Date`<=@todate ");
                sb.Append(" GROUP BY MONTH(pli.`Date`)) t  ");
                ReportName = "Quality Indicator Delay TAT";
                headding1 = "Total no of Delayed Samples";
                headding2 = "% Delayed";
                headding3 = "DELAY TAT";
            }
            else if (ReportType == "2")
            {
                sb.Append("  SELECT t.Name AS Department,t.Month, SUM(t.RejectSample)AS 'Val' ,SUM(t.TotalSample)TotalSample,((SUM(t.RejectSample) / SUM(t.TotalSample)) * 100) AS  'Val_Per','<5%' AS limitVal ");
                sb.Append("  FROM ");
                sb.Append("  (SELECT sm.Name, MONTHNAME(pli.date) AS 'Month',0 AS 'RejectSample',SUM(1) AS 'TotalSample',MONTH(pli.date) MonthNumber  ");
                sb.Append("  FROM `patient_labinvestigation_opd` pli  ");
                sb.Append("  INNER JOIN `f_ledgertransaction` lt  ");
                sb.Append("  ON lt.`LedgerTransactionID` = pli.`LedgerTransactionID`  ");

                sb.Append("  INNER JOIN `f_subcategorymaster` sm  ");
                sb.Append("  ON sm.`SubCategoryID` = pli.SubcategoryID  ");
                sb.Append("  AND pli.SubcategoryID = @SubcategoryID  ");
                sb.Append("  AND pli.`Date` >= @fromdate  ");
                sb.Append("  AND pli.`Date` <= @todate  ");
                sb.Append("  GROUP BY MONTH(pli.`Date`) ");

                sb.Append("  UNION ALL  ");

                sb.Append("  SELECT  ");
                sb.Append("  sm.Name,MONTHNAME(pli.`Date`) AS 'Month',COUNT(1) AS 'RejectSample',0 AS 'TotalSample', MONTH(pli.date) MonthNumber  ");
                sb.Append("  FROM ");
                sb.Append("  `patient_sample_rejection` plr  ");
                sb.Append("  INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Test_ID`=plr.`Test_ID` ");
                sb.Append("  INNER JOIN `f_ledgertransaction` lt  ");
                sb.Append("  ON lt.`LedgerTransactionID` = pli.`LedgerTransactionID`  ");


                sb.Append("  INNER JOIN `f_subcategorymaster` sm  ");
                sb.Append("  ON sm.`SubCategoryID` = pli.SubcategoryID   ");
                sb.Append("  AND sm.SubcategoryID =@SubcategoryID  ");
                sb.Append("  AND pli.`Date` >= @fromdate  ");
                sb.Append("  AND pli.`Date` <= @todate  ");
                sb.Append("  GROUP BY MONTH(pli.`Date`)    ");

                sb.Append("  ) t  ");
                sb.Append("  GROUP BY  ");
                sb.Append("  t.Month ORDER BY t.MonthNumber ");
                ReportName = "Quality Indicator -Sample Rejection";
                headding1 = "Total no of Rejection Samples";
                headding2 = "% Rejection";
                headding3 = "REJECTION";
            }
            else if (ReportType == "3")
            {
                sb.Append("  SELECT t.Name AS Department,t.Month, SUM(t.RepetSample)AS 'Val' ,SUM(t.TotalSample)TotalSample,((SUM(t.RepetSample) / SUM(t.TotalSample)) * 100) AS  'Val_Per','<5%' AS limitVal ");
                sb.Append("  FROM ");
                sb.Append("  (SELECT sm.Name, MONTHNAME(pli.date) AS 'Month',0 AS 'RepetSample',SUM(1) AS 'TotalSample',MONTH(pli.date) MonthNumber  ");
                sb.Append("  FROM `patient_labinvestigation_opd` pli  ");
                sb.Append("  INNER JOIN `f_ledgertransaction` lt  ");
                sb.Append("  ON lt.`LedgerTransactionID` = pli.`LedgerTransactionID`  ");

                sb.Append("  INNER JOIN `f_subcategorymaster` sm  ");
                sb.Append("  ON sm.`SubCategoryID` = pli.SubcategoryID  ");
                sb.Append("  AND pli.SubcategoryID = @SubcategoryID  ");
                sb.Append("  AND pli.`Date` >= @fromdate  ");
                sb.Append("  AND pli.`Date` <= @todate  ");
                sb.Append("  GROUP BY MONTH(pli.`Date`) ");

                sb.Append("  UNION ALL  ");
                sb.Append("  SELECT  ");
                sb.Append("  sm.Name,MONTHNAME(pli.`Date`) AS 'Month',COUNT(1) AS 'RepetSample',0 AS 'TotalSample', MONTH(pli.date) MonthNumber  ");
                sb.Append("  FROM ");
                sb.Append("  `patient_labobservation_opd_rerun` plr  ");
                sb.Append("  INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Test_ID`=plr.`Test_ID` ");
                sb.Append("  INNER JOIN `f_ledgertransaction` lt  ");
                sb.Append("  ON lt.`LedgerTransactionID` = pli.`LedgerTransactionID`  ");
                sb.Append("  INNER JOIN `f_subcategorymaster` sm  ");
                sb.Append("  ON sm.`SubCategoryID` = pli.SubcategoryID   ");
                sb.Append("  AND sm.SubcategoryID =@SubcategoryID  ");
                sb.Append("  AND pli.`Date` >= @fromdate ");
                sb.Append("  AND pli.`Date` <= @todate  ");
                sb.Append("  GROUP BY MONTH(pli.`Date`)    ");

                sb.Append("  ) t  ");
                sb.Append("  GROUP BY  ");
                sb.Append("  t.Month ORDER BY t.MonthNumber ");

                ReportName = "Quality Indicator - Sample Repeats";
                headding1 = "Total no of Repeat Samples";
                headding2 = "% Repeat";
                headding3 = "REPEAT";
            }
            else if (ReportType == "4")
            {
                sb.Append("    SELECT t.Name 'Department',t.Month,t.`Centre`,t.RejectionReason, t.RejectSample, t.TotalSample,t.MonthNumber,t.checkReject  ");
                sb.Append("  FROM  ");
                sb.Append("  (SELECT sm.Name,MONTHNAME(pli.date) AS 'Month',cm.Centre,'' RejectionReason,'' AS 'RejectSample',COUNT(1) AS 'TotalSample',MONTH(pli.date) MonthNumber,'0' checkReject   ");
                sb.Append("  FROM `patient_labinvestigation_opd` pli   ");
                sb.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=pli.`CentreID`  ");
                sb.Append("  INNER JOIN `f_subcategorymaster` sm   ");
                sb.Append("  ON sm.`SubCategoryID` = pli.SubcategoryID ");
                sb.Append("  AND pli.SubcategoryID = @SubcategoryID  ");

                sb.Append("  AND pli.`Date` >= @fromdate  ");
                sb.Append("  AND pli.`Date` <= @todate  ");
                sb.Append("  GROUP BY MONTH(pli.`Date`),cm.`CentreID`  ");
                sb.Append("  UNION ALL  ");
                sb.Append("  SELECT   ");
                sb.Append("  sm.Name, MONTHNAME(plr.`EntDate`) AS 'Month',cm.`Centre`,sr.RejectionReason,COUNT(1) AS 'RejectSample',0 AS 'TotalSample',MONTH(plr.`EntDate`) MonthNumber,'1' checkReject   ");
                sb.Append("  FROM  ");
                sb.Append("  `patient_sample_rejection` plr   ");
                sb.Append("  INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Test_ID`=plr.`Test_ID`  ");
                sb.Append("  INNER JOIN samplerejection_master sr ON sr.id=plr.RejectionReason_ID  ");
                sb.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=pli.`CentreID`  ");
                sb.Append("  INNER JOIN `f_subcategorymaster` sm   ");
                sb.Append("  ON sm.`SubCategoryID` = pli.SubcategoryID ");
                sb.Append("  AND pli.SubcategoryID = @SubcategoryID  ");

                sb.Append("  AND plr.`EntDate` >= @fromdate  ");
                sb.Append("  AND plr.`EntDate` <= @todate  ");

                sb.Append("  GROUP BY MONTH(plr.`EntDate`),cm.`CentreID`,sr.id ");
                sb.Append("  ) t  ");
                sb.Append("  ORDER BY  t.MonthNumber,t.`Centre`  ");
            }

            using (dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@fromdate", string.Concat(Year, "-", FromMonth, "-01 00:00:00")),
                           new MySqlParameter("@todate", string.Concat(Year, "-", ToMonth, "-31 23:59:59")),
                           new MySqlParameter("@SubcategoryID", Deparment)).Tables[0])
            {
                if (ReportType == "4")
                {
                    chart_div.Style.Add("display", "none");
                    int TotalGrandRejectCount = 0;
                    int TotalGrandSample = 0;
                    DataTable dtFor1 = new DataTable();
                    DataTable dtResonLength = new DataTable();
                    DataTable dtFor = new DataTable();
                    var rowsCheck = dt.Select("checkReject <> '0'", "MonthNumber ASC");

                    if (rowsCheck.Any())
                    {
                        dtFor1 = dt.Select("checkReject <> '0'", "MonthNumber ASC").CopyToDataTable();
                        dtResonLength = dtFor1.AsEnumerable().GroupBy(r => new { Col1 = r["RejectionReason"] }).Select(g => g.OrderBy(r => r["MonthNumber"]).First()).CopyToDataTable();
                        dtFor = dtFor1.AsEnumerable().GroupBy(r => new { Col1 = r["MonthNumber"], Col2 = r["Centre"] }).Select(g => g.OrderBy(r => r["MonthNumber"]).First()).CopyToDataTable();


                    }

                    StringBuilder sb_ResonTable = new StringBuilder();

                    if (dtFor.Rows.Count > 0)
                    {
                        int colspan = dtResonLength.Rows.Count + 6;
                        div_contain.Style.Add("display", "block");

                        sbdata.Append("  <table style='text-align:center;  width:100%; height:100%; float:right; margin-bottom: 20px; '  > ");
                        sbdata.Append("    <tr > ");
                        sbdata.Append("    <td colspan=" + colspan + " > ");
                        sbdata.Append("   <img style='height:60px; width: 150px; float:left' src='http://localhost" + Resources.Resource.ApplicationName + "/App_Images/MainLogo.jpg' /> ");
                        sbdata.Append("     <br /> ");
                        sbdata.Append("      <br /> ");

                        sbdata.Append("      <b style='font-size:20px'>Quality Indicator - II Sample Reject Criteria</b> ");

                        sbdata.Append("    </td> ");
                        sbdata.Append("    </tr> ");
                        sbdata.Append("   <tr>  <td colspan=" + (dtResonLength.Rows.Count + 1) + " ><b>Department-" + dt.Rows[0]["Department"].ToString() + "</b></td> <td></td> <td></td> <td></td><td></td></tr>");

                        sbdata.Append("   <tr><td colspan=" + (dtResonLength.Rows.Count + 1) + "><b>Period: " + GetMonthName(FromMonth) + "- " + GetMonthName(ToMonth) + "  " + Year + "</b></td><td></td><td></td> <td></td><td></td> </tr> ");
                        sbdata.Append("   <tr> <td class='auto-style1'><b>Month</td> <td class='auto-style1'><b>Branches</b></td> <td class='auto-style1' colspan=" + dtResonLength.Rows.Count + " ><b>Rejection Criteria</b></td>  <td class='auto-style1'><b>Total No of samples Rejected</b></td></td>  <td class='auto-style1'><b>Total No of samples</b></td> <td class='auto-style1'><b>% Rejection</b></td>  </tr> ");


                        string CentreName = "";
                        string MonthName = "";
                        sbdata.Append("   <tr> ");
                        sbdata.Append(" <td> </td>  ");
                        sbdata.Append(" <td> </td>  ");


                        sb_ResonTable.Append("  <table style='text-align:center;  width:30%; height:50%; '  border='1'> ");
                        sb_ResonTable.Append("    <tr > ");
                        sb_ResonTable.Append("    <td ><b>Rejection Criteria</b></td> ");
                        sb_ResonTable.Append("   </tr >  ");
                        for (int k = 0; k < dtResonLength.Rows.Count; k++)
                        {

                            sbdata.Append(" <td>R" + (k + 1) + " </td>  ");

                            sb_ResonTable.Append("    <tr > ");
                            sb_ResonTable.Append("    <td style='text-align: left;' >R" + (k + 1) + " = " + dtResonLength.Rows[k]["RejectionReason"].ToString() + "</td> ");
                            sb_ResonTable.Append("   </tr >  ");


                        }
                        sb_ResonTable.Append("   </table >  ");
                        sbdata.Append(" <td> </td>  ");
                        sbdata.Append(" <td> </td>  ");
                        sbdata.Append(" <td> </td>  ");
                        sbdata.Append("   </tr> ");
                        for (int i = 0; i < dtFor.Rows.Count; i++)
                        {
                            int TotalRejectCount = 0;
                            int nextVal = 0;
                            int j = i + 1;

                            try
                            {
                                while (dtFor.Rows[j]["Month"].ToString() == dtFor.Rows[i]["Month"].ToString() && dtFor.Rows[j]["Centre"].ToString() == dtFor.Rows[i]["Centre"].ToString())
                                {
                                    nextVal += Util.GetInt(dtFor.Rows[j]["RejectSample"].ToString());

                                    j++;

                                }
                            }
                            catch (Exception e)
                            {

                            }
                            sbdata.Append("  <tr> ");
                            if (i == 0)
                            {
                                sbdata.Append(" <td>" + dtFor.Rows[i]["Month"].ToString() + "</td> ");
                            }
                            else
                            {
                                if (dtFor.Rows[i]["Month"].ToString() == dtFor.Rows[i - 1]["Month"].ToString())
                                {
                                    sbdata.Append(" <td></td> ");
                                }
                                else
                                {
                                    sbdata.Append(" <td>" + dtFor.Rows[i]["Month"].ToString() + "</td> ");
                                }

                            }
                            sbdata.Append(" <td>" + dtFor.Rows[i]["Centre"].ToString() + "</td> ");
                            for (int k = 0; k < dtResonLength.Rows.Count; k++)
                            {

                                DataTable dtVal = null;
                                var rows = dtFor1.Select("Month ='" + dtFor.Rows[i]["Month"].ToString() + "'  and  centre='" + dtFor.Rows[i]["centre"].ToString() + "' and  RejectionReason='" + dtResonLength.Rows[k]["RejectionReason"].ToString() + "' ");

                                if (rows.Any())
                                {
                                    dtVal = rows.CopyToDataTable();
                                    sbdata.Append(" <td>" + dtVal.Rows[0]["RejectSample"].ToString() + "</td> ");
                                    TotalRejectCount += Util.GetInt(dtVal.Rows[0]["RejectSample"].ToString());
                                }

                                else
                                {
                                    sbdata.Append(" <td></td> ");
                                }
                            }
                            string totalCount = dt.Select("Month ='" + dtFor.Rows[i]["Month"].ToString() + "' and checkReject='0' and  centre='" + dtFor.Rows[i]["centre"].ToString() + "' ").CopyToDataTable().Rows[0]["TotalSample"].ToString();
                            sbdata.Append("  <td>" + TotalRejectCount.ToString() + "</td> ");
                            sbdata.Append("  <td>" + totalCount + "</td> ");
                            double result = ((double)TotalRejectCount / Util.GetInt(totalCount)) * 100;
                            sbdata.Append("  <td>" + result.ToString("0.##") + "</td> ");
                            CentreName = dtFor.Rows[i]["Centre"].ToString();
                            MonthName = dtFor.Rows[i]["Month"].ToString();
                            sbdata.Append(" </tr> ");

                            TotalGrandRejectCount += TotalRejectCount;
                            TotalGrandSample += Util.GetInt(totalCount);
                            if (i < dtFor.Rows.Count - 1)
                            {
                                if (dtFor.Rows[i]["Month"].ToString() != dtFor.Rows[i + 1]["Month"].ToString())
                                {
                                    sbdata.Append("  <tr> ");
                                    sbdata.Append("  <td style='text-align: left;' colspan=" + (dtResonLength.Rows.Count + 2) + "><b>Grand Total =></b></td> ");
                                    sbdata.Append("  <td ><b>" + TotalGrandRejectCount + "</b></td> ");
                                    sbdata.Append("  <td ><b>" + TotalGrandSample + "</b></td> ");
                                    double resultTotal = ((double)TotalGrandRejectCount / TotalGrandSample) * 100;
                                    sbdata.Append("  <td ><b>" + resultTotal.ToString("0.##") + "</b></td> ");
                                    sbdata.Append("  </tr> ");
                                    TotalGrandRejectCount = 0;
                                    TotalGrandSample = 0;
                                }
                            }
                            else
                            {
                                sbdata.Append("  <tr> ");
                                sbdata.Append("  <td style='text-align: left;' colspan=" + (dtResonLength.Rows.Count + 2) + "><b>Grand Total =></b></td> ");
                                sbdata.Append("  <td ><b>" + TotalGrandRejectCount + "</b></td> ");
                                sbdata.Append("  <td ><b>" + TotalGrandSample + "</b></td> ");
                                double resultTotal = ((double)TotalGrandRejectCount / TotalGrandSample) * 100;
                                sbdata.Append("  <td ><b>" + resultTotal.ToString("0.##") + "</b></td> ");
                                sbdata.Append("  </tr> ");
                                // TotalGrandRejectCount = 0;
                            }
                        }
                        sbdata.Append(" </table> ");
                        jsonstring = Newtonsoft.Json.JsonConvert.SerializeObject(dtFor);
                    }
                    else
                    {
                        div_contain.Style.Add("display", "none");
                    }
                    divData.InnerHtml = sbdata.ToString() + "<br/><br/><br/>" + sb_ResonTable.ToString();
                }
                else
                {
                    if (dt.Rows.Count > 0)
                    {
                        chart_div.Style.Add("display", "block");
                        div_contain.Style.Add("display", "block");
                        sbdata.Append("  <table style='text-align:center;  width:100%; height:100%; '  > ");
                        sbdata.Append("    <tr > ");
                        sbdata.Append("    <td colspan='5' > ");
                        sbdata.Append("   <img style='height:60px; width: 150px; float:left' src='http://localhost" + Resources.Resource.ApplicationName + "/App_Images/MainLogo.jpg' /> ");
                        sbdata.Append("     <br /> ");
                        sbdata.Append("      <br /> ");
                        sbdata.Append("      <b style='font-size:20px'>" + ReportName + "</b> ");
                        sbdata.Append("    </td> ");
                        sbdata.Append("    </tr> ");
                        sbdata.Append("   <tr>  <td colspan='2' ><b>Department-" + dt.Rows[0]["Department"].ToString() + "</b></td> <td></td> <td></td> <td></td></tr>");
                        sbdata.Append("   <tr><td colspan='2'><b>Period: " + GetMonthName(FromMonth) + "- " + GetMonthName(ToMonth) + "  " + Year + "</b></td><td></td><td></td> <td></td> </tr> ");
                        sbdata.Append("   <tr> <td class='auto-style1'><b>Month</td> <td class='auto-style1'><b>" + headding1 + "</b></td> <td class='auto-style1'><b>" + headding2 + "</b></td>  <td class='auto-style1'><b>Total no of samples</b></td> <td class='auto-style1'><b>Acceptable Limit</b></td> </tr> ");
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            sbdata.Append("  <tr> ");
                            sbdata.Append(" <td>" + dt.Rows[i]["Month"].ToString() + "</td> ");
                            sbdata.Append(" <td>" + dt.Rows[i]["Val"].ToString() + "</td> ");
                            sbdata.Append(" <td>" + dt.Rows[i]["Val_Per"].ToString() + "</td> ");
                            sbdata.Append(" <td>" + dt.Rows[i]["TotalSample"].ToString() + "</td> ");
                            sbdata.Append("  <td>" + dt.Rows[i]["limitVal"].ToString() + "</td> ");
                            sbdata.Append(" </tr> ");
                        }
                        sbdata.Append(" </table> ");
                        jsonstring = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                    }
                    else
                    {
                        div_contain.Style.Add("display", "none");
                    }
                    divData.InnerHtml = sbdata.ToString();
                }
            }
        }
        catch (Exception ex)
        {
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

   
       // ScriptManager.RegisterStartupScript(this,GetType(),"",
    }
    public string GetMonthName(string monthNum)
    {
        string MonthName = "";
        switch (monthNum)
        {
            case "1":
                MonthName = "Jan";
                break;
            case "2":
                MonthName = "Feb";
                break;
            case "3":
                MonthName = "Mar";
                break;
            case "4":
                MonthName = "Apr";
                break;
            case "5":
                MonthName = "May";
                break;
            case "6":
                MonthName = "June";
                break;
            case "7":
                MonthName = "July";
                break;
            case "8":
                MonthName = "Aug";
                break;
            case "9":
                MonthName = "Sept";
                break;
            case "10":
                MonthName = "Oct";
                break;
            case "11":
                MonthName = "Nov";
                break;
            case "12":
                MonthName = "Dec";
                break;
           
        }
        return MonthName;
    }
}
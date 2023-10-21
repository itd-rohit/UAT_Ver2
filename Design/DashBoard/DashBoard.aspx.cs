using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_DashBoard_DashBoard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            bindTagBusinessLab();
        }
    }
    public void bindTagBusinessLab()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT TagBusinessLabID,TagBusinessLab FROM f_panel_master WHERE PanelType='Centre' GROUP BY TagBusinessLabID ").Tables[0])
            {
                lstCentreList.DataSource = dt;
                lstCentreList.DataTextField = "TagBusinessLab";
                lstCentreList.DataValueField = "TagBusinessLabID";
                lstCentreList.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }
    [WebMethod]
    public static string GetLocationWiseReport(DateTime fromDate, DateTime toDate, string TagBusinessLabID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ");
            sb.Append(" TagBusinessLabID,TagBusinessUnit,SUM(GrossSales)GrossSales,SUM(Disc)Disc,SUM(NetSales)NetSales,");
            sb.Append(" COUNT(DISTINCT `LedgerTransactionID`) Pt_Count, ");
            sb.Append(" COUNT(DISTINCT `LedgerTransactionID`,ItemID)TestCount,");          
            sb.Append(" SUM(TotalReceivedAmount)TotalReceivedAmount,SUM(TotalRefundAmount) RefundAmt,0 IsTotal  ");
            sb.Append(" FROM ( ");

            sb.Append(" SELECT pnl.TagBusinessLabID,cm.`Centre` TagBusinessUnit,(plo.rate * plo.`Quantity`) GrossSales, ");
            sb.Append(" plo.`DiscountAmt` Disc,plo.`Amount` NetSales, lt.`LedgerTransactionID`, IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`, ");
            sb.Append(" plo.`Quantity`,0 TotalReceivedAmount,0 TotalRefundAmount,plo.Investigation_ID,plo.ItemID");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=pnl.`TagBusinessLabID` ");
            sb.Append(" WHERE plo.`Date`>=@fromDate AND plo.`Date`<=@toDate ");
            sb.Append(" AND pnl.IsPermanentClose=0");
            if (TagBusinessLabID != string.Empty)
                sb.Append(" AND pnl.`TagBusinessLabID` IN (" + TagBusinessLabID + ")");

            sb.Append(" UNION ALL  ");

            sb.Append(" SELECT pnl.TagBusinessLabID,cm.`Centre` TagBusinessUnit,0 GrossSales, ");
            sb.Append(" 0 Disc,0 NetSales, NULL `LedgerTransactionID`, NULL `SampleTypeID`, ");
            sb.Append(" NULL `Quantity`,IF(r.`Amount`>0,r.`Amount`,0) TotalReceivedAmount,0 TotalRefundAmount,NULL Investigation_ID,NULL ItemID ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN `f_receipt` r ON r.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
            sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=pnl.`TagBusinessLabID` ");
            sb.Append(" WHERE r.`IsCancel`=0  ");
            sb.Append(" AND r.`createdDate`>=@fromDate ");
            sb.Append(" AND r.`createdDate`<=@toDate ");
            sb.Append(" AND pnl.IsPermanentClose=0");
            if (TagBusinessLabID != string.Empty)
                sb.Append(" AND pnl.`TagBusinessLabID` IN (" + TagBusinessLabID + ")");

            sb.Append(" UNION ALL  ");

            sb.Append(" SELECT pnl.TagBusinessLabID,cm.`Centre` TagBusinessUnit,0 GrossSales, ");
            sb.Append(" 0 Disc,0 NetSales, NULL `LedgerTransactionID`, NULL `SampleTypeID`, ");
            sb.Append(" NULL `Quantity`,0 TotalReceivedAmount,IF(r.`Amount`<0,r.`Amount`,0) TotalRefundAmount,NULL Investigation_ID,NULL ItemID ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN `f_receipt` r ON r.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
            sb.Append(" INNER JOIN centre_master cm2 ON cm2.`CentreID`=lt.CentreID   AND cm2.`type1` != 'CC'  ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=pnl.`TagBusinessLabID` ");
            sb.Append(" WHERE r.`IsCancel`=0  ");
            sb.Append(" AND r.`createdDate`>=@fromDate ");
            sb.Append(" AND r.`createdDate`<=@toDate ");
            sb.Append(" AND pnl.IsPermanentClose=0");
            if (TagBusinessLabID != string.Empty)
                sb.Append(" AND pnl.`TagBusinessLabID` IN (" + TagBusinessLabID + ")");

            sb.Append("   UNION ALL  ");

            sb.Append(" SELECT pnl.TagBusinessLabID,cm.`Centre` TagBusinessUnit,0 GrossSales,");
            sb.Append(" 0 Disc,0 NetSales, NULL `LedgerTransactionID`, NULL `SampleTypeID`, ");
            sb.Append(" NULL `Quantity`, io.`ReceivedAmt` TotalReceivedAmount,0 TotalRefundAmount,NULL Investigation_ID,NULL ItemID ");
            sb.Append(" FROM `invoicemaster_onaccount` io  ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=io.`Panel_ID` ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=pnl.`TagBusinessLabID` ");
            sb.Append(" WHERE io.`IsCancel`=0  ");
            sb.Append(" AND io.`CreditNote`=0 ");
            sb.Append(" AND io.`ReceivedDate`>=@fromDate  ");
            sb.Append(" AND io.`ReceivedDate`<=@toDate ");
            if (TagBusinessLabID != string.Empty)
                sb.Append(" AND pnl.`TagBusinessLabID` IN (" + TagBusinessLabID + ")");
            sb.Append("  ) aa ");
            sb.Append("  GROUP BY TagBusinessLabID ");
            sb.Append("  ORDER BY TagBusinessUnit ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                              new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    int Pt_Count = Util.GetInt(dt.AsEnumerable().Select(tr => tr.Field<Int64>("Pt_Count")).Cast<Int64?>().Sum());
                    int TestCount = Util.GetInt(dt.AsEnumerable().Select(tr => tr.Field<Int64>("TestCount")).Cast<Int64?>().Sum());

                    DataRow row = dt.NewRow();
                    row["TagBusinessLabID"] = 0;
                    row["TagBusinessUnit"] = "Total :";
                    row["GrossSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("GrossSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["Disc"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("Disc")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["NetSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("NetSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["TestCount"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<Int64>("TestCount")).Cast<Int64?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["Pt_Count"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<Int64>("Pt_Count")).Cast<Int64?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["TotalReceivedAmount"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("TotalReceivedAmount")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["RefundAmt"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("RefundAmt")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["IsTotal"] = 1;
                    dt.Rows.Add(row);
                    dt.AcceptChanges();
                    return JsonConvert.SerializeObject(new { status = true, response = Util.getJson(dt), PtCount = string.Concat(Pt_Count, Environment.NewLine, "Orders"), TestCount = string.Concat(TestCount, Environment.NewLine, " Samples") });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }
    [WebMethod]
    public static string GetReport(DateTime fromDate, DateTime toDate, string TagBusinessLabID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ");
            sb.Append(" TagBusinessLabID,TagBusinessUnit,SubCategoryID,SubCategoryName, SUM(GrossSales)GrossSales,SUM(Disc)Disc,SUM(NetSales)NetSales, ");
            sb.Append(" COUNT(DISTINCT `LedgerTransactionID`,ItemID)TestCount ");
            sb.Append(" FROM ( ");
            sb.Append(" SELECT pnl.TagBusinessLabID,cm.`Centre` TagBusinessUnit,(plo.rate * plo.`Quantity`)GrossSales, ");
            sb.Append(" plo.`DiscountAmt` Disc,plo.`Amount` NetSales,lt.`LedgerTransactionID`,IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`, ");
            sb.Append(" plo.`Quantity`,0 TotalReceivedAmount,plo.SubCategoryID,plo.SubCategoryName,plo.Investigation_ID,plo.ItemID ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=pnl.`TagBusinessLabID` ");
            sb.Append(" WHERE plo.`Date`>=@fromDate AND plo.`Date`<=@toDate   ");
            sb.Append(" AND pnl.IsPermanentClose=0 AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
            if (TagBusinessLabID != string.Empty)
                sb.Append(" AND pnl.`TagBusinessLabID` IN (" + TagBusinessLabID + ")");

            sb.Append("  ) aa ");
            sb.Append("  GROUP BY TagBusinessLabID,SubCategoryID ");
            sb.Append("  ORDER BY TagBusinessUnit,SubCategoryName ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                              new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    DataTable dtMerge = new DataTable();
                    dtMerge.Columns.Add("TagBusinessLabID");
                    dtMerge.Columns.Add("SubCategoryID");
                    dtMerge.Columns.Add("SubCategoryName");
                    dtMerge.Columns.Add("GrossSales");
                    dtMerge.Columns.Add("Disc");
                    dtMerge.Columns.Add("NetSales");
                    dtMerge.Columns.Add("TestCount");
                    dtMerge.Columns.Add("IsTagLab");
                    dtMerge.Columns.Add("IsTotal");
                    using (DataTable groupTagBusinessLabID = dt.AsEnumerable()
                            .GroupBy(r1 => new
                            {
                                TagBusinessLabID = r1.Field<int>("TagBusinessLabID")
                            }).Select(r1 => r1.First()).CopyToDataTable())
                    {
                        for (int i = 0; i < groupTagBusinessLabID.Rows.Count; i++)
                        {
                            DataRow NewMerge1 = dtMerge.NewRow();
                            NewMerge1["TagBusinessLabID"] = groupTagBusinessLabID.Rows[i]["TagBusinessLabID"].ToString();
                            NewMerge1["SubCategoryID"] = groupTagBusinessLabID.Rows[i]["TagBusinessLabID"].ToString();
                            NewMerge1["SubCategoryName"] = groupTagBusinessLabID.Rows[i]["TagBusinessUnit"].ToString();
                            NewMerge1["IsTagLab"] = 1;
                            NewMerge1["GrossSales"] = "";
                            NewMerge1["Disc"] = "";
                            NewMerge1["NetSales"] = "";
                            NewMerge1["TestCount"] = "";
                            NewMerge1["IsTotal"] = 0;
                            dtMerge.Rows.Add(NewMerge1);
                            using (DataTable dtSubCategoryID = dt.AsEnumerable().Where(e => e.Field<Int32>("TagBusinessLabID") == Util.GetInt(groupTagBusinessLabID.Rows[i]["TagBusinessLabID"].ToString())).CopyToDataTable())
                            {
                                for (int s = 0; s < dtSubCategoryID.Rows.Count; s++)
                                {
                                    DataRow NewMerge = dtMerge.NewRow();
                                    NewMerge["TagBusinessLabID"] = dtSubCategoryID.Rows[s]["TagBusinessLabID"].ToString();
                                    NewMerge["SubCategoryID"] = dtSubCategoryID.Rows[s]["SubCategoryID"].ToString();
                                    NewMerge["SubCategoryName"] = dtSubCategoryID.Rows[s]["SubCategoryName"].ToString();
                                    NewMerge["IsTagLab"] = 0;
                                    NewMerge["GrossSales"] = Math.Round(Util.GetDecimal(dtSubCategoryID.Rows[s]["GrossSales"].ToString()), 2, MidpointRounding.AwayFromZero);
                                    NewMerge["Disc"] = Math.Round(Util.GetDecimal(dtSubCategoryID.Rows[s]["Disc"].ToString()), 2, MidpointRounding.AwayFromZero);
                                    NewMerge["NetSales"] = Math.Round(Util.GetDecimal(dtSubCategoryID.Rows[s]["NetSales"].ToString()), 2, MidpointRounding.AwayFromZero);
                                    NewMerge["TestCount"] = dtSubCategoryID.Rows[s]["TestCount"].ToString();
                                    NewMerge["IsTotal"] = 0;
                                    dtMerge.Rows.Add(NewMerge);
                                    if (s == dtSubCategoryID.Rows.Count - 1)
                                    {
                                        NewMerge = dtMerge.NewRow();
                                        NewMerge["TagBusinessLabID"] = "";
                                        NewMerge["SubCategoryID"] = "";
                                        NewMerge["SubCategoryName"] = "Total :";
                                        NewMerge["IsTagLab"] = 0;
                                        NewMerge["GrossSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(a => a.Field<Int32>("TagBusinessLabID") == Util.GetInt(dtSubCategoryID.Rows[s]["TagBusinessLabID"].ToString())).Select(tr => tr.Field<decimal>("GrossSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                                        NewMerge["Disc"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(a => a.Field<Int32>("TagBusinessLabID") == Util.GetInt(dtSubCategoryID.Rows[s]["TagBusinessLabID"].ToString())).Select(tr => tr.Field<decimal>("Disc")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                                        NewMerge["NetSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(a => a.Field<Int32>("TagBusinessLabID") == Util.GetInt(dtSubCategoryID.Rows[s]["TagBusinessLabID"].ToString())).Select(tr => tr.Field<decimal>("NetSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                                        NewMerge["TestCount"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Where(a => a.Field<Int32>("TagBusinessLabID") == Util.GetInt(dtSubCategoryID.Rows[s]["TagBusinessLabID"].ToString())).Select(tr => tr.Field<Int64>("TestCount")).Cast<Int64?>().Sum()), 2, MidpointRounding.AwayFromZero);
                                        NewMerge["IsTotal"] = 1;
                                        dtMerge.Rows.Add(NewMerge);
                                    }
                                }
                            }
                        }
                    }
                    DataRow NewMerge2 = dtMerge.NewRow();
                    NewMerge2["TagBusinessLabID"] = "";
                    NewMerge2["SubCategoryID"] = "";
                    NewMerge2["SubCategoryName"] = "Grand Total :";
                    NewMerge2["IsTagLab"] = 0;
                    NewMerge2["GrossSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("GrossSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    NewMerge2["Disc"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("Disc")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    NewMerge2["NetSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("NetSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    NewMerge2["TestCount"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<Int64>("TestCount")).Cast<Int64?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    NewMerge2["IsTotal"] = 2;
                    dtMerge.Rows.Add(NewMerge2);
                    return JsonConvert.SerializeObject(new { status = true, response = Util.getJson(dtMerge) });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response="No Record Found" });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }
    [WebMethod]
    public static string ServiceGroup(DateTime fromDate, DateTime toDate, string TagBusinessLabID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ");
            sb.Append(" SubCategoryID,SubCategoryName, SUM(GrossSales)GrossSales,SUM(Disc)Disc,SUM(NetSales)NetSales,");
            sb.Append(" COUNT(DISTINCT `LedgerTransactionID`,ItemID)TestCount,0 IsTotal ");
            sb.Append(" FROM ( ");
            sb.Append(" SELECT (plo.rate * plo.`Quantity`)GrossSales, ");
            sb.Append(" plo.`DiscountAmt` Disc,plo.`Amount` NetSales,lt.`LedgerTransactionID`, ");
            sb.Append(" plo.`Quantity`,plo.SubCategoryID,plo.SubCategoryName,plo.Investigation_ID,plo.ItemID ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
            sb.Append(" WHERE plo.`Date`>=@fromDate AND plo.`Date`<=@toDate  AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
            sb.Append(" AND pnl.IsPermanentClose=0");
            if (TagBusinessLabID != string.Empty)
                sb.Append(" AND pnl.`TagBusinessLabID` IN (" + TagBusinessLabID + ")");

            sb.Append("  ) aa ");
            sb.Append("  GROUP BY SubCategoryID ");
            sb.Append("  ORDER BY SubCategoryName ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                              new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.NewRow();
                    row["SubCategoryID"] = 0;
                    row["SubCategoryName"] = "Total :";
                    row["GrossSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("GrossSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["Disc"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("Disc")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["NetSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("NetSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["TestCount"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<Int64>("TestCount")).Cast<Int64?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["IsTotal"] = 1;
                    dt.Rows.Add(row);
                    dt.AcceptChanges();
                    return JsonConvert.SerializeObject(new { status = true, response = Util.getJson(dt) });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }
    [WebMethod]
    public static string GetClientWiseReport(DateTime fromDate, DateTime toDate, string TagBusinessLabID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ");
            sb.Append(" Panel_ID,ClientName, SUM(GrossSales)GrossSales,SUM(Disc)Disc, SUM(NetSales)NetSales, ");
            sb.Append(" COUNT(DISTINCT `LedgerTransactionID`,ItemID)TestCount,SUM(TotalReceivedAmount)TotalReceivedAmount,0 IsTotal ");
            sb.Append(" FROM ( ");
            sb.Append(" SELECT pnl.Panel_ID,pnl.`Company_Name` ClientName,(plo.rate * plo.`Quantity`) GrossSales, ");
            sb.Append(" plo.`DiscountAmt` Disc,plo.`Amount` NetSales, lt.`LedgerTransactionID`, IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`, ");
            sb.Append(" plo.`Quantity`,0 TotalReceivedAmount,plo.Investigation_ID,plo.ItemID");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
            sb.Append(" WHERE plo.`Date`>=@fromDate AND plo.`Date`<=@toDate  ");
            sb.Append(" AND pnl.IsPermanentClose=0");
            if (TagBusinessLabID != string.Empty)
                sb.Append(" AND pnl.`TagBusinessLabID` IN (" + TagBusinessLabID + ")");

            sb.Append(" UNION ALL  ");

            sb.Append(" SELECT pnl.Panel_ID,pnl.`Company_Name` ClientName,0 GrossSales, ");
            sb.Append(" 0 Disc,0 NetSales, NULL `LedgerTransactionID`, NULL `SampleTypeID`, ");
            sb.Append(" NULL `Quantity`,r.`Amount` TotalReceivedAmount,NULL Investigation_ID,NULL ItemID ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN `f_receipt` r ON r.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
            sb.Append(" WHERE r.`IsCancel`=0  ");
            sb.Append(" AND r.`createdDate`>=@fromDate ");
            sb.Append(" AND r.`createdDate`<=@toDate ");
            sb.Append(" AND pnl.IsPermanentClose=0");
            if (TagBusinessLabID != string.Empty)
                sb.Append(" AND pnl.`TagBusinessLabID` IN (" + TagBusinessLabID + ")");

            sb.Append("   UNION ALL  ");

            sb.Append(" SELECT pnl.Panel_ID,pnl.`Company_Name` ClientName,0 GrossSales,");
            sb.Append(" 0 Disc,0 NetSales, NULL `LedgerTransactionID`, NULL `SampleTypeID`, ");
            sb.Append(" NULL `Quantity`, io.`ReceivedAmt` TotalReceivedAmount,NULL Investigation_ID,NULL ItemID ");
            sb.Append(" FROM `invoicemaster_onaccount` io  ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=io.`Panel_ID` ");
            sb.Append(" WHERE io.`IsCancel`=0  ");
            sb.Append(" AND io.`CreditNote`=0 ");
            sb.Append(" AND io.`ReceivedDate`>=@fromDate  ");
            sb.Append(" AND io.`ReceivedDate`<=@toDate ");
            if (TagBusinessLabID != string.Empty)
                sb.Append(" AND pnl.`TagBusinessLabID` IN (" + TagBusinessLabID + ")");

            sb.Append("  ) aa ");
            sb.Append("  GROUP BY Panel_ID ");
            sb.Append("  ORDER BY ClientName ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                              new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.NewRow();
                    row["Panel_ID"] = 0;
                    row["ClientName"] = "Total :";
                    row["GrossSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("GrossSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["Disc"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("Disc")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["NetSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("NetSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["TestCount"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<Int64>("TestCount")).Cast<Int64?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["TotalReceivedAmount"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("TotalReceivedAmount")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);

                    row["IsTotal"] = 1;
                    dt.Rows.Add(row);
                    dt.AcceptChanges();
                    return JsonConvert.SerializeObject(new { status = true, response = Util.getJson(dt) });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }
    [WebMethod]
    public static string getTagBusinessLabDepartmentDetail(DateTime fromDate, DateTime toDate, string SubCategoryID, string TagBusinessLabID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ");
            sb.Append(" TagBusinessUnit,SubCategoryName,SUM(GrossSales)GrossSales,SUM(Disc)Disc, SUM(NetSales)NetSales, ");
            sb.Append(" COUNT(DISTINCT `LedgerTransactionID`,ItemID)TestCount,ItemName,0 IsTotal ");
            sb.Append(" FROM ( ");

            sb.Append(" SELECT pnl.TagBusinessLabID,cm.`Centre` TagBusinessUnit,(plo.rate * plo.`Quantity`) GrossSales, ");
            sb.Append(" plo.`DiscountAmt` Disc,plo.`Amount` NetSales,lt.`LedgerTransactionID`,");
            sb.Append(" plo.`Quantity`,plo.SubCategoryID,plo.SubCategoryName,plo.ItemName,plo.ItemID,plo.Investigation_ID ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=pnl.`TagBusinessLabID` ");
            sb.Append(" WHERE plo.`Date`>=@fromDate AND plo.`Date`<=@toDate ");
            sb.Append(" AND plo.`SubCategoryID`=@SubCategoryID AND pnl.`TagBusinessLabID`=@TagBusinessLabID");
            sb.Append(" AND pnl.IsPermanentClose=0");
            sb.Append("  ) aa GROUP BY ItemID ");
            sb.Append("  ORDER BY ItemName ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@SubCategoryID", SubCategoryID),
                                              new MySqlParameter("@TagBusinessLabID", TagBusinessLabID),
                                              new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                              new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.NewRow();
                    row["TagBusinessUnit"] = "";
                    row["SubCategoryName"] = "";
                    row["GrossSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("GrossSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["Disc"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("Disc")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["NetSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("NetSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["TestCount"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<Int64>("TestCount")).Cast<Int64?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["ItemName"] = "Total :";
                    row["IsTotal"] = 1;
                    dt.Rows.Add(row);
                    dt.AcceptChanges();
                    return JsonConvert.SerializeObject(new { status = true, response = Util.getJson(dt) });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }
    [WebMethod]
    public static string getClientDetailReport(DateTime fromDate, DateTime toDate, string Panel_ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ");
            sb.Append(" SUM(GrossSales)GrossSales,SUM(Disc)Disc, SUM(NetSales)NetSales,COUNT(DISTINCT `LedgerTransactionID`,ItemID)TestCount,ItemName,ItemID,0 IsTotal ");
            sb.Append(" FROM ( ");

            sb.Append(" SELECT (plo.rate * plo.`Quantity`) GrossSales, ");
            sb.Append(" plo.`DiscountAmt` Disc,plo.`Amount` NetSales, lt.`LedgerTransactionID`, IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`, ");
            sb.Append(" plo.`Quantity`,plo.ItemName,plo.ItemID,plo.Investigation_ID");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
            sb.Append(" WHERE plo.`Date`>=@fromDate AND plo.`Date`<=@toDate ");
            sb.Append(" AND pnl.`Panel_ID`=@Panel_ID ");
            sb.Append(" AND pnl.IsPermanentClose=0");

            sb.Append("  ) aa ");
            sb.Append("  GROUP BY ItemID ");
            sb.Append("  ORDER BY ItemName ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@Panel_ID", Panel_ID),
                                              new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                              new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.NewRow();

                    row["GrossSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("GrossSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["Disc"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("Disc")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["NetSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("NetSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["TestCount"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<Int64>("TestCount")).Cast<Int64?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["ItemName"] = "Total :";
                    row["IsTotal"] = 1;
                    row["ItemID"] = 0;
                    dt.Rows.Add(row);
                    dt.AcceptChanges();
                    return JsonConvert.SerializeObject(new { status = true, response = Util.getJson(dt) });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }
    [WebMethod]
    public static string getServiceGroupDetail(DateTime fromDate, DateTime toDate, string SubCategoryID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ");
            sb.Append(" SUM(GrossSales)GrossSales,SUM(Disc)Disc, SUM(NetSales)NetSales,COUNT(DISTINCT `LedgerTransactionID`,ItemID)TestCount,ItemName,0 IsTotal ");
            sb.Append(" FROM ( ");

            sb.Append(" SELECT (plo.rate * plo.`Quantity`) GrossSales, ");
            sb.Append(" plo.`DiscountAmt` Disc,plo.`Amount` NetSales, lt.`LedgerTransactionID`, IF(plo.reportType=5,plo.Test_ID, plo.`SampleTypeID`)`SampleTypeID`, ");
            sb.Append(" plo.`Quantity`,0 TotalReceivedAmount,plo.SubCategoryID,plo.SubCategoryName,plo.ItemName,plo.ItemID,plo.Investigation_ID ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
            sb.Append(" WHERE plo.`Date`>=@fromDate AND plo.`Date`<=@toDate ");
            sb.Append(" AND plo.`SubCategoryID`=@SubCategoryID ");
            sb.Append(" AND pnl.IsPermanentClose=0 AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)");
            sb.Append("  ) aa GROUP BY ItemID ");
            sb.Append("  ORDER BY ItemName ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@SubCategoryID", SubCategoryID),
                                              new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                              new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.NewRow();
                    row["GrossSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("GrossSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["Disc"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("Disc")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["NetSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("NetSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["TestCount"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<Int64>("TestCount")).Cast<Int64?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["ItemName"] = "Total :";
                    row["IsTotal"] = 1;
                    dt.Rows.Add(row);
                    dt.AcceptChanges();
                    return JsonConvert.SerializeObject(new { status = true, response = Util.getJson(dt) });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }
    [WebMethod]
    public static string GetLocationWiseClientDetail(DateTime fromDate, DateTime toDate, string TagBusinessLabID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ");
            sb.Append(" ClientName, SUM(GrossSales)GrossSales,SUM(Disc)Disc, SUM(NetSales)NetSales,COUNT(DISTINCT `LedgerTransactionID`,ItemID)TestCount,0 IsTotal  ");
            sb.Append(" FROM ( ");
            sb.Append(" SELECT pnl.Panel_ID,pnl.`Company_Name` ClientName,(plo.rate * plo.`Quantity`) GrossSales, ");
            sb.Append(" plo.`DiscountAmt` Disc,plo.`Amount` NetSales, lt.`LedgerTransactionID`, ");
            sb.Append(" plo.`Quantity`,0 TotalReceivedAmount,plo.ItemID");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
            sb.Append(" WHERE plo.`Date`>=@fromDate AND plo.`Date`<=@toDate  ");
            sb.Append(" AND pnl.`TagBusinessLabID`=@TagBusinessLabID");
            sb.Append(" AND pnl.IsPermanentClose=0");
            sb.Append("  ) aa ");
            sb.Append("  GROUP BY Panel_ID ");
            sb.Append("  ORDER BY ClientName ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@TagBusinessLabID", TagBusinessLabID),
                                              new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                              new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.NewRow();

                    row["GrossSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("GrossSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["Disc"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("Disc")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["NetSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("NetSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["TestCount"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<Int64>("TestCount")).Cast<Int64?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["ClientName"] = "Total :";
                    row["IsTotal"] = 1;
                    dt.Rows.Add(row);
                    dt.AcceptChanges();
                    return JsonConvert.SerializeObject(new { status = true, response = Util.getJson(dt) });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }
    [WebMethod]
    public static string GetLocationWiseDetailDepartment(DateTime fromDate, DateTime toDate, string TagBusinessLabID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ");
            sb.Append(" SubCategoryName,SubCategoryID, SUM(GrossSales)GrossSales,SUM(Disc)Disc, SUM(NetSales)NetSales,COUNT(DISTINCT `LedgerTransactionID`,ItemID)TestCount,0 IsTotal  ");
            sb.Append(" FROM ( ");

            sb.Append(" SELECT (plo.rate * plo.`Quantity`) GrossSales, ");
            sb.Append(" plo.`DiscountAmt` Disc,plo.`Amount` NetSales, lt.`LedgerTransactionID`,");
            sb.Append(" plo.`Quantity`,plo.SubCategoryID,plo.SubCategoryName,plo.ItemID ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
            sb.Append(" WHERE plo.`Date`>=@fromDate AND plo.`Date`<=@toDate AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
            sb.Append(" AND pnl.`TagBusinessLabID`=@TagBusinessLabID");
            sb.Append(" AND pnl.IsPermanentClose=0 AND plo.`Date`>=@fromDate AND plo.`Date`<=@toDate");

            sb.Append("  ) aa ");
            sb.Append("  GROUP BY SubCategoryID ");
            sb.Append("  ORDER BY SubCategoryName ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@TagBusinessLabID", TagBusinessLabID),
                                              new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                              new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.NewRow();
                    row["GrossSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("GrossSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["Disc"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("Disc")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["NetSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("NetSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["TestCount"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<Int64>("TestCount")).Cast<Int64?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["SubCategoryName"] = "Total :";
                    row["IsTotal"] = 1;
                    dt.Rows.Add(row);
                    dt.AcceptChanges();
                    return JsonConvert.SerializeObject(new { status = true, response = Util.getJson(dt) });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }
    [WebMethod]
    public static string GetClientPatientDetail(DateTime fromDate, DateTime toDate, string Panel_ID,string ItemID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT (plo.rate * plo.`Quantity`) GrossSales,plo.`DiscountAmt` Disc,plo.`Amount` NetSales,lt.`LedgerTransactionNo` LabNo, ");
            sb.Append(" plo.ItemName,plo.BillNo,lt.PName,0 IsTotal,DATE_FORMAT(plo.Date,'%d-%b-%Y %I:%i %p')BillDate,LEFT(plo.Gender,1)Gender");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=lt.`InvoiceToPanelID` ");
            sb.Append(" WHERE IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)  ");
            sb.Append(" AND plo.`Date`>=@fromDate AND plo.`Date`<=@toDate ");
            sb.Append(" AND pnl.`Panel_ID`=@Panel_ID AND plo.ItemID=@ItemID");
            sb.Append(" AND pnl.IsPermanentClose=0");
            sb.Append("  ORDER BY plo.ItemName ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@Panel_ID", Panel_ID),
                                              new MySqlParameter("@ItemID", ItemID),
                                              new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                              new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.NewRow();
                    row["GrossSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("GrossSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["Disc"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("Disc")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["NetSales"] = Math.Round(Util.GetDecimal(dt.AsEnumerable().Select(tr => tr.Field<decimal>("NetSales")).Cast<decimal?>().Sum()), 2, MidpointRounding.AwayFromZero);
                    row["LabNo"] = "";
                    row["ItemName"] = "";
                    row["BillNo"] = "";
                    row["BillDate"] = "";
                    row["Gender"] = "";
                    row["PName"] = "Total :";
                    row["IsTotal"] = 1;
                    dt.Rows.Add(row);
                    dt.AcceptChanges();
                    return JsonConvert.SerializeObject(new { status = true, response = Util.getJson(dt) });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }
}
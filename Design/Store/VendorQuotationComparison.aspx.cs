using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_VendorQuotationComparison : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");



        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindState()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ID,State FROM state_master WHERE IsActive=1 ORDER BY State"));

    }
    [WebMethod(EnableSession = true)]
    public static string bindCentre(string StateID)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.Panel_ID CentreID,pm.company_name Centre FROM f_panel_master  pm");
        sb.Append("  INNER JOIN centre_master cm on cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' then pm.`CentreID` else pm.tagprocessinglabid END AND pm.`PanelType` in('Centre','PUP')   WHERE pm.IsActive=1 ");


        if (StateID != "")
            sb.Append(" AND cm.StateID IN(" + StateID + ")");



        sb.Append(" ORDER BY Centre");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));





    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetExcelDate(string location)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("    SELECT   ");
        sb.Append("   VendorName SupplierName,vendoraddress SupplierAddress,VednorStateName SupplierState ,DeliveryLocationName,DeliveryStateName ");
        sb.Append("      ,ItemCategoryName,st.itemid,st.typename ItemName,st.HSNCode,sv.ManufactureName,sv.MachineName,PurchasedUnit,Rate,DiscountPer,DiscountAmt,  ");
        sb.Append("      IGSTPer,SGSTPer,CGSTPer,GSTAmount TaxAmount,BuyPrice,FinalPrice  ");
        sb.Append("  , DATE_FORMAT(sv.CreaterDateTime,'%d-%b-%y %h:%i %p')MakeDateTime,e_Update.`Name` MakeBy,e_checked.`Name` 'ValidatedBy' ,DATE_FORMAT(sv.checkeddate,'%d-%b-%y %h:%i %p')Validateddate,  ");

        sb.Append("  e_Approved.`Name` ApprovedBy, DATE_FORMAT(sv.ApprovedDate,'%d-%b-%y %h:%i %p')ApprovedDate  ");

        sb.Append("      FROM st_vendorqutation sv ");
        sb.Append("      LEFT JOIN employee_master e_Update ON e_update.employee_id=sv.CreaterId ");
        sb.Append("       LEFT JOIN employee_master e_Approved ON e_Approved.employee_id=sv.Approvedby ");
        sb.Append("        LEFT JOIN employee_master e_checked ON e_checked.employee_id=sv.Checkedby ");
        sb.Append("     INNER JOIN st_itemmaster st ON st.`ItemID`=sv.`ItemID` AND sv.`IsActive`=1 AND st.`IsActive`=1 AND sv.`ApprovalStatus`=2 ");
       
        if (location != "0")
        {
            sb.Append(" and DeliveryLocationID in (" + location + ")");
        }
       
       
        sb.Append(" where sv.ComparisonStatus=1 ");
        
        sb.Append("order by DeliveryLocationName,ItemName");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataColumn column = new DataColumn();
        column.ColumnName = "S.No";
        column.DataType = System.Type.GetType("System.Int32");
        column.AutoIncrement = true;
        column.AutoIncrementSeed = 0;
        column.AutoIncrementStep = 1;

        dt.Columns.Add(column);
        int index = 0;
        foreach (DataRow row in dt.Rows)
        {
            row.SetField(column, ++index);
        }
        dt.Columns["S.No"].SetOrdinal(0);
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "ItemRateList";
            return "true";
        }
        else
        {
            return "false";
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string Item, string fromdate, string todate, string location, string onlyserate)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("    SELECT DeliveryLocationID,(SELECT GROUP_CONCAT(TermsCondition) FROM st_Qutationtermsconditions WHERE Qutationno=sv.Qutationno) term,  catalogno, ");
        sb.Append("    Qutationno,Quotationrefno,vendorid,VendorName,vendoraddress,VednorStateName,vendorstateid,VednorStateGstnno,DATE_FORMAT(entrydatefrom,'%d-%b-%Y')entrydate,deliverystateid,deliverycentreid   ");
        sb.Append("      ,ItemCategoryID,ItemCategoryName,sv.ItemID,st.typename ItemName,st.HSNCode,sv.ManufactureID,sv.ManufactureName,sv.MachineID,sv.MachineName,Rate,Qty,DiscountPer,  ");
        sb.Append("      IGSTPer,SGSTPer,CGSTPer,ConversionFactor,PurchasedUnit,ConsumptionUnit,BuyPrice,FreeQty,DiscountAmt,GSTAmount,FinalPrice,sv.IsActive,DeliveryCentrename,DeliveryLocationName,DeliveryStateName,  ");
        sb.Append("      case when  sv.`ComparisonStatus`=0 then 'white' else 'pink' end rowcolor");
        sb.Append("      ,date_format(EntryDateFrom,'%d-%b-%Y')fromdate,date_format(EntryDateTo,'%d-%b-%Y')todate");
        sb.Append("      FROM st_vendorqutation sv ");
        sb.Append("     INNER JOIN st_itemmaster st ON st.`ItemID`=sv.`ItemID` AND sv.`IsActive`=1 AND st.`IsActive`=1 AND sv.`ApprovalStatus`=2 and EntryDateTo>=date(now())");
        if (Item != "")
        {
            sb.Append(" and st.`ItemID` in (" + Item + ")");
        }
        if (location != "")
        {
            sb.Append(" and DeliveryLocationID in (" + location + ")");
        }

        if (onlyserate == "1")
        {
            sb.Append(" where sv.ComparisonStatus=1 ");
        }
        else
        {
            //sb.Append("  where sv.CreaterDateTime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
           // sb.Append("  and sv.CreaterDateTime<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        }
        sb.Append("order by ItemName");




        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public static string SetRate(string qid, string itemid, string locationid)
    {
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE st_vendorqutation SET ComparisonStatus=0 WHERE ItemID=@ItemID AND DeliveryLocationID=@DeliveryLocationID ",
                                new MySqlParameter("@ItemID", itemid), new MySqlParameter("@DeliveryLocationID", locationid));
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE st_vendorqutation SET ComparisonStatus=1,ComparisonDate=now(),ComparisonBy=@ComparisonBy WHERE ItemID=@ItemID AND DeliveryLocationID=@DeliveryLocationID AND QutationNo=@QutationNo",
                        new MySqlParameter("@ComparisonBy", UserInfo.ID), new MySqlParameter("@ItemID", itemid),
                        new MySqlParameter("@DeliveryLocationID", locationid), new MySqlParameter("@QutationNo", qid)
                        );
                    tnx.Commit();
                    return "1";

                }
                catch (Exception ex)
                {

                    tnx.Rollback();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return "0";

                }
                finally
                {
                    con.Close();
                }
            }
        }
    }

}

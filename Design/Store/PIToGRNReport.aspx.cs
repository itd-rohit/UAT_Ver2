using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_PIToGRNReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindalldata();
        }
    }

    void bindalldata()
    {
        if (UserInfo.AccessStoreLocation != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT locationid,location FROM st_locationmaster WHERE isactive=1   ");
            sb.Append(" AND locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


            sb.Append(" ORDER BY location ");
            ddllocation.DataSource = StockReports.GetDataTable(sb.ToString());
            ddllocation.DataTextField = "location";
            ddllocation.DataValueField = "locationid";
            ddllocation.DataBind();

            sb = new StringBuilder();
            sb.Append("  SELECT supplierid,suppliername FROM `st_vendormaster` WHERE isactive=1 ORDER BY suppliername");
            ddlvendor.DataSource = StockReports.GetDataTable(sb.ToString());
            ddlvendor.DataTextField = "suppliername";
            ddlvendor.DataValueField = "supplierid";
            ddlvendor.DataBind();


            //ddllocation.Items.Insert(0, new ListItem("Select Location", "0"));
        }

    }

    [WebMethod(EnableSession = true)]
    public static string binditem(string CategoryTypeId, string SubCategoryTypeId, string CategoryId, string LocationID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT st.ItemId,typename ItemName FROM st_itemmaster st ");
        //sb.Append(" inner join st_mappingitemmaster sm on sm.itemid=st.itemid and sm.locationid='" + LocationID.Split('#')[0] + "'");

        sb.Append(" WHERE CategoryTypeID IN(" + CategoryTypeId + ")");

        if (SubCategoryTypeId != "")
            sb.Append(" AND SubCategoryTypeID IN(" + SubCategoryTypeId + ") ");
        if (CategoryId != "")
            sb.Append(" AND SubCategoryID IN(" + CategoryId + ") ");

        sb.Append("  and st.isactive=1 and approvalstatus=2  order by typename");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }

    [WebMethod(EnableSession = true)]
    public static string getreportexcel(string location, string Items,string manu,string machine,  string fromdate, string todate,string vendor)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT stm.State IndentState, sl.Location IndentLocation,  ");
        sb.Append(" ssm1.CategoryTypeName CategoryType, sm1.SubCategoryTypeName SubCategoryType,ssm.Name ItemType, ");
        sb.Append(" itg.`ItemNameGroup` itemname,smm.machinename,smm.ManufactureName Manufacture,smm.PackSize,smm.CatalogNo,smm.HSNCode, ");
        sb.Append(" smm.MajorUnitName,smm.MinorUnitName,smm.Converter, ");

        sb.Append(" sd.IndentNo, DATE_FORMAT(sd.`dtEntry`,'%d-%b-%Y  %h:%i %p') IndentDate, sd.UserName IndentedBy,  ");
        sb.Append(" DATE_FORMAT(sd.approveddate,'%d-%b-%Y %h:%i %p')IndentApprovalDate,sd.approvedUserName IndentApprovedBy,sd.`ApprovedQty` ApprovedIndentQty, ");
        
        
        sb.Append(" sp.VendorName Supplier,(SELECT state FROM state_master WHERE id=sd.VendorStateId)SupplierState, ");
        sb.Append(" sp.`PurchaseOrderNo`, DATE_FORMAT(sp.CheckedDate,'%d-%b-%Y %h:%i %p') `POPreparedDate`,sp.`CreatedByName` POPreparedBy, DATE_FORMAT(sp.ApprovedDate,'%d-%b-%Y %h:%i %p') POApprovedDate,sp.AppprovedByName POApprovedBy, ");

        sb.Append("  spd.`ApprovedQty` PurchaseOrderQty,spd.Rate as 'POGrossTotal(RatePerItem)',spd.UnitPrice 'PONetTotal(UnitPricePerItem)' ,st.`InitialCount`/st.`Converter` GRNQty , ");

        sb.Append(" st.LedgerTransactionNo GRNNo, DATE_FORMAT(lt.DATETIME,'%d-%b-%Y %h:%i %p') GRNDate, ");
        sb.Append(" (SELECT NAME FROM employee_master WHERE employee_id =st.userid)GRNBy, ");
        
        sb.Append("  st.batchnumber,st.barcodeno,st.stockid,DATE_FORMAT(st.`expirydate`,'%d-%b-%Y') expirydate, ");
        sb.Append("  (st.rate*st.`Converter`) as 'GRNGross(RatePerItem)',(st.DiscountAmount*st.`Converter`) GRNDiscountAmount, st.DiscountPer GRNDiscountPer, ");
        sb.Append("  (st.TaxAmount*st.`Converter`) GRNTaxAmount, st.TaxPer GRNTaxPer,(st.UnitPrice*st.`Converter`) as 'GRNNet(UnitPricePerItem)', ");
        sb.Append("  ROUND(((st.rate-st.DiscountAmount)*IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=st.stockid   ");
        sb.Append("  AND taxname='IGST' LIMIT 1) ,'0')*0.01),5)TaxAmtIGST, ");
        sb.Append("  ROUND(((st.rate-st.DiscountAmount)*IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=st.stockid  ");
        sb.Append("   AND taxname='CGST' LIMIT 1) ,'0')*0.01),5) TaxAmtCGST, ");
        sb.Append("  ROUND( ((st.rate-st.DiscountAmount)*IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=st.stockid   ");
        sb.Append("     AND taxname='SGST' LIMIT 1) ,'0')*0.01),5) TaxAmtSGST, ");
        sb.Append("    st.`IsPost`,DATE_FORMAT(st.`PostDate`,'%d-%b-%Y') PostDate, ");
        sb.Append("    (SELECT NAME FROM employee_master WHERE employee_id=st.`PostUserID`)PostByUser, ");
        sb.Append("    lt.IsPODGenerate,lt.PODnumber,lt.PODcreated_by PODGenerateBy,DATE_FORMAT(lt.`PODgendate`,'%d-%b-%Y') PODGenerateDate ");
        sb.Append(" FROM st_nmstock st ");
        sb.Append(" INNER JOIN `st_ledgertransaction` lt ON st.`LedgerTransactionID`=lt.`LedgerTransactionID`  ");
        sb.Append(" INNER JOIN `st_purchaseorder` sp ON sp.`PurchaseOrderNo`=lt.`PurchaseOrderNo` ");
        sb.Append(" INNER JOIN `st_purchaseorder_details` spd ON spd.`PurchaseOrderID`=sp.`PurchaseOrderID` AND spd.`ItemID`=st.`ItemID` ");
        sb.Append(" INNER JOIN `st_indent_detail` sd ON sd.`IndentNo`=sp.`IndentNo` AND sd.`ItemId`=spd.`ItemID` ");
        sb.Append(" INNER JOIN st_locationmaster sl ON sl.locationid=sd.fromlocationid ");
        sb.Append(" and st.locationid in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        if (location != "[]")
        {
            sb.Append(" and sl.LocationID in (" + Util.GetString(location).Replace("[", "").Replace("]", "") + ")");
        }
        sb.Append(" INNER JOIN state_master stm ON stm.id=sl.stateid ");
        sb.Append(" INNER JOIN st_itemmaster smm ON smm.`ItemID`=sd.`ItemID`  ");
        sb.Append(" INNER JOIN `st_itemmaster_group` itg ON itg.`ItemIDGroup`=smm.`ItemIDGroup`  ");
        if (Items != "[]")
        {
            sb.Append(" and smm.itemid in ('" + Util.GetString(Items).Replace(",", "','") + "')");
        }
        if (manu != "0")
        {
            sb.Append(" and smm.ManufactureID='" + manu + "'");
        }
        if (machine != "0")
        {
            sb.Append(" and smm.MacID ='" + machine + "'");
        }
        sb.Append(" INNER JOIN `st_categorytypemaster` ssm1 ON ssm1.CategoryTypeID=smm.CategoryTypeID   ");
        sb.Append(" INNER JOIN `st_subcategorymaster` ssm ON ssm.SubCategoryID=smm.SubCategoryID   ");
        sb.Append(" INNER JOIN `st_subcategorytypemaster` sm1 ON sm1.SubCategoryTypeID=smm.SubCategoryTypeID   ");

        sb.Append("  WHERE lt.`IsCancel`=0 AND  lt.typeoftnx='Purchase'   ");
        sb.Append("  AND lt.datetime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append("  AND lt.datetime<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'  ");

        if(vendor!="[]")
        {
            sb.Append(" and lt.VendorID in ('" + Util.GetString(vendor).Replace(",", "','") + "')");
        }


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

            HttpContext.Current.Session["ReportName"] = "PI_To_GRNreport";

            return "true";
        }
        else
        {
            return "No Record Found";
        }
    }

}
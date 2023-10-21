using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_PIToPOAndGRN : System.Web.UI.Page
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
    public static string getreportexcel(string location, string Items, string manu, string machine, string fromdate, string todate, string type, string rtype)
    {

        if (type == "1")
        {
           
            StringBuilder sb = new StringBuilder();

            sb.Append("   SELECT pom.IndentNo PIIndentNo,DATE_FORMAT(sid.dtEntry,'%d-%b-%Y') IndentDate, ");
            sb.Append("     (SELECT location FROM st_locationmaster WHERE locationid=pom.locationid)IndentLocation,  ");
            sb.Append("   DATE_FORMAT(sid.CheckedDate,'%d-%b-%Y')PICheckedDate,CheckedUserName PICheckedByName, ");
            sb.Append("   DATE_FORMAT(sid.ApprovedDate,'%d-%b-%Y')PIApprovedDate,ApprovedUserName  PIAppprovedByName, ");
            sb.Append("   DATE_FORMAT(pom.CreatedDate,'%d-%b-%Y')PODate,pom.PurchaseOrderNo,VendorName, ");
            if (rtype == "1")
            {
                sb.Append("  GrossTotal GrossTotal,DiscountOnTotal TotalDiscount, ");
                sb.Append("   pom.taxAmount Totaltax,NetTotal NetTotal, ");
            }
            else
            {
                sb.Append("   ssm1.CategoryTypeName CategoryType, sm1.SubCategoryTypeName SubCategoryType,ssm.Name ItemType,");
                sb.Append("   sm.typename `ItemName`, ");
                sb.Append("   sm.`ManufactureName`,sm.`MachineName`,sm.`PackSize`,sm.catalogno,sm.hsncode, ");
                sb.Append("   trimzero(sid.`ApprovedQty`)IndentQty, trimzero(pod.`ApprovedQty`)ApprovedQty, ");
                sb.Append("   ");
                sb.Append("   pod.`Rate` Rate, ");
                sb.Append("   pod.DiscountPercentage,pod.`DiscountAmount` DiscountAmount, ");
                sb.Append(" (SELECT SUM( `Percentage` ) FROM  `st_purchaseorder_tax` st WHERE st.purchaseorderid=pod.purchaseorderid AND st.itemid=pod.itemid ) TaxPercentage,");
                sb.Append("   pod.`TaxAmount` TaxAmount,pod.`UnitPrice` UnitPrice,pod.`NetAmount` NetAmount, ");
            }
            sb.Append("   DATE_FORMAT(pom.CheckedDate,'%d-%b-%Y')POCheckedDate,CheckedByName POCheckedByName, ");
            sb.Append("   DATE_FORMAT(pom.ApprovedDate,'%d-%b-%Y')POApprovedDate,AppprovedByName  POAppprovedByName ");
            sb.Append("   FROM `st_purchaseorder` pom ");
            sb.Append("   INNER JOIN st_purchaseorder_details pod ON pod.PurchaseOrderID=pom.PurchaseOrderID ");
            sb.Append(" inner join st_indent_detail sid on sid.IndentNo=pom.IndentNo and sid.itemid=pod.itemid");

            sb.Append("   and pom.LocationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


            if (location != "[]")
            {
                sb.Append(" and pom.LocationID in (" + Util.GetString(location).Replace("[", "").Replace("]", "") + ")");
            }
            sb.Append("   INNER JOIN st_itemmaster sm ON sm.`ItemID`=pod.`ItemID` ");
            if (Items != "[]")
            {
                sb.Append(" and sm.itemid in ('" + Util.GetString(Items).Replace(",", "','") + "')");
            }
            if (manu != "0")
            {
                sb.Append(" and sm.ManufactureID='" + manu + "'");
            }
            if (machine != "0")
            {
                sb.Append(" and sm.MacID ='" + machine + "'");
            }
            sb.Append("   INNER JOIN `st_categorytypemaster` ssm1 ON ssm1.CategoryTypeID=sm.CategoryTypeID  ");
            sb.Append("   INNER JOIN `st_subcategorymaster` ssm ON ssm.SubCategoryID=sm.SubCategoryID  ");
            sb.Append("   INNER JOIN `st_subcategorytypemaster` sm1 ON sm1.SubCategoryTypeID=sm.SubCategoryTypeID  ");

            sb.Append("   AND pod.`IsActive`=1  and IsDirectPO=0");

            sb.Append("  AND sid.`dtEntry`>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append("  AND sid.`dtEntry`<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
            if (rtype == "1")
            {
                sb.Append(" group by pom.PurchaseOrderID ");
                sb.Append("  ORDER BY IndentLocation,sid.dtEntry");
            }
            else
            {
                sb.Append("  ORDER BY IndentLocation,sid.dtEntry,itemname");
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
                if (rtype == "1")
                {
                    HttpContext.Current.Session["ReportName"] = "PI_vs_PoReportSummary";
                }
                else
                {
                    HttpContext.Current.Session["ReportName"] = "PI_vs_PoReportDetail";
                }
                return "true";
            }
            else
            {
                return "No Record Found";
            }
           
        }
        else if (type == "2")
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT lt.`PurchaseOrderNo`,VendorName,  DATE_FORMAT(pom.CreatedDate,'%d-%b-%Y')PODate,  ");
            sb.Append("   DATE_FORMAT(pom.CheckedDate,'%d-%b-%Y')POCheckedDate,CheckedByName POCheckedByName, ");
            sb.Append("   DATE_FORMAT(pom.ApprovedDate,'%d-%b-%Y')POApprovedDate,AppprovedByName  POAppprovedByName, ");
            sb.Append("  sl.location POLocation,  ");
            if (rtype == "1")
            {
                sb.Append("  pom.GrossTotal POGrossTotal,pom.DiscountOnTotal POTotalDiscount, ");
                sb.Append("   pom.taxAmount POTotaltax,pom.NetTotal PONetTotal, ");
            }

            sb.Append("  lt.`LedgerTransactionNo` GRNNo,");

            if (rtype == "1")
            {
                sb.Append("  lt.GrossAmount GRNGrossAmount,lt.DiscountOnTotal GRNDiscountOnTotal,lt.TaxAmount GRNTaxAmount,lt.NetAmount GRNNetAmount,lt.`InvoiceNo`,");
            }
            else
            {

                sb.Append("   ssm1.CategoryTypeName CategoryType, sm1.SubCategoryTypeName SubCategoryType,ssm.Name ItemType,");
                sb.Append("   sm.typename `ItemName`, ");
                sb.Append("   sm.`ManufactureName`,sm.`MachineName`,sm.`PackSize`,sm.catalogno,sm.hsncode, ");


                sb.Append("  snm.`BarcodeNo`,snm.batchnumber,DATE_FORMAT(snm.`ExpiryDate`,'%d-%b-%Y') ExpiryDate,  ");
                sb.Append("  trimzero((snm.`InitialCount`/snm.converter)) GRNQty,trimzero(snm.`Rate`)Rate,trimzero(snm.`DiscountAmount`)DiscountAmount,trimzero(snm.`TaxAmount`)TaxAmount,trimzero(snm.`UnitPrice`)UnitPrice, if(snm.`IsFree`=1,'Yes','')IsFree,  ");
            }
            sb.Append("  snm.`IsPost`,DATE_FORMAT(lt.`DateTime`,'%d-%b-%Y')GRNDate,(SELECT NAME FROM employee_master WHERE employee_id=lt.Creator_UserID)GRNBYUser,  ");
            sb.Append("  DATE_FORMAT(snm.`PostDate`,'%d-%b-%Y') PostDate,(SELECT NAME FROM employee_master WHERE employee_id=snm.`PostUserID`)PostByUser   ");
            sb.Append("  FROM `st_ledgertransaction` lt  ");
            sb.Append("   inner join  `st_purchaseorder` pom on pom.PurchaseOrderNo=lt.PurchaseOrderNo");
            sb.Append("  INNER JOIN st_nmstock snm ON lt.`LedgerTransactionID`=snm.`LedgerTransactionID`  ");




            sb.Append("   INNER JOIN st_itemmaster sm ON sm.`ItemID`=snm.`ItemID` ");
            if (Items != "[]")
            {
                sb.Append(" and sm.itemid in ('" + Util.GetString(Items).Replace(",", "','") + "')");
            }
            if (manu != "0")
            {
                sb.Append(" and sm.ManufactureID='" + manu + "'");
            }
            if (machine != "0")
            {
                sb.Append(" and sm.MacID ='" + machine + "'");
            }

            sb.Append("   INNER JOIN `st_categorytypemaster` ssm1 ON ssm1.CategoryTypeID=sm.CategoryTypeID  ");
            sb.Append("   INNER JOIN `st_subcategorymaster` ssm ON ssm.SubCategoryID=sm.SubCategoryID  ");
            sb.Append("   INNER JOIN `st_subcategorytypemaster` sm1 ON sm1.SubCategoryTypeID=sm.SubCategoryTypeID  ");



            sb.Append(" inner join st_locationmaster sl on sl.locationid=lt.locationid");
            sb.Append("   and lt.LocationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
            if (location != "[]")
            {
                sb.Append(" and sl.LocationID in (" + Util.GetString(location).Replace("[", "").Replace("]", "") + ")");
            }

            sb.Append("  WHERE lt.`IsCancel`=0 AND  typeoftnx='Purchase'   ");
            sb.Append("  AND pom.CreatedDate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append("  AND pom.CreatedDate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'  ");


            sb.Append(" and IsDirectGRN=0");
            if (rtype == "1")
            {
                sb.Append(" group by lt.`LedgerTransactionID` ");
                sb.Append("  ORDER BY  lt.`PurchaseOrderNo`");
            }
            else
            {
                sb.Append(" ORDER BY lt.`PurchaseOrderNo`,snm.`ItemName`  ");
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
                if (rtype == "1")
                {
                    HttpContext.Current.Session["ReportName"] = "PO_vs_GRNSummary";
                }
                else
                {
                    HttpContext.Current.Session["ReportName"] = "PO_vs_GRNDetail";
                }
                return "true";
            }
            else
            {
                return "No Record Found";
            }
        }

        else
        {
            return "No Record Found";
        }
      
    }
    

}
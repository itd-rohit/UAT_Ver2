using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;


public partial class Design_Store_PendingPOReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
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
    }
    

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(string fromdate, string todate, string type, string LocationID)
    {


        StringBuilder sb = new StringBuilder();

        sb.Append("   SELECT (SELECT location FROM st_locationmaster WHERE locationid=pom.locationid)DeliveryLocation,  ");
        sb.Append("   DATE_FORMAT(pom.CreatedDate,'%d-%b-%Y')PODate,IFNULL(CreatedByName,'') POCreatedBY, ");
        sb.Append("   pom.PurchaseOrderNo,VendorName, IFNULL(IndentNo,'')PIIndentNo,  ");
        sb.Append("   (SELECT DATE_FORMAT(ind.`dtEntry`,'%d-%b-%Y %I:%i%p') FROM `st_indent_detail` ind WHERE ind.`IndentNo`=pom.IndentNo LIMIT 1 ) IndentDate,  ");
        sb.Append("   IF(IsDirectPO=0,'PO From PI','Direct PO') POType ,ssm1.CategoryTypeName CategoryType, sm1.SubCategoryTypeName SubCategoryType,ssm.Name ItemType,");
        sb.Append("   itg.`ItemNameGroup` `ItemName`, ");
        sb.Append("   sm.`ManufactureName`,sm.`MachineName`,sm.`PackSize`,sm.catalogno,sm.hsncode,trimzero(pod.`OrderedQty`)OrderedQty,  ");
        sb.Append("  trimzero(pod.`CheckedQty`)CheckedQty,trimzero(pod.`ApprovedQty`)ApprovedQty,trimzero(pod.`GRNQty`)GRNQty,trimzero(pod.ApprovedQty-pod.GRNQty) PendingQty,");

        sb.Append("   Rate*(IF(ApprovedQty=0,IF(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty)) GrossTotal, ");
        sb.Append("   DiscountAmount*(IF(ApprovedQty=0,IF(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty)) TotalDiscount, ");
        sb.Append("   DiscountPercentage, ");
        sb.Append("   pod.TaxAmount*(IF(ApprovedQty=0,IF(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty)) Totaltax,");
        sb.Append("   UnitPrice*(IF(ApprovedQty=0,IF(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty)) NetTotal , ");

        sb.Append("   IF(pod.`IsFree`=1,'Free','') IsFree, ");
        sb.Append("   pod.`Rate` Rate, ");
        sb.Append("   pod.DiscountPercentage,");
        sb.Append(" (SELECT SUM( `Percentage` ) FROM  `st_purchaseorder_tax` st WHERE st.purchaseorderid=pod.purchaseorderid AND st.itemid=pod.itemid ) TaxPercentage,");
        sb.Append("   pod.`TaxAmount` TaxAmount,pod.`UnitPrice` UnitPrice, ");
        sb.Append("   DATE_FORMAT(pom.CheckedDate,'%d-%b-%Y')CheckedDate, CheckedByName, ");
        sb.Append("   DATE_FORMAT(pom.ApprovedDate,'%d-%b-%Y')ApprovedDate,  AppprovedByName ");
        sb.Append("   FROM `st_purchaseorder` pom ");
        sb.Append("   INNER JOIN st_purchaseorder_details pod ON pod.PurchaseOrderID=pom.PurchaseOrderID ");
        sb.Append("   and pom.locationid in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        if (LocationID != "")
        {
            sb.Append(" and pom.locationid in (" + Util.GetString(LocationID).Replace("[", "").Replace("]", "") + ")");
        }

        sb.Append("   INNER JOIN st_itemmaster sm ON sm.`ItemID`=pod.`ItemID` ");
        sb.Append("   INNER JOIN `st_itemmaster_group` itg ON itg.`ItemIDGroup`=sm.`ItemIDGroup` ");
        sb.Append("   INNER JOIN `st_categorytypemaster` ssm1 ON ssm1.CategoryTypeID=sm.CategoryTypeID  ");
        sb.Append("   INNER JOIN `st_subcategorymaster` ssm ON ssm.SubCategoryID=sm.SubCategoryID  ");
        sb.Append("   INNER JOIN `st_subcategorytypemaster` sm1 ON sm1.SubCategoryTypeID=sm.SubCategoryTypeID  ");

        sb.Append("   where pod.`IsActive`=1 AND pom.status=2 and pod.`GRNQty`<>pod.ApprovedQty");
        sb.Append("   AND pom.locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        sb.Append("  AND pom.`CreatedDate`>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append("  AND pom.`CreatedDate`<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
        sb.Append("  ORDER BY DeliveryLocation,CreatedDate,Itemname");

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
            HttpContext.Current.Session["ReportName"] = "Pending GRN Report";
            return "true";
        }
        else
        {
            return "false";
        }

    }

}
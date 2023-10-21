using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_ClosedPOReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(string fromdate, string todate, string type, string type1)
    {

            StringBuilder sb = new StringBuilder();

            sb.Append("   SELECT (SELECT location FROM st_locationmaster WHERE locationid=pom.locationid)DeliveryLocation,  ");
            sb.Append("   DATE_FORMAT(pom.CreatedDate,'%d-%b-%Y')PODate,IFNULL(CreatedByName,'') POCreatedBy, ");
            sb.Append("   pom.PurchaseOrderNo,VendorName, IFNULL(IndentNo,'')PIIndentNo,  ");
            sb.Append("   IFNULL((SELECT DATE_FORMAT(`dtEntry`,'%d-%b-%Y') FROM `st_indent_detail` sid WHERE sid.`IndentNo`=pom.IndentNo LIMIT 1 ),'') IndentDate,    ");
            sb.Append("   IF(IsDirectPO=0,'PO From PI','Direct PO') POType ,ssm1.CategoryTypeName CategoryType, sm1.SubCategoryTypeName SubCategoryType,ssm.Name ItemType,");
            sb.Append("   itg.`ItemNameGroup` `ItemName`, ");
            sb.Append("   sm.`ManufactureName`,sm.`MachineName`,sm.`PackSize`,sm.catalogno,sm.hsncode,pod.`OrderedQty` OrderedQty,  ");
            sb.Append("   pod.`CheckedQty` CheckedQty,pod.`ApprovedQty` ApprovedQty,RejectQty ClosedQty, ");

           
            sb.Append("   DATE_FORMAT(pom.CheckedDate,'%d-%b-%Y')CheckedDate, CheckedByName, ");
            sb.Append("   DATE_FORMAT(pom.ApprovedDate,'%d-%b-%Y')ApprovedDate,  AppprovedByName ");
            sb.Append("   ,DATE_FORMAT(pom.closeddate,'%d-%b-%Y')Closeddate,  closedbyname,closedreason ");
            sb.Append("   FROM `st_purchaseorder` pom ");

            sb.Append("   INNER JOIN st_purchaseorder_details pod ON pod.PurchaseOrderID=pom.PurchaseOrderID  and RejectQty>0");
            sb.Append(" and pom.locationid in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
            sb.Append("   INNER JOIN st_itemmaster sm ON sm.`ItemID`=pod.`ItemID` ");
            sb.Append("   INNER JOIN `st_itemmaster_group` itg ON itg.`ItemIDGroup`=sm.`ItemIDGroup` ");
            sb.Append("   INNER JOIN `st_categorytypemaster` ssm1 ON ssm1.CategoryTypeID=sm.CategoryTypeID  ");
            sb.Append("   INNER JOIN `st_subcategorymaster` ssm ON ssm.SubCategoryID=sm.SubCategoryID  ");
            sb.Append("   INNER JOIN `st_subcategorytypemaster` sm1 ON sm1.SubCategoryTypeID=sm.SubCategoryTypeID  ");

            sb.Append("   AND pod.`IsActive`=1 AND pom.status in(4,5) ");

            if (type == "")
            {

            }
            if (type1 != "")
            {
                sb.Append("   AND pom.status=" + type1 + "");
            }

            sb.Append("  AND pom.`Closeddate`>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append("  AND pom.`Closeddate`<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
            sb.Append("  ORDER BY DeliveryLocation,Closeddate,Itemname");

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
                HttpContext.Current.Session["ReportName"] = "ClosedPOReport";
                return "true";
            }
            else
            {
                return "false";
            }
        
    }

}
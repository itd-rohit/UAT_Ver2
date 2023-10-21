using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_PrintStockBarcode : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindalldata();
        }
    }

    void bindalldata()
    {
        if (UserInfo.AccessStoreLocation != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT concat(locationid,'#',panel_id) locationid,location FROM st_locationmaster WHERE isactive=1   ");
            sb.Append(" AND locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


            sb.Append(" ORDER BY location ");
            ddllocation.DataSource = StockReports.GetDataTable(sb.ToString());
            ddllocation.DataTextField = "location";
            ddllocation.DataValueField = "locationid";
            ddllocation.DataBind();

            if (ddllocation.Items.Count > 1)
            {
                ddllocation.Items.Insert(0, new ListItem("Select Location", "0"));
            }
        }

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchDataPrint(string locationid, string CategoryTypeId, string SubCategoryTypeId, string SubCategoryId, string ItemId)
    {


        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT (select location from st_locationmaster where locationid=smm.`LocationId`) LocationName, si.IssueInFIFO,si.BarcodeOption, si.BarcodeGenrationOption, si.IsExpirable, IFNULL(snt.BatchNumber,'')batchnumber, IFNULL(DATE_FORMAT(snt.ExpiryDate,'%d-%b-%Y'),'')ExpiryDate, snt.InHandQty  Balance ,IFNULL(snt.StockID,0)StockID, si.SubCategoryID,sm.name itemgroup,si.itemid,typename,apolloitemcode,si.ManufactureID,   ");
        sb.Append(" si.MachineID,si.MajorUnitId,si.MajorUnitName,si.IssueMultiplier,si.IsExpirable,si.Converter,si.PackSize,si.MinorUnitId,si.MinorUnitName,smm.`LocationId`,'" + locationid.Split('#')[1] + "' panelid,   ");
        sb.Append(" IFNULL(snt.Rate,0)Rate,IFNULL(snt.DiscountPer,0)DiscountPer,IFNULL(snt.DiscountAmount,0)DiscountAmount,IFNULL(snt.TaxPer,0)TaxPer,IFNULL(snt.TaxAmount,0)TaxAmount,IFNULL(snt.UnitPrice,0)UnitPrice,IFNULL(snt.MRP,0)MRP  ");

        sb.Append(",ifnull(snt.barcodeno,'' )barcodeno ");

        sb.Append(" FROM st_itemmaster si    ");
        sb.Append(" INNER JOIN st_subcategorymaster sm ON sm.SubCategoryID=si.SubCategoryID   ");
        sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`   ");
        sb.Append(" AND smm.`LocationId`=" + locationid.Split('#')[0] + "  ");
        sb.Append(" inner JOIN   ");
        sb.Append(" (SELECT  barcodeno,stockid,`ItemID`,`BatchNumber`,if(`ExpiryDate`='0001-01-01','',ExpiryDate)ExpiryDate,sum(`InitialCount` - `ReleasedCount` - `PendingQty` )InHandQty,Rate,  ");
        sb.Append(" DiscountPer,DiscountAmount,TaxPer,TaxAmount,UnitPrice,MRP FROM st_nmstock   ");
        sb.Append(" WHERE `LocationId`=" + locationid.Split('#')[0] + " AND (`InitialCount` - `ReleasedCount` - `PendingQty` ) >0 AND `IsPost`=1  ");
        sb.Append(" GROUP BY `ItemID`,`BatchNumber`,`ExpiryDate`,barcodeno  ) snt ON snt.ItemID=si.itemid  ");
        sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2   ");



        if (CategoryTypeId != "")
            sb.Append(" and si.CategoryTypeID in (" + CategoryTypeId + ")");

        if (SubCategoryTypeId != "")
            sb.Append(" and si.SubCategoryTypeID in (" + SubCategoryTypeId + ")");

        if (SubCategoryId != "")
            sb.Append(" and si.SubCategoryID in (" + SubCategoryId + ")");

        if (ItemId != "")
            sb.Append(" and si.itemid in (" + ItemId + ")");


        sb.Append(" order by  typename");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            // ds.WriteXmlSchema(@"E:\StockPhysicalVerification.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "StockPhysicalVerification";
            return "1";
        }
        else
        {
            return "No Record Found";
        }


    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string locationid, string CategoryTypeId, string SubCategoryTypeId, string SubCategoryId, string ItemId)
    {


        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT si.IssueInFIFO,si.BarcodeOption, si.BarcodeGenrationOption, si.IsExpirable, IFNULL(snt.BatchNumber,'')batchnumber, IFNULL(DATE_FORMAT(snt.ExpiryDate,'%d-%b-%Y'),'')ExpiryDate, snt.InHandQty  Balance ,IFNULL(snt.StockID,0)StockID, si.SubCategoryID,sm.name itemgroup,si.itemid,typename,apolloitemcode,si.ManufactureID,   ");
        sb.Append(" si.MachineID,si.MajorUnitId,si.MajorUnitName,si.IssueMultiplier,si.IsExpirable,si.Converter,si.PackSize,si.MinorUnitId,si.MinorUnitName,smm.`LocationId`,'" + locationid.Split('#')[1] + "' panelid,   ");
        sb.Append(" IFNULL(snt.Rate,0)Rate,IFNULL(snt.DiscountPer,0)DiscountPer,IFNULL(snt.DiscountAmount,0)DiscountAmount,IFNULL(snt.TaxPer,0)TaxPer,IFNULL(snt.TaxAmount,0)TaxAmount,IFNULL(snt.UnitPrice,0)UnitPrice,IFNULL(snt.MRP,0)MRP  ");

        sb.Append(",ifnull(snt.barcodeno,'' )barcodeno ");

        sb.Append(" FROM st_itemmaster si    ");
        sb.Append(" INNER JOIN st_subcategorymaster sm ON sm.SubCategoryID=si.SubCategoryID   ");
        sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`   ");
        sb.Append(" AND smm.`LocationId`=" + locationid.Split('#')[0] + "  ");
        sb.Append(" inner JOIN   ");
        sb.Append(" (SELECT  barcodeno,stockid,`ItemID`,`BatchNumber`,if(`ExpiryDate`='0001-01-01',null,ExpiryDate)ExpiryDate,sum(`InitialCount` - `ReleasedCount` - `PendingQty` )InHandQty,Rate,  ");
        sb.Append(" DiscountPer,DiscountAmount,TaxPer,TaxAmount,UnitPrice,MRP FROM st_nmstock   ");
        sb.Append(" WHERE `LocationId`=" + locationid.Split('#')[0] + " AND (`InitialCount` - `ReleasedCount` - `PendingQty` ) >0 AND `IsPost`=1  ");
        sb.Append(" GROUP BY `ItemID`,`BatchNumber`,`ExpiryDate`,barcodeno) snt ON snt.ItemID=si.itemid  ");
        sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2   ");



        if (CategoryTypeId != "")
            sb.Append(" and si.CategoryTypeID in (" + CategoryTypeId + ")");

        if (SubCategoryTypeId != "")
            sb.Append(" and si.SubCategoryTypeID in (" + SubCategoryTypeId + ")");

        if (SubCategoryId != "")
            sb.Append(" and si.SubCategoryID in (" + SubCategoryId + ")");

        if (ItemId != "")
            sb.Append(" and si.itemid in (" + ItemId + ")");


        sb.Append(" order by InHandQty desc,typename asc");



        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

}
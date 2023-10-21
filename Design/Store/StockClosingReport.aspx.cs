using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_StockClosingReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromtime.Text = DateTime.Now.ToString("23:59:59");
            txtfromtime.ReadOnly = true;
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
    public static string getstockstatusreportexcel(string location, string Items, string manu, string machine, string fromdate, string fromtime)
    {
        StringBuilder sb = new StringBuilder();


        sb.Append("       SELECT * FROM (  ");
        sb.Append("       SELECT (SELECT location FROM st_locationmaster WHERE locationid=TEMP5.cid)StoreLocation,  ");
  sb.Append("        (SELECT sm.`state` FROM st_locationmaster sl INNER JOIN state_master sm ON sm.`id`=sl.`StateID` WHERE sl.locationid=TEMP5.cid)State,  ");
        sb.Append("  cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemTypeName,im.typename `ItemName`,  ");
        sb.Append(" temp5.ITEMID,TEMP5.cid,im.`ManufactureName` Manufacture,im.`MachineName` Machine ,im.packsize, ");

        sb.Append("            stockid,barcodeno,BatchNumber, ");
        sb.Append("            IF(ExpiryDate='0001-01-01','',DATE_FORMAT(ExpiryDate,'%d-%b-%y'))ExpiryDate,   ");
        sb.Append("          Rate,DiscPer,PurTaxPer TaxPer, ");
        sb.Append("           UnitPrice,InitialCount InitialQty,IF(NetReleaseQty='' OR  ");
        sb.Append("           NetReleaseQty IS NULL,0,NetReleaseQty)NetReleaseQty,  ");
        sb.Append("           (InitialCount-ifnull(NetInTransitQty,0)-(IFnull(NetReleaseQty,0)))AS InHandQty, ifnull(NetInTransitQty,0) InTransitQty, ");
        sb.Append("          UnitPrice*(InitialCount-ifnull(NetInTransitQty,0)-(IFNULL(NetReleaseQty,0))) TotalCostValue, UnitPrice*ifnull(NetInTransitQty,0) InTransitAmt,  ");
        sb.Append("          DATE_FORMAT(StockDate,'%d-%b-%y')StockDate,IF(`IsFree`=1,'Yes','No') Isfree ");
        sb.Append("            ,Unit  ");
        sb.Append("          FROM (  ");
        sb.Append("            SELECT ST.StockID,st.barcodeno,ST.ItemID,ST.ItemName,  ");
        sb.Append("           ST.BatchNumber,ST.Rate,ST.DiscountPer DiscPer,ST.TaxPer PurTaxPer,ST.UnitPrice, ");
        sb.Append("           ST.MRP,ST.InitialCount,st.`ReleasedCount` stReleased,st.pendingqty,IF(Sales.NetReleaseQty<0,Sales.NetReleaseQty*-1,Sales.NetReleaseQty)  ");           sb.Append("           NetReleaseQty,ST.StockDate,st.`IsFree`,0 totalstockvalue,  ");
        sb.Append("           ST.ExpiryDate,ST.PostDate,st.`locationid` cid,st.`MinorUnit` Unit, IFNULL(Sales.NetInTransitQty,0)NetInTransitQty ");
        sb.Append("           FROM st_nmstock ST LEFT OUTER JOIN (   ");
        sb.Append("           SELECT StockID,ItemID,  ");
        sb.Append("          (ConsumeQty+IssueQty+AdjQty) AS NetReleaseQty, (InTransitIssueQty - InTransitReceiveQty - InTransitConsumeQty - InTransitStockInQty ) NetInTransitQty ");
        sb.Append("          FROM ( ");
        sb.Append("          SELECT StockID,ItemID, ");
        sb.Append("         IFNULL(SUM(ConsumeQty),0) AS ConsumeQty,  ");
        sb.Append("         IFNULL(SUM(IssueQty),0)   AS IssueQty , ");
        sb.Append("         IFNULL(SUM(AdjQty),0) AS AdjQty,  ");
        sb.Append("         IFNULL(SUM(InTransitIssueQty),0) AS InTransitIssueQty,  ");
        sb.Append("         IFNULL(SUM(InTransitReceiveQty),0) AS InTransitReceiveQty,  ");
        sb.Append("         IFNULL(SUM(InTransitConsumeQty),0) AS InTransitConsumeQty,  ");
        sb.Append("         IFNULL(SUM(InTransitStockInQty),0) AS InTransitStockInQty  ");
        
        
        sb.Append("         FROM( SELECT StockID,ItemID,   ");
      
        sb.Append("         (CASE WHEN TrasactionTypeID = 1 THEN Qty END)AS ConsumeQty,  ");
        sb.Append("         (CASE WHEN TrasactionTypeID = 2 THEN Qty END)AS IssueQty, ");
        sb.Append("         (CASE WHEN TrasactionTypeID = 3 THEN Qty END)AS AdjQty,  ");
        sb.Append("         (CASE WHEN TrasactionTypeID = 8 THEN Qty END)AS InTransitIssueQty,  ");        
        sb.Append("         (CASE WHEN TrasactionTypeID = 9 THEN Qty END)AS InTransitReceiveQty,  ");
        sb.Append("         (CASE WHEN TrasactionTypeID = 10 THEN Qty END)AS InTransitConsumeQty,  ");
        sb.Append("         (CASE WHEN TrasactionTypeID = 11 THEN Qty END)AS InTransitStockInQty  ");
        
        sb.Append("        FROM ( SELECT StockID,ItemID,SUM(Quantity)AS Qty, ");
        sb.Append("       TrasactionTypeID FROM st_nmsalesdetails  ");



        sb.Append("  WHERE DateTime<='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " " + fromtime + "' ");


        if (Items != "[]")
        {
            sb.Append(" and itemid in ('" + Util.GetString(Items).Replace("[", "").Replace("]", "") + "')");
        }
        sb.Append("   and FromLocationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        if (location != "[]")
        {
            sb.Append(" and FromLocationID in (" + Util.GetString(location).Replace("[", "").Replace("]", "") + ")");
        }





        sb.Append("   and TrasactionTypeID IN(1,2,3,8,9,10,11)  ");

        sb.Append("    GROUP BY StockID,ItemID,TrasactionTypeID ");
        sb.Append("  )temp1 GROUP BY StockID,ItemID,TrasactionTypeID ");
        sb.Append("  )temp2 GROUP BY StockID,ItemID ");
        sb.Append(" )temp3   ");
        sb.Append("  ORDER BY StockID,ItemID ");
        sb.Append("   )Sales ON ST.StockID = Sales.StockID AND ST.ItemID = Sales.ItemID   ");

        sb.Append("   WHERE  ST.IsPost = 1    ");
        sb.Append(" AND ST.PostDate <='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " " + fromtime + "'  ");

        if (Items != "[]")
        {

            sb.Append(" and st.itemid in ('" + Util.GetString(Items).Replace("[", "").Replace("]", "") + "')");
        }
        sb.Append("   and st.locationid in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        if (location != "[]")
        {
            sb.Append(" and st.locationid  in (" + Util.GetString(location).Replace("[", "").Replace("]", "") + ") ");

        }
        sb.Append("    ORDER BY ST.StockID)temp5   ");
        sb.Append("   INNER JOIN st_itemmaster im ON im.`ItemID`=temp5.`ItemID`  ");
        if (Items != "[]")
        {
            sb.Append(" and im.itemid in ('" + Util.GetString(Items).Replace("[", "").Replace("]", "") + "')");
        }

        if (manu != "0")
        {
            sb.Append(" and im.ManufactureID='" + manu + "'");
        }
        if (machine != "0")
        {
            sb.Append(" and im.MacID ='" + machine + "'");
        }
        sb.Append("   INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=im.CategoryTypeID   ");
        sb.Append("   INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=im.SubCategoryTypeID   ");
        sb.Append("   INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=im.SubCategoryID  ");



        sb.Append("     )temp6    ");

        sb.Append("   WHERE (InitialQty - NetReleaseQty)  > 0  ");
        sb.Append("  ORDER BY StoreLocation,CategoryTypeName,SubCategoryTypeName,itemTypeName,ItemName,Manufacture,Machine,packsize   ");







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
            HttpContext.Current.Session["ReportName"] = " StockStatusReportAsOnDate_"+fromdate+"_"+fromtime;
            return "1";
        }
        else
        {
            return "No Record Found";
        }


    }
    
}


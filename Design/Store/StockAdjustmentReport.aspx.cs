using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_StockAdjustmentReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtfromdate.Text = "1-" + DateTime.Now.ToString("MMM-yyyy");
            txttodate.Text = DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month) + "-" + DateTime.Now.ToString("MMM-yyyy");
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
    public static string getstockstatusreportexcel(string location, string Items, string manu, string machine, string fromdate, string todate, string type)
    {


        StringBuilder sb;

        if (type == "1")
        {
            sb= new StringBuilder();
            sb.Append(" SELECT 'StockAdjustment' Type, st.barcodeno,(SELECT location FROM st_locationmaster WHERE locationid=st.LocationID)StoreLocation, ");
            sb.Append(" cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemTypeName,im.typename ItemName, ");
            sb.Append("(select name from  st_manufacture_master mmmm where mmmm.MAnufactureID=st.ManufactureID)Manufacture,");
            sb.Append("(select name from  macmaster mmmm where mmmm.id=st.macid)Machine,");
            sb.Append(" st.BatchNumber,IF(st.ExpiryDate='0001-01-01','',DATE_FORMAT(expirydate,'%d-%b-%Y')) ExpiryDate, ");
            sb.Append(" TRIM(ROUND(st.Rate,2)) Rate ,TRIM(ROUND(st.UnitPrice,2)) UnitPrice , ");
            sb.Append(" TRIM(ROUND(st.DiscountAmount,2)) DiscountAmount,TRIM(ROUND(st.TaxAmount,2))TaxAmount, ");
            sb.Append(" TRIM(ROUND(st.InitialCount, 2)) AdjustQty , ");
            sb.Append(" TRIM(ROUND(st.UnitPrice*st.InitialCount, 2)) StockAmount, ");
            sb.Append("  st.MajorUnit PurchaseUnit,st.MinorUnit ConsumeUnit,im.packsize PackSize,");


            sb.Append(" DATE_FORMAT(StockDate,'%d-%b-%Y') StockDate, ");
            sb.Append(" st.stockid,st.barcodeno,(select name from employee_master where employee_id=st.PostUserID) UserName,DATE_FORMAT(PostDate,'%d-%b-%Y %h:%m %p') EntryDate");
            sb.Append(" FROM st_nmstock st  ");
            sb.Append(" INNER JOIN st_itemmaster im ON im.ItemID=st.ItemID ");
            if (Items != "[]")
            {
                sb.Append(" and st.itemid in ('" + Util.GetString(Items).Replace("[", "").Replace("]", "") + "')");
            }
            sb.Append(" inner join st_ledgertransaction lt on lt.LedgerTransactionID=st.LedgerTransactionID and lt.TypeOfTnx='StockAdjustment' ");

            sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=im.CategoryTypeID  ");
            sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=im.SubCategoryTypeID  ");
            sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=im.SubCategoryID ");
            sb.Append(" WHERE (st.InitialCount)>0 ");
            sb.Append(" and lt.DateTime >='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append(" and lt.DateTime <='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append("   and st.locationid in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
            if (location != "[]")
            {
                sb.Append(" and st.LocationID in (" + Util.GetString(location).Replace("[", "").Replace("]", "") + ")");
            }


            if (manu != "0")
            {
                sb.Append(" and st.ManufactureID='" + manu + "'");
            }
            if (machine != "0")
            {
                sb.Append(" and st.MacID ='" + machine + "'");
            }


            sb.Append(" UNION ALL ");


            sb.Append(" SELECT 'StockProcess' Type,  st.barcodeno,(SELECT location FROM st_locationmaster WHERE locationid=st.LocationID)StoreLocation, ");
            sb.Append(" cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemTypeName,im.typename ItemName, ");
            sb.Append("(select name from  st_manufacture_master mmmm where mmmm.MAnufactureID=st.ManufactureID)Manufacture,");
            sb.Append("(select name from  macmaster mmmm where mmmm.id=st.macid)Machine,");
            sb.Append(" st.BatchNumber,IF(st.ExpiryDate='0001-01-01','',DATE_FORMAT(expirydate,'%d-%b-%Y')) ExpiryDate, ");
            sb.Append(" TRIM(ROUND(st.Rate,2)) Rate ,TRIM(ROUND(st.UnitPrice,2)) UnitPrice , ");
            sb.Append(" TRIM(ROUND(st.DiscountAmount,2)) DiscountAmount,TRIM(ROUND(st.TaxAmount,2))TaxAmount, ");
            sb.Append(" TRIM(ROUND(sd.Quantity, 2)) * (-1) AdjustQty , ");
            sb.Append(" TRIM(ROUND(st.UnitPrice*sd.Quantity*(-1), 2)) StockAmount, ");
            sb.Append("  st.MajorUnit PurchaseUnit,st.MinorUnit ConsumeUnit,im.packsize PackSize,");


            sb.Append(" DATE_FORMAT(StockDate,'%d-%b-%Y') StockDate ");
            sb.Append(" ,sd.stockid,st.barcodeno,(select name from employee_master where employee_id=sd.UserID) UserName,DATE_FORMAT(sd.DateTime,'%d-%b-%Y %h:%m %p') EntryDate");
            sb.Append(" FROM st_nmstock st  ");
            sb.Append(" INNER JOIN st_itemmaster im ON im.ItemID=st.ItemID ");
            if (Items != "[]")
            {
                sb.Append(" and st.itemid in ('" + Util.GetString(Items).Replace("[", "").Replace("]", "") + "')");
            }
            sb.Append(" inner join st_nmsalesdetails sd on sd.StockID=st.StockID  and TrasactionTypeID = 3 ");

            sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=im.CategoryTypeID  ");
            sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=im.SubCategoryTypeID  ");
            sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=im.SubCategoryID ");
            sb.Append(" WHERE (sd.Quantity)>0 ");
            sb.Append(" and sd.DateTime >='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append(" and sd.DateTime <='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append("   and st.locationid in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
            if (location != "[]")
            {
                sb.Append(" and st.LocationID in (" + Util.GetString(location).Replace("[", "").Replace("]", "") + ")");
            }


            if (manu != "0")
            {
                sb.Append(" and st.ManufactureID='" + manu + "'");
            }
            if (machine != "0")
            {
                sb.Append(" and st.MacID ='" + machine + "'");
            }

            sb.Append(" order by StoreLocation,CategoryTypeName,SubCategoryTypeName,itemTypeName,ItemName,Manufacture,Machine,packsize ");







        }
        else
        {
            sb = new StringBuilder();
            sb.Append(" SELECT 'StockAdjustment' Type, st.barcodeno,(SELECT location FROM st_locationmaster WHERE locationid=st.LocationID)StoreLocation, ");
            sb.Append(" cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemTypeName,im.typename ItemName, ");
            sb.Append("(select name from  st_manufacture_master mmmm where mmmm.MAnufactureID=st.ManufactureID)Manufacture,");
            sb.Append("(select name from  macmaster mmmm where mmmm.id=st.macid)Machine,");
            sb.Append(" st.BatchNumber,IF(st.ExpiryDate='0001-01-01','',DATE_FORMAT(expirydate,'%d-%b-%Y')) ExpiryDate, ");
            sb.Append(" TRIM(ROUND(st.Rate,2)) Rate ,TRIM(ROUND(st.UnitPrice,2)) UnitPrice , ");
            sb.Append(" TRIM(ROUND(st.DiscountAmount,2)) DiscountAmount,TRIM(ROUND(st.TaxAmount,2))TaxAmount, ");
            sb.Append(" TRIM(ROUND(st.InitialCount, 2)) AdjustQty , ");
            sb.Append(" TRIM(ROUND(st.UnitPrice*st.InitialCount, 2)) StockAmount, ");
            sb.Append("  st.MajorUnit PurchaseUnit,st.MinorUnit ConsumeUnit,im.packsize PackSize,");


            sb.Append(" DATE_FORMAT(StockDate,'%d-%b-%Y') StockDate, ");
            sb.Append(" st.stockid,st.barcodeno,(select name from employee_master where employee_id=st.PostUserID) UserName");

            sb.Append(" FROM st_nmstock st  ");
            sb.Append(" INNER JOIN st_itemmaster im ON im.ItemID=st.ItemID ");
            if (Items != "[]")
            {
                sb.Append(" and st.itemid in ('" + Util.GetString(Items).Replace("[", "").Replace("]", "") + "')");
            }
            sb.Append(" inner join st_ledgertransaction lt on lt.LedgerTransactionID=st.LedgerTransactionID and lt.TypeOfTnx='StockAdjustment' ");

            sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=im.CategoryTypeID  ");
            sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=im.SubCategoryTypeID  ");
            sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=im.SubCategoryID ");
            sb.Append(" WHERE (st.InitialCount)>0 ");
            sb.Append(" and lt.DateTime >='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append(" and lt.DateTime <='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append("   and st.locationid in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
            if (location != "[]")
            {
                sb.Append(" and st.LocationID in (" + Util.GetString(location).Replace("[", "").Replace("]", "") + ")");
            }


            if (manu != "0")
            {
                sb.Append(" and st.ManufactureID='" + manu + "'");
            }
            if (machine != "0")
            {
                sb.Append(" and st.MacID ='" + machine + "'");
            }


            sb.Append(" UNION ALL ");


            sb.Append(" SELECT 'StockProcess' Type,  st.barcodeno,(SELECT location FROM st_locationmaster WHERE locationid=st.LocationID)StoreLocation, ");
            sb.Append(" cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemTypeName,im.typename ItemName, ");
            sb.Append("(select name from  st_manufacture_master mmmm where mmmm.MAnufactureID=st.ManufactureID)Manufacture,");
            sb.Append("(select name from  macmaster mmmm where mmmm.id=st.macid)Machine,");
            sb.Append(" st.BatchNumber,IF(st.ExpiryDate='0001-01-01','',DATE_FORMAT(expirydate,'%d-%b-%Y')) ExpiryDate, ");
            sb.Append(" TRIM(ROUND(st.Rate,2)) Rate ,TRIM(ROUND(st.UnitPrice,2)) UnitPrice , ");
            sb.Append(" TRIM(ROUND(st.DiscountAmount,2)) DiscountAmount,TRIM(ROUND(st.TaxAmount,2))TaxAmount, ");
            sb.Append(" TRIM(ROUND(sd.Quantity, 2)) * (-1) AdjustQty , ");
            sb.Append(" TRIM(ROUND(st.UnitPrice*sd.Quantity*(-1), 2)) StockAmount, ");
            sb.Append("  st.MajorUnit PurchaseUnit,st.MinorUnit ConsumeUnit,im.packsize PackSize,");


            sb.Append(" DATE_FORMAT(StockDate,'%d-%b-%Y') StockDate ");
            sb.Append(" ,sd.stockid,st.barcodeno,(select name from employee_master where employee_id=sd.UserID) UserName");
            sb.Append(" FROM st_nmstock st  ");
            sb.Append(" INNER JOIN st_itemmaster im ON im.ItemID=st.ItemID ");
            if (Items != "[]")
            {
                sb.Append(" and st.itemid in ('" + Util.GetString(Items).Replace("[", "").Replace("]", "") + "')");
            }
            sb.Append(" inner join st_nmsalesdetails sd on sd.StockID=st.StockID  and TrasactionTypeID = 3 ");

            sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=im.CategoryTypeID  ");
            sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=im.SubCategoryTypeID  ");
            sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=im.SubCategoryID ");
            sb.Append(" WHERE (sd.Quantity)>0 ");
            sb.Append(" and sd.DateTime >='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append(" and sd.DateTime <='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append(" and st.locationid in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
            if (location != "[]")
            {
                sb.Append(" and st.LocationID in (" + Util.GetString(location).Replace("[", "").Replace("]", "") + ")");
            }


            if (manu != "0")
            {
                sb.Append(" and st.ManufactureID='" + manu + "'");
            }
            if (machine != "0")
            {
                sb.Append(" and st.MacID ='" + machine + "'");
            }

            sb.Append(" order by StoreLocation,CategoryTypeName,SubCategoryTypeName,itemTypeName,ItemName,Manufacture,Machine,packsize ");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
           

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





            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = " StockAdjustMentReport_FromDate_" + fromdate + "_ToDate_" + todate;
            return "1";
        }
        else
        {
            return "No Record Found";
        }
    }
    
}
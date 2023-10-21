using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_UnmappedStock : System.Web.UI.Page
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
            sb.Append("  SELECT locationid locationid,location FROM st_locationmaster WHERE isactive=1   ");
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
    public static string SearchData(string locationid, string type)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" select *,if(t.Mapped_UnMapped='Mapped','#90EE90','bisque') rowcolor from (  ");
        sb.Append("  SELECT sl.`Location`, ssm1.CategoryTypeName CategoryType, sm1.SubCategoryTypeName SubCategoryType,ssm.Name ItemType, ");
        sb.Append("    im.typename Itemname,st.Itemname Itemname1, ");
        
        sb.Append("  im.`ManufactureName`,im.`MachineName`,im.`PackSize`,im.`CatalogNo`,im.`HsnCode`,im.`MajorUnitName`,im.`MinorUnitName`,im.`Converter`, ");
        sb.Append("  st.`BatchNumber`,st.`BarcodeNo`,IFNULL(DATE_FORMAT(st.ExpiryDate,'%d-%b-%Y'),'')ExpiryDate, ");
        sb.Append("  (`InitialCount` - `ReleasedCount` - `PendingQty` ) InhandQty,rate,st.`TaxPer`,st.`DiscountPer`,st.`UnitPrice`, ");
        sb.Append("  IF(IFNULL(smm.id,'')='','UnMapped','Mapped')Mapped_UnMapped,IF(IFNULL(smm.ispiitem,'0')=0,'','PI Item') IsPIItem ");
        sb.Append("  FROM st_nmstock st ");
        sb.Append(" INNER JOIN st_itemmaster im ON st.itemid=im.`ItemID` ");
        sb.Append(" INNER JOIN st_locationmaster sl ON sl.`LocationID`=st.`LocationID`  ");
        sb.Append("   INNER JOIN `st_categorytypemaster` ssm1 ON ssm1.CategoryTypeID=im.CategoryTypeID  ");
        sb.Append("   INNER JOIN `st_subcategorymaster` ssm ON ssm.SubCategoryID=im.SubCategoryID  ");
        sb.Append("   INNER JOIN `st_subcategorytypemaster` sm1 ON sm1.SubCategoryTypeID=im.SubCategoryTypeID  ");

        sb.Append(" LEFT JOIN st_mappingitemmaster smm ON st.`ItemId`=smm.`ItemID`   ");
        sb.Append("  AND st.`LocationID`=smm.`LocationId` ");
        sb.Append(" where st.locationid='" + locationid + "' and (`InitialCount` - `ReleasedCount` - `PendingQty` ) >0 order by itemname) t");

        if (type != "")
        {
            sb.Append(" where t.Mapped_UnMapped='" + type + "'");
        }



        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(string locationid, string type)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" select * from ( SELECT sl.`Location`, ssm1.CategoryTypeName CategoryType, sm1.SubCategoryTypeName SubCategoryType,ssm.Name ItemType, ");
        sb.Append("    im.typename Itemname, ");
        sb.Append("  im.`ManufactureName`,im.`MachineName`,im.`PackSize`,im.`CatalogNo`,im.`HsnCode`,im.`MajorUnitName`,im.`MinorUnitName`,im.`Converter`, ");
        sb.Append("  st.`BatchNumber`,st.`BarcodeNo`,IFNULL(DATE_FORMAT(st.ExpiryDate,'%d-%b-%Y'),'')ExpiryDate, ");
        sb.Append("  (`InitialCount` - `ReleasedCount` - `PendingQty` ) InhandQty,rate,st.`TaxPer`,st.`DiscountPer`,st.`UnitPrice`, ");
        sb.Append("  IF(IFNULL(smm.id,'')='','UnMapped','Mapped')Mapped_UnMapped,IF(IFNULL(smm.ispiitem,'0')=0,'','PI Item') IsPIItem ");
        sb.Append("  FROM st_nmstock st ");
        sb.Append(" INNER JOIN st_itemmaster im ON st.itemid=im.`ItemID` ");
        sb.Append(" INNER JOIN st_locationmaster sl ON sl.`LocationID`=st.`LocationID`  ");
        sb.Append("   INNER JOIN `st_categorytypemaster` ssm1 ON ssm1.CategoryTypeID=im.CategoryTypeID  ");
        sb.Append("   INNER JOIN `st_subcategorymaster` ssm ON ssm.SubCategoryID=im.SubCategoryID  ");
        sb.Append("   INNER JOIN `st_subcategorytypemaster` sm1 ON sm1.SubCategoryTypeID=im.SubCategoryTypeID  ");

        sb.Append(" LEFT JOIN st_mappingitemmaster smm ON st.`ItemId`=smm.`ItemID`   ");
        sb.Append("  AND st.`LocationID`=smm.`LocationId` ");
        sb.Append(" where st.locationid='" + locationid + "' and (`InitialCount` - `ReleasedCount` - `PendingQty` ) >0 order by itemname) t");

        if (type != "")
        {
            sb.Append(" where t.Mapped_UnMapped='" + type + "'");
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
            HttpContext.Current.Session["ReportName"] = "MappedUnMapped";
            return "true";
        }
        else
        {
            return "false";
        }
    }
}

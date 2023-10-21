using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Linq;
using System.Web.UI;


public partial class Design_Store_VendorRetrunSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (UserInfo.AccessStoreLocation != "")
            {

                txtdatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                txtdateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");

                StringBuilder sb = new StringBuilder();
                sb.Append("  SELECT locationid locationid,location FROM st_locationmaster WHERE isactive=1   ");
                sb.Append(" AND locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


                sb.Append(" ORDER BY location ");
                lstlocation.DataSource = StockReports.GetDataTable(sb.ToString());
                lstlocation.DataTextField = "location";
                lstlocation.DataValueField = "locationid";
                lstlocation.DataBind();

               

                lstsupplier.DataSource = StockReports.GetDataTable("SELECT supplierid,suppliername FROM `st_vendormaster` WHERE isactive=1 ORDER BY suppliername ASC ");
                lstsupplier.DataTextField = "suppliername";
                lstsupplier.DataValueField = "supplierid";
                lstsupplier.DataBind();
               

            }
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string locationid, string supplierid, string fromdate, string todate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT stv.`VendorReturnNo`, stv.`VendorID`,sv.`Suppliername` ,stv.`LocationID`,sl.location,st.`ItemName`,st.`BatchNumber`, ");
        sb.Append(" DATE_FORMAT(st.`ExpiryDate`,'%d-%b-%Y') ExpiryDate,st.`Rate`,st.`DiscountAmount`,st.taxamount,st.`UnitPrice`, ");
        sb.Append(" stv.Remark,stv.`UserName`,DATE_FORMAT(stv.EntryDateTime,'%d-%b-%Y')`EntryDateTime`,stv.`ReturnQty`,st.`MinorUnit` ");
        sb.Append(" FROM st_vendor_return stv ");
        sb.Append(" INNER JOIN `st_vendormaster` sv ON sv.`SupplierID`=stv.`VendorID`  ");
        sb.Append(" INNER JOIN st_locationmaster sl ON sl.LocationID=stv.`LocationID`  ");
        sb.Append(" INNER JOIN st_nmstock st ON st.`StockID`=stv.`StockID` AND st.`ItemID`=stv.`ItemID` ");
        sb.Append(" where stv.EntryDateTime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" and stv.EntryDateTime<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" and stv.`LocationID` in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "')");
        if (locationid != "")
        {
            sb.Append(" and stv.`LocationID` in ("+locationid+")");

        }
        if (supplierid != "")
        {
            sb.Append(" and stv.`VendorID` in (" + supplierid + ")");

        }
        sb.Append(" order BY VendorReturnNo,itemname ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string ExcelReport(string locationid, string supplierid, string fromdate, string todate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT stv.`VendorReturnNo`, stv.`VendorID` SupplierID,sv.`Suppliername` ,stv.`LocationID`,sl.location,st.`ItemName`,st.`BatchNumber`, ");
        sb.Append(" DATE_FORMAT(st.`ExpiryDate`,'%d-%b-%Y') ExpiryDate,stv.`ReturnQty`,st.`MinorUnit`,st.`Rate`,st.`DiscountAmount`,st.taxamount,st.`UnitPrice`, ");
        sb.Append(" stv.Remark,stv.`UserName`,DATE_FORMAT(stv.EntryDateTime,'%d-%b-%Y')`ReturnDateTime` ");
        sb.Append(" FROM st_vendor_return stv ");
        sb.Append(" INNER JOIN `st_vendormaster` sv ON sv.`SupplierID`=stv.`VendorID`  ");
        sb.Append(" INNER JOIN st_locationmaster sl ON sl.LocationID=stv.`LocationID`  ");
        sb.Append(" INNER JOIN st_nmstock st ON st.`StockID`=stv.`StockID` AND st.`ItemID`=stv.`ItemID` ");
        sb.Append(" where stv.EntryDateTime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" and stv.EntryDateTime<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" and stv.`LocationID` in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "')");
        if (locationid != "")
        {
            sb.Append(" and stv.`LocationID` in (" + locationid + ")");

        }
        if (supplierid != "")
        {
            sb.Append(" and stv.`VendorID` in (" + supplierid + ")");

        }
        sb.Append(" order BY VendorReturnNo,itemname ");

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
            HttpContext.Current.Session["ReportName"] = "VendorReturnList";
            return "true";
        }
        else
        {
            return "false";
        }
    }
}
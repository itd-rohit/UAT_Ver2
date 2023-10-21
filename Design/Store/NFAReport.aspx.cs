using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_NFAReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txttodate);

            bindalldata();
        }
        
    }

    void bindalldata()
    {
        if (UserInfo.AccessStoreLocation != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT concat(locationid,'#',Panel_ID) locationid,location FROM st_locationmaster WHERE isactive=1   ");
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



            ddlsupplier.DataSource = StockReports.GetDataTable("SELECT SupplierID,suppliername FROM st_vendormaster WHERE isactive=1 ORDER BY suppliername ");
      
            ddlsupplier.DataTextField = "suppliername";
            ddlsupplier.DataValueField = "SupplierID";
            ddlsupplier.DataBind();

            ddlsupplier.Items.Insert(0, new ListItem("Select","0"));
           
        }

    }




    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindindentno(string locationid, string fromdate, string todate, string pendingpionly)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select  si.IndentNo from st_indent_detail si  ");

        sb.Append("  where si.isactive=1 and si.vendorid<>0 and IndentType='PI' ");
        sb.Append("  and si.dtentry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'");
        sb.Append("  and si.dtentry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'");

       
        sb.Append("  and si.FromLocationID='" + locationid + "'");
        sb.Append(" group by si.IndentNo ");
        if (pendingpionly == "1")
        {
            sb.Append(" having sum(poqty)=0");
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReportPDF(string fromdate, string todate, string LocationID,string supplierid,string indentno)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT sl.`Location` FromLocation,sl1.`Location` ToLocation ,vm.`SupplierName` , ");
        sb.Append("  si.`IndentNo`,DATE_FORMAT(si.`dtEntry`,'%d-%b-%Y') IndentDate, ");
        sb.Append("  sm.typename ItemName, ");
        sb.Append("  sm.`ManufactureName`,sm.`MachineName`,sm.`PackSize`,sm.`CatalogNo`,sm.`HsnCode`,sm.`MajorUnitName`, ");
        sb.Append("  trimzero(IF(si.`ApprovedQty`=0,IF(si.`CheckedQty`=0,si.`ReqQty`,si.`CheckedQty`),si.`ApprovedQty`))Qty, ");
        sb.Append("  trimzero(si.`Rate`) Rate,si.Rate Rate1, ");
        sb.Append("  trimzero((si.`TaxPerCGST`+si.`TaxPerSGST`+si.`TaxPerIGST`)) TaxPer, ");
        sb.Append("  (si.`TaxPerCGST`+si.`TaxPerSGST`+si.`TaxPerIGST`) TaxPer1, ");
        sb.Append("  trimzero(si.`DiscountPer`)DiscountPer,si.DiscountPer DiscountPer1, ");
        sb.Append("  trimzero(si.`UnitPrice`)UnitPrice ,si.`UnitPrice` UnitPrice1, ");
        sb.Append("  trimzero(si.`NetAmount`)NetAmount,si.`NetAmount` NetAmount1 ");
        sb.Append("  FROM `st_indent_detail` si ");
        sb.Append("  INNER JOIN st_locationmaster sl ON si.`FromLocationID`=sl.`LocationID` ");
        sb.Append("  INNER JOIN st_locationmaster sl1 ON si.`toLocationID`=sl1.`LocationID` ");
        sb.Append("  INNER JOIN `st_vendormaster` vm ON vm.`SupplierID`=si.`vendorid` ");
        if (supplierid != "0")
        {
            sb.Append(" and vm.SupplierID='" + supplierid + "'");
        }
        sb.Append("  INNER JOIN `st_itemmaster` sm ON sm.`ItemID`=si.`ItemId` ");
        sb.Append("  where si.isactive=1 and si.IndentType='PI' ");
        sb.Append("  and si.dtentry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'");
        sb.Append("  and si.dtentry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'");
        sb.Append("  and si.FromLocationID='" + LocationID + "'");
        if (indentno != "0")
        {
            sb.Append(" and si.IndentNo='" + indentno.Trim() + "'");
        }
        sb.Append("  ORDER BY si.`IndentNo` ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {

            DataColumn dc = new DataColumn("DateRange");
            dc.DefaultValue = "From : " + Util.GetDateTime(fromdate).ToString("dd-MM-yyyy") + " To : " + Util.GetDateTime(todate).ToString("dd-MM-yyyy");
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema(@"E:\NFAReport.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "NFAReport";


            return "true";
        }
        else
        {
            return "false";
        }



    }
}
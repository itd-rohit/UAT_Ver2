using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_InTransitAdjustmentReport : System.Web.UI.Page
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
    public static string GetReport( string fromdate, string todate, string categorytypeid, string subcategorytypeid, string subcategoryid, string itemid, string locationid, string machineid)
    {
       
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT  salesno TransactionNo,Location Location,cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName, ");
            sb.Append(" stn.itemname,stn.stockid,stn.batchnumber,ifnull(DATE_FORMAT(stn.expirydate,'%d-%b-%y'),'') Expirydate, stn.barcodeno,sm.MachineName,snd.TrasactionType AdjustmentType, snd.Quantity AdjustmentQuantity ,stn.unitprice*snd.Quantity AdjustmentAmt, stn.minorunit Unit, ");
            sb.Append(" DATE_FORMAT(DATETIME,'%d-%b-%Y') AdjustmentDate,snd.Naration Remarks,(SELECT NAME FROM employee_master WHERE employee_id=snd.UserID) UserName ");
            sb.Append("  FROM `st_nmsalesdetails` snd ");
            sb.Append(" INNER JOIN `st_locationmaster` slm ON snd.fromlocationid=slm.locationid ");
            sb.Append(" and slm.locationid in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
            if (locationid != "")
            {
                sb.Append(" and slm.locationid in (" + locationid + ")");
            }
            sb.Append(" INNER JOIN st_nmstock stn ON stn.stockid=snd.stockid ");
            sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=stn.itemid ");
            if (itemid != "")
            {
                sb.Append(" and sm.itemid in (" + itemid + ")");
            }
            if (machineid != "")
            {
                sb.Append(" and sm.MachineID in (" + machineid + ")");
            }
            sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID  ");
            if (categorytypeid != "")
            {
                sb.Append(" and cat.CategoryTypeID in (" + categorytypeid + ")");
            }
            sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID  ");
            if (subcategorytypeid != "")
            {
                sb.Append(" and subcat.SubCategoryTypeID in (" + subcategorytypeid + ")");
            }
            sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID   ");
            if (subcategoryid != "")
            {
                sb.Append(" and itemcat.SubCategoryID in (" + subcategoryid + ")");
            }
            sb.Append(" WHERE TrasactionTypeID in(10,11) ");
            sb.Append(" AND snd.DATETIME>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' AND snd.DATETIME<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");

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
                HttpContext.Current.Session["ReportName"] = " StockInTransitAdjustmentReport";
                return "true";
            }
            else
            {
                return "false";
            }
       
    }

}
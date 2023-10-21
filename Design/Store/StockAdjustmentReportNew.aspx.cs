using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_StockAdjustmentReportNew : System.Web.UI.Page
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
    public static string GetReport(string fromdate, string todate, string categorytypeid, string subcategorytypeid, string subcategoryid, string itemid, string locationid, string machineid)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT if(st.approved=1,'Approved','Pending')ApprovalStatus, Location ,cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName, ");
        sb.Append(" sm.typename itemname,sm.MachineName ");
        sb.Append(",st.OldQty,st.NewQty,(st.OldQty-st.NewQty)Difference,st.NewBatch,if(st.NewBatch<>'',DATE_FORMAT(st.NewBatchExpiryDate,'%d-%b-%y'),'') NewBatchExpiryDate ,VerificationRemarks");
        sb.Append(" ,rate,discountper,discountamount,taxper,taxamount,unitprice,(unitprice*st.NewQty) NewStockValue,(SELECT barcodeno FROM st_nmstock WHERE stockid=st.stockid LIMIT 1) Barcodeno,");
        sb.Append(" st.UserName SavedBy,DATE_FORMAT(st.EntryDate,'%d-%b-%y') EntryDate,st.ApprovedByName ApprovedBy,DATE_FORMAT(st.ApprovedDate,'%d-%b-%y') ApprovedDate");
        sb.Append(" from st_StockPhysicalVerification st ");
    
        sb.Append(" INNER JOIN `st_locationmaster` slm ON st.locationid=slm.locationid ");
        //sb.Append(" and slm.locationid in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        if (locationid != "")
        {
            sb.Append(" and slm.locationid in (" + locationid + ")");
        }

        sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=st.itemid ");
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
        sb.Append(" WHERE st.isactive=1  ");

        sb.Append(" AND  if(st.approved=1,st.ApprovedDate,st.entrydate)>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'  ");
        sb.Append(" AND  if(st.approved=1,st.ApprovedDate,st.entrydate)<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
		System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\ads.txt",sb.ToString());
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
            HttpContext.Current.Session["ReportName"] = "StockPhysicalVerificationReport";
            return "true";
        }
        else
        {
            return "false";
        }
    }

}
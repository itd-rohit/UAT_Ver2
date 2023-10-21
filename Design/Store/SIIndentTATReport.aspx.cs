using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_SIIndentTATReport : System.Web.UI.Page
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
    public static string GetReport(string dateoption, string fromdate, string todate, string indentno)
    {
        StringBuilder sb = new StringBuilder();



        sb.Append(" ");
        sb.Append(" SELECT sl.`Location` IndentFromLocation,sl1.`Location` IndentToLocation,  ");
        sb.Append(" sid.`IndentNo`, sid.`ItemID`,sd.`ItemName`,  ");
        sb.Append(" sd.`ApprovedUserName` ApprovedBy,  ");
        sb.Append(" DATE_FORMAT(sd.`ApprovedDate`,'%d-%b-%Y %h:%i %p')IndentCreateDate,  ");
        sb.Append(" sid.`ReceiveByUserName` ReceiveBy, DATE_FORMAT(sid.`ReceiveDate`,'%d-%b-%Y %h:%i %p')  `IndentReceiveDate` ,  ");

        sb.Append("  CONCAT(IF( TIMESTAMPDIFF(DAY,sd.`ApprovedDate`,sid.`ReceiveDate`)=0,'',CONCAT(TIMESTAMPDIFF(DAY,sd.`ApprovedDate`,sid.`ReceiveDate`),' days ')) , ");



        sb.Append(" IF(MOD( TIMESTAMPDIFF(HOUR,sd.`ApprovedDate`,sid.`ReceiveDate`), 24)=0,'',CONCAT(MOD( TIMESTAMPDIFF(HOUR,sd.`ApprovedDate`,sid.`ReceiveDate`), 24), ' hours ')),  ");
        sb.Append(" MOD( TIMESTAMPDIFF(MINUTE,sd.`ApprovedDate`,sid.`ReceiveDate`), 60), ' minutes ' ");
        sb.Append(" )TotalTAT ");





        sb.Append(" FROM `st_indentissuedetail` sid   ");
        sb.Append(" INNER JOIN `st_indent_detail` sd ON sid.`ItemID`=sd.`ItemId` AND sid.`IndentNo`=sd.`IndentNo` AND sd.`IndentType`='SI'  ");
        sb.Append(" AND sid.`ReceiveQty`>0 AND sd.`IsActive`=1   ");
        if (indentno != "")
        {
            sb.Append(" and sid.IndentNo='" + indentno + "'");
        }

        sb.Append(" INNER JOIN `st_locationmaster` sl ON sl.`LocationID`=sd.`FromLocationID`   ");
        sb.Append(" and  sd.FromLocationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        sb.Append(" INNER JOIN `st_locationmaster` sl1 ON sl1.`LocationID`=sd.`ToLocationID`   ");

        sb.Append(" where " + dateoption + ">='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" and " + dateoption + "<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'");
        sb.Append(" ORDER BY sl.`Location`,sl1.`Location`,indentno  ");


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
            HttpContext.Current.Session["ReportName"] = "SIIndentTATReport";
            return "true";
        }
        else
        {
            return "false";
        }

    }
}
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;


public partial class Design_Store_StockInTransitReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromtime.Text = DateTime.Now.ToString("00:00:00");
            txtfromtime.ReadOnly = true;
            txtfromtime0.Text = DateTime.Now.ToString("23:59:59");
            txtfromtime0.ReadOnly = true;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(string fromdate, string todate, string reporttype)
    {

        if (reporttype == "1")
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT IF(sd.IndentNo='','Old In-Transit Data','') Remarks,");
            sb.Append(" lm.`Location` FromLocation,");

            sb.Append(" ");
            sb.Append(" IF(sd.IndentNo='','',lm2.`Location`) ToLocation,");
            sb.Append(" sd.IndentNo,");
            sb.Append(" st.StockID,st.ItemID,st.ItemName,");

            sb.Append(" sd.`TrasactionType`,IF(sd.TrasactionTypeID=8,sd.Quantity,(-1)*sd.Quantity)Quantity,");

            sb.Append(" IF(sd.TrasactionTypeID=8,st.`UnitPrice`,(-1)*st.UnitPrice) UnitPrice,");
            sb.Append(" IF(sd.TrasactionTypeID=8,st.`UnitPrice`* sd.Quantity,(-1)*st.UnitPrice*sd.Quantity) TotalInTransitAmount");
            sb.Append(" ,DATE_FORMAT(sd.DateTime,'%d-%b-%Y') TransferDate");

            sb.Append(" FROM st_nmsalesdetails sd ");
            sb.Append(" INNER JOIN ");
            sb.Append(" (SELECT StockID,SUM(IF(TrasactionTypeID=8,Quantity,(-1)*Quantity)) ");
            sb.Append(" FROM `st_nmsalesdetails` WHERE `TrasactionTypeID` IN (8,9,10,11) ");
            sb.Append(" AND DATETIME <='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 23:59:59'");
            sb.Append(" GROUP BY stockid");
            sb.Append(" HAVING SUM(IF(TrasactionTypeID=8,Quantity,(-1)*Quantity)) > 0 ) aa");
            sb.Append(" ON aa.StockID=sd.StockID");
            sb.Append(" AND sd.`TrasactionTypeID` IN (8,9,10,11) ");
            sb.Append(" AND sd.DATETIME <='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 23:59:59'");
            sb.Append(" INNER JOIN `st_locationmaster` lm ON lm.`LocationID`=sd.`FromLocationID`");
            sb.Append(" and lm.`LocationID` in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
            sb.Append(" INNER JOIN `st_locationmaster` lm2 ON lm2.`LocationID`=sd.`ToLocationID`");
            sb.Append(" INNER JOIN `st_nmstock` st ON st.stockID=sd.`StockID`");
            sb.Append(" ORDER BY sd.`StockID`");

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
                HttpContext.Current.Session["ReportName"] = "StockInTransitReport_Summary";
                return "true";
            }
            else
            {
                return "false";
            }
        }

        else
        {

            StringBuilder sb = new StringBuilder();
            sb.Append("select IndentNo,IssueInvoiceNo,IndentFromLocation,IndentToLocation,");
            sb.Append(" ItemID,TypeName ItemName,StockID,barcodeno,SendQty,ReceiveQty,consumeqty,stockinqty,UnitPrice,TotalIntransitQty,(TotalIntransitQty*UnitPrice) TotalPrice");
            sb.Append(",SendDate,SendByUser,ReceiveDate,ReceiveByUser,DispatchStatus,BatchNumber,BatchCreatedDate,BatchCreatedByUser,CourierName,AWBNumber,NoofBoxSend,NoofBoxReceive from (");
            sb.Append(" SELECT sid.`IndentNo`,sid.`IssueInvoiceNo`, ");
          //  sb.Append(" (select approvedqty from st_indent_detail id where id.indentno= sid.`IndentNo` and id.itemid=sid.itemid) IndentQty, ");
             sb.Append("(select FromLocationID from st_indent_detail id where id.indentno=sid.`IndentNo` limit 1)fromLocationID, ");
            sb.Append(" (select location from st_indent_detail id inner join st_locationmaster sl on sl.LocationID=id.`FromLocationID` where id.indentno= sid.`IndentNo` and id.itemid=sid.itemid limit 1) IndentFromLocation ,");
            sb.Append(" (select location from st_indent_detail id inner join st_locationmaster sl on sl.LocationID=id.`toLocationID` where id.indentno= sid.`IndentNo` and id.itemid=sid.itemid limit 1) IndentToLocation, ");

            sb.Append(" im.`ItemID`,im.`TypeName`,sid.`StockID`,sid.barcodeno, ");
            sb.Append(" sid.`SendQty`,sid.ReceiveQty,sid.consumeqty,sid.stockinqty ,");
            sb.Append(" (sid.sendqty-sid.`ReceiveQty`-sid.consumeqty-sid.stockinqty) TotalIntransitQty");
            sb.Append(" ,(select UnitPrice from st_nmstock where stockid=sid.`StockID`) UnitPrice");
            sb.Append(" ,DATE_FORMAT(sid.DateTime,'%d-%b-%Y') SendDate,");

            sb.Append(" (SELECT Name FROM employee_master WHERE Employee_ID=sid.userid) SendByUser ");
            sb.Append(" ,ifnull(DATE_FORMAT(sid.receivedate,'%d-%b-%Y'),'') ReceiveDate,ifnull(ReceiveByUserName,'')ReceiveByUser ");

            sb.Append(" ,(case when DispatchStatus=0 then 'Pending For Dispatch'  when DispatchStatus=1 then 'Dispatched' when DispatchStatus=2 then 'Delivered' else 'Received' end) DispatchStatus");
            sb.Append(" ,sid.BatchNumber,DATE_FORMAT(sid.BatchCreatedDateTime,'%d-%b-%Y')BatchCreatedDate,BatchCreatedByName BatchCreatedByUser,CourierName,AWBNumber,NoofBox NoofBoxSend,");
            sb.Append(" TotalWeight,ConsignmentNote,Temperature,FieldBoyName,OtherName,NoofBoxReceive");
            sb.Append(" FROM `st_indentissuedetail` sid  ");
            sb.Append(" INNER JOIN st_itemmaster im ON sid.`ItemID`=im.`ItemID`  ");


            sb.Append(" WHERE (sid.sendqty-sid.`ReceiveQty`-sid.consumeqty-sid.stockinqty)>0  ");




            sb.Append("  AND sid.`DateTime`>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append("  AND sid.`DateTime`<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'  ");


            sb.Append(" ORDER BY IndentFromLocation,IndentToLocation ) t ");
            sb.Append(" where t.fromLocationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");

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
                HttpContext.Current.Session["ReportName"] = "StockInTransitReport_Detail";
                return "true";
            }
            else
            {
                return "false";
            }
        }


       
       
       

    }

}
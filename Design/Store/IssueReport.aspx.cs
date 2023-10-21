using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_IssueReport : System.Web.UI.Page
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
    public static string GetReport(string type, string fromdate, string todate, string categorytypeid, string subcategorytypeid, string subcategoryid, string itemid, string locationid, string machineid, string dateoption, string issuetype, string indentno, string reportType)
    {

        string ReportPath = string.Empty;
        String ReportDisplayName = string.Empty;
        if (type == "1")
            ReportDisplayName = "Issue Report Detail";
        else if (type == "2")
            ReportDisplayName = "Issue Report Item Summary";
        else
            ReportDisplayName = "Issue Report Amt Summary";
        if (reportType == "PDF")
        {
            ReportPath = "IssueReportPDF.aspx";
        }
        else
        {
            ReportPath = "../Common/ExportToExcelEncrypt.aspx";
        }
        try
        {
            return JsonConvert.SerializeObject(new
            {
                status = true,
                Type = Common.EncryptRijndael(Util.GetString(type)),
                FromDate = Common.EncryptRijndael(fromdate),
                ToDate = Common.EncryptRijndael(todate),
                CategoryTypeID = Common.EncryptRijndael(categorytypeid),
                SubCategoryTypeID = Common.EncryptRijndael(subcategorytypeid),
                SubCategoryID = Common.EncryptRijndael(subcategoryid),
                ItemID = Common.EncryptRijndael(itemid),
                LocationID = Common.EncryptRijndael(locationid),
                MachineID = Common.EncryptRijndael(machineid),
                DateOption = Common.EncryptRijndael(dateoption),
                IssueType = Common.EncryptRijndael(issuetype),
                IndentNo = Common.EncryptRijndael(indentno),
                ReportType = Common.EncryptRijndael("IssueReport"),
                ReportDisplayName = Common.EncryptRijndael(ReportDisplayName),
                IsAutoIncrement = Common.EncryptRijndael("1"),
                ReportPath = ReportPath
            });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new
            {
                status = false

            });
        }

        if (dateoption == "1")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT salesno TransactionNo,snd.IndentNo,slm.Location FromLocation,sm12.state FromLocationState,slm1.location ToLocation ,sm121.state ToLocationState,cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName, ");
            sb.Append(" sm.typename itemname,sm.HsnCode,stn.barcodeno,sm.MachineName,sm.ManufactureName,sm.packsize");
            sb.Append(" ,DATE_FORMAT(stn.`ExpiryDate`,'%d-%b-%Y')ExpiryDate,stn.BatchNumber,");
            sb.Append(" (SELECT group_concat(DISTINCT issueinvoiceno) FROM st_indentissuedetail WHERE stockid=snd.stockid and indentno=snd.indentno)Issueinvoiceno,");
            sb.Append(" snd.Quantity ReceiveQuantity , (stn.rate*snd.Quantity)Rate,(stn.DiscountAmount*snd.Quantity) DiscountAmt,stn.taxper, (stn.unitprice*snd.Quantity) ReceiveAmt,stn.minorunit ReceiveUnit,");

            sb.Append("  (stn.taxamount*snd.Quantity) TaxAmount,");
            sb.Append("  if(sm12.state=sm121.state,0,(stn.taxamount*snd.Quantity)) TaxAmtIGST,");
            sb.Append("  if(sm12.state<>sm121.state,0,(stn.taxamount*snd.Quantity)/2) TaxAmtCGST,");
            sb.Append("  if(sm12.state<>sm121.state,0,(stn.taxamount*snd.Quantity)/2)  TaxAmtSGST,");
            sb.Append(" snd.IssueType,");
            sb.Append(" DATE_FORMAT(DATETIME,'%b-%Y') ReceiveMonth, ");

            sb.Append(" DATE_FORMAT(DATETIME,'%d-%b-%Y') ReceiveDate,snd.Naration Remarks,(SELECT NAME FROM employee_master WHERE employee_id=snd.UserID) UserName ");


            sb.Append("  FROM `st_nmsalesdetails` snd ");
            sb.Append(" INNER JOIN `st_locationmaster` slm ON snd.fromlocationid=slm.locationid ");
            sb.Append(" and slm.locationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
            if (locationid != "")
            {
                sb.Append(" and slm.locationid in (" + locationid + ")");
            }



            sb.Append(" INNER JOIN st_locationmaster slm1 ON slm1.locationid=snd.tolocationid ");


            sb.Append("  inner join state_master sm12 on   sm12.id=slm.StateID ");



            sb.Append("  inner join state_master sm121 on   sm121.id=slm1.StateID ");


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
            sb.Append(" WHERE TrasactionTypeID=2  ");
            if (issuetype != "0")
            {
                sb.Append(" and snd.IssueType='" + issuetype + "' ");
            }
            if (indentno == "")
            {
                sb.Append(" AND snd.DATETIME>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' AND snd.DATETIME<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            }
            else
            {
                sb.Append(" and snd.indentno='" + indentno.Trim() + "' ");
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
                HttpContext.Current.Session["ReportName"] = "IssueReportDetail";
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

            sb.Append(" SELECT sid.id, sid.indentno,sid.issueinvoiceno, ");
            sb.Append(" sm12.state FromState, ");
            sb.Append(" sl1.location FromLocation ,");
            sb.Append(" sm121.state toState, ");
            sb.Append(" sl2.location ToLocation,");
            sb.Append(" cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName,TypeName ItemName,im.hsncode,");
            sb.Append(" barcodeno,");

            sb.Append(" (SELECT DATE_FORMAT(`ExpiryDate`,'%d-%b-%Y') FROM st_nmstock WHERE stockid=sid.stockid)ExpiryDate,");
            sb.Append(" (SELECT BatchNumber FROM st_nmstock WHERE stockid=sid.stockid)BatchNumber,");


            sb.Append(" sendqty IssueQty,sendqty*(SELECT unitprice FROM st_nmstock WHERE stockid=sid.stockid) IssueAmount,");
            sb.Append(" (sid.receiveqty)ReceiveQty, ");
            sb.Append(" (sid.receiveqty)*(SELECT unitprice FROM st_nmstock WHERE stockid=sid.stockid) ReceiveAmount,");

            sb.Append(" (sid.consumeqty)ConsumeqtyFromPending, ");
            sb.Append(" (sid.consumeqty)*(SELECT unitprice FROM st_nmstock WHERE stockid=sid.stockid) ConsumeAmountFromPending,");
            sb.Append(" (sid.stockinqty)StockInQty, ");
            sb.Append(" (sid.stockinqty)*(SELECT unitprice FROM st_nmstock WHERE stockid=sid.stockid) StockInAmount,");
            sb.Append(" (sendqty-(sid.receiveqty+consumeqty+stockinqty)) InTransitQty,");
            sb.Append(" (sendqty-(sid.receiveqty+consumeqty+stockinqty))*(SELECT unitprice FROM st_nmstock WHERE stockid=sid.stockid) InTransitAmount,");
            sb.Append(" DATE_FORMAT(sid.datetime,'%b-%Y') IssueMonth, ");
            sb.Append(" DATE_FORMAT(sid.datetime,'%d-%m-%Y') IssueDateTime, pendingremarks,");

            sb.Append(" DATE_FORMAT(sid.dispatchdate,'%d-%m-%Y') DispatchDate,dispatchbyusername DispatchBy,");
            sb.Append(" DATE_FORMAT(sid.ReceiveDate,'%d-%m-%Y') BatchReceiveDate,ReceiveByUserName BatchReceiveBy ");

            sb.Append(" FROM st_indentissuedetail sid ");

            sb.Append(" INNER JOIN (SELECT indentno,tolocationid,fromlocationid FROM st_indent_detail sttd  GROUP BY indentno ) sttd ON sttd.indentno=sid.indentno ");
            sb.Append(" INNER JOIN st_locationmaster sl1 ON sl1.locationid=sttd.tolocationid ");
            sb.Append(" and sl1.locationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
            if (locationid != "")
            {
                sb.Append(" and sl1.locationid in (" + locationid + ")");
            }

            sb.Append(" INNER JOIN st_locationmaster sl2 ON sl2.locationid=sttd.fromlocationid ");


            sb.Append("  inner join state_master sm12 on   sm12.id=sl1.StateID ");
            sb.Append("  inner join state_master sm121 on   sm121.id=sl2.StateID ");




            sb.Append(" INNER JOIN st_itemmaster im ON sid.itemid=im.itemid ");
            if (itemid != "")
            {
                sb.Append(" and im.itemid in (" + itemid + ")");
            }
            if (machineid != "")
            {
                sb.Append(" and im.MachineID in (" + machineid + ")");
            }
            sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=im.CategoryTypeID  ");
            if (categorytypeid != "")
            {
                sb.Append(" and cat.CategoryTypeID in (" + categorytypeid + ")");
            }
            sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=im.SubCategoryTypeID  ");
            if (subcategorytypeid != "")
            {
                sb.Append(" and subcat.SubCategoryTypeID in (" + subcategorytypeid + ")");
            }
            sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=im.SubCategoryID   ");
            if (subcategoryid != "")
            {
                sb.Append(" and itemcat.SubCategoryID in (" + subcategoryid + ")");
            }
            if (indentno == "")
            {
                sb.Append(" where sid.datetime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' AND sid.datetime<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            }
            else
            {
                sb.Append(" where sid.indentno='" + indentno.Trim() + "' ");
            }
           

          
            sb.Append(" ORDER BY id ");

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
                HttpContext.Current.Session["ReportName"] = "IssueReportDetailFromIssueDate";
                return "true";
            }
            else
            {
                return "false";
            }
        }

    }
}
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_DirectIssueandTransferReprint : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
           
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string fromdate, string todate, string indentno)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" ");
        sb.Append("   SELECT  ifnull(group_concat(distinct sid.IssueInvoiceNo),'')IssueInvoiceNo, tolocationid,std.indentno,(SELECT location FROM st_locationmaster WHERE locationid=tolocationid)ToLocation, ");
        sb.Append("  (SELECT location FROM st_locationmaster WHERE locationid=fromlocationid)FromLocation,");
        sb.Append("  DATE_FORMAT(dtentry,'%d-%b-%Y') IndentDate,Username,");


        sb.Append("  (CASE   ");
        sb.Append("  WHEN sum(sid.sendqty)= (sum(sid.ReceiveQty)+sum(sid.ConsumeQty)+sum(sid.StockInQty))  THEN '#90EE90'   ");
        sb.Append("  WHEN sum(sid.sendqty)>(sum(sid.ReceiveQty)+sum(sid.ConsumeQty)+sum(sid.StockInQty)) and sum(sid.ReceiveQty)>0 THEN 'Yellow' ");
        sb.Append("  else   'white'  END ) `Rowcolor` ,");


        sb.Append("  (CASE   ");
        sb.Append("  WHEN sum(sid.sendqty)=(sum(sid.ReceiveQty)+sum(sid.ConsumeQty)+sum(sid.StockInQty))  THEN 'Received'   ");
        sb.Append("  WHEN sum(sid.sendqty)>(sum(sid.ReceiveQty)+sum(sid.ConsumeQty)+sum(sid.StockInQty)) and sum(sid.ReceiveQty)>0 THEN 'Partial Received' ");
        sb.Append("   else   'Pending For Received'  END ) `Status` ");


        sb.Append(" ,Narration, ");
        sb.Append(" IF(`ExpectedDate`='0001-01-01','',DATE_FORMAT(ExpectedDate,'%d-%b-%Y')) ExpectedDate");

        sb.Append("  FROM st_indent_detail std  ");
        sb.Append(" inner join st_indentissuedetail sid on std.itemid=sid.itemid and std.indentno=sid.indentno and sid.DispatchStatus=3 ");
        sb.Append(" where std.indentno<>'' and  std.indenttype in('Dir') ");

        sb.Append(" and dtentry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" and dtentry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");

        


        if (indentno != "")
        {
            sb.Append(" AND std.indentno='" + indentno + "'");
        }

        sb.Append("  GROUP BY std.indentno ORDER BY std.IndentNo");
       

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

}
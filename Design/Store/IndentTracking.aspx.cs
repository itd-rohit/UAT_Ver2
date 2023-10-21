using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_IndentTracking : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindItemDetail(string IndentNo)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT IF(indenttype='Dir','Direct',indenttype)indenttype, indentno,itemid,itemname, DATE_FORMAT(dtentry,'%d-%b-%Y') IndentDate, ");
        sb.Append(" (SELECT location FROM st_locationmaster WHERE locationid=fromlocationid)FromLocation, ");
        sb.Append(" (SELECT location FROM st_locationmaster WHERE locationid=tolocationid) ToLocation, ");
        sb.Append(" reqqty,checkedqty,approvedqty,rejectqty, ");
        sb.Append(" IFNULL((SELECT SUM(sendqty) FROM `st_indentissuedetail` WHERE indentno=sd.indentno AND itemid=sd.itemid),0) IssueQty, ");
        sb.Append(" IFNULL((SELECT SUM(ReceiveQty) FROM `st_indentissuedetail` WHERE indentno=sd.indentno AND itemid=sd.itemid),0) ReceiveQty ");
        sb.Append("  FROM st_indent_detail sd WHERE indentno='" + IndentNo + "' AND isactive=1 ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string binddispatchdetail(string IndentNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT indentno,issueinvoiceno,itemid,(SELECT typename FROM st_itemmaster WHERE itemid=sid.itemid) Itemname,stockid,sendqty,receiveqty,DATE_FORMAT(DATETIME,'%d-%b-%Y') senddate ,");
        sb.Append(" (SELECT NAME FROM employee_master WHERE employee_id=userid)sendby,ifnull(BatchNumber,'')BatchNumber,ifnull(DATE_FORMAT(BatchCreatedDateTime,'%d-%b-%Y'),'') BatchCreatedDateTime,ifnull(BatchCreatedByName,'')BatchCreatedByName,");
        sb.Append(" ifnull(NoofBox,'')NoofBox,ifnull(TotalWeight,'')TotalWeight,ifnull(ConsignmentNote,'')ConsignmentNote,ifnull(Temperature,'')Temperature,ifnull(DispatchOption,'')DispatchOption,ifnull(DATE_FORMAT(DispatchDate,'%d-%b-%Y'),'')DispatchDate,ifnull(CourierName,'')CourierName,ifnull(AWBNumber,'')AWBNumber,FieldBoyID,FieldBoyName,");
        sb.Append(" ifnull(DATE_FORMAT(ReceiveDate,'%d-%b-%Y'),'') ReceiveDate,");
        sb.Append(" ReceiveByUserName,ifnull(NoofBoxReceive,'')NoofBoxReceive");

        sb.Append(" FROM st_indentissuedetail sid");

        sb.Append(" where indentno='" + IndentNo + "'");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
}
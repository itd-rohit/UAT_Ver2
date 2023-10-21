using MySql.Data.MySqlClient;
using Newtonsoft.Json;
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

public partial class Design_Store_VendorPortal_SearchAllPO : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string searchdata(string fromdate, string todate, string postatus, string ponumber)
    {

        if (HttpContext.Current.Session["SupplierID"] == null)
        {
            return "-1";
        }


        StringBuilder sb = new StringBuilder();
        sb.Append(" select * from (");
        sb.Append(" SELECT ifnull(so.vendorcomment,'')vendorcomment, so.IsVendorAccept, ");

        sb.Append(" (CASE WHEN so.IsVendorAccept=0 THEN  'white' ");
        sb.Append("  WHEN so.IsVendorAccept=1 AND SUM(VendorIssueQty)=0 THEN 'pink' ");
        sb.Append("  WHEN SUM(VendorIssueQty)>0 AND SUM(GRNQty)=0 THEN 'lightgreen'");
        sb.Append("  WHEN SUM(VendorIssueQty)<>SUM(GRNQty) AND SUM(GRNQty)>0 THEN 'yellow'");
        sb.Append("  ELSE   '#00FFFF'   ");
        sb.Append("  END)  rowColor,");


        sb.Append(" (CASE WHEN so.IsVendorAccept=0 THEN  'New' ");
        sb.Append("  WHEN so.IsVendorAccept=1 AND SUM(VendorIssueQty)=0 THEN 'Accepted' ");
        sb.Append("  WHEN SUM(VendorIssueQty)>0 AND SUM(GRNQty)=0 THEN 'Issued'");
        sb.Append("  WHEN SUM(VendorIssueQty)<>SUM(GRNQty) AND SUM(GRNQty)>0 THEN 'Partial GRN'");
        sb.Append("  ELSE   'GRN'   ");
        sb.Append("  END)  postatus,");
        sb.Append(" so.PurchaseOrderID,so.PurchaseOrderNo,DATE_FORMAT(so.CreatedDate,'%d-%b-%Y')PODate,GrossTotal,DiscountOnTotal,so.TaxAmount,NetTotal, ");
        sb.Append(" sl.`Location`,sl.`ContactPerson`,sl.`ContactPersonNo`,DATE_FORMAT(so.VendorAcceptDateTime,'%d-%b-%Y') VendorAcceptDateTime ");
        sb.Append(" FROM ");
        sb.Append(" st_purchaseorder so  ");
        sb.Append(" INNER JOIN `st_locationmaster` sl ON so.`LocationID`=sl.`LocationID` ");
        sb.Append(" INNER join st_purchaseorder_details spod on spod.PurchaseOrderID=so.PurchaseOrderID ");

        sb.Append(" WHERE vendorid='" + HttpContext.Current.Session["SupplierID"].ToString() + "' AND actiontype='Approval' ");
        if (ponumber == "")
        {
            sb.Append(" and so.ApprovedDate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append(" and so.ApprovedDate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        }
        else
        {
            sb.Append(" and so.PurchaseOrderNo='" + ponumber + "' ");
        }
        sb.Append(" group by so.PurchaseOrderID");
        sb.Append(" order by so.VendorAcceptDateTime) t");
        if (postatus == "0")
        {
            sb.Append(" where t.postatus='New' ");
        }
        if (postatus == "1")
        {
            sb.Append(" where t.postatus='Accepted' ");
        }
        else if (postatus == "2")
        {
            sb.Append(" where t.postatus='Issued' ");
        }
        else if (postatus == "3")
        {
            sb.Append(" where t.postatus='Partial GRN' ");
        }
        else if (postatus == "4")
        {
            sb.Append(" where t.postatus='GRN' ");
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));


    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindItemDetail(string POID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT PurchaseOrderID,PurchaseOrderNo,ifnull(vendorcommentitem,'')vendorcommentitem, VendorIssueQty, (case when (approvedqty-RejectQtyByUser-VendorIssueQty)>0 then 'white' else 'lightgreen' end) Rowcolor ,itemid,itemname,`MAnufactureID`,`ManufactureName`,machineid,machinename,packsize,approvedqty,rate,taxamount,discountamount ,netamount, ");
        sb.Append("IFNULL((SELECT percentage FROM `st_purchaseorder_tax`  WHERE purchaseorderid=pod.purchaseorderid AND itemid=pod.itemid AND taxname='IGST'),0)  IGSTPer,");
        sb.Append("IFNULL((SELECT percentage FROM `st_purchaseorder_tax`  WHERE purchaseorderid=pod.purchaseorderid AND itemid=pod.itemid AND taxname='CGST'),0) CGSTPer, ");
        sb.Append("IFNULL((SELECT percentage FROM `st_purchaseorder_tax`  WHERE purchaseorderid=pod.purchaseorderid AND itemid=pod.itemid AND taxname='SGST'),0) SGSTPer, ");

        sb.Append(" grnqty grnqty,(VendorIssueQty-grnqty) MisMatchQty ");

        sb.Append(", ifnull((select concat(IssueQty,'#',DATE_FORMAT(IssueDateTime,'%d-%b-%Y')) from  st_purchaseorder_details_vendor where  Itemid=pod.Itemid and PurchaseOrderID=pod.PurchaseOrderID order by id desc limit 1),'')lastissueqty");


        sb.Append(" FROM `st_purchaseorder_details` pod WHERE isactive=1 AND `PurchaseOrderID`=" + POID + "  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public static string encryptPurchaseOrderID(string ImageToPrint, string PurchaseOrderID)
    {
        List<string> addEncrypt = new List<string>();
        addEncrypt.Add(Common.Encrypt(ImageToPrint));
        addEncrypt.Add(Common.Encrypt(PurchaseOrderID));
        return JsonConvert.SerializeObject(addEncrypt);
    }
}
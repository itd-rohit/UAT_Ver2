using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_VendorPortal_VendorData : System.Web.UI.Page
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
        sb.Append(" SELECT so.IsVendorAccept,(case when so.IsVendorAccept=0 then  'white' when so.IsVendorAccept=1 then 'pink' else 'lightgreen' end)   rowColor, ");
        sb.Append(" (case when so.IsVendorAccept=0 then  'New' when so.IsVendorAccept=1 then 'Accepted' else 'Issued' end) postatus,");
        sb.Append(" PurchaseOrderID,PurchaseOrderNo,DATE_FORMAT(so.CreatedDate,'%d-%b-%Y')PODate,GrossTotal,DiscountOnTotal,TaxAmount,NetTotal, ");
        sb.Append(" sl.`Location`,sl.`ContactPerson`,sl.`ContactPersonNo`,DATE_FORMAT(so.VendorAcceptDateTime,'%d-%b-%Y') VendorAcceptDateTime ");
        sb.Append(" FROM ");
        sb.Append(" st_purchaseorder so  ");
        sb.Append(" INNER JOIN `st_locationmaster` sl ON so.`LocationID`=sl.`LocationID` ");
        sb.Append(" WHERE vendorid='" + HttpContext.Current.Session["SupplierID"].ToString()+ "' AND actiontype='Approval' ");

        if (ponumber == "")
        {
            sb.Append(" and so.ApprovedDate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append(" and so.ApprovedDate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");

        }
        else
        {
            sb.Append(" and so.PurchaseOrderNo='" + ponumber + "' ");
        }
        if (postatus == "0")
        {
            sb.Append(" and so.IsVendorAccept=0");
        }
        if (postatus == "1")
        {
            sb.Append(" and so.IsVendorAccept=1");
        }
        sb.Append(" order by so.CreatedDate");
       
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));


    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindItemDetail(string POID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT itemid,itemname,`MAnufactureID`,`ManufactureName`,machineid,machinename,packsize,approvedqty,rate,taxamount,discountamount ,netamount, ");
        sb.Append("IFNULL((SELECT percentage FROM `st_purchaseorder_tax`  WHERE purchaseorderid=pod.purchaseorderid AND itemid=pod.itemid AND taxname='IGST'),0)  IGSTPer,");
        sb.Append("IFNULL((SELECT percentage FROM `st_purchaseorder_tax`  WHERE purchaseorderid=pod.purchaseorderid AND itemid=pod.itemid AND taxname='CGST'),0) CGSTPer, ");
        sb.Append("IFNULL((SELECT percentage FROM `st_purchaseorder_tax`  WHERE purchaseorderid=pod.purchaseorderid AND itemid=pod.itemid AND taxname='SGST'),0) SGSTPer ");
        sb.Append("FROM `st_purchaseorder_details` pod WHERE isactive=1 AND `PurchaseOrderID`=" + POID + "  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string AcceptPo(string POID)
    {
        try
        {
            POID = "'" + POID.Trim(',') + "'";
            POID = POID.Replace(",", "','");
            StockReports.ExecuteDML("update st_purchaseorder set  IsVendorAccept=1,VendorAcceptDateTime=now() where purchaseorderid in (" + POID + ") ");
            return "1";
        }
        catch(Exception ex)
        {
            return ex.Message;
        }
       
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
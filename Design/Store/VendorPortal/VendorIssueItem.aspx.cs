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

public partial class Design_Store_VendorPortal_VendorIssueItem : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            txtinvoicedate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtdispatchdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }


    [WebMethod(EnableSession = true)]
    public static string binditem()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT ItemId,typename ItemName FROM st_itemmaster im");
        sb.Append("  where isactive=1 and approvalstatus=2 order by typename ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string searchdata(string fromdate, string todate, string postatus, string ponumber, string Items)
    {

        if (HttpContext.Current.Session["SupplierID"] == null)
        {
            return "-1";
        }


        StringBuilder sb = new StringBuilder();
        sb.Append(" select * from (");
        sb.Append(" SELECT ifnull(so.vendorcomment,'')vendorcomment, so.IsVendorAccept,(case when so.IsVendorAccept=0 then  'white' when so.IsVendorAccept=1 and sum(approvedqty-RejectQtyByUser-VendorIssueQty)>0 then 'pink' else 'lightgreen' end)   rowColor, ");
        sb.Append(" (case when so.IsVendorAccept=0 then  'New' when so.IsVendorAccept=1 and sum(approvedqty-RejectQtyByUser-VendorIssueQty)>0 then 'Accepted' else 'Issued' end)  postatus,");
        sb.Append(" so.PurchaseOrderID,so.PurchaseOrderNo,DATE_FORMAT(so.CreatedDate,'%d-%b-%Y')PODate,GrossTotal,DiscountOnTotal,so.TaxAmount,NetTotal, ");
        sb.Append(" sl.`Location`,sl.`ContactPerson`,sl.`ContactPersonNo`,DATE_FORMAT(so.VendorAcceptDateTime,'%d-%b-%Y') VendorAcceptDateTime ");
        sb.Append(" FROM ");
        sb.Append(" st_purchaseorder so  ");
        sb.Append(" INNER JOIN `st_locationmaster` sl ON so.`LocationID`=sl.`LocationID` ");
        sb.Append(" INNER join st_purchaseorder_details spod on spod.PurchaseOrderID=so.PurchaseOrderID ");
        if (Items != "")
        {
            sb.Append(" and spod.itemid in (" + Items + ")");
        }
        sb.Append(" WHERE vendorid='" + HttpContext.Current.Session["SupplierID"].ToString() + "' AND actiontype='Approval' ");
        if (ponumber == "")
        {
            sb.Append(" and so.VendorAcceptDateTime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append(" and so.VendorAcceptDateTime<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' and so.IsVendorAccept=1 ");
        }
        else
        {
            sb.Append(" and so.PurchaseOrderNo='" + ponumber + "' ");
        }
        sb.Append(" group by so.PurchaseOrderID");
        sb.Append(" order by so.VendorAcceptDateTime) t");
        if (postatus == "1")
        {
            sb.Append(" where t.postatus='Accepted' ");
        }
        else if (postatus == "2")
        {
            sb.Append(" where t.postatus='Issued' ");
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));


    }


     [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindItemDetail(string POID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ifnull(vendorcommentitem,'')vendorcommentitem, (case when (approvedqty-RejectQtyByUser-VendorIssueQty)>0 then 'white' else 'lightgreen' end) Rowcolor, itemid,itemname,`MAnufactureID`,`ManufactureName`,machineid,machinename,packsize,(approvedqty-RejectQtyByUser-VendorIssueQty) approvedqty,VendorIssueQty,approvedqty orderqty,(approvedqty-RejectQtyByUser) orderqty,rate,taxamount,discountamount ,netamount,PurchaseOrderID,PurchaseOrderNo,(VendorIssueQty-grnqty) MisMatchQty,pod.rate,pod.taxamount,pod.netamount ");

        sb.Append(", ifnull((select concat(IssueQty,'#',DATE_FORMAT(IssueDateTime,'%d-%b-%Y')) from  st_purchaseorder_details_vendor where  Itemid=pod.Itemid and PurchaseOrderID=pod.PurchaseOrderID order by id desc limit 1),'')lastissueqty");

        sb.Append(" FROM `st_purchaseorder_details` pod WHERE isactive=1 AND `PurchaseOrderID`=" + POID + " ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

     [WebMethod]
     [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
     public static string IssuePoItem(string Data, string POID, string PONo, string invoiceno, string invoicedate, string cdetail, string filename, string awbnumber, string dispatchdate)
     {
         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         try
         {
             Data = Data.Trim(',');

             foreach (string item in Data.Split(','))
             {
                 MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_purchaseorder_details set  VendorIssueQty=VendorIssueQty+" + item.Split('#')[1] + " where purchaseorderid =" + POID + " and itemid=" + item.Split('#')[0] + " ");

                 MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into  st_purchaseorder_details_vendor (PurchaseOrderID,PurchaseOrderNo,Itemid,IssueQty,IssueDateTime,VendorId,VendorName,invoiceno,invoicedate,courierdetail,filename,AWBNumber,DispatchDate) values('" + POID + "','" + PONo + "','" + item.Split('#')[0] + "','" + item.Split('#')[1] + "',now(),'" + HttpContext.Current.Session["SupplierID"].ToString() + "','" + HttpContext.Current.Session["SupplierName"].ToString() + "','" + invoiceno + "','" + Util.GetDateTime(invoicedate).ToString("yyyy-MM-dd") + "','" + cdetail + "','" + filename + "','" + awbnumber + "','" + Util.GetDateTime(dispatchdate).ToString("yyyy-MM-dd") + "')  ");

                 if (filename != "")
                 {
                     MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_purchaseorder_details_vendor_invoice set PurchaseOrderID='" + POID + "',PurchaseOrderNo='" + PONo + "',ItemID='" + item.Split('#')[0] + "',VendorId='" + HttpContext.Current.Session["SupplierID"].ToString() + "' where file='" + filename + "'");
                 }


             }
             tnx.Commit();
             return "1";
         }

         catch (Exception ex)
         {
             tnx.Rollback();
             ClassLog cl = new ClassLog();
             cl.errLog(ex);
             return Util.GetString(ex.Message);

         }
         finally
         {
             tnx.Dispose();
             con.Close();
             con.Dispose();
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
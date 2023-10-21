using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class Design_Store_GRNFromPO : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {


          

            //string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM st_approvalright WHERE apprightfor='GRN' AND active=1 AND typeid=1 AND employeeid='" + UserInfo.ID + "'  ");
            //if (dt == "0")
            //{
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';showerrormsg('Dear User You Did not Have Right To Make GRN');", true);
            //    return;
            //}
           // txtinvoicedate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            //txtchallandate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            bindalldata();
        }


    }

    void bindalldata()
    {
        if (UserInfo.AccessStoreLocation != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT concat(locationid,'#',panel_id) locationid,location FROM st_locationmaster WHERE isactive=1   ");
            sb.Append(" AND locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


            sb.Append(" ORDER BY location ");
            ddllocation.DataSource = StockReports.GetDataTable(sb.ToString());
            ddllocation.DataTextField = "location";
            ddllocation.DataValueField = "locationid";
            ddllocation.DataBind();

            if (ddllocation.Items.Count > 1)
            {
                ddllocation.Items.Insert(0, new ListItem("Select Location", "0"));
            }

            if (ddllocation.Items.Count == 1)
            {
                string res = StorePageAccess.OpenOtherStockPages(ddllocation.SelectedValue.Split('#')[0]);

                if (res != "1")
                {

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "hideme('" + res + "');", true);
                }
            }
        }

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindorder(string location)
    {
        return Util.getJson(StockReports.GetDataTable(@"SELECT DISTINCT CONCAT(po.`PurchaseOrderNo`,' # ',po.vendorname)PurchaseOrderNo,po.PurchaseOrderID FROM st_purchaseorder po 
INNER JOIN `st_purchaseorder_details` pod ON po.`PurchaseOrderID`=pod.`PurchaseOrderID` 
AND ((CASE WHEN  po.VendorLogin=0 THEN ApprovedQty ELSE VendorIssueQty END)-`RejectQtyByUser`-`RejectQtyByVendor`)>`GRNQty`
AND po.locationid='" + location.Split('#')[0] + "'  AND po.status=2 and (CASE WHEN  po.VendorLogin=0 then IsVendorAccept=0 else IsVendorAccept=1 end) order by po.`PurchaseOrderNo`"));
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindorderdetail(string location, string poid)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ifnull(po.vendorcomment,'')vendorcomment, ifnull(pod.vendorcommentitem,'')vendorcommentitem,ifnull(si.expdatecutoff,0)expdatecutoff,po.`PurchaseOrderNo`,po.PurchaseOrderID,po.`VendorID`,po.`VendorName`,po.`Subject`,po.VendorLogin, ");
        sb.Append(" DATE_FORMAT(po.`ApprovedDate`,'%d-%b-%Y') podate,if(po.VendorLogin=0,'','Vendor Portal')VendorPortal,");

        sb.Append(" if(po.vendorlogin=1 && po.isvendoraccept=1,ifnull((SELECT group_concat(FILE) FROM `st_purchaseorder_details_vendor_invoice` WHERE `PurchaseOrderID`=po.PurchaseOrderID),''),'') VendorInvoice,if(po.vendorlogin=1,ifnull((SELECT invoiceno FROM st_purchaseorder_details_vendor WHERE PurchaseOrderID=po.PurchaseOrderID ORDER BY id LIMIT 1),''),'')vendorinvoicetext,if(po.vendorlogin=1,ifnull((SELECT DATE_FORMAT(invoicedate,'%d-%b-%Y') FROM st_purchaseorder_details_vendor WHERE PurchaseOrderID=po.PurchaseOrderID ORDER BY id LIMIT 1),''),'')vendorinvoicedate,");
        sb.Append("  si.IsExpirable, si.HsnCode,sm.name itemgroup,pod.itemid,typename,apolloitemcode,si.ManufactureID, ");
        sb.Append("  si.MachineID,si.MajorUnitId,si.MajorUnitName,si.Converter,si.MinorUnitId,si.MinorUnitName,po.locationid `LocationId`, ");
        sb.Append("  '" + location.Split('#')[1] + "' panelid, ");
        sb.Append(" si.IssueMultiplier,si.PackSize,si.BarcodeOption,si.BarcodeGenrationOption,si.IssueInFIFO, si.MajorUnitInDecimal,si.MinorUnitInDecimal, ");
        sb.Append(" sum(pod.Rate)Rate,sum(pod.DiscountPercentage) DiscountPer,");
        sb.Append(" (CASE WHEN  po.VendorLogin=0 THEN pod.ApprovedQty ELSE pod.VendorIssueQty END) poqty,pod.grnqty,");
       

         sb.Append("  IFNULL((SELECT percentage FROM st_purchaseorder_tax WHERE `PurchaseOrderID`=pod.`PurchaseOrderID` and itemid=pod.`ItemID`   AND taxname='IGST') ,'') IGSTPer,");
         sb.Append(" IFNULL((SELECT percentage FROM st_purchaseorder_tax WHERE `PurchaseOrderID`=pod.`PurchaseOrderID` and itemid=pod.`ItemID`  AND taxname='CGST') ,'') CGSTPer,");
         sb.Append(" IFNULL((SELECT percentage FROM st_purchaseorder_tax WHERE `PurchaseOrderID`=pod.`PurchaseOrderID` and itemid=pod.`ItemID`   AND taxname='SGST') ,'') SGSTPer ");


         sb.Append(" ,sum(if(isfree=0,(CASE WHEN  po.VendorLogin=0 THEN ApprovedQty ELSE VendorIssueQty END),0)-if(isfree=0,`RejectQtyByUser`,0)-if(isfree=0,`RejectQtyByVendor`,0)-if(isfree=0,GRNQty,0)) PaidQty");
         sb.Append(" ,sum(if(isfree=1,(CASE WHEN  po.VendorLogin=0 THEN ApprovedQty ELSE VendorIssueQty END),0)-if(isfree=1,`RejectQtyByUser`,0)-if(isfree=1,`RejectQtyByVendor`,0)-if(isfree=1,GRNQty,0)) FreeQty");
        sb.Append(" FROM st_purchaseorder po ");
        sb.Append(" INNER JOIN `st_purchaseorder_details` pod ON po.`PurchaseOrderID`=pod.`PurchaseOrderID` ");
        sb.Append(" AND ((CASE WHEN  po.VendorLogin=0 THEN ApprovedQty ELSE VendorIssueQty END)-`RejectQtyByUser`-`RejectQtyByVendor`)>`GRNQty` ");
        sb.Append(" inner join st_itemmaster si ON si.`ItemID`=pod.`ItemID`");
        sb.Append("  INNER JOIN st_subcategorymaster sm ON sm.SubCategoryID=si.SubCategoryID ");

        sb.Append(" where po.locationid='" + location.Split('#')[0] + "' AND  po.status=2 AND po.PurchaseOrderID='" + poid + "' group by pod.`ItemID` ");



        //b.Append(" SELECT si.IsExpirable, si.HsnCode,sm.name itemgroup,si.itemid,typename,apolloitemcode,si.ManufactureID, ");
        //sb.Append("  si.MachineID,si.MajorUnitId,si.MajorUnitName,si.Converter,si.MinorUnitId,si.MinorUnitName,smm.`LocationId`, ");
        //sb.Append("  '" + locationid.Split('#')[1] + "' panelid, ");
        //sb.Append(" si.IssueMultiplier,si.PackSize,si.BarcodeOption,si.BarcodeGenrationOption,si.IssueInFIFO, si.MajorUnitInDecimal,si.MinorUnitInDecimal, ");
        //sb.Append(" qut.Rate,qut.DiscountPer,qut.IGSTPer,qut.SGSTPer,qut.CGSTPer");
        //sb.Append(", '" + barcodeno + "' barcodeno ");
        //sb.Append("  FROM st_itemmaster si    ");
        //sb.Append("  INNER JOIN st_subcategorymaster sm ON sm.SubCategoryID=si.SubCategoryID   ");
        //sb.Append("  INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`   ");

        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savegrn(StoreLedgerTransaction st_ledgertransaction, List<StoreNMStock> st_nmstock, List<StoreTaxChargedList> taxdata, string filename, string PurchaseOrderID,string vendorlogin)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string LedgerTransactionID = "";
            string LedgerTransactionNo = "";
            StoreLedgerTransaction lt = new StoreLedgerTransaction(tnx);
            lt.VendorID = st_ledgertransaction.VendorID;
            lt.TypeOfTnx = st_ledgertransaction.TypeOfTnx;
            lt.PurchaseOrderNo = st_ledgertransaction.PurchaseOrderNo;
            lt.GrossAmount = st_ledgertransaction.GrossAmount;
            lt.DiscountOnTotal = st_ledgertransaction.DiscountOnTotal;
            lt.TaxAmount = st_ledgertransaction.TaxAmount;
            lt.NetAmount = st_ledgertransaction.NetAmount;
            lt.InvoiceAmount = st_ledgertransaction.InvoiceAmount;
            if (filename != "")
            {
                lt.InvoiceAttachment = 1;
            }
            else
            {
                lt.InvoiceAttachment = 0;
            }
            lt.IndentNo = st_ledgertransaction.IndentNo;
            lt.InvoiceNo = st_ledgertransaction.InvoiceNo;
            lt.InvoiceDate = st_ledgertransaction.InvoiceDate;
            lt.ChalanDate = st_ledgertransaction.ChalanDate;
            lt.ChalanNo = st_ledgertransaction.ChalanNo;
            lt.Remarks = st_ledgertransaction.Remarks;
            lt.Freight = st_ledgertransaction.Freight;
            lt.Octori = st_ledgertransaction.Octori;
            lt.IsReturnable = st_ledgertransaction.IsReturnable;
            lt.RoundOff = st_ledgertransaction.RoundOff;
            lt.GatePassInWard = st_ledgertransaction.GatePassInWard;
            lt.LocationID = st_ledgertransaction.LocationID;
            lt.IsDirectGRN = st_ledgertransaction.IsDirectGRN;

            string ss = lt.Insert();
            LedgerTransactionID = ss.Split('#')[0];
            LedgerTransactionNo = ss.Split('#')[1];
            foreach (StoreNMStock stockdata in st_nmstock)
            {
              

                StoreNMStock ststock = new StoreNMStock(tnx);

                ststock.ItemID = stockdata.ItemID;
                ststock.ItemName = stockdata.ItemName;
                ststock.LedgerTransactionID = Util.GetInt(LedgerTransactionID);
                ststock.LedgerTransactionNo = LedgerTransactionNo;
                ststock.BatchNumber = stockdata.BatchNumber;

                ststock.Rate = stockdata.Rate / stockdata.Converter;
                ststock.DiscountPer = stockdata.DiscountPer;
                ststock.DiscountAmount = stockdata.DiscountAmount / stockdata.Converter;
                ststock.TaxPer = stockdata.TaxPer;
                ststock.TaxAmount = stockdata.TaxAmount / stockdata.Converter;
                ststock.UnitPrice = stockdata.UnitPrice / stockdata.Converter;
                ststock.MRP = stockdata.MRP / stockdata.Converter;
                ststock.InitialCount = stockdata.InitialCount;
                ststock.ReleasedCount = 0;
                ststock.PendingQty = 0;
                ststock.RejectQty = 0;


                ststock.ExpiryDate = stockdata.ExpiryDate;


                ststock.Naration = stockdata.Naration;
                ststock.IsFree = stockdata.IsFree;

                ststock.LocationID = stockdata.LocationID;
                ststock.Panel_Id = stockdata.Panel_Id;

                ststock.IndentNo = stockdata.IndentNo;
                ststock.FromLocationID = stockdata.FromLocationID;
                ststock.FromStockID = stockdata.FromStockID;
                ststock.Reusable = stockdata.Reusable;
                ststock.ManufactureID = stockdata.ManufactureID;
                ststock.MacID = stockdata.MacID;
                ststock.MajorUnitID = stockdata.MajorUnitID;
                ststock.MajorUnit = stockdata.MajorUnit;
                ststock.MinorUnitID = stockdata.MinorUnitID;
                ststock.MinorUnit = stockdata.MinorUnit;
                ststock.Converter = stockdata.Converter;
                ststock.Remarks = stockdata.Remarks;
                ststock.BarcodeNo = stockdata.BarcodeNo;
                ststock.IsPost = 0;

                ststock.IsExpirable = stockdata.IsExpirable;
                ststock.PackSize = stockdata.PackSize;
                ststock.IssueMultiplier = stockdata.IssueMultiplier;
                ststock.BarcodeOption = stockdata.BarcodeOption;
                ststock.BarcodeGenrationOption = stockdata.BarcodeGenrationOption;
                ststock.IssueInFIFO = stockdata.IssueInFIFO;
                ststock.MajorUnitInDecimal = stockdata.MajorUnitInDecimal;
                ststock.MinorUnitInDecimal = stockdata.MinorUnitInDecimal;

                var ststocknew = st_nmstock.Where(f => (f.ItemID == ststock.ItemID) && (f.IsFree == ststock.IsFree) && (f.StockID == 0));
                float qty = 0;
                foreach (StoreNMStock ssmnew in ststocknew)
                {
                    float recqty = ssmnew.InitialCount / ssmnew.Converter;
                    qty = qty + recqty;
                }
                float issueqty = Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select ((CASE WHEN  po.VendorLogin=0 THEN ApprovedQty ELSE VendorIssueQty END)-`RejectQtyByUser`-`RejectQtyByVendor`-GRNQty) from st_purchaseorder_details pod inner join st_purchaseorder po on po.PurchaseOrderID=pod.PurchaseOrderID where po.PurchaseOrderID=" + PurchaseOrderID + " and itemid='" + stockdata.ItemID + "' and  IsFree=" + ststock.IsFree + ""));

                if (qty > issueqty)
                {
                    tnx.Rollback();

                    return "0#Receive Qty Can Not Greater Then " + issueqty + " For " + stockdata.ItemName;
                }
                string stockid = ststock.Insert();
                try
                {
                    st_nmstock.Where(f => (f.ItemID == ststock.ItemID) && (f.IsFree == 0) && (f.BatchNumber == ststock.BatchNumber)).ToList()[0].StockID = Util.GetInt(stockid);
                }
                catch
                {
                }
              
                if (stockid == "")
                {
                    tnx.Rollback();
                    return "0";
                }
                if (ststock.BarcodeGenrationOption == 2 && ststock.BarcodeNo == "")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_nmstock set Barcodeno=stockid where stockid=" + stockid + "");
                }

                // Update Purchase Order table 
                //if (vendorlogin == "0")
                //{
                    float GRNQty = stockdata.InitialCount / stockdata.Converter;
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_purchaseorder_details set  GRNQty=GRNQty+" + GRNQty + " where PurchaseOrderID=" + PurchaseOrderID + " and itemid='" + stockdata.ItemID + "' and  IsFree=" + ststock.IsFree + "");
                //}
                //if (ststock.IsFree == 0)
                //{
                    var taxlist = taxdata.Where(f => (f.ItemID == ststock.ItemID) && f.BatchNumber == ststock.BatchNumber);

                    foreach (StoreTaxChargedList tax in taxlist)
                    {
                        StoreTaxChargedList mytax = new StoreTaxChargedList(tnx);
                        mytax.LedgerTransactionID = Util.GetInt(LedgerTransactionID);
                        mytax.LedgerTransactionNo = LedgerTransactionNo;
                        mytax.ItemID = tax.ItemID;
                        mytax.StockID = Util.GetInt(stockid);
                        mytax.Percentage = tax.Percentage;
                        mytax.TaxName = tax.TaxName;
                        mytax.TaxAmt = tax.TaxAmt / stockdata.Converter;
                        string savedid = mytax.Insert();
                        if (savedid == "")
                        {
                            tnx.Rollback();

                            return "0";
                        }
                    }
                //}
            }

            if (filename != "")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_grn_document set LedgerTransactionID='" + LedgerTransactionID + "' where newfilename='" + filename + "'");
            }

            // update StoreLedgerTransaction

            StringBuilder sb = new StringBuilder();
            sb.Append(" update st_LedgerTransaction slt  ");
            sb.Append(" set grossamount=(select sum(rate*InitialCount) from st_nmstock st where st.LedgerTransactionID=slt.LedgerTransactionID) ");
            sb.Append(" , DiscountOnTotal=(select sum(discountamount*InitialCount) from st_nmstock st where st.LedgerTransactionID=slt.LedgerTransactionID) ");
            sb.Append(" , TaxAmount=(select sum(TaxAmount*InitialCount) from st_nmstock st where st.LedgerTransactionID=slt.LedgerTransactionID) ");
            sb.Append(" , NetAmount=(select sum(unitprice*InitialCount) from st_nmstock st where st.LedgerTransactionID=slt.LedgerTransactionID) ");
            sb.Append(",InvoiceAmount=NetAmount where slt.LedgerTransactionID='" + LedgerTransactionID + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            tnx.Commit();
            return "1#" + LedgerTransactionID;
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.Message);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string checkmybarcode(string barcodeno, string barcodeoption, string itemid)
    {

        //stock wise
        if (barcodeoption == "1")
        {
            DataTable dt = StockReports.GetDataTable("select itemid,BatchNumber,date_format(ExpiryDate,'%d-%b-%Y')ExpiryDate from st_nmstock where barcodeno='" + barcodeno + "' order by stockid desc");
            if (dt.Rows.Count > 0)
            {
                if (dt.Select("itemid='" + itemid + "'").Length == 0)
                {
                    return "0#";//Error
                }
                else
                {
                    return "2#" + dt.Rows[0]["BatchNumber"].ToString() + "^" + dt.Rows[0]["ExpiryDate"].ToString();// Validate With BatchNumber
                }
            }
            else
            {
                return "1#";//Validate With No BatchNumber
            }
        }

        //item wise
        if (barcodeoption == "2")
        {
            DataTable dt = StockReports.GetDataTable("select itemid from st_itemmaster_barcode where Barcode='" + barcodeno + "'");
            if (dt.Rows.Count > 0)
            {
                if (dt.Select("itemid='" + itemid + "'").Length == 0)
                {
                    return "0#";//Error
                }
                else
                {
                    return "1#";//Validate With No BatchNumber
                }
            }
            else
            {
                StockReports.ExecuteDML("insert into st_itemmaster_barcode(ItemID,Barcode,EntryDateTime,UserID) values ('" + itemid + "','" + barcodeno + "',now(),'" + UserInfo.ID + "')");
                return "1#";//Validate With No BatchNumber
            }
        }
        return "";
    }


    
}
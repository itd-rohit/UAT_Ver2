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

public partial class Design_Store_DirectGRN : System.Web.UI.Page
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

                //txtinvoicedate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
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
    public static string SearchItemDetail(string itemid, string qtype, string locationid, string barcodeno,string vendorid)
    {
        string itemidbarcode = "";
        if (barcodeno != "")
        {
            // case 1 Itemwise
            itemidbarcode = Util.GetString(StockReports.ExecuteScalar("select itemid from st_itemmaster_barcode where barcode='" + barcodeno + "' order by id desc limit 1"));

            // case 2 StockWise
            if (itemidbarcode == "")
            {
                itemidbarcode = Util.GetString(StockReports.ExecuteScalar("select itemid from st_nmstock where barcodeno='" + barcodeno + "'  order by stockid desc limit 1"));

            }

            if (itemidbarcode == "")
                return "-1";
        }


        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ifnull(si.expdatecutoff,0)expdatecutoff,si.IsExpirable, si.HsnCode,sm.name itemgroup,si.itemid,typename,apolloitemcode,si.ManufactureID, ");
        sb.Append("  si.MachineID,si.MajorUnitId,si.MajorUnitName,si.Converter,si.MinorUnitId,si.MinorUnitName,smm.`LocationId`, ");
        sb.Append("  '" + locationid.Split('#')[1] + "' panelid, ");
        sb.Append(" si.IssueMultiplier,si.PackSize,si.BarcodeOption,si.BarcodeGenrationOption,si.IssueInFIFO, si.MajorUnitInDecimal,si.MinorUnitInDecimal, ");

        //if (qtype == "2")
        //{
            sb.Append(" ifnull(qut.Rate,0)Rate,ifnull(qut.DiscountPer,0)DiscountPer,ifnull(qut.IGSTPer,0)IGSTPer,ifnull(qut.SGSTPer,0)SGSTPer,ifnull(qut.CGSTPer,0)CGSTPer");
        //}
        //else
        //{
        //    sb.Append(" '' Rate,'' DiscountPer,'' IGSTPer,'' SGSTPer,'' CGSTPer");
        //}
        sb.Append(", '" + barcodeno + "' barcodeno ");
        sb.Append("  FROM st_itemmaster si    ");
        sb.Append("  INNER JOIN st_subcategorymaster sm ON sm.SubCategoryID=si.SubCategoryID   ");
        sb.Append("  INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`   ");
      
        if (itemid != "")
        {
            sb.Append("  and si.itemid='" + itemid + "' ");
        }
        sb.Append("  AND smm.`LocationId`=" + locationid.Split('#')[0] + "  ");
       
        if (barcodeno != "")
        {
            sb.Append(" and si.itemid='" + itemidbarcode + "' ");
        }

        //if (qtype == "2")
        //{
        sb.Append(" left join (select Rate,DiscountPer,IGSTPer,SGSTPer,CGSTPer,itemid,ComparisonStatus from st_vendorqutation where vendorid='" + vendorid + "' and DeliveryLocationID='" + locationid.Split('#')[0] + "' and ComparisonStatus=1 and IsActive=1 and ApprovalStatus=2 and EntryDateTo>=date(now()) order by id desc) qut on qut.itemid=si.itemid ");
        //}



            sb.Append("  WHERE si.isactive=1 AND si.approvalstatus=2 and ComparisonStatus=1 and  ifnull(qut.Rate,0)>0 ");

	//System.IO.File.WriteAllText(@"C:\inetpub\wwwroot\Apollo\ErrorLog\Query.txt", sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
   
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savedirectgrn(StoreLedgerTransaction st_ledgertransaction, List<StoreNMStock> st_nmstock,List<StoreTaxChargedList> taxdata, string filename)
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
                
                string stockid = ststock.Insert();
                if (stockid == "")
                {
                    tnx.Rollback();

                    return "0";
                }
                if (ststock.BarcodeGenrationOption == 2 && ststock.BarcodeNo == "")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_nmstock set Barcodeno=stockid where stockid=" + stockid + "");
                }
                if (ststock.IsFree == 0)
                {
                    var taxlist = taxdata.Where(f => (f.ItemID == ststock.ItemID) && f.BatchNumber==ststock.BatchNumber);

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
                        string savedid=mytax.Insert();
                        if (savedid == "")
                        {
                            tnx.Rollback();

                            return "0";
                        }
                    }
                }
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
            return "0#"+Util.GetString(ex.Message);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchItem(string itemname, string locationidfrom)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT si.`ItemIDGroup`,sig.`ItemNameGroup` ");
        sb.Append(" FROM st_itemmaster si     ");
        sb.Append(" INNER JOIN `st_itemmaster_group` sig ON sig.`ItemIDGroup`=si.`ItemIDGroup` ");
        sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`    ");
        sb.Append(" AND smm.`LocationId` IN (" + locationidfrom.Split('#')[0] + ")  ");
        sb.Append(" AND typename LIKE '" + itemname + "%'  ");
        sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2 GROUP BY sig.`ItemIDGroup` ORDER BY sig.`ItemNameGroup` LIMIT 20   ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindManufacturer(string locationidfrom, string ItemIDGroup)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT si.`ManufactureID`,si.`ManufactureName`   ");
        sb.Append("  FROM st_itemmaster si      ");
        sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`   ");
        sb.Append("  AND smm.`LocationId` = " + locationidfrom.Split('#')[0] + "   ");

        sb.Append(" AND si.`ItemIDGroup`  = '" + ItemIDGroup + "' ");
        sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2  ");
        sb.Append(" GROUP BY si.`ManufactureID` ");
        sb.Append(" ORDER BY si.`ManufactureName` ; ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindMachine(string locationidfrom, string ItemIDGroup, string ManufactureID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("    SELECT si.`MachineID`,si.`MachineName`     ");
        sb.Append(" FROM st_itemmaster si       ");
        sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`    ");
        sb.Append(" AND smm.`LocationId` = " + locationidfrom.Split('#')[0] + "    ");

        sb.Append(" AND si.`ItemIDGroup`  = '" + ItemIDGroup + "' AND `ManufactureID`='" + ManufactureID + "'  ");
        sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2   ");
        sb.Append("  GROUP BY si.`MachineID`  ");
        sb.Append("  ORDER BY si.`MachineName` ;  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindPackSize(string locationidfrom, string ItemIDGroup, string ManufactureID, string MachineID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT si.`PackSize`, concat(si.`IssueMultiplier`,'#',si.`MinorUnitName`,'#',si.`ItemID`)PackValue  ");
        sb.Append(" FROM st_itemmaster si       ");
        sb.Append("  INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`    ");
        sb.Append(" AND smm.`LocationId` = " + locationidfrom.Split('#')[0] + "    ");

        sb.Append(" AND si.`ItemIDGroup`  = '" + ItemIDGroup + "' AND `ManufactureID`='" + ManufactureID + "' AND si.`MachineID`='" + MachineID + "'  ");
        sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2   ");
        sb.Append(" GROUP BY si.`PackSize`  ");
        sb.Append(" ORDER BY si.`PackSize` ;  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

}
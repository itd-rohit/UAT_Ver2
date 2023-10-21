using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Linq;
using System.Web.UI;

public partial class Design_Store_StockPhysicalVerification : System.Web.UI.Page
{

    public string savespv = "0";
    public string approvespv = "0";
   

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
            bindalldata();

            string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM st_approvalright WHERE apprightfor='SPV' AND employeeid='" + UserInfo.ID + "' and active=1 ");
            if (dt != "0")
            {
                if (dt.Contains("Save"))
                {
                    savespv = "1";
                }
                if (dt.Contains("Approved"))
                {
                    approvespv = "1";
                }
               
            }


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
                string res = StorePageAccess.OpenStockPhysicalVerificationPage(ddllocation.SelectedValue.Split('#')[0]);

                if (res != "1")
                {

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "hideme('" + res + "');", true);
                }
            }

            
        }
       
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchDataPrint(string locationid, string CategoryTypeId, string SubCategoryTypeId, string SubCategoryId, string ItemId)
    {
       
       
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT ifnull(si.expdatecutoff,0)expdatecutoff, (select location from st_locationmaster where locationid=smm.`LocationId`) LocationName, si.IssueInFIFO,si.BarcodeOption, si.BarcodeGenrationOption, si.IsExpirable, IFNULL(snt.BatchNumber,'')batchnumber, IFNULL(DATE_FORMAT(snt.ExpiryDate,'%d-%b-%Y'),'')ExpiryDate, ifnull(snt.InHandQty,0)  Balance ,IFNULL(snt.StockID,0)StockID, si.SubCategoryID,sm.name itemgroup,si.itemid,typename,apolloitemcode,si.ManufactureID,   ");
        sb.Append(" si.MachineID,si.MajorUnitId,si.MajorUnitName,si.IssueMultiplier,si.IsExpirable,si.Converter,si.PackSize,si.MinorUnitId,si.MinorUnitName,smm.`LocationId`,'" + locationid.Split('#')[1] + "' panelid,   ");
        sb.Append(" IFNULL(snt.Rate,0)Rate,IFNULL(snt.DiscountPer,0)DiscountPer,IFNULL(snt.DiscountAmount,0)DiscountAmount,IFNULL(snt.TaxPer,0)TaxPer,IFNULL(snt.TaxAmount,0)TaxAmount,IFNULL(snt.UnitPrice,0)UnitPrice,IFNULL(snt.MRP,0)MRP  ");

        sb.Append(",ifnull(snt.barcodeno,'' )barcodeno ,if(snt.IsBarcodePrinted='1','Yes','No')IsBarcodePrinted");
       
        sb.Append(" FROM st_itemmaster si    ");
        sb.Append(" INNER JOIN st_subcategorymaster sm ON sm.SubCategoryID=si.SubCategoryID   ");
        sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`   ");
        sb.Append(" AND smm.`LocationId`=" + locationid.Split('#')[0] + "  ");
        sb.Append(" LEFT JOIN   ");
        sb.Append(" (SELECT  barcodeno,stockid,`ItemID`,`BatchNumber`,if(`ExpiryDate`='0001-01-01','',ExpiryDate)ExpiryDate,sum(`InitialCount` - `ReleasedCount` - `PendingQty` )InHandQty,Rate,  ");
        sb.Append(" DiscountPer,DiscountAmount,TaxPer,TaxAmount,UnitPrice,MRP ,IsBarcodePrinted FROM st_nmstock   ");
        sb.Append(" WHERE `LocationId`=" + locationid.Split('#')[0] + " AND (`InitialCount` - `ReleasedCount` - `PendingQty` ) >0 AND `IsPost`=1  ");
        sb.Append(" GROUP BY stockid  ) snt ON snt.ItemID=si.itemid  ");
        sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2   ");

        

            if (CategoryTypeId != "")
                sb.Append(" and si.CategoryTypeID in (" + CategoryTypeId + ")");

            if (SubCategoryTypeId != "")
                sb.Append(" and si.SubCategoryTypeID in (" + SubCategoryTypeId + ")");

            if (SubCategoryId != "")
                sb.Append(" and si.SubCategoryID in (" + SubCategoryId + ")");

            if (ItemId != "")
                sb.Append(" and si.itemid in (" + ItemId + ")");


            sb.Append(" and ifnull(snt.InHandQty,0)>0 order by Balance desc,typename asc");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
          //  ds.WriteXmlSchema(@"E:\StockPhysicalVerification.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "StockPhysicalVerification";
            return "1";
        }
        else
        {
            return "No Record Found";
        }

        
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string locationid, string CategoryTypeId, string SubCategoryTypeId, string SubCategoryId, string ItemId, string barcode, string itemcode, string rowcolor, string itemidfinal)
    {


        if (itemidfinal == "")
        {
            string itemidbarcode = "";
            if (barcode != "")
            {
                // case 1 Itemwise
                itemidbarcode = Util.GetString(StockReports.ExecuteScalar("select itemid from st_itemmaster_barcode where barcode='" + barcode + "' order by id desc limit 1"));

                // case 2 StockWise
                if (itemidbarcode == "")
                {
                    itemidbarcode = Util.GetString(StockReports.ExecuteScalar("select itemid from st_nmstock where barcodeno='" + barcode + "'  order by stockid desc limit 1"));

                }

                if (itemidbarcode == "")
                    return "-1";
            }
            StringBuilder sb = new StringBuilder();
            sb.Append(" select * from ( ");
            sb.Append(" SELECT ifnull(ssq.qutationid,0)qutationid, ifnull(si.expdatecutoff,0)expdatecutoff, si.MajorUnitInDecimal,si.MinorUnitInDecimal,si.IssueInFIFO,si.BarcodeOption, si.BarcodeGenrationOption, si.IsExpirable, if(IFNULL(ssq.newbatch,'')<>'',ifnull(ssq.newbatch,''),IFNULL(snt.BatchNumber,''))batchnumber,if(ifnull(ssq.NewBatchExpiryDate,'0001-01-01')='0001-01-01',IFNULL(DATE_FORMAT(snt.ExpiryDate,'%d-%b-%Y'),''),IFNULL(DATE_FORMAT(ssq.NewBatchExpiryDate,'%d-%b-%Y'),''))ExpiryDate, snt.InHandQty  Balance ,IFNULL(snt.StockID,0)StockID, si.SubCategoryID,sm.name itemgroup,si.itemid,typename,apolloitemcode,si.ManufactureID,   ");
            sb.Append(" si.MachineID,si.MajorUnitId,si.MajorUnitName,si.IssueMultiplier,si.Converter,si.PackSize,si.MinorUnitId,si.MinorUnitName,smm.`LocationId`,'" + locationid.Split('#')[1] + "' panelid,   ");
            sb.Append(" IFNULL(snt.Rate,ifnull(ssq.rate,0))Rate,IFNULL(snt.DiscountPer,ifnull(ssq.DiscountPer,0))DiscountPer,IFNULL(snt.DiscountAmount,ifnull(ssq.DiscountAmount,0))DiscountAmount,IFNULL(snt.TaxPer,ifnull(ssq.TaxPer,0))TaxPer,IFNULL(snt.TaxAmount,ifnull(ssq.TaxAmount,0))TaxAmount,IFNULL(snt.UnitPrice,ifnull(ssq.UnitPrice,0))UnitPrice,IFNULL(snt.MRP,ifnull(ssq.MRP,0))MRP  ");

            sb.Append(",ifnull(snt.barcodeno,'" + barcode + "' )barcodeno, ");
            sb.Append(" (case when ifnull(ssq.id,'')<>''  then 'lightsalmon' when ifnull(ssq.newbatch,'')<>'' then 'yellow'  when ifnull(snt.stockid,0)=0 then 'bisque' when snt.IsBarcodePrinted=0 then 'White' when snt.IsBarcodePrinted=1 then '#90EE90' end) rowcolor");

            sb.Append(" ,ifnull(ssq.id,'0') savedid,ifnull(ssq.newqty,'') newqty,ifnull(ssq.newbatch,'')newbatch,IF(ssq.NewBatchExpiryDate<>'0001-01-01', DATE_FORMAT(ssq.NewBatchExpiryDate,'%d-%b-%Y'),'') NewBatchExpiryDate,ifnull(ssq.VerificationRemarks,'')VerificationRemarks");

            sb.Append(" FROM st_itemmaster si    ");
            sb.Append(" INNER JOIN st_subcategorymaster sm ON sm.SubCategoryID=si.SubCategoryID   ");
            sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`   ");
            sb.Append(" AND smm.`LocationId`=" + locationid.Split('#')[0] + "  ");
            sb.Append(" LEFT JOIN   ");
            sb.Append(" (SELECT IsBarcodePrinted, barcodeno,stockid,`ItemID`,`BatchNumber`,if(`ExpiryDate`='0001-01-01',null,ExpiryDate)ExpiryDate,sum(`InitialCount` - `ReleasedCount` - `PendingQty` )InHandQty,Rate,  ");
            sb.Append(" DiscountPer,DiscountAmount,TaxPer,TaxAmount,UnitPrice,MRP FROM st_nmstock   ");
            sb.Append(" WHERE `LocationId`=" + locationid.Split('#')[0] + " AND (`InitialCount` - `ReleasedCount` - `PendingQty` ) >0 AND `IsPost`=1  ");
            sb.Append(" GROUP BY stockid ) snt ON snt.ItemID=si.itemid  ");

            sb.Append(" left join st_StockPhysicalVerification ssq on ssq.stockid=snt.stockid and ssq.itemid=snt.itemid and ssq.approved=0 and ssq.locationid=" + locationid.Split('#')[0] + " and ssq.isactive=1 and ssq.entrydate>=DATE_ADD(NOW(),INTERVAL -5 DAY)");
            sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2   ");
          //  sb.Append(" and ifnull(snt.stockid,0)<>0 ");
            if (barcode != "")
            {

                sb.Append(" and si.itemid='" + itemidbarcode + "' and snt.barcodeno='" + barcode + "'");

            }
            else
            {

                if (CategoryTypeId != "")
                    sb.Append(" and si.CategoryTypeID in (" + CategoryTypeId + ")");

                if (SubCategoryTypeId != "")
                    sb.Append(" and si.SubCategoryTypeID in (" + SubCategoryTypeId + ")");

                if (SubCategoryId != "")
                    sb.Append(" and si.SubCategoryID in (" + SubCategoryId + ")");

                if (ItemId != "")
                    sb.Append(" and si.itemid in (" + ItemId + ")");

                if (itemcode != "")
                    sb.Append(" and si.apolloitemcode='" + itemcode + "' ");



            }

            if (rowcolor != "")
            {
             //   if (rowcolor == "bisque")
              //      sb.Append(" and ifnull(snt.stockid,0)=0 ");

                if (rowcolor == "white")
                    sb.Append(" and snt.IsBarcodePrinted=0 and snt.stockid<>0");

                if (rowcolor == "#90EE90")
                    sb.Append(" and snt.IsBarcodePrinted=1 ");

            }


            sb.Append(" union all ");


            sb.Append(" SELECT  ifnull(ssq.qutationid,0)qutationid,ifnull(si.expdatecutoff,0)expdatecutoff, si.MajorUnitInDecimal,si.MinorUnitInDecimal,si.IssueInFIFO,si.BarcodeOption, si.BarcodeGenrationOption, si.IsExpirable, if(IFNULL(ssq.newbatch,'')<>'',ifnull(ssq.newbatch,''),IFNULL(snt.BatchNumber,''))batchnumber,if(ifnull(ssq.NewBatchExpiryDate,'0001-01-01')='0001-01-01',IFNULL(DATE_FORMAT(snt.ExpiryDate,'%d-%b-%Y'),''),IFNULL(DATE_FORMAT(ssq.NewBatchExpiryDate,'%d-%b-%Y'),''))ExpiryDate, if(IFNULL(ssq.newbatch,'')<>'','0',ifnull(snt.InHandQty,0))  Balance ,IFNULL(ssq.StockID,0)StockID, si.SubCategoryID,sm.name itemgroup,si.itemid,typename,apolloitemcode,si.ManufactureID,   ");
            sb.Append(" si.MachineID,si.MajorUnitId,si.MajorUnitName,si.IssueMultiplier,si.Converter,si.PackSize,si.MinorUnitId,si.MinorUnitName,smm.`LocationId`,'" + locationid.Split('#')[1] + "' panelid,   ");
            sb.Append(" IFNULL(snt.Rate,ifnull(ssq.rate,0))Rate,IFNULL(snt.DiscountPer,ifnull(ssq.DiscountPer,0))DiscountPer,IFNULL(snt.DiscountAmount,ifnull(ssq.DiscountAmount,0))DiscountAmount,IFNULL(snt.TaxPer,ifnull(ssq.TaxPer,0))TaxPer,IFNULL(snt.TaxAmount,ifnull(ssq.TaxAmount,0))TaxAmount,IFNULL(snt.UnitPrice,ifnull(ssq.UnitPrice,0))UnitPrice,IFNULL(snt.MRP,ifnull(ssq.MRP,0))MRP  ");

            sb.Append(",ifnull(snt.barcodeno,'" + barcode + "' )barcodeno, ");
            sb.Append(" (case when ifnull(ssq.id,'')<>'' then 'lightsalmon' when ifnull(ssq.newbatch,'')<>'' then 'yellow'  when ifnull(snt.stockid,0)=0 then 'bisque' when snt.IsBarcodePrinted=0 then 'White' when snt.IsBarcodePrinted=1 then '#90EE90' end) rowcolor");

            sb.Append(" ,ifnull(ssq.id,'0') savedid,ifnull(ssq.newqty,'') newqty,ifnull(ssq.newbatch,'')newbatch,IF(ssq.NewBatchExpiryDate<>'0001-01-01', DATE_FORMAT(ssq.NewBatchExpiryDate,'%d-%b-%Y'),'') NewBatchExpiryDate,ifnull(ssq.VerificationRemarks,'')VerificationRemarks");

            sb.Append(" FROM st_itemmaster si    ");
            sb.Append(" INNER JOIN st_subcategorymaster sm ON sm.SubCategoryID=si.SubCategoryID   ");
            sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`   ");
            sb.Append(" AND smm.`LocationId`=" + locationid.Split('#')[0] + "  ");

            sb.Append(" inner join st_StockPhysicalVerification ssq on ssq.stockid=0 and ssq.itemid=si.itemid and ssq.approved=0 and ssq.locationid=" + locationid.Split('#')[0] + " and ssq.isactive=1 and ssq.entrydate>=DATE_ADD(NOW(),INTERVAL -5 DAY)");

            sb.Append(" LEFT JOIN   ");
            sb.Append(" (SELECT IsBarcodePrinted, barcodeno,stockid,`ItemID`,`BatchNumber`,if(`ExpiryDate`='0001-01-01',null,ExpiryDate)ExpiryDate,sum(`InitialCount` - `ReleasedCount` - `PendingQty` )InHandQty,Rate,  ");
            sb.Append(" DiscountPer,DiscountAmount,TaxPer,TaxAmount,UnitPrice,MRP FROM st_nmstock   ");
            sb.Append(" WHERE `LocationId`=" + locationid.Split('#')[0] + " AND (`InitialCount` - `ReleasedCount` - `PendingQty` ) >0 AND `IsPost`=1  ");
            sb.Append(" GROUP BY stockid ) snt ON snt.ItemID=si.itemid and snt.stockid=ssq.fromstockid  ");


            sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2   ");
           // sb.Append(" and ifnull(snt.stockid,0)<>0 ");
            if (barcode != "")
            {

                sb.Append(" and si.itemid='" + itemidbarcode + "' and snt.barcodeno='" + barcode + "'");

            }
            else
            {

                if (CategoryTypeId != "")
                    sb.Append(" and si.CategoryTypeID in (" + CategoryTypeId + ")");

                if (SubCategoryTypeId != "")
                    sb.Append(" and si.SubCategoryTypeID in (" + SubCategoryTypeId + ")");

                if (SubCategoryId != "")
                    sb.Append(" and si.SubCategoryID in (" + SubCategoryId + ")");

                if (ItemId != "")
                    sb.Append(" and si.itemid in (" + ItemId + ")");

                if (itemcode != "")
                    sb.Append(" and si.apolloitemcode='" + itemcode + "' ");



            }

            if (rowcolor != "")
            {
                //if (rowcolor == "bisque")
                   // sb.Append(" and ifnull(snt.stockid,0)=0 ");

                if (rowcolor == "white")
                    sb.Append(" and snt.IsBarcodePrinted=0 and snt.stockid<>0");

                if (rowcolor == "#90EE90")
                    sb.Append(" and snt.IsBarcodePrinted=1 ");

            }


            sb.Append(" ) t order by savedid desc,Balance desc,typename asc");


            //System.IO.File.WriteAllText(@"D:\p1.txt", sb.ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
        }
        else
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT  sv.id qutationid,ifnull(si.expdatecutoff,0)expdatecutoff, si.MajorUnitInDecimal,si.MinorUnitInDecimal,si.IssueInFIFO,si.BarcodeOption, si.BarcodeGenrationOption, si.IsExpirable, '' batchnumber,'' ExpiryDate, ''  Balance ,0 StockID, si.SubCategoryID,sm.name itemgroup,si.itemid,typename,apolloitemcode,si.ManufactureID,   ");
            sb.Append(" si.MachineID,si.MajorUnitId,si.MajorUnitName,si.IssueMultiplier,si.Converter,si.PackSize,si.MinorUnitId,si.MinorUnitName,smm.`LocationId`,'" + locationid.Split('#')[1] + "' panelid,   ");



            sb.Append(" (sv.`Rate`/si.`Converter`) Rate,  ");
            sb.Append(" (sv.`DiscountAmt`/si.`Converter`)DiscountAmount,sv.`DiscountPer`,  ");
            sb.Append(" (sv.`IGSTPer`+sv.`CGSTPer`+sv.`SGSTPer`)TaxPer,  ");
            sb.Append(" (sv.`GSTAmount`/si.`Converter`)TaxAmount,  ");

            sb.Append(" (sv.`BuyPrice`/si.`Converter`)UnitPrice ,(sv.`BuyPrice`/si.`Converter`)MRP ");



            sb.Append(",'' barcodeno, ");
            sb.Append("   'bisque'  rowcolor");

            sb.Append(" ,'0' savedid,'' newqty,'' newbatch,'' NewBatchExpiryDate,'' VerificationRemarks");

            sb.Append(" FROM st_itemmaster si    ");
            sb.Append(" INNER JOIN st_subcategorymaster sm ON sm.SubCategoryID=si.SubCategoryID   ");
            sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID` and si.itemid in (" + itemidfinal.TrimEnd(',') + ")   ");
            sb.Append(" AND smm.`LocationId`=" + locationid.Split('#')[0] + "  ");
            sb.Append(" INNER JOIN st_vendorqutation sv ON sv.`ItemID`=si.`ItemID` AND sv.`ApprovalStatus`=2 AND sv.`IsActive`=1  ");
            sb.Append(" AND sv.`ComparisonStatus`=1 AND sv.`DeliveryLocationID`=" + locationid.Split('#')[0] + "       ");
           System.IO.File.WriteAllText(@"D:\p2.txt", sb.ToString());
		   return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savestock(List<StockPhysicalVerify> mydata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string itemid = string.Join(",", mydata.Select(x => x.itemid).ToArray());

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from st_StockPhysicalVerification where itemid in(" + itemid + ") and Approved=0 and locationid=" + mydata[0].LocationID + "  ");

            foreach (StockPhysicalVerify fm in mydata)
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into st_StockPhysicalVerification(StockID,fromstockid,locationid,ItemID,OldQty,NewQty,NewBatch,NewBatchExpiryDate,Month,Year,UserID,UserName,EntryDate,VerificationRemarks,qutationid,Rate,DiscountPer,DiscountAmount,TaxPer,TaxAmount,UnitPrice,MRP) values (@StockID,@fromstockid,@locationid,@ItemID,@OldQty,@NewQty,@NewBatch,@NewBatchExpiryDate,@Month,@Year,@UserID,@UserName,@EntryDate,@VerificationRemarks,@qutationid,@Rate,@DiscountPer,@DiscountAmount,@TaxPer,@TaxAmount,@UnitPrice,@MRP)",
                    new MySqlParameter("@StockID", fm.stockid),
                    new MySqlParameter("@fromstockid", fm.fromstockid),
                    new MySqlParameter("@locationid", fm.LocationID),
                    new MySqlParameter("@ItemID", fm.itemid),
                    new MySqlParameter("@OldQty", fm.OldQty),
                    new MySqlParameter("@NewQty", fm.NewQty),
                    new MySqlParameter("@NewBatch", fm.NewBatch),
                    new MySqlParameter("@NewBatchExpiryDate", Util.GetDateTime(fm.NewBatchExpiryDate).ToString("yyyy-MM-dd")),
                    new MySqlParameter("@Month", DateTime.Now.Month),
                    new MySqlParameter("@Year", DateTime.Now.Year),
                    new MySqlParameter("@UserID", UserInfo.ID),
                    new MySqlParameter("@UserName", UserInfo.LoginName),
                    new MySqlParameter("@EntryDate", Util.GetDateTime(DateTime.Now)),
                    new MySqlParameter("@VerificationRemarks", fm.StockPhysicalVerificationRemarks),
                     new MySqlParameter("@qutationid", fm.qutationid),
                      new MySqlParameter("@Rate", fm.Rate),
                       new MySqlParameter("@DiscountPer", fm.DiscountPer),
                        new MySqlParameter("@DiscountAmount", fm.DiscountAmount),
                         new MySqlParameter("@TaxPer", fm.TaxPer),
                          new MySqlParameter("@TaxAmount", fm.TaxAmount),
                           new MySqlParameter("@UnitPrice", fm.UnitPrice),
                             new MySqlParameter("@MRP", fm.MRP)
                    
                    );
            }

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;

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
    public static string approvestock(List<StoreNMStock> mydataadj, List<StoreNMStock> mydatapro, string deletedtemid)
    {
    
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (mydataadj.Count > 0)
            {
                string LedgerTransactionID = "";
                string LedgerTransactionNo = "";
                StoreLedgerTransaction lt = new StoreLedgerTransaction(tnx);
                lt.VendorID = 0;
                lt.TypeOfTnx = "StockAdjustment";
                lt.PurchaseOrderNo = "";
                lt.GrossAmount = 0;
                lt.DiscountOnTotal = 0;
                lt.TaxAmount = 0;
                lt.NetAmount = 0;
                lt.InvoiceAmount = 0;
                lt.InvoiceAttachment = 0;
                lt.Remarks = "";
                lt.Freight = 0;
                lt.Octori = 0;
                lt.IsReturnable = 0;
                lt.RoundOff = 0;
                lt.LocationID = mydataadj[0].LocationID;
                string ss = lt.Insert();
                LedgerTransactionID = ss.Split('#')[0];
                LedgerTransactionNo = ss.Split('#')[1];
                foreach (StoreNMStock stockdata in mydataadj)
                {
                    StoreNMStock ststock = new StoreNMStock(tnx);

                    ststock.ItemID = stockdata.ItemID;
                    ststock.ItemName = stockdata.ItemName;
                    ststock.LedgerTransactionID = Util.GetInt(LedgerTransactionID);
                    ststock.LedgerTransactionNo = LedgerTransactionNo;
                    ststock.BatchNumber = stockdata.BatchNumber;

                    ststock.Rate = stockdata.Rate;
                    ststock.DiscountPer = stockdata.DiscountPer;
                    ststock.DiscountAmount = stockdata.DiscountAmount;
                    ststock.TaxPer = stockdata.TaxPer;
                    ststock.TaxAmount = stockdata.TaxAmount;
                    ststock.UnitPrice = stockdata.UnitPrice;
                    ststock.MRP = stockdata.MRP;
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
                    ststock.FromLocationID = 0;
                    ststock.FromStockID = 0;
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
                    ststock.IsPost = 1;

                    ststock.IsExpirable = stockdata.IsExpirable;
                    ststock.IssueMultiplier = stockdata.IssueMultiplier;
                    ststock.PackSize = stockdata.PackSize;


                  
                    ststock.BarcodeOption = stockdata.BarcodeOption;
                    ststock.BarcodeGenrationOption = stockdata.BarcodeGenrationOption;
                    ststock.IssueInFIFO = stockdata.IssueInFIFO;

                    ststock.MajorUnitInDecimal = stockdata.MajorUnitInDecimal;
                    ststock.MinorUnitInDecimal = stockdata.MinorUnitInDecimal;

                    ststock.PostDate = DateTime.Now;
                    ststock.PostUserID = UserInfo.ID.ToString();
                    string stockid = ststock.Insert();
                    if (stockid == "")
                    {
                        tnx.Rollback();

                        return "0";
                    }

                    if (stockdata.qutationid == "0")
                    {
                        string stTax = " SELECT stockid,itemid,taxname,percentage,taxamt FROM st_taxchargedlist WHERE stockid='" + stockdata.FromStockID + "' and itemid='" + stockdata.ItemID + "'  ";
                        DataTable dtTax = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, stTax).Tables[0];
                        foreach (DataRow dw in dtTax.Rows)
                        {

                            StoreTaxChargedList objTCharged = new StoreTaxChargedList(tnx);
                            objTCharged.LedgerTransactionNo = LedgerTransactionNo;
                            objTCharged.LedgerTransactionID = Util.GetInt(LedgerTransactionID);
                            objTCharged.ItemID = Util.GetInt(dw["itemid"]);
                            objTCharged.TaxName = Util.GetString(dw["TaxName"]);
                            objTCharged.Percentage = Util.GetFloat(dw["percentage"]);
                            objTCharged.TaxAmt = Util.GetFloat(dw["TaxAmt"]);
                            objTCharged.StockID = Util.GetInt(stockid);

                            string TaxChrgID = objTCharged.Insert();

                            if (TaxChrgID == string.Empty)
                            {
                                tnx.Rollback();
                                return "0#Tax Not Saved";
                            }

                        }
                    }
                    else
                    {
                        string stTax = " SELECT itemid,IGSTPer,CGSTPer,SGSTPer,(`GSTAmount`/`ConversionFactor`)TaxAmount FROM st_vendorqutation WHERE id='" + stockdata.qutationid + "' and itemid='" + stockdata.ItemID + "'  ";
                        DataTable dtTax = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, stTax).Tables[0];
                        if (dtTax.Rows.Count == 0)
                        {
                            tnx.Rollback();
                            return "0#Tax Not Saved";

                        }

                        if (Util.GetFloat(dtTax.Rows[0]["IGSTPer"]) > 0)
                        {
                            StoreTaxChargedList objTCharged = new StoreTaxChargedList(tnx);
                            objTCharged.LedgerTransactionNo = LedgerTransactionNo;
                            objTCharged.LedgerTransactionID = Util.GetInt(LedgerTransactionID);
                            objTCharged.ItemID = Util.GetInt(dtTax.Rows[0]["itemid"]);
                            objTCharged.TaxName = "IGST";
                            objTCharged.Percentage = Util.GetFloat(dtTax.Rows[0]["IGSTPer"]);
                            objTCharged.TaxAmt = Util.GetFloat(dtTax.Rows[0]["TaxAmount"]);
                            objTCharged.StockID = Util.GetInt(stockid);

                            string TaxChrgID = objTCharged.Insert();

                            if (TaxChrgID == string.Empty)
                            {
                                tnx.Rollback();
                                return "0#Tax Not Saved";
                            }
                        }
                        if (Util.GetFloat(dtTax.Rows[0]["CGSTPer"]) > 0)
                        {
                            StoreTaxChargedList objTCharged = new StoreTaxChargedList(tnx);
                            objTCharged.LedgerTransactionNo = LedgerTransactionNo;
                            objTCharged.LedgerTransactionID = Util.GetInt(LedgerTransactionID);
                            objTCharged.ItemID = Util.GetInt(dtTax.Rows[0]["itemid"]);
                            objTCharged.TaxName = "CGST";
                            objTCharged.Percentage = Util.GetFloat(dtTax.Rows[0]["CGSTPer"]);
                            objTCharged.TaxAmt = Util.GetFloat(dtTax.Rows[0]["TaxAmount"])/2;
                            objTCharged.StockID = Util.GetInt(stockid);

                            string TaxChrgID = objTCharged.Insert();

                            if (TaxChrgID == string.Empty)
                            {
                                tnx.Rollback();
                                return "0#Tax Not Saved";
                            }
                        }
                        if (Util.GetFloat(dtTax.Rows[0]["SGSTPer"]) > 0)
                        {
                            StoreTaxChargedList objTCharged = new StoreTaxChargedList(tnx);
                            objTCharged.LedgerTransactionNo = LedgerTransactionNo;
                            objTCharged.LedgerTransactionID = Util.GetInt(LedgerTransactionID);
                            objTCharged.ItemID = Util.GetInt(dtTax.Rows[0]["itemid"]);
                            objTCharged.TaxName = "SGST";
                            objTCharged.Percentage = Util.GetFloat(dtTax.Rows[0]["SGSTPer"]);
                            objTCharged.TaxAmt = Util.GetFloat(dtTax.Rows[0]["TaxAmount"]) / 2;
                            objTCharged.StockID = Util.GetInt(stockid);

                            string TaxChrgID = objTCharged.Insert();

                            if (TaxChrgID == string.Empty)
                            {
                                tnx.Rollback();
                                return "0#Tax Not Saved";
                            }
                        }

                    }


                    if (ststock.BarcodeGenrationOption == 2 && ststock.BarcodeNo == "")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_nmstock set Barcodeno=stockid where stockid=" + stockid + "");
                    }



                    if (stockdata.StockPhysicalVerificationID != "0")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_StockPhysicalVerification set Approved=1,ApprovedByID=" + UserInfo.ID + ",ApprovedByName='" + UserInfo.LoginName + "',ApprovedDate=now() where ID=" + stockdata.StockPhysicalVerificationID + "");
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into st_StockPhysicalVerification(StockID,fromstockid,locationid,ItemID,OldQty,NewQty,NewBatch,NewBatchExpiryDate,Month,Year,UserID,UserName,EntryDate,Approved,ApprovedByID,ApprovedByName,ApprovedDate,VerificationRemarks,qutationid,Rate,DiscountPer,DiscountAmount,TaxPer,TaxAmount,UnitPrice,MRP) values (@StockID,@fromstockid,@locationid,@ItemID,@OldQty,@NewQty,@NewBatch,@NewBatchExpiryDate,@Month,@Year,@UserID,@UserName,@EntryDate,@Approved,@ApprovedByID,@ApprovedByName,@ApprovedDate,@VerificationRemarks,@qutationid,@Rate,@DiscountPer,@DiscountAmount,@TaxPer,@TaxAmount,@UnitPrice,@MRP)",
                  new MySqlParameter("@StockID", stockdata.FromStockID),
                  new MySqlParameter("@fromstockid", stockdata.FromStockID),
                  new MySqlParameter("@locationid", stockdata.LocationID),
                  new MySqlParameter("@ItemID", stockdata.ItemID),
                  new MySqlParameter("@OldQty", stockdata.InitialCount_old),
                  new MySqlParameter("@NewQty", stockdata.InitialCount_New),
                  new MySqlParameter("@NewBatch", stockdata.BatchNumber),
                  new MySqlParameter("@NewBatchExpiryDate", Util.GetDateTime(stockdata.ExpiryDate).ToString("yyyy-MM-dd")),
                  new MySqlParameter("@Month", DateTime.Now.Month),
                  new MySqlParameter("@Year", DateTime.Now.Year),
                  new MySqlParameter("@UserID", UserInfo.ID),
                  new MySqlParameter("@UserName", UserInfo.LoginName),
                  new MySqlParameter("@EntryDate", Util.GetDateTime(DateTime.Now)),
                  new MySqlParameter("@Approved", "1"),
                  new MySqlParameter("@ApprovedByID", UserInfo.ID),
                  new MySqlParameter("@ApprovedByName", UserInfo.LoginName),
                  new MySqlParameter("@ApprovedDate", Util.GetDateTime(DateTime.Now)),
                  new MySqlParameter("@VerificationRemarks", stockdata.StockPhysicalVerificationRemarks),
                   new MySqlParameter("@qutationid", stockdata.qutationid),
                      new MySqlParameter("@Rate", stockdata.Rate),
                       new MySqlParameter("@DiscountPer", stockdata.DiscountPer),
                        new MySqlParameter("@DiscountAmount", stockdata.DiscountAmount),
                         new MySqlParameter("@TaxPer", stockdata.TaxPer),
                          new MySqlParameter("@TaxAmount", stockdata.TaxAmount),
                           new MySqlParameter("@UnitPrice", stockdata.UnitPrice),
                             new MySqlParameter("@MRP", stockdata.MRP));
                    }
                  
                }
            }

            if (mydatapro.Count > 0)
            {

                foreach (StoreNMStock stockdata in mydatapro)
                {



                    int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_getsalesno(3)"));
                    StoreSalesDetail objnssaled = new StoreSalesDetail(tnx);
                    objnssaled.FromLocationID = Util.GetInt(mydatapro[0].LocationID);
                    objnssaled.ToLocationID = Util.GetInt(mydatapro[0].LocationID);
                    objnssaled.StockID = Util.GetInt(stockdata.StockID);
                    objnssaled.Quantity = Util.GetFloat(Util.GetFloat(stockdata.InitialCount));
                    objnssaled.TrasactionTypeID = 3;
                    objnssaled.TrasactionType = "StockAdjustMent";
                    objnssaled.ItemID = Util.GetInt(stockdata.ItemID);

                    objnssaled.IndentNo = "";
                    objnssaled.Naration = "";
                    objnssaled.SalesNo = SalesNo;

                    string saledid = objnssaled.Insert();
                    if (saledid == string.Empty)
                    {
                        tnx.Rollback();
                        return "Sales Not Saved";
                    }


                    string sql = "";
                    sql = "select if(InitialCount < (ReleasedCount+" + Util.GetFloat(stockdata.InitialCount) + "),0,1)CHK from st_nmstock where stockID=" + stockdata.StockID;
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql)) <= 0)
                    {
                        tnx.Rollback();
                        return "0";
                    }


                    sql = "update st_nmstock set ReleasedCount = ReleasedCount + " + Util.GetFloat(stockdata.InitialCount) + " where StockID = '" + stockdata.StockID + "'  and ItemID = '" + stockdata.ItemID + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);


                    if (stockdata.StockPhysicalVerificationID != "0")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_StockPhysicalVerification set Approved=1,ApprovedByID=" + UserInfo.ID + ",ApprovedByName='" + UserInfo.LoginName + "',ApprovedDate=now() where ID=" + stockdata.StockPhysicalVerificationID + "");
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into st_StockPhysicalVerification(StockID,fromstockid,locationid,ItemID,OldQty,NewQty,NewBatch,NewBatchExpiryDate,Month,Year,UserID,UserName,EntryDate,Approved,ApprovedByID,ApprovedByName,ApprovedDate,VerificationRemarks,qutationid,Rate,DiscountPer,DiscountAmount,TaxPer,TaxAmount,UnitPrice,MRP) values (@StockID,@fromstockid,@locationid,@ItemID,@OldQty,@NewQty,@NewBatch,@NewBatchExpiryDate,@Month,@Year,@UserID,@UserName,@EntryDate,@Approved,@ApprovedByID,@ApprovedByName,@ApprovedDate,@VerificationRemarks,@qutationid,@Rate,@DiscountPer,@DiscountAmount,@TaxPer,@TaxAmount,@UnitPrice,@MRP)",
                    new MySqlParameter("@StockID", stockdata.FromStockID),
                    new MySqlParameter("@fromstockid", stockdata.FromStockID),
                    new MySqlParameter("@locationid", stockdata.LocationID),
                    new MySqlParameter("@ItemID", stockdata.ItemID),
                    new MySqlParameter("@OldQty", stockdata.InitialCount_old),
                    new MySqlParameter("@NewQty", stockdata.InitialCount_New),
                    new MySqlParameter("@NewBatch", stockdata.BatchNumber),
                    new MySqlParameter("@NewBatchExpiryDate", Util.GetDateTime(stockdata.ExpiryDate).ToString("yyyy-MM-dd")),
                    new MySqlParameter("@Month", DateTime.Now.Month),
                    new MySqlParameter("@Year", DateTime.Now.Year),
                    new MySqlParameter("@UserID", UserInfo.ID),
                    new MySqlParameter("@UserName", UserInfo.LoginName),
                    new MySqlParameter("@EntryDate", Util.GetDateTime(DateTime.Now)),
                    new MySqlParameter("@Approved", "1"),
                    new MySqlParameter("@ApprovedByID", UserInfo.ID),
                    new MySqlParameter("@ApprovedByName", UserInfo.LoginName),
                    new MySqlParameter("@ApprovedDate", Util.GetDateTime(DateTime.Now)),
                   new MySqlParameter("@VerificationRemarks", stockdata.StockPhysicalVerificationRemarks),
                   new MySqlParameter("@qutationid", stockdata.qutationid),
                      new MySqlParameter("@Rate", stockdata.Rate),
                       new MySqlParameter("@DiscountPer", stockdata.DiscountPer),
                        new MySqlParameter("@DiscountAmount", stockdata.DiscountAmount),
                         new MySqlParameter("@TaxPer", stockdata.TaxPer),
                          new MySqlParameter("@TaxAmount", stockdata.TaxAmount),
                           new MySqlParameter("@UnitPrice", stockdata.UnitPrice),
                             new MySqlParameter("@MRP", stockdata.MRP));
                    }

                }

            }



            if (deletedtemid != "")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_StockPhysicalVerification set isactive=0 where  ID in(" + deletedtemid.TrimEnd(',') + ")");
                   
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
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string binditem(string locationid)
    {
        StringBuilder sb=new StringBuilder();
        sb.Append(" select concat(si.itemid,'#',BarcodeOption)itemid,typename from st_itemmaster si ");
        sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`   ");
        sb.Append(" AND smm.`LocationId`=" + locationid.Split('#')[0] + "  ");
       
        sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2 and BarcodeGenrationOption=1");
        
        sb.Append(" order by typename");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savebarcode(string itemid, string barcodeno)
    {
        string type = "0";
        if (itemid.Split('#')[1] == "2")
        {
            string olditemid = Util.GetString(StockReports.ExecuteScalar("select itemid from st_itemmaster_barcode where Barcode='" + barcodeno + "'"));
            if (olditemid == "")
            {
                StockReports.ExecuteDML("insert into st_itemmaster_barcode(ItemID,Barcode,EntryDateTime,UserID) values ('" + itemid.Split('#')[0] + "','" + barcodeno + "',now(),'" + UserInfo.ID + "')");
            }
            
                type = "1";
            
        }
        else
        {
            type = "2";
        }

        return type;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string checkduplicatebatchno(string itemid, string batchno, string locationid)
    {


        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT `BatchNumber`,if(`ExpiryDate`='0001-01-01',null,DATE_FORMAT(ExpiryDate,'%d-%b-%Y'))ExpiryDate,Rate,  DiscountPer,DiscountAmount,TaxPer,TaxAmount,UnitPrice,MRP FROM st_nmstock where itemid='" + itemid + "' and BatchNumber='" + batchno + "' and locationid='" + locationid + "' order by stockid desc limit 1"));
    }

    [WebMethod]
    public static string getquotdata(string locationid)
    {

         StringBuilder sb = new StringBuilder();
        sb.Append("  ");

        sb.Append(" SELECT sv.`DeliveryStateName`,sv.`VednorStateName`, sv.`VendorName`,sv.`ID` qutationid,  si.`ItemID`,si.`TypeName`,sm.name itemgroup,IFNULL(snt.stockid,0)stockid,si.`Converter`,  ");
         sb.Append(" (sv.`Rate`/si.`Converter`) Rate,  ");
         sb.Append(" (sv.`DiscountAmt`/si.`Converter`)DiscountAmt,sv.`DiscountPer`,  ");
         sb.Append(" sv.`IGSTPer`,sv.`CGSTPer`,sv.`SGSTPer`,  ");
         sb.Append(" (sv.`GSTAmount`/si.`Converter`)TaxAmount,  ");
         
         sb.Append(" (sv.`BuyPrice`/si.`Converter`)UnitPrice  ");
         
         sb.Append(" FROM st_itemmaster si     ");
         sb.Append(" INNER JOIN st_subcategorymaster sm ON sm.SubCategoryID=si.SubCategoryID    ");
         sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`    ");
         sb.Append(" AND smm.`LocationId`=" + locationid.Split('#')[0] + "  ");
         sb.Append(" INNER JOIN st_vendorqutation sv ON sv.`ItemID`=si.`ItemID` AND sv.`ApprovalStatus`=2 AND sv.`IsActive`=1  ");
         sb.Append(" AND sv.`ComparisonStatus`=1 AND sv.`DeliveryLocationID`=" + locationid.Split('#')[0] + "       ");
         
         sb.Append(" LEFT JOIN   ");
         sb.Append(" (SELECT itemid,stockid FROM st_nmstock  ");
         sb.Append(" WHERE `LocationId`=" + locationid.Split('#')[0] + " AND (`InitialCount` - `ReleasedCount` - `PendingQty` ) >0 AND `IsPost`=1  ");
         sb.Append(" GROUP BY stockid ) snt ON snt.ItemID=si.itemid  ");

         //sb.Append(" WHERE IFNULL(snt.stockid,0)=0 ");
         sb.Append(" where sv.id not in (select qutationid from st_StockPhysicalVerification where locationid=" + locationid.Split('#')[0] + " and isactive=1 and Approved=0)");
         sb.Append(" order by si.`TypeName`");

         return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


   
    
}

public class StockPhysicalVerify
{
    public int itemid { get; set; }
    public int stockid { get; set; }
    public int fromstockid { get; set; }
    public float OldQty { get; set; }
    public float NewQty { get; set; }
    public string NewBatch { get; set; }
    public DateTime NewBatchExpiryDate { get; set; }
    public int LocationID { get; set; }
    public string StockPhysicalVerificationRemarks { get; set; }
    public string qutationid { get; set; }
    public float Rate { get; set; }
    public float DiscountPer { get; set; }
    public float DiscountAmount { get; set; }
    public float TaxPer { get; set; }
    public float TaxAmount { get; set; }
    public float UnitPrice { get; set; }
    public float MRP { get; set; }
}
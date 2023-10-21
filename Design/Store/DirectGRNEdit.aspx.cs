using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_DirectGRNEdit : System.Web.UI.Page
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
            txtgrnno.Text = StockReports.ExecuteScalar("select LedgerTransactionNo from st_ledgertransaction where LedgerTransactionID=" + Util.GetString(Request.QueryString["GRNID"]) + " ");
            txtgrnid.Text = Util.GetString(Request.QueryString["GRNID"]);
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

            ddllocation.Enabled = false;

        }

    }




    

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchItemDetail(string itemid, string qtype, string locationid, string barcodeno, string vendorid)
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
        sb.Append(" qut.Rate,qut.DiscountPer,qut.IGSTPer,qut.SGSTPer,qut.CGSTPer");
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
        sb.Append(" inner join (select Rate,DiscountPer,IGSTPer,SGSTPer,CGSTPer,itemid from st_vendorqutation where vendorid='" + vendorid + "' and DeliveryLocationID='" + locationid.Split('#')[0] + "' and ComparisonStatus=1 and IsActive=1 and ApprovalStatus=2 and EntryDateTo>=date(now())  order by id desc) qut on qut.itemid=si.itemid ");
        sb.Append("  WHERE si.isactive=1 AND si.approvalstatus=2  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
   

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindoldgrndata(string grnid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select ifnull(imm.expdatecutoff,0)expdatecutoff, st.MajorUnitInDecimal,st.MinorUnitInDecimal, lt.PurchaseOrderNo, st.barcodeno, imm.IsExpirable, lt.UpdateRemarks, lt.LedgerTransactionID,lt.LedgerTransactionNo, group_concat(st.stockid ORDER BY isfree ASC)stockid,lt.remarks, st.MajorUnit,st.itemid,st.itemname, lt.locationid,st.panel_id, concat(lt.locationid,'#',st.panel_id)locid,lt.vendorid,  ");
        sb.Append(" st.MacID,st.ManufactureID,st.MinorUnitID,st.MajorUnitID,st.ItemID,st.MinorUnit,st.Converter,st.MajorUnit,imm.HsnCode,imm.apolloitemcode,sm.name itemgroup,");
        sb.Append(" lt.InvoiceNo,date_format(lt.InvoiceDate,'%d-%b-%Y')InvoiceDate,lt.ChalanNo,date_format(lt.ChalanDate,'%d-%b-%Y')ChalanDate,lt.InvoiceAmount,lt.Freight,lt.Octori,lt.GatePassInWard,lt.RoundOff,lt.NetAmount, ");
        sb.Append(" st.batchnumber,IF(st.`ExpiryDate`='0001-01-01','',DATE_FORMAT(ExpiryDate,'%d-%b-%Y')) ExpiryDate,");
        sb.Append(" sum(st.rate*st.Converter) rate,sum(if(isfree=0,initialcount,0)+if(isfree=0,releasedcount,0)+if(isfree=0,pendingqty,0))/st.Converter PaidQty,sum(if(isfree=1,initialcount,0)+if(isfree=1,releasedcount,0)+if(isfree=1,pendingqty,0))/st.Converter freeQty,SUM(st.DiscountPer)DiscountPer,SUM(st.DiscountAmount*st.Converter)DiscountAmount,SUM(st.TaxPer)TaxPer,sum(st.TaxAmount*st.Converter)TaxAmount,sum(st.UnitPrice*st.Converter)UnitPrice");
        sb.Append(" , IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=st.stockid   AND taxname='IGST') ,'') IGSTPer,");
        sb.Append(" IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=st.stockid   AND taxname='CGST') ,'') CGSTPer,");
        sb.Append(" IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=st.stockid   AND taxname='SGST') ,'') SGSTPer ");
        sb.Append(" ,st.IssueMultiplier,st.PackSize,st.BarcodeOption,st.BarcodeGenrationOption,st.IssueInFIFO ");
        sb.Append(" from st_ledgertransaction lt");
        sb.Append(" inner join st_nmstock st on st.LedgerTransactionID=lt.LedgerTransactionID and st.ispost=0  ");
        sb.Append(" inner join st_itemmaster imm on st.itemid=imm.itemid");
        sb.Append(" INNER JOIN st_subcategorymaster sm ON sm.SubCategoryID=imm.SubCategoryID   ");

        sb.Append(" where lt.LedgerTransactionID=" + grnid + " and IsDirectGRN=1 and lt.iscancel=0 group by st.itemid,batchnumber order by st.stockid ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string updatedirectgrn(StoreLedgerTransaction st_ledgertransaction, List<StoreNMStock> st_nmstock, List<StoreTaxChargedList> taxdata, string deleteditem)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx,CommandType.Text,"delete from st_taxchargedlist where LedgerTransactionID=" + st_ledgertransaction.LedgerTransactionID );

            string LedgerTransactionID = st_ledgertransaction.LedgerTransactionID.ToString();
            string LedgerTransactionNo = st_ledgertransaction.LedgerTransactionNo.ToString();
            StoreLedgerTransaction lt = new StoreLedgerTransaction(tnx);
            lt.LedgerTransactionID = st_ledgertransaction.LedgerTransactionID;
            lt.LedgerTransactionNo = st_ledgertransaction.LedgerTransactionNo;
            lt.VendorID = st_ledgertransaction.VendorID;
            lt.TypeOfTnx = st_ledgertransaction.TypeOfTnx;
            lt.PurchaseOrderNo = st_ledgertransaction.PurchaseOrderNo;
            lt.GrossAmount = st_ledgertransaction.GrossAmount;
            lt.DiscountOnTotal = st_ledgertransaction.DiscountOnTotal;
            lt.TaxAmount = st_ledgertransaction.TaxAmount;
            lt.NetAmount = st_ledgertransaction.NetAmount;
            lt.InvoiceAmount = st_ledgertransaction.InvoiceAmount;
           
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
            lt.UpdateRemarks = st_ledgertransaction.UpdateRemarks;
            string ss =Util.GetString(lt.Update());
            
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
                ststock.UpdateRemarks = st_ledgertransaction.UpdateRemarks;
                string stockid = "";
                if (stockdata.StockID == 0)
                {
                     stockid = ststock.Insert();
                     if (ststock.BarcodeGenrationOption == 2 && ststock.BarcodeNo == "")
                     {
                         MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_nmstock set Barcodeno=stockid where stockid=" + stockid + "");
                     }
                }
                else
                {
                    stockid = stockdata.StockID.ToString();
                    ststock.StockID = stockdata.StockID;
                    ststock.Update();
                }
                if (stockid == "")
                {
                    tnx.Rollback();

                    return "0";
                }
                if (ststock.IsFree == 0)
                {
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
                }
            }
            if (deleteditem != "")
            {
                deleteditem = "'" + deleteditem + "'";
                deleteditem = deleteditem.Replace(",", "','");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_nmstock set LedgerTransactionIDOLD=LedgerTransactionID,LedgerTransactionNoOLD=LedgerTransactionNo ,LedgerTransactionID=0,LedgerTransactionNo='',ispost=3 where stockid in (" + deleteditem + ")");
            }
         
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
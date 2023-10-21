using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_IndentReceive : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
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
        }

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string location, string fromdate, string todate, string indentno, string indenttype)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select * from (");
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
        sb.Append(" inner join st_indentissuedetail sid on std.itemid=sid.itemid and std.indentno=sid.indentno ");//and sid.DispatchStatus=3
        sb.Append(" where std.indentno<>'' and  std.indenttype in('SI','Direct','Dir') ");

        sb.Append(" and dtentry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" and dtentry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
       // sb.Append(" and sid.Datetime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        //sb.Append(" and sid.ReceiveDate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (location == "0")
        {
            sb.Append(" AND fromlocationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        }
        else
        {
            sb.Append(" AND fromlocationid='" + location + "'");
        }
       

        if (indentno != "")
        {
            sb.Append(" AND std.indentno='" + indentno + "'");
        }

        sb.Append("  GROUP BY std.indentno ORDER BY std.IndentNo)t");
        if (indenttype != "All")
            sb.Append(" where t.Status='" + indenttype + "'");
//System.IO.File.WriteAllText (@"D:\searchindent.txt", sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindItemDetail(string IndentNo, string locationid, string itemid)
    {
      
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT stt.barcodeno, ifnull(sid.PendingRemarks,'')PendingRemarks, stt.MinorUnitInDecimal, std.minorunitname, sid.id,std.itemid,stt.itemname,ReqQty,ApprovedQty,sid.ReceiveQty,std.RejectQty,sid.sendqty PendingQty,std.frompanelid,std.fromlocationid,(sid.sendqty-sid.ReceiveQty-sid.ConsumeQty-sid.StockInQty) PrQty,");


        sb.Append("  (CASE   ");
        sb.Append("  WHEN sid.sendqty=(sid.ReceiveQty+sid.ConsumeQty+sid.StockInQty)  THEN '#90EE90'   ");
        sb.Append("  WHEN sid.sendqty>(sid.ReceiveQty+sid.ConsumeQty+sid.StockInQty) and sid.ReceiveQty>0 THEN 'Yellow' ");
        sb.Append("  else   'white'  END ) `Rowcolor` ,");


        sb.Append("  (CASE   ");
        sb.Append("  WHEN sid.sendqty=(sid.ReceiveQty+sid.ConsumeQty+sid.StockInQty)  THEN 'Received'   ");
        sb.Append("  WHEN sid.sendqty>(sid.ReceiveQty+sid.ConsumeQty+sid.StockInQty)  and sid.ReceiveQty>0 THEN 'Partial Received' ");
        sb.Append("   else   'Pending For Received'  END ) `Status` ,");

    
        sb.Append(" sid.stockid,sid.IssueInvoiceNo ");

        sb.Append("  FROM st_indent_detail std  ");
    
        sb.Append(" inner join st_indentissuedetail sid on std.itemid=sid.itemid and std.indentno=sid.indentno ");
        sb.Append(" inner join st_nmstock stt on sid.stockid=stt.stockid and stt.itemid=std.itemid");
        
        sb.Append(" where std.indentno='" + IndentNo + "'");
        if (itemid != "")
        {
            sb.Append(" and std.itemid='"+itemid+"'");
        }

        sb.Append(" group by stt.itemid,sid.stockid,sid.IssueInvoiceNo");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

   

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string ReceiveAll(List<ReceiveDetail> mydataadj)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            foreach (ReceiveDetail ReDetail in mydataadj)
            {

                string IndentNo = ReDetail.IndentNo;
                string itemid = ReDetail.itemid;
                string stockid = ReDetail.stockid;
                string issueqty = ReDetail.Receiveqty;
                string fromlocation = ReDetail.fromlocation;
                string frompanel = ReDetail.frompanel;
                string IssueInvoiceNo = ReDetail.IssueInvoiceNo;
                string PendingRemarks = ReDetail.PendingRemarks;
                StringBuilder sb = new StringBuilder();
                sb.Append("   SELECT StockID,ItemID,ItemName,BatchNumber,Rate,DiscountPer,DiscountAmount,TaxPer,TaxAmount,UnitPrice,MRP, ");
                sb.Append("   ManufactureID,MacID,MajorUnitID,MajorUnit,MinorUnitID,MinorUnit,Converter,Naration,");
                sb.Append("   UnitPrice,MRP,ExpiryDate ,LocationID,Panel_Id,if(IsFree=1,1,0)IsFree,Remarks,if(Reusable=1,1,0)Reusable, BarcodeNo,");
                sb.Append("   IsExpirable,IssueMultiplier,PackSize,BarcodeOption,BarcodeGenrationOption,IssueInFIFO,MajorUnitInDecimal,MinorUnitInDecimal ");
                sb.Append("   from st_nmstock where StockID='" + stockid + "' ");
// System.IO.File.WriteAllText (@"D:\recev.txt", sb.ToString());

                DataTable dtResult = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString()).Tables[0];
                if (dtResult != null && dtResult.Rows.Count > 0)
                {

                   float pendingqty=Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select  (sid.sendqty-sid.ReceiveQty-sid.ConsumeQty-sid.StockInQty) pendingqty from st_indentissuedetail sid where IndentNo='" + IndentNo + "' and stockid='" + stockid + "' and itemid='" + itemid + "' and IssueInvoiceNo='" + IssueInvoiceNo + "'"));


                   if (Util.GetFloat(issueqty) > pendingqty)
                   {
                       tnx.Rollback();

                       return "Receive Qty Can't Greater Then Pending Qty";
                   }
                   




                    StoreNMStock ststock = new StoreNMStock(tnx);

                    ststock.ItemID = Util.GetInt(dtResult.Rows[0]["ItemID"].ToString());
                    ststock.ItemName = Util.GetString(dtResult.Rows[0]["ItemName"].ToString());
                    ststock.LedgerTransactionID = 0;
                    ststock.LedgerTransactionNo = "";
                    ststock.BatchNumber = Util.GetString(dtResult.Rows[0]["BatchNumber"].ToString());

                    ststock.Rate = Util.GetFloat(dtResult.Rows[0]["Rate"].ToString());
                    ststock.DiscountPer = Util.GetFloat(dtResult.Rows[0]["DiscountPer"].ToString());
                    ststock.DiscountAmount = Util.GetFloat(dtResult.Rows[0]["DiscountAmount"].ToString());
                    ststock.TaxPer = Util.GetFloat(dtResult.Rows[0]["TaxPer"].ToString());
                    ststock.TaxAmount = Util.GetFloat(dtResult.Rows[0]["TaxAmount"].ToString());
                    ststock.UnitPrice = Util.GetFloat(dtResult.Rows[0]["UnitPrice"].ToString());
                    ststock.MRP = Util.GetFloat(dtResult.Rows[0]["MRP"].ToString());
                    ststock.InitialCount = Util.GetFloat(issueqty);
                    ststock.ReleasedCount = 0;
                    ststock.PendingQty = 0;
                    ststock.RejectQty = 0;


                    ststock.ExpiryDate = Util.GetDateTime(dtResult.Rows[0]["ExpiryDate"].ToString());


                    ststock.Naration = Util.GetString(dtResult.Rows[0]["Naration"].ToString());
                    ststock.IsFree = Util.GetInt(dtResult.Rows[0]["IsFree"].ToString());

                    ststock.LocationID = Util.GetInt(fromlocation);
                    ststock.Panel_Id = Util.GetInt(frompanel);

                    ststock.IndentNo = IndentNo;
                    ststock.FromLocationID = Util.GetInt(dtResult.Rows[0]["LocationID"].ToString());
                    ststock.FromStockID = Util.GetInt(dtResult.Rows[0]["StockID"].ToString());
                    ststock.Reusable = Util.GetInt(dtResult.Rows[0]["Reusable"].ToString());
                    ststock.ManufactureID = Util.GetInt(dtResult.Rows[0]["ManufactureID"].ToString());
                    ststock.MacID = Util.GetInt(dtResult.Rows[0]["MacID"].ToString());
                    ststock.MajorUnitID = Util.GetInt(dtResult.Rows[0]["MajorUnitID"].ToString());
                    ststock.MajorUnit = Util.GetString(dtResult.Rows[0]["MajorUnit"].ToString());
                    ststock.MinorUnitID = Util.GetInt(dtResult.Rows[0]["MinorUnitID"].ToString());
                    ststock.MinorUnit = Util.GetString(dtResult.Rows[0]["MinorUnit"].ToString());
                    ststock.Converter = Util.GetFloat(dtResult.Rows[0]["Converter"].ToString());
                    if (IndentNo.StartsWith("SI"))
                    {
                        ststock.Remarks = "Issue Against Indent";
                    }
                    else
                    {
                        ststock.Remarks = "Direct Stock Transfer";
                    }
                    ststock.BarcodeNo = Util.GetString(dtResult.Rows[0]["BarcodeNo"].ToString());
                    ststock.IsPost = 1;
                    ststock.PostDate = DateTime.Now;
                    ststock.PostUserID = UserInfo.ID.ToString();

                    ststock.IsExpirable = Util.GetInt(dtResult.Rows[0]["IsExpirable"].ToString());
                    ststock.IssueMultiplier = Util.GetInt(dtResult.Rows[0]["IssueMultiplier"].ToString());
                    ststock.PackSize = Util.GetString(dtResult.Rows[0]["PackSize"].ToString());



                    ststock.BarcodeOption = Util.GetInt(dtResult.Rows[0]["BarcodeOption"].ToString());
                    ststock.BarcodeGenrationOption = Util.GetInt(dtResult.Rows[0]["BarcodeGenrationOption"].ToString());
                    ststock.IssueInFIFO = Util.GetInt(dtResult.Rows[0]["IssueInFIFO"].ToString());

                    ststock.MajorUnitInDecimal = Util.GetInt(dtResult.Rows[0]["MajorUnitInDecimal"].ToString());
                    ststock.MinorUnitInDecimal = Util.GetInt(dtResult.Rows[0]["MinorUnitInDecimal"].ToString());

                    string stockidsaved = ststock.Insert();

                    if (stockidsaved == string.Empty)
                    {
                        tnx.Rollback();


                        return "Stock No Saved";
                    }

                    string fromstateid = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, @"SELECT cm.stateid FROM f_panel_master pm 
INNER JOIN centre_master cm ON cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' THEN pm.`CentreID` 
ELSE pm.tagprocessinglabid END AND pm.`PanelType` IN('Centre','PUP') AND cm.isactive=1 
WHERE pm.`Panel_ID`='" + Util.GetString(dtResult.Rows[0]["Panel_Id"]) + "'").ToString();

                    string tostateid = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, @"SELECT cm.stateid FROM f_panel_master pm 
INNER JOIN centre_master cm ON cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' THEN pm.`CentreID` 
ELSE pm.tagprocessinglabid END AND pm.`PanelType` IN('Centre','PUP') AND cm.isactive=1 
WHERE pm.`Panel_ID`='" + Util.GetInt(frompanel) + "'"));


                    float totalgstper = Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, @"SELECT SUM(percentage) FROM st_taxchargedlist where stockid='" + stockid + "' and itemid='" + itemid + "' "));

                    // case 1 if both state is same CGST and SGST is Apply



                    if (fromstateid == tostateid)
                    {

                        StoreTaxChargedList objTCharged = new StoreTaxChargedList(tnx);
                        objTCharged.LedgerTransactionNo = "";
                        objTCharged.LedgerTransactionID = 0;
                        objTCharged.ItemID = Util.GetInt(itemid);
                        objTCharged.TaxName = "CGST";
                        objTCharged.Percentage = totalgstper / 2;
                        objTCharged.TaxAmt = Util.GetFloat(dtResult.Rows[0]["TaxAmount"].ToString()) / 2;
                        objTCharged.StockID = Util.GetInt(stockidsaved);

                        string TaxChrgID = objTCharged.Insert();

                        if (TaxChrgID == string.Empty)
                        {
                            tnx.Rollback();
                            return "Tax Not Saved";
                        }

                        objTCharged = new StoreTaxChargedList(tnx);
                        objTCharged.LedgerTransactionNo = "";
                        objTCharged.LedgerTransactionID = 0;
                        objTCharged.ItemID = Util.GetInt(itemid);
                        objTCharged.TaxName = "SGST";
                        objTCharged.Percentage = totalgstper / 2;
                        objTCharged.TaxAmt = Util.GetFloat(dtResult.Rows[0]["TaxAmount"].ToString()) / 2;
                        objTCharged.StockID = Util.GetInt(stockidsaved);

                        string TaxChrgID1 = objTCharged.Insert();

                        if (TaxChrgID1 == string.Empty)
                        {
                            tnx.Rollback();
                            return "Tax Not Saved";
                        }


                    }

                    // case 2 if both state is diffrent IGST is Apply
                    else
                    {

                        StoreTaxChargedList objTCharged = new StoreTaxChargedList(tnx);
                        objTCharged.LedgerTransactionNo = "";
                        objTCharged.LedgerTransactionID = 0;
                        objTCharged.ItemID = Util.GetInt(itemid);
                        objTCharged.TaxName = "IGST";
                        objTCharged.Percentage = totalgstper;
                        objTCharged.TaxAmt = Util.GetFloat(dtResult.Rows[0]["TaxAmount"].ToString());
                        objTCharged.StockID = Util.GetInt(stockidsaved);

                        string TaxChrgID = objTCharged.Insert();

                        if (TaxChrgID == string.Empty)
                        {
                            tnx.Rollback();
                            return "Tax Not Saved";
                        }
                    }



                    int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_getsalesno(2)"));
                    StoreSalesDetail objnssaled = new StoreSalesDetail(tnx);
                    objnssaled.FromLocationID = Util.GetInt(dtResult.Rows[0]["LocationID"].ToString());
                    objnssaled.ToLocationID = Util.GetInt(fromlocation);
                    objnssaled.StockID = Util.GetInt(dtResult.Rows[0]["StockID"].ToString());
                    objnssaled.Quantity = Util.GetFloat(issueqty);
                    objnssaled.TrasactionTypeID = 2;
                    objnssaled.TrasactionType = "Issue";
                    objnssaled.ItemID = Util.GetInt(itemid);
                    if (IndentNo.StartsWith("SI"))
                    {
                        objnssaled.IssueType = "Issue From SI";
                    }
                    else
                    {
                        objnssaled.IssueType = "Direct Stock Transfer";
                    }
                    objnssaled.IndentNo = Util.GetString(IndentNo);
                    objnssaled.Naration = "";
                    objnssaled.SalesNo = SalesNo;
                    string saledid = objnssaled.Insert();
                    if (saledid == string.Empty)
                    {
                        tnx.Rollback();
                        return "Sales Not Saved";
                    }


                    // Sales Detail InTransitReceive


                    int SalesNo1 = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_getsalesno(9)"));
                    StoreSalesDetail objnssaled1 = new StoreSalesDetail(tnx);
                    objnssaled1.FromLocationID = Util.GetInt(dtResult.Rows[0]["LocationID"].ToString());
                    objnssaled1.ToLocationID = Util.GetInt(fromlocation);
                    objnssaled1.StockID = Util.GetInt(dtResult.Rows[0]["StockID"].ToString());
                    objnssaled1.Quantity = Util.GetFloat(issueqty);
                    objnssaled1.TrasactionTypeID = 9;
                    objnssaled1.ItemID = Util.GetInt(itemid);
                    objnssaled1.TrasactionType = "InTransitReceive";
                    objnssaled1.IndentNo = Util.GetString(IndentNo);
                    objnssaled1.Naration = "";
                    objnssaled1.SalesNo = SalesNo1;
                    string saledid1 = objnssaled1.Insert();
                    if (saledid1 == string.Empty)
                    {
                        tnx.Rollback();
                        return "0#Sales Not Saved";
                    }




                    string sql = "select if(InitialCount < (ReleasedCount+" + Util.GetFloat(issueqty) + "),0,1)CHK from st_nmstock where stockID='" + stockid + "'";
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql)) <= 0)
                    {
                        tnx.Rollback();

                        return "0#Stock Unavailable";
                    }



                    sb = new StringBuilder();
                    sb.Append(" update   st_indentissuedetail set  ReceiveQty =ReceiveQty+" + Util.GetFloat(issueqty) + ",PendingRemarks='" + PendingRemarks + "' where StockID=" + stockid + " and itemid=" + itemid + " and IndentNo='" + IndentNo + "' and IssueInvoiceNo='" + IssueInvoiceNo + "' ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                    string strUpdateStock = "update st_nmstock set PendingQty = PendingQty - " + Util.GetFloat(issueqty) + ",ReleasedCount=ReleasedCount+" + Util.GetFloat(issueqty) + " where StockID = '" + stockid + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock);



                    string strUpdateIndent = "update st_indent_detail set  ReceiveQty=ReceiveQty+" + Util.GetFloat(issueqty) + "  where IndentNo = '" + IndentNo + "' and itemid= '" + itemid + "';";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateIndent);

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
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string searchindentnofrombarcode(string barcodeno)
    {
        return StockReports.ExecuteScalar("SELECT CONCAT(indentno,'#',itemid,'#',id) FROM st_indentissuedetail WHERE barcodeno='" + barcodeno + "' AND (sendqty-receiveqty-consumeqty-stockinqty)>0 LIMIT 1 ");
    }
    
}

public class ReceiveDetail
{

    public string IndentNo { get; set; }
    public string itemid { get; set; }
    public string stockid { get; set; }
    public string Receiveqty { get; set; }
    public string fromlocation { get; set; }
    public string frompanel { get; set; }

    public string IssueInvoiceNo { get; set; }
    public string PendingRemarks { get; set; }







}
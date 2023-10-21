using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;


public partial class Design_Store_IndentIssueNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

          
            txtindentno.Text = Util.GetString(Request.QueryString["IndentNo"]);

            DataTable dt = StockReports.GetDataTable("select tolocationid, frompanelid,fromlocationid,(SELECT location FROM st_locationmaster WHERE locationid=tolocationid)ToLocation,(SELECT location FROM st_locationmaster WHERE locationid=fromlocationid)FromLocation from st_indent_detail where indentno='" + txtindentno.Text + "' group by indentno");


            if (dt.Rows.Count > 0)
            {
                lblcurrentlocation.Text = dt.Rows[0]["ToLocation"].ToString();
                lblfromlocation.Text = dt.Rows[0]["FromLocation"].ToString();
                lblcurrentlocationid.Text = dt.Rows[0]["tolocationid"].ToString();
                lbltolocationid.Text = dt.Rows[0]["fromlocationid"].ToString();
                lbltopanelid.Text = dt.Rows[0]["frompanelid"].ToString();


                string res = StorePageAccess.OpenOtherStockPages(lblcurrentlocationid.Text);

                if (res != "1")
                {

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "hideme('" + res + "');", true);
                    return;
                }

                string res1 = StorePageAccess.OpenOtherStockPages(lbltolocationid.Text);

                if (res1 != "1")
                {

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "hideme('" + res1 + "');", true);
                    return;
                }
            }
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindItemDetail(string IndentNo, string locationid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT std.minorunitname, id,itemid,itemname,ApprovedQty,ReqQty,ReceiveQty,RejectQty,pendingqty,");


        sb.Append("  (CASE WHEN ApprovedQty=receiveqty THEN '#90EE90'  ");
        sb.Append(" WHEN ApprovedQty=RejectQty THEN 'Pink'   ");
        sb.Append(" WHEN receiveqty=0 and pendingqty=0  THEN 'bisque' WHEN pendingqty>0 THEN 'White' ");
        sb.Append(" WHEN ApprovedQty=receiveqty+RejectQty THEN '#90EE90'  ELSE 'yellow' END ) Rowcolor,  ");
        sb.Append("  (CASE WHEN ApprovedQty=receiveqty THEN 'Close'   ");
        sb.Append("  WHEN ApprovedQty=RejectQty THEN 'Reject'   ");
        sb.Append(" WHEN pendingqty>0 THEN 'Pending'  WHEN receiveqty=0 and pendingqty=0 THEN 'New'   ");
        sb.Append(" WHEN ApprovedQty=receiveqty+RejectQty THEN 'Close'  ELSE 'Partial' END ) `Status` ,");
        sb.Append(" (select  sum(`InitialCount` - `ReleasedCount` - `PendingQty` ) from st_nmstock st where st.itemid=std.itemid and st.locationid='" + locationid + "' and ispost=1)AblQty ");

        sb.Append("  FROM st_indent_detail std where indentno='" + IndentNo + "' and isactive=1 and ApprovedQty>0 ");



        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string RejectIndent(string IndentNo, string id, string rejectqty, string Reason)
    {
        StockReports.ExecuteDML("update st_indent_detail set RejectQty=rejectqty+" + rejectqty + ",RejectReason='" + Reason + "', RejectBy='" + UserInfo.ID + "', dtReject=now(), CancelUserId='" + UserInfo.ID + "', CancelReason='" + Reason + "', dtCancel=now() where indentno='" + IndentNo + "' and id=" + id + "");
        return "1";
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetStockIndent(string itemid, string locationid,string stockid)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("   SELECT barcodeno, IF(`ExpiryDate`='0001-01-01','aqua','chartreuse')Rowcolor, StockID,ItemID,ItemName,BatchNumber,Rate,DiscountPer,DiscountAmount,TaxPer,TaxAmount,UnitPrice,MRP ");
        sb.Append("   ManufactureID,MacID,MajorUnitID,MajorUnit,MinorUnitID,MinorUnit,Converter,");
        sb.Append("   UnitPrice,MRP,IF(`ExpiryDate`='0001-01-01','',DATE_FORMAT(ExpiryDate,'%d-%b-%Y'))ExpiryDate ,");
        sb.Append("   (InitialCount-ReleasedCount-PendingQty)AvailQty,MajorUnitInDecimal,MinorUnitInDecimal ");

        sb.Append("   from st_nmstock st where ItemID='" + itemid + "' and   locationid='" + locationid + "'");
        if (stockid != "")
        {
            sb.Append(" and stockid='" + stockid + "' ");
        }

        sb.Append("   and IF(`ExpiryDate`='0001-01-01',NOW(),ExpiryDate)>CURDATE()  and (InitialCount-ReleasedCount-PendingQty)>0 and ispost=1 order by st.ExpiryDate asc ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getitemidfrombarcode(string barcodeno, string locationid)
    {
        string itemid = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT concat(itemid,'#',stockid)itemid  ");
        sb.Append(" FROM st_nmstock WHERE locationid=" + locationid + " AND (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1 ");
        if (barcodeno != "")
        {
            sb.Append(" and BarcodeNo='" + barcodeno + "'");
        }
        

        itemid =Util.GetString(StockReports.ExecuteScalar(sb.ToString()));
        return itemid;
    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string IssueItem(List<IssueDetail> IssueDetailData)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string batchno = "";
            int issamepanel = 0;
            batchno = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_get_indent_no('SI-Inv')").ToString();

            if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM st_indent_detail WHERE indentno='" + IssueDetailData[0].IndentNo+ "' AND `FromPanelId`=`ToPanelID`")) > 0)
                   {
                       issamepanel = 1;
                   }
                  
            foreach (IssueDetail ss in IssueDetailData)
            {

               
                string IndentNo = ss.IndentNo;
                string itemid = ss.itemid;
                string stockid = ss.stockid;
                string issueqty = ss.issueqty;
                string BarcodeNo = ss.BarcodeNo;
                StringBuilder sb = new StringBuilder();
                sb.Append("   SELECT StockID,locationid ");
                sb.Append("   from st_nmstock where StockID='" + stockid + "' ");
                sb.Append("   and (InitialCount-ReleasedCount-PendingQty)>0  and ispost=1 ");


                DataTable dtResult = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString()).Tables[0];
                if (dtResult != null && dtResult.Rows.Count > 0)
                {

                    string sql = "select if(InitialCount < (ReleasedCount+PendingQty+" + issueqty + "),0,1)CHK from st_nmstock where stockID='" + stockid + "'";
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql)) <= 0)
                    {
                        tnx.Rollback();

                        return "0#Stock Unavailable";
                    }

                    sb = new StringBuilder();



                    if (issamepanel == 1)
                    {
                        sb.Append(" insert into st_indentissuedetail (StockID,ItemID,IndentNo,SendQty,ReceiveQty,DATETIME,UserID,IssueInvoiceNo,barcodeno,DispatchStatus) values (" + stockid + "," + itemid + ",'" + IndentNo + "'," + Util.GetFloat(issueqty) + ",0,now()," + UserInfo.ID + ",'" + batchno + "','" + BarcodeNo + "',3)");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                    }
                    else
                    {
                        sb.Append(" insert into st_indentissuedetail (StockID,ItemID,IndentNo,SendQty,ReceiveQty,DATETIME,UserID,IssueInvoiceNo,barcodeno) values (" + stockid + "," + itemid + ",'" + IndentNo + "'," + Util.GetFloat(issueqty) + ",0,now()," + UserInfo.ID + ",'" + batchno + "','" + BarcodeNo + "')");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                    }
                   
                    string strUpdateStock = "update st_nmstock set PendingQty = PendingQty + " + Util.GetFloat(issueqty) + " where StockID = '" + stockid + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock);



                    string strUpdateIndent = "update st_indent_detail set  PendingQty = PendingQty +" + Util.GetFloat(issueqty) + ",IssueDate=now(),IssueBy='" + UserInfo.LoginName + "',IssueByID='"+UserInfo.ID+"' where IndentNo = '" + IndentNo + "' and itemid= '" + itemid + "';";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateIndent);


                    // Sales Detail InTransitIssue
                    int tolocationid = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select distinct FromLocationID from st_indent_detail where indentno='"+IndentNo+"' "));

                    int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_getsalesno(8)"));
                    StoreSalesDetail objnssaled = new StoreSalesDetail(tnx);
                    objnssaled.FromLocationID = Util.GetInt(dtResult.Rows[0]["LocationID"].ToString());
                    objnssaled.ToLocationID = Util.GetInt(tolocationid);
                    objnssaled.StockID = Util.GetInt(stockid);
                    objnssaled.Quantity = Util.GetFloat(issueqty);
                    objnssaled.TrasactionTypeID = 8;
                    objnssaled.ItemID = Util.GetInt(itemid);
                    objnssaled.TrasactionType = "InTransitIssue";
                    objnssaled.IndentNo = IndentNo;
                    objnssaled.Naration = "";
                    objnssaled.SalesNo = SalesNo;
                    string saledid = objnssaled.Insert();
                    if (saledid == string.Empty)
                    {
                        tnx.Rollback();
                        return "0#Sales Not Saved";
                    }



                }
                else
                {
                    tnx.Rollback();
                    return "0#Stock Unavailable";
                }
            }

             tnx.Commit();
              return "1#" + batchno + "#" + IssueDetailData[0].IndentNo;

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

}

public class IssueDetail
{

    public string IndentNo { get; set; }
    public string itemid { get; set; }
    public string stockid { get; set; }
    public string issueqty { get; set; }
    public string BarcodeNo { get; set; }
   
}
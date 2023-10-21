using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_GRNReprint : System.Web.UI.Page
{
    public string CanUnpost = "0";
    public string CanCancel = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM st_approvalright WHERE apprightfor='GRN' and active=1 AND employeeid='" + UserInfo.ID + "' ");
            if (dt != "0")
            {
                if (dt.Contains("UnPost"))
                {
                    CanUnpost = "1";
                }
                if (dt.Contains("Cancel"))
                {
                    CanCancel = "1";
                }
               

            }

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
            sb.Append("  SELECT locationid locationid,location FROM st_locationmaster WHERE isactive=1   ");
            sb.Append(" AND locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


            sb.Append(" ORDER BY location ");
            ddllocation.DataSource = StockReports.GetDataTable(sb.ToString());
            ddllocation.DataTextField = "location";
            ddllocation.DataValueField = "locationid";
            ddllocation.DataBind();
            ddllocation.Items.Insert(0, new ListItem("All Location", "0"));
        }

    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string location, string fromdate, string todate, string supplier, string ponumber, string invoiceno, string grnno, string grnstatus)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("");

        sb.Append(" SELECT lt.IsDirectGRN, case WHEN st.ispost = 0 THEN 'Pink' WHEN st.ispost = 1 THEN '#90EE90' WHEN st.ispost=3 THEN 'Yellow' END AS rowColor, lt.LedgerTransactionID,lt.LedgerTransactionNo,lt.PurchaseOrderNo PurchaseOrderNo,lt.InvoiceNo,lt.ChalanNo, ");
        sb.Append(" vm.SupplierName,DATE_FORMAT(lt.datetime,'%d-%b-%Y')GRNDate, ");

        sb.Append("  sum(st.rate*st.`InitialCount`) GrossAmount,  ");
        sb.Append("  sum(st.DiscountAmount*st.`InitialCount`) DiscountOnTotal, ");
        sb.Append("  sum(st.TaxAmount*st.`InitialCount`) TaxAmount, ");
        sb.Append("  sum(st.UnitPrice*st.`InitialCount`) NetAmount, ");


        sb.Append(" IF(st.isPost = 1,'Post','') Post,isPost ");
        sb.Append(" FROM   st_ledgertransaction lt ");
        sb.Append(" INNER JOIN st_nmstock st ON lt.LedgerTransactionID = st.LedgerTransactionID ");
        sb.Append(" INNER JOIN st_vendormaster vm ON lt.vendorid=vm.SupplierID ");
        sb.Append(" where lt.TypeOfTnx = 'Purchase'  ");
        if (ponumber == "" )
        {
            sb.Append(" and lt.datetime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
           sb.Append(" and lt.datetime<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        }

        if (location == "0")
        {
            sb.Append(" AND lt.locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        }
        else
        {
            sb.Append(" AND lt.locationid='" + location.Split('#')[0] + "'");
        }
        if (supplier != "0")
        {
            sb.Append(" AND lt.vendorid='" + supplier + "'");
        }
        if (invoiceno != "")
        {
            sb.Append(" AND (lt.invoiceno='" + invoiceno + "' or lt.ChalanNo='" + invoiceno + "')");
        }
        if (grnno != "")
        {
            sb.Append(" AND lt.LedgerTransactionNo='" + grnno + "'");
        }

        if (grnstatus != "All")
        {
            sb.Append(" AND st.isPost='" + grnstatus + "'");
        }

        if (ponumber != "")
        {
            sb.Append(" AND lt.PurchaseOrderNo='" + ponumber + "'");
        }
        sb.Append(" GROUP BY LedgerTransactionID ORDER BY LedgerTransactionID ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindItemDetail(string GRNID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("");
        sb.Append(" SELECT barcodeno, stockid, itemid,itemname,batchnumber,sum(rate*`InitialCount`)rate,sum(discountper)discountper,sum(taxper)taxper,sum(unitprice*`InitialCount`) unitprice,if(isfree=1,'Free','')isfree,sum(unitprice)price,converter , ");
        sb.Append(" IF(`ExpiryDate`='0001-01-01','',DATE_FORMAT(ExpiryDate,'%d-%b-%Y')) ExpiryDate,  ");
        sb.Append(" sum(if(isfree=0,initialcount,0))/Converter PaidQty,sum(if(isfree=1,initialcount,0))/Converter freeQty,sum(initialcount)initialcount,MajorUnit  ");
        sb.Append(" FROM st_nmstock WHERE `LedgerTransactionID`=" + GRNID + "  group by itemid,batchnumber order by stockid ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Post(string GRNID,string type)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
        string rt = "";
       
            if (type == "1")//Post
            {
                string str = "update st_nmstock set ispost = 1,PostDate = now(),PostUserID='" + UserInfo.ID + "' where LedgerTransactionID = '" + GRNID + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                rt="1#";
            }
            if (type == "0")//UnPost
            {
                float releasedCount = Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select SUM(ReleasedCount+pendingqty) from st_nmstock where LedgerTransactionID = '" + GRNID + "'"));
                if (releasedCount == 0)
                {
                    string str = "update st_nmstock set ispost = 0,PostDate = now(),PostUserID='" + UserInfo.ID + "' where LedgerTransactionID = '" + GRNID + "' ";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                    rt = "1#";
                }
                else
                {
                    rt = "2#";
                }
            }
            if (type == "3")//Cancel
            {
                float releasedCount = Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text,"select SUM(ReleasedCount+pendingqty) from st_nmstock where LedgerTransactionID = " + GRNID + ""));
                if (releasedCount == 0)
                {
                     string strrtn = "update st_nmstock set IsPost=3, PostDate = now(),PostUserID='" + UserInfo.ID + "'  where LedgerTransactionID = " + GRNID + "";
                     MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strrtn);
                     string str = "update st_ledgertransaction set IsCancel=1,CancelDate=now(),Cancel_UserID='" + UserInfo.ID + "' where LedgerTransactionID = " + GRNID + " ";
                     MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                     string purchaseorderno = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select PurchaseOrderNo from st_ledgertransaction where LedgerTransactionID = " + GRNID + " and IsDirectGRN=0 "));
                     if (purchaseorderno != "")// Update Purchase Order Table
                     {
                         DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select itemid,(InitialCount/Converter) qty from st_nmstock where LedgerTransactionID = '" + GRNID + "'").Tables[0];

                         foreach (DataRow dw in dt.Rows)
                         {
                             MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "update st_purchaseorder_details set grnqty=grnqty-" + dw["qty"].ToString() + " where itemid=" + dw["itemid"].ToString() + " and PurchaseOrderNo='"+purchaseorderno+"' ");
                         }
                     }
                     
                     rt = "1#";
                 }
                 else
                 {
                     rt = "2#";
                 }
            }
            tnx.Commit();
            return rt;
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
    public static string encryptPurchaseOrderID(string ImageToPrint, string PurchaseOrderNo)
    {
        string PurchaseOrderID = StockReports.ExecuteScalar("select PurchaseOrderID from st_purchaseorder where PurchaseOrderNo='" + PurchaseOrderNo + "'");
        List<string> addEncrypt = new List<string>();
        addEncrypt.Add(Common.Encrypt(ImageToPrint));
        addEncrypt.Add(Common.Encrypt(PurchaseOrderID));
        return JsonConvert.SerializeObject(addEncrypt);
    }
    
}
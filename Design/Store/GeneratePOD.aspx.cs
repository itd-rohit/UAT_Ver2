using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_GeneratePOD : System.Web.UI.Page
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
           ddllocation.Items.Insert(0, new ListItem("Select", "0"));
        }

    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string location, string fromdate, string todate, string supplier, string ponumber, string invoiceno, string grnno, string grnstatus)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("");

        sb.Append(" SELECT lt.LedgerTransactionNo,lt.IsDirectGRN,(select location from st_locationmaster where locationid=lt.locationid)location,lt.locationid,lt.PODnumber,ifnull(pd.IsPOD_transfer,0)IsPOD_transfer,lt.Ispodgenerate,  CASE WHEN IFNULL(IsPOD_transfer,0) = 1 THEN 'aqua' WHEN lt.Ispodgenerate = 1 THEN '#90EE90'  WHEN lt.Ispodgenerate = 0 THEN 'Pink'  END AS rowColor, lt.LedgerTransactionID,lt.LedgerTransactionNo,lt.PurchaseOrderNo PurchaseOrderNo,lt.InvoiceNo,lt.ChalanNo, ");
        sb.Append(" vm.SupplierName,DATE_FORMAT(lt.datetime,'%d-%b-%Y')GRNDate,lt.NetAmount,lt.GrossAmount,lt.DiscountOnTotal,lt.TaxAmount, ");
        sb.Append(" IF(st.isPost = 1,'Post','') Post,isPost ");
        sb.Append(" FROM   st_ledgertransaction lt ");
        sb.Append(" INNER JOIN st_nmstock st ON lt.LedgerTransactionID = st.LedgerTransactionID ");
        sb.Append(" INNER JOIN st_vendormaster vm ON lt.vendorid=vm.SupplierID left join st_pod_details pd on lt.PODnumber=pd.podnumber");
        sb.Append(" where lt.TypeOfTnx = 'Purchase'  ");

        sb.Append(" and lt.datetime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" and lt.datetime<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");

        if (location != "0")
        {
            sb.Append(" AND lt.locationid='" + location.Split('#')[0] + "'");
            //sb.Append(" AND lt.locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        }
        //else
        //{
        //    sb.Append(" AND lt.locationid='" + location.Split('#')[0] + "'");
        //}
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
        sb.Append(" SELECT barcodeno, stockid, itemid,itemname,batchnumber,sum(rate)rate,sum(discountper)discountper,sum(taxper)taxper,sum(unitprice)unitprice,if(isfree=1,'Free','')isfree,  ");
        sb.Append(" IF(`ExpiryDate`='0001-01-01','',DATE_FORMAT(ExpiryDate,'%d-%b-%Y')) ExpiryDate,  ");
        sb.Append(" sum(if(isfree=0,initialcount,0))/Converter PaidQty,sum(if(isfree=1,initialcount,0))/Converter freeQty,sum(initialcount-releasedcount-pendingqty)initialcount,MajorUnit  ");
        sb.Append(" FROM st_nmstock WHERE `LedgerTransactionID`=" + GRNID + "  group by itemid,batchnumber order by stockid ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Post(List<poddetails> objpoddetails)
    {
       
        string rt = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {


            string indentno = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_get_indent_no('POD')").ToString();
            if (indentno == "")
            {
                tnx.Rollback();
                return "0#Error";
            }
            else
            {

                for (int i = 0; i < objpoddetails.Count; i++)
                {
                    string str = "update st_ledgertransaction set PODnumber ='" + indentno + "',Ispodgenerate =1,PODcreated_by='" + UserInfo.ID + "',PODgendate=now() where LedgerTransactionID=" + objpoddetails[i].LedgerTransactionID + " ";
                   // StockReports.ExecuteDML(str);
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);


                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO st_pod_details (LedgerTransactionID,LedgerTransactionNo,locationid,GrossAmount,DiscountOnTotal,TaxAmount,NetAmount,InvoiceNo,PODnumber,PODcreated_by,PODgendate) values(  @LedgerTransactionID,@LedgerTransactionNo,@locationid,@GrossAmount,@DiscountOnTotal,@TaxAmount,@NetAmount,@InvoiceNo,@PODnumber,@PODcreated_by,now())",
                           new MySqlParameter("@LedgerTransactionID", objpoddetails[i].LedgerTransactionID),
                           new MySqlParameter("@LedgerTransactionNo", objpoddetails[i].grn_no),
                           new MySqlParameter("@locationid", objpoddetails[i].location),
                           new MySqlParameter("@GrossAmount", objpoddetails[i].grossamt),
                           new MySqlParameter("@DiscountOnTotal", objpoddetails[i].discamt),
                           new MySqlParameter("@TaxAmount", objpoddetails[i].taxamt),
                           new MySqlParameter("@NetAmount", objpoddetails[i].netamt),
                           new MySqlParameter("@InvoiceNo", objpoddetails[i].invoicenumber),
                           new MySqlParameter("@PODnumber", indentno),
                             new MySqlParameter("@PODcreated_by", UserInfo.ID)
                               
                             

                           );
                }

                tnx.Commit();
                    rt = "1";
            }

            return rt;
        }
        catch(Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            //return Util.GetString(ex.Message);
            return "0";
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
    public static string transfer(List<poddetails> objpoddetails,string curriername,string consinment,string courierdate)
    {
        string rt = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

                for (int i = 0; i < objpoddetails.Count; i++)
                {
                    string str = "update st_pod_details set couriername='" + curriername + "',consinmentno='" + consinment + "',senddate='" + Util.GetDateTime(courierdate).ToString("yyyy-MM-dd") + " 00:00:00" + "',IsPOD_transfer =1,POD_Transferby='" + UserInfo.ID + "',POD_transferdate=now() where PODnumber='" + objpoddetails[i].podnumber + "' ";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);


                    rt = "1";
                }




                tnx.Commit();
            return rt;
        }
        catch (Exception ex)
        {

            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
           
            return "0";
        }
        finally
        {

            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

   public class poddetails
    {
        public string  LedgerTransactionID { get; set; }
       public string grn_no { get; set; }
       public string podnumber { get; set; }
       public string invoicenumber { get; set; }
       public string grossamt { get; set; }
       public string discamt { get; set; }
       public string taxamt { get; set; }
       public string netamt { get; set; }
       public string location { get; set; }
    
    }

}
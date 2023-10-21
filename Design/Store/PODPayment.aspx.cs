using MySql.Data.MySqlClient;
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

public partial class Design_Store_PODPayment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            string uid = StockReports.ExecuteScalar("Select employeeid from st_approvalright where employeeid=" + UserInfo.ID + " and TypeName='POD Payment'");
            if (UserInfo.ID.ToString() != uid)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';showerrormsg('Dear User You Did not Have Right To View This Page');", true);
                return;
            }
            bindalldata();
            bindvendor();

        }
    }




    void bindalldata()
    {
        if (UserInfo.AccessStoreLocation != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT locationid,location FROM st_locationmaster WHERE isactive=1   ");
            sb.Append(" AND locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");

            sb.Append(" ORDER BY location ");
            ddllocation.DataSource = StockReports.GetDataTable(sb.ToString());
            ddllocation.DataTextField = "location";
            ddllocation.DataValueField = "locationid";
            ddllocation.DataBind();
            ddllocation.Items.Insert(0, new ListItem("All", "0"));
        }

    }


    void bindvendor()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT supplierid,suppliername FROM st_vendormaster WHERE isactive=1   ");

        sb.Append(" ORDER BY suppliername ");
        ddlvendor.DataSource = StockReports.GetDataTable(sb.ToString());
        ddlvendor.DataTextField = "suppliername";
        ddlvendor.DataValueField = "supplierid";
        ddlvendor.DataBind();
        ddlvendor.Items.Insert(0, new ListItem("Select", "0"));


    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string fromdate, string todate, string supplier)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("");

        sb.Append(" SELECT pd. PODnumber,pd.is_payment ,Case  when ifnull(pd.is_payment,0)=1 then '#90EE90' else 'pink' end as rowColor,lm.location,pd.IsPOD_Accept,pd.is_forwarded,SUM(pd.GrossAmount )GrossAmount,SUM(pd. DiscountOnTotal )DiscountOnTotal,SUM(pd. TaxAmount )TaxAmount,SUM(pd. NetAmount )NetAmount,pd.locationid ,");
        sb.Append("   vendetail.suppliername ,vendetail.vendorid ");

        sb.Append(" FROM st_pod_details pd INNER JOIN  st_locationmaster  lm ON pd. Locationid =lm. LocationID  ");
        sb.Append("INNER JOIN  (SELECT vm.suppliername ,lt.vendorid ,lt.podnumber  FROM `st_ledgertransaction` lt INNER JOIN st_vendormaster vm  ON lt.vendorid = vm.supplierid ");

        sb.Append("GROUP BY lt.podnumber) AS vendetail ON  vendetail.podnumber=pd.podnumber ");
        sb.Append(" INNER JOIN st_podtransfer spt ON pd.podnumber=spt.podnumber ");
        sb.Append(" where pd.podgendate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" and pd.podgendate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append("  and spt.STATUS='Accept' AND spt.iscurrent=1 ");
        if (supplier != "0")
            sb.Append(" AND vendetail.vendorid=" + supplier + "");
        


        sb.Append(" GROUP BY pd. PODnumber ");




        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Allpod(string status)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("");

        sb.Append(" SELECT pd. PODnumber,pd.is_payment ,Case  when ifnull(pd.is_payment,0)=1 then '#90EE90' else 'pink' end as rowColor,lm.location,pd.IsPOD_Accept,pd.is_forwarded,SUM(pd.GrossAmount )GrossAmount,SUM(pd. DiscountOnTotal )DiscountOnTotal,SUM(pd. TaxAmount )TaxAmount,SUM(pd. NetAmount )NetAmount,pd.locationid ,");
        sb.Append("   vendetail.suppliername ,vendetail.vendorid ");

        sb.Append(" FROM st_pod_details pd INNER JOIN  st_locationmaster  lm ON pd. Locationid =lm. LocationID  ");
        sb.Append("INNER JOIN  (SELECT vm.suppliername ,lt.vendorid ,lt.podnumber  FROM `st_ledgertransaction` lt INNER JOIN st_vendormaster vm  ON lt.vendorid = vm.supplierid ");

        sb.Append("GROUP BY lt.podnumber) AS vendetail ON  vendetail.podnumber=pd.podnumber");
        sb.Append("  and pd.is_forwarded=1 and pd.forwarded_to=" + UserInfo.ID + "");
        sb.Append("  and pd.is_payment=" + status + " ");
        sb.Append(" AND pd.locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


        sb.Append(" GROUP BY pd. PODnumber ");




        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);




    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindItemDetail(string pod)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("");

        sb.Append(" SELECT lt.LedgerTransactionID,lt.LedgerTransactionNo,lt.IsDirectGRN,lt.PODnumber,lt.Ispodgenerate,  lt.LedgerTransactionID,lt.LedgerTransactionNo,lt.PurchaseOrderNo PurchaseOrderNo,lt.InvoiceNo,lt.ChalanNo, ");
        sb.Append(" vm.SupplierName,DATE_FORMAT(lt.datetime,'%d-%b-%Y')GRNDate,lt.NetAmount,lt.GrossAmount,lt.DiscountOnTotal,lt.TaxAmount ");
        sb.Append(" FROM   st_ledgertransaction lt ");

        sb.Append(" INNER JOIN st_vendormaster vm ON lt.vendorid=vm.SupplierID ");
        sb.Append(" where lt.PODnumber='" + pod + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindvendorbypod(string pod)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("");
        sb.Append("   SELECT DISTINCT vendorid,(SELECT suppliername FROM st_vendormaster WHERE supplierid=lt.`VendorID` ) suppliername   ");
        sb.Append("  ,( SELECT GROUP_CONCAT(LedgerTransactionNO) FROM st_ledgertransaction WHERE podnumber=lt.`PODnumber` AND vendorid=lt.`VendorID`) grn,(SELECT SUM(NetAmount) FROM st_ledgertransaction WHERE podnumber=lt.`PODnumber` AND vendorid=lt.`VendorID` ) netbalance   ");
        sb.Append(" FROM st_ledgertransaction lt WHERE podnumber='" + pod + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }







    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savepaymentDetail(string pod, string vendorid, string grn, string netamt, string paidamt, string mode, string refrence, string paydate, string other)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {

            StringBuilder Command = new StringBuilder();
            if (paydate == "")
            {
                paydate = DateTime.Now.ToString();
            }
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update st_pod_details set is_payment=1,payment_by=" + UserInfo.ID + ",paymentdate=now() where PODnumber='" + pod + "' ");

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "insert into st_podpayment(podnumber,grnnumber,netamount,paidamount,vendorid,paymentmode,refrencenumber,paymentdate,otherdetails,Payment_by,paydate) values(@podnumber,@grnnumber,@netamount,@paidamount,@vendorid,@paymentmode,@refrencenumber,@paymentdate,@otherdetails,@Payment_by,now())",
                           new MySqlParameter("@podnumber", pod),
                           new MySqlParameter("@grnnumber", grn),
                           new MySqlParameter("@netamount", netamt),
                           new MySqlParameter("@paidamount", paidamt),
                            new MySqlParameter("@vendorid", vendorid),
                           new MySqlParameter("@paymentmode", mode),
                           new MySqlParameter("@refrencenumber", refrence),
                           new MySqlParameter("@paymentdate", Convert.ToDateTime(paydate)),
                           new MySqlParameter("@otherdetails", other),
                           new MySqlParameter("@Payment_by", UserInfo.ID));
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();

        }

    }





    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindpaymentdetails(string pod)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("");

        sb.Append(" SELECT podnumber,paidamount,refrencenumber,(SELECT suppliername FROM st_vendormaster WHERE supplierid=vendorid ) suppliername,paymentmode,DATE_FORMAT(paymentdate,'%d-%b-%y') paymentdate,(SELECT NAME FROM employee_master WHERE employee_id=payment_by) paymentrecieved ");
        sb.Append(" FROM st_podpayment WHERE  podnumber='" + pod + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(string location, string fromdate, string todate, string supplier)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("");

        sb.Append(" SELECT pd. PODnumber,pd.is_payment,Date_Format(pd.paymentdate,'%d-%b-%y')paymentdate,(select name from employee_master where employee_id=pd.payment_by) Payment_Recieved ,lm.location,SUM(pd.GrossAmount )GrossAmount,SUM(pd. DiscountOnTotal )DiscountOnTotal,SUM(pd. TaxAmount )TaxAmount,SUM(pd. NetAmount )NetAmount ,");
        sb.Append("   vendetail.suppliername  ");

        sb.Append(" FROM st_pod_details pd INNER JOIN  st_locationmaster  lm ON pd. Locationid =lm. LocationID  ");
        sb.Append("INNER JOIN  (SELECT vm.suppliername ,lt.vendorid ,lt.podnumber  FROM `st_ledgertransaction` lt INNER JOIN st_vendormaster vm  ON lt.vendorid = vm.supplierid ");

        sb.Append("GROUP BY lt.podnumber) AS vendetail ON  vendetail.podnumber=pd.podnumber");
        sb.Append(" where pd.podgendate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" and pd.podgendate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append("  and pd.is_forwarded=1 and pd.forwarded_to=" + UserInfo.ID + "");
        if (supplier != "0")
            sb.Append(" AND vendetail.vendorid=" + supplier + "");
        if (location != "")
            sb.Append(" AND pd. Locationid=" + location + "");
        else
            sb.Append(" AND pd.locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


        sb.Append(" GROUP BY pd. PODnumber ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataColumn column = new DataColumn();
        column.ColumnName = "S.No";
        column.DataType = System.Type.GetType("System.Int32");
        column.AutoIncrement = true;
        column.AutoIncrementSeed = 0;
        column.AutoIncrementStep = 1;

        dt.Columns.Add(column);
        int index = 0;
        foreach (DataRow row in dt.Rows)
        {
            row.SetField(column, ++index);
        }
        dt.Columns["S.No"].SetOrdinal(0);
        if (dt.Rows.Count > 0)
        {

            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "IssueReportDetail";
            return "true";
        }
        else
        {
            return "false";
        }

    }
}
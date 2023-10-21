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

public partial class Design_Store_VendorReturn : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (UserInfo.AccessStoreLocation != "")
            {


                string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM st_approvalright WHERE apprightfor='SR' and typeid=20 AND active=1 AND employeeid='" + UserInfo.ID + "' ");
                if (dt == "0")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';showerrormsg('Dear User You Did not Have Right To Supplier Return');", true);
                    return;
                }



                txtdatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                txtdateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");

                StringBuilder sb = new StringBuilder();
                sb.Append("  SELECT locationid locationid,location FROM st_locationmaster WHERE isactive=1   ");
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

                ddlsupplier.DataSource = StockReports.GetDataTable("SELECT supplierid,suppliername FROM `st_vendormaster` WHERE isactive=1 ORDER BY suppliername ASC ");
                ddlsupplier.DataTextField = "suppliername";
                ddlsupplier.DataValueField = "supplierid";
                ddlsupplier.DataBind();
                ddlsupplier.Items.Insert(0, new ListItem("Select Supplier", "0"));

           }
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string binditem(string locationid, string supplierid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" ");

        sb.Append("   SELECT  st.`ItemID`,st.`ItemName`");
        sb.Append(" FROM st_nmstock st ");
        sb.Append(" INNER JOIN `st_ledgertransaction` lt ON st.`LedgerTransactionID`=lt.`LedgerTransactionID` AND typeoftnx='Purchase' ");
        sb.Append(" AND lt.`VendorID`=" + supplierid + " AND lt.`LocationID`=" + locationid + " ");

        sb.Append(" INNER JOIN st_itemmaster im ON im.`ItemID`=st.`ItemID`  ");
        sb.Append(" INNER JOIN `st_categorytypemaster` ca ON ca.`CategoryTypeID`=im.`CategoryTypeID`  ");
        sb.Append(" WHERE (st.`InitialCount`-st.`ReleasedCount`-st.`PendingQty`)>0");
        sb.Append(" GROUP  BY st.`ItemID`");
        sb.Append(" ORDER BY itemname");


        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string locationid, string supplierid, string fromdate, string todate, string itemid, string barcodeno)
    {
        StringBuilder sb = new StringBuilder();


        sb.Append(" SELECT DATEDIFF(expirydate,CURRENT_DATE) exdate, lt.`LocationID`,lt.`VendorID`,ca.`CategoryTypeName`, st.`StockID`,st.`ItemID`,st.`ItemName`,st.`MajorUnit`,st.`Converter`,st.`BarcodeNo`,st.`BatchNumber`, ");
        sb.Append(" DATE_FORMAT(st.`ExpiryDate`,'%d-%b-%Y') ExpiryDate, DATE_FORMAT(lt.`datetime`,'%d-%b-%Y')  PurchaseDate, ");
        sb.Append(" (st.`InitialCount`/st.`Converter`)PurchaseQty,(st.`InitialCount`-st.`ReleasedCount`-st.`PendingQty`) /st.`Converter` Inhandqtypurchased,");
        sb.Append(" (st.`InitialCount`-st.`ReleasedCount`-st.`PendingQty`) Inhandqty,st.`MinorUnit`,st.`Rate`,st.`DiscountAmount`,st.`TaxAmount`,st.`UnitPrice` ");
        sb.Append(" FROM st_nmstock st ");
        sb.Append(" INNER JOIN `st_ledgertransaction` lt ON st.`LedgerTransactionID`=lt.`LedgerTransactionID` AND typeoftnx='Purchase' ");
        sb.Append(" AND lt.`VendorID`=" + supplierid + " AND lt.`LocationID`=" + locationid + " ");
        //sb.Append(" and lt.datetime>='"+Util.GetDateTime(fromdate).ToString("yyyy-MM-dd")+" 00:00:00' ");
        //sb.Append(" and lt.datetime<='"+ Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");

       
        sb.Append(" INNER JOIN st_itemmaster im ON im.`ItemID`=st.`ItemID`  ");
        sb.Append(" INNER JOIN `st_categorytypemaster` ca ON ca.`CategoryTypeID`=im.`CategoryTypeID`  ");
        sb.Append(" where (st.`InitialCount`-st.`ReleasedCount`-st.`PendingQty`)>0");
        if (barcodeno != "")
        {
            sb.Append(" and st.barcodeno='" + barcodeno + "'");
        }
        else
        {
            sb.Append(" and st.itemid in (" + itemid + ")");
        }
        sb.Append(" order by itemname asc");



        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savedata(List<string[]> mydataadj)
    {

        string salesnotoreturn = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            salesnotoreturn = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_get_indent_no('VR')").ToString();
            if (salesnotoreturn == "")
            {
                tnx.Rollback();
                return "0#Error";
            }
            foreach (string[] ss in mydataadj)
            {
                int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_getsalesno(4)"));
               
                StoreSalesDetail objnssaled = new StoreSalesDetail(tnx);
                objnssaled.FromLocationID = Util.GetInt(ss[0]);
                objnssaled.ToLocationID = Util.GetInt(ss[0]);
                objnssaled.StockID = Util.GetInt(ss[2]);
                objnssaled.Quantity = Util.GetFloat(ss[3]);
                objnssaled.TrasactionTypeID = 4;
                objnssaled.TrasactionType = "VendorReturn";
                objnssaled.ItemID = Util.GetInt(ss[4]);

                objnssaled.IndentNo = salesnotoreturn;
                objnssaled.Naration = Util.GetString(ss[5])+"";
                objnssaled.SalesNo = SalesNo;
                string saledid = objnssaled.Insert();
                if (saledid == string.Empty)
                {
                    tnx.Rollback();
                    return "0#Sales Not Saved";
                }

                //Check If Stock is Available 
                string sql = "select if(InitialCount < (ReleasedCount+PendingQty+" + Util.GetFloat(ss[3]) + "),0,1)CHK from st_nmstock where stockID='" + ss[2] + "'";
                if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql)) <= 0)
                {
                    tnx.Rollback();

                    return "0#Stock Unavailable";
                }

                string strUpdateStock = "update st_nmstock set ReleasedCount = ReleasedCount + " + Util.GetFloat(ss[3]) + " where StockID = '" + ss[2] + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock);
                //Insert into New table
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into st_vendor_return (VendorReturnNo,VendorID,LocationID,ItemID,StockID,ReturnQty,UserID,UserName,EntryDateTime,SalesNo,remark) values (@VendorReturnNo,@VendorID,@LocationID,@ItemID,@StockID,@ReturnQty,@UserID,@UserName,@EntryDateTime,@SalesNo,@remarks)",
                    new MySqlParameter("@VendorReturnNo", salesnotoreturn),
                    new MySqlParameter("@VendorID", Util.GetInt(ss[1])),
                    new MySqlParameter("@LocationID", Util.GetInt(ss[0])),
                    new MySqlParameter("@ItemID", Util.GetInt(ss[4])),
                    new MySqlParameter("@StockID", Util.GetInt(ss[2])),
                    new MySqlParameter("@ReturnQty", Util.GetFloat(ss[3])),
                    new MySqlParameter("@UserID", UserInfo.ID),
                    new MySqlParameter("@UserName", UserInfo.LoginName),
                    new MySqlParameter("@EntryDateTime", DateTime.Now),
                    new MySqlParameter("@SalesNo", saledid),
                    new MySqlParameter("@remarks", Util.GetString(ss[5])));
            }

            tnx.Commit();
            return "1#" + salesnotoreturn;
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


    
}
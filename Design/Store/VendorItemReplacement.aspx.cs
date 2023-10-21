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

public partial class Design_Store_VendorItemReplacement : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (UserInfo.AccessStoreLocation != "")
            {


                string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM st_approvalright WHERE apprightfor='SR' and typeid=21 AND active=1 AND employeeid='" + UserInfo.ID + "' ");
                if (dt == "0")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';showerrormsg('Dear User You Did not Have Right To Item Replacement');", true);
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
    public static string SearchData(string locationid, string supplierid, string fromdate, string todate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lt.id, lt.StockID, lt.`LocationID`,lt.`VendorID`,ca.`CategoryTypeName`, st.`StockID`,st.`ItemID`,st.`ItemName`,st.`MajorUnit`,st.`Converter`, ");
        sb.Append(" DATE_FORMAT(lt.`EntryDateTime`,'%d-%b-%Y %h:%i %p')  ReturnDate,lt.ReturnQty,lt.ReplaceQty,(lt.ReturnQty-lt.ReplaceQty)  RemainQty, ");
        sb.Append(" st.`MinorUnit`,st.`Rate`,st.`DiscountAmount`,st.`TaxAmount`,st.`UnitPrice`,im.BarcodeOption,im.BarcodeGenrationOption ");
        sb.Append(" FROM st_vendor_return lt ");
        sb.Append(" INNER JOIN `st_nmstock` st ON st.stockid=lt.stockid and (lt.ReturnQty-lt.ReplaceQty)>0 ");
        sb.Append(" AND lt.`VendorID`=" + supplierid + " AND lt.`LocationID`=" + locationid + " ");



        sb.Append(" INNER JOIN st_itemmaster im ON im.`ItemID`=st.`ItemID`  ");
        sb.Append(" INNER JOIN `st_categorytypemaster` ca ON ca.`CategoryTypeID`=im.`CategoryTypeID`  ");
        sb.Append(" where ");
        sb.Append("  lt.EntryDateTime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" and lt.EntryDateTime<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");

        sb.Append(" order by itemname asc");



        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savedata(List<VendorReplacement> mydata)
    {
        string salesnotoreturn = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string LedgerTransactionID = "";
            string LedgerTransactionNo = "";
            StoreLedgerTransaction lt = new StoreLedgerTransaction(tnx);
            lt.VendorID = 0;
            lt.TypeOfTnx = "VendorReplacement";
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
            lt.LocationID = mydata[0].LocationID;
            string ss = lt.Insert();
            LedgerTransactionID = ss.Split('#')[0];
            LedgerTransactionNo = ss.Split('#')[1];

            salesnotoreturn = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_get_indent_no('VRM')").ToString();
            if (salesnotoreturn == "")
            {
                tnx.Rollback();
                return "0#Error";
            }


            foreach (VendorReplacement stockdata in mydata)
            {

                StringBuilder sb = new StringBuilder();
                sb.Append("   SELECT StockID,ItemID,ItemName,BatchNumber,Rate,DiscountPer,DiscountAmount,TaxPer,TaxAmount,UnitPrice,MRP, ");
                sb.Append("   ManufactureID,MacID,MajorUnitID,MajorUnit,MinorUnitID,MinorUnit,Converter,Naration,");
                sb.Append("   UnitPrice,MRP,ExpiryDate ,LocationID,Panel_Id,if(IsFree=1,1,0)IsFree,Remarks,if(Reusable=1,1,0)Reusable, BarcodeNo,");
                sb.Append("   IsExpirable,IssueMultiplier,PackSize,BarcodeOption,BarcodeGenrationOption,IssueInFIFO,MajorUnitInDecimal,MinorUnitInDecimal ");
                sb.Append("   from st_nmstock where StockID='" + stockdata.StockID + "' ");


                DataTable dtResult = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString()).Tables[0];
                if (dtResult != null && dtResult.Rows.Count > 0)
                {

                    float pendingqty = Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select  (sid.ReturnQty-sid.ReplaceQty) pendingqty from st_vendor_return sid where id='" + stockdata.ReturnID + "'"));


                    if (Util.GetFloat(stockdata.Qty) > pendingqty)
                    {
                        tnx.Rollback();

                        return "0#Replace Qty Can't Greater Then Return Qty";
                    }





                    StoreNMStock ststock = new StoreNMStock(tnx);

                    ststock.ItemID = Util.GetInt(dtResult.Rows[0]["ItemID"].ToString());
                    ststock.ItemName = Util.GetString(dtResult.Rows[0]["ItemName"].ToString());
                    ststock.LedgerTransactionID = 0;
                    ststock.LedgerTransactionNo = "";
                    ststock.BatchNumber = Util.GetString(stockdata.BatchNumber);

                    ststock.Rate = Util.GetFloat(dtResult.Rows[0]["Rate"].ToString());
                    ststock.DiscountPer = Util.GetFloat(dtResult.Rows[0]["DiscountPer"].ToString());
                    ststock.DiscountAmount = Util.GetFloat(dtResult.Rows[0]["DiscountAmount"].ToString());
                    ststock.TaxPer = Util.GetFloat(dtResult.Rows[0]["TaxPer"].ToString());
                    ststock.TaxAmount = Util.GetFloat(dtResult.Rows[0]["TaxAmount"].ToString());
                    ststock.UnitPrice = Util.GetFloat(dtResult.Rows[0]["UnitPrice"].ToString());
                    ststock.MRP = Util.GetFloat(dtResult.Rows[0]["MRP"].ToString());
                    ststock.InitialCount = Util.GetFloat(stockdata.Qty);
                    ststock.ReleasedCount = 0;
                    ststock.PendingQty = 0;
                    ststock.RejectQty = 0;


                    ststock.ExpiryDate = Util.GetDateTime(stockdata.ExpiryDate);


                    ststock.Naration = Util.GetString(dtResult.Rows[0]["Naration"].ToString());
                    ststock.IsFree = Util.GetInt(dtResult.Rows[0]["IsFree"].ToString());

                    ststock.LocationID = Util.GetInt(dtResult.Rows[0]["LocationID"].ToString());
                    ststock.Panel_Id = Util.GetInt(dtResult.Rows[0]["Panel_Id"].ToString());

                    ststock.IndentNo = "";
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

                    ststock.Remarks = "Vendor Replacement";

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


                        return "0#Stock Not Saved";
                    }


                    
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_nmstock set Barcodeno=stockid where stockid=" + stockidsaved + "");
                    


                    string stTax = " SELECT stockid,itemid,taxname,percentage,taxamt FROM st_taxchargedlist WHERE stockid='" + stockdata.StockID + "' and itemid='" + stockdata.ItemID + "'  ";
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
                        objTCharged.StockID = Util.GetInt(stockidsaved);

                        string TaxChrgID = objTCharged.Insert();

                        if (TaxChrgID == string.Empty)
                        {
                            tnx.Rollback();
                            return "0#Tax Not Saved";
                        }

                    }



                    int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_getsalesno(12)"));
                    StoreSalesDetail objnssaled = new StoreSalesDetail(tnx);
                    objnssaled.FromLocationID = Util.GetInt(dtResult.Rows[0]["LocationID"].ToString());
                    objnssaled.ToLocationID = Util.GetInt(dtResult.Rows[0]["LocationID"].ToString());
                    objnssaled.StockID = Util.GetInt(stockidsaved);
                    objnssaled.Quantity = Util.GetFloat(stockdata.Qty);
                    objnssaled.TrasactionTypeID = 12;
                    objnssaled.TrasactionType = "VendorReplacement";
                    objnssaled.ItemID = Util.GetInt(stockdata.ItemID);

                    objnssaled.IndentNo = "";
                    objnssaled.Naration = "VendorReplacement";
                    objnssaled.SalesNo = SalesNo;
                    string saledid = objnssaled.Insert();
                    if (saledid == string.Empty)
                    {
                        tnx.Rollback();
                        return "0#Sales Not Saved";
                    }






                    sb = new StringBuilder();
                    sb.Append(" update   st_vendor_return set  ReplaceQty =ReplaceQty+" + Util.GetFloat(stockdata.Qty) + " where id=" + stockdata.ReturnID + " ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());



                    sb = new StringBuilder();
                    sb.Append(" insert into st_vendor_replacement (ReplacementID,StockID,ItemID,VendorID,LocationID,ReplaceQty,ReplaceDate,ReplaceByID,ReplaceByName,BatchNumber,  ");
                    sb.Append(" ExpiryDate,ReturnStoockID,ReturnID) values");
                    sb.Append(" ('"+salesnotoreturn+"', " + stockidsaved + ","+stockdata.ItemID+","+stockdata.VendorID+","+stockdata.LocationID+","+stockdata.Qty+",now(),"+UserInfo.ID+",");
                    sb.Append(" '" + UserInfo.LoginName + "','" + stockdata.BatchNumber + "','" + Util.GetDateTime(stockdata.ExpiryDate).ToString("yyyy-MM-dd") + "',"+stockdata.StockID+","+stockdata.ReturnID+")");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());


                }

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
public class VendorReplacement
{
    public string VendorID { get; set; }
    public int LocationID { get; set; }
    public string ReturnID { get; set; }
    public string StockID { get; set; }
    public string ItemID { get; set; }
    public string Qty { get; set; }
    public string BatchNumber { get; set; }
    public string ExpiryDate { get; set; }
}
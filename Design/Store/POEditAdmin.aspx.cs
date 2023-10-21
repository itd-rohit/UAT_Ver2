using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class Design_Store_POEditAdmin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {


            string dt = StockReports.ExecuteScalar("SELECT count(1) FROM st_approvalright WHERE apprightfor='PO' AND active=1 AND employeeid='" + UserInfo.ID + "' and  typeid=18");
            if (dt == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';showerrormsg('Dear User You Did not Have Right To Edit PO');", true);
                return;
            }


            if (Util.GetString(Request.QueryString["ponumber"]) != "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch1", "document.getElementById('masterheaderid').style.display='none';", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch12", "document.getElementById('mastertopcorner').style.display='none';", true);

                txtponumber.ReadOnly = true;
                txtponumber.Text = Util.GetString(Request.QueryString["ponumber"]);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "searchpo();", true);
            }

            ddlsupplier.DataSource = StockReports.GetDataTable("SELECT supplierid,suppliername FROM `st_vendormaster` WHERE isactive=1 ORDER BY suppliername ASC  ");
            ddlsupplier.DataValueField = "supplierid";
            ddlsupplier.DataTextField = "suppliername";
            ddlsupplier.DataBind();
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string ponumber)
    {

        if (Util.GetInt(StockReports.ExecuteScalar("select count(1)  from  st_ledgertransaction where PurchaseOrderNo='" + ponumber + "'")) > 0)
        {
            return "0";
        }

        StringBuilder sb = new StringBuilder();




        sb.Append("  SELECT st.PurchaseOrderID, st.VendorID,(select CONCAT(location,'^#^',Stateid) from st_locationmaster where LocationID=st.LocationID)  location, ");
        sb.Append("  spd.PurchaseOrderNo,st.GrossTotal,st.DiscountOnTotal,st.TaxAmount TaxAmt,st.NetTotal, ");
        sb.Append("   spd.ItemID,imm.typename ItemName,ApprovedQty,Rate,spd.TaxAmount,DiscountAmount,DiscountPercentage,NetAmount,UnitPrice,");
        sb.Append("    IFNULL((SELECT Percentage FROM st_purchaseorder_tax WHERE PurchaseOrderNo='" + ponumber + "' AND `itemid`=spd.itemid  AND taxname='IGST') ,'0') IGSTPercentage,");
        sb.Append("     IFNULL((SELECT Percentage FROM st_purchaseorder_tax WHERE PurchaseOrderNo='" + ponumber + "' AND `itemid`=spd.itemid   AND taxname='CGST') ,'0') CGSTPercentage, ");
        sb.Append("     IFNULL((SELECT Percentage FROM st_purchaseorder_tax WHERE PurchaseOrderNo='" + ponumber + "' AND `itemid`=spd.itemid    AND taxname='SGST') ,'0') SGSTPercentage ");
        sb.Append("      FROM `st_purchaseorder_details` spd  ");
        sb.Append("     INNER JOIN st_purchaseorder st ON st.PurchaseOrderID=spd.PurchaseOrderID  ");
        sb.Append("     inner join st_itemmaster  imm on imm.itemid=spd.itemid ");
        sb.Append("     WHERE st.PurchaseOrderNo='" + ponumber + "' and st.Status=2  ");



        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string updatepo(List<string> pomaster, List<podetail> podetail, List<PurchaseOrderTax> potax)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dtDetails = StockReports.GetDataTable(" SELECT State,StateID,GST_No,Address FROM `st_supplier_gstn` WHERE `SupplierID`='" + pomaster[2] + "' AND stateid='" + pomaster[8] + "'");

            if (dtDetails.Rows.Count > 0)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE st_purchaseorder SET VendorStateId='" + dtDetails.Rows[0]["StateID"].ToString() + "',VendorGSTIN='" + dtDetails.Rows[0]["GST_No"].ToString() + "',VendorAddress='" + dtDetails.Rows[0]["Address"].ToString() + "',VendorID='" + pomaster[2] + "',VendorName='" + pomaster[3] + "',GrossTotal='" + pomaster[4] + "',DiscountOnTotal='" + pomaster[5] + "',TaxAmount='" + pomaster[6] + "',NetTotal='" + pomaster[7] + "',IsEdited=1,LastEditDate=now(),LastEditByID='" + UserInfo.ID + "',LastEditByName='" + UserInfo.LoginName + "',STATUS=0,statusname='Maker',ActionType='Maker' WHERE PurchaseOrderID='" + pomaster[0] + "' ");
            }
            else
            {
                return "0#GST No is not found for this supplier.";
            }

           

            foreach (podetail pod in podetail)
            {
                MySqlHelper.ExecuteNonQuery(tnx,CommandType.Text,@"INSERT INTO st_purchaseorder_details_edited
            (PurchaseOrderID,PurchaseOrderNo,ItemID, ItemName,ManufactureID,  ManufactureName,   CatalogNo,MachineID, MachineName,
            MajorUnitId,MajorUnitName,PackSize,OrderedQty,CheckedQty,ApprovedQty,VendorIssueQty,GRNQty,RejectQtyByUser,
            RejectQtyByVendor,RejectByUserID,RejectByVendorID,Rate,TaxAmount,DiscountAmount,DiscountPercentage,NetAmount,
            TotalAmount,IsFree,UnitPrice,RejectQty,RejectByUserName,RejectReason,IsActive,UpdatedByID,UpdatedByName,vendorcommentitem,Updatedate)
            
            SELECT PurchaseOrderID,PurchaseOrderNo,ItemID, ItemName,ManufactureID,  ManufactureName,   CatalogNo,MachineID, MachineName,
            MajorUnitId,MajorUnitName,PackSize,OrderedQty,CheckedQty,ApprovedQty,VendorIssueQty,GRNQty,RejectQtyByUser,
            RejectQtyByVendor,RejectByUserID,RejectByVendorID,Rate,TaxAmount,DiscountAmount,DiscountPercentage,NetAmount,
            TotalAmount,IsFree,UnitPrice,RejectQty,RejectByUserName,RejectReason,IsActive,"+UserInfo.ID+",'"+UserInfo.LoginName+"',vendorcommentitem,NOW() FROM st_purchaseorder_details WHERE PurchaseOrderID='" + pod.PurchaseOrderID + "' AND ItemID='" + pod.ItemID + "'");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE st_purchaseorder_details SET Rate='" + pod.Rate + "',TaxAmount='" + pod.TaxAmount + "',DiscountAmount='" + pod.DiscountAmount + "',DiscountPercentage='" + pod.DiscountPercentage + "',UnitPrice='" + pod.UnitPrice + "',NetAmount='" + pod.NetAmount + "',CheckedQty=0,ApprovedQty=0 WHERE PurchaseOrderID='" + pod.PurchaseOrderID + "' AND ItemID='" + pod.ItemID + "'");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from st_purchaseorder_tax where PurchaseOrderID='" + pod.PurchaseOrderID + "' AND ItemID='" + pod.ItemID + "'");

                var taxlist = potax.Where(f => (f.ItemID == Util.GetInt(pod.ItemID)));

                foreach (PurchaseOrderTax tax in taxlist)
                {
                    PurchaseOrderTax mytax = new PurchaseOrderTax(tnx);
                    mytax.PurchaseOrderID = Util.GetInt(tax.PurchaseOrderID);
                    mytax.PurchaseOrderNo = tax.PurchaseOrderNo;
                    mytax.ItemID = tax.ItemID;
                   
                    mytax.Percentage = tax.Percentage;
                    mytax.TaxName = tax.TaxName;
                    mytax.TaxAmt = tax.TaxAmt;
                    int savedid = mytax.Insert();
                    if (savedid == 0)
                    {
                        tnx.Rollback();

                        return "0#Error";
                    }
                }
            }

            tnx.Commit();
            return "1#";
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
    [WebMethod(EnableSession = true)]
    public static string bindState(string SupplierID)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT StateId,State FROM `st_supplier_gstn` WHERE `SupplierID`='" + SupplierID + "' ORDER BY State"));

    }
}

public class podetail
{

    public string PurchaseOrderID { get; set; }
    public string PurchaseOrderNo { get; set; }

    public string ItemID { get; set; }
    public string Rate { get; set; }

    public string TaxAmount { get; set; }
    public string DiscountAmount { get; set; }
    public string DiscountPercentage { get; set; }
    public string NetAmount { get; set; }
    public string UnitPrice { get; set; }
}
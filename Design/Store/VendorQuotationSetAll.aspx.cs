using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_VendorQuotationSetAll : System.Web.UI.Page
{
    public string approvaltypemaker = "0";
    public string approvaltypechecker = "0";
    public string approvaltypeapproval = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //txtentrydate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
       
            calFromDate.StartDate = DateTime.Now;
            txtentrydate0_CalendarExtender0.StartDate = DateTime.Now;
            bindalldata();

            string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM st_approvalright WHERE apprightfor='VQ' AND employeeid='" + UserInfo.ID + "' ");
            if (dt != "0")
            {
                if (dt.Contains("Checker"))
                {
                    approvaltypechecker = "1";
                }
                if (dt.Contains("Approval"))
                {
                    approvaltypeapproval = "1";
                }
                if (dt.Contains("Maker"))
                {
                    approvaltypemaker = "1";
                }


            }

        }

    }

    void bindalldata()
    {


        ddlmachineall.DataSource = StockReports.GetDataTable("SELECT ID, NAME FROM macmaster ORDER BY Name");
        ddlmachineall.DataValueField = "ID";
        ddlmachineall.DataTextField = "Name";
        ddlmachineall.DataBind();
        ddlmachineall.Items.Insert(0, new ListItem("Select Machine", "0"));
    }




    [WebMethod(EnableSession = true)]
    public static string bindlocation(string TypeId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(lm.LocationID,'#',cm.`CentreID`,'#',cm.`Centre`,'#',cm.`StateID`,'#',cm.`State`,'#',Location)LocationID,Location FROM st_locationmaster lm  ");
        //  sb.Append(" INNER JOIN st_mappingitemmaster stm ON stm.`LocationId`=lm.LocationId AND IsPIItem=1 ");
        sb.Append(" INNER JOIN f_panel_master pm on pm.`panel_id`=lm.`panel_id`  ");
        sb.Append(" INNER join centre_master cm on   cm.`CentreID`=pm.`CentreID` AND pm.`PanelType`in('Centre','PUP')   and cm.IsActive=1");
        if (TypeId != "")
            sb.Append("  AND cm.Type1Id IN(" + TypeId + ")");

        sb.Append(" WHERE lm.IsActive=1 group by lm.LocationID ORDER BY lm.Location");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }



   

   

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getitemdetailtoaddall(string machine, string locationidfrom)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT itemcat.SubCategoryID itemtypeid,itemcat.Name ItemCategory,sm.typename ItemName,sm.hsncode, sm.Itemid, ");
        sb.Append(" sm.ManufactureID,smm.name ManufactureName,sm.catalogno,MachineID,MachineName, ");
        sb.Append(" MajorUnitId,MajorUnitName,Converter  PackSize,MinorUnitId,MinorUnitName,sm.gstntax ");

        sb.Append("  FROM st_itemmaster sm  ");
        //   sb.Append(" INNER JOIN st_mappingitemmaster smm1 ON smm1.`ItemId`=sm.`ItemID`    ");
        //  sb.Append(" AND smm1.`LocationId` IN (" + locationidfrom + ")  ");
        sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID  ");
        sb.Append(" INNER JOIN st_manufacture_master smm ON smm.MAnufactureID=sm.ManufactureID ");
        sb.Append(" where sm.machineid='" + machine + "' group by sm.Itemid");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveVendorQuotation(List<StoreSupplierQuotation> quotationdata)
    {
        string Qutationno = "";
        MySqlConnection con = Util.GetMySqlCon();


        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string issaved = "";
            string qut = "select ifnull(max(Qutationno),0)+1 from st_vendorqutation";
            Qutationno = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, qut.ToString()));
            foreach (StoreSupplierQuotation objsq in quotationdata)
            {

               
                    DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT location,pm.panel_id,company_name FROM st_locationmaster sl INNER JOIN f_panel_master pm ON pm.panel_id=sl.panel_id WHERE locationid=" + objsq.DeliveryLocationID.ToString() + "").Tables[0];
                    StoreSupplierQuotation obj = new StoreSupplierQuotation(tnx);
                    obj.Qutationno = Qutationno;
                    obj.Quotationrefno = objsq.Quotationrefno;
                    obj.VendorId = objsq.VendorId;
                    obj.VendorName = objsq.VendorName;
                    obj.VendorAddress = objsq.VendorAddress;
                    obj.VendorStateId = objsq.VendorStateId;
                    obj.VednorStateName = objsq.VednorStateName;
                    obj.VednorStateGstnno = objsq.VednorStateGstnno;
                    obj.EntryDateFrom = objsq.EntryDateFrom;
                    obj.EntryDateTo = objsq.EntryDateTo;
                    obj.DeliveryStateID = objsq.DeliveryStateID;
                    obj.DeliveryStateName = objsq.DeliveryStateName;
                    obj.DeliveryCentreID = dt.Rows[0]["panel_id"].ToString();
                    obj.DeliveryCentreName = dt.Rows[0]["company_name"].ToString();
                    obj.DeliveryLocationID = objsq.DeliveryLocationID.ToString();
                    obj.DeliveryLocationName = dt.Rows[0]["location"].ToString();
                    obj.ItemCategoryID = objsq.ItemCategoryID;

                    obj.ItemCategoryName = objsq.ItemCategoryName;
                    obj.ItemID = objsq.ItemID;
                    obj.ItemName = objsq.ItemName;
                    obj.HSNCode = objsq.HSNCode;
                    obj.ManufactureID = objsq.ManufactureID;
                    obj.ManufactureName = objsq.ManufactureName;
                    obj.MachineID = objsq.MachineID;
                    obj.MachineName = objsq.MachineName;



                    obj.Rate = objsq.Rate;
                    obj.Qty = objsq.Qty;
                    obj.DiscountPer = objsq.DiscountPer;
                    obj.IGSTPer = objsq.IGSTPer;
                    obj.SGSTPer = objsq.SGSTPer;
                    obj.CGSTPer = objsq.CGSTPer;
                    obj.ConversionFactor = objsq.ConversionFactor;
                    obj.PurchasedUnit = objsq.PurchasedUnit;
                    obj.ConsumptionUnit = objsq.ConsumptionUnit;
                    obj.BuyPrice = objsq.BuyPrice;
                    obj.FreeQty = objsq.FreeQty;
                    obj.DiscountAmt = objsq.DiscountAmt;
                    obj.GSTAmount = objsq.GSTAmount;
                    obj.FinalPrice = objsq.FinalPrice;

                    obj.IsActive = objsq.IsActive;


                    issaved = obj.Insert();
                    if (issaved == string.Empty)
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        return "0#Error";

                    }
              

            }

           


            tnx.Commit();

            return "1#" + Qutationno;
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.GetBaseException());

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

 
}

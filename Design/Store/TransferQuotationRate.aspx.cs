using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_TransferQuotationRate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       

        
    }

    [WebMethod(EnableSession = true)]
    public static string bindlocation()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT  deliverylocationid,deliverylocationname FROM `st_vendorqutation` group by deliverylocationid ORDER BY deliverylocationname"));
       


    }

    [WebMethod(EnableSession = true)]
    public static string bindmachine()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT DISTINCT MachineID,MachineName FROM `st_vendorqutation` ORDER BY MachineName"));



    }
    [WebMethod(EnableSession = true)]
    public static string bindsupplier()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT DISTINCT VendorId,VendorName FROM `st_vendorqutation` ORDER BY VendorName"));
    }
    [WebMethod(EnableSession = true)]
    public static string bindsupplierchange()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT  SupplierID,SupplierName FROM `st_vendormaster` where isactive=1 ORDER BY SupplierName"));
    }
    
    [WebMethod(EnableSession = true)]
    public static string bindtolocation()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT locationid ,location FROM `st_locationmaster` ORDER BY location"));



    }

    [WebMethod(EnableSession = true)]
    public static string SearchFromRecords(string locationid, string machineid, string supplier)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT vendorname,VednorStateName,MachineName,(select typename from st_itemmaster where itemid=sv.itemid)ItemName,Rate,DiscountPer ,DiscountAmt,IGSTPer,SGSTPer,CGSTPer,itemid,");
        sb.Append(" GSTAmount,FinalPrice,ComparisonStatus FROM st_vendorqutation sv");
        
        sb.Append(" where deliverylocationid='" + locationid + "' ");
        sb.Append(" and IsActive=1 and ApprovalStatus=2 and EntryDateTo>=date(now()) ");

        if (machineid != "")
        {
            sb.Append(" and machineid in (" + machineid + ") ");
        }
        if (supplier != "")
        {
            sb.Append(" and VendorId in (" + supplier + ") ");
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));




    }
    [WebMethod(EnableSession = true)]
    public static string TransferRateRecords(string locationid, string machineid, string tolocation, string supplier, string tosupplier, string tosuppliername, string tostate, string tostatename, string tosupplieraddress, string togstn,string itemidtosave)
    {

        int count = tolocation.Split(',').Length;
        if (count > 50)
        {
            return "3";
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            foreach (string location in tolocation.Split(','))
            {
                if (locationid != location)
                {

                    String itemid = "";

                    StringBuilder sbupdate = new StringBuilder();
                    //sbupdate.Append(" select itemid FROM st_vendorqutation ");
                    //sbupdate.Append(" where deliverylocationid='" + locationid + "' and IsActive=1 and ApprovalStatus=2 and EntryDateTo>=date(now()) and ComparisonStatus=1  ");
                    //if (machineid != "")
                    //{
                    //    sbupdate.Append("  and machineid in (" + machineid + ")");
                    //}
                    //if (supplier != "")
                    //{
                    //    sbupdate.Append("  and vendorid in (" + supplier + ")");
                    //}



                    //foreach (DataRow dw in MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sbupdate.ToString()).Tables[0].Rows)
                    //{
                    //    itemid += dw["itemid"].ToString() + ",";
                    //}

                    sbupdate = new StringBuilder();
                    sbupdate.Append("update st_vendorqutation set ComparisonStatus=0 where DeliveryLocationID=" + location + "");
                    sbupdate.Append(" and itemid in (" +itemidtosave + ") ");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbupdate.ToString());




                    string Qutationno = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select ifnull(max(Qutationno),0)+1 from st_vendorqutation"));


                    DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT cm.StateID,(SELECT state FROM state_master WHERE id=cm.StateID) Statename,location,pm.panel_id,company_name FROM st_locationmaster sl INNER JOIN f_panel_master pm ON pm.panel_id=sl.panel_id INNER JOIN centre_master cm on cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' then pm.`CentreID` else pm.tagprocessinglabid END AND pm.`PanelType` in('Centre','PUP')  WHERE locationid=" + location + "").Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append(" INSERT INTO st_vendorqutation (Qutationno,Quotationrefno,VendorId, ");
                        sb.Append(" VendorName,VendorAddress, ");
                        sb.Append(" VendorStateId, VednorStateName, ");
                        sb.Append(" VednorStateGstnno,EntryDateFrom,EntryDateTo,DeliveryStateID, ");
                        sb.Append(" DeliveryStateName,DeliveryCentreID, ");
                        sb.Append(" DeliveryCentrename,DeliveryLocationID, ");
                        sb.Append(" DeliveryLocationName,ItemCategoryID,ItemCategoryName,ItemID,ItemName,HSNCode, ");
                        sb.Append(" ManufactureID,ManufactureName,MachineID,MachineName,Rate,Qty,DiscountPer, ");
                        sb.Append(" IGSTPer,SGSTPer,CGSTPer,ConversionFactor,PurchasedUnit,ConsumptionUnit,BuyPrice,FreeQty,DiscountAmt, ");
                        sb.Append(" GSTAmount,FinalPrice,CreaterDateTime,CreaterID,CheckedDate,CheckedBy,ApprovedDate,ApprovedBy, ");
                        sb.Append(" ApprovalStatus,IsActive,ComparisonStatus,ComparisonDate,ComparisonBy,Updatedate,updatebyid)  ");

                        sb.Append("  SELECT '" + Qutationno + "','',");

                        if (tosupplier == "" || tosupplier == "0")
                        {
                            sb.Append("  VendorId, ");
                            sb.Append("  VendorName,VendorAddress, ");
                            sb.Append("  VendorStateId, VednorStateName, ");
                            sb.Append("  VednorStateGstnno,");
                        }
                        else
                        {
                            sb.Append("  '" + tosupplier + "', ");
                            sb.Append(" '" + tosuppliername + "' ,'" + tosupplieraddress + "', ");
                            sb.Append("  '" + tostate.Split('#')[0] + "', '" + tostatename + "', ");
                            sb.Append("  '" + togstn + "',");
                        }
                        sb.Append("  EntryDateFrom,EntryDateTo,'" + Util.GetString(dt.Rows[0]["StateID"]) + "' , ");
                        sb.Append("  '" + Util.GetString(dt.Rows[0]["Statename"]) + "' ,'" + Util.GetString(dt.Rows[0]["panel_id"]) + "' , ");
                        sb.Append("  '" + Util.GetString(dt.Rows[0]["company_name"]) + "' ,'" + location + "' ,");
                        sb.Append("  '" + Util.GetString(dt.Rows[0]["location"]) + "' ,ItemCategoryID,ItemCategoryName,ItemID,ItemName,HSNCode, ");
                        sb.Append("  ManufactureID,ManufactureName,MachineID,MachineName,Rate,Qty,DiscountPer, ");
                        if (tosupplier == "" || tosupplier == "0")
                        {
                            sb.Append(" if('" + Util.GetString(dt.Rows[0]["StateID"]) + "'<>VendorStateId,(IGSTPer+SGSTPer+CGSTPer),0)  IGSTPer,");
                            sb.Append(" if('" + Util.GetString(dt.Rows[0]["StateID"]) + "'<>VendorStateId,0,(IGSTPer+SGSTPer+CGSTPer)/2)  SGSTPer,");
                            sb.Append(" if('" + Util.GetString(dt.Rows[0]["StateID"]) + "'<>VendorStateId,0,(IGSTPer+SGSTPer+CGSTPer)/2)  CGSTPer,");

                        }
                        else
                        {
                            sb.Append(" if('" + Util.GetString(dt.Rows[0]["StateID"]) + "'<>'" + tostate.Split('#')[0] + "',(IGSTPer+SGSTPer+CGSTPer),0)  IGSTPer,");
                            sb.Append(" if('" + Util.GetString(dt.Rows[0]["StateID"]) + "'<>'" + tostate.Split('#')[0] + "',0,(IGSTPer+SGSTPer+CGSTPer)/2)  SGSTPer,");
                            sb.Append(" if('" + Util.GetString(dt.Rows[0]["StateID"]) + "'<>'" + tostate.Split('#')[0] + "',0,(IGSTPer+SGSTPer+CGSTPer)/2)  CGSTPer,");
                        }

                        sb.Append("  ConversionFactor,PurchasedUnit,ConsumptionUnit,BuyPrice,FreeQty,DiscountAmt, ");
                        sb.Append("  GSTAmount,FinalPrice,NOW() CreaterDateTime,'" + UserInfo.ID + "',NOW() CheckedDate,'" + UserInfo.ID + "',NOW() ApprovedDate,'" + UserInfo.ID + "', ");
                        sb.Append("  2 ApprovalStatus,IsActive,1 ComparisonStatus,NOW() ComparisonDate,'" + UserInfo.ID + "',now() updatedate,'" + UserInfo.ID + "' updatebyid ");
                        sb.Append("  FROM st_vendorqutation ");

                        sb.Append(" where deliverylocationid='" + locationid + "' and IsActive=1 and ApprovalStatus=2 and EntryDateTo>=date(now()) and ComparisonStatus=1  ");

                        if (machineid != "")
                        {
                            sb.Append("  and machineid in (" + machineid + ")");
                        }
                        if (supplier != "")
                        {
                            sb.Append("  and vendorid in (" + supplier + ")");
                        }

                        sb.Append(" and itemid in (" + itemidtosave + ")");
						 System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\TRF.txt",sb.ToString());
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                    }
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
            return Util.GetString(ex.GetBaseException());

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    

    
}
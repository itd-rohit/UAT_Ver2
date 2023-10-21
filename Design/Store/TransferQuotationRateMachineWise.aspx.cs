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

public partial class Design_Store_TransferQuotationRateMachineWise : System.Web.UI.Page
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

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT id MachineID,NAME MachineName FROM macmaster ORDER BY NAME"));



    }
   

    [WebMethod(EnableSession = true)]
    public static string bindtolocation()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT locationid ,location FROM `st_locationmaster` ORDER BY location"));



    }

    [WebMethod(EnableSession = true)]
    public static string SearchFromRecords(string locationid, string machineid, string machineidto)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT vendorname,VednorStateName,sv.MachineName,im.typename ItemName,Rate,DiscountPer ,DiscountAmt,IGSTPer,SGSTPer,CGSTPer,sv.itemid,im.ItemIDGroup,");
        sb.Append(" GSTAmount,FinalPrice,ComparisonStatus, ");
        sb.Append("  ifnull(imm.`ItemID`,0) itemidto,ifnull(imm.`TypeName`,'') itemnameto ");
        sb.Append(" FROM st_vendorqutation sv inner join st_itemmaster im on im.itemid=sv.itemid");
        sb.Append(" LEFT JOIN st_itemmaster imm ON imm.itemid<>im.`ItemID` AND imm.`ItemIDGroup`=im.`ItemIDGroup` AND imm.`MachineID`='" + machineidto + "' ");
        sb.Append(" where deliverylocationid='" + locationid + "' ");
        sb.Append(" and sv.IsActive=1 and sv.ApprovalStatus=2 and EntryDateTo>=current_date ");
        sb.Append(" and sv.machineid  ='" + machineid + "' ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod(EnableSession = true)]
    public static string TransferRateRecords(string locationid, string machineid,string machineidto, string tolocation,  string itemidtosave)
    {

        int count = tolocation.Split(',').Length;
        if (count > 20)
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

                  
                    StringBuilder sbupdate = new StringBuilder();


                    sbupdate = new StringBuilder();
                    sbupdate.Append(" update st_vendorqutation sv ");
                    sbupdate.Append(" inner join st_itemmaster im on im.itemid=sv.itemid and im.machineid=" + machineidto + " ");
                    sbupdate.Append(" set ComparisonStatus=0 where DeliveryLocationID=" + location + "");
                    sbupdate.Append(" and itemidgroup in (" + itemidtosave + ") ");

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
                        sb.Append("  VendorId, ");
                        sb.Append("  VendorName,VendorAddress, ");
                        sb.Append("  VendorStateId, VednorStateName, ");
                        sb.Append("  VednorStateGstnno,");
                        sb.Append("  EntryDateFrom,EntryDateTo,'" + Util.GetString(dt.Rows[0]["StateID"]) + "' , ");
                        sb.Append("  '" + Util.GetString(dt.Rows[0]["Statename"]) + "' ,'" + Util.GetString(dt.Rows[0]["panel_id"]) + "' , ");
                        sb.Append("  '" + Util.GetString(dt.Rows[0]["company_name"]) + "' ,'" + location + "' ,");
                        sb.Append("  '" + Util.GetString(dt.Rows[0]["location"]) + "' ,ItemCategoryID,ItemCategoryName,ifnull(imm.ItemID,0)Itemid,ifnull(imm.typename,''),ifnull(imm.HSNCode,'')HSNCode, ");
                        sb.Append("  imm.ManufactureID,imm.ManufactureName,imm.MachineID,imm.MachineName,Rate,Qty,DiscountPer, ");
                        sb.Append(" if('" + Util.GetString(dt.Rows[0]["StateID"]) + "'<>VendorStateId,(IGSTPer+SGSTPer+CGSTPer),0)  IGSTPer,");
                        sb.Append(" if('" + Util.GetString(dt.Rows[0]["StateID"]) + "'<>VendorStateId,0,(IGSTPer+SGSTPer+CGSTPer)/2)  SGSTPer,");
                        sb.Append(" if('" + Util.GetString(dt.Rows[0]["StateID"]) + "'<>VendorStateId,0,(IGSTPer+SGSTPer+CGSTPer)/2)  CGSTPer,");

                       

                        sb.Append("  imm.converter,PurchasedUnit,ConsumptionUnit,BuyPrice,FreeQty,DiscountAmt, ");
                        sb.Append("  GSTAmount,FinalPrice,NOW() CreaterDateTime,'" + UserInfo.ID + "',NOW() CheckedDate,'" + UserInfo.ID + "',NOW() ApprovedDate,'" + UserInfo.ID + "', ");
                        sb.Append("  2 ApprovalStatus,1 IsActive,1 ComparisonStatus,NOW() ComparisonDate,'" + UserInfo.ID + "',now() updatedate,'" + UserInfo.ID + "' updatebyid ");
                        sb.Append("  FROM st_vendorqutation sv ");
                        sb.Append("  inner join st_itemmaster im on im.itemid=sv.itemid and im.itemidgroup in (" + itemidtosave + ")");
                        sb.Append("  LEFT JOIN st_itemmaster imm ON imm.itemid<>im.`ItemID` AND imm.`ItemIDGroup`=im.`ItemIDGroup` AND imm.`MachineID`='" + machineidto + "' ");
                        sb.Append("  and imm.itemidgroup in (" + itemidtosave + ")");
                        sb.Append("  where deliverylocationid='" + locationid + "' and sv.IsActive=1 and sv.ApprovalStatus=2 and EntryDateTo>=current_date and ComparisonStatus=1  ");
                        sb.Append("  and sv.machineid =" + machineid + " ");
                                                                  
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
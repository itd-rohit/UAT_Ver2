using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_VendorQuotation : System.Web.UI.Page
{
    public string approvaltypemaker = "0";
    public string approvaltypechecker = "0";
    public string approvaltypeapproval = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //txtentrydate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calFromDate.StartDate = DateTime.Now;
            txtentrydate0_CalendarExtender0.StartDate = DateTime.Now;
            bindalldata();

            ddlitemsearch.DataSource = StockReports.GetDataTable("select typename,itemid from st_itemmaster where isactive=1 order by typename ");
            ddlitemsearch.DataValueField = "itemid";
            ddlitemsearch.DataTextField = "typename";
            ddlitemsearch.DataBind();
            ddlitemsearch.Items.Insert(0, new ListItem("Select Item","0"));



            ddllocationsearch.DataSource = StockReports.GetDataTable("select location,locationid from st_locationmaster where isactive=1 order by location ");
            ddllocationsearch.DataValueField = "locationid";
            ddllocationsearch.DataTextField = "location";
            ddllocationsearch.DataBind();
            ddllocationsearch.Items.Insert(0, new ListItem("Select Location", "0"));

            string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM st_approvalright WHERE apprightfor='VQ' AND employeeid='" + UserInfo.ID + "' and active=1 ");
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


       


        ddlcentrestate.DataSource = StockReports.GetDataTable("SELECT  ID,State Name FROM state_master where IsActive=1 ORDER BY State");
        ddlcentrestate.DataValueField = "ID";
        ddlcentrestate.DataTextField = "Name";
        ddlcentrestate.DataBind();
        ddlcentrestate.Items.Insert(0, new ListItem("Select", "0"));

        ddlmachineall.DataSource=StockReports.GetDataTable("SELECT ID, NAME FROM macmaster  WHERE isactive=1 ORDER BY Name");
        ddlmachineall.DataValueField = "ID";
        ddlmachineall.DataTextField = "Name";
        ddlmachineall.DataBind();
        ddlmachineall.Items.Insert(0, new ListItem("Select Machine", "0"));
    }

   


    [WebMethod(EnableSession = true)]
    public static string bindlocation(string centreid, string StateID, string TypeId, string ZoneId, string cityId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lm.LocationID,Location FROM st_locationmaster lm  ");
      //  sb.Append(" INNER JOIN st_mappingitemmaster stm ON stm.`LocationId`=lm.LocationId AND IsPIItem=1 ");
        sb.Append(" INNER JOIN f_panel_master pm on pm.`panel_id`=lm.`panel_id`  ");
        sb.Append(" INNER join centre_master cm on   cm.`CentreID`=pm.`CentreID` AND pm.`PanelType`in('Centre','PUP')   and cm.IsActive=1");
        if (ZoneId != "")
            sb.Append(" AND cm.BusinessZoneID IN(" + ZoneId + ")");

        if (StateID != "")
            sb.Append("  AND cm.StateID IN(" + StateID + ")");

        if (cityId != "")
            sb.Append(" AND cm.cityid IN(" + cityId + ")");

        if (TypeId != "")
            sb.Append("  AND cm.Type1Id IN(" + TypeId + ")");

        if (centreid != "")
            sb.Append("  AND  pm.`panel_id` IN(" + centreid + ")");

        sb.Append(" WHERE lm.IsActive=1 group by lm.LocationID ORDER BY lm.Location");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getitemdetail(string itemid)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT ManufactureID,ManufactureName  ");
        sb.Append("  FROM st_ItemManufactureSectionDetail where ItemId='" + itemid + "'");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getitemdetailtoadd(string itemid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT itemcat.SubCategoryID itemtypeid,itemcat.Name ItemCategory,sm.typename ItemName,sm.hsncode, sm.Itemid, ");
        sb.Append(" sm.ManufactureID,smm.name ManufactureName,sm.catalogno,MachineID,MachineName, ");
        sb.Append(" MajorUnitId,MajorUnitName,Converter  PackSize,MinorUnitId,MinorUnitName,sm.gstntax ");

        sb.Append("  FROM st_itemmaster sm  ");

        sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID  ");
        sb.Append(" INNER JOIN st_manufacture_master smm ON smm.MAnufactureID=sm.ManufactureID ");
        sb.Append(" where sm.itemid='" + itemid + "'");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getitemdetailtoaddall(string machine, string locationidfrom, string itemtype)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT itemcat.SubCategoryID itemtypeid,itemcat.Name ItemCategory,sm.typename ItemName,sm.hsncode, sm.Itemid, ");
        sb.Append(" sm.ManufactureID,smm.name ManufactureName,sm.catalogno,MachineID,MachineName, ");
        sb.Append(" MajorUnitId,MajorUnitName,Converter  PackSize,MinorUnitId,MinorUnitName,sm.gstntax ");

        sb.Append("  FROM st_itemmaster sm  ");
        sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID  ");
        sb.Append(" INNER JOIN st_manufacture_master smm ON smm.MAnufactureID=sm.ManufactureID ");
        sb.Append(" where sm.machineid='" + machine + "' and sm.isactive=1 AND sm.approvalstatus=2 ");
        if (itemtype == "Capex")
        {
            sb.Append(" and sm.CategoryTypeID=1");
        }
        else if (itemtype == "Opex")
        {
            sb.Append(" and sm.CategoryTypeID=2");
        }
       
        sb.Append(" group by sm.Itemid ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveVendorQuotation(List<StoreSupplierQuotation> quotationdata, List<string> quotationdataterm)
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

                for (int a = 0; a <= objsq.DeliveryLocationID.Split(',').Length-1; a++)
                {
                    DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT location,pm.panel_id,company_name FROM st_locationmaster sl INNER JOIN f_panel_master pm ON pm.panel_id=sl.panel_id WHERE locationid=" + objsq.DeliveryLocationID.Split(',')[a].ToString() + "").Tables[0];
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
                    obj.DeliveryLocationID = objsq.DeliveryLocationID.Split(',')[a].ToString();
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

            }

            foreach (string s in quotationdataterm)
            {
                string sb = "INSERT INTO st_Qutationtermsconditions (TermsCondition,Qutationno) VALUES('" + s + "','" + Qutationno + "')";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
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

     [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateVendorQuotation(List<StoreSupplierQuotation> quotationdata, List<string> quotationdataterm)
    {
        string Qutationno = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string issaved = "";
          
            foreach (StoreSupplierQuotation objsq in quotationdata)
            {
                StoreSupplierQuotation obj = new StoreSupplierQuotation(tnx);
                obj.Qutationno = objsq.Qutationno;
                obj.Quotationrefno = objsq.Quotationrefno;
                obj.VendorId = objsq.VendorId;
                obj.VendorName = objsq.VendorName;
                obj.VendorAddress = objsq.VendorAddress;
                obj.VendorStateId = objsq.VendorStateId;
                obj.VednorStateName = objsq.VednorStateName;
                obj.VednorStateGstnno = objsq.VednorStateGstnno;
                obj.EntryDateFrom = objsq.EntryDateFrom;
                obj.DeliveryStateID = objsq.DeliveryStateID;
                obj.DeliveryStateName = objsq.DeliveryStateName;
                obj.DeliveryCentreID = objsq.DeliveryCentreID;
                obj.DeliveryCentreName = objsq.DeliveryCentreName;

                obj.DeliveryLocationID = objsq.DeliveryLocationID;
                obj.DeliveryLocationName = objsq.DeliveryLocationName;
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

            foreach (string s in quotationdataterm)
            {
                string sb = "INSERT INTO st_Qutationtermsconditions (TermsCondition,Qutationno) VALUES('" + s + "','" + Qutationno + "')";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
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

    
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
     public static string SearchData(string quno, string fromdate, string todate, string Status, string NoofRecord, string vendorid, string itemid,string location)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append("    SELECT date_format(entrydatefrom,'%d-%b-%Y')EntryDateFrom,date_format(entrydateTo,'%d-%b-%Y')EntryDateTo,   ApprovalStatus,CASE WHEN ApprovalStatus=0 THEN 'bisque' WHEN ApprovalStatus=1  ");
        sb.Append("    THEN 'pink' WHEN ApprovalStatus=2 THEN 'lightgreen'  END rowcolor, ");
        sb.Append("   Qutationno,VendorName,CONCAT(VendorAddress,' ',VednorStateName) Address,	VednorStateGstnno,DeliveryStateName, ");
        sb.Append("  group_concat(Distinct DeliveryLocationName)DeliveryLocationName FROM st_vendorqutation ");
        sb.Append(" where isactive=1 and ");
        sb.Append("  CreaterDateTime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" and CreaterDateTime<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (quno != "")
        {
            sb.Append(" and (Qutationno='" + quno + "' or Quotationrefno ='" + quno + "') ");
        }
        if (vendorid != "0")
        {
            sb.Append(" and VendorId='" + vendorid + "'");
        }
        if (itemid != "0")
        {
            sb.Append(" and ItemID='" + itemid + "'");
        }
        if (location != "0")
        {
            sb.Append(" and DeliveryLocationid='" + location + "'");
        }
        if (Status != "")
        {
            sb.Append(" and ApprovalStatus='" + Status + "'");
        }
        sb.Append("   group by  Qutationno order by Qutationno  desc limit " + NoofRecord + "");


        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SetStatus(int itemId, int Status)
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string str = "";
            if (Status == 1)
            {
                str = "update st_vendorqutation set ApprovalStatus='" + Status + "',CheckedBy='" + UserInfo.ID + "',CheckedDate=now() where Qutationno='" + itemId + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
               

            }

            if (Status == 2)
            {
                str = "update st_vendorqutation set ApprovalStatus='" + Status + "',ApprovedBy='" + UserInfo.ID + "',ApprovedDate=now() where Qutationno='" + itemId + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select  itemid,DeliveryLocationID from st_vendorqutation where Qutationno='" + itemId + "'").Tables[0];

                foreach (DataRow dw in dt.Rows)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE st_vendorqutation SET ComparisonStatus=0 WHERE ItemID=@ItemID AND DeliveryLocationID=@DeliveryLocationID ",
                               new MySqlParameter("@ItemID", dw["ItemID"].ToString()), 
                               new MySqlParameter("@DeliveryLocationID", dw["DeliveryLocationID"].ToString()));

                    string quno = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT qutationno FROM st_vendorqutation WHERE itemid=@itemid AND `DeliveryLocationID`=@DeliveryLocationID and ApprovalStatus=2 and isactive=1 ORDER BY CreaterDateTime desc LIMIT 1",
                               new MySqlParameter("@ItemID", dw["ItemID"].ToString()),
                               new MySqlParameter("@DeliveryLocationID", dw["DeliveryLocationID"].ToString())).ToString();


                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE st_vendorqutation SET ComparisonStatus=1 WHERE ItemID=@ItemID AND DeliveryLocationID=@DeliveryLocationID and qutationno=@qutationno ",
                             new MySqlParameter("@ItemID", dw["ItemID"].ToString()),
                             new MySqlParameter("@DeliveryLocationID", dw["DeliveryLocationID"].ToString()),
                             new MySqlParameter("@qutationno", quno));

                }

            }

            tnx.Commit();
            return "true";
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


   



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetDataToUpdate(string qid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT (select GROUP_CONCAT(TermsCondition) from st_Qutationtermsconditions where Qutationno=st.Qutationno) term, (SELECT CatalogNo FROM `st_itemmanufacturesectiondetail` WHERE itemid=st.itemid AND MAnufactureID=st.ManufactureID) catalogno, Qutationno,Quotationrefno,vendorid,vendoraddress,vendorstateid,VednorStateGstnno,date_format(entrydatefrom,'%d-%b-%Y')entrydate,deliverystateid,deliverycentreid  ");
        sb.Append(" ,ItemCategoryID,ItemCategoryName,ItemID,ItemName,HSNCode,ManufactureID,ManufactureName,MachineID,MachineName,Rate,Qty,DiscountPer, ");
        sb.Append(" IGSTPer,SGSTPer,CGSTPer,ConversionFactor,PurchasedUnit,ConsumptionUnit,BuyPrice,FreeQty,DiscountAmt,GSTAmount,FinalPrice,IsActive ");
        sb.Append(" FROM st_vendorqutation st WHERE Qutationno='" + qid + "' ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchItem(string itemname, string locationidfrom, string itemtype)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT si.`ItemIDGroup`,sig.`ItemNameGroup` ");
        sb.Append(" FROM st_itemmaster si     ");
        sb.Append(" INNER JOIN `st_itemmaster_group` sig ON sig.`ItemIDGroup`=si.`ItemIDGroup` ");
        //    sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`    ");
        //  sb.Append(" AND smm.`LocationId` IN (" + locationidfrom+ ")  ");
        sb.Append(" AND typename LIKE '" + itemname + "%'  ");
        sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2    ");


        if (itemtype == "Capex")
        {
            sb.Append(" and si.CategoryTypeID=1");
        }
        else if (itemtype == "Opex")
        {
            sb.Append(" and si.CategoryTypeID=2");
        }


        sb.Append(" GROUP BY sig.`ItemIDGroup` ORDER BY sig.`ItemNameGroup` LIMIT 20 ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindManufacturer(string locationidfrom, string ItemIDGroup)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT si.`ManufactureID`,si.`ManufactureName`   ");
        sb.Append("  FROM st_itemmaster si      ");
      //  sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`   ");
       // sb.Append("  AND smm.`LocationId` in( " + locationidfrom + ")   ");
       
        sb.Append(" where si.`ItemIDGroup`  = '" + ItemIDGroup + "' ");
        sb.Append(" and si.isactive=1 AND si.approvalstatus=2  ");
        sb.Append(" GROUP BY si.`ManufactureID` ");
        sb.Append(" ORDER BY si.`ManufactureName` ; ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindMachine(string locationidfrom, string ItemIDGroup, string ManufactureID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("    SELECT si.`MachineID`,si.`MachineName`     ");
        sb.Append(" FROM st_itemmaster si       ");
     //   sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`    ");
     //   sb.Append(" AND smm.`LocationId`  in( " + locationidfrom + ")    ");
     
        sb.Append(" where si.`ItemIDGroup`  = '" + ItemIDGroup + "' AND `ManufactureID`='" + ManufactureID + "'  ");
        sb.Append(" and si.isactive=1 AND si.approvalstatus=2   ");
        sb.Append("  GROUP BY si.`MachineID`  ");
        sb.Append("  ORDER BY si.`MachineName` ;  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindPackSize(string locationidfrom, string ItemIDGroup, string ManufactureID, string MachineID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT si.`PackSize`, concat(si.`IssueMultiplier`,'#',si.`MinorUnitName`,'#',si.`ItemID`)PackValue  ");
        sb.Append(" FROM st_itemmaster si       ");
    //    sb.Append("  INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`    ");
     //   sb.Append(" AND smm.`LocationId` in( " + locationidfrom + ")   ");
      
        sb.Append(" where si.`ItemIDGroup`  = '" + ItemIDGroup + "' AND `ManufactureID`='" + ManufactureID + "' AND si.`MachineID`='" + MachineID + "'  ");
        sb.Append(" and si.isactive=1 AND si.approvalstatus=2   ");
        sb.Append(" GROUP BY si.`PackSize`  ");
        sb.Append(" ORDER BY si.`PackSize` ;  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    
}

using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class Design_Store_DirectIssue : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            


            ddlcategorytype.DataSource = StockReports.GetDataTable("SELECT `CategoryTypeID` ID,`CategoryTypeName` Name FROM st_categorytypemaster where active=1 ORDER BY CategoryTypeName desc");
            ddlcategorytype.DataValueField = "ID";
            ddlcategorytype.DataTextField = "Name";
            ddlcategorytype.DataBind();
            string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM st_approvalright WHERE apprightfor='IS' AND active=1 AND employeeid='" + UserInfo.ID + "' ");
            if (dt == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';showerrormsg('Dear User You Did not Have Right To Issue Item');", true);
                return;
            }
            bindalldata();

        }
    }

    void bindalldata()
    {
        if (UserInfo.AccessStoreLocation != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT concat(locationid,'#',panel_id) locationid,location FROM st_locationmaster WHERE isactive=1   ");
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

            if (ddllocation.Items.Count == 1)
            {
                string res = StorePageAccess.OpenOtherStockPages(ddllocation.SelectedValue.Split('#')[0]);

                if (res != "1")
                {

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "hideme('" + res + "');", true);
                }
            }


            ddlissuelocation.Items.Insert(0, new ListItem("Select Issue To Location", "0"));
        }

    }

    [WebMethod(EnableSession = true)]
    public static string bindCentre(string TypeId, string ZoneId, string StateID)
    {





        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.Panel_ID CentreID,CONCAT(pm.company_name,'#',CM.CENTRECODE) Centre FROM f_panel_master  pm");
        sb.Append("  INNER JOIN centre_master cm on cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' then pm.`CentreID` else pm.tagprocessinglabid END AND pm.`PanelType` in('Centre','PUP')   WHERE pm.IsActive=1 ");
        if (ZoneId != "")
            sb.Append(" AND cm.BusinessZoneID IN(" + ZoneId + ")");

        if (StateID != "")
            sb.Append(" AND cm.StateID IN(" + StateID + ")");

       

        if (TypeId != "")
            sb.Append(" AND cm.Type1Id IN(" + TypeId + ")");

       

        sb.Append(" ORDER BY Centre");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));


    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindindentfromlocation(string tolocation,string TypeId, string ZoneId, string StateID,string panelid)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT concat(locationid,'#',sl.panel_id) locationid,location FROM st_locationmaster sl ");
        sb.Append("  INNER JOIN st_centerindentright    sc ON sl.locationid=sc.toLoationID  AND sc.fromloationID=" + tolocation.Split('#')[0] + " ");
        sb.Append("  AND IndentType='DirectIssue' AND  sl.isactive=1  ");
        sb.Append(" inner join f_panel_master pm on pm.panel_id=sl.panel_id INNER JOIN centre_master cm on cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' then pm.`CentreID` else pm.tagprocessinglabid END AND pm.`PanelType` in('Centre','PUP')   and pm.IsActive=1 ");
        if (ZoneId != "")
            sb.Append(" AND cm.BusinessZoneID IN(" + ZoneId + ")");

        if (StateID != "")
            sb.Append(" AND cm.StateID IN(" + StateID + ")");


        if (TypeId != "")
            sb.Append(" AND cm.Type1Id IN(" + TypeId + ")");
        if (panelid != "0" && panelid != "null" && panelid != "")
            sb.Append(" AND pm.panel_id IN(" + panelid + ")");
        sb.Append("  ORDER BY location  ");


        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchItemDetail(string itemid, string location,string barcodeno)
    {
        StringBuilder sb = new StringBuilder();


        sb.Append("    SELECT ss.barcodeno, ss.MinorUnitInDecimal,ss.itemid,itemname,ss.stockid,ss.locationid,ss.batchnumber,im.IssueMultiplier,  ");
        sb.Append("    IF(`ExpiryDate`='0001-01-01','',DATE_FORMAT(ExpiryDate,'%d-%b-%Y')) ExpiryDate,  ");
        sb.Append("    (`InitialCount` - `ReleasedCount`-PendingQty) AvilableQty,ss.MinorUnit,ss.UnitPrice   ");
        sb.Append("    FROM st_nmstock ss inner join st_itemmaster im on im.itemid=ss.itemid  WHERE ispost=1  AND (`InitialCount` - `ReleasedCount`-PendingQty)>0   ");

        sb.Append("    AND locationid=" + location.Split('#')[0] + " ");
        if (itemid != "")
        {
            sb.Append("    AND ss.itemid=" + itemid + " ");
        }
        if (barcodeno != "")
        {
            sb.Append("    AND ss.BarcodeNo='" + barcodeno + "' ");
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savedirectissue(List<string> datatosave, string narration,string DispatchOption, string DispatchDate, string CourierName, string AWBNumber, string FieldBoyID, string FieldBoyName, string OtherName, string NoofBox, string TotalWeight, string ConsignmentNote, string Temperature)
    {
        string stockidsavedto = "";
       
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string indentno = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_get_indent_no('Direct')").ToString();
            if (indentno == "")
            {
                tnx.Rollback();
                return "0#Error";
            }

            string batchno = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_get_indent_no('Direct-Inv')").ToString();


            foreach (string ss in datatosave)
            {

              
                string itemid = ss.Split('#')[1];
                string stockid = ss.Split('#')[0];
                string issueqty = ss.Split('#')[2];
                string fromlocation = ss.Split('#')[3];
                string frompanel = ss.Split('#')[4];

                // Insert Into Indent Table









                StringBuilder sb = new StringBuilder();
                sb.Append("   SELECT MajorUnitInDecimal,MinorUnitInDecimal,StockID,ItemID,ItemName,BatchNumber,Rate,DiscountPer,DiscountAmount,TaxPer,TaxAmount,UnitPrice,MRP, ");
                sb.Append("   ManufactureID,MacID,MajorUnitID,MajorUnit,MinorUnitID,MinorUnit,Converter,Naration,");
                sb.Append("   UnitPrice,MRP,ExpiryDate ,LocationID,Panel_Id,if(IsFree=1,1,0)IsFree,Remarks,if(Reusable=1,1,0)Reusable, BarcodeNo,");
                sb.Append(" IsExpirable,IssueMultiplier,PackSize,BarcodeOption,BarcodeGenrationOption,IssueInFIFO,Panel_Id, ");
                sb.Append("  IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=st.stockid   AND taxname='IGST') ,'') IGSTPer,");
                sb.Append(" IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=st.stockid   AND taxname='CGST') ,'') CGSTPer,");
                sb.Append(" IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=st.stockid   AND taxname='SGST') ,'') SGSTPer ");

                sb.Append("   from st_nmstock st where StockID='" + stockid + "' ");
                sb.Append("   and (InitialCount-ReleasedCount-PendingQty)>0  and ispost=1 ");


                DataTable dtResult = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString()).Tables[0];
                if (dtResult != null && dtResult.Rows.Count > 0)
                {

                    string sql = "select if(InitialCount < (ReleasedCount+PendingQty+" + issueqty + "),0,1)CHK from st_nmstock where stockID='" + stockid + "'";
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql)) <= 0)
                    {
                        tnx.Rollback();

                        return "0#Stock Unavailable";
                    }

                    string strUpdateStock = "update st_nmstock set ReleasedCount = ReleasedCount + " + Util.GetFloat(issueqty) + " where StockID = '" + stockid + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock);

                    // Insert Into Indent Table

                    StoreSalesIndent objindent = new StoreSalesIndent(tnx);
                    objindent.IndentNo = indentno;
                    objindent.ItemId = Util.GetInt(dtResult.Rows[0]["ItemID"]);
                    objindent.ItemName = Util.GetString(dtResult.Rows[0]["ItemName"]);
                    objindent.FromLocationID = Util.GetInt(fromlocation);
                    objindent.FromPanelId = Util.GetInt(frompanel);
                    objindent.ToLocationID = Util.GetInt(dtResult.Rows[0]["LocationID"]);
                    objindent.ToPanelID = Util.GetInt(dtResult.Rows[0]["Panel_Id"]);
                    objindent.ReqQty = Util.GetFloat(issueqty);
                    objindent.MinorUnitID = Util.GetInt(dtResult.Rows[0]["MinorUnitID"]);
                    objindent.MinorUnitName = Util.GetString(dtResult.Rows[0]["MinorUnit"]);
                    //  objindent.ExpectedDate = Util.GetDateTime(ssi.ExpectedDate);
                    objindent.Narration = "Direct Issue";
                    objindent.IndentType = "Direct";
                    objindent.Rate = Util.GetFloat(dtResult.Rows[0]["Rate"]); ;
                    objindent.DiscountPer = Util.GetFloat(dtResult.Rows[0]["DiscountPer"]);
                    objindent.TaxPerIGST = Util.GetFloat(dtResult.Rows[0]["IGSTPer"]);
                    objindent.TaxPerCGST = Util.GetFloat(dtResult.Rows[0]["CGSTPer"]);
                    objindent.TaxPerSGST = Util.GetFloat(dtResult.Rows[0]["SGSTPer"]); 
                    objindent.FromRights = "Approval";
                 
                    objindent.Vendorid = 0;
                    objindent.VendorStateId = 0;
                    objindent.VednorStateGstnno = "";

                    objindent.MaxQty = Util.GetFloat(issueqty);

                    objindent.Insert();

                    var rate = objindent.Rate;
                    var discper = objindent.DiscountPer;
                    var IGST = objindent.TaxPerIGST;
                    var CGST = objindent.TaxPerCGST;
                    var SGST = objindent.TaxPerSGST;

                    var Tax = IGST == 0 ? (CGST + SGST) : IGST;

                    var discountAmout = rate * discper * 0.01;
                    var ratedisc = rate - discountAmout;
                    var tax = ratedisc * Tax * 0.01;
                    var ratetaxincludetax = ratedisc + tax;

                   // var NetAmount = ratetaxincludetax * Util.GetFloat(objindent.ReqQty);

                    // Update Indent Table
                    string strUpdateindent = "update st_indent_detail set UnitPrice=" + ratetaxincludetax + ",  NetAmount=UnitPrice*ReqQty, ApprovedQty = ReqQty,CheckedQty=ReqQty,ApprovedDate=NOW(),ApprovedUserID=" + UserInfo.ID + " ,ApprovedUserName='" + UserInfo.LoginName + "',CheckedDate=NOW(),CheckedUserID=" + UserInfo.ID + ",CheckedUserName='" + UserInfo.LoginName + "',PendingQty = PendingQty +" + Util.GetFloat(issueqty) + ",IssueDate=now(),IssueBy='" + UserInfo.LoginName + "',IssueByID='" + UserInfo.ID + "' ,ActionType='Approval' where IndentNo = '" + indentno + "' and itemid='" + objindent.ItemId + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateindent);





                    sb = new StringBuilder();
                    sb.Append(" insert into st_indentissuedetail (StockID,ItemID,IndentNo,SendQty,ReceiveQty,DATETIME,UserID,IssueInvoiceNo,barcodeno,DispatchStatus,ReceiveDate,DispatchOption,CourierName,AWBNumber,NoofBox,TotalWeight,ConsignmentNote,Temperature,FieldBoyID,FieldBoyName,OtherName,DeliveryDate,DeliveryByUserID,DeliveryByUserName) values (" + stockid + "," + itemid + ",'" + indentno + "'," + Util.GetFloat(issueqty) + "," + Util.GetFloat(issueqty) + ",now()," + UserInfo.ID + ",'" + batchno + "','" + dtResult.Rows[0]["BarcodeNo"].ToString() + "','3',now(),'" + DispatchOption + "','"+CourierName+"','"+AWBNumber+"','"+NoofBox+"','"+TotalWeight+"','"+ConsignmentNote+"','"+Temperature+"','"+FieldBoyID+"','"+FieldBoyName+"','"+OtherName+"','"+Util.GetDateTime(DispatchDate).ToString("yyyy-MM-dd")+"','"+UserInfo.ID+"','"+UserInfo.LoginName+"')");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                   



                    StoreNMStock ststock = new StoreNMStock(tnx);

                    ststock.ItemID = Util.GetInt(dtResult.Rows[0]["ItemID"].ToString());
                    ststock.ItemName = Util.GetString(dtResult.Rows[0]["ItemName"].ToString());
                    ststock.LedgerTransactionID = 0;
                    ststock.LedgerTransactionNo = "";
                    ststock.BatchNumber = Util.GetString(dtResult.Rows[0]["BatchNumber"].ToString());

                    ststock.Rate = Util.GetFloat(dtResult.Rows[0]["Rate"].ToString());
                    ststock.DiscountPer = Util.GetFloat(dtResult.Rows[0]["DiscountPer"].ToString());
                    ststock.DiscountAmount = Util.GetFloat(dtResult.Rows[0]["DiscountAmount"].ToString());
                    ststock.TaxPer = Util.GetFloat(dtResult.Rows[0]["TaxPer"].ToString());
                    ststock.TaxAmount = Util.GetFloat(dtResult.Rows[0]["TaxAmount"].ToString());
                    ststock.UnitPrice = Util.GetFloat(dtResult.Rows[0]["UnitPrice"].ToString());
                    ststock.MRP = Util.GetFloat(dtResult.Rows[0]["MRP"].ToString());
                    ststock.InitialCount = Util.GetFloat(issueqty);
                    ststock.ReleasedCount = Util.GetFloat(issueqty);
                    ststock.PendingQty = 0;
                    ststock.RejectQty = 0;


                    ststock.ExpiryDate = Util.GetDateTime(dtResult.Rows[0]["ExpiryDate"].ToString());


                    ststock.Naration = Util.GetString(narration);
                    ststock.IsFree = Util.GetInt(dtResult.Rows[0]["IsFree"].ToString());

                    ststock.LocationID = Util.GetInt(fromlocation);
                    ststock.Panel_Id = Util.GetInt(frompanel);

                    ststock.IndentNo = indentno;
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
                    ststock.Remarks = "Direct Issue and Consume";
                    ststock.BarcodeNo = Util.GetString(dtResult.Rows[0]["BarcodeNo"].ToString());
                    ststock.IsPost = 1;
                    ststock.PostDate = DateTime.Now;
                    ststock.PostUserID = UserInfo.ID.ToString();
                    
                    ststock.IsExpirable = Util.GetInt(dtResult.Rows[0]["IsExpirable"].ToString());
                    ststock.IssueMultiplier = Util.GetInt(dtResult.Rows[0]["IssueMultiplier"].ToString());
                    ststock.PackSize = Util.GetString(dtResult.Rows[0]["PackSize"].ToString());



                    ststock.BarcodeOption =Util.GetInt(dtResult.Rows[0]["BarcodeOption"].ToString());
                    ststock.BarcodeGenrationOption = Util.GetInt(dtResult.Rows[0]["BarcodeGenrationOption"].ToString());
                    ststock.IssueInFIFO = Util.GetInt(dtResult.Rows[0]["IssueInFIFO"].ToString());

                    ststock.MajorUnitInDecimal = Util.GetInt(dtResult.Rows[0]["MajorUnitInDecimal"].ToString()); 
                    ststock.MinorUnitInDecimal = Util.GetInt(dtResult.Rows[0]["MinorUnitInDecimal"].ToString()); 
                    
                    string stockidsaved = ststock.Insert();
                    stockidsavedto += stockidsaved + ",";
                    if (stockidsaved == string.Empty)
                    {
                        tnx.Rollback();


                        return "0#Stock No Saved";
                    }




                    string fromstateid = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, @"SELECT cm.stateid FROM f_panel_master pm 
INNER JOIN centre_master cm ON cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' THEN pm.`CentreID` 
ELSE pm.tagprocessinglabid END AND pm.`PanelType` IN('Centre','PUP') AND cm.isactive=1 
WHERE pm.`Panel_ID`='" + Util.GetString(dtResult.Rows[0]["Panel_Id"]) + "'").ToString();

                    string tostateid = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, @"SELECT cm.stateid FROM f_panel_master pm 
INNER JOIN centre_master cm ON cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' THEN pm.`CentreID` 
ELSE pm.tagprocessinglabid END AND pm.`PanelType` IN('Centre','PUP') AND cm.isactive=1 
WHERE pm.`Panel_ID`='" + Util.GetInt(frompanel) + "'").ToString();


                    float totalgstper = Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, @"SELECT SUM(percentage) FROM st_taxchargedlist where stockid='" + stockid + "' and itemid='" + itemid + "' "));

                    // case 1 if both state is same CGST and SGST is Apply



                    if (fromstateid == tostateid)
                    {

                        StoreTaxChargedList objTCharged = new StoreTaxChargedList(tnx);
                        objTCharged.LedgerTransactionNo = "";
                        objTCharged.LedgerTransactionID = 0;
                        objTCharged.ItemID = Util.GetInt(itemid);
                        objTCharged.TaxName = "CGST";
                        objTCharged.Percentage = totalgstper / 2;
                        objTCharged.TaxAmt = Util.GetFloat(dtResult.Rows[0]["TaxAmount"].ToString()) / 2;
                        objTCharged.StockID = Util.GetInt(stockidsaved);

                        string TaxChrgID = objTCharged.Insert();

                        if (TaxChrgID == string.Empty)
                        {
                            tnx.Rollback();
                            return "Tax Not Saved";
                        }

                        objTCharged = new StoreTaxChargedList(tnx);
                        objTCharged.LedgerTransactionNo = "";
                        objTCharged.LedgerTransactionID = 0;
                        objTCharged.ItemID = Util.GetInt(itemid);
                        objTCharged.TaxName = "SGST";
                        objTCharged.Percentage = totalgstper / 2;
                        objTCharged.TaxAmt = Util.GetFloat(dtResult.Rows[0]["TaxAmount"].ToString()) / 2;
                        objTCharged.StockID = Util.GetInt(stockidsaved);

                        string TaxChrgID1 = objTCharged.Insert();

                        if (TaxChrgID1 == string.Empty)
                        {
                            tnx.Rollback();
                            return "Tax Not Saved";
                        }


                    }

                    // case 2 if both state is diffrent IGST is Apply
                    else
                    {

                        StoreTaxChargedList objTCharged = new StoreTaxChargedList(tnx);
                        objTCharged.LedgerTransactionNo = "";
                        objTCharged.LedgerTransactionID = 0;
                        objTCharged.ItemID = Util.GetInt(itemid);
                        objTCharged.TaxName = "IGST";
                        objTCharged.Percentage = totalgstper;
                        objTCharged.TaxAmt = Util.GetFloat(dtResult.Rows[0]["TaxAmount"].ToString());
                        objTCharged.StockID = Util.GetInt(stockidsaved);

                        string TaxChrgID = objTCharged.Insert();

                        if (TaxChrgID == string.Empty)
                        {
                            tnx.Rollback();
                            return "Tax Not Saved";
                        }
                    }


                    int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_getsalesno(2)"));
                    StoreSalesDetail objnssaled = new StoreSalesDetail(tnx);
                    objnssaled.FromLocationID = Util.GetInt(dtResult.Rows[0]["LocationID"].ToString());
                    objnssaled.ToLocationID = Util.GetInt(fromlocation);
                    objnssaled.StockID = Util.GetInt(Util.GetInt(dtResult.Rows[0]["StockID"].ToString()));
                    objnssaled.Quantity = Util.GetFloat(issueqty);
                    objnssaled.TrasactionTypeID = 2;
                    objnssaled.ItemID = Util.GetInt(itemid);
                    objnssaled.TrasactionType = "Issue";
                    objnssaled.IndentNo = indentno;
                    objnssaled.Naration = narration;
                    objnssaled.IssueType = "Direct Issue";
                    objnssaled.SalesNo = SalesNo;
                    string saledid = objnssaled.Insert();
                    if (saledid == string.Empty)
                    {
                        tnx.Rollback();
                        return "0#Sales Not Saved";
                    }

                    //Consume Entry
                    int SalesNo1 = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_getsalesno(1)"));
                    objnssaled = new StoreSalesDetail(tnx);
                    objnssaled.FromLocationID = Util.GetInt(fromlocation);
                    objnssaled.ToLocationID = Util.GetInt(fromlocation);
                    objnssaled.StockID = Util.GetInt(stockidsaved);
                    objnssaled.Quantity = Util.GetFloat(issueqty);
                    objnssaled.TrasactionTypeID = 1;
                    objnssaled.ItemID = Util.GetInt(itemid);
                    objnssaled.TrasactionType = "Consume";
                    objnssaled.IndentNo = indentno;
                    objnssaled.Naration = narration;
                    objnssaled.SalesNo = SalesNo1;
                    string saledid1 = objnssaled.Insert();
                    if (saledid1 == string.Empty)
                    {
                        tnx.Rollback();
                        return "0#Sales Not Saved";
                    }
                   
                }
                else
                {
                    tnx.Rollback();
                    return "0#Stock Unavailable";
                }
            }
            tnx.Commit();
            return "1#" + batchno;
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

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchItem(string itemname, string locationidfrom, string locationidto, string itemcate)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT si.`ItemIDGroup`,sig.`ItemNameGroup` ");
        sb.Append(" FROM st_itemmaster si     ");
        sb.Append(" INNER JOIN `st_itemmaster_group` sig ON sig.`ItemIDGroup`=si.`ItemIDGroup` ");
        sb.Append(" INNER JOIN st_nmstock smm ON smm.`ItemId`=si.`ItemID`    ");
        sb.Append(" AND smm.`LocationId` IN (" + locationidfrom.Split('#')[0] + ")  ");
        sb.Append(" and si.categorytypeid='" + itemcate + "' ");
        //sb.Append(" INNER JOIN st_mappingitemmaster smm1 ON smm1.`ItemId`=si.`ItemID`   ");
        //sb.Append(" AND smm1.`LocationId` in (" + locationidto.Split('#')[0] + ") ");


        sb.Append(" AND typename LIKE '" + itemname + "%'  ");
        sb.Append(" WHERE (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1 and  si.approvalstatus=2 GROUP BY sig.`ItemIDGroup` ORDER BY sig.`ItemNameGroup` LIMIT 20   ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindManufacturer(string locationidfrom,string locationidto, string ItemIDGroup)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT si.`ManufactureID`,si.`ManufactureName`   ");
        sb.Append("  FROM st_itemmaster si      ");
        sb.Append(" INNER JOIN st_nmstock smm ON smm.`ItemId`=si.`ItemID`   ");
        sb.Append("  AND smm.`LocationId` in( " + locationidfrom + ")  ");
        sb.Append(" AND si.`ItemIDGroup`  = '" + ItemIDGroup + "' ");
        //sb.Append(" INNER JOIN st_mappingitemmaster smm1 ON smm1.`ItemId`=si.`ItemID`   ");
        //sb.Append(" AND smm1.`LocationId` in (" + locationidto + ") ");


        
        sb.Append(" WHERE (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1 and si.approvalstatus=2  ");
        sb.Append(" GROUP BY si.`ManufactureID` ");
        sb.Append(" ORDER BY si.`ManufactureName` ; ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindMachine(string locationidfrom,string locationidto, string ItemIDGroup, string ManufactureID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("    SELECT si.`MachineID`,si.`MachineName`     ");
        sb.Append(" FROM st_itemmaster si       ");
        sb.Append(" INNER JOIN st_nmstock smm ON smm.`ItemId`=si.`ItemID`    ");
        sb.Append(" AND smm.`LocationId` in( " + locationidfrom+ ")    ");
        sb.Append(" AND si.`ItemIDGroup`  = '" + ItemIDGroup + "' AND smm.`ManufactureID`='" + ManufactureID + "'  ");

        //sb.Append(" INNER JOIN st_mappingitemmaster smm1 ON smm1.`ItemId`=si.`ItemID`   ");
        //sb.Append(" AND smm1.`LocationId` in (" + locationidto + ") ");


     
        sb.Append(" WHERE (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1 and si.approvalstatus=2  ");
        sb.Append("  GROUP BY si.`MachineID`  ");
        sb.Append("  ORDER BY si.`MachineName` ;  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindPackSize(string locationidfrom,string locationidto, string ItemIDGroup, string ManufactureID, string MachineID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT si.`PackSize`, concat(si.`IssueMultiplier`,'#',si.`MinorUnitName`,'#',si.`ItemID`)PackValue  ");
        sb.Append(" FROM st_itemmaster si       ");
        sb.Append("  INNER JOIN st_nmstock smm ON smm.`ItemId`=si.`ItemID`    ");
        sb.Append(" AND smm.`LocationId` in( " + locationidfrom + ")    ");

        sb.Append(" AND si.`ItemIDGroup`  = '" + ItemIDGroup + "' AND smm.`ManufactureID`='" + ManufactureID + "' AND si.`MachineID`='" + MachineID + "'  ");

        //sb.Append(" INNER JOIN st_mappingitemmaster smm1 ON smm1.`ItemId`=si.`ItemID`   ");
        //sb.Append(" AND smm1.`LocationId` in (" + locationidto + ") ");

        sb.Append(" WHERE (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1 and si.approvalstatus=2  ");
        sb.Append(" GROUP BY si.`PackSize`  ");
        sb.Append(" ORDER BY si.`PackSize` ;  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
}
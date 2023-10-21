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

public partial class Design_Store_DirectStockTransfer : System.Web.UI.Page
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

            ddlissuelocation.Items.Insert(0, new ListItem("Select Transfer To Location", "0"));
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
        sb.Append("  AND IndentType='DirectStockTransfer' AND  sl.isactive=1  ");


        sb.Append(" inner join f_panel_master pm on pm.panel_id=sl.panel_id INNER JOIN centre_master cm on cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' then pm.`CentreID` else pm.tagprocessinglabid END AND pm.`PanelType` in('Centre','PUP')   and pm.IsActive=1 ");
        if (ZoneId != "")
            sb.Append(" AND cm.BusinessZoneID IN(" + ZoneId + ")");

        if (StateID != "")
            sb.Append(" AND cm.StateID IN(" + StateID + ")");


        if (TypeId != "")
            sb.Append(" AND cm.Type1Id IN(" + TypeId + ")");

        if (panelid != "0" && panelid != "null" && panelid != string.Empty)
            sb.Append(" AND pm.panel_id IN(" + panelid + ")");

        sb.Append("  ORDER BY location  ");


        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchItemDetail(string itemid, string location, string barcodeno)
    {
        StringBuilder sb = new StringBuilder();


        sb.Append("    SELECT ss.barcodeno, ss.MinorUnitInDecimal,ss.itemid,itemname,ss.stockid,ss.locationid,ss.batchnumber,im.IssueMultiplier,  ");
        sb.Append("    IF(`ExpiryDate`='0001-01-01','',DATE_FORMAT(ExpiryDate,'%d-%b-%Y')) ExpiryDate,  ");
        sb.Append("    (`InitialCount` - `ReleasedCount`-PendingQty) AvilableQty,ss.MinorUnit,ss.UnitPrice   ");
        sb.Append("    FROM st_nmstock ss inner join st_itemmaster im on im.itemid=ss.itemid  WHERE ispost=1  AND (`InitialCount` - `ReleasedCount`-PendingQty)>0    ");
        
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
    public static string savedirectstocktransfer(List<string> datatosave, string narration)
    {
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

           









                StringBuilder sb = new StringBuilder();
                sb.Append("   SELECT StockID,ItemID,ItemName,Rate,DiscountPer,DiscountAmount,TaxPer,TaxAmount,UnitPrice,MRP ");
                sb.Append("  ,MinorUnitID,MinorUnit,");
                sb.Append("   UnitPrice,MRP,ExpiryDate ,LocationID,Panel_Id,BarcodeNo");

                sb.Append(" , IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=st.stockid   AND taxname='IGST') ,'') IGSTPer,");
                sb.Append(" IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=st.stockid   AND taxname='CGST') ,'') CGSTPer,");
                sb.Append(" IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=st.stockid   AND taxname='SGST') ,'') SGSTPer ");


                sb.Append("   ");
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
                    objindent.Narration = "Direct Stock Transfer";
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

                    //var NetAmount = ratetaxincludetax * Util.GetFloat(objindent.ReqQty);


                    // Update Indent Table
                    string strUpdateindent = "update st_indent_detail set UnitPrice=" + ratetaxincludetax + ", NetAmount=UnitPrice*ReqQty, ApprovedQty = ReqQty,CheckedQty=ReqQty,ApprovedDate=NOW(),ApprovedUserID=" + UserInfo.ID + " ,ApprovedUserName='" + UserInfo.LoginName + "',CheckedDate=NOW(),CheckedUserID=" + UserInfo.ID + ",CheckedUserName='" + UserInfo.LoginName + "',PendingQty = PendingQty +" + Util.GetFloat(issueqty) + ",IssueDate=now(),IssueBy='" + UserInfo.LoginName + "',IssueByID='" + UserInfo.ID + "' ,ActionType='Approval' where IndentNo = '" + indentno + "' and itemid='" + objindent.ItemId + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateindent);



                    if (Util.GetInt(frompanel) == Util.GetInt(dtResult.Rows[0]["Panel_Id"]))
                    {
                        sb = new StringBuilder();
                        sb.Append(" insert into st_indentissuedetail (StockID,ItemID,IndentNo,SendQty,ReceiveQty,DATETIME,UserID,IssueInvoiceNo,barcodeno,DispatchStatus,ReceiveDate) values (" + stockid + "," + itemid + ",'" + indentno + "'," + Util.GetFloat(issueqty) + ",0,now()," + UserInfo.ID + ",'" + batchno + "','" + dtResult.Rows[0]["BarcodeNo"].ToString() + "','3',now())");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                    }
                    else
                    {
                        sb = new StringBuilder();
                        sb.Append(" insert into st_indentissuedetail (StockID,ItemID,IndentNo,SendQty,ReceiveQty,DATETIME,UserID,IssueInvoiceNo,barcodeno,DispatchStatus) values (" + stockid + "," + itemid + ",'" + indentno + "'," + Util.GetFloat(issueqty) + ",0,now()," + UserInfo.ID + ",'" + batchno + "','" + dtResult.Rows[0]["BarcodeNo"].ToString() + "','0')");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                    }

                  
                    

                    string strUpdateStock = "update st_nmstock set PendingQty = PendingQty + " + Util.GetFloat(issueqty) + " where StockID = '" + stockid + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock);


                    // Sales Detail InTransitIssue


                    int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_getsalesno(8)"));
                    StoreSalesDetail objnssaled = new StoreSalesDetail(tnx);
                    objnssaled.FromLocationID = Util.GetInt(dtResult.Rows[0]["LocationID"].ToString());
                    objnssaled.ToLocationID = Util.GetInt(fromlocation);
                    objnssaled.StockID = Util.GetInt(stockid);
                    objnssaled.Quantity = Util.GetFloat(issueqty);
                    objnssaled.TrasactionTypeID = 8;
                    objnssaled.ItemID = Util.GetInt(itemid);
                    objnssaled.TrasactionType = "InTransitIssue";
                    objnssaled.IndentNo = indentno;
                    objnssaled.Naration = narration;
                    objnssaled.SalesNo = SalesNo;
                    string saledid = objnssaled.Insert();
                    if (saledid == string.Empty)
                    {
                        tnx.Rollback();
                        return "0#Sales Not Saved";
                    }

                    // Send Email To Centre Manager 

                    DataTable EmailID = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, @"SELECT sl.`Location`,cm.`Email` FROM st_locationmaster sl INNER JOIN f_panel_master pm ON pm.`panel_id`=sl.`panel_id` and sl.LocationID='" + fromlocation + "' INNER JOIN centre_master cm ON cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' THEN pm.`CentreID` ELSE pm.tagprocessinglabid END AND pm.`PanelType` IN('Centre','PUP') AND cm.isactive=1 ").Tables[0];
                    if (EmailID.Rows.Count > 0)
                    {
                        if (EmailID.Rows[0]["Email"].ToString() != string.Empty)
                        {

                            sb = new StringBuilder();
                            sb.Append("<div> Dear Centre Manager of <b>" + EmailID.Rows[0]["Location"].ToString() + "</b> </div>");
                            sb.Append("<br/>");
                            sb.Append(" Greetings from Apollo Health and Lifestyle Limited");
                            sb.Append("<br/>"); sb.Append("<br/>");
                            sb.Append("Direct Stock Transferd With Following Detail");
                            sb.Append("<br/>");
                            sb.Append("Reference No: <b>" + indentno + "</b>  <br/>Batch No: <b>" + batchno + "</b>  <br/>Transfer By: " + UserInfo.LoginName + " at: " + DateTime.Now.ToString("dd-MM-yyyy hh:mm"));
                            sb.Append("<br/><br/><br/><br/>");

                            sb.Append("Thanks & Regards,");
                            sb.Append("<br/>");
                            sb.Append("Apollo Health And Lifestyle Limited.");
                            sb.Append("<br/>");

                            ReportEmailClass REmail = new ReportEmailClass();
                            string IsSend = "0";
                          //  IsSend = REmail.sendstoreemail(EmailID.Rows[0]["Email"].ToString(), "Direct Stock Transfer", sb.ToString(), null, "", "", null, "", DateTime.Now.ToString("yyyy-MM-dd"));
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO st_emailrecord(TransactionID,UserID,IsSend,Remarks,EmailID,MailedTo)VALUES(@TransactionID,@UserID,@IsSend,@Remarks,@EmailID,@MailedTo)",
                             new MySqlParameter("@TransactionID", indentno),
                             new MySqlParameter("@UserID", UserInfo.ID),
                             new MySqlParameter("@IsSend", IsSend),
                             new MySqlParameter("@Remarks", "Direct Stock Transfer"),
                             new MySqlParameter("@EmailID", EmailID.Rows[0]["Email"].ToString()),
                             new MySqlParameter("@MailedTo", "Centre Manager"));

                        }
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
    public static string SearchItem(string itemname, string locationidfrom, string locationidto,string itemcate)
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
    public static string bindManufacturer(string locationidfrom, string locationidto, string ItemIDGroup)
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
    public static string bindMachine(string locationidfrom, string locationidto, string ItemIDGroup, string ManufactureID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("    SELECT si.`MachineID`,si.`MachineName`     ");
        sb.Append(" FROM st_itemmaster si       ");
        sb.Append(" INNER JOIN st_nmstock smm ON smm.`ItemId`=si.`ItemID`    ");
        sb.Append(" AND smm.`LocationId` in( " + locationidfrom + ")    ");
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
    public static string bindPackSize(string locationidfrom, string locationidto, string ItemIDGroup, string ManufactureID, string MachineID)
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
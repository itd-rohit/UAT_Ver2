using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_DirectPO : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlcategorytype.DataSource = StockReports.GetDataTable("SELECT `CategoryTypeID` ID,`CategoryTypeName` Name FROM st_categorytypemaster where active=1 ORDER BY CategoryTypeName desc");
            ddlcategorytype.DataValueField = "ID";
            ddlcategorytype.DataTextField = "Name";
            ddlcategorytype.DataBind();
            bindSupplier();
            bindCentreState();
            DataTable dt = accessRight();
            if (dt.Rows.Count == 0)
            {
                lblError.Text = "You do not have right to access this page";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "accessRight();", true);
                return;
            }
            else
            {
                int MakerCount = dt.AsEnumerable().Count(row => "Maker" == row.Field<String>("TypeName"));

            }
        }
    }

    public void bindSupplier()
    {
        ddlsupplier.DataSource = StockReports.GetDataTable("SELECT SupplierID,SupplierName FROM st_vendormaster WHERE `ApprovalStatus`=2 AND isActive=1   ORDER BY supplierName");
        ddlsupplier.DataValueField = "SupplierID";
        ddlsupplier.DataTextField = "SupplierName";
        ddlsupplier.DataBind();
        ddlsupplier.Items.Insert(0, new ListItem("Select","0"));
    }
    private DataTable accessRight()
    {
        return StockReports.GetDataTable("SELECT TypeName FROM st_approvalright WHERE TypeID=1 AND AppRightFor='PO' AND EmployeeID='" + UserInfo.ID + "' AND Active=1 ");
    }
    [WebMethod(EnableSession = true)]
    public static string setPOData(string POID)
    {

        StringBuilder sb = new StringBuilder();



        sb.Append(" SELECT sm11.categorytypename,sm11.categorytypeID, if(po.IsEdited=1,'Amended','') re, if(po.IsEdited=1,concat('Amended Date :',DATE_FORMAT(po.LastEditDate,'%d-%b-%y'),'<br/>Amended By :',po.LastEditByName),'')remsg, ifnull(po.Warranty,'')Warranty,ifnull(po.NFANo,'')NFANo,ifnull(po.TermandCondition,'')TermandCondition, itemcat.Name ItemCategory,pod.ItemName,sm.hsncode,pod.ManufactureName,pod.catalogno,pod.MachineName ,pod.MajorUnitName,pod.PackSize,");
        sb.Append(" pod.Rate,pod.DiscountPercentage DiscountPer,IFNULL(pot.IGSTTax,0) IGSTPer,IFNULL(pot.CGSTTax,0) CGSTPer,IFNULL(pot.SGSTax,0) SGSTPer,");
        sb.Append(" pod.NetAmount,pod.UnitPrice ,itemcat.SubCategoryID ItemTypeID,pod.Itemid,pod.ManufactureID,pod.MachineID,pod.MajorUnitId, ");
        sb.Append(" po.VendorID,po.VendorAddress,po.VendorName,po.VendorLogin IsLoginRequired,po.VendorStateId,po.VendorGSTIN VednorStateGstnno,pod.DiscountAmount DiscountAmt,");
        sb.Append(" po.PurchaseOrderID,po.PurchaseOrderNo,po.ActionType,po.LocationID DeliveryLocationID ,");
        sb.Append(" SUM(IF(pod.IsFree=0,CASE WHEN po.Status=0 THEN pod.OrderedQty WHEN po.Status=1 THEN pod.CheckedQty ELSE pod.ApprovedQty END,0))OrderedQty, ");
        sb.Append(" SUM(IF(pod.IsFree=1,CASE WHEN po.Status=0 THEN pod.OrderedQty WHEN po.Status=1 THEN pod.CheckedQty ELSE pod.ApprovedQty END,0))FreeQty , ");
        sb.Append(" pod.IsFree,pod.TaxAmount  ");
        sb.Append("   ");
        sb.Append(" FROM st_purchaseorder po INNER JOIN st_purchaseorder_details pod ON po.PurchaseOrderID=pod.PurchaseOrderID AND pod.IsActive=1 ");
        sb.Append(" INNER JOIN st_itemmaster sm ON sm.ItemID=pod.ItemID ");
        sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID  ");
        sb.Append(" INNER JOIN st_categorytypemaster sm11 ON sm11.categorytypeID=sm.categorytypeID   ");
        sb.Append(" LEFT JOIN   ");

        sb.Append("  (  SELECT pot.ItemID ,  SUM(IF(pot.TaxName='IGST',IFNULL(pot.Percentage,0),0))IGSTTax,");
        sb.Append(" SUM(IF(pot.TaxName='CGST',(pot.Percentage),0))CGSTTax,SUM(IF(pot.TaxName='SGST',(pot.Percentage),0))SGSTax");
        sb.Append(" FROM  st_purchaseorder_tax pot WHERE pot.PurchaseOrderID='" + POID + "' GROUP BY ItemID )pot     ON  pot.ItemID=pod.ItemID  ");
        sb.Append(" WHERE po.PurchaseOrderID='" + POID + "'   GROUP BY po.PurchaseOrderID,pod.ItemID ");
        sb.Append(" ");

        sb.Append("  ");

        return Util.getJson(StockReports.GetDataTable(sb.ToString()));



    }
    [WebMethod(EnableSession = true)]
    public static string bindPODLocation(string LocationID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.centreid,CONCAT(cm.centre,' ~ ',cm.centrecode)centre,loc.Location,loc.LocationID,cm.State,cm.StateID ");
        sb.Append(" FROM f_panel_master fpm INNER JOIN  centre_master cm ON fpm.CentreID=cm.CentreID  ");
        sb.Append(" INNER JOIN st_locationmaster  loc ON loc.Panel_ID=fpm.Panel_ID WHERE loc.LocationID='" + LocationID + "' ");
        sb.Append(" ");
        return Util.getJson(StockReports.GetDataTable(sb.ToString()));

    }
    [WebMethod(EnableSession = true)]
    public static string bindPOTermCondtion(string PurchaseOrderID)
    {
        return Util.getJson(StockReports.GetDataTable(" SELECT TermConditionID,TermCondition,deliverytermid,deliveryterm  FROM st_purchaseorder_termsandconditions WHERE IsActive=1 AND PurchaseOrderID='" + PurchaseOrderID + "' "));

    }
    [WebMethod(EnableSession = true)]
    public static string bindSupplier(string SupplierName)
    {
        return Util.getJson(StockReports.GetDataTable("SELECT SupplierID,SupplierName FROM st_vendormaster WHERE `ApprovalStatus`=2 AND isActive=1  AND SupplierName LIKE '" + SupplierName + "%' ORDER BY supplierName"));
    }
    private void bindCentreState()
    {

        ddlCentreState.DataSource = StockReports.GetDataTable("SELECT  ID,State Name FROM state_master where IsActive=1 ORDER BY State");
        ddlCentreState.DataValueField = "ID";
        ddlCentreState.DataTextField = "Name";
        ddlCentreState.DataBind();
        ddlCentreState.Items.Insert(0, new ListItem("Select", "0"));
    }
    [WebMethod(EnableSession = true)]
    public static string bindLocation(string CentreID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lm.LocationID,Location FROM st_locationmaster lm  ");



        sb.Append(" WHERE lm.IsActive=1 and lm.panel_id='" + CentreID + "'  ORDER BY lm.Location");

		//System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\loca.txt",sb.ToString());



      
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]

    public static string SearchItem(string itemname, string locationidfrom, string searchoption)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT si.`ItemIDGroup` ItemID,sig.`ItemNameGroup` ItemName");
        sb.Append(" FROM st_itemmaster si     ");
        sb.Append(" INNER JOIN `st_itemmaster_group` sig ON sig.`ItemIDGroup`=si.`ItemIDGroup` ");
        sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`    ");
        sb.Append(" AND smm.`LocationId` IN (" + locationidfrom.Split('#')[0] + ")  ");

        if (searchoption == "0")
        {
            sb.Append(" AND typename LIKE '" + itemname + "%'  ");
        }
        else if (searchoption == "1")
        {
            sb.Append(" AND typename LIKE '%" + itemname + "%'  ");
        }
        else
        {
            sb.Append(" AND apolloitemcode LIKE '%" + itemname + "%'  ");
        }

        //sb.Append(" AND typename LIKE '%" + itemname + "%'  ");

        sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2   ");

        sb.Append(" GROUP BY sig.`ItemIDGroup` ORDER BY sig.`ItemNameGroup` LIMIT 20  ");

		//System.IO.File.WriteAllText(@"C:\itdose\Livecode\Droplet_Live_New\Droplet\Design\Store\searchitem.txt",sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
	
	
	
    [WebMethod]
    public static string getItemDetailtoAdd(string ItemID, string SupplierID, string DeliveryLocationID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sm11.categorytypename,sm11.categorytypeID, itemcat.SubCategoryID ItemTypeID,itemcat.Name ItemCategory,sm.typename ItemName,sm.hsncode, sm.Itemid,venq.ManufactureID,venq.ManufactureName, ");
        sb.Append(" sm.catalogno,venq.MachineID,venq.MachineName,MajorUnitId,MajorUnitName,Converter  PackSize,MinorUnitId,MinorUnitName,sm.gstntax, ");
        sb.Append(" venq.Rate,venq.Qty,venq.DiscountPer,venq.IGSTPer,venq.SGSTPer,venq.CGSTPer,venq.BuyPrice,sm.MajorUnitInDecimal,venq.VendorID,venq.VendorAddress,venq.VendorName, ");
        sb.Append(" ven.IsLoginRequired,venq.DeliveryLocationID,venq.VendorStateId,venq.VednorStateGstnno,venq.DiscountAmt ");
        sb.Append("  FROM st_itemmaster sm  ");
        sb.Append(" INNER JOIN `st_vendorqutation` venq ON venq.`ItemID`=sm.`ItemID` AND venq.isactive=1 AND venq.approvalstatus=2 AND venq.ComparisonStatus=1 and EntryDateTo>=date(now()) ");
        sb.Append(" INNER JOIN st_vendormaster ven ON ven.supplierID=venq.VendorID ");
        sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID  ");
        sb.Append(" INNER JOIN st_categorytypemaster sm11 ON sm11.categorytypeID=sm.categorytypeID   ");
        sb.Append(" where venq.itemid='" + ItemID + "' AND venq.VendorID='" + SupplierID + "' AND venq.DeliveryLocationID='" + DeliveryLocationID + "'");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public static string savePurchaseOrder(List<PurchaseOrder> POMaster, string term, string deliveryterm, int termID, int deliverytermID) 
    {
        var POData = POMaster.Where(s => string.IsNullOrWhiteSpace(Util.GetString(s.OrderedQty)) || Util.GetDecimal(s.OrderedQty) == 0).ToList();
        if (POData.Count > 0)
        {
            var oSerializer = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(new { QtyValidation = POData.Select(s => s.tableSNo) });
            return oSerializer;
        }
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    if (POMaster.Count > 0)
                    {
                        if (POMaster[0].PurchaseOrderNo == string.Empty)
                        {
                            string PurchaseOrderNo = string.Empty;
                            PurchaseOrderMaster POM = new PurchaseOrderMaster(Tnx);
                            PurchaseOrderNo = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "Select store_get_po_number()"));
                            if (PurchaseOrderNo == string.Empty)
                            {
                                return "2";
                            }
                            POM.PurchaseOrderNo = PurchaseOrderNo;
                            POM.Subject = POMaster[0].Subject;
                            POM.VendorID = POMaster[0].VendorID;
                            POM.VendorName = POMaster[0].VendorName;
                            POM.CreatedByID = UserInfo.ID;
                            POM.CreatedByName = UserInfo.LoginName;
                            POM.Status = 0;
                            POM.StatusName = "Maker";
                            POM.LocationID = POMaster[0].LocationID;
                            POM.IndentNo = POMaster[0].IndentNo;
                            POM.VendorStateId = POMaster[0].VendorStateId;
                            POM.VendorGSTIN = POMaster[0].VendorGSTIN;
                            POM.VendorAddress = POMaster[0].VendorAddress;
                            POM.VendorLogin = POMaster[0].VendorLogin;
                            POM.POType = POMaster[0].POType;
                            POM.IsDirectPO = 1;
                            POM.ActionType = "Maker";
                            POM.Warranty = POMaster[0].Warranty;
                            POM.NFANo = POMaster[0].NFANo;
                            POM.Termandcondition = POMaster[0].Termandcondition;
                            int PurchaseOrderID = POM.Insert();
                            if (PurchaseOrderID == 0)
                            {
                                return "0";
                            }
                            for (int i = 0; i < POMaster.Count; i++)
                            {
                                string PurchaseOrderDetail = savePurchaseOrderDetail(POMaster[i], Tnx, Util.GetInt(PurchaseOrderID), PurchaseOrderNo, POMaster[0].ActionType);

                                if (PurchaseOrderDetail != "1")
                                {
                                    Tnx.Rollback();
                                    return "0";
                                }
                            }
                            //if (POTermCondition.Count > 0)
                            //{
                            //    for (int i = 0; i < POTermCondition.Count; i++)
                            //    {
                            PurchaseOrderTermsAndConditions POT = new PurchaseOrderTermsAndConditions(Tnx);
                            POT.PurchaseOrderID = PurchaseOrderID;
                            POT.PurchaseOrderNo = PurchaseOrderNo;
                            POT.POTermsCondition = term;
                            POT.CreatedByID = UserInfo.ID;
                            POT.CreatedByName = UserInfo.LoginName;
                            POT.DeliveryTerm = deliveryterm;
                            POT.TermConditionID = termID;
                            POT.DeliveryTermID = deliverytermID;
                            POT.Insert();
                            //    }
                            //}

                            StringBuilder sb = new StringBuilder();
                            sb.Append(" UPDATE `st_purchaseorder` po ");
                            sb.Append("SET po.`GrossTotal` = ( SELECT ifnull(SUM(`Rate`*`OrderedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND pod.IsFree=0 AND IsActive=1), ");
                            sb.Append("po.`DiscountOnTotal`= ( SELECT ifnull(SUM(`DiscountAmount`*`OrderedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND pod.IsFree=0 AND IsActive=1), ");
                            sb.Append(" po.`TaxAmount`= ( SELECT ifnull(SUM(`TaxAmount`*`OrderedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND pod.IsFree=0 AND IsActive=1), ");
                            sb.Append(" po.`NetTotal`= ( SELECT ifnull(SUM(`NetAmount`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND pod.IsFree=0 AND IsActive=1) ");
                            sb.Append(" WHERE  po.`PurchaseOrderID`=@PurchaseOrderID ");

                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@PurchaseOrderID", PurchaseOrderID));


                            
                              sb = new StringBuilder();
                            sb.Append(@"
                                 SELECT sp.PurchaseOrderID,sp.PurchaseOrderNo,pnl.Company_Name PanelName
                                ,(SELECT SUBJECT FROM Email_configuration WHERE ID=3 AND IsActive=1) EmailSubject
                                ,(SELECT Template FROM Email_configuration WHERE ID=3 AND IsActive=1) EmailBody
                                ,(SELECT IsClient FROM Email_configuration WHERE ID=3 AND IsActive=1)  AllowToWhom,pnl.EmailIdReport
                                FROM st_purchaseorder sp
                                INNER JOIN st_ledgertransaction lt ON sp.PurchaseOrderNo=lt.PurchaseOrderNo
                                INNER JOIN st_locationmaster loc ON lt.LocationId=loc.LocationID
                                INNER JOIN f_panel_master pnl ON pnl.Panel_Id=loc.Panel_ID
                                INNER JOIN centre_master cm ON cm.CentreId=pnl.CentreId
                                WHERE sp.PurchaseOrderID=@PurchaseOrderID   AND cm.Type1Id IN ( 
                                SELECT ecc.Type1Id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsActivate=1 AND ec.ID=3 AND panel_Id=0  AND (ec.IsPatient=1 OR ec.IsClient=1)
                                ) 
                                AND pnl.Panel_Id NOT IN ( SELECT ecc.Panel_id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsDiscard=1 AND ec.ID=3 AND (ec.IsPatient=1 OR ec.IsClient=1))
                                UNION 
                                SELECT sp.PurchaseOrderID,sp.PurchaseOrderNo,pnl.Company_Name PanelName
                                ,(SELECT SUBJECT FROM Email_configuration WHERE ID=3 AND IsActive=1) EmailSubject
                                ,(SELECT Template FROM Email_configuration WHERE ID=3 AND IsActive=1) EmailBody
                                ,(SELECT IsClient FROM Email_configuration WHERE ID=3 AND IsActive=1)  AllowToWhom,pnl.EmailIdReport
                                FROM st_purchaseorder sp
                                INNER JOIN st_ledgertransaction lt ON sp.PurchaseOrderNo=lt.PurchaseOrderNo
                                INNER JOIN st_locationmaster loc ON lt.LocationId=loc.LocationID
                                INNER JOIN f_panel_master pnl ON pnl.Panel_Id=loc.Panel_ID
                                WHERE pnl.Panel_Id IN ( 
                                SELECT ecc.Panel_id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsActivate=1 AND ec.ID=3  AND ec.IsClient=1
                                ) AND sp.PurchaseOrderID=@PurchaseOrderID 
                            ");

                            using (DataTable dtEmail = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@PurchaseOrderID", PurchaseOrderID)).Tables[0])
                            {
                                if (dtEmail.Rows.Count > 0)
                                {

                                    string EmailSubject = string.Empty;
                                    StringBuilder EmailBody = new StringBuilder();
                                    EmailSubject = Util.GetString(dtEmail.Rows[0]["EmailSubject"]).Replace("{PurchaseOrderNo}", Util.GetString(dtEmail.Rows[0]["PurchaseOrderNo"]));
                                    EmailBody.Append(Util.GetString(dtEmail.Rows[0]["EmailBody"]));
                                    EmailBody.Replace("{PurchaseOrderNo}", Util.GetString(dtEmail.Rows[0]["PurchaseOrderNo"]));


                                    Store_AllLoadData sa = new Store_AllLoadData();
                                    string EmailID = sa.getApprovalRightEnail(con, "1", "PO");

                                    if (EmailID != string.Empty)
                                    {
                                        ReportEmailClass REmail = new ReportEmailClass();
                                        string IsSend = REmail.sendPanelInvoice(EmailID, EmailSubject, EmailBody.ToString(), null, "", "", null, "", DateTime.Now.ToString("yyyy-MM-dd"));
                                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO st_emailrecord(TransactionID,UserID,IsSend,Remarks,EmailID,MailedTo)VALUES(@TransactionID,@UserID,@IsSend,@Remarks,@EmailID,@MailedTo)",
                                         new MySqlParameter("@TransactionID", PurchaseOrderID), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@IsSend", IsSend),
                               new MySqlParameter("@Remarks", "User PO Mail"), new MySqlParameter("@EmailID", EmailID), new MySqlParameter("@MailedTo", "PO"));

                                    }
                                }
                            }
                        }
                        else
                        {
                            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ItemID FROM st_purchaseorder_details WHERE PurchaseOrderID=@PurchaseOrderID ",
                new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID)).Tables[0];
                            for (int i = 0; i < POMaster.Count; i++)
                            {
                                DataRow[] fountRow = dt.Select("ItemID = '" + POMaster[i].ItemID + "'");
                                if (fountRow.Length == 0)
                                {
                                    string PurchaseOrderDetail = savePurchaseOrderDetail(POMaster[i], Tnx, Util.GetInt(POMaster[0].PurchaseOrderID), POMaster[0].PurchaseOrderNo, POMaster[0].ActionType);

                                    if (PurchaseOrderDetail == "0")
                                    {
                                        Tnx.Rollback();
                                        return "0";
                                    }
                                }
                            }
                           
                            StringBuilder sb = new StringBuilder();
                            if (POMaster[0].ActionType == "Check")
                            {
                                sb = new StringBuilder();
                                sb.Append(" UPDATE `st_purchaseorder` po ");
                                sb.Append("SET po.`GrossTotal` = ( SELECT ifnull(SUM(`Rate`*`CheckedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                                sb.Append("po.`DiscountOnTotal`= ( SELECT ifnull(SUM(`DiscountAmount`*`CheckedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                                sb.Append(" po.`TaxAmount`= ( SELECT ifnull(SUM(`TaxAmount`*`CheckedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                                sb.Append(" po.`NetTotal`= ( SELECT ifnull(SUM(`NetAmount`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1) ");
                                sb.Append(" WHERE  po.`PurchaseOrderID`=@PurchaseOrderID ");

                                
                            }
                            else if (POMaster[0].ActionType == "Approval")
                            {
                                sb = new StringBuilder();
                                sb.Append(" UPDATE `st_purchaseorder` po ");
                                sb.Append("SET po.`GrossTotal` = ( SELECT ifnull(SUM(`Rate`*`ApprovedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                                sb.Append("po.`DiscountOnTotal`= ( SELECT ifnull(SUM(`DiscountAmount`*`ApprovedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                                sb.Append(" po.`TaxAmount`= ( SELECT ifnull(SUM(`TaxAmount`*`ApprovedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                                sb.Append(" po.`NetTotal`= ( SELECT ifnull(SUM(`NetAmount`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1) ");
                                sb.Append(" WHERE  po.`PurchaseOrderID`=@PurchaseOrderID ");

                                
                            }

                            else
                            {
                                sb = new StringBuilder();
                                sb.Append(" UPDATE `st_purchaseorder` po ");
                                sb.Append("SET po.`GrossTotal` = ( SELECT ifnull(SUM(`Rate`*`OrderedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                                sb.Append("po.`DiscountOnTotal`= ( SELECT ifnull(SUM(`DiscountAmount`*`OrderedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                                sb.Append(" po.`TaxAmount`= ( SELECT ifnull(SUM(`TaxAmount`*`OrderedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                                sb.Append(" po.`NetTotal`= ( SELECT ifnull(SUM(`NetAmount`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1) ");
                                sb.Append(" WHERE  po.`PurchaseOrderID`=@PurchaseOrderID ");

                               
                            }

                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                                   new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID));
                        }
                    }
                    Tnx.Commit();
                    return "1";
                }
                catch (Exception ex)
                {
                    Tnx.Rollback();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return "0";
                }
                finally
                {
                    con.Close();
                }
            }
        }
    }

    public static string savePurchaseOrderDetail(PurchaseOrder POD, MySqlTransaction Tnx, int PurchaseOrderID, string PurchaseOrderNo, string ActionType)
    {


        try
        {
            PurchaseOrderDetail objPOD = new PurchaseOrderDetail(Tnx);
            objPOD.PurchaseOrderID = PurchaseOrderID;
            objPOD.PurchaseOrderNo = PurchaseOrderNo;
            objPOD.ItemID = POD.ItemID;
            objPOD.ItemName = POD.ItemName;
            objPOD.ManufactureID = POD.ManufactureID;
            objPOD.ManufactureName = POD.ManufactureName;
            objPOD.CatalogNo = POD.CatalogNo;
            objPOD.MachineID = POD.MachineID;
            objPOD.MachineName = POD.MachineName;
            objPOD.MajorUnitId = POD.MajorUnitId;
            objPOD.MajorUnitName = POD.MajorUnitName;
            objPOD.PackSize = POD.PackSize;
            
             objPOD.OrderedQty = POD.OrderedQty;
             //objPOD.CheckedQty = POD.OrderedQty;
             //objPOD.ApprovedQty = POD.OrderedQty;
            
            // objPOD.CheckedQty = POMaster[i].OrderedQty;

            objPOD.DiscountPercentage = POD.DiscountPercentage;
            objPOD.IsFree = POD.IsFree;
            decimal discAmount = Util.GetDecimal(Util.GetDecimal(POD.Rate) * Util.GetDecimal(POD.DiscountPercentage) * Util.GetDecimal(0.01));
            if (POD.IsFree == 0)
            {
                var TaxPer = POD.TaxPerCGST + POD.TaxPerIGST + POD.TaxPerSGST;
                objPOD.Rate = POD.Rate; //
                decimal taxAmount = (Util.GetDecimal(POD.Rate) - discAmount) * Util.GetDecimal(TaxPer) * Util.GetDecimal(0.01);
                objPOD.TaxAmount = taxAmount;//
                objPOD.DiscountAmount = discAmount;//
                objPOD.UnitPrice = POD.UnitPrice;//
            }
            else
            {
                objPOD.Rate = 0; //
                objPOD.TaxAmount = 0; //
                objPOD.DiscountAmount = 0; //
                objPOD.UnitPrice = 0;//
            }
           
            if (POD.IsFree == 0)
                objPOD.NetAmount = POD.UnitPrice * POD.OrderedQty;//
            else
                objPOD.NetAmount = 0;

            int PurchaseOrderDetailID = objPOD.Insert();
            if (PurchaseOrderDetailID == 0)
            {
                return "0";
            }
            if ((Util.GetDecimal(POD.TaxPerCGST) > 0 || Util.GetDecimal(POD.TaxPerIGST) > 0 || Util.GetDecimal(POD.TaxPerSGST) > 0))
            {
                try
                {
                    PurchaseOrderTax objPOT = new PurchaseOrderTax(Tnx);
                    objPOT.PurchaseOrderID = PurchaseOrderID;
                    objPOT.PurchaseOrderNo = PurchaseOrderNo;
                    objPOT.CreatedBy = UserInfo.LoginName;
                    objPOT.CreatedByID = UserInfo.ID;
                    objPOT.ItemID = POD.ItemID;
                    if (Util.GetDecimal(POD.TaxPerCGST) > 0)
                    {
                        objPOT.TaxName = "CGST";
                        objPOT.Percentage = POD.TaxPerCGST;
                        decimal CGSTTaxAmount = (Util.GetDecimal(POD.Rate) - discAmount) * Util.GetDecimal(POD.TaxPerCGST) * Util.GetDecimal(0.01);
                        if (POD.IsFree == 0)
                        {
                            objPOT.TaxAmt = CGSTTaxAmount;//
                        }
                        else
                        {
                            objPOT.TaxAmt = 0;
                        }

                        if (Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT count(1) FROM `st_purchaseorder_tax` WHERE purchaseorderid=" + PurchaseOrderID + " AND itemid=" + POD.ItemID + " AND taxname='CGST'")) == 0)
                        {
                            objPOT.Insert();
                        }
                    }
                    if (Util.GetDecimal(POD.TaxPerIGST) > 0)
                    {
                        objPOT.TaxName = "IGST";
                        objPOT.Percentage = POD.TaxPerIGST;
                        decimal IGSTTaxAmount = (Util.GetDecimal(POD.Rate) - discAmount) * Util.GetDecimal(POD.TaxPerIGST) * Util.GetDecimal(0.01);
                       
                        if (POD.IsFree == 0)
                        {
                            objPOT.TaxAmt = IGSTTaxAmount;//
                        }
                        else
                        {
                            objPOT.TaxAmt = 0;
                        }
                        if (Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT count(1) FROM `st_purchaseorder_tax` WHERE purchaseorderid=" + PurchaseOrderID + " AND itemid=" + POD.ItemID + " AND taxname='IGST'")) == 0)
                        {
                            objPOT.Insert();
                        }
                    }
                    if (Util.GetDecimal(POD.TaxPerSGST) > 0)
                    {
                        objPOT.TaxName = "SGST";
                        objPOT.Percentage = POD.TaxPerSGST;
                        decimal SGSTTaxAmount = (Util.GetDecimal(POD.Rate) - discAmount) * Util.GetDecimal(POD.TaxPerSGST) * Util.GetDecimal(0.01);
                      
                        if (POD.IsFree == 0)
                        {
                            objPOT.TaxAmt = SGSTTaxAmount;//
                        }
                        else
                        {
                            objPOT.TaxAmt = 0;
                        }
                        if (Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT count(1) FROM `st_purchaseorder_tax` WHERE purchaseorderid=" + PurchaseOrderID + " AND itemid=" + POD.ItemID + " AND taxname='SGST'")) == 0)
                        {
                            objPOT.Insert();
                        }
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return "0";
                }
            }
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
    [WebMethod(EnableSession = true)]
    public static string MakeAction(List<PurchaseOrder> POMaster, string ButtonActionType)
    {
        var POData = POMaster.Where(s => string.IsNullOrWhiteSpace(Util.GetString(s.OrderedQty)) || Util.GetDecimal(s.OrderedQty) == 0).ToList();
        if (POData.Count > 0)
        {
            var oSerializer = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(new { QtyValidation = POData.Select(s => s.tableSNo) });
            return oSerializer;
        }
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    StringBuilder sbRigths = new StringBuilder();
                    sbRigths.Append(" SELECT COUNT(*)  FROM st_approvalright WHERE `EmployeeID`=@EmployeeID AND Active=1 AND AppRightFor='PO' ");
                    if (ButtonActionType.Trim() == "Check")
                    {
                        sbRigths.Append(" AND TypeID=2 ");
                    }
                    else
                    {
                        sbRigths.Append(" AND TypeID=3 ");
                    }
                    int dtRigths = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sbRigths.ToString(),
                        new MySqlParameter("@EmployeeID", UserInfo.ID)));
                    if (dtRigths == 0)
                    {
                        return "4#";
                    }
                    DataTable dt = PurchaseOrderItemDetail(con, POMaster[0].PurchaseOrderID);
                    if (dt.Rows.Count == 0)
                        return "0#Error";

                    StringBuilder sb = new StringBuilder();
                    List<string> POItemID = new List<string>();
                    if (ButtonActionType.Trim() == "Check")
                    {
                        int CheckCount = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT COUNT(*) FROM st_purchaseorder_details WHERE PurchaseOrderID=@PurchaseOrderID AND CheckedQty>0",
                            new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID)
                            ));
                        if (CheckCount > 0)
                        {
                            return "2#";
                        }
                        for (int i = 0; i < POMaster.Count; i++)
                        {
                            if (POMaster[i].IsFree == 0)
                                POItemID.Add(string.Concat("'", POMaster[i].ItemID, "'"));

                            var FoundItem = dt.Select("ItemID= '" + POMaster[i].ItemID + "' AND IsFree='" + POMaster[i].IsFree + "'");
                            if (FoundItem.Any())
                            {
                                DataTable dtFoundItem = FoundItem.CopyToDataTable();
                                for (int j = 0; j < dtFoundItem.Rows.Count; j++)
                                {
                                    if (dtFoundItem.Rows[j]["IsFree"].ToString() == "1" && POMaster[i].IsFree == 1)
                                    {
                                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE `st_purchaseorder_details` SET CheckedQty=@CheckedQty WHERE PurchaseOrderID=@PurchaseOrderID AND ItemID=@ItemID AND IsFree=1",
                           new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID), new MySqlParameter("@CheckedQty", POMaster[i].OrderedQty),
                           new MySqlParameter("@ItemID", POMaster[i].ItemID));
                                    }
                                    else if (dtFoundItem.Rows[j]["IsFree"].ToString() == "0" && POMaster[i].IsFree == 0)
                                    {
                                        if (Util.GetDecimal(dtFoundItem.Rows[j]["OrderedQty"].ToString()) > Util.GetDecimal(POMaster[i].OrderedQty))
                                        {
                                            var oSerializer = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(new { QtyValidation = POData.Select(s => s.tableSNo) });
                                           // return oSerializer;
                                        }
                                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE `st_purchaseorder_details` SET CheckedQty=@CheckedQty WHERE PurchaseOrderID=@PurchaseOrderID AND ItemID=@ItemID AND IsFree=0",
                          new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID), new MySqlParameter("@CheckedQty", POMaster[i].OrderedQty),
                           new MySqlParameter("@ItemID", POMaster[i].ItemID));
                                    }
                                }
                            }
                            else
                            {
                                if (POMaster[i].IsFree == 1)
                                {
                                    sb = new StringBuilder();
                                    sb.Append(" INSERT INTO st_purchaseorder_details(PurchaseOrderID,PurchaseOrderNo,ItemID,ItemName,ManufactureID,ManufactureName,CatalogNo,MachineID,MachineName,MajorUnitId,");
                                    sb.Append(" MajorUnitName,PackSize,CheckedQty,UnitPrice,IsFree )");
                                    sb.Append(" SELECT PurchaseOrderID,PurchaseOrderNo,ItemID,ItemName,ManufactureID,ManufactureName,CatalogNo,MachineID,MachineName,MajorUnitId,");
                                    sb.Append(" MajorUnitName,PackSize,@CheckedQty,UnitPrice,1 ");
                                    sb.Append(" FROM st_purchaseorder_details WHERE PurchaseOrderID=@PurchaseOrderID AND IsFree=0 AND ItemID=@ItemID");
                                    sb.Append(" ");
                                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                                        new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID), new MySqlParameter("@ItemID", POMaster[i].ItemID),
                                        new MySqlParameter("@CheckedQty", POMaster[i].OrderedQty));
                                }
                            }
                        }
                        //if (POItemID.Count > 0)
                        //{
                        //    string AllPOItemID = String.Join(",", POItemID);

                        //    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE `st_purchaseorder_details` SET IsActive=0,UpdatedByID='" + UserInfo.ID + "',UpdatedByName='" + UserInfo.CentreName + "' WHERE PurchaseOrderID='" + POMaster[0].PurchaseOrderID + "' AND ItemID NOT IN(" + AllPOItemID + ")");

                        //}
                        sb = new StringBuilder();

                        sb.Append(" UPDATE `st_purchaseorder` po ");
                        sb.Append("SET po.`GrossTotal` = ( SELECT ifnull(SUM(`Rate`*`CheckedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                        sb.Append(" po.`DiscountOnTotal`= ( SELECT ifnull(SUM(`DiscountAmount`*`CheckedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                        sb.Append(" po.`TaxAmount`= ( SELECT ifnull(SUM(`TaxAmount`*`CheckedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                        sb.Append(" po.`NetTotal`= ( SELECT ifnull(SUM(`NetAmount`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                        sb.Append(" po.CheckedDate=NOW(),po.CheckedByID=@CheckedByID,po.CheckedByName=@CheckedByName,Status=@Status,StatusName=@StatusName,ActionType=@ActionType,Warranty=@Warranty,NFANo=@NFANo,TermandCondition=@TermandCondition");
                        sb.Append(" WHERE  po.`PurchaseOrderID`=@PurchaseOrderID ");

                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID), new MySqlParameter("@CheckedByID", UserInfo.ID),
                            new MySqlParameter("@CheckedByName", UserInfo.LoginName), new MySqlParameter("@Status", "1"), new MySqlParameter("@StatusName", "Checker"), new MySqlParameter("@ActionType", "Checker"), new MySqlParameter("@NFANo", POMaster[0].NFANo), new MySqlParameter("@Termandcondition", POMaster[0].Termandcondition), new MySqlParameter("@Warranty", POMaster[0].Warranty));


                       // Store_AllLoadData sa = new Store_AllLoadData();
                        //string EmailID = sa.getApprovalRightEnail(con, "2", "PO");
                        string EmailID="";
                        if (EmailID != string.Empty)
                        {

                            sb = new StringBuilder();
                            sb.Append("<div> Dear All , </div>");
                            sb.Append("<br/>");
                            sb.Append(" Greetings from Apollo Health and Lifestyle Limited,");
                            sb.Append("<br/>"); sb.Append("<br/>");
                            sb.Append("Please Approve purchase Order No. <b>" + POMaster[0].PurchaseOrderNo + "</b>");
                            sb.Append("<br/>"); sb.Append("<br/>"); sb.Append("<br/>"); sb.Append("<br/>");
                            sb.Append("Thanks & Regards,"); sb.Append("<br/>");
                            sb.Append("Apollo Health And Lifestyle Limited."); sb.Append("<br/>");

                            ReportEmailClass REmail = new ReportEmailClass();
                            string IsSend="0";
							//string IsSend = REmail.sendPanelInvoice(EmailID, "Purchase Order", sb.ToString(), null, "", "", null, "", DateTime.Now.ToString("yyyy-MM-dd"));
                           // MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO st_emailrecord(TransactionID,UserID,IsSend,Remarks,EmailID,MailedTo)VALUES(@TransactionID,@UserID,@IsSend,@Remarks,@EmailID,@MailedTo)",
                          //  new MySqlParameter("@TransactionID", "48784"), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@IsSend", IsSend),
                   // new MySqlParameter("@Remarks", "User PO Mail"), new MySqlParameter("@EmailID", EmailID), new MySqlParameter("@MailedTo", "PO"));

                        }


                    }
                    else if (ButtonActionType.Trim() == "Approval")
                    {

                        float limitperpo = Util.GetFloat(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select POAppLimitPerPO from st_approvalright where EmployeeID=@EmployeeID and Active=@Active and typeid=@typeid and AppRightFor=@AppRightFor",
                    new MySqlParameter("@EmployeeID", UserInfo.ID),
                    new MySqlParameter("@Active", "1"),
                    new MySqlParameter("@typeid", "3"), new MySqlParameter("@AppRightFor", "PO")));


                        int CheckCount = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT COUNT(*) FROM st_purchaseorder_details WHERE PurchaseOrderID=@PurchaseOrderID AND ApprovedQty>0",
                            new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID)
                            ));
                        if (CheckCount > 0)
                        {
                            return "3#";
                        }
                        for (int i = 0; i < POMaster.Count; i++)
                        {
                            if (POMaster[i].IsFree == 0)
                                POItemID.Add(string.Concat("'", POMaster[i].ItemID, "'"));


                            var FoundItem = dt.Select("ItemID= '" + POMaster[i].ItemID + "' AND IsFree='" + POMaster[i].IsFree + "'");
                            if (FoundItem.Any())
                            {
                                DataTable dtFoundItem = FoundItem.CopyToDataTable();

                                for (int j = 0; j < dtFoundItem.Rows.Count; j++)
                                {
                                    if (dtFoundItem.Rows[j]["IsFree"].ToString() == "1" && POMaster[i].IsFree == 1)
                                    {
                                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE `st_purchaseorder_details` SET ApprovedQty=@ApprovedQty WHERE PurchaseOrderID=@PurchaseOrderID AND ItemID=@ItemID AND IsFree=1",
                           new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID), new MySqlParameter("@ApprovedQty", POMaster[i].OrderedQty),
                           new MySqlParameter("@ItemID", POMaster[i].ItemID));
                                    }
                                    else if (dtFoundItem.Rows[j]["IsFree"].ToString() == "0" && POMaster[i].IsFree == 0)
                                    {
                                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE `st_purchaseorder_details` SET ApprovedQty=@ApprovedQty WHERE PurchaseOrderID=@PurchaseOrderID AND ItemID=@ItemID AND IsFree=0",
                          new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID), new MySqlParameter("@ApprovedQty", POMaster[i].OrderedQty),
                          new MySqlParameter("@ItemID", POMaster[i].ItemID));
                                    }

                                }


                            }
                            else
                            {
                                if (POMaster[i].IsFree == 1)
                                {
                                    sb = new StringBuilder();
                                    sb.Append(" INSERT INTO st_purchaseorder_details(PurchaseOrderID,PurchaseOrderNo,ItemID,ItemName,ManufactureID,ManufactureName,CatalogNo,MachineID,MachineName,MajorUnitId,");
                                    sb.Append(" MajorUnitName,PackSize,ApprovedQty,UnitPrice,IsFree ) ");
                                    sb.Append(" SELECT PurchaseOrderID,PurchaseOrderNo,ItemID,ItemName,ManufactureID,ManufactureName,CatalogNo,MachineID,MachineName,MajorUnitId,");
                                    sb.Append(" MajorUnitName,PackSize,@ApprovedQty,UnitPrice,1 ");
                                    sb.Append(" FROM st_purchaseorder_details WHERE PurchaseOrderID=@PurchaseOrderID AND IsFree=0 AND ItemID=@ItemID");

                                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                                        new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID), new MySqlParameter("@ItemID", POMaster[i].ItemID),
                                        new MySqlParameter("@ApprovedQty", POMaster[i].OrderedQty));
                                }

                            }
                        }

                        //if (POItemID.Count > 0)
                        //{
                          //  string AllPOItemID = String.Join(",", POItemID);
                          //MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE `st_purchaseorder_details` SET IsActive=0,UpdatedByID='" + UserInfo.ID + "',UpdatedByName='" + UserInfo.CentreName + "' WHERE PurchaseOrderID='" + POMaster[0].PurchaseOrderID + "' AND ItemID NOT IN(" + AllPOItemID + ")");
                        //}
                        string cutoff = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT concat(isautorejectpo,'#',IF(isautorejectpo=1,autorejectpoafterdays,60)) cutoff FROM st_vendormaster WHERE supplierid=(SELECT vendorid FROM `st_purchaseorder` WHERE `PurchaseOrderID`='" + POMaster[0].PurchaseOrderID + "')"));

                        if (cutoff == "")
                        {
                            cutoff = "0#60";
                        }
                        sb = new StringBuilder();
                        sb.Append(" UPDATE `st_purchaseorder` po ");
                        sb.Append("SET po.`GrossTotal` = ( SELECT ifnull(SUM(`Rate`*`ApprovedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                        sb.Append("po.`DiscountOnTotal`= ( SELECT ifnull(SUM(`DiscountAmount`*`ApprovedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                        sb.Append(" po.`TaxAmount`= ( SELECT ifnull(SUM(`TaxAmount`*`ApprovedQty`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                        sb.Append(" po.`NetTotal`= ( SELECT ifnull(SUM(`NetAmount`),0) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");

                        sb.Append(" po.ApprovedDate=NOW(),po.ApprovedByID=@ApprovedByID,po.AppprovedByName=@AppprovedByName,Status=@Status,StatusName=@StatusName,ActionType=@ActionType,Warranty=@Warranty,NFANo=@NFANo,TermandCondition=@TermandCondition");
                        sb.Append(" ,po.POExpiryDate=DATE_ADD(NOW(),INTERVAL " + cutoff.Split('#')[1] + " DAY),po.IsAutoExpirable=" + cutoff.Split('#')[0] + "");
                        sb.Append(" WHERE  po.`PurchaseOrderID`=@PurchaseOrderID ");

                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID), new MySqlParameter("@ApprovedByID", UserInfo.ID),
                            new MySqlParameter("@AppprovedByName", UserInfo.LoginName), new MySqlParameter("@Status", "2"), new MySqlParameter("@StatusName", "Approval"), new MySqlParameter("@ActionType", "Approval"), new MySqlParameter("@NFANo", POMaster[0].NFANo), new MySqlParameter("@Termandcondition", POMaster[0].Termandcondition), new MySqlParameter("@Warranty", POMaster[0].Warranty));

                        float totalpovalue = Util.GetFloat(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "select NetTotal from st_purchaseorder po WHERE  po.`PurchaseOrderID`=@PurchaseOrderID ",
                              new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID)
                              ));



                        if (totalpovalue > limitperpo)
                        {
                            Exception ex = new Exception("PO Approval Limit Exceed..! <br/>You can only Approved PO Upto " + limitperpo);
                            throw (ex);
                        }
                    
                    
                    }
                    Tnx.Commit();
                    return "1#";
                }
                catch (Exception ex)
                {
                    //Tnx.Rollback();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return "0#"+ex.Message;
                }
                finally
                {
                    con.Close();
                }

            }

        }

    }

    public static DataTable PurchaseOrderItemDetail(MySqlConnection con, int PurchaseOrderID)
    {
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT pod.ItemID,pod.IsFree,IF(pod.IsFree=0,CASE WHEN po.Status=0 THEN pod.OrderedQty WHEN po.Status=1 THEN pod.CheckedQty ELSE pod.ApprovedQty END,0)OrderedQty,IF(pod.IsFree=1,CASE WHEN po.Status=0 THEN pod.OrderedQty WHEN po.Status=1 THEN pod.CheckedQty ELSE pod.ApprovedQty END,0)FreeQty FROM st_purchaseorder_details pod INNER JOIN st_purchaseorder po ON pod.PurchaseOrderID=po.PurchaseOrderID WHERE po.PurchaseOrderID=@PurchaseOrderID AND pod.IsActive=1",
              new MySqlParameter("@PurchaseOrderID", PurchaseOrderID)).Tables[0];
    }
}
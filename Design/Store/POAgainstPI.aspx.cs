using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;

public partial class Design_Store_POAgainstPI : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            ddlcategorytype.DataSource = StockReports.GetDataTable("SELECT `CategoryTypeID` ID,`CategoryTypeName` Name FROM st_categorytypemaster where active=1 ORDER BY CategoryTypeName desc");
            ddlcategorytype.DataValueField = "ID";
            ddlcategorytype.DataTextField = "Name";
            ddlcategorytype.DataBind();

            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
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
                lblApprovalCount.Text = Util.GetString(dt.AsEnumerable().Count(row => "Approval" == row.Field<String>("TypeName")));
            }

        }
    }
    private DataTable accessRight()
    {
        return StockReports.GetDataTable("SELECT TypeName FROM st_approvalright WHERE TypeID IN('1','2','3') AND AppRightFor='PO' AND EmployeeID='" + UserInfo.ID + "' AND Active=1 ");
    }
    [WebMethod]
    public static string bindItemGroup(string SubcategoryID)
    {
        return Util.getJson(StockReports.GetDataTable(" SELECT  ig.`ItemIDGroup`,ig.`ItemNameGroup` FROM st_itemmaster im INNER JOIN `st_itemmaster_group` ig ON im.ItemIDGroup=ig.ItemIDGroup WHERE im.`SubcategoryID`='" + SubcategoryID + "'  GROUP BY ig.ItemIDGroup "));
    }

    [WebMethod]
    public static string bindData(string CentreType, string CategoryType, string Manufacture, string ZoneID, string SubCategory, string Machine, string StateID, string ItemType, string ItemIDGroup, string FromDate, string ToDate, string CityID, string VendorID, string Centre, string CentreLocation, string indentno, string pendingpi, string itemcate)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT (ind.IndentNo)IndentNo,ind.FromLocationID,loc.Location,im.ItemID,im.typename ItemName,subm.SubCategoryTypeName SubCategoryType,sub.Name ItemType ,  ");
        sb.Append(" im.ManufactureID,im.CatalogNo,im.MajorUnitId,im.MajorUnitName,im.ManufactureName Manufacture,im.MachineID,im.MachineName,im.PackSize,im.MajorUnitName PurchaseUnit, ");
        sb.Append(" ind.Rate ,ind.UnitPrice,ind.DiscountPer,(ind.Rate*(1 - (ind.DiscountPer*0.01))*ind.ApprovedQty)DiscAmt,(ind.TaxPerCGST+ind.TaxPerIGST+ind.TaxPerSGST)TaxPer,ind.TaxPerCGST,");
        sb.Append(" ind.TaxPerIGST,ind.TaxPerSGST ,ind.NetAmount NetAmount,IF(im.MajorUnitInDecimal =0,TRUNCATE((ind.ApprovedQty-(ind.RejectQty+ind.POQty+ind.BudgetRejectQty)),0),(ind.ApprovedQty-(ind.RejectQty+ind.POQty+ind.BudgetRejectQty)))ApprovedQty, ");
        sb.Append(" im.MajorUnitInDecimal,ind.VendorID,ven.SupplierName,ven.IsLoginRequired,ind.VendorStateId,ind.VednorStateGstnno, ");
        sb.Append(" CONCAT(ven.HouseNo,' ',ven.Street,' ',ven.State,' ',ven.Country,' ',ven.PinCode)SupplierAddress ");
        sb.Append(" ,ifnull(svq.vendorid,ind.VendorID) newvendorid, ifnull(svq.rate,ind.rate) newrate,ifnull(svq.vendorname,ven.SupplierName)SupplierNameNew,");
        sb.Append(" ifnull(svq.discountper,ind.discountper)discountpernew,ifnull(svq.buyprice,ind.unitprice) unitpricenew,(ifnull(svq.IGSTPer,ind.TaxPerIGST)+ifnull(svq.SGSTPer,ind.TaxPerSGST)+ifnull(svq.CGSTPer,ind.TaxPerCGST)) taxpernew");
        sb.Append(" ,ifnull(ind.rejectby,0) rejectby");
        sb.Append(" ,CONCAT( LEFT (ind.Narration, 10),IF(LENGTH(ind.Narration)>10, '..','')) AS NarrationDisplay,ind.Narration ");
        sb.Append(" FROM st_indent_detail ind INNER JOIN f_panel_master fpm ON ind.FromPanelId=fpm.Panel_ID  ");
        //  sb.Append(" INNER JOIN centre_master cm ON cm.centreid=fpm.CentreID ");
        sb.Append(" INNER JOIN st_locationmaster loc ON fpm.Panel_ID=loc.Panel_ID AND ind.FromLocationID=loc.LocationID ");
        if (Centre != string.Empty)
        {
            sb.Append(" and loc.Panel_ID IN (" + Centre + ") ");
        }
        if (CentreLocation != string.Empty)
        {
            sb.Append(" and loc.LocationID IN (" + CentreLocation + ") ");
        }

        sb.Append(" INNER JOIN st_itemmaster im ON im.ItemID=ind.ItemID ");
        sb.Append(" INNER JOIN st_vendormaster ven ON ven.SupplierID =ind.VendorID ");
        //sb.Append(" INNER JOIN st_itemmaster_group img ON img.ItemIDGroup=im.ItemIDGroup ");
        sb.Append(" INNER JOIN `st_Subcategorytypemaster` subm ON subm.SubCategoryTypeID=im.SubCategoryTypeID ");
        sb.Append(" INNER JOIN st_subcategorymaster sub ON sub.SubCategoryID =im.SubCategoryID ");
           
        
        sb.Append(" left join st_vendorqutation svq on svq.DeliveryLocationID=ind.FromLocationID and svq.itemid=ind.itemid and ComparisonStatus=1 ");
        sb.Append(" and svq.IsActive=1 and svq.ApprovalStatus=2 and svq.EntryDateTo>=date(now()) ");
        sb.Append(" WHERE ind.IndentType='PI' AND ind.IsActive=1 AND ind.isCancel=0  AND ind.ApprovedQty>0 AND IFNULL(ind.PIGroupID,'')='' AND ind.ActionType='Approval' ");
        sb.Append(" AND (ind.ApprovedQty-(ind.RejectQty+ind.POQty+ind.BudgetRejectQty))>0 ");
        sb.Append(" and im.categorytypeid='"+itemcate+"'");

        if (indentno == string.Empty)
        {
            if (pendingpi == string.Empty)
            {

                sb.Append(" AND ind.dtEntry>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb.Append(" AND ind.dtEntry<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            }
        }

        //if (CentreType != string.Empty)
        //    sb.Append(" AND cm.Type1 IN (" + CentreType + ")");
        if (CategoryType != string.Empty)
            sb.Append(" AND subm.CategoryTypeID IN (" + CategoryType + ")");
        if (Manufacture != string.Empty)
            sb.Append(" AND im.ManufactureID IN (" + Manufacture + ")");
        //if (ZoneID != string.Empty)
        //    sb.Append(" AND cm.BusinessZoneID IN (" + ZoneID + ")");

        if (SubCategory != string.Empty)
            sb.Append(" AND subm.SubCategoryTypeID IN (" + SubCategory + ")");
        if (Machine != string.Empty)
            sb.Append(" AND im.MachineID IN (" + Machine + ")");
        //if (StateID != string.Empty)
        //    sb.Append(" AND cm.StateID IN (" + StateID + ")");
        if (ItemType != string.Empty)
            sb.Append(" AND sub.SubCategoryID IN (" + ItemType + ")");
        if (ItemIDGroup != string.Empty)
            sb.Append(" AND im.ItemIDGroup IN (" + ItemIDGroup + ")");
        //if (CityID != string.Empty)
        //    sb.Append(" AND cm.CityID IN (" + CityID + ")");

        if (indentno != string.Empty)
            sb.Append(" and ind.IndentNo='" + indentno + "'");

        if (pendingpi != string.Empty)
        {
            pendingpi = "'" + pendingpi + "'";
            pendingpi = pendingpi.Replace(",", "','");
            sb.Append(" and ind.IndentNo in (" + pendingpi + ") ");
        }

        if (VendorID != string.Empty)
            sb.Append(" AND ven.SupplierID IN (" + VendorID + ")");
        sb.Append(" Order BY ind.FromLocationID,ind.IndentNo,ind.VendorID,ind.NetAmount desc ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
                return Util.getJson(dt);
            else
                return "";
        }
    }

    [WebMethod]
    public static string bindpendingpi(string locationid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT indentno FROM st_indent_detail ind ");
        sb.Append(" WHERE ind.IndentType='PI' AND ind.IsActive=1 AND ind.isCancel=0   ");
        sb.Append(" AND ind.ApprovedQty>0 AND IFNULL(ind.PIGroupID,'')='' AND ind.ActionType='Approval'  ");
        sb.Append(" AND (ind.ApprovedQty-(ind.RejectQty+ind.POQty+ind.BudgetRejectQty))>0  ");
        sb.Append(" AND FromLocationID IN (" + locationid + ") ");


        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }
    

    public static string   savePurchaseOrder(PurchaseOrder POMaster, MySqlTransaction Tnx)
    {
        try
        {
            PurchaseOrderMaster POM = new PurchaseOrderMaster(Tnx);

            string PurchaseOrderNo = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "Select store_get_po_number()"));
            if (PurchaseOrderNo == string.Empty)
            {
                return "2";
            }
            POM.PurchaseOrderNo = PurchaseOrderNo;
            POM.Subject = POMaster.Subject;
            POM.VendorID = POMaster.VendorID;
            POM.VendorName = POMaster.VendorName;
            POM.CreatedByID = UserInfo.ID;
            POM.CreatedByName = UserInfo.LoginName;
            // POM.CheckedDate = DateTime.Now;
            // POM.CheckedByID = UserInfo.ID;
            // POM.CheckedByName = UserInfo.LoginName;
            // POM.ApprovedDate = DateTime.Now;
            // POM.ApprovedByID = UserInfo.ID;
            //  POM.AppprovedByName = UserInfo.LoginName;
            POM.Status = 0;

            POM.StatusName = "Maker";
            POM.LocationID = POMaster.LocationID;
            POM.IndentNo = POMaster.IndentNo;
            POM.VendorStateId = POMaster.VendorStateId;
            POM.VendorGSTIN = POMaster.VendorGSTIN;
            POM.VendorAddress = POMaster.VendorAddress;
            POM.VendorLogin = POMaster.VendorLogin;
            POM.POType = POMaster.POType;
            POM.ActionType = "Maker";
            POM.Warranty = POMaster.Warranty;
            POM.NFANo = POMaster.NFANo;
            POM.Termandcondition = POMaster.Termandcondition;
            int PurchaseOrderID = POM.Insert();
            return string.Concat(PurchaseOrderID, "#", PurchaseOrderNo);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

    public static string savePurchaseOrderDetail(PurchaseOrder POD, MySqlTransaction Tnx, int PurchaseOrderID, string PurchaseOrderNo)
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
            // objPOD.CheckedQty = POD.OrderedQty;
            // objPOD.ApprovedQty = POD.OrderedQty;
            objPOD.DiscountPercentage = POD.DiscountPercentage;
            objPOD.IsFree = POD.IsFree;

            objPOD.Rate = POD.Rate; //
            decimal discAmount = Util.GetDecimal(Util.GetDecimal(POD.Rate) * Util.GetDecimal(POD.DiscountPercentage) * Util.GetDecimal(0.01));
            decimal taxAmount = (Util.GetDecimal(POD.Rate) - discAmount) * Util.GetDecimal(POD.TaxPer) * Util.GetDecimal(0.01);

            objPOD.TaxAmount = taxAmount;//
            objPOD.DiscountAmount = discAmount;//


            objPOD.UnitPrice = POD.UnitPrice;//
            objPOD.NetAmount = POD.UnitPrice * POD.OrderedQty;//
            objPOD.Insert();

            using (DataTable dt = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, "SELECT POQty,ApprovedQty,TrimZero(ApprovedQty-POQty)PendingQty FROM st_indent_detail WHERE IndentNo=@IndentNo AND ItemID=@ItemID AND IsActive=1 AND `ActionType`='Approval' ",
                              new MySqlParameter("@IndentNo", POD.IndentNo), new MySqlParameter("@ItemID", POD.ItemID)).Tables[0])
            {
                if (Util.GetDecimal(dt.Rows[0]["ApprovedQty"].ToString()) < Util.GetDecimal(Util.GetDecimal(dt.Rows[0]["POQty"].ToString()) + (Util.GetDecimal(POD.OrderedQty))))
                {
                    POQuantityChk bsObj = new POQuantityChk()
                    {
                        TableTrNo = POD.tableSNo,
                        Qty = dt.Rows[0]["PendingQty"].ToString()
                    };

                    var oSerializer = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(new { ApprovedValidation = bsObj });
                    return oSerializer;

                    //var oSerializer = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(new { ApprovedValidation = string.Concat(POD.tableSNo.ToString(), '#', dt.Rows[0]["PendingQty"].ToString()) });
                    //return oSerializer;

                }
            }

            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE st_indent_detail SET POQty=POQty+@POQty WHERE IndentNo=@IndentNo AND ItemID=@ItemID",
               new MySqlParameter("@POQty", Util.GetDecimal(POD.OrderedQty)), new MySqlParameter("@IndentNo", POD.IndentNo), new MySqlParameter("@ItemID", POD.ItemID));
            if (Util.GetDecimal(POD.TaxPerCGST) > 0 || Util.GetDecimal(POD.TaxPerIGST) > 0 || Util.GetDecimal(POD.TaxPerSGST) > 0)
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
                        taxAmount = (Util.GetDecimal(POD.Rate) - discAmount) * Util.GetDecimal(POD.TaxPerCGST) * Util.GetDecimal(0.01);
                        objPOT.TaxAmt = taxAmount;//
                        objPOT.Insert();
                    }
                    if (Util.GetDecimal(POD.TaxPerIGST) > 0)
                    {
                        objPOT.TaxName = "IGST";
                        objPOT.Percentage = POD.TaxPerIGST;
                        taxAmount = (Util.GetDecimal(POD.Rate) - discAmount) * Util.GetDecimal(POD.TaxPerIGST) * Util.GetDecimal(0.01);
                        objPOT.TaxAmt = taxAmount;//
                        objPOT.Insert();
                    }
                    if (Util.GetDecimal(POD.TaxPerSGST) > 0)
                    {
                        objPOT.TaxName = "SGST";
                        objPOT.Percentage = POD.TaxPerSGST;
                        taxAmount = (Util.GetDecimal(POD.Rate) - discAmount) * Util.GetDecimal(POD.TaxPerSGST) * Util.GetDecimal(0.01);
                        objPOT.TaxAmt = taxAmount;//
                        objPOT.Insert();
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
    public static string savePurchaseOrder(List<PurchaseOrder> POMaster, string term, string deliveryterm, int termID, int deliverytermID)
    {

        var POData = POMaster.Where(s => string.IsNullOrWhiteSpace(Util.GetString(s.OrderedQty)) || Util.GetDecimal(s.OrderedQty) == 0).ToList();
        if (POData.Count > 0)
        {

             //new {QtyValidation = QtyValidation, ApprovedValidation = ApprovedValidation}
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
                        string PurchaseOrderNo = string.Empty;
                        List<string> POIDList = new List<string>();
                        List<string> POIDANDNOList = new List<string>();
                        for (int i = 0; i < POMaster.Count; i++)
                        {
                            if (i == 0)
                            {
                                PurchaseOrderNo = savePurchaseOrder(POMaster[i], Tnx);
                                if (PurchaseOrderNo == "0" || PurchaseOrderNo == "2")
                                {
                                    Tnx.Rollback();
                                    return PurchaseOrderNo;
                                }
                                var PurchaseOrderDetail = savePurchaseOrderDetail(POMaster[i], Tnx, Util.GetInt(PurchaseOrderNo.Split('#')[0]), PurchaseOrderNo.Split('#')[1]);
                                if (PurchaseOrderDetail != "1")
                                {

                                    Tnx.Rollback();
                                    return PurchaseOrderDetail;

                                }
                                POIDList.Add(string.Concat("'", PurchaseOrderNo.Split('#')[0], "'"));

                                POIDANDNOList.Add(PurchaseOrderNo);


                            }
                            else
                            {
                                if ((POMaster[i].LocationID.ToString() == POMaster[i - 1].LocationID.ToString()) && (POMaster[i].IndentNo.ToString() == POMaster[i - 1].IndentNo.ToString()) && (POMaster[i].VendorID.ToString() == POMaster[i - 1].VendorID.ToString()))
                                {
                                    string PurchaseOrderDetail = savePurchaseOrderDetail(POMaster[i], Tnx, Util.GetInt(PurchaseOrderNo.Split('#')[0]), PurchaseOrderNo.Split('#')[1]);
                                    if (PurchaseOrderDetail != "1")
                                    {
                                        Tnx.Rollback();
                                        return PurchaseOrderDetail;
                                    }
                                }
                                else
                                {
                                    PurchaseOrderNo = savePurchaseOrder(POMaster[i], Tnx);
                                    if (PurchaseOrderNo == "0" || PurchaseOrderNo == "2")
                                    {
                                        Tnx.Rollback();
                                        return PurchaseOrderNo;
                                    }
                                    string PurchaseOrderDetail = savePurchaseOrderDetail(POMaster[i], Tnx, Util.GetInt(PurchaseOrderNo.Split('#')[0]), PurchaseOrderNo.Split('#')[1]);
                                    if (PurchaseOrderDetail != "1")
                                    {
                                        Tnx.Rollback();
                                        return PurchaseOrderDetail;
                                    }
                                    POIDList.Add(string.Concat("'", PurchaseOrderNo.Split('#')[0], "'"));
                                    POIDANDNOList.Add(PurchaseOrderNo);
                                }
                            }
                        }

                        string AllPOID = String.Join(",", POIDList);
                        StringBuilder sb = new StringBuilder();
                        sb.Append(" UPDATE `st_purchaseorder` po ");
                        sb.Append("SET po.`GrossTotal` = ( SELECT SUM(`Rate`*`OrderedQty`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND pod.IsFree=0 AND pod.IsActive=1 ), ");
                        sb.Append(" po.`DiscountOnTotal`= ( SELECT SUM(`DiscountAmount`*`OrderedQty`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND pod.IsFree=0 AND pod.IsActive=1 ), ");
                        sb.Append(" po.`TaxAmount`= ( SELECT SUM(`TaxAmount`*`OrderedQty`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND pod.IsFree=0 AND pod.IsActive=1 ), ");
                        sb.Append(" po.`NetTotal`= ( SELECT SUM(`NetAmount`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND pod.IsFree=0 AND pod.IsActive=1 ) ");
                        sb.Append(" WHERE  po.`PurchaseOrderID` IN (" + AllPOID + ") ");

                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

                        foreach (string ponumber in POIDANDNOList)
                        {
                            PurchaseOrderTermsAndConditions POT = new PurchaseOrderTermsAndConditions(Tnx);
                            POT.PurchaseOrderID = Util.GetInt(ponumber.Split('#')[0]);
                            POT.PurchaseOrderNo = Util.GetString(ponumber.Split('#')[1]);
                            POT.POTermsCondition = term;
                            POT.CreatedByID = UserInfo.ID;
                            POT.CreatedByName = UserInfo.LoginName;
                            POT.DeliveryTerm = deliveryterm;
                            POT.TermConditionID = termID;
                            POT.DeliveryTermID = deliverytermID;
                            POT.Insert();
                        }

                        Tnx.Commit();
                    }
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
    class POQuantityChk
    {
        public int TableTrNo { get; set; }
        public string Qty { get; set; }
    }

    
    [WebMethod(EnableSession = true)]
    public static string setPOData(string POID)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT if(po.IsEdited=1,'Amended','') re, if(po.IsEdited=1,concat('Amended Date :',DATE_FORMAT(po.LastEditDate,'%d-%b-%y'),'<br/>Amended By :',po.LastEditByName),'')remsg, '0' rejectby, ifnull(po.Warranty,'')Warranty,ifnull(po.NFANo,'')NFANo,ifnull(po.TermandCondition,'')TermandCondition, po.PurchaseOrderID,po.PurchaseOrderNo,po.IndentNo IndentNo,po.LocationID FromLocationID,loc.Location,pod.ItemID,img.ItemNameGroup ItemName,subm.SubCategoryTypeName SubCategoryType,sub.Name ItemType ,  ");
        sb.Append(" pod.ManufactureID,pod.CatalogNo,pod.MajorUnitId,pod.MajorUnitName,pod.ManufactureName Manufacture,pod.MachineID,pod.MachineName,pod.PackSize,pod.MajorUnitName PurchaseUnit, ");
        sb.Append(" pod.Rate ,pod.UnitPrice,pod.DiscountPercentage DiscountPer,pod.DiscountAmount DiscAmt,(IFNULL(pot.CGSTTax,0)+IFNULL(pot.IGSTTax,0)+IFNULL(pot.SGSTax,0))TaxPer,IFNULL(pot.CGSTTax,0) TaxPerCGST,");
        sb.Append(" IFNULL(pot.IGSTTax,0)TaxPerIGST,IFNULL(pot.SGSTax,0)TaxPerSGST ,po.NetTotal NetAmount, ");
        sb.Append(" SUM(IF(pod.IsFree=0,CASE WHEN po.Status=0 THEN pod.OrderedQty WHEN po.Status=1 THEN pod.CheckedQty ELSE pod.ApprovedQty END,0))ApprovedQty, ");

        sb.Append(" im.MajorUnitInDecimal,po.VendorID,po.VendorName SupplierName,po.VendorLogin IsLoginRequired,po.VendorStateId VendorStateId,po.VendorGSTIN VednorStateGstnno, ");
        sb.Append(" po.VendorAddress SupplierAddress,po.ActionType ");
        sb.Append(" ");
        sb.Append(" ,ifnull(svq.vendorid,po.VendorID) newvendorid, ifnull(svq.rate,pod.rate) newrate,ifnull(svq.vendorname,po.VendorName)SupplierNameNew,");
        sb.Append(" ifnull(svq.discountper,pod.DiscountPercentage)discountpernew,ifnull(svq.buyprice,pod.unitprice) unitpricenew,(ifnull(svq.IGSTPer,pot.IGSTTax)+ifnull(svq.SGSTPer,pot.SGSTax)+ifnull(svq.CGSTPer,pot.CGSTTax)) taxpernew");

        sb.Append("  ,  (SELECT GROUP_CONCAT(TypeName)TypeName FROM st_approvalright WHERE `EmployeeID`='" + UserInfo.ID + "' AND Active=1 AND AppRightFor='PO' ) TotalRigthsPO");


        sb.Append(" FROM st_purchaseorder po INNER JOIN st_purchaseorder_details pod ON po.PurchaseOrderID=pod.PurchaseOrderID AND pod.IsActive=1 ");
        sb.Append(" INNER JOIN st_itemmaster im ON im.ItemID=pod.ItemID ");
        sb.Append(" INNER JOIN st_locationmaster loc ON loc.LocationID=po.LocationID    ");
        sb.Append(" INNER JOIN st_itemmaster_group img ON img.ItemIDGroup=im.ItemIDGroup INNER JOIN `st_Subcategorytypemaster` subm ON subm.SubCategoryTypeID=im.SubCategoryTypeID");
        sb.Append(" left join st_vendorqutation svq on svq.DeliveryLocationID=po.LocationID and svq.itemid=pod.itemid and ComparisonStatus=1");
        sb.Append(" and svq.IsActive=1 and svq.ApprovalStatus=2 and svq.EntryDateTo>=date(now()) ");
        sb.Append(" INNER JOIN st_subcategorymaster sub ON sub.SubCategoryID =im.SubCategoryID ");
        sb.Append(" LEFT JOIN   ");

        sb.Append("  (  SELECT pot.ItemID ,  SUM(IF(pot.TaxName='IGST',IFNULL(pot.Percentage,0),0))IGSTTax,");
        sb.Append(" SUM(IF(pot.TaxName='CGST',(pot.Percentage),0))CGSTTax,SUM(IF(pot.TaxName='SGST',(pot.Percentage),0))SGSTax");
        sb.Append(" FROM  st_purchaseorder_tax pot WHERE pot.PurchaseOrderID='" + POID + "' GROUP BY ItemID )pot     ON  pot.ItemID=pod.ItemID  ");
        sb.Append(" WHERE po.PurchaseOrderID='" + POID + "'   GROUP BY po.PurchaseOrderID,pod.ItemID ");


        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
                return Util.getJson(dt);
            else
                return "";
        }


    }


    [WebMethod(EnableSession = true)]
    public static string MakeAction(List<PurchaseOrder> POMaster, string ButtonActionType, string Term, int TermID, string Deliveryterm, int DeliverytermID)
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
                            POItemID.Add(string.Concat("'", POMaster[i].ItemID, "'"));

                            var FoundItem = dt.Select("ItemID= '" + POMaster[i].ItemID + "' ");
                            if (FoundItem.Any())
                            {
                                DataTable dtFoundItem = FoundItem.CopyToDataTable();
                                for (int j = 0; j < dtFoundItem.Rows.Count; j++)
                                {

                                    if (Util.GetDecimal(dtFoundItem.Rows[j]["OrderedQty"].ToString()) < Util.GetDecimal(POMaster[i].OrderedQty))
                                    {
                                        var oSerializer = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(new { QtyValidation = POData.Select(s => s.tableSNo) });
                                        //return oSerializer;
                                    }
                                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE `st_purchaseorder_details` SET CheckedQty=@CheckedQty WHERE PurchaseOrderID=@PurchaseOrderID AND ItemID=@ItemID AND IsFree=0",
                       new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID), new MySqlParameter("@CheckedQty", POMaster[i].OrderedQty),
                       new MySqlParameter("@ItemID", POMaster[i].ItemID));


                                }
                            }

                        }
                        if (POItemID.Count > 0)
                        {
                            string AllPOItemID = String.Join(",", POItemID);

                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE `st_purchaseorder_details` SET IsActive=0,UpdatedByID='" + UserInfo.ID + "',UpdatedByName='" + UserInfo.CentreName + "' WHERE PurchaseOrderID='" + POMaster[0].PurchaseOrderID + "' AND ItemID NOT IN(" + AllPOItemID + ")");

                        }
                        sb = new StringBuilder();

                        sb.Append(" UPDATE `st_purchaseorder` po ");
                        sb.Append("SET po.`GrossTotal` = ( SELECT SUM(`Rate`*`CheckedQty`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                        sb.Append(" po.`DiscountOnTotal`= ( SELECT SUM(`DiscountAmount`*`CheckedQty`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                        sb.Append(" po.`TaxAmount`= ( SELECT SUM(`TaxAmount`*`CheckedQty`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                        sb.Append(" po.`NetTotal`= ( SELECT SUM(`NetAmount`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                        sb.Append(" po.CheckedDate=NOW(),po.CheckedByID=@CheckedByID,po.CheckedByName=@CheckedByName,Status=@Status,StatusName=@StatusName,ActionType=@ActionType,Warranty=@Warranty,NFANo=@NFANo,TermandCondition=@TermandCondition");
                        sb.Append(" WHERE  po.`PurchaseOrderID`=@PurchaseOrderID ");

                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID), new MySqlParameter("@CheckedByID", UserInfo.ID),
                            new MySqlParameter("@CheckedByName", UserInfo.LoginName), new MySqlParameter("@Status", "1"), new MySqlParameter("@StatusName", "Checker"), new MySqlParameter("@ActionType", "Checker"), new MySqlParameter("@NFANo", POMaster[0].NFANo), new MySqlParameter("@Termandcondition", POMaster[0].Termandcondition), new MySqlParameter("@Warranty", POMaster[0].Warranty));


                        Store_AllLoadData sa = new Store_AllLoadData();
                        string EmailID = sa.getApprovalRightEnail(con, "2", "PO");

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
                            string IsSend = REmail.sendPanelInvoice(EmailID, "Purchase Order", sb.ToString(), null, "", "", null, "", DateTime.Now.ToString("yyyy-MM-dd"));
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO st_emailrecord(TransactionID,UserID,IsSend,Remarks,EmailID,MailedTo)VALUES(@TransactionID,@UserID,@IsSend,@Remarks,@EmailID,@MailedTo)",
                             new MySqlParameter("@TransactionID", POMaster[0].PurchaseOrderID), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@IsSend", IsSend),
                   new MySqlParameter("@Remarks", "User PO Mail"), new MySqlParameter("@EmailID", EmailID), new MySqlParameter("@MailedTo", "PO"));

                        }


                    }
                    else if (ButtonActionType.Trim() == "Approval")
                    {

                        float limitperpo = Util.GetFloat(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select POAppLimitPerPO from st_approvalright where EmployeeID=@EmployeeID and Active=@Active and typeid=@typeid and AppRightFor=@AppRightFor",
                       new MySqlParameter("@EmployeeID", UserInfo.ID),
                       new MySqlParameter("@Active","1"),
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

                            POItemID.Add(string.Concat("'", POMaster[i].ItemID, "'"));

                            var FoundItem = dt.Select("ItemID= '" + POMaster[i].ItemID + "' ");
                            if (FoundItem.Any())
                            {
                                DataTable dtFoundItem = FoundItem.CopyToDataTable();

                                for (int j = 0; j < dtFoundItem.Rows.Count; j++)
                                {

                                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE `st_purchaseorder_details` SET ApprovedQty=@ApprovedQty WHERE PurchaseOrderID=@PurchaseOrderID AND ItemID=@ItemID AND IsFree=0",
                      new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID), new MySqlParameter("@ApprovedQty", POMaster[i].OrderedQty),
                      new MySqlParameter("@ItemID", POMaster[i].ItemID));
                                }
                            }

                        }

                        if (POItemID.Count > 0)
                        {
                            string AllPOItemID = String.Join(",", POItemID);
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, " UPDATE `st_purchaseorder_details` SET IsActive=0,UpdatedByID='" + UserInfo.ID + "',UpdatedByName='" + UserInfo.CentreName + "' WHERE PurchaseOrderID='" + POMaster[0].PurchaseOrderID + "' AND ItemID NOT IN(" + AllPOItemID + ")");
                        }

                        string cutoff = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT concat(isautorejectpo,'#',IF(isautorejectpo=1,autorejectpoafterdays,60)) cutoff FROM st_vendormaster WHERE supplierid=(SELECT vendorid FROM `st_purchaseorder` WHERE `PurchaseOrderID`='" + POMaster[0].PurchaseOrderID + "')"));

                        if (cutoff == "")
                        {
                            cutoff = "0#60";
                        }
                        sb = new StringBuilder();
                        sb.Append(" UPDATE `st_purchaseorder` po ");
                        sb.Append("SET po.`GrossTotal` = ( SELECT SUM(`Rate`*`ApprovedQty`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                        sb.Append("po.`DiscountOnTotal`= ( SELECT SUM(`DiscountAmount`*`ApprovedQty`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                        sb.Append(" po.`TaxAmount`= ( SELECT SUM(`TaxAmount`*`ApprovedQty`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                        sb.Append(" po.`NetTotal`= ( SELECT SUM(`NetAmount`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");

                        sb.Append(" po.ApprovedDate=NOW(),po.ApprovedByID=@ApprovedByID,po.AppprovedByName=@AppprovedByName,Status=@Status,StatusName=@StatusName,ActionType=@ActionType,Warranty=@Warranty,NFANo=@NFANo,TermandCondition=@TermandCondition");
                        sb.Append(" ,po.POExpiryDate=DATE_ADD(NOW(),INTERVAL " + cutoff.Split('#')[1] + " DAY),po.IsAutoExpirable=" + cutoff.Split('#')[0] + "");

                        sb.Append(" WHERE  po.`PurchaseOrderID`=@PurchaseOrderID ");

                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID), new MySqlParameter("@ApprovedByID", UserInfo.ID),
                            new MySqlParameter("@AppprovedByName", UserInfo.LoginName), new MySqlParameter("@Status", "2"), new MySqlParameter("@StatusName", "Approval"), new MySqlParameter("@ActionType", "Approval"), new MySqlParameter("@Warranty", POMaster[0].Warranty), new MySqlParameter("@NFANo", POMaster[0].NFANo), new MySqlParameter("@Termandcondition", POMaster[0].Termandcondition));


                       float totalpovalue=Util.GetFloat( MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "select NetTotal from st_purchaseorder po WHERE  po.`PurchaseOrderID`=@PurchaseOrderID ",
                            new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID)
                            ));



                       if (totalpovalue > limitperpo)
                       {

                           Exception ex = new Exception("PO Approval Limit Exceed..! <br/>You can only Approved PO Upto " + limitperpo);
                           throw (ex);
                       }
                    }

                    DataTable POTerm = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, "SELECT DeliveryTerm,DeliveryTermID,TermCondition,TermConditionID FROM st_purchaseorder_termsandconditions WHERE PurchaseOrderID=@PurchaseOrderID",
                        new MySqlParameter("@PurchaseOrderID", POMaster[0].PurchaseOrderID)
                        ).Tables[0];

                    if (POTerm.Rows.Count > 0)
                    {
                        DataRow[] FoundTermCondition = POTerm.Select("TermConditionID= '" + TermID + "' ");
                        DataRow[] FoundDeliveryterm = POTerm.Select("DeliveryTermID= '" + DeliverytermID + "' ");
                       

                        if (FoundDeliveryterm.Length == 0 || FoundTermCondition.Length == 0)
                        {
                            sb = new StringBuilder();
                            sb.Append("UPDATE st_purchaseorder_termsandconditions SET ");

                            if (FoundTermCondition.Length == 0)
                                sb.Append(" TermConditionID=@TermConditionID,TermCondition=@TermCondition ");

                            if (FoundTermCondition.Length == 0 && FoundDeliveryterm.Length == 0)
                                sb.Append(" , ");
                           

                            if (FoundDeliveryterm.Length == 0)
                                sb.Append(" DeliveryTermID=@DeliveryTermID,DeliveryTerm=@DeliveryTerm ");
                          

                            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);

                            if (FoundTermCondition.Length == 0)
                            {
                                cmd.Parameters.AddWithValue("@TermConditionID", TermID);
                                cmd.Parameters.AddWithValue("@TermCondition", Term);
                               
                            }
                            if (FoundDeliveryterm.Length == 0)
                            {
                                cmd.Parameters.AddWithValue("@DeliveryTermID", DeliverytermID);
                                cmd.Parameters.AddWithValue("@DeliveryTerm", Deliveryterm);
                            }


                            cmd.ExecuteNonQuery();
                            cmd.Dispose();
                        }
                    }
                   Tnx.Commit();
                    return "1#";
                }
                catch (Exception ex)
                {
                    Tnx.Rollback();
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


    [WebMethod(EnableSession = true)]
    public static string UpdateNewRate(List<UpdateNewRate> UpdateData)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb;
            foreach (UpdateNewRate Newrate in UpdateData)
            {
                DataTable dtnewrate = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT  VendorId,VendorStateId,VednorStateGstnno,ItemID,Rate,DiscountPer,IGSTPer,SGSTPer,CGSTPer,BuyPrice FROM st_vendorqutation WHERE itemid=@itemid AND DeliveryLocationID=@DeliveryLocationID AND ComparisonStatus=1 and IsActive=1 and ApprovalStatus=2 and EntryDateTo>=date(now()) ",
                    new MySqlParameter("@itemid", Newrate.ItemID),
                    new MySqlParameter("@DeliveryLocationID", Newrate.FromLocationID)).Tables[0];

                if (dtnewrate.Rows.Count > 0)
                {
                    if (Util.GetInt(dtnewrate.Rows[0]["VendorId"]) != Util.GetInt(Newrate.OldvendorID) || Util.GetFloat(dtnewrate.Rows[0]["Rate"]) != Util.GetFloat(Newrate.Rate))
                    {
                        // Update Indent No
                        sb = new StringBuilder();
                        sb.Append(" update st_indent_detail set Rate=@Rate,DiscountPer=@DiscountPer,TaxPerIGST=@TaxPerIGST,TaxPerCGST=@TaxPerCGST,TaxPerSGST=@TaxPerSGST");
                        sb.Append(" ,UnitPrice=@UnitPrice,NetAmount=UnitPrice*if(ApprovedQty=0,ReqQty,ApprovedQty),vendorid=@vendorid,VendorStateId=@VendorStateId  ");
                        sb.Append(" ,VednorStateGstnno=@VednorStateGstnno where indentno=@indentno and itemid=@itemid");

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@Rate", Util.GetFloat(dtnewrate.Rows[0]["Rate"])),
                            new MySqlParameter("@DiscountPer", Util.GetFloat(dtnewrate.Rows[0]["DiscountPer"])),
                            new MySqlParameter("@TaxPerIGST", Util.GetFloat(dtnewrate.Rows[0]["IGSTPer"])),
                            new MySqlParameter("@TaxPerCGST", Util.GetFloat(dtnewrate.Rows[0]["CGSTPer"])),
                            new MySqlParameter("@TaxPerSGST", Util.GetFloat(dtnewrate.Rows[0]["SGSTPer"])),
                            new MySqlParameter("@UnitPrice", Util.GetFloat(dtnewrate.Rows[0]["BuyPrice"])),
                            new MySqlParameter("@vendorid", Util.GetInt(dtnewrate.Rows[0]["VendorId"])),
                            new MySqlParameter("@VendorStateId", Util.GetInt(dtnewrate.Rows[0]["VendorStateId"])),
                            new MySqlParameter("@VednorStateGstnno", Util.GetString(dtnewrate.Rows[0]["VednorStateGstnno"])),
                            new MySqlParameter("@indentno", Util.GetString(Newrate.IndentNo)),
                            new MySqlParameter("@itemid", Util.GetInt(Newrate.ItemID))
                          );


                        // Insert into BackUp Table


                        sb = new StringBuilder();
                        sb.Append("    INSERT INTO st_indent_detail_old ");
                        sb.Append("    (IndentNo,ItemId,FromLocationID, Qty,Rate, ");
                        sb.Append("    DiscountPer,TaxPerIGST, TaxPerCGST, ");
                        sb.Append("    TaxPerSGST, UnitPrice,  NetAmount, ");
                        sb.Append("    vendorid,  VendorStateId,   VednorStateGstnno,  EntryDate, ");
                        sb.Append("     EntryByUserID,EntryByUserName) values  ");
                        sb.Append("    (@IndentNo,@ItemId,@FromLocationID, @Qty,@Rate, ");
                        sb.Append("    @DiscountPer,@TaxPerIGST, @TaxPerCGST, ");
                        sb.Append("    @TaxPerSGST, @UnitPrice,  @NetAmount, ");
                        sb.Append("    @vendorid,  @VendorStateId,   @VednorStateGstnno,  now(), ");
                        sb.Append("     @EntryByUserID,@EntryByUserName)   ");


                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@IndentNo", Newrate.IndentNo),
                            new MySqlParameter("@ItemId", Newrate.ItemID),
                            new MySqlParameter("@FromLocationID", Newrate.FromLocationID),
                            new MySqlParameter("@Qty", Newrate.Qty),
                            new MySqlParameter("@Rate", Newrate.Rate),
                            new MySqlParameter("@DiscountPer", Newrate.DiscountPer),
                            new MySqlParameter("@TaxPerIGST", Newrate.TaxPerIGST),
                            new MySqlParameter("@TaxPerCGST", Newrate.TaxPerCGST),
                            new MySqlParameter("@TaxPerSGST", Newrate.TaxPerSGST),
                            new MySqlParameter("@UnitPrice", Newrate.UnitPrice),
                            new MySqlParameter("@NetAmount", Newrate.NetAmount),
                            new MySqlParameter("@vendorid", Newrate.OldvendorID),
                            new MySqlParameter("@VendorStateId", Newrate.VendorStateId),
                            new MySqlParameter("@VednorStateGstnno", Newrate.VednorStateGstnno),
                            new MySqlParameter("@EntryByUserID", UserInfo.ID),
                            new MySqlParameter("@EntryByUserName", UserInfo.LoginName)
                            );


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

    [WebMethod(EnableSession = true)]
    public static string BindVendorwithrate(string locationid, string itemid, string vendorid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT vendorid,vendorname,deliverylocationid,deliverylocationname,itemid,itemname,rate,DiscountPer,IGSTPer,SGSTPer,CGSTPer,VendorStateId,VednorStateGstnno,
IF(vendorid=" + vendorid + ",1,0) isset,IF(vendorid=" + vendorid + ",'pink','white') Rowcolor,BuyPrice FROM st_vendorqutation WHERE itemid=" + itemid + " AND `DeliveryLocationID`=" + locationid + " and IsActive=1 and ApprovalStatus=2 and EntryDateTo>=date(now()) order by isset desc,vendorname asc"));
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateNewRateWithVendor(UpdateNewRate UpdateData)
    {


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            DataTable dtoldrate = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT  ApprovedQty,Rate,DiscountPer,TaxPerIGST,TaxPerCGST,TaxPerSGST,UnitPrice,NetAmount,vendorid,VendorStateId,VednorStateGstnno FROM st_indent_detail WHERE itemid=@itemid AND IndentNo=@IndentNo",
                   new MySqlParameter("@itemid", UpdateData.ItemID),
                   new MySqlParameter("@IndentNo", UpdateData.IndentNo)).Tables[0];


            StringBuilder sb;


            // Insert into BackUp Table


            sb = new StringBuilder();
            sb.Append("    INSERT INTO st_indent_detail_old ");
            sb.Append("    (IndentNo,ItemId,FromLocationID, Qty,Rate, ");
            sb.Append("    DiscountPer,TaxPerIGST, TaxPerCGST, ");
            sb.Append("    TaxPerSGST, UnitPrice,  NetAmount, ");
            sb.Append("    vendorid,  VendorStateId,   VednorStateGstnno,  EntryDate, ");
            sb.Append("     EntryByUserID,EntryByUserName) values  ");
            sb.Append("    (@IndentNo,@ItemId,@FromLocationID, @Qty,@Rate, ");
            sb.Append("    @DiscountPer,@TaxPerIGST, @TaxPerCGST, ");
            sb.Append("    @TaxPerSGST, @UnitPrice,  @NetAmount, ");
            sb.Append("    @vendorid,  @VendorStateId,   @VednorStateGstnno,  now(), ");
            sb.Append("     @EntryByUserID,@EntryByUserName)   ");


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@IndentNo", UpdateData.IndentNo),
                new MySqlParameter("@ItemId", UpdateData.ItemID),
                new MySqlParameter("@FromLocationID", UpdateData.FromLocationID),
                new MySqlParameter("@Qty", dtoldrate.Rows[0]["ApprovedQty"]),
                new MySqlParameter("@Rate", dtoldrate.Rows[0]["rate"]),
                new MySqlParameter("@DiscountPer", dtoldrate.Rows[0]["DiscountPer"]),
                new MySqlParameter("@TaxPerIGST", dtoldrate.Rows[0]["TaxPerIGST"]),
                new MySqlParameter("@TaxPerCGST", dtoldrate.Rows[0]["TaxPerCGST"]),
                new MySqlParameter("@TaxPerSGST", dtoldrate.Rows[0]["TaxPerSGST"]),
                new MySqlParameter("@UnitPrice", dtoldrate.Rows[0]["UnitPrice"]),
                new MySqlParameter("@NetAmount", dtoldrate.Rows[0]["NetAmount"]),
                new MySqlParameter("@vendorid", dtoldrate.Rows[0]["vendorid"]),
                new MySqlParameter("@VendorStateId", dtoldrate.Rows[0]["VendorStateId"]),
                new MySqlParameter("@VednorStateGstnno", dtoldrate.Rows[0]["VednorStateGstnno"]),
                new MySqlParameter("@EntryByUserID", UserInfo.ID),
                new MySqlParameter("@EntryByUserName", UserInfo.LoginName)
                );


            // Update Indent No
            sb = new StringBuilder();
            sb.Append(" update st_indent_detail set Rate=@Rate,DiscountPer=@DiscountPer,TaxPerIGST=@TaxPerIGST,TaxPerCGST=@TaxPerCGST,TaxPerSGST=@TaxPerSGST");
            sb.Append(" ,UnitPrice=@UnitPrice,NetAmount=UnitPrice*if(ApprovedQty=0,ReqQty,ApprovedQty),vendorid=@vendorid,VendorStateId=@VendorStateId  ");
            sb.Append(" ,VednorStateGstnno=@VednorStateGstnno where indentno=@indentno and itemid=@itemid");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Rate", Util.GetFloat(UpdateData.Rate)),
                new MySqlParameter("@DiscountPer", Util.GetFloat(UpdateData.DiscountPer)),
                new MySqlParameter("@TaxPerIGST", Util.GetFloat(UpdateData.TaxPerIGST)),
                new MySqlParameter("@TaxPerCGST", Util.GetFloat(UpdateData.TaxPerCGST)),
                new MySqlParameter("@TaxPerSGST", Util.GetFloat(UpdateData.TaxPerSGST)),
                new MySqlParameter("@UnitPrice", Util.GetFloat(UpdateData.UnitPrice)),
                new MySqlParameter("@vendorid", Util.GetInt(UpdateData.OldvendorID)),
                new MySqlParameter("@VendorStateId", Util.GetInt(UpdateData.VendorStateId)),
                new MySqlParameter("@VednorStateGstnno", Util.GetString(UpdateData.VednorStateGstnno)),
                new MySqlParameter("@indentno", Util.GetString(UpdateData.IndentNo)),
                new MySqlParameter("@itemid", Util.GetInt(UpdateData.ItemID))
              );






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




    [WebMethod(EnableSession = true)]
    public static string RejectItem(string indentno, string itemid, string ActionType, string POID)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            if (POID != "")
            {

                if (ActionType != "")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_purchaseorder_details set RejectQty=if(ApprovedQty=0,if(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty) ,IsActive=0,RejectByUserID=" + UserInfo.ID + ",RejectByUserName='" + UserInfo.LoginName + "' where PurchaseOrderID='" + POID + "' and itemid='" + itemid + "'");
                    string rjqty = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select RejectQty from st_purchaseorder_details where PurchaseOrderID='" + POID + "' and itemid='" + itemid + "'"));

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_indent_detail set poqty=poqty-" + rjqty + ", dtReject=now(), RejectBy=" + UserInfo.ID + " where indentno='" + indentno + "' and itemid='" + itemid + "'");





                    StringBuilder sb = new StringBuilder();

                    sb.Append(" UPDATE `st_purchaseorder` po ");
                    sb.Append("SET po.`GrossTotal` = ( SELECT SUM(`Rate`*if(ApprovedQty=0,if(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty)) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                    sb.Append(" po.`DiscountOnTotal`= ( SELECT SUM(`DiscountAmount`*if(ApprovedQty=0,if(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty)) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                    sb.Append(" po.`TaxAmount`= ( SELECT SUM(`TaxAmount`*if(ApprovedQty=0,if(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty)) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1), ");
                    sb.Append(" po.`NetTotal`= ( SELECT SUM(`NetAmount`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND IsActive=1) ");

                    sb.Append(" WHERE  po.`PurchaseOrderID`=" + POID + "");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " DELETE FROM st_purchaseorder_tax WHERE itemid='" + itemid + "' and PurchaseOrderID='" + POID + "'");


                }
            }
            else {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_indent_detail set RejectQty=ApprovedQty, dtReject=now(), RejectBy=" + UserInfo.ID + " where indentno='" + indentno + "' and itemid='" + itemid + "'");
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

    [WebMethod(EnableSession = true)]
    public static string setPOTermsandconditions(string POID)
    {
        return Util.getJson(StockReports.GetDataTable("SELECT TermConditionID,TermCondition,DeliveryTermID,DeliveryTerm FROM st_purchaseorder_termsandconditions WHERE PurchaseOrderID='" + POID + "' "));
    }
}



    public class UpdateNewRate
{
    public string IndentNo { get; set; }
    public string ItemID { get; set; }
    public string FromLocationID { get; set; }
    public string Qty { get; set; }
    public string OldvendorID { get; set; }
    public string VendorStateId { get; set; }
    public string VednorStateGstnno { get; set; }
    public string Rate { get; set; }
    public string DiscountPer { get; set; }
    public string TaxPerIGST { get; set; }
    public string TaxPerCGST { get; set; }
    public string TaxPerSGST { get; set; }
    public string UnitPrice { get; set; }
    public string NetAmount { get; set; }



}
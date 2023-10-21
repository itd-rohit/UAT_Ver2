using CrystalDecisions.CrystalReports.Engine;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_POSearch : System.Web.UI.Page
{
    public string approve = "0", edit = "0", closeAfterapp = "0", editAfterapp = "0", rejectAfterAppBeforeClose = "0", poeditfull="0";
    public float limitperpo = 0;
    protected void Page_Load(object sender, EventArgs e)
    {


        limitperpo = Util.GetFloat(StockReports.ExecuteScalar("select POAppLimitPerPO from st_approvalright where EmployeeID='"+UserInfo.ID+"' and Active=1 and typeid=3 and AppRightFor='PO'"));
            


        ddlaction.SelectedIndex = 0;
        DataTable dt = StockReports.GetDataTable("SELECT TypeID FROM `st_approvalright` WHERE EmployeeID ='" + Session["id"].ToString() + "' AND AppRightFor='PO' AND Active=1 ");
        if (dt.Select(" TypeID=1 ").Length > 0)
        {
            edit = "1";
        }
        if (dt.Select(" TypeID=2 ").Length > 0)
        {
            ddlaction.SelectedIndex = -1;
            ListItem selectedListItem = ddlaction.Items.FindByValue("Maker");

            if (selectedListItem != null)
            {
                selectedListItem.Selected = true;
            }
            edit = "1";
        }
        if (dt.Select(" TypeID=3 ").Length > 0)
        {
            ddlaction.SelectedIndex = -1;
            ListItem selectedListItem = ddlaction.Items.FindByValue("Checker");

                if (selectedListItem != null)
                {
                    selectedListItem.Selected = true;
                }
           
            approve = "1";
        }
        if (dt.Select(" TypeID=4 ").Length > 0)
        {
            closeAfterapp = "1";
        }
        if (dt.Select(" TypeID=5 ").Length > 0)
        {
            editAfterapp = "1";
        }
        if (dt.Select(" TypeID=6 ").Length > 0)
        {
            rejectAfterAppBeforeClose = "1";
        }
        if (dt.Select(" TypeID=18 ").Length > 0)
        {
            poeditfull = "1";
        }
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);

            ddlusername.DataSource = StockReports.GetDataTable(@"
SELECT DISTINCT Employee_ID,NAME FROM employee_master em 
INNER JOIN `st_approvalright` sa ON em.Employee_ID=sa.employeeID AND apprightfor='PO' AND sa.active=1 AND typename='Maker'
ORDER BY NAME");

            ddlusername.DataValueField = "Employee_ID";
            ddlusername.DataTextField = "NAME";
            ddlusername.DataBind();
            ddlusername.Items.Insert(0, new ListItem("Select Maker","0"));


        }
    }
    [WebMethod]
    public static string bindData(string CentreType, string CategoryType, string Manufacture, string ZoneID, string SubCategory, string Machine, string StateID, string ItemType, string ItemIDGroup, string FromDate, string ToDate, string CityID, string VendorID, string PONo, string POType, int POStatus, string Maker, string ddlaction,string location)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM ( ");
        sb.Append(" SELECT if(po.IsEdited=1,'Amended','') re, if(po.IsEdited=1,concat('Amended Date :',DATE_FORMAT(po.LastEditDate,'%d-%b-%y'),'<br/>Amended By :',po.LastEditByName),'')remsg, po.vendorlogin, if(po.vendorlogin=1 && po.isvendoraccept=1,ifnull((SELECT group_concat(FILE) FROM `st_purchaseorder_details_vendor_invoice` WHERE `PurchaseOrderID`=po.PurchaseOrderID),''),'') VendorInvoice, po.vendorcomment, loc.Location, po.DiscountOnTotal,po.TaxAmount, po.PurchaseOrderNo,po.PurchaseOrderID, im.ItemID,img.ItemNameGroup ItemName,subm.SubCategoryTypeName SubCategoryType,sub.Name ItemType ,  ");
        sb.Append(" im.ManufactureID,im.CatalogNo,im.MajorUnitId,im.MajorUnitName,im.ManufactureName Manufacture,im.MachineID, ");
        sb.Append(" im.MachineName,im.PackSize,im.MajorUnitName PurchaseUnit,im.MajorUnitInDecimal,po.VendorName SupplierName,po.VendorLogin IsLoginRequired, ");
        sb.Append("  DATE_FORMAT(po.CreatedDate,'%d-%b-%y')RaisedDate,po.IsMail,po.POType,po.Subject,po.GrossTotal,po.NetTotal,po.VendorID,ven.EmailID VendorMailID,Po.Status POStatus, ");
		sb.Append("CONCAT(ifnull(loc.`ContactPerson`,''),' (',IFNULL(loc.ContactPersonNo,''),')',', ',ifnull(loc.`StoreLocationAddress`,'')) DeliveryAddress, ");
        sb.Append("  (CASE WHEN Po.Status = 7 THEN 'Full GRN'  WHEN po.Status=6 THEN 'Partial GRN' WHEN po.Status=5 THEN 'Closed by System' WHEN po.Status=4 THEN 'Closed By User' WHEN po.Status=3 THEN 'Reject' WHEN po.Status=2 THEN 'Approved'      ");
        sb.Append(" else 'Open' END) POStatusType, ");
        sb.Append("  (CASE WHEN Po.autoPOMail=1 THEN '#44A3AA' WHEN Po.autoPOMail = -1 THEN '#FFC0CB' WHEN Po.Status = 7 THEN '#B0C4DE' WHEN po.Status=6 THEN '#00FFFF'  WHEN po.Status=5 THEN '#CC99FF' WHEN po.Status=4 THEN '#f5b738' WHEN po.Status=3 THEN '#3399FF' WHEN po.status=2 THEN '#90EE90'   ");
        sb.Append(" else '#FFFFFF' END) rowColor,po.IndentNo,SUM(pod.GrnQty)GrnQty,SUM(pod.ApprovedQty)ApprovedQty,po.IsDirectPO,IFNULL(po.ActionType,'')ActionType,po.RejectReason ");
        sb.Append(" FROM st_purchaseorder po   INNER JOIN st_purchaseorder_details pod ON po.PurchaseOrderID=pod.PurchaseOrderID  AND pod.IsActive=1");
        sb.Append("  INNER JOIN st_vendormaster ven ON ven.SupplierID=po.VendorID ");
        sb.Append(" INNER JOIN st_locationmaster loc ON loc.LocationID=po.LocationID ");

        if (location != "")
        {
            sb.Append(" and loc.LocationID in ("+location+")");
        }
        //sb.Append(" INNER JOIN f_panel_master fpm ON loc.Panel_ID=fpm.Panel_ID AND fpm.PanelType='Centre' ");
        //sb.Append(" INNER JOIN centre_master cm ON cm.centreid=fpm.CentreID ");
        sb.Append(" INNER JOIN st_itemmaster im ON im.ItemID=pod.ItemID ");
        sb.Append(" INNER JOIN st_itemmaster_group img ON img.ItemIDGroup=im.ItemIDGroup ");
        sb.Append(" INNER JOIN `st_Subcategorytypemaster` subm ON subm.SubCategoryTypeID=im.SubCategoryTypeID ");
        sb.Append(" INNER JOIN st_subcategorymaster sub ON sub.SubCategoryID =im.SubCategoryID ");

        sb.Append(" WHERE  ");

        

        sb.Append("  po.CreatedDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append("  AND po.CreatedDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");

        if (ddlaction != "")
        {
            sb.Append(" and po.ActionType='" + ddlaction + "'");
        }
        if (Maker != "0")
        {
            sb.Append(" and po.CreatedByID='"+Maker+"' ");
        }
        if (POStatus != 0)
        {
            if (POStatus != 8)
                sb.Append(" AND Po.Status ='" + POStatus + "'");
            else
                sb.Append(" AND Po.autoPOMail=1");
        }

        if (PONo != string.Empty)
        {
            sb.Append(" AND po.PurchaseOrderNo ='" + PONo + "'");
        }
        if (POType != "Select")
        {
            sb.Append(" AND po.POType ='" + POType + "'");
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

        if (VendorID != string.Empty)
            sb.Append(" AND ven.SupplierID IN (" + VendorID + ")");

        sb.Append(" GROUP BY po.PurchaseOrderID )t   ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
                return Util.getJson(dt);
            else
                return "";
        }
    }
    [WebMethod]
    public static string bindPODetail(string PurchaseOrderID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT pod.vendorcommentitem, pod.ID PurchaseOrderDetailID,pod.ItemName,pod.ItemID,pod.ManufactureName,pod.CatalogNo,pod.MachineName,");
        sb.Append(" TrimZero(pod.UnitPrice)UnitPrice,TrimZero(pod.DiscountPercentage)DiscountPercentage,TrimZero(pod.NetAmount)NetAmount,pod.MajorUnitName,pod.PackSize, ");
        sb.Append(" SUM(IF(pod.IsFree=0, pod.OrderedQty,0))OrderedQty,SUM(IF(pod.IsFree=1, pod.OrderedQty,0))OrderedFreeQty, ");
        sb.Append(" SUM(IF(pod.IsFree=0, pod.CheckedQty,0))CheckedQty,SUM(IF(pod.IsFree=1, pod.OrderedQty,0))CheckedFreeQty, ");
        sb.Append(" SUM(IF(pod.IsFree=0, pod.ApprovedQty,0))ApprovedQty,SUM(IF(pod.IsFree=1, pod.OrderedQty,0))ApprovedFreeQty ");
        sb.Append(" FROM `st_purchaseorder_details` pod  ");
        sb.Append(" WHERE pod.PurchaseOrderID='" + PurchaseOrderID + "' AND pod.IsActive=1 GROUP BY pod.ItemID");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            return Util.getJson(dt);
        }
    }
    [WebMethod]
    public static string EmailReport(string PurchaseOrderID, string VendorEmailID, string vendorName, string emailCC, string emailBcc)
    {
        string IsSend = "0";
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            try
            {

                StringBuilder sb = new StringBuilder();
                sb.Append(" select po.status,''  posign,po.ApprovedByID, ");
                sb.Append(" if(po.IsEdited=1,concat('Amended PO Approved by ',po.LastEditByName,' on',DATE_FORMAT(po.LastEditDate,'%d-%b-%Y')),'') pomsg,");

                sb.Append(" cm.centrecode,cm.centre,  po.Warranty,po.NFANo,po.TermandCondition, sm.GSTIN DeliveryGSTN,sm.state deliveryState,sm.GSTINAddress deliveryGSTINAddress,(select house_no from employee_master where employee_id=po.CreatedByID) MakerUser, ");
                sb.Append(" ifnull(spt.DeliveryTerm,'') DeliveryPeriod,ifnull(spt.TermCondition,'') PaymentTerms,CONCAT(ifnull(sl.`ContactPerson`,''),' (',IFNULL(sl.ContactPersonNo,''),')',', ',ifnull(sl.`StoreLocationAddress`,'')) DeliveryAddress,  ");
                sb.Append(" (SELECT VendorNote FROM st_purchaseorder_footer_note)VendorNote,   ");
                sb.Append(" (SELECT FooterNote FROM st_purchaseorder_footer_note)FooterNote   ");
                sb.Append(" ,concat(cccm.CategoryTypeName,'~',ssb.`Name`) Category,''ForPaymentStatusContact ,concat(img.`ItemNameGroup`,'-',ifnull(im.packsize,' '),'-',ifnull(im.CatalogNo,' '),'-',ifnull(im.MachineName,' '),'-',ifnull(im.ManufactureName,' ')) Discription,im.`HsnCode` HSN_SAC_CODE,pod.`MajorUnitName` UOM,   ");
                sb.Append(" `TrimZero`(pod.`ApprovedQty`) Qty,`TrimZero`(pod.`Rate`) UnitRate, `TrimZero`(pod.`UnitPrice`)UnitPrice,  ");
                sb.Append(" `TrimZero`(pod.`DiscountAmount`) Disc,(TrimZero(pot.CGSTTax)+TrimZero(pot.SGSTax)+TrimZero(pot.IGSTTax)) Tax,   ");
                sb.Append(" TrimZero(IFNULL(pot.CGSTTaxAmt,'0')) CGST,TrimZero(IFNULL(pot.SGSTaxAmt,'0'))SGST, TrimZero(IFNULL(pot.IGSTTaxAmt,'0')) IGST,   ");
                sb.Append(" TrimZero(pod.`NetAmount`) Amount, (pod.`ApprovedQty`*pod.UnitPrice) finalprice,   ");
                sb.Append(" po.`PurchaseOrderNo` PONumber,DATE_FORMAT(ifnull(po.ApprovedDate,po.CreatedDate),'%d-%b-%Y')PODate,    ");
                sb.Append(" po.`VendorName` VendorName,ven.`PrimaryContactPerson` VendorContactPerson,po.`VendorAddress` VendorAddress,   ");
                // sb.Append(" ven.`PrimaryContactPersonMobileNo` VendorMobile,ven.`EmailId` VendorEmail,po.`VendorGSTIN` VendorGSTIN,   ");
                sb.Append(" ven.`PrimaryContactPersonMobileNo` VendorMobile,ven.`EmailId` VendorEmail,(select GST_No from st_supplier_gstn where supplierID=ven.`SupplierID` limit 1) VendorGSTIN,   ");
                sb.Append(" (select state from st_supplier_gstn where supplierID=ven.`SupplierID` limit 1) VendorState,1 ImageToPrint , ItemName ,  ");
                sb.Append(" CONCAT(em.Title,' ',em.Name)MakerBy,em.Email MakerEmail,em.Mobile MakerContactNo,sl.Location DeliveryLocation ");
                sb.Append(" FROM `st_purchaseorder` po    ");
                sb.Append(" INNER JOIN st_locationmaster sl ON sl.`LocationID`=po.`LocationID`  ");
                sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=sl.`Panel_ID`  ");
                sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=fpm.`CentreID`  ");
                sb.Append(" INNER JOIN state_master sm ON sm.`id`=cm.`StateID`  ");
                sb.Append(" INNER JOIN `st_purchaseorder_details` pod    ");
                sb.Append(" ON po.`PurchaseOrderID`=pod.`PurchaseOrderID`   ");
                sb.Append(" AND pod.`IsActive`=1   ");
                sb.Append(" INNER JOIN st_itemmaster im   ON pod.ItemID = im.ItemID    ");
                sb.Append(" INNER JOIN st_itemmaster_group img   ON img.ItemIDgroup = im.ItemIDgroup    ");
                sb.Append(" INNER JOIN st_subcategorymaster ssb ON ssb.`SubCategoryID`=im.`SubCategoryID`  ");
                sb.Append(" inner join st_categorytypemaster cccm on cccm.CategoryTypeID=im.CategoryTypeID");
                sb.Append(" INNER JOIN `st_vendormaster` ven ON ven.`SupplierID`=po.`VendorID`   ");
                sb.Append(" INNER JOIN `employee_master` em ON em.employee_id=po.CreatedByID ");
                sb.Append(" LEFT JOIN st_purchaseorder_termsandconditions spt ON spt.`PurchaseOrderID`=po.`PurchaseOrderID`  ");
                sb.Append(" LEFT JOIN      ");
                sb.Append(" (  SELECT pot.ItemID ,pot.PurchaseOrderID,  sum(IF(pot.TaxName='IGST',IFNULL(pot.Percentage,0),0))IGSTTax,sum(IF(pot.TaxName='IGST',IFNULL(pot.TaxAmt,0),0))IGSTTaxAmt,   ");
                sb.Append(" sum(IF(pot.TaxName='CGST',(pot.Percentage),0))CGSTTax,sum(IF(pot.TaxName='CGST',(pot.TaxAmt),0))CGSTTaxAmt,sum(IF(pot.TaxName='SGST',(pot.Percentage),0))SGSTax ,sum(IF(pot.TaxName='SGST',(pot.TaxAmt),0))SGSTaxAmt  ");
                sb.Append(" FROM  st_purchaseorder_tax pot WHERE pot.PurchaseOrderID=@PurchaseOrderID GROUP BY ItemID )pot     ON  pot.ItemID=pod.ItemID     and pot.PurchaseOrderID=pod.PurchaseOrderID");
                sb.Append(" WHERE po.PurchaseOrderID = @PurchaseOrderID and po.status='2'  ORDER BY pod.ItemName  ");//

                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@PurchaseOrderID", PurchaseOrderID)).Tables[0])
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "User";
                    try
                    {
                        dc.DefaultValue = UserInfo.LoginName;
                    }
                    catch
                    {
                        dc.DefaultValue = "Supplier Portal";
                    }
                    dt.Columns.Add(dc);
                    var DistinctCategory = dt.AsEnumerable()
                            .Select(s => s.Field<string>("Category"))

                            .Distinct().ToList();
                    string DistValue = "";
                    foreach (var a in DistinctCategory)
                    {
                        var net = dt.Compute("sum(finalprice)", "Category='" + a.ToString() + "'");
                        DistValue += a.ToString() + " - " + Convert.ToInt32(net) + ", ";
                    }


                    dt.Rows[0]["Category"] = DistValue.TrimEnd(' ').TrimEnd(',');

                    string path = HttpContext.Current.Server.MapPath("~/Design/Store/POSign/" + dt.Rows[0]["ApprovedByID"] + ".jpg");
                    DataColumn dc1 = new DataColumn();
                    dc1.ColumnName = "AppSign";
                    dc1.DataType = System.Type.GetType("System.Byte[]");

                    if (File.Exists(path))
                    {
                        FileStream fs = new FileStream(path, FileMode.Open, System.IO.FileAccess.Read);
                        byte[] imgbyte = new byte[fs.Length + 1];
                        fs.Read(imgbyte, 0, (int)fs.Length);
                        fs.Close();

                        dc1.DefaultValue = imgbyte;

                    }

                    dt.Columns.Add(dc1);

                    using (DataSet ds = new DataSet())
                    {
                        ds.Tables.Add(dt.Copy());
                        ds.Tables[0].TableName = "ItemsDetail";
                        // ds.WriteXml(@"E:\POReport.xml");
                        using (ReportDocument obj1 = new ReportDocument())
                        {
                            obj1.Load(HttpContext.Current.Server.MapPath(@"~\Design\Store\Report\PurchaseOrderReport.rpt"));
                            obj1.SetDataSource(ds);
                            System.IO.Stream oStream = null;
                            byte[] byteArray = null;
                            oStream = obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                            byteArray = new byte[oStream.Length];
                            oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
                            HttpContext.Current.Response.ClearContent();
                            HttpContext.Current.Response.ClearHeaders();
                            HttpContext.Current.Response.Buffer = true;
                            HttpContext.Current.Response.ContentType = "application/pdf";
                            HttpContext.Current.Response.BinaryWrite(byteArray.ToArray());

                            ReportEmailClass REmail = new ReportEmailClass();

                            sb = new StringBuilder();
                            sb.Append("<div> Dear " + vendorName.ToUpper() + " , </div>");
                            sb.Append("<br/>");
                            sb.Append(" Greetings from Apollo Health and Lifestyle Limited,");
                            sb.Append("<br/>"); sb.Append("<br/>");
                            sb.Append("Please find the attached Purchase Order ");
                            sb.Append("<br/>"); sb.Append("<br/>"); sb.Append("<br/>"); sb.Append("<br/>");
                            sb.Append("Thanks & Regards,"); sb.Append("<br/>");
                            sb.Append(dt.Rows[0]["MakerBy"].ToString());sb.Append("<br/>");
                            
                            if (dt.Rows[0]["MakerEmail"].ToString() != string.Empty)
                            {
                                sb.Append(" Email:- "); sb.Append(dt.Rows[0]["MakerEmail"].ToString());
                                sb.Append("<br/>");
                            }
                            if (dt.Rows[0]["MakerContactNo"].ToString() != string.Empty)
                            {
                                sb.Append(" Mobile:- "); sb.Append(dt.Rows[0]["MakerContactNo"].ToString());
                                sb.Append("<br/>");
                            }
                            sb.Append("Apollo Health And Lifestyle Limited.");

                          string emailSubject = string.Concat(dt.Rows[0]["PONumber"].ToString(), "#", vendorName, "#", dt.Rows[0]["DeliveryLocation"].ToString());

                            IsSend = REmail.sendPanelInvoice(VendorEmailID, emailSubject, sb.ToString(), byteArray, emailCC, emailBcc, null, emailSubject, string.Empty);
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO st_emailrecord(TransactionID,UserID,IsSend,Remarks,EmailID,Cc,Bcc,MailedTo)VALUES(@TransactionID,@UserID,@IsSend,@Remarks,@EmailID,@Cc,@Bcc,@MailedTo)",
                             new MySqlParameter("@TransactionID", PurchaseOrderID), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@IsSend", IsSend),
                   new MySqlParameter("@Remarks", "Vendor PO Mail"), new MySqlParameter("@EmailID", VendorEmailID), new MySqlParameter("@Cc", emailCC), new MySqlParameter("@Bcc", emailBcc), new MySqlParameter("@MailedTo", "Vendor"));


                        }
                    }
                    
                }
                
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                IsSend= "0";
            }
            finally
            {
                con.Close();
            }
        }

        return IsSend;

    }
    [WebMethod(EnableSession = true)]
    public static int approvePO(string PurchaseOrderID)
    {
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE st_purchaseorder SET Status='2',StatusName='Approved', ApprovedByID=@ApprovedByID,ApprovedDate=NOW(),AppprovedByName=@AppprovedByName ");
                sb.Append("   WHERE PurchaseOrderID=@PurchaseOrderID ");

                return MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                                 new MySqlParameter("@PurchaseOrderID", PurchaseOrderID), new MySqlParameter("@ApprovedByID", UserInfo.ID),
                                 new MySqlParameter("@AppprovedByName", UserInfo.LoginName));
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return 0;
            }
            finally
            {
                con.Close();
            }
        }
    }
    [WebMethod]
    public static string encryptPurchaseOrderID(string ImageToPrint, string PurchaseOrderID)
    {
        List<string> addEncrypt = new List<string>();
        addEncrypt.Add(Common.Encrypt(ImageToPrint));
        addEncrypt.Add(Common.Encrypt(PurchaseOrderID));
        return JsonConvert.SerializeObject(addEncrypt);
    }
    [WebMethod]
    public static int closePO(string PurchaseOrderID, string closeReason, string IndentNo)
    {
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    StringBuilder sb = new StringBuilder();

                    int count = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT COUNT(*) FROM st_purchaseorder WHERE PurchaseOrderID=@PurchaseOrderID AND status IN ('4','5')",
                        new MySqlParameter("@PurchaseOrderID", PurchaseOrderID)));
                    if (count > 0)
                    {
                        return 2;
                    }

                    sb.Append(" UPDATE st_purchaseorder SET  Status='4',StatusName='Closed By User', ClosedReason=@ClosedReason,ClosedDate=NOW(),ClosedByID=@ClosedByID,ClosedByName=@ClosedByName ");
                    sb.Append(" WHERE PurchaseOrderID=@PurchaseOrderID ");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@PurchaseOrderID", PurchaseOrderID), new MySqlParameter("@ClosedReason", closeReason),
                        new MySqlParameter("@ClosedByID", UserInfo.ID), new MySqlParameter("@ClosedByName", UserInfo.LoginName));



                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE st_purchaseorder_details SET RejectQty=(ApprovedQty-GRNQty) WHERE PurchaseOrderID=@PurchaseOrderID",
                        new MySqlParameter("@PurchaseOrderID", PurchaseOrderID));

                    if (IndentNo.Trim() != string.Empty)
                    {
                        sb = new StringBuilder();

                         sb.Append(" UPDATE st_indent_detail ind INNER JOIN st_purchaseorder po ON ind.IndentNo=po.IndentNo INNER JOIN  st_purchaseorder_details pd ");
                         sb.Append("  ON po.PurchaseOrderID=pd.PurchaseOrderID and pd.itemid=ind.itemid SET ind.rejectqty=pd.RejectQty WHERE ind.IndentNo=@IndentNo and po.PurchaseOrderID=@PurchaseOrderID");

                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@IndentNo", IndentNo), new MySqlParameter("@PurchaseOrderID", PurchaseOrderID));




                        sb = new StringBuilder();

                        sb.Append(" UPDATE st_purchaseorder set indentno=concat(indentno,'_Closed') WHERE PurchaseOrderID=@PurchaseOrderID");

                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@PurchaseOrderID", PurchaseOrderID));
                    }


                    //StringBuilder sb = new StringBuilder();
                    //sb.Append(" UPDATE `st_purchaseorder` po ");
                    //sb.Append(" SET po.`GrossTotal` = ( SELECT SUM(`Rate`*`ApprovedQty`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID`), ");
                    //sb.Append(" po.`DiscountOnTotal`= ( SELECT SUM(`DiscountAmount`*`ApprovedQty`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID`), ");
                    //sb.Append(" po.`TaxAmount`= ( SELECT SUM(`TaxAmount`*`ApprovedQty`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID`), ");
                    //sb.Append(" po.`NetTotal`= ( SELECT SUM(`NetAmount`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID`) ");
                    //sb.Append(" WHERE  po.`PurchaseOrderID`=@PurchaseOrderID ");

                    //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                    //    new MySqlParameter("@PurchaseOrderID", PurchaseOrderID)
                    //    );

                    Tranx.Commit();
                    return 1;
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return 0;
                }
                finally
                {
                    con.Close();
                }

            }
        }

    }
    [WebMethod]
    public static string bindPOEditDetail(string PurchaseOrderID, string IndentNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pod.ID PurchaseOrderDetailID,pod.PurchaseOrderID,pod.ItemName,pod.ItemID,pod.ManufactureName,pod.PackSize,pod.CatalogNo,");
        sb.Append(" pod.MachineName,IF(pod.isFree=0, (pod.ApprovedQty-(RejectQtyByUser+RejectQtyByVendor)),0)ApprovedQty,pod.UnitPrice, ");
        sb.Append(" pod.DiscountPercentage,pod.NetAmount,pod.MajorUnitName,pod.PackSize,im.MajorUnitInDecimal,pod.GRNQty,pod.isFree ");
        sb.Append(" FROM `st_purchaseorder_details` pod INNER JOIN st_itemmaster im ON pod.ItemID=im.ItemID AND  pod.IsActive=1");     
        sb.Append(" WHERE pod.PurchaseOrderID='" + PurchaseOrderID + "' AND pod.IsActive=1");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            return Util.getJson(dt);
        }
    }
    [WebMethod]
    public static string POEdit(List<string[]> POItemData, string PurchaseOrderID)
    {

        var POData = POItemData.Where(s => string.IsNullOrWhiteSpace(Util.GetString(s[1])) || Util.GetDecimal(s[1]) == 0).ToList();
        if (POData.Count > 0)
        {
            return string.Concat(POItemData[0][7].Trim(), "$", "Please Enter Valid Qty.").ToString(); ;
        }
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {

                    int count = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT COUNT(*) FROM st_purchaseorder WHERE PurchaseOrderID=@PurchaseOrderID AND status IN ('4','5')",
                        new MySqlParameter("@PurchaseOrderID", PurchaseOrderID)));
                    if (count > 0)
                    {
                        return "2";
                    }

                    int i = 2;
                    foreach (string[] s in POItemData)
                    {
                        i += 1;
                        if (Util.GetDecimal(s[1]) == 0)
                        {
                            return string.Concat(i, "$", "Please Enter Valid Qty.").ToString();
                        }

                        using (DataTable dt = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, "SELECT GRNQty,ApprovedQty FROM st_purchaseorder_details WHERE ID=@ID",
                              new MySqlParameter("@ID", Util.GetString(s[3]))).Tables[0])
                        {

                            if (Util.GetDecimal(dt.Rows[0]["GRNQty"].ToString()) > Util.GetDecimal(s[1]))
                            {
                                return string.Concat(i, "#", "Qty Cannot Less then GRN Quantity").ToString();
                            }
                            if (Util.GetDecimal(dt.Rows[0]["ApprovedQty"].ToString()) < Util.GetDecimal(s[1]))
                            {
                                return string.Concat(i, "#", "You Can not Increase Approved Quantity").ToString();
                            }


                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, @"INSERT INTO st_purchaseorder_details_edited
            (PurchaseOrderID,PurchaseOrderNo,ItemID, ItemName,ManufactureID,  ManufactureName,   CatalogNo,MachineID, MachineName,
            MajorUnitId,MajorUnitName,PackSize,OrderedQty,CheckedQty,ApprovedQty,VendorIssueQty,GRNQty,RejectQtyByUser,
            RejectQtyByVendor,RejectByUserID,RejectByVendorID,Rate,TaxAmount,DiscountAmount,DiscountPercentage,NetAmount,
            TotalAmount,IsFree,UnitPrice,RejectQty,RejectByUserName,RejectReason,IsActive,UpdatedByID,UpdatedByName,vendorcommentitem,Updatedate)
            
            SELECT PurchaseOrderID,PurchaseOrderNo,ItemID, ItemName,ManufactureID,  ManufactureName,   CatalogNo,MachineID, MachineName,
            MajorUnitId,MajorUnitName,PackSize,OrderedQty,CheckedQty,ApprovedQty,VendorIssueQty,GRNQty,RejectQtyByUser,
            RejectQtyByVendor,RejectByUserID,RejectByVendorID,Rate,TaxAmount,DiscountAmount,DiscountPercentage,NetAmount,
            TotalAmount,IsFree,UnitPrice,RejectQty,RejectByUserName,RejectReason,IsActive," + UserInfo.ID + ",'" + UserInfo.LoginName + "',vendorcommentitem,NOW() FROM st_purchaseorder_details WHERE ID='" + Util.GetString(s[3]) + "' ");



                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE st_purchaseorder_details SET ApprovedQty=@ApprovedQty,NetAmount=@NetAmount WHERE ID=@ID  ",
                                new MySqlParameter("@ApprovedQty", Util.GetDecimal(s[1])), new MySqlParameter("@NetAmount", Util.GetDecimal(s[1]) * Util.GetDecimal(s[4])),
                                new MySqlParameter("@ID", Util.GetString(s[3]))
                                );




                            if (Util.GetString(s[5]) != string.Empty)
                            {
                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE st_indent_detail SET POQty=(POQty-(" + Util.GetDecimal(dt.Rows[0]["ApprovedQty"].ToString()) + "-@POQty)) WHERE IndentNo=@IndentNo AND ItemID=@ItemID ",
                               new MySqlParameter("@POQty", Util.GetDecimal(s[1])), new MySqlParameter("@IndentNo", Util.GetString(s[5])), new MySqlParameter("@ItemID", Util.GetString(s[0])));
                            }

                        }

                    }

                    StringBuilder sb = new StringBuilder();
                    sb.Append(" UPDATE `st_purchaseorder` po ");
                    sb.Append(" SET po.`GrossTotal` = ( SELECT SUM(`Rate`*`ApprovedQty`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND pod.IsActive=1), ");
                    sb.Append(" po.`DiscountOnTotal`= ( SELECT SUM(`DiscountAmount`*`ApprovedQty`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND pod.IsActive=1), ");
                    sb.Append(" po.`TaxAmount`= ( SELECT SUM(`TaxAmount`*`ApprovedQty`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND pod.IsActive=1), ");
                    sb.Append(" po.`NetTotal`= ( SELECT SUM(`NetAmount`) FROM `st_purchaseorder_details` pod WHERE po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND IsFree=0 AND pod.IsActive=1), ");
                    sb.Append(" po.IsEdited=2,po.LastEditDate=now(),po.LastEditByID='" + UserInfo.ID + "',po.LastEditByName='" + UserInfo.LoginName + "' ");
                    sb.Append(" WHERE  po.`PurchaseOrderID`=@PurchaseOrderID ");

                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@PurchaseOrderID", PurchaseOrderID)
                        );

                    Tranx.Commit();
                    return "1";
                }
                catch (Exception ex)
                {
                    Tranx.Rollback();
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
    [WebMethod]
    public static string bindPORejectDetail(string PurchaseOrderID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT pod.ID PurchaseOrderDetailID,pod.ItemName,pod.ItemID,pod.ManufactureName,pod.CatalogNo,pod.MachineName,pod.ApprovedQty,pod.IsFree,");
        sb.Append(" pod.OrderedQty,(pod.ApprovedQty-(RejectQtyByUser+RejectQtyByVendor+pod.GRNQty))RejectQty,pod.UnitPrice,pod.DiscountPercentage,pod.NetAmount,pod.MajorUnitName,pod.PackSize,pod.GRNQty,pod.PurchaseOrderID ");
        sb.Append(" FROM `st_purchaseorder_details` pod  ");
        sb.Append(" WHERE pod.PurchaseOrderID='" + PurchaseOrderID + "' AND (pod.ApprovedQty-(RejectQtyByUser+RejectQtyByVendor+pod.GRNQty))>0 AND  pod.IsActive=1");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            return Util.getJson(dt);
        }
    }
    [WebMethod]
    public static string rejectPO(List<string[]> POItemData, string PurchaseOrderID, string RejectReason)
    {
        var POData = POItemData.Where(s => string.IsNullOrWhiteSpace(Util.GetString(s[1])) || Util.GetDecimal(s[1]) == 0).ToList();
        if (POData.Count > 0)
        {
            return string.Concat(POItemData[0][7].Trim(), "$", "Please Enter Valid Qty.").ToString(); ;
        }
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    int i = 2;
                    foreach (string[] s in POItemData)
                    {
                        i += 1;
                        if (Util.GetDecimal(s[1]) == 0)
                        {
                            return string.Concat(i, "$", "Please Enter Valid Qty.").ToString();
                        }

                        using (DataTable dt = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, "SELECT (ApprovedQty-GRNQty)RejectQty FROM st_purchaseorder_details WHERE ID=@ID",
                              new MySqlParameter("@ID", Util.GetString(s[3]))).Tables[0])
                        {

                            if (Util.GetDecimal(dt.Rows[0]["RejectQty"].ToString()) < Util.GetDecimal(s[1]))
                            {
                                return string.Concat(i, "#", "Qty Cannot Greater then Approved and GRN Quantity").ToString();
                            }
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE st_purchaseorder_details SET RejectByUserName=@RejectByUserName, RejectQtyByUser=@RejectQtyByUser,RejectByUserID=@RejectByUserID,RejectReason=@RejectReason WHERE ID=@ID",
                              new MySqlParameter("@RejectByUserName", UserInfo.LoginName), new MySqlParameter("@RejectByUserID", UserInfo.ID),
                               new MySqlParameter("@RejectQtyByUser", s[1]), new MySqlParameter("@RejectReason", RejectReason), new MySqlParameter("@ID", s[3]));

                            if (Util.GetString(s[5]) != string.Empty)
                            {
                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE st_indent_detail SET POQty=(POQty-@RejectQty) ,`RejectionReason`=@RejectReason,`RejectBy`=@RejectByUserName WHERE IndentNo=@IndentNo AND ItemID=@ItemID ",
                                new MySqlParameter("@RejectQty", s[1]), new MySqlParameter("@IndentNo", Util.GetString(s[5]).Trim()),
                                new MySqlParameter("@RejectByUserName", UserInfo.LoginName), new MySqlParameter("@RejectReason", RejectReason),
                                new MySqlParameter("@ItemID", Util.GetString(s[0])));

                               

                            }
                        }
                    }


                    //----Item reject if case exists 1 item-------------------------------------------------
                    StringBuilder sb = new StringBuilder();

                      sb.Append(" SELECT SUM(IF(ApprovedQty=0,IF(checkedqty=0,OrderedQty,checkedqty),ApprovedQty) -GRNQty-RejectQtyByUser) totalqty ");
                      sb.Append(" FROM `st_purchaseorder_details` WHERE `PurchaseOrderID`='" + PurchaseOrderID + "' AND isactive=1 and GRNQty=0 ");

                      DataTable dtCheck = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, sb.ToString()).Tables[0];
                      if (dtCheck.Rows.Count > 0)
                      {
                          if (Util.GetFloat(dtCheck.Rows[0]["totalqty"]) == 0)
                          {
                              MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE st_purchaseorder SET RejectedDate=now(),RejectedByID=@RejectByUserID,RejectedByName=@RejectByUserName,RejectReason=@RejectReason,STATUS=3,StatusName='Rejected'     WHERE PurchaseOrderID=@PurchaseOrderID",
                            new MySqlParameter("@RejectByUserName", UserInfo.LoginName), new MySqlParameter("@RejectByUserID", UserInfo.ID),
                             new MySqlParameter("@PurchaseOrderID", PurchaseOrderID), new MySqlParameter("@RejectReason", RejectReason));
                          }
                      }

                    
                    //----------------------------------------------------------------------------------------

                    Tranx.Commit();
                    return "1";

                }
                catch (Exception ex)
                {
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
}
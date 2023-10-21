using CrystalDecisions.CrystalReports.Engine;
using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;

public partial class Design_Store_POReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {

            string POID = Common.Decrypt(Util.GetString(Request.QueryString["POID"]));
            string ImageToPrint = Common.Decrypt(Util.GetString(Request.QueryString["ImageToPrint"]));
            string Type = Util.GetString(Request.QueryString["Type"]);
            GetPOReport(POID, ImageToPrint, Type);
        }
    }

    private void GetPOReport(string POID, string ImageToPrint, string Type)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select po.`CreatedByName`, po.`CheckedByName`,po.`AppprovedByName`, po.status Status1,''  posign1,po.ApprovedByID, ");
        sb.Append(" if(po.IsEdited=1,concat('Amended PO Approved by ',po.LastEditByName,' on',DATE_FORMAT(po.LastEditDate,'%d-%b-%Y')),'') pomsg,");
        //sb.Append("  cm.centrecode,cm.centre, po.Warranty,po.NFANo,po.TermandCondition, sm.GSTIN DeliveryGSTN,sm.state deliveryState,sm.GSTINAddress deliveryGSTINAddress,(select house_no from employee_master where employee_id=po.CreatedByID) MakerUser, ");
        sb.Append("  cm.centrecode,cm.centre,po.NFANo,po.TermandCondition, sm.GSTIN DeliveryGSTN,sm.state deliveryState,sm.GSTINAddress deliveryGSTINAddress,sl.ContactPerson ContactPerson,sl.ContactPersonNo MakerUser,sl.`Location`,sl.ContactPersonEmail,fpm.`GSTTin`, ");
        //sb.Append(" ifnull(spt.DeliveryTerm,'') DeliveryPeriod,ifnull(spt.TermCondition,'') PaymentTerms,CONCAT(ifnull(sl.`ContactPerson`,''),' (',IFNULL(sl.ContactPersonNo,''),')',', ',ifnull(sl.`StoreLocationAddress`,'')) DeliveryAddress,  ");
sb.Append(" ifnull(spt.DeliveryTerm,'') DeliveryPeriod,ifnull(spt.TermCondition,'') PaymentTerms,CONCAT(ifnull(sl.`StoreLocationAddress`,'')) DeliveryAddress,  ");
        sb.Append(" (SELECT VendorNote FROM st_purchaseorder_footer_note)VendorNote,   ");
        sb.Append(" (SELECT FooterNote FROM st_purchaseorder_footer_note)FooterNote   ");
        sb.Append(" ,concat(cccm.CategoryTypeName,'~',ssb.`Name`) Category,''ForPaymentStatusContact ,CONCAT(IF(img.`ItemNameGroup` <>'',CONCAT('Item :',img.`ItemNameGroup`),''),  IF(im.packsize <>'',CONCAT(' Packsize :',im.packsize),''),IF(im.ManufactureName <>'',CONCAT(' Mfr :',im.ManufactureName),''),IF(im.MachineName <>'',CONCAT(' Mac :',im.MachineName),''))Discription,im.`HsnCode` HSN_SAC_CODE,pod.`MajorUnitName` UOM,   ");
		sb.Append(" im.ApolloItemCode posign,im.packsize CGST,im.CatalogNo `User`,im.ManufactureName `status`,im.MachineName Warranty,img.ItemNameGroup ItemName,");
        sb.Append(" `TrimZero`(pod.`ApprovedQty`) Qty,`TrimZero`(pod.`Rate`) UnitRate, `TrimZero`(pod.`UnitPrice`)UnitPrice,  ");
        sb.Append(" `TrimZero`(pod.`DiscountAmount`) Disc,(TrimZero(pot.CGSTTax)+TrimZero(pot.SGSTax)+TrimZero(pot.IGSTTax)) Tax,   ");
        sb.Append(" TrimZero(IFNULL(pot.CGSTTaxAmt,'0')) CGST1,TrimZero(IFNULL(pot.SGSTaxAmt,'0'))SGST, TrimZero(IFNULL(pot.IGSTTaxAmt,'0')) IGST,   ");
        sb.Append(" TrimZero((pod.orderedQty * pod.unitprice)) Amount, (pod.`ApprovedQty`*pod.UnitPrice) finalprice,   ");
        if (Type == "0")
        {
            sb.Append(" po.`PurchaseOrderNo` PONumber,DATE_FORMAT(po.CreatedDate,'%d-%b-%Y')PODate,    ");
        }
        else
        {
            sb.Append(" po.`PurchaseOrderNo` PONumber,DATE_FORMAT(ifnull(po.ApprovedDate,po.CreatedDate),'%d-%b-%Y')PODate,    ");
           
        }
        sb.Append(" po.`VendorName` VendorName,ven.`PrimaryContactPerson` VendorContactPerson,ifnull((select Address from st_supplier_gstn where supplierID=ven.`SupplierID` and StateID=sm.`id` limit 1),po.`VendorAddress`) VendorAddress,   ");
        //sb.Append(" ven.`PrimaryContactPersonMobileNo` VendorMobile,ven.`EmailId` VendorEmail,po.`VendorGSTIN` VendorGSTIN,   ");
        sb.Append(" ven.`PrimaryContactPersonMobileNo` VendorMobile,ven.`EmailId` VendorEmail,(select GST_No from st_supplier_gstn where supplierID=ven.`SupplierID` and StateID=sm.`id` limit 1) VendorGSTIN,   ");
        sb.Append(" (select state from st_supplier_gstn where supplierID=ven.`SupplierID`AND StateID = ven.state  ) VendorState," + ImageToPrint + " ImageToPrint , ItemName   ");
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
        sb.Append(" LEFT JOIN st_purchaseorder_termsandconditions spt ON spt.`PurchaseOrderID`=po.`PurchaseOrderID`  ");
        sb.Append(" LEFT JOIN      ");
        sb.Append(" (  SELECT pot.ItemID ,pot.PurchaseOrderID,  sum(IF(pot.TaxName='IGST',IFNULL(pot.Percentage,0),0))IGSTTax,sum(IF(pot.TaxName='IGST',IFNULL(pot.TaxAmt,0),0))IGSTTaxAmt,   ");
        sb.Append(" sum(IF(pot.TaxName='CGST',(pot.Percentage),0))CGSTTax,sum(IF(pot.TaxName='CGST',(pot.TaxAmt),0))CGSTTaxAmt,sum(IF(pot.TaxName='SGST',(pot.Percentage),0))SGSTax ,sum(IF(pot.TaxName='SGST',(pot.TaxAmt),0))SGSTaxAmt  ");
        sb.Append(" FROM  st_purchaseorder_tax pot WHERE pot.PurchaseOrderID='" + POID + "' GROUP BY ItemID )pot     ON  pot.ItemID=pod.ItemID     and pot.PurchaseOrderID=pod.PurchaseOrderID");
        if (Type == "0")
        {
            sb.Append(" WHERE po.PurchaseOrderID = '" + POID + "'  GROUP BY pod.ItemName ORDER BY pod.ItemName  ");//

        }
        else
        {
            sb.Append(" WHERE po.PurchaseOrderID = '" + POID + "' and po.status in('2','5') GROUP BY pod.ItemName  ORDER BY pod.ItemName  ");//
        }
		//System.IO.File.WriteAllText(@"C:\ITDose\Code\Yoda_live\Design\Store\poreport.txt",sb.ToString());
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "User1";
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
            string path = Server.MapPath("~/Design/Store/POSign/" + dt.Rows[0]["ApprovedByID"] + ".jpg");
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
                Session["ItemsDetail"] = ds;
                Response.Redirect("POReportpdf.aspx", false);
                //ds.WriteXmlSchema(@"E:\POReport.xml");
                //using (ReportDocument obj1 = new ReportDocument())
                //{
                //    obj1.Load(Server.MapPath(@"~\Design\Store\Report\PurchaseOrderReport.rpt"));
                //    obj1.SetDataSource(ds);
                //    System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                //    obj1.Close();
                //    Response.ClearContent();
                //    Response.ClearHeaders();
                //    Response.Buffer = true;
                //    Response.ContentType = "application/pdf";
                //    Response.BinaryWrite(m.ToArray());

                //}
                using (ReportDocument obj1 = new ReportDocument())
                {

                    try
                    {
                        //if (Type == "0")
                        //{
                        //    rpt.Load(Server.MapPath(@"~\Design\Store\Report\PurchaseOrderReportPreview.rpt"));
                        //}
                        //else
                        //{
                        //    rpt.Load(Server.MapPath(@"~\Design\Store\Report\PurchaseOrderReport.rpt"));
                        //}
                        obj1.SetDataSource(ds);
                        System.IO.Stream m = (System.IO.Stream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                        byte[] byteArray = new byte[m.Length];
                        m.Read(byteArray, 0, Convert.ToInt32(m.Length - 1));
                        //if (Util.GetString(Request.QueryString["IsDownload"]) == "1")
                        //{
                        //    ExportFormatType formatType = ExportFormatType.NoFormat;
                        //    formatType = ExportFormatType.PortableDocFormat;

                        //    obj1.ExportToHttpResponse(formatType, Response, true, "Invoice_" + InvoiceNo);
                        //    Response.End();
                        //}
                        obj1.Close();
                        obj1.Dispose();
                        Response.ClearContent();
                        Response.ClearHeaders();
                        Response.Buffer = true;
                        Response.ContentType = "application/pdf";

                        Response.BinaryWrite(byteArray);
                        Response.Flush();
                        Response.Close();
                    }
                    catch (Exception ex)
                    {
                        ClassLog objClassLog = new ClassLog();
                        objClassLog.errLog(ex);
                    }
                    finally
                    {
                        obj1.Close();
                        obj1.Dispose();

                        // ds.Clear();
                    }
                }
            }
        }
    }

}

using CrystalDecisions.CrystalReports.Engine;
using System;
using System.Data;
using System.Text;

public partial class Design_Store_GRNReceipt : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            string PONumber = Util.GetString(Request.QueryString["GRNNO"]);

            GetPOReport(PONumber, 0);
        }   
    }

    private void GetPOReport(string grnno, int isMail)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  ");
		sb.Append(" (IF((SELECT username FROM f_login  WHERE employeeid=userid LIMIT 1)=1,'Itdose Team',(SELECT username FROM f_login WHERE employeeid=userid LIMIT 1))) username, ");
		sb.Append(" (IF((SELECT username FROM f_login  WHERE employeeid=PostUserID LIMIT 1)=1,'Itdose Team',(SELECT username FROM f_login WHERE employeeid=PostUserID LIMIT 1))) postname, ");
		sb.Append(" (select location from st_locationmaster where locationid=lt.locationid) Location,lt.LedgerTransactionNo,DATE_FORMAT(lt.datetime,'%d-%b-%Y') grndate,vm.SupplierName Vendorname,vm.EmailId VendorEmailId,HouseNo VendorAddress, vm.Street City, ");
        sb.Append(" vm.PinCode,vm.Landline Telephone,vm.PrimaryContactPersonMobileNo Mobile,");
        sb.Append(" IF(im.IsExpirable=0,' ',DATE_FORMAT(st.ExpiryDate,'%d-%b-%Y'))ExpiryDate,");
        sb.Append("  st.BatchNumber,st.ItemName,st.ItemID, st.MajorUnit unittype,trimzero(Rate*st.InitialCount) Rate,trimzero(DiscountPer)DiscountPer,trimzero(DiscountAmount*st.InitialCount)DiscountAmount,trimzero(st.unitprice*st.InitialCount)unitprice,trimzero(lt.netamount)netamount,trimzero(lt.Freight)Freight, st.unitprice*(st.InitialCount)unitprice1,trimzero(lt.Octori)Octori ,trimzero(lt.RoundOff)RoundOff,lt.InvoiceNo, lt.ChalanNo ,lt.PurchaseOrderNo,");
        sb.Append(" IFNULL((SELECT round(percentage,2) FROM st_taxchargedlist WHERE `stockid`=st.stockid   AND taxname='IGST') ,'0') IGSTPer,");
        sb.Append(" IFNULL((SELECT round(percentage,2) FROM st_taxchargedlist WHERE `stockid`=st.stockid   AND taxname='CGST') ,'0') CGSTPer,");
        sb.Append(" IFNULL((SELECT round(percentage,2) FROM st_taxchargedlist WHERE `stockid`=st.stockid   AND taxname='SGST') ,'0') SGSTPer ,");
        sb.Append(" IF(st.IsFree=0,'No','Yes')IsFree ,(st.InitialCount/st.Converter)Quantity,emp.NAME UserName,st.Naration,lt.iscancel,im.CatalogNo ");
        sb.Append(" from st_ledgertransaction lt");
        sb.Append(" INNER JOIN `st_vendormaster` vm ON vm.SupplierID=lt.vendorid ");
        sb.Append(" INNER JOIN st_nmstock st ON lt.LedgerTransactionID=st.LedgerTransactionID   ");

        sb.Append(" INNER JOIN employee_master emp ON emp.Employee_ID=st.UserID    ");

        sb.Append("  INNER JOIN st_itemmaster im ON im.ItemID=st.ItemID    ");
        sb.Append("  WHERE lt.LedgerTransactionID='" + grnno + "' ");



        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {

            DataColumn dc = new DataColumn();
            dc.ColumnName = "User";
            dc.DefaultValue = Convert.ToString(Session["ID"]);
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "AmountInWord";

            dc.DefaultValue = "";
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "Grndetail";
            Session["Grndetail"] = ds;
            Response.Redirect("GRNReceiptpdf.aspx", false);


          //  ds.WriteXmlSchema(@"D:\GRN.xml");



           // ReportDocument obj1 = new ReportDocument();
          

            //ds.WriteXmlSchema(@"D:\NewIndent.xml");

            ReportDocument obj1 = new ReportDocument();
            try
            {
                obj1.SetDataSource(ds);
                System.IO.Stream m = (System.IO.Stream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                byte[] byteArray = new byte[m.Length];
                m.Read(byteArray, 0, Convert.ToInt32(m.Length - 1));
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
            //obj1.Load(Server.MapPath("~/Design/Store/Report/GRNReceipt.rpt"));
            //obj1.SetDataSource(ds);
            //System.IO.Stream m = (System.IO.Stream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
            //byte[] byteArray = new byte[m.Length];
            //m.Read(byteArray, 0, Convert.ToInt32(m.Length - 1));
            //obj1.Close();
            //obj1.Dispose();
            //Response.ClearContent();
            //Response.ClearHeaders();
            //Response.Buffer = true;
            //Response.ContentType = "application/pdf";

            //Response.BinaryWrite(byteArray);
        }



    }
}
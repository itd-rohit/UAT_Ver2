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

            string fromdate = Util.GetString(Request.QueryString["fromdate"]);
            string todate = Util.GetString(Request.QueryString["todate"]);
            string type = Util.GetString(Request.QueryString["type"]);
            GetPOReport(fromdate);
        }   
    }

    private void GetPOReport(string fromdate)
    {
        StringBuilder str = new StringBuilder();
        str.Append(" SELECT lt.LedgerTransactionNo,lt.`GatePassInWard`,im.typename,im.MachineName MacName,(SELECT NAME FROM st_manufacture_master mm WHERE MAnufactureID=im.MAnufactureID) ManuFacturer,st.`Naration`,st.MajorUnit UnitType,DATE_FORMAT(lt.DATETime,'%d-%M-%y')DATE, ");
        str.Append(" lt.DateTime TIME,lt.PurchaseOrderNo AgainstPONo,iv.InvoiceNo,iv.ChalanNo,lt.NetAmount,lt.Freight, ");
        str.Append(" ltd.ItemID,ltd.ItemName,ltd.DiscountPercentage,(ltd.Quantity/st.Converter)Quantity,(ltd.Rate*st.Converter)Rate,ltd.Amount,ltd.StockID, ");
        str.Append(" st.BatchNumber,(st.UnitPrice)UnitPrice,st.MRP,DATE_FORMAT(st.ExpiryDate,'%d-%b-%y') MedExpiryDate, ");
        str.Append(" st.IsPost,if(st.IsFree=1,'Yes','No') IsFree,DATE_FORMAT(st.PostDate,'%d-%b-%y') PostDate, ");
        //str.Append(" SELECT NAME FROM st_subcategorymaster stm WHERE SubCategoryID = stm.subcategoryid )SubName, ");
        str.Append(" (SELECT TaxName FROM st_taxmaster WHERE TaxID=tcl.ID)TaxName,tcl.Percentage,DATE_FORMAT(iv.ChalanDate,'%d-%b-%y') ChalanDate,  DATE_FORMAT(iv.InvoiceDate,'%d-%b-%y') InvoiceDate ");

        //str.Append(" ,if(lt.Netamount<>0,((lt.Adjustment*ltd.amount)/lt.Netamount),0)PaidAmount ");
        str.Append(" ,(SELECT suppliername FROM st_vendormaster limit 1) vendorname");

        str.Append(" FROM st_ledgertransaction lt INNER JOIN st_ledgertnxdetail ltd ");
        str.Append("  INNER JOIN st_itemmaster im ON im.itemid = ltd.itemid  ");


        str.Append(" INNER JOIN st_nmstock st  ");

        str.Append(" INNER JOIN st_invoicemaster iv  ");
        str.Append(" LEFT JOIN st_taxchargedlist tcl ON lt.LedgerTransactionNo = tcl.LedgerTransactionNo AND ltd.StockID = tcl.StockID    ");


        str.Append("  AND lt.IsCancel=0  ");       		


        DataTable dt = new DataTable();
		System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\grno.txt",str.ToString());
        dt = StockReports.GetDataTable(str.ToString());
        if (dt.Rows.Count > 0)
        {
			
			DataSet ds =  (DataSet)Session["ds"];


          //  ds.WriteXmlSchema(@"D:\GRN.xml");
		  string type="ItemCategoryWise";
            if (type != null)
            {
                ReportDocument obj1 = new ReportDocument();                               
                if (type == "ItemCategoryWise")
                    obj1.Load(Server.MapPath("~/Design/Store/Report/ItemWiseReceipt.rpt"));
                if (type == "DateWise")
                    obj1.Load(Server.MapPath("../DateWiseReceipt.rpt"));
                if (type == "VendorWise")
                    obj1.Load(Server.MapPath("../VendorWiseReceipt.rpt"));
                if (type == "ItemCategoryWise")
                    obj1.Load(Server.MapPath("../CategoryWiseReceipt.rpt"));


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
            }
        }



    }
}
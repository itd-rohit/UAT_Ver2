using CrystalDecisions.CrystalReports.Engine;
using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;


public partial class Design_Store_VendorReturnReceipt : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  ");

            sb.Append(" SELECT stv.`VendorReturnNo`, stv.`VendorID`,sv.`Suppliername` ,stv.`LocationID`,sl.location,st.`ItemName`,st.`BatchNumber`, ");
            sb.Append(" DATE_FORMAT(st.`ExpiryDate`,'%d-%b-%Y') ExpiryDate,st.`Rate`,st.`DiscountAmount`,st.taxamount `TaxPer`,st.`UnitPrice`, ");
            sb.Append(" stv.Remark,stv.`UserName`,DATE_FORMAT(stv.EntryDateTime,'%d-%b-%Y')`EntryDateTime`,stv.`ReturnQty`,st.`MinorUnit` ");
            sb.Append(" FROM st_vendor_return stv ");
            sb.Append(" INNER JOIN `st_vendormaster` sv ON sv.`SupplierID`=stv.`VendorID`  ");
            sb.Append(" INNER JOIN st_locationmaster sl ON sl.LocationID=stv.`LocationID`  ");
            sb.Append(" INNER JOIN st_nmstock st ON st.`StockID`=stv.`StockID` AND st.`ItemID`=stv.`ItemID` ");
            sb.Append(" WHERE VendorReturnNo='" + Util.GetString(Request.QueryString["salesno"]) + "' ORDER BY itemname ");



            using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            {
                using (DataSet ds = new DataSet())
                {
                    ds.Tables.Add(dt.Copy());
                    ds.Tables[0].TableName = "VendorReturnReceipt";
                    //ds.WriteXmlSchema(@"E:\VendorReturnReceipt.xml");
                    using (ReportDocument rpt = new ReportDocument())
                    {

                        rpt.Load(Server.MapPath(@"~\Design\Store\Report\VendorReturnReceipt.rpt"));
                        
                        rpt.SetDataSource(ds);
                        System.IO.Stream oStream = null;
                        byte[] byteArray = null;
                        oStream = rpt.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                        byteArray = new byte[oStream.Length];
                        oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
                        Response.ClearContent();
                        Response.ClearHeaders();
                        Response.ContentType = "application/pdf";
                        Response.BinaryWrite(byteArray);
                        Response.Flush();
                        Response.Close();
                        rpt.Close();
                        oStream.Close();
                        oStream.Dispose();
                    }
                }
            }


        }
    }
}
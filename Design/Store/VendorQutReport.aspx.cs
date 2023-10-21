using CrystalDecisions.CrystalReports.Engine;
using System;
using System.Data;


public partial class Design_Store_VendorQutReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
        if (!IsPostBack)
        {
            String Qutation = Util.GetString(Request.QueryString["QutationNo"]);
         GetQutationReport(Qutation);

        }
    }

    private void GetQutationReport(string Qutation)
    {
               string str="SELECT Qutationno,(SELECT REPLACE(GROUP_CONCAT('# ',TermsCondition,'"+
        "'), ',', '')  FROM st_Qutationtermsconditions WHERE Qutationno=stv.Qutationno)"+
        "TermsCondition,VendorId Vendor_Id,VendorName vendor," +
        "DeliveryCentreName Center,DeliveryLocationName Location," +
         "ManufactureName Menufacture," +
         "ItemId,ItemName Item,'' MakeModel,HsnCode,VednorStateGstnno GSTno,TrimZero(Rate) Rate,Qty,TrimZero(DiscountPer)DiscountPer,TrimZero(IGSTPer)IGSTPer,TrimZero(SGSTPer)SGSTPer,TrimZero(CGSTPer)CGSTPer,ConversionFactor,PurchasedUnit," +
        "ConsumptionUnit,TrimZero(Finalprice)Finalprice,Finalprice Finalprice1, ApprovalStatus,Qty,(SELECT CatalogNo FROM st_itemmaster WHERE itemid=stv.`ItemID` LIMIT 1)  CatalogNo  FROM st_vendorqutation stv  where Qutationno='" + Qutation + "'";

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {

            var total = dt.Compute("sum(Finalprice1)", "");
            DataColumn dc = new DataColumn();
            dc.ColumnName = "FinalAmount";
            dc.DefaultValue = total;
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "AmountInWord";
            dc.DefaultValue = ConvertCurrencyInWord.AmountInWord(Util.GetDecimal(total), "INR");
            dt.Columns.Add(dc);

            var Qtytotal = dt.Compute("sum(Qty)", "");
            dc = new DataColumn();
            dc.ColumnName = "QtyInWord";
            dc.DefaultValue = ConvertCurrencyInWord.AmountInWord(Util.GetDecimal(Qtytotal), "INR");
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "QutationDetail";
            Session["QutationDetail"] = ds;
            Response.Redirect("VendorQutReportpdf.aspx", false);
            using (ReportDocument obj1 = new ReportDocument())
            {

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
            }
         
            //  ds.Tables.Add(dt.Copy());
          //  System.IO.Stream oStream = null;
            //try
            //{
            //   // ds.WriteXml(@"D:\Qutation.xml");

            //    ReportDocument obj1 = new ReportDocument();
            //    obj1.Load(Server.MapPath("~/Design/Store/Report/VendorQutation.rpt"));
            //    obj1.SetDataSource(ds);

            //    System.IO.Stream m = (System.IO.Stream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
            //    byte[] byteArray = new byte[m.Length];
            //    m.Read(byteArray, 0, Convert.ToInt32(m.Length - 1));
            //    obj1.Close();
            //    obj1.Dispose();
            //    Response.ClearContent();
            //    Response.ClearHeaders();
            //    Response.Buffer = true;
            //    Response.ContentType = "application/pdf";

            //    Response.BinaryWrite(byteArray);

            //}
            //catch (Exception ex)
            //{
            //    ClassLog objClassLog = new ClassLog();
            //    objClassLog.errLog(ex);
            //}
            //finally
            //{

            //    //oStream.Close();
            //    //oStream.Dispose();
            //}
        }
    }

}

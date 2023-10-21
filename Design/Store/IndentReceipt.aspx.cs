using CrystalDecisions.CrystalReports.Engine;
using System;
using System.Data;
using System.Text;

public partial class Design_Store_IndentReceipt : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        DataTable dt = new DataTable();
        if (Request.QueryString["IndentNo"] != null)
        {
            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" SELECT id.username,id.`CheckedUserName`,id.`ApprovedUserName`,if(id.IndentType='SI','STOCK INDENT','PURCHASE INDENT') IndentType, id.IndentNo,TrimZero(id.ReceiveQty) ReceiveQty,fr.`Location` AS FromLocation,fr.StoreLocationAddress FromLocationAddress,fr1.`Location` AS ToLocation, fr1.StoreLocationAddress ToLocationAddress,id.ItemName,TrimZero(IF(approvedqty=0,`ReqQty`,approvedqty)) OrderQty,id.MinorUnitName UnitType, TrimZero(Rate)Rate,TrimZero(Rate*DiscountPer*0.01)DiscountPer,TrimZero((Rate-(Rate*DiscountPer*0.01))*TaxPerIGST*0.01)TaxPerIGST,TrimZero((Rate-(Rate*DiscountPer*0.01))*TaxPerCGST*0.01)TaxPerCGST,TrimZero((Rate-(Rate*DiscountPer*0.01))*TaxPerSGST*0.01)TaxPerSGST,TrimZero(NetAmount)NetAmount,NetAmount NetAmount1, ");
            sb1.Append(" fr.GSTNNO FromGSTNNo,  ");
            sb1.Append(" fr1.GSTNNO ToGSTNNo,  ");
            sb1.Append(" id.Narration,if(reqqty=rejectqty,1,0) isApproved,DATE_FORMAT(id.dtEntry,'%d/%b/%Y %I:%i %p') dtEntry,  ");
            sb1.Append(" id.username EmpName ,ftm.HsnCode,ftm.CatalogNo ");
            sb1.Append(" FROM st_indent_detail  id    ");
            sb1.Append(" INNER JOIN st_itemmaster ftm ON id.ItemId=ftm.ItemID    ");

            sb1.Append(" INNER JOIN st_locationmaster fr ON fr.`locationid`=id.`Fromlocationid` ");
            
            sb1.Append(" INNER JOIN st_locationmaster fr1 ON fr1.`locationid`=id.`tolocationid` ");
            sb1.Append(" WHERE indentno='" + Request.QueryString["IndentNo"] + "' and id.IsActive=1  order by rate desc,itemname asc ");
			//System.IO.File.WriteAllText(@"C:\ITDose\Code\Yoda_live\Design\Store\indre.txt",sb1.ToString());
             dt = StockReports.GetDataTable(sb1.ToString());
            if (dt.Rows.Count > 0)
            {
               
                var total= dt.Compute("sum(NetAmount1)","");
                DataColumn dc = new DataColumn();
                dc.ColumnName = "FinalAmount";
                dc.DefaultValue = total;
                dt.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "AmountInWord";
                dc.DefaultValue = ConvertCurrencyInWord.AmountInWord(Util.GetDecimal(total), "INR");
                dt.Columns.Add(dc);

                

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());

              //  ds.Tables.Add(dt.Copy());
                ds.Tables[0].TableName = "IndentDetail";
                Session["IndentDetail"] = ds;
                Response.Redirect("IndentReceiptpdf.aspx", false);

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
                //obj1.Load(Server.MapPath(@"~\Design\Store\Report\NewIndent.rpt"));
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
}

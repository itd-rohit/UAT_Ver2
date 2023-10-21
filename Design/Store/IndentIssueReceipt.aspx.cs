using CrystalDecisions.CrystalReports.Engine;
using System;
using System.Data;
using System.Text;

public partial class Design_Store_IndentIssueReceipt : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        if (Util.GetString(Request.QueryString["Type"]) == "1")
        {
           
            if (Request.QueryString["BatchNumber"] != null)
            {
                StringBuilder sb1 = new StringBuilder();
                sb1.Append(" SELECT st.batchnumber itembatch,st.barcodeno,DATE_FORMAT(st.ExpiryDate,'%d-%b-%Y')ExpiryDate, sm.GSTIN FromGSTN,sm.state fromstate,sm1.state tostate, sm1.GSTIN ToGSTN, sid.batchnumber, sid.IssueInvoiceNo, if(id.IndentType='SI','SALES INDENT','PURCHASE INDENT') IndentType, id.IndentNo,TrimZero(id.ReceiveQty)ReceiveQty,fr.`Location` AS FromLocation,fr.storelocationaddress FromLocationAddress,fr1.`Location` AS ToLocation,fr1.storelocationaddress ToLocationAddress,id.ItemName,TrimZero(sid.sendqty) issueQty,id.MinorUnitName UnitType, TrimZero(st.Rate)Rate,TrimZero(ST.DiscountAmount)DiscountPer,TrimZero(ST.unitprice*sid.sendqty)NetAmount,ST.unitprice*sid.sendqty NetAmount1,st.TaxPer, ");


                sb1.Append(" if(fr.stateid<>fr1.stateid, ");
                sb1.Append(" TrimZero((ST.RATE-ST.DiscountAmount)*(IFNULL((SELECT sum(percentage) FROM st_taxchargedlist WHERE `stockid`=st.stockid   LIMIT 1) ,'0')*0.01)),0) TaxPerIGST");

                sb1.Append(" ,if(fr.stateid=fr1.stateid, ");
                sb1.Append(" TrimZero((ST.RATE-ST.DiscountAmount)*(IFNULL((SELECT sum(percentage)/2 FROM st_taxchargedlist WHERE `stockid`=st.stockid   LIMIT 1) ,'0')*0.01)),0) TaxPerCGST");


                sb1.Append(" ,if(fr.stateid=fr1.stateid, ");
                sb1.Append(" TrimZero((ST.RATE-ST.DiscountAmount)*(IFNULL((SELECT sum(percentage)/2 FROM st_taxchargedlist WHERE `stockid`=st.stockid   LIMIT 1) ,'0')*0.01)),0) TaxPerSGST");


                //sb1.Append("  TaxPerIGST,");
                //sb1.Append(" TrimZero((ST.RATE-ST.DiscountAmount)*(IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=st.stockid   AND taxname='CGST' LIMIT 1) ,'0')*0.01)) TaxPerCGST,");
                //sb1.Append(" TrimZero((ST.RATE-ST.DiscountAmount)*(IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=st.stockid   AND taxname='SGST' LIMIT 1) ,'0')*0.01)) TaxPerSGST,");
              




                sb1.Append(" ,fr.GSTNNO FromGSTNNo,  ");
                sb1.Append(" fr1.GSTNNO ToGSTNNo,  ");
                sb1.Append(" id.Narration,if(reqqty=id.rejectqty,1,0) isApproved,DATE_FORMAT(sid.datetime,'%d/%b/%Y %I:%i %p') dtEntry,  ");
                sb1.Append(" (select house_no from employee_master where employee_id=sid.UserID) EmpName ,ftm.HsnCode ");
                sb1.Append("");
                sb1.Append(" FROM st_indent_detail  id    ");
                sb1.Append(" INNER JOIN st_itemmaster ftm ON id.ItemId=ftm.ItemID    ");

                sb1.Append(" INNER JOIN st_locationmaster fr ON fr.`locationid`=id.`tolocationid` ");
                sb1.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=fr.`Panel_ID`  ");
                sb1.Append("  INNER JOIN centre_master cm on cm.`CentreID`=CASE WHEN fpm.`PanelType` ='Centre' then fpm.`CentreID` else fpm.tagprocessinglabid END AND fpm.`PanelType` in('Centre','PUP')   and fpm.IsActive=1   ");
                sb1.Append(" INNER JOIN state_master sm ON sm.`id`=cm.`StateID`  ");

                sb1.Append(" INNER JOIN st_locationmaster fr1 ON fr1.`locationid`=id.`Fromlocationid`  ");

                sb1.Append(" INNER JOIN f_panel_master fpm1 ON fpm1.`Panel_ID`=fr1.`Panel_ID`  ");
                sb1.Append("  INNER JOIN centre_master cm1 on cm1.`CentreID`=CASE WHEN fpm1.`PanelType` ='Centre' then fpm1.`CentreID` else fpm1.tagprocessinglabid END AND fpm1.`PanelType` in('Centre','PUP')   and fpm1.IsActive=1   ");
                sb1.Append(" INNER JOIN state_master sm1 ON sm1.`id`=cm1.`StateID`  ");

                sb1.Append(" inner join st_indentissuedetail sid on sid.indentno=id.indentno and sid.itemid=id.itemid");
                sb1.Append(" inner join st_nmstock st on st.stockid=sid.stockid and st.itemid=sid.itemid ");
                sb1.Append(" WHERE sid.IssueInvoiceNo='" + Request.QueryString["BatchNumber"] + "' and id.IsActive=1 group by sid.itemid,st.batchnumber,st.stockid order by id.rate desc,itemname asc ");

                dt = StockReports.GetDataTable(sb1.ToString());

                if (dt.Rows.Count > 0)
                {


                    var total = dt.Compute("sum(NetAmount1)", "");
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "FinalAmount";
                    dc.DefaultValue = total;
                    dt.Columns.Add(dc);

                    dc = new DataColumn();
                    dc.ColumnName = "AmountInWord";
                   try
                   {
                         dc.DefaultValue = ConvertNumberToRupees.GenerateWordsinRs(Math.Round(Util.GetDecimal(total),2).ToString());
                   }
                   catch
                   {
                     dc.DefaultValue =Util.GetString(total);
                         
                   }
                    dt.Columns.Add(dc);



                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());

                    ds.Tables[0].TableName = "BatchNumber";
                    Session["BatchNumber"] = ds;
                    Response.Redirect(@"~/Design/Store/IndentReceiptTax_Pdf.aspx", true);
                    //ds.WriteXmlSchema(@"D:\NewIndentIssue.xml");
                    ReportDocument obj1 = new ReportDocument();
                    //obj1.Load(Server.MapPath(@"~/Design/Store/Report/NewIndentIssue.rpt"));
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


            }
        }
        else if (Util.GetString(Request.QueryString["Type"]) == "2")
        {
            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" SELECT fr.`Location` AS FromLocation,fr.`StoreLocationAddress` FromLocationAddress,fr1.`Location` AS ToLocation, ");
            sb1.Append(" fr1.`StoreLocationAddress` ToLocationAddress, sm.GSTIN FromGSTNNo,sm1.GSTIN ToGSTNNo   ");
            sb1.Append("  FROM st_indent_detail  id     ");
            sb1.Append("  INNER JOIN st_locationmaster fr ON fr.`locationid`=id.`tolocationid`  ");
            sb1.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=fr.`Panel_ID`  ");
            sb1.Append("  INNER JOIN centre_master cm on cm.`CentreID`=CASE WHEN fpm.`PanelType` ='Centre' then fpm.`CentreID` else fpm.tagprocessinglabid END AND fpm.`PanelType` in('Centre','PUP')   and fpm.IsActive=1   ");
            sb1.Append(" INNER JOIN state_master sm ON sm.`id`=cm.`StateID`  ");          
            sb1.Append(" INNER JOIN st_locationmaster fr1 ON fr1.`locationid`=id.`Fromlocationid`");
            sb1.Append(" INNER JOIN f_panel_master fpm1 ON fpm1.`Panel_ID`=fr1.`Panel_ID`  ");
            sb1.Append("  INNER JOIN centre_master cm1 on cm1.`CentreID`=CASE WHEN fpm1.`PanelType` ='Centre' then fpm1.`CentreID` else fpm1.tagprocessinglabid END AND fpm1.`PanelType` in('Centre','PUP')   and fpm1.IsActive=1   ");
            sb1.Append(" INNER JOIN state_master sm1 ON sm1.`id`=cm1.`StateID`  ");
          //  sb1.Append(" INNER JOIN st_locationmaster fr1 ON fr1.`locationid`=id. `Fromlocationid` ");
            sb1.Append(" WHERE indentno='" + Request.QueryString["IndentNo"] + "' and id.IsActive=1  group by indentno ");


            dt = StockReports.GetDataTable(sb1.ToString());
            if (dt.Rows.Count > 0)
            {


                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());

                ds.Tables[0].TableName = "DsIndentAddress";
                Session["DsIndentAddress"] = ds;
                Response.Redirect(@"~/Design/Store/IndentAddresspdf.aspx", true);

               // ds.WriteXmlSchema(@"D:\NewIndentIssueAddress.xml");

                ReportDocument obj1 = new ReportDocument();
               // obj1.Load(Server.MapPath(@"~/Design/Store/Report/NewIndentIssueAddress.rpt"));
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


        else if (Util.GetString(Request.QueryString["Type"]) == "4")
        {
            String stockid = Request.QueryString["BatchNumber"].ToString();
            stockid = "'" + stockid + "'";
            stockid = stockid.Replace(",", "','");
            StringBuilder sb1 = new StringBuilder();

            sb1.Append("  SELECT sm.GSTIN FromGSTN,sm.state fromstate,sm1.state tostate, sm1.GSTIN ToGSTN,  ");
            sb1.Append(" '' batchnumber, '' IssueInvoiceNo, ''  IndentType,  ");
            sb1.Append(" id.IndentNo,TrimZero(id.`InitialCount`)ReceiveQty,fr.`Location` AS FromLocation, ");
            sb1.Append(" fr.storelocationaddress FromLocationAddress,fr1.`Location` AS ToLocation, ");
            sb1.Append(" fr1.storelocationaddress ToLocationAddress,id.ItemName,TrimZero(id.InitialCount) issueQty, ");
            sb1.Append(" id.MinorUnit UnitType, TrimZero(Rate)Rate,TrimZero(Rate*DiscountPer*0.01)DiscountPer, ");
            sb1.Append(" '0' TaxPerIGST,'0' TaxPerCGST,'0' TaxPerSGST, ");
            sb1.Append(" '0' NetAmount,0 NetAmount1,  ");
            sb1.Append("      fr.GSTNNO FromGSTNNo,   ");
            sb1.Append("   fr1.GSTNNO ToGSTNNo,   ");
            sb1.Append("  '' Narration,1 isApproved,DATE_FORMAT(id.StockDate,'%d/%b/%Y %I:%i %p') dtEntry,    ");
            sb1.Append("  (SELECT NAME FROM employee_master WHERE employee_id=id.UserID) EmpName ,ftm.HsnCode   ");
            sb1.Append("  FROM `st_nmstock`  id      ");
            sb1.Append("  INNER JOIN st_itemmaster ftm ON id.ItemId=ftm.ItemID      ");

            sb1.Append("  INNER JOIN st_locationmaster fr ON fr.`locationid`=id.`Fromlocationid`  ");
            sb1.Append("  INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=fr.`Panel_ID`    ");
            sb1.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=fpm.`CentreID`    ");
            sb1.Append("  INNER JOIN state_master sm ON sm.`id`=cm.`StateID`    ");

            sb1.Append("   INNER JOIN st_locationmaster fr1 ON fr1.`locationid`=id.`locationid`    ");
            sb1.Append("   INNER JOIN f_panel_master fpm1 ON fpm1.`Panel_ID`=fr1.`Panel_ID`    ");
            sb1.Append("   INNER JOIN centre_master cm1 ON cm1.`CentreID`=fpm1.`CentreID`    ");
            sb1.Append("   INNER JOIN state_master sm1 ON sm1.`id`=cm1.`StateID`    ");


            sb1.Append("  WHERE id.stockid in (" + stockid + ") ORDER BY rate DESC,itemname ASC  ");

            dt = StockReports.GetDataTable(sb1.ToString());
            if (dt.Rows.Count > 0)
            {


                var total = dt.Compute("sum(NetAmount1)", "");
                DataColumn dc = new DataColumn();
                dc.ColumnName = "FinalAmount";
                dc.DefaultValue = total;
                dt.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "AmountInWord";
                dc.DefaultValue = ConvertCurrencyInWord.AmountInWord(Util.GetDecimal(total), "INR");
                dt.Columns.Add(dc);



                //DataSet ds = new DataSet();
                //ds.Tables.Add(dt.Copy());

                ////ds.WriteXmlSchema(@"D:\NewIndentIssue.xml");

                ReportDocument obj1 = new ReportDocument();
                //obj1.Load(Server.MapPath(@"~/Design/Store/Report/NewIndentIssue.rpt"));

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());

                ds.Tables[0].TableName = "BatchNumber";
                Session["BatchNumber"] = ds;
                Response.Redirect(@"~/Design/Store/IndentReceiptTax_Pdf.aspx", true);
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
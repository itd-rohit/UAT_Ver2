using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_Master_InvoiceReceipt : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string InvoiceNo =Common.Decrypt(Request.QueryString["InvoiceNo"]);
            if (Request.QueryString["IsDownload"] != null)
            {
                InvoiceDetailReport(InvoiceNo);
            }
            else
            {
                GetInvoice(InvoiceNo);
            }
        }
    }

    private void GetInvoice(string InvoiceNo)
    {
        InvoiceNo = InvoiceNo.Replace(",", "','").TrimEnd(',');
        StringBuilder sbInvoice = new StringBuilder();
        sbInvoice.Append(" SELECT *,ROUND(IFNULL(im.`NetAmount`,0)-IFNULL(SUM(a.`ReceivedAmt`),0)) ClosingAmount FROM ( ");
        sbInvoice.Append(" SELECT im.`FromDate`,im.`ToDate`, PM.`GSTTin` AS PanelGSTNo, '' StateCode,InvoiceNo,'Delhi' as PanelID,pm.Company_Name PanelName,CONCAT(pm.Add1) Address,DATE_FORMAT(InvoiceDate,'%d-%m-%Y')InvoiceDate, ");
        sbInvoice.Append(" PM.Panel_code,pm.Mobile AS  Mobile,pm.EmailID,im.ShareAmt, ");
        sbInvoice.Append(" pm.Company_Name AS CentreName,CM1.`Landline` AS CentrePhone,CM1.`Email` AS CentreEmail,pm.GSTTin AS CentreGSTN ,");
        sbInvoice.Append(" 'Testing Charges for pathology samples for the period'TestingCharges,''PanNumber, ");
        sbInvoice.Append(" CONCAT('Form : ',DATE_FORMAT(fromDate,'%d-%b-%Y'),' To : ',DATE_FORMAT(toDate,'%d-%b-%Y')) Period,'' InvoiceType, ");
        sbInvoice.Append(" '~/Design/Centre/Image/ApolloHeader.jpg'HeaderImage, ");
        sbInvoice.Append(" IF(pm.InvoiceDisplayName='',pm.Company_Name, pm.InvoiceDisplayName)InvoiceDisplayName,'' AmountInWord,pm.`AccountNo`, pm.`BankID`,pm.`BankName`,pm.`PANNo`,pm.`IFSCCode`,DATE_FORMAT(InvoiceDate,'%b %Y')InvoiceMonth ");
        sbInvoice.Append(" FROM InvoiceMaster im INNER JOIN f_panel_master pm ON im.panelID=pm.panel_ID ");



        sbInvoice.Append(" LEft JOIN Centre_Master CM1 ON CM1.`CentreID`=pm.`CentreID` ");
        sbInvoice.Append(" WHERE InvoiceNo IN ('" + InvoiceNo + "')) t ");
        sbInvoice.Append("      LEFT JOIN `invoicemaster` im  ON im.`PanelID`=t.PanelID AND  im.`FromDate`<t.FromDate    ");
        sbInvoice.Append(" LEFT JOIN `invoicemaster_onaccount` a ON im.`PanelID`=a.`Panel_id`  AND t.PanelID=a.`Panel_id` AND a.`IsCancel`=0    AND a.`ReceivedDate`<t.FromDate ");

        DataTable dtInvoice = StockReports.GetDataTable(sbInvoice.ToString());
        StringBuilder sbCollectionSummary = new StringBuilder();
        sbCollectionSummary.Append("Select  Sum(ReceivedAmt) as Amount, PaymentMode from InvoiceMaster_OnAccount ");
        sbCollectionSummary.Append(" WHERE InvoiceNo IN ('" + InvoiceNo + "') and Iscancel=0 ");
        sbCollectionSummary.Append(" group by PaymentMode");
        DataTable dtCm = StockReports.GetDataTable(sbCollectionSummary.ToString());
        double PreviousInvoiceAmt;
        double PreviousReceivedAmt;
        DataTable dt = StockReports.GetDataTable(" Select PanelId,ToDate from InvoiceMaster where InvoiceNo IN ('" + InvoiceNo + "')  ");
        if (dt.Rows.Count > 0)
        {
            PreviousInvoiceAmt = Util.GetDouble(StockReports.ExecuteScalar(" Select  IFNULL(SUM(netamount),'0.00') previousInvoiceAmt from InvoiceMaster where InvoiceNo < '" + InvoiceNo + "' and iscancel=0 and PanelId='" + dt.Rows[0]["PanelId"] + "' AND invoiceno<>'' "));

        }
        else
        {
            PreviousInvoiceAmt = 0.00;
        }
        DataTable dt1 = StockReports.GetDataTable(" SELECT Panel_Id, MIN(ReceivedDate) as ReceivedDate FROM InvoiceMaster_OnAccount where InvoiceNo IN ('" + InvoiceNo + "')  ");
        if (dt.Rows.Count > 0)
        {
            PreviousReceivedAmt = Util.GetDouble(StockReports.ExecuteScalar(" Select IFNULL(SUM(ReceivedAmt),'0.00') previousReceivedAmt from InvoiceMaster_OnAccount where  InvoiceNo < '" + InvoiceNo + "' and Panel_Id='" + dt1.Rows[0]["Panel_Id"] + "' and iscancel=0  AND invoiceno<>'' "));
        }
        else
        {
            PreviousReceivedAmt = 0.00;
        }
        double OpeningBal;
        OpeningBal = PreviousInvoiceAmt - PreviousReceivedAmt;

        StringBuilder sbAccountSummary = new StringBuilder();
        sbAccountSummary.Append("Select  IFNULL(Sum(ReceivedAmt),'0.00') as CollectionAmount," + OpeningBal + "  as Amount from InvoiceMaster_OnAccount ");
        sbAccountSummary.Append(" WHERE InvoiceNo ='" + InvoiceNo + "' and Iscancel=0 ");
        DataTable dtAccountSumm = StockReports.GetDataTable(sbAccountSummary.ToString());
        if (dtInvoice.Rows.Count > 0)
        {
            //dtInvoice.Columns.Add("AmountInWord", typeof(string));

            for (int i = 0; i < dtInvoice.Rows.Count; i++)
            {
                AllLoad_Data ad = new AllLoad_Data();
                dtInvoice.Rows[i]["AmountInWord"] = ad.changeNumericToWords(Util.GetString(dtInvoice.Rows[i]["ShareAmt"])).ToString();
            }

            string headerimage = dtInvoice.Rows[0]["HeaderImage"].ToString();
            if (!string.IsNullOrEmpty(headerimage))
            {
                string HImage = headerimage;
                string path1 = System.Web.HttpContext.Current.Server.MapPath(HImage);
                System.IO.FileStream fs = new System.IO.FileStream(path1, System.IO.FileMode.Open, System.IO.FileAccess.Read);
                byte[] imgbyte = new byte[fs.Length + 1];
                fs.Read(imgbyte, 0, (int)fs.Length);
                fs.Close();
                byte[] bytes = System.Text.Encoding.UTF8.GetBytes((headerimage));
                DataColumn dcHeaderImageData = new DataColumn("HeaderImageData");
                dcHeaderImageData.DataType = System.Type.GetType("System.Byte[]");
                dcHeaderImageData.DefaultValue = imgbyte; ;
                dtInvoice.Columns.Add(dcHeaderImageData);
            }

            DataSet ds = new DataSet();
           // ReportDocument obj1 = new ReportDocument();
            //     System.IO.Stream m = (System.IO.Stream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
            try
            {
                dtInvoice.TableName = "Table";
                ds.Tables.Add(dtInvoice.Copy());
                dtCm.TableName = "Table1";
                ds.Tables.Add(dtCm.Copy());
                dtAccountSumm.TableName = "Table2";
                ds.Tables.Add(dtAccountSumm.Copy());

                // ds.WriteXmlSchema("G:/dtInvoice.xml");

                if (dtInvoice.Rows[0]["InvoiceType"].ToString().Trim() == "PUP")
                {
                   // obj1.Load(Server.MapPath("~/Reports/Invoice_PUP.rpt"));
                }
                else
                {
                    Session["DsInvoice"] = ds;
                    Response.Redirect("InvoiceReceiptNew.aspx", false);
                    //  obj1.Load(Server.MapPath("~/Reports/Invoice.rpt"));
                }
                // obj1.SetDataSource(ds);
                // System.IO.Stream m = (System.IO.Stream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                // byte[] byteArray = new byte[m.Length];
                // m.Read(byteArray, 0, Convert.ToInt32(m.Length - 1));

                // if (Util.GetString(Request.QueryString["IsDownload"]) == "1")
                // {
                    // ExportFormatType formatType = ExportFormatType.NoFormat;
                    // formatType = ExportFormatType.PortableDocFormat;

                    // obj1.ExportToHttpResponse(formatType, Response, true, "Invoice_" + InvoiceNo);
                    // Response.End();
                // }
                // obj1.Close();
                // obj1.Dispose();
                // Response.ClearContent();
                // Response.ClearHeaders();
                // Response.Buffer = true;
                // Response.ContentType = "application/pdf";

                // Response.BinaryWrite(byteArray);
                // Response.Flush();
                // Response.Close();
            }

            catch (Exception ex)
            {
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
            }
            finally
            {
               // obj1.Close();
                //obj1.Dispose();

                // ds.Clear();
            }
        }
    }

    private void InvoiceDetailReport(string InvoiceNo)
    {
        InvoiceNo = InvoiceNo.Replace(",", "','").TrimEnd(',');



        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT lt.PanelName as Client, concat('*',lt.LedgerTransactionNo)LedgerTransactionNo,Date_Format(lt.Date,'%d %b %Y') `Date of Billing` , CONCAT(pm.Title,' ',pm.PName)PName,CONCAT(pm.Age,'/',LEFT(pm.Gender,1))Age, lt.`HLMPatientType` 'HLM Patient Type',lt.`HLMOPDIPDNo` 'OPD/IPD No',  ");
        sb.Append(" if(plo.SubCategoryID=34,plo.PackageName,plo.InvestigationName) ItemName  ,plo.Rate,plo.Quantity,lt.GrossAmount,ROUND((IFNULL(((plo.Rate*plo.Quantity)-plo.Amount),0 )),2)Discount, lt.NetAmount,plo.Amount,   ");

        sb.Append(" plo.Amount-ROUND(plos.PCCInvoiceAmt,2)ClientShare, ");
        sb.Append(" ROUND(plos.PCCInvoiceAmt,2)MaxLabShare ");
        sb.Append("  FROM f_ledgertransaction lt    ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON lt.LedgerTransactionID = plo.LedgerTransactionID  AND  plo.`SubCategoryID`=IF(plo.isPackage=1,34,plo.`SubCategoryID`) ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID=plo.LedgerTransactionID AND plos.ItemID=plo.ItemID");
        sb.Append(" INNER JOIN f_Panel_Master fpm ON fpm.panel_ID=lt.panel_ID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID = lt.Patient_ID   ");
        sb.Append(" where  lt.InvoiceNo='" + InvoiceNo + "' ");
        sb.Append("   ORDER BY lt.Date ");
        //System.IO.File.WriteAllText (@"I:\MLAB Application\WWWRoot\Production\maxlab\ErrorLog\yy.txt", sb.ToString());

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Invoice Report";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
        }
    }
}
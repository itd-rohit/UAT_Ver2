using CrystalDecisions.CrystalReports.Engine;
using System;
using System.Data;
using System.Text;

public partial class Design_Lab_HistoImmunoData : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string testid = Util.GetString(Request.QueryString["testid"]);
        string labno = Util.GetString(Request.QueryString["labno"]);
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT plo.LedgerTransactionNo,lt.pname Pname,CONCAT(lt.age,'/',left(lt.gender,1)) pinfo,plh.Clone,plh.`TYPE`,plh.Result,plh.Intensity,plh.Pattern,plh.Percentage,plh.interpretation,plh.comments, ");
        sb.Append(" plo.slidenumber testid,plh.labno, plh.antiname,plh.obsvalue,");
        sb.Append(" '' doctorname,DATE_FORMAT(plh.entrydate,'%d/%m/%Y %h:%I %p') colldate, ");
        sb.Append(" DATE_FORMAT(plo.ResultEnteredDate,'%d/%m/%Y %h:%I %p') reportdate,im.name testname ");
        sb.Append("   ");
        sb.Append(" FROM  patient_labhisto_immuno plh ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plh.testid=plo.test_id ");
        sb.Append(" AND plh.testid='" + testid + "' AND plo.LedgerTransactionNo='" + labno + "' ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionID=plo.LedgerTransactionID  ");
        sb.Append(" INNER JOIN investigation_master im ON im.investigation_id=plo.investigation_id  ");

        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            ReportDocument obj1 = new ReportDocument();
            DataSet ds = new DataSet();

            ds.Tables.Add(dt.Copy());

            // ds.WriteXmlSchema("d:/HistoImmunoData.xml");

            obj1.Load(Server.MapPath(@"~\Reports\HistoImmunoData.rpt"));
            obj1.SetDataSource(ds);

            System.IO.Stream oStream = null;
            byte[] byteArray = null;
            oStream = obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
            byteArray = new byte[oStream.Length];
            oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
            Response.ClearContent();
            Response.ClearHeaders();
            Response.ContentType = "application/pdf";
            Response.BinaryWrite(byteArray);
            Response.Flush();
            Response.Close();
            obj1.Close();
            obj1.Dispose();
            Session["testid"] = "";
        }
        else
        {
            lb.Text = "No Data To Print";
        }
    }
}
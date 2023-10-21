using CrystalDecisions.CrystalReports.Engine;
using MW6BarcodeASPNet;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_HistoGrossLabel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string testid = Util.GetString(Request.QueryString["testid"]);
        string multipletestid = Util.GetStringWithoutReplace(Session["testid"]);
        string fromdate = Util.GetStringWithoutReplace(Session["fromdate"]);
        string todate = Util.GetStringWithoutReplace(Session["todate"]);
        string labno = Util.GetString(Request.QueryString["labno"]);
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT '" + fromdate + "' fromdate,'" + todate + "' todate,testid,labno,blockid,DATE_FORMAT( entrydate,'%y') yearf FROM patient_labhisto_gross ");
        if (testid != "")
        {
            sb.Append(" where testid='" + testid + "' ");
        }
        else if (multipletestid != "")
        {
            sb.Append(" where testid in(" + multipletestid + ") ");
        }
        else
        {
            lb.Text="No Data To Print";
            return;
        }
        sb.Append(" order by labno,blockid ");
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            ReportDocument obj1 = new ReportDocument();
            DataSet ds = new DataSet();


            ds.Tables.Add(dt.Copy());



           // ds.WriteXmlSchema("d:/HistoGross.xml");



             obj1.Load(Server.MapPath(@"~\Reports\HistoGross.rpt"));
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
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
public partial class Design_Lab_HistoSlidesLabel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string testid = Util.GetString(Request.QueryString["testid"]);
        string labno = Util.GetString(Request.QueryString["labno"]);
        string multipletestid = Util.GetStringWithoutReplace(Session["testid"]);
        string fromdate = Util.GetStringWithoutReplace(Session["fromdate"]);
        string todate = Util.GetStringWithoutReplace(Session["todate"]);
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT plo.barcodeno, '" + fromdate + "' fromdate,'" + todate + "' todate, 'Client' labname,left(pm.pname,15) pname, testid,labno,blockid,slideno,DATE_FORMAT( entrydate,'%y') yearf ");
        sb.Append(" ,date_format(entrydate,'%d/%m/%Y') entrydate   FROM patient_labhisto_slides pls ");
        sb.Append(" inner join patient_labinvestigation_opd plo on plo.test_id=pls.testid and plo.slidenumber=pls.labno ");
        sb.Append(" inner join patient_master pm on pm.patient_id=plo.patient_id");
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
            lb.Text = "No Data To Print";
            return;
        }
        sb.Append(" order by labno,blockid,slideno");
        dt = StockReports.GetDataTable(sb.ToString());


        string barcode = new Barcode_alok().Save(Util.GetString(dt.Rows[0]["barcodeno"].ToString())).Trim();
        //   dt.Columns.Add("Image", System.Type.GetType("System.Byte[]"));
        if (!string.IsNullOrEmpty(barcode))
        {
            string x = barcode.Replace("data:image/png;base64,", "");
          
            byte[] imageBytes = Convert.FromBase64String(x);
            MemoryStream ms = new MemoryStream(imageBytes, 0, imageBytes.Length);
           
            DataColumn dcImage = new DataColumn("Image");
            dcImage.DataType = System.Type.GetType("System.Byte[]");
            dcImage.DefaultValue = imageBytes;
            dt.Columns.Add(dcImage);
        }


        if (dt.Rows.Count > 0)
        {
            ReportDocument obj1 = new ReportDocument();
            DataSet ds = new DataSet();


            ds.Tables.Add(dt.Copy());



            //ds.WriteXmlSchema("d:/HistoSlides.xml");



             obj1.Load(Server.MapPath(@"~\Reports\HistoSlides.rpt"));
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

        }
        else
        {
            lb.Text = "No Data To Print";
        }
    }
}
using System;
using MW6BarcodeASPNet;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using System.Text.RegularExpressions;

public partial class Design_Lab_DeltacheckGraph : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ReportDocument rpt = new ReportDocument();
        System.IO.Stream oStream = null;
        try
        {
            string testid = Util.GetString(Request.QueryString["Test_ID"]);
            testid = "'" + testid + "'";
            testid = testid.Replace(",", "','");
            StringBuilder sb = new StringBuilder();
            sb.Append("");
            sb.Append(" SELECT plo.MinValue, plo.MaxValue, plo.MinCritical, plo.MaxCritical, labobservationname, DATE_FORMAT(`ResultDateTime`,'%d-%b-%y %h:%i:%s') ResultdDate,VALUE,lt.pname,lt.LedgerTransactionno,lt.patient_id,lt.Age, ");
            sb.Append(" lt.gender  FROM patient_labobservation_opd plo ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` pli ON pli.test_id=plo.test_id AND `IsNumeric`(VALUE)=1 ");
            sb.Append(" and pli.investigation_ID in (select investigation_id from patient_labinvestigation_opd where test_id in(" + testid + ")) ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.LedgerTransactionID=pli.LedgerTransactionID ");
            sb.Append(" WHERE lt.patient_id =(SELECT patient_id FROM patient_labinvestigation_opd WHERE test_id in(" + testid + ") LIMIT 1) ");
            sb.Append(" ORDER BY labobservationname,plo.ResultDateTime ASC ");
            using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            {


                if (dt.Rows.Count > 0)
                {

                    using (DataSet ds = new DataSet())
                    {
                        ds.Tables.Add(dt.Copy());
                        dt.TableName = "DeltaData";
                        //ds.WriteXmlSchema("d:/DeltaData.xml");
                        rpt.Load(Server.MapPath(@"~\Reports\DeltaCheckGraph.rpt"));
                        rpt.SetDataSource(ds);

                        byte[] byteArray = null;
                        oStream = rpt.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                        byteArray = new byte[oStream.Length];
                        oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
                        Response.ClearContent();
                        Response.ClearHeaders();
                        Response.ContentType = "application/pdf";
                        Response.BinaryWrite(byteArray);
                        Response.Flush();
                        Response.Clear();
                        HttpContext.Current.Response.SuppressContent = true;
                        HttpContext.Current.ApplicationInstance.CompleteRequest();
                    }

                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            rpt.Close();
            rpt.Dispose();
            oStream.Close();
            oStream.Dispose();
        }
    }
}
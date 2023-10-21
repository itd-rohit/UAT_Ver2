using CrystalDecisions.CrystalReports.Engine;
using System;
using System.Data;
using System.Web;

public partial class Design_common_CommonCrystalReportViewerExcel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ReportDocument obj1 = new ReportDocument();
        try
        {
            string cmd = Util.GetString(Request.QueryString["cmd"]);
            DataSet ds = new DataSet();
            ds = (DataSet)Session["ds" + cmd];
            string ReportName = "";
            ds = (DataSet)Session["ds"];

            if (Session["ReportName"] != null)
            {
                ReportName = Session["ReportName" + cmd].ToString();
                Session.Remove("ReportName" + cmd);
                Session.Remove("ds" + cmd);
            }
            switch (ReportName)
            {
                case "CollectionReportSummary":
                    {
                        obj1.Load(Server.MapPath(@"~\Reports\CollectionReportSummary.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "SettlementReportDetail":
                    {
                        obj1.Load(Server.MapPath(@"~\Reports\SettlementReportDetail.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "SalesReport":
                    {
                        obj1.Load(Server.MapPath(@"~\Reports\SalesReport.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "SampleTypeCount":
                    {
                        obj1.Load(Server.MapPath(@"~\Reports\SampleTypeCount.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "ClientWiseSummary":
                    {
                        obj1.Load(Server.MapPath("~/Reports/ClientWiseSummary.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "CollectionReport_PatientWise":
                    {
                        obj1.Load(Server.MapPath(@"~\Reports\CollectionReport_PatientWise.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
            }
            this.CrystalReportViewer1.ReportSource = obj1;
            this.CrystalReportViewer1.DataBind();
            this.CrystalReportViewer1.DisplayToolbar = false;

            using (System.IO.Stream m = (System.IO.Stream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.Excel))
            {
                byte[] byteArray = new byte[m.Length];
                m.Read(byteArray, 0, Convert.ToInt32(m.Length - 1));
                string attachment = "attachment; filename=" + ReportName + ".xlsx";
                Response.ClearContent();
                Response.ClearHeaders();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", attachment);
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.BinaryWrite(byteArray);
                Response.Flush();
                Response.Clear();
                HttpContext.Current.Response.SuppressContent = true;
                HttpContext.Current.ApplicationInstance.CompleteRequest();
                m.Close();
                m.Dispose();
            }
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
            CrystalReportViewer1.Dispose();
            CrystalReportViewer1 = null;
        }
    }
}
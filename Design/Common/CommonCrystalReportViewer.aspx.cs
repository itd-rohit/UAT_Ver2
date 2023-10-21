using CrystalDecisions.CrystalReports.Engine;
using System;
using System.Data;

public partial class Design_common_CommonCrystalReportViewer : System.Web.UI.Page
{
    private ReportDocument obj1 = new ReportDocument();
    private DataSet ds = new DataSet();

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string cmd = Util.GetString(Request.QueryString["cmd"]);

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
            }

            this.CrystalReportViewer1.ReportSource = obj1;
            this.CrystalReportViewer1.DataBind();
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    protected void Page_UnLoad(object sender, EventArgs e)
    {
        if (obj1 != null)
        {
            obj1.Close();
            obj1.Dispose();
        }
    }
}
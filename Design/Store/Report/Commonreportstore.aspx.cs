using CrystalDecisions.CrystalReports.Engine;
using System;
using System.Data;

public partial class Design_Store_Report_Commonreportstore : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        System.IO.Stream oStream = null;
        ReportDocument obj1 = new ReportDocument();
        try
        {
           


          
            DataSet ds = new DataSet();

            ds = (DataSet)Session["ds"];
            string ReportName = "";

            if (Session["ReportName"] != null)
            {
                ReportName = Session["ReportName"].ToString();
                Session.Remove("ReportName");
                Session.Remove("ds");
                switch (ReportName)
                {

                    case "StockStatusReport":
                        {
                            obj1.Load(Server.MapPath("~/Design/Store/Report/StockStatusReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "StockPhysicalVerification":
                        {
                            obj1.Load(Server.MapPath("~/Design/Store/Report/StockPhysicalVerification.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "ConsumeReportDetail":
                        {
                            obj1.Load(Server.MapPath("~/Design/Store/Report/ConsumeReportDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "ConsumeReportItemSummary":
                        {
                            obj1.Load(Server.MapPath("~/Design/Store/Report/ConsumeReportItemSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "ConsumeReportAmtSummary":
                        {
                            obj1.Load(Server.MapPath("~/Design/Store/Report/ConsumeReportAmtSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "IssueReportDetail":
                        {
                            obj1.Load(Server.MapPath("~/Design/Store/Report/IssueReportDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "IssueReportItemSummary":
                        {
                            obj1.Load(Server.MapPath("~/Design/Store/Report/IssueReportItemSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "IssueReportAmtSummary":
                        {
                            obj1.Load(Server.MapPath("~/Design/Store/Report/IssueReportAmtSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "StockExpiryReport":
                        {
                            obj1.Load(Server.MapPath("~/Design/Store/Report/StockExpiryReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "LowStockReport":
                        {
                            obj1.Load(Server.MapPath("~/Design/Store/Report/LowStockReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "GRNReport":
                        {
                            obj1.Load(Server.MapPath("~/Design/Store/Report/GRNReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "IndentReport":
                        {
                            obj1.Load(Server.MapPath("~/Design/Store/Report/IndentReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "POReport":
                        {
                            obj1.Load(Server.MapPath("~/Design/Store/Report/POReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "NFAReport":
                        {
                            obj1.Load(Server.MapPath("~/Design/Store/Report/NFAReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                }




                //  System.IO.Stream oStream = null;
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
            oStream.Close();
            oStream.Dispose();
        }


    }
}
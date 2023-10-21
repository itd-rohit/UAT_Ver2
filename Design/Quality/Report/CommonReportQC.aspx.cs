using CrystalDecisions.CrystalReports.Engine;
using System;
using System.Data;

public partial class Design_Quality_CommonReportQC : System.Web.UI.Page
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

                    case "QCReport":
                        {
                            obj1.Load(Server.MapPath("~/Design/Quality/Report/QCReport.rpt"));
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
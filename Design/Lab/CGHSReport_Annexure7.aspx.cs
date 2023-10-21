using System;
using System.Data;
using System.IO;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System.Drawing.Printing;

public partial class Design_Lab_CGHSReport_Annexure7 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        System.IO.Stream oStream = null;
        try
        {
            if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
            {
                Response.Redirect(Request.RawUrl + "?access=" + Util.getHash(), false);
            }
            else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
            {
                Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
            }
            string cmd = Util.GetString(Request.QueryString["cmd"]);


            ReportDocument obj1 = new ReportDocument();
            DataSet ds = new DataSet();

            ds = (DataSet)Session["ds7" + cmd];
            string ReportName = "";

            if (Session["ReportName7" + cmd] != null)
            {
                ReportName = Session["ReportName7" + cmd].ToString();
                Session.Remove("ReportName7" + cmd);
                 Session.Remove("ds7" + cmd);
              
                switch (ReportName)
                {
                    case "CGHSPatientReport_Annexure7":
                        {
                            obj1.Load(Server.MapPath("~/Reports/CGHSPatientReport_Annexure7.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                  
                }

                //---------------------------------


                CrystalDecisions.Shared.PrintLayoutSettings oPrintLayoutSettings = new CrystalDecisions.Shared.PrintLayoutSettings();
                System.Drawing.Printing.PrintDocument oPrintDocument = new System.Drawing.Printing.PrintDocument();
                //System.Drawing.Printing.PageSettings oPageSetting = new System.Drawing.Printing.PageSettings();
                System.Drawing.Printing.PaperSize oPaperSize = new System.Drawing.Printing.PaperSize();

                string namePrinter = oPrintDocument.DefaultPageSettings.PrinterSettings.PrinterName;
                obj1.PrintOptions.PrinterName = namePrinter;
                obj1.PrintOptions.DissociatePageSizeAndPrinterPaperSize = true;
                oPaperSize.RawKind = (int)PaperKind.Custom;
                oPaperSize.Height = 100;
                oPaperSize.Width = 100;
                obj1.PrintOptions.PaperSize = (CrystalDecisions.Shared.PaperSize)oPaperSize.Kind;
                Response.Write(namePrinter);

                //---------------------------------

                
                // obj1.PrintOptions.PaperSize = 
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
                obj1.Close();
                obj1.Dispose();



            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {

            oStream.Close();
            oStream.Dispose();
        }


    }
}

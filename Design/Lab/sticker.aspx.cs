using CrystalDecisions.CrystalReports.Engine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
public partial class Design_Lab_sticker : System.Web.UI.Page
{
    public DataTable dt;
    public int no = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
System.IO.Stream oStream = null;
ReportDocument obj1 = new ReportDocument();
try
        {
        dt = (DataTable)Session["stdata"];
        
        
        DataSet ds = new DataSet();


        ds.Tables.Add(dt.Copy());
        dt.TableName = "stdata";
        ds.Tables.Add(dt.Copy());


        ds.WriteXmlSchema("F:/stdata.xml");

      

        obj1.Load(HttpContext.Current.Server.MapPath(@"~\Reports\Stiker.rpt"));
        obj1.SetDataSource(ds);
        byte[] byteArray = null;
        oStream = obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
        byteArray = new byte[oStream.Length];
        oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
        HttpContext.Current.Response.ClearContent();
        HttpContext.Current.Response.ClearHeaders();
        HttpContext.Current.Response.ContentType = "application/pdf";
        HttpContext.Current.Response.BinaryWrite(byteArray);
       // HttpContext.Current.Response.Flush();
       // HttpContext.Current.Response.End();
        HttpContext.Current.Response.Flush();
        HttpContext.Current.Response.Close();
      //  obj1.Close();
      //  obj1.Dispose();
         HttpContext.Current.Response.SuppressContent = true;
         HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            obj1.Close();
            obj1.Dispose();
            oStream.Close();
            oStream.Dispose();
            Session["stdata"] = string.Empty;
            Session.Remove("stdata");
        }
    }
}
using CrystalDecisions.CrystalReports.Engine;
using System;
using System.Data;

public partial class Design_Common_CrystalReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form.Count > 0)
        {
            string Query = Request.Form["Query"];

            using (DataTable dt = StockReports.GetDataTable(Query))
            {
                if (dt.Rows.Count > 0)
                {
                    using (DataSet ds = new DataSet())
                    {
                        ds.Tables.Add(dt.Copy());
                        // ds.WriteXmlSchema(Request.Form["ReportXMLPath"]);
                        using (ReportDocument obj1 = new ReportDocument())
                        {
                            obj1.Load(Server.MapPath(Request.Form["ReportPath"]));

                            obj1.SetDataSource(ds);
                            using (System.IO.Stream m = (System.IO.Stream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat))
                            {
                                byte[] byteArray = new byte[m.Length];
                                m.Read(byteArray, 0, Convert.ToInt32(m.Length - 1));

                                obj1.Close();
                                obj1.Dispose();
                                Response.ClearContent();
                                Response.ClearHeaders();
                                Response.Buffer = true;
                                Response.ContentType = "application/pdf";

                                Response.BinaryWrite(byteArray);
                                Response.Flush();
                                Response.Close();
                                m.Close();
                                m.Dispose();
                            }
                        }
                    }
                }
                else
                {
                    lblMsg.Text = "No Record Found";
                }
            }
        }
    }
}
using System;
using System.Data;
using System.Text;
using CrystalDecisions.CrystalReports.Engine;
using System.IO;
using System.Web;
using MySql.Data.MySqlClient;
public partial class Design_Lab_DispatchSampleReport : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string batchNo = Util.GetString(Common.Decrypt( Request.QueryString["batchNo"]));
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT plo.LedgerTransactionNo,plo.ItemId, GROUP_CONCAT(distinct plo.ItemName SEPARATOR ',')ItemName,DATE_FORMAT(plo.Date,'%d-%b-%Y')DATE,plo.CentreID,DATE_FORMAT(plo.SampleCollectionDate, '%d-%b-%Y %h:%i %p')SampleCollectionDate ,plo.SampleTypeID,plo.SampleTypeName");
            sb.Append(" ,CONCAT(pm.title,' ',pm.pname)NAME,Concat(pm.age,'/',pm.gender)age,sl.BarcodeNo, ");
            sb.Append(" (SELECT Centre FROM centre_master WHERE CentreID=sl.FromCentreID)FromCentreName,sl.FromCentreID, ");
            sb.Append(" (SELECT Centre FROM centre_master WHERE CentreID=sl.ToCentreID)ToCentreName,sl.ToCentreID,sl.DispatchCode,sl.CourierDetail,sl.CourierDocketNo, ");
            sb.Append(" DATE_FORMAT(sl.dtLogisticReceive,'%d-%b-%Y %h:%I%p')LogisticReceiveDate,sl.PickUpFieldBoyID,sl.PickUpFieldBoy ");
            sb.Append(" FROM patient_labinvestigation_opd plo  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.patient_id=plo.patient_id ");
            sb.Append(" INNER JOIN sample_logistic sl ON plo.Barcodeno=sl.BarcodeNo ");
            sb.Append(" AND sl.isactive=1 and sl.DispatchCode=@DispatchCode AND plo.`IsSampleCollected`='S' GROUP BY BarcodeNo ");
            using (DataTable dt =MySqlHelper.ExecuteDataset(con,CommandType.Text,sb.ToString(),
               new MySqlParameter("@DispatchCode", batchNo.Trim())).Tables[0])
            {
                try
                {
                    if (dt.Rows.Count > 0)
                    {
                        string barcode = new Barcode_alok().Save(Util.GetString(dt.Rows[0]["DispatchCode"].ToString())).Trim();
                        if (!string.IsNullOrEmpty(barcode))
                        {
                            string x = barcode.Replace("data:image/png;base64,", "");
                            byte[] imageBytes = Convert.FromBase64String(x);
                            using (MemoryStream ms = new MemoryStream(imageBytes, 0, imageBytes.Length))
                            {
                                DataColumn dcImage = new DataColumn("Image");
                                dcImage.DataType = System.Type.GetType("System.Byte[]");
                                dcImage.DefaultValue = imageBytes;
                                dt.Columns.Add(dcImage);
                                ms.Close();
                                ms.Dispose();
                            }
                        }

                        using (ReportDocument rpt = new ReportDocument())
                        {
                            using (DataSet ds = new DataSet())
                            {
                                ds.Tables.Add(dt.Copy());
                                //   ds.WriteXmlSchema("d:/DispatchSampleReport.xml");
                                rpt.Load(Server.MapPath(@"~\Reports\DispatchSampleReport.rpt"));
                                rpt.SetDataSource(ds);

                                byte[] byteArray = null;
                                using (System.IO.Stream oStream = rpt.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat))
                                {
                                    byteArray = new byte[oStream.Length];
                                    oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
                                    Response.ClearContent();
                                    Response.ClearHeaders();
                                    Response.ContentType = "application/pdf";
                                    Response.BinaryWrite(byteArray);

                                    rpt.Close();
                                    rpt.Dispose();
                                    Response.Flush();
                                    Response.Clear();
                                    oStream.Close();
                                    oStream.Dispose();
                                    HttpContext.Current.Response.SuppressContent = true;
                                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                                }
                            }
                        }

                    }

                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
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
            con.Close();
            con.Dispose();
        }
    }
}
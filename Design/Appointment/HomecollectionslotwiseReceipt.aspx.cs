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

public partial class Design_Appointment_HomecollectionslotwiseReceipt : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT hcn.`id`,hcn.`PhlebotomistName`,DATE_FORMAT(hcn.`AppDate`,'%d-%b-%Y')AppDate,hcn.Pincode,  ");
        sb.Append(" TIME_FORMAT(hcn.`AppTime`,'%h:%i:%s %p')AppTime,hcn.`PatientName`,hcn.`Gender`, ");
        sb.Append(" hcn.`Mobile`,hcn.`Address`,hcn.`Address1`,hcn.`Address2`,hcn.`Investigation`, pnl.`Company_Name`, dr.`Name`, ");
        sb.Append(" CONCAT(IF(ageyear<>0,CONCAT(ageyear,' Y'),''),IF(agemonth<>0,CONCAT(' ',agemonth,' M'),''),IF(agedays<>0,CONCAT(' ',agedays,' D'),''))`AgeYear` ");
        sb.Append(" ,'' testname,''  rate  FROM f_homecollectiondatanew hcn  ");
        sb.Append("   INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=hcn.`PanelID` ");
        sb.Append("  INNER JOIN `doctor_referal` dr ON dr.`Doctor_ID`=hcn.`ReferDoctor` where hcn.id='" + Request.QueryString["ID"].ToString() + "' ");

        dt = StockReports.GetDataTable(sb.ToString());



        if (dt.Rows.Count > 0)
        {
            System.IO.Stream oStream = null;
            try
            {
                DataTable dtc = new DataTable("testtable");
                dtc.Columns.Add("testName");
                dtc.Columns.Add("rate");

                foreach (string s in dt.Rows[0]["Investigation"].ToString().Split('#'))
                {
                    if (s != "")
                    {
                        DataRow dw = dtc.NewRow();
                        dw["testname"] = s.Split('_')[1].Split('@')[0].ToString();
                        dw["rate"] = s.Split('_')[1].Split('@')[1].ToString();
                        dtc.Rows.Add(dw);
                    }
                }
                ReportDocument obj1 = new ReportDocument();
                DataSet ds = new DataSet();


                ds.Tables.Add(dt.Copy());
                ds.Tables.Add(dtc.Copy());


                //ds.WriteXmlSchema("E:/ReceiptHomeColl.xml");
                obj1.Load(Server.MapPath(@"~\Reports\ReceiptHomeCollslotwise.rpt"));
                obj1.SetDataSource(ds);

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


                //System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                ////System.IO.Stream m = (System.IO.Stream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);

                //obj1.Close();
                //obj1.Dispose();
                //Response.ClearContent();
                //Response.ClearHeaders();
                //Response.Buffer = true;
                //Response.ContentType = "application/pdf";
                //Response.BinaryWrite(m.ToArray());
                //m.Flush();
                //m.Close();
                //m.Dispose();
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
}
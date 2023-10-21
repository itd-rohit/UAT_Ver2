using CrystalDecisions.CrystalReports.Engine;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for Sales
/// </summary>
public class Sales :IDisposable
{
	public Sales()
	{
		//
		// TODO: Add constructor logic here
		//
	}
    public void Dispose()
    {
        
    }
   

    //public static byte[] PUPSalesRateList(MySqlConnection con, int Panel_ID)
    //{
      //  using (DataTable rateList = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT im.TestCode,im.TypeName ItemName,if(SpecialFlag=1,'Yes','No')IsSpecial,IFNULL(rat.Rate,0)Rate FROM f_itemmaster im LEFT JOIN f_ratelist rat ON rat.ItemID=im.ItemID WHERE rat.Panel_ID=@Panel_ID",
        //                   new MySqlParameter("@Panel_ID", Panel_ID)).Tables[0])
        //{
          //  DataSet ds = new DataSet();
            //ds.Tables.Add(rateList.Copy());
            // ds.WriteXmlSchema("E:/PUPRateListReport.xml");
           // using (CrystalDecisions.CrystalReports.Engine.ReportDocument obj1 = new CrystalDecisions.CrystalReports.Engine.ReportDocument())
            //{
               // obj1.Load(HttpContext.Current.Server.MapPath("~/Reports/PUPRateListReport.rpt"));
                //obj1.SetDataSource(ds);
                //using (System.IO.Stream m = (System.IO.Stream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat))
                //{
                  //  byte[] byteArray = new byte[m.Length];
                    //m.Read(byteArray, 0, Convert.ToInt32(m.Length - 1));


                    //HttpContext.Current.Response.ClearContent();
                    //HttpContext.Current.Response.ClearHeaders();
                   // HttpContext.Current.Response.ContentType = "application/pdf";
                   // HttpContext.Current.Response.BinaryWrite(byteArray);
                    //HttpContext.Current.Response.Flush();
                    //HttpContext.Current.Response.Close();

                    //obj1.Close();
                    //m.Close();
                    //return byteArray;
                //}
            //}
       // }
    //}
}
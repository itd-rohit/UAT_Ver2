using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class captureImg : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)    
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Barcode = Util.GetString(Request.QueryString["Barcodeno"]).ToLower();
            string MachineID = Util.GetString(Request.QueryString["MachineID"]);
            string MachineName = Util.GetString(Request.QueryString["MachineName"]);
            string content = (new StreamReader(Request.InputStream)).ReadToEnd();
Request.InputStream.Position=0;
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT pli.`Test_ID`,pli.`LedgerTransactionNo`,im.`Name`,pli.`Investigation_ID`  ");
            sb.Append("  FROM `patient_labinvestigation_opd` pli ");
            sb.Append("  INNER JOIN `investigation_master` im ");
            sb.Append("  ON pli.`Investigation_ID`=im.`Investigation_Id` ");
            sb.Append("  AND im.Investigation_ID IN(5352,8227)  AND pli.`BarcodeNo`=@BarcodeNo ORDER BY im.`Name`");
            DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@BarcodeNo", Util.GetString(Request.QueryString["Barcodeno"]))).Tables[0];

        //    string Test_Id = dt.Rows[0]["Test_ID"].ToString();
         //   string Testid = StockReports.ExecuteScalar("Select Test_ID from patient_labinvestigation_opd_image where Test_ID='" + Test_Id + "' limit 1");
         //   if (Testid == "")
        //    {
                if (dt.Rows.Count > 0)
                {
                    sb = new StringBuilder();
                    sb.Append("  SELECT COUNT(*) FROM patient_labinvestigation_opd_image ploi   ");
                    sb.Append("  WHERE ploi.Test_ID=@Test_ID AND ploi.`BarcodeNo`=@BarcodeNo AND ploi.`Investigation_ID`=@Investigation_ID AND ploi.`MachineID`=@MachineID  ");
                    sb.Append(" AND  ploi.MachineName=@MachineName");
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@Test_ID", Util.GetString(dt.Rows[0]["Test_ID"])),
                            new MySqlParameter("@BarcodeNo", Util.GetString(Request.QueryString["Barcodeno"])),
                            new MySqlParameter("@Investigation_ID", Util.GetString(dt.Rows[0]["Investigation_ID"])),
                            new MySqlParameter("@MachineID", MachineID), new MySqlParameter("@MachineName", MachineName))) == 0)
                    {
                        sb = new StringBuilder();
                        sb.Append("  INSERT INTO patient_labinvestigation_opd_image  ");
                        sb.Append(" (Test_ID,BarcodeNo,Investigation_ID,Base64Image,MachineID,MachineName) ");
                        sb.Append(" VALUES ");
                        sb.Append(" (@Test_ID,@BarcodeNo,@Investigation_ID,@Base64Image,@MachineID,@MachineName) ");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@Test_ID", Util.GetString(dt.Rows[0]["Test_ID"])),
                        new MySqlParameter("@BarcodeNo", Util.GetString(Request.QueryString["Barcodeno"])),
                        new MySqlParameter("@Investigation_ID", Util.GetString(dt.Rows[0]["Investigation_ID"])),
                        new MySqlParameter("@Base64Image", content),
                        new MySqlParameter("@MachineID", MachineID),
                        new MySqlParameter("@MachineName",MachineName));
                    tnx.Commit();
                }
            }  
        }
//}
        catch (Exception ex)
        {
            tnx.Rollback();            
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
   
   
}
using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;

public partial class Design_Lab_PatientImageDelete : System.Web.UI.Page
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            dtTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchPatientImage(string Barcode, string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT plo.LedgerTransactionNo LabNo,plo.Test_ID,plo.BarCodeNo,inv.Name Investigationname ,CONCAT(pm.Title,' ',pm.PName)PatientName ");
        sb.Append(" FROM patient_labinvestigation_opd plo INNER JOIN patient_labinvestigation_opd_image poi ON poi.Test_ID=plo.Test_ID   ");
        sb.Append("  LEFT JOIN investigation_master inv ON inv.Investigation_Id=plo.Investigation_ID  LEFT JOIN patient_master pm ON pm.Patient_ID=plo.Patient_ID ");
        sb.Append(" where plo.date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00'  ");
        sb.Append(" and  plo.date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
        if (Barcode != "")
        {
            sb.Append(" and plo.BarCodeNo='" + Barcode + "' ");
        }
        sb.Append("  GROUP BY plo.BarcodeNo  order by plo.BarCodeNo  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string DeleteImage(string TestId)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO patient_labinvestigation_opd_image_log (Test_ID,BarcodeNo,Investigation_ID,Base64Image,MachineID,MachineName,dtEntry,Updatedate,DeletedByID,DeletedBy)  ");
            sb.Append(" SELECT Test_ID,BarcodeNo,Investigation_ID,Base64Image,MachineID,MachineName,dtEntry,Updatedate,@DeletedByID,@DeletedBy FROM patient_labinvestigation_opd_image WHERE Test_ID=@Test_ID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@Test_ID", TestId),
                  new MySqlParameter("@DeletedByID", UserInfo.ID),
                  new MySqlParameter("@DeletedBy", UserInfo.LoginName));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM  patient_labinvestigation_opd_image WHERE Test_ID=@Test_ID",
               new MySqlParameter("@Test_ID", TestId));
            tnx.Commit();
            return "1";

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    public static string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue));
            }
            sb.Append(sb2.ToString());
            sb.Append("}");
        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();
    }
}
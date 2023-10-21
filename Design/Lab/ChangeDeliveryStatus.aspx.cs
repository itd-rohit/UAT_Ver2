using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;

public partial class Design_Lab_ChangeDeliveryStatus : System.Web.UI.Page
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
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
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));


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
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Util.GetString(Request.QueryString["LabNo"]) != "")
        {
            txtLabNo.Text = Util.GetString(Request.QueryString["LabNo"]);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "GetData();", true);
        }
        else
        {
            txtLabNo.Focus();
        }

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetData(string LabNo)
    {
        try
        {
            string valCentreID = Util.GetInt(UserInfo.Centre).ToString();
        }
        catch
        {
            return "-1";
        }

        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT DATE_FORMAT(plo.SampleReceiveDate, '%d-%b-%y') SampleReceiveDate,TIME_FORMAT(TIME(plo.SampleReceiveDate),'%H:%i:%s %p') SampleReceiveDateTime,pm.`PName`,CONCAT(pm.`Age`,'/ ',LEFT(pm.`Gender`,1)) AgeGender,lt.`LedgerTransactionNo`,plo.Test_ID,  ");
            sb.Append(" inv.`Name` Investigation,plo.`BarcodeNo`,plo.`Result_Flag`,plo.`Approved`,plo.`IsSampleCollected`, ");
            sb.Append(" CASE WHEN plo.isPrint=1 THEN '#00FFFF' WHEN plo.Approved=1 THEN '#90EE90' WHEN plo.Result_Flag=1  THEN 'Pink' ");
            sb.Append(" WHEN plo.isSampleCollected='N' THEN  '#CC99FF'  WHEN plo.isSampleCollected='Y' THEN 'white'  ELSE 'white'  END rowcolor, ");
           // sb.Append(" DATE_FORMAT(plo.ApprovedDate,'%d-%b-%y') PatientOutDate,TIME_FORMAT(TIME(plo.ApprovedDate),'%H:%i:%s %p') PatientOutTime,");
            sb.Append(" DATE_FORMAT(plo.SampleCollectionDate, '%d-%b-%y') SampleCollectionDate,TIME_FORMAT(TIME(plo.SampleCollectionDate),'%H:%i:%s %p') SampleCollectionDateTime ");
            sb.Append(" ,DATE_FORMAT(plo.ApprovedDate, '%d-%b-%y') ApprovedDate,TIME_FORMAT(TIME(plo.ApprovedDate),'%H:%i:%s %p') ApprovedTime ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plo.`LedgerTransactionNo` AND lt.`IsCancel`=0 ");
           // sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=lt.Transaction_ID");
            sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID=plo.`Patient_ID`  ");
            sb.Append(" INNER JOIN investigation_master inv ON inv.`Investigation_Id`=plo.`Investigation_ID` ");
            sb.Append(" WHERE lt.LedgertransactionNo='" + Util.GetString(LabNo) + "' ORDER BY inv.`Name`; ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
           
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveRecord(string Data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            Data = Data.TrimEnd('#');
            
            
            string[] Item = Data.Split('#');

            for (int i = 0; i < Item.Length; i++)
            {
                string[] data = Item[i].Split('|');
                string datetime = data[2];
                string time = data[3];
                string inDatetime = datetime + " " + time;
                string Outdatetime = data[4] + " " + data[5];
               // string Filmdatetime = data[6] + " " + data[7];
                string ApprovedDate = data[6] + " " + data[7];

                StringBuilder sbold = new StringBuilder();
                //StringBuilder sboNew = new StringBuilder();
                StringBuilder sb = new StringBuilder();

                sb.Append(" update patient_labinvestigation_opd set SampleReceiveDate='" + Util.GetDateTime(inDatetime).ToString("yyyy-MM-dd HH:mm:ss") + "' ");

                sb.Append(" ,SampleCollectionDate='" + Util.GetDateTime(Outdatetime).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
                   
                    sb.Append(" ,ApprovedDate='" + Util.GetDateTime(ApprovedDate).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
                                             
                    sb.Append(" where LedgerTransactionNo='" + data[0] + "' and Test_ID='" + data[1] + "' ");
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());

                    string insertqry = "insert into patient_labinvestigation_opd_update_status(Test_ID,Status,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID,LedgerTransactionNo) values ('" + data[1] + "','Change Date','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',NOW(),'" + StockReports.getip() + "','" + UserInfo.Centre + "','" + Util.GetString(HttpContext.Current.Session["RoleID"]) + "','" + data[0] + "')";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, insertqry);

                    
               // }        
            }
            Tnx.Commit();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            Tnx.Rollback();
            con.Close();
            con.Dispose();
            return "0";
        }
    }
  
}
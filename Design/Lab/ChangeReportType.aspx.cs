using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Linq;
using Newtonsoft.Json;
using System.Web.Script.Serialization;

public partial class Design_Lab_ChangeReportType : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
          
        }
    }

    [WebMethod(EnableSession = true)]
    public static string searchdata(string LabNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            // PatientMaster
            sb.Append(" SELECT  plo.Test_ID,inv.`Investigation_Id`,  ");
            // LT
            sb.Append(" lt.LedgerTransactionID,lt.LedgerTransactionNo, ");
            sb.Append(" DATE_FORMAT(plo.date,'%d-%b-%Y')DATE,");

            //PLO
            sb.Append(" plo.ItemId,plo.ItemCode,plo.ItemName,plo.Investigation_ID,plo.IsPackage,plo.ReportType, ");
            sb.Append(" if(plo.IsReporting=0 AND plo.`IsPackage`=0,'N', IF(plo.`IsPackage`=1 AND ( SELECT COUNT(1) FROM patient_labinvestigation_opd plo2 WHERE plo2.LedgerTransactionID = plo.`LedgerTransactionID` AND plo2.ItemID=plo.itemid AND if(plo2.reporttype=5,if(plo2.result_flag=1,'Y','N'),plo2.IsSampleCollected)='Y') >0 ,'Y',if(plo.reporttype=5,if(plo.result_flag=1,'Y','N'), plo.IsSampleCollected))) IsSampleCollected ");

            sb.Append(" FROM patient_master pm  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`Patient_ID`=pm.`Patient_ID` ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
            sb.Append(" AND (plo.`LedgerTransactionNo`=@LedgerTransactionNo or plo.Barcodeno=@LedgerTransactionNo)   AND lt.`NetAmount`>0 AND plo.IsActive=1  INNER JOIN investigation_master inv   ON inv.`Investigation_Id`=plo.`Investigation_ID` GROUP BY plo.`ItemId` ");  //AND lt.CentreID=@CentreID //AND plo.IsReporting <> 1

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LedgerTransactionNo", LabNo.Trim()),
                new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0])
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
   
    [WebMethod(EnableSession = true)]
    public static string SaveOPDRefund(object PLO)
    {
        List<OPDRefund> opdrefund = new JavaScriptSerializer().ConvertToType<List<OPDRefund>>(PLO);
        if (opdrefund.Count == 0)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Please Select Item" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);



        string newReceiptNo = string.Empty;


        try
        {
            string Testid = string.Join(",", opdrefund.AsEnumerable().Select(x => x.Test_ID));

            //int[] TestidTags = opdrefund.AsEnumerable().Select(x => Util.GetInt(x.Test_ID)).ToArray();
            //string[] TestidParamNames = TestidTags.Select((s, i) => "@tag" + i).ToArray();
            //string TestidClause = string.Join(", ", TestidParamNames);


            StringBuilder sb = new StringBuilder();
            
                sb = new StringBuilder();
                sb.Append("UPDATE `patient_labinvestigation_opd` plo INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=plo.`Investigation_ID`SET plo.`ReportType`=inv.`ReportType`");
                sb.Append(" WHERE  plo.Test_ID IN (" + Testid + ") ");

                

               MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
               tnx.Commit();
          
            return JsonConvert.SerializeObject(new { status = "true", response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class OPDRefund
    {
        public int ItemID { get; set; }
        public int Test_ID { get; set; }
        public string LabID { get; set; }
        public string PayBy { get; set; }

    }
}
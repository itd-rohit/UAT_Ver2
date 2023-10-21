using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_FrontOffice_PrintReportFrontOffice : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetDetails(string LabNo)
    {
        StringBuilder sb = new StringBuilder();
        //IF(lt.`HLMOPDIPDNo` IS NULL OR lt.`HLMOPDIPDNo` = '','OPD','IPD') AS Hlmopdipd,
        sb.Append("  SELECT plo.isPrint,DATE_FORMAT(plo.date,'%d-%b-%Y %h:%i %p')Regdate,DATE_FORMAT(plo.SampleCollectionDate,'%d-%b-%Y %h:%i %p')Samplecoldate,plo.Test_Id,plo.`BarcodeNo`,plo.`LedgerTransactionNo` Labno,lt.PName,lt.Age,lt.Gender,lt.DoctorName,lt.PanelName  ");
        sb.Append(" ,plo.Approved,IF(rd.Id <> NULL,'Dispatched','') DispatchStatus,IFNULL(CONCAT(em.Title,' ',em.Name),'') DispatchBy,IFNULL(DATE_FORMAT(rd.CREATEDDATE,'%d-%b-%Y %h:%i %p'),'')DispatchedOn, ");
        sb.Append(" plo.itemname as InvestigationName,sm.Name Department,  ");
        sb.Append(" CASE WHEN plo.Result_Flag=0 AND plo.IsSampleCollected='Y' THEN 'Result Pending' ");
        sb.Append(" WHEN plo.Result_Flag=1 AND plo.Approved=1 THEN 'Result Done' ");
        sb.Append(" WHEN plo.Result_Flag=1 AND plo.Approved=0 THEN 'Result Not Done' ");
        sb.Append(" ELSE 'Pending' END `Status` ");
        sb.Append(" FROM f_ledgertransaction lt ");
        sb.Append(" INNER JOIN patient_labInvestigation_OPD plo ON lt.LedgertransactionId=plo.ledgertransactionId ");
        sb.Append(" INNER JOIN f_SubcategoryMaster sm On plo.subcategoryId=sm.subcategoryId");
        sb.Append(" LEFT JOIN ReportDispatch_log rd ON plo.Test_Id=rd.Test_Id ");
        sb.Append(" LEFT JOIN Employee_Master em ON em.Employee_Id=rd.CreatedByID ");
        sb.Append(" WHERE plo.`BarcodeNo`='" + LabNo + "' AND plo.IsReporting=1 ");
     
       // sb.Append(" ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
    }


     [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Dispatch(string TestId, string DispatchTo, string OtherName, string OtherMobile)
    {
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {

                string[] arr = TestId.Split(',');
                for (int i = 0; i < arr.Length; i++)
                {
                    int count1 = 0;
                    if (arr[i] != "")
                    {
                         count1 = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Count(1) FROM ReportDispatch_log WHERE Test_Id= '" + arr[i] + "'  "));

                    }
                    if (count1 < 1)
                    {
                        if (arr[i] != "")
                        {
                            string str = "INSERT INTO ReportDispatch_log(CreatedByID,Test_Id,DispatchTo,OtherName,OtherMobile) VALUES('" + UserInfo.ID + "','" + arr[i] + "','"+DispatchTo+"','"+OtherName+"','"+OtherMobile+"')";
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str.ToString());
                        }
                   }
                    
                }
               
                Tnx.Commit();
                con.Close();
                return "1";
            }
        }
    }

     [WebMethod]
     public static string PostData(string ID)
     {
         return Util.getJson(new { LabID = Common.Encrypt(ID) });

     }


    



}
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
public partial class Design_FrontOffice_PrintReportFrontOffice : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Request.Form["LabID"] != null)
        {
            hdnLabNo.Value = Util.GetString(Common.Decrypt(Request.Form["LabID"]));
        }
        else
        {
            hdnLabNo.Value = string.Empty;
        }
    }



    [WebMethod(EnableSession = true)]
    public static string GetDetails(string LabNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT plo.Test_Id,lt.PName,lt.Age,lt.Gender,lt.DoctorName,lt.PanelName,lt.LedgertransactionNo LabNo ");
            sb.Append(" ,plo.Approved,IF(rd.Id <> NULL,'Dispatched','') DispatchStatus,IFNULL(rd.CreatedBy,'') DispatchBy,IFNULL(DATE_FORMAT(rd.CreatedDate,'%d-%b-%Y %h:%i %p'),'')DispatchedOn, ");
            sb.Append(" plo.ItemName InvestigationName,sm.Name Department,  ");
            sb.Append(" CASE WHEN plo.IsDispatch=1  AND plo.isFOReceive=1 THEN 'Dispatched' "); //Dispatched
            sb.Append("      WHEN plo.Result_Flag=0 AND plo.IsSampleCollected='Y' THEN 'Result Pending' ");
            sb.Append("      WHEN plo.Result_Flag=1 AND plo.Approved=1 THEN 'Result Done' ");
            sb.Append("      WHEN plo.Result_Flag=1 AND plo.Approved=0 THEN 'Result Not Done' ");
            sb.Append(" ELSE 'Pending' END `Status` ");
            sb.Append(" FROM f_ledgertransaction lt ");
            sb.Append(" INNER JOIN patient_labInvestigation_OPD plo ON lt.LedgertransactionId=plo.ledgertransactionId AND plo.IsActive=1 ");
            sb.Append(" INNER JOIN f_SubcategoryMaster sm On plo.subcategoryId=sm.subcategoryId");
            sb.Append(" LEFT JOIN ReportDispatch_log rd ON plo.Test_Id=rd.Test_Id ");

            sb.Append(" WHERE lt.LedgertransactionNo=@LedgertransactionNo AND plo.IsReporting=1 ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@LedgertransactionNo", LabNo)).Tables[0])
            {
                return JsonConvert.SerializeObject(new { status = true, response = dt });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public class TestId
    {
        public string Test_ID { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public static string dispatchSave(object TestId, string DispatchTo, string OtherName, string OtherMobile, string CourierName, string DocketNumber)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            List<string> test_ID = new JavaScriptSerializer().ConvertToType<List<string>>(TestId);
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < test_ID.Count; i++)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO ReportDispatch_log(CreatedByID,CreatedBy,Test_Id,DispatchTo,OtherName,OtherMobile,CourierName,DocketNumber) ");
                sb.Append(" VALUES(@CreatedByID,@CreatedBy,@Test_Id,@DispatchTo,@OtherName,@OtherMobile,@CourierName,@DocketNumber)");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                  new MySqlParameter("@Test_Id", test_ID[i]), new MySqlParameter("@DispatchTo", DispatchTo),
                  new MySqlParameter("@OtherName", OtherName), new MySqlParameter("@OtherMobile", OtherMobile),
                  new MySqlParameter("@CourierName", CourierName), new MySqlParameter("@DocketNumber", DocketNumber));
            }
            sb = new StringBuilder();

            string[] Test_IDTags = string.Join(", ", test_ID).Split(',');
            string[] Test_IDParamNames = Test_IDTags.Select((s, i) => "@tag" + i).ToArray();

            string Test_IDClause = string.Join(", ", Test_IDParamNames);
            sb.Append(" UPDATE patient_labinvestigation_opd SET IsDispatch=1,isFOReceive=1 WHERE Test_ID IN ({0})");
            using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), Test_IDParamNames), con, Tnx))
            {
                for (int i = 0; i < Test_IDParamNames.Length; i++)
                {
                    cmd.Parameters.AddWithValue(Test_IDParamNames[i], Test_IDTags[i]);
                }
                cmd.ExecuteNonQuery();
            }

            Tnx.Commit();
            test_ID.Clear();
            sb.Clear();
            return JsonConvert.SerializeObject(new { status = true, response = "Success" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tnx.Rollback();
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
            Tnx.Dispose();
        }


    }
}







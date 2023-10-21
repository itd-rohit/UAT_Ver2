using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web.Http;
using System.Web.Script.Serialization;
[Route("api/[controller]/[action]")]
public class LabStatusController : ApiController
{
    // GET api/<controller>
    [HttpGet]
    [ActionName("LabStatus")]
    public OrderResponseJArray LabStatus(JObject LabStatusData)
    {
        var obj = "";
        OrderResponseJArray res = new OrderResponseJArray();
        res.success = "false";
       
        try
        {
            LabStatusAPIVM LabStatusDataList = JsonConvert.DeserializeObject<LabStatusAPIVM>(LabStatusData.ToString());
            if (LabStatusDataList == null)
            {
                res.message = "Invalid JSON Format";
                return res;
            }
            if (string.IsNullOrWhiteSpace(LabStatusDataList.InterfaceClient))
            {
                res.message = "InterfaceClient can't be blank";
                return res;
            }
            CreateFolder cf = new CreateFolder();
            cf.CreateNewFolder(LabStatusData.ToString(), "LabStatusAPI", Util.GetString(LabStatusDataList.InterfaceClient));

            if (string.IsNullOrWhiteSpace(LabStatusDataList.UserName))
            {
                res.message = "UserName can't be blank";
                return res;
            }
            if (string.IsNullOrWhiteSpace(LabStatusDataList.Password))
            {
                res.message = "Password can't be blank";
                return res;
            }


            if (string.IsNullOrWhiteSpace(LabStatusDataList.CentreID_interface))
            {
                res.message = "CentreID_interface can't be blank";
                return res;
            }
            if (string.IsNullOrWhiteSpace(LabStatusDataList.WorkOrderID))
            {
                res.message = "WorkOrderID can't be blank";
                return res;
            }

            MySqlConnection con = Util.GetMySqlCon();
            try
            {
                if (AllLoad_Data.validateAPIUserNamePassword(LabStatusDataList.UserName, LabStatusDataList.Password, LabStatusDataList.InterfaceClient, con) == 0)
                {
                    res.message = "Invalid UserName or Password";
                    return res;
                }

                string _Flag = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(`CentreID`,'#',`Panel_id`,'#',Interface_CompanyID) FROM `centre_master_interface` WHERE `CentreID_interface`=@CentreID_interface  AND `Interface_companyName`=@Interface_companyName ;",
                                                          new MySqlParameter("@CentreID_interface", LabStatusDataList.CentreID_interface),
                                                          new MySqlParameter("@Interface_companyName", LabStatusDataList.InterfaceClient)));

                //string _CentreID = string.Empty;
                //string _Panel_ID = string.Empty;
                string _Interface_CompanyID = string.Empty;

                if (string.IsNullOrWhiteSpace(_Flag))
                {
                    res.message = "Invalid InterfaceClient or CentreID";
                    return res;
                }
                //_CentreID = _Flag.Split('#')[0];
                //_Panel_ID = _Flag.Split('#')[1];
                _Interface_CompanyID = _Flag.Split('#')[2];

                StringBuilder sb = new StringBuilder();
                sb.Append("  SELECT lt.`LedgerTransactionNo` ApolloVisitNo,lt.Patient_ID ApolloUHID,  ");
                sb.Append(" lt.`PName` PatientName, lt.`Age` ,lt.`Gender`, plo.`ItemName` ");
                sb.Append(" `ItemName`,`IsReporting`,  ");
                sb.Append(" CASE WHEN IsReporting=0 THEN ''   ");
                sb.Append(" WHEN plo.IsSampleCollected='R' THEN 'Reject' ");
                sb.Append(" when plo.IsSampleCollected='N' then 'Sample Not Collected' ");
                sb.Append(" WHEN  plo.approved=0 AND plo.IsSampleCollected='S'  AND  ");
                sb.Append("  (SELECT COUNT(1) FROM sample_logistic sl WHERE sl.TestID=plo.Test_ID ) = 0  THEN 'Sample Collected'  ");
                sb.Append("  WHEN  plo.approved=0 AND plo.IsSampleCollected='Y' and plo.`Result_Flag`=0  THEN 'Sample Department Received'  ");
                sb.Append("  WHEN  plo.approved=0 AND plo.IsSampleCollected='Y' and plo.`Result_Flag`=1  THEN 'Result Done and Verification Pending'  ");
                sb.Append(" WHEN approved=1 THEN 'ReportGenerated'  ");
                sb.Append(" WHEN  plo.approved=0 AND plo.IsSampleCollected='S'  AND ");
                sb.Append(" (SELECT COUNT(1) FROM sample_logistic sl WHERE sl.TestID=plo.Test_ID AND sl.status='Received' ) > 0  THEN 'SRADone' ");
                sb.Append(" ELSE  'OrderConfirmed' END `TestStatus`  ");
                sb.Append(" FROM patient_labinvestigation_opd plo ");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.LedgertransactionID=plo.LedgertransactionID ");
                sb.Append(" WHERE lt.`LedgerTransactionNo_Interface`=@LedgerTransactionNo_Interface ");
                sb.Append(" AND lt.`Interface_CompanyID`=@Interface_CompanyID ");
                //sbBookingStatus.Append(" AND lt.`CentreID`=@CentreID ");
                //sbBookingStatus.Append(" AND lt.`Panel_ID`=@Panel_ID ");

                using (DataTable dtBookingStatus = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                                               new MySqlParameter("@LedgerTransactionNo_Interface", LabStatusDataList.WorkOrderID),
                                                               new MySqlParameter("@Interface_CompanyID", _Interface_CompanyID)
                    //,new MySqlParameter("@CentreID", _CentreID),
                    //new MySqlParameter("@Panel_ID", _Panel_ID)
                      ).Tables[0])
                {
                    if (dtBookingStatus.Rows.Count > 0)
                    {
                        res.success = "true";
                        res.message = "success";
                        res.data = JArray.FromObject(dtBookingStatus);                        
                        return res;
                    }
                    else
                    {
                        res.message = "No record found";
                        return res;
                    }
                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                res.message = "Error";
                return res;
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            res.message = "Error";
            return res;
        }
    }    
}

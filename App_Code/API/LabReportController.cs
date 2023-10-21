using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web.Http;
[Route("api/[controller]/[action]")]
public class LabReportController : ApiController
{
    [HttpGet]
    [ActionName("LabReport")]
    public OrderResponseData LabReport(JObject LabReportData)
    {
        OrderResponseData res = new OrderResponseData();
        res.success = "false";
        res.data = null;
        try
        {
            LabStatusAPIVM LabReportDataList = JsonConvert.DeserializeObject<LabStatusAPIVM>(LabReportData.ToString());
            if (LabReportDataList == null)
            {
                res.message = "Invalid JSON Format";
                return res;
            }
            if (string.IsNullOrWhiteSpace(LabReportDataList.InterfaceClient))
            {
                res.message = "InterfaceClient can't be blank";
                return res;
            }
            CreateFolder cf = new CreateFolder();
            cf.CreateNewFolder(LabReportData.ToString(), "LabReportAPI", Util.GetString(LabReportDataList.InterfaceClient));

            if (string.IsNullOrWhiteSpace(LabReportDataList.UserName))
            {
                res.message = "UserName can't be blank";
                return res;
            }
            if (string.IsNullOrWhiteSpace(LabReportDataList.Password))
            {
                res.message = "Password can't be blank";
                return res;
            }


            if (string.IsNullOrWhiteSpace(LabReportDataList.CentreID_interface))
            {
                res.message = "CentreID_interface can't be blank";
                return res;
            }
            if (string.IsNullOrWhiteSpace(LabReportDataList.WorkOrderID))
            {
                res.message = "WorkOrderID can't be blank";
                return res;
            }

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                
                if (AllLoad_Data.validateAPIUserNamePassword(LabReportDataList.UserName, LabReportDataList.Password, LabReportDataList.InterfaceClient, con) == 0)
                {
                    res.message = "Invalid UserName or Password";
                    return res;
                }
                string _Flag = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(`CentreID`,'#',`Panel_id`,'#',Interface_CompanyID) FROM `centre_master_interface` WHERE `CentreID_interface`=@CentreID_interface  AND `Interface_companyName`=@Interface_companyName ;",
                                                          new MySqlParameter("@CentreID_interface", LabReportDataList.CentreID_interface),
                                                          new MySqlParameter("@Interface_companyName", LabReportDataList.InterfaceClient)));

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
                int CheckLabNo = 0;

                int IsWorkOrderIDCreateCount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM f_interface_company_master WHERE ID=@ID AND IsWorkOrderIDCreate=1",
                                                                       new MySqlParameter("@ID", _Interface_CompanyID)));
                if (IsWorkOrderIDCreateCount == 0)
                {
                    CheckLabNo = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) from `f_ledgertransaction` lt   WHERE lt.`LedgerTransactionNo`=@LedgerTransactionNo   ",
                                                         new MySqlParameter("@LedgerTransactionNo", LabReportDataList.WorkOrderID.Trim())));
                }
                else
                {
                    CheckLabNo = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) from `f_ledgertransaction` lt   WHERE lt.`LedgerTransactionNo_Interface`=@LedgerTransactionNo   ",
                                                         new MySqlParameter("@LedgerTransactionNo", LabReportDataList.WorkOrderID.Trim())));
                }
                if (CheckLabNo == 0)
                {
                    res.message = "WorkOrderID not found";
                    return res;
                }
                string TestID = string.Empty;
                StringBuilder sb = new StringBuilder();
                if (IsWorkOrderIDCreateCount == 0)
                {
                    sb.Append("SELECT GROUP_CONCAT( plo.test_id) TestID FROM `patient_labinvestigation_opd`  plo ");
                    sb.Append(" WHERE LedgertransactionNo=@LedgerTransactionNo AND Approved=1 AND ApprovedDate >= DATE_ADD(NOW(), INTERVAL -30 DAY ) GROUP BY LedgertransactionNo  ");
                    TestID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                                                        new MySqlParameter("@LedgerTransactionNo", LabReportDataList.WorkOrderID.Trim())));

                }
                else
                {
                    sb.Append("SELECT GROUP_CONCAT( plo.test_id) TestID FROM `patient_labinvestigation_opd`  plo ");
                    sb.Append(" INNER JOIN `f_ledgertransaction` lt ON plo.LedgerTransactionID=lt.LedgerTransactionID ");
                    sb.Append(" WHERE lt.LedgerTransactionNo_Interface=@LedgerTransactionNo AND plo.Approved=1 AND plo.ApprovedDate >= DATE_ADD(NOW(), INTERVAL -30 DAY ) GROUP BY plo.LedgertransactionNo  ");
                    TestID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                                                        new MySqlParameter("@LedgerTransactionNo", LabReportDataList.WorkOrderID.Trim())));
                }

                if (TestID != string.Empty)
                {
                    int IsLetterHead = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IsLetterHead FROM f_interface_company_master WHERE ID=@ID ",
                                                       new MySqlParameter("@ID", _Interface_CompanyID)));

                    string reportURL = string.Format("../lab/labreportnew.aspx?TestID={0}&isOnlinePrint={1}&PHead={2}&app={3}&PrintedByName={4}", Common.Encrypt(Util.GetString(TestID)), Common.Encrypt("1"), Common.Encrypt(Util.GetString(IsLetterHead)), Common.Encrypt("1"), Common.Encrypt(LabReportDataList.UserName));
                    using (MemoryStream file = this.ConvertToStream(reportURL))
                    {
                        var ToBase64File = Convert.ToBase64String(file.ToArray());
                        if (ToBase64File != string.Empty)
                        {
                            res.success = "true";
                            res.message = "success";
                            res.data = null;
                            return res;
                        }
                    }
                }
                else
                {
                    res.message = "No record found";
                    return res;
                }
                return res;
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                res.message = ex.GetBaseException().Message;
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
            res.message = ex.GetBaseException().Message;
            return res;
        }
    }
    public MemoryStream ConvertToStream(string fileUrl)
    {
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(fileUrl);
        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
        MemoryStream result;
        try
        {
            MemoryStream mem = this.CopyStream(response.GetResponseStream());
            result = mem;
        }
        finally
        {
            response.Close();
        }
        return result;
    }
    public MemoryStream CopyStream(Stream input)
    {
        MemoryStream output = new MemoryStream();
        byte[] buffer = new byte[16384];
        int read;
        while ((read = input.Read(buffer, 0, buffer.Length)) > 0)
        {
            output.Write(buffer, 0, read);
        }
        return output;
    }
}

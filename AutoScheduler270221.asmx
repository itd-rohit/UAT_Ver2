<%@ WebService Language="C#" Class="AutoScheduler" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using MySql.Data.MySqlClient;
using MySql.Data;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Text;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class AutoScheduler : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    public void sendEmail()
    {
CreateFolder cf = new CreateFolder();
        cf.CreateNewFolder("EmailLog", "Log");
        try
        {
            sendReportMail();
        }
        catch(Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        try
        {
            sendBillMail();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        try
        {
            sendTinySms();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        try
        {
            sendWebsitelinkApprovalSms();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    public string sendTinySms()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        DataTable dt = new DataTable();
        try
        {
            int isallow = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1)  FROM sms_configuration WHERE id=12 AND (`IsPatient`=1 OR IsDoctor=1 OR IsClient=1)"));
            if (isallow == 0)
                return JsonConvert.SerializeObject(new { status = false, response = "" });
            
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "call insert_sms_tiny()").Tables[0];
            if (dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    SMSDetail sd = new SMSDetail();
                    JSONResponse SMSResponse = new JSONResponse();
                    string Tinyurl = sd.tinysmsbill(Util.GetString(dt.Rows[i]["LedgerTransactionNO"]), 0, "LabReport");

                    List<SMSDetailListRegistration> SMSDetail = new List<SMSDetailListRegistration>  
                        {  
                            new SMSDetailListRegistration {
                                                LabNo=Util.GetString(dt.Rows[i]["LedgerTransactionNO"]),
                                                PName = Util.GetString(dt.Rows[i]["PName"]),
                                                TinyURL=Tinyurl
                                               }   
                        };
                    if (Util.GetString(dt.Rows[i]["PatientMobileno"]) != string.Empty)
                    {
                        SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(12, Util.GetInt(dt.Rows[i]["Panel_ID"]), Util.GetInt(dt.Rows[i]["Type1ID"]), "Patient", Util.GetString(dt.Rows[i]["PatientMobileno"]), Util.GetInt(dt.Rows[i]["LedgerTransactionID"]), con, tnx, SMSDetail));

                        if (SMSResponse.status == false)
                        {
                            tnx.Rollback();
                            return JsonConvert.SerializeObject(new { status = false, response = SMSResponse.response });
                        }
                    }
                    if (Util.GetString(dt.Rows[i]["clientMobileNo"]) != string.Empty)
                    {
                        SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(12, Util.GetInt(dt.Rows[i]["Panel_ID"]), Util.GetInt(dt.Rows[i]["Type1ID"]), "Client", Util.GetString(dt.Rows[i]["clientMobileNo"]), Util.GetInt(dt.Rows[i]["LedgerTransactionID"]), con, tnx, SMSDetail));

                        if (SMSResponse.status == false)
                        {
                            tnx.Rollback();
                            return JsonConvert.SerializeObject(new { status = false, response = SMSResponse.response });
                        }
                    }
                    if (Util.GetString(dt.Rows[i]["DoctorMobileNo"]) != string.Empty)
                    {
                        SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(12, Util.GetInt(dt.Rows[i]["Panel_ID"]), Util.GetInt(dt.Rows[i]["Type1ID"]), "Doctor", Util.GetString(dt.Rows[i]["DoctorMobileNo"]), Util.GetInt(dt.Rows[i]["LedgerTransactionID"]), con, tnx, SMSDetail));

                        if (SMSResponse.status == false)
                        {
                            tnx.Rollback();
                            return JsonConvert.SerializeObject(new { status = false, response = SMSResponse.response });
                        }
                    }
                    SMSDetail.Clear();
                    tnx.Commit();
                }
            }

            return JsonConvert.SerializeObject(new { status = true, response = "" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog dl = new ClassLog();
            dl.errLog(ex);
            if (dt != null && dt.Rows.Count > 0)
            {

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dl.GeneralLog("LabNo:" + dt.Rows[i]["LedgerTransactionNO"].ToString() + " MobileNo:" + dt.Rows[i]["PatientMobileno"].ToString());
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE `sms_tiny` SET `isActive`=0 , `ErrorMsg`=@ErrorMsg WHERE  `isActive`='1' AND `LedgertransactionNo`=@LedgertransactionNo",
                        new MySqlParameter("@ErrorMsg", "Error"),
                        new MySqlParameter("@LedgertransactionNo", dt.Rows[i]["LedgerTransactionNO"].ToString()));

                }
            }
            return JsonConvert.SerializeObject(new { status = false, response = "" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();

        }

    }
    public string sendWebsitelinkApprovalSms()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        DataTable dt = new DataTable();
        try
        {
            int isallow = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1)  FROM sms_configuration WHERE id=13 AND (`IsPatient`=1 OR IsDoctor=1 OR IsClient=1)"));
            if (isallow == 0)
                return JsonConvert.SerializeObject(new { status = false, response = "" });

            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "call INSERT_SMS_Approval()").Tables[0];
            if (dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    SMSDetail sd = new SMSDetail();
                    JSONResponse SMSResponse = new JSONResponse();
                   
                    List<SMSDetailListRegistration> SMSDetail = new List<SMSDetailListRegistration>  
                        {  
                            new SMSDetailListRegistration {
                                                LabNo=Util.GetString(dt.Rows[i]["LedgerTransactionNO"]),
                                                PName = Util.GetString(dt.Rows[i]["PName"]),
                                                UserName=Util.GetString(dt.Rows[i]["Username_web"]),
                                                Passowrd=Util.GetString(dt.Rows[i]["Password_web"])
                                               }   
                        };
                    if (Util.GetString(dt.Rows[i]["PatientMobileno"]) != string.Empty)
                    {
                        SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(13, Util.GetInt(dt.Rows[i]["Panel_ID"]), Util.GetInt(dt.Rows[i]["Type1ID"]), "Patient", Util.GetString(dt.Rows[i]["PatientMobileno"]), Util.GetInt(dt.Rows[i]["LedgerTransactionID"]), con, tnx, SMSDetail));

                        if (SMSResponse.status == false)
                        {
                            return JsonConvert.SerializeObject(new { status = false, response = SMSResponse.response });
                        }
                    }
                    SMSDetail.Clear();
                    tnx.Commit();
                }
            }

            return JsonConvert.SerializeObject(new { status = true, response = "" });
        }
        catch (Exception ex)
        {
            ClassLog dl = new ClassLog();
            dl.errLog(ex);
            if (dt != null && dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dl.GeneralLog("LabNo:" + dt.Rows[i]["LedgerTransactionNO"].ToString() + " MobileNo:" + dt.Rows[i]["PatientMobileno"].ToString());
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE `sms_Approval` SET `isActive`=0 , `ErrorMsg`=@ErrorMsg WHERE  `isActive`='1' AND `LedgertransactionNo`=@LedgertransactionNo",
                        new MySqlParameter("@ErrorMsg", "Error"),
                        new MySqlParameter("@LedgertransactionNo", dt.Rows[i]["LedgerTransactionNO"].ToString()));
                }
            }
            return JsonConvert.SerializeObject(new { status = false, response = "" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public string sendReportMail()
    {
         DataTable dtEmailData = StockReports.GetDataTable("CALL get_email_data_patient();");

        if (dtEmailData.Rows.Count > 0)
        {
            foreach (DataRow drTemp in dtEmailData.Rows)
            {

                string EmailSubject = string.Empty;
                StringBuilder EmailBody = new System.Text.StringBuilder();
                EmailSubject = Util.GetString(drTemp["EmailSubject"]).Replace("{LabNo}", Util.GetString(drTemp["LedgertransactionNo"])).Replace("{PName}", Util.GetString(drTemp["PName"])).Replace("{Age}", Util.GetString(drTemp["Age"])).Replace("{Gender}", Util.GetString(drTemp["Gender"])).Replace("{PatientID}", Util.GetString(drTemp["Patient_id"])).Replace("{GrossAmount}", Util.GetString(drTemp["GrossAmount"])).Replace("{DiscountAmount}", Util.GetString(drTemp["DiscountOnTotal"])).Replace("{NetAmount}", Util.GetString(drTemp["NetAmount"])).Replace("{PaidAmount}", Util.GetString(drTemp["PaidAmount"])).Replace("{UserName}", Util.GetString(drTemp["Username_web"])).Replace("{Passowrd}", Util.GetString(drTemp["Password_web"])).Replace("{DOB}", Util.GetString(drTemp["DOB"]));
                EmailBody.Append(Util.GetString(drTemp["EmailBody"]));
                EmailBody.Replace("{LabNo}", Util.GetString(drTemp["LedgertransactionNo"])).Replace("{PName}", Util.GetString(drTemp["PName"])).Replace("{Age}", Util.GetString(drTemp["Age"])).Replace("{Gender}", Util.GetString(drTemp["Gender"])).Replace("{PatientID}", Util.GetString(drTemp["Patient_id"])).Replace("{GrossAmount}", Util.GetString(drTemp["GrossAmount"])).Replace("{DiscountAmount}", Util.GetString(drTemp["DiscountOnTotal"])).Replace("{NetAmount}", Util.GetString(drTemp["NetAmount"])).Replace("{PaidAmount}", Util.GetString(drTemp["PaidAmount"])).Replace("{UserName}", Util.GetString(drTemp["Username_web"])).Replace("{Passowrd}", Util.GetString(drTemp["Password_web"])).Replace("{DOB}", Util.GetString(drTemp["DOB"]));
                if (Util.GetString(drTemp["AllowToWhom"]).Split('#')[0] == "1" && Util.GetString(drTemp["Email"]) != "" && Util.GetInt(drTemp["DueAmt"]) <= 0)
                {
                    try
                    {
                        ReportEmailClass RMail = new ReportEmailClass();
                        string IsSend = RMail.sendEmail(Util.GetString(drTemp["EmailId"]), EmailSubject.Trim(), EmailBody.ToString(), "", "", Util.GetString(drTemp["LedgerTransactionNo"]), Util.GetString(drTemp["Test_ID"]), "PDF Report", "1", "PDF Report Email", "Patient");
                    }
                    catch (Exception ex)
                    {
                        ClassLog dl = new ClassLog();
                        dl.errLog(ex);
                        dl.GeneralLog("LabNo:" + drTemp["LedgerTransactionNO"].ToString() + "");
                    }
                }

                if (Util.GetString(drTemp["AllowToWhom"]).Split('#')[1] == "1" && Util.GetString(drTemp["EmailIdReport"]) != "" )
                {
                    try
                    {
                        ReportEmailClass RMail = new ReportEmailClass();
                        string IsSend = RMail.sendEmail(Util.GetString(drTemp["EmailIdReport"]), EmailSubject.Trim(), EmailBody.ToString(), "", "", Util.GetString(drTemp["LedgerTransactionNo"]), Util.GetString(drTemp["Test_ID"]), "PDF Report", "1", "PDF Report Email", "Client");
                    }
                    catch (Exception ex)
                    {
                        ClassLog dl = new ClassLog();
                        dl.errLog(ex);
                        dl.GeneralLog("LabNo:" + drTemp["LedgerTransactionNO"].ToString() + "");
                    }
                }

                if (Util.GetString(drTemp["AllowToWhom"]).Split('#')[2] == "1" && Util.GetString(drTemp["DoctorEmailId"]) != "")
                {
                    try
                    {
                        ReportEmailClass RMail = new ReportEmailClass();
                        string IsSend = RMail.sendEmail(Util.GetString(drTemp["DoctorEmailId"]), EmailSubject.Trim(), EmailBody.ToString(), "", "", Util.GetString(drTemp["LedgerTransactionNo"]), Util.GetString(drTemp["Test_ID"]), "PDF Report", "1", "PDF Report Email", "Doctor");
                    }
                    catch (Exception ex)
                    {
                        ClassLog dl = new ClassLog();
                        dl.errLog(ex);
                        dl.GeneralLog("LabNo:" + drTemp["LedgerTransactionNO"].ToString() + "");
                    }
                }


            }
        }
        return "";
    }
    public string sendBillMail()
    {
        DataTable dtEmailData = StockReports.GetDataTable("SELECt ID,LedgerTransactionId,PName,LedgerTransactionNo,ItemID,EmailAddress FROM email_record_bill WHERE IsSent=0");

         if (dtEmailData.Rows.Count > 0)
         {
             foreach (DataRow drTemp in dtEmailData.Rows)
             {
                 if (Util.GetString(drTemp["EmailAddress"]) != string.Empty)
                 {
                     try
                     {
                         ReportEmailClass RMail = new ReportEmailClass();
                         string IsSend = RMail.sendBillEmail(Util.GetString(drTemp["EmailAddress"]), "Bill", "Please Find attachment of bill", string.Empty, string.Empty, Util.GetString(drTemp["LedgerTransactionNo"]), Util.GetString(drTemp["LedgerTransactionId"]), "PDF Bill Report", "0", "PDF Bill Report Email", "Patient");

                         if (IsSend == "1")
                             StockReports.ExecuteDML("UPDATE email_record_bill SET IsSent=1 WHERE ID=" + drTemp["ID"] + "");
                     }
                     catch (Exception ex)
                     {
                      ClassLog dl = new ClassLog();
                     dl.errLog(ex);
                     dl.GeneralLog("LabNo:" + drTemp["LedgerTransactionNO"].ToString()+"");
                      StockReports.ExecuteDML("UPDATE email_record_bill SET IsSent=-1 WHERE ID=" + drTemp["ID"] + "");
                     }

                 }

             }
         }
        return "";
    }
}
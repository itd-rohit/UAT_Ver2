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
using System.Net;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class AutoScheduler : System.Web.Services.WebService
{

    [WebMethod]
    public string AutoScheduleService()
    {
        //System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\op2.txt","shat");
        try
        {
            //sendWhatsappReport();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
          try
        {
            //sendBillMail();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        
        try
        {
            //sendWhatsapp();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
		 try
        {
            //sendTinySms();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        try
        {
           // sendWhatsappHC();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        try
        {
            sendSMS();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        try
        {
            //sendSMSHC();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        try
        {
            //sendEmailPatient();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        try
        {
            //sendEmailHC();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        try
        {
            sendReportMail();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        return string.Empty;
    }
    public void sendEmailPatient()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        DataTable dt = new DataTable();
        ClassLog cl = new ClassLog();
        ReportEmailClass rc = new ReportEmailClass();
        try
        {
            dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select * from  email_record_Patient where issend=0 and IsAttachment=0 and  dtEntry >='" + System.DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00" + "'  ").Tables[0];
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string IsSend = "0";
                try
                {

                    //IsSend = rc.sendEmailToPatient(Util.GetString(dt.Rows[i]["EMailID"]), Util.GetString(dt.Rows[i]["Subject"]), Util.GetString(dt.Rows[i]["EmailBody"]), "", "", "", "", Util.GetString(dt.Rows[i]["EmailType"]), "1", "", Util.GetString(dt.Rows[i]["EMailID"]), "");
                    
                }
                catch (Exception ex)
                {
                    cl.errLog(ex);
                    cl.GeneralLog("SMSID:" + dt.Rows[i]["SMS_ID"].ToString() + " LabNo:" + dt.Rows[i]["labno"].ToString() + " MobileNo:" + dt.Rows[i]["Mobile_No"].ToString());
                    IsSend = "-1";
                }
                finally
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE email_record_Patient SET `issend`='"+ IsSend +"',Remarks=@ErrorMsg  WHERE  `issend`='0' and ID=@SMSID",
                       new MySqlParameter("@ErrorMsg", "Error"), new MySqlParameter("@SMSID", dt.Rows[i]["ID"].ToString()));
                }

            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            cl.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
     //send All whatsapp except Approval
    public void sendEmailHC()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        DataTable dt = new DataTable();
        ClassLog cl = new ClassLog();
        ReportEmailClass rc = new ReportEmailClass();
        try
        {
            dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select * from  " + Util.getApp("HomeCollectionDB") + ".hc_email_sender where issend=0 and  entryDateTime >='" + System.DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00" + "'  ").Tables[0];
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string IsSend = "0";
                try
                {

                    //IsSend = rc.sendEmailToPatient(Util.GetString(dt.Rows[i]["EMailID"]), Util.GetString(dt.Rows[i]["Subject"]), Util.GetString(dt.Rows[i]["EmailBody"]), "", "", "", "", Util.GetString(dt.Rows[i]["EmailType"]), "1", "", Util.GetString(dt.Rows[i]["EMailID"]), "");
                }
                catch (Exception ex)
                {
                    cl.errLog(ex);
                    cl.GeneralLog("SMSID:" + dt.Rows[i]["SMS_ID"].ToString() + " LabNo:" + dt.Rows[i]["labno"].ToString() + " MobileNo:" + dt.Rows[i]["Mobile_No"].ToString());
                }
                finally
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE " + Util.getApp("HomeCollectionDB") + ".hc_email_sender SET `issend`='" + IsSend + "',ErrorMessage=@ErrorMsg  WHERE  `issend`='0' and ID=@SMSID",
                       new MySqlParameter("@ErrorMsg", "Error"),new MySqlParameter("@SMSID",dt.Rows[i]["ID"].ToString()));
                }

            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            cl.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    //send All whatsapp except Approval
    public void sendWhatsapp()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        DataTable dt = new DataTable();
        ClassLog cl = new ClassLog();
        try
        {
            int hr=System.DateTime.Now.Hour;
            int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT Count(*) FROM sms_whatsapp WHERE HOUR(EntDate)='" + System.DateTime.Now.Hour + "' AND issend=1 AND EntDate >='" + System.DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00" + "'"));
            int CountHC = Util.GetInt(StockReports.ExecuteScalar("SELECT Count(*) FROM " + Util.getApp("HomeCollectionDB") + ".hc_sms_whatsapp WHERE HOUR(EntDate)='" + System.DateTime.Now.Hour + "' AND issend=1 AND EntDate >='" + System.DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00" + "'"));
            int Totalcount =120- (Count + CountHC);
            if (Totalcount > 0)
            {
                dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select * from sms_whatsapp where issend=0 and Type<> 'Approval' limit " + Totalcount + " ").Tables[0];
                string Path = StockReports.ExecuteScalar("SELECT  APILink FROM sms_whatsapp_setup Limit 1");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    string SMSText = Path;
                    SMSText = SMSText.Replace("MOBILENO", Util.GetString(dt.Rows[i]["MOBILE_NO"])).Replace("SMSTEXT", Util.GetString(dt.Rows[i]["SMS_TEXT"]));
                    string @string;
                    try
                    {
                        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                        WebClient webClient = new WebClient();
                        string s = "";
                        byte[] bytes = Encoding.ASCII.GetBytes(s);
                        webClient.Headers.Add("User-Agent: Other");
                        webClient.Headers.Add("Content-Type", "text/xml");
                        webClient.Encoding = Encoding.UTF8;
                        byte[] bytes2 = webClient.UploadData(SMSText, bytes);
                        @string = Encoding.ASCII.GetString(bytes2);
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE `sms_whatsapp` SET `issend`=1 , `remark`=@ErrorMsg WHERE  `issend`='0' and sms_ID=@SMSID",
                            new MySqlParameter("@ErrorMsg", "Success"),
                            new MySqlParameter("@SMSID", dt.Rows[i]["SMS_ID"].ToString()));
                    }
                    catch (Exception ex)
                    {
                        cl.errLog(ex);
                        cl.GeneralLog("SMSID:" + dt.Rows[i]["SMS_ID"].ToString() + " LabNo:" + dt.Rows[i]["labno"].ToString() + " MobileNo:" + dt.Rows[i]["Mobile_No"].ToString());
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE `sms_whatsapp` SET `issend`=-1 , `remark`=@ErrorMsg WHERE  `issend`='0' and sms_ID=@SMSID",
                            new MySqlParameter("@ErrorMsg", "Error"),
                            new MySqlParameter("@SMSID", dt.Rows[i]["SMS_ID"].ToString()));
                    }

                }
            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            cl.errLog(ex);
            
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    //send All whatsapp Report
    public void sendWhatsappReport()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        ClassLog cl = new ClassLog();
        try
        {
            int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT Count(*) FROM sms_whatsapp WHERE HOUR(EntDate)='" + System.DateTime.Now.Hour + "' AND issend=1 AND EntDate >='" + System.DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00" + "'"));
            int CountHC = Util.GetInt(StockReports.ExecuteScalar("SELECT Count(*) FROM " + Util.getApp("HomeCollectionDB") + ".hc_sms_whatsapp WHERE HOUR(EntDate)='" + System.DateTime.Now.Hour + "' AND issend=1 AND EntDate >='" + System.DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00" + "'"));
            int Totalcount = 120 - (Count + CountHC);
            if (Totalcount > 0)
            {
                dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select * from sms_whatsapp where issend=0 and Type='Approval' limit " + Totalcount + " ").Tables[0];
                DataTable dtPath =MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT  * FROM sms_whatsapp_setup Limit 1").Tables[0];
				
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    string @string;
                    try
                    {
					
                        DataTable dataTable2 = StockReports.GetDataTable(" CALL Get_WhatsApp_TestId('" + dt.Rows[i]["LabNo"].ToString() + "') ");
								string text4 = (dataTable2.Rows.Count > 0) ? dataTable2.Rows[0]["Test_ID"].ToString() : "";
                                if (text4 != "")
                                {
									string text3 = Util.GetString(dtPath.Rows[0]["APILink"]);
                                    string text5 = Util.GetString(dtPath.Rows[0]["ReportLink"]);
                                    text5 = text5.Replace("~", "&");
                                    text5 = text5.Replace("TEST_ID", text4);
                                    string text6 = SaveReport(this.getBase64Report(text5), Util.GetString(dt.Rows[i]["LabNo"]) + "_" + Util.GetString(dtPath.Rows[0]["prefix"]));
                                    text6 = dtPath.Rows[0]["PDFLink"].ToString().Replace("PDFLINK", text6);
									
									text3 = text3.Replace("MOBILENO", Util.GetString(dt.Rows[i]["MOBILE_NO"]));
									text3 = text3.Replace("SMSTEXT", Util.GetString(dt.Rows[i]["SMS_TEXT"]));
                                    text3 = text3.Replace("LabReport", text6);
                                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                                    WebClient webClient = new WebClient();
                                    string s = "";
                                    byte[] bytes = Encoding.ASCII.GetBytes(s);
                                    webClient.Headers.Add("User-Agent: Other");
                                    webClient.Headers.Add("Content-Type", "text/xml");
                                    webClient.Encoding = Encoding.UTF8;
									//System.IO.File.WriteAllText(@"D:\Live_MediBird\Live_Code\Medibird\ErrorLog\what.txt",text3);
                                    byte[] bytes2 = webClient.UploadData(text3, bytes);
                                    @string = Encoding.ASCII.GetString(bytes2);
                                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE `sms_whatsapp` SET `issend`=1 , `remark`=@ErrorMsg WHERE  `issend`='0' and sms_ID=@SMSID",
                                        new MySqlParameter("@ErrorMsg", "Success"),
                                        new MySqlParameter("@SMSID", dt.Rows[i]["SMS_ID"].ToString()));
                                }
                    }
                    catch (Exception ex)
                    {
                        cl.errLog(ex);
                        cl.GeneralLog("SMSID:" + dt.Rows[i]["SMS_ID"].ToString() + " LabNo:" + dt.Rows[i]["labno"].ToString() + " MobileNo:" + dt.Rows[i]["Mobile_No"].ToString());
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE `sms_whatsapp` SET `issend`=-1 , `remark`=@ErrorMsg WHERE  `issend`='0' and sms_ID=@SMSID",
                            new MySqlParameter("@ErrorMsg", "Error"),
                            new MySqlParameter("@SMSID", dt.Rows[i]["SMS_ID"].ToString()));
                    }

                }
            }
        }
        catch (Exception ex)
        {
            cl.errLog(ex);

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    //send All SMS 
    public void sendSMS()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        DataTable dt = new DataTable();
        ClassLog cl = new ClassLog();
        try
        {
//	System.IO.File.WriteAllText(@"D:\Live_MediBird\Live_Code\Medibird\ErrorLog\sms1.txt",SMSTemplate +"---" + WhatTemplate );
            dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select * from SMS where  issend=0 and  EntDate >='" + System.DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00" + "' ").Tables[0];
//System.IO.File.WriteAllText(@"D:\Live_MediBird\Live_Code\Medibird\ErrorLog\smsbook.txt", "select * from SMS where  issend=0 and  EntDate >='" + System.DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00" + "' " );
            string Path = Util.getApp("SMSURL").Replace('~', '&');
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                StringBuilder SMSText = new StringBuilder();
				SMSText.Append(Path);
                SMSText = SMSText.Replace("MOBILENO", Util.GetString(dt.Rows[i]["MOBILE_NO"])).Replace("SMSTEXT", Util.GetString(dt.Rows[i]["SMS_TEXT"])).Replace("templateid",Util.GetString(dt.Rows[i]["TemplateID"]));
				SMSText=SMSText.Replace("@@", "%0A");
                try
                {
					HttpWebRequest req = (HttpWebRequest)WebRequest.Create(SMSText.ToString());
                    req.Method = "GET";
                     ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 | SecurityProtocolType.Ssl3 |
                                                   SecurityProtocolType.Tls | SecurityProtocolType.Tls11;

//System.IO.File.AppendAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\smsbook2.txt", SMSText.ToString());
                   
                    WebResponse respon = req.GetResponse();
                    System.IO.Stream res = respon.GetResponseStream();

                    string ret = "";
                    byte[] buffer = new byte[1048];
                    int read = 0;
                    while ((read = res.Read(buffer, 0, buffer.Length)) > 0)
                    {
                        Console.Write(Encoding.ASCII.GetString(buffer, 0, read));
                        ret += Encoding.ASCII.GetString(buffer, 0, read);
                    }
					

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE SMS SET `issend`=1  WHERE  `issend`='0' and sms_ID=@SMSID",
                        new MySqlParameter("@ErrorMsg", "Success"),
						 new MySqlParameter("@SMSID", dt.Rows[i]["SMS_ID"].ToString()));
                }
                catch (Exception ex)
                {
		  // System.IO.File.WriteAllText(@"D:\Live_MediBird\Live_Code\Medibird\ErrorLog\smsbook2.txt", ex.ToString());
                    cl.errLog(ex);
                    cl.GeneralLog("SMSID:" + dt.Rows[i]["SMS_ID"].ToString() + " LabNo:" + dt.Rows[i]["MOBILE_NO"].ToString() + " MobileNo:" + dt.Rows[i]["Mobile_No"].ToString());
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE SMS SET `issend`=-1  WHERE  `issend`='0' and sms_ID=@SMSID",
                        new MySqlParameter("@ErrorMsg", "Error"),
						 new MySqlParameter("@SMSID", dt.Rows[i]["SMS_ID"].ToString()));
                }

            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            cl.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    //send All SMS of Home Collection
    public void sendSMSHC()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        DataTable dt = new DataTable();
        ClassLog cl = new ClassLog();
        try
        {

            dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select * from " + Util.getApp("HomeCollectionDB") + ".SMS where issend=0 and EntDate >='" + System.DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00" + "' ").Tables[0];
            string Path = Util.getApp("SMSURL").Replace('~', '&');
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string SMSText = Path;
                SMSText = SMSText.Replace("MOBILENO", Util.GetString(dt.Rows[i]["MOBILE_NO"])).Replace("SMSTEXT", Util.GetString(dt.Rows[i]["SMS_TEXT"]));
                try
                {
                    WebClient Client = new WebClient();
                    string RequestData = "";
                    byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
                    Client.Headers.Add("User-Agent: Other");
                    Client.Headers.Add("Content-Type", "text/xml");
                    Client.Encoding = Encoding.UTF8;
                    byte[] Response = Client.UploadData(SMSText, PostData);
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE " + Util.getApp("HomeCollectionDB") + ".SMS SET `issend`=1  WHERE  `issend`='0' and sms_ID=@SMSID",
                        new MySqlParameter("@ErrorMsg", "Success"),
						 new MySqlParameter("@SMSID", dt.Rows[i]["SMS_ID"].ToString()));
                }
                catch (Exception ex)
                {
                    cl.errLog(ex);
                    cl.GeneralLog("SMSID:" + dt.Rows[i]["SMS_ID"].ToString() + " LabNo:" + dt.Rows[i]["labno"].ToString() + " MobileNo:" + dt.Rows[i]["Mobile_No"].ToString());
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE " + Util.getApp("HomeCollectionDB") + ".SMS SET `issend`=-1  WHERE  `issend`='0' and sms_ID=@SMSID",
                        new MySqlParameter("@ErrorMsg", "Error"),
						 new MySqlParameter("@SMSID", dt.Rows[i]["SMS_ID"].ToString()));
                }

            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            cl.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    //send All whatsapp of Home Collection
    public void sendWhatsappHC()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        DataTable dt = new DataTable();
        ClassLog cl = new ClassLog();
        try
        {
            int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT Count(*) FROM sms_whatsapp WHERE HOUR(EntDate)='" + System.DateTime.Now.Hour + "' AND issend=1 AND EntDate >='" + System.DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00" + "'"));
            int CountHC = Util.GetInt(StockReports.ExecuteScalar("SELECT Count(*) FROM " + Util.getApp("HomeCollectionDB") + ".hc_sms_whatsapp WHERE HOUR(EntDate)='" + System.DateTime.Now.Hour + "' AND issend=1 AND EntDate >='" + System.DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00" + "'"));
            int Totalcount =120- (Count + CountHC);
            if (Totalcount > 0)
            {
//                  System.IO.File.WriteAllText(@"D:\Live_MediBird\Live_Code\Medibird\ErrorLog\What.txt","select * from " + Util.getApp("HomeCollectionDB") + ".hc_sms_whatsapp where issend=0 " + Totalcount  + " ");
                dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select * from " + Util.getApp("HomeCollectionDB") + ".hc_sms_whatsapp where issend=0 LIMIT  " + Totalcount  + " ").Tables[0];
                string Path = StockReports.ExecuteScalar("SELECT  APILink FROM sms_whatsapp_setup Limit 1");

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    string SMSText = Path;
                    SMSText = SMSText.Replace("MOBILENO", Util.GetString(dt.Rows[i]["MOBILE_NO"])).Replace("SMSTEXT", Util.GetString(dt.Rows[i]["SMS_TEXT"]));

                    string @string;
                    try
                    {
                        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                        WebClient webClient = new WebClient();
                        string s = "";
                        byte[] bytes = Encoding.ASCII.GetBytes(s);
                        webClient.Headers.Add("User-Agent: Other");
                        webClient.Headers.Add("Content-Type", "text/xml");
                        webClient.Encoding = Encoding.UTF8;
                        byte[] bytes2 = webClient.UploadData(SMSText, bytes);
                        @string = Encoding.ASCII.GetString(bytes2);
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE " + Util.getApp("HomeCollectionDB") + ".hc_sms_whatsapp SET `issend`=1 , `remark`=@ErrorMsg WHERE  `issend`='0' and sms_ID=@SMSID",
                            new MySqlParameter("@ErrorMsg", "Success"),
                            new MySqlParameter("@SMSID", dt.Rows[i]["SMS_ID"].ToString()));
                    }
                    catch (Exception ex)
                    {
                        cl.errLog(ex);
                        cl.GeneralLog("SMSID:" + dt.Rows[i]["SMS_ID"].ToString() + " LabNo:" + dt.Rows[i]["labno"].ToString() + " MobileNo:" + dt.Rows[i]["Mobile_No"].ToString());
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE " + Util.getApp("HomeCollectionDB") + ".hc_sms_whatsapp SET `issend`=-1 , `remark`=@ErrorMsg WHERE  `issend`='0' and sms_ID=@SMSID",
                            new MySqlParameter("@ErrorMsg", "Error"),
                            new MySqlParameter("@SMSID", dt.Rows[i]["SMS_ID"].ToString()));
                    }

                }
            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            cl.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
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
            int isallow = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1)  FROM sms_configuration WHERE id=12 AND (`IsPatient`=1 OR IsDoctor=1 OR IsClient=1)"));
            if (isallow == 0)
                return JsonConvert.SerializeObject(new { status = false, response = "" });
            
            dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "call insert_sms_tiny()").Tables[0];
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
						try{
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
					}
					catch(Exception ex)
					{
						 ClassLog dl = new ClassLog();
						dl.errLog(ex);
					}
                    SMSDetail.Clear();
//                    tnx.Commit();
                }
            }

            return JsonConvert.SerializeObject(new { status = true, response = "" });
        }
        catch (Exception ex)
        {
            //tnx.Rollback();
            ClassLog dl = new ClassLog();
            dl.errLog(ex);
            if (dt != null && dt.Rows.Count > 0)
            {

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dl.GeneralLog("LabNo:" + dt.Rows[i]["LedgerTransactionNO"].ToString() + " MobileNo:" + dt.Rows[i]["PatientMobileno"].ToString());
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE `sms_tiny` SET `isActive`=0 , `ErrorMsg`=@ErrorMsg WHERE  `isActive`='1' AND `LedgertransactionNo`=@LedgertransactionNo",
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
                EmailSubject = Util.GetString(drTemp["EmailSubject"]).Replace("{PName}", Util.GetString(drTemp["PName"])).Replace("{LabNo}", Util.GetString(dtEmailData.Rows[0]["LedgerTransactionNo"])); ;
                EmailBody.Append(Util.GetString(drTemp["EmailBody"])).Replace("{LabNo}", Util.GetString(dtEmailData.Rows[0]["LedgerTransactionNo"])); ;
                EmailBody.Replace("{PName}", Util.GetString(drTemp["PName"]));
                if (Util.GetString(drTemp["Email"]) != "" && Util.GetFloat(drTemp["DueAmt"]) <= 0)
                {
                    try
                    {
                        ReportEmailClass RMail = new ReportEmailClass();
                        string IsSend = RMail.sendEmail(Util.GetString(drTemp["Email"]), EmailSubject.Trim(), EmailBody.ToString(), "", "", Util.GetString(drTemp["LedgerTransactionNo"]), Util.GetString(drTemp["Test_ID"]), "PDF Report", "1", "PDF Report Email", "Patient");
                    }
                    catch (Exception ex)
                    {
                        ClassLog dl = new ClassLog();
                        dl.errLog(ex);
                        dl.GeneralLog("LabNo:" + drTemp["LedgerTransactionNO"].ToString() + "");
                    }
                }

                if (Util.GetString(drTemp["EmailIdReport"]) != "" )
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

              // if (Util.GetString(drTemp["AllowToWhom"]).Split('#')[2] == "1" && Util.GetString(drTemp["DoctorEmailId"]) != "")
              // {
              //     try
              //     {
              //         ReportEmailClass RMail = new ReportEmailClass();
              //         string IsSend = RMail.sendEmail(Util.GetString(drTemp["DoctorEmailId"]), EmailSubject.Trim(), EmailBody.ToString(), "", "", Util.GetString(drTemp["LedgerTransactionNo"]), Util.GetString(drTemp["Test_ID"]), "PDF Report", "1", "PDF Report Email", "Doctor");
              //     }
              //     catch (Exception ex)
              //     {
              //         ClassLog dl = new ClassLog();
              //         dl.errLog(ex);
              //         dl.GeneralLog("LabNo:" + drTemp["LedgerTransactionNO"].ToString() + "");
              //     }
              // }


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
                         String EmailBill = Util.GetString(StockReports.ExecuteScalar("Select Concat(Subject,'#',Template) from Email_configuration sc where sc.IsActive=1 and sc.id=17 and IsPatient=1"));
                         ReportEmailClass RMail = new ReportEmailClass();
                         string IsSend = RMail.sendBillEmail(Util.GetString(drTemp["EmailAddress"]), EmailBill.Split('#')[0], EmailBill.Split('#')[1], string.Empty, string.Empty, Util.GetString(drTemp["LedgerTransactionNo"]), Util.GetString(drTemp["LedgerTransactionId"]), "PDF Bill Report", "0", "PDF Bill Report Email", "Patient");

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
    [WebMethod]
    public void sendEmail()
    {
        //System.IO.File.WriteAllText(@"D:\Live_MediBird\Live_Code\Medibird\ErrorLog\op5.txt","IN");
        CreateFolder cf = new CreateFolder();
        cf.CreateNewFolder("EmailLog", "Log");
        // System.IO.File.WriteAllText(@"D:\Live_MediBird\Live_Code\Medibird\ErrorLog\op.txt","IN");
        try
        {
            //sendReportMail();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        try
        {
            //  sendBillMail();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        try
        {
            // sendTinySms();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        try
        {
            // sendWebsitelinkApprovalSms();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
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
    public string SaveReport(string base64String, string PdfName)
    {
        string result;
        try
        {
            string path = Util.getApp("SavingPath").ToString() + "/" + PdfName + ".pdf";
            byte[] bytes = Convert.FromBase64String(base64String);
            System.IO.File.WriteAllBytes(path, bytes);
            result = PdfName + ".pdf";
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return result;
    }
    public string getBase64Report(string Path)
    {
        string @string;
        try
        {
            WebClient webClient = new WebClient();
            string s = "";
            byte[] bytes = Encoding.ASCII.GetBytes(s);
            byte[] bytes2 = webClient.UploadData(Path, bytes);
            @string = Encoding.ASCII.GetString(bytes2);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return @string;
    }
}
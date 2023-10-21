using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using Newtonsoft.Json;
using System.Text;
using System.Web.Script.Serialization;
using System.Net;
/// <summary>
/// Summary description for SMSDetail
/// </summary>
public class SMSDetail
{


    public string RegistrationSMS(int SmsConfigurationID, int Panel_ID, int type1ID, string SendType, string MobileNo, int LedgertransactionID, MySqlConnection con, MySqlTransaction tnx, object SMSDetail)
    {
        //  validate by SMSSendDetail
        // 9 column data 

        JSONResponseDataTable SMSStatus = JsonConvert.DeserializeObject<JSONResponseDataTable>(SMSSendDetail(SmsConfigurationID, Panel_ID, type1ID, SendType, MobileNo, LedgertransactionID, con, tnx));
        if (SMSStatus.status)
        {
            StringBuilder sb = new StringBuilder();
            if (SMSStatus.responseData != null)
            {
                using (DataTable dtSMSDetail = SMSStatus.responseData)
                {
                    if (dtSMSDetail.Rows.Count > 0)
                    {
                        string SMSTemplate = dtSMSDetail.Rows[0]["Template"].ToString();
                        List<SMSDetailListRegistration> SMSDetails = new JavaScriptSerializer().ConvertToType<List<SMSDetailListRegistration>>(SMSDetail);
                        string SMS_text = ReplaceSMSTempRegistration(SMSTemplate, SMSDetails);
                        try
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO sms(Mobile_No,SMS_text,SMS_Type,LedgertransactionID,UserID,TemplateID)VALUES(@MobileNo,@SMS_text,@SMS_Type,@LedgertransactionID,@UserID,@TemplateID)",
                                          new MySqlParameter("@MobileNo", MobileNo),
                                          new MySqlParameter("@SMS_text", SMS_text),
                                          new MySqlParameter("@SMS_Type", dtSMSDetail.Rows[0]["SMSType"].ToString()),
                                          new MySqlParameter("@LedgertransactionID", LedgertransactionID),
                                          new MySqlParameter("@UserID", UserInfo.ID),
                                          new MySqlParameter("@TemplateID", SMSDetails[0].TemplateID));
                          //  SMSDetails.Clear();
                            return JsonConvert.SerializeObject(new { status = true, response = "Success" });
                        }
                        catch (Exception ex)
                        {
                            ClassLog cl = new ClassLog();
                            cl.errLog(ex);
                            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
                        }
                    }
                    else
                        return JsonConvert.SerializeObject(new { status = true, response = "Success" });
                }
            }
            else
                return JsonConvert.SerializeObject(new { status = true, response = "Success" });
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
    }
    public string ReplaceSMSTempRegistration(string Template, List<SMSDetailListRegistration> SMSDetail)
    {
        Template = Template.Replace("{LabNo}", SMSDetail[0].LabNo);
        Template = Template.Replace("{PName}", SMSDetail[0].PName);
        Template = Template.Replace("{PatientID}", SMSDetail[0].PatientID);
        Template = Template.Replace("{Age}", SMSDetail[0].Age);
        Template = Template.Replace("{Gender}", SMSDetail[0].Gender);
        Template = Template.Replace("{DOB}", SMSDetail[0].DOB);
        Template = Template.Replace("{GrossAmount}", SMSDetail[0].GrossAmount);
        Template = Template.Replace("{DiscountAmount}", SMSDetail[0].DiscountAmount);
        Template = Template.Replace("{NetAmount}", SMSDetail[0].NetAmount);
        Template = Template.Replace("{PaidAmout}", SMSDetail[0].PaidAmout);
        Template = Template.Replace("{UserName}", SMSDetail[0].UserName);
        Template = Template.Replace("{Passowrd}", SMSDetail[0].Passowrd);
        Template = Template.Replace("{AppointmentID}", SMSDetail[0].AppointmentID);
        Template = Template.Replace("{AppointmentDate}", SMSDetail[0].AppointmentDate);
        Template = Template.Replace("{TinySmsAllowDisc}", SMSDetail[0].TinySmsAllowDisc);
        Template = Template.Replace("{TinySmsRejectDisc}", SMSDetail[0].TinySmsRejectDisc);
        Template = Template.Replace("{TinySmsAllowDiscRemotelink}", SMSDetail[0].TinySmsAllowDiscRemotelink);
        Template = Template.Replace("{TinySmsRejectDiscRemotelink}", SMSDetail[0].TinySmsRejectDiscRemotelink);
        Template = Template.Replace("{TinyURL}", SMSDetail[0].TinyURL);
        Template = Template.Replace("{ItemName}", SMSDetail[0].ItemName);
        Template = Template.Replace("{Bal}", SMSDetail[0].Bal);
        Template = Template.Replace("{Username_web}", SMSDetail[0].LoginID);
        Template = Template.Replace("{Password_web}", SMSDetail[0].Passowrd);
        return Template;
    }
    public string SMSSendDetail(int SmsConfigurationID, int Panel_ID, int type1ID, string SendType, string MobileNo, int LedgertransactionID, MySqlConnection con, MySqlTransaction tnx)
    {
        try
        {
            int IsSMSDiscarded = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT COUNT(1) FROM sms_configuration_client WHERE Panel_ID=@Panel_ID AND SmsConfigurationID=@SmsConfigurationID AND IsDiscard=1",
                new MySqlParameter("@SmsConfigurationID", SmsConfigurationID)));
            if (IsSMSDiscarded > 0)
            {
                return JsonConvert.SerializeObject(new { status = true, response = "" });
            }
            int IsSMSActivate = 0;
            IsSMSActivate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM sms_configuration_client WHERE Type1ID=@Type1ID AND SmsConfigurationID=@SmsConfigurationID AND IsActivate=1",
               new MySqlParameter("@SmsConfigurationID", SmsConfigurationID),
               new MySqlParameter("@Type1ID", type1ID)));

            if (IsSMSActivate == 0)
            {
                IsSMSActivate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM sms_configuration_client WHERE Panel_ID=@Panel_ID AND SmsConfigurationID=@SmsConfigurationID AND IsActivate=1",
                   new MySqlParameter("@SmsConfigurationID", SmsConfigurationID)));
            }
            if (IsSMSActivate > 0)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" SELECT SMSType,Template,IsPatient,IsDoctor,IsClient,IsEmployee FROM sms_configuration WHERE Template!='' AND ");
                if (SendType == "Patient")
                    sb.Append(" IsPatient = 1");
                else if (SendType == "Doctor")
                    sb.Append(" IsDoctor = 1");
                else if (SendType == "Client")
                    sb.Append(" IsClient = 1");
                else if (SendType == "Employee")
                    sb.Append(" IsEmployee = 1");
                sb.Append(" AND ID=@ID");
                using (DataTable SMSDetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@ID", SmsConfigurationID)).Tables[0])
                {
                    if (SMSDetail.Rows.Count > 0)
                        return JsonConvert.SerializeObject(new { status = true, response = "", responseData = SMSDetail });
                    else
                        return JsonConvert.SerializeObject(new { status = true, response = "" });
                }
            }
            else
                return JsonConvert.SerializeObject(new { status = true, response = "" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }

    }
    public string tinysmsresponse(string Labno, string DiscApprovedBy, string DiscountAmt, string DiscType, string Reportlink)
    {
        string ReportURL = "";
        string TinyConverterURL = "http://9url.in/?_url=";
        if (Reportlink == "Local")
        {
             ReportURL = Resources.Resource.LinkURL;
        }
        else
        {
            ReportURL = Resources.Resource.RemoteLink;
        }
            ReportURL += string.Format("/Design/opd/DiscountApprovedByEmail.aspx?VisitNo={0}&AppBy={1}&discamt={2}&type={3}", HttpUtility.UrlEncode(Common.Encrypt(Labno.Trim())), HttpUtility.UrlEncode(Common.Encrypt(DiscApprovedBy)), HttpUtility.UrlEncode(Common.Encrypt(DiscountAmt)), HttpUtility.UrlEncode(Common.Encrypt(DiscType)));
        
        WebClient Client = new WebClient();
        string RequestData = "";
        byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
        byte[] Response = Client.UploadData(TinyConverterURL + ReportURL, PostData);
        string turl = Encoding.ASCII.GetString(Response);
        return turl;
    }
    public string tinysmsbill(string Labno, int billtype, string reporttype)
    {

        string TinyConverterURL = "http://9url.in/?_url=";
        string ReportURL = Resources.Resource.RemoteLink;
        if (reporttype == "Bill")
            ReportURL += string.Format("/Design/lab/PatientReceiptNew1.aspx?labid={0}&MRPBill={1}", Common.Encrypt(Labno.Trim()), billtype);
        else
            ReportURL += string.Format("/Design/lab/labreportnew_ShortSMS.aspx?LabNo={0}", Common.Encrypt(Labno.Trim()));
        WebClient Client = new WebClient();
        string RequestData = "";
        byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
        byte[] Response = Client.UploadData(TinyConverterURL + ReportURL, PostData);
        string turl = Encoding.ASCII.GetString(Response);
        return turl;
    }
}
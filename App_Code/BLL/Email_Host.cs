using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.Script.Serialization;

/// <summary>
/// Summary description for Email_Host
/// </summary>
public class Email_Host
{


    public string _EmailTo { get; set; }
    public string _EmailMsg { get; set; }
    public string _EmailSubject { get; set; }

    public string _Attachment { get; set; }
    public string _EmailFrom { get; set; }
    private string _value(string _key)
    {
        return ((dt.Select("key_data='" + _key + "'").Length == 1) ? dt.Select("key_data='" + _key + "'")[0]["key_value"].ToString() : "");
    }
    DataTable dt = new DataTable();
    public Email_Host()
    {
        dt = StockReports.GetDataTable("select * from global_data");
        _EmailFrom = _value("smtp_username");
    }
    public void sendEmail()
    {
        try
        {


            MailMessage message = new MailMessage(_EmailFrom, _EmailTo, _EmailSubject, _EmailMsg);
            message.IsBodyHtml = true;

            message.Subject = _EmailSubject;

            
            message.Body = _EmailMsg;
          //  message.IsBodyHtml = true;
            message.Priority = MailPriority.High;
            SmtpClient emailClient = new SmtpClient();
            emailClient.Host = Util.GetString(_value("smtp_host"));
            emailClient.Port = Util.GetInt(_value("smtp_port"));
            if (Util.GetString(_Attachment) != "")
            {
                message.Attachments.Add(new Attachment(_Attachment));
            }


            
                emailClient.EnableSsl = false;

            emailClient.UseDefaultCredentials = true;
            emailClient.Credentials = new NetworkCredential(_value("smtp_username"), _value("smtp_password"));
            emailClient.Send(message);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
    }
   

   
}
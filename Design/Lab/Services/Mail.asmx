<%@ WebService Language="C#" Class="Mail" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class Mail : System.Web.Services.WebService
{
   
    [WebMethod(EnableSession = true)]
    public string SendMail(object data)
    {
        MailStatus objmail = new MailStatus();
        return objmail.SendMail(data);
    } 
    [WebMethod(EnableSession = true)]   
    public string SendMailPatientWise(object data)
    {
        MailStatus objmail = new MailStatus();
        return objmail.SendMail(data);
    }
}


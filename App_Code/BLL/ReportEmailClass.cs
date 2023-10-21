using ClosedXML.Excel;
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;
using System.Web;
public class ReportEmailClass
{
    SmtpClient client = new SmtpClient();
    public string EmailID;
    public string EmailPassword;
    public string EmailDisplayName;
    public string FromEmailid;
    public ReportEmailClass()
    {
        //EmailID = "ravi.kumar@itdoseinfo.com";
        //EmailPassword = "8102378777";//Ahll@1122";
        //EmailDisplayName = "Atylaya Healthcare";
        //client.Port = 465;
        //client.Host = "mail.google.com";

        FromEmailid = Resources.Resource.FromEmailid;
        EmailID = Resources.Resource.EmailID;
        EmailPassword = Resources.Resource.EmailPassword;
        EmailDisplayName = Resources.Resource.EmailDisplayName;
        client.Port = Util.GetInt(Resources.Resource.Port);
        client.Host = Resources.Resource.HostName;
        client.DeliveryMethod = SmtpDeliveryMethod.Network;
        client.EnableSsl = true;
        client.UseDefaultCredentials = false;
        client.Credentials = new System.Net.NetworkCredential(EmailID, EmailPassword);
    }
    public string sendEmail(string toAddresses, string subject, string emailBody, string ccAddresses = "", string bccAddresses = "", string LabNo = "", string testID = "", string EmailType = "Normal", string IsAutoMail = "0", string Remarks = "", string MailedTo = "", string FromPUPPortal = "0")
    {
        string IsSend = "-1";
        try
        {
            MailAddress fromAddress = new MailAddress(FromEmailid, EmailDisplayName);
            client.Timeout = 100000;//more than 1 s

            MailMessage message = new MailMessage();
            if (EmailType.Trim() == "PDF Report")
            {
                //Attachment
                string reportURL = Resources.Resource.EmailURLLink; // string.Format("http://localhost/{0}", Resources.Resource.ApplicationURLReportPathName);
                reportURL += string.Format("/Design/Lab/labreportnew.aspx?testid={0}&isOnlinePrint={1}&PHead={2}", Common.Encrypt(Util.GetString(testID)), Common.Encrypt("1"), Common.Encrypt("1"));
                MemoryStream file = this.ConvertToStream(reportURL);
                file.Seek(0L, SeekOrigin.Begin);
                Attachment objAttach2 = new Attachment(file, "LabReport.pdf", "application/pdf");
                ContentDisposition disposition = objAttach2.ContentDisposition;
                disposition.CreationDate = DateTime.Now;
                disposition.ModificationDate = DateTime.Now;
                disposition.DispositionType = "attachment";
                message.Attachments.Add(objAttach2);

            }

            message.From = fromAddress;
            message.To.Add(toAddresses);
            message.Subject = subject;
            message.Body = emailBody;
            //   message.CC.Add("ravi.kumar@itdoseinfo.com"); 
            if (ccAddresses != "") { message.CC.Add(ccAddresses); }
            if (bccAddresses != "") { message.Bcc.Add(bccAddresses); }

           // message.BodyEncoding = System.Text.Encoding.UTF8;
            message.IsBodyHtml = true;
            //message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

            client.Send(message);
            // Clean up.
            message.Dispose();

            IsSend = "1";
CreateFolder cf = new CreateFolder();
        cf.CreateNewFolder(IsSend, "Log");
        }
        catch (Exception ex)
        {
            IsSend = "-1";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Remarks = Util.GetString(ex.GetBaseException()).Substring(0, 200);
        }
        finally
        {
            saveData(LabNo, testID, Remarks, IsSend, IsAutoMail, toAddresses, ccAddresses, bccAddresses, MailedTo, FromPUPPortal);
        }
        return IsSend;
    }

    public void saveData(string VisitNo, string testID, string Remarks, string IsSend, string IsAutoMail, string EmailID, string Cc, string Bcc, string MailedTo, string FromPUPPortal)
    {
        StringBuilder sbTempEmailData = new StringBuilder();
        sbTempEmailData.Append("  SELECT LedgerTransactionID from f_ledgertransaction where LedgerTransactionNo='" + VisitNo + "' ");
        DataTable dtEmailData = StockReports.GetDataTable(sbTempEmailData.ToString());
        int strUserID = (IsAutoMail.Trim() == "1") ? -1 : Util.GetInt(UserInfo.ID);

        if (dtEmailData.Rows.Count > 0)
        {
            if (IsAutoMail.Trim() == "1")
            {
                string[] ArrTest = testID.Split(',');
                StringBuilder sbemail_record_patient = new StringBuilder();
                sbemail_record_patient.Append(" INSERT INTO email_record_patient(LedgerTransactionID,LedgerTransactionNo,Test_id,IsAutoMail,UserID,IsSend,Remarks,EmailID,Cc,Bcc,MailedTo,FromPUPPortal,Test_Id_Single) values ");
                for (int i = 0; i < ArrTest.Length; i++)
                {
                    sbemail_record_patient.Append(" ('" + Util.GetString(dtEmailData.Rows[0]["LedgerTransactionID"]) + "','" + VisitNo + "','" + testID + "','" + IsAutoMail + "'," + strUserID + "," + IsSend + ",'" + Remarks + "','" + EmailID.Trim() + "','" + Cc.Trim() + "','" + Bcc.Trim() + "','" + MailedTo.Trim() + "','" + FromPUPPortal.Trim() + "','" + ArrTest[i] + "'),");
                }
                StockReports.ExecuteDML(sbemail_record_patient.ToString().TrimEnd(','));
            }
            else
            {
                StringBuilder sbemail_record_patient = new StringBuilder();
                sbemail_record_patient.Append(" INSERT INTO email_record_patient(LedgerTransactionID,LedgerTransactionNo,Test_id,IsAutoMail,UserID,IsSend,Remarks,EmailID,Cc,Bcc,MailedTo,FromPUPPortal) ");
                sbemail_record_patient.Append(" values('" + Util.GetString(dtEmailData.Rows[0]["LedgerTransactionID"]) + "','" + VisitNo + "','" + testID + "','" + IsAutoMail + "'," + strUserID + "," + IsSend + ",'" + Remarks + "','" + EmailID.Trim() + "','" + Cc.Trim() + "','" + Bcc.Trim() + "','" + MailedTo.Trim() + "','" + FromPUPPortal.Trim() + "');");
                StockReports.ExecuteDML(sbemail_record_patient.ToString());
            }
        }
    }

    public string sendCriticalEmail(string toAddresses, string subject, string emailBody, string ccAddresses = "", string bccAddresses = "", string LabNo = "", string Remarks = "", string MailedTo = "", string IsAutoMail = "")
    {
        string IsSend = "-1";
        try
        {
            MailAddress fromAddress = new MailAddress(FromEmailid, EmailDisplayName);
            client.Timeout = 100000;//more than 1 s
            MailMessage message = new MailMessage();
            message.From = fromAddress;
            message.To.Add(toAddresses);
            message.Subject = subject;
            message.Body = emailBody;
            if (ccAddresses != "") { message.CC.Add(ccAddresses); }
            if (bccAddresses != "") { message.Bcc.Add(bccAddresses); }
            message.BodyEncoding = System.Text.Encoding.UTF8;
            message.IsBodyHtml = true;
            message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
            client.Send(message);
            message.Dispose();
            IsSend = "1";
        }
        catch (Exception ex)
        {
            IsSend = "-1";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Remarks = Util.GetString(ex.GetBaseException());
        }
        finally
        {
            int strUserID = (IsAutoMail.Trim() == "1") ? -1 : Util.GetInt(UserInfo.ID);
            StringBuilder sbEmail_Critical = new StringBuilder();
            sbEmail_Critical.Append(" update  Email_Critical SET IsSent='" + IsSend + "',Remarks='" + Remarks + "',MailedTo='" + MailedTo + "',UpdatedByID='" + strUserID + "',dtSent=now() ");
            sbEmail_Critical.Append(" where LedgertransactionNo='" + LabNo + "' and IsSent=0 ");
            StockReports.ExecuteDML(sbEmail_Critical.ToString());
        }
        return IsSend;
    }
    //public string sendEmailToPatient(string toAddresses, string subject, string emailBody, string testID, string ccAddresses = "", string bccAddresses = "")
    //{
    //    MailAddress fromAddress = new MailAddress(EmailID, EmailDisplayName);
    //    client.Timeout = 100000;//more than 1 s

    //    MailMessage message = new MailMessage();
    //    //Attachment
    //    string reportURL = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port + "/" + HttpContext.Current.Request.Url.AbsolutePath.Split('/')[1];
    //    reportURL += string.Format("/Design/Lab/labreportnew.aspx?testid={0}&isOnlinePrint={1}&PHead={2}", Common.Encrypt(Util.GetString(testID)), Common.Encrypt("1"), Common.Encrypt("1"));
    //    MemoryStream file = this.ConvertToStream(reportURL);
    //    file.Seek(0L, SeekOrigin.Begin);
    //    Attachment objAttach2 = new Attachment(file, "LabReport.pdf", "application/pdf");
    //    ContentDisposition disposition = objAttach2.ContentDisposition;
    //    disposition.CreationDate = DateTime.Now;
    //    disposition.ModificationDate = DateTime.Now;
    //    disposition.DispositionType = "attachment";
    //    message.Attachments.Add(objAttach2);

    //    message.From = fromAddress;
    //    message.To.Add(toAddresses);
    //    message.Subject = subject;
    //    message.Body = emailBody;
    //    if (ccAddresses != "") { message.CC.Add(ccAddresses); }
    //    if (bccAddresses != "") { message.Bcc.Add(bccAddresses); }

    //    message.BodyEncoding = System.Text.Encoding.UTF8;
    //    message.IsBodyHtml = true;
    //    message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

    //    client.Send(message);
    //    // Clean up.
    //    message.Dispose();

    //    return "1";
    //}
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
    public string sendTATReportEmail(string toAddresses, string subject, string emailBody, string ccAddresses = "", string bccAddresses = "", string EmailType = "TAT", DataTable dt = null, string CentreName = "", string CentreID = "")
    {
        string IsSend = "-1";
        try
        {
            MailAddress fromAddress = new MailAddress(EmailID, EmailDisplayName);
            client.Timeout = 100000;//more than 1 s

            MailMessage message = new MailMessage();

            var wb = new XLWorkbook();
            wb.Worksheets.Add(dt);
            byte[] package = ((MemoryStream)GetStream(wb)).ToArray();
            MemoryStream file = new MemoryStream(package);
            file.Seek(0L, SeekOrigin.Begin);
            Attachment objAttach2 = new Attachment(file, "" + CentreName + "_Over_All_Pending_Report_" + DateTime.Now.ToString() + ".xlsx", "application/ms-excel");
            ContentDisposition disposition = objAttach2.ContentDisposition;
            disposition.CreationDate = DateTime.Now;
            disposition.ModificationDate = DateTime.Now;
            disposition.DispositionType = "attachment";
            message.Attachments.Add(objAttach2);

            message.From = fromAddress;
            message.To.Add(toAddresses);
            message.Subject = subject;
            message.Body = emailBody;
            if (ccAddresses != "") { message.CC.Add(ccAddresses); }
            if (bccAddresses != "") { message.Bcc.Add(bccAddresses); }

            message.BodyEncoding = System.Text.Encoding.UTF8;
            message.IsBodyHtml = true;
            message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

            client.Send(message);
            // Clean up.
            message.Dispose();

            IsSend = "1";
        }
        catch (Exception ex)
        {
            IsSend = "-1";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            StringBuilder sbTATLog = new StringBuilder();
            sbTATLog.Append(" Insert into TATReportLog (CentreID,Centre,EmailID,Cc,Bcc,dtEntry,IsSent)");
            sbTATLog.Append(" values (" + CentreID + ",'" + CentreName + "','" + toAddresses + "','" + ccAddresses + "','" + bccAddresses + "',now()," + IsSend + ")");
            StockReports.ExecuteDML(sbTATLog.ToString());
        }
        return IsSend;
    }
    public MemoryStream GetStream(XLWorkbook excelWorkbook)
    {
        MemoryStream fs = new MemoryStream();
        excelWorkbook.SaveAs(fs);
        fs.Position = 0;
        return fs;
    }
    public string sendCustomerCareEmail(string[] toAddresses, string subject, string emailBody, string[] ccAddresses = null, string[] bccAddresses = null, string[] attachmentList = null, string TicketID = "")
    {
        string IsSend = "-1";
        try
        {
            MailAddress fromAddress = new MailAddress(EmailID, EmailDisplayName);
            client.Timeout = 100000;//more than 1 s
            MailMessage message = new MailMessage();
            message.From = fromAddress;

            foreach (string to in toAddresses)
                message.To.Add(new MailAddress(to));
            foreach (string cc in ccAddresses)
                message.CC.Add(new MailAddress(cc));
            foreach (string bcc in bccAddresses)
                message.CC.Add(new MailAddress(bcc));

            message.Subject = subject;
            message.Body = emailBody;

            foreach (string _Attachment in attachmentList)
            {
                message.Attachments.Add(new Attachment(_Attachment));
            }

            message.BodyEncoding = System.Text.Encoding.UTF8;
            message.IsBodyHtml = true;
            message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

            client.Send(message);
            // Clean up.
            message.Dispose();

            IsSend = "1";
        }
        catch (Exception ex)
        {
            IsSend = "-1";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            // saveData(TicketID, "0", "New Ticket", IsSend, "0", toAddresses, ccAddresses, bccAddresses, toAddresses);
        }
        return IsSend;
    }
    public string sendEmailOTP(string toAddresses, string subject, string emailBody, string ccAddresses = "", string bccAddresses = "", string EmployeeID = "", string UserType = "")
    {
        string IsSend = "-1";
        try
        {
            MailAddress fromAddress = new MailAddress(EmailID, EmailDisplayName);
            client.Timeout = 100000;//more than 1 s
            MailMessage message = new MailMessage();
            message.From = fromAddress;
            message.To.Add(toAddresses);
            message.Subject = subject;
            message.Body = emailBody;
            if (ccAddresses != "") { message.CC.Add(ccAddresses); }
            if (bccAddresses != "") { message.Bcc.Add(bccAddresses); }

            message.BodyEncoding = System.Text.Encoding.UTF8;
            message.IsBodyHtml = true;
            message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

            client.Send(message);
            // Clean up.
            message.Dispose();

            IsSend = "1";
        }
        catch (Exception ex)
        {
            IsSend = "-1";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            saveOTPEmailData(toAddresses, ccAddresses, bccAddresses, IsSend, EmployeeID, UserType);
        }
        return IsSend;
    }
    public void saveOTPEmailData(string toAddresses, string ccAddresses, string bccAddresses, string IsSend, string EmployeeID, string UserType)
    {
        StringBuilder saveOTPEmailData = new StringBuilder();
        saveOTPEmailData.Append(" insert into Email_OTP_Log(Email,Cc,Bcc,IsSent,EnteredByID,IpAddress)");
        saveOTPEmailData.Append(" values('" + toAddresses + "','" + ccAddresses + "','" + bccAddresses + "','" + IsSend + "','" + EmployeeID + "','" + StockReports.getip() + "' ) ");
        StockReports.ExecuteDML(saveOTPEmailData.ToString());

    }
    public string SalesEnrolmentEmail(string toAddresses, string subject, string emailBody, string ccAddresses = "", string bccAddresses = "")
    {
        string IsSend = "-1";
        try
        {
            string[] toAddress = toAddresses.Split(',');
            MailAddress fromAddress = new MailAddress(EmailID, EmailDisplayName);
            client.Timeout = 100000;//more than 1 s
            MailMessage message = new MailMessage();
            message.From = fromAddress;
            foreach (string to in toAddress)
                message.To.Add(new MailAddress(to));
            //message.To.Add(new MailAddress(toAddresses));
            message.Subject = subject;
            message.Body = emailBody;
            if (ccAddresses != "") { message.CC.Add(ccAddresses); }
            if (bccAddresses != "") { message.Bcc.Add(bccAddresses); }

            message.BodyEncoding = System.Text.Encoding.UTF8;
            message.IsBodyHtml = true;
            message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

            client.Send(message);

            message.Dispose();

            IsSend = "1";
        }
        catch (Exception ex)
        {
            IsSend = "-1";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {

        }
        return IsSend;
    }
    public string sendDiscountApproval(string toAddresses, string subject, string emailBody, string ccAddresses = "")
    {
        string IsSend = "-1";
        try
        {
            MailAddress fromAddress = new MailAddress(EmailID, EmailDisplayName);
            client.Timeout = 100000;//more than 1 s
            string AttachDisplay = string.Empty;
            using (MailMessage message = new MailMessage())
            {

                message.From = fromAddress;
                message.To.Add(toAddresses);
                message.Subject = subject;
                message.Body = emailBody;
                if (ccAddresses != "") { message.CC.Add(ccAddresses); }
                message.BodyEncoding = System.Text.Encoding.UTF8;
                message.IsBodyHtml = true;
                message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
                client.Send(message);
                IsSend = "1";
            }
        }
        catch (Exception ex)
        {
            IsSend = "-1";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {

        }
        return IsSend;
    }
    public string sendPanelInvoice(string toAddresses, string subject, string emailBody, byte[] body, string ccAddresses = "", string bccAddresses = "", DataTable dt = null, string CentreName = "", string InvoiceDate = "")
    {
        string IsSend = "-1";
        try
        {
            MailAddress fromAddress = new MailAddress(EmailID, EmailDisplayName);
            client.Timeout = 100000;//more than 1 s

            string AttachDisplay = string.Empty;
            if (InvoiceDate != string.Empty)
            {
                AttachDisplay = string.Concat(CentreName, "_", Util.GetDateTime(InvoiceDate).ToString("dd-MM-yyyy"));
            }
            else
            {
                AttachDisplay = CentreName;
            }

            MailMessage message = new MailMessage();

            if (dt != null)
            {
                var wb = new XLWorkbook();
                wb.Worksheets.Add(dt);
                byte[] package = ((MemoryStream)GetStream(wb)).ToArray();
                MemoryStream file = new MemoryStream(package);
                file.Seek(0L, SeekOrigin.Begin);

                Attachment objAttach2 = new Attachment(file, string.Concat(AttachDisplay, ".xlsx"), "application/ms-excel");
                ContentDisposition disposition = objAttach2.ContentDisposition;
                disposition.CreationDate = DateTime.Now;
                disposition.ModificationDate = DateTime.Now;
                disposition.DispositionType = "attachment";
                message.Attachments.Add(objAttach2);
            }

            if (body != null)
            {
                message.Attachments.Add(new Attachment(new MemoryStream(body), string.Concat(AttachDisplay, ".pdf")));
                message.IsBodyHtml = true;

            }





            message.From = fromAddress;
            message.To.Add(toAddresses);
            message.Subject = subject;
            message.Body = emailBody;
            if (ccAddresses != "") { message.CC.Add(ccAddresses); }
            if (bccAddresses != "") { message.Bcc.Add(bccAddresses); }

            message.BodyEncoding = System.Text.Encoding.UTF8;
            message.IsBodyHtml = true;
            message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

            client.Send(message);
            // Clean up.
            message.Dispose();

            IsSend = "1";
        }
        catch (Exception ex)
        {
            IsSend = "-1";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {

        }
        return IsSend;
    }


    public string sendManualEmail(string toAddresses, string subject, string emailBody, string ccAddresses = "", string bccAddresses = "", string LabNo = "", string testID = "", string EmailType = "Normal", string IsAutoMail = "0", string Remarks = "", string MailedTo = "", string FromPUPPortal = "0")
    {

        string IsSend = "-1";
        try
        {
            MailAddress fromAddress = new MailAddress(EmailID, EmailDisplayName);
            client.Timeout = 100000;//more than 1 s

            MailMessage message = new MailMessage();
            if (EmailType.Trim() == "PDF Report")
            {
                //Attachment 
                string reportURL = string.Format("http://localhost/{0}", Resources.Resource.ApplicationURLReportPathName);
                reportURL += string.Format("/Design/Lab/labreportnew.aspx?testid={0}&isOnlinePrint={1}&PHead={2}", Common.Encrypt(Util.GetString(testID)), Common.Encrypt("1"), Common.Encrypt("1"));//Common.Encrypt(Util.GetString(testID)), Common.Encrypt("1"), Common.Encrypt("1")
                MemoryStream file = this.ConvertToStream(reportURL);
                file.Seek(0L, SeekOrigin.Begin);
                Attachment objAttach2 = new Attachment(file, "LabReport.pdf", "application/pdf");
                ContentDisposition disposition = objAttach2.ContentDisposition;
                disposition.CreationDate = DateTime.Now;
                disposition.ModificationDate = DateTime.Now;
                disposition.DispositionType = "attachment";
                message.Attachments.Add(objAttach2);
                file.Dispose();
            }

            message.From = fromAddress;
            message.To.Add(toAddresses);
            message.Subject = subject;// +"AutoMail";
            message.Body = emailBody;
            if (bccAddresses != "") { message.Bcc.Add(bccAddresses); }

            message.BodyEncoding = System.Text.Encoding.UTF8;
            message.IsBodyHtml = true;
            message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

            client.Send(message);
            // Clean up.
            message.Dispose();

            IsSend = "1";
        }
        catch (Exception ex)
        {
            IsSend = "-1";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Remarks = Util.GetString(ex.GetBaseException());
        }
        finally
        {
            UpdateData(LabNo, testID, IsSend);
        }
        return IsSend;
    }

    private void UpdateData(string LabNo, string testID, string IsSend)
    {

        string Status = IsSend == "-1" ? "Failed" : "Send";
        string[] tids = testID.Split(',');
        for (int i = 0; i < tids.Length; i++)
        {
            StringBuilder sbemail_record_patient = new StringBuilder();
            sbemail_record_patient.Append(" Update email_record_patient Set IsSend='" + IsSend + "' WHERE LedgertransactionNo='" + LabNo + "' AND test_Id='" + tids[i] + "' And IsAutoMail=0 ");
            StockReports.ExecuteDML(sbemail_record_patient.ToString());
            sbemail_record_patient = new StringBuilder();
            sbemail_record_patient.Append("INSERT INTO  manual_email_log(LedgerTransactionNo,TestID,Status) VALUES('" + LabNo + "','" + tids[i] + "','" + Status + "')");
            StockReports.ExecuteDML(sbemail_record_patient.ToString());
        }
    }
    public string sendBillEmail(string toAddresses, string subject, string emailBody, string ccAddresses = "", string bccAddresses = "", string LabNo = "", string LabID = "", string EmailType = "Normal", string IsAutoMail = "0", string Remarks = "", string MailedTo = "", string FromPUPPortal = "0", string header = "1")
    {
        string IsSend = "-1";
        try
        {
            MailAddress fromAddress = new MailAddress(EmailID, EmailDisplayName);
            client.Timeout = 100000;//more than 1 s

            MailMessage message = new MailMessage();

            //Attachment
            string reportURL = string.Format("http://localhost/{0}", Resources.Resource.ApplicationURLReportPathName);
            reportURL += string.Format("/design/Lab/PatientReceiptNew1.aspx?LabID={0}", Common.Encrypt( LabID));
            MemoryStream file = this.ConvertToStream(reportURL);
            file.Seek(0L, SeekOrigin.Begin);
            Attachment objAttach2 = new Attachment(file, "Bill.pdf", "application/pdf");
            ContentDisposition disposition = objAttach2.ContentDisposition;
            disposition.CreationDate = DateTime.Now;
            disposition.ModificationDate = DateTime.Now;
            disposition.DispositionType = "attachment";
            message.Attachments.Add(objAttach2);


            message.From = fromAddress;
            message.To.Add(toAddresses);
            message.Subject = subject;
            message.Body = emailBody;
            if (ccAddresses != "") { message.CC.Add(ccAddresses); }
            if (bccAddresses != "") { message.Bcc.Add(bccAddresses); }

            message.BodyEncoding = System.Text.Encoding.UTF8;
            message.IsBodyHtml = true;
            message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

            client.Send(message);
            // Clean up.
            message.Dispose();

            IsSend = "1";
             CreateFolder cf = new CreateFolder();
            cf.CreateNewFolder(IsSend, "Log");
        }
        catch (Exception ex)
        {
            IsSend = "-1";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Remarks = Util.GetString(ex.Message);
        }
        finally
        {

            //int strUserID = (IsAutoMail.Trim() == "1") ? -1 : Util.GetInt(UserInfo.ID);
            //StringBuilder sbemail_record_patient = new StringBuilder();
            //sbemail_record_patient.Append(" INSERT INTO email_record_patient(LedgerTransactionID,LedgerTransactionNo,IsAutoMail,UserID,IsSend,Remarks,EmailID,Cc,Bcc,MailedTo,FromPUPPortal) ");
            //sbemail_record_patient.Append(" values('" + LabID + "','" + LabNo + "','" + IsAutoMail + "'," + strUserID + "," + IsSend + ",'HCBill','" + EmailID.Trim() + "','" + ccAddresses.Trim() + "','" + bccAddresses.Trim() + "','" + MailedTo.Trim() + "','" + FromPUPPortal.Trim() + "'); ");
            //StockReports.ExecuteDML(sbemail_record_patient.ToString());
        }
        return IsSend;
    }
 public string sendPanelInvoiceNew(string InvoiceNo,string toAddresses, string subject, string emailBody, string ccAddresses = "", string bccAddresses = "", DataTable dt = null, string CentreName = "", string InvoiceDate = "")
    {
        string IsSend = "-1";
        try
        {
            MailAddress fromAddress = new MailAddress(EmailID, EmailDisplayName);
            client.Timeout = 100000;//more than 1 s

            string AttachDisplay = string.Empty;
            if (InvoiceDate != string.Empty)
            {
                AttachDisplay = string.Concat(CentreName, "_", Util.GetDateTime(InvoiceDate).ToString("dd-MM-yyyy"));
            }
            else
            {
                AttachDisplay = CentreName;
            }

            MailMessage message = new MailMessage();

            //if (dt != null)
            //{
            //    var wb = new XLWorkbook();
            //    wb.Worksheets.Add(dt);
            //    byte[] package = ((MemoryStream)GetStream(wb)).ToArray();
            //    MemoryStream file = new MemoryStream(package);
            //    file.Seek(0L, SeekOrigin.Begin);

            //    Attachment objAttach2 = new Attachment(file, string.Concat(AttachDisplay, ".xlsx"), "application/ms-excel");
            //    ContentDisposition disposition = objAttach2.ContentDisposition;
            //    disposition.CreationDate = DateTime.Now;
            //    disposition.ModificationDate = DateTime.Now;
            //    disposition.DispositionType = "attachment";
            //    message.Attachments.Add(objAttach2);
            //}

            string reportURL = string.Format("http://localhost/{0}", Resources.Resource.ApplicationURLReportPathName);
            reportURL += string.Format("/Design/Invoicing/InvoiceReceipt.aspx?InvoiceNo={0}", Common.Encrypt(Util.GetString(InvoiceNo)));
            MemoryStream file1 = ConvertToStream(reportURL);
            file1.Seek(0L, SeekOrigin.Begin);
            Attachment objAttach3 = new Attachment(file1, "Invoice.pdf", "application/pdf");
            ContentDisposition disposition1 = objAttach3.ContentDisposition;
            disposition1.CreationDate = DateTime.Now;
            disposition1.ModificationDate = DateTime.Now;
            disposition1.DispositionType = "attachment";

            message.Attachments.Add(objAttach3);





            message.From = fromAddress;
            message.To.Add(toAddresses);
            message.Subject = subject;
            message.Body = emailBody;
            if (ccAddresses != "") { message.CC.Add(ccAddresses); }
            if (bccAddresses != "") { message.Bcc.Add(bccAddresses); }

            message.BodyEncoding = System.Text.Encoding.UTF8;
            message.IsBodyHtml = true;
            message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

            client.Send(message);
            // Clean up.
            message.Dispose();

            IsSend = "1";
        }
        catch (Exception ex)
        {
            IsSend = "-1";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {

        }
        return IsSend;
    }

 public void SendRegistrationMail(int LedgertransactionId, MySqlTransaction Tnx)
 {

     StringBuilder sb = new StringBuilder();

     sb.Append(@"SELECT lt.LedgertransactionNo,DATE_FORMAT(lt.Date,'%d-%b-%Y') EntryDate,ROUND(lt.GrossAmount)GrossAmount,ROUND(lt.NetAmount) NetAmount,ROUND(lt.DiscountOnTotal) DiscountOnTotal,
                ROUND(lt.Adjustment) PaidAmount,lt.PName,lt.Age,lt.Gender,lt.PanelName,lt.Username_web,lt.Password_web 
                ,(SELECT SUBJECT FROM Email_configuration WHERE ID=1 AND IsActive=1) EmailSubject
                ,(SELECT Template FROM Email_configuration WHERE ID=1 AND IsActive=1) EmailBody,pm.Email
                ,(SELECT CONCAT(IsPatient,'#',IsClient) FROM Email_configuration WHERE ID=1 AND IsActive=1)  AllowToWhom,pnl.EmailIdReport,pm.Patient_id,pm.DOB
                FROM f_ledgertransaction lt
                INNER JOIN patient_master pm ON pm.Patient_id=lt.Patient_id
                INNER JOIN centre_master cm ON cm.CentreId=lt.CentreId
                INNER JOIN f_panel_master pnl ON pnl.Panel_Id=lt.Panel_Id
                WHERE cm.Type1Id IN ( 
                SELECT ecc.Type1Id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsActivate=1 AND ec.ID=1 AND panel_Id=0  AND (ec.IsPatient=1 OR ec.IsClient=1)
                ) AND lt.LedgertransactionId=@LedgertransactionId
                AND lt.Panel_Id NOT IN ( SELECT ecc.Panel_id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsDiscard=1 AND ec.ID=1 AND (ec.IsPatient=1 OR ec.IsClient=1))
                UNION 
                SELECT lt.LedgertransactionNo,DATE_FORMAT(lt.Date,'%d-%b-%Y') EntryDate,ROUND(lt.GrossAmount)GrossAmount,ROUND(lt.NetAmount) NetAmount,ROUND(lt.DiscountOnTotal) DiscountOnTotal,
                ROUND(lt.Adjustment) PaidAmount,lt.PName,lt.Age,lt.Gender,lt.PanelName,lt.Username_web,lt.Password_web 
                ,(SELECT SUBJECT FROM Email_configuration WHERE ID=1 AND IsActive=1) EmailSubject
                ,(SELECT Template FROM Email_configuration WHERE ID=1 AND IsActive=1) EmailBody,pm.Email
                ,(SELECT CONCAT(IsPatient,'#',IsClient) FROM Email_configuration WHERE ID=1 AND IsActive=1)  AllowToWhom,pnl.EmailIdReport,pm.Patient_id,pm.DOB
                FROM f_ledgertransaction lt
                INNER JOIN patient_master pm ON pm.Patient_id=lt.Patient_id
                INNER JOIN f_panel_master pnl ON pnl.Panel_Id=lt.Panel_Id
                WHERE pnl.Panel_Id IN ( 
                SELECT ecc.Panel_id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsActivate=1 AND ec.ID=1  AND (ec.IsPatient=1 OR ec.IsClient=1)
                ) AND lt.LedgertransactionId=@LedgertransactionId");

     using (DataTable dt = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, sb.ToString(), new MySqlParameter("@LedgertransactionId", LedgertransactionId)).Tables[0])
     {

         if (dt.Rows.Count > 0)
         {
             string EmailSubject = string.Empty;
             StringBuilder EmailBody = new StringBuilder();
             EmailSubject = Util.GetString(dt.Rows[0]["EmailSubject"]).Replace("{LabNo}", Util.GetString(dt.Rows[0]["LedgertransactionNo"])).Replace("{PName}", Util.GetString(dt.Rows[0]["PName"])).Replace("{Age}", Util.GetString(dt.Rows[0]["Age"])).Replace("{Gender}", Util.GetString(dt.Rows[0]["Gender"])).Replace("{PatientID}", Util.GetString(dt.Rows[0]["Patient_id"])).Replace("{GrossAmount}", Util.GetString(dt.Rows[0]["GrossAmount"])).Replace("{DiscountAmount}", Util.GetString(dt.Rows[0]["DiscountOnTotal"])).Replace("{NetAmount}", Util.GetString(dt.Rows[0]["NetAmount"])).Replace("{PaidAmount}", Util.GetString(dt.Rows[0]["PaidAmount"])).Replace("{UserName}", Util.GetString(dt.Rows[0]["Username_web"])).Replace("{Passowrd}", Util.GetString(dt.Rows[0]["Password_web"])).Replace("{DOB}", Util.GetString(dt.Rows[0]["DOB"]));
             EmailBody.Append(Util.GetString(dt.Rows[0]["EmailBody"]));
             EmailBody.Replace("{LabNo}", Util.GetString(dt.Rows[0]["LedgertransactionNo"])).Replace("{PName}", Util.GetString(dt.Rows[0]["PName"])).Replace("{Age}", Util.GetString(dt.Rows[0]["Age"])).Replace("{Gender}", Util.GetString(dt.Rows[0]["Gender"])).Replace("{PatientID}", Util.GetString(dt.Rows[0]["Patient_id"])).Replace("{GrossAmount}", Util.GetString(dt.Rows[0]["GrossAmount"])).Replace("{DiscountAmount}", Util.GetString(dt.Rows[0]["DiscountOnTotal"])).Replace("{NetAmount}", Util.GetString(dt.Rows[0]["NetAmount"])).Replace("{PaidAmount}", Util.GetString(dt.Rows[0]["PaidAmount"])).Replace("{UserName}", Util.GetString(dt.Rows[0]["Username_web"])).Replace("{Passowrd}", Util.GetString(dt.Rows[0]["Password_web"])).Replace("{DOB}", Util.GetString(dt.Rows[0]["DOB"]));

             //---Check Mail to patient------
             if (Util.GetString(dt.Rows[0]["AllowToWhom"]).Split('#')[0] == "1" && Util.GetString(dt.Rows[0]["Email"]) != "")
             {
                 string IsSend = "-1";
                 try
                 {
                     MailAddress fromAddress = new MailAddress(FromEmailid, EmailDisplayName);
                     client.Timeout = 100000;//more than 1 s

                     MailMessage message = new MailMessage();

                     //Attachment
			try{
                     string reportURL = "http://itd-saas.cl-srv.ondgni.com/uat_ver1";// string.Format(Util.getApp("ApplicationHost"));
                     reportURL += string.Format("/Design/Lab/{0}?LabId={1}", Resources.Resource.PatientReceiptURL, Common.Encrypt(Util.GetString(LedgertransactionId)));
                    // System.IO.File.WriteAllText(@"C:\ITDOSE\UAT_Ver1\ErrorLog\reportURL.txt", reportURL.ToString());
                     MemoryStream file = this.ConvertToStream(reportURL);
                     file.Seek(0L, SeekOrigin.Begin);
                     Attachment objAttach2 = new Attachment(file, "PatientReceipt.pdf", "application/pdf");
                     ContentDisposition disposition = objAttach2.ContentDisposition;
                     disposition.CreationDate = DateTime.Now;
                     disposition.ModificationDate = DateTime.Now;
                     disposition.DispositionType = "attachment";
                     message.Attachments.Add(objAttach2);
			} catch{}


                     message.From = fromAddress;
                     message.To.Add(Util.GetString(dt.Rows[0]["Email"]));
                     message.Subject = EmailSubject;
                     message.Body = EmailBody.ToString();
                     message.BodyEncoding = System.Text.Encoding.UTF8;
                     message.IsBodyHtml = true;
                     message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
                     client.EnableSsl = true;
                     client.Send(message);
                     // Clean up.
                     message.Dispose();
                     IsSend = "1";

                 }
                 catch (Exception ex)
                 {
                     IsSend = "-1";
                     ClassLog cl = new ClassLog();
                     cl.errLog(ex);
                 }
                 finally
                 {
                     SaveEmailData(Tnx, LedgertransactionId, Util.GetString(dt.Rows[0]["LedgertransactionNo"]), 1, UserInfo.ID, IsSend, "Patient Receipt", Util.GetString(dt.Rows[0]["Email"]), "Patient", EmailSubject, EmailBody.ToString(), 1);
                 }


             }

             //---Check Mail to client------
             if (Util.GetString(dt.Rows[0]["AllowToWhom"]).Split('#')[1] == "1" && Util.GetString(dt.Rows[0]["EmailIdReport"]) != "")
             {
                 string IsSend = "-1";
                 try
                 {
                     MailAddress fromAddress = new MailAddress(FromEmailid, EmailDisplayName);
                     client.Timeout = 100000;//more than 1 s

                     MailMessage message = new MailMessage();

                     //Attachment
                     string reportURL = string.Format(Util.getApp("ApplicationHost"));
                     reportURL += string.Format("/Design/Lab/{0}?LabId={1}", Resources.Resource.PatientReceiptURL, Common.Encrypt(Util.GetString(LedgertransactionId)));
                     MemoryStream file = this.ConvertToStream(reportURL);
                     file.Seek(0L, SeekOrigin.Begin);
                     Attachment objAttach2 = new Attachment(file, "PatientReceipt.pdf", "application/pdf");
                     ContentDisposition disposition = objAttach2.ContentDisposition;
                     disposition.CreationDate = DateTime.Now;
                     disposition.ModificationDate = DateTime.Now;
                     disposition.DispositionType = "attachment";
                     message.Attachments.Add(objAttach2);


                     message.From = fromAddress;
                     message.To.Add(Util.GetString(dt.Rows[0]["EmailIdReport"]));
                     message.Subject = EmailSubject;
                     message.Body = EmailBody.ToString();
                     message.BodyEncoding = System.Text.Encoding.UTF8;
                     message.IsBodyHtml = true;
                     message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

                     client.Send(message);
                     // Clean up.
                     message.Dispose();
                     IsSend = "1";

                 }
                 catch (Exception ex)
                 {
                     IsSend = "-1";
                     ClassLog cl = new ClassLog();
                     cl.errLog(ex);
                 }
                 finally
                 {
                     SaveEmailData(Tnx, LedgertransactionId, Util.GetString(dt.Rows[0]["LedgertransactionNo"]), 1, UserInfo.ID, IsSend, "Patient Receipt", Util.GetString(dt.Rows[0]["EmailIdReport"]), "Client", EmailSubject, EmailBody.ToString(), 1);

                 }
             }
         }
     }

 }

 public void SendSettlementMail(int LedgertransactionId, MySqlTransaction Tnx)
 {

     StringBuilder sb = new StringBuilder();

     sb.Append(@"SELECT lt.LedgertransactionNo,DATE_FORMAT(lt.Date,'%d-%b-%Y') EntryDate,ROUND(lt.GrossAmount)GrossAmount,ROUND(lt.NetAmount) NetAmount,ROUND(lt.DiscountOnTotal) DiscountOnTotal,
                ROUND(lt.Adjustment) PaidAmount,lt.PName,lt.Age,lt.Gender,lt.PanelName,lt.Username_web,lt.Password_web 
                ,(SELECT SUBJECT FROM Email_configuration WHERE ID=6 AND IsActive=1) EmailSubject
                ,(SELECT Template FROM Email_configuration WHERE ID=6 AND IsActive=1) EmailBody,pm.Email
                ,(SELECT CONCAT(IsPatient,'#',IsClient) FROM Email_configuration WHERE ID=6 AND IsActive=1)  AllowToWhom,pnl.EmailIdReport,pm.Patient_id,pm.DOB
                FROM f_ledgertransaction lt
                INNER JOIN patient_master pm ON pm.Patient_id=lt.Patient_id
                INNER JOIN centre_master cm ON cm.CentreId=lt.CentreId
                INNER JOIN f_panel_master pnl ON pnl.Panel_Id=lt.Panel_Id
                WHERE cm.Type1Id IN ( 
                SELECT ecc.Type1Id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsActivate=1 AND ec.ID=1 AND panel_Id=0  AND (ec.IsPatient=1 OR ec.IsClient=1)
                ) AND lt.LedgertransactionId=@LedgertransactionId
                AND lt.Panel_Id NOT IN ( SELECT ecc.Panel_id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsDiscard=1 AND ec.ID=6 AND (ec.IsPatient=1 OR ec.IsClient=1))
                UNION 
                SELECT lt.LedgertransactionNo,DATE_FORMAT(lt.Date,'%d-%b-%Y') EntryDate,ROUND(lt.GrossAmount)GrossAmount,ROUND(lt.NetAmount) NetAmount,ROUND(lt.DiscountOnTotal) DiscountOnTotal,
                ROUND(lt.Adjustment) PaidAmount,lt.PName,lt.Age,lt.Gender,lt.PanelName,lt.Username_web,lt.Password_web 
                ,(SELECT SUBJECT FROM Email_configuration WHERE ID=1 AND IsActive=6) EmailSubject
                ,(SELECT Template FROM Email_configuration WHERE ID=1 AND IsActive=6) EmailBody,pm.Email
                ,(SELECT CONCAT(IsPatient,'#',IsClient) FROM Email_configuration WHERE ID=1 AND IsActive=1)  AllowToWhom,pnl.EmailIdReport,pm.Patient_id,pm.DOB
                FROM f_ledgertransaction lt
                INNER JOIN patient_master pm ON pm.Patient_id=lt.Patient_id
                INNER JOIN f_panel_master pnl ON pnl.Panel_Id=lt.Panel_Id
                WHERE pnl.Panel_Id IN ( 
                SELECT ecc.Panel_id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsActivate=1 AND ec.ID=6  AND (ec.IsPatient=1 OR ec.IsClient=1)
                ) AND lt.LedgertransactionId=@LedgertransactionId");

     using (DataTable dt = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, sb.ToString(), new MySqlParameter("@LedgertransactionId", LedgertransactionId)).Tables[0])
     {

         if (dt.Rows.Count > 0)
         {
             string EmailSubject = string.Empty;
             StringBuilder EmailBody = new StringBuilder();
             EmailSubject = Util.GetString(dt.Rows[0]["EmailSubject"]).Replace("{LabNo}", Util.GetString(dt.Rows[0]["LedgertransactionNo"])).Replace("{PName}", Util.GetString(dt.Rows[0]["PName"])).Replace("{Age}", Util.GetString(dt.Rows[0]["Age"])).Replace("{Gender}", Util.GetString(dt.Rows[0]["Gender"])).Replace("{PatientID}", Util.GetString(dt.Rows[0]["Patient_id"])).Replace("{GrossAmount}", Util.GetString(dt.Rows[0]["GrossAmount"])).Replace("{DiscountAmount}", Util.GetString(dt.Rows[0]["DiscountOnTotal"])).Replace("{NetAmount}", Util.GetString(dt.Rows[0]["NetAmount"])).Replace("{PaidAmount}", Util.GetString(dt.Rows[0]["PaidAmount"])).Replace("{UserName}", Util.GetString(dt.Rows[0]["Username_web"])).Replace("{Passowrd}", Util.GetString(dt.Rows[0]["Password_web"])).Replace("{DOB}", Util.GetString(dt.Rows[0]["DOB"]));
             EmailBody.Append(Util.GetString(dt.Rows[0]["EmailBody"]));
             EmailBody.Replace("{LabNo}", Util.GetString(dt.Rows[0]["LedgertransactionNo"])).Replace("{PName}", Util.GetString(dt.Rows[0]["PName"])).Replace("{Age}", Util.GetString(dt.Rows[0]["Age"])).Replace("{Gender}", Util.GetString(dt.Rows[0]["Gender"])).Replace("{PatientID}", Util.GetString(dt.Rows[0]["Patient_id"])).Replace("{GrossAmount}", Util.GetString(dt.Rows[0]["GrossAmount"])).Replace("{DiscountAmount}", Util.GetString(dt.Rows[0]["DiscountOnTotal"])).Replace("{NetAmount}", Util.GetString(dt.Rows[0]["NetAmount"])).Replace("{PaidAmount}", Util.GetString(dt.Rows[0]["PaidAmount"])).Replace("{UserName}", Util.GetString(dt.Rows[0]["Username_web"])).Replace("{Passowrd}", Util.GetString(dt.Rows[0]["Password_web"])).Replace("{DOB}", Util.GetString(dt.Rows[0]["DOB"]));

             //---Check Mail to patient------
             if (Util.GetString(dt.Rows[0]["AllowToWhom"]).Split('#')[0] == "1" && Util.GetString(dt.Rows[0]["Email"]) != "")
             {
                 string IsSend = "-1";
                 try
                 {
                     MailAddress fromAddress = new MailAddress(FromEmailid, EmailDisplayName);
                     client.Timeout = 100000;//more than 1 s

                     MailMessage message = new MailMessage();

                     message.From = fromAddress;
                     message.To.Add(Util.GetString(dt.Rows[0]["Email"]));
                     message.Subject = EmailSubject;
                     message.Body = EmailBody.ToString();
                     message.BodyEncoding = System.Text.Encoding.UTF8;
                     message.IsBodyHtml = true;
                     message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
                     client.EnableSsl = true;
                     client.Send(message);
                     // Clean up.
                     message.Dispose();
                     IsSend = "1";

                 }
                 catch (Exception ex)
                 {
                     IsSend = "-1";
                     ClassLog cl = new ClassLog();
                     cl.errLog(ex);
                 }
                 finally
                 {
                     SaveEmailData(Tnx, LedgertransactionId, Util.GetString(dt.Rows[0]["LedgertransactionNo"]), 1, UserInfo.ID, IsSend, "Payment Settlement", Util.GetString(dt.Rows[0]["Email"]), "Patient", EmailSubject, EmailBody.ToString(), 0);
                 }


             }


         }
     }

 }

 public void SendInvoiceMail(string InvoiceNo, string PanelId, MySqlTransaction Tnx)
 {

     StringBuilder sb = new StringBuilder();

     sb.Append(@"
                SELECT im.`InvoiceNo`,DATE_FORMAT(im.`InvoiceDate`,'%d-%b-%Y') InvoiceDate,ROUND(im.GrossAmount)GrossAmount,ROUND(im.NetAmount) NetAmount,ROUND(im.DiscountOnTotal) DiscountOnTotal,
                ROUND(im.ShareAmt) ShareAmt,pnl.Company_Name PanelName
                ,(SELECT SUBJECT FROM Email_configuration WHERE ID=4 AND IsActive=1) EmailSubject
                ,(SELECT Template FROM Email_configuration WHERE ID=4 AND IsActive=1) EmailBody
                ,(SELECT IsClient FROM Email_configuration WHERE ID=4 AND IsActive=1)  AllowToWhom,pnl.InvoiceEmailTo EmailIdReport
                FROM invoiceMaster im
                INNER JOIN f_panel_master pnl ON pnl.Panel_Id=im.PanelId
                INNER JOIN centre_master cm ON cm.CentreId=pnl.CentreId
                WHERE im.InvoiceNo=@InvoiceNo  AND im.PanelId=@PanelId AND cm.Type1Id IN ( 
                SELECT ecc.Type1Id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsActivate=1 AND ec.ID=4 AND panel_Id=0  AND (ec.IsPatient=1 OR ec.IsClient=1)
                ) 
                AND pnl.Panel_Id NOT IN ( SELECT ecc.Panel_id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsDiscard=1 AND ec.ID=4 AND (ec.IsPatient=1 OR ec.IsClient=1))
                UNION 
                SELECT im.`InvoiceNo`,DATE_FORMAT(im.`InvoiceDate`,'%d-%b-%Y') InvoiceDate,ROUND(im.GrossAmount)GrossAmount,ROUND(im.NetAmount) NetAmount,ROUND(im.DiscountOnTotal) DiscountOnTotal,
                ROUND(im.ShareAmt) ShareAmt,pnl.Company_Name PanelName
                ,(SELECT SUBJECT FROM Email_configuration WHERE ID=4 AND IsActive=1) EmailSubject
                ,(SELECT Template FROM Email_configuration WHERE ID=4 AND IsActive=1) EmailBody
                ,(SELECT IsClient FROM Email_configuration WHERE ID=4 AND IsActive=1)  AllowToWhom,pnl.InvoiceEmailTo EmailIdReport
                FROM invoiceMaster im
                INNER JOIN f_panel_master pnl ON pnl.Panel_Id=im.PanelId
                WHERE pnl.Panel_Id IN ( 
                SELECT ecc.Panel_id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsActivate=1 AND ec.ID=4  AND ec.IsClient=1
                ) AND im.InvoiceNo=@InvoiceNo AND im.PanelId=@PanelId
               ");
     // {InvoiceNo} {InvoiceDate} {GrossAmount} {NetAmount} {DiscountOnTotal} {ShareAmt} {PanelName}
     using (DataTable dt = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, sb.ToString(), new MySqlParameter("@InvoiceNo", InvoiceNo), new MySqlParameter("@PanelId", PanelId)).Tables[0])
     {

         if (dt.Rows.Count > 0)
         {
             string EmailSubject = string.Empty;
             StringBuilder EmailBody = new StringBuilder();
             EmailSubject = Util.GetString(dt.Rows[0]["EmailSubject"]).Replace("{InvoiceNo}", Util.GetString(dt.Rows[0]["InvoiceNo"])).Replace("{InvoiceDate}", Util.GetString(dt.Rows[0]["InvoiceDate"])).Replace("{GrossAmount}", Util.GetString(dt.Rows[0]["GrossAmount"])).Replace("{NetAmount}", Util.GetString(dt.Rows[0]["NetAmount"])).Replace("{DiscountOnTotal}", Util.GetString(dt.Rows[0]["DiscountOnTotal"])).Replace("{ShareAmt}", Util.GetString(dt.Rows[0]["ShareAmt"])).Replace("{PanelName}", Util.GetString(dt.Rows[0]["PanelName"]));
             EmailBody.Append(Util.GetString(dt.Rows[0]["EmailBody"]));
             EmailBody.Replace("{InvoiceNo}", Util.GetString(dt.Rows[0]["InvoiceNo"])).Replace("{InvoiceDate}", Util.GetString(dt.Rows[0]["InvoiceDate"])).Replace("{GrossAmount}", Util.GetString(dt.Rows[0]["GrossAmount"])).Replace("{NetAmount}", Util.GetString(dt.Rows[0]["NetAmount"])).Replace("{DiscountOnTotal}", Util.GetString(dt.Rows[0]["DiscountOnTotal"])).Replace("{ShareAmt}", Util.GetString(dt.Rows[0]["ShareAmt"])).Replace("{PanelName}", Util.GetString(dt.Rows[0]["PanelName"]));

             //---Check Mail to patient------
             if (Util.GetString(dt.Rows[0]["AllowToWhom"]).Split('#')[0] == "1" && Util.GetString(dt.Rows[0]["EmailIdReport"]) != "")
             {
                 string IsSend = "-1";
                 try
                 {
                     MailAddress fromAddress = new MailAddress(FromEmailid, EmailDisplayName);
                     client.Timeout = 100000;//more than 1 s

                     MailMessage message = new MailMessage();

                     message.From = fromAddress;
                     message.To.Add(Util.GetString(dt.Rows[0]["EmailIdReport"]));
                     message.Subject = EmailSubject;
                     message.Body = EmailBody.ToString();
                     message.BodyEncoding = System.Text.Encoding.UTF8;
                     message.IsBodyHtml = true;
                     message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
                     client.EnableSsl = true;
                     client.Send(message);
                     // Clean up.
                     message.Dispose();
                     IsSend = "1";

                 }
                 catch (Exception ex)
                 {
                     IsSend = "-1";
                     ClassLog cl = new ClassLog();
                     cl.errLog(ex);
                 }
                 finally
                 {
                     SaveEmailData(Tnx, Util.GetInt(PanelId), Util.GetString(dt.Rows[0]["InvoiceNo"]), 1, UserInfo.ID, IsSend, "Client Invoice", Util.GetString(dt.Rows[0]["EmailIdReport"]), "Client", EmailSubject, EmailBody.ToString(), 0);
                 }


             }


         }
     }

 }

 public void SendClientPaymentMail(int LedgertransactionId, MySqlTransaction Tnx)
 {

     StringBuilder sb = new StringBuilder();

     sb.Append(@"SELECT lt.LedgertransactionNo,DATE_FORMAT(lt.Date,'%d-%b-%Y') EntryDate,ROUND(lt.GrossAmount)GrossAmount,ROUND(lt.NetAmount) NetAmount,ROUND(lt.DiscountOnTotal) DiscountOnTotal,
                ROUND(lt.Adjustment) PaidAmount,lt.PName,lt.Age,lt.Gender,lt.PanelName,lt.Username_web,lt.Password_web 
                ,(SELECT SUBJECT FROM Email_configuration WHERE ID=6 AND IsActive=1) EmailSubject
                ,(SELECT Template FROM Email_configuration WHERE ID=6 AND IsActive=1) EmailBody,pm.Email
                ,(SELECT CONCAT(IsPatient,'#',IsClient) FROM Email_configuration WHERE ID=6 AND IsActive=1)  AllowToWhom,pnl.EmailIdReport,pm.Patient_id,pm.DOB
                FROM f_ledgertransaction lt
                INNER JOIN patient_master pm ON pm.Patient_id=lt.Patient_id
                INNER JOIN centre_master cm ON cm.CentreId=lt.CentreId
                INNER JOIN f_panel_master pnl ON pnl.Panel_Id=lt.Panel_Id
                WHERE cm.Type1Id IN ( 
                SELECT ecc.Type1Id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsActivate=1 AND ec.ID=1 AND panel_Id=0  AND (ec.IsPatient=1 OR ec.IsClient=1)
                ) AND lt.LedgertransactionId=@LedgertransactionId
                AND lt.Panel_Id NOT IN ( SELECT ecc.Panel_id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsDiscard=1 AND ec.ID=6 AND (ec.IsPatient=1 OR ec.IsClient=1))
                UNION 
                SELECT lt.LedgertransactionNo,DATE_FORMAT(lt.Date,'%d-%b-%Y') EntryDate,ROUND(lt.GrossAmount)GrossAmount,ROUND(lt.NetAmount) NetAmount,ROUND(lt.DiscountOnTotal) DiscountOnTotal,
                ROUND(lt.Adjustment) PaidAmount,lt.PName,lt.Age,lt.Gender,lt.PanelName,lt.Username_web,lt.Password_web 
                ,(SELECT SUBJECT FROM Email_configuration WHERE ID=1 AND IsActive=6) EmailSubject
                ,(SELECT Template FROM Email_configuration WHERE ID=1 AND IsActive=6) EmailBody,pm.Email
                ,(SELECT CONCAT(IsPatient,'#',IsClient) FROM Email_configuration WHERE ID=1 AND IsActive=1)  AllowToWhom,pnl.EmailIdReport,pm.Patient_id,pm.DOB
                FROM f_ledgertransaction lt
                INNER JOIN patient_master pm ON pm.Patient_id=lt.Patient_id
                INNER JOIN f_panel_master pnl ON pnl.Panel_Id=lt.Panel_Id
                WHERE pnl.Panel_Id IN ( 
                SELECT ecc.Panel_id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsActivate=1 AND ec.ID=6  AND (ec.IsPatient=1 OR ec.IsClient=1)
                ) AND lt.LedgertransactionId=@LedgertransactionId");

     using (DataTable dt = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, sb.ToString(), new MySqlParameter("@LedgertransactionId", LedgertransactionId)).Tables[0])
     {

         if (dt.Rows.Count > 0)
         {
             string EmailSubject = string.Empty;
             StringBuilder EmailBody = new StringBuilder();
             EmailSubject = Util.GetString(dt.Rows[0]["EmailSubject"]).Replace("{LabNo}", Util.GetString(dt.Rows[0]["LedgertransactionNo"])).Replace("{PName}", Util.GetString(dt.Rows[0]["PName"])).Replace("{Age}", Util.GetString(dt.Rows[0]["Age"])).Replace("{Gender}", Util.GetString(dt.Rows[0]["Gender"])).Replace("{PatientID}", Util.GetString(dt.Rows[0]["Patient_id"])).Replace("{GrossAmount}", Util.GetString(dt.Rows[0]["GrossAmount"])).Replace("{DiscountAmount}", Util.GetString(dt.Rows[0]["DiscountOnTotal"])).Replace("{NetAmount}", Util.GetString(dt.Rows[0]["NetAmount"])).Replace("{PaidAmount}", Util.GetString(dt.Rows[0]["PaidAmount"])).Replace("{UserName}", Util.GetString(dt.Rows[0]["Username_web"])).Replace("{Passowrd}", Util.GetString(dt.Rows[0]["Password_web"])).Replace("{DOB}", Util.GetString(dt.Rows[0]["DOB"]));
             EmailBody.Append(Util.GetString(dt.Rows[0]["EmailBody"]));
             EmailBody.Replace("{LabNo}", Util.GetString(dt.Rows[0]["LedgertransactionNo"])).Replace("{PName}", Util.GetString(dt.Rows[0]["PName"])).Replace("{Age}", Util.GetString(dt.Rows[0]["Age"])).Replace("{Gender}", Util.GetString(dt.Rows[0]["Gender"])).Replace("{PatientID}", Util.GetString(dt.Rows[0]["Patient_id"])).Replace("{GrossAmount}", Util.GetString(dt.Rows[0]["GrossAmount"])).Replace("{DiscountAmount}", Util.GetString(dt.Rows[0]["DiscountOnTotal"])).Replace("{NetAmount}", Util.GetString(dt.Rows[0]["NetAmount"])).Replace("{PaidAmount}", Util.GetString(dt.Rows[0]["PaidAmount"])).Replace("{UserName}", Util.GetString(dt.Rows[0]["Username_web"])).Replace("{Passowrd}", Util.GetString(dt.Rows[0]["Password_web"])).Replace("{DOB}", Util.GetString(dt.Rows[0]["DOB"]));

             //---Check Mail to patient------
             if (Util.GetString(dt.Rows[0]["AllowToWhom"]).Split('#')[0] == "1" && Util.GetString(dt.Rows[0]["Email"]) != "")
             {
                 string IsSend = "-1";
                 try
                 {
                     MailAddress fromAddress = new MailAddress(FromEmailid, EmailDisplayName);
                     client.Timeout = 100000;//more than 1 s

                     MailMessage message = new MailMessage();

                     message.From = fromAddress;
                     message.To.Add(Util.GetString(dt.Rows[0]["Email"]));
                     message.Subject = EmailSubject;
                     message.Body = EmailBody.ToString();
                     message.BodyEncoding = System.Text.Encoding.UTF8;
                     message.IsBodyHtml = true;
                     message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
                     client.EnableSsl = true;
                     client.Send(message);
                     // Clean up.
                     message.Dispose();
                     IsSend = "1";

                 }
                 catch (Exception ex)
                 {
                     IsSend = "-1";
                     ClassLog cl = new ClassLog();
                     cl.errLog(ex);
                 }
                 finally
                 {
                     SaveEmailData(Tnx, LedgertransactionId, Util.GetString(dt.Rows[0]["LedgertransactionNo"]), 1, UserInfo.ID, IsSend, "Payment Settlement", Util.GetString(dt.Rows[0]["Email"]), "Patient", EmailSubject, EmailBody.ToString(), 0);
                 }


             }


         }
     }

 }

  public void SendRegistrationMail(int LedgertransactionId)
    {
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    StringBuilder sb = new StringBuilder();

                    sb.Append(@"SELECT lt.LedgertransactionNo,DATE_FORMAT(lt.Date,'%d-%b-%Y') EntryDate,ROUND(lt.GrossAmount)GrossAmount,ROUND(lt.NetAmount) NetAmount,ROUND(lt.DiscountOnTotal) DiscountOnTotal,
                ROUND(lt.Adjustment) PaidAmount,lt.PName,lt.Age,lt.Gender,lt.PanelName,lt.Username_web,lt.Password_web 
                ,(SELECT SUBJECT FROM Email_configuration WHERE ID=1 AND IsActive=1) EmailSubject
                ,(SELECT Template FROM Email_configuration WHERE ID=1 AND IsActive=1) EmailBody,pm.Email
                ,(SELECT CONCAT(IsPatient,'#',IsClient) FROM Email_configuration WHERE ID=1 AND IsActive=1)  AllowToWhom,pnl.EmailIdReport,pm.Patient_id,pm.DOB
                FROM f_ledgertransaction lt
                INNER JOIN patient_master pm ON pm.Patient_id=lt.Patient_id
                INNER JOIN centre_master cm ON cm.CentreId=lt.CentreId
                INNER JOIN f_panel_master pnl ON pnl.Panel_Id=lt.Panel_Id
                WHERE cm.Type1Id IN ( 
                SELECT ecc.Type1Id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsActivate=1 AND ec.ID=1 AND panel_Id=0  AND (ec.IsPatient=1 OR ec.IsClient=1)
                ) AND lt.LedgertransactionId=@LedgertransactionId
                AND lt.Panel_Id NOT IN ( SELECT ecc.Panel_id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsDiscard=1 AND ec.ID=1 AND (ec.IsPatient=1 OR ec.IsClient=1))
                UNION 
                SELECT lt.LedgertransactionNo,DATE_FORMAT(lt.Date,'%d-%b-%Y') EntryDate,ROUND(lt.GrossAmount)GrossAmount,ROUND(lt.NetAmount) NetAmount,ROUND(lt.DiscountOnTotal) DiscountOnTotal,
                ROUND(lt.Adjustment) PaidAmount,lt.PName,lt.Age,lt.Gender,lt.PanelName,lt.Username_web,lt.Password_web 
                ,(SELECT SUBJECT FROM Email_configuration WHERE ID=1 AND IsActive=1) EmailSubject
                ,(SELECT Template FROM Email_configuration WHERE ID=1 AND IsActive=1) EmailBody,pm.Email
                ,(SELECT CONCAT(IsPatient,'#',IsClient) FROM Email_configuration WHERE ID=1 AND IsActive=1)  AllowToWhom,pnl.EmailIdReport,pm.Patient_id,pm.DOB
                FROM f_ledgertransaction lt
                INNER JOIN patient_master pm ON pm.Patient_id=lt.Patient_id
                INNER JOIN f_panel_master pnl ON pnl.Panel_Id=lt.Panel_Id
                WHERE pnl.Panel_Id IN ( 
                SELECT ecc.Panel_id FROM email_configuration_client ecc INNER JOIN Email_configuration ec ON ec.Id=ecc.EmailConfigurationId AND ec.IsActive=1 AND ecc.IsActivate=1 AND ec.ID=1  AND (ec.IsPatient=1 OR ec.IsClient=1)
                ) AND lt.LedgertransactionId=@LedgertransactionId");

                    using (DataTable dt = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, sb.ToString(), new MySqlParameter("@LedgertransactionId", LedgertransactionId)).Tables[0])
                    {

                        if (dt.Rows.Count > 0)
                        {
                            string EmailSubject = string.Empty;
                            StringBuilder EmailBody = new StringBuilder();
                            EmailSubject = Util.GetString(dt.Rows[0]["EmailSubject"]).Replace("{LabNo}", Util.GetString(dt.Rows[0]["LedgertransactionNo"])).Replace("{PName}", Util.GetString(dt.Rows[0]["PName"])).Replace("{Age}", Util.GetString(dt.Rows[0]["Age"])).Replace("{Gender}", Util.GetString(dt.Rows[0]["Gender"])).Replace("{PatientID}", Util.GetString(dt.Rows[0]["Patient_id"])).Replace("{GrossAmount}", Util.GetString(dt.Rows[0]["GrossAmount"])).Replace("{DiscountAmount}", Util.GetString(dt.Rows[0]["DiscountOnTotal"])).Replace("{NetAmount}", Util.GetString(dt.Rows[0]["NetAmount"])).Replace("{PaidAmount}", Util.GetString(dt.Rows[0]["PaidAmount"])).Replace("{UserName}", Util.GetString(dt.Rows[0]["Username_web"])).Replace("{Passowrd}", Util.GetString(dt.Rows[0]["Password_web"])).Replace("{DOB}", Util.GetString(dt.Rows[0]["DOB"]));
                            EmailBody.Append(Util.GetString(dt.Rows[0]["EmailBody"]));
                            EmailBody.Replace("{LabNo}", Util.GetString(dt.Rows[0]["LedgertransactionNo"])).Replace("{PName}", Util.GetString(dt.Rows[0]["PName"])).Replace("{Age}", Util.GetString(dt.Rows[0]["Age"])).Replace("{Gender}", Util.GetString(dt.Rows[0]["Gender"])).Replace("{PatientID}", Util.GetString(dt.Rows[0]["Patient_id"])).Replace("{GrossAmount}", Util.GetString(dt.Rows[0]["GrossAmount"])).Replace("{DiscountAmount}", Util.GetString(dt.Rows[0]["DiscountOnTotal"])).Replace("{NetAmount}", Util.GetString(dt.Rows[0]["NetAmount"])).Replace("{PaidAmount}", Util.GetString(dt.Rows[0]["PaidAmount"])).Replace("{UserName}", Util.GetString(dt.Rows[0]["Username_web"])).Replace("{Passowrd}", Util.GetString(dt.Rows[0]["Password_web"])).Replace("{DOB}", Util.GetString(dt.Rows[0]["DOB"]));

                            //---Check Mail to patient------
                            if (Util.GetString(dt.Rows[0]["AllowToWhom"]).Split('#')[0] == "1" && Util.GetString(dt.Rows[0]["Email"]) != "")
                            {
                                string IsSend = "-1";
                                try
                                {
                                    MailAddress fromAddress = new MailAddress(FromEmailid, EmailDisplayName);
                                    client.Timeout = 100000;//more than 1 s

                                    MailMessage message = new MailMessage();

                                    //Attachment
                                    string reportURL = "http://itd-saas.cl-srv.ondgni.com/uat_ver1";//string.Format(Util.getApp("ApplicationHost"));
                                    reportURL += string.Format("/Design/Lab/{0}?LabId={1}", Resources.Resource.PatientReceiptURL, Common.Encrypt(Util.GetString(LedgertransactionId)));
                                   // System.IO.File.WriteAllText(@"C:\ITDOSE\UAT_Ver1\ErrorLog\reportURL.txt", reportURL.ToString());
                                    MemoryStream file = this.ConvertToStream(reportURL);
                                    file.Seek(0L, SeekOrigin.Begin);
                                    Attachment objAttach2 = new Attachment(file, "PatientReceipt.pdf", "application/pdf");
                                    ContentDisposition disposition = objAttach2.ContentDisposition;
                                    disposition.CreationDate = DateTime.Now;
                                    disposition.ModificationDate = DateTime.Now;
                                    disposition.DispositionType = "attachment";
                                    message.Attachments.Add(objAttach2);


                                    message.From = fromAddress;
                                    message.To.Add(Util.GetString(dt.Rows[0]["Email"]));
                                    message.Subject = EmailSubject;
                                    message.Body = EmailBody.ToString();
                                    message.BodyEncoding = System.Text.Encoding.UTF8;
                                    message.IsBodyHtml = true;
                                    message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
                                    client.EnableSsl = true;
                                    client.Send(message);
                                    // Clean up.
                                    message.Dispose();
                                    IsSend = "1";

                                }
                                catch (Exception ex)
                                {
                                    IsSend = "-1";
                                    ClassLog cl = new ClassLog();
                                    cl.errLog(ex);
                                }
                                finally
                                {
                                    SaveEmailData(Tnx, LedgertransactionId, Util.GetString(dt.Rows[0]["LedgertransactionNo"]), 1, UserInfo.ID, IsSend, "Patient Receipt", Util.GetString(dt.Rows[0]["Email"]), "Patient", EmailSubject, EmailBody.ToString(), 1);
                                }


                            }

                            //---Check Mail to client------
                            if (Util.GetString(dt.Rows[0]["AllowToWhom"]).Split('#')[1] == "1" && Util.GetString(dt.Rows[0]["EmailIdReport"]) != "")
                            {
                                string IsSend = "-1";
                                try
                                {
                                    MailAddress fromAddress = new MailAddress(FromEmailid, EmailDisplayName);
                                    client.Timeout = 100000;//more than 1 s

                                    MailMessage message = new MailMessage();

                                    //Attachment
                                    string reportURL = string.Format(Util.getApp("ApplicationHost"));
                                    reportURL += string.Format("/Design/Lab/{0}?LabId={1}", Resources.Resource.PatientReceiptURL, Common.Encrypt(Util.GetString(LedgertransactionId)));
                                    MemoryStream file = this.ConvertToStream(reportURL);
                                    file.Seek(0L, SeekOrigin.Begin);
                                    Attachment objAttach2 = new Attachment(file, "PatientReceipt.pdf", "application/pdf");
                                    ContentDisposition disposition = objAttach2.ContentDisposition;
                                    disposition.CreationDate = DateTime.Now;
                                    disposition.ModificationDate = DateTime.Now;
                                    disposition.DispositionType = "attachment";
                                    message.Attachments.Add(objAttach2);


                                    message.From = fromAddress;
                                    message.To.Add(Util.GetString(dt.Rows[0]["EmailIdReport"]));
                                    message.Subject = EmailSubject;
                                    message.Body = EmailBody.ToString();
                                    message.BodyEncoding = System.Text.Encoding.UTF8;
                                    message.IsBodyHtml = true;
                                    message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

                                    client.Send(message);
                                    // Clean up.
                                    message.Dispose();
                                    IsSend = "1";

                                }
                                catch (Exception ex)
                                {
                                    IsSend = "-1";
                                    ClassLog cl = new ClassLog();
                                    cl.errLog(ex);
                                }
                                finally
                                {
                                    SaveEmailData(Tnx, LedgertransactionId, Util.GetString(dt.Rows[0]["LedgertransactionNo"]), 1, UserInfo.ID, IsSend, "Patient Receipt", Util.GetString(dt.Rows[0]["EmailIdReport"]), "Client", EmailSubject, EmailBody.ToString(), 1);

                                }
                            }
                        }
                    }

                    Tnx.Commit();
                }
                catch
                {
                    Tnx.Rollback();
                }
                finally {
                    con.Close();
                }
            }
        }

    }
 private void SaveEmailData(MySqlTransaction Tnx, int LedgertransactionId, string LedgertransactionNo, int IsAutoMail, int UserId, string IsSend, string Remarks, string EmailId, string MailedTo, string EmailSubject, string EmailBody, int IsAttachment)
 {
     StringBuilder sb = new StringBuilder();
     sb.Append(@"
        INSERT INTO Email_Record_Patient(LedgertransactionId,LedgertransactionNo,IsAutoMail,UserId,IsSend,Remarks,EmailId,MailedTo,EmailSubject,EmailBody,IsAttachment)
        VALUES(@LedgertransactionId,@LedgertransactionNo,@IsAutoMail,@UserId,@IsSend,@Remarks,@EmailId,@MailedTo,@EmailSubject,@EmailBody,@IsAttachment)
        ");

     MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
         new MySqlParameter("@LedgertransactionId", LedgertransactionId),
         new MySqlParameter("@LedgertransactionNo", LedgertransactionNo),
         new MySqlParameter("@IsAutoMail", IsAutoMail),
         new MySqlParameter("@UserId", UserId),
         new MySqlParameter("@IsSend", IsSend),
         new MySqlParameter("@Remarks", Remarks),
         new MySqlParameter("@EmailId", EmailId),
         new MySqlParameter("@MailedTo", MailedTo),
         new MySqlParameter("@EmailSubject", EmailSubject),
         new MySqlParameter("@EmailBody", EmailBody),
         new MySqlParameter("@IsAttachment", IsAttachment));

 }

}
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Linq;

/// <summary>
/// Summary description for MailStatus
/// </summary>
public class MailStatus
{
    public MailStatus()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public string SendMail(object data)
    {
        List<EmailData> datatDetail = new System.Web.Script.Serialization.JavaScriptSerializer().ConvertToType<List<EmailData>>(data);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dtEmailTemp = StockReports.GetDataTable(" SELECT Subject,Template FROM Email_configuration WHERE id=2 ");
            if (datatDetail.Count > 0)
            {
                string test = "";
                var labnodata = datatDetail.AsEnumerable().GroupBy(r => r.LedgertransactionId).Select(group => new
                                {

                                   LedgerTransactionId = group.Key,
                                   otherDetails = group.ToList()
                                }).ToList();
      
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < labnodata.Count; i++)
                {
                  
                   sb = new StringBuilder();
                   test = String.Join(",", datatDetail.AsEnumerable().Where(w => w.LedgertransactionId == labnodata[i].LedgerTransactionId).Select(ss => ss.TestID).ToArray());
                   string EmailTo=Util.GetString(labnodata[i].otherDetails.Where(w => w.LedgertransactionId == labnodata[i].LedgerTransactionId).Select(s => s.EmailId).First());
                   string labto=Util.GetString(labnodata[i].otherDetails.Where(w => w.LedgertransactionId == labnodata[i].LedgerTransactionId).Select(s => s.LedgerTransactionNo).First());
                   DataTable dtPatientDetail = StockReports.GetDataTable(" SELECT PName,Age,Gender FROM f_ledgertransaction WHERE `LedgerTransactionNO`='"+ labto +"' ");                   
                   string EmailSubject = string.Empty;
                   StringBuilder EmailBody = new System.Text.StringBuilder();
                   EmailSubject = Util.GetString(dtEmailTemp.Rows[0]["Subject"]).Replace("{PName}", Util.GetString(dtPatientDetail.Rows[0]["PName"])).Replace("{LabNo}", labto);
                   EmailBody.Append(Util.GetString(dtEmailTemp.Rows[0]["Template"]));
                   EmailBody.Replace("{LabNo}",labto).Replace("{PName}", Util.GetString(dtPatientDetail.Rows[0]["PName"])).Replace("{Age}", Util.GetString(dtPatientDetail.Rows[0]["Age"])).Replace("{Gender}", Util.GetString(dtPatientDetail.Rows[0]["Gender"])).Replace("{PatientID}", "").Replace("{GrossAmount}", "").Replace("{DiscountAmount}","").Replace("{NetAmount}","").Replace("{PaidAmount}", "").Replace("{DOB}", "");
                    try
                    {
                        ReportEmailClass RMail = new ReportEmailClass();
                        string IsSend = RMail.sendEmail(EmailTo, EmailSubject.Trim(), EmailBody.ToString(), "", "", labto, test == "" ? "0" : test, "PDF Report", "1", "PDF Report Email", "Patient");
                    }
                    catch (Exception ex)
                    {
                        ClassLog dl = new ClassLog();
                        dl.errLog(ex);
                        dl.GeneralLog("LabNo:" + labto  + "");
                    }
                   /*  sb.Append("INSERT INTO email_record_patient(LedgerTransactionId,LedgerTransactionNo,Test_ID,EmailId,MailedTo,dtEntry,UserId,IsSend,IsManualBulkMail) ");
                    sb.Append(" VALUES(@LedgerTransactionId,@LedgerTransactionNo,@TestId, @EmailId,'Patient',NOW(),@EntryById,0,1) ");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@LedgerTransactionId", labnodata[i].LedgerTransactionId),
                         new MySqlParameter("@LedgerTransactionNo", labnodata[i].otherDetails.Where(w => w.LedgertransactionId == labnodata[i].LedgerTransactionId).Select(s => s.LedgerTransactionNo).First()),
                         new MySqlParameter("@TestId", test == "" ? "0" : test),
                         new MySqlParameter("@EmailId", Util.GetString(labnodata[i].otherDetails.Where(w => w.LedgertransactionId == labnodata[i].LedgerTransactionId).Select(s => s.EmailId).First())),
                         new MySqlParameter("@EntryById", HttpContext.Current.Session["ID"].ToString())
                        ); */                 
                }
            }
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
           // Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public string SendMailPatientWise(object data)
    {
        List<EmailData> datatDetail = new System.Web.Script.Serialization.JavaScriptSerializer().ConvertToType<List<EmailData>>(data);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (datatDetail.Count > 0)
            {

                for (int i = 0; i < datatDetail.Count; i++)
                {

                    string LedgerTransactionNo = datatDetail[i].LedgerTransactionNo;
                    DataTable dt = StockReports.GetDataTable(" SELECT DISTINCT pm.PName FROM patient_labinvestigation_opd  plo  INNER JOIN `patient_master` pm ON plo.patient_id = pm.patient_id where plo.LedgerTransactionNo='" + LedgerTransactionNo + "'  ");
                    string str = "insert into email_record_bill(LedgerTransactionId,PName,LedgerTransactionNo,ItemID,EmailAddress,dtEntry,UserID,isSent,Type) ";
                    str += " VALUES(@LedgerTransactionId,@PatientName,@LedgerTransactionNo,@TestId, @EmailId,NOW(),@EntryById,0,@Type) ";


                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str.ToString(),
                    new MySqlParameter("@LedgerTransactionId", datatDetail[i].LedgertransactionId),
                    new MySqlParameter("@PatientName", Util.GetString(datatDetail[i].PatientName)),
                    new MySqlParameter("@LedgerTransactionNo", datatDetail[i].LedgerTransactionNo),
                    new MySqlParameter("@TestId", datatDetail[i].TestID == "" ? "0" : datatDetail[i].TestID),
                    new MySqlParameter("@EmailId", Util.GetString(datatDetail[i].EmailId)),
                    new MySqlParameter("@EntryById", HttpContext.Current.Session["ID"].ToString()),
                     new MySqlParameter("@Type", datatDetail[i].logintype)
                     );

                    string str2 = "INSERT INTO  manual_email_log(LedgerTransactionNo,TestID,Status) VALUES(LedgerTransactionNo,@TestId,'Requested')";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str2.ToString(),
                      new MySqlParameter("@LedgerTransactionNo", Util.GetString(LedgerTransactionNo)),
                     new MySqlParameter("@TestId", datatDetail[i].TestID == "" ? "0" : datatDetail[i].TestID)
                     );
                }
            }
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public class EmailData
    {
        public string EmailId { get; set; }
        public string PatientName { get; set; }
        public string Panelid { get; set; }
        public int LedgertransactionId { get; set; }
        public string LedgerTransactionNo { get; set; }
        public string TestID { get; set; }
        public string TestName { get; set; }
        public string PHead { get; set; }
        public string logintype { get; set; }

    }
}
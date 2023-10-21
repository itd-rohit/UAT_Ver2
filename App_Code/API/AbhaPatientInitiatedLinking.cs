using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Net.Http;
using System.Net;
using System.Net.Http.Headers;
using System.Data;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System.Text;
using Newtonsoft.Json.Linq;
using System.IO;
using System.Threading;

/// <summary>
/// Summary description for AbhaPatientInitiatedLinking
/// </summary>
public class AbhaPatientInitiatedLinking
{
    public void OnDiscoverResponce(DicoverResponce DisResponce, int Delay = 0)
    {
        if (Delay > 0)
            Thread.Sleep(Delay);
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();


        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.TokenBaseUrl);
            client.DefaultRequestHeaders.Add("X-CM-ID", ABHABasicData.XCMID);
            try
            {
                string ReqID = Guid.NewGuid().ToString();
                string TimStamp = DateTime.UtcNow.ToString("o");

                string urldat = "" + ABHABasicData.Getway + "v0.5/care-contexts/on-discover";
                string pp = CreateString(DisResponce.requestId, DisResponce.transactionId, DisResponce.patient.id);
                //string payload = System.IO.File.ReadAllText(pp);
                JObject reqObj = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, reqObj).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                if (responseMessage.IsSuccessStatusCode)
                {

                }
                else
                {

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);

            }


        }



    }
    public string CreateString(string RequestAgainestID, string TransactionID, string AbhaID)
    {
        DataTable Dt = new DataTable();

        StringBuilder ab = new StringBuilder();

        ab.Append(" SELECT ar.Name ItemName,ltd.EntryDate,ltd.LedgerTransactionNo ReferenceNumber,lt.PatientID, ");
        ab.Append(" CONCAT(DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y'),'_Checkup')Display FROM abha_registration ar ");
        ab.Append(" INNER JOIN f_ledgertransaction lt ON lt.PatientID=ar.PatientId ");
        ab.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.TransactionID=lt.TransactionID ");
        ab.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=ltd.SubcategoryID ");
        ab.Append(" WHERE  ar.HealthId like concat('%',@AbhaID,'%')   AND ltd.LedgerTransactionNo NOT IN  (SELECT alc.LedgertransactionNo_ReferenceNumber FROM  abha_linkedcarecontext alc WHERE alc.ReferenceNumber=lt.PatientID and alc.IsLinked=1) ");

    //    Dt = StockReports.GetDataTable(ab.ToString());

        ExcuteCMD excuteCMD = new ExcuteCMD();
        Dt = excuteCMD.GetDataTable(ab.ToString(), CommandType.Text, new
        {
            AbhaID = AbhaID, 
        });

        StringBuilder sb = new StringBuilder();
        if (Dt.Rows.Count > 0)
        {
            sb.Append("  { ");
            sb.Append(" \"requestId\": \"" + Guid.NewGuid().ToString() + "\", ");
            sb.Append(" \"timestamp\": \"" + DateTime.UtcNow.ToString("o") + "\", ");
            sb.Append(" \"transactionId\": \"" + TransactionID + "\", ");
            sb.Append("  \"patient\": { ");
            sb.Append("   \"referenceNumber\": \"" + Dt.Rows[0]["PatientID"].ToString() + "\", ");
            sb.Append("   \"display\": \"" + Dt.Rows[0]["ItemName"].ToString() + "\", ");

            // Care cotext
            sb.Append("   \"careContexts\": [ ");
            for (int i = 0; i < Dt.Rows.Count; i++)
            {
                sb.Append(" { ");
                sb.Append(" \"referenceNumber\": \"" + Dt.Rows[i]["ReferenceNumber"].ToString() + "\", ");
                sb.Append("          \"display\": \"" + Dt.Rows[i]["Display"].ToString() + "\" ");
                sb.Append("   }, ");

            }
            sb.Append("   ], ");
            // Care cotext End 
            sb.Append(" \"matchedBy\": [ ");
            sb.Append(" \"MOBILE\" ");
            sb.Append(" ] ");

            sb.Append("  }, ");
            //Responce Againest
            sb.Append("  \"resp\": { ");
            sb.Append("  \"requestId\": \"" + RequestAgainestID + "\" ");
            sb.Append("  } ");
            //Responce Againest End
            sb.Append(" } ");

        }


        return sb.ToString();
    }

    public void OnInItResponce(DicoverResponce DisResponce, int Delay = 0)
    {
        if (Delay > 0)
            Thread.Sleep(Delay);
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();


        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.TokenBaseUrl);
            client.DefaultRequestHeaders.Add("X-CM-ID", ABHABasicData.XCMID);
            try
            {
                string ReqID = Guid.NewGuid().ToString();
                string TimStamp = DateTime.UtcNow.ToString("o");

                string urldat = "" + ABHABasicData.Getway + "v0.5/links/link/on-init";
                string pp = CreateInitString(DisResponce.requestId, DisResponce.transactionId, DisResponce.patient.id);
                //string payload = System.IO.File.ReadAllText(pp);
                JObject reqObj = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, reqObj).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                if (responseMessage.IsSuccessStatusCode)
                {
                    RequestToLink(DisResponce);
                    genrateOtp(DisResponce.requestId, DisResponce.transactionId, DisResponce.patient.id);

                }
                else
                {

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);

            }


        }



    }


    public string CreateInitString(string RequestAgainestID, string TransactionID, string AbhaID)
    {


        StringBuilder sb = new StringBuilder();

        sb.Append("  { ");
        sb.Append(" \"requestId\": \"" + Guid.NewGuid().ToString() + "\", ");
        sb.Append(" \"timestamp\": \"" + DateTime.UtcNow.ToString("o") + "\", ");
        sb.Append(" \"transactionId\": \"" + TransactionID + "\", ");

        sb.Append("  \"link\": { ");
        sb.Append("   \"referenceNumber\": \"" + GetPatientIdByAbhaID(AbhaID) + "\", ");
        sb.Append("   \"authenticationType\": \"DIRECT\", ");

        sb.Append("  \"meta\": { ");
        sb.Append("    \"communicationMedium\": \"MOBILE\",");
        sb.Append(" \"communicationHint\": \"Commnicate By Mobile\", ");
        // sb.Append(" \"communicationExpiry\":\"" + DateTime.UtcNow.AddYears(3).ToString("o") +"\"");
        sb.Append(" \"communicationExpiry\":\"" + DateTime.UtcNow.AddYears(3).ToString("o") + "\"");
        sb.Append(" } ");
        sb.Append("  }, ");
        sb.Append(" \"error\": null, ");
        //Responce Againest 
        sb.Append("  \"resp\": { ");
        sb.Append("  \"requestId\": \"" + RequestAgainestID + "\" ");
        sb.Append("  } ");
        //Responce Againest End
        sb.Append(" } ");


        return sb.ToString();
    }

    public void genrateOtp(string RequestAgainestID, string TransactionID, string AbhaID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string mobile = StockReports.ExecuteScalar("SELECT ar.Mobile FROM abha_registration ar  WHERE  ar.HealthId='" + AbhaID + "'");

            StringBuilder sb = new StringBuilder();

            sb.Append(" insert into abha_genrateotp ");
            sb.Append("(RequestAgainestID,TrasactionID,AbhaID,Mobile,OTP,ValidTo)");
            sb.Append(" values ");
            sb.Append("(@RequestAgainestID,@TrasactionID,@AbhaID,@Mobile,@OTP,@ValidTo)");
            int OTP = Util.GetInt(new Random().Next(100000, 999999).ToString());
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                RequestAgainestID = RequestAgainestID,
                TrasactionID = TransactionID,
                AbhaID = AbhaID,
                Mobile = mobile,
                OTP = OTP,
                ValidTo = Util.GetDateTime(DateTime.UtcNow.AddMinutes(5).ToString()).ToString("yyyy-MM-dd HH:mm:ss")
            });
            tnx.Commit();
            string Message = "   The One Time Password (OTP) for Kongunad Mobile App " + OTP + ". Please enter the OTP in Mobile App to login and continue using. - Kongunad Hospitals Private Limited";
            SendMessage(mobile, Message);
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }




    }


    public void RequestToLink(DicoverResponce ReqToLink)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            foreach (var item in ReqToLink.patient.careContexts)
            {


                StringBuilder sb = new StringBuilder();

                sb.Append(" insert into abha_patientrequesttolink ");
                sb.Append("(AbhaId,PatientID,AbhaTransactionID,AbhaRequestID,LedgertransactionNo)");
                sb.Append(" values ");
                sb.Append("(@AbhaId,@PatientID,@AbhaTransactionID,@AbhaRequestID,@LedgertransactionNo)");
                excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                {
                    AbhaId = ReqToLink.patient.id,
                    PatientID = ReqToLink.patient.referenceNumber,
                    AbhaTransactionID = ReqToLink.transactionId,
                    AbhaRequestID = ReqToLink.requestId,
                    LedgertransactionNo = item.referenceNumber
                });

            }
            tnx.Commit();

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }




    }

    public bool SendMessage(string mobile, string message)
    {
        try
        {
            string url = "http://app.msgpedia.com/sms-panel/api/http/index.php?username=kongunad&apikey=F1C6E-E0C88&apirequest=Text&sender=KONGUH&route=TRANS&mobile=" + mobile + "&message=" + message + "&TemplateID=1607100000000094269";

            WebRequest request = HttpWebRequest.Create(url);

            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            Stream s = (Stream)response.GetResponseStream();
            StreamReader readStream = new StreamReader(s);
            string dataString = readStream.ReadToEnd();
            response.Close();
            s.Close();
            readStream.Close();
            return true;
        }
        catch
        {
            return false;
        }
    }


    public void OnConfirmResponce(DicoverResponce DisResponce, int Delay = 0)
    {
        if (Delay > 0)
        {
            Thread.Sleep(Delay);

        }
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();


        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.TokenBaseUrl);
            client.DefaultRequestHeaders.Add("X-CM-ID", ABHABasicData.XCMID);
            try
            {
                string ReqID = Guid.NewGuid().ToString();
                string TimStamp = DateTime.UtcNow.ToString("o");

                string urldat = "" + ABHABasicData.Getway + "v0.5/links/link/on-confirm";
                string pp = "";
                if (ValidateOTP(DisResponce.confirmation.linkRefNumber, DisResponce.confirmation.token))
                {
                    pp = CreateOnConfirmationString(DisResponce.requestId, DisResponce.transactionId, GetAbhaIDByPatientID(DisResponce.confirmation.linkRefNumber), true, DisResponce.confirmation.linkRefNumber);
                }
                else
                {
                    pp = CreateOnConfirmationString(DisResponce.requestId, DisResponce.transactionId, GetAbhaIDByPatientID(DisResponce.confirmation.linkRefNumber), false, DisResponce.confirmation.linkRefNumber);
                }
                //string payload = System.IO.File.ReadAllText(pp);
                JObject reqObj = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, reqObj).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                if (responseMessage.IsSuccessStatusCode)
                {
                    ConfirmSaveRes FetchDat = JsonConvert.DeserializeObject<ConfirmSaveRes>(pp);
                    SaveLinkedData(FetchDat, 1, 0);

                }
                else
                {

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);

            }


        }



    }


    public string GetAbhaIDByPatientID(string PatientId)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string HealthId = excuteCMD.ExecuteScalar("SELECT ar.HealthId FROM abha_registration ar  WHERE  ar.PatientId=@PatientId ", new
        {
            PatientId = PatientId
        });

        return HealthId;

    }

    public string GetPatientIdByAbhaID(string AbhaID)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD(); 
        string HealthId = excuteCMD.ExecuteScalar("SELECT ar.PatientId FROM abha_registration ar  WHERE  ar.HealthId like concat('%',@PatientId,'%') limit 1", new
        {
            PatientId = AbhaID
        });

        return HealthId;

    }

    public bool ValidateOTP(string PatientId, string OTP)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT IF(COUNT(*)>0,'true','false') FROM abha_genrateotp ago ");
        sb.Append(" INNER JOIN abha_registration ar ON ar.HealthId=ago.AbhaID AND ar.Mobile=ago.Mobile ");
        sb.Append(" WHERE ar.PatientId='" + PatientId + "' AND ago.otp='" + OTP + "' AND ago.EntryDate>= DATE_ADD(NOW(),INTERVAL -5 MINUTE) ");
      //  bool A = Util.GetBoolean(StockReports.ExecuteScalar(sb.ToString()));

        ExcuteCMD excuteCMD = new ExcuteCMD();
        bool A = Util.GetBoolean(excuteCMD.ExecuteScalar(sb.ToString(), new
        {
            PatientId = PatientId,
            OTP = OTP
        }));
        return A;
    }

    public string CreateOnConfirmationString(string RequestAgainestID, string TransactionID, string AbhaID, bool AuthValdation, string PatientID)
    {
        DataTable Dt = new DataTable();

        StringBuilder ab = new StringBuilder();
        StringBuilder sb = new StringBuilder();
        if (AuthValdation)
        {

            ab.Append(" SELECT ar.Name ItemName,ltd.EntryDate,ltd.LedgerTransactionNo ReferenceNumber,lt.PatientID, ");
            ab.Append(" CONCAT(DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y'),'_Checkup')Display FROM abha_registration ar ");
            ab.Append(" INNER JOIN f_ledgertransaction lt ON lt.PatientID=ar.PatientId ");
            ab.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.TransactionID=lt.TransactionID ");
            ab.Append(" INNER JOIN abha_patientrequesttolink apl on apl.LedgertransactionNo=ltd.LedgerTransactionNo And apl.PatientID=lt.PatientID");

            ab.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=ltd.SubcategoryID ");
            ab.Append(" WHERE  ar.HealthId='" + AbhaID + "' AND ltd.LedgerTransactionNo NOT IN  (SELECT alc.LedgertransactionNo_ReferenceNumber FROM  abha_linkedcarecontext alc WHERE alc.ReferenceNumber=lt.PatientID and alc.IsLinked=1) ");
            ab.Append(" group by ltd.LedgerTransactionNo ");
            Dt = StockReports.GetDataTable(ab.ToString());

            if (Dt.Rows.Count > 0)
            {
                sb.Append("  { ");
                sb.Append(" \"requestId\": \"" + Guid.NewGuid().ToString() + "\", ");
                sb.Append(" \"timestamp\": \"" + DateTime.UtcNow.ToString("o") + "\", ");
                sb.Append(" \"transactionId\": \"" + TransactionID + "\", ");
                sb.Append("  \"patient\": { ");
                sb.Append("   \"referenceNumber\": \"" + Dt.Rows[0]["PatientID"].ToString() + "\", ");
                sb.Append("   \"display\": \"" + Dt.Rows[0]["ItemName"].ToString() + "\", ");

                // Care cotext
                sb.Append("   \"careContexts\": [ ");
                for (int i = 0; i < Dt.Rows.Count; i++)
                {
                    sb.Append(" { ");
                    sb.Append(" \"referenceNumber\": \"" + Dt.Rows[i]["ReferenceNumber"].ToString() + "\", ");
                    sb.Append("          \"display\": \"" + Dt.Rows[i]["Display"].ToString() + "\" ");
                    sb.Append("   }, ");

                }
                sb.Append("   ], ");
                // Care cotext End  
                sb.Append("  }, ");

                sb.Append(" \"error\": null, ");
                //Responce Againest
                sb.Append("  \"resp\": { ");
                sb.Append("  \"requestId\": \"" + RequestAgainestID + "\" ");
                sb.Append("  } ");
                //Responce Againest End
                sb.Append(" } ");

            }
            else
            {
                sb.Append("  { ");
                sb.Append(" \"requestId\": \"" + Guid.NewGuid().ToString() + "\", ");
                sb.Append(" \"timestamp\": \"" + DateTime.UtcNow.ToString("o") + "\", ");
                sb.Append(" \"transactionId\": \"" + TransactionID + "\", ");
                sb.Append("  \"patient\": { ");
                sb.Append("   \"referenceNumber\": \"" + PatientID + "\", ");
                sb.Append("   \"display\": \"\", ");

                // Care cotext
                sb.Append("   \"careContexts\":null");

                // Care cotext End 


                sb.Append("  }, ");

                sb.Append("  \"error\": { ");
                sb.Append("  \"code\": \"1400\", ");
                sb.Append("  \"message\": \"Unable to add record.\" ");
                sb.Append("  }, ");
                //Responce Againest
                sb.Append("  \"resp\": { ");
                sb.Append("  \"requestId\": \"" + RequestAgainestID + "\" ");
                sb.Append("  } ");
                //Responce Againest End
                sb.Append(" } ");

            }

        }
        else
        {
            sb.Append("  { ");
            sb.Append(" \"requestId\": \"" + Guid.NewGuid().ToString() + "\", ");
            sb.Append(" \"timestamp\": \"" + DateTime.UtcNow.ToString("o") + "\", ");
            sb.Append(" \"transactionId\": \"" + TransactionID + "\", ");
            sb.Append("  \"patient\": { ");
            sb.Append("   \"referenceNumber\": \"" + PatientID + "\", ");
            sb.Append("   \"display\": \"\", ");

            // Care cotext
            sb.Append("   \"careContexts\":null");

            // Care cotext End 


            sb.Append("  }, ");

            sb.Append("  \"error\": { ");
            sb.Append("  \"code\": \"1401\", ");
            sb.Append("  \"message\": \"OTP verification failed.\" ");
            sb.Append("  }, ");
            //Responce Againest
            sb.Append("  \"resp\": { ");
            sb.Append("  \"requestId\": \"" + RequestAgainestID + "\" ");
            sb.Append("  } ");
            //Responce Againest End
            sb.Append(" } ");


        }

        return sb.ToString();
    }


    public void SaveLinkedData(ConfirmSaveRes PatData, int IsLinked, int IsHIPinitiated = 0)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {


            foreach (var item in PatData.patient.careContexts)
            {
                StringBuilder sb = new StringBuilder();

                sb.Append(" insert into abha_linkedcarecontext ");
                sb.Append("( RequestId,Timestamp,ReferenceNumber, ");
                sb.Append("Display,LedgertransactionNo_ReferenceNumber, ");
                sb.Append("  DisplayCareContext,RequestId_ResponceAgainest, ");
                sb.Append("  EntryDate,IsLinked,LinkThroughHIPInitiated) ");
                sb.Append(" values ");
                sb.Append("( @RequestId,@Timestamp,@ReferenceNumber, ");
                sb.Append(" @Display,@LedgertransactionNo_ReferenceNumber, ");
                sb.Append("  @DisplayCareContext,@RequestId_ResponceAgainest, ");
                sb.Append("  Now(),@IsLinked,@LinkThroughHIPInitiated) ");
                excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                {
                    RequestId = PatData.requestId,
                    Timestamp = Util.GetDateTime(PatData.timestamp).ToString("yyyy-MM-dd HH:mm:ss"),
                    ReferenceNumber = PatData.patient.referenceNumber,
                    Display = PatData.patient.display,
                    LedgertransactionNo_ReferenceNumber = item.referenceNumber,
                    DisplayCareContext = item.display,
                    RequestId_ResponceAgainest = PatData.resp.requestId,
                    IsLinked = IsLinked,
                    LinkThroughHIPInitiated = IsHIPinitiated
                });

            }

            tnx.Commit();

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    public void OnShareProfleResponce(ABHAProfileShareRes Responce, string XHIPID, int Delay = 0)
    {

        if (Delay > 0)
            Thread.Sleep(Delay);


        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();
        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.TokenBaseUrl);
            client.DefaultRequestHeaders.Add("X-CM-ID", ABHABasicData.XCMID);
            try
            {
                string ReqID = Guid.NewGuid().ToString();
                string TimStamp = DateTime.UtcNow.ToString("o");

                string urldat = "" + ABHABasicData.Getway + "v1.0/patients/profile/on-share";
                string pp = CreateOnProfielShareString(Responce, XHIPID);
                //string payload = System.IO.File.ReadAllText(pp);
                JObject reqObj = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, reqObj).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                if (responseMessage.IsSuccessStatusCode)
                {
                    RequestToActivateShareProfile(Responce, 1);
                }
                else
                {
                    RequestToActivateShareProfile(Responce, 0);
                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                RequestToActivateShareProfile(Responce, 0);
            }


        }



    }


    public string CreateOnProfielShareString(ABHAProfileShareRes Res, string XHIPID)
    {

        string TokenNo = RequestToSaveShareProfile(Res, XHIPID);


        StringBuilder sb = new StringBuilder();

        sb.Append("  { ");
        sb.Append(" \"requestId\": \"" + Guid.NewGuid().ToString() + "\", ");
        sb.Append(" \"timestamp\": \"" + DateTime.UtcNow.ToString("o") + "\", ");

        sb.Append("  \"acknowledgement\": { ");
        sb.Append("   \"status\": \"SUCCESS\", ");
        sb.Append("   \"healthId\": \"" + Res.profile.patient.healthId + "\", ");
        sb.Append("   \"tokenNumber\": \"" + TokenNo + "\", ");

        sb.Append("  }, ");

        // sb.Append(" \"error\": null, ");
        //Responce Againest 
        sb.Append("  \"resp\": { ");
        sb.Append("  \"requestId\": \"" + Res.requestId + "\" ");
        sb.Append("  } ");
        //Responce Againest End
        sb.Append(" } ");

        return sb.ToString();
    }


    public string RequestToSaveShareProfile(ABHAProfileShareRes Res, string XHIPID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            string DOB = Res.profile.patient.dayOfBirth + "-" + Res.profile.patient.monthOfBirth + "-" + Res.profile.patient.yearOfBirth;
            string stringIdentifire = string.Join("#", Res.profile.patient.identifiers.Select(x => x.type + "_" + x.value).ToArray());

            StringBuilder sb = new StringBuilder();

            sb.Append(" insert into abha_profileshare ");
            sb.Append("(Name,HIPID,RequestId,Timestamp,IntentType,HipCode,HealthId,HealthIdNumber,Gender,Line,District,State,PinCode,DOB,Identifire,EntryDate,IsConfirm,IsActive)");
            sb.Append(" values ");
            sb.Append("(@Name,@HIPID,@RequestId,@Timestamp,@IntentType,@HipCode,@HealthId,@HealthIdNumber,@Gender,@Line,@District,@State,@PinCode,@DOB,@Identifire,NOW(),@IsConfirm,@IsActive)");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                RequestId = Res.requestId,
                Timestamp = Util.GetDateTime(Res.timestamp).ToString("yyyy-MM-dd hh:mm:ss"),
                IntentType = Res.intent.type,
                HipCode = Res.profile.hipCode,
                HealthId = Res.profile.patient.healthId,
                HealthIdNumber = Res.profile.patient.healthIdNumber,
                Gender = Res.profile.patient.gender,
                Line = Res.profile.patient.address.line,
                District = Res.profile.patient.address.district,
                State = Res.profile.patient.address.state,
                PinCode = Res.profile.patient.address.pincode,
                DOB = Util.GetDateTime(DOB).ToString("yyyy-MM-dd"),
                Identifire = stringIdentifire,
                IsConfirm = 0,
                IsActive = 0,
                Name = Res.profile.patient.name,
                HIPID = XHIPID,
            });

            tnx.Commit();
            string query = "SELECT IFNULL(MAX(Id),0)AS Id FROM abha_profileshare";
            string ID = Util.GetString(StockReports.ExecuteScalar(query));

            return ID;

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }




    }

    public void RequestToActivateShareProfile(ABHAProfileShareRes Res, int Status)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            string DOB = Res.profile.patient.dayOfBirth + "-" + Res.profile.patient.monthOfBirth + "-" + Res.profile.patient.yearOfBirth;
            string stringIdentifire = string.Join("#", Res.profile.patient.identifiers.Select(x => x.type + "_" + x.value).ToArray());

            StringBuilder sb = new StringBuilder();

            sb.Append(" Update abha_profileshare set IsActive=1,IsConfirm=0 where RequestId=@RequestId ");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                RequestId = Res.requestId,
                IsConfirm = 0,
                IsActive = Status
            });
            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }




    }


    public void UpdateSendSmsStatus(SMSNotifyResponce Res, int Status)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            StringBuilder sb = new StringBuilder();
            string ErrorMessage = "";

            if (Res.error != null)
            {
                ErrorMessage = Res.error.message;

            }

            sb.Append(" Update abha_sendmobilesms set IsSend=@IsSend,Status=@Status where RequestId=@RequestId ");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                RequestId = Res.resp.requestId,
                Status = Res.status,
                IsSend = Status,
                ErrorMessage = ErrorMessage
            });
            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }




    }

}
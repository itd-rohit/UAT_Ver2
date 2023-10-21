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

public class AbhaHIUAutoResponce
{

    public void UpdateOnRequest(AbhaHIUOnInintResModel PatData,int Delay=0)
    {
        if (Delay > 0)
            Thread.Sleep(Delay);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            int IsOnAuthResponce = 0;

            string Code = "";
            string Message = "";

            if (PatData.error != null)
            {
                Code = PatData.error.code;
                Message = PatData.error.message;
                IsOnAuthResponce = 2;
            }
            else
            {
                IsOnAuthResponce = 1;
            }

            StringBuilder sb = new StringBuilder();

            sb.Append(" UPDATE abha_consentInit af  ");
            sb.Append(" SET ConsentId=@ConsentId,ConRequestId=@ConRequestId,ErrorCode=@Code,ErrorMesasge=@Message,IsOnInitRes=@IsOnInitRes ");
            sb.Append(" WHERE af.RequestId=@RequestId ");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                IsOnInitRes = IsOnAuthResponce,
                ConsentId = PatData.consentRequest.id,
                ConRequestId = PatData.requestId,
                Code = Code,
                Message = Message,
                RequestId = PatData.resp.requestId
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

    public void OnNotifyCall(AbhaHIUNotifyResModel AbhaNot,int Delay=0)
    {
        if (Delay > 0)
            Thread.Sleep(Delay);

        SaveOnNotify(AbhaNot);
        foreach (RequestReshiRequestconsent item in AbhaNot.notification.consentArtefacts)
        {
            ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();

            using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
            {
                ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

                client.BaseAddress = new Uri(ABHABasicData.TokenBaseUrl);
                client.DefaultRequestHeaders.Add("X-CM-ID", ABHABasicData.XCMID);
                try
                {
                    string urldat = ""+ABHABasicData.Getway+"v0.5/consents/hiu/on-notify";
                    string pp = CreateString(item.id, AbhaNot.requestId);
                    //string payload = System.IO.File.ReadAllText(pp);
                    JObject reqObj = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                    System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, reqObj).GetAwaiter().GetResult();
                    string status_code = responseMessage.StatusCode.ToString();

                    string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                    object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
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



    }

    public string CreateString(string consentRequestId, string requestId)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append("  { ");
        sb.Append(" \"requestId\": \"" + Guid.NewGuid().ToString() + "\", ");
        sb.Append(" \"timestamp\": \"" + DateTime.UtcNow.ToString("o") + "\", ");

        sb.Append("  \"acknowledgement\": { ");
        sb.Append("   \"status\": \"OK\", ");
        sb.Append("   \"consentId\": \"" + consentRequestId + "\", ");
        sb.Append("  }, ");
        //Responce Againest
        sb.Append("  \"resp\": { ");
        sb.Append("  \"requestId\": \"" + requestId + "\" ");
        sb.Append("  } ");
        //Responce Againest End
        sb.Append(" } ");


        return sb.ToString();
    }

    public void SaveOnNotify(AbhaHIUNotifyResModel PatData)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            int IsOnAuthResponce = 0;

            string Code = "";
            string Message = "";

            if (PatData.error != null)
            {
                Code = PatData.error.code;
                Message = PatData.error.message;
                IsOnAuthResponce = 2;
            }
            else
            {
                IsOnAuthResponce = 1;
            }

            StringBuilder sb = new StringBuilder();

            sb.Append(" UPDATE abha_consentinit af  ");
            sb.Append(" SET ConGrantedReqID=@ConGrantedReqID,ConGrantedDate=@ConGrantedDate,Status=@Status ");
            sb.Append(" WHERE af.ConsentId=@ConsentId ");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                ConsentId = PatData.notification.consentRequestId,
                ConGrantedReqID = PatData.requestId,
                ConGrantedDate = Util.GetDateTime(PatData.timestamp).ToString("yyyy-MM-dd HH:mm:ss"),
                Status = PatData.notification.status
            });

             
            if ( PatData.notification.consentArtefacts!=null)
            {
                foreach (RequestReshiRequestconsent item in PatData.notification.consentArtefacts)
                {
                    sb = new StringBuilder();

                    if (PatData.notification.status == "GRANTED")
                    {
                        sb.Append("insert into abha_consentinit_notify");
                        sb.Append("(ConsentID,NotifyId,NotifyDateTime,Status,ConArtifectID,EntryDate)");
                        sb.Append("values");
                        sb.Append("(@ConsentID,@NotifyId,@NotifyDateTime,@Status,@ConArtifectID,Now())");

                        excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                        {
                            ConsentID = PatData.notification.consentRequestId,
                            NotifyId = PatData.requestId,
                            NotifyDateTime = Util.GetDateTime(PatData.timestamp).ToString("yyyy-MM-dd HH:mm:ss"),
                            Status = PatData.notification.status,
                            ConArtifectID = item.id,
                        });

                    }
                    else
                    {
                        sb.Append("UPDATE abha_consentinit_notify ");
                        sb.Append(" set Status=@Status where ConArtifectID=@ConsentID");
                        excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                        {
                            ConsentID =item.id,
                            Status = PatData.notification.status,
                        });
                    }

                } 
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


    public bool SaveConsentRequest(string ReqID, string TimeStamp, string PurposeText, string PurposeVal, string HealthID, string HIUFacilityId, string RequesterName, string ReqType, string ReqValue, string ReqSystem, string AccessMode, string HiType, string FromDate, string ToDate, string ConsentExpiry, string PatientName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            StringBuilder sb = new StringBuilder();

            sb.Append(" insert into abha_consentInit ");
            sb.Append(" (RequestId,RequestedDate,PurposeText,PurposeCode,");
            sb.Append(" PatientID,PatientName,HiuId,ReqName,ReqIdeType,");
            sb.Append(" ReqIdeValue,ReqIdeSystem,HiTypes,PerAccessMode,");
            sb.Append(" PerFromDate,PerToDate,PermissionDataEraseAt,");
            sb.Append(" FreUnit,FreValue,FreRepeats,IsActive,EntryDate,Status )");

            sb.Append(" values ");
            sb.Append(" (@RequestId,@RequestedDate,@PurposeText,@PurposeCode,");
            sb.Append(" @PatientID,@PatientName,@HiuId,@ReqName,@ReqIdeType,");
            sb.Append(" @ReqIdeValue,@ReqIdeSystem,@HiTypes,@PerAccessMode,");
            sb.Append(" @PerFromDate,@PerToDate,@PermissionDataEraseAt,");
            sb.Append(" @FreUnit,@FreValue,@FreRepeats,@IsActive,now(),@Status )");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                RequestId = ReqID,
                RequestedDate = Util.GetDateTime(TimeStamp).ToString("yyyy-MM-dd HH:mm:ss"),
                PurposeText = PurposeText,
                PurposeCode = PurposeVal,
                PatientID = HealthID,
                PatientName = PatientName,
                HiuId = HIUFacilityId,
                ReqName = RequesterName,
                ReqIdeType = ReqType,
                ReqIdeValue = ReqValue,
                ReqIdeSystem = ReqSystem,
                HiTypes = HiType,
                PerAccessMode = AccessMode,
                PerFromDate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd HH:mm:ss"),
                PerToDate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd HH:mm:ss"),
                PermissionDataEraseAt = Util.GetDateTime(ConsentExpiry).ToString("yyyy-MM-dd HH:mm:ss"),
                FreUnit = "HOUR",
                FreValue = "1",
                FreRepeats = 0,
                IsActive = 1,
                Status="Requested",

            });



            tnx.Commit();
            return true;

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    public string CreateRequestString(string ReqID, string TimeStamp, string PurposeText, string PurposeVal, string HealthID, string HIUFacilityId, string RequesterName, string ReqType, string ReqValue, string ReqSystem, string AccessMode, string HiType, string FromDate, string ToDate, string ConsentExpiry, string PatientName)
    {

        string[] HiArrayType = HiType.Split(',');
        StringBuilder sb = new StringBuilder();

        sb.Append("  { ");
        sb.Append(" \"requestId\": \"" + ReqID + "\", ");
        sb.Append(" \"timestamp\": \"" + TimeStamp + "\", ");

        sb.Append("  \"consent\": { ");
        sb.Append("     \"purpose\": { ");
        sb.Append("       \"text\": \"" + PurposeText + "\", ");
        sb.Append("      \"code\": \"" + PurposeVal + "\" ");
        sb.Append("   }, ");
        sb.Append(" \"patient\": { ");
        sb.Append("       \"id\": \"" + HealthID + "\" ");
        sb.Append("    }, ");
        sb.Append("    \"hiu\": { ");
        sb.Append("       \"id\": \"" + HIUFacilityId + "\" ");
        sb.Append("    }, ");
        sb.Append("   \"requester\": { ");
        sb.Append("     \"name\": \"" + RequesterName + "\", ");
        sb.Append(" \"identifier\": { ");
        sb.Append("       \"type\": \"" + ReqType + "\", ");
        sb.Append(" \"value\": \"" + ReqValue + "\", ");
        sb.Append(" \"system\": \"" + ReqSystem + "\" ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append(" \"hiTypes\": [ ");
        foreach (string item in HiArrayType)
        {
            sb.Append(" \"" + item + "\", ");

        }

        sb.Append(" ], ");
        sb.Append(" \"permission\": { ");
        sb.Append(" \"accessMode\": \"" + AccessMode + "\", ");
        sb.Append(" \"dateRange\": { ");
        sb.Append(" \"from\": \"" + Util.GetDateTime(FromDate).ToString("o") + "\", ");
        sb.Append(" \"to\": \"" + Util.GetDateTime(ToDate).ToString("o") + "\" ");
        sb.Append(" }, ");
        sb.Append(" \"dataEraseAt\": \"" + Util.GetDateTime(ConsentExpiry).ToString("o") + "\", ");
        sb.Append(" \"frequency\": { ");
        sb.Append(" \"unit\": \"HOUR\", ");
        sb.Append(" \"value\": 1, ");
        sb.Append(" \"repeats\": 0 ");
        sb.Append(" } ");
        sb.Append(" } ");
        sb.Append(" } ");
        sb.Append(" } ");
        return sb.ToString();
    }



    public string CreateDatarequestFromHIPString(string FromDate, string ToDate, string ConsentID)
    {
        AbhaEncryptionDecrypton ED = new AbhaEncryptionDecrypton();
        var senderKeyPair = ED.GenerateKey();

        var senderPublicKey = ED.GetPublicKeyNew(senderKeyPair);
        var senderPrivateKey = ED.GetPrivateKeyNew(senderKeyPair);

        var randomKeySender = ED.GenerateRandomKey(); 
        string Curve = ABHABasicData.CURVE;
        string ALGORITHM = ABHABasicData.ALGORITHM; 

        StringBuilder sb = new StringBuilder();
        string ReqID = Guid.NewGuid().ToString();
        string TimeStamp = DateTime.UtcNow.ToString("o");
        string Expiry = DateTime.UtcNow.AddDays(1).ToString("o");
        string Parameters = ABHABasicData.CURVE + "/" + ED.GenerateRandomKey();

        sb.Append("  {");
        sb.Append(" \"requestId\": \"" + ReqID + "\", ");
        sb.Append(" \"timestamp\": \"" + TimeStamp + "\", ");

        sb.Append("  \"hiRequest\": { ");
        sb.Append("      \"consent\": { ");
        sb.Append("        \"id\": \"" + ConsentID + "\" ");
        sb.Append("    }, ");
        sb.Append("    \"dateRange\": { ");
        sb.Append("       \"from\": \"" + Util.GetDateTime(FromDate).ToString("o") + "\", ");
        sb.Append("      \"to\": \"" + Util.GetDateTime(ToDate).ToString("o") + "\" ");
        sb.Append("   }, ");
        sb.Append("   \"dataPushUrl\": \"" + ABHABasicData.DataPushURL + "\", ");
        sb.Append("   \"keyMaterial\": { ");
        sb.Append("      \"cryptoAlg\": \"" + ABHABasicData.ALGORITHM + "\", ");
        sb.Append("     \"curve\": \"" + ABHABasicData.CURVE + "\", ");
        sb.Append("    \"dhPublicKey\": { ");
        sb.Append("       \"expiry\": \"" + Expiry + "\", ");
        sb.Append("      \"parameters\": \"" + Parameters + "\", ");
        sb.Append("     \"keyValue\": \"" + senderPublicKey + "\" ");
        sb.Append("  }, ");
        sb.Append("  \"nonce\": \"" + randomKeySender + "\" ");
        sb.Append("   } ");
        sb.Append(" } ");
        sb.Append(" } ");
        SaveDataRequest(ReqID, TimeStamp, ConsentID, FromDate, ToDate, ABHABasicData.DataPushURL, ABHABasicData.ALGORITHM, ABHABasicData.CURVE, Expiry, Parameters, senderPublicKey, senderPrivateKey, randomKeySender);
        return sb.ToString();
    }


    public bool SaveDataRequest(string RequestId, string Timestamp, string ConsentId, string FromDate, string ToDate, string DataPushUrl, string CryptoAlg, string Curve, string KeyExpiry, string Parameters, string PublicKey, string PrivateKey, string Nonce)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            StringBuilder sb = new StringBuilder();

            sb.Append(" insert into abha_datarequesttohip ");
            sb.Append(" (RequestId,Timestamp,ConsentId,FromDate,ToDate, ");
            sb.Append("DataPushUrl,CryptoAlg,Curve, ");
            sb.Append("KeyExpiry,Parameters,PublicKey, ");
            sb.Append("PrivateKey,Nonce, IsActive )");

            sb.Append(" values ");
            sb.Append(" (@RequestId,@Timestamp,@ConsentId,@FromDate,@ToDate, ");
            sb.Append(" @DataPushUrl, @CryptoAlg,@Curve, ");
            sb.Append(" @KeyExpiry, @Parameters,@PublicKey, ");
            sb.Append(" @PrivateKey,@Nonce, @IsActive )");

            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                RequestId = RequestId,
                Timestamp = Util.GetDateTime(Timestamp).ToString("yyyy-MM-dd HH:mm:ss"),
                ConsentId = ConsentId,
                FromDate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd HH:mm:ss"),
                ToDate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd HH:mm:ss"),
                DataPushUrl = DataPushUrl,
                CryptoAlg = CryptoAlg,
                Curve = Curve,
                KeyExpiry = Util.GetDateTime(KeyExpiry).ToString("yyyy-MM-dd HH:mm:ss"),
                Parameters = Parameters,
                PublicKey = PublicKey,
                PrivateKey = PrivateKey,
                Nonce = Nonce,
                IsActive = 1

            });



            tnx.Commit();
            return true;

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    public void UpdateAbhaOnRequest(AbhaOnRequestResponceHIU PatData)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            int IsOnAuthResponce = 0;

            string Code = "";
            string Message = "";

            if (PatData.error != null)
            {
                Code = PatData.error.code;
                Message = PatData.error.message;
                IsOnAuthResponce = 2;
            }
            else
            {
                IsOnAuthResponce = 1;
            }

            StringBuilder sb = new StringBuilder();

            sb.Append(" UPDATE abha_datarequesttohip af  ");
            sb.Append(" SET TransactionId=@TransactionId,OnRequest=@OnRequest,ErrorCode=@Code,ErrorMessage=@Message ");
            sb.Append(" WHERE af.RequestId=@RequestId ");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {

                TransactionId = PatData.hiRequest.transactionId,
                OnRequest = IsOnAuthResponce,
                Code = Code,
                Message = Message,
                RequestId = PatData.resp.requestId
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



    public bool SavePullData(AbhaDataRes PulledData,int Delay=0)
    {
        if (Delay>0)
        {
            Thread.Sleep(Delay);            
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            DataTable dt = new DataTable();
            StringBuilder ab = new StringBuilder();
            ab.Append("SELECT * FROM abha_datarequesttohip hip WHERE hip.TransactionId=@transactionId");
            // dt = StockReports.GetDataTable(ab.ToString()); 
            dt = excuteCMD.GetDataTable(ab.ToString(), CommandType.Text, new
            {
                transactionId = PulledData.transactionId
            });
            foreach (AbhaDataResEntries item in PulledData.entries)
            {

                AbhaEncryptionDecrypton ED = new AbhaEncryptionDecrypton();

                var SenderPublicKey = PulledData.keyMaterial.dhPublicKey.keyValue;
                var SendorNonce = PulledData.keyMaterial.nonce;


                var ReciverPrivateKey = dt.Rows[0]["PrivateKey"].ToString(); 
                // Generating random key 
                var ReciverNonce = dt.Rows[0]["Nonce"].ToString();
                var xorOfRandoms = ED.XorOfRandom(ReciverNonce, SendorNonce).ToArray();



               string DecryptedData = ED.DecryptString(item.content, xorOfRandoms, ReciverPrivateKey, SenderPublicKey);
                 

                StringBuilder sb = new StringBuilder();

                sb.Append(" insert into abha_datarequestresfromhip ");
                sb.Append(" (TransactionId,PageNumber,PageCount, ");
                sb.Append("ContentEncrypted,ContentDecrypted,Media, ");
                sb.Append("Checksum,CareContextReference,Algo, ");
                sb.Append("Curve,Expiry,Parameters,SenderPublicKey,Nonce )");

                sb.Append(" values ");
                sb.Append(" (@TransactionId,@PageNumber,@PageCount, ");
                sb.Append("@ContentEncrypted,@ContentDecrypted,@Media, ");
                sb.Append("@Checksum,@CareContextReference,@Algo, ");
                sb.Append("@Curve,@Expiry,@Parameter,@SenderPublicKey,@Nonce )");

                excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                {
                    TransactionId = PulledData.transactionId,
                    PageNumber = PulledData.pageNumber,
                    PageCount = PulledData.pageCount,
                    ContentEncrypted = item.content,
                    ContentDecrypted = DecryptedData,
                    Media = item.media,
                    Checksum = item.checksum,
                    CareContextReference = item.careContextReference,
                    Algo = PulledData.keyMaterial.cryptoAlg,
                    Curve = PulledData.keyMaterial.curve,
                    Expiry = Util.GetDateTime(PulledData.keyMaterial.dhPublicKey.expiry).ToString("yyy-MM-dd"),
                    Parameter = PulledData.keyMaterial.dhPublicKey.parameters,
                    SenderPublicKey = PulledData.keyMaterial.dhPublicKey.keyValue,
                    Nonce = PulledData.keyMaterial.nonce
                });
               
            }

            tnx.Commit();

            foreach (AbhaDataResEntries item in PulledData.entries)
            {
                if (ABHABasicData.Delay>0)
                {
                    Thread.Sleep(ABHABasicData.Delay);
                }
                
                NotifyAfterPulledData(PulledData.transactionId, item.careContextReference, dt.Rows[0]["ConsentId"].ToString());
            }
            return true;

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    public void NotifyAfterPulledData(string TransactionID, string CareContextId,string ConArtifectID)
    {

        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();

        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.TokenBaseUrl);
            client.DefaultRequestHeaders.Add("X-CM-ID", ABHABasicData.XCMID);
            try
            {
                string urldat = "" + ABHABasicData.Getway + "v0.5/health-information/notify";
                string pp = CreateNotifyPulledDataString(TransactionID, CareContextId, ConArtifectID);
                //string payload = System.IO.File.ReadAllText(pp);
                JObject reqObj = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, reqObj).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
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



    public string CreateNotifyPulledDataString(string TransactionID, string CareContextId, string ConArtifectID)
    {



        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT ac.HiuId,ac.ConsentId,acn.ConArtifectID,drp.TransactionId FROM abha_consentInit ac ");
        sb.Append(" INNER JOIN abha_consentinit_notify acn ON  acn.ConsentID=ac.ConsentId ");
        sb.Append(" INNER JOIN abha_datarequesttohip drp ON drp.ConsentId=acn.ConArtifectID ");
        sb.Append(" WHERE drp.TransactionId=@TransactionID ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
          {
              TransactionID = TransactionID
          });
        //  DataTable dt = StockReports.GetDataTable(sb.ToString());
        sb = new StringBuilder();

        sb.Append("   { ");
        sb.Append(" \"requestId\": \"" + Guid.NewGuid() + "\", ");
        sb.Append(" \"timestamp\": \"" + DateTime.UtcNow.ToString("o") + "\", ");

        sb.Append(" \"notification\": {  ");
        sb.Append(" \"consentId\": \"" + dt.Rows[0]["ConsentId"].ToString() + "\", ");
        sb.Append(" \"transactionId\": \"" + TransactionID + "\", ");
        sb.Append(" \"doneAt\": \"" + DateTime.UtcNow.ToString("o") + "\", ");
        sb.Append(" \"notifier\": { ");
        sb.Append(" \"type\": \"HIU\", ");
        sb.Append(" \"id\": \"" + dt.Rows[0]["HiuId"].ToString() + "\" ");
        sb.Append(" }, ");
        sb.Append(" \"statusNotification\": { ");
        sb.Append(" \"sessionStatus\": \"TRANSFERRED\", ");
        sb.Append(" \"hipId\": \"" + ConArtifectID + "\", ");
        sb.Append(" \"statusResponses\": [ ");
        sb.Append(" { ");
        sb.Append(" \"careContextReference\": \"" + CareContextId + "\", ");
        sb.Append(" \"hiStatus\": \"OK\", ");
        sb.Append(" \"description\": \"\" ");
        sb.Append(" } ");
        sb.Append(" ] ");
        sb.Append(" } ");
        sb.Append(" } ");
        sb.Append(" } ");

        return sb.ToString();

    }


    public string CreateFetchArtefactString(string consentID, string ReqId, string Timesatmp)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append(" { ");
        sb.Append(" \"requestId\":  \"" + ReqId + "\", ");
        sb.Append(" \"timestamp\": \"" + Timesatmp + "\", ");
        sb.Append(" \"consentId\": \"" + consentID + "\" ");
        sb.Append(" } ");

        return sb.ToString();
    }

    public DateTime GetIndianDateWithSpecificTimeZone(DateTime Date)
    {

        DateTime dateTime_Indian = TimeZoneInfo.ConvertTimeFromUtc(Date, ABHABasicData.India_Standard_Time);
       return dateTime_Indian;
    }
}
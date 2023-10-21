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
using System.Threading.Tasks;

public class DataTransferResponceAsHIP
{
    AbhaHIUAutoResponce ap = new AbhaHIUAutoResponce();
    public void OnNotifyCall(AbhaNotifyModel AbhaNot, int Delay = 0)
    {
        if (Delay > 0)
            Thread.Sleep(Delay);
        if (AbhaNot.notification.status != "REVOKED" && AbhaNot.notification.status != "EXPIRED")
        {
            bool b = SaveNotifyData(AbhaNot);
            // string recivedata = "";
        }
        else
        {
            bool b = UpdateNotifyData(AbhaNot);
        }

        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();

        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.TokenBaseUrl);
            client.DefaultRequestHeaders.Add("X-CM-ID", ABHABasicData.XCMID);
            try
            {
                string urldat = "" + ABHABasicData.Getway + "v0.5/consents/hip/on-notify";
                string pp = CreateString(AbhaNot);
                System.IO.File.WriteAllText(@"E:\OnNotifyString.txt", pp.ToString());

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

    public string CreateString(AbhaNotifyModel AbhaNot)
    {


        DataTable Dt = new DataTable();

        //StringBuilder ab = new StringBuilder();


        //ab.Append(" SELECT ar.Name ItemName,ltd.EntryDate,ltd.LedgerTransactionNo ReferenceNumber,lt.PatientID, ");
        //ab.Append(" CONCAT(DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y'),'_Checkup')Display FROM abha_registration ar ");
        //ab.Append(" INNER JOIN f_ledgertransaction lt ON lt.PatientID=ar.PatientId ");
        //ab.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.TransactionID=lt.TransactionID ");
        //ab.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=ltd.SubcategoryID ");
        //ab.Append(" INNER JOIN abhanotifyrequestcarecontexts abnr ON abnr.CareContextReference=ltd.LedgerTransactionNo and abnr.ConsentID='" + AbhaNot.notification.consentDetail.consentId + "'");
        //ab.Append(" WHERE  ar.HealthId='" + AbhaNot.notification.consentDetail.patient.id + "'");
        //ab.Append("  AND ltd.LedgerTransactionNo NOT IN  (SELECT alc.LedgertransactionNo_ReferenceNumber FROM  ");
        //ab.Append("   abha_linkedcarecontext alc WHERE alc.ReferenceNumber=lt.PatientID and alc.IsLinked=1) ");
        //ab.Append(" and ltd.EntryDate>='" + Util.GetDateTime(AbhaNot.notification.consentDetail.permission.dateRange.from).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
        //ab.Append(" and ltd.EntryDate<='" + Util.GetDateTime(AbhaNot.notification.consentDetail.permission.dateRange.to).ToString("yyyy-MM-dd HH:mm:ss") + "' ");


        ////StringBuilder ab = new StringBuilder();
        ////ab.Append("SELECT pm.PatientID,pm.PName,pm.Age,pm.DOB,pm.Gender,an.HipId,an.PatientId HealthID,(SELECT aa.Name FROM abha_registerdfacility aa WHERE aa.UserName=an.HipId ORDER BY ID DESC LIMIT 1 )HipName,(SELECT GROUP_CONCAT(DISTINCT aa.Alias) FROM abha_registerdfacility aa WHERE aa.UserName=an.HipId ORDER BY ID) HIPAlias  FROM abha_hiurequest  ah ");
        ////ab.Append("INNER JOIN abhanotifydata an ON an.ConsentId=ah.ConsentID  ");
        ////ab.Append("INNER JOIN abha_registration ar ON ar.HealthId=an.PatientId ");
        ////ab.Append("INNER JOIN patient_master pm ON pm.PatientID=ar.PatientId ");
        ////ab.Append("WHERE ah.ConsentID='" + AbhaNot.notification.consentDetail.consentId + "' limit 1 ");
        ////DataTable dt = StockReports.GetDataTable(ab.ToString());

        ////StringBuilder lab = new StringBuilder();


        ////lab.Append("  SELECT  * FROM patient_labinvestigation_opd plo  WHERE plo.PatientID='" + dt.Rows[0]["PatientID"].ToString() + "' ");
        ////lab.Append("  AND plo.DATE>='" + Util.GetDateTime(AbhaNot.notification.consentDetail.permission.dateRange.from).ToString("yyyy-MM-dd HH:mm:ss") + "' AND plo.DATE<='" + Util.GetDateTime(AbhaNot.notification.consentDetail.permission.dateRange.to).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
        ////lab.Append("   AND plo.Result_Flag=1 ");

        //////DataTable dtLab = StockReports.GetDataTable(lab.ToString());

        string ConsentD = "";
        if (AbhaNot.notification.status != "REVOKED" && AbhaNot.notification.status != "EXPIRED")
        {
            ConsentD = AbhaNot.notification.consentDetail.consentId;

        }
        else
        {
            ConsentD = AbhaNot.notification.consentId;

        }



        StringBuilder sb = new StringBuilder();

        sb.Append("  { ");
        sb.Append(" \"requestId\": \"" + Guid.NewGuid().ToString() + "\", ");
        sb.Append(" \"timestamp\": \"" + DateTime.UtcNow.ToString("o") + "\", ");

        sb.Append("  \"acknowledgement\": { ");
        sb.Append("   \"status\": \"OK\", ");
        sb.Append("   \"consentId\": \"" + ConsentD + "\", ");
        sb.Append("  }, ");
        ////if (dtLab.Rows.Count > 0)
        ////{
        ////    sb.Append(" \"error\": null, ");
        ////}
        ////else
        ////{
        ////    sb.Append("  \"error\": { ");
        ////    sb.Append("  \"code\": \"3502\", ");
        ////    sb.Append("  \"message\": \"Health Information Not Found.\" ");
        ////    sb.Append("  }, ");
        ////}

        //Responce Againest
        sb.Append("  \"resp\": { ");
        sb.Append("  \"requestId\": \"" + AbhaNot.requestId + "\" ");
        sb.Append("  } ");
        //Responce Againest End
        sb.Append(" } ");


        return sb.ToString();
    }


    public bool UpdateNotifyData(AbhaNotifyModel AbhaNot)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            StringBuilder sb = new StringBuilder();

            sb.Append(" update AbhaNotifyData ");
            sb.Append(" set Status=@Status,GrantAcknowledgement=@GrantAcknowledgement where ConsentId=@ConsentId");

            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                ConsentId = AbhaNot.notification.consentId,
                Status = AbhaNot.notification.status,
                GrantAcknowledgement = AbhaNot.notification.grantAcknowledgement,

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


    public bool SaveNotifyData(AbhaNotifyModel AbhaNot)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            StringBuilder sb = new StringBuilder();

            sb.Append(" insert into AbhaNotifyData ");
            sb.Append("( ConsentId,CreatedAt,PurposeText,PurposeCode,PurposeRefUri,PatientId, ");
            sb.Append(" ConsentManagerId,HipId,HipName,HiTypes,PermissionAccessMode,PermissionDateRangeFrom, ");
            sb.Append(" PermissionDateRangeTo,PermissionDataEraseAt,PermissionFrequencyUnit,PermissionFrequencyValue, ");
            sb.Append(" PermissionFrequencyRepeats,Status,Signature,GrantAcknowledgement,RequestId,Timestamp,EntryDate) ");

            sb.Append(" values ");
            sb.Append("( @ConsentId,@CreatedAt,@PurposeText,@PurposeCode,@PurposeRefUri,@PatientId, ");
            sb.Append(" @ConsentManagerId,@HipId,@HipName,@HiTypes,@PermissionAccessMode,@PermissionDateRangeFrom, ");
            sb.Append(" @PermissionDateRangeTo,@PermissionDataEraseAt,@PermissionFrequencyUnit,@PermissionFrequencyValue, ");
            sb.Append(" @PermissionFrequencyRepeats,@Status,@Signature,@GrantAcknowledgement,@RequestId,@Timestamp,NOW()) ");

            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                ConsentId = AbhaNot.notification.consentDetail.consentId,
                CreatedAt = AbhaNot.notification.consentDetail.createdAt,
                PurposeText = AbhaNot.notification.consentDetail.purpose.text,
                PurposeCode = AbhaNot.notification.consentDetail.purpose.code,
                PurposeRefUri = AbhaNot.notification.consentDetail.purpose.refUri,
                PatientId = AbhaNot.notification.consentDetail.patient.id,
                ConsentManagerId = AbhaNot.notification.consentDetail.consentManager.id,
                HipId = AbhaNot.notification.consentDetail.hip.id,
                HipName = AbhaNot.notification.consentDetail.hip.name,
                HiTypes = String.Join(",", AbhaNot.notification.consentDetail.hiTypes),
                PermissionAccessMode = AbhaNot.notification.consentDetail.permission.accessMode,
                PermissionDateRangeFrom = Util.GetDateTime(AbhaNot.notification.consentDetail.permission.dateRange.from).ToString("yyyy-MM-dd HH:mm:ss"),
                PermissionDateRangeTo = Util.GetDateTime(AbhaNot.notification.consentDetail.permission.dateRange.to).ToString("yyyy-MM-dd HH:mm:ss"),
                PermissionDataEraseAt = Util.GetDateTime(AbhaNot.notification.consentDetail.permission.dataEraseAt).ToString("yyyy-MM-dd HH:mm:ss"),
                PermissionFrequencyUnit = AbhaNot.notification.consentDetail.permission.frequency.unit,
                PermissionFrequencyValue = AbhaNot.notification.consentDetail.permission.frequency.value,
                PermissionFrequencyRepeats = AbhaNot.notification.consentDetail.permission.frequency.repeats,
                Status = AbhaNot.notification.status,
                Signature = AbhaNot.notification.signature,
                GrantAcknowledgement = AbhaNot.notification.grantAcknowledgement,
                RequestId = AbhaNot.requestId,
                Timestamp = Util.GetDateTime(AbhaNot.timestamp).ToString("yyyy-MM-dd HH:mm:ss"),

            });

            int NotifyID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT MAX(ID) FROM AbhaNotifyData"));

            foreach (var item in AbhaNot.notification.consentDetail.careContexts)
            {
                StringBuilder sbCa = new StringBuilder();


                sbCa.Append(" INSERT INTO  abhanotifyrequestcarecontexts ");
                sbCa.Append("  (AbhaNotifyId,ConsentID,AbhaID,PatientReference,CareContextReference,FromDate,ToDate,EntryDate) ");
                sbCa.Append(" VALUES  (@AbhaNotifyId,@ConsentID,@AbhaID,@PatientReference,@CareContextReference,@FromDate,@ToDate,NOW()) ");
                int T = excuteCMD.DML(tnx, sbCa.ToString(), CommandType.Text, new
                {
                    AbhaNotifyId = NotifyID,
                    ConsentID = AbhaNot.notification.consentDetail.consentId,
                    AbhaID = AbhaNot.notification.consentDetail.patient.id,
                    PatientReference = item.patientReference,
                    CareContextReference = item.careContextReference,
                    FromDate = Util.GetDateTime(AbhaNot.notification.consentDetail.permission.dateRange.from).ToString("yyyy-MM-dd HH:mm:ss"),
                    ToDate = Util.GetDateTime(AbhaNot.notification.consentDetail.permission.dateRange.to).ToString("yyyy-MM-dd HH:mm:ss"),

                });

            }

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

    public void OnRequestCall(RequestRes AbhaNot, int Delay = 0)
    {
        if (Delay > 0)
            Thread.Sleep(Delay);

        bool b = SaveRequestData(AbhaNot);
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();

        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.TokenBaseUrl);
            client.DefaultRequestHeaders.Add("X-CM-ID", ABHABasicData.XCMID);
            try
            {
                string urldat = "" + ABHABasicData.Getway + "v0.5/health-information/hip/on-request";
                string pp = CreateRequestString(AbhaNot);
                //string payload = System.IO.File.ReadAllText(pp);
                JObject reqObj = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, reqObj).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                if (responseMessage.IsSuccessStatusCode)
                {
                    DataPushToHIU(AbhaNot);
                }
                else
                {
                    //  DataPushToHIU(AbhaNot);

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);

            }


        }



    }

    public string CreateRequestString(RequestRes AbhaNot)
    {


        StringBuilder sb = new StringBuilder();

        sb.Append("  { ");
        sb.Append(" \"requestId\": \"" + Guid.NewGuid().ToString() + "\", ");
        sb.Append(" \"timestamp\": \"" + DateTime.UtcNow.ToString("o") + "\", ");

        sb.Append("  \"hiRequest\": { ");
        sb.Append("   \"transactionId\": \"" + AbhaNot.transactionId + "\", ");
        sb.Append("   \"sessionStatus\": \"ACKNOWLEDGED\", ");
        sb.Append("  }, ");

        //Responce Againest
        sb.Append("  \"resp\": { ");
        sb.Append("  \"requestId\": \"" + AbhaNot.requestId + "\" ");
        sb.Append("  } ");
        //Responce Againest End
        sb.Append(" } ");
        return sb.ToString();
    }

    public bool SaveRequestData(RequestRes AbhaNot)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            StringBuilder sb = new StringBuilder();

            sb.Append(" insert into abha_hiurequest ");
            sb.Append("(  TransactionId,RequestId,Timestamp,ConsentID, ");
            sb.Append("FromDate,ToDate,DataPushUrl,CryptoAlg,Curve, ");
            sb.Append("PublicKeyExpiry,PublicKeyParaMeter, ");
            sb.Append("PublicKeyKeyValue,Nonce, EntryDate )");
            sb.Append(" values ");
            sb.Append("(  @TransactionId,@RequestId,@Timestamp,@ConsentID, ");
            sb.Append("@FromDate,@ToDate,@DataPushUrl,@CryptoAlg,@Curve, ");
            sb.Append("@PublicKeyExpiry,@PublicKeyParaMeter, ");
            sb.Append("@PublicKeyKeyValue,@Nonce, NOW() )");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {

                TransactionId = AbhaNot.transactionId,
                RequestId = AbhaNot.requestId,
                Timestamp = Util.GetDateTime(AbhaNot.timestamp).ToString("yyyy-MM-dd HH:mm:ss"),
                ConsentID = AbhaNot.hiRequest.consent.id,
                FromDate = Util.GetDateTime(AbhaNot.hiRequest.dateRange.from).ToString("yyyy-MM-dd HH:mm:ss"),
                ToDate = Util.GetDateTime(AbhaNot.hiRequest.dateRange.to).ToString("yyyy-MM-dd HH:mm:ss"),
                DataPushUrl = AbhaNot.hiRequest.dataPushUrl,
                CryptoAlg = AbhaNot.hiRequest.keyMaterial.cryptoAlg,
                Curve = AbhaNot.hiRequest.keyMaterial.curve,
                PublicKeyExpiry = Util.GetDateTime(AbhaNot.hiRequest.keyMaterial.dhPublicKey.expiry).ToString("yyyy-MM-dd HH:mm:ss"),
                PublicKeyParaMeter = AbhaNot.hiRequest.keyMaterial.dhPublicKey.parameters,
                PublicKeyKeyValue = AbhaNot.hiRequest.keyMaterial.dhPublicKey.keyValue,
                Nonce = AbhaNot.hiRequest.keyMaterial.nonce,

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

    public void DataPushToHIU(RequestRes AbhaNot)
    {

        using (var client = ABHAClientHelper.GetClient(""))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(AbhaNot.hiRequest.dataPushUrl);
            // client.DefaultRequestHeaders.Add("X-CM-ID", ABHABasicData.XCMID);
            try
            {
                string urldat = "";
                string pp = CreateDataPushString(AbhaNot);
                //string payload = System.IO.File.ReadAllText(pp);
                JObject reqObj = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, reqObj).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                if (responseMessage.IsSuccessStatusCode)
                {
                    string s = status_code;
                    Task.Factory.StartNew(() => NotifyAfterPushingData(AbhaNot, ABHABasicData.Delay));

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

    public string CreateDataPushString(RequestRes AbhaNot)
    {
        StringBuilder ab = new StringBuilder();

        ab.Append("  SELECT DISTINCT(ar.CareContextReference) CareContextReference,ar.ConsentID,ah.TransactionId,an.HiTypes FROM abha_hiurequest  ah  ");
        ab.Append("  INNER JOIN abhanotifydata an ON an.ConsentId=ah.ConsentID ");
        ab.Append("  INNER JOIN abhanotifyrequestcarecontexts ar ON ar.ConsentID=an.ConsentID  ");
        ab.Append("  WHERE ah.TransactionId='" + AbhaNot.transactionId + "' limit 1  ");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(ab.ToString());
        AbhaEncryptionDecrypton ED = new AbhaEncryptionDecrypton();


        //// Generating key pairs 
        //var receiverKeyPair = ED.GenerateKey();
        //var receiverPublicKey = ED.GetPublicKey(receiverKeyPair);
        //var receiverPrivateKey = ED.GetPrivateKey(receiverKeyPair);
        var receiverPublicKey = AbhaNot.hiRequest.keyMaterial.dhPublicKey.keyValue;
        var senderKeyPair = ED.GenerateKey();
        var senderPublicKey = ED.GetPublicKey(senderKeyPair);
        var senderPrivateKey = ED.GetPrivateKey(senderKeyPair);

        // Generating random key 
        var randomKeySender = ED.GenerateRandomKey();
        //var randomKeyReceiver = ED.GenerateRandomKey();
        var randomKeyReceiver = AbhaNot.hiRequest.keyMaterial.nonce;

        // Generating XOR array for getting the salt and IV used for encryption 
        var xorOfRandoms = ED.XorOfRandom(randomKeySender, randomKeyReceiver).ToArray();



        StringBuilder sb = new StringBuilder();

        sb.Append("  { ");
        sb.Append(" \"pageNumber\": \"1\", ");
        sb.Append(" \"pageCount\": \"1\", ");
        sb.Append(" \"transactionId\": \"" + AbhaNot.transactionId + "\", ");
        sb.Append("   \"entries\": [ ");
        if (dt.Rows.Count > 0)
        {
            int count = 1;
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string GetDataToEncrypt = GetDiagnosticReportString(AbhaNot);
                // Encrypting the string
                var encryptString = ED.EncryptString(GetDataToEncrypt,
                    xorOfRandoms,
                    senderPrivateKey,
                    receiverPublicKey);
                string getMd5Hash = ED.CreateMD5CheckSum(GetDataToEncrypt);

                if (count < dt.Rows.Count)
                {
                    sb.Append("  { ");
                    sb.Append("      \"content\": \"" + encryptString + "\", ");
                    sb.Append("     \"media\": \"application/fhir+json\", ");
                    sb.Append("   \"checksum\": \"" + getMd5Hash + "\", ");
                    sb.Append("   \"careContextReference\": \"" + dt.Rows[i]["CareContextReference"].ToString() + "\" ");
                    sb.Append(" }, ");
                }
                else
                {
                    sb.Append("  { ");
                    sb.Append("      \"content\": \"" + encryptString + "\", ");
                    sb.Append("     \"media\": \"application/fhir+json\", ");
                    sb.Append("   \"checksum\": \"" + getMd5Hash + "\", ");
                    sb.Append("   \"careContextReference\": \"" + dt.Rows[i]["CareContextReference"].ToString() + "\" ");
                    sb.Append(" } ");

                }



            }
        }


        sb.Append("  ], ");

        sb.Append("   \"keyMaterial\": { ");
        sb.Append("   \"cryptoAlg\": \"" + ABHABasicData.ALGORITHM + "\", ");
        sb.Append("   \"curve\": \"" + ABHABasicData.CURVE + "\", ");
        sb.Append("   \"dhPublicKey\": { ");
        sb.Append("   \"expiry\": \"" + DateTime.UtcNow.AddMinutes(10).ToString("o") + "\", ");
        // sb.Append("   \"parameters\": \"" + ABHABasicData.CURVE + "/" + ED.GenerateRandomKey() + "\", ");

        sb.Append("   \"parameters\": \"Ephemeral public key\", ");


        sb.Append("   \"keyValue\": \"" + senderPublicKey + "\" ");
        sb.Append("    }, ");
        sb.Append("   \"nonce\": \"" + randomKeySender + "\" ");
        sb.Append("    } ");

        sb.Append(" } ");



        return sb.ToString();
    }

    public string GetString()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" {  ");
        sb.Append(" \"resourceType\": \"Bundle\",");
        sb.Append(" \"id\": \"e24d0d35-a976-4eec-9598-c0f061a56b8b\",");
        sb.Append(" \"meta\":  {  ");
        sb.Append(" \"lastUpdated\": \"2019-04-19T00:00:00.000+05:30\" ");
        sb.Append(" }, ");
        sb.Append(" \"identifier\":  {  ");
        sb.Append(" \"system\": \"https://www.max.in/bundle\",");
        sb.Append(" \"value\": \"e24d0d35-a976-4eec-9598-c0f061a56b8b\" ");
        sb.Append(" }, ");
        sb.Append(" \"type\": \"document\",");
        sb.Append(" \"timestamp\": \"2019-04-19T00:00:00.000+05:30\",");
        sb.Append(" \"entry\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"Composition/fb8c668f-8e53-47dd-802b-aa2ff4763e8c\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"Composition\",");
        sb.Append(" \"id\": \"fb8c668f-8e53-47dd-802b-aa2ff4763e8c\",");
        sb.Append(" \"identifier\":  {  ");
        sb.Append(" \"system\": \"https://www.max.in/document\",");
        sb.Append(" \"value\": \"fb8c668f-8e53-47dd-802b-aa2ff4763e8c\" ");
        sb.Append(" }, ");
        sb.Append(" \"status\": \"final\",");
        sb.Append(" \"type\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://projecteka.in/sct\",");
        sb.Append(" \"code\": \"373942005\",");
        sb.Append(" \"display\": \"Discharge Summary Record\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append(" \"subject\":  {  ");
        sb.Append(" \"reference\": \"Patient/NCC1543\" ");
        sb.Append(" }, ");
        sb.Append(" \"encounter\":  {  ");
        sb.Append(" \"reference\": \"Encounter/ece47f53-28dc-48bf-9232-79efa964defd\" ");
        sb.Append(" }, ");
        sb.Append(" \"date\": \"2019-04-19T00:00:00.605+05:30\",");
        sb.Append(" \"author\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"reference\": \"Practitioner/MAX191101\",");
        sb.Append(" \"display\": \"Dr Akshatha M K\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"title\": \"Discharge Summary Document\",");
        sb.Append(" \"custodian\":  {  ");
        sb.Append(" \"reference\": \"Organization/MaxSaket01\" ");
        sb.Append(" }, ");
        sb.Append(" \"section\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"title\": \"Presenting Problems\",");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://projecteka.in/sct\",");
        sb.Append(" \"code\": \"422843007\",");
        sb.Append(" \"display\": \"Chief Complaint Section\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append(" \"entry\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"reference\": \"Condition/194208f1-a058-4b21-88bd-7ca38bbfe68f\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"title\": \"Allergy Section\",");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://projecteka.in/sct\",");
        sb.Append(" \"code\": \"722446000\",");
        sb.Append(" \"display\": \"Allergy Record\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append(" \"entry\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"reference\": \"AllergyIntolerance/example\" ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"reference\": \"AllergyIntolerance/medication\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"title\": \"Physical Examination\",");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://projecteka.in/sct\",");
        sb.Append(" \"code\": \"425044008\",");
        sb.Append(" \"display\": \"Physical exam section\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append(" \"entry\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"reference\": \"Observation/5d4cf222-76d0-4da1-9beb-c44d676db85c\" ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"reference\": \"Observation/3e1db0b3-46bb-4f23-a5ea-6ed3b3a34cf2\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"title\": \"Prescribed medications during Admission\",");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://projecteka.in/sct\",");
        sb.Append(" \"code\": \"440545006\",");
        sb.Append(" \"display\": \"Prescription\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append(" \"entry\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"reference\": \"MedicationRequest/b07e48bc-1554-4eaa-bee3-0370982eb8f0\" ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"reference\": \"MedicationRequest/27e444a7-379d-44b8-9e4b-24a52a29ff8e\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"title\": \"Clinical consultation\",");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://projecteka.in/sct\",");
        sb.Append(" \"code\": \"371530004\",");
        sb.Append(" \"display\": \"Clinical consultation report\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append(" \"entry\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"reference\": \"DocumentReference/4c641e52-0d59-4835-8752-e380e89c694c\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"title\": \"Procedures\",");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://projecteka.in/sct\",");
        sb.Append(" \"code\": \"371525003\",");
        sb.Append(" \"display\": \"Clinical procedure report\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append(" \"entry\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"reference\": \"Procedure/e6c5e7fd-c22a-4d5a-a568-270753e51249\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"title\": \"Care Plan\",");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://projecteka.in/sct\",");
        sb.Append(" \"code\": \"734163000\",");
        sb.Append(" \"display\": \"Care Plan\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append(" \"entry\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"reference\": \"CarePlan/00bc7230-101b-4339-bbed-89be3918663c\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"title\": \"Follow up\",");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://projecteka.in/sct\",");
        sb.Append(" \"code\": \"736271009\",");
        sb.Append(" \"display\": \"Follow up\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append(" \"entry\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"reference\": \"Appointment/4976fe22-7475-4545-a11b-5160b4950878\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"attester\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"mode\": \"official\",");
        sb.Append(" \"time\": \"2019-01-04T09:10:14Z\",");
        sb.Append(" \"party\":  {  ");
        sb.Append(" \"reference\": \"Organization/MaxSaket01\",");
        sb.Append(" \"display\": \"Max Super Speciality Hospital, Saket\" ");
        sb.Append(" } ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" }, ");

        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"Practitioner/MAX191101\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"Practitioner\",");
        sb.Append(" \"id\": \"MAX191101\",");
        sb.Append(" \"identifier\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://www.mciindia.in/doctor\",");
        sb.Append(" \"value\": \"MAX191101\"");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"name\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"text\": \"Akshatha M K\",");
        sb.Append(" \"prefix\": [ ");
        sb.Append(" \"Dr\" ");
        sb.Append(" ] , ");
        sb.Append(" \"suffix\": [ ");
        sb.Append(" \"MD\" ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"Organization/MaxSaket01\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"Organization\",");
        sb.Append(" \"id\": \"MaxSaket01\",");
        sb.Append(" \"name\": \"Max Super Speciality Hospital, Saket\",");
        sb.Append(" \"alias\": [ ");
        sb.Append(" \"Max\" ");
        sb.Append(" ] , ");
        sb.Append(" \"identifier\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://facilitysbx.ndhm.gov.in\",");
        sb.Append(" \"value\": \"IN0410000183\"");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"telecom\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"phone\",");
        sb.Append(" \"value\": \"(+91) 011-2651-5050\" ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"fax\",");
        sb.Append(" \"value\": \"(+91) 011-2651-5051\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"address\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"line\": [ ");
        sb.Append(" \"1, 2, Press Enclave Marg, Saket Institutional Area, Saket\" ");
        sb.Append(" ] , ");
        sb.Append(" \"city\": \"New Delhi\",");
        sb.Append(" \"state\": \"New Delhi\",");
        sb.Append(" \"postalCode\": \"110017\",");
        sb.Append(" \"country\": \"INDIA\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"endpoint\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"reference\": \"https://www.max.in/hospital-network/max-super-speciality-hospital-saket\",");
        sb.Append(" \"display\": \"Website\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"Patient/NCC1543\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"Patient\",");
        sb.Append(" \"id\": \"NCC1543\",");
        sb.Append(" \"name\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"text\": \"Keith David\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"gender\": \"male\" ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"Condition/3a55eee8-8ed2-496b-8492-a2ee82fae9ab\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"Condition\",");
        sb.Append(" \"id\": \"3a55eee8-8ed2-496b-8492-a2ee82fae9ab\",");
        sb.Append(" \"clinicalStatus\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"http://terminology.hl7.org/CodeSystem/condition-clinical\",");
        sb.Append(" \"code\": \"recurrence\",");
        sb.Append(" \"display\": \"recurrence\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"text\": \"recurrence\" ");
        sb.Append(" }, ");
        sb.Append(" \"category\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"http://terminology.hl7.org/CodeSystem/condition-category\",");
        sb.Append(" \"code\": \"encounter-diagnosis\",");
        sb.Append(" \"display\": \"Encounter Diagnosis\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"text\": \"Encounter Diagnosis\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"severity\":  {  ");
        sb.Append(" \"text\": \"Mild\" ");
        sb.Append(" }, ");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://projecteka.in/sct\",");
        sb.Append(" \"code\": \"128944008\",");
        sb.Append(" \"display\": \"Bacterial infection due to Bacillus\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"text\": \"Bacterial infection due to Bacillus\" ");
        sb.Append(" }, ");
        sb.Append(" \"subject\":  {  ");
        sb.Append(" \"reference\": \"Patient/NCC1543\" ");
        sb.Append(" } ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"Encounter/ece47f53-28dc-48bf-9232-79efa964defd\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"Encounter\",");
        sb.Append(" \"id\": \"ece47f53-28dc-48bf-9232-79efa964defd\",");
        sb.Append(" \"status\": \"finished\",");
        sb.Append(" \"class\":  {  ");
        sb.Append(" \"system\": \"http://terminology.hl7.org/CodeSystem/v3-ActCode\",");
        sb.Append(" \"code\": \"IMP\",");
        sb.Append(" \"display\": \"Inpatient visit\" ");
        sb.Append(" }, ");
        sb.Append(" \"subject\":  {  ");
        sb.Append(" \"reference\": \"Patient/NCC1543\" ");
        sb.Append(" }, ");
        sb.Append(" \"period\":  {  ");
        sb.Append(" \"start\": \"2019-04-15T00:00:00+05:30\",");
        sb.Append(" \"end\": \"2019-04-19T00:00:00+05:30\" ");
        sb.Append(" }, ");
        sb.Append(" \"diagnosis\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"condition\":  {  ");
        sb.Append(" \"reference\": \"Condition/3a55eee8-8ed2-496b-8492-a2ee82fae9ab\" ");
        sb.Append(" } ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"Condition/194208f1-a058-4b21-88bd-7ca38bbfe68f\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"Condition\",");
        sb.Append(" \"id\": \"194208f1-a058-4b21-88bd-7ca38bbfe68f\",");
        sb.Append(" \"category\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"http://terminology.hl7.org/CodeSystem/condition-category\",");
        sb.Append(" \"code\": \"problem-list-item\",");
        sb.Append(" \"display\": \"problem list\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"text\": \"problem list\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"severity\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://projecteka.in/sct\",");
        sb.Append(" \"code\": \"24484000\",");
        sb.Append(" \"display\": \"Severe\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"text\": \"Severe\" ");
        sb.Append(" }, ");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"text\": \"Toothache\" ");
        sb.Append(" }, ");
        sb.Append(" \"subject\":  {  ");
        sb.Append(" \"reference\": \"Patient/NCC1543\" ");
        sb.Append(" } ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"AllergyIntolerance/example\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"AllergyIntolerance\",");
        sb.Append(" \"id\": \"example\",");
        sb.Append(" \"clinicalStatus\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical\",");
        sb.Append(" \"code\": \"active\",");
        sb.Append(" \"display\": \"Active\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append(" \"verificationStatus\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"http://terminology.hl7.org/CodeSystem/allergyintolerance-verification\",");
        sb.Append(" \"code\": \"confirmed\",");
        sb.Append(" \"display\": \"Confirmed\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append(" \"type\": \"allergy\",");
        sb.Append(" \"category\": [ ");
        sb.Append(" \"food\" ");
        sb.Append(" ] , ");
        sb.Append(" \"criticality\": \"high\",");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"http://snomed.info/sct\",");
        sb.Append(" \"code\": \"227493005\",");
        sb.Append(" \"display\": \"Cashew nuts\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append(" \"patient\":  {  ");
        sb.Append(" \"reference\": \"Patient/NCC1543\" ");
        sb.Append(" }, ");
        sb.Append(" \"onsetString\": \"Past 1 year\",");
        sb.Append(" \"asserter\":  {  ");
        sb.Append(" \"reference\": \"Practitioner/MAX191101\",");
        sb.Append(" \"display\": \"Dr Akshatha M K\" ");
        sb.Append(" }, ");
        sb.Append(" \"note\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"text\": \"The criticality is high becasue of the observed anaphylactic reaction when challenged with cashew extract .\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"AllergyIntolerance/medication\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"AllergyIntolerance\",");
        sb.Append(" \"id\": \"medication\",");
        sb.Append(" \"clinicalStatus\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical\",");
        sb.Append(" \"code\": \"active\",");
        sb.Append(" \"display\": \"Active\"");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append(" \"category\": [ ");
        sb.Append(" \"medication\" ");
        sb.Append(" ] , ");
        sb.Append(" \"criticality\": \"high\",");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"http://www.nlm.nih.gov/research/umls/rxnorm\",");
        sb.Append(" \"code\": \"7980\",");
        sb.Append(" \"display\": \"Penicillin G\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append(" \"patient\":  {  ");
        sb.Append(" \"reference\": \"Patient/NCC1543\" ");
        sb.Append(" }, ");
        sb.Append(" \"onsetString\": \"Past 2 year\",");
        sb.Append(" \"asserter\":  {  ");
        sb.Append(" \"reference\": \"Practitioner/MAX191101\",");
        sb.Append(" \"display\": \"Dr Akshatha M K\" ");
        sb.Append(" } ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"Observation/5d4cf222-76d0-4da1-9beb-c44d676db85c\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"Observation\",");
        sb.Append(" \"id\": \"5d4cf222-76d0-4da1-9beb-c44d676db85c\",");
        sb.Append(" \"status\": \"final\",");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"text\": \"Temperature\"");
        sb.Append(" }, ");
        sb.Append(" \"effectiveDateTime\": \"2019-04-15T00:00:00+05:30\",");
        sb.Append(" \"valueQuantity\":  {  ");
        sb.Append(" \"value\": 99.5, ");
        sb.Append(" \"unit\": \"C\" ");
        sb.Append(" } ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"Observation/3e1db0b3-46bb-4f23-a5ea-6ed3b3a34cf2\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"Observation\",");
        sb.Append(" \"id\": \"3e1db0b3-46bb-4f23-a5ea-6ed3b3a34cf2\",");
        sb.Append(" \"status\": \"final\",");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"text\": \"pulse\" ");
        sb.Append(" }, ");
        sb.Append(" \"effectiveDateTime\": \"2019-04-16T00:00:00+05:30\",");
        sb.Append(" \"valueString\": \"72 bpm\" ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"Condition/c34917cd-616b-43de-8f2b-5a755bef6bca\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"Condition\",");
        sb.Append(" \"id\": \"c34917cd-616b-43de-8f2b-5a755bef6bca\",");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"text\": \"inflammation\" ");
        sb.Append(" }, ");
        sb.Append(" \"subject\":  {  ");
        sb.Append(" \"reference\": \"Patient/NCC1543\" ");
        sb.Append(" } ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"MedicationRequest/b07e48bc-1554-4eaa-bee3-0370982eb8f0\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"MedicationRequest\",");
        sb.Append(" \"id\": \"b07e48bc-1554-4eaa-bee3-0370982eb8f0\",");
        sb.Append(" \"status\": \"active\",");
        sb.Append(" \"intent\": \"order\",");
        sb.Append(" \"medicationCodeableConcept\":  {  ");
        sb.Append(" \"text\": \"ibuprofen 500 mg\" ");
        sb.Append(" }, ");
        sb.Append(" \"subject\":  {  ");
        sb.Append(" \"reference\": \"Patient/NCC1543\" ");
        sb.Append(" }, ");
        sb.Append(" \"authoredOn\": \"2019-04-18T00:00:00+05:30\",");
        sb.Append(" \"requester\":  {  ");
        sb.Append(" \"reference\": \"Practitioner/MAX191101\" ");
        sb.Append(" }, ");
        sb.Append(" \"reasonReference\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"reference\": \"Condition/c34917cd-616b-43de-8f2b-5a755bef6bca\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"dosageInstruction\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"text\": \"1 tablet 3 times a day\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"Medication/bacc4303-b5d7-4c2d-b6d6-84d4c8559b22\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"Medication\",");
        sb.Append(" \"id\": \"bacc4303-b5d7-4c2d-b6d6-84d4c8559b22\",");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"text\": \"albendazole 400 mg\" ");
        sb.Append(" } ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"MedicationRequest/27e444a7-379d-44b8-9e4b-24a52a29ff8e\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"MedicationRequest\",");
        sb.Append(" \"id\": \"27e444a7-379d-44b8-9e4b-24a52a29ff8e\",");
        sb.Append(" \"status\": \"active\",");
        sb.Append(" \"intent\": \"order\",");
        sb.Append(" \"medicationReference\":  {  ");
        sb.Append(" \"reference\": \"Medication/bacc4303-b5d7-4c2d-b6d6-84d4c8559b22\" ");
        sb.Append(" }, ");
        sb.Append(" \"subject\":  {  ");
        sb.Append(" \"reference\": \"Patient/NCC1543\" ");
        sb.Append(" }, ");
        sb.Append(" \"authoredOn\": \"2019-04-18T00:00:00+05:30\",");
        sb.Append(" \"requester\":  {  ");
        sb.Append(" \"reference\": \"Practitioner/MAX191101\" ");
        sb.Append(" }, ");
        sb.Append(" \"dosageInstruction\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"text\": \"1 time only\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"Practitioner/MAX1234\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"Practitioner\",");
        sb.Append(" \"id\": \"MAX1234\",");
        sb.Append(" \"identifier\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://www.mciindia.in/doctor\",");
        sb.Append(" \"value\": \"MAX1234\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"name\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"text\": \"Manju Sengar\",");
        sb.Append(" \"prefix\": [ ");
        sb.Append(" \"Dr\" ");
        sb.Append(" ] , ");
        sb.Append(" \"suffix\": [ ");
        sb.Append(" \"MD\" ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"DocumentReference/4c641e52-0d59-4835-8752-e380e89c694c\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"DocumentReference\",");
        sb.Append(" \"id\": \"4c641e52-0d59-4835-8752-e380e89c694c\",");
        sb.Append(" \"status\": \"current\",");
        sb.Append(" \"type\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://projecteka.in/loinc\",");
        sb.Append(" \"code\": \"30954-2\",");
        sb.Append(" \"display\": \"Surgical Pathology Report\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" }, ");
        sb.Append(" \"author\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"reference\": \"Practitioner/MAX1234\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"content\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"attachment\":  {  ");
        sb.Append(" \"contentType\": \"application/pdf\",");
        sb.Append(" \"data\":\"base64\",");
        sb.Append(" \"title\": \"Surgical Pathology Report\" ");
        sb.Append(" } ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"Practitioner/MAX5001\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"Practitioner\",");
        sb.Append(" \"id\": \"MAX5001\",");
        sb.Append(" \"identifier\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://www.mciindia.in/doctor\",");
        sb.Append(" \"value\": \"MAX5001\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"name\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"text\": \"Laxmikanth J\",");
        sb.Append(" \"prefix\": [ ");
        sb.Append(" \"Dr\" ");
        sb.Append(" ] , ");
        sb.Append(" \"suffix\": [ ");
        sb.Append(" \"MD\" ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"Procedure/e6c5e7fd-c22a-4d5a-a568-270753e51249\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"Procedure\",");
        sb.Append(" \"id\": \"e6c5e7fd-c22a-4d5a-a568-270753e51249\",");
        sb.Append(" \"status\": \"completed\",");
        sb.Append(" \"code\":  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://projecteka.in/sct\",");
        sb.Append(" \"code\": \"90105005\",");
        sb.Append(" \"display\": \"Biopsy of soft tissue of forearm (Procedure)\" ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"text\": \"Biopsy of suspected melanoma L) arm\" ");
        sb.Append(" }, ");
        sb.Append(" \"subject\":  {  ");
        sb.Append(" \"reference\": \"Patient/NCC1543\" ");
        sb.Append(" }, ");
        sb.Append(" \"performedDateTime\": \"2019-04-17T00:00:00+05:30\",");
        sb.Append(" \"asserter\":  {  ");
        sb.Append(" \"reference\": \"Practitioner/MAX191101\",");
        sb.Append(" \"display\": \"Dr Akshatha M K\" ");
        sb.Append(" }, ");
        sb.Append(" \"performer\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"actor\":  {  ");
        sb.Append(" \"reference\": \"Practitioner/MAX5001\" ");
        sb.Append(" } ");
        sb.Append(" } ");
        sb.Append(" ] , ");
        sb.Append(" \"complication\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"coding\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"system\": \"https://projecteka.in/sct\",");
        sb.Append(" \"code\": \"131148009\",");
        sb.Append(" \"display\": \"Bleeding\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"CarePlan/00bc7230-101b-4339-bbed-89be3918663c\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"CarePlan\",");
        sb.Append(" \"id\": \"00bc7230-101b-4339-bbed-89be3918663c\",");
        sb.Append(" \"status\": \"draft\",");
        sb.Append(" \"intent\": \"proposal\",");
        sb.Append(" \"title\": \"Tentative Plan for next 2 months\",");
        sb.Append(" \"description\": \"Actively monitor progress. Review every week to start with. Medications to be revised after 2 weeks.\",");
        sb.Append(" \"subject\":  {  ");
        sb.Append(" \"reference\": \"Patient/NCC1543\" ");
        sb.Append(" }, ");
        sb.Append(" \"period\":  {  ");
        sb.Append(" \"start\": \"2019-04-19T00:00:00+05:30\",");
        sb.Append(" \"end\": \"2019-06-18T00:00:00+05:30\" ");
        sb.Append(" }, ");
        sb.Append(" \"author\":  {  ");
        sb.Append(" \"reference\": \"Practitioner/MAX191101\",");
        sb.Append(" \"display\": \"Dr Akshatha M K\" ");
        sb.Append(" }, ");
        sb.Append(" \"note\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"text\": \"Actively monitor progress .\" ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"text\": \"Review every week to start with. Medications to be revised after 2 weeks .\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" }, ");
        sb.Append("  {  ");
        sb.Append(" \"fullUrl\": \"Appointment/4976fe22-7475-4545-a11b-5160b4950878\",");
        sb.Append(" \"resource\":  {  ");
        sb.Append(" \"resourceType\": \"Appointment\",");
        sb.Append(" \"id\": \"4976fe22-7475-4545-a11b-5160b4950878\",");
        sb.Append(" \"status\": \"booked\",");
        sb.Append(" \"description\": \"Review progress in 7 days\",");
        sb.Append(" \"start\": \"2019-04-22T00:00:00.000+05:30\",");
        sb.Append(" \"end\": \"2019-04-22T00:30:00.000+05:30\",");
        sb.Append(" \"participant\": [ ");
        sb.Append("  {  ");
        sb.Append(" \"actor\":  {  ");
        sb.Append(" \"reference\": \"Practitioner/MAX191101\",");
        sb.Append(" \"display\": \"Dr Akshatha M K\" ");
        sb.Append(" }, ");
        sb.Append(" \"status\": \"accepted\" ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");
        sb.Append(" } ");
        sb.Append(" ]  ");
        sb.Append(" } ");

        return sb.ToString();
    }




    public void NotifyAfterPushingData(RequestRes AbhaNot, int Delay = 0)
    {
        if (Delay > 0)
        {
            Thread.Sleep(Delay);
        }
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();

        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.TokenBaseUrl);
            client.DefaultRequestHeaders.Add("X-CM-ID", ABHABasicData.XCMID);
            try
            {
                string urldat = "" + ABHABasicData.Getway + "v0.5/health-information/notify";
                string pp = CreateNotifyString(AbhaNot);
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

    public string CreateNotifyString(RequestRes AbhaNot)
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT * FROM  AbhaNotifyData ab WHERE ab.ConsentId='" + AbhaNot.hiRequest.consent.id + "' order by id desc limit 1");

        AbhaEncryptionDecrypton ED = new AbhaEncryptionDecrypton();

        StringBuilder sb = new StringBuilder();

        sb.Append("   {");
        sb.Append("  \"requestId\": \"" + Guid.NewGuid().ToString() + "\",");
        sb.Append("  \"timestamp\": \"" + DateTime.UtcNow.ToString("o") + "\",");
        sb.Append("  \"notification\": {");
        sb.Append("  \"consentId\": \"" + AbhaNot.hiRequest.consent.id + "\",");
        sb.Append("  \"transactionId\": \"" + AbhaNot.transactionId + "\",");
        sb.Append("  \"doneAt\": \"" + DateTime.UtcNow.ToString("o") + "\",");
        sb.Append("  \"notifier\": {");
        sb.Append("  \"type\": \"HIP\",");
        sb.Append("  \"id\": \"" + dt.Rows[0]["HipId"].ToString() + "\"");
        sb.Append("  },");
        sb.Append("  \"statusNotification\": {");
        sb.Append("  \"sessionStatus\": \"TRANSFERRED\",");
        sb.Append("  \"hipId\": \"" + dt.Rows[0]["HipId"].ToString() + "\",");
        sb.Append("  \"statusResponses\": [");
        sb.Append("  {");
        sb.Append("  \"careContextReference\": \"388\",");
        sb.Append("  \"hiStatus\": \"OK\",");
        sb.Append("  \"description\": \"\"");
        sb.Append("  }");
        sb.Append("  ]");
        sb.Append("  }");
        sb.Append(" }");
        sb.Append("  }");


        return sb.ToString();
    }



    public string GetDiagnosticReportString(RequestRes AbhaNot)
    {
        string FromDate = Util.GetDateTime(AbhaNot.hiRequest.dateRange.from).ToString("yyyy-MM-dd 00:00:00");
        string ToDate = Util.GetDateTime(AbhaNot.hiRequest.dateRange.to).ToString("yyyy-MM-dd 23:59:59");


        StringBuilder OrgString = new StringBuilder();
        StringBuilder PracString = new StringBuilder();
        StringBuilder PatientString = new StringBuilder();
        StringBuilder EncounterString = new StringBuilder();
        StringBuilder DiagnosticString = new StringBuilder();


        StringBuilder ab = new StringBuilder();
        ab.Append("SELECT pm.PatientID,pm.PName,pm.Age,pm.DOB,pm.Gender,an.HipId,an.PatientId HealthID,(SELECT aa.Name FROM abha_registerdfacility aa WHERE aa.UserName=an.HipId ORDER BY ID DESC LIMIT 1 )HipName,(SELECT GROUP_CONCAT(DISTINCT aa.Alias) FROM abha_registerdfacility aa WHERE aa.UserName=an.HipId ORDER BY ID) HIPAlias  FROM abha_hiurequest  ah ");
        ab.Append("INNER JOIN abhanotifydata an ON an.ConsentId=ah.ConsentID  ");
        ab.Append("INNER JOIN abha_registration ar ON ar.HealthId=an.PatientId ");
        ab.Append("INNER JOIN patient_master pm ON pm.PatientID=ar.PatientId ");
        ab.Append("WHERE ah.TransactionId='" + AbhaNot.transactionId + "' limit 1 ");
        DataTable dt = StockReports.GetDataTable(ab.ToString());

        StringBuilder lab = new StringBuilder();


        lab.Append("  SELECT  * FROM patient_labinvestigation_opd plo  WHERE plo.PatientID='" + dt.Rows[0]["PatientID"].ToString() + "' ");
        lab.Append("  AND plo.DATE>='" + FromDate + "' AND plo.DATE<='" + ToDate + "' ");
        lab.Append("   AND plo.Result_Flag=1 ");

        DataTable dtLab = StockReports.GetDataTable(lab.ToString());




        StringBuilder sb = new StringBuilder();
        string CompositonGuide = Guid.NewGuid().ToString();
        string IdentifireGuide = Guid.NewGuid().ToString();
        string LastUpdate = DateTime.UtcNow.ToString("o");

        sb.Append("  { ");
        sb.Append("  \"resourceType\":\"Bundle\", ");
        sb.Append("  \"id\":\"" + IdentifireGuide + "\",");
        sb.Append("  \"meta\":{ ");
        sb.Append("  \"lastUpdated\":\"" + LastUpdate + "\"");
        sb.Append("   }, ");
        sb.Append("  \"timestamp\":\"" + LastUpdate + "\",");
        sb.Append("  \"identifier\":{ ");
        sb.Append("  \"system\":\"https://www.max.in/bundle\",");
        sb.Append("  \"value\":\"" + IdentifireGuide + "\" ");
        sb.Append("  },");
        sb.Append("  \"type\":\"document\",");
        sb.Append("  \"entry\":[ ");
        sb.Append("   {");
        sb.Append("  \"fullUrl\":\"Composition/" + CompositonGuide + "\",");
        sb.Append("  \"resource\":{ ");
        sb.Append("  \"resourceType\":\"Composition\", ");
        sb.Append("  \"id\":\"" + CompositonGuide + "\", ");
        sb.Append("  \"date\":\"" + LastUpdate + "\", ");
        sb.Append("  \"text\":{ ");
        sb.Append("  \"status\":\"generated\", ");
        sb.Append("  \"div\": \"<div xmlns='http://www.w3.org/1999/xhtml' > Diagnostic Report for " + dt.Rows[0]["PName"].ToString() + " (" + dt.Rows[0]["PatientID"].ToString() + ")</div>\" ");
        sb.Append("  }, ");
        sb.Append("  \"identifier\":{ ");
        sb.Append("  \"system\": \"" + ABHABasicData.HospitalURL + "\", ");
        sb.Append("  \"value\":\"" + CompositonGuide + "\" ");
        sb.Append("  }, ");
        sb.Append("  \"status\":\"final\", ");
        sb.Append("  \"type\":{ ");
        sb.Append("  \"coding\":[ ");
        sb.Append("   { ");
        sb.Append("  \"system\":\"" + ABHABasicData.HospitalURL + "\", ");
        sb.Append("  \"code\":\"721981007\", ");
        sb.Append("  \"display\":\"Diagnostic Report\" ");
        sb.Append("  } ");
        sb.Append("   ], ");
        sb.Append("  \"text\":\"Prescription record\" ");
        sb.Append("  }, ");

        // Encounter Start
        string EncounterGuide = Guid.NewGuid().ToString();
        sb.Append("    \"encounter\":{ ");
        sb.Append("      \"reference\":\"Encounter/" + EncounterGuide + "\", ");
        sb.Append("     \"display\":\"OPD Visit - patient walked in\" ");
        sb.Append("    },");
        EncounterString.Append(GetEncounterString(dt, EncounterGuide));
        // Encounter End

        //Subject Start
        sb.Append("     \"subject\":{ ");
        sb.Append("     \"reference\":\"Patient/" + dt.Rows[0]["PatientID"].ToString() + "\" ");
        sb.Append("    }, ");

        PatientString.Append(GetPatientString(dt));

        //Subject End

        string OrganizationGuide = Guid.NewGuid().ToString();
        string PractitionerGude = Guid.NewGuid().ToString();

        //Author Start
        sb.Append(" \"author\":[ ");

        //Organization Start
        sb.Append("   { ");
        sb.Append("     \"reference\":\"Organization/" + OrganizationGuide + "\" ");
        sb.Append("    }, ");
        OrgString.Append(GetOrganizationString(dt, OrganizationGuide));

        //Organization End

        //Practitioner Start
        sb.Append("   { ");
        sb.Append("     \"reference\":\"Practitioner/" + PractitionerGude + "\" ");
        sb.Append("   } ");
        PracString.Append(GetPractitionerString(dtLab, "", PractitionerGude));
        //Practitioner End

        sb.Append("   ], ");

        //Author END


        sb.Append("   \"title\":\"Doc: Surgical Pathology Report\", ");
        //Section Start
        sb.Append(" \"section\":[ ");
        sb.Append("  { ");
        sb.Append("  \"title\":\"Section - Diagnostic report: Surgical Pathology\", ");
        sb.Append("  \"code\":{ ");
        sb.Append("  \"coding\":[ ");
        sb.Append("     { ");
        sb.Append("     \"system\":\"" + ABHABasicData.HospitalURL + "\", ");
        sb.Append("   \"code\":\"721981007\", ");
        sb.Append("   \"display\":\"Diagnosti Report: Surgical Pathology\" ");
        sb.Append("  } ");
        sb.Append(" ] ");
        sb.Append("  }, ");

        int count = 1;
        // DiagnosticReport Reffsection Start
        sb.Append(" \"entry\":[ ");
        for (int i = 0; i < dtLab.Rows.Count; i++)
        {
            string DiagnosticGuide = Guid.NewGuid().ToString();
            if (count < dtLab.Rows.Count)
            {
                sb.Append(" { ");
                sb.Append(" \"reference\":\"DiagnosticReport/" + DiagnosticGuide + "\" ");
                sb.Append(" }, ");
                DiagnosticString.Append(GetDiagnosticString(dt.Rows[i]["PatientID"].ToString(), dt.Rows[i]["PName"].ToString(), FromDate, ToDate, DiagnosticGuide, PractitionerGude, dtLab.Rows[i]["Test_ID"].ToString(), OrganizationGuide, dtLab, i));
                DiagnosticString.Append(",");
            }
            else
            {
                sb.Append(" { ");
                sb.Append(" \"reference\":\"DiagnosticReport/" + DiagnosticGuide + "\" ");
                sb.Append(" } ");
                DiagnosticString.Append(GetDiagnosticString(dt.Rows[i]["PatientID"].ToString(), dt.Rows[i]["PName"].ToString(), FromDate, ToDate, DiagnosticGuide, PractitionerGude, dtLab.Rows[i]["Test_ID"].ToString(), OrganizationGuide, dtLab, i));

            }

            count = count + 1;

        }


        sb.Append("  ] ");
        // DiagnosticReport Reffsection End

        sb.Append("  } ");
        sb.Append("  ], ");
        //Section End


        //Attester Start

        sb.Append(" \"attester\": [ ");
        sb.Append(" { ");
        sb.Append(" \"mode\": \"official\",");
        sb.Append(" \"time\": \"" + DateTime.UtcNow.ToString("o") + "\",");
        sb.Append(" \"party\": { ");
        sb.Append(" \"reference\": \"Organization/" + OrganizationGuide + "\",");
        sb.Append(" \"display\": \"" + dt.Rows[0]["HipName"].ToString() + "\" ");
        sb.Append("} ");
        sb.Append(" } ");
        sb.Append("] ");

        //Attester End

        sb.Append(" } ");
        sb.Append("}, ");


        sb.Append(OrgString.ToString());
        sb.Append(PracString.ToString());
        sb.Append(PatientString.ToString());

        sb.Append(EncounterString.ToString());

        sb.Append(DiagnosticString.ToString()); // Diagnostic
        ////ab.Append(ObservationString.ToString());// Observation
        ////ab.Append(MediaString.ToString()); // Media

        sb.Append(" ]");
        sb.Append(" }");

        return sb.ToString();

    }


    public string GetDiagnosticString(string PID, string PName, string FromDate, string ToDate, string DiagGuide, string PractitionerGuide, string TestID, string OrganizationGuide, DataTable dtLab, int Row)
    {
        StringBuilder ObservationString = new StringBuilder();
        StringBuilder MediaString = new StringBuilder();

        StringBuilder ab = new StringBuilder();
        ab.Append("SELECT * FROM  investigation_master im WHERE im.Investigation_Id='" + dtLab.Rows[Row]["Investigation_ID"].ToString() + "'");
        DataTable dtInv = StockReports.GetDataTable(ab.ToString());
        ab = new StringBuilder();
        ab.Append("SELECT * FROM patient_labobservation_opd plo WHERE plo.Test_ID='" + dtLab.Rows[Row]["Test_ID"].ToString() + "'");
        DataTable dtObs = StockReports.GetDataTable(ab.ToString());

        StringBuilder sb = new StringBuilder();
        sb.Append(" { ");
        sb.Append(" \"fullUrl\":\"DiagnosticReport/" + DiagGuide + "\", ");
        sb.Append(" \"resource\":{ ");
        sb.Append(" \"resourceType\":\"DiagnosticReport\", ");
        sb.Append(" \"id\":\"" + DiagGuide + "\", ");
        sb.Append(" \"status\":\"final\", ");
        sb.Append(" \"code\":{ ");
        sb.Append("  \"text\":\"" + dtInv.Rows[0]["Name"].ToString() + "\" ");
        sb.Append("  }, ");


        sb.Append(" \"subject\":{ ");
        sb.Append("  \"display\":\"" + PName + "\", ");
        sb.Append("  \"reference\":\"Patient/" + PID + "\" ");
        sb.Append(" }, ");

        sb.Append(" \"performer\" : [ ");
        sb.Append("  { ");
        sb.Append("   \"reference\":\"Organization/" + OrganizationGuide + "\" ");
        sb.Append(" } ");
        sb.Append(" ], ");

        sb.Append("  \"resultsInterpreter\"  : [ ");
        sb.Append("  { ");
        sb.Append("   \"reference\":\"Practitioner/" + PractitionerGuide + "\" ");
        sb.Append(" }     ");
        sb.Append("   ], ");

        sb.Append(" \"result\": [ ");

        int Count = 1;
        for (int i = 0; i < dtObs.Rows.Count; i++)
        {
            var observationGuide = Guid.NewGuid().ToString();

            if (Count < dtObs.Rows.Count)
            {
                sb.Append("  { ");
                sb.Append("   \"reference\": \"Observation/" + observationGuide + "\" ");
                sb.Append(" }, ");
            }
            else
            {
                sb.Append("  { ");
                sb.Append("   \"reference\": \"Observation/" + observationGuide + "\" ");
                sb.Append(" } ");
            }

            ObservationString.Append(GetObservationString(PID, PName, observationGuide, dtObs, i));

            Count = Count + 1;
        }

        sb.Append(" ], ");


        sb.Append(" \"effectiveDateTime\":\"" + Util.GetDateTime(dtLab.Rows[Row]["SampleDate"].ToString()).ToUniversalTime().ToString("o") + "\", ");
        sb.Append("  \"issued\":\"" + Util.GetDateTime(dtLab.Rows[Row]["ResultEnteredDate"].ToString()).ToUniversalTime().ToString("o") + "\", ");
        sb.Append(" \"media\": [ ");
        sb.Append("   { ");

        sb.Append("  \"comment\": \"" + dtInv.Rows[0]["NAME"].ToString() + "\", ");
        string MediaGuide = Guid.NewGuid().ToString();
        sb.Append("  \"link\": { ");
        sb.Append("  \"reference\": \"Media/" + MediaGuide + "\", ");
        sb.Append("  \"display\": \"" + dtInv.Rows[0]["NAME"].ToString() + "\" ");
        sb.Append("  } ");
        MediaString.Append(GetMediaStrings(PID, FromDate, ToDate, MediaGuide, TestID));
        sb.Append("  } ");


        sb.Append(" ], ");

        sb.Append("  \"conclusion\": \"" + dtInv.Rows[0]["NAME"].ToString() + "\" ");
        sb.Append(" } ");
        sb.Append("  }, ");

        sb.Append(ObservationString.ToString());
        sb.Append(MediaString.ToString());


        return sb.ToString();
    }


    public string GetObservationString(string PID, string PName, string GuideID, DataTable dtObs, int Row)
    {


        StringBuilder sb = new StringBuilder();
        sb.Append(" { ");
        sb.Append(" \"fullUrl\": \"Observation/" + GuideID + "\", ");
        sb.Append(" \"resource\": { ");
        sb.Append(" \"resourceType\": \"Observation\", ");
        sb.Append(" \"id\": \"" + GuideID + "\", ");
        sb.Append(" \"text\": { ");
        sb.Append(" \"status\": \"additional\", ");
        sb.Append(" \"div\": \"<div xmlns='http://www.w3.org/1999/xhtml'>" + dtObs.Rows[Row]["LabObservationName"].ToString() + "</div>\" ");
        sb.Append(" }, ");
        sb.Append(" \"status\": \"final\", ");
        sb.Append(" \"code\": { ");
        sb.Append(" \"text\": \"" + dtObs.Rows[Row]["LabObservationName"].ToString() + "\" ");
        sb.Append(" }, ");
        sb.Append(" \"subject\": { ");
        sb.Append(" \"display\": \"" + PName + "\" ");
        sb.Append("  }, ");
        sb.Append(" \"performer\": [ ");
        sb.Append("  { ");
        sb.Append(" \"display\": \"" + dtObs.Rows[Row]["ParamEnteredByName"].ToString() + "\" ");
        sb.Append(" } ");
        sb.Append(" ], ");
        if (!string.IsNullOrEmpty( dtObs.Rows[Row]["Value"].ToString()) )
        {
            sb.Append(" \"valueString\": \"" + dtObs.Rows[Row]["Value"].ToString() + "\" ");

        }
        else
        {
            sb.Append(" \"valueString\": \"0\" ");
       
        }   
       sb.Append(" } ");
        sb.Append(" }, ");

        return sb.ToString();
    }


    public string GetMediaStrings(string PID, string FromDate, string ToDate, string GudeID, string TestId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" { ");

        sb.Append(" \"fullUrl\": \"Media/" + GudeID + "\", ");
        sb.Append(" \"resource\": { ");
        sb.Append(" \"resourceType\": \"Media\", ");
        sb.Append(" \"id\": \"" + GudeID + "\", ");
        sb.Append(" \"status\": \"completed\", ");
        sb.Append(" \"content\": { ");
        sb.Append(" \"contentType\": \"application/pdf\", ");
        sb.Append(" \"data\": \"" + Getbase64string(PID, FromDate, ToDate, TestId) + "\" ");

        sb.Append(" } ");
        sb.Append(" } ");
        sb.Append(" } ");
        return sb.ToString();
    }


    public string GetOrganizationString(DataTable dt, string OrganizationGuide)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  { ");
        sb.Append(" \"fullUrl\": \"Organization/" + OrganizationGuide + "\", ");
        sb.Append(" \"resource\" : { ");
        sb.Append("  \"resourceType\":\"Organization\", ");
        sb.Append(" \"id\": \"" + OrganizationGuide + "\", ");
        sb.Append("  \"name\":\"" + dt.Rows[0]["HIPName"].ToString() + "\", ");
        sb.Append(" \"alias\":[ ");
        int count = 1;
        string[] ArrAlias = dt.Rows[0]["HIPAlias"].ToString().Split(',');
        for (int i = 0; i < ArrAlias.Length; i++)
        {
            if (count < ArrAlias.Length)
            {
                sb.Append("    \"" + ArrAlias[i] + "\", ");
            }
            else
            {
                sb.Append("    \"" + ArrAlias[i] + "\" ");
            }

            count = count + 1;
        }


        sb.Append("     ], ");
        sb.Append("  \"identifier\": [ ");
        sb.Append("    { ");
        sb.Append("     \"system\": \"" + ABHABasicData.HospitalURL + "\", ");
        sb.Append("    \"value\": \"IN0410000183\" ");
        sb.Append("   } ");
        sb.Append("   ], ");
        sb.Append("    \"telecom\":[ ");
        sb.Append("       { ");
        sb.Append("         \"system\":\"phone\", ");
        sb.Append("       \"value\":\"(+91) 011-2651-5050\" ");
        sb.Append("    }, ");
        sb.Append("    { ");
        sb.Append("        \"system\":\"fax\", ");
        sb.Append("      \"value\":\"(+91) 011-2651-5051\" ");
        sb.Append("   } ");
        sb.Append("    ], ");
        sb.Append("   \"address\":[ ");
        sb.Append("    { ");
        sb.Append("       \"line\":[ ");
        sb.Append("      \"1, 2, Press Enclave Marg, Saket Institutional Area, Saket\" ");
        sb.Append("     ], ");
        sb.Append("    \"city\":\"New Delhi\", ");
        sb.Append("     \"state\":\"New Delhi\", ");
        sb.Append("    \"postalCode\":\"110017\", ");
        sb.Append("    \"country\":\"INDIA\" ");
        sb.Append("    } ");
        sb.Append("     ],");
        sb.Append("     \"endpoint\":[ ");
        sb.Append("     { ");
        sb.Append(" \"reference\":\"" + ABHABasicData.HospitalURL + "\", ");
        sb.Append("        \"display\":\"Website\" ");
        sb.Append("     } ");
        sb.Append("     ] ");
        sb.Append("     } ");
        sb.Append("     }, ");

        return sb.ToString();

    }

    public string GetPractitionerString(DataTable dt, string LedgertransNo, string PractitionerGude)
    {

        StringBuilder ab = new StringBuilder();

        ab.Append("SELECT   dm.DoctorID,dm.Title Prefix,dm.NAME,dm.Designation Suffix,SUBSTRING_INDEX(dm.NAME,' ',-1)Family,SUBSTRING_INDEX(dm.NAME,' ',1)Given ");
        ab.Append(" FROM doctor_master dm WHERE dm.DoctorID='" + dt.Rows[0]["DoctorID"].ToString() + "' ");
        DataTable dtdoc = StockReports.GetDataTable(ab.ToString());
        StringBuilder sb = new StringBuilder();
        sb.Append("{ ");
        sb.Append(" \"fullUrl\": \"Practitioner/" + PractitionerGude + "\", ");
        sb.Append(" \"resource\": { ");
        sb.Append(" \"resourceType\": \"Practitioner\", ");
        sb.Append(" \"id\": \"" + PractitionerGude + "\", ");
        sb.Append(" \"identifier\": [ ");
        sb.Append(" { ");
        sb.Append(" \"system\": \"" + ABHABasicData.HospitalURL + "\", ");
        sb.Append(" \"value\": \"" + dtdoc.Rows[0]["DoctorID"].ToString() + "\" ");
        sb.Append(" } ");
        sb.Append(" ], ");
        sb.Append(" \"name\": [ ");
        sb.Append("   { ");
        sb.Append(" \"text\": \"" + dtdoc.Rows[0]["NAME"].ToString() + "\", ");
        sb.Append(" \"family\": \"" + dtdoc.Rows[0]["Family"].ToString() + "\", ");
        sb.Append(" \"given\": [ ");
        sb.Append(" \"" + dtdoc.Rows[0]["Given"].ToString() + "\" ");
        sb.Append(" ], ");
        sb.Append(" \"prefix\": [ ");
        //   sb.Append(" \"" + dtdoc.Rows[0]["Prefix"].ToString() + "\" ");
        sb.Append("  ], ");
        sb.Append(" \"suffix\": [ ");
        sb.Append(" \"" + dtdoc.Rows[0]["Suffix"].ToString() + "\" ");
        sb.Append("  ] ");
        sb.Append("  } ");
        sb.Append("  ] ");
        sb.Append("  } ");
        sb.Append("  }, ");

        return sb.ToString();

    }

    public string GetPatientString(DataTable dt)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" { ");
        sb.Append("  \"fullUrl\": \"Patient/" + dt.Rows[0]["PatientID"].ToString() + "\", ");
        sb.Append("  \"resource\": { ");
        sb.Append("   \"resourceType\": \"Patient\", ");
        sb.Append("   \"id\": \"" + dt.Rows[0]["PatientID"].ToString() + "\", ");
        sb.Append("   \"identifier\": [ ");
        sb.Append("    { ");
        sb.Append("    \"system\": \"" + ABHABasicData.HospitalURL + "\", ");
        sb.Append("    \"value\": \"" + dt.Rows[0]["HealthID"].ToString() + "\" ");
        sb.Append("   } ");
        sb.Append("    ], ");
        sb.Append("   \"name\": [ ");
        sb.Append("     { ");
        sb.Append("    \"text\": \"" + dt.Rows[0]["PName"].ToString() + "\" ");
        sb.Append("   } ");
        sb.Append("    ] ");
        sb.Append("    } ");
        sb.Append("   }, ");
        return sb.ToString();
    }
    public string GetEncounterString(DataTable dt, string EncounterGuide)
    {
        StringBuilder ab = new StringBuilder();

        ab.Append("SELECT CONCAT(ap.Date,' ',ap.Time)StartTime,CONCAT(ap.Date,' ',ap.EndTime)EndTime,sm.NAME,sm.Description  ");
        ab.Append("  FROM appointment ap ");
        ab.Append("   INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=ap.SubCategoryID");
        ab.Append("   WHERE ap.PatientID='" + dt.Rows[0]["PatientID"].ToString() + "'");
        DataTable dtApp = StockReports.GetDataTable(ab.ToString());
        string FromDate = "";
        string ToDate = "";
        string Display = "";
        string Code = "";
        if (dtApp.Rows.Count > 0)
        {
            FromDate = Util.GetDateTime(dtApp.Rows[0]["StartTime"].ToString()).ToString("o");
            ToDate = Util.GetDateTime(dtApp.Rows[0]["EndTime"].ToString()).ToString("o");
            Display = dtApp.Rows[0]["NAME"].ToString();
            Code = dtApp.Rows[0]["Description"].ToString();
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(" { ");
        sb.Append(" \"fullUrl\": \"Encounter/" + EncounterGuide + "\", ");
        sb.Append(" \"resource\": { ");
        sb.Append("  \"resourceType\": \"Encounter\", ");
        sb.Append(" \"id\": \"" + EncounterGuide + "\", ");
        sb.Append(" \"status\": \"finished\", ");
        sb.Append(" \"class\": { ");
        sb.Append("  \"system\": \"" + ABHABasicData.HospitalURL + "\", ");
        sb.Append(" \"code\": \"" + Code + "\", ");
        sb.Append(" \"display\": \"" + Display + "\" ");
        sb.Append("  }, ");
        sb.Append("  \"period\": { ");
        sb.Append("   \"start\": \"" + Util.GetDateTime(FromDate).ToUniversalTime().ToString("o") + "\", ");
        sb.Append("   \"end\": \"" + Util.GetDateTime(ToDate).ToUniversalTime().ToString("o") + "\" ");
        sb.Append("  }, ");
        sb.Append(" \"subject\": { ");
        sb.Append("      \"reference\" : \"Patient/" + dt.Rows[0]["PatientID"].ToString() + "\" ");
        sb.Append("  } ");
        sb.Append(" } ");
        sb.Append("  }, ");
        return sb.ToString();
    }



    public string Getbase64string(string PID, string FromDate, string ToDate, string Id)
    {
        // string Id = StockReports.ExecuteScalar(" SELECT GROUP_CONCAT(plo.Test_ID) FROM patient_labinvestigation_opd plo  WHERE plo.PatientID='" + PID + "' AND plo.DATE>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd 00:00:00") + "' AND plo.DATE<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd 23:59:59") + "' AND plo.Result_Flag=1");

        string base64 = "";
        using (System.Net.WebClient webclient = new System.Net.WebClient())
        {
            byte[] pdfBuffer = webclient.DownloadData("http://itd2.fw.ondgni.com/Tenwekabhanew/Design/Lab/printLabReport_pdf.aspx?IsPrev=0&TestID=" + Id + "&Phead=0");
            base64 = Convert.ToBase64String(pdfBuffer, 0, pdfBuffer.Length);
        }

        return base64;
    }

}

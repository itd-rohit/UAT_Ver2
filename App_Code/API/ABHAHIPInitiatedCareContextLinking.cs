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
/// Summary description for ABHSHIPInitiatedCareContextLinking
/// </summary>
public class ABHAHIPInitiatedCareContextLinking
{
    public void UpdateOnFetchData(HIPInitiatedFetchAuth PatData, string Status)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            int IsOnAuthResponce = 0;

            string AuthMode = "";
            string Code = "";
            string Message = "";
            if (PatData.auth != null)
            {
                Status = "OK";
                IsOnAuthResponce = 1;
                AuthMode = String.Join(",", PatData.auth.modes);
            }
            else
            {
                if (PatData.error != null)
                {
                    Code = PatData.error.code;
                    Message = PatData.error.message;
                }
                IsOnAuthResponce = 2;
            }


            StringBuilder sb = new StringBuilder();

            sb.Append(" UPDATE abha_fetchauth af  ");
            sb.Append(" SET af.IsOnAuthResponce=@IsOnAuthResponce ,af.AuthResponceReqId=@AuthResponceReqId ,af.Status=@Status, ");
            sb.Append(" af.Code=@Code, af.Message=@Message,af.AuthMethod=@AuthMethod ");
            sb.Append(" WHERE af.RequestId=@RequestId ");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                IsOnAuthResponce = IsOnAuthResponce,
                AuthResponceReqId = PatData.requestId,
                Status = Status,
                Code = Code,
                Message = Message,
                AuthMethod = AuthMode,
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

    public void UpdateOnInitData(HIPInitiatedInitPost PatData, string Status)
    {


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            int IsOnAuthResponce = 0;

            string transactionid = "";
            string Code = "";
            string Message = "";
            if (PatData.auth != null)
            {
                Status = "OK";
                IsOnAuthResponce = 1;
                transactionid = PatData.auth.transactionId;
            }
            else
            {
                if (PatData.error != null)
                {
                    Code = PatData.error.code;
                    Message = PatData.error.message;
                }
                IsOnAuthResponce = 2;
            }


            StringBuilder sb = new StringBuilder();

            sb.Append(" UPDATE abha_hipinit af  ");
            sb.Append(" SET af.IsOnInit=@IsOnAuthResponce ,af.AuthResponceReqId=@AuthResponceReqId ,af.Status=@Status, ");
            sb.Append(" af.Code=@Code, af.Message=@Message,TransactionId=@TransactionId ");
            sb.Append(" WHERE af.RequestId=@RequestId ");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                IsOnAuthResponce = IsOnAuthResponce,
                AuthResponceReqId = PatData.requestId,
                Status = Status,
                Code = Code,
                Message = Message,
                RequestId = PatData.resp.requestId,
                TransactionId = transactionid
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


    public void UpdateConfirmData(HIPOnConfirmAuth PatData, string Status)
    {


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            int IsOnAuthResponce = 0;

            string AccessToken = "";
            string Code = "";
            string Message = "";
            string DateOfBirth = "0001-01-01";
            string Name = "";
            string Gender = "";

            string Line = "";
            string District = "";
            string State = "";
            string Pincode = "";

            if (PatData.auth.patient != null && !string.IsNullOrEmpty(PatData.auth.patient.yearOfBirth.ToString()))
            {
                Name = PatData.auth.patient.name;
                Gender = PatData.auth.patient.gender;
                DateOfBirth = Util.GetDateTime(PatData.auth.patient.yearOfBirth + "-" + PatData.auth.patient.monthOfBirth + "-" + PatData.auth.patient.dayOfBirth).ToString("yyyy-MM-dd");
            }
            if (PatData.auth.patient.address != null)
            {
                Line = PatData.auth.patient.address.line;
                District = PatData.auth.patient.address.district;
                State = PatData.auth.patient.address.state;
                Pincode = PatData.auth.patient.address.pincode;
                DateOfBirth = Util.GetDateTime(PatData.auth.patient.yearOfBirth + "-" + PatData.auth.patient.monthOfBirth + "-" + PatData.auth.patient.dayOfBirth).ToString("yyyy-MM-dd");
            }
            if (PatData.auth != null)
            {
                Status = "OK";
                IsOnAuthResponce = 1;
                AccessToken = PatData.auth.accessToken;
            }
            else
            {
                if (PatData.error != null)
                {
                    Code = PatData.error.code;
                    Message = PatData.error.message;
                }
                IsOnAuthResponce = 2;
            }

            string stringIdentifire = string.Join("#", PatData.auth.patient.identifiers.Select(x => x.type + "_" + x.value).ToArray());

            StringBuilder sb = new StringBuilder();

            sb.Append(" UPDATE abha_hipconfirmauth acm SET acm.AccessToken=@AccessToken,acm.IsConfirm=@IsConfirm, ");
            sb.Append(" acm.Status=@STATUS,acm.ResRequestID=@ResRequestID,acm.Code=@Code,acm.Message=@Message, ");
            sb.Append(" acm.Name=@Name,acm.Gender=@Gender,acm.DOB=@DOB,acm.Line=@Line, ");
            sb.Append("  acm.District=@District,acm.State=@State,acm.Pincode=@Pincode,acm.Identifire=@Identifire ");
            sb.Append(" WHERE acm.RequestID=@RequestID  ");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                AccessToken = AccessToken,
                IsConfirm = IsOnAuthResponce,
                Status = Status,
                ResRequestID = PatData.requestId,
                Code = Code,
                Message = Message,
                Name = Name,
                Gender = Gender,
                DOB = DateOfBirth,
                Line = Line,
                District = District,
                State = State,
                Pincode = Pincode,
                Identifire = stringIdentifire,
                RequestID = PatData.resp.requestId,

            });
            string query = "SELECT ifnull(ahc.AbhaID,'') FROM abha_hipconfirmauth ahc where ahc.RequestID=@RequestID ";
            //string ID = Util.GetString(StockReports.ExecuteScalar(query));
            string ID =Util.GetString(excuteCMD.ExecuteScalar(query, new
            {
                RequestID = PatData.resp.requestId
            }));

            sb = new StringBuilder();
            sb.Append(" UPDATE abha_profileshare ab SET ab.IsActive=2,ab.IsConfirm=1 ");
            sb.Append(" WHERE ab.HealthId=@HealthId AND ab.EntryDate>=DATE_ADD(NOW(),INTERVAL -30 MINUTE) AND ab.IsActive=1 AND ab.IsConfirm=0  ");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                HealthId = ID
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

    public void SaveHIPAddCareContext(HIPSaveDataAddCareContext PatData, int IsLinked, int IsHIPinitiated = 1)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            foreach (var item in PatData.link.patient.careContexts)
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
                    ReferenceNumber = PatData.link.patient.referenceNumber,
                    Display = PatData.link.patient.display,
                    LedgertransactionNo_ReferenceNumber = item.referenceNumber,
                    DisplayCareContext = item.display,
                    RequestId_ResponceAgainest = "",
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


    public string CreateAddCareContextString(string AccessToken, string AbhaID)
    {
        DataTable Dt = new DataTable();

        StringBuilder ab = new StringBuilder();
        StringBuilder sb = new StringBuilder();


        ab.Append(" SELECT ar.Name ItemName,ltd.EntryDate,ltd.LedgerTransactionNo ReferenceNumber,lt.PatientID, ");
        ab.Append(" CONCAT(DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y'),'_Checkup')Display FROM abha_registration ar ");
        ab.Append(" INNER JOIN f_ledgertransaction lt ON lt.PatientID=ar.PatientId ");
        ab.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.TransactionID=lt.TransactionID ");
        ab.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=ltd.SubcategoryID ");
        ab.Append(" WHERE  ar.HealthId=@AbhaID AND ltd.LedgerTransactionNo NOT IN  (SELECT alc.LedgertransactionNo_ReferenceNumber FROM  abha_linkedcarecontext alc WHERE alc.ReferenceNumber=lt.PatientID and alc.IsLinked=1) ");
        ab.Append(" group by ltd.LedgerTransactionNo ");
      //  Dt = StockReports.GetDataTable(ab.ToString());
        ExcuteCMD excuteCMD = new ExcuteCMD();
        Dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
        {
            AbhaID = AbhaID
        });
        if (Dt.Rows.Count > 0)
        {
            sb.Append("  { ");
            sb.Append(" \"requestId\": \"" + Guid.NewGuid().ToString() + "\", ");
            sb.Append(" \"timestamp\": \"" + DateTime.UtcNow.ToString("o") + "\", ");
            // Link Data 
            sb.Append("  \"link\": { ");

            sb.Append(" \"accessToken\": \"" + AccessToken + "\", ");
            //Patient Data
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
            //Patient Data End
            sb.Append("  }, ");
            //Link Data End
            sb.Append(" } ");

        }


        return sb.ToString();
    }


    public void UpdateOnAddcontext(AddCareContextRes PatData, string Status, string XHIPID, int Delay = 0)
    {

        //if (Delay > 0)
        //    Thread.Sleep(Delay);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            int IsOnAuthResponce = 0;

            string AccessToken = "";
            string Code = "";
            string Message = "";
            if (PatData.acknowledgement != null)
            {
                if (PatData.acknowledgement.status == "SUCCESS")
                {
                    Status = PatData.acknowledgement.status;
                    IsOnAuthResponce = 1;
                }
                else
                {
                    Status = PatData.acknowledgement.status;
                    IsOnAuthResponce = 2;
                }

            }
            else
            {
                if (PatData.error != null)
                {
                    Code = PatData.error.code;
                    Message = PatData.error.message;
                }
                IsOnAuthResponce = 2;
            }


            StringBuilder sb = new StringBuilder();

            sb.Append(" UPDATE abha_linkedcarecontext acm SET acm.IsLinked=@IsLinked,acm.Code=@Code, ");
            sb.Append("  acm.Message=@Message,acm.SuccessStatus=@SuccessStatus,acm.RequestId_ResponceAgainest=@RequestId_ResponceAgainest ");
            sb.Append(" WHERE acm.RequestId=@RequestId  ");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {

                IsLinked = IsOnAuthResponce,
                SuccessStatus = Status,
                RequestId_ResponceAgainest = PatData.requestId,
                Code = Code,
                Message = Message,
                RequestId = PatData.resp.requestId,

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


    public void NotifyAfterAddCareContext(AddCareContextRes PatData, string Status, string XHIPID, int Delay = 0)
    {
        if (Delay > 0)
            Thread.Sleep(Delay);
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT a.HealthId,a.HealthIdNumber,al.ReferenceNumber,al.LedgertransactionNo_ReferenceNumber,al.EntryDate ");
        sb.Append(" FROM abha_linkedcarecontext al ");
        sb.Append(" INNER JOIN  abha_registration a ON al.ReferenceNumber=a.PatientId ");
        sb.Append(" WHERE al.RequestId=@RequestId AND al.IsLinked=1;");
       // DataTable dt = StockReports.GetDataTable(sb.ToString());
        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
        {
            RequestId = PatData.resp.requestId 
        });
        if (dt.Rows.Count > 0)
        {

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();
                using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
                {
                    ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

                    client.BaseAddress = new Uri(ABHABasicData.TokenBaseUrl);
                    client.DefaultRequestHeaders.Add("X-CM-ID", ABHABasicData.XCMID);
                    try
                    {

                        string urldat = "" + ABHABasicData.Getway + "v0.5/links/context/notify";
                        string pp = CreateNotifyAfterAddCareContext(dt.Rows[i]["HealthId"].ToString(), dt.Rows[i]["ReferenceNumber"].ToString(), dt.Rows[i]["LedgertransactionNo_ReferenceNumber"].ToString(), dt.Rows[i]["EntryDate"].ToString(), XHIPID);
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



    }


    public string CreateNotifyAfterAddCareContext(string HealthId, string PatientId, string CarecontextID, string date, string XHIPID)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append("    { ");
        sb.Append("  \"requestId\": \"" + Guid.NewGuid().ToString() + "\", ");
        sb.Append(" \"timestamp\": \"" + DateTime.UtcNow.ToString("o") + "\", ");
        sb.Append("  \"notification\": { ");
        sb.Append(" \"patient\": { ");
        sb.Append(" \"id\": \"" + HealthId + "\" ");
        sb.Append(" }, ");
        sb.Append(" \"careContext\": { ");
        sb.Append("    \"patientReference\": \"" + PatientId + "\", ");
        sb.Append(" \"careContextReference\": \"" + CarecontextID + "\" ");
        sb.Append("  }, ");
        sb.Append("  \"hiTypes\": [ ");
        sb.Append("   \"OPConsultation\" ");
        sb.Append("  ], ");
        sb.Append("  \"date\": \"" + Util.GetDateTime(date).ToString("o") + "\", ");
        sb.Append(" \"hip\": { ");
        sb.Append("    \"id\": \"" + XHIPID + "\" ");
        sb.Append("   } ");
        sb.Append(" } ");
        return sb.ToString();
    }

}
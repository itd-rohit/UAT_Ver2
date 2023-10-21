<%@ WebService Language="C#" Class="ABHAM2Service" %>
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
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ABHAM2Service : System.Web.Services.WebService
{
    ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetAccessToken()
    {
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();

        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = tokenResponse.AccessToken });

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string RegisterCallbackUrl(string URL)
    {
        bool b = MT.SaveRequestCount(17);
        int ReqCount = MT.GetIPCount(17);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Too Many Request Try After Some Time." } }, message = "Too Many Request." });
        }

        if (MT.IsInjectedString(URL))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, details = new { message = AllGlobalFunction.errorMessage } }, message = "" });
        }
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();


        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.TokenBaseUrl);

            try
            {

                string urldat = "devservice/v1/bridges";
                var data = new { url = URL };
                //   System.Net.Http.HttpContent requestContent = new System.Net.Http.StringContent("{url:" + URL + "}",Encoding.UTF8,);
                System.Net.Http.HttpContent requestContent = new StringContent("{\"url\":\"" + URL + "\"}",
                                    Encoding.UTF8,
                                    "application/json");//CONTENT-TYPE header

                var method = "PATCH";
                var httpVerb = new HttpMethod(method);
                var httpRequestMessage =
                    new HttpRequestMessage(httpVerb, urldat)
                    {
                        Content = requestContent
                    };


                System.Net.Http.HttpResponseMessage responseMessage = client.SendAsync(httpRequestMessage).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                if (responseMessage.IsSuccessStatusCode)
                {

                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, message = "" });

                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, message = "" });

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, details = new { message = AllGlobalFunction.errorMessage } }, message = ex.Message });

            }


        }


    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string AddAndUpdateServices(string ID, string Name, string Type, string Alias, string Status)
    {
        bool b = MT.SaveRequestCount(18);
        int ReqCount = MT.GetIPCount(18);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Too Many Request Try After Some Time." } }, message = "Too Many Request." });
        }
        
        if (MT.IsInjectedString(ID) || MT.IsInjectedString(Name) || MT.IsInjectedString(Type) || MT.IsInjectedString(Alias) || MT.IsInjectedString(Status))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Please Enter Valid Data." } }, message = "Too Many Request." });
        }
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();


        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.TokenBaseUrl);

            try
            {

                string urldat = "devservice/v1/bridges/addUpdateServices";
                var data = new { id = ID, name = Name, type = Type, active = Util.GetBoolean(Status), alias = Alias.Split(',') };

                System.Net.Http.HttpResponseMessage responseMessage = client.PutAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                if (responseMessage.IsSuccessStatusCode)
                {
                    SaveRegisterdFaility(ID, Name, Type, Alias, Status);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, message = "" });

                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, message = "" });

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, details = new { message = AllGlobalFunction.errorMessage } }, message = ex.Message });

            }


        }




    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetServices()
    {

        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();


        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.TokenBaseUrl);

            try
            {

                string urldat = "devservice/v1/bridges/getServices";

                System.Net.Http.HttpResponseMessage responseMessage = client.GetAsync(urldat).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                if (responseMessage.IsSuccessStatusCode)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, message = "" });

                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, message = "" });

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, details = new { message = AllGlobalFunction.errorMessage } }, message = ex.Message });

            }


        }




    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string FetchAuthMode(string HealthId, string Purpose, string RequesterID, string Type)
    {

        bool b = MT.SaveRequestCount(18);
        int ReqCount = MT.GetIPCount(18);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Too Many Request Try After Some Time." } }, message = "Too Many Request." });
        }
        if (MT.IsInjectedString(HealthId) || MT.IsInjectedString(Purpose) || MT.IsInjectedString(RequesterID) || MT.IsInjectedString(Type))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = "Invalid Request", }, message = "" });
        }
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();


        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.ABDM_Point_URL);
            client.DefaultRequestHeaders.Add("X-CM-ID", ABHABasicData.XCMID);
            try
            {
                string ReqID = Guid.NewGuid().ToString();
                string TimStamp = DateTime.UtcNow.ToString("o");

                string urldat = "gateway/v0.5/users/auth/fetch-modes";
                var data = new
                {
                    requestId = ReqID,
                    timestamp = TimStamp,
                    query = new
                    {
                        id = HealthId,
                        purpose = Purpose,
                        requester = new { type = Type, id = RequesterID }
                    }
                };

                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                if (responseMessage.IsSuccessStatusCode)
                {
                    bool IsSaved = StartTransaction(ReqID, TimStamp, HealthId, Purpose, Type, RequesterID);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, ReqID = ReqID, message = "status_code" });

                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, ReqID = "", message = "" });

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, error = new { message = AllGlobalFunction.errorMessage } }, message = ex.Message });

            }


        }




    }


    public bool StartTransaction(string RequestId, string ReuestedDateime, string HealthId, string Purpose, string Type, string RequsterID)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" insert into Abha_FetchAuth ");
            sb.Append("(RequestId,ReuestedDateime,HealthId,Purpose,Type,");
            sb.Append(" RequsterID,EntryBy,EntryDate ) ");
            sb.Append(" values ");
            sb.Append("( @RequestId,@ReuestedDateime,@HealthId,@Purpose,@Type,");
            sb.Append(" @RequsterID,@EntryBy,now()) ");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                RequestId = RequestId,
                ReuestedDateime = Util.GetDateTime(ReuestedDateime).ToString("yyyy-MM-dd HH:mm:ss"),
                HealthId = HealthId,
                Purpose = Purpose,
                Type = Type,
                RequsterID = RequsterID,
                EntryBy = HttpContext.Current.Session["ID"].ToString(),

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




    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetOnFetchAuthModeResponce(string HealthId, string RequesterID, string ReqId)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();

        if (MT.IsInjectedString(HealthId) || MT.IsInjectedString(RequesterID) || MT.IsInjectedString(ReqId))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "" });
        }

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM Abha_FetchAuth  ab WHERE ab.RequestId=@ReqId ");
        sb.Append(" AND ab.HealthId=@HealthId AND ab.RequsterID=@RequesterID AND ab.IsOnAuthResponce<>0 ORDER BY ab.Id DESC LIMIT 1 ");

        DataTable dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
        {
            ReqId = ReqId,
            HealthId = HealthId,
            RequesterID = RequesterID,
        });
        if (dt != null && dt.Rows.Count > 0)
        {
            if (Util.GetInt(dt.Rows[0]["IsOnAuthResponce"].ToString()) == 1)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, IsOnAuthResponce = true, response = dt, message = "Success" });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, IsOnAuthResponce = false, response = "", message = dt.Rows[0]["Message"].ToString() });

            }

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", message = "" });

        }

    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string HIPInitiation(string HealthId, string Purpose, string RequesterID, string Type, string AuthMode)
    {

        if (MT.IsInjectedString(HealthId) || MT.IsInjectedString(RequesterID) || MT.IsInjectedString(Purpose) || MT.IsInjectedString(Type) || MT.IsInjectedString(AuthMode))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "" });
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

                string urldat = "" + ABHABasicData.Getway + "v0.5/users/auth/init";
                var data = new
                {
                    requestId = ReqID,
                    timestamp = TimStamp,
                    query = new
                    {
                        id = HealthId,
                        purpose = Purpose,
                        authMode = AuthMode,
                        requester = new { type = Type, id = RequesterID }
                    }
                };

                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                if (responseMessage.IsSuccessStatusCode)
                {
                    bool IsSaved = StartHipInitTransaction(ReqID, TimStamp, HealthId, Purpose, Type, RequesterID, AuthMode);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, ReqID = ReqID, message = "status_code" });

                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, ReqID = "", message = "" });

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, error = new { message = AllGlobalFunction.errorMessage } }, message = ex.Message });

            }


        }



    }

    public bool StartHipInitTransaction(string RequestId, string ReuestedDateime, string HealthId, string Purpose, string Type, string RequsterID, string AuthMode)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" insert into abha_hipinit ");
            sb.Append("(RequestId,ReuestedDateime,HealthId,Purpose,Type,");
            sb.Append(" RequsterID,EntryBy,EntryDate,AuthMode ) ");
            sb.Append(" values ");
            sb.Append("( @RequestId,@ReuestedDateime,@HealthId,@Purpose,@Type,");
            sb.Append(" @RequsterID,@EntryBy,now(),@AuthMode) ");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                RequestId = RequestId,
                ReuestedDateime = Util.GetDateTime(ReuestedDateime).ToString("yyyy-MM-dd HH:mm:ss"),
                HealthId = HealthId,
                Purpose = Purpose,
                Type = Type,
                RequsterID = RequsterID,
                EntryBy = HttpContext.Current.Session["ID"].ToString(),
                AuthMode = AuthMode
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


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetOnInitResponce(string HealthId, string RequesterID, string ReqId)
    {
        if (MT.IsInjectedString(HealthId) || MT.IsInjectedString(RequesterID) || MT.IsInjectedString(ReqId))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "" });
        }
        ExcuteCMD excuteCMD = new ExcuteCMD();

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM abha_hipinit  ab WHERE ab.RequestId=@ReqId");
        sb.Append(" AND ab.HealthId=@HealthId AND ab.RequsterID=@RequesterID AND ab.IsOnInit<>0 ORDER BY ab.Id DESC LIMIT 1 ");

        DataTable dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
        {
            ReqId = ReqId,
            HealthId = HealthId,
            RequesterID = RequesterID,
        });
        if (dt != null && dt.Rows.Count > 0)
        {
            if (Util.GetInt(dt.Rows[0]["IsOnInit"].ToString()) == 1)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, IsOnAuthResponce = true, response = dt, message = "Success" });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, IsOnAuthResponce = false, response = "", message = dt.Rows[0]["Message"].ToString() });

            }

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", message = "" });

        }

    }






    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string HIPConfirmAuth(string TransactionId, string AuthMethod, string HealthId, string OTP, string Name, string Gender, string DOB, string MobileNo)
    {

        if (MT.IsInjectedString(TransactionId) || MT.IsInjectedString(AuthMethod)
            || MT.IsInjectedString(HealthId)
            || MT.IsInjectedString(OTP)
            || MT.IsInjectedString(Name)
            || MT.IsInjectedString(Gender)
            || MT.IsInjectedString(DOB)
             || MT.IsInjectedString(MobileNo)

            )
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "" });
        }


        if (AuthMethod != "DEMOGRAPHICS")
        {
            if (string.IsNullOrEmpty(OTP))
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = "Enter OTP Send to rgistered mobile.", error = new { message = "Enter OTP Send to rgistered mobile." } }, message = "" });

            }

        }
        else
        {
            if (string.IsNullOrEmpty(Name))
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = "Enter Name of Patient.", error = new { message = AllGlobalFunction.errorMessage } }, message = "" });

            }
            if (string.IsNullOrEmpty(Gender))
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = "Select Gender of Patient.", error = new { message = AllGlobalFunction.errorMessage } }, message = "" });

            }

            if (string.IsNullOrEmpty(DOB))
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = "Enter DOB of Patient.", error = new { message = AllGlobalFunction.errorMessage } }, message = "" });

            }

            if (string.IsNullOrEmpty(MobileNo))
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = "Enter Mobile No.", error = new { message = AllGlobalFunction.errorMessage } }, message = "" });

            }
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

                string urldat = "" + ABHABasicData.Getway + "v0.5/users/auth/confirm";
                HttpResponseMessage responseMessage = new HttpResponseMessage();
                if (AuthMethod == "DEMOGRAPHICS")
                {
                    var data = new
                      {
                          requestId = ReqID,
                          timestamp = TimStamp,
                          transactionId = TransactionId,
                          credential = new
                          {
                              demographic = new
                              {
                                  name = Name,
                                  gender = Gender,
                                  dateOfBirth = Util.GetDateTime(DOB).ToString("yyyy-MM-dd"),
                                  identifier = new
                                  {
                                      type = "MOBILE",
                                      value = MobileNo
                                  }
                              }
                          }
                      };

                    responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();

                }
                else
                {
                    var data = new
                    {
                        requestId = ReqID,
                        timestamp = TimStamp,
                        transactionId = TransactionId,
                        credential = new
                        {
                            authCode = OTP,

                        }
                    };

                    responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();

                }
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                if (responseMessage.IsSuccessStatusCode)
                {
                    bool IsSaved = StartHipCofirmTransaction(ReqID, TimStamp, HealthId, TransactionId, Name, DOB, Gender);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, ReqID = ReqID, message = "status_code" });

                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, ReqID = "", message = "" });

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, error = new { message = AllGlobalFunction.errorMessage } }, message = ex.Message });

            }


        }

    }

    public bool StartHipCofirmTransaction(string RequestId, string ReuestedDateime, string HealthId, string TransactionID, string Name, string DOB, string Gender)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" insert into abha_hipconfirmauth ");
            sb.Append("(RequestID,RequestedDateTime,TransationID,AbhaID,IsActive,Name,Gender,DOB )");
            sb.Append(" values ");
            sb.Append("(@RequestID,@RequestedDateTime,@TransationID,@AbhaID,1,@Name,@Gender,@DOB  )");

            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                RequestId = RequestId,
                RequestedDateTime = Util.GetDateTime(ReuestedDateime).ToString("yyyy-MM-dd HH:mm:ss"),
                TransationID = TransactionID,
                AbhaID = HealthId,
                Name = Name,
                Gender = Gender,
                DOB = Util.GetDateTime(DOB).ToString("yyyy-MM-dd")
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




    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetOnConfirmResponce(string HealthId, string TransactionID, string ReqId)
    {


        if (MT.IsInjectedString(TransactionID) || MT.IsInjectedString(ReqId)
            || MT.IsInjectedString(HealthId))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "" });
        }



        ExcuteCMD excuteCMD = new ExcuteCMD();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM abha_hipconfirmauth  ab WHERE ab.RequestId=@ReqId ");
        sb.Append(" AND ab.AbhaID=@HealthId AND ab.TransationID=@TransactionID AND ab.IsConfirm<>0 ORDER BY ab.Id DESC LIMIT 1 ");

        DataTable dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
        {
            ReqId = ReqId,
            HealthId = HealthId,
            TransactionID = TransactionID,
        });
        if (dt != null && dt.Rows.Count > 0)
        {
            if (Util.GetInt(dt.Rows[0]["IsConfirm"].ToString()) == 1)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, IsOnAuthResponce = true, response = dt, message = "Success" });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, IsOnAuthResponce = false, response = "", message = dt.Rows[0]["Message"].ToString() });

            }

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", message = "" });

        }

    }



    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string HIPAddCareContext(string HealthId, string AccessToken)
    {
        if (MT.IsInjectedString(HealthId) || MT.IsInjectedString(AccessToken)
           )
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "" });
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
                string urldat = "" + ABHABasicData.Getway + "v0.5/links/link/add-contexts";
                ABHAHIPInitiatedCareContextLinking HIP = new ABHAHIPInitiatedCareContextLinking();

                string pp = HIP.CreateAddCareContextString(AccessToken, HealthId);
                HIPSaveDataAddCareContext FetchDat = JsonConvert.DeserializeObject<HIPSaveDataAddCareContext>(pp);
                HIP.SaveHIPAddCareContext(FetchDat, 0, 1);
                //string payload = System.IO.File.ReadAllText(pp);
                JObject reqObj = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, reqObj).GetAwaiter().GetResult();

                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                if (responseMessage.IsSuccessStatusCode)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, ReqID = FetchDat.requestId, message = "status_code" });

                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, ReqID = "", message = "" });

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, error = new { message = AllGlobalFunction.errorMessage } }, message = ex.Message });

            }


        }



    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetOnAddCareContext(string ReqId)
    {
        if (MT.IsInjectedString(ReqId))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "" });
        }

        ExcuteCMD excuteCMD = new ExcuteCMD();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM abha_linkedcarecontext  ab WHERE ab.RequestId=@ReqId' ");
        sb.Append(" AND  ab.IsLinked<>0 And ab.LinkThroughHIPInitiated=1 ORDER BY ab.Id DESC LIMIT 1 ");

        DataTable dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
        {
            ReqId = ReqId,
        });
        if (dt != null && dt.Rows.Count > 0)
        {
            if (Util.GetInt(dt.Rows[0]["IsLinked"].ToString()) == 1)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, IsOnAuthResponce = true, response = dt, message = "Success" });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, IsOnAuthResponce = false, response = "", message = dt.Rows[0]["Message"].ToString() });

            }

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", message = "" });

        }

    }



    public bool SaveRegisterdFaility(string ID, string Name, string Type, string Alias, string Status)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" insert into Abha_RegisterdFacility ");
            sb.Append("(Name,UserName,Type,Alias,Active ,EntryBy )");
            sb.Append(" values ");
            sb.Append("( @Name,@UserName,@Type,@Alias,@Active ,@EntryBy )");

            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                Name = Name,
                UserName = ID,
                Type = Type,
                Alias = Alias,
                Active = Util.getbooleanInt(Util.GetBoolean(Status)),
                EntryBy = HttpContext.Current.Session["ID"].ToString(),

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


    [WebMethod(EnableSession = true)]
    public string SearchSharedProfileData()
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();

            sbnew.Append("  SELECT HIPID XHIPID,'DEMOGRAPHICS' AuthMode,'KYC_AND_LINK' Purpose,SUBSTRING_INDEX(SUBSTRING_INDEX(ab.Identifire,'#',1),'_',-1)Mobile,ab.Name,ab.Id,ab.HealthId,ab.HealthIdNumber,ab.Gender,DATE_FORMAT(ab.DOB,'%d-%b-%Y')DOB, ");
            sbnew.Append(" DATE_FORMAT(ab.EntryDate,'%d-%b-%Y')EntryDate,DATE_FORMAT(DATE_ADD(ab.EntryDate,INTERVAL 30 MINUTE),'%d-%b-%Y')ExpiryDate ");
            sbnew.Append(" FROM abha_profileshare ab  ");
            sbnew.Append(" WHERE  ab.EntryDate>=DATE_ADD(NOW(),INTERVAL -30 MINUTE) ");
            sbnew.Append("AND ab.IsActive=1 AND ab.IsConfirm=0 ");

            DataTable dt = StockReports.GetDataTable(sbnew.ToString());
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = true,
                    data = dt
                });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = false,
                    data = "No data found."
                });
            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });

        }
    }



    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SendSMSNotification(string MobileNo, string RequesterID)
    {
        if (MT.IsInjectedString(MobileNo) || MT.IsInjectedString(RequesterID))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "Too Many Request." });
        }
        bool b = MT.SaveRequestCount(2);
        int ReqCount = MT.GetIPCount(2);
        int MobileCount = MT.GetAbhaSendSmsCount(MobileNo, RequesterID);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed || MobileCount > ABHABasicData.MaxSMSRequestCountAllowed)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Too Many Request Found,Try After Some Time." } }, message = "Too Many Request." });
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
                string query = "SELECT s.Name FROM abha_registerdfacility s WHERE s.Type='HIP' AND s.UserName=@RequesterID";
                ExcuteCMD excuteCMD = new ExcuteCMD();
                string HipName = excuteCMD.ExecuteScalar(query, new
                {
                    RequesterID = RequesterID
                });
                string urldat = "" + ABHABasicData.Getway + "v0.5/patients/sms/notify2";
                var data = new
                {
                    requestId = ReqID,
                    timestamp = TimStamp,
                    notification = new
                    {
                        phoneNo = MobileNo,
                        hip = new { name = HipName, id = RequesterID }
                    }
                };


                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                if (responseMessage.IsSuccessStatusCode)
                {
                    bool IsSaved = SaveSendSmsData(ReqID, MobileNo, HipName, RequesterID);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, ReqID = ReqID, message = "status_code" });

                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, ReqID = "", message = "" });

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                //  return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage }, message = ex.Message });
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = AllGlobalFunction.errorMessage } }, message = ex.Message });

            }


        }

    }

    public bool SaveSendSmsData(string RequestID, string MobileNo, string HipName, string HipId)
    {


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" insert into abha_sendmobilesms ");
            sb.Append("(RequestID,MobileNo,TimeStamp,HipName,HipId,EntryBy )");
            sb.Append(" values ");
            sb.Append("( @RequestID,@MobileNo,now(),@HipName,@HipId,@EntryBy )");

            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                RequestID = RequestID,
                MobileNo = MobileNo,
                HipName = HipName,
                HipId = HipId,
                EntryBy = HttpContext.Current.Session["ID"].ToString(),

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

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetOnSMSResponce(string MobileNo, string RequesterID, string ReqId)
    {
        if (MT.IsInjectedString(MobileNo) || MT.IsInjectedString(RequesterID) || MT.IsInjectedString(ReqId))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Please Enter Valid Data." } }, message = "Too Many Request." });
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM abha_sendmobilesms  ab WHERE ab.RequestID=@ReqId ");
        sb.Append(" AND ab.MobileNo=@MobileNo AND ab.HipId=@RequesterID AND ab.IsSend<>0 ORDER BY ab.Id DESC LIMIT 1 ");
        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
        {
            MobileNo = MobileNo,
            RequesterID = RequesterID,
            ReqId = ReqId,
        });
        if (dt != null && dt.Rows.Count > 0)
        {
            if (Util.GetInt(dt.Rows[0]["IsSend"].ToString()) == 1)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, IsOnAuthResponce = true, response = dt, message = "Success" });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, IsOnAuthResponce = false, response = "", message = dt.Rows[0]["ErrorMessage"].ToString() });

            }

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", message = "" });

        }

    }


}
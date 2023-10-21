<%@ WebService Language="C#" Class="ABHAM3Services" %>
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
using System.Threading;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]

public class ABHAM3Services : System.Web.Services.WebService
{

    AbhaHIUAutoResponce Ar = new AbhaHIUAutoResponce();
    ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SearchByHealthId(string AbhaId)
    {
         MT.SaveRequestCount(4);
        int ReqCount = MT.GetIPCount(4);

        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Too Many Request Found,Try After Some Time." } }, message = "Too Many Request." });
        }
        if (MT.IsInjectedString(AbhaId))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "Too Many Request." });
        }
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();


        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.BaseUrl);
            try
            {
                string urldat = "v1/search/searchByHealthId";
                var data = new { healthId = AbhaId };

                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                if (responseMessage.IsSuccessStatusCode)
                {
                    AbhaPatientSearch FetchDat = JsonConvert.DeserializeObject<AbhaPatientSearch>(recivedata);

                HttpContext.Current.Session["ABHAPatientName"] = FetchDat.name;
                HttpContext.Current.Session["ABHAAddressNumber"] = FetchDat.healthIdNumber;
                HttpContext.Current.Session["ABHAAddressId"] = FetchDat.healthId;

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
    public string ConsentInitialization(string PurposeText, string PurposeVal, string HealthID, string HiType, string FromDate, string ToDate, string ConsentExpiry, string PatientName)
    {

        if (!MT.IsValidValueForPurpose(PurposeText, 1) || !MT.IsValidValueForPurpose(PurposeVal, 0) || MT.IsInjectedString(PurposeText)
            || MT.IsInjectedString(PurposeVal)
               || MT.IsInjectedString(HealthID)
              || MT.IsInjectedString(HiType)
              || MT.IsInjectedString(FromDate)
              || MT.IsInjectedString(ToDate)
              || MT.IsInjectedString(ConsentExpiry)
              || MT.IsInjectedString(PatientName)
            )
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "Too Many Request." });
        } 
        string ReqID = Guid.NewGuid().ToString();
        string TimeStamp = DateTime.UtcNow.ToString("o");

         MT.SaveRequestCount(3);
        int ReqCount = MT.GetIPCount(3);
         
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed )
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage }, message = ""});

            //return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Too Many Request Found,Try After Some Time." } }, message = "Too Many Request." });
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
                string s = HttpContext.Current.Session["ABHAAddressId"].ToString();
                //Session["ABHAPatientName"];
                //Session["ABHAAddressNumber"] = FetchDat.healthIdNumber;
                //Session["ABHAAddressId"] = FetchDat.healthIdNumber;

                if (HttpContext.Current.Session["ABHAAddressId"] == null || HttpContext.Current.Session["ABHAAddressId"].ToString() != HealthID)
                {
                     return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage }, message =""  });
                     
                }

                if (HttpContext.Current.Session["ABHAPatientName"] == null)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = "Refresh the page and try again." }, message = "" });
                     
                }
                
                string urldat = "" + ABHABasicData.Getway + "v0.5/consent-requests/init";
                string pp = Ar.CreateRequestString(ReqID, TimeStamp, PurposeText,
           PurposeVal, HealthID, ABHABasicData.DefultHIU,
            HttpContext.Current.Session["LoginName"].ToString(), "REGNO", "MH1001", "https://www.mciindia.org",
         "VIEW", HiType, FromDate, ToDate,
           ConsentExpiry, HttpContext.Current.Session["ABHAPatientName"].ToString());

                JObject reqObj = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, reqObj).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

               // System.IO.File.WriteAllText(@"E:\Consentinit.txt", pp.ToString());
 
                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                if (responseMessage.IsSuccessStatusCode)
                {

                    bool b = Ar.SaveConsentRequest(ReqID, TimeStamp, PurposeText,
           PurposeVal, HealthID, "hospedia",
           HttpContext.Current.Session["LoginName"].ToString(), "REGNO", "MH1001", "https://www.mciindia.org",
         "VIEW", HiType, FromDate, ToDate,
           ConsentExpiry, HttpContext.Current.Session["ABHAPatientName"].ToString());
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
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage }, message = ex.Message });

            }


        }




    }

    [WebMethod(EnableSession = true)]
    public string GetDataToFill(string FromDate, string ToDate, string HealthID)
    {
        if (MT.IsInjectedString(FromDate)
            || MT.IsInjectedString(ToDate)
            || MT.IsInjectedString(HealthID) 
            )
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new
            {
                status = false,
                data = "Input valid data."
            });
        }

        try
        {
            //sbnew.Append("IFNULL(acn.Status,'Requested') Status,DATE_FORMAT(ac.PerFromDate,'%d-%b-%Y %I:%i %p')PerFromDate,ac.PerToDate,group_concat(ConArtifectID)ConArtifectID ");
            StringBuilder sbnew = new StringBuilder();
            sbnew.Append(" SELECT ac.PatientID,ac.PatientName, ");
            sbnew.Append(" DATE_FORMAT(ac.ConGrantedDate,'%d-%b-%Y %I:%i %p')ConGrantedDate, ");
           sbnew.Append(" DATE_FORMAT(ac.RequestedDate,'%d-%b-%Y %I:%i %p')RequestedDate, ");
            sbnew.Append("ac.ConRequestId,ac.ConsentId, ");
           sbnew.Append("DATE_FORMAT(ac.PermissionDataEraseAt,'%d-%b-%Y %I:%i %p')PermissionDataEraseAt, ");
           sbnew.Append("IFNULL(acn.Status,'Requested') Status,DATE_FORMAT(ac.PerFromDate,'%d-%b-%Y %I:%i %p')PerFromDate,DATE_FORMAT(ac.PerToDate,'%d-%b-%Y %I:%i %p')PerToDate,group_concat(ConArtifectID)ConArtifectID ");
            sbnew.Append("FROM abha_consentInit ac  ");
            sbnew.Append("LEFT JOIN abha_consentinit_notify acn ON acn.ConsentID=ac.ConsentId ");

            sbnew.Append("WHERE ac.RequestedDate>=@RequestedDate AND ac.RequestedDate<=@RequestedToDate ");
            sbnew.Append(" And Date(PermissionDataEraseAt)>Date(Now()) ");
            
            if (!string.IsNullOrEmpty(HealthID))
            {
                sbnew.Append("  AND ac.PatientID=@HealthId "); 

            }
            sbnew.Append("Group BY  ac.ConsentId");

            sbnew.Append(" ORDER BY ac.id DESC  ");

            ExcuteCMD excuteCMD = new ExcuteCMD();
            DataTable dt = excuteCMD.GetDataTable(sbnew.ToString(), CommandType.Text, new
            {
                RequestedDate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd 00:00:00"),
                RequestedToDate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd 23:59:59"),
                HealthId = HealthID,                
            });
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
    public string RequestData(string ConsentId, string FromDate, string ToDate)
    {
        if (MT.IsInjectedString(ConsentId)
            || MT.IsInjectedString(FromDate)
            || MT.IsInjectedString(ToDate)
            )
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "Too Many Request." });
        }
        string[] ConsentIDArray = ConsentId.Split(',');
        object Seralizedata = new object();
        int SuccessCount = 0;
        int count = 0;
        int Delay = ABHABasicData.MinDelay;
        foreach (string item in ConsentIDArray)
        {
            if (count > 0)
            {
                Thread.Sleep(Delay);
            }
            count = count + 1;

            string ReqID = Guid.NewGuid().ToString();
            string TimeStamp = DateTime.UtcNow.ToString("o");

            // string recivedata = "";
            ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();

            using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
            {
                ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

                client.BaseAddress = new Uri(ABHABasicData.TokenBaseUrl);
                client.DefaultRequestHeaders.Add("X-CM-ID", ABHABasicData.XCMID);
                try
                {
                    string urldat = "" + ABHABasicData.Getway + "v0.5/health-information/cm/request";
                    string pp = Ar.CreateDatarequestFromHIPString(FromDate, ToDate, item);

                    JObject reqObj = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                    System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, reqObj).GetAwaiter().GetResult();
                    string status_code = responseMessage.StatusCode.ToString();

                    System.IO.File.WriteAllText(@"E:\RequestData.txt", pp.ToString());
 
                    string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                    Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                    if (responseMessage.IsSuccessStatusCode)
                    {
                        SuccessCount = SuccessCount + 1;
                    }
                    else
                    {

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

        if (SuccessCount > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, message = "" });

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, message = "" });

        }


    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string FetchArtefact(string ConsentId)
    {
        if (MT.IsInjectedString(ConsentId) 
            )
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "Too Many Request." });
        }

        string[] ConsentIDArray = ConsentId.Split(',');
        object Seralizedata = new object();
        int SuccessCount = 0;
        int count = 0;
        int Delay = ABHABasicData.MinDelay;
        foreach (string item in ConsentIDArray)
        {
            if (count > 0)
            {
                Thread.Sleep(Delay);
            }
            count = count + 1;

            string ReqID = Guid.NewGuid().ToString();
            string TimeStamp = DateTime.UtcNow.ToString("o");

            // string recivedata = "";
            ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();

            using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
            {
                ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

                client.BaseAddress = new Uri(ABHABasicData.TokenBaseUrl);
                client.DefaultRequestHeaders.Add("X-CM-ID", ABHABasicData.XCMID);
                try
                {
                    string urldat = "" + ABHABasicData.Getway + "v0.5/consents/fetch";
                    string pp = Ar.CreateFetchArtefactString(item, ReqID, TimeStamp);

                    JObject reqObj = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                    System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, reqObj).GetAwaiter().GetResult();
                    string status_code = responseMessage.StatusCode.ToString();

                    System.IO.File.WriteAllText(@"E:\FetchArtifect.txt", pp.ToString());
 
                    string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                    Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                    if (responseMessage.IsSuccessStatusCode)
                    {
                        SuccessCount = SuccessCount + 1;
                    }
                    else
                    {

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
        if (SuccessCount > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, message = "" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, message = "" });

        }


    }


    [WebMethod(EnableSession = true)]
    public string ViewData()
    {
         
        // string[] Conarray = ConsentId.Split(',');
        string[] Conarray = HttpContext.Current.Session["ConsentID"].ToString().Split(',');

        string NewConsentID = "";
        int Count = 0;
        foreach (string item in Conarray)
        {
            if (Count == 0)
            {
                NewConsentID = "'" + item + "'";
            }
            else
            {
                NewConsentID = NewConsentID + ",'" + item + "'";
            }
            Count = Count + 1;
        }

        DataTable dt = new DataTable();

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT adr.ContentDecrypted FROM abha_datarequesttohip ab  ");
        sb.Append(" INNER JOIN abha_datarequestresfromhip adr ON adr.TransactionId=ab.TransactionId  ");
        sb.Append(" WHERE ab.ConsentId in (" + NewConsentID + ")");
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt.Rows[0]["ContentDecrypted"].ToString(), message = "" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", message = "" });

        }
    }
    [WebMethod(EnableSession = true)]
    public string SetSession(string SessionName, string SessionVal)
    {
        if (MT.IsInjectedString(SessionVal) || MT.IsInjectedString(SessionName))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Invalid Request" });
        }

        Session[SessionName] = SessionVal;
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "../ABHA/AbhaPDFView.aspx" });

    }
    [WebMethod(EnableSession = true)]
    public string ConvertDateTime(string Date)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Util.GetDateTime(Date).ToString("dd-MMM-yyyy hh:mm t") });

    }
}
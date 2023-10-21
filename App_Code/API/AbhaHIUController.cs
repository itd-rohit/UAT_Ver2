using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

public class AbhaHIUController : ApiController
{
    AbhaHIUAutoResponce DTRAHIP = new AbhaHIUAutoResponce();

    [Route("v0.5/consent-requests/on-init")]
    [HttpPost]
    [ActionName("ConsentRequestOnInit")]
    public HttpResponseMessage ConsentRequestOnInit()
    {

        HttpError err = new HttpError();

        var rawMessage = Request.Content.ReadAsStringAsync();
        string status_code = rawMessage.Status.ToString();
        AbhaHIUOnInintResModel FetchDat = JsonConvert.DeserializeObject<AbhaHIUOnInintResModel>(rawMessage.Result);

        try
        {
            err.Add("status", true);
            err.Add("message", "Success");
            return Request.CreateErrorResponse(HttpStatusCode.Accepted, err);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("status", false);
            err.Add("message", "No Record Found");
            err.Add("data", "");
            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
        }
        finally
        {
            Task.Factory.StartNew(() => DTRAHIP.UpdateOnRequest(FetchDat, ABHABasicData.MinDelay));
        }
    }

    [Route("v0.5/consents/hiu/notify")]
    [HttpPost]
    [ActionName("ConsentRequestNotify")]
    public HttpResponseMessage ConsentRequestNotify()
    {

        HttpError err = new HttpError();
        var rawMessage = Request.Content.ReadAsStringAsync();

        string status_code = rawMessage.Status.ToString();
        AbhaHIUNotifyResModel FetchDat = JsonConvert.DeserializeObject<AbhaHIUNotifyResModel>(rawMessage.Result);

        try
        {
            err.Add("status", true);
            err.Add("message", "Success");
            return Request.CreateErrorResponse(HttpStatusCode.Accepted, err);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("status", false);
            err.Add("message", "No Record Found");
            err.Add("data", "");
            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
        }
        finally
        {
            Task.Factory.StartNew(() => DTRAHIP.OnNotifyCall(FetchDat, ABHABasicData.Delay));
        }
    }

    [Route("v0.5/consents/on-fetch")]
    [HttpPost]
    [ActionName("Consentonfetch")]
    public HttpResponseMessage Consentonfetch()
    {

        HttpError err = new HttpError();
        try
        {
            var rawMessage = Request.Content.ReadAsStringAsync();

            string status_code = rawMessage.Status.ToString();
            RequestRes FetchDat = JsonConvert.DeserializeObject<RequestRes>(rawMessage.Result);
            AbhaHIUNotifyResModel DTRAHIP = new AbhaHIUNotifyResModel();

            // DTRAHIP.OnRequestCall(FetchDat);

            err.Add("status", true);
            err.Add("message", "Success");
            return Request.CreateErrorResponse(HttpStatusCode.Accepted, err);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("status", false);
            err.Add("message", "No Record Found");
            err.Add("data", "");
            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
        }
        finally
        {

        }
    }

    [Route("v0.5/health-information/hiu/on-request")]
    [HttpPost]
    [ActionName("Consentonrequest")]
    public HttpResponseMessage Consentonrequest()
    {

        HttpError err = new HttpError();
        try
        {
            var rawMessage = Request.Content.ReadAsStringAsync();

            string status_code = rawMessage.Status.ToString();
            AbhaOnRequestResponceHIU FetchDat = JsonConvert.DeserializeObject<AbhaOnRequestResponceHIU>(rawMessage.Result);


            DTRAHIP.UpdateAbhaOnRequest(FetchDat);

            err.Add("status", true);
            err.Add("message", "Success");
            return Request.CreateErrorResponse(HttpStatusCode.Accepted, err);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("status", false);
            err.Add("message", "No Record Found");
            err.Add("data", "");
            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
        }
        finally
        {

        }
    }

    [Route("hiu/data-push/pushdataonrequest")]
    [HttpPost]
    [ActionName("PushDataHere")]
    public HttpResponseMessage PushDataHere()
    {

        HttpError err = new HttpError();
        var rawMessage = Request.Content.ReadAsStringAsync();

        string status_code = rawMessage.Status.ToString();
        AbhaDataRes FetchDat = JsonConvert.DeserializeObject<AbhaDataRes>(rawMessage.Result);

        // DTRAHIP.SavePullData(FetchDat);

        try
        {

            err.Add("status", true);
            err.Add("message", "Success");
            return Request.CreateErrorResponse(HttpStatusCode.Accepted, err);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("status", false);
            err.Add("message", "No Record Found");
            err.Add("data", "");
            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
        }
        finally
        {
            Task.Factory.StartNew(() => DTRAHIP.SavePullData(FetchDat, ABHABasicData.Delay));
        }
    }


}

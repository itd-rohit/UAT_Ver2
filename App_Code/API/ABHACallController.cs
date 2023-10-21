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
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

//[Route("api/{controller}/{action}")]
public class ABHACallController : ApiController
{
    /// <summary>
    /// HIP Initiated linking
    /// </summary>
    /// <returns></returns>
    [Route("v0.5/users/auth/on-fetch-modes")]
    [HttpPost]
    [ActionName("onfetchmodes")]
    public HttpResponseMessage onfetchmodes()
    {

        HttpError err = new HttpError();
        try
        {
            var rawMessage = Request.Content.ReadAsStringAsync();

            string status_code = rawMessage.Status.ToString();
            HIPInitiatedFetchAuth FetchDat = JsonConvert.DeserializeObject<HIPInitiatedFetchAuth>(rawMessage.Result);
            ABHAHIPInitiatedCareContextLinking AbhaCareLinking = new ABHAHIPInitiatedCareContextLinking();

            AbhaCareLinking.UpdateOnFetchData(FetchDat, status_code);



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


    [Route("v0.5/users/auth/on-init")]
    [HttpPost]
    [ActionName("OnInitPost")]
    public HttpResponseMessage OnInitPost()
    {

        HttpError err = new HttpError();
        try
        {
            var rawMessage = Request.Content.ReadAsStringAsync();

            string status_code = rawMessage.Status.ToString();
            HIPInitiatedInitPost FetchDat = JsonConvert.DeserializeObject<HIPInitiatedInitPost>(rawMessage.Result);
            ABHAHIPInitiatedCareContextLinking AbhaCareLinking = new ABHAHIPInitiatedCareContextLinking();


            AbhaCareLinking.UpdateOnInitData(FetchDat, status_code);

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

    [Route("v0.5/users/auth/on-confirm")]
    [HttpPost]
    [ActionName("OnConfirm")]
    public HttpResponseMessage OnConfirm()
    {

        HttpError err = new HttpError();
        try
        {
            var rawMessage = Request.Content.ReadAsStringAsync();
            string status_code = rawMessage.Status.ToString();
            HIPOnConfirmAuth FetchDat = JsonConvert.DeserializeObject<HIPOnConfirmAuth>(rawMessage.Result);
            ABHAHIPInitiatedCareContextLinking AbhaCareLinking = new ABHAHIPInitiatedCareContextLinking();
            AbhaCareLinking.UpdateConfirmData(FetchDat, status_code);

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

    [Route("v0.5/links/link/on-add-contexts")]
    [HttpPost]
    [ActionName("OnAddContexts")]
    public HttpResponseMessage OnAddContexts()
    {

        HttpError err = new HttpError();

        //var rawMessage = Request.Content.ReadAsStringAsync();
        var rawMessage = Request.Content.ReadAsStringAsync();
        string status_code = rawMessage.Status.ToString();
        AddCareContextRes FetchDat = JsonConvert.DeserializeObject<AddCareContextRes>(rawMessage.Result);
        ABHAHIPInitiatedCareContextLinking AbhaCareLinking = new ABHAHIPInitiatedCareContextLinking();

        string XHIPID = "";
        foreach (var header in Request.Headers)
        {
            if (header.Key == "X-HIP-ID")
            {
                XHIPID = String.Join(", ", header.Value);
            }
        }
        try
        {
            AbhaCareLinking.UpdateOnAddcontext(FetchDat, status_code, XHIPID, 0);
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
            Task.Factory.StartNew(() => AbhaCareLinking.NotifyAfterAddCareContext(FetchDat, status_code, XHIPID, ABHABasicData.Delay));
        }
    }

    /// <summary>
    /// HIP Initiated linking
    /// </summary>
    /// <returns></returns>

    //Profile share Part

    [Route("v1.0/patients/profile/share")]
    [HttpPost]
    [ActionName("ProfileShare")]
    public HttpResponseMessage ProfileShare()
    {

        HttpError err = new HttpError();
        var rawMessage = Request.Content.ReadAsStringAsync().Result;
        ABHAProfileShareRes FetchDat = JsonConvert.DeserializeObject<ABHAProfileShareRes>(rawMessage);
        AbhaPatientInitiatedLinking AbhaPatLink = new AbhaPatientInitiatedLinking();

        string XHIPID = "";
        foreach (var header in Request.Headers)
        {
            if (header.Key == "X-HIP-ID")
            {
                XHIPID = String.Join(", ", header.Value);
            }
        }

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
            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
        }
        finally
        {
            Task.Factory.StartNew(() => AbhaPatLink.OnShareProfleResponce(FetchDat, XHIPID, ABHABasicData.Delay));
        }
    }
    //profle share part end.
    /// <summary>
    /// Patient Initiated Care context linking
    /// </summary>
    /// <returns></returns>
    [Route("v0.5/care-contexts/discover")]
    [HttpPost]
    [ActionName("discover")]
    public HttpResponseMessage discover()
    {
        var rawMessage = Request.Content.ReadAsStringAsync().Result;
        DicoverResponce FetchDat = JsonConvert.DeserializeObject<DicoverResponce>(rawMessage);
        AbhaPatientInitiatedLinking AbhaPatLink = new AbhaPatientInitiatedLinking();

        HttpError err = new HttpError();
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

            Task.Factory.StartNew(() => AbhaPatLink.OnDiscoverResponce(FetchDat, ABHABasicData.Delay));
        }
    }

    [Route("v0.5/links/link/init")]
    [HttpPost]
    [ActionName("InitiationToLinkCareContext")]
    public HttpResponseMessage InitiationToLinkCareContext()
    {

        HttpError err = new HttpError();
        var rawMessage = Request.Content.ReadAsStringAsync().Result;
        DicoverResponce FetchDat = JsonConvert.DeserializeObject<DicoverResponce>(rawMessage);
        AbhaPatientInitiatedLinking AbhaPatLink = new AbhaPatientInitiatedLinking();

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
            Task.Factory.StartNew(() => AbhaPatLink.OnInItResponce(FetchDat, ABHABasicData.Delay));
        }
    }

    [Route("v0.5/links/link/confirm")]
    [HttpPost]
    [ActionName("confirm")]
    public HttpResponseMessage confirm()
    {

        HttpError err = new HttpError();

        var rawMessage = Request.Content.ReadAsStringAsync().Result;
        DicoverResponce FetchDat = JsonConvert.DeserializeObject<DicoverResponce>(rawMessage);
        AbhaPatientInitiatedLinking AbhaPatLink = new AbhaPatientInitiatedLinking();

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
            Task.Factory.StartNew(() => AbhaPatLink.OnConfirmResponce(FetchDat, ABHABasicData.Delay));
        }
    }

    [Route("v0.5/links/context/on-notify")]
    [HttpPost]
    [ActionName("onnotifyAfterAddcontext")]
    public HttpResponseMessage onnotifyAfterAddcontext()
    {

        HttpError err = new HttpError();
        try
        {
            var rawMessage = Request.Content.ReadAsStringAsync();

            string status_code = rawMessage.Status.ToString();

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


    [Route("v0.5/patients/sms/on-notify")]
    [HttpPost]
    [ActionName("smsonnotify")]
    public HttpResponseMessage smsonnotify()
    {

        HttpError err = new HttpError();
        try
        {
            var rawMessage = Request.Content.ReadAsStringAsync().Result;
            SMSNotifyResponce FetchDat = JsonConvert.DeserializeObject<SMSNotifyResponce>(rawMessage);
            AbhaPatientInitiatedLinking AbhaPatLink = new AbhaPatientInitiatedLinking();
            int stat = 2;
            if (FetchDat.status=="ACKNOWLEDGED")
            {
                stat = 1;
            }

            AbhaPatLink.UpdateSendSmsStatus(FetchDat, stat);

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



}
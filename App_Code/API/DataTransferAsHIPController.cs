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
public class DataTransferAsHIPController : ApiController
{ 
    /// <summary>
    /// Data Transefer As HIP
    /// </summary>
    /// <returns></returns>
    /// 
    [Route("v0.5/consents/hip/notify")]
    [HttpPost]
    [ActionName("Notify")]
    public HttpResponseMessage Notify()
    {

        HttpError err = new HttpError();

        var rawMessage = Request.Content.ReadAsStringAsync();

        string status_code = rawMessage.Status.ToString();
        AbhaNotifyModel FetchDat = JsonConvert.DeserializeObject<AbhaNotifyModel>(rawMessage.Result);
        DataTransferResponceAsHIP DTRAHIP = new DataTransferResponceAsHIP();
        
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
            if (FetchDat.notification.status != "REVOKED" && FetchDat.notification.status != "EXPIRED")
            {
                Task.Factory.StartNew(() => DTRAHIP.OnNotifyCall(FetchDat, ABHABasicData.Delay));
            }
            else
            {
                Task.Factory.StartNew(() => DTRAHIP.OnNotifyCall(FetchDat, ABHABasicData.Delay));
            }
           
        }
    }

    [Route("v0.5/health-information/hip/request")]
    [HttpPost]
    [ActionName("RequestedByHIU")]
    public HttpResponseMessage RequestedByHIU()
    {

        HttpError err = new HttpError();
        var rawMessage = Request.Content.ReadAsStringAsync();

            string status_code = rawMessage.Status.ToString();
            RequestRes FetchDat = JsonConvert.DeserializeObject<RequestRes>(rawMessage.Result);
            DataTransferResponceAsHIP DTRAHIP = new DataTransferResponceAsHIP();

       
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
            Task.Factory.StartNew(() => DTRAHIP.OnRequestCall(FetchDat, ABHABasicData.Delay));
        }
    }


}

using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for ABHAGetBearerToken
/// </summary>
public class ABHAGetBearerToken
{
    public static ABHATokenResponceModel GetAbhaAccessToken()
    {
        ABHATokenResponceModel tokenResponse = new ABHATokenResponceModel();

        try
        {
            using (var client = ABHAClientHelper.GetClient(ABHABasicData.clientId, ABHABasicData.clientSecret))
            {
                System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;
                client.BaseAddress = new Uri(ABHABasicData.ABDM_Point_URL);
                // client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                try
                {
                    string urldat = "gateway/v0.5/sessions";
                    var data = new { clientId = ABHABasicData.clientId, clientSecret = ABHABasicData.clientSecret };

                    System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                    string status_code = responseMessage.StatusCode.ToString();
                    if (responseMessage.IsSuccessStatusCode)
                    {
                        string jsonMessage;
                        using (Stream responseStream = responseMessage.Content.ReadAsStreamAsync().GetAwaiter().GetResult())
                        {
                            jsonMessage = new StreamReader(responseStream).ReadToEnd();
                        }
                        tokenResponse = (ABHATokenResponceModel)JsonConvert.DeserializeObject(jsonMessage,
                        typeof(ABHATokenResponceModel));
                        return tokenResponse;
                    }
                    else
                    {
                        return tokenResponse;
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return null;
                }

                return tokenResponse;

            }

        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;

        }


    }


}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Formatting;
using System.Web;
using System.Web.Http;
using WebDemoAPI.CustomHandler;

/// <summary>
/// Summary description for WebApiConfig
/// </summary>
public class WebApiConfig
{
    public static void Register(HttpConfiguration config)
    {
        // config.MessageHandlers.Add(new TokenValidationHandler());
        config.MessageHandlers.Add(new RequestResponseHandler());
        config.Routes.MapHttpRoute(
               name: "MapByAction",
               routeTemplate: "api/{controller}/{action}/{id}", defaults: new { id = RouteParameter.Optional });

        // Register the static route on fetch auth mode
        config.Routes.MapHttpRoute(
             name: "OnFetchAuthModeRoot",
             routeTemplate: "v0.5/users/auth/on-fetch-modes",
             defaults: new { controller = "abhacall", action = "onfetchmodes" }
        );

        //// Register the static route on-int
        config.Routes.MapHttpRoute(
             name: "OnInitPostRoot",
             routeTemplate: "v0.5/users/auth/on-init",
             defaults: new { controller = "abhacall", action = "OnInitPost" }
        );

        //// Register the static route on-confirm
        config.Routes.MapHttpRoute(
             name: "onconfirmRoot",
             routeTemplate: "v0.5/users/auth/on-confirm",
             defaults: new { controller = "abhacall", action = "OnConfirm" }
        );

        //// Register the static route Profile Share
        config.Routes.MapHttpRoute(
             name: "ProfileshareRoot",
             routeTemplate: "v1.0/patients/profile/share",
             defaults: new { controller = "abhacall", action = "ProfileShare" }
        );

        //// Register the static route  on-add-contexts  Root
        config.Routes.MapHttpRoute(
             name: "onaddcontexts",
             routeTemplate: "v0.5/links/link/on-add-contexts",
             defaults: new { controller = "abhacall", action = "OnAddContexts" }
        );

        //// Register the static route  discoverPatientInitiated  Root
        config.Routes.MapHttpRoute(
             name: "discoverPatientInitiated",
             routeTemplate: "v0.5/care-contexts/discover",
             defaults: new { controller = "abhacall", action = "discover" }
        );

        //// Register the static route  InitiationToLinkCareContext  Root
        config.Routes.MapHttpRoute(
             name: "InitiationToLinkCareContext",
             routeTemplate: "v0.5/links/link/init",
             defaults: new { controller = "abhacall", action = "InitiationToLinkCareContext" }
        );

        //// Register the static route  confirm  Root
        config.Routes.MapHttpRoute(
             name: "confirm",
             routeTemplate: "v0.5/links/link/confirm",
             defaults: new { controller = "abhacall", action = "confirm" }
        );
         

        config.Routes.MapHttpRoute(
           name: "onnotifyAfterAddcontext",
           routeTemplate: "v0.5/links/context/on-notify",
           defaults: new { controller = "abhacall", action = "onnotifyAfterAddcontext" }
      );


        config.Routes.MapHttpRoute(
           name: "smsonnotify",
           routeTemplate: "v0.5/patients/sms/on-notify",
           defaults: new { controller = "abhacall", action = "smsonnotify" }
      );
         


        config.Routes.MapHttpRoute(
            name: "DefaultApi",
            routeTemplate: "api/{controller}/{action}/{id}",
            defaults: new
            {
                id = RouteParameter.Optional
            }
        );

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- Data Transfer As HIP Routeing URL---------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

        //// Register the static route  notify 
        config.Routes.MapHttpRoute(
             name: "Notify",
             routeTemplate: "v0.5/consents/hip/notify",
             defaults: new { controller = "DataTransferAsHIP", action = "Notify" }
        );

        //// Register the static route  v0.5/health-information/hip/request
        config.Routes.MapHttpRoute(
             name: "RequestedByHIU",
             routeTemplate: "v0.5/health-information/hip/request",
             defaults: new { controller = "DataTransferAsHIP", action = "RequestedByHIU" }
        );


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* -------------------------------------------------------- HIU Get Responce Route URL---------------------------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
        //// Register the static route  notify 
        config.Routes.MapHttpRoute(
             name: "ConsentRequestOnInit",
             routeTemplate: "v0.5/consent-requests/on-init",
             defaults: new { controller = "AbhaHIU", action = "ConsentRequestOnInit" }
        );

        //// Register the static route  v0.5/consents/hiu/notify
        config.Routes.MapHttpRoute(
             name: "ConsentRequestNotify",
             routeTemplate: "v0.5/consents/hiu/notify",
             defaults: new { controller = "AbhaHIU", action = "ConsentRequestNotify" }
        );

        //// Register the static route  v0.5/consents/on-fetch 
        config.Routes.MapHttpRoute(
             name: "Consentonfetch",
             routeTemplate: "v0.5/consents/on-fetch",
             defaults: new { controller = "AbhaHIU", action = "Consentonfetch" }
        );

        //// Register the static route  v0.5/health-information/hiu/on-request
        config.Routes.MapHttpRoute(
             name: "Consentonrequest",
             routeTemplate: "v0.5/health-information/hiu/on-request",
             defaults: new { controller = "AbhaHIU", action = "Consentonrequest" }
        );
         

        //// Register the static route  hiu/data-push/pushdataonrequest HIU Direct datapush URL
        config.Routes.MapHttpRoute(
             name: "PushDataHere",
             routeTemplate: "hiu/data-push/pushdataonrequest",
             defaults: new { controller = "AbhaHIU", action = "PushDataHere" }
        ); 
/*...............................................................................................................................*/


        GlobalConfiguration.Configuration.Formatters.JsonFormatter.MediaTypeMappings.Add(new QueryStringMapping("json", "true", "application/json"));
        config.Formatters.XmlFormatter.SupportedMediaTypes.Add(new System.Net.Http.Headers.MediaTypeHeaderValue("multipart/form-data"));
    }
}
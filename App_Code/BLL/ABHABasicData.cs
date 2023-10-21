using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for ABHABasicData
/// </summary>
public class ABHABasicData
{
    public static readonly string TokenBaseUrl = "https://dev.abdm.gov.in/";//  "https://nha-suma-azb7fa3pfa-el.a.run.app/";//"https://dev.abdm.gov.in/";
    public static readonly string BaseUrl = "https://healthidsbx.abdm.gov.in/api/";//"https://nha-suma-azb7fa3pfa-el.a.run.app/";// "https://healthidsbx.abdm.gov.in/api/";
    public static readonly string ABDM_Point_URL = "https://dev.abdm.gov.in/";
    public static readonly string clientId = "SBX_002977";
    public static readonly string clientSecret = "9674725f-23c9-4f9b-926a-41958e0cdb93";
    public static readonly string XCMID = "sbx";
    public static readonly string DataPushURL = "http://itd2.fw.ondgni.com/Tenwekabhanew/hiu/data-push/pushdataonrequest";
    public static readonly string HospitalURL = "http://itd2.fw.ondgni.com/Tenwekabhanew/";
    public static readonly string grant_type = "password";
    public static readonly string CURVE = "curve25519";
    public static readonly string ALGORITHM = "ECDH";
    public static readonly string Getway = "gateway/";//"gateway/";
    public static readonly int Delay = 5000;
    public static readonly int MinDelay = 3000;
    public static readonly int MaxRequestCountAllowed = 50;
    public static readonly int MaxSMSRequestCountAllowed = 50;
    public static readonly string DefultHIU = "SBX_002517_HIU";

    public static readonly TimeZoneInfo India_Standard_Time = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
    public static readonly TimeZoneInfo Eastern_Standard_Time = TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time");
    public static readonly TimeZoneInfo Tokyo_Standard_Time = TimeZoneInfo.FindSystemTimeZoneById("Tokyo Standard Time");  

}
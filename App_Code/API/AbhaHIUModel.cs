using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for AbhaHIUModel
/// </summary>
public class AbhaHIUOnInintResModel
{
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public RequestReshiRequestconsent consentRequest { get; set; }
    public DataRes resp { get; set; }
    public RespError error { get; set; }
}


public class AbhaHIUNotifyResModel
{
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public AbhaHIUNotiicationResModel notification { get; set; }
    public RespError error { get; set; }
}

public class AbhaHIUNotiicationResModel
{
    public string consentRequestId { get; set; }
    public string status { get; set; }
    public List<RequestReshiRequestconsent> consentArtefacts { get; set; }
}


public class AbhaOnRequestResponceHIU
{
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public HiRequest hiRequest { get; set; }
    public RespError error { get; set; }
    public DataRes resp { get; set; }
}


public class AbhaDataRes
{
    public string pageNumber { get; set; }
    public string pageCount { get; set; }
    public string transactionId { get; set; }
    public List<AbhaDataResEntries> entries { get; set; }
    public RequestReshiRequestkeyMaterial keyMaterial { get; set; }

}

public class AbhaDataResEntries
{

    public string content { get; set; }
    public string media { get; set; }
    public string checksum { get; set; }
    public string careContextReference { get; set; }

}
 

public class AbhaPatientSearch
{

    public string healthId { get; set; }
    public string healthIdNumber { get; set; }
    public string name { get; set; }
    public string status { get; set; }

}














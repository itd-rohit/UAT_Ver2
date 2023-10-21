using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DataTransferModel
/// </summary>


// on-Notify Responce model.
public class OnNotifyResponceModel
{
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public Acknowledgement acknowledgement { get; set; }
    public DataRes resp { get; set; }
}
public class Acknowledgement
{
    public string status { get; set; }
    public string consentId { get; set; }
}
public class DataRes
{
    public string requestId { get; set; }

}
// on-Notify Responce model End.

public class NotifyResponceModel
{
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public Acknowledgement acknowledgement { get; set; }
    public DataRes resp { get; set; }
}
// on-Notify Responce model End.

//Notify Responce model.

public class AbhaNotifyModel
{
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public AbhaNotification notification { get; set; }
}

public class AbhaNotification
{
    public string status { get; set; }
    public string signature { get; set; }
    public string consentId { get; set; }
    public string grantAcknowledgement { get; set; }
    public AbhaConsentDetail consentDetail { get; set; }

}

public class AbhaConsentDetail
{
    public string consentId { get; set; }
    public string createdAt { get; set; }
    public AbhaPurpose purpose { get; set; }
    public AbhaData patient { get; set; }
    public AbhaData consentManager { get; set; }
    public AbhaData hip { get; set; }
    public string[] hiTypes { get; set; }
    public AbhaPermission permission { get; set; }
    public List<AbhacareContexts> careContexts { get; set; }

}
public class AbhaPurpose
{
    public string text { get; set; }
    public string code { get; set; }
    public string refUri { get; set; }

}
public class AbhaData
{
    public string id { get; set; }
    public string name { get; set; }
}

public class AbhaPermission
{
    public string accessMode { get; set; }
    public AbhaDateRange dateRange { get; set; }
    public string dataEraseAt { get; set; }
    public Abhafrequency frequency { get; set; }

}

public class AbhaDateRange
{
    public string from { get; set; }
    public string to { get; set; }
}
public class Abhafrequency
{
    public string unit { get; set; }
    public string value { get; set; }
    public string repeats { get; set; }
}

public class AbhacareContexts
{
    public string patientReference { get; set; }
    public string careContextReference { get; set; }

}

// on-Notify Responce model End.



// on-request helath information Responce model .

public class OnRequestHealthInformationModel
{
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public Acknowledgement hiRequest { get; set; }
    public DataRes resp { get; set; }

}

public class HiRequest
{
    public string transactionId { get; set; }
    public string sessionStatus { get; set; }
}

// on-request helath information Responce model End.

// request helath information Responce model .


public class RequestHealthInformationModel
{
    public string requestId { get; set; }
    public string HiRequest { get; set; }
    public Acknowledgement hiRequest { get; set; }
    public DataRes resp { get; set; }

}

// on-request helath information Responce model End.

public class RequestRes
{
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public string transactionId { get; set; }
    public RequestReshiRequest hiRequest { get; set; }

}

public class RequestReshiRequest
{
    public RequestReshiRequestconsent consent { get; set; }
    public AbhaDateRange dateRange { get; set; }
    public string dataPushUrl { get; set; }
    public RequestReshiRequestkeyMaterial keyMaterial { get; set; }


}
public class RequestReshiRequestconsent
{
    public string id { get; set; }
}
public class RequestReshiRequestkeyMaterial
{
    public string cryptoAlg { get; set; }
    public string curve { get; set; }
    public RequestReshiRequestkeyMaterialdhPublicKey dhPublicKey { get; set; }
    public string nonce { get; set; }

}
public class RequestReshiRequestkeyMaterialdhPublicKey
{
    public string expiry { get; set; }
    public string parameters { get; set; }
    public string keyValue { get; set; }
    
}
// request helath information Responce model .


public class SMSNotifyResponce
{
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public string status { get; set; }
    public DataRes resp { get; set; }
    public RespError error { get; set; }
}









































using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for ABHATokenResponceModel
/// </summary>
public class ABHATokenResponceModel
{
    [JsonProperty("accessToken")]
    public string AccessToken { get; set; }
    [JsonProperty("expiresIn")]
    public int ExpiresIn { get; set; }
    [JsonProperty("refreshExpiresIn")]
    public int RefreshExpiresIn { get; set; }
    [JsonProperty("refreshToken")]
    public string RefreshToken { get; set; }
    [JsonProperty("tokenType")]
    public string TokenType { get; set; }

}

public class AbhaRegistrationPatientDetails
{
    public string email { get; set; }
    public string firstName { get; set; }
    public string healthId { get; set; }
    public string lastName { get; set; }
    public string middleName { get; set; }
    public string password { get; set; }
    public string profilePhoto { get; set; }
    public string txnId { get; set; }

}

public class AbhaMobileVerificationRes
{
    public string txnId { get; set; }
    public bool mobileLinked { get; set; }

}

public class AbhaXTokenRes
{
    [JsonProperty("token")]
    public string XToken { get; set; }


}

public class DicoverResponce
{
    public PatientData patient { get; set; }
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public string transactionId { get; set; }
    public Confirmation confirmation { get; set; }
}

public class PatientData
{
    public string id { get; set; }
    public string referenceNumber { get; set; }
    public string name { get; set; }
    public string gender { get; set; }
    public int yearOfBirth { get; set; }
    public List<VerifiedIdentifiers> verifiedIdentifiers { get; set; }
    public List<VerifiedIdentifiers> unverifiedIdentifiers { get; set; }
    public List<RequestTolinkCareContext> careContexts { get; set; }
}

public class RequestTolinkCareContext
{
    public string referenceNumber { get; set; }
     
}

public class VerifiedIdentifiers
{
    public string type { get; set; }
    public string value { get; set; }

}


public class Confirmation
{
    public string linkRefNumber { get; set; }
    public string token { get; set; }
}



public class ConfirmSaveRes
{
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public ConfirmPatData patient { get; set; }
    public ConfirmResp resp { get; set; }


}
public class HIPSaveDataAddCareContext
{
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public HIPSaveDataAddCareContextLink link { get; set; }
}

public class HIPSaveDataAddCareContextLink
{
    public string accessToken { get; set; }
    public ConfirmPatData patient { get; set; }
}

public class ConfirmPatData
{
    public string referenceNumber { get; set; }
    public string display { get; set; }
    public List<ConfirmCareContexts> careContexts { get; set; }
}
public class ConfirmCareContexts
{
    public string referenceNumber { get; set; }
    public string display { get; set; }
}

public class ConfirmResp
{
    public string requestId { get; set; }

}

public class HIPInitiatedFetchAuth
{
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public HIPInitAuthResp auth { get; set; }
    public RespError error { get; set; }
    public ConfirmResp resp { get; set; }

}

public class HIPInitAuthResp
{
    public string purpose { get; set; }
    public string[] modes { get; set; }
}
public class RespError
{
    public string code { get; set; }
    public string message { get; set; }
}

public class HIPInitiatedInitPost
{
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public HIPInit auth { get; set; }
    public RespError error { get; set; }
    public ConfirmResp resp { get; set; }

}

public class HIPInit
{
    public string transactionId { get; set; }
    public string modes { get; set; }
    public Meta meta { get; set; }
}
public class Meta
{
    public string hint { get; set; }
    public string expiry { get; set; }
}


///
//Abha on Confirm Auth Responce
///

public class HIPOnConfirmAuth
{
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public HIPOnConfirmAuthResponce auth { get; set; }
    public RespError error { get; set; }
    public ConfirmResp resp { get; set; }
}

public class HIPOnConfirmAuthResponce
{
    public string accessToken { get; set; }
    public HIPOnConfirmPatientResponce patient { get; set; }
}

public class HIPOnConfirmPatientResponce
{
    public string id { get; set; }
    public string name { get; set; }
    public string gender { get; set; }
    public int yearOfBirth { get; set; }
    public int monthOfBirth { get; set; }
    public int dayOfBirth { get; set; }
    public HIPOnConfirmPatientAddressLine address { get; set; }
    public List<HIPOnConfirmPatientIdentifire> identifiers { get; set; }
}

public class HIPOnConfirmPatientAddressLine
{
    public string line { get; set; }
    public string district { get; set; }
    public string state { get; set; }
    public string pincode { get; set; }

}
public class HIPOnConfirmPatientIdentifire
{
    public string type { get; set; }
    public string value { get; set; }

}




///
//Add Care Context Responce.
/// 
public class AddCareContextRes
{
    public string requestId { get; set; }
    public string timestamp { get; set; }
    public AddCareContextResAck acknowledgement { get; set; }
    public RespError error { get; set; }
    public ConfirmResp resp { get; set; }
}
public class AddCareContextResAck
{
    public string status { get; set; }
}

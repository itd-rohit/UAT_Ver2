using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class ABHAProfileShareRes
{

    public string requestId { get; set; }
    public string timestamp { get; set; }
    public ABHAProfileintent intent { get; set; }
    public ABHAProfilelocation location { get; set; }
    public ABHAProfile profile { get; set; }

}

public class ABHAProfileintent
{
    public string type { get; set; }
}
public class ABHAProfilelocation
{
    public string latitude { get; set; }
    public string longitude { get; set; }
}

public class ABHAProfile
{
    public string hipCode { get; set; }
    public ABHAProfilePatient patient { get; set; }
}

public class ABHAProfilePatient
{
    public string healthId { get; set; }
    public string healthIdNumber { get; set; }
    public string name { get; set; }
    public string gender { get; set; }
    public HIPOnConfirmPatientAddressLine address { get; set; }
    public int yearOfBirth { get; set; }
    public int monthOfBirth { get; set; }
    public int dayOfBirth { get; set; }
    public List<HIPOnConfirmPatientIdentifire> identifiers { get; set; }
}
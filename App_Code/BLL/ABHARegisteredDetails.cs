using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class ABHARegisteredDetails
{
    public string token { get; set; }
    public string refreshToken { get; set; }
    public string healthIdNumber { get; set; }
    public string name { get; set; }
    public string gender { get; set; }
    public int yearOfBirth { get; set; }
    public int monthOfBirth { get; set; }
    public int dayOfBirth { get; set; }
    public string firstName { get; set; }
    public string healthId { get; set; }
    public string lastName { get; set; }
    public string middleName { get; set; }
    public string stateCode { get; set; }
    public string districtCode { get; set; }
    public string stateName { get; set; }
    public string districtName { get; set; }
    public string email { get; set; }
    public string kycPhoto { get; set; }
    public string profilePhoto { get; set; }
    public string mobile { get; set; }
    public string[] authMethods { get; set; }
    public string pincode { get; set; }
    public object tags { get; set; }
    [JsonProperty("new")]
    public bool New { get; set; }
}
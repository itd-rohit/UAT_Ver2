<%@ WebService Language="C#" CodeBehind="~/App_Code/ABHAService.cs" Class="ABHAService" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Net.Http;
using System.Net;
using System.Net.Http.Headers;
using System.Data;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System.Text;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ABHAService : System.Web.Services.WebService
{

    ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
    public ABHAService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    ////
    // Abha Registration  And Mapped to UHID PArts

    //

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetAccessToken()
    {
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();

        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = tokenResponse.AccessToken });

    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetAadharOtp(string AadharNo)
    {
        if (MT.IsInjectedString(AadharNo))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "Too Many Request." });
        }
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();


        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.BaseUrl);

            try
            {
                string urldat = "v1/registration/aadhaar/generateOtp";
                var data = new { aadhaar = AadharNo, iagree = true, consentVersion = "V1" };

                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                if (responseMessage.IsSuccessStatusCode)
                {

                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, message = "" });

                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, message = "" });

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage }, message = "" });

            }


        }


    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string VerifyAadharOtp(string OTP, string TnxId)
    {

        if (MT.IsInjectedString(OTP) || MT.IsInjectedString(TnxId))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "Too Many Request." });
        }
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();

        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.BaseUrl);
            try
            {
                string urldat = "v1/registration/aadhaar/verifyOTP";
                var data = new { otp = OTP, txnId = TnxId };

                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                //Checking the response is successful or not which is sent using HttpClient  
                if (responseMessage.IsSuccessStatusCode)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, message = "" });

                }
                else
                {

                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, message = "" });

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, details = new { message = AllGlobalFunction.errorMessage } }, message = "" });

            }


        }

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string ResendAadhaarOtp(string TnxId)
    {

        if (MT.IsInjectedString(TnxId))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "Too Many Request." });
        }
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();

        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.BaseUrl);
            try
            {
                string urldat = "v1/registration/aadhaar/resendAadhaarOtp";
                var data = new {txnId = TnxId };

                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                //Checking the response is successful or not which is sent using HttpClient  
                if (responseMessage.IsSuccessStatusCode)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, message = "" });

                }
                else
                {

                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, message = "" });

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, details = new { message = AllGlobalFunction.errorMessage } }, message = "" });

            }


        }

    }



    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string CheckAndGenerateMobileOTP(string Mobile, string TnxId)
    {
        
        if (MT.IsInjectedString(Mobile) || MT.IsInjectedString(TnxId))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "Too Many Request." });
        }

        AbhaMobileverification(Mobile, TnxId, 0);

        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();


        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.BaseUrl);

            try
            {
                string urldat = "v2/registration/aadhaar/checkAndGenerateMobileOTP";
                var data = new { mobile = Mobile, txnId = TnxId };

                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);

                if (responseMessage.IsSuccessStatusCode)
                {

                    AbhaMobileVerificationRes FetchDat = JsonConvert.DeserializeObject<AbhaMobileVerificationRes>(recivedata);

                    if (FetchDat.mobileLinked)
                    {

                        AbhaMobileverification(Mobile, TnxId, 1);

                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, MobileStatus = true, response = Seralizedata, message = "" });

                    }
                    else
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, MobileStatus = false, response = "Mobile Is Already Link", message = "" });

                    }

                }
                else
                {

                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, message = "" });

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, details = new { message = AllGlobalFunction.errorMessage } }, message = "" });

            }


        }


    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string VerifyMobileOTP(string OTP, string TnxId)
    {
        if (MT.IsInjectedString(OTP) || MT.IsInjectedString(TnxId))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "Too Many Request." });
        }
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();


        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.BaseUrl);

            try
            {
                string urldat = "v1/registration/aadhaar/VerifyMobileOTP";
                var data = new { otp = OTP, txnId = TnxId };

                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);

                if (responseMessage.IsSuccessStatusCode)
                {
                    AbhaMobileverification("", TnxId, 1);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, message = "" });

                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, message = "" });
                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, details = new { message = AllGlobalFunction.errorMessage } }, message = "" });

            }


        }


    }
  
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string CreateHealthIdWithPreVerified(AbhaRegistrationPatientDetails AbhaRegistration)
    {
 
        if (!IsAbhaMobileverification(AbhaRegistration.txnId))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = "Mobile No Not Verified", details = new { message = AllGlobalFunction.errorMessage } }, message = "" });
        }
        
        if (MT.IsInjectedString(AbhaRegistration.firstName)
            || MT.IsInjectedString(AbhaRegistration.email)
            || MT.IsInjectedString(AbhaRegistration.healthId)
            || MT.IsInjectedString(AbhaRegistration.lastName)
            || MT.IsInjectedString(AbhaRegistration.middleName)
             || MT.IsInjectedString(AbhaRegistration.password)
             || MT.IsInjectedString(AbhaRegistration.profilePhoto)
             || MT.IsInjectedString(AbhaRegistration.txnId)
            )
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "Too Many Request." });
        }
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();

        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.BaseUrl);

            try
            {
                string urldat = "v1/registration/aadhaar/createHealthIdWithPreVerified";
                var data = new
                {
                    email = AbhaRegistration.email,
                    firstName = AbhaRegistration.firstName,
                    healthId = AbhaRegistration.healthId,
                    lastName = AbhaRegistration.lastName,
                    middleName = AbhaRegistration.middleName,
                    password = AbhaRegistration.password,
                    profilePhoto = AbhaRegistration.profilePhoto,
                    txnId = AbhaRegistration.txnId,
                };

                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);

                if (responseMessage.IsSuccessStatusCode)
                {
                    ABHARegisteredDetails FetchDat = JsonConvert.DeserializeObject<ABHARegisteredDetails>(recivedata);

                    bool IsSave = SaveFetchData(FetchDat);

                    string MappedPatientID = IsPatientMapped(FetchDat.healthIdNumber);

                    bool IsMappedPatient = false;

                    if (!string.IsNullOrEmpty(MappedPatientID))
                    {
                        IsMappedPatient = true;
                    }


                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, message = "", IsMappedPatient = IsMappedPatient, MappedPatientID = MappedPatientID });

                    //return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, message = "" });

                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, message = "" });

                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, details = new { message = AllGlobalFunction.errorMessage } }, message = "" });

            }


        }


    }

    [WebMethod(EnableSession = true, Description = "Save Fetch Data")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public bool SaveFetchData(ABHARegisteredDetails ARD)
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("Select * From abha_registration pm where Pm.HealthIdNumber='" + ARD.healthIdNumber + "' ");
        if (dt != null && dt.Rows.Count > 0)
        {
            return false;
        }


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            int IsNew = 0;
            if (ARD.New)
            {
                IsNew = 1;
            }

            StringBuilder sb = new StringBuilder();

            sb.Append(" insert into abha_registration ");

            sb.Append(" (Token, RefreshToken,HealthIdNumber,Name,Gender, ");
            sb.Append(" YearOfBirth,MonthOfBirth,DayOfBirth,DateOfBirth, ");
            sb.Append(" FirstName,HealthId,LastName,MiddleName,StateCode, ");
            sb.Append(" DistrictCode,StateName,DistrictName,Email, kycPhoto, ");
            sb.Append(" ProfilePhoto,Mobile,AuthMethods,Pincode,New,");
            sb.Append(" EntryDate,DataFetchBy) ");
            sb.Append(" values ");
            sb.Append(" (@Token, @RefreshToken,@HealthIdNumber,@Name,@Gender, ");
            sb.Append(" @YearOfBirth,@MonthOfBirth,@DayOfBirth,@DateOfBirth, ");
            sb.Append(" @FirstName,@HealthId,@LastName,@MiddleName,@StateCode, ");
            sb.Append(" @DistrictCode,@StateName,@DistrictName,@Email, @kycPhoto, ");
            sb.Append(" @ProfilePhoto,@Mobile,@AuthMethods,@Pincode,@New,");
            sb.Append(" NOW(),@DataFetchBy) ");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
          {

              Token = ARD.token,
              RefreshToken = ARD.refreshToken,
              HealthIdNumber = ARD.healthIdNumber,
              Name = ARD.name,
              Gender = ARD.gender,
              YearOfBirth = ARD.yearOfBirth,
              MonthOfBirth = ARD.monthOfBirth,
              DayOfBirth = ARD.dayOfBirth,
              DateOfBirth = Util.GetDateTime(ARD.dayOfBirth + "-" + ARD.monthOfBirth + "-" + ARD.yearOfBirth).ToString("yyyy-MM-dd"),
              FirstName = ARD.firstName,
              HealthId = ARD.healthId,
              LastName = ARD.lastName,
              MiddleName = ARD.middleName,
              StateCode = ARD.stateCode,
              DistrictCode = ARD.districtCode,
              StateName = ARD.stateName,
              DistrictName = ARD.districtName,
              Email = ARD.email,
              kycPhoto = ARD.kycPhoto,
              ProfilePhoto = ARD.profilePhoto,
              Mobile = ARD.mobile,
              AuthMethods = String.Join(",", ARD.authMethods),
              Pincode = ARD.pincode,
              New = IsNew,
              DataFetchBy = HttpContext.Current.Session["ID"].ToString()
          });

            tnx.Commit();
            return true;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }




    }



    [WebMethod(EnableSession = true, Description = "Save Fetch Data")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string MappAbhaNoWithPatientID(string PatientID, string AbhaNo)
    {


        
        string PatId = PatientID;
        DataTable dt = new DataTable();
        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dtabhareg = excuteCMD.GetDataTable("Select * From abha_registration pm where Pm.HealthIdNumber=@AbhaNo", CommandType.Text, new
        {
            AbhaNo = AbhaNo, 
        });
        if (dtabhareg == null && dtabhareg.Rows.Count == 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "ABHA Not Verified", message = "" });

        }
        dt = new DataTable();

        dt = excuteCMD.GetDataTable("SELECT CONCAT(pm.Title,' ',pm.PName) PatientFullName,pm.* FROM patient_master pm WHERE Pm.Patient_ID=@PatId ", CommandType.Text, new
        {
            PatId = PatientID,
        });
        if (dt == null || dt.Rows.Count == 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Enter Valid PatientID", message = "" });
        }

        string AbhaName = dtabhareg.Rows[0]["Name"].ToString();
        string AbhaMobile = dtabhareg.Rows[0]["Mobile"].ToString();
        string Name = dt.Rows[0]["PatientFullName"].ToString();
        string Mobile = dt.Rows[0]["Mobile"].ToString();
        if (AbhaName.ToLower().Trim() != Name.ToLower().Trim())
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Patient is not valid", message = "" });
        }
        //if (AbhaMobile != Mobile)
        //{
        //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Patient is not valid", message = "" });
        //}
        if (MT.IsInjectedString(PatientID) || MT.IsInjectedString(AbhaNo))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Invalid Request", message = "" });

        }
        dt = excuteCMD.GetDataTable(" Select * From patient_master pm where pm.AbhaHealthIdNo=@AbhaNumber ", CommandType.Text, new
        {
            AbhaNumber = AbhaNo
        });
        if (dt != null && dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Abha Number is Already Mapped With PatientID '" + dt.Rows[0]["PatientID"].ToString() + "'", message = "" });
        }
        dt = new DataTable();

        dt = excuteCMD.GetDataTable("Select * From abha_registration pm where Pm.PatientId=@PatId", CommandType.Text, new
        {
            PatId = PatientID,
        });
        if (dt != null && dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "PatientId Is Already Mapped With Abha Number '" + dt.Rows[0]["HealthIdNumber"].ToString() + "'", message = "" });
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("UPDATE abha_registration  ar  SET ar.PatientId=@PatientId ,ar.MappedBy=@MappedBy, ar.MappedDate=NOW() WHERE ar.HealthIdNumber=@HealthIdNumber");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                       {
                           PatientId = PatientID,
                           MappedBy = HttpContext.Current.Session["ID"].ToString(),
                           HealthIdNumber = AbhaNo
                       });

            sb = new StringBuilder();
            sb.Append("UPDATE patient_master pm SET pm.AbhaHealthIdNo=@AbhaHealthIdNo  WHERE pm.PatientId=@PatientId");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                PatientId = PatientID,
                AbhaHealthIdNo = AbhaNo
            });

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage, message = "" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }



    // Abha Registration  And Mapped to UHID Parts END//
    // Abha Login Start//


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string AuthInitiation(string LoginWith, string AbhaNumber)
    {
        if (MT.IsInjectedString(LoginWith) || MT.IsInjectedString(AbhaNumber))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "Too Many Request." });
        }
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();


        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.BaseUrl);

            try
            {
                string urldat = "v1/auth/init";
                var data = new { authMethod = LoginWith, healthid = AbhaNumber };

                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);

                if (responseMessage.IsSuccessStatusCode)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, message = "" });

                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, message = "" });
                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, details = new { message = AllGlobalFunction.errorMessage } }, message = ex.Message });

            }


        }


    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string AuthVerification(string LoginWith, string OTP, string TxnId)
    {
        if (MT.IsInjectedString(LoginWith) || MT.IsInjectedString(OTP) || MT.IsInjectedString(TxnId))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "Too Many Request." });
        }
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();


        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.BaseUrl);

            try
            {

                string urldat = "";
                if (LoginWith == "MOBILE_OTP")
                {
                    urldat = "v1/auth/confirmWithMobileOTP";
                }
                else if (LoginWith == "AADHAAR_OTP")
                {
                    urldat = "v1/auth/confirmWithAadhaarOtp";
                }

                var data = new { otp = OTP, txnId = TxnId };

                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);

                if (responseMessage.IsSuccessStatusCode)
                {
                    AbhaXTokenRes FetchDat = JsonConvert.DeserializeObject<AbhaXTokenRes>(recivedata);

                    ABHATokenResponceModel NewtokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();
                    using (var Newclient = ABHAClientHelper.GetClient(NewtokenResponse.AccessToken))
                    {

                        ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

                        Newclient.BaseAddress = new Uri(ABHABasicData.BaseUrl);
                        Newclient.DefaultRequestHeaders.Add("X-Token", "Bearer " + FetchDat.XToken);
                        try
                        {

                            string Newurldat = "v1/account/profile";

                            var Newdata = new { };

                            System.Net.Http.HttpResponseMessage NewresponseMessage = Newclient.PostAsJsonAsync(Newurldat, Newdata).GetAwaiter().GetResult();
                            string Newstatus_code = NewresponseMessage.StatusCode.ToString();

                            string Newrecivedata = NewresponseMessage.Content.ReadAsStringAsync().Result;
                            object NewSeralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(Newrecivedata);
                            if (NewresponseMessage.IsSuccessStatusCode)
                            {
                                ABHARegisteredDetails NewFetchDat = JsonConvert.DeserializeObject<ABHARegisteredDetails>(Newrecivedata);
                                 
                                bool IsSave = SaveFetchData(NewFetchDat);
                                
                                string MappedPatientID = IsPatientMapped(NewFetchDat.healthIdNumber);

                                bool IsMappedPatient = false;

                                if (!string.IsNullOrEmpty(MappedPatientID))
                                {
                                    IsMappedPatient = true;                                   
                                }


                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = NewSeralizedata, message = "", IsMappedPatient = IsMappedPatient, MappedPatientID = MappedPatientID });

                            }
                            else
                            {
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = NewSeralizedata, message = "" });
                            }

                        }
                        catch (Exception ex)
                        {
                            ClassLog cl = new ClassLog();
                            cl.errLog(ex);
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, details = new { message = AllGlobalFunction.errorMessage } }, message = ex.Message });

                        }


                    }

                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, message = "" });
                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, details = new { message = AllGlobalFunction.errorMessage } }, message = ex.Message });

            }


        }


    }



    public string IsPatientMapped(string AbhaNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ifnull(ab.PatientId,'') FROM abha_registration ab WHERE ab.HealthIdNumber=@AbhaNo ");
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string Value = excuteCMD.ExecuteScalar(sb.ToString(), new
        {
            AbhaNo = AbhaNo
        });
        return Value;

    }



    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string ResendAuthOTP(string LoginWith, string TxnId)
    {
        if (MT.IsInjectedString(LoginWith) || MT.IsInjectedString(TxnId))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "Too Many Request." });
        }
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();


        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.BaseUrl);

            try
            {
                string urldat = "v1/auth/resendAuthOTP";
                var data = new { authMethod = LoginWith, txnId = TxnId };

                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);

                if (responseMessage.IsSuccessStatusCode)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, message = "" });

                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, message = "" });
                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, details = new { message = AllGlobalFunction.errorMessage } }, message = ex.Message });

            }


        }


    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string ExistsByHealthId(string HealthId)
    {
        bool b = MT.SaveRequestCount(16);
        int ReqCount = MT.GetIPCount(16);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Too Many Request Try After Some Time." } }, message = "Too Many Request." });
        }
        
        if (MT.IsInjectedString(HealthId))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { error = new { message = "Invalid Request" } }, message = "Too Many Request." });
        }
        // string recivedata = "";
        ABHATokenResponceModel tokenResponse = ABHAGetBearerToken.GetAbhaAccessToken();


        using (var client = ABHAClientHelper.GetClient(tokenResponse.AccessToken))
        {
            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

            client.BaseAddress = new Uri(ABHABasicData.BaseUrl);

            try
            {
                string urldat = "v1/search/existsByHealthId";
                var data = new { healthId = HealthId };

                System.Net.Http.HttpResponseMessage responseMessage = client.PostAsJsonAsync(urldat, data).GetAwaiter().GetResult();
                string status_code = responseMessage.StatusCode.ToString();

                string recivedata = responseMessage.Content.ReadAsStringAsync().Result;
                object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);

                if (responseMessage.IsSuccessStatusCode)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Seralizedata, message = "" });

                }
                else
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Seralizedata, message = "" });
                }

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = new { message = AllGlobalFunction.errorMessage, details = new { message = AllGlobalFunction.errorMessage } }, message = ex.Message });

            }


        }


    }

    public bool AbhaMobileverification(string MobileNo, string TnxId, int Type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {

            StringBuilder sb = new StringBuilder();

            if (Type == 0)
            {
                sb.Append("insert into abha_mobileverification (MobileNo,TnxId,IsActive,IsVerified,EntryDate)");
                sb.Append(" Values (@MobileNo,@TnxId,@IsActive,@IsVerified,Now())");

                excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                {
                    MobileNo = MobileNo,
                    TnxId = TnxId,
                    IsActive = 1,
                    IsVerified = 0
                });
            }
            else
            {
                sb.Append("update abha_mobileverification am set am.IsVerified=@IsVerified ");
                if (Type == 2)
                {
                    sb.Append(" am.IsActive=0 ");
                }

                sb.Append(" where TnxId=@TnxId and  IsActive=1 and IsVerified=0 and  Date(EntryDate)=Date(Now())  ");
                excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                {
                    TnxId = TnxId,
                    IsVerified = 1
                });
            }



            tnx.Commit();

            return true;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }



    public bool IsAbhaMobileverification(string TnxId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT COUNT(am.Id) FROM  abha_mobileverification am ");
        sb.Append(" WHERE am.TnxId='" + TnxId + "' AND am.IsVerified=1 AND am.EntryDate>=DATE_ADD(NOW(),INTERVAL -10 MINUTE) ");
        int Value = Util.GetInt(StockReports.ExecuteScalar(sb.ToString()));
        if (Value > 0)
        {
            return true;
        }
        else
        {
            return false;
        }

        
    }

}

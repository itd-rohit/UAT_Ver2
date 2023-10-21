using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Script.Serialization;
using paytm;
using System.IO;
using System.Text;
using MySql.Data.MySqlClient;
using System.Data;
/// <summary>
/// Summary description for Paytm
/// </summary>
/// 
public class PaymentGateway
{

    public PaymentGateway()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static string PaytmMid
    {
        get
        {

            return "Maxhea53767489304687";
        }
    }

    public static string PaytmGuid
    {
        get
        {

            return "7dd71911-9812-4af3-a705-e07dcafa03cd"; 
        }
    }
    public static string PaytmKey
    {
        get
        {

            return "5RJUu7OV_d2aEAy1";
        }
    }

    public static string currencyCode
    {
        get
        {

            return "INR";
        }
    }

    public static string platformName
    {
        get
        {

            return "PayTM";
        }
    }
    public static string channel
    {
        get
        {

            return "POS";
        }
    }
    public static string version
    {
        get
        {
            return "1.0";
        }
    }

    public static string ipAddress
    {
        get
        {
            return Dns.GetHostByName(Dns.GetHostName()).AddressList[0].ToString();
        }
    }


    public static string withdrawal(string phone, string otp, string posId, string comment, string totalAmount, string merchantOrderId)
    {

        string value = "https://trust-uat.paytm.in/wallet-web/v7/withdraw";
        /// string value = "https://trust.paytm.in/wallet-web/v7/withdraw";

        Dictionary<string, string> innerrequest = new Dictionary<string, string>();
        Dictionary<string, string> outerrequest = new Dictionary<string, string>();

        innerrequest.Add("merchantGuid", PaymentGateway.PaytmGuid);
        innerrequest.Add("totalAmount", totalAmount);
        innerrequest.Add("merchantOrderId", merchantOrderId);
        innerrequest.Add("currencyCode", PaymentGateway.currencyCode);
        innerrequest.Add("posId", posId);
        innerrequest.Add("industryType", "Retail");
        innerrequest.Add("comment", comment);
        String first_jason = new JavaScriptSerializer().Serialize(innerrequest);
        outerrequest.Add("request", first_jason);
        outerrequest.Add("platformName", PaymentGateway.platformName);
        outerrequest.Add("ipAddress", PaymentGateway.ipAddress);
        outerrequest.Add("operationType", "WITHDRAW_MONEY"); //WITHDRAW_MONEY
        outerrequest.Add("channel", PaymentGateway.channel);
        outerrequest.Add("version", PaymentGateway.version);
        String Second_jason = new JavaScriptSerializer().Serialize(outerrequest);
        try
        {

            Second_jason = Second_jason.Replace("\\", "").Replace(":\"{", ":{").Replace("}\",", "},");
            string Check = paytm.CheckSum.generateCheckSumByJson(PaymentGateway.PaytmKey, Second_jason);
            String url = value;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Headers.Add("mid", PaymentGateway.PaytmGuid);
            request.Headers.Add("phone", phone);
            request.Headers.Add("otp", otp);
            request.Headers.Add("checksumhash", Check);
            request.Headers.Add("ContentType", "application/json");
            request.Method = "POST";
            var time = DateTime.Now;
            using (StreamWriter requestWriter2 = new StreamWriter(request.GetRequestStream()))
            {
                requestWriter2.Write(Second_jason);
            }
            string responseData = string.Empty;
            using (StreamReader responseReader = new StreamReader(request.GetResponse().GetResponseStream()))
            {
                responseData = responseReader.ReadToEnd();
                // Response.Write("RequestJson= " + Second_jason.ToString());
                return responseData.ToString();
            }
        }
        catch (UriFormatException uri_expec)
        {
            return uri_expec.ToString();
        }
        catch (paytm.exception.CryptoException keyexcep)
        {
            return keyexcep.ToString();
        }
        catch (System.Web.HttpRequestValidationException ex)
        {
            return ex.ToString();
        }
        catch (WebException ex)
        {
            Stream s = ex.Response.GetResponseStream();
            StreamReader sr = new StreamReader(s);
            string m = sr.ReadToEnd();
            return m;
        }
    }

    public static string Refund(string refundRefId, string merchantOrderId, string totalAmount, string walletSystemTxnId)
    {


        string value = "https://trust-uat.paytm.in/wallet-web/refundWalletTxn";
        Dictionary<string, string> innerrequest = new Dictionary<string, string>();
        Dictionary<string, string> outerrequest = new Dictionary<string, string>();
        innerrequest.Add("merchantGuid", PaymentGateway.PaytmGuid);
        innerrequest.Add("amount", totalAmount);
        innerrequest.Add("merchantOrderId", merchantOrderId);
        innerrequest.Add("currencyCode", PaymentGateway.currencyCode);
        innerrequest.Add("txnGuid", walletSystemTxnId);
        innerrequest.Add("refundRefId", refundRefId);
        String first_jason = new JavaScriptSerializer().Serialize(innerrequest);
        outerrequest.Add("request", first_jason);
        outerrequest.Add("platformName", PaymentGateway.platformName);
        outerrequest.Add("ipAddress", PaymentGateway.ipAddress);
        outerrequest.Add("operationType", "REFUND_MONEY"); //WITHDRAW_MONEY
        outerrequest.Add("channel", PaymentGateway.channel);
        outerrequest.Add("version", PaymentGateway.version);
        String Second_jason = new JavaScriptSerializer().Serialize(outerrequest);
        try
        {
            Second_jason = Second_jason.Replace("\\", "").Replace(":\"{", ":{").Replace("}\",", "},");
            string Check = paytm.CheckSum.generateCheckSumByJson(PaymentGateway.PaytmKey, Second_jason);
            String url = value;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Headers.Add("mid", PaymentGateway.PaytmGuid);
            request.Headers.Add("checksumhash", Check);
            request.Headers.Add("ContentType", "application/json");
            request.Method = "POST";
            using (StreamWriter requestWriter2 = new StreamWriter(request.GetRequestStream()))
            {
                requestWriter2.Write(Second_jason);
            }
            string responseData = string.Empty;
            using (StreamReader responseReader = new StreamReader(request.GetResponse().GetResponseStream()))
            {
                responseData = responseReader.ReadToEnd();
                return responseData.ToString();
            }
        }
        catch (UriFormatException uri_expec)
        {
            return uri_expec.ToString();
        }
        catch (paytm.exception.CryptoException keyexcep)
        {
            return keyexcep.ToString();
        }
        catch (System.Web.HttpRequestValidationException ex)
        {
            return ex.ToString();
        }
        catch (WebException ex)
        {
            Stream s = ex.Response.GetResponseStream();
            StreamReader sr = new StreamReader(s);
            string m = sr.ReadToEnd();
            return m;
        }
    }

}

public class PaymentResponse
{
    public string type { get; set; }
    public string requestGuid { get; set; }
    public string orderId { get; set; }
    public string status { get; set; }
    public string statusCode { get; set; }
    public string statusMessage { get; set; }    
    public string metadata { get; set; }
    public PaymentInnerResponse response { get; set; }

}
public class PaymentInnerResponse
{

    public string userGuid { get; set; }
    public string pgTxnId { get; set; }
    public string timestamp { get; set; }
    public string cashBackStatus { get; set; }
    public string cashBackMessage { get; set; }
    public string state { get; set; }
    public string heading { get; set; }
    public string walletSysTransactionId { get; set; }
    public string walletSystemTxnId { get; set; }
    public string comment { get; set; }
    public string posId { get; set; }
    public string txnAmount { get; set; }
    public string merchantOrderId { get; set; }
    public string uniqueReferenceLabel { get; set; }
    public string uniqueReferenceValue { get; set; }
    public string pccCode { get; set; }
    public string refundTxnGuid { get; set; }
    public string refundTxnStatus { get; set; }
}


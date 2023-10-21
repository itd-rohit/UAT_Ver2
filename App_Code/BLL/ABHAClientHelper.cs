﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for ABHAClientHelper
/// </summary>
public class ABHAClientHelper
{
    // Basic auth
    public static HttpClient GetClient(string username, string password)
    {
        var authValue = new AuthenticationHeaderValue("Basic",
        Convert.ToBase64String(Encoding.UTF8.GetBytes("" + username + ":" + password + "")));
        var client = new HttpClient()
        {
            DefaultRequestHeaders = { Authorization = authValue }
        };
        return client;
    }
    // Auth with bearer token (You already have a bearer token)
    public static HttpClient GetClient(string token)
    {
        var authValue = new AuthenticationHeaderValue("Bearer", token);
        var client = new HttpClient()
        {
            DefaultRequestHeaders = { Authorization = authValue }
        };
        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        client.DefaultRequestHeaders.Add("Accept-Language", "en-US"); 
        return client;
    }
}
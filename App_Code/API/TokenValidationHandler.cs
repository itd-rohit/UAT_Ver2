﻿using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using Microsoft.IdentityModel.Tokens;


public class TokenValidationHandler : DelegatingHandler
{
    private static bool TryRetrieveToken(HttpRequestMessage request, out string token)
    {
        token = null;
        IEnumerable<string> authzHeaders;
        if (!request.Headers.TryGetValues("Authorization", out authzHeaders) || authzHeaders.Count() > 1)
        {
            return false;
        }
        var bearerToken = authzHeaders.ElementAt(0);
        token = bearerToken.StartsWith("Bearer ") ? bearerToken.Substring(7) : bearerToken;
        return true;
    }

    protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
    {
        HttpStatusCode statusCode;
        string token;

        //chek if a token exists in the request header
        if (!TryRetrieveToken(request, out token))
        {
            statusCode = HttpStatusCode.Unauthorized;
            //allow requests with no token - whether a action method needs an authentication can be set with the claimsauthorization attribute
            return base.SendAsync(request, cancellationToken);
        }

        try
        {
            const string secretKey = "C428A377979E395725A6A1A13A0CE0D25F1B30B7DAE0EFB06F26F79EDC149472";
            var securityKey = new SymmetricSecurityKey(System.Text.Encoding.Default.GetBytes(secretKey));

            SecurityToken securityToken;
            var handler = new JwtSecurityTokenHandler();

            //Replace the issuer and audience with your URL (ex. http:localhost:12345)
            var validationParameters = new TokenValidationParameters
            {
                ValidAudience = "http://localhost:12345/",
                ValidIssuer = "http://localhost:12345/",
                ValidateIssuer = true,
                ValidateLifetime = true,
                ValidateIssuerSigningKey = true,
                LifetimeValidator = LifetimeValidator,
                IssuerSigningKey = securityKey
            };
            

            //extract and assign the user of the jwt
            Thread.CurrentPrincipal = handler.ValidateToken(token, validationParameters, out securityToken);
            HttpContext.Current.User = handler.ValidateToken(token, validationParameters, out securityToken);

            return base.SendAsync(request, cancellationToken);
        }
        catch (SecurityTokenValidationException)
        {
            statusCode = HttpStatusCode.Unauthorized;
        }
        catch (Exception ex)
        {
            statusCode = HttpStatusCode.Unauthorized;
        }
        return Task<HttpResponseMessage>.Factory.StartNew(() => new HttpResponseMessage(statusCode) { }, cancellationToken);
    }

    public bool LifetimeValidator(DateTime? notBefore,
        DateTime? expires,
        SecurityToken securityToken,
        TokenValidationParameters validationParameters)
    {
        if (expires == null) return false;
        return DateTime.UtcNow < expires;
    }

}
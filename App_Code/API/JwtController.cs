﻿using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Web.Http;
using Microsoft.IdentityModel.Tokens;


namespace WebAPIwithJWT.Controllers
{
    [RoutePrefix("Login")]
    public class LoginController : ApiController
    {

        //[HttpGet]
        //[Authorize]
        //[Route("ok")]
        //public IHttpActionResult Authenticated() => Ok("Authenticated");

        //[HttpGet]
        //[Route("notok")]
        //public IHttpActionResult NotAuthenticated() => Unauthorized();


        [HttpPost]
        [Route("Login")]
        public IHttpActionResult Authenticate([FromBody] LoginVM loginVM)
        {
            var loginResponse = new LoginResponseVM();
            var loginrequest = new LoginVM
            {
                Email = loginVM.Email.ToLower(),
                Password = loginVM.Password
            };

            var isUsernamePasswordValid = loginrequest.Password == "admin";
            // if credentials are valid
            if (isUsernamePasswordValid)
            {
                var token = CreateToken(loginrequest.Email);
                //return the token
                return Ok(token);
            }
            // if credentials are not valid send unauthorized status code in response
            loginResponse.responseMsg.StatusCode = HttpStatusCode.Unauthorized;
            IHttpActionResult response = ResponseMessage(loginResponse.responseMsg);
            return response;
        }


        private string CreateToken(string email)
        {
            //Set issued at date
            DateTime issuedAt = DateTime.UtcNow;
            //set the time when it expires
            DateTime expires = DateTime.UtcNow.AddDays(7);

            //http://stackoverflow.com/questions/18223868/how-to-encrypt-jwt-security-token
            var tokenHandler = new JwtSecurityTokenHandler();

            //create a identity and add claims to the user which we want to log in
            var claimsIdentity = new ClaimsIdentity(new[]
            {
                new Claim(ClaimTypes.UserData, email),
                new Claim(ClaimTypes.Name,"Shatrughan")
            }); ;

            const string secrectKey = "ItD0se/@2020731/SHatRUgHaN+==HlS8527048626GhwX@z74NV1Xi3Sb3Vj";
            var securityKey = new SymmetricSecurityKey(System.Text.Encoding.Default.GetBytes(secrectKey));
            var signingCredentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256Signature);


            //Create the jwt (JSON Web Token)
            //Replace the issuer and audience with your URL (ex. http:localhost:12345)
            var token =
                (JwtSecurityToken)
                tokenHandler.CreateJwtSecurityToken(
                issuer: "http://localhost:12345/",
                audience: "http://localhost:12345/",
                subject: claimsIdentity,
                notBefore: issuedAt,
                expires: expires,
                signingCredentials: signingCredentials);

            var tokenString = tokenHandler.WriteToken(token);

            return tokenString;

        }
    }
}

using MySql.Data.MySqlClient;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

public class WebApiM2Patient : ApiController
{
    // GET api/<controller>
    public IEnumerable<string> Get()
    {
        return new string[] { "value1", "value2" };
    }



    [HttpGet]
    [ActionName("GetPageData")]
    public HttpResponseMessage GetPageData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        HttpError err = new HttpError();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT * FROM abha_registration").Tables[0])
            {
                err.Add("status", true);
                err.Add("message", "Success");
                err.Add("data", JArray.FromObject(dt));
                return Request.CreateErrorResponse(HttpStatusCode.Accepted, err);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("status", false);
            err.Add("message", "No Record Found");
            err.Add("data", "");
            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }



    // GET api/<controller>/5
    public string Get(int id)
    {
        return "value";
    }

    // POST api/<controller>
    public void Post([FromBody]string value)
    {
    }

    // PUT api/<controller>/5
    public void Put(int id, [FromBody]string value)
    {
    }

    // DELETE api/<controller>/5
    public void Delete(int id)
    {
    }
}

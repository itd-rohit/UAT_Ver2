using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web.Http;
using System.Web.Script.Serialization;

/// <summary>
/// Summary description for MDRCLisApiController
/// </summary>
/// 
[Route("api/[controller]/[action]")]
public class MDRCLisApiController:ApiController
{
    [HttpPost]
    [ActionName("FetchPatient")]
    public object Fetchpatientdetails([FromBody] FetchpatientdetailsReq _patientdetails)
    {
         var Mobile = "";
        var Barcode = "";
        try
        {
            Mobile = _patientdetails.Mobile.ToString();
           
        }
        catch
        {

        }

        try
        {
            Barcode = _patientdetails.Barcode.ToString();
        }
        catch
        {

        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            if (string.IsNullOrEmpty(Mobile) && string.IsNullOrEmpty(Barcode))
            {
                string message = "{\"statusCode\": 0,\"statusMessage\": \"Kindly Send Mobile No. or Barcode no \",\"data\": null}";
                return JsonConvert.DeserializeObject(message);
            }

            StringBuilder sb = new StringBuilder();
            if(Mobile!=""){
                sb = new StringBuilder();
                sb.Append("SELECT pm.`Patient_ID` ID,pm.`PName`,pm.`City` FROM patient_master pm WHERE mobile=@mobile  ");
            }
            else if (Barcode != "") {
                sb = new StringBuilder();
                sb.Append("SELECT pm.`Patient_ID` ID,pm.`PName`,pm.`City` FROM patient_master pm WHERE patient_id=(SELECT patient_id FROM `patient_labinvestigation_opd` WHERE BarcodeNo=@barcode LIMIT 1) ");

            }

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@mobile", Mobile),
                           new MySqlParameter("@barcode", Barcode)).Tables[0];
            List<FetchPatientRes> reslist = new List<FetchPatientRes>();
            foreach (DataRow dw in dt.Rows)
            {
                FetchPatientRes res = new FetchPatientRes();
                res.Id = dw["ID"].ToString();
                res.Name = dw["PName"].ToString();
                res.City = dw["City"].ToString();
                reslist.Add(res);
               
            }

             if (dt.Rows.Count > 0)
            {
                string message = "{\"statusCode\": 1,\"statusMessage\": \"SUCCESS\",\"data\": " + JsonConvert.SerializeObject(reslist) + " }";
                return JsonConvert.DeserializeObject(message);
            }
            else
            {

                string message = "{\"statusCode\": 0,\"statusMessage\": \"DATA NOT FOUND\",\"data\": null}";
                return JsonConvert.DeserializeObject(message);
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            string message = "{\"statusCode\": 0,\"statusMessage\": \"DATA NOT FOUND\",\"data\": null}";
            return JsonConvert.DeserializeObject(message);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

}


public class FetchpatientdetailsReq
{
    public string Mobile { get; set; }
    public string Barcode { get; set; }
}

public class FetchPatientRes
{
    public string Id { get; set; }
    public string Name { get; set; }
    public string City { get; set; }
}
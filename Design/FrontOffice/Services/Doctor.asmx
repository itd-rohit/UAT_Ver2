<%@ WebService Language="C#" Class="Doctor" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Web.Script.Services;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class Doctor : System.Web.Services.WebService
{

    public Doctor()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }


    
    [WebMethod(EnableSession = true)]
    public string BindDept(string Type)
    {
        ReferDoctor objReferDoctor = new ReferDoctor();
        DataTable dt = objReferDoctor.BindDept(Type);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    
    
    [WebMethod(EnableSession = true)]
    public string checkduplicatedoctor(string mobile)
    {
        return StockReports.ExecuteScalar("SELECT COUNT(*) FROM `doctor_referal` WHERE mobile='" + mobile + "' ");
    }
    [WebMethod(EnableSession = true)]
    public string AddNewDoctor(string Title, string Name, string Phone1, string Mobile, string Street_Name, string Specialization, string DocCode, string Email, string ClinicName, string Degree, string doctype, string visitday, int GroupID, string StateID, string CityID, string ZoneID, string LocalityID,string ReferShare,string ReferMaster,string PRO)
    {
        string response = "";
        ReferDoctor objReferDoctor = new ReferDoctor();
        response = objReferDoctor.AddNewDoctor(Title, Name, Phone1, Mobile, Street_Name, Specialization, DocCode, Email, ClinicName, Degree, doctype, visitday, GroupID, StateID, CityID, ZoneID, LocalityID, ReferShare, ReferMaster,PRO);
        if (response != "0")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved" });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved" });
    }
    [WebMethod(EnableSession = true)]
    public string getReferDoctor()
    {
        string strQuery = " SELECT CONCAT((CONCAT_WS(' # ',TRIM(NAME),TRIM(Mobile),CONCAT(IFNULL(TRIM(House_No),''), IFNULL(TRIM(Locality),''),IFNULL(TRIM(Street_Name),''),IFNULL(TRIM(City),'')))),'@',TRIM(Doctor_ID)) Doctor FROM doctor_referal WHERE IsActive = 1 AND TRIM(NAME)<>'' ORDER BY NAME ";
        DataTable dt = StockReports.GetDataTable(strQuery);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}


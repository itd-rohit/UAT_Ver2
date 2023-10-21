<%@ WebService Language="C#" Class="PatientLabSearch" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using MySql.Data.MySqlClient;



/// <summary>
/// Summary description for PatientLabSearch
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class PatientLabSearch : System.Web.Services.WebService
{

    public PatientLabSearch()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Search_WorkSheet(string LabNo, string RegNo,
        string PName, string CentreID, string dtFrom, string dtTo, string SearchByDate, string Dept, string Status,
        string PhoneNo, string Mobile, string refrdby, string Ptype, string TimeFrm, string TimeTo, string FromLabNo, string ToLabNo, string PanelID, string CardNoFrom, string CardNoTo, string InvestigationID, string isUrgent, string slidenumber, string macid, string rerun, string colorCode,string SinNo)
    {
        PatientSearch objSearch = new PatientSearch();
        DataTable dtresult = objSearch.SearchWorkSheet(LabNo, RegNo, PName, CentreID, dtFrom, dtTo, SearchByDate, Dept, Status,
         PhoneNo, Mobile, refrdby, Ptype, TimeFrm, TimeTo, FromLabNo, ToLabNo, PanelID, CardNoFrom, CardNoTo, InvestigationID, isUrgent, slidenumber, macid, rerun, colorCode, SinNo);
        return Util.getJson(dtresult);

    }

    [WebMethod(EnableSession = true)]
    public void sendData(string ConcatVal)
    {

        Session["WorkSheetData"] = ConcatVal;

    }



}


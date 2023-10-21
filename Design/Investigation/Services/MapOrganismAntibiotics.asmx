<%@ WebService Language="C#" Class="MapOrganismAntibiotics" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
[ScriptService]
public class MapOrganismAntibiotics  : System.Web.Services.WebService {
    
    [WebMethod(EnableSession = true)]
    public string GetObservationData(string OrganismID)
    {
        MapOrganism_Antibiotics ObjMapOrganismAntibiotics = new MapOrganism_Antibiotics();
        return JsonConvert.SerializeObject(ObjMapOrganismAntibiotics.GetObservation_Data(OrganismID));   
    }
    [WebMethod(EnableSession = true)]
    public string SaveObservation(string OrganismID, string ObservationId)
    {
        MapOrganism_Antibiotics ObjMapOrganismAntibiotics = new MapOrganism_Antibiotics();
        return ObjMapOrganismAntibiotics.SaveObservation(OrganismID, ObservationId);     
    }   
    [WebMethod(EnableSession = true)]
    public string RemoveObservation(string OrganismID, string ObservationId)
    {
        MapOrganism_Antibiotics ObjMapOrganismAntibiotics = new MapOrganism_Antibiotics();
        return ObjMapOrganismAntibiotics.RemoveObservation(OrganismID, ObservationId);     
    }
    [WebMethod(EnableSession = true)]
    public string SaveMapping(string OrganismID, string Order)
    {
        MapOrganism_Antibiotics ObjMapOrganismAntibiotics = new MapOrganism_Antibiotics();
        return ObjMapOrganismAntibiotics.SaveMapping(OrganismID, Order);
        
    }    
}


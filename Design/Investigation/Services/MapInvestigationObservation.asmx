<%@ WebService Language="C#" Class="MapInvestigationObservation" %>

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
[ScriptService]
public class MapInvestigationObservation : System.Web.Services.WebService
{

    [WebMethod(EnableSession = true)]
    public string GetObservation(string InvestigationID)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return JsonConvert.SerializeObject(ObjMapInvObs.Get_Observation(InvestigationID));
    }
    [WebMethod(EnableSession = true)]
    public string BindInvestigation()
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return JsonConvert.SerializeObject(ObjMapInvObs.Bind_Investigation());
    }
    [WebMethod(EnableSession = true)]
    public string BindListBox(string Dept)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return JsonConvert.SerializeObject(ObjMapInvObs.BindInvListBox(Dept));
    }

    [WebMethod(EnableSession = true)]
    public string GetObservationData2(string InvestigationID, string LabNo)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return JsonConvert.SerializeObject(ObjMapInvObs.GetObservation_Data2(InvestigationID, LabNo));
    }
    [WebMethod(EnableSession = true)]
    public string GetObservationData(string InvestigationID)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return JsonConvert.SerializeObject(ObjMapInvObs.GetObservation_Data(InvestigationID));
    }
    [WebMethod(EnableSession = true)]
    public string GetMapObservation(string LabObservationID)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        DataTable dt = ObjMapInvObs.GetMapObservation(LabObservationID);
        if (dt.Rows.Count > 0)
            return dt.Rows[0]["InvName"].ToString();
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string MapInvestigation(string InvestigationID, string RoleID)
    {
        return "";
    }
    [WebMethod(EnableSession = true)]
    public string SaveMapping(string InvestigationID, string Order)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.SaveMapping(InvestigationID, Order);
    }
    [WebMethod(EnableSession = true)]
    public string SaveObservation(string InvestigationID, string ObservationId)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.SaveObservation(InvestigationID, ObservationId);
    }
    [WebMethod(EnableSession = true)]
    public string RemoveObservation(string InvestigationID, string ObservationId)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.RemoveObservation(InvestigationID, ObservationId);
    }
    [WebMethod(EnableSession = true)]
    public string SaveNewInvestigation(string InvName, string TestCode, string DepartmentID, string DepartmentName, string ReportType, string SampleType, string ShortName, string IsOutSrc, string TimeLimit, string SampleQty, string SampleRmks, string ColorCode, string Gender, string showPtRpt, string ShowAnlysRpt, string ShowOnlnRpt, string IsAutoStore, string isUrgent, string SampleTypeID, string MaxDiscount, string Reporting, string Booking, int IsActive, string BillCategoryID, string IsOrganism, string IsCulture, string IsMic, string PrintSeparate, string PrintSampleName, string Rate, string autoconsume, string BillingCategory, string ConsentType, string labalert, string smstext, string temp, string fromage, string toage, string invtype, string sampledefined, string RequiredAttachment, string BaseRate, string AttchmentRequiredAt, string IsLMPRequired, string LMPDay, string IsQuantity, string TatIntimate, string ShowInRateList,  string ShowinTAT, string PrintTestCentre)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.SaveNewInvestigation(InvName, TestCode, DepartmentID, DepartmentName, ReportType, SampleType, ShortName, IsOutSrc, TimeLimit, SampleQty, SampleRmks, ColorCode, Gender, showPtRpt, ShowAnlysRpt, ShowOnlnRpt, IsAutoStore, isUrgent, SampleTypeID, MaxDiscount, Reporting, Booking, IsActive, BillCategoryID, IsOrganism, IsCulture, IsMic, PrintSeparate, PrintSampleName, Rate, autoconsume, BillingCategory, ConsentType, labalert, smstext, temp, fromage, toage, invtype, sampledefined, RequiredAttachment, BaseRate, AttchmentRequiredAt, IsLMPRequired, LMPDay, IsQuantity, TatIntimate, ShowInRateList,ShowinTAT, PrintTestCentre);

    }


    [WebMethod(EnableSession = true)]
    public string UpdateInvestigation(string InvName, string TestCode, string InvID, string ItemID, string DepartmentID, string InvObsId, string DepartmentName, string ReportType, string SampleType, string ShortName, string IsOutSrc, string TimeLimit, string SampleQty, string SampleRmks, string ColorCode, string Gender, string showPtRpt, string ShowAnlysRpt, string ShowOnlnRpt, string IsAutoStore, string isUrgent, string SampleTypeID, string MaxDiscount, string Reporting, string Booking, int IsActive, string BillCategoryID, string IsOrganism, string IsCulture, string IsMic, string PrintSeparate, string PrintSampleName, string Rate, string autoconsume, string BillingCategory, string ConsentType, string labalert, string smstext, string temp, string fromage, string toage, string invtype, string sampledefined, string RequiredAttachment, string BaseRate, string AttchmentRequiredAt, string IsLMPRequired, string LMPDay, string IsQuantity, string TatIntimate, string ShowInRateList,string ShowinTAT, string PrintTestCentre)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.UpdateInvestigation(InvName, TestCode, InvID, ItemID, DepartmentID, InvObsId, DepartmentName, ReportType, SampleType, ShortName, IsOutSrc, TimeLimit, SampleQty, SampleRmks, ColorCode, Gender, showPtRpt, ShowAnlysRpt, ShowOnlnRpt, IsAutoStore, isUrgent, SampleTypeID, MaxDiscount, Reporting, Booking, IsActive, BillCategoryID, IsOrganism, IsCulture, IsMic, PrintSeparate, PrintSampleName, Rate, autoconsume, BillingCategory, ConsentType, labalert, smstext, temp, fromage, toage, invtype, sampledefined, RequiredAttachment, BaseRate, AttchmentRequiredAt, IsLMPRequired, LMPDay, IsQuantity, TatIntimate, ShowInRateList, ShowinTAT, PrintTestCentre);
    }
    [WebMethod(EnableSession = true)]
    public string GetObservationDetails(string ObservationID, string InvestigationID, string Gender, string MacID, String MethodName, int CentreID, string type)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return JsonConvert.SerializeObject(ObjMapInvObs.GetObservation_Details(ObservationID, InvestigationID, Gender, MacID, MethodName, CentreID, type));
    }

    [WebMethod(EnableSession = true)]
    public string GetObsMasterData(string ObservationID)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return JsonConvert.SerializeObject(ObjMapInvObs.GetObs_MasterData(ObservationID));
    }
    [WebMethod(EnableSession = true)]
    public string updtObsRangesForAllInv(string ObservationName, string ObservationID, string InvestigationID, string ObsRangeData, string Gender, string ShortName, string Suffix, string AnylRpt, string IsCulture, string MacID, string RoundOff, string MethodName)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.updtObsRangesForAllInv(ObservationName, ObservationID, ObsRangeData, Gender, ShortName, Suffix, AnylRpt, IsCulture, MacID, RoundOff, MethodName);

    }

    [WebMethod(EnableSession = true)]
    public string updtObsRanges(string ObservationName, string ObservationID, string InvestigationID, string ObsRangeData, string Gender, string ShortName, string Suffix, string AnylRpt, string IsCulture, string MacID, string RoundOff, string MethodName, int CheckMethod, int MaleFemale, int CentreID, int ResultRequired, string MasterGender, string PrintSeparate, string Type, int AllCentre, int PrintInLabReport, int AllowDuplicateBooking, int ShowAbnormalAlert, int ShowDelta)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.updtObsRanges(ObservationName, ObservationID, InvestigationID, ObsRangeData, Gender, ShortName, Suffix, AnylRpt, IsCulture, MacID, RoundOff, MethodName, CheckMethod, MaleFemale, CentreID, ResultRequired, MasterGender, PrintSeparate, Type, AllCentre, PrintInLabReport, AllowDuplicateBooking, ShowAbnormalAlert, ShowDelta);

    }
    [WebMethod(EnableSession = true)]
    public string SaveNewObservation(string ObsName, string ShortName, string Suffix, string IsCulture, string ObsAnylRpt, string RoundOff, string Gender, string PrintSeparate, int PrintInLabReport, int AllowDuplicateBooking)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.SaveNewObservation(ObsName, ShortName, Suffix, IsCulture, ObsAnylRpt, RoundOff, Gender, PrintSeparate, PrintInLabReport, AllowDuplicateBooking);
    }
    [WebMethod(EnableSession = true)]
    public string SaveInvOrdering(string InvOrder)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.SaveInvOrdering(InvOrder);
    }
    [WebMethod(EnableSession = true)]
    public string GetInvPriorty(string SubCategoryId)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return JsonConvert.SerializeObject(ObjMapInvObs.Get_InvPriorty(SubCategoryId.Split('#')[0].Trim()));

    }
    [WebMethod(EnableSession = true)]
    public string GetDeptPriorty()
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return JsonConvert.SerializeObject(ObjMapInvObs.Get_DeptPriorty());
    }
    [WebMethod(EnableSession = true)]
    public string SaveDeptOrdering(string DeptOrder)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.SaveDeptOrdering(DeptOrder);
    }

    [WebMethod(EnableSession = true)]
    public string getTestCentre(string BookingCentre, string Department, string TestName)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return JsonConvert.SerializeObject(ObjMapInvObs.getTestCentre(BookingCentre, Department, TestName));
    }
    [WebMethod(EnableSession = true)]
    public string SaveTestCentre(string BookingCentre, string Investigation_ID, string TestCentre, string TestCentre1, string TestCentre2)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.SaveTestCentre(BookingCentre, Investigation_ID, TestCentre, TestCentre1, TestCentre2);

    }
    [WebMethod(EnableSession = true)]
    public string mappingInterpretation(string fromCentre, string toCentre, string fromMachine, string toMachine, string departmentID)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.mappingInterpretation(fromCentre, toCentre, fromMachine, toMachine, departmentID);
    }
}


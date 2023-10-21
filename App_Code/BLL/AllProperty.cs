using CrystalDecisions.Shared.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
/// <summary>
/// Summary description for DispatchDetail
/// </summary>
public class DispatchDetail
{
    public DispatchDetail()
    {
        //
        // TODO: Add constructor logic here
        //
        isDispatched = 0;
    }
    public string BatchNo { get; set; }
    public int Quantity { get; set; }
    public string FieldBoy { get; set; }
    public int FieldBoyID { get; set; }
    public string Courier { get; set; }
    public string DocketNo { get; set; }
    public int isDispatched { get; set; }
}

public class SampleSearch
{
    public int FromCentreID { get; set; }
    public int ToCentreID { get; set; }
    public string BatchNo { get; set; }
    public string BarcodeNo { get; set; }
    public int Quantity { get; set; }
    public string FieldBoyID { get; set; }
    public string FieldBoy { get; set; }
    public string CourierDetail { get; set; }
    public string CourierDocketNo { get; set; }
    public string Status { get; set; }
    public string SubCategoryID { get; set; }
    public string Test_ID { get; set; }
    public string Inhouse { get; set; }
    public string FromDate { get; set; }
    public string ToDate { get; set; }
    public string LedgerTransactionNo { get; set; }
    public string Barcode_Group { get; set; }
    public string Type { get; set; }
}

public class EmailTemplate
{
    public string PName { get; set; }
    public string Age { get; set; }
    public string Gender { get; set; }
    public string Centre { get; set; }
    public string GrossAmt { get; set; }
    public string DiscAmt { get; set; }
    public string NetAmt { get; set; }
    public string EmailTo { get; set; }
    public string LedgerTransactionID { get; set; }
}
public class Centre_Access
{
    public int CentreID { get; set; }
    public string Centre { get; set; }

}
public class TestCentre
{
    public string BookingCentre { get; set; }
    public string Investigation_ID { get; set; }
    public string TestCentre1 { get; set; }
    public string TestCentre2 { get; set; }
    public string TestCentre3 { get; set; }
    public string AllInvestigation_ID { get; set; }
}
public class JSONResponse
{
    public bool status { get; set; }
    public string response { get; set; }
    public string responseData { get; set; }
    public string responseDetail { get; set; }
}
public class Mac_Observation
{
    public string LabNo { get; set; }
    public string Machine_Id { get; set; }
    public string Machine_ParamID { get; set; }
    public string Reading { get; set; }
    public int isActive { get; set; }
    public string PatientName { get; set; }
    public string PatientId { get; set; }
    public DateTime dtRun { get; set; }
    public DateTime dtEntry { get; set; }
    public int isSync { get; set; }
    public string GroupId { get; set; }
    public string UpdateReason { get; set; }
    public string UpdateBy { get; set; }
    public int Type { get; set; }
    public string ParamName { get; set; }
    public string Interpretation { get; set; }
    public string ObservationName { get; set; }
}
public class patientDocumentList
{
    public int DocumentID { get; set; }
    public string DocumentName { get; set; }
    public string Patient_ID { get; set; }
}
public class DepartmentTokenNoDetail
{
    public int DepartmentTokenNo { get; set; }
    public string DepartmentDisplayName { get; set; }
}
public class ReportAccessList
{
    public bool status { get; set; }
    public string responseMsg { get; set; }
    public int DurationInDay { get; set; }
    public int ShowPdf { get; set; }
    public int ShowExcel { get; set; }
}
public class JSONResponseDataTable
{
    public bool status { get; set; }
    public string response { get; set; }
    public DataTable responseData { get; set; }
    public DataTable responseDetail { get; set; }
}

public class SMSDetailListRegistration
{
    public string LabNo { get; set; }
    public string PName { get; set; }
    public string PatientID { get; set; }
    public string Age { get; set; }
    public string Gender { get; set; }
    public string DOB { get; set; }
    public string GrossAmount { get; set; }
    public string DiscountAmount { get; set; }
    public string NetAmount { get; set; }
    public string PaidAmout { get; set; }
    public string UserName { get; set; }
    public string Passowrd { get; set; }
    public string AppointmentID { get; set; }
    public string AppointmentDate { get; set; }
    public string TinySmsAllowDisc { get; set; }
    public string TinySmsRejectDisc { get; set; }
    public string TinySmsAllowDiscRemotelink { get; set; }
    public string TinySmsRejectDiscRemotelink { get; set; }
    public string TinyURL { get; set; }
    public string ItemName { get; set; }
    public string Bal { get; set; }
    public string LoginID { get; set; }
    public string Password { get; set; }
    public string TemplateID { get; set; }
    public List<SMSTestListRegistration> TestDetails { get; set; }
}
public class SMSTestListRegistration
{
    public string TestName { get; set; }
}
public class OrderResponse
{
    public string success { get; set; }
    public string message { get; set; }
}
public class OrderResponseJArray
{
    public string success { get; set; }
    public string message { get; set; }

    public JArray data { get; set; }
}
public class OrderResponseData
{
    public string success { get; set; }
    public string message { get; set; }
    public string data { get; set; }
}
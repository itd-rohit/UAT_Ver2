using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for B2BMobileModel
/// </summary>
public class B2BMobileModel
{
    public int CentreID { get; set; }
    public string RoleName { get; set; }
    public string UserName { get; set; }
    public int Employee_Id { get; set; }
    public string NAME { get; set; }
    public string RoleID { get; set; }
    public string Centre { get; set; }
    public string Type1 { get; set; }
    public int IsInvoice { get; set; }
    public int IsSalesTeamMember { get; set; }
    public int IsHideRate { get; set; }
    public string Mobile { get; set; }
    public int panel_id { get; set; }
    public string AccessStoreLocation { get; set; }
    public string AccessDepartment { get; set; }
    public string Panel_Name { get; set; }
}
public class B2BLogin
{
    [Required(ErrorMessage = "username should not blank")]
    public string username { get; set; }
    [Required(ErrorMessage = "password should not blank")]
    public string password { get; set; }
}
public class ForgotPassword
{
   public  string UserName{get;set;}
   public string Mobile {get;set;}
   public string Email { get; set; }
   public string OTP { get; set; }
}
public class Savenewpassword
{
    public string Password { get; set; }
    public string Employeeid { get; set; }
   
}
public class Documentmaster
{
    public string ID { get; set; }
    public string DocName { get; set; }
   
}

public class ChangePassword
{
    public string UserName { get; set; }
    public string NewPassword { get; set; }
    public string UserType { get; set; }



}



public class AdvancePaymentSubmit
{
    public string EmployeeID { get; set; }
    public string Employeename { get; set; }
    public string DepositeDate { get; set; }
    public decimal AdvAmount { get; set; }
    public string BankName { get; set; }
    public string Remarks { get; set; }
    public string EntryType { get; set; }
    public int CentreID { get; set; }
    public string PaymentMode { get; set; }
    public string PaymentModeID { get; set; }
    public string CardNo { get; set; }
    public string CardDate { get; set; }
    public string Narration { get; set; }
    public decimal S_Amount { get; set; }
    public int S_CountryID { get; set; }
    public string S_Currency { get; set; }
    public string S_Notation { get; set; }
    public decimal C_Factor { get; set; }
    public decimal Currency_RoundOff { get; set; }
    public byte CurrencyRoundDigit { get; set; }
    public int Converson_ID { get; set; }
    public string CreditDebitNoteTypeID { get; set; }
    public string CreditDebitNoteType { get; set; }
    public int TypeOfPayment { get; set; }
    public int IsAgainstinvoice { get; set; }
    public DateTime? InvoiceDate { get; set; }
    public string InvoiceNo { get; set; }
    public decimal? InvoiceAmount { get; set; }
    public string TransactionID { get; set; }
}

public class ClientDepositReport
{
   
    public string FromDate { get; set; }
   
    public string ToDate { get; set; }


    public string SearchType { get; set; }
    public string PanelID { get; set; }
    public string AllClient { get; set; }
    public string DateType { get; set; }
     
}


public class GetRegistration
{
    public string EmployeeID { get; set; }
    public string Title { get; set; }
    

}
public class Welcome
{

    public string todayCount { get; set; }

    public string todayVal { get; set; }


    public string MonthCount { get; set; }
    public string MonthVal { get; set; }
    public string MonthlyExpected { get; set; }
    public string MonthlyExpectedval { get; set; }
    public string Outstanding { get; set; }
    public string Paidamount { get; set; }
}
public class Dispatch
{
   
    public string FromDate { get; set; }
   
    public string ToDate { get; set; }


    public string SearchType { get; set; }
    public string SearchValue { get; set; }
    public string Status { get; set; }
    public string PanelID { get; set; }
}


public class InvoiceReprint
{
    public string SearchType { get; set; }
    public string SearchValue { get; set; }
    public string LabNo { get; set; }
    public string Centre { get; set; }
    public string User { get; set; }
    public DateTime FromDate { get; set; }
    public DateTime ToDate { get; set; }
    public string FromTime { get; set; }
    public string ToTime { get; set; }
    public string PanelID { get; set; }

}
public class SearchSampleCollection
{
    public DateTime FromDate { get; set; }
    public string PanelID { get; set; }
    public DateTime ToDate { get; set; }
    public string BarcodeNO { get; set; }
    public string TestID { get; set; }
    public string SampleTypeID { get; set; }
    public string SampleTypeName { get; set; }
    public string LedgertransactionNo { get; set; }

   // LedgertransactionNo

    public string SampleStatus { get; set; }
}

public class B2BPatientRegistration {
    public string EmployeeId { get; set; }
    public string Id { get; set; }
    public string PanelId { get; set; }
    public string PageNo { get; set; }
    public string Investigation { get; set; }

    public string CenterId { get; set; }
    public string FromDate { get; set; }
    public string ToDate { get; set; }
    public string Client { get; set; }
    public string Type { get; set; }

    public string Mobile         { get; set; }
    public string PatientName    { get; set; }
    public string Gender         { get; set; }
    public string Address        { get; set; }
    public string City           { get; set; }
    public string Source         { get; set; }
    public string Year           { get; set; }
    public string Month          { get; set; }
    public string Day            { get; set; }
    public string Dob            { get; set; }
    public string ReferredDoctor { get; set; }
    public string Locality       { get; set; }
    public string State          { get; set; }
    public string Pro            { get; set; }

}
public class PatientUpdate
{
    public string EmpID { get; set; }
    public string Title { get; set; }
    public string PName { get; set; }
    public string Mobile { get; set; }
    public string DateOfBirth { get; set; }
    public string Address { get; set; }
    public string City { get; set; }
    public string Pincode { get; set; }
    public string Qualification { get; set; }
    public string Bloodgroup { get; set; }
    public string DocumentName { get; set; }
    public string DocumentNo { get; set; }

}
public class BookingData
{

    public string InterfaceClient { get; set; }
    public string Type { get; set; }
    public string srfNumber { get; set; }

    public string WorkOrderID { get; set; }
    public int WorkOrderID_Creat { get; set; }
    public string patientId { get; set; }
    public int Patient_ID_creat { get; set; }
    public string designation { get; set; }
    public string fullName { get; set; }
    public string Address { get; set; }
    public string localityid { get; set; }
    public string area { get; set; }
    public int cityid { get; set; }
    public string city { get; set; }
    public string PanelID { get; set; }
    public string CentreID { get; set; }
    public string stateid { get; set; }
    public string State { get; set; }
    public int Pincode { get; set; }
    public string Country { get; set; }
    public string Phone { get; set; }
    public string Mobile { get; set; }
    public string Email { get; set; }
    public DateTime dob { get; set; }
    public string age { get; set; }

    public int AgeYear { get; set; }
    public int AgeMonth { get; set; }
    public int AgeDays { get; set; }

    public string gender { get; set; }
    public string CentreID_Interface { get; set; }

    public int VIP { get; set; }
    public int isUrgent { get; set; }
    public int Doctor_ID { get; set; }

    public int Panel_ID { get; set; }
    public string DoctorName { get; set; }
    public string patientType { get; set; }
    public string HLMOPDIPDNo { get; set; }
    public string bed_type { get; set; }
    public string ward_name { get; set; }
    public string BarcodeNo { get; set; }
    public string ItemId_interface { get; set; }
    public string ItemName_interface { get; set; }
    public int ItemID_AsItdose { get; set; }
    public DateTime SampleCollectionDate { get; set; }
    public int SampleTypeID { get; set; }
    public string SampleTypeName { get; set; }
    public int IsBooked { get; set; }
    public string Response { get; set; }
    public DateTime dtAccepted { get; set; }
    public string TPA_Name { get; set; }
    public string Employee_id { get; set; }

    public string PackageName { get; set; }
    public string DoctorMobile { get; set; }
    public string TechnicalRemarks { get; set; }
    public int TestCount { get; set; }
    public int IsAllowPrint { get; set; }

    //New Add Variable
    public string labPatientId { get; set; }
    public string passportNo { get; set; }
    public string panNumber { get; set; }
    public string aadharNumber { get; set; }
    public string insuranceNo { get; set; }
    public string nationality { get; set; }
    public string ethnicity { get; set; }
    public string nationalIdentityNumber { get; set; }
    public string workerCode { get; set; }
    public string doctorCode { get; set; }
    public string PrintDob { get; set; }
    public int emergencyFlag { get; set; }
    public string totalAmount { get; set; }
    public string advance { get; set; }
    public string billDate { get; set; }
  //  public string paymentType { get; set; }
    public string referralName { get; set; }
    public string otherReferral { get; set; }
    public string sampleId { get; set; }
    public string orderNumber { get; set; }
    public string referralIdLH { get; set; }
    public string organisationName { get; set; }
    public string additionalAmount { get; set; }
    public string organizationIdLH { get; set; }
    public string comments { get; set; }
	// public string paymentType { get; set; }
  
	 public string paymentType { get; set; }
    public string paymentAmount { get; set; }
    public string issueBank { get; set; }
    public string chequeNo { get; set; }
    public List<testList> testList { get; set; }
   // public List<paymentList> paymentList { get; set; }
    //public billDetails billDetails { get; set; }

}
//public class billDetails
//{
   
    

//}
public class testList
{

    public string testID { get; set; }
    public float Rate { get; set; }
    public float DiscountAmt { get; set; }
    public string testCode { get; set; }
    public string integrationCode { get; set; }
    public string dictionaryId { get; set; }
    public string sampleId { get; set; }
    //  public List<paymentList> paymentList { get; set; }
}

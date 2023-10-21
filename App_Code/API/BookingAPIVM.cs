using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
/// <summary>
/// Summary description for BookingAPIVM
/// </summary>

public class BookingAPIVM
{

    [Required(ErrorMessage = "UserName can't be blank")]
    public string UserName { get; set; }
    [Required(ErrorMessage = "Password can't be blank")]
    public string Password { get; set; }
    [Required(ErrorMessage = "InterfaceClient can't be blank",AllowEmptyStrings=false)]
    public string InterfaceClient { get; set; }
    public string CentreID_interface { get; set; }
    public string Type { get; set; }
    public string WorkOrderID { get; set; }
    public string Patient_ID { get; set; }
    public string Title { get; set; }
    public string PName { get; set; }
    public string Address { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string Pincode { get; set; }
    public string Country { get; set; }
    public string Mobile { get; set; }
    public string Email { get; set; }
    public string DOB { get; set; }
    public string Gender { get; set; }
    public string isUrgent { get; set; }
    public string Doctor_ID { get; set; }
    public string DoctorName { get; set; }
    public string HLMPatientType { get; set; }
    public string HLMOPDIPDNo { get; set; }
    public string BarcodeNo { get; set; }
    public string ItemId_interface { get; set; }
    public string ItemName_interface { get; set; }
    public string SampleCollectionDate { get; set; }
    public string SampleTypeID { get; set; }
    public string SampleTypeName { get; set; }
    public string TPA_Name { get; set; }
    public string Employee_id { get; set; }
    public string PackageName { get; set; }
    public string TechnicalRemarks { get; set; }
    public string Interface_Doctor_Mobile { get; set; }
    public string Interface_PackageCategoryID { get; set; }
    public string AllowPrint { get; set; }
    public string BillNo { get; set; }
    public List<BookingTest> tests { get; set; }

}
public class BookingTest
{
    [Required(ErrorMessage = "InterfaceClient can't be blank", AllowEmptyStrings = false)]
    public string ItemId_interface { get; set; }
    public string ItemName_interface { get; set; }
    public string BarcodeNo { get; set; }
    public string SampleCollectionDate { get; set; }
    public string SampleTypeID { get; set; }
    public string SampleTypeName { get; set; }
    public string PackageName { get; set; }
    public string Interface_PackageCategoryID { get; set; }
    public string ClientPatientRate { get; set; }
}

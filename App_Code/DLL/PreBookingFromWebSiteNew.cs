using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;


/// <summary>
/// Summary description for PreBookingfromWwebsitenew
/// </summary>
public class PreBookingFromWebSiteNew
{
	   MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public PreBookingFromWebSiteNew()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public PreBookingFromWebSiteNew(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    public string PreBookingID { get; set; }
    public string Patient_ID { get; set; }
    public string Title { get; set; }
    public string PName { get; set; }
    public string Address { get; set; }
    public string Locality { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string Mobile { get; set; }
    public string Pincode { get; set; }
    public string Email { get; set; }
    public DateTime DOB { get; set; }
    public string Gender { get; set; }
   
    public string VisitType { get; set; }
    public int VIP { get; set; }
    public string PatientIDProof { get; set; }
    public string PatientIDProofNo { get; set; }
    public string PatientSource { get; set; }
  
    public string Remarks { get; set; }
    public int PreBookingCentreID { get; set; }
    public int[] ItemId { get; set; }
    public string[] ItemName { get; set; }
    public float[] Rate { get; set; }
    public string[] TestCode { get; set; }

   


    public string PaymentRefNo { get; set; }
    
    public float GrossAmt { get; set; }
    public float DiscAmt { get; set; }
    public float NetAmt { get; set; }
    public float PaidAmt { get; set; }
    public string UserName { get; set; }
    public string Password { get; set; }
    public string PaymentMode { get; set; }
    public string LabRefrenceNo { get; set; }
    public DateTime SampleCollectionDateTime { get; set; }
    public string StateID { get; set; }
    public string CityID { get; set; }
    public string LocalityID { get; set; }
    public string House_No { get; set; }
}
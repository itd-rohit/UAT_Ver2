using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for Insert_PreBooking
/// </summary>
public class Insert_PreBooking
{
     MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public Insert_PreBooking()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Insert_PreBooking(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    public string PreBookingID { get; set; }
    public int BookingID { get; set; }  
    public string Patient_ID { get; set; }
    public string Title { get; set; }
    public string PName { get; set; }
    public string House_No { get; set; }
    public string Locality { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string Mobile { get; set; }
    public int Pincode { get; set; }
    public string Email { get; set; }
    public DateTime? DOB { get; set; }
    public string Age { get; set; }
    public int AgeYear { get; set; }
    public int AgeMonth { get; set; }
    public int AgeDays { get; set; }
    public int TotalAgeInDays { get; set; }
    public string Gender { get; set; }
    public string StateID { get; set; }
    public string CityID { get; set; }
    public string LocalityID { get; set; }

    public string VisitType { get; set; }
    public int VIP { get; set; }
    public string PatientIDProof { get; set; }
    public string PatientIDProofNo { get; set; }
    public string PatientSource { get; set; }
    public string DispatchModeName { get; set; }
    public string Remarks { get; set; }
    public int IsDOBActual { get; set; }
    public int ItemId { get; set; }
    public string ItemName { get; set; }
    public decimal Rate { get; set; }
    public string TestCode { get; set; }
    public int IsPackage { get; set; }
    public int SubCategoryID { get; set; }
    public int Panel_ID { get; set; }
    public string CreatedBy { get; set; }
    public int CreatedByID { get; set; }
    public string PaymentMode { get; set; }
    public string LabRefrenceNo { get; set; }
    public int PreBookingCentreID { get; set; }
    public DateTime SampleCollectionDateTime { get; set; }
    public int IsScheduleRate { get; set; }
    public string Landmark { get; set; }
    public int VisitTypeID { get; set; }
    public int PreCollectionCentreID { get; set; }
    public int BookingCentre { get; set; }

    public decimal GrossAmt { get; set; }
    public decimal DiscAmt { get; set; }
    public decimal NetAmt { get; set; }
    public string PaymentRefNo { get; set; }
    public decimal PaidAmt { get; set; }
    public string Sender { get; set; }
    public int IsConfirm { get; set; }

    public int? DoctorID { get; set; }
    public string RefDoctor { get; set; }
    public string OtherDoctor { get; set; }
    public int? DiscountTypeID { get; set; }
    public int IsHomeCollection { get; set; }
    public string DiscAppBy { get; set; }
    public int DiscAppByID { get; set; }
    public string DiscReason { get; set; }
    public decimal MRP { get; set; }
    public int Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_PreBooking");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@ReturnPreBookingID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 30;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@PreBookingID", Util.GetInt(PreBookingID)));
            cmd.Parameters.Add(new MySqlParameter("@Patient_ID", Util.GetString(Patient_ID)));
            cmd.Parameters.Add(new MySqlParameter("@Title", Util.GetString(Title)));
            cmd.Parameters.Add(new MySqlParameter("@PName", Util.GetString(PName).ToUpper()));
            cmd.Parameters.Add(new MySqlParameter("@House_No", Util.GetString(House_No)));
            cmd.Parameters.Add(new MySqlParameter("@Locality", Util.GetString(Locality)));
            cmd.Parameters.Add(new MySqlParameter("@City", Util.GetString(City)));
            cmd.Parameters.Add(new MySqlParameter("@State", Util.GetString(State)));
            cmd.Parameters.Add(new MySqlParameter("@Mobile", Util.GetString(Mobile)));
            cmd.Parameters.Add(new MySqlParameter("@PinCode", Util.GetInt(Pincode)));
            cmd.Parameters.Add(new MySqlParameter("@Email", Util.GetString(Email)));
            cmd.Parameters.Add(new MySqlParameter("@DOB", Util.GetDateTime(DOB)));
            cmd.Parameters.Add(new MySqlParameter("@Age", Util.GetString(Age)));
            cmd.Parameters.Add(new MySqlParameter("@AgeYear", Util.GetInt(AgeYear)));
            cmd.Parameters.Add(new MySqlParameter("@AgeMonth", Util.GetInt(AgeMonth)));
            cmd.Parameters.Add(new MySqlParameter("@AgeDays", Util.GetInt(AgeDays)));
            cmd.Parameters.Add(new MySqlParameter("@TotalAgeInDays", Util.GetInt(TotalAgeInDays)));
            cmd.Parameters.Add(new MySqlParameter("@Gender", Util.GetString(Gender)));
            cmd.Parameters.Add(new MySqlParameter("@StateID", Util.GetInt(StateID)));
            cmd.Parameters.Add(new MySqlParameter("@CityID", Util.GetInt(CityID)));
            cmd.Parameters.Add(new MySqlParameter("@LocalityID", Util.GetInt(LocalityID)));
            cmd.Parameters.Add(new MySqlParameter("@VisitType", Util.GetString(VisitType)));
            cmd.Parameters.Add(new MySqlParameter("@VIP", Util.GetInt(VIP)));
            cmd.Parameters.Add(new MySqlParameter("@PatientIDProof", Util.GetString(PatientIDProof)));
            cmd.Parameters.Add(new MySqlParameter("@PatientIDProofNo", Util.GetString(PatientIDProofNo)));
            cmd.Parameters.Add(new MySqlParameter("@PatientSource", Util.GetString(PatientSource)));
            cmd.Parameters.Add(new MySqlParameter("@DispatchModeName", Util.GetString(DispatchModeName)));
            cmd.Parameters.Add(new MySqlParameter("@Remarks", Util.GetString(Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@IsDOBActual", Util.GetInt(IsDOBActual)));          
            cmd.Parameters.Add(new MySqlParameter("@ItemId", Util.GetInt(ItemId)));
            cmd.Parameters.Add(new MySqlParameter("@ItemName", Util.GetString(ItemName)));
            cmd.Parameters.Add(new MySqlParameter("@Rate", Util.GetDecimal(Rate)));
            cmd.Parameters.Add(new MySqlParameter("@SubCategoryID", Util.GetInt(SubCategoryID)));
            cmd.Parameters.Add(new MySqlParameter("@TestCode", Util.GetString(TestCode)));
            cmd.Parameters.Add(new MySqlParameter("@IsPackage", Util.GetInt(IsPackage)));
            cmd.Parameters.Add(new MySqlParameter("@Panel_ID", Util.GetInt(Panel_ID)));

            cmd.Parameters.Add(new MySqlParameter("@CreatedBy", Util.GetString(CreatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@CreatedByID", Util.GetInt(CreatedByID)));
            cmd.Parameters.Add(new MySqlParameter("@PaymentMode", Util.GetString(PaymentMode)));
            cmd.Parameters.Add(new MySqlParameter("@SampleCollectionDateTime", Util.GetDateTime(SampleCollectionDateTime)));
            cmd.Parameters.Add(new MySqlParameter("@LabRefrenceNo", Util.GetString(LabRefrenceNo)));
            cmd.Parameters.Add(new MySqlParameter("@PreBookingCentreID", Util.GetInt(PreBookingCentreID)));
            cmd.Parameters.Add(new MySqlParameter("@IsScheduleRate", Util.GetInt(IsScheduleRate)));
            cmd.Parameters.Add(new MySqlParameter("@Landmark", Util.GetString(Landmark)));
            cmd.Parameters.Add(new MySqlParameter("@VisitTypeID", Util.GetInt(VisitTypeID)));
            cmd.Parameters.Add(new MySqlParameter("@PreCollectionCentreID", Util.GetInt(PreCollectionCentreID)));

            cmd.Parameters.Add(new MySqlParameter("@BookingCentre", Util.GetInt(BookingCentre)));

            cmd.Parameters.Add(new MySqlParameter("@GrossAmt", Util.GetDecimal(GrossAmt)));
            cmd.Parameters.Add(new MySqlParameter("@DiscAmt", Util.GetDecimal(DiscAmt)));
            cmd.Parameters.Add(new MySqlParameter("@NetAmt", Util.GetDecimal(NetAmt)));
            cmd.Parameters.Add(new MySqlParameter("@PaidAmt", Util.GetDecimal(GrossAmt)));

            cmd.Parameters.Add(new MySqlParameter("@PaymentRefNo", Util.GetString(PaymentRefNo)));
            cmd.Parameters.Add(new MySqlParameter("@Sender", Util.GetString(Sender)));
            cmd.Parameters.Add(new MySqlParameter("@IsConfirm", Util.GetInt(IsConfirm)));

            cmd.Parameters.Add(new MySqlParameter("@ReferedDoctor", Util.GetString(RefDoctor)));
            cmd.Parameters.Add(new MySqlParameter("@OtherDoctor", Util.GetString(OtherDoctor)));
            cmd.Parameters.Add(new MySqlParameter("@DoctorID", Util.GetInt(DoctorID)));
            cmd.Parameters.Add(new MySqlParameter("@DiscountTypeID", Util.GetInt(DiscountTypeID)));
            cmd.Parameters.Add(new MySqlParameter("@IsHomeCollection", Util.GetInt(IsHomeCollection)));
            cmd.Parameters.Add(new MySqlParameter("@DiscAppBy", Util.GetString(DiscAppBy)));
            cmd.Parameters.Add(new MySqlParameter("@DiscAppByID", Util.GetInt(DiscAppByID)));
            cmd.Parameters.Add(new MySqlParameter("@DiscReason", Util.GetString(DiscReason)));
            cmd.Parameters.Add(new MySqlParameter("@MRP", Util.GetDecimal(MRP)));
            cmd.Parameters.Add(paramTnxID);
            BookingID = Util.GetInt( cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return BookingID;


        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            throw (ex);
        }
    }

}
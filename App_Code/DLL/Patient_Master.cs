using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for Patient_Master
/// </summary>
public class Patient_Master
{
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public Patient_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
       
    }
    public Patient_Master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    public string ID { get; set; }
    public string Patient_ID { get; set; }
    public string Title { get; set; }
    public string PName { get; set; }
    public string House_No { get; set; }
    public string Street_Name { get; set; } 
    public int Pincode { get; set; }
    public int CountryID { get; set; }
    public string Country { get; set; }
    public int StateID { get; set; }
    public string State { get; set; }
    public int CityID { get; set; }
    public string City { get; set; }
    public int LocalityID { get; set; }
    public string Locality { get; set; }
    public string Phone { get; set; }
    public string Mobile { get; set; }
    public string Email { get; set; }
    public DateTime DOB { get; set; }
    public string Age { get; set; }
    public int AgeYear { get; set; }
    public int AgeMonth { get; set; }
    public int AgeDays { get; set; }
    public int TotalAgeInDays { get; set; }
    public string Gender { get; set; }
    public int CentreID { get; set; }
    public string UpdateID { get; set; }
    public string UpdateName { get; set; }
    public string UpdateRemarks { get; set; }
    public DateTime Updatedate { get; set; }
    public string ipaddress { get; set; }
    public DateTime dtEntry { get; set; }    
    public string Patient_ID_Interface { get; set; }
    public int Patient_ID_create { get; set; }
    public int UserID { get; set; }
    public byte IsOnlineFilterData { get; set; }
    public byte IsDuplicate { get; set; }
    public byte IsDOBActual { get; set; }
    public string EmployeeID { get; set; }
    public string Relation { get; set; }
    public string UniqueKey { get; set; }
    public int FamilyMemberGroupID { get; set; }
    public sbyte FamilyMemberIsPrimary { get; set; }
    public string FamilyMemberRelation { get; set; }
    public string OTP { get; set; }
    public string OTPCode { get; set; }
    public string isCapTure { get; set; }
    public string base64PatientProfilePic { get; set; }
    public string ClinicalHistory { get; set; }
    public int MembershipCardID  { get; set; }
    public string MembershipCardNo  { get; set; }
    public DateTime MembershipCardValidFrom  { get; set; }
    public DateTime MembershipCardValidTo { get; set; }
    public Byte? IsAPIEntry { get; set; }
    public int VIP { get; set; }

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_patient");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter() { ParameterName = "@PatientID", MySqlDbType = MySqlDbType.VarChar, Size = 15, Direction = ParameterDirection.Output };
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans) { CommandType = CommandType.StoredProcedure };

            cmd.Parameters.Add(new MySqlParameter("@Title",  Util.GetString(Title)));
            cmd.Parameters.Add(new MySqlParameter("@Pname", Util.GetString(PName).ToUpper()));
            cmd.Parameters.Add(new MySqlParameter("@House_No", Util.GetString(House_No)));
            cmd.Parameters.Add(new MySqlParameter("@Street_Name", Util.GetString(Street_Name)));                     
            cmd.Parameters.Add(new MySqlParameter("@Pincode", Util.GetInt(Pincode)));           
            cmd.Parameters.Add(new MySqlParameter("@Country", Util.GetString(Country)));
            cmd.Parameters.Add(new MySqlParameter("@Phone", Util.GetString(Phone)));
            cmd.Parameters.Add(new MySqlParameter("@Mobile", Util.GetString(Mobile)));
            cmd.Parameters.Add(new MySqlParameter("@Email", Util.GetString(Email)));
            cmd.Parameters.Add(new MySqlParameter("@DOB", Util.GetDateTime(DOB)));
            cmd.Parameters.Add(new MySqlParameter("@Age", Util.GetString(Age)));
            cmd.Parameters.Add(new MySqlParameter("@AgeYear",Util.GetInt(AgeYear) ));
            cmd.Parameters.Add(new MySqlParameter("@AgeMonth",Util.GetInt(AgeMonth) ));
            cmd.Parameters.Add(new MySqlParameter("@AgeDays",Util.GetInt(AgeDays) ));
            cmd.Parameters.Add(new MySqlParameter("@TotalAgeInDays",Util.GetInt(TotalAgeInDays)));
            cmd.Parameters.Add(new MySqlParameter("@Gender", Util.GetString(Gender)));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", Util.GetInt(CentreID)));
            cmd.Parameters.Add(new MySqlParameter("@ipaddress", Util.GetString(StockReports.getip())));
            //cmd.Parameters.Add(new MySqlParameter("@Country", Util.GetString(Country)));
            cmd.Parameters.Add(new MySqlParameter("@CountryID", Util.GetInt(CountryID)));
            cmd.Parameters.Add(new MySqlParameter("@State", Util.GetString(State)));
            cmd.Parameters.Add(new MySqlParameter("@StateID", Util.GetInt(StateID)));
            cmd.Parameters.Add(new MySqlParameter("@City", Util.GetString(City)));
            cmd.Parameters.Add(new MySqlParameter("@CityID", Util.GetInt(CityID)));
            cmd.Parameters.Add(new MySqlParameter("@Locality", Util.GetString(Locality)));
            cmd.Parameters.Add(new MySqlParameter("@LocalityID", Util.GetInt(LocalityID)));
            cmd.Parameters.Add(new MySqlParameter("@EmployeeID", Util.GetString(EmployeeID)));
            cmd.Parameters.Add(new MySqlParameter("@Relation", Util.GetString(Relation)));
            if (Util.GetString(Patient_ID_Interface) == string.Empty)
            {
            cmd.Parameters.Add(new MySqlParameter("@UserID", Util.GetInt(UserInfo.ID)));
                cmd.Parameters.Add(new MySqlParameter("@Patient_ID_Interface", string.Empty));
                cmd.Parameters.Add(new MySqlParameter("@Patient_ID_create", 1));
            }
            else
            {
                cmd.Parameters.Add(new MySqlParameter("@UserID", UserID));
                cmd.Parameters.Add(new MySqlParameter("@Patient_ID_Interface", Patient_ID_Interface));
                cmd.Parameters.Add(new MySqlParameter("@Patient_ID_create", Patient_ID_create));
            }
            cmd.Parameters.Add(new MySqlParameter("@IsOnlineFilterData", Util.GetInt(IsOnlineFilterData)));
            cmd.Parameters.Add(new MySqlParameter("@IsDuplicate", Util.GetByte(IsDuplicate)));
            cmd.Parameters.Add(new MySqlParameter("@IsDOBActual", Util.GetByte(IsDOBActual)));


            cmd.Parameters.Add(new MySqlParameter("@FamilyMemberGroupID", Util.GetInt(FamilyMemberGroupID)));
            cmd.Parameters.Add(new MySqlParameter("@FamilyMemberIsPrimary", Util.GetByte(FamilyMemberIsPrimary)));
            cmd.Parameters.Add(new MySqlParameter("@FamilyMemberRelation", Util.GetString(FamilyMemberRelation)));
            cmd.Parameters.Add(new MySqlParameter("@ClinicalHistory", Util.GetString(ClinicalHistory)));
            cmd.Parameters.Add(new MySqlParameter("@VIP", Util.GetString(VIP)));

            cmd.Parameters.Add(new MySqlParameter("@MembershipCardID", Util.GetInt(MembershipCardID)));
            cmd.Parameters.Add(new MySqlParameter("@MembershipCardNo", Util.GetString(MembershipCardNo)));
            cmd.Parameters.Add(new MySqlParameter("@MembershipCardValidFrom", Util.GetDateTime(MembershipCardValidFrom)));
            cmd.Parameters.Add(new MySqlParameter("@MembershipCardValidTo", Util.GetDateTime(MembershipCardValidTo)));
            cmd.Parameters.Add(new MySqlParameter("@IsAPIEntry", Util.GetByte(IsAPIEntry)));
            cmd.Parameters.Add(paramTnxID);
            Patient_ID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Patient_ID.ToString();


        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            // Util.WriteLog(ex);
            throw (ex);
        }
    }
    
}
public class PatientDocuments
{
    public string documentId { get; set; }
    public string name { get; set; }
    public string data { get; set; }
}
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
/// <summary>
/// Summary description for StoreVendormaster
/// </summary>
public class StoreVendormaster
{
	

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public StoreVendormaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
       
    }
    public StoreVendormaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    public string SupplierID { get; set; }
    public string SupplierName { get; set; }
    public string SupplierCode { get; set; }
    public string SupplierType { get; set; }
    
    public string SupplierCategory { get; set; }
    public string OrganizationType { get; set; }
    public string HouseNo { get; set; }
    public string Street { get; set; }
    public string Country { get; set; }
    public string State { get; set; }
    public string PinCode { get; set; }
    public string Landline { get; set; }
    public string FaxNo { get; set; }
    public string EmailId { get; set; }
    public string Website { get; set; }

    public string PrimaryContactPerson { get; set; }
    public string PrimaryContactPersonDesignation { get; set; }
    public string PrimaryContactPersonMobileNo { get; set; }
    public string PrimaryContactPersonEmailId { get; set; }
    public string SecondaryContactPerson { get; set; }
    public string SecondaryContactPersonDesignation { get; set; }
    public string SecondaryContactPersonMobileNo { get; set; }
    public string SecondaryContactPersonEmailId { get; set; }
    


    public string CINNo { get; set; }
    public string PFRegistartionNo { get; set; }
    public string NameonPANCard { get; set; }
    public string PANCardNo { get; set; }
    public string ROCNo { get; set; }
    public string ESIRegistrationNo { get; set; }
    public string ISOCertificationNo { get; set; }
    public string ISOValidUpto { get; set; }
    public string PollutioncontrolBoardCertificationNo { get; set; }
    public string PollutionValidUpto{ get; set; }



    public string Bank1 { get; set; }
    public string Bank1Branch { get; set; }
    public string Bank1AccountsNo { get; set; }
    public string Bank1IFSCCode { get; set; }
    public string Bank1Address1 { get; set; }
    public string Bank1Address2 { get; set; }
    public string Bank1City { get; set; }
    public string Bank1State { get; set; }
    public string Bank2 { get; set; }
    public string Bank2Branch { get; set; }
    public string Bank2AccountsNo { get; set; }
    public string Bank2IFSCCode { get; set; }
    public string Bank2Address1 { get; set; }
    public string Bank2Address2 { get; set; }
    public string Bank2City { get; set; }
    public string Bank2State { get; set; }


    public string PaymentTerms { get; set; }
    public string Taxes { get; set; }
    public string DeliveryTerms { get; set; }
    public string VendorToNotes { get; set; }
    public string CreditLimit { get; set; }
    public string IsActive { get; set; }
    public string IsLoginRequired { get; set; }
    public string LoginUserName { get; set; }
    public string LoginPassword  { get; set; }

    public string IsAutoRejectPO { get; set; }
    public string AutoRejectPOAfterDays { get; set; }


    public string IsMSMERegistration { get; set; }
    public string MSMERegistrationNo { get; set; }
    public string MSMERegistrationValidDate { get; set; }
    public string OracleVendorCode { get; set; }
    public string OracleVendorSite { get; set; }
  

    public string Insert()
    {
        try
        {
            string saveditemid = "";
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("store_vendormaster");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@SupplierID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 15;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            cmd.Parameters.Add(new MySqlParameter("@SupplierName", Util.GetString(SupplierName)));
            cmd.Parameters.Add(new MySqlParameter("@SupplierCode", Util.GetString(SupplierCode)));
            cmd.Parameters.Add(new MySqlParameter("@SupplierType", Util.GetString(SupplierType)));
            cmd.Parameters.Add(new MySqlParameter("@SupplierCategory", Util.GetString(SupplierCategory)));
            cmd.Parameters.Add(new MySqlParameter("@OrganizationType", Util.GetString(OrganizationType)));
            cmd.Parameters.Add(new MySqlParameter("@HouseNo", Util.GetString(HouseNo)));
            cmd.Parameters.Add(new MySqlParameter("@Street", Util.GetString(Street)));
            cmd.Parameters.Add(new MySqlParameter("@Country", Util.GetString(Country)));
            cmd.Parameters.Add(new MySqlParameter("@State", Util.GetString(State)));
            cmd.Parameters.Add(new MySqlParameter("@PinCode", Util.GetString(PinCode)));
            cmd.Parameters.Add(new MySqlParameter("@Landline", Util.GetString(Landline)));
            cmd.Parameters.Add(new MySqlParameter("@FaxNo", Util.GetString(FaxNo)));
            cmd.Parameters.Add(new MySqlParameter("@EmailId", Util.GetString(EmailId)));
            cmd.Parameters.Add(new MySqlParameter("@Website", Util.GetString(Website)));
            cmd.Parameters.Add(new MySqlParameter("@PrimaryContactPerson", Util.GetString(PrimaryContactPerson)));
            cmd.Parameters.Add(new MySqlParameter("@PrimaryContactPersonDesignation", Util.GetString(PrimaryContactPersonDesignation)));
            cmd.Parameters.Add(new MySqlParameter("@PrimaryContactPersonMobileNo", Util.GetString(PrimaryContactPersonMobileNo)));
            cmd.Parameters.Add(new MySqlParameter("@PrimaryContactPersonEmailId", Util.GetString(PrimaryContactPersonEmailId)));
            cmd.Parameters.Add(new MySqlParameter("@SecondaryContactPerson", Util.GetString(SecondaryContactPerson)));
            cmd.Parameters.Add(new MySqlParameter("@SecondaryContactPersonDesignation", Util.GetString(SecondaryContactPersonDesignation)));
            cmd.Parameters.Add(new MySqlParameter("@SecondaryContactPersonMobileNo", Util.GetString(SecondaryContactPersonMobileNo)));
            cmd.Parameters.Add(new MySqlParameter("@SecondaryContactPersonEmailId", Util.GetString(SecondaryContactPersonEmailId)));
            cmd.Parameters.Add(new MySqlParameter("@CINNo", Util.GetString(CINNo)));
            cmd.Parameters.Add(new MySqlParameter("@PFRegistartionNo", Util.GetString(PFRegistartionNo)));
            cmd.Parameters.Add(new MySqlParameter("@NameonPANCard", Util.GetString(NameonPANCard)));
            cmd.Parameters.Add(new MySqlParameter("@PANCardNo", Util.GetString(PANCardNo)));
            cmd.Parameters.Add(new MySqlParameter("@ROCNo", Util.GetString(ROCNo)));
            cmd.Parameters.Add(new MySqlParameter("@ESIRegistrationNo", Util.GetString(ESIRegistrationNo)));
            cmd.Parameters.Add(new MySqlParameter("@ISOCertificationNo", Util.GetString(ISOCertificationNo)));
            cmd.Parameters.Add(new MySqlParameter("@ISOValidUpto", Util.GetString(ISOValidUpto)));
            cmd.Parameters.Add(new MySqlParameter("@PollutioncontrolBoardCertificationNo", Util.GetString(PollutioncontrolBoardCertificationNo)));
            cmd.Parameters.Add(new MySqlParameter("@PollutionValidUpto", Util.GetString(PollutionValidUpto)));
            cmd.Parameters.Add(new MySqlParameter("@Bank1", Util.GetString(Bank1)));
            cmd.Parameters.Add(new MySqlParameter("@Bank1Branch", Util.GetString(Bank1Branch)));
            cmd.Parameters.Add(new MySqlParameter("@Bank1AccountsNo", Util.GetString(Bank1AccountsNo)));
            cmd.Parameters.Add(new MySqlParameter("@Bank1IFSCCode", Util.GetString(Bank1IFSCCode)));
            cmd.Parameters.Add(new MySqlParameter("@Bank1Address1", Util.GetString(Bank1Address1)));
            cmd.Parameters.Add(new MySqlParameter("@Bank1Address2", Util.GetString(Bank1Address2)));
            cmd.Parameters.Add(new MySqlParameter("@Bank1City", Util.GetString(Bank1City)));
            cmd.Parameters.Add(new MySqlParameter("@Bank1State", Util.GetString(Bank1State)));
            cmd.Parameters.Add(new MySqlParameter("@Bank2", Util.GetString(Bank2)));
            cmd.Parameters.Add(new MySqlParameter("@Bank2Branch", Util.GetString(Bank2Branch)));
            cmd.Parameters.Add(new MySqlParameter("@Bank2AccountsNo", Util.GetString(Bank2AccountsNo)));
            cmd.Parameters.Add(new MySqlParameter("@Bank2IFSCCode", Util.GetString(Bank2IFSCCode)));
            cmd.Parameters.Add(new MySqlParameter("@Bank2Address1", Util.GetString(Bank2Address1)));
            cmd.Parameters.Add(new MySqlParameter("@Bank2Address2", Util.GetString(Bank2Address2)));
            cmd.Parameters.Add(new MySqlParameter("@Bank2City", Util.GetString(Bank2City)));
            cmd.Parameters.Add(new MySqlParameter("@Bank2State", Util.GetString(Bank2State)));
            cmd.Parameters.Add(new MySqlParameter("@PaymentTerms", Util.GetString(PaymentTerms)));
            cmd.Parameters.Add(new MySqlParameter("@Taxes", Util.GetString(Taxes)));
            cmd.Parameters.Add(new MySqlParameter("@DeliveryTerms", Util.GetString(DeliveryTerms)));
            cmd.Parameters.Add(new MySqlParameter("@VendorToNotes", Util.GetString(VendorToNotes)));
            cmd.Parameters.Add(new MySqlParameter("@CreditLimit", Util.GetString(CreditLimit)));
            cmd.Parameters.Add(new MySqlParameter("@CreaterID",Util.GetString(UserInfo.ID)));
            cmd.Parameters.Add(new MySqlParameter("@IsLoginRequired",Util.GetString(IsLoginRequired)));
            cmd.Parameters.Add(new MySqlParameter("@LoginUserName",Util.GetString(LoginUserName)));
            cmd.Parameters.Add(new MySqlParameter("@LoginPassword",Util.GetString(LoginPassword)));

            cmd.Parameters.Add(new MySqlParameter("@IsAutoRejectPO", Util.GetString(IsAutoRejectPO)));
            cmd.Parameters.Add(new MySqlParameter("@AutoRejectPOAfterDays", Util.GetString(AutoRejectPOAfterDays)));



            cmd.Parameters.Add(new MySqlParameter("@IsMSMERegistration", Util.GetString(IsMSMERegistration)));
            cmd.Parameters.Add(new MySqlParameter("@MSMERegistrationNo", Util.GetString(MSMERegistrationNo)));
            cmd.Parameters.Add(new MySqlParameter("@MSMERegistrationValidDate", Util.GetString(MSMERegistrationValidDate)));
            cmd.Parameters.Add(new MySqlParameter("@OracleVendorCode", Util.GetString(OracleVendorCode)));
            cmd.Parameters.Add(new MySqlParameter("@OracleVendorSite", Util.GetString(OracleVendorSite)));
            

            cmd.Parameters.Add(paramTnxID);
            saveditemid = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return saveditemid.ToString();


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

    public int Update()
    {

        try
        {
            int saveditemid = 0;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("  UPDATE st_vendormaster");
            objSQL.Append(" SET ");
            objSQL.Append(" SupplierName = '" + Util.GetString(SupplierName) + "',");
            objSQL.Append(" SupplierCode = '" + Util.GetString(SupplierCode)+"',");
            objSQL.Append(" SupplierType = '" + Util.GetString(SupplierType) + "',");
            objSQL.Append(" SupplierCategory = '" + Util.GetString(SupplierCategory)+"',");
            objSQL.Append(" OrganizationType = '" + Util.GetString(OrganizationType)+"',");
            objSQL.Append(" HouseNo = '" + Util.GetString(HouseNo)+"',");
            objSQL.Append(" Street = '" + Util.GetString(Street)+"',");
            objSQL.Append(" Country = '" + Util.GetString(Country)+"',");
            objSQL.Append(" State = '" + Util.GetString(State)+"',");
            objSQL.Append(" PinCode = '" + Util.GetString(PinCode)+"',");
            objSQL.Append(" Landline = '" + Util.GetString(Landline)+"',");
            objSQL.Append(" FaxNo = '" + Util.GetString(FaxNo)+"',");
            objSQL.Append(" EmailId = '" + Util.GetString(EmailId)+"',");
            objSQL.Append(" Website = '" + Util.GetString(Website)+"',");
            objSQL.Append(" PrimaryContactPerson = '" + Util.GetString(PrimaryContactPerson)+"',");
            objSQL.Append("PrimaryContactPersonDesignation = '" + Util.GetString(PrimaryContactPersonDesignation)+"',");
            objSQL.Append(" PrimaryContactPersonMobileNo = '" + Util.GetString(PrimaryContactPersonMobileNo)+"',");
            objSQL.Append(" PrimaryContactPersonEmailId = '" + Util.GetString(PrimaryContactPersonEmailId)+"',");
            objSQL.Append("  SecondaryContactPerson = '" + Util.GetString(SecondaryContactPerson)+"',");
            objSQL.Append(" SecondaryContactPersonDesignation = '" + Util.GetString(SecondaryContactPersonDesignation)+"',");
            objSQL.Append(" SecondaryContactPersonMobileNo = '" + Util.GetString(SecondaryContactPersonMobileNo)+"',");
            objSQL.Append(" SecondaryContactPersonEmailId = '" + Util.GetString(SecondaryContactPersonEmailId)+"',");
            objSQL.Append(" CINNo = '" + Util.GetString(CINNo)+"',");
            objSQL.Append(" PFRegistartionNo = '" + Util.GetString(PFRegistartionNo)+"',");
            objSQL.Append(" NameonPANCard = '" + Util.GetString(NameonPANCard)+"',");
            objSQL.Append(" PANCardNo = '" + Util.GetString(PANCardNo)+"',");
            objSQL.Append(" ROCNo = '" + Util.GetString(ROCNo)+"',");
            objSQL.Append(" ESIRegistrationNo = '" + Util.GetString(ESIRegistrationNo)+"',");
            objSQL.Append("  ISOCertificationNo = '" + Util.GetString(ISOCertificationNo)+"',");
            objSQL.Append(" ISOValidUpto = '" + Util.GetString(ISOValidUpto)+"',");
            objSQL.Append(" PollutioncontrolBoardCertificationNo = '" + Util.GetString(PollutioncontrolBoardCertificationNo)+"',");
            objSQL.Append(" PollutionValidUpto = '" + Util.GetString(PollutionValidUpto)+"',");
            objSQL.Append(" Bank1 = '" + Util.GetString(Bank1)+"',");
            objSQL.Append(" Bank1Branch = '" + Util.GetString(Bank1Branch)+"',");
            objSQL.Append(" Bank1AccountsNo = '" + Util.GetString(Bank1AccountsNo)+"',");
            objSQL.Append(" Bank1IFSCCode = '" + Util.GetString(Bank1IFSCCode)+"',");
            objSQL.Append(" Bank1Address1 = '" + Util.GetString(Bank1Address1)+"',");
            objSQL.Append(" Bank1Address2 = '" + Util.GetString(Bank1Address2)+"',");
            objSQL.Append(" Bank1City = '" + Util.GetString(Bank1City)+"',");
            objSQL.Append(" Bank1State = '" + Util.GetString(Bank1State)+"',");
            objSQL.Append(" Bank2 = '" + Util.GetString(Bank2)+"',");
            objSQL.Append(" Bank2Branch = '" + Util.GetString(Bank2Branch)+"',");
            objSQL.Append(" Bank2AccountsNo = '" + Util.GetString(Bank2AccountsNo)+"',");
            objSQL.Append(" Bank2IFSCCode = '" + Util.GetString(Bank2IFSCCode)+"',");
            objSQL.Append(" Bank2Address1 = '" + Util.GetString(Bank2Address1)+"',");
            objSQL.Append(" Bank2Address2 = '" + Util.GetString(Bank2Address2)+"',");
            objSQL.Append(" Bank2City = '" + Util.GetString(Bank2City)+"',");
            objSQL.Append(" Bank2State = '" + Util.GetString(Bank2State)+"',");
            objSQL.Append(" PaymentTerms = '" + Util.GetString(PaymentTerms)+"',");
            objSQL.Append(" Taxes = '" + Util.GetString(Taxes)+"',");
            objSQL.Append(" DeliveryTerms = '" + Util.GetString(DeliveryTerms)+"',");
            objSQL.Append(" VendorToNotes = '" + Util.GetString(VendorToNotes)+"',");
            objSQL.Append(" CreditLimit = '" + Util.GetString(CreditLimit)+"',");
            objSQL.Append(" IsActive = '" + Util.GetString(IsActive)+"',");
            objSQL.Append(" UpdateDate = now(),");
            objSQL.Append(" UpdatedBy = '"+Util.GetString(UserInfo.ID)+"',");
            objSQL.Append(" IsLoginRequired = '" + Util.GetString(IsLoginRequired) + "',");
            objSQL.Append(" LoginUserName = '" + Util.GetString(LoginUserName) + "',");
            objSQL.Append(" LoginPassword = '" + Util.GetString(LoginPassword) + "',");
            objSQL.Append(" IsAutoRejectPO = '" + Util.GetString(IsAutoRejectPO) + "',");
            objSQL.Append(" AutoRejectPOAfterDays = '" + Util.GetString(AutoRejectPOAfterDays) + "',");

            objSQL.Append(" IsMSMERegistration = '" + Util.GetInt(IsMSMERegistration) + "',");
            objSQL.Append(" MSMERegistrationNo = '" + Util.GetString(MSMERegistrationNo) + "',");
            objSQL.Append(" MSMERegistrationValidDate = '" + Util.GetString(MSMERegistrationValidDate) + "',");
            objSQL.Append(" OracleVendorCode = '" + Util.GetString(OracleVendorCode) + "',");
            objSQL.Append(" OracleVendorSite = '" + Util.GetString(OracleVendorSite) + "'");
            

            objSQL.Append(" WHERE SupplierID = '" + Util.GetString(SupplierID) + "' ");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.Text;



            saveditemid = cmd.ExecuteNonQuery();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return saveditemid;


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
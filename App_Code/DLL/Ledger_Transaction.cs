using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for Ledger_Transaction
/// </summary>
public class Ledger_Transaction
{
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public Ledger_Transaction()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Ledger_Transaction(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    
    public int LedgerTransactionID { get; set; }
    public string LedgerTransactionNo { get; set; }
    public DateTime Date { get; set; }
    public decimal DiscountOnTotal { get; set; }
    public decimal NetAmount { get; set; }
    public decimal GrossAmount { get; set; }
    public Byte IsCredit { get; set; }
    public string Patient_ID { get; set; }
    public string PName { get; set; }
    public string Age { get; set; }
    public string Gender { get; set; }
    public Byte VIP { get; set; }
    public Byte isMask { get; set; }
    public int Panel_ID { get; set; }
    public string PanelName { get; set; }
    public string Doctor_ID { get; set; }
    public string DoctorName { get; set; }
    public int OtherReferLabID { get; set; }
    public int CentreID { get; set; }
    public decimal Adjustment { get; set; }
    public DateTime AdjustmentDate { get; set; }
    public int CreatedByID { get; set; }
    public string HomeVisitBoyID { get; set; }
    public string ipAddress { get; set; }
    public int DiscountApprovedByID { get; set; }
    public string DiscountApprovedByName { get; set; }
    public DateTime DiscountApprovedDate { get; set; }
    public decimal DiscountPendingPer { get; set; }
    public string PatientIDProof { get; set; }
    public string PatientIDProofNo { get; set; }
    public string PatientSource { get; set; }
    public string PatientType { get; set; }
    public string VisitType { get; set; }
    public string HLMPatientType { get; set; }
    public string HLMOPDIPDNo { get; set; }
    public string CorporateIDType { get; set; }
    public string CorporateIDCard { get; set; }
    public Byte ReVisit { get; set; }
    public string CreatedBy { get; set; }
    public Byte WorkOrderID_Create { get; set; }
    public string WorkOrderID { get; set; }
    public string Interface_companyName { get; set; }
    public int DiscountID { get; set; }
    public string OtherLabRefNo { get; set; }
    public string WorkOrderIDSuffix { get; set; }
    public string showBalanceAmt { get; set; }
    public string CentreName { get; set; }
    public string DiscountType { get; set; }
    public int? PatientTypeID { get; set; }
    public int? PreBookingID { get; set; }
    public int Doctor_ID_Temp { get; set; }
    public string COCO_FOCO { get; set; }
    public int? Type1ID { get; set; }
    public string Interface_TPAID { get; set; }
    public Byte IsDiscountApproved { get; set; }
    public int OutstandingEmployeeId { get; set; }
    public decimal CashOutstanding { get; set; }
    public decimal CashOutstandingPer { get; set; }
    public string BarCodePrintedType { get; set; }
    public Byte? BarCodePrintedCentreType { get; set; }
    public Byte? BarCodePrintedHomeColectionType { get; set; }
    public string setOfBarCode { get; set; }
    public Byte? SampleCollectionOnReg { get; set; }
    public int InvoiceToPanelId { get; set; }
    public string CardHolderRelation { get; set; }
    public string CardHolderName { get; set; }
    public string PatientGovtType { get; set; }
    public int SecondReferenceID { get; set; }
    public string SecondReference { get; set; }
    public int TempSecondRef { get; set; }
    public DateTime BillDate { get; set; }
    public string AttachedFileName { get; set; }
    public string Remarks { get; set; }
    public int SalesTagEmployee { get; set; }
    public string DiscountReason { get; set; }
    public decimal DiscountPending { get; set; }
    public decimal Currency_RoundOff { get; set; }
    public int DispatchModeID { get; set; }
    public string DispatchModeName { get; set; }
    public int AppBelowBaseRate { get; set; }
    public string MemberShipCardNo { get; set; }
    public int? MembershipCardID { get; set; }
    public Byte? IsSelfPatient { get; set; }
    public int AppointmentID { get; set; }
    public int HomeCollectionAppID { get; set; }
    public int IsOPDConsultation { get; set; }
    public int OPDConsultationTokenNo { get; set; }
    public int? Interface_CompanyID { get; set; }
    public Byte?AllowPrint { get; set; }
    public Byte?  checkAllowPrint { get; set; }
    public string Interface_BillNo { get; set; }
    public string OtherReferLab { get; set; }
    public Byte? IsAPIEntry { get; set; }
    public Byte? IsMRPBill { get; set; }
  public string SRFNo { get; set; }
  public string PROID { get; set; }
  public string Nationality { get; set; }
  public string ECHS { get; set; }
  public string PureHealthID { get; set; }
  public string ICMRNo { get; set; }
  public string PassPortNo { get; set; }
  public string BarcodeManual { get; set; }
  public string Daughter { get; set; }
  public DateTime Pregnancydate { get; set; }
  public string AgeSon { get; set; }
  public string AgeDaughter { get; set; }
  public string PndtDoctorId { get; set; }

  public string CouponCodeDetail { get; set; }
    public int CouponID { get; set; }
    public int? CouponType { get; set; }
    public string CouponName { get; set; }
    public string CouponCode { get; set; }
    public List<string> CouponAmtDetail { get; set; }
    public decimal? CouponAmt { get; set; }
    public Byte? CouponClientShareType { get; set; }
    public Byte? OneCouponOneMobileMultipleBilling { get; set; }
    public string Children { get; set; }
    public string Son { get; set; }
    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_f_ledgertransaction");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter() { ParameterName = "@ReturnLedgerTransactionNo", MySqlDbType = MySqlDbType.VarChar, Size = 30, Direction = ParameterDirection.Output };
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans) { CommandType = CommandType.StoredProcedure };

            cmd.Parameters.Add(new MySqlParameter("@DiscountOnTotal", Util.GetDecimal(DiscountOnTotal)));
            cmd.Parameters.Add(new MySqlParameter("@NetAmount", Util.GetDecimal(NetAmount)));
            cmd.Parameters.Add(new MySqlParameter("@GrossAmount", Util.GetDecimal(GrossAmount)));
            cmd.Parameters.Add(new MySqlParameter("@IsCredit", Util.GetInt(IsCredit)));
            cmd.Parameters.Add(new MySqlParameter("@Patient_ID", Util.GetString(Patient_ID)));
            cmd.Parameters.Add(new MySqlParameter("@PName", Util.GetString(PName)));
            cmd.Parameters.Add(new MySqlParameter("@Age", Util.GetString(Age)));
            cmd.Parameters.Add(new MySqlParameter("@Gender", Util.GetString(Gender)));
            cmd.Parameters.Add(new MySqlParameter("@VIP", Util.GetInt(VIP)));
            cmd.Parameters.Add(new MySqlParameter("@Panel_ID", Util.GetInt(Panel_ID)));
            cmd.Parameters.Add(new MySqlParameter("@PanelName", Util.GetString(PanelName)));
            cmd.Parameters.Add(new MySqlParameter("@Doctor_ID", Util.GetInt(Doctor_ID)));
            cmd.Parameters.Add(new MySqlParameter("@DoctorName", Util.GetString(DoctorName)));
            cmd.Parameters.Add(new MySqlParameter("@OtherReferLabID", Util.GetInt(OtherReferLabID)));
            cmd.Parameters.Add(new MySqlParameter("@CentreId", Util.GetInt(CentreID)));
            cmd.Parameters.Add(new MySqlParameter("@Adjustment", Util.GetDecimal(Adjustment)));
            cmd.Parameters.Add(new MySqlParameter("@CreatedByID", Util.GetInt(CreatedByID)));
            cmd.Parameters.Add(new MySqlParameter("@HomeVisitBoyID", Util.GetInt(HomeVisitBoyID)));
            cmd.Parameters.Add(new MySqlParameter("@ipAddress", Util.GetString(StockReports.getip())));
            cmd.Parameters.Add(new MySqlParameter("@PatientIDProof", Util.GetString(PatientIDProof)));
            cmd.Parameters.Add(new MySqlParameter("@PatientIDProofNo", Util.GetString(PatientIDProofNo)));
            cmd.Parameters.Add(new MySqlParameter("@PatientSource", Util.GetString(PatientSource)));
            cmd.Parameters.Add(new MySqlParameter("@PatientType", Util.GetString(PatientType)));
            cmd.Parameters.Add(new MySqlParameter("@VisitType", Util.GetString(VisitType)));
           
            cmd.Parameters.Add(new MySqlParameter("@HLMPatientType", Util.GetString(HLMPatientType)));
            cmd.Parameters.Add(new MySqlParameter("@HLMOPDIPDNo", Util.GetString(HLMOPDIPDNo)));
            cmd.Parameters.Add(new MySqlParameter("@DiscountApprovedByID", Util.GetInt(DiscountApprovedByID)));
            cmd.Parameters.Add(new MySqlParameter("@DiscountApprovedByName", Util.GetString(DiscountApprovedByName)));
            cmd.Parameters.Add(new MySqlParameter("@CorporateIDType", Util.GetString(CorporateIDType)));
            cmd.Parameters.Add(new MySqlParameter("@CorporateIDCard", Util.GetString(CorporateIDCard)));
            cmd.Parameters.Add(new MySqlParameter("@ReVisit", Util.GetInt(ReVisit)));
            cmd.Parameters.Add(new MySqlParameter("@CreatedBy", Util.GetString(CreatedBy)));
            if (Util.GetString(WorkOrderID) != string.Empty)
            {
                cmd.Parameters.Add(new MySqlParameter("@WorkOrderID_Create", Util.GetByte(WorkOrderID_Create)));
                cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionNo_Interface", Util.GetString(WorkOrderID)));
                cmd.Parameters.Add(new MySqlParameter("@Interface_companyName", Util.GetString(Interface_companyName)));
            }
            else
            {
                cmd.Parameters.Add(new MySqlParameter("@WorkOrderID_Create", Util.GetByte(1)));
                cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionNo_Interface", string.Empty));
                cmd.Parameters.Add(new MySqlParameter("@Interface_companyName", string.Empty));
            }
            cmd.Parameters.Add(new MySqlParameter("@DiscountID", Util.GetInt(DiscountID)));
            cmd.Parameters.Add(new MySqlParameter("@OtherLabRefNo", Util.GetString(OtherLabRefNo)));
            cmd.Parameters.Add(new MySqlParameter("@WorkOrderIDSuffix", Util.GetString(WorkOrderIDSuffix)));
            cmd.Parameters.Add(new MySqlParameter("@DiscountType", Util.GetString(DiscountType)));
            cmd.Parameters.Add(new MySqlParameter("@PreBookingID", Util.GetInt(PreBookingID)));
            cmd.Parameters.Add(new MySqlParameter("@Doctor_ID_Temp", Util.GetInt(Doctor_ID_Temp)));
            cmd.Parameters.Add(new MySqlParameter("@Interface_TPAID", Util.GetString(Doctor_ID_Temp)));
            cmd.Parameters.Add(new MySqlParameter("@IsDiscountApproved", Util.GetByte(IsDiscountApproved)));
            cmd.Parameters.Add(new MySqlParameter("@isMask", Util.GetByte(isMask)));
            cmd.Parameters.Add(new MySqlParameter("@CashOutstanding", Util.GetDecimal(CashOutstanding)));
            cmd.Parameters.Add(new MySqlParameter("@OutstandingEmployeeId", Util.GetInt(OutstandingEmployeeId)));
            cmd.Parameters.Add(new MySqlParameter("@BarCodePrintedType", Util.GetString(BarCodePrintedType)));
            cmd.Parameters.Add(new MySqlParameter("@BarCodePrintedCentreType", Util.GetByte(BarCodePrintedCentreType)));
            cmd.Parameters.Add(new MySqlParameter("@BarCodePrintedHomeColectionType", Util.GetByte(BarCodePrintedHomeColectionType)));
            cmd.Parameters.Add(new MySqlParameter("@setOfBarCode", Util.GetString(setOfBarCode)));
            cmd.Parameters.Add(new MySqlParameter("@SampleCollectionOnReg", Util.GetByte(SampleCollectionOnReg)));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceToPanelId", Util.GetInt(InvoiceToPanelId)));
            cmd.Parameters.Add(new MySqlParameter("@CardHolderRelation", Util.GetString(CardHolderRelation)));
            cmd.Parameters.Add(new MySqlParameter("@CardHolderName", Util.GetString(CardHolderName)));
            cmd.Parameters.Add(new MySqlParameter("@PatientGovtType", Util.GetString(PatientGovtType)));
            cmd.Parameters.Add(new MySqlParameter("@SecondReferenceID", Util.GetInt(SecondReferenceID)));
            cmd.Parameters.Add(new MySqlParameter("@SecondReference", Util.GetString(SecondReference)));
            cmd.Parameters.Add(new MySqlParameter("@TempSecondRef", Util.GetInt(TempSecondRef)));
            cmd.Parameters.Add(new MySqlParameter("@BillDate", Util.GetDateTime(BillDate)));
            cmd.Parameters.Add(new MySqlParameter("@SalesTagEmployee", Util.GetInt(SalesTagEmployee)));
            cmd.Parameters.Add(new MySqlParameter("@Currency_RoundOff", Util.GetDecimal(Currency_RoundOff)));
            cmd.Parameters.Add(new MySqlParameter("@MemberShipcardNo", Util.GetString(MemberShipCardNo)));

            cmd.Parameters.Add(new MySqlParameter("@MembershipCardID", Util.GetInt(MembershipCardID)));
            cmd.Parameters.Add(new MySqlParameter("@IsSelfPatient", Util.GetByte(IsSelfPatient)));
            cmd.Parameters.Add(new MySqlParameter("@AppointmentID", Util.GetInt(AppointmentID)));
            cmd.Parameters.Add(new MySqlParameter("@HomeCollectionAppID", Util.GetInt(HomeCollectionAppID)));
            cmd.Parameters.Add(new MySqlParameter("@IsOPDConsultation", Util.GetInt(IsOPDConsultation)));
            cmd.Parameters.Add(new MySqlParameter("@OPDConsultationTokenNo", Util.GetInt(OPDConsultationTokenNo)));

            cmd.Parameters.Add(new MySqlParameter("@Interface_CompanyID", Util.GetInt(Interface_CompanyID)));
            cmd.Parameters.Add(new MySqlParameter("@AllowPrint", Util.GetByte(AllowPrint)));
            cmd.Parameters.Add(new MySqlParameter("@checkAllowPrint", Util.GetByte(checkAllowPrint)));
            cmd.Parameters.Add(new MySqlParameter("@Interface_BillNo", Util.GetString(Interface_BillNo)));
            cmd.Parameters.Add(new MySqlParameter("@OtherReferLab", Util.GetString(OtherReferLab)));
            cmd.Parameters.Add(new MySqlParameter("@IsAPIEntry", Util.GetByte(IsAPIEntry)));
	        cmd.Parameters.Add(new MySqlParameter("@SRFNo", Util.GetString(SRFNo)));
            cmd.Parameters.Add(new MySqlParameter("@PROID", Util.GetString(PROID)));
            cmd.Parameters.Add(new MySqlParameter("@ICMRNo", Util.GetString(ICMRNo)));
            cmd.Parameters.Add(new MySqlParameter("@Nationality", Util.GetString(Nationality)));
            cmd.Parameters.Add(new MySqlParameter("@PassPortNo", Util.GetString(PassPortNo)));
            cmd.Parameters.Add(new MySqlParameter("@PureHealthID", Util.GetString(PureHealthID)));
            cmd.Parameters.Add(new MySqlParameter("@ECHS", Util.GetString(ECHS)));

            cmd.Parameters.Add(new MySqlParameter("@CouponCode", Util.GetString(CouponCode)));
            cmd.Parameters.Add(new MySqlParameter("@CouponName", Util.GetString(CouponName)));
            cmd.Parameters.Add(new MySqlParameter("@CouponID", Util.GetInt(CouponID)));
            cmd.Parameters.Add(new MySqlParameter("@CouponClientShareType", Util.GetByte(CouponClientShareType)));
            cmd.Parameters.Add(new MySqlParameter("@OneCouponOneMobileMultipleBilling", Util.GetByte(OneCouponOneMobileMultipleBilling)));
            cmd.Parameters.Add(new MySqlParameter("@Children", Util.GetString(Children)));
            cmd.Parameters.Add(new MySqlParameter("@Son", Util.GetString(Son)));
            cmd.Parameters.Add(new MySqlParameter("@Daughter", Util.GetString(Daughter)));
            cmd.Parameters.Add(new MySqlParameter("@Pregnancydate", Util.GetDateTime(Pregnancydate)));
            cmd.Parameters.Add(new MySqlParameter("@AgeSon", Util.GetString(AgeSon)));
            cmd.Parameters.Add(new MySqlParameter("@AgeDaughter", Util.GetString(AgeDaughter)));
            cmd.Parameters.Add(new MySqlParameter("@PndtDoctorId", Util.GetString(PndtDoctorId)));

            cmd.Parameters.Add(paramTnxID);
            LedgerTransactionNo = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return LedgerTransactionNo.ToString();
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
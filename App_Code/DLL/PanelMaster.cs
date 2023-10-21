#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;

#endregion All Namespaces

public class PanelMaster
{
    #region All Memory Variables

    private string _Company_Name;
    private string _Add1;

    private string _Panel_ID;
    private string _Panel_Code;
    private string _ReferenceCode;
    private string _EmailID;
    private string _Phone;
    private string _Mobile;
    private string _Contact_Person;
    private string _ReferenceCodeOPD;
    private string _ReferenceMrp;
    private string _Agreement;
    private DateTime _DateFrom;
    private DateTime _DateTo;
    private string _CreditLimit;
    private int _PanelGroupID;
    private string _Country;
    private string _Payment_Mode;
    private string _PanelUserID;
    private string _PanelPassword;
    private DateTime _Contractdate;
    private float _TaxPercentage;
    private int _IsActive;
    private string _ReportDispatchMode;
    private string _PrintAtCentre;
    private int _PrintinLab;
    private int _HideRate;
    private int _HideDiscount;
    private int _isfullpaidreceipt;
    private int _ShowMRPinReceipt;
    private int _ShowHeaderinReceipt;
    private string _MinBalReceive;
    private string _Fullpaidpanelid;
    private string _city;
    private string _area;
    private string _state;
    private string _EmailIDReport;
    private decimal _MinBusinessCommitment;
    private string _GSTTin;
    private string _BankName;
    private string _AccountNo;
    private string _IFSCCode;
    private string _InvoiceBillingCycle;
    private string _BusinessType;
    private string _SalesHierarchy;
    private string _SecurityDeposit;
    private int _ReportInterpretation;
    private int _BankID;
    private int _TagProcessingLabID;
    private int _TagHUB;
    private string _TagProcessingLab;
    private int _ZoneID;
    private string _Zone;
    private string _PanelGroup;
    private int _CentreID;
    private int _ShowAmtInBooking;
    private string _InvoiceTo;
    private string _SavingType;
    private string _CreatedBy;
    private string _PanelType;
    private int _HideReceiptRate;
    private int _AAALogo;
    private string _EnrollID;
    private int _IsInvoice;
    private string _InvoiceDisplayName;
    private string _InvoiceDisplayNo;
    private int _IsBookingLock;
    private int _IsPrintingLock;
    private string _PatientPayTo;
    private int _TypeID;
    private string _TypeName;
    private decimal _SharePercentage;
    private decimal _DiscPercent;
    private int _DesignationID;
    private int _EmployeeID;
    private int _SequenceNo;
    private string _AttachedFileName;
    private int _IsApprove;
    private int _BusinessZoneID;
    private int _StateID;
    private int _CityID;
    private int _CityZoneID;
    private int _LocalityID;
    private int _HeadQuarterID;
    private int _DirectApprovalPendingBy;
    private string _VerificationType;
    private int _OnLineLoginRequired;
    private int? _PROID;
    private string _InvoiceDisplayAddress;
    private int _SalesManager;
    private string _SalesManagerName;
    private int _MrpBill;
    private int _NetBill;
    private int _IsPermanentClose;
    private DateTime _PermanentCloseDate;
    private int _showBalanceAmt;
    private int _AutoPreBookingReceipt;
    private string _LedgerReportPassword;
    private int _ReferringMrpID;
    private int _ReferringShareID;
    private string _LabReportLimit;
    private string _IntimationLimit;
    private int _IsShowIntimation;
    private int _TagBusinessLabID;
    private string _TagBusinessLab;
    private int _IsLogisticExpense;
    private int _LogisticExpenseRateType;
    private int _LogisticExpenseToPanelID;
    private int _RollingAdvance;
    private string _OwnerName;
    private int _CentreType1ID;
    private string _CentreType1;
    private int _IsOtherLabReferenceNo;
    private int _chkExpectedPayment;
    private int _ExpectedPaymentDate;
    private int _IsShowFooterContact;
    private string _FooterContact;
    private int _IsBatchCreate;

    private string _BarCodePrintedType;
    private int _SampleCollectionOnReg;
    private int _BarCodePrintedCentreType;
    private int _BarCodePrintedHomeColectionType;
    private string _SetOfBarCode;
    private int _ShowCollectionCharge;
    private int _CollectionCharge;
    private int _ShowDeliveryCharge;
    private int _DeliveryCharge;
    private string _ReceiptType;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public PanelMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        //this.Location=AllGlobalFunction.Location;
        //this.HospCode = AllGlobalFunction.HospCode;
    }

    public PanelMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual int PrintinLab { get { return _PrintinLab; } set { _PrintinLab = value; } }
    public virtual int HideRate { get { return _HideRate; } set { _HideRate = value; } }
    public virtual int HideDiscount { get { return _HideDiscount; } set { _HideDiscount = value; } }
    public virtual int isfullpaidreceipt { get { return _isfullpaidreceipt; } set { _isfullpaidreceipt = value; } }
    public virtual int ShowMRPinReceipt { get { return _ShowMRPinReceipt; } set { _ShowMRPinReceipt = value; } }
    public virtual int ShowHeaderinReceipt { get { return _ShowHeaderinReceipt; } set { _ShowHeaderinReceipt = value; } }
    public virtual string MinBalReceive { get { return _MinBalReceive; } set { _MinBalReceive = value; } }
    public virtual string Fullpaidpanelid { get { return _Fullpaidpanelid; } set { _Fullpaidpanelid = value; } }
    public virtual string city { get { return _city; } set { _city = value; } }
    public virtual string area { get { return _area; } set { _area = value; } }
    public virtual string state { get { return _state; } set { _state = value; } }
    public virtual string EmailIDReport { get { return _EmailIDReport; } set { _EmailIDReport = value; } }
    public virtual decimal MinBusinessCommitment { get { return _MinBusinessCommitment; } set { _MinBusinessCommitment = value; } }
    public virtual string GSTTin { get { return _GSTTin; } set { _GSTTin = value; } }
    public virtual string BankName { get { return _BankName; } set { _BankName = value; } }
    public virtual string AccountNo { get { return _AccountNo; } set { _AccountNo = value; } }
    public virtual string IFSCCode { get { return _IFSCCode; } set { _IFSCCode = value; } }
    public virtual string InvoiceBillingCycle { get { return _InvoiceBillingCycle; } set { _InvoiceBillingCycle = value; } }
    public virtual string BusinessType { get { return _BusinessType; } set { _BusinessType = value; } }
    public virtual string SalesHierarchy { get { return _SalesHierarchy; } set { _SalesHierarchy = value; } }
    public virtual string SecurityDeposit { get { return _SecurityDeposit; } set { _SecurityDeposit = value; } }
    public virtual int ReportInterpretation { get { return _ReportInterpretation; } set { _ReportInterpretation = value; } }
    public virtual int BankID { get { return _BankID; } set { _BankID = value; } }
    public virtual int TagProcessingLabID { get { return _TagProcessingLabID; } set { _TagProcessingLabID = value; } }
    public virtual string TagProcessingLab { get { return _TagProcessingLab; } set { _TagProcessingLab = value; } }
    public virtual int ZoneID { get { return _ZoneID; } set { _ZoneID = value; } }
    public virtual string Zone { get { return _Zone; } set { _Zone = value; } }
    public virtual string PanelGroup { get { return _PanelGroup; } set { _PanelGroup = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public virtual int ShowAmtInBooking { get { return _ShowAmtInBooking; } set { _ShowAmtInBooking = value; } }
    public virtual string InvoiceTo { get { return _InvoiceTo; } set { _InvoiceTo = value; } }
    public virtual string SavingType { get { return _SavingType; } set { _SavingType = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    public virtual string PanelType { get { return _PanelType; } set { _PanelType = value; } }
    public virtual int HideReceiptRate { get { return _HideReceiptRate; } set { _HideReceiptRate = value; } }
    public virtual int AAALogo { get { return _AAALogo; } set { _AAALogo = value; } }
    public virtual string EnrollID { get { return _EnrollID; } set { _EnrollID = value; } }
    public virtual int IsInvoice { get { return _IsInvoice; } set { _IsInvoice = value; } }
    public virtual string InvoiceDisplayName { get { return _InvoiceDisplayName; } set { _InvoiceDisplayName = value; } }
    public virtual string InvoiceDisplayNo { get { return _InvoiceDisplayNo; } set { _InvoiceDisplayNo = value; } }
    public virtual int IsBookingLock { get { return _IsBookingLock; } set { _IsBookingLock = value; } }
    public virtual int IsPrintingLock { get { return _IsPrintingLock; } set { _IsPrintingLock = value; } }
    public virtual string PatientPayTo { get { return _PatientPayTo; } set { _PatientPayTo = value; } }
    public virtual int TypeID { get { return _TypeID; } set { _TypeID = value; } }
    public virtual int? PROID { get { return _PROID; } set { _PROID = value; } }
    public virtual int MrpBill { get { return _MrpBill; } set { _MrpBill = value; } }
    public virtual int NetBill { get { return _NetBill; } set { _NetBill = value; } }
    public virtual int showBalanceAmt { get { return _showBalanceAmt; } set { _showBalanceAmt = value; } }
    public virtual int AutoPreBookingReceipt { get { return _AutoPreBookingReceipt; } set { _AutoPreBookingReceipt = value; } }
    public virtual string LedgerReportPassword { get { return _LedgerReportPassword; } set { _LedgerReportPassword = value; } }
    public virtual string PrintAtCentre { get { return _PrintAtCentre; } set { _PrintAtCentre = value; } }
    public virtual string ReportDispatchMode { get { return _ReportDispatchMode; } set { _ReportDispatchMode = value; } }
    public virtual int IsActive { get { return _IsActive; } set { _IsActive = value; } }
    public virtual float TaxPercentage { get { return _TaxPercentage; } set { _TaxPercentage = value; } }
    public virtual DateTime Contractdate { get { return _Contractdate; } set { _Contractdate = value; } }
    public virtual string Payment_Mode { get { return _Payment_Mode; } set { _Payment_Mode = value; } }
    public virtual string Company_Name { get { return _Company_Name; } set { _Company_Name = value; } }
    public virtual string Add1 { get { return _Add1; } set { _Add1 = value; } }
    public virtual string Panel_ID { get { return _Panel_ID; } set { _Panel_ID = value; } }
    public virtual string Panel_Code { get { return _Panel_Code; } set { _Panel_Code = value; } }
    public virtual string ReferenceCode { get { return _ReferenceCode; } set { _ReferenceCode = value; } }
    public virtual string EmailID { get { return _EmailID; } set { _EmailID = value; } }
    public virtual string Phone { get { return _Phone; } set { _Phone = value; } }
    public virtual string Mobile { get { return _Mobile; } set { _Mobile = value; } }
    public virtual string Contact_Person { get { return _Contact_Person; } set { _Contact_Person = value; } }
    public virtual string ReferenceCodeOPD { get { return _ReferenceCodeOPD; } set { _ReferenceCodeOPD = value; } }
    public virtual string ReferenceMrp { get { return _ReferenceMrp; } set { _ReferenceMrp = value; } }
    public virtual string Agreement { get { return _Agreement; } set { _Agreement = value; } }
    public virtual DateTime DateFrom { get { return _DateFrom; } set { _DateFrom = value; } }
    public virtual DateTime DateTo { get { return _DateTo; } set { _DateTo = value; } }
    public virtual string CreditLimit { get { return _CreditLimit; } set { _CreditLimit = value; } }
    public virtual int PanelGroupID { get { return _PanelGroupID; } set { _PanelGroupID = value; } }
    public virtual string Country { get { return _Country; } set { _Country = value; } }
    public virtual string PanelUserID { get { return _PanelUserID; } set { _PanelUserID = value; } }
    public virtual string PanelPassword { get { return _PanelUserID; } set { _PanelUserID = value; } }
    public virtual int SalesManager { get { return _SalesManager; } set { _SalesManager = value; } }
    public virtual string SalesManagerName { get { return _SalesManagerName; } set { _SalesManagerName = value; } }
    public virtual string TypeName { get { return _TypeName; } set { _TypeName = value; } }
    public virtual decimal SharePercentage { get { return _SharePercentage; } set { _SharePercentage = value; } }
    public virtual decimal DiscPercent { get { return _DiscPercent; } set { _DiscPercent = value; } }
    public virtual int DesignationID { get { return _DesignationID; } set { _DesignationID = value; } }
    public virtual int EmployeeID { get { return _EmployeeID; } set { _EmployeeID = value; } }
    public virtual int SequenceNo { get { return _SequenceNo; } set { _SequenceNo = value; } }
    public virtual string AttachedFileName { get { return _AttachedFileName; } set { _AttachedFileName = value; } }
    public virtual int IsApprove { get { return _IsApprove; } set { _IsApprove = value; } }
    public virtual int BusinessZoneID { get { return _BusinessZoneID; } set { _BusinessZoneID = value; } }
    public virtual int StateID { get { return _StateID; } set { _StateID = value; } }
    public virtual int CityID { get { return _CityID; } set { _CityID = value; } }
    public virtual int CityZoneID { get { return _CityZoneID; } set { _CityZoneID = value; } }
    public virtual int LocalityID { get { return _LocalityID; } set { _LocalityID = value; } }
    public virtual int HeadQuarterID { get { return _HeadQuarterID; } set { _HeadQuarterID = value; } }
    public virtual int DirectApprovalPendingBy { get { return _DirectApprovalPendingBy; } set { _DirectApprovalPendingBy = value; } }
    public virtual string VerificationType { get { return _VerificationType; } set { _VerificationType = value; } }
    public virtual int OnLineLoginRequired { get { return _OnLineLoginRequired; } set { _OnLineLoginRequired = value; } }
    public virtual int? HLMOPHikeInMRP { get; set; }
    public virtual int? HLMOPClientShare { get; set; }
    public virtual int? HLMIPHikeInMRP { get; set; }
    public virtual int? HLMIPClientShare { get; set; }
    public virtual int? HLMICUHikeInMRP { get; set; }
    public virtual int? HLMICUClientShare { get; set; }
    public virtual int? IsHLMOP { get; set; }
    public virtual int? IsHLMIP { get; set; }
    public virtual int? IsHLMICU { get; set; }
    public virtual string HLMOPPaymentMode { get; set; }
    public virtual string HLMOPPatientPayTo { get; set; }
    public virtual string HLMIPPaymentMode { get; set; }
    public virtual string HLMIPPatientPayTo { get; set; }
    public virtual string HLMICUPaymentMode { get; set; }
    public virtual string HLMICUPatientPayTo { get; set; }
    public virtual string ChequeNo { get; set; }
    public virtual DateTime ChequeDate { get; set; }
    public virtual string ChequeAmt { get; set; }
   
    public virtual string InvoiceDisplayAddress { get { return _InvoiceDisplayAddress; } set { _InvoiceDisplayAddress = value; } }
    public int AllowPreBooking { get; set; }
    public string PreBookingCentre { get; set; }
    public string PreCollectionCentre { get; set; }
    public virtual int IsPermanentClose { get { return _IsPermanentClose; } set { _IsPermanentClose = value; } }
    public virtual DateTime PermanentCloseDate { get { return _PermanentCloseDate; } set { _PermanentCloseDate = value; } }
    public virtual int IsDuplicatePanNo { get; set; }
    public virtual int ReferringMrpID { get { return _ReferringMrpID; } set { _ReferringMrpID = value; } }
    public virtual int ReferringShareID { get { return _ReferringShareID; } set { _ReferringShareID = value; } }
    public virtual string LabReportLimit { get { return _LabReportLimit; } set { _LabReportLimit = value; } }
    public virtual string IntimationLimit { get { return _IntimationLimit; } set { _IntimationLimit = value; } }
    public virtual int IsShowIntimation { get { return _IsShowIntimation; } set { _IsShowIntimation = value; } }
    public virtual int TagBusinessLabID { get { return _TagBusinessLabID; } set { _TagBusinessLabID = value; } }
    public virtual int TagHUB { get { return _TagHUB; } set { _TagHUB = value; } }
    public virtual string TagBusinessLab { get { return _TagBusinessLab; } set { _TagBusinessLab = value; } }
    public virtual int IsLogisticExpense { get { return _IsLogisticExpense; } set { _IsLogisticExpense = value; } }
    public virtual int LogisticExpenseRateType { get { return _LogisticExpenseRateType; } set { _LogisticExpenseRateType = value; } }
    public virtual int LogisticExpenseToPanelID { get { return _LogisticExpenseToPanelID; } set { _LogisticExpenseToPanelID = value; } }
    public virtual int RollingAdvance { get { return _RollingAdvance; } set { _RollingAdvance = value; } }
    public virtual string OwnerName { get { return _OwnerName; } set { _OwnerName = value; } }
    public int chkLedgerReportPassword { get; set; }
    public virtual int CentreType1ID { get { return _CentreType1ID; } set { _CentreType1ID = value; } }
    public virtual string CentreType1 { get { return _CentreType1; } set { _CentreType1 = value; } }
    public virtual int IsOtherLabReferenceNo { get { return _IsOtherLabReferenceNo; } set { _IsOtherLabReferenceNo = value; } }
    public virtual int chkExpectedPayment { get { return _chkExpectedPayment; } set { _chkExpectedPayment = value; } }
    public virtual int ExpectedPaymentDate { get { return _ExpectedPaymentDate; } set { _ExpectedPaymentDate = value; } }
    public virtual int IsBatchCreate { get { return _IsBatchCreate; } set { _IsBatchCreate = value; } }

    public virtual string BarCodePrintedType { get { return _BarCodePrintedType; } set { _BarCodePrintedType = value; } }
    public virtual int SampleCollectionOnReg { get { return _SampleCollectionOnReg; } set { _SampleCollectionOnReg = value; } }
    public virtual int BarCodePrintedCentreType { get { return _BarCodePrintedCentreType; } set { _BarCodePrintedCentreType = value; } }
    public virtual int BarCodePrintedHomeColectionType { get { return _BarCodePrintedHomeColectionType; } set { _BarCodePrintedHomeColectionType = value; } }
    public virtual string SetOfBarCode { get { return _SetOfBarCode; } set { _SetOfBarCode = value; } }

    public virtual int ShowCollectionCharge { get { return _ShowCollectionCharge; } set { _ShowCollectionCharge = value; } }
    public virtual int CollectionCharge { get { return _CollectionCharge; } set { _CollectionCharge = value; } }

    public virtual int ShowDeliveryCharge { get { return _ShowDeliveryCharge; } set { _ShowDeliveryCharge = value; } }
    public virtual int DeliveryCharge { get { return _DeliveryCharge; } set { _DeliveryCharge = value; } }

    public int CoPaymentApplicable { get; set; }
    public int CoPaymentEditonBooking { get; set; }
    public virtual string ReceiptType { get { return _ReceiptType; } set { _ReceiptType = value; } }
    public int IsPanelLogin { get; set; }
    public int SampleRecollectAfterReject { get; set; }
    public int InvoiceCreatedOn { get; set; }
    public int MonthlyInvoiceType { get; set; }
    public int CountryID { get; set; }
    public string CountryName { get; set; }
    public string BusinessZone { get; set; }
 public int IsAllowDoctorShare { get; set; }
 public string PanNo { get; set; }
 public  string PANCardName { get; set; }
 public string CreationDate { get; set; }
 public  string SecurityAmtComments { get; set; }
 public string LoginID { get; set; }
 public string LoginPassword { get; set; }
 public int SecurityAmt { get; set; }
    public int AllowSharing { get; set; }
public string SecurityRemark { get; set; }
    
    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT_Panel");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter() { ParameterName = "@vPanel_ID", MySqlDbType = MySqlDbType.VarChar, Size = 50, Direction = ParameterDirection.Output };
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans) { CommandType = CommandType.StoredProcedure };

            this.Company_Name = Util.GetString(Company_Name);
            this.Payment_Mode = Util.GetString(Payment_Mode);
            this.Add1 = Util.GetString(Add1);
            this.Panel_Code = Util.GetString(Panel_Code);
            this.ReferenceCode = Util.GetString(ReferenceCode);
            this.EmailID = Util.GetString(EmailID);
            this.Phone = Util.GetString(Phone);
            this.Mobile = Util.GetString(Mobile);
            this.Contact_Person = Util.GetString(Contact_Person);
            this.ReferenceCodeOPD = Util.GetString(ReferenceCodeOPD);
            this.ReferenceMrp = Util.GetString(ReferenceMrp);
            this.Agreement = Util.GetString(Agreement);
            this.DateFrom = Util.GetDateTime(DateFrom);
            this.DateTo = Util.GetDateTime(DateTo);
            this.CreditLimit = Util.GetString(CreditLimit);
            this.PanelGroupID = Util.GetInt(PanelGroupID);
            this.PanelUserID = Util.GetString(PanelUserID);
            this.TaxPercentage = Util.GetFloat(TaxPercentage);
            this.PanelPassword = Util.GetString(PanelPassword);
            this.Contractdate = Util.GetDateTime(Contractdate);
            this.IsActive = Util.GetInt(IsActive);
            this.ReportDispatchMode = Util.GetString(ReportDispatchMode);
            this.PrintAtCentre = Util.GetString(PrintAtCentre);
            this.isfullpaidreceipt = Util.GetInt(isfullpaidreceipt);
            this.ShowMRPinReceipt = Util.GetInt(ShowMRPinReceipt);
            this.ShowHeaderinReceipt = Util.GetInt(ShowHeaderinReceipt);
            this.MinBalReceive = Util.GetString(MinBalReceive);
            this.Fullpaidpanelid = Util.GetString(Fullpaidpanelid);
            this.city = Util.GetString(city);
            this.area = Util.GetString(area);
            this.state = Util.GetString(state);
            this.EmailIDReport = Util.GetString(EmailIDReport);
            this.MinBusinessCommitment = Util.GetDecimal(MinBusinessCommitment);
            this.GSTTin = Util.GetString(GSTTin);
            this.BankName = Util.GetString(BankName);
            this.AccountNo = Util.GetString(AccountNo);
            this.IFSCCode = Util.GetString(IFSCCode);
            this.InvoiceBillingCycle = Util.GetString(InvoiceBillingCycle);
            this.BusinessType = Util.GetString(BusinessType);
            this.SalesHierarchy = Util.GetString(SalesHierarchy);
            this.SecurityDeposit = Util.GetString(SecurityDeposit);
            this.ReportInterpretation = Util.GetInt(ReportInterpretation);
            this.BankID = Util.GetInt(BankID);
            this.TagProcessingLabID = Util.GetInt(TagProcessingLabID);
            this.TagProcessingLab = Util.GetString(TagProcessingLab);
            this.ZoneID = Util.GetInt(ZoneID);
            this.Zone = Util.GetString(Zone);
            this.PanelGroup = Util.GetString(PanelGroup);
            this.CentreID = Util.GetInt(CentreID);
            this.ShowAmtInBooking = Util.GetInt(ShowAmtInBooking);
            this.InvoiceTo = Util.GetString(InvoiceTo);
            this.SavingType = Util.GetString(SavingType);
            this.PanelType = Util.GetString(PanelType);
            this.HideReceiptRate = Util.GetInt(HideReceiptRate);
            this.AAALogo = Util.GetInt(AAALogo);
            this.IsInvoice = Util.GetInt(IsInvoice);
            this.InvoiceDisplayName = Util.GetString(InvoiceDisplayName);
            this.InvoiceDisplayNo = Util.GetString(InvoiceDisplayNo);
            this.IsBookingLock = Util.GetInt(IsBookingLock);
            this.IsPrintingLock = Util.GetInt(IsPrintingLock);
            this.PatientPayTo = Util.GetString(PatientPayTo);
            this.SharePercentage = Util.GetDecimal(SharePercentage);
            this.DiscPercent = Util.GetDecimal(DiscPercent);
            this.PROID = Util.GetInt(PROID);
            this.MrpBill = Util.GetInt(MrpBill);
            this.NetBill = Util.GetInt(NetBill);
            this.showBalanceAmt = Util.GetInt(showBalanceAmt);
            this.AutoPreBookingReceipt = Util.GetInt(AutoPreBookingReceipt);
            this.LedgerReportPassword = Util.GetString(LedgerReportPassword);
            this.InvoiceDisplayAddress = Util.GetString(InvoiceDisplayAddress);
            this.SalesManager = Util.GetInt(SalesManager);
            this.SalesManagerName = Util.GetString(SalesManagerName);
            this.ReferringMrpID = Util.GetInt(ReferringMrpID);
            this.ReferringShareID = Util.GetInt(ReferringShareID);
            this.LabReportLimit = LabReportLimit;
            this.IntimationLimit = IntimationLimit;
            this.IsShowIntimation = Util.GetInt(IsShowIntimation);
            this.TagBusinessLabID = Util.GetInt(TagBusinessLabID);
            this.TagBusinessLab = TagBusinessLab;
            this.IsLogisticExpense = Util.GetInt(IsLogisticExpense);
            this.LogisticExpenseRateType = Util.GetInt(LogisticExpenseRateType);
            this.LogisticExpenseToPanelID = Util.GetInt(LogisticExpenseToPanelID);
            this.RollingAdvance = Util.GetInt(RollingAdvance);
            this.OwnerName = Util.GetString(OwnerName);
            this.CentreType1 = Util.GetString(CentreType1);
            this.CentreType1ID = Util.GetInt(CentreType1ID);
            this.IsOtherLabReferenceNo = Util.GetInt(IsOtherLabReferenceNo);
            this.chkExpectedPayment = Util.GetInt(chkExpectedPayment);
            this.ExpectedPaymentDate = Util.GetInt(ExpectedPaymentDate);
            this.IsBatchCreate = Util.GetInt(IsBatchCreate);

            this.BarCodePrintedType = Util.GetString(BarCodePrintedType);
            this.SampleCollectionOnReg = Util.GetInt(SampleCollectionOnReg);
            this.BarCodePrintedCentreType = Util.GetInt(BarCodePrintedCentreType);
            this.BarCodePrintedHomeColectionType = Util.GetInt(BarCodePrintedHomeColectionType);
            this.SetOfBarCode = Util.GetString(SetOfBarCode);
            this.ShowCollectionCharge = Util.GetInt(ShowCollectionCharge);
            this.CollectionCharge = Util.GetInt(CollectionCharge);
            this.ShowDeliveryCharge = Util.GetInt(ShowDeliveryCharge);
            this.DeliveryCharge = Util.GetInt(DeliveryCharge);
            this.CoPaymentApplicable = Util.GetInt(CoPaymentApplicable);
            this.CoPaymentEditonBooking = Util.GetInt(CoPaymentEditonBooking);
            this.ReceiptType = Util.GetString(ReceiptType);
            this.SampleRecollectAfterReject = Util.GetInt(SampleRecollectAfterReject);
            this.MonthlyInvoiceType = Util.GetInt(MonthlyInvoiceType);
            this.InvoiceCreatedOn = Util.GetInt(InvoiceCreatedOn);
            this.CountryID = Util.GetInt(CountryID);
            this.CountryName = Util.GetString(CountryName);           
            this.LocalityID = Util.GetInt(LocalityID);            
            this.CityID = Util.GetInt(CityID);
            this.LocalityID = Util.GetInt(LocalityID);           
            this.StateID = Util.GetInt(StateID);
            //this.ZoneID = Util.GetInt(ZoneID);
            //this.Zone = Util.GetString(Zone);
            this.BusinessZoneID = Util.GetInt(BusinessZoneID);
            this.BusinessZone = Util.GetString(BusinessZone);
            this.IsAllowDoctorShare = Util.GetInt(IsAllowDoctorShare);
            this.CreationDate = Util.GetString(CreationDate);
            this.SecurityAmt = Util.GetInt(SecurityAmt);
            this.SecurityRemark = Util.GetString(SecurityRemark);

            cmd.Parameters.Add(new MySqlParameter("@Company_Name", Company_Name));
            cmd.Parameters.Add(new MySqlParameter("@Payment_Mode", Payment_Mode));
            cmd.Parameters.Add(new MySqlParameter("@Add1", Add1));
            cmd.Parameters.Add(new MySqlParameter("@Panel_Code", Panel_Code));
            cmd.Parameters.Add(new MySqlParameter("@ReferenceCode", ReferenceCode));
            cmd.Parameters.Add(new MySqlParameter("@EmailID", EmailID));
            cmd.Parameters.Add(new MySqlParameter("@Phone", Phone));
            cmd.Parameters.Add(new MySqlParameter("@Mobile", Mobile));
            cmd.Parameters.Add(new MySqlParameter("@Contact_Person", Contact_Person));
            cmd.Parameters.Add(new MySqlParameter("@ReferenceCodeOPD", ReferenceCodeOPD));
            cmd.Parameters.Add(new MySqlParameter("@Agreement", Agreement));
            cmd.Parameters.Add(new MySqlParameter("@DateFrom", DateFrom));
            cmd.Parameters.Add(new MySqlParameter("@DateTo", DateTo));
            cmd.Parameters.Add(new MySqlParameter("@CreditLimit", CreditLimit));
            cmd.Parameters.Add(new MySqlParameter("@PanelGroupID", PanelGroupID));
            cmd.Parameters.Add(new MySqlParameter("@PanelUserID", LoginID));
            cmd.Parameters.Add(new MySqlParameter("@PanelPassword", LoginPassword));
            cmd.Parameters.Add(new MySqlParameter("@Contractdate", Contractdate));
            cmd.Parameters.Add(new MySqlParameter("@TaxPercentage", TaxPercentage));
            cmd.Parameters.Add(new MySqlParameter("@CreatorUserID", HttpContext.Current.Session["ID"].ToString()));
            cmd.Parameters.Add(new MySqlParameter("@IsActive", IsActive));
            cmd.Parameters.Add(new MySqlParameter("@ReportDispatchMode", ReportDispatchMode));
            cmd.Parameters.Add(new MySqlParameter("@CentreID_Print", PrintAtCentre));
            cmd.Parameters.Add(new MySqlParameter("@PrintinLab", PrintinLab));
            cmd.Parameters.Add(new MySqlParameter("@HideRate", HideRate));
            cmd.Parameters.Add(new MySqlParameter("@HideDiscount", HideDiscount));
            cmd.Parameters.Add(new MySqlParameter("@isfullpaidreceipt", isfullpaidreceipt));
            cmd.Parameters.Add(new MySqlParameter("@ShowMRPinReceipt", ShowMRPinReceipt));
            cmd.Parameters.Add(new MySqlParameter("@ShowHeaderinReceipt", ShowHeaderinReceipt));
            cmd.Parameters.Add(new MySqlParameter("@MinBalReceive", MinBalReceive));
            cmd.Parameters.Add(new MySqlParameter("@Fullpaidpanelid", Fullpaidpanelid));
            cmd.Parameters.Add(new MySqlParameter("@city", city));
            cmd.Parameters.Add(new MySqlParameter("@area", area));
            cmd.Parameters.Add(new MySqlParameter("@state", state));
            cmd.Parameters.Add(new MySqlParameter("@EmailIDReport", EmailIDReport));
            cmd.Parameters.Add(new MySqlParameter("@MinBusinessCommitment", MinBusinessCommitment));
            cmd.Parameters.Add(new MySqlParameter("@GSTTin", GSTTin));
            cmd.Parameters.Add(new MySqlParameter("@BankName", BankName));
            cmd.Parameters.Add(new MySqlParameter("@AccountNo", AccountNo));
            cmd.Parameters.Add(new MySqlParameter("@IFSCCode", IFSCCode));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceBillingCycle", InvoiceBillingCycle));
            cmd.Parameters.Add(new MySqlParameter("@BusinessType", BusinessType));
            cmd.Parameters.Add(new MySqlParameter("@SalesHierarchy", SalesHierarchy));
            cmd.Parameters.Add(new MySqlParameter("@SecurityDeposit", SecurityDeposit));
            cmd.Parameters.Add(new MySqlParameter("@ReportInterpretation", ReportInterpretation));
            cmd.Parameters.Add(new MySqlParameter("@BankID", BankID));
            cmd.Parameters.Add(new MySqlParameter("@TagProcessingLabID", TagProcessingLabID));
            cmd.Parameters.Add(new MySqlParameter("@TagProcessingLab", TagProcessingLab));
            cmd.Parameters.Add(new MySqlParameter("@Zone", Zone));
            cmd.Parameters.Add(new MySqlParameter("@ZoneID", ZoneID));
            cmd.Parameters.Add(new MySqlParameter("@PanelGroup", PanelGroup));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@ShowAmtInBooking", ShowAmtInBooking));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceTo", InvoiceTo));
            cmd.Parameters.Add(new MySqlParameter("@SavingType", SavingType));
            cmd.Parameters.Add(new MySqlParameter("@PanelType", PanelType));
            cmd.Parameters.Add(new MySqlParameter("@HideReceiptRate", HideReceiptRate));
            cmd.Parameters.Add(new MySqlParameter("@AAALogo", AAALogo));
            cmd.Parameters.Add(new MySqlParameter("@IsInvoice", IsInvoice));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceDisplayName", InvoiceDisplayName));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceDisplayNo", InvoiceDisplayNo));
            cmd.Parameters.Add(new MySqlParameter("@IsBookingLock", IsBookingLock));
            cmd.Parameters.Add(new MySqlParameter("@IsPrintingLock", IsPrintingLock));
            cmd.Parameters.Add(new MySqlParameter("@PatientPayTo", PatientPayTo));
            cmd.Parameters.Add(new MySqlParameter("@SharePercentage", SharePercentage));
            cmd.Parameters.Add(new MySqlParameter("@DiscPercent", DiscPercent));
            cmd.Parameters.Add(new MySqlParameter("@PROID", PROID));
            cmd.Parameters.Add(new MySqlParameter("@MrpBill", MrpBill));
            cmd.Parameters.Add(new MySqlParameter("@NetBill", NetBill));
            cmd.Parameters.Add(new MySqlParameter("@showBalanceAmt", showBalanceAmt));
            cmd.Parameters.Add(new MySqlParameter("@AutoPreBookingReceipt", AutoPreBookingReceipt));
            cmd.Parameters.Add(new MySqlParameter("@LedgerReportPassword", LedgerReportPassword));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceDisplayAddress", InvoiceDisplayAddress));
            cmd.Parameters.Add(new MySqlParameter("@SalesManager", SalesManager));
            cmd.Parameters.Add(new MySqlParameter("@SalesManagerName", SalesManagerName));
            cmd.Parameters.Add(new MySqlParameter("@PanelID_MRP", ReferringMrpID));
            cmd.Parameters.Add(new MySqlParameter("@PanelShareID", ReferringShareID));
            cmd.Parameters.Add(new MySqlParameter("@LabReportLimit", LabReportLimit));
            cmd.Parameters.Add(new MySqlParameter("@IntimationLimit", IntimationLimit));
            cmd.Parameters.Add(new MySqlParameter("@IsShowIntimation", IsShowIntimation));
            cmd.Parameters.Add(new MySqlParameter("@TagBusinessLabID", TagBusinessLabID));
            cmd.Parameters.Add(new MySqlParameter("@TagBusinessLab", TagBusinessLab));
            cmd.Parameters.Add(new MySqlParameter("@IsLogisticExpense", IsLogisticExpense));
            cmd.Parameters.Add(new MySqlParameter("@LogisticExpenseRateType", LogisticExpenseRateType));
            cmd.Parameters.Add(new MySqlParameter("@LogisticExpenseToPanelID", LogisticExpenseToPanelID));
            cmd.Parameters.Add(new MySqlParameter("@RollingAdvance", RollingAdvance));
            cmd.Parameters.Add(new MySqlParameter("@OwnerName", OwnerName));
            cmd.Parameters.Add(new MySqlParameter("@CentreType1ID", CentreType1ID));
            cmd.Parameters.Add(new MySqlParameter("@CentreType1", CentreType1));
            cmd.Parameters.Add(new MySqlParameter("@IsOtherLabReferenceNo", IsOtherLabReferenceNo));
            cmd.Parameters.Add(new MySqlParameter("@chkExpectedPayment", chkExpectedPayment));
            cmd.Parameters.Add(new MySqlParameter("@ExpectedPaymentDate", ExpectedPaymentDate));
            cmd.Parameters.Add(new MySqlParameter("@IsBatchCreate", IsBatchCreate));

            cmd.Parameters.Add(new MySqlParameter("@BarCodePrintedType", BarCodePrintedType));
            cmd.Parameters.Add(new MySqlParameter("@SampleCollectionOnReg", SampleCollectionOnReg));
            cmd.Parameters.Add(new MySqlParameter("@BarCodePrintedCentreType", BarCodePrintedCentreType));
            cmd.Parameters.Add(new MySqlParameter("@BarCodePrintedHomeColectionType", BarCodePrintedHomeColectionType));
            cmd.Parameters.Add(new MySqlParameter("@SetOfBarCode", SetOfBarCode));
            cmd.Parameters.Add(new MySqlParameter("@ShowCollectionCharge", ShowCollectionCharge));
            cmd.Parameters.Add(new MySqlParameter("@CollectionCharge", CollectionCharge));

            cmd.Parameters.Add(new MySqlParameter("@ShowDeliveryCharge", ShowDeliveryCharge));
            cmd.Parameters.Add(new MySqlParameter("@DeliveryCharge", DeliveryCharge));
            cmd.Parameters.Add(new MySqlParameter("@CoPaymentApplicable", CoPaymentApplicable));
            cmd.Parameters.Add(new MySqlParameter("@CoPaymentEditonBooking", CoPaymentEditonBooking));
            cmd.Parameters.Add(new MySqlParameter("@ReceiptType", ReceiptType));
            cmd.Parameters.Add(new MySqlParameter("@SampleRecollectAfterReject", SampleRecollectAfterReject));
            cmd.Parameters.Add(new MySqlParameter("@MonthlyInvoiceType", MonthlyInvoiceType));
            cmd.Parameters.Add(new MySqlParameter("@InvoiceCreatedOn", InvoiceCreatedOn));
            cmd.Parameters.Add(new MySqlParameter("@CountryID", CountryID));
            cmd.Parameters.Add(new MySqlParameter("@CountryName", CountryName));            
            cmd.Parameters.Add(new MySqlParameter("@LocalityID", LocalityID));            
            cmd.Parameters.Add(new MySqlParameter("@CityId", CityID));
            //cmd.Parameters.Add(new MySqlParameter("@city", city));
            cmd.Parameters.Add(new MySqlParameter("@StateId", StateID));           
            cmd.Parameters.Add(new MySqlParameter("@BusinessZoneID", BusinessZoneID));
            cmd.Parameters.Add(new MySqlParameter("@BusinessZone", BusinessZone));    
            cmd.Parameters.Add(new MySqlParameter("@IsAllowDoctorShare", IsAllowDoctorShare));
            cmd.Parameters.Add(new MySqlParameter("@PANNO", PanNo));
            cmd.Parameters.Add(new MySqlParameter("@PANCardName", PANCardName));
            cmd.Parameters.Add(new MySqlParameter("@SecurityAmtComments", SecurityAmtComments));
            cmd.Parameters.Add(new MySqlParameter("@CreationDate", CreationDate));
            cmd.Parameters.Add(new MySqlParameter("@SecurityAmt", SecurityAmt));
            cmd.Parameters.Add(new MySqlParameter("@SecurityRemark", SecurityRemark));

            cmd.Parameters.Add(paramTnxID);
            Panel_ID = cmd.ExecuteScalar().ToString();
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return Panel_ID.ToString();
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

    #endregion All Public Member Function
}
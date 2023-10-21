using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;

/// <summary>
/// Summary description for All_Update
/// </summary>
public class All_Update
{
    public All_Update()
    {
        //
        // TODO: Add constructor logic here
        //
    }


    public string UpdateCenterMaster(object Centre, object Panel)
    {
        List<CenterMaster> centreMasterData = new JavaScriptSerializer().ConvertToType<List<CenterMaster>>(Centre);
        List<PanelMaster> panelMasterData = new JavaScriptSerializer().ConvertToType<List<PanelMaster>>(Panel);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            int IsDuplicateCentreName = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM centre_master WHERE UCASE(centre)=@centre AND centreID<>@centreID ",
               new MySqlParameter("@centre", centreMasterData[0].Centre.ToUpper()), new MySqlParameter("@centreID", centreMasterData[0].CentreID)));
            if (IsDuplicateCentreName > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Centre Name Already in Used" });


            }
            // To Check Duplicacy Based On UHID Abbreviation Code
            int IsDuplicateCentreUHID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM centre_master WHERE UCASE(UHIDCode)=@UHIDCode AND centreID<>@centreID ",
                new MySqlParameter("@UHIDCode", centreMasterData[0].UHIDCode.ToUpper()), new MySqlParameter("@centreID", centreMasterData[0].CentreID)));
            if (IsDuplicateCentreUHID > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "UHID Abbreviation Code Already Exist" });

            }
            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" Update centre_master SET type1=@type1,type1ID=@type1ID ,Centre=@Centre,CentreCode=@CentreCode,UHIDCode=@UHIDCode,isActive=@isActive,");
            sb1.Append(" Address=@Address,City=@City,State=@State,Locality=@Locality,LocalityID=@LocalityID,CityID=@CityID,StateID=@StateID,");
            sb1.Append(" BusinessZoneID=@BusinessZoneID,BusinessZoneName=@BusinessZoneName,Landline=@Landline,Mobile=@Mobile,Email=@Email,");
            sb1.Append(" UpdatedBy=@UpdatedBy,UpdatedByID=@UpdatedByID,UpdateDate=NOW(),contactPerson=@contactPerson,contactpersonMobile=@contactpersonMobile,");
            sb1.Append(" contactpersonEmail=@contactpersonEmail,contactpersonDesignation=@contactpersonDesignation,zone=@zone,ZoneID=@ZoneID,businessUnit=@businessUnit,");
            sb1.Append(" BusinessUnitID=@BusinessUnitID,Sales_HierarchyID=@Sales_HierarchyID,Sales_HierarchyName=@Sales_HierarchyName ,");
            sb1.Append(" subbusinessUnit=subbusinessUnit,SubBusinessUnitID=@SubBusinessUnitID ,unitHead=@unitHead,UnitHeadID=@UnitHeadID ,");
            sb1.Append(" TagProcessingLabID=@TagProcessingLabID, TagProcessingLab=@TagProcessingLab,OnLineUserName=@OnLineUserName, OnlinePassword=@OnlinePassword,  ");
            sb1.Append(" COCO_FOCO=@COCO_FOCO,IndentType=@IndentType,CountryID=@CountryID,Country=@Country ");
            sb1.Append("  ");
            if (centreMasterData[0].ReferalRate != "0")
                sb1.Append(" ,ReferalRate=@ReferalRate");
            sb1.Append(" where CentreID =@CentreID ");
            MySqlCommand cmd = new MySqlCommand(sb1.ToString(), con, tnx);

            cmd.Parameters.AddWithValue("@type1", centreMasterData[0].type1);
            cmd.Parameters.AddWithValue("@type1ID", centreMasterData[0].type1ID);
            cmd.Parameters.AddWithValue("@Centre", centreMasterData[0].Centre.ToUpper());
            cmd.Parameters.AddWithValue("@CentreCode", centreMasterData[0].CentreCode.ToUpper());
            cmd.Parameters.AddWithValue("@UHIDCode", centreMasterData[0].UHIDCode.ToUpper());
            cmd.Parameters.AddWithValue("@isActive", centreMasterData[0].isActive);
            cmd.Parameters.AddWithValue("@Address", centreMasterData[0].Address);
            cmd.Parameters.AddWithValue("@City", centreMasterData[0].City);
            cmd.Parameters.AddWithValue("@State", centreMasterData[0].State);
            cmd.Parameters.AddWithValue("@Locality", centreMasterData[0].Locality);
            cmd.Parameters.AddWithValue("@LocalityID", centreMasterData[0].LocalityID);
            cmd.Parameters.AddWithValue("@CityID", centreMasterData[0].CityID);
            cmd.Parameters.AddWithValue("@StateID", centreMasterData[0].StateID);
            cmd.Parameters.AddWithValue("@BusinessZoneID", centreMasterData[0].BusinessZoneID);
            cmd.Parameters.AddWithValue("@BusinessZoneName", centreMasterData[0].BusinessZoneName);
            cmd.Parameters.AddWithValue("@Landline", centreMasterData[0].Landline);
            cmd.Parameters.AddWithValue("@Mobile", centreMasterData[0].Mobile);
            cmd.Parameters.AddWithValue("@Email", centreMasterData[0].Email);
            cmd.Parameters.AddWithValue("@UpdatedBy", UserInfo.LoginName);
            cmd.Parameters.AddWithValue("@UpdatedByID", UserInfo.ID);
            cmd.Parameters.AddWithValue("@contactPerson", centreMasterData[0].contactperson);
            cmd.Parameters.AddWithValue("@contactpersonMobile", centreMasterData[0].contactpersonmobile);
            cmd.Parameters.AddWithValue("@contactpersonEmail", centreMasterData[0].contactpersonemail);
            cmd.Parameters.AddWithValue("@contactpersonDesignation", centreMasterData[0].contactpersondesignation);
            cmd.Parameters.AddWithValue("@zone", centreMasterData[0].zone);
            cmd.Parameters.AddWithValue("@ZoneID", centreMasterData[0].ZoneID);
            cmd.Parameters.AddWithValue("@businessUnit", centreMasterData[0].businessunit);
            cmd.Parameters.AddWithValue("@BusinessUnitID", centreMasterData[0].BusinessUnitID);
            cmd.Parameters.AddWithValue("@Sales_HierarchyID", centreMasterData[0].SalesHierarchyID);
            cmd.Parameters.AddWithValue("@Sales_HierarchyName", centreMasterData[0].SalesHierarchyName);
            cmd.Parameters.AddWithValue("@subbusinessUnit", centreMasterData[0].subbusinessunit);
            cmd.Parameters.AddWithValue("@SubBusinessUnitID", centreMasterData[0].SubBusinessUnitID);
            cmd.Parameters.AddWithValue("@unitHead", centreMasterData[0].unithead);
            cmd.Parameters.AddWithValue("@UnitHeadID", centreMasterData[0].UnitHeadID);
            if (centreMasterData[0].TagProcessingLab.ToUpper() != "SELF")
            {
                cmd.Parameters.AddWithValue("@TagProcessingLabID", centreMasterData[0].TagProcessingLabID);
                cmd.Parameters.AddWithValue("@TagProcessingLab", centreMasterData[0].TagProcessingLab);
            }
            else
            {
                cmd.Parameters.AddWithValue("@TagProcessingLabID", centreMasterData[0].CentreID);
                cmd.Parameters.AddWithValue("@TagProcessingLab", centreMasterData[0].Centre);
            }

            cmd.Parameters.AddWithValue("@OnLineUserName", centreMasterData[0].OnLineUserName);
            cmd.Parameters.AddWithValue("@OnlinePassword", centreMasterData[0].OnlinePassword);
            cmd.Parameters.AddWithValue("@COCO_FOCO", centreMasterData[0].SavingType);
            cmd.Parameters.AddWithValue("@IndentType", centreMasterData[0].IndentType);
            if (centreMasterData[0].ReferalRate != "0")
                cmd.Parameters.AddWithValue("@ReferalRate", centreMasterData[0].ReferalRate);
            cmd.Parameters.AddWithValue("@CentreID", centreMasterData[0].CentreID);
            cmd.Parameters.AddWithValue("@CountryID", centreMasterData[0].CountryID);
            cmd.Parameters.AddWithValue("@Country", centreMasterData[0].CountryName);
            cmd.ExecuteNonQuery();


            sb1 = new StringBuilder();
            sb1.Append(" Update f_panel_master SET HideReceiptRate=@HideReceiptRate,Panel_Code=@Panel_Code ,Company_Name=@Company_Name,PanelGroup=@PanelGroup,PanelGroupID=@PanelGroupID,isActive=@isActive,");
            sb1.Append(" Payment_Mode=@Payment_Mode,TagProcessingLabID=@TagProcessingLabID,TagProcessingLab=@TagProcessingLab,");
            sb1.Append(" InvoiceEmailTo=@EmailID,EmailIDReport=@EmailIDReport, ");
            sb1.Append(" ReportDispatchMode=@ReportDispatchMode,MinBusinessCommitment=@MinBusinessCommitment, GSTTin=@GSTTin,AAALogo=@AAALogo,BankName=@BankName,BankID=@BankID, ");
            sb1.Append(" AccountNo=@AccountNo,IFSCCode=@IFSCCode,InvoiceBillingCycle=@InvoiceBillingCycle,PanelUserID=@PanelUserID,PanelPassword=@PanelPassword, ");
            sb1.Append(" MinBalReceive=@MinBalReceive,CreditLimit=@CreditLimit, ");
            sb1.Append(" ShowAmtInBooking=@ShowAmtInBooking,ReportInterpretation=@ReportInterpretation, HideDiscount=@HideDiscount,");
            sb1.Append(" COCO_FOCO=@COCO_FOCO,IsPrintingLock=@IsPrintingLock,IsBookingLock=@IsBookingLock, ");
            sb1.Append(" IsShowIntimation=@IsShowIntimation,IntimationLimit=@IntimationLimit,LabReportLimit=@LabReportLimit,showBalanceAmt='1',");
            sb1.Append(" SecurityDeposit=@SecurityDeposit,RollingAdvance=@RollingAdvance,OwnerName=@OwnerName,HideRate=@HideRate ");
            if (panelMasterData[0].chkLedgerReportPassword == 1)
                sb1.Append(" ,LedgerReportPassword=@LedgerReportPassword ");
            if (panelMasterData[0].TagBusinessLabID != 0)
                sb1.Append(" ,TagBusinessLabID=@TagBusinessLabID,TagBusinessLab=@TagBusinessLab ");
            if (panelMasterData[0].ReferringMrpID != 0)
                sb1.Append(" ,PanelID_MRP=@PanelID_MRP ");
            if (panelMasterData[0].ReferringShareID != 0)
                sb1.Append(" ,PanelShareID=@PanelShareID ");
            if (panelMasterData[0].InvoiceTo != "0")
                sb1.Append(" ,InvoiceTo=@InvoiceTo ");
            if (panelMasterData[0].IsLogisticExpense == 1)
            {
                sb1.Append(" ,IsLogisticExpense=@IsLogisticExpense ");
                if (panelMasterData[0].LogisticExpenseRateType != -1)
                    sb1.Append(" ,LogisticExpenseRateType=@LogisticExpenseRateType ");
                if (panelMasterData[0].LogisticExpenseToPanelID != -1)
                    sb1.Append(" ,LogisticExpenseToPanelID=@LogisticExpenseToPanelID ");
            }
            else
                sb1.Append(" ,IsLogisticExpense=0,LogisticExpenseRateType=0,LogisticExpenseToPanelID=0 ");
            if (panelMasterData[0].ReferenceCodeOPD != "0")
                sb1.Append(" ,ReferenceCode=@ReferenceCode, ReferenceCodeOPD=@ReferenceCodeOPD ");
            sb1.Append(" ,InvoiceDisplayName=@InvoiceDisplayName,InvoiceDisplayNo=@InvoiceDisplayNo,InvoiceDisplayAddress=@InvoiceDisplayAddress, ");
            sb1.Append(" IsInvoice=@IsInvoice,PatientPayTo=@PatientPayTo,SalesManager=@SalesManager,IsOtherLabReferenceNo=@IsOtherLabReferenceNo ");
            sb1.Append(" ,chkExpectedPayment=@chkExpectedPayment,ExpectedPaymentDate=@ExpectedPaymentDate,UpdateID=@UpdateID,UpdateName=@UpdateName,UpdateDate=NOW() ");
            sb1.Append(" ,IsBatchCreate=@IsBatchCreate, ");
            sb1.Append(" BarCodePrintedType=@BarCodePrintedType,SampleCollectionOnReg = @SampleCollectionOnReg,");
            sb1.Append(" BarCodePrintedCentreType=@BarCodePrintedCentreType,BarCodePrintedHomeColectionType = @BarCodePrintedHomeColectionType,");
            sb1.Append(" SetOfBarCode=@SetOfBarCode, ");
            sb1.Append(" ShowCollectionCharge=@ShowCollectionCharge,CollectionCharge=@CollectionCharge,ShowDeliveryCharge=@ShowDeliveryCharge,DeliveryCharge=@DeliveryCharge ");
            sb1.Append(" ,CoPaymentApplicable=@CoPaymentApplicable,CoPaymentEditonBooking=@CoPaymentEditonBooking,ReceiptType=@ReceiptType,SampleRecollectAfterReject=@SampleRecollectAfterReject,MonthlyInvoiceType=@MonthlyInvoiceType,InvoiceCreatedOn=@InvoiceCreatedOn,CountryID=@CountryID,Country=@Country, ");
            sb1.Append(" IsAllowDoctorShare=@IsAllowDoctorShare,MrpBill=@MrpBill,PANNO=@PANNO,PANCardName=@PANCardName,SecurityAmtComments=@SecurityAmtComments where Panel_ID =@Panel_ID ");

            MySqlCommand cmd1 = new MySqlCommand(sb1.ToString(), con, tnx);

            cmd1.Parameters.AddWithValue("@HideReceiptRate", Util.GetInt(panelMasterData[0].HideReceiptRate));
            cmd1.Parameters.AddWithValue("@Panel_Code", panelMasterData[0].Panel_Code);
            cmd1.Parameters.AddWithValue("@Company_Name", centreMasterData[0].Centre.ToUpper());
            cmd1.Parameters.AddWithValue("@PanelGroup", panelMasterData[0].PanelGroup);
            cmd1.Parameters.AddWithValue("@PanelGroupID", panelMasterData[0].PanelGroupID);
            cmd1.Parameters.AddWithValue("@isActive", centreMasterData[0].isActive);
            cmd1.Parameters.AddWithValue("@Payment_Mode", panelMasterData[0].Payment_Mode);
            if (panelMasterData[0].TagProcessingLab.ToUpper() != "SELF")
            {
                cmd1.Parameters.AddWithValue("@TagProcessingLabID", panelMasterData[0].TagProcessingLabID);
                cmd1.Parameters.AddWithValue("@TagProcessingLab", panelMasterData[0].TagProcessingLab);
            }
            else
            {
                cmd1.Parameters.AddWithValue("@TagProcessingLabID", centreMasterData[0].CentreID);
                cmd1.Parameters.AddWithValue("@TagProcessingLab", centreMasterData[0].Centre);
            }

            cmd1.Parameters.AddWithValue("@EmailID", panelMasterData[0].EmailID);
            cmd1.Parameters.AddWithValue("@EmailIDReport", panelMasterData[0].EmailIDReport);
            cmd1.Parameters.AddWithValue("@ReportDispatchMode", panelMasterData[0].ReportDispatchMode);
            cmd1.Parameters.AddWithValue("@MinBusinessCommitment", panelMasterData[0].MinBusinessCommitment);
            cmd1.Parameters.AddWithValue("@GSTTin", panelMasterData[0].GSTTin);
            cmd1.Parameters.AddWithValue("@AAALogo", panelMasterData[0].AAALogo);
            cmd1.Parameters.AddWithValue("@BankName", panelMasterData[0].BankName);
            cmd1.Parameters.AddWithValue("@BankID", panelMasterData[0].BankID);
            cmd1.Parameters.AddWithValue("@AccountNo", panelMasterData[0].AccountNo);
            cmd1.Parameters.AddWithValue("@IFSCCode", panelMasterData[0].IFSCCode);
            cmd1.Parameters.AddWithValue("@InvoiceBillingCycle", panelMasterData[0].InvoiceBillingCycle);
            cmd1.Parameters.AddWithValue("@PanelUserID", panelMasterData[0].PanelUserID);
            cmd1.Parameters.AddWithValue("@PanelPassword", panelMasterData[0].PanelPassword);

            cmd1.Parameters.AddWithValue("@MinBalReceive", panelMasterData[0].MinBalReceive);
            cmd1.Parameters.AddWithValue("@CreditLimit", panelMasterData[0].CreditLimit);
            cmd1.Parameters.AddWithValue("@ShowAmtInBooking", panelMasterData[0].ShowAmtInBooking);
            cmd1.Parameters.AddWithValue("@ReportInterpretation", panelMasterData[0].ReportInterpretation);
            cmd1.Parameters.AddWithValue("@HideDiscount", panelMasterData[0].HideDiscount);
            cmd1.Parameters.AddWithValue("@COCO_FOCO", panelMasterData[0].SavingType);
            cmd1.Parameters.AddWithValue("@IsPrintingLock", panelMasterData[0].IsPrintingLock);
            cmd1.Parameters.AddWithValue("@IsBookingLock", panelMasterData[0].IsBookingLock);
            cmd1.Parameters.AddWithValue("@IsShowIntimation", panelMasterData[0].IsShowIntimation);
            cmd1.Parameters.AddWithValue("@IntimationLimit", panelMasterData[0].IntimationLimit);
            cmd1.Parameters.AddWithValue("@LabReportLimit", panelMasterData[0].LabReportLimit);
            cmd1.Parameters.AddWithValue("@SecurityDeposit", panelMasterData[0].SecurityDeposit);
            cmd1.Parameters.AddWithValue("@RollingAdvance", panelMasterData[0].RollingAdvance);
            cmd1.Parameters.AddWithValue("@OwnerName", panelMasterData[0].OwnerName);
            cmd1.Parameters.AddWithValue("@HideRate", panelMasterData[0].HideRate);
            if (panelMasterData[0].chkLedgerReportPassword == 1)
                cmd1.Parameters.AddWithValue("@LedgerReportPassword", panelMasterData[0].LedgerReportPassword);

            if (panelMasterData[0].TagBusinessLabID != 0)
            {
                cmd1.Parameters.AddWithValue("@TagBusinessLabID", panelMasterData[0].TagBusinessLabID);
                cmd1.Parameters.AddWithValue("@TagBusinessLab", panelMasterData[0].TagBusinessLab);
            }
            if (panelMasterData[0].ReferringMrpID != 0)
                cmd1.Parameters.AddWithValue("@PanelID_MRP", panelMasterData[0].ReferringMrpID);
            if (panelMasterData[0].ReferringShareID != 0)
                cmd1.Parameters.AddWithValue("@PanelShareID", panelMasterData[0].ReferringShareID);

            if (panelMasterData[0].InvoiceTo != "0")
                cmd1.Parameters.AddWithValue("@InvoiceTo", panelMasterData[0].InvoiceTo);
            if (panelMasterData[0].IsLogisticExpense == 1)
            {
                cmd1.Parameters.AddWithValue("@IsLogisticExpense", panelMasterData[0].IsLogisticExpense);
                if (panelMasterData[0].LogisticExpenseRateType != -1)

                    cmd1.Parameters.AddWithValue("@LogisticExpenseRateType", panelMasterData[0].LogisticExpenseRateType);
                if (panelMasterData[0].LogisticExpenseToPanelID != -1)
                    cmd1.Parameters.AddWithValue("@LogisticExpenseToPanelID", panelMasterData[0].LogisticExpenseToPanelID);
            }
            if (panelMasterData[0].ReferenceCodeOPD != "0")
            {
                cmd1.Parameters.AddWithValue("@ReferenceCode", panelMasterData[0].ReferenceCodeOPD);
                cmd1.Parameters.AddWithValue("@ReferenceCodeOPD", panelMasterData[0].ReferenceCodeOPD);
            }
            cmd1.Parameters.AddWithValue("@InvoiceDisplayName", panelMasterData[0].InvoiceDisplayName);
            cmd1.Parameters.AddWithValue("@InvoiceDisplayNo", panelMasterData[0].InvoiceDisplayNo);
            cmd1.Parameters.AddWithValue("@InvoiceDisplayAddress", panelMasterData[0].InvoiceDisplayAddress);
            cmd1.Parameters.AddWithValue("@IsInvoice", panelMasterData[0].IsInvoice);
            cmd1.Parameters.AddWithValue("@PatientPayTo", panelMasterData[0].PatientPayTo);
            cmd1.Parameters.AddWithValue("@SalesManager", panelMasterData[0].SalesManager);
            cmd1.Parameters.AddWithValue("@IsOtherLabReferenceNo", panelMasterData[0].IsOtherLabReferenceNo);
            cmd1.Parameters.AddWithValue("@chkExpectedPayment", panelMasterData[0].chkExpectedPayment);
            cmd1.Parameters.AddWithValue("@ExpectedPaymentDate", panelMasterData[0].ExpectedPaymentDate);
            cmd1.Parameters.AddWithValue("@UpdateID", UserInfo.ID);
            cmd1.Parameters.AddWithValue("@UpdateName", UserInfo.LoginName);
            cmd1.Parameters.AddWithValue("@IsBatchCreate", panelMasterData[0].IsBatchCreate);
            cmd1.Parameters.AddWithValue("@BarCodePrintedType", panelMasterData[0].BarCodePrintedType);
            cmd1.Parameters.AddWithValue("@SampleCollectionOnReg", panelMasterData[0].SampleCollectionOnReg);
            cmd1.Parameters.AddWithValue("@BarCodePrintedCentreType", panelMasterData[0].BarCodePrintedCentreType);
            cmd1.Parameters.AddWithValue("@BarCodePrintedHomeColectionType", panelMasterData[0].BarCodePrintedHomeColectionType);
            cmd1.Parameters.AddWithValue("@SetOfBarCode", panelMasterData[0].SetOfBarCode);
            cmd1.Parameters.AddWithValue("@Panel_ID", panelMasterData[0].Panel_ID);
            cmd1.Parameters.AddWithValue("@ShowCollectionCharge", panelMasterData[0].ShowCollectionCharge);
            cmd1.Parameters.AddWithValue("@CollectionCharge", panelMasterData[0].CollectionCharge);
            cmd1.Parameters.AddWithValue("@ShowDeliveryCharge", panelMasterData[0].ShowDeliveryCharge);
            cmd1.Parameters.AddWithValue("@DeliveryCharge", panelMasterData[0].DeliveryCharge);
            cmd1.Parameters.AddWithValue("@CoPaymentApplicable", panelMasterData[0].CoPaymentApplicable);
            cmd1.Parameters.AddWithValue("@CoPaymentEditonBooking", panelMasterData[0].CoPaymentEditonBooking);
            cmd1.Parameters.AddWithValue("@ReceiptType", panelMasterData[0].ReceiptType);
            cmd1.Parameters.AddWithValue("@SampleRecollectAfterReject", panelMasterData[0].SampleRecollectAfterReject);
            cmd1.Parameters.AddWithValue("@MonthlyInvoiceType", panelMasterData[0].MonthlyInvoiceType);
            cmd1.Parameters.AddWithValue("@InvoiceCreatedOn", panelMasterData[0].InvoiceCreatedOn);
            cmd1.Parameters.AddWithValue("@CountryID", panelMasterData[0].CountryID);
            cmd1.Parameters.AddWithValue("@Country", panelMasterData[0].CountryName);
            cmd1.Parameters.AddWithValue("@IsAllowDoctorShare", panelMasterData[0].IsAllowDoctorShare);
            cmd1.Parameters.AddWithValue("@MrpBill", panelMasterData[0].MrpBill);
            cmd1.Parameters.AddWithValue("@PANNO", panelMasterData[0].PanNo);
            cmd1.Parameters.AddWithValue("@PANCardName", panelMasterData[0].PANCardName);
            cmd1.Parameters.AddWithValue("@SecurityAmtComments", panelMasterData[0].SecurityAmtComments);
            cmd1.ExecuteNonQuery();
            if (panelMasterData[0].LogisticExpenseRateType == -1)
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET LogisticExpenseRateType=@LogisticExpenseRateType  WHERE Panel_ID=@Panel_ID ",
                    new MySqlParameter("@LogisticExpenseRateType", panelMasterData[0].Panel_ID), new MySqlParameter("@Panel_ID", panelMasterData[0].Panel_ID)
                    );
            }
            if (panelMasterData[0].LogisticExpenseToPanelID == -1)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET LogisticExpenseToPanelID=@LogisticExpenseToPanelID  WHERE Panel_ID=@Panel_ID ",
                   new MySqlParameter("@LogisticExpenseToPanelID", panelMasterData[0].Panel_ID), new MySqlParameter("@Panel_ID", panelMasterData[0].Panel_ID)
                   );
            }
            if (panelMasterData[0].ReferenceCodeOPD == "0")
            {
                string upd = "UPDATE f_panel_master SET ReferenceCode='" + panelMasterData[0].Panel_ID + "', ReferenceCodeOPD='" + panelMasterData[0].Panel_ID + "' WHERE Panel_ID='" + panelMasterData[0].Panel_ID + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, upd);

            }
            if (centreMasterData[0].ReferalRate == "0")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE centre_master SET ReferalRate='" + panelMasterData[0].Panel_ID + "' WHERE CentreID='" + centreMasterData[0].CentreID + "'");

            }
            if (panelMasterData[0].InvoiceTo == "0")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET InvoiceTo='" + panelMasterData[0].Panel_ID + "' WHERE Panel_ID='" + panelMasterData[0].Panel_ID + "'");
            }
            if (panelMasterData[0].TagProcessingLab.ToUpper() == "SELF")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET TagProcessingLab=@TagProcessingLab,TagProcessingLabID=@TagProcessingLabID WHERE CentreID=@CentreID",
                     new MySqlParameter("@TagProcessingLab", centreMasterData[0].Centre), new MySqlParameter("@TagProcessingLabID", centreMasterData[0].CentreID), new MySqlParameter("@CentreID", centreMasterData[0].CentreID)
                    );
            }
            if (panelMasterData[0].ReferringMrpID == 0)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET PanelID_MRP=@ReferringMrpID WHERE Panel_ID=@Panel_ID",
                   new MySqlParameter("@ReferringMrpID", panelMasterData[0].Panel_ID), new MySqlParameter("@Panel_ID", panelMasterData[0].Panel_ID));
            }
            if (panelMasterData[0].ReferringShareID == 0)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET PanelShareID=@ReferringShareID WHERE Panel_ID=@Panel_ID",
                   new MySqlParameter("@ReferringShareID", panelMasterData[0].Panel_ID), new MySqlParameter("@Panel_ID", panelMasterData[0].Panel_ID));
            }
            if (panelMasterData[0].TagBusinessLabID == 0)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET TagBusinessLabID=@TagBusinessLabID,TagBusinessLab=@TagBusinessLab WHERE Panel_ID=@Panel_ID",
                     new MySqlParameter("@TagBusinessLabID", centreMasterData[0].CentreID), new MySqlParameter("@TagBusinessLab", centreMasterData[0].Centre), new MySqlParameter("@Panel_ID", panelMasterData[0].Panel_ID));
            }
            if (panelMasterData[0].IsLogisticExpense == 1 && panelMasterData[0].LogisticExpenseRateType == -1)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET LogisticExpenseRateType=@LogisticExpenseRateType WHERE Panel_ID=@Panel_ID",
                     new MySqlParameter("@LogisticExpenseRateType", panelMasterData[0].Panel_ID), new MySqlParameter("@Panel_ID", panelMasterData[0].Panel_ID));
            }
            if (panelMasterData[0].IsLogisticExpense == 1 && panelMasterData[0].LogisticExpenseToPanelID == -1)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET LogisticExpenseToPanelID=@LogisticExpenseToPanelID WHERE Panel_ID=@Panel_ID",
                     new MySqlParameter("@LogisticExpenseToPanelID", panelMasterData[0].Panel_ID), new MySqlParameter("@Panel_ID", panelMasterData[0].Panel_ID));
            }
            //    if (centreMasterData[0].isActive == 0)
            //  {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE centre_panel SET isActive=@isActive WHERE CentreID=@CentreID",
               new MySqlParameter("@isActive", centreMasterData[0].isActive), new MySqlParameter("@CentreID", centreMasterData[0].CentreID));
            //  }    

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO Centre_master_log(CentreID,Centre_master_log,f_panel_master_log,CreatedBy,CreatedByID,LogType)VALUES(@CentreID,@Centre_master_log,@f_panel_master_log,@CreatedBy,@CreatedByID,'Update') ",
                new MySqlParameter("@Centre_master_log", Newtonsoft.Json.JsonConvert.SerializeObject(centreMasterData)), new MySqlParameter("@f_panel_master_log", Newtonsoft.Json.JsonConvert.SerializeObject(panelMasterData)),
                new MySqlParameter("@CentreID", centreMasterData[0].CentreID), new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID));

            int Centre_master_log_ID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT @@identity"));


            tnx.Commit();
            cmd.Dispose();
            cmd1.Dispose();
            centreMasterData.Clear();
            panelMasterData.Clear();
            return JsonConvert.SerializeObject(new { status = true, LogID = Common.Encrypt(Util.GetString(Centre_master_log_ID)) });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return JsonConvert.SerializeObject(new { status = false, response = "Error Occurred" });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    public string UpdatePUP(object Panel, int DocumentID)
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(17);
        int ReqCount = MT.GetIPCount(17);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return "Too Many Request,Try Again after some";
        }
        List<PanelMaster> panelMasterData = new JavaScriptSerializer().ConvertToType<List<PanelMaster>>(Panel);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb_1 = new StringBuilder();
            //psc.SharePer,psc.ItemCategory ,fpm.Pan,
             sb_1 = new StringBuilder();
             sb_1.Append(" SELECT  fpm.IsInvoice,fpm.SecurityRemark,fpm.SecurityAmt,fpm.ReceiptType,fpm.PANCardName,fpm.SampleRecollectAfterReject,fpm.SetOfBarCode,fpm.BarCodePrintedHomeColectionType,fpm.BarCodePrintedCentreType,fpm.SampleCollectionOnReg,fpm.IsOtherLabReferenceNo ,fpm.PROID,fpm.PanelID_MRP,fpm.ReferenceCodeOPD,fpm.ReferenceCode ,fpm.InvoiceTo,fpm.COCO_FOCO,fpm.HideDiscount,fpm.ReportInterpretation,fpm.ShowAmtInBooking,fpm.MinBalReceive, fpm.CentreID_Print,fpm.GSTTin ,fpm.TagBusinessLabID,fpm.AAALogo,fpm.TagHUBID ,fpm.IntimationLimit,fpm.SalesManagerID,fpm.AllowSharing,fpm.SalesManager `SalesManager`,fpm.RollingAdvance `RollingAdvance`,fpm.LabReportLimit `ReportingCreditLimit`,fpm.IsShowIntimation `ShowIntimation`,");
             sb_1.Append(" fpm.IntimationLimit `IntimationLimit`,fpm.HideReceiptRate `HideReceiptRate`,fpm.Company_Name `PUPName`,fpm.Add1 `Address`,fpm.PanelGroup `Type`, fpm.IsActive `Active`,fpm.Mobile `MobileNo`,fpm.Phone `LandLineNo`,fpm.Payment_Mode `PaymentMode`,fpm.TagProcessingLab `TagProcessingLab` ,");
             sb_1.Append(" fpm.EmailID `EmailId(Invoice)`,fpm.EmailIDReport `EmailId(Report)`,fpm.ReportDispatchMode `ReportDispatchMode`,fpm.MinBusinessCommitment `MinBusinessCom`,fpm.GSTTin `GSTTIN`,fpm.InvoiceBillingCycle `InvoiceBillingCycle`,fpm.BankName `BankName`,fpm.AccountNo `AccountNo`,fpm.IFSCCode `IFSCCode`,  ");
             sb_1.Append(" fpm.PanelUserID `OnlineUserName`,fpm.PanelPassword `OnlinePassword`, ");
             sb_1.Append(" fpm.CreditLimit `ReportingCreditLimit`,fpm.IsPrintingLock `fpm.IsPrintingLock`,fpm.IsBookingLock `IsBookingLock`,");
             sb_1.Append(" fpm.InvoiceDisplayName `InvoiceDisplayName`,fpm.InvoiceDisplayNo `InvoiceDispNo`,fpm.HideRate `HideReceiptRate`, ");
             sb_1.Append(" fpm.BarCodePrintedType `BarCodeType`, ");
             sb_1.Append(" fpm.Country `Country`,fpm.City `City`,fpm.state `State`,fpm.area `Locality`,fpm.Zone `CityZone`,fpm.BusinessZone `BusinessZone`,fpm.IsAllowDoctorShare `AllowDoctorShare`,");
             sb_1.Append(" fpm.PANNO `PAN`,fpm.showBalanceAmt,fpm.OwnerName `Owner Name`,fpm.Panel_Code `PUPCode`");//inner join f_panel_share_items_category psc on psc.Panel_ID=fpm.Panel_ID
             sb_1.Append(" from f_panel_master fpm  where fpm.Panel_ID ='" + panelMasterData[0].Panel_ID + "';");
              DataTable dt_LTD_1 = StockReports.GetDataTable(sb_1.ToString());
            int IsPanelCodeExists = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT COUNT(1) FROM f_panel_master WHERE Panel_Code = @Panel_Code AND Panel_ID<>@Panel_ID ",
            new MySqlParameter("@Panel_Code", panelMasterData[0].Panel_Code), new MySqlParameter("@Panel_ID", panelMasterData[0].Panel_ID)));
            if (IsPanelCodeExists > 0)
                return JsonConvert.SerializeObject(new { status = false, response = "PUP Code Already Exist", focusControl = "txtPUPCode" });

            string loginid = StockReports.ExecuteScalar(" SELECT pnl.PanelUserID FROM `f_panel_master` pnl WHERE  pnl.`PanelUserID`='" + panelMasterData[0].LoginID + "' AND pnl.panel_id<> '" +panelMasterData[0].Panel_ID +"'  ");
          
            if (loginid == panelMasterData[0].LoginID && loginid != string.Empty)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "UserName Already Exist", focusControl = "txtOnlineUserName" });
                //return JsonConvert.SerializeObject("Not Saved");
            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" Update f_panel_master Set AllowSharing=@AllowSharing ,SalesManagerID=@SalesManagerID,SalesManager=@SalesManager,RollingAdvance=@RollingAdvance,LabReportLimit=@LabReportLimit,IsShowIntimation=@IsShowIntimation,IntimationLimit=@IntimationLimit,TagHUBID=@TagHUBID,HideReceiptRate=@HideReceiptRate,Company_Name=@Company_Name,Add1=@Add1,AAALogo=@AAALogo,PanelGroup=@PanelGroup, PanelGroupID=@PanelGroupID, ");
            sb.Append(" IsActive=@IsActive,Mobile=@Mobile,Phone=@Phone,Payment_Mode=@Payment_Mode,TagProcessingLabID=@TagProcessingLabID, TagProcessingLab=@TagProcessingLab,TagBusinessLabID=@TagBusinessLabID, ");
            sb.Append(" EmailID=@EmailID,EmailIDReport=@EmailIDReport,ReportDispatchMode=@ReportDispatchMode,MinBusinessCommitment=@MinBusinessCommitment, ");
            sb.Append(" GSTTin=@GSTTin,InvoiceBillingCycle=@InvoiceBillingCycle,BankName=@BankName,BankID=@BankID,AccountNo=@AccountNo,IFSCCode=@IFSCCode, ");
            sb.Append(" PanelUserID=@PanelUserID,PanelPassword=@PanelPassword,CentreID_Print=@CentreID_Print,MinBalReceive=@MinBalReceive ,  ");
            sb.Append(" CreditLimit=@CreditLimit,ShowAmtInBooking=@ShowAmtInBooking ,ReportInterpretation=@ReportInterpretation,  ");
            sb.Append(" HideDiscount=@HideDiscount,COCO_FOCO=@COCO_FOCO,IsPrintingLock=@IsPrintingLock ,IsBookingLock=@IsBookingLock,InvoiceTo=@InvoiceTo,IsInvoice=1");
            if (panelMasterData[0].ReferenceCodeOPD != "0")
                sb.Append(" ,ReferenceCode=@ReferenceCode, ReferenceCodeOPD=@ReferenceCodeOPD ");
            sb.Append(" ,InvoiceDisplayName=@InvoiceDisplayName,InvoiceDisplayNo=@InvoiceDisplayNo,PROID=@PROID,HideRate=@HideRate,IsOtherLabReferenceNo=@IsOtherLabReferenceNo, ");
            sb.Append(" BarCodePrintedType=@BarCodePrintedType,SampleCollectionOnReg = @SampleCollectionOnReg,BarCodePrintedCentreType=@BarCodePrintedCentreType,");
            sb.Append(" BarCodePrintedHomeColectionType = @BarCodePrintedHomeColectionType,SetOfBarCode=@SetOfBarCode,SampleRecollectAfterReject=@SampleRecollectAfterReject,");
            sb.Append("CountryID=@CountryID,Country=@CountryName,CityId=@CityId, City=@city,StateId=@StateId,state=@state,area=@area,LocalityID=@LocalityID,ZoneID=@ZoneID,Zone=@ZoneName,BusinessZoneID=@BusinessZoneID,BusinessZone=@BusinessZone,IsAllowDoctorShare=@IsAllowDoctorShare,MonthlyInvoiceType=@MonthlyInvoiceType,InvoiceCreatedOn=@InvoiceCreatedOn");
            sb.Append(" ,PANNO=@PANNO,PANCardName=@PANCardName,PanelCreationDt=@CreationDate,ReceiptType=@ReceiptType,showBalanceAmt=@showbalamount,SecurityAmt=@SecurityAmt,SecurityRemark=@SecurityRemark");
            sb.Append(" ,Panel_Code=@Panel_Code where Panel_ID =@Panel_ID "); 
          
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            MySqlCommand cmd1 = new MySqlCommand(sb.ToString(), con, tnx);
            cmd1.Parameters.AddWithValue("@RollingAdvance", panelMasterData[0].RollingAdvance);
            cmd1.Parameters.AddWithValue("@Panel_Code", panelMasterData[0].Panel_Code);
            cmd1.Parameters.AddWithValue("@IsShowIntimation", panelMasterData[0].IsShowIntimation);
            cmd1.Parameters.AddWithValue("@IntimationLimit", panelMasterData[0].IntimationLimit);
            cmd1.Parameters.AddWithValue("@LabReportLimit", panelMasterData[0].LabReportLimit);
            cmd1.Parameters.AddWithValue("@SalesManagerID", panelMasterData[0].SalesManager);
            cmd1.Parameters.AddWithValue("@SalesManager", panelMasterData[0].SalesManagerName);
            cmd1.Parameters.AddWithValue("@TagHUBID", Util.GetInt(panelMasterData[0].TagHUB));
            cmd1.Parameters.AddWithValue("@HideReceiptRate", panelMasterData[0].HideReceiptRate);
            cmd1.Parameters.AddWithValue("@Company_Name", panelMasterData[0].Company_Name.ToUpper());
            cmd1.Parameters.AddWithValue("@Add1", panelMasterData[0].Add1);
            cmd1.Parameters.AddWithValue("@AAALogo", panelMasterData[0].AAALogo);
            cmd1.Parameters.AddWithValue("@PanelGroup", panelMasterData[0].PanelGroup);
            cmd1.Parameters.AddWithValue("@PanelGroupID", panelMasterData[0].PanelGroupID);
            cmd1.Parameters.AddWithValue("@IsActive", panelMasterData[0].IsActive);
            cmd1.Parameters.AddWithValue("@Mobile", panelMasterData[0].Mobile);
            cmd1.Parameters.AddWithValue("@Phone", panelMasterData[0].Phone);
            cmd1.Parameters.AddWithValue("@Payment_Mode", panelMasterData[0].Payment_Mode);
            cmd1.Parameters.AddWithValue("@TagProcessingLabID", panelMasterData[0].TagProcessingLabID);
            cmd1.Parameters.AddWithValue("@TagProcessingLab", panelMasterData[0].TagProcessingLab);
                cmd1.Parameters.AddWithValue("@TagBusinessLabID", panelMasterData[0].TagBusinessLabID);
            cmd1.Parameters.AddWithValue("@EmailID", panelMasterData[0].EmailID);
            cmd1.Parameters.AddWithValue("@EmailIDReport", panelMasterData[0].EmailIDReport);
            cmd1.Parameters.AddWithValue("@ReportDispatchMode", panelMasterData[0].ReportDispatchMode);
            cmd1.Parameters.AddWithValue("@MinBusinessCommitment", panelMasterData[0].MinBusinessCommitment);
            cmd1.Parameters.AddWithValue("@GSTTin", panelMasterData[0].GSTTin);
            cmd1.Parameters.AddWithValue("@InvoiceBillingCycle", panelMasterData[0].InvoiceBillingCycle);
            cmd1.Parameters.AddWithValue("@BankName", panelMasterData[0].BankName);
            cmd1.Parameters.AddWithValue("@BankID", panelMasterData[0].BankID);
            cmd1.Parameters.AddWithValue("@AccountNo", panelMasterData[0].AccountNo);
            cmd1.Parameters.AddWithValue("@IFSCCode", panelMasterData[0].IFSCCode);
            cmd1.Parameters.AddWithValue("@PanelUserID", panelMasterData[0].LoginID);
            cmd1.Parameters.AddWithValue("@PanelPassword", panelMasterData[0].LoginPassword);
            cmd1.Parameters.AddWithValue("@CentreID_Print", panelMasterData[0].PrintAtCentre);
            cmd1.Parameters.AddWithValue("@MinBalReceive", panelMasterData[0].MinBalReceive);
            cmd1.Parameters.AddWithValue("@CreditLimit", panelMasterData[0].CreditLimit);
            cmd1.Parameters.AddWithValue("@ShowAmtInBooking", panelMasterData[0].ShowAmtInBooking);
            cmd1.Parameters.AddWithValue("@ReportInterpretation", panelMasterData[0].ReportInterpretation);
            cmd1.Parameters.AddWithValue("@HideDiscount", panelMasterData[0].HideDiscount);
            cmd1.Parameters.AddWithValue("@COCO_FOCO", panelMasterData[0].SavingType);
            cmd1.Parameters.AddWithValue("@IsPrintingLock", panelMasterData[0].IsPrintingLock);
            cmd1.Parameters.AddWithValue("@IsBookingLock", panelMasterData[0].IsBookingLock);
            cmd1.Parameters.AddWithValue("@InvoiceTo", panelMasterData[0].InvoiceTo);
            if (panelMasterData[0].ReferenceCodeOPD != "0")
            {
                cmd1.Parameters.AddWithValue("@ReferenceCode", panelMasterData[0].ReferenceCodeOPD);
                cmd1.Parameters.AddWithValue("@ReferenceCodeOPD", panelMasterData[0].ReferenceCodeOPD);
            }
            cmd1.Parameters.AddWithValue("@InvoiceDisplayName", panelMasterData[0].InvoiceDisplayName);
            cmd1.Parameters.AddWithValue("@InvoiceDisplayNo", panelMasterData[0].InvoiceDisplayNo);
            cmd1.Parameters.AddWithValue("@PROID", panelMasterData[0].PROID);
            cmd1.Parameters.AddWithValue("@HideRate", panelMasterData[0].HideRate);
            cmd1.Parameters.AddWithValue("@IsOtherLabReferenceNo", panelMasterData[0].IsOtherLabReferenceNo);
            cmd1.Parameters.AddWithValue("@BarCodePrintedType", panelMasterData[0].BarCodePrintedType);
            cmd1.Parameters.AddWithValue("@SampleCollectionOnReg", panelMasterData[0].SampleCollectionOnReg);
            cmd1.Parameters.AddWithValue("@BarCodePrintedCentreType", panelMasterData[0].BarCodePrintedCentreType);
            cmd1.Parameters.AddWithValue("@BarCodePrintedHomeColectionType", panelMasterData[0].BarCodePrintedHomeColectionType);
            cmd1.Parameters.AddWithValue("@SetOfBarCode", panelMasterData[0].SetOfBarCode);
            cmd1.Parameters.AddWithValue("@SampleRecollectAfterReject", panelMasterData[0].SampleRecollectAfterReject);
            cmd1.Parameters.AddWithValue("@Panel_ID", panelMasterData[0].Panel_ID);
            cmd1.Parameters.AddWithValue("@CountryName", panelMasterData[0].CountryName);
            cmd1.Parameters.AddWithValue("@CountryID", panelMasterData[0].CountryID);
            cmd1.Parameters.AddWithValue("@area", panelMasterData[0].area);
            cmd1.Parameters.AddWithValue("@LocalityID", panelMasterData[0].LocalityID);
            
            cmd1.Parameters.AddWithValue("@ZoneID", panelMasterData[0].ZoneID);
            cmd1.Parameters.AddWithValue("@ZoneName", panelMasterData[0].Zone);
           

            cmd1.Parameters.AddWithValue("@CityId", panelMasterData[0].CityID);
            cmd1.Parameters.AddWithValue("@city", panelMasterData[0].city);

            cmd1.Parameters.AddWithValue("@StateId", panelMasterData[0].StateID);
            cmd1.Parameters.AddWithValue("@state", panelMasterData[0].state);

            cmd1.Parameters.AddWithValue("@BusinessZoneID", panelMasterData[0].BusinessZoneID);
            cmd1.Parameters.AddWithValue("@BusinessZone", panelMasterData[0].BusinessZone);
            cmd1.Parameters.AddWithValue("@IsAllowDoctorShare", panelMasterData[0].IsAllowDoctorShare);
            cmd1.Parameters.AddWithValue("@MonthlyInvoiceType", panelMasterData[0].MonthlyInvoiceType);
            cmd1.Parameters.AddWithValue("@InvoiceCreatedOn", panelMasterData[0].InvoiceCreatedOn);
            cmd1.Parameters.AddWithValue("@ReceiptType", panelMasterData[0].ReceiptType);
           
            cmd1.Parameters.AddWithValue("@PANNO", panelMasterData[0].PanNo);
            cmd1.Parameters.AddWithValue("@PANCardName", panelMasterData[0].PANCardName);
            cmd1.Parameters.AddWithValue("@showbalamount", panelMasterData[0].showBalanceAmt);
            cmd1.Parameters.AddWithValue("@CreationDate", panelMasterData[0].CreationDate);
            cmd1.Parameters.AddWithValue("@SecurityAmt", panelMasterData[0].SecurityAmt);
            cmd1.Parameters.AddWithValue("@SecurityRemark", panelMasterData[0].SecurityRemark);
            cmd1.Parameters.AddWithValue("@AllowSharing", panelMasterData[0].AllowSharing);
            
            
            cmd1.ExecuteNonQuery();
            if (panelMasterData[0].ReferenceCodeOPD == "0")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET ReferenceCode=@ReferenceCode, ReferenceCodeOPD=@ReferenceCodeOPD WHERE Panel_ID=@Panel_ID",
                    new MySqlParameter("@ReferenceCode", panelMasterData[0].Panel_ID), new MySqlParameter("@ReferenceCodeOPD", panelMasterData[0].Panel_ID),
                    new MySqlParameter("@Panel_ID", panelMasterData[0].Panel_ID));
            }
            if (panelMasterData[0].InvoiceTo == "0")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET InvoiceTo=@InvoiceTo WHERE Panel_ID=@Panel_ID",
                    new MySqlParameter("@InvoiceTo", panelMasterData[0].Panel_ID), new MySqlParameter("@Panel_ID", panelMasterData[0].Panel_ID));

            }
            int oldhub = Util.GetInt(StockReports.ExecuteScalar("select TagBusinessLabID from f_panel_master where Panel_ID='" + panelMasterData[0].Panel_ID + "'"));
            if (oldhub != Util.GetInt(panelMasterData[0].TagBusinessLabID))
            {
              //  MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE centre_panel SET isActive=@isActive WHERE CentreID=@CentreID and PanelID=@PanelID",
              // new MySqlParameter("@isActive", '0'), new MySqlParameter("@CentreID", panelMasterData[0].TagHUB)
              // , new MySqlParameter("@PanelID", panelMasterData[0].Panel_ID));
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE centre_panel SET isActive=@isActive WHERE PanelID=@PanelID",
                         new MySqlParameter("@isActive", "0"),
                         new MySqlParameter("@PanelID", panelMasterData[0].Panel_ID));
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO centre_panel(CentreID,PanelID,UserID)VALUES(@CentreID,@PanelID,@UserID)",
              new MySqlParameter("@CentreID", panelMasterData[0].TagBusinessLabID), new MySqlParameter("@PanelID", panelMasterData[0].Panel_ID), new MySqlParameter("@UserID", UserInfo.ID));

            
            }
           

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO pup_master_log(Panel_ID,f_panel_master_log,CreatedBy,CreatedByID,LogType)VALUES(@Panel_ID,@f_panel_master_log,@CreatedBy,@CreatedByID,'Update') ",
              new MySqlParameter("@f_panel_master_log", Newtonsoft.Json.JsonConvert.SerializeObject(panelMasterData)),
              new MySqlParameter("@Panel_ID", panelMasterData[0].Panel_ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
              new MySqlParameter("@CreatedByID", UserInfo.ID));

            if (panelMasterData[0].IsPanelLogin == 1 && panelMasterData[0].TagBusinessLabID != 0 && panelMasterData[0].LoginID != "" && panelMasterData[0].LoginPassword != "")
            {


                //string roleID = "183"; //PCC
                //int DesgID = 59;
                //string Desg = "PCC";
                //if (panelMasterData[0].Panel_ID != panelMasterData[0].InvoiceTo) //SubPCC
                //{
                //    //roleID = "";
                //    DesgID = 60;
                //    Desg = "SUB PCC";
                //}

                string roleID, Desg = "";
                int DesgID = 0;

                if (panelMasterData[0].Panel_ID != panelMasterData[0].InvoiceTo) //SubPCC
                {
                    roleID = "252"; //SUBPCC
                    DesgID = 60;
                    Desg = "SUB PCC";
                }
                else
                {
                    roleID = "183"; //PCC
                    DesgID = 59;
                    Desg = "PCC";
                }


                string Employee_id = "";
                MSTEmployee objMSTEmployee = new MSTEmployee(tnx);
                objMSTEmployee.Title = "Mr.";
                objMSTEmployee.Name = panelMasterData[0].Company_Name;
                objMSTEmployee.House_No = ""; // panelMasterData[0].Add1;
                objMSTEmployee.Street_Name = "";
                objMSTEmployee.Locality = "";
                objMSTEmployee.City = "";
                objMSTEmployee.PinCode = 0;
                objMSTEmployee.PHouse_No = "";
                objMSTEmployee.PStreet_Name = "";
                objMSTEmployee.PLocality = "";
                objMSTEmployee.PCity = "";
                objMSTEmployee.PPinCode = 0;
                objMSTEmployee.FatherName = "";
                objMSTEmployee.MotherName = "";
                objMSTEmployee.ESI_No = "";
                objMSTEmployee.EPF_No = "";
                objMSTEmployee.PAN_No = "";
                objMSTEmployee.Passport_No = "";
                //objMSTEmployee.DOB = Util.GetDateTime(DOB.Trim());
                objMSTEmployee.Qualification = "";
                objMSTEmployee.Email = panelMasterData[0].EmailID.Trim();
                objMSTEmployee.AllowSharing = "0";
                objMSTEmployee.Phone = "";
                objMSTEmployee.Mobile = panelMasterData[0].Mobile.Trim();
                objMSTEmployee.Blood_Group = "";
                //  objMSTEmployee.StartDate = Util.GetDateTime(StartDate.Trim());
                objMSTEmployee.Designation = Desg;
                objMSTEmployee.DesignationID = DesgID; ;
                objMSTEmployee.CreatedByID = Util.GetInt(UserInfo.ID);
                objMSTEmployee.ApproveSpecialRate = 0;
                objMSTEmployee.AmrValueAccess = 0;
                objMSTEmployee.ValidateLogin = 1;
                objMSTEmployee.IsMobileAccess = 0;
                objMSTEmployee.PROID = 0;
                objMSTEmployee.IsHideRate = 0;
                objMSTEmployee.IsEditMacReading = 0;
                objMSTEmployee.IsSampleLogisticReject = 0;
                objMSTEmployee.CreatedBy = UserInfo.LoginName;
                objMSTEmployee.GlobalReportAccess = 0;
                objMSTEmployee.Employee_ID = Util.GetString(panelMasterData[0].EmployeeID);
                if (panelMasterData[0].EmployeeID != 0)
                {
                    objMSTEmployee.Update();
                    Employee_id = Util.GetString(panelMasterData[0].EmployeeID);
                }
                else
                    Employee_id = objMSTEmployee.Insert();
                string rsltdata = SaveLogin(tnx, Employee_id, panelMasterData[0].LoginID, panelMasterData[0].LoginPassword, panelMasterData[0].PanelPassword, Util.GetString(panelMasterData[0].TagBusinessLabID), roleID, "1", panelMasterData[0].TagBusinessLabID, Util.GetInt(roleID));
                if (rsltdata.IndexOf("Record Saved") > 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update f_panel_master set employee_id='" + Employee_id + "' where panel_ID='" + panelMasterData[0].Panel_ID + "'");
                }
                else
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Not Saved" });
                }
                sb_1 = new StringBuilder();
                sb_1.Append(" SELECT  fpm.IsInvoice,fpm.SecurityRemark,fpm.SecurityAmt,fpm.ReceiptType,fpm.PANCardName,fpm.SampleRecollectAfterReject,fpm.SetOfBarCode,fpm.BarCodePrintedHomeColectionType,fpm.BarCodePrintedCentreType,fpm.SampleCollectionOnReg,fpm.IsOtherLabReferenceNo ,fpm.PROID,fpm.PanelID_MRP,fpm.ReferenceCodeOPD,fpm.ReferenceCode ,fpm.InvoiceTo,fpm.COCO_FOCO,fpm.HideDiscount,fpm.ReportInterpretation,fpm.ShowAmtInBooking,fpm.MinBalReceive, fpm.CentreID_Print,fpm.GSTTin ,fpm.TagBusinessLabID,fpm.AAALogo,fpm.TagHUBID ,fpm.IntimationLimit,fpm.SalesManagerID,fpm.AllowSharing,fpm.SalesManager `SalesManager`,fpm.RollingAdvance `RollingAdvance`,fpm.LabReportLimit `ReportingCreditLimit`,fpm.IsShowIntimation `ShowIntimation`,");
                sb_1.Append(" fpm.IntimationLimit `IntimationLimit`,fpm.HideReceiptRate `HideReceiptRate`,fpm.Company_Name `PUPName`,fpm.Add1 `Address`,fpm.PanelGroup `Type`, fpm.IsActive `Active`,fpm.Mobile `MobileNo`,fpm.Phone `LandLineNo`,fpm.Payment_Mode `PaymentMode`,fpm.TagProcessingLab `TagProcessingLab` ,");
                sb_1.Append(" fpm.EmailID `EmailId(Invoice)`,fpm.EmailIDReport `EmailId(Report)`,fpm.ReportDispatchMode `ReportDispatchMode`,fpm.MinBusinessCommitment `MinBusinessCom`,fpm.GSTTin `GSTTIN`,fpm.InvoiceBillingCycle `InvoiceBillingCycle`,fpm.BankName `BankName`,fpm.AccountNo `AccountNo`,fpm.IFSCCode `IFSCCode`,  ");
                sb_1.Append(" fpm.PanelUserID `OnlineUserName`,fpm.PanelPassword `OnlinePassword`, ");
                sb_1.Append(" fpm.CreditLimit `ReportingCreditLimit`,fpm.IsPrintingLock `fpm.IsPrintingLock`,fpm.IsBookingLock `IsBookingLock`,");
                sb_1.Append(" fpm.InvoiceDisplayName `InvoiceDisplayName`,fpm.InvoiceDisplayNo `InvoiceDispNo`,fpm.HideRate `HideReceiptRate`, ");
                sb_1.Append(" fpm.BarCodePrintedType `BarCodeType`, ");
                sb_1.Append(" fpm.Country `Country`,fpm.City `City`,fpm.state `State`,fpm.area `Locality`,fpm.Zone `CityZone`,fpm.BusinessZone `BusinessZone`,fpm.IsAllowDoctorShare `AllowDoctorShare`,");
                sb_1.Append(" fpm.PANNO `PAN`,fpm.showBalanceAmt,fpm.OwnerName `Owner Name`,fpm.Panel_Code `PUPCode`");//inner join f_panel_share_items_category psc on psc.Panel_ID=fpm.Panel_ID
                sb_1.Append(" from f_panel_master fpm  where fpm.Panel_ID ='" + panelMasterData[0].Panel_ID + "';");

                DataTable dt_LTD_2 = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb_1.ToString()).Tables[0];

                for (int j = 0; j < dt_LTD_1.Rows.Count; j++)
                {


                    for (int i = 0; i < dt_LTD_1.Columns.Count; i++)
                    {
                        string _ColumnName = dt_LTD_1.Columns[i].ColumnName;
                        if ((Util.GetString(dt_LTD_1.Rows[j][i]) != Util.GetString(dt_LTD_2.Rows[j][i])))
                        {
                            sb_1 = new StringBuilder();
                            sb_1.Append("  INSERT INTO `patient_labinvestigation_opd_update_status`(`LedgertransactionNo`,`Status`,OLDNAME,`NEWNAME`,UserID,UserName,dtEntry,RoleID,CentreID,Remarks,IpAddress) ");
                            sb_1.Append("  values('','Panel Update','" + Util.GetString(dt_LTD_1.Rows[j][i]) + "','" + Util.GetString(dt_LTD_2.Rows[j][i]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["RoleID"]) + "','" + Util.GetString(UserInfo.Centre) + "','Change " + dt_LTD_2.Rows[j]["PUPName"] + " " + _ColumnName + " from " + Util.GetString(dt_LTD_1.Rows[j][i]) + " to " + Util.GetString(dt_LTD_2.Rows[j][i]) + "','" + StockReports.getip() + "');  ");
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb_1.ToString());
                        }
                    }
                }
            }
			MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE document_detail SET PanelID=@Panel_ID WHERE ID=@ID",
                   new MySqlParameter("@ID", DocumentID), new MySqlParameter("@Panel_ID", panelMasterData[0].Panel_ID));

            tnx.Commit();
            cmd1.Dispose();
            panelMasterData.Clear();
            return JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return JsonConvert.SerializeObject(new { status = false, response = "Error Occurred" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public string SaveLogin(MySqlTransaction MySqltrans, string EmployeeID, string Username, string Pwd, string ConfirmPwd, string Centre, string Role, string Login, int defaultCentreID, int defaultRoleID)
    {
        int sts = 0;
        int rslt = 0;
        int centreID;
        int roleID;

        int isTPwd = 0;
        string TranPwd = string.Empty;

        

        MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, "DELETE FROM f_login WHERE EmployeeID=@EmployeeID", new MySqlParameter("@EmployeeID", EmployeeID));

        int isDefault = 0;

        string[] cid = Centre.Split(',');
        string[] rid = Role.Split(',');
        int lenCentreID = Util.GetInt(cid.Length);
        int lenRoleID = Util.GetInt(rid.Length);

        for (int i = 0; i < lenCentreID; i++)
        {
            centreID = Convert.ToInt32(cid[i]);
            for (int j = 0; j < lenRoleID; j++)
            {
                roleID = Convert.ToInt32(rid[j]);
                if (centreID == defaultCentreID && roleID == defaultRoleID)
                    isDefault = 1;
                else
                    isDefault = 0;
                string str1 = "insert into f_login(RoleID,EmployeeID,Username,Password,CentreId,IsTPassword,TPassword,lastpass_dt,isDefault,CreatedByID,CreatedBy,Createdon)" +
                            "values(@roleID,@EmployeeID,@Username,@Pwd,@centreID,@isTPwd,@TranPwd,now(),@isDefault,@CreatedByID,@CreatedBy,NOW())";
                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, str1, new MySqlParameter("@roleID", roleID),
                    new MySqlParameter("@EmployeeID", EmployeeID), new MySqlParameter("@Username", Username),
                    new MySqlParameter("@Pwd", Pwd), new MySqlParameter("@centreID", centreID),
                    new MySqlParameter("@isTPwd", isTPwd), new MySqlParameter("@TranPwd", TranPwd),
                    new MySqlParameter("@isDefault", isDefault),
                    new MySqlParameter("@CreatedByID", UserInfo.ID),
                    new MySqlParameter("@CreatedBy", UserInfo.LoginName));
            }
            sts = 1;
        }
        if (sts == 1)
        {
            rslt = 1;
            return JsonConvert.SerializeObject("Record Saved");
        }
        return JsonConvert.SerializeObject("Not Saved");
    }
}
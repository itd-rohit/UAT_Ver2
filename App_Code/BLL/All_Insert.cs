using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Text;
using Newtonsoft.Json;
/// <summary>
/// Summary description for All_Insert
/// </summary>
public class All_Insert
{
    public All_Insert()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public string saveCentre(object Centre, object Panel)
    {
        List<CenterMaster> centreMasterData = new JavaScriptSerializer().ConvertToType<List<CenterMaster>>(Centre);
        List<PanelMaster> panelMasterData = new JavaScriptSerializer().ConvertToType<List<PanelMaster>>(Panel);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT COUNT(*)centreCount,IFNULL(ce.MaxLimit,0)MaxLimit FROM centreConfiguration ce LEFT JOIN centre_master cm  ON ce.Category=cm.Category WHERE ce.category=@category",
                new MySqlParameter("@category", centreMasterData[0].Category)).Tables[0])
            {
                if (Util.GetInt(dt.Rows[0]["centreCount"].ToString()) > Util.GetInt(dt.Rows[0]["MaxLimit"].ToString()) || Util.GetInt(dt.Rows[0]["MaxLimit"].ToString()) == 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Max Limit for Creating Centre Type Exceed", focusControl = "ddlCentreType" });
                }
            }
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT COUNT(1) FROM centre_master WHERE Centre = @Centre",
               new MySqlParameter("@Centre", centreMasterData[0].Centre)));
            if (count > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Centre Name Already Exist", focusControl = "txtCentreName" });
            }
            int IsDuplicateCentreUHID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM centre_master WHERE UCASE(UHIDCode)=@UHIDCode ",
               new MySqlParameter("@UHIDCode", centreMasterData[0].UHIDCode.ToUpper())));
            if (IsDuplicateCentreUHID > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "UHID Abbreviation Code Already Exist", focusControl = "txtUHIDCode" });
            }
            int IsDuplicateCentreCode = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM centre_master WHERE UCASE(CentreCode)=@CentreCode ",
                new MySqlParameter("@CentreCode", centreMasterData[0].CentreCode.ToUpper())));
            if (IsDuplicateCentreCode > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Centre Code Already Exist", focusControl = "txtCentreCode" });
            }
            int IsDuplicatePUPCode = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM f_panel_master WHERE UCASE(Panel_Code)=@Panel_Code ",
               new MySqlParameter("@Panel_Code", centreMasterData[0].CentreCode.ToUpper())));
            if (IsDuplicatePUPCode > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Centre Code Already Exist", focusControl = "txtCentreCode" });
            }
            CenterMaster objCenter = new CenterMaster(tnx)
            {
                type1 = centreMasterData[0].type1,
                type1ID = centreMasterData[0].type1ID,
                Centre = centreMasterData[0].Centre.ToUpper(),
                CentreCode = centreMasterData[0].CentreCode.ToUpper(),
                UHIDCode = centreMasterData[0].UHIDCode.ToUpper(),
                isActive = centreMasterData[0].isActive,
                Address = centreMasterData[0].Address,
                Locality = centreMasterData[0].Locality,
                City = centreMasterData[0].City,
                State = centreMasterData[0].State,
                Landline = centreMasterData[0].Landline,
                Mobile = centreMasterData[0].Mobile,
                Email = centreMasterData[0].Email,
                contactperson = centreMasterData[0].contactperson,
                contactpersonmobile = centreMasterData[0].contactpersonmobile,
                contactpersonemail = centreMasterData[0].contactpersonemail,
                contactpersondesignation = centreMasterData[0].contactpersondesignation,
                zone = centreMasterData[0].zone,
                ZoneID = centreMasterData[0].ZoneID,
                businessunit = centreMasterData[0].businessunit,
                BusinessUnitID = centreMasterData[0].BusinessUnitID,
                subbusinessunit = centreMasterData[0].subbusinessunit,
                SubBusinessUnitID = centreMasterData[0].SubBusinessUnitID,
                unithead = centreMasterData[0].unithead,
                UnitHeadID = centreMasterData[0].UnitHeadID,
                OnLineUserName = centreMasterData[0].OnLineUserName,
                OnlinePassword = centreMasterData[0].OnlinePassword,
                SavingType = centreMasterData[0].SavingType,
                StateID = centreMasterData[0].StateID,
                CityID = centreMasterData[0].CityID,
                LocalityID = centreMasterData[0].LocalityID,
                BusinessZoneID = centreMasterData[0].BusinessZoneID,
                BusinessZoneName = centreMasterData[0].BusinessZoneName,
                SalesHierarchyID = centreMasterData[0].SalesHierarchyID,
                SalesHierarchyName = centreMasterData[0].SalesHierarchyName,
                IndentType = centreMasterData[0].IndentType,
                Category = centreMasterData[0].Category,
                CountryID = centreMasterData[0].CountryID,
                CountryName = centreMasterData[0].CountryName
            };
            if (centreMasterData[0].TagProcessingLab.ToUpper() != "SELF")
            {
                objCenter.TagProcessingLab = centreMasterData[0].TagProcessingLab;
                objCenter.TagProcessingLabID = centreMasterData[0].TagProcessingLabID;
            }
            if (panelMasterData[0].ReferenceCodeOPD != "0")
            {
                objCenter.ReferalRate = centreMasterData[0].ReferalRate;
            }
            int CentreID = objCenter.Insert();
            if (CentreID == 0)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Error Occurred" });
            }
            if (centreMasterData[0].TagProcessingLab.ToUpper() == "SELF")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE centre_master SET TagProcessingLab=@TagProcessingLab,TagProcessingLabID=@TagProcessingLabID WHERE CentreID=@CentreID",
                   new MySqlParameter("@TagProcessingLab", centreMasterData[0].Centre),
                   new MySqlParameter("@TagProcessingLabID", CentreID),
                   new MySqlParameter("@CentreID", CentreID));
            }
            StringBuilder sb = new StringBuilder();
            if (CentreID != 0)
            {
                Dictionary<string, int> HLMType = new Dictionary<string, int>();
                HLMType.Add("IsHLMOP", Util.GetInt(panelMasterData[0].IsHLMOP));
                if (Util.GetInt(panelMasterData[0].IsHLMIP) == 1)
                    HLMType.Add("IsHLMIP", Util.GetInt(panelMasterData[0].IsHLMIP));
                if (Util.GetInt(panelMasterData[0].IsHLMICU) == 1)
                    HLMType.Add("IsHLMICU", Util.GetInt(panelMasterData[0].IsHLMICU));

                foreach (KeyValuePair<string, int> HLM in HLMType)
                {
                    PanelMaster objPanel = new PanelMaster(tnx)
                    {
                        CentreID = CentreID,
                        Add1 = centreMasterData[0].Address,
                        PanelGroup = panelMasterData[0].PanelGroup,
                        PanelGroupID = panelMasterData[0].PanelGroupID,
                        IsActive = Util.GetInt(centreMasterData[0].isActive),
                        Mobile = centreMasterData[0].Mobile,
                        Contact_Person = centreMasterData[0].contactperson,
                        EmailID = panelMasterData[0].EmailID,
                        EmailIDReport = panelMasterData[0].EmailIDReport,
                        ReportDispatchMode = panelMasterData[0].ReportDispatchMode,
                        MinBusinessCommitment = panelMasterData[0].MinBusinessCommitment,
                        GSTTin = panelMasterData[0].GSTTin,
                        BankName = panelMasterData[0].BankName,
                        BankID = panelMasterData[0].BankID,
                        AccountNo = panelMasterData[0].AccountNo,
                        IFSCCode = panelMasterData[0].IFSCCode,
                        InvoiceBillingCycle = panelMasterData[0].InvoiceBillingCycle,
                        PanelUserID = panelMasterData[0].PanelUserID,
                        PanelPassword = panelMasterData[0].PanelPassword,
                        PrintAtCentre = panelMasterData[0].PrintAtCentre,
                        InvoiceTo = panelMasterData[0].InvoiceTo,
                        MinBalReceive = panelMasterData[0].MinBalReceive,
                        CreditLimit = panelMasterData[0].CreditLimit,
                        ShowAmtInBooking = panelMasterData[0].ShowAmtInBooking,
                        ReportInterpretation = panelMasterData[0].ReportInterpretation,
                        HideDiscount = panelMasterData[0].HideDiscount,
                        SecurityDeposit = panelMasterData[0].SecurityDeposit,
                        SavingType = panelMasterData[0].SavingType,
                        Panel_Code = objCenter.CentreCode.ToUpper(),
                        HideReceiptRate = panelMasterData[0].HideReceiptRate,
                        InvoiceDisplayName = panelMasterData[0].InvoiceDisplayName,
                        InvoiceDisplayNo = panelMasterData[0].InvoiceDisplayNo,
                        IsPrintingLock = panelMasterData[0].IsPrintingLock,
                        IsBookingLock = panelMasterData[0].IsBookingLock,
                        AAALogo = panelMasterData[0].AAALogo,
                        DiscPercent = panelMasterData[0].DiscPercent,
                        Fullpaidpanelid = "0",
                        SharePercentage = 0,
                        SalesManager = panelMasterData[0].SalesManager,
                        SalesManagerName = panelMasterData[0].SalesManagerName,
                        ReferringMrpID = panelMasterData[0].ReferringMrpID,
                        LabReportLimit = panelMasterData[0].LabReportLimit,
                        IntimationLimit = panelMasterData[0].IntimationLimit,
                        IsShowIntimation = panelMasterData[0].IsShowIntimation,
                        TagBusinessLabID = panelMasterData[0].TagBusinessLabID,
                        TagBusinessLab = panelMasterData[0].TagBusinessLab,
                        IsLogisticExpense = panelMasterData[0].IsLogisticExpense,
                        RollingAdvance = panelMasterData[0].RollingAdvance,
                        OwnerName = panelMasterData[0].OwnerName.Trim(),
                        HideRate = panelMasterData[0].HideRate,
                        CentreType1 = centreMasterData[0].type1,
                        CentreType1ID = centreMasterData[0].type1ID,
                        IsOtherLabReferenceNo = panelMasterData[0].IsOtherLabReferenceNo,
                        chkExpectedPayment = panelMasterData[0].chkExpectedPayment,
                        ExpectedPaymentDate = panelMasterData[0].ExpectedPaymentDate,
                        IsBatchCreate = panelMasterData[0].IsBatchCreate,
                        BarCodePrintedType = panelMasterData[0].BarCodePrintedType,
                        SampleCollectionOnReg = panelMasterData[0].SampleCollectionOnReg,
                        BarCodePrintedCentreType = panelMasterData[0].BarCodePrintedCentreType,
                        BarCodePrintedHomeColectionType = panelMasterData[0].BarCodePrintedHomeColectionType,
                        SetOfBarCode = panelMasterData[0].SetOfBarCode,
                        ShowCollectionCharge = panelMasterData[0].ShowCollectionCharge,
                        CollectionCharge = panelMasterData[0].CollectionCharge,
                        ShowDeliveryCharge = panelMasterData[0].ShowDeliveryCharge,
                        DeliveryCharge = panelMasterData[0].DeliveryCharge,
                        CoPaymentApplicable = panelMasterData[0].CoPaymentApplicable,
                        CoPaymentEditonBooking = panelMasterData[0].CoPaymentEditonBooking,
                        ReceiptType = panelMasterData[0].ReceiptType,
                        SampleRecollectAfterReject = panelMasterData[0].SampleRecollectAfterReject,
                        IsAllowDoctorShare=panelMasterData[0].IsAllowDoctorShare,
                        MrpBill = panelMasterData[0].MrpBill
                    };
                    if (HLM.Key == "IsHLMOP" && HLM.Value == 1)
                    {
                        objPanel.Company_Name = centreMasterData[0].Centre.ToUpper();
                        objPanel.PanelType = "Centre";
                        objPanel.Payment_Mode = panelMasterData[0].HLMOPPaymentMode;
                        objPanel.PatientPayTo = panelMasterData[0].HLMOPPatientPayTo;
                    }
                    else if (HLM.Key == "IsHLMIP" && HLM.Value == 1)
                    {
                        objPanel.Company_Name = string.Concat(centreMasterData[0].Centre.ToUpper(), " IP");
                        objPanel.PanelType = "RateType";
                        objPanel.Payment_Mode = panelMasterData[0].HLMIPPaymentMode;
                        objPanel.PatientPayTo = panelMasterData[0].HLMIPPatientPayTo;
                    }
                    else if (HLM.Key == "IsHLMICU" && HLM.Value == 1)
                    {
                        objPanel.Company_Name = string.Concat(centreMasterData[0].Centre.ToUpper(), " ICU");
                        objPanel.PanelType = "RateType";
                        objPanel.Payment_Mode = panelMasterData[0].HLMICUPaymentMode;
                        objPanel.PatientPayTo = panelMasterData[0].HLMICUPatientPayTo;
                    }

                    if (centreMasterData[0].type1.ToUpper() != "HLM")
                    {
                        objPanel.Payment_Mode = panelMasterData[0].Payment_Mode;
                        objPanel.PatientPayTo = panelMasterData[0].PatientPayTo;
                    }
                    if (panelMasterData[0].TagProcessingLab.ToUpper() != "SELF")
                    {
                        objPanel.TagProcessingLab = panelMasterData[0].TagProcessingLab;
                        objPanel.TagProcessingLabID = panelMasterData[0].TagProcessingLabID;
                    }

                    if (panelMasterData[0].ReferenceCodeOPD != "0")
                    {
                        objPanel.ReferenceCode = panelMasterData[0].ReferenceCode;
                        objPanel.ReferenceCodeOPD = panelMasterData[0].ReferenceCodeOPD;
                    }
                    else
                    {
                        objPanel.ReferenceCode = "0";
                        objPanel.ReferenceCodeOPD = "0";
                    }

                    if (panelMasterData[0].SavingType.Trim() == "FOCO")
                    {
                        objPanel.IsInvoice = 1;
                        // objPanel.showBalanceAmt = panelMasterData[0].showBalanceAmt;
                        objPanel.LedgerReportPassword = panelMasterData[0].LedgerReportPassword;
                        objPanel.InvoiceDisplayAddress = panelMasterData[0].InvoiceDisplayAddress;
                    }
                    else
                    {
                        // objPanel.showBalanceAmt = 0;
                        objPanel.IsInvoice = 0;
                    }
                    if (panelMasterData[0].IsShowIntimation == 1 || panelMasterData[0].IsBookingLock == 1 || panelMasterData[0].IsPrintingLock == 1)
                        objPanel.showBalanceAmt = 1;
                    else if (panelMasterData[0].SavingType.Trim() == "FOCO")
                        objPanel.showBalanceAmt = panelMasterData[0].showBalanceAmt;
                    else
                        objPanel.showBalanceAmt = 0;

                    if (centreMasterData[0].type1 == "CC")
                        objPanel.ReferringShareID = panelMasterData[0].ReferringShareID;
                    else
                        objPanel.ReferringShareID = 0;

                    if (objPanel.IsLogisticExpense == 1)
                    {
                        objPanel.LogisticExpenseRateType = panelMasterData[0].LogisticExpenseRateType;
                        objPanel.LogisticExpenseToPanelID = panelMasterData[0].LogisticExpenseToPanelID;
                    }
                    else
                    {
                        objPanel.LogisticExpenseRateType = 0;
                        objPanel.LogisticExpenseToPanelID = 0;
                    }
                    objPanel.MonthlyInvoiceType = panelMasterData[0].MonthlyInvoiceType;
                    objPanel.InvoiceCreatedOn = panelMasterData[0].InvoiceCreatedOn;
                    objPanel.CountryID = panelMasterData[0].CountryID;
                    objPanel.CountryName = panelMasterData[0].CountryName;
                    objPanel.PanNo = panelMasterData[0].PanNo;
                    objPanel.PANCardName = panelMasterData[0].PANCardName;
                    objPanel.SecurityAmtComments = panelMasterData[0].SecurityAmtComments;
                    objPanel.CreationDate = panelMasterData[0].CreationDate;
                    objPanel.ReceiptType = panelMasterData[0].ReceiptType;
                    string PanelId = objPanel.Insert();
                    if (PanelId == string.Empty)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "Error Occurred" });
                    }
                    if (objPanel.TagBusinessLabID == 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET TagBusinessLabID=@TagBusinessLabID,TagBusinessLab=@TagBusinessLab WHERE Panel_ID=@Panel_ID",
                             new MySqlParameter("@TagBusinessLabID", CentreID), new MySqlParameter("@TagBusinessLab", centreMasterData[0].Centre.ToUpper()), new MySqlParameter("@Panel_ID", PanelId));
                    }
                    if (objPanel.IsLogisticExpense == 1 && panelMasterData[0].LogisticExpenseRateType == -1)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET LogisticExpenseRateType=@LogisticExpenseRateType WHERE Panel_ID=@Panel_ID",
                             new MySqlParameter("@LogisticExpenseRateType", PanelId), new MySqlParameter("@Panel_ID", PanelId));
                    }
                    if (objPanel.IsLogisticExpense == 1 && panelMasterData[0].LogisticExpenseToPanelID == -1)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET LogisticExpenseToPanelID=@LogisticExpenseToPanelID WHERE Panel_ID=@Panel_ID",
                             new MySqlParameter("@LogisticExpenseToPanelID", PanelId),
                             new MySqlParameter("@Panel_ID", PanelId));
                    }
                    if (panelMasterData[0].ReferenceCodeOPD == "0")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET ReferenceCode=@ReferenceCode, ReferenceCodeOPD=@ReferenceCodeOPD WHERE Panel_ID=@Panel_ID",
                            new MySqlParameter("@ReferenceCode", PanelId),
                            new MySqlParameter("@ReferenceCodeOPD", PanelId),
                            new MySqlParameter("@Panel_ID", PanelId));

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE centre_master SET ReferalRate=@ReferalRate WHERE CentreID=@CentreID",
                            new MySqlParameter("@ReferalRate", PanelId),
                            new MySqlParameter("@CentreID", CentreID));
                    }
                    if (panelMasterData[0].InvoiceTo == "0")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET InvoiceTo=@InvoiceTo WHERE Panel_ID=@Panel_ID",
                            new MySqlParameter("@InvoiceTo", PanelId),
                            new MySqlParameter("@Panel_ID", PanelId));
                    }
                    if (panelMasterData[0].TagProcessingLab.ToUpper() == "SELF")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET TagProcessingLab=@TagProcessingLab,TagProcessingLabID=@TagProcessingLabID WHERE CentreID=@CentreID",
                             new MySqlParameter("@TagProcessingLab", centreMasterData[0].Centre),
                             new MySqlParameter("@TagProcessingLabID", CentreID),
                             new MySqlParameter("@CentreID", CentreID));
                    }
                    if (panelMasterData[0].ReferringMrpID == 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET PanelID_MRP=@ReferringMrpID WHERE Panel_ID=@Panel_ID",
                           new MySqlParameter("@ReferringMrpID", PanelId), new MySqlParameter("@Panel_ID", PanelId));
                    }
                    if (panelMasterData[0].ReferringShareID == 0 && centreMasterData[0].type1 == "CC")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET PanelShareID=@ReferringShareID WHERE Panel_ID=@Panel_ID",
                           new MySqlParameter("@ReferringShareID", PanelId), new MySqlParameter("@Panel_ID", PanelId));
                    }
                    if (panelMasterData[0].EnrollID.Trim() != string.Empty)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sales_enrolment_master SET ISEnroll=1,Panel_ID=@Panel_ID,EnrollByID=@EnrollByID,EnrollBy=@EnrollBy,EnrollDate=NOW() WHERE ID=@EnrollID ",
                            new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()), new MySqlParameter("@Panel_ID", PanelId),
                            new MySqlParameter("@EnrollBy", UserInfo.LoginName), new MySqlParameter("@EnrollByID", UserInfo.ID));
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET EnrollID=@EnrollID WHERE Panel_ID=@Panel_ID ",
                             new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()), new MySqlParameter("@Panel_ID", PanelId));
                    }
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO centre_panel(CentreID,PanelID,UserID)VALUES(@CentreID,@PanelId,@UserID)",
                        new MySqlParameter("@CentreID", CentreID), new MySqlParameter("@PanelId", PanelId), new MySqlParameter("@UserID", UserInfo.ID));
                    if (panelMasterData[0].EnrollID.Trim() != string.Empty && (centreMasterData[0].type1.ToUpper() == "PCC"))
                    {
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO f_ratelist_schedule(Panel_ID,ItemID,FromDate,ToDate,Rate,CreatedBy,CreatedByID,PCCSharePer,CreatedDate) ");
                        sb.Append(" SELECT @PanelId,ItemID,FromDate,ToDate,OfferMRP,@CreatedBy,@CreatedByID,PCCSharePer,NOW() FROM sales_MarketingTest_enrolment ");
                        sb.Append(" WHERE EnrollID=@EnrollID AND IsActive=1  ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PanelId", PanelId), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                            new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()));
                    }

                    if (panelMasterData[0].EnrollID.Trim() != string.Empty && (centreMasterData[0].type1.ToUpper() == "PCC" || centreMasterData[0].type1.ToUpper() == "PCL"))
                    {
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO f_panel_master_specialtest(ItemID,Panel_ID,CentrePanelID,Rate,RateBasic,IsVerified,CreatedByID,CreatedDate,IsActive,CreatedBy,EntryType) ");
                        sb.Append(" SELECT se.SpecialTestID,@PanelId,@PanelId, se.SpecialTestRate,se.SpecialTestRate,1,@CreatedByID,NOW(),1,@CreatedBy,EntryType ");
                        sb.Append(" FROM  sales_specialtest_enrolment se WHERE se.EnrollID=@EnrollID  ");
                        sb.Append(" AND se.SpecialTestRate<>0 AND se.IsActive=1 AND se.IsPCCGroup=0  ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PanelId", PanelId), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                            new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()));

                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO f_panel_share_items(Panel_ID,CentrePanelID,ItemID,SharePer,ShareAmt,IsActive,CreatedByID,CreatedBy,EntryType,CreatedDate,PCCGroupID) ");
                        sb.Append(" SELECT @PanelId,@PanelId,se.SpecialTestID , pe.PCCGroupSharePer,0,1,@CreatedByID,@CreatedBy,se.EntryType,NOW(),se.PCCGroupID   ");
                        sb.Append(" FROM sales_specialtest_enrolment se  INNER JOIN sales_PCCGrouping_Enrolment pe ON se.PCCGroupID=pe.GroupID AND se.EnrollID=pe.EnrollID AND pe.IsActive=1 ");
                        sb.Append(" WHERE se.EnrollID=@EnrollID  AND se.IsActive=1 AND se.IsPCCGroup=1 ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PanelId", PanelId), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                            new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()));

                        if (centreMasterData[0].type1.ToUpper() == "PCC")
                        {
                            sb = new StringBuilder();
                            sb.Append("  INSERT INTO f_panel_share_items(Panel_ID,CentrePanelID,ItemID,SharePer,ShareAmt,IsActive,CreatedByID,CreatedBy,EntryType,CreatedDate,PCCGroupID) ");
                            sb.Append(" SELECT @PanelId,@PanelId,itm.ItemID , @SharePer,0,1,@CreatedByID,@CreatedBy,@EntryType,NOW(),PCCGroupID   ");
                            sb.Append(" FROM  f_itemmaster itm ");
                            sb.Append(" LEFT JOIN sales_specialtest_enrolment se ON itm.itemid=se.SpecialTestID AND se.EnrollID=@EnrollID  ");
                            sb.Append("   AND se.IsActive=1    ");
                            sb.Append(" WHERE se.ID IS NULL ");
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@PanelId", PanelId), new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID),
                                 new MySqlParameter("@EntryType", centreMasterData[0].type1.ToUpper()), new MySqlParameter("@SharePer", (Util.GetDecimal(panelMasterData[0].DiscPercent))),
                                 new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()));
                        }
                        else if (centreMasterData[0].type1.ToUpper() == "PCL")
                        {
                            decimal PCLSharePercentage = 40;
                            sb = new StringBuilder();
                            sb.Append("  INSERT INTO f_panel_share_items(Panel_ID,CentrePanelID,ItemID,SharePer,ShareAmt,IsActive,CreatedByID,CreatedBy,EntryType,CreatedDate,PCCGroupID) ");
                            sb.Append(" SELECT @PanelId,@PanelId,itm.ItemID , @SharePer,0,1,@CreatedByID,@CreatedBy,@EntryType,NOW(),PCCGroupID   ");
                            sb.Append(" FROM  f_itemmaster itm ");
                            sb.Append(" LEFT JOIN sales_specialtest_enrolment se ON itm.itemid=se.SpecialTestID AND se.EnrollID=@EnrollID  ");
                            sb.Append("   AND se.IsActive=1    ");
                            sb.Append(" WHERE se.ID IS NULL ");
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@PanelId", PanelId), new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID),
                                new MySqlParameter("@EntryType", centreMasterData[0].type1.ToUpper()), new MySqlParameter("@SharePer", (Util.GetDecimal(PCLSharePercentage))),
                                new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()));
                        }
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO Employee_master_Sales(Employee_ID,DesignationID,Panel_ID,CreatedBy,CreatedByID,EnrollID) ");
                        sb.Append(" SELECT se.EmployeeID,se.DesignationID,@PanelId,@CreatedBy,@CreatedByID,@EnrollID   ");
                        sb.Append(" FROM  sales_employee_centre se WHERE se.EnrollID=@EnrollID  ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()), new MySqlParameter("@PanelId", PanelId),
                            new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID));
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO sales_admin_verification(EnrollID,VerifiedBy,VerifiedByID,VerificationType)VALUES(@EnrollID,@VerifiedBy,@VerifiedByID,@VerificationType)",
                            new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()), new MySqlParameter("@VerifiedByID", UserInfo.ID), new MySqlParameter("@VerifiedBy", UserInfo.LoginName),
                            new MySqlParameter("@VerificationType", "IT"));

                    }
                    else if (panelMasterData[0].EnrollID.Trim() != string.Empty && (centreMasterData[0].type1.ToUpper() == "HLM"))
                    {
                        int HLMHikeMRP = 0; int HLMClientShare = 0;
                        if (HLM.Key == "IsHLMOP" && HLM.Value == 1)
                        {
                            HLMHikeMRP = Util.GetInt(panelMasterData[0].HLMOPHikeInMRP);
                            HLMClientShare = Util.GetInt(panelMasterData[0].HLMOPClientShare);
                        }
                        else if (HLM.Key == "IsHLMIP" && HLM.Value == 1)
                        {
                            HLMHikeMRP = Util.GetInt(panelMasterData[0].HLMIPHikeInMRP);
                            HLMClientShare = Util.GetInt(panelMasterData[0].HLMIPClientShare);
                        }
                        else if (HLM.Key == "IsHLMICU" && HLM.Value == 1)
                        {
                            HLMHikeMRP = Util.GetInt(panelMasterData[0].HLMICUHikeInMRP);
                            HLMClientShare = Util.GetInt(panelMasterData[0].HLMICUClientShare);
                        }


                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO f_ratelist(Rate,ERate,ItemID,IsService,Panel_ID,SpecialFlag,IsCurrent,FromDate) ");
                        sb.Append(" SELECT round(rat.Rate+ ((rat.Rate*@HLMHikeMRP)/100))Rate,round(rat.Rate+ ((rat.Rate*@HLMHikeMRP)/100))ERate,rat.ItemID,1,@PanelId,0,1,CURRENT_DATE()  FROM  f_ratelist rat");
                        sb.Append("  INNER JOIN f_panel_master pm ON pm.Panel_ID=rat.Panel_ID  ");
                        sb.Append("  AND rat.Panel_ID=( SELECT ReferenceCode FROM f_panel_master WHERE CentreID=@TagProcessingLabID AND IsActive=1 AND PanelType='Centre'  LIMIT 1 )  ");
                        sb.Append(" LEFT JOIN sales_specialtest_enrolment se ON rat.itemid=se.SpecialTestID AND se.EnrollID=@EnrollID  ");
                        sb.Append(" AND se.SpecialTestRate<>0 AND se.IsActive=1 AND  HLMPrice='Gross' ");
                        sb.Append(" WHERE se.ID IS NULL ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PanelId", PanelId),
                            new MySqlParameter("@TagProcessingLabID", panelMasterData[0].TagProcessingLabID),
                            new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()),
                            new MySqlParameter("@HLMHikeMRP", Util.GetDecimal(HLMHikeMRP)));


                        sb = new StringBuilder();
                        sb.Append("  INSERT INTO f_panel_share_items(Panel_ID,CentrePanelID,ItemID,SharePer,ShareAmt,IsActive,CreatedByID,CreatedBy,EntryType)  ");
                        sb.Append(" SELECT @PanelId,@PanelId,itm.ItemID,@SharePer,0,1,@CreatedByID,@CreatedBy,'HLM' ");
                        sb.Append(" FROM f_Itemmaster itm ");
                        sb.Append(" LEFT JOIN sales_specialtest_enrolment se ON itm.itemid=se.SpecialTestID AND se.EnrollID=@EnrollID  ");
                        sb.Append(" AND se.SpecialTestRate<>0 AND se.IsActive=1 AND  HLMPrice='Net' ");
                        sb.Append(" WHERE se.ID IS NULL ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PanelId", PanelId), new MySqlParameter("@SharePer", HLMClientShare),
                            new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                            new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()));


                        //For Special test Net
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO f_panel_share_items(Panel_ID,CentrePanelID,ItemID,SharePer,ShareAmt,IsActive,CreatedByID,CreatedBy,EntryType) ");
                        sb.Append(" SELECT @PanelId,@PanelId,se.SpecialTestID,0,se.SpecialTestRate,1,@CreatedByID,@CreatedBy,'HLM'  ");
                        sb.Append(" FROM  sales_specialtest_enrolment se   ");
                        sb.Append(" WHERE se.EnrollID=@EnrollID AND se.SpecialTestRate<>0 AND se.IsActive=1 AND se.HLMPrice='Net' ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PanelId", PanelId), new MySqlParameter("@CreatedByID", UserInfo.ID),
                            new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()));

                        //For Special test Gross 
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO f_ratelist(Rate,ERate,ItemID,IsService,Panel_ID,SpecialFlag,IsCurrent,FromDate) ");
                        sb.Append(" SELECT se.SpecialTestRate,se.SpecialTestRate,se.SpecialTestID,1,@PanelId,1,1,CURRENT_DATE() ");
                        sb.Append(" FROM  sales_specialtest_enrolment se ");
                        sb.Append("  WHERE se.EnrollID=@EnrollID AND se.SpecialTestRate<>0 AND se.IsActive=1 AND  HLMPrice='Gross' ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@PanelId", PanelId),
                           new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()));


                        //07.11.17

                        string PackageItemID = string.Empty; List<string> AllPackageItemID = new List<string>();
                        using (DataTable PackageData = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT PackageName,ItemID,PatientRate,ShareType,NetAmount FROM sales_hlmpackage_enrolment WHERE EnrollID=@EnrollID AND IsActive=1",
                             new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim())).Tables[0])
                        {
                            if (PackageData.Rows.Count > 0)
                            {
                                if (HLM.Key == "IsHLMOP" && HLM.Value == 1)
                                {
                                    int SubcategoryID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT SubCategoryID FROM f_subcategorymaster  WHERE CategoryID = 'LSHHI44' "));

                                    for (int i = 0; i < PackageData.Rows.Count; i++)
                                    {
                                        sb = new StringBuilder();
                                        PackageLab_Master objPLM = new PackageLab_Master(tnx)
                                        {
                                            Name = PackageData.Rows[i]["PackageName"].ToString().Trim(),
                                            Description = PackageData.Rows[i]["PackageName"].ToString().Trim(),
                                            Creator_Date = DateTime.Now,
                                            IsActive = 1,
                                            CreaterID = Util.GetString(HttpContext.Current.Session["ID"])
                                        };
                                        string PackageID = objPLM.Insert();
                                        ItemMaster objIMaster = new ItemMaster(tnx)
                                          {
                                              TypeName = PackageData.Rows[i]["PackageName"].ToString().Trim(),
                                              Type_ID = Util.GetInt(PackageID),
                                              Inv_ShortName = PackageData.Rows[i]["PackageName"].ToString().Trim(),
                                              SubCategoryID = SubcategoryID,
                                              IsTrigger = "0",
                                              IsActive = 1,
                                              TestCode = string.Empty
                                          };
                                        PackageItemID = objIMaster.Insert();

                                        AllPackageItemID.Add(PackageItemID);

                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update f_itemmaster set BaseRate=0,FromAge='0',ToAge='70000',Gender='B',TestCode=@TestCode where ItemID=@ItemID",
                                           new MySqlParameter("@TestCode", PackageItemID), new MySqlParameter("@ItemID", PackageItemID));

                                        string MaxPriority = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT MAX(priority+1) FROM packagelab_master "));

                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update packagelab_master set ShowInReport='1',priority=@priority where PLabID=@PLabID ",
                                           new MySqlParameter("@priority", MaxPriority), new MySqlParameter("@PLabID", PackageID));
                                        string LastInvPriority = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT IFNULL(MAX(priority+1),'0') FROM package_labdetail  WHERE PlabID=@PlabID",
                                           new MySqlParameter("@PlabID", PackageID)));
                                        int Priority = 0;
                                        if (LastInvPriority.Trim() == "0")
                                        {
                                            Priority = 1;
                                        }
                                        else
                                        {
                                            Priority = Util.GetInt(LastInvPriority.Trim());
                                        }
                                        int len = Util.GetInt(PackageData.Rows[i]["ItemID"].ToString().Split(',').Length);
                                        string[] Data = new string[len];
                                        Data = PackageData.Rows[i]["ItemID"].ToString().Split(',');
                                        for (int j = 0; j < len; j++)
                                        {
                                            sb = new StringBuilder();
                                            sb.Append("INSERT INTO package_labdetail(PLabID,InvestigationID,UserID,DateModified,Priority) ");
                                            sb.Append(" VALUES(@PackageID,@InvestigationID,@UserID,NOW(),@Priority)");
                                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                new MySqlParameter("@PackageID", PackageID), new MySqlParameter("@InvestigationID", Data[j].Split(',')[0]),
                                                new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@Priority", Priority));
                                        }
                                    }
                                }
                            }
                            if (AllPackageItemID.Count > 0)
                            {
                                for (int i = 0; i < PackageData.Rows.Count; i++)
                                {
                                    if (PackageData.Rows[i]["ShareType"].ToString() == "Net")
                                    {
                                        sb = new StringBuilder();
                                        sb.Append(" INSERT INTO f_panel_share_items(Panel_ID,CentrePanelID,ItemID,SharePer,ShareAmt,IsActive,CreatedByID,CreatedBy,EntryType) ");
                                        sb.Append(" SELECT @Panel_ID,@Panel_ID,@ItemID,0,se.NetAmount,1,@CreatedByID,@CreatedBy,'HLM'  ");
                                        sb.Append(" FROM  sales_hlmpackage_enrolment se   ");
                                        sb.Append(" WHERE se.EnrollID=@EnrollID AND se.NetAmount<>0 AND se.IsActive=1 AND se.ShareType='Net' ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@Panel_ID", PanelId), new MySqlParameter("@ItemID", AllPackageItemID[i]),
                                            new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                                            new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()));
                                    }
                                    else
                                    {
                                        sb = new StringBuilder();
                                        sb.Append(" INSERT INTO f_panel_share_items(Panel_ID,CentrePanelID,ItemID,SharePer,ShareAmt,IsActive,CreatedByID,CreatedBy,EntryType) ");
                                        sb.Append(" SELECT @Panel_ID,@Panel_ID,@ItemID',@SharePer,0,1,@CreatedByID,@CreatedBy,'HLM'  ");
                                        sb.Append(" FROM  sales_hlmpackage_enrolment se   ");
                                        sb.Append(" WHERE se.EnrollID=@EnrollID AND se.NetAmount<>0 AND se.IsActive=1 AND se.ShareType='Gross' ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                           new MySqlParameter("@Panel_ID", PanelId), new MySqlParameter("@ItemID", AllPackageItemID[i]),
                                           new MySqlParameter("@SharePer", HLMClientShare), new MySqlParameter("@CreatedByID", UserInfo.ID),
                                           new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()));
                                    }
                                    RateList objRateList = new RateList(tnx)
                                    {
                                        Panel_ID = Util.GetInt(PanelId),
                                        ItemID = Util.GetInt(AllPackageItemID[i]),
                                        Rate = Util.GetDecimal(PackageData.Rows[i]["PatientRate"].ToString()),
                                        IsTaxable = 0,
                                        FromDate = DateTime.Now,
                                        ToDate = DateTime.Now,
                                        IsCurrent = 1,
                                        IsService = "YES",
                                        ItemDisplayName = PackageData.Rows[i]["PackageName"].ToString().Trim(),
                                        ItemCode = string.Empty
                                    };
                                    if (HLM.Key == "IsHLMOP" && HLM.Value == 1)
                                        objRateList.Insert();
                                    else if (HLM.Key == "IsHLMIP" && HLM.Value == 1)
                                        objRateList.Insert();
                                    else if (HLM.Key == "IsHLMICU" && HLM.Value == 1)
                                        objRateList.Insert();
                                }
                            }

                            sb = new StringBuilder();
                            sb.Append(" INSERT INTO Employee_master_Sales(Employee_ID,DesignationID,Panel_ID,CreatedBy,CreatedByID,EnrollID) ");
                            sb.Append(" SELECT se.EmployeeID,se.DesignationID,@PanelId,@CreatedBy,@CreatedByID,@EnrollID   ");
                            sb.Append(" FROM  sales_employee_centre se WHERE se.EnrollID=@EnrollID  ");
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()), new MySqlParameter("@PanelId", PanelId),
                                new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID));

                            if (HLM.Key == "IsHLMOP" && HLM.Value == 1)
                            {
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO sales_admin_verification(EnrollID,VerifiedBy,VerifiedByID,VerificationType)VALUES(@EnrollID,@VerifiedBy,@VerifiedByID,@VerificationType)",
                                     new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()), new MySqlParameter("@VerifiedByID", UserInfo.ID), new MySqlParameter("@VerifiedBy", UserInfo.LoginName),
                                     new MySqlParameter("@VerificationType", "IT"));

                            }
                        }
                    }
                    MSTEmployee objMSTEmployee = new MSTEmployee(tnx) { Title = string.Empty, Name = centreMasterData[0].Centre.Trim(), Street_Name = centreMasterData[0].Address.Trim(), CreatedByID = Util.GetInt(UserInfo.ID), CreatedBy = UserInfo.LoginName, Designation = "Collection Center", DesignationID = 38, AllowSharing = "0", IsHideRate = 1 };
                    string EmployeeID = objMSTEmployee.Insert();
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET Employee_ID=@Employee_ID WHERE Panel_ID=@Panel_ID",
                       new MySqlParameter("@Employee_ID", EmployeeID), new MySqlParameter("@Panel_ID", PanelId));

                    if (centreMasterData[0].UserName != string.Empty && centreMasterData[0].UserPassword != string.Empty)
                    {
                        int RoleID = 0;
                        if (centreMasterData[0].type1 == "CC")
                            RoleID = 241;
                        else if (centreMasterData[0].type1 == "FC")
                            RoleID = 242;
                        else if (centreMasterData[0].type1 == "B2B")
                            RoleID = 243;
                        if (RoleID != 0)
                        {
                            if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT count(1) FROM f_login where lower(username)=@username",
                                new MySqlParameter("@username", centreMasterData[0].UserName.ToLower()))) > 0)
                                return JsonConvert.SerializeObject(new { status = false, response = "User Name Already Use.Please Entre Different User Name", focusControl = "txtClientUserName" });

                            string str1 = "INSERT INTO f_login(RoleID,EmployeeID,Username,Password,CentreId,IsTPassword,TPassword,lastpass_dt,isDefault,CreatedByID,CreatedBy,CreatedOn)" +
                                           "values(@RoleID,@EmployeeID,@UserName,@UserPassword,@CentreID,0,'',NOW(),1,@CreatedByID,@CreatedBy,NOW())";
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str1,
                                new MySqlParameter("@RoleID", RoleID), new MySqlParameter("@EmployeeID", EmployeeID), new MySqlParameter("@UserName", centreMasterData[0].UserName),
                                new MySqlParameter("@UserPassword", centreMasterData[0].UserPassword), new MySqlParameter("@CentreID", CentreID), new MySqlParameter("@CreatedByID", UserInfo.ID),
                                new MySqlParameter("@CreatedBy", UserInfo.LoginName));
                        }

                    }
                }
            }
            if (panelMasterData[0].EnrollID.Trim() != string.Empty)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO f_login(RoleID,EmployeeID,UserName,PASSWORD,Active,CentreID,CreatedByID,CreatedBy,IsTPassword,TPassword,lastpass_dt,isDefault)");
                sb.Append(" SELECT RoleID,EmployeeID,UserName,PASSWORD,1,@CentreID,@CreatedByID,@CreatedBy,IsTPassword,TPassword,lastpass_dt,isDefault ");
                sb.Append(" FROM f_login WHERE EmployeeID=@CreatedByID  AND Active=1 GROUP BY RoleID ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@CentreID", CentreID), new MySqlParameter("@CreatedByID", UserInfo.ID),
                   new MySqlParameter("@CreatedBy", UserInfo.LoginName));
                using (DataTable emailData = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT EmaiID,IFNULL(CCEmaiID,'')CCEmaiID FROM  sales_email_master em WHERE IsActive=1 AND EmailCondtion='IT' ").Tables[0])
                {
                    if (emailData.Rows.Count > 0)
                    {
                        sb = new StringBuilder();
                        sb.Append(" SELECT CAST(GROUP_CONCAT(em.Email  SEPARATOR ',')AS CHAR)Email FROM sales_Employee_centre ec ");
                        sb.Append(" INNER JOIN employee_master em ON em.Employee_ID=ec.EmployeeID ");
                        sb.Append(" WHERE ec.EnrollID=@EnrollID AND ec.SequenceNo>=7 AND IFNULL(em.Email,'')<>'' ORDER BY ec.SequenceNo");
                    }
                }
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE centre_type1master set MaxID=MaxID+1 WHERE ID=@ID",
                new MySqlParameter("@ID", centreMasterData[0].type1ID));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO Centre_master_log(CentreID,Centre_master_log,f_panel_master_log,CreatedBy,CreatedByID,LogType)VALUES(@CentreID,@Centre_master_log,@f_panel_master_log,@CreatedBy,@CreatedByID,'New') ",
                new MySqlParameter("@Centre_master_log", JsonConvert.SerializeObject(centreMasterData)), new MySqlParameter("@f_panel_master_log", JsonConvert.SerializeObject(panelMasterData)),
              new MySqlParameter("@CentreID", CentreID), new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID));
            int Centre_master_log_ID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT @@identity"));
            tnx.Commit();
            panelMasterData.Clear();
            centreMasterData.Clear();
            return JsonConvert.SerializeObject(new { status = true, CentreID = Common.Encrypt(Util.GetString(CentreID)), LogID = Common.Encrypt(Util.GetString(Centre_master_log_ID)) });
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
    public string savePUP(object PUP, int DocumentID)
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(16);
        int ReqCount = MT.GetIPCount(16);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return "Too Many Request,Try Again after some";
        }
        List<PanelMaster> panelMasterData = new JavaScriptSerializer().ConvertToType<List<PanelMaster>>(PUP);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT COUNT(1) FROM f_panel_master WHERE Company_Name = @Company_Name",
               new MySqlParameter("@Company_Name", panelMasterData[0].Company_Name)));
            if (count > 0)
                return JsonConvert.SerializeObject(new { status = false, response = "PUP Name Already Exist", focusControl = "txtPUPName" });

            string loginid = StockReports.ExecuteScalar(" SELECT  UserName FROM `f_login` lg  WHERE  lg.`UserName` LIKE '%"+ panelMasterData[0].LoginID + "%' ");

            if (loginid == panelMasterData[0].LoginID)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "UserName Already Exist", focusControl = "txtOnlineUserName" });
               
            }          
             //   return JsonConvert.SerializeObject(new { status = false, response = "PUP Code Already Exist", focusControl = "txtPUPCode" });
                int isinvoice = 0;
                if (panelMasterData[0].Payment_Mode == "Credit")
                {
                    isinvoice = 1;
                }

            PanelMaster objPanel = new PanelMaster(tnx)
            {
               
                Company_Name = panelMasterData[0].Company_Name.ToUpper(),
                Add1 = panelMasterData[0].Add1,
                PanelGroup = panelMasterData[0].PanelGroup,
                PanelGroupID = panelMasterData[0].PanelGroupID,
                IsActive = Util.GetInt(panelMasterData[0].IsActive),
                Mobile = panelMasterData[0].Mobile,
                EmailID = panelMasterData[0].EmailID,
                Phone = panelMasterData[0].Phone,
                Payment_Mode = panelMasterData[0].Payment_Mode,
                TagProcessingLab = panelMasterData[0].TagProcessingLab,
                TagProcessingLabID = panelMasterData[0].TagProcessingLabID,
                EmailIDReport = panelMasterData[0].EmailIDReport,
                ReportDispatchMode = panelMasterData[0].ReportDispatchMode,
                MinBusinessCommitment = panelMasterData[0].MinBusinessCommitment,
                GSTTin = panelMasterData[0].GSTTin,
                BankName = panelMasterData[0].BankName,
                BankID = panelMasterData[0].BankID,
                AccountNo = panelMasterData[0].AccountNo,
                IFSCCode = panelMasterData[0].IFSCCode,
                InvoiceBillingCycle = panelMasterData[0].InvoiceBillingCycle,
                LoginID = panelMasterData[0].LoginID,
                LoginPassword=panelMasterData[0].LoginPassword,
                PrintAtCentre = panelMasterData[0].PrintAtCentre,
                MinBalReceive = panelMasterData[0].MinBalReceive,
                CreditLimit = panelMasterData[0].CreditLimit,
                ReportInterpretation = panelMasterData[0].ReportInterpretation,
                HideDiscount = panelMasterData[0].HideDiscount,
                SecurityDeposit = panelMasterData[0].SecurityDeposit,
                SavingType = panelMasterData[0].SavingType,
                PanelType = "PUP",
                Panel_Code = panelMasterData[0].Panel_Code,
                HideReceiptRate = Util.GetInt(panelMasterData[0].HideReceiptRate),
                AAALogo = panelMasterData[0].AAALogo,
                IsInvoice = panelMasterData[0].IsInvoice,
                InvoiceDisplayName = panelMasterData[0].InvoiceDisplayName,
                InvoiceDisplayNo = panelMasterData[0].InvoiceDisplayNo,
                IsPrintingLock = panelMasterData[0].IsPrintingLock,
                IsBookingLock = panelMasterData[0].IsBookingLock,
                DiscPercent = panelMasterData[0].DiscPercent,
                SharePercentage = 0,
                Fullpaidpanelid = "0",
                InvoiceTo = panelMasterData[0].InvoiceTo,
                PROID = Util.GetInt(panelMasterData[0].PROID),
                ShowAmtInBooking = panelMasterData[0].ShowAmtInBooking,
                HideRate = panelMasterData[0].HideRate,
                TagBusinessLabID = panelMasterData[0].TagBusinessLabID,
                TagBusinessLab = panelMasterData[0].TagBusinessLab,
                CentreType1 = panelMasterData[0].PanelGroup,
                CentreType1ID = panelMasterData[0].PanelGroupID,
                IsOtherLabReferenceNo = panelMasterData[0].IsOtherLabReferenceNo,
                BarCodePrintedType = panelMasterData[0].BarCodePrintedType,
                SampleCollectionOnReg = panelMasterData[0].SampleCollectionOnReg,
                BarCodePrintedCentreType = panelMasterData[0].BarCodePrintedCentreType,
                BarCodePrintedHomeColectionType = panelMasterData[0].BarCodePrintedHomeColectionType,
                SetOfBarCode = panelMasterData[0].SetOfBarCode,
                SampleRecollectAfterReject = panelMasterData[0].SampleRecollectAfterReject,
                CountryID = panelMasterData[0].CountryID,
                CountryName = panelMasterData[0].CountryName,
                area = panelMasterData[0].area,
                LocalityID = panelMasterData[0].LocalityID,
                city = panelMasterData[0].city,
                CityID = panelMasterData[0].CityID,  
                state = panelMasterData[0].state,
                StateID = panelMasterData[0].StateID,
                ZoneID = panelMasterData[0].ZoneID,
                Zone = panelMasterData[0].Zone,
                BusinessZoneID = panelMasterData[0].BusinessZoneID,
                BusinessZone = panelMasterData[0].BusinessZone,
                IsAllowDoctorShare=panelMasterData[0].IsAllowDoctorShare,
                MonthlyInvoiceType = panelMasterData[0].MonthlyInvoiceType,
                InvoiceCreatedOn = panelMasterData[0].InvoiceCreatedOn,
                SalesManager = panelMasterData[0].SalesManager,
                SalesManagerName = panelMasterData[0].SalesManagerName,
                LabReportLimit = panelMasterData[0].LabReportLimit,
                IntimationLimit = panelMasterData[0].IntimationLimit,
                IsShowIntimation = panelMasterData[0].IsShowIntimation,
                RollingAdvance=panelMasterData[0].RollingAdvance,
                PanNo=panelMasterData[0].PanNo,
                PANCardName=panelMasterData[0].PANCardName,
                CreationDate=panelMasterData[0].CreationDate,
                ReceiptType = panelMasterData[0].ReceiptType,
                showBalanceAmt = panelMasterData[0].showBalanceAmt,
                SecurityAmt=panelMasterData[0].SecurityAmt,
                SecurityRemark=panelMasterData[0].SecurityRemark
            };
            if (panelMasterData[0].ReferenceCodeOPD != "0")
            {
                objPanel.ReferenceCode = panelMasterData[0].ReferenceCode;
                objPanel.ReferenceCodeOPD = panelMasterData[0].ReferenceCodeOPD;
            }
            else
            {
                objPanel.ReferenceCode = "0";
                objPanel.ReferenceCodeOPD = "0";
            }
            if (panelMasterData[0].ReferenceMrp != "0")
                objPanel.ReferenceMrp = panelMasterData[0].ReferenceMrp;
            else
                objPanel.ReferenceMrp = "0";

            string PanelId = objPanel.Insert();
            if (panelMasterData[0].ReferenceCodeOPD == "0")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET ReferenceCode=@ReferenceCode, ReferenceCodeOPD=@ReferenceCodeOPD WHERE Panel_ID=@Panel_ID",
                   new MySqlParameter("@ReferenceCode", PanelId), new MySqlParameter("@ReferenceCodeOPD", PanelId), new MySqlParameter("@Panel_ID", PanelId));
            }
            if (panelMasterData[0].InvoiceTo == "0")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET InvoiceTo=@InvoiceTo WHERE Panel_ID=@Panel_ID",
                    new MySqlParameter("@InvoiceTo", PanelId), new MySqlParameter("@Panel_ID", PanelId));
            }
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
                string rsltdata = SaveLogin(tnx, Employee_id, panelMasterData[0].LoginID, panelMasterData[0].LoginPassword, panelMasterData[0].LoginPassword, Util.GetString(panelMasterData[0].TagBusinessLabID), roleID, "1", panelMasterData[0].TagBusinessLabID, Util.GetInt(roleID));
                if (rsltdata.IndexOf("Record Saved") > 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update f_panel_master set employee_id='" + Employee_id + "' where panel_ID='" + PanelId + "'");
                }
                else
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Not Saved" });
                }

            }
            StringBuilder sb = new StringBuilder();
            if (panelMasterData[0].EnrollID.Trim() != string.Empty)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sales_enrolment_master SET ISEnroll=1,Panel_ID=@Panel_ID WHERE ID=@ID ",
                   new MySqlParameter("@Panel_ID", PanelId), new MySqlParameter("@ID", panelMasterData[0].EnrollID.Trim()));

                sb = new StringBuilder();
                sb.Append(" INSERT INTO f_ratelist(Rate,ERate,ItemID,IsService,Panel_ID,SpecialFlag,IsCurrent,FromDate) ");
                sb.Append(" SELECT se.SpecialTestRate,se.SpecialTestRate,se.SpecialTestID,1,@PanelId,1,1,CURRENT_DATE()   ");
                sb.Append(" FROM  sales_specialtest_enrolment se WHERE se.EnrollID=@EnrollID  ");
                sb.Append(" AND se.SpecialTestRate<>0 AND se.IsActive=1 ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()),
                   new MySqlParameter("@PanelId", @PanelId));


                sb = new StringBuilder();
                sb.Append(" INSERT INTO f_ratelist(Rate,ERate,ItemID,IsService,Panel_ID,SpecialFlag,IsCurrent,FromDate) ");
                sb.Append(" SELECT round(rat.Rate- ((rat.Rate*@DiscPercent)/100))Rate,round(rat.Rate- ((rat.Rate*@DiscPercent)/100))ERate,rat.ItemID,1,@PanelId,0,1,CURRENT_DATE()  FROM  f_ratelist rat");
                sb.Append("  INNER JOIN f_panel_master pm ON pm.Panel_ID=rat.Panel_ID  ");
                sb.Append("  AND rat.Panel_ID=( SELECT ReferenceCode FROM f_panel_master WHERE CentreID=@CentreID AND IsActive=1 AND PanelType='Centre'  LIMIT 1 )  ");
                sb.Append(" LEFT JOIN sales_specialtest_enrolment se ON rat.itemid=se.SpecialTestID AND se.EnrollID=@EnrollID AND se.SpecialTestRate<>0 AND se.IsActive=1 ");
                sb.Append(" WHERE se.ID IS NULL ");
                sb.Append(" ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@CentreID", panelMasterData[0].TagProcessingLabID),
                   new MySqlParameter("@EnrollID", panelMasterData[0].EnrollID.Trim()),
                   new MySqlParameter("@DiscPercent", Util.GetDecimal(panelMasterData[0].DiscPercent)),
                   new MySqlParameter("@PanelId", PanelId));

            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO centre_panel(CentreID,PanelID,UserID)VALUES(@CentreID,@PanelID,@UserID)",
               new MySqlParameter("@CentreID", panelMasterData[0].TagBusinessLabID), new MySqlParameter("@PanelID", PanelId), new MySqlParameter("@UserID", UserInfo.ID));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " update centre_type1master set MaxID=MaxID+1 where ID='7'");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " update f_panel_master set AllowSharing=@AllowSharing ,Panel_code=@PanelID where Panel_ID=@PanelID", new MySqlParameter("@PanelID", PanelId), new MySqlParameter("@AllowSharing", panelMasterData[0].AllowSharing));

            // if (Util.GetString(panelMasterData[0].TagHUB) != "")
            //{
            //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET TagHUBID=@InvoiceTo WHERE Panel_ID=@Panel_ID",
            //       new MySqlParameter("@InvoiceTo", panelMasterData[0].TagHUB), new MySqlParameter("@Panel_ID", PanelId));
            //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO centre_panel(CentreID,PanelID,UserID)VALUES(@CentreID,@PanelID,@UserID)",
            //   new MySqlParameter("@CentreID", panelMasterData[0].TagHUB), new MySqlParameter("@PanelID", PanelId), new MySqlParameter("@UserID", UserInfo.ID));
            //}

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO pup_master_log(Panel_ID,f_panel_master_log,CreatedBy,CreatedByID,LogType)VALUES(@Panel_ID,@f_panel_master_log,@CreatedBy,@CreatedByID,'New') ",
              new MySqlParameter("@f_panel_master_log", JsonConvert.SerializeObject(panelMasterData)),
              new MySqlParameter("@Panel_ID", PanelId), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
              new MySqlParameter("@CreatedByID", UserInfo.ID));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE document_detail SET PanelID=@Panel_ID WHERE ID=@ID",
                    new MySqlParameter("@ID", DocumentID), new MySqlParameter("@Panel_ID", PanelId));

            tnx.Commit();
            panelMasterData.Clear();
            return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
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
}
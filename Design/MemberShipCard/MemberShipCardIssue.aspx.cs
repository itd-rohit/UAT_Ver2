using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Membershipcard_MemberShipCardIssue : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            ddlcard.DataSource = StockReports.GetDataTable(@"SELECT CONCAT(id,'#',No_of_dependant,'#',0,'#',DATE_FORMAT(ValidUpTo,'%d-%b-%Y'),'#',Amount,'#',ItemID,'#',SubCategoryID,'#',ValidUpTo)id,NAME cardname 
 FROM membership_card_master WHERE isactive=1 AND ValidUpTo>CURRENT_DATE");
            ddlcard.DataValueField = "id";
            ddlcard.DataTextField = "cardname";
            ddlcard.DataBind();
            ddlcard.Items.Insert(0, new ListItem("Select Card ", "0"));


        }
    }

    [WebMethod]
    public static string getCardDetail(string cardID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT im.TestCode, im.`TypeName` ItemName,sm.`Name` deptname,mt.SelfDisc,mt.`DependentDisc`,mt.`SelfFreeTestCount`,mt.`DependentFreeTestCount` FROM membershipcard_tests_master mt");
            sb.Append(" INNER JOIN `f_itemmaster` im ON im.`ItemID`=mt.`ItemID` INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=mt.`Subcategoryid` WHERE mt.MemberShipID=@MemberShipID ORDER BY sm.`Name`,im.TypeName ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
             new MySqlParameter("@MemberShipID", cardID.Split('#')[0])).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = "true", response = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = false, response = "Item Not found on this selected Card" });
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, MemberSearch = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod]
    public static string savedata(List<Patient_Master> PatientData, Ledger_Transaction LTData, Patient_Lab_InvestigationOPD plodata, List<Receipt> rcdata, int cardid, DateTime cardvalidity, string cardno, int CardDependent)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {
            int cardActive = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM membership_card_master WHERE ID=@ID AND IsActive=0",
                new MySqlParameter("@ID", cardid)));
            if (cardActive > 0)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Membership Card Already Deactive" });
            }
            string MemberShipCardNo = string.Empty;
            if (Resources.Resource.MemberShipCardNoAutoGenerate == "0" && cardno.Trim() == string.Empty)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Enter Membership Card No." });

            }
            if (Resources.Resource.MemberShipCardNoAutoGenerate == "1")
            {
                MemberShipCardNo = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select get_Tran_id('MemberShipCardNo') "));
                if (MemberShipCardNo == string.Empty || MemberShipCardNo == "0")
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "MemberShipCardNo Generate Error" });
                }
            }
            else
            {
                MemberShipCardNo = cardno;
            }
            if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) from membershipcard WHERE CardNo=@CardNo",
                new MySqlParameter("@CardNo", MemberShipCardNo))) > 0)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Membership Card No. Already Issued" });
            }
            int testCount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM membershipcard_tests_master WHERE  MemberShipID=@MemberShipID",
               new MySqlParameter("@MemberShipID", cardid)));
            if (testCount == 0)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Please Add Test in MemberShip Card" });
            }
            string ConcatPatient_ID = string.Format("{0}", string.Join(",", PatientData.Where(s => s.Patient_ID != string.Empty).Select(a => String.Join(", ", a.Patient_ID))));
            if (ConcatPatient_ID != string.Empty)
            {
                string[] Patient_IDTags = String.Join(",", ConcatPatient_ID).Split(',');
                string[] Patient_IDParamNames = Patient_IDTags.Select((s, i) => "@tag" + i).ToArray();
                string Patient_IDClause = string.Join(", ", Patient_IDParamNames);
                sb.Append("SELECT IFNULL(CAST(GROUP_CONCAT(Patient_ID SEPARATOR '<br/>' ) AS CHAR),'')Patient_ID FROM patient_master WHERE Patient_ID IN ({0}) AND MembershipCardID!=0 AND MembershipCardValidTo>CURRENT_DATE ");

                using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), Patient_IDClause), con))
                {
                    for (int i = 0; i < Patient_IDParamNames.Length; i++)
                    {
                        cmd.Parameters.AddWithValue(Patient_IDParamNames[i], Patient_IDTags[i]);
                    }
                    string exitPatientID = Util.GetString(cmd.ExecuteScalar());
                    if (exitPatientID.ToString() != string.Empty)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = string.Concat("This UHID No. : ", exitPatientID, " , Already Exits in MemberShip") });
                    }
                }
            }
            DateTime billDate = DateTime.Now;
            int CreatedByID = UserInfo.ID;
            string CreatedBy = UserInfo.LoginName;
            string PatientID = string.Empty;
            string PrimaryPatientID = string.Empty;
            int FamilyMemberGroupID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_Tran_id('MembershipGroupID')"));
            if (FamilyMemberGroupID == 0)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "FamilyMemberGroupID Error" });
            }
            string Country = string.Empty;
            foreach (Patient_Master pm in PatientData)
            {
                if (pm.Patient_ID == string.Empty)
                {
                    if (Country == string.Empty)
                    {
                        Country = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Name FROM `country_master` WHERE CountryID=@CountryID",
                           new MySqlParameter("@CountryID", Resources.Resource.BaseCurrencyID)));
                    }
                    Patient_Master objPM = new Patient_Master(tnx);
                    objPM.Title = pm.Title;
                    objPM.PName = pm.PName.ToUpper();
                    objPM.DOB = pm.DOB;
                    objPM.Age = pm.Age;
                    objPM.AgeYear = pm.AgeYear;
                    objPM.AgeMonth = pm.AgeMonth;
                    objPM.AgeDays = pm.AgeDays;
                    objPM.TotalAgeInDays = pm.TotalAgeInDays;
                    objPM.Gender = pm.Gender;
                    objPM.Mobile = pm.Mobile;
                    objPM.base64PatientProfilePic = pm.base64PatientProfilePic;
                    objPM.CentreID = UserInfo.Centre;

                    objPM.FamilyMemberGroupID = FamilyMemberGroupID;
                    objPM.FamilyMemberIsPrimary = pm.FamilyMemberIsPrimary;
                    objPM.FamilyMemberRelation = pm.FamilyMemberRelation;
                    objPM.MembershipCardID = cardid;
                    objPM.MembershipCardNo = MemberShipCardNo;
                    objPM.MembershipCardValidFrom = DateTime.Now;
                    objPM.MembershipCardValidTo = Util.GetDateTime(cardvalidity.ToString("yyyy-MM-dd"));
                    objPM.CountryID = Util.GetInt(Resources.Resource.BaseCurrencyID);
                    objPM.Country = Util.GetString(Country);
                    try
                    {
                        string pid = objPM.Insert();
                        if (pm.FamilyMemberIsPrimary == 1)
                        {
                            PrimaryPatientID = pid;
                        }
                        PatientID = pid;
                        pm.Patient_ID = pid;
                    }
                    catch (Exception exPm)
                    {
                        if (exPm.Message.Contains("Duplicate entry") && exPm.Message.Contains("Patient_ID"))
                        {
                            PatientID = objPM.Insert();
                        }
                        else
                        {
                            tnx.Rollback();
                            return JsonConvert.SerializeObject(new { status = false, response = "Patient Master Error" });
                        }
                    }
                }
                else
                {
                    if (pm.FamilyMemberIsPrimary == 1)
                    {
                        PrimaryPatientID = pm.Patient_ID;
                    }
                    PatientID = pm.Patient_ID;
                    sb = new StringBuilder();
                    sb.Append("  UPDATE patient_master ");
                    sb.Append(" SET  ");
                    sb.Append(" Age = @Age,AgeYear = @AgeYear,AgeMonth = @AgeMonth, AgeDays = @AgeDays,TotalAgeInDays = @TotalAgeInDays,");
                    sb.Append(" dob= @dob,UpdateID = @UpdateID,IsDOBActual = @IsDOBActual,UpdateName = @UpdateName,UpdateDate = NOW(),House_no=@House_no,");
                    sb.Append(" FamilyMemberGroupID=@FamilyMemberGroupID,FamilyMemberIsPrimary=@FamilyMemberIsPrimary,FamilyMemberRelation=@FamilyMemberRelation, ");
                    sb.Append(" MembershipCardID=@MembershipCardID,MembershipCardNo=@MembershipCardNo,MembershipCardValidFrom=NOW(),");
                    sb.Append(" MembershipCardValidTo=@MembershipCardValidTo WHERE Patient_ID = @Patient_ID");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@Age", pm.Age), new MySqlParameter("@AgeYear", pm.AgeYear),
                       new MySqlParameter("@AgeMonth", pm.AgeMonth), new MySqlParameter("@AgeDays", pm.AgeDays),
                       new MySqlParameter("@TotalAgeInDays", pm.TotalAgeInDays),
                       new MySqlParameter("@dob", Util.GetDateTime(pm.DOB).ToString("yyyy-MM-dd")),
                       new MySqlParameter("@UpdateID", UserInfo.ID),
                       new MySqlParameter("@IsDOBActual", pm.IsDOBActual),
                       new MySqlParameter("@UpdateName", UserInfo.LoginName),
                       new MySqlParameter("@House_no", pm.House_No),
                       new MySqlParameter("@FamilyMemberGroupID", FamilyMemberGroupID),
                       new MySqlParameter("@FamilyMemberIsPrimary", pm.FamilyMemberIsPrimary),
                       new MySqlParameter("@Patient_ID", pm.Patient_ID),
                       new MySqlParameter("@FamilyMemberRelation", pm.FamilyMemberRelation),
                       new MySqlParameter("@MembershipCardID", cardid),
                       new MySqlParameter("@MembershipCardNo", MemberShipCardNo),
                       new MySqlParameter("@MembershipCardValidTo", Util.GetDateTime(cardvalidity.ToString("yyyy-MM-dd"))));


                }
            }

            string BillNo = AllLoad_Data.getBillNo(UserInfo.Centre, "B", con, tnx);
            if (BillNo == string.Empty)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "BillNo Error" });
            }
            int LedgerTransactionID = 0;
            string LedgerTransactionNo = string.Empty;

            int Panel_ID = 0;
            string ClientName = string.Empty;
            using (DataTable panelDetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Panel_ID,Panel_Code,`Company_Name` ClientName FROM f_panel_master WHERE CentreID=@CentreID AND PanelType='Centre' LIMIT 1",
                    new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0])
            {
                Panel_ID = Util.GetInt(panelDetail.Rows[0]["Panel_ID"].ToString());
                ClientName = panelDetail.Rows[0]["ClientName"].ToString();
            }

            Ledger_Transaction objlt = new Ledger_Transaction(tnx);
            objlt.DiscountOnTotal = 0;
            objlt.NetAmount = LTData.NetAmount;
            objlt.GrossAmount = LTData.GrossAmount;
            objlt.IsCredit = 0;
            objlt.Patient_ID = PrimaryPatientID;
            objlt.Age = PatientData[0].Age;
            objlt.Gender = PatientData[0].Gender;
            objlt.PName =string.Concat( PatientData[0].Title , PatientData[0].PName.ToUpper());
            objlt.Panel_ID = Panel_ID;
            objlt.PanelName = ClientName;
            objlt.Doctor_ID = LTData.Doctor_ID;
            objlt.DoctorName = LTData.DoctorName;
            objlt.CreatedBy = CreatedBy;
            objlt.CreatedByID = CreatedByID;
            objlt.CentreID = UserInfo.Centre;
            objlt.BillDate = billDate;
         
            objlt.Adjustment = Util.GetDecimal(LTData.Adjustment + LTData.Currency_RoundOff);
            objlt.AdjustmentDate = billDate;
            string retvalue = objlt.Insert();
            if (retvalue == string.Empty)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "LT Error" });
            }
            LedgerTransactionID = Util.GetInt(retvalue.Split('#')[0]);
            LedgerTransactionNo = retvalue.Split('#')[1];

            Patient_Lab_InvestigationOPD objPlo = new Patient_Lab_InvestigationOPD(tnx);
            objPlo.LedgerTransactionID = LedgerTransactionID;
            objPlo.LedgerTransactionNo = LedgerTransactionNo;
            objPlo.Patient_ID = PatientID;
            objPlo.AgeInDays = PatientData[0].TotalAgeInDays;
            objPlo.Gender = PatientData[0].Gender;
            objPlo.BarcodeNo = string.Empty;
            objPlo.ItemId = plodata.ItemId;
            objPlo.ItemName = plodata.ItemName.ToUpper();
            objPlo.SubCategoryID = plodata.SubCategoryID;
            objPlo.Rate = plodata.Rate;
            objPlo.Amount = plodata.Amount;
            objPlo.IsActive = 1;
            objPlo.BillNo = BillNo;
            objPlo.BillType = "Credit-Test Add";
            objPlo.Date = billDate;
            objPlo.MRP = plodata.Rate;
            objPlo.CreatedBy = UserInfo.LoginName;
            objPlo.CreatedByID = UserInfo.ID;
            objPlo.Quantity = 1;
            string ID = objPlo.Insert();

            if (ID == string.Empty)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "PLO Error" });
            }

            if (objlt.Adjustment > 0)
            {
                foreach (Receipt rrc in rcdata)
                {
                    Receipt objRC = new Receipt(tnx)
                    {
                        LedgerNoCr = "OPD003",
                        LedgerTransactionID = LedgerTransactionID,
                        LedgerTransactionNo = LedgerTransactionNo,
                        CreatedByID = UserInfo.ID,
                        Patient_ID = PatientID,
                        PayBy = rrc.PayBy,
                        PaymentMode = rrc.PaymentMode,
                        PaymentModeID = rrc.PaymentModeID,
                        Amount = rrc.Amount,
                        BankName = rrc.BankName,
                        CardNo = rrc.CardNo,
                        CardDate = rrc.CardDate,
                        IsCancel = 0,
                        Narration = rrc.Narration,
                        CentreID = UserInfo.Centre,
                        Panel_ID = Panel_ID,
                        CreatedDate = billDate,
                        S_Amount = rrc.S_Amount,
                        S_CountryID = rrc.S_CountryID,
                        S_Currency = rrc.S_Currency,
                        S_Notation = rrc.S_Notation,
                        C_Factor = rrc.C_Factor,
                        Currency_RoundOff = rrc.Currency_RoundOff,
                        CurrencyRoundDigit = rrc.CurrencyRoundDigit,
                        CreatedBy = UserInfo.LoginName,
                        Converson_ID = rrc.Converson_ID
                    };
                    string ReceiptNo = objRC.Insert();
                    if (ReceiptNo == string.Empty)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "Receipt Error" });
                    }

                    var patientAdvancePaymentMode = rcdata.Where(p => p.PaymentModeID == 9).ToList();
                    for (int i = 0; i < patientAdvancePaymentMode.Count; i++)
                    {
                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,(AdvanceAmount-IFNULL(BalanceAmount,0))RemAmt,ReceiptNo FROM OPD_Advance WHERE Patient_ID =@Patient_ID  AND IsCancel=0 AND (AdvanceAmount-IFNULL(BalanceAmount,0))>0 AND AdvanceType='Patient' ORDER BY ID+0",
                            new MySqlParameter("@Patient_ID", PatientID)).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                decimal advanceAmount = patientAdvancePaymentMode[i].Amount;
                                for (int s = 0; s < dt.Rows.Count; s++)
                                {
                                    decimal paidAmt = 0;
                                    if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) >= Util.GetDecimal(advanceAmount))
                                    {
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update OPD_Advance SET BalanceAmount =BalanceAmount+@advanceAmount WHERE ID =@ID ",
                                                                    new MySqlParameter("@advanceAmount", Util.GetDecimal(advanceAmount)),
                                                                    new MySqlParameter("@ID", dt.Rows[s]["ID"].ToString()));
                                        paidAmt = advanceAmount;
                                        advanceAmount = 0;
                                    }
                                    else if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) < Util.GetDecimal(advanceAmount))
                                    {
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update OPD_Advance SET BalanceAmount =BalanceAmount+@BalanceAmount WHERE ID =@ID ",
                                                                    new MySqlParameter("@BalanceAmount", Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString())),
                                                                    new MySqlParameter("@ID", dt.Rows[s]["ID"].ToString()));

                                        advanceAmount = advanceAmount - Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                                        paidAmt = Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                                    }

                                    OPD_Advance_Detail adv = new OPD_Advance_Detail(tnx)
                                    {
                                        PaidAmount = Util.GetDecimal(paidAmt),
                                        Patient_ID = PatientID,
                                        LedgerTransactionID = LedgerTransactionID,
                                        LedgerTransactionNo = LedgerTransactionNo,
                                        ReceiptNo = ReceiptNo,
                                        CentreID = LTData.CentreID,
                                        Panel_ID = Panel_ID,
                                        CreatedBy = CreatedBy,
                                        CreatedByID = CreatedByID,
                                        AdvanceID = Util.GetInt(dt.Rows[s]["ID"].ToString()),
                                        ReceiptNoAgainst = dt.Rows[s]["ReceiptNo"].ToString(),
                                        AdvanceType = "Patient"
                                    };

                                    adv.Insert();
                                    if (advanceAmount == 0)
                                        break;
                                }
                                if (advanceAmount > 0)
                                {
                                    tnx.Rollback();
                                    return JsonConvert.SerializeObject(new { status = false, response = "Un-Sufficient OPD Advance Balance", message = "Error In OPD Advance" });
                                }
                            }
                            else
                            {
                                tnx.Rollback();
                                return JsonConvert.SerializeObject(new { status = false, response = "Un-Sufficient OPD Advance Balance", message = "Error In OPD Advance" });
                            }
                        }
                    }
                }
            }

            sb = new StringBuilder();
            sb.Append(" INSERT INTO membershipcard(CardNo,NAME,Age,Gender,Mobile,MembershipCardID,ValidFrom,ValidTo,LedgerTransactionNo,CreatedByID,Amount,LedgerTransactionID,Patient_ID,CardType,CardDependent,MembershipCardName,FamilyMemberGroupID,CreatedBy,CentreID) ");
            sb.Append(" values (@CardNo,@NAME,@Age,@Gender,@Mobile,@MembershipCardID,@ValidFrom,@ValidTo,@LedgerTransactionNo,@CreatedByID,@Amount,@LedgerTransactionID,@Patient_ID,@cardType,@CardDependent,@MembershipCardName,@FamilyMemberGroupID,@CreatedBy,@CentreID)");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@CardNo", MemberShipCardNo),
                new MySqlParameter("@NAME", PatientData[0].Title + PatientData[0].PName.ToUpper()),
                new MySqlParameter("@Age", PatientData[0].Age),
                new MySqlParameter("@Gender", PatientData[0].Gender),
                new MySqlParameter("@Mobile", PatientData[0].Mobile),
                new MySqlParameter("@MembershipCardID", cardid),
                new MySqlParameter("@ValidFrom", DateTime.Now.ToString("yyyy-MM-dd")),
                new MySqlParameter("@ValidTo", Util.GetDateTime(cardvalidity).ToString("yyyy-MM-dd")),
                new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                new MySqlParameter("@CreatedByID", UserInfo.ID),
                new MySqlParameter("@CardType", Resources.Resource.MemberShipCardNoAutoGenerate),
                new MySqlParameter("@CardDependent", CardDependent),
                new MySqlParameter("@MembershipCardName", plodata.ItemName),
                new MySqlParameter("@Amount", LTData.NetAmount),
                new MySqlParameter("@Patient_ID", PrimaryPatientID),
                new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                new MySqlParameter("@FamilyMemberGroupID", FamilyMemberGroupID),
                new MySqlParameter("@CentreID", UserInfo.Centre));


            foreach (Patient_Master pm in PatientData)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO membershipcard_member(MembershipCardNo,PName,Patient_ID,Age,Gender,Relation,CreatedByID,Mobile,MembershipCardID,CreatedBy,FamilyMemberIsPrimary,CardValid,FamilyMemberGroupID,CardType) ");
                sb.Append(" values (@CardNo,@PName,@Patient_ID,@Age,@Gender,@Relation,@CreatedByID,@Mobile,@MembershipCardID,@CreatedBy,@FamilyMemberIsPrimary,@CardValid,@FamilyMemberGroupID,@CardType)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@CardNo", MemberShipCardNo),
                     new MySqlParameter("@MembershipCardID", cardid),
                     new MySqlParameter("@PName", pm.Title + pm.PName.ToUpper()),
                     new MySqlParameter("@Patient_ID", pm.Patient_ID),
                     new MySqlParameter("@Age", pm.Age), new MySqlParameter("@FamilyMemberGroupID", FamilyMemberGroupID),
                     new MySqlParameter("@Gender", pm.Gender),
                     new MySqlParameter("@Relation", pm.FamilyMemberRelation), new MySqlParameter("@CardType", Resources.Resource.MemberShipCardNoAutoGenerate),
                     new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@FamilyMemberIsPrimary", pm.FamilyMemberIsPrimary),
                     new MySqlParameter("@Mobile", pm.Mobile), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                     new MySqlParameter("@CardValid", Util.GetDateTime(cardvalidity).ToString("yyyy-MM-dd")));
            }
            sb = new StringBuilder();
            sb.Append(" INSERT INTO membershipcard_Detail(Patient_ID,MembershipCardID,MembershipCardNo,FamilyMemberIsPrimary,ItemID,SelfDisc,DependentDisc,SelfFreeTest,SelfFreeTestCount,DependentFreeTest,DependentFreeTestCount,CardValid,FamilyMemberGroupID,CardType,SubcategoryID)");
            sb.Append(" SELECT shi.`Patient_ID`,mem.`MemberShipID`,shi.`MembershipCardNo`,shi.`FamilyMemberIsPrimary`,");
            sb.Append(" mem.`ItemID`,mem.SelfDisc,0 DependentDisc,mem.SelfFreeTest,mem.SelfFreeTestCount,0 DependentFreeTest,0 DependentFreeTestCount,@CardValid,shi.FamilyMemberGroupID,@CardType,mem.SubcategoryID ");
            sb.Append(" FROM membershipcard_tests_master mem INNER JOIN membershipcard_member shi  ON mem.`MemberShipID`=shi.`MembershipCardID` AND shi.FamilyMemberIsPrimary=1 AND shi.FamilyMemberGroupID=@FamilyMemberGroupID");
            sb.Append(" WHERE mem.MemberShipID=@MembershipCardID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                      new MySqlParameter("@MembershipCardNo", MemberShipCardNo), new MySqlParameter("@FamilyMemberGroupID", FamilyMemberGroupID),
                      new MySqlParameter("@MembershipCardID", cardid), new MySqlParameter("@CardType", Resources.Resource.MemberShipCardNoAutoGenerate),
                      new MySqlParameter("@CardValid", Util.GetDateTime(cardvalidity).ToString("yyyy-MM-dd")));

            sb = new StringBuilder();
            sb.Append(" INSERT INTO membershipcard_Detail(Patient_ID,MembershipCardID,MembershipCardNo,FamilyMemberIsPrimary,ItemID,SelfDisc,DependentDisc,SelfFreeTest,SelfFreeTestCount,DependentFreeTest,DependentFreeTestCount,CardValid,FamilyMemberGroupID,CardType,SubcategoryID)");
            sb.Append(" SELECT shi.`Patient_ID`,mem.`MemberShipID`,shi.`MembershipCardNo`,shi.`FamilyMemberIsPrimary`,");
            sb.Append(" mem.`ItemID`,0 SelfDisc,mem.DependentDisc,0 SelfFreeTest,0 SelfFreeTestCount,mem.DependentFreeTest,mem.DependentFreeTestCount,@CardValid,shi.FamilyMemberGroupID,@CardType,mem.SubcategoryID ");
            sb.Append(" FROM membershipcard_tests_master mem INNER JOIN membershipcard_member shi  ON mem.`MemberShipID`=shi.`MembershipCardID` AND shi.FamilyMemberIsPrimary=0 AND shi.FamilyMemberGroupID=@FamilyMemberGroupID");
            sb.Append(" WHERE mem.MemberShipID=@MembershipCardID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                      new MySqlParameter("@MembershipCardNo", MemberShipCardNo), new MySqlParameter("@FamilyMemberGroupID", FamilyMemberGroupID),
                      new MySqlParameter("@MembershipCardID", cardid), new MySqlParameter("@CardType", Resources.Resource.MemberShipCardNoAutoGenerate),
                      new MySqlParameter("@CardValid", Util.GetDateTime(cardvalidity).ToString("yyyy-MM-dd")));

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = "true", response = "MemberShip Card Issued", LabID = Common.Encrypt(Util.GetString(LedgerTransactionID)), No = Common.Encrypt(MemberShipCardNo) });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { Status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

}
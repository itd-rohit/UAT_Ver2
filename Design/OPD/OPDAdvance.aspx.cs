using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_OPD_OPDAdvance : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindcentre();
        }
    }

    private void bindcentre()
    {
        ddlCentre.DataSource = StockReports.GetDataTable(string.Format("SELECT CONCAT(CentreID,'#',type1id,'#',IFNULL(CityID,''),'#',IFNULL(StateID,''),'#',IFNULL(contactperson,''),'#',IFNULL(contactpersonmobile,''),'#',IFNULL(contactpersonemail,''),'#',IFNULL(LocalityID,''),'#',IF(IFNULL(cm.`PaytmMid`,'')<>'' AND IFNULL(cm.`PaytmGuid`,'')<>'' AND IFNULL(cm.`PaytmKey`,'')<>'','1','0'),'#',IFNULL(cm.`COCO_FOCO`,''),'#',0,'#',IFNULL(CountryID,'')) CentreID,Centre FROM centre_master cm where cm.CentreID={0} AND cm.isActive=1 order by cm.CentreCode", UserInfo.Centre));
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataTextField = "Centre";
        ddlCentre.DataBind();
    }

    [WebMethod(EnableSession = true)]
    public static string SaveOPDAdvance(Patient_Master PatientData, List<Receipt> Rcdata, int isVipM)
    {
        byte ReVisit = 0;
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Your Session Expired Please Login Again" });
        }

        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string PatientID = string.Empty;
            string ReceiptNo = string.Empty;

            string LedgerTransactionNo = string.Empty;
            if (PatientData.Patient_ID == string.Empty)
            {
                Patient_Master objPM = new Patient_Master(tnx)
                {
                    Title = PatientData.Title,
                    PName = PatientData.PName,
                    House_No = PatientData.House_No,
                    Street_Name = PatientData.Street_Name,
                    Pincode = PatientData.Pincode,
                    Country = PatientData.Country,
                    State = PatientData.State,
                    City = PatientData.City,
                    Locality = PatientData.Locality,
                    Phone = PatientData.Phone,
                    Mobile = PatientData.Mobile,
                    Email = PatientData.Email,
                    DOB = PatientData.DOB,
                    Age = PatientData.Age,
                    AgeYear = PatientData.AgeYear,
                    AgeMonth = PatientData.AgeMonth,
                    AgeDays = PatientData.AgeDays,
                    TotalAgeInDays = PatientData.TotalAgeInDays,
                    Gender = PatientData.Gender,
                    CentreID = PatientData.CentreID,
                    CountryID = PatientData.CountryID,
                    StateID = PatientData.StateID,
                    CityID = PatientData.CityID,
                    LocalityID = PatientData.LocalityID,
                    IsOnlineFilterData = PatientData.IsOnlineFilterData,
                    IsDuplicate = PatientData.IsDuplicate,
                    IsDOBActual = PatientData.IsDOBActual,
                    ClinicalHistory = PatientData.ClinicalHistory
                };
                //isMask
                if (isVipM == 1)
                {
                    objPM.Title = "XX";
                    objPM.PName = "XXXXXX";
                    objPM.Mobile = "XXXXXX";
                    objPM.Email = "XXXXXX";
                }
                try
                {
                    PatientID = objPM.Insert();
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
                PatientID = PatientData.Patient_ID;
                sb = new StringBuilder();
                sb.Append("  UPDATE patient_master ");
                sb.Append(" SET  ");
                sb.Append(" Email = @Email,Age = @Age,AgeYear =@AgeYear,CountryID =@CountryID,StateID =@StateID,CityID =@CityID,LocalityID =@LocalityID,");
                sb.Append(" Country =@Country,State =@State,City = @City,Locality =@Locality,AgeMonth =@AgeMonth, AgeDays =@AgeDays,TotalAgeInDays =@TotalAgeInDays,dob=@DOB,");
                sb.Append(" UpdateID =@UpdateID,IsDOBActual =@IsDOBActual,UpdateName =@UpdateName,UpdateDate = NOW(),ClinicalHistory=@ClinicalHistory ");
                sb.Append(" WHERE Patient_ID =@Patient_ID;");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@Email", PatientData.Email), new MySqlParameter("@Age", PatientData.Age), new MySqlParameter("@AgeYear", PatientData.AgeYear),
                  new MySqlParameter("@CountryID", PatientData.CountryID), new MySqlParameter("@Country", PatientData.Country),
                  new MySqlParameter("@StateID", PatientData.StateID), new MySqlParameter("@CityID", PatientData.CityID), new MySqlParameter("@LocalityID", PatientData.LocalityID),
                  new MySqlParameter("@State", PatientData.State), new MySqlParameter("@City", PatientData.City), new MySqlParameter("@Locality", PatientData.Locality),
                  new MySqlParameter("@AgeMonth", PatientData.AgeMonth), new MySqlParameter("@AgeDays", PatientData.AgeDays), new MySqlParameter("@TotalAgeInDays", PatientData.TotalAgeInDays),
                  new MySqlParameter("@DOB", Util.GetDateTime(PatientData.DOB).ToString("yyyy-MM-dd")),
                  new MySqlParameter("@UpdateID", Util.GetInt(HttpContext.Current.Session["ID"])), new MySqlParameter("@IsDOBActual", PatientData.IsDOBActual),
                  new MySqlParameter("@UpdateName", Util.GetString(HttpContext.Current.Session["LoginName"])), new MySqlParameter("@Patient_ID", PatientData.Patient_ID),
                  new MySqlParameter("@ClinicalHistory", PatientData.ClinicalHistory));
                ReVisit = 1;
            }

            if (PatientID == string.Empty)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Patient Master Error" });
            }

            using (DataTable PanelData = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Panel_ID,IsInvoice,InvoiceTo InvoiceToPanelId,Company_Name FROM f_Panel_Master WHERE CentreID=@CentreID AND PanelType='Centre' AND IsActive=1",
               new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0])
            {
                string EmployeeList = string.Empty;
                int SalesManager = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT SalesManager FROM f_Panel_Master WHERE Panel_Id=@Panel_Id",
                   new MySqlParameter("@Panel_Id", PanelData.Rows[0]["Panel_ID"].ToString())));
                if (SalesManager != 0)
                    EmployeeList = AllLoad_Data.getSalesChildNode(con, SalesManager);

                DateTime billData = DateTime.Now;
                //Ledger_Transaction objlt = new Ledger_Transaction(tnx);
                //objlt.DiscountOnTotal = LTData.DiscountOnTotal;
                //objlt.NetAmount = LTData.NetAmount;
                //objlt.GrossAmount = LTData.GrossAmount;
                //objlt.isMask = LTData.isMask;
                //objlt.IsCredit = LTData.IsCredit;
                //objlt.Patient_ID = PatientID;
                //objlt.Age = PatientData.Age;
                //objlt.Gender = PatientData.Gender;
                //objlt.VIP = LTData.VIP;
                //objlt.Panel_ID = Util.GetInt(PanelData.Rows[0]["Panel_ID"].ToString());
                //objlt.PanelName = PanelData.Rows[0]["Company_Name"].ToString();
                //objlt.Doctor_ID = LTData.Doctor_ID;
                //objlt.DoctorName = LTData.DoctorName;
                //objlt.OtherReferLabID = LTData.OtherReferLabID;
                //objlt.CentreID = UserInfo.Centre;
                //objlt.Adjustment = LTData.Adjustment;
                //objlt.CreatedByID = UserInfo.ID;
                //objlt.CreatedBy = UserInfo.LoginName;
                //objlt.HomeVisitBoyID = LTData.HomeVisitBoyID;
                //objlt.PatientIDProof = LTData.PatientIDProof;
                //objlt.PatientIDProofNo = LTData.PatientIDProofNo;
                //objlt.PatientSource = LTData.PatientSource;
                //objlt.PatientType = LTData.PatientType;
                //objlt.VisitType = LTData.VisitType;
                //objlt.HLMPatientType = LTData.HLMPatientType;
                //objlt.HLMOPDIPDNo = LTData.HLMOPDIPDNo;
                //objlt.DiscountApprovedByID = LTData.DiscountApprovedByID;
                //objlt.DiscountApprovedByName = LTData.DiscountApprovedByName;
                //objlt.HLMPatientType = LTData.HLMPatientType;
                //objlt.HLMOPDIPDNo = LTData.HLMOPDIPDNo;
                //objlt.CorporateIDCard = LTData.CorporateIDCard;
                //objlt.CorporateIDType = LTData.CorporateIDType;
                //objlt.AttachedFileName = LTData.AttachedFileName;
                //objlt.ReVisit = ReVisit;

                //objlt.DiscountID = LTData.DiscountID;
                //objlt.OtherLabRefNo = LTData.OtherLabRefNo;
                //objlt.WorkOrderID = LTData.WorkOrderID;
                //objlt.PreBookingID = 0;
                //objlt.Doctor_ID_Temp = LTData.Doctor_ID_Temp;
                //objlt.IsDiscountApproved = LTData.IsDiscountApproved;
                //objlt.CashOutstanding = 0;
                //objlt.OutstandingEmployeeId = 0;
                //objlt.BarCodePrintedType = string.Empty;
                //objlt.BarCodePrintedCentreType = 0;
                //objlt.BarCodePrintedHomeColectionType = 0;
                //objlt.setOfBarCode = string.Empty;
                //objlt.SampleCollectionOnReg = 0;
                //objlt.InvoiceToPanelId = Util.GetInt(PanelData.Rows[0]["InvoiceToPanelId"].ToString());
                //objlt.PatientGovtType = LTData.PatientGovtType;
                //objlt.CardHolderRelation = LTData.CardHolderRelation;
                //objlt.CardHolderName = LTData.CardHolderName.ToUpper();
                //objlt.TempSecondRef = LTData.TempSecondRef;
                //objlt.SecondReferenceID = LTData.SecondReferenceID;
                //objlt.SecondReference = LTData.SecondReference;
                //objlt.BillDate = billData;
                //objlt.SalesTagEmployee = SalesManager;
                //if (isVipM == 1)
                //    objlt.PName = "XX-XXXXXX";
                //else
                //    objlt.PName = string.Concat(PatientData.Title, PatientData.PName.ToUpper());
                //string retvalue = objlt.Insert();
                //if (retvalue == string.Empty)
                //{
                //    tnx.Rollback();
                //    return JsonConvert.SerializeObject(new { status = false, response = "LT Error" });
                //}
                //LedgerTransactionID = Util.GetInt(retvalue.Split('#')[0]);
                //LedgerTransactionNo = retvalue.Split('#')[1];

                //sb = new StringBuilder();
                //sb.Append(" INSERT INTO f_ledgertransaction_Sales(LedgerTransactionID,LedgerTransactionNo,Sales,CreatedDate) ");
                //sb.Append(" VALUES(@LedgerTransactionID,@LedgerTransactionNo,@Sales,@CreatedDate)");
                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                //                            new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                //                            new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                //                            new MySqlParameter("@Sales", EmployeeList),
                //                            new MySqlParameter("@CreatedDate", billData));

                if (isVipM == 1)
                {
                    int isAlreadyInsert = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT COUNT(1) FROM  Patient_master_VIP WHERE Paitent_ID=@Paitent_ID",
                       new MySqlParameter("@Paitent_ID", PatientID)));
                    try
                    {
                        if (isAlreadyInsert > 0)
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE Patient_master_VIP set title=@Title, Paitent_name=@Paitent_name,Mobile=@Mobile,emailID=@emailID, isActive=1 WHERE Paitent_ID=@Paitent_ID",
                               new MySqlParameter("@Title", PatientData.Title), new MySqlParameter("@Paitent_name", PatientData.PName),
                               new MySqlParameter("@Mobile", PatientData.Mobile), new MySqlParameter("@emailID", PatientData.Email),
                               new MySqlParameter("@Paitent_ID", PatientData.Patient_ID));
                        }
                        else
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO Patient_master_VIP (Paitent_ID,Paitent_name,Mobile,emailID,title) values(@Paitent_ID,@Paitent_name,@Mobile,@emailID,@Title) ",
                                new MySqlParameter("@Paitent_ID", PatientData.Patient_ID), new MySqlParameter("@Paitent_name", PatientData.PName),
                                new MySqlParameter("@Mobile", PatientData.Mobile), new MySqlParameter("@emailID", PatientData.Email),
                                new MySqlParameter("@Title", PatientData.Title));
                        }
                    }
                    catch (Exception ex)
                    {
                        ClassLog CL = new ClassLog();
                        CL.errLog(ex);
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "VIP Patient Error" });
                    }
                }
                //string BillNo = AllLoad_Data.getBillNo(UserInfo.Centre, "B", con, tnx);
                //if (BillNo == string.Empty)
                //{
                //    tnx.Rollback();
                //    return JsonConvert.SerializeObject(new { status = false, response = "BillNo Error" });
                //}
                //foreach (Patient_Lab_InvestigationOPD plo in PLO)
                //{
                //    Patient_Lab_InvestigationOPD objPlo = new Patient_Lab_InvestigationOPD(tnx)
                //    {
                //        LedgerTransactionID = LedgerTransactionID,
                //        LedgerTransactionNo = LedgerTransactionNo,
                //        Patient_ID = PatientID,
                //        AgeInDays = PatientData.TotalAgeInDays,
                //        Gender = PatientData.Gender,
                //        BarcodeNo = string.Empty,
                //        ItemId = plo.ItemId,
                //        ItemName = "OPD Advance",
                //        PackageName = string.Empty,
                //        PackageCode = string.Empty,
                //        Investigation_ID = plo.Investigation_ID,
                //        IsPackage = 0,
                //        SubCategoryID = plo.SubCategoryID,
                //        Rate = LTData.NetAmount,
                //        Amount = LTData.NetAmount,
                //        DiscountAmt = 0,
                //        DiscountByLab = plo.DiscountByLab,
                //        CouponAmt = 0,
                //        Quantity = plo.Quantity,
                //        IsRefund = plo.IsRefund,
                //        IsReporting = plo.IsReporting,
                //        ReportType = plo.ReportType,
                //        CentreID = UserInfo.Centre,
                //        TestCentreID = UserInfo.Centre,
                //        barcodePreprinted = 0,
                //        IsSampleCollected = "N",
                //        SampleTypeID = 0,
                //        SampleTypeName = string.Empty,
                //        SampleCollector = UserInfo.LoginName,
                //        SampleCollectionBy = UserInfo.ID,
                //        SampleCollectionDate = Util.GetDateTime(DateTime.Now),
                //        SampleBySelf = plo.SampleBySelf,
                //        isUrgent = plo.isUrgent,
                //        DeliveryDate = billData,
                //        SRADate = billData,
                //        IsScheduleRate = plo.IsScheduleRate,
                //        MRP = plo.MRP == 0 ? plo.Rate : plo.MRP,
                //        Date = billData,
                //        PanelItemCode = plo.PanelItemCode,
                //        BillNo = BillNo,
                //        BillType = string.Empty,
                //        IsActive = 1,
                //        CreatedBy = UserInfo.LoginName,
                //        CreatedByID = UserInfo.ID
                //    };
                //    string ID = objPlo.Insert();
                //    if (ID == string.Empty)
                //    {
                //        tnx.Rollback();
                //        return JsonConvert.SerializeObject(new { status = false, response = "PLO Error" });
                //    }
                //}
                foreach (Receipt rrc in Rcdata)
                {
                    Receipt objRC = new Receipt(tnx)
                    {
                        LedgerNoCr = "OPD003",
                        LedgerTransactionID = 0,
                        LedgerTransactionNo = string.Empty,
                        CreatedByID = UserInfo.ID,
                        CreatedBy = UserInfo.UserName,
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
                        Panel_ID = Util.GetInt(PanelData.Rows[0]["Panel_ID"].ToString()),
                        CreatedDate = billData,
                        S_Amount = rrc.S_Amount,
                        S_CountryID = rrc.S_CountryID,
                        S_Currency = rrc.S_Currency,
                        S_Notation = rrc.S_Notation,
                        C_Factor = rrc.C_Factor,
                        Currency_RoundOff = rrc.Currency_RoundOff,
                        Converson_ID = rrc.Converson_ID
                    };
                    ReceiptNo = objRC.Insert();
                    if (ReceiptNo == string.Empty)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "Receipt Error" });
                    }

                    OPD_Advance adv = new OPD_Advance(tnx)
                    {
                        Patient_ID = PatientID,
                        LedgerTransactionID = 0,
                        LedgerTransactionNo = string.Empty,
                        AdvanceAmount = Util.GetDecimal(rrc.Amount),
                        ReceiptNo = ReceiptNo,
                        CreatedBy = UserInfo.UserName,
                        CreatedByID = UserInfo.ID,
                        CentreID = UserInfo.Centre,
                        Panel_ID = Util.GetInt(PanelData.Rows[0]["Panel_ID"].ToString()),
                        PaymentModeID = rrc.PaymentModeID,
                        PaymentMode = rrc.PaymentMode,
                        CreatedDate = billData
                    };
                    int advID = adv.Insert();
                    if (advID == 0)
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In OPD Advance" });
                    }
                }
            }
            //Pyatm Payment
            Receipt PayTm = Rcdata.Where(x => x.PaymentModeID == 9 && x.PaymentMode == "PayTM").FirstOrDefault();
            JavaScriptSerializer js = new JavaScriptSerializer();
            string walletSystemTxnId = string.Empty;
            string PaytmPosID = string.Empty;
            string PaytmOrderID = string.Empty;
            string PaytmAmount = "0";
            string PaytmMobile = string.Empty;
            string PaytmOtp = string.Empty;
            if (Rcdata.Any(item => item.PaymentModeID == 9))
            {
                PaytmAmount = Util.GetString(PayTm.Amount);
                PaytmMobile = Util.GetString(PayTm.PayTmMobile);
                PaytmOtp = Util.GetString(PayTm.PayTmOtp);
                PaytmOrderID = Util.GetString(Guid.NewGuid().ToString());
                PaytmPosID = Util.GetString(LedgerTransactionNo);
                if (Resources.Resource.PayTM == "1" && PayTm.PaymentModeID == 9 && PayTm.PaymentMode == "PayTM")
                {
                    var response = js.Deserialize<PaymentResponse>(PaymentGateway.withdrawal(PaytmMobile, PaytmOtp, PaytmPosID, "Payment", PaytmAmount, PaytmOrderID));
                    if (response.status == "SUCCESS" && response.statusCode == "SUCCESS" && response.statusMessage == "SUCCESS")
                    {
                        walletSystemTxnId = response.response.walletSystemTxnId;
                    }
                    if (response.status != "SUCCESS" && response.statusCode != "SUCCESS" && response.statusMessage != "SUCCESS")
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(response.statusMessage) });
                    }
                }
            }
            if (PatientData.isCapTure == "1")
            {
                try
                {
                    DateTime patientEnrolledDate = DateTime.Now;
                    patientEnrolledDate = Util.GetDateTime(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT pm.dtEntry FROM  patient_master pm  WHERE pm.Patient_ID=@Patient_ID",
                       new MySqlParameter("@Patient_ID", PatientData.Patient_ID)));

                    var directoryPath = new DirectoryInfo(string.Concat(Resources.Resource.DocumentPath, "\\PatientPhoto\\", patientEnrolledDate.Year.ToString(), "\\", patientEnrolledDate.Month.ToString()));

                    if (directoryPath.Exists == false)
                        directoryPath.Create();

                    string filePath = Path.Combine(directoryPath.ToString(), PatientID.Replace("/", "_"), ".jpg");
                    if (File.Exists(filePath))
                        File.Delete(filePath);

                    string strImage = PatientData.base64PatientProfilePic.Replace(PatientData.base64PatientProfilePic.Split(',')[0] + ",", string.Empty);
                    File.WriteAllBytes(filePath, Convert.FromBase64String(strImage));
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Error on Patient Image Upload" });
                }
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = "true", LabID = Common.Encrypt(Util.GetString(ReceiptNo)) });
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
using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Text;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Linq;
public partial class Design_FrontOffice_OPDCONSULTATION : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(Resources.Resource.OPDHomeCollection=="0")
            Response.Redirect("../UnAuthorized.aspx");
        llheader.Text = "OPD CONSULTATION";
        if (!IsPostBack)
        {
            StockReports.ExecuteDML("Delete from TempAppTime where EmployeeID='" + UserInfo.ID + "'");
            txttokenno.Focus();
            bindTitle();
            bindAccessCentre();
            txtAppDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindDepartment();
            txtUniqueHash.Text = Util.getHash();
            BindPatientType();
            bindvisittype();

        }     
    }
    public void BindPatientType()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT panelGroupID,PanelGroup FROM `f_panelgroup` WHERE Active=1 ORDER BY panelGroupID ").Tables[0])
            {
                ddlPatientType.DataSource = dt;
                ddlPatientType.DataValueField = "panelGroupID";
                ddlPatientType.DataTextField = "PanelGroup";
                ddlPatientType.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    protected void bindvisittype()
    {
        ddlCategory.DataSource = DoctorReg.LoadSubCategoryByCategory(DoctorReg.LoadCategoryByConfigRelationID("5"));
        ddlCategory.DataTextField = "Name";
        ddlCategory.DataValueField = "SubCategoryID";
        ddlCategory.DataBind();


       // ddlCategory.Items.Insert(0, new ListItem("Select", "0"));
    }
    protected void BindDepartment()
    {
        ddldept.DataSource = StockReports.GetDataTable("select distinct Department from doctor_hospital order by Department");
        ddldept.DataTextField = "Department";
        ddldept.DataValueField = "Department";
        ddldept.DataBind();
        ddldept.Items.Insert(0, new ListItem("Select", "0"));
    }
    [WebMethod]
    public static string bindDoctorlist(string DepartmentID, string Centreid)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select distinct dm.Name,dm.Doctor_ID,dh.Department from doctor_hospital dh  ");
            sb.Append(" inner join doctor_master dm on dm.Doctor_ID = dh.Doctor_ID  INNER JOIN  `centre_master`  cm  ON cm.`CentreID`=dm.`CentreId`  ");
            sb.Append(" where  dm.IsActive=1 ");
          //  if (Centreid != "0")
           // {
                sb.Append(" AND dm.`CentreId`=@Centreid  ");
          //  }
            if (DepartmentID != "0")
            {
                sb.Append(" AND dh.Department =@Department ");
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Department",DepartmentID),
               new MySqlParameter("@Centreid", Centreid)).Tables[0])
            {
                return Util.getJson(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string getapptime(string DoctorID,string AppDate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dttime = new DataTable();
            dttime.Columns.Add("Timeslot");

            DateTime dt3 = DateTime.Parse(AppDate);
            string str = "select * from doctor_hospital where Doctor_ID = @Doctor_ID AND Day = @Day";
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str,
                new MySqlParameter("@Doctor_ID", DoctorID),
                new MySqlParameter("@Day", dt3.DayOfWeek.ToString())).Tables[0];
            if (dt.Rows.Count == 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "No schedule for the selected doctor" });
            }
            if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM doctor_holiday WHERE doctorid=@DoctorID AND date(dateofholiday) =@dateofholiday ",
                new MySqlParameter("@DoctorID", DoctorID),
                new MySqlParameter("@dateofholiday", Util.GetDateTime(AppDate.Trim()).ToString("yyyy-MM-dd")))) > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Doctor is on Holiday..!" });
            }

            string str5 = "select Appointment_Time from appointment where  Doctor_ID = @Doctor_ID and date(Date) =@Appdate and flag<>3 ";
            DataTable dt5 = MySqlHelper.ExecuteDataset(con, CommandType.Text, str5,
                new MySqlParameter("@Doctor_ID", DoctorID),
                new MySqlParameter("@Appdate", Util.GetDateTime(AppDate.Trim()).ToString("yyyy-MM-dd"))).Tables[0];

            if (dt != null)
            {
                int index = 0;
                foreach (DataRow dr in dt.Rows)
                {
                    DateTime starttime = DateTime.Parse(dr["StartTime"].ToString());
                    DateTime endtime = DateTime.Parse(dr["EndTime"].ToString());
                    int avgtime = Convert.ToInt32(dr["AvgTime"].ToString());
                    TimeSpan span = endtime.Subtract(starttime);

                    int total_min = Util.GetInt(span.TotalMinutes);

                    int noslots = total_min / avgtime;
                    int add = 0;
                    for (int i = 0; i < noslots; i++)
                    {

                        DateTime c1 = Convert.ToDateTime(DateTime.Now.ToShortTimeString().Trim());
                        DateTime c2 = Convert.ToDateTime((Util.GetDateTime((starttime.AddMinutes(add)).ToShortTimeString()).ToString("HH:mm:ss")));
                        int c = c1.CompareTo(c2);
                        if (c < 0)
                        {
                            DataRow drt = dttime.NewRow();
                            drt["Timeslot"] = (starttime.AddMinutes(add)).ToShortTimeString();
                            dttime.Rows.Add(drt);
                        }

                        if (dt5 != null)
                        {
                            foreach (DataRow dr5 in dt5.Rows)
                            {
                                if ((Util.GetDateTime((starttime.AddMinutes(add)).ToShortTimeString()).ToString("HH:mm:ss") == dr5["Appointment_Time"].ToString()))
                                {
                                    foreach (DataRow drd in dttime.Rows)
                                    {
                                        if (drd["Timeslot"].ToString() == dr5["Appointment_Time"].ToString())
                                            drd.Delete();
                                    }
                                }
                            }
                        }
                        index = index + 1;
                        add += avgtime;
                    }
                }
            }
            if (dttime.Rows.Count == 0)
                return JsonConvert.SerializeObject(new { status = false, response = "Timeslot is End at this time" });
            else
                return JsonConvert.SerializeObject(new { status = true, response = dttime });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = ex.ToString() });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string AddItem(string Type_ID, string PatientID, string subcategoryid, string AppDate, string Apptime)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            DataTable dtdetail = StockReports.GetDataTable("Select DoctorID,TempAppDate,TempAppTime,EmployeeID from TempAppTime where EmployeeID='" + UserInfo.ID + "' and TempAppDate='" + AppDate + "' and TempAppTime='" + Apptime + "'");
            if (dtdetail.Rows.Count > 0)
            {
                if (Util.GetString(dtdetail.Rows[0]["TempAppTime"]) == Apptime)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Doctor already added in this App Time..!" });
                }
            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" Select ");
            if (PatientID != "")
            {
                string days = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT DATEDIFF(CURRENT_DATE(),dtEntry) FROM patient_master WHERE patient_id=@PatientID",
                    new MySqlParameter("@PatientID", PatientID)));

                if (Util.GetInt(days) <= 180 && days != "")
                {
                    sb.Append(" rl.Rate, ");
                }
                else
                {
                    sb.Append(" rl.Rate, ");
                }
            }

            else
            {
                sb.Append(" rl.Rate, ");
            }
            sb.Append(" RL.RateListID,im.itemid,IM.TypeName Item,RL.Panel_ID,IM.Type_ID,IM.SubCategoryID,scm.Name ");
            sb.Append(" from f_itemmaster im inner join f_ratelist rl on im.itemid = rl.itemid ");
            sb.Append(" INNER JOIN f_subcategorymaster scm on scm.SubCategoryID=im.SubCategoryID ");
            sb.Append(" where  im.type_id=@Type_ID and rl.panel_id=@PanelID and rl.iscurrent=1");
            if (subcategoryid != "0")
                sb.Append(" and im.subcategoryid=@subcategoryid ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Type_ID", Type_ID),
                new MySqlParameter("@PanelID", 78),
                new MySqlParameter("@subcategoryid", subcategoryid)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {

                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO TempAppTime(DoctorID,TempAppDate,TempAppTime,EmployeeID) ");
                    sb.Append(" VALUES(@DoctorID,@TempAppDate,@TempAppTime,@EmployeeID)");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                                                new MySqlParameter("@DoctorID", Type_ID),
                                                new MySqlParameter("@TempAppDate", AppDate),
                                                new MySqlParameter("@TempAppTime", Apptime),
                                                new MySqlParameter("@EmployeeID", UserInfo.ID));

                    return JsonConvert.SerializeObject(new { status = true, response = dt });
                }
                else
                    return JsonConvert.SerializeObject(new { status = false, response = "Please enter Rate of Doctor..!" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string SaveNewRegistration(object PatientData, Ledger_Transaction LTData, List<Patient_Lab_InvestigationOPD> PLO, List<Receipt> Rcdata)
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
        (from PLOData in PLO
         select PLOData).ToList().ForEach((PLOData) =>
         {
             PLOData.Rate = Util.GetDecimal(PLOData.Rate);
             PLOData.Amount = Util.GetDecimal(PLOData.Amount) * PLOData.Quantity;
             PLOData.DiscountAmt = Util.GetDecimal(PLOData.DiscountAmt);
             PLOData.MRP = Util.GetDecimal(PLOData.MRP);
         });

        sbyte isItemWiseDisc = 0; decimal totalDiscAmt = 0;
        if (PLO.Select(x => x.DiscountAmt).Sum() > 0)
        {
            isItemWiseDisc = 1;

        }
        decimal getTotalRate = PLO.Sum(x => Util.GetDecimal(x.Rate));

        if (isItemWiseDisc == 0)
        {
            foreach (Patient_Lab_InvestigationOPD objPlo in PLO)
            {
                decimal discountAmt = 0;
                var discper = Math.Round((Util.GetDecimal(LTData.DiscountOnTotal) * 100) / Util.GetDecimal(getTotalRate), 2, MidpointRounding.AwayFromZero);
                if (PLO.Last().ItemId == objPlo.ItemId)
                {
                    discountAmt = Math.Round(Util.GetDecimal(LTData.DiscountOnTotal) - Util.GetDecimal(totalDiscAmt), 0, MidpointRounding.AwayFromZero);
                }
                else
                {
                    discountAmt = Math.Round(Util.GetDecimal((Util.GetDecimal(objPlo.Rate) * Util.GetDecimal(discper)) / 100), 0, MidpointRounding.AwayFromZero);
                    totalDiscAmt += discountAmt;
                }

                (from PLOData in PLO
                 select PLOData).Where(s => s.ItemId == objPlo.ItemId).ToList().ForEach((PLOData) =>
                 {
                     PLOData.Amount = Util.GetDecimal((objPlo.Rate * objPlo.Quantity) - discountAmt);
                     PLOData.DiscountAmt = Util.GetDecimal(discountAmt);
                 });
            }
        }

        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            List<Patient_Master> PatientDetail = new JavaScriptSerializer().ConvertToType<List<Patient_Master>>(PatientData);

            int CreatedByID = UserInfo.ID;
            string CreatedBy = UserInfo.LoginName;

        
          
            string PatientID = string.Empty;
            int LedgerTransactionID = 0;
            string LedgerTransactionNo = string.Empty;
            string AppointmentID = "";
            if (PatientDetail[0].Patient_ID == string.Empty)
            {
                Patient_Master objPM = new Patient_Master(tnx)
                {
                    Title =  PatientDetail[0].Title,
                    PName =  PatientDetail[0].PName.ToUpper(),
                    House_No = PatientDetail[0].House_No,
                    Street_Name = PatientDetail[0].Street_Name,
                    Pincode = PatientDetail[0].Pincode,
                    Country = PatientDetail[0].Country,
                    State = PatientDetail[0].State,
                    City = PatientDetail[0].City,
                    Locality = PatientDetail[0].Locality,
                    CountryID = PatientDetail[0].CountryID,
                    StateID = PatientDetail[0].StateID,
                    CityID = PatientDetail[0].CityID,
                    LocalityID = PatientDetail[0].LocalityID,
                    Phone = PatientDetail[0].Phone,
                    Mobile =  PatientDetail[0].Mobile,
                    Email =  PatientDetail[0].Email,
                    DOB = PatientDetail[0].DOB,
                    Age = PatientDetail[0].Age,
                    AgeYear = PatientDetail[0].AgeYear,
                    AgeMonth = PatientDetail[0].AgeMonth,
                    AgeDays = PatientDetail[0].AgeDays,
                    TotalAgeInDays = PatientDetail[0].TotalAgeInDays,
                    Gender = PatientDetail[0].Gender,
                    CentreID = PatientDetail[0].CentreID,
                    IsOnlineFilterData = PatientDetail[0].IsOnlineFilterData,
                    IsDuplicate = PatientDetail[0].IsDuplicate,
                    IsDOBActual = PatientDetail[0].IsDOBActual,
                    ClinicalHistory = PatientDetail[0].ClinicalHistory,
                    VIP = PatientDetail[0].VIP
                };
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
                PatientID = PatientDetail[0].Patient_ID;
                sb = new StringBuilder();
                sb.Append("  UPDATE patient_master ");
                sb.Append(" SET  ");
                sb.Append(" Email = @Email,Age = @Age,AgeYear =@AgeYear,CountryID=@CountryID, StateID =@StateID,CityID =@CityID,localityID =@localityID,");
                sb.Append(" Country=@Country,State =@State,City = @City,Locality =@Locality,AgeMonth =@AgeMonth, AgeDays =@AgeDays,TotalAgeInDays =@TotalAgeInDays,dob=@DOB,");
                sb.Append(" UpdateID =@UpdateID,IsDOBActual =@IsDOBActual,UpdateName =@UpdateName,UpdateDate = NOW(),ClinicalHistory=@ClinicalHistory,Vip=@Vip ");
                sb.Append(" WHERE Patient_ID =@Patient_ID;");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@Email", PatientDetail[0].Email),
                                            new MySqlParameter("@Age", PatientDetail[0].Age),
                                            new MySqlParameter("@AgeYear", PatientDetail[0].AgeYear),
                                            new MySqlParameter("@CountryID", PatientDetail[0].CountryID),
                                            new MySqlParameter("@StateID", PatientDetail[0].StateID),
                                            new MySqlParameter("@CityID", PatientDetail[0].CityID),
                                            new MySqlParameter("@localityID", PatientDetail[0].LocalityID),
                                            new MySqlParameter("@Country", PatientDetail[0].Country),
                                            new MySqlParameter("@State", PatientDetail[0].State),
                                            new MySqlParameter("@City", PatientDetail[0].City),
                                            new MySqlParameter("@Locality", PatientDetail[0].Locality),
                                            new MySqlParameter("@AgeMonth", PatientDetail[0].AgeMonth),
                                            new MySqlParameter("@AgeDays", PatientDetail[0].AgeDays),
                                            new MySqlParameter("@TotalAgeInDays", PatientDetail[0].TotalAgeInDays),
                                            new MySqlParameter("@DOB", Util.GetDateTime(PatientDetail[0].DOB).ToString("yyyy-MM-dd")),
                                            new MySqlParameter("@UpdateID", UserInfo.ID),
                                            new MySqlParameter("@IsDOBActual", PatientDetail[0].IsDOBActual),
                                            new MySqlParameter("@UpdateName", CreatedBy),
                                            new MySqlParameter("@Patient_ID", PatientDetail[0].Patient_ID),
                                            new MySqlParameter("@ClinicalHistory", PatientDetail[0].ClinicalHistory),
                                            new MySqlParameter("@Vip", PatientDetail[0].VIP));
                ReVisit = 1;
            }

            if (PatientID == string.Empty)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Patient Master Error" });
            }
            string EmployeeList = string.Empty;
            int SalesManager = 0;
           
            DateTime billData = DateTime.Now;
            Ledger_Transaction objlt = new Ledger_Transaction(tnx)
            {
                DiscountOnTotal = LTData.DiscountOnTotal,
                NetAmount = PLO.Select(x => x.Amount).Sum(),
                GrossAmount = PLO.Select(x => x.Rate * x.Quantity).Sum(),
                //isMask = LTData.isMask,
                IsCredit = LTData.IsCredit,
                Patient_ID = PatientID,
                Age = PatientDetail[0].Age,
                Gender = PatientDetail[0].Gender,
                VIP = LTData.VIP,
                Panel_ID = LTData.Panel_ID,
                PanelName = LTData.PanelName,
                Doctor_ID = LTData.Doctor_ID,
                DoctorName = LTData.DoctorName,
                //OtherReferLabID = LTData.OtherReferLabID,
                CentreID = LTData.CentreID,
                Adjustment = Util.GetDecimal(LTData.Adjustment + LTData.Currency_RoundOff),
                CreatedByID = CreatedByID,
                //HomeVisitBoyID = LTData.HomeVisitBoyID,
                //PatientIDProof = LTData.PatientIDProof,
                //PatientIDProofNo = LTData.PatientIDProofNo,
                //PatientSource = LTData.PatientSource,
                //PatientType = LTData.PatientType,
                //VisitType = LTData.VisitType,
                //HLMPatientType = LTData.HLMPatientType,
                //HLMOPDIPDNo = LTData.HLMOPDIPDNo,
                //DiscountApprovedByID = LTData.DiscountApprovedByID,
                //DiscountApprovedByName = LTData.DiscountApprovedByName,
                //CorporateIDCard = LTData.CorporateIDCard,
                //CorporateIDType = LTData.CorporateIDType,
                //AttachedFileName = LTData.AttachedFileName,
                ReVisit = ReVisit,
                CreatedBy = CreatedBy,
                //DiscountID = LTData.DiscountID,
                //OtherLabRefNo = LTData.OtherLabRefNo,
                //WorkOrderID = LTData.WorkOrderID,
                //PreBookingID = LTData.PreBookingID,
                //Doctor_ID_Temp = LTData.Doctor_ID_Temp,
                //IsDiscountApproved = LTData.IsDiscountApproved,
                //CashOutstanding = LTData.CashOutstanding,
                //OutstandingEmployeeId = LTData.OutstandingEmployeeId,
                //BarCodePrintedType = LTData.BarCodePrintedType,
                //BarCodePrintedCentreType = LTData.BarCodePrintedCentreType,
                //BarCodePrintedHomeColectionType = LTData.BarCodePrintedHomeColectionType,
                //setOfBarCode = LTData.setOfBarCode,
                //SampleCollectionOnReg = LTData.SampleCollectionOnReg,
                //InvoiceToPanelId = LTData.InvoiceToPanelId,
                //PatientGovtType = LTData.PatientGovtType,
                //CardHolderRelation = LTData.CardHolderRelation,
                //CardHolderName = LTData.CardHolderName.ToUpper(),
                //TempSecondRef = LTData.TempSecondRef,
                //SecondReferenceID = LTData.SecondReferenceID,
                //SecondReference = LTData.SecondReference,
                BillDate = billData,
                SalesTagEmployee = SalesManager,
                PName =  string.Concat(PatientDetail[0].Title, PatientDetail[0].PName.ToUpper()),
                //Currency_RoundOff = LTData.Currency_RoundOff,
                //MemberShipCardNo = LTData.MemberShipCardNo,
                //MembershipCardID = LTData.MembershipCardID,
                //IsSelfPatient = LTData.IsSelfPatient,
                //AppointmentID = LTData.AppointmentID,
                //HomeCollectionAppID = LTData.HomeCollectionAppID
                IsOPDConsultation=1,
                OPDConsultationTokenNo = LTData.OPDConsultationTokenNo
            };
            string retvalue = objlt.Insert();
            if (retvalue == string.Empty)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "LT Error" });
            }
            LedgerTransactionID = Util.GetInt(retvalue.Split('#')[0]);
            LedgerTransactionNo = retvalue.Split('#')[1];


            sb = new StringBuilder();
            sb.Append(" INSERT INTO f_ledgertransaction_Sales(LedgerTransactionID,LedgerTransactionNo,Sales,CreatedDate) ");
            sb.Append(" VALUES(@LedgerTransactionID,@LedgerTransactionNo,@Sales,@CreatedDate)");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                        new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                                        new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                                        new MySqlParameter("@Sales", EmployeeList),
                                        new MySqlParameter("@CreatedDate", billData));

            string Barcode = string.Empty;
            byte barcodePreprinted = 0;
            int DepartmentTokenNo = 0;
            List<DepartmentTokenNoDetail> DepartmentTokenNoDetail = new List<DepartmentTokenNoDetail>();
            string BillNo = AllLoad_Data.getBillNo(LTData.CentreID, "B", con, tnx);
            if (BillNo == string.Empty)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "BillNo Error" });
            }

            if (LTData.DiscountOnTotal > 0)
            {
                string DiscountReason = LTData.DiscountReason;
                if (LTData.MemberShipCardNo != string.Empty)
                    DiscountReason = "MemberShip Discount";
                sb = new StringBuilder();
                sb.Append(" INSERT INTO f_ledgertransaction_DiscountReason(LedgerTransactionID,LedgerTransactionNo,DiscountReason,CreatedByID,CreatedBy,BillNo,CreatedDate) ");
                sb.Append(" VALUES(@LedgerTransactionID,@LedgerTransactionNo,@DiscountReason,@CreatedByID,@CreatedBy,@BillNo,@CreatedDate)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                                            new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                                            new MySqlParameter("@DiscountReason", LTData.DiscountReason),
                                            new MySqlParameter("@CreatedByID", CreatedByID),
                                            new MySqlParameter("@CreatedBy", CreatedBy),
                                            new MySqlParameter("@BillNo", BillNo),
                                            new MySqlParameter("@CreatedDate", billData));
            }

            string BillType = "Credit-Test Add";
            foreach (Patient_Lab_InvestigationOPD plo in PLO)
            {

                string sampleType = string.Empty;
                sampleType = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT CONCAt(ist.`SampleTypeID`,'#',ist.SampleTypeName) FROM `investigations_sampletype` ist where `Investigation_Id`=@Investigation_Id AND ist.`IsDefault`=1 ",
                                                                      new MySqlParameter("@Investigation_Id", plo.Investigation_ID)));

             
                string PackName = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IF(im.`SubCategoryID`=15,IF(IFNULL(im.`Inv_ShortName`,'')='',im.`TypeName`,im.`Inv_ShortName`),'')PackName  FROM f_itemmaster im WHERE im.itemid=@ItemId ",
                                                                           new MySqlParameter("@ItemId", plo.ItemId)));
                Patient_Lab_InvestigationOPD objPlo = new Patient_Lab_InvestigationOPD(tnx);
                objPlo.LedgerTransactionID = LedgerTransactionID;
                objPlo.LedgerTransactionNo = LedgerTransactionNo;
                objPlo.Patient_ID = PatientID;
                objPlo.AgeInDays = PatientDetail[0].TotalAgeInDays;
                objPlo.Gender = PatientDetail[0].Gender;
              
                objPlo.BarcodeNo = "SNR";
                objPlo.ItemId = plo.ItemId;
                objPlo.ItemCode = plo.ItemCode.ToUpper();
                objPlo.ItemName = plo.ItemName.ToUpper();
                objPlo.PackageName = PackName.ToUpper();
                objPlo.PackageCode = plo.PackageCode;
                objPlo.Investigation_ID = plo.Investigation_ID;
                objPlo.IsPackage = plo.IsPackage;
                objPlo.SubCategoryID = plo.SubCategoryID;
                objPlo.Rate = plo.Rate;
                objPlo.DiscountAmt = plo.DiscountAmt;
                objPlo.Amount = plo.Amount;

                objPlo.DiscountByLab = plo.DiscountByLab;
                objPlo.CouponAmt = plo.CouponAmt;
                objPlo.PayByPanel = plo.PayByPanel;
                objPlo.PayByPanelPercentage = plo.PayByPanelPercentage;
                objPlo.PayByPatient = plo.PayByPatient;
                objPlo.Quantity = plo.Quantity;
                objPlo.IsRefund = 0;
                objPlo.IsReporting = plo.IsReporting;
                objPlo.ReportType = plo.ReportType;
                objPlo.CentreID = plo.CentreID;
                objPlo.TestCentreID = plo.TestCentreID;
                objPlo.IsSampleCollected = plo.IsSampleCollected;
                objPlo.barcodePreprinted = barcodePreprinted;
                try
                {
                    
                        objPlo.SampleTypeID = Util.GetInt(sampleType.Split('#')[0]);
                        objPlo.SampleTypeName = sampleType.Split('#')[1];
                    
                }
                catch
                {
                    objPlo.IsSampleCollected = plo.IsSampleCollected;
                }
               
                    objPlo.SampleCollector = CreatedBy;
                    objPlo.SampleCollectionBy = CreatedByID;
                    
                objPlo.SampleCollectionDate = Util.GetDateTime(plo.SampleCollectionDate);
                    
                objPlo.SampleBySelf = plo.SampleBySelf;
                objPlo.isUrgent = plo.isUrgent;
                objPlo.DeliveryDate = plo.DeliveryDate;
                objPlo.SRADate = plo.SRADate;

                objPlo.IsScheduleRate = plo.IsScheduleRate;
                objPlo.MRP = plo.MRP == 0 ? plo.Rate : plo.MRP;
                objPlo.Date = billData;
                objPlo.PanelItemCode = plo.PanelItemCode;
                objPlo.BillNo = BillNo;
                objPlo.BillType = string.Empty;
                objPlo.IsActive = 1;
                objPlo.CreatedBy = CreatedBy;
                objPlo.CreatedByID = CreatedByID;
                objPlo.BaseCurrencyRound = Util.GetByte(Resources.Resource.BaseCurrencyRound);
                objPlo.BillType = BillType;
                objPlo.IsSampleCollectedByPatient = plo.IsSampleCollectedByPatient;
                objPlo.DepartmentTokenNo = DepartmentTokenNo;

                objPlo.IsMemberShipFreeTest = plo.IsMemberShipFreeTest;
                objPlo.MemberShipDisc = plo.MemberShipDisc;
                objPlo.MemberShipTableID = plo.MemberShipTableID;
                objPlo.IsMemberShipDisc = plo.IsMemberShipDisc;
                objPlo.SubCategoryName = plo.SubCategoryName;
                string ID = objPlo.Insert();

                if (ID == string.Empty)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "PLO Error" });
                }
               
               

                if (LTData.Remarks != string.Empty)
                {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO patient_labinvestigation_opd_remarks  ");
                    sb.Append("  (`UserID`,`UserName`,`Test_ID`,`Remarks`,`LedgerTransactionNo`,`ShowOnline`,DATE,LedgerTransactionID) ");
                    sb.Append("  VALUES (@UserID,@UserName,@Test_ID,@Remarks,@LedgerTransactionNo,1,@DATE,@LedgerTransactionID)");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                new MySqlParameter("@UserID", CreatedByID),
                                                new MySqlParameter("@UserName", CreatedBy),
                                                new MySqlParameter("@Test_ID", ID),
                                                new MySqlParameter("@Remarks", LTData.Remarks.Replace("'", string.Empty)),
                                                new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                                                new MySqlParameter("@DATE", billData),
                                                new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
                }
                if (plo.IsPackage == 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode,@LedgerTransactionID) ",
                                                new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                                                new MySqlParameter("@SinNo", objPlo.BarcodeNo),
                                                new MySqlParameter("@Test_ID", ID),
                                                new MySqlParameter("@Status", string.Format("Registration Done ({0})", plo.ItemName.ToUpper())),
                                                new MySqlParameter("@UserID", CreatedByID),
                                                new MySqlParameter("@UserName", CreatedBy),
                                                new MySqlParameter("@IpAddress", StockReports.getip()),
                                                new MySqlParameter("@CentreID", LTData.CentreID),
                                                new MySqlParameter("@RoleID", UserInfo.RoleID),
                                                new MySqlParameter("@dtEntry", billData),
                                                new MySqlParameter("@DispatchCode", string.Empty),
                                                new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
                   
                }
             //   Appointment Insert
                try
                {
                    appointment objappointment = new appointment(tnx);

                    objappointment.Hospital_ID = "HOS/070920/00001";
                    objappointment.Patient_ID = PatientID;
                    objappointment.Title = PatientDetail[0].Title;
                    objappointment.Pname = PatientDetail[0].PName;
                    objappointment.Age = PatientDetail[0].Age;
                    objappointment.DOB = Util.GetDateTime(PatientDetail[0].DOB.ToString("yyyy-MM-dd"));
                    objappointment.Temp_Patient_Flag = 1;
                    objappointment.Time = System.DateTime.Now;
                    objappointment.Date = Util.GetDateTime(plo.SampleCollectionDate);
                    objappointment.flag = 0;
                    objappointment.Transaction_ID = BillNo;
                    objappointment.AppNo = LTData.OPDConsultationTokenNo;
                    objappointment.LedgerTransactionNo = LedgerTransactionNo;


                    objappointment.Doctor_ID =Util.GetString(plo.Investigation_ID);
                    objappointment.AptTime = plo.SRADate;
                    AppointmentID = objappointment.Insert();
                    
                }
                catch (Exception ex)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Appointment Error" });
                }

                string NewAge = "";
                if (PatientDetail[0].AgeYear > 0 && PatientDetail[0].AgeMonth > 0)
                {
                    NewAge = PatientDetail[0].AgeYear + "." + PatientDetail[0].AgeMonth + " YRS";
                }
                else if (PatientDetail[0].AgeYear == 0 && PatientDetail[0].AgeMonth > 0)
                {
                    NewAge = PatientDetail[0].AgeMonth + " MONTH(S)";
                }
                else if (PatientDetail[0].AgeYear == 0 && PatientDetail[0].AgeMonth == 0)
                {
                    NewAge = PatientDetail[0].AgeDays + " DAYS";
                }
                else
                {
                    NewAge = PatientDetail[0].AgeYear + " YRS";
                }
                
                
                sb = new StringBuilder();
                sb.Append(" INSERT INTO doctor_integration.appointment_interface  ");
                sb.Append("  (AppID,LedgerTnxNo,AppNo,PatientID,Pname,Age,Sex,DoctorID,DName,AppointmentDate,AppointmentTime,ContactNo,VisitType,TransactionID,PanelID,PanelName,AmountPaid,Naration) ");
                sb.Append("  VALUES (@AppID,@LedgerTnxNo,@AppNo,@PatientID,@Pname,@Age,@Sex,@DoctorID,@DName,@AppointmentDate,@AppointmentTime,@ContactNo,@VisitType,@TransactionID,@PanelID,@PanelName,@AmountPaid,@Naration)");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@AppID", AppointmentID), new MySqlParameter("@LedgerTnxNo", LedgerTransactionNo),
                                            new MySqlParameter("@AppNo", LTData.OPDConsultationTokenNo), new MySqlParameter("@PatientID", PatientID),
                                            new MySqlParameter("@Pname", PatientDetail[0].PName.ToUpper()), new MySqlParameter("@Age", NewAge),
                                            new MySqlParameter("@Sex", PatientDetail[0].Gender), new MySqlParameter("@DoctorID", Util.GetString(plo.Investigation_ID)),
                                            new MySqlParameter("@DName", plo.ItemName.ToUpper()), new MySqlParameter("@AppointmentDate", Util.GetDateTime(plo.SampleCollectionDate)),
                                            new MySqlParameter("@AppointmentTime", plo.SRADate),new MySqlParameter("@ContactNo", PatientDetail[0].Mobile),
                                            new MySqlParameter("@VisitType", "New"),new MySqlParameter("@TransactionID", LedgerTransactionID),
                                            new MySqlParameter("@PanelID",  LTData.Panel_ID),new MySqlParameter("@PanelName", LTData.PanelName),
                                            new MySqlParameter("@AmountPaid", LTData.Adjustment),new MySqlParameter("@Naration", ""));

            }
            if (objlt.Adjustment > 0)
            {
                foreach (Receipt rrc in Rcdata)
                {
                    Receipt objRC = new Receipt(tnx)
                    {
                        LedgerNoCr = "OPD003",
                        LedgerTransactionID = LedgerTransactionID,
                        LedgerTransactionNo = LedgerTransactionNo,
                        CreatedByID = CreatedByID,
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
                        CentreID = rrc.CentreID,
                        Panel_ID = LTData.Panel_ID,
                        CreatedDate = billData,
                        S_Amount = rrc.S_Amount,
                        S_CountryID = rrc.S_CountryID,
                        S_Currency = rrc.S_Currency,
                        S_Notation = rrc.S_Notation,
                        C_Factor = rrc.C_Factor,
                        Currency_RoundOff = rrc.Currency_RoundOff,
                        CurrencyRoundDigit = rrc.CurrencyRoundDigit,
                        CreatedBy = CreatedBy,
                        Converson_ID = rrc.Converson_ID,
                       // Appointment_ID = AppointmentID
                    };
                    string ReceiptNo = objRC.Insert();
                    if (ReceiptNo == string.Empty)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "Receipt Error" });
                    }

                    var patientAdvancePaymentMode = Rcdata.Where(p => p.PaymentModeID == 9).ToList();
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
                                        Panel_ID = LTData.Panel_ID,
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
            sb.Append(" SELECT lm.`LabObservation_ID`,lm.`Name`,plo.`ItemName` FROM `patient_labinvestigation_opd` plo ");
            sb.Append(" INNER JOIN `labobservation_investigation` li ON li.`Investigation_Id`=plo.`Investigation_ID` ");
            sb.Append(" INNER JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=li.`labObservation_ID` ");
            sb.Append(" WHERE AllowDuplicateBooking=0 AND `LedgerTransactionID`>0 AND  plo.`LedgerTransactionID`=@LedgerTransactionID ");
            sb.Append(" GROUP BY lm.`LabObservation_ID` HAVING COUNT(*) >1  ");
            using (DataTable dtDuplicate = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)).Tables[0])
            {
                if (dtDuplicate.Rows.Count > 0)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = string.Concat(dtDuplicate.Rows[0]["Name"].ToString(), " Found duplicate in ", dtDuplicate.Rows[0]["ItemName"].ToString()) });
                }
            }

            using (DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT ID,(AdvanceAmount-IFNULL(BalanceAmount,0))RemAmt,ReceiptNo FROM OPD_Advance WHERE Panel_ID =@Panel_ID  AND IsCancel=0 AND (AdvanceAmount-IFNULL(BalanceAmount,0))>0 AND AdvanceType='Client' ORDER BY ID+0",
                                                             new MySqlParameter("@Panel_ID", LTData.Panel_ID)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {

                    decimal advanceAmount = LTData.NetAmount;
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
                            ReceiptNo = string.Empty,
                            CentreID = LTData.CentreID,
                            Panel_ID = LTData.Panel_ID,
                            CreatedBy = CreatedBy,
                            CreatedByID = CreatedByID,
                            AdvanceID = Util.GetInt(dt.Rows[s]["ID"].ToString()),
                            ReceiptNoAgainst = dt.Rows[s]["ReceiptNo"].ToString(),
                            AdvanceType = "Client"
                        };

                        adv.Insert();
                        if (advanceAmount == 0)
                            break;
                    }
                   
                }
                else
                {
                    
                }
            }
            tnx.Commit();

            StockReports.ExecuteDML("Delete from TempAppTime where EmployeeID='" + UserInfo.ID + "'");

            return JsonConvert.SerializeObject(new { status = "true", LabID = Common.Encrypt(Util.GetString(LedgerTransactionID)), No = LedgerTransactionNo });
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
    private void bindAccessCentre()
    {
        DataTable dt = AllLoad_Data.getCentreByLogin();
        ddlCentreAccess.DataSource = dt;
        ddlCentreAccess.DataTextField = "Centre";
        ddlCentreAccess.DataValueField = "CentreID";
        ddlCentreAccess.DataBind();
        ddlCentreAccess.Items.Insert(0, new ListItem("--Select Centre--", "0"));
        string da = DateTime.Now.ToString("yyyy-MM-dd hh:hh:hh");
    }
    private void bindTitle()
    {
        cmbTitle.DataSource = AllGlobalFunction.NameTitle;
        cmbTitle.DataBind();

    }
    [WebMethod]
    public static string getappointmentno(string DoctorID, string AppDate)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int a = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM appointment WHERE doctor_id=@doctor_id AND DATE(DATE)=@aptdate and flag<>3",
                new MySqlParameter("@doctor_id", DoctorID),
                new MySqlParameter("@aptdate", Util.GetDateTime(AppDate).ToString("yyyy-MM-dd"))));
            return JsonConvert.SerializeObject(new { status = true, response = "Appointment No : " + (a + 1) });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = true, response = ex.ToString() });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string DeleteTempDoc(string DoctorID)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Delete from TempAppTime where EmployeeID=@EmployeeID And DoctorID=@DoctorID ",
                new MySqlParameter("@DoctorID", DoctorID),
                new MySqlParameter("@EmployeeID", UserInfo.ID));
            return JsonConvert.SerializeObject(new { status = true, response = ""});
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = true, response = ex.ToString() });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    
   
   
}
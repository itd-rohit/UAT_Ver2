using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_Lab_PrescriptionOPDEditInfo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {




            if (Util.GetString(Request.QueryString["labno"]) != string.Empty)
            {
                txtLabNo.Text = Util.GetString(Common.Decrypt(Request.QueryString["labno"]));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "getdata();", true);
                ddlPNTDDocotor.DataSource = StockReports.GetDataTable("SELECT ID,NAME FROM `pndt_doctor` WHERE Active=1");
                ddlPNTDDocotor.DataValueField = "ID";
                ddlPNTDDocotor.DataTextField = "NAME";
                ddlPNTDDocotor.DataBind();
               

            }
            else
            {
                txtLabNo.Focus();
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public static string UpdatePatientInfo(Patient_Master PatientData, Ledger_Transaction LTData, OTPPatient patientOTP)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
       // string drname=
        string drname = StockReports.ExecuteScalar("SELECT dr.`Name` FROM `doctor_referal` dr  WHERE dr.`Name` LIKE '%" + LTData.DoctorName + "%' AND dr.`IsActive`=1 ");
        if (drname.ToUpper() != LTData.DoctorName.ToUpper() && LTData.DoctorName.ToUpper() != "SELF")
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Please Select Valid Dr Name" });
        }
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            if (patientOTP.OTPRequired == "1")
            {
                string otp = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT OTP FROM patient_otp WHERE UniqueID=@UniqueID and MobileNo=@MobileNo AND TIMESTAMPDIFF(MINUTE,EntryDate,NOW())<=15",
               new MySqlParameter("@UniqueID", patientOTP.OTPUniqID.ToUpper()),
               new MySqlParameter("@MobileNo", PatientData.Mobile)));
                if (otp != patientOTP.OTPVal.ToUpper())
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "OTP not verified" });
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_otp set isUsed=1 where  UniqueID=@UniqueID and MobileNo=@MobileNo AND otp=@OTP",
                    new MySqlParameter("@Title", PatientData.Title),
                    new MySqlParameter("@UniqueID", patientOTP.OTPUniqID.ToUpper()),
                    new MySqlParameter("@MobileNo", PatientData.Mobile),
                    new MySqlParameter("@OTP", patientOTP.OTPVal));

                }
            }
            #region Code For Manage Log : Code By : Abhishek, Code Date : 06-Nov-2017*
            StringBuilder sb_1 = new StringBuilder();
            sb_1.Append(" SELECT lt.LedgertransactionNo,pm.`Title`,pm.`PName` Patient,pm.`Age`,pm.`Gender`,pm.`Email`,pm.`Mobile`,pm.`House_No` Address,pm.PinCode,pm.`DOB` DateOfBirth,");
            sb_1.Append(" pm.Country,pm.State,pm.city, pm.Locality,fldm.DispatchModeName ");
            sb_1.Append(" ,lt.VIP,lt.DoctorName,");
            sb_1.Append("  lt.PatientIDProof,lt.PatientIDProofNo,lt.PatientSource,");
            sb_1.Append("  lt.HLMPatientType,lt.HLMOPDIPDNo");
            sb_1.Append(" FROM `f_ledgertransaction` lt");
            sb_1.Append(" left join f_ledgertransaction_dispatchmode fldm on fldm.LedgertransactionID=lt.LedgerTransactionID ");
            sb_1.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`");
            sb_1.Append(" WHERE lt.`LedgertransactionNo`='" + LTData.LedgerTransactionNo + "';");
            DataTable dt_LTD_1 = StockReports.GetDataTable(sb_1.ToString());
            #endregion

           

            StringBuilder sb = new StringBuilder();
            sb.Append("  UPDATE patient_master ");
            sb.Append(" SET  Title = @Title ,PName = @PName,Country=@Country, State = @State,City = @City,Locality = @Locality,");
            sb.Append(" House_No=@Address,PinCode = @PinCode, Mobile = @Mobile,Email = @Email,Age = @Age,AgeYear = @AgeY,AgeMonth = @AgeM, AgeDays = @AgeD,");
            sb.Append(" TotalAgeInDays = @TotalAge,Gender = @Gender,CountryID=@CountryID,StateID=@StateID,cityID=@CityID, LocalityID=@LocalityID,");
            sb.Append(" UpdateID =@UpdateID ,dob=@DOB,UpdateName = @UpdateName ");
            sb.Append(" WHERE Patient_ID = @PID;");


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Util.GetString(sb),
            new MySqlParameter("@Title", PatientData.Title),
            new MySqlParameter("@PName", PatientData.PName), new MySqlParameter("@Country", PatientData.Country), new MySqlParameter("@State", PatientData.State),
            new MySqlParameter("@City", PatientData.City), new MySqlParameter("@Locality", PatientData.Locality),
            new MySqlParameter("@Address", PatientData.House_No), new MySqlParameter("@PinCode", PatientData.Pincode),
            new MySqlParameter("@Mobile", PatientData.Mobile), new MySqlParameter("@Email", PatientData.Email), new MySqlParameter("@Age", PatientData.Age),
            new MySqlParameter("@AgeY", PatientData.AgeYear), new MySqlParameter("@AgeM", PatientData.AgeMonth), new MySqlParameter("@AgeD", PatientData.AgeDays),
            new MySqlParameter("@TotalAge", PatientData.TotalAgeInDays), new MySqlParameter("@Gender", PatientData.Gender),
            new MySqlParameter("@CountryID", PatientData.CountryID),
            new MySqlParameter("@StateID", PatientData.StateID), new MySqlParameter("@CityID", PatientData.CityID), new MySqlParameter("@LocalityID", PatientData.LocalityID),
            new MySqlParameter("@UpdateID", UserInfo.ID), new MySqlParameter("@UpdateName", UserInfo.LoginName), new MySqlParameter("@DOB", PatientData.DOB.ToString("yyyy-MM-dd")),
            new MySqlParameter("@PID", PatientData.Patient_ID));


            int docid =Util.GetInt(LTData.Doctor_ID);

            if (docid == 1)
            {
                LTData.DoctorName = "SELF";
            }
            else if(docid>2)
            {
                string docnameinmaster=Util.GetString( MySqlHelper.ExecuteScalar(tnx, CommandType.Text,"SELECT NAME FROM `doctor_referal` WHERE doctor_id=@doctor_id",
                    new MySqlParameter("@doctor_id",LTData.Doctor_ID)));

                if (LTData.DoctorName.ToUpper() != docnameinmaster.ToUpper())
                {
                   

                    return JsonConvert.SerializeObject(new { status = false, response = "Incorrect Doctor Name" });
                }
            }

            // Update LedgerTransaction
            sb = new StringBuilder();
            sb.Append("  UPDATE f_ledgertransaction ");
            sb.Append("  SET PureHealthID=@PureHealthID,PassPortNo=@PassPortNo,");
            sb.Append(" SRFNo=@SRFNo, Age =@Age,VIP = @VIP,Doctor_ID = @DoctorID,DoctorName = @DoctorName,");
            sb.Append("  UpdateID =@UpdateID1,UpdateName = @UpdateName1,PatientIDProof = @IDProof,");
            sb.Append("  PatientIDProofNo = @IDProofNo,PatientSource = @Source,");
            sb.Append("  HLMPatientType = @HLMPType,HLMOPDIPDNo = @HLMOPDIPDNo,PROID=@PROID, Children = @Children, Son = @Son, Daughter = @Daughter, Pregnancydate = @Pregnancydate, AgeSon = @AgeSon, AgeDaughter = @AgeDaughter, PndtDoctorId = @PndtDoctorId ");
            sb.Append("  WHERE LedgerTransactionID = @LedgerTransactionID");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Util.GetString(sb),
                 new MySqlParameter("@PassPortNo", LTData.PassPortNo),
                  new MySqlParameter("@PureHealthID", LTData.PureHealthID),
             new MySqlParameter("@SRFNo", LTData.SRFNo), new MySqlParameter("@Age", PatientData.Age), new MySqlParameter("@VIP", LTData.VIP),
             new MySqlParameter("@DoctorID", LTData.Doctor_ID), new MySqlParameter("@DoctorName", LTData.DoctorName),
             new MySqlParameter("@UpdateID1", UserInfo.ID), new MySqlParameter("@UpdateName1", UserInfo.LoginName), new MySqlParameter("@IDProof", LTData.PatientIDProof),
             new MySqlParameter("@IDProofNo", LTData.PatientIDProofNo), new MySqlParameter("@Source", LTData.PatientSource),
             new MySqlParameter("@HLMPType", LTData.HLMPatientType),
             new MySqlParameter("@HLMOPDIPDNo", LTData.HLMOPDIPDNo), new MySqlParameter("@LedgerTransactionID", LTData.LedgerTransactionID)
             , new MySqlParameter("@PROID", LTData.PROID), new MySqlParameter("@Children", LTData.Children), new MySqlParameter("@Son", LTData.Son), new MySqlParameter("@Daughter", LTData.Daughter), new MySqlParameter("@Pregnancydate", LTData.Pregnancydate), new MySqlParameter("@AgeSon", LTData.AgeSon), new MySqlParameter("@AgeDaughter", LTData.AgeDaughter), new MySqlParameter("@PndtDoctorId", LTData.PndtDoctorId));

            //Update Patient Name & Gender in LT
            sb = new StringBuilder();
            sb.Append("UPDATE f_ledgertransaction SET PName = @PName, Gender = @Gender WHERE  Patient_ID = @PatientID");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Util.GetString(sb),
           new MySqlParameter("@PName", string.Concat(PatientData.Title, ' ', PatientData.PName)), new MySqlParameter("@Gender", PatientData.Gender),
           new MySqlParameter("@PatientID", PatientData.Patient_ID));

            // Update  remarks 18may23 by Vaseem
            if (LTData.Remarks != string.Empty)
            {
                sb = new StringBuilder();
                sb.Append("UPDATE patient_labinvestigation_opd_remarks SET Remarks = @Remarks WHERE  LedgerTransactionNo = @LedgerTransactionNo ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Util.GetString(sb),
               new MySqlParameter("@Remarks", LTData.Remarks),
               new MySqlParameter("@LedgerTransactionNo", LTData.LedgerTransactionNo));
            }

            //Update Patient Age & Gender in PLO
            sb = new StringBuilder();
            sb.Append("UPDATE patient_labinvestigation_opd SET Gender = @Gender,AgeInDays=if(LedgerTransactionID=@LID,@TotalAge,AgeInDays) WHERE  Patient_ID = @PatientID");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Util.GetString(sb),
                new MySqlParameter("@Gender", PatientData.Gender), new MySqlParameter("@LID", PatientData.ID),
            new MySqlParameter("@TotalAge", PatientData.TotalAgeInDays), new MySqlParameter("@PatientID", PatientData.Patient_ID));

           

            int DispatchModeCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM f_ledgertransaction_dispatchmode WHERE LedgertransactionID=@LedgertransactionID",
                new MySqlParameter("@LedgertransactionID", LTData.LedgerTransactionID)));
            if (DispatchModeCount > 0)
            {
                sb = new StringBuilder();
                sb.Append("UPDATE f_ledgertransaction_dispatchmode SET DispatchModeName = @DispatchModeName, DispatchModeID = @DispatchModeID WHERE  LedgertransactionID = @LedgertransactionID");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@DispatchModeName", LTData.DispatchModeName), new MySqlParameter("@DispatchModeID", LTData.DispatchModeID),
               new MySqlParameter("@LedgertransactionID", LTData.LedgerTransactionID));
            }
            else
            {
                if (LTData.DispatchModeID != 0)
                {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO f_ledgertransaction_DispatchMode(DispatchModeName,DispatchModeID,LedgerTransactionID,LedgerTransactionNo,CreatedDate) ");
                    sb.Append(" VALUES(@DispatchModeName,@DispatchModeID,@LedgerTransactionID,@LedgerTransactionNo,@CreatedDate)");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                new MySqlParameter("@DispatchModeName", LTData.DispatchModeName),
                                                new MySqlParameter("@DispatchModeID", LTData.DispatchModeID),
                                                new MySqlParameter("@LedgerTransactionID", LTData.LedgerTransactionID),
                                                new MySqlParameter("@LedgerTransactionNo", LTData.LedgerTransactionNo),
                                                new MySqlParameter("@CreatedDate", DateTime.Now));

                }
            }

            #region Code For Manage Log : Code By : Abhishek, Code Date : 06-Nov-2017*
            sb_1 = new StringBuilder();
            sb_1.Append(" SELECT lt.LedgertransactionNo,pm.`Title`,pm.`PName` Patient,pm.`Age`,pm.`Gender`,pm.`Email`,pm.`Mobile`,pm.`House_No` Address,pm.PinCode,pm.`DOB` DateOfBirth,");
            sb_1.Append(" pm.Country,pm.State,pm.city, pm.Locality,fldm.DispatchModeName ");
            sb_1.Append(" ,lt.VIP,lt.DoctorName,");
            sb_1.Append("  lt.PatientIDProof,lt.PatientIDProofNo,lt.PatientSource,");
            sb_1.Append("  lt.HLMPatientType,lt.HLMOPDIPDNo");
            sb_1.Append(" FROM `f_ledgertransaction` lt");
            sb_1.Append(" left join f_ledgertransaction_dispatchmode fldm on fldm.LedgertransactionID=lt.LedgerTransactionID ");
            sb_1.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`");
            sb_1.Append(" WHERE lt.`LedgertransactionNo`='" + LTData.LedgerTransactionNo + "';");

            DataTable dt_LTD_2 = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb_1.ToString()).Tables[0];
            string strLog = "  ";
            MySqlCommand cmd = new MySqlCommand();
            for (int i = 0; i < dt_LTD_1.Columns.Count; i++)
            {
                string _ColumnName = dt_LTD_1.Columns[i].ColumnName;
                if ((Util.GetString(dt_LTD_1.Rows[0][i]) != Util.GetString(dt_LTD_2.Rows[0][i]) ))
                {
                    sb_1 = new StringBuilder();
                    sb_1.Append("  INSERT INTO `patient_labinvestigation_opd_update_status`(`LedgertransactionNo`,`Status`,UserID,UserName,dtEntry,RoleID,CentreID,IPAddress) ");
                    sb_1.Append("  values('" + LTData.LedgerTransactionNo + "','Change " + _ColumnName + " From "+  Util.GetString(dt_LTD_1.Rows[0][i]) +" To "+ Util.GetString(dt_LTD_2.Rows[0][i])+"','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["RoleID"]) + "','" + Util.GetString(UserInfo.Centre) + "','" + StockReports.getip() + "');  ");
                    cmd = new MySqlCommand(sb_1.ToString(), tnx.Connection, tnx);
                    cmd.ExecuteNonQuery();
                }

            }
          #endregion



            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Record Updated" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(ex.GetBaseException()) });
           // return Util.GetString(new { Status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {

            con.Close();
            con.Dispose();
            tnx.Dispose();
        }
    }


    [WebMethod]
    public static string SendPatientOTP(string mobileno)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string chars = "0123456789";
            char[] stringChars = new char[6];
            Random random = new Random();

            for (int i = 0; i < stringChars.Length; i++)
            {
                stringChars[i] = chars[random.Next(chars.Length)];
            }

            string finalString = new String(stringChars);

            string uniqueid = Util.GetString(Guid.NewGuid());
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into patient_otp(UniqueID,MobileNo,OTP,EntryDate,ExpiryDate) values (@UniqueID,@MobileNo,@OTP,Now(),DATE_ADD(NOW(),INTERVAL 15 MINUTE)) ",
                  new MySqlParameter("@UniqueID", uniqueid), new MySqlParameter("@MobileNo", mobileno), new MySqlParameter("@OTP", finalString));
            // SMS

            StringBuilder smsText = new StringBuilder();
            StringBuilder sbSMS = new StringBuilder();
            smsText.Append("Dear Patient, OTP to change mobile number is: <OTP>.");
            smsText.Replace("<OTP>", Util.GetString(finalString) + " ");
            sbSMS.Append(" insert into sms(MOBILE_NO,SMS_TEXT,IsSend,UserID,EntDate,SMS_Type,LedgerTransactionID,LabObservation_ID) ");
            sbSMS.Append("values( @MOBILE_NO,@SMS_TEXT,@IsSend,@UserID,now(),@SMS_Type,@LID,@LObID) ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(), new MySqlParameter("@MOBILE_NO", mobileno)
             , new MySqlParameter("@SMS_TEXT", smsText), new MySqlParameter("@IsSend", "0"), new MySqlParameter("@UserID", "-1")
             , new MySqlParameter("@SMS_Type", "Registration"), new MySqlParameter("@LID", "0"), new MySqlParameter("@LObID", "0"));

            double diff = (DateTime.Now.AddMinutes(15) - DateTime.Now).TotalSeconds;
            tnx.Commit();
            return JsonConvert.SerializeObject(new { Status = true, response = "1#" + uniqueid + "#" + diff });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(new { Status = false, ErrorMsg = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class OTPPatient
    {
        public string OTPUniqID { get; set; }
        public string OTPVal { get; set; }
        public string OTPRequired { get; set; }
    }
}
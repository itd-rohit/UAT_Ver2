using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Lab_DeltaCheckMobile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //if (Session["RoleID"] == null)
            //{
            //      Response.Redirect("~/Design/Default.aspx");
            //}
            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindAccessCentre();
        }
    }
    public void bindAccessCentre()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select distinct cm.CentreID,cm.Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID =@Centre and AccessType=1 ) or cm.CentreID = @Centre) and cm.isActive=1 order by cm.Centre ",
                new MySqlParameter("@Centre", UserInfo.Centre)).Tables[0])
            {
                ddlCentreAccess.DataSource = dt;
                ddlCentreAccess.DataTextField = "Centre";
                ddlCentreAccess.DataValueField = "CentreID";
                ddlCentreAccess.DataBind();
                ddlCentreAccess.Items.Insert(0, new ListItem("All Centres", "ALL"));    
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
    [WebMethod]
    public static string SearchPatientParamterDetail(string LabNo)
    {
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return "-1";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Append("   SELECT plo.`LedgerTransactionNo` LabNo,inv.`Name` Investigation,ploo.`LabObservationName` ParamterName, ");
            sbQuery.Append("  ploo.`Value` Reading,ploo.`MinValue`,ploo.`MaxValue`,ploo.`ReadingFormat` Unit    ");
            sbQuery.Append("   FROM `patient_labinvestigation_opd` plo   ");
            sbQuery.Append("   INNER JOIN investigation_master inv ON inv.`Investigation_Id`=plo.`Investigation_ID`  ");
            sbQuery.Append("   INNER JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID` ");
            sbQuery.Append("  WHERE plo.`Approved`=1 AND ploo.`Value`<>'' ");
            if (LabNo.Trim() != string.Empty)
            {
                sbQuery.Append(" AND plo.LedgerTransactionNo=@LedgerTransactionNo ");
            }
            sbQuery.Append(" ORDER BY inv.name,ploo.`Priorty`;");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
               new MySqlParameter("@LedgerTransactionNo", LabNo.Trim())).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string SearchPatientDetailVisitID(string VisitID, string fromdate, string todate)
    {
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return "-1";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Append(" SELECT IF(plo.`Approved`=1,'Yes','No') Approved,lt.LedgerTransactionID,cm.Centre,pm.`Mobile`,IFNULL(pm.`Email`,'')Email,DATE_FORMAT(lt.`Date`,'%d-%b-%y') RegDate,lt.`LedgerTransactionNo` LabNo, ");
            sbQuery.Append(" CONCAT(pm.`Title`,' ',pm.`PName`) PName,CONCAT(pm.`Age`,'/',LEFT(pm.`Gender`,1)) Age,  ");

            sbQuery.Append(" ( CASE    ");
            sbQuery.Append(" WHEN (lt.NetAmount-lt.Adjustment)=0  AND lt.iscredit=0 THEN '#00FA9A'  ");
            sbQuery.Append(" WHEN (lt.iscredit =1) THEN '#F0FFF0'  ");
            sbQuery.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment>0  AND lt.iscredit=0 THEN '#F6A9D1'  ");
            sbQuery.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment=0  AND lt.iscredit=0 THEN '#DDA0DD' ELSE '#F6A9D1'  END)  rowColor,");


            sbQuery.Append(" ROUND((lt.`NetAmount`-lt.`Adjustment`),2) BalAmount, ");
            sbQuery.Append(" IFNULL((SELECT BarcodeNo FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionNo`=lt.`LedgerTransactionNo` AND BarcodeNo<>'' LIMIT 1),'') BarcodeNo  ");
            sbQuery.Append(" FROM patient_master pm ");
            sbQuery.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`Patient_ID`=pm.`Patient_ID`   ");
            sbQuery.Append(" INNER JOIN centre_master cm on cm.CentreID=lt.`CentreID`  ");
            sbQuery.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");
       
            if (VisitID.Trim() != string.Empty)
            {
                sbQuery.Append(" AND lt.`LedgerTransactionNo`=@LedgerTransactionNo ");
            }

            sbQuery.Append(" AND lt.date >=@FromDate AND lt.date <=@ToDate ");
        
            sbQuery.Append(" GROUP BY lt.`LedgerTransactionNo` ORDER BY lt.`LedgerTransactionNo` ");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
                new MySqlParameter("@FromDate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " 00:00:00")),
                     new MySqlParameter("@ToDate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " 23:59:59")),
                   new MySqlParameter("@LedgerTransactionNo", VisitID.Trim())).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string SearchDetail(string SearchType, string SearchValue, string FromDate, string ToDate, string CentreID, string CallBy)
    {
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Your Session Expired.... Please Login Again" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Append(" SELECT '' MinDate,'' MaxDate,pm.`Patient_ID`,pm.`PName`,pm.`Mobile`");

            sbQuery.Append(" ,( CASE    ");
            sbQuery.Append("  WHEN (lt.NetAmount-lt.Adjustment)=0  AND lt.iscredit=0 THEN '#00FA9A'  ");
            sbQuery.Append(" WHEN (lt.iscredit =1) THEN '#F0FFF0'  ");
            sbQuery.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment>0  AND lt.iscredit=0 THEN '#F6A9D1'  ");
            sbQuery.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment=0  AND lt.iscredit=0 THEN '#DDA0DD' ELSE '#F6A9D1'  END)  rowColor");



            sbQuery.Append(" FROM patient_master pm   ");
            sbQuery.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`Patient_ID`=pm.`Patient_ID` ");
            sbQuery.Append(" WHERE pm.`Mobile`<>'0000000000'    AND pm.`Mobile`<>'' ");
            if (CallBy == "Patient")
            {
                if (SearchValue.Trim() != string.Empty)
                {
                    if (SearchType.Trim() == "lt.LedgertransactionNo")
                    {
                        sbQuery.Append(" AND lt.LedgertransactionNo = @SearchValue ");
                    }
                    else
                    {
                        sbQuery.Append(" AND pm.Mobile = @SearchValue ");
                    }
                }
                else
                {
                    sbQuery.Append(" AND lt.date >=@FromDate AND lt.date <=@ToDate ");
                }
            }
            if (CallBy != "Patient")
            {
                sbQuery.Append(" AND lt.date >=@FromDate AND lt.date <=@ToDate ");
            }
            if (CallBy == "Doctor")
            {
                sbQuery.Append(" AND lt.`Doctor_ID`=@SearchValue");
            }
            if (CallBy == "PUP")
            {
                sbQuery.Append(" AND lt.`Panel_ID`=@SearchValue");
            }
            if (CallBy == "PCC")
            {
                sbQuery.Append(" AND lt.CentreID=@SearchValue");
            }
            if (CentreID != "" && CentreID != "ALL")
            {
                sbQuery.Append(" AND lt.CentreID=@CentreID ");
            }
            if (CallBy == "Patient")
            {
                sbQuery.Append(" GROUP BY pm.`Patient_ID`  ORDER BY pm.`Patient_ID` ");
            }

            else if (SearchType.Trim() != "lt.LedgertransactionNo")
            {
                sbQuery.Append(" GROUP BY pm.`Patient_ID`  ORDER BY pm.`Patient_ID` ");
            }
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
                     new MySqlParameter("@CentreID", CentreID),
                     new MySqlParameter("@FromDate", string.Concat(Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"), " 00:00:00")),
                     new MySqlParameter("@ToDate", string.Concat(Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"), " 23:59:59")),
                     new MySqlParameter("@SearchValue", SearchValue)).Tables[0];

            DataTable patientTestDetails = new DataTable();
            if (dt.Rows.Count > 0)
            {
                patientTestDetails = SearchPatientLabDetails(dt.Rows[0]["Patient_ID"].ToString(), con);
            }
            DataTable patientInvDetails = new DataTable();
            if (patientTestDetails.Rows.Count > 0)
            {
                patientInvDetails = SearchPatientInvDetails(string.Empty, con, Util.GetInt(patientTestDetails.Rows[0]["LedgerTransactionID"].ToString()));
            }
            return JsonConvert.SerializeObject(new { status = "true", patientDetails = Util.getJson(dt), labDetails = Util.getJson(patientTestDetails), invDetails = Util.getJson(patientInvDetails) });

            // return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public static DataTable SearchPatientLabDetails(string PatientID, MySqlConnection con)
    {
        try
        {
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Append(" SELECT IF(plo.`Approved`=1,'Yes','No') Approved,lt.LedgerTransactionID,cm.Centre,pm.`Mobile`,pm.`Email`,DATE_FORMAT(lt.`Date`,'%d-%b-%y') RegDate,lt.`LedgerTransactionNo` LabNo, ");
            sbQuery.Append(" CONCAT(pm.`Title`,' ',pm.`PName`) PName,CONCAT(pm.`Age`,'/',LEFT(pm.`Gender`,1)) Age,  ");

            sbQuery.Append(" ( CASE  ");
            sbQuery.Append("  WHEN (lt.NetAmount-lt.Adjustment)=0  AND lt.iscredit=0 THEN '#00FA9A'  ");
            sbQuery.Append(" WHEN (lt.iscredit =1) THEN '#F0FFF0'  ");
            sbQuery.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment>0  AND lt.iscredit=0 THEN '#F6A9D1'  ");
            sbQuery.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment=0  AND lt.iscredit=0 THEN '#DDA0DD' ELSE '#F6A9D1'  END)  rowColor,");


            sbQuery.Append(" ROUND((lt.`NetAmount`-lt.`Adjustment`),2) BalAmount, ");
            sbQuery.Append(" IFNULL((SELECT BarcodeNo FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionNo`=lt.`LedgerTransactionNo` AND BarcodeNo<>'' LIMIT 1),'') BarcodeNo  ");
            sbQuery.Append(" FROM patient_master pm ");
            sbQuery.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`Patient_ID`=pm.`Patient_ID`   ");
            sbQuery.Append(" INNER JOIN centre_master cm on cm.CentreID=lt.`CentreID`  ");
            sbQuery.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` AND plo.isreporting=1");
          
            if (PatientID.Trim() != string.Empty)
            {
                sbQuery.Append(" AND pm.`Patient_ID`=@Patient_ID ");
            }
            sbQuery.Append(" GROUP BY lt.`LedgerTransactionNo` ORDER BY lt.`LedgerTransactionNo` ");
            return MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
               new MySqlParameter("@Patient_ID", PatientID.Trim())).Tables[0];

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {

        }
    }
    [WebMethod]
    public static string SearchPatientDetail(string PatientID)
    {
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Your Session Expired.... Please Login Again" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable patientDetails = SearchPatientLabDetails(PatientID, con);
            if (patientDetails.Rows.Count > 0)
            {
                DataTable patientInvDetails = SearchPatientInvDetails(string.Empty, con, Util.GetInt(patientDetails.Rows[0]["LedgerTransactionID"].ToString()));
                return JsonConvert.SerializeObject(new { status = "true", labDetails = Util.getJson(patientDetails), invDetails = Util.getJson(patientInvDetails) });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public static DataTable SearchPatientInvDetails(string LabNo, MySqlConnection con, int LedgerTransactionID = 0)
    {
        try
        {
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Append(" SELECT lt.LedgerTransactionID,plo.`LedgerTransactionNo`,inv.`Name` AS Investigation,plo.`BarcodeNo`,plo.Test_ID, ");
            sbQuery.Append(" IF(plo.`Approved`=1,'Yes','No') Approved,");

            sbQuery.Append(" (CASE   WHEN plo.IsDispatch='1' AND plo.isFOReceive='1' THEN '#44A3AA' "); //Dispatched
            sbQuery.Append(" WHEN plo.IsSampleCollected='R' THEN '#FF0000' ");//Sample Rejected
            sbQuery.Append(" WHEN plo.isFOReceive='0' AND plo.Approved='1' AND plo.isPrint='1' THEN '#00FFFF'  "); //Printed
            sbQuery.Append(" WHEN plo.isFOReceive='0' AND plo.Approved='1'  THEN '#90EE90' "); //Approved
            sbQuery.Append(" WHEN plo.Result_Flag='1' AND plo.isHold='0' AND plo.isForward='0' AND isPartial_Result='0' AND  plo.IsSampleCollected<>'R'  THEN '#FFC0CB'  "); //Tested
            sbQuery.Append(" WHEN plo.isHold='1' THEN '#FFFF00' "); //Hold
            sbQuery.Append(" WHEN plo.IsSampleCollected='N' THEN '#CC99FF'  ");//New
            sbQuery.Append(" WHEN plo.IsSampleCollected='S' THEN 'bisque'  ");//Sample Collected
            sbQuery.Append(" WHEN plo.IsSampleCollected='Y' THEN '#FFFFFF' "); //Department Receive
            sbQuery.Append(" ELSE '#FFFFFF' END )rowColor  ");


            
            sbQuery.Append(" FROM `patient_labinvestigation_opd` plo ");
            sbQuery.Append(" INNER JOIN investigation_master inv ON inv.`Investigation_Id`=plo.`Investigation_ID`");
            sbQuery.Append(" INNER JOIN  `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");
            if (LedgerTransactionID != 0)
                sbQuery.Append(" Where plo.LedgerTransactionID=@LedgerTransactionID ");
            else if (LabNo.Trim() != string.Empty)
                sbQuery.Append(" Where plo.LedgerTransactionNo=@LedgerTransactionNo ");

            sbQuery.Append(" ORDER BY inv.name;");
            return MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
               new MySqlParameter("@LedgerTransactionNo", LabNo.Trim()),
               new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)).Tables[0];
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {

        }
    }
    [WebMethod]
    public static string SearchPatientInvestigation(string LabNo)
    {
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Your Session Expired.... Please Login Again" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable invPatientDetails = SearchPatientInvDetails(LabNo, con);
            if (invPatientDetails.Rows.Count > 0)
            {
                return JsonConvert.SerializeObject(new { status = "true", invDetails = Util.getJson(invPatientDetails) });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string GetRemarks()
    {
        try
        {
            return JsonConvert.SerializeObject(StockReports.GetDataTable(" SELECT ID,Remarks FROM  Call_Centre_Remarks WHERE IsActive=1 "));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    [WebMethod]
    public static string SearchDetail1(string SearchType, string SearchValue, string FromDate, string ToDate, string CentreID)
    {
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return "-1";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Append(" SELECT '' MinDate,'' MaxDate,pm.`Patient_ID`,pm.`PName`,pm.`Mobile`");

            sbQuery.Append(" ,( CASE   ");
            sbQuery.Append("  WHEN (lt.NetAmount-lt.Adjustment)=0  AND lt.iscredit=0 THEN '#00FA9A'  ");
            sbQuery.Append(" WHEN (lt.iscredit =1) THEN '#F0FFF0'  ");
            sbQuery.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment>0  AND lt.iscredit=0 THEN '#F6A9D1'  ");
            sbQuery.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment=0  AND lt.iscredit=0 THEN '#DDA0DD' ELSE '#F6A9D1'  END)  rowColor");


            sbQuery.Append(" FROM patient_master pm   ");
            sbQuery.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`Patient_ID`=pm.`Patient_ID` ");
            sbQuery.Append(" WHERE pm.`Mobile`<>'0000000000'    AND pm.`Mobile`<>''  ");
            if (SearchValue.Trim() != "")
            {
                if (SearchType.Trim() == "PM.PName")
                {
                    sbQuery.Append(" AND @SearchType LIKE @searchValue ");
                }
                else
                {
                    sbQuery.Append(" AND @SearchType = @searchValue2 ");
                }
            }
            else
            {
                sbQuery.Append(" AND lt.date >=@FromDate ");
                sbQuery.Append(" AND lt.date <=@ToDate ");
            }
            if (CentreID != "" && CentreID != "ALL")
            {
                sbQuery.Append(" AND lt.CentreID=@Cid ");
            }
            else if (CentreID == "ALL")
            {
                sbQuery.Append(" AND (lt.CentreID in ( SELECT DISTINCT `CentreAccess` FROM `centre_access` WHERE `CentreID`=@CentreID  ) or lt.CentreID=@CentreID ) ");
            }
            else
            {
                sbQuery.Append(" AND lt.CentreID=@CentreID ");
            }

            if (SearchType.Trim() != "lt.LedgertransactionNo")
            {
                sbQuery.Append(" GROUP BY pm.`Patient_ID`  ORDER BY pm.`Patient_ID` ");
            }
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
                        new MySqlParameter("@CentreID", UserInfo.Centre),
                        new MySqlParameter("@Cid", CentreID),
                        new MySqlParameter("@SearchType", SearchType.Trim()),
                        new MySqlParameter("@searchValue", string.Format("{0}%",SearchValue.Trim())),
                        new MySqlParameter("@searchValue2", string.Format("{0}",SearchValue.Trim())),
                        new MySqlParameter("@FromDate", Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00"),
                        new MySqlParameter("@ToDate", Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59")
                        ).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveNewLabReportLog(string MobileNo, string CallBy, string CallByID, string CallType, string Remarks, int RemarksID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            Patient_Estimate_Log PSL = new Patient_Estimate_Log(tnx)
            {
                Mobile = MobileNo,
                Call_By = CallBy,
                Call_By_ID = CallByID,
                Call_Type = CallType,
                UserName = UserInfo.LoginName,
                UserID = UserInfo.ID,
                Remarks = Remarks,
                CentreID = "0",
                RemarksID = RemarksID
            };
            string ID = PSL.Insert();
            if (ID == string.Empty)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Error" });
            }
            else
            {
                tnx.Commit();
                return JsonConvert.SerializeObject(new { status = "true", response = "Call Close Successfully" });
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string bindEmailData(string VisitNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select lt.LedgerTransactionno,pli.barcodeno,pli.test_id,pli.approved,pli.itemname,pm.mobile,pm.email,lt.pname pname, ");
            sb.Append(" if(pli.approved=1,'lightgreen','pink') rowColor");
            sb.Append(" from patient_labinvestigation_opd pli inner join patient_master pm on pm.patient_id=pli.patient_id");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON pli.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" AND lt.LedgerTransactionno=@LedgerTransactionNo");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@LedgerTransactionNo", VisitNo)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public static string OTP()
    {
        string chars = "0123456789";
        char[] stringChars = new char[6];
        Random random = new Random();
        for (int i = 0; i < stringChars.Length; i++)
        {
            stringChars[i] = chars[random.Next(chars.Length)];
        }
        return new String(stringChars);
    }
    public static List<responseDetails> createOTP(string VisitNo, string MobileNo, string OTPType, int LedgerTransactionID)
    {

        string finalString = OTP();
        string uniqueid = Guid.NewGuid().ToString();
        StringBuilder smsText = new StringBuilder();
        StringBuilder sbSMS = new StringBuilder();
        smsText.AppendFormat("Dear User,OTP to receive {0} for different mobile no. is < OTP >.Your OTP is valid for only 15 minutes.", OTPType);
        smsText.Replace("< OTP >", Util.GetString(finalString) + " ");
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        List<responseDetails> addEncrypt = new List<responseDetails>();
        try
        {
            sbSMS = new StringBuilder();
            sbSMS.Append(" SELECT pm.Mobile FROM patient_master pm  INNER JOIN f_ledgertransaction lt ON lt.`Patient_ID`=pm.`Patient_ID` ");
            sbSMS.Append(" AND lt.LedgerTransactionID=@LedgerTransactionID   LIMIT 1 ");
            string Mobile = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sbSMS.ToString(),
                new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)));
            if (Mobile == string.Empty)
            {
                addEncrypt.Add(new responseDetails { Status = false, Response = "Primary Mobile No. is blank", ResponseDetail = string.Empty });
                return addEncrypt;
            }
            else
            {
                sbSMS = new StringBuilder();
                sbSMS.Append(" INSERT INTO  call_otp(UniqueID,MobileNo,OTP,EntryDate,ExpiryDate)");
                sbSMS.Append(" VALUES(@UniqueID,@MobileNo,@OTP,NOW(),DATE_ADD(NOW(),INTERVAL 15 MINUTE))");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                    new MySqlParameter("@UniqueID", uniqueid),
                    new MySqlParameter("@MobileNo", Mobile),
                    new MySqlParameter("@OTP", finalString));
                int CallID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT LAST_INSERT_ID() as AutoKey"));

                sbSMS = new StringBuilder();
                sbSMS.Append("INSERT INTO  sms(MOBILE_NO,SMS_TEXT,IsSend,UserID,EntDate,SMS_Type,LedgerTransactionID,LabObservation_ID) ");
                sbSMS.Append(" values(@MobileNo,@smsText,'0','-1',NOW(),'CallCenter',@LedgerTransactionID,'0') ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                   new MySqlParameter("@MobileNo", Mobile), new MySqlParameter("@smsText", smsText),
                   new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
                tnx.Commit();
                addEncrypt.Add(new responseDetails { Status = true, Response = "OTP Send Successfully", ResponseDetail = Common.Encrypt(Util.GetString(CallID)) });
                return addEncrypt;
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            addEncrypt.Add(new responseDetails { Status = false, Response = "Error", ResponseDetail = string.Empty });
            return addEncrypt;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string SendOTP(string VisitNo, string MobileNo, string OTPType, int LedgerTransactionID)
    {
        List<responseDetails> OTPDetail = createOTP(VisitNo, MobileNo, OTPType, LedgerTransactionID);
        if (OTPDetail[0].Status == true)
        {
            return JsonConvert.SerializeObject(new { status = "true", response = OTPDetail[0].Response, responseDetail = OTPDetail[0].ResponseDetail });
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
    }
    [WebMethod(EnableSession = true)]
    public static string ReSendOTP(string VisitNo, string MobileNo, string OTPType, int LedgerTransactionID, string OTPResponse)
    {
        List<responseDetails> OTPDetail = ResendOTP(VisitNo, MobileNo, OTPType, LedgerTransactionID, OTPResponse);
        if (OTPDetail[0].Status == true)
        {
            return JsonConvert.SerializeObject(new { status = "true", response = OTPDetail[0].Response, responseDetail = OTPDetail[0].ResponseDetail, IsShow = OTPDetail[0].IsShow });
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = false, response = OTPDetail[0].Response, responseDetail = OTPDetail[0].ResponseDetail, IsShow = OTPDetail[0].IsShow });
        }
    }
    public static List<responseDetails> ResendOTP(string VisitNo, string MobileNo, string OTPType, int VisitID, string OTPResponse)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        List<responseDetails> responseDetail = new List<responseDetails>();
        string OTP = string.Empty; int Success = 0;
        try
        {
            StringBuilder sb = new StringBuilder();
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,OTP,EntryDate,ExpiryDate,IsReused,MobileNo FROM  call_otp  WHERE ID=@ID ",
                       new MySqlParameter("@ID", Common.Decrypt(OTPResponse))).Tables[0])
            {
                if (dt.Rows.Count == 0)
                {
                    responseDetail.Add(new responseDetails { Status = false, Response = "Invalid Mobile No." });
                    return responseDetail;
                }
                else if (Util.GetInt(dt.Rows[0]["IsReused"].ToString()) >= 2)
                {
                    responseDetail.Add(new responseDetails { Status = false, Response = "Maximum Reused OTP has been expired,Please create new OTP", IsShow = 1 });
                    return responseDetail;
                }
                else if (Util.GetDateTime(DateTime.Now) > Util.GetDateTime(dt.Rows[0]["ExpiryDate"].ToString()))
                {
                    responseDetail.Add(new responseDetails { Status = false, Response = "OTP expired,Please create new OTP", IsShow = 1 });
                    return responseDetail;
                }
                OTP = dt.Rows[0]["OTP"].ToString();

                if (OTP != string.Empty)
                {
                    StringBuilder smsText = new StringBuilder();
                    smsText.AppendFormat("Dear User,OTP to receive {0} for different mobile no. is < OTP >.Your OTP is valid for only 15 minutes.", OTPType);
                    smsText.Replace("< OTP >", Util.GetString(OTP) + " ");


                    MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                    try
                    {
                        sb = new StringBuilder();
                        sb.Append("  UPDATE  call_otp SET IsReused=IsReused+1 WHERE ID=@ID");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@ID", Common.Decrypt(OTPResponse)));

                        sb = new StringBuilder();
                        sb.Append("INSERT INTO  sms(MOBILE_NO,SMS_TEXT,IsSend,UserID,EntDate,SMS_Type,LedgerTransactionID,LabObservation_ID) ");
                        sb.Append(" values(@MobileNo,@smsText,'0','-1',NOW(),'CallCenter',@LedgerTransactionID,'0') ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@MobileNo", dt.Rows[0]["MobileNo"].ToString()), new MySqlParameter("@smsText", smsText),
                           new MySqlParameter("@LedgerTransactionID", VisitID));
                        tnx.Commit();
                        Success = 1;

                    }
                    catch (Exception ex)
                    {
                        tnx.Rollback();
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        responseDetail.Add(new responseDetails { Status = false, Response = "Error", ResponseDetail = string.Empty, IsShow = 1 });
                    }
                    finally
                    {
                        tnx.Dispose();
                    }
                    if (Success == 1)
                        responseDetail.Add(new responseDetails { Status = true, Response = "OTP ReSend Successfully", ResponseDetail = Util.GetString(OTPResponse), IsShow = 0 });
                    else
                        responseDetail.Add(new responseDetails { Status = false, Response = "Error", ResponseDetail = string.Empty, IsShow = 1 });
                    return responseDetail;
                }
                else
                {
                    responseDetail.Add(new responseDetails { Status = false, Response = "OTP not found", ResponseDetail = string.Empty, IsShow = 1 });
                    return responseDetail;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            responseDetail.Add(new responseDetails { Status = false, Response = "Error", ResponseDetail = string.Empty, IsShow = 1 });
            return responseDetail;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string SendSMSReceipt(string VisitNo, string MobileNo, int VisitID, string OTP, string reportUniqueID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pm.Mobile FROM patient_master pm  INNER JOIN f_ledgertransaction lt ON lt.`Patient_ID`=pm.`Patient_ID` ");
            sb.Append(" AND lt.LedgerTransactionID=@LedgerTransactionID   ");
            string PatientMobileNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@LedgerTransactionID", VisitID)));
            if (PatientMobileNo != MobileNo && OTP == string.Empty)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Different Mobile no.So OTP validation required" });
            }
            else if (PatientMobileNo == MobileNo)
            {
                List<responseDetails> receiptDetail = tinyReceipt(VisitID, MobileNo);
                return JsonConvert.SerializeObject(new { status = receiptDetail[0].Status, response = receiptDetail[0].Response, responseDetail = DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), MobileNo = MobileNo });
            }
            else if (OTP != string.Empty)
            {
                int a = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  call_otp WHERE otp=@otp AND ID=@ID AND NOW()<expirydate AND isused=0 AND MobileNo=@MobileNo",
                    new MySqlParameter("@otp", OTP), new MySqlParameter("@MobileNo", PatientMobileNo),
                    new MySqlParameter("@ID", Common.Decrypt(reportUniqueID))));

                if (a == 1)
                {
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE  call_otp set isUsed=1 WHERE ID=@ID",
                         new MySqlParameter("@ID", Common.Decrypt(reportUniqueID)));
                    List<responseDetails> receiptDetail = tinyReceipt(VisitID, MobileNo);
                    return JsonConvert.SerializeObject(new { status = receiptDetail[0].Status, response = receiptDetail[0].Response, responseDetail = DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), MobileNo = MobileNo });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Invalid OTP" });
                }
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Error" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string SendWhatsAppReceipt(string VisitNo, string MobileNo, int VisitID, string OTP, string reportUniqueID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pm.Mobile,lt.pname FROM patient_master pm  INNER JOIN f_ledgertransaction lt ON lt.`Patient_ID`=pm.`Patient_ID` ");
            sb.Append(" AND lt.LedgerTransactionID=@LedgerTransactionID   ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@LedgerTransactionID", VisitID)).Tables[0];

            string PatientMobileNo=dt.Rows[0]["Mobile"].ToString();
            string PatientName=dt.Rows[0]["pname"].ToString();
            if (PatientMobileNo != MobileNo && OTP == string.Empty)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Different Mobile no.So OTP validation required" });
            }
            else if (PatientMobileNo == MobileNo)
            {
                List<responseDetails> receiptDetail = WhatsAppReceipt(VisitID, VisitNo, PatientName, MobileNo);
                return JsonConvert.SerializeObject(new { status = receiptDetail[0].Status, response = receiptDetail[0].Response, responseDetail = DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), MobileNo = MobileNo });
            }
            else if (OTP != string.Empty)
            {
                int a = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  call_otp WHERE otp=@otp AND ID=@ID AND NOW()<expirydate AND isused=0 AND MobileNo=@MobileNo",
                    new MySqlParameter("@otp", OTP), new MySqlParameter("@MobileNo", PatientMobileNo),
                    new MySqlParameter("@ID", Common.Decrypt(reportUniqueID))));

                if (a == 1)
                {
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE  call_otp set isUsed=1 WHERE ID=@ID",
                         new MySqlParameter("@ID", Common.Decrypt(reportUniqueID)));
                    List<responseDetails> receiptDetail = WhatsAppReceipt(VisitID,VisitNo,PatientName, MobileNo);
                    return JsonConvert.SerializeObject(new { status = receiptDetail[0].Status, response = receiptDetail[0].Response, responseDetail = DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), MobileNo = MobileNo });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Invalid OTP" });
                }
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Error" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public class WebClientWithTimeout : WebClient
    {
        protected override WebRequest GetWebRequest(Uri address)
        {
            WebRequest wr = base.GetWebRequest(address);
            wr.Timeout = 5000; // timeout in milliseconds
            return wr;
        }
    }
    public static List<responseDetails> tinyReceipt(int LedgerTransactionID, string MobileNo)
    {
        List<responseDetails> addStatus = new List<responseDetails>();
        try
        {
            string TinyConverterURL = "http://9url.in/?_url=";
            string TrackUrl = string.Format("http://localhost/itdoselab/design/Lab/PatientReceiptNew.aspx?LabID={2}", Common.Encrypt(Util.GetString(UserInfo.ID)), Common.Encrypt(UserInfo.LoginName), LedgerTransactionID);
            using (WebClient wc = new WebClientWithTimeout())
            {
                byte[] PostData = Encoding.ASCII.GetBytes("");
                byte[] Response = wc.UploadData(TinyConverterURL + TrackUrl, PostData);
                string turl = Encoding.ASCII.GetString(Response);
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    StringBuilder smsText = new StringBuilder();
                    smsText.AppendFormat("Namaste! Thank you for choosing {0}. Your samples are received View/download your bill copy here < TrackLink > For any assistance call {1} ", "Apollo Diagnostics", "");
                    smsText.Replace("< TrackLink >", Util.GetString(turl));
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO  sms(MOBILE_NO,SMS_TEXT,IsSend,UserID,EntDate,SMS_Type,LedgerTransactionID,LabObservation_ID) ");
                    sb.Append(" VALUES(@MobileNo,@smsText,'0','1',NOW(),'HCBill',@LedgerTransactionID,'0') ");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@MobileNo", MobileNo), new MySqlParameter("@smsText", smsText),
                       new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));

                    smsText.Clear();
                    sb.Clear();
                    addStatus.Add(new responseDetails { Status = true, Response = "Send Sucessfully" });
                    return addStatus;
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    addStatus.Add(new responseDetails { Status = false, Response = "Error" });
                    return addStatus;
                }
                finally
                {
                    con.Close();
                    con.Dispose();
                }
            }
        }
        catch (WebException e)
        {
            if (e.Status == WebExceptionStatus.Timeout)
                addStatus.Add(new responseDetails { Status = false, Response = "TimeOut Error", ResponseDetail = string.Empty });
            else
                addStatus.Add(new responseDetails { Status = false, Response = "Error", ResponseDetail = string.Empty });
            return addStatus;
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            addStatus.Add(new responseDetails { Status = false, Response = "Error", ResponseDetail = string.Empty });
            return addStatus;
        }
    }


    public static List<responseDetails> WhatsAppReceipt(int LedgerTransactionID,string LedgerTransactionNo,string Pname,  string MobileNo)
    {
        List<responseDetails> addStatus = new List<responseDetails>();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sbSMS = new StringBuilder(); 
            sbSMS.Append(" insert into whatsapp(LedgerTransactionID,LedgerTransactionNo,PName,FieldName,FieldValue,MobileNo,WhatsappType,EntryById,EntryByName) ");
            sbSMS.Append(" values(@LedgerTransactionID,@LedgerTransactionNo,@Pname,@FieldName,@LedgerTransactionID,@MobileNo,@WhatsappType,@EntryById,@EntryByName) ");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sbSMS.ToString(),
                new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                new MySqlParameter("@Pname", Pname),
                new MySqlParameter("@FieldName", "LedgerTransactionID"),
                new MySqlParameter("@MobileNo", MobileNo),
                new MySqlParameter("@WhatsappType", "Bill"),
                new MySqlParameter("@EntryById", UserInfo.ID),
                new MySqlParameter("@EntryByName", UserInfo.LoginName)
                );

            sbSMS.Clear();
            addStatus.Add(new responseDetails { Status = true, Response = "WhatsApp Request Send Sucessfully" });
            return addStatus;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            addStatus.Add(new responseDetails { Status = false, Response = "Error" });
            return addStatus;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public static List<responseDetails> WhatsAppReport(int LedgerTransactionID, string LedgerTransactionNo, string Pname, string MobileNo)
    {
        List<responseDetails> addStatus = new List<responseDetails>();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int isfound = 0;
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT plo.`LedgerTransactionID`, plo.LedgerTransactionNO,plo.`ItemId`,lt.PName,plo.Test_id,ifnull(ibt.id,0) islock ");
            sb.Append(" FROM patient_labinvestigation_opd  plo ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`= plo.`LedgerTransactionID`  ");
            sb.Append(" and plo.approved=1 and lt.LedgerTransactionID=@LedgerTransactionID");
            sb.Append(" left join f_itemaster_block_tiny_sms ibt on ibt.itemid=plo.itemid and ibt.isactive=1");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)).Tables[0];
            StringBuilder sbSMS;
            if (dt.Rows.Count > 0)
            {
                
                foreach (DataRow dw in dt.Rows)
                {
                    if (dw["islock"].ToString() == "0")
                    {
                        sbSMS = new StringBuilder();
                        sbSMS.Append(" insert into whatsapp(Test_id,LedgerTransactionID,LedgerTransactionNo,PName,FieldName,FieldValue,MobileNo,WhatsappType,EntryById,EntryByName) ");
                        sbSMS.Append(" values(@Test_id,@LedgerTransactionID,@LedgerTransactionNo,@Pname,@FieldName,@LedgerTransactionID,@MobileNo,@WhatsappType,@EntryById,@EntryByName) ");
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sbSMS.ToString(),
                            new MySqlParameter("@Test_id", Util.GetInt(dw["Test_id"])),
                            new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                            new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                            new MySqlParameter("@Pname", Pname),
                            new MySqlParameter("@FieldName", "LedgerTransactionID"),
                            new MySqlParameter("@MobileNo", MobileNo),
                            new MySqlParameter("@WhatsappType", "LabReport"),
                            new MySqlParameter("@EntryById", UserInfo.ID),
                            new MySqlParameter("@EntryByName", UserInfo.LoginName)
                            );
                        isfound = isfound + 1;

                    }
                }
            }
            if (isfound > 0)
            {
                addStatus.Add(new responseDetails { Status = true, Response = "WhatsApp Request Send Sucessfully " });
            }
            else
            {
                addStatus.Add(new responseDetails { Status = false, Response = "WhatsApp Not Allowed" });
            }
            return addStatus;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            addStatus.Add(new responseDetails { Status = false, Response = "Error" });
            return addStatus;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
        
    

    public class responseDetails
    {
        public bool Status { get; set; }
        public string Response { get; set; }
        public string ResponseDetail { get; set; }
        public int IsShow { get; set; }
    }

    public static DataTable getLabReportData(int VisitID, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT IF(fpm.`PanelType`='PUP','PUP',cm.`type1`)PanelType,lt.LedgerTransactionID,lt.`IsCredit`,lt.`NetAmount`,lt.`Adjustment`, ");
        sb.Append("  IF(ROUND(lt.`NetAmount`)>ROUND(lt.`Adjustment`) AND lt.`IsCredit`=0,'1','0')IsDue,  ");
        sb.Append("   GROUP_CONCAT(Test_id)Test_id, lt.`LedgerTransactionNo`,cm.`Centre`,CONCAT(pm.title,'',pm.Pname)PName,lt.Patient_ID UHID,   ");
        sb.Append("  lt.Username_web UserID, lt.`Password_web` `Password` FROM patient_master pm  ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`Patient_ID`=pm.`Patient_ID` AND lt.LedgerTransactionID=@LedgerTransactionID    ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
        sb.Append(" AND plo.`Approved`=1 AND plo.`IsReporting`=1  ");
        sb.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`  ");
        sb.Append("  INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID` ");
        sb.Append("   GROUP BY plo.LedgerTransactionID; ");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@LedgerTransactionID", VisitID)).Tables[0];
    }

    public static List<responseDetails> sendLabReportData(DataTable dtSMSData, string MobileNo, int VisitID, MySqlConnection con, string Type)
    {
        List<responseDetails> addStatus = new List<responseDetails>();
        try
        {
            string TinyConverterURL = "http://9url.in/?_url=";
            string labno =Util.GetString( MySqlHelper.ExecuteScalar(con, CommandType.Text, "select LedgerTransactionno from f_LedgerTransaction where LedgerTransactionID=@LedgerTransactionID",
                       new MySqlParameter("@LedgerTransactionID", VisitID)));

            string TrackUrl = "https://localhost/itdoselab/Design/lab/labreportnew_ShortSMS.aspx?LabNo=" + labno;

            // TrackUrl += string.Format("/Design/Lab/labreportnew.aspx?testid={0}&isOnlinePrint={1}&PHead={2}&PrintedByName={3}", Common.Encrypt(Util.GetString(dtSMSData.Rows[0]["Test_id"])), Common.Encrypt("1"), Common.Encrypt("0"), Common.Encrypt("Email"));

            using (WebClient wc = new WebClientWithTimeout())
            {
                byte[] PostData = Encoding.ASCII.GetBytes("");
                byte[] Response = wc.UploadData(TinyConverterURL + TrackUrl, PostData);
                string turl = Encoding.ASCII.GetString(Response);

                try
                {
                    StringBuilder smsText = new StringBuilder();

                    smsText.AppendFormat("Namaste! Thank you for choosing {0}. Your samples are received View/download your report copy here < TrackLink > For any assistance call {1} ", "Apollo Diagnostics", "");
                    smsText.Replace("< TrackLink >", Util.GetString(turl));

                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO  sms(MOBILE_NO,SMS_TEXT,IsSend,UserID,EntDate,SMS_Type,LedgerTransactionID,LabObservation_ID) ");
                    sb.Append(" VALUES(@MobileNo,@smsText,'0','1',NOW(),@Type,@LedgerTransactionID,'0') ");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@MobileNo", MobileNo), new MySqlParameter("@smsText", smsText),
                       new MySqlParameter("@LedgerTransactionID", VisitID), new MySqlParameter("@Type", Type));

                    smsText.Clear();
                    sb.Clear();
                    addStatus.Add(new responseDetails { Status = true, Response = "Send Successfully", ResponseDetail = string.Empty });
                    return addStatus;

                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    addStatus.Add(new responseDetails { Status = false, Response = "Error", ResponseDetail = string.Empty });
                    return addStatus;
                }
            }
        }
        catch (WebException e)
        {
            if (e.Status == WebExceptionStatus.Timeout)
                addStatus.Add(new responseDetails { Status = false, Response = "Time Out Error", ResponseDetail = string.Empty });
            else
                addStatus.Add(new responseDetails { Status = false, Response = "Error", ResponseDetail = string.Empty });
            return addStatus;
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            addStatus.Add(new responseDetails { Status = false, Response = "Error", ResponseDetail = string.Empty });
            return addStatus;
        }
    }


    [WebMethod(EnableSession = true)]
    public static string sendReportWhatsApp(string VisitNo, string MobileNo, string OTP, int VisitID, string reportUniqueID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
             StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pm.Mobile,lt.pname FROM patient_master pm  INNER JOIN f_ledgertransaction lt ON lt.`Patient_ID`=pm.`Patient_ID` ");
            sb.Append(" AND lt.LedgerTransactionID=@LedgerTransactionID   ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@LedgerTransactionID", VisitID)).Tables[0];

            string PatientMobileNo=dt.Rows[0]["Mobile"].ToString();
            string PatientName=dt.Rows[0]["pname"].ToString();

            if (PatientMobileNo != MobileNo && OTP == string.Empty)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Different Mobile no.So OTP validation required", isShow = "1" });
            }
            else if (PatientMobileNo == MobileNo)
            {
                DataTable LabReportData = getLabReportData(VisitID, con);
                if (LabReportData.Rows.Count > 0)
                {
                    if (Util.GetString(LabReportData.Rows[0]["IsDue"]) == "0")
                    {
                        List<responseDetails> responseData = WhatsAppReport(VisitID, VisitNo, PatientName, MobileNo);
                        if (responseData[0].Status == true)
                        {
                            return JsonConvert.SerializeObject(new { status = "true", response = responseData[0].Response, responseDetails = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy hh:mm tt") });
                        }
                        else
                        {
                            return JsonConvert.SerializeObject(new { status = false, response = responseData[0].Response, isShow = "0" });
                        }
                    }
                    else
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = "Patient Due Amount", isShow = "0" });
                    }
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found", isShow = "0" });
                }
            }
            else if (OTP != string.Empty)
            {
                int a = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  call_otp WHERE otp=@otp AND ID=@ID AND NOW()<expirydate AND isused=0 ",
                    new MySqlParameter("@otp", OTP), new MySqlParameter("@ID", Common.Decrypt(reportUniqueID))));

                if (a == 1)
                {

                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE  call_otp set isUsed=1 WHERE ID=@ID",
                         new MySqlParameter("@ID", Common.Decrypt(reportUniqueID)));
                    DataTable LabReportData = getLabReportData(VisitID, con);
                    if (LabReportData.Rows.Count > 0)
                    {
                        if (Util.GetString(LabReportData.Rows[0]["IsDue"]) == "0")
                        {
                            List<responseDetails> responseData = WhatsAppReport(VisitID, VisitNo, PatientName, MobileNo);
                            if (responseData[0].Status == true)
                            {
                                return JsonConvert.SerializeObject(new { status = "true", response = responseData[0].Response, responseDetails = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy hh:mm tt") });
                            }
                            else
                            {
                                return JsonConvert.SerializeObject(new { status = false, response = responseData[0].Response, isShow = "0" });
                            }
                        }
                        else
                        {
                            return JsonConvert.SerializeObject(new { status = false, response = "Patient Due Amount", isShow = "0" });
                        }
                    }
                    else
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = "Patient Due Amount", isShow = "0" });
                    }
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Invalid OTP", isShow = "0" });

                }
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Error", isShow = "0" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error", isShow = "0" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    

    [WebMethod(EnableSession = true)]
    public static string sendReportSMS(string VisitNo, string MobileNo, string OTP, int VisitID, string reportUniqueID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pm.Mobile FROM patient_master pm  INNER JOIN f_ledgertransaction lt ON lt.`Patient_ID`=pm.`Patient_ID` ");
            sb.Append(" AND lt.LedgerTransactionID=@LedgerTransactionID   ");

            string PatientMobileNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@LedgerTransactionID", VisitID)));
            if (PatientMobileNo != MobileNo && OTP == string.Empty)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Different Mobile no.So OTP validation required", isShow = "1" });
            }
            else if (PatientMobileNo == MobileNo)
            {
                DataTable LabReportData = getLabReportData(VisitID, con);
                if (LabReportData.Rows.Count > 0)
                {
                    if (Util.GetString(LabReportData.Rows[0]["IsDue"]) == "0")
                    {
                        List<responseDetails> responseData = sendLabReportData(LabReportData, MobileNo, VisitID, con, "TinySMS");
                        if (responseData[0].Status == true)
                        {
                            return JsonConvert.SerializeObject(new { status = "true", response = responseData[0].Response, responseDetails = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy hh:mm tt") });
                        }
                        else
                        {
                            return JsonConvert.SerializeObject(new { status = false, response = responseData[0].Response, isShow = "0" });
                        }
                    }
                    else
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = "Patient Due Amount", isShow = "0" });
                    }
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found", isShow = "0" });
                }
            }
            else if (OTP != string.Empty)
            {
                int a = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM  call_otp WHERE otp=@otp AND ID=@ID AND NOW()<expirydate AND isused=0 ",
                    new MySqlParameter("@otp", OTP), new MySqlParameter("@ID", Common.Decrypt(reportUniqueID))));

                if (a == 1)
                {

                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE  call_otp set isUsed=1 WHERE ID=@ID",
                         new MySqlParameter("@ID", Common.Decrypt(reportUniqueID)));
                    DataTable LabReportData = getLabReportData(VisitID, con);
                    if (LabReportData.Rows.Count > 0)
                    {
                        if (Util.GetString(LabReportData.Rows[0]["IsDue"]) == "0")
                        {
                            List<responseDetails> responseData = sendLabReportData(LabReportData, MobileNo, VisitID, con, "TinySMS");
                            if (responseData[0].Status == true)
                            {
                                return JsonConvert.SerializeObject(new { status = "true", response = responseData[0].Response, responseDetails = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy hh:mm tt") });
                            }
                            else
                            {
                                return JsonConvert.SerializeObject(new { status = false, response = responseData[0].Response, isShow = "0" });
                            }
                        }
                        else
                        {
                            return JsonConvert.SerializeObject(new { status = false, response = "Patient Due Amount", isShow = "0" });
                        }
                    }
                    else
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = "Patient Due Amount", isShow = "0" });
                    }
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Invalid OTP", isShow = "0" });

                }
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Error", isShow = "0" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error", isShow = "0" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string sendReportMail(string VisitNo, string EmailID, int VisitID)
    {
        string IsSend = "-1";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT IF(fpm.`PanelType`='PUP','PUP',cm.`type1`)PanelType,lt.LedgerTransactionID,lt.`IsCredit`,lt.`NetAmount`,lt.`Adjustment`, ");
            sb.Append("  IF(ROUND(lt.`NetAmount`)>ROUND(lt.`Adjustment`) AND lt.`IsCredit`=0,'1','0')IsDue,  ");
            sb.Append("   GROUP_CONCAT(Test_id)Test_id, lt.`LedgerTransactionNo`,cm.`Centre`,CONCAT(pm.title,'',pm.Pname)PName,lt.Patient_ID UHID,   ");
            sb.Append("  lt.Username_web UserID, lt.`Password_web` `Password` FROM patient_master pm  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`Patient_ID`=pm.`Patient_ID` AND lt.LedgerTransactionno=@LedgerTransactionNo    ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" AND plo.`Approved`=1 AND plo.`IsReporting`=1  ");
            sb.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`  ");
            sb.Append("  INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID` ");
            sb.Append("   GROUP BY plo.LedgerTransactionID; ");

            DataTable dtEmailData = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LedgerTransactionNo", VisitNo)).Tables[0];
            if (dtEmailData.Rows.Count > 0)
            {

                if (Util.GetString(dtEmailData.Rows[0]["IsDue"]) == "0")
                {
                    try
                    {
                        ReportEmailClass RMail = new ReportEmailClass();
                        StringBuilder EmailBody = new StringBuilder();
                        string EmailSubject = string.Empty;
                        if (Util.GetString(dtEmailData.Rows[0]["PanelType"]) != "PUP")
                        {
                            // For (PCC) All ( Except STAT , HLM , PUP )
                            if (Util.GetString(dtEmailData.Rows[0]["PanelType"]) == "PCC" || Util.GetString(dtEmailData.Rows[0]["PanelType"]) == "NRL" || Util.GetString(dtEmailData.Rows[0]["PanelType"]) == "RRL" || Util.GetString(dtEmailData.Rows[0]["PanelType"]) == "SL" || Util.GetString(dtEmailData.Rows[0]["PanelType"]) == "DDC" || Util.GetString(dtEmailData.Rows[0]["PanelType"]) == "PCL" || Util.GetString(dtEmailData.Rows[0]["PanelType"]) == "RLM")
                            {
                                EmailBody.Append(System.IO.File.ReadAllText(HttpContext.Current.Server.MapPath("~/EmailBody/PCC_Report_Email_Template.html")));
                            }
                            // For STAT And HLM
                            else if (Util.GetString(dtEmailData.Rows[0]["PanelType"]) == "HLM" || Util.GetString(dtEmailData.Rows[0]["PanelType"]) == "STAT")
                            {
                                EmailBody.Append(System.IO.File.ReadAllText(HttpContext.Current.Server.MapPath("~/EmailBody/HLM_Report_Email_Template.html")));
                            }
                        }
                        // For PU                       
                        if (Util.GetString(dtEmailData.Rows[0]["PanelType"]) == "PUP")
                        {
                            EmailBody.Append(System.IO.File.ReadAllText(HttpContext.Current.Server.MapPath("~/EmailBody/PUP_Report_Email_Template.html")));
                        }


                        EmailBody.Replace("{CentreName}", Util.GetString(dtEmailData.Rows[0]["Centre"])).Replace("{UserID}", Util.GetString(dtEmailData.Rows[0]["UserID"])).Replace("{Password}", Util.GetString(dtEmailData.Rows[0]["Password"])).Replace("{UHID}", Util.GetString(dtEmailData.Rows[0]["UHID"])).Replace("{PName}", Util.GetString(dtEmailData.Rows[0]["PName"]));
                        EmailSubject = "Your Reports for UHID " + Util.GetString(dtEmailData.Rows[0]["UHID"]);
                        if (EmailBody.ToString().Trim() != "" && EmailSubject.Trim() != "")
                            IsSend = RMail.sendEmail(EmailID.Trim(), EmailSubject.Trim(), EmailBody.ToString(), string.Empty, string.Empty, Util.GetString(dtEmailData.Rows[0]["LedgerTransactionNo"]), Util.GetString(dtEmailData.Rows[0]["Test_id"]), "PDF Report", "0", "PDF Report Email", "Patient");
                        if (IsSend == "1")
                            return JsonConvert.SerializeObject(new { status = "true", response = "Email Send successfully", responseDetails = IsSend, sendDate = DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), EmailID = EmailID, SendBy = UserInfo.LoginName });
                        else
                            return JsonConvert.SerializeObject(new { status = "true", response = "Email Not Send", responseDetails = IsSend, sendDate = DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), EmailID = EmailID, SendBy = UserInfo.LoginName });
                    }
                    catch (Exception ex)
                    {
                        IsSend = "-1";
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        return JsonConvert.SerializeObject(new { status = false, response = "Error", responseDetails = IsSend });
                    }
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Patient Due Amount", responseDetails = IsSend });
                }
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "No Record Found", responseDetails = IsSend });
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error", responseDetails = IsSend });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string EmailReceipt(string VisitNo, string Email, string Type, string VisitID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string EmailSubject = "Your Receipt for Visit ID " + VisitNo;
            StringBuilder EmailBody = new StringBuilder();
            EmailBody.Append(System.IO.File.ReadAllText(HttpContext.Current.Server.MapPath("~/EmailBody/ReceiptEmailBody.html")));
            EmailBody.Replace("{VisitID}",VisitNo);
            

            ReportEmailClass RMail = new ReportEmailClass();
            string IsSend = RMail.sendBillEmail(Email.Trim(), EmailSubject, EmailBody.ToString(), string.Empty, string.Empty, Util.GetString(VisitNo), Util.GetString(VisitID), "PDF Bill Report", "0", "PDF Bill Report Email", "Patient");
           

            if (IsSend == "1")
                return JsonConvert.SerializeObject(new { status = "true", response = "Email Send successfully", responseDetails = IsSend, responseDetail = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy hh:mm tt") });
            else
                return JsonConvert.SerializeObject(new { status = false, response = "Email Not Send", responseDetails = IsSend });
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error", responseDetails = "0" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public static DataTable getEmailDetail(string VisitNo, string Type, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT erp.ID,erp.MailedTo,erp.LedgerTransactionNo,erp.`EmailID`,erp.`Cc`,erp.`Bcc`,DATE_FORMAT(erp.`dtEntry`,'%d-%b-%Y %h:%i %p')dtEntry,");
        sb.Append(" IF(erp.`IsAutoMail`=1,'Auto','Manual')MailType,lt.`PName`,em.`Name` UserName,IF(erp.`IsSend`=1,'Sent','Failed')IsSend ");
        sb.Append(" FROM `email_record_patient`  erp ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=erp.`LedgerTransactionID` ");
        sb.Append(" AND erp.`LedgerTransactionNo`=@LedgerTransactionNo AND erp.Remarks=@Remarks ");
        sb.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=erp.`UserID`  ORDER BY erp.`dtEntry` DESC ");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
           new MySqlParameter("@LedgerTransactionNo", VisitNo), new MySqlParameter("@Remarks", Type)).Tables[0];
    }
    [WebMethod(EnableSession = true)]
    public static string EmailStatusData(string VisitNo, string Type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = getEmailDetail(VisitNo, Type, con))
            {
                 if (dt.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(new { status = "true", response = "Success", responseDetail = Util.getJson(dt) });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = string.Empty, responseDetail = string.Empty });
                }
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public static DataTable getSMSDetail(string VisitID, string Type, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT sm.sms_ID ID,sm.Mobile_No,lt.LedgerTransactionNo,DATE_FORMAT(sm.`EntDate`,'%d-%b-%Y %h:%i %p')dtEntry,");
        sb.Append(" IF(sm.`IsSend`=1,'Sent','Failed')IsSend,'SMS' `type` ");
        sb.Append(" FROM  `sms`  sm ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=sm.`LedgerTransactionID` ");
        sb.Append(" AND lt.`LedgerTransactionID`=@LedgerTransactionID  ");
        if (Type != string.Empty)
            sb.Append(" AND sm.SMS_Type=@SMS_Type ");

        sb.Append(" Union all  ");

        sb.Append(" select id `ID`,mobileno Mobile_No,LedgerTransactionNo,DATE_FORMAT(`entrydatetime`,'%d-%b-%Y %h:%i %p')dtEntry, ");
        sb.Append(" if(issend=1,'Send','Fail') IsSend,'WhatsApp' `type` ");
        sb.Append(" from whatsapp where LedgerTransactionID=@LedgerTransactionID and WhatsAppType='Bill'");

        sb.Append(" ORDER BY id desc");

        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@LedgerTransactionID", VisitID), new MySqlParameter("@SMS_Type", Type)).Tables[0];
    }

    [WebMethod(EnableSession = true)]
    public static string getSMSEmailDetail(string VisitID, string VisitNo, string Type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable SMSDetail = getSMSDetail(VisitID, Type, con);
            DataTable EmailDetail = getEmailDetail(VisitNo, Type, con);
            return JsonConvert.SerializeObject(new { status = "true", SMSDetail = Util.getJson(SMSDetail), EmailDetail = Util.getJson(EmailDetail) });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string SMSWhastsAppData(string VisitID, string Type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select id `ID`,mobileno Mobile_No,LedgerTransactionNo,DATE_FORMAT(`entrydatetime`,'%d-%b-%Y %h:%i %p')dtEntry,");
            sb.Append(" IF(`IsSend`=1,'Sent','Failed')IsSend ");
            sb.Append(" FROM  whatsapp ");
            sb.Append(" where `LedgerTransactionID`=@LedgerTransactionID and  WhatsAppType='LabReport' group by LedgerTransactionID ,entrydatetime  ");         
            sb.Append(" ORDER BY id DESC  ");

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@LedgerTransactionID", VisitID)).Tables[0];
            if (dt.Rows.Count > 0)
            {
                return JsonConvert.SerializeObject(new { status = "true", response = "Success", responseDetail = Util.getJson(dt) });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = string.Empty, responseDetail = string.Empty });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error", responseDetail = string.Empty });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SMSStatusData(string VisitID, string Type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT sm.sms_ID ID,sm.Mobile_No,lt.LedgerTransactionNo,DATE_FORMAT(sm.`EntDate`,'%d-%b-%Y %h:%i %p')dtEntry,");
            sb.Append(" IF(sm.`IsSend`=1,'Sent','Failed')IsSend ");
            sb.Append(" FROM  `sms`  sm ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=sm.`LedgerTransactionID` ");
            sb.Append(" AND lt.`LedgerTransactionID`=@LedgerTransactionID  ");
            if (Type != string.Empty)
                sb.Append(" AND sm.SMS_Type=@SMS_Type ");
            sb.Append(" ORDER BY sm.`EntDate` DESC  ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@LedgerTransactionID", VisitID), new MySqlParameter("@SMS_Type", Type)).Tables[0];
            if (dt.Rows.Count > 0)
            {
                return JsonConvert.SerializeObject(new { status = "true", response = "Success", responseDetail = Util.getJson(dt) });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = string.Empty, responseDetail = string.Empty });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error", responseDetail = string.Empty });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string EncryptDate()
    {
        return JsonConvert.SerializeObject(new
        {
            status = "true",
            ID = Common.Encrypt(Util.GetString(UserInfo.ID)),
            LoginName = Common.Encrypt(UserInfo.LoginName),
            Centre = Common.Encrypt(Util.GetString(UserInfo.Centre)),
            RoleID = Common.Encrypt(Util.GetString(UserInfo.RoleID)),
            LoginType = Common.Encrypt(Util.GetString(UserInfo.LoginType)),
            CentreName = Common.Encrypt(Util.GetString(UserInfo.CentreName)),
        });
    }
}
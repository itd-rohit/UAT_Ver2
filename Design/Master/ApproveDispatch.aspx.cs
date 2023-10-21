using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Lab_ApproveDispatch : System.Web.UI.Page
{
    public string IsDefaultSing = string.Empty;
    public string ApprovalId = "";
    public string Year = DateTime.Now.Year.ToString();
    public string Month = DateTime.Now.ToString("MMM");
    public string HIVSaveRight = "0";
    public string IsAllowForRerun = "0";
    public static string Fromtime = "23:59:59";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            txtSearchValue.Focus();
            if (Session["RoleID"] == null)
            {
                Response.Redirect("~/Design/Default.aspx");
            }

            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindDepartment();
            BindApprovedBy();

            // Open Page From Test Approval Screen

            if (Util.GetString(Request.QueryString["fromdate"]) != "")
            {
                txtFormDate.Text = Util.GetString(Request.QueryString["fromdate"]);
                txtToDate.Text = Util.GetString(Request.QueryString["todate"]);
            }
        }
    }

    private void BindApprovedBy()
    {      
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@"SELECT DISTINCT em.Name, fa.EmployeeID FROM f_approval_labemployee fa INNER JOIN employee_master em ON em.Employee_ID=fa.EmployeeID   
                       AND IF(fa.`TechnicalId`='',fa.`EmployeeID`,fa.`TechnicalId`)=@EmployeeID AND fa.`RoleID`=@RoleID WHERE fa.Approval IN (1,3,4)  
                       ORDER BY fa.isDefault DESC,em.Name ");
            using (DataTable dtApproval = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@EmployeeID", UserInfo.ID),
                  new MySqlParameter("@RoleID", UserInfo.RoleID)).Tables[0])
            {
                ddlApprove.DataSource = dtApproval;
                ddlApprove.DataTextField = "Name";
                ddlApprove.DataValueField = "EmployeeID";
                ddlApprove.DataBind();
                ddlApprove.Items.Insert(0, new ListItem("Select Doctor", "0"));
                ddlApprove.SelectedIndex = ddlApprove.Items.IndexOf(ddlApprove.Items.FindByValue(UserInfo.ID.ToString()));
                if (dtApproval.Rows.Count == 1)
                    ddlApprove.Enabled = true;
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

    [WebMethod(EnableSession = true)]
    public static string Checkcolor(string testid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT");
            sb.Append(" plo.LabObservationName,plo.`Value`,plo.`MinValue`,plo.`MaxValue`,plo.readingFormat ");
            sb.Append(" FROM `patient_labobservation_opd` plo where Test_ID=@Test_ID ");

            using (DataTable dtApproval = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@Test_ID ", testid)).Tables[0])
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dtApproval);
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

    private void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='LSHHI3'   ");
        sb.Append(" ORDER BY NAME");
        ddlDepartment.DataSource = StockReports.GetDataTable(sb.ToString());
        ddlDepartment.DataTextField = "NAME";
        ddlDepartment.DataValueField = "SubCategoryID";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, new ListItem("-Select-", "0"));
    }

    public class labSearchType
    {
        public string SearchType { get; set; }
    }

    public static List<labSearchType> SearchType()
    {
        List<labSearchType> patientSearchType = new List<labSearchType>();
        patientSearchType.Add(new labSearchType() { SearchType = "pli.BarcodeNo" });
        patientSearchType.Add(new labSearchType() { SearchType = "lt.Patient_ID" });
        patientSearchType.Add(new labSearchType() { SearchType = "pli.LedgerTransactionNo" });
        patientSearchType.Add(new labSearchType() { SearchType = "pm.PName" });
        return patientSearchType;
    }

    public class patientLabSearch
    {
        public string SearchType { get; set; }
        public string SearchValue { get; set; }
        public string Department { get; set; }
        public string FromDate { get; set; }
        public string FromTime { get; set; }
        public string ToDate { get; set; }
        public string ToTime { get; set; }
        public string Investigation { get; set; }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string PatientSearch(object searchData, string PageNo, string PageSize, string _Flag)
    {
        try
        {
            string checkSession = UserInfo.LoginName;
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Session Expired,Please Login" });
        }
        List<patientLabSearch> labSearch = new JavaScriptSerializer().ConvertToType<List<patientLabSearch>>(searchData);

        HashSet<string> SearchTypes = new HashSet<string>(labSearch.Select(s => s.SearchType));
        if (SearchType().Where(m => SearchTypes.Contains(m.SearchType)).Count() == 0)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Invalid Data Found" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Append("  SELECT plo.flag, plo.LabObservation_ID, pli.reporttype,plo.MinCritical,plo.MaxCritical,plo.LabObservationName,plo.`Value`,plo.`MinValue`,plo.`MaxValue`,plo.readingFormat, pli.IsDispatch,pli.Approved,pli.test_id,DATE_FORMAT(lt.Date, '%d-%b-%y %H:%i')RegDate,(SELECT CentreCode FROM centre_master WHERE CentreID=pli.TestCentreID)TestCentreCode,pli.SubCategoryID SubCategoryID,DATE_FORMAT(pli.DeliveryDate,'%d-%b-%y')DeliveryDate,pli.investigation_ID,pli.ItemName InvestigationName ,''srno,sum(pli.isRerun) isrerun, concat(pli.CurrentSampleDept,'-->',pli.ToSampleDept)CombinationSampleDept,'' ReferLab,pli.Approved, ");
            sbQuery.Append("  if(DATE_FORMAT(pli.SampleReceiveDate, '%d-%b-%y %H:%i')='01-Jan-00 00:00' || DATE_FORMAT(pli.SampleReceiveDate, '%d-%b-%y %H:%i')='01-Jan-01 00:00','',DATE_FORMAT(ifnull(pli.SampleReceiveDate,''), '%d-%b-%y %H:%i'))DATE, DATE_FORMAT(ifnull(pli.SampleCollectionDate,''), '%d-%b-%y %H:%i') colledate,DATE_FORMAT(ifnull(pli.ResultEnteredDate,''), '%d-%b-%y %H:%i') ResultEnteredDate,DATE_FORMAT(ifnull(pli.Date,''), '%d-%b-%y %H:%i')ProvisionalDispatchDate,pli.`LedgerTransactionNo`,'' SampleLocation,pli.CombinationSample,CONCAT(lt.`PName`,' / ', lt.`Age`, ' / ', lt.`Gender`) PName,lt.`Gender`,lt.Patient_ID,");

            sbQuery.Append(" lt.doctorname AS Doctor,cm.Centre,pli.`BarcodeNo`, lt.panelname,   ");
            sbQuery.Append(" GROUP_CONCAT(DISTINCT CONCAT(plo.LabObservationName)) AS Test    ");

            sbQuery.Append(" FROM patient_labinvestigation_opd pli ");
            sbQuery.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID` ");
            sbQuery.Append(" INNER JOIN `investigation_master` im ON im.investigation_ID=pli.investigation_ID and im.isCulture=0 and im.ReportType<>7    ");
            sbQuery.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
            sbQuery.Append(" INNER JOIN patient_labobservation_opd  plo  ON plo.`test_id`=pli.`test_id` ");
            sbQuery.Append(" INNER JOIN patient_master pm on pm.patient_id=lt.patient_id");
            if (_Flag != "A")
            {
                if (_Flag == "H")
                {
                    sbQuery.Append(" inner join  (SELECT `Test_ID` FROM `patient_labobservation_opd` WHERE  ");
                    sbQuery.Append(" `ResultEnteredDate` >=@fromResultEnteredDate ");
                    sbQuery.Append(" AND `ResultEnteredDate` <= @toResultEnteredDate ");
                    sbQuery.Append(" AND Flag ='High' ) a   ");
                    sbQuery.Append(" on a.Test_ID = pli.Test_ID   ");
                }
                else if (_Flag == "L")
                {
                    sbQuery.Append(" inner join  (SELECT `Test_ID` FROM `patient_labobservation_opd` WHERE  ");
                    sbQuery.Append(" `ResultEnteredDate` >= @fromResultEnteredDate ");
                    sbQuery.Append(" AND `ResultEnteredDate` <= @toResultEnteredDate ");
                    sbQuery.Append(" AND Flag ='Low' ) a   ");
                    sbQuery.Append(" on a.Test_ID = pli.Test_ID   ");
                }
                else if (_Flag == "CH")
                {
                    sbQuery.Append(" inner join  (SELECT `Test_ID` FROM `patient_labobservation_opd` WHERE  ");
                    sbQuery.Append(" `ResultEnteredDate` >= @fromResultEnteredDate ");
                    sbQuery.Append(" AND `ResultEnteredDate` <= @toResultEnteredDate ");
                    sbQuery.Append(" AND `MaxCritical`<>0 AND isnumeric(`Value`)=1 AND  CAST(`Value` AS DECIMAL(11,2)) > CAST(`MaxCritical` AS DECIMAL(11,2)) ) a   ");
                    sbQuery.Append(" on a.Test_ID = pli.Test_ID   ");
                }
                else if (_Flag == "CL")
                {
                    sbQuery.Append(" inner join  (SELECT `Test_ID` FROM `patient_labobservation_opd` WHERE  ");
                    sbQuery.Append(" `ResultEnteredDate` >= @fromResultEnteredDate ");
                    sbQuery.Append(" AND `ResultEnteredDate` <= @toResultEnteredDate ");
                    sbQuery.Append(" AND `MinCritical`<>0 AND isnumeric(`Value`)=1 AND  CAST(`Value` AS DECIMAL(11,2)) < CAST(`MinCritical` AS DECIMAL(11,2)) ) a   ");
                    sbQuery.Append(" on a.Test_ID = pli.Test_ID   ");
                }
            }
            sbQuery.Append(" Where pli.result_flag=1 and pli.approved=0 and pli.ishold=0 ");
            if (labSearch[0].Department != string.Empty)
                sbQuery.Append("  and pli.SubcategoryID=@Department ");

            if (labSearch[0].SearchValue != string.Empty)
            {
                if (labSearch[0].SearchType.Contains("pm."))
                {
                    sbQuery.AppendFormat(" AND {0} LIKE @LikeSearchValue ", labSearch[0].SearchType);
                }
                else
                {
                    sbQuery.AppendFormat(" AND {0}=@SearchValue ", labSearch[0].SearchType);
                }
            }
            if (Util.GetString(labSearch[0].Investigation) != string.Empty)
            {
                sbQuery.Append(" and pli.ItemID=@ItemID  ");
            }
            if (((labSearch[0].SearchType.Trim() == "lt.Patient_ID") || (labSearch[0].SearchType.Trim() == "pm.PName")) || ((labSearch[0].SearchValue.Trim() == "") && (labSearch[0].SearchType.Trim() == "pli.LedgerTransactionNo")))
            {
                sbQuery.Append(" AND pli.ResultEnteredDate>=@fromResultEnteredDate  ");
                sbQuery.Append(" AND pli.ResultEnteredDate<=@toResultEnteredDate  ");
            }
            sbQuery.Append(" AND pli.IsReporting=1 GROUP BY if(im.ReportType<>1,Pli.Test_ID, lt.`LedgerTransactionNo`),pli.BarcodeNo,plo.LabObservation_ID");

            sbQuery.Append(" order by  lt.Patient_ID,im.Print_Sequence,plo.Priorty ");

            using (MySqlDataAdapter da = new MySqlDataAdapter(sbQuery.ToString(), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@SearchValue", labSearch[0].SearchValue);
                da.SelectCommand.Parameters.AddWithValue("@LikeSearchValue", Util.GetString(labSearch[0].SearchValue) + "%");
                da.SelectCommand.Parameters.AddWithValue("@fromResultEnteredDate", string.Concat(Util.GetDateTime(labSearch[0].FromDate).ToString("yyyy-MM-dd"), ' ', Util.GetDateTime(labSearch[0].FromTime).ToString("HH-mm-ss")));
                da.SelectCommand.Parameters.AddWithValue("@toResultEnteredDate", string.Concat(Util.GetDateTime(labSearch[0].ToDate).ToString("yyyy-MM-dd"), ' ', Util.GetDateTime(labSearch[0].ToTime).ToString("HH-mm-ss")));
                da.SelectCommand.Parameters.AddWithValue("@Department", labSearch[0].Department);
                da.SelectCommand.Parameters.AddWithValue("@ItemID", labSearch[0].Investigation);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                }
                if (_Flag == "N")
                {
                    var dc = dt.Select("flag = 'High' or flag = 'Low'").CopyToDataTable().DefaultView.ToTable(true, "test_id");
                    foreach (DataRow dw in dc.Rows)
                    {
                        dt.AsEnumerable().Where(r => r.Field<int>("test_id") == Util.GetInt(dw[0].ToString())).ToList().ForEach(row => row.Delete());
                        dt.AcceptChanges();
                    }
                }
                if (dt.Rows.Count > 0)
                {
                    int count = dt.Rows.Count;
                    dt.Columns.Add("TotalRecord");
                    foreach (DataRow dw in dt.Rows)
                    {
                        dw["TotalRecord"] = dt.Rows.Count.ToString();
                    }
                    dt.AcceptChanges();
                }               
                return JsonConvert.SerializeObject(new { status = true, response = dt });
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
    [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = false)]
    public static string SaveLabObservationOpdData(string Testid, string ResultStatus, string ApprovedBy, string ApprovalName)
    {
        Testid = Testid.TrimEnd(',');
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {         
            string[] Investigation_IDTags = Testid.Split(',');
            string[] Investigation_IDParamNames = Investigation_IDTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string Investigation_IDClause = string.Join(", ", Investigation_IDParamNames);

            if (ResultStatus == "Approved")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE patient_labinvestigation_opd SET Approved = 1, ApprovedBy = @ApprovedBy,IsDispatch=1, ApprovedName = @ApprovedName,");
                sb.Append("ApprovedDoneBy=@ApprovedDoneBy,ApprovedDate=now(), ResultEnteredBy=if(Result_Flag=0,@ResultEnteredBy,ResultEnteredBy),");
                sb.Append("ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,@ResultEnteredName,ResultEnteredName),");
                sb.Append(" Result_Flag=1  WHERE   Test_ID IN ({0}) ");
               
                using (MySqlCommand m = new MySqlCommand(string.Format(sb.ToString(), Investigation_IDClause), con, tnx))
                {
                    for (int i = 0; i < Investigation_IDParamNames.Length; i++)
                    {
                        m.Parameters.AddWithValue(Investigation_IDParamNames[i], Investigation_IDTags[i]);
                    }
                    m.Parameters.AddWithValue("@ApprovedBy", ApprovedBy);
                    m.Parameters.AddWithValue("@ApprovedName", ApprovalName);
                    m.Parameters.AddWithValue("@ApprovedDoneBy", UserInfo.ID);
                    m.Parameters.AddWithValue("@ResultEnteredBy", UserInfo.ID);
                    m.Parameters.AddWithValue("@ResultEnteredName", UserInfo.LoginName);
                    m.ExecuteNonQuery();
                }
                

                sb = new StringBuilder();
                sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,'Report Approved & Dispatched',@UserID,@UserName,@IPaddress,@Centre, ");
                sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE   Test_ID IN ({0}) ");
                
                using (MySqlCommand m = new MySqlCommand(string.Format(sb.ToString(), Investigation_IDClause), con, tnx))
                {
                    for (int i = 0; i < Investigation_IDParamNames.Length; i++)
                    {
                        m.Parameters.AddWithValue(Investigation_IDParamNames[i], Investigation_IDTags[i]);
                    }
                    m.Parameters.AddWithValue("@UserID", UserInfo.ID);
                    m.Parameters.AddWithValue("@UserName", UserInfo.LoginName);
                    m.Parameters.AddWithValue("@IPaddress", StockReports.getip());
                    m.Parameters.AddWithValue("@Centre", UserInfo.Centre);
                    m.Parameters.AddWithValue("@RoleID", UserInfo.RoleID);
                    m.ExecuteNonQuery();
                }
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Success" });
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

    [WebMethod(EnableSession = true)]
    public static string GetTestMaster(string DepartmentID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string str = "";
            if (DepartmentID != "0")
                str = " select IF(im.TestCode='',typename,CONCAT(im.TestCode,' ~ ',typename)) testname,im.`ItemID` testid from f_itemmaster im where isactive=1 and im.subcategoryid<>'LSHHI44' and im.subcategoryid =@subcategoryid order by testname ";
            else
                str = "select IF(im.TestCode='',typename,CONCAT(im.TestCode,' ~ ',typename)) testname,im.`ItemID` testid from f_itemmaster im where isactive=1 and im.subcategoryid<>'LSHHI44'  order by testname";

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str,
                 new MySqlParameter("@subcategoryid ", DepartmentID)).Tables[0])
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
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
}
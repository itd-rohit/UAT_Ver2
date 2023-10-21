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
using System.Web.Script.Serialization;
public partial class Design_Lab_PatientLabSearchUnApprove : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            AllLoad_Data.getCurrentDate(txtFormDate, txtToDate);
            bindData();
        }
    }
    public class labSearchType
    {
        public string SearchType { get; set; }
    }
    public static List<labSearchType> SearchType()
    {
        List<labSearchType> patientSearchType = new List<labSearchType>();
        patientSearchType.Add(new labSearchType() { SearchType = "plo.BarcodeNo" });
        patientSearchType.Add(new labSearchType() { SearchType = "lt.Patient_ID" });
        patientSearchType.Add(new labSearchType() { SearchType = "plo.LedgerTransactionNo" });
        patientSearchType.Add(new labSearchType() { SearchType = "pm.mobile" });
        patientSearchType.Add(new labSearchType() { SearchType = "pm.pname" });
        return patientSearchType;
    }
    public static List<labSearchType> SearchDateType()
    {
        List<labSearchType> dateSearchType = new List<labSearchType>();
        dateSearchType.Add(new labSearchType() { SearchType = "plo.date" });
        dateSearchType.Add(new labSearchType() { SearchType = "plo.SampleReceiveDate" });
        dateSearchType.Add(new labSearchType() { SearchType = "plo.ApprovedDate" });
        return dateSearchType;
    }
    [WebMethod(EnableSession = true)]
    public static string GetUnapprovedreportlist(string TestID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            using (dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT  ReportType,DATE_FORMAT(UnapproveDate,'%d-%b-%y %i:%h %p') AS EntryDate, DATE_FORMAT(UnapproveDate,'%Y-%m-%d %H:%i:%S') AS Unique_Hash FROM report_unapprove WHERE test_id=@TestID order by UnapproveDate desc ",
                new MySqlParameter("@TestID", TestID)).Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
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

    [WebMethod(EnableSession = true)]
    public static string SearchPatient(object searchData, string stype, string PageNo, string PageSize)
    {
        List<patientLabSearch> labSearch = new JavaScriptSerializer().ConvertToType<List<patientLabSearch>>(searchData);

        HashSet<string> SearchTypes = new HashSet<string>(labSearch.Select(s => s.SearchType));
        if (SearchType().Where(m => SearchTypes.Contains(m.SearchType)).Count() == 0)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Invalid Data Found" });
        }
        HashSet<string> SearchDateTypes = new HashSet<string>(labSearch.Select(s => s.SearchByDate));
        if (SearchDateType().Where(m => SearchDateTypes.Contains(m.SearchType)).Count() == 0)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Invalid Data Found" });
        }  

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT 0 isold, plo.IsUrgent,DATE_FORMAT(lt.`Date`,'%d-%b-%Y %h:%i %p') EntryDate,lt.`LedgerTransactionNo`,plo.`BarcodeNo`,plo.barcode_group,plo.IsSampleCollected,IFNULL(plo.UpdateRemarks,'') UpdateRemarks,");
            sb.Append(" lt.`PName`,CONCAT(lt.`Age`,'/',lt.`Gender`) pinfo,pm.mobile,(SELECT centre FROM centre_master WHERE centreid=lt.centreid)centre,");
            sb.Append(" lt.`DoctorName`,lt.`PanelName`,obm.Name AS Dept,plo.`ItemName`,plo.`Test_ID`,");
            sb.Append(" plo.Approved,'' SampleStatus,");

            sb.Append(" CASE   WHEN plo.IsDispatch=1 AND plo.isFOReceive=1 THEN '#44A3AA' "); //Dispatched
            sb.Append(" WHEN plo.IsSampleCollected='R' THEN '#FF0000' ");//Sample Rejected
            sb.Append(" WHEN plo.isFOReceive=0 AND plo.Approved=1 AND plo.isPrint=1 THEN '#00FFFF'  "); //Printed
            sb.Append(" WHEN plo.isFOReceive='0' AND plo.Approved=1  THEN '#90EE90' "); //Approved
            sb.Append(" WHEN plo.Result_Flag=1 AND plo.isHold=0 AND plo.isForward=0 AND isPartial_Result=0 AND  plo.IsSampleCollected<>'R'  THEN '#FFC0CB'  "); //Tested
            sb.Append(" WHEN plo.isHold=1 THEN '#FFFF00' "); //Hold
            sb.Append(" WHEN plo.IsSampleCollected='N' THEN '#CC99FF'  ");//New
            sb.Append(" WHEN plo.IsSampleCollected='S' THEN 'bisque'  ");//Sample Collected
            sb.Append(" WHEN plo.IsSampleCollected='Y' THEN '#FFFFFF' "); //Department Receive
            sb.Append(" ELSE '#FFFFFF' END rowColor,  ");
            sb.Append(" if(plo.IsSampleCollected='S',(SELECT `Status` FROM  patient_labinvestigation_opd_update_status plus WHERE plus.BarcodeNo=plo.BarcodeNo ORDER BY dtEntry DESC LIMIT 1 ),'') LogisticStatus  ");

            sb.Append(" ,(SELECT COUNT(1) FROM `patient_labinvestigation_opd_remarks` WHERE Test_ID= plo.Test_ID AND isActive=1 ) Remarks ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo  ");
            sb.Append(" INNER JOIN patient_master pm on pm.patient_id=plo.patient_id");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` and plo.NotApprovedCount>0 ");
            if (Util.GetString(labSearch[0].Panel) != string.Empty)
            {
                sb.Append(" AND  lt.panel_id=@Panel_ID ");
            }
            if (Util.GetString(labSearch[0].ReferDoc) != string.Empty)
            {
                sb.Append(" AND  lt.`Doctor_ID`=@Doctor_ID");
            }
            if (labSearch[0].SinNo != string.Empty)
            {
                sb.Append(" AND plo.`BarcodeNo`=@BarcodeNo");
            }
            else if (labSearch[0].SearchValue != string.Empty)
            {
                if (labSearch[0].SearchType.Contains("pm."))
                {
                    sb.AppendFormat(" AND {0} LIKE @LikeSearchValue ", labSearch[0].SearchType);
                }
                else
                {
                    sb.AppendFormat(" AND {0}=@SearchValue ", labSearch[0].SearchType);
                }
            }
            else
            {
                sb.AppendFormat("  AND {0}>=@fromDateTime", labSearch[0].SearchByDate);
                sb.AppendFormat("  AND {0}<=@toDateTime ", labSearch[0].SearchByDate);
            }
            if (labSearch[0].IsUrgent == 1)
            {
                sb.Append(" and plo.isUrgent=1  ");
            }
            if (Util.GetString(labSearch[0].Investigation) != "")
            {
                sb.Append(" and plo.ItemID=@ItemID ");
            }
            switch (stype)
            {
                case "1":
                    sb.Append("  AND plo.IsSampleCollected='N'  ");//New
                    break;
                case "2":
                    sb.Append(" AND plo.IsSampleCollected = 'S' ");//Sample Collected
                    break;
                case "3":
                    sb.Append(" AND plo.IsSampleCollected = 'Y' and plo.Result_Flag=0  ");//Department Receive
                    break;
                case "4":
                    sb.Append(" AND plo.Result_Flag=0 And (SELECT COUNT(*) FROM mac_data mac WHERE mac.LedgerTransactionNO=plo.LedgerTransactionNO AND mac.Test_ID=plo.Test_ID AND IFNULL(Reading,'')<>'')>0 "); //Mac Data
                    break;
                case "5":
                    sb.Append(" AND plo.isrerun=1  AND plo.Result_flag=0 "); //Rerun
                    break;
                case "6":
                    sb.Append(" AND  plo.Result_Flag=1 AND plo.isHold=0 AND plo.isForward=0 AND isPartial_Result=1 AND   plo.Approved=0   ");//Incomplete
                    break;
                case "7":
                    sb.Append(" AND  plo.Result_Flag=1  and (plo.Approved is null or plo.Approved=0) and isForward=0 and plo.isHold=0  AND plo.isPartial_Result=0 and plo.Preliminary=0 "); //Tested
                    break;
                case "8":
                    sb.Append(" AND   plo.Approved=1 AND plo.isHold=0 AND plo.isPrint=0  "); //Approved
                    break;
                case "9":
                    sb.Append(" AND   plo.Approved=1 AND plo.isHold=0 AND plo.isPrint=1 AND plo.IsFOReceive=0  "); //Printed
                    break;
                case "10":
                    sb.Append(" AND   plo.isHold=1   "); //Hold
                    break;
                case "11":
                    sb.Append(" AND  plo.Result_Flag=1 AND plo.isHold=0 AND plo.isForward=1  ");//Forward
                    break;
                case "12":
                    sb.Append(" AND  plo.IsFOReceive=1 AND plo.IsDispatch=0  "); //Received
                    break;
                case "13":
                    sb.Append(" AND  plo.IsDispatch=1 AND plo.isFOReceive=1  "); //Dispatched
                    break;
                case "14":
                    sb.Append(" AND plo.IsSampleCollected = 'R' ");//Sample Rejected
                    break;
            }
            if (labSearch[0].UserID != "All")
            {
                sb.Append(" AND lt.`CreatedByID`=@CreatedByID");
            }
            if (labSearch[0].Centre != "ALL")
            {
                sb.Append("  AND lt.CentreID=@CentreID");
            }
            else
            {
                string RoleId = Util.GetString(HttpContext.Current.Session["RoleID"].ToString());
                if (RoleId != "212")
                {
                    sb.Append("  AND ( lt.CentreID in ( select ca.CentreAccess from  centre_access ca where ca.Centreid=@SessionCentreID )  or lt.CentreID=@SessionCentreID) ");
                }
            }
            sb.Append(" INNER JOIN f_panel_master fpm  ON lt.`Panel_ID` = fpm.`Panel_ID` ");
            if (labSearch[0].DispacthMode != "BOTH")
            {
                sb.Append(" AND ReportDispatchMode=@ReportDispatchMode");
            }

            sb.Append(" INNER JOIN f_subcategorymaster obm ON obm.subcategoryid=plo.subcategoryid ");
            if (Util.GetString(labSearch[0].Department) != string.Empty)
                sb.Append("  AND obm.subcategoryid=@Department ");
            sb.Append(" AND plo.IsReporting=1 and plo.ReportType<>5 ORDER BY plo.LedgerTransactionNo,plo.barcodeno, plo.`ItemName` ");
            if (PageNo != "0")
            {
                int from = Util.GetInt(PageSize) * Util.GetInt(PageNo);
                int to = Util.GetInt(PageSize);
                sb.AppendFormat(" limit {0},{1} ", from, to);
            }
            DataTable dtN = new DataTable();
            //System.IO.File.WriteAllText (@"D:\Shat\aa.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@Panel_ID", labSearch[0].Panel),
                   new MySqlParameter("@Doctor_ID", labSearch[0].ReferDoc),
                   new MySqlParameter("@BarcodeNo", labSearch[0].SinNo),
                   new MySqlParameter("@CentreID", labSearch[0].Centre),
                   new MySqlParameter("@SearchValue", labSearch[0].SearchValue),
                   new MySqlParameter("@LikeSearchValue", Util.GetString(labSearch[0].SearchValue) + "%"),
                   new MySqlParameter("@SessionCentreID", UserInfo.Centre),
                   new MySqlParameter("@fromDateTime", string.Concat(Util.GetDateTime(labSearch[0].FromDate).ToString("yyyy-MM-dd"), " ", Util.GetDateTime(labSearch[0].FromTime).ToString("HH-mm-ss"))),
                   new MySqlParameter("@toDateTime", string.Concat(Util.GetDateTime(labSearch[0].ToDate).ToString("yyyy-MM-dd"), " ", Util.GetDateTime(labSearch[0].ToTime).ToString("HH-mm-ss"))),
                   new MySqlParameter("@ReportDispatchMode", labSearch[0].DispacthMode),
                   new MySqlParameter("@ItemID", labSearch[0].Investigation),
                   new MySqlParameter("@Department", labSearch[0].Department),
                   new MySqlParameter("@CreatedByID", labSearch[0].UserID)).Tables[0])
            {
                if (PageNo == "0")
                {
                    if (dt.Rows.Count > 0)
                    {
                        int count = dt.Rows.Count;
                        dt.Columns.Add("TotalRecord");
                        foreach (DataRow dw in dt.Rows)
                        {
                            dw["TotalRecord"] = dt.Rows.Count.ToString();
                        }
                        dt.AcceptChanges();
                        dtN = dt.AsEnumerable().Skip(0).Take(Util.GetInt(PageSize)).CopyToDataTable();
                    }
                }              
            }
            return JsonConvert.SerializeObject(new { status = true, response = dtN });
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
    private void bindData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT em.Name,em.Employee_ID Employee_ID FROM f_login f ");
            sb.Append(" INNER JOIN employee_master em ON em.Employee_ID=f.EmployeeID ");
            if (HttpContext.Current.Session["RoleID"].ToString() == "214")
                sb.Append(" and f.EmployeeID=@EmployeeID");
            else
                sb.Append(" AND f.roleid IN('9','211','214') GROUP BY `Employee_ID` ORDER BY Name");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@EmployeeID", UserInfo.ID)).Tables[0])
            {

                ddlUser.DataSource = dt;
                ddlUser.DataTextField = "Name";
                ddlUser.DataValueField = "Employee_ID";
                ddlUser.DataBind();
                if (HttpContext.Current.Session["RoleID"].ToString() != "214")
                {
                    ddlUser.Items.Insert(0, new ListItem("ALL User", "All"));
                }
            }


            sb = new StringBuilder();
            sb.Append("  SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='LSHHI3'   ");
            if (Util.GetString(HttpContext.Current.Session["AccessDepartment"]) != string.Empty)
            {
                sb.Append("  AND  SubCategoryID IN({0}) ");
            }
            sb.Append(" ORDER BY NAME");

            string[] deptTags = String.Join(",", Util.GetString(HttpContext.Current.Session["AccessDepartment"]).Replace(",", "','")).Split(',');
            string[] deptParamNames = deptTags.Select((s, i) => "@tag" + i).ToArray();
            string deptClause = string.Join(", ", deptParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), deptClause), con))
            {
                for (int i = 0; i < deptParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(deptParamNames[i], deptTags[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    ddlDepartment.DataSource = dt;
                    ddlDepartment.DataTextField = "NAME";
                    ddlDepartment.DataValueField = "SubCategoryID";
                    ddlDepartment.DataBind();
                    ddlDepartment.Items.Insert(0, new ListItem("All Department", ""));
                }
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
    public class patientLabSearch
    {
        public string SearchType { get; set; }
        public string SearchValue { get; set; }
        public string Centre { get; set; }
        public string Department { get; set; }
        public string SearchByDate { get; set; }
        public string Panel { get; set; }
        public string FromDate { get; set; }
        public string FromTime { get; set; }
        public string ToDate { get; set; }
        public string ToTime { get; set; }
        public string Investigation { get; set; }
        public string SinNo { get; set; }
        public string ReferDoc { get; set; }
        public byte IsUrgent { get; set; }
        public string UserID { get; set; }
        public string DispacthMode { get; set; }
    }
    [WebMethod]
    public static string PostData(string ID)
    {
        return Util.getJson(new { LabID = Common.Encrypt(ID) });

    }
    [WebMethod]
    public static string PostRemarksData(string TestID, string TestName, string VisitNo)
    {
        return Util.getJson(new { TestID = Common.Encrypt(TestID), TestName = Common.Encrypt(TestName), VisitNo = Common.Encrypt(VisitNo) });

    }
}
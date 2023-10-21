using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using System.Linq;

public partial class PatientResultEntry : System.Web.UI.Page
{
    public string IsDefaultSing = string.Empty;
    public string ApprovalId = string.Empty;
    public string Year = DateTime.Now.Year.ToString();
    public string Month = DateTime.Now.ToString("MMM");

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                txtFromTime.Text = "00:00:00";
                txtToTime.Text = "23:59:59";
                txtSearchValue.Focus();
                if (Session["RoleID"] == null)
                {
                    Response.Redirect("~/Design/Default.aspx");
                }
                else
                {
                    string RoleID = Util.GetString(UserInfo.RoleID);
                    ApprovalId = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT max(`Approval`)  FROM `f_approval_labemployee` WHERE `RoleID`=@RoleID AND IF(`TechnicalId`='',`EmployeeID`,`TechnicalId`)=@EmployeeID",
                       new MySqlParameter("@RoleID", RoleID), new MySqlParameter("@EmployeeID", UserInfo.ID)));
                    IsDefaultSing = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT DefaultSignature  FROM `f_approval_labemployee` WHERE `RoleID`=@RoleID AND IF(`TechnicalId`='',`EmployeeID`,`TechnicalId`)=@EmployeeID Limit 1 ",
                        new MySqlParameter("@RoleID", RoleID), new MySqlParameter("@EmployeeID", UserInfo.ID)));
                }

                if (Util.GetString(Session["RoleID"]) == "15")
                {
                    ListItem selectedListItem = ddlSampleStatus.Items.FindByText("All Patient");

                    if (selectedListItem != null)
                    {
                        selectedListItem.Selected = true;
                    }
                }
                else if (ApprovalId == "5")
                {

                    ListItem selectedListItem = ddlSampleStatus.Items.FindByText("Tested");

                    if (selectedListItem != null)
                    {
                        selectedListItem.Selected = true;
                    }
                }
                else
                {
                    ListItem selectedListItem = ddlSampleStatus.Items.FindByText("Pending");

                    if (selectedListItem != null)
                    {
                        selectedListItem.Selected = true;
                    }
                }

                txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                txttatdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                BindDepartment(con);

                ddluser.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT NAME,employee_id FROM employee_master WHERE isactive=1 AND employee_id<>1 ORDER BY NAME ").Tables[0];
                ddluser.DataValueField = "employee_id";
                ddluser.DataTextField = "NAME";
                ddluser.DataBind();
                ddluser.Items.Insert(0, new ListItem("Select User", "0"));
                // bindInvestigation();
                BindMachine(con);
                BindMacMaster(con);
                BindApprovedBy(con);
                BindTestDon(con);
                if (UserInfo.ID == 561)
                {
                    ddlDepartment.SelectedValue = "1";
                    ddlDepartment.Enabled = false;
                }
                // Open Page From Test Approval Screen

                if (Util.GetString(Request.QueryString["fromdate"]) != string.Empty)
                {
                    txtFormDate.Text = Util.GetString(Request.QueryString["fromdate"]);
                    txtToDate.Text = Util.GetString(Request.QueryString["todate"]);
                    txtFromTime.Text = Util.GetString(Request.QueryString["fromtime"]);
                    txtToTime.Text = Util.GetString(Request.QueryString["totime"]);

                    if (Util.GetString(Request.QueryString["department"]) != string.Empty)
                    {
                        ddlDepartment.SelectedIndex = ddlDepartment.Items.IndexOf(ddlDepartment.Items.FindByValue(Util.GetString(Request.QueryString["department"])));
                    }

                    using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " select  cm.CentreID,cm.Centre Centre from centre_master cm where cm.CentreID = @CentreID ",
                          new MySqlParameter("@CentreID", Util.GetString(Request.QueryString["centre"]))).Tables[0])
                    {

                        ddlCentreAccess.DataSource = dt;
                        ddlCentreAccess.DataTextField = "Centre";
                        ddlCentreAccess.DataValueField = "CentreID";
                        ddlCentreAccess.DataBind();
                        ListItem selectedListItem = ddlSampleStatus.Items.FindByText("Tested");
                        if (selectedListItem != null)
                        {
                            selectedListItem.Selected = true;
                        }
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "$('#back').show();SearchSampleCollection();", true);

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
    }

    private void BindApprovedBy(MySqlConnection con)
    {
        using (DataTable dtApproval = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DISTINCT em.Name, fa.EmployeeID FROM f_approval_labemployee fa INNER JOIN employee_master em ON em.Employee_ID=fa.EmployeeID   " +
   " AND IF(fa.`TechnicalId`='',fa.`EmployeeID`,fa.`TechnicalId`)=@EmployeeID AND fa.`RoleID`=@RoleID WHERE fa.Approval IN (1,3,4)  " +
   " ORDER BY fa.isDefault DESC,em.Name ",
    new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@EmployeeID", UserInfo.ID)).Tables[0])
        {
            ddlApprove.DataSource = dtApproval;
            ddlApprove.DataTextField = "Name";
            ddlApprove.DataValueField = "EmployeeID";
            ddlApprove.DataBind();
            if (dtApproval.Rows.Count == 1)
            {
                ddlApprove.Enabled = false;
            }
        }
    }
    private void BindMachine(MySqlConnection con)
    {
        try
        {
            ddlMachine.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT MachineID FROM `machost_uat_ver1`.`mac_machinemaster` where centreid=@CentreID  ORDER BY MachineID",
               new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0];
            ddlMachine.DataTextField = "MachineID";
            ddlMachine.DataValueField = "MachineID";
            ddlMachine.DataBind();
            ddlMachine.Items.Insert(0, new ListItem("ALL Machine", "ALL"));
        }
        catch
        {
            ddlMachine.Items.Insert(0, new ListItem("ALL Machine", "ALL"));
        }
    }
    private void BindMacMaster(MySqlConnection con)
    {
        try
        {
            ddlMacMaster.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT  groupid ,MachineID FROM `machost_uat_ver1`.`mac_machinemaster` where centreid=@CentreID  ORDER BY MachineID",
               new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0];
            ddlMacMaster.DataTextField = "MachineID";
            ddlMacMaster.DataValueField = "MachineID";
            ddlMacMaster.DataBind();
            ddlMacMaster.Items.Insert(0, new ListItem("Machine Pending Test", "ALL"));
            ddlMacMaster.Items.Insert(1, new ListItem("Miscellaneous", "1"));
        }
        catch
        {
            ddlMacMaster.Items.Insert(0, new ListItem("ALL Machine", "ALL"));
        }
    }
    private void BindDepartment(MySqlConnection con)
    {
        List<string> ObservationType_ID = Util.GetString(HttpContext.Current.Session["AccessDepartment"]).TrimEnd(',').Split(',').ToList<string>();

        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='LSHHI3'   ");
        if (Util.GetString(HttpContext.Current.Session["AccessDepartment"]) != string.Empty)
        {
            sb.Append("  and  SubCategoryID in ({0}) ");
        }
        sb.Append(" ORDER BY NAME");
        DataTable dt = new DataTable();
        using (dt as IDisposable)
        {
            using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", ObservationType_ID)), con))
            {
                for (int i = 0; i < ObservationType_ID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@ObservationType_IDParam", i), ObservationType_ID[i]);
                }
                da.Fill(dt);
                sb = new StringBuilder();
                ObservationType_ID.Clear();
            }
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "NAME";
            ddlDepartment.DataValueField = "SubCategoryID";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, new ListItem("All Department", string.Empty));
        }
    }

    private void BindTestDon(MySqlConnection con)
    {
        ddlTestDon.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT * FROM macmaster WHERE IsActive=1").Tables[0];
        ddlTestDon.DataTextField = "Name";
        ddlTestDon.DataValueField = "ID";
        ddlTestDon.DataBind();
        ddlTestDon.Items.Insert(0, new ListItem(string.Empty, string.Empty));
    }


    [WebMethod(EnableSession = true)]
    public static string bindAccessCentre()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb=new StringBuilder();
            if (UserInfo.CentreType == "PUP" || UserInfo.LoginType == "PCC" || UserInfo.LoginType.ToUpper() == "SUBPCC")
                sb.Append(" select distinct cm.CentreID,cm.Centre Centre from centre_master cm where ( cm.CentreID =@CentreID )  and cm.isActive=1 order by cm.centrecode,cm.Centre ");
            else
                sb.Append(" select distinct cm.CentreID,cm.Centre Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID =@CentreID ) or cm.CentreID = @CentreID) and cm.isActive=1 order by cm.centrecode,cm.Centre ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0])
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
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
    public static string GetPanelMaster(string centreid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string q1 = string.Empty;
            if (centreid == "ALL")
            {
                q1 = " SELECT  pm.`Panel_ID`,CONCAT (IF(IFNULL(pm.panel_code,'')='',pm.`Panel_ID`,pm.panel_code), ' ~ ',pm.company_name) company_name FROM Centre_Panel cp   ";
                q1 += " INNER JOIN f_panel_master pm ON cp.PanelId=pm.panel_id and cp.CentreId in(select  cm.CentreID from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID =@CentreID ) or cm.CentreID = @CentreID) and cm.isActive=1) and pm.isactive=1  GROUP  BY pm.`Panel_ID` order by company_name";
            }
            else
            {
                q1 = "SELECT  pm.`Panel_ID`,CONCAT (IF(IFNULL(pm.panel_code,'')='',pm.`Panel_ID`,pm.panel_code), ' ~ ',pm.company_name) company_name  FROM Centre_Panel cp   ";
                q1 += " INNER JOIN f_panel_master pm ON cp.PanelId=pm.panel_id and cp.CentreId=Centre_ID and pm.isactive=1  GROUP  BY pm.`Panel_ID` order by company_name";

            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, q1.ToString(),
                  new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@Centre_ID", centreid)).Tables[0])
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
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
    public static string GetTestMaster()
    {
        using (DataTable dt = StockReports.GetDataTable("select IF(im.TestCode='',typename,CONCAT(im.TestCode,' ~ ',typename)) testname,im.`ItemID` testid from f_itemmaster im where isactive=1 and im.subcategoryid<>'LSHHI44' order by testname"))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    public static List<machineResultEntry> resultEntrySearchType()
    {
        List<machineResultEntry> resultEntry = new List<machineResultEntry>();
        resultEntry.Add(new machineResultEntry() { SearchType = "pli.BarcodeNo" });
        resultEntry.Add(new machineResultEntry() { SearchType = "lt.Patient_ID" });
        resultEntry.Add(new machineResultEntry() { SearchType = "pli.LedgerTransactionNo" });
		resultEntry.Add(new machineResultEntry() { SearchType = "pm.PName" });
        resultEntry.Add(new machineResultEntry() { SearchType = "lt.srfno" });
        return resultEntry;
    }
    public class machineResultEntry
    {
        public string SearchType { get; set; }
    }
    public class machineResultEntrySampColl
    {
        public string SampColl { get; set; }
    }
    public static List<machineResultEntry> resultEntrySearchTypeSampColl()
    {
        List<machineResultEntry> resultEntry = new List<machineResultEntry>();
        resultEntry.Add(new machineResultEntry() { SearchType = " and pli.isSampleCollected<>'N' " });
        resultEntry.Add(new machineResultEntry() { SearchType = " and pli.Result_flag=0  and pli.isSampleCollected<>'N'  and pli.isSampleCollected<>'R' " });
        resultEntry.Add(new machineResultEntry() { SearchType = " and pli.isSampleCollected='S' and pli.Result_flag=0" });

        resultEntry.Add(new machineResultEntry() { SearchType = " and pli.isSampleCollected='Y' and pli.Result_flag=0" });
        resultEntry.Add(new machineResultEntry() { SearchType = " and  pli.Result_Flag='0'  and pli.isSampleCollected<>'R'  and (select count(*) from mac_data md where md.Test_ID=pli.Test_ID  and md.reading<>'')>0" });
        resultEntry.Add(new machineResultEntry() { SearchType = " and pli.Result_flag=1 and pli.approved=0 and pli.ishold='0'  and pli.isSampleCollected<>'R'" });
        resultEntry.Add(new machineResultEntry() { SearchType = " and pli.Result_flag=1 and pli.isForward=1 and pli.Approved=0  and pli.isSampleCollected<>'R'" });
        resultEntry.Add(new machineResultEntry() { SearchType = " and pli.Result_flag=0 and pli.isrerun=1 and  pli.isSampleCollected<>'N'  and pli.isSampleCollected<>'R'" });
        resultEntry.Add(new machineResultEntry() { SearchType = " and pli.Approved=1 and pli.isPrint=0 and pli.isSampleCollected<>'R'" });
        resultEntry.Add(new machineResultEntry() { SearchType = " and pli.isHold='1'" });
        resultEntry.Add(new machineResultEntry() { SearchType = " and pli.isPrint=1  and pli.isSampleCollected<>'R'" });
        resultEntry.Add(new machineResultEntry() { SearchType = " and pli.isSampleCollected='R'" });
        return resultEntry;
    }
    [WebMethod]
    public static string PatientSearch(string SearchType, string SearchValue, string FromDate, string ToDate, string CentreID, string SmpleColl, string Department, string MachineID, string MacGroupid, string ZSM, string TimeFrm, string TimeTo, string isUrgent, string InvestigationId, string PanelId, string SampleStatusText, string chremarks, string chcomments, string BookingUser, string ColourCode, string addon, string ResultType, string camp, string TATOption, string SearchDateby)
    {

        if (SearchValue == string.Empty)
        {
            string rresult = Util.DateDiffPatientsearch(Util.GetDateTime(ToDate), Util.GetDateTime(FromDate));

            if (rresult == "true")
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Your From date ,To date Diffrence is too  Long" });
            }
        }
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Your Session Expired.... Please Login Again" });
        }

        if (resultEntrySearchType().Any(cus => cus.SearchType == SearchType) == false)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Invalid Data Found" });
        }
        if (resultEntrySearchTypeSampColl().Any(cus => cus.SearchType.Trim() == SmpleColl.Trim()) == false)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Invalid Data Found" });
        }




        StringBuilder sbQuery = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            List<string> InvID = new List<string>();
            InvestigationId = InvestigationId ?? string.Empty;
            if (InvestigationId != string.Empty)
                InvID = InvestigationId.Trim().Split(',').ToList<string>();

            List<string> ObservationType_ID = Util.GetString(HttpContext.Current.Session["AccessDepartment"]).TrimEnd(',').Split(',').ToList<string>();
            sbQuery.Append(" select * from ( ");
            sbQuery.Append("  SELECT lt.ReVisit, sum(pli.isRerun) isrerun,pli.IsEdited, concat(pli.CurrentSampleDept,'-->',pli.ToSampleDept)CombinationSampleDept,'' ReferLab,pli.Approved, ");
            sbQuery.Append("  DATE_FORMAT(pli.date, '%d-%b-%y %H:%i') RegDate,DATE_FORMAT(pli.SRADate, '%d-%b-%y %H:%i') SRADate,DATE_FORMAT(pli.SampleReceiveDate, '%d-%b-%y %H:%i') DATE,pli.`LedgerTransactionNo`,'' SampleLocation,pli.CombinationSample,");
            if (UserInfo.RoleID==15)
                sbQuery.Append(" pm.`PName`,");
            else
                sbQuery.Append(" lt.`PName`,");
            sbQuery.Append("CONCAT(lt.`Age`,'/',lt.`Gender`) Age_Gender,lt.`Gender`,lt.srfno,lt.Patient_ID,pm.Mobile,");
            sbQuery.Append(" lt.doctorname AS Doctor,cm.Centre,pli.`BarcodeNo`,pli.SampleTypeName, lt.panelname,  GROUP_CONCAT(distinct  im.Name) AS Test,CAST(GROUP_CONCAT(distinct pli.Test_ID)AS CHAR)Test_ID");
            sbQuery.Append(" ,pm.TotalAgeInDays AGE_in_Days,lt.ClinicalHistory  ");
            sbQuery.Append(",  IFNULL((SELECT Remarks FROM patient_labinvestigation_opd_remarks plor WHERE plor.Test_ID =pli.Test_ID And IsActive=1 ORDER BY ID DESC LIMIT 1 ),'')RemarkStatus");
            sbQuery.Append(", IFNULL((SELECT ID FROM document_detail dd WHERE dd.`labNo`=lt.`LedgerTransactionNo` And IsActive=1 LIMIT 1 ),'')DocumentStatus");
            sbQuery.Append(" , IF( IF(pli.Approved=0,NOW(),pli.ApprovedDate) > pli.DeliveryDate,'1','0') TATDelay,IF(pli.isurgent = 1,'Y','N')Urgent");

            //Bilal-
            sbQuery.Append(" , IF(pli.`DeliveryDate`='0001-01-01 00:00:00','0',IF(IF(pli.Approved=0,NOW(),pli.ApprovedDate) > DATE_ADD(pli.DeliveryDate ,INTERVAL im.tatintimation*-1 MINUTE),'1','0')) TATIntimate");
            sbQuery.Append(" ,TIMEDIFF(pli.`DeliveryDate`,IF(pli.Approved=0,NOW(),pli.ApprovedDate)) timeDiff ");

            sbQuery.Append(" ,CASE ");
            sbQuery.Append(" WHEN COUNT(pli.isPrint)=SUM(pli.isPrint) THEN 'Printed' ");
            sbQuery.Append(" WHEN COUNT(pli.Approved)=SUM(pli.Approved) THEN 'Approved' ");
            sbQuery.Append(" WHEN COUNT(pli.isHold)=SUM(pli.isHold) THEN 'Hold' ");
            sbQuery.Append("   WHEN COUNT(pli.Result_Flag)=SUM(pli.Result_Flag)  and   SUM(pli.isForward*pli.Result_Flag)=0 THEN 'Tested' ");
            sbQuery.Append("   WHEN COUNT(pli.isForward)=SUM(pli.isForward) THEN  'Forwarded' ");
            if (MacGroupid.Trim() == "ALL")
                sbQuery.Append("   WHEN (select count(1) from mac_Data where reading<>'' and Test_ID=pli.Test_ID)>0 and pli.Result_Flag=0 THEN 'MacData' ");

            sbQuery.Append("  WHEN COUNT(pli.isSampleCollected)=SUM(IF(pli.isSampleCollected='N',1,0)) THEN  'Not-Collected' ");
            sbQuery.Append("   WHEN COUNT(pli.isSampleCollected)=SUM(IF(pli.isSampleCollected='S',1,0)) THEN 'Collected' ");
            sbQuery.Append("  WHEN COUNT(pli.isSampleCollected)=SUM(IF(pli.isSampleCollected='Y',1,0)) THEN 'Received' ");
            sbQuery.Append("  WHEN COUNT(pli.isSampleCollected)=SUM(IF(pli.isSampleCollected='R',1,0)) THEN 'Rejected' ");
            sbQuery.Append("  ELSE 'NA'  ");
            sbQuery.Append("  END `Status` ");
            sbQuery.Append(" ,'' Comments, MAX(pli.IsCriticalResult) IsCriticalResult,MAX(pli.IsNormalResult) IsNormalResult ,CASE WHEN (NOW() <=  pli.DeliveryDate AND NOW() >= (pli.DeliveryDate - INTERVAL 30 MINUTE)) THEN 'Alert' ELSE '' END TATMessage ,Count(distinct pli.Test_ID)TestCount  ");
            sbQuery.Append(" FROM ");
            if (SearchType == "pli.BarcodeNo" && SearchValue.Trim() != string.Empty)
            {
                sbQuery.Append(" (select * from `patient_labinvestigation_opd`  where BarcodeNo = @BarcodeNo  ) pli ");
            }
            else
            {
                sbQuery.Append(" `patient_labinvestigation_opd` pli ");
            }
            sbQuery.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID`  ");
            if (BookingUser != "0")
            {
                sbQuery.Append(" and lt.CreatedByID=@CreatedByID");
            }
            sbQuery.Append(" INNER JOIN `investigation_master` im ON im.investigation_ID=pli.investigation_ID and im.isCulture=0  ");
            if (UserInfo.RoleID == 15)
                sbQuery.Append(" and im.ReportType= 5 ");
            else
                sbQuery.Append(" and im.ReportType<>7 and im.ReportType<> 5 ");
            sbQuery.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
            sbQuery.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID` ");
            sbQuery.Append(" INNER JOIN investigation_observationtype iot on iot.Investigation_ID=pli.Investigation_ID  ");

           
            
            if (Department != string.Empty)
                sbQuery.Append("  and iot.ObservationType_ID=@ObservationType_ID ");

            else if (Util.GetString(HttpContext.Current.Session["AccessDepartment"]) != string.Empty)
            {
                sbQuery.Append("  and iot.ObservationType_ID in ({1})  ");
            }

            if (CentreID != "ALL")
            {
                sbQuery.Append("  and IF(ifnull(pli.ForwardToDoctor,0)!=0, ( pli.TestCentreID=@Centre_ID or pli.ForwardToCentre=@Centre_ID ) , pli.TestCentreID=@Centre_ID) ");
            }
            else
            {
                sbQuery.Append("  and IF(ifnull(pli.ForwardToDoctor,0)!=0, ( pli.TestCentreID in ( select ca.CentreAccess from   centre_access ca where  ca.Centreid=@CentreID )   or pli.TestCentreID=@CentreID or  pli.ForwardToCentre in ( select ca.CentreAccess from   centre_access ca where  ca.Centreid=@CentreID )   or pli.ForwardToCentre=@CentreID ) ,  ");
                //sbQuery.Append("   ( pli.TestCentreID in ( select ca.CentreAccess from   centre_access ca where  ca.Centreid=@CentreID )   or pli.TestCentreID=@CentreID ");
                if (SmpleColl == " and pli.isSampleCollected<>'N' " || ColourCode=="17")   //All Patient
                {
                    sbQuery.Append("   ( if(pli.isSampleCollected='S',pli.issamplecollected='S' and pli.CentreID=@CentreID   , pli.TestCentreID=@CentreID)))  ");
                }
                else
                {
                    sbQuery.Append("   (  pli.TestCentreID=@CentreID ");
                    if (SmpleColl == " and pli.isSampleCollected='S' and pli.Result_flag=0 ")
                        sbQuery.Append(" or issamplecollected='S' ");
                    sbQuery.Append(" ) ) ");
                }
            }
            if (InvID.Count > 0)
            {
               // sbQuery.Append("  and pli.`Investigation_ID` in ({0}) ");
                sbQuery.Append("  and (pli.`Investigation_ID` in ({0})  or pli.`ItemID` in({0})) ");
            }
            if ((PanelId ?? string.Empty) != string.Empty)
            {
                sbQuery.Append("  and lt.panel_id=@PanelId ");
            }
            //Bilal
            if (camp != "0")
            {
                sbQuery.Append("  and lt.IsCamp=1 ");
            }

            if (isUrgent == "1")
            {
                sbQuery.Append(" and pli.isUrgent=1  ");
            }

            if (addon == "1")
            {
                sbQuery.Append(" and pli.IsEdited=1  "); // Also use  for new test added
            }
            else if (ColourCode == "14")
            {

                sbQuery.Append(" and pli.IsEdited=1  ");
            }
            else if (ColourCode == "1")///MacData
            {
                sbQuery.Append(" and pli.Result_Flag='0' And (SELECT COUNT(*) FROM mac_data mac WHERE  mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>'')>0 ");
                //sb.Append(" AND mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>'')>0 ");
            }
            else if (ColourCode == "2")
            {
                sbQuery.Append(" AND pli.IsSampleCollected = 'R' ");
            }
            else if (ColourCode == "3")
            {
                sbQuery.Append(" AND (pli.IsSampleCollected='N' OR pli.IsSampleCollected='S')  ");
            }
            else if (ColourCode == "4") //Tested
            {
                //sbQuery.Append(" AND  pli.Result_Flag=1  and (pli.Approved is null or pli.Approved=0) and isForward=0 and pli.isHold=0  AND pli.isPartial_Result=0  ");
				sbQuery.Append(" and pli.Result_flag=1 and (pli.Approved is null or pli.Approved=0) and isForward=0 and pli.ishold='0'  and pli.isSampleCollected<>'R' ");
            }
            else if (ColourCode == "5") ////Pending 
            {
                sbQuery.Append(" AND  pli.Result_Flag=0  and pli.IsSampleCollected='Y'   ");
            }
            else if (ColourCode == "6")//Approved
            {
                sbQuery.Append(" AND   pli.Approved=1 AND pli.isHold=0  AND pli.isPrint=0  ");
            }
			else if (ColourCode == "16")//Auto Approved
            {
                sbQuery.Append(" AND pli.isHold=0  AND pli.isPrint=0 AND pli.AutoApproved=1 ");
            }
			
            else if (ColourCode == "7")
            {
                sbQuery.Append(" AND  pli.Result_Flag=1 AND pli.isHold=0 AND pli.isForward=0 AND isPartial_Result=1 AND   pli.Approved=0  ");
            }
            else if (ColourCode == "8")//Hold
            {
                sbQuery.Append(" AND   pli.isHold=1  ");
            }
            else if (ColourCode == "9")
            {
                sbQuery.Append(" AND  pli.Result_Flag=1 AND pli.isHold='0' AND pli.isForward=1  ");
            }
            else if (ColourCode == "10")///Printed
            {
                sbQuery.Append(" AND  pli.isFOReceive='0' AND pli.Approved=1 AND pli.isPrint=1  ");
                sbQuery.Append("  AND pli.date >=@FromDate ");
                sbQuery.Append(" AND pli.date <=@ToDate ");
            }
            else if (ColourCode == "11")
            {
                sbQuery.Append(" AND  pli.IsFOReceive=1  ");

            }
            else if (ColourCode == "12")
            {
                sbQuery.Append(" AND  pli.IsDispatch=1 AND pli.isFOReceive=1  ");
            }
            else if (ColourCode == "13") //ReRun
            {
                sbQuery.Append(" and pli.isrerun=1  AND pli.Result_flag=0 ");
            }
            else if (ColourCode == "15")//Forwarded
            {
                sbQuery.Append(" and pli.isForward = 1  ");
            }
            else if (ColourCode == "17")
            {
                sbQuery.Append(" and pli.isSampleCollected='S' and pli.Result_flag=0 ");
            }
            else if (ColourCode == "22")
            {
                sbQuery.Append(" and pli.isautoconsume=0 and pli.autoconsumeoption>0 AND pli.Result_flag=0 and IsSampleCollected='Y' ");
            }
           // if (MachineID.Trim() != "ALL")
               // sbQuery.Append(" inner join mac_data md on md.Test_ID=pli.Test_ID and md.MachineName =@MachineName");
            //if (MacGroupid.Trim() != "ALL")
           // {
                //sbQuery.Append(" inner JOIN investigation_machinemaster imm ON imm.`CentreID`=@CentreID AND imm.`Investigation_ID` = pli.`Investigation_ID`  ");
                //sbQuery.Append(" and imm.MachineID=@MachineID  ");
           // }
		   if (MachineID.Trim() != "ALL")
            sbQuery.Append(" inner join mac_data md on md.Test_ID=pli.Test_ID and md.MachineName='" + MachineID + "'  and md.`centreid`=pli.`TestCentreID` ");

            if (!SmpleColl.Contains("having") && ColourCode == string.Empty)
            {
                sbQuery.AppendFormat(" {0} ", SmpleColl);
            }
            if (SearchValue.Trim() != string.Empty)
            {
				if (SearchType == "pm.PName")
                    sbQuery.Append(" and pm.PName like '%"+ SearchValue.Trim() +"%'");
				else
                sbQuery.AppendFormat(" and {0} = @SearchValue ", SearchType);
               // if (SampleStatusText != "Tested")
               // {
               //    // if (SampleStatusText != "Pending")
               //    // {
               //         sbQuery.Append("  AND pli.SampleCollectionDate >=@FromDate ");
               //         sbQuery.Append(" AND pli.SampleCollectionDate <=@ToDate ");
               //    // }
               // }

            }
            if (SampleStatusText == "Tested" && ColourCode == string.Empty)
            {

                sbQuery.Append("  and if(ifnull(pli.ForwardToDoctor,0)!=0, ForwardToDoctor=@UserID, pli.isForward=0) ");

            }

            if (((SearchValue.Trim() != "") && (SearchType.Trim() == "pm.PName")) ||((SearchValue.Trim() == string.Empty) && (SearchType.Trim() != "lt.Patient_ID")) || ((SearchValue.Trim() == string.Empty) && (SearchType.Trim() != "pli.BarcodeNo")))
            {

               // if (SampleStatusText != "Pending")
                //{
                    sbQuery.Append("  AND pli.SampleCollectionDate >=@FromDate ");
                    sbQuery.Append(" AND pli.SampleCollectionDate <=@ToDate ");
                //}
            }
            if (ResultType != "0")
            {
                if (ResultType == "1")
                {
                    sbQuery.Append(" AND pli.IsNormalResult in (2,3) AND pli.IsCriticalResult='0' ");
                }
                else
                {
                    sbQuery.Append(" AND pli.IsCriticalResult='1' ");
                }

            }

            // Search By date

            if (SearchDateby == "Registeration Date")
            {
                sbQuery.Append(" and pli.`Date`>=@FromDate");
                sbQuery.Append(" and pli.`Date`<=@ToDate");
            }

            //SRADate
            if (SearchDateby == "Sample Collection Date")
            {
                sbQuery.Append(" and pli.`SampleCollectionDate`>=@FromDate");
                sbQuery.Append(" and pli.`SampleCollectionDate`<=@ToDate");
            }

            if (SearchDateby == "Approved Date")
            {
                sbQuery.Append(" and pli.`ApprovedDate`>=@FromDate");
                sbQuery.Append(" and pli.`ApprovedDate`<=@ToDate");
            }



            if (SearchDateby == "Department Recive Date")
            {
                sbQuery.Append(" and pli.`SampleReceiveDate`>=@FromDate");
                sbQuery.Append(" and pli.`SampleReceiveDate`<=@ToDate");
            }

            //--------"Tissue for Processing" can be show for  Grocess & sliding only. Not for Reporting  by Apurva 20-08-2018

            sbQuery.Append(" AND im.Investigation_ID <> '1932' AND im.Investigation_ID <> '2035' ");
            if(UserInfo.RoleID==15)
            {
             sbQuery.Append(" AND pli.IsReporting='1' GROUP BY pli.Test_id");
            }
            else
            {
           // sbQuery.Append(" AND pli.IsReporting='1' GROUP BY  lt.`LedgerTransactionNo`,pli.SubCategoryID");
                sbQuery.Append(" AND pli.IsReporting='1' GROUP BY IF (pli.ReportType='3',pli.test_ID,CONCAT(lt.`LedgerTransactionNo`,pli.SubCategoryID ))");
}

            if (SmpleColl.Contains("having") && ColourCode == string.Empty)
            {
                sbQuery.AppendFormat(" {0} ", SmpleColl);
            }


            if (SampleStatusText == "Tested" && ColourCode == string.Empty)
            {
                sbQuery.Append(" order by pli.SRADate asc,TATDelay desc, pli.SampleReceiveDate asc ");//pli.isurgent
            }
            else
            {
                sbQuery.Append(" order by pli.SRADate Desc,TATDelay desc, pli.SampleReceiveDate asc ");//,pli.isurgent
            }


            if (SearchValue.Trim() != string.Empty)
            {
                sbQuery.Append(" limit 1000");
            }
            //bilal
            sbQuery.Append(" ) tbl ");

            if (TATOption == "1")
            {
                sbQuery.Append(" where tatdelay=0 and TATIntimate=0");
            }
            if (TATOption == "2")
            {
                sbQuery.Append(" where tatdelay=0 and TATIntimate=1");
            }
            if (TATOption == "3")
            {
                sbQuery.Append(" where tatdelay=1 ");
            }
      //      if(UserInfo.ID==1)
   // System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\mac.txt",sbQuery.ToString());
            using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sbQuery.ToString(), string.Join(",", InvID), string.Join(",", ObservationType_ID)), con))
            {

                da.SelectCommand.Parameters.AddWithValue("@UserID", UserInfo.ID);
                da.SelectCommand.Parameters.AddWithValue("@CentreID", UserInfo.Centre);
                da.SelectCommand.Parameters.AddWithValue("@MachineID", MacGroupid);
                da.SelectCommand.Parameters.AddWithValue("@MachineName", MachineID);
                da.SelectCommand.Parameters.AddWithValue("@FromDate", string.Concat(Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"), " ", TimeFrm));
                da.SelectCommand.Parameters.AddWithValue("@ToDate", string.Concat(Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"), " ", TimeTo));
                da.SelectCommand.Parameters.AddWithValue("@ObservationType_ID", Department);
                da.SelectCommand.Parameters.AddWithValue("@CreatedByID", BookingUser);
                da.SelectCommand.Parameters.AddWithValue("@BarcodeNo", SearchValue.Trim());
                da.SelectCommand.Parameters.AddWithValue("@Centre_ID", CentreID);
                if ((PanelId ?? string.Empty) != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@PanelId", PanelId);
                da.SelectCommand.Parameters.AddWithValue("@SearchValue", SearchValue.Trim());
                for (int i = 0; i < InvID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@InvIDParam", i), InvID[i]);
                }
                for (int i = 0; i < ObservationType_ID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@ObservationType_IDParam", i), ObservationType_ID[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    sbQuery = new StringBuilder();
                    InvID.Clear();
                    ObservationType_ID.Clear();
                    if (dt.Rows.Count > 0)
                    {
                        int TotalTest = Convert.ToInt32(dt.Compute("SUM(TestCount)", string.Empty));
                        DataColumn dc = new DataColumn("TotalTestPatient", typeof(Int32));
                        dc.DefaultValue = TotalTest;
                        dt.Columns.Add(dc);

                        int CountPatient = 0;
                        var LabNo = "";
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            if (Util.GetString(dt.Rows[i]["LedgerTransactionNo"]) != LabNo)
                            {
                                CountPatient = CountPatient+1;
                                LabNo = Util.GetString(dt.Rows[i]["LedgerTransactionNo"]);
                            }
                        }
                        DataColumn dc1 = new DataColumn("TotalTest", typeof(Int32));
                        dc1.DefaultValue = CountPatient;
                        dt.Columns.Add(dc1);
                    }
                    return JsonConvert.SerializeObject(new { status = true, response = dt });

                }
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
    public static string UpdateLabInvestigationOpdData(string TestID, string Barcode, string LedgerTransactionNo)
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(9);
        int ReqCount = MT.GetIPCount(9);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return "Too Many Request,Try Again after some";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int IsAvail = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(BarcodeNo) from patient_labinvestigation_opd  where BarcodeNo=@BarcodeNo and  LedgerTransactionNo<>@LedgerTransactionNo",
               new MySqlParameter("@BarcodeNo", Barcode), new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo)));
            if (IsAvail == 0)
            {
                int j = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET BarcodeNo = @BarcodeNo, macStatus = @macStatus WHERE Test_ID IN @Test_ID AND LedgerTransactionNo=@LedgerTransactionNo",
                           new MySqlParameter("@BarcodeNo", Barcode), new MySqlParameter("@macStatus", 0),
                           new MySqlParameter("@Test_ID", TestID.Replace(",", "','")), new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo));
                if (j > 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE from mac_data where Test_ID IN @Test_ID AND LedgerTransactionNo=@LedgerTransactionNo",
                       new MySqlParameter("@Test_ID", TestID.Replace(",", "','")),
                       new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo));
                }
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Vial ID Already Exit" });

            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Success" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
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
    public static string GetPatientInvsetigationsNameOnly(string LabNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("   SELECT cast( GROUP_CONCAT( IF(   pli.IsSampleCollected='Y'   ");

            sb.Append(" , CONCAT(\"<a onmouseout=hideme() onmouseover=getme('\",pli.Test_ID,\"')  href=\",'\" javascript:void(0); \" ' , concat(\"style=\'background-color:\",CASE  WHEN pli.IsDispatch='1' AND pli.isFOReceive='1' THEN '#44A3AA' WHEN pli.IsFOReceive='1' THEN '#E9967A' WHEN pli.isFOReceive='0' AND pli.Approved='1' AND pli.isPrint='1' THEN '#00FFFF' WHEN pli.Approved='1' AND pli.isHold='0' THEN '#90EE90' WHEN pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='0'AND isPartial_Result='0' AND  pli.IsSampleCollected<>'R' THEN '#FFC0CB' WHEN pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='0' AND isPartial_Result='1'  THEN '#A9A9A9' WHEN pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='1' THEN '#3399FF' WHEN pli.Result_Flag='0' AND (SELECT COUNT(*) FROM mac_data mac WHERE mac.LedgerTransactionNO=pli.LedgerTransactionNO AND mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>'')>0 THEN '#E2680A' WHEN pli.isHold='1' THEN '#FFFF00' WHEN pli.IsSampleCollected='N' OR pli.IsSampleCollected='S' THEN '#CC99FF' WHEN pli.IsSampleCollected='R' THEN '#B0C4DE' WHEN pli.IsSampleCollected<>'Y' THEN '#CC99FF' ELSE '#FFFFFF' END,\";'\") ,\" onclick=\", '~' ,\"");
          //  sb.Append(" GetParameters('\",sc.Abbreviation,\"','\",pli.Test_ID,\"','\", Im.ReportType, ");//WHEN pli.IsEdited=1 THEN '#FF00FF'
           // sb.Append(" \"','\",pli.Test_ID,\"','\",pli.Investigation_ID,\"','\", ");
           // sb.Append(" (CASE  WHEN pli.LedgerTransactionNo=\"\" THEN \"Test Cancel\" WHEN pli.isHold=\"1\" AND pli.LedgerTransactionNo!=\"\" THEN \"Hold\" WHEN pli.Approved=\"1\" ");
          //  sb.Append(" AND pli.LedgerTransactionNo!=\"\" THEN \"Approved\" WHEN pli.Approved=\"0\" AND pli.Result_Flag=\"1\" AND pli.LedgerTransactionNo!=\"\" THEN \"Result Done\" ");
          //  sb.Append("  WHEN pli.IsSampleCollected=\"Y\" AND pli.Result_Flag=\"0\" AND pli.LedgerTransactionNo!=\"\" THEN \"Sample LabReceived\" WHEN pli.IsSampleCollected=\"S\" ");
           // sb.Append("  AND pli.LedgerTransactionNo!=\"\" THEN \"Sample Collected\" WHEN pli.IsSampleCollected=\"N\" AND pli.LedgerTransactionNo!=\"\" THEN \"Sample Not Collected\" ");
           //sb.Append(" WHEN pli.IsSampleCollected=\"R\" AND pli.LedgerTransactionNo!=\"\" THEN \"Sample Rejected\" END ),  \"','\",io.observationType_ID,\"','\",im.isculture,\"'); ~ >\", ");
            sb.Append("   GetParameters('\", pli.Test_ID, \"'); ~ >\", ");
            sb.Append("  Im.Name ,\"</a>\"),IF(   pli.IsSampleCollected='S',  CONCAT('<a style=\"background-color:#CC99FF;\"  href=\"javascript:void(0);\">', Im.Name,'</a>' ),CONCAT('<a style=\"background-color:#CC99FF;\"  href=\"javascript:void(0);\">', Im.Name,'</a>' )))  SEPARATOR \" \") as char) AS IName ");
            sb.Append(" FROM (SELECT * FROM patient_labinvestigation_opd WHERE LedgerTransactionNo=@LedgerTransactionNo AND isreporting =1 and issamplecollected<>'R'  )pli  ");
            sb.Append(" INNER JOIN investigation_master im ON pli.Investigation_ID=im.Investigation_Id ");
            sb.Append(" INNER JOIN f_itemmaster fim ON fim.type_id=pli.Investigation_ID INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=fim.SubCategoryID  ");
            sb.Append(" INNER JOIN investigation_observationtype io ON io.investigation_id = im.Investigation_Id ");
            sb.Append(" INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id ");
            if (UserInfo.RoleID == 15)
            {
                sb.Append(" and pli.ReportType=5; ");
            }
            else
                {
                    sb.Append(" and pli.ReportType<>5 ;");
                }
           // sb.Append(" GROUP BY pli.SubCategoryID");
		  // System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\GetPatientInvsetigationsNameOnly.txt", sb.ToString());
            string rtrn = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@LedgerTransactionNo", LabNo)));

            rtrn = rtrn.Replace('~', '"');
            return rtrn;
        }
        catch (Exception ex)
        {

            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return string.Empty;

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string LabObservationSearch(string LabNo, string TestID, float AgeInDays, string RangeType, string Gender, string MachineID, string macId)
    {
		// Added  By Vaseem  For  Transgender  20-March-23
        if (Gender == "Trans")
        {
            Gender = Gender.Replace("Trans", "Male");
        }
        if (string.IsNullOrEmpty(macId))
        {
            macId = string.Empty;
        }
        List<string> Test_ID = TestID.TrimEnd(',').Split(',').ToList<string>();
        StringBuilder sbObs = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sbObs.Append(" SELECT pli.IsEdited,'' EditDetail,");
            sbObs.Append(" pli.SubCategoryID,pli.LedgerTransactionID,'' RequiredField,pli.patient_id,@Gender Gender,");
            sbObs.Append(" @LedgerTransactionNo LabNo,@AgeInDays AgeInDays,pli.Interface_companyName InterfaceCName,pli.CancelByInterface CancelByInterface,pli.IsPackage,pli.BarcodeNo,pli.ItemName TestName ,om.Print_Sequence Dept_Sequence,om.name Dept, ");
            // Comment By Salek to show old mac reading on 11Dec2018
            sbObs.Append(" im.PrintSeparate INV_PrintSeparate,lom.PrintSeparate OBS_PrintSeparate,plo.Description,pli.IsSampleCollected,'' AS LabInvestigation_ID,pli.Investigation_ID,pli.test_id PLIID, pli.Test_ID,pli.Result_Flag,pli.Approved,pli.isHold,plo.flag `Flag`, (CASE WHEN pli.approved=1  THEN plo.Value WHEN loi.Child_Flag='1' THEN 'HEAD' WHEN IFNULL(plo.Value,'')!='' AND pli.Result_Flag=1  THEN plo.Value  WHEN (IFNULL(plo.Value ,'')='' OR pli.Result_Flag=0) AND IFNULL(mac.MacReading,'')!='' THEN IF(ifnull(mac.MacReading,0)=1,mac.MacReading,mac.MacReading)    WHEN IFNULL(plo.Value,'')='' AND IFNULL(mac.MacReading,'')='' AND IFNULL(IFNULL(lr.DefaultReading,lr2.DefaultReading), '') != '' AND pli.Result_Flag<>1  THEN IFNULL(lr.DefaultReading,lr2.DefaultReading)    ELSE '' END ) `Value`, if(plo.MachineName<>'' and mac.machinename is null ,plo.MacReading, mac.MacReading  ) MacReading , if(plo.MachineName<>'' and mac.machinename is null ,plo.MachineID, mac.MachineID  ) MachineID, if(plo.MachineName<>'' and mac.machinename is null ,plo.MachineName, mac.machinename  )machinename,mac.MachineID1,mac.MachineID2,mac.MachineID3, IFNULL(CONCAT(DATE(mac.MacDate),' ',TIME(mac.MacDate)),'0001-01-01 00:00:00')  dtMacEntry, lom.DefaultValue,plo.ID,LOM.LabObservation_ID,mac.Reading1,mac.Reading2,mac.Reading3, (CONCAT(loi.prefix,'',LOM.Name)) AS `LabObservationName`, ");
            // sbObs.Append(" im.PrintSeparate INV_PrintSeparate,lom.PrintSeparate OBS_PrintSeparate,plo.Description,pli.IsSampleCollected,'' AS LabInvestigation_ID,pli.Investigation_ID,pli.test_id PLIID, pli.Test_ID,pli.Result_Flag,pli.Approved,pli.isHold,plo.flag `Flag`, (CASE WHEN loi.Child_Flag='1' THEN 'HEAD'  WHEN IFNULL(plo.Value,'')!='' AND pli.Result_Flag=1  THEN plo.Value  WHEN (IFNULL(plo.Value ,'')='' OR pli.Result_Flag=0) AND IFNULL(mac.MacReading,'')!='' THEN IF(IsNumeric(mac.MacReading)=1,mac.MacReading,mac.MacReading)    WHEN IFNULL(plo.Value,'')='' AND IFNULL(mac.MacReading,'')='' AND IFNULL(IFNULL(lr.DefaultReading,lr2.DefaultReading), '') != '' AND pli.Result_Flag<>1  THEN IFNULL(lr.DefaultReading,lr2.DefaultReading)    ELSE '' END ) `Value`,  mac.MacReading,mac.MachineID,mac.machinename,mac.MachineID1,mac.MachineID2,mac.MachineID3, IFNULL(CONCAT(DATE(mac.MacDate),' ',TIME(mac.MacDate)),'0001-01-01 00:00:00')  dtMacEntry, lom.DefaultValue,plo.ID,LOM.LabObservation_ID,mac.Reading1,mac.Reading2,mac.Reading3, (CONCAT(loi.prefix,'',LOM.Name)) AS `LabObservationName`, ");
            sbObs.Append(" IF(IFNULL(plo.value,'')<>'' AND pli.approved=1 ,plo.MinValue , IFNULL(lr.MinReading,lr2.MinReading)) `MinValue`,   ");
            sbObs.Append(" IF(IFNULL(plo.value,'')<>'' AND pli.approved=1 ,plo.MaxValue , IFNULL(lr.MaxReading,lr2.MaxReading)) `MaxValue`, ");
            sbObs.Append(" REPLACE( IF(IFNULL(plo.value,'')<>'' AND pli.approved=1,plo.`DisplayReading`, IFNULL(lr.DisplayReading,lr2.DisplayReading)),'\n','~')DisplayReading, ");
            sbObs.Append("   IFNULL(lr.DefaultReading,lr2.DefaultReading)DefaultReading, ");
            sbObs.Append(" '1' rangetype,   ");
            sbObs.Append(" IF(IFNULL(plo.value,'')<>'' AND pli.approved=1, plo.ReadingFormat, IFNULL(lr.ReadingFormat,lr2.ReadingFormat))ReadingFormat,        ");
            sbObs.Append(" IF(IFNULL(plo.value,'')<>'' AND pli.approved=1,plo.`AbnormalValue`,IFNULL(lr.AbnormalValue,lr2.AbnormalValue))AbnormalValue,       IFNULL(loi.IsBold,0) IsBold,       IFNULL(loi.IsUnderLine,0)IsUnderLine,        ");
            sbObs.Append(" loi.PrintOrder Priorty,Im.ReportType,lom.ParentID,loi.Child_Flag, ifnull(loi.Formula,'')Formula,   ");

            sbObs.Append(" IF(IFNULL(plo.value,'')<>'' AND pli.approved=1, plo.`Method`, IFNULL(lr.MethodName,lr2.MethodName)) `Method`, IFNULL(lr.ShowAbnormalAlert,lr2.ShowAbnormalAlert) `ShowAbnormalAlert`,ifnull(IFNULL(lr.ShowDeltaReport,lr2.ShowDeltaReport),0) `ShowDeltaReport`,  ");
            sbObs.Append(" IFNULL(plo.PrintMethod,1)PrintMethod,   im.Print_Sequence,lom.IsMultiChild,     ");
            sbObs.Append(" loi.IsCritical,IF(IFNULL(plo.value,'')<>'' AND pli.approved=1,plo.`MinCritical`,IFNULL(lr.MinCritical,lr2.MinCritical))MinCritical,IF(IFNULL(plo.value,'')<>'' AND pli.approved=1,plo.`MaxCritical`,IFNULL(lr.MaxCritical,lr2.MaxCritical ))MaxCritical  ,ifnull(h.Help,'') Help,   ");
            sbObs.Append(" im.IsMic,lom.IsComment,lom.ResultRequired   , pli.isPartial_Result,lom.DLCCheck,loi.isamr isAmr,loi.isreflex Isreflex,loi.helpvalueonly,IFNULL(lr.AMRMin,lr2.AMRMin) AmrMin,IFNULL(lr.AMRMax,lr2.AMRMax) AmrMax,IFNULL(lr.reflexmin,lr2.reflexmin) ReflexMin,IFNULL(lr.reflexmax,lr2.reflexmax) ReflexMax ,  ");
            sbObs.Append(" (select IFNULL(GROUP_CONCAT(LabObservationIDto SEPARATOR '#'),'') from investigation_maphold where LabObservationIDfrom =loi.LabObservation_ID) HoldObsId");

            sbObs.Append(@" ,IFNUll(( SELECT GROUP_CONCAT( CONCAT('<a target=\'_blank\' href=\'../../Clientdocument/Uploaded Document/',DATE_FORMAT(`dtEntry`,'%Y%m%d'),'/', `FileUrl`,'\'>',AttachedFile,'</a>')  SEPARATOR '<br/>') FileUrl FROM patient_labinvestigation_attachment  WHERE Test_ID=pli.Test_ID GROUP BY test_id ),'')IsAttached ");

            sbObs.Append(" ,CASE ");
            sbObs.Append(" WHEN pli.isPrint=1 THEN '#00FFFF' /*'Printed'*/ ");
            sbObs.Append(" WHEN pli.Approved=1 THEN '#90EE90' /*'Approved'*/ ");
            sbObs.Append("   WHEN pli.Result_Flag=1  and pli.isForward=0  THEN '#FFC0CB' /*'Result_Done'*/ ");
            sbObs.Append("   WHEN pli.isForward=1  THEN '#3399FF' /*'Forwarded'*/ ");
            sbObs.Append(" WHEN pli.IsEdited=1 THEN '#FF00FF' /*'ADD ON Test*/ ");
            sbObs.Append("   WHEN (select count(*) from mac_Data where reading<>'' and Test_Id=pli.Test_Id )>0 and pli.Result_Flag=0 THEN '#E2680A' /*'MacData'*/ ");

            sbObs.Append("  WHEN pli.isSampleCollected='N' THEN '#CC99FF' /*'Not-Collected'*/ ");
            sbObs.Append("   WHEN pli.isSampleCollected='S' THEN '#CC99FF' /*'Collected'*/ ");
            sbObs.Append("  WHEN pli.isSampleCollected='Y' THEN '#FFFFFF' /*'Received'*/ ");
            sbObs.Append("  WHEN pli.isSampleCollected='R' THEN '#B0C4DE' /*'Rejected'*/ ");

            sbObs.Append("  ELSE '#FFFFFF'  ");
            sbObs.Append("  END `Status` ");
            sbObs.Append(" ,(SELECT COUNT(*) FROM `patient_labinvestigation_opd_micro` WHERE Test_ID= pli.Test_ID ) micro, om.Name DeptName,if(pli.isrerun=0,im.Name,concat(im.name,'(RERUN)')) as InvName ");
            sbObs.Append(" ,(SELECT COUNT(*) FROM `patient_labinvestigation_opd_remarks` WHERE Test_ID= pli.Test_ID and IsActive='1') Remarks,'true' SaveInv ");
            sbObs.Append(" FROM (select * from patient_labinvestigation_opd where LedgerTransactionNo=@LedgerTransactionNo ");  // AND IsSampleCollected='Y'
            if (TestID != string.Empty)
            {
                sbObs.Append(" AND Test_ID in ({0}) ");
            }
            sbObs.Append(" ) pli ");
            sbObs.Append(" INNER JOIN investigation_master im  ON pli.Investigation_ID=im.Investigation_Id  AND im.ReportType=1 and im.IsMic=0 and im.isCulture=0  ");
            sbObs.Append(" INNER JOIN investigation_observationtype io  ON io.Investigation_ID=im.Investigation_Id  ");
            sbObs.Append(" INNER JOIN observationtype_master om  ON om.ObservationType_ID=io.ObservationType_ID  ");
            sbObs.Append(" INNER JOIN labobservation_investigation loi ON im.Investigation_Id=loi.Investigation_Id    ");
            sbObs.Append(" INNER JOIN  labobservation_master lom ON loi.labObservation_ID=lom.LabObservation_ID and (lom.Gender= left(@Gender,1) or lom.Gender='B') ");

            sbObs.Append(" LEFT JOIN patient_labobservation_opd plo ON pli.Test_ID=plo.Test_ID AND plo.LabObservation_ID=LOM.LabObservation_ID  ");

            sbObs.Append(" LEFT OUTER JOIN   ");
            sbObs.Append(" ( SELECT SUBSTRING_INDEX(LabNo,'-',1)LabNo,LabObservation_ID,Reading MacReading,Reading1,Reading2,Reading3, MachineID,machinename,MachineID1,MachineID2,MachineID3,MacDate,Test_ID FROM  mac_data WHERE LedgerTransactionNo=@LedgerTransactionNo and ( Reading<>'' or Reading1<>'')  ");
            sbObs.Append("      GROUP BY Test_ID,LabObservation_ID ) mac ON mac.Test_ID=pli.Test_ID  AND mac.LabObservation_ID= lom.LabObservation_ID   AND mac.LabNo = CONCAT(pli.BarcodeNo,IFNULL(lom.suffix,''))   ");

            sbObs.Append(" LEFT OUTER JOIN labobservation_range lr ON lr.Gender=LEFT(@Gender,1) ");
            sbObs.Append(" AND lr.FromAge<=@AgeInDays AND lr.ToAge>=@AgeInDays   ");
            sbObs.Append(" AND lr.LabObservation_ID=lom.LabObservation_ID AND lr.macID = (if (ifnull(mac.MachineID,'')='','1',mac.MachineID)) and lr.CentreID=@CentreID  and lr.rangetype=@RangeType ");

            sbObs.Append(" LEFT OUTER JOIN labobservation_range lr2 ON lr2.Gender=LEFT(@Gender,1) ");
            sbObs.Append(" AND lr2.FromAge<=@AgeInDays AND lr2.ToAge>=@AgeInDays ");
            //sbObs.Append(" AND lr2.LabObservation_ID=lom.LabObservation_ID AND   IFNULL(lr2.macID,'1') = if('" + macId + "'<>'','" + macId + "','1') and lr2.CentreID=if('" + macId + "'<>'','" + UserInfo.Centre + "','1')  and lr2.rangetype='" + RangeType + "' ");
            sbObs.Append(" AND lr2.LabObservation_ID=lom.LabObservation_ID AND   IFNULL(lr2.macID,'1') = if(@macId<>'',@macId,'1') and lr2.CentreID = 1  and lr2.rangetype=@RangeType");

            sbObs.Append(" LEFT OUTER JOIN ");
            sbObs.Append(" (SELECT GROUP_CONCAT(concat(lhm.Help,'#',if(ifnull(lhm.ShortKey,'')='',lhm.Help,lhm.ShortKey) ) ORDER BY IF(IFNULL(lhm.ShortKey,'')='',lhm.id,lhm.ShortKey) SEPARATOR '|' )Help,loh.labObservation_ID  ");
            sbObs.Append(" FROM LabObservation_Help loh  ");
            sbObs.Append(" INNER JOIN LabObservation_Help_Master lhm ON lhm.id=loh.HelpId  ");
            sbObs.Append(" GROUP BY loh.LabObservation_ID ) h ON h.LabObservation_ID = lom.LabObservation_ID ");



            sbObs.Append(" UNION ALL  ");

            sbObs.Append(" SELECT pli.IsEdited,'' EditDetail ,");
            sbObs.Append("  pli.SubCategoryID,pli.LedgerTransactionID ,'' RequiredField,pli.patient_id,@Gender Gender, ");
            sbObs.Append(" @LedgerTransactionNo LabNo,@AgeInDays AgeInDays,pli.Interface_companyName InterfaceCName,pli.CancelByInterface CancelByInterface,pli.IsPackage,pli.BarcodeNo,pli.ItemName TestName,om.Print_Sequence Dept_Sequence,om.name Dept,  ");
            sbObs.Append(" im.PrintSeparate INV_PrintSeparate,'0' OBS_PrintSeparate,'' Description,pli.IsSampleCollected,'' AS LabInvestigation_ID,pli.Investigation_ID,pli.test_id PLIID, pli.Test_ID,pli.Result_Flag,pli.Approved,pli.isHold,'' `Flag`,  ");
            sbObs.Append(" '' `Value`,  '' MacReading, '' MachineID,'' machinename,'' MachineID1,'' MachineID2,'' MachineID3, '0001-01-01 00:00:00'  dtMacEntry, '' DefaultValue,'' ID,pli.Test_ID LabObservation_ID,'' Reading1,'' Reading2,'' Reading3,  im.Name `LabObservationName` , ''`MinValue`,   ''  `MaxValue`,    '' DisplayReading,  '' DefaultReading,  ");
            sbObs.Append(" ''  rangetype,    ");
            sbObs.Append(" '' ReadingFormat,         ");
            sbObs.Append(" '' AbnormalValue,      0 IsBold,       0 IsUnderLine,         ");
            sbObs.Append(" 0 Priorty,Im.ReportType,0 ParentID,0 Child_Flag, '' Formula,    ");
            sbObs.Append(" '' `Method`, '' ShowAbnormalAlert ,'0' ShowDeltaTReport,  ");
            sbObs.Append(" 0 PrintMethod,   im.Print_Sequence,0 IsMultiChild,      ");
            sbObs.Append(" 0 IsCritical,'' MinCritical,'' MaxCritical  ,'' HELP ,    ");
            sbObs.Append(" im.IsMic,'' IsComment,'0' ResultRequired   , pli.isPartial_Result,0 DLCCheck,0 isAmr,0 Isreflex,0 helpvalueonly,0 AmrMin,0 AmrMax,0 ReflexMin,0 ReflexMax,    ");
            sbObs.Append(" '' HoldObsId");

            sbObs.Append(@" ,IFNUll(( SELECT GROUP_CONCAT( CONCAT('<a target=\'_blank\' href=\'../../Clientdocument/Uploaded Document/',DATE_FORMAT(`dtEntry`,'%Y%m%d'),'/', `FileUrl`,'\'>',AttachedFile,'</a>')  SEPARATOR '<br/>') FileUrl FROM patient_labinvestigation_attachment  WHERE Test_ID=pli.Test_ID GROUP BY test_id ),'')IsAttached ");

            sbObs.Append(" ,CASE  ");
            sbObs.Append(" WHEN pli.isPrint=1 THEN '#00FFFF' /*'Printed'*/  ");
            sbObs.Append(" WHEN pli.Approved=1 THEN '#90EE90' /*'Approved'*/  ");
            sbObs.Append(" WHEN pli.Result_Flag=1  AND pli.isForward=0  THEN '#FFC0CB' /*'Result_Done'*/  ");
            sbObs.Append(" WHEN pli.isForward=1  THEN '#3399FF' /*'Forwarded'*/  ");
            sbObs.Append(" WHEN pli.IsEdited=1 THEN '#FF00FF' /*'ADD ON Test*/ ");
            sbObs.Append(" WHEN (SELECT COUNT(*) FROM mac_Data WHERE reading<>'' AND Test_Id=pli.Test_Id )>0 AND pli.Result_Flag=0 THEN '#E2680A' /*'MacData'*/  ");

            sbObs.Append(" WHEN pli.isSampleCollected='N' THEN '#CC99FF' /*'Not-Collected'*/  ");
            sbObs.Append(" WHEN pli.isSampleCollected='S' THEN '#CC99FF' /*'Collected'*/  ");
            sbObs.Append(" WHEN pli.isSampleCollected='Y' THEN '#FFFFFF' /*'Received'*/  ");
            sbObs.Append(" WHEN pli.isSampleCollected='R' THEN '#B0C4DE' /*'Rejected'*/  ");
            sbObs.Append(" ELSE '#FFFFFF'   ");
            sbObs.Append(" END `Status`    ");

            sbObs.Append(" ,'0' micro,om.Name DeptName,im.Name as InvName ");
            sbObs.Append(" ,(SELECT COUNT(*) FROM `patient_labinvestigation_opd_remarks` WHERE Test_ID= pli.Test_ID and IsActive=1 ) Remarks,'true' SaveInv  ");
            sbObs.Append(" FROM (SELECT * FROM patient_labinvestigation_opd WHERE LedgerTransactionNo=@LedgerTransactionNo    ");

            sbObs.Append(" AND Test_ID IN ({0})   ");

            sbObs.Append(" ) pli  ");
            sbObs.Append(" INNER JOIN investigation_master im  ON pli.Investigation_ID=im.Investigation_Id  AND im.ReportType<>1 and im.ReportType<>7 and im.ReportType<>11 and im.isCulture=0 ");
            sbObs.Append(" INNER JOIN investigation_observationtype io  ON io.Investigation_ID=im.Investigation_Id  ");
            sbObs.Append(" INNER JOIN observationtype_master om  ON om.ObservationType_ID=io.ObservationType_ID  ");

            sbObs.Append(" UNION ALL  ");

            sbObs.Append(" SELECT pli.IsEdited,'' EditDetail ,");
            sbObs.Append("  pli.SubCategoryID,pli.LedgerTransactionID ,'' RequiredField,pli.patient_id,@Gender Gender, ");
            sbObs.Append(" @LedgerTransactionNo LabNo,@AgeInDays AgeInDays,pli.Interface_companyName InterfaceCName,pli.CancelByInterface CancelByInterface,pli.IsPackage,pli.BarcodeNo,pli.ItemName TestName,'' Dept_Sequence,pli.SubCategoryName Dept,  ");
            sbObs.Append(" im.PrintSeparate INV_PrintSeparate,'0' OBS_PrintSeparate,'' Description,pli.IsSampleCollected,'' AS LabInvestigation_ID,pli.Investigation_ID,pli.test_id PLIID, pli.Test_ID,pli.Result_Flag,pli.Approved,pli.isHold,'' `Flag`,  ");
            sbObs.Append(" '' `Value`,  '' MacReading, '' MachineID,'' machinename,'' MachineID1,'' MachineID2,'' MachineID3, '0001-01-01 00:00:00'  dtMacEntry, '' DefaultValue,'' ID,pli.Test_ID LabObservation_ID,'' Reading1,'' Reading2,'' Reading3,  im.Name `LabObservationName` , ''`MinValue`,   ''  `MaxValue`,    '' DisplayReading,  '' DefaultReading,  ");
            sbObs.Append(" ''  rangetype,    ");
            sbObs.Append(" '' ReadingFormat,         ");
            sbObs.Append(" '' AbnormalValue,      0 IsBold,       0 IsUnderLine,         ");
            sbObs.Append(" 0 Priorty,Im.ReportType,0 ParentID,0 Child_Flag, '' Formula,    ");
            sbObs.Append(" '' `Method`, '' ShowAbnormalAlert ,'0' ShowDeltaTReport,  ");
            sbObs.Append(" 0 PrintMethod,   im.Print_Sequence,0 IsMultiChild,      ");
            sbObs.Append(" 0 IsCritical,'' MinCritical,'' MaxCritical  ,'' HELP ,    ");
            sbObs.Append(" im.IsMic,'' IsComment,'0' ResultRequired   , pli.isPartial_Result,0 DLCCheck,0 isAmr,0 Isreflex,0 helpvalueonly,0 AmrMin,0 AmrMax,0 ReflexMin,0 ReflexMax,    ");
            sbObs.Append(" '' HoldObsId");

            sbObs.Append(@" ,IFNUll(( SELECT GROUP_CONCAT( CONCAT('<a target=\'_blank\' href=\'../../Clientdocument/Uploaded Document/',DATE_FORMAT(`dtEntry`,'%Y%m%d'),'/', `FileUrl`,'\'>',AttachedFile,'</a>')  SEPARATOR '<br/>') FileUrl FROM patient_labinvestigation_attachment  WHERE Test_ID=pli.Test_ID GROUP BY test_id ),'')IsAttached ");

            sbObs.Append(" ,CASE  ");
            sbObs.Append(" WHEN pli.isPrint=1 THEN '#00FFFF' /*'Printed'*/  ");
            sbObs.Append(" WHEN pli.Approved=1 THEN '#90EE90' /*'Approved'*/  ");
            sbObs.Append(" WHEN pli.Result_Flag=1  AND pli.isForward=0  THEN '#FFC0CB' /*'Result_Done'*/  ");
            sbObs.Append(" WHEN pli.isForward=1  THEN '#3399FF' /*'Forwarded'*/  ");
            sbObs.Append(" WHEN pli.IsEdited=1 THEN '#FF00FF' /*'ADD ON Test*/ ");
            sbObs.Append(" WHEN (SELECT COUNT(*) FROM mac_Data WHERE reading<>'' AND Test_Id=pli.Test_Id )>0 AND pli.Result_Flag=0 THEN '#E2680A' /*'MacData'*/  ");

            sbObs.Append(" WHEN pli.isSampleCollected='N' THEN '#CC99FF' /*'Not-Collected'*/  ");
            sbObs.Append(" WHEN pli.isSampleCollected='S' THEN '#CC99FF' /*'Collected'*/  ");
            sbObs.Append(" WHEN pli.isSampleCollected='Y' THEN '#FFFFFF' /*'Received'*/  ");
            sbObs.Append(" WHEN pli.isSampleCollected='R' THEN '#B0C4DE' /*'Rejected'*/  ");
            sbObs.Append(" ELSE '#FFFFFF'   ");
            sbObs.Append(" END `Status`    ");

            sbObs.Append(" ,'0' micro,pli.SubCategoryName DeptName,im.Name as InvName ");//om.Name DeptName,
            sbObs.Append(" ,(SELECT COUNT(*) FROM `patient_labinvestigation_opd_remarks` WHERE Test_ID= pli.Test_ID and IsActive=1 ) Remarks,'true' SaveInv  ");
            sbObs.Append(" FROM (SELECT * FROM patient_labinvestigation_opd WHERE LedgerTransactionNo=@LedgerTransactionNo    ");

            sbObs.Append(" AND Test_ID IN ({0})   ");

            sbObs.Append(" ) pli  ");
            sbObs.Append(" INNER JOIN investigation_master im  ON pli.Investigation_ID=im.Investigation_Id  AND im.ReportType=11  ");
            sbObs.Append(" INNER JOIN investigation_observationtype io  ON io.Investigation_ID=im.Investigation_Id  ");
            sbObs.Append(" INNER JOIN observationtype_master om  ON om.ObservationType_ID=io.ObservationType_ID  ");
            sbObs.Append(" ORDER BY Dept_Sequence,Dept, Print_Sequence,Priorty");


            //if(UserInfo.ID ==1)
            // System.IO.File.WriteAllText (@"F:\macdta.txt", sbObs.ToString());

            DataTable dt = new DataTable();
            using (dt as IDisposable)
            {
                using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sbObs.ToString(), string.Join(",", Test_ID)), con))
                {

                    da.SelectCommand.Parameters.AddWithValue("@LedgerTransactionNo", LabNo);
                    da.SelectCommand.Parameters.AddWithValue("@AgeInDays", AgeInDays);
                    da.SelectCommand.Parameters.AddWithValue("@Gender", Gender);
                    da.SelectCommand.Parameters.AddWithValue("@CentreID", UserInfo.Centre);

                    da.SelectCommand.Parameters.AddWithValue("@RangeType", RangeType);
                    da.SelectCommand.Parameters.AddWithValue("@macId", macId);
                    for (int i = 0; i < Test_ID.Count; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(string.Concat("@Test_IDParam", i), Test_ID[i]);
                    }
                    da.Fill(dt);
                    sbObs = new StringBuilder();

                }
                DataColumn newColumn = new System.Data.DataColumn("Inv", typeof(System.String)) { DefaultValue = "0" };
                dt.Columns.Add(newColumn);
                DataTable dtreportfile = new DataTable();
                using (dtreportfile as IDisposable)
                {
                    if (dt.Rows.Count > 0)
                    {
                        sbObs = new StringBuilder();
                        sbObs.Append(" SELECT test_id");//, CONCAT(@UploadedReport,DATE_FORMAT(`dtEntry`,'%Y%m%d'),'/', `FileUrl`,@UploadedPath1,AttachedFile,@UploadedPath)  FileUrl");
                        sbObs.Append(" ,CONCAT(@UploadedReport,AttachedFile,'&Type=1&FilePath=',DATE_FORMAT(`dtEntry`,'%Y%m%d'),'/', `FileUrl`,@UploadedPath1,AttachedFile)FileUrl");
                        sbObs.Append(" FROM patient_labinvestigation_attachment_report  WHERE Test_ID IN ({0})");
                        using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sbObs.ToString(), string.Join(",", Test_ID)), con))
                        {
                            da.SelectCommand.Parameters.AddWithValue("@UploadedReport", string.Concat("<a target=_self href=DownloadAttachment.aspx?FileName="));///<a target=\'_blank\' href=\'../../Clientdocument/Uploaded Report/
                            da.SelectCommand.Parameters.AddWithValue("@UploadedPath", string.Concat("</a>"));


                            da.SelectCommand.Parameters.AddWithValue("@UploadedPath1", string.Concat(">"));
                            for (int i = 0; i < Test_ID.Count; i++)
                            {
                                da.SelectCommand.Parameters.AddWithValue(string.Concat("@Test_IDParam", i), Test_ID[i]);
                            }
                            da.Fill(dtreportfile);
                            sbObs = new StringBuilder();

                        }
                        string temp = string.Empty;
                        string tempDept = string.Empty;
                        DataTable dtClone = dt.Clone();
                        using (dtClone as IDisposable)
                        {
                            DataRow drCopy = null;
                            DataRow drNew1 = null;
                            DataRow drNew = null;
                            foreach (DataRow dr in dt.Rows)
                            {

                                if (temp != dr["Test_ID"].ToString())
                                {
                                    if (temp != string.Empty)
                                    {
                                        drCopy = dt.Rows[dt.Rows.IndexOf(dr) - 1];
                                        drNew1 = dtClone.NewRow();
                                        drNew1["LabObservationName"] = "Comments";
                                        drNew1["PrintMethod"] = 0;
                                        drNew1["Inv"] = 2;
                                        drNew1["Flag"] = string.Empty;
                                        drNew1["Value"] = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select IFNULL(comments,'')comments from patient_labinvestigation_opd_comments where Test_ID=@Test_ID",
                                            new MySqlParameter("@Test_ID", drCopy["Test_ID"].ToString())));
                                        drNew1["IsAttached"] = drCopy["IsAttached"].ToString();
                                        drNew1["Test_ID"] = drCopy["Test_ID"].ToString();
                                        drNew1["LabNo"] = drCopy["LabNo"].ToString();
                                        drNew1["SaveInv"] = "true";
                                        drNew1["ReportType"] = drCopy["ReportType"].ToString();
                                        dtClone.Rows.Add(drNew1);
                                    }
                                    if (tempDept != dr["Dept"].ToString())
                                    {
                                        tempDept = dr["Dept"].ToString();
                                        drNew = dtClone.NewRow();
                                        drNew["LabObservationName"] = dr["Dept"].ToString();
                                        drNew["PrintMethod"] = 0;
                                        drNew["Inv"] = 3;
                                        drNew["Flag"] = string.Empty;
                                        drNew["IsAttached"] = dr["IsAttached"].ToString();
                                        drNew["LabNo"] = dr["LabNo"].ToString();
                                        drNew["SaveInv"] = "true";
                                        drNew["ReportType"] = dr["ReportType"].ToString();
                                        dtClone.Rows.Add(drNew);
                                    }
                                    drCopy = dr;
                                    temp = dr["Test_ID"].ToString();
                                    drNew = dtClone.NewRow();
                                    drNew["PLIID"] = dr["Test_ID"].ToString();
                                    drNew["LabObservationName"] = dr["InvName"].ToString();
                                    drNew["IsEdited"] = dr["IsEdited"].ToString();
                                    drNew["EditDetail"] = dr["EditDetail"].ToString();
                                    drNew["PrintMethod"] = 0;
                                    drNew["Inv"] = 1;
                                    drNew["Flag"] = string.Empty;
                                    drNew["IsAttached"] = dr["IsAttached"].ToString();
                                    drNew["LabNo"] = dr["LabNo"].ToString();
                                    drNew["SaveInv"] = "true";
                                    drNew["Remarks"] = dr["Remarks"].ToString();
                                    drNew["ReportType"] = dr["ReportType"].ToString();
                                    if (dr["investigation_id"].ToString() == "924" || dr["investigation_id"].ToString() == "933" || dr["investigation_id"].ToString() == "936")
                                    {
                                        string ss1 = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(CONCAT(fieldname,' : ',fieldvalue,' ',unit)) requiredfield FROM `patient_labinvestigation_opd_requiredfield`  WHERE `LedgerTransactionID`=@LedgerTransactionID",
                                            new MySqlParameter("@LedgerTransactionID", dr["LedgerTransactionID"])));

                                        string ss2 = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT DATE_FORMAT(dob,'%d-%b-%Y') FROM patient_master WHERE patient_id=@patient_id",
                                            new MySqlParameter("@patient_id", dr["patient_id"])));
                                        drNew["RequiredField"] = string.Format("{0},DOB : {1}", ss1, ss2);
                                    }
                                    dtClone.Rows.Add(drNew);
                                    if (dtreportfile.Select(string.Format("test_id='{0}'", drCopy["Test_ID"])).Length > 0)
                                    {
                                        foreach (DataRow dwreport in dtreportfile.Select(string.Format("test_id='{0}'", drCopy["Test_ID"])))
                                        {
                                            drNew1 = dtClone.NewRow();
                                            drNew1["LabObservationName"] = "Attached Report";
                                            drNew1["PrintMethod"] = 0;
                                            drNew1["Inv"] = 4;
                                            drNew1["Flag"] = string.Empty;
                                            drNew1["Value"] = dwreport["FileUrl"].ToString();
                                            drNew1["IsAttached"] = drCopy["IsAttached"].ToString();
                                            drNew1["Test_ID"] = drCopy["Test_ID"].ToString();
                                            drNew1["LabNo"] = drCopy["LabNo"].ToString();
                                            drNew1["PLIID"] = drCopy["PLIID"].ToString();
                                            drNew1["barcodeno"] = drCopy["barcodeno"].ToString();
                                            drNew1["TestName"] = drCopy["TestName"].ToString();
                                            drNew1["SaveInv"] = "true";
                                            drNew1["ReportType"] = drCopy["ReportType"].ToString();
                                            dtClone.Rows.Add(drNew1);
                                        }
                                    }
                                }
                                dtClone.ImportRow(dr);
                            }
                            drNew1 = dtClone.NewRow();
                            drNew1["LabObservationName"] = "Comments";
                            drNew1["PrintMethod"] = 0;
                            drNew1["Inv"] = 2;
                            drNew1["Flag"] = string.Empty;
                            drNew1["Value"] = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select IFNULL(comments,'')comments from patient_labinvestigation_opd_comments where Test_ID=@Test_ID",
                               new MySqlParameter("@Test_ID", drCopy["Test_ID"].ToString())));
                            drNew1["IsAttached"] = drCopy["IsAttached"].ToString();
                            drNew1["Test_ID"] = drCopy["Test_ID"].ToString();
                            drNew1["LabNo"] = drCopy["LabNo"].ToString();
                            drNew1["SaveInv"] = "true";
                            drNew1["ReportType"] = drCopy["ReportType"].ToString();
                            dtClone.Rows.Add(drNew1);
                            dt = dtClone.Copy();
                        }
                    }
                    return JsonConvert.SerializeObject(dt);
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return string.Empty;

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string Comments_LabObservation(string LabObservation_ID, string Type, string Gender)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (Type == "Value")
            {
                string str = "SELECT it.`Template_ID`,it.`Temp_Head` FROM `investigation_template` it INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Investigation_ID`= it.`Investigation_ID` " +
            " WHERE pli.`Test_ID`=@LabObservation_ID and (it.FavDoctorId=0 or it.FavDoctorId=@UserInfo.ID) and (it.Gender=@Gender or it.Gender='B') ";
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str,
                    new MySqlParameter("@LabObservation_ID", LabObservation_ID), new MySqlParameter("@ID", UserInfo.ID), new MySqlParameter("@Gender", Gender.Substring(0, 1))).Tables[0])
                {
                    if (dt.Rows.Count > 0)
                    {

                    }
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                }
            }
            else
            {
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Comments_ID,Comments_Head FROM labobservation_comments WHERE `LabObservation_ID`=@LabObservation_ID",
                    new MySqlParameter("@LabObservation_ID", LabObservation_ID)).Tables[0])
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
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
    public static string GetComments_labobservation(string CmntID, string type, string BarcodeNo, string Test_ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string temp = string.Empty;
            string str = string.Empty;
            if (type == "Value")
            {
                str = "SELECT `Template_Desc` FROM `investigation_template` WHERE `Template_ID`=@Comments_ID";
            }
            else
            {
                str = "select Comments from labobservation_comments where Comments_ID=@Comments_ID";
            }

            temp = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, str,
                new MySqlParameter("@Comments_ID", CmntID)));
            DataTable dtMacData;
            try
            {
                if (CmntID.Trim() != string.Empty && CmntID.Trim() != "0" && temp.Trim() != string.Empty)
                {
                    StringBuilder sbQuery = new StringBuilder();
                    sbQuery.Append(" SELECT * FROM ( SELECT pm.`LabObservation_id`,mo.`Reading` FROM machost_atulya.`mac_observation` mo ");
                    sbQuery.Append(" INNER JOIN machost_atulya.mac_param_master pm ON pm.`Machine_ParamID`=mo.`Machine_ParamID`  ");
                    sbQuery.Append(" WHERE mo.`LabNo`=@LabNo AND mo.`Reading`<>'' ORDER BY mo.`id`) a ");
                    sbQuery.Append(" GROUP BY LabObservation_id ");

                    dtMacData = MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
                         new MySqlParameter("@LabNo", BarcodeNo.Trim())).Tables[0];

                    if (dtMacData.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dtMacData.Rows)
                        {
                            if (temp.Contains(string.Format("{{{0}}}", dr["LabObservation_id"])))
                            {
                                if (Util.GetString(dr["LabObservation_id"]) == "1097")
                                {
                                    temp = temp.Replace(string.Format("{{{0}}}", dr["LabObservation_id"]), string.Format("{0}/{1}", Util.GetString(Util.GetInt(dr["Reading"]) / 7), Util.GetString(Util.GetInt(dr["Reading"]) % 7)));
                                }
                                else if (Util.GetString(dr["LabObservation_id"]) == "1110" || Util.GetString(dr["LabObservation_id"]) == "1111" || Util.GetString(dr["LabObservation_id"]) == "1112" || Util.GetString(dr["LabObservation_id"]) == "1120" || Util.GetString(dr["LabObservation_id"]) == "1113")
                                {
                                    string valToShow = string.Empty;
                                    if (Util.GetString(dr["Reading"]).ToLower() == "low")
                                    {
                                        valToShow = "NEGATIVE";
                                    }
                                    else if (Util.GetString(dr["Reading"]).ToLower() == "increased")
                                    {
                                        valToShow = "POSITIVE";
                                    }
                                    else
                                    {
                                        valToShow = Util.GetString(dr["Reading"]);
                                    }

                                    temp = temp.Replace(string.Format("{{{0}}}", dr["LabObservation_id"]), Util.GetString(dr["Reading"]));
                                    temp = temp.Replace(string.Format("{{-{0}}}", dr["LabObservation_id"]), valToShow);
                                }
                                else if (Util.GetString(dr["LabObservation_id"]) == "1201" || Util.GetString(dr["LabObservation_id"]) == "1203" || Util.GetString(dr["LabObservation_id"]) == "1206" || Util.GetString(dr["LabObservation_id"]) == "1210" || Util.GetString(dr["LabObservation_id"]) == "1208")
                                {
                                    string valToShow = string.Empty;
                                    if (Util.GetString(dr["Reading"]).ToLower() == "low")
                                    {
                                        valToShow = "NEGATIVE";
                                    }
                                    else if (Util.GetString(dr["Reading"]).ToLower() == "increased")
                                    {
                                        valToShow = "POSITIVE";
                                    }
                                    else
                                    {
                                        valToShow = Util.GetString(dr["Reading"]);
                                    }

                                    temp = temp.Replace(string.Format("{{{0}}}", dr["LabObservation_id"]), Util.GetString(dr["Reading"]));
                                    temp = temp.Replace(string.Format("{{-{0}}}", dr["LabObservation_id"]), valToShow);
                                }
                                else if (Util.GetString(dr["LabObservation_id"]) == "1095")
                                {
                                    string Year = string.Empty;
                                    string Month = string.Empty;
                                    string DispData = string.Empty;
                                    try
                                    {
                                        Year = Util.GetString(dr["Reading"]).Split('.')[0];
                                        Month = (Util.GetInt(Util.GetString(dr["Reading"]).Split('.')[1]) * 12).ToString("0000").Substring(0, 2);
                                        DispData = string.Format("{0}/{1}", Year, Month);
                                    }
                                    catch
                                    {
                                        DispData = Util.GetString(dr["Reading"]) + "/0";
                                    }
                                    temp = temp.Replace(string.Format("{{{0}}}", dr["LabObservation_id"]), DispData);
                                }
                                else
                                {
                                    temp = temp.Replace(string.Format("{{{0}}}", dr["LabObservation_id"]), Util.GetString(dr["Reading"]));
                                }

                            }
                        }
                    }
                    temp = System.Text.RegularExpressions.Regex.Replace(temp, "{.*?}", string.Empty, System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                }
            }
            catch
            {
            }
            return temp;
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
    public static string Getpatient_labobservation_opd_text(string TestId, string BarcodeNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            //StringBuilder sbQuery = new StringBuilder();
            //sbQuery.Append(" SELECT * FROM ( SELECT pm.`LabObservation_id`,mo.`Reading` FROM machost_atulya.`mac_observation` mo ");
            //sbQuery.Append(" INNER JOIN machost_atulya.mac_param_master pm ON pm.`Machine_ParamID`=mo.`Machine_ParamID`  ");
            //sbQuery.Append(" WHERE mo.`LabNo`=@LabNo AND mo.`Reading`<>'' ORDER BY mo.`id`) a ");
            //sbQuery.Append(" GROUP BY LabObservation_id ");
            //using (DataTable dtMacData = MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
            //      new MySqlParameter("@LabNo", BarcodeNo.Trim())).Tables[0])
            //{

            string str = Util.GetStringWithoutReplace(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT `LabInves_Description` FROM patient_labobservation_opd_text WHERE `Test_ID`=@Test_ID",
                new MySqlParameter("@Test_ID", TestId)));
            //if (dtMacData.Rows.Count > 0)
            //{
            //    foreach (DataRow dr in dtMacData.Rows)
            //    {
            //        if (str.Contains(string.Format("{{{0}}}", dr["LabObservation_id"])))
            //        {
            //            str = str.Replace(string.Format("{{{0}}}", dr["LabObservation_id"]), dr["Reading"].ToString());
            //        }
            //    }
            //}
            return str;
            //  }
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
    public static string SaveLabObservationOpdData(List<ResultEntryProperty> data, string ResultStatus, string ApprovedBy, string ApprovalName, string HoldRemarks, string criticalsave, string notapprovalcomment, string macvalue, int MachineID_Manual = 0, int MobileApproved = 0, string IsDefaultSing = "0", string MobileEMINo = "", string MobileNo = "", string MobileLatitude = "", string MobileLongitude = "",string isholddocumentrequired="0")
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(8);
        int ReqCount = MT.GetIPCount(8);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return "Too Many Request,Try Again after some";
        }
        if (data.Count == 0)
            return string.Empty;
        data = data.Where(x => x.SaveInv == "true").ToList();
        DLC_Check(data, ResultStatus);

        ResultEntryProperty pOpd = new ResultEntryProperty();
        int noOfRowsUpdated = data.Count;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string oldPLIID = string.Empty;
        int RowsAffected = 0;
        string isPartial_PLID = string.Empty;
        int isPartial = 0;
        string deleteTestID = string.Empty;
        string deleteTestIDAftersave = string.Empty;
        DataTable oldvalue = new DataTable();
        string TestIDList = string.Empty;
        try
        {
            int i = 0;
            string oldCurLabNo = string.Empty;
            int IsAmendmentAllowed = 0;
            if (ResultStatus == "Approved" || ResultStatus == "Save")
            {
                IsAmendmentAllowed = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT IsEditMacReading FROM employee_master WHERE Employee_id=@Employee_id ",
                   new MySqlParameter("@Employee_id", UserInfo.ID)));
            }

            foreach (ResultEntryProperty pdeatil in data)
            {
                if ((pdeatil.Inv == "1") || (pdeatil.Inv == "3"))
                    continue;

                else if (pdeatil.Inv == "2")
                {
                    continue;
                }

                string str = string.Empty; ;
                string ID = pdeatil.ID;
                string PLId = pdeatil.PLIID;
                string value = pdeatil.Value;
                string rangetype = pdeatil.rangetype;

                int ResultRequiredField = Util.GetInt(pdeatil.ResultRequired);
                string flag = pdeatil.Flag;
                if (flag == "Normal")
                    flag = string.Empty;
                int strPrintSeparate;

                if (pdeatil.Flag == string.Empty || pdeatil.Flag == "0")
                    strPrintSeparate = 0;
                else
                    strPrintSeparate = 1;

                // Delete PLO Value
                if (deleteTestID != pdeatil.Test_ID)
                {
                    MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "DELETE FROM patient_labobservation_opd WHERE `Test_ID`=@Test_ID",
                    new MySqlParameter("@Test_ID", pdeatil.Test_ID));

                    deleteTestID = pdeatil.Test_ID;

                    oldvalue = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select id,value,LabObservation_ID from patient_labobservation_opd_audittrail where Test_ID=@Test_ID ",
                       new MySqlParameter("@Test_ID", pdeatil.Test_ID)).Tables[0];
                    TestIDList = TestIDList == "" ? pdeatil.Test_ID  : TestIDList + "," + pdeatil.Test_ID;
                }

                if (pdeatil.ReportType == "1")
                {
                    float re = 0;
                    if (pdeatil.isAmr == "1" && pdeatil.AmrMin != string.Empty && pdeatil.AmrMax != string.Empty && pdeatil.AmrMin != null && pdeatil.AmrMax != null)
                    {
                        if (float.TryParse(pdeatil.Value, out re))
                        {
                            if (Util.GetFloat(pdeatil.Value) < Util.GetFloat(pdeatil.AmrMin) || Util.GetFloat(pdeatil.Value) > Util.GetFloat(pdeatil.AmrMax))
                            {
                                if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT AmrValueAccess FROM employee_master where employee_id=@employee_id",
                                   new MySqlParameter("@employee_id", UserInfo.ID))) == 0)
                                {
                                    Exception ex = new Exception(string.Format("{0} value must be with in {1} to {2}", pdeatil.LabObservationName, pdeatil.AmrMin, pdeatil.AmrMax));
                                    throw (ex);
                                }
                            }
                        }
                        else if (pdeatil.Value.Trim() != string.Empty)
                        {
                            Exception ex = new Exception(pdeatil.LabObservationName + " value must be numeric and in proper format");
                            throw (ex);
                        }
                    }

                    if (ResultStatus == "Approved" || ResultStatus == "Forward" || ResultStatus == "Save")
                    {
                        if (float.TryParse(pdeatil.Value.Trim(), out re))
                        {
                            if (Util.GetFloat(pdeatil.Value.Trim()) < 0)
                            {
                                Exception ex = new Exception(pdeatil.LabObservationName + " value cannot be negative ");
                                throw (ex);
                            }
                        }
                    }
                    Patient_LabObservation_OPD objPLOI = new Patient_LabObservation_OPD(tnx);
                    objPLOI.LabObservation_ID = pdeatil.LabObservation_ID;
                    objPLOI.LabObservationName = pdeatil.LabObservationName;
                    objPLOI.MaxValue = pdeatil.MaxValue;
                    objPLOI.MinValue = pdeatil.MinValue;
                    objPLOI.Test_ID = pdeatil.Test_ID;
                    objPLOI.Value = ((Util.GetInt(pdeatil.IsComment) == 0) ? pdeatil.Value : pdeatil.Description);
                    objPLOI.ResultDateTime = Util.GetDateTime(DateTime.Now);
                    objPLOI.Priorty = i;
                    objPLOI.ReadingFormat = pdeatil.ReadingFormat;
                    objPLOI.DisplayReading = pdeatil.DisplayReading;
                    objPLOI.Description = pdeatil.Description;
                    objPLOI.OrganismID = pdeatil.OrganismID;
                    objPLOI.IsOrganism = Util.GetInt(pdeatil.IsOrganism);
                    objPLOI.ParamEnteredBy = UserInfo.ID.ToString();
                    objPLOI.ParamEnteredByName = Util.GetString(HttpContext.Current.Session["LoginName"]);
                    objPLOI.MacReading = pdeatil.MacReading;
                    try
                    {
                        objPLOI.dtMacEntry = Util.GetDateTime(pdeatil.dtMacEntry);
                    }
                    catch
                    {
                    }
                    objPLOI.MachineID = Util.GetInt(pdeatil.MachineID);
                    objPLOI.Method = pdeatil.Method;
                    objPLOI.PrintMethod = Util.GetInt(pdeatil.PrintMethod);
                    objPLOI.LedgerTransactionNo = pdeatil.LabNo;
                    objPLOI.IsCommentField = Util.GetInt(pdeatil.IsComment);
                    objPLOI.ResultRequiredField = Util.GetInt(pdeatil.ResultRequiredField);
                    objPLOI.IsCritical = 0;// Util.GetInt(pdeatil.IsCritical);
                    objPLOI.MinCritical = Util.GetString(pdeatil.MinCritical);
                    objPLOI.MaxCritical = Util.GetString(pdeatil.MaxCritical);
                    objPLOI.ResultEnteredBy = UserInfo.ID.ToString();
                    objPLOI.ResultEnteredDate = DateTime.Now;
                    objPLOI.ResultEnteredName = Util.GetString(HttpContext.Current.Session["LoginName"]);
                    objPLOI.AbnormalValue = Util.GetString(pdeatil.AbnormalValue);
                    objPLOI.Flag = Util.GetString(pdeatil.Flag);
                    objPLOI.MachineName = Util.GetString(pdeatil.machinename);
                    if (objPLOI.Value == "HEAD" && objPLOI.IsOrganism == 1)
                    {
                        objPLOI.IsBold = 1;
                        objPLOI.IsUnderLine = 1;
                    }
                    else
                    {
                        objPLOI.IsBold = Util.GetInt(pdeatil.IsBold);
                        objPLOI.IsUnderLine = Util.GetInt(pdeatil.IsUnderLine);
                    }

                 //   objPLOI.IsMic = Util.GetInt(pdeatil.isMic);
                    objPLOI.IsMic = Util.GetInt(0);
                    objPLOI.PrintSeparate = Util.GetInt(pdeatil.PrintSeparate);
                    objPLOI.ShowDeltaReport = Util.GetInt(pdeatil.ShowDeltaReport);
                    objPLOI.Insert();
                    i++;

                    //------------Apurva Code for check Mac Reading Amendment starts here : 15-12-2018 --------

                    if (ResultStatus == "Approved" || ResultStatus == "Save")
                    {
                        if (IsAmendmentAllowed != 1)
                        {
                            if (pdeatil.MacReading != string.Empty && Util.GetString(pdeatil.MacReading) != string.Empty)
                            {
                                if (pdeatil.Value != pdeatil.MacReading)
                                {
                                    Exception ex = new Exception("Mac Reading is different From Value. You do not have permission");
                                    throw (ex);
                                }

                            }
                        }
                    }
                    StringBuilder sbsaveaudit = new StringBuilder();
                    string oldsavedvalue = string.Empty;
                    try
                    {
                        if (oldvalue.Rows.Count > 0)
                        {

                            DataRow[] dr = oldvalue.Select(string.Format("LabObservation_ID='{0}'", pdeatil.LabObservation_ID));
                            DataTable dtnewoldvalue = dr.CopyToDataTable<DataRow>();
                            if (dtnewoldvalue.Rows.Count > 0)
                            {
                                dtnewoldvalue.DefaultView.Sort = "id desc";
                                dtnewoldvalue = dtnewoldvalue.DefaultView.ToTable();
                                oldsavedvalue = Util.GetString(dtnewoldvalue.Rows[0]["value"]);
                                if (oldsavedvalue != pdeatil.Value)
                                {
                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labobservation_opd_audittrail (LabObservation_ID,Test_ID,Value,OldValue,ResultDateTime,ResultEnterdByID,ResultEnterdByName) values(@LabObservation_ID,@Test_ID,@Value,@OldValue,now(),@ResultEnterdByID,@ResultEnterdByName) ",
                                       new MySqlParameter("@LabObservation_ID", pdeatil.LabObservation_ID), new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                                       new MySqlParameter("@Value", pdeatil.Value), new MySqlParameter("@OldValue", oldsavedvalue),
                                       new MySqlParameter("@ResultEnterdByID", UserInfo.ID), new MySqlParameter("@ResultEnterdByName", UserInfo.LoginName));
                                }
                            }
                            else
                            {
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labobservation_opd_audittrail (LabObservation_ID,Test_ID,Value,OldValue,ResultDateTime,ResultEnterdByID,ResultEnterdByName) values(@LabObservation_ID,@Test_ID,@Value,'',now(),@ResultEnterdByID,@ResultEnterdByName) ",
                                    new MySqlParameter("@LabObservation_ID", pdeatil.LabObservation_ID), new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                                    new MySqlParameter("@Value", pdeatil.Value),
                                    new MySqlParameter("@ResultEnterdByID", UserInfo.ID), new MySqlParameter("@ResultEnterdByName", UserInfo.LoginName));
                            }
                        }
                        else
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labobservation_opd_audittrail (LabObservation_ID,Test_ID,Value,OldValue,ResultDateTime,ResultEnterdByID,ResultEnterdByName) values(@LabObservation_ID,@Test_ID,@Value,'',now(),@ResultEnterdByID,@ResultEnterdByName) ",
                                 new MySqlParameter("@LabObservation_ID", pdeatil.LabObservation_ID), new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                                 new MySqlParameter("@Value", pdeatil.Value),
                                 new MySqlParameter("@ResultEnterdByID", UserInfo.ID), new MySqlParameter("@ResultEnterdByName", UserInfo.LoginName));
                        }
                    }
                    catch
                    {
                    }
                    double isdouble;
                    if (criticalsave != "1")
                    {
                        if ((value != string.Empty) && (pdeatil.IsCritical == "1") && double.TryParse(value.Trim(), out isdouble) && Util.GetString(pdeatil.AbnormalValue) == string.Empty && pdeatil.MinCritical != null && pdeatil.MaxCritical != null)
                        {
                            try
                            {
                                if (Util.GetDouble(value.Trim()) <= Util.GetDouble(pdeatil.MinCritical) || Util.GetDouble(value.Trim()) >= Util.GetDouble(pdeatil.MaxCritical))
                                {
                                    //------------------Critical Value Email & SMS---------------
                                    if (ResultStatus == "Approved")
                                    {
                                        string LtNo = pdeatil.LabNo;
                                        StringBuilder sb = new StringBuilder();
                                        sb.Append(" select lt.`LedgerTransactionID`,cm.centre as Location ,lt.PName,Date_Format(lt.date,'%d %b %y') as Date, lt.`Patient_ID`, lt.CentreID, fpm.Mobile ClientMobile, pm.`Mobile` as PMobile, dr.Mobile,dr.Email as DoctorEmail, lt.`PName`,lt.`Panel_ID`,cm.Type1ID from f_ledgertransaction lt ");
                                        sb.Append(" INNER JOIN doctor_referal  dr ON lt.`Doctor_ID`=dr.Doctor_Id ");
                                        sb.Append(" inner join Patient_Master pm on pm.`Patient_ID`=lt.`Patient_ID` ");
                                        sb.Append("  inner join Centre_Master cm ON cm.`CentreID`=lt.`CentreID` ");
                                        sb.Append(" INNER JOIN  f_panel_master fpm ON lt.`Panel_ID`=fpm.`Panel_ID` ");
                                        sb.Append(" WHERE lt.`LedgerTransactionNo`=@LedgerTransactionNo ");
                                        DataTable dtPanicValuesData = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                           new MySqlParameter("@LedgerTransactionNo", LtNo)).Tables[0];
                                        if (dtPanicValuesData.Rows.Count > 0)
                                        {
                                            try
                                            {
                                                string CentreID = dtPanicValuesData.Rows[0]["centreId"].ToString();
                                                string DrMobile = dtPanicValuesData.Rows[0]["Mobile"].ToString();
                                                string Pname = dtPanicValuesData.Rows[0]["PName"].ToString();
                                                string PanicValue = string.Format("{0} : {1}", pdeatil.LabObservationName, value);
                                                string ClientMobile = dtPanicValuesData.Rows[0]["ClientMobile"].ToString();
                                                string PMobile = dtPanicValuesData.Rows[0]["PMobile"].ToString();
                                                string Patient_ID = dtPanicValuesData.Rows[0]["Patient_ID"].ToString();
                                                string Location = dtPanicValuesData.Rows[0]["Location"].ToString();
                                                string visitDateTime = dtPanicValuesData.Rows[0]["Date"].ToString();
                                                string DoctorEmail = dtPanicValuesData.Rows[0]["DoctorEmail"].ToString();
                                               
                                               
                                                //----SMS-----------------------

                                              //  if (DrMobile != string.Empty)
                                             //   {
                                                    //string SMS = string.Format("Your patient {0}, have critical values for observations- {1}", Pname, PanicValue);
                                                    //StringBuilder sb1 = new StringBuilder();
                                                    //sb.Append(" INSERT INTO SMS(Mobile_No,SMS_Text,IsSend,EntDate,UserId) VALUES ");
                                                    //sb.Append(" (@Mobile_No,@SMS_Text,'0',NOW(),@UserId) ");
                                                    //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString(),
                                                    //       new MySqlParameter("@Mobile_No", DrMobile),
                                                    //       new MySqlParameter("@SMS_Text", SMS),
                                                    //       new MySqlParameter("@UserId", UserInfo.ID));
                                              //  }

                                                    //sms
                                                    int isallow = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1)  FROM sms_configuration WHERE id=15 AND (IsDoctor=1 OR IsClient=1)"));
                                                    if (isallow == 1)
                                                    {
                                                        SMSDetail sd = new SMSDetail();
                                                        JSONResponse SMSResponse = new JSONResponse();

                                                        List<SMSDetailListRegistration> SMSDetail = new List<SMSDetailListRegistration>{  
                                                             new SMSDetailListRegistration {
                                                                 LabNo=Util.GetString(LtNo), 
                                                                 PName = Util.GetString(Pname), 
                                                                 ItemName=PanicValue }};

                                                        if (Util.GetString(ClientMobile) != string.Empty)
                                                        {
                                                            SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(15, Util.GetInt(dtPanicValuesData.Rows[0]["Panel_ID"]), Util.GetInt(dtPanicValuesData.Rows[0]["Type1ID"]), "Client", Util.GetString(ClientMobile), Util.GetInt(dtPanicValuesData.Rows[0]["LedgerTransactionID"]), con, tnx, SMSDetail));
                                                        }
                                                        if (Util.GetString(DrMobile) != string.Empty)
                                                        {
                                                            SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(15, Util.GetInt(dtPanicValuesData.Rows[0]["Panel_ID"]), Util.GetInt(dtPanicValuesData.Rows[0]["Type1ID"]), "Doctor", Util.GetString(DrMobile), Util.GetInt(dtPanicValuesData.Rows[0]["LedgerTransactionID"]), con, tnx, SMSDetail));
                                                        }
                                                        SMSDetail.Clear();
                                                    }
                                                
                                                //-----Email--------------------------
                                                if (DoctorEmail != string.Empty)
                                                {
                                                    StringBuilder sbCritical = new StringBuilder();
                                                    sbCritical.Append(" insert into Email_Critical(LedgertransactionNo,EnteredByID,MailedTo,IpAddress,LabObservation_ID)");
                                                    sbCritical.Append(" values(@LedgertransactionNo,@EnteredByID,@DoctorEmail,@IpAddress,@LabObservation_ID) ");
                                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbCritical.ToString(),
                                                    new MySqlParameter("@LedgertransactionNo", LtNo),
                                                    new MySqlParameter("@EnteredByID", Util.GetString(UserInfo.ID)),
                                                    new MySqlParameter("@IpAddress", Util.GetString(StockReports.getip())),
                                                    new MySqlParameter("@DoctorEmail", Util.GetString(DrMobile)),
                                                    new MySqlParameter("@LabObservation_ID", Util.GetString(pdeatil.LabObservation_ID)));
                                                }
                                                //-----------------------------------

                                            }
                                            catch
                                            {

                                            }
                                        }
                                    }
                                    //------------------Critical Value Email & SMS End------------

                                    Exception ex = new Exception("Critical");
                                    throw (ex);
                                }
                            }
                            catch (Exception ex)
                            {
                                throw (ex);
                            }
                        }
                        else if ((value != string.Empty) && (pdeatil.IsCritical == "1") && (Util.GetString(pdeatil.AbnormalValue) != string.Empty) && (value.ToUpper() == pdeatil.AbnormalValue.ToUpper()))
                        {
                            Exception ex = new Exception("Critical");
                            throw (ex);
                        }
                        else if ((value != string.Empty) && (pdeatil.Flag != "Normal") && (pdeatil.ShowAbnormalAlert == "1"))
                        {
                            try
                            {
                                Exception ex = new Exception("AbnormalAlert");
                                throw (ex);
                            }
                            catch (Exception ex)
                            {
                                throw (ex);
                            }
                        }
                    }

                    try
                    {
                        if (macvalue != "1")
                        {
                            if (pdeatil.MacReading != string.Empty && pdeatil.MacReading != null && Util.GetDouble(value.Trim()) != Util.GetDouble(pdeatil.MacReading))
                            {
                                Exception ex = new Exception("MacValue");
                                throw (ex);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                    }


                    if (ResultStatus == "Approved" && value != string.Empty && pdeatil.IsCritical == "1")
                    {

                        if ((value != string.Empty) && (pdeatil.IsCritical == "1") && (Util.GetString(pdeatil.AbnormalValue) != string.Empty) && (value.ToUpper() == pdeatil.AbnormalValue.ToUpper()))
                        {
                            oldCurLabNo = Util.GetString(pdeatil.LabNo);
                            StringBuilder sbCritical = new StringBuilder();
                            sbCritical.Append(" INSERT INTO Email_Critical(LedgertransactionNo,EnteredByID,IpAddress,LabObservation_ID)");
                            sbCritical.Append(" values(@LedgertransactionNo,@EnteredByID,@IpAddress,@LabObservation_ID) ");
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbCritical.ToString(),
                               new MySqlParameter("@LedgertransactionNo", oldCurLabNo),
                               new MySqlParameter("@EnteredByID", Util.GetString(UserInfo.ID)),
                               new MySqlParameter("@IpAddress", Util.GetString(StockReports.getip())),
                               new MySqlParameter("@LabObservation_ID", Util.GetString(pdeatil.LabObservation_ID)));

                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labobservation_opd set IsCritical=@IsCritical where Test_ID=@Test_ID and LabObservation_ID=@LabObservation_ID",
                                    new MySqlParameter("@IsCritical", "1"),
                                    new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                                    new MySqlParameter("@LabObservation_ID", pdeatil.LabObservation_ID));
                        }
                        else if (double.TryParse(value, out isdouble) && Util.GetDouble(pdeatil.MinCritical) != 0 && Util.GetDouble(pdeatil.MaxCritical) != 0)
                        {
                            if (Util.GetDouble(value.Trim()) <= Util.GetDouble(pdeatil.MinCritical) || Util.GetDouble(value.Trim()) >= Util.GetDouble(pdeatil.MaxCritical))
                            {
                                oldCurLabNo = Util.GetString(pdeatil.LabNo);
                                StringBuilder sbCritical = new StringBuilder();
                                sbCritical.Append(" insert into Email_Critical(LedgertransactionNo,EnteredByID,IpAddress,LabObservation_ID)");
                                sbCritical.Append(" values(@LedgertransactionNo,@EnteredByID,@IpAddress,@LabObservation_ID) ");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbCritical.ToString(),
                                  new MySqlParameter("@LedgertransactionNo", oldCurLabNo),
                                  new MySqlParameter("@EnteredByID", Util.GetString(UserInfo.ID)),
                                  new MySqlParameter("@IpAddress", Util.GetString(StockReports.getip())),
                                  new MySqlParameter("@LabObservation_ID", Util.GetString(pdeatil.LabObservation_ID)));

                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labobservation_opd set IsCritical=@IsCritical where Test_ID=@Test_ID and LabObservation_ID=@LabObservation_ID",
                                    new MySqlParameter("@IsCritical", "1"),
                                    new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                                    new MySqlParameter("@LabObservation_ID", pdeatil.LabObservation_ID));

                            }
                        }

                    }
                    if ((ResultStatus != "UnHold") && (ResultStatus != "Approved"))
                    {
                        if (pdeatil.LabObservation_ID == "211" && (pdeatil.Value.ToUpper() == "POSITIVE" || pdeatil.Value.ToUpper() == "REACTIVE"))// HIV Case
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  Approved = @Approved,ReportType = @ReportType,isHold=@isHold,HoldBy=@HoldBy,HoldByName=@HoldByName  WHERE Test_ID=@ID AND isSampleCollected=@isSampleCollected",
                                                     new MySqlParameter("@Approved", "0"),
                                                     new MySqlParameter("@ReportType", pdeatil.ReportType), new MySqlParameter("@isHold", "1"), new MySqlParameter("@HoldBy", UserInfo.ID), new MySqlParameter("@HoldByName", Util.GetString(HttpContext.Current.Session["LoginName"])),
                                                     new MySqlParameter("@ID", PLId),
                                                     new MySqlParameter("@isSampleCollected", 'Y'));

                        }
                    }


                }
                else
                {
                    // To Check Text Report Value
                    if (pdeatil.ReportType == "3" && pdeatil.ReportType != null)
                    {
                        string htmltext = pdeatil.Description ?? string.Empty;
                        string plaintext = System.Text.RegularExpressions.Regex.Replace(htmltext.Trim(), @"<[^>]+>|&nbsp;|\n|\t", string.Empty).Trim();
                        int AddReportQty = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM patient_labinvestigation_attachment_report WHERE Test_ID =@Test_ID ", new MySqlParameter("@Test_ID", pdeatil.Test_ID)));
                        int IsAvailText = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM patient_labobservation_opd_text WHERE Test_ID =@Test_ID ", new MySqlParameter("@Test_ID", pdeatil.Test_ID)));
                        if (pdeatil.ReportType == "3" && pdeatil.ReportType != null && plaintext.Trim() == string.Empty && AddReportQty == 0 && IsAvailText == 0)
                        {
                            Exception ex = new Exception(pdeatil.LabObservationName + " value can't be blank.....!");
                            throw (ex);
                        }
                    }
                    if (pdeatil.Method == "1")
                    {
                        MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "DELETE FROM patient_labobservation_opd_text WHERE `Test_ID`=@Test_ID",
                        new MySqlParameter("@Test_ID", pdeatil.Test_ID));
                        StringBuilder myStr = new StringBuilder();
                        myStr.Append("INSERT INTO `patient_labobservation_opd_text`(`PLO_ID`,`Test_ID`,`LabInves_Description`,`EntDate`,UserID) ");
                        myStr.Append(" VALUES(@PLO_ID,@Test_ID,@LabInves_Description,@EntDate,@UserID)");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, myStr.ToString(),
                            new MySqlParameter("@PLO_ID", pdeatil.PLIID),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@LabInves_Description", pdeatil.Description),
                            new MySqlParameter("@EntDate", DateTime.Now),
                            new MySqlParameter("@UserID", UserInfo.ID));
                    }
                }


                // Update Result Status

                if (deleteTestIDAftersave != pdeatil.Test_ID)
                {
                    // duplicate entry validation
                    if (Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT Test_ID FROM `patient_labobservation_opd` WHERE test_id=@Test_ID GROUP BY `Test_ID`,`LabObservation_ID`,`Priorty` HAVING COUNT(1) >1",
                        new MySqlParameter("@Test_ID", pdeatil.Test_ID))) != string.Empty)
                    {
                        Exception ex = new Exception("Duplicate Entry Please Contact to ITDOSE Team.");
                        throw (ex);
                    }
                    // Check Flag Low
                    if (data.Count(x => x.Flag == "Low" && x.Test_ID == pdeatil.Test_ID) > 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET IsNormalResult = 2 WHERE Test_ID=@Test_ID ",
                         new MySqlParameter("@Test_ID", pdeatil.Test_ID));
                    }


                    // Check Flag High
                    if (data.Count(x => x.Flag == "High" && x.Test_ID == pdeatil.Test_ID) > 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET IsNormalResult = 3 WHERE Test_ID=@Test_ID ",
                           new MySqlParameter("@Test_ID", pdeatil.Test_ID));
                    }

                    // Check Critical
                    if (data.Count(x => x.IsCritical == "1" && x.Test_ID == pdeatil.Test_ID) > 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET IsCriticalResult = 1 WHERE Test_ID=@Test_ID ",
                          new MySqlParameter("@Test_ID", pdeatil.Test_ID));
                    }

                    if (ResultStatus == "Forward")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET isForward = @isForward, ForwardBy = @ForwardBy, ForwardByName = @ForwardByName,ForwardDate=now() WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@isForward", 1), new MySqlParameter("@ForwardBy", UserInfo.ID), new MySqlParameter("@ForwardByName", UserInfo.LoginName),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'));
                    }
                    if ((ResultStatus == "Approved" || ResultStatus == "Preliminary Report") && IsDefaultSing.Trim() == "1")
                    {
                        StringBuilder sbDef = new StringBuilder();
                        sbDef.Append(" SELECT ia.`ApproveById`,em.`Name` FROM investigation_autoapprovemaster ia ");
                        sbDef.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.`TestCentreID`=ia.`CentreId` ");
                        sbDef.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=ia.`ApproveById` AND plo.`SubCategoryID`=ia.`departmentid` ");
                        sbDef.Append(" Where plo.`Test_ID`=@Test_ID AND plo.`SubCategoryID`=@SubCategoryID AND ia.`IsActive`=@IsActive  AND  em.`IsActive`=@IsActive");
                        using (DataTable dtDefaulSign = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sbDef.ToString(),
                                new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                                new MySqlParameter("@SubCategoryID", pdeatil.SubCategoryID),
                                new MySqlParameter("@IsActive", "1")).Tables[0])
                        {
                            if (dtDefaulSign.Rows.Count > 0)
                            {
                                ApprovedBy = Util.GetString(dtDefaulSign.Rows[0]["ApproveById"]);
                                ApprovalName = Util.GetString(dtDefaulSign.Rows[0]["Name"]);
                            }
                            else
                            {
                                Exception ex = new Exception("Report Not Approved Because Signature Is Not Available.Please Contact To IT Team..!");
                                throw (ex);
                            }
                        }


                    }


                    //----------Approved Validation by Apurva 04/09/2018--

                    if (ResultStatus != "Not Approved")
                    {
                        string IsApproved = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT Approved FROM Patient_LabInvestigation_OPD WHERE Test_Id = @Test_Id",
                           new MySqlParameter("@Test_Id", pdeatil.Test_ID)));
                        if (IsApproved == "1")
                        {
                            Exception ex = new Exception("Result is Already Approved !");
                            throw (ex);
                        }
                    }

                    //----------------------------------------------------
                    if (ResultStatus == "Approved")
                    {

                        string SignatureID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT SigantureID FROM f_approval_signature WHERE EmployeeID=@EmployeeID AND isActive=1",
                           new MySqlParameter("@EmployeeID", ApprovedBy)));

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET SignatureID=@SignatureID, Approved = @Approved, ApprovedBy = @ApprovedBy, ApprovedName = @ApprovedName,ApprovedDoneBy=@ApprovedDoneBy,ApprovedDate=now(), ResultEnteredBy=if(Result_Flag=0,@UserID,ResultEnteredBy),ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,@LoginName,ResultEnteredName),Result_Flag=1 WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected and Approved=0  and ishold=0 ",
                            new MySqlParameter("@Approved", 1), new MySqlParameter("@SignatureID", (SignatureID == "" ? "0" : SignatureID)), new MySqlParameter("@ApprovedName", ApprovalName),
                            new MySqlParameter("@ApprovedDoneBy", UserInfo.ID), new MySqlParameter("@ApprovedBy", ApprovedBy),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@LoginName", Util.GetString(HttpContext.Current.Session["LoginName"])),
                            new MySqlParameter("@isSampleCollected", 'Y'));




                    }
                    if (ResultStatus == "Not Approved")
                    {
                         string entrydatetime = System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");                       
                       
                        // Save Not Approval Data in New Table
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "call Insert_UnApprove_Plo(@Test_ID,@UnapproveDate,@LedgerTransactionNo,@UnapprovebyID,@Unapproveby,@Comments,@ipaddress,@ReportType)",
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID), new MySqlParameter("@UnapproveDate", entrydatetime), new MySqlParameter("@LedgerTransactionNo", Util.GetString(pdeatil.LabNo)),
                           new MySqlParameter("@UnapprovebyID", Util.GetString(UserInfo.ID)), new MySqlParameter("@Unapproveby", Util.GetString(UserInfo.LoginName)),
                           new MySqlParameter("@Comments", notapprovalcomment.ToUpper()),
                           new MySqlParameter("@ipaddress", StockReports.getip()),
                            new MySqlParameter("@ReportType", Util.GetInt(pdeatil.ReportType)));                                        

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  NotApprovedCount=NotApprovedCount+1 ,Approved = @Approved, isForward = @isForward, isPrint = @isPrint WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@Approved", "0"), new MySqlParameter("@isForward", "0"), new MySqlParameter("@isPrint", "0"),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'));                       

                        // For Insta
                        DataTable dtInsta = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, " SELECT plo.`ItemID_Interface`,plo.`Interface_companyName` FROM `patient_labinvestigation_opd` plo WHERE plo.`Test_ID`=@Test_ID ",
                             new MySqlParameter("@Test_ID", pdeatil.Test_ID)).Tables[0];
                        if (dtInsta.Rows.Count > 0)
                        {
                            if (Util.GetString(dtInsta.Rows[0]["Interface_companyName"]).Trim().ToLower() == "insta")
                            {
                                StringBuilder sbInsta = new StringBuilder();
                                sbInsta.Append(" INSERT INTO booking_data_notapproved(Test_ID,ItemID_Interface,LedgerTransactionNo) ");
                                sbInsta.Append(" VALUES(@Test_ID,@ItemID_Interface,@LedgerTransactionNo) ");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbInsta.ToString(),
                                    new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                                    new MySqlParameter("@ItemID_Interface", Util.GetString(dtInsta.Rows[0]["ItemID_Interface"])),
                                    new MySqlParameter("@LedgerTransactionNo", Util.GetString(pdeatil.LabNo)));

                                sbInsta = new StringBuilder();
                                sbInsta.Append(" DELETE FROM `booking_data_result_insta` WHERE `Test_ID`=@Test_ID ");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbInsta.ToString(),
                                    new MySqlParameter("@Test_ID", pdeatil.Test_ID));

                            }
                        }
                    }
                    if (ResultStatus == "Un Forward")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET ForwardToDoctor=0,ForwardToCentre=0, isForward = @isForward WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@isForward", "0"),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'));
                    }
                    if (ResultStatus == "Preliminary Report")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  Preliminary = @Preliminary,PreliminaryBy = @PreliminaryBy,PreliminaryName=@PreliminaryName,PreliminaryDateTime=@PreliminaryDateTime,ApprovedBy=@ApprovedBy,ApprovedName=@ApprovedName WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@Preliminary", "1"),
                            new MySqlParameter("@PreliminaryBy", UserInfo.ID), new MySqlParameter("@PreliminaryName", UserInfo.LoginName), new MySqlParameter("@PreliminaryDateTime", DateTime.Now), new MySqlParameter("@ApprovedBy", ApprovedBy), new MySqlParameter("@ApprovedName", ApprovalName),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'));
                    }
                    if (ResultStatus == "UnHold")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  isHold = @isHold,UnHoldBy = @UnHoldBy,UnHoldByName=@UnHoldByName,unholddate=now() WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected and isHold=1",
                            new MySqlParameter("@isHold", "0"),
                            new MySqlParameter("@UnHoldBy", UserInfo.ID),
                            new MySqlParameter("@UnHoldByName", UserInfo.LoginName),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'));
                    }
                    if (ResultStatus == "Hold")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  isHold = @isHold,HoldBy = @HoldBy,HoldByName=@HoldByName,Hold_Reason=@Hold_Reason,isholddocumentrequired=@isholddocumentrequired WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected and isHold =0 ",
                            new MySqlParameter("@isHold", "1"),
                            new MySqlParameter("@HoldBy", UserInfo.ID),
                            new MySqlParameter("@HoldByName", UserInfo.LoginName), new MySqlParameter("@Hold_Reason", HoldRemarks),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isholddocumentrequired", isholddocumentrequired),
                            new MySqlParameter("@isSampleCollected", 'Y'));


                    }

                    if (criticalsave == "1" && ResultStatus == "Save")
                    {
                        double isdouble1;
                        if (double.TryParse(value, out isdouble1) && Util.GetDouble(pdeatil.MaxCritical) != 0)
                        {
                            if (Util.GetDouble(value.Trim()) <= Util.GetDouble(pdeatil.MinCritical) || Util.GetDouble(value.Trim()) >= Util.GetDouble(pdeatil.MaxCritical))
                            {
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  Approved = @Approved,ReportType = @ReportType,isHold=@isHold,HoldBy=@HoldBy,HoldByName=@HoldByName,Hold_Reason=@Hold_Reason,HoldType=@HoldType  WHERE Test_ID=@ID AND isSampleCollected=@isSampleCollected",
                                              new MySqlParameter("@Approved", "0"),
                                              new MySqlParameter("@ReportType", pdeatil.ReportType), new MySqlParameter("@isHold", "1"), new MySqlParameter("@HoldBy", UserInfo.ID), new MySqlParameter("@HoldByName", Util.GetString(HttpContext.Current.Session["LoginName"])),
                                              new MySqlParameter("@ID", PLId),
                                              new MySqlParameter("@isSampleCollected", 'Y'), new MySqlParameter("@Hold_Reason", "Hold Due To Critical"), new MySqlParameter("@HoldType", "Auto"));

                                StringBuilder sb = new StringBuilder();
                                sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                                sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,concat('Auto Hold due to Critical of ',itemName),@UserID,@LoginName,@IpAddress,@CentreID, ");
                                sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE Test_ID =@Test_ID");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                   new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@LoginName", UserInfo.LoginName), new MySqlParameter("@CentreID", UserInfo.Centre),
                                   new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@RoleID", UserInfo.RoleID),
                                   new MySqlParameter("@Test_ID", pdeatil.Test_ID));

                            }
                        }
                    }
                    isPartial = 0;
                    //*Start The below code use for store mobile transaction details 
                    if (MobileApproved == 1)
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append("INSERT INTO `patient_labinvestigation_opd_mobile_transaction`(`Test_ID`,`Status`,`UserID`,`MobileEMINo`,MobileNo,MobileLatitude,MobileLongitude)");
                        sb.Append(" VALUES(@Test_ID,@Status,@UserID,@MobileEMINo,@MobileNo,@MobileLatitude,@MobileLongitude)");
                        RowsAffected = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@Status", ResultStatus),
                            new MySqlParameter("@UserID", UserInfo.ID),
                            // new MySqlParameter("@EntryDateTime", Util.GetString(UserInfo.LoginName)), new MySqlParameter("@dtEntry", DateTime.Now),
                            new MySqlParameter("@MobileEMINo", Util.GetString(MobileEMINo)),
                            new MySqlParameter("@MobileNo", Util.GetString(MobileNo)),
                            new MySqlParameter("@MobileLatitude", Util.GetString(MobileLatitude)),
                            new MySqlParameter("@MobileLongitude", Util.GetString(MobileLongitude))
                         );
                    }
                    //* End
                    string audit = savestatus(tnx, pdeatil.BarcodeNo, pdeatil.LabNo, pdeatil.Test_ID, string.Format("Report {0} For :{1}", ResultStatus, pdeatil.TestName));
                    if (audit == "fail")
                    {
                        Exception ex = new Exception("Status Not Saved.Please Contact To Itdose..!");
                        throw (ex);
                    }

                    deleteTestIDAftersave = pdeatil.Test_ID;
                }

                if ((value != string.Empty) || (pdeatil.Description != string.Empty && pdeatil.Description != null))
                {
                    if ((oldPLIID != PLId))
                    {
                        if (value != "HEAD" && ResultStatus == "Save")
                        {
                            str = "update patient_labinvestigation_opd set  MobileApproved=@MobileApproved,MachineID_Manual=@MachineID_Manual,ResultEnteredBy=if(Result_Flag=0,@UserID,ResultEnteredBy),ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,@LoginName,ResultEnteredName),Result_Flag=1 ";
                            if (isPartial == 0)
                            {
                                str += ",isPartial_Result='0' ";
                            }
                            str += " where test_id=@test_id  and isSampleCollected='Y' and approved=0 ";
                            RowsAffected = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str,
                               new MySqlParameter("@MobileApproved", Util.GetInt(MobileApproved)), new MySqlParameter("@MachineID_Manual", Util.GetInt(MachineID_Manual)),
                               new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@LoginName", Util.GetString(HttpContext.Current.Session["LoginName"])),
                               new MySqlParameter("@test_id", PLId));
                            oldPLIID = PLId;
                            isPartial = 0;
                        }
                    }
                }
                else
                {
                    if (isPartial_PLID != PLId && ResultRequiredField == 1)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  PrintSeparate = @PrintSeparate,isPartial_Result = @isPartial_Result  WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@PrintSeparate", strPrintSeparate), new MySqlParameter("@isPartial_Result", "1"),
                            new MySqlParameter("@Test_ID", PLId),
                            new MySqlParameter("@isSampleCollected", 'Y'));
                        isPartial_PLID = PLId;
                        isPartial = 1;
                    }
                }
            }
            // notification
            if (ResultStatus == "Hold" && isholddocumentrequired == "1")
            {
                Notification_Insert.notificationInsert(2, data[0].LabNo, tnx, 0, data[0].LabNo, 0, 0, string.Concat("Document Required For Lab No ", data[0].LabNo), "", "patient_labinvestigation_opd", "isHold", "SampleHold");

            }
            string oldInterTestID = string.Empty;
            foreach (ResultEntryProperty pdeatil in data)
            {
                if ((pdeatil.Inv == "1") || (pdeatil.Inv == "3"))
                    continue;

                else if (pdeatil.Inv == "2")
                {
                    continue;
                }
                int ObsQty = 0;
                int DoInter = 0;
                int DoInterObs = 0;
                string TypeOfInterpretation = string.Empty;
                DataTable dtTempInter = new DataTable();
                if (oldInterTestID != pdeatil.Test_ID)
                {
                    oldInterTestID = pdeatil.Test_ID;
                }
                else
                {
                    continue;
                }
                string ploDataFlag = Util.GetString(pdeatil.Flag);
                if (ploDataFlag.Trim() == string.Empty)
                    ploDataFlag = "Normal";
                ObsQty = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT count(*) FROM `labobservation_investigation` WHERE investigation_id=@investigation_id ",
                        new MySqlParameter("@investigation_id", pdeatil.Investigation_ID)));
                string MachineID = "1";
                try
                {
                    MachineID = (pdeatil.MachineID.Trim() == "" || pdeatil.MachineID == "0") ? "1" : pdeatil.MachineID;
                }
                catch { }
                int TestCentreID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT TestCentreID from Patient_labinvestigation_opd WHERE Test_ID=@Test_ID ",
                       new MySqlParameter("@Test_ID", pdeatil.Test_ID)));
                dtTempInter = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, " SELECT id,labObservation_ID,flag,Interpretation,PrintInterTest,PrintInterPackage FROM labobservation_master_interpretation   where labObservation_ID=@labObservation_ID and flag=@flag and centreid=@centreid and macid=@macid and isactive=1",
                        new MySqlParameter("@labObservation_ID", pdeatil.LabObservation_ID),
                        new MySqlParameter("@flag", ploDataFlag),
                        new MySqlParameter("@centreid", TestCentreID==0? "1":TestCentreID.ToString()),
                        new MySqlParameter("@macid",MachineID)).Tables[0];
                if (ObsQty == 1 && dtTempInter.Rows.Count > 0)  // Observation Wise Interpretation 
                {
                    if (pdeatil.IsPackage == "1" && Util.GetString(dtTempInter.Rows[0]["PrintInterPackage"]) == "1")
                    {
                        DoInterObs = 1;
                        TypeOfInterpretation = "ObservationWise";
                    }
                    else if (pdeatil.IsPackage == "0" && Util.GetString(dtTempInter.Rows[0]["PrintInterTest"]) == "1")
                    {
                        DoInterObs = 1;
                        TypeOfInterpretation = "ObservationWise";
                    }
                    if (DoInterObs == 1 && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != string.Empty && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "<br/>" && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "<br />")
                    {

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labinvestigation_opd set InterpretationID=@InterpretationID ,InterpretationType=@TypeOfInterpretation where test_id=@test_id ",
                        new MySqlParameter("@test_id", pdeatil.Test_ID),
                        new MySqlParameter("@InterpretationID", Util.GetInt(dtTempInter.Rows[0]["ID"])),
                        new MySqlParameter("@TypeOfInterpretation", TypeOfInterpretation)
                        );



                    }
                }
                dtTempInter = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, " SELECT id,Investigation_Id,Interpretation,PrintInterTest,PrintInterPackage FROM investigation_master_interpretation where Investigation_Id=@Investigation_Id and centreid=@centreid and macid=@macid and isactive=1 ",
                    new MySqlParameter("@Investigation_Id", pdeatil.Investigation_ID),
                   new MySqlParameter("@centreid", TestCentreID == 0 ? "1" : TestCentreID.ToString()),
                        new MySqlParameter("@macid", MachineID)).Tables[0];
              //  if(UserInfo.ID==3430)
               // System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\mach.txt", " SELECT id,Investigation_Id,Interpretation,PrintInterTest,PrintInterPackage FROM investigation_master_interpretation where Investigation_Id=@Investigation_Id and centreid=@centreid and macid=@macid and isactive=1 " + MachineID + "##" + TestCentreID.ToString());
                if (dtTempInter.Rows.Count > 0)
                {
                    if (pdeatil.IsPackage == "1" && Util.GetString(dtTempInter.Rows[0]["PrintInterPackage"]) == "1")
                    {
                        DoInter = 1;
                        TypeOfInterpretation = "InvestigationWise";
                    }
                    else if (pdeatil.IsPackage == "0" && Util.GetString(dtTempInter.Rows[0]["PrintInterTest"]) == "1")
                    {
                        DoInter = 1;
                        TypeOfInterpretation = "InvestigationWise";
                    }
                    if (DoInter == 1 && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != string.Empty && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "<br/>" && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "<br />")
                    {

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labinvestigation_opd set InterpretationID=@InterpretationID ,InterpretationType=@TypeOfInterpretation where test_id=@test_id ",
                         new MySqlParameter("@test_id", pdeatil.Test_ID),
                         new MySqlParameter("@InterpretationID", Util.GetInt(dtTempInter.Rows[0]["ID"])),
                         new MySqlParameter("@TypeOfInterpretation", TypeOfInterpretation)
                         );



                    }
                }
            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            throw (ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        string IsShift = "1";
        if (TestIDList != "") IsShift = Util.GetString(StockReports.ExecuteScalar("Select IsShift from f_subcategorymaster where subcategoryid in(select distinct SubcategoryID from patient_labinvestigation_opd where Test_Id in("+ TestIDList +")) LIMIT 1"));
        return "success" +"##"+IsShift;
    }
    private static void DLC_Check(List<ResultEntryProperty> data, string ResultStatus)
    {
        float DLC = 0f;
        float Semen = 0f;
        string test = string.Empty;
        string test1 = string.Empty;
        int atfile = 0;
        foreach (ResultEntryProperty pdeatil in data)
        {
            if (pdeatil.DLCCheck == "1")
            {
                DLC = DLC + Util.GetFloat(pdeatil.Value);
                test = string.Format("{0}, {1}", test, pdeatil.LabObservationName);
            }
            /*  if (pdeatil.LabObservation_ID == "1006" || pdeatil.LabObservation_ID=="1007")// semen report
              {
                  Semen = Semen + Util.GetFloat(pdeatil.Value);
                  test1 = test1 + ", " + pdeatil.LabObservationName;
              }*/
            if (pdeatil.LabObservationName == "Attached Report")
            {
                atfile = 1;
            }
            if ((pdeatil.ResultRequired == "1") && (pdeatil.Value == string.Empty) && (ResultStatus == "Approved") && (pdeatil.Method != "1") && (atfile == 0))
                throw (new Exception("All parameter needs to be filled before approval."));


            double o;
            if ((pdeatil.Value != string.Empty) && (pdeatil.IsCritical == "1") && (ResultStatus == "Approved" || ResultStatus == "Save"))
            {
                // bool aa = double.TryParse(pdeatil.Value.Trim(), out o);
                if (double.TryParse(pdeatil.Value.Trim(), out o) && Util.GetString(pdeatil.AbnormalValue) == string.Empty)
                {
                    if (Util.GetDouble(pdeatil.Value.Trim()) <= Util.GetDouble(pdeatil.MinCritical) || Util.GetDouble(pdeatil.Value.Trim()) >= Util.GetDouble(pdeatil.MaxCritical))
                    {


                        if (Util.GetInt(pdeatil.isrerun) == 0 && Util.GetString(pdeatil.MacReading) != string.Empty && Util.GetString(pdeatil.Reading1) == string.Empty)
                            throw (new Exception(string.Format("Please Rerun {0} to proceed further", pdeatil.LabObservationName)));
                    }
                }
                else if (Util.GetString(pdeatil.AbnormalValue) != string.Empty && Util.GetString(pdeatil.AbnormalValue) == pdeatil.Value.Trim())
                {

                    if (Util.GetInt(pdeatil.isrerun) == 0 && Util.GetString(pdeatil.MacReading) != string.Empty && Util.GetString(pdeatil.Reading1) == string.Empty)
                        throw (new Exception(string.Format("Please Rerun {0} to proceed further", pdeatil.LabObservationName)));

                }
            }


        }
        test = test.Trim(',');
        test1 = test1.Trim(',');
        //if (Util.GetFloat(data[0].AgeInDays) > 4745)
        //{
        if ((DLC > 0) && (Convert.ToInt32(DLC) != 100))
            throw (new Exception(string.Format("Total {0} should be equal to 100.", test)));

        if ((Semen > 0) && (Semen != 100))
            throw (new Exception(string.Format("Total {0} should be equal to 100.", test1)));
        //}
    }
    [WebMethod]
    public static string SearchInvestigation(string LabNo, string SmpleColl, string Department)
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
            sbQuery.Append(" SELECT plo.Test_ID,plo.IsSampleCollected,plo.Date, im.name,plo.`SampleTypeID`,plo.`SampleTypeName`,plo.`BarcodeNo`,plo.`LedgerTransactionNo`, ");
            sbQuery.Append(" IF(plo.SampleTypeID=0,   ");
            sbQuery.Append(" IFNULL((SELECT CONCAT(ist.SampleTypeID ,'^',ist.SampleTypeName) FROM investigations_SampleType ist   ");
            sbQuery.Append("  WHERE ist.Investigation_Id =plo.Investigation_ID ORDER BY ist.isDefault DESC,ist.SampleTypeName LIMIT  1),'1|')  ");
            sbQuery.Append(" ,CONCAT(plo.`SampleTypeID`,'|',plo.`SampleTypeName`))  SampleID,    ");
            sbQuery.Append(" GROUP_CONCAT(DISTINCT CONCAT(inv_smpl.SampleTypeID,'|',inv_smpl.SampleTypeName)ORDER BY  inv_smpl.SampleTypeName SEPARATOR '$')SampleTypes    ");
            sbQuery.Append(" FROM `patient_labinvestigation_opd` plo ");
            sbQuery.Append(" INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID` ");

            if (Department != string.Empty)
                sbQuery.Append(" inner join investigation_observationtype iot on iot.Investigation_ID=plo.Investigation_ID and iot.ObservationType_ID=@ObservationType_ID ");

            switch (SmpleColl)
            {
                case "N": sbQuery.Append(" and plo.IsSampleCollected='N' ");
                    break;
                case "Y": sbQuery.Append(" and plo.IsSampleCollected='Y' ");
                    break;
                case "S": sbQuery.Append(" and plo.IsSampleCollected='S' ");
                    break;
            }
            sbQuery.Append(" LEFT JOIN `investigations_SampleType` inv_smpl  ");
            sbQuery.Append(" ON inv_smpl.`Investigation_ID`=im.`Investigation_Id` ");
            sbQuery.Append(" WHERE plo.`LedgerTransactionNo`=@LedgerTransactionNo ");
            sbQuery.Append(" GROUP BY plo.LedgerTransactionNo,plo.Investigation_ID ");
            using (DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
                  new MySqlParameter("@LedgerTransactionNo", LabNo), new MySqlParameter("@ObservationType_ID", Department)).Tables[0])
                return JsonConvert.SerializeObject(dt1);
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
    public static string SaveSampleCollection(string ItemData, string Type)
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(10);
        int ReqCount = MT.GetIPCount(10);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return "Too Many Request,Try Again after some";
        }
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
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ItemData = ItemData.TrimEnd('#');
            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');
            string UserID = UserInfo.ID.ToString();
            if (ItemData != string.Empty)
            {
                for (int i = 0; i < len; i++)
                {
                    StringBuilder sb = new StringBuilder();
                    if (Type == "CR")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  IsSampleCollected = @IsSampleCollected,SampleTypeID = @SampleTypeID,SampleTypeName=@SampleTypeName,SampleSegratedBy_ID=@SampleSegratedBy_ID,SegratedDate=@SegratedDate, UpdateID=@UpdateID,UpdateName=@UpdateName,updateDate=@updateDate,IPAddress=@IPAddress  WHERE Test_ID=@Test_ID",
                           new MySqlParameter("@IsSampleCollected", 'Y'),
                           new MySqlParameter("@SampleTypeID", Item[i].Split('_')[1].ToString()), new MySqlParameter("@SampleTypeName", Item[i].Split('_')[2].ToString()), new MySqlParameter("@SampleSegratedBy_ID", UserInfo.ID),
                           new MySqlParameter("@SampleSegratedBy", UserInfo.LoginName),
                           new MySqlParameter("@SegratedDate", DateTime.Now),
                           new MySqlParameter("@UpdateID", Item[i].Split('_')[1].ToString()), new MySqlParameter("@UpdateName", UserInfo.ID),
                           new MySqlParameter("@updateDate", DateTime.Now), new MySqlParameter("@IPAddress", StockReports.getip()),
                           new MySqlParameter("@Test_ID", Item[i].Split('_')[0].ToString()));
                    }
                    if (Type == "C")
                    {

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  IsSampleCollected = @IsSampleCollected,SampleTypeID = @SampleTypeID,SampleTypeName=@SampleTypeName,SampleSegratedBy_ID=@SampleSegratedBy_ID,SampleSegratedBy=@SampleSegratedBy,SegratedDate=@SegratedDate, UpdateID=@UpdateID,UpdateName=@UpdateName,updateDate=@updateDate,IPAddress=@IPAddress  WHERE Test_ID=@Test_ID",
                           new MySqlParameter("@IsSampleCollected", 'S'),
                           new MySqlParameter("@SampleTypeID", Item[i].Split('_')[1].ToString()),
                           new MySqlParameter("@SampleTypeName", Item[i].Split('_')[2].ToString()),
                           new MySqlParameter("@SampleSegratedBy_ID", UserInfo.ID),
                           new MySqlParameter("@SampleSegratedBy", UserInfo.LoginName),
                           new MySqlParameter("@SegratedDate", DateTime.Now),
                           new MySqlParameter("@UpdateID", Item[i].Split('_')[1].ToString()), new MySqlParameter("@UpdateName", UserInfo.ID),
                           new MySqlParameter("@updateDate", DateTime.Now), new MySqlParameter("@IPAddress", StockReports.getip()),
                           new MySqlParameter("@Test_ID", Item[i].Split('_')[0].ToString()));
                    }

                }
                tnx.Commit();
                return "1";
            }
            else
            {
                return "0";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string getBarcode(string LabNo, string TestID)
    {
        List<string> Test_ID = TestID.TrimEnd(',').Split(',').ToList<string>();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            TestID = TestID.Replace(",", "','");
            sb.Append("SELECT UPPER(PName) AS Patient,CONCAT_WS('/', Age, Gender) AS AG, TestName, ");
            sb.Append(" BarcodeNo AS MachineCode,  LedgerTransactionNo AS PatientNo, ");
            sb.Append(" DATE_FORMAT(DATE, '%d-%b-%y') AS DATE,  Suffix, ");
            sb.Append(" SampleTypeName,ColorCode, ");
            sb.Append("  (SELECT `Company_Name` FROM f_panel_master pnl WHERE pnl.Panel_ID = Panel_ID LIMIT 1) PanelName ");
            sb.Append(" FROM (SELECT lt.date,pm.PName PName, ");
            sb.Append(" inv_mas.Name TestName,pm.Age,pm.Gender,lt.`LedgerTransactionNo`,IFNULL(ist.SampleTypeName, '') SampleTypeName, ");
            sb.Append("   lt.Panel_ID,plo.BarcodeNo,im.PrintName,inv_mas.ColorCode,IFNULL(lm.`Suffix`, '') Suffix    ");
            sb.Append("  FROM `f_ledgertransaction` lt      ");
            sb.Append("  INNER JOIN patient_labinvestigation_opd plo    ");
            sb.Append("  ON plo.`LedgerTransactionNo`=lt.`LedgerTransactionNo`  ");
            sb.Append(" INNER JOIN investigation_master inv_mas ON inv_mas.Investigation_Id=plo.Investigation_ID");
            sb.Append(" AND plo.test_id IN ({0})    ");
            sb.Append("  INNER JOIN f_itemmaster im ON im.type_id=plo.Investigation_id INNER JOIN f_subcategorymaster sc ON sc.subcategoryid=im.subcategoryid AND sc.categoryid='LSHHI3'    ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`  ");
            sb.Append("  LEFT JOIN   `labobservation_investigation` li ON plo.Investigation_id=li.Investigation_id ");
            sb.Append("  LEFT JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=li.`labObservation_ID` ");
            sb.Append("  LEFT JOIN `investigations_sampletype` ist ON ist.`Investigation_ID`=plo.`Investigation_ID`    and ist.IsDefault='1' ");
            sb.Append("  GROUP BY IFNULL(li.Investigation_id,''),IFNULL(lm.`Suffix`,'') ");
            sb.Append(" ) aa  ");
            sb.Append("   GROUP BY  SampleTypeName,Suffix;     ");
            DataTable dt = new DataTable();

            using (dt as IDisposable)
            {
                using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", Test_ID)), con))
                {
                    for (int i = 0; i < Test_ID.Count; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(string.Concat("@Test_IDParam", i), Test_ID[i]);
                    }
                    using (dt as IDisposable)
                    {
                        da.Fill(dt);
                        sb = new StringBuilder();
                        Test_ID.Clear();
                    }
                }
                string returnStr = string.Empty;

                foreach (DataRow dr in dt.Rows)
                    returnStr = returnStr + "" + (returnStr == "" ? "" : "^") + dr["Patient"].ToString() + "," +
                                dr["AG"].ToString() + ",a," + dr["MachineCode"].ToString() + "" + dr["Suffix"].ToString().Trim() + "," +
                                dr["PatientNo"].ToString() + "," +
                                dr["DATE"].ToString();

                return returnStr;
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
    public static string CheckBarcode(string BarcodeNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            List<string> barcode = BarcodeNo.TrimEnd(',').Split(',').ToList<string>();
            string Exists = string.Empty;
            DataTable barcodes = new DataTable();
            using (barcodes as IDisposable)
            {
                using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format("SELECT GROUP_CONCAT(DISTINCT barcodeNo)barcodeNo FROM `patient_labinvestigation_opd` WHERE barcodeNo in ({0})", string.Join(",", barcode)), con))
                {
                    for (int i = 0; i < barcode.Count; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(string.Concat("@barcodeParam", i), barcode[i]);
                    }
                    da.Fill(barcodes);
                    barcode.Clear();
                }
                if (barcodes.Rows.Count > 0)
                {
                    Exists = Util.GetString(barcodes.Rows[0]["barcodeNo"]);
                }
                return Exists;
            }
        }
        catch (Exception ex)
        {

            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string SaveRemarksStatus(string TestID, string Remarks, string LedgerTransactionNo)
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(11);
        int ReqCount = MT.GetIPCount(11);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return "Too Many Request,Try Again after some";
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int LedgerTransactionID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT LedgerTransactionID FROM f_ledgertransaction WHERE LedgerTransactionNo=@LedgerTransactionNo",
                                                                            new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo)));
            string[] arr = TestID.Split(',');
            for (int i = 0; i < arr.Length; i++)
            {


                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM patient_labinvestigation_opd_remarks WHERE `Test_ID`=@Test_ID",
                       new MySqlParameter("@Test_ID", arr[i]));
                StringBuilder sbIns = new StringBuilder();
                sbIns.Append("INSERT INTO patient_labinvestigation_opd_remarks(UserID,UserName,Test_ID,Remarks,LedgerTransactionNo,LedgerTransactionID) ");
                sbIns.Append(" VALUES(@UserID,@UserName,@Test_ID,@Remarks,@LedgerTransactionNo,@LedgerTransactionID)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbIns.ToString(),
                    new MySqlParameter("@UserID", UserInfo.ID),
                    new MySqlParameter("@UserName", Util.GetString(HttpContext.Current.Session["LoginName"])),
                    new MySqlParameter("@Test_ID", arr[i]),
                    new MySqlParameter("@Remarks", Remarks),
                    new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo), new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Remarks Status Saved" });

        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return JsonConvert.SerializeObject(new { status = true, response = "Remarks Status Not Saved" });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    static string savestatus(MySqlTransaction tnx, string barcodeno, string LedgerTransactionNo, string ID, string status)
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(12);
        int ReqCount = MT.GetIPCount(12);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return "Too Many Request,Try Again after some";
        }
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode) ",
                      new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                      new MySqlParameter("@SinNo", barcodeno), new MySqlParameter("@Test_ID", ID),
                      new MySqlParameter("@Status", status), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                      new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@DispatchCode", string.Empty));
            return "success";
        }
        catch
        {
            return "fail";
        }
    }
    static string booknewentry(MySqlTransaction tnx, string testid, string obsid)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("select ist.SampleTypeID SampleType,plo.SubCategoryID,plo.BarcodeNo");
            sb.Append("  FROM `investigations_sampletype` ist");
            sb.Append(" inner join `patient_labinvestigation_opd` plo on");
            sb.Append("  plo.`Investigation_ID`=ist.`Investigation_ID` and plo.`LedgerTransactionID`=(select LedgerTransactionID from patient_labinvestigation_opd where test_id=@test_id) and ist.`IsDefault`=1 ");
            sb.Append("   group by ist.SampleTypeID,plo.SubCategoryID,plo.BarcodeNo ");
            using (DataTable dtSample = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@test_id", testid)).Tables[0])
            {
                string Barcode = string.Empty;
                string query = @"SELECT plo.LedgerTransactionID,plo.sampletypename, plo.TestCentreID, im.ReportType, plo.Barcodeno, plo.`CentreID`,patient_id,`LedgerTransactionNO` 
,im.`Name` bookingtestname,im.`Investigation_Id` bookingtestinvid,imm.`ItemID` bookingtestitemid ,imm.`SubCategoryID`,imm.TestCode,AgeInDays,plo.Gender,DATE_FORMAT(plo.date,'%d-%b-%Y %H:%i:%s')BookingDate
FROM `patient_labinvestigation_opd` plo
inner JOIN investigation_reflecttest   ir ON plo.Investigation_ID=ir.InvestigationID  AND ir.labobservation_id=@labobservation_id INNER JOIN investigation_master im ON im.Investigation_ID=ir.`Reflecttestid` AND im.`Investigation_Id` NOT IN(SELECT investigation_id FROM patient_labinvestigation_opd WHERE `LedgerTransactionNO`=plo.`LedgerTransactionNo`) INNER JOIN f_itemmaster imm ON imm.`Type_ID`=im.Investigation_ID INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=imm.`SubCategoryID` AND sm.`CategoryID`<>'LSHHI44' WHERE test_id=@testid";
                DataSet dts = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, query,
                    new MySqlParameter("@labobservation_id", obsid), new MySqlParameter("@testid", testid));
                if (dts.Tables.Count > 0)
                {
                    DataTable dt = dts.Tables[0];
                    foreach (DataRow dw in dt.Rows)
                    {
                        string sampleType = string.Empty;
                        sampleType = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT concat(ist.`SampleTypeID`,'#',ist.SampleTypeName) FROM `investigations_sampletype` ist where `Investigation_Id`=@Investigation_Id AND ist.`IsDefault`=1 ",
                           new MySqlParameter("@Investigation_Id", dw["bookingtestinvid"].ToString())));
                        if (dtSample.Select(string.Format("SampleType='{0}' and SubCategoryID='{1}'", sampleType.Split('#')[0], dw["SubCategoryID"])).Length == 0)
                        {
                            Barcode = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_barcode(@SubCategoryID)",
                              new MySqlParameter("@SubCategoryID", dw["SubCategoryID"].ToString())).ToString();
                            DataRow dr = dtSample.NewRow();
                            dr["SampleType"] = sampleType.Split('#')[0];
                            dr["SubCategoryID"] = dw["SubCategoryID"].ToString();
                            dr["BarcodeNo"] = Barcode;
                            dtSample.Rows.Add(dr);
                            dtSample.AcceptChanges();
                        }
                        else
                            Barcode = dtSample.Select(string.Format("SampleType='{0}' and SubCategoryID='{1}'", sampleType.Split('#')[0], dw["SubCategoryID"]))[0]["BarcodeNo"].ToString();
                        Patient_Lab_InvestigationOPD objPLI = new Patient_Lab_InvestigationOPD(tnx);
                        objPLI.LedgerTransactionID = Util.GetInt(dw["LedgerTransactionID"].ToString());
                        objPLI.LedgerTransactionNo = dw["LedgerTransactionNO"].ToString();
                        objPLI.Investigation_ID = Util.GetInt(dw["bookingtestinvid"].ToString());
                        objPLI.Patient_ID = dw["patient_id"].ToString();
                        objPLI.AgeInDays = Util.GetInt(dw["AgeInDays"].ToString());
                        objPLI.Gender = dw["Gender"].ToString();
                        objPLI.ItemId = Util.GetInt(dw["bookingtestitemid"].ToString());
                        objPLI.ItemName = dw["bookingtestname"].ToString();
                        objPLI.ItemCode = dw["TestCode"].ToString();
                        objPLI.PackageName = string.Empty;
                        objPLI.PackageCode = string.Empty;
                        objPLI.IsReporting = 1;
                        objPLI.IsPackage = 0;
                        objPLI.SubCategoryID = Util.GetInt(dw["SubCategoryID"].ToString());
                        objPLI.Rate = 0;
                        objPLI.Amount = 0;
                        objPLI.DiscountAmt = 0;
                        objPLI.Quantity = 1;
                        objPLI.BarcodeNo = Barcode;
                        objPLI.CentreID = Util.GetInt(dw["CentreID"].ToString());
                        if (sampleType.Split('#')[1] == dw["sampletypename"].ToString())
                        {
                            objPLI.IsSampleCollected = "Y";
                        }
                        else
                        {
                            objPLI.IsSampleCollected = "N";
                        }
                        objPLI.SampleBySelf = 0;
                        objPLI.isUrgent = 0;
                        objPLI.DeliveryDate = DateTime.Now.AddDays(1);
                        objPLI.ipaddress = StockReports.getip();
                        objPLI.Date = Util.GetDateTime(dw["BookingDate"].ToString());
                        objPLI.BaseCurrencyRound = Util.GetByte(Resources.Resource.BaseCurrencyRound);
                        string PLOID = objPLI.Insert();
                        if (sampleType.Split('#')[1] == dw["sampletypename"].ToString())
                        {
                            sb = new StringBuilder();
                            sb.Append("update patient_labinvestigation_opd set `SampleCollector`=@SampleCollector,`SampleCollectionDate`=now(),");
                            sb.Append(" SampleCollectionBy=@SampleCollectionBy,reporttype=@reporttype,TestCentreID=@TestCentreID,`SampleReceiveDate`=now(),");
                            sb.Append(" SampleReceivedBy=@SampleReceivedBy,SampleReceiver=@SampleReceiver where Test_ID=@Test_ID");
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                               new MySqlParameter("@SampleCollector", HttpContext.Current.Session["LoginName"].ToString()),
                               new MySqlParameter("@SampleCollectionBy", HttpContext.Current.Session["ID"].ToString()),
                               new MySqlParameter("@reporttype", dw["ReportType"].ToString()), new MySqlParameter("@TestCentreID", dw["TestCentreID"].ToString()),
                               new MySqlParameter("@SampleReceivedBy", HttpContext.Current.Session["ID"].ToString()),
                               new MySqlParameter("@SampleReceiver", HttpContext.Current.Session["LoginName"].ToString()),
                               new MySqlParameter("@Test_ID", PLOID));
                        }
                    }
                }
                return "success";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "fail";
        }
    }
    [WebMethod]
    public static string saveNewtest(List<string[]> mydataadj)
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(13);
        int ReqCount = MT.GetIPCount(13);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return "Too Many Request,Try Again after some";
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string testid = string.Empty;
            string obsid = string.Empty;
            foreach (string[] ss in mydataadj)
            {
                testid = ss[0].ToString();
                obsid = ss[1].ToString();
                StringBuilder sbbarcode = new StringBuilder();
                sbbarcode.Append("select ist.SampleTypeID SampleType,plo.SubCategoryID,plo.BarcodeNo");
                sbbarcode.Append("  FROM `investigations_sampletype` ist");
                sbbarcode.Append(" inner join `patient_labinvestigation_opd` plo on");
                sbbarcode.Append("  plo.`Investigation_ID`=ist.`Investigation_ID` and plo.`LedgerTransactionID`=(select LedgerTransactionID from patient_labinvestigation_opd where test_id=@testid) and ist.`IsDefault`=1 ");
                sbbarcode.Append("   group by ist.SampleTypeID,plo.SubCategoryID,plo.BarcodeNo ");
                using (DataTable dtSample = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sbbarcode.ToString(),
                       new MySqlParameter("@testid", testid)).Tables[0])
                {
                    string Barcode = string.Empty;
                    string query = @"SELECT plo.LedgerTransactionID,plo.sampletypename, plo.TestCentreID, im.ReportType, plo.Barcodeno, plo.`CentreID`,patient_id,`LedgerTransactionNO` 
,im.`Name` bookingtestname,im.`Investigation_Id` bookingtestinvid,imm.`ItemID` bookingtestitemid ,imm.`SubCategoryID`,imm.TestCode,AgeInDays,plo.Gender,DATE_FORMAT(plo.date,'%d-%b-%Y %H:%i:%s') BookingDate
FROM `patient_labinvestigation_opd` plo
inner JOIN investigation_reflecttest   ir ON plo.Investigation_ID=ir.InvestigationID  AND ir.labobservation_id=@labobservation_id  INNER JOIN investigation_master im ON im.Investigation_ID=ir.`Reflecttestid` and  im.investigation_id=@investigation_id AND im.`Investigation_Id` NOT IN(SELECT investigation_id FROM patient_labinvestigation_opd WHERE `LedgerTransactionNO`=plo.`LedgerTransactionNo`) INNER JOIN f_itemmaster imm ON imm.`Type_ID`=im.Investigation_ID INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=imm.`SubCategoryID` AND sm.`CategoryID`<>'LSHHI44' WHERE test_id=@testid";
                    DataSet dts = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, query,
                       new MySqlParameter("@labobservation_id", obsid), new MySqlParameter("@investigation_id", ss[2].ToString()),
                       new MySqlParameter("@testid", testid));
                    if (dts.Tables.Count > 0)
                    {
                        DataTable dt = dts.Tables[0];
                        foreach (DataRow dw in dt.Rows)
                        {
                            string sampleType = string.Empty;
                            sampleType = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT concat(ist.`SampleTypeID`,'#',ist.SampleTypeName) FROM `investigations_sampletype` ist where `Investigation_Id`=@Investigation_Id AND ist.`IsDefault`=1 ",
                                new MySqlParameter("@Investigation_Id", dw["bookingtestinvid"].ToString())));
                            if (dtSample.Select(string.Format("SampleType='{0}' and SubCategoryID='{1}'", sampleType.Split('#')[0], dw["SubCategoryID"])).Length == 0)
                            {
                                Barcode = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_barcode(@SubCategoryID)",
                                    new MySqlParameter("@SubCategoryID", dw["SubCategoryID"].ToString())).ToString();
                                DataRow dr = dtSample.NewRow();
                                dr["SampleType"] = sampleType.Split('#')[0];
                                dr["SubCategoryID"] = dw["SubCategoryID"].ToString();
                                dr["BarcodeNo"] = Barcode;
                                dtSample.Rows.Add(dr);
                                dtSample.AcceptChanges();
                            }
                            else
                                Barcode = dtSample.Select(string.Format("SampleType='{0}' and SubCategoryID='{1}'", sampleType.Split('#')[0], dw["SubCategoryID"]))[0]["BarcodeNo"].ToString();
                            Patient_Lab_InvestigationOPD objPLI = new Patient_Lab_InvestigationOPD(tnx);
                            objPLI.LedgerTransactionID = Util.GetInt(dw["LedgerTransactionID"].ToString());
                            objPLI.LedgerTransactionNo = dw["LedgerTransactionNO"].ToString();
                            objPLI.Investigation_ID = Util.GetInt(dw["bookingtestinvid"].ToString());
                            objPLI.Patient_ID = dw["patient_id"].ToString();
                            objPLI.AgeInDays = Util.GetInt(dw["AgeInDays"].ToString());
                            objPLI.Gender = dw["Gender"].ToString();
                            objPLI.ItemId = Util.GetInt(dw["bookingtestitemid"].ToString());
                            objPLI.ItemName = dw["bookingtestname"].ToString();
                            objPLI.ItemCode = dw["TestCode"].ToString();

                            objPLI.PackageName = string.Empty;
                            objPLI.PackageCode = string.Empty;
                            objPLI.IsReporting = 1;
                            objPLI.IsPackage = 0;
                            objPLI.SubCategoryID = Util.GetInt(dw["SubCategoryID"].ToString());
                            objPLI.Rate = 0;
                            objPLI.Amount = 0;
                            objPLI.DiscountAmt = 0;
                            objPLI.Quantity = 1;
                            objPLI.BarcodeNo = Barcode;
                            objPLI.CentreID = Util.GetInt(dw["CentreID"].ToString());
                            if (sampleType.Split('#')[1] == dw["sampletypename"].ToString())
                            {
                                objPLI.IsSampleCollected = "Y";
                            }
                            else
                            {
                                objPLI.IsSampleCollected = "N";
                            }
                            objPLI.SampleBySelf = 0;
                            objPLI.isUrgent = 0;
                            objPLI.DeliveryDate = DateTime.Now.AddDays(1);
                            objPLI.ipaddress = StockReports.getip();
                            objPLI.Date = Util.GetDateTime(dw["BookingDate"].ToString());
                            string PLOID = objPLI.Insert();
                            if (sampleType.Split('#')[1] == dw["sampletypename"].ToString())
                            {
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labinvestigation_opd set `SampleCollector`=@SampleCollector,`SampleCollectionDate`=now(),`SampleCollectionBy`=@SampleCollectionBy,reporttype=@reporttype,TestCentreID=@TestCentreID,`SampleReceiveDate`=now(),`SampleReceivedBy`=@SampleReceivedBy,`SampleReceiver`=@SampleReceiver where Test_ID=@Test_ID",
                                 new MySqlParameter("@SampleCollector", HttpContext.Current.Session["LoginName"].ToString()),
                                 new MySqlParameter("@SampleCollectionBy", HttpContext.Current.Session["ID"].ToString()),
                                 new MySqlParameter("@reporttype", dw["ReportType"].ToString()),
                                 new MySqlParameter("@TestCentreID", dw["TestCentreID"].ToString()),
                                 new MySqlParameter("@SampleReceivedBy", HttpContext.Current.Session["ID"].ToString()),
                                 new MySqlParameter("@SampleReceiver", HttpContext.Current.Session["LoginName"].ToString()),
                                 new MySqlParameter("@Test_ID", PLOID));
                            }
                        }
                    }

                }
                tnx.Commit();
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            throw (ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        return "1";
    }

    [WebMethod]
    public static string BindTestToForward(string testid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            List<string> Test_ID = testid.TrimEnd(',').Split(',').ToList<string>();

            using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(" select im.name,plo.test_id from patient_labinvestigation_opd plo  INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID` and plo.test_id in({0}) ", string.Join(",", Test_ID)), con))
            {

                for (int i = 0; i < Test_ID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@Test_IDParam", i), Test_ID[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    Test_ID.Clear();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                }
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
    public static string BindCentreToForward()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT centreid,centre FROM centre_master WHERE centreid=@centreid   union all SELECT centreid,centre FROM centre_master WHERE type1<>'PCC' and centreid<>@centreid   ",
                 new MySqlParameter("@centreid", UserInfo.Centre)).Tables[0])
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
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
    public static string BindDoctorToForward(string centre)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Append(" SELECT DISTINCT fl.employeeid,em.`Name` FROM f_login fl ");
            sbQuery.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=fl.`EmployeeID` ");
            sbQuery.Append(" INNER JOIN f_approval_labemployee fa ON fa.`EmployeeID`=fl.`EmployeeID` ");
            sbQuery.Append("  WHERE centreid=@centre and fl.employeeid<>@employeeid");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
                   new MySqlParameter("@centre", centre), new MySqlParameter("@employeeid", UserInfo.ID)).Tables[0])
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

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
    public static string ForwardMe(string testid, string centre, string forward, int MobileApproved = 0, string MobileEMINo = "", string MobileNo = "", string MobileLatitude = "", string MobileLongitude = "")
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET isForward = @isForward, ForwardBy = @ForwardBy, ForwardByName = @ForwardByName,ForwardDate=@ForwardDate,ForwardToCentre=@ForwardToCentre,ForwardToDoctor=@ForwardToDoctor WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                new MySqlParameter("@isForward", 1), new MySqlParameter("@ForwardBy", UserInfo.ID), new MySqlParameter("@ForwardByName", UserInfo.LoginName),
                new MySqlParameter("@ForwardDate", DateTime.Now), new MySqlParameter("@ForwardToCentre", centre), new MySqlParameter("@ForwardToDoctor", forward),
                new MySqlParameter("@Test_ID", testid),
                new MySqlParameter("@isSampleCollected", 'Y'));

            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Forward (',ItemName,')'),@UserID,@UserName,@IpAddress,@CentreID, ");
            sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID =@Test_ID");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
               new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre),
                new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@Test_ID", testid));

            //*Start The below code use for store mobile transaction details 
            if (MobileApproved == 1)
            {
                StringBuilder sb1 = new StringBuilder();
                sb1.Append("INSERT INTO `patient_labinvestigation_opd_mobile_transaction`(`Test_ID`,`Status`,`UserID`,`MobileEMINo`,MobileNo,MobileLatitude,MobileLongitude)");
                sb1.Append(" VALUES(@Test_ID,@Status,@UserID,@MobileEMINo,@MobileNo,@MobileLatitude,@MobileLongitude)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString(),
                    new MySqlParameter("@Test_ID", testid),
                    new MySqlParameter("@Status", "Forward"),
                    new MySqlParameter("@UserID", UserInfo.ID),
                    new MySqlParameter("@MobileEMINo", Util.GetString(MobileEMINo)),
                    new MySqlParameter("@MobileNo", Util.GetString(MobileNo)),
                    new MySqlParameter("@MobileLatitude", Util.GetString(MobileLatitude)),
                    new MySqlParameter("@MobileLongitude", Util.GetString(MobileLongitude))
                 );
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            throw (ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string savetemplate(string temp, string tempname, string invid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            temp = temp.Replace("\'", "");
            temp = temp.Replace("–", "-");
            temp = temp.Replace("'", "");
            temp = temp.Replace("µ", "&micro;");
            temp = temp.Replace("ᴼ", "&deg;");
            temp = temp.Replace("#aaaaaa 1px dashed", "none");
            temp = temp.Replace("dashed", "none");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "insert into investigation_template (Investigation_ID,Temp_Head,Template_Desc,FavDoctorId) values(@Investigation_ID,@Temp_Head,@Template_Desc,@FavDoctorId)",
            new MySqlParameter("@Investigation_ID", invid), new MySqlParameter("@Temp_Head", tempname), new MySqlParameter("@Template_Desc", temp), new MySqlParameter("@FavDoctorId", UserInfo.ID));
            return JsonConvert.SerializeObject(new { status = true, response = "Template Saved" });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = true, response = ex.Message });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod]
    public static string getreflextestlist(string Test_ID, string LabObservation_ID, string LabNo, string Investigation_ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ifnull(GROUP_CONCAT(CONCAT(NAME,'#',investigation_id,'#',@Test_ID,'#',@LabObservation_ID)),'') testtobook FROM investigation_master im  INNER JOIN investigation_reflecttest ir ON im.investigation_id=ir.Reflecttestid AND ir.labobservation_id=@LabObservation_ID AND ir.investigationid=@Investigation_ID and investigation_id not in (select investigation_id from patient_labinvestigation_opd where LedgerTransactionNo=@LabNo)",
               new MySqlParameter("@Test_ID", Test_ID), new MySqlParameter("@LabObservation_ID", LabObservation_ID),
               new MySqlParameter("@Investigation_ID", Investigation_ID),
               new MySqlParameter("@LabNo", LabNo)));
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string OpenTestLog(string TestId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int IsExists = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM patient_labinvestigation_opd_notApprove WHERE Test_Id = @Test_Id",
                new MySqlParameter("@Test_Id", TestId)));
            if (IsExists > 0)
            {
                return JsonConvert.SerializeObject(new { status = true, response = "Success" });

            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false });
            }
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
    [WebMethod]
    public static string GetAutoCorrect()
    {


        string sql = "select Cast(CONCAT('{',GROUP_CONCAT(CONCAT('\"',Autokey,'\":\"',AutoDescription),'\"'),'}')as CHAR) result FROM autocorrect_detail WHERE isActive=1";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            //DataTable dtdetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Autokey,AutoDescription FROM autocorrect_detail WHERE isActive=1").Tables[0];
            //return Newtonsoft.Json.JsonConvert.SerializeObject(dtdetail);

            DataTable dtdetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, sql.ToString()).Tables[0];
            // return Newtonsoft.Json.JsonConvert.SerializeObject(dtdetail);
            return dtdetail.Rows[0]["result"].ToString();
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
    [WebMethod]
    public static string loadSmsdetail(string MobileNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Mobile_No,IF(Issend=0,'failed','Send')STATUS,DATE_FORMAT(EntDate,'%d-%b-%y %h:%s %p')EntDate,Sms_Type  FROM sms where Mobile_No=@Mobile_No and Sms_Type= 'TAT Delay' order by EntDate desc,Sms_Type",
                  new MySqlParameter("@Mobile_No", MobileNo)).Tables[0];
            return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string sendTATsms(string MobileNo, string LabNo,string TATDate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string SMS_text = "";

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Round(NetAmount)NetAmount,Round(Adjustment)Adjustment,Pname,LedgerTransactionId FROM f_ledgertransaction WHERE LedgerTransactionNo=@LedgerTransactionNo",
                  new MySqlParameter("@LedgerTransactionNo", LabNo)).Tables[0];
            if (dt.Rows.Count == 0)
                return JsonConvert.SerializeObject(new { status = false, response = "No Record found..!" });

            SMSDetail sd = new SMSDetail();
                SMS_text = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Template  FROM sms_configuration where ID=16"));
                SMS_text = SMS_text.Replace("{PName}", dt.Rows[0]["Pname"].ToString()).Replace("{AppointmentDate}", TATDate);
       
          
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO sms(Mobile_No,SMS_text,SMS_Type,LedgertransactionID,UserID)VALUES(@MobileNo,@SMS_text,@SMS_Type,@LedgertransactionID,@UserID)",
                                      new MySqlParameter("@MobileNo", MobileNo),
                                      new MySqlParameter("@SMS_text", SMS_text),
                                      new MySqlParameter("@SMS_Type", "TAT Delay"),
                                      new MySqlParameter("@LedgertransactionID", Util.GetInt(dt.Rows[0]["LedgerTransactionId"])),
                                      new MySqlParameter("@UserID", UserInfo.ID));
            return JsonConvert.SerializeObject(new { status = true, response = "SMS Send Successfully..!" });


        }
        catch (Exception ex)
        {
            ClassLog CL = new ClassLog();
            CL.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error in sending SMS..!" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string encryptData(string LedgerTransactionNo, string Test_ID)
    {
        return JsonConvert.SerializeObject(new { status = true, LedgerTransactionNo = Common.EncryptRijndael(LedgerTransactionNo), Test_ID = Common.EncryptRijndael(Test_ID) });
    }
}
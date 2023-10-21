using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Sales_EnrolmentMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string cmd = Util.GetString(Request.QueryString["cmd"]);
        string rtrn = "";

        if (cmd == "GetTestList")
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(GetTestList());
            Response.Clear();
            Response.ContentType = "application/json; charset=utf-8";
            Response.Write(rtrn);
            Response.End();

            return;
        }

        if (!IsPostBack)
        {
            AllLoad_Data.bindDropDown(ddlType, "", "SELECT ID,Type1 Text FROM centre_type1master Where IsActive=1 ORDER BY Type1 ");
            bindDesignation();
            bindPanelGroup();
            bindTagProcessingLab();
            getPanelRefrenceCode();
            binePrintCentre();
            AllLoad_Data.bindBank(ddlBankName);
            ddlBankName.Items.Insert(0, new ListItem(string.Empty, "0"));

            // AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            bindBusinessZone();
            if (Request.QueryString["EnrolID"] != null)
            {
                if (Request.QueryString["View"] != null)
                    lblIsView.Text = Common.Decrypt(Request.QueryString["View"]);
                else
                    lblIsView.Text = string.Empty;
                lblEnrollID.Text = Common.Decrypt(Request.QueryString["EnrolID"].ToString());
                bindEnrolment(Common.Decrypt(Request.QueryString["ApprovalID"].ToString()));
            }
            else
            {
                lblIsView.Text = string.Empty;
                lblEnrollID.Text = string.Empty;
            }

            lblCurrentDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            // GetIpAddress();
        }
        // txtMRPPercentage.Attributes.Add("readOnly", "readOnly");
    }

    [WebMethod]
    private DataTable GetTestList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.itemid value,typeName label,if(subcategoryID='15','Package','Test') type,0 Rate from f_itemmaster im ");
        sb.Append(" WHERE isActive=1 ");
        if (Request.QueryString["SearchType"] == "1")
            sb.Append(" AND typeName like '" + Request.QueryString["TestName"].ToString() + "%' ");
        else if (Request.QueryString["SearchType"] == "0")
            sb.Append(" AND im.testcode LIKE '" + Request.QueryString["TestName"].ToString() + "%' ");
        else
            sb.Append(" AND typeName like '%" + Request.QueryString["TestName"].ToString() + "%' ");

        sb.Append("  order by typeName limit 20 ");

        return StockReports.GetDataTable(sb.ToString());
    }

    private void bindEnrolment(string ApprovalPendingByID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT em.Company_Name,em.Add1,em.Phone,em.Mobile,em.Payment_Mode,em.CentreID_Print,em.EmailID,em.EmailIDReport, ");
        sb.Append(" em.ReportDispatchMode,em.MinBusinessCommitment,em.GSTTin,em.InvoiceBillingCycle,em.BankID,em.AccountNo,em.IFSCCode,PanelUserID,PanelPassword, ");
        sb.Append(" TagProcessingLabID,CreditLimit,InvoiceTo,MinBalReceive,ReferenceCodeOPD,CONCAT(ec.DesignationID,'#',dm.IsNewTestApprove,'#',dm.IsShowSpecialRate,'#',dm.IsDirectApprove)DesignationID,");
        sb.Append(" MRPPercentage,TypeID,TypeName,PanelGroupID,ec.EmployeeID,CONCAT(emm.Employee_ID,'#',emm.Reporting_Employee_ID,'#',ec.SequenceNo,'#',emm.Email)Employee_ID,CONCAT(emm.Title,' ',emm.NAME)EmpName, ");
        sb.Append(" em.BusinessZoneID,em.StateID,em.HeadQuarterID,em.CityID,em.CityZoneID,em.LocalityID,IF(em.DirectApprovalPendingBy='" + UserInfo.ID + "','1','0')IsDirectApprovalPending,AAALogo,OnLineLoginRequired, ");
        sb.Append(" em.HLMOPHikeInMRP,em.HLMIPHikeInMRP,em.HLMICUHikeInMRP,em.HLMOPClientShare,em.HLMIPClientShare,em.HLMICUClientShare,IsHLMIP,IsHLMICU,IsHLMOP, ");
        sb.Append(" em.HLMOPPaymentMode,em.HLMOPPatientPayTo,em.HLMIPPaymentMode,em.HLMIPPatientPayTo,em.HLMICUPaymentMode,em.HLMICUPatientPayTo,em.InvoiceDisplayName,em.InvoiceDisplayAddress ");
        sb.Append(" FROM sales_enrolment_master em INNER JOIN sales_employee_centre ec ON em.ID=ec.EnrollID  ");
        sb.Append(" INNER JOIN employee_master emm ON emm.Employee_ID=ec.EmployeeID  INNER JOIN f_designation_msater dm ON dm.ID=emm.DesignationID ");
        sb.Append(" WHERE em.ID='" + lblEnrollID.Text + "'  AND ec.EmployeeID='" + ApprovalPendingByID + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            lblIsDirectApprovalPending.Text = dt.Rows[0]["IsDirectApprovalPending"].ToString();
            lblFileName.Text = Request.QueryString["EnrolID"].ToString();
            lblTypeID.Text = dt.Rows[0]["TypeID"].ToString();
            lblTypeName.Text = dt.Rows[0]["TypeName"].ToString().ToUpper();

            ddlType.Attributes.Add("disabled", "disabled");
            ddlPanelGroup.SelectedIndex = ddlPanelGroup.Items.IndexOf(ddlPanelGroup.Items.FindByValue(dt.Rows[0]["PanelGroupID"].ToString()));
            ddlPanelGroup.Attributes.Add("disabled", "disabled");
            txtName.Text = dt.Rows[0]["Company_Name"].ToString();
            txtAddress.Text = dt.Rows[0]["Add1"].ToString();
            txtLandline.Text = dt.Rows[0]["Phone"].ToString();
            txtMobile.Text = dt.Rows[0]["Mobile"].ToString();

            ddlDesignation.SelectedIndex = ddlDesignation.Items.IndexOf(ddlDesignation.Items.FindByValue(dt.Rows[0]["DesignationID"].ToString()));

            ddlDesignation.Attributes.Add("disabled", "disabled");

            ddlName.Items.Add(new ListItem(dt.Rows[0]["EmpName"].ToString(), dt.Rows[0]["Employee_ID"].ToString()));
            ddlName.Attributes.Add("disabled", "disabled");

            if (lblTypeName.Text.ToUpper() != "PUP")
            {
                ddlBusinessZone.SelectedIndex = ddlBusinessZone.Items.IndexOf(ddlBusinessZone.Items.FindByValue(dt.Rows[0]["BusinessZoneID"].ToString()));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindState();", true);

                txtStateCity.Text = string.Concat(dt.Rows[0]["StateID"].ToString(), "#", dt.Rows[0]["HeadQuarterID"].ToString(), "#", dt.Rows[0]["CityID"].ToString(), "#", dt.Rows[0]["CityZoneID"].ToString(), "#", dt.Rows[0]["LocalityID"].ToString());
            }
            else
            {
                txtStateCity.Text = string.Empty;
            }

            ddlPaymentMode.SelectedIndex = ddlPaymentMode.Items.IndexOf(ddlPaymentMode.Items.FindByValue(dt.Rows[0]["Payment_Mode"].ToString()));
            ddlPrintAtCentre.SelectedIndex = ddlPrintAtCentre.Items.IndexOf(ddlPrintAtCentre.Items.FindByValue(dt.Rows[0]["CentreID_Print"].ToString()));
            txtEmailInvoice.Text = dt.Rows[0]["EmailID"].ToString();
            txtEmailReport.Text = dt.Rows[0]["EmailIDReport"].ToString();
            ddlReportDispatchMode.SelectedIndex = ddlReportDispatchMode.Items.IndexOf(ddlReportDispatchMode.Items.FindByValue(dt.Rows[0]["ReportDispatchMode"].ToString()));
            txtMinBusinessComm.Text = dt.Rows[0]["MinBusinessCommitment"].ToString();
            // txtMinBusinessComm.Attributes.Add("disabled", "disabled");
            txtGSTTIN.Text = dt.Rows[0]["GSTTin"].ToString();
            ddlInvoiceBillingCycle.SelectedIndex = ddlInvoiceBillingCycle.Items.IndexOf(ddlInvoiceBillingCycle.Items.FindByValue(dt.Rows[0]["InvoiceBillingCycle"].ToString()));
            ddlBankName.SelectedIndex = ddlBankName.Items.IndexOf(ddlBankName.Items.FindByValue(dt.Rows[0]["BankID"].ToString()));
            txtAccountNo.Text = dt.Rows[0]["AccountNo"].ToString();
            txtIFSCCode.Text = dt.Rows[0]["IFSCCode"].ToString();
            txtOnlineUserName.Text = dt.Rows[0]["PanelUserID"].ToString();
            // txtOnlineUserName.Attributes.Add("disabled", "disabled");
            txtOnlinePassword.Text = dt.Rows[0]["PanelPassword"].ToString();

            // txtOnlinePassword.Attributes.Add("disabled", "disabled");
            ddlTagProcessingLab.SelectedIndex = ddlTagProcessingLab.Items.IndexOf(ddlTagProcessingLab.Items.FindByValue(dt.Rows[0]["TagProcessingLabID"].ToString()));
            //  ddlTagProcessingLab.Attributes.Add("disabled", "disabled");
            txtCreditLimit.Text = dt.Rows[0]["CreditLimit"].ToString();
            ddlInvoiceTo.SelectedIndex = ddlInvoiceTo.Items.IndexOf(ddlInvoiceTo.Items.FindByValue(dt.Rows[0]["InvoiceTo"].ToString()));
            // ddlInvoiceTo.Attributes.Add("disabled", "disabled");
            txtMinCash.Text = dt.Rows[0]["MinBalReceive"].ToString();
            ddlReferringRate.SelectedIndex = ddlReferringRate.Items.IndexOf(ddlReferringRate.Items.FindByValue(dt.Rows[0]["ReferenceCodeOPD"].ToString()));
            // ddlReferringRate.Attributes.Add("disabled", "disabled");
            // ddlPrintAtCentre.Attributes.Add("disabled", "disabled");
            txtMRPPercentage.Text = dt.Rows[0]["MRPPercentage"].ToString();

            chkAAALogo.Checked = (Util.GetInt(dt.Rows[0]["AAALogo"].ToString()) > 0) ? true : false;
            chkOnlineLogin.Checked = (Util.GetInt(dt.Rows[0]["OnLineLoginRequired"].ToString()) > 0) ? true : false;

            if (dt.Rows[0]["TypeName"].ToString().ToUpper() == "PCC" || dt.Rows[0]["TypeName"].ToString().ToUpper() == "PUP")
                txtMRPPercentage.Attributes.Add("display", "block");
            else
                txtMRPPercentage.Attributes.Add("display", "none");

            if (lblTypeName.Text.ToUpper() == "HLM")
            {
                if (dt.Rows[0]["IsHLMOP"].ToString() == "1")
                {
                    chkHLMOP.Checked = true;
                    txtHLMOPMRP.Text = dt.Rows[0]["HLMOPHikeInMRP"].ToString();
                    txtHLMOPClientShare.Text = dt.Rows[0]["HLMOPClientShare"].ToString();
                    ddlHLMOPPaymentMode.SelectedIndex = ddlHLMOPPaymentMode.Items.IndexOf(ddlHLMOPPaymentMode.Items.FindByValue(dt.Rows[0]["HLMOPPaymentMode"].ToString()));
                    rblHLMOPPatientPayTo.SelectedIndex = rblHLMOPPatientPayTo.Items.IndexOf(rblHLMOPPatientPayTo.Items.FindByValue(dt.Rows[0]["HLMOPPatientPayTo"].ToString()));
                }
                else
                {
                    chkHLMOP.Checked = false;
                    txtHLMOPMRP.Text = string.Empty;
                    txtHLMOPClientShare.Text = string.Empty;
                }
                if (dt.Rows[0]["IsHLMIP"].ToString() == "1")
                {
                    chkHLMIP.Checked = true;
                    txtHLMIPMRP.Text = dt.Rows[0]["HLMIPHikeInMRP"].ToString();
                    txtHLMIPClientShare.Text = dt.Rows[0]["HLMIPClientShare"].ToString();
                    ddlHLMIPPaymentMode.SelectedIndex = ddlHLMIPPaymentMode.Items.IndexOf(ddlHLMIPPaymentMode.Items.FindByValue(dt.Rows[0]["HLMIPPaymentMode"].ToString()));
                    rblHLMIPPatientPayTo.SelectedIndex = rblHLMIPPatientPayTo.Items.IndexOf(rblHLMIPPatientPayTo.Items.FindByValue(dt.Rows[0]["HLMIPPatientPayTo"].ToString()));
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "getIPPaymentCon();", true);
                }
                else
                {
                    chkHLMIP.Checked = false;
                    txtHLMIPMRP.Text = string.Empty;
                    txtHLMIPClientShare.Text = string.Empty;
                }

                if (dt.Rows[0]["IsHLMICU"].ToString() == "1")
                {
                    chkHLMICU.Checked = true;
                    txtHLMICUMRP.Text = dt.Rows[0]["HLMICUHikeInMRP"].ToString();
                    txtHLMICUClientShare.Text = dt.Rows[0]["HLMICUClientShare"].ToString();
                    ddlHLMICUPaymentMode.SelectedIndex = ddlHLMICUPaymentMode.Items.IndexOf(ddlHLMICUPaymentMode.Items.FindByValue(dt.Rows[0]["HLMICUPaymentMode"].ToString()));
                    rblHLMICUPatientPayTo.SelectedIndex = rblHLMICUPatientPayTo.Items.IndexOf(rblHLMICUPatientPayTo.Items.FindByValue(dt.Rows[0]["HLMICUPatientPayTo"].ToString()));
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script1", "getICUPaymentCon();", true);
                }
                else
                {
                    chkHLMICU.Checked = false;
                    txtHLMICUMRP.Text = string.Empty;
                    txtHLMICUClientShare.Text = string.Empty;
                }
            }
            else
            {
            }
            if (lblIsView.Text != string.Empty)
            {
                ddlHLMOPPaymentMode.Attributes.Add("disabled", "disabled");
                ddlHLMIPPaymentMode.Attributes.Add("disabled", "disabled");
                ddlHLMICUPaymentMode.Attributes.Add("disabled", "disabled");
                rblHLMOPPatientPayTo.Enabled = false;
                rblHLMIPPatientPayTo.Enabled = false;
                rblHLMICUPatientPayTo.Enabled = false;
            }
            txtInvoiceDisplayName.Text = dt.Rows[0]["InvoiceDisplayName"].ToString();
            txtInvoiceDisplayAddress.Text = dt.Rows[0]["InvoiceDisplayAddress"].ToString();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key5", "getEnrolTestLimitCount();", true);
            if (lblTypeName.Text.ToUpper() != "PUP")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key50", "fillEnrolmentAddress();", true);
            }
        }
    }

    private void bindDesignation()
    {
        DataTable dt = StockReports.GetDataTable("SELECT CONCAT(`ID`,'#',IsNewTestApprove,'#',IsShowSpecialRate,'#',IsDirectApprove)ID, `Name` FROM f_designation_msater WHERE IsSales=1 ORDER BY SequenceNo+0 DESC");
        if (dt.Rows.Count > 0)
        {
            ddlDesignation.DataSource = dt;
            ddlDesignation.DataTextField = "Name";
            ddlDesignation.DataValueField = "ID";
            ddlDesignation.DataBind();
            ddlDesignation.Items.Insert(0, new ListItem("Select", "0"));

            string empDes = Util.GetString(StockReports.ExecuteScalar("SELECT CONCAT(DesignationID,'#',IsNewTestApprove,'#',IsShowSpecialRate,'#',IsDirectApprove)DesignationID FROM employee_master em INNER JOIN f_designation_msater dm ON em.DesignationID=dm.ID WHERE Employee_ID='" + UserInfo.ID + "' AND IsSalesTeamMember=1"));
            if (empDes != string.Empty)
            {
                ddlDesignation.SelectedIndex = ddlDesignation.Items.IndexOf(ddlDesignation.Items.FindByValue(empDes));
                bindEmployee(empDes.Split('#')[0]);
                ddlDesignation.Attributes.Add("disabled", "disabled");
            }
            else
            {
                lblMsg.Text = "You are not a Sales Employee";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key510", "disableSaveButton();", true);
                return;
            }
        }
    }

    private void bindEmployee(string DesignationID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(em.Employee_ID,'#',em.Reporting_Employee_ID,'#',dm.SequenceNo,'#',em.Email)Employee_ID,CONCAT(Title,' ',em.NAME)EmpName FROM employee_master em ");
        sb.Append(" INNER JOIN f_designation_msater  dm ON em.DesignationID=dm.ID AND dm.IsActive=1 AND dm.IsSales=1");
        sb.Append(" WHERE em.DesignationID='" + DesignationID + "' AND em.IsActive=1 AND em.IsSalesTeamMember=1 AND Employee_ID='" + UserInfo.ID + "'");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            ddlName.DataSource = dt;
            ddlName.DataTextField = "EmpName";
            ddlName.DataValueField = "Employee_ID";
            ddlName.DataBind();
            ddlName.Attributes.Add("disabled", "disabled");

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key55", "bindSalesHierarchy();", true);
        }
        else
        {
        }
    }

    private void bindPanelGroup()
    {
        DataTable dt = AllLoad_Data.loadPatientType();
        if (dt.Rows.Count > 0)
        {
            ddlPanelGroup.DataSource = dt;
            ddlPanelGroup.DataTextField = "PanelGroup";
            ddlPanelGroup.DataValueField = "PanelGroupID";
            ddlPanelGroup.DataBind();
        }
    }

    private void binePrintCentre()
    {
        DataTable dt = StockReports.GetDataTable("SELECT cm.CentreID,cm.Centre FROM f_panel_master fpm INNER JOIN centre_master cm ON fpm.TagProcessingLabID=cm.CentreID ");
        if (dt.Rows.Count > 0)
        {
            ddlPrintAtCentre.DataSource = dt;
            ddlPrintAtCentre.DataTextField = "Centre";
            ddlPrintAtCentre.DataValueField = "CentreID";
            ddlPrintAtCentre.DataBind();
        }
    }

    private void bindTagProcessingLab()
    {
        DataTable dt = StockReports.GetDataTable("SELECT CentreID,Centre,type1,COCO_FOCO FROM centre_master WHERE type1ID <> '7' AND IF(type1ID = '8',COCO_FOCO='COCO', type1ID != '8') AND IsActive=1 ORDER BY Centre");
        if (dt.Rows.Count > 0)
        {
            ddlTagProcessingLab.DataSource = dt;
            ddlTagProcessingLab.DataTextField = "Centre";
            ddlTagProcessingLab.DataValueField = "CentreID";
            ddlTagProcessingLab.DataBind();
        }
        ddlTagProcessingLab.Items.Insert(0, new ListItem("Select", "-1"));
        ddlTagProcessingLab.Items.Insert(1, new ListItem("Self", "0"));
    }

    private void getPanelRefrenceCode()
    {
        DataTable dt = StockReports.GetDataTable("SELECT  RTRIM(LTRIM(Company_Name)) AS Company_Name,Panel_ID,ReferenceCode,ReferenceCodeOPD FROM f_panel_master WHERE Panel_ID IN (SELECT DISTINCT(ReferenceCode) FROM f_panel_master) ORDER BY Company_Name ");
        if (dt.Rows.Count > 0)
        {
            ddlReferringRate.DataSource = dt;
            ddlReferringRate.DataTextField = "Company_Name";
            ddlReferringRate.DataValueField = "Panel_ID";
            ddlReferringRate.DataBind();

            //ddlInvoiceTo.DataSource = dt;
            //ddlInvoiceTo.DataTextField = "Company_Name";
            //ddlInvoiceTo.DataValueField = "Panel_ID";
            //ddlInvoiceTo.DataBind();
        }
        ddlReferringRate.Items.Insert(0, new ListItem("SELF", "0"));
        ddlInvoiceTo.Items.Insert(0, new ListItem("SELF", "0"));
    }

    //here creating function change1
    private static void salesenrolmentlog(MySqlConnection con, string EnrollID, string EnrollName, string Ontype)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append(" INSERT INTO sales_enrolment_log(EnrollID,EnrollName,EnteredBy,EnteredByID,EnteredByDate,OnType)");
        sb.Append(" VALUES(@EnrollID,@EnrollName,@EnteredBy,@EnteredByID,@EnteredByDate,@OnType)");
        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@EnrollID", EnrollID),
                    new MySqlParameter("@EnrollName", EnrollName),
                    new MySqlParameter("@EnteredBy", UserInfo.LoginName),
                    new MySqlParameter("@EnteredByID", UserInfo.ID),
                    new MySqlParameter("@EnteredByDate", DateTime.Now),
                    new MySqlParameter("@OnType", Ontype));

    }


    [WebMethod(EnableSession = true)]
    public static string saveEnrolment(object Panel, object Employee, object TestEnrolment, object PCCGrouping, object MarketingCampaignTest, object HLMPackage)
    {
        List<PanelMaster> Enrolment = new JavaScriptSerializer().ConvertToType<List<PanelMaster>>(Panel);
        List<EnrolmentEmployee> EmployeeEnrolment = new JavaScriptSerializer().ConvertToType<List<EnrolmentEmployee>>(Employee);
        List<SpecialTestEnrolment> SpecialTestEnrolment = new JavaScriptSerializer().ConvertToType<List<SpecialTestEnrolment>>(TestEnrolment);
        List<PCCTestGrouping> PCCTestGrouping = new JavaScriptSerializer().ConvertToType<List<PCCTestGrouping>>(PCCGrouping);
        List<MarketingTestDetail> MarketingTestDetail = new JavaScriptSerializer().ConvertToType<List<MarketingTestDetail>>(MarketingCampaignTest);

        List<HLMPackageDetail> HLMPackageDetail = new JavaScriptSerializer().ConvertToType<List<HLMPackageDetail>>(HLMPackage);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from sales_enrolment_master WHERE Company_Name=@Company_Name ",
                new MySqlParameter("@Company_Name", Enrolment[0].Company_Name)));
            if (count > 0)
            {
                return "2";
            }
            if (Enrolment[0].TypeName.ToUpper() == "PUP")
            {
                count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from sales_enrolment_master WHERE Mobile=@Mobile ",
                                new MySqlParameter("@Mobile", Enrolment[0].Mobile)));
                if (count > 0)
                {
                    return "Mobile No. Already Exits";
                }

                if (Enrolment[0].Payment_Mode == "Credit")
                {
                    count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from Sales_document WHERE EnrollID=@EnrollID AND DocumentID=6",
                               new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)));
                    if (count == 0)
                    {
                        return "Please Upload PAN Card";
                    }
                    count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from Sales_document WHERE EnrollID=@EnrollID AND DocumentID=14",
                              new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)));
                    if (count == 0)
                    {
                        return "Please Upload Cancel Cheque";
                    }
                    count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from Sales_document WHERE EnrollID=@EnrollID AND DocumentID=5",
                             new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)));
                    if (count == 0)
                    {
                        return "Please Upload Cancel MOU";
                    }
                }
                else
                {
                    count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from Sales_document WHERE EnrollID=@EnrollID AND DocumentID=5",
                             new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)));
                    if (count == 0)
                    {
                        return "Please Upload MOU";
                    }
                }
            }
            else if (Enrolment[0].TypeName.ToUpper() == "PCC")
            {
                count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from Sales_document WHERE tempID=@tempID AND DocumentID=14",
                           new MySqlParameter("@tempID", Enrolment[0].AttachedFileName)));
                if (count == 0)
                {
                    return "Please Upload Cancel Cheque";
                }
            }
            else if (Enrolment[0].TypeName.ToUpper() == "HLM")
            {
                count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from Sales_document WHERE tempID=@tempID AND DocumentID=19",
                           new MySqlParameter("@tempID", Enrolment[0].AttachedFileName)));
                if (count == 0)
                {
                    return "Please Upload 3 Month Business";
                }
                count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from Sales_document WHERE tempID=@tempID AND DocumentID=18",
                           new MySqlParameter("@tempID", Enrolment[0].AttachedFileName)));
                if (count == 0)
                {
                    return "Please Upload HLM Agreement";
                }
            }
            bool hasIsVerified = SpecialTestEnrolment.Any(cus => cus.IsVerified == 1);
            int IsVerified = 0; string VerifiedDateTime = "0001-01-01 00:00:00";
            int IsApproved = 0; string ApprovedDateTime = "0001-01-01 00:00:00";
            //if (hasIsVerified.ToString().ToUpper() == "TRUE" )
            //{
            //    IsVerified = 1; IsApproved = 1;
            //    VerifiedDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            //    ApprovedDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            //}
            if (Enrolment[0].IsApprove == 1)
            {
                IsVerified = 1;
                VerifiedDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            }
            else if (Enrolment[0].IsApprove == 2 && hasIsVerified.ToString().ToUpper() == "TRUE")
            {
                IsApproved = 1; IsVerified = 2;
                ApprovedDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                VerifiedDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO sales_enrolment_master(TypeID,TypeName,Company_Name,Add1,Mobile,Phone,Payment_Mode,CentreID_Print,EmailID,EmailIDReport,MinBusinessCommitment,GSTTin,InvoiceBillingCycle,CreatedBy,CreatedByID,");
            sb.Append(" BankID,BankName,AccountNo,IFSCCode,TagProcessingLabID,TagProcessingLab,InvoiceTo,PanelUserID,PanelPassword,ReportDispatchMode,CreditLimit,MinBalReceive,ReferenceCodeOPD,PanelGroup,PanelGroupID,MRPPercentage, ");
            sb.Append(" SalesDesignationID,SalesEmployeeID,SequenceNo,ApprovalPendingBy,IsApproved,ApprovedDate,BusinessZoneID,StateID,CityID,CityZoneID,LocalityID,HeadQuarterID,DirectApprovalPendingBy,AAALogo,OnLineLoginRequired, ");
            sb.Append(" HLMOPHikeInMRP,HLMIPHikeInMRP,HLMICUHikeInMRP,HLMOPClientShare,HLMIPClientShare,HLMICUClientShare,IsHLMOP,IsHLMIP,IsHLMICU, ");
            sb.Append("  HLMOPPaymentMode,HLMOPPatientPayTo,HLMIPPaymentMode,HLMIPPatientPayTo,HLMICUPaymentMode,HLMICUPatientPayTo,InvoiceDisplayName,InvoiceDisplayAddress  )");
            sb.Append(" VALUES(@TypeID,@TypeName,@Company_Name,@Add1,@Mobile,@Phone,@Payment_Mode,@CentreID_Print,@EmailID,@EmailIDReport,@MinBusinessCommitment,@GSTTin,@InvoiceBillingCycle,@CreatedBy,@CreatedByID,");
            sb.Append(" @BankID,@BankName,@AccountNo,@IFSCCode,@TagProcessingLabID,@TagProcessingLab,@InvoiceTo,@PanelUserID,@PanelPassword,@ReportDispatchMode,@CreditLimit,@MinBalReceive,@ReferenceCodeOPD,@PanelGroup,@PanelGroupID, ");
            sb.Append(" @MRPPercentage,@SalesDesignationID,@SalesEmployeeID,@SequenceNo,@ApprovalPendingBy,@IsApproved,@ApprovedDate,@BusinessZoneID,@StateID,@CityID,@CityZoneID,@LocalityID,@HeadQuarterID,@DirectApprovalPendingBy,@AAALogo,@OnLineLoginRequired ,");
            sb.Append(" @HLMOPHikeInMRP,@HLMIPHikeInMRP,@HLMICUHikeInMRP,@HLMOPClientShare,@HLMIPClientShare,@HLMICUClientShare,@IsHLMOP,@IsHLMIP,@IsHLMICU, ");
            sb.Append(" @HLMOPPaymentMode,@HLMOPPatientPayTo,@HLMIPPaymentMode,@HLMIPPatientPayTo,@HLMICUPaymentMode,@HLMICUPatientPayTo,@InvoiceDisplayName,@InvoiceDisplayAddress  )");
            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);

            cmd.Parameters.AddWithValue("@TypeID", Enrolment[0].TypeID);
            cmd.Parameters.AddWithValue("@TypeName", Enrolment[0].TypeName);
            cmd.Parameters.AddWithValue("@Company_Name", Enrolment[0].Company_Name.Trim().ToUpper());
            cmd.Parameters.AddWithValue("@Add1", Enrolment[0].Add1);
            cmd.Parameters.AddWithValue("@Mobile", Enrolment[0].Mobile);
            cmd.Parameters.AddWithValue("@Phone", Enrolment[0].Phone);
            cmd.Parameters.AddWithValue("@Payment_Mode", Enrolment[0].Payment_Mode);
            cmd.Parameters.AddWithValue("@CentreID_Print", Enrolment[0].PrintAtCentre);
            cmd.Parameters.AddWithValue("@EmailID", Enrolment[0].EmailID);
            cmd.Parameters.AddWithValue("@EmailIDReport", Enrolment[0].EmailIDReport);
            cmd.Parameters.AddWithValue("@MinBusinessCommitment", Enrolment[0].MinBusinessCommitment);
            cmd.Parameters.AddWithValue("@GSTTin", Enrolment[0].GSTTin);
            cmd.Parameters.AddWithValue("@InvoiceBillingCycle", Enrolment[0].InvoiceBillingCycle);
            cmd.Parameters.AddWithValue("@CreatedByID", UserInfo.ID);
            cmd.Parameters.AddWithValue("@CreatedBy", UserInfo.LoginName);
            cmd.Parameters.AddWithValue("@BankID", Enrolment[0].BankID);
            cmd.Parameters.AddWithValue("@BankName", Enrolment[0].BankName);
            cmd.Parameters.AddWithValue("@AccountNo", Enrolment[0].AccountNo);
            cmd.Parameters.AddWithValue("@IFSCCode", Enrolment[0].IFSCCode);
            cmd.Parameters.AddWithValue("@TagProcessingLabID", Enrolment[0].TagProcessingLabID);
            cmd.Parameters.AddWithValue("@TagProcessingLab", Enrolment[0].TagProcessingLab);
            cmd.Parameters.AddWithValue("@InvoiceTo", Enrolment[0].InvoiceTo);
            cmd.Parameters.AddWithValue("@PanelUserID", Enrolment[0].PanelUserID);
            cmd.Parameters.AddWithValue("@PanelPassword", Enrolment[0].PanelPassword);
            cmd.Parameters.AddWithValue("@ReportDispatchMode", Enrolment[0].ReportDispatchMode);
            cmd.Parameters.AddWithValue("@CreditLimit", Enrolment[0].CreditLimit);
            cmd.Parameters.AddWithValue("@MinBalReceive", Enrolment[0].MinBalReceive);
            cmd.Parameters.AddWithValue("@ReferenceCodeOPD", Enrolment[0].ReferenceCodeOPD);
            cmd.Parameters.AddWithValue("@PanelGroup", Enrolment[0].PanelGroup);
            cmd.Parameters.AddWithValue("@PanelGroupID", Enrolment[0].PanelGroupID);
            cmd.Parameters.AddWithValue("@MRPPercentage", Enrolment[0].SharePercentage);
            cmd.Parameters.AddWithValue("@SalesDesignationID", Enrolment[0].DesignationID);
            cmd.Parameters.AddWithValue("@SalesEmployeeID", Enrolment[0].EmployeeID);
            cmd.Parameters.AddWithValue("@SequenceNo", Enrolment[0].SequenceNo);
            if (IsVerified == 0)
            {
                cmd.Parameters.AddWithValue("@ApprovalPendingBy", EmployeeEnrolment[0].Employee_ID);
                cmd.Parameters.AddWithValue("@IsApproved", "0");
                cmd.Parameters.AddWithValue("@ApprovedDate", ApprovedDateTime);
            }
            else if (IsVerified == 1)
            {
                cmd.Parameters.AddWithValue("@ApprovalPendingBy", EmployeeEnrolment[1].Employee_ID);
                cmd.Parameters.AddWithValue("@IsApproved", "0");
                cmd.Parameters.AddWithValue("@ApprovedDate", ApprovedDateTime);
            }
            else if (IsApproved == 1)
            {
                cmd.Parameters.AddWithValue("@ApprovalPendingBy", "0");
                cmd.Parameters.AddWithValue("@IsApproved", "1");
                cmd.Parameters.AddWithValue("@ApprovedDate", DateTime.Now);
            }
            var aa = EmployeeEnrolment.Find(item => item.IsDirectApprove == 1);
            if (aa != null)
                cmd.Parameters.AddWithValue("@DirectApprovalPendingBy", aa.Employee_ID);
            else
                cmd.Parameters.AddWithValue("@DirectApprovalPendingBy", EmployeeEnrolment[0].Employee_ID);
            cmd.Parameters.AddWithValue("@BusinessZoneID", Enrolment[0].BusinessZoneID);
            cmd.Parameters.AddWithValue("@StateID", Enrolment[0].StateID);
            cmd.Parameters.AddWithValue("@CityID", Enrolment[0].CityID);
            cmd.Parameters.AddWithValue("@CityZoneID", Enrolment[0].CityZoneID);
            cmd.Parameters.AddWithValue("@LocalityID", Enrolment[0].LocalityID);
            cmd.Parameters.AddWithValue("@HeadQuarterID", Enrolment[0].HeadQuarterID);
            cmd.Parameters.AddWithValue("@AAALogo", Enrolment[0].AAALogo);
            cmd.Parameters.AddWithValue("@OnLineLoginRequired", Enrolment[0].OnLineLoginRequired);

            cmd.Parameters.AddWithValue("@HLMOPHikeInMRP", Enrolment[0].HLMOPHikeInMRP);
            cmd.Parameters.AddWithValue("@HLMIPHikeInMRP", Enrolment[0].HLMIPHikeInMRP);
            cmd.Parameters.AddWithValue("@HLMICUHikeInMRP", Enrolment[0].HLMICUHikeInMRP);
            cmd.Parameters.AddWithValue("@HLMOPClientShare", Enrolment[0].HLMOPClientShare);
            cmd.Parameters.AddWithValue("@HLMIPClientShare", Enrolment[0].HLMIPClientShare);
            cmd.Parameters.AddWithValue("@HLMICUClientShare", Enrolment[0].HLMICUClientShare);
            cmd.Parameters.AddWithValue("@IsHLMOP", Enrolment[0].IsHLMOP);
            cmd.Parameters.AddWithValue("@IsHLMIP", Enrolment[0].IsHLMIP);
            cmd.Parameters.AddWithValue("@IsHLMICU", Enrolment[0].IsHLMICU);

            cmd.Parameters.AddWithValue("@HLMOPPaymentMode", Enrolment[0].HLMOPPaymentMode);
            cmd.Parameters.AddWithValue("@HLMOPPatientPayTo", Enrolment[0].HLMOPPatientPayTo);
            cmd.Parameters.AddWithValue("@HLMIPPaymentMode", Enrolment[0].HLMIPPaymentMode);
            cmd.Parameters.AddWithValue("@HLMIPPatientPayTo", Enrolment[0].HLMIPPatientPayTo);
            cmd.Parameters.AddWithValue("@HLMICUPaymentMode", Enrolment[0].HLMICUPaymentMode);
            cmd.Parameters.AddWithValue("@HLMICUPatientPayTo", Enrolment[0].HLMICUPatientPayTo);

            cmd.Parameters.AddWithValue("@InvoiceDisplayName", Enrolment[0].InvoiceDisplayName);
            cmd.Parameters.AddWithValue("@InvoiceDisplayAddress", Enrolment[0].InvoiceDisplayAddress);
            cmd.ExecuteNonQuery();

            int EnrollID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT LAST_INSERT_ID() as AutoKey"));

            if (Enrolment[0].AttachedFileName != string.Empty)
            {
                int filecount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM Sales_document WHERE  TempID=@TempID ",
                    new MySqlParameter("@TempID", Enrolment[0].AttachedFileName)));

                if (filecount > 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE Sales_document SET EnrollID=@EnrollID WHERE TempID=@TempID",
                        new MySqlParameter("@EnrollID", EnrollID),
                        new MySqlParameter("@TempID", Enrolment[0].AttachedFileName));
                }
            }
            string SpecialTestID = string.Empty;
            for (int i = 0; i < SpecialTestEnrolment.Count; i++)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO sales_SpecialTest_Enrolment(SpecialTestID,SpecialTestRate,Rate,CreatedByID,CreatedBy,EnrollID,Priority,IsNewTest,MinimumSales,SalesDuration,IntimationDays,EntryType,HLMPrice)");
                sb.Append(" VALUES(@SpecialTestID,@SpecialTestRate,@Rate,@CreatedByID,@CreatedBy,@EnrollID,@Priority,@IsNewTest,@MinimumSales,@SalesDuration,@IntimationDays,@EntryType,@HLMPrice)");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@SpecialTestID", SpecialTestEnrolment[i].SpecialTestID),
                 new MySqlParameter("@SpecialTestRate", SpecialTestEnrolment[i].SpecialTestRate), new MySqlParameter("@Rate", SpecialTestEnrolment[i].Rate),
                 new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                 new MySqlParameter("@EnrollID", EnrollID), new MySqlParameter("@Priority", SpecialTestEnrolment[i].Priority),
                 new MySqlParameter("@IsNewTest", SpecialTestEnrolment[i].IsNewTest), new MySqlParameter("@MinimumSales", SpecialTestEnrolment[i].MinimumSales),
                 new MySqlParameter("@SalesDuration", SpecialTestEnrolment[i].SalesDuration), new MySqlParameter("@IntimationDays", SpecialTestEnrolment[i].IntimationDays),
                 new MySqlParameter("@EntryType", SpecialTestEnrolment[i].EntryType), new MySqlParameter("@HLMPrice", SpecialTestEnrolment[i].HLMPrice));

                if (SpecialTestEnrolment[0].EntryType == "PCC")
                {
                    if (SpecialTestID != string.Empty)
                        SpecialTestID = string.Concat(SpecialTestID, ",", SpecialTestEnrolment[i].SpecialTestID);
                    else
                        SpecialTestID = string.Concat(SpecialTestEnrolment[i].SpecialTestID);
                }
            }
            if (Enrolment[0].TypeName.ToUpper() == "PCC")
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO sales_SpecialTest_Enrolment(SpecialTestID,SpecialTestRate,Rate,CreatedByID,CreatedBy,EnrollID,Priority,IsNewTest, ");
                sb.Append("  MinimumSales,SalesDuration,IntimationDays,EntryType)");
                sb.Append("  SELECT  SpecialTestID,TestRate,TestRate,'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + EnrollID + "',1,0,0,0,0,'PCC' ");
                sb.Append("  FROM sales_special_testlimit_amount WHERE IsActive=1 AND EntryType='PCC' AND SalesID='" + Enrolment[0].DesignationID + "' AND SpecialTestID NOT IN (" + SpecialTestID + ") ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                if (PCCTestGrouping.Count > 0)
                {
                    string TestID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(cast(SpecialTestID as CHAR)) FROM sales_special_testlimit_amount WHERE IsActive=1 AND EntryType='PCC' AND SalesID='" + Enrolment[0].DesignationID + "' AND SpecialTestID NOT IN (" + SpecialTestID + ") "));

                    if (SpecialTestID != string.Empty && TestID != string.Empty)
                        SpecialTestID = string.Concat(TestID, ",", SpecialTestID);

                    string PCCGroupID = String.Join(" ", PCCTestGrouping.Select(a => String.Join(", ", a.GroupID)));

                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO sales_SpecialTest_Enrolment(SpecialTestID,SpecialTestRate,Rate,CreatedByID,CreatedBy,EnrollID,Priority,IsNewTest, ");
                    sb.Append("  MinimumSales,SalesDuration,IntimationDays,EntryType,IsPCCGroup,PCCGroupID)");
                    sb.Append("  SELECT  sp.ItemID,se.PCCGroupSharePer,0,'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + EnrollID + "',1,0,0,0,0,'PCC',1,sp.GroupID ");
                    sb.Append("  FROM sales_pccgrouping sp INNER JOIN sales_pccgrouping_enrolment se ON sp.GroupID=se.GroupID WHERE se.GroupID IN (" + PCCGroupID + ") AND sp.ItemID NOT IN (" + SpecialTestID + ") AND sp.IsActive=1 ");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                    for (int i = 0; i < PCCTestGrouping.Count; i++)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO sales_PCCGrouping_Enrolment(EnrollID,GroupID,PCCGroupSharePer,CreatedBy,CreatedByID)VALUES(@EnrollID,@GroupID,@PCCGroupSharePer,@CreatedBy,@CreatedByID)",
                            new MySqlParameter("@EnrollID", EnrollID), new MySqlParameter("@GroupID", PCCTestGrouping[i].GroupID), new MySqlParameter("@PCCGroupSharePer", PCCTestGrouping[i].GroupShare),
                            new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID)
                            );
                    }
                }
            }
            string SalesToEmailID = string.Empty;
            if (Enrolment[0].TypeName.ToUpper() == "PUP")
            {
                SalesToEmailID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT SalesToEmailID FROM businesszone_master WHERE BusinessZoneID=(SELECT BusinessZoneID FROM centre_master WHERE CentreID='" + Enrolment[0].TagProcessingLabID + "')"));
            }
            else
            {
                SalesToEmailID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT SalesToEmailID FROM businesszone_master WHERE BusinessZoneID='" + Enrolment[0].BusinessZoneID + "'"));
            }
            for (int i = 0; i < EmployeeEnrolment.Count; i++)
            {
                //if (i == 0)
                //{
                //    ReportEmailClass mail = new ReportEmailClass();
                //     mail.SalesEnrolmentEmail(SalesToEmailID, "Testing Enrolment", "One Enrolment Created", "", "");

                //}
                var mailStatus = "0";
                if (EmployeeEnrolment[i].EmployeeEmail != "")
                {
                    //  ReportEmailClass mail = new ReportEmailClass();
                    //  mailStatus = mail.SalesEnrolmentEmail(EmployeeEnrolment[i].EmployeeEmail, "Testing Enrolment", "One Enrolment Created", "", "");
                }
                sb = new StringBuilder();
                sb.Append(" INSERT INTO sales_Employee_centre(DesignationID,EmployeeID,CreatedByID,CreatedBy,EnrollID,SequenceNo,IsVerified,VerifiedDate,IsApproved,ApprovedDate,IsDirectApprove,mailStatus)");
                sb.Append(" VALUES(@DesignationID,@EmployeeID,@CreatedByID,@CreatedBy,@EnrollID,@SequenceNo,@IsVerified,@VerifiedDate,@IsApproved,@ApprovedDate,@IsDirectApprove,@mailStatus)");

                MySqlCommand cmd1 = new MySqlCommand(sb.ToString(), con, tnx);

                cmd1.Parameters.AddWithValue("@DesignationID", EmployeeEnrolment[i].DesignationID);
                cmd1.Parameters.AddWithValue("@EmployeeID", EmployeeEnrolment[i].Employee_ID);
                cmd1.Parameters.AddWithValue("@CreatedByID", UserInfo.ID);
                cmd1.Parameters.AddWithValue("@CreatedBy", UserInfo.LoginName);
                cmd1.Parameters.AddWithValue("@EnrollID", EnrollID);
                cmd1.Parameters.AddWithValue("@SequenceNo", EmployeeEnrolment[i].SequenceNo);
                cmd1.Parameters.AddWithValue("@IsDirectApprove", EmployeeEnrolment[i].IsDirectApprove);
                cmd1.Parameters.AddWithValue("@mailStatus", mailStatus);
                if (i == 0)
                {
                    cmd1.Parameters.AddWithValue("@IsVerified", EmployeeEnrolment[i].IsVerified);
                    if (EmployeeEnrolment[i].IsVerified == 1)
                        cmd1.Parameters.AddWithValue("@VerifiedDate", DateTime.Now);
                    else
                        cmd1.Parameters.AddWithValue("@VerifiedDate", "0001-01-01 00:00:00");
                    cmd1.Parameters.AddWithValue("@IsApproved", EmployeeEnrolment[i].IsApproved);
                    if (EmployeeEnrolment[i].IsApproved == 1)
                        cmd1.Parameters.AddWithValue("@ApprovedDate", DateTime.Now);
                    else
                        cmd1.Parameters.AddWithValue("@ApprovedDate", "0001-01-01 00:00:00");
                }
                else
                {
                    cmd1.Parameters.AddWithValue("@IsVerified", "0");
                    cmd1.Parameters.AddWithValue("@VerifiedDate", "0001-01-01 00:00:00");
                    cmd1.Parameters.AddWithValue("@IsApproved", "0");
                    cmd1.Parameters.AddWithValue("@ApprovedDate", "0001-01-01 00:00:00");
                }
                cmd1.ExecuteNonQuery();
            }
            if (Enrolment[0].TypeName.ToUpper() == "PCC")
            {
                for (int i = 0; i < MarketingTestDetail.Count; i++)
                {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO sales_MarketingTest_enrolment(EnrollID,ItemID,FromDate,ToDate,MRP,OfferMRP,PCCSharePer,CreatedBy,CreatedByID)");
                    sb.Append(" VALUES(@EnrollID,@ItemID,@FromDate,@ToDate,@MRP,@OfferMRP,@PCCSharePer,@CreatedBy,@CreatedByID)");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                               new MySqlParameter("@EnrollID", EnrollID), new MySqlParameter("@ItemID", MarketingTestDetail[i].ItemID),
                               new MySqlParameter("@FromDate", Util.GetDateTime(MarketingTestDetail[i].FromDate).ToString("yyyy-MM-dd")), new MySqlParameter("@ToDate", Util.GetDateTime(MarketingTestDetail[i].ToDate).ToString("yyyy-MM-dd")),
                               new MySqlParameter("@MRP", MarketingTestDetail[i].MRP), new MySqlParameter("@OfferMRP", MarketingTestDetail[i].OfferMRP),
                               new MySqlParameter("@PCCSharePer", MarketingTestDetail[i].PCCSharePer),
                               new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID)
                               );
                }
            }
            if (Enrolment[0].TypeName.ToUpper() == "HLM")
            {
                for (int i = 0; i < HLMPackageDetail.Count; i++)
                {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO sales_HLMPackage_enrolment(EnrollID,ItemID,PackageName,PatientRate,ShareType,NetAmount,CreatedBy,CreatedByID,TestWiseMRP)");
                    sb.Append(" VALUES(@EnrollID,@ItemID,@PackageName,@PatientRate,@ShareType,@NetAmount,@CreatedBy,@CreatedByID,@TestWiseMRP)");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                               new MySqlParameter("@EnrollID", EnrollID), new MySqlParameter("@ItemID", HLMPackageDetail[i].ItemID),
                               new MySqlParameter("@PackageName", HLMPackageDetail[i].PackageName), new MySqlParameter("@PatientRate", HLMPackageDetail[i].PatientRate),
                               new MySqlParameter("@ShareType", HLMPackageDetail[i].ShareType), new MySqlParameter("@NetAmount", HLMPackageDetail[i].NetAmount),
                               new MySqlParameter("@TestWiseMRP", HLMPackageDetail[i].TestWiseMRP),
                               new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID)
                               );
                }
            }
            sb = new StringBuilder();
            sb.Append(" SELECT ec.DesignationID,ec.EnrollID,ec.SequenceNo,em.Email,dm.Name DesignationName,em.Name EmployeeName FROM sales_Employee_centre ec ");
            sb.Append(" INNER JOIN f_designation_msater dm ON ec.DesignationID=dm.ID INNER JOIN employee_master em ON em.Employee_ID=ec.EmployeeID ");
            sb.Append(" WHERE ec.EnrollID=@EnrollID AND ec.SequenceNo!=1 ORDER BY ec.SequenceNo");
            DataTable emailData = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)).Tables[0];

            string emailreturnData = getEmailMessage(EmployeeEnrolment, Enrolment, emailData);
            for (int i = 0; i < emailData.Rows.Count; i++)
            {
                if (emailData.Rows[i]["Email"].ToString() != string.Empty)
                {
                    ReportEmailClass mail = new ReportEmailClass();
                    string returnStatus = mail.SalesEnrolmentEmail(emailData.Rows[i]["Email"].ToString(), Enrolment[0].Company_Name, emailreturnData, "", "");
                }
            }

            tnx.Commit();
            //here for save enrollment change2
            salesenrolmentlog(con, EnrollID.ToString(), Enrolment[0].Company_Name, "Creator");
            return "1";
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
    public static string checkesixts(string companyName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, string.Format("SELECT count(*) from sales_enrolment_master where Company_Name ='{0}'", companyName)));
            if (count > 0)
                return "1";
            else
            {
                int count1 = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, string.Format("SELECT count(*) from f_panel_master where company_name ='{0}'", companyName)));
                if (count1 > 0)
                    return "1";
                else
                    return "0";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public static DataTable bindReportingEmployeeID(string ReportingEmployeeID, string EnrollID, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT dm.ID DesignationID,dm.IsDirectApprove,dm.Name DesignationName, em.Employee_ID,CONCAT(em.Title,' ',em.NAME)EmpName, ");
        sb.Append(" em.Reporting_Employee_ID ReportingEmployeeID,dm.SequenceNo,'' IsVerified,  ");
        sb.Append(" '' VerifiedDate,em.Email ");
        sb.Append(" FROM employee_master em INNER JOIN f_designation_msater dm ON em.DesignationID =dm.ID AND dm.IsActive=1 AND dm.IsSales=1 ");
        sb.Append(" WHERE  em.IsActive=1 AND em.IsSalesTeamMember=1 AND em.Employee_ID=@Employee_ID ");
        sb.Append(" ORDER BY dm.sequenceno+0 ASC ");

        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
           new MySqlParameter("@EnrollID", EnrollID.Trim()), new MySqlParameter("@Employee_ID", ReportingEmployeeID)).Tables[0];
    }

    [WebMethod]
    public static string bindSalesHierarchy(string EmployeeID, string ReportingEmployeeID, int SequenceNo, string EnrollID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (EnrollID.Trim() == string.Empty)
            {
                if (EmployeeID == ReportingEmployeeID)
                {
                    return null;
                }

                DataTable dtMerge = new DataTable();
                DataTable dt = bindReportingEmployeeID(ReportingEmployeeID, EnrollID, con);
                dtMerge.Merge(dt);

                for (int i = 0; i < SequenceNo - 1; i++)
                {
                    if (dt.Rows.Count > 0)
                    {
                        if (dt.Rows[0]["ReportingEmployeeID"].ToString() != dt.Rows[0]["Employee_ID"].ToString())
                        {
                            dt = bindReportingEmployeeID(dt.Rows[0]["ReportingEmployeeID"].ToString(), EnrollID, con);
                            dtMerge.Merge(dt);
                        }
                    }
                    else
                    {
                        break;
                    }
                }
                return Util.getJson(dtMerge);
            }
            else
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT dm.ID DesignationID,dm.IsDirectApprove,dm.Name DesignationName, em.Employee_ID,CONCAT(em.Title,' ',em.NAME)EmpName, ");
                sb.Append(" em.Reporting_Employee_ID ReportingEmployeeID,dm.SequenceNo,IF(IsVerified=1,'Yes','')IsVerified,  ");
                sb.Append(" IF(IsVerified=1,DATE_FORMAT(VerifiedDate,'%d-%b-%Y'),'')VerifiedDate,IF(IsApproved=1,'Yes','')IsApproved, ");
                sb.Append(" IF(IsApproved=1,DATE_FORMAT(ApprovedDate,'%d-%b-%Y'),'')ApprovedDate,DATE_FORMAT(se.CreatedDate,'%d-%b-%Y')CreatedDate,em.Email ");
                sb.Append(" FROM employee_master em INNER JOIN f_designation_msater dm ON em.DesignationID =dm.ID AND dm.IsActive=1 AND dm.IsSales=1 ");
                sb.Append(" INNER JOIN sales_employee_centre se ON se.EmployeeID=em.Employee_ID AND se.IsActive=1  AND  se.EnrollID='" + EnrollID + "'");
                sb.Append(" WHERE  em.IsActive=1 AND em.IsSalesTeamMember=1 ");
                sb.Append(" ORDER BY dm.sequenceno+0 DESC ");

                DataTable dt = StockReports.GetDataTable(sb.ToString());

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
    public static string bindSpecialTest(string type, int designationID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.TestCode,im.TypeName TestName,im.ItemID,st.TestRate,'' Rate,'0' IsCheck FROM f_itemmaster im INNER JOIN  sales_special_testlimit_amount  st ON im.ItemID=st.SpecialTestID ");
        sb.Append(" WHERE st.IsActive=1 AND st.EntryType='" + type.ToUpper() + "' AND SalesID='" + designationID + "'");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }

    [WebMethod]
    public static string getSpecialTestLimit(int designationID, string Type)
    {
        DataTable TestLimit = StockReports.GetDataTable("SELECT TestLimit,BusinessCommitment FROM sales_special_testlimit_count WHERE SalesID='" + designationID + "' AND IsActive=1 AND EntryType='" + Type.ToUpper() + "' ORDER BY BusinessCommitment+0");
        if (TestLimit.Rows.Count > 0)
            return Util.getJson(TestLimit);
        else
            return null;
    }

    [WebMethod]
    public static string getDiscountOnMRP(int designationID, string Type)
    {
        DataTable DiscountOnMRP = StockReports.GetDataTable("SELECT DiscountOnMRP,BusinessCommitment FROM sales_discountonmrp WHERE SalesID='" + designationID + "' AND IsActive=1 AND EntryType='" + Type.ToUpper() + "' ORDER BY BusinessCommitment+0");
        if (DiscountOnMRP.Rows.Count > 0)
            return Util.getJson(DiscountOnMRP);
        else
            return null;
    }

    [WebMethod]
    public static string bindEnrollSpecialTest(string type, int designationID, int EnrolID)
    {
        StringBuilder sb = new StringBuilder();
        if (type.ToUpper() == "PUP")
        {
            sb.Append(" SELECT * FROM ( ");
            sb.Append(" SELECT im.TestCode,im.TypeName TestName,im.ItemID,IFNULL(se.SpecialTestRate,'')TestRate,st.testRate Rate, ");
            // sb.Append(" IF(IFNULL(se.ID,'')='',st.testRate,IFNULL(se.Rate,''))Rate, ");
            sb.Append(" IF((IFNULL(se.ID,'') AND se.Rate<>0)='','0','1')IsCheck,IFNULL(IsNewTest ,0)IsNewTest, 0 MinimumSales,0 SalesDuration,0 IntimationDays,0 TotalValue ");
            sb.Append(" FROM f_itemmaster im INNER JOIN  sales_special_testlimit_amount  st ON im.ItemID=st.SpecialTestID ");
            sb.Append(" LEFT JOIN sales_specialtest_enrolment se ON se.SpecialTestID=st.SpecialTestID AND se.IsActive=1 AND se.EnrollID='" + EnrolID + "' AND se.IsNewTest=0 ");
            sb.Append(" WHERE st.IsActive=1 AND st.EntryType='" + type.ToUpper() + "' AND SalesID='" + designationID + "'  ");
            sb.Append(" UNION ALL ");
            sb.Append(" SELECT im.TestCode,im.TypeName TestName,im.ItemID,se.SpecialTestRate TestRate,'' Rate,IF(IFNULL(se.ID,'')='','0','1')IsCheck,IsNewTest,IFNULL(MinimumSales,0)MinimumSales,IFNULL(SalesDuration,0)SalesDuration,IFNULL(IntimationDays,0)IntimationDays ,(IFNULL(se.SpecialTestRate,0)*IFNULL(MinimumSales,0))TotalValue   ");
            sb.Append(" FROM f_itemmaster im  ");
            sb.Append(" INNER JOIN sales_specialtest_enrolment se ON se.SpecialTestID=im.ItemID AND se.IsActive=1 AND se.IsNewTest=1 ");
            sb.Append(" AND se.EnrollID='" + EnrolID + "' ");
            sb.Append(" )t ORDER BY t.IsCheck+0 DESC ");
        }
        else
        {
            sb.Append(" SELECT im.TestCode,im.TypeName TestName,im.ItemID,se.SpecialTestRate TestRate,IFNULL(se.Rate,'')Rate,1 IsCheck,");
            sb.Append(" IsNewTest,IFNULL(MinimumSales,0)MinimumSales,IFNULL(SalesDuration,0)SalesDuration,IFNULL(IntimationDays,0)IntimationDays,");
            sb.Append(" (IFNULL(se.SpecialTestRate,0)*IFNULL(MinimumSales,0)) TotalValue,HLMPrice    ");
            sb.Append(" FROM f_itemmaster im  ");
            sb.Append(" INNER JOIN sales_specialtest_enrolment se ON se.SpecialTestID=im.ItemID WHERE se.IsActive=1 AND se.IsNewTest=1 ");
            sb.Append(" AND se.EnrollID='" + EnrolID + "' ORDER BY se.Priority+0 ");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }

    [WebMethod]
    public static string getEnrolTestLimitCount(int designationID, string BusinessCommitment, string EntryType)
    {
        string TestLimitCount = StockReports.ExecuteScalar("SELECT TestLimit FROM sales_special_testlimit_count WHERE SalesID='" + designationID + "' AND BusinessCommitment<='" + BusinessCommitment + "' AND IsActive=1 AND EntryType='" + EntryType.ToUpper() + "' ORDER BY ID DESC LIMIT 1 ");

        return TestLimitCount;
    }

    [WebMethod(EnableSession = true)]
    public static string approveEnrolment(object Panel, object Employee, object TestEnrolment, object PCCGrouping, object MarketingCampaignTest, object HLMPackage)
    {
        List<PanelMaster> Enrolment = new JavaScriptSerializer().ConvertToType<List<PanelMaster>>(Panel);
        List<EnrolmentEmployee> EmployeeEnrolment = new JavaScriptSerializer().ConvertToType<List<EnrolmentEmployee>>(Employee);
        List<SpecialTestEnrolment> SpecialTestEnrolment = new JavaScriptSerializer().ConvertToType<List<SpecialTestEnrolment>>(TestEnrolment);
        List<PCCTestGrouping> PCCTestGrouping = new JavaScriptSerializer().ConvertToType<List<PCCTestGrouping>>(PCCGrouping);
        List<MarketingTestDetail> MarketingTestDetail = new JavaScriptSerializer().ConvertToType<List<MarketingTestDetail>>(MarketingCampaignTest);
        List<HLMPackageDetail> HLMPackageDetail = new JavaScriptSerializer().ConvertToType<List<HLMPackageDetail>>(HLMPackage);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = 0;

            count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from sales_enrolment_master WHERE  IsApproved=1 AND ID=@ID",
                new MySqlParameter("@ID", Enrolment[0].EnrollID)));
            if (count > 0)
                return "3";
            count = 0;
            count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT count(*) from sales_enrolment_master WHERE Company_Name=@Company_Name AND IsApproved=1 AND ID!=@ID",
               new MySqlParameter("@Company_Name", Enrolment[0].Company_Name), new MySqlParameter("@ID", Enrolment[0].EnrollID)));

            if (count > 0)
                return "2";

            if (Enrolment[0].TypeName.ToUpper() == "PUP")
            {
                count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from sales_enrolment_master WHERE Mobile=@Mobile AND ID!=@ID ",
                                new MySqlParameter("@Mobile", Enrolment[0].Mobile), new MySqlParameter("@ID", Enrolment[0].EnrollID)));
                if (count > 0)
                {
                    return "Mobile No Already Exits";
                }
                if (Enrolment[0].Payment_Mode == "Credit")
                {
                    count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from Sales_document WHERE EnrollID=@EnrollID AND DocumentID=6",
                               new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)));
                    if (count == 0)
                    {
                        return "Please Upload PAN Card";
                    }
                    count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from Sales_document WHERE EnrollID=@EnrollID AND DocumentID=14",
                              new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)));
                    if (count == 0)
                    {
                        return "Please Upload Cancel Cheque";
                    }
                    count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from Sales_document WHERE EnrollID=@EnrollID AND DocumentID=5",
                             new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)));
                    if (count == 0)
                    {
                        return "Please Upload Cancel MOU";
                    }
                }
                else
                {
                    count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from Sales_document WHERE EnrollID=@EnrollID AND DocumentID=5",
                             new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)));
                    if (count == 0)
                    {
                        return "Please Upload MOU";
                    }
                }
            }
            if (Enrolment[0].TypeName.ToUpper() == "PCC")
            {
                count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from Sales_document WHERE EnrollID=@EnrollID AND DocumentID=14",
                           new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)));
                if (count == 0)
                {
                    return "Please Upload Cancel Cheque";
                }
            }

            // bool hasIsVerified = SpecialTestEnrolment.Any(cus => cus.IsVerified == 1);

            int IsVerified = 1; string VerifiedDateTime = "0001-01-01 00:00:00"; int DirectApprovalPendingBy = 0;
            int IsApproved = 0; string ApprovedDateTime = "0001-01-01 00:00:00"; int ApprovalPendingBy = 0;
            if (Enrolment[0].IsApprove == 1)
            {
                IsApproved = 0;
                VerifiedDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                ApprovedDateTime = "0001-01-01 00:00:00";
                if (EmployeeEnrolment[0].IsDirectApprovalPending == 1)
                    DirectApprovalPendingBy = EmployeeEnrolment[1].Employee_ID;
                else
                    ApprovalPendingBy = EmployeeEnrolment[1].Employee_ID;
            }
            else
            {
                IsApproved = 1; ApprovalPendingBy = 0;
                VerifiedDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                ApprovedDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE sales_enrolment_master SET Company_Name=@Company_Name,Add1=@Add1,Mobile=@Mobile,Phone=@Phone,Payment_Mode=@Payment_Mode,CentreID_Print=@CentreID_Print,");
            sb.Append(" EmailID=@EmailID,EmailIDReport=@EmailIDReport,MinBusinessCommitment=@MinBusinessCommitment,GSTTin=@GSTTin,InvoiceBillingCycle=@InvoiceBillingCycle,");
            sb.Append(" BankID=@BankID,BankName=@BankName,AccountNo=@AccountNo,IFSCCode=@IFSCCode,TagProcessingLabID=@TagProcessingLabID,TagProcessingLab=@TagProcessingLab,InvoiceTo=@InvoiceTo,");
            sb.Append(" PanelUserID=@PanelUserID,PanelPassword=@PanelPassword,ReportDispatchMode=@ReportDispatchMode,CreditLimit=@CreditLimit,MinBalReceive=@MinBalReceive,ReferenceCodeOPD=@ReferenceCodeOPD,");
            sb.Append(" PanelGroup=@PanelGroup,PanelGroupID=@PanelGroupID,MRPPercentage=@MRPPercentage,SalesDesignationID=@SalesDesignationID,SalesEmployeeID=@SalesEmployeeID,SequenceNo=@SequenceNo,");
            if (EmployeeEnrolment[0].IsDirectApprovalPending == 1)
                sb.Append(" DirectApprovalPendingBy=@DirectApprovalPendingBy ");
            else
                sb.Append(" ApprovalPendingBy=@ApprovalPendingBy ");

            sb.Append(" ,IsApproved=@IsApproved,ApprovedDate=@ApprovedDate,BusinessZoneID=@BusinessZoneID,StateID=@StateID,CityID=@CityID,CityZoneID=@CityZoneID,LocalityID=@LocalityID, ");
            sb.Append(" HeadQuarterID=@HeadQuarterID,AAALogo=@AAALogo,OnLineLoginRequired=@OnLineLoginRequired,HLMOPHikeInMRP=@HLMOPHikeInMRP,HLMIPHikeInMRP=@HLMIPHikeInMRP, ");
            sb.Append(" HLMICUHikeInMRP=@HLMICUHikeInMRP,HLMOPClientShare=@HLMOPClientShare,HLMIPClientShare=@HLMIPClientShare,HLMICUClientShare=@HLMICUClientShare, ");
            sb.Append(" IsHLMOP=@IsHLMOP,IsHLMIP=@IsHLMIP,IsHLMICU=@IsHLMICU,HLMOPPaymentMode=@HLMOPPaymentMode,HLMOPPatientPayTo=@HLMOPPatientPayTo, ");
            sb.Append(" HLMIPPaymentMode=@HLMIPPaymentMode,HLMIPPatientPayTo=@HLMIPPatientPayTo,HLMICUPaymentMode=@HLMICUPaymentMode,HLMICUPatientPayTo=@HLMICUPatientPayTo, ");
            sb.Append(" InvoiceDisplayName=@InvoiceDisplayName,InvoiceDisplayAddress=@InvoiceDisplayAddress");
            sb.Append(" WHERE ID=@EnrollID  ");

            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);

            cmd.Parameters.AddWithValue("@Company_Name", Enrolment[0].Company_Name.Trim().ToUpper());
            cmd.Parameters.AddWithValue("@Add1", Enrolment[0].Add1.Trim());
            cmd.Parameters.AddWithValue("@Mobile", Enrolment[0].Mobile);
            cmd.Parameters.AddWithValue("@Phone", Enrolment[0].Phone);
            cmd.Parameters.AddWithValue("@Payment_Mode", Enrolment[0].Payment_Mode);
            cmd.Parameters.AddWithValue("@CentreID_Print", Enrolment[0].PrintAtCentre);
            cmd.Parameters.AddWithValue("@EmailID", Enrolment[0].EmailID);
            cmd.Parameters.AddWithValue("@EmailIDReport", Enrolment[0].EmailIDReport);
            cmd.Parameters.AddWithValue("@MinBusinessCommitment", Enrolment[0].MinBusinessCommitment);
            cmd.Parameters.AddWithValue("@GSTTin", Enrolment[0].GSTTin);
            cmd.Parameters.AddWithValue("@InvoiceBillingCycle", Enrolment[0].InvoiceBillingCycle);
            cmd.Parameters.AddWithValue("@BankID", Enrolment[0].BankID);
            cmd.Parameters.AddWithValue("@BankName", Enrolment[0].BankName.Trim());
            cmd.Parameters.AddWithValue("@AccountNo", Enrolment[0].AccountNo);
            cmd.Parameters.AddWithValue("@IFSCCode", Enrolment[0].IFSCCode);
            cmd.Parameters.AddWithValue("@TagProcessingLabID", Enrolment[0].TagProcessingLabID);
            cmd.Parameters.AddWithValue("@TagProcessingLab", Enrolment[0].TagProcessingLab);
            cmd.Parameters.AddWithValue("@InvoiceTo", Enrolment[0].InvoiceTo);
            cmd.Parameters.AddWithValue("@PanelUserID", Enrolment[0].PanelUserID);
            cmd.Parameters.AddWithValue("@PanelPassword", Enrolment[0].PanelPassword);
            cmd.Parameters.AddWithValue("@ReportDispatchMode", Enrolment[0].ReportDispatchMode);
            cmd.Parameters.AddWithValue("@CreditLimit", Enrolment[0].CreditLimit);
            cmd.Parameters.AddWithValue("@MinBalReceive", Enrolment[0].MinBalReceive);
            cmd.Parameters.AddWithValue("@ReferenceCodeOPD", Enrolment[0].ReferenceCodeOPD);
            cmd.Parameters.AddWithValue("@PanelGroup", Enrolment[0].PanelGroup);
            cmd.Parameters.AddWithValue("@PanelGroupID", Enrolment[0].PanelGroupID);
            cmd.Parameters.AddWithValue("@MRPPercentage", Enrolment[0].SharePercentage);
            cmd.Parameters.AddWithValue("@SalesDesignationID", Enrolment[0].DesignationID);
            cmd.Parameters.AddWithValue("@SalesEmployeeID", Enrolment[0].EmployeeID);
            cmd.Parameters.AddWithValue("@SequenceNo", Enrolment[0].SequenceNo);
            if (EmployeeEnrolment[0].IsDirectApprovalPending == 1)
                cmd.Parameters.AddWithValue("@DirectApprovalPendingBy", DirectApprovalPendingBy);
            else
                cmd.Parameters.AddWithValue("@ApprovalPendingBy", ApprovalPendingBy);

            cmd.Parameters.AddWithValue("@IsApproved", IsApproved);
            cmd.Parameters.AddWithValue("@ApprovedDate", ApprovedDateTime);
            cmd.Parameters.AddWithValue("@EnrollID", Enrolment[0].EnrollID);
            cmd.Parameters.AddWithValue("@BusinessZoneID", Enrolment[0].BusinessZoneID);
            cmd.Parameters.AddWithValue("@StateID", Enrolment[0].StateID);
            cmd.Parameters.AddWithValue("@CityID", Enrolment[0].CityID);
            cmd.Parameters.AddWithValue("@CityZoneID", Enrolment[0].CityZoneID);
            cmd.Parameters.AddWithValue("@LocalityID", Enrolment[0].LocalityID);
            cmd.Parameters.AddWithValue("@HeadQuarterID", Enrolment[0].HeadQuarterID);
            cmd.Parameters.AddWithValue("@AAALogo", Enrolment[0].AAALogo);
            cmd.Parameters.AddWithValue("@OnLineLoginRequired", Enrolment[0].OnLineLoginRequired);

            cmd.Parameters.AddWithValue("@HLMOPHikeInMRP", Enrolment[0].HLMOPHikeInMRP);
            cmd.Parameters.AddWithValue("@HLMIPHikeInMRP", Enrolment[0].HLMIPHikeInMRP);
            cmd.Parameters.AddWithValue("@HLMICUHikeInMRP", Enrolment[0].HLMICUHikeInMRP);
            cmd.Parameters.AddWithValue("@HLMOPClientShare", Enrolment[0].HLMOPClientShare);
            cmd.Parameters.AddWithValue("@HLMIPClientShare", Enrolment[0].HLMIPClientShare);
            cmd.Parameters.AddWithValue("@HLMICUClientShare", Enrolment[0].HLMICUClientShare);
            cmd.Parameters.AddWithValue("@IsHLMOP", Enrolment[0].IsHLMOP);
            cmd.Parameters.AddWithValue("@IsHLMIP", Enrolment[0].IsHLMIP);
            cmd.Parameters.AddWithValue("@IsHLMICU", Enrolment[0].IsHLMICU);

            cmd.Parameters.AddWithValue("@HLMOPPaymentMode", Enrolment[0].HLMOPPaymentMode);
            cmd.Parameters.AddWithValue("@HLMOPPatientPayTo", Enrolment[0].HLMOPPatientPayTo);
            cmd.Parameters.AddWithValue("@HLMIPPaymentMode", Enrolment[0].HLMIPPaymentMode);
            cmd.Parameters.AddWithValue("@HLMIPPatientPayTo", Enrolment[0].HLMIPPatientPayTo);
            cmd.Parameters.AddWithValue("@HLMICUPaymentMode", Enrolment[0].HLMICUPaymentMode);
            cmd.Parameters.AddWithValue("@HLMICUPatientPayTo", Enrolment[0].HLMICUPatientPayTo);

            cmd.Parameters.AddWithValue("@InvoiceDisplayName", Enrolment[0].InvoiceDisplayName);
            cmd.Parameters.AddWithValue("@InvoiceDisplayAddress", Enrolment[0].InvoiceDisplayAddress);
            cmd.ExecuteNonQuery();
            cmd.Dispose();

            List<int> testEnroll = new List<int>();

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT SpecialTestID FROM sales_SpecialTest_Enrolment WHERE EnrollID=@EnrollID AND IsActive=1",
                new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)).Tables[0];

            for (int i = 0; i < SpecialTestEnrolment.Count; i++)
            {
                testEnroll.Add(SpecialTestEnrolment[i].SpecialTestID);
                sb = new StringBuilder();

                DataRow[] fountRow = dt.Select("SpecialTestID = '" + SpecialTestEnrolment[i].SpecialTestID + "'");
                if (fountRow.Length != 0)
                {
                    sb.Append(" UPDATE sales_SpecialTest_Enrolment SET SpecialTestRate=@SpecialTestRate,Rate=@Rate,");
                    sb.Append(" Priority=@Priority,MinimumSales=@MinimumSales,SalesDuration=@SalesDuration,");
                    sb.Append(" IntimationDays=@IntimationDays,UpdatedByID=@UpdatedByID,UpdatedBy=@UpdatedBy,UpdatedDate=@UpdatedDate, ");
                    sb.Append(" IsPCCGroup=@IsPCCGroup,PCCGroupID=@PCCGroupID,HLMPrice=@HLMPrice WHERE SpecialTestID=@SpecialTestID AND EnrollID=@EnrollID  ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),

                    new MySqlParameter("@SpecialTestRate", SpecialTestEnrolment[i].SpecialTestRate), new MySqlParameter("@Rate", SpecialTestEnrolment[i].Rate),
                    new MySqlParameter("@Priority", SpecialTestEnrolment[i].Priority), new MySqlParameter("@MinimumSales", SpecialTestEnrolment[i].MinimumSales),
                    new MySqlParameter("@SalesDuration", SpecialTestEnrolment[i].SalesDuration), new MySqlParameter("@IntimationDays", SpecialTestEnrolment[i].IntimationDays),
                    new MySqlParameter("@SpecialTestID", SpecialTestEnrolment[i].SpecialTestID), new MySqlParameter("@EnrollID", Enrolment[0].EnrollID),
                    new MySqlParameter("@UpdatedByID", UserInfo.ID), new MySqlParameter("@UpdatedBy", UserInfo.LoginName), new MySqlParameter("@UpdatedDate", DateTime.Now),
                    new MySqlParameter("@IsPCCGroup", "0"), new MySqlParameter("@PCCGroupID", "0"), new MySqlParameter("@HLMPrice", SpecialTestEnrolment[i].HLMPrice)
                    );
                }
                else
                {
                    sb.Append(" INSERT INTO sales_SpecialTest_Enrolment(SpecialTestID,SpecialTestRate,Rate,CreatedByID,CreatedBy,EnrollID,Priority,IsNewTest,MinimumSales,SalesDuration,IntimationDays,EntryType,HLMPrice)");
                    sb.Append(" VALUES(@SpecialTestID,@SpecialTestRate,@Rate,@CreatedByID,@CreatedBy,@EnrollID,@Priority,@IsNewTest,@MinimumSales,@SalesDuration,@IntimationDays,@EntryType,@HLMPrice)");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@SpecialTestID", SpecialTestEnrolment[i].SpecialTestID),
                     new MySqlParameter("@SpecialTestRate", SpecialTestEnrolment[i].SpecialTestRate), new MySqlParameter("@Rate", SpecialTestEnrolment[i].Rate),
                     new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                     new MySqlParameter("@EnrollID", Enrolment[0].EnrollID), new MySqlParameter("@Priority", SpecialTestEnrolment[i].Priority),
                     new MySqlParameter("@IsNewTest", SpecialTestEnrolment[i].IsNewTest), new MySqlParameter("@MinimumSales", SpecialTestEnrolment[i].MinimumSales),
                     new MySqlParameter("@SalesDuration", SpecialTestEnrolment[i].SalesDuration), new MySqlParameter("@IntimationDays", SpecialTestEnrolment[i].IntimationDays),
                     new MySqlParameter("@EntryType", SpecialTestEnrolment[i].EntryType), new MySqlParameter("@HLMPrice", SpecialTestEnrolment[i].HLMPrice)
                     );
                }
            }

            string SpecialTestID = String.Join(",", testEnroll);

            if (PCCTestGrouping.Count > 0)
            {
                DataTable PCCGroupingTest = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT GroupID,PCCGroupSharePer FROM sales_pccgrouping_enrolment WHERE EnrollID=@EnrollID AND IsActive=@IsActive",
               new MySqlParameter("@EnrollID", Enrolment[0].EnrollID), new MySqlParameter("@IsActive", "1")).Tables[0];

                string PCCGroupID = String.Join(",", PCCTestGrouping.Select(a => String.Join(", ", a.GroupID)));

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sales_PCCGrouping_Enrolment SET IsActive=0,UpdatedBy='" + UserInfo.LoginName + "',UpdatedByID='" + UserInfo.ID + "',UpdatedDate=NOW() WHERE EnrollID='" + Enrolment[0].EnrollID + "' AND GroupID NOT IN(" + PCCGroupID + ")");

                string TestID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(CAST(SpecialTestID AS CHAR)) FROM sales_special_testlimit_amount WHERE IsActive=1 AND EntryType='PCC' AND SalesID='" + Enrolment[0].DesignationID + "' AND SpecialTestID NOT IN (" + SpecialTestID + ") "));

                if (SpecialTestID != string.Empty && TestID != string.Empty)
                    SpecialTestID = string.Concat(TestID, ",", SpecialTestID);

                TestID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(CAST(SpecialTestID AS CHAR)) FROM sales_SpecialTest_Enrolment WHERE IsActive=1 AND EnrollID='" + Enrolment[0].EnrollID + "' AND PCCGroupID IN (" + PCCGroupID + ") "));
                if (SpecialTestID != string.Empty && TestID != string.Empty)
                    SpecialTestID = string.Concat(TestID, ",", SpecialTestID);

                sb = new StringBuilder();
                sb.Append(" INSERT INTO sales_SpecialTest_Enrolment(SpecialTestID,SpecialTestRate,Rate,CreatedByID,CreatedBy,EnrollID,Priority,IsNewTest, ");
                sb.Append("  MinimumSales,SalesDuration,IntimationDays,EntryType,IsPCCGroup,PCCGroupID)");
                sb.Append("  SELECT  ItemID,0,0,'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + Enrolment[0].EnrollID + "',1,0,0,0,0,'PCC',1,GroupID ");
                sb.Append("  FROM sales_pccgrouping  WHERE GroupID IN (" + PCCGroupID + ") AND ItemID NOT IN (" + SpecialTestID + ") AND IsActive=1 ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                if (PCCGroupingTest.Rows.Count > 0)
                {
                    for (int i = 0; i < PCCTestGrouping.Count; i++)
                    {
                        DataRow[] fountRow = PCCGroupingTest.Select("GroupID = '" + PCCTestGrouping[i].GroupID + "'");
                        if (fountRow.Length == 0)
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO sales_PCCGrouping_Enrolment(EnrollID,GroupID,PCCGroupSharePer,CreatedBy,CreatedByID)VALUES(@EnrollID,@GroupID,@PCCGroupSharePer,@CreatedBy,@CreatedByID)",
                            new MySqlParameter("@EnrollID", Enrolment[0].EnrollID), new MySqlParameter("@GroupID", PCCTestGrouping[i].GroupID), new MySqlParameter("@PCCGroupSharePer", PCCTestGrouping[i].GroupShare),
                            new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID)
                            );
                        }
                        else
                        {
                            DataRow[] fountRow1 = PCCGroupingTest.Select("GroupID = '" + PCCTestGrouping[i].GroupID + "' AND PCCGroupSharePer<>'" + PCCTestGrouping[i].GroupShare + "'");
                            if (fountRow1.Length != 0)
                            {
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sales_PCCGrouping_Enrolment SET PCCGroupSharePer=@PCCGroupSharePer,UpdatedBy=@UpdatedBy,UpdatedByID=@UpdatedByID,UpdatedDate=@UpdatedDate WHERE EnrollID=@EnrollID AND GroupID=@GroupID",
                               new MySqlParameter("@EnrollID", Enrolment[0].EnrollID), new MySqlParameter("@GroupID", PCCTestGrouping[i].GroupID), new MySqlParameter("@PCCGroupSharePer", PCCTestGrouping[i].GroupShare),
                               new MySqlParameter("@UpdatedBy", UserInfo.LoginName), new MySqlParameter("@UpdatedByID", UserInfo.ID), new MySqlParameter("@UpdatedDate", DateTime.Now));
                            }
                        }
                    }
                }
            }
            if (testEnroll.Count > 0)
            {
                //  string SpecialTestID = String.Join(",", testEnroll);

                sb = new StringBuilder();
                sb.Append(" UPDATE sales_SpecialTest_Enrolment SET Rate=0,  IsActive=IF(IsNewTest=1,0,1),UpdatedByID='" + UserInfo.ID + "',UpdatedBy='" + UserInfo.LoginName + "',UpdatedDate=NOW() WHERE SpecialTestID NOT IN (" + SpecialTestID + ") AND EnrollID='" + Enrolment[0].EnrollID + "' ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            }

            if (Enrolment[0].IsApprove == 1)
            {
                sb = new StringBuilder();
                sb.Append(" UPDATE sales_Employee_centre SET  IsVerified=@IsVerified,VerifiedDate=@VerifiedDate");
                sb.Append("  WHERE  EnrollID=@EnrollID AND EmployeeID=@EmployeeID ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@IsVerified", IsVerified), new MySqlParameter("@VerifiedDate", VerifiedDateTime),
                new MySqlParameter("@EnrollID", Enrolment[0].EnrollID), new MySqlParameter("@EmployeeID", Enrolment[0].EmployeeID));
            }
            else
            {
                sb = new StringBuilder();
                sb.Append(" UPDATE sales_Employee_centre SET IsApproved=@IsApproved,ApprovedDate=@ApprovedDate ");
                sb.Append("  WHERE  EnrollID=@EnrollID AND EmployeeID=@EmployeeID ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@IsApproved", IsApproved), new MySqlParameter("@ApprovedDate", DateTime.Now),
                new MySqlParameter("@EnrollID", Enrolment[0].EnrollID), new MySqlParameter("@EmployeeID", Enrolment[0].EmployeeID));
            }
            if (Enrolment[0].IsApprove == 2)
            {
                sb = new StringBuilder();
                sb.Append(" UPDATE sales_enrolment_master SET IsApproved=@IsApproved,ApprovedDate=@ApprovedDate,ApprovalPendingBy=@ApprovalPendingBy WHERE ID=@ID ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@IsApproved", "1"), new MySqlParameter("@ApprovedDate", DateTime.Now), new MySqlParameter("@ApprovalPendingBy", "0"),
                new MySqlParameter("@ID", Enrolment[0].EnrollID));
            }
            if (Enrolment[0].TypeName.ToUpper() == "PCC")
            {
                DataTable MarketingData = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT ID,ItemID,FromDate,ToDate,MRP,OfferMRP,PCCSharePer FROM sales_MarketingTest_enrolment WHERE EnrollID='" + Enrolment[0].EnrollID + "' AND IsActive=1").Tables[0];

                for (int i = 0; i < MarketingTestDetail.Count; i++)
                {
                    sb = new StringBuilder();
                    DataRow[] fountRow = MarketingData.Select("ItemID = '" + MarketingTestDetail[i].ItemID + "'");
                    if (fountRow.Length == 0)
                    {
                        sb.Append(" INSERT INTO sales_MarketingTest_enrolment(EnrollID,ItemID,FromDate,ToDate,MRP,OfferMRP,PCCSharePer,CreatedBy,CreatedByID)");
                        sb.Append(" VALUES(@EnrollID,@ItemID,@FromDate,@ToDate,@MRP,@OfferMRP,@PCCSharePer,@CreatedBy,@CreatedByID)");

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                   new MySqlParameter("@EnrollID", Enrolment[0].EnrollID), new MySqlParameter("@ItemID", MarketingTestDetail[i].ItemID),
                                   new MySqlParameter("@FromDate", Util.GetDateTime(MarketingTestDetail[i].FromDate).ToString("yyyy-MM-dd")), new MySqlParameter("@ToDate", Util.GetDateTime(MarketingTestDetail[i].ToDate).ToString("yyyy-MM-dd")),
                                   new MySqlParameter("@MRP", MarketingTestDetail[i].MRP), new MySqlParameter("@OfferMRP", MarketingTestDetail[i].OfferMRP),
                                   new MySqlParameter("@PCCSharePer", MarketingTestDetail[i].PCCSharePer),
                                   new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID)
                                   );
                    }
                    else
                    {
                        DataRow[] fountRow1 = MarketingData.Select(" MRP<>'" + MarketingTestDetail[i].MRP + "' OR OfferMRP<>'" + MarketingTestDetail[i].OfferMRP + "' OR PCCSharePer<>'" + MarketingTestDetail[i].PCCSharePer + "'");
                        if (fountRow1.Length != 0)
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sales_MarketingTest_enrolment SET FromDate=@FromDate,ToDate=@ToDate,MRP=@MRP,OfferMRP=@OfferMRP,PCCSharePer=@PCCSharePer,UpdatedBy=@UpdatedBy,UpdatedByID=@UpdatedByID,UpdatedDate=@UpdatedDate WHERE ID=@ID ",
                                  new MySqlParameter("@ID", MarketingData.Rows[i]["ID"].ToString()), new MySqlParameter("@FromDate", Util.GetDateTime(MarketingTestDetail[i].FromDate).ToString("yyyy-MM-dd")),
                                  new MySqlParameter("@ToDate", Util.GetDateTime(MarketingTestDetail[i].ToDate).ToString("yyyy-MM-dd")),
                                  new MySqlParameter("@MRP", MarketingTestDetail[i].MRP), new MySqlParameter("@OfferMRP", MarketingTestDetail[i].OfferMRP),
                                  new MySqlParameter("@PCCSharePer", MarketingTestDetail[i].PCCSharePer),
                                  new MySqlParameter("@UpdatedBy", UserInfo.LoginName), new MySqlParameter("@UpdatedByID", UserInfo.ID), new MySqlParameter("@UpdatedDate", DateTime.Now));
                        }
                    }
                }
            }
            if (Enrolment[0].TypeName.ToUpper() == "HLM")
            {
                DataTable HLMPackageData = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT ID FROM sales_HLMPackage_enrolment WHERE EnrollID='" + Enrolment[0].EnrollID + "' AND IsActive=1").Tables[0];

                for (int i = 0; i < HLMPackageDetail.Count; i++)
                {
                    sb = new StringBuilder();
                    DataRow[] fountRow = HLMPackageData.Select("ID = '" + HLMPackageDetail[i].HLMPackageID + "'");
                    if (fountRow.Length == 0)
                    {
                        sb.Append(" INSERT INTO sales_HLMPackage_enrolment(EnrollID,ItemID,PackageName,PatientRate,ShareType,NetAmount,CreatedBy,CreatedByID,TestWiseMRP)");
                        sb.Append(" VALUES(@EnrollID,@ItemID,@PackageName,@PatientRate,@ShareType,@NetAmount,@CreatedBy,@CreatedByID,@TestWiseMRP)");

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                   new MySqlParameter("@EnrollID", Enrolment[0].EnrollID), new MySqlParameter("@ItemID", HLMPackageDetail[i].ItemID),
                                   new MySqlParameter("@PackageName", HLMPackageDetail[i].PackageName),
                                   new MySqlParameter("@PatientRate", HLMPackageDetail[i].PatientRate), new MySqlParameter("@ShareType", HLMPackageDetail[i].ShareType),
                                   new MySqlParameter("@NetAmount", HLMPackageDetail[i].NetAmount), new MySqlParameter("@TestWiseMRP", HLMPackageDetail[i].TestWiseMRP),
                                   new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID)
                                   );
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sales_HLMPackage_enrolment SET ItemID=@ItemID,PackageName=@PackageName,PatientRate=@PatientRate,ShareType=@ShareType,NetAmount=@NetAmount,UpdatedBy=@UpdatedBy,UpdatedByID=@UpdatedByID,UpdatedDate=@UpdatedDate,TestWiseMRP=@TestWiseMRP WHERE ID=@ID ",
                                  new MySqlParameter("@ID", HLMPackageDetail[i].HLMPackageID), new MySqlParameter("@ItemID", HLMPackageDetail[i].ItemID),
                                  new MySqlParameter("@PackageName", HLMPackageDetail[i].PackageName), new MySqlParameter("@PatientRate", HLMPackageDetail[i].PatientRate),
                                  new MySqlParameter("@ShareType", HLMPackageDetail[i].ShareType), new MySqlParameter("@NetAmount", HLMPackageDetail[i].NetAmount),
                                 new MySqlParameter("@TestWiseMRP", HLMPackageDetail[i].TestWiseMRP),
                                  new MySqlParameter("@UpdatedBy", UserInfo.LoginName), new MySqlParameter("@UpdatedByID", UserInfo.ID), new MySqlParameter("@UpdatedDate", DateTime.Now));
                    }
                }
            }

            tnx.Commit();
            //here for approval and varified change3
            string Ontype = "";
            if (Enrolment[0].IsApprove == 1)
            {
                Ontype = "Verified";

            }
            else
            {
                Ontype = "Approved";
            }

            salesenrolmentlog(con, Enrolment[0].EnrollID.ToString(), Enrolment[0].Company_Name, Ontype);

            //here ending
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public static string getEmailMessage(List<EnrolmentEmployee> employee, List<PanelMaster> Enrolment, DataTable Email)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("<div> Hi, </div>");
        sb.Append("<br/>");

        sb.AppendFormat("   This is to inform you that {0} '" + Enrolment[0].TypeName + "' Request Details has been raised. Please find the below details, ",Resources.Resource.DiagnosticName);
        sb.Append("<br/><br/>");
        sb.Append("<table style='width:50%;border-collapse:collapse;'>");
        sb.Append("<tr>");
        sb.Append("<td colspan='2' style='border:solid black 1.0pt;background:#4086aa;padding:2.25pt 2.25pt 2.25pt 2.25pt;text-align:center'>");

        sb.Append("<b><span style='font-size:13.0pt;font-family:Verdana,sans-serif;color:white'>DIAGNOSTICS CODE CREATION DETAILS</span></b> ");
        sb.Append("</td> ");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append(" <td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Group Name ");
        sb.Append(" </td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" FOFO ");
        sb.Append(" </td> ");
        sb.Append("</tr>");

        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'>");
        sb.Append(" Center Code");
        sb.Append(" </td>  ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");

        sb.Append("</td> ");
        sb.Append("</tr> ");
        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Name ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" " + Enrolment[0].Company_Name + " ");
        sb.Append("</td> ");
        sb.Append("</tr> ");

        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Vendor Type ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Franchisee owned franchisee operated");
        sb.Append("</td> ");
        sb.Append("</tr> ");
        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" City ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" " + Enrolment[0].city + " ");
        sb.Append("     </td> ");
        sb.Append(" </tr> ");

        sb.Append(" <tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" State ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" " + Enrolment[0].state + " ");
        sb.Append("</td> ");
        sb.Append("</tr> ");
        sb.Append(" <tr>");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Registration Lab ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" " + Enrolment[0].TagProcessingLab + " ");
        sb.Append("</td> ");
        sb.Append("</tr> ");

        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Processing Lab ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" " + Enrolment[0].TagProcessingLab + " ");
        sb.Append("</td> ");
        sb.Append("</tr> ");

        foreach (DataRow row in Email.Rows)
        {
            sb.Append("<tr> ");
            sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
            sb.Append(" " + row["DesignationName"].ToString() + " ");
            sb.Append("</td> ");
            sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
            sb.Append(" " + row["EmployeeName"].ToString() + " ");
            sb.Append("</td>");
            sb.Append("</tr>");
        }

        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" FE Code ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append("  ");
        sb.Append("</td> ");
        sb.Append("</tr> ");
        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" FE Name ");
        sb.Append("</td>  ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append("  ");
        sb.Append("</td> ");
        sb.Append("</tr> ");
        sb.Append("<tr>");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Group Code ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append("  ");
        sb.Append("</td> ");
        sb.Append("</tr> ");
        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Address ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" " + Enrolment[0].Add1 + " ");
        sb.Append("</td> ");
        sb.Append("</tr> ");

        sb.Append("</tr> ");
        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Mobile Number ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" " + Enrolment[0].Mobile + " ");
        sb.Append("</td> ");
        sb.Append("</tr> ");

        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Email Address ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" " + Enrolment[0].EmailID + " ");
        sb.Append("    </td> ");
        sb.Append(" </tr>");

        sb.Append(" <tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Payment Type ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" " + Enrolment[0].Payment_Mode + " ");
        sb.Append("</td> ");
        sb.Append("</tr> ");

        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Owner Name ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" " + Enrolment[0].OwnerName + " ");
        sb.Append("</td> ");
        sb.Append("</tr> ");

        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" PAN Number ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");

        sb.Append(" " + Enrolment[0].PanNo + " ");
        sb.Append("</td> ");
        sb.Append("</tr> ");
        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Account Number ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" " + Enrolment[0].AccountNo + " ");
        sb.Append("</td> ");
        sb.Append("</tr> ");

        sb.Append(" <tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" IFSC Code ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" " + Enrolment[0].IFSCCode + " ");

        sb.Append("</td> ");
        sb.Append("</tr> ");

        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Bank Name ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" " + Enrolment[0].BankName + " ");
        sb.Append("</td> ");
        sb.Append("</tr> ");

        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Expected Business ");
        sb.Append("</td> ");

        sb.Append("<td> ");
        sb.Append(" " + Enrolment[0].MinBusinessCommitment + " ");
        sb.Append("</td> ");
        sb.Append("</tr> ");

        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Credit Limit ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");

        sb.Append(" " + Enrolment[0].CreditLimit + " ");
        sb.Append("</td> ");
        sb.Append("</tr> ");

        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" " + Enrolment[0].TypeName + " ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");

        sb.Append("</td> ");
        sb.Append("</tr> ");

        if (Enrolment[0].TypeName == "HLM")
        {
            sb.Append("<tr> ");
            sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
            sb.Append(" HLM ");
            sb.Append("</td> ");
            sb.Append(" <td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt' ");
            sb.Append(" cheq no- " + Enrolment[0].ChequeNo + " ");
            sb.Append("</td> ");
            sb.Append("</tr> ");
        }

        sb.Append("<tr> ");
        sb.Append("<td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Launch Date ");
        sb.Append("</td> ");
        sb.Append("<td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");

        sb.Append("  ");
        sb.Append("    </td> ");
        sb.Append("  </tr> ");

        sb.Append("  <tr> ");
        sb.Append("   <td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Created On ");
        sb.Append("  </td> ");
        sb.Append("  <td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");

        sb.Append("  ");
        sb.Append("  </td> ");
        sb.Append("  </tr> ");

        sb.Append(" <tr> ");
        sb.Append("     <td style='width:187.5pt;border:solid black 1.0pt;border-top:none;padding:2.25pt 2.25pt 2.25pt 2.25pt'> ");
        sb.Append(" Percentage ");
        sb.Append("    </td> ");
        sb.Append(" <td style='width:187.5pt;border-top:none;border-left:none;border-bottom:solid black 1.0pt;border-right:solid black 1.0pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>");
        sb.Append(" " + Enrolment[0].SharePercentage + " ");

        sb.Append(" </td> ");
        sb.Append(" </tr> ");
        sb.Append("     </tbody> ");
        sb.Append("     </table> ");

        return sb.ToString();
    }

    [WebMethod]
    public static string getItemMaster(string ItemID, string Type)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL(im.TestCode,'')TestCode,im.TypeName TestName,im.`ItemID`  ");
        if (Type.ToUpper() == "HLM")
            sb.Append(" ,IFNULL(st.Rate,0)TestRate ");
        sb.Append(" FROM f_itemmaster im ");
        if (Type.ToUpper() == "HLM")
            sb.Append(" LEFT JOIN f_ItemMaster_Special st ON im.ItemID=st.ItemID ");
        sb.Append(" WHERE im.isActive=1 AND im.`ItemID`='" + ItemID + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    public class EnrolmentEmployee
    {
        public int DesignationID { get; set; }
        public int Employee_ID { get; set; }
        public int SequenceNo { get; set; }
        public int IsVerified { get; set; }
        public int IsApproved { get; set; }
        public int IsDirectApprove { get; set; }
        public int IsDirectApprovalPending { get; set; }
        public string EmployeeEmail { get; set; }
    }

    public class SpecialTestEnrolment
    {
        public int SpecialTestID { get; set; }
        public decimal SpecialTestRate { get; set; }
        public decimal Rate { get; set; }
        public int Priority { get; set; }
        public int IsVerified { get; set; }
        public string IsApproved { get; set; }
        public int IsNewTest { get; set; }
        public int MinimumSales { get; set; }
        public int SalesDuration { get; set; }
        public int IntimationDays { get; set; }
        public string EntryType { get; set; }
        public string HLMPrice { get; set; }
    }

    public class PCCTestGrouping
    {
        public int GroupID { get; set; }
        public decimal GroupShare { get; set; }
    }

    public class MarketingTestDetail
    {
        private int EnrollID { get; set; }
        public int ItemID { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public decimal MRP { get; set; }
        public decimal OfferMRP { get; set; }
        public int PCCSharePer { get; set; }
    }

    public class HLMPackageDetail
    {
        public string PackageName { get; set; }
        public string ItemID { get; set; }
        public int PatientRate { get; set; }
        public string ShareType { get; set; }
        public int NetAmount { get; set; }
        public int TestWiseMRP { get; set; }
        public int HLMPackageID { get; set; }
    }

    private void bindBusinessZone()
    {
        StringBuilder sb = new StringBuilder();
        DataTable type = new DataTable();
        DataTable dt = StockReports.GetDataTable(" SELECT CAST(GROUP_CONCAT(TypeID) AS CHAR)TypeID,TagLocationID,TagLocationName,TypeName FROM sales_taglocation WHERE IsActive=1 AND  Employee_ID='" + UserInfo.ID + "' GROUP BY TagLocationID ");
        if (dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["TagLocationID"].ToString() == "1" || dt.Rows[0]["TagLocationID"].ToString() == "2")
            {
                sb = new StringBuilder();
                sb.Append(" SELECT BusinessZoneID,BusinessZoneName FROM BusinessZone_master bm WHERE IsActive=1 ");
                if (dt.Rows[0]["TagLocationID"].ToString() == "2")
                    sb.Append(" AND BusinessZoneID IN (" + dt.Rows[0]["TypeID"].ToString() + ") ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "3")//State
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(st.BusinessZoneID)BusinessZoneID,bm.BusinessZoneName FROM state_master st  ");
                sb.Append(" INNER JOIN BusinessZone_master bm ON st.BusinessZoneID=bm.BusinessZoneID");
                sb.Append(" WHERE st.IsActive=1 AND bm.IsActive=1 AND  st.ID   ");
                sb.Append(" IN  (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "4")//HQ
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(bm.BusinessZoneID)BusinessZoneID,bm.BusinessZoneName FROM headquarter_master hm ");
                sb.Append(" INNER JOIN BusinessZone_master bm ON hm.BusinessZoneID=bm.BusinessZoneID ");
                sb.Append(" WHERE hm.IsActive=1 AND bm.IsActive=1 AND  hm.ID IN ");
                sb.Append("  (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "5")//City
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(bm.BusinessZoneID)BusinessZoneID,bm.BusinessZoneName FROM city_master cm ");
                sb.Append(" INNER JOIN state_master sm ON cm.StateID=sm.ID ");
                sb.Append(" INNER JOIN BusinessZone_master bm ON sm.BusinessZoneID=bm.BusinessZoneID ");
                sb.Append(" WHERE sm.IsActive=1 AND bm.IsActive=1 AND cm.IsActive=1  ");
                sb.Append("  AND  cm.ID IN(" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "6")//City Zone
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(bm.BusinessZoneID)BusinessZoneID,bm.BusinessZoneName FROM centre_zonemaster cz");
                sb.Append(" INNER JOIN state_master sm ON sm.ID=cz.StateID ");
                sb.Append(" INNER JOIN BusinessZone_master bm ON sm.BusinessZoneID=bm.BusinessZoneID ");
                sb.Append(" WHERE cz.IsActive=1 AND sm.IsActive=1  AND bm.IsActive=1 ");
                sb.Append(" AND  cz.ZoneID IN  (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "7")//Locality
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(bm.BusinessZoneID)BusinessZoneID,bm.BusinessZoneName FROM f_locality lo ");
                sb.Append(" INNER JOIN state_master sm  ON sm.ID=lo.StateID ");
                sb.Append(" INNER JOIN BusinessZone_master bm ON sm.BusinessZoneID=bm.BusinessZoneID ");
                sb.Append(" WHERE lo.Active=1 AND sm.IsActive=1  ");
                sb.Append(" AND  lo.ID IN  (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            sb.Append(" ORDER BY bm.BusinessZoneName ");
            type = StockReports.GetDataTable(sb.ToString());

            ddlBusinessZone.DataSource = type;
            ddlBusinessZone.DataValueField = "BusinessZoneID";
            ddlBusinessZone.DataTextField = "BusinessZoneName";
            ddlBusinessZone.DataBind();
            ddlBusinessZone.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    [WebMethod]
    public static string bindState(int BusinessZoneID)
    {
        StringBuilder sb = new StringBuilder();
        DataTable type = new DataTable();
        DataTable dt = StockReports.GetDataTable(" SELECT CAST(GROUP_CONCAT(TypeID) AS CHAR)TypeID,TagLocationID,TagLocationName,TypeName FROM sales_taglocation WHERE IsActive=1 AND  Employee_ID='" + UserInfo.ID + "' GROUP BY TagLocationID ");
        if (dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["TagLocationID"].ToString() == "1" || dt.Rows[0]["TagLocationID"].ToString() == "2")
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(sm.ID)ID,sm.State FROM BusinessZone_master bm  ");
                sb.Append(" INNER JOIN state_master sm ON sm.BusinessZoneID=bm.BusinessZoneID ");
                sb.Append(" WHERE sm.IsActive=1 AND bm.IsActive=1     ");
                if (dt.Rows[0]["TagLocationID"].ToString() == "2")
                    sb.Append(" AND  bm.BusinessZoneID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "3")//State
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(sm.ID)ID,sm.State FROM state_master sm  ");
                sb.Append(" WHERE sm.IsActive=1     ");
                sb.Append(" AND  sm.ID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "4")//HQ
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(sm.ID)ID,sm.State FROM headquarter_master hm ");
                sb.Append(" INNER JOIN state_master sm ON sm.ID=hm.StateID ");
                sb.Append(" WHERE hm.IsActive=1 AND sm.IsActive=1  ");
                sb.Append(" AND  hm.ID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "5")//City
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(sm.ID)ID,sm.State FROM city_master cm ");
                sb.Append(" INNER JOIN state_master sm ON cm.StateID=sm.ID ");
                sb.Append(" WHERE sm.IsActive=1  AND cm.IsActive=1  ");
                sb.Append("  AND  cm.ID IN(" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "6")//City Zone
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(sm.ID)ID,sm.State FROM centre_zonemaster cz ");
                sb.Append(" INNER JOIN state_master sm ON sm.ID=cz.StateID ");
                sb.Append(" WHERE cz.IsActive=1 AND sm.IsActive=1  ");
                sb.Append(" AND  cz.ZoneID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "7")//Locality
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(sm.ID)ID,sm.State FROM f_locality lo ");
                sb.Append(" INNER JOIN state_master sm ON sm.ID=lo.StateID ");
                sb.Append(" WHERE lo.Active=1 AND sm.IsActive=1  ");
                sb.Append(" AND  lo.ID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            sb.Append(" AND sm.BusinessZoneID='" + BusinessZoneID + "' ORDER BY sm.State ");
            type = StockReports.GetDataTable(sb.ToString());
        }
        return Util.getJson(type);
    }

    [WebMethod]
    public static string bindHeadQuarter(int StateID)
    {
        StringBuilder sb = new StringBuilder();
        DataTable type = new DataTable();
        DataTable dt = StockReports.GetDataTable(" SELECT CAST(GROUP_CONCAT(TypeID) AS CHAR)TypeID,TagLocationID,TagLocationName,TypeName FROM sales_taglocation WHERE IsActive=1 AND  Employee_ID='" + UserInfo.ID + "' GROUP BY TagLocationID ");
        if (dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["TagLocationID"].ToString() == "1" || dt.Rows[0]["TagLocationID"].ToString() == "2")
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(hm.ID)ID,hm.HeadQuarter FROM BusinessZone_master bm  ");
                sb.Append(" INNER JOIN  state_master sm ON sm.BusinessZoneID=bm.BusinessZoneID ");
                sb.Append(" INNER JOIN  headquarter_master hm ON hm.StateID=sm.ID ");
                sb.Append(" WHERE bm.IsActive=1 AND sm.IsActive=1 AND hm.IsActive=1    ");
                if (dt.Rows[0]["TagLocationID"].ToString() == "2")
                    sb.Append(" AND  bm.BusinessZoneID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "3")//State
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(hm.ID)ID,hm.HeadQuarter FROM state_master sm  ");
                sb.Append(" INNER JOIN  headquarter_master hm ON hm.StateID=sm.ID ");
                sb.Append(" WHERE sm.IsActive=1 AND hm.IsActive=1 ");
                sb.Append("  AND  sm.ID  IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "4")//HQ
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(hm.ID)ID,hm.HeadQuarter FROM headquarter_master hm ");
                sb.Append(" WHERE hm.IsActive=1   ");
                sb.Append(" AND  hm.ID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "5")//City
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(hm.ID)ID,hm.HeadQuarter FROM city_master cm ");
                sb.Append(" INNER JOIN headquarter_master hm ON hm.ID=cm.HeadQuarterID ");
                sb.Append(" WHERE hm.IsActive=1  AND cm.IsActive=1  ");
                sb.Append("  AND  cm.ID IN(" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "6")//City Zone
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(hm.ID)ID,hm.HeadQuarter FROM centre_zonemaster cz ");
                sb.Append(" INNER JOIN city_master cm ON cm.ID=cz.CityID ");
                sb.Append(" INNER JOIN headquarter_master hm ON hm.ID=cm.HeadQuarterID ");
                sb.Append(" WHERE cz.IsActive=1  AND cm.IsActive=1  AND hm.IsActive=1   ");
                sb.Append(" AND  cz.ZoneID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "7")//Locality
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(hm.ID)ID,hm.HeadQuarter FROM f_locality lo ");
                sb.Append(" INNER JOIN city_master cm ON cm.ID=lo.CityID ");
                sb.Append(" INNER JOIN headquarter_master hm ON hm.ID=cm.HeadQuarterID ");
                sb.Append(" WHERE lo.Active=1  AND cm.IsActive=1  AND hm.IsActive=1   ");
                sb.Append(" AND  lo.ID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            sb.Append(" AND hm.StateID='" + StateID + "' ORDER BY hm.HeadQuarter ");
            type = StockReports.GetDataTable(sb.ToString());
        }
        return Util.getJson(type);
    }

    [WebMethod]
    public static string bindCityByHeadQuarter(int HeadQuarterID)
    {
        StringBuilder sb = new StringBuilder();
        DataTable type = new DataTable();
        DataTable dt = StockReports.GetDataTable(" SELECT CAST(GROUP_CONCAT(TypeID) AS CHAR)TypeID,TagLocationID,TagLocationName,TypeName FROM sales_taglocation WHERE IsActive=1 AND  Employee_ID='" + UserInfo.ID + "' GROUP BY TagLocationID ");
        if (dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["TagLocationID"].ToString() == "1" || dt.Rows[0]["TagLocationID"].ToString() == "2")
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(cm.ID)ID,cm.City FROM BusinessZone_master bm  ");
                sb.Append(" INNER JOIN  state_master sm ON sm.BusinessZoneID=bm.BusinessZoneID ");
                sb.Append(" INNER JOIN  city_master cm ON cm.StateID=sm.ID ");
                sb.Append(" WHERE bm.IsActive=1 AND sm.IsActive=1  AND cm.IsActive=1  ");
                if (dt.Rows[0]["TagLocationID"].ToString() == "2")
                    sb.Append(" AND  bm.BusinessZoneID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "3")//State
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(cm.ID)ID,cm.City FROM state_master sm  INNER JOIN headquarter_master hm ON hm.StateID=sm.id ");
                sb.Append(" INNER JOIN  city_master cm ON cm.HeadquarterID=hm.ID ");
                sb.Append(" WHERE sm.IsActive=1 AND cm.IsActive=1  AND hm.IsActive=1 ");
                sb.Append(" AND sm.ID  IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "4")//HQ
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(cm.ID)ID,cm.City FROM headquarter_master hm ");
                sb.Append("  INNER JOIN city_master cm ON cm.HeadQuarterID=hm.ID  ");
                sb.Append(" WHERE hm.IsActive=1 AND cm.IsActive=1  ");
                sb.Append(" AND  hm.ID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "5")//City
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(cm.ID)ID,cm.City FROM city_master cm ");
                sb.Append(" WHERE  cm.IsActive=1  ");
                sb.Append("  AND  cm.ID IN(" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "6")//City Zone
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(cm.ID)ID,cm.City FROM centre_zonemaster cz ");
                sb.Append(" INNER JOIN city_master cm ON cm.ID=cz.CityID ");
                sb.Append(" WHERE cz.IsActive=1 AND cm.IsActive=1   ");
                sb.Append(" AND cz.ZoneID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "7")//Locality
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(cm.ID)ID,cm.City FROM f_locality lo ");
                sb.Append(" INNER JOIN city_master cm ON cm.ID=lo.CityID ");
                sb.Append(" WHERE lo.Active=1 AND cm.IsActive=1   ");
                sb.Append(" AND lo.ID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            sb.Append(" AND cm.HeadQuarterID='" + HeadQuarterID + "'  ORDER BY cm.City ");
            type = StockReports.GetDataTable(sb.ToString());
        }
        return Util.getJson(type);
    }

    [WebMethod]
    public static string bindZone(int CityID)
    {
        StringBuilder sb = new StringBuilder();
        DataTable type = new DataTable();
        DataTable dt = StockReports.GetDataTable(" SELECT CAST(GROUP_CONCAT(TypeID) AS CHAR)TypeID,TagLocationID,TagLocationName,TypeName FROM sales_taglocation WHERE IsActive=1 AND  Employee_ID='" + UserInfo.ID + "' GROUP BY TagLocationID ");
        if (dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["TagLocationID"].ToString() == "1" || dt.Rows[0]["TagLocationID"].ToString() == "2")
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(cz.ZoneID)ZoneID,cz.Zone FROM BusinessZone_master bm  ");
                sb.Append(" INNER JOIN  state_master sm ON sm.BusinessZoneID=bm.BusinessZoneID ");
                sb.Append(" INNER JOIN  centre_zonemaster cz ON cz.StateID=sm.ID ");
                sb.Append(" WHERE sm.IsActive=1 AND cz.IsActive=1   AND bm.IsActive=1 ");
                if (dt.Rows[0]["TagLocationID"].ToString() == "2")
                    sb.Append(" AND bm.BusinessZoneID  IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "3")//State
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(cz.ZoneID)ZoneID,cz.Zone FROM state_master sm  ");

                sb.Append(" INNER JOIN  centre_zonemaster cz ON cz.StateID=sm.ID ");
                sb.Append(" WHERE sm.IsActive=1 AND cz.IsActive=1   ");
                sb.Append(" AND sm.ID  IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "4")//HQ
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(cz.ZoneID)ZoneID,cz.Zone FROM headquarter_master hm ");
                sb.Append("  INNER JOIN city_master cm ON cm.HeadQuarterID=hm.ID  ");
                sb.Append("  INNER JOIN centre_zonemaster cz ON cz.CityID=cm.ID  ");
                sb.Append(" WHERE hm.IsActive=1 AND cm.IsActive=1  AND cz.IsActive=1 ");
                sb.Append(" AND  hm.ID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "5")//City
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(cz.ZoneID)ZoneID,cz.Zone FROM city_master cm ");
                sb.Append(" INNER JOIN centre_zonemaster cz ON cz.CityID=cm.ID ");
                sb.Append(" WHERE  cm.IsActive=1 AND cz.IsActive=1 ");
                sb.Append("  AND  cm.ID IN(" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "6")//City Zone
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(cz.ZoneID)ZoneID,cz.Zone FROM centre_zonemaster cz ");
                sb.Append(" INNER JOIN city_master cm ON cm.ID=cz.CityID ");
                sb.Append(" WHERE cz.IsActive=1 AND cm.IsActive=1   ");
                sb.Append(" AND cz.ZoneID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "7")//Locality
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(cz.ZoneID)ZoneID,cz.Zone FROM f_locality lo ");
                sb.Append(" INNER JOIN centre_zonemaster cz ON cz.ZoneID=cz.ID ");
                sb.Append(" WHERE lo.Active=1 AND cz.IsActive=1   ");
                sb.Append(" AND lo.ID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            sb.Append(" AND cz.CityID='" + CityID + "' ORDER BY cz.Zone ");
            type = StockReports.GetDataTable(sb.ToString());
        }
        return Util.getJson(type);
    }

    [WebMethod]
    public static string bindLocalityByZone(int ZoneID)
    {
        StringBuilder sb = new StringBuilder();
        DataTable type = new DataTable();
        DataTable dt = StockReports.GetDataTable(" SELECT CAST(GROUP_CONCAT(TypeID) AS CHAR)TypeID,TagLocationID,TagLocationName,TypeName FROM sales_taglocation WHERE IsActive=1 AND  Employee_ID='" + UserInfo.ID + "' GROUP BY TagLocationID ");
        if (dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["TagLocationID"].ToString() == "1" || dt.Rows[0]["TagLocationID"].ToString() == "2")
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(lo.ID)ID,lo.NAME FROM BusinessZone_master bm  ");
                sb.Append(" INNER JOIN  state_master sm ON sm.BusinessZoneID=bm.BusinessZoneID ");
                sb.Append(" INNER JOIN f_locality lo ON lo.StateID=sm.ID  ");
                sb.Append(" WHERE sm.IsActive=1  AND lo.Active=1 ");
                if (dt.Rows[0]["TagLocationID"].ToString() == "2")
                    sb.Append(" AND bm.BusinessZoneID  IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "3")//State
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(lo.ID)ID,lo.NAME FROM state_master sm  ");
                sb.Append(" INNER JOIN  city_master cm ON cm.StateID=sm.ID ");
                sb.Append(" INNER JOIN f_locality lo ON lo.CityID=cm.ID  ");
                sb.Append(" WHERE sm.IsActive=1 AND cm.IsActive=1  AND lo.Active=1 ");
                sb.Append(" AND sm.ID  IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "4")//HQ
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(lo.ID)ID,lo.NAME FROM headquarter_master hm ");
                sb.Append("  INNER JOIN city_master cm ON cm.HeadQuarterID=hm.ID  ");
                sb.Append("  INNER JOIN f_locality lo ON lo.CityID=cm.ID  ");
                sb.Append(" WHERE hm.IsActive=1 AND cm.IsActive=1 AND lo.Active=1 ");
                sb.Append(" AND  hm.ID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "5")//City
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(lo.ID)ID,lo.NAME FROM city_master cm ");
                sb.Append("  INNER JOIN f_locality lo ON lo.CityID=cm.ID  ");
                sb.Append(" WHERE  cm.IsActive=1 AND lo.Active=1 ");
                sb.Append("  AND  cm.ID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "6")//City Zone
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(lo.ID)ID,lo.NAME FROM f_locality lo ");
                sb.Append("  INNER JOIN centre_zonemaster cz ON lo.ZoneID=cz.ZoneID  ");
                sb.Append(" WHERE lo.Active=1 AND cz.IsActive=1 ");
                sb.Append(" AND cz.ZoneID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            else if (dt.Rows[0]["TagLocationID"].ToString() == "7")//Locality
            {
                sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT(lo.ID)ID,lo.NAME FROM f_locality lo ");
                sb.Append(" WHERE lo.Active=1  ");
                sb.Append(" AND lo.ID IN (" + dt.Rows[0]["TypeID"].ToString() + ")  ");
            }
            sb.Append(" AND lo.ZoneID='" + ZoneID + "' ORDER BY lo.NAME ");
            type = StockReports.GetDataTable(sb.ToString());
        }
        return Util.getJson(type);
    }

    [WebMethod]
    public static string bindPCCGrouping()
    {
        return Util.getJson(StockReports.GetDataTable("SELECT GroupID,GroupName,0 IsCheck,'' PCCGroupSharePer FROM sales_pccgrouping_master   WHERE IsActive=1 "));
    }

    [WebMethod]
    public static string bindPCCGroupingTest(int GroupID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select gp.GroupID,gp.ItemID,im.TypeName ItemName,IFNULL( im.testcode,'')TestCode FROM  sales_pccGrouping gp   ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=gp.ItemID ");
        sb.Append(" WHERE  gp.IsActive=1 AND gp.groupID=@GroupID");

        DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, sb.ToString(),
            new MySqlParameter("@GroupID", GroupID)).Tables[0];

        return Util.getJson(dt);
    }

    [WebMethod]
    public static string bindEnrollPCCGrouping(int EnrollID)
    {
        return Util.getJson(StockReports.GetDataTable("SELECT gm.GroupID,gm.GroupName,if(IFNULL(ge.GroupID,'')='',0,1)IsCheck,IFNULL(PCCGroupSharePer,'')PCCGroupSharePer FROM sales_pccgrouping_master gm LEFT JOIN sales_pccgrouping_enrolment ge ON gm.groupID=ge.GroupID AND EnrollID='" + EnrollID + "' AND ge.IsActive=1 WHERE gm.IsActive=1 "));
    }

    [WebMethod]
    public static string getMarketItemMaster(string ItemID, string TagProcessingID)
    {
        int RefrenceCodeOPD = Util.GetInt(StockReports.ExecuteScalar("SELECT ReferenceCodeOPD FROM f_Panel_master WHERE PanelType='Centre' AND CentreID='" + TagProcessingID + "' "));
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL( im.TestCode,'')TestCode,im.TypeName TestName,im.`ItemID`,IFNULL(rt.Rate,0)MRP FROM f_itemmaster im  ");
        sb.Append(" LEFT JOIN f_rateList rt ON rt.ItemID=im.ItemID AND Panel_ID='" + RefrenceCodeOPD + "' AND IsCurrent=1 ");
        sb.Append(" ");
        sb.Append("  WHERE im.isActive=1 AND im.`ItemID`='" + ItemID + "'  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static int CompareFromToDate(DateTime FromDate, DateTime ToDate)
    {
        if (Convert.ToDateTime(FromDate) > Convert.ToDateTime(ToDate))
            return 0;
        else
            return 1;
    }

    [WebMethod]
    public static string bindMarketingTest(int EnrollID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.TestCode,im.TypeName TestName,im.ItemID,DATE_FORMAT(st.FromDate,'%d-%b-%Y')FromDate,DATE_FORMAT(st.ToDate,'%d-%b-%Y')ToDate,st.MRP,st.OfferMRP,st.PCCSharePer FROM f_itemmaster im ");
        sb.Append(" INNER JOIN  sales_MarketingTest_enrolment  st ON im.ItemID=st.ItemID ");
        sb.Append(" WHERE st.IsActive=1 AND st.EnrollID='" + EnrollID + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }

    [WebMethod]
    public static string getHLMPackage(string ItemID, string TagProcessingID)
    {
        int RefrenceCodeOPD = Util.GetInt(StockReports.ExecuteScalar("SELECT ReferenceCodeOPD FROM f_Panel_master WHERE PanelType='Centre' AND CentreID='" + TagProcessingID + "' "));
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL( im.TestCode,'')TestCode,im.TypeName TestName,im.`ItemID`,IFNULL(rt.Rate,0)MRP FROM f_itemmaster im  ");
        sb.Append(" LEFT JOIN f_rateList rt ON rt.ItemID=im.ItemID AND Panel_ID='" + RefrenceCodeOPD + "' AND IsCurrent=1 ");
        sb.Append(" ");
        sb.Append("  WHERE im.isActive=1 AND im.`ItemID`='" + ItemID + "'  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string bindHLMPackageTest(int EnrollID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,PackageName,st.ItemID,PatientRate,ShareType,if(ShareType='Gross','',NetAmount)NetAmount,TestWiseMRP FROM sales_HLMPackage_enrolment st ");
        sb.Append("  ");
        sb.Append(" WHERE st.IsActive=1 AND st.EnrollID='" + EnrollID + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }

    [WebMethod]
    public static string viewHLMPackageTest(int ID, string ItemID)
    {
        string PackageItemID = string.Empty;
        if (ID != 0)
            PackageItemID = StockReports.ExecuteScalar("SELECT ItemID FROM sales_HLMPackage_enrolment WHERE ID='" + ID + "'");
        else
            PackageItemID = ItemID;

        DataTable dt = StockReports.GetDataTable("SELECT IFNULL( im.TestCode,'')TestCode,im.TypeName ItemName,im.`ItemID` FROM f_itemmaster im WHERE im.ItemID IN(" + PackageItemID + ") ");

        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }
}
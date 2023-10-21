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



public partial class Design_Sales_EnrolmentVerification : System.Web.UI.Page
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
                lblEnrollID.Text = Common.Decrypt(Request.QueryString["EnrolID"].ToString());
                lblVerificationType.Text = Common.Decrypt(Request.QueryString["Verified"].ToString());
                bindEnrolment();
            }
            else
            {
                lblEnrollID.Text = string.Empty;
            }
            lblCurrentDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

        }

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

    //here creating function changing1
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

    private void bindEnrolment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT em.Company_Name,em.Add1,em.Phone,em.Mobile,em.Payment_Mode,em.CentreID_Print,em.EmailID,em.EmailIDReport, ");
        sb.Append(" em.ReportDispatchMode,em.MinBusinessCommitment,em.GSTTin,em.InvoiceBillingCycle,em.BankID,em.AccountNo,em.IFSCCode,PanelUserID,PanelPassword, ");
        sb.Append(" TagProcessingLabID,CreditLimit,InvoiceTo,MinBalReceive,ReferenceCodeOPD,MRPPercentage,TypeID,TypeName,PanelGroupID, ");
        sb.Append(" em.BusinessZoneID,em.StateID,em.HeadQuarterID,em.CityID,em.CityZoneID,em.LocalityID,em.AAALogo,em.OnLineLoginRequired, ");
        sb.Append(" em.HLMOPHikeInMRP,em.HLMIPHikeInMRP,em.HLMICUHikeInMRP,em.HLMOPClientShare,em.HLMIPClientShare,em.HLMICUClientShare,IsHLMIP,IsHLMICU,IsHLMOP, ");
        sb.Append(" em.HLMOPPaymentMode,em.HLMOPPatientPayTo,em.HLMIPPaymentMode,em.HLMIPPatientPayTo,em.HLMICUPaymentMode,em.HLMICUPatientPayTo,InvoiceDisplayName,InvoiceDisplayAddress, ");
        sb.Append(" ChequeNo,ChequeDate,ChequeAmt,PanNo,OwnerName ");
        sb.Append(" FROM sales_enrolment_master em   ");
        sb.Append("    ");
        sb.Append(" WHERE em.ID='" + lblEnrollID.Text.Trim() + "' AND em.ISEnroll=0  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {

            lblFileName.Text = Request.QueryString["EnrolID"].ToString();
            lblTypeID.Text = dt.Rows[0]["TypeID"].ToString();
            lblTypeName.Text = dt.Rows[0]["TypeName"].ToString().ToUpper();
            ddlType.Attributes.Add("disabled", "disabled");
            ddlPanelGroup.SelectedIndex = ddlPanelGroup.Items.IndexOf(ddlPanelGroup.Items.FindByValue(dt.Rows[0]["PanelGroupID"].ToString()));
            ddlPanelGroup.Attributes.Add("disabled", "disabled");
            txtPUPName.Text = dt.Rows[0]["Company_Name"].ToString();
            txtAddress.Text = dt.Rows[0]["Add1"].ToString();
            txtLandline.Text = dt.Rows[0]["Phone"].ToString();
            txtMobile.Text = dt.Rows[0]["Mobile"].ToString();



            chkAAALogo.Checked = (Util.GetInt(dt.Rows[0]["AAALogo"].ToString()) > 0) ? true : false;
            chkOnlineLogin.Checked = (Util.GetInt(dt.Rows[0]["OnLineLoginRequired"].ToString()) > 0) ? true : false;
            if (lblTypeName.Text.ToUpper() != "PUP")
            {
                ddlBusinessZone.SelectedIndex = ddlBusinessZone.Items.IndexOf(ddlBusinessZone.Items.FindByValue(dt.Rows[0]["BusinessZoneID"].ToString()));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindState();", true);
                ddlBusinessZone.Attributes.Add("disabled", "disabled");
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
            txtActualMinBusinessComm.Text = dt.Rows[0]["MinBusinessCommitment"].ToString();
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
            txtActualMRPPercentage.Text = dt.Rows[0]["MRPPercentage"].ToString();

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
                    if (lblVerificationType.Text != "Financial")
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
                    if (lblVerificationType.Text != "Financial")
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script1", "getICUPaymentCon();", true);

                }
                else
                {
                    chkHLMICU.Checked = false;
                    txtHLMICUMRP.Text = string.Empty;
                    txtHLMICUClientShare.Text = string.Empty;
                }
                if (lblVerificationType.Text == "Financial")
                {
                    chkHLMOP.Enabled = false;
                    txtHLMOPMRP.Attributes.Add("disabled", "disabled");
                    txtHLMOPClientShare.Attributes.Add("disabled", "disabled");
                    ddlHLMOPPaymentMode.Attributes.Add("disabled", "disabled");
                    rblHLMOPPatientPayTo.Attributes.Add("disabled", "disabled");

                    chkHLMIP.Enabled = false;
                    txtHLMIPMRP.Attributes.Add("disabled", "disabled");
                    txtHLMIPClientShare.Attributes.Add("disabled", "disabled");
                    ddlHLMIPPaymentMode.Attributes.Add("disabled", "disabled");
                    rblHLMIPPatientPayTo.Attributes.Add("disabled", "disabled");

                    chkHLMICU.Enabled = false;
                    txtHLMICUMRP.Attributes.Add("disabled", "disabled");
                    txtHLMICUClientShare.Attributes.Add("disabled", "disabled");
                    ddlHLMICUPaymentMode.Attributes.Add("disabled", "disabled");
                    rblHLMICUPatientPayTo.Attributes.Add("disabled", "disabled");
                }
            }
            else
            {

            }
            txtInvoiceDisplayName.Text = dt.Rows[0]["InvoiceDisplayName"].ToString();
            txtInvoiceDisplayAddress.Text = dt.Rows[0]["InvoiceDisplayAddress"].ToString();

            txtChequeNo.Text = dt.Rows[0]["ChequeNo"].ToString();
            txtChequeDate.Text = dt.Rows[0]["ChequeDate"].ToString();
            txtChequeAmt.Text = dt.Rows[0]["ChequeAmt"].ToString();
            txtPanNo.Text = dt.Rows[0]["PanNo"].ToString();
            txtOwnerName.Text = dt.Rows[0]["OwnerName"].ToString();

            if (dt.Rows[0]["TypeName"].ToString().ToUpper() == "PCC" || dt.Rows[0]["TypeName"].ToString().ToUpper() == "PUP")
                txtMRPPercentage.Attributes.Add("display", "block");
            else
                txtMRPPercentage.Attributes.Add("display", "none");

            if (lblTypeName.Text.ToUpper() != "PUP")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key50", "fillEnrolmentAddress();", true);
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key60", "bindSalesHierarchy();", true);
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
        DataTable dt = StockReports.GetDataTable("SELECT CentreID,Centre,type1,COCO_FOCO FROM centre_master WHERE type1ID NOT IN( '7','8') AND IF(type1ID = '8',COCO_FOCO='COCO', type1ID != '8') AND IsActive=1 ORDER BY Centre");
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

    [WebMethod]
    public static string checkesixts(string companyName, string EnrollID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) from sales_enrolment_master WHERE Company_Name='" + companyName + "' AND ID !='" + EnrollID + "' "));
            if (count > 0)
                return "1";
            else
            {
                count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) from f_panel_master WHERE Company_Name='" + companyName + "' "));
                if (count > 0)
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
        sb.Append(" '' VerifiedDate ");
        sb.Append(" FROM employee_master em INNER JOIN f_designation_msater dm ON em.DesignationID =dm.ID AND dm.IsActive=1 AND dm.IsSales=1 ");
        sb.Append(" WHERE  em.IsActive=1 AND em.IsSalesTeamMember=1 AND em.Employee_ID=@Employee_ID ");
        sb.Append(" ORDER BY dm.sequenceno+0 ASC ");

        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
           new MySqlParameter("@EnrollID", EnrollID.Trim()), new MySqlParameter("@Employee_ID", ReportingEmployeeID)).Tables[0];
    }

    [WebMethod]
    public static string bindSalesHierarchy(string EnrollID)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT dm.ID DesignationID,dm.IsDirectApprove,dm.Name DesignationName, em.Employee_ID,CONCAT(em.Title,' ',em.NAME)EmpName, ");
        sb.Append(" em.Reporting_Employee_ID ReportingEmployeeID,dm.SequenceNo,IF(IsVerified=1,'Yes','')IsVerified,  ");
        sb.Append(" IF(IsVerified=1,DATE_FORMAT(VerifiedDate,'%d-%b-%Y'),'')VerifiedDate,IF(IsApproved=1,'Yes','')IsApproved, ");
        sb.Append(" IF(IsApproved=1,DATE_FORMAT(ApprovedDate,'%d-%b-%Y'),'')ApprovedDate,DATE_FORMAT(se.CreatedDate,'%d-%b-%Y')CreatedDate ");
        sb.Append(" FROM employee_master em INNER JOIN f_designation_msater dm ON em.DesignationID =dm.ID AND dm.IsActive=1 AND dm.IsSales=1 ");
        sb.Append(" INNER JOIN sales_employee_centre se ON se.EmployeeID=em.Employee_ID AND se.IsActive=1  AND  se.EnrollID='" + EnrollID + "' ");
        sb.Append(" WHERE  em.IsActive=1 AND em.IsSalesTeamMember=1 ");
        sb.Append(" ORDER BY dm.sequenceno+0 DESC ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Util.getJson(dt);



    }

    [WebMethod]
    public static string bindSpecialTest(string type, int designationID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.TestCode,im.TypeName TestName,im.ItemID,st.TestRate,'' Rate,'0' IsCheck FROM f_itemmaster im INNER JOIN  sales_special_testlimit_amount  st ON im.ItemID=st.SpecialTestID ");
        sb.Append(" WHERE st.IsActive=1 AND st.EntryType=@EntryType AND SalesID=@SalesID");

        DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, sb.ToString(),
           new MySqlParameter("@EntryType", type.ToUpper()), new MySqlParameter("@SalesID", designationID)).Tables[0];

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
    public static string bindEnrollSpecialTest(string type, int EnrolID)
    {
        StringBuilder sb = new StringBuilder();
        if (type.ToUpper() == "PUP")
        {
            //sb.Append(" SELECT im.TestCode,im.TypeName TestName,im.ItemID,IFNULL(se.SpecialTestRate,'')TestRate,IF(IFNULL(se.ID,'')='',st.testRate,  IFNULL(se.Rate,''))Rate,IF((IFNULL(se.ID,'') AND se.Rate<>0)='','0','1')IsCheck,IFNULL(IsNewTest ,0)IsNewTest, 0 MinimumSales,0 SalesDuration,0 IntimationDays,0 TotalValue,HLMPrice  ");
            //sb.Append(" FROM f_itemmaster im INNER JOIN  sales_special_testlimit_amount  st ON im.ItemID=st.SpecialTestID ");
            //sb.Append(" LEFT JOIN sales_specialtest_enrolment se ON se.SpecialTestID=st.SpecialTestID AND se.IsActive=1 AND se.EnrollID='" + EnrolID + "' AND se.IsNewTest=0 ");
            //sb.Append(" WHERE st.IsActive=1 AND st.EntryType='" + type.ToUpper() + "'   ");
            //sb.Append(" UNION ALL ");
            sb.Append(" SELECT im.TestCode,im.TypeName TestName,im.ItemID,se.SpecialTestRate TestRate,se.Rate,IF(IFNULL(se.ID,'')='','0','1')IsCheck,IsNewTest,IFNULL(MinimumSales,0)MinimumSales, ");
            sb.Append(" IFNULL(SalesDuration,0)SalesDuration,IFNULL(IntimationDays,0)IntimationDays ,(IFNULL(se.SpecialTestRate,0)*IFNULL(MinimumSales,0))TotalValue,HLMPrice   ");
            sb.Append(" FROM f_itemmaster im  ");
            sb.Append(" INNER JOIN sales_specialtest_enrolment se ON se.SpecialTestID=im.ItemID AND se.IsActive=1 ");
            sb.Append(" AND se.EnrollID='" + EnrolID + "' ORDER BY se.Priority+0   ");
        }
        else
        {
            sb.Append(" SELECT im.TestCode,im.TypeName TestName,im.ItemID,se.SpecialTestRate TestRate,IFNULL(se.Rate,'')Rate,1 IsCheck,");
            sb.Append(" IsNewTest,IFNULL(MinimumSales,0)MinimumSales,IFNULL(SalesDuration,0)SalesDuration,IFNULL(IntimationDays,0)IntimationDays,");
            sb.Append(" (IFNULL(se.SpecialTestRate,0)*IFNULL(MinimumSales,0)) TotalValue,HLMPrice     ");
            sb.Append(" FROM f_itemmaster im  ");
            sb.Append(" INNER JOIN sales_specialtest_enrolment se ON se.SpecialTestID=im.ItemID  ");
            sb.Append(" WHERE se.IsActive=1 AND se.IsNewTest=1 AND IsPccGroup=0 AND se.EnrollID='" + EnrolID + "' ORDER BY se.Priority+0 ");
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
        string TestLimitCount = StockReports.ExecuteScalar("SELECT TestLimit FROM sales_special_testlimit_count WHERE SalesID='" + designationID + "' AND BusinessCommitment<='" + BusinessCommitment + "' AND IsActive=1 AND EntryType='" + EntryType.ToUpper() + "'");

        return TestLimitCount;
    }

    [WebMethod(EnableSession = true)]
    public static string approveEnrolment(object Panel, object Employee, object TestEnrolment, object PCCGrouping, object MarketingCampaignTest, object HLMPackage, string Reason)
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
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT count(*) from sales_enrolment_master WHERE Company_Name='" + Enrolment[0].Company_Name.Trim() + "' AND ID!='" + Enrolment[0].EnrollID + "'"));
            if (count > 0)
                return "2";

            count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from sales_enrolment_master WHERE ID=@EnrollID AND IsEnroll=1 ",
                          new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)));
            if (count > 0)
            {
                return "Enrolment Already Enrol";
            }
            if (Enrolment[0].TypeName.ToUpper() == "PUP")
            {
                count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from sales_enrolment_master WHERE Mobile=@Mobile AND ID!=@EnrollID",
                            new MySqlParameter("@Mobile", Enrolment[0].Mobile), new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)));
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
            else  if (Enrolment[0].TypeName.ToUpper() == "PCC")
            {
                count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from Sales_document WHERE EnrollID=@EnrollID AND DocumentID=14",
                           new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)));
                if (count == 0)
                {
                    return "Please Upload Cancel Cheque";
                }
            }
            else if (Enrolment[0].TypeName.ToUpper() == "HLM")
            {
                count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from Sales_document WHERE EnrollID=@EnrollID AND DocumentID=19",
                           new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)));
                if (count == 0)
                {
                    return "Please Upload 3 Month Business";
                }
                count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from Sales_document WHERE EnrollID=@EnrollID AND DocumentID=18",
                           new MySqlParameter("@EnrollID", Enrolment[0].EnrollID)));
                if (count == 0)
                {
                    return "Please Upload HLM Agreement";
                }
            }
            
                // bool hasIsVerified = SpecialTestEnrolment.Any(cus => cus.IsVerified == 1);

                int IsVerified = 1; string VerifiedDateTime = "0001-01-01 00:00:00"; int IsSales = 0; int IsFinance = 0;
                int IsApproved = 0; 

                //1 Verify 2 Approve
                if (Enrolment[0].IsApprove == 1)
                {
                    IsApproved = 0;
                    VerifiedDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                    
                    
                }
                else
                {
                    IsApproved = 1;
                    VerifiedDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                    
                }

                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE sales_enrolment_master SET Company_Name=@Company_Name,Add1=@Add1,Mobile=@Mobile,Phone=@Phone,Payment_Mode=@Payment_Mode,CentreID_Print=@CentreID_Print,");
                sb.Append(" EmailID=@EmailID,EmailIDReport=@EmailIDReport,MinBusinessCommitment=@MinBusinessCommitment,GSTTin=@GSTTin,InvoiceBillingCycle=@InvoiceBillingCycle,");
                sb.Append(" BankID=@BankID,BankName=@BankName,AccountNo=@AccountNo,IFSCCode=@IFSCCode,TagProcessingLabID=@TagProcessingLabID,TagProcessingLab=@TagProcessingLab,InvoiceTo=@InvoiceTo,");
                sb.Append(" PanelUserID=@PanelUserID,PanelPassword=@PanelPassword,ReportDispatchMode=@ReportDispatchMode,CreditLimit=@CreditLimit,MinBalReceive=@MinBalReceive,ReferenceCodeOPD=@ReferenceCodeOPD,");
                sb.Append(" PanelGroup=@PanelGroup,PanelGroupID=@PanelGroupID,MRPPercentage=@MRPPercentage,");
                if (Enrolment[0].VerificationType == "Sales")
                    sb.Append(" IsSalesApproved=@IsSalesApproved,SalesApprovedDateTime=@SalesApprovedDateTime,SalesApprovedByID=@SalesApprovedByID ");
                else
                    sb.Append(" IsFinancialApproved=@IsFinancialApproved,FinancialApprovedDateTime=@FinancialApprovedDateTime,FinancialApprovedByID=@FinancialApprovedByID ");

                sb.Append(" ,IsApproved=@IsApproved,BusinessZoneID=@BusinessZoneID,StateID=@StateID,CityID=@CityID,CityZoneID=@CityZoneID,LocalityID=@LocalityID,HeadQuarterID=@HeadQuarterID,AAALogo=@AAALogo,OnLineLoginRequired=@OnLineLoginRequired ,");
                sb.Append("HLMOPHikeInMRP=@HLMOPHikeInMRP,HLMIPHikeInMRP=@HLMIPHikeInMRP,HLMICUHikeInMRP=@HLMICUHikeInMRP,HLMOPClientShare=@HLMOPClientShare,HLMIPClientShare=@HLMIPClientShare,HLMICUClientShare=@HLMICUClientShare,  ");
                sb.Append(" IsHLMOP=@IsHLMOP,IsHLMIP=@IsHLMIP,IsHLMICU=@IsHLMICU,HLMOPPaymentMode=@HLMOPPaymentMode,HLMOPPatientPayTo=@HLMOPPatientPayTo, ");
                sb.Append(" HLMIPPaymentMode=@HLMIPPaymentMode,HLMIPPatientPayTo=@HLMIPPatientPayTo,HLMICUPaymentMode=@HLMICUPaymentMode,HLMICUPatientPayTo=@HLMICUPatientPayTo, ");
                sb.Append(" InvoiceDisplayName=@InvoiceDisplayName,InvoiceDisplayAddress=@InvoiceDisplayAddress, ");
                sb.Append(" ChequeNo=@ChequeNo,ChequeDate=@ChequeDate,ChequeAmt=@ChequeAmt,PanNo=@PanNo,OwnerName=@OwnerName");
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

                if (Enrolment[0].VerificationType == "Sales")
                {
                    cmd.Parameters.AddWithValue("@IsSalesApproved", IsApproved);
                    cmd.Parameters.AddWithValue("@SalesApprovedDateTime", VerifiedDateTime);
                    cmd.Parameters.AddWithValue("@SalesApprovedByID",UserInfo.ID );
                    IsSales = 1;
                }
                else
                {
                    cmd.Parameters.AddWithValue("@IsFinancialApproved", IsApproved);
                    cmd.Parameters.AddWithValue("@FinancialApprovedDateTime", VerifiedDateTime);
                    cmd.Parameters.AddWithValue("@FinancialApprovedByID", UserInfo.ID);
                    IsFinance = 1;
                }

                cmd.Parameters.AddWithValue("@IsApproved", IsApproved);
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

                cmd.Parameters.AddWithValue("@ChequeNo", Enrolment[0].ChequeNo);
            
                cmd.Parameters.AddWithValue("@ChequeDate", Util.GetDateTime(Enrolment[0].ChequeDate).ToString("yyyy-MM-dd"));
                cmd.Parameters.AddWithValue("@ChequeAmt", Enrolment[0].ChequeAmt);
                cmd.Parameters.AddWithValue("@PanNo", Enrolment[0].PanNo);
                cmd.Parameters.AddWithValue("@OwnerName", Enrolment[0].OwnerName);
                cmd.ExecuteNonQuery();
                cmd.Dispose();

                List<int> testEnroll = new List<int>();

                DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT SpecialTestID FROM sales_SpecialTest_Enrolment WHERE EnrollID=@EnrollID",
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
                    else
                    {
                        for (int k = 0; k < PCCTestGrouping.Count; k++)
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO sales_PCCGrouping_Enrolment(EnrollID,GroupID,PCCGroupSharePer,CreatedBy,CreatedByID)VALUES(@EnrollID,@GroupID,@PCCGroupSharePer,@CreatedBy,@CreatedByID)",
                                new MySqlParameter("@EnrollID", Enrolment[0].EnrollID), new MySqlParameter("@GroupID", PCCTestGrouping[k].GroupID), new MySqlParameter("@PCCGroupSharePer", PCCTestGrouping[k].GroupShare),
                                new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID)
                                );
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

                //1 Verify 2 Approve

                if (Enrolment[0].IsApprove == 1)
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE sales_Employee_centre SET  IsApproved=@IsApproved,ApprovedDate=@ApprovedDate");
                    sb.Append("  WHERE  EnrollID=@EnrollID  ");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@IsApproved", "0"), new MySqlParameter("@ApprovedDate", "0001-01-01 00:00:00"),
                    new MySqlParameter("@EnrollID", Enrolment[0].EnrollID), new MySqlParameter("@EmployeeID", Enrolment[0].EmployeeID));

                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO  sales_enrolment_verification(EnrolID,CreatedBy,CreatedByID,IsSales,IsFinance,Reason) ");
                    sb.Append("  VALUES(@EnrolID,@CreatedBy,@CreatedByID,@IsSales,@IsFinance,@Reason)  ");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@EnrolID", Enrolment[0].EnrollID), new MySqlParameter("@IsSales", IsSales),
                        new MySqlParameter("@IsFinance",IsFinance),new MySqlParameter("@Reason",Reason),
                    new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID)
                    );

                    
                }
                //else
                //{
                //    sb = new StringBuilder();
                //    sb.Append(" UPDATE sales_Employee_centre SET IsApproved=@IsApproved,ApprovedDate=@ApprovedDate ");
                //    sb.Append("  WHERE  EnrollID=@EnrollID AND EmployeeID=@EmployeeID ");

                //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                //    new MySqlParameter("@IsApproved", IsApproved), new MySqlParameter("@ApprovedDate", DateTime.Now),
                //    new MySqlParameter("@EnrollID", Enrolment[0].EnrollID), new MySqlParameter("@EmployeeID", Enrolment[0].EmployeeID));
                //}
                //if (Enrolment[0].IsApprove == 2)
                //{
                //    sb = new StringBuilder();
                //    sb.Append(" UPDATE sales_enrolment_master SET IsApproved=@IsApproved,ApprovedDate=@ApprovedDate,ApprovalPendingBy=@ApprovalPendingBy WHERE ID=@ID ");
                //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                //    new MySqlParameter("@IsApproved", "1"), new MySqlParameter("@ApprovedDate", DateTime.Now), new MySqlParameter("@ApprovalPendingBy", "0"),
                //    new MySqlParameter("@ID", Enrolment[0].EnrollID));
                //}
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO sales_Admin_Verification(EnrollID,VerifiedBy,VerifiedByID,VerificationType)VALUES(@EnrollID,@VerifiedBy,@VerifiedByID,@VerificationType)",
                    new MySqlParameter("@EnrollID", Enrolment[0].EnrollID), new MySqlParameter("@VerifiedBy", UserInfo.LoginName),
                    new MySqlParameter("@VerifiedByID", UserInfo.ID), new MySqlParameter("@VerificationType", Enrolment[0].VerificationType));


                if (Enrolment[0].TypeName.ToUpper() == "PCC")
                {
                    List<int> PCCTestCamItemID = new List<int>();

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
            //here for approval and varified changing2
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

    [WebMethod]
    public static string getItemMaster(string ItemID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT IFNULL( im.TestCode,'')TestCode,im.TypeName TestName,im.`ItemID` FROM f_itemmaster im  WHERE im.isActive=1 AND im.`ItemID`='" + ItemID + "' ");
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
        int EnrollID { get; set; }
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


        DataTable type = StockReports.GetDataTable("SELECT BusinessZoneID,BusinessZoneName FROM BusinessZone_master bm WHERE IsActive=1 ");

        ddlBusinessZone.DataSource = type;
        ddlBusinessZone.DataValueField = "BusinessZoneID";
        ddlBusinessZone.DataTextField = "BusinessZoneName";
        ddlBusinessZone.DataBind();
        ddlBusinessZone.Items.Insert(0, new ListItem("Select", "0"));

    }

    [WebMethod]
    public static string bindState(int BusinessZoneID)
    {

        DataTable type = StockReports.GetDataTable("SELECT DISTINCT(sm.ID)ID,sm.State FROM state_master sm WHERE sm.IsActive=1 AND  sm.BusinessZoneID ='" + BusinessZoneID + "'   ");

        return Util.getJson(type);

    }

    [WebMethod]
    public static string bindHeadQuarter(int StateID)
    {

        DataTable type = StockReports.GetDataTable(" SELECT DISTINCT(hm.ID)ID,hm.HeadQuarter FROM headquarter_master hm WHERE hm.IsActive=1 AND  hm.StateID ='" + StateID + "'  ORDER BY hm.HeadQuarter  ");

        return Util.getJson(type);
    }

    [WebMethod]
    public static string bindCityByHeadQuarter(int HeadQuarterID)
    {

        DataTable type = StockReports.GetDataTable("SELECT DISTINCT(cm.ID)ID,cm.City FROM city_master cm WHERE  cm.IsActive=1  AND cm.HeadQuarterID='" + HeadQuarterID + "'  ORDER BY cm.City ");

        return Util.getJson(type);
    }

    [WebMethod]
    public static string bindZone(int CityID)
    {

        DataTable type = StockReports.GetDataTable("SELECT DISTINCT(cz.ZoneID)ZoneID,cz.Zone FROM centre_zonemaster cz WHERE cz.IsActive=1  AND cz.CityID='" + CityID + "' ORDER BY cz.Zone ");

        return Util.getJson(type);
    }

    [WebMethod]
    public static string bindLocalityByZone(int ZoneID)
    {

        DataTable type = StockReports.GetDataTable(" SELECT DISTINCT(lo.ID)ID,lo.NAME FROM f_locality lo WHERE lo.Active=1 AND lo.ZoneID='" + ZoneID + "' ORDER BY lo.NAME ");

        return Util.getJson(type);
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
    public static string UnApproveFinance(int EnrollID, string UnApproveReason)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from sales_enrolment_master WHERE ID=@EnrollID AND IsFinancialApproved=1 ",
                               new MySqlParameter("@EnrollID", EnrollID)));
            if (count > 0)
                return "1";
            count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) from sales_enrolment_master WHERE ID=@EnrollID AND ISEnroll=1 ",
                               new MySqlParameter("@EnrollID", EnrollID)));
            if (count > 0)
                return "2";
            
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text," UPDATE sales_enrolment_master SET  IsSalesApproved=@IsSalesApproved,SalesApprovedByID=@SalesApprovedByID,SalesApprovedDateTime=@SalesApprovedDateTime WHERE ID=@EnrollID",
                        new MySqlParameter("@EnrollID", EnrollID), new MySqlParameter("@IsSalesApproved", "0"),
                        new MySqlParameter("@SalesApprovedByID", "0"), new MySqlParameter("@SalesApprovedDateTime", "0001-01-01 00:00:00"));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO sales_Finance_Unapproval(EnrollID,UnApprovedByID,UnApprovedBy,Reason)VALUES(@EnrollID,@UnApprovedByID,@UnApprovedBy,@Reason)",
                new MySqlParameter("@EnrollID", EnrollID), new MySqlParameter("@UnApprovedByID", UserInfo.ID), new MySqlParameter("@UnApprovedBy", UserInfo.LoginName),
                new MySqlParameter("@Reason", UnApproveReason));
            tnx.Commit();
            return "3";
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